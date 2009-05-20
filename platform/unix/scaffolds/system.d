/*
 * system.d
 *
 * This Scaffold holds the System implementations for the Linux platform
 *
 * Author: Dave Wilkinson
 * Originated: May 19th, 2007
 *
 */

module platform.unix.scaffolds.system;

import core.definitions;

// Querying displays:

// Xinerama Extension:
// -----------------------
// XineramaQueryExtension
// XineramaQueryScreens

int SystemGetDisplayWidth(uint screen) {
	return 0;
}

int SystemGetDisplayHeight(uint screen) {
	return 0;
}

uint SystemGetPrimaryDisplay() {
	// The primary display is 0

	return 0;
}

uint SystemGetDisplayCount() {
	return 0;
}

ulong SystemGetTotalMemory() {
	return 0;
}

ulong SystemGetAvailableMemory() {
	return 0;
}
