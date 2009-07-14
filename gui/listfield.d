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

template ControlPrintCSTRList()
{
	const char[] ControlPrintCSTRList = `
	this(int x, int y, int width, int height, AbstractList!(String) list = null)
	{
		super(x,y,width,height,list);
	}
	`;
}

class ListFieldWindow : Window
{
	this(uint width)
	{
		super("ListFieldPopup", WindowStyle.Popup, SystemColor.Window, 0,0,width,width / 2);
	}

	override void onLostFocus()
	{
		remove();
	}
}

// Section: Controls

// Description: This control provides a standard dropdown list selection box.
class ListField : Widget, AbstractList!(String)
{

	enum Signal : uint
	{
		Selected,
		Unselected
	}

	this(int x, int y, int width, int height, AbstractList!(String) list = null)
	{
		super(x,y,width,height);

		_list = new ArrayList!(String)();
		if (list !is null) { _list.addList(list); }
	}

	// handle events
	override void onAdd()
	{
		if (control_button is null)
		{
			control_button = new Button(_r - _height,_y, _height, _height, "V");
			control_listbox = new ListBox(0,0, _width,_width / 2);
			control_window = new ListFieldWindow(_width);

			if (_list !is null)
			{
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

		//control_scroll.Bound(17, _height);
		//control_scroll.Move(_x+(_width-17), _y);

		m_total_visible = ((_height+2) / m_entryHeight.y) + 1;

		// Add the Child Button, which will spawn the window and the list
		_window.push(control_button);

		control_button.setEnabled(false);
	}

	override void onRemove()
	{
		//control_button.remove();
	}

	override void onDraw(ref Graphics g)
	{
	//draw all entries

		ulong i;

		Rect rt;

		Brush brsh = new Brush(m_clrbackground);
		Pen pen = new Pen(m_clroutline);

		g.setPen(pen);
		g.setBrush(brsh);

		g.drawRect(_x, _y, _r, _b);

		rt.left = _x+1;
		rt.top = _y+1;
		rt.right = _r - control_button.getWidth();
		rt.bottom = rt.top + m_entryHeight.y;
	}

	// List Methods

	void addItem(String data)
	{
		control_listbox.addItem(data);
	}

	void addItem(string data)
	{
		control_listbox.addItem(data);
	}

	void addList(AbstractList!(String) list)
	{
		control_listbox.addList(list);
	}

	void addList(String[] list)
	{
		control_listbox.addList(list);
	}

    bool getItem(out String data, uint index)
    {
		return control_listbox.getItem(data, index);
    }

	Iterator getIterator()
	{
		return control_listbox.getIterator();
	}

    bool getItem(out String data, ref Iterator irate)
    {
		return control_listbox.getItem(data, irate);
    }

    uint length()
    {
		return control_listbox.length();
    }

	bool remove(out String item)
	{
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

	/*void _ButtonEvents(Button button, Button.Event evt)
	{
		if (evt == Button.Event.Pressed)
		{
			// Spawn the child window, if one does not exist
			Coord pt;
			pt.x = _x;
			pt.y = _b;

			_window.ClientToScreen(pt);

			control_window.move(pt.x, pt.y);
			_window.addWindow(control_window);
			control_window.setVisibility(true);
			control_window.push(control_listbox);
		}
	}*/

	/*void _ListBoxEvents(ListBox list, ListBoxEvent evt)
	{
		if (evt == ListBoxEvent.Selected)
		{
			control_window.remove();

			String data;
			control_listbox.getItem(data, control_listbox.getSelectionStart());
		}
	}*/
}
