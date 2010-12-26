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
import graphics.path;
import graphics.contour;
import graphics.region;

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

	Region r;
public:
	this(double x, double y, double width, double height) {
		_timer = new Timer(70);
		attach(_timer, &timerProc);
		_timer.start();
		super(x, y, width, height);

		r = new Region();
		Contour c = new Contour();
		c.addLine(50,50,200,50);
		c.addLine(200,200,50,200);
		r.addContour(c);
		c = new Contour();
		c.addLine(100,100,150,100);
		c.addLine(150,150,100,150);
		r.addContour(c);

	}

	override void onDraw(Canvas canvas) {
		double alpha = 0.5;
		canvas.brush = new Brush(this.backcolor);
		canvas.fillRectangle(0, 0, this.width, this.height);

		long context = canvas.save();
		canvas.antialias = true;
		canvas.brush = new Brush(Color.Red);

		Contour c = new Contour();
		c.addCurve(200, 200, 250, 200, 225, 225);
//		c.addLine(200, 200, 250, 200);
		c.addLine(250, 200, 275, 200);
		c.addCurve(300, 300, 350, 300, 325, 325);
//		c.addLine(300, 300, 350, 300);
		c.addCurve(250, 150, 200, 150, 200, 125);
//		c.addLine(250, 150, 200, 150);
		canvas.drawContour(c);
//		Path p = new Path();
//		p.addCurve(0, 0, this.width, 0, this.width/3, this.height);
//		canvas.drawPath(p);

		canvas.drawRegion(r);
//		canvas.drawQuadratic(0, 0, this.width, 0, this.width/3, this.height);
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
