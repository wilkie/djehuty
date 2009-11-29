/*
 * gdiplusbitmap.d
 *
 * This module implements GdiPlusBitmap.h for D. The original
 * copyright info is given below.
 *
 * Author: Dave Wilkinson
 * Originated: November 25th, 2009
 *
 */

module binding.win32.gdiplusbitmap;

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
import binding.win32.gdiplusgraphics;

class Image : GdiplusBase {

    this(in WCHAR* filename, in BOOL useEmbeddedColorManagement = FALSE) {
	    nativeImage = null;
	    if(useEmbeddedColorManagement)
	    {
	        lastResult = GdipLoadImageFromFileICM(
	            filename, 
	            &nativeImage
	        );
	    }
	    else
	    {      
	        lastResult = GdipLoadImageFromFile(
	            filename, 
	            &nativeImage
	        );
	    }
    }

    //this(in IStream* stream, in BOOL useEmbeddedColorManagement = FALSE) {
    //}

    static Image FromFile(in WCHAR* filename, in BOOL useEmbeddedColorManagement = FALSE) {
	    return new Image(
	        filename, 
	        useEmbeddedColorManagement
	    );
    }

//    static Image* FromStream(
//        in IStream* stream,
//        in BOOL useEmbeddedColorManagement = FALSE
//    );

	~this() {
    	GdipDisposeImage(nativeImage);
	}

    Image Clone() {
	    GpImage *cloneimage = null;

	    SetStatus(GdipCloneImage(nativeImage, &cloneimage));

	    return new Image(cloneimage, lastResult);
    }

    Status Save(in WCHAR* filename,
                in CLSID* clsidEncoder,
                in EncoderParameters *encoderParams = null) {
	    return SetStatus(GdipSaveImageToFile(nativeImage,
	                                                     filename,
	                                                     clsidEncoder,
	                                                     encoderParams));
    }
//    Status Save(in IStream* stream,
  //              in CLSID* clsidEncoder,
    //            in EncoderParameters *encoderParams = null);
    Status SaveAdd(in EncoderParameters* encoderParams) {
	    return SetStatus(GdipSaveAdd(nativeImage,
	                                             encoderParams));
    }

    Status SaveAdd(in Image* newImage,
                   in EncoderParameters* encoderParams) {
	    if ( newImage is null ) {
	        return SetStatus(Status.InvalidParameter);
	    }
	
	    return SetStatus(GdipSaveAddImage(nativeImage,
	                                                  newImage.nativeImage,
	                                                  encoderParams));
    }

    ImageType GetType() {
	    ImageType type = ImageType.ImageTypeUnknown;
	
	    SetStatus(GdipGetImageType(nativeImage, &type));
	
	    return type;
    }

    Status GetPhysicalDimension(SizeF* size) {
	    if (size is null) {
	        return SetStatus(Status.InvalidParameter);
	    }
	    
	    REAL width, height;
	    Status status;
	
	    status = SetStatus(GdipGetImageDimension(nativeImage,
	                                                         &width, &height));
	
	    size.Width  = width;
	    size.Height = height;
	
	    return status;
    }

    Status GetBounds(RectF* srcRect,
                     Unit* srcUnit) {
	    return SetStatus(GdipGetImageBounds(nativeImage,
	                    srcRect, srcUnit));
    }

    UINT GetWidth() {
	    UINT width = 0;
	
	    SetStatus(GdipGetImageWidth(nativeImage, &width));
	
	    return width;
    }

    UINT GetHeight() {
	    UINT height = 0;
	
	    SetStatus(GdipGetImageHeight(nativeImage, &height));
	
	    return height;
    }

    REAL GetHorizontalResolution() {
	    REAL resolution = 0.0f;
	
	    SetStatus(GdipGetImageHorizontalResolution(nativeImage, &resolution));

	    return resolution;
    }

    REAL GetVerticalResolution() {
	    REAL resolution = 0.0f;

	    SetStatus(GdipGetImageVerticalResolution(nativeImage, &resolution));
	
	    return resolution;
    }

    UINT GetFlags() {
	    UINT flags = 0;
	
	    SetStatus(GdipGetImageFlags(nativeImage, &flags));
	
	    return flags;
    }

    Status GetRawFormat(GUID *format) {
   		return SetStatus(GdipGetImageRawFormat(nativeImage, format));
    }

    PixelFormat GetPixelFormat() {
	    PixelFormat format;
	
	    SetStatus(GdipGetImagePixelFormat(nativeImage, &format));
	
	    return format;
    }

    INT GetPaletteSize() {
	    INT size = 0;
	    
	    SetStatus(GdipGetImagePaletteSize(nativeImage, &size));
	    
	    return size;
    }

    Status GetPalette(ColorPalette* palette,
                      in INT size) {
	    return SetStatus(GdipGetImagePalette(nativeImage, palette, size));
    }

    Status SetPalette(in ColorPalette* palette) {
	    return SetStatus(GdipSetImagePalette(nativeImage, palette));
    }

    Image GetThumbnailImage(in UINT thumbWidth,
                             in UINT thumbHeight,
                             in GetThumbnailImageAbort callback = null,
                             in VOID* callbackData = null) {
	    GpImage *thumbimage = null;

	    SetStatus(GdipGetImageThumbnail(nativeImage,
	                                                thumbWidth, thumbHeight,
	                                                &thumbimage,
	                                                callback, callbackData));

	    Image newImage = new Image(thumbimage, lastResult);

	    if (newImage is null) {
	        GdipDisposeImage(thumbimage);
	    }

	    return newImage;
    }

    UINT GetFrameDimensionsCount() {
	    UINT count = 0;
	
	    SetStatus(GdipImageGetFrameDimensionsCount(nativeImage,
	                                                                  &count));
	
	    return count;
    }

    Status GetFrameDimensionsList(GUID* dimensionIDs,
                                  in UINT count) {
	    return SetStatus(GdipImageGetFrameDimensionsList(nativeImage,
	                                                                 dimensionIDs,
                                                                 count));
    }

    UINT GetFrameCount(in GUID* dimensionID) {
	    UINT count = 0;
	
	    SetStatus(GdipImageGetFrameCount(nativeImage,
	                                                        dimensionID,
	                                                        &count));
	    return count;
    }

    Status SelectActiveFrame(in GUID* dimensionID,
                             in UINT frameIndex) {
	    return SetStatus(GdipImageSelectActiveFrame(nativeImage,
	                                                            dimensionID,
	                                                            frameIndex));
    }

    Status RotateFlip(in RotateFlipType rotateFlipType) {
	    return SetStatus(GdipImageRotateFlip(nativeImage,
	                                                     rotateFlipType));
    }

    UINT GetPropertyCount() {
	    UINT numProperty = 0;
	
	    SetStatus(GdipGetPropertyCount(nativeImage,
	                                               &numProperty));
	
	    return numProperty;
    }

    Status GetPropertyIdList(in UINT numOfProperty,
                             PROPID* list) {
	    return SetStatus(GdipGetPropertyIdList(nativeImage,
	                                                       numOfProperty, list));
    }

    UINT GetPropertyItemSize(in PROPID propId) {
	    UINT size = 0;
	
	    SetStatus(GdipGetPropertyItemSize(nativeImage,
	                                                  propId,
	                                                  &size));
	
	    return size;
    }

    Status GetPropertyItem(in PROPID propId,
                           in UINT propSize,
                           PropertyItem* buffer) {
	    return SetStatus(GdipGetPropertyItem(nativeImage,
	                                                     propId, propSize, buffer));
	}

    Status GetPropertySize(UINT* totalBufferSize,
                           UINT* numProperties) {
	    return SetStatus(GdipGetPropertySize(nativeImage,
	                                                     totalBufferSize,
	                                                     numProperties));
    }

    Status GetAllPropertyItems(in UINT totalBufferSize,
                               in UINT numProperties,
                               PropertyItem* allItems) {
	    if (allItems == null) {
	        return SetStatus(Status.InvalidParameter);
	    }
	    return SetStatus(GdipGetAllPropertyItems(nativeImage,
	                                                         totalBufferSize,
	                                                         numProperties,
	                                                         allItems));
    }

    Status RemovePropertyItem(in PROPID propId) {
	    return SetStatus(GdipRemovePropertyItem(nativeImage, propId));
    }

    Status SetPropertyItem(in PropertyItem* item) {
	    return SetStatus(GdipSetPropertyItem(nativeImage, item));
    }

    UINT  GetEncoderParameterListSize(in CLSID* clsidEncoder) {
	    UINT size = 0;

	    SetStatus(GdipGetEncoderParameterListSize(nativeImage,
	                                                          clsidEncoder,
	                                                          &size));
	    return size;
    }

    Status GetEncoderParameterList(in CLSID* clsidEncoder,
                                   in UINT size,
                                   EncoderParameters* buffer) {
	    return SetStatus(GdipGetEncoderParameterList(nativeImage,
	                                                             clsidEncoder,
	                                                             size,
	                                                             buffer));
    }

version(GDIPLUS6) {
    Status FindFirstItem(in ImageItemData *item) {
	    return SetStatus(GdipFindFirstImageItem(nativeImage, item));
    }

    Status FindNextItem(in ImageItemData *item) {
	    return SetStatus(GdipFindNextImageItem(nativeImage, item));
    }

    Status GetItemData(in ImageItemData *item) {
	    return SetStatus(GdipGetImageItemData(nativeImage, item));
    }

    Status SetAbort(GdiplusAbort *pIAbort) {
	    return SetStatus(GdipImageSetAbort(
	        nativeImage,
	        pIAbort
	        ));
    }
}

    Status GetLastStatus() {
	    Status lastStatus = lastResult;
	    lastResult = Status.Ok;

	    return lastStatus;
    }

protected:

    this() {}

    package this(GpImage *nativeImage, Status status) {
	    SetNativeImage(nativeImage);
	    lastResult = status;
    }

    VOID SetNativeImage(GpImage* nativeImage) {
	    this.nativeImage = nativeImage;
    }

    Status SetStatus(Status status) {
        if (status != Status.Ok)
            return (lastResult = status);
        else
            return status;
    }

    package GpImage* nativeImage;
    package Status lastResult;
    package Status loadStatus;
}



class Bitmap : Image {

    this(in WCHAR* filename, in BOOL useEmbeddedColorManagement = FALSE) {
	    GpBitmap *bitmap = null;
	
	    if(useEmbeddedColorManagement) {
	        lastResult = GdipCreateBitmapFromFileICM(filename, &bitmap);
	    }
	    else {
	        lastResult = GdipCreateBitmapFromFile(filename, &bitmap);
	    }
	
	    SetNativeImage(bitmap);    	
    }

	/*
    this(in IStream *stream, in BOOL useEmbeddedColorManagement = FALSE) {
	    GpBitmap *bitmap = null;
	
	    if(useEmbeddedColorManagement) {
	        lastResult = GdipCreateBitmapFromStreamICM(stream, &bitmap);
	    }
	    else {
	        lastResult = GdipCreateBitmapFromStream(stream, &bitmap);
	    }
	
	    SetNativeImage(bitmap);    	
    }
    */

    static Bitmap FromFile(in WCHAR* filename, in BOOL useEmbeddedColorManagement = FALSE) {
	    return new Bitmap(
	        filename,
	        useEmbeddedColorManagement
	    );
    }

	/*
    static Bitmap FromStream(in IStream *stream, in BOOL useEmbeddedColorManagement = FALSE) {    	
	    return new Bitmap(
	        stream,
	        useEmbeddedColorManagement
	    );
    }
    */

    this(in INT width, in INT height, in INT stride, PixelFormat format, in BYTE* scan0) {   
	    GpBitmap *bitmap = null;
	
	    lastResult = GdipCreateBitmapFromScan0(width,
	                                                       height,
	                                                       stride,
	                                                       format,
	                                                       scan0,
	                                                       &bitmap);
	
	    SetNativeImage(bitmap);        	
    }
    
    this(in INT width, in INT height, in PixelFormat format = PixelFormat32bppARGB) {
	    GpBitmap *bitmap = null;
	
	    lastResult = GdipCreateBitmapFromScan0(width,
	                                                       height,
	                                                       0,
	                                                       format,
	                                                       null,
	                                                       &bitmap);
	
	    SetNativeImage(bitmap);
    }
    
    this(in INT width, in INT height, in Graphics target) { 
	    GpBitmap *bitmap = null;
	
	    lastResult = GdipCreateBitmapFromGraphics(width,
	                                                          height,
	                                                          target.nativeGraphics,
	                                                          &bitmap);
	
	    SetNativeImage(bitmap);   	
    }

    Bitmap Clone(in Rect rect, in PixelFormat format) {
    	return Clone(rect.X, rect.Y, rect.Width, rect.Height, format);    	
    }
    
    Bitmap Clone(in INT x, in INT y, in INT width, in INT height, in PixelFormat format) {
	   GpBitmap* gpdstBitmap = null;
	   Bitmap bitmap;
	
	   lastResult = GdipCloneBitmapAreaI(
	                               x,
	                               y,
	                               width,
	                               height,
	                               format,
	                               cast(GpBitmap *)nativeImage,
	                               &gpdstBitmap);
	
	   if (lastResult == Status.Ok) {
	       bitmap = new Bitmap(gpdstBitmap);
	
	       if (bitmap is null) {
	           GdipDisposeImage(gpdstBitmap);
	       }
	
	       return bitmap;
	   }
	   else
	       return null;
    	
    }
    
    Bitmap Clone(in RectF rect, in PixelFormat format) {
    	return Clone(rect.X, rect.Y, rect.Width, rect.Height, format);    	    	
    }
    
    Bitmap Clone(in REAL x, in REAL y, in REAL width, in REAL height, in PixelFormat format) {
	   GpBitmap* gpdstBitmap = null;
	   Bitmap bitmap;
	
	   SetStatus(GdipCloneBitmapArea(
	                               x,
	                               y,
	                               width,
	                               height,
	                               format,
	                               cast(GpBitmap *)nativeImage,
	                               &gpdstBitmap));
	
	   if (lastResult == Status.Ok) {
	       bitmap = new Bitmap(gpdstBitmap);
	
	       if (bitmap is null) {
	       		GdipDisposeImage(gpdstBitmap);
	       }
	
	       return bitmap;
	   }
	   else
	       return null;
    	
    }

    Status LockBits(in Rect* rect, in UINT flags, in PixelFormat format, BitmapData* lockedBitmapData) {
	    return SetStatus(GdipBitmapLockBits(
	                                    cast(GpBitmap*)(nativeImage),
	                                    rect,
	                                    flags,
	                                    format,
	                                    lockedBitmapData));    	
    }
    
    Status UnlockBits(in BitmapData* lockedBitmapData) {
	    return SetStatus(GdipBitmapUnlockBits(
	                                    cast(GpBitmap*)(nativeImage),
	                                    lockedBitmapData));    	
    }
    
    Status GetPixel(in INT x, in INT y, Color *color) {
	    ARGB argb;
	
	    Status status = SetStatus(GdipBitmapGetPixel(
	        cast(GpBitmap *)(nativeImage),
	        x, y,        
	        &argb));
	
	    if (status == Status.Ok) {
	        color.SetValue(argb);
	    }
	
	    return  status;    	
    }
    
    Status SetPixel(in INT x, in INT y, in Color color) {
	    return SetStatus(GdipBitmapSetPixel(
	        cast(GpBitmap *)(nativeImage),
	        x, y,
	        color.GetValue()));    	
    }
    /*
    Status ConvertFormat(PixelFormat format, DitherType dithertype, PaletteType palettetype, ColorPalette *palette, REAL alphaThresholdPercent) {
    	
    }
    
    // The palette must be allocated and count must be set to the number of
    // entries in the palette. If there are not enough, the API will fail.
    
    static Status InitializePalette(
        in ColorPalette *palette,  // Palette to initialize.
        PaletteType palettetype,       // palette enumeration type.
        INT optimalColors,             // how many optimal colors
        BOOL useTransparentColor,      // add a transparent color to the palette.
        Bitmap *bitmap                 // optional bitmap for median cut.
        ) {
        	
    }
        
    Status ApplyEffect(Effect *effect, RECT* ROI) {
    }
    
    static Status ApplyEffect(
        in  Bitmap **inputs,
        in  INT numInputs,
        in  Effect *effect, 
        in  RECT *ROI,           // optional parameter.
        RECT *outputRect,    // optional parameter.
        Bitmap **output
    ) {    	
    }
    
    Status GetHistogram(
        in HistogramFormat format,
        in UINT NumberOfEntries,
        UINT *channel0,
        UINT *channel1,
        UINT *channel2,
        UINT *channel3
    ) {    	
    }
    
    static Status GetHistogramSize(in HistogramFormat format, UINT *NumberOfEntries) {    	
    }
    */
    
    Status SetResolution(in REAL xdpi, in REAL ydpi) {  
	    return SetStatus(GdipBitmapSetResolution(
	        cast(GpBitmap *)(nativeImage),
	        xdpi, ydpi));  	
    }

    this(in IDirectDrawSurface7* surface) {
	    GpBitmap *bitmap = null;
	
	    lastResult = GdipCreateBitmapFromDirectDrawSurface(surface,
	                                                       &bitmap);
	
	    SetNativeImage(bitmap);    	
    }
    
    this(in BITMAPINFO* gdiBitmapInfo, in VOID* gdiBitmapData) {   
	    GpBitmap *bitmap = null;
	
	    lastResult = GdipCreateBitmapFromGdiDib(gdiBitmapInfo,
	                                                        gdiBitmapData,
	                                                        &bitmap);
	
	    SetNativeImage(bitmap); 	
    }
    
    this(in HBITMAP hbm, in HPALETTE hpal) {  
	    GpBitmap *bitmap = null;
	
	    lastResult = GdipCreateBitmapFromHBITMAP(hbm, hpal, &bitmap);
	
	    SetNativeImage(bitmap);  	
    }
    
    this(in HICON hicon) {  
	    GpBitmap *bitmap = null;
	
	    lastResult = GdipCreateBitmapFromHICON(hicon, &bitmap);
	
	    SetNativeImage(bitmap);  	
    }
    
    this(in HINSTANCE hInstance, in WCHAR * bitmapName) { 
	    GpBitmap *bitmap = null;
	
	    lastResult = GdipCreateBitmapFromResource(hInstance,
	                                                          bitmapName,
	                                                          &bitmap);
	
	    SetNativeImage(bitmap);   	
    }
    
    static Bitmap FromDirectDrawSurface7(in IDirectDrawSurface7* surface) {    
    	return new Bitmap(surface);	
    }
    
    static Bitmap FromBITMAPINFO(in BITMAPINFO* gdiBitmapInfo, in VOID* gdiBitmapData) {    
    	return new Bitmap(gdiBitmapInfo, gdiBitmapData);	
    }
    
    static Bitmap FromHBITMAP(in HBITMAP hbm, in HPALETTE hpal) { 
    	return new Bitmap(hbm, hpal);   	
    }
    
    static Bitmap FromHICON(in HICON hicon) {
    	return new Bitmap(hicon);    	
    }
    
    static Bitmap FromResource(in HINSTANCE hInstance, in WCHAR * bitmapName) {  
    	return new Bitmap(hInstance, bitmapName);  	
    }
    
    Status GetHBITMAP(in Color colorBackground, HBITMAP *hbmReturn) {
	    return SetStatus(GdipCreateHBITMAPFromBitmap(
	                                        cast(GpBitmap*)(nativeImage),
	                                        hbmReturn,
	                                        colorBackground.GetValue()));    	
    }
    
    Status GetHICON(HICON *hicon) {   
	    return SetStatus(GdipCreateHICONFromBitmap(
	                                        cast(GpBitmap*)(nativeImage),
	                                        hicon)); 	
    }
    
protected:
    package this(GpBitmap *nativeBitmap) {  
	    lastResult = Status.Ok;
	
	    SetNativeImage(nativeBitmap);  	
    }
}

