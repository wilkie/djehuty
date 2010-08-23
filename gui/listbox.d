/*
 * listbox.d
 *
 * This module implements a simple listbox widget for gui applications.
 *
 */

module gui.listbox;

import djehuty;

import gui.window;
import gui.scrollbar;
import gui.label;

import graphics.canvas;
import graphics.font;
import graphics.brush;
import graphics.pen;
import graphics.gradient;
import graphics.path;

import data.list;

class ListBox : Window, Iterable!(string) {
private:
	// Scrollbar
	ScrollBar _scrollbar;

	// Actual List
	List!(string) _list;

	// For searching the list incrementally
	List!(string) _searchList;
	List!(size_t) _searchIndices;
	string _searchTerm;
	Label _searchLabel;

	// Colors
	Color _fg = Color.Blue;

	// Selected Colors
	Color _selbg = Color.White;
	Color _selfg = Color.Black;

	size_t _selIndex = size_t.max;

	bool _scrolled(Dispatcher dsp, uint signal) {
		if (signal == ScrollBar.Signal.Changed) {
			redraw();
		}
		return true;
	}

	void _setScrollBarValues() {
		if (_list.length() <= (this.height / 18)) {
			_scrollbar.max = 0;
		}
		else {
			_scrollbar.max = cast(long)(_list.length() - cast(size_t)(this.height / 18));
		}

		_scrollbar.largeChange = cast(long)(this.height / 18);
	}
	
	void _cancelSearch() {
		_searchLabel.visible = false;
		_searchTerm = null;
	}
	
	void _resetSearch() {
		_searchList = new List!(string)();
		_searchIndices = new List!(size_t)();
		_searchList.addList(_list);
		_searchIndices.addList(range(0, _searchList.length()));
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
		_scrollbar = new ScrollBar(this.width-15, 0, 15, this.height, Orientation.Vertical);
		attach(_scrollbar, &_scrolled);

		_searchLabel = new Label(0, this.height-20, this.width-_scrollbar.width, 20, "");
		_searchLabel.visible = false;
		_searchLabel.backcolor = Color.fromRGBA(1, 1, 1, 0.5);
		_searchLabel.forecolor = Color.Black;
		attach(_searchLabel);
	}

	// Events

	override void onDraw(Canvas canvas) {
		canvas.brush = new Brush(this.backcolor);
		canvas.fillRectangle(0, 0, this.width-_scrollbar.width, this.height);

		canvas.font = new Font(FontSans, 16, 800, false, false, false);

		canvas.antialias = true;
		canvas.brush = new Brush(this.forecolor);
		for(int i = 0; i < this.height; i++) {
			size_t pos = cast(size_t)_scrollbar.value + i;
			if (pos < _list.length()) {
				string item = _list.peekAt(pos);

				if (pos == _selIndex) {
					canvas.brush = new Brush(this.selectedBackcolor);
					canvas.fillRectangle(0, i * 18, this.width-_scrollbar.width, 18);
					canvas.brush = new Brush(this.selectedForecolor);
				}

				canvas.fillString(item, 0, i * 18);
				if (pos == _selIndex) {
					canvas.brush = new Brush(this.forecolor);
				}
			}
		}
	}

	/*override void onScrollY(ref Mouse mouse, int delta) {
		delta = -delta;

		// void out the current search
		_cancelSearch();

		// get the new selected index
		_scrollbar.value = _scrollbar.value + (cast(long)delta * 3);
	}
*/
	override void onMouseDown(Mouse mouse, uint button) {
		// cancel any search
		_cancelSearch();

		// the calculation is easy... the index of the first visible + the mouse y coordinate
		this.selected = cast(size_t)(_scrollbar.value + (mouse.y / 18));
	}

	override void onKeyDown(Key key) {
		if (key.code == Key.Up || key.code == Key.PageUp) {
			// must have a selection...
			if (this.selected == size_t.max) {
				return;
			}

			// get the new selected index
			long newIndex = this.selected;
			if (key.code == Key.Up) {
				newIndex--;
			}
			else {
				newIndex -= _scrollbar.largeChange;
			}

			// bounds check
			if (newIndex < 0) {
				newIndex = 0;
			}

			// set (and then account for the scroll bar so that it is actually visible)
			this.selected = cast(size_t)newIndex;
			if (this.selected < _scrollbar.value || this.selected >= _scrollbar.value + this.height) {
				_scrollbar.value = this.selected;
			}
		}
		else if (key.code == Key.Down || key.code == Key.PageDown) {
			// must have a selection...
			if (this.selected == size_t.max) {
				return;
			}

			// get the new selected index
			long newIndex = this.selected;
			if (key.code == Key.Down) {
				newIndex++;
			}
			else {
				newIndex += _scrollbar.largeChange;
			}

			// bounds check
			if (newIndex > _list.length() - 1) {
				newIndex = _list.length() - 1;
			}

			// set (and then account for the scroll bar so that it is actually visible)
			this.selected = cast(size_t)newIndex;
			if (this.selected < _scrollbar.value || this.selected >= _scrollbar.value + this.height) {
				_scrollbar.value = cast(long)this.selected - cast(long)this.height + 1;
			}
		}

		if (key.code == Key.Backspace) {
			if (_searchTerm.length <= 1) {
				_cancelSearch();
			}
			else {
				_searchTerm = _searchTerm.substring(0, _searchTerm.length-1);
				_searchLabel.text = "/" ~ _searchTerm;
				_resetSearch(); // Have to include some items we dropped...
			}
		}
		else if ((!key.printable && key.code != Key.LeftShift && key.code != Key.RightShift) || key.code == Key.Return) {
			// cancel any search
			_cancelSearch();
		}
	}

	override void onKeyChar(dchar chr) {
		if (chr == '\r' || chr == '\n') {
			_cancelSearch();
			return;
		}

		// Search for the term in the list when entered
		if (_searchTerm is null) {
			// Reset to include all items in the search
			_resetSearch();
			_searchLabel.text = "/";
			_searchLabel.visible = true;
		}

		_searchTerm ~= chr;
		_searchLabel.text = "/" ~ _searchTerm;

		for(size_t i = 0; i < _searchList.length(); i++) {
			string element = _searchList.peekAt(i);
			if (element.beginsWith(_searchTerm)) {
				// oh good...
				this.selected = _searchIndices.peekAt(i);
				if (this.selected < _scrollbar.value || this.selected >= _scrollbar.value + this.height - 1) {
					_scrollbar.value = cast(long)this.selected - ((cast(long)this.height)/2) + 1;
				}
				break;
			}
			else {
				// remove this item
				_searchList.removeAt(i);
				_searchIndices.removeAt(i);
				i--;
			}
		}
	}

	// Methods (Iterable)

	void add(string item) {
		_list.add(item);
		_setScrollBarValues();
		redraw();
	}

	void addAt(string item, size_t idx) {
		_list.addAt(item, idx);
		_setScrollBarValues();
		redraw();
	}

	override string remove() {
		string ret = _list.remove();
		_setScrollBarValues();
		redraw();
		return ret;
	}

	override string removeAt(size_t idx) {
		string ret = _list.removeAt(idx);
		_setScrollBarValues();
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
		_setScrollBarValues();
		this.selected = int.max;
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
		auto ret = _list.opApplyReverse(loopFunc);
		_setScrollBarValues();
		redraw();
		return ret;
	}

	override int opApplyReverse(int delegate(ref size_t, ref string) loopFunc) {
		auto ret = _list.opApplyReverse(loopFunc);
		_setScrollBarValues();
		redraw();
		return ret;
	}

	override Iterable!(string) opCat(string[] list) {
		auto ret = _list.opCat(list);
		_setScrollBarValues();
		redraw();
		return ret;
	}

	override Iterable!(string) opCat(Iterable!(string) list) {
		auto ret = _list.opCat(list);
		_setScrollBarValues();
		redraw();
		return ret;
	}

	override Iterable!(string) opCat(string item) {
		auto ret = _list.opCat(item);
		_setScrollBarValues();
		redraw();
		return ret;
	}

	override void opCatAssign(string[] list) {
		_list.opCatAssign(list);
		_setScrollBarValues();
		redraw();
	}

	override void opCatAssign(Iterable!(string) list) {
		_list.opCatAssign(list);
		_setScrollBarValues();
		redraw();
	}

	override void opCatAssign(string item) {
		_list.opCatAssign(item);
		_setScrollBarValues();
		redraw();
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
		raiseSignal(ListBox.Signal.Changed);

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