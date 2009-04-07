module platform.win.scaffolds.app;

import platform.win.vars;
import platform.win.common;

import core.view;
import core.graphics;

import bases.window;
import core.window;
import platform.win.main;
import core.string;
import core.file;

import core.main;

import core.definitions;

import std.string;
import std.stdio;

import std.thread;
import std.gc;


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

		//gc_term();			// run finalizers; terminate garbage collector

		// end all threads
		// cleanup

		//Thread[] threads = Thread.getAll();

		//foreach(th; threads)
		//{
		//	delete th;
		//}

		//ExitProcess(0);
	}
	else
	{
		console_loop = false;
	}
}

