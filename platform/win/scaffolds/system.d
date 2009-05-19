module platform.win.scaffolds.system;

import platform.win.vars;
import platform.win.common;

import core.definitions;

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

int SystemGetScreenWidth(uint screen) {
	if (count == 0) {
		SystemGetScreenCount();
	}
	
	if (screen > count || screen < 0) {
		return -1;
	}

	MONITORINFO mInfo;
	GetMonitorInfoW(displays[screen].handle, &mInfo);

	return (mInfo.rcMonitor.right - mInfo.rcMonitor.left);
}

int SystemGetScreenHeight(uint screen) {
	if (count == 0) {
		SystemGetScreenCount();
	}

	if (screen > count) {
		return -1;
	}

	MONITORINFO mInfo;
	GetMonitorInfoW(displays[screen].handle, &mInfo);

	return (mInfo.rcMonitor.bottom - mInfo.rcMonitor.top);
}

uint SystemGetPrimaryScreen() {
	if (count == 0) {
		SystemGetScreenCount();
	}
	
	return primary;
}

long SystemGetScreenCount() {
	// reset parameters
	count = 0;
	primary = 0;
	displays = null;

	// this will call the above callback
	EnumDisplayMonitors(null, null, &_win_displayPoll, 0);

	// return the count
	return count;
}