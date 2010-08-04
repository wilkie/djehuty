/*
 * togglefield.d
 *
 * This module implements a CUI toggle-able field.
 *
 */

module cui.togglefield;

import djehuty;

import cui.window;
import cui.canvas;
import cui.label;

class CuiToggleField : CuiWindow {
private:

	CuiLabel _label;
	bool _toggled;

public:

	enum Signal {
		Changed
	}

	// Description: This constructor will create a new toggle field widget.
	this(int x, int y, int width, int height) {
		super(x,y,width,height);

		_label = new CuiLabel(4, 0, width-4, "");
		push(_label);
	}

	override void onDraw(CuiCanvas canvas) {
		canvas.position(0, (this.height-1) / 2);
		if (_toggled) {
			canvas.write("[x]");
		}
		else {
			canvas.write("[ ]");
		}
	}

	override void onPrimaryDown(ref Mouse mouse) {
		if (mouse.x < 3) {
			this.toggled = !this.toggled;
			redraw();
		}
	}
	
	// Properties

	// Description: This property holds the current toggled state.
	// value: The state of the toggle, which is either true for toggled and false otherwise.
	bool toggled() {
		return _toggled;
	}

	void toggled(bool value) {
		_toggled = value;
		raiseSignal(CuiToggleField.Signal.Changed);
		redraw();
	}
	
	// Description: This property holds the text for the toggle field.
	// value: The text that will be displayed with the field.
	string text() {
		return _label.text;
	}

	void text(string value) {
		_label.text = value;
	}
}