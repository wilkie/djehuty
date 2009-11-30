/*
 * gdiplusgraphics.d
 *
 * This module implements GdiPlusGraphics.h for D. The original
 * copyright info is given below.
 *
 * Author: Dave Wilkinson
 * Originated: November 25th, 2009
 *
 */

module binding.win32.gdiplusgraphics;

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
import binding.win32.gdiplusregion;
import binding.win32.gdiplusbrush;
import binding.win32.gdipluspen;
import binding.win32.gdiplusfont;
import binding.win32.gdipluspath;
import binding.win32.gdiplusstringformat;
import binding.win32.gdipluscachedbitmap;
import binding.win32.gdipluseffects;
import binding.win32.gdiplusmetafile;

/**************************************************************************\
*
* Copyright (c) 1998-2001, Microsoft Corp.  All Rights Reserved.
*
* Module Name:
*
*   GdiplusGraphics.h
*
* Abstract:
*
*   GDI+ Graphics Object
*
\**************************************************************************/

extern(System):

class Graphics : GdiplusBase {

    static Graphics FromHDC(in HDC hdc) {
        return new Graphics(hdc);
    }

    static Graphics FromHDC(in HDC hdc, in HANDLE hdevice) {
        return new Graphics(hdc, hdevice);
    }

    static Graphics FromHWND(in HWND hwnd, in BOOL icm = FALSE) {
        return new Graphics(hwnd, icm);
    }

    static Graphics FromImage(in Image image) {
        return new Graphics(image);
    }

    this(in HDC hdc) {
        GpGraphics *graphics = null;

        lastResult = GdipCreateFromHDC(hdc, &graphics);

        SetNativeGraphics(graphics);
    }

    this(in HDC hdc, in HANDLE hdevice) {
        GpGraphics *graphics = null;

        lastResult = GdipCreateFromHDC2(hdc, hdevice, &graphics);

        SetNativeGraphics(graphics);
    }

    this(in HWND hwnd, in BOOL icm) {
        GpGraphics *graphics = null;

        if (icm) {
            lastResult = GdipCreateFromHWNDICM(hwnd, &graphics);
        }
        else {
            lastResult = GdipCreateFromHWND(hwnd, &graphics);
        }

        SetNativeGraphics(graphics);
    }

    this(in Image image) {
        GpGraphics *graphics = null;

        if (image !is null) {
            lastResult = GdipGetImageGraphicsContext(
                                                                image.nativeImage, &graphics);
        }
        SetNativeGraphics(graphics);
    }

    ~this() {
        GdipDeleteGraphics(nativeGraphics);
    }

    VOID Flush(in FlushIntention intention = FlushIntention.FlushIntentionFlush) {
        GdipFlush(nativeGraphics, intention);
    }

    //------------------------------------------------------------------------
    // GDI Interop methods
    //------------------------------------------------------------------------

    // Locks the graphics until ReleaseDC is called

    HDC GetHDC() {
        HDC     hdc = null;

        SetStatus(GdipGetDC(nativeGraphics, &hdc));

        return hdc;
    }

    VOID ReleaseHDC(in HDC hdc) {
        SetStatus(GdipReleaseDC(nativeGraphics, hdc));
    }

    //------------------------------------------------------------------------
    // Rendering modes
    //------------------------------------------------------------------------

    Status SetRenderingOrigin(in INT x, in INT y) {
        return SetStatus(
            GdipSetRenderingOrigin(
                nativeGraphics, x, y
            )
        );
    }

    Status GetRenderingOrigin(ref INT x, ref INT y) {
        return SetStatus(
            GdipGetRenderingOrigin(
                nativeGraphics, &x, &y
            )
        );
    }

    Status SetCompositingMode(in CompositingMode compositingMode) {
        return SetStatus(GdipSetCompositingMode(nativeGraphics, compositingMode));
    }

    CompositingMode GetCompositingMode() {
        CompositingMode mode;

        SetStatus(GdipGetCompositingMode(nativeGraphics,
                                                     &mode));

        return mode;
    }

    Status SetCompositingQuality(in CompositingQuality compositingQuality) {
        return SetStatus(GdipSetCompositingQuality(
            nativeGraphics,
            compositingQuality));
    }

    CompositingQuality GetCompositingQuality() {
        CompositingQuality quality;

        SetStatus(GdipGetCompositingQuality(
            nativeGraphics,
            &quality));

        return quality;
    }

    Status SetTextRenderingHint(in TextRenderingHint newMode) {
        return SetStatus(GdipSetTextRenderingHint(nativeGraphics,
                                                          newMode));
    }

    TextRenderingHint GetTextRenderingHint() {
        TextRenderingHint hint;

        SetStatus(GdipGetTextRenderingHint(nativeGraphics,
                                                   &hint));

        return hint;
    }

    Status SetTextContrast(in UINT contrast) {
        return SetStatus(GdipSetTextContrast(nativeGraphics, contrast));
    }

    UINT GetTextContrast() {
        UINT contrast;

        SetStatus(GdipGetTextContrast(nativeGraphics, &contrast));

        return contrast;
    }

    InterpolationMode GetInterpolationMode() {
        InterpolationMode mode = InterpolationMode.InterpolationModeInvalid;

        SetStatus(GdipGetInterpolationMode(nativeGraphics, &mode));

        return mode;
    }

    Status SetInterpolationMode(in InterpolationMode interpolationMode) {
        return SetStatus(GdipSetInterpolationMode(nativeGraphics, interpolationMode));
    }

version(GDIPLUS6) {
    Status SetAbort(GdiplusAbort *pIAbort) {
        return SetStatus(GdipGraphicsSetAbort(
            nativeGraphics,
            pIAbort
        ));
    }
}

    SmoothingMode GetSmoothingMode() {
        SmoothingMode smoothingMode = SmoothingMode.SmoothingModeInvalid;

        SetStatus(GdipGetSmoothingMode(nativeGraphics,
                                                   &smoothingMode));

        return smoothingMode;
    }

    Status SetSmoothingMode(in SmoothingMode smoothingMode) {
        return SetStatus(GdipSetSmoothingMode(nativeGraphics,
                                                          smoothingMode));
    }

    PixelOffsetMode GetPixelOffsetMode() {
        PixelOffsetMode pixelOffsetMode = PixelOffsetMode.PixelOffsetModeInvalid;

        SetStatus(GdipGetPixelOffsetMode(nativeGraphics,
                                                     &pixelOffsetMode));

        return pixelOffsetMode;
    }

    Status SetPixelOffsetMode(in PixelOffsetMode pixelOffsetMode) {
        return SetStatus(GdipSetPixelOffsetMode(nativeGraphics,
                                                            pixelOffsetMode));
    }

    //------------------------------------------------------------------------
    // Manipulate current world transform
    //------------------------------------------------------------------------

    Status SetTransform(in Matrix matrix) {
        return SetStatus(GdipSetWorldTransform(nativeGraphics,
                                                        matrix.nativeMatrix));
    }
    
    Status ResetTransform() {
        return SetStatus(GdipResetWorldTransform(nativeGraphics));
    }

    Status MultiplyTransform(in Matrix matrix, in MatrixOrder order = MatrixOrder.MatrixOrderPrepend) {
        return SetStatus(GdipMultiplyWorldTransform(nativeGraphics,
                                                                matrix.nativeMatrix,
                                                                order));
    }

    Status TranslateTransform(in REAL dx, in REAL dy, in MatrixOrder order = MatrixOrder.MatrixOrderPrepend) {
        return SetStatus(GdipTranslateWorldTransform(nativeGraphics, dx, dy, order));
    }

    Status ScaleTransform(in REAL sx, in REAL sy, in MatrixOrder order = MatrixOrder.MatrixOrderPrepend) {
        return SetStatus(GdipScaleWorldTransform(nativeGraphics, sx, sy, order));
    }

    Status RotateTransform(in REAL angle, in MatrixOrder order = MatrixOrder.MatrixOrderPrepend) {
        return SetStatus(GdipRotateWorldTransform(nativeGraphics, angle, order));
    }

    Status GetTransform(Matrix* matrix) {
        return SetStatus(GdipGetWorldTransform(nativeGraphics, matrix.nativeMatrix));
    }

    Status SetPageUnit(in Unit unit) {
        return SetStatus(GdipSetPageUnit(nativeGraphics, unit));
    }

    Status SetPageScale(in REAL scale) {
        return SetStatus(GdipSetPageScale(nativeGraphics, scale));
    }

    Unit GetPageUnit() {
        Unit unit;

        SetStatus(GdipGetPageUnit(nativeGraphics, &unit));

        return unit;
    }

    REAL GetPageScale() {
        REAL scale;

        SetStatus(GdipGetPageScale(nativeGraphics, &scale));

        return scale;
    }

    REAL GetDpiX() {
        REAL dpi;

        SetStatus(GdipGetDpiX(nativeGraphics, &dpi));

        return dpi;
    }

    REAL GetDpiY() {
        REAL dpi;

        SetStatus(GdipGetDpiY(nativeGraphics, &dpi));

        return dpi;
    }

    Status TransformPoints(in CoordinateSpace destSpace, in CoordinateSpace srcSpace, PointF* pts, in INT count) {
        return SetStatus(GdipTransformPoints(nativeGraphics, destSpace, srcSpace, pts, count));
    }

    Status TransformPoints(in CoordinateSpace destSpace, in CoordinateSpace srcSpace, in Point* pts, in INT count)  {
        return SetStatus(GdipTransformPointsI(nativeGraphics, destSpace, srcSpace, pts, count));
    }

    //------------------------------------------------------------------------
    // GetNearestColor (for <= 8bpp surfaces).  Note: Alpha is ignored.
    //------------------------------------------------------------------------
    
    Status GetNearestColor(in Color color) {
        if (color is null) {
            return SetStatus(Status.InvalidParameter);
        }

        ARGB argb = color.GetValue();

        Status status = SetStatus(GdipGetNearestColor(nativeGraphics, &argb));

        color.SetValue(argb);

        return status;
    }

    Status DrawLine(in Pen pen, in REAL x1, in REAL y1, in REAL x2, in REAL y2) {
        return SetStatus(GdipDrawLine(nativeGraphics,
                                                  pen.nativePen, x1, y1, x2,
                                                  y2));
    }

    Status DrawLine(in Pen pen, in PointF pt1, in PointF pt2) {
        return DrawLine(pen, pt1.X, pt1.Y, pt2.X, pt2.Y);
    }

    Status DrawLines(in Pen pen,
                     in PointF* points,
                     in INT count)
    {
        return SetStatus(GdipDrawLines(nativeGraphics,
                                                   pen.nativePen,
                                                   points, count));
    }

    Status DrawLine(in Pen pen,
                    in INT x1,
                    in INT y1,
                    in INT x2,
                    in INT y2)
    {
        return SetStatus(GdipDrawLineI(nativeGraphics,
                                                   pen.nativePen,
                                                   x1,
                                                   y1,
                                                   x2,
                                                   y2));
    }

    Status DrawLine(in Pen pen,
                    in Point pt1,
                    in Point pt2)
    {
        return DrawLine(pen,
                        pt1.X,
                        pt1.Y,
                        pt2.X,
                        pt2.Y);
    }

    Status DrawLines(in Pen pen,
                     in Point* points,
                     in INT count)
    {
        return SetStatus(GdipDrawLinesI(nativeGraphics,
                                                    pen.nativePen,
                                                    points,
                                                    count));
    }

    Status DrawArc(in Pen pen,
                   in REAL x,
                   in REAL y,
                   in REAL width,
                   in REAL height,
                   in REAL startAngle,
                   in REAL sweepAngle)
    {
        return SetStatus(GdipDrawArc(nativeGraphics,
                                                 pen.nativePen,
                                                 x,
                                                 y,
                                                 width,
                                                 height,
                                                 startAngle,
                                                 sweepAngle));
    }

    Status DrawArc(in Pen pen,
                   in RectF rect,
                   in REAL startAngle,
                   in REAL sweepAngle)
    {
        return DrawArc(pen, rect.X, rect.Y, rect.Width, rect.Height,
                       startAngle, sweepAngle);
    }

    Status DrawArc(in Pen pen,
                   in INT x,
                   in INT y,
                   in INT width,
                   in INT height,
                   in REAL startAngle,
                   in REAL sweepAngle)
    {
        return SetStatus(GdipDrawArcI(nativeGraphics,
                                                  pen.nativePen,
                                                  x,
                                                  y,
                                                  width,
                                                  height,
                                                  startAngle,
                                                  sweepAngle));
    }


    Status DrawArc(in Pen pen,
                   in Rect rect,
                   in REAL startAngle,
                   in REAL sweepAngle)
    {
        return DrawArc(pen,
                       rect.X,
                       rect.Y,
                       rect.Width,
                       rect.Height,
                       startAngle,
                       sweepAngle);
    }

    Status DrawBezier(in Pen pen,
                      in REAL x1,
                      in REAL y1,
                      in REAL x2,
                      in REAL y2,
                      in REAL x3,
                      in REAL y3,
                      in REAL x4,
                      in REAL y4)
    {
        return SetStatus(GdipDrawBezier(nativeGraphics,
                                                    pen.nativePen, x1, y1,
                                                    x2, y2, x3, y3, x4, y4));
    }

    Status DrawBezier(in Pen pen,
                      in PointF pt1,
                      in PointF pt2,
                      in PointF pt3,
                      in PointF pt4)
    {
        return DrawBezier(pen,
                          pt1.X,
                          pt1.Y,
                          pt2.X,
                          pt2.Y,
                          pt3.X,
                          pt3.Y,
                          pt4.X,
                          pt4.Y);
    }

    Status DrawBeziers(in Pen pen,
                       in PointF* points,
                       in INT count)
    {
        return SetStatus(GdipDrawBeziers(nativeGraphics,
                                                     pen.nativePen,
                                                     points,
                                                     count));
    }

    Status DrawBezier(in Pen pen,
                      in INT x1,
                      in INT y1,
                      in INT x2,
                      in INT y2,
                      in INT x3,
                      in INT y3,
                      in INT x4,
                      in INT y4)
    {
        return SetStatus(GdipDrawBezierI(nativeGraphics,
                                                     pen.nativePen,
                                                     x1,
                                                     y1,
                                                     x2,
                                                     y2,
                                                     x3,
                                                     y3,
                                                     x4,
                                                     y4));
    }

    Status DrawBezier(in Pen pen,
                      in Point pt1,
                      in Point pt2,
                      in Point pt3,
                      in Point pt4)
    {
        return DrawBezier(pen,
                          pt1.X,
                          pt1.Y,
                          pt2.X,
                          pt2.Y,
                          pt3.X,
                          pt3.Y,
                          pt4.X,
                          pt4.Y);
    }

    Status DrawBeziers(in Pen pen,
                       in Point* points,
                       in INT count)
    {
        return SetStatus(GdipDrawBeziersI(nativeGraphics,
                                                      pen.nativePen,
                                                      points,
                                                      count));
    }

    Status DrawRectangle(in Pen pen,
                         in RectF rect)
    {
        return DrawRectangle(pen, rect.X, rect.Y, rect.Width, rect.Height);
    }

    Status DrawRectangle(in Pen pen,
                         in REAL x,
                         in REAL y,
                         in REAL width,
                         in REAL height)
    {
        return SetStatus(GdipDrawRectangle(nativeGraphics,
                                                       pen.nativePen, x, y,
                                                       width, height));
    }

    Status DrawRectangles(in Pen pen,
                          in RectF* rects,
                          in INT count)
    {
        return SetStatus(GdipDrawRectangles(nativeGraphics,
                                                        pen.nativePen,
                                                        rects, count));
    }

    Status DrawRectangle(in Pen pen,
                         in Rect rect)
    {
        return DrawRectangle(pen,
                             rect.X,
                             rect.Y,
                             rect.Width,
                             rect.Height);
    }

    Status DrawRectangle(in Pen pen,
                         in INT x,
                         in INT y,
                         in INT width,
                         in INT height)
    {
        return SetStatus(GdipDrawRectangleI(nativeGraphics,
                                                        pen.nativePen,
                                                        x,
                                                        y,
                                                        width,
                                                        height));
    }

    Status DrawRectangles(in Pen pen,
                          in Rect* rects,
                          in INT count)
    {
        return SetStatus(GdipDrawRectanglesI(nativeGraphics,
                                                         pen.nativePen,
                                                         rects,
                                                         count));
    }

    Status DrawEllipse(in Pen pen,
                       in RectF rect)
    {
        return DrawEllipse(pen, rect.X, rect.Y, rect.Width, rect.Height);
    }

    Status DrawEllipse(in Pen pen,
                       in REAL x,
                       in REAL y,
                       in REAL width,
                       in REAL height)
    {
        return SetStatus(GdipDrawEllipse(nativeGraphics,
                                                     pen.nativePen,
                                                     x,
                                                     y,
                                                     width,
                                                     height));
    }

    Status DrawEllipse(in Pen pen,
                       in Rect rect)
    {
        return DrawEllipse(pen,
                           rect.X,
                           rect.Y,
                           rect.Width,
                           rect.Height);
    }

    Status DrawEllipse(in Pen pen,
                       in INT x,
                       in INT y,
                       in INT width,
                       in INT height)
    {
        return SetStatus(GdipDrawEllipseI(nativeGraphics,
                                                      pen.nativePen,
                                                      x,
                                                      y,
                                                      width,
                                                      height));
    }

    Status DrawPie(in Pen pen,
                   in RectF rect,
                   in REAL startAngle,
                   in REAL sweepAngle)
    {
        return DrawPie(pen,
                       rect.X,
                       rect.Y,
                       rect.Width,
                       rect.Height,
                       startAngle,
                       sweepAngle);
    }

    Status DrawPie(in Pen pen,
                   in REAL x,
                   in REAL y,
                   in REAL width,
                   in REAL height,
                   in REAL startAngle,
                   in REAL sweepAngle)
    {
        return SetStatus(GdipDrawPie(nativeGraphics,
                                                 pen.nativePen,
                                                 x,
                                                 y,
                                                 width,
                                                 height,
                                                 startAngle,
                                                 sweepAngle));
    }

    Status DrawPie(in Pen pen,
                   in Rect rect,
                   in REAL startAngle,
                   in REAL sweepAngle)
    {
        return DrawPie(pen,
                       rect.X,
                       rect.Y,
                       rect.Width,
                       rect.Height,
                       startAngle,
                       sweepAngle);
    }

    Status DrawPie(in Pen pen,
                   in INT x,
                   in INT y,
                   in INT width,
                   in INT height,
                   in REAL startAngle,
                   in REAL sweepAngle)
    {
        return SetStatus(GdipDrawPieI(nativeGraphics,
                                                  pen.nativePen,
                                                  x,
                                                  y,
                                                  width,
                                                  height,
                                                  startAngle,
                                                  sweepAngle));
    }

    Status DrawPolygon(in Pen pen,
                       in PointF* points,
                       in INT count)
    {
        return SetStatus(GdipDrawPolygon(nativeGraphics,
                                                     pen.nativePen,
                                                     points,
                                                     count));
    }

    Status DrawPolygon(in Pen pen,
                       in Point* points,
                       in INT count)
    {
        return SetStatus(GdipDrawPolygonI(nativeGraphics,
                                                      pen.nativePen,
                                                      points,
                                                      count));
    }

    Status DrawPath(in Pen pen,
                    in GraphicsPath* path)
    {
        return SetStatus(GdipDrawPath(nativeGraphics,
                                                  pen ? pen.nativePen : null,
                                                  path ? path.nativePath : null));
    }

    Status DrawCurve(in Pen pen,
                     in PointF* points,
                     in INT count)
    {
        return SetStatus(GdipDrawCurve(nativeGraphics,
                                                   pen.nativePen, points,
                                                   count));
    }

    Status DrawCurve(in Pen pen,
                     in PointF* points,
                     in INT count,
                     in REAL tension)
    {
        return SetStatus(GdipDrawCurve2(nativeGraphics,
                                                    pen.nativePen, points,
                                                    count, tension));
    }

    Status DrawCurve(in Pen pen,
                     in PointF* points,
                     in INT count,
                     in INT offset,
                     in INT numberOfSegments,
                     in REAL tension = 0.5f)
    {
        return SetStatus(GdipDrawCurve3(nativeGraphics,
                                                    pen.nativePen, points,
                                                    count, offset,
                                                    numberOfSegments, tension));
    }

    Status DrawCurve(in Pen pen,
                     in Point* points,
                     in INT count)
    {
        return SetStatus(GdipDrawCurveI(nativeGraphics,
                                                    pen.nativePen,
                                                    points,
                                                    count));
    }

    Status DrawCurve(in Pen pen,
                     in Point* points,
                     in INT count,
                     in REAL tension)
    {
        return SetStatus(GdipDrawCurve2I(nativeGraphics,
                                                     pen.nativePen,
                                                     points,
                                                     count,
                                                     tension));
    }

    Status DrawCurve(in Pen pen,
                     in Point* points,
                     in INT count,
                     in INT offset,
                     in INT numberOfSegments,
                     in REAL tension = 0.5f)
    {
        return SetStatus(GdipDrawCurve3I(nativeGraphics,
                                                     pen.nativePen,
                                                     points,
                                                     count,
                                                     offset,
                                                     numberOfSegments,
                                                     tension));
    }

    Status DrawClosedCurve(in Pen pen,
                           in PointF* points,
                           in INT count)
    {
        return SetStatus(GdipDrawClosedCurve(nativeGraphics,
                                                         pen.nativePen,
                                                         points, count));
    }

    Status DrawClosedCurve(in Pen *pen,
                           in PointF* points,
                           in INT count,
                           in REAL tension)
    {
        return SetStatus(GdipDrawClosedCurve2(nativeGraphics,
                                                          pen.nativePen,
                                                          points, count,
                                                          tension));
    }

    Status DrawClosedCurve(in Pen pen,
                           in Point* points,
                           in INT count)
    {
        return SetStatus(GdipDrawClosedCurveI(nativeGraphics,
                                                          pen.nativePen,
                                                          points,
                                                          count));
    }

    Status DrawClosedCurve(in Pen *pen,
                           in Point* points,
                           in INT count,
                           in REAL tension)
    {
        return SetStatus(GdipDrawClosedCurve2I(nativeGraphics,
                                                           pen.nativePen,
                                                           points,
                                                           count,
                                                           tension));
    }

    Status Clear(in Color color)
    {
        return SetStatus(GdipGraphicsClear(
            nativeGraphics,
            color.GetValue()));
    }

    Status FillRectangle(in Brush* brush,
                         in RectF rect)
    {
        return FillRectangle(brush, rect.X, rect.Y, rect.Width, rect.Height);
    }

    Status FillRectangle(in Brush* brush,
                         in REAL x,
                         in REAL y,
                         in REAL width,
                         in REAL height)
    {
        return SetStatus(GdipFillRectangle(nativeGraphics, brush.nativeBrush, x, y, width, height));
    }

    Status FillRectangles(in Brush* brush,
                          in RectF* rects,
                          in INT count)
    {
        return SetStatus(GdipFillRectangles(nativeGraphics,
                                                        brush.nativeBrush,
                                                        rects, count));
    }

    Status FillRectangle(in Brush* brush,
                         in Rect rect)
    {
        return FillRectangle(brush,
                             rect.X,
                             rect.Y,
                             rect.Width,
                             rect.Height);
    }

    Status FillRectangle(in Brush* brush,
                         in INT x,
                         in INT y,
                         in INT width,
                         in INT height)
    {
        return SetStatus(GdipFillRectangleI(nativeGraphics,
                                                        brush.nativeBrush,
                                                        x,
                                                        y,
                                                        width,
                                                        height));
    }

    Status FillRectangles(in Brush* brush,
                          in Rect* rects,
                          in INT count)
    {
        return SetStatus(GdipFillRectanglesI(nativeGraphics,
                                                         brush.nativeBrush,
                                                         rects,
                                                         count));
    }

    Status FillPolygon(in Brush* brush,
                       in PointF* points,
                       in INT count)
    {
        return FillPolygon(brush, points, count, FillMode.FillModeAlternate);
    }

    Status FillPolygon(in Brush* brush,
                       in PointF* points,
                       in INT count,
                       in FillMode fillMode)
    {
        return SetStatus(GdipFillPolygon(nativeGraphics,
                                                     brush.nativeBrush,
                                                     points, count, fillMode));
    }

    Status FillPolygon(in Brush* brush,
                       in Point* points,
                       in INT count)
    {
        return FillPolygon(brush, points, count, FillMode.FillModeAlternate);
    }

    Status FillPolygon(in Brush* brush,
                       in Point* points,
                       in INT count,
                       in FillMode fillMode)
    {
        return SetStatus(GdipFillPolygonI(nativeGraphics,
                                                      brush.nativeBrush,
                                                      points, count,
                                                      fillMode));
    }

    Status FillEllipse(in Brush* brush,
                       in RectF rect)
    {
        return FillEllipse(brush, rect.X, rect.Y, rect.Width, rect.Height);
    }

    Status FillEllipse(in Brush* brush,
                       in REAL x,
                       in REAL y,
                       in REAL width,
                       in REAL height)
    {
        return SetStatus(GdipFillEllipse(nativeGraphics,
                                                     brush.nativeBrush, x, y,
                                                     width, height));
    }

    Status FillEllipse(in Brush* brush,
                       in Rect rect)
    {
        return FillEllipse(brush, rect.X, rect.Y, rect.Width, rect.Height);
    }

    Status FillEllipse(in Brush* brush,
                       in INT x,
                       in INT y,
                       in INT width,
                       in INT height)
    {
        return SetStatus(GdipFillEllipseI(nativeGraphics,
                                                      brush.nativeBrush,
                                                      x,
                                                      y,
                                                      width,
                                                      height));
    }

    Status FillPie(in Brush* brush,
                   in RectF rect,
                   in REAL startAngle,
                   in REAL sweepAngle)
    {
        return FillPie(brush, rect.X, rect.Y, rect.Width, rect.Height,
                       startAngle, sweepAngle);
    }

    Status FillPie(in Brush* brush,
                   in REAL x,
                   in REAL y,
                   in REAL width,
                   in REAL height,
                   in REAL startAngle,
                   in REAL sweepAngle)
    {
        return SetStatus(GdipFillPie(nativeGraphics,
                                                 brush.nativeBrush, x, y,
                                                 width, height, startAngle,
                                                 sweepAngle));
    }

    Status FillPie(in Brush* brush,
                   in Rect rect,
                   in REAL startAngle,
                   in REAL sweepAngle)
    {
        return FillPie(brush, rect.X, rect.Y, rect.Width, rect.Height,
                       startAngle, sweepAngle);
    }

    Status FillPie(in Brush* brush,
                   in INT x,
                   in INT y,
                   in INT width,
                   in INT height,
                   in REAL startAngle,
                   in REAL sweepAngle)
    {
        return SetStatus(GdipFillPieI(nativeGraphics,
                                                  brush.nativeBrush,
                                                  x,
                                                  y,
                                                  width,
                                                  height,
                                                  startAngle,
                                                  sweepAngle));
    }

    Status FillPath(in Brush* brush,
                    in GraphicsPath* path)
    {
        return SetStatus(GdipFillPath(nativeGraphics,
                                                  brush.nativeBrush,
                                                  path.nativePath));
    }

    Status FillClosedCurve(in Brush* brush,
                           in PointF* points,
                           in INT count)
    {
        return SetStatus(GdipFillClosedCurve(nativeGraphics,
                                                         brush.nativeBrush,
                                                         points, count));

    }

    Status FillClosedCurve(in Brush* brush,
                           in PointF* points,
                           in INT count,
                           in FillMode fillMode,
                           in REAL tension = 0.5f)
    {
        return SetStatus(GdipFillClosedCurve2(nativeGraphics,
                                                          brush.nativeBrush,
                                                          points, count,
                                                          tension, fillMode));
    }

    Status FillClosedCurve(in Brush* brush,
                           in Point* points,
                           in INT count)
    {
        return SetStatus(GdipFillClosedCurveI(nativeGraphics,
                                                          brush.nativeBrush,
                                                          points,
                                                          count));
    }

    Status FillClosedCurve(in Brush* brush,
                           in Point* points,
                           in INT count,
                           in FillMode fillMode,
                           in REAL tension = 0.5f)
    {
        return SetStatus(GdipFillClosedCurve2I(nativeGraphics,
                                                           brush.nativeBrush,
                                                           points, count,
                                                           tension, fillMode));
    }

    Status FillRegion(in Brush* brush,
                      in Region* region)
    {
        return SetStatus(GdipFillRegion(nativeGraphics,
                                                    brush.nativeBrush,
                                                    region.nativeRegion));
    }

    Status DrawString(in WCHAR* string, in INT length, in Font font, 
            in RectF layoutRect, in StringFormat stringFormat, in Brush brush) {
        return SetStatus(GdipDrawString(
            nativeGraphics,
            string,
            length,
            font ? font.nativeFont : null,
            &layoutRect,
            stringFormat ? stringFormat.nativeFormat : null,
            brush ? brush.nativeBrush : null
        ));
    }

    Status
    DrawString(
        WCHAR        *string,
        INT                 length,
        Font         font,
        PointF       origin,
        Brush        brush
    )
    {
        RectF rect;
        rect.init(origin.X, origin.Y, 0.0f, 0.0f);

        return SetStatus(GdipDrawString(
            nativeGraphics,
            string,
            length,
            font ? font.nativeFont : null,
            &rect,
            null,
            brush ? brush.nativeBrush : null
        ));
    }

    Status
    DrawString(
        WCHAR        *string,
        INT                 length,
        Font         font,
        PointF       origin,
        StringFormat stringFormat,
        Brush        brush
    )
    {
        RectF rect;
        rect.init(origin.X, origin.Y, 0.0f, 0.0f);

        return SetStatus(GdipDrawString(
            nativeGraphics,
            string,
            length,
            font ? font.nativeFont : null,
            &rect,
            stringFormat ? stringFormat.nativeFormat : null,
            brush ? brush.nativeBrush : null
        ));
    }

    Status
    MeasureString(
        in WCHAR        *string,
        in INT                 length,
        in Font         font,
        in RectF        layoutRect,
        in StringFormat stringFormat,
        RectF             *boundingBox,
        INT               *codepointsFitted = null,
        INT               *linesFilled      = null
    ) {
        return SetStatus(GdipMeasureString(
            nativeGraphics,
            string,
            length,
            font ? font.nativeFont : null,
            &layoutRect,
            stringFormat ? stringFormat.nativeFormat : null,
            boundingBox,
            codepointsFitted,
            linesFilled
        ));
    }

    Status
    MeasureString(
        in WCHAR        *string,
        in INT                 length,
        in Font         font,
        in SizeF        *layoutRectSize,
        in StringFormat stringFormat,
        SizeF             *size,
        INT               *codepointsFitted = null,
        INT               *linesFilled      = null
    )
    {
        RectF   layoutRect;
        layoutRect.init(0, 0, layoutRectSize.Width, layoutRectSize.Height);
        RectF   boundingBox;
        Status  status;

        if (size is null) {
            return SetStatus(Status.InvalidParameter);
        }

        status = SetStatus(GdipMeasureString(
            nativeGraphics,
            string,
            length,
            font ? font.nativeFont : null,
            &layoutRect,
            stringFormat ? stringFormat.nativeFormat : null,
            size ? &boundingBox : null,
            codepointsFitted,
            linesFilled
        ));

        if (size && status == Status.Ok)
        {
            size.Width  = boundingBox.Width;
            size.Height = boundingBox.Height;
        }

        return status;
    }

    Status
    MeasureString(
        in WCHAR        *string,
        in INT                 length,
        in Font         font,
        in PointF       origin,
        in StringFormat stringFormat,
        RectF             *boundingBox
    )
    {
        RectF rect;
        rect.init(origin.X, origin.Y, 0.0f, 0.0f);

        return SetStatus(GdipMeasureString(
            nativeGraphics,
            string,
            length,
            font ? font.nativeFont : null,
            &rect,
            stringFormat ? stringFormat.nativeFormat : null,
            boundingBox,
            null,
            null
        ));
    }

    Status
    MeasureString(
        in WCHAR  *string,
        in INT           length,
        in Font   font,
        in RectF  layoutRect,
        RectF       *boundingBox
    )
    {
        return SetStatus(GdipMeasureString(
            nativeGraphics,
            string,
            length,
            font ? font.nativeFont : null,
            &layoutRect,
            null,
            boundingBox,
            null,
            null
        ));
    }

    Status
    MeasureString(
        in WCHAR  *string,
        in INT           length,
        in Font   font,
        in PointF origin,
        RectF       *boundingBox
    )
    {
        RectF rect;
        rect.init(origin.X, origin.Y, 0.0f, 0.0f);

        return SetStatus(GdipMeasureString(
            nativeGraphics,
            string,
            length,
            font ? font.nativeFont : null,
            &rect,
            null,
            boundingBox,
            null,
            null
        ));
    }


    Status
    MeasureCharacterRanges(
        in WCHAR        *string,
        in INT                 length,
        in Font         font,
        in RectF        layoutRect,
        in StringFormat stringFormat,
        in INT                 regionCount,
        Region            *regions
    )
    {
        if (!regions || regionCount <= 0)
        {
            return Status.InvalidParameter;
        }

        GpRegion*[] nativeRegions = new GpRegion* [regionCount];

        if (!nativeRegions) {
            return Status.OutOfMemory;
        }

        for (INT i = 0; i < regionCount; i++) {
            nativeRegions[i] = regions[i].nativeRegion;
        }

        Status status = SetStatus(GdipMeasureCharacterRanges(
            nativeGraphics,
            string,
            length,
            font ? font.nativeFont : null,
            layoutRect,
            stringFormat ? stringFormat.nativeFormat : null,
            regionCount,
            nativeRegions.ptr
        ));

        return status;
    }

    Status DrawDriverString(
        in UINT16  *text,
        in INT            length,
        in Font    font,
        in Brush   brush,
        in PointF  *positions,
        in INT            flags,
        in Matrix        matrix
    )
    {
        return SetStatus(GdipDrawDriverString(
            nativeGraphics,
            text,
            length,
            font ? font.nativeFont : null,
            brush ? brush.nativeBrush : null,
            positions,
            flags,
            matrix ? matrix.nativeMatrix : null
        ));
    }

    Status MeasureDriverString(
        in UINT16  *text,
        in INT            length,
        in Font    font,
        in PointF  *positions,
        in INT            flags,
        in Matrix        matrix,
        RectF        *boundingBox
    )
    {
        return SetStatus(GdipMeasureDriverString(
            nativeGraphics,
            text,
            length,
            font ? font.nativeFont : null,
            positions,
            flags,
            matrix ? matrix.nativeMatrix : null,
            boundingBox
        ));
    }

    // Draw a cached bitmap on this graphics destination offset by
    // x, y. Note this will fail with WrongState if the CachedBitmap
    // native format differs from this Graphics.

    Status DrawCachedBitmap(in CachedBitmap cb,
                            in INT x,
                            in INT y)
    {
        return SetStatus(GdipDrawCachedBitmap(
            nativeGraphics,
            cb.nativeCachedBitmap,
            x, y
        ));
    }

    Status DrawImage(in Image image,
                     in PointF point)
    {
        return DrawImage(image, point.X, point.Y);
    }

    Status DrawImage(in Image image,
                     in REAL x,
                     in REAL y)
    {
        return SetStatus(GdipDrawImage(nativeGraphics,
                                                   image ? image.nativeImage
                                                         : null,
                                                   x,
                                                   y));
    }

    Status DrawImage(in Image image, in RectF rect) {
        return DrawImage(image, rect.X, rect.Y, rect.Width, rect.Height);
    }

    Status DrawImage(in Image image,
                     in REAL x,
                     in REAL y,
                     in REAL width,
                     in REAL height)
    {
        return SetStatus(GdipDrawImageRect(nativeGraphics,
                                                       image ? image.nativeImage
                                                             : null,
                                                       x,
                                                       y,
                                                       width,
                                                       height));
    }

    Status DrawImage(in Image image,
                     in Point point)
    {
        return DrawImage(image, point.X, point.Y);
    }

    Status DrawImage(in Image image,
                     in INT x,
                     in INT y)
    {
        return SetStatus(GdipDrawImageI(nativeGraphics,
                                                    image ? image.nativeImage
                                                          : null,
                                                    x,
                                                    y));
    }

    Status DrawImage(in Image image,
                     in Rect rect)
    {
        return DrawImage(image,
                         rect.X,
                         rect.Y,
                         rect.Width,
                         rect.Height);
    }

    Status DrawImage(in Image image,
                     in INT x,
                     in INT y,
                     in INT width,
                     in INT height) {
        return SetStatus(GdipDrawImageRectI(nativeGraphics,
                                                        image ? image.nativeImage
                                                              : null,
                                                        x,
                                                        y,
                                                        width,
                                                        height));
    }

    
    Status DrawImage(in Image image,
                     in PointF* destPoints,
                     in INT count)
    {
        if (count != 3 && count != 4)
            return SetStatus(Status.InvalidParameter);

        return SetStatus(GdipDrawImagePoints(nativeGraphics,
                                                         image ? image.nativeImage
                                                               : null,
                                                         destPoints, count));
    }

    Status DrawImage(in Image image,
                     in Point* destPoints,
                     in INT count)
    {
        if (count != 3 && count != 4)
            return SetStatus(Status.InvalidParameter);

        return SetStatus(GdipDrawImagePointsI(nativeGraphics,
                                                          image ? image.nativeImage
                                                                : null,
                                                          destPoints,
                                                          count));
    }

    Status DrawImage(in Image image,
                     in REAL x,
                     in REAL y,
                     in REAL srcx,
                     in REAL srcy,
                     in REAL srcwidth,
                     in REAL srcheight,
                     in Unit srcUnit)
    {
        return SetStatus(GdipDrawImagePointRect(nativeGraphics,
                                                            image ? image.nativeImage
                                                                  : null,
                                                            x, y,
                                                            srcx, srcy,
                                                            srcwidth, srcheight, srcUnit));
    }

    Status DrawImage(in Image image,
                     in RectF destRect,
                     in REAL srcx,
                     in REAL srcy,
                     in REAL srcwidth,
                     in REAL srcheight,
                     in Unit srcUnit,
                     in ImageAttributes imageAttributes = null,
                     in DrawImageAbort callback = null,
                     in VOID* callbackData = null)
    {
        return SetStatus(GdipDrawImageRectRect(nativeGraphics,
                                                           image ? image.nativeImage
                                                                 : null,
                                                           destRect.X,
                                                           destRect.Y,
                                                           destRect.Width,
                                                           destRect.Height,
                                                           srcx, srcy,
                                                           srcwidth, srcheight,
                                                           srcUnit,
                                                           imageAttributes
                                                            ? imageAttributes.nativeImageAttr
                                                            : null,
                                                           callback,
                                                           callbackData));
    }

    Status DrawImage(in Image image,
                     in PointF* destPoints,
                     in INT count,
                     in REAL srcx,
                     in REAL srcy,
                     in REAL srcwidth,
                     in REAL srcheight,
                     in Unit srcUnit,
                     in ImageAttributes imageAttributes = null,
                     in DrawImageAbort callback = null,
                     in VOID* callbackData = null)
    {
        return SetStatus(GdipDrawImagePointsRect(nativeGraphics,
                                                             image ? image.nativeImage
                                                                   : null,
                                                             destPoints, count,
                                                             srcx, srcy,
                                                             srcwidth,
                                                             srcheight,
                                                             srcUnit,
                                                             imageAttributes
                                                              ? imageAttributes.nativeImageAttr
                                                              : null,
                                                             callback,
                                                             callbackData));
    }

    Status DrawImage(in Image image,
                     in INT x,
                     in INT y,
                     in INT srcx,
                     in INT srcy,
                     in INT srcwidth,
                     in INT srcheight,
                     in Unit srcUnit)
    {
        return SetStatus(GdipDrawImagePointRectI(nativeGraphics,
                                                             image ? image.nativeImage
                                                                   : null,
                                                             x,
                                                             y,
                                                             srcx,
                                                             srcy,
                                                             srcwidth,
                                                             srcheight,
                                                             srcUnit));
    }

    Status DrawImage(in Image image,
                     in Rect destRect,
                     in INT srcx,
                     in INT srcy,
                     in INT srcwidth,
                     in INT srcheight,
                     in Unit srcUnit,
                     in ImageAttributes imageAttributes = null,
                     in DrawImageAbort callback = null,
                     in VOID* callbackData = null)
    {
        return SetStatus(GdipDrawImageRectRectI(nativeGraphics,
                                                            image ? image.nativeImage
                                                                  : null,
                                                            destRect.X,
                                                            destRect.Y,
                                                            destRect.Width,
                                                            destRect.Height,
                                                            srcx,
                                                            srcy,
                                                            srcwidth,
                                                            srcheight,
                                                            srcUnit,
                                                            imageAttributes
                                                            ? imageAttributes.nativeImageAttr
                                                            : null,
                                                            callback,
                                                            callbackData));
    }

    Status DrawImage(in Image image,
                     in Point* destPoints,
                     in INT count,
                     in INT srcx,
                     in INT srcy,
                     in INT srcwidth,
                     in INT srcheight,
                     in Unit srcUnit,
                     in ImageAttributes imageAttributes = null,
                     in DrawImageAbort callback = null,
                     in VOID* callbackData = null)
    {
        return SetStatus(GdipDrawImagePointsRectI(nativeGraphics,
                                                              image ? image.nativeImage
                                                                    : null,
                                                              destPoints,
                                                              count,
                                                              srcx,
                                                              srcy,
                                                              srcwidth,
                                                              srcheight,
                                                              srcUnit,
                                                              imageAttributes
                                                               ? imageAttributes.nativeImageAttr
                                                               : null,
                                                              callback,
                                                              callbackData));
    }
    
    Status DrawImage(
        in Image image,
        in RectF destRect,
        in RectF sourceRect,
        in Unit srcUnit,
        in ImageAttributes *imageAttributes = null
    )
    {
        return SetStatus(GdipDrawImageRectRect(
            nativeGraphics,
            image.nativeImage,
            destRect.X,
            destRect.Y,
            destRect.Width,
            destRect.Height,
            sourceRect.X,
            sourceRect.Y,
            sourceRect.Width,
            sourceRect.Height,
            srcUnit,
            imageAttributes ? imageAttributes.nativeImageAttr : null,
            null,
            null
        ));
    }

version(GDIPLUS6) {
    Status DrawImage(
        in Image image,
        in RectF *sourceRect,
        in Matrix xForm,
        in Effect effect,
        in ImageAttributes imageAttributes,
        in Unit srcUnit
    )
    {
        return SetStatus(GdipDrawImageFX(
            nativeGraphics,
            image.nativeImage,
            sourceRect,
            xForm ? xForm.nativeMatrix : null,
            effect ? effect.nativeEffect : null,
            imageAttributes ? imageAttributes.nativeImageAttr : null,
            srcUnit
        ));
    }
}

    // The following methods are for playing an EMF+ to a graphics
    // via the enumeration interface.  Each record of the EMF+ is
    // sent to the callback (along with the callbackData).  Then
    // the callback can invoke the Metafile::PlayRecord method
    // to play the particular record.

    Status
    EnumerateMetafile(
        in Metafile *        metafile,
        in PointF           destPoint,
        in EnumerateMetafileProc   callback,
        in VOID *                  callbackData    = null,
        in ImageAttributes *       imageAttributes = null
        )
    {
        return SetStatus(GdipEnumerateMetafileDestPoint(
                    nativeGraphics,
                    cast( GpMetafile *)(metafile ? metafile.nativeImage:null),
                    destPoint,
                    callback,
                    callbackData,
                    imageAttributes ? imageAttributes.nativeImageAttr : null));
    }

    Status
    EnumerateMetafile(
        in Metafile *        metafile,
        in Point            destPoint,
        in EnumerateMetafileProc   callback,
        in VOID *                  callbackData    = null,
        in ImageAttributes *       imageAttributes = null
        )
    {
        return SetStatus(GdipEnumerateMetafileDestPointI(
                    nativeGraphics,
                    cast( GpMetafile *)(metafile ? metafile.nativeImage:null),
                    destPoint,
                    callback,
                    callbackData,
                    imageAttributes ? imageAttributes.nativeImageAttr : null));
    }

    Status
    EnumerateMetafile(
        in Metafile *        metafile,
        in RectF            destRect,
        in EnumerateMetafileProc   callback,
        in VOID *                  callbackData    = null,
        in ImageAttributes *       imageAttributes = null
        )
    {
        return SetStatus(GdipEnumerateMetafileDestRect(
                    nativeGraphics,
                    cast(GpMetafile *)(metafile ? metafile.nativeImage:null),
                    destRect,
                    callback,
                    callbackData,
                    imageAttributes ? imageAttributes.nativeImageAttr : null));
    }

    Status
    EnumerateMetafile(
        in Metafile *        metafile,
        in Rect             destRect,
        in EnumerateMetafileProc   callback,
        in VOID *                  callbackData    = null,
        in ImageAttributes *       imageAttributes = null
        )
    {
        return SetStatus(GdipEnumerateMetafileDestRectI(
                    nativeGraphics,
                    cast(GpMetafile *)(metafile ? metafile.nativeImage:null),
                    destRect,
                    callback,
                    callbackData,
                    imageAttributes ? imageAttributes.nativeImageAttr : null));
    }

    Status
    EnumerateMetafile(
        in Metafile *        metafile,
        in PointF *          destPoints,
        in INT                     count,
        in EnumerateMetafileProc   callback,
        in VOID *                  callbackData    = null,
        in ImageAttributes *       imageAttributes = null
        )
    {
        return SetStatus(GdipEnumerateMetafileDestPoints(
                    nativeGraphics,
                    cast(GpMetafile *)(metafile ? metafile.nativeImage:null),
                    destPoints,
                    count,
                    callback,
                    callbackData,
                    imageAttributes ? imageAttributes.nativeImageAttr : null));
    }

    Status
    EnumerateMetafile(
        in Metafile *        metafile,
        in Point *           destPoints,
        in INT                     count,
        in EnumerateMetafileProc   callback,
        in VOID *                  callbackData    = null,
        in ImageAttributes *       imageAttributes = null
        )
    {
        return SetStatus(GdipEnumerateMetafileDestPointsI(
                    nativeGraphics,
                    cast(GpMetafile *)(metafile ? metafile.nativeImage:null),
                    destPoints,
                    count,
                    callback,
                    callbackData,
                    imageAttributes ? imageAttributes.nativeImageAttr : null));
    }

    Status
    EnumerateMetafile(
        in Metafile *        metafile,
        in PointF           destPoint,
        in RectF            srcRect,
        in Unit                    srcUnit,
        in EnumerateMetafileProc   callback,
        in VOID *                  callbackData    = null,
        in ImageAttributes *       imageAttributes = null
        )
    {
        return SetStatus(GdipEnumerateMetafileSrcRectDestPoint(
                    nativeGraphics,
                    cast(GpMetafile *)(metafile ? metafile.nativeImage:null),
                    destPoint,
                    srcRect,
                    srcUnit,
                    callback,
                    callbackData,
                    imageAttributes ? imageAttributes.nativeImageAttr : null));
    }

    Status
    EnumerateMetafile(
        in Metafile *        metafile,
        in Point           destPoint,
        in Rect             srcRect,
        in Unit                    srcUnit,
        in EnumerateMetafileProc   callback,
        in VOID *                  callbackData    = null,
        in ImageAttributes *       imageAttributes = null
        )
    {
        return SetStatus(GdipEnumerateMetafileSrcRectDestPointI(
                    nativeGraphics,
                    cast(GpMetafile *)(metafile ? metafile.nativeImage:null),
                    destPoint,
                    srcRect,
                    srcUnit,
                    callback,
                    callbackData,
                    imageAttributes ? imageAttributes.nativeImageAttr : null));
    }

    Status
    EnumerateMetafile(
        in Metafile *        metafile,
        in RectF            destRect,
        in RectF            srcRect,
        in Unit                    srcUnit,
        in EnumerateMetafileProc   callback,
        in VOID *                  callbackData    = null,
        in ImageAttributes *       imageAttributes = null
        )
    {
        return SetStatus(GdipEnumerateMetafileSrcRectDestRect(
                    nativeGraphics,
                    cast(GpMetafile *)(metafile ? metafile.nativeImage:null),
                    destRect,
                    srcRect,
                    srcUnit,
                    callback,
                    callbackData,
                    imageAttributes ? imageAttributes.nativeImageAttr : null));
    }

    Status
    EnumerateMetafile(
        in Metafile         metafile,
        in Rect             destRect,
        in Rect             srcRect,
        in Unit                    srcUnit,
        in EnumerateMetafileProc   callback,
        in VOID *                  callbackData    = null,
        in ImageAttributes        imageAttributes = null
        )
    {
        return SetStatus(GdipEnumerateMetafileSrcRectDestRectI(
                    nativeGraphics,
                    cast(GpMetafile *)(metafile ? metafile.nativeImage:null),
                    destRect,
                    srcRect,
                    srcUnit,
                    callback,
                    callbackData,
                    imageAttributes ? imageAttributes.nativeImageAttr : null));
    }

    Status
    EnumerateMetafile(
        in Metafile         metafile,
        in PointF *          destPoints,
        in INT                     count,
        in RectF            srcRect,
        in Unit                    srcUnit,
        in EnumerateMetafileProc   callback,
        in VOID *                  callbackData    = null,
        in ImageAttributes        imageAttributes = null
        )
    {
        return SetStatus(GdipEnumerateMetafileSrcRectDestPoints(
                    nativeGraphics,
                    cast(GpMetafile *)(metafile ? metafile.nativeImage:null),
                    destPoints,
                    count,
                    srcRect,
                    srcUnit,
                    callback,
                    callbackData,
                    imageAttributes ? imageAttributes.nativeImageAttr : null));
    }

    Status
    EnumerateMetafile(
        in Metafile         metafile,
        in Point[]            destPoints,
        in INT                     count,
        in Rect             srcRect,
        in Unit                    srcUnit,
        in EnumerateMetafileProc   callback,
        in VOID *                  callbackData    = null,
        in ImageAttributes        imageAttributes = null
        )
    {
        return SetStatus(GdipEnumerateMetafileSrcRectDestPointsI(
                    nativeGraphics,
                    cast(GpMetafile *)(metafile ? metafile.nativeImage:null),
                    destPoints.ptr,
                    count,
                    srcRect,
                    srcUnit,
                    callback,
                    callbackData,
                    imageAttributes ? imageAttributes.nativeImageAttr : null));
    }
    
    Status SetClip(in Graphics g,
                   in CombineMode combineMode = CombineMode.CombineModeReplace)
    {
        return SetStatus(GdipSetClipGraphics(nativeGraphics,
                                                         g.nativeGraphics,
                                                         combineMode));
    }

    Status SetClip(in RectF rect,
                   in CombineMode combineMode = CombineMode.CombineModeReplace)
    {
        return SetStatus(GdipSetClipRect(nativeGraphics,
                                                     rect.X, rect.Y,
                                                     rect.Width, rect.Height,
                                                     combineMode));
    }

    Status SetClip(in Rect rect,
                   in CombineMode combineMode = CombineMode.CombineModeReplace)
    {
        return SetStatus(GdipSetClipRectI(nativeGraphics,
                                                      rect.X, rect.Y,
                                                      rect.Width, rect.Height,
                                                      combineMode));
    }

    Status SetClip(in GraphicsPath path,
                   in CombineMode combineMode = CombineMode.CombineModeReplace)
    {
        return SetStatus(GdipSetClipPath(nativeGraphics,
                                                     path.nativePath,
                                                     combineMode));
    }

    Status SetClip(in Region region,
                   in CombineMode combineMode = CombineMode.CombineModeReplace)
    {
        return SetStatus(GdipSetClipRegion(nativeGraphics,
                                                       region.nativeRegion,
                                                       combineMode));
    }

    // This is different than the other SetClip methods because it assumes
    // that the HRGN is already in device units, so it doesn't transform
    // the coordinates in the HRGN.
    
    Status SetClip(in HRGN hRgn,
                   in CombineMode combineMode = CombineMode.CombineModeReplace)
    {
        return SetStatus(GdipSetClipHrgn(nativeGraphics, hRgn,
                                                     combineMode));
    }

    Status IntersectClip(in RectF rect)
    {
        return SetStatus(GdipSetClipRect(nativeGraphics,
                                                     rect.X, rect.Y,
                                                     rect.Width, rect.Height,
                                                     CombineMode.CombineModeIntersect));
    }

    Status IntersectClip(in Rect rect)
    {
        return SetStatus(GdipSetClipRectI(nativeGraphics,
                                                      rect.X, rect.Y,
                                                      rect.Width, rect.Height,
                                                      CombineMode.CombineModeIntersect));
    }

    Status IntersectClip(in Region* region)
    {
        return SetStatus(GdipSetClipRegion(nativeGraphics,
                                                       region.nativeRegion,
                                                       CombineMode.CombineModeIntersect));
    }

    Status ExcludeClip(in RectF rect)
    {
        return SetStatus(GdipSetClipRect(nativeGraphics,
                                                     rect.X, rect.Y,
                                                     rect.Width, rect.Height,
                                                     CombineMode.CombineModeExclude));
    }

    Status ExcludeClip(in Rect rect)
    {
        return SetStatus(GdipSetClipRectI(nativeGraphics,
                                                      rect.X, rect.Y,
                                                      rect.Width, rect.Height,
                                                      CombineMode.CombineModeExclude));
    }

    Status ExcludeClip(in Region* region)
    {
        return SetStatus(GdipSetClipRegion(nativeGraphics,
                                                       region.nativeRegion,
                                                       CombineMode.CombineModeExclude));
    }

    Status ResetClip()
    {
        return SetStatus(GdipResetClip(nativeGraphics));
    }

    Status TranslateClip(in REAL dx,
                         in REAL dy)
    {
        return SetStatus(GdipTranslateClip(nativeGraphics, dx, dy));
    }

    Status TranslateClip(in INT dx,
                         in INT dy)
    {
        return SetStatus(GdipTranslateClipI(nativeGraphics,
                                                        dx, dy));
    }

    Status GetClip(Region* region)
    {
        return SetStatus(GdipGetClip(nativeGraphics,
                                                 region.nativeRegion));
    }

    Status GetClipBounds(RectF* rect)
    {
        return SetStatus(GdipGetClipBounds(nativeGraphics, rect));
    }

    Status GetClipBounds(Rect* rect)
    {
        return SetStatus(GdipGetClipBoundsI(nativeGraphics, rect));
    }

    BOOL IsClipEmpty()
    {
        BOOL booln = FALSE;

        SetStatus(GdipIsClipEmpty(nativeGraphics, &booln));

        return booln;
    }

    Status GetVisibleClipBounds(RectF *rect)
    {

        return SetStatus(GdipGetVisibleClipBounds(nativeGraphics,
                                                              rect));
    }

    Status GetVisibleClipBounds(Rect *rect)
    {
       return SetStatus(GdipGetVisibleClipBoundsI(nativeGraphics,
                                                              rect));
    }

    BOOL IsVisibleClipEmpty()
    {
        BOOL booln = FALSE;

        SetStatus(GdipIsVisibleClipEmpty(nativeGraphics, &booln));

        return booln;
    }

    BOOL IsVisible(in INT x,
                   in INT y)
    {
        return IsVisible(Point(x,y));
    }

    BOOL IsVisible(in Point point)
    {
        BOOL booln = FALSE;

        SetStatus(GdipIsVisiblePointI(nativeGraphics,
                                                  point.X,
                                                  point.Y,
                                                  &booln));

        return booln;
    }

    BOOL IsVisible(in INT x,
                   in INT y,
                   in INT width,
                   in INT height)
    {
        return IsVisible(Rect(x, y, width, height));
    }

    BOOL IsVisible(in Rect rect)
    {

        BOOL booln = TRUE;

        SetStatus(GdipIsVisibleRectI(nativeGraphics,
                                                 rect.X,
                                                 rect.Y,
                                                 rect.Width,
                                                 rect.Height,
                                                 &booln));
        return booln;
    }

    BOOL IsVisible(in REAL x,
                   in REAL y)
    {
        return IsVisible(PointF(x, y));
    }

    BOOL IsVisible(in PointF point)
    {
        BOOL booln = FALSE;

        SetStatus(GdipIsVisiblePoint(nativeGraphics,
                                                 point.X,
                                                 point.Y,
                                                 &booln));

        return booln;
    }

    BOOL IsVisible(in REAL x,
                   in REAL y,
                   in REAL width,
                   in REAL height) {
        RectF rect;
        rect.init(x, y, width, height);
        return IsVisible(rect);
    }

    BOOL IsVisible(in RectF rect) {
        BOOL booln = TRUE;

        SetStatus(GdipIsVisibleRect(nativeGraphics,
                                                rect.X,
                                                rect.Y,
                                                rect.Width,
                                                rect.Height,
                                                &booln));
        return booln;
    }

    GraphicsState Save()
    {
        GraphicsState gstate;

        SetStatus(GdipSaveGraphics(nativeGraphics, &gstate));

        return gstate;
    }

    Status Restore(in GraphicsState gstate)
    {
        return SetStatus(GdipRestoreGraphics(nativeGraphics,
                                                         gstate));
    }

    GraphicsContainer BeginContainer(in RectF dstrect,
                                     in RectF srcrect,
                                     in Unit         unit)
    {
        GraphicsContainer state;

        SetStatus(GdipBeginContainer(nativeGraphics, &dstrect,
                                                 &srcrect, unit, &state));

        return state;
    }

    GraphicsContainer BeginContainer(in Rect    dstrect,
                                     in Rect    srcrect,
                                     in Unit           unit)
    {
        GraphicsContainer state;

        SetStatus(GdipBeginContainerI(nativeGraphics, &dstrect,
                                                  &srcrect, unit, &state));

        return state;
    }

    GraphicsContainer BeginContainer()
    {
        GraphicsContainer state;

        SetStatus(GdipBeginContainer2(nativeGraphics, &state));

        return state;
    }

    Status EndContainer(in GraphicsContainer state)
    {
        return SetStatus(GdipEndContainer(nativeGraphics, state));
    }

    // Only valid when recording metafiles.

    Status AddMetafileComment(in BYTE * data,
                              in UINT sizeData)
    {
        return SetStatus(GdipComment(nativeGraphics, sizeData, data));
    }

    static HPALETTE GetHalftonePalette()
    {
        return GdipCreateHalftonePalette();
    }

    Status GetLastStatus()
    {
        Status lastStatus = lastResult;
        lastResult = Status.Ok;

        return lastStatus;
    }

protected:
    package this(GpGraphics* graphics) {
        lastResult = Status.Ok;
        SetNativeGraphics(graphics);
    }

    VOID SetNativeGraphics(GpGraphics *graphics)
    {
        this.nativeGraphics = graphics;
    }

    Status SetStatus(Status status)
    {
        if (status != Status.Ok)
            return (lastResult = status);
        else
            return status;
    }

    GpGraphics* GetNativeGraphics()
    {
        return this.nativeGraphics;
    }

    GpPen* GetNativePen(Pen pen) {
        return pen.nativePen;
    }

protected:
    package GpGraphics* nativeGraphics;
    package Status lastResult;

}

