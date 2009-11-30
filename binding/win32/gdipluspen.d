/*
 * gdipluspen.d
 *
 * This module implements GdiPlusPen.h for D. The original
 * copyright info is given below.
 *
 * Author: Dave Wilkinson
 * Originated: November 25th, 2009
 *
 */

module binding.win32.gdipluspen;

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
import binding.win32.gdiplusbrush;
import binding.win32.gdipluslinecaps;

/**************************************************************************\
*
* Copyright (c) 1998-2001, Microsoft Corp.  All Rights Reserved.
*
* Module Name:
*
*   GdiplusPen.h
*
* Abstract:
*
*   GDI+ Pen class
*
\**************************************************************************/

extern(System):

//--------------------------------------------------------------------------
// Pen class
//--------------------------------------------------------------------------

class Pen : GdiplusBase {

    this(in Color color,
        in REAL width = 1.0f) {
        Unit unit = Unit.UnitWorld;
        nativePen = null;
        lastResult = GdipCreatePen1(color.GetValue(),
                                    width, unit, &nativePen);
    }

    this(in Brush brush, in REAL width = 1.0f) {
        Unit unit = Unit.UnitWorld;
        nativePen = null;
        lastResult = GdipCreatePen2(brush.nativeBrush,
                                    width, unit, &nativePen);
    }

    ~this() {
        GdipDeletePen(nativePen);
    }

    Pen Clone() {
        GpPen *clonePen = null;

        lastResult = GdipClonePen(nativePen, &clonePen);

        return new Pen(clonePen, lastResult);
    }

    alias Clone dup;

    Status SetWidth(in REAL width) {
        return SetStatus(GdipSetPenWidth(nativePen, width));
    }

    REAL GetWidth() {
        REAL width;

        SetStatus(GdipGetPenWidth(nativePen, &width));

        return width;
    }
    
    // Set/get line caps: start, end, and dash

    // Line cap and join APIs by using LineCap and LineJoin enums.

    Status SetLineCap(in LineCap startCap,
                      in LineCap endCap,
                      in DashCap dashCap) {
        return SetStatus(GdipSetPenLineCap197819(nativePen,
                                   startCap, endCap, dashCap));
    }

    Status SetStartCap(in LineCap startCap) {
        return SetStatus(GdipSetPenStartCap(nativePen, startCap));
    }

    Status SetEndCap(in LineCap endCap) {
        return SetStatus(GdipSetPenEndCap(nativePen, endCap));
    }

    Status SetDashCap(in DashCap dashCap) {
        return SetStatus(GdipSetPenDashCap197819(nativePen,
                                   dashCap));
    }

    LineCap GetStartCap() {
        LineCap startCap;

        SetStatus(GdipGetPenStartCap(nativePen, &startCap));

        return startCap;
    }

    LineCap GetEndCap() {
        LineCap endCap;

        SetStatus(GdipGetPenEndCap(nativePen, &endCap));

        return endCap;
    }

    DashCap GetDashCap() {
        DashCap dashCap;

        SetStatus(GdipGetPenDashCap197819(nativePen,
                            &dashCap));

        return dashCap;
    }

    Status SetLineJoin(in LineJoin lineJoin) {
        return SetStatus(GdipSetPenLineJoin(nativePen, lineJoin));
    }

    LineJoin GetLineJoin() {
        LineJoin lineJoin;

        SetStatus(GdipGetPenLineJoin(nativePen, &lineJoin));

        return lineJoin;
    }

    Status SetCustomStartCap(in CustomLineCap* customCap) {
        GpCustomLineCap* nativeCap = null;
        if(customCap)
            nativeCap = customCap.nativeCap;

        return SetStatus(GdipSetPenCustomStartCap(nativePen,
                                                              nativeCap));
    }

    Status GetCustomStartCap(out CustomLineCap* customCap) {
        if(!customCap)
            return SetStatus(Status.InvalidParameter);

        return SetStatus(GdipGetPenCustomStartCap(nativePen,
                                                    &(customCap.nativeCap)));
    }

    Status SetCustomEndCap(in CustomLineCap* customCap) {
        GpCustomLineCap* nativeCap = null;
        if(customCap)
            nativeCap = customCap.nativeCap;

        return SetStatus(GdipSetPenCustomEndCap(nativePen,
                                                            nativeCap));
    }

    Status GetCustomEndCap(out CustomLineCap* customCap) {
        if(!customCap)
            return SetStatus(Status.InvalidParameter);

        return SetStatus(GdipGetPenCustomEndCap(nativePen,
                                                    &(customCap.nativeCap)));
    }

    Status SetMiterLimit(in REAL miterLimit) {
        return SetStatus(GdipSetPenMiterLimit(nativePen,
                                                    miterLimit));
    }

    REAL GetMiterLimit() {
        REAL miterLimit;

        SetStatus(GdipGetPenMiterLimit(nativePen, &miterLimit));

        return miterLimit;
    }

    Status SetAlignment(in PenAlignment penAlignment) {
        return SetStatus(GdipSetPenMode(nativePen, penAlignment));
    }

    PenAlignment GetAlignment() {
        PenAlignment penAlignment;

        SetStatus(GdipGetPenMode(nativePen, &penAlignment));

        return penAlignment;
    }

    Status SetTransform(in Matrix* matrix) {
        return SetStatus(GdipSetPenTransform(nativePen,
                                                       matrix.nativeMatrix));
    }

    Status GetTransform(out Matrix* matrix) {
        return SetStatus(GdipGetPenTransform(nativePen,
                                                         matrix.nativeMatrix));
    }

    Status ResetTransform() {
        return SetStatus(GdipResetPenTransform(nativePen));
    }

    Status MultiplyTransform(in Matrix* matrix,
                             in MatrixOrder order = MatrixOrder.MatrixOrderPrepend) {
        return SetStatus(GdipMultiplyPenTransform(nativePen,
                                                         matrix.nativeMatrix,
                                                         order));
    }

    Status TranslateTransform(in REAL dx,
                              in REAL dy,
                              in MatrixOrder order = MatrixOrder.MatrixOrderPrepend) {
        return SetStatus(GdipTranslatePenTransform(nativePen,
                                                               dx,
                                                               dy,
                                                               order));
    }

    Status ScaleTransform(in REAL sx,
                          in REAL sy,
                          in MatrixOrder order = MatrixOrder.MatrixOrderPrepend) {
        return SetStatus(GdipScalePenTransform(nativePen,
                                                           sx,
                                                           sy,
                                                           order));
    }

    Status RotateTransform(in REAL angle,
                           in MatrixOrder order = MatrixOrder.MatrixOrderPrepend) {
        return SetStatus(GdipRotatePenTransform(nativePen,
                                                            angle,
                                                            order));
    }

    PenType GetPenType() {
       PenType type;
       SetStatus(GdipGetPenFillType(nativePen, &type));

       return type;
    }

    Status SetColor(in Color color) {
        return SetStatus(GdipSetPenColor(nativePen,
                                                     color.GetValue()));
    }

    Status SetBrush(in Brush brush) {
        return SetStatus(GdipSetPenBrushFill(nativePen,
                                       brush.nativeBrush));
    }

    Status GetColor(out Color color) {
        if (color is null) {
            return SetStatus(Status.InvalidParameter);
        }

        PenType type = GetPenType();

        if (type != PenType.PenTypeSolidColor) {
            return Status.WrongState;
        }

        ARGB argb;

        SetStatus(GdipGetPenColor(nativePen,
                                              &argb));
        if (lastResult == Status.Ok) {
            color.SetValue(argb);
        }

        return lastResult;
    }

    Brush GetBrush() {
       PenType type = GetPenType();

       Brush brush = null;

       switch(type) {
       case PenType.PenTypeSolidColor:
           brush = new SolidBrush();
           break;

       case PenType.PenTypeHatchFill:
           brush = new HatchBrush();
           break;

       case PenType.PenTypeTextureFill:
           brush = new TextureBrush();
           break;

       case PenType.PenTypePathGradient:
           brush = new Brush();
           break;

       case PenType.PenTypeLinearGradient:
           brush = new LinearGradientBrush();
           break;

       default:
           break;
       }

       if(brush) {
           GpBrush* nativeBrush;

           SetStatus(GdipGetPenBrushFill(nativePen,
                                                     &nativeBrush));
           brush.SetNativeBrush(nativeBrush);
       }

       return brush;
    }

    DashStyle GetDashStyle() {
        DashStyle dashStyle;

        SetStatus(GdipGetPenDashStyle(nativePen, &dashStyle));

        return dashStyle;
    }

    Status SetDashStyle(in DashStyle dashStyle) {
        return SetStatus(GdipSetPenDashStyle(nativePen,
                                                         dashStyle));
    }

    REAL GetDashOffset() {
        REAL dashOffset;

        SetStatus(GdipGetPenDashOffset(nativePen, &dashOffset));

        return dashOffset;
    }

    Status SetDashOffset(in REAL dashOffset) {
        return SetStatus(GdipSetPenDashOffset(nativePen,
                                                          dashOffset));
    }

    Status SetDashPattern(in REAL* dashArray, in INT count) {
        return SetStatus(GdipSetPenDashArray(nativePen,
                                                         dashArray,
                                                         count));
    }

    INT GetDashPatternCount() {
        INT count = 0;

        SetStatus(GdipGetPenDashCount(nativePen, &count));

        return count;
    }

    Status GetDashPattern(out REAL* dashArray, in INT count) {
        if (dashArray is null || count <= 0)
            return SetStatus(Status.InvalidParameter);

        return SetStatus(GdipGetPenDashArray(nativePen,
                                                         dashArray,
                                                         count));
    }

    Status SetCompoundArray(in REAL* compoundArray,
                            in INT count) {
        return SetStatus(GdipSetPenCompoundArray(nativePen,
                                                             compoundArray,
                                                             count));
    }

    INT GetCompoundArrayCount() {
        INT count = 0;

        SetStatus(GdipGetPenCompoundCount(nativePen, &count));

        return count;
    }

    Status GetCompoundArray(out REAL* compoundArray, in INT count) {
        if (compoundArray is null || count <= 0)
            return SetStatus(Status.InvalidParameter);

        return SetStatus(GdipGetPenCompoundArray(nativePen,
                                                             compoundArray,
                                                             count));
    }

    Status GetLastStatus() {
        Status lastStatus = lastResult;
        lastResult = Status.Ok;

        return lastStatus;
    }

protected:

    package this(GpPen* nativePen, Status status) {
        lastResult = status;
        SetNativePen(nativePen);
    }

    VOID SetNativePen(GpPen* nativePen) {
        this.nativePen = nativePen;
    }

    Status SetStatus(Status status) {
        if (status != Status.Ok)
            return (lastResult = status);
        else
            return status;
    }

    package GpPen* nativePen;
    package Status lastResult;
}