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

extern(C) void tzset();

extern(C) {
	extern char* tzname[2];
}

}

Time.Zone TimeZoneGet() {
	int foo;
	timeval val;
	gettimeofday(&val, null);

	tm time_struct;
	localtime_r(cast(time_t*)&val.tv_sec, &time_struct);
//	tzset();
	if (tzname[0] !is null) {
		size_t len = strlen(tzname[0]);
		char[] tzstr = new char[len];
		tzstr[0..tzstr.length] = tzname[0][0..tzstr.length];

		switch(tzstr[0..len]) {
			case "EST":
				return Time.Zone.EST;
			case "ECT":
				return Time.Zone.ECT;
			case "EET":
				return Time.Zone.EET;
			case "ART":
				return Time.Zone.ART;
			case "EAT":
				return Time.Zone.EAT;
			case "MET":
				return Time.Zone.MET;
			case "NET":
				return Time.Zone.NET;
			case "PLT":
				return Time.Zone.PLT;
			case "IST":
				return Time.Zone.IST;
			case "BST":
				return Time.Zone.BST;
			case "VST":
				return Time.Zone.VST;
			case "CTT":
				return Time.Zone.CTT;
			case "JST":
				return Time.Zone.JST;
			case "ACT":
				return Time.Zone.ACT;
			case "AET":
				return Time.Zone.AET;
			case "SST":
				return Time.Zone.SST;
			case "NST":
				return Time.Zone.NST;
			case "MIT":
				return Time.Zone.MIT;
			case "HST":
				return Time.Zone.HST;
			case "AST":
				return Time.Zone.AST;
			case "PST":
				return Time.Zone.PST;
			case "PNT":
				return Time.Zone.PNT;
			case "MST":
				return Time.Zone.MST;
			case "CST":
				return Time.Zone.CST;
			case "IET":
				return Time.Zone.IET;
			case "PRT":
				return Time.Zone.PRT;
			case "CNT":
				return Time.Zone.CNT;
			case "AGT":
				return Time.Zone.AGT;
			case "BET":
				return Time.Zone.BET;
			case "CAT":
				return Time.Zone.CAT;
			case "GMT":
			default:
				return Time.Zone.GMT;
		}
	}
	return Time.Zone.GMT;
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
	month = cast(Month)0;
	day = 0;
	year = 0;
}
