/*
 * imagebox.d
 *
 * This module implements a box widget that displays an image.
 *
 */

module gui.imagebox;

import djehuty;

import gui.window;

import graphics.canvas;
import graphics.brush;

import decoders.image.decoder;

import resource.image;

import synch.timer;

import io.console;

class ImageBox : Window {
private:
	Image _image;
	Position _position = Position.Center;
	Timer _animationTimer;
	ImageFrameDescription _frameDesc;

	bool timerProc(Dispatcher dsp, uint signal) {
		image.next();

		_animationTimer.interval = _frameDesc.time;
		redraw();
		return true;
	}

public:
	this(double x, double y, double width, double height, string filename = null) {
		_animationTimer = new Timer();
		attach(_animationTimer, &timerProc);

		if (filename !is null) {
			this.image = new Image(filename);
			_frameDesc = this.image.frameDescription;
		}
		super(x, y, width, height);
	}

	this(double x, double y, string filename = null) {
		_animationTimer = new Timer();
		attach(_animationTimer, &timerProc);

		if (filename !is null) {
			this.image = new Image(filename);
			_frameDesc = this.image.frameDescription;

			super(x, y, _image.width, _image.height);
		}
		else {
			super(x, y, 0, 0);
		}
	}

	// Events

	override void onDraw(Canvas canvas) {
		// Fill background
		canvas.brush = new Brush(this.backcolor);
		canvas.fillRectangle(0, 0, this.width, this.height);

		// Draw image
		if (_image !is null) {
			double posX, posY;
			switch(_position) {
				case Position.Left:
				case Position.TopLeft:
				case Position.BottomLeft:
					posX = 0.0;
					break;
				case Position.Right:
				case Position.TopRight:
				case Position.BottomRight:
					posX = this.width - cast(double)_image.width;
					break;
				default:
					posX = (this.width - cast(double)_image.width) / 2.0;
					break;
			}
			switch(_position) {
				case Position.Top:
				case Position.TopLeft:
				case Position.TopRight:
					posY = 0.0;
					break;
				case Position.Bottom:
				case Position.BottomLeft:
				case Position.BottomRight:
					posY = this.height - cast(double)_image.height;
					break;
				default:
					posY = (this.height - cast(double)_image.height) / 2.0;
					break;
			}

			canvas.drawCanvas(_image.canvas, posX, posY);
		}
	}

	// Properties

	Image image() {
		return _image;
	}

	void image(Image value) {
		_image = value;
		_frameDesc = this.image.frameDescription;

		if (_image.numFrames > 1) {
			_animationTimer.stop();

			auto frameDesc = image.frameDescription;

			_animationTimer.interval = frameDesc.time;
			_animationTimer.start();
		}
		redraw();
	}

	Position position() {
		return _position;
	}

	void position(Position value) {
		_position = value;
		redraw();
	}
}