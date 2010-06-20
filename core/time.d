module core.time;

import Scaffold = scaffold.time;

import core.string;
import core.definitions;
import core.timezone;

// Section: Types
// Description: This struct stores a description of time.
class Time {

	// Description: This will construct a Time object that will represent midnight.
	this() {
	}

	// Description: This will construct a Time object that will represent the
	//   amount of time equal to the number of microseconds given by the
	//   parameter.
	// microseconds: The number of microseconds to be represented.
	this(long microseconds) {
		_micros = microseconds;
	}

	// Description: This will construct a Time object that will represent the
	//   time given by each parameter such that it will represent
	//   hour:minute:second.microsecond
	// hour: The hours to be represented by this Time object.
	// minute: The minutes to be represented by this Time object.
	// second: The seconds to be represented by this Time object.
	// microsecond: The microseconds to be represented by this Time object.
	this(long hour, long minute, long second, long microsecond = 0) {
		_micros = hour;
		_micros *= 60;
		_micros += minute;
		_micros *= 60;
		_micros += second;
		_micros *= 1000000;
		_micros += microsecond;
	}

	// Description: This will return a Time object that represents the coordinated
	//   universal time (UTC) assumed by the system.
	// Returns: A Time class that represents the system's idea of the current universal time.
	static Time Now() {
		return new Time(Scaffold.TimeGet());
	}

	// Description: This will return a Time object that represents the local time
	//   according to the given TimeZone. If a TimeZone is not given, the local
	//   time of the current locale is returned.
	// localTZ: The TimeZone to use to infer the localized time from the UTC.
	// Returns: A Time class that represents the local time.
	static Time Local(TimeZone localTZ = null) {
		Time ret = new Time(Scaffold.TimeGet());

		// Get the local timezone if one was not specified.
		if (localTZ is null) {
			localTZ = new TimeZone();
		}
		
		ret._micros += localTZ.utcOffset;

		// Make sure it is within a day
		// I am sure this breaks some leap second business
		if (ret._micros < 0) {
			ret._micros += (24L * 60L * 60L * 1000000L);
		}
		return ret;
	}

	// Description: This will give the floored number of hours this Time
	//   object represents.
	long hours() {
		long h, ms, s, m;
		long tmp = _micros;

		tmp /= 1000000;
		tmp /= 60;
		tmp /= 60;

		return tmp;
	}

	void hours(long value) {
		_micros = value * 60L * 60L * 1000000L;
	}
	
	// Description: This will give the floored number of seconds this Time
	//   object represents.
	long seconds() {
		long h, ms, s, m;
		long tmp = _micros;

		tmp /= 1000000;

		return tmp;
	}

	void seconds(long value) {
		_micros = value * 1000000L;
	}

	// Description: This will give the floored number of minutes this Time
	//   object represents.
	long minutes() {
		long h, ms, s, m;
		long tmp = _micros;

		tmp /= 1000000;
		tmp /= 60;

		return tmp;
	}

	void minutes(long value) {
		_micros = value * 60L * 1000000L;
	}

	// Description: This will give the floored number of milliseconds this Time
	//   object represents.
	long milliseconds() {
		long h, ms, s, m;
		long tmp = _micros;

		return tmp / 1000;
	}

	void milliseconds(long value) {
		_micros = value * 1000L;
	}

	// Description: This will give the floored number of microseconds this Time
	//   object represents.
	long microseconds() {
		return _micros;
	}

	void microseconds(long value) {
		_micros = value;
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

		string str = "";

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
			str ~= "-";
		}

		if (h < 10) {
			str ~= "0";
		}
		str ~= toStr(h, ":");

		if (m < 10) {
			str ~= "0";
		}
		str ~= toStr(m, ":");

		if (s < 10) {
			str ~= "0";
		}
		str ~= toStr(s, ".");

		if (ms < 100) {
			str ~= "0";
		}
		if (ms < 10) {
			str ~= "0";
		}
		str ~= toStr(ms);

		return str;
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
