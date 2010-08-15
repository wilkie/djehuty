/*
 * spinner.d
 *
 * This module implements a CUI widget that will indicate loading progress.
 *
 */

module cui.spinner;

import djehuty;

import cui.window;
import cui.canvas;

import synch.timer;

class CuiSpinner : CuiWindow {
private:

	int _index;
	Timer _timer;

public:

	// Description: This will create a new spinner widget.
	this(int x, int y) {
		super(x, y, 5, 3);
		
		_timer = new Timer();
		_timer.interval = 100;

		attach(_timer);

		_timer.start();
	}

	override bool onSignal(Dispatcher dsp, uint signal) {
		if (dsp is _timer) {
			_index = (_index + 1) % 8;
			redraw();
			return true;
		}
		return false;
	}

	override void onDraw(CuiCanvas canvas) {
		canvas.backcolor = Color.Black;
		canvas.forecolor = Color.Gray;

		canvas.position(0, 0);
		canvas.write("\\|/");
		canvas.position(0, 1);
		canvas.write("\u2500 \u2500");
		canvas.position(0, 2);
		canvas.write("/|\\");

		canvas.forecolor = Color.White;

		switch(_index) {
			case 0:
				canvas.position(0,0);
				canvas.write("\\");
				break;
			case 1:
				canvas.position(1,0);
				canvas.write("|");
				break;
			case 2:
				canvas.position(2,0);
				canvas.write("/");
				break;
			case 3:
				canvas.position(2,1);
				canvas.write("\u2500");
				break;
			case 4:
				canvas.position(2,2);
				canvas.write("\\");
				break;
			case 5:
				canvas.position(1,2);
				canvas.write("|");
				break;
			case 6:
				canvas.position(0,2);
				canvas.write("/");
				break;
			case 7:
			default:
				canvas.position(0,1);
				canvas.write("\u2500");
				break;
		}
	}
}