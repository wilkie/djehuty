module platform.win.scaffolds.color;

import platform.win.vars;
import platform.win.common;

import core.view;
import core.graphics;
import core.window;
import platform.win.main;
import core.string;
import core.file;
import core.color;

import core.main;

import core.definitions;

void ColorGetSystemColor(ref Color clr, SystemColor sysColorIndex)
{
	switch (sysColorIndex)
	{
		case SystemColor.Window:
			ColorSetValue(clr, (GetSysColor(15)));
			break;
		default: break;
	}
}

