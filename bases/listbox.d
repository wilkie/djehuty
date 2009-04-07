module bases.listbox;

import core.control;
import core.string;

import interfaces.list;
import utils.arraylist;

import platform.imports;
mixin(PlatformGenericImport!("definitions"));

enum ListBoxEvent : uint
{
	Selected,
	Unselected
}

// Section: Bases

// Description: This base provides a shell for a standard list selection box.
abstract class BaseListBox : Control, AbstractList!(String)
{
public:

	this(int x, int y, int width, int height, AbstractList!(String) list)
	{
		_x = x;
		_y = y;
		_r = x + width;
		_b = y + height;
		_width = width;
		_height = height;

		_list = new ArrayList!(String)();
		if (list !is null) { _list.addList(list); }
	}

	// support Events
	mixin(ControlAddDelegateSupport!("BaseListBox", "ListBoxEvent"));


	uint GetSelectionStart()
	{
		return m_sel_start;
	}


	// IList Methods

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

	ArrayList!(String) _list;

	uint m_first_visible;
	uint m_total_visible;
	uint m_sel_start;

	void _checkScrollBarStatus()
	{
	}

}
