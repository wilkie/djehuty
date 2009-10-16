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
		_tabList = new ArrayList!(_tabItem);
	}

	override void onAdd() {
	}

	override void onDraw() {
		//draw the tabs

	}

	void addItem(String name, TuiWindow win) {
		_tabItem t = {name, win};
		_tabList.addItem(t);
	}

	void addItem(string name, TuiWindow win) {
		_tabItem t = {new String(name), win};
		_tabList.addItem(t);
	}

	bool removeItem(string name) {
		String name = new String(name);
		_tabItem item;
		
		for(int i=0; i<_tabList.length(); i++) {
			_tabList.getItem(item, i);
			if(item._name == name){
				_tabList.removeAt(i);
				return true;
			}
		}
		
		return false;
	}

	bool removeItem(String name) {
		_tabItem item;
		
		for(int i=0; i<_tabList.length(); i++) {
			_tabList.getItem(item, i);
			if(item._name == name){
				_tabList.removeAt(i);
				return true;
			}
		}
		
		return false;
	}

	void setActive(int index) {
		curTab = index;
	}

	void setActive(string name) {
		String name = new String(name);
		_tabItem item;
		
		for(int i=0; i<_tabList.length(); i++) {
			_tabList.getItem(item, i);
			if(item._name == name){
				curTab = i;
				return;
			}
		}
	}

	void setActive(String name) {
		_tabItem item;
		
		for(int i=0; i<_tabList.length(); i++) {
			_tabList.getItem(item, i);
			if(item._name == name){
				curTab = i;
				return;
			}
		}
	}

protected:
	struct _tabItem {
		String _name;
		TuiWindow _winList;
	}
	
	uint curTab = 0;

	ArrayList!(_tabItem) _tabList;

	fgColor _forecolor = fgColor.White;
	bgColor _backcolor = bgColor.Black;

	fgColor _selectedForecolor = fgColor.BrightYellow;
	bgColor _selectedBackcolor = bgColor.Black;
}

