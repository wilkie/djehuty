/*
 * gdipluspath.d
 *
 * This module implements GdiPlusPath.h for D. The original
 * copyright info is given below.
 *
 * Author: Dave Wilkinson
 * Originated: November 25th, 2009
 *
 */

module binding.win32.gdipluspath;

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
import binding.win32.gdiplusgraphics;
import binding.win32.gdiplusfontfamily;
import binding.win32.gdiplusfont;
import binding.win32.gdiplusbrush;
import binding.win32.gdipluspen;
import binding.win32.gdiplusstringformat;

/**************************************************************************\
*
* Copyright (c) 1998-2001, Microsoft Corp.  All Rights Reserved.
*
* Module Name:
*
*   GdiplusPath.h
*
* Abstract:
*
*   GDI+ Graphics Path class
*
\**************************************************************************/

class GraphicsPath : GdiplusBase {

    this(in FillMode fillMode = FillMode.FillModeAlternate) {
        nativePath = null;
        lastResult = GdipCreatePath(fillMode, &nativePath);
    }

    this(in PointF* points,
                 in BYTE* types,
                 in INT count,
                 in FillMode fillMode = FillMode.FillModeAlternate) {
        nativePath = null;
        lastResult = GdipCreatePath2(points,
                                                 types,
                                                 count,
                                                 fillMode,
                                                 &nativePath);
    }

    this(in Point* points,
                 in BYTE* types,
                 in INT count,
                 in FillMode fillMode = FillMode.FillModeAlternate) {
        nativePath = null;
        lastResult = GdipCreatePath2I(points,
                                                  types,
                                                  count,
                                                  fillMode,
                                                  &nativePath);
    }

    ~this() {
        GdipDeletePath(nativePath);
    }

    GraphicsPath Clone() {
        GpPath *clonepath = null;

        SetStatus(GdipClonePath(nativePath, &clonepath));

        return new GraphicsPath(clonepath);
    }

    alias Clone dup;

    // Reset the path object to empty (and fill mode to FillModeAlternate)

    Status Reset() {
        return SetStatus(GdipResetPath(nativePath));
    }

    FillMode GetFillMode() {
        FillMode fillmode = FillMode.FillModeAlternate;

        SetStatus(GdipGetPathFillMode(nativePath, &fillmode));

        return fillmode;
    }

    Status SetFillMode(in FillMode fillmode) {
        return SetStatus(GdipSetPathFillMode(nativePath,
                                                         fillmode));
    }

    Status GetPathData(ref PathData pathData) {
        
        INT count = GetPointCount();

        if ((count <= 0) || (pathData.Count>0 && pathData.Count<count)) {
            pathData.Count = 0;
            if (pathData.Points) {                
                pathData.Points = null;
            }

            if (pathData.Types) {
                pathData.Types = null;
            }

            if (count <= 0) {
                return Status.Ok;
            }
        }

        if (pathData.Count == 0)  {
            pathData.Points = new PointF[count];
            if (pathData.Points is null)  {
                return SetStatus(Status.OutOfMemory);

            }
            pathData.Types = new BYTE[count];
            if (pathData.Types is null)  {
                pathData.Points = null;

                return SetStatus(Status.OutOfMemory);
            }
            pathData.Count = count;
        }

        return SetStatus(GdipGetPathData(nativePath, &pathData));
    }

    Status StartFigure() {
        return SetStatus(GdipStartPathFigure(nativePath));
    }

    Status CloseFigure() {
        return SetStatus(GdipClosePathFigure(nativePath));
    }

    Status CloseAllFigures() {
        return SetStatus(GdipClosePathFigures(nativePath));
    }

    Status SetMarker() {
        return SetStatus(GdipSetPathMarker(nativePath));
    }

    Status ClearMarkers() {
        return SetStatus(GdipClearPathMarkers(nativePath));
    }

    Status Reverse() {
        return SetStatus(GdipReversePath(nativePath));
    }

    Status GetLastPoint(PointF* lastPoint) {
        return SetStatus(GdipGetPathLastPoint(nativePath,
                                                          lastPoint));
    }

    Status AddLine(in PointF pt1,
                   in PointF pt2) {
        return AddLine(pt1.X, pt1.Y, pt2.X, pt2.Y);
    }

    Status AddLine(in REAL x1,
                   in REAL y1,
                   in REAL x2,
                   in REAL y2) {
        return SetStatus(GdipAddPathLine(nativePath, x1, y1,
                                                     x2, y2));
    }

    Status AddLines(in PointF* points,
                    in INT count) {
        return SetStatus(GdipAddPathLine2(nativePath, points,
                                                      count));
    }

    Status AddLine(in Point pt1,
                   in Point pt2) {
        return AddLine(pt1.X,
                       pt1.Y,
                       pt2.X,
                       pt2.Y);
    }

    Status AddLine(in INT x1,
                   in INT y1,
                   in INT x2,
                   in INT y2) {
        return SetStatus(GdipAddPathLineI(nativePath,
                                                     x1,
                                                     y1,
                                                     x2,
                                                     y2));
    }

    Status AddLines(in Point* points,
                    in INT count) {
        return SetStatus(GdipAddPathLine2I(nativePath,
                                                       points,
                                                       count));
    }

    Status AddArc(in RectF rect,
                  in REAL startAngle,
                  in REAL sweepAngle) {
        return AddArc(rect.X, rect.Y, rect.Width, rect.Height,
                      startAngle, sweepAngle);
    }

    Status AddArc(in REAL x,
                  in REAL y,
                  in REAL width,
                  in REAL height,
                  in REAL startAngle,
                  in REAL sweepAngle) {
        return SetStatus(GdipAddPathArc(nativePath, x, y, width,
                                                    height, startAngle,
                                                    sweepAngle));
    }

    Status AddArc(in Rect rect,
                  in REAL startAngle,
                  in REAL sweepAngle) {
        return AddArc(rect.X, rect.Y, rect.Width, rect.Height,
                      startAngle, sweepAngle);
    }

    Status AddArc(in INT x,
                  in INT y,
                  in INT width,
                  in INT height,
                  in REAL startAngle,
                  in REAL sweepAngle) {
        return SetStatus(GdipAddPathArcI(nativePath,
                                                    x,
                                                    y,
                                                    width,
                                                    height,
                                                    startAngle,
                                                    sweepAngle));
    }

    Status AddBezier(in PointF pt1,
                     in PointF pt2,
                     in PointF pt3,
                     in PointF pt4) {
        return AddBezier(pt1.X, pt1.Y, pt2.X, pt2.Y, pt3.X, pt3.Y, pt4.X,
                         pt4.Y);
    }

    Status AddBezier(in REAL x1,
                     in REAL y1,
                     in REAL x2,
                     in REAL y2,
                     in REAL x3,
                     in REAL y3,
                     in REAL x4,
                     in REAL y4) {
        return SetStatus(GdipAddPathBezier(nativePath, x1, y1, x2,
                                                       y2, x3, y3, x4, y4));
    }

    Status AddBeziers(in PointF* points,
                      in INT count) {
        return SetStatus(GdipAddPathBeziers(nativePath, points,
                                                        count));
    }

    Status AddBezier(in Point pt1,
                     in Point pt2,
                     in Point pt3,
                     in Point pt4) {
       return AddBezier(pt1.X, pt1.Y, pt2.X, pt2.Y, pt3.X, pt3.Y, pt4.X,
                        pt4.Y);
    }

    Status AddBezier(in INT x1,
                     in INT y1,
                     in INT x2,
                     in INT y2,
                     in INT x3,
                     in INT y3,
                     in INT x4,
                     in INT y4) {
       return SetStatus(GdipAddPathBezierI(nativePath,
                                                      x1,
                                                      y1,
                                                      x2,
                                                      y2,
                                                      x3,
                                                      y3,
                                                      x4,
                                                      y4));
    }

    Status AddBeziers(in Point* points,
                      in INT count) {
       return SetStatus(GdipAddPathBeziersI(nativePath,
                                                        points,
                                                        count));
    }

    Status AddCurve(in PointF* points,
                    in INT count) {
        return SetStatus(GdipAddPathCurve(nativePath,
                                                      points,
                                                      count));
    }

    Status AddCurve(in PointF* points,
                    in INT count,
                    in REAL tension) {
        return SetStatus(GdipAddPathCurve2(nativePath,
                                                       points,
                                                       count,
                                                       tension));
    }

    Status AddCurve(in PointF* points,
                    in INT count,
                    in INT offset,
                    in INT numberOfSegments,
                    in REAL tension) {
        return SetStatus(GdipAddPathCurve3(nativePath,
                                                       points,
                                                       count,
                                                       offset,
                                                       numberOfSegments,
                                                       tension));
    }

    Status AddCurve(in Point* points,
                    in INT count) {
       return SetStatus(GdipAddPathCurveI(nativePath,
                                                     points,
                                                     count));
    }

    Status AddCurve(in Point* points,
                    in INT count,
                    in REAL tension) {
       return SetStatus(GdipAddPathCurve2I(nativePath,
                                                      points,
                                                      count,
                                                      tension));
    }

    Status AddCurve(in Point* points,
                    in INT count,
                    in INT offset,
                    in INT numberOfSegments,
                    in REAL tension) {
       return SetStatus(GdipAddPathCurve3I(nativePath,
                                                      points,
                                                      count,
                                                      offset,
                                                      numberOfSegments,
                                                      tension));
    }

    Status AddClosedCurve(in PointF* points,
                          in INT count) {
        return SetStatus(GdipAddPathClosedCurve(nativePath,
                                                            points,
                                                            count));
    }

    Status AddClosedCurve(in PointF* points,
                          in INT count,
                          in REAL tension) {
        return SetStatus(GdipAddPathClosedCurve2(nativePath,
                                                             points,
                                                             count,
                                                             tension));
    }

    Status AddClosedCurve(in Point* points,
                          in INT count) {
       return SetStatus(GdipAddPathClosedCurveI(nativePath,
                                                            points,
                                                            count));
    }


    Status AddClosedCurve(in Point* points,
                          in INT count,
                          in REAL tension) {
       return SetStatus(GdipAddPathClosedCurve2I(nativePath,
                                                             points,
                                                             count,
                                                             tension));
    }

    Status AddRectangle(in RectF rect) {
        return SetStatus(GdipAddPathRectangle(nativePath,
                                                          rect.X,
                                                          rect.Y,
                                                          rect.Width,
                                                          rect.Height));
    }

    Status AddRectangles(in RectF* rects,
                         in INT count) {
        return SetStatus(GdipAddPathRectangles(nativePath,
                                                           rects,
                                                           count));
    }

    Status AddRectangle(in Rect rect) {
        return SetStatus(GdipAddPathRectangleI(nativePath,
                                                          rect.X,
                                                          rect.Y,
                                                          rect.Width,
                                                          rect.Height));
    }

    Status AddRectangles(in Rect* rects, INT count) {
        return SetStatus(GdipAddPathRectanglesI(nativePath,
                                                           rects,
                                                           count));
    }

    Status AddEllipse(in RectF rect) {
        return AddEllipse(rect.X, rect.Y, rect.Width, rect.Height);
    }

    Status AddEllipse(in REAL x,
                      in REAL y,
                      in REAL width,
                      in REAL height) {
        return SetStatus(GdipAddPathEllipse(nativePath,
                                                        x,
                                                        y,
                                                        width,
                                                        height));
    }

    Status AddEllipse(in Rect rect) {
        return AddEllipse(rect.X, rect.Y, rect.Width, rect.Height);
    }

    Status AddEllipse(in INT x,
                      in INT y,
                      in INT width,
                      in INT height) {
        return SetStatus(GdipAddPathEllipseI(nativePath,
                                                        x,
                                                        y,
                                                        width,
                                                        height));
    }

    Status AddPie(in RectF rect,
                  in REAL startAngle,
                  in REAL sweepAngle) {
        return AddPie(rect.X, rect.Y, rect.Width, rect.Height, startAngle,
                      sweepAngle);
    }

    Status AddPie(in REAL x,
                  in REAL y,
                  in REAL width,
                  in REAL height,
                  in REAL startAngle,
                  in REAL sweepAngle) {
        return SetStatus(GdipAddPathPie(nativePath, x, y, width,
                                                    height, startAngle,
                                                    sweepAngle));
    }

    Status AddPie(in Rect rect,
                  in REAL startAngle,
                  in REAL sweepAngle) {
        return AddPie(rect.X,
                      rect.Y,
                      rect.Width,
                      rect.Height,
                      startAngle,
                      sweepAngle);
    }

    Status AddPie(in INT x,
                  in INT y,
                  in INT width,
                  in INT height,
                  in REAL startAngle,
                  in REAL sweepAngle) {
        return SetStatus(GdipAddPathPieI(nativePath,
                                                    x,
                                                    y,
                                                    width,
                                                    height,
                                                    startAngle,
                                                    sweepAngle));
    }

    Status AddPolygon(in PointF* points,
                      in INT count) {
        return SetStatus(GdipAddPathPolygon(nativePath, points,
                                                        count));
    }

    Status AddPolygon(in Point* points,
                      in INT count) {
       return SetStatus(GdipAddPathPolygonI(nativePath, points,
                                                        count));
    }

    Status AddPath(in GraphicsPath addingPath,
                   in BOOL connect) {
        GpPath* nativePath2 = null;
        if(addingPath)
            nativePath2 = addingPath.nativePath;

        return SetStatus(GdipAddPathPath(nativePath, nativePath2,
                                                     connect));
    }

    Status AddString(
        in WCHAR         *string,
        in INT                  length,
        in FontFamily    family,
        in INT                  style,
        in REAL                 emSize,  // World units
        in PointF        origin,
        in StringFormat  format
    ) {
        RectF rect = RectF.init(origin.X, origin.Y, 0.0f, 0.0f);

        return SetStatus(GdipAddPathString(
            nativePath,
            string,
            length,
            family ? family.nativeFamily : null,
            style,
            emSize,
            &rect,
            format ? format.nativeFormat : null
        ));
    }

    Status AddString(
        in WCHAR         *string,
        in INT                  length,
        in FontFamily    family,
        in INT                  style,
        in REAL                 emSize,  // World units
        in RectF         layoutRect,
        in StringFormat  format
    ) {
        return SetStatus(GdipAddPathString(
            nativePath,
            string,
            length,
            family ? family.nativeFamily : null,
            style,
            emSize,
            &layoutRect,
            format ? format.nativeFormat : null
        ));
    }

    Status AddString(
        in WCHAR         *string,
        in INT                  length,
        in FontFamily    family,
        in INT                  style,
        in REAL                 emSize,  // World units
        in Point         origin,
        in StringFormat  format
    ) {
        Rect rect = Rect.init(origin.X, origin.Y, 0, 0);

        return SetStatus(GdipAddPathStringI(
            nativePath,
            string,
            length,
            family ? family.nativeFamily : null,
            style,
            emSize,
            &rect,
            format ? format.nativeFormat : null
        ));
    }

    Status AddString(
        in WCHAR         *string,
        in INT                  length,
        in FontFamily    family,
        in INT                  style,
        in REAL                 emSize,  // World units
        in Rect          layoutRect,
        in StringFormat  format
    ) {
        return SetStatus(GdipAddPathStringI(
            nativePath,
            string,
            length,
            family ? family.nativeFamily : null,
            style,
            emSize,
            &layoutRect,
            format ? format.nativeFormat : null
        ));
    }

    Status Transform(in Matrix matrix) {
        if(matrix)
            return SetStatus(GdipTransformPath(nativePath,
                                                      matrix.nativeMatrix));
        else
            return Status.Ok;
    }

    // This is not always the tightest bounds.

    Status GetBounds(RectF* bounds,
                     in Matrix matrix = null,
                     in Pen pen = null) {
	    GpMatrix* nativeMatrix = null;
	    GpPen* nativePen = null;

	    if (matrix)
	        nativeMatrix = matrix.nativeMatrix;

	    if (pen)
	        nativePen = pen.nativePen;

	    return SetStatus(GdipGetPathWorldBounds(nativePath, bounds,
	                                                   nativeMatrix, nativePen));
    }

    Status GetBounds(Rect* bounds,
                     in Matrix matrix = null,
                     in Pen pen = null) {
	    GpMatrix* nativeMatrix = null;
	    GpPen* nativePen = null;

	    if (matrix)
	        nativeMatrix = matrix.nativeMatrix;

	    if (pen)
	        nativePen = pen.nativePen;

	    return SetStatus(GdipGetPathWorldBoundsI(nativePath, bounds,
	                                                    nativeMatrix, nativePen));
    }

    // Once flattened, the resultant path is made of line segments and
    // the original path information is lost.  When matrix is null the
    // identity matrix is assumed.

    Status Flatten(in Matrix matrix = null,
                   in REAL flatness = FlatnessDefault) {
        GpMatrix* nativeMatrix = null;
        if(matrix) {
            nativeMatrix = matrix.nativeMatrix;
        }

        return SetStatus(GdipFlattenPath(
            nativePath,
            nativeMatrix,
            flatness
        ));
    }

    Status Widen(
        in Pen* pen,
        in Matrix matrix = null,
        in REAL flatness = FlatnessDefault
    ) {
        GpMatrix* nativeMatrix = null;
        if(matrix)
            nativeMatrix = matrix.nativeMatrix;

        return SetStatus(GdipWidenPath(
            nativePath,
            pen.nativePen,
            nativeMatrix,
            flatness
        ));
    }

    Status Outline(
        in Matrix matrix = null,
        in REAL flatness = FlatnessDefault
    ) {
        GpMatrix* nativeMatrix = null;
        if(matrix) {
            nativeMatrix = matrix.nativeMatrix;
        }

        return SetStatus(GdipWindingModeOutline(
            nativePath, nativeMatrix, flatness
        ));
    }

    // Once this is called, the resultant path is made of line segments and
    // the original path information is lost.  When matrix is null, the
    // identity matrix is assumed.

    Status Warp(in PointF* destPoints,
                in INT count,
                in RectF srcRect,
                in Matrix matrix = null,
                in WarpMode warpMode = WarpMode.WarpModePerspective,
                in REAL flatness = FlatnessDefault) {
        GpMatrix* nativeMatrix = null;
        if(matrix)
            nativeMatrix = matrix.nativeMatrix;

        return SetStatus(GdipWarpPath(
                                        nativePath,
                                        nativeMatrix,
                                        destPoints,
                                        count,
                                        srcRect.X,
                                        srcRect.Y,
                                        srcRect.Width,
                                        srcRect.Height,
                                        warpMode,
                                        flatness));
    }

    INT GetPointCount() {
        INT count = 0;

        SetStatus(GdipGetPointCount(nativePath, &count));

        return count;
    }

    Status GetPathTypes(BYTE* types,
                        in INT count) {
        return SetStatus(GdipGetPathTypes(nativePath, types,
                                                      count));
    }

    Status GetPathPoints(PointF* points,
                         in INT count) {
        return SetStatus(GdipGetPathPoints(nativePath, points,
                                                       count));
    }

    Status GetPathPoints(Point* points,
                         in INT count) {
        return SetStatus(GdipGetPathPointsI(nativePath, points,
                                                        count));
    }

    Status GetLastStatus() {
        Status lastStatus = lastResult;
        lastResult = Status.Ok;

        return lastStatus;
    }

    BOOL IsVisible(in PointF point,
                   in Graphics g = null) {
        return IsVisible(point.X, point.Y, g);
    }

    BOOL IsVisible(in REAL x,
                   in REAL y,
                   in Graphics g = null) {
	   BOOL booln = FALSE;
	
	   GpGraphics* nativeGraphics = null;

	   if (g)
	       nativeGraphics = g.nativeGraphics;

	   SetStatus(GdipIsVisiblePathPoint(nativePath,
	                                                x, y, nativeGraphics,
	                                                &booln));
	   return booln;
    }

    BOOL IsVisible(in Point point,
                   in Graphics g = null) {
        return IsVisible(point.X, point.Y, g);
    }

    BOOL IsVisible(in INT x,
                   in INT y,
                   in Graphics g = null) {
	   BOOL booln = FALSE;
	
	   GpGraphics* nativeGraphics = null;

	   if (g)
	       nativeGraphics = g.nativeGraphics;

	   SetStatus(GdipIsVisiblePathPointI(nativePath,
	                                                 x, y, nativeGraphics,
	                                                 &booln));
	   return booln;
    }
/*
    BOOL IsOutlineVisible(in PointF point,
                          in Pen pen,
                          in Graphics g = null) {
        return IsOutlineVisible(point.X, point.Y, pen, g);
    }

    BOOL IsOutlineVisible(in REAL x,
                          in REAL y,
                          in Pen pen,
                          in Graphics g = null) {
    }

    BOOL IsOutlineVisible(in Point point,
                          in Pen pen,
                          in Graphics g = null) {
        return IsOutlineVisible(point.X, point.Y, pen, g);
    }

    BOOL IsOutlineVisible(in INT x,
                          in INT y,
                          in Pen pen,
                          in Graphics g = null) {
    }
*/
protected:

    package this(GraphicsPath path) {
        GpPath *clonepath = null;
        SetStatus(GdipClonePath(path.nativePath, &clonepath));
        SetNativePath(clonepath);
    }

    package this(GpPath* nativePath) {
        lastResult = Status.Ok;
        SetNativePath(nativePath);
    }

    VOID SetNativePath(GpPath *nativePath) {
        this.nativePath = nativePath;
    }

    Status SetStatus(Status status) {
        if (status != Status.Ok)
            return (lastResult = status);
        else
            return status;
    }

    package GpPath* nativePath;
    package Status lastResult;
}

//--------------------------------------------------------------------------
// GraphisPathIterator class
//--------------------------------------------------------------------------

class GraphicsPathIterator : GdiplusBase {

    this(in GraphicsPath* path) {
        GpPath* nativePath = null;
        if(path)
            nativePath = path.nativePath;

        GpPathIterator *iter = null;
        lastResult = GdipCreatePathIter(&iter, nativePath);
        SetNativeIterator(iter);
    }

    ~this() {
        GdipDeletePathIter(nativeIterator);
    }


    INT NextSubpath(INT* startIndex,
                    INT* endIndex,
                    BOOL* isClosed) {
        INT resultCount;

        SetStatus(GdipPathIterNextSubpath(nativeIterator,
            &resultCount, startIndex, endIndex, isClosed));

        return resultCount;
    }


    INT NextSubpath(GraphicsPath path,
                    BOOL* isClosed) {
        GpPath* nativePath = null;

        INT resultCount;

        if(path)
            nativePath= path.nativePath;

        SetStatus(GdipPathIterNextSubpathPath(nativeIterator,
            &resultCount, nativePath, isClosed));

        return resultCount;
    }

    INT NextPathType(BYTE* pathType,
                     INT* startIndex,
                     INT* endIndex) {
        INT resultCount;

        SetStatus(GdipPathIterNextPathType(nativeIterator,
            &resultCount, pathType, startIndex, endIndex));

        return resultCount;
    }

    INT NextMarker(INT* startIndex,
                   INT* endIndex) {
        INT resultCount;

        SetStatus(GdipPathIterNextMarker(nativeIterator,
            &resultCount, startIndex, endIndex));

        return resultCount;
    }


    INT NextMarker(GraphicsPath path) {
        GpPath* nativePath = null;

        INT resultCount;

        if(path)
            nativePath= path.nativePath;

        SetStatus(GdipPathIterNextMarkerPath(nativeIterator,
            &resultCount, nativePath));

        return resultCount;
    }

    INT GetCount() {
        INT resultCount;

        SetStatus(GdipPathIterGetCount(nativeIterator,
                                                   &resultCount));

        return resultCount;
    }

    INT GetSubpathCount() {
        INT resultCount;

        SetStatus(GdipPathIterGetSubpathCount(nativeIterator,
                                                          &resultCount));

        return resultCount;
    }

    BOOL HasCurve() {
        BOOL hasCurve;

        SetStatus(GdipPathIterHasCurve(nativeIterator, &hasCurve));

        return hasCurve;
    }

    VOID Rewind() {
        SetStatus(GdipPathIterRewind(nativeIterator));
    }

    INT Enumerate(PointF *points,
                  BYTE *types,
                  in INT count) {
        INT resultCount;

        SetStatus(GdipPathIterEnumerate(nativeIterator,
            &resultCount, points, types, count));

        return resultCount;
    }

    INT CopyData(PointF* points,
                 BYTE* types,
                 in INT startIndex,
                 in INT endIndex) {
        INT resultCount;

        SetStatus(GdipPathIterCopyData(nativeIterator,
            &resultCount, points, types, startIndex, endIndex));

        return resultCount;
    }

    Status GetLastStatus() {
        Status lastStatus = lastResult;
        lastResult = Status.Ok;

        return lastStatus;
    }

protected:
    VOID SetNativeIterator(GpPathIterator *nativeIterator) {
        this.nativeIterator = nativeIterator;
    }

    Status SetStatus(Status status) {
        if (status != Status.Ok)
            return (lastResult = status);
        else
            return status;
    }

    package GpPathIterator* nativeIterator;
    package Status lastResult;
}


//--------------------------------------------------------------------------
// Path Gradient Brush
//--------------------------------------------------------------------------

class PathGradientBrush : Brush {
    this(
        in PointF* points,
        in INT count,
        in WrapMode wrapMode = WrapMode.WrapModeClamp) {
        GpPathGradient *brush = null;

        lastResult = GdipCreatePathGradient(
                                        points, count,
                                        wrapMode, &brush);
        SetNativeBrush(brush);
    }

    this(
        in Point* points,
        in INT count,
        in WrapMode wrapMode = WrapMode.WrapModeClamp) {
        GpPathGradient *brush = null;

        lastResult = GdipCreatePathGradientI(
                                        points, count,
                                        wrapMode, &brush);

        SetNativeBrush(brush);
    }

    this(in GraphicsPath* path) {
        GpPathGradient *brush = null;

        lastResult = GdipCreatePathGradientFromPath(
                                        path.nativePath, &brush);
        SetNativeBrush(brush);
    }

    Status GetCenterColor(Color color) {
        ARGB argb;

        if (color is null) {
            return SetStatus(Status.InvalidParameter);
        }

        SetStatus(GdipGetPathGradientCenterColor(
                       cast(GpPathGradient*) nativeBrush, &argb));

        color.SetValue(argb);

        return lastResult;
    }

    Status SetCenterColor(Color color) {
        SetStatus(GdipSetPathGradientCenterColor(
                       cast(GpPathGradient*) nativeBrush,
                       color.GetValue()));

        return lastResult;
    }

    INT GetPointCount() {
        INT count;

        SetStatus(GdipGetPathGradientPointCount(
                       cast(GpPathGradient*) nativeBrush, &count));

        return count;
    }

    INT GetSurroundColorCount() {
        INT count;

        SetStatus(GdipGetPathGradientSurroundColorCount(
                       cast(GpPathGradient*) nativeBrush, &count));

        return count;
    }

    Status GetSurroundColors(Color* colors,
                             ref INT* count) {
        if(colors is null || count is null) {
            return SetStatus(Status.InvalidParameter);
        }

        INT count1;

        SetStatus(GdipGetPathGradientSurroundColorCount(
                        cast(GpPathGradient*) nativeBrush, &count1));

        if(lastResult != Status.Ok)
            return lastResult;

        if((*count < count1) || (count1 <= 0))
            return SetStatus(Status.InsufficientBuffer);

        ARGB[] argbs = new ARGB[count1];
        if(argbs is null)
            return SetStatus(Status.OutOfMemory);

        SetStatus(GdipGetPathGradientSurroundColorsWithCount(
                    cast(GpPathGradient*)nativeBrush, argbs.ptr, &count1));

        if(lastResult == Status.Ok) {
            for(INT i = 0; i < count1; i++) {
                colors[i].SetValue(argbs[i]);
            }
            *count = count1;
        }

        return lastResult;
    }

    Status SetSurroundColors(in Color* colors,
                             ref INT* count) {
        if(colors is null || count is null) {
            return SetStatus(Status.InvalidParameter);
        }

        INT count1 = GetPointCount();

        if((*count > count1) || (count1 <= 0))
            return SetStatus(Status.InvalidParameter);

        count1 = *count;

        ARGB[] argbs = new ARGB[count1];
        if(argbs is null)
            return SetStatus(Status.OutOfMemory);

        for(INT i = 0; i < count1; i++) {
            argbs[i] = colors[i].GetValue();
        }

        SetStatus(GdipSetPathGradientSurroundColorsWithCount(
                    cast(GpPathGradient*)nativeBrush, argbs.ptr, &count1));

        if(lastResult == Status.Ok)
            *count = count1;

        return lastResult;
    }

    Status GetGraphicsPath(GraphicsPath* path) {
        if(path is null)
            return SetStatus(Status.InvalidParameter);

        return SetStatus(GdipGetPathGradientPath(
                    cast(GpPathGradient*)nativeBrush, path.nativePath));
    }

    Status SetGraphicsPath(in GraphicsPath* path) {
        if(path is null)
            return SetStatus(Status.InvalidParameter);

        return SetStatus(GdipSetPathGradientPath(
                    cast(GpPathGradient*)nativeBrush, path.nativePath));
    }

    Status GetCenterPoint(PointF* point) {
        return SetStatus(GdipGetPathGradientCenterPoint(
                                cast(GpPathGradient*)nativeBrush,
                                point));
    }

    Status GetCenterPoint(Point* point) {
        return SetStatus(GdipGetPathGradientCenterPointI(
                                cast(GpPathGradient*)nativeBrush,
                                point));
    }

    Status SetCenterPoint(in PointF point) {
        return SetStatus(GdipSetPathGradientCenterPoint(
                                cast(GpPathGradient*)nativeBrush,
                                &point));
    }

    Status SetCenterPoint(in Point point) {
        return SetStatus(GdipSetPathGradientCenterPointI(
                                cast(GpPathGradient*)nativeBrush,
                                &point));
    }

    Status GetRectangle(RectF* rect) {
        return SetStatus(GdipGetPathGradientRect(
                            cast(GpPathGradient*)nativeBrush, rect));
    }

    Status GetRectangle(Rect* rect) {
        return SetStatus(GdipGetPathGradientRectI(
                            cast(GpPathGradient*)nativeBrush, rect));
    }

    Status SetGammaCorrection(in BOOL useGammaCorrection) {
        return SetStatus(GdipSetPathGradientGammaCorrection(
            cast(GpPathGradient*)nativeBrush, useGammaCorrection));
    }

    BOOL GetGammaCorrection() {
        BOOL useGammaCorrection;

        SetStatus(GdipGetPathGradientGammaCorrection(
            cast(GpPathGradient*)nativeBrush, &useGammaCorrection));

        return useGammaCorrection;
    }

    INT GetBlendCount() {
       INT count = 0;

       SetStatus(GdipGetPathGradientBlendCount(
                           cast(GpPathGradient*) nativeBrush, &count));

       return count;
    }

    Status GetBlend(REAL* blendFactors, REAL* blendPositions, in INT count) {
        return SetStatus(GdipGetPathGradientBlend(
                            cast(GpPathGradient*)nativeBrush,
                            blendFactors, blendPositions, count));
    }

    Status SetBlend(in REAL* blendFactors, in REAL* blendPositions, in INT count) {
        return SetStatus(GdipSetPathGradientBlend(
                            cast(GpPathGradient*)nativeBrush,
                            blendFactors, blendPositions, count));
    }

    INT GetInterpolationColorCount() {
       INT count = 0;

       SetStatus(GdipGetPathGradientPresetBlendCount(
                        cast(GpPathGradient*) nativeBrush, &count));

       return count;
    }

    Status SetInterpolationColors(in Color[] presetColors, in REAL* blendPositions, in INT count) {
        if ((count <= 0) || !presetColors) {
            return SetStatus(Status.InvalidParameter);
        }

        ARGB[] argbs = new ARGB[count];
        if(argbs !is null) {
            for(INT i = 0; i < count; i++) {
                argbs[i] = presetColors[i].GetValue();
            }

            Status status = SetStatus(
                               GdipSetPathGradientPresetBlend(
                                    cast(GpPathGradient*) nativeBrush,
                                    argbs.ptr,
                                    blendPositions,
                                    count));
            return status;
        }
        else {
            return SetStatus(Status.OutOfMemory);
        }
    }

    Status GetInterpolationColors(Color[] presetColors, REAL* blendPositions, in INT count) {
        if ((count <= 0) || !presetColors) {
            return SetStatus(Status.InvalidParameter);
        }

        ARGB[] argbs = new ARGB[count];

        if (argbs is null) {
            return SetStatus(Status.OutOfMemory);
        }

        GpStatus status = SetStatus(GdipGetPathGradientPresetBlend(
                                cast(GpPathGradient*)nativeBrush,
                                argbs.ptr,
                                blendPositions,
                                count));

        for(INT i = 0; i < count; i++) {
            presetColors[i] = new Color(argbs[i]);
        }

        return status;
    }

    Status SetBlendBellShape(in REAL focus, in REAL scale = 1.0) {
        return SetStatus(GdipSetPathGradientSigmaBlend(
                            cast(GpPathGradient*)nativeBrush, focus, scale));
    }

    Status SetBlendTriangularShape(in REAL focus, in REAL scale = 1.0) {
        return SetStatus(GdipSetPathGradientLinearBlend(
                            cast(GpPathGradient*)nativeBrush, focus, scale));
    }

    Status GetTransform(Matrix matrix) {
        return SetStatus(GdipGetPathGradientTransform(
                            cast(GpPathGradient*) nativeBrush,
                            matrix.nativeMatrix));
    }

    Status SetTransform(in Matrix matrix) {
        return SetStatus(GdipSetPathGradientTransform(
                            cast(GpPathGradient*) nativeBrush,
                            matrix.nativeMatrix));
    }

    Status ResetTransform() {
        return SetStatus(GdipResetPathGradientTransform(
                            cast(GpPathGradient*)nativeBrush));
    }

    Status MultiplyTransform(in Matrix matrix, in MatrixOrder order = MatrixOrder.MatrixOrderPrepend) {
        return SetStatus(GdipMultiplyPathGradientTransform(
                            cast(GpPathGradient*)nativeBrush,
                            matrix.nativeMatrix,
                            order));
    }

    Status TranslateTransform(in REAL dx, in REAL dy, in MatrixOrder order = MatrixOrder.MatrixOrderPrepend) {
        return SetStatus(GdipTranslatePathGradientTransform(
                            cast(GpPathGradient*)nativeBrush,
                            dx, dy, order));
    }

    Status ScaleTransform(in REAL sx, in REAL sy, in MatrixOrder order = MatrixOrder.MatrixOrderPrepend) {
        return SetStatus(GdipScalePathGradientTransform(
                            cast(GpPathGradient*)nativeBrush,
                            sx, sy, order));
    }

    Status RotateTransform(in REAL angle, in MatrixOrder order = MatrixOrder.MatrixOrderPrepend) {
        return SetStatus(GdipRotatePathGradientTransform(
                            cast(GpPathGradient*)nativeBrush,
                            angle, order));
    }

    Status GetFocusScales(REAL* xScale, REAL* yScale) {
        return SetStatus(GdipGetPathGradientFocusScales(
                            cast(GpPathGradient*) nativeBrush, xScale, yScale));
    }

    Status SetFocusScales(in REAL xScale, in REAL yScale) {
        return SetStatus(GdipSetPathGradientFocusScales(
                            cast(GpPathGradient*) nativeBrush, xScale, yScale));
    }

    WrapMode GetWrapMode() {
        WrapMode wrapMode;

        SetStatus(GdipGetPathGradientWrapMode(
                     cast(GpPathGradient*) nativeBrush, &wrapMode));

        return wrapMode;
    }

    Status SetWrapMode(in WrapMode wrapMode) {
        return SetStatus(GdipSetPathGradientWrapMode(
                            cast(GpPathGradient*) nativeBrush, wrapMode));
    }

protected:

    package this() {
    }
}