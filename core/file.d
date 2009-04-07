module core.file;

import interfaces.stream;

import core.stream;
import core.string;

import platform.imports;
mixin(PlatformGenericImport!("vars"));
mixin(PlatformGenericImport!("definitions"));
mixin(PlatformScaffoldImport!());

// Section: Core/Streams

// Description: This class wraps common file operations within the context of a Stream.
class FileImpl(StreamAccess permissions) : StreamImpl!(permissions)
{
public:


	// Description: Will open the file located at the path at filename.  The internal pointer will point to the beginning of the file.
	// filename: The file to open.
	this(String filename)
	{
		open(filename);
	}

	// Description: Will open the file located at the path at filename.  The internal pointer will point to the beginning of the file.
	// filename: The file to open.
	this(StringLiteral filename)
	{
		open(filename);
	}

	// Description: Will create a closed File class.  You must open a file to use it as a stream.
	this()
	{
	}

	~this()
	{
		close();
	}

	// Methods //



	// Inherited Functionality

	alias StreamImpl!(permissions).write write;
	alias StreamImpl!(permissions).append append;
	alias StreamImpl!(permissions).read read;

	// Core Functionality

	// Description: Will open the file located at the path at filename.  The internal pointer will point to the beginning of the file.
	// filename: The file to open.
	// Returns: Will return false when the file cannot be opened.

	// TODO: Exceptions for opening of a file.
    bool open(String filename)
    {
        _filename = new String(filename);

        _pos = null;
        _curpos = 0;
        bool r = Scaffold.FileOpen(_pfvars, _filename);

        if (!r)
        {
            return false;
        }

        // get file size
        Scaffold.FileGetSize(_pfvars, _length);
        _inited = true;

        return true;
    }

	// Description: Will open the file located at the path at filename.  The internal pointer will point to the beginning of the file.
	// filename: The file to open.
	// Returns: Will return false when the file cannot be opened.

	// TODO: Exceptions for opening of a file.
    bool open(StringLiteral filename)
    {
        _filename = new String(filename);

        _pos = null;
        _curpos = 0;
        bool r = Scaffold.FileOpen(_pfvars, _filename);

        if (!r)
        {
            return false;
        }

        // get file size
        Scaffold.FileGetSize(_pfvars, _length);
        _inited = true;

        return true;
    }

	// Description: Will close the file.  This is also done upon deconstruction of the class, for instance when it is garbage collected.
    void close()
    {
		if (_inited)
		{
	        Scaffold.FileClose(_pfvars);
	        _inited = false;
	        _filename = null;
	    }
    }


    // read
	override bool read(void* buffer, uint len)
	{
		static if ((cast(int)permissions) & ReadFlag)
		{
			if (_curpos + len > _length)
			{
				return false;
			}

			Scaffold.FileRead(_pfvars, cast(ubyte*)buffer, len);

			_curpos += len;

			return true;
		}
		else
		{
			// TODO: throw permission exception
			return false;
		}
	}

	override bool read(AbstractStream stream, uint len)
	{
		static if ((cast(int)permissions) & ReadFlag)
		{
			if (_curpos + len > _length)
			{
				return false;
			}

			stream.write(this, len);

			return true;
		}
		else
		{
			// TODO: throw permission exception
			return false;
		}
	}

	override ulong readAny(void* buffer, uint len)
	{
		static if ((cast(int)permissions) & ReadFlag)
		{
			if (_curpos + len > _length)
			{
				len = cast(uint)(_length - _curpos);
			}

			if (len == 0) { return 0; }

			Scaffold.FileRead(_pfvars, cast(ubyte*)buffer, len);

			return len;
		}
		else
		{
			// TODO: throw permission exception
			return 0;
		}
	}

	override ulong readAny(AbstractStream stream, uint len)
	{
		static if ((cast(int)permissions) & ReadFlag)
		{
			if (_curpos + len > _length)
			{
				len = cast(uint)(_length - _curpos);
			}

			if (len == 0) { return 0; }

			stream.write(this, len);

			_curpos += len;

			return len;
		}
		else
		{
			// TODO: throw permission exception
			return 0;
		}
	}



    // Console.put

	override bool write(ubyte* bytes, uint len)
	{
		static if ((cast(int)permissions) & UpdateFlag)
		{
			if (len <= 0) { return false;}

			static if (!((cast(int)permissions) & AppendOnlyFlag))
			{
				if (_curpos + len > _length)
				{
					// TODO: throw permission exception
					return false;
				}
			}

			Scaffold.FileWrite(_pfvars, bytes, len);

			_curpos += len;

			if (_curpos > _length) { _length = _curpos; }
			return true;
		}
		else
		{
			// TODO: throw permission exception
			return false;
		}
	}

	override bool write(AbstractStream stream, uint len)
	{
		static if ((cast(int)permissions) & UpdateFlag)
		{
			if (len <= 0) { return false;}

			ubyte buffer[] = new ubyte[len];

			stream.read(&buffer[0], len);

			static if (!((cast(int)permissions) & AppendOnlyFlag))
			{
				if (_curpos + len > _length)
				{
					// TODO: throw permission exception
					return false;
				}
			}

			Scaffold.FileWrite(_pfvars, &buffer[0], len);

			_curpos += len;

			if (_curpos > _length) { _length = _curpos; }
			return true;
		}
		else
		{
			// TODO: throw permission exception
			return false;
		}
	}



    // append

	override bool append(ubyte* bytes, uint len)
	{
		static if ((cast(int)permissions) & AppendFlag)
		{
			if (len <= 0) { return false;}

			Scaffold.FileAppend(_pfvars, bytes, len);

			_length += len;
			return true;
		}
		else
		{
			// TODO: throw permission exception
			return false;
		}
	}

	override bool append(AbstractStream stream, uint len)
	{
		static if ((cast(int)permissions) & AppendFlag)
		{
			if (len <= 0) { return false;}

			ubyte buffer[] = new ubyte[len];

			stream.read(&buffer[0], len);
			Scaffold.FileAppend(_pfvars, &buffer[0], len);

			_length += len;
			return true;
		}
		else
		{
			// TODO: throw permission exception
			return false;
		}
	}




	override ulong getRemaining()
	{
		//Console.put("rem: ", _curpos, " ", _length, " ", _length - _curpos);
		return _length - _curpos;
	}




	// rewind

	override void rewind()
	{
		// set to start
		_curpos = 0;

		Scaffold.FileRewindAll(_pfvars);
	}

	override bool rewind(ulong amount)
	{
		if (_curpos - amount < 0)
		{
			return false;
		}

		_curpos -= amount;
		Scaffold.FileRewind(_pfvars, amount);

		return true;
	}

	override ulong rewindAny(ulong amount)
	{
		if (_curpos - amount < 0)
		{
			amount = _curpos;
		}

		_curpos -= amount;
		Scaffold.FileRewind(_pfvars, amount);

		return amount;
	}


	// skip

	override void skip()
	{
		_curpos = _length;

		Scaffold.FileSkipAll(_pfvars);
	}

	override bool skip(ulong amount)
	{
		if (_curpos + amount > _length)
		{
			return false;
		}

		_curpos += amount;
		Scaffold.FileSkip(_pfvars, amount);
		return true;
	}

	override ulong skipAny(ulong amount)
	{
		if (_curpos + amount > _length)
		{
			amount = _length - _curpos;
		}

		if (amount <= 0) { return 0; }

		_curpos += amount;
		Scaffold.FileSkip(_pfvars, amount);
		return amount;
	}

	// Description: Will return the String representing the filename currently open, or null for when there is no open file.
	// Returns: The string representing the filename of this class.
    String getFilename()
    {
		if (_inited) {
	        return new String(_filename);
	    }

	    return null;
    }





	override bool duplicate(ulong distanceBehind, uint amount)
	{
		if (amount <= 0) { return false; }

		if (_curpos - distanceBehind < 0) { return false; }

		//Console.put("dupdata");

		// need to store bytes...could be an overlapping array copy!

		ubyte bytes[] = new ubyte[amount];

		read(bytes.ptr, amount);

		return true;
	}

	override bool duplicateFromEnd(ulong distanceBehind, uint amount)
	{
		static if ((cast(int)permissions) & AppendFlag)
		{
			if (amount <= 0) { return false; }

			if (_length - distanceBehind < 0) { return false; }

	//		Console.put("dupend");

			// need to store bytes...could be an overlapping array copy!




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
		else
		{
			// TODO: throw permission exception
			return false;
		}
	}

protected:

    bool _inited = false;
    FilePlatformVars _pfvars;
    String _filename = null;
}

alias FileImpl!(StreamAccess.AllAccess) File;
alias FileImpl!(StreamAccess.Read) FileReader;
alias FileImpl!(StreamAccess.Update) FileWriter;
