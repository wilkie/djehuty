/*
 * semaphore.d
 *
 * This module has the structure that is kept with a Semaphore class for Windows.
 *
 * Author: Dave Wilkinson
 * Originated: July 22th, 2009
 *
 */

module platform.vars.semaphore;

import platform.win.common;

struct SemaphorePlatformVars {
	HANDLE _semaphore;
}