/*
 * mutex.d
 *
 * This module implements the platform specifics for the Mutex class.
 *
 * Author: Dave Wilkinson
 * Originated: July 25th, 2009
 *
 */

module platform.vars.mutex;

import platform.unix.common;

struct MutexPlatformVars {
	pthread_mutex_t mut_id;
}

