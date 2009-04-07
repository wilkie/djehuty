module controls.listfield;

import core.control;
import core.color;
import core.definitions;
import core.string;
import core.graphics;
import core.window;

import controls.button;
import controls.listbox;

import bases.listfield;

import interfaces.list;

public import bases.listfield : ListFieldEvent;

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

	override void OnLostFocus()
	{
		remove();
	}
}

// Section: Controls

// Description: This control provides a standard dropdown list selection box.
class ListField : BaseListField
{
	this(int x, int y, int width, int height, AbstractList!(String) list = null)
	{
		super(x,y,width,height,list);
		control_button = new Button(_r - _height,_y, _height, _height, "V");
		control_listbox = new ListBox(0,0, _width,_width / 2);
		control_window = new ListFieldWindow(_width);

		control_button.setDelegate(&_ButtonEvents);
		control_listbox.setDelegate(&_ListBoxEvents);

		if (list !is null)
		{
			control_listbox.addList(list);
		}
	}

	// I do not know why I need this to compile in D 2.0 without warnings:
	alias BaseListField.remove remove;

	// support Events
	mixin(ControlAddDelegateSupport!("ListField", "ListFieldEvent"));

	// handle events
	override void OnAdd()
	{
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
		_window.addControl(control_button);

		control_button.setEnabled(false);
	}

	override void OnRemove()
	{
		//control_button.remove();
	}

	override void OnDraw(ref Graphics g)
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





	// IList Methods

	override void addItem(String data)
	{
		control_listbox.addItem(data);
	}

	override void addItem(StringLiteral data)
	{
		control_listbox.addItem(data);
	}

	override void addList(AbstractList!(String) list)
	{
		control_listbox.addList(list);
	}

    override bool getItem(out String data, uint index)
    {
		return control_listbox.getItem(data, index);
    }

	override Iterator getIterator()
	{
		return control_listbox.getIterator();
	}

    override bool getItem(out String data, ref Iterator irate)
    {
		return control_listbox.getItem(data, irate);
    }

    override uint length()
    {
		return control_listbox.length();
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

	void _ButtonEvents(Button button, ButtonEvent evt)
	{
		if (evt == ButtonEvent.Pressed)
		{
			// Spawn the child window, if one does not exist
			Coord pt;
			pt.x = _x;
			pt.y = _b;

			_window.ClientToScreen(pt);

			control_window.move(pt.x, pt.y);
			_window.addWindow(control_window);
			control_window.setVisibility(true);
			control_window.addControl(control_listbox);
		}
	}

	void _ListBoxEvents(ListBox list, ListBoxEvent evt)
	{
		if (evt == ListBoxEvent.Selected)
		{
			control_window.remove();

			String data;
			control_listbox.getItem(data, control_listbox.GetSelectionStart());
		}
	}
}
