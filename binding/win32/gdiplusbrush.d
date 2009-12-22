/*
 * gdiplusbrush.d
 *
 * This module implements GdiPlusBrush.h for D. The original
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
* Copyright (c) 1998-2001, Microsoft Corp.  All Rights Reserved.
*
* Module Name:
*
*   GdiplusBrush.h
*
* Abstract:
*
*   GDI+ Brush class
*
\**************************************************************************/

extern(System):

//--------------------------------------------------------------------------
// Abstract base class for various brush types
//--------------------------------------------------------------------------

class Brush : GdiplusBase {

    ~this() {
        GdipDeleteBrush(nativeBrush);
    }

    Brush Clone() {
        GpBrush *brush = null;

        SetStatus(GdipCloneBrush(nativeBrush, &brush));

        Brush newBrush = new Brush(brush, lastResult);

        if (newBrush is null) {
            GdipDeleteBrush(brush);
        }

        return newBrush;
    }

    alias Clone dup;

    BrushType GetType() {
        BrushType type = cast(BrushType)(-1);

        SetStatus(GdipGetBrushType(nativeBrush, &type));

        return type;
    }

    Status GetLastStatus() {
        Status lastStatus = lastResult;
        lastResult = Status.Ok;

        return lastStatus;
    }

protected:

    package this() {
        SetStatus(Status.NotImplemented);
    }

    package this(GpBrush* nativeBrush, Status status) {
        lastResult = status;
        SetNativeBrush(nativeBrush);
    }

    package VOID SetNativeBrush(GpBrush* nativeBrush) {
        this.nativeBrush = nativeBrush;
    }

    package Status SetStatus(Status status) {
        if (status != Status.Ok)
            return (lastResult = status);
        else
            return status;
    }

    package GpBrush* nativeBrush;
    package Status lastResult;
}

//--------------------------------------------------------------------------
// Solid Fill Brush Object
//--------------------------------------------------------------------------

class SolidBrush : Brush {

    this(ref Color color) {
        GpSolidFill *brush = null;

        lastResult = GdipCreateSolidFill(color.GetValue(), &brush);

        SetNativeBrush(cast(GpBrush*)brush);
    }

    Status GetColor(Color color) {
        ARGB argb;

        if (color is null) {
            return SetStatus(Status.InvalidParameter);
        }

        SetStatus(GdipGetSolidFillColor(cast(GpSolidFill*)nativeBrush,
                                                    &argb));

        color = new Color(argb);

        return lastResult;
    }

    Status SetColor(in Color color) {
        return SetStatus(GdipSetSolidFillColor(cast(GpSolidFill*)nativeBrush,
                                                           color.GetValue()));
    }

protected:

    package this() {
    }
}

//--------------------------------------------------------------------------
// Texture Brush Fill Object
//--------------------------------------------------------------------------

class TextureBrush : Brush {

    this(in Image* image,
                 in WrapMode wrapMode = WrapMode.WrapModeTile) {
        GpTexture *texture = null;

        lastResult = GdipCreateTexture(
                                                  image.nativeImage,
                                                  wrapMode, &texture);

        SetNativeBrush(cast(GpBrush*)texture);
    }

    // When creating a texture brush from a metafile image, the dstRect
    // is used to specify the size that the metafile image should be
    // rendered at in the device units of the destination graphics.
    // It is NOT used to crop the metafile image, so only the width
    // and height values matter for metafiles.

    this(in Image* image,
                 in WrapMode wrapMode,
                 in RectF dstRect) {
        GpTexture *texture = null;

        lastResult = GdipCreateTexture2(
                                                   image.nativeImage,
                                                   wrapMode,
                                                   dstRect.X,
                                                   dstRect.Y,
                                                   dstRect.Width,
                                                   dstRect.Height,
                                                   &texture);

        SetNativeBrush(texture);
    }

    this(in Image *image,
                 in RectF dstRect,
                 in ImageAttributes *imageAttributes = null) {
        GpTexture *texture = null;

        lastResult = GdipCreateTextureIA(
            image.nativeImage,
            (imageAttributes !is null)?imageAttributes.nativeImageAttr:null,
            dstRect.X,
            dstRect.Y,
            dstRect.Width,
            dstRect.Height,
            &texture
        );

        SetNativeBrush(texture);
    }

    this(in Image *image,
                 in Rect dstRect,
                 in ImageAttributes *imageAttributes = null) {
        GpTexture *texture = null;

        lastResult = GdipCreateTextureIAI(
            image.nativeImage,
            (imageAttributes !is null)?imageAttributes.nativeImageAttr:null,
            dstRect.X,
            dstRect.Y,
            dstRect.Width,
            dstRect.Height,
            &texture
        );

        SetNativeBrush(texture);
    }

    this(in Image* image, in WrapMode wrapMode, in Rect dstRect) {
        GpTexture *texture = null;

        lastResult = GdipCreateTexture2I(
                                                    image.nativeImage,
                                                    wrapMode,
                                                    dstRect.X,
                                                    dstRect.Y,
                                                    dstRect.Width,
                                                    dstRect.Height,
                                                    &texture);

        SetNativeBrush(texture);
    }

    this(in Image* image,
                 in WrapMode wrapMode,
                 in REAL dstX,
                 in REAL dstY,
                 in REAL dstWidth,
                 in REAL dstHeight)
    {
        GpTexture *texture = null;

        lastResult = GdipCreateTexture2(
                                                   image.nativeImage,
                                                   wrapMode,
                                                   dstX,
                                                   dstY,
                                                   dstWidth,
                                                   dstHeight,
                                                   &texture);

        SetNativeBrush(texture);
    }

    this(in Image* image,
                 in WrapMode wrapMode,
                 in INT dstX,
                 in INT dstY,
                 in INT dstWidth,
                 in INT dstHeight) {
        GpTexture *texture = null;

        lastResult = GdipCreateTexture2I(
                                                    image.nativeImage,
                                                    wrapMode,
                                                    dstX,
                                                    dstY, 
                                                    dstWidth, 
                                                    dstHeight,
                                                    &texture);

        SetNativeBrush(texture);
    }

    Status SetTransform(Matrix matrix) {
        return SetStatus(GdipSetTextureTransform(cast(GpTexture*)nativeBrush,
                                                             matrix.nativeMatrix));
    }

    Status GetTransform(in Matrix matrix) {
        return SetStatus(GdipGetTextureTransform(cast(GpTexture*)nativeBrush,
                                                             matrix.nativeMatrix));
    }

    Status ResetTransform() {
        return SetStatus(GdipResetTextureTransform(cast(GpTexture*)nativeBrush));
    }

    Status MultiplyTransform(in Matrix* matrix,
                             in MatrixOrder order = MatrixOrder.MatrixOrderPrepend) {
        return SetStatus(GdipMultiplyTextureTransform(cast(GpTexture*)nativeBrush,
                                                                matrix.nativeMatrix,
                                                                order));
    }

    Status TranslateTransform(in REAL dx,
                              in REAL dy,
                              in MatrixOrder order = MatrixOrder.MatrixOrderPrepend)
    {
        return SetStatus(GdipTranslateTextureTransform(cast(GpTexture*)nativeBrush,
                                                               dx, dy, order));
    }

    Status ScaleTransform(in REAL sx,
                          in REAL sy,
                          in MatrixOrder order = MatrixOrder.MatrixOrderPrepend) {
        return SetStatus(GdipScaleTextureTransform(cast(GpTexture*)nativeBrush,
                                                             sx, sy, order));
    }

    Status RotateTransform(in REAL angle,
                           in MatrixOrder order = MatrixOrder.MatrixOrderPrepend) {
        return SetStatus(GdipRotateTextureTransform(cast(GpTexture*)nativeBrush,
                                                              angle, order));
    }

    Status SetWrapMode(in WrapMode wrapMode) {
        return SetStatus(GdipSetTextureWrapMode(cast(GpTexture*)nativeBrush,
                                                            wrapMode));
    }

    WrapMode GetWrapMode() {
        WrapMode wrapMode;

        SetStatus(GdipGetTextureWrapMode(cast(GpTexture*)nativeBrush,
                                                     &wrapMode));
        return wrapMode;
    }

    Image GetImage() {
        GpImage *image;

        SetStatus(GdipGetTextureImage(cast(GpTexture *)nativeBrush,
                                                  &image));

        Image retimage = new Image(image, lastResult);

        if (retimage is null) {
            GdipDisposeImage(image);
        }

        return retimage;
    }

protected:

    package this() {
    }
}

//--------------------------------------------------------------------------
// Linear Gradient Brush Object
//--------------------------------------------------------------------------

class LinearGradientBrush : Brush {

    this(in PointF point1,
                        in PointF point2,
                        in Color color1,
                        in Color color2) {
        GpLineGradient *brush = null;

        lastResult = GdipCreateLineBrush(&point1,
                                                     &point2,
                                                     color1.GetValue(),
                                                     color2.GetValue(),
                                                     WrapMode.WrapModeTile,
                                                     &brush);

        SetNativeBrush(brush);
    }

    this(in Point point1,
                        in Point point2,
                        in Color color1,
                        in Color color2) {
        GpLineGradient *brush = null;

        lastResult = GdipCreateLineBrushI(&point1,
                                                      &point2,
                                                      color1.GetValue(),
                                                      color2.GetValue(),
                                                      WrapMode.WrapModeTile,
                                                      &brush);

        SetNativeBrush(brush);
    }

    this(in RectF rect,
                        in Color color1,
                        in Color color2,
                        in LinearGradientMode mode) {
        GpLineGradient *brush = null;

        lastResult = GdipCreateLineBrushFromRect(&rect,
                                                             color1.GetValue(),
                                                             color2.GetValue(),
                                                             mode,
                                                             WrapMode.WrapModeTile,
                                                             &brush);

        SetNativeBrush(brush);
    }

    this(in Rect rect,
                        in Color color1,
                        in Color color2,
                        in LinearGradientMode mode) {
        GpLineGradient *brush = null;

        lastResult = GdipCreateLineBrushFromRectI(&rect,
                                                              color1.GetValue(),
                                                              color2.GetValue(),
                                                              mode,
                                                              WrapMode.WrapModeTile,
                                                              &brush);

        SetNativeBrush(brush);
    }

    this(in RectF rect,
                        in Color color1,
                        in Color color2,
                        in REAL angle,
                        in BOOL isAngleScalable = FALSE)
    {
        GpLineGradient *brush = null;

        lastResult = GdipCreateLineBrushFromRectWithAngle(&rect,
                                                                      color1.GetValue(),
                                                                      color2.GetValue(),
                                                                      angle,
                                                                      isAngleScalable,
                                                                      WrapMode.WrapModeTile,
                                                                      &brush);

        SetNativeBrush(brush);
    }

    this(in Rect rect,
                        in Color color1,
                        in Color color2,
                        in REAL angle,
                        in BOOL isAngleScalable = FALSE) {
        GpLineGradient *brush = null;

        lastResult = GdipCreateLineBrushFromRectWithAngleI(&rect,
                                                                       color1.GetValue(),
                                                                       color2.GetValue(),
                                                                       angle,
                                                                       isAngleScalable,
                                                                       WrapMode.WrapModeTile,
                                                                       &brush);

        SetNativeBrush(brush);
    }

    Status SetLinearColors(in Color color1,
                           in Color color2) {
        return SetStatus(GdipSetLineColors(cast(GpLineGradient*)nativeBrush,
                                                       color1.GetValue(),
                                                       color2.GetValue()));
    }

    Status GetLinearColors(ref Color[] colors) {
        ARGB[2] argb;

        colors = new Color[2];

        Status status = SetStatus(GdipGetLineColors(cast(GpLineGradient*) nativeBrush, argb.ptr));

        if (status == Status.Ok) {
            // use bitwise copy operator for Color copy
            colors[0] = new Color(argb[0]);
            colors[1] = new Color(argb[1]);
        }

        return status;
    }

    Status GetRectangle(RectF* rect) {
        return SetStatus(GdipGetLineRect(cast(GpLineGradient*)nativeBrush, rect));
    }

    Status GetRectangle(Rect* rect) {
        return SetStatus(GdipGetLineRectI(cast(GpLineGradient*)nativeBrush, rect));
    }

    Status SetGammaCorrection(in BOOL useGammaCorrection) {
        return SetStatus(GdipSetLineGammaCorrection(cast(GpLineGradient*)nativeBrush,
                    useGammaCorrection));
    }

    BOOL GetGammaCorrection() {
        BOOL useGammaCorrection;

        SetStatus(GdipGetLineGammaCorrection(cast(GpLineGradient*)nativeBrush,
                    &useGammaCorrection));

        return useGammaCorrection;
    }

    INT GetBlendCount() {
        INT count = 0;

        SetStatus(GdipGetLineBlendCount(cast(GpLineGradient*)
                                                    nativeBrush,
                                                    &count));

        return count;
    }

    Status SetBlend(in REAL* blendFactors,
                    in REAL* blendPositions,
                    in INT count) {
        return SetStatus(GdipSetLineBlend(cast(GpLineGradient*)
                                                      nativeBrush,
                                                      blendFactors,
                                                      blendPositions,
                                                      count));
    }

    Status GetBlend(REAL* blendFactors,
                    REAL* blendPositions,
                    in INT count) {
        return SetStatus(GdipGetLineBlend(cast(GpLineGradient*)nativeBrush,
                                                      blendFactors,
                                                      blendPositions,
                                                      count));
    }

    INT GetInterpolationColorCount() {
        INT count = 0;

        SetStatus(GdipGetLinePresetBlendCount(cast(GpLineGradient*)
                                                          nativeBrush,
                                                          &count));

        return count;
    }

    Status SetInterpolationColors(in Color* presetColors,
                                  in REAL* blendPositions,
                                  in INT count) {
        if ((count <= 0) || !presetColors)
            return SetStatus(Status.InvalidParameter);

        ARGB *argbs = cast(ARGB*) new BYTE[count*ARGB.sizeof];

        if (argbs) {
            for (INT i = 0; i < count; i++) {
                argbs[i] = presetColors[i].GetValue();
            }

            Status status = SetStatus(GdipSetLinePresetBlend(
                                                                        cast(GpLineGradient*) nativeBrush,
                                                                        argbs,
                                                                        blendPositions,
                                                                        count));
            return status;
        }
        else {
            return SetStatus(Status.OutOfMemory);
        }
    }

    Status GetInterpolationColors(Color[] presetColors,
                                  REAL* blendPositions,
                                  in INT count) {
        if ((count <= 0) || !presetColors)
            return SetStatus(Status.InvalidParameter);

        ARGB[] argbs = new ARGB[count];

        if (!argbs) {
            return SetStatus(Status.OutOfMemory);
        }

        Status status = SetStatus(GdipGetLinePresetBlend(cast(GpLineGradient*)nativeBrush,
                                                                     argbs.ptr,
                                                                     blendPositions,
                                                                     count));
                                                                     
        if (status == Status.Ok) {
            for (INT i = 0; i < count; i++) {
                presetColors[i] = new Color(argbs[i]);
            }
        }

        return status;
    }

    Status SetBlendBellShape(in REAL focus,
                             in REAL scale = 1.0f) {
        return SetStatus(GdipSetLineSigmaBlend(cast(GpLineGradient*)nativeBrush, focus, scale));
    }

    Status SetBlendTriangularShape(
        in REAL focus,
        in REAL scale = 1.0f
    ) {
        return SetStatus(GdipSetLineLinearBlend(cast(GpLineGradient*)nativeBrush, focus, scale));
    }

    Status SetTransform(in Matrix* matrix) {
        return SetStatus(GdipSetLineTransform(cast(GpLineGradient*)nativeBrush,
                                                          matrix.nativeMatrix));
    }

    Status GetTransform(Matrix *matrix) {
        return SetStatus(GdipGetLineTransform(cast(GpLineGradient*)nativeBrush,
                                                          matrix.nativeMatrix));
    }

    Status ResetTransform() {
        return SetStatus(GdipResetLineTransform(cast(GpLineGradient*)nativeBrush));
    }

    Status MultiplyTransform(in Matrix* matrix,
                             in MatrixOrder order = MatrixOrder.MatrixOrderPrepend) {
        return SetStatus(GdipMultiplyLineTransform(cast(GpLineGradient*)nativeBrush,
                                                                matrix.nativeMatrix,
                                                                order));
    }

    Status TranslateTransform(in REAL dx,
                              in REAL dy,
                              in MatrixOrder order = MatrixOrder.MatrixOrderPrepend) {
        return SetStatus(GdipTranslateLineTransform(cast(GpLineGradient*)nativeBrush,
                                                               dx, dy, order));
    }

    Status ScaleTransform(in REAL sx,
                          in REAL sy,
                          in MatrixOrder order = MatrixOrder.MatrixOrderPrepend) {
        return SetStatus(GdipScaleLineTransform(cast(GpLineGradient*)nativeBrush,
                                                             sx, sy, order));
    }

    Status RotateTransform(in REAL angle,
                           in MatrixOrder order = MatrixOrder.MatrixOrderPrepend) {
        return SetStatus(GdipRotateLineTransform(cast(GpLineGradient*)nativeBrush,
                                                              angle, order));
    }

    Status SetWrapMode(in WrapMode wrapMode) {
        return SetStatus(GdipSetLineWrapMode(cast(GpLineGradient*)nativeBrush,
                                                         wrapMode));
    }

    WrapMode GetWrapMode() {
        WrapMode wrapMode;

        SetStatus(GdipGetLineWrapMode(cast(GpLineGradient*)
                                                  nativeBrush,
                                                  &wrapMode));

        return wrapMode;
    }

protected:

    package this() {
    }
}

//--------------------------------------------------------------------------
// PathGradientBrush object is defined
// in gdipluspath.h.
//--------------------------------------------------------------------------

//--------------------------------------------------------------------------
// Hatch Brush Object
//--------------------------------------------------------------------------

class HatchBrush : Brush {

    this(in HatchStyle hatchStyle,
               in Color foreColor,
               in Color backColor = Color.init) {
        GpHatch *brush = null;

        lastResult = GdipCreateHatchBrush(hatchStyle,
                                                      foreColor.GetValue(),
                                                      backColor.GetValue(),
                                                      &brush);
        SetNativeBrush(brush);
    }

    HatchStyle GetHatchStyle() {
        HatchStyle hatchStyle;

        SetStatus(GdipGetHatchStyle(cast(GpHatch*)nativeBrush,
                                                &hatchStyle));

        return hatchStyle;
    }

    Status GetForegroundColor(Color* color) {
        ARGB argb;

        if (color is null) {
            return SetStatus(Status.InvalidParameter);
        }

        Status status = SetStatus(GdipGetHatchForegroundColor(
                                                        cast(GpHatch*)nativeBrush,
                                                        &argb));

        color.SetValue(argb);

        return status;
    }

    Status GetBackgroundColor(Color *color) {
        ARGB argb;

        if (color is null) {
            return SetStatus(Status.InvalidParameter);
        }

        Status status = SetStatus(GdipGetHatchBackgroundColor(
                                                        cast(GpHatch*)nativeBrush,
                                                        &argb));

        color.SetValue(argb);

        return status;
    }

protected:

    package this() {
    }
}

