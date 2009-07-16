/*
 * widget.d
 *
 * This file holds the WinWidget interface that must be a part of an OSWidget.
 *
 * Author: Dave Wilkinson
 *
 */

module platform.win.widget;

import platform.win.common;

import graphics.view;

// os control interface

interface WinWidget
{
protected:
	LRESULT _AppLoopMessage(uint message, WPARAM wParam, LPARAM lParam);
	View _ReturnView(out int x, out int y, out int w, out int h);
}

LRESULT CallAppLoopMessage(WinWidget ctrl, uint message, WPARAM wParam, LPARAM lParam) {
	return ctrl._AppLoopMessage(message, wParam, lParam);
}

View CallReturnView(WinWidget ctrl, out int x, out int y, out int w, out int h) {
	return ctrl._ReturnView(x,y,w,h);
}