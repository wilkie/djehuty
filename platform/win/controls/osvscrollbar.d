module platform.win.controls.osvscrollbar;

import core.string;

import platform.win.definitions;
import platform.win.vars;
import platform.win.common;
import platform.win.oscontrolinterface;

import platform.win.main;
import core.view;
import gui.widget;
import gui.window;

import gui.vscrollbar;

class OSVScrollBar : VScrollBar, OSControl
{
public:
	this(int x, int y, int width, int height)
	{
		super(x,y,width,height);
	}

	override void OnAdd()
	{
		 _hWnd = CreateWindowExW(0,
			"SCROLLBAR\0", null, WS_CHILD | WS_VISIBLE | SBS_VERT , _x,_y,_width,_height,
			WindowGetPlatformVars(_window).hWnd,null, cast(HINSTANCE)GetWindowLongW(WindowGetPlatformVars(_window).hWnd,GWLP_HINSTANCE), null);

		SetWindowPos(_hWnd, cast(HWND)HWND_TOP, 0, 0, 0, 0, SWP_NOSIZE | SWP_NOMOVE);

		SetWindowLongW(_hWnd, GWLP_USERDATA, cast(ulong)(cast(void*)(cast(OSControl)this)));
		_oldproc = cast(WNDPROC)SetWindowLongW(_hWnd, GWLP_WNDPROC, cast(ulong)&CtrlProc);

		SetScrollRange(_hWnd, SB_CTL, cast(uint)m_min, cast(uint)m_max, FALSE);
	}

	override void OnRemove()
	{
		DestroyWindow(_hWnd);
	}

protected:

	LRESULT _AppLoopMessage(uint message, WPARAM wParam, LPARAM lParam)
	{
		SCROLLINFO sinfo = {0};
		sinfo.cbSize = SCROLLINFO.sizeof;
		sinfo.fMask = SIF_TRACKPOS;

		if (message == WM_VSCROLL)
		{
			switch(wParam)
			{
				case SB_THUMBTRACK:
					GetScrollInfo(_hWnd, SB_CTL, &sinfo);
					m_value = sinfo.nTrackPos;
					break ;
				case SB_LINEDOWN:
					m_value += m_small_change ;
					if (m_value > m_max) { m_value = m_max; }
					break ;
				case SB_LINEUP:
					m_value -= m_small_change ;
					if (m_value < m_min) { m_value = m_min; }
					break ;
				case SB_PAGEDOWN:
					m_value += m_large_change ;
					if (m_value > m_max) { m_value = m_max; }
					break ;
				case SB_PAGEUP:
					m_value -= m_large_change ;
					if (m_value < m_min) { m_value = m_min; }
					break ;
				default:
					return 0;
			}

			// was scrolled
			SetScrollPos (_hWnd, SB_CTL, cast(uint)m_value, 1) ;

			raiseSignal(Signal.Scrolled);

			_window.redraw();

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
