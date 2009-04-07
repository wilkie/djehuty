#ifndef _OSXWINDOW_INC
#define _OSXWINDOW_INC

#include <Cocoa/Cocoa.h>
#include <Foundation/Foundation.h>

struct _OSXWindowPlatformVars
{
	void* windowClassRef;
	NSWindow* windowRef;
	NSEvent* curEvent;
	unsigned int curEventType; // 0 - mouseMoved, 1 - mouseDragged

	struct _OSXViewPlatformVars* viewVars;
};

#endif // _OSXWINDOW_INC
