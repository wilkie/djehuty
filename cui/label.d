module cui.label;

import djehuty;

import cui.window;
import cui.canvas;

// Section: Console

// Description: This console control abstracts a simple static text field.
class CuiLabel : CuiWindow {
private:

	Color _forecolor = Color.Blue;
	Color _backcolor = Color.Black;

	string _value;

public:
	this( uint x, uint y, uint width, string text,
		  Color fgclr = Color.Blue,
		  Color bgclr = Color.Black ) {
		super(x,y,width,1);

		_forecolor = fgclr;
		_backcolor = bgclr;

		_value = text.dup;
	}

	// Properties

	// Description: this peroperty sets the value of the field
	// newValue: the new value of the field
	void text(string newValue) {
		_value = newValue.dup;
		redraw();
	}

	// Description: this property returns the value of the field
	string text() {
		return _value.dup;
	}

	// Description: this property sets the foreground color of the field
	// fgclr: the color to set the foreground to
	void forecolor(Color fgclr) {
		_forecolor = fgclr;
		redraw();
	}

	// Description: this property returns the foreground color of the field
	Color forecolor() {
		return _forecolor;
	}

	// Description: this property sets the background color of the field
	// bgclr: the color to set the background to
	void backcolor(Color bgclr) {
		_backcolor = bgclr;
		redraw();
	}

	// Description: this property returns the background color of the field
	Color backcolor() {
		return _backcolor;
	}

	override void onDraw(CuiCanvas canvas) {
		canvas.forecolor = _forecolor;
		canvas.backcolor = _backcolor;

		// draw as much as we can

		if (_value.length > this.width) {
			canvas.write(_value[0..width]);
		}
		else {
			canvas.write(_value);
			for (uint i; i < this.width - _value.length; i++) {
				canvas.write(" ");
			}
		}
	}
}
