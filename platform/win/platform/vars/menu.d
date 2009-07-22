/*
 * menu.d
 *
 * This module has the structure that is kept with a Menu class for Windows.
 *
 * Author: Dave Wilkinson
 * Originated: July 22th, 2009
 *
 */

module platform.vars.menu;

import platform.win.common;

struct MenuPlatformVars {
	HMENU hMenu;
}