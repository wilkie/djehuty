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

module binding.win32.gdipluslinecaps;

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
import binding.win32.gdipluspath;

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

class CustomLineCap : GdiplusBase {

    this(in GraphicsPath* fillPath, in GraphicsPath* strokePath, in LineCap baseCap = LineCap.LineCapFlat, in REAL baseInset = 0) {
        nativeCap = null;
        GpPath* nativeFillPath = null;
        GpPath* nativeStrokePath = null;
    
        if(fillPath)
            nativeFillPath = fillPath.nativePath;
        if(strokePath)
            nativeStrokePath = strokePath.nativePath;
    
        lastResult = GdipCreateCustomLineCap(
                        nativeFillPath, nativeStrokePath,
                        baseCap, baseInset, &nativeCap);        
    }
    
    ~this() {     
        GdipDeleteCustomLineCap(nativeCap);   
    }

    CustomLineCap Clone() {  
        GpCustomLineCap *newNativeLineCap = null;
        
        SetStatus(GdipCloneCustomLineCap(nativeCap, 
                                                     &newNativeLineCap));
    
        if (lastResult == Status.Ok) {
            CustomLineCap newLineCap = new CustomLineCap(newNativeLineCap, lastResult);
            if (newLineCap is null) {
                SetStatus(GdipDeleteCustomLineCap(newNativeLineCap));
            }
    
            return newLineCap;
        }
    
        return null;      
    }
    
    alias Clone dup;

    // This changes both the start and end cap.

    Status SetStrokeCap(in LineCap strokeCap) {
        return SetStrokeCaps(strokeCap, strokeCap);
    }

    Status SetStrokeCaps(in LineCap startCap, in LineCap endCap) {   
        return SetStatus(GdipSetCustomLineCapStrokeCaps(nativeCap, startCap, endCap));     
    }
    
    Status GetStrokeCaps(LineCap* startCap, LineCap* endCap) {     
        return SetStatus(GdipGetCustomLineCapStrokeCaps(nativeCap, startCap, endCap));   
    }
    
    Status SetStrokeJoin(in LineJoin lineJoin) {    
        return SetStatus(GdipSetCustomLineCapStrokeJoin(nativeCap, lineJoin));    
    }
    
    LineJoin GetStrokeJoin() {      
        LineJoin lineJoin;
    
        SetStatus(GdipGetCustomLineCapStrokeJoin(nativeCap, &lineJoin));
    
        return lineJoin;  
    }
    
    Status SetBaseCap(in LineCap baseCap) {    
        return SetStatus(GdipSetCustomLineCapBaseCap(nativeCap, baseCap));    
    }
    
    LineCap GetBaseCap() {  
        LineCap baseCap;
        SetStatus(GdipGetCustomLineCapBaseCap(nativeCap, &baseCap));
    
        return baseCap;      
    }
    
    Status SetBaseInset(in REAL inset) {    
        return SetStatus(GdipSetCustomLineCapBaseInset(nativeCap, inset));    
    }
    
    REAL GetBaseInset() {   
        REAL inset;
        SetStatus(GdipGetCustomLineCapBaseInset(nativeCap, &inset));
    
        return inset;     
    }
    
    Status SetWidthScale(in REAL widthScale) {     
        return SetStatus(GdipSetCustomLineCapWidthScale(nativeCap, widthScale));   
    }
    
    REAL GetWidthScale() { 
        REAL widthScale;
        SetStatus(GdipGetCustomLineCapWidthScale(nativeCap, &widthScale));
    
        return widthScale;       
    }
    
    Status GetLastStatus() {    
        Status lastStatus = lastResult;
        lastResult = Status.Ok;    
        return (lastStatus);    
    }

protected:

    package this() {      
    }

    this(GpCustomLineCap* nativeCap, Status status) {
        lastResult = status;
        SetNativeCap(nativeCap);
    }

    VOID SetNativeCap(GpCustomLineCap* nativeCap) {
        this.nativeCap = nativeCap;
    }

    Status SetStatus(Status status) {
        if (status != Status.Ok)
            return (lastResult = status);
        else
            return status;
    }

    package GpCustomLineCap* nativeCap = null;
    package Status lastResult = Status.Ok;
}

class AdjustableArrowCap : CustomLineCap {

    this(in REAL height, in REAL width, in BOOL isFilled = TRUE) {
        GpAdjustableArrowCap* cap = null;

        lastResult = GdipCreateAdjustableArrowCap(
                        height, width, isFilled, &cap);
        SetNativeCap(cap);
    }

    Status SetHeight(in REAL height) {
        GpAdjustableArrowCap* cap = cast(GpAdjustableArrowCap*) nativeCap;
        return SetStatus(GdipSetAdjustableArrowCapHeight(
                            cap, height));
    }

    REAL GetHeight() {
        GpAdjustableArrowCap* cap = cast(GpAdjustableArrowCap*) nativeCap;
        REAL height;
        SetStatus(GdipGetAdjustableArrowCapHeight(
                            cap, &height));

        return height;
    }

    Status SetWidth(in REAL width) {
        GpAdjustableArrowCap* cap = cast(GpAdjustableArrowCap*) nativeCap;
        return SetStatus(GdipSetAdjustableArrowCapWidth(
                            cap, width));
    }

    REAL GetWidth() {
        GpAdjustableArrowCap* cap = cast(GpAdjustableArrowCap*) nativeCap;
        REAL width;
        SetStatus(GdipGetAdjustableArrowCapWidth(
                            cap, &width));

        return width;
    }

    Status SetMiddleInset(in REAL middleInset) {
        GpAdjustableArrowCap* cap = cast(GpAdjustableArrowCap*) nativeCap;
        return SetStatus(GdipSetAdjustableArrowCapMiddleInset(
                            cap, middleInset));
    }

    REAL GetMiddleInset() {
        GpAdjustableArrowCap* cap = cast(GpAdjustableArrowCap*) nativeCap;
        REAL middleInset;
        SetStatus(GdipGetAdjustableArrowCapMiddleInset(
                            cap, &middleInset));

        return middleInset;
    }

    Status SetFillState(in BOOL isFilled) {
        GpAdjustableArrowCap* cap = cast(GpAdjustableArrowCap*) nativeCap;
        return SetStatus(GdipSetAdjustableArrowCapFillState(
                            cap, isFilled));
    }

    BOOL IsFilled() {
        GpAdjustableArrowCap* cap = cast(GpAdjustableArrowCap*) nativeCap;
        BOOL isFilled;
        SetStatus(GdipGetAdjustableArrowCapFillState(
                            cap, &isFilled));

        return isFilled;
    }
}


