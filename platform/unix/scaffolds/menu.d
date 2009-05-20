/*
 * menu.d
 *
 * This Scaffold holds the Menu implementations for the Linux platform
 *
 * Author: Dave Wilkinson
 *
 */

module platform.unix.scaffolds.menu;

import platform.unix.vars;
import platform.unix.common;

import core.view;
import core.graphics;

import core.basewindow;
import core.window;
import core.string;
import core.menu;

import core.main;

import core.definitions;

void MenuCreate(ref Menu mnu, ref MenuPlatformVars menuVars)
{
}

void MenuDestroy(ref Menu mnu, ref MenuPlatformVars menuVars)
{
}

void MenuAppend(ref Menu mnu, ref Menu toAppend, ref MenuPlatformVars mnuVars, ref MenuPlatformVars toAppendVars)
{
	if (toAppend.GetSubMenuCount() > 0)
	{
	}
	else
	{
	}
}

void MenuUpdate(uint position, ref Menu mnu, ref Menu toUpdate, ref MenuPlatformVars mnuVars, ref MenuPlatformVars toUpdateVars)
{
	if (toUpdate.GetSubMenuCount() > 0)
	{
	}
	else
	{
	}
}

void WindowSetMenu(ref Menu mnu, ref MenuPlatformVars mnuVars, ref Window wnd, ref WindowPlatformVars windVars)
{
}

