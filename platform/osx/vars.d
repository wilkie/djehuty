module platform.osx.vars;

import platform.osx.common;

import core.definitions;
import core.thread;

import core.semaphore;
import core.audio;
import core.stream;

// objective-c cross overs
extern (C) struct _OSXWindowPlatformVars;
extern (C) struct _OSXViewPlatformVars;
extern (C) struct _OSXMenuPlatformVars;
extern (C) struct _OSXWavePlatformVars;

// platform vars

struct WindowPlatformVars
{
	_OSXWindowPlatformVars* vars;
	_OSXViewPlatformVars* viewVars;
}

struct ViewPlatformVars
{
	_OSXViewPlatformVars* vars;
	ulong dibBytes;
	int fromWindow;
}

public import platform.unix.vars : FilePlatformVars;

public import platform.unix.vars : ThreadPlatformVars;
public import platform.unix.vars : SemaphorePlatformVars;
public import platform.unix.vars : MutexPlatformVars;

public import platform.unix.vars : SocketPlatformVars;

struct MenuPlatformVars
{
	_OSXMenuPlatformVars* vars;
}

struct WavePlatformVars
{
	_OSXWavePlatformVars* vars;
}