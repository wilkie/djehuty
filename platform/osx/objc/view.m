#include <Cocoa/Cocoa.h>
#include <Foundation/Foundation.h>

#include "OSXView.h"

void _OSXViewCreate(struct _OSXViewPlatformVars** viewVars, int width, int height)
{
	(*viewVars) = malloc (sizeof(struct _OSXViewPlatformVars));

	(*viewVars)->dib_image = [ [ [ NSImage alloc ] initWithSize:NSMakeSize(width, height) ] retain ];
}

void _OSXViewCreateDIB(struct _OSXViewPlatformVars** viewVars, int width, int height)
{
	(*viewVars) = malloc (sizeof(struct _OSXViewPlatformVars));

	(*viewVars)->dib_image_rep = [ [ [ NSBitmapImageRep alloc ] initWithBitmapDataPlanes:nil
		pixelsWide:width pixelsHigh:height bitsPerSample:8 samplesPerPixel:4
		hasAlpha:YES isPlanar:NO colorSpaceName:NSCalibratedRGBColorSpace
		bitmapFormat:NSAlphaNonpremultipliedBitmapFormat bytesPerRow:(width*4) bitsPerPixel:32 ] retain ];

	(*viewVars)->dib_image = [ [ NSImage alloc ] retain ];
	[ (*viewVars)->dib_image addRepresentation: (*viewVars)->dib_image_rep ];

	[ (*viewVars)->dib_image setFlipped:YES ];
}

void _OSXViewDestroy(struct _OSXViewPlatformVars* viewVars, int isDIB, int isWindow)
{
	if (isDIB)
	{
		[ viewVars->dib_image_rep release ];
		[ viewVars->dib_image release ];
	}
	else if (!isWindow)
	{
		[ viewVars->dib_image release ];
	}

	free(viewVars);
}

void* _OSXGetBytes(struct _OSXViewPlatformVars* viewVars)
{
	return [ viewVars->dib_image_rep bitmapData ];
}



// --- Graphics --- //

void _OSXUsePen(struct _OSXViewPlatformVars* viewVars, int fromWindow, void* pen)
{
	if (!fromWindow)
	{
		[ viewVars->dib_image lockFocus ];
	}

	[ ((NSColor*)pen) setStroke ];

	if (!fromWindow)
	{
		[ viewVars->dib_image unlockFocus ];
	}
}

void _OSXCreatePen(struct _OSXViewPlatformVars* viewVars, int fromWindow, void** pen, int r, int g, int b, int a)
{
	NSColor* nsclr = [ [ NSColor colorWithDeviceRed:((float)r / 255) green:((float)g / 255) blue:((float)b / 255) alpha:((float)a / 255) ] retain ];

	(*pen) = (void*)nsclr;
}

void _OSXDestroyPen(struct _OSXViewPlatformVars* viewVars, int fromWindow, void* pen)
{
	[ (NSColor*)pen release ];
}


void _OSXUseBrush(struct _OSXViewPlatformVars* viewVars, int fromWindow, void* brush)
{
	if (!fromWindow)
	{
		[ viewVars->dib_image lockFocus ];
	}

	[ ((NSColor*)brush) setFill ];

	if (!fromWindow)
	{
		[ viewVars->dib_image unlockFocus ];
	}
}

void _OSXCreateBrush(struct _OSXViewPlatformVars* viewVars, int fromWindow, void** brush, int r, int g, int b, int a)
{
	NSColor* nsclr = [ [ NSColor colorWithDeviceRed:((float)r / 255) green:((float)g / 255) blue:((float)b / 255) alpha:((float)a / 255) ] retain ];

	(*brush) = (void*)nsclr;
}

void _OSXDestroyBrush(struct _OSXViewPlatformVars* viewVars, int fromWindow, void* brush)
{
	[ (NSColor*)brush release ];
}




//  Shapes  //

void _OSXDrawLine(struct _OSXViewPlatformVars* viewVars, int fromWindow, int x, int y, int x2, int y2)
{
	if (!fromWindow)
	{
		[ viewVars->dib_image lockFocus ];
		[ NSBezierPath strokeLineFromPoint:NSMakePoint((x),(y)) toPoint:NSMakePoint((x2),(y2)) ];
		[ viewVars->dib_image unlockFocus ];
	}
	else
	{
		[ NSBezierPath strokeLineFromPoint:NSMakePoint((x),(y)) toPoint:NSMakePoint((x2),(y2)) ];
	}
}

void _OSXDrawRect(struct _OSXViewPlatformVars* viewVars, int fromWindow, int x, int y, int x2, int y2)
{
	if (!fromWindow)
	{
		[ viewVars->dib_image lockFocus ];
		NSRectFill(NSMakeRect((x),(y),(x2)-(x),(y2)-(y)));
		[ [ NSBezierPath bezierPathWithRect:NSMakeRect((x),(y),(x2)-(x),(y2)-(y)) ] stroke ];
		[ viewVars->dib_image unlockFocus ];
	}
	else
	{
		NSRectFill(NSMakeRect((x),(y),(x2)-(x),(y2)-(y)));
		[ [ NSBezierPath bezierPathWithRect:NSMakeRect((x),(y),(x2)-(x),(y2)-(y)) ] stroke ];
	}
}

void _OSXDrawOval(struct _OSXViewPlatformVars* viewVars, int fromWindow, int x, int y, int x2, int y2)
{
	if (!fromWindow)
	{
		[ viewVars->dib_image lockFocus ];
		[ [ NSBezierPath bezierPathWithOvalInRect:NSMakeRect((x),(y),(x2)-(x),(y2)-(y)) ] fill ];
		[ [ NSBezierPath bezierPathWithOvalInRect:NSMakeRect((x),(y),(x2)-(x),(y2)-(y)) ] stroke ];
		[ viewVars->dib_image unlockFocus ];
	}
	else
	{
		[ [ NSBezierPath bezierPathWithOvalInRect:NSMakeRect((x),(y),(x2)-(x),(y2)-(y)) ] fill ];
		[ [ NSBezierPath bezierPathWithOvalInRect:NSMakeRect((x),(y),(x2)-(x),(y2)-(y)) ] stroke ];
	}
}





// Text //

void _OSXDrawText(struct _OSXViewPlatformVars* viewVars, int fromWindow, int x, int y, char* str)
{
	if (!fromWindow)
	{
		[ viewVars->dib_image lockFocus ];
	}

	NSString* nss = [ [ NSString alloc ] initWithUTF8String:str ];

	[ viewVars->txtstore setAttributedString: [ [ NSAttributedString alloc ] initWithString: nss attributes:viewVars->cur_font ] ] ;

	NSRange glyphs = [ viewVars->layout glyphRangeForTextContainer: viewVars->container ];

	[ [ NSGraphicsContext currentContext ] setShouldAntialias:YES ];
	[ viewVars->layout drawGlyphsForGlyphRange:glyphs atPoint: NSMakePoint(x-5,y) ];
	[ [ NSGraphicsContext currentContext ] setShouldAntialias:NO ];

	if (!fromWindow)
	{
		[ viewVars->dib_image unlockFocus ];
	}
}

void _OSXMeasureText(struct _OSXViewPlatformVars* viewVars, int fromWindow, char* str, unsigned int* w, unsigned int* h)
{
	if (!fromWindow)
	{
		[ viewVars->dib_image lockFocus ];
	}

	NSString* nss = [ [ NSString alloc ] initWithUTF8String:str ];

	[ viewVars->txtstore setAttributedString: [ [ NSAttributedString alloc ] initWithString: nss attributes:viewVars->cur_font ] ] ;

	NSRange glyphs = [ viewVars->layout glyphRangeForTextContainer: viewVars->container ];

	NSRect nrect = [ viewVars->layout boundingRectForGlyphRange:glyphs inTextContainer: viewVars->container ];

	(*w) = (unsigned int)nrect.size.width;
	(*h) = (unsigned int)nrect.size.height;

	if (!fromWindow)
	{
		[ viewVars->dib_image unlockFocus ];
	}
}

void _OSXDrawViewXY(struct _OSXViewPlatformVars* viewVars, int fromWindow, struct _OSXViewPlatformVars* srcViewVars, int srcFromWindow, int x, int y, int srcX, int srcY)
{
	if (!fromWindow)
	{
		[ viewVars->dib_image lockFocus ];
	}

	if (!srcFromWindow)
	{
		[ srcViewVars->dib_image drawAtPoint:NSMakePoint(x, y) fromRect:NSZeroRect operation:NSCompositeSourceOver  fraction:1.0f ];
	}

	if (!fromWindow)
	{
		[ viewVars->dib_image unlockFocus ];
	}
}

void _OSXDrawViewXYXYWH(struct _OSXViewPlatformVars* viewVars, int fromWindow, struct _OSXViewPlatformVars* srcViewVars, int srcFromWindow, int x, int y, int srcX, int srcY, int srcWidth, int srcHeight)
{

	if (!fromWindow)
	{
		[ viewVars->dib_image lockFocus ];
	}

	if (!srcFromWindow)
	{
		[ viewVars->dib_image drawInRect:NSMakeRect(x, y, srcWidth, srcHeight) fromRect:NSMakeRect(srcX, srcY, srcWidth, srcHeight) operation:NSCompositeSourceOver fraction:1.0f ];
	}

	if (!fromWindow)
	{
		[ viewVars->dib_image unlockFocus ];
	}
}

void _OSXDrawViewXYA(struct _OSXViewPlatformVars* viewVars, int fromWindow, struct _OSXViewPlatformVars* srcViewVars, int srcFromWindow, int x, int y, int srcX, int srcY, float opacity)
{
	if (!fromWindow)
	{
		[ viewVars->dib_image lockFocus ];
	}

	if (!srcFromWindow)
	{
		[ srcViewVars->dib_image drawAtPoint:NSMakePoint(x, y) fromRect:NSZeroRect operation:NSCompositeSourceOver  fraction: opacity ];
	}

	if (!fromWindow)
	{
		[ viewVars->dib_image unlockFocus ];
	}
}

void _OSXDrawViewXYXYWHA(struct _OSXViewPlatformVars* viewVars, int fromWindow, struct _OSXViewPlatformVars* srcViewVars, int srcFromWindow, int x, int y, int srcX, int srcY, int srcWidth, int srcHeight, float opacity)
{

	if (!fromWindow)
	{
		[ viewVars->dib_image lockFocus ];
	}

	if (!srcFromWindow)
	{
		[ viewVars->dib_image drawInRect:NSMakeRect(x, y, srcWidth, srcHeight) fromRect:NSMakeRect(srcX, srcY, srcWidth, srcHeight) operation:NSCompositeSourceOver fraction: opacity ];
	}

	if (!fromWindow)
	{
		[ viewVars->dib_image unlockFocus ];
	}
}
