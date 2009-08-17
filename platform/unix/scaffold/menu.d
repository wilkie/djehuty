/*
 * menu.d
 *
 * This Scaffold holds the Menu implementations for the Linux platform
 *
 * Author: Dave Wilkinson
 *
 */

module scaffold.menu;

import platform.vars.window;
import platform.vars.menu;
import platform.unix.common;

import core.string;
import core.main;
import core.definitions;

import resource.menu;

import gui.window;

void MenuCreate(MenuPlatformVars* menuVars)
{
}

void MenuDestroy(MenuPlatformVars* menuVars)
{
}

void MenuAppend(void* identifier, MenuPlatformVars* mnuVars, MenuPlatformVars* toAppendVars, String text, bool hasSubitems)
{
	if (hasSubitems)
	{
	}
	else
	{
	}
}

void MenuUpdate(void* identifier, MenuPlatformVars* mnuVars, MenuPlatformVars* toUpdateVars, String text, uint position, bool hasSubitems)
{
	if (hasSubitems)
	{
	}
	else
	{
	}
}

void WindowSetMenu(MenuPlatformVars* mnuVars, ref Window wnd, WindowPlatformVars* windowVars)
{
}

