/*
 * app.d
 *
 * This file implements the Scaffold for the application states.
 *
 * Author: Dave Wilkinson
 *
 */

module platform.win.scaffolds.app;

import platform.win.vars;
import platform.win.common;
import platform.win.main;

import core.view;
import core.graphics;
import core.basewindow;
import core.window;
import core.string;
import core.file;
import core.main;
import core.definitions;

void AppStart()
{
}

void AppEnd()
{
	if (!Djehuty._console_inited)
	{
		// I think this is wrong: PostQuitMessage(0);

		// This is (albeit horrible) better:
		_appEnd = true;
	}
	else
	{
		console_loop = false;
	}
}

