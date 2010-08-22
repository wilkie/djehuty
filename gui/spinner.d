/*
 * spinner.d
 *
 * This module implements a spinner widget for gui applications.
 *
 */

module gui.spinner;

import djehuty;

import graphics.canvas;
import graphics.brush;

import gui.window;

import synch.timer;

class Spinner : Window {
private:
	static const int ticks = 20;
	static const double maxAlpha = 0.5;

	int _tick;
	Timer _timer;
	Color _fg = Color.Black;

	bool timerProc(Dispatcher dsp, uint signal) {
		_tick = (_tick + 1) % ticks;
		redraw();
		return true;
	}

public:
	this(double x, double y, double width, double height) {
		_timer = new Timer(70);
		attach(_timer, &timerProc);
		_timer.start();
		super(x, y, width, height);
	}

	override void onDraw(Canvas canvas) {
		double alpha = 0.5;
		canvas.brush = new Brush(this.backcolor);
		canvas.fillRectangle(0, 0, this.width, this.height);

		long context = canvas.save();
		canvas.antialias = true;
		canvas.transformTranslate(this.width/2.0, this.height/2.0);

		// |--|--|--|--|--|--|--|--| <-- width of the widget
		//                xxxxxxx    <-- relative position of the tick

		double rotation = (2 * 3.14159265) / cast(double)ticks;
		double radius = this.width/8.0;
		double circumference = 2 * 3.14159265 * radius;
		double granularity = circumference / cast(double)ticks;
		for(int i = 0; i < ticks; i++) {
			int index = ((i + ticks - _tick) - 1) % ticks;
			alpha = (cast(double)index / cast(double)ticks) * _fg.alpha;
			canvas.brush = new Brush(Color.fromRGBA(_fg.red, _fg.green, _fg.blue, alpha));
			canvas.fillRectangle(radius, -this.width/32.0, this.width/4.0, granularity);
			canvas.transformRotate(rotation);
		}

		canvas.restore(context);
	}

	// Properties

	// Description: This property indicates the color of the indicator.
	// value: The color to render the indicator.
	// default: Color.Black
	Color forecolor() {
		return _fg;
	}

	void forecolor(Color value) {
		_fg = value;
		redraw();
	}
}