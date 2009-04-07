module bases.listfield;

import core.control;
import core.string;

import interfaces.list;
import utils.arraylist;

import platform.imports;
mixin(PlatformGenericImport!("definitions"));

enum ListFieldEvent : uint
{
	Selected,
	Unselected
}

// Section: Bases

// Description: This base provides a shell for a standard dropdown list selection field.
abstract class BaseListField : Control, AbstractList!(String)
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
	}




	// support Events
	mixin(ControlAddDelegateSupport!("BaseListField", "ListFieldEvent"));




	// IList Methods

	void addItem(String data)
	{
	}

	void addItem(StringLiteral data)
	{
	}

	void addList(AbstractList!(String) list)
	{
	}

	bool getItem(out String data, uint index)
	{
		return false;
    }

	Iterator getIterator()
	{
		Iterator d;
		return d;
	}

	bool getItem(out String data, ref Iterator irate)
	{
		return false;
    }

    uint length()
    {
		return 0;
    }

	bool remove(out String item)
	{
		return false;
	}




protected:


}

