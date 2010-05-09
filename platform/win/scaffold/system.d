/*
 * system.d
 *
 * This file implements the Scaffold for platform specific System
 * operations in Windows.
 *
 * Author: Dave Wilkinson
 *
 */

module scaffold.system;

import platform.win.common;
import platform.win.main;

import platform.application;

import scaffold.directory;

import core.definitions;
import core.string;
import core.locale;
import core.unicode;

import platform.vars.library;

//XXX: winnls.h

extern(System) LCID GetUserDefaultLCID();

private {
	uint count;
	uint primary;

	struct DisplayInfo {
		HMONITOR handle;
		Coord pos;
		Coord frame;
	}

	extern (Windows) BOOL _win_displayPoll(HMONITOR hMonitor, HDC hdc, LPRECT rect, LPARAM lparam) {
		DisplayInfo dispInfo;
		dispInfo.handle = hMonitor;

		dispInfo.frame.x = rect.right - rect.left;
		dispInfo.frame.y = rect.bottom - rect.top;

		dispInfo.pos.x = rect.left;
		dispInfo.pos.y = rect.right;

		displays ~= dispInfo;

		MONITORINFO mInfo;
		GetMonitorInfoW(hMonitor, &mInfo);

		if (mInfo.dwFlags & MONITORINFOF_PRIMARY > 0) {
			primary = count;
		}

		count++;

		return 1;
	}

	DisplayInfo[] displays;
}

int SystemGetDisplayWidth(uint screen) {
	if (count == 0) {
		SystemGetDisplayCount();
	}

	if (screen > count || screen < 0) {
		return -1;
	}

	MONITORINFO mInfo;
	GetMonitorInfoW(displays[screen].handle, &mInfo);

	return (mInfo.rcMonitor.right - mInfo.rcMonitor.left);
}

int SystemGetDisplayHeight(uint screen) {
	if (count == 0) {
		SystemGetDisplayCount();
	}

	if (screen > count) {
		return -1;
	}

	MONITORINFO mInfo;
	GetMonitorInfoW(displays[screen].handle, &mInfo);

	return (mInfo.rcMonitor.bottom - mInfo.rcMonitor.top);
}

uint SystemGetPrimaryDisplay() {
	if (count == 0) {
		SystemGetDisplayCount();
	}
	
	return primary;
}

uint SystemGetDisplayCount() {
	// reset parameters
	count = 0;
	primary = 0;
	displays = null;

	// this will call the above callback
	EnumDisplayMonitors(null, null, &_win_displayPoll, 0);

	// return the count
	return count;
}

ulong SystemGetTotalMemory() {
	MEMORYSTATUSEX stats;
	GlobalMemoryStatusEx(&stats);

	return stats.ullTotalPhys;
}

ulong SystemGetAvailableMemory() {
	MEMORYSTATUSEX stats;
	GlobalMemoryStatusEx(&stats);

	return stats.ullAvailPhys;
}

bool SystemLoadLibrary(ref LibraryPlatformVars vars, string libraryPath) {
	wchar[] path = _ConvertFrameworkPath(Unicode.toUtf16(libraryPath ~ "\0"));

	vars.hmodule = LoadLibraryW(path.ptr);
	return vars.hmodule !is null;
}

void SystemFreeLibrary(ref LibraryPlatformVars vars) {
	if (vars.hmodule is null) { return; }
	
	FreeLibrary(vars.hmodule);
	vars.hmodule = null;
}

void* SystemLoadLibraryProc(ref LibraryPlatformVars vars, string procName) {
	if (vars.hmodule is null) {
		return null;
	}

	wstring pn = Unicode.toUtf16(procName);
	pn ~= '\0';
	return cast(void*)GetProcAddressW(vars.hmodule, pn.ptr);
}

LocaleId SystemGetLocaleId() {
	ApplicationController app = ApplicationController.instance();
	
	LCID lcid = GetUserDefaultLCID();
	if (lcid == 0x1000) {
		// LOCALE_CUSTOM_UNSPECIFIED
		
		// Must go to GetUserDefaultLocaleName()
		// Which is Vista+ only
	}

	LocaleId ret;
	switch (lcid) {
		case 0x0409:
			ret = LocaleId.English_US;
			break;
		case 0x0809:
			ret = LocaleId.English_GB;
			break;
		case 0x040c:
			ret = LocaleId.French_FR;
			break;
		default:
			ret = LocaleId.English_US;
			break;
	}
	return ret;
}

private import binding.c;

ubyte[] malloc(size_t length) {
	ubyte* ret = cast(ubyte*)binding.c.malloc(length);

	// Error, probably out of memory.
	if (ret is null) {
		return null;
	}

	return ret[0..length];
}

ubyte[] realloc(ubyte[] original, size_t length) {
	ubyte* ret = cast(ubyte*)binding.c.realloc(original.ptr, length);

	if (ret is null) {
		return null;
	}

	return ret[0..length];
}

ubyte[] calloc(size_t length) {
	ubyte* ret = cast(ubyte*)binding.c.calloc(length);

	// Error, probably out of memory.
	if (ret is null) {
		return null;
	}

	return ret[0..length];
}

void free(void[] memory) {
	binding.c.free(memory.ptr);
}
