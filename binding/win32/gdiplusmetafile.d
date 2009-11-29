/*
 * gdiplusmetafile.d
 *
 * This module implements GdiPlusMetaFile.h for D. The original
 * copyright info is given below.
 *
 * Author: Dave Wilkinson
 * Originated: November 25th, 2009
 *
 */

module binding.win32.gdiplusmetafile;

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

/**************************************************************************\
*
* Copyright (c) 1998-2001, Microsoft Corp.  All Rights Reserved.
*
* Module Name:
*
*   GdiplusMetafile.h
*
* Abstract:
*
*   GDI+ Metafile class
*
\**************************************************************************/


class Metafile : Image {
    // Playback a metafile from a HMETAFILE
    // If deleteWmf is TRUE, then when the metafile is deleted,
    // the hWmf will also be deleted.  Otherwise, it won't be.
    
    this(
        in HMETAFILE                      hWmf,
        in WmfPlaceableFileHeader * wmfPlaceableFileHeader,
        in BOOL                           deleteWmf = FALSE) {

        GpMetafile *    metafile = null;
    
        lastResult = GdipCreateMetafileFromWmf(hWmf, deleteWmf, 
                                                           wmfPlaceableFileHeader, 
                                                           &metafile);
    
        SetNativeImage(metafile);            
    }

    // Playback a metafile from a HENHMETAFILE
    // If deleteEmf is TRUE, then when the metafile is deleted,
    // the hEmf will also be deleted.  Otherwise, it won't be.
    
    this(in HENHMETAFILE hEmf, in BOOL deleteEmf = FALSE) {
        GpMetafile *    metafile = null;
    
        lastResult = GdipCreateMetafileFromEmf(hEmf, deleteEmf, 
                                                           &metafile);
    
        SetNativeImage(metafile);        
    }
    
    this(in WCHAR* filename) {  
        GpMetafile *    metafile = null;
    
        lastResult = GdipCreateMetafileFromFile(filename, 
                                                            &metafile);
    
        SetNativeImage(metafile);      
    }

    // Playback a WMF metafile from a file.

    this(in WCHAR* filename, in WmfPlaceableFileHeader* wmfPlaceableFileHeader) {   
        GpMetafile *    metafile = null;
        
        lastResult = GdipCreateMetafileFromWmfFile(filename, 
                                                               wmfPlaceableFileHeader, 
                                                               &metafile);
        
        SetNativeImage(metafile);     
    }

    //this(in IStream* stream) {
 //       GpMetafile *    metafile = null;
  //  
   //     lastResult = GdipCreateMetafileFromStream(stream, 
       //                                                       &metafile);
    //
     //   SetNativeImage(metafile);
    //    
    //}

    // Record a metafile to memory.

    this(in HDC referenceHdc, in EmfType type = EmfType.EmfTypeEmfPlusDual, in WCHAR* description = null) {  
        GpMetafile *    metafile = null;
    
        lastResult = GdipRecordMetafile(
                        referenceHdc, type, null, MetafileFrameUnit.MetafileFrameUnitGdi,
                        description, &metafile);
    
        SetNativeImage(metafile);      
    } 
    
    // Record a metafile to memory.

    this(in HDC referenceHdc, in RectF frameRect, in MetafileFrameUnit frameUnit = MetafileFrameUnit.MetafileFrameUnitGdi,
            in EmfType type = EmfType.EmfTypeEmfPlusDual, in WCHAR* description = null) {
        GpMetafile *    metafile = null;
    
        lastResult = GdipRecordMetafile(
                        referenceHdc, type, &frameRect, frameUnit,
                        description, &metafile);
    
        SetNativeImage(metafile);         
    }

    // Record a metafile to memory.

    this(
        in HDC                 referenceHdc,
        in Rect         frameRect,
        in MetafileFrameUnit   frameUnit   = MetafileFrameUnit.MetafileFrameUnitGdi,
        in EmfType             type        = EmfType.EmfTypeEmfPlusDual,
        in WCHAR *       description = null
        ) {      
        GpMetafile *    metafile = null;
    
        lastResult = GdipRecordMetafileI(
                        referenceHdc, type, &frameRect, frameUnit,
                        description, &metafile);
    
        SetNativeImage(metafile);      
    }

    this(
        in WCHAR*        fileName,
        in HDC                 referenceHdc,
        in EmfType             type        = EmfType.EmfTypeEmfPlusDual,
        in WCHAR *       description = null
        ) {  
        GpMetafile *    metafile = null;
    
        lastResult = GdipRecordMetafileFileName(fileName,
                        referenceHdc, type, null, MetafileFrameUnit.MetafileFrameUnitGdi,
                        description, &metafile);
    
        SetNativeImage(metafile);          
    }

    this(
        in WCHAR*        fileName,
        in HDC                 referenceHdc,
        in RectF       frameRect,
        in MetafileFrameUnit   frameUnit   = MetafileFrameUnit.MetafileFrameUnitGdi,
        in EmfType             type        = EmfType.EmfTypeEmfPlusDual,
        in WCHAR *       description = null
        ) {    
        GpMetafile *    metafile = null;
    
        lastResult = GdipRecordMetafileFileName(fileName,
                        referenceHdc, type, &frameRect, frameUnit,
                        description, &metafile);
    
        SetNativeImage(metafile);        
    }

    this(
        in WCHAR*        fileName,
        in HDC                 referenceHdc,
        in Rect         frameRect,
        in MetafileFrameUnit   frameUnit   = MetafileFrameUnit.MetafileFrameUnitGdi,
        in EmfType             type        = EmfType.EmfTypeEmfPlusDual,
        in WCHAR *       description = null
        ) {
        GpMetafile *    metafile = null;
    
        lastResult = GdipRecordMetafileFileNameI(fileName,
                        referenceHdc, type, &frameRect, frameUnit,
                        description, &metafile);
    
        SetNativeImage(metafile);
    }
    
    /*
    this(
        in IStream *           stream,
        in HDC                 referenceHdc,
        in EmfType             type        = EmfType.EmfTypeEmfPlusDual,
        in WCHAR *       description = null
        ) {  
        GpMetafile *    metafile = null;
    
        lastResult = GdipRecordMetafileStream(stream,
                        referenceHdc, type, null, MetafileFrameUnitGdi,
                        description, &metafile);
    
        SetNativeImage(metafile);          
    }

    this(
        in IStream *           stream,
        in HDC                 referenceHdc,
        in RectF        frameRect,
        in MetafileFrameUnit   frameUnit   = MetafileFrameUnit.MetafileFrameUnitGdi,
        in EmfType             type        = EmfType.EmfTypeEmfPlusDual,
        in WCHAR *       description = null
        ) {   
        GpMetafile *    metafile = null;
    
        lastResult = GdipRecordMetafileStream(stream,
                        referenceHdc, type, &frameRect, frameUnit,
                        description, &metafile);
    
        SetNativeImage(metafile);         
    }

    this(
        in IStream *           stream,
        in HDC                 referenceHdc,
        in Rect         frameRect,
        in MetafileFrameUnit   frameUnit   = MetafileFrameUnit.MetafileFrameUnitGdi,
        in EmfType             type        = EmfType.EmfTypeEmfPlusDual,
        in WCHAR *       description = null
        ) {       
        GpMetafile *    metafile = null;
    
        lastResult = GdipRecordMetafileStreamI(stream,
                        referenceHdc, type, &frameRect, frameUnit,
                        description, &metafile);
    
        SetNativeImage(metafile);     
    }*/

    static Status GetMetafileHeader(in HMETAFILE hWmf, in WmfPlaceableFileHeader* wmfPlaceableFileHeader, MetafileHeader* header) {
        return GdipGetMetafileHeaderFromWmf(hWmf, wmfPlaceableFileHeader, header);
    }

    static Status GetMetafileHeader(in HENHMETAFILE hEmf, MetafileHeader* header) {
        return GdipGetMetafileHeaderFromEmf(hEmf, header);
    }

    static Status GetMetafileHeader(in WCHAR* filename, MetafileHeader* header) {  
        return GdipGetMetafileHeaderFromFile(filename, header);          
    }
    
/*
    static Status GetMetafileHeader(
        in IStream *           stream,
        MetafileHeader *   header
        ) {            
        return GdipGetMetafileHeaderFromStream(stream, header);
    }
*/

    Status GetMetafileHeader(MetafileHeader* header) { 
        return SetStatus(GdipGetMetafileHeaderFromMetafile(
                                              cast(GpMetafile *)nativeImage,
                                              header));       
    }

    // Once this method is called, the Metafile object is in an invalid state
    // and can no longer be used.  It is the responsiblity of the caller to
    // invoke DeleteEnhMetaFile to delete this hEmf.

    HENHMETAFILE GetHENHMETAFILE() {
        HENHMETAFILE hEmf;
    
        SetStatus(GdipGetHemfFromMetafile(
                                  cast(GpMetafile *)nativeImage, 
                                  &hEmf));
    
        return hEmf;        
    }

    // Used in conjuction with Graphics::EnumerateMetafile to play an EMF+
    // The data must be DWORD aligned if it's an EMF or EMF+.  It must be
    // WORD aligned if it's a WMF.
    
    Status PlayRecord(in EmfPlusRecordType recordType, in UINT flags, in UINT dataSize, in BYTE* data) {
        return SetStatus(GdipPlayMetafileRecord(
                                cast(GpMetafile *)nativeImage,
                                recordType,
                                flags,
                                dataSize,
                                data));          
    }

    // If you're using a printer HDC for the metafile, but you want the
    // metafile rasterized at screen resolution, then use this API to set
    // the rasterization dpi of the metafile to the screen resolution,
    // e.g. 96 dpi or 120 dpi.
    
    Status SetDownLevelRasterizationLimit(in UINT metafileRasterizationLimitDpi) {
        return SetStatus(
                         GdipSetMetafileDownLevelRasterizationLimit(
                                cast(GpMetafile *)nativeImage,
                                metafileRasterizationLimitDpi));
    }

    UINT GetDownLevelRasterizationLimit() {    
        UINT metafileRasterizationLimitDpi = 0;
    
        SetStatus(GdipGetMetafileDownLevelRasterizationLimit(
                                cast(GpMetafile *)nativeImage,
                                &metafileRasterizationLimitDpi));
    
        return metafileRasterizationLimitDpi;    
    }

    static UINT EmfToWmfBits(in HENHMETAFILE hemf, in UINT cbData16, LPBYTE pData16, in INT iMapMode = MM_ANISOTROPIC, in INT eFlags = EmfToWmfBitsFlags.EmfToWmfBitsFlagsDefault) {
        return GdipEmfToWmfBits(
            hemf,
            cbData16,
            pData16,
            iMapMode,
            eFlags);
    }

version(GDIPLUS6) {
    Status ConvertToEmfPlus(
        in Graphics* refGraphics,
        in INT* conversionFailureFlag = null,
        in EmfType emfType = EmfType.EmfTypeEmfPlusOnly,
        in WCHAR* description = null
    ) {
        GpMetafile * metafile = null;
        GpStatus status = GdipConvertToEmfPlus(
            cast(GpGraphics*)refGraphics.nativeGraphics,
            cast(GpMetafile *)nativeImage,
            conversionFailureFlag,
            emfType, description, &metafile);

        if (metafile !is null) {
            if (status == Status.Ok) {
                GdipDisposeImage(nativeImage);
                SetNativeImage(metafile);
            }
            else {
                GdipDisposeImage(metafile);
            }
        }
        return status;
    }

    Status ConvertToEmfPlus(
        in Graphics* refGraphics,
        in WCHAR* filename,
        in INT* conversionFailureFlag = null,
        in EmfType emfType = EmfType.EmfTypeEmfPlusOnly,
        in WCHAR* description = null
    ) {
        GpMetafile * metafile = null;
        GpStatus status = GdipConvertToEmfPlusToFile(
            cast(GpGraphics*)refGraphics.nativeGraphics,
            cast(GpMetafile *)nativeImage,
            conversionFailureFlag,
            filename, emfType, description, &metafile);

        if (metafile !is null) {
            if (status == Status.Ok) {
                GdipDisposeImage(nativeImage);
                SetNativeImage(metafile);
            }
            else {
                GdipDisposeImage(metafile);
            }
        }
        return status;
    }
}

/*    Status ConvertToEmfPlus(
        in Graphics* refGraphics,
        in IStream* stream,
        in INT* conversionFailureFlag = null,
        in EmfType emfType = EmfType.EmfTypeEmfPlusOnly,
        in WCHAR* description = null
    ) {
        GpMetafile * metafile = null;
        GpStatus status = GdipConvertToEmfPlusToStream(
            cast(GpGraphics*)refGraphics.nativeGraphics,
            cast(GpMetafile *)nativeImage,
            conversionFailureFlag,
            stream, emfType, description, &metafile);

        if (metafile != null) {
            if (status == Status.Ok) {
                GdipDisposeImage(nativeImage);
                SetNativeImage(metafile);
            }
            else {
                GdipDisposeImage(metafile);
            }
        }
        return status;
    }
*/

protected:
    this() {
        SetNativeImage(null);
        lastResult = Status.Ok;
    }
}
