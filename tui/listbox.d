module tui.listbox;

import core.string;
import core.main;
import core.definitions;

import io.console;

import tui.widget;

import interfaces.list;

import utils.arraylist;

// Section: Console

// Description: This console control abstracts a simple list of items.
class TuiListBox : TuiWidget, AbstractList!(String) {
	this( uint x, uint y, uint width, uint height ) {
		super(x,y,width,height);

		_list = new ArrayList!(String)();
	}

	override void onAdd() {
	}
	
	override void onDraw() {
<<<<<<< HEAD:tui/listbox.d
		Console.position(0, 0);
		Console.setColor(fgColor.White, bgColor.Black);

		// draw all strings
		Iterator irate;
		irate = _list.getIterator();

		String data;
		uint i = 1;

		_spacestr = new char[width];
		_spacestr[0..width] = ' ';

		while(_list.getItem(data, irate)) {
			Console.put(data.array);
			Console.put(_spacestr[0..width-data.length]);
			if (i == 1){
				Console.setColor(fgColor.BrightWhite, bgColor.Black);
			}
			Console.position(0, i);
			i++;
		}

		for ( ; i<=height; i++) {
			Console.put(_spacestr);
			if (i != height) {
				Console.position(0, i);
			}
=======
		uint i;

		for (i = _firstVisible; (i < this.height + _firstVisible) && (i < _list.length); i++) {
			drawLine(i);
		}

		Console.setColor(_forecolor, _backcolor);

		for (; i < this.height + _firstVisible; i++) {
			Console.position(0, i-_firstVisible);
			Console.putSpaces(this.width);
>>>>>>> 55c858782d15c3bd5600c9cd22c01370d2262fab:tui/listbox.d
		}
	}

	override void onKeyDown(Key key) {
		if (key.code == Key.Up) {
<<<<<<< HEAD:tui/listbox.d
			String data;

			if (_pos > 0) {
				// draw over current
				_list.getItem(data, _pos);
				Console.setColor(fgColor.BrightWhite, bgColor.Black);
				Console.position(0, _pos);
				Console.put(data.array);
				// decrement
				_pos--;
				// draw new
				_list.getItem(data, _pos);
				Console.setColor(fgColor.BrightYellow, bgColor.Black);
				Console.position(0, _pos);
				Console.put(data.array);
			}
		}
		else if (key.code == Key.Down) {
			String data;

			if (_list.length > 0 && _pos < _list.length() - 1)
			{
				// draw over current
				_list.getItem(data, _pos);
				Console.setColor(fgColor.BrightWhite, bgColor.Black);
				Console.position(0,_pos);
				Console.put(data.array);
				// increment
				_pos++;
				// draw new
				_list.getItem(data, _pos);
				Console.setColor(fgColor.BrightYellow, bgColor.Black);
				Console.position(0, _pos);
				Console.put(data.array);
=======
			if (_pos == 0) {
				return;
			}

			if (_pos == _firstVisible) {
				_firstVisible--;
				_pos--;
				onDraw();

				return;
			}

			if (_pos > 0) {
				_pos--;
				drawLine(_pos+1);
				drawLine(_pos);
			}
		}
		else if (key.code == Key.Down) {
			if (_pos == _list.length - 1) {
				return;
			}

			if (_pos == (_firstVisible + this.height - 1)) {
				_firstVisible++;
				_pos++;
				onDraw();

				return;
			}

			if (_list.length > 0 && _pos < _list.length - 1) {
				_pos++;
				drawLine(_pos-1);
				drawLine(_pos);
>>>>>>> 55c858782d15c3bd5600c9cd22c01370d2262fab:tui/listbox.d
			}
		}
		else if (key.code == Key.PageUp) {
			if (_pos == 0) {
				return;
			}

			if (_pos != _firstVisible) {
				_pos = _firstVisible;
			}
			else {
				if (_firstVisible > this.height - 1) {
					_firstVisible -= this.height - 1;
				}
				else {
					_firstVisible = 0;
				}

				if (_pos > this.height - 1) {
					_pos -= this.height - 1;
				}
				else {
					_pos = 0;
				}
			}

			onDraw();
		}
		else if (key.code == Key.PageDown) {
			if (_pos == _list.length - 1) {
				return;
			}

			if (_pos != _firstVisible + this.height - 1) {
				_pos = _firstVisible + this.height - 1;
			}
			else {
				_firstVisible += this.height - 1;
				_pos += this.height - 1;

				if (_firstVisible > _list.length - this.height) {
					_firstVisible = _list.length - this.height;
				}
			}

			if ( _pos >= _list.length) {
				_pos = _list.length - 1;
			}

			onDraw();
		}
	}

	override void onLostFocus() {
<<<<<<< HEAD:tui/listbox.d
		String data;

		if (_list.length > 0) {
			_list.getItem(data, _pos);
			Console.setColor(fgColor.White, bgColor.Black);
			Console.position(0, _pos);
			Console.put(data.array);
=======
		if (_list.length > 0) {
			drawLine(_pos);
>>>>>>> 55c858782d15c3bd5600c9cd22c01370d2262fab:tui/listbox.d
		}
	}

	override void onGotFocus() {
		Console.hideCaret();

<<<<<<< HEAD:tui/listbox.d
		String data;

		if (_list.length > 0) {
			_list.getItem(data, _pos);
			Console.setColor(fgColor.BrightYellow, bgColor.Black);
			Console.position(0, _pos);
			Console.put(data.array);
=======
		if (_list.length > 0) {
			drawLine(_pos);
>>>>>>> 55c858782d15c3bd5600c9cd22c01370d2262fab:tui/listbox.d
		}
	}

	// methods

	override bool isTabStop() {
		return true;
	}

	void addItem(String data) {
		_list.addItem(data);
	}

	void addItem(string data) {
		_list.addItem(new String(data));
	}

	void addList(AbstractList!(String) list) {
		_list.addList(list);
	}

	void addList(String[] list) {
		_list.addList(list);
	}

    bool getItem(out String data, uint index) {
		return _list.getItem(data, index);
    }

	Iterator getIterator() {
		return _list.getIterator();
	}

	bool getItem(out String data, ref Iterator irate) {
		return _list.getItem(data, irate);
	}

	uint length() {
		return _list.length();
	}

	bool remove(out String item) {
		return _list.remove(item);
    }
    
	// Propeties

	// Description: This property is for setting the backcolor for normal items.
	bgColor backcolor() {
		return _backcolor;
	}

	void backcolor(bgColor value) {
		_backcolor = value;
	}

	// Description: This property is for setting the forecolor for normal items.
	fgColor forecolor() {
		return _forecolor;
	}

	void forecolor(fgColor value) {
		_forecolor = value;
	}

<<<<<<< HEAD:tui/listbox.d
=======
	// Description: This property is for setting the forecolor for selected items.
	fgColor selectedForecolor() {
		return _selectedForecolor;
	}

	void selectedForecolor(fgColor value) {
		_selectedForecolor = value;
	}

	// Description: This property is for setting the backcolor for selected items.
	bgColor selectedBackcolor() {
		return _selectedBackcolor;
	}

	void selectedBackcolor(bgColor value) {
		_selectedBackcolor = value;
	}

>>>>>>> 55c858782d15c3bd5600c9cd22c01370d2262fab:tui/listbox.d
protected:

	void drawLine(uint pos) {
		Console.position(0, pos - _firstVisible);

		if(pos == _pos) {
			Console.setColor(_selectedForecolor, _selectedBackcolor);
		}
		else {
			Console.setColor(_forecolor, _backcolor);
		}

		Console.put(_list[pos]);

		if(_list[pos].length < this.width) {
			Console.putSpaces(this.width - _list[pos].length);
		}
	}

	uint _pos = 0;
	uint _firstVisible = 0;

	char[] _spacestr;

	ArrayList!(String) _list;
	
	fgColor _forecolor = fgColor.White;
	bgColor _backcolor = bgColor.Black;

	fgColor _selectedForecolor = fgColor.BrightYellow;
	bgColor _selectedBackcolor = bgColor.Black;
}
