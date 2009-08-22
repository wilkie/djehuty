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

import utils.arraylist;

class TuiFileBox : TuiWidget {
	this(uint x, uint y, uint width, uint height) {
		super(x,y,width,height);
		_path = new Directory();
		_list = _path.list;
	}

	override void onDraw() {
		uint i;

		for (i = _firstVisible; (i < this.height + _firstVisible) && (i < _list.length); i++) {
			drawLine(i);
		}

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
			if (_path.isDir(_list[_pos])) {
				_path = _path.traverse(_list[_pos]);
				_list = _path.list;
				_pos = 0;
				_firstVisible = 0;
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

	void onFileSelect(String file) {
	}

	void onDirectorySelect(String dir) {
	}

	// Methods

	override bool isTabStop() {
		return true;
	}

protected:

	void drawLine(uint pos) {
		Console.position(0, pos - _firstVisible);

		if(pos == _pos) {
			Console.setColor(fgColor.BrightYellow, bgColor.Black);
		}
		else {
			Console.setColor(fgColor.White, bgColor.Black);
		}

		Console.put(_list[pos]);
		
		if(_list[pos].length < this.width) {
			Console.putSpaces(this.width - _list[pos].length);
		}
	}

	uint _pos = 0;
	uint _firstVisible = 0;

	Directory _path;
	String[] _list;
}