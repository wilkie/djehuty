module gui.textfield;

import gui.widget;

import core.color;
import core.definitions;
import core.string;

import graphics.graphics;

template ControlPrintCSTRList() {
	const char[] ControlPrintCSTRList = `
	this(int x, int y, int width, int height, String value) {
		super(x,y,width,height,value);
	}
	this(int x, int y, int width, int height, string value) {
		super(x,y,width,height,value);
	}
	`;
}

// Description: This control provides a standard one line text field.
class TextField : Widget {
public:

	enum Signal : uint {
		Selected,
		Unselected,
		Changed,
	}

	this(int x, int y, int width, int height, String value) {
		super(x,y,width,height);

		_value = new String(value);
	}

	this(int x, int y, int width, int height, string value) {
		super(x,y,width,height);

		_value = new String(value);
	}

	override void onAdd() {
		_clr_highlight.fromRGB(0xf8,0xf8,0xf8);
		_clr_outline = Color.DarkGray;
		_clr_background = Color.White;

		Graphics grp = _view.lockDisplay();

		_font = new Font(FontSans, 8, 400, false, false, false);
		grp.setFont(_font);

		if (_value.length > 0)
		{
			grp.measureText(_value, _value_size);
		}
		else
		{
			grp.measureText(new String(" "), _value_size);
			_value_size.x = 0;
		}

		_view.unlockDisplay();
	}

	void SelectionClear() {
		//deletes the selection

		if (_caret_pos != _sel_start)
		{
			InternalSelectionClear();

			RefreshViewport(_caret_pos);
		}
	}

	override bool onMouseMove(ref Mouse mouseProps) {
		//find the section when the left mouse button is pressed

		if (mouseProps.clicks != 1) {
			return false;
		}

		if (mouseProps.leftDown) {
			Graphics grp = _view.lockDisplay();
			//grp.setFont(_font);

			uint sel_start = 0;

			int x1 = mouseProps.x - (this.left + 3);

			if (x1 < 0) {
				sel_start = 0;
			}
			else {
				int x_test;

				Size s;

				sel_start = _first_char;

				grp.measureText(_value[_first_char.._first_char+1],s);

				x_test = (s.x / 2);

				while (x_test < x1 && sel_start < _value.length) {
					//proceed further down the string
					sel_start++;

					//get length of total string so far
					grp.measureText(_value[_first_char..sel_start],s);

					x_test = s.x;

					//get length of current character
					grp.measureText(_value[sel_start..sel_start+1],s);

					//add half of the current character
					x_test += (s.x / 2);
				}
			}

			if (_sel_start != sel_start) {
				_sel_start = sel_start;
				_view.unlockDisplay();

				RefreshViewport(sel_start);
				return true;
			}

			_view.unlockDisplay();

			RefreshViewport(sel_start);

		}
		return false;
	}

	override bool onPrimaryMouseDown(ref Mouse mouseProps) {
		//move caret

		// -- this section takes 'x' in terms of the control's position
		//    and gets the position under x.  Should be good for determining
		//    selections

		int x1 = mouseProps.x - (this.left + 3);

		if (x1 < 0) { _caret_pos = 0; return true; }

		Graphics grp = _view.lockDisplay();
		//grp.setFont(_font);

		int x_test;

		Size s;

		_caret_pos = _first_char;
		grp.measureText(_value[_first_char.._first_char+1], s);

		x_test = (s.x / 2);

		while (x_test < x1 && _caret_pos < _value.length) {
			//proceed further down the string
			_caret_pos++;

			//get length of total string so far
			grp.measureText(_value[_first_char.._caret_pos-_first_char], s);

			x_test = s.x;

			//get length of current character
			grp.measureText(_value[_caret_pos.._caret_pos+1], s);

			//add half of the current character
			x_test += (s.x / 2);
		}

		//void out any previous selection
		_sel_start = _caret_pos;

		//capture mouse

		requestCapture();

		if ((mouseProps.clicks % 3) == 0) {
			//select line
			_caret_pos = 0;
			_sel_start = _value.length;
		}
		if ((mouseProps.clicks % 2) == 0) {
			//select text from the current caret position
			//grab a word
			_caret_pos = 0;
			_sel_start = _value.length;
		}
		else {
		}

		_view.unlockDisplay();
		return true;
	}

	override bool onPrimaryMouseUp(ref Mouse mouseProps) {
		requestRelease();

		return false;
	}

	override bool onGotFocus(bool withWindow) {
		return true;
	}

	override bool onLostFocus(bool withWindow) {
		return true;
	}

	// Key Presses

	override bool onKeyDown(uint keyCode) {
		switch(keyCode) {
			case KeyArrowLeft:
				if (_caret_pos != 0) {
					_sel_start = --_caret_pos;
				}

				RefreshViewport(_caret_pos);

				break;
			case KeyArrowRight:
				if (_caret_pos != _value.length) {
					_sel_start = ++_caret_pos;
				}

				RefreshViewport(_caret_pos);

				break;
			case KeyArrowUp:
				break;
			case KeyArrowDown:
				break;
			case KeyDelete:

				if (_caret_pos == _sel_start) {
					if ( _caret_pos != _value.length ) {
						//delete the character to the right of the caret
						String str_partA, str_partB;

						str_partA = _value.subString(0, _caret_pos);
						str_partB = _value.subString(_caret_pos+1);

						_value = str_partA;
						_value.append(str_partB);

						//load the font, and get the size of the text when drawn

						Graphics grp = _view.lockDisplay();
						//grp.setFont(_font);

						if (_value.length > 0) {
							grp.measureText(_value, _value_size);
						}
						else {
							grp.measureText(new String(" "), _value_size);
							_value_size.x = 0;
						}

						_view.unlockDisplay();

						RefreshViewport(_caret_pos);

						//FIRE_EVENT(id, EventValueChanged, 0, 0);
					}
				}
				else {
					//clear selection
					SelectionClear();
				}

				break;

			case KeyBackspace:

				//erase

				if (_caret_pos == _sel_start) {
					if (_caret_pos != 0) {
						String str_partA, str_partB;

						_caret_pos--;

						str_partA = _value.subString(0, _caret_pos);
						str_partB = _value.subString(_caret_pos+1);

						_value = str_partA;
						_value.append(str_partB);

						_sel_start = _caret_pos;

						//load the font, and get the size of the text when drawn

						Graphics grp = _view.lockDisplay();
						//grp.setFont(_font);

						if (_value.length > 0)
						{
							grp.measureText(_value, _value_size);
						}
						else
						{
							grp.measureText(new String(" "), _value_size);
							_value_size.x = 0;
						}

						_view.unlockDisplay();

						RefreshViewport(_caret_pos);

						//FIRE_EVENT(id, EventValueChanged, 0, 0);
					}
				}
				else {
					//erase the selection

					SelectionClear();
				}

				break;

			default:

				//check for keyboard shortcut

				break;
		}

		return true;
	}

	override bool onKeyChar(dchar character) {
		//if this character is a character we can write out, then
		//alter the text of the field

		//add the letter into the text field

		//if there is a selection, clear it first
		SelectionClear();

		String str_partA;
		String str_partB;

		str_partA = _value.subString(0, _caret_pos);

		str_partB = _value.subString(_caret_pos);

		_sel_start = ++_caret_pos;

		_value = str_partA;
		_value.appendChar(character);
		_value.append(str_partB);

		//load the font, and get the size of the text when drawn

		Graphics grp = _view.lockDisplay();
		//grp.setFont(_font);

		if (_value.length > 0) {
			grp.measureText(_value, _value_size);
		}
		else {
			grp.measureText(new String(" "), _value_size);
			_value_size.x = 0;
		}

		_view.unlockDisplay();

		RefreshViewport(_caret_pos);

		//FIRE_EVENT(id, EventValueChanged, 0, 0);

		return true;
	}

	override void onDraw(ref Graphics g) {
		//Draw Background of Button
		Brush brush = new Brush(_clr_background);

		Pen pen = new Pen(_clr_outline);

		g.setBrush(brush);
		g.setPen(pen);

		g.drawRect(this.left, this.top, this.right, this.bottom);

		//Draw 3D Effect
		pen.setColor(_clr_highlight);
		g.setPen(pen);

		g.drawLine(this.left + 1, this.top + 1, this.right - 1, this.top + 1);
		g.drawLine(this.left + 1, this.top + 1, this.left + 1, this.bottom - 1);

		//Drawing Transparent Text
		g.setTextModeTransparent();

		//create Atmosphere for Selections
		brush.setColor(Color.Black);
		pen.setColor(Color.Black);

		//Draw Text

		Rect bounds;

		bounds.left = this.left + 1;
		bounds.right = this.right - 1;
		bounds.top = this.top + 1;
		bounds.bottom = this.bottom - 1;

		//g.setFont(_font);

		g.setTextColor(Color.Black);

		if (_caret_pos == _sel_start || (_caret_pos < _first_char && _sel_start < _first_char)) {
			//no selection visible
			g.drawText(this.left+3, this.top+2, _value[_first_char.._value.length]);

			//Draw Caret

			if (_caret_pos >= _first_char && _focused) {
				int x, y;

				y = this.top + 2;
				x = this.left + 3;

				Size s;

				if (_caret_pos > _first_char) {
					g.measureText(_value[_first_char.._caret_pos],s);

					x += s.x;
				}

				if (x < bounds.right) {
					g.drawLine(x,y,x,y+_value_size.y);
				}
			}
		}
		else {
			int x, y, x2, y2;
			Size s;

			uint from_pos;
			uint to_pos;

			if (_sel_start < _caret_pos) {
				from_pos = _sel_start;
				to_pos = _caret_pos;
			}
			else {
				from_pos = _caret_pos;
				to_pos = _sel_start;
			}

			x = this.left + 3;
			y = this.top + 2;

			//left side of the selection
			if (from_pos < _first_char) {
				from_pos = _first_char;
			}

			g.drawText(x,y,_value[_first_char..from_pos]);
			g.measureText(_value[_first_char..from_pos],s);

			x += s.x;

			g.setTextColor(Color.White);

			//draw background rect within the control's bounds
			g.measureText(_value[from_pos..to_pos],s);

			//get the width of the line above, use that to determine x2, the
			//width of the selection rectangle.

			//y2 is the height of the line with some room

			//x2 is reused, since it determines the position of the next part
			//of the string below when printing
			x2 = x + s.x;
			y2 = y + _value_size.y + 1;

			if (x2 >= this.right) {
				x2 = this.right - 1;
			}

			g.drawRect(x,y,x2,y2);

			//the selection
			g.drawText(x,y,_value[from_pos..to_pos]);

			g.setTextColor(Color.Black);

			//the right side of the selection
			g.drawText(x2, y, _value[to_pos.._value.length]);
		}
	}

	void text(String newTitle) {
		_value = new String(newTitle);
	}

	void text(string newTitle) {
		_value = new String(newTitle);
	}

	String text() {
		return _value;
	}

protected:

	String _value;

private:

	void RefreshViewport(uint onPos) {
		//check to see if onPos is already within viewing area
		//check to see what direction we are travelling
		//if left... from onPos go backwards a certain distance
		//if right... from onPos go forwards a certain distance
		//set _first_char accordingly

		if (_caret_pos > _value.length) {
			_caret_pos = _value.length;
		}

		Size s;

		//the width to move
		int movement_width = 45;
		int current_movement = 0;
		uint i;

		Graphics grp = _view.lockDisplay();

		if (onPos > _first_char) {
			//check to see if it is within the viewable area
			grp.measureText(_value[_first_char..onPos], s);

			if ((s.x + 3) < this.width) {
				//we are good
				_view.unlockDisplay();
				return;
			}
			else {
				//we are moving right

				//go forward

				i = onPos;

				while(current_movement < movement_width) {
					if (i > _value.length) {
						i = _value.length;
						break;
					}

					grp.measureText(_value[i..i+1], s);
					current_movement += s.x;

					i++;
				}

				//i is the rightmost character
				//go backwards from onPos to find
				//the first character

				i = onPos;

				while(current_movement < this.width) {
					if (i<=0) {
						i = 0;
						break;
					}

					i--;

					grp.measureText(_value[i..i+1],s);
					current_movement += s.x;
				}

				//i is the new first character
				_first_char = i + 1;
			}
		}
		else {
			//we are moving left

			//go backward

			i = onPos;

			while(current_movement < movement_width) {
				if (i<=0) {
					i = 0;
					break;
				}

				i--;

				grp.measureText(_value[i..i+1],s);
				current_movement += s.x;
			}

			//i is the new first character

			_first_char = i;
		}

		_view.unlockDisplay();

	}

	void InternalSelectionClear() {
		//deletes the selection

		if (_caret_pos != _sel_start) {
			if (_caret_pos < _sel_start) {
				//swap the two positions, so that
				//m_sel_start is at the beginning of the selection
				//and m_caret_pos marks the end
				_sel_start ^= _caret_pos;
				_caret_pos ^= _sel_start;
				_sel_start ^= _caret_pos;
			}

			String str_partA, str_partB;

			// new_string = subString(0 ---> _sel_start)

			str_partA = _value.subString(0, _sel_start);

			// new_string += subString(_caret_pos ---> <EOS>);

			str_partB = _value.subString(_caret_pos);

			_value = str_partA;
			_value.append(str_partB);

			//turn off the selection
			//make the selection start the new caret position
			_caret_pos = _sel_start;

			//load the font, and get the size of the text when drawn
			Graphics grp = _view.lockDisplay();
			//grp.setFont(_font);

			if (_value.length) {
				grp.measureText(_value, _value_size);
			}
			else {
				grp.measureText(new String(" "), _value_size);
				_value_size.x = 0;
			}

			_view.unlockDisplay();
		}
	}


	Size _value_size;

	Font _font;

	uint _first_char;		//the first character drawn
	uint _caret_pos;		//the caret position within the string
	uint _caret_on;		//if caret is currently drawn

	uint _sel_start;		//the start of the selection
							//_caret_pos is the end

	Color _clr_background;
	Color _clr_highlight;
	Color _clr_outline;
}
