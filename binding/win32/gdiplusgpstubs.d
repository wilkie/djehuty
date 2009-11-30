/*
 * gdiplusgpstubs.d
 *
 * This module binds GdiPlusGpStubs.h to D. The original copyright
 * notice is preserved below.
 *
 * Author: Dave Wilkinson
 * Originated: November 25th, 2009
 *
 */

module binding.win32.gdiplusgpstubs;

import binding.win32.windef;
import binding.win32.winbase;
import binding.win32.winnt;
import binding.win32.wingdi;
import binding.win32.guiddef;
import binding.win32.gdiplusmem;
import binding.win32.gdiplustypes;
import binding.win32.gdiplusenums;
import binding.win32.gdiplusmetaheader;
import binding.win32.gdipluspixelformats;
import binding.win32.gdipluscolor;
import binding.win32.gdipluscolormatrix;

/**************************************************************************\
*
* Copyright (c) 1998-2001, Microsoft Corp.  All Rights Reserved.
*
* Module Name:
*
*   GdiplusGpStubs.h
*
* Abstract:
*
*   Private GDI+ header file.
*
\**************************************************************************/

//---------------------------------------------------------------------------
// Private GDI+ interfacees for internal type checking
//---------------------------------------------------------------------------
struct GpGraphics {};

struct GpBrush {};

alias GpBrush GpTexture;
alias GpBrush GpSolidFill;
alias GpBrush GpLineGradient;
alias GpBrush GpPathGradient;
alias GpBrush GpHatch;

struct GpPen {};
struct GpCustomLineCap {};

alias GpCustomLineCap GpAdjustableArrowCap;

struct GpImage {};
struct GpImageAttributes {};

alias GpImage GpBitmap;
alias GpImage GpMetafile;

struct GpPath {};
struct GpRegion {};
struct GpPathIterator {};

struct GpFontFamily {};
struct GpFont {};
struct GpStringFormat {};
struct GpFontCollection {};
alias GpFontCollection GpInstalledFontCollection;
alias GpFontCollection GpPrivateFontCollection;

struct GpCachedBitmap {};

alias Status GpStatus;
alias FillMode GpFillMode;
alias WrapMode GpWrapMode;
alias Unit GpUnit;
alias CoordinateSpace GpCoordinateSpace;
alias PointF GpPointF;
alias Point GpPoint;
alias RectF GpRectF;
alias Rect GpRect;
alias SizeF GpSizeF;
alias HatchStyle GpHatchStyle;
alias DashStyle GpDashStyle;
alias LineCap GpLineCap;
alias DashCap GpDashCap;

alias PenAlignment GpPenAlignment;

alias LineJoin GpLineJoin;
alias PenType GpPenType;

alias HANDLE GpMatrix;
alias BrushType GpBrushType;
alias MatrixOrder GpMatrixOrder;
alias FlushIntention GpFlushIntention;
alias PathData GpPathData;
