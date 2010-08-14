/*
 * application.d
 *
 * This module implements the GUI application class that will be the starting
 * point for a GUI application. From this, Window classes with Widgets can be
 * created and pushed.
 *
 * Author: Dave Wilkinson
 * Originated: June 24th, 2009
 *
 */

module gui.application;

import core.application;
import core.event;

import gui.widget;
import gui.window;

// Platform Specific application entry
import gui.apploop;

import platform.vars.window;

import scaffold.window;

class GuiApplication : Application {
protected:
	Window _windowListHead = null;
	Window _windowListTail = null;

	int _windowCount;
	int _windowVisibleCount;

	override void start() {
		_appController.start();
	}

	override void end(uint exitCode) {
		_appController.end(exitCode);
	}

private:

	GuiApplicationController _appController;

	// Description: Will add and create the window (as long as it hasn't been already) and add it to the root window hierarchy.
	// window: An instance of a Window class, or any the inherit from Window.
	void addWindow(Window window) {
		WindowPlatformVars* wpv = &window._pfvars;

		synchronized {
			// update the window linked list
			updateWindowList(window);

			// increase global window count
			_windowCount++;

			// create the window through platform calls
			WindowCreate(window, wpv);
		}

		if (window.visible) {
			WindowSetVisible(window, wpv, true);
		}
	}

	void updateWindowList(Window window) {
		window._inited = true;

		if (_windowListHead is null)
		{
			_windowListHead = window;
			_windowListTail = window;

			window._nextWindow = window;
			window._prevWindow = window;
		}
		else
		{
			window._nextWindow = _windowListHead;
			window._prevWindow = _windowListTail;

			_windowListHead._prevWindow = window;
			_windowListTail._nextWindow = window;

			_windowListHead = window;
		}

		if (window._visible)
		{
			_windowVisibleCount++;
		}
	}

	package void destroyAllWindows()
	{
		Window w = _windowListHead;

		if (w is null) { return; }

		Window tmp = w;

		_windowListHead = null;
		_windowListTail = null;

		do
		{
			w.remove();

			w = w._nextWindow;

		} while (w !is tmp)

		_windowCount = 0;
		_windowVisibleCount = 0;
	}
public:

	// Constructors

	this() {
		_appController = new GuiApplicationController();
		super();
	}

	override void push(Dispatcher dsp) {
		if (cast(Window)dsp !is null) {
			addWindow(cast(Window)dsp);
		}

		super.push(dsp);
	}

	// Properties

	int numWindows() {
		return _windowCount;
	}

	int numVisible() {
		return _windowVisibleCount;
	}

	// Methods

	override bool isZombie() {
		return _windowVisibleCount == 0;
	}

	Window firstWindow() {
		return _windowListHead;
	}
}
