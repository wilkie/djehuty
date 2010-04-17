#include <Cocoa/Cocoa.h>
#include <Foundation/Foundation.h>

@interface _OSXApp : NSApplication {
}
@end

@implementation _OSXApp {
}
/*
-(void)sendEvent:(NSEvent*)event
{
	printf("event %d\n", [ event type ]);
	[ super sendEvent:event ];
} //*/
/*
-(BOOL)tryToPerform:(SEL)sel with:(id)obj
{
	printf("perform\n");
	return [ super tryToPerform:sel with:obj ];
}//*/
@end

NSAutoreleasePool* pool;

NSArray* fntKeys;

void _OSXStart() {
	fntKeys = [ [NSArray alloc ] initWithObjects:
			NSFontAttributeName,
			NSUnderlineStyleAttributeName,
			nil ] ;

	pool = [ [ NSAutoreleasePool alloc ] init ];

printf("start\n");
	NSApp = [_OSXApp sharedApplication];
}

void _OSXLoop() {
	// run the main event loop
	printf("Loop\n");
    [ NSApp run ];
}

void _OSXEnd() {
	[ NSApp release ];

	[ pool release ];
}
