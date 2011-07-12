/*
 * color.d
 *
 * This Scaffold holds the Color implementations for the XOmB platform
 *
 * Author: Dave Wilkinson
 *
 */

module scaffold.color;

import core.color;
import core.main;
import core.definitions;

void ColorGetSystemColor(ref Color clr, SystemColor sysColorIndex) {
	// code to get a system color
	switch (sysColorIndex) {
		case SystemColor.Window:
			clr.alpha = 1.0;
			clr.red = 0.7;
			clr.green = 0.7;
			clr.blue = 0.7;
			break;
	}
}
