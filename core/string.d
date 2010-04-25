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
import core.variant;
import io.console;

public import core.string;

string toStrv(Variadic vars) {
	string ret = "";
	foreach(var; vars) {
		ret ~= var.toString();
	}
	return ret;
}

string toStr(...) {
	Variadic vars = new Variadic(_arguments, _argptr);

	return toStrv(vars);
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

string trim(string chrs) {
	size_t idx_s, idx_e;

	idx_e = chrs.length;

	while (idx_s < chrs.length && (chrs[idx_s] == ' ' || chrs[idx_s] == '\t' || chrs[idx_s] == '\n' || chrs[idx_s] == '\r')) {
		idx_s++;
	}

	while (idx_e > 0 && (chrs[idx_e-1] == ' ' || chrs[idx_e-1] == '\t' || chrs[idx_e-1] == '\n' || chrs[idx_e-1] == '\r')) {
		idx_e--;
	}

	if (idx_s >= idx_e) {
		return "";
	}

	return chrs[idx_s..idx_e].dup;
}

string[] split(string input, string delims) {
	string[] retstring;
	size_t last;

	foreach(size_t i, char c; input) {
		foreach(char d; delims) {
			if (c == d) {
				retstring ~= input[last..i];
				last = i+1;
			}
		}
	}
	
	retstring ~= input[last..$];

	return retstring;
}

string[] split(string input, char delim) {
	string[] retstring;
	size_t last;

	foreach(size_t i, char c; input) {
		if (c == delim) {
			retstring ~= input[last..i];
			last = i+1;
		}
	}

	retstring ~= input[last..$];

	return retstring;
}

template _nextInt(T) {
	bool _nextInt(T)(string str, out T value) {
		int curpos;
		if (str.length == 0) {
			return false;
		}

		for(curpos=0; curpos<str.length; curpos++) {
			if (str[curpos] != ' ' &&
					str[curpos] != '\t' &&
					str[curpos] != '\r' &&
					str[curpos] != '\n') {

				break;
			}
		}

		bool negative = false;

		if (str[curpos] == '-') {
			negative = true;
			curpos++;
			if (curpos == str.length) { return false; }
		}

		if (str[curpos] < '0' ||
				str[curpos] > '9') {

			return false;
		}

		long tmpval = 0;

		for (;curpos<str.length;curpos++) {
			if (str[curpos] < '0' ||
					str[curpos] > '9') {

				break;
			}

			tmpval *= 10;
			tmpval += cast(long)(str[curpos] - '0');
		}

		if (negative) { tmpval = -tmpval; }

		value = cast(T)tmpval;

		return true;
	}
}

// Description: This function will return the next integer value found in the string.
bool nextInt(string str, out int value) {
	return _nextInt!(int)(str, value);
}

bool nextInt(string str, out uint value) {
	return _nextInt!(uint)(str, value);
}

bool nextInt(string str, out long value) {
	return _nextInt!(long)(str, value);
}

bool nextInt(string str, out ulong value) {
	return _nextInt!(ulong)(str, value);
}

bool nextInt(string str, out short value) {
	return _nextInt!(short)(str, value);
}

bool nextInt(string str, out ushort value) {
	return _nextInt!(ushort)(str, value);
}

// Description: Will build and return a String object representing a slice of the current String.
// start: The position to start from.
// len: The length of the slice.  Pass -1 to get the remaining string.
string substring(string str, int start, int len = -1) {
	uint[] _indices = Unicode.calcIndices(str);

	if (start >= _indices.length || len == 0) {
		return "";
	}

	if (len < 0) { len = -1; }

	if (len >= 0 && start + len >= _indices.length) {
		len = -1;
	}

	// subdivide

	if (len == -1) {
		start = _indices[start];
		string ret = "";
		ret = str[start..$].dup;
		return ret;
	}

	// this is the index for one character past the
	// end of the substring of the original string...hence, len is
	// now the exclusive end of the range to slice the array.
	len = _indices[start+len];

	start = _indices[start];

	string ret = "";
	ret = str[start..len].dup;
	return ret;
}

string replace(string str, dchar find, dchar replace) {
	string ret = str.dup;
	uint[] _indices = Unicode.calcIndices(str);

	for(int i = 0; i < _indices.length; i++) {
		dchar cmpChar = Unicode.toUtf32Char(ret[_indices[i]..$]);
		if (cmpChar == find) {
			dchar[1] chrs = [replace];
			ret = ret[0.._indices[i]] ~ Unicode.toUtf8(chrs) ~ ret[_indices[i+1]..$];
			_indices = Unicode.calcIndices(ret);
		}
	}

	return ret;
}

int findReverse(string source, string search, uint start = uint.max) {
	if (start == uint.max) {
		start = source.length;
	}

	if (search == "") {
		return -1;
	}

	uint[] _indices = Unicode.calcIndices(source);
	uint[] search_indices = Unicode.calcIndices(search);

	bool found;

	int o;
	foreach_reverse(i, aPos; _indices[0..start]) {
		found = true;
		o=i-1;
		foreach(bPos; search_indices) {
			o++;
			if(o >= _indices.length) {
				found = false;
				break;
			}

			dchar aChr, bChr;

			aChr = Unicode.toUtf32Char(source[_indices[o]..$]);
			bChr = Unicode.toUtf32Char(search[bPos..$]);

			if(aChr != bChr) {
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

int find(string source, string search, uint start = 0) {
	// look through string for term search
	// in some, hopefully later on, efficient manner

	uint[] _indices = Unicode.calcIndices(source);
	uint[] search_indices = Unicode.calcIndices(search);

	if (search == "") {
		return -1;
	}

	if (start >= _indices.length) {
		return -1;
	}

	bool found;

	int o;

	foreach (i, aPos; _indices[start..$]) {
		found = true;
		o=i-1+start;
		foreach (bPos; search_indices) {
			o++;
			if (o >= _indices.length) {
				found = false;
				break;
			}

			dchar aChr, bChr;

			aChr = Unicode.toUtf32Char(source[_indices[o]..$]);
			bChr = Unicode.toUtf32Char(search[bPos..$]);

			if (aChr != bChr) {
				found = false;
				break;
			}
		}
		if (found) {
			return i+start;
		}
	}

	return -1;
}

string times(string str, uint amount) {
	if (amount == 0) {
		return "";
	}

	string ret = "";
	for(int i = 0; i < amount; i++) {
		ret ~= str;
	}
	return ret;
}

string format(string format, ...) {
	Variadic vars = new Variadic(_arguments, _argptr);
	return formatv(format, vars);
}

string formatv(string format, Variadic vars) {
	string ret = "";
	string specifier = "";
	bool inFormat = false;
	bool intoFormat = false;
	foreach(chr; format) {
		if (intoFormat && chr != '{') {
			intoFormat = false;
			inFormat = true;
			specifier = "";
		}

		if (inFormat) {
			// look for format end
			if (chr == '}') {
				inFormat = false;

				int index = 0;
				int width = 0;
				int precision = 0;
				int base = 10;
				bool unsigned = false;
				long value;
				ulong uvalue;
				float fvalue;
				double dvalue;

				bool formatIndex = false;
				bool formatNumber = false;
				bool formatFloat = false;
				bool formatDouble = false;
				bool formatUpper = false;

				if (specifier.nextInt(index)) {
					specifier = specifier.substring(toStr(index).length);
					formatIndex = true;
				}

				// interpret format specifier
				if (specifier.length > 0) {
					if (specifier[0] == ':') {
						specifier = specifier[1..$];
					}
				}
				if (specifier.length == 0) {
					specifier = ":";
				}

				switch(specifier[0]) {
					case 'd':
						base = 10;
						formatNumber = true;
						specifier[1..$].nextInt(width);
						break;
					case 'x':
					case 'X':
						base = 16;
						unsigned = true;
						formatNumber = true;
						specifier[1..$].nextInt(width);
						break;
					case 'o':
					case 'O':
						base = 8;
						unsigned = true;
						formatNumber = true;
						specifier[1..$].nextInt(width);
						break;
					case 'u':
						base = 10;
						unsigned = true;
						formatNumber = true;
						break;
					default:
						// Other specifier series
						// Parse them

						width = 0;
						precision = 0;
						bool gettingPrecision = false;
						foreach(c; specifier) {

							// Zero Placeholders
							if (c == '0') {
								if (gettingPrecision) {
									precision++;
								}
								else {
									width++;
								}
							}
							else if (c == '.') {
								if (gettingPrecision) {
									throw new Exception("Format Exception");
								}
								gettingPrecision = true;
							}
						}
						if (width > 0 || precision > 0) {
							formatNumber = true;
						}
						break;
				}

				specifier = specifier[0..1];

				// Pull an argument off of the stack
				Variant var;
				if (formatIndex) {
					if (index < vars.length) {
						var = vars[index];
					}
					else {
						// TODO: More descriptive and uniform exception?
						throw new Exception("Invalid Format String");
					}
				}
				else {
					var = vars.next();
				}

				Type type = var.type;
				if (formatNumber) {
					switch (type) {
						case Type.Byte:
						case Type.Ubyte:
						case Type.Short:
						case Type.Ushort:
						case Type.Int:
						case Type.Uint:
						case Type.Long:
							value = var.to!(long);
							uvalue = var.to!(ulong);
							break;
						case Type.Ulong:
							unsigned = true;
							uvalue = var.to!(ulong);
							break;
						case Type.Float:
							fvalue = var.to!(float);
							formatFloat = true;
							break;
						case Type.Double:
							dvalue = var.to!(double);
							formatDouble = true;
							break;
						default:
							break;
					}

					string result = "";
					if (formatFloat | formatDouble) {
						string[] foo;
						if (formatFloat) {
							foo = pftoa(fvalue, base);
						}
						else {
							foo = pdtoa(dvalue, base);
						}
						result = foo[0];
						while (result.length < width) {
							result = "0" ~ result;
						}
						string dec = foo[1];
						while (dec.length < precision) {
							dec ~= "0";
						}
						result ~= "." ~ dec;
					}
					else if (formatDouble) {
						result = dtoa(dvalue, base);
					}
					else {
						if (unsigned) {
							result = utoa(uvalue, base);
						}
						else {
							result = itoa(value, base);
						}

						while (result.length < width) {
							result = "0" ~ result;
						}
					}
					if (specifier.uppercase() == specifier) {
						result = result.uppercase();
					}
					ret ~= result;
				}
				else {
					ret ~= var.toString();
				}
			}
			specifier ~= chr;
		}
		else {
			// Go into a format specifier
			if (chr == '{' && intoFormat == false) {
				intoFormat = true;
				continue;
			}
			intoFormat = false;
			ret ~= chr;
		}
	}
	return ret;
}

string lowercase(string str) {
	string ret = str.dup; 
	foreach(ref chr; ret) {
		if (chr >= 'A' && chr <= 'Z') {
			chr = cast(char)((cast(byte)chr) + 32);
		}
	}
	return ret;
}

string uppercase(string str) {
	string ret = str.dup; 
	foreach(ref chr; ret) {
		if (chr >= 'a' && chr <= 'z') {
			chr = cast(char)((cast(byte)chr) - 32);
		}
	}
	return ret;
}

string charAt(string str, uint idx) {
	uint[] _indices = Unicode.calcIndices(str);
	int start, end;
	if (_indices.length > idx) {
		start = _indices[idx];
	}
	else {
		return null;
	}
	if (_indices.length > idx+1) {
		end = _indices[idx+1];
	}
	else {
		end = str.length;
	}
	return str[start..end];
}

string insertAt(string str, string what, uint idx) {
	uint[] _indices = Unicode.calcIndices(str);
	int pos;
	if (_indices.length > idx) {
		pos = _indices[idx];
	}
	else if (idx == _indices.length) {
		pos = str.length;
	}
	else {
		return null;
	}

	return str[0..pos] ~ what ~ str[pos..$];
}

int utflen(string str) {
	uint[] _indices = Unicode.calcIndices(str);
	return _indices.length;
}

int toInt(string str) {
	int ret;
	if (str.nextInt(ret)) {
		return ret;
	}
	return 0;
}

private:
string itoa(long val, uint base = 10) {
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

    while (tmp >= base) {
        tmp /= base;
        intlen++;
    }

    //allocate

    string ret = new char[intlen];

    intlen--;

    if (negative) {
        tmp = -val;
    } else {
        tmp = val;
    }

    do {
    	uint off = cast(uint)(tmp % base);
    	char replace;
    	if (off < 10) {
    		replace = cast(char)('0' + off);
    	}
    	else if (off < 36) {
    		off -= 10;
    		replace = cast(char)('a' + off);
    	}
        ret[intlen] = replace;
        tmp /= base;
        intlen--;
    } while (tmp != 0);


    if (negative) {
        ret[intlen] = '-';
    }

    return ret;
}

string utoa(ulong val, uint base = 10) {
	int intlen;
	ulong tmp = val;

    intlen = 1;

    while (tmp >= base) {
        tmp /= base;
        intlen++;
    }

    //allocate
    tmp = val;

    string ret = new char[intlen];

    intlen--;

    do {
    	uint off = cast(uint)(tmp % base);
    	char replace;
    	if (off < 10) {
    		replace = cast(char)('0' + off);
    	}
    	else if (off < 36) {
    		off -= 10;
    		replace = cast(char)('a' + off);
    	}
        ret[intlen] = replace;
        tmp /= base;
        intlen--;
    } while (tmp != 0);

    return ret;
}

private union intFloat {
	int l;
	float f;
}

private union longDouble {
	long l;
	double f;
}

private union longReal {
	struct inner {
		short exp;
		long frac;
	}

	inner l;
	real f;
}

string ctoa(cfloat val, uint base = 10) {
	if (val is cfloat.infinity) {
		return "inf";
	}
	else if (val.re !<>= 0.0 && val.im !<>= 0.0) {
		return "nan";
	}

	return ftoa(val.re, base) ~ " + " ~ ftoa(val.im, base) ~ "i";
}

string ctoa(cdouble val, uint base = 10) {
	if (val is cdouble.infinity) {
		return "inf";
	}
	else if (val.re !<>= 0.0 && val.im !<>= 0.0) {
		return "nan";
	}

	return dtoa(val.re, base) ~ " + " ~ ftoa(val.im, base) ~ "i";
}

string ctoa(creal val, uint base = 10) {
	if (val is creal.infinity) {
		return "inf";
	}
	else if (val is creal.nan) {
		return "nan";
	}

	return rtoa(val.re, base) ~ " + " ~ ftoa(val.im, base) ~ "i";
}

string ftoa(float val, uint base = 10) {
	string[] foo = pftoa(val, base);

	string ret = foo[0];
	if (foo[1].length > 0) {
		ret ~= "." ~ foo[1];
	}
	return ret;
}

string[] pftoa(float val, uint base = 10) {
	if (val == float.infinity) {
		return ["inf",""];
	}
	else if (val !<>= 0.0) {
		return ["nan",""];
	}
	else if (val == 0.0) {
		return ["0",""];
	}

	long mantissa;
	long intPart;
	long fracPart;

	short exp;

	intFloat iF;
	iF.f = val;

	// Conform to the IEEE standard
	exp = ((iF.l >> 23) & 0xff) - 127;
	mantissa = (iF.l & 0x7fffff) | 0x800000;
	fracPart = 0;
	intPart = 0;

	if (exp >= 31) {
		return ["0",""];
	}
	else if (exp < -23) {
		return ["0",""];
	}
	else if (exp >= 23) {
		intPart = mantissa << (exp - 23);
	}
	else if (exp >= 0) {
		intPart = mantissa >> (23 - exp);
		fracPart = (mantissa << (exp + 1)) & 0xffffff;
	}
	else { // exp < 0
		fracPart = (mantissa & 0xffffff) >> (-(exp + 1));
	}

	string[] ret = ["",""];
	if (iF.l < 0) {
		ret[0] = "-";
	}

	ret[0] ~= itoa(intPart, base);

	for (uint k; k < 7; k++) {
		fracPart *= 10;
		ret[1] ~= cast(char)((fracPart >> 24) + '0');
		fracPart &= 0xffffff;
	}
	
	// round last digit
	bool roundUp = (ret[1][$-1] >= '5');
	ret[1] = ret[1][0..$-1];

	while (roundUp) {
		// Look for a completely empty float
		if (ret[0].length + ret[1].length == 0) {
			return ["0",""];
		}
		else if (ret[1].length > 0 && ret[1][$-1] == '9') {
			ret[1] = ret[1][0..$-1];
			continue;
		}
		ret[1][$-1]++;
		break;
	}

	// get rid of useless trailing zeroes
	foreach_reverse(uint i, chr; ret[1]) {
		if (chr != '0') {
			ret[1] = ret[1][0..i+1];
			break;
		}
	}

	return ret;
}

string dtoa(double val, uint base = 10) {
	string[] foo = pdtoa(val, base);

	string ret = foo[0];
	if (foo[1].length > 0) {
		ret ~= "." ~ foo[1];
	}
	
	return ret;
}

string[] pdtoa(double val, uint base = 10) {
	if (val is double.infinity) {
		return ["inf",""];
	}
	else if (val !<>= 0.0) {
		return ["nan",""];
	}
	else if (val == 0.0) {
		return ["0",""];
	}

	long mantissa;
	long intPart;
	long fracPart;

	long exp;

	longDouble iF;
	iF.f = val;

	// Conform to the IEEE standard
	exp = ((iF.l >> 52) & 0x7ff);
	if (exp == 0) {
		return ["0",""];
	}
	else if (exp == 0x7ff) {
		return ["inf",""];
	}
	exp -= 1023;

	mantissa = (iF.l & 0xfffffffffffff) | 0x10000000000000;
	fracPart = 0;
	intPart = 0;

	if (exp < -52) {
		return ["0",""];
	}
	else if (exp >= 52) {
		intPart = mantissa << (exp - 52);
	}
	else if (exp >= 0) {
		intPart = mantissa >> (52 - exp);
		fracPart = (mantissa << (exp + 1)) & 0x1fffffffffffff;
	}
	else { // exp < 0
		fracPart = (mantissa & 0x1fffffffffffff) >> (-(exp + 1));
	}

	string ret[] = ["", ""];
	if (iF.l < 0) {
		ret[0] = "-";
	}

	ret[0] ~= itoa(intPart, base);

	for (uint k; k < 7; k++) {
		fracPart *= 10;
		ret[1] ~= cast(char)((fracPart >> 53) + '0');
		fracPart &= 0x1fffffffffffff;
	}
	
	// round last digit
	bool roundUp = (ret[1][$-1] >= '5');
	ret[1] = ret[1][0..$-1];

	while (roundUp) {
		if (ret[0].length == 0 && ret[1].length == 0) {
			return ["0",""];
		}
		else if (ret[1][$-1] == '9') {
			ret[1] = ret[1][0..$-1];
			continue;
		}
		ret[1][$-1]++;
		break;
	}

	// get rid of useless zeroes (and point if necessary)
	foreach_reverse(uint i, chr; ret[1]) {
		if (chr != '0') {
			ret[1] = ret[1][0..i+1];
			break;
		}
	}

	return ret;
}

string rtoa(real val, uint base = 10) {
	static if (real.sizeof == 10) {
		// Support for 80-bit extended precision

		if (val is real.infinity) {
			return "inf";
		}
		else if (val !<>= 0.0) {
			return "nan";
		}
		else if (val == 0.0) {
			return "0";
		}

		long mantissa;
		long intPart;
		long fracPart;
	
		long exp;

		longReal iF;
		iF.f = val;

		// Conform to the IEEE standard
		exp = iF.l.exp & 0x7fff;
		if (exp == 0) {
			return "0";
		}
		else if (exp == 32767) {
			return "inf";
		}
		exp -= 16383;

		mantissa = iF.l.frac;
		fracPart = 0;
		intPart = 0;
	
		if (exp >= 31) {
			return "0";
		}
		else if (exp < -64) {
			return "0";
		}
		else if (exp >= 64) {
			intPart = mantissa << (exp - 64);
		}
		else if (exp >= 0) {
			intPart = mantissa >> (64 - exp);
			fracPart = mantissa << (exp + 1);
		}
		else { // exp < 0
			fracPart = mantissa >> (-(exp + 1));
		}

		string ret;
		if (iF.l.exp < 0) {
			ret = "-";
		}
	
		ret ~= itoa(intPart, base);
		ret ~= '.';

		for (uint k; k < 7; k++) {
			fracPart *= 10;
			ret ~= cast(char)((fracPart >> 64) + '0');
		}
		
		// round last digit
		bool roundUp = (ret[$-1] >= '5');
		ret = ret[0..$-1];
	
		while (roundUp) {
			if (ret.length == 0) {
				return "0";
			}
			else if (ret[$-1] == '.' || ret[$-1] == '9') {
				ret = ret[0..$-1];
				continue;
			}
			ret[$-1]++;
			break;
		}
	
		// get rid of useless zeroes (and point if necessary)
		foreach_reverse(uint i, chr; ret) {
			if (chr != '0' && chr != '.') {
				ret = ret[0..i+1];
				break;
			}
			else if (chr == '.') {
				ret = ret[0..i];
				break;
			}
		}

		return ret;
	}
	else {
		return ftoa(cast(double)val, base);
	}
}
