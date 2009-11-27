/*
 * gdipluslinecaps.d
 *
 * This module implements GdiPlusLineCaps.h for D. The original
 * copyright info is given below.
 *
 * Author: Dave Wilkinson
 * Originated: November 25th, 2009
 *
 */

module binding.win32.gdiplusbrush;

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
*    GdiplusLineCaps.h
*
* Abstract:
*
*   GDI+ CustomLineCap APIs
*
\**************************************************************************/

#ifndef _GDIPLUSLINECAPS_H
#define _GDIPLUSLINECAPS_H

inline 
CustomLineCap::CustomLineCap(
    IN const GraphicsPath* fillPath,
    IN const GraphicsPath* strokePath,
    IN LineCap baseCap,
    IN REAL baseInset
    )
{
    nativeCap = NULL;
    GpPath* nativeFillPath = NULL;
    GpPath* nativeStrokePath = NULL;

    if(fillPath)
        nativeFillPath = fillPath->nativePath;
    if(strokePath)
        nativeStrokePath = strokePath->nativePath;

    lastResult = DllExports::GdipCreateCustomLineCap(
                    nativeFillPath, nativeStrokePath,
                    baseCap, baseInset, &nativeCap);
}

inline 
CustomLineCap::CustomLineCap()
{
    nativeCap = NULL;
    lastResult = Ok;
}

inline 
CustomLineCap::~CustomLineCap()
{
    DllExports::GdipDeleteCustomLineCap(nativeCap);
}

inline Status 
CustomLineCap::SetStrokeCaps(
    IN LineCap startCap, 
    IN LineCap endCap)
{
    return SetStatus(DllExports::GdipSetCustomLineCapStrokeCaps(nativeCap,
                startCap, endCap));
}

inline Status 
CustomLineCap::GetStrokeCaps(
    OUT LineCap* startCap, 
    OUT LineCap* endCap) const
{
    return SetStatus(DllExports::GdipGetCustomLineCapStrokeCaps(nativeCap,
                 startCap, endCap));
}

inline Status 
CustomLineCap::SetStrokeJoin(
    IN LineJoin lineJoin)
{
    return SetStatus(DllExports::GdipSetCustomLineCapStrokeJoin(nativeCap, 
                                                                lineJoin));
}

inline LineJoin 
CustomLineCap::GetStrokeJoin() const
{
    LineJoin lineJoin;

    SetStatus(DllExports::GdipGetCustomLineCapStrokeJoin(nativeCap, 
                                                         &lineJoin));

    return lineJoin;
}

inline Status 
CustomLineCap::SetBaseCap(IN LineCap baseCap)
{
    return SetStatus(DllExports::GdipSetCustomLineCapBaseCap(nativeCap, 
                                                             baseCap));
}

inline LineCap 
CustomLineCap::GetBaseCap() const
{
    LineCap baseCap;
    SetStatus(DllExports::GdipGetCustomLineCapBaseCap(nativeCap, &baseCap));

    return baseCap;
}

inline Status 
CustomLineCap::SetBaseInset(IN REAL inset)
{
    return SetStatus(DllExports::GdipSetCustomLineCapBaseInset(nativeCap, 
                                                               inset));
}

inline REAL 
CustomLineCap::GetBaseInset() const
{
    REAL inset;
    SetStatus(DllExports::GdipGetCustomLineCapBaseInset(nativeCap, &inset));

    return inset;
}


inline Status 
CustomLineCap::SetWidthScale(IN REAL widthScale)
{
    return SetStatus(DllExports::GdipSetCustomLineCapWidthScale(nativeCap, 
                                                                widthScale));
}

inline REAL 
CustomLineCap::GetWidthScale() const
{
    REAL widthScale;
    SetStatus(DllExports::GdipGetCustomLineCapWidthScale(nativeCap, 
                                                         &widthScale));

    return widthScale;
}

inline CustomLineCap* 
CustomLineCap::Clone() const
{
    GpCustomLineCap *newNativeLineCap = NULL;
    
    SetStatus(DllExports::GdipCloneCustomLineCap(nativeCap, 
                                                 &newNativeLineCap));

    if (lastResult == Ok) 
    {
        CustomLineCap *newLineCap = new CustomLineCap(newNativeLineCap, 
                                                      lastResult);
        if (newLineCap == NULL) 
        {
            SetStatus(DllExports::GdipDeleteCustomLineCap(newNativeLineCap));
        }

        return newLineCap;
    }

    return NULL;
}

inline Status 
CustomLineCap::GetLastStatus() const 
{
    Status lastStatus = lastResult;
    lastResult = Ok;    
    return (lastStatus);
}

class AdjustableArrowCap : public CustomLineCap
{
public:

    AdjustableArrowCap(
        IN REAL height,
        IN REAL width,
        IN BOOL isFilled = TRUE
        )
    {
        GpAdjustableArrowCap* cap = NULL;

        lastResult = DllExports::GdipCreateAdjustableArrowCap(
                        height, width, isFilled, &cap);
        SetNativeCap(cap);
    }

    Status SetHeight(IN REAL height)
    {
        GpAdjustableArrowCap* cap = (GpAdjustableArrowCap*) nativeCap;
        return SetStatus(DllExports::GdipSetAdjustableArrowCapHeight(
                            cap, height));
    }

    REAL GetHeight() const
    {
        GpAdjustableArrowCap* cap = (GpAdjustableArrowCap*) nativeCap;
        REAL height;
        SetStatus(DllExports::GdipGetAdjustableArrowCapHeight(
                            cap, &height));

        return height;
    }

    Status SetWidth(IN REAL width)
    {
        GpAdjustableArrowCap* cap = (GpAdjustableArrowCap*) nativeCap;
        return SetStatus(DllExports::GdipSetAdjustableArrowCapWidth(
                            cap, width));
    }

    REAL GetWidth() const
    {
        GpAdjustableArrowCap* cap = (GpAdjustableArrowCap*) nativeCap;
        REAL width;
        SetStatus(DllExports::GdipGetAdjustableArrowCapWidth(
                            cap, &width));

        return width;
    }

    Status SetMiddleInset(IN REAL middleInset)
    {
        GpAdjustableArrowCap* cap = (GpAdjustableArrowCap*) nativeCap;
        return SetStatus(DllExports::GdipSetAdjustableArrowCapMiddleInset(
                            cap, middleInset));
    }

    REAL GetMiddleInset() const
    {
        GpAdjustableArrowCap* cap = (GpAdjustableArrowCap*) nativeCap;
        REAL middleInset;
        SetStatus(DllExports::GdipGetAdjustableArrowCapMiddleInset(
                            cap, &middleInset));

        return middleInset;
    }

    Status SetFillState(IN BOOL isFilled)
    {
        GpAdjustableArrowCap* cap = (GpAdjustableArrowCap*) nativeCap;
        return SetStatus(DllExports::GdipSetAdjustableArrowCapFillState(
                            cap, isFilled));
    }

    BOOL IsFilled() const
    {
        GpAdjustableArrowCap* cap = (GpAdjustableArrowCap*) nativeCap;
        BOOL isFilled;
        SetStatus(DllExports::GdipGetAdjustableArrowCapFillState(
                            cap, &isFilled));

        return isFilled;
    }

private:
    AdjustableArrowCap(const AdjustableArrowCap &);
    AdjustableArrowCap& operator=(const AdjustableArrowCap &);
};


#endif

