module gui.progressbar;

import gui.widget;

import core.color;
import core.definitions;
import core.string;

import graphics.graphics;

template ControlPrintCSTRList() {
	const char[] ControlPrintCSTRList = `
	this(int x, int y, int width, int height) {
		super(x,y,width,height);
	}


	`;
}

class ProgressBar : Widget {

	// Description: This will create a button with the specified dimensions and text.
	this(int x, int y, int width, int height) {
		super(x,y,width,height);
	}

	override void onDraw(ref Graphics g) {
		Brush brsh = new Brush(Color.Red);

		g.setBrush(brsh);

		g.drawRect(this.left, this.top, this.right, this.bottom);

		int barWidth;

		barWidth = cast(int)(cast(float)this.width * (cast(float)(_value - _min) / cast(float)(_max - _min)));

		//writefln("barwidth: ", barWidth, " width: ", this.width, " value: ", _value, " max: ", _max);

		brsh.setColor(Color.Green);
		g.setBrush(brsh);

		g.drawRect(this.left, this.right, barWidth + this.left, this.bottom);

	}
	
	// Properties

	void range(long[2] value) {
		_min = value[0];
		_max = value[1];

		if (_min > _max) { _min = _max; }
		if (_value < _min) { _value = _min; }
		if (_value > _max) { _value = _max; }
	}

	long[] range() {
		return [_min, _max];
	}

	void value(long val) {
		_value = val;

		if (_value < _min) { _value = _min; }
		if (_value > _max) { _value = _max; }
	}

	long value() {
		return _value;
	}

protected:

	long _min = 0;
	long _max = 100;
	long _value = 0;
}
