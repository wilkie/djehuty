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

import core.definitions;
import core.string;
import core.date;
import core.time;

string TimeZoneGet() {
	return "";
}

// getting microseconds
long TimeGet() {
	return 0;
}

ulong SystemTimeGet() {
	return 0;
}

void DateGet(out Month month, out uint day, out uint year) {
}
