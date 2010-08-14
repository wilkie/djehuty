/*
 * file.d
 *
 * This file contains the magic behind File.
 *
 * Author: Dave Wilkinson
 *
 */

module io.file;

import djehuty;

import platform.vars.file;

import scaffold.file;

import io.directory;

// Section: Core/Streams

// Description: This class wraps common file operations within the context of a Stream.
class File : Stream {
protected:

	bool _inited = false;
	FilePlatformVars _pfvars;

	Directory _path;
	string _name;

public:
	// Description: Will open the file located at the _path at filename.  The internal pointer will point to the beginning of the file.
	// filename: The file to open.
	this(string filename) {
		_name = filename.dup; 

		_pos = null;
		_curpos = 0;
		bool r = FileCreate(_pfvars, _name);

		if (!r) {
			throw new IOException.CreationFailure(filename);
		}

		_length = 0;
		_inited = true;
	}

	// Description: Will create a closed File class.  You must open a file to use it as a stream.
	this() {
	}

	~this() {
		close();
	}

	// Description: Will open the file located at the _path at filename.  The internal pointer will point to the beginning of the file.
	// filename: The file to open.
	// Returns: Will return an instance to the opened file.
	static File open(string filename) {
		File foo = new File;
		foo._name = filename.dup;

		foo._pos = null;
		foo._curpos = 0;
		bool r = FileOpen(foo._pfvars, foo._name);

		if (!r) {
			return null;
		}

		FileGetSize(foo._pfvars, foo._length);
		foo._inited = true;

		return foo;
	}

	static File create(string filename) {
		return new File(filename);
	}

	static Time time(string filename) {
		return FileTime(filename);
	}

	// Methods //

	// Inherited Functionality

	alias Stream.write write;
	alias Stream.append append;
	alias Stream.read read;

	// Core Functionality

	Time time() {
		return File.time(_name);
	}

	// Description: Will close the file.  This is also done upon deconstruction of the class, for instance when it is garbage collected.
	void close() {
		if (_inited) {
			FileClose(_pfvars);
			_inited = false;
			_name = null;
		}
	}

	// read
	override bool read(void* buffer, uint len) {
		if (_curpos + len > _length) {
			return false;
		}

		FileRead(_pfvars, cast(ubyte*)buffer, len);

		_curpos += len;

		return true;
	}

	override bool read(Stream stream, uint len) {
		if (_curpos + len > _length) {
			return false;
		}

		stream.write(this, len);

		return true;
	}

	override ulong readAny(void* buffer, uint len) {
		if (_curpos + len > _length) {
			len = cast(uint)(_length - _curpos);
		}

		if (len == 0) { return 0; }

		FileRead(_pfvars, cast(ubyte*)buffer, len);

		return len;
	}

	override ulong readAny(Stream stream, uint len) {
		if (_curpos + len > _length) {
			len = cast(uint)(_length - _curpos);
		}

		if (len == 0) { return 0; }

		stream.write(this, len);

		_curpos += len;

		return len;
	}

	// Console.put

	override bool write(ubyte* bytes, uint len) {
		if (len <= 0) { return false;}

		//if (_curpos + len > _length)
		//{
		// TODO: throw permission exception
		//	return false;
		//}

		FileWrite(_pfvars, bytes, len);

		_curpos += len;

		if (_curpos > _length) { _length = _curpos; }
		return true;
	}

	override bool write(Stream stream, uint len) {
		if (len <= 0) { return false;}

		ubyte buffer[] = new ubyte[len];

		stream.read(&buffer[0], len);

		//if (_curpos + len > _length)
		//{
		// TODO: throw permission exception
		//	return false;
		//}

		FileWrite(_pfvars, &buffer[0], len);

		_curpos += len;

		if (_curpos > _length) { _length = _curpos; }
		return true;
	}

	// append

	override bool append(ubyte* bytes, uint len) {
		if (len <= 0) { return false;}

		FileAppend(_pfvars, bytes, len);

		_length += len;
		return true;
	}

	override bool append(Stream stream, uint len) {
		if (len <= 0) { return false;}

		ubyte buffer[] = new ubyte[len];

		stream.read(&buffer[0], len);
		FileAppend(_pfvars, &buffer[0], len);

		_length += len;
		return true;
	}

	override ulong remaining() {
		//Console.put("rem: ", _curpos, " ", _length, " ", _length - _curpos);
		return _length - _curpos;
	}

	// rewind

	override void rewind() {
		// set to start
		_curpos = 0;

		FileRewindAll(_pfvars);
	}

	override bool rewind(ulong amount) {
		if (_curpos - amount < 0) {
			return false;
		}

		_curpos -= amount;
		FileRewind(_pfvars, amount);

		return true;
	}

	override ulong rewindAny(ulong amount) {
		if (_curpos - amount < 0) {
			amount = _curpos;
		}

		_curpos -= amount;
		FileRewind(_pfvars, amount);

		return amount;
	}

	// skip

	override void skip() {
		_curpos = _length;

		FileSkipAll(_pfvars);
	}

	override bool skip(ulong amount) {
		if (_curpos + amount > _length) {
			return false;
		}

		_curpos += amount;
		FileSkip(_pfvars, amount);
		return true;
	}

	override ulong skipAny(ulong amount) {
		if (_curpos + amount > _length) {
			amount = _length - _curpos;
		}

		if (amount <= 0) { return 0; }

		_curpos += amount;
		FileSkip(_pfvars, amount);
		return amount;
	}

	// Description: Will return the string representing the filename currently open, or null for when there is no open file.
	// Returns: The string representing the filename of this class.
	string name() {
		if (_inited) {
			return _name.dup;
		}

		return null;
	}

	override bool duplicate(ulong distanceBehind, uint amount) {
		if (amount <= 0) { return false; }

		if (_curpos - distanceBehind < 0) { return false; }

		// need to store bytes...could be an overlapping array copy!
		ubyte bytes[] = new ubyte[amount];

		read(bytes.ptr, amount);

		return true;
	}

	override bool duplicateFromEnd(ulong distanceBehind, uint amount) {
		if (amount <= 0) { return false; }

		if (_length - distanceBehind < 0) { return false; }

		ubyte bytes[] = new ubyte[amount];

		ulong pos = _curpos;

		skip();
		rewind(distanceBehind);

		read(bytes.ptr, amount);
		append(bytes.ptr, amount);

		rewind();
		skip(pos);

		return true;
	}

	// File logic

	Directory path() {
		if (_inited) {
			return _path;
		}

		return null;
	}

	void move(Directory destination) {
		if (FileMove(_pfvars, _path.path ~ "/" ~ _name, destination.path ~ "/" ~ _name)) {
			_path = destination;
		}
	}

	void move(string destination) {
		if (FileMove(_pfvars, _path.path ~ "/" ~ _name, destination ~ "/" ~ _name)) {
			_path = Directory.open(destination);
		}
	}

	File copy(Directory destination) {
		File ret;
		if (FileCopy(_pfvars, _path.path ~ "/" ~ _name, destination.path ~ "/" ~ _name)) {
			ret = File.open(destination.path ~ "/" ~ _name);
		}
		return ret;
	}

	File copy(string destination) {
		File ret;
		if (FileCopy(_pfvars, _path.path ~ "/" ~ _name, destination ~ "/" ~ _name)) {
			ret = File.open(destination ~ "/" ~ _name);
		}
		return ret;
	}

	void destroy() {
	}

	override char[] toString() {
		return _path.path ~ "/" ~ _name;
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
}

// Section: Core/Streams

// Description: This class wraps common file operations within the context of a Stream. The permissions of this object will not allow writes.
class FileReader : File {
	// Description: Will open the file located at the _path at filename. The internal pointer will point to the beginning of the file.
	// filename: The file to open.
	this(string filename) {
		super(filename);
	}

	// Description: Will create a closed File class. You must open a file to use it as a stream.
	this() {
		super();
	}
}

// Section: Core/Streams

// Description: This class wraps common file operations within the context of a Stream. The permissions of this object will not allow reads.
class FileWriter : File {
	// Description: Will open the file located at the _path at filename. The internal pointer will point to the beginning of the file.
	// filename: The file to open.
	this(string filename) {
		super(filename);
	}

	// Description: Will create a closed File class. You must open a file to use it as a stream.
	this() {
		super();
	}
}
