module core.locales.fr_fr;

import core.locale;

import core.time;
import core.date;
import core.tostring;
import core.definitions;

class LocaleFrench_FR : LocaleInterface {
	string formatTime(Time time) {
		string ret;

		uint hr, min, sec;
		hr = time.hours;
		min = time.minutes % 60;
		sec = time.seconds % 60;

		ret = toStr(hr);
		ret ~= ":";

		if (min < 10) {
			ret ~= "0";
		}
		ret ~= toStr(min);
		ret ~= ":";

		if (sec < 10) {
			ret ~= "0";
		}
		ret ~= toStr(sec);

		return ret;
	}

	string formatDate(Date date) {
		string ret;

		ret = toStr(date.day);
		ret ~= " ";

		switch(date.month) {
			case Month.January:
				ret ~= "janvier";
				break;
			case Month.February:
				ret ~= "f\u00e9vier";
				break;
			case Month.March:
				ret ~= "mars";
				break;
			case Month.April:
				ret ~= "avril";
				break;
			case Month.May:
				ret ~= "mai";
				break;
			case Month.June:
				ret ~= "juin";
				break;
			case Month.July:
				ret ~= "juillet";
				break;
			case Month.August:
				ret ~= "ao\u00fbt";
				break;
			case Month.September:
				ret ~= "septembre";
				break;
			case Month.October:
				ret ~= "octobre";
				break;
			case Month.November:
				ret ~= "novembre";
				break;
			case Month.December:
				ret ~= "d\u00e9cembre";
				break;
			default:
				ret ~= "???";
				break;
		}

		ret ~= " " ~ toStr(date.year);

		return ret;
	}

	string formatCurrency(long whole, long scale) {
		return formatNumber(whole, scale, 2) ~ " \u20ac";
	}

	string formatCurrency(double amount) {
		return formatNumber(amount) ~ " \u20ac";
	}

	string formatNumber(long whole, long scale, long round = -1) {
		long intPart;
		long baseScale;
		long fracPart;

		// Get integer part of decimal
		intPart = whole;
		baseScale = 1;
		for (long i; i < scale; i++) {
			intPart /= 10;
			baseScale *= 10;
		}
		baseScale /= 10;

		// Get fraction as an integer
		fracPart = whole % baseScale;

		// Round down
		for ( ; round > 0 ; round-- ) {
			baseScale /= 10;
		}
		fracPart /= baseScale;
		
		return formatNumber(intPart) ~ "," ~ formatNumber(fracPart);
	}

	string formatNumber(long value) {
		if (value == 0) {
			return "0";
		}

		string ret;
		while (value > 0) {
			long part = value % 1000;
			value /= 1000;
			if (ret !is null) {
				ret = toStr(part) ~ " " ~ ret;
			}
			else {
				ret = toStr(part);
			}
		}
		return ret;
	}

	string formatNumber(double value) {
		string ret;
		long intPart = cast(long)value;

		while (intPart > 0) {
			long part = intPart % 1000;
			intPart /= 1000;
			if (ret !is null) {
				ret = toStr(part) ~ " " ~ ret;
			}
			else {
				ret = toStr(part);
			}
		}
		ret ~= ",";
		ret ~= ftoa(value, 10, false);
	
		// round last digit
		bool roundUp = (ret[$-1] >= '5');
		ret = ret[0..$-1];

		while (roundUp) {
			if (ret.length == 0) {
				return "0";
			}
			else if (ret[$-1] == ',' || ret[$-1] == '9') {
				ret = ret[0..$-1];
				continue;
			}
			ret[$-1]++;
			break;
		}

		// get rid of useless zeroes (and point if necessary)
		foreach_reverse(uint i, chr; ret) {
			if (chr != '0' && chr != ',') {
				ret = ret[0..i+1];
				break;
			}
		}

		return ret;
	}
}
