/*
 * filebox.d
 *
 * This module implements a CuiWidget that lists a directory.
 *
 */

module cui.filebox;

import djehuty;

import data.iterable;

import cui.listbox;

import io.directory;
import io.console;

class CuiFileBox : CuiListBox {
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

public:
	this(uint x, uint y, uint width, uint height) {
		super(x,y,width,height);
		_path = new Directory();

		_loadPath();
	}

	override void onKeyDown(Key key) {
		if (key.code == Key.Return) {
			size_t idx = this.selected;
			if (idx != int.max) {
				string curitem = this.peekAt(idx);

				bool traversed = true;
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
					return;
				}
			}
		}
		super.onKeyDown(key);
	}
}
