/*
 * menu.d
 *
 * This file implements the Scaffold for platform specific Menu
 * operations in Windows.
 *
 * Author: Dave Wilkinson
 *
 */

module scaffold.menu;

import scaffold.window;

import binding.win32.windef;
import binding.win32.winnt;
import binding.win32.winbase;
import binding.win32.wingdi;
import binding.win32.winuser;

import platform.win.main;

import platform.vars.menu;
import platform.vars.window;

import core.string;
import core.main;
import core.definitions;
import core.unicode;

import io.console;

import gui.window;

import resource.menu;

void MenuCreate(MenuPlatformVars* menuVars) {
	menuVars.hMenu = CreateMenu();
}

void MenuDestroy(MenuPlatformVars* menuVars) {
	DestroyMenu(menuVars.hMenu);
	menuVars.hMenu = null;
}

void MenuAppend(void* identifier, MenuPlatformVars* mnuVars, MenuPlatformVars* toAppendVars, string text, bool hasSubitems) {
	wstring s;
	if (text == "") {
		if (hasSubitems) {
			AppendMenuW(mnuVars.hMenu,MF_SEPARATOR,cast(UINT_PTR)toAppendVars.hMenu,"\0"w.ptr);
		}
		else {
			AppendMenuW(mnuVars.hMenu,MF_SEPARATOR,cast(UINT_PTR)identifier,"\0"w.ptr);
		}
	}
	else {
		s = Unicode.toUtf16(text);
		s ~= '\0';
		if (hasSubitems) {
			AppendMenuW(mnuVars.hMenu,MF_POPUP,cast(UINT_PTR)toAppendVars.hMenu,s.ptr);
		}
		else {
			AppendMenuW(mnuVars.hMenu,MF_STRING,cast(UINT_PTR)identifier,s.ptr);
		}
	}
}

void MenuUpdate(void* identifier, MenuPlatformVars* mnuVars, MenuPlatformVars* toUpdateVars, string text, uint position, bool hasSubitems) {
	wstring s;
	if (text.trim() == "") {
		if (hasSubitems) {
			ModifyMenuW(mnuVars.hMenu,position,MF_BYPOSITION | MF_SEPARATOR,cast(UINT_PTR)toUpdateVars.hMenu,"\0"w.ptr);
		}
		else {
			ModifyMenuW(mnuVars.hMenu,position,MF_BYPOSITION | MF_SEPARATOR,cast(UINT_PTR)identifier,"\0"w.ptr);
		}
	}
	else {
		s = Unicode.toUtf16(text);
		s ~= '\0';
		if (hasSubitems) {
			ModifyMenuW(mnuVars.hMenu,position,MF_BYPOSITION | MF_POPUP,cast(UINT_PTR)toUpdateVars.hMenu,s.ptr);
		}
		else {
			ModifyMenuW(mnuVars.hMenu,position,MF_BYPOSITION | MF_STRING,cast(UINT_PTR)identifier,s.ptr);
		}
	}
}

void WindowSetMenu(MenuPlatformVars* mnuVars, ref Window wnd, WindowPlatformVars* windowVars) {
	SetMenu(windowVars.hWnd, mnuVars.hMenu);

	// resize to adapt client area
	WindowRebound(wnd,windowVars);
}
