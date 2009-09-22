module core.locales.en_us;

import core.locale;

import core.time;
import core.date;
import core.string;
import core.definitions;


class LocaleEnglish_US : LocaleInterface {
static:
	string formatTime(Time time) {
		uint hour = time.hour;

		bool pm = false;

		if (hour >= 12) {
			hour -= 12;
			pm = true;
		}
		
		string ret;

		ret = toStr(hour);
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

	string formatCurrency(double amount) {
		return "$" ~ formatNumber(amount);
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
		ret ~= ftoa(value, 10, false);
	
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

