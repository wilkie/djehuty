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

class TuiTabBox : TuiContainer, ListInterface!(TuiContainer) {
	this(uint x, uint y, uint width, uint height) {
		super(x,y,width,height);
		_tabList = new List!(TuiContainer);
	}

	override void onAdd() {
	}

	override void onDraw() {
		//draw the tabs
		Console.setColor(_forecolor, _backcolor);
		
		foreach(int i, item; _tabList) {
			if(i == _curTab) {
				Console.setColor(_selectedForecolor, _selectedBackcolor);
				Console.put(item.text);
				Console.setColor(_forecolor, _backcolor);
			}
			else {
				Console.put(item.text);		
			}
			
			Console.put(" | ");
		}
		
		if(!_tabList.empty()) {
			_tabList[_curTab].onDraw();
		}
	}
	
	void onGotFocus() {
		if(!_tabList.empty()) {
			_tabList[_curTab].onGotFocus();
		}	
	}

	void onLostFocus() {
		if(!_tabList.empty()) {
			_tabList[_curTab].onLostFocus();
		}	
	}

	void onResize() {
		if(!_tabList.empty()) {
			_tabList[_curTab].resize(width, height-1);
		}
	}

	void onKeyDown(Key key) {
		if(!_tabList.empty()) {
			if(key.alt == true && key.code >= Key.Zero && key.code <= Key.Nine) {
				current(key.code - Key.Zero);
			}
			else {
				_tabList[_curTab].onKeyDown(key);
			}
		}	
	}

	void onKeyChar(dchar keyChar) {
		if(!_tabList.empty()) {
			_tabList[_curTab].onKeyChar(keyChar);
		}	
	}

	void onPrimaryMouseDown() {
		if(!_tabList.empty()) {
			_tabList[_curTab].onPrimaryMouseDown();
		}	
	}

	void onPrimaryMouseUp() {
		if(!_tabList.empty()) {
			_tabList[_curTab].onPrimaryMouseUp();
		}	
	}

	void onSecondaryMouseDown() {
		if(!_tabList.empty()) {
			_tabList[_curTab].onSecondaryMouseDown();
		}	
	}

	void onSecondaryMouseUp() {
		if(!_tabList.empty()) {
			_tabList[_curTab].onSecondaryMouseUp();
		}	
	}

	void onTertiaryMouseDown() {
		if(!_tabList.empty()) {
			_tabList[_curTab].onTertiaryMouseDown();
		}	
	}

	void onTertiaryMouseUp() {
		if(!_tabList.empty()) {
			_tabList[_curTab].onTertiaryMouseUp();
		}	
	}

	void onMouseWheelY(int amount) {
		if(!_tabList.empty()) {
			_tabList[_curTab].onMouseWheelY(amount);
		}	
	}

	void onMouseWheelX(int amount) {
		if(!_tabList.empty()) {
			_tabList[_curTab].onMouseWheelX(amount);
		}	
	}

	void onMouseMove() {
		if(!_tabList.empty()) {
			_tabList[_curTab].onMouseMove();
		}	
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
	
	List!(TuiContainer) reverse() {
		return _tabList.reverse();
	}
	
	size_t length() {
		return _tabList.length();
	}
	
	TuiContainer opIndex(size_t i1) {
		return _tabList.opIndex(i1);
	}
	
	int opApply(int delegate(ref TuiContainer) loopFunc) {
		return _tabList.opApply(loopFunc);
	}
	
	int opApply(int delegate(ref int, ref TuiContainer) loopFunc) {
		return _tabList.opApply(loopFunc);
	}
	
	void next() {
		if(_curTab + 1 < _tabList.length()) {
			current(_curTab+1);
		}
		else {
			current(0);
		}
	}

	void prev() {
		if(_curTab == 0) {
			current(_tabList.length()-1);
		}
		else {
			current(_curTab-1);
		}
	}
	
// properties
	
	size_t current() {
		return _curTab;
	}
	
	void current(size_t cur) {
		if(cur < _tabList.length()) {
			_curTab = cur;
		}
		
		if(!_tabList.empty() && (_tabList[_curTab].width != this.width || _tabList[_curTab].height != (this.height-1))) {
			_tabList[_curTab].resize(width, height-1);
		}
		
		onDraw();
	}	

protected:
	size_t _curTab = 0;

	List!(TuiContainer) _tabList;

	fgColor _forecolor = fgColor.White;
	bgColor _backcolor = bgColor.Black;

	fgColor _selectedForecolor = fgColor.BrightYellow;
	bgColor _selectedBackcolor = bgColor.Black;
}

