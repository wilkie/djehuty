/*
 * endian.d
 *
 * This file contains some simple code to switch endian.
 *
 * Author: Dave Wilkinson
 *
 */

module core.endian;


// IntType FromBigEndian(IntType)
// --------------------------------
//   converts big endian input to native byte order

ulong FromBigEndian64(ulong input)
{
	version(LittleEndian)
	{
		return (input >> 56) | ((input >> 40) & 0xFF00) | ((input >> 24) & 0xFF0000) | ((input >> 8) & 0xFF000000) | ((input << 8) & 0xFF00000000UL) | ((input << 24) & 0xFF0000000000UL) | ((input << 40) & 0xFF000000000000UL) | ((input << 56) & 0xFF00000000000000UL);
	}
	else
	{
		return input;
	}
}

uint FromBigEndian32(uint input)
{
	version(LittleEndian)
	{
		return (input >> 24) | ((input >> 8) & 0xFF00) | ((input << 8) & 0xFF0000) | ((input << 24) & 0xFF000000);
	}
	else
	{
		return input;
	}
}

ushort FromBigEndian16(ushort input)
{
	version(LittleEndian)
	{
		return cast(ushort)((cast(uint)input >> 8) | (cast(uint)input << 8));
	}
	else
	{
		return input;
	}
}







// IntType FromLittleEndian(IntType)
// -----------------------------------
//   converts little endian input to native byte order

ulong FromLittleEndian64(ulong input)
{
	version(LittleEndian)
	{
		return input;
	}
	else
	{
		return (input >> 56) | ((input >> 40) & 0xFF00) | ((input >> 24) & 0xFF0000) | ((input >> 8) & 0xFF000000) | ((input << 8) & 0xFF00000000) | ((input << 24) & 0xFF0000000000) | ((input << 40) & 0xFF000000000000) | ((input << 56) & 0xFF00000000000000);
	}
}

uint FromLittleEndian32(uint input)
{
	version(LittleEndian)
	{
		return input;
	}
	else
	{
		return (input >> 24) | ((input >> 8) & 0xFF00) | ((input << 8) & 0xFF0000) | ((input << 24) & 0xFF000000);
	}
}

ushort FromLittleEndian16(ushort input)
{
	version(LittleEndian)
	{
		return input;
	}
	else
	{
		return (input >> 8) | (input << 8);
	}
}



ulong NativeToLE64(ulong input)
{
	version (LittleEndian)
	{
		return input;
	}
	else
	{
		return FromLittleEndian64(input);
	}
}

uint NativeToLE32(uint input)
{
	version (LittleEndian)
	{
		return input;
	}
	else
	{
		return FromLittleEndian32(input);
	}
}

ushort NativeToLE16(ushort input)
{
	version (LittleEndian)
	{
		return input;
	}
	else
	{
		return FromLittleEndian16(input);
	}
}

ulong NativeToBE64(ulong input)
{
	version (LittleEndian)
	{
		return FromBigEndian64(input);
	}
	else
	{
		return input;
	}
}

uint NativeToBE32(uint input)
{
	version (LittleEndian)
	{
		return FromBigEndian32(input);
	}
	else
	{
		return input;
	}
}

ushort NativeToBE16(ushort input)
{
	version (LittleEndian)
	{
		return FromBigEndian16(input);
	}
	else
	{
		return input;
	}
}
