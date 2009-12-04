module gui.listbox;

import gui.widget;

import core.color;
import core.definitions;
import core.string;
import core.list;

import graphics.graphics;

import gui.vscrollbar;

template ControlPrintCSTRList() {
	const char[] ControlPrintCSTRList = `
	this(int x, int y, int width, int height, List!(String) list = null) {
		super(x,y,width,height,list);
	}
	`;
}

// Description: This control provides a standard list selection box.
class ListBox : Widget {

	enum Signal : uint {
		Selected,
		Unselected
	}

	this(int x, int y, int width, int height, List!(String) list = null) {
		super(x,y,width,height);

		_list = new List!(String)();
		if (list !is null) {
			foreach(item; list) {
				_list.add(item);
			}
		}
	}

	// handle events
	override void onAdd() {
		if (control_scroll is null) {
			control_scroll = new VScrollBar(this.right - 17,this.top, 17, this.height);
		}

		_font = new Font(FontSans, 8, 400, false, false, false);

		Graphics grp = _view.lockDisplay();
		grp.font = _font;
		grp.measureText(" ", 1, m_entryHeight);
		_view.unlockDisplay();

		m_clroutline = Color.fromRGB(0x80, 0x80, 0x80);
		m_clrhighlight = Color.fromRGB(0xdd,0xdd,0xdd);
		m_clrhighlighttext = Color.White;
		m_clrnormal = Color.Black;
		m_clrbackground = Color.White;

		m_first_visible = 0;
		m_total_visible = 0;

		//normal state
		m_hoverstate = 0;

		m_total_visible = ((this.height+2) / m_entryHeight.y) + 1;

		_window.push(control_scroll);

		//control_scroll.SetScrollPeriods(1, m_total_visible-2);
		//control_scroll.SetRange(0, _list.length() - m_total_visible+1);

		control_scroll.enabled = false;
	}

	override void onRemove() {
		control_scroll.detach();
	}

	override void onDraw(ref Graphics g) {
		//draw all entries

		uint i;

		Rect rt;

		Brush brsh;
		Pen pen;

		brsh = new Brush(m_clrbackground);
		pen = new Pen(m_clroutline);

		g.pen = pen;
		g.brush = brsh;

		g.drawRect(this.left, this.top, this.width, this.height);

		rt.left = this.left+1;
		rt.top = this.top+1;
		rt.right = this.right - control_scroll.width;
		rt.bottom = rt.top + m_entryHeight.y;

		// set text mode to transparent
		g.setTextModeTransparent();

		g.backcolor = m_clrhighlight;
		g.forecolor = m_clrnormal;

		g.font = _font;

		String data;

		for (i=m_first_visible; i<m_first_visible+m_total_visible && i<_list.length(); i++) {
			data = _list.peekAt(i);

			if (i==m_sel_start) {
				// set text mode to opaque (selection!)
				g.setTextModeOpaque();
				g.forecolor(m_clrhighlighttext);

				g.drawText(rt.left, rt.top, data);

				g.forecolor(m_clrnormal);
				g.setTextModeTransparent();
			}
			else {
				g.drawText(rt.left, rt.top, data);
			}

			rt.top = rt.bottom;

			if (rt.bottom == this.bottom-1) { break; }

			rt.bottom += m_entryHeight.y;

			if (rt.bottom >= this.bottom) { rt.bottom = this.bottom-1; }
		}
	}

	override bool onPrimaryMouseDown(ref Mouse mouseProps) {
		uint curEntry = (mouseProps.y - this.top);
		curEntry -= 1; //remove top margin

		curEntry /= m_entryHeight.y;

		curEntry += m_first_visible;

		if (curEntry < _list.length()) {
			//mark this as selected
			if (m_sel_start != curEntry) {
				m_sel_start = curEntry;

				raiseSignal(Signal.Selected);

				return true;
			}

			raiseSignal(Signal.Selected);
		}
		else {
			if (m_sel_start != -1) {
				m_sel_start = -1;
				return true;
			}
		}

		return false;
	}

	uint selectionStart() {
		return m_sel_start;
	}

	// List Methods

	void add(String c) {
		_list.add(c);

		_checkScrollBarStatus();
	}

	void add(string c) {
		_list.add(new String(c));

		_checkScrollBarStatus();
	}

	void add(String[] c) {
		foreach(item; c) {
			_list.add(item);
		}
	}

	void add(string[] c) {
		foreach(item; c) {
			_list.add(new String(item));
		}
	}

	void add(ListInterface!(String) list) {
		foreach(item; list) {
			_list.add(item);
		}
	}

	void addAt(String c, size_t idx) {
		_list.addAt(c, idx);

		_checkScrollBarStatus();
	}

	String remove() {
		String ret = _list.remove();

		_checkScrollBarStatus();

		return ret;
	}

	String removeAt(size_t idx){
		String ret = _list.removeAt(idx);

		_checkScrollBarStatus();

		return ret;
	}

	String peek() {
		return _list.peek();
	}

	String peekAt(size_t idx) {
		return _list.peekAt(idx);
	}

	void set(String c) {
		_list.set(c);
	}

	void apply(String delegate(String) func) {
		_list.apply(func);
	}

	bool contains(String c) {
		return _list.contains(c);
	}

	bool empty() {
		return _list.empty();
	}

	void clear() {
		_list.clear();

		_checkScrollBarStatus();
	}

	String[] array() {
		return _list.array();
	}

	List!(String) dup() {
		return _list.dup();
	}

	List!(String) slice(size_t start, size_t end) {
		return _list.slice(start, end);
	}

	List!(String) reverse() {
		return _list.reverse();
	}

	size_t length() {
		return _list.length();
	}

	String opIndex(size_t i1) {
		return _list.opIndex(i1);
	}

	int opApply(int delegate(ref String) loopFunc) {
		return _list.opApply(loopFunc);
	}

	int opApply(int delegate(ref size_t, ref String) loopFunc) {
		return _list.opApply(loopFunc);
	}

protected:

	Font _font;

	Size m_entryHeight;

	Color m_clrnormal;
	Color m_clrhighlight;
	Color m_clrhighlighttext;
	Color m_clrbackground;
	Color m_clroutline;

	uint m_first_visible;
	uint m_total_visible;
	uint m_sel_start;

	List!(String) _list;

	int m_hoverstate;

	VScrollBar control_scroll;

	void _checkScrollBarStatus() {
		//make sure list refits the list when it gets taller
		if (m_first_visible > _list.length() - m_total_visible + 2) {
			m_first_visible = _list.length() - m_total_visible + 2;

			//control_scroll.SetValue(m_first_visible);
		}

		//whether or not the scroll bar is in use
		if (_list.length() - m_total_visible >= 0 && _list.length() - m_total_visible < _list.length()) {
			//scroll bars should be enabled
			control_scroll.enabled = true;

			//control_scroll.SetRange(0, _list.length() - m_total_visible + 1);
		}
		else {
			control_scroll.enabled = false;
		}
	}
}
