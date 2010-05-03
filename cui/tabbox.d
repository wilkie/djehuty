/*
 * tabs.d
 *
 * This module implements tabs of windows for TUI apps.
 *
 * Author: Lindsey Bieda
 * Originated: October 14th 2009
 *
 */

module cui.tabbox;

import djehuty;

import data.list;

import cui.container;

import io.console;

// Tabs should loop through CuiContainers that are sized to the size of the tab widget

// Some hints:
// onDraw() { current_container.onDraw(); }
// onKeyDown(Key foo) { current_container.onKeyDown(foo); }
// etc. for all events

// Redraw container when the tab is switched

// Pass resize events down to current container and ALL containers 
//   (eventually.. like check the size when containers are switched to reduce overhead)

class CuiTabBox : CuiContainer, Iterable!(CuiContainer) {
	this(uint x, uint y, uint width, uint height) {
		super(x,y,width,height);
		_tabList = new List!(CuiContainer);
	}

	override void onAdd() {
		_old_base_y = _base_y;
		_base_y++;
	}

	override void onDraw() {
		io.console.Console.hideCaret();
		//draw the tabs
		io.console.Console.clipSave();
		io.console.Console.position(_base_x + this.left, _base_y + this.top - 1);
		io.console.Console.setColor(_forecolor, _backcolor);

		io.console.Console.put(" ");		
		foreach(i, item; _tabList) {
			if(i == _curTab) {
				io.console.Console.setColor(_selectedForecolor, _selectedBackcolor);
				io.console.Console.put(item.text);
				io.console.Console.setColor(_forecolor, _backcolor);
			}
			else {
				io.console.Console.put(item.text);
			}

			io.console.Console.put(" | ");
		}

		if(!_tabList.empty()) {
			CuiContainer c = _tabList[_curTab];

			io.console.Console.clipSave();
			this.widgetClippingContext = c;
			c.onDraw();
			io.console.Console.clipRestore();
			io.console.Console.clipRect(_base_x + this.left + c.left, _base_y + this.top + c.top, _base_x + this.left + c.left + c.width, _base_y + this.top + c.top + c.height);
		}
		io.console.Console.clipRestore();
	}
	
	override void onGotFocus() {
		if(!_tabList.empty()) {
			_tabList[_curTab].onGotFocus();
		}	
	}

	override void onLostFocus() {
		if(!_tabList.empty()) {
			_tabList[_curTab].onLostFocus();
		}	
	}

	override void onResize() {
		if(!_tabList.empty()) {
			_tabList[_curTab].resize(width, height-1);
		}
	}

	override void onKeyDown(Key key) {
		if(!_tabList.empty()) {
			if(key.alt == true && key.code >= Key.Zero && key.code <= Key.Nine) {
				if (key.code == Key.Zero) {
					current(10);
				}
				else {
					current(key.code - Key.One);
				}
			}
			else {
				_tabList[_curTab].onKeyDown(key);
			}
		}	
	}

	override void onKeyChar(dchar keyChar) {
		if(!_tabList.empty()) {
			_tabList[_curTab].onKeyChar(keyChar);
		}	
	}

	override void onPrimaryMouseDown() {
		if(!_tabList.empty()) {
			_tabList[_curTab].onPrimaryMouseDown();
		}	
	}

	override void onPrimaryMouseUp() {
		if(!_tabList.empty()) {
			_tabList[_curTab].onPrimaryMouseUp();
		}	
	}

	override void onSecondaryMouseDown() {
		if(!_tabList.empty()) {
			_tabList[_curTab].onSecondaryMouseDown();
		}	
	}

	override void onSecondaryMouseUp() {
		if(!_tabList.empty()) {
			_tabList[_curTab].onSecondaryMouseUp();
		}	
	}

	override void onTertiaryMouseDown() {
		if(!_tabList.empty()) {
			_tabList[_curTab].onTertiaryMouseDown();
		}	
	}

	override void onTertiaryMouseUp() {
		if(!_tabList.empty()) {
			_tabList[_curTab].onTertiaryMouseUp();
		}	
	}

	override void onMouseWheelY(int amount) {
		if(!_tabList.empty()) {
			_tabList[_curTab].onMouseWheelY(amount);
		}	
	}

	override void onMouseWheelX(int amount) {
		if(!_tabList.empty()) {
			_tabList[_curTab].onMouseWheelX(amount);
		}	
	}

	override void onMouseMove() {
		if(!_tabList.empty()) {
			_tabList[_curTab].onMouseMove();
		}	
	}
	
	override void push(Dispatcher dsp) {
		if (cast(CuiContainer)dsp) {
			CuiContainer c = cast(CuiContainer)dsp;
			c.resize(width, height-1);
			c.move(0,0);
			_tabList.add(c);
		}
		super.push(dsp);
	}
	
	void add(CuiContainer c) {
		push(c);
	}
	
	CuiContainer remove() {
		return _tabList.remove();
	}
	
	CuiContainer removeAt(size_t idx){
		return _tabList.removeAt(idx);
	}
	
	CuiContainer peek() {
		return _tabList.peek();
	}
	
	CuiContainer peekAt(size_t idx) {
		return _tabList.peekAt(idx);
	}
	
	void set(CuiContainer c) {
		_tabList.set(c);
	}
	
	void apply(CuiContainer delegate(CuiContainer) func) {
		_tabList.apply(func);
	}
	
	bool contains(CuiContainer c) {
		return _tabList.contains(c);
	}
	
	bool empty() {
		return _tabList.empty();
	}
	
	void clear() {
		_tabList.clear();
	}
	
	CuiContainer[] array() {
		return _tabList.array();
	}
	
	List!(CuiContainer) dup() {
		return _tabList.dup();
	}
	
	List!(CuiContainer) slice(size_t start, size_t end) {
		return _tabList.slice(start, end);
	}
	
	List!(CuiContainer) reverse() {
		return _tabList.reverse();
	}
	
	size_t length() {
		return _tabList.length();
	}
	
	CuiContainer opIndex(size_t i1) {
		return _tabList.opIndex(i1);
	}
	
	int opApply(int delegate(ref CuiContainer) loopFunc) {
		return _tabList.opApply(loopFunc);
	}
	
	int opApply(int delegate(ref size_t, ref CuiContainer) loopFunc) {
		return _tabList.opApply(loopFunc);
	}

	int opApplyReverse(int delegate(ref CuiContainer) loopFunc) {
		return _tabList.opApplyReverse(loopFunc);
	}

	int opApplyReverse(int delegate(ref size_t, ref CuiContainer) loopFunc) {
		return _tabList.opApplyReverse(loopFunc);
	}

	void opCatAssign(CuiContainer[] list) {
		_tabList.opCatAssign(list);
	}

	void opCatAssign(Iterable!(CuiContainer) list) {
		_tabList.opCatAssign(list);
	}

	void opCatAssign(CuiContainer item) {
		_tabList.opCatAssign(item);
	}

	Iterable!(CuiContainer) opCat(CuiContainer[] list) {
		return _tabList.opCat(list);
	}

	Iterable!(CuiContainer) opCat(Iterable!(CuiContainer) list) {
		return _tabList.opCat(list);
	}

	Iterable!(CuiContainer) opCat(CuiContainer item) {
		return _tabList.opCat(item);
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

protected:

	override void _reportMove(uint x, uint y) {
		_base_y++;
		super._reportMove(x,y);
	}
	
	uint _old_base_y;
	size_t _curTab = 0;

	List!(CuiContainer) _tabList;

	fgColor _forecolor = fgColor.White;
	bgColor _backcolor = bgColor.Black;

	fgColor _selectedForecolor = fgColor.BrightYellow;
	bgColor _selectedBackcolor = bgColor.Black;
}

