/*
 * mutex.d
 *
 * This module has the structure that is kept with a Mutex class for Windows.
 *
 * Author: Dave Wilkinson
 * Originated: July 22th, 2009
 *
 */

module platform.vars.mutex;

import platform.win.common;

struct MutexPlatformVars {
	CRITICAL_SECTION* _mutex;

	HANDLE _semaphore;
}