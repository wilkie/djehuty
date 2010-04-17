#include <Cocoa/Cocoa.h>
#include <Foundation/Foundation.h>

#include "OSXView.h"

enum OSXEvents
{
	// Window Events

	EventResize, // parameters: (width, height) of window

	// Mouse Events, params are (x, y) coordinates

	EventPrimaryDown,
	EventSecondaryDown,
	EventTertiaryDown,
	EventPrimaryUp,
	EventSecondaryUp,
	EventTertiaryUp,
	EventMouseMove,

	EventOtherDown = 0xff,
	EventOtherUp = 0xffff,
};

void OSXEventRoutine(void* window, int event, int p1, int p2);
void _D_OSXInitView(void* windPtr, struct _OSXViewPlatformVars* viewVars);

@interface _OSXWindow : NSWindow {
	@public
		void* window;
		struct _OSXWindowPlatformVars* window_info;
}

@end

@interface _OSXView : NSView <NSWindowDelegate> {
	@public
		void* window;
		struct _OSXWindowPlatformVars* window_info;
}
- (void)tick:(NSTimer*)timer;
- (void)OSX_HandleEvent:(NSEvent*)event;
@end

@implementation _OSXWindow

-(void)windowWillClose:(NSNotification *)notification {
	//OSX_CloseWindowPrologue(window);
}

- (void)drawRect:(NSRect)rect {
	window_info->viewVars->nsRect = [ window_info->viewVars->viewRef bounds ];

	[ window_info->viewVars->viewRef setNeedsDisplay:YES ];

	OSXEventRoutine(window_info->windowClassRef, EventResize, window_info->viewVars->nsRect.size.width, window_info->viewVars->nsRect.size.height);

//	printf("OBJ-C: done with drawRect\n");
}

-(BOOL)isFlipped {
	return YES;
}

- (BOOL)acceptsMouseMovedEvents {
    return YES;
}
@end

@implementation _OSXView

-(BOOL)isFlipped {
	return YES;
}

- (BOOL)acceptsFirstResponder {
    return YES;
}

- (BOOL)acceptsMouseMovedEvents {
    return YES;
}
/*
-(void)windowDidExpose:(NSNotification*)aNotification {
	printf("OBJ-C: done with windowDidExpose\n");
}

-(void)windowDidUpdate:(NSNotification*)aNotification {
	window_info->viewVars->nsRect = [ window_info->viewVars->viewRef bounds ];

	[ window_info->viewVars->viewRef setNeedsDisplay:YES ];

	OSXEventRoutine(window_info->windowClassRef, EventResize, window_info->viewVars->nsRect.size.width, window_info->viewVars->nsRect.size.height);

	printf("OBJ-C: done with windowDidUpdate\n");
}

-(void)windowDidResize:(NSNotification*)aNotification {
	printf("OBJ-C: done with windowDidResize\n");
}
*/
- (void)drawRect:(NSRect)rect {
	printf("drawRect\n");
	window_info->viewVars->nsRect = [ window_info->viewVars->viewRef bounds ];

	[ window_info->viewVars->viewRef setNeedsDisplay:YES ];

	OSXEventRoutine(window_info->windowClassRef, EventResize, window_info->viewVars->nsRect.size.width, window_info->viewVars->nsRect.size.height);

//	printf("OBJ-C: done with drawRect\n");
}

- (void)mouseDown:(NSEvent*)event {
	[ self OSX_HandleEvent:event ];
}

- (void)rightMouseDown:(NSEvent*)event {
	[ self OSX_HandleEvent:event ];
}

- (void)otherMouseDown:(NSEvent*)event {
	[ self OSX_HandleEvent:event ];
}

- (void)mouseUp:(NSEvent*)event {
	[ self OSX_HandleEvent:event ];
}

- (void)rightMouseUp:(NSEvent*)event {
	[ self OSX_HandleEvent:event ];
}

- (void)otherMouseUp:(NSEvent*)event {
	[ self OSX_HandleEvent:event ];
}

- (void)mouseMoved:(NSEvent*)event {
	printf("hey\n");
	[ self OSX_HandleEvent:event ];
}

- (void)mouseDragged:(NSEvent*)event {
	printf("hey!!!!!!!!!\n");
	[ self OSX_HandleEvent:event ];
}

- (void)OSX_HandleEvent:(NSEvent*)event {
	NSPoint coord;

	switch ( [ event type ] ) {

	case NSLeftMouseDown:
	case NSRightMouseDown:
	case NSOtherMouseDown:

		coord = [ window_info->viewVars->viewRef convertPoint:[ event locationInWindow ] fromView: nil ];

		int xysend;
		xysend = coord.x;
		xysend |= ((int)coord.y << 16);

		switch ( [ event buttonNumber ] ) {
			case 0:
				OSXEventRoutine(window_info->windowClassRef, EventPrimaryDown, xysend, [ event clickCount ] );
				break;
			case 1:
				OSXEventRoutine(window_info->windowClassRef, EventSecondaryDown, xysend, [ event clickCount ] );
				break;
			case 2:
				OSXEventRoutine(window_info->windowClassRef, EventTertiaryDown, xysend, [ event clickCount ] );
				break;
			default:
				OSXEventRoutine(window_info->windowClassRef, EventOtherDown + ( [ event buttonNumber ] - 3 ), xysend, [ event clickCount ] );
				break;
		}

		break;

	case NSLeftMouseUp:
	case NSRightMouseUp:
	case NSOtherMouseUp:

		coord = [ window_info->viewVars->viewRef convertPoint:[ event locationInWindow ] fromView: nil ];

		int xysendup;
		xysendup = coord.x;
		xysendup |= ((int)coord.y << 16);

		switch ( [ event buttonNumber ] ) {
			case 0:
				OSXEventRoutine(window_info->windowClassRef, EventPrimaryUp, xysendup, [ event clickCount ] );
				break;
			case 1:
				OSXEventRoutine(window_info->windowClassRef, EventSecondaryUp, xysendup, [ event clickCount ] );
				break;
			case 2:
				OSXEventRoutine(window_info->windowClassRef, EventTertiaryUp, xysendup, [ event clickCount ] );
				break;
			default:
				OSXEventRoutine(window_info->windowClassRef, EventOtherUp + ( [ event buttonNumber ] - 3 ), xysendup, [ event clickCount ] );
				break;
		}

		break;

	case NSMouseMoved:
	case NSLeftMouseDragged:
	case NSRightMouseDragged:
	case NSOtherMouseDragged:

		coord = [ window_info->viewVars->viewRef convertPoint:[ event locationInWindow ] fromView: nil ];

		int xysendmove;
		xysendmove = coord.x;
		xysendmove |= ((int)coord.y << 16);

		OSXEventRoutine(window_info->windowClassRef, EventMouseMove, xysendmove, [ event clickCount ] );

		break;
	}
}


// FOCUS //

//- (void)windowDidBecomeKey:(NSNotification *)notification {
	/*// control receives focus due to window

	//fire event
	FIRE_WINDOW_EVENT(window, EventGotFocus, 0, 0);

	//currently focused control will regain focus
	//all controls receive message ???

	_internal_file_event_GotFocus(window);*/

	//return;
//}

- (void)windowDidResignKey:(NSNotification *)notification {
	/*// control loses focus due to window

	//fire event
	FIRE_WINDOW_EVENT(window, EventLostFocus, 0, 0);

	//currently focused control will regain focus
	//all controls receive message ???

	_internal_file_event_LostFocus(window);*/
}

// ACTION MESSAGES //

-(void)_osx_redraw {
	//Scaffold.RequestRedraw(window_info);
}

// TIMERS //

- (void)tick:(NSTimer*)timer {
	/*NSValue* val = (NSValue*)[ timer userInfo ];

	void* ptr_val = [ val pointerValue ];

	_internal_timer_info* tmr_info = (_internal_timer_info*)ptr_val;

	_internal_file_event_Timer(window, tmr_info);*/
}


@end







void _OSXWindowShow(struct _OSXWindowPlatformVars* window, int bShow) {
	NSWindow* wnd = window->windowRef;

	if (bShow) {
	printf("windowshow\n");
		[ wnd update ];
		[ wnd makeKeyAndOrderFront: nil ]; // displays
	} else {
	printf("windowhide\n");
		[ wnd orderOut: nil ]; // hides
	}
}

void _OSXWindowSetTitle(struct _OSXWindowPlatformVars* window, char* str) {
	NSString* nss = [[NSString alloc] initWithUTF8String: str];
    [window->windowRef setTitle: nss];
}

struct _OSXViewPlatformVars* _OSXWindowCreate(void* windowRef, struct _OSXWindowPlatformVars* parent, struct _OSXWindowPlatformVars** window, char* initTitle, int initX, int initY, int initW, int initH) {
	printf("WindowCreate\n");

    // initialize the rectangle variable
	NSRect graphicsRect = NSMakeRect(initX,initY,initW,initH); //window->_initial_x,window->_initial_y,window->_initial_width,window->_initial_height);

	(*window) = malloc( sizeof( struct _OSXWindowPlatformVars ) );
	(*window)->viewVars = malloc( sizeof( struct _OSXViewPlatformVars) );

	(*window)->windowClassRef = windowRef;

	(*window)->viewVars->layout = [[NSLayoutManager alloc] init];

	(*window)->viewVars->container = [[NSTextContainer alloc] init];

	[ (*window)->viewVars->layout addTextContainer: (*window)->viewVars->container ];

	(*window)->viewVars->cur_font = [ [ NSMutableDictionary alloc ] init ];

	(*window)->viewVars->txtstore = [ [ NSTextStorage alloc ] init ];

	[ (*window)->viewVars->txtstore addLayoutManager:(*window)->viewVars->layout ];

		printf("Creating View for Window '%s'... %dx%d at %dx%d\n", initTitle, initW, initH, initX, initY);

    (*window)->viewVars->viewRef = [[[_OSXView alloc] initWithFrame:graphicsRect] autorelease];

	(*window)->viewVars->viewRef->window_info = *window;

	// the view is responsible for the rest of the setup

		printf("Creating Window '%s'...\n", initTitle);

	(*window)->windowRef = (*window)->viewVars->viewRef->window = [ [_OSXWindow alloc]              // create the window
               initWithContentRect: graphicsRect
                         styleMask:NSTitledWindowMask
                                  |NSClosableWindowMask
                                  |NSMiniaturizableWindowMask
                           backing:NSBackingStoreBuffered
                             defer:YES ];

		printf("Setting Window Title to '%s'...\n", initTitle);

	_OSXWindowSetTitle(*window, initTitle);

	[ (*window)->windowRef setAcceptsMouseMovedEvents:YES ];
    [ (*window)->windowRef setContentView:(NSView*)(*window)->viewVars->viewRef ];    // set window's view
	[ (*window)->windowRef setDelegate: (*window)->viewVars->viewRef ];
	[ (*window)->windowRef makeFirstResponder: (*window)->viewVars->viewRef ];

	return (*window)->viewVars;
}

void _OSXWindowStartDraw(struct _OSXWindowPlatformVars* windVars, struct _OSXViewPlatformVars* viewVars, int isSysColorWindow, double r, double g, double b) {
	// This stops it from painting upside down (for some reason)
	[ viewVars->viewRef setNeedsDisplay:YES ];

	// StartDraw

//	printf("start draw (OBJ-C)\n");

	//Fill the background of the window with the window color
	if (!isSysColorWindow) {
		NSColor* clr;

		clr = [ NSColor colorWithDeviceRed:r green:g blue:b alpha:1.0f ];

		[ clr set ];
		NSRectFill(viewVars->nsRect);
	}
//	printf("start draw (OBJ-C)\n");

	[ [ NSGraphicsContext currentContext ] setShouldAntialias:YES ];
//	printf("start draw (OBJ-C)\n");

	//Get the CGContextRef
	viewVars->cgContext = (CGContextRef)[[NSGraphicsContext currentContext] graphicsPort];
//	printf("start draw (OBJ-C)\n");

	//Set default colors
	[ [ NSColor blackColor ] setStroke ];
//	printf("start draw (OBJ-C)\n");
	[ [ NSColor whiteColor ] setFill ];

//	printf("start draw done\n");
}
