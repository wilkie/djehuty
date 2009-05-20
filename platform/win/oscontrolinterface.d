/*
 * oscontrolinterface.d
 *
 * This file holds the OSControl interface that must be a part of an OSControl.
 *
 * Author: Dave Wilkinson
 *
 */

module platform.win.oscontrolinterface;

import platform.win.common;
import core.view;

// os control interface

interface OSControl
{
protected:
	LRESULT _AppLoopMessage(uint message, WPARAM wParam, LPARAM lParam);
	View _ReturnView(out int x, out int y, out int w, out int h);
}

LRESULT CallControlAppLoopMessage(ref OSControl ctrl, ref uint message, ref WPARAM wParam, ref LPARAM lParam)
{
	return ctrl._AppLoopMessage(message, wParam, lParam);
}

View CallControlReturnView(ref OSControl ctrl, out int x, out int y, out int w, out int h)
{
	return ctrl._ReturnView(x,y,w,h);
}