/*
 * gui.d
 *
 * This module contains platform specific variables for the Gui Scaffold calls.
 *
 */

module platform.vars.gui;

import binding.win32.gdiplusinit;
import binding.win32.windef;

struct GuiPlatformVars {
	ULONG_PTR gdiplusToken;
	GdiplusStartupInput gdiplusStartupInput;
}