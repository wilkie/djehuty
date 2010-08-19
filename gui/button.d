/*
 * button.d
 *
 * This module implements a Gui push button widget.
 *
 */

module gui.button;

import djehuty;

import gui.window;

import graphics.canvas;
import graphics.brush;
import graphics.pen;

import io.console;

class Button : Window {
private:
	string _value;

public:
	this(double x, double y, double width, double height, string text = "") {
		_value = text.dup;
		super(x, y, width, height);
	}

	override void onKeyDown(Key key) {
		putln("key down ", key.code);
	}

	override void onKeyChar(dchar chr) {
		putln(chr);
	}

	override void onKeyUp(Key key) {
		putln("key up ", key.code);
	}

	override void onMouseDown(Mouse mouse, uint button) {
		putln("down ", button, " clicks: ", mouse.clicks[button]);
	}

	override void onMouseUp(Mouse mouse, uint button) {
		putln("up ", button);
	}

	override void onHover(Mouse mouse) {
		putln("hover");
	}

	override void onDrag(Mouse mouse) {
		putln("drag");
	}

	override void onDraw(Canvas canvas) {
		Color clr = Color.Blue;
		clr.alpha = 0.7;
		Brush brush = new Brush(clr);

		clr = Color.Black;
		clr.alpha = 0.7;
		Pen pen = new Pen(clr);

		canvas.brush = brush;
		canvas.pen = pen;

		canvas.fillRectangle(0, 0, this.width, this.height);

		canvas.fillRectangle(0, 0, this.width, 2);
		canvas.fillRectangle(0, 2, 2, this.height-2);

		canvas.brush = new Brush(Color.fromRGBA(0.0, 0.0, 0.5, 0.7));

		canvas.fillRectangle(0, this.height-2, this.width, 2);
		canvas.fillRectangle(this.width-2, 0, 2, this.height-2);

		canvas.strokeRectangle(0, 0, this.width, this.height);
	}

	// Properties

	string text() {
		return _value.dup;
	}

	void text(string value) {
		_value = value.dup;
		redraw();
	}
}