/*
 * menu.d
 *
 * This file implements the Scaffold for platform specific Menu
 * operations in Windows.
 *
 * Author: Dave Wilkinson
 *
 */

module platform.win.scaffolds.menu;

import platform.win.scaffolds.window;
import platform.win.vars;
import platform.win.common;
import platform.win.main;

import core.view;
import core.graphics;
import core.string;
import core.menu;
import core.main;
import core.definitions;

import io.console;

import gui.window;

void MenuCreate(ref Menu mnu, ref MenuPlatformVars menuVars)
{
	menuVars.hMenu = CreateMenu();
}

void MenuDestroy(ref Menu mnu, ref MenuPlatformVars menuVars)
{
	DestroyMenu(menuVars.hMenu);
	menuVars.hMenu = null;
}

void MenuAppend(ref Menu mnu, ref Menu toAppend, ref MenuPlatformVars mnuVars, ref MenuPlatformVars toAppendVars)
{
	String s = new String(toAppend.text);
	s.appendChar('\0');
	if (toAppend.length > 0)
	{
		AppendMenuW(mnuVars.hMenu,MF_POPUP,cast(uint*)toAppendVars.hMenu,s.ptr);
	}
	else
	{
		AppendMenuW(mnuVars.hMenu,MF_STRING,cast(uint*)toAppend,s.ptr);
	}
}

void MenuUpdate(uint position, ref Menu mnu, ref Menu toUpdate, ref MenuPlatformVars mnuVars, ref MenuPlatformVars toUpdateVars)
{
	String s = new String(toUpdate.text);
	s.appendChar('\0');
	if (toUpdate.length > 0)
	{
		ModifyMenuW(mnuVars.hMenu,position,MF_BYPOSITION | MF_POPUP,cast(uint*)toUpdateVars.hMenu,s.ptr);
	}
	else
	{
		ModifyMenuW(mnuVars.hMenu,position,MF_BYPOSITION | MF_STRING,cast(uint*)toUpdate,s.ptr);
	}
}

void WindowSetMenu(ref Menu mnu, ref MenuPlatformVars mnuVars, ref Window wnd, ref WindowHelper windowHelper)
{
	SetMenu(windowHelper.getPlatformVars().hWnd, mnuVars.hMenu);

	// resize to adapt client area
	WindowRebound(wnd,windowHelper);
}
