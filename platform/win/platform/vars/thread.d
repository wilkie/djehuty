/*
 * thread.d
 *
 * This module has the structure that is kept with a Thread class for Windows.
 *
 * Author: Dave Wilkinson
 * Originated: July 22th, 2009
 *
 */

module platform.vars.thread;

import synch.thread;

import binding.win32.winnt;
import binding.win32.windef;

struct ThreadPlatformVars {
	DWORD id;
	HANDLE threadHnd;
	Thread thread;
	void delegate() endCallback;
}