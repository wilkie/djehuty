/*
 * listbox.d
 *
 * This module implements a simple listbox widget for CUI applications.
 *
 */

module cui.listbox;

import djehuty;

import cui.window;
import cui.scrollbar;
import cui.canvas;

import data.list;

class CuiListBox : CuiWindow, Iterable!(string) {
private:
	// Scrollbar
	CuiScrollBar _scrollbar;

	// Actual List
	List!(string) _list;

	// Colors
	Color _bg = Color.Black;
	Color _fg = Color.Blue;

	// Selected Colors
	Color _selbg = Color.White;
	Color _selfg = Color.Black;

	size_t _selIndex = size_t.max;
	size_t _firstVisible;

	bool _scrolled(Dispatcher dsp, uint signal) {
		if (signal == CuiScrollBar.Signal.Changed) {
			_firstVisible = cast(size_t)_scrollbar.value;
			redraw();
		}
		return true;
	}

public:

	enum Signal {
		Changed
	}

	// Description: This constructor will create a new listbox widget of the
	//  specified dimensions at the specified location.
	this(int x, int y, int width, int height) {
		super(x,y,width,height);

		// Create a new list
		_list = new List!(string);

		// Create the vertical scroll bar for the list
		_scrollbar = new CuiScrollBar(width-1, 0, 1, height, Orientation.Vertical);
		push(_scrollbar, &_scrolled);
	}

	// Events

	override void onDraw(CuiCanvas canvas) {
		canvas.forecolor = _fg;
		canvas.backcolor = _bg;

		for(int i = 0; i < this.height; i++) {
			canvas.position(0, i);

			size_t pos = _firstVisible + i;
			if (pos < _list.length()) {
				string item = _list.peekAt(pos);
				if (item.length < this.width-1) {
					item ~= times(" ", (this.width-1) - item.length);
				}
				if (pos == _selIndex) {
					canvas.forecolor = _selfg;
					canvas.backcolor = _selbg;
				}
				canvas.write(item);
				if (pos == _selIndex) {
					canvas.forecolor = _fg;
					canvas.backcolor = _bg;
				}
			}
			else {
				canvas.write(times(" ", this.width-1));
			}
		}
	}

	override void onPrimaryDown(ref Mouse mouse) {
		size_t newSelection = _firstVisible + cast(int)mouse.y;

		this.selected = newSelection;
	}

	// Methods (Iterable)

	void add(string item) {
		_list.add(item);
		redraw();
	}

	void addAt(string item, size_t idx) {
		_list.addAt(item, idx);
		redraw();
	}

	override string remove() {
		string ret = _list.remove();
		redraw();
		return ret;
	}

	override string removeAt(size_t idx) {
		string ret = _list.removeAt(idx);
		redraw();
		return ret;
	}

	override string peek() {
		return _list.peek();
	}

	override string peekAt(size_t idx) {
		return _list.peekAt(idx);
	}

	void set(string value) {
		_list.set(value);
		redraw();
	}

	void setAt(size_t idx, string value) {
		_list.setAt(idx, value);
		redraw();
	}

	void apply(string delegate(string) func) {
		_list.apply(func);
		redraw();
	}

	bool contains(string value) {
		return _list.contains(value);
	}

	override bool empty() {
		return _list.empty();
	}

	override void clear() {
		_list.clear();
		redraw();
	}

	override string[] array() {
		return _list.array();
	}

	override Iterable!(string) dup() {
		return _list.dup();
	}

	override Iterable!(string) slice(size_t start, size_t end) {
		return _list.slice(start, end);
	}

	override size_t length() {
		return _list.length();
	}

	override string opIndex(size_t i1) {
		return _list.opIndex(i1);
	}

	size_t opIndexAssign(string value, size_t i1) {
		return _list.opIndexAssign(value, i1);
	}

	override int opApply(int delegate(ref string) loopFunc) {
		return _list.opApply(loopFunc);
	}

	override int opApply(int delegate(ref size_t, ref string) loopFunc) {
		return _list.opApply(loopFunc);
	}

	override int opApplyReverse(int delegate(ref string) loopFunc) {
		return _list.opApplyReverse(loopFunc);
	}

	override int opApplyReverse(int delegate(ref size_t, ref string) loopFunc) {
		return _list.opApplyReverse(loopFunc);
	}

	override Iterable!(string) opCat(string[] list) {
		return _list.opCat(list);
	}

	override Iterable!(string) opCat(Iterable!(string) list) {
		return _list.opCat(list);
	}

	override Iterable!(string) opCat(string item) {
		return _list.opCat(item);
	}

	override void opCatAssign(string[] list) {
		_list.opCatAssign(list);
	}

	override void opCatAssign(Iterable!(string) list) {
		_list.opCatAssign(list);
	}

	override void opCatAssign(string item) {
		_list.opCatAssign(item);
	}

	// Properties

	// Description: This function will get the index of the item that is currently selected.
	// Returns: A valid index into the list of the item that is selected and size_t.max if nothing is selected.
	size_t selected() {
		return _selIndex;
	}
	
	// Description: This function will set the index of the item that is currently selected.
	// index: The index of the item that is to be selected. An invalid index will select nothing.
	void selected(size_t index) {
		// For invalid indices, just unselect
		if (index >= _list.length()) {
			index = size_t.max;
		}

		// Set the selected index to that of the index given
		_selIndex = index;

		// Fire a signal
		raiseSignal(CuiListBox.Signal.Changed);

		// Refresh the display
		redraw();
	}

	// Description: This function will get the foreground color for the list.
	// Returns: The current foreground color.
	Color forecolor() {
		return _fg;
	}

	// Description: This function will set the foreground color for the list.
	// value: The new color to set to be the foreground color.
	void forecolor(Color value) {
		_fg = value;
		redraw();
	}

	// Description: This function will get the background color for the list.
	// Returns: The current background color.
	Color backcolor() {
		return _bg;
	}

	// Description: This function will set the background color for the list.
	// value: The new color to set to be the background color.
	void backcolor(Color value) {
		_bg = value;
		redraw();
	}

	// Description: This function will get the foreground color for the selected items of the list.
	// Returns: The current foreground color.
	Color selectedForecolor() {
		return _selfg;
	}

	// Description: This function will set the foreground color for the selected items of the list.
	// value: The new color to set to be the foreground color.
	void selectedForecolor(Color value) {
		_selfg = value;
		redraw();
	}

	// Description: This function will get the background color for the selected items of the list.
	// Returns: The current background color.
	Color selectedBackcolor() {
		return _selbg;
	}

	// Description: This function will set the background color for the selected items of the list.
	// value: The new color to set to be the background color.
	void selectedBackcolor(Color value) {
		_selbg = value;
		redraw();
	}
}