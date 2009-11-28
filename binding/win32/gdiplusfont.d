/*
 * gdiplusfont.d
 *
 * This module implements GdiPlusFont.h for D. The original
 * copyright info is given below.
 *
 * Author: Dave Wilkinson
 * Originated: November 25th, 2009
 *
 */

module binding.win32.gdiplusfont;

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
import binding.win32.gdiplusfontfamily;
import binding.win32.gdiplusfontcollection;
import binding.win32.gdiplusgraphics;

/**************************************************************************\
*
* Copyright (c) 1998-2001, Microsoft Corp.  All Rights Reserved.
*
* Module Name:
*
*   GdiplusFont.h
*
* Abstract:
*
*   GDI+ Font class
*
\**************************************************************************/

//--------------------------------------------------------------------------
// Font
//--------------------------------------------------------------------------

class Font : GdiplusBase {

    this(in HDC hdc) {
        GpFont *font = null;
        lastResult = GdipCreateFontFromDC(hdc, &font);
    
        SetNativeFont(font);
    }
    
    this(in HDC hdc, in LOGFONTA* logfont) {
        GpFont *font = null;
    
        if (logfont) {
            lastResult = GdipCreateFontFromLogfontA(hdc, logfont, &font);
        }
        else {
            lastResult = GdipCreateFontFromDC(hdc, &font);
        }
    
        SetNativeFont(font);           
    }
         
    this(in HDC hdc, in LOGFONTW* logfont) {
        GpFont *font = null;
        if (logfont) {
            lastResult = GdipCreateFontFromLogfontW(hdc, logfont, &font);
        }
        else {
            lastResult = GdipCreateFontFromDC(hdc, &font);
        }
    
        SetNativeFont(font);
    }
         
    this(in HDC hdc, in HFONT hfont) {
        GpFont *font = null;
    
        if (hfont) {
            LOGFONTA lf;
    
            if(GetObjectA(hfont, LOGFONTA.sizeof, &lf))
                lastResult = GdipCreateFontFromLogfontA(hdc, &lf, &font);
            else
                lastResult = GdipCreateFontFromDC(hdc, &font);
        }
        else {
            lastResult = GdipCreateFontFromDC(hdc, &font);
        }
    
        SetNativeFont(font);      
    }
    
    this(in FontFamily family, in REAL emSize, in INT style = FontStyle.FontStyleRegular, in Unit unit = Unit.UnitPoint) {
        GpFont *font = null;
    
        lastResult = GdipCreateFont(family ? family.nativeFamily : null,
                        emSize,
                        style,
                        unit,
                        &font);
    
        SetNativeFont(font);        
    }

    this(in WCHAR* familyName, in REAL emSize, in INT style = FontStyle.FontStyleRegular, in Unit unit = Unit.UnitPoint, in FontCollection fontCollection = null) {
        nativeFont = null;
    
        FontFamily family = new FontFamily(familyName, fontCollection);
        GpFontFamily *nativeFamily = family.nativeFamily;
    
        lastResult = family.GetLastStatus();
    
        if (lastResult != Status.Ok) {
            nativeFamily = FontFamily.GenericSansSerif().nativeFamily;
            lastResult = FontFamily.GenericSansSerif().lastResult;
            if (lastResult != Status.Ok)
                return;
        }
    
        lastResult = GdipCreateFont(nativeFamily,
                                emSize,
                                style,
                                unit,
                                &nativeFont);
    
        if (lastResult != Status.Ok) {
            nativeFamily = FontFamily.GenericSansSerif().nativeFamily;
            lastResult = FontFamily.GenericSansSerif().lastResult;
            if (lastResult != Status.Ok)
                return;
    
            lastResult = GdipCreateFont(
                nativeFamily,
                emSize,
                style,
                unit,
                &nativeFont);
        }        
    }

    Status GetLogFontA(in Graphics g, LOGFONTA * logfontA) {
        return SetStatus(GdipGetLogFontA(nativeFont, g ? g.nativeGraphics : null, logfontA));
    }
    
    Status GetLogFontW(in Graphics g, LOGFONTW * logfontW) {
        return SetStatus(GdipGetLogFontW(nativeFont, g ? g.nativeGraphics : null, logfontW));
    }

    Font Clone() {
        GpFont *cloneFont = null;
    
        SetStatus(GdipCloneFont(nativeFont, &cloneFont));
    
        return new Font(cloneFont, lastResult);
    }
    
    alias Clone dup;
    
    ~this() {
        GdipDeleteFont(nativeFont);        
    }
    
    BOOL IsAvailable()   {
        return (nativeFont ? TRUE : FALSE);
    }
    
    INT GetStyle()      {
        INT style;
        SetStatus(GdipGetFontStyle(nativeFont, &style));
        return style;  
        
    }
    
    REAL GetSize()       {
        REAL size;
        SetStatus(GdipGetFontSize(nativeFont, &size));
        return size;        
    }
    
    Unit GetUnit()       {
        Unit unit;
        SetStatus(GdipGetFontUnit(nativeFont, &unit));
        return unit;
        
    }
    
    Status GetLastStatus() {
        return lastResult;      
    }
    
    REAL GetHeight(in Graphics graphics) {
        REAL height;
        SetStatus(GdipGetFontHeight(
            nativeFont,
            graphics ? graphics.nativeGraphics : null,
            &height
        ));
        return height;                
    }
    
    REAL GetHeight(in REAL dpi) {
        REAL height;
        SetStatus(GdipGetFontHeightGivenDPI(nativeFont, dpi, &height));
        return height;        
    }

    Status GetFamily(FontFamily family) {  
        if (family is null) {
            return SetStatus(Status.InvalidParameter);
        }
    
        Status status = GdipGetFamily(nativeFont, &(family.nativeFamily));
        family.SetStatus(status);
    
        return SetStatus(status);
    }

protected:
    this(GpFont* font, Status status) {
        lastResult = status;
        SetNativeFont(font);        
    }
    
    VOID SetNativeFont(GpFont *Font) {
        nativeFont = Font;        
    }
    
    Status SetStatus(Status status) {
        if (status != Status.Ok)
            return (lastResult = status);
        else
            return status;        
    }

    package GpFont* nativeFont;
    package Status lastResult;
}
