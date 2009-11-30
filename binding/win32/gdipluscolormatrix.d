/*
 * gdipluscolormatrix.d
 *
 * This module implements GdiPlusColorMatrix.h for D. The original copyright
 * info is given below.
 *
 * Author: Dave Wilkinson
 * Originated: November 25th, 2009
 *
 */

module binding.win32.gdipluscolormatrix;

import binding.win32.windef;
import binding.win32.winbase;
import binding.win32.winnt;
import binding.win32.guiddef;
import binding.win32.gdipluscolor;
import binding.win32.gdiplusimaging;
import binding.win32.gdiplustypes;
import binding.win32.gdiplusenums;
import binding.win32.gdipluspixelformats;

/**************************************************************************\
*
* Copyright (c) 1998-2001, Microsoft Corp.  All Rights Reserved.
*
* Module Name:
*
*   GdiplusColorMatrix.h
*
* Abstract:
*
*  GDI+ Color Matrix object, used with Graphics.DrawImage
*
\**************************************************************************/

extern(System):

//----------------------------------------------------------------------------
// Color channel look up table (LUT)
//----------------------------------------------------------------------------

alias BYTE[256] ColorChannelLUT;

//----------------------------------------------------------------------------
// Per-channel Histogram for 8bpp images.
//----------------------------------------------------------------------------

enum HistogramFormat {
    HistogramFormatARGB,
    HistogramFormatPARGB,
    HistogramFormatRGB,
    HistogramFormatGray,
    HistogramFormatB,
    HistogramFormatG,
    HistogramFormatR,
    HistogramFormatA
}

//----------------------------------------------------------------------------
// Color matrix
//----------------------------------------------------------------------------

struct ColorMatrix {
    REAL m[5][5] = [[1,0,0,0,0], [0,1,0,0,0], [0,0,1,0,0], [0,0,0,1,0], [0,0,0,0,1]];
}

//----------------------------------------------------------------------------
// Color Matrix flags
//----------------------------------------------------------------------------

enum ColorMatrixFlags {
    ColorMatrixFlagsDefault   = 0,
    ColorMatrixFlagsSkipGrays = 1,
    ColorMatrixFlagsAltGray   = 2
}

//----------------------------------------------------------------------------
// Color Adjust Type
//----------------------------------------------------------------------------

enum ColorAdjustType {
    ColorAdjustTypeDefault,
    ColorAdjustTypeBitmap,
    ColorAdjustTypeBrush,
    ColorAdjustTypePen,
    ColorAdjustTypeText,
    ColorAdjustTypeCount,
    ColorAdjustTypeAny      // Reserved
}

//----------------------------------------------------------------------------
// Color Map
//----------------------------------------------------------------------------

struct ColorMap {
    Color oldColor;
    Color newColor;
}
