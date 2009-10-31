/*
 * string.d
 *
 * This file contains the native String class. A string class that wraps a
 * string that is represented in the native preferred unicode class.
 *
 * Author: Dave Wilkinson
 *
 */

module core.string;

// a class to encapsulate the expected string format for
// the underlying OS platform in use

import core.definitions;
import core.unicode;
import core.format;
import core.variant;

public import core.string;

template _StringFormat() {
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

			for(int i=0; i<fmt.length; i++) {
				if (fmt[i] == '%') {
					i++;
					length = 0;
					if (fmt[i] == '.') {
						i++;
						for( ; i<fmt.length && fmt[i] >= '0' && fmt[i] <= '9'; i++) {
							// read integer for number of digits
							length *= 10;
							length += (fmt[i] - '0');
						}
					}

					if (fmt[i] == 'x') {
						// hex conversion
						base = 16;
						signed = false;
					}
					else if (fmt[i] == 'd' || fmt[i] == 'l') {
						// integer
						base = 10;
						signed = true;
					}
					else if (fmt[i] == 'u') {
						// uinteger
						base = 10;
						signed = false;
					}

					{

						if (_arguments[curArg] == typeid(long)) {
							argval = va_arg!(long)(_argptr);
							intToStr = true;
						}
						else if (_arguments[curArg] == typeid(ulong)) {
							argval = cast(long)va_arg!(ulong)(_argptr);
							intToStr = true;
						}
						else if (_arguments[curArg] == typeid(int)) {
							argval = cast(int)va_arg!(int)(_argptr);
							intToStr = true;
						}
						else if (_arguments[curArg] == typeid(uint)) {
							argval = cast(uint)va_arg!(uint)(_argptr);
							intToStr = true;
						}
						else if (_arguments[curArg] == typeid(short)) {
							argval = cast(short)va_arg!(short)(_argptr);
							intToStr = true;
						}
						else if (_arguments[curArg] == typeid(ushort)) {
							argval = cast(ushort)va_arg!(ushort)(_argptr);
							intToStr = true;
						}
						else if (_arguments[curArg] == typeid(byte)) {
							argval = cast(byte)va_arg!(byte)(_argptr);
							intToStr = true;
						}
						else if (_arguments[curArg] == typeid(ubyte)) {
							argval = cast(ubyte)va_arg!(ubyte)(_argptr);
							intToStr = true;
						}

						if (intToStr) {
							// convert int to string
							// get length of potential string
							uint actualLength = 1;
							ulong tmpVal;

							bool negative;

							if (argval < 0) {
								negative = true;
								argval = -argval;
							}

							tmpVal = cast(ulong)(argval);

							// initial push
							tmpVal /= base;

							// finds the length
							while(tmpVal > 0) {
								tmpVal /= base;
								actualLength++;
							}

							if (actualLength < length) { actualLength = length; }

							// from this, we can determine how much of the string to add
							result ~= new dchar[actualLength];
							result[$-actualLength..$] = '0';

							// add the string
							uint valIndex;
							for(int o = result.length-1; ; o--) {
								valIndex = cast(uint)argval % base;
								if (valIndex >= 10) {
									result[o] = (valIndex - 10) + 'a';
								}
								else {
									result[o] = valIndex + '0';
								}
								argval /= base;

								if (argval == 0) { break; }
							}
						}

						curArg++;
					}

					if (curArg == _arguments.length) { // just append the rest and not care
						i++;
						result ~= fmt[i..$];
						break; // exit for
					}
				}
				else {
					result ~= fmt[i];
				}
			}

	`;
}

// Section: Core/Resources

// Description: A class that abstracts a character array with the native platform's perferred unicode format.
class String {

	// Description: Will create an empty string.
	this() {
		this("");
	}

	// Description: Will create a string fitting the string passed through via the parameter.
	// str: The string to copy to the class.
	this (string str, ...) {
		if (_arguments.length == 0) {
			_data = Unicode.toNative(str);
		}
		else {
			// formatted string
			// perform format
			mixin(_StringFormat!());

			_data = Unicode.toNative(result);
		}
	}

	// Description: Will create a string fitting the string passed through via the parameter.
	// str: The string to copy to the class.
	this(String str) {
		_data ~= str._data;
	}

	// Description: Will create a string for the given integer.
	// val: The value to use.
	this(long val) {
		fromInteger(val);
	}

	// Description: Will return the length of the string.
	// Returns: The length of the string.
	uint length() {
		if (_data.length == 0) {
			return 0;
		}

		if (_calcIndices) {
			return _indices.length;
		}

		if (_calcLength) {
			return _length;
		}

		_length = Unicode.utflen(_data);

		_calcLength = true;

		return _length;
	}

	// Description: Will return the pointer to the character array.
	// Returns: An address to the internal character array for this String class.
	Char* ptr() {
		return _data.ptr;
	}

	// Description: Will return a reference to the internal character array.
	// Returns: A reference to the internal character array for this String class.
	Char[] array() {
		return _data;
	}

	// Description: Will append a String to the current String.  The internal character array is rebuilt.
	// str: The String to append to the internal character array of this String class.
	void append(String str) {
		_data ~= str._data.dup;
		if (str._calcLength) {
			_length += str._length;
		}
		else {
			_calcLength = false;
		}
		_calcIndices = false;
	}

	void append(string str, ...) {
		_calcLength = false;
		_calcIndices = false;
		if (_arguments.length == 0) {
			_data ~= Unicode.toNative(str);
		}
		else {
			// formatted string
			// perform format

			// scan input, write when appropriate
			mixin(_StringFormat!());

			_data ~= Unicode.toNative(result);
		}
	}

	// Description: Will append a unicode character to this String.  The internal character array is rebuilt.
	// character: The unicode character to append to the internal character array of this String class.
	void appendChar(dchar character) {
		_calcIndices = false;
		static if (Char.sizeof == dchar.sizeof) {
			_data ~= character;
			if (!Unicode.isDeadChar(character)) {
				_length++;
			}
		}
		else {
			dchar[] charArray = [ character ];
			// BLEH
			static if(Char.sizeof == wchar.sizeof) {
				_data ~= Unicode.toUtf16(charArray);
			}
			else {
				char[] chrs = Unicode.toUtf8(charArray);
				_data ~= chrs;
			}

			if (!Unicode.isDeadChar(character)) {
				_length++;
			}
		}
	}

	// Description: Will append a unicode character with combining marks to this String.  The internal character array is rebuilt.
	// characters: The unicode character to append to the internal character array of this String class.
	void appendChar(dstring characters) {
		static if (Char.sizeof == dchar.sizeof) {
			_data ~= characters;
			if (!Unicode.isDeadChar(characters[0])) {
				_length++;
			}
		}
		else {
			static if(Char.sizeof == wchar.sizeof) {
				_data ~= Unicode.toUtf16Chars(characters);
			}
			else {
				_data ~= Unicode.toUtf8Chars(characters);
			}

			if (!Unicode.isDeadChar(characters[0])) {
				_length++;
			}
		}
	}

	// Description: Inserts a String at an arbitrary position.
	void insertAt(String s, uint pos) {
		if (pos >= this.length())
			return;
		String rest = new String(this.subString(pos));
		this = this.subString(0, pos);
		this.append(s);
		this.append(rest);
	}

	void insertAt(string s, uint pos) {
		insertAt(new String(s), pos);
	}

	// Description: Repeats a given string.
	// Returns: s repeated n times.
	static String repeat(String s, uint n) {
		String ret = new String();

		for (uint i = 0; i < n; i++) {
			ret.append(s);
		}

		return ret;
	}

	static String repeat(string s, uint n) {
		return repeat(new String(s), n);
	}

	String trim() {
		// find the start and end
		// slice the array

		int startpos;
		int endpos;

		for(startpos=0; startpos<_data.length; startpos++) {
			if (_data[startpos] != ' ' &&
				_data[startpos] != '\t' &&
				_data[startpos] != '\r' &&
				_data[startpos] != '\n') {

				break;
			}
		}

		for(endpos=_data.length-1; endpos>=0; endpos--) {
			if (_data[endpos] != ' ' &&
				_data[endpos] != '\t' &&
				_data[endpos] != '\r' &&
				_data[endpos] != '\n') {

				break;
			}
		}
		endpos++;

		String ret = new String("");
		ret._data = _data[startpos..endpos];
		return ret;
	}

	template _nextInt(T) {
		bool _nextInt(T)(T value) {
			int curpos;

			for(curpos=0; curpos<_data.length; curpos++) {
				if (_data[curpos] != ' ' &&
					_data[curpos] != '\t' &&
					_data[curpos] != '\r' &&
					_data[curpos] != '\n') {

					break;
				}
			}

			bool negative = false;

			if (_data[curpos] == '-') {
				negative = true;
				curpos++;
				if (curpos == _data.length) { return false; }
			}

			if (_data[curpos] < '0' ||
				_data[curpos] > '9') {

				return false;
			}

			long tmpval = 0;

			for (;curpos<_data.length;curpos++) {
				if (_data[curpos] < '0' ||
					_data[curpos] > '9') {

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
	bool nextInt(out int value) {
		return _nextInt!(int)(value);
	}

	bool nextInt(out uint value) {
		return _nextInt!(uint)(value);
	}

	bool nextInt(out long value) {
		return _nextInt!(long)(value);
	}

	bool nextInt(out ulong value) {
		return _nextInt!(ulong)(value);
	}

	bool nextInt(out short value) {
		return _nextInt!(short)(value);
	}

	bool nextInt(out ushort value) {
		return _nextInt!(ushort)(value);
	}

	bool next(out String value, string delimiters) {
		return false;
	}

	int findReverse(String search) {
		// look through string for term search
		// in some, hopefully later on, efficient manner

		if (!_calcIndices) {
			_indices = Unicode.calcIndices(_data);
			_calcIndices = true;
		}

		if (!search._calcIndices) {
			search._indices = Unicode.calcIndices(search._data);
			search._calcIndices = true;
		}

		bool found;

		int o;
		int i;
		int aPos;

		for (i=_indices.length-1; i>=0; i--) {
			aPos = _indices[i];

			found = true;
			o=i;
			foreach (bPos; search._indices) {
				dchar aChr, bChr;

				aChr = Unicode.toUtf32Char(_data[_indices[o]..$]);
				bChr = Unicode.toUtf32Char(search._data[bPos..$]);

				if (aChr != bChr) {
					found = false;
					break;
				}

				o++;
				if (o >= _indices.length) {
					found = false;
					break;
				}
			}
			if (found) {
				return i;
			}
		}

		return -1;
	}

	int find(string search, uint start = 0) {
		return find(new String(search), start);
	}

	int find(String search, uint start = 0) {
		// look through string for term search
		// in some, hopefully later on, efficient manner

		if (!_calcIndices) {
			_indices = Unicode.calcIndices(_data);
			_calcIndices = true;
		}

		if (!search._calcIndices) {
			search._indices = Unicode.calcIndices(search._data);
			search._calcIndices = true;
		}

		if (start >= _indices.length) {
			return -1;
		}

		bool found;

		int o;

		foreach (i, aPos; _indices[start..$]) {
			found = true;
			o=i-1+start;
			foreach (bPos; search._indices) {
				o++;
				if (o >= _indices.length) {
					found = false;
					break;
				}

				dchar aChr, bChr;

				aChr = Unicode.toUtf32Char(_data[_indices[o]..$]);
				bChr = Unicode.toUtf32Char(search._data[bPos..$]);

				if (aChr != bChr) {
					found = false;
					break;
				}
			}
			if (found) {
				return i;
			}
		}

		return -1;
	}

	String replace(dchar find, dchar replace) {
		String ret = new String(this);

		if (!ret._calcIndices) {
			ret._indices = Unicode.calcIndices(ret._data);
			ret._calcIndices = true;
		}

		for(int i = 0; i < ret._indices.length; i++) {
			if (ret.charAt(i) == find) {
				ret._calcIndices = false;
				dchar[1] chrs = [replace];
				ret._data = ret._data[0..ret._indices[i]] ~ Unicode.toNative(chrs) ~ ret._data[ret._indices[i+1]..$];
			}

			if (!ret._calcIndices) {
				ret._indices = Unicode.calcIndices(ret._data);
				ret._calcIndices = true;
			}
		}

		return ret;
	}

	// Description: Will convert the string to lowercase.
	// Returns: The lowercase version of the current string.
	String toLowercase() {
		if (!_calcIndices) {
			_calcIndices = true;
			_indices = Unicode.calcIndices(_data);
		}

		String str = new String("");

		foreach(idx; _indices) {
			dchar chr = Unicode.toUtf32Char(_data[idx..$]);

			if (chr >= 'A' && chr <= 'Z') {
				chr += 32;
			}

			str.appendChar(chr);
		}

		return str;
	}

	// Description: Will convert the string to uppercase.
	// Returns: The uppercase version of the current string.
	String toUppercase() {
		if (!_calcIndices) {
			_calcIndices = true;
			_indices = Unicode.calcIndices(_data);
		}

		String str = new String("");

		foreach(index; _indices) {
			dchar chr = Unicode.toUtf32Char(_data[index..$]);

			if (chr >= 'a' && chr <= 'z') {
				chr -= 32;
			}

			str.appendChar(chr);
		}

		return str;
	}

	// Description: Will build and return a String object representing a slice of the current String.
	// start: The position to start from.
	// len: The length of the slice.  Pass -1 to get the remaining string.
	String subString(int start, int len = -1) {
		if (!_calcIndices) {
			_calcIndices = true;
			_indices = Unicode.calcIndices(_data);
		}

		if (start >= _indices.length || len == 0) {
			return new String("");
		}

		if (len < 0) { len = -1; }

		if (len >= 0 && start + len >= _indices.length) {
			len = -1;
		}

		// subdivide

		String str;
		if (len == -1) {
			start = _indices[start];
			String ret = new String("");
			ret._data = _data[start..$];
			return ret;
		}

		// this is the index for one character past the
		// end of the substring of the original string...hence, len is
		// now the exclusive end of the range to slice the array.
		len = _indices[start+len];

		start = _indices[start];

		String ret = new String();
		ret._data = _data[start..len];
		return ret;
	}

	// Description: Will return the UTF-32 character from the position given.  This will ignore combining marks!  Do not use unless you wish to compute the size of the character, where this function would be more efficient.  Otherwise, to ensure that internationalization is supported, use utfCharAt.
	// position: The character index to retreive.
	// Returns: The UTF-32 character at this position, without combining marks.
	dchar charAt(uint position) {
		if (!_calcIndices) {
			_calcIndices = true;
			_indices = Unicode.calcIndices(_data);
		}

		if (position >= _indices.length) {
			return '\0';
		}

		if (_indices.length == 0) {
			return '\0';
		}

		// convert the character starting at that position to a dchar

		return Unicode.toUtf32Char(_data[_indices[position]..$]);
	}

	void setCharAt(uint position, dchar value) {
		if (!_calcIndices) {
			_calcIndices = true;
			_indices = Unicode.calcIndices(_data);
		}

		if (position >= _indices.length) {
			position = 0;
		}

		if (_indices.length == 0) {
			return;
		}

		_calcIndices = false;
		dchar[1] chrs = [value];
		_data = _data[0.._indices[position]] ~ Unicode.toNative(chrs) ~ _data[_indices[position+1]..$];
	}

	// Description: Will return the UTF-32 character along with any combining marks.
	// Returns: An array of UTF-32 characters.  The first character is the valid UTF-32 character base, and the rest of the dchars are combining marks.
	// position: The character index to retreive.
	dchar[] utfCharAt(uint position) {
		if (!_calcIndices) {
			_calcIndices = true;
			_indices = Unicode.calcIndices(_data);
		}

		if (position >= _indices.length) {
			position = 0;
		}

		// convert the character starting at that position to a dchar

		return Unicode.toUtf32Chars(_data[_indices[position]..$]);
	}

	// Description: Will cast the String object to a string for functions that require it.
	//string opCast() {
	//	return toString();
	//}

	// Unicode Conversions

	// Description: Will return a Unicode character array for this string in UTF-32.
	dstring toUtf32() {
		static if (Char.sizeof == dchar.sizeof) {
			// no change!
			return cast(dstring)_data;
		}
		else {
			return Unicode.toUtf32(_data);
		}
	}

	// Description: Will return a Unicode character array for this string in UTF-16.
	wstring toUtf16() {
		static if (Char.sizeof == wchar.sizeof) {
			// no change!
			return cast(wstring)_data;
		}
		else {
			return Unicode.toUtf16(_data);
		}
	}

	// Description: Will return a Unicode character array for this string in UTF-8.
	string toUtf8() {
		static if (Char.sizeof == char.sizeof) {
			// no change!
			return _data;
		}
		else {
			return Unicode.toUtf8(_data);
		}
	}

	bool opEquals(string string) {
		if (string.length != _data.length) {
			return false;
		}

		if (_data[0..$] != Unicode.toNative(string[0..$])) {
			return false;
		}

		return true;
	}

	// this should work:
	alias Object.opEquals opEquals;

	bool opEquals(String string) {
		if (string._data.length != _data.length) {
			return false;
		}

		if (_data[0..$] != string._data[0..$]) {
			return false;
		}

		return true;
	}

	void fromInteger(long val) {
		int intlen;
		long tmp = val;

	    bool negative;

	    if (tmp < 0) {
	        negative = true;
	        tmp = -tmp;
	        intlen = 2;
	    }
	    else {
	        negative = false;
	        intlen = 1;
	    }

	    while (tmp > 9) {
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

	    do {
	        _data[intlen] = cast(Char)('0' + (tmp % 10));
	        tmp /= 10;
	        intlen--;
	    } while (tmp != 0);


	    if (negative) {
	        _data[intlen] = '-';
	    }

		_calcIndices = false;
		_calcLength = false;
	}

	// array operator overloads
	string opSlice() {
		return Unicode.toUtf8(_data);
	}

	string opSlice(size_t start) {
		size_t end = _data.length;

		if (start < 0) { start = 0; }

		if (!_calcIndices) {
			_calcIndices = true;
			_indices = Unicode.calcIndices(_data);
		}

		if (end >= _indices.length) {
			end = _data.length;
		}
		else {
			end = _indices[end];
		}

		if (start > end) { return ""; }

		return Unicode.toUtf8(_data[start..end]);
	}

	string opSlice(size_t start, size_t end) {
		if (start < 0) { start = 0; }

		if (!_calcIndices) {
			_calcIndices = true;
			_indices = Unicode.calcIndices(_data);
		}

		if (end >= _indices.length) {
			end = _data.length;
		}
		else {
			end = _indices[end];
		}

		if (start > end) { return ""; }

		return Unicode.toUtf8(_data[start..end]);
	}

	//string opSliceAssign(T val)
	//{
	//	return _components[] = val;
	//}

	//string opSliceAssign(T[] val)
	//{
	//	return _components[] = val;
	//}

	//string opSliceAssign(T val, size_t x, size_t y)
	//{
	//	return _components[x..y] = val;
	//}

	//string opSliceAssign(T[] val, size_t x, size_t y)
	//{
	//	return _components[x..y] = val;
	//}

	Char opIndex(size_t i) {
		return charAt(i);
	}

	void opIndexAssign(size_t i, dchar val) {
		setCharAt(i, val);
	}

	//string opIndexAssign(T value, size_t i)
	//{
	//	return _components[i] = value;
	//}

	String opCat(string string) {
		String newStr = new String(this);
		newStr.append(string);

		return newStr;
	}

	void opCatAssign(string str) {
		append(str);
	}

	String opCat(String string) {
		String newStr = new String(this);
		newStr.append(string);

		return newStr;
	}

	void opCatAssign(String str) {
		append(str);
	}

	String opCat(dchar chr) {
		String newStr = new String(this);
		newStr.appendChar(chr);

		return newStr;
	}

	void opCatAssign(dchar chr) {
		appendChar(chr);
	}

	int opApply(int delegate(inout dchar) loopFunc) {
		int ret;

		dchar[] utf32 = toUtf32();

		foreach(chr; utf32) {
			ret = loopFunc(chr);
			if (ret) { break; }
		}

		return ret;
	}

	int opApplyReverse(int delegate(inout dchar) loopFunc) {
		int ret;

		dchar[] utf32 = toUtf32();

		foreach_reverse(chr; utf32) {
			ret = loopFunc(chr);
			if (ret) { break; }
		}

		return ret;
	}

	int opApply(int delegate(inout int, inout dchar) loopFunc) {
		int ret;

		int idx = 0;

		dchar[] utf32 = toUtf32();

		foreach(chr; utf32) {
			ret = loopFunc(idx,chr);
			idx++;
			if (ret) { break; }
		}

		return ret;
	}

	int opApplyReverse(int delegate(inout int, inout dchar) loopFunc) {
		int ret;
		int idx = length();

		dchar[] utf32 = toUtf32();

		foreach_reverse(chr; utf32) {
			idx--;
			ret = loopFunc(idx,chr);
			if (ret) { break; }
		}

		return ret;
	}
	
	int opCmp(Object o) {
		if (cast(String)o) {
			String str = cast(String)o;
			if (_data < str._data) {
				return -1;
			}
			else if (_data == str._data) {
				return 0;
			}
			return 1;
		}
		return 0;
	}

	int opCmp(string str) {
		return opCmp(new String(str));
	}

	override char[] toString() {
		return Unicode.toUtf8(_data);
	}

private:
	uint _length;

	bool _calcLength; 		// whether the length has been calculated

	uint[] _indices;		// refer within the string for each character

	bool _calcIndices;		// whether the indices have been calculated

	uint _capacity;
	Char _data[];
}

// Standard string functions (for C)

// strlen
size_t strlen(char* chr) {
	size_t ret = 0;
	while(*chr++) {
		ret++;
	}
	return ret;
}

size_t strlen(wchar* chr) {
	size_t ret = 0;
	while(*chr++) {
		ret++;
	}
	return ret;
}

void strncpy(char* dest, char* src, int length) {
	while(((*dest++ = *src++) != 0) && --length){}
	*(--dest) = '\0';
}

void strncat(char* dest, char* src, int length) {
	while(*dest++){}
	strncpy(--dest,src,length);
}

int strcmp(char* a, char* b) {
	while((*a == *b) && *a++ && *b++){}
	return *a - *b;
}

int strncmp(char* a, char* b, int length) {
	while(--length && (*a == *b) && *a++ && *b++){}
	return *a - *b;
}

void strcpy(char* dest, char* src) {
	while((*dest++ = *src++) != 0){}
}

void strcat(char* dest, char* src) {
	while(*dest++){}
	strcpy(--dest,src);
}

void strupr(char* str) {
	while(*str) {
		if (*str >= 'a' || *str <= 'z') {
			*str -= 32;
		}
		str++;
	}
}

void strlwr(char* str) {
    while(*str) {
		if (*str >= 'A' || *str <= 'Z') {
			*str += 32;
		}
		str++;
	}
}

