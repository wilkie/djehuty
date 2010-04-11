module core.locales.en_us;

import core.locale;

import core.time;
import core.date;
import core.definitions;
import core.string;

class LocaleEnglish_US : LocaleInterface {
	string formatTime(Time time) {
		long hour = time.hours;

		bool pm = false;

		if (hour >= 12) {
			hour -= 12;
			pm = true;
		}

		string ret;

		ret = toStr(hour);
		ret ~= ":";

		long min = time.minutes % 60;
		if (min < 10) {
			ret ~= "0";
		}
		ret ~= toStr(min);
		ret ~= ":";

		long sec = time.seconds % 60;
		if (sec < 10) {
			ret ~= "0";
		}
		ret ~= toStr(sec);

		if (pm) {
			ret ~= "pm";
		}
		else {
			ret ~= "PM";
		}

		return ret;
	}

	string formatDate(Date date) {
		string ret;
		switch(date.month) {
			case Month.January:
				ret = "January ";
				break;
			case Month.February:
				ret = "February ";
				break;
			case Month.March:
				ret = "March ";
				break;
			case Month.April:
				ret = "April ";
				break;
			case Month.May:
				ret = "May ";
				break;
			case Month.June:
				ret = "June ";
				break;
			case Month.July:
				ret = "July ";
				break;
			case Month.August:
				ret = "August ";
				break;
			case Month.September:
				ret = "September ";
				break;
			case Month.October:
				ret = "October ";
				break;
			case Month.November:
				ret = "November ";
				break;
			case Month.December:
				ret = "December ";
				break;
			default:
				ret = "??? ";
				break;
		}

		string day = toStr(date.day);
		ret ~= day;

		ret ~= ", " ~ toStr(date.year);

		return ret;
	}

	string formatCurrency(long whole, long scale) {
		return "$" ~ formatNumber(whole, scale, 2);
	}

	string formatCurrency(double amount) {
		return "$" ~ formatNumber(amount);
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
		
		return formatNumber(intPart) ~ "." ~ formatNumber(fracPart);
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
				ret = toStr(part) ~ "," ~ ret;
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
				ret = toStr(part) ~ "," ~ ret;
			}
			else {
				ret = toStr(part);
			}
		}
		ret ~= ".";
		ret ~= toStr(value);
	
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
		}

		return ret;
	}
}
