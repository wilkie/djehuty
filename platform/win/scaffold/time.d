/*
 * time.d
 *
 * This file implements the Scaffold for platform specific Time
 * operations in Windows.
 *
 * Author: Dave Wilkinson
 *
 */

module scaffold.time;

import platform.win.common;

import core.date;
import core.definitions;
import core.string;
import core.tostring;

// Timing

import binding.win32.mmsystem;

import io.console;

string TimeZoneGet() {
	TIME_ZONE_INFORMATION tzi;
	GetTimeZoneInformation(&tzi);

	// Use Bias information.

	// The Bias entry is calculated as the difference from UTC such that:
	// UTC = lcoal time + bias.

	// Therefore, we need to use the negative of the Bias.

	int diff_hr, diff_min;

	diff_hr = -tzi.Bias / 60;
	diff_min = -tzi.Bias % 60;

	string ret = "UTC" ~ toStr(diff_hr) ~ ":";
	if (diff_min < 10) {
		ret ~= "0";
	}
	ret ~= toStr(diff_min);

	// Use other information

	wchar[] tzname = "";
	size_t len = strlen(tzi.StandardName.ptr);
	if (len != 0) {
		tzname = new wchar[len];
		tzname[0..len] = (tzi.StandardName.ptr)[0..len];
		switch (tzname) {
			case "EST":
				if (diff_hr != -5) { break; }
			case "Eastern Standard Time":
				return "Eastern Standard Time";

			case "PST":
				if (diff_hr != -8) { break; }
			case "Pacific Standard Time":
				return "Pacific Standard Time";

			default:
				break;
		}
	}

	return ret;
}

long TimeGet() {
	SYSTEMTIME sysTime;
	GetSystemTime(&sysTime);
	long micros;

	micros = cast(long)sysTime.wHour;
	micros *= 60L;
	micros += cast(long)sysTime.wMinute;
	micros *= 60L;
	micros += cast(long)sysTime.wSecond;
	micros *= 1000;
	micros += cast(long)sysTime.wMilliseconds;
	micros *= 1000L;

	return micros;
}

long SystemTimeGet() {
	return timeGetTime();
}

void DateGet(out Month month, out uint day, out uint year) {
	SYSTEMTIME sysTime;
	GetSystemTime(&sysTime);
	
	month = cast(Month)(sysTime.wMonth - 1);
	day = sysTime.wDay;
	year = sysTime.wYear;
}