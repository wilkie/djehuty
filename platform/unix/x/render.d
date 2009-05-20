/*
 * render.d
 *
 * This file holds bindings to 'render'. This file was created from render.h
 * which is provided with xrender proper. The original copyright notice is
 * displayed below, but does not pertain to this file.
 *
 * Author: Dave Wilkinson
 *
 */

/* Converted to D from render.h by htod */

module platform.unix.x.render;

/*
 * $XFree86: xc/include/extensions/render.h,v 1.10 2002/11/06 22:47:49 keithp Exp $
 *
 * Copyright © 2000 SuSE, Inc.
 *
 * Permission to use, copy, modify, distribute, and sell this software and its
 * documentation for any purpose is hereby granted without fee, provided that
 * the above copyright notice appear in all copies and that both that
 * copyright notice and this permission notice appear in supporting
 * documentation, and that the name of SuSE not be used in advertising or
 * publicity pertaining to distribution of the software without specific,
 * written prior permission.  SuSE makes no representations about the
 * suitability of this software for any purpose.  It is provided "as is"
 * without express or implied warranty.
 *
 * SuSE DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE, INCLUDING ALL
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS, IN NO EVENT SHALL SuSE
 * BE LIABLE FOR ANY SPECIAL, INDIRECT OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION
 * OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
 * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 *
 * Author:  Keith Packard, SuSE, Inc.
 */

import platform.unix.x.X;

extern (C):
alias XID Glyph;
alias XID GlyphSet;
alias XID Picture;
alias XID PictFormat;

const auto RENDER_NAME = "RENDER";
const auto RENDER_MAJOR = 0;
const auto RENDER_MINOR = 10;

const auto X_RenderQueryVersion = 0;

const auto X_RenderQueryPictFormats = 1;

const auto X_RenderQueryPictIndexValues = 2;

const auto X_RenderQueryDithers = 3;

const auto X_RenderCreatePicture = 4;

const auto X_RenderChangePicture = 5;

const auto X_RenderSetPictureClipRectangles = 6;

const auto X_RenderFreePicture = 7;

const auto X_RenderComposite = 8;

const auto X_RenderScale = 9;

const auto X_RenderTrapezoids = 10;

const auto X_RenderTriangles = 11;

const auto X_RenderTriStrip = 12;

const auto X_RenderTriFan = 13;

const auto X_RenderColorTrapezoids = 14;

const auto X_RenderColorTriangles = 15;

/* #define X_RenderTransform		    16 */

const auto X_RenderCreateGlyphSet = 17;

const auto X_RenderReferenceGlyphSet = 18;

const auto X_RenderFreeGlyphSet = 19;

const auto X_RenderAddGlyphs = 20;

const auto X_RenderAddGlyphsFromPicture = 21;

const auto X_RenderFreeGlyphs = 22;

const auto X_RenderCompositeGlyphs8 = 23;

const auto X_RenderCompositeGlyphs16 = 24;

const auto X_RenderCompositeGlyphs32 = 25;
/* 0.5 */
const auto X_RenderFillRectangles = 26;

/* 0.6 */
const auto X_RenderCreateCursor = 27;


const auto X_RenderSetPictureTransform = 28;

const auto X_RenderQueryFilters = 29;
/* 0.8 */
const auto X_RenderSetPictureFilter = 30;

/* 0.9 */
const auto X_RenderCreateAnimCursor = 31;

/* 0.10 */
const auto X_RenderAddTraps = 32;


const auto X_RenderCreateSolidFill = 33;

const auto X_RenderCreateLinearGradient = 34;

const auto X_RenderCreateRadialGradient = 35;

const auto X_RenderCreateConicalGradient = 36;




const auto BadPictFormat = 0;

const auto BadPicture = 1;

const auto BadPictOp = 2;

const auto BadGlyphSet = 3;

const auto BadGlyph = 4;


const auto PictTypeIndexed = 0;

const auto PictTypeDirect = 1;


const auto PictOpMinimum = 0;

const auto PictOpClear = 0;

const auto PictOpSrc = 1;

const auto PictOpDst = 2;

const auto PictOpOver = 3;

const auto PictOpOverReverse = 4;

const auto PictOpIn = 5;

const auto PictOpInReverse = 6;

const auto PictOpOut = 7;

const auto PictOpOutReverse = 8;

const auto PictOpAtop = 9;

const auto PictOpAtopReverse = 10;

const auto PictOpXor = 11;

const auto PictOpAdd = 12;

const auto PictOpSaturate = 13;

const auto PictOpMaximum = 13;

/*
 * Operators only available in version 0.2
 */

const auto PictOpDisjointMinimum = 0x10;

const auto PictOpDisjointClear = 0x10;

const auto PictOpDisjointSrc = 0x11;

const auto PictOpDisjointDst = 0x12;

const auto PictOpDisjointOver = 0x13;

const auto PictOpDisjointOverReverse = 0x14;

const auto PictOpDisjointIn = 0x15;

const auto PictOpDisjointInReverse = 0x16;

const auto PictOpDisjointOut = 0x17;

const auto PictOpDisjointOutReverse = 0x18;

const auto PictOpDisjointAtop = 0x19;

const auto PictOpDisjointAtopReverse = 0x1a;

const auto PictOpDisjointXor = 0x1b;

const auto PictOpDisjointMaximum = 0x1b;


const auto PictOpConjointMinimum = 0x20;

const auto PictOpConjointClear = 0x20;

const auto PictOpConjointSrc = 0x21;

const auto PictOpConjointDst = 0x22;

const auto PictOpConjointOver = 0x23;

const auto PictOpConjointOverReverse = 0x24;

const auto PictOpConjointIn = 0x25;

const auto PictOpConjointInReverse = 0x26;

const auto PictOpConjointOut = 0x27;

const auto PictOpConjointOutReverse = 0x28;

const auto PictOpConjointAtop = 0x29;

const auto PictOpConjointAtopReverse = 0x2a;

const auto PictOpConjointXor = 0x2b;

const auto PictOpConjointMaximum = 0x2b;


const auto PolyEdgeSharp = 0;

const auto PolyEdgeSmooth = 1;


const auto PolyModePrecise = 0;

const auto PolyModeImprecise = 1;

const auto CPRepeat = (1 << 0);
const auto CPAlphaMap = (1 << 1);
const auto CPAlphaXOrigin = (1 << 2);
const auto CPAlphaYOrigin = (1 << 3);
const auto CPClipXOrigin = (1 << 4);
const auto CPClipYOrigin = (1 << 5);
const auto CPClipMask = (1 << 6);
const auto CPGraphicsExposure = (1 << 7);
const auto CPSubwindowMode = (1 << 8);
const auto CPPolyEdge = (1 << 9);
const auto CPPolyMode = (1 << 10);
const auto CPDither = (1 << 11);
const auto CPComponentAlpha = (1 << 12);

const auto CPLastBit = 12;





/* Filters included in 0.6 */

const auto FilterNearest "nearest";
const auto FilterBilinear "bilinear";

/* Filters included in 0.10 */

const auto FilterConvolution "convolution";

const auto FilterFast = "fast";
const auto FilterGood = "good";
const auto FilterBest = "best";

const auto FilterAliasNone = -1;


/* Subpixel orders included in 0.6 */

const auto SubPixelUnknown = 0;

const auto SubPixelHorizontalRGB = 1;

const auto SubPixelHorizontalBGR = 2;

const auto SubPixelVerticalRGB = 3;

const auto SubPixelVerticalBGR = 4;

const auto SubPixelNone = 5;

/* Extended repeat attributes included in 0.10 */

const auto RepeatNone = 0;

const auto RepeatNormal = 1;

const auto RepeatPad = 2;

const auto RepeatReflect = 3;

