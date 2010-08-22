/*
 * progressbar.d
 *
 * This module implements a gui widget that provides a progress bar.
 *
 */

module gui.progressbar;

import djehuty;

import gui.window;

import graphics.canvas;
import graphics.brush;
import graphics.pen;
import graphics.path;

import data.iterable;

import synch.timer;

class ProgressBar : Window {
private:
	double _value = 0.0;
	double _animTranslate = 0.0;

	Timer _timer;

	bool timerProc(Dispatcher dsp, uint signal) {
		_animTranslate += 2.0;
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
		// Draw background of the window
		canvas.brush = new Brush(this.backcolor);
		canvas.fillRectangle(0, 0, this.width, this.height);

		// Get sizes
		double cornerSize = min([this.width, this.height]);
		cornerSize /= 8.0;
		cornerSize *= 3.0;

		double barSize = min([this.width, this.height]);
		barSize /= 3.0;

		canvas.antialias = true;

		// Draw background of the bar
		canvas.brush = new Brush(Color.fromRGBA(0.3, 0.3, 0.7, 0.5));

		Path bar = new Path();
		bar.addRoundedRectangle(0, 0, this.width, this.height, cornerSize, cornerSize, 90);
		canvas.fillPath(bar);

		if (_value > 0.0) {
			long context = canvas.save();

			// clip bar to indicate the progress
			canvas.clipRectangle(0, 0, this.width * _value, this.height);
			canvas.clipPath(bar);

			// Draw bar
			canvas.brush = new Brush(Color.fromRGBA(0.3, 0.3, 0.7, 0.7));
			canvas.fillPath(bar);

			double rotation = 3.14159265 / 4.0;

			canvas.pen = new Pen(Color.fromRGBA(0.3, 0.3, 0.7, 0.5));
			double step = barSize*2.4;
			for (double x = -step; x < this.width; x += step) {
				long innercontext = canvas.save();
				canvas.transformTranslate(x+(_animTranslate % step), 0);
				canvas.transformRotate(rotation);
				canvas.drawRectangle(0, -this.height/2, barSize, this.height*2);
				canvas.restore(innercontext);
			}

			canvas.restore(context);
		}

		canvas.pen = new Pen(Color.fromRGBA(0.1, 0.1, 0.5, 1.0));
		canvas.strokePath(bar);

		canvas.antialias = false;
	}

	// Description: This property indicates the amount that this progress bar
	//  will indicate has been done.
	// value: A value between 0.0 and 1.0 where 1.0 means the progress bar will
	//  be full and 0.0 means it will be empty.
	// default: 0.0
	double value() {
		return _value;
	}

	void value(double value) {
		_value = value;
		redraw();
	}
}