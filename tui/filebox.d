/*
 * filebox.d
 *
 * This module implements a TuiWidget that lists a directory.
 *
 * Author: Dave Wilkinson
 * Originated: August 20th 2009
 *
 */

module tui.filebox;

import tui.listbox;
import tui.widget;

import io.directory;
import io.console;

import core.string;
import core.definitions;
import core.list;

class TuiFileBox : TuiWidget, Iterable!(string) {
	this(uint x, uint y, uint width, uint height) {
		super(x,y,width,height);
		_path = new Directory();
		_list = new List!(string);
		string[] list = _path.list.sort;
		if (!_path.isRoot) {
			list = [".."] ~ list;
		}
		foreach(item; list) {
			_list.add(item);
		}
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
		else if (key.code == Key.Return) {
			// Traverse Directory
			if (_list[_pos] == "..") {
				_path = _path.parent;
				string[] list = _path.list.sort;
				if (!_path.isRoot) {
					list = [".."] ~ list;
				}
				_list.clear();
				// XXX: Make this work for List!()
				foreach(item; list) {
					_list.add(item);
				}
				_pos = 0;
				_firstVisible = 0;
				onDraw();
				onDirectorySelect(_path.path);
			}
			else if (_path.isDir(_list[_pos])) {
				_path = _path.traverse(_list[_pos]);
				string[] list = _path.list.sort;
				if (!_path.isRoot) {
					list = [".."] ~ list;
				}
				_pos = 0;
				_firstVisible = 0;
				_list.clear();
				foreach(item; list) {
					_list.add(item);
				}
				onDraw();
				onDirectorySelect(_path.path);
			}
			else {
				onFileSelect(_path.path ~ "/" ~ _list[_pos]);
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

	// Events

	// Description: This event will be fired upon selection of a file within the widget.
	// file: The complete path to the file.
	void onFileSelect(string file) {
	}

	// Description: This event will be fired upon selection of a directory within the widget.
	// dir: The complete path to the directory.
	void onDirectorySelect(string dir) {
	}

	// Methods

	override bool isTabStop() {
		return true;
	}
	
	void add(string c) {
		return;
	}
	
	string remove() {
		return _list.peek();
	}
	
	string removeAt(size_t idx){
		return _list.peekAt(idx);
	}
	
	string peek() {
		return _list.peek();
	}
	
	string peekAt(size_t idx) {
		return _list.peekAt(idx);
	}
	
	void set(string c) {
		return;
	}
	
	void apply(string delegate(string) func) {
		return;
	}
	
	bool contains(string c) {
		return _list.contains(c);
	}
	
	bool empty() {
		return _list.empty();
	}
	
	void clear() {
		return;
	}
	
	string[] array() {
		return _list.array();
	}
	
	List!(string) dup() {
		return _list.dup();
	}
	
	List!(string) slice(size_t start, size_t end) {
		return _list.slice(start, end);
	}
	
	List!(string) reverse() {
		return _list.reverse();
	}
	
	size_t length() {
		return _list.length();
	}
	
	string opIndex(size_t i1) {
		return _list.opIndex(i1);
	}
	
	int opApply(int delegate(ref string) loopFunc) {
		return _list.opApply(loopFunc);
	}
	
	int opApply(int delegate(ref size_t, ref string) loopFunc) {
		return _list.opApply(loopFunc);
	}

	int opApplyReverse(int delegate(ref string) loopFunc) {
		return _list.opApplyReverse(loopFunc);
	}

	int opApplyReverse(int delegate(ref size_t, ref string) loopFunc) {
		return _list.opApplyReverse(loopFunc);
	}

	void opCatAssign(string[] list) {
		_list.opCatAssign(list);
	}

	void opCatAssign(Iterable!(string) list) {
		_list.opCatAssign(list);
	}

	void opCatAssign(string item) {
		_list.opCatAssign(item);
	}

	Iterable!(string) opCat(string[] list) {
		return _list.opCat(list);
	}

	Iterable!(string) opCat(Iterable!(string) list) {
		return _list.opCat(list);
	}

	Iterable!(string) opCat(string item) {
		return _list.opCat(item);
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

	Directory _path;
	List!(string) _list;

	fgColor _forecolor = fgColor.White;
	bgColor _backcolor = bgColor.Black;

	fgColor _selectedForecolor = fgColor.BrightYellow;
	bgColor _selectedBackcolor = bgColor.Black;

}
