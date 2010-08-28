/*
 * filebox.d
 *
 * This module implements a file listbox for directory listing in gui apps.
 *
 */

module gui.filebox;

import djehuty;

import data.iterable;

import gui.listbox;

import io.directory;
import io.console;

class FileBox : ListBox {
private:
	Directory _path;

	void _loadPath() {
		string[] list = sort(_path.list);
		if (!_path.isRoot) {
			list = [".."] ~ list;
		}
		foreach(item; list) {
			add(item);
		}
		this.selected = 0;
	}

	bool _traverse(size_t idx) {
		bool traversed = false;
		if (idx != int.max) {
			string curitem = this.peekAt(idx);

			traversed = true;
			if (curitem == "..") {
				_path = _path.parent;
			}
			else if (_path.isDir(curitem)) {
				_path = _path.traverse(curitem);
			}
			else {
				traversed = false;
			}

			if (traversed) {
				this.clear();
				_loadPath();
			}
		}
		
		return traversed;
	}

public:
	this(double x, double y, double width, double height) {
		super(x,y,width,height);
		_path = new Directory();

		_loadPath();
	}

	override void onMouseDown(Mouse mouse, uint button) {
		if ((mouse.clicks[0] % 2) == 0) {
			if (_traverse(this.selected)) {
				return;
			}
		}
		super.onMouseDown(mouse, button);
	}

	override void onKeyDown(Key key) {
		if (key.code == Key.Return) {
			if (_traverse(this.selected)) {
				return;
			}
		}
		super.onKeyDown(key);
	}

	// Description: This property represents the current path being listed.
	// Returns: A string representing the path of the directory.
	string path() {
		return _path.path;
	}

	void path(string value) {
		_path = Directory.open(value);
		_loadPath();
		redraw();
	}
}
