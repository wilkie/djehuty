module core.time;

import Scaffold = scaffold.time;

import core.string;
import core.definitions;
import core.tostring;

import io.console;

// Section: Types

// Description: This struct stores a description of time.
class Time {

	enum Zone {
		GMT,
		ECT,
		EET,
		ART,
		EAT,
		MET,
		NET,
		PLT,
		IST,
		BST,
		VST,
		CTT,
		JST,
		ACT,
		AET,
		SST,
		NST,
		MIT,
		HST,
		AST,
		PST,
		PNT,
		MST,
		CST,
		EST,
		IET,
		PRT,
		CNT,
		AGT,
		BET,
		CAT
	}

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
		Time.Zone localtz = Scaffold.TimeZoneGet();
		
		switch(localtz) {
			case Time.Zone.EST:
				ret._micros -= 5L * 60L * 60L * 1000000L;
				break;
			default:
		}

		// Make sure it is within a day
		// I am sure this breaks some leap second business
		ret._micros %= (24L * 60L * 60L * 1000000L);
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
