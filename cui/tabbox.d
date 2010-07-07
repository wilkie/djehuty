/*
 * tabs.d
 *
 * This module implements tabs of windows for CUI apps.
 *
 * Author: Dave Wilkinson
 * Originated: June 18th, 2010
 *
 */

module cui.tabbox;

import djehuty;

import data.list;

import cui.window;
import cui.canvas;

import io.console;

class CuiTabBox : CuiWindow {
private:
	// Keep the names of the tabs
	struct TabInfo {
		string name;
		CuiWindow window;
	}

	TabInfo[] _tabs;
	int _active;

<<<<<<< HEAD:cui/tabbox.d
class CuiTabBox : CuiContainer, Iterable!(CuiContainer) {
protected:

	override void _reportMove(uint x, uint y) {
		_base_y++;
		super._reportMove(x,y);
	}
	
	uint _old_base_y;
	size_t _curTab = 0;

	List!(CuiContainer) _tabList;

	Color _forecolor = Color.Gray;
	Color _backcolor = Color.Black;

	Color _selectedForecolor = Color.Yellow;
	Color _selectedBackcolor = Color.Black;

public:
	this(uint x, uint y, uint width, uint height) {
		super(x,y,width,height);
		_tabList = new List!(CuiContainer);
=======
public:
	this(int x, int y, int width, int height) {
		super(x, y, width, height);
>>>>>>> 7168ba66303a9911bd72a3752dc0134777b0ea6e:cui/tabbox.d
	}

	void title(string value) {
		_tabs[_active].name = value.dup;
	}

	string title() {
		return _tabs[_active].name;
	}

	override int clientHeight() {
		return this.height() - 1;
	}

	override void clientHeight(int value) {
		height(value + 1);
	}

	override void onPrimaryDown(ref Mouse mouse) {
		if (mouse.y != 0) {
			super.onPrimaryDown(mouse);
			return;
		}

		int pos = 0;
		foreach(size_t idx, tinfo; _tabs) {
			// Account for name + " "
			pos = pos + utflen(tinfo.name) + 1;
			if (mouse.x < pos) {
				_switchTo(idx);
				break;
			}
			// Account for "| "
			pos = pos + 2;
		}
	}

	void add(string title) {
		auto newTab = new CuiWindow(0, 1, this.width(), this.height()-1);
		newTab.visible = true;

		TabInfo tinfo;
		tinfo.window = newTab;
		tinfo.name = title.dup;

		_tabs ~= tinfo;
		_active = _tabs.length-1;

		// Make the current tab invisible
		if (this.active !is null) {
			this.active.visible = false;
		}

		// Push the tab as a subwindow to this widget
		super.push(newTab);
	}

	override void onDraw(CuiCanvas canvas) {
		onDrawChildren(canvas);

		// Draw the tab bar
		canvas.position(0, 0);
		foreach(tinfo; _tabs) {
			if (tinfo.window is this.active()) {
				canvas.forecolor = Color.Yellow;
			}
			else {
				canvas.forecolor = Color.Gray;
			}
			canvas.write(tinfo.name);
			canvas.forecolor = Color.Gray;
			canvas.write(" | ");
		}

		string rest = times(" ", this.width());
		canvas.write(rest);
	}

	override void onKeyDown(Key key) {
		if (key.alt && key.code >= Key.Zero && key.code <= Key.Nine) {
			int switchTo = key.code - Key.Zero;
			if (switchTo == 0) {
				switchTo = 10;
			}
			switchTo--;
			if (switchTo < _tabs.length) {
				_switchTo(switchTo);
			}
			return;
		}

		super.onKeyDown(key);
	}

	private void _switchTo(int idx) {
		if (_active == idx) {
			return;
		}

		_tabs[_active].window.visible = false;
		_active = idx;

		auto window = _tabs[_active].window;

		// Resize the tab if necessary
		if (window.width != clientWidth() || window.height != clientHeight()) {
			window.reposition(0, 1, clientWidth(), clientHeight());
		}

		window.visible = true;
		window.focused = true;

		redraw();
	}

	override void reposition(int left, int top, int width = -1, int height = -1) {
		// Do the normal resize and event calling
		super.reposition(left, top, width, height);

		// Reposition the current active window
		// Note: This means upon switching the tab, one might need to reposition the client area
		//   and then redraw.
		this.active.reposition(0, 1, clientWidth(), clientHeight());
	}

	override void push(Dispatcher dsp, SignalHandler handler = null) {
		CuiWindow window = cast(CuiWindow)dsp;

		if (window !is null) {
			// Push the window to the focused window
			this.active.push(dsp, handler);
		}
		else {
			super.push(dsp, handler);
		}
	}
<<<<<<< HEAD:cui/tabbox.d
	
	bool isTabStop() {
		return true;
	}
	
// properties
	
	size_t current() {
		return _curTab;
	}
	
	void current(size_t cur) {
		if(cur < _tabList.length()) {
			if (_curTab == cur) {
				return;
			}
			_tabList[_curTab].onLostFocus();
			_curTab = cur;

			if((_tabList[_curTab].width != this.width 
			  || _tabList[_curTab].height != (this.height-1))) {
				_tabList[_curTab].resize(width, height-1);
			}

			onDraw();

			_tabList[_curTab].onGotFocus();
		}
	}	

=======
>>>>>>> 7168ba66303a9911bd72a3752dc0134777b0ea6e:cui/tabbox.d
}
