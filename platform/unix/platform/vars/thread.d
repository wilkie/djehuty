/*
 * thread.d
 *
 * This module implements the platform specifics for the Thread class.
 *
 * Author: Dave Wilkinson
 * Originated: July 25th, 2009
 *
 */

module platform.vars.thread;

import platform.unix.common;

import synch.thread;

struct ThreadPlatformVars {
	pthread_t id;
	Thread thread;
}
