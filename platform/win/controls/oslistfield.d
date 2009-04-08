module platform.win.controls.oslistfield;

import controls.listfield;
import core.string;

import platform.win.definitions;
import platform.win.vars;
import platform.win.common;
import platform.win.oscontrolinterface;

import platform.win.main;
import core.view;
import core.control;
import bases.windowedcontrol;

import core.basewindow;

import interfaces.list;

import utils.arraylist;

class OSListField : ListField, OSControl
{
public:

	this(int x, int y, int width, int height, AbstractList!(String) list = null)
	{
		super(x,y,width,height,null);
	}

	// support Events
	mixin(ControlAddDelegateSupport!("OSListField", "ListFieldEvent"));

	override void OnAdd()
	{
		// CBS_DROPDOWN - editable
	   _hWnd = CreateWindowExW(0, "COMBOBOX\0", null, WS_CHILD | WS_VISIBLE | CBS_DROPDOWNLIST | WS_BORDER | WS_VSCROLL , _x,_y,_width,_height,
			WindowGetPlatformVars(_window).hWnd,null, cast(HINSTANCE)GetWindowLongW(WindowGetPlatformVars(_window).hWnd,GWLP_HINSTANCE), null);

		SetWindowPos(_hWnd, cast(HWND)HWND_TOP, 0, 0, 0, 0, SWP_NOSIZE | SWP_NOMOVE);

		SetWindowLongW(_hWnd, GWLP_USERDATA, cast(ulong)(cast(void*)(cast(OSControl)this)));
		_oldproc = cast(WNDPROC)SetWindowLongW(_hWnd, GWLP_WNDPROC, cast(ulong)&CtrlProc);

		SendMessageW( _hWnd, WM_SETFONT, cast(WPARAM)win_button_font, 1);

		// Add all members of the list
		Iterator irate = getIterator();

		String data;
		while(getItem(data, irate))
		{
			SendMessageW(_hWnd, CB_ADDSTRING, 0, cast(LPARAM)data.ptr);
		}
	}

	override void OnRemove()
	{
		DestroyWindow(_hWnd);
	}

	override void addItem(String text)
	{
		_list.addItem(text);
		SendMessageW(_hWnd, CB_ADDSTRING, 0, cast(LPARAM)text.ptr);
	}

	override void addItem(StringLiteral text)
	{
		_list.addItem(new String(text));
		SendMessageW(_hWnd, CB_ADDSTRING, 0, cast(LPARAM)text.ptr);
	}

	override void addList(AbstractList!(String) list)
	{
		Iterator irate = _list.getIterator();

		String data;
		while(_list.getItem(data, irate))
		{
			addItem(data);
		}
	}

	override bool getItem(out String data, uint index)
	{
		return _list.getItem(data, index);
	}

	override Iterator getIterator()
	{
		return _list.getIterator();
	}

    override bool getItem(out String data, ref Iterator irate)
	{
		return _list.getItem(data, irate);
	}

    override uint length()
    {
		return _list.length();
    }

protected:

	LRESULT _AppLoopMessage(uint message, WPARAM wParam, LPARAM lParam)
	{
		switch (message)
		{
			break;
		default:
			break;
		}

		return CallWindowProcW(_oldproc, _hWnd, message, wParam, lParam);
	}

	View _ReturnView(out int x, out int y, out int w, out int h)
	{
		x = _x;
		y = _y;
		w = _width;
		h = _height;
		return _view;
	}

	HWND _hWnd;
	WNDPROC _oldproc;
}
