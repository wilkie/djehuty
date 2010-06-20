/*
 * main.d
 *
 * This is the main entry point for windows applications.
 *
 * Author: Dave Wilkinson
 * Originated: July 20th, 2009
 *
 */

module platform.win.main;

import binding.win32.winnt;
import binding.win32.windef;

import core.arguments;
import core.string;
import core.unicode;
import core.main;

import io.console;

import binding.c;

import analyzing.debugger;

import platform.application;

// Convert real in ST0 to ulong

private real adjust = cast(real)0x800_0000_0000_0000 * 0x10;

private short roundTo0 = 0xFBF;

extern(C) ulong __LDBLULLNG()
{
    version (OSX)
    {
	asm
	{   naked				;
	    push	0xFBF			; // roundTo0
	    push	0x0000403e		;
	    push	0x80000000		;
	    push	0			; // adjust
	    sub		ESP,16			;
	    fld		real ptr 16[ESP]	; // adjust
	    fcomp				;
	    fstsw	AX			;
	    fstcw	8[ESP]			;
	    fldcw	28[ESP]			; // roundTo0
	    sahf				;
	    jae		L1			;
	    fld		real ptr 16[ESP]	; // adjust
	    fsubp	ST(1), ST		;
	    fistp	qword ptr [ESP]		;
	    pop		EAX			;
	    pop		EDX			;
	    fldcw	[ESP]			;
	    add		ESP,24			;
	    add		EDX,0x8000_0000		;
	    ret					;
	L1:					;
	    fistp	qword ptr [ESP]		;
	    pop		EAX			;
	    pop		EDX			;
	    fldcw	[ESP]			;
	    add		ESP,24			;
	    ret					;
	}
    }
    else
    {
	asm
	{   naked				;
	    sub		ESP,16			;
	    fld		real ptr adjust		;
	    fcomp				;
	    fstsw	AX			;
	    fstcw	8[ESP]			;
	    fldcw	roundTo0		;
	    sahf				;
	    jae		L1			;
	    fld		real ptr adjust		;
	    fsubp	ST(1), ST		;
	    fistp	qword ptr [ESP]		;
	    pop		EAX			;
	    pop		EDX			;
	    fldcw	[ESP]			;
	    add		ESP,8			;
	    add		EDX,0x8000_0000		;
	    ret					;
	L1:					;
	    fistp	qword ptr [ESP]		;
	    pop		EAX			;
	    pop		EDX			;
	    fldcw	[ESP]			;
	    add		ESP,8			;
	    ret					;
	}
    }
}

extern (C) void gc_init();
extern (C) void gc_term();
extern (C) void _minit();
extern (C) void _moduleCtor();
extern (C) void _moduleUnitTests();

// The windows entry point
extern (Windows)
int WinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance, LPSTR lpCmdLine, int nCmdShow) {

	int result;

	gc_init();			// initialize garbage collector
	_minit();			// initialize module constructor table

	int windowsVersion;

	try {

		ApplicationController app = ApplicationController.instance;

		windowsVersion = app.windowsVersion;

		_moduleCtor();		// call module constructors
		_moduleUnitTests();	// run unit tests (optional)

		Djehuty.application.run();

		app = null;
	}
	catch (Object o) {
		// Catch any unhandled exceptions
		Debugger.raiseException(cast(Exception)o);

		result = 0;		// failed
	}

	// This is a bug in the GC with windows 7... I just don't call it
	// XXX: Fix when GC is fixed
	if (windowsVersion != OsVersionWindows7) {
		gc_term();			// run finalizers; terminate garbage collector
	}

    return result;
}
