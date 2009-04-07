#ifndef _OSXVIEW_INC
#define _OSXVIEW_INC

#include <Cocoa/Cocoa.h>
#include <Foundation/Foundation.h>

#include "OSXWindow.h"

@class _OSXView;

struct _OSXViewPlatformVars
{
	//contains the stuff for drawing text
	//font colors and attributes and font description
	NSMutableDictionary* cur_font;

	NSLayoutManager* layout;

	NSTextContainer* container;

	NSTextStorage* txtstore;

	_OSXView* viewRef;

	NSRect nsRect;
	CGContextRef cgContext;

	// Buffers:

	NSBitmapImageRep* dib_image_rep;

	NSImage* dib_image;
};

#endif // _OSXVIEW_INC
