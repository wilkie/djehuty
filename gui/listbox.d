module gui.listbox;

import gui.core;
import core.color;
import core.definitions;
import core.string;
import core.graphics;

import utils.arraylist;

import interfaces.list;

import gui.vscrollbar;
import core.windowedcontrol;

template ControlPrintCSTRList()
{
	const char[] ControlPrintCSTRList = `
	this(int x, int y, int width, int height, AbstractList!(String) list = null)
	{
		super(x,y,width,height,list);
	}
`;
}

enum ListBoxEvent : uint
{
	Selected,
	Unselected
}

// Description: This control provides a standard list selection box.
class ListBox : WindowedControl
{
	this(int x, int y, int width, int height, AbstractList!(String) list = null)
	{
		super(x,y,width,height);

		_list = new ArrayList!(String)();
		if (list !is null) { _list.addList(list); }
	}

	// support Events
	mixin(ControlAddDelegateSupport!("ListBox", "ListBoxEvent"));

	// handle events
	override void OnAdd()
	{
		if (control_scroll is null)
		{
			control_scroll = new VScrollBar(_r - 17,_y, 17, _height);
		}

		_font = new Font(FontSans, 8, 400, false, false, false);

		Graphics grp = _view.lockDisplay();
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

		m_total_visible = ((_height+2) / m_entryHeight.y) + 1;

		_window.push(control_scroll);

		control_scroll.SetScrollPeriods(1, m_total_visible-2);
		control_scroll.SetRange(0, _list.length() - m_total_visible+1);

		control_scroll.SetEnabled(false);
	}

	override void OnRemove()
	{
		control_scroll.remove();
	}

	override void OnDraw(ref Graphics g)
	{
	//draw all entries

		uint i;

		Rect rt;

		Brush brsh;
		Pen pen;

		brsh = new Brush(m_clrbackground);
		pen = new Pen(m_clroutline);

		g.setPen(pen);
		g.setBrush(brsh);

		g.drawRect(_x, _y, _r, _b);

		rt.left = _x+1;
		rt.top = _y+1;
		rt.right = _r - control_scroll.getWidth();
		rt.bottom = rt.top + m_entryHeight.y;

		// set text mode to transparent
		g.setTextModeTransparent();

		g.setTextBackgroundColor(m_clrhighlight);
		g.setTextColor(m_clrnormal);

		g.setFont(_font);

		String data;

		for (i=m_first_visible; i<m_first_visible+m_total_visible && i<_list.length(); i++)
		{
			_list.getItem(data, i);

			if (i==m_sel_start)
			{
				// set text mode to opaque (selection!)
				g.setTextModeOpaque();
				g.setTextColor(m_clrhighlighttext);

				g.drawClippedText(rt.left, rt.top, rt, data);

				g.setTextColor(m_clrnormal);
				g.setTextModeTransparent();
			}
			else
			{
				g.drawClippedText(rt.left, rt.top, rt, data);
			}

			rt.top = rt.bottom;

			if (rt.bottom == _b-1) { break; }

			rt.bottom += m_entryHeight.y;

			if (rt.bottom >= _b) { rt.bottom = _b-1; }
		}
	}

	override bool OnPrimaryMouseDown(ref Mouse mouseProps)
	{
		uint curEntry = (mouseProps.y - _y);
		curEntry -= 1; //remove top margin

		curEntry /= m_entryHeight.y;

		curEntry += m_first_visible;

		if (curEntry < _list.length())
		{
			//mark this as selected
			if (m_sel_start != curEntry)
			{
				m_sel_start = curEntry;

				FireEvent(ListBoxEvent.Selected);

				return true;
			}

			FireEvent(ListBoxEvent.Selected);
		}
		else
		{
			if (m_sel_start != -1)
			{
				m_sel_start = -1;
				return true;
			}
		}

		return false;
	}

	uint getSelectionStart()
	{
		return m_sel_start;
	}

	// AbstractList Methods

	void addItem(String data)
	{
		_list.addItem(data);

		_checkScrollBarStatus();
	}

	void addItem(StringLiteral data)
	{
		_list.addItem(new String(data));

		_checkScrollBarStatus();
	}

	void addList(AbstractList!(String) list)
	{
		_list.addList(list);

		_checkScrollBarStatus();
	}

	void addList(String[] list)
	{
		_list.addList(list);

		_checkScrollBarStatus();
	}

    bool getItem(out String data, uint index)
    {
		return _list.getItem(data, index);
    }

	Iterator getIterator()
	{
		return _list.getIterator();
	}

	bool getItem(out String data, ref Iterator irate)
	{
		return _list.getItem(data, irate);
    }

    uint length()
    {
		return _list.length();
    }

	bool remove(out String item)
	{
		return _list.remove(item);
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

	ArrayList!(String) _list;

	int m_hoverstate;

	VScrollBar control_scroll;

	void _checkScrollBarStatus()
	{
		//make sure list refits the list when it gets taller
		if (m_first_visible > _list.length() - m_total_visible + 2)
		{
			m_first_visible = _list.length() - m_total_visible + 2;

			control_scroll.SetValue(m_first_visible);
		}

		//whether or not the scroll bar is in use
		if (_list.length() - m_total_visible >= 0 && _list.length() - m_total_visible < _list.length())
		{
			//scroll bars should be enabled
			control_scroll.SetEnabled(true);

			control_scroll.SetRange(0, _list.length() - m_total_visible + 1);
		}
		else
		{
			control_scroll.SetEnabled(false);
		}
	}
}
