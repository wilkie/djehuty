/*
 * stream.d
 *
 * This module implements a stream.
 *
 */

module core.stream;

import core.definitions;
import core.string;

// TODO: allow ENORMOUS ARRAYS gracefully (> 4GB... switch to a Map)
// TODO: Read and Write distinction, stream permissions

// Section: Enums

// Description: This enum gives a description of the current stream processing progress for any function that receives its information via a stream.
enum StreamData : int {
	// Description: The stream is invalid.  The primarly reason is that the stream does not represent the expected semantics of the data.  For instance, you gave a BMP file to the PNG decoder, the PNG header would not be present and the stream would be marked invalid.
	Invalid = -1,

	// Description: The stream is so far valid, and has been partially processed.  The function requires further data to complete.
	Required,

	// Description: The stream was used and a piece of information has been processed successfully.  There are more units to decode with further calls.  (A frame of animation or a sample of audio are examples)
	Accepted,

	// Description: The stream was used and all information was successfully decoded.
	Complete,
}

// Description: This enum gives the possible permission types of the stream.

// As you can see, individual bits indicate access type: read - 1, update - 2, append - 4, allocate - 8
enum StreamAccess : int {
	// Description: The stream allows no access to data.
	NoAccess = 0,

	// Description: The stream allows for reading.
	Read = 1,

	// Description: The stream allows for updating the contents, but not reading what was already there.  You cannot also change the size of the buffer.
	Update = 2,

	// Description: The stream allows for reading and updating. One cannot change the size of the stream.
	ReadUpdate = 3,

	// Description: The stream does not allow reading. The stream allows for writing past the end bounds of the buffer and allows for changing the internal memory capacity of the buffer.
	Append = 14,

	// Description: The stream does not allow reading. The stream allows for writing past the end bounds of the buffer, but one is confined to the memory capacity of the buffer at creation.
	AppendFixed = 6,

	// Description: The stream allows for all accesses, but the buffer is confined to use only as much memory as was originally allocated for it.
	AllFixed = 7,

	// Description: The stream allows all access.
	AllAccess = 15,
}

// Section: Core/Streams

// Description: A stream class!
// Feature: Provides a nice interface to any read, write, and append operation on any type of input output device.
class Stream {
public:

	// Description: This will create the stream using a default capacity.
	this() {
		_data = new ubyte[cast(uint)_capacity];
		_pos = &_data[0];
	}

	// Description: This will create the stream using the capacity given by the parameter.
	// size: The default size of the stream, which will be allocated immediately.
	this(ulong size) {
		_capacity = size;

		this();
	}

	this(ubyte[] fromArray) {
		_capacity = fromArray.length;
		_length = fromArray.length;

		_data = fromArray;

		_pos = &_data[0];
	}

	// Methods //

	// Description: This will zero out the entire contents of the stream.
	void zero() {
		_data[0..$] = 0;
	}

	// Description: This will shrink the stream back to the default size and invalidate the contents. You will need allocation and write permissions.  If you do not have allocation permissions, this will simply perform the operations of zero().
	void clear() {
		_capacity = 100000;
		_data = new ubyte[cast(uint)_capacity];

		_pos = &_data[0];
		_curpos = 0;

		_length = 0;
	}

	// Description: Will resize the Stream.
	// Returns: Will return true when the Stream can be resized to this amount.
	// newLength: the new length of the stream
	bool resize(ulong newLength) {
		if (newLength == 0) {
			_length = 0;
			_curpos = 0;
			_data = new ubyte[100];
			_pos = _data.ptr;
			_capacity = 100;
			return true;
		}

		ubyte tmp[] = new ubyte[cast(uint)newLength];

		if (newLength > _length) {
			tmp[0..cast(uint)_length] = _data[0..cast(uint)_length];
		}
		else {
			tmp[0..cast(uint)newLength] = _data[0..cast(uint)newLength];
		}

		_length = newLength;

		// Setup the new position
		if (_curpos > newLength) { _curpos = newLength; }

		// Rereference the new array
		_data = tmp;

		// Index like this to avoid index out of bounds errors:
		_pos = &_data[0] + _curpos;

		// the capacity is now the length
		// resize() fits the array
		_capacity = _length;

		return true;
	}

	// Description: This function will append the buffer passed in with the length given to the end of the current stream.
	// bytes: The buffer with the data to be appended.
	// len: The number of bytes to append.
	// Returns: Will return true when the data could be successfully written and false when the data could not all be read.
	bool append(ubyte* bytes, uint len) {
		if (len <= 0) { return false;}

		while (_length + len > _capacity) {
			resize();	// Size!
		}

		_data[cast(uint)_length..cast(uint)_length+len] = bytes[0..len];

		_length += len;
		return true;
	}

	// Description: This function will append len bytes from the stream passed to the end of the current stream.
	// stream: The stream to append from.
	// len: The number of bytes to stream.
	// Returns: Will return true when the data could be successfully written and false when the data could not all be read.
	bool append(Stream stream, uint len) {
		if (len <= 0) { return false;}

		while (_length + len > _capacity) {
			resize();	// Size!
		}

		if (!stream.read(&_data[cast(uint)_length], len)) {
			return false;
		}

		//writeln("append: ", _data[_length.._length+len]);

		_length += len;
		return true;
	}

	// Description: This function will append len bytes from the stream passed to the end of the current stream.
	// stream: The stream to append from.
	// len: The number of bytes to stream.
	// Returns: Will return true when the data could be successfully written and false when the data could not all be read.
	ulong appendAny(Stream stream, uint len) {
		if (len <= 0) { return 0;}

		while (_length + len > _capacity) {
			resize();	// Size!
		}

		len = cast(uint)stream.readAny(&_data[cast(uint)_length], len);

		//writeln("append: ", _data[_length.._length+len]);

		_length += len;
		return len;
	}

	// Description: This function will write len bytes from the buffer passed to the current location in the stream.  It will then progress this stream to the end of the written data.
	// bytes: The buffer to write from.
	// len: The number of bytes to write.
	// Returns: Will return true when the data could be successfully written and false when the data could not all be read.
	bool write(ubyte* bytes, uint len) {
		if (len <= 0) { return false;}

		while (_curpos + len > _capacity) {
			resize();	// Size!
		}

		_pos[0..len] = bytes[0..len];

		_curpos += len;
		_pos += len;

		if (_curpos > _length) { _length = _curpos; }
		return true;
	}

	// Description: This function will write len bytes from the stream passed to the current location in the stream.  It will then progress this stream to the end of the written data and also progress the stream which was read to the end of the read data.
	// bytes: The buffer to write from.
	// len: The number of bytes to write.
	// Returns: Will return true when the data could be successfully written and false when the data could not all be read.
	bool write(Stream stream, uint len) {
		if (len <= 0) { return false;}

		while (_curpos + len > _capacity) {
			resize();	// Size!
		}

		stream.read(_pos, len);

		_curpos += len;
		_pos += len;

		if (_curpos > _length) { _length = _curpos; }
		return true;
	}

	// Description: This function will write len bytes from the stream passed to the current location in the stream.  It will then progress this stream to the end of the written data and also progress the stream which was read to the end of the read data.
	// bytes: The buffer to write from.
	// len: The number of bytes to write.
	// Returns: Will return true when the data could be successfully written and false when the data could not all be read.
	ulong writeAny(Stream stream, uint len) {
		if (len <= 0) { return false;}

		while (_curpos + len > _capacity) {
			resize();	// Size!
		}

		len = cast(uint)stream.readAny(_pos, len);

		if ((_curpos + len) > _length) {
			// cannot append
			// TODO: throw permission exception
			return 0;
		}

		_curpos += len;
		_pos += len;

		if (_curpos > _length) { _length = _curpos; }
		return len;
	}

	// Description: This function will write the ubyte passed to the end of the current stream.
	// value: A ubyte to append.
	// Returns: Will return true when the data could be successfully written and false when the data could not.
	bool append(ubyte value) {
		return append(&value, 1);
	}

	// Description: This function will write the ubyte passed to the current position of the current stream and progress this stream the amount written.
	// value: A ubyte to append.
	// Returns: Will return true when the data could be successfully written and false when the data could not.
	bool write(ubyte value) {
		return write(&value, 1);
	}

	// Description: This function will write the byte passed to the end of the current stream.
	// value: A byte to append.
	// Returns: Will return true when the data could be successfully written and false when the data could not.
	bool append(byte value) {
		return append(cast(ubyte*)&value, 1);
	}

	// Description: This function will write the byte passed to the current position of the current stream and progress this stream the amount written.
	// value: A byte to append.
	// Returns: Will return true when the data could be successfully written and false when the data could not.
	bool write(byte value) {
		return write(cast(ubyte*)&value, 1);
	}

	// Description: This function will write the ushort passed to the end of the current stream.
	// value: A ushort to append.
	// Returns: Will return true when the data could be successfully written and false when the data could not.
	bool append(ushort value) {
		return append(cast(ubyte*)&value, 2);
	}

	// Description: This function will write the ushort passed to the current position of the current stream and progress this stream the amount written.
	// value: A ushort to append.
	// Returns: Will return true when the data could be successfully written and false when the data could not.
	bool write(ushort value) {
		return write(cast(ubyte*)&value, 2);
	}

	// Description: This function will write the short passed to the end of the current stream.
	// value: A ushort to append.
	// Returns: Will return true when the data could be successfully written and false when the data could not.
	bool append(short value) {
		return append(cast(ubyte*)&value, 2);
	}

	// Description: This function will write the ushort passed to the current position of the current stream and progress this stream the amount written.
	// value: A short to append.
	// Returns: Will return true when the data could be successfully written and false when the data could not.
	bool write(short value) {
		return write(cast(ubyte*)&value, 2);
	}

	// Description: This function will write the uint passed to the end of the current stream.
	// value: A uint to append.
	// Returns: Will return true when the data could be successfully written and false when the data could not.
	bool append(uint value) {
		return append(cast(ubyte*)&value, 4);
	}

	// Description: This function will write the uint passed to the current position of the current stream and progress this stream the amount written.
	// value: A uint to append.
	// Returns: Will return true when the data could be successfully written and false when the data could not.
	bool write(uint value) {
		return write(cast(ubyte*)&value, 4);
	}

	// Description: This function will write the uint passed to the end of the current stream.
	// value: A uint to append.
	// Returns: Will return true when the data could be successfully written and false when the data could not.
	bool append(int value) {
		return append(cast(ubyte*)&value, 4);
	}

	// Description: This function will write the int passed to the current position of the current stream and progress this stream the amount written.
	// value: A int to append.
	// Returns: Will return true when the data could be successfully written and false when the data could not.
	bool write(int value) {
		return write(cast(ubyte*)&value, 4);
	}

	// Description: This function will write the ulong passed to the end of the current stream.
	// value: A ulong to append.
	// Returns: Will return true when the data could be successfully written and false when the data could not.
	bool append(ulong value) {
		return append(cast(ubyte*)&value, 8);
	}

	// Description: This function will write the ulong passed to the current position of the current stream and progress this stream the amount written.
	// value: A ulong to append.
	// Returns: Will return true when the data could be successfully written and false when the data could not.
	bool write(ulong value) {
		return write(cast(ubyte*)&value, 8);
	}

	// Description: This function will write the long passed to the end of the current stream.
	// value: A long to append.
	// Returns: Will return true when the data could be successfully written and false when the data could not.
	bool append(long value) {
		return append(cast(ubyte*)&value, 8);
	}

	// Description: This function will write the long passed to the current position of the current stream and progress this stream the amount written.
	// value: A long to append.
	// Returns: Will return true when the data could be successfully written and false when the data could not.
	bool write(long value) {
		return write(cast(ubyte*)&value, 8);
	}

	bool append(char[] str) {
		return append(cast(ubyte*)str.ptr, char.sizeof * str.length);
	}

	bool writeUtf8(char[] str) {
		return write(cast(ubyte*)str.ptr, char.sizeof * str.length);
	}

	bool write(char[] str) {
		return write(cast(ubyte*)str.ptr, char.sizeof * str.length);
	}

	bool append(wchar[] str) {
		return append(cast(ubyte*)str.ptr, wchar.sizeof * str.length);
	}

	bool write(wchar[] str) {
		return write(cast(ubyte*)str.ptr, wchar.sizeof * str.length);
	}

	bool append(dchar[] str) {
		return append(cast(ubyte*)str.ptr, dchar.sizeof * str.length);
	}

	bool write(dchar[] str) {
		return write(cast(ubyte*)str.ptr, dchar.sizeof * str.length);
	}

	bool append(String str) {
		return append(str.array);
	}

	bool write(String str) {
		return write(str.array);
	}

	// Description: This function places the last bytes of information into the front and sets the pointer to end of the information after it is moved.
	void flush() {
	}

	StreamAccess permissions() {
		//return permissions;
		return StreamAccess.AllAccess;
	}

	// Description: This function will return the amount of data remaining in the stream from the current position.
	// Returns: The number of bytes remaining in the stream.
	ulong remaining() {
		return _length - _curpos;
	}

	// Description: This function will return the current length of the stream.
	// Returns: The total number of bytes of this stream.
	ulong length() {
		return _length;
	}

	// Description: This function will return the current position of the stream.
	// Returns: The current byte of the stream.
	ulong position() {
		return _curpos;
	}

	ulong position(ulong newPosition) {
		if (position > newPosition) {
			// need to rewind
			ulong amt = position - newPosition;
			rewind(amt);
		}
		else {
			// need to skip
			ulong amt = newPosition - position;
			skip(amt);
		}

		return position;
	}

	// Description: This function will rewind the current position to the very beginning of the stream's buffer.
	void rewind() {
		// set to start
		_pos = &_data[0];
		_curpos = 0;
	}

	// Description: This function will rewind the current position the amount given if possible.
	// amount: The number of bytes to rewind.
	// Returns: Will return false if the stream cannot be rewound by that amount and true if the operation is successful.
	bool rewind(ulong amount) {
		if (_curpos - amount < 0) {
			return false;
		}

		_curpos -= amount;
		_pos -= amount;

		return true;
	}

	// Description: This function will rewind the current position the amount given or simply move to the beginning.
	// amount: The number of bytes to rewind.
	// Returns: Will return the number of bytes rewound successfully.  This could be less than 'amount' if the stream's current position was less than amount.  In this case, it has rewound to the very beginning and was analogous to the simple rewind() call.
	ulong rewindAny(ulong amount) {
		if (_curpos - amount < 0) {
			amount = _curpos;
		}

		_curpos -= amount;
		_pos -= amount;

		return amount;
	}

	// Description: This function will read from the current stream the number of bytes given by len into the buffer passed.
	// len: The number of bytes to read from this stream.
	// buffer: The buffer into which the data will be copied.
	// Returns: Will return true when the stream has copied successfully all data and false when there is not enough data to complete the operation.
	bool read(void* buffer, uint len) {
		if (_curpos + len > _length) {
			return false;
		}

		(cast(ubyte*)buffer)[0..len] = _pos[0..len];

		_curpos += len;
		_pos += len;

		return true;
	}

	// Description: This function will read from the current stream the number of bytes given by len into the current position of the stream passed.  It will then, on success, progress the current positions of both streams.  On failure, no positions will change.
	// len: The number of bytes to read from this stream.
	// stream: The stream into which the data will be copied.
	// Returns: Will return true when the stream has copied successfully all data and false when there is not enough data to complete the operation.
	bool read(Stream stream, uint len) {
		if (_curpos + len > _length) {
			return false;
		}

		stream.write(_pos, len);

		_curpos += len;
		_pos += len;

		return true;
	}

	/* // Description: This function will read from the current stream the number of bytes given by len into the end of the stream passed.  It will then, on success, progress the current position of the source stream. On failure, no positions will change.
	// len: The number of bytes to read from this stream.
	// stream: The stream into which the data will be copied.
	// Returns: Will return true when the stream has copied successfully all data and false when there is not enough data to complete the operation.
	bool readAndAppend(Stream stream, uint len)
	{
		if (_curpos + len > _length)
		{
			return false;
		}

		stream.append(_pos, len);

		_curpos += len;
		_pos += len;

		return true;
	} */;

	// Description: This function will read from the current stream the number of bytes given by len or all of the remaining bytes into the buffer passed.  It will then progress the current position of the source stream.
	// len: The number of bytes to read from this stream.
	// stream: The buffer into which the data will be copied.
	// Returns: Will return the number of bytes successfully copied.  This will be less than len when the stream does not have len bytes left in its buffer.
	ulong readAny(void* buffer, uint len) {
		if (_curpos + len > _length) {
			len = cast(uint)(_length - _curpos);
		}

		if (len == 0) { return 0; }

		(cast(ubyte*)buffer)[0..len] = _pos[0..len];
		return len;
	}

	// Description: This function will read from the current stream the number of bytes given by len or all of the remaining bytes at the current position of the stream passed.  It will then progress the current positions of the streams.
	// len: The number of bytes to read from this stream.
	// stream: The stream into which the data will be copied.
	// Returns: Will return the number of bytes successfully copied.  This will be less than len when the stream does not have len bytes left in its buffer.
	ulong readAny(Stream stream, uint len) {
		if (_curpos + len > _length) {
			len = cast(uint)(_length - _curpos);
		}

		if (len == 0) { return 0; }

		stream.write(_pos, len);
		return len;
	}

	/* // Description: This function will read from the current stream the number of bytes given by len or all of the remaining bytes to the end of the stream passed.  It will then progress the current position of the source stream.
	// len: The number of bytes to read from this stream.
	// stream: The stream into which the data will be copied.
	// Returns: Will return the number of bytes successfully copied.  This will be less than len when the stream does not have len bytes left in its buffer.
	ulong readAvailableAndAppend(Stream stream, uint len)
	{
		if (_curpos + len > _length)
		{
			len = cast(uint)(_length - _curpos);
		}

		if (len <= 0) { return 0; }

		stream.append(_pos, len);
		return len;
	} */;

	// Description: This function will read in a ubyte from the current stream and progress the current position upon success.
	// toByte: a ubyte to be manipulated.
	// Returns: Will return true upon success and false when the Stream does not have enough data.
	bool read(out ubyte toByte) {
		return read(&toByte, 1);
	}

	// Description: This function will read in a ushort from the current stream and progress the current position upon success.
	// toShort: a ushort to be manipulated.
	// Returns: Will return true upon success and false when the Stream does not have enough data.
	bool read(out ushort toShort) {
		return read(cast(ubyte*)&toShort, 2);
	}

	// Description: This function will read in a uint from the current stream and progress the current position upon success.
	// toInt: a uint to be manipulated.
	// Returns: Will return true upon success and false when the Stream does not have enough data.
	bool read(out uint toInt) {
		return read(cast(ubyte*)&toInt, 4);
	}

	// Description: This function will read in a double from the current stream and progress the current position upon success.
	// toDouble: a double to be manipulated.
	// Returns: Will return true upon success and false when the Stream does not have enough data.
	bool read(out double toDouble) {
		return read(cast(ubyte*)&toDouble, 8);
	}

	// Description: This function will read in a float from the current stream and progress the current position upon success.
	// toDouble: a float to be manipulated.
	// Returns: Will return true upon success and false when the Stream does not have enough data.
	bool read(out float toFloat) {
		return read(cast(ubyte*)&toFloat, 4);
	}

	bool readLine(out char[] line) {
		ubyte inByte;

		for(;;) {
			if (!read(inByte)) {
				// done
				if (line is null) { return false; }
				break;
			}
			else if (inByte == cast(ubyte)'\r') {
				// ignore
			}
			else if (inByte == cast(ubyte)'\n') {
				// done
				break;
			}
			else {
				// add to the string
				line ~= cast(char)inByte;
			}
		}

		return true;
	}

	bool read(ref ubyte[] toBuffer) {
		return read(toBuffer.ptr, toBuffer.length);
	}

	// Description: This function will skip to the end of the stream.  Essentially, it will set the current position to the length.
	void skip() {
		_curpos = _length;
		_pos = &_data[cast(uint)_curpos];
	}

	// Description: This function will skip through the stream the number of bytes given.
	// amount: The number of bytes to skip.
	// Returns: Will return true upon success and false when the stream does not have enough bytes to skip.
	bool skip(ulong amount) {
		if (_curpos + amount > _length) {
			return false;
		}

		_curpos += amount;
		_pos += amount;
		return true;
	}

	// Description: This function will skip through the stream the number of bytes given or skip to the end of the stream when the operation would have skipped past the end of the buffer.
	// amount: The number of bytes to skip.
	// Returns: Will return the number of bytes skipped.  This may be less than amount if amount is greater than the amount of bytes left in the buffer.
	ulong skipAny(ulong amount) {
		if (_curpos + amount > _length) {
			amount = _length - _curpos;
		}

		if (amount <= 0) { return 0; }

		_curpos += amount;
		_pos += amount;
		return amount;
	}

	// Description: This function serves as a useful convenience function for repeating parts of the stream from the current location.  It will select a region starting at the current position and rewinding the distanceBehind with the length given by amount.  It will then write at the current position of the stream this region. Note that overlaps are allowed, and can be a way of repeating values. Many compression algorithms find this feature delicious.
	// distanceBehind: The number of bytes behind the current position the data region to copy starts.
	// amount: The number of bytes to duplicate.
	// Returns: Will return true upon success and false when the region is undefined (the current position is less than distanceBehind).
	bool duplicate(ulong distanceBehind, uint amount) {
		if (amount <= 0) { return false; }

		if (_curpos - distanceBehind < 0) { return false; }

		// need to store bytes...could be an overlapping array copy!

		ubyte bytes[] = new ubyte[amount];

		read(bytes.ptr, amount);
		write(bytes.ptr, amount);

		return true;
	}

	// Description: This function serves as a useful convenience function for repeating parts of the stream at the end of the stream.  It will select a region starting at the end of the stream and rewinding the number of bytes specified by distanceBehind with the length given by amount.  It will then append at the end of the stream the data at this region. Note that overlaps are allowed, and can be a way of repeating values. Many compression algorithms find this feature delicious.
	// distanceBehind: The number of bytes behind the current position the data region to copy starts.
	// amount: The number of bytes to duplicate.
	// Returns: Will return true upon success and false when the region is undefined (the length is less than distanceBehind).
	bool duplicateFromEnd(ulong distanceBehind, uint amount) {
		if (amount <= 0) { return false; }

		if (_length - distanceBehind < 0) { return false; }

		// need to store bytes...could be an overlapping array copy!

		while (_length + amount > _capacity) {
			resize();	// Size!
		}

		if (distanceBehind < amount) {
			// overlapping regions (worst case)
			// in chunks
			ubyte bytes[] = new ubyte[cast(uint)distanceBehind];

			bytes[0..cast(uint)distanceBehind] = _data[cast(uint)_length-cast(uint)distanceBehind..cast(uint)_length];

			while(distanceBehind < amount) {
				_data[cast(uint)_length..cast(uint)_length+cast(uint)distanceBehind] = bytes[0..cast(uint)distanceBehind];

				_length += distanceBehind;
				amount -= distanceBehind;
			}

			if (amount > 0) {
				_data[cast(uint)_length..cast(uint)_length+amount] = bytes[0..amount];
				_length += amount;
			}
		}
		else	// non overlapping regions (best case)
		{
			ubyte bytes[] = new ubyte[amount];

			bytes[0..amount] = _data[cast(uint)_length - cast(uint)distanceBehind..cast(uint)_length - cast(uint)distanceBehind + amount];
			_data[cast(uint)_length..cast(uint)_length+amount] = bytes[0..amount];

			_length += amount;
		}

		return true;
	}


	// allows a viewer of a stream to save the current position it has
	// and then recall this, if it should believe another function
	// may manipulate the stream position.
	bool PushRestriction(ulong length) {
		return false;
	}

	bool PushRestriction(ulong startingIndex, ulong length) {
		return false;
	}

	bool PopRestriction() {
		return false;
	}

	int opApply(int delegate(ref size_t, ref string) loopFunc) {
		string nextLine;
		int ret;
		size_t cnt = 0;
		while(readLine(nextLine)) {
			ret = loopFunc(cnt, nextLine);
			cnt++;

			if (ret) { break; }
		}

		return ret;
	}

	int opApply(int delegate(ref string) loopFunc) {
		string nextLine;
		int ret;
		while(readLine(nextLine)) {
			ret = loopFunc(nextLine);

			if (ret) { break; }
		}

		return ret;
	}

	int opApply(int delegate(ref String) loopFunc) {
		string nextLine;
		int ret;
		while(readLine(nextLine)) {
			String str = new String(nextLine);
			ret = loopFunc(str);

			if (ret) { break; }
		}
		
		return ret;
	}

	ubyte[] contents() {
		if (_length == 0) {
			return null;
		}
		return _data[0..cast(uint)_length];
	}

protected:

	const uint ReadFlag = 1;
	const uint UpdateFlag = 2;
	const uint AppendFlag = (4 | UpdateFlag);
	const uint AllocFlag = (8 | AppendFlag);

	const uint AppendOnlyFlag = 4;
	const uint AllocOnlyFlag = 8;

	void readFrom(void* buffer, ulong pos, ulong len) {
		(cast(ubyte*)buffer)[0..cast(uint)len] = _data[cast(uint)pos..cast(uint)pos+cast(uint)len];
	}

	void resize() {
		_capacity += 150000;

		ubyte tmp[] = new ubyte[cast(uint)_capacity];

		if (_length != 0) {
			tmp[0..cast(uint)_length] = _data[0..cast(uint)_length];
		}

		//writeln(_data.length, tmp.length);

		_data = tmp;
		_pos = &_data[cast(uint)_curpos];
	}

	ubyte _data[] = null;

	ulong _length = 0;
	ulong _capacity = 100000;

	ubyte* _pos = null;
	ulong _curpos = 0;
}

class Buffer : Stream {
	// Description: This will create the stream using a default capacity.
	this() {
		super();
	}

	// Description: This will create the stream using the capacity given by the parameter.
	// size: The default size of the stream, which will be allocated immediately.
	this(ulong size) {
		super(size);
	}

	this(ubyte[] fromArray) {
		super(fromArray);
	}
}

class BufferReader : Stream {
	// Description: This will create the stream using a default capacity.
	this() {
		super();
	}

	// Description: This will create the stream using the capacity given by the parameter.
	// size: The default size of the stream, which will be allocated immediately.
	this(ulong size) {
		super(size);
	}

	this(ubyte[] fromArray) {
		super(fromArray);
	}

	// Exceptions:

	override bool write(byte value) {
		//throw new Exception("Stream Permission");
		return false;
	}
}

class BufferWriter : Stream {
	// Description: This will create the stream using a default capacity.
	this() {
		super();
	}

	// Description: This will create the stream using the capacity given by the parameter.
	// size: The default size of the stream, which will be allocated immediately.
	this(ulong size) {
		super(size);
	}

	this(ubyte[] fromArray) {
		super(fromArray);
	}
}
