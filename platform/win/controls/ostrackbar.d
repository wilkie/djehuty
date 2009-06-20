module platform.win.controls.ostrackbar;

import gui.trackbar;
import core.string;

import platform.win.definitions;
import platform.win.vars;
import platform.win.common;
import platform.win.oscontrolinterface;

import platform.win.main;
import core.view;
import gui.core;

class OSTrackBar : TrackBar, OSControl
{
public:
	this(int x, int y, int width, int height)
	{
		super(x,y,width,height);
	}

	// support Events
	mixin(ControlAddDelegateSupport!("OSTrackBar", "TrackBarEvent"));

	override void OnAdd()
	{
		 _hWnd = CreateWindowExW(0,
			"msctls_trackbar32\0", null, WS_CHILD | WS_VISIBLE | TBS_AUTOTICKS , _x,_y,_width,_height,
			WindowGetPlatformVars(_window).hWnd,null, cast(HINSTANCE)GetWindowLongW(WindowGetPlatformVars(_window).hWnd,GWLP_HINSTANCE), null);

		SetWindowPos(_hWnd, cast(HWND)HWND_TOP, 0, 0, 0, 0, SWP_NOSIZE | SWP_NOMOVE);

		SetWindowLongW(_hWnd, GWLP_USERDATA, cast(ulong)(cast(void*)(cast(OSControl)this)));
		_oldproc = cast(WNDPROC)SetWindowLongW(_hWnd, GWLP_WNDPROC, cast(ulong)&CtrlProc);

		setRange(_min, _max);
		setValue(_value);
		setTickFrequency(_tickFreq);
	}

	override void OnRemove()
	{
		DestroyWindow(_hWnd);
	}

	override void setValue(long value)
	{
		super.setValue(value);

		if (_is64)
		{
			int val = cast(int)((cast(double)_value) * _proportion);
			SendMessageW(_hWnd, TBM_SETPOS, 0, val);
		}
		else
		{
			SendMessageW(_hWnd, TBM_SETPOS, 0, cast(int)_value);
		}
	}

	override void setRange(long min, long max)
	{
		super.setRange(min, max);

		if (_min <= 0xfffffff && _max <= 0xfffffff)
		{
			_implMin = cast(int)_min;
			_implMax = cast(int)_max;

			_proportion = 1.0f;
			_is64=false;
		}
		else
		{
			_implMin = 0;
			_implMax = 0xfffffff;
			_is64=true;

			_proportion = cast(double)(_max - _min) / cast(double)0xfffffff;
		}

		SendMessageW(_hWnd, TBM_SETRANGEMIN, 0, _implMin);
		SendMessageW(_hWnd, TBM_SETRANGEMAX, 0, _implMax);
	}

	override void setTickFrequency(ulong tickFreq)
	{
		super.setTickFrequency(tickFreq);

		if (_is64) {
			int _freq = cast(int)((cast(double)_tickFreq) * _proportion);
			SendMessageW(_hWnd, TBM_SETTICFREQ, _freq, 0);
		} else {
			SendMessageW(_hWnd, TBM_SETTICFREQ, cast(int)_tickFreq, 0);
		}
	}

protected:

	int _implMin;
	int _implMax;
	double _proportion;

	bool _is64;

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
