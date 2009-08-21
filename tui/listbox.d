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
		moveCaret(0, 0);
		changeColor(fgColor.White, bgColor.Black);

		// draw all strings
		Iterator irate;
		irate = _list.getIterator();

		String data;
		uint i = 1;

		_spacestr = new char[width];
		_spacestr[0..width] = ' ';

		while(_list.getItem(data, irate)) {
			put(data.array);
			put(_spacestr[0..width-data.length]);
			if (i == 1){
				changeColor(fgColor.BrightWhite, bgColor.Black);
			}
			moveCaret(0, i);
			i++;
		}

		for ( ; i<=height; i++) {
			put(_spacestr);
			if (i != height) {
				moveCaret(0, i);
			}
		}
	}

	override void onKeyDown(Key key) {
		if (key.code == Key.Up) {
			String data;

			if (_pos > 0) {
				// draw over current
				_list.getItem(data, _pos);
				changeColor(fgColor.BrightWhite, bgColor.Black);
				moveCaret(0, _pos);
				put(data.array);
				// decrement
				_pos--;
				// draw new
				_list.getItem(data, _pos);
				changeColor(fgColor.BrightYellow, bgColor.Black);
				moveCaret(0, _pos);
				put(data.array);
			}
		}
		else if (key.code == Key.Down) {
			String data;

			if (_list.length > 0 && _pos < _list.length() - 1)
			{
				// draw over current
				_list.getItem(data, _pos);
				changeColor(fgColor.BrightWhite, bgColor.Black);
				moveCaret(0,_pos);
				put(data.array);
				// increment
				_pos++;
				// draw new
				_list.getItem(data, _pos);
				changeColor(fgColor.BrightYellow, bgColor.Black);
				moveCaret(0, _pos);
				put(data.array);
			}
		}
	}

	override void onLostFocus() {
		String data;

		if (_list.length > 0) {
			_list.getItem(data, _pos);
			changeColor(fgColor.White, bgColor.Black);
			moveCaret(0, _pos);
			put(data.array);
		}
	}

	override void onGotFocus() {
		hideCaret();

		String data;

		if (_list.length > 0) {
			_list.getItem(data, _pos);
			changeColor(fgColor.BrightYellow, bgColor.Black);
			moveCaret(0, _pos);
			put(data.array);
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

protected:

	uint _pos = 0;

	char[] _spacestr;

	ArrayList!(String) _list;
}
