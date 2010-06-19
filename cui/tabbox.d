/*
 * tabs.d
 *
 * This module implements tabs of windows for TUI apps.
 *
 * Author: Lindsey Bieda
 * Originated: October 14th 2009
 *
 */

module cui.tabbox;

import djehuty;

import data.list;

import cui.window;
import cui.canvas;

import io.console;

class CuiTabBox : CuiWindow {
	this(int x, int y, int width, int height) {
		super(x, y, width, height);

		// Push a new client area
		auto clientArea = new CuiWindow(0, 1, width, height-1);
		clientArea.visible = true;

		super.push(clientArea);
	}

	override void onDraw(CuiCanvas canvas) {
		onDrawChildren(canvas);

		// Draw the tab bar
		canvas.position(0, 0);
		canvas.write("tabbar");
	}

	override void reposition(int left, int top, int width = -1, int height = -1) {
		// Do the normal resize and event calling
		super.reposition(left, top, width, height);

		// Reposition the current active window
		// Note: This means upon switching the tab, one might need to reposition the client area
		//   and then redraw.
		this.active.reposition(0, 1, width, height-1);
	}

	override void push(Dispatcher dsp) {
		CuiWindow window = cast(CuiWindow)dsp;
		
		if (window !is null) {
			// Push the window to the focused window
			this.active.push(dsp);
		}
		else {
			super.push(dsp);
		}
	}
}
