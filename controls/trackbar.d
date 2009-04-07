module controls.trackbar;

import core.control;
import core.color;
import core.definitions;
import core.string;
import core.graphics;

import bases.trackbar;

template ControlPrintCSTRList()
{
	const char[] ControlPrintCSTRList = `
	this(int x, int y, int width, int height)
	{
		super(x,y,width,height);
	}


`;
}

class TrackBar : BaseTrackBar
{
	// support Events
	mixin(ControlAddDelegateSupport!("TrackBar", "TrackBarEvent"));

	// Description: This will create a button with the specified dimensions and text.
	this(int x, int y, int width, int height)
	{
		super(x,y,width,height);
	}

	override void OnDraw(ref Graphics g)
	{
		Brush brsh = new Brush(Color.Red);

		g.setBrush(brsh);

		g.drawRect(_x, _y, _r, _b);

		int barWidth;

		barWidth = cast(int)(cast(float)_width * (cast(float)(_value - _min) / cast(float)(_max - _min)));

		//writefln("barwidth: ", barWidth, " width: ", _width, " value: ", _value, " max: ", _max);

		brsh.setColor(Color.Green);
		g.setBrush(brsh);

		g.drawRect(_x, _y, barWidth + _x, _b);

	}
}
