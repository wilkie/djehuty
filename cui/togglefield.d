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

	// Label for the text display
	CuiLabel _label;

	// The state of the widget
	bool _toggled;

	// To handle grouping
	CuiToggleField _next;

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
		if (_next !is null) {
			if (_toggled) {
				canvas.write("(o)");
			}
			else {
				canvas.write("( )");
			}
		}
		else {
			if (_toggled) {
				canvas.write("[x]");
			}
			else {
				canvas.write("[ ]");
			}
		}
	}

	override void onPrimaryDown(ref Mouse mouse) {
		if (mouse.x < 3) {
			// Cannot untoggle an option via the mouse.
			if (_toggled && this._next !is null) {
				return;
			}
			this.toggled = !this.toggled;
			redraw();
		}
	}

	// Methods

	// Description: This will add to the option group.
	// field: The field to group with the current one.
	void add(CuiToggleField field) {
		if (this._next is null) {
			field._next = this;
		}
		else {
			field._next = this._next;
		}
		this._next = field;
		this.toggled = true;
	}

	// Properties

	// Description: This property holds the current toggled state.
	// value: The state of the toggle, which is either true for toggled and false otherwise.
	bool toggled() {
		return _toggled;
	}

	void toggled(bool value) {
		if (_toggled != value) {
			_toggled = value;

			// untoggle every field in the group
			if (value == true) {
				auto current = this._next;
				while(current !is this && current !is null) {
					current.toggled = false;
					current = current._next;
				}
			}

			raiseSignal(CuiToggleField.Signal.Changed);
			redraw();
		}
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