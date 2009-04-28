module core.string;

// a class to encapsulate the expected string format for
// the underlying OS platform in use

import platform.imports;
mixin(PlatformGenericImport!("definitions"));

import core.definitions;
import core.unicode;
import core.format;


public import core.stringliteral;

template _StringFormat()
{
	const char[] _StringFormat = `

			// scan input, write when appropriate
			dchar[] fmt = (new String(str)).toUtf32();

			uint length;
			uint base;
			bool signed;

			dchar result[];

			int curArg = 0;

			// grab an argument
			bool intToStr = false;
			long argval;

			for(int i=0; i<fmt.length; i++)
			{
				if (fmt[i] == '%')
				{
					i++;
					length = 0;
					if (fmt[i] == '.')
					{
						i++;
						for( ; i<fmt.length && fmt[i] >= '0' && fmt[i] <= '9'; i++)
						{ // read integer for number of digits
							length *= 10;
							length += (fmt[i] - '0');
						}
					}

					if (fmt[i] == 'x')
					{ // hex conversion
						base = 16;
						signed = false;
					}
					else if (fmt[i] == 'd' || fmt[i] == 'l')
					{ // integer
						base = 10;
						signed = true;
					}
					else if (fmt[i] == 'u')
					{ // uinteger
						base = 10;
						signed = false;
					}

					{

						if (_arguments[curArg] == typeid(long))
						{
							argval = va_arg!(long)(_argptr);
							intToStr = true;
						}
						else if (_arguments[curArg] == typeid(ulong))
						{
							argval = cast(long)va_arg!(ulong)(_argptr);
							intToStr = true;
						}
						else if (_arguments[curArg] == typeid(int))
						{
							argval = cast(int)va_arg!(int)(_argptr);
							intToStr = true;
						}
						else if (_arguments[curArg] == typeid(uint))
						{
							argval = cast(uint)va_arg!(uint)(_argptr);
							intToStr = true;
						}
						else if (_arguments[curArg] == typeid(short))
						{
							argval = cast(short)va_arg!(short)(_argptr);
							intToStr = true;
						}
						else if (_arguments[curArg] == typeid(ushort))
						{
						argval = cast(ushort)va_arg!(ushort)(_argptr);
						intToStr = true;
						}
						else if (_arguments[curArg] == typeid(byte))
						{
							argval = cast(byte)va_arg!(byte)(_argptr);
							intToStr = true;
						}
						else if (_arguments[curArg] == typeid(ubyte))
						{
							argval = cast(ubyte)va_arg!(ubyte)(_argptr);
							intToStr = true;
						}

						if (intToStr)
						{
							// convert int to string
							// get length of potential string
							uint actualLength = 1;
							ulong tmpVal;

							bool negative;

							if (argval < 0)
							{
								negative = true;
								argval = -argval;
							}

							tmpVal = cast(ulong)(argval);

							// initial push
							tmpVal /= base;

							// finds the length
							while(tmpVal > 0)
							{
								tmpVal /= base;
								actualLength++;
							}

							if (actualLength < length) { actualLength = length; }

							// from this, we can determine how much of the string to add
							result ~= new dchar[actualLength];
							result[$-actualLength..$] = '0';

							// add the string
							uint valIndex;
							for(int o = result.length-1; ; o--)
							{
								valIndex = cast(uint)argval % base;
								if (valIndex >= 10)
								{
									result[o] = (valIndex - 10) + 'a';
								}
								else
								{
									result[o] = valIndex + '0';
								}
								argval /= base;

								if (argval == 0) { break; }
							}
						}

						curArg++;
					}


					if (curArg == _arguments.length)// just append the rest and not care
					{
						i++;
						result ~= fmt[i..$];
						break; // exit for
					}
				}
				else
				{
					result ~= fmt[i];
				}
			}

	`;
}

// Section: Core/Resources

// Description: A class that abstracts a character array with the native platform's perferred unicode format.
class String
{
	// Description: Will create an empty string.
	this()
	{
		this("");
	}

	// Description: Will create a string fitting the string passed through via the parameter.
	// str: The string to copy to the class.
	this (StringLiteral str, ...)
	{
		if (_arguments.length == 0) {
			_data ~= str;
		}
		else
		{
			// formatted string
			// perform format
			mixin(_StringFormat!());

			_data = Unicode.toNative(result);
		}
	}

	// Description: Will create a string fitting the string passed through via the parameter.
	// str: The string to copy to the class.
	this(String str)
	{
		_data ~= str._data[0..$];
	}

	// Description: Will create a string for the given integer.
	// val: The value to use.
	this(ulong val)
	{
		fromInteger(val);
	}

	// Description: Will return the length of the string.
	// Returns: The length of the string.
	uint length()
	{
		if (_data.length == 0)
		{
			return 0;
		}

		if (_calcIndices)
		{
			return _indices.length;
		}

		if (_calcLength)
		{
			return _length;
		}

		_length = Unicode.utflen(cast(StringLiteral)_data);

		_calcLength = true;

		return _length;
	}

	// Description: Will return the pointer to the character array.
	// Returns: An address to the internal character array for this String class.
	Char* ptr()
	{
		return _data.ptr;
	}

	// Description: Will return a reference to the internal character array.
	// Returns: A reference to the internal character array for this String class.
	Char[] array()
	{
		return _data;
	}

	// Description: Will append a String to the current String.  The internal character array is rebuilt.
	// str: The String to append to the internal character array of this String class.
	void append(String str)
	{
		_data ~= str._data;
		_length += str._length;
	}

	void append(StringLiteral str, ...)
	{
		if (_arguments.length == 0)
		{
			_data ~= str;
			_length += str.length;
		}
		else
		{
			// formatted string
			// perform format

			// scan input, write when appropriate
			mixin(_StringFormat!());

			StringLiteral res = Unicode.toNative(result);
			_data ~= res;
			_length += res.length;
		}
	}

	// Description: Will append a unicode character to this String.  The internal character array is rebuilt.
	// character: The unicode character to append to the internal character array of this String class.
	void appendChar(dchar character)
	{
		static if (Char.sizeof == dchar.sizeof)
		{
			_data ~= character;
			if (!Unicode.isDeadChar(character))
			{
				_length++;
			}
		}
		else
		{
			dchar[] charArray = [ character ];
			// BLEH
			static if(Char.sizeof == wchar.sizeof)
			{
				_data ~= Unicode.toUtf16(charArray);
			}
			else
			{
				char[] chrs = Unicode.toUtf8(charArray);
				_data ~= chrs;
			}

			if (!Unicode.isDeadChar(character))
			{
				_length++;
			}
		}
	}

	// Description: Will append a unicode character with combining marks to this String.  The internal character array is rebuilt.
	// characters: The unicode character to append to the internal character array of this String class.
	void appendChar(StringLiteral32 characters)
	{
		static if (Char.sizeof == dchar.sizeof)
		{
			_data ~= characters;
			if (!Unicode.isDeadChar(characters[0]))
			{
				_length++;
			}
		}
		else
		{
			static if(Char.sizeof == wchar.sizeof)
			{
				_data ~= Unicode.toUtf16Chars(characters);
			}
			else
			{
				_data ~= Unicode.toUtf8Chars(characters);
			}

			if (!Unicode.isDeadChar(characters[0]))
			{
				_length++;
			}
		}
	}

	String trim()
	{
		// find the start and end
		// slice the array

		int startpos;
		int endpos;

		for(startpos=0; startpos<_data.length; startpos++)
		{
			if (_data[startpos] != ' ' &&
				_data[startpos] != '\t' &&
				_data[startpos] != '\r' &&
				_data[startpos] != '\n')
			{
				break;
			}
		}

		for(endpos=_data.length-1; endpos>=0; endpos--)
		{
			if (_data[endpos] != ' ' &&
				_data[endpos] != '\t' &&
				_data[endpos] != '\r' &&
				_data[endpos] != '\n')
			{
				break;
			}
		}
		endpos++;

		return new String(cast(StringLiteral)_data[startpos..endpos]);
	}

	template _nextInt(T)
	{
		bool _nextInt(T)(T value)
		{
			int curpos;

			for(curpos=0; curpos<_data.length; curpos++)
			{
				if (_data[curpos] != ' ' &&
					_data[curpos] != '\t' &&
					_data[curpos] != '\r' &&
					_data[curpos] != '\n')
				{
					break;
				}
			}

			bool negative = false;

			if (_data[curpos] == '-')
			{
				negative = true;
				curpos++;
				if (curpos == _data.length) { return false; }
			}

			if (_data[curpos] < '0' ||
				_data[curpos] > '9')
			{
				return false;
			}

			long tmpval = 0;

			for (;curpos<_data.length;curpos++)
			{
				if (_data[curpos] < '0' ||
					_data[curpos] > '9')
				{
					break;
				}

				tmpval *= 10;
				tmpval += cast(long)(_data[curpos] - '0');
			}

			if (negative) { tmpval = -tmpval; }

			value = cast(T)tmpval;

			return true;
		}
	}

	// Description: This function will return the next integer value found in the string.
	bool nextInt(out int value)
	{
		return _nextInt!(int)(value);
	}

	bool nextInt(out uint value)
	{
		return _nextInt!(uint)(value);
	}

	bool nextInt(out long value)
	{
		return _nextInt!(long)(value);
	}

	bool nextInt(out ulong value)
	{
		return _nextInt!(ulong)(value);
	}

	bool nextInt(out short value)
	{
		return _nextInt!(short)(value);
	}

	bool nextInt(out ushort value)
	{
		return _nextInt!(ushort)(value);
	}

	bool next(out String value, StringLiteral delimiters)
	{
		return false;
	}

	int find(String search)
	{
		// look through string for term search
		// in some, hopefully later on, efficient manner

		if (!_calcIndices)
		{
			_indices = Unicode.calcIndices(cast(StringLiteral)_data);
			_calcIndices = true;
		}

		if (!search._calcIndices)
		{
			search._indices = Unicode.calcIndices(cast(StringLiteral)search._data);
			search._calcIndices = true;
		}

		bool found;

		int o;

		foreach (i, aPos; _indices)
		{
			found = true;
			o=i;
			foreach (bPos; search._indices)
			{
				dchar aChr, bChr;

				aChr = Unicode.toUtf32Char(cast(StringLiteral)_data[_indices[o]..$]);
				bChr = Unicode.toUtf32Char(cast(StringLiteral)search._data[bPos..$]);

				if (aChr != bChr)
				{
					found = false;
					break;
				}

				o++;
				if (o >= _indices.length)
				{
					found = false;
					break;
				}
			}
			if (found)
			{
				return i;
			}
		}

		return -1;
	}

	// Description: Will convert the string to lowercase.
	// Returns: The lowercase version of the current string.
	String toLowercase()
	{
		if (!_calcIndices)
		{
			_calcIndices = true;
			_indices = Unicode.calcIndices(_data);
		}

		String str = new String("");

		foreach(idx; _indices)
		{
			dchar chr = Unicode.toUtf32Char(_data[idx..$]);

			if (chr >= 'A' && chr <= 'Z')
			{
				chr += 32;
			}

			str.appendChar(chr);
		}

		return str;
	}

	// Description: Will convert the string to uppercase.
	// Returns: The uppercase version of the current string.
	String toUppercase()
	{
		if (!_calcIndices)
		{
			_calcIndices = true;
			_indices = Unicode.calcIndices(cast(StringLiteral)_data);
		}

		String str = new String("");

		foreach(index; _indices)
		{
			dchar chr = Unicode.toUtf32Char(cast(StringLiteral)_data[index..$]);

			if (chr >= 'a' && chr <= 'z')
			{
				chr -= 32;
			}

			str.appendChar(chr);
		}

		return str;
	}


	// Description: Will build and return a String object representing a slice of the current String.
	// start: The position to start from.
	// len: The length of the slice.  Pass -1 to get the remaining string.
	String subString(int start, int len = -1)
	{
		if (!_calcIndices)
		{
			_calcIndices = true;
			_indices = Unicode.calcIndices(cast(StringLiteral)_data);
		}

		if (start >= _indices.length || len == 0)
		{
			return new String("");
		}

		if (start + len >= _indices.length)
		{
			len = -1;
		}

		// subdivide

		start = _indices[start];

		String str;
		if (len == -1)
		{
			return new String(cast(StringLiteral)_data[start..$]);
		}

		// this is the index for one character past the
		// end of the substring of the original string...hence, len is
		// now the exclusive end of the range to slice the array.
		len = _indices[start+len];

		return new String(cast(StringLiteral)_data[start..len]);
	}

	// Description: Will return the UTF-32 character from the position given.  This will ignore combining marks!  Do not use unless you wish to compute the size of the character, where this function would be more efficient.  Otherwise, to ensure that internationalization is supported, use utfCharAt.
	// position: The character index to retreive.
	// Returns: The UTF-32 character at this position, without combining marks.
	dchar charAt(uint position)
	{
		if (!_calcIndices)
		{
			_calcIndices = true;
			_indices = Unicode.calcIndices(cast(StringLiteral)_data);
		}

		if (position >= _indices.length)
		{
			position = 0;
		}

		// convert the character starting at that position to a dchar

		return Unicode.toUtf32Char(cast(StringLiteral)_data[_indices[position]..$]);
	}

	// Description: Will return the UTF-32 character along with any combining marks.
	// Returns: An array of UTF-32 characters.  The first character is the valid UTF-32 character base, and the rest of the dchars are combining marks.
	// position: The character index to retreive.
	dchar[] utfCharAt(uint position)
	{
		if (!_calcIndices)
		{
			_calcIndices = true;
			_indices = Unicode.calcIndices(cast(StringLiteral)_data);
		}

		if (position >= _indices.length)
		{
			position = 0;
		}

		// convert the character starting at that position to a dchar

		return Unicode.toUtf32Chars(cast(StringLiteral)_data[_indices[position]..$]);
	}

	// Description: Will cast the String object to a StringLiteral for functions that require it.
	StringLiteral opCast()
	{
		return cast(StringLiteral)_data;
	}

	// Unicode Conversions

	// Description: Will return a Unicode character array for this string in UTF-32.
	StringLiteral32 toUtf32()
	{
		static if (Char.sizeof == dchar.sizeof)
		{
			// no change!
			return cast(StringLiteral32)_data;
		}
		else
		{
			return Unicode.toUtf32(cast(StringLiteral)_data);
		}
	}

	// Description: Will return a Unicode character array for this string in UTF-16.
	StringLiteral16 toUtf16()
	{
		static if (Char.sizeof == wchar.sizeof)
		{
			// no change!
			return cast(StringLiteral16)_data;
		}
		else
		{
			return Unicode.toUtf16(cast(StringLiteral)_data);
		}
	}

	// Description: Will return a Unicode character array for this string in UTF-8.
	StringLiteral8 toUtf8()
	{
		static if (Char.sizeof == char.sizeof)
		{
			// no change!
			return cast(StringLiteral8)_data;
		}
		else
		{
			return Unicode.toUtf8(cast(StringLiteral)_data);
		}
	}

	bool opEquals(StringLiteral stringLiteral)
	{
		if (stringLiteral.length != _data.length)
		{
			return false;
		}

		if (_data[0..$] != stringLiteral[0..$])
		{
			return false;
		}

		return true;
	}

	// this should work:
	alias Object.opEquals opEquals;

	bool opEquals(String string)
	{
		if (string._data.length != _data.length)
		{
			return false;
		}

		if (_data[0..$] != string._data[0..$])
		{
			return false;
		}

		return true;
	}

	void fromInteger(ulong val)
	{
	    int intlen;
	    ulong tmp = val;

	    bool negative;

	    if (tmp < 0)
	    {
	        negative = true;
	        tmp = -tmp;
	        intlen = 2;
	    }
	    else
	    {
	        negative = false;
	        intlen = 1;
	    }

	    while (tmp > 9)
	    {
	        tmp /= 10;
	        intlen++;
	    }

	    //allocate

	    _data = new Char[intlen];

	    // we know the length
	    _calcLength = true;
	    _length = intlen;

	    // we also know the indices!!!

	    intlen--;

	    if (negative) {
	        tmp = -val;
	    } else {
	        tmp = val;
	    }

	    do
	    {
	        _data[intlen] = '0' + (tmp % 10);
	        tmp /= 10;
	        intlen--;
	    } while (tmp != 0);


	    if (negative)
	    {
	        _data[intlen] = '-';
	    }

		_calcIndices = false;
		_calcLength = false;
	}

	// array operator overloads
	StringLiteral opSlice()
	{
		return _data;
	}

	StringLiteral opSlice(size_t start)
	{
		size_t end = _data.length;

		if (start < 0) { start = 0; }

		if (!_calcIndices)
		{
			_calcIndices = true;
			_indices = Unicode.calcIndices(cast(StringLiteral)_data);
		}

		if (end >= _indices.length)
		{
			end = _data.length;
		}
		else
		{
			end = _indices[end];
		}

		return _data[start..end];
	}

	StringLiteral opSlice(size_t start, size_t end)
	{
		if (start < 0) { start = 0; }

		if (!_calcIndices)
		{
			_calcIndices = true;
			_indices = Unicode.calcIndices(cast(StringLiteral)_data);
		}

		if (end >= _indices.length)
		{
			end = _data.length;
		}
		else
		{
			end = _indices[end];
		}

		return _data[start..end];
	}

	//StringLiteral opSliceAssign(T val)
	//{
	//	return _components[] = val;
	//}

	//StringLiteral opSliceAssign(T[] val)
	//{
	//	return _components[] = val;
	//}

	//StringLiteral opSliceAssign(T val, size_t x, size_t y)
	//{
	//	return _components[x..y] = val;
	//}

	//StringLiteral opSliceAssign(T[] val, size_t x, size_t y)
	//{
	//	return _components[x..y] = val;
	//}

	Char opIndex(size_t i)
	{
		return charAt(i);
	}

	//StringLiteral opIndexAssign(T value, size_t i)
	//{
	//	return _components[i] = value;
	//}

	String opCat(StringLiteral string)
	{
		String newStr = new String(this);
		newStr.append(string);

		return newStr;
	}

	String opCat(String string)
	{
		String newStr = new String(this);
		newStr.append(string);

		return newStr;
	}

	int opApply(int delegate(inout dchar) loopFunc)
	{
		int ret;

		dchar[] utf32 = toUtf32();

		foreach(chr; utf32)
		{
			ret = loopFunc(chr);
			if (ret) { break; }
		}

		return ret;
	}

	int opApplyReverse(int delegate(inout dchar) loopFunc)
	{
		int ret;

		dchar[] utf32 = toUtf32();

		foreach_reverse(chr; utf32)
		{
			ret = loopFunc(chr);
			if (ret) { break; }
		}

		return ret;
	}

	int opApply(int delegate(inout int, inout dchar) loopFunc)
	{
		int ret;

		int idx = 0;

		dchar[] utf32 = toUtf32();

		foreach(chr; utf32)
		{
			ret = loopFunc(idx,chr);
			idx++;
			if (ret) { break; }
		}

		return ret;
	}

	int opApplyReverse(int delegate(inout int, inout dchar) loopFunc)
	{
		int ret;
		int idx = length();

		dchar[] utf32 = toUtf32();

		foreach_reverse(chr; utf32)
		{
			idx--;
			ret = loopFunc(idx,chr);
			if (ret) { break; }
		}

		return ret;
	}

private:
	uint _length;

	bool _calcLength; 		// whether the length has been calculated

	uint[] _indices;		// refer within the string for each character

	bool _calcIndices;		// whether the indices have been calculated

	uint _capacity;
	Char _data[];
}
