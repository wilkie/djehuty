/*
 * tabs.d
 *
 * This module implements tabs of windows for TUI apps.
 *
 * Author: Lindsey Bieda
 * Originated: October 14th 2009
 *
 */

module tui.tabs;

import tui.widget;
import tui.window;

import core.string;
import core.definitions;

import io.console;

import utils.arrylist;

class TuiTabs : TuiWidget {
	this(uint x, uint y, uint width, uint height) {
		super(x,y,width,height);
	}

	override void onAdd() {
	}

	override void onDraw() {
		//draw the tabs

	}

	void addItem(String name, TuiWindow win) {
		_nameList.addItem(name);
		_winList.addItem(win);
	}

	void addItem(string name, TuiWindow win) {
		_nameList.addItem(new String(name));
		_winList.addItem(win);
	}

	void removeItem(string name) {

	}

	void removeItem(String name) {

	}

	void setActive(int index) {
		curTab = index;
	}

	void setActive(string name) {

	}

	void setActive(String name) {

	}

protected:

	uint curTab = 0;

	ArrayList!(String) _nameList;
	ArrayList!(TuiWindow) _winList;

	fgColor _forecolor = fgColor.White;
	bgColor _backcolor = bgColor.Black;

	fgColor _selectedForecolor = fgColor.BrightYellow;
	bgColor _selectedBackcolor = bgColor.Black;
}

