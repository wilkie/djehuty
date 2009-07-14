/*
 * listfield.d
 *
 * This module implements a GUI drop-down list widget.
 *
 * Author: Dave Wilkinson
 *
 */

module gui.listfield;

import core.color;
import core.definitions;
import core.string;
import core.graphics;

import utils.arraylist;

import gui.widget;
import gui.window;
import gui.button;
import gui.listbox;

import interfaces.list;

template ControlPrintCSTRList() {
	const char[] ControlPrintCSTRList = `
	this(int x, int y, int width, int height, AbstractList!(String) list = null) {
		super(x,y,width,height,list);
	}
	`;
}

class ListFieldWindow : Window {
	this(uint width) {
		super("ListFieldPopup", WindowStyle.Popup, SystemColor.Window, 0,0,width,width / 2);
	}

	override void onLostFocus() {
		remove();
	}
}

// Section: Controls

// Description: This control provides a standard dropdown list selection box.
class ListField : Widget, AbstractList!(String) {

	enum Signal : uint {
		Selected,
		Unselected
	}

	this(int x, int y, int width, int height, AbstractList!(String) list = null) {
		super(x,y,width,height);

		_list = new ArrayList!(String)();
		if (list !is null) { _list.addList(list); }
	}

	// handle events
	override void onAdd() {
		if (control_button is null) {
			control_button = new Button(this.right - this.height,this.top, this.height, this.height, "V");
			control_listbox = new ListBox(0,0, this.width,this.width / 2);
			control_window = new ListFieldWindow(this.width);

			if (_list !is null) {
				control_listbox.addList(_list);
			}
			_list = null;
		}

		Graphics grp = _view.lockDisplay();
		_font = new Font(FontSans, 8, 400, false, false, false);
		grp.setFont(_font);
		grp.measureText(" ", 1, m_entryHeight);
		_view.unlockDisplay();

		m_clroutline.setRGB(0x80, 0x80, 0x80);
		m_clrhighlight.setRGB(0xdd,0xdd,0xdd);
		m_clrhighlighttext.setRGB(0xff,0xff,0xff);
		m_clrnormal.setRGB(0,0,0);
		m_clrbackground.setRGB(0xff,0xff,0xff);

		m_first_visible = 0;
		m_total_visible = 0;

		//normal state
		m_hoverstate = 0;

		//control_scroll.Bound(17, this.height);
		//control_scroll.Move(this.left+(this.width-17), this.top);

		m_total_visible = ((this.height+2) / m_entryHeight.y) + 1;

		// Add the Child Button, which will spawn the window and the list
		_window.push(control_button);

		control_button.enabled = false;
	}

	override void onRemove() {
		//control_button.remove();
	}

	override void onDraw(ref Graphics g) {
	//draw all entries

		ulong i;

		Rect rt;

		Brush brsh = new Brush(m_clrbackground);
		Pen pen = new Pen(m_clroutline);

		g.setPen(pen);
		g.setBrush(brsh);

		g.drawRect(this.left, this.top, this.right, this.bottom);

		rt.left = this.left+1;
		rt.top = this.top+1;
		rt.right = this.right - control_button.width;
		rt.bottom = rt.top + m_entryHeight.y;
	}

	// List Methods

	void addItem(String data) {
		control_listbox.addItem(data);
	}

	void addItem(string data) {
		control_listbox.addItem(data);
	}

	void addList(AbstractList!(String) list) {
		control_listbox.addList(list);
	}

	void addList(String[] list) {
		control_listbox.addList(list);
	}

    bool getItem(out String data, uint index) {
		return control_listbox.getItem(data, index);
    }

	Iterator getIterator() {
		return control_listbox.getIterator();
	}

    bool getItem(out String data, ref Iterator irate) {
		return control_listbox.getItem(data, irate);
    }

    uint length() {
		return control_listbox.length();
    }

	bool remove(out String item) {
		return control_listbox.remove(item);
	}

protected:

	Font _font;

	Size m_entryHeight;

	ulong m_first_visible;
	ulong m_total_visible;
	ulong m_sel_start;

	Color m_clrnormal;
	Color m_clrhighlight;
	Color m_clrhighlighttext;
	Color m_clrbackground;
	Color m_clroutline;

	int m_hoverstate;

	Button control_button;
	ListBox control_listbox;
	Window control_window;

	ArrayList!(String) _list;
}
