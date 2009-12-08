module core.tostring;

import core.variant;
import core.definitions;

string toStrv(Variadic vars) {
	string ret = "";
	foreach(var; vars) {
		if (!var.isArray) {
			if (var.type < Type.Real) {
				long val;
				switch(var.type) {
					case Type.Byte:
						val = var.data.b;
						break;
					case Type.Ubyte:
						val = var.data.ub;
						break;
					case Type.Short:
						val = var.data.s;
						break;
					case Type.Ushort:
						val = var.data.us;
						break;
					case Type.Int:
						val = var.data.i;
						break;
					case Type.Uint:
						val = var.data.ui;
						break;
					case Type.Long:
						val = var.data.l;
						break;
					default:
						break;
				}
				if (var.type == Type.Ulong) {
					ret ~= utoa(var.data.ul);
				}
				else {
					ret ~= itoa(val);
				}
				continue;
			}
			else if (var.type <= Type.Float) {
				switch(var.type) {
					case Type.Float:
						ret ~= ftoa(var.data.f);
						break;
					case Type.Real:
						ret ~= "{real}";
						break;
					default:
					case Type.Double:
						ret ~= ftoa(var.data.d);
						break;
				}
				continue;
			}
			else if (var.type <= Type.Ifloat) {
				switch(var.type) {
					case Type.Float:
						ret ~= ftoa(var.data.fi.im) ~ "i";
						break;
					case Type.Real:
						ret ~= "{real}";
						break;
					default:
					case Type.Double:
						ret ~= ftoa(var.data.di.im) ~ "i";
						break;
				}
				continue;
			}
			else if (var.type <= Type.Cfloat) {
				switch(var.type) {
					case Type.Float:
						ret ~= ctoa(var.data.fc);
						break;
					case Type.Real:
						ret ~= "{real}";
						break;
					default:
					case Type.Double:
						ret ~= ctoa(var.data.dc);
						break;
				}
				continue;
			}
		}
		ret ~= var.toString();
	}
	return ret;
}

string toStr(...) {
	Variadic vars = new Variadic(_arguments, _argptr);

	return toStrv(vars);
}

long atoi(string value, uint base = 10) {
	bool negative;
	uint i;
	if (value is null || value.length == 0) {
		return 0;
	}
	if (value[i] == '-') {
		negative = true;
		i++;
	}

	long ret;

	for (; i < value.length; i++) {
		if (value[i] >= '0' && value[i] <= '9') {
			ret *= 10;
			ret += cast(int)value[i] - cast(int)'0';
		}
	}

	if (negative) {
		ret = -ret;
	}

	return ret;
}

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
	else if (val is cfloat.nan) {
		return "nan";
	}

	return ftoa(val.re, base) ~ " + " ~ ftoa(val.im, base) ~ "i";
}

string ctoa(cdouble val, uint base = 10) {
	if (val is cdouble.infinity) {
		return "inf";
	}
	else if (val is cdouble.nan) {
		return "nan";
	}

	return ftoa(val.re, base) ~ " + " ~ ftoa(val.im, base) ~ "i";
}

string ctoa(creal val, uint base = 10) {
	if (val is creal.infinity) {
		return "inf";
	}
	else if (val is creal.nan) {
		return "nan";
	}

	return ftoa(val.re, base) ~ " + " ~ ftoa(val.im, base) ~ "i";
}

string ftoa(float val, uint base = 10) {
	if (val is float.infinity) {
		return "inf";
	}
	else if (val is float.nan) {
		return "nan";
	}
	else if (val == 0.0) {
		return "0";
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
		return "0";
	}
	else if (exp < -23) {
		return "0";
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

	string ret;
	if (iF.l < 0) {
		ret = "-";
	}

	ret ~= itoa(intPart, base);
	ret ~= ".";
	for (uint k; k < 7; k++) {
		fracPart *= 10;
		ret ~= cast(char)((fracPart >> 24) + '0');
		fracPart &= 0xffffff;
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

string ftoa(double val, uint base = 10, bool doIntPart = true) {
	if (val is double.infinity) {
		return "inf";
	}
	else if (val is double.nan) {
		return "nan";
	}
	else if (val == 0.0) {
		return "0";
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
		return "0";
	}
	else if (exp == 0x7ff) {
		return "inf";
	}
	exp -= 1023;

	mantissa = (iF.l & 0xfffffffffffff) | 0x10000000000000;
	fracPart = 0;
	intPart = 0;

	if (exp < -52) {
		return "0";
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

	string ret;
	if (iF.l < 0) {
		ret = "-";
	}

	if (doIntPart) {
		ret ~= itoa(intPart, base);
		ret ~= ".";
	}

	for (uint k; k < 7; k++) {
		fracPart *= 10;
		ret ~= cast(char)((fracPart >> 53) + '0');
		fracPart &= 0x1fffffffffffff;
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

string ftoa(real val, uint base = 10) {
	static if (real.sizeof == 10) {
		// Support for 80-bit extended precision

		if (val is real.infinity) {
			return "inf";
		}
		else if (val is real.nan) {
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
		ret ~= ".";
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
