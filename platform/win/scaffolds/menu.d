module platform.win.scaffolds.menu;

import platform.win.scaffolds.window;

import platform.win.vars;
import platform.win.common;

import core.view;
import core.graphics;

import bases.window;
import core.window;
import platform.win.main;
import core.string;
import core.menu;

import core.main;

import core.definitions;

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
	String s = new String(toAppend.getText());
	s.appendChar('\0');
	if (toAppend.GetSubMenuCount() > 0)
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
	String s = new String(toUpdate.getText());
	s.appendChar('\0');
	if (toUpdate.GetSubMenuCount() > 0)
	{
		ModifyMenuW(mnuVars.hMenu,position,MF_BYPOSITION | MF_POPUP,cast(uint*)toUpdateVars.hMenu,s.ptr);
	}
	else
	{
		ModifyMenuW(mnuVars.hMenu,position,MF_BYPOSITION | MF_STRING,cast(uint*)toUpdate,s.ptr);
	}
}

void WindowSetMenu(ref Menu mnu, ref MenuPlatformVars mnuVars, ref Window wnd, ref WindowPlatformVars windVars)
{
	SetMenu(windVars.hWnd, mnuVars.hMenu);

	// resize to adapt client area
	BaseWindow bw = cast(BaseWindow)wnd;
	WindowRebound(bw,&windVars);
}
