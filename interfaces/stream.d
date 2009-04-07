module interfaces.stream;

// Section: Enums

// Description: This enum gives a description of the current stream processing progress for any function that receives its information via a stream.
enum StreamData : int
{
	// Description: The stream is invalid.  The primarly reason is that the stream does not represent the expected semantics of the data.  For instance, you gave a BMP file to the PNG decoder, the PNG header would not be present and the stream would be marked invalid.
	Invalid = -1,

	// Description: The stream is so far valid, and has been partially processed.  The function requires further data to complete.
	Required,

	// Description: The stream was used and a piece of information has been processed successfully.  There is more units to decode with further calls.  (A frame of animation or a sample of audio are examples)
	Accepted,

	// Description: The stream was used and all information was successfully decoded.
	Complete,
}

// Description: This enum gives the possible permission types of the stream.

// As you can see, individual bits indicate access type: read - 1, update - 2, append - 4, allocate - 8
enum StreamAccess : int
{
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

// Section: Interfaces

// Description: This abstract class represents operations to maintain a stream.
interface AbstractStream
{
	// Methods //

	// Description: This will zero out the entire contents of the stream.
	void zero();

	// Description: This will shrink the stream back to the default size and invalidate the contents.
	void clear();

	// Description: Will resize the Stream.
	// Returns: Will return true when the Stream can be resized to this amount.
	// newLength: the new length of the stream
	bool resize(ulong newLength);

	// Description: This function will append the buffer passed in with the length given to the end of the current stream.
	// bytes: The buffer with the data to be appended.
	// len: The number of bytes to append.
	// Returns: Will return true when the data could be successfully written and false when the data could not all be read.
	bool append(ubyte* bytes, uint len);

	// Description: This function will append len bytes from the stream passed to the end of the current stream.
	// stream: The stream to append from.
	// len: The number of bytes to stream.
	// Returns: Will return true when the data could be successfully written and false when the data could not all be read.
	bool append(AbstractStream stream, uint len);

	// Description: This function will append len bytes from the stream passed to the end of the current stream.
	// stream: The stream to append from.
	// len: The number of bytes to stream.
	// Returns: Will return true when the data could be successfully written and false when the data could not all be read.
	ulong appendAny(AbstractStream stream, uint len);

	// Description: This function will write len bytes from the buffer passed to the current location in the stream.  It will then progress this stream to the end of the written data.
	// bytes: The buffer to write from.
	// len: The number of bytes to write.
	// Returns: Will return true when the data could be successfully written and false when the data could not all be read.
	bool write(ubyte* bytes, uint len);

	// Description: This function will write len bytes from the stream passed to the current location in the stream.  It will then progress this stream to the end of the written data and also progress the stream which was read to the end of the read data.
	// bytes: The buffer to write from.
	// len: The number of bytes to write.
	// Returns: Will return true when the data could be successfully written and false when the data could not all be read.
	bool write(AbstractStream stream, uint len);

	// Description: This function will write len bytes from the stream passed to the current location in the stream.  It will then progress this stream to the end of the written data and also progress the stream which was read to the end of the read data.
	// bytes: The buffer to write from.
	// len: The number of bytes to write.
	// Returns: Will return true when the data could be successfully written and false when the data could not all be read.
	ulong writeAny(AbstractStream stream, uint len);

	// Description: This function will write the ubyte passed to the end of the current stream.
	// value: A ubyte to append.
	// Returns: Will return true when the data could be successfully written and false when the data could not.
	bool append(ubyte value);

	// Description: This function will write the ubyte passed to the current position of the current stream and progress this stream the amount written.
	// value: A ubyte to append.
	// Returns: Will return true when the data could be successfully written and false when the data could not.
	bool write(ubyte value);

	// Description: This function will write the byte passed to the end of the current stream.
	// value: A byte to append.
	// Returns: Will return true when the data could be successfully written and false when the data could not.
	bool append(byte value);

	// Description: This function will write the byte passed to the current position of the current stream and progress this stream the amount written.
	// value: A byte to append.
	// Returns: Will return true when the data could be successfully written and false when the data could not.
	bool write(byte value);

	// Description: This function will write the ushort passed to the end of the current stream.
	// value: A ushort to append.
	// Returns: Will return true when the data could be successfully written and false when the data could not.
	bool append(ushort value);

	// Description: This function will write the ushort passed to the current position of the current stream and progress this stream the amount written.
	// value: A ushort to append.
	// Returns: Will return true when the data could be successfully written and false when the data could not.
	bool write(ushort value);

	// Description: This function will write the short passed to the end of the current stream.
	// value: A ushort to append.
	// Returns: Will return true when the data could be successfully written and false when the data could not.
	bool append(short value);

	// Description: This function will write the ushort passed to the current position of the current stream and progress this stream the amount written.
	// value: A short to append.
	// Returns: Will return true when the data could be successfully written and false when the data could not.
	bool write(short value);

	// Description: This function will write the uint passed to the end of the current stream.
	// value: A uint to append.
	// Returns: Will return true when the data could be successfully written and false when the data could not.
	bool append(uint value);

	// Description: This function will write the uint passed to the current position of the current stream and progress this stream the amount written.
	// value: A uint to append.
	// Returns: Will return true when the data could be successfully written and false when the data could not.
	bool write(uint value);

	// Description: This function will write the uint passed to the end of the current stream.
	// value: A uint to append.
	// Returns: Will return true when the data could be successfully written and false when the data could not.
	bool append(int value);

	// Description: This function will write the int passed to the current position of the current stream and progress this stream the amount written.
	// value: A int to append.
	// Returns: Will return true when the data could be successfully written and false when the data could not.
	bool write(int value);

	// Description: This function will write the ulong passed to the end of the current stream.
	// value: A ulong to append.
	// Returns: Will return true when the data could be successfully written and false when the data could not.
	bool append(ulong value);

	// Description: This function will write the ulong passed to the current position of the current stream and progress this stream the amount written.
	// value: A ulong to append.
	// Returns: Will return true when the data could be successfully written and false when the data could not.
	bool write(ulong value);

	// Description: This function will write the long passed to the end of the current stream.
	// value: A long to append.
	// Returns: Will return true when the data could be successfully written and false when the data could not.
	bool append(long value);

	// Description: This function will write the long passed to the current position of the current stream and progress this stream the amount written.
	// value: A long to append.
	// Returns: Will return true when the data could be successfully written and false when the data could not.
	bool write(long value);

	bool append(char[] str);

	// Description: This function will write the string passed to the current position of the current stream abd progress this stream the amount written.
	bool writeUtf8(char[] str);

	bool append(wchar[] str);

	bool write(wchar[] str);

	bool append(dchar[] str);

	bool write(dchar[] str);

	// Description: This function places the last bytes of information into the front and sets the pointer to end of the information after it is moved.
	void flush();

	StreamAccess getPermissions();

	// Description: This function will return the amount of data remaining in the stream from the current position.
	// Returns: The number of bytes remaining in the stream.
	ulong getRemaining();

	// Description: This function will return the current length of the stream.
	// Returns: The total number of bytes of this stream.
	ulong length();

	// Description: This function will return the current position of the stream.
	// Returns: The current byte of the stream.
	ulong getPosition();

	// Description: This function will position the stream as best as possible to the position given.
	// position: The new position in the stream.
	// Returns: The new position
	ulong setPosition(ulong position);

	// Description: This function will rewind the current position to the very beginning of the stream's buffer.
	void rewind();

	// Description: This function will rewind the current position the amount given if possible.
	// amount: The number of bytes to rewind.
	// Returns: Will return false if the stream cannot be rewound by that amount and true if the operation is successful.
	bool rewind(ulong amount);

	// Description: This function will rewind the current position the amount given or simply move to the beginning.
	// amount: The number of bytes to rewind.
	// Returns: Will return the number of bytes rewound successfully.  This could be less than 'amount' if the stream's current position was less than amount.  In this case, it has rewound to the very beginning and was analogous to the simple rewind() call.
	ulong rewindAny(ulong amount);

	// Description: This function will read from the current stream the number of bytes given by len into the buffer passed.
	// len: The number of bytes to read from this stream.
	// buffer: The buffer into which the data will be copied.
	// Returns: Will return true when the stream has copied successfully all data and false when there is not enough data to complete the operation.
	bool read(void* buffer, uint len);

	// Description: This function will read from the current stream the number of bytes given by len into the current position of the stream passed.  It will then, on success, progress the current positions of both streams.  On failure, no positions will change.
	// len: The number of bytes to read from this stream.
	// stream: The stream into which the data will be copied.
	// Returns: Will return true when the stream has copied successfully all data and false when there is not enough data to complete the operation.
	bool read(AbstractStream stream, uint len);

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
	ulong readAny(void* buffer, uint len);

	// Description: This function will read from the current stream the number of bytes given by len or all of the remaining bytes at the current position of the stream passed.  It will then progress the current positions of the streams.
	// len: The number of bytes to read from this stream.
	// stream: The stream into which the data will be copied.
	// Returns: Will return the number of bytes successfully copied.  This will be less than len when the stream does not have len bytes left in its buffer.
	ulong readAny(AbstractStream stream, uint len);

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
	bool read(out ubyte toByte);

	// Description: This function will read in a ushort from the current stream and progress the current position upon success.
	// toShort: a ushort to be manipulated.
	// Returns: Will return true upon success and false when the Stream does not have enough data.
	bool read(out ushort toShort);

	// Description: This function will read in a uint from the current stream and progress the current position upon success.
	// toInt: a uint to be manipulated.
	// Returns: Will return true upon success and false when the Stream does not have enough data.
	bool read(out uint toInt);

	// Description: This function will read in a double from the current stream and progress the current position upon success.
	// toDouble: a double to be manipulated.
	// Returns: Will return true upon success and false when the Stream does not have enough data.
	bool read(out double toDouble);

	// Description: This function will read in a float from the current stream and progress the current position upon success.
	// toDouble: a float to be manipulated.
	// Returns: Will return true upon success and false when the Stream does not have enough data.
	bool read(out float toFloat);

	bool readUTF8(out char toByte);

	bool read(ref ubyte[] toBuffer);

	// Description: This function will skip to the end of the stream.  Essentially, it will set the current position to the length.
	void skip();

	// Description: This function will skip through the stream the number of bytes given.
	// amount: The number of bytes to skip.
	// Returns: Will return true upon success and false when the stream does not have enough bytes to skip.
	bool skip(ulong amount);

	// Description: This function will skip through the stream the number of bytes given or skip to the end of the stream when the operation would have skipped past the end of the buffer.
	// amount: The number of bytes to skip.
	// Returns: Will return the number of bytes skipped.  This may be less than amount if amount is greater than the amount of bytes left in the buffer.
	ulong skipAny(ulong amount);

	// Description: This function serves as a useful convenience function for repeating parts of the stream from the current location.  It will select a region starting at the current position and rewinding the distanceBehind with the length given by amount.  It will then write at the current position of the stream this region. Note that overlaps are allowed, and can be a way of repeating values. Many compression algorithms find this feature delicious.
	// distanceBehind: The number of bytes behind the current position the data region to copy starts.
	// amount: The number of bytes to duplicate.
	// Returns: Will return true upon success and false when the region is undefined (the current position is less than distanceBehind).
	bool duplicate(ulong distanceBehind, uint amount);

	// Description: This function serves as a useful convenience function for repeating parts of the stream at the end of the stream.  It will select a region starting at the end of the stream and rewinding the number of bytes specified by distanceBehind with the length given by amount.  It will then append at the end of the stream the data at this region. Note that overlaps are allowed, and can be a way of repeating values. Many compression algorithms find this feature delicious.
	// distanceBehind: The number of bytes behind the current position the data region to copy starts.
	// amount: The number of bytes to duplicate.
	// Returns: Will return true upon success and false when the region is undefined (the length is less than distanceBehind).
	bool duplicateFromEnd(ulong distanceBehind, uint amount);


	// allows a viewer of a stream to save the current position it has
	// and then recall this, if it should believe another function
	// may manipulate the stream position.
	bool PushRestriction(ulong length);

	bool PushRestriction(ulong startingIndex, ulong length);

	bool PopRestriction();




	ubyte[] contents();
}
