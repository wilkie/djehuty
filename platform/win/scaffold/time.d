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

// Timing

uint TimeGet()
{
	return timeGetTime();
}