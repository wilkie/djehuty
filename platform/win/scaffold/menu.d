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

import platform.win.common;
import platform.win.main;

import platform.vars.menu;
import platform.vars.window;

import core.string;
import core.main;
import core.definitions;

import io.console;

import gui.window;

import resource.menu;

void MenuCreate(MenuPlatformVars* menuVars)
{
	menuVars.hMenu = CreateMenu();
}

void MenuDestroy(MenuPlatformVars* menuVars)
{
	DestroyMenu(menuVars.hMenu);
	menuVars.hMenu = null;
}

void MenuAppend(void* identifier, MenuPlatformVars* mnuVars, MenuPlatformVars* toAppendVars, String text, bool hasSubitems)
{
	String s = new String(text);
	s.appendChar('\0');
	if (hasSubitems)
	{
		AppendMenuW(mnuVars.hMenu,MF_POPUP,cast(uint*)toAppendVars.hMenu,s.ptr);
	}
	else
	{
		AppendMenuW(mnuVars.hMenu,MF_STRING,cast(uint*)identifier,s.ptr);
	}
}

void MenuUpdate(void* identifier, MenuPlatformVars* mnuVars, MenuPlatformVars* toUpdateVars, String text, uint position, bool hasSubitems)
{
	String s = new String(text);
	s.appendChar('\0');
	if (hasSubitems)
	{
		ModifyMenuW(mnuVars.hMenu,position,MF_BYPOSITION | MF_POPUP,cast(uint*)toUpdateVars.hMenu,s.ptr);
	}
	else
	{
		ModifyMenuW(mnuVars.hMenu,position,MF_BYPOSITION | MF_STRING,cast(uint*)identifier,s.ptr);
	}
}

void WindowSetMenu(MenuPlatformVars* mnuVars, ref Window wnd, WindowPlatformVars* windowVars)
{
	SetMenu(windowVars.hWnd, mnuVars.hMenu);

	// resize to adapt client area
	WindowRebound(wnd,windowVars);
}
