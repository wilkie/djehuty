module core.time;

import Scaffold = scaffold.time;

import core.string;
import core.definitions;
import core.tostring;

import io.console;

// Section: Types
class TimeZone {

	// Description: This will construct a TimeZone for the current location.
	this() {
		this(Scaffold.TimeZoneGet());
	}

	// Description: This will construct a specific TimeZone for a specific
	//   timezone name or a string containing a custom timezone.
	// name: A full name, or "GMT+h:mm" or "GMT-h:mm" where h and mm
	//   represent the hour and minutes from GMT respectively.
	this(string name) {
		_name = name;
		if (name[0..3] == "GMT") {
			_gmt = name;
			string foo = name[3..$];
			int pos = (new String(foo)).find(":");
			if (pos < 0) { pos = foo.length; }
			foo = foo[0..pos];
			int diff_hr; 
			if ((new String(foo)).nextInt(diff_hr)) {
				Console.putln("!!", foo, "##", diff_hr);
			}
		}
		else {
			switch(name) {
				case "Eastern Standard Time":
					_offset_in_minutes = -(5 * 60);
					break;
				case "Pacific Standard Time":
					_offset_in_minutes = -(8 * 60);
					break;
				default:
					break;
			}
			int diff_hr = _offset_in_minutes / 60;
			int diff_min = _offset_in_minutes % 60;
			_gmt = "GMT" ~ toStr(diff_hr) ~ ":" ~ (diff_min < 10 ? "0" : "") ~ toStr(diff_min);
			Console.putln(_gmt);
		}
	}

	string name() {
		return _name;
	}

	string toString() {
		return "GMT";
	}

protected:

	string _name = "";
	string _gmt = "";
	int _offset_in_minutes;
}

// Description: This struct stores a description of time.
class Time {

	this() {
	}

	this(long ms) {
		fromMicroseconds(ms);
	}

	this(long hour, long minute, long second, long microsecond = 0) {
		_micros = hour;
		_micros *= 60;
		_micros += minute;
		_micros *= 60;
		_micros += second;
		_micros *= 1000000;
		_micros += microsecond;
	}

	static Time Now() {
		return new Time(Scaffold.TimeGet());
	}

	static Time Local() {
		Time ret = new Time(Scaffold.TimeGet());
		TimeZone localtz = new TimeZone();
		
		switch(0) {
			default:
				ret._micros -= 5L * 60L * 60L * 1000000L;
				break;
		}

		// Make sure it is within a day
		// I am sure this breaks some leap second business
		if (ret._micros < 0) {
			ret._micros += (24L * 60L * 60L * 1000000L);
		}
		return ret;
	}

	long hour() {
		long h, ms, s, m;
		long tmp = _micros;

		ms = (tmp % 1000000) / 1000;
		tmp /= 1000000;

		s = tmp % 60;
		tmp /= 60;

		m = tmp % 60;
		tmp /= 60;

		return tmp;
	}
	
	long second() {
		long h, ms, s, m;
		long tmp = _micros;

		ms = (tmp % 1000000) / 1000;
		tmp /= 1000000;

		return tmp % 60;
	}

	long minute() {
		long h, ms, s, m;
		long tmp = _micros;

		ms = (tmp % 1000000) / 1000;
		tmp /= 1000000;

		s = tmp % 60;
		tmp /= 60;

		return tmp % 60;
	}

	long millisecond() {
		long h, ms, s, m;
		long tmp = _micros;

		return (tmp % 1000000) / 1000;
	}

	long microsecond() {
		return _micros % 1000000;
	}
	
	long toMicroseconds() {
		return _micros;
	}

	// Description: Will set the time value for all fields with the given milliseconds.
	void fromMilliseconds(long ms) {
		_micros = ms * 1000;
	}

	// Description: Will set the time value for all fields with the given microseconds.
	void fromMicroseconds(long us) {
		_micros = us;
	}

	// comparator functions
	int opCmp(Time o) {
		return cast(int)(_micros - o._micros);
	}

	int opEquals(Time o) {
		return cast(int)(o._micros == _micros);
	}

	// string functions

	string toString() {
		long h, ms, s, m;
		long tmp = _micros;

		String str = new String("");

		if (tmp < 0) {
			tmp *= -1;
		}

		ms = (tmp % 1000000) / 1000;
		tmp /= 1000000;

		s = tmp % 60;
		tmp /= 60;

		m = tmp % 60;
		tmp /= 60;

		h = tmp;

		if (_micros < 0) {
			str.append("-");
		}

		if (h < 10) {
			str.append("0");
		}
		str.append(toStr(h, ":"));

		if (m < 10) {
			str.append("0");
		}
		str.append(toStr(m, ":"));

		if (s < 10) {
			str.append("0");
		}
		str.append(toStr(s, "."));

		if (ms < 100) {
			str.append("0");
		}
		if (ms < 10) {
			str.append("0");
		}
		str.append(toStr(ms));

		return str.toString();
	}

	// mathematical functions
	Time opAdd(Time o) {
		Time ret = new Time();
		ret._micros = _micros + o._micros;

		return ret;
	}

	Time opSub(Time o) {
		Time ret = new Time();
		ret._micros = _micros - o._micros;

		return ret;
	}

	void opAddAssign(Time o) {
		_micros += o._micros;
	}

	void opSubAssign(Time o) {
		_micros -= o._micros;
	}

protected:

	// Description: The microsecond.
	long _micros;
}
