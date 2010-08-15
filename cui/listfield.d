/*
 * listfield.d
 *
 * This module implements a CUI widget that provides a drop-down list.
 *
 */

module cui.listfield;

import cui.window;
import cui.canvas;
import cui.listbox;
import cui.button;
import cui.label;

import data.iterable;

import djehuty;

private class _CuiListFieldBox : CuiListBox {
	this(int x, int y, int width, int height) {
		super(x, y, width, height);
	}

	override void onLostFocus() {
		this.parent.detach(this);
	}
}

class CuiListField : CuiWindow, Iterable!(string) {
private:

	_CuiListFieldBox _list;
	CuiButton _button;
	CuiLabel _label;

	bool listHandler(Dispatcher dsp, uint signal) {
		if (signal == CuiListBox.Signal.Changed) {
			this.parent.detach(_list);
			_label.text = _list.peekAt(_list.selected);
			raiseSignal(CuiListField.Signal.Changed);
		}
		return true;
	}

	// This will be called when the button signals an action.
	bool buttonHandler(Dispatcher dsp, uint signal) {
		if (signal == CuiButton.Signal.Pressed) {
			if (this.parent !is null) {
				this.parent.attach(_list, &listHandler);
			}
		}
		return true;
	}

public:

	enum Signal {
		Changed
	}

	// Description: This constructor will create a new listfield.
	this(int x, int y, int width) {
		super(x, y, width, 1);

		_list = new _CuiListFieldBox(x+1, y+1, width-1, 10);
		_button = new CuiButton(width-1, 0, 1, 1, "\u2193");
		_label = new CuiLabel(0, 0, width-1, "hello");
		
		_button.forecolor = Color.Gray;
		_button.backcolor = Color.Blue;

		attach(_button, &buttonHandler);
		attach(_label);
	}

	// Methods (Iterable)

	void add(string item) {
		_list.add(item);
	}

	void addAt(string item, size_t idx) {
		_list.addAt(item, idx);
	}

	override string remove() {
		return _list.remove();
	}

	override string removeAt(size_t idx) {
		return _list.removeAt(idx);
	}

	override string peek() {
		return _list.peek();
	}

	override string peekAt(size_t idx) {
		return _list.peekAt(idx);
	}

	void set(string value) {
		_list.set(value);
	}

	void setAt(size_t idx, string value) {
		_list.setAt(idx, value);
	}

	void apply(string delegate(string) func) {
		_list.apply(func);
	}

	bool contains(string value) {
		return _list.contains(value);
	}

	override bool empty() {
		return _list.empty();
	}

	override void clear() {
		_list.clear();
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
}