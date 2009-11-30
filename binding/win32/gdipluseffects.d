/*
 * gdipluseffects.d
 *
 * This module implements GdiPlusEffects.h for D. The original copyright
 * info is given below.
 *
 * Author: Dave Wilkinson
 * Originated: November 25th, 2009
 *
 */

module binding.win32.gdipluseffects;

import binding.win32.windef;
import binding.win32.winbase;
import binding.win32.winnt;
import binding.win32.guiddef;
import binding.win32.gdiplusmem;
import binding.win32.gdiplustypes;
import binding.win32.gdiplusenums;
import binding.win32.gdipluspixelformats;
import binding.win32.gdipluscolor;
import binding.win32.gdipluscolormatrix;

/**************************************************************************
*
* Copyright (c) 2001 Microsoft Corporation
*
* Module Name:
*
*   Gdiplus effect objects.
*
* Created:
*
*   05/29/2001 asecchia
*      Created it.
*
**************************************************************************/

extern(System):
version(GDIPLUS6) {

//-----------------------------------------------------------------------------
// GDI+ effect GUIDs
//-----------------------------------------------------------------------------

// {633C80A4-1843-482b-9EF2-BE2834C5FDD4}
const GUID BlurEffectGuid =
{ 0x633c80a4, 0x1843, 0x482b, [ 0x9e, 0xf2, 0xbe, 0x28, 0x34, 0xc5, 0xfd, 0xd4 ] };

// {63CBF3EE-C526-402c-8F71-62C540BF5142}
const GUID SharpenEffectGuid =
{ 0x63cbf3ee, 0xc526, 0x402c, [ 0x8f, 0x71, 0x62, 0xc5, 0x40, 0xbf, 0x51, 0x42 ] };

// {718F2615-7933-40e3-A511-5F68FE14DD74}
const GUID ColorMatrixEffectGuid =
{ 0x718f2615, 0x7933, 0x40e3, [ 0xa5, 0x11, 0x5f, 0x68, 0xfe, 0x14, 0xdd, 0x74 ] };

// {A7CE72A9-0F7F-40d7-B3CC-D0C02D5C3212}
const GUID ColorLUTEffectGuid =
{ 0xa7ce72a9, 0xf7f, 0x40d7, [ 0xb3, 0xcc, 0xd0, 0xc0, 0x2d, 0x5c, 0x32, 0x12 ] };

// {D3A1DBE1-8EC4-4c17-9F4C-EA97AD1C343D}
const GUID BrightnessContrastEffectGuid =
{ 0xd3a1dbe1, 0x8ec4, 0x4c17, [ 0x9f, 0x4c, 0xea, 0x97, 0xad, 0x1c, 0x34, 0x3d ] };

// {8B2DD6C3-EB07-4d87-A5F0-7108E26A9C5F}
const GUID HueSaturationLightnessEffectGuid =
{ 0x8b2dd6c3, 0xeb07, 0x4d87, [ 0xa5, 0xf0, 0x71, 0x8, 0xe2, 0x6a, 0x9c, 0x5f ] };

// {99C354EC-2A31-4f3a-8C34-17A803B33A25}
const GUID LevelsEffectGuid =
{ 0x99c354ec, 0x2a31, 0x4f3a, [ 0x8c, 0x34, 0x17, 0xa8, 0x3, 0xb3, 0x3a, 0x25 ] };

// {1077AF00-2848-4441-9489-44AD4C2D7A2C}
const GUID TintEffectGuid =
{ 0x1077af00, 0x2848, 0x4441, [ 0x94, 0x89, 0x44, 0xad, 0x4c, 0x2d, 0x7a, 0x2c ] };

// {537E597D-251E-48da-9664-29CA496B70F8}
const GUID ColorBalanceEffectGuid =
{ 0x537e597d, 0x251e, 0x48da, [ 0x96, 0x64, 0x29, 0xca, 0x49, 0x6b, 0x70, 0xf8 ] };

// {74D29D05-69A4-4266-9549-3CC52836B632}
const GUID RedEyeCorrectionEffectGuid =
{ 0x74d29d05, 0x69a4, 0x4266, [ 0x95, 0x49, 0x3c, 0xc5, 0x28, 0x36, 0xb6, 0x32 ] };

// {DD6A0022-58E4-4a67-9D9B-D48EB881A53D}
const GUID ColorCurveEffectGuid =
{ 0xdd6a0022, 0x58e4, 0x4a67, [ 0x9d, 0x9b, 0xd4, 0x8e, 0xb8, 0x81, 0xa5, 0x3d ] };

//-----------------------------------------------------------------------------

struct SharpenParams {
    float radius;
    float amount;
}

struct BlurParams {
    float radius;
    BOOL expandEdge;
}

struct BrightnessContrastParams {
    INT brightnessLevel;
    INT contrastLevel;
}

struct RedEyeCorrectionParams {
    UINT numberOfAreas;
    RECT *areas;
}

struct HueSaturationLightnessParams {
    INT hueLevel;
    INT saturationLevel;
    INT lightnessLevel;
}

struct TintParams {
    INT hue;
    INT amount;
}

struct LevelsParams {
    INT highlight;
    INT midtone;
    INT shadow;
}

struct ColorBalanceParams {
    INT cyanRed;
    INT magentaGreen;
    INT yellowBlue;
}

struct ColorLUTParams {
    // look up tables for each color channel.

    ColorChannelLUT lutB;
    ColorChannelLUT lutG;
    ColorChannelLUT lutR;
    ColorChannelLUT lutA;
}

enum CurveAdjustments {
    AdjustExposure,
    AdjustDensity,
    AdjustContrast,
    AdjustHighlight,
    AdjustShadow,
    AdjustMidtone,
    AdjustWhiteSaturation,
    AdjustBlackSaturation
}

enum CurveChannel {
    CurveChannelAll,
    CurveChannelRed,
    CurveChannelGreen,
    CurveChannelBlue
}

struct ColorCurveParams {
    CurveAdjustments adjustment;
    CurveChannel channel;
    INT adjustValue;
}

struct CGpEffect;

Status GdipCreateEffect(GUID guid, CGpEffect **effect);

Status GdipDeleteEffect(CGpEffect *effect);

Status GdipGetEffectParameterSize(CGpEffect *effect, UINT *size);

Status GdipSetEffectParameters(CGpEffect *effect, VOID *params, UINT size);

Status GdipGetEffectParameters(CGpEffect *effect, UINT *size, VOID *params);

class Effect {
    ~this() {
        // pvData is allocated by ApplyEffect. Return the pointer so that
        // it can be freed by the appropriate memory manager.

        GdipFree(auxData);

        // Release the native Effect.

        GdipDeleteEffect(nativeEffect);
    }

    INT GetAuxDataSize() {
        return auxDataSize;
    }

    VOID *GetAuxData() {
        return auxData;
    }

    VOID UseAuxData(BOOL useAuxDataFlag) {
        useAuxData = useAuxDataFlag;
    }

    Status GetParameterSize(UINT *size) {
        return GdipGetEffectParameterSize(nativeEffect, size);
    }

protected:

    Status SetParameters(void* params, UINT size) {
        return GdipSetEffectParameters(nativeEffect, params, size);
    }

    Status GetParameters(UINT* size, void* params) {
        return GdipGetEffectParameters(nativeEffect, size, params);
    }

    // protected data members.

    package CGpEffect *nativeEffect = null;
    package INT auxDataSize = 0;
    package VOID *auxData = null;
    package BOOL useAuxData = FALSE;
}

// Blur

class Blur : Effect {
    // constructors cannot return an error code.

    this() {
        GdipCreateEffect(BlurEffectGuid, &nativeEffect);
    }

    Status SetParameters(BlurParams *parameters) {
        UINT size = BlurParams.sizeof;
        return Effect.SetParameters(cast(void*)parameters, size);
    }

    Status GetParameters(UINT *size, BlurParams *parameters) {
        return Effect.GetParameters(size, cast(VOID*)parameters);
    }
}

// Sharpen

class Sharpen : Effect {

    this() {
        GdipCreateEffect(SharpenEffectGuid, &nativeEffect);
    }

    Status SetParameters(SharpenParams *parameters) {
        UINT size = SharpenParams.sizeof;
        return Effect.SetParameters(parameters, size);
    }

    Status GetParameters(UINT *size, SharpenParams *parameters) {
        return Effect.GetParameters(size, cast(VOID*)parameters);
    }
}

// RedEye Correction

class RedEyeCorrection : Effect {
    // constructors cannot return an error code.

    this() {
        GdipCreateEffect(RedEyeCorrectionEffectGuid, &nativeEffect);
    }

    Status SetParameters(RedEyeCorrectionParams *parameters) {
        Status status = Status.InvalidParameter;

        if (parameters) {
            RedEyeCorrectionParams *inputParam =
                cast(RedEyeCorrectionParams*)parameters;

            UINT size = RedEyeCorrectionParams.sizeof +
                inputParam.numberOfAreas * RECT.sizeof;

            status = Effect.SetParameters(parameters, size);
        }

        return status;
    }

    Status GetParameters(UINT *size, RedEyeCorrectionParams *parameters) {
        return Effect.GetParameters(size,cast(VOID*)parameters);
    }
}

// Brightness/Contrast
class BrightnessContrast : Effect {

    this() {
        GdipCreateEffect(BrightnessContrastEffectGuid, &nativeEffect);
    }

    Status SetParameters(BrightnessContrastParams *parameters) {
        UINT size = BrightnessContrastParams.sizeof;
        return Effect.SetParameters(cast(VOID*)parameters, size);
    }

    Status GetParameters(UINT *size, BrightnessContrastParams *parameters) {
        return Effect.GetParameters(size, cast(VOID*)parameters);
    }
}

// Hue/Saturation/Lightness

class HueSaturationLightness : Effect {

    this() {
        GdipCreateEffect(HueSaturationLightnessEffectGuid, &nativeEffect);
    }

    Status SetParameters(HueSaturationLightnessParams *parameters) {
        UINT size = HueSaturationLightnessParams.sizeof;
        return Effect.SetParameters(cast(VOID*)parameters, size);
    }

    Status GetParameters(UINT *size, HueSaturationLightnessParams *parameters) {
        return Effect.GetParameters(size, cast(VOID*)parameters);
    }
}

// Highlight/Midtone/Shadow curves

class Levels : Effect {

    this() {
        GdipCreateEffect(LevelsEffectGuid, &nativeEffect);
    }

    Status SetParameters(LevelsParams *parameters) {
        UINT size = LevelsParams.sizeof;
        return Effect.SetParameters(cast(VOID*)parameters, size);
    }

    Status GetParameters(UINT *size, LevelsParams *parameters) {
        return Effect.GetParameters(size, cast(VOID*)parameters);
    }
}

// Tint

class Tint : Effect {

    this() {
        GdipCreateEffect(TintEffectGuid, &nativeEffect);
    }

    Status SetParameters(TintParams *parameters) {
        UINT size = TintParams.sizeof;
        return Effect.SetParameters(cast(VOID*)parameters, size);
    }

    Status GetParameters(UINT *size, TintParams *parameters) {
        return Effect.GetParameters(size, cast(VOID*)parameters);
    }
}

// ColorBalance

class ColorBalance : Effect {

    this() {
        GdipCreateEffect(ColorBalanceEffectGuid, &nativeEffect);
    }

    Status SetParameters(ColorBalanceParams *parameters) {
        UINT size = ColorBalanceParams.sizeof;
        return Effect.SetParameters(cast(VOID*)parameters, size);
    }

    Status GetParameters(UINT *size, ColorBalanceParams *parameters) {
        return Effect.GetParameters(size, cast(VOID*)parameters);
    }
}

// ColorMatrix

class ColorMatrixEffect : Effect {

    this() {
        GdipCreateEffect(ColorMatrixEffectGuid, &nativeEffect);
    }

    Status SetParameters(ColorMatrix *matrix) {
        UINT size = ColorMatrix.sizeof;
        return Effect.SetParameters(matrix, size);
    }

    Status GetParameters(UINT *size, ColorMatrix *matrix) {
        return Effect.GetParameters(size, cast(VOID*)matrix);
    }
}


// ColorLUT

class ColorLUT : Effect {

    this() {
        GdipCreateEffect(ColorLUTEffectGuid, &nativeEffect);
    }

    Status SetParameters(ColorLUTParams *lut) {
        UINT size = ColorLUTParams.sizeof;
        return Effect.SetParameters(lut, size);
    }

    Status GetParameters(UINT *size, ColorLUTParams *lut) {
        return Effect.GetParameters(size, cast(VOID*)lut);
    }
}

// Color Curve

class ColorCurve : Effect {

    this() {
        GdipCreateEffect(ColorCurveEffectGuid, &nativeEffect);
    }

    Status SetParameters(ColorCurveParams *parameters) {
        UINT size = ColorCurveParams.sizeof;
        return Effect.SetParameters(cast(VOID*)parameters, size);
    }

    Status GetParameters(UINT *size, ColorCurveParams *parameters) {
        return Effect.GetParameters(size, cast(VOID*)parameters);
    }
}
}