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

extern(System) struct IDirectDrawSurface7;

public import binding.win32.gdiplusbase;
public import binding.win32.gdiplusenums;