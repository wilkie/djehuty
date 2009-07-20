/*
 * app.d
 *
 * This Scaffold holds the Application implementations for the Linux platform
 *
 * Author: Dave Wilkinson
 *
 */

module platform.unix.scaffolds.app;

import platform.unix.vars;
import platform.unix.common;
import platform.unix.main;

import graphics.view;
import graphics.graphics;

import gui.window;
import io.file;

import core.string;
import core.main;
import core.definitions;

import io.console;

void AppStart()
{
}

void AppEnd(uint exitCode)
{
	// this code is executed at uninitialization of the application
	_pfvars.running = false;
}
