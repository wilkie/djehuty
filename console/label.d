module console.label;

import core.string;
import core.main;
import core.definitions;

import console.main;
import console.window;
import console.control;

// Section: Console

// Description: This console control abstracts a simple static text field.
class ConsoleLabel : ConsoleControl {

	this( uint x, uint y, uint width, String text,
		  fgColor fgclr = fgColor.BrightBlue, 
		  bgColor bgclr = bgColor.Black )
	{
		super(x,y,width,1);

		forecolor = fgclr;
		backcolor = bgclr;

		_value = new String(text);
	}

	this( uint x, uint y, uint width, StringLiteral text,
		  fgColor fgclr = fgColor.BrightBlue, 
		  bgColor bgclr = bgColor.Black )
	{
		super(x,y,width,1);

		forecolor = fgclr;
		backcolor = bgclr;

		_value = new String(text);
	}

	override void OnAdd() {
	}

	override void OnInit() {
		draw();
	}

	void setText(String newValue) {
		_value = new String(newValue);
		draw();
	}

	void setText(StringLiteral newValue) {
		_value = new String(newValue);
		draw();
	}

	void setForeColor(fgColor fgclr) {
		forecolor = fgclr;
	}
	
	void setBackColor(bgColor bgclr) {
		backcolor = bgclr;
	}

protected:

	void draw() {
		Console.setPosition(_x, _y);
		Console.setColor(forecolor, backcolor);

		// draw as much as we can

		if (_value.length > _width) {
			Console.put((new String(_value[0.._width])));
		}
		else {
			Console.put(_value);
		}
	}

	fgColor forecolor = fgColor.BrightBlue;
	bgColor backcolor = bgColor.Black;

	String _value;
}
