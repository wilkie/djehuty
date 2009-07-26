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

// Timing

// getting milliseconds
uint TimeGet()
{
	timeval val;

	gettimeofday(&val, null);
	uint ms = val.tv_sec * 1000;
	ms += (val.tv_usec / 1000);

	return ms;
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
