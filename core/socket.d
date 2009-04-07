module core.socket;

import interfaces.stream;

import core.stream;
import core.string;

import platform.imports;
mixin(PlatformGenericImport!("vars"));
mixin(PlatformGenericImport!("definitions"));
mixin(PlatformScaffoldImport!());

// Section: Core/Streams

// Description: This class wraps networking calls and represents the information stream as a Stream class.  This is a low-level implementation of a socket.  Note: no rewind or seek operations will have any affect.
class SocketImpl(StreamAccess permissions) : StreamImpl!(permissions)
{
	~this()
	{
		close();
	}

	// Methods

	// Inherited Functionality

	alias StreamImpl!(permissions).write write;
	alias StreamImpl!(permissions).append append;
	alias StreamImpl!(permissions).read read;

	// Core Functionality

	// Description: Will open a connection with the host on the port given by the parameters.
	// hostname: The name of the host to connect.
	// port: The port to connect through.
	// Returns: Will return true when the connect is made and false if the connection cannot be made.
    bool connect(String hostname, ushort port)
    {
        _hostname = new String(hostname);
        _port = port;

        _pos = null;
        _curpos = 0;
        bool r = Scaffold.SocketOpen(_pfvars, _hostname, port);

        if (!r)
        {
            return false;
        }

        _inited = true;

        return true;
    }

	// Description: Will open a connection with the host on the port given by the parameters.
	// hostname: The name of the host to connect.
	// port: The port to connect through.
	// Returns: Will return true when the connect is made and false if the connection cannot be made.
    bool connect(StringLiteral hostname, ushort port)
    {
        _hostname = new String(hostname);
        _port = port;

        _pos = null;
        _curpos = 0;
        bool r = Scaffold.SocketOpen(_pfvars, _hostname, port);

        if (!r)
        {
            return false;
        }

        _inited = true;

        return true;
    }

	// Description: Binds to a port, causes the socket to act as a server.
	// port: The port to listen for connection requests.
	// Returns: Will return false on failure.
    bool bind(ushort port)
    {
        _hostname = null;
        _port = port;

        _pos = null;
        _curpos = 0;
        bool r = Scaffold.SocketBind(_pfvars, port);

        if (!r)
        {
            return false;
        }

        _inited = true;

        return true;
    }

	// Description: Will listen to a binded port.  Use bind() prior to this.  It will not return until a connection is requested from a client.
	// Returns: Will return false on failure.
    bool listen()
    {
		return Scaffold.SocketListen(_pfvars);
    }

	// Description: Will accept a connection request from a client.  Do this after returning from a Listen() call without failure.
	// Returns: Will return false on failure.
    bool accept()
    {
		return Scaffold.SocketAccept(_pfvars);
    }

	// Description: Will close the connection, if open.  This is also done upon deconstruction of the class, for instance when it is garbage collected.
    void close()
    {
		if (_inited)
		{
	        Scaffold.SocketClose(_pfvars);

	        _inited = false;
	        _hostname = null;
	    }
    }


    // read
	override bool read(void* buffer, uint len)
	{
		static if ((cast(int)permissions) & ReadFlag)
		{
			return Scaffold.SocketRead(_pfvars, cast(ubyte*)buffer, len);
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

			_curpos += len;

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
			if (len == 0) { return 0; }

			return Scaffold.SocketReadAvailable(_pfvars, cast(ubyte*)buffer, len);
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
			if (len == 0) { return 0; }

			ubyte buffer[] = new ubyte[len];

			len = cast(uint)Scaffold.SocketReadAvailable(_pfvars, buffer.ptr, len);

			if (len != 0)
			{
				stream.write(buffer.ptr, len);
			}

			return len;
		}
		else
		{
			// TODO: throw permission exception
			return 0;
		}
	}



    // write

	override bool write(ubyte* bytes, uint len)
	{
		static if ((cast(int)permissions) & UpdateFlag)
		{
			if (len <= 0) { return false;}

			Scaffold.SocketWrite(_pfvars, bytes, len);

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
			Scaffold.SocketWrite(_pfvars, &buffer[0], len);

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
		static if ((cast(int)permissions) & UpdateFlag)
		{
			if (len <= 0) { return false;}

			Scaffold.SocketWrite(_pfvars, bytes, len);

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
		static if ((cast(int)permissions) & UpdateFlag)
		{
			if (len <= 0) { return false;}

			ubyte buffer[] = new ubyte[len];

			stream.read(&buffer[0], len);
			Scaffold.SocketWrite(_pfvars, &buffer[0], len);

			return true;
		}
		else
		{
			// TODO: throw permission exception
			return false;
		}
	}







	// rewind

	override void rewind()
	{
	}

	override bool rewind(ulong amount)
	{
		return true;
	}

	override ulong rewindAny(ulong amount)
	{
		return amount;
	}


	// skip

	override void skip()
	{
	}

	override bool skip(ulong amount)
	{
		return true;
	}

	override ulong skipAny(ulong amount)
	{
		return amount;
	}

	// Description: Will return the String representing the host currently open, or null for when there is no open socket.
	// Returns: The String of the host.
    String getHostname()
    {
		if (_inited) {
	        return _hostname;
	    }

		return null;
	}

	ulong getPort()
	{
		if (_inited) { return 0; }

		return _port;
    }

protected:

    bool _inited = false;
    String _hostname = null;

    ulong _port = 0;

    SocketPlatformVars _pfvars;

}

alias SocketImpl!(StreamAccess.AllAccess) Socket;
alias SocketImpl!(StreamAccess.Read) SocketReader;
alias SocketImpl!(StreamAccess.AllAccess) SocketWriter;
