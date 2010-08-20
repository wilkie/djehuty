/*
 * label.d
 *
 * This module implements a simple label widget.
 *
 */

module gui.label;

import djehuty;

import gui.window;

import graphics.canvas;
import graphics.font;
import graphics.brush;
import graphics.pen;

class Label : Window {
private:
	Position _textPosition = Position.Center;
	string _text;

public:
	this(double x, double y, double width, double height, string text = "") {
		_text = text.dup;
		super(x, y, width, height);
	}

	override void onDraw(Canvas canvas) {
		canvas.antialias = true;

		Size sz;
		canvas.font = new Font(FontSans, 16, 200, false, false, false);
		sz = canvas.font.measureString(_text);

		canvas.brush = new Brush(Color.Black);
		canvas.pen = new Pen(Color.Black);

		double textX, textY;
		switch(_textPosition) {
			case Position.Top:
			case Position.Bottom:
			case Position.Center:
			default:
				textX = (this.width - sz.x) / 2.0;
				break;
			case Position.Left:
			case Position.TopLeft:
			case Position.BottomLeft:
				textX = 0.0;
				break;
			case Position.Right:
			case Position.TopRight:
			case Position.BottomRight:
				textX = this.width - sz.x;
				break;
		}
		switch(_textPosition) {
			case Position.Left:
			case Position.Right:
			case Position.Center:
			default:
				textY = (this.height - sz.y) / 2.0;
				break;
			case Position.Top:
			case Position.TopLeft:
			case Position.TopRight:
				textY = 0.0;
				break;
			case Position.Bottom:
			case Position.BottomLeft:
			case Position.BottomRight:
				textY = this.height - sz.y;
				break;
		}

		canvas.drawString(_text, textX, textY);
	}

	// Properties

	// Description: This property indicates the text displayed on the widget.
	// value: The text that will get displayed on the widget.
	// default: ""
	string text() {
		return _text.dup;
	}

	void text(string value) {
		_text = value.dup;
		redraw();
	}

	// Description: This property indicates how the text is positioned on
	//  the widget.
	// value: The position of the text.
	// default: Position.Center
	Position position() {
		return _textPosition;
	}

	void position(Position value) {
		_textPosition = value;
		redraw();
	}
}