module platform.win.controls.osbutton;

import gui.button;
import core.string;

import platform.win.definitions;
import platform.win.vars;
import platform.win.common;
import platform.win.oscontrolinterface;

import platform.win.main;
import core.view;
import gui.core;

class OSButton : Button, OSControl
{
public:
	this(int x, int y, int width, int height, String value)
	{
		super(x,y,width,height,value);
	}

	this(int x, int y, int width, int height, StringLiteral value)
	{
		super(x,y,width,height,value);
	}

	// support Events
	mixin(ControlAddDelegateSupport!("OSButton", "Button.Event"));

	override void OnAdd()
	{
		 _hWnd = CreateWindowExW(0,
			"BUTTON\0", cast(wchar*)_value.ptr, WS_CHILD | WS_VISIBLE | BS_PUSHBUTTON | BS_TEXT , _x,_y,_width,_height,
			WindowGetPlatformVars(_window).hWnd,null, cast(HINSTANCE)GetWindowLongW(WindowGetPlatformVars(_window).hWnd,GWLP_HINSTANCE), null);

		SetWindowPos(_hWnd, cast(HWND)HWND_TOP, 0, 0, 0, 0, SWP_NOSIZE | SWP_NOMOVE);

		SendMessageW( _hWnd, WM_SETFONT, cast(WPARAM)win_button_font, 1);

		SetWindowLongW(_hWnd, GWLP_USERDATA, cast(ulong)(cast(void*)(cast(OSControl)this)));
		_oldproc = cast(WNDPROC)SetWindowLongW(_hWnd, GWLP_WNDPROC, cast(ulong)&CtrlProc);
	}

	override void OnRemove()
	{
		DestroyWindow(_hWnd);
	}

protected:

	LRESULT _AppLoopMessage(uint message, WPARAM wParam, LPARAM lParam)
	{
		if (message == WM_COMMAND)
		{
			FireEvent(Button.Event.Selected);
			return 0;
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
