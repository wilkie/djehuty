module cui.button;

import djehuty;

import cui.window;
import cui.canvas;

class CuiButton : CuiWindow {
private:

	Color _bg = Color.Gray;
	Color _fg = Color.Blue;

	bool _pressed;

	string _text;

public:
	enum Signal {
		Pressed,
		Released
	}

	this(int x, int y, int width, int height, string text = "") {
		_text = text.dup;
		super(x, y, width, height);
	}

	void onPrimaryDown(ref Mouse mouse) {
		raiseSignal(Signal.Pressed);
		_pressed = true;
		redraw();
	}

	void onPrimaryUp(ref Mouse mouse) {
		_pressed = false;
		raiseSignal(Signal.Released);
		redraw();
	}

	void onDraw(CuiCanvas canvas) {
		static const string BORDER_LEFT_CHAR = "\u258c";
		static const string BORDER_RIGHT_CHAR = "\u2590";

		if (_pressed) {
			canvas.forecolor = _bg;
			canvas.backcolor = _fg;
		}
		else {
			canvas.forecolor = _fg;
			canvas.backcolor = _bg;
		}

		uint textY = this.height / 2;
		uint textX = (this.width - _text.utflen()) / 2;
		if (textX > this.width || textX < 1) {
			textX = 1;
		}

		for(uint i = 0; i < this.height; i++) {
			canvas.position(0, i);
			canvas.write(BORDER_LEFT_CHAR);

			if (i == textY) {
				for(uint x = 1; x < textX; x++) {
					canvas.write(" ");
				}
				canvas.write(_text);
				for(uint x = textX + _text.utflen() + 1; x < this.width; x++) {
					canvas.write(" ");
				}
			}
			else {
				for(uint x = 2; x < this.width; x++) {
					canvas.write(" ");
				}
			}

			canvas.write(BORDER_RIGHT_CHAR);
		}
	}

	// Properties

	string text() {
		return _text.dup;
	}

	void text(string value) {
		_text = value.dup;
		redraw();
	}
	
	Color forecolor() {
		return _fg;
	}
	
	void forecolor(Color value) {
		_fg = value;
		redraw();
	}
	
	Color backcolor() {
		return _bg;
	}
	
	void backcolor(Color value) {
		_bg = value;
		redraw();
	}
}