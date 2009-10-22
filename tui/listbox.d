module tui.listbox;

import core.string;
import core.main;
import core.definitions;
import core.list;

import io.console;

import tui.widget;

import interfaces.list;

// Section: Console

// Description: This console control abstracts a simple list of items.
class TuiListBox : TuiWidget, ListInterface!(String) {
	this( uint x, uint y, uint width, uint height ) {
		super(x,y,width,height);

		_list = new List!(String)();
	}

	override void onAdd() {
	}
	
	override void onDraw() {
		uint i;

		for (i = _firstVisible; (i < this.height + _firstVisible) && (i < _list.length); i++) {
			drawLine(i);
		}

		Console.setColor(_forecolor, _backcolor);

		for (; i < this.height + _firstVisible; i++) {
			Console.position(0, i-_firstVisible);
			Console.putSpaces(this.width);
		}
	}

	override void onKeyDown(Key key) {
		if (key.code == Key.Up) {
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
		if (_list.length > 0) {
			drawLine(_pos);
		}
	}

	override void onGotFocus() {
		Console.hideCaret();

		if (_list.length > 0) {
			drawLine(_pos);
		}
	}
	
	void add(String c) {
		_list.add(c);
	}
	
	String remove() {
		return _list.remove();
	}
	
	String removeAt(size_t idx){
		return _list.removeAt(idx);
	}
	
	String peek() {
		return _list.peek();
	}
	
	String peekAt(size_t idx) {
		return _list.peekAt(idx);
	}
	
	void set(String c) {
		_list.set(c);
	}
	
	void apply(String delegate(String) func) {
		_list.apply(func);
	}
	
	bool contains(String c) {
		return _list.contains(c);
	}
	
	bool empty() {
		return _list.empty();
	}
	
	void clear() {
		_list.clear();
	}
	
	String[] array() {
		return _list.array();
	}
	
	List!(String) dup() {
		return _list.dup();
	}
	
	List!(String) slice(size_t start, size_t end) {
		return _list.slice(start, end);
	}
	
	List!(String) reverse() {
		return _list.reverse();
	}
	
	size_t length() {
		return _list.length();
	}
	
	String opIndex(size_t i1) {
		return _list.opIndex(i1);
	}
	
	int opApply(int delegate(ref String) loopFunc) {
		return _list.opApply(loopFunc);
	}
	
	int opApply(int delegate(ref int, ref String) loopFunc) {
		return _list.opApply(loopFunc);
	}
	
	// methods

	override bool isTabStop() {
		return true;
	}

	// Description: This property returns the backcolor value for normal items.
	bgColor backcolor() {
		return _backcolor;
	}

	// Description: This property is for setting the backcolor for normal items.
	// value: The color to set the backcolor to
	void backcolor(bgColor value) {
		_backcolor = value;
	}

	// Description: This property returns the backcolor value for normal items.
	fgColor forecolor() {
		return _forecolor;
	}

	// Description: This property is for setting the forecolor for normal items.
	// value: The color to set the forecolor to
	void forecolor(fgColor value) {
		_forecolor = value;
	}

	// Description: This property returns the forecolor for selected items.
	fgColor selectedForecolor() {
		return _selectedForecolor;
	}

	// Description: This property is for setting the forecolor for selected items.
	// value: The color to set the forecolor to
	void selectedForecolor(fgColor value) {
		_selectedForecolor = value;
	}

	// Description: This property returns the backcolor for selected items.
	bgColor selectedBackcolor() {
		return _selectedBackcolor;
	}
	
	// Description: This property is for setting the backcolor for selected items.
	// value: The color to set the backcolor to
	void selectedBackcolor(bgColor value) {
		_selectedBackcolor = value;
	}

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

	List!(String) _list;
	
	fgColor _forecolor = fgColor.White;
	bgColor _backcolor = bgColor.Black;

	fgColor _selectedForecolor = fgColor.BrightYellow;
	bgColor _selectedBackcolor = bgColor.Black;
}
