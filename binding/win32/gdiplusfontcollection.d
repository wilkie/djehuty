/*
 * gdiplusfontcollection.d
 *
 * This module implements GdiPlusFontCollection.h for D. The original
 * copyright info is given below.
 *
 * Author: Dave Wilkinson
 * Originated: November 25th, 2009
 *
 */

module binding.win32.gdiplusfontcollection;

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

/**************************************************************************\
*
* Copyright (c) 2000, Microsoft Corp.  All Rights Reserved.
*
* Module Name:
* 
*   GdiplusFontCollection.h
*
* Abstract:
*
*   Font collections (Installed and Private)
*
\**************************************************************************/

class FontCollection : GdiplusBase {

    this() {
    }
    
    ~this() {
    }

    INT GetFamilyCount() {
        INT numFound = 0;
    
        lastResult = GdipGetFontCollectionFamilyCount(
                                 nativeFontCollection, &numFound);
    
        return numFound;       
    }

    Status GetFamilies(in INT numSought, FontFamily[] gpfamilies, INT* numFound) {
        if (numSought <= 0 || gpfamilies is null || numFound is null) {
            return SetStatus(Status.InvalidParameter);
        }
        
        *numFound = 0;
        GpFontFamily*[] nativeFamilyList = new GpFontFamily*[numSought];
    
        if (nativeFamilyList is null) {
            return SetStatus(Status.OutOfMemory);
        }
    
        Status status = SetStatus(GdipGetFontCollectionFamilyList(
            nativeFontCollection,
            numSought,
            nativeFamilyList,
            numFound
        ));
        if (status == Status.Ok){
            for (INT i = 0; i < *numFound; i++) {
                GdipCloneFontFamily(nativeFamilyList[i],
                                                &gpfamilies[i].nativeFamily);
            }
        }
    
        return status;
    }

    Status GetLastStatus() {
        return lastResult;        
    }

protected:
    package Status SetStatus(Status status) {
        lastResult = status;
        return lastResult;        
    }

    package GpFontCollection *nativeFontCollection = null;
    package Status    lastResult;
}


class InstalledFontCollection : FontCollection {
    this() {
        nativeFontCollection = null;
        lastResult = GdipNewInstalledFontCollection(&nativeFontCollection);
    }
    
    ~this() {
    }
}

class PrivateFontCollection : FontCollection {
    this() {
        nativeFontCollection = null;
        lastResult = GdipNewPrivateFontCollection(&nativeFontCollection);
    }
    
    ~this() {
        GdipDeletePrivateFontCollection(&nativeFontCollection);        
    }

    Status AddFontFile(in WCHAR* filename) {
        return SetStatus(GdipPrivateAddFontFile(nativeFontCollection, filename));        
    }
    
    Status AddMemoryFont(in VOID* memory, in INT length) {
        return SetStatus(GdipPrivateAddMemoryFont(
            nativeFontCollection,
            memory,
            length));                             
    }
}
