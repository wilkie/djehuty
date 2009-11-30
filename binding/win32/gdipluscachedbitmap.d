/*
 * gdipluscachedbitmap.d
 *
 * This module implements GdiPlusCachedBitmap.h for D. The original
 * copyright info is given below.
 *
 * Author: Dave Wilkinson
 * Originated: November 25th, 2009
 *
 */

module binding.win32.gdipluscachedbitmap;

import binding.win32.windef;
import binding.win32.winbase;
import binding.win32.winnt;
import binding.win32.wingdi;
import binding.win32.guiddef;
import binding.win32.gdiplusbase;
import binding.win32.gdiplustypes;
import binding.win32.gdiplusenums;
import binding.win32.gdipluspixelformats;
import binding.win32.gdiplusgpstubs;
import binding.win32.gdiplusmetaheader;
import binding.win32.gdipluspixelformats;
import binding.win32.gdipluscolor;
import binding.win32.gdipluscolormatrix;
import binding.win32.gdiplusflat;
import binding.win32.gdiplusimaging;
import binding.win32.gdiplusbitmap;
import binding.win32.gdiplusimageattributes;
import binding.win32.gdiplusmatrix;
import binding.win32.gdiplusgraphics;

/**************************************************************************
*
* Copyright (c) 2000 Microsoft Corporation
*
* Module Name:
*
*   CachedBitmap class definition
*
* Abstract:
*
*   GDI+ CachedBitmap is a representation of an accelerated drawing
*   that has restrictions on what operations are allowed in order
*   to accelerate the drawing to the destination.
*
*   Look for class definition in GdiplusHeaders.h
*
**************************************************************************/

class CachedBitmap : GdiplusBase {
    this(in Bitmap bitmap, in Graphics graphics) {
        nativeCachedBitmap = null;    
    
        lastResult = GdipCreateCachedBitmap(
            bitmap.nativeImage,
            graphics.nativeGraphics,
            &nativeCachedBitmap
        );
    }
    
    ~this() {
        GdipDeleteCachedBitmap(nativeCachedBitmap);
    }

    Status GetLastStatus() {
        Status lastStatus = lastResult;
        lastResult = Status.Ok;    
        return (lastStatus);
    }

protected:
    package GpCachedBitmap *nativeCachedBitmap;
    package Status lastResult;
}

