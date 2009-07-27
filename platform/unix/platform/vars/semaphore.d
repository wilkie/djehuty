/*
 * semaphore.d
 *
 * This module implements the platform specifics for the Semaphore class.
 *
 * Author: Dave Wilkinson
 * Originated: July 25th, 2009
 *
 */

module platform.vars.semaphore;

import platform.unix.common;

struct SemaphorePlatformVars {
	sem_t sem_id;
}
