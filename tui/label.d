module tui.label;

import core.string;
import core.main;
import core.definitions;

import io.console;

import tui.widget;

// Section: Console

// Description: This console control abstracts a simple static text field.
class TuiLabel : TuiWidget {

	this( uint x, uint y, uint width, String text,
		  fgColor fgclr = fgColor.BrightBlue,
		  bgColor bgclr = bgColor.Black ) {
		super(x,y,width,1);

		_forecolor = fgclr;
		_backcolor = bgclr;

		_value = new String(text);
	}

	this( uint x, uint y, uint width, string text,
		  fgColor fgclr = fgColor.BrightBlue,
		  bgColor bgclr = bgColor.Black ) {
		super(x,y,width,1);

		_forecolor = fgclr;
		_backcolor = bgclr;

		_value = new String(text);
	}

	override void onAdd() {
	}

	override void onInit() {
	}

	// Properties

	// Description: this property sets the value of the field
	// newValue: the new value of the field
	void text(String newValue) {
		_value = new String(newValue);
		onDraw();
	}

	// Description: this peroperty sets the value of the field
	// newValue: the new value of the field
	void text(string newValue) {
		_value = new String(newValue);
		onDraw();
	}

	// Description: this property returns the value of the field
	String text() {
		return new String(_value);
	}

	// Description: this property sets the foreground color of the field
	// fgclr: the color to set the foreground to
	void forecolor(fgColor fgclr) {
		_forecolor = fgclr;
		onDraw();
	}

	// Description: this property returns the foreground color of the field
	fgColor forecolor() {
		return _forecolor;
	}

	// Description: this property sets the background color of the field
	// bgclr: the color to set the background to
	void backcolor(bgColor bgclr) {
		_backcolor = bgclr;
		onDraw();
	}

	// Description: this property returns the background color of the field
	bgColor backcolor() {
		return _backcolor;
	}

	override void onDraw() {
		if (canDraw) {
			Console.position(0, 0);
			Console.setColor(_forecolor, _backcolor);

			// draw as much as we can

			if (_value.length > this.width) {
				Console.put((new String(_value[0..width])));
			}
			else {
				Console.put(_value);
				for (uint i; i < this.width - _value.length; i++) {
					Console.put(" ");
				}
			}
		}
	}

protected:

private:

	fgColor _forecolor = fgColor.BrightBlue;
	bgColor _backcolor = bgColor.Black;

	String _value;
}
