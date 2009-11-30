/*
 * gdiplusimageattributes.d
 *
 * This module implements GdiPlusImageAttributes.h for D. The original
 * copyright info is given below.
 *
 * Author: Dave Wilkinson
 * Originated: November 25th, 2009
 *
 */

module binding.win32.gdiplusimageattributes;

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

/**************************************************************************\
*
* Copyright (c) 1998-2001, Microsoft Corp.  All Rights Reserved.
*
* Module Name:
*
*   Image Attributes
*
* Abstract:
*
*   GDI+ Image Attributes used with Graphics.DrawImage
*
* There are 5 possible sets of color adjustments:
*          ColorAdjustDefault,
*          ColorAdjustBitmap,
*          ColorAdjustBrush,
*          ColorAdjustPen,
*          ColorAdjustText,
*
* Bitmaps, Brushes, Pens, and Text will all use any color adjustments
* that have been set into the default ImageAttributes until their own
* color adjustments have been set.  So as soon as any "Set" method is
* called for Bitmaps, Brushes, Pens, or Text, then they start from
* scratch with only the color adjustments that have been set for them.
* Calling Reset removes any individual color adjustments for a type
* and makes it revert back to using all the default color adjustments
* (if any).  The SetToIdentity method is a way to force a type to
* have no color adjustments at all, regardless of what previous adjustments
* have been set for the defaults or for that type.
*
\********************************************************************F******/

class ImageAttributes : GdiplusBase {
    this() {
        nativeImageAttr = null;
        lastResult = GdipCreateImageAttributes(&nativeImageAttr);
    }

    ~this() {
        GdipDisposeImageAttributes(nativeImageAttr);
    }

    ImageAttributes Clone() {
        GpImageAttributes* clone;

        SetStatus(GdipCloneImageAttributes(
                                            nativeImageAttr,
                                            &clone));

        return new ImageAttributes(clone, lastResult);
    }
    
    alias Clone dup;

    Status SetToIdentity(in ColorAdjustType type = ColorAdjustType.ColorAdjustTypeDefault) {
        return SetStatus(GdipSetImageAttributesToIdentity(
                                            nativeImageAttr,
                                            type));
    }

    Status Reset(in ColorAdjustType type = ColorAdjustType.ColorAdjustTypeDefault) {
        return SetStatus(GdipResetImageAttributes(
                                            nativeImageAttr,
                                            type));
    }

    Status SetColorMatrix(in ColorMatrix *colorMatrix,
			in ColorMatrixFlags mode = ColorMatrixFlags.ColorMatrixFlagsDefault,
			in ColorAdjustType type = ColorAdjustType.ColorAdjustTypeDefault) {

        return SetStatus(GdipSetImageAttributesColorMatrix(
                                            nativeImageAttr,
                                            type,
                                            TRUE,
                                            colorMatrix,
                                            null,
                                            mode));
    }

    Status ClearColorMatrix(in ColorAdjustType type = ColorAdjustType.ColorAdjustTypeDefault) {
        return SetStatus(GdipSetImageAttributesColorMatrix(
                                            nativeImageAttr,
                                            type,
                                            FALSE,
                                            null,
                                            null,
                                            ColorMatrixFlags.ColorMatrixFlagsDefault));
    }

    Status SetColorMatrices(in ColorMatrix* colorMatrix, in ColorMatrix *grayMatrix,
    		in ColorMatrixFlags mode = ColorMatrixFlags.ColorMatrixFlagsDefault,
    		in ColorAdjustType type = ColorAdjustType.ColorAdjustTypeDefault) {

        return SetStatus(GdipSetImageAttributesColorMatrix(
                                            nativeImageAttr,
                                            type,
                                            TRUE,
                                            colorMatrix,
                                            grayMatrix,
                                            mode));
    }

    Status ClearColorMatrices(in ColorAdjustType type = ColorAdjustType.ColorAdjustTypeDefault) {
        return SetStatus(GdipSetImageAttributesColorMatrix(
                                            nativeImageAttr,
                                            type,
                                            FALSE,
                                            null,
                                            null,
                                            ColorMatrixFlags.ColorMatrixFlagsDefault));
    }

    Status SetThreshold(in REAL threshold, in ColorAdjustType type = ColorAdjustType.ColorAdjustTypeDefault) {

        return SetStatus(GdipSetImageAttributesThreshold(
                                            nativeImageAttr,
                                            type,
                                            TRUE,
                                            threshold));
    }

    Status ClearThreshold(in ColorAdjustType type = ColorAdjustType.ColorAdjustTypeDefault) {
        return SetStatus(GdipSetImageAttributesThreshold(
                                            nativeImageAttr,
                                            type,
                                            FALSE,
                                            0.0));
    }

    Status SetGamma(in REAL gamma, in ColorAdjustType type = ColorAdjustType.ColorAdjustTypeDefault) {
        return SetStatus(GdipSetImageAttributesGamma(
                                            nativeImageAttr,
                                            type,
                                            TRUE,
                                            gamma));
    }

    Status ClearGamma(in ColorAdjustType type = ColorAdjustType.ColorAdjustTypeDefault) {
        return SetStatus(GdipSetImageAttributesGamma(
                                            nativeImageAttr,
                                            type,
                                            FALSE,
                                            0.0));
    }

    Status SetNoOp(in ColorAdjustType type = ColorAdjustType.ColorAdjustTypeDefault) {
        return SetStatus(GdipSetImageAttributesNoOp(
                                            nativeImageAttr,
                                            type,
                                            TRUE));
    }

    Status ClearNoOp(in ColorAdjustType type = ColorAdjustType.ColorAdjustTypeDefault) {
        return SetStatus(GdipSetImageAttributesNoOp(
                                            nativeImageAttr,
                                            type,
                                            FALSE));
    }

    Status SetColorKey(in Color colorLow, in Color colorHigh, 
			in ColorAdjustType type = ColorAdjustType.ColorAdjustTypeDefault) {

        return SetStatus(GdipSetImageAttributesColorKeys(
                                            nativeImageAttr,
                                            type,
                                            TRUE,
                                            colorLow.GetValue(),
                                            colorHigh.GetValue()));
    }

    Status ClearColorKey(in ColorAdjustType type = ColorAdjustType.ColorAdjustTypeDefault) {
        return SetStatus(GdipSetImageAttributesColorKeys(
                                            nativeImageAttr,
                                            type,
                                            FALSE,
                                            0,
                                            0));
    }

    Status SetOutputChannel(in ColorChannelFlags channelFlags,
			in ColorAdjustType type = ColorAdjustType.ColorAdjustTypeDefault) {
        return SetStatus(GdipSetImageAttributesOutputChannel(
                                            nativeImageAttr,
                                            type,
                                            TRUE,
                                            channelFlags));
    }

    Status ClearOutputChannel(in ColorAdjustType type = ColorAdjustType.ColorAdjustTypeDefault) {
        return SetStatus(GdipSetImageAttributesOutputChannel(
                                            nativeImageAttr,
                                            type,
                                            FALSE,
                                            ColorChannelFlags.ColorChannelFlagsLast));
    }

    Status SetOutputChannelColorProfile(in WCHAR* colorProfileFilename,
    		in ColorAdjustType type = ColorAdjustType.ColorAdjustTypeDefault) {

        return SetStatus(GdipSetImageAttributesOutputChannelColorProfile(
                                            nativeImageAttr,
                                            type,
                                            TRUE,
                                            colorProfileFilename));
    }

    Status ClearOutputChannelColorProfile(in ColorAdjustType type = ColorAdjustType.ColorAdjustTypeDefault) {
        return SetStatus(GdipSetImageAttributesOutputChannelColorProfile(
                                            nativeImageAttr,
                                            type,
                                            FALSE,
                                            null));
    }

    Status SetRemapTable(in UINT mapSize, in ColorMap* map, in ColorAdjustType type = ColorAdjustType.ColorAdjustTypeDefault) {
        return SetStatus(GdipSetImageAttributesRemapTable(
                                            nativeImageAttr,
                                            type,
                                            TRUE,
                                            mapSize,
                                            map));
    }

    Status ClearRemapTable(in ColorAdjustType type = ColorAdjustType.ColorAdjustTypeDefault) {
        return SetStatus(GdipSetImageAttributesRemapTable(
                                            nativeImageAttr,
                                            type,
                                            FALSE,
                                            0,
                                            null));
    }

    Status SetBrushRemapTable(in UINT mapSize, in ColorMap* map) {
        return SetRemapTable(mapSize, map, ColorAdjustType.ColorAdjustTypeBrush);
    }

    Status ClearBrushRemapTable() {
        return ClearRemapTable(ColorAdjustType.ColorAdjustTypeBrush);
    }

    Status SetWrapMode(in WrapMode wrap, in Color color = Color.init, in BOOL clamp = FALSE) {
        ARGB argb = color.GetValue();

        return SetStatus(GdipSetImageAttributesWrapMode(
                           nativeImageAttr, wrap, argb, clamp));
    }

    // The flags of the palette are ignored.

    Status GetAdjustedPalette(ref ColorPalette* colorPalette, in ColorAdjustType colorAdjustType) {
        return SetStatus(GdipGetImageAttributesAdjustedPalette(
                           nativeImageAttr, colorPalette, colorAdjustType));
    }

    Status GetLastStatus() {
        Status lastStatus = lastResult;
        lastResult = Status.Ok;

        return lastStatus;
    }

protected:
    this(GpImageAttributes* imageAttr, Status status) {
        SetNativeImageAttr(imageAttr);
        lastResult = status;
    }

    VOID SetNativeImageAttr(GpImageAttributes* nativeImageAttr) {
        this.nativeImageAttr = nativeImageAttr;
    }

    Status SetStatus(Status status) {
        if (status != Status.Ok)
            return (lastResult = status);
        else
            return status;
    }

    package GpImageAttributes* nativeImageAttr;
    package Status lastResult;
}
