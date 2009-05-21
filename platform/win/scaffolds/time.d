/*
 * time.d
 *
 * This file implements the Scaffold for platform specific Time
 * operations in Windows.
 *
 * Author: Dave Wilkinson
 *
 */

module platform.win.scaffolds.time;

import platform.win.common;
import platform.win.definitions;
import platform.win.vars;

// Timing

uint TimeGet()
{
	return timeGetTime();
}