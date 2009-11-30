/*
 * gdiplustypes.d
 *
 * This module binds GdiPlusTypes.h to D. The original copyright
 * notice is preserved below.
 *
 * Author: Dave Wilkinson
 * Originated: November 25th, 2009
 *
 */

module binding.win32.gdiplustypes;

import binding.win32.windef;
import binding.win32.winbase;
import binding.win32.winnt;

import binding.win32.gdiplusenums;

extern(System):

/**************************************************************************\
*
* Copyright (c) 1998-2001, Microsoft Corp.  All Rights Reserved.
*
* Module Name:
*
*   GdiplusTypes.hco
*
* Abstract:
*
*   GDI+ Types
*
\**************************************************************************/

extern(System) struct IDirectDrawSurface7;

//--------------------------------------------------------------------------
// Callback functions
//--------------------------------------------------------------------------

alias BOOL function(VOID*) ImageAbort;
alias ImageAbort DrawImageAbort;
alias ImageAbort GetThumbnailImageAbort;

// Callback for EnumerateMetafile methods.  The parameters are:

//      recordType      WMF, EMF, or EMF+ record type
//      flags           (always 0 for WMF/EMF records)
//      dataSize        size of the record data (in bytes), or 0 if no data
//      data            pointer to the record data, or NULL if no data
//      callbackData    pointer to callbackData, if any

// This method can then call Metafile::PlayRecord to play the
// record that was just enumerated.  If this method  returns
// FALSE, the enumeration process is aborted.  Otherwise, it continues.

alias BOOL function(EmfPlusRecordType, UINT, UINT, BYTE*, VOID*) EnumerateMetafileProc;

// This is the main GDI+ Abort interface

extern(C++) interface GdiplusAbort {
    HRESULT Abort();
}

//--------------------------------------------------------------------------
// Primitive data types
//
// NOTE:
//  Types already defined in standard header files:
//      INT8
//      UINT8
//      INT16
//      UINT16
//      INT32
//      UINT32
//      INT64
//      UINT64
//
//  Avoid using the following types:
//      LONG - use INT
//      ULONG - use UINT
//      DWORD - use UINT32
//--------------------------------------------------------------------------

alias float REAL;

const auto REAL_MAX            = REAL.max;
const auto REAL_MIN            = REAL.min;
const auto REAL_TOLERANCE      = (REAL.min * 100);
const auto REAL_EPSILON        = 1.192092896e-07F;        /* FLT_EPSILON */

//--------------------------------------------------------------------------
// Status return values from GDI+ methods
//--------------------------------------------------------------------------

enum Status {
    Ok = 0,
    GenericError = 1,
    InvalidParameter = 2,
    OutOfMemory = 3,
    ObjectBusy = 4,
    InsufficientBuffer = 5,
    NotImplemented = 6,
    Win32Error = 7,
    WrongState = 8,
    Aborted = 9,
    FileNotFound = 10,
    ValueOverflow = 11,
    AccessDenied = 12,
    UnknownImageFormat = 13,
    FontFamilyNotFound = 14,
    FontStyleNotFound = 15,
    NotTrueTypeFont = 16,
    UnsupportedGdiplusVersion = 17,
    GdiplusNotInitialized = 18,
    PropertyNotFound = 19,
    PropertyNotSupported = 20,

    ProfileNotFound = 21,
}

//--------------------------------------------------------------------------
// Represents a dimension in a 2D coordinate system (floating-point coordinates)
//--------------------------------------------------------------------------

struct SizeF {
public:
	SizeF init(SizeF size) {
		SizeF ret;
		ret.Width = size.Width;
		ret.Height = size.Height;
		return ret;
	}

	SizeF init(REAL width, REAL height) {
		SizeF ret;
		ret.Width = width;
		ret.Height = height;
		return ret;
	}

	SizeF opAdd(SizeF sz) {
		return SizeF(Width + sz.Width, Height + sz.Height);
	}

	SizeF opSub(SizeF sz) {
		return SizeF(Width - sz.Width, Height - sz.Height);
	}

    BOOL Equals(SizeF sz) {
        return (Width == sz.Width) && (Height == sz.Height);
    }

    BOOL Empty() {
        return (Width == 0.0f && Height == 0.0f);
    }

    REAL Width = 0.0f;
    REAL Height = 0.0f;
}

//--------------------------------------------------------------------------
// Represents a dimension in a 2D coordinate system (integer coordinates)
//--------------------------------------------------------------------------

struct Size {
public:
    static Size init(Size size) {
    	Size ret;
        ret.Width = size.Width;
        ret.Height = size.Height;
        return ret;
    }

    static Size init(INT width, INT height) {
    	Size ret;
        ret.Width = width;
        ret.Height = height;
        return ret;
    }

    Size opAdd(Size sz) {
        return Size(Width + sz.Width, Height + sz.Height);
    }

    Size opSub(Size sz) {
        return Size(Width - sz.Width,
                    Height - sz.Height);
    }

    BOOL Equals(Size sz)  {
        return (Width == sz.Width) && (Height == sz.Height);
    }

    BOOL Empty() {
        return (Width == 0 && Height == 0);
    }

    INT Width;
    INT Height;
}


//--------------------------------------------------------------------------
// Represents a location in a 2D coordinate system (floating-point coordinates)
//--------------------------------------------------------------------------

struct PointF {
public:
	static PointF init(ref PointF point) {
		PointF ret;
		ret.X = point.X;
		ret.Y = point.Y;
		return ret;
	}

	static PointF init(ref SizeF size) {
		PointF ret;
		ret.X = size.Width;
		ret.Y = size.Height;
		return ret;
	}

	static PointF init(REAL x, REAL y)  {
		PointF ret;
	    ret.X = x;
	    ret.Y = y;
	    return ret;
	}

	PointF opAdd(ref PointF point) {
	    return PointF(X + point.X, Y + point.Y);
	}

	PointF opSub(ref PointF point) {
	    return PointF(X - point.X, Y - point.Y);
	}

	BOOL Equals(ref PointF point) {
	    return (X == point.X) && (Y == point.Y);
	}

    REAL X;
    REAL Y;
}

//--------------------------------------------------------------------------
// Represents a location in a 2D coordinate system (integer coordinates)
//--------------------------------------------------------------------------

struct Point {
public:

	static Point init(in Point point) {
		Point ret;
	    ret.X = point.X;
	    ret.Y = point.Y;
	    return ret;
	}

	static Point init(in Size size) {
		Point ret;
	    ret.X = size.Width;
	    ret.Y = size.Height;
	    return ret;
	}

	Point init(INT x, INT y) {
		Point ret;
	    ret.X = x;
	    ret.Y = y;
	    return ret;
	}

	Point opAdd(in Point point) {
	    return Point(X + point.X, Y + point.Y);
	}

	Point opSub(in Point point) {
	    return Point(X - point.X, Y - point.Y);
	}

	BOOL Equals(in Point point) {
	    return (X == point.X) && (Y == point.Y);
	}

    INT X;
    INT Y;
}

//--------------------------------------------------------------------------
// Represents a rectangle in a 2D coordinate system (floating-point coordinates)
//--------------------------------------------------------------------------

struct RectF {
public:
    static RectF init(REAL x, REAL y, REAL width, REAL height) {
    	RectF ret;
        ret.X = x;
        ret.Y = y;
        ret.Width = width;
        ret.Height = height;
        return ret;
    }

    static RectF init(in PointF location, in SizeF size) {
    	RectF ret;
        ret.X = location.X;
        ret.Y = location.Y;
        ret.Width = size.Width;
        ret.Height = size.Height;
        return ret;
    }

    RectF Clone() {
    	return RectF.init(X, Y, Width, Height);
    }

    alias Clone dup;

    VOID GetLocation(out PointF point) {
    	point.X = X;
    	point.Y = Y;
    }

    VOID GetSize(out SizeF size) {
    	size.Width = Width;
    	size.Height = Height;
    }

    VOID GetBounds(out RectF rect) {
    	rect.X = X;
    	rect.Y = Y;
		rect.Width = Width;
		rect.Height = Height;
    }

    REAL GetLeft() {
        return X;
    }

    REAL GetTop() {
        return Y;
    }

    REAL GetRight() {
        return X+Width;
    }

    REAL GetBottom() {
        return Y+Height;
    }

    BOOL IsEmptyArea() {
        return (Width <= REAL_EPSILON) || (Height <= REAL_EPSILON);
    }

    BOOL Equals(in RectF rect) {
        return X == rect.X &&
               Y == rect.Y &&
               Width == rect.Width &&
               Height == rect.Height;
    }

    BOOL Contains(in REAL x, in REAL y) {
        return x >= X && x < X+Width &&
               y >= Y && y < Y+Height;
    }

    BOOL Contains(in PointF pt) {
        return Contains(pt.X, pt.Y);
    }

    BOOL Contains(in RectF rect) {
        return (X <= rect.X) && (rect.GetRight() <= GetRight()) &&
               (Y <= rect.Y) && (rect.GetBottom() <= GetBottom());
    }

    VOID Inflate(in REAL dx, in REAL dy) {
        X -= dx;
        Y -= dy;
        Width += 2*dx;
        Height += 2*dy;
    }

    VOID Inflate(in PointF point) {
        Inflate(point.X, point.Y);
    }

    BOOL Intersect(in RectF rect) {
        return Intersect(*this, *this, rect);
    }

    static BOOL Intersect(RectF c, in RectF a, in RectF b) {
    	REAL right = ((a.GetRight() < b.GetRight()) ? a.GetRight() : b.GetRight());
//        REAL right = min(a.GetRight(), b.GetRight());
    	REAL bottom = ((a.GetBottom() < b.GetBottom()) ? a.GetBottom() : b.GetBottom());
    	REAL left = ((a.GetLeft() > b.GetLeft()) ? a.GetLeft() : b.GetLeft());
    	REAL top = ((a.GetTop() > b.GetTop()) ? a.GetTop() : b.GetTop());

        c.X = left;
        c.Y = top;
        c.Width = right - left;
        c.Height = bottom - top;
        return !c.IsEmptyArea();
    }

    BOOL IntersectsWith(in RectF rect) {
        return (GetLeft() < rect.GetRight() &&
                GetTop() < rect.GetBottom() &&
                GetRight() > rect.GetLeft() &&
                GetBottom() > rect.GetTop());
    }

    static BOOL Union(out RectF c, in RectF a, in RectF b) {
    	REAL right = ((a.GetRight() > b.GetRight()) ? a.GetRight() : b.GetRight());
    	REAL bottom = ((a.GetBottom() > b.GetBottom()) ? a.GetBottom() : b.GetBottom());
//        REAL right = max(a.GetRight(), b.GetRight());
//        REAL bottom = max(a.GetBottom(), b.GetBottom());
//        REAL left = min(a.GetLeft(), b.GetLeft());
//        REAL top = min(a.GetTop(), b.GetTop());
    	REAL left = ((a.GetLeft() < b.GetLeft()) ? a.GetLeft() : b.GetLeft());
    	REAL top = ((a.GetTop() < b.GetTop()) ? a.GetTop() : b.GetTop());

        c.X = left;
        c.Y = top;
        c.Width = right - left;
        c.Height = bottom - top;
        return !c.IsEmptyArea();
    }

    VOID Offset(in PointF point) {
        Offset(point.X, point.Y);
    }

    VOID Offset(in REAL dx, in REAL dy) {
        X += dx;
        Y += dy;
    }

    REAL X;
    REAL Y;
    REAL Width;
    REAL Height;
}

//--------------------------------------------------------------------------
// Represents a rectangle in a 2D coordinate system (integer coordinates)
//--------------------------------------------------------------------------

struct Rect {
public:

	static Rect init(in INT x, in INT y, in INT width, in INT height) {
		Rect ret;
        ret.X = x;
        ret.Y = y;
        ret.Width = width;
        ret.Height = height;
        return ret;
    }

    static Rect init(in Point location, in Size size) {
    	Rect ret;
        ret.X = location.X;
        ret.Y = location.Y;
        ret.Width = size.Width;
        ret.Height = size.Height;
        return ret;
    }

    Rect Clone() {
        return Rect.init(X, Y, Width, Height);
    }

    alias Clone dup;

    VOID GetLocation(out Point point) {
    	point.X = X;
    	point.Y = Y;
    }

    VOID GetSize(out Size size) {
        size.Width = Width;
        size.Height = Height;
    }

    VOID GetBounds(out Rect rect) {
        rect.X = X;
        rect.Y = Y;
        rect.Width = Width;
        rect.Height = Height;
    }

    INT GetLeft() {
        return X;
    }

    INT GetTop() {
        return Y;
    }

    INT GetRight() {
        return X+Width;
    }

    INT GetBottom() {
        return Y+Height;
    }

    BOOL IsEmptyArea() {
        return (Width <= 0) || (Height <= 0);
    }

    BOOL Equals(in Rect rect) {
        return X == rect.X &&
               Y == rect.Y &&
               Width == rect.Width &&
               Height == rect.Height;
    }

    BOOL Contains(in INT x, in INT y) {
        return x >= X && x < X+Width &&
               y >= Y && y < Y+Height;
    }

    BOOL Contains(in Point pt) {
        return Contains(pt.X, pt.Y);
    }

    BOOL Contains(in Rect rect) {
        return (X <= rect.X) && (rect.GetRight() <= GetRight()) &&
               (Y <= rect.Y) && (rect.GetBottom() <= GetBottom());
    }

    VOID Inflate(in INT dx, in INT dy) {
        X -= dx;
        Y -= dy;
        Width += 2*dx;
        Height += 2*dy;
    }

    VOID Inflate(in Point point) {
        Inflate(point.X, point.Y);
    }

    BOOL Intersect(in Rect rect) {
        return Intersect(*this, *this, rect);
    }

    static BOOL Intersect(out Rect c, in Rect a, in Rect b) {
    	INT right = ((a.GetRight() < b.GetRight()) ? a.GetRight() : b.GetRight());
//        INT right = min(a.GetRight(), b.GetRight());
    	INT bottom = ((a.GetBottom() < b.GetBottom()) ? a.GetBottom() : b.GetBottom());
    	INT left = ((a.GetLeft() > b.GetLeft()) ? a.GetLeft() : b.GetLeft());
    	INT top = ((a.GetTop() > b.GetTop()) ? a.GetTop() : b.GetTop());

        c.X = left;
        c.Y = top;
        c.Width = right - left;
        c.Height = bottom - top;
        return !c.IsEmptyArea();
    }

    BOOL IntersectsWith(in Rect rect) {
        return (GetLeft() < rect.GetRight() &&
                GetTop() < rect.GetBottom() &&
                GetRight() > rect.GetLeft() &&
                GetBottom() > rect.GetTop());
    }

    static BOOL Union(out Rect c, in Rect a, in Rect b) {
    	INT right = ((a.GetRight() > b.GetRight()) ? a.GetRight() : b.GetRight());
    	INT bottom = ((a.GetBottom() > b.GetBottom()) ? a.GetBottom() : b.GetBottom());
//        INT right = max(a.GetRight(), b.GetRight());
//        INT bottom = max(a.GetBottom(), b.GetBottom());
//        INT left = min(a.GetLeft(), b.GetLeft());
//        INT top = min(a.GetTop(), b.GetTop());
    	INT left = ((a.GetLeft() < b.GetLeft()) ? a.GetLeft() : b.GetLeft());
    	INT top = ((a.GetTop() < b.GetTop()) ? a.GetTop() : b.GetTop());

        c.X = left;
        c.Y = top;
        c.Width = right - left;
        c.Height = bottom - top;
        return !c.IsEmptyArea();
    }

    VOID Offset(in Point point) {
        Offset(point.X, point.Y);
    }

    VOID Offset(in INT dx, in INT dy) {
        X += dx;
        Y += dy;
    }

    INT X;
    INT Y;
    INT Width;
    INT Height;
}

struct PathData {
public:
    INT Count;
    PointF[] Points;
	BYTE[] Types;
}

struct CharacterRange {
public:

	CharacterRange init(INT first, INT length) {
		CharacterRange ret;
		ret.First = first;
		ret.Length = length;
		return ret;
	}

    INT First;
    INT Length;
}