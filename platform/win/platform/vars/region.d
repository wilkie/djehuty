/*
 * region.d
 *
 * This module has the structure that is kept with a Region class for Windows.
 *
 * Author: Dave Wilkinson
 * Originated: July 22th, 2009
 *
 */

module platform.vars.region;

import binding.win32.windef;

struct RegionPlatformVars {
	HRGN regionHandle;
}