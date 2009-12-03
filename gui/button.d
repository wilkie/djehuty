/*
 * button.d
 *
 * This module implements a GUI push button widget.
 *
 * Author: Dave Wilkinson
 *
 */

module gui.button;

import gui.widget;

import core.color;
import core.definitions;
import core.string;

import graphics.graphics;
import graphics.brush;

template ControlPrintCSTRList() {
	const char[] ControlPrintCSTRList = `
	this(int x, int y, int width, int height, String value) {
		super(x,y,width,height,value);
	}
	this(int x, int y, int width, int height, string value) {
		super(x,y,width,height,value);
	}
	`;
}

// Description: This control will provide a simple push button.
class Button : Widget {

	enum Signal : uint {
		Pressed,
		Released,
		Selected,
	}

	// Description: This will create a button with the specified dimensions and text.
	this(int x, int y, int width, int height, String value) {
		super(x,y,width,height);
		_value = new String(value);
	}

	// Description: This will create a button with the specified dimensions and text.
	this(int x, int y, int width, int height, string value) {
		super(x,y,width,height);
		_value = new String(value);
	}

	override void onAdd() {
		_clrNormal = Color.fromRGBA(0x50, 0xd8, 0xee, 0x80);
		_clrHover = Color.fromRGBA(0x70, 0xf8, 0xff, 0xc0);

		_brsh = new Brush(_clrNormal);
		_pen = new Pen(Color.fromRGBA(0x20, 0xa8, 0xbe, 0xff));
		_font = new Font(FontSans, 8, 800, false, false, false);
	}

	override void onDraw(ref Graphics g) {
		g.setBrush(_brsh);
		g.setPen(_pen);

		g.drawRect(this.left, this.top, this.right, this.bottom);

		// Draw the text
		Size sz;

		g.setFont(_font);
		g.measureText(_value, sz);

		int x, y;

		x = this.left + ((this.width - sz.x)/2);
		y = this.top + ((this.height - sz.y)/2);

		g.setTextModeTransparent();
		
		Color textColor = Color.fromRGBA(0x00,0x00,0x00,0xc8);
		g.setTextColor(textColor);

		g.drawText(x, y, _value);
	}

	override bool onPrimaryMouseDown(ref Mouse mouseProps) {
		requestCapture();

		raiseSignal(Signal.Pressed);

		return true;
	}

	override bool onPrimaryMouseUp(ref Mouse mouseProps) {
		if (_hovered) {
			raiseSignal(Signal.Selected);
		}

		raiseSignal(Signal.Released);

		requestRelease();

		return true;
	}

	override bool onMouseEnter() {
		_brsh.color = _clrHover;

		return true;
	}

	override bool onMouseLeave() {
		_brsh.color = _clrNormal;

		return true;
	}

	void text(String newTitle) {
		_value = new String(newTitle);
	}

	void text(string newTitle) {
		_value = new String(newTitle);
	}

	String text() {
		return _value;
	}

protected:
	String _value;

private:
	
	Color _clrNormal;
	Color _clrHover;

	Brush _brsh;
	Pen _pen;

	Font _font;
}

