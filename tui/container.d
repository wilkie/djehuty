/*
 * container.d
 *
 * This module implements a widget container for TuiWidget.
 *
 * Author: Dave Wilkinson
 * Originated: August 20th 2009
 *
 */

module tui.container;

import tui.widget;

import core.event;

import io.console;

class TuiContainer : TuiWidget {
	this(uint x, uint y, uint width, uint height) {
		super(x,y,width,height);
	}

	override void onDraw() {
		Console.clipSave();
		Console.clipClear();
		Console.clipRect(this.left, this.top, this.right, this.bottom);

		// Go through child widget list and draw each one

		TuiWidget c = _firstControl;

		do {
			c =	c._prevControl;

			c.onDraw();
		} while(c != _firstControl);

		Console.clipRestore();
	}

	override void push(Dispatcher dsp) {
		if (cast(TuiWidget)dsp) {
		}
		super.push(dsp);
	}

protected:

	// head and tail of the control linked list
	TuiWidget _firstControl;	//head
	TuiWidget _lastControl;		//tail
}