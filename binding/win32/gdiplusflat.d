/*
 * gdiplusimaging.d
 *
 * This module implements GdiPlusImaging.h for D. The original copyright
 * info is given below.
 *
 * Author: Dave Wilkinson
 * Originated: November 25th, 2009
 *
 */

module binding.win32.gdiplusflat;

import binding.win32.windef;
import binding.win32.winbase;
import binding.win32.winnt;
import binding.win32.wingdi;
import binding.win32.guiddef;
import binding.win32.gdiplustypes;
import binding.win32.gdiplusenums;
import binding.win32.gdipluspixelformats;
import binding.win32.gdiplusgpstubs;
import binding.win32.gdiplusmetaheader;
import binding.win32.gdipluspixelformats;
import binding.win32.gdipluscolor;
import binding.win32.gdipluscolormatrix;
import binding.win32.gdiplusimaging;
import binding.win32.gdipluseffects;
import binding.win32.gdipluscachedbitmap;

/**************************************************************************\
*
* Copyright (c) 1998-2001, Microsoft Corp.  All Rights Reserved.
*
* Module Name:
*
*   GdiplusFlat.h
*
* Abstract:
*
*   Private GDI+ header file.
*
\**************************************************************************/

pragma(lib, "gdiplus.lib");

extern(System):

//----------------------------------------------------------------------------
// GraphicsPath APIs
//----------------------------------------------------------------------------

GpStatus GdipCreatePath(GpFillMode brushMode, GpPath **path);

GpStatus GdipCreatePath2(GpPointF*, BYTE*, INT, GpFillMode,
                                    GpPath **path);

GpStatus GdipCreatePath2I(GpPoint*, BYTE*, INT, GpFillMode,
                                     GpPath **path);

GpStatus GdipClonePath(GpPath* path, GpPath **clonePath);

GpStatus GdipDeletePath(GpPath* path);

GpStatus GdipResetPath(GpPath* path);

GpStatus GdipGetPointCount(GpPath* path, INT* count);

GpStatus GdipGetPathTypes(GpPath* path, BYTE* types, INT count);

GpStatus GdipGetPathPoints(GpPath*, GpPointF* points, INT count);

GpStatus GdipGetPathPointsI(GpPath*, GpPoint* points, INT count);

GpStatus GdipGetPathFillMode(GpPath *path, GpFillMode *fillmode);

GpStatus GdipSetPathFillMode(GpPath *path, GpFillMode fillmode);

GpStatus GdipGetPathData(GpPath *path, GpPathData* pathData);

GpStatus GdipStartPathFigure(GpPath *path);

GpStatus GdipClosePathFigure(GpPath *path);

GpStatus GdipClosePathFigures(GpPath *path);

GpStatus GdipSetPathMarker(GpPath* path);

GpStatus GdipClearPathMarkers(GpPath* path);

GpStatus GdipReversePath(GpPath* path);

GpStatus GdipGetPathLastPoint(GpPath* path, GpPointF* lastPoint);

GpStatus GdipAddPathLine(GpPath *path, REAL x1, REAL y1, REAL x2, REAL y2);

GpStatus GdipAddPathLine2(GpPath *path, GpPointF *points, INT count);

GpStatus GdipAddPathArc(GpPath *path, REAL x, REAL y, REAL width, REAL height,
                        REAL startAngle, REAL sweepAngle);

GpStatus GdipAddPathBezier(GpPath *path, REAL x1, REAL y1, REAL x2, REAL y2,
                           REAL x3, REAL y3, REAL x4, REAL y4);

GpStatus GdipAddPathBeziers(GpPath *path, GpPointF *points, INT count);

GpStatus GdipAddPathCurve(GpPath *path, GpPointF *points, INT count);

GpStatus GdipAddPathCurve2(GpPath *path, GpPointF *points, INT count,
                           REAL tension);

GpStatus GdipAddPathCurve3(GpPath *path, GpPointF *points, INT count,
                           INT offset, INT numberOfSegments, REAL tension);

GpStatus GdipAddPathClosedCurve(GpPath *path, GpPointF *points, INT count);

GpStatus GdipAddPathClosedCurve2(GpPath *path, GpPointF *points, INT count,
                                 REAL tension);

GpStatus GdipAddPathRectangle(GpPath *path, REAL x, REAL y, REAL width, REAL height);

GpStatus GdipAddPathRectangles(GpPath *path, GpRectF *rects, INT count);

GpStatus GdipAddPathEllipse(GpPath *path, REAL x, REAL y, REAL width,
                            REAL height);

GpStatus GdipAddPathPie(GpPath *path, REAL x, REAL y, REAL width, REAL height,
                        REAL startAngle, REAL sweepAngle);

GpStatus GdipAddPathPolygon(GpPath *path, GpPointF *points, INT count);

GpStatus GdipAddPathPath(GpPath *path, GpPath* addingPath, BOOL connect);

GpStatus GdipAddPathString(GpPath *path, WCHAR *string,
                        INT length, GpFontFamily *family, INT style,
                        REAL emSize, RectF *layoutRect,
                        GpStringFormat *format);

GpStatus GdipAddPathStringI(GpPath *path, WCHAR *string,
                        INT length, GpFontFamily *family, INT style,
                        REAL emSize, Rect *layoutRect,
                        GpStringFormat *format);

GpStatus GdipAddPathLineI(GpPath *path, INT x1, INT y1, INT x2, INT y2);

GpStatus GdipAddPathLine2I(GpPath *path, GpPoint *points, INT count);

GpStatus GdipAddPathArcI(GpPath *path, INT x, INT y, INT width, INT height,
                        REAL startAngle, REAL sweepAngle);

GpStatus GdipAddPathBezierI(GpPath *path, INT x1, INT y1, INT x2, INT y2,
                           INT x3, INT y3, INT x4, INT y4);

GpStatus GdipAddPathBeziersI(GpPath *path, GpPoint *points, INT count);

GpStatus GdipAddPathCurveI(GpPath *path, GpPoint *points, INT count);

GpStatus GdipAddPathCurve2I(GpPath *path, GpPoint *points, INT count,
                           REAL tension);

GpStatus GdipAddPathCurve3I(GpPath *path, GpPoint *points, INT count,
                           INT offset, INT numberOfSegments, REAL tension);

GpStatus GdipAddPathClosedCurveI(GpPath *path, GpPoint *points, INT count);

GpStatus GdipAddPathClosedCurve2I(GpPath *path, GpPoint *points, INT count,
                                 REAL tension);

GpStatus GdipAddPathRectangleI(GpPath *path, INT x, INT y, INT width, INT height);

GpStatus GdipAddPathRectanglesI(GpPath *path, GpRect *rects, INT count);

GpStatus GdipAddPathEllipseI(GpPath *path, INT x, INT y, INT width, INT height);

GpStatus GdipAddPathPieI(GpPath *path, INT x, INT y, INT width, INT height,
                        REAL startAngle, REAL sweepAngle);

GpStatus GdipAddPathPolygonI(GpPath *path, GpPoint *points, INT count);

GpStatus GdipFlattenPath(GpPath *path, GpMatrix* matrix, REAL flatness);

GpStatus GdipWindingModeOutline(
    GpPath *path,
    GpMatrix *matrix,
    REAL flatness
);

GpStatus GdipWidenPath(
    GpPath *nativePath,
    GpPen *pen,
    GpMatrix *matrix,
    REAL flatness
);

GpStatus GdipWarpPath(GpPath *path, GpMatrix* matrix,
            GpPointF *points, INT count,
            REAL srcx, REAL srcy, REAL srcwidth, REAL srcheight,
            WarpMode warpMode, REAL flatness);

GpStatus GdipTransformPath(GpPath* path, GpMatrix* matrix);

GpStatus GdipGetPathWorldBounds(GpPath* path, GpRectF* bounds,
                       GpMatrix *matrix, GpPen *pen);

GpStatus GdipGetPathWorldBoundsI(GpPath* path, GpRect* bounds,
                        GpMatrix *matrix, GpPen *pen);

GpStatus GdipIsVisiblePathPoint(GpPath* path, REAL x, REAL y,
                       GpGraphics *graphics, BOOL *result);

GpStatus GdipIsVisiblePathPointI(GpPath* path, INT x, INT y,
                        GpGraphics *graphics, BOOL *result);

GpStatus GdipIsOutlineVisiblePathPoint(GpPath* path, REAL x, REAL y, GpPen *pen,
                              GpGraphics *graphics, BOOL *result);

GpStatus GdipIsOutlineVisiblePathPointI(GpPath* path, INT x, INT y, GpPen *pen,
                               GpGraphics *graphics, BOOL *result);


//----------------------------------------------------------------------------
// PathIterator APIs
//----------------------------------------------------------------------------

GpStatus GdipCreatePathIter(GpPathIterator **iterator, GpPath* path);

GpStatus GdipDeletePathIter(GpPathIterator *iterator);

GpStatus GdipPathIterNextSubpath(GpPathIterator* iterator, INT *resultCount,
        INT* startIndex, INT* endIndex, BOOL* isClosed);

GpStatus GdipPathIterNextSubpathPath(GpPathIterator* iterator, INT* resultCount,
        GpPath* path, BOOL* isClosed);

GpStatus GdipPathIterNextPathType(GpPathIterator* iterator, INT* resultCount,
        BYTE* pathType, INT* startIndex, INT* endIndex);

GpStatus GdipPathIterNextMarker(GpPathIterator* iterator, INT *resultCount,
        INT* startIndex, INT* endIndex);

GpStatus GdipPathIterNextMarkerPath(GpPathIterator* iterator, INT* resultCount,
        GpPath* path);

GpStatus GdipPathIterGetCount(GpPathIterator* iterator, INT* count);

GpStatus GdipPathIterGetSubpathCount(GpPathIterator* iterator, INT* count);

GpStatus GdipPathIterIsValid(GpPathIterator* iterator, BOOL* valid);

GpStatus GdipPathIterHasCurve(GpPathIterator* iterator, BOOL* hasCurve);

GpStatus GdipPathIterRewind(GpPathIterator* iterator);

GpStatus GdipPathIterEnumerate(GpPathIterator* iterator, INT* resultCount,
    GpPointF *points, BYTE *types, INT count);

GpStatus GdipPathIterCopyData(GpPathIterator* iterator, INT* resultCount,
    GpPointF* points, BYTE* types, INT startIndex, INT endIndex);

//----------------------------------------------------------------------------
// Matrix APIs
//----------------------------------------------------------------------------

GpStatus GdipCreateMatrix(GpMatrix **matrix);

GpStatus GdipCreateMatrix2(REAL m11, REAL m12, REAL m21, REAL m22, REAL dx,
                                      REAL dy, GpMatrix **matrix);

GpStatus GdipCreateMatrix3(GpRectF *rect, GpPointF *dstplg,
                                      GpMatrix **matrix);

GpStatus GdipCreateMatrix3I(GpRect *rect, GpPoint *dstplg,
                                       GpMatrix **matrix);

GpStatus GdipCloneMatrix(GpMatrix *matrix, GpMatrix **cloneMatrix);

GpStatus GdipDeleteMatrix(GpMatrix *matrix);

GpStatus GdipSetMatrixElements(GpMatrix *matrix, REAL m11, REAL m12, REAL m21, REAL m22,
                      REAL dx, REAL dy);

GpStatus GdipMultiplyMatrix(GpMatrix *matrix, GpMatrix* matrix2,
                            GpMatrixOrder order);

GpStatus GdipTranslateMatrix(GpMatrix *matrix, REAL offsetX, REAL offsetY,
                    GpMatrixOrder order);

GpStatus GdipScaleMatrix(GpMatrix *matrix, REAL scaleX, REAL scaleY,
                GpMatrixOrder order);

GpStatus GdipRotateMatrix(GpMatrix *matrix, REAL angle, GpMatrixOrder order);

GpStatus GdipShearMatrix(GpMatrix *matrix, REAL shearX, REAL shearY,
                GpMatrixOrder order);

GpStatus GdipInvertMatrix(GpMatrix *matrix);

GpStatus GdipTransformMatrixPoints(GpMatrix *matrix, GpPointF *pts, INT count);

GpStatus GdipTransformMatrixPointsI(GpMatrix *matrix, GpPoint *pts, INT count);

GpStatus GdipVectorTransformMatrixPoints(GpMatrix *matrix, GpPointF *pts,
                                         INT count);

GpStatus GdipVectorTransformMatrixPointsI(GpMatrix *matrix, GpPoint *pts,
                                         INT count);

GpStatus GdipGetMatrixElements(GpMatrix *matrix, REAL *matrixOut);

GpStatus GdipIsMatrixInvertible(GpMatrix *matrix, BOOL *result);

GpStatus GdipIsMatrixIdentity(GpMatrix *matrix, BOOL *result);

GpStatus GdipIsMatrixEqual(GpMatrix *matrix, GpMatrix *matrix2,
                  BOOL *result);

//----------------------------------------------------------------------------
// Region APIs
//----------------------------------------------------------------------------

GpStatus GdipCreateRegion(GpRegion **region);

GpStatus GdipCreateRegionRect(GpRectF *rect, GpRegion **region);

GpStatus GdipCreateRegionRectI(GpRect *rect, GpRegion **region);

GpStatus GdipCreateRegionPath(GpPath *path, GpRegion **region);

GpStatus GdipCreateRegionRgnData(BYTE *regionData, INT size,
                        GpRegion **region);

GpStatus GdipCreateRegionHrgn(HRGN hRgn, GpRegion **region);

GpStatus GdipCloneRegion(GpRegion *region, GpRegion **cloneRegion);

GpStatus GdipDeleteRegion(GpRegion *region);

GpStatus GdipSetInfinite(GpRegion *region);

GpStatus GdipSetEmpty(GpRegion *region);

GpStatus GdipCombineRegionRect(GpRegion *region, GpRectF *rect,
                      CombineMode combineMode);

GpStatus GdipCombineRegionRectI(GpRegion *region, GpRect *rect,
                       CombineMode combineMode);

GpStatus GdipCombineRegionPath(GpRegion *region, GpPath *path, CombineMode combineMode);

GpStatus GdipCombineRegionRegion(GpRegion *region,  GpRegion *region2,
                        CombineMode combineMode);

GpStatus GdipTranslateRegion(GpRegion *region, REAL dx, REAL dy);

GpStatus GdipTranslateRegionI(GpRegion *region, INT dx, INT dy);

GpStatus GdipTransformRegion(GpRegion *region, GpMatrix *matrix);

GpStatus GdipGetRegionBounds(GpRegion *region, GpGraphics *graphics,
                             GpRectF *rect);

GpStatus GdipGetRegionBoundsI(GpRegion *region, GpGraphics *graphics,
                             GpRect *rect);

GpStatus GdipGetRegionHRgn(GpRegion *region, GpGraphics *graphics, HRGN *hRgn);

GpStatus GdipIsEmptyRegion(GpRegion *region, GpGraphics *graphics,
                           BOOL *result);

GpStatus GdipIsInfiniteRegion(GpRegion *region, GpGraphics *graphics,
                              BOOL *result);

GpStatus GdipIsEqualRegion(GpRegion *region, GpRegion *region2,
                           GpGraphics *graphics, BOOL *result);

GpStatus GdipGetRegionDataSize(GpRegion *region, UINT * bufferSize);

GpStatus GdipGetRegionData(GpRegion *region, BYTE * buffer, UINT bufferSize,
                  UINT * sizeFilled);

GpStatus GdipIsVisibleRegionPoint(GpRegion *region, REAL x, REAL y,
                                  GpGraphics *graphics, BOOL *result);

GpStatus GdipIsVisibleRegionPointI(GpRegion *region, INT x, INT y,
                                  GpGraphics *graphics, BOOL *result);

GpStatus GdipIsVisibleRegionRect(GpRegion *region, REAL x, REAL y, REAL width,
                        REAL height, GpGraphics *graphics, BOOL *result);

GpStatus GdipIsVisibleRegionRectI(GpRegion *region, INT x, INT y, INT width,
                         INT height, GpGraphics *graphics, BOOL *result);

GpStatus GdipGetRegionScansCount(GpRegion *region, UINT* count, GpMatrix* matrix);

GpStatus GdipGetRegionScans(GpRegion *region, GpRectF* rects, INT* count,
                   GpMatrix* matrix);

GpStatus GdipGetRegionScansI(GpRegion *region, GpRect* rects, INT* count,
                    GpMatrix* matrix);

//----------------------------------------------------------------------------
// Brush APIs
//----------------------------------------------------------------------------

GpStatus GdipCloneBrush(GpBrush *brush, GpBrush **cloneBrush);

GpStatus GdipDeleteBrush(GpBrush *brush);

GpStatus GdipGetBrushType(GpBrush *brush, GpBrushType *type);

//----------------------------------------------------------------------------
// HatchBrush APIs
//----------------------------------------------------------------------------

GpStatus GdipCreateHatchBrush(GpHatchStyle hatchstyle, ARGB forecol,
                              ARGB backcol, GpHatch **brush);

GpStatus GdipGetHatchStyle(GpHatch *brush, GpHatchStyle *hatchstyle);

GpStatus GdipGetHatchForegroundColor(GpHatch *brush, ARGB* forecol);

GpStatus GdipGetHatchBackgroundColor(GpHatch *brush, ARGB* backcol);

//----------------------------------------------------------------------------
// TextureBrush APIs
//----------------------------------------------------------------------------

GpStatus GdipCreateTexture(GpImage *image, GpWrapMode wrapmode,
                           GpTexture **texture);

GpStatus GdipCreateTexture2(GpImage *image, GpWrapMode wrapmode, REAL x,
                   REAL y, REAL width, REAL height, GpTexture **texture);

GpStatus GdipCreateTextureIA(GpImage *image,
                    GpImageAttributes *imageAttributes,
                    REAL x, REAL y, REAL width, REAL height,
                    GpTexture **texture);

GpStatus GdipCreateTexture2I(GpImage *image, GpWrapMode wrapmode, INT x,
                    INT y, INT width, INT height, GpTexture **texture);

GpStatus GdipCreateTextureIAI(GpImage *image,
                     GpImageAttributes *imageAttributes,
                     INT x, INT y, INT width, INT height,
                     GpTexture **texture);


GpStatus GdipGetTextureTransform(GpTexture *brush, GpMatrix *matrix);

GpStatus GdipSetTextureTransform(GpTexture *brush, GpMatrix *matrix);

GpStatus GdipResetTextureTransform(GpTexture* brush);

GpStatus GdipMultiplyTextureTransform(GpTexture* brush, GpMatrix *matrix,
                            GpMatrixOrder order);

GpStatus GdipTranslateTextureTransform(GpTexture* brush, REAL dx, REAL dy,
                            GpMatrixOrder order);

GpStatus GdipScaleTextureTransform(GpTexture* brush, REAL sx, REAL sy,
                            GpMatrixOrder order);

GpStatus GdipRotateTextureTransform(GpTexture* brush, REAL angle, GpMatrixOrder order);

GpStatus GdipSetTextureWrapMode(GpTexture *brush, GpWrapMode wrapmode);

GpStatus GdipGetTextureWrapMode(GpTexture *brush, GpWrapMode *wrapmode);

GpStatus GdipGetTextureImage(GpTexture *brush, GpImage **image);

//----------------------------------------------------------------------------
// SolidBrush APIs
//----------------------------------------------------------------------------

GpStatus GdipCreateSolidFill(ARGB color, GpSolidFill **brush);

GpStatus GdipSetSolidFillColor(GpSolidFill *brush, ARGB color);

GpStatus GdipGetSolidFillColor(GpSolidFill *brush, ARGB *color);

//----------------------------------------------------------------------------
// LineBrush APIs
//----------------------------------------------------------------------------

GpStatus GdipCreateLineBrush(GpPointF* point1,
                    GpPointF* point2,
                    ARGB color1, ARGB color2,
                    GpWrapMode wrapMode,
                    GpLineGradient **lineGradient);

GpStatus GdipCreateLineBrushI(GpPoint* point1,
                     GpPoint* point2,
                     ARGB color1, ARGB color2,
                     GpWrapMode wrapMode,
                     GpLineGradient **lineGradient);

GpStatus GdipCreateLineBrushFromRect(GpRectF* rect,
                            ARGB color1, ARGB color2,
                            LinearGradientMode mode,
                            GpWrapMode wrapMode,
                            GpLineGradient **lineGradient);

GpStatus GdipCreateLineBrushFromRectI(GpRect* rect,
                             ARGB color1, ARGB color2,
                             LinearGradientMode mode,
                             GpWrapMode wrapMode,
                             GpLineGradient **lineGradient);

GpStatus GdipCreateLineBrushFromRectWithAngle(GpRectF* rect,
                                     ARGB color1, ARGB color2,
                                     REAL angle,
                                     BOOL isAngleScalable,
                                     GpWrapMode wrapMode,
                                     GpLineGradient **lineGradient);

GpStatus GdipCreateLineBrushFromRectWithAngleI(GpRect* rect,
                                     ARGB color1, ARGB color2,
                                     REAL angle,
                                     BOOL isAngleScalable,
                                     GpWrapMode wrapMode,
                                     GpLineGradient **lineGradient);

GpStatus GdipSetLineColors(GpLineGradient *brush, ARGB color1, ARGB color2);

GpStatus GdipGetLineColors(GpLineGradient *brush, ARGB* colors);

GpStatus GdipGetLineRect(GpLineGradient *brush, GpRectF *rect);

GpStatus GdipGetLineRectI(GpLineGradient *brush, GpRect *rect);

GpStatus GdipSetLineGammaCorrection(GpLineGradient *brush, BOOL useGammaCorrection);

GpStatus GdipGetLineGammaCorrection(GpLineGradient *brush, BOOL *useGammaCorrection);

GpStatus GdipGetLineBlendCount(GpLineGradient *brush, INT *count);

GpStatus GdipGetLineBlend(GpLineGradient *brush, REAL *blend, REAL* positions,
                 INT count);

GpStatus GdipSetLineBlend(GpLineGradient *brush, REAL *blend,
                 REAL* positions, INT count);

GpStatus GdipGetLinePresetBlendCount(GpLineGradient *brush, INT *count);

GpStatus GdipGetLinePresetBlend(GpLineGradient *brush, ARGB *blend,
                                           REAL* positions, INT count);

GpStatus GdipSetLinePresetBlend(GpLineGradient *brush, ARGB *blend,
                       REAL* positions, INT count);

GpStatus GdipSetLineSigmaBlend(GpLineGradient *brush, REAL focus, REAL scale);

GpStatus GdipSetLineLinearBlend(GpLineGradient *brush, REAL focus, REAL scale);

GpStatus GdipSetLineWrapMode(GpLineGradient *brush, GpWrapMode wrapmode);

GpStatus GdipGetLineWrapMode(GpLineGradient *brush, GpWrapMode *wrapmode);

GpStatus GdipGetLineTransform(GpLineGradient *brush, GpMatrix *matrix);

GpStatus GdipSetLineTransform(GpLineGradient *brush, GpMatrix *matrix);

GpStatus GdipResetLineTransform(GpLineGradient* brush);

GpStatus GdipMultiplyLineTransform(GpLineGradient* brush, GpMatrix *matrix,
                            GpMatrixOrder order);

GpStatus GdipTranslateLineTransform(GpLineGradient* brush, REAL dx, REAL dy,
                            GpMatrixOrder order);

GpStatus GdipScaleLineTransform(GpLineGradient* brush, REAL sx, REAL sy,
                            GpMatrixOrder order);

GpStatus GdipRotateLineTransform(GpLineGradient* brush, REAL angle,
                        GpMatrixOrder order);

//----------------------------------------------------------------------------
// PathGradientBrush APIs
//----------------------------------------------------------------------------

GpStatus GdipCreatePathGradient(GpPointF* points,
                                    INT count,
                                    GpWrapMode wrapMode,
                                    GpPathGradient **polyGradient);

GpStatus GdipCreatePathGradientI(GpPoint* points,
                                    INT count,
                                    GpWrapMode wrapMode,
                                    GpPathGradient **polyGradient);

GpStatus GdipCreatePathGradientFromPath(GpPath* path,
                                    GpPathGradient **polyGradient);

GpStatus GdipGetPathGradientCenterColor(
                        GpPathGradient *brush, ARGB* colors);

GpStatus GdipSetPathGradientCenterColor(
                        GpPathGradient *brush, ARGB colors);

GpStatus GdipGetPathGradientSurroundColorsWithCount(
                        GpPathGradient *brush, ARGB* color, INT* count);

GpStatus GdipSetPathGradientSurroundColorsWithCount(
                        GpPathGradient *brush,
                        ARGB* color, INT* count);

GpStatus GdipGetPathGradientPath(GpPathGradient *brush, GpPath *path);

GpStatus GdipSetPathGradientPath(GpPathGradient *brush, GpPath *path);

GpStatus GdipGetPathGradientCenterPoint(
                        GpPathGradient *brush, GpPointF* points);

GpStatus GdipGetPathGradientCenterPointI(
                        GpPathGradient *brush, GpPoint* points);

GpStatus GdipSetPathGradientCenterPoint(
                        GpPathGradient *brush, GpPointF* points);

GpStatus GdipSetPathGradientCenterPointI(
                        GpPathGradient *brush, GpPoint* points);

GpStatus GdipGetPathGradientRect(GpPathGradient *brush, GpRectF *rect);

GpStatus GdipGetPathGradientRectI(GpPathGradient *brush, GpRect *rect);

GpStatus GdipGetPathGradientPointCount(GpPathGradient *brush, INT* count);

GpStatus GdipGetPathGradientSurroundColorCount(GpPathGradient *brush, INT* count);

GpStatus GdipSetPathGradientGammaCorrection(GpPathGradient *brush,
                                   BOOL useGammaCorrection);

GpStatus GdipGetPathGradientGammaCorrection(GpPathGradient *brush,
                                   BOOL *useGammaCorrection);

GpStatus GdipGetPathGradientBlendCount(GpPathGradient *brush,
                                             INT *count);

GpStatus GdipGetPathGradientBlend(GpPathGradient *brush,
                                    REAL *blend, REAL *positions, INT count);

GpStatus GdipSetPathGradientBlend(GpPathGradient *brush,
                REAL *blend, REAL *positions, INT count);

GpStatus GdipGetPathGradientPresetBlendCount(GpPathGradient *brush, INT *count);

GpStatus GdipGetPathGradientPresetBlend(GpPathGradient *brush, ARGB *blend,
                                                REAL* positions, INT count);

GpStatus GdipSetPathGradientPresetBlend(GpPathGradient *brush, ARGB *blend,
                                        REAL* positions, INT count);

GpStatus GdipSetPathGradientSigmaBlend(GpPathGradient *brush, REAL focus, REAL scale);

GpStatus GdipSetPathGradientLinearBlend(GpPathGradient *brush, REAL focus, REAL scale);

GpStatus GdipGetPathGradientWrapMode(GpPathGradient *brush,
                                         GpWrapMode *wrapmode);

GpStatus GdipSetPathGradientWrapMode(GpPathGradient *brush,
                                         GpWrapMode wrapmode);

GpStatus GdipGetPathGradientTransform(GpPathGradient *brush,
                                          GpMatrix *matrix);

GpStatus GdipSetPathGradientTransform(GpPathGradient *brush,
                                          GpMatrix *matrix);

GpStatus GdipResetPathGradientTransform(GpPathGradient* brush);

GpStatus GdipMultiplyPathGradientTransform(GpPathGradient* brush,
                                  GpMatrix *matrix,
                                  GpMatrixOrder order);

GpStatus GdipTranslatePathGradientTransform(GpPathGradient* brush, REAL dx, REAL dy,
                                   GpMatrixOrder order);

GpStatus GdipScalePathGradientTransform(GpPathGradient* brush, REAL sx, REAL sy,
                               GpMatrixOrder order);

GpStatus GdipRotatePathGradientTransform(GpPathGradient* brush, REAL angle,
                                GpMatrixOrder order);

GpStatus GdipGetPathGradientFocusScales(GpPathGradient *brush, REAL* xScale,
                               REAL* yScale);

GpStatus GdipSetPathGradientFocusScales(GpPathGradient *brush, REAL xScale,
                               REAL yScale);

//----------------------------------------------------------------------------
// Pen APIs
//----------------------------------------------------------------------------

GpStatus GdipCreatePen1(ARGB color, REAL width, GpUnit unit, GpPen **pen);

GpStatus GdipCreatePen2(GpBrush *brush, REAL width, GpUnit unit,
                        GpPen **pen);

GpStatus GdipClonePen(GpPen *pen, GpPen **clonepen);

GpStatus GdipDeletePen(GpPen *pen);

GpStatus GdipSetPenWidth(GpPen *pen, REAL width);

GpStatus GdipGetPenWidth(GpPen *pen, REAL *width);

GpStatus GdipSetPenUnit(GpPen *pen, GpUnit unit);

GpStatus GdipGetPenUnit(GpPen *pen, GpUnit *unit);

GpStatus GdipSetPenLineCap197819(GpPen *pen, GpLineCap startCap, GpLineCap endCap,
                  GpDashCap dashCap);

GpStatus GdipSetPenStartCap(GpPen *pen, GpLineCap startCap);

GpStatus GdipSetPenEndCap(GpPen *pen, GpLineCap endCap);

GpStatus GdipSetPenDashCap197819(GpPen *pen, GpDashCap dashCap);

GpStatus GdipGetPenStartCap(GpPen *pen, GpLineCap *startCap);

GpStatus GdipGetPenEndCap(GpPen *pen, GpLineCap *endCap);

GpStatus GdipGetPenDashCap197819(GpPen *pen, GpDashCap *dashCap);

GpStatus GdipSetPenLineJoin(GpPen *pen, GpLineJoin lineJoin);

GpStatus GdipGetPenLineJoin(GpPen *pen, GpLineJoin *lineJoin);

GpStatus GdipSetPenCustomStartCap(GpPen *pen, GpCustomLineCap* customCap);

GpStatus GdipGetPenCustomStartCap(GpPen *pen, GpCustomLineCap** customCap);

GpStatus GdipSetPenCustomEndCap(GpPen *pen, GpCustomLineCap* customCap);

GpStatus GdipGetPenCustomEndCap(GpPen *pen, GpCustomLineCap** customCap);

GpStatus GdipSetPenMiterLimit(GpPen *pen, REAL miterLimit);

GpStatus GdipGetPenMiterLimit(GpPen *pen, REAL *miterLimit);

GpStatus GdipSetPenMode(GpPen *pen, GpPenAlignment penMode);

GpStatus GdipGetPenMode(GpPen *pen, GpPenAlignment *penMode);

GpStatus GdipSetPenTransform(GpPen *pen, GpMatrix *matrix);

GpStatus GdipGetPenTransform(GpPen *pen, GpMatrix *matrix);

GpStatus GdipResetPenTransform(GpPen *pen);

GpStatus GdipMultiplyPenTransform(GpPen *pen, GpMatrix *matrix,
                           GpMatrixOrder order);

GpStatus GdipTranslatePenTransform(GpPen *pen, REAL dx, REAL dy,
                            GpMatrixOrder order);

GpStatus GdipScalePenTransform(GpPen *pen, REAL sx, REAL sy,
                            GpMatrixOrder order);

GpStatus GdipRotatePenTransform(GpPen *pen, REAL angle, GpMatrixOrder order);

GpStatus GdipSetPenColor(GpPen *pen, ARGB argb);

GpStatus GdipGetPenColor(GpPen *pen, ARGB *argb);

GpStatus GdipSetPenBrushFill(GpPen *pen, GpBrush *brush);

GpStatus GdipGetPenBrushFill(GpPen *pen, GpBrush **brush);

GpStatus GdipGetPenFillType(GpPen *pen, GpPenType* type);

GpStatus GdipGetPenDashStyle(GpPen *pen, GpDashStyle *dashstyle);

GpStatus GdipSetPenDashStyle(GpPen *pen, GpDashStyle dashstyle);

GpStatus GdipGetPenDashOffset(GpPen *pen, REAL *offset);

GpStatus GdipSetPenDashOffset(GpPen *pen, REAL offset);

GpStatus GdipGetPenDashCount(GpPen *pen, INT *count);

GpStatus GdipSetPenDashArray(GpPen *pen, REAL *dash, INT count);

GpStatus GdipGetPenDashArray(GpPen *pen, REAL *dash, INT count);

GpStatus GdipGetPenCompoundCount(GpPen *pen, INT *count);

GpStatus GdipSetPenCompoundArray(GpPen *pen, REAL *dash, INT count);

GpStatus GdipGetPenCompoundArray(GpPen *pen, REAL *dash, INT count);

//----------------------------------------------------------------------------
// CustomLineCap APIs
//----------------------------------------------------------------------------

GpStatus GdipCreateCustomLineCap(GpPath* fillPath, GpPath* strokePath,
   GpLineCap baseCap, REAL baseInset, GpCustomLineCap **customCap);

GpStatus GdipDeleteCustomLineCap(GpCustomLineCap* customCap);

GpStatus GdipCloneCustomLineCap(GpCustomLineCap* customCap,
                       GpCustomLineCap** clonedCap);

GpStatus GdipGetCustomLineCapType(GpCustomLineCap* customCap,
                       CustomLineCapType* capType);

GpStatus GdipSetCustomLineCapStrokeCaps(GpCustomLineCap* customCap,
                               GpLineCap startCap, GpLineCap endCap);

GpStatus GdipGetCustomLineCapStrokeCaps(GpCustomLineCap* customCap,
                               GpLineCap* startCap, GpLineCap* endCap);

GpStatus GdipSetCustomLineCapStrokeJoin(GpCustomLineCap* customCap,
                               GpLineJoin lineJoin);

GpStatus GdipGetCustomLineCapStrokeJoin(GpCustomLineCap* customCap,
                               GpLineJoin* lineJoin);

GpStatus GdipSetCustomLineCapBaseCap(GpCustomLineCap* customCap, GpLineCap baseCap);

GpStatus GdipGetCustomLineCapBaseCap(GpCustomLineCap* customCap, GpLineCap* baseCap);

GpStatus GdipSetCustomLineCapBaseInset(GpCustomLineCap* customCap, REAL inset);

GpStatus GdipGetCustomLineCapBaseInset(GpCustomLineCap* customCap, REAL* inset);

GpStatus GdipSetCustomLineCapWidthScale(GpCustomLineCap* customCap, REAL widthScale);

GpStatus GdipGetCustomLineCapWidthScale(GpCustomLineCap* customCap, REAL* widthScale);

//----------------------------------------------------------------------------
// AdjustableArrowCap APIs
//----------------------------------------------------------------------------

GpStatus GdipCreateAdjustableArrowCap(REAL height, REAL width, BOOL isFilled,
                             GpAdjustableArrowCap **cap);

GpStatus GdipSetAdjustableArrowCapHeight(GpAdjustableArrowCap* cap, REAL height);

GpStatus GdipGetAdjustableArrowCapHeight(GpAdjustableArrowCap* cap, REAL* height);

GpStatus GdipSetAdjustableArrowCapWidth(GpAdjustableArrowCap* cap, REAL width);

GpStatus GdipGetAdjustableArrowCapWidth(GpAdjustableArrowCap* cap, REAL* width);

GpStatus GdipSetAdjustableArrowCapMiddleInset(GpAdjustableArrowCap* cap,
                                     REAL middleInset);

GpStatus GdipGetAdjustableArrowCapMiddleInset(GpAdjustableArrowCap* cap,
                                     REAL* middleInset);

GpStatus GdipSetAdjustableArrowCapFillState(GpAdjustableArrowCap* cap, BOOL fillState);

GpStatus GdipGetAdjustableArrowCapFillState(GpAdjustableArrowCap* cap, BOOL* fillState);

//----------------------------------------------------------------------------
// Image APIs
//----------------------------------------------------------------------------

//GpStatus GdipLoadImageFromStream(IStream* stream, GpImage **image);

GpStatus GdipLoadImageFromFile(WCHAR* filename, GpImage **image);

//GpStatus GdipLoadImageFromStreamICM(IStream* stream, GpImage **image);

GpStatus GdipLoadImageFromFileICM(WCHAR* filename, GpImage **image);

GpStatus GdipCloneImage(GpImage *image, GpImage **cloneImage);

GpStatus GdipDisposeImage(GpImage *image);

GpStatus GdipSaveImageToFile(GpImage *image, WCHAR* filename,
                    CLSID* clsidEncoder,
                    EncoderParameters* encoderParams);

//GpStatus GdipSaveImageToStream(GpImage *image, IStream* stream,
//                      CLSID* clsidEncoder,
//                      EncoderParameters* encoderParams);

GpStatus GdipSaveAdd(GpImage *image, EncoderParameters* encoderParams);

GpStatus GdipSaveAddImage(GpImage *image, GpImage* newImage,
                 EncoderParameters* encoderParams);

GpStatus GdipGetImageGraphicsContext(GpImage *image, GpGraphics **graphics);

GpStatus GdipGetImageBounds(GpImage *image, GpRectF *srcRect, GpUnit *srcUnit);

GpStatus GdipGetImageDimension(GpImage *image, REAL *width, REAL *height);

GpStatus GdipGetImageType(GpImage *image, ImageType *type);

GpStatus GdipGetImageWidth(GpImage *image, UINT *width);

GpStatus GdipGetImageHeight(GpImage *image, UINT *height);

GpStatus GdipGetImageHorizontalResolution(GpImage *image, REAL *resolution);

GpStatus GdipGetImageVerticalResolution(GpImage *image, REAL *resolution);

GpStatus GdipGetImageFlags(GpImage *image, UINT *flags);

GpStatus GdipGetImageRawFormat(GpImage *image, GUID *format);

GpStatus GdipGetImagePixelFormat(GpImage *image, PixelFormat *format);

GpStatus GdipGetImageThumbnail(GpImage *image, UINT thumbWidth, UINT thumbHeight,
                      GpImage **thumbImage,
                      GetThumbnailImageAbort callback, VOID * callbackData);

GpStatus GdipGetEncoderParameterListSize(GpImage *image, CLSID* clsidEncoder,
                                UINT* size);

GpStatus GdipGetEncoderParameterList(GpImage *image, CLSID* clsidEncoder,
                            UINT size, EncoderParameters* buffer);

GpStatus GdipImageGetFrameDimensionsCount(GpImage* image, UINT* count);

GpStatus GdipImageGetFrameDimensionsList(GpImage* image, GUID* dimensionIDs,
                                UINT count);

GpStatus GdipImageGetFrameCount(GpImage *image, GUID* dimensionID,
                       UINT* count);

GpStatus GdipImageSelectActiveFrame(GpImage *image, GUID* dimensionID,
                           UINT frameIndex);

GpStatus GdipImageRotateFlip(GpImage *image, RotateFlipType rfType);

GpStatus GdipGetImagePalette(GpImage *image, ColorPalette *palette, INT size);

GpStatus GdipSetImagePalette(GpImage *image, ColorPalette *palette);

GpStatus GdipGetImagePaletteSize(GpImage *image, INT *size);

GpStatus GdipGetPropertyCount(GpImage *image, UINT* numOfProperty);

GpStatus GdipGetPropertyIdList(GpImage *image, UINT numOfProperty, PROPID* list);

GpStatus GdipGetPropertyItemSize(GpImage *image, PROPID propId, UINT* size);

GpStatus GdipGetPropertyItem(GpImage *image, PROPID propId,UINT propSize,
                    PropertyItem* buffer);

GpStatus GdipGetPropertySize(GpImage *image, UINT* totalBufferSize,
                    UINT* numProperties);

GpStatus GdipGetAllPropertyItems(GpImage *image, UINT totalBufferSize,
                        UINT numProperties, PropertyItem* allItems);

GpStatus GdipRemovePropertyItem(GpImage *image, PROPID propId);

GpStatus GdipSetPropertyItem(GpImage *image, PropertyItem* item);

version(GDIPLUS6) {
GpStatus GdipFindFirstImageItem(GpImage *image, ImageItemData* item);

GpStatus GdipFindNextImageItem(GpImage *image, ImageItemData* item);

GpStatus GdipGetImageItemData(GpImage *image, ImageItemData* item);
}

GpStatus GdipImageForceValidation(GpImage *image);

//----------------------------------------------------------------------------
// Bitmap APIs
//----------------------------------------------------------------------------

//GpStatus GdipCreateBitmapFromStream(IStream* stream, GpBitmap **bitmap);

GpStatus GdipCreateBitmapFromFile(WCHAR* filename, GpBitmap **bitmap);

//GpStatus GdipCreateBitmapFromStreamICM(IStream* stream, GpBitmap **bitmap);

GpStatus GdipCreateBitmapFromFileICM(WCHAR* filename, GpBitmap **bitmap);

GpStatus GdipCreateBitmapFromScan0(INT width,
                          INT height,
                          INT stride,
                          PixelFormat format,
                          BYTE* scan0,
                          GpBitmap** bitmap);

GpStatus GdipCreateBitmapFromGraphics(INT width,
                             INT height,
                             GpGraphics* target,
                             GpBitmap** bitmap);

GpStatus GdipCreateBitmapFromDirectDrawSurface(IDirectDrawSurface7* surface,
                                      GpBitmap** bitmap);

GpStatus GdipCreateBitmapFromGdiDib(BITMAPINFO* gdiBitmapInfo,
                           VOID* gdiBitmapData,
                           GpBitmap** bitmap);

GpStatus GdipCreateBitmapFromHBITMAP(HBITMAP hbm,
                            HPALETTE hpal,
                            GpBitmap** bitmap);

GpStatus GdipCreateHBITMAPFromBitmap(GpBitmap* bitmap,
                            HBITMAP* hbmReturn,
                            ARGB background);

GpStatus GdipCreateBitmapFromHICON(HICON hicon,
                          GpBitmap** bitmap);

GpStatus GdipCreateHICONFromBitmap(GpBitmap* bitmap,
                          HICON* hbmReturn);

GpStatus GdipCreateBitmapFromResource(HINSTANCE hInstance,
                             WCHAR* lpBitmapName,
                             GpBitmap** bitmap);

GpStatus GdipCloneBitmapArea(REAL x, REAL y, REAL width, REAL height,
                            PixelFormat format,
                            GpBitmap *srcBitmap,
                            GpBitmap **dstBitmap);

GpStatus GdipCloneBitmapAreaI(INT x,
                     INT y,
                     INT width,
                     INT height,
                     PixelFormat format,
                     GpBitmap *srcBitmap,
                     GpBitmap **dstBitmap);

GpStatus GdipBitmapLockBits(GpBitmap* bitmap,
                   GpRect* rect,
                   UINT flags,
                   PixelFormat format,
                   BitmapData* lockedBitmapData);

GpStatus GdipBitmapUnlockBits(GpBitmap* bitmap,
                     BitmapData* lockedBitmapData);

GpStatus GdipBitmapGetPixel(GpBitmap* bitmap, INT x, INT y, ARGB *color);

GpStatus GdipBitmapSetPixel(GpBitmap* bitmap, INT x, INT y, ARGB color);

version(GDIPLUS6) {
GpStatus GdipImageSetAbort(
    GpImage *pImage,
    GdiplusAbort *pIAbort
    );

GpStatus GdipGraphicsSetAbort(
    GpGraphics *pGraphics,
    GdiplusAbort *pIAbort
    );

GpStatus GdipBitmapConvertFormat(
    GpBitmap *pInputBitmap,
    PixelFormat format,
    DitherType dithertype,
    PaletteType palettetype,
    ColorPalette *palette,
    REAL alphaThresholdPercent
    );

GpStatus GdipInitializePalette(
    ColorPalette *palette,   // output palette. must be allocated.
    PaletteType palettetype,     // palette enumeration type.
    INT optimalColors,           // how many optimal colors
    BOOL useTransparentColor,    // add a transparent color to the palette.
    GpBitmap *bitmap             // optional bitmap for median cut.
    );

GpStatus GdipBitmapApplyEffect(
    GpBitmap* bitmap,
    CGpEffect *effect,
    RECT *roi,
    BOOL useAuxData,
    VOID **auxData,
    INT *auxDataSize
    );

GpStatus GdipBitmapCreateApplyEffect(
    GpBitmap **inputBitmaps,
    INT numInputs,
    CGpEffect *effect,
    RECT *roi,
    RECT *outputRect,
    GpBitmap **outputBitmap,
    BOOL useAuxData,
    VOID **auxData,
    INT *auxDataSize
);

GpStatus GdipBitmapGetHistogram(
    GpBitmap* bitmap,
    HistogramFormat format,
    UINT NumberOfEntries,
    UINT *channel0,
    UINT *channel1,
    UINT *channel2,
    UINT *channel3
);

GpStatus GdipBitmapGetHistogramSize(
    HistogramFormat format,
    UINT *NumberOfEntries
);
}

GpStatus GdipBitmapSetResolution(GpBitmap* bitmap, REAL xdpi, REAL ydpi);

//----------------------------------------------------------------------------
// ImageAttributes APIs
//----------------------------------------------------------------------------

GpStatus GdipCreateImageAttributes(GpImageAttributes **imageattr);

GpStatus GdipCloneImageAttributes(GpImageAttributes *imageattr,
                         GpImageAttributes **cloneImageattr);

GpStatus GdipDisposeImageAttributes(GpImageAttributes *imageattr);

GpStatus GdipSetImageAttributesToIdentity(GpImageAttributes *imageattr,
                                 ColorAdjustType type);
GpStatus GdipResetImageAttributes(GpImageAttributes *imageattr,
                         ColorAdjustType type);

GpStatus GdipSetImageAttributesColorMatrix(GpImageAttributes *imageattr,
                               ColorAdjustType type,
                               BOOL enableFlag,
                               ColorMatrix* colorMatrix,
                               ColorMatrix* grayMatrix,
                               ColorMatrixFlags flags);

GpStatus GdipSetImageAttributesThreshold(GpImageAttributes *imageattr,
                                ColorAdjustType type,
                                BOOL enableFlag,
                                REAL threshold);

GpStatus GdipSetImageAttributesGamma(GpImageAttributes *imageattr,
                            ColorAdjustType type,
                            BOOL enableFlag,
                            REAL gamma);

GpStatus GdipSetImageAttributesNoOp(GpImageAttributes *imageattr,
                           ColorAdjustType type,
                           BOOL enableFlag);

GpStatus GdipSetImageAttributesColorKeys(GpImageAttributes *imageattr,
                                ColorAdjustType type,
                                BOOL enableFlag,
                                ARGB colorLow,
                                ARGB colorHigh);

GpStatus GdipSetImageAttributesOutputChannel(GpImageAttributes *imageattr,
                                    ColorAdjustType type,
                                    BOOL enableFlag,
                                    ColorChannelFlags channelFlags);

GpStatus GdipSetImageAttributesOutputChannelColorProfile(GpImageAttributes *imageattr,
                                                ColorAdjustType type,
                                                BOOL enableFlag,
                                                  WCHAR *colorProfileFilename);

GpStatus GdipSetImageAttributesRemapTable(GpImageAttributes *imageattr,
                                 ColorAdjustType type,
                                 BOOL enableFlag,
                                 UINT mapSize,
                                 ColorMap *map);
GpStatus GdipSetImageAttributesWrapMode(
    GpImageAttributes *imageAttr,
    WrapMode wrap,
    ARGB argb,
    BOOL clamp
);

GpStatus GdipSetImageAttributesICMMode(
    GpImageAttributes *imageAttr,
    BOOL on
);

GpStatus GdipGetImageAttributesAdjustedPalette(
    GpImageAttributes *imageAttr,
    ColorPalette * colorPalette,
    ColorAdjustType colorAdjustType
);

//----------------------------------------------------------------------------
// Graphics APIs
//----------------------------------------------------------------------------

GpStatus GdipFlush(GpGraphics *graphics, GpFlushIntention intention);

GpStatus GdipCreateFromHDC(HDC hdc, GpGraphics **graphics);

GpStatus GdipCreateFromHDC2(HDC hdc, HANDLE hDevice, GpGraphics **graphics);

GpStatus GdipCreateFromHWND(HWND hwnd, GpGraphics **graphics);

GpStatus GdipCreateFromHWNDICM(HWND hwnd, GpGraphics **graphics);

GpStatus GdipDeleteGraphics(GpGraphics *graphics);

GpStatus GdipGetDC(GpGraphics* graphics, HDC * hdc);

GpStatus GdipReleaseDC(GpGraphics* graphics, HDC hdc);

GpStatus GdipSetCompositingMode(GpGraphics *graphics, CompositingMode compositingMode);

GpStatus GdipGetCompositingMode(GpGraphics *graphics, CompositingMode *compositingMode);

GpStatus GdipSetRenderingOrigin(GpGraphics *graphics, INT x, INT y);

GpStatus GdipGetRenderingOrigin(GpGraphics *graphics, INT *x, INT *y);

GpStatus GdipSetCompositingQuality(GpGraphics *graphics,
                          CompositingQuality compositingQuality);

GpStatus GdipGetCompositingQuality(GpGraphics *graphics,
                          CompositingQuality *compositingQuality);

GpStatus GdipSetSmoothingMode(GpGraphics *graphics, SmoothingMode smoothingMode);

GpStatus GdipGetSmoothingMode(GpGraphics *graphics, SmoothingMode *smoothingMode);

GpStatus GdipSetPixelOffsetMode(GpGraphics* graphics, PixelOffsetMode pixelOffsetMode);

GpStatus GdipGetPixelOffsetMode(GpGraphics *graphics, PixelOffsetMode *pixelOffsetMode);

GpStatus GdipSetTextRenderingHint(GpGraphics *graphics, TextRenderingHint mode);

GpStatus GdipGetTextRenderingHint(GpGraphics *graphics, TextRenderingHint *mode);

GpStatus GdipSetTextContrast(GpGraphics *graphics, UINT contrast);

GpStatus GdipGetTextContrast(GpGraphics *graphics, UINT * contrast);

GpStatus GdipSetInterpolationMode(GpGraphics *graphics,
                         InterpolationMode interpolationMode);

GpStatus GdipGetInterpolationMode(GpGraphics *graphics,
                         InterpolationMode *interpolationMode);

GpStatus GdipSetWorldTransform(GpGraphics *graphics, GpMatrix *matrix);

GpStatus GdipResetWorldTransform(GpGraphics *graphics);

GpStatus GdipMultiplyWorldTransform(GpGraphics *graphics, GpMatrix *matrix,
                           GpMatrixOrder order);

GpStatus GdipTranslateWorldTransform(GpGraphics *graphics, REAL dx, REAL dy,
                            GpMatrixOrder order);

GpStatus GdipScaleWorldTransform(GpGraphics *graphics, REAL sx, REAL sy,
                        GpMatrixOrder order);

GpStatus GdipRotateWorldTransform(GpGraphics *graphics, REAL angle,
                         GpMatrixOrder order);

GpStatus GdipGetWorldTransform(GpGraphics *graphics, GpMatrix *matrix);

GpStatus GdipResetPageTransform(GpGraphics *graphics);

GpStatus GdipGetPageUnit(GpGraphics *graphics, GpUnit *unit);

GpStatus GdipGetPageScale(GpGraphics *graphics, REAL *scale);

GpStatus GdipSetPageUnit(GpGraphics *graphics, GpUnit unit);

GpStatus GdipSetPageScale(GpGraphics *graphics, REAL scale);

GpStatus GdipGetDpiX(GpGraphics *graphics, REAL* dpi);

GpStatus GdipGetDpiY(GpGraphics *graphics, REAL* dpi);

GpStatus GdipTransformPoints(GpGraphics *graphics, GpCoordinateSpace destSpace,
                             GpCoordinateSpace srcSpace, GpPointF *points,
                             INT count);

GpStatus GdipTransformPointsI(GpGraphics *graphics, GpCoordinateSpace destSpace,
                             GpCoordinateSpace srcSpace, GpPoint *points,
                             INT count);

GpStatus GdipGetNearestColor(GpGraphics *graphics, ARGB* argb);

// Creates the Win9x Halftone Palette (even on NT) with correct Desktop colors
HPALETTE GdipCreateHalftonePalette();

GpStatus GdipDrawLine(GpGraphics *graphics, GpPen *pen, REAL x1, REAL y1,
                      REAL x2, REAL y2);

GpStatus GdipDrawLineI(GpGraphics *graphics, GpPen *pen, INT x1, INT y1,
                      INT x2, INT y2);

GpStatus GdipDrawLines(GpGraphics *graphics, GpPen *pen, GpPointF *points,
                       INT count);

GpStatus GdipDrawLinesI(GpGraphics *graphics, GpPen *pen, GpPoint *points,
                       INT count);

GpStatus GdipDrawArc(GpGraphics *graphics, GpPen *pen, REAL x, REAL y,
            REAL width, REAL height, REAL startAngle, REAL sweepAngle);

GpStatus GdipDrawArcI(GpGraphics *graphics, GpPen *pen, INT x, INT y,
                     INT width, INT height, REAL startAngle, REAL sweepAngle);

GpStatus GdipDrawBezier(GpGraphics *graphics, GpPen *pen, REAL x1, REAL y1,
                        REAL x2, REAL y2, REAL x3, REAL y3, REAL x4, REAL y4);

GpStatus GdipDrawBezierI(GpGraphics *graphics, GpPen *pen, INT x1, INT y1,
                        INT x2, INT y2, INT x3, INT y3, INT x4, INT y4);

GpStatus GdipDrawBeziers(GpGraphics *graphics, GpPen *pen, GpPointF *points,
                         INT count);

GpStatus GdipDrawBeziersI(GpGraphics *graphics, GpPen *pen, GpPoint *points,
                         INT count);

GpStatus GdipDrawRectangle(GpGraphics *graphics, GpPen *pen, REAL x, REAL y,
                      REAL width, REAL height);

GpStatus GdipDrawRectangleI(GpGraphics *graphics, GpPen *pen, INT x, INT y,
                      INT width, INT height);

GpStatus GdipDrawRectangles(GpGraphics *graphics, GpPen *pen, GpRectF *rects,
                       INT count);

GpStatus GdipDrawRectanglesI(GpGraphics *graphics, GpPen *pen, GpRect *rects,
                       INT count);

GpStatus GdipDrawEllipse(GpGraphics *graphics, GpPen *pen, REAL x, REAL y,
                         REAL width, REAL height);

GpStatus GdipDrawEllipseI(GpGraphics *graphics, GpPen *pen, INT x, INT y,
                         INT width, INT height);

GpStatus GdipDrawPie(GpGraphics *graphics, GpPen *pen, REAL x, REAL y,
                     REAL width, REAL height, REAL startAngle,
            REAL sweepAngle);

GpStatus GdipDrawPieI(GpGraphics *graphics, GpPen *pen, INT x, INT y,
                     INT width, INT height, REAL startAngle, REAL sweepAngle);

GpStatus GdipDrawPolygon(GpGraphics *graphics, GpPen *pen, GpPointF *points,
                         INT count);

GpStatus GdipDrawPolygonI(GpGraphics *graphics, GpPen *pen, GpPoint *points,
                         INT count);

GpStatus GdipDrawPath(GpGraphics *graphics, GpPen *pen, GpPath *path);

GpStatus GdipDrawCurve(GpGraphics *graphics, GpPen *pen, GpPointF *points,
                       INT count);

GpStatus GdipDrawCurveI(GpGraphics *graphics, GpPen *pen, GpPoint *points,
                       INT count);

GpStatus GdipDrawCurve2(GpGraphics *graphics, GpPen *pen, GpPointF *points,
                       INT count, REAL tension);

GpStatus GdipDrawCurve2I(GpGraphics *graphics, GpPen *pen, GpPoint *points,
                       INT count, REAL tension);

GpStatus GdipDrawCurve3(GpGraphics *graphics, GpPen *pen, GpPointF *points,
               INT count, INT offset, INT numberOfSegments, REAL tension);

GpStatus GdipDrawCurve3I(GpGraphics *graphics, GpPen *pen, GpPoint *points,
                INT count, INT offset, INT numberOfSegments, REAL tension);

GpStatus GdipDrawClosedCurve(GpGraphics *graphics, GpPen *pen,
                    GpPointF *points, INT count);

GpStatus GdipDrawClosedCurveI(GpGraphics *graphics, GpPen *pen,
                     GpPoint *points, INT count);

GpStatus GdipDrawClosedCurve2(GpGraphics *graphics, GpPen *pen,
                     GpPointF *points, INT count, REAL tension);

GpStatus GdipDrawClosedCurve2I(GpGraphics *graphics, GpPen *pen,
                      GpPoint *points, INT count, REAL tension);

GpStatus GdipGraphicsClear(GpGraphics *graphics, ARGB color);

GpStatus GdipFillRectangle(GpGraphics *graphics, GpBrush *brush, REAL x, REAL y,
                  REAL width, REAL height);

GpStatus GdipFillRectangleI(GpGraphics *graphics, GpBrush *brush, INT x, INT y,
                   INT width, INT height);

GpStatus GdipFillRectangles(GpGraphics *graphics, GpBrush *brush,
                   GpRectF *rects, INT count);

GpStatus GdipFillRectanglesI(GpGraphics *graphics, GpBrush *brush,
                    GpRect *rects, INT count);

GpStatus GdipFillPolygon(GpGraphics *graphics, GpBrush *brush,
                GpPointF *points, INT count, GpFillMode fillMode);

GpStatus GdipFillPolygonI(GpGraphics *graphics, GpBrush *brush,
                 GpPoint *points, INT count, GpFillMode fillMode);

GpStatus GdipFillPolygon2(GpGraphics *graphics, GpBrush *brush,
                 GpPointF *points, INT count);

GpStatus GdipFillPolygon2I(GpGraphics *graphics, GpBrush *brush,
                  GpPoint *points, INT count);

GpStatus GdipFillEllipse(GpGraphics *graphics, GpBrush *brush, REAL x, REAL y,
                REAL width, REAL height);

GpStatus GdipFillEllipseI(GpGraphics *graphics, GpBrush *brush, INT x, INT y,
                 INT width, INT height);

GpStatus GdipFillPie(GpGraphics *graphics, GpBrush *brush, REAL x, REAL y,
            REAL width, REAL height, REAL startAngle, REAL sweepAngle);

GpStatus GdipFillPieI(GpGraphics *graphics, GpBrush *brush, INT x, INT y,
             INT width, INT height, REAL startAngle, REAL sweepAngle);

GpStatus GdipFillPath(GpGraphics *graphics, GpBrush *brush, GpPath *path);

GpStatus GdipFillClosedCurve(GpGraphics *graphics, GpBrush *brush,
                              GpPointF *points, INT count);

GpStatus GdipFillClosedCurveI(GpGraphics *graphics, GpBrush *brush,
                              GpPoint *points, INT count);

GpStatus GdipFillClosedCurve2(GpGraphics *graphics, GpBrush *brush,
                              GpPointF *points, INT count,
                              REAL tension, GpFillMode fillMode);

GpStatus GdipFillClosedCurve2I(GpGraphics *graphics, GpBrush *brush,
                              GpPoint *points, INT count,
                              REAL tension, GpFillMode fillMode);

GpStatus GdipFillRegion(GpGraphics *graphics, GpBrush *brush,
                        GpRegion *region);

version(GDIPLUS6) {
GpStatus GdipDrawImageFX(
    GpGraphics *graphics,
    GpImage *image,
    GpRectF *source,
    GpMatrix *xForm,
    CGpEffect *effect,
    GpImageAttributes *imageAttributes,
    GpUnit srcUnit
    );
}

GpStatus GdipDrawImage(GpGraphics *graphics, GpImage *image, REAL x, REAL y);

GpStatus GdipDrawImageI(GpGraphics *graphics, GpImage *image, INT x, INT y);

GpStatus GdipDrawImageRect(GpGraphics *graphics, GpImage *image, REAL x, REAL y,
                           REAL width, REAL height);

GpStatus GdipDrawImageRectI(GpGraphics *graphics, GpImage *image, INT x, INT y,
                           INT width, INT height);

GpStatus GdipDrawImagePoints(GpGraphics *graphics, GpImage *image,
                             GpPointF *dstpoints, INT count);

GpStatus GdipDrawImagePointsI(GpGraphics *graphics, GpImage *image,
                             GpPoint *dstpoints, INT count);

GpStatus GdipDrawImagePointRect(GpGraphics *graphics, GpImage *image, REAL x,
                                REAL y, REAL srcx, REAL srcy, REAL srcwidth,
                                REAL srcheight, GpUnit srcUnit);

GpStatus GdipDrawImagePointRectI(GpGraphics *graphics, GpImage *image, INT x,
                                INT y, INT srcx, INT srcy, INT srcwidth,
                                INT srcheight, GpUnit srcUnit);

GpStatus GdipDrawImageRectRect(GpGraphics *graphics, GpImage *image, REAL dstx,
                      REAL dsty, REAL dstwidth, REAL dstheight,
                      REAL srcx, REAL srcy, REAL srcwidth, REAL srcheight,
                      GpUnit srcUnit,
                      GpImageAttributes* imageAttributes,
                      DrawImageAbort callback, VOID * callbackData);

GpStatus GdipDrawImageRectRectI(GpGraphics *graphics, GpImage *image, INT dstx,
                       INT dsty, INT dstwidth, INT dstheight,
                       INT srcx, INT srcy, INT srcwidth, INT srcheight,
                       GpUnit srcUnit,
                       GpImageAttributes* imageAttributes,
                       DrawImageAbort callback, VOID * callbackData);

GpStatus GdipDrawImagePointsRect(GpGraphics *graphics, GpImage *image,
                        GpPointF *points, INT count, REAL srcx,
                        REAL srcy, REAL srcwidth, REAL srcheight,
                        GpUnit srcUnit,
                        GpImageAttributes* imageAttributes,
                        DrawImageAbort callback, VOID * callbackData);

GpStatus GdipDrawImagePointsRectI(GpGraphics *graphics, GpImage *image,
                         GpPoint *points, INT count, INT srcx,
                         INT srcy, INT srcwidth, INT srcheight,
                         GpUnit srcUnit,
                         GpImageAttributes* imageAttributes,
                         DrawImageAbort callback, VOID * callbackData);

GpStatus GdipEnumerateMetafileDestPoint(
    GpGraphics *            graphics,
    GpMetafile *  metafile,
    ref PointF       destPoint,
    EnumerateMetafileProc   callback,
    VOID *                  callbackData,
    GpImageAttributes *     imageAttributes
    );

GpStatus GdipEnumerateMetafileDestPointI(
    GpGraphics *            graphics,
    GpMetafile *  metafile,
    ref Point        destPoint,
    EnumerateMetafileProc   callback,
    VOID *                  callbackData,
    GpImageAttributes *     imageAttributes
    );

GpStatus GdipEnumerateMetafileDestRect(
    GpGraphics *            graphics,
    GpMetafile *  metafile,
    ref RectF        destRect,
    EnumerateMetafileProc   callback,
    VOID *                  callbackData,
    GpImageAttributes *     imageAttributes
    );

GpStatus GdipEnumerateMetafileDestRectI(
    GpGraphics *            graphics,
    GpMetafile *  metafile,
    ref Rect         destRect,
    EnumerateMetafileProc   callback,
    VOID *                  callbackData,
    GpImageAttributes *     imageAttributes
    );

GpStatus GdipEnumerateMetafileDestPoints(
    GpGraphics *            graphics,
    GpMetafile *  metafile,
    PointF *      destPoints,
    INT                     count,
    EnumerateMetafileProc   callback,
    VOID *                  callbackData,
    GpImageAttributes *     imageAttributes
    );

GpStatus GdipEnumerateMetafileDestPointsI(
    GpGraphics *            graphics,
    GpMetafile *  metafile,
    Point *       destPoints,
    INT                     count,
    EnumerateMetafileProc   callback,
    VOID *                  callbackData,
    GpImageAttributes *     imageAttributes
    );

GpStatus GdipEnumerateMetafileSrcRectDestPoint(
    GpGraphics *            graphics,
    GpMetafile *  metafile,
    ref PointF       destPoint,
    ref RectF        srcRect,
    Unit                    srcUnit,
    EnumerateMetafileProc   callback,
    VOID *                  callbackData,
    GpImageAttributes *     imageAttributes
    );

GpStatus GdipEnumerateMetafileSrcRectDestPointI(
    GpGraphics *            graphics,
    GpMetafile *  metafile,
    ref Point        destPoint,
    ref Rect         srcRect,
    Unit                    srcUnit,
    EnumerateMetafileProc   callback,
    VOID *                  callbackData,
    GpImageAttributes *     imageAttributes
    );

GpStatus GdipEnumerateMetafileSrcRectDestRect(
    GpGraphics *            graphics,
    GpMetafile *  metafile,
    ref RectF       destRect,
    ref RectF       srcRect,
    Unit                    srcUnit,
    EnumerateMetafileProc   callback,
    VOID *                  callbackData,
    GpImageAttributes *     imageAttributes
    );

GpStatus GdipEnumerateMetafileSrcRectDestRectI(
    GpGraphics *            graphics,
    GpMetafile *  metafile,
    ref Rect        destRect,
    ref Rect        srcRect,
    Unit                    srcUnit,
    EnumerateMetafileProc   callback,
    VOID *                  callbackData,
    GpImageAttributes *     imageAttributes
    );

GpStatus GdipEnumerateMetafileSrcRectDestPoints(
    GpGraphics *            graphics,
    GpMetafile *  metafile,
    PointF *      destPoints,
    INT                     count,
    ref RectF       srcRect,
    Unit                    srcUnit,
    EnumerateMetafileProc   callback,
    VOID *                  callbackData,
    GpImageAttributes *     imageAttributes
    );

GpStatus GdipEnumerateMetafileSrcRectDestPointsI(
    GpGraphics *            graphics,
    GpMetafile *  metafile,
    Point *       destPoints,
    INT                     count,
    ref Rect        srcRect,
    Unit                    srcUnit,
    EnumerateMetafileProc   callback,
    VOID *                  callbackData,
    GpImageAttributes *     imageAttributes
    );

GpStatus GdipPlayMetafileRecord(
    GpMetafile *  metafile,
    EmfPlusRecordType       recordType,
    UINT                    flags,
    UINT                    dataSize,
    BYTE *        data
    );

GpStatus GdipSetClipGraphics(GpGraphics *graphics, GpGraphics *srcgraphics,
                    CombineMode combineMode);

GpStatus GdipSetClipRect(GpGraphics *graphics, REAL x, REAL y,
                         REAL width, REAL height, CombineMode combineMode);

GpStatus GdipSetClipRectI(GpGraphics *graphics, INT x, INT y,
                         INT width, INT height, CombineMode combineMode);

GpStatus GdipSetClipPath(GpGraphics *graphics, GpPath *path, CombineMode combineMode);

GpStatus GdipSetClipRegion(GpGraphics *graphics, GpRegion *region,
                  CombineMode combineMode);

GpStatus GdipSetClipHrgn(GpGraphics *graphics, HRGN hRgn, CombineMode combineMode);

GpStatus GdipResetClip(GpGraphics *graphics);

GpStatus GdipTranslateClip(GpGraphics *graphics, REAL dx, REAL dy);

GpStatus GdipTranslateClipI(GpGraphics *graphics, INT dx, INT dy);

GpStatus GdipGetClip(GpGraphics *graphics, GpRegion *region);

GpStatus GdipGetClipBounds(GpGraphics *graphics, GpRectF *rect);

GpStatus GdipGetClipBoundsI(GpGraphics *graphics, GpRect *rect);

GpStatus GdipIsClipEmpty(GpGraphics *graphics, BOOL *result);

GpStatus GdipGetVisibleClipBounds(GpGraphics *graphics, GpRectF *rect);

GpStatus GdipGetVisibleClipBoundsI(GpGraphics *graphics, GpRect *rect);

GpStatus GdipIsVisibleClipEmpty(GpGraphics *graphics, BOOL *result);

GpStatus GdipIsVisiblePoint(GpGraphics *graphics, REAL x, REAL y,
                           BOOL *result);

GpStatus GdipIsVisiblePointI(GpGraphics *graphics, INT x, INT y,
                           BOOL *result);

GpStatus GdipIsVisibleRect(GpGraphics *graphics, REAL x, REAL y,
                           REAL width, REAL height, BOOL *result);

GpStatus GdipIsVisibleRectI(GpGraphics *graphics, INT x, INT y,
                           INT width, INT height, BOOL *result);

GpStatus GdipSaveGraphics(GpGraphics *graphics, GraphicsState *state);

GpStatus GdipRestoreGraphics(GpGraphics *graphics, GraphicsState state);

GpStatus GdipBeginContainer(GpGraphics *graphics, GpRectF* dstrect,
                   GpRectF *srcrect, GpUnit unit,
                   GraphicsContainer *state);

GpStatus GdipBeginContainerI(GpGraphics *graphics, GpRect* dstrect,
                    GpRect *srcrect, GpUnit unit,
                    GraphicsContainer *state);

GpStatus GdipBeginContainer2(GpGraphics *graphics, GraphicsContainer* state);

GpStatus GdipEndContainer(GpGraphics *graphics, GraphicsContainer state);

GpStatus GdipGetMetafileHeaderFromWmf(
    HMETAFILE           hWmf,
    WmfPlaceableFileHeader *     wmfPlaceableFileHeader,
    MetafileHeader *    header
    );

GpStatus GdipGetMetafileHeaderFromEmf(
    HENHMETAFILE        hEmf,
    MetafileHeader *    header
    );

GpStatus GdipGetMetafileHeaderFromFile(
    WCHAR*        filename,
    MetafileHeader *    header
    );

//GpStatus GdipGetMetafileHeaderFromStream(
//    IStream *           stream,
//    MetafileHeader *    header
//    );

GpStatus GdipGetMetafileHeaderFromMetafile(
    GpMetafile *        metafile,
    MetafileHeader *    header
    );

GpStatus GdipGetHemfFromMetafile(
    GpMetafile *        metafile,
    HENHMETAFILE *      hEmf
    );

//GpStatus GdipCreateStreamOnFile(WCHAR * filename, UINT access,
//                       IStream **stream);

GpStatus GdipCreateMetafileFromWmf(HMETAFILE hWmf, BOOL deleteWmf,
                          WmfPlaceableFileHeader * wmfPlaceableFileHeader,
                          GpMetafile **metafile);

GpStatus GdipCreateMetafileFromEmf(HENHMETAFILE hEmf, BOOL deleteEmf,
                          GpMetafile **metafile);

GpStatus GdipCreateMetafileFromFile(WCHAR* file, GpMetafile **metafile);

GpStatus GdipCreateMetafileFromWmfFile(WCHAR* file,
                              WmfPlaceableFileHeader * wmfPlaceableFileHeader, 
                              GpMetafile **metafile);

//GpStatus GdipCreateMetafileFromStream(IStream * stream, GpMetafile **metafile);


GpStatus GdipRecordMetafile(
    HDC                 referenceHdc,
    EmfType             type,
    GpRectF * frameRect,
    MetafileFrameUnit   frameUnit,
    WCHAR *   description,
    GpMetafile **       metafile
    );

GpStatus GdipRecordMetafileI(
    HDC                 referenceHdc,
    EmfType             type,
    GpRect *  frameRect,
    MetafileFrameUnit   frameUnit,
    WCHAR *   description,
    GpMetafile **       metafile
    );

GpStatus GdipRecordMetafileFileName(
    WCHAR*    fileName,
    HDC                 referenceHdc,
    EmfType             type,
    GpRectF * frameRect,
    MetafileFrameUnit   frameUnit,
    WCHAR *   description,
    GpMetafile **       metafile
    );

GpStatus GdipRecordMetafileFileNameI(
    WCHAR*    fileName,
    HDC                 referenceHdc,
    EmfType             type,
    GpRect *  frameRect,
    MetafileFrameUnit   frameUnit,
    WCHAR *   description,
    GpMetafile **       metafile
    );

/*GpStatus GdipRecordMetafileStream(
    IStream *           stream,
    HDC                 referenceHdc,
    EmfType             type,
    GpRectF * frameRect,
    MetafileFrameUnit   frameUnit,
    WCHAR *   description,
    GpMetafile **       metafile
    );
*/

/*GpStatus GdipRecordMetafileStreamI(
    IStream *           stream,
    HDC                 referenceHdc,
    EmfType             type,
    GpRect *  frameRect,
    MetafileFrameUnit   frameUnit,
    WCHAR *   description,
    GpMetafile **       metafile
    );
*/

GpStatus GdipSetMetafileDownLevelRasterizationLimit(
    GpMetafile *            metafile,
    UINT                    metafileRasterizationLimitDpi
    );

GpStatus GdipGetMetafileDownLevelRasterizationLimit(
    GpMetafile *  metafile,
    UINT *                  metafileRasterizationLimitDpi
    );

GpStatus GdipGetImageDecodersSize(UINT *numDecoders, UINT *size);

GpStatus GdipGetImageDecoders(UINT numDecoders,
                     UINT size,
                     ImageCodecInfo *decoders);

GpStatus GdipGetImageEncodersSize(UINT *numEncoders, UINT *size);

GpStatus GdipGetImageEncoders(UINT numEncoders,
                     UINT size,
                     ImageCodecInfo *encoders);

GpStatus GdipComment(GpGraphics* graphics, UINT sizeData, BYTE * data);

//----------------------------------------------------------------------------
// FontFamily APIs
//----------------------------------------------------------------------------

GpStatus GdipCreateFontFamilyFromName(WCHAR *name,
                             GpFontCollection *fontCollection,
                             GpFontFamily **FontFamily);

GpStatus GdipDeleteFontFamily(GpFontFamily *FontFamily);

GpStatus GdipCloneFontFamily(GpFontFamily *FontFamily, GpFontFamily **clonedFontFamily);

GpStatus GdipGetGenericFontFamilySansSerif(GpFontFamily **nativeFamily);

GpStatus GdipGetGenericFontFamilySerif(GpFontFamily **nativeFamily);

GpStatus GdipGetGenericFontFamilyMonospace(GpFontFamily **nativeFamily);


GpStatus GdipGetFamilyName(
    GpFontFamily              *family,
    LPWSTR    name,
    LANGID                              language
);

GpStatus GdipIsStyleAvailable(GpFontFamily *family, INT style,
                     BOOL * IsStyleAvailable);

GpStatus GdipFontCollectionEnumerable(
    GpFontCollection* fontCollection,
    GpGraphics* graphics,
    INT *       numFound
);

GpStatus GdipFontCollectionEnumerate(
    GpFontCollection* fontCollection,
    INT             numSought,
    GpFontFamily*   gpfamilies[],
    INT*            numFound,
    GpGraphics*     graphics
);

GpStatus GdipGetEmHeight(GpFontFamily *family, INT style,
                UINT16 * EmHeight);

GpStatus GdipGetCellAscent(GpFontFamily *family, INT style,
                  UINT16 * CellAscent);

GpStatus GdipGetCellDescent(GpFontFamily *family, INT style,
                   UINT16 * CellDescent);

GpStatus GdipGetLineSpacing(GpFontFamily *family, INT style,
                   UINT16 * LineSpacing);


//----------------------------------------------------------------------------
// Font APIs
//----------------------------------------------------------------------------

GpStatus GdipCreateFontFromDC(
    HDC        hdc,
    GpFont   **font
);

GpStatus GdipCreateFontFromLogfontA(
    HDC        hdc,
    LOGFONTA  *logfont,
    GpFont   **font
);

GpStatus GdipCreateFontFromLogfontW(
    HDC        hdc,
    LOGFONTW  *logfont,
    GpFont   **font
);

GpStatus GdipCreateFont(
    GpFontFamily  *fontFamily,
    REAL                 emSize,
    INT                  style,
    Unit                 unit,
    GpFont             **font
);

GpStatus GdipCloneFont(GpFont* font, GpFont** cloneFont);

GpStatus GdipDeleteFont(GpFont* font);

GpStatus GdipGetFamily(GpFont *font, GpFontFamily **family);

GpStatus GdipGetFontStyle(GpFont *font, INT *style);

GpStatus GdipGetFontSize(GpFont *font, REAL *size);

GpStatus GdipGetFontUnit(GpFont *font, Unit *unit);

GpStatus GdipGetFontHeight(GpFont *font, GpGraphics *graphics,
                  REAL *height);

GpStatus GdipGetFontHeightGivenDPI(GpFont *font, REAL dpi, REAL *height);

GpStatus GdipGetLogFontA(GpFont * font, GpGraphics *graphics, LOGFONTA * logfontA);

GpStatus GdipGetLogFontW(GpFont * font, GpGraphics *graphics, LOGFONTW * logfontW);

GpStatus GdipNewInstalledFontCollection(GpFontCollection** fontCollection);

GpStatus GdipNewPrivateFontCollection(GpFontCollection** fontCollection);

GpStatus GdipDeletePrivateFontCollection(GpFontCollection** fontCollection);

GpStatus GdipGetFontCollectionFamilyCount(
    GpFontCollection* fontCollection,
    INT *       numFound
);

GpStatus GdipGetFontCollectionFamilyList(
    GpFontCollection* fontCollection,
    INT             numSought,
    GpFontFamily*   gpfamilies[],
    INT*            numFound
);

GpStatus GdipPrivateAddFontFile(
    GpFontCollection* fontCollection,
    WCHAR* filename
);

GpStatus GdipPrivateAddMemoryFont(
    GpFontCollection* fontCollection,
    void* memory,
    INT length
);

//----------------------------------------------------------------------------
// Text APIs
//----------------------------------------------------------------------------

GpStatus GdipDrawString(
    GpGraphics               *graphics,
    WCHAR          *string,
    INT                       length,
    GpFont         *font,
    RectF          *layoutRect,
    GpStringFormat *stringFormat,
    GpBrush        *brush
);

GpStatus GdipMeasureString(
    GpGraphics               *graphics,
    WCHAR          *string,
    INT                       length,
    GpFont         *font,
    RectF          *layoutRect,
    GpStringFormat *stringFormat,
    RectF                    *boundingBox,
    INT                      *codepointsFitted,
    INT                      *linesFilled
);

GpStatus GdipMeasureCharacterRanges(
    GpGraphics               *graphics,
    WCHAR          *string,
    INT                       length,
    GpFont         *font,
    ref RectF          layoutRect,
    GpStringFormat *stringFormat,
    INT                       regionCount,
    GpRegion                **regions
);

GpStatus GdipDrawDriverString(
    GpGraphics *graphics,
    UINT16 *text,
    INT length,
    GpFont *font,
    GpBrush *brush,
    PointF *positions,
    INT flags,
    GpMatrix *matrix
);

GpStatus GdipMeasureDriverString(
    GpGraphics *graphics,
    UINT16 *text,
    INT length,
    GpFont *font,
    PointF *positions,
    INT flags,
    GpMatrix *matrix,
    RectF *boundingBox
);

//----------------------------------------------------------------------------
// String format APIs
//----------------------------------------------------------------------------

GpStatus GdipCreateStringFormat(
    INT               formatAttributes,
    LANGID            language,
    GpStringFormat  **format
);

GpStatus GdipStringFormatGetGenericDefault(GpStringFormat **format);

GpStatus GdipStringFormatGetGenericTypographic(GpStringFormat **format);

GpStatus GdipDeleteStringFormat(GpStringFormat *format);

GpStatus GdipCloneStringFormat(GpStringFormat *format,
                      GpStringFormat **newFormat);

GpStatus GdipSetStringFormatFlags(GpStringFormat *format, INT flags);

GpStatus GdipGetStringFormatFlags(GpStringFormat *format,
                                             INT *flags);

GpStatus GdipSetStringFormatAlign(GpStringFormat *format, StringAlignment _align);

GpStatus GdipGetStringFormatAlign(GpStringFormat *format,
                         StringAlignment *_align);

GpStatus GdipSetStringFormatLineAlign(GpStringFormat *format,
                             StringAlignment _align);

GpStatus GdipGetStringFormatLineAlign(GpStringFormat *format,
                             StringAlignment *_align);

GpStatus GdipSetStringFormatTrimming(
    GpStringFormat  *format,
    StringTrimming   trimming
);

GpStatus GdipGetStringFormatTrimming(
    GpStringFormat *format,
    StringTrimming       *trimming
);

GpStatus GdipSetStringFormatHotkeyPrefix(GpStringFormat *format, INT hotkeyPrefix);

GpStatus GdipGetStringFormatHotkeyPrefix(GpStringFormat *format,
                                INT *hotkeyPrefix);

GpStatus GdipSetStringFormatTabStops(GpStringFormat *format, REAL firstTabOffset,
                            INT count, REAL *tabStops);

GpStatus GdipGetStringFormatTabStops(GpStringFormat *format, INT count,
                            REAL *firstTabOffset, REAL *tabStops);

GpStatus GdipGetStringFormatTabStopCount(GpStringFormat *format, INT * count);

GpStatus GdipSetStringFormatDigitSubstitution(GpStringFormat *format, LANGID language,
                                     StringDigitSubstitute substitute);

GpStatus GdipGetStringFormatDigitSubstitution(GpStringFormat *format,
                                     LANGID *language,
                                     StringDigitSubstitute *substitute);

GpStatus GdipGetStringFormatMeasurableCharacterRangeCount(
    GpStringFormat    *format,
    INT                         *count
);

GpStatus GdipSetStringFormatMeasurableCharacterRanges(
    GpStringFormat              *format,
    INT                         rangeCount,
    CharacterRange    *ranges
);

//----------------------------------------------------------------------------
// Cached Bitmap APIs
//----------------------------------------------------------------------------

GpStatus GdipCreateCachedBitmap(
    GpBitmap *bitmap,
    GpGraphics *graphics,
    GpCachedBitmap **cachedBitmap
);

GpStatus GdipDeleteCachedBitmap(GpCachedBitmap *cachedBitmap);

GpStatus GdipDrawCachedBitmap(
    GpGraphics *graphics,
    GpCachedBitmap *cachedBitmap,
    INT x,
    INT y
);

UINT GdipEmfToWmfBits(
    HENHMETAFILE hemf,
    UINT         cbData16,
    LPBYTE       pData16,
    INT          iMapMode,
    INT          eFlags
);

GpStatus GdipSetImageAttributesCachedBackground(
    GpImageAttributes *imageattr,
    BOOL enableFlag
);

GpStatus GdipTestControl(
    GpTestControlEnum control,
    void * param
);

GpStatus GdiplusNotificationHook(
    ULONG_PTR *token
);

VOID GdiplusNotificationUnhook(
    ULONG_PTR token
);

version(GDIPLUS6) {
GpStatus GdipConvertToEmfPlus(
   GpGraphics* refGraphics,
   GpMetafile*  metafile,
   INT* conversionFailureFlag,
   EmfType      emfType,
   WCHAR* description,
   GpMetafile** out_metafile
);

GpStatus GdipConvertToEmfPlusToFile(
   GpGraphics* refGraphics,
   GpMetafile*  metafile,
   INT* conversionFailureFlag,
   WCHAR* filename,
   EmfType      emfType,
   WCHAR* description,
   GpMetafile** out_metafile
);

/*GpStatus GdipConvertToEmfPlusToStream(
   GpGraphics* refGraphics,
   GpMetafile*  metafile,
   INT* conversionFailureFlag,
   IStream* stream,
   EmfType      emfType,
   WCHAR* description,
   GpMetafile** out_metafile
);
*/
}