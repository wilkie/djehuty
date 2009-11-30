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

module binding.win32.gdiplusimaging;

import binding.win32.windef;
import binding.win32.winbase;
import binding.win32.winnt;
import binding.win32.guiddef;
import binding.win32.gdiplustypes;
import binding.win32.gdiplusenums;
import binding.win32.gdipluspixelformats;

/**************************************************************************\
*
* Copyright (c) 1999-2000  Microsoft Corporation
*
* Module Name:
*
*   GdiplusImaging.h
*
* Abstract:
*
*   GDI+ Imaging GUIDs
*
\**************************************************************************/

extern(System):

//---------------------------------------------------------------------------
// Image file format identifiers
//---------------------------------------------------------------------------

const GUID ImageFormatUndefined = {0xb96b3ca9,0x0728,0x11d3,[0x9d,0x7b,0x00,0x00,0xf8,0x1e,0xf3,0x2e]};
const GUID ImageFormatMemoryBMP = {0xb96b3caa,0x0728,0x11d3,[0x9d,0x7b,0x00,0x00,0xf8,0x1e,0xf3,0x2e]};
const GUID ImageFormatBMP = {0xb96b3cab,0x0728,0x11d3,[0x9d,0x7b,0x00,0x00,0xf8,0x1e,0xf3,0x2e]};
const GUID ImageFormatEMF = {0xb96b3cac,0x0728,0x11d3,[0x9d,0x7b,0x00,0x00,0xf8,0x1e,0xf3,0x2e]};
const GUID ImageFormatWMF = {0xb96b3cad,0x0728,0x11d3,[0x9d,0x7b,0x00,0x00,0xf8,0x1e,0xf3,0x2e]};
const GUID ImageFormatJPEG = {0xb96b3cae,0x0728,0x11d3,[0x9d,0x7b,0x00,0x00,0xf8,0x1e,0xf3,0x2e]};
const GUID ImageFormatPNG = {0xb96b3caf,0x0728,0x11d3,[0x9d,0x7b,0x00,0x00,0xf8,0x1e,0xf3,0x2e]};
const GUID ImageFormatGIF = {0xb96b3cb0,0x0728,0x11d3,[0x9d,0x7b,0x00,0x00,0xf8,0x1e,0xf3,0x2e]};
const GUID ImageFormatTIFF = {0xb96b3cb1,0x0728,0x11d3,[0x9d,0x7b,0x00,0x00,0xf8,0x1e,0xf3,0x2e]};
const GUID ImageFormatEXIF = {0xb96b3cb2,0x0728,0x11d3,[0x9d,0x7b,0x00,0x00,0xf8,0x1e,0xf3,0x2e]};
const GUID ImageFormatIcon = {0xb96b3cb5,0x0728,0x11d3,[0x9d,0x7b,0x00,0x00,0xf8,0x1e,0xf3,0x2e]};

//---------------------------------------------------------------------------
// Predefined multi-frame dimension IDs
//---------------------------------------------------------------------------

const GUID FrameDimensionTime = {0x6aedbd6d,0x3fb5,0x418a,[0x83,0xa6,0x7f,0x45,0x22,0x9d,0xc8,0x72]};
const GUID FrameDimensionResolution = {0x84236f7b,0x3bd3,0x428f,[0x8d,0xab,0x4e,0xa1,0x43,0x9c,0xa3,0x15]};
const GUID FrameDimensionPage = {0x7462dc86,0x6180,0x4c7e,[0x8e,0x3f,0xee,0x73,0x33,0xa7,0xa4,0x83]};

//---------------------------------------------------------------------------
// Property sets
//---------------------------------------------------------------------------

const GUID FormatIDImageInformation = {0xe5836cbe,0x5eef,0x4f1d,[0xac,0xde,0xae,0x4c,0x43,0xb6,0x08,0xce]};
const GUID FormatIDJpegAppHeaders = {0x1c4afdcd,0x6177,0x43cf,[0xab,0xc7,0x5f,0x51,0xaf,0x39,0xee,0x85]};

//---------------------------------------------------------------------------
// Encoder parameter sets
//---------------------------------------------------------------------------

const GUID EncoderCompression = {0xe09d739d,0xccd4,0x44ee,[0x8e,0xba,0x3f,0xbf,0x8b,0xe4,0xfc,0x58]};
const GUID EncoderColorDepth = {0x66087055,0xad66,0x4c7c,[0x9a,0x18,0x38,0xa2,0x31,0x0b,0x83,0x37]};
const GUID EncoderScanMethod = {0x3a4e2661,0x3109,0x4e56,[0x85,0x36,0x42,0xc1,0x56,0xe7,0xdc,0xfa]};
const GUID EncoderVersion = {0x24d18c76,0x814a,0x41a4,[0xbf,0x53,0x1c,0x21,0x9c,0xcc,0xf7,0x97]};
const GUID EncoderRenderMethod = {0x6d42c53a,0x229a,0x4825,[0x8b,0xb7,0x5c,0x99,0xe2,0xb9,0xa8,0xb8]};
const GUID EncoderQuality = {0x1d5be4b5,0xfa4a,0x452d,[0x9c,0xdd,0x5d,0xb3,0x51,0x05,0xe7,0xeb]};
const GUID EncoderTransformation = {0x8d0eb2d1,0xa58e,0x4ea8,[0xaa,0x14,0x10,0x80,0x74,0xb7,0xb6,0xf9]};
const GUID EncoderLuminanceTable = {0xedb33bce,0x0266,0x4a77,[0xb9,0x04,0x27,0x21,0x60,0x99,0xe7,0x17]};
const GUID EncoderChrominanceTable = {0xf2e455dc,0x09b3,0x4316,[0x82,0x60,0x67,0x6a,0xda,0x32,0x48,0x1c]};
const GUID EncoderSaveFlag = {0x292266fc,0xac40,0x47bf,[0x8c, 0xfc, 0xa8, 0x5b, 0x89, 0xa6, 0x55, 0xde]};

const GUID EncoderColorSpace = {0xae7a62a0,0xee2c,0x49d8,[0x9d,0x7,0x1b,0xa8,0xa9,0x27,0x59,0x6e]};
const GUID EncoderImageItems = {0x63875e13,0x1f1d,0x45ab,[0x91, 0x95, 0xa2, 0x9b, 0x60, 0x66, 0xa6, 0x50]};
const GUID EncoderSaveAsCMYK = {0xa219bbc9, 0xa9d, 0x4005, [0xa3, 0xee, 0x3a, 0x42, 0x1b, 0x8b, 0xb0, 0x6c]};

const GUID CodecIImageBytes = {0x025d1823,0x6c7d,0x447b,[0xbb, 0xdb, 0xa3, 0xcb, 0xc3, 0xdf, 0xa2, 0xfc]};

/*MIDL_INTERFACE("025D1823-6C7D-447B-BBDB-A3CBC3DFA2FC")
IImageBytes : public IUnknown
{
public:
    // Return total number of bytes in the IStream

    STDMETHOD(CountBytes)(
        OUT UINT *pcb
        ) = 0;

    // Locks "cb" bytes, starting from "ulOffset" in the stream, and returns the
    // pointer to the beginning of the locked memory chunk in "ppvBytes"

    STDMETHOD(LockBytes)(
        IN UINT cb,
        IN ULONG ulOffset,
        OUT const VOID ** ppvBytes
        ) = 0;

    // Unlocks "cb" bytes, pointed by "pvBytes", starting from "ulOffset" in the
    // stream

    STDMETHOD(UnlockBytes)(
        IN const VOID *pvBytes,
        IN UINT cb,
        IN ULONG ulOffset
        ) = 0;
};
*/

//--------------------------------------------------------------------------
// ImageCodecInfo structure
//--------------------------------------------------------------------------

struct ImageCodecInfo {
    CLSID Clsid;
    GUID  FormatID;
    WCHAR* CodecName;
    WCHAR* DllName;
    WCHAR* FormatDescription;
    WCHAR* FilenameExtension;
    WCHAR* MimeType;
    DWORD Flags;
    DWORD Version;
    DWORD SigCount;
    DWORD SigSize;
    BYTE* SigPattern;
    BYTE* SigMask;
}

//--------------------------------------------------------------------------
// Information flags about image codecs
//--------------------------------------------------------------------------

enum ImageCodecFlags {
    ImageCodecFlagsEncoder            = 0x00000001,
    ImageCodecFlagsDecoder            = 0x00000002,
    ImageCodecFlagsSupportBitmap      = 0x00000004,
    ImageCodecFlagsSupportVector      = 0x00000008,
    ImageCodecFlagsSeekableEncode     = 0x00000010,
    ImageCodecFlagsBlockingDecode     = 0x00000020,

    ImageCodecFlagsBuiltin            = 0x00010000,
    ImageCodecFlagsSystem             = 0x00020000,
    ImageCodecFlagsUser               = 0x00040000
}

//---------------------------------------------------------------------------
// Access modes used when calling Image::LockBits
//---------------------------------------------------------------------------

enum ImageLockMode {
    ImageLockModeRead        = 0x0001,
    ImageLockModeWrite       = 0x0002,
    ImageLockModeReadWrite   = 0x0003,
    ImageLockModeUserInputBuf= 0x0004
}

//---------------------------------------------------------------------------
// Information about image pixel data
//---------------------------------------------------------------------------

struct BitmapData {
    UINT Width;
    UINT Height;
    INT Stride;
    PixelFormat _PixelFormat;
    VOID* Scan0;
    UINT_PTR Reserved;
}

//---------------------------------------------------------------------------
// Image flags
//---------------------------------------------------------------------------

enum ImageFlags {
    ImageFlagsNone                = 0,

    // Low-word: shared with SINKFLAG_x

    ImageFlagsScalable            = 0x0001,
    ImageFlagsHasAlpha            = 0x0002,
    ImageFlagsHasTranslucent      = 0x0004,
    ImageFlagsPartiallyScalable   = 0x0008,

    // Low-word: color space definition

    ImageFlagsColorSpaceRGB       = 0x0010,
    ImageFlagsColorSpaceCMYK      = 0x0020,
    ImageFlagsColorSpaceGRAY      = 0x0040,
    ImageFlagsColorSpaceYCBCR     = 0x0080,
    ImageFlagsColorSpaceYCCK      = 0x0100,

    // Low-word: image size info

    ImageFlagsHasRealDPI          = 0x1000,
    ImageFlagsHasRealPixelSize    = 0x2000,

    // High-word

    ImageFlagsReadOnly            = 0x00010000,
    ImageFlagsCaching             = 0x00020000
}

enum RotateFlipType {
    RotateNoneFlipNone = 0,
    Rotate90FlipNone   = 1,
    Rotate180FlipNone  = 2,
    Rotate270FlipNone  = 3,

    RotateNoneFlipX    = 4,
    Rotate90FlipX      = 5,
    Rotate180FlipX     = 6,
    Rotate270FlipX     = 7,

    RotateNoneFlipY    = Rotate180FlipX,
    Rotate90FlipY      = Rotate270FlipX,
    Rotate180FlipY     = RotateNoneFlipX,
    Rotate270FlipY     = Rotate90FlipX,

    RotateNoneFlipXY   = Rotate180FlipNone,
    Rotate90FlipXY     = Rotate270FlipNone,
    Rotate180FlipXY    = RotateNoneFlipNone,
    Rotate270FlipXY    = Rotate90FlipNone
}

//---------------------------------------------------------------------------
// Encoder Parameter structure
//---------------------------------------------------------------------------
struct EncoderParameter {
    GUID    Guid;               // GUID of the parameter
    ULONG   NumberOfValues;     // Number of the parameter values
    ULONG   Type;               // Value type, like ValueTypeLONG  etc.
    VOID*   Value;              // A pointer to the parameter values
}

//---------------------------------------------------------------------------
// Encoder Parameters structure
//---------------------------------------------------------------------------
struct EncoderParameters {
    UINT Count;                      // Number of parameters in this structure
    EncoderParameter[1] Parameter;   // Parameter values
}

enum ItemDataPosition {
    ItemDataPositionAfterHeader    = 0x0,
    ItemDataPositionAfterPalette   = 0x1,
    ItemDataPositionAfterBits      = 0x2,
}

//---------------------------------------------------------------------------
// External Data Item
//---------------------------------------------------------------------------
struct ImageItemData {
    UINT  Size;           // size of the structure
    UINT  Position;       // flags describing how the data is to be used.
    VOID *Desc;           // description on how the data is to be saved.
                          // it is different for every codec type.
    UINT  DescSize;       // size memory pointed by Desc
    VOID *Data;           // pointer to the data that is to be saved in the
                          // file, could be anything saved directly.
    UINT  DataSize;       // size memory pointed by Data
    UINT  Cookie;         // opaque for the apps data member used during
                          // enumeration of image data items.
}

//---------------------------------------------------------------------------
// Property Item
//---------------------------------------------------------------------------
struct PropertyItem {
    ULONG  id;                 // ID of this property
    ULONG   length;             // Length of the property value, in bytes
    WORD    type;               // Type of the value, as one of TAG_TYPE_XXX
                                // defined above
    VOID*   value;              // property value
}

//---------------------------------------------------------------------------
// Image property types
//---------------------------------------------------------------------------
const auto PropertyTagTypeByte         = 1;
const auto PropertyTagTypeASCII        = 2;
const auto PropertyTagTypeShort        = 3;
const auto PropertyTagTypeLong         = 4;
const auto PropertyTagTypeRational     = 5;
const auto PropertyTagTypeUndefined    = 7;
const auto PropertyTagTypeSLONG        = 9;
const auto PropertyTagTypeSRational   = 10;

//---------------------------------------------------------------------------
// Image property ID tags
//---------------------------------------------------------------------------

const auto PropertyTagExifIFD              = 0x8769;
const auto PropertyTagGpsIFD               = 0x8825;

const auto PropertyTagNewSubfileType       = 0x00FE;
const auto PropertyTagSubfileType          = 0x00FF;
const auto PropertyTagImageWidth           = 0x0100;
const auto PropertyTagImageHeight          = 0x0101;
const auto PropertyTagBitsPerSample        = 0x0102;
const auto PropertyTagCompression          = 0x0103;
const auto PropertyTagPhotometricInterp    = 0x0106;
const auto PropertyTagThreshHolding        = 0x0107;
const auto PropertyTagCellWidth            = 0x0108;
const auto PropertyTagCellHeight           = 0x0109;
const auto PropertyTagFillOrder            = 0x010A;
const auto PropertyTagDocumentName         = 0x010D;
const auto PropertyTagImageDescription     = 0x010E;
const auto PropertyTagEquipMake            = 0x010F;
const auto PropertyTagEquipModel           = 0x0110;
const auto PropertyTagStripOffsets         = 0x0111;
const auto PropertyTagOrientation          = 0x0112;
const auto PropertyTagSamplesPerPixel      = 0x0115;
const auto PropertyTagRowsPerStrip         = 0x0116;
const auto PropertyTagStripBytesCount      = 0x0117;
const auto PropertyTagMinSampleValue       = 0x0118;
const auto PropertyTagMaxSampleValue       = 0x0119;
const auto PropertyTagXResolution          = 0x011A   ; // Image resolution in width direction
const auto PropertyTagYResolution          = 0x011B   ; // Image resolution in height direction
const auto PropertyTagPlanarConfig         = 0x011C   ; // Image data arrangement
const auto PropertyTagPageName             = 0x011D;
const auto PropertyTagXPosition            = 0x011E;
const auto PropertyTagYPosition            = 0x011F;
const auto PropertyTagFreeOffset           = 0x0120;
const auto PropertyTagFreeByteCounts       = 0x0121;
const auto PropertyTagGrayResponseUnit     = 0x0122;
const auto PropertyTagGrayResponseCurve    = 0x0123;
const auto PropertyTagT4Option             = 0x0124;
const auto PropertyTagT6Option             = 0x0125;
const auto PropertyTagResolutionUnit       = 0x0128   ; // Unit of X and Y resolution
const auto PropertyTagPageNumber           = 0x0129;
const auto PropertyTagTransferFuncition    = 0x012D;
const auto PropertyTagSoftwareUsed         = 0x0131;
const auto PropertyTagDateTime             = 0x0132;
const auto PropertyTagArtist               = 0x013B;
const auto PropertyTagHostComputer         = 0x013C;
const auto PropertyTagPredictor            = 0x013D;
const auto PropertyTagWhitePoint           = 0x013E;
const auto PropertyTagPrimaryChromaticities  = 0x013F;
const auto PropertyTagColorMap             = 0x0140;
const auto PropertyTagHalftoneHints        = 0x0141;
const auto PropertyTagTileWidth            = 0x0142;
const auto PropertyTagTileLength           = 0x0143;
const auto PropertyTagTileOffset           = 0x0144;
const auto PropertyTagTileByteCounts       = 0x0145;
const auto PropertyTagInkSet               = 0x014C;
const auto PropertyTagInkNames             = 0x014D;
const auto PropertyTagNumberOfInks         = 0x014E;
const auto PropertyTagDotRange             = 0x0150;
const auto PropertyTagTargetPrinter        = 0x0151;
const auto PropertyTagExtraSamples         = 0x0152;
const auto PropertyTagSampleFormat         = 0x0153;
const auto PropertyTagSMinSampleValue      = 0x0154;
const auto PropertyTagSMaxSampleValue      = 0x0155;
const auto PropertyTagTransferRange        = 0x0156;

const auto PropertyTagJPEGProc             = 0x0200;
const auto PropertyTagJPEGInterFormat      = 0x0201;
const auto PropertyTagJPEGInterLength      = 0x0202;
const auto PropertyTagJPEGRestartInterval  = 0x0203;
const auto PropertyTagJPEGLosslessPredictors   = 0x0205;
const auto PropertyTagJPEGPointTransforms      = 0x0206;
const auto PropertyTagJPEGQTables          = 0x0207;
const auto PropertyTagJPEGDCTables         = 0x0208;
const auto PropertyTagJPEGACTables         = 0x0209;

const auto PropertyTagYCbCrCoefficients    = 0x0211;
const auto PropertyTagYCbCrSubsampling     = 0x0212;
const auto PropertyTagYCbCrPositioning     = 0x0213;
const auto PropertyTagREFBlackWhite        = 0x0214;

const auto PropertyTagICCProfile           = 0x8773   ; // This TAG is defined by ICC
                                                // for embedded ICC in TIFF
const auto PropertyTagGamma                = 0x0301;
const auto PropertyTagICCProfileDescriptor  = 0x0302;
const auto PropertyTagSRGBRenderingIntent  = 0x0303;

const auto PropertyTagImageTitle           = 0x0320;
const auto PropertyTagCopyright            = 0x8298;

// Extra TAGs (Like Adobe Image Information tags etc.)

const auto PropertyTagResolutionXUnit            = 0x5001;
const auto PropertyTagResolutionYUnit            = 0x5002;
const auto PropertyTagResolutionXLengthUnit      = 0x5003;
const auto PropertyTagResolutionYLengthUnit      = 0x5004;
const auto PropertyTagPrintFlags                 = 0x5005;
const auto PropertyTagPrintFlagsVersion          = 0x5006;
const auto PropertyTagPrintFlagsCrop             = 0x5007;
const auto PropertyTagPrintFlagsBleedWidth       = 0x5008;
const auto PropertyTagPrintFlagsBleedWidthScale  = 0x5009;
const auto PropertyTagHalftoneLPI                = 0x500A;
const auto PropertyTagHalftoneLPIUnit            = 0x500B;
const auto PropertyTagHalftoneDegree             = 0x500C;
const auto PropertyTagHalftoneShape              = 0x500D;
const auto PropertyTagHalftoneMisc               = 0x500E;
const auto PropertyTagHalftoneScreen             = 0x500F;
const auto PropertyTagJPEGQuality                = 0x5010;
const auto PropertyTagGridSize                   = 0x5011;
const auto PropertyTagThumbnailFormat            = 0x5012  ; // 1 = JPEG, 0 = RAW RGB
const auto PropertyTagThumbnailWidth             = 0x5013;
const auto PropertyTagThumbnailHeight            = 0x5014;
const auto PropertyTagThumbnailColorDepth        = 0x5015;
const auto PropertyTagThumbnailPlanes            = 0x5016;
const auto PropertyTagThumbnailRawBytes          = 0x5017;
const auto PropertyTagThumbnailSize              = 0x5018;
const auto PropertyTagThumbnailCompressedSize    = 0x5019;
const auto PropertyTagColorTransferFunction      = 0x501A;
const auto PropertyTagThumbnailData              = 0x501B; // RAW thumbnail bits in
                                                   // JPEG format or RGB format
                                                   // depends on
                                                   // PropertyTagThumbnailFormat

// Thumbnail related TAGs
                                                
const auto PropertyTagThumbnailImageWidth        = 0x5020  ; // Thumbnail width
const auto PropertyTagThumbnailImageHeight       = 0x5021  ; // Thumbnail height
const auto PropertyTagThumbnailBitsPerSample     = 0x5022  ; // Number of bits per
                                                     // component
const auto PropertyTagThumbnailCompression       = 0x5023  ; // Compression Scheme
const auto PropertyTagThumbnailPhotometricInterp  = 0x5024 ; // Pixel composition
const auto PropertyTagThumbnailImageDescription  = 0x5025  ; // Image Tile
const auto PropertyTagThumbnailEquipMake         = 0x5026  ; // Manufacturer of Image
                                                     // Input equipment
const auto PropertyTagThumbnailEquipModel        = 0x5027  ; // Model of Image input
                                                     // equipment
const auto PropertyTagThumbnailStripOffsets      = 0x5028  ; // Image data location
const auto PropertyTagThumbnailOrientation       = 0x5029  ; // Orientation of image
const auto PropertyTagThumbnailSamplesPerPixel   = 0x502A  ; // Number of components
const auto PropertyTagThumbnailRowsPerStrip      = 0x502B  ; // Number of rows per strip
const auto PropertyTagThumbnailStripBytesCount   = 0x502C  ; // Bytes per compressed
                                                     // strip
const auto PropertyTagThumbnailResolutionX       = 0x502D  ; // Resolution in width
                                                     // direction
const auto PropertyTagThumbnailResolutionY       = 0x502E  ; // Resolution in height
                                                     // direction
const auto PropertyTagThumbnailPlanarConfig      = 0x502F  ; // Image data arrangement
const auto PropertyTagThumbnailResolutionUnit    = 0x5030  ; // Unit of X and Y
                                                     // Resolution
const auto PropertyTagThumbnailTransferFunction  = 0x5031  ; // Transfer function
const auto PropertyTagThumbnailSoftwareUsed      = 0x5032  ; // Software used
const auto PropertyTagThumbnailDateTime          = 0x5033  ; // File change date and
                                                     // time
const auto PropertyTagThumbnailArtist            = 0x5034  ; // Person who created the
                                                     // image
const auto PropertyTagThumbnailWhitePoint        = 0x5035  ; // White point chromaticity
const auto PropertyTagThumbnailPrimaryChromaticities  = 0x5036 ;
                                                     // Chromaticities of
                                                     // primaries
const auto PropertyTagThumbnailYCbCrCoefficients  = 0x5037 ; // Color space transforma-
                                                     // tion coefficients
const auto PropertyTagThumbnailYCbCrSubsampling  = 0x5038  ; // Subsampling ratio of Y
                                                     // to C
const auto PropertyTagThumbnailYCbCrPositioning  = 0x5039  ; // Y and C position
const auto PropertyTagThumbnailRefBlackWhite     = 0x503A  ; // Pair of black and white
                                                     // reference values
const auto PropertyTagThumbnailCopyRight         = 0x503B  ; // CopyRight holder

const auto PropertyTagLuminanceTable             = 0x5090;
const auto PropertyTagChrominanceTable           = 0x5091;

const auto PropertyTagFrameDelay                 = 0x5100;
const auto PropertyTagLoopCount                  = 0x5101;

const auto PropertyTagGlobalPalette              = 0x5102;
const auto PropertyTagIndexBackground            = 0x5103;
const auto PropertyTagIndexTransparent           = 0x5104;

const auto PropertyTagPixelUnit          = 0x5110  ; // Unit specifier for pixel/unit
const auto PropertyTagPixelPerUnitX      = 0x5111  ; // Pixels per unit in X
const auto PropertyTagPixelPerUnitY      = 0x5112  ; // Pixels per unit in Y
const auto PropertyTagPaletteHistogram   = 0x5113  ; // Palette histogram

// EXIF specific tag

const auto PropertyTagExifExposureTime   = 0x829A;
const auto PropertyTagExifFNumber        = 0x829D;

const auto PropertyTagExifExposureProg   = 0x8822;
const auto PropertyTagExifSpectralSense  = 0x8824;
const auto PropertyTagExifISOSpeed       = 0x8827;
const auto PropertyTagExifOECF           = 0x8828;

const auto PropertyTagExifVer             = 0x9000;
const auto PropertyTagExifDTOrig          = 0x9003 ; // Date & time of original
const auto PropertyTagExifDTDigitized     = 0x9004 ; // Date & time of digital data generation

const auto PropertyTagExifCompConfig      = 0x9101;
const auto PropertyTagExifCompBPP         = 0x9102;

const auto PropertyTagExifShutterSpeed    = 0x9201;
const auto PropertyTagExifAperture        = 0x9202;
const auto PropertyTagExifBrightness      = 0x9203;
const auto PropertyTagExifExposureBias    = 0x9204;
const auto PropertyTagExifMaxAperture     = 0x9205;
const auto PropertyTagExifSubjectDist     = 0x9206;
const auto PropertyTagExifMeteringMode    = 0x9207;
const auto PropertyTagExifLightSource     = 0x9208;
const auto PropertyTagExifFlash           = 0x9209;
const auto PropertyTagExifFocalLength     = 0x920A;
const auto PropertyTagExifSubjectArea     = 0x9214  ; // exif 2.2 Subject Area
const auto PropertyTagExifMakerNote       = 0x927C;
const auto PropertyTagExifUserComment     = 0x9286;
const auto PropertyTagExifDTSubsec        = 0x9290  ; // Date & Time subseconds
const auto PropertyTagExifDTOrigSS        = 0x9291  ; // Date & Time original subseconds
const auto PropertyTagExifDTDigSS         = 0x9292  ; // Date & TIme digitized subseconds

const auto PropertyTagExifFPXVer          = 0xA000;
const auto PropertyTagExifColorSpace      = 0xA001;
const auto PropertyTagExifPixXDim         = 0xA002;
const auto PropertyTagExifPixYDim         = 0xA003;
const auto PropertyTagExifRelatedWav      = 0xA004  ; // related sound file
const auto PropertyTagExifInterop         = 0xA005;
const auto PropertyTagExifFlashEnergy     = 0xA20B;
const auto PropertyTagExifSpatialFR       = 0xA20C  ; // Spatial Frequency Response
const auto PropertyTagExifFocalXRes       = 0xA20E  ; // Focal Plane X Resolution
const auto PropertyTagExifFocalYRes       = 0xA20F  ; // Focal Plane Y Resolution
const auto PropertyTagExifFocalResUnit    = 0xA210  ; // Focal Plane Resolution Unit
const auto PropertyTagExifSubjectLoc      = 0xA214;
const auto PropertyTagExifExposureIndex   = 0xA215;
const auto PropertyTagExifSensingMethod   = 0xA217;
const auto PropertyTagExifFileSource      = 0xA300;
const auto PropertyTagExifSceneType       = 0xA301;
const auto PropertyTagExifCfaPattern      = 0xA302;

// New EXIF 2.2 properties

const auto PropertyTagExifCustomRendered            = 0xA401;
const auto PropertyTagExifExposureMode              = 0xA402;
const auto PropertyTagExifWhiteBalance              = 0xA403;
const auto PropertyTagExifDigitalZoomRatio          = 0xA404;
const auto PropertyTagExifFocalLengthIn35mmFilm     = 0xA405;
const auto PropertyTagExifSceneCaptureType          = 0xA406;
const auto PropertyTagExifGainControl               = 0xA407;
const auto PropertyTagExifContrast                  = 0xA408;
const auto PropertyTagExifSaturation                = 0xA409;
const auto PropertyTagExifSharpness                 = 0xA40A;
const auto PropertyTagExifDeviceSettingDesc         = 0xA40B;
const auto PropertyTagExifSubjectDistanceRange      = 0xA40C;
const auto PropertyTagExifUniqueImageID             = 0xA420;


const auto PropertyTagGpsVer              = 0x0000;
const auto PropertyTagGpsLatitudeRef      = 0x0001;
const auto PropertyTagGpsLatitude         = 0x0002;
const auto PropertyTagGpsLongitudeRef     = 0x0003;
const auto PropertyTagGpsLongitude        = 0x0004;
const auto PropertyTagGpsAltitudeRef      = 0x0005;
const auto PropertyTagGpsAltitude         = 0x0006;
const auto PropertyTagGpsGpsTime          = 0x0007;
const auto PropertyTagGpsGpsSatellites    = 0x0008;
const auto PropertyTagGpsGpsStatus        = 0x0009;
const auto PropertyTagGpsGpsMeasureMode   = 0x00A;
const auto PropertyTagGpsGpsDop           = 0x000B  ; // Measurement precision
const auto PropertyTagGpsSpeedRef         = 0x000C;
const auto PropertyTagGpsSpeed            = 0x000D;
const auto PropertyTagGpsTrackRef         = 0x000E;
const auto PropertyTagGpsTrack            = 0x000F;
const auto PropertyTagGpsImgDirRef        = 0x0010;
const auto PropertyTagGpsImgDir           = 0x0011;
const auto PropertyTagGpsMapDatum         = 0x0012;
const auto PropertyTagGpsDestLatRef       = 0x0013;
const auto PropertyTagGpsDestLat          = 0x0014;
const auto PropertyTagGpsDestLongRef      = 0x0015;
const auto PropertyTagGpsDestLong         = 0x0016;
const auto PropertyTagGpsDestBearRef      = 0x0017;
const auto PropertyTagGpsDestBear         = 0x0018;
const auto PropertyTagGpsDestDistRef      = 0x0019;
const auto PropertyTagGpsDestDist         = 0x001A;
const auto PropertyTagGpsProcessingMethod  = 0x001B;
const auto PropertyTagGpsAreaInformation  = 0x001C;
const auto PropertyTagGpsDate             = 0x001D;
const auto PropertyTagGpsDifferential     = 0x001E;

