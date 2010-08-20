/*
 * button.d
 *
 * This module implements a Gui push button widget.
 *
 */

module gui.button;

import djehuty;

import gui.window;

import graphics.canvas;
import graphics.brush;
import graphics.pen;
import graphics.font;

import resource.image;

import io.console;

class Button : Window {
private:
	string _value;
	Image _image;
	Position _imagePosition = Position.Center;
	bool _clicked;
	bool _hover;

	void _pressed() {
		_clicked = true;
		redraw();
		raiseSignal(Signal.Pressed);
	}

	void _released() {
		_clicked = false;
		redraw();
		raiseSignal(Signal.Released);
	}

public:
	enum Signal {
		Pressed,
		Released
	}

	this(double x, double y, double width, double height, string text = "") {
		_value = text.dup;
		super(x, y, width, height);
	}

	override void onKeyDown(Key key) {
		if (key.code == Key.Return || key.code == Key.Space) {
			_pressed();
		}
	}

	override void onKeyUp(Key key) {
		if (key.code == Key.Return || key.code == Key.Space) {
			_released();
		}
	}

	override void onMouseDown(Mouse mouse, uint button) {
		_pressed();
	}

	override void onMouseUp(Mouse mouse, uint button) {
		_released();
	}

	override void onMouseHover(Mouse mouse) {
		if (_hover == false) {
			_hover = true;
			redraw();
		}
	}

	override void onMouseLeave() {
		_hover = false;
		redraw();
	}

	override void onDraw(Canvas canvas) {
		Color clr = Color.Blue;

		if (_clicked) {
			clr.alpha = 1.0;
		}
		else if (!_hover) {
			clr.alpha = 0.7;
		}
		else {
			clr.alpha = 0.5;
		}

		Brush brush = new Brush(clr);

		clr = Color.Black;
		clr.alpha = 0.7;
		Pen pen = new Pen(clr);

		canvas.brush = brush;
		canvas.pen = pen;

		canvas.fillRectangle(0, 0, this.width, this.height);

		canvas.fillRectangle(0, 0, this.width, 2);
		canvas.fillRectangle(0, 2, 2, this.height-2);

		canvas.brush = new Brush(Color.fromRGBA(0.0, 0.0, 0.5, 0.7));

		canvas.fillRectangle(0, this.height-2, this.width, 2);
		canvas.fillRectangle(this.width-2, 0, 2, this.height-2);

		canvas.strokeRectangle(0, 0, this.width, this.height);

		canvas.pen = new Pen(Color.fromRGBA(0, 0, 0, 0.5), 2.0);
		canvas.brush = new Brush(Color.Black);
		canvas.font = new Font(FontSans, 16, 800, false, false, false);

		double textX, textY;
		auto size = canvas.font.measureString(_value);
		textX = (this.width - size.x) / 2.0;
		textY = (this.height - size.y) / 2.0;
		canvas.antialias = true;
		canvas.drawString(_value, textX, textY);
		canvas.antialias = false;

		if (_image !is null) {
			double posX, posY;
			switch(_imagePosition) {
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
			switch(_imagePosition) {
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

	// Description: This property is for the text displayed on the button.
	// value: The text for the button.
	// default: ""
	string text() {
		return _value.dup;
	}

	void text(string value) {
		_value = value.dup;
		redraw();
	}

	// Description: This property is for the image displayed on the button.
	// value: The loaded image class. The property will be null when no image
	//  is loaded.
	// default: null
	Image image() {
		return _image;
	}

	void image(Image value) {
		_image = value;
		redraw();
	}

	// Description: This property is for positioning the image on the button.
	// value: The position of the image.
	// default: Position.Center
	Position imagePosition() {
		return _imagePosition;
	}

	void imagePosition(Position value) {
		_imagePosition = value;
		redraw();
	}
}