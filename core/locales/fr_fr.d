module core.locales.fr_fr;

import core.locale;

import core.time;
import core.date;
import core.string;

class LocaleFrench_FR : LocaleInterface {
static:
	string formatTime(Time time) {
		string ret;

		ret = toStr(time.hour);
		ret ~= ":";

		if (time.minute < 10) {
			ret ~= "0";
		}
		ret ~= toStr(time.minute);
		ret ~= ":";

		if (time.second < 10) {
			ret ~= "0";
		}
		ret ~= toStr(time.second);

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

	string formatCurrency(double amount) {
		return formatNumber(amount) ~ " \u20ac";
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