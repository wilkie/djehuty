module hashes.all;

import hashes.digest;
import hashes.md5;
import hashes.sha1;

import core.string;
import core.stream;

enum HashType
{
	MD5,
	SHA1,
}

template _HashCall(HashType type)
{
	static if (type == HashType.MD5)
	{
		const char[] _HashCall = `return HashMD5(msg);`;
	}
	else static if (type == HashType.SHA1)
	{
		const char[] _HashCall = `return HashSHA1(msg);`;
	}
	else
	{
		static assert(false, "Hash type not supported.");
	}
}

struct Hash(HashType type)
{
static:
	Digest opCall(StringLiteral msg)
	{
		mixin(_HashCall!(type));
	}

	Digest opCall(String msg)
	{
		mixin(_HashCall!(type));
	}

	Digest opCall(ubyte[] msg)
	{
		mixin(_HashCall!(type));
	}

	Digest opCall(Stream msg)
	{
		mixin(_HashCall!(type));
	}
}

/*	static if (type == HashType.MD5)
	{
		Digest Hash(StringLiteral msg)
		{
			return HashMD5(msg);
		}
	}
	else static if (type == HashType.SHA1)
	{
	}
	else
	{
		static assert (false, "Hash type not supported");
	}
}*/