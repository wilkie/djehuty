/*
 * gdiplusregion.d
 *
 * This module implements GdiPlusRegion.h for D. The original
 * copyright info is given below.
 *
 * Author: Dave Wilkinson
 * Originated: November 25th, 2009
 *
 */

module binding.win32.gdiplusregion;

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
import binding.win32.gdiplusgraphics;

/**************************************************************************\
*
* Copyright (c) 1998-2001, Microsoft Corp.  All Rights Reserved.
*
* Module Name:
*
*   GdiplusRegion.h
*
* Abstract:
*
*   GDI+ Region class implementation
*
\**************************************************************************/

class Region : GdiplusBase {
public:
    this() {
      GpRegion *region = null;
  
      lastResult = GdipCreateRegion(&region);
  
      SetNativeRegion(region);
    }
    
    this(in RectF rect) {
      GpRegion *region = null;
  
      lastResult = GdipCreateRegionRect(&rect, &region);
  
      SetNativeRegion(region);
    }
    
    this(in Rect rect) {
      GpRegion *region = null;
  
      lastResult = GdipCreateRegionRectI(&rect, &region);
  
      SetNativeRegion(region);      
    }
    
    this(in GraphicsPath path) {
      GpRegion *region = null;
  
      lastResult = GdipCreateRegionPath(path.nativePath, &region);
  
      SetNativeRegion(region);      
    }
    
    this(in BYTE* regionData, in INT size) {
      GpRegion *region = null;
  
      lastResult = GdipCreateRegionRgnData(regionData, size, 
                                                       &region);
  
      SetNativeRegion(region);      
    }
    
    this(in HRGN hRgn) {
      GpRegion *region = null;
  
      lastResult = GdipCreateRegionHrgn(hRgn, &region);
  
      SetNativeRegion(region);      
    }
    
    static Region FromHRGN(in HRGN hRgn) {
      GpRegion *region = null;
  
      if (GdipCreateRegionHrgn(hRgn, &region) == Status.Ok) {
          Region newRegion = new Region(region);
  
          if (newRegion is null) {
              GdipDeleteRegion(region);
          }
  
          return newRegion;
      }
      else
          return null;      
    }

    ~this() {
      GdipDeleteRegion(nativeRegion);
    }
    
    Region Clone() {
      GpRegion *region = null;
  
      SetStatus(GdipCloneRegion(nativeRegion, &region));
  
      return new Region(region);
    }
    
    alias Clone dup;

    Status MakeInfinite() {
      return SetStatus(GdipSetInfinite(nativeRegion));      
    }
    
    Status MakeEmpty() {
      return SetStatus(GdipSetEmpty(nativeRegion));
    }

    UINT GetDataSize() {
      UINT     bufferSize = 0;
      
      SetStatus(GdipGetRegionDataSize(nativeRegion, &bufferSize));
      
      return bufferSize;      
    }

    // buffer     - where to put the data
    // bufferSize - how big the buffer is (should be at least as big as GetDataSize())
    // sizeFilled - if not null, this is an param that says how many bytes
    //              of data were written to the buffer.

    Status GetData(BYTE* buffer, in UINT bufferSize, UINT* sizeFilled = null) {
      return SetStatus(GdipGetRegionData(nativeRegion, buffer, bufferSize, sizeFilled));                     
    }

    Status Intersect(in Rect rect) {
      return SetStatus(GdipCombineRegionRectI(nativeRegion, &rect, CombineMode.CombineModeIntersect));
    }
    
    Status Intersect(in RectF rect) {
      return SetStatus(GdipCombineRegionRect(nativeRegion, &rect, CombineMode.CombineModeIntersect));      
    }
    
    Status Intersect(in GraphicsPath path) {
      return SetStatus(GdipCombineRegionPath(nativeRegion, path.nativePath, CombineMode.CombineModeIntersect));      
    }
    
    Status Intersect(in Region region) {
      return SetStatus(GdipCombineRegionRegion(nativeRegion, region.nativeRegion, CombineMode.CombineModeIntersect));
    }
    
    Status Union(in Rect rect) {
      return SetStatus(GdipCombineRegionRectI(nativeRegion, &rect, CombineMode.CombineModeUnion));            
    }
    
    Status Union(in RectF rect) {
      return SetStatus(GdipCombineRegionRect(nativeRegion, &rect, CombineMode.CombineModeUnion));      
    }
    
    Status Union(in GraphicsPath path) {
      return SetStatus(GdipCombineRegionPath(nativeRegion, path.nativePath, CombineMode.CombineModeUnion));      
    }
    
    Status Union(in Region region) {
      return SetStatus(GdipCombineRegionRegion(nativeRegion, region.nativeRegion, CombineMode.CombineModeUnion));      
    }
    
    Status Xor(in Rect rect) {    
      return SetStatus(GdipCombineRegionRectI(nativeRegion, &rect, CombineMode.CombineModeXor));  
    }
    
    Status Xor(in RectF rect) {
      return SetStatus(GdipCombineRegionRect(nativeRegion, &rect, CombineMode.CombineModeXor));        
    }
    
    Status Xor(in GraphicsPath path) {
      return SetStatus(GdipCombineRegionPath(nativeRegion, path.nativePath, CombineMode.CombineModeXor));      
    }
    
    Status Xor(in Region region) {
      return SetStatus(GdipCombineRegionRegion(nativeRegion, region.nativeRegion, CombineMode.CombineModeXor));      
    }
    
    Status Exclude(in Rect rect) {
      return SetStatus(GdipCombineRegionRectI(nativeRegion, &rect, CombineMode.CombineModeExclude));      
    }
    
    Status Exclude(in RectF rect) {
      return SetStatus(GdipCombineRegionRect(nativeRegion, &rect, CombineMode.CombineModeExclude));      
    }
    
    Status Exclude(in GraphicsPath path) {
      return SetStatus(GdipCombineRegionPath(nativeRegion, path.nativePath, CombineMode.CombineModeExclude));      
    }
    
    Status Exclude(in Region region) {
      return SetStatus(GdipCombineRegionRegion(nativeRegion, region.nativeRegion, CombineMode.CombineModeExclude));      
    }
    
    Status Complement(in Rect rect) {
      return SetStatus(GdipCombineRegionRectI(nativeRegion, &rect, CombineMode.CombineModeComplement));      
    }
    
    Status Complement(in RectF rect) {
      return SetStatus(GdipCombineRegionRect(nativeRegion, &rect, CombineMode.CombineModeComplement));      
      
    }
    
    Status Complement(in GraphicsPath path) {
      return SetStatus(GdipCombineRegionPath(nativeRegion, path.nativePath, CombineMode.CombineModeComplement));      
    }
    
    Status Complement(in Region region) {
      return SetStatus(GdipCombineRegionRegion(nativeRegion, region.nativeRegion, CombineMode.CombineModeComplement));      
    }
    
    Status Translate(in REAL dx,
                     in REAL dy) {
      return SetStatus(GdipTranslateRegion(nativeRegion, dx, dy)); 
    }
                     
    Status Translate(in INT dx,
                     in INT dy) {
      return SetStatus(GdipTranslateRegionI(nativeRegion, dx, dy));                       
    }
                     
    Status Transform(in Matrix matrix) {
      return SetStatus(GdipTransformRegion(nativeRegion, matrix.nativeMatrix));      
    }

    Status GetBounds(ref Rect rect, in Graphics g) {
      return SetStatus(GdipGetRegionBoundsI(nativeRegion, g.nativeGraphics, &rect));
    }

    Status GetBounds(ref RectF rect, in Graphics g) {
      return SetStatus(GdipGetRegionBounds(nativeRegion, g.nativeGraphics, &rect));                       
    }

    HRGN   GetHRGN  (in Graphics g) {
      HRGN hrgn;
  
      SetStatus(GdipGetRegionHRgn(nativeRegion, g.nativeGraphics, &hrgn));
  
      return hrgn;      
    }

    BOOL IsEmpty(in Graphics g) {
      BOOL booln = FALSE;
     
      SetStatus(GdipIsEmptyRegion(nativeRegion, g.nativeGraphics, &booln));
  
      return booln;      
    }
    
    BOOL IsInfinite(in Graphics g) {
      BOOL booln = FALSE;
  
      SetStatus(GdipIsInfiniteRegion(nativeRegion, g.nativeGraphics, &booln));
  
      return booln;      
    }

    BOOL IsVisible(in INT x,
                   in INT y,
                   in Graphics g = null) {
        return IsVisible(Point(x, y), g);
    }

    BOOL IsVisible(in Point point,
                   in Graphics g = null) {
      BOOL booln = FALSE;
  
  
      SetStatus(GdipIsVisibleRegionPointI(nativeRegion,
                                                     point.X,
                                                     point.Y,
                                                     (g is null) 
                                                      ? null : g.nativeGraphics,
                                                     &booln));
      return booln;                     
    }

    BOOL IsVisible(in REAL x,
                   in REAL y,
                   in Graphics g = null) {
        return IsVisible(PointF(x, y), g);
    }

    BOOL IsVisible(in PointF point,
                   in Graphics g = null) {
      BOOL booln = FALSE;
  
      SetStatus(GdipIsVisibleRegionPoint(nativeRegion, point.X, point.Y, 
                                       (g is null) ? null : g.nativeGraphics,
                                       &booln));
      return booln;                     
    }

    BOOL IsVisible(in INT x,
                   in INT y,
                   in INT width,
                   in INT height,
                   in Graphics g) {
        return IsVisible(Rect(x, y, width, height), g);
    }

    BOOL IsVisible(in Rect rect,
                   in Graphics g = null) {
      BOOL booln = FALSE;
  
      SetStatus(GdipIsVisibleRegionRectI(nativeRegion,
                                                    rect.X,
                                                    rect.Y,
                                                    rect.Width,
                                                    rect.Height,
                                                    (g is null) 
                                                      ? null : g.nativeGraphics,
                                                    &booln));
      return booln;                     
    }

    BOOL IsVisible(in REAL x,
                   in REAL y,
                   in REAL width,
                   in REAL height,
                   in Graphics g = null) {
        return IsVisible(RectF.init(x, y, width, height), g);
    }

    BOOL IsVisible(in RectF rect,
                   in Graphics g = null) {
      BOOL booln = FALSE;
  
      SetStatus(GdipIsVisibleRegionRect(nativeRegion, rect.X,
                                                      rect.Y, rect.Width,
                                                      rect.Height,
                                                      (g is null) ?
                                                        null : g.nativeGraphics,
                                                      &booln));
      return booln;                     
    }

    BOOL Equals(in Region region, in Graphics g) {
      BOOL booln = FALSE;
  
      SetStatus(GdipIsEqualRegion(nativeRegion, region.nativeRegion, g.nativeGraphics, &booln));
      
      return booln;                  
    }

    UINT GetRegionScansCount(in Matrix matrix) {
      UINT count = 0;
  
      SetStatus(GdipGetRegionScansCount(nativeRegion, &count, matrix.nativeMatrix));
      return count;      
    }
    
    Status GetRegionScans(in Matrix matrix,
                          RectF[] rects,
                          ref INT count) {
      return SetStatus(GdipGetRegionScans(nativeRegion, rects.ptr, &count, matrix.nativeMatrix));                              
    }
                          
    Status GetRegionScans(in Matrix matrix,
                          Rect[]  rects,
                          ref INT count) {
      return SetStatus(GdipGetRegionScansI(nativeRegion, rects.ptr, &count, matrix.nativeMatrix));                            
    }
                          
    Status GetLastStatus() {
      Status lastStatus = lastResult;
      lastResult = Status.Ok;
  
      return lastStatus;      
    }

protected:

    Status SetStatus(Status status) {
        if (status != Status.Ok)
            return (lastResult = status);
        else
            return status;
    }

    this(GpRegion* nativeRegion) {
      SetNativeRegion(nativeRegion);      
    }

    VOID SetNativeRegion(GpRegion* nativeRegion) {
      this.nativeRegion = nativeRegion;      
    }

protected:
    package GpRegion* nativeRegion;
    package Status lastResult;
}
