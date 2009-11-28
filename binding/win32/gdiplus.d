/*
 * gdiplus.d
 *
 * This module binds GdiPlus for windows applications using GDI+.
 * The original header file is gdiplus.h with the original copyright
 * information preserved at the top of this file.
 *
 * Author: Dave Wilkinson
 * Originated: November 24th, 2009
 *
 */

module binding.win32.gdiplus;

// The original copyright notice from gdiplus.h from which this module is based.

/**************************************************************************\
*
* Copyright (c) 1998-2001, Microsoft Corp.  All Rights Reserved.
*
* Module Name:
*
*   Gdiplus.h
*
* Abstract:
*
*   GDI+ public header file
*
\**************************************************************************/

public import binding.win32.gdiplusmem;
public import binding.win32.gdiplusbase;
public import binding.win32.gdiplusenums;
public import binding.win32.gdiplustypes;
public import binding.win32.gdiplusinit;
public import binding.win32.gdipluspixelformats;
public import binding.win32.gdipluscolor;
public import binding.win32.gdiplusmetaheader;
public import binding.win32.gdiplusimaging;
public import binding.win32.gdipluscolormatrix;
public import binding.win32.gdipluseffects;
public import binding.win32.gdiplusgpstubs;

public import binding.win32.gdiplusflat;

public import binding.win32.gdiplusimageattributes;
public import binding.win32.gdiplusmatrix;
public import binding.win32.gdiplusbrush;
public import binding.win32.gdipluspen;
public import binding.win32.gdiplusstringformat;
public import binding.win32.gdipluspath;
public import binding.win32.gdipluslinecaps;
public import binding.win32.gdiplusmetafile;
public import binding.win32.gdiplusgraphics;
public import binding.win32.gdipluscachedbitmap;
public import binding.win32.gdiplusregion;
public import binding.win32.gdiplusfontcollection;
public import binding.win32.gdiplusfontfamily;
public import binding.win32.gdiplusfont;
public import binding.win32.gdiplusbitmap;
public import binding.win32.gdiplusimagecodec;
