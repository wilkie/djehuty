module platform.vars.view;

import platform.osx.common;

extern (C) struct _OSXViewPlatformVars;
extern (C) struct _OSXMenuPlatformVars;
extern (C) struct _OSXWavePlatformVars;

struct ViewPlatformVars
{
	_OSXViewPlatformVars* vars;
	ulong dibBytes;
	int fromWindow;
}


