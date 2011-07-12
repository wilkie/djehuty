/*
 * system.d
 *
 * This Scaffold holds the System implementations for the Linux platform
 *
 * Author: Dave Wilkinson
 * Originated: May 19th, 2007
 *
 */

module scaffold.system;

import platform.vars.library;

import core.definitions;
import core.string;
import core.locale;

import platform.unix.common;

// Querying displays:

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

bool SystemLoadLibrary(ref LibraryPlatformVars vars, string libraryPath) {
	char[] path = libraryPath.dup ~ "\0";
	//vars.handle = dlopen(path.ptr,RTLD_LAZY);
	return false;
}

void SystemFreeLibrary(ref LibraryPlatformVars vars) {
}

void* SystemLoadLibraryProc(ref LibraryPlatformVars vars, string procName) {
	return null;
}

LocaleId SystemGetLocaleId() {
	LocaleId ret;
	return ret;
}

extern(C) {
	// XOmB gives page aligned boundary for the program
	extern ubyte _end;
}

// Start memory boundary at the end of this space
static ubyte* _boundary_start = &_end;
static ubyte* _boundary_cur = &_end;
static ubyte* _boundary_end = &_end;

ubyte[] malloc(size_t length) {
	ubyte* ret = cast(ubyte*)_boundary_cur;
	_boundary_cur += length;
	_boundary_end = _boundary_cur;

	if (ret is null) {
		return null;
	}
	
	return ret[0..length];
}

ubyte[] realloc(ubyte[] original, size_t length) {
	auto ret = malloc(length);
	size_t len = original.length;
	if (len > length) {
		len = length;
	}
	memcpy(original.ptr, ret.ptr, len);
	return ret;
}

ubyte[] calloc(size_t length) {
	return malloc(length);
}

void free(void[] memory) {
}

long SystemExecute(string path) {
	return 0;
}
