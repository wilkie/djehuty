module tui.listbox;

import core.string;
import core.main;
import core.definitions;

import console.main;

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

	override bool isTabStop() {
		return true;
	}

	override void onAdd() {
	}

	override void onInit() {
		Console.setPosition(x, y);
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
			Console.setPosition(x, y+i);
			i++;
		}

		for ( ; i<=height; i++) {
			Console.put(_spacestr);
			if (i != height) {
				Console.setPosition(x, y+i);
			}
		}
	}

	override void onKeyDown(uint keyCode) {
		if (keyCode == KeyTab) {
			window.tabForward();
		}
		else if (keyCode == KeyArrowUp) {
			String data;

			if (_pos > 0) {
				// draw over current
				_list.getItem(data, _pos);
				Console.setColor(fgColor.BrightWhite, bgColor.Black);
				Console.setPosition(x, y+_pos);
				Console.put(data.array);
				// decrement
				_pos--;
				// draw new
				_list.getItem(data, _pos);
				Console.setColor(fgColor.BrightYellow, bgColor.Black);
				Console.setPosition(x, y+_pos);
				Console.put(data.array);
			}
		}
		else if (keyCode == KeyArrowDown) {
			String data;

			if (_pos < _list.length() - 1)
			{
				// draw over current
				_list.getItem(data, _pos);
				Console.setColor(fgColor.BrightWhite, bgColor.Black);
				Console.setPosition(x, y+_pos);
				Console.put(data.array);
				// increment
				_pos++;
				// draw new
				_list.getItem(data, _pos);
				Console.setColor(fgColor.BrightYellow, bgColor.Black);
				Console.setPosition(x, y+_pos);
				Console.put(data.array);
			}
		}
	}

	override void onLostFocus() {
		String data;

		_list.getItem(data, _pos);
		Console.setColor(fgColor.White, bgColor.Black);
		Console.setPosition(x, y+_pos);
		Console.put(data.array);
	}

	override void onGotFocus() {
		Console.hideCaret();

		String data;

		_list.getItem(data, _pos);
		Console.setColor(fgColor.BrightYellow, bgColor.Black);
		Console.setPosition(x, y+_pos);
		Console.put(data.array);
	}


	// methods

	// IList Methods:

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
