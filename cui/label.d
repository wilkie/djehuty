module cui.label;

import djehuty;

import io.console;

import cui.widget;

// Section: Console

// Description: This console control abstracts a simple static text field.
class CuiLabel : CuiWidget {

	this( uint x, uint y, uint width, string text,
		  Color fgclr = Color.Blue,
		  Color bgclr = Color.Black ) {
		super(x,y,width,1);

		_forecolor = fgclr;
		_backcolor = bgclr;

		_value = text.dup;
	}

	override void onAdd() {
	}

	override void onInit() {
	}

	// Properties

	// Description: this peroperty sets the value of the field
	// newValue: the new value of the field
	void text(string newValue) {
		_value = newValue.dup;
		onDraw();
	}

	// Description: this property returns the value of the field
	string text() {
		return _value.dup;
	}

	// Description: this property sets the foreground color of the field
	// fgclr: the color to set the foreground to
	void forecolor(Color fgclr) {
		_forecolor = fgclr;
		onDraw();
	}

	// Description: this property returns the foreground color of the field
	Color forecolor() {
		return _forecolor;
	}

	// Description: this property sets the background color of the field
	// bgclr: the color to set the background to
	void backcolor(Color bgclr) {
		_backcolor = bgclr;
		onDraw();
	}

	// Description: this property returns the background color of the field
	Color backcolor() {
		return _backcolor;
	}

	override void onDraw() {
		if (canDraw) {
			Console.position(0, 0);
			Console.forecolor = _forecolor;
			Console.backcolor = _backcolor;

			// draw as much as we can

			if (_value.length > this.width) {
				Console.put((_value[0..width]));
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

	Color _forecolor = Color.Blue;
	Color _backcolor = Color.Black;

	string _value;
}
