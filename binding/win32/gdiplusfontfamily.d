/*
 * gdiplusfontfamily.d
 *
 * This module implements GdiPlusFontFamily.h for D. The original
 * copyright info is given below.
 *
 * Author: Dave Wilkinson
 * Originated: November 25th, 2009
 *
 */

module binding.win32.gdiplusfontfamily;

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
import binding.win32.gdiplusfontcollection;

/**************************************************************************\
*
* Copyright (c) 1998-2001, Microsoft Corp.  All Rights Reserved.
*
* Module Name:
*
*   GdiplusFontFamily.h
*
* Abstract:
*
*   GDI+ Font Family class
*
\**************************************************************************/

//--------------------------------------------------------------------------
// FontFamily
//--------------------------------------------------------------------------

class FontFamily : GdiplusBase {

    this() {
    }

    this(in WCHAR* name, in FontCollection fontCollection = null) {
        nativeFamily = null;
        lastResult = GdipCreateFontFamilyFromName(
            name,
            fontCollection ? fontCollection.nativeFontCollection : null,
            &nativeFamily
        );        
    }

    ~this() {
        GdipDeleteFontFamily (nativeFamily);
    }

    static FontFamily GenericSansSerif() {
        static FontFamily GenericSansSerifFontFamily;
        
        if (GenericSansSerifFontFamily !is null) {
            return GenericSansSerifFontFamily;
        }
    
        GenericSansSerifFontFamily = new FontFamily();
    
        GenericSansSerifFontFamily.lastResult =
            GdipGetGenericFontFamilySansSerif(
                &(GenericSansSerifFontFamily.nativeFamily)
            );
    
        return GenericSansSerifFontFamily; 
    }
    
    static FontFamily GenericSerif() {   
        static FontFamily GenericSerifFontFamily;
        
        if (GenericSerifFontFamily !is null) {
            return GenericSerifFontFamily;
        }
    
        GenericSerifFontFamily = new FontFamily();
    
        GenericSerifFontFamily.lastResult =
            GdipGetGenericFontFamilySerif(
                &(GenericSerifFontFamily.nativeFamily)
            );
    
        return GenericSerifFontFamily;     
    }
    
    static FontFamily GenericMonospace() { 
        static FontFamily GenericMonospaceFontFamily; 
        
        if (GenericMonospaceFontFamily !is null) {
            return GenericMonospaceFontFamily;
        }
    
        GenericMonospaceFontFamily = new FontFamily();
    
        GenericMonospaceFontFamily.lastResult =
            GdipGetGenericFontFamilyMonospace(
                &(GenericMonospaceFontFamily.nativeFamily)
            );
    
        return GenericMonospaceFontFamily;      
    }

    Status GetFamilyName(LPWSTR name, in LANGID language = 0) { 
        return SetStatus(GdipGetFamilyName(nativeFamily, 
                                                       name, 
                                                       language));           
    }

    FontFamily Clone() { 
        GpFontFamily * clonedFamily = null;
    
        SetStatus(GdipCloneFontFamily (nativeFamily, &clonedFamily));
    
        return new FontFamily(clonedFamily, lastResult);       
    }
    
    alias Clone dup;

    BOOL    IsAvailable() {
        return (nativeFamily !is null);
    }

    BOOL    IsStyleAvailable(in INT style) {
        BOOL    StyleAvailable;
        Status  status;
    
        status = SetStatus(GdipIsStyleAvailable(nativeFamily, style, &StyleAvailable));
    
        if (status != Status.Ok)
            StyleAvailable = FALSE;
    
        return StyleAvailable;        
    }

    UINT16  GetEmHeight     (in INT style) {
        UINT16  EmHeight;
    
        SetStatus(GdipGetEmHeight(nativeFamily, style, &EmHeight));
    
        return EmHeight;
        
    }
    
    UINT16  GetCellAscent   (in INT style) {
        UINT16  CellAscent;
    
        SetStatus(GdipGetCellAscent(nativeFamily, style, &CellAscent));
    
        return CellAscent;
        
    }
    
    UINT16  GetCellDescent  (in INT style) {
        UINT16  CellDescent;
    
        SetStatus(GdipGetCellDescent(nativeFamily, style, &CellDescent));
    
        return CellDescent;
        
    }
    
    UINT16  GetLineSpacing  (in INT style) {
        UINT16  LineSpacing;
    
        SetStatus(GdipGetLineSpacing(nativeFamily, style, &LineSpacing));
    
        return LineSpacing;
        
    }
    
    Status GetLastStatus() {
        Status lastStatus = lastResult;
        lastResult = Status.Ok;
    
        return lastStatus;        
    }

protected:
    package Status SetStatus(Status status) {
        if (status != Status.Ok) {
            return (lastResult = status);
        }
        else {
            return status;
        }        
    }

    package this(GpFontFamily * nativeOrig, Status status) {
        lastResult    = status;
        nativeFamily = nativeOrig;        
    }

    package GpFontFamily    *nativeFamily = null;
    package Status   lastResult = Status.Ok;
}
