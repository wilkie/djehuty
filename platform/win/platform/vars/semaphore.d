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

import binding.win32.winnt;

struct SemaphorePlatformVars {
	HANDLE _semaphore;
}