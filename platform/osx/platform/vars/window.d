module platform.vars.window;

import platform.vars.view;

import platform.osx.common;

extern (C) struct _OSXWindowPlatformVars;

struct WindowPlatformVars {
	_OSXWindowPlatformVars* vars;
	_OSXViewPlatformVars* viewVars;
}


