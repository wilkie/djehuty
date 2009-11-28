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

// Timing

//XXX:MMSystem.h

extern(System) DWORD timeGetTime();

uint TimeGet() {
	return timeGetTime();
}

void DateGet(out Month month, out uint day, out uint year) {
	SYSTEMTIME st;
	GetSystemTime(&st);
	
	month = cast(Month)(st.wMonth - 1);
	day = st.wDay;
	year = st.wYear;
}