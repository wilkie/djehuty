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
		changeColor(fgColor.White, bgColor.Black);

		char[] _spacestr = new char[this.width];
		_spacestr[0..this.width] = ' ';

		foreach(uint i, item; _list) {
			moveCaret(0, i);
			put(item);
			if (((this.width - item.length) > 0) && ((this.width - item.length) < this.width)) {
				put(_spacestr[0..this.width-item.length]);
			}
			if (i == 0){
				changeColor(fgColor.White, bgColor.Black);
			}
		}

		for (uint i = _list.length ; i<=height; i++) {
			moveCaret(0, i);
			put(_spacestr);
		}
	}

	override void onKeyDown(Key key) {
		if (key.code == Key.Up) {
			String data;

			if (_pos > 0) {
				// draw over current
				data = _list[_pos];
				changeColor(fgColor.White, bgColor.Black);
				moveCaret(0, _pos);
				put(data);
				// decrement
				_pos--;
				// draw new
				data = _list[_pos];
				changeColor(fgColor.BrightYellow, bgColor.Black);
				moveCaret(0, _pos);
				put(data);
			}
		}
		else if (key.code == Key.Down) {
			String data;

			if (_list.length > 0 && _pos < _list.length - 1)
			{
				// draw over current
				data = _list[_pos];
				changeColor(fgColor.White, bgColor.Black);
				moveCaret(0,_pos);
				put(data.array);
				// increment
				_pos++;
				// draw new
				data = _list[_pos];
				changeColor(fgColor.BrightYellow, bgColor.Black);
				moveCaret(0, _pos);
				put(data.array);
			}
		}
		else if (key.code == Key.Return) {
			// Traverse Directory
			if (_path.isDir(_list[_pos])) {
				_path = _path.traverse(_list[_pos]);
				_list = _path.list;
				_pos = 0;
				onDraw();
				onDirectorySelect(_path.path);
			}
			else {
				onFileSelect(_path.path ~ "/" ~ _list[_pos]);
			}
		}
	}

	override void onLostFocus() {
		String data;

		if (_list.length > 0) {
			data = _list[_pos];
			changeColor(fgColor.Yellow, bgColor.Black);
			moveCaret(0, _pos);
			put(data.array);
		}
	}

	override void onGotFocus() {
		hideCaret();

		String data;

		if (_list.length > 0) {
			data = _list[_pos];
			changeColor(fgColor.BrightYellow, bgColor.Black);
			moveCaret(0, _pos);
			put(data.array);
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

	uint _pos = 0;

	Directory _path;
	String[] _list;
}