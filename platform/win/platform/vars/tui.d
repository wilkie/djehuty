/*
 * tui.d
 *
 * This module contains state information for a tui app for Windows.
 *
 * Author: Dave Wilkinson
 * Originated: August 17th 2009
 *
 */

module platform.vars.tui;

import core.definitions;

import synch.thread;

import utils.linkedlist;

import platform.win.common;

struct TuiPlatformVars {
	// Window resize thread
	Thread t;

	// Standard in and out
	HANDLE stdin;
	HANDLE stdout;

	// Input state
	INPUT_RECORD irInBuf[128];

	LinkedList!(TuiEvent) events;
}