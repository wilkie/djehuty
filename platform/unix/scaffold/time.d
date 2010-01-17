/*
 * time.d
 *
 * This Scaffold holds the Time implementations for the Linux platform
 *
 * Author: Dave Wilkinson
 * Originated: May 19th, 2009
 *
 */

module scaffold.time;

import platform.unix.common;

import core.definitions;
import core.string;
import core.date;
import core.time;

// Timing
private {
	struct tm {
		int tm_sec;
		int tm_min;
		int tm_hour;
		int tm_mday;
		int tm_mon;
		int tm_year;
		int tm_wday;
		int tm_yday;
		int tm_isdst;
		char* tm_zone;
		int tm_gmtoff;
	}

	extern(C) tm* gmtime(time_t* tim);
	extern(C) tm* gmtime_r(time_t* tim, tm* output);
	extern(C) tm* localtime(time_t* tim);
	extern(C) tm* localtime_r(time_t* tim, tm* output);
	extern(C) size_t strftime(char*, size_t, char*, tm*);
	extern(C) void* memcpy(void*, void*, size_t);

	extern(C) time_t mktime(tm*);

	extern(C) void tzset();

	extern(C) {
		extern char* tzname[2];
	}
}

string TimeZoneGet() {
	int foo;
	timeval val;
	gettimeofday(&val, null);

	tm LOCAL;
	tm GMT;
	gmtime_r(cast(time_t*)&val.tv_sec, &GMT);
	localtime_r(cast(time_t*)&val.tv_sec, &LOCAL);

	// Get GMT difference
	// Which is earliest?
	time_t gmt_time = mktime(&GMT);
	time_t local_time = mktime(&LOCAL);
	
	time_t diff = local_time - gmt_time;
	int diff_min = diff % (60*60);
	int diff_hr = diff / 60 / 60;

	char[] strret = new char[128];
	strret[0..3] = "UTC";
	size_t len = sprintf(&strret[3], "%d", diff_hr);
	strret[3+len] = ':';
	len+=4;
	if (diff_min < 10) {
		strret[len] = '0';
		len++;
	}
	
	if (diff_min > 0) {
		len = sprintf(&strret[len], "%d", diff_min);
	}
	else {
		strret[len] = '0';
		len++;
	}
	strret = strret[0..len];

	if (tzname[0] !is null) {
		len = strlen(tzname[0]);
		char[] tzstr = new char[len];
		tzstr[0..tzstr.length] = tzname[0][0..tzstr.length];

		switch(tzstr[0..len]) {
			case "EST":
				if (strret == "UTC-5:00") {
					return "Eastern Standard Time";
				}
				break;
			case "PST":
				if (strret == "UTC-8:00") {
					return "Pacific Standard Time";
				}
				break;
			default:
				return strret;
		}
	}
	return strret;
}

// getting microseconds
long TimeGet() {
	timeval val;
	gettimeofday(&val, null);

	tm time_struct;
	gmtime_r(cast(time_t*)&val.tv_sec, &time_struct);

	// get microseconds
	long micros;
	micros = time_struct.tm_sec + (time_struct.tm_min * 60);
	micros += time_struct.tm_hour * 60 * 60;
	micros *= 1000000;
	micros += val.tv_usec;
	return micros;
}

ulong SystemTimeGet() {
	timeval val;
	gettimeofday(&val, null);
	return (val.tv_sec * 1000000) + val.tv_usec;
}

float gettimeofday_difference(timeval *b, timeval *a) {
	timeval diff_tv;

	diff_tv.tv_usec = b.tv_usec - a.tv_usec;
	diff_tv.tv_sec = b.tv_sec - a.tv_sec;

	if (a.tv_usec > b.tv_usec) {
		diff_tv.tv_usec += 1000000;
		diff_tv.tv_sec--;
	}

	return cast(float)diff_tv.tv_sec + (cast(float)diff_tv.tv_usec / 1000000.0);
}

void DateGet(out Month month, out uint day, out uint year) {
	timeval val;
	gettimeofday(&val, null);

	tm time_struct;
	gmtime_r(cast(time_t*)&val.tv_sec, &time_struct);

	month = cast(Month)time_struct.tm_mon;
	day = time_struct.tm_mday;
	year = time_struct.tm_year + 1900;
}
