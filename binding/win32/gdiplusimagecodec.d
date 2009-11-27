/*
 * gdiplusimagecodec.d
 *
 * This module implements GdiPlusImageCodec.h for D. The original
 * copyright info is given below.
 *
 * Author: Dave Wilkinson
 * Originated: November 25th, 2009
 *
 */

module binding.win32.gdiplusimagecodec;

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

/**************************************************************************\
*
* Copyright (c) 2000-2001, Microsoft Corp.  All Rights Reserved.
*
* Module Name:
*
*   GdiplusImageCodec.h
*
* Abstract:
*
*   GDI+ Codec Image APIs
*
\**************************************************************************/

#ifndef _GDIPLUSIMAGECODEC_H
#define _GDIPLUSIMAGECODEC_H

//--------------------------------------------------------------------------
// Codec Management APIs
//--------------------------------------------------------------------------

inline Status 
GetImageDecodersSize(
    OUT UINT *numDecoders,
    OUT UINT *size)
{
    return DllExports::GdipGetImageDecodersSize(numDecoders, size);
}


inline Status 
GetImageDecoders(
    IN UINT numDecoders,
    IN UINT size,
    OUT ImageCodecInfo *decoders)
{
    return DllExports::GdipGetImageDecoders(numDecoders, size, decoders);
}


inline Status 
GetImageEncodersSize(
    OUT UINT *numEncoders, 
    OUT UINT *size)
{
    return DllExports::GdipGetImageEncodersSize(numEncoders, size);
}


inline Status 
GetImageEncoders(
    IN UINT numEncoders,
    IN UINT size,
    OUT ImageCodecInfo *encoders)
{
    return DllExports::GdipGetImageEncoders(numEncoders, size, encoders);
}

#endif  // _GDIPLUSIMAGECODEC_H

