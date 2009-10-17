/*
 * tabs.d
 *
 * This module implements tabs of windows for TUI apps.
 *
 * Author: Lindsey Bieda
 * Originated: October 14th 2009
 *
 */

module tui.tabbox;

import tui.widget;
import tui.container;

import core.string;
import core.definitions;
import core.list;

import io.console;

// Tabs should loop through TuiContainers that are sized to the size of the tab widget

// Some hints:
// onDraw() { current_container.onDraw(); }
// onKeyDown(Key foo) { current_container.onKeyDown(foo); }
// etc. for all events

// Redraw container when the tab is switched

// Pass resize events down to current container and ALL containers 
//   (eventually.. like check the size when containers are switched to reduce overhead)

class TuiTabBox : TuiWidget, ListInterface!(TuiContainer) {
	this(uint x, uint y, uint width, uint height) {
		super(x,y,width,height);
		_tabList = new List!(TuiContainer);
	}

	override void onAdd() {
	}

	override void onDraw() {
		//draw the tabs

	}
	
	void add(TuiContainer c) {
		_tabList.add(c);
	}
	
	TuiContainer remove() {
		return _tabList.remove();
	}
	
	TuiContainer removeAt(size_t idx){
		return _tabList.removeAt(idx);
	}
	
	TuiContainer peek() {
		return _tabList.peek();
	}
	
	TuiContainer peekAt(size_t idx) {
		return _tabList.peekAt(idx);
	}
	
	void set(TuiContainer c) {
		_tabList.set(c);
	}
	
	void apply(TuiContainer delegate(TuiContainer) func) {
		_tabList.apply(func);
	}
	
	bool contains(TuiContainer c) {
		return _tabList.contains(c);
	}
	
	bool empty() {
		return _tabList.empty();
	}
	
	void clear() {
		_tabList.clear();
	}
	
	TuiContainer[] array() {
		return _tabList.array();
	}
	
	List!(TuiContainer) dup() {
		return _tabList.dup();
	}
	
	List!(TuiContainer) slice(size_t start, size_t end) {
		return _tabList.slice(start, end);
	}
	
	List!(TuiContainer) reverse(){
		return _tabList.reverse();
	}
	
	size_t length() {
		return _tabList.length();
	}
	
	TuiContainer opIndex(size_t i1) {
		return _tabList.opIndex(i1);
	}
	
	int opApply(int delegate(ref TuiContainer) loopFunc){
		return _tabList.opApply(loopFunc);
	}
	
	int opApply(int delegate(ref int, ref TuiContainer) loopFunc){
		return _tabList.opApply(loopFunc);
	}
	
	

protected:
	uint curTab = 0;

	List!(TuiContainer) _tabList;

	fgColor _forecolor = fgColor.White;
	bgColor _backcolor = bgColor.Black;

	fgColor _selectedForecolor = fgColor.BrightYellow;
	bgColor _selectedBackcolor = bgColor.Black;
}

