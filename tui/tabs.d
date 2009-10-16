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

class TuiTabs : TuiWidget, ListInterface!(TuiContainer) {
	this(uint x, uint y, uint width, uint height) {
		super(x,y,width,height);
		_tabList = new List!(_tabItem);
	}

	override void onAdd() {
	}

	override void onDraw() {
		//draw the tabs

	}
	
	void add(TuiContainer c) {
		
	}
	
	TuiContainer remove() {
		
	}
	
	TuiContainer removeAt(size_t idx){
		
	}
	
	TuiContainer peek() {
		
	}
	
	TuiContainer peekAt(size_t idx) {
		
	}
	
	void set(TuiContainer c) {
		
	}
	
	void apply(TuiContainer delegate(TuiContainer) func) {
		
	}
	
	bool contains(TuiContainer c) {
		
	}
	
	bool empty() {
		
	}
	
	void clear() {
		
	}
	
	TuiContainer[] array() {
		
	}
	
	List!(TuiContainer) dup() {
		
	}
	
	List!(TuiContainer) slice(size_t start, size_t end) {
		
	}
	
	List!(TuiContainer) reverse(){
		
	}
	
	size_t length() {
		
	}
	
	TuiContainer opIndex(size_t i1) {
		
	}
	
	int opApply(int delegate(ref TuiContainer) loopFunc){
		
	}
	
	int opApply(int delegate(ref int, ref TuiContainer) loopFunc){
		
	}
	
	

protected:
	uint curTab = 0;

	List!(TuiContainer) _tabList;

	fgColor _forecolor = fgColor.White;
	bgColor _backcolor = bgColor.Black;

	fgColor _selectedForecolor = fgColor.BrightYellow;
	bgColor _selectedBackcolor = bgColor.Black;
}

