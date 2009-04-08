module platform.win.controls.osprogressbar;

import controls.progressbar;
import core.string;

import platform.win.definitions;
import platform.win.vars;
import platform.win.common;
import platform.win.oscontrolinterface;

import bases.window;

import platform.win.main;
import core.view;
import core.control;

class OSProgressBar : ProgressBar, OSControl
{
public:
	this(int x, int y, int width, int height)
	{
		super(x,y,width,height);
	}

	override void OnAdd()
	{
		 _hWnd = CreateWindowExW(0,
			"msctls_progress32\0", null, WS_CHILD | WS_VISIBLE , _x,_y,_width,_height,
			WindowGetPlatformVars(_window).hWnd,null, cast(HINSTANCE)GetWindowLongW(WindowGetPlatformVars(_window).hWnd,GWLP_HINSTANCE), null);

		SetWindowPos(_hWnd, cast(HWND)HWND_TOP, 0, 0, 0, 0, SWP_NOSIZE | SWP_NOMOVE);

		SendMessageW(_hWnd, PBM_SETRANGE32, 0, MAX_RANGE); // from 0 to MAX_RANGE
		SendMessageW(_hWnd, PBM_SETSTEP, 0, 0);

		SetWindowLongW(_hWnd, GWLP_USERDATA, cast(ulong)(cast(void*)(cast(OSControl)this)));
		_oldproc = cast(WNDPROC)SetWindowLongW(_hWnd, GWLP_WNDPROC, cast(ulong)&CtrlProc);
	}

	override void OnRemove()
	{
		DestroyWindow(_hWnd);
	}

	override void setValue(long value)
	{
		super.setValue(value);

		// update the control

		if (_value == _max) {
			SendMessageW( _hWnd, PBM_SETPOS, MAX_RANGE, 0);
		}
		else {
			float percentage = cast(float)(_value - _min) / cast(float)(_max - _min);
			int newval = cast(int)(cast(float)MAX_RANGE * percentage);

			SendMessageW( _hWnd, PBM_SETPOS, newval, 0);
		}
	}

protected:

	const int MAX_RANGE = 0xfffffff;

	LRESULT _AppLoopMessage(uint message, WPARAM wParam, LPARAM lParam)
	{
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
