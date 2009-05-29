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
import core.string;

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

bool SystemLoadLibrary(ref LibraryPlatformVars vars, String libraryPath) {
	char[] path = libraryPath.array ~ "\0";
	//vars.handle = dlopen(path.ptr,RTLD_LAZY);
	return vars.handle !is null;
}

void SystemFreeLibrary(ref LibraryPlatformVars vars) {
	if (vars.handle is null) { return; }
	//dlclose(vars.handle);
	vars.handle = null;
}

void* SystemLoadLibraryProc(ref LibraryPlatformVars vars, String procName) {
	if (vars.handle is null) {
		return null;
	}

	char[] proc = procName.array ~ "\0";
	//return cast(void*)dlsym(vars.handle, proc.ptr);
	return null;
}