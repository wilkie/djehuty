module core.time;

import core.string;

import io.console;

// Section: Types

// Description: This struct stores a description of time.
class Time {

	this() {
	}

	this(long ms) {
		fromMilliseconds(ms);
	}
	
	this(uint hour, uint minute, uint second, uint millisecond = 0) {
		micros = hour;
		micros *= 60;
		micros += minute;
		micros *= 60;
		micros += second;
		micros *= 1000;
		micros += millisecond;
		micros *= 1000;
	}

	// Description: The microsecond.
	long micros;
	
	uint hour() {
		ulong h,ms,s,m;
		long tmp = micros;

		ms = (cast(uint)tmp % 1000000) / 1000;
		tmp /= 1000000;

		s = cast(uint)tmp % 60;
		tmp /= 60;

		m = cast(uint)tmp % 60;
		tmp /= 60;

		return cast(uint)tmp;
	}
	
	uint second() {
		ulong h,ms,s,m;
		long tmp = micros;

		ms = (cast(uint)tmp % 1000000) / 1000;
		tmp /= 1000000;

		return cast(uint)tmp % 60;
	}
	
	uint minute() {
		ulong h,ms,s,m;
		long tmp = micros;

		ms = (cast(uint)tmp % 1000000) / 1000;
		tmp /= 1000000;

		s = cast(uint)tmp % 60;
		tmp /= 60;

		return cast(uint)tmp % 60;
	}
	
	uint millsecond() {
		ulong h,ms,s,m;
		long tmp = micros;

		return (cast(uint)tmp % 1000000) / 1000;
	}

	// Description: Will set the time value for all fields with the given milliseconds.
	void fromMilliseconds(long ms) {
		micros = ms * 1000;
	}

	// Description: Will set the time value for all fields with the given milliseconds.
	void fromMicroseconds(long ms) {
		micros = ms;
	}

	// comparator functions
	int opCmp(Time o) {
		return cast(int)(micros - o.micros);
	}

	int opEquals(Time o) {
		return cast(int)(o.micros == micros);
	}

	// string functions

	string toString() {
		ulong h,ms,s,m;
		long tmp = micros;

		ms = (cast(uint)tmp % 1000000) / 1000;
		tmp /= 1000000;

		s = cast(uint)tmp % 60;
		tmp /= 60;

		m = cast(uint)tmp % 60;
		tmp /= 60;

		h = cast(uint)tmp;

		if (h != 0)
		{
			Console.put(h, ":");
		}

		if (m < 10 && h > 0)
		{
			Console.put("0");
		}
		Console.put(m, ":");

		if (s < 10)
		{
			Console.put("0");
		}
		Console.put(s, ".");

		if (ms < 100)
		{
			Console.put("0");
		}
		if (ms < 10)
		{
			Console.put("0");
		}
		Console.put(ms);

		Console.put("");

		string str = "";

		return str;
	}

	// mathematical functions
	Time opAdd(Time o) {
		Time ret;
		ret.micros = micros + o.micros;

		return ret;
	}

	Time opSub(Time o) {
		Time ret;

		ret.micros = micros - o.micros;

		return ret;
	}

	void opAddAssign(Time o) {
		micros += o.micros;
	}

	void opSubAssign(Time o) {
		micros -= o.micros;
	}
}
