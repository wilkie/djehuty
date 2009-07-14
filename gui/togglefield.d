/*
 * togglefield.d
 *
 * This module implements a GUI widget for an optional selection.
 *
 * Author: Dave Wilkinson
 *
 */

module gui.togglefield;

import gui.widget;

import core.color;
import core.definitions;
import core.string;
import core.graphics;

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

// Description: This control provides a standard toggle field.  When grouped, these will act as a exclusive list of options, essentially a 'radio' or 'option' field.  Otherwise they are 'check' fields.
class ToggleField : Widget {

	enum Signal : uint {
		Selected,
		Unselected,
	}

	this(int x, int y, int width, int height, String value) {
		super(x,y,width,height);

		_value = new String(value);
	}

	this(int x, int y, int width, int height, string value) {
		super(x,y,width,height);

		_value = new String(value);
	}

	void unselect() {
		_btnstate = 0;
	}

	void select() {
		_btnstate = 1;
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

	// handle events
	override void onAdd() {
		_brsh = new Brush(Color.White);

		_clroutline.setRGB(0x80, 0x80, 0x80);
		_clrhighlight.setRGB(0xdd,0xdd,0xdd);
		_clrnormal.setRGB(0xaa,0xaa,0xaa);
		_clrforeground.setRGB(0,0,0);
		_clrbackground.setRGB(0xff,0xff,0xff);

		Graphics grp = _view.lockDisplay();

		_font = new Font(FontSans, 8, 400, false, false, false);

		grp.setFont(_font);
		grp.measureText(_value,_valueBounds);

		_view.unlockDisplay();

		//FIRE_EVENT(id,EventCreated,0,0);
	}

	override void onDraw(ref Graphics g) {
		//Draw Background of Button
		Brush brush;
		Pen pen;

		Rect chkRect;

		chkRect.left = this.left + 2;
		chkRect.top = this.top + 2;
		chkRect.right = (chkRect.left + this.height) - 4;
		chkRect.bottom = this.bottom - 2;

		if (_is_grouped) {
			if (chkRect.right > this.right) {
				chkRect.right = this.right;
				chkRect.top += (this.height - this.width) / 2;
				chkRect.bottom = chkRect.top + this.width;
			}

			brush = new Brush(_clrbackground);
			pen = new Pen(_clroutline);

			g.setBrush(brush);
			g.setPen(pen);

			g.drawRect(chkRect.left, chkRect.top, chkRect.right, chkRect.bottom);

			pen.setColor(_clrhighlight);

			g.drawLine(chkRect.left+1, chkRect.top+1, chkRect.right - 1, chkRect.top+1);
			g.drawLine(chkRect.left+1, chkRect.top+2, chkRect.left + 1, chkRect.bottom-1);

			//Draw Check

			if (_mouseholdstate == 1) {
				pen.setColor(_clrnormal);

				brush.setColor(_clrbackground);

				g.drawOval(chkRect.left + 3, chkRect.top + 3, chkRect.right - 3, chkRect.bottom-3);
			}
			else if (_btnstate == 1) {
				brush.setColor(_clrnormal);

				pen.setColor(_clrnormal);

				g.drawOval(chkRect.left + 3, chkRect.top + 3, chkRect.right - 3, chkRect.bottom - 3);

				if (_hovered) {
					pen.setColor(_clrhighlight);

					g.drawOval(chkRect.left + 4, chkRect.top + 4, chkRect.right - 4, chkRect.bottom-4);
				}

			}
			else if (_hovered) {
				pen.setColor(_clrhighlight);
				brush.setColor(_clrbackground);

				g.drawOval(chkRect.left + 3, chkRect.top + 3, chkRect.right - 3, chkRect.bottom-3);
			}
		}
		else {
			//Draw Background of Button

			chkRect.left = this.left + 2;
			chkRect.top = this.top + 2;
			chkRect.right = (chkRect.left + this.height) - 4;
			chkRect.bottom = this.bottom - 2;

			if (chkRect.right > this.right) {
				chkRect.right = this.right;
				chkRect.top += (this.height - this.width) / 2;
				chkRect.bottom = chkRect.top + this.width;
			}

			pen = new Pen(_clroutline);
			brush = new Brush(_clrbackground);

			g.setBrush(brush);
			g.setPen(pen);

			g.drawRect(chkRect.left, chkRect.top, chkRect.right, chkRect.bottom);

			pen.setColor(_clrhighlight);

			g.drawLine(chkRect.left+1, chkRect.top+1, chkRect.right - 1, chkRect.top+1);
			g.drawLine(chkRect.left+1, chkRect.top+2, chkRect.left + 1, chkRect.bottom-1);

			//Draw Check

			if (_mouseholdstate == 1) {
				pen.setColor(_clrnormal);
				brush.setColor(_clrbackground);

				g.drawRect(chkRect.left + 3, chkRect.top + 3, chkRect.right - 3, chkRect.bottom-3);
			}
			else if (_btnstate == 1) {
				brush.setColor(_clrnormal);
				pen.setColor(_clrnormal);

				g.drawRect(chkRect.left + 3, chkRect.top + 3, chkRect.right - 3, chkRect.bottom - 3);

				if (_hovered) {
					pen.setColor(_clrhighlight);

					g.drawRect(chkRect.left + 4, chkRect.top + 4, chkRect.right - 4, chkRect.bottom-4);
				}

			}
			else if (_hovered) {
				pen.setColor(_clrhighlight);
				brush.setColor(_clrbackground);

				g.drawRect(chkRect.left + 3, chkRect.top + 3, chkRect.right - 3, chkRect.bottom-3);
			}
		}

		//Draw the text
		g.setTextColor(_clrforeground);
		g.setTextModeTransparent();
		g.setFont(_font);
		Rect ctrlrt;
		ctrlrt.left = chkRect.right;
		ctrlrt.right = this.right;
		ctrlrt.top = this.top;
		ctrlrt.bottom = this.bottom;
		g.drawClippedText(chkRect.right + 4, (this.bottom + this.top-_valueBounds.y)/2, ctrlrt, _value);
	}

	override bool onPrimaryMouseDown(ref Mouse mouseProps) {
		if (!_enabled) { return false; }

		_mouseholdstate = 1;

		requestCapture();
		return true;
	}

	override bool onPrimaryMouseUp(ref Mouse mouseProps) {
		if (!_enabled) { return false; }

		requestRelease();

		_mouseholdstate = 0;

		if (_hovered) {
			if (!(_is_grouped && _btnstate)) {
				_btnstate = !_btnstate;
				raiseSignal(Signal.Selected);
			}
		}

		return true;
	}

	override bool onMouseEnter() {
		Graphics g = _view.lockDisplay();

		_brsh.setColor(Color.White);

		_view.unlockDisplay();

		return true;
	}

	override bool onMouseLeave() {
		Graphics g = _view.lockDisplay();

		Color c;
		c.setRGB(0xc8, 0xc8, 0xc8);

		_brsh.setColor(c);

		_view.unlockDisplay();

		return true;
	}

	override bool onKeyDown(uint keyCode) {
		return false;
	}

private:
	String _value;

	package bool _is_grouped = false;

	Brush _brsh;
	Pen _pen;

	Font _font;

	Color _clroutline;
	Color _clrhighlight;
	Color _clrnormal;
	Color _clrforeground;
	Color _clrbackground;

	int _btnstate = 0;
	int _mouseholdstate = 0;

	Size _valueBounds;
}