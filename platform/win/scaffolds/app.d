/*
 * app.d
 *
 * This file implements the Scaffold for the application states.
 *
 * Author: Dave Wilkinson
 *
 */

module platform.win.scaffolds.app;

import platform.win.main;

import core.main;
import console.main;

void AppStart()
{
}

void AppEnd(uint code) {
	exitCode = code;
	console_loop = false;
	_appEnd = true;
}

