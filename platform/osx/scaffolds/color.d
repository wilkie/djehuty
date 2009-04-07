module platform.osx.scaffolds.color;

import platform.osx.vars;
import platform.osx.common;

import core.view;
import core.graphics;

import bases.window;
import core.window;
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
			ColorSetValue(clr, 0x0);
			break;
		default: break;
	}
}

