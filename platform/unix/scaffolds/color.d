module platform.unix.scaffolds.color;

import platform.unix.vars;
import platform.unix.common;

import core.color;
import core.main;
import core.definitions;

void ColorGetSystemColor(ref Color clr, SystemColor sysColorIndex)
{
	// code to get a system color
	switch (sysColorIndex)
	{
		case SystemColor.Window:
			ColorSetValue(clr, 0xd8d8d8);
			break;
	}
}




