/*
 * cui.d
 *
 * This module contains state information for a cui app for Windows.
 *
 * Author: Dave Wilkinson
 * Originated: August 17th 2009
 *
 */

module platform.vars.cui;

import core.definitions;

import synch.thread;

import data.queue;

import binding.win32.winnt;
import binding.win32.wincon;

struct CuiPlatformVars {
	// Window resize thread
	Thread t;

	// Standard in and out
	HANDLE stdin;
	HANDLE stdout;
	
	HANDLE[2] buffers;
	size_t bufferIndex;

	// Input state
	INPUT_RECORD[128] irInBuf;

	CHAR_INFO[][] screen;

	Queue!(Event) events;
}