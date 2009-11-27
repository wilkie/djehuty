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

    Status GetPhysicalDimension(out SizeF* size) {
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

    Status GetBounds(out RectF* srcRect,
                     out Unit* srcUnit) {
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

    Status GetRawFormat(out GUID *format) {
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

    Status GetPalette(out ColorPalette* palette,
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

    Status GetFrameDimensionsList(out GUID* dimensionIDs,
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
                             out PROPID* list) {
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
                           out PropertyItem* buffer) {
	    return SetStatus(GdipGetPropertyItem(nativeImage,
	                                                     propId, propSize, buffer));
	}

    Status GetPropertySize(out UINT* totalBufferSize,
                           out UINT* numProperties) {
	    return SetStatus(GdipGetPropertySize(nativeImage,
	                                                     totalBufferSize,
	                                                     numProperties));
    }

    Status GetAllPropertyItems(in UINT totalBufferSize,
                               in UINT numProperties,
                               out PropertyItem* allItems) {
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
                                   out EncoderParameters* buffer) {
	    return SetStatus(GdipGetEncoderParameterList(nativeImage,
	                                                             clsidEncoder,
	                                                             size,
	                                                             buffer));
    }

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