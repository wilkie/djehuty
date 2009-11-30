/*
 * wingdi.d
 *
 * This module binds wingdi.h to D. The original copyright notice is
 * preserved below.
 *
 * Author: Dave Wilkinson
 * Originated: November 24th, 2009
 *
 */

module binding.win32.wingdi;

import binding.win32.windef;
import binding.win32.winnt;
import binding.win32.winuser;

import binding.c;

extern(System):

// The original copyright from WinGDI.h:

/**************************************************************************
*                                                                         *
* wingdi.h -- GDI procedure declarations, constant definitions and macros *
*                                                                         *
* Copyright (c) Microsoft Corp. All rights reserved.                      *
*                                                                         *
**************************************************************************/

/* Binary raster ops */
const auto R2_BLACK            = 1;   /*  0       */
const auto R2_NOTMERGEPEN      = 2;   /* DPon     */
const auto R2_MASKNOTPEN       = 3;   /* DPna     */
const auto R2_NOTCOPYPEN       = 4;   /* PN       */
const auto R2_MASKPENNOT       = 5;   /* PDna     */
const auto R2_NOT              = 6;   /* Dn       */
const auto R2_XORPEN           = 7;   /* DPx      */
const auto R2_NOTMASKPEN       = 8;   /* DPan     */
const auto R2_MASKPEN          = 9;   /* DPa      */
const auto R2_NOTXORPEN        = 10;  /* DPxn     */
const auto R2_NOP              = 11;  /* D        */
const auto R2_MERGENOTPEN      = 12;  /* DPno     */
const auto R2_COPYPEN          = 13;  /* P        */
const auto R2_MERGEPENNOT      = 14;  /* PDno     */
const auto R2_MERGEPEN         = 15;  /* DPo      */
const auto R2_WHITE            = 16;  /*  1       */
const auto R2_LAST             = 16;

/* Ternary raster operations */
const auto SRCCOPY             = cast(DWORD)0x00CC0020; /* dest = source                   */
const auto SRCPAINT            = cast(DWORD)0x00EE0086; /* dest = source OR dest           */
const auto SRCAND              = cast(DWORD)0x008800C6; /* dest = source AND dest          */
const auto SRCINVERT           = cast(DWORD)0x00660046; /* dest = source XOR dest          */
const auto SRCERASE            = cast(DWORD)0x00440328; /* dest = source AND (NOT dest )   */
const auto NOTSRCCOPY          = cast(DWORD)0x00330008; /* dest = (NOT source)             */
const auto NOTSRCERASE         = cast(DWORD)0x001100A6; /* dest = (NOT src) AND (NOT dest) */
const auto MERGECOPY           = cast(DWORD)0x00C000CA; /* dest = (source AND pattern)     */
const auto MERGEPAINT          = cast(DWORD)0x00BB0226; /* dest = (NOT source) OR dest     */
const auto PATCOPY             = cast(DWORD)0x00F00021; /* dest = pattern                  */
const auto PATPAINT            = cast(DWORD)0x00FB0A09; /* dest = DPSnoo                   */
const auto PATINVERT           = cast(DWORD)0x005A0049; /* dest = pattern XOR dest         */
const auto DSTINVERT           = cast(DWORD)0x00550009; /* dest = (NOT dest)               */
const auto BLACKNESS           = cast(DWORD)0x00000042; /* dest = BLACK                    */
const auto WHITENESS           = cast(DWORD)0x00FF0062; /* dest = WHITE                    */

const auto NOMIRRORBITMAP      = cast(DWORD)0x80000000; /* Do not Mirror the bitmap in this call */
const auto CAPTUREBLT          = cast(DWORD)0x40000000; /* Include layered windows */

/* Quaternary raster codes */
template MAKEROP4(uint fore, uint back) {
	const uint MAKEROP4 = cast(uint)((((back) << 8) & 0xFF000000) | (fore));
}

const auto GDI_ERROR = (0xFFFFFFFFL);

const auto HGDI_ERROR = cast(HANDLE)(-1);

/* Region Flags */
const auto ERROR				= 0;
const auto NULLREGION			= 1;
const auto SIMPLEREGION			= 2;
const auto COMPLEXREGION		= 3;
const auto RGN_ERROR 			= ERROR;

/* CombineRgn() Styles */
const auto RGN_AND             = 1;
const auto RGN_OR              = 2;
const auto RGN_XOR             = 3;
const auto RGN_DIFF            = 4;
const auto RGN_COPY            = 5;
const auto RGN_MIN             = RGN_AND;
const auto RGN_MAX             = RGN_COPY;

/* StretchBlt() Modes */
const auto BLACKONWHITE                 = 1;
const auto WHITEONBLACK                 = 2;
const auto COLORONCOLOR                 = 3;
const auto HALFTONE                     = 4;
const auto MAXSTRETCHBLTMODE            = 4;

/* New StretchBlt() Modes */
const auto STRETCH_ANDSCANS    = BLACKONWHITE;
const auto STRETCH_ORSCANS     = WHITEONBLACK;
const auto STRETCH_DELETESCANS = COLORONCOLOR;
const auto STRETCH_HALFTONE    = HALFTONE;

/* PolyFill() Modes */
const auto ALTERNATE                    = 1;
const auto WINDING                      = 2;
const auto POLYFILL_LAST                = 2;

/* Layout Orientation Options */
const auto LAYOUT_RTL                         = 0x00000001; // Right to left
const auto LAYOUT_BTT                         = 0x00000002; // Bottom to top
const auto LAYOUT_VBH                         = 0x00000004; // Vertical before horizontal
const auto LAYOUT_ORIENTATIONMASK             = (LAYOUT_RTL | LAYOUT_BTT | LAYOUT_VBH);
const auto LAYOUT_BITMAPORIENTATIONPRESERVED  = 0x00000008;

/* Text Alignment Options */
const auto TA_NOUPDATECP                = 0;
const auto TA_UPDATECP                  = 1;

const auto TA_LEFT                      = 0;
const auto TA_RIGHT                     = 2;
const auto TA_CENTER                    = 6;

const auto TA_TOP                       = 0;
const auto TA_BOTTOM                    = 8;
const auto TA_BASELINE                  = 24;

const auto TA_RTLREADING                = 256;
const auto TA_MASK       = (TA_BASELINE+TA_CENTER+TA_UPDATECP+TA_RTLREADING);

const auto VTA_BASELINE = TA_BASELINE;
const auto VTA_LEFT     = TA_BOTTOM;
const auto VTA_RIGHT    = TA_TOP;
const auto VTA_CENTER   = TA_CENTER;
const auto VTA_BOTTOM   = TA_RIGHT;
const auto VTA_TOP      = TA_LEFT;

const auto ETO_OPAQUE                   = 0x0002;
const auto ETO_CLIPPED                  = 0x0004;

const auto ETO_GLYPH_INDEX              = 0x0010;
const auto ETO_RTLREADING               = 0x0080;
const auto ETO_NUMERICSLOCAL            = 0x0400;
const auto ETO_NUMERICSLATIN            = 0x0800;
const auto ETO_IGNORELANGUAGE           = 0x1000;

const auto ETO_PDY                      = 0x2000;
const auto ETO_REVERSE_INDEX_MAP        = 0x10000;

const auto ASPECT_FILTERING             = 0x0001;

/* Bounds Accumulation APIs */

const auto DCB_RESET       = 0x0001;
const auto DCB_ACCUMULATE  = 0x0002;
const auto DCB_DIRTY       = DCB_ACCUMULATE;
const auto DCB_SET         = (DCB_RESET | DCB_ACCUMULATE);
const auto DCB_ENABLE      = 0x0004;
const auto DCB_DISABLE     = 0x0008;

/* Metafile Functions */
const auto META_SETBKCOLOR              = 0x0201;
const auto META_SETBKMODE               = 0x0102;
const auto META_SETMAPMODE              = 0x0103;
const auto META_SETROP2                 = 0x0104;
const auto META_SETRELABS               = 0x0105;
const auto META_SETPOLYFILLMODE         = 0x0106;
const auto META_SETSTRETCHBLTMODE       = 0x0107;
const auto META_SETTEXTCHAREXTRA        = 0x0108;
const auto META_SETTEXTCOLOR            = 0x0209;
const auto META_SETTEXTJUSTIFICATION    = 0x020A;
const auto META_SETWINDOWORG            = 0x020B;
const auto META_SETWINDOWEXT            = 0x020C;
const auto META_SETVIEWPORTORG          = 0x020D;
const auto META_SETVIEWPORTEXT          = 0x020E;
const auto META_OFFSETWINDOWORG         = 0x020F;
const auto META_SCALEWINDOWEXT          = 0x0410;
const auto META_OFFSETVIEWPORTORG       = 0x0211;
const auto META_SCALEVIEWPORTEXT        = 0x0412;
const auto META_LINETO                  = 0x0213;
const auto META_MOVETO                  = 0x0214;
const auto META_EXCLUDECLIPRECT         = 0x0415;
const auto META_INTERSECTCLIPRECT       = 0x0416;
const auto META_ARC                     = 0x0817;
const auto META_ELLIPSE                 = 0x0418;
const auto META_FLOODFILL               = 0x0419;
const auto META_PIE                     = 0x081A;
const auto META_RECTANGLE               = 0x041B;
const auto META_ROUNDRECT               = 0x061C;
const auto META_PATBLT                  = 0x061D;
const auto META_SAVEDC                  = 0x001E;
const auto META_SETPIXEL                = 0x041F;
const auto META_OFFSETCLIPRGN           = 0x0220;
const auto META_TEXTOUT                 = 0x0521;
const auto META_BITBLT                  = 0x0922;
const auto META_STRETCHBLT              = 0x0B23;
const auto META_POLYGON                 = 0x0324;
const auto META_POLYLINE                = 0x0325;
const auto META_ESCAPE                  = 0x0626;
const auto META_RESTOREDC               = 0x0127;
const auto META_FILLREGION              = 0x0228;
const auto META_FRAMEREGION             = 0x0429;
const auto META_INVERTREGION            = 0x012A;
const auto META_PAINTREGION             = 0x012B;
const auto META_SELECTCLIPREGION        = 0x012C;
const auto META_SELECTOBJECT            = 0x012D;
const auto META_SETTEXTALIGN            = 0x012E;
const auto META_CHORD                   = 0x0830;
const auto META_SETMAPPERFLAGS          = 0x0231;
const auto META_EXTTEXTOUT              = 0x0a32;
const auto META_SETDIBTODEV             = 0x0d33;
const auto META_SELECTPALETTE           = 0x0234;
const auto META_REALIZEPALETTE          = 0x0035;
const auto META_ANIMATEPALETTE          = 0x0436;
const auto META_SETPALENTRIES           = 0x0037;
const auto META_POLYPOLYGON             = 0x0538;
const auto META_RESIZEPALETTE           = 0x0139;
const auto META_DIBBITBLT               = 0x0940;
const auto META_DIBSTRETCHBLT           = 0x0b41;
const auto META_DIBCREATEPATTERNBRUSH   = 0x0142;
const auto META_STRETCHDIB              = 0x0f43;
const auto META_EXTFLOODFILL            = 0x0548;

const auto META_SETLAYOUT               = 0x0149;

const auto META_DELETEOBJECT            = 0x01f0;
const auto META_CREATEPALETTE           = 0x00f7;
const auto META_CREATEPATTERNBRUSH      = 0x01F9;
const auto META_CREATEPENINDIRECT       = 0x02FA;
const auto META_CREATEFONTINDIRECT      = 0x02FB;
const auto META_CREATEBRUSHINDIRECT     = 0x02FC;
const auto META_CREATEREGION            = 0x06FF;

struct DRAWPATRECT {
	POINT ptPosition;
	POINT ptSize;
	WORD wStyle;
	WORD wPattern;
}

typedef DRAWPATRECT* PDRAWPATRECT;

/* GDI Escapes */
const auto NEWFRAME                     = 1;
const auto ABORTDOC                     = 2;
const auto NEXTBAND                     = 3;
const auto SETCOLORTABLE                = 4;
const auto GETCOLORTABLE                = 5;
const auto FLUSHOUTPUT                  = 6;
const auto DRAFTMODE                    = 7;
const auto QUERYESCSUPPORT              = 8;
const auto SETABORTPROC                 = 9;
const auto STARTDOC                     = 10;
const auto ENDDOC                       = 11;
const auto GETPHYSPAGESIZE              = 12;
const auto GETPRINTINGOFFSET            = 13;
const auto GETSCALINGFACTOR             = 14;
const auto MFCOMMENT                    = 15;
const auto GETPENWIDTH                  = 16;
const auto SETCOPYCOUNT                 = 17;
const auto SELECTPAPERSOURCE            = 18;
const auto DEVICEDATA                   = 19;
const auto PASSTHROUGH                  = 19;
const auto GETTECHNOLGY                 = 20;
const auto GETTECHNOLOGY                = 20;
const auto SETLINECAP                   = 21;
const auto SETLINEJOIN                  = 22;
const auto SETMITERLIMIT                = 23;
const auto BANDINFO                     = 24;
const auto DRAWPATTERNRECT              = 25;
const auto GETVECTORPENSIZE             = 26;
const auto GETVECTORBRUSHSIZE           = 27;
const auto ENABLEDUPLEX                 = 28;
const auto GETSETPAPERBINS              = 29;
const auto GETSETPRINTORIENT            = 30;
const auto ENUMPAPERBINS                = 31;
const auto SETDIBSCALING                = 32;
const auto EPSPRINTING                  = 33;
const auto ENUMPAPERMETRICS             = 34;
const auto GETSETPAPERMETRICS           = 35;
const auto POSTSCRIPT_DATA              = 37;
const auto POSTSCRIPT_IGNORE            = 38;
const auto MOUSETRAILS                  = 39;
const auto GETDEVICEUNITS               = 42;

const auto GETEXTENDEDTEXTMETRICS       = 256;
const auto GETEXTENTTABLE               = 257;
const auto GETPAIRKERNTABLE             = 258;
const auto GETTRACKKERNTABLE            = 259;
const auto EXTTEXTOUT                   = 512;
const auto GETFACENAME                  = 513;
const auto DOWNLOADFACE                 = 514;
const auto ENABLERELATIVEWIDTHS         = 768;
const auto ENABLEPAIRKERNING            = 769;
const auto SETKERNTRACK                 = 770;
const auto SETALLJUSTVALUES             = 771;
const auto SETCHARSET                   = 772;

const auto STRETCHBLT                   = 2048;
const auto METAFILE_DRIVER              = 2049;
const auto GETSETSCREENPARAMS           = 3072;
const auto QUERYDIBSUPPORT              = 3073;
const auto BEGIN_PATH                   = 4096;
const auto CLIP_TO_PATH                 = 4097;
const auto END_PATH                     = 4098;
const auto EXT_DEVICE_CAPS              = 4099;
const auto RESTORE_CTM                  = 4100;
const auto SAVE_CTM                     = 4101;
const auto SET_ARC_DIRECTION            = 4102;
const auto SET_BACKGROUND_COLOR         = 4103;
const auto SET_POLY_MODE                = 4104;
const auto SET_SCREEN_ANGLE             = 4105;
const auto SET_SPREAD                   = 4106;
const auto TRANSFORM_CTM                = 4107;
const auto SET_CLIP_BOX                 = 4108;
const auto SET_BOUNDS                   = 4109;
const auto SET_MIRROR_MODE              = 4110;
const auto OPENCHANNEL                  = 4110;
const auto DOWNLOADHEADER               = 4111;
const auto CLOSECHANNEL                 = 4112;
const auto POSTSCRIPT_PASSTHROUGH       = 4115;
const auto ENCAPSULATED_POSTSCRIPT      = 4116;

const auto POSTSCRIPT_IDENTIFY          = 4117;   /* new escape for NT5 pscript driver */
const auto POSTSCRIPT_INJECTION         = 4118;   /* new escape for NT5 pscript driver */

const auto CHECKJPEGFORMAT              = 4119;
const auto CHECKPNGFORMAT               = 4120;

const auto GET_PS_FEATURESETTING        = 4121;   /* new escape for NT5 pscript driver */

const auto GDIPLUS_TS_QUERYVER          = 4122;   /* private escape */
const auto GDIPLUS_TS_RECORD            = 4123;   /* private escape */

/*
 * Return Values for MILCORE_TS_QUERYVER
 */

const auto MILCORE_TS_QUERYVER_RESULT_FALSE = 0x0;
const auto MILCORE_TS_QUERYVER_RESULT_TRUE  = 0x7FFFFFFF;

const auto SPCLPASSTHROUGH2             = 4568;   /* new escape for NT5 pscript driver */

/*
 * Parameters for POSTSCRIPT_IDENTIFY escape
 */

const auto PSIDENT_GDICENTRIC    = 0;
const auto PSIDENT_PSCENTRIC     = 1;

/*
 * Header structure for the input buffer to POSTSCRIPT_INJECTION escape
 */

struct PSINJECTDATA {

    DWORD   DataBytes;      /* number of raw data bytes (NOT including this header) */
    WORD    InjectionPoint; /* injection point */
    WORD    PageNumber;     /* page number to apply the injection */

    /* Followed by raw data to be injected */

}

typedef PSINJECTDATA* PPSINJECTDATA;

/*
 * Constants for PSINJECTDATA.InjectionPoint field
 */

const auto PSINJECT_BEGINSTREAM                = 1;
const auto PSINJECT_PSADOBE                    = 2;
const auto PSINJECT_PAGESATEND                 = 3;
const auto PSINJECT_PAGES                      = 4;

const auto PSINJECT_DOCNEEDEDRES               = 5;
const auto PSINJECT_DOCSUPPLIEDRES             = 6;
const auto PSINJECT_PAGEORDER                  = 7;
const auto PSINJECT_ORIENTATION                = 8;
const auto PSINJECT_BOUNDINGBOX                = 9;
const auto PSINJECT_DOCUMENTPROCESSCOLORS      = 10;

const auto PSINJECT_COMMENTS                   = 11;
const auto PSINJECT_BEGINDEFAULTS              = 12;
const auto PSINJECT_ENDDEFAULTS                = 13;
const auto PSINJECT_BEGINPROLOG                = 14;
const auto PSINJECT_ENDPROLOG                  = 15;
const auto PSINJECT_BEGINSETUP                 = 16;
const auto PSINJECT_ENDSETUP                   = 17;
const auto PSINJECT_TRAILER                    = 18;
const auto PSINJECT_EOF                        = 19;
const auto PSINJECT_ENDSTREAM                  = 20;
const auto PSINJECT_DOCUMENTPROCESSCOLORSATEND = 21;

const auto PSINJECT_PAGENUMBER                 = 100;
const auto PSINJECT_BEGINPAGESETUP             = 101;
const auto PSINJECT_ENDPAGESETUP               = 102;
const auto PSINJECT_PAGETRAILER                = 103;
const auto PSINJECT_PLATECOLOR                 = 104;

const auto PSINJECT_SHOWPAGE                   = 105;
const auto PSINJECT_PAGEBBOX                   = 106;
const auto PSINJECT_ENDPAGECOMMENTS            = 107;

const auto PSINJECT_VMSAVE                     = 200;
const auto PSINJECT_VMRESTORE                  = 201;

/*
 * Parameter for GET_PS_FEATURESETTING escape
 */

const auto FEATURESETTING_NUP                  = 0;
const auto FEATURESETTING_OUTPUT               = 1;
const auto FEATURESETTING_PSLEVEL              = 2;
const auto FEATURESETTING_CUSTPAPER            = 3;
const auto FEATURESETTING_MIRROR               = 4;
const auto FEATURESETTING_NEGATIVE             = 5;
const auto FEATURESETTING_PROTOCOL             = 6;

//
// The range of selectors between FEATURESETTING_PRIVATE_BEGIN and
// FEATURESETTING_PRIVATE_END is reserved by Microsoft for private use
//
const auto FEATURESETTING_PRIVATE_BEGIN = 0x1000;
const auto FEATURESETTING_PRIVATE_END   = 0x1FFF;

/*
 * Information about output options
 */

struct PSFEATURE_OUTPUT {
    BOOL bPageIndependent;
    BOOL bSetPageDevice;
}

typedef PSFEATURE_OUTPUT* PPSFEATURE_OUTPUT;

/*
 * Information about custom paper size
 */

struct PSFEATURE_CUSTPAPER {
	LONG lOrientation;
	LONG lWidth;
	LONG lHeight;
	LONG lWidthOffset;
	LONG lHeightOffset;

}

typedef PSFEATURE_CUSTPAPER* PPSFEATURE_CUSTPAPER;

/* Value returned for FEATURESETTING_PROTOCOL */
const auto PSPROTOCOL_ASCII             = 0;
const auto PSPROTOCOL_BCP               = 1;
const auto PSPROTOCOL_TBCP              = 2;
const auto PSPROTOCOL_BINARY            = 3;

/* Flag returned from QUERYDIBSUPPORT */
const auto QDI_SETDIBITS                = 1;
const auto QDI_GETDIBITS                = 2;
const auto QDI_DIBTOSCREEN              = 4;
const auto QDI_STRETCHDIB               = 8;

/* Spooler Error Codes */
const auto SP_NOTREPORTED               = 0x4000;
const auto SP_ERROR                     = (-1);
const auto SP_APPABORT                  = (-2);
const auto SP_USERABORT                 = (-3);
const auto SP_OUTOFDISK                 = (-4);
const auto SP_OUTOFMEMORY               = (-5);

const auto PR_JOBSTATUS                 = 0x0000;

/* Object Definitions for EnumObjects() */
const auto OBJ_PEN             = 1;
const auto OBJ_BRUSH           = 2;
const auto OBJ_DC              = 3;
const auto OBJ_METADC          = 4;
const auto OBJ_PAL             = 5;
const auto OBJ_FONT            = 6;
const auto OBJ_BITMAP          = 7;
const auto OBJ_REGION          = 8;
const auto OBJ_METAFILE        = 9;
const auto OBJ_MEMDC           = 10;
const auto OBJ_EXTPEN          = 11;
const auto OBJ_ENHMETADC       = 12;
const auto OBJ_ENHMETAFILE     = 13;
const auto OBJ_COLORSPACE      = 14;

const auto GDI_OBJ_LAST        = OBJ_COLORSPACE;

/* xform stuff */
const auto MWT_IDENTITY        = 1;
const auto MWT_LEFTMULTIPLY    = 2;
const auto MWT_RIGHTMULTIPLY   = 3;

const auto MWT_MIN             = MWT_IDENTITY;
const auto MWT_MAX             = MWT_RIGHTMULTIPLY;

const auto _XFORM_ = 0;
struct XFORM {
	FLOAT   eM11;
	FLOAT   eM12;
	FLOAT   eM21;
	FLOAT   eM22;
	FLOAT   eDx;
	FLOAT   eDy;
}

typedef XFORM* PXFORM;
typedef XFORM* LPXFORM;

/* Bitmap Header Definition */
struct BITMAP {
	LONG        bmType;
	LONG        bmWidth;
	LONG        bmHeight;
	LONG        bmWidthBytes;
	WORD        bmPlanes;
	WORD        bmBitsPixel;
	LPVOID      bmBits;
}

typedef BITMAP* PBITMAP;
typedef BITMAP* NPBITMAP;
typedef BITMAP* LPBITMAP;

align(1) struct RGBTRIPLE {
	BYTE    rgbtBlue;
	BYTE    rgbtGreen;
	BYTE    rgbtRed;
} 

typedef RGBTRIPLE* PRGBTRIPLE;
typedef RGBTRIPLE* NPRGBTRIPLE;
typedef RGBTRIPLE* LPRGBTRIPLE;

struct RGBQUAD {
	BYTE    rgbBlue;
	BYTE    rgbGreen;
	BYTE    rgbRed;
	BYTE    rgbReserved;
}
typedef RGBQUAD* LPRGBQUAD;

/* Image Color Matching color definitions */

const auto CS_ENABLE                       = 0x00000001;
const auto CS_DISABLE                      = 0x00000002;
const auto CS_DELETE_TRANSFORM             = 0x00000003;

/* Logcolorspace signature */

const auto LCS_SIGNATURE           = "PSOC"c;

/* Logcolorspace lcsType values */

const auto LCS_sRGB                = "sRGB"c;
const auto LCS_WINDOWS_COLOR_SPACE = "Win "c;  // Windows default color space

typedef LONG LCSCSTYPE;
const auto LCS_CALIBRATED_RGB              = 0x00000000;

typedef LONG LCSGAMUTMATCH;
const auto LCS_GM_BUSINESS                 = 0x00000001;
const auto LCS_GM_GRAPHICS                 = 0x00000002;
const auto LCS_GM_IMAGES                   = 0x00000004;
const auto LCS_GM_ABS_COLORIMETRIC         = 0x00000008;

/* ICM Defines for results from CheckColorInGamut() */
const auto CM_OUT_OF_GAMUT                 = 255;
const auto CM_IN_GAMUT                     = 0;

/* UpdateICMRegKey Constants               */
const auto ICM_ADDPROFILE                  = 1;
const auto ICM_DELETEPROFILE               = 2;
const auto ICM_QUERYPROFILE                = 3;
const auto ICM_SETDEFAULTPROFILE           = 4;
const auto ICM_REGISTERICMATCHER           = 5;
const auto ICM_UNREGISTERICMATCHER         = 6;
const auto ICM_QUERYMATCH                  = 7;

/* Macros to retrieve CMYK values from a COLORREF */
template GetKValue(COLORREF cmyk) {
	const BYTE GetKValue = cast(BYTE)(cmyk);
}

template GetYValue(COLORREF cmyk) {
	const BYTE GetYValue = cast(BYTE)(cmyk >> 8);
}

template GetYValue(COLORREF cmyk) {
	const BYTE GetMValue = cast(BYTE)(cmyk >> 16);
}

template GetYValue(COLORREF cmyk) {
	const BYTE GetCValue = cast(BYTE)(cmyk >> 24);
}

template CMYK(BYTE c, BYTE m, BYTE y, BYTE k) {
	const COLORREF CMYK = cast(COLORREF)(cast(uint)k | (cast(uint)y) << 8 | (cast(uint)m) << 16 | (cast(uint)c) << 24);
}

typedef Clong_t FXPT16DOT16;
typedef Clong_t* LPFXPT16DOT16;
typedef Clong_t FXPT2DOT30;
typedef Clong_t* LPFXPT2DOT30;

/* ICM Color Definitions */
// The following two structures are used for defining RGB's in terms of CIEXYZ.

struct CIEXYZ {
	FXPT2DOT30 ciexyzX;
	FXPT2DOT30 ciexyzY;
	FXPT2DOT30 ciexyzZ;
}

typedef CIEXYZ* LPCIEXYZ;

struct CIEXYZTRIPLE {
	CIEXYZ  ciexyzRed;
	CIEXYZ  ciexyzGreen;
	CIEXYZ  ciexyzBlue;
}

typedef CIEXYZTRIPLE* LPCIEXYZTRIPLE;

// The next structures the logical color space. Unlike pens and brushes,
// but like palettes, there is only one way to create a LogColorSpace.
// A pointer to it must be passed, its elements can't be pushed as
// arguments.

struct LOGCOLORSPACEA {
	DWORD lcsSignature;
	DWORD lcsVersion;
    DWORD lcsSize;
    LCSCSTYPE lcsCSType;
    LCSGAMUTMATCH lcsIntent;
    CIEXYZTRIPLE lcsEndpoints;
    DWORD lcsGammaRed;
    DWORD lcsGammaGreen;
    DWORD lcsGammaBlue;
    CHAR   lcsFilename[MAX_PATH];
}

typedef LOGCOLORSPACEA* LPLOGCOLORSPACEA;

struct LOGCOLORSPACEW {
    DWORD lcsSignature;
    DWORD lcsVersion;
    DWORD lcsSize;
    LCSCSTYPE lcsCSType;
    LCSGAMUTMATCH lcsIntent;
    CIEXYZTRIPLE lcsEndpoints;
    DWORD lcsGammaRed;
    DWORD lcsGammaGreen;
    DWORD lcsGammaBlue;
    WCHAR  lcsFilename[MAX_PATH];
}

typedef LOGCOLORSPACEW* LPLOGCOLORSPACEW;

version(UNICODE) {
	typedef LOGCOLORSPACEW LOGCOLORSPACE;
	typedef LPLOGCOLORSPACEW LPLOGCOLORSPACE;
}
else {
	typedef LOGCOLORSPACEA LOGCOLORSPACE;
	typedef LPLOGCOLORSPACEA LPLOGCOLORSPACE;
}

/* structures for defining DIBs */
struct BITMAPCOREHEADER {
	DWORD   bcSize;                 /* used to get to color table */
	WORD    bcWidth;
	WORD    bcHeight;
	WORD    bcPlanes;
	WORD    bcBitCount;
} 

typedef BITMAPCOREHEADER* LPBITMAPCOREHEADER;
typedef BITMAPCOREHEADER* PBITMAPCOREHEADER;

struct BITMAPINFOHEADER{
	DWORD      biSize;
	LONG       biWidth;
	LONG       biHeight;
	WORD       biPlanes;
	WORD       biBitCount;
	DWORD      biCompression;
	DWORD      biSizeImage;
	LONG       biXPelsPerMeter;
	LONG       biYPelsPerMeter;
	DWORD      biClrUsed;
	DWORD      biClrImportant;
} 

typedef BITMAPINFOHEADER* LPBITMAPINFOHEADER;
typedef BITMAPINFOHEADER* PBITMAPINFOHEADER;

struct BITMAPV4HEADER {
	DWORD        bV4Size;
	LONG         bV4Width;
	LONG         bV4Height;
	WORD         bV4Planes;
	WORD         bV4BitCount;
	DWORD        bV4V4Compression;
	DWORD        bV4SizeImage;
	LONG         bV4XPelsPerMeter;
	LONG         bV4YPelsPerMeter;
	DWORD        bV4ClrUsed;
	DWORD        bV4ClrImportant;
	DWORD        bV4RedMask;
	DWORD        bV4GreenMask;
	DWORD        bV4BlueMask;
	DWORD        bV4AlphaMask;
	DWORD        bV4CSType;
	CIEXYZTRIPLE bV4Endpoints;
	DWORD        bV4GammaRed;
	DWORD        bV4GammaGreen;
	DWORD        bV4GammaBlue;
}

typedef BITMAPV4HEADER* LPBITMAPV4HEADER;
typedef BITMAPV4HEADER* PBITMAPV4HEADER;

struct BITMAPV5HEADER {
	DWORD        bV5Size;
	LONG         bV5Width;
	LONG         bV5Height;
	WORD         bV5Planes;
	WORD         bV5BitCount;
	DWORD        bV5Compression;
	DWORD        bV5SizeImage;
	LONG         bV5XPelsPerMeter;
	LONG         bV5YPelsPerMeter;
	DWORD        bV5ClrUsed;
	DWORD        bV5ClrImportant;
	DWORD        bV5RedMask;
	DWORD        bV5GreenMask;
	DWORD        bV5BlueMask;
	DWORD        bV5AlphaMask;
	DWORD        bV5CSType;
	CIEXYZTRIPLE bV5Endpoints;
	DWORD        bV5GammaRed;
	DWORD        bV5GammaGreen;
	DWORD        bV5GammaBlue;
	DWORD        bV5Intent;
	DWORD        bV5ProfileData;
	DWORD        bV5ProfileSize;
	DWORD        bV5Reserved;
}

typedef BITMAPV5HEADER* LPBITMAPV5HEADER;
typedef BITMAPV5HEADER* PBITMAPV5HEADER;

// Values for bV5CSType
const auto PROFILE_LINKED          = "LINK"c;
const auto PROFILE_EMBEDDED        = "MBED"c;

/* constants for the biCompression field */
const auto BI_RGB        = 0;
const auto BI_RLE8       = 1;
const auto BI_RLE4       = 2;
const auto BI_BITFIELDS  = 3;
const auto BI_JPEG       = 4;
const auto BI_PNG        = 5;

struct BITMAPINFO {
	BITMAPINFOHEADER    bmiHeader;
	RGBQUAD             bmiColors[1];
}

typedef BITMAPINFO* LPBITMAPINFO;
typedef BITMAPINFO* PBITMAPINFO;

struct BITMAPCOREINFO {
	BITMAPCOREHEADER    bmciHeader;
	RGBTRIPLE           bmciColors[1];
}

typedef BITMAPCOREINFO* LPBITMAPCOREINFO;
typedef BITMAPCOREINFO* PBITMAPCOREINFO;

align(2) struct BITMAPFILEHEADER {
	WORD    bfType;
	DWORD   bfSize;
	WORD    bfReserved1;
	WORD    bfReserved2;
	DWORD   bfOffBits;
}
typedef BITMAPFILEHEADER* LPBITMAPFILEHEADER;
typedef BITMAPFILEHEADER* PBITMAPFILEHEADER;

POINTS* MAKEPOINTS(ref DWORD val) {
	return cast(POINTS*)(&val);
}

struct FONTSIGNATURE {
	DWORD fsUsb[4];
	DWORD fsCsb[2];
}

typedef FONTSIGNATURE* LPFONTSIGNATURE;
typedef FONTSIGNATURE* PFONTSIGNATURE;

struct CHARSETINFO {
	UINT ciCharset;
	UINT ciACP;
	FONTSIGNATURE fs;
}

typedef CHARSETINFO* NPCHARSETINFO;
typedef CHARSETINFO* LPCHARSETINFO;
typedef CHARSETINFO* PCHARSETINFO;

const auto TCI_SRCCHARSET  = 1;
const auto TCI_SRCCODEPAGE = 2;
const auto TCI_SRCFONTSIG  = 3;

const auto TCI_SRCLOCALE   = 0x1000;

struct LOCALESIGNATURE {
	DWORD lsUsb[4];
	DWORD lsCsbDefault[2];
	DWORD lsCsbSupported[2];
}

typedef LOCALESIGNATURE* LPLOCALESIGNATURE;
typedef LOCALESIGNATURE* PLOCALESIGNATURE;

/* Clipboard Metafile Picture Structure */
struct HANDLETABLE {
	HGDIOBJ     objectHandle[1];
}

typedef HANDLETABLE* PHANDLETABLE;
typedef HANDLETABLE* LPHANDLETABLE;

struct METARECORD {
	DWORD       rdSize;
	WORD        rdFunction;
	WORD        rdParm[1];
}
typedef METARECORD* PMETARECORD;
typedef METARECORD* LPMETARECORD;

struct METAFILEPICT {
	LONG        mm;
	LONG        xExt;
	LONG        yExt;
	HMETAFILE   hMF;
}

typedef METAFILEPICT* LPMETAFILEPICT;

align(2) struct METAHEADER {
	WORD        mtType;
	WORD        mtHeaderSize;
	WORD        mtVersion;
	DWORD       mtSize;
	WORD        mtNoObjects;
	DWORD       mtMaxRecord;
	WORD        mtNoParameters;
}

typedef METAHEADER* PMETAHEADER;
typedef METAHEADER* LPMETAHEADER;

/* Enhanced Metafile structures */
struct ENHMETARECORD {
	DWORD   iType;              // Record type EMR_XXX
	DWORD   nSize;              // Record size in bytes
	DWORD   dParm[1];           // Parameters
}

typedef ENHMETARECORD* PENHMETARECORD;
typedef ENHMETARECORD* LPENHMETARECORD;

struct ENHMETAHEADER {
	DWORD   iType;              // Record typeEMR_HEADER
	DWORD   nSize;              // Record size in bytes.  This may be greater
	                            // than the sizeof(ENHMETAHEADER).
	RECTL   rclBounds;          // Inclusive-inclusive bounds in device units
	RECTL   rclFrame;           // Inclusive-inclusive Picture Frame of metafile in .01 mm units
	DWORD   dSignature;         // Signature.  Must be ENHMETA_SIGNATURE.
	DWORD   nVersion;           // Version number
	DWORD   nBytes;             // Size of the metafile in bytes
	DWORD   nRecords;           // Number of records in the metafile
	WORD    nHandles;           // Number of handles in the handle table
	                            // Handle index zero is reserved.
	WORD    sReserved;          // Reserved.  Must be zero.
	DWORD   nDescription;       // Number of chars in the unicode description string
	                            // This is 0 if there is no description string
	DWORD   offDescription;     // Offset to the metafile description record.
	                            // This is 0 if there is no description string
	DWORD   nPalEntries;        // Number of entries in the metafile palette.
	SIZEL   szlDevice;          // Size of the reference device in pels
	SIZEL   szlMillimeters;     // Size of the reference device in millimeters
	DWORD   cbPixelFormat;      // Size of PIXELFORMATDESCRIPTOR information
	                            // This is 0 if no pixel format is set
	DWORD   offPixelFormat;     // Offset to PIXELFORMATDESCRIPTOR
	                            // This is 0 if no pixel format is set
	DWORD   bOpenGL;            // TRUE if OpenGL commands are present in
	                            // the metafile, otherwise FALSE
	SIZEL   szlMicrometers;     // Size of the reference device in micrometers
}

typedef ENHMETAHEADER* PENHMETAHEADER;
typedef ENHMETAHEADER* LPENHMETAHEADER;

/* tmPitchAndFamily flags */
const auto TMPF_FIXED_PITCH	= 0x01;
const auto TMPF_VECTOR		= 0x02;
const auto TMPF_DEVICE		= 0x08;
const auto TMPF_TRUETYPE	= 0x04;

//
// BCHAR definition for APPs
//
version(UNICODE) {
	typedef WCHAR BCHAR;
}
else {
	typedef BYTE BCHAR;
}

align(4) struct TEXTMETRICA {
    LONG        tmHeight;
    LONG        tmAscent;
    LONG        tmDescent;
    LONG        tmInternalLeading;
    LONG        tmExternalLeading;
    LONG        tmAveCharWidth;
    LONG        tmMaxCharWidth;
    LONG        tmWeight;
    LONG        tmOverhang;
    LONG        tmDigitizedAspectX;
    LONG        tmDigitizedAspectY;
    BYTE        tmFirstChar;
    BYTE        tmLastChar;
    BYTE        tmDefaultChar;
    BYTE        tmBreakChar;
    BYTE        tmItalic;
    BYTE        tmUnderlined;
    BYTE        tmStruckOut;
    BYTE        tmPitchAndFamily;
    BYTE        tmCharSet;
}

typedef TEXTMETRICA* PTEXTMETRICA;
typedef TEXTMETRICA* NPTEXTMETRICA;
typedef TEXTMETRICA* LPTEXTMETRICA;

align(4) struct TEXTMETRICW {
    LONG        tmHeight;
    LONG        tmAscent;
    LONG        tmDescent;
    LONG        tmInternalLeading;
    LONG        tmExternalLeading;
    LONG        tmAveCharWidth;
    LONG        tmMaxCharWidth;
    LONG        tmWeight;
    LONG        tmOverhang;
    LONG        tmDigitizedAspectX;
    LONG        tmDigitizedAspectY;
    WCHAR       tmFirstChar;
    WCHAR       tmLastChar;
    WCHAR       tmDefaultChar;
    WCHAR       tmBreakChar;
    BYTE        tmItalic;
    BYTE        tmUnderlined;
    BYTE        tmStruckOut;
    BYTE        tmPitchAndFamily;
    BYTE        tmCharSet;
}

typedef TEXTMETRICW* PTEXTMETRICW;
typedef TEXTMETRICW* NPTEXTMETRICW;
typedef TEXTMETRICW* LPTEXTMETRICW;

version(UNICODE) {
	typedef TEXTMETRICW TEXTMETRIC;
	typedef PTEXTMETRICW PTEXTMETRIC;
	typedef NPTEXTMETRICW NPTEXTMETRIC;
	typedef LPTEXTMETRICW LPTEXTMETRIC;
}
else {
	typedef TEXTMETRICA TEXTMETRIC;
	typedef PTEXTMETRICA PTEXTMETRIC;
	typedef NPTEXTMETRICA NPTEXTMETRIC;
	typedef LPTEXTMETRICA LPTEXTMETRIC;
}

/* ntmFlags field flags */
const auto NTM_REGULAR     = 0x00000040;
const auto NTM_BOLD        = 0x00000020;
const auto NTM_ITALIC      = 0x00000001;

/* new in NT 5.0 */

const auto NTM_NONNEGATIVE_AC  = 0x00010000;
const auto NTM_PS_OPENTYPE     = 0x00020000;
const auto NTM_TT_OPENTYPE     = 0x00040000;
const auto NTM_MULTIPLEMASTER  = 0x00080000;
const auto NTM_TYPE1           = 0x00100000;
const auto NTM_DSIG            = 0x00200000;

align(4) struct NEWTEXTMETRICA {
	LONG        tmHeight;
	LONG        tmAscent;
	LONG        tmDescent;
	LONG        tmInternalLeading;
	LONG        tmExternalLeading;
	LONG        tmAveCharWidth;
	LONG        tmMaxCharWidth;
	LONG        tmWeight;
	LONG        tmOverhang;
	LONG        tmDigitizedAspectX;
	LONG        tmDigitizedAspectY;
	BYTE        tmFirstChar;
	BYTE        tmLastChar;
	BYTE        tmDefaultChar;
	BYTE        tmBreakChar;
	BYTE        tmItalic;
	BYTE        tmUnderlined;
	BYTE        tmStruckOut;
	BYTE        tmPitchAndFamily;
	BYTE        tmCharSet;
	DWORD   ntmFlags;
	UINT    ntmSizeEM;
	UINT    ntmCellHeight;
	UINT    ntmAvgWidth;
}

typedef NEWTEXTMETRICA* PNEWTEXTMETRICA;
typedef NEWTEXTMETRICA* NPNEWTEXTMETRICA;
typedef NEWTEXTMETRICA* LPNEWTEXTMETRICA;

struct NEWTEXTMETRICW {
	LONG        tmHeight;
	LONG        tmAscent;
	LONG        tmDescent;
	LONG        tmInternalLeading;
	LONG        tmExternalLeading;
	LONG        tmAveCharWidth;
	LONG        tmMaxCharWidth;
	LONG        tmWeight;
	LONG        tmOverhang;
	LONG        tmDigitizedAspectX;
	LONG        tmDigitizedAspectY;
	WCHAR       tmFirstChar;
	WCHAR       tmLastChar;
	WCHAR       tmDefaultChar;
	WCHAR       tmBreakChar;
	BYTE        tmItalic;
	BYTE        tmUnderlined;
	BYTE        tmStruckOut;
	BYTE        tmPitchAndFamily;
	BYTE        tmCharSet;
	DWORD   ntmFlags;
	UINT    ntmSizeEM;
	UINT    ntmCellHeight;
	UINT    ntmAvgWidth;
}

typedef NEWTEXTMETRICW* PNEWTEXTMETRICW;
typedef NEWTEXTMETRICW* NPNEWTEXTMETRICW;
typedef NEWTEXTMETRICW* LPNEWTEXTMETRICW;

version(UNICODE) {
	typedef NEWTEXTMETRICW NEWTEXTMETRIC;
	typedef PNEWTEXTMETRICW PNEWTEXTMETRIC;
	typedef NPNEWTEXTMETRICW NPNEWTEXTMETRIC;
	typedef LPNEWTEXTMETRICW LPNEWTEXTMETRIC;
}
else {
	typedef NEWTEXTMETRICA NEWTEXTMETRIC;
	typedef PNEWTEXTMETRICA PNEWTEXTMETRIC;
	typedef NPNEWTEXTMETRICA NPNEWTEXTMETRIC;
	typedef LPNEWTEXTMETRICA LPNEWTEXTMETRIC;
}

struct NEWTEXTMETRICEXA {
    NEWTEXTMETRICA  ntmTm;
    FONTSIGNATURE   ntmFontSig;
}

struct NEWTEXTMETRICEXW {
    NEWTEXTMETRICW  ntmTm;
    FONTSIGNATURE   ntmFontSig;
}

version(UNICODE) {
	typedef NEWTEXTMETRICEXW NEWTEXTMETRICEX;
}
else {
	typedef NEWTEXTMETRICEXA NEWTEXTMETRICEX;
}

/* GDI Logical Objects: */

/* Pel Array */
struct PELARRAY {
    LONG        paXCount;
    LONG        paYCount;
    LONG        paXExt;
    LONG        paYExt;
    BYTE        paRGBs;
}

typedef PELARRAY* PPELARRAY;
typedef PELARRAY* NPPELARRAY;
typedef PELARRAY* LPPELARRAY;

/* Logical Brush (or Pattern) */
struct LOGBRUSH {
    UINT        lbStyle;
    COLORREF    lbColor;
    ULONG_PTR    lbHatch;    // Sundown: lbHatch could hold a HANDLE
} 

typedef LOGBRUSH* PLOGBRUSH;
typedef LOGBRUSH* NPLOGBRUSH;
typedef LOGBRUSH* LPLOGBRUSH;

struct LOGBRUSH32 {
	UINT        lbStyle;
	COLORREF    lbColor;
	ULONG       lbHatch;
}

typedef LOGBRUSH32* PLOGBRUSH32;
typedef LOGBRUSH32* NPLOGBRUSH32;
typedef LOGBRUSH32* LPLOGBRUSH32;

typedef LOGBRUSH            PATTERN;
typedef PATTERN             *PPATTERN;
typedef PATTERN *NPPATTERN;
typedef PATTERN *LPPATTERN;

/* Logical Pen */
struct LOGPEN {
	UINT        lopnStyle;
	POINT       lopnWidth;
	COLORREF    lopnColor;
}

typedef LOGPEN* PLOGPEN;
typedef LOGPEN* NPLOGPEN;
typedef LOGPEN* LPLOGPEN;

struct EXTLOGPEN {
	DWORD       elpPenStyle;
	DWORD       elpWidth;
	UINT        elpBrushStyle;
	COLORREF    elpColor;
	ULONG_PTR   elpHatch;     //Sundown: elpHatch could take a HANDLE
	DWORD       elpNumEntries;
	DWORD[1]    elpStyleEntry;
}

typedef EXTLOGPEN* PEXTLOGPEN;
typedef EXTLOGPEN* NPEXTLOGPEN;
typedef EXTLOGPEN* LPEXTLOGPEN;

struct PALETTEENTRY {
	BYTE        peRed;
	BYTE        peGreen;
	BYTE        peBlue;
	BYTE        peFlags;
}

typedef PALETTEENTRY* PPALETTEENTRY;
typedef PALETTEENTRY* LPPALETTEENTRY;

/* Logical Palette */
struct LOGPALETTE {
    WORD        palVersion;
    WORD        palNumEntries;
	PALETTEENTRY[1]        palPalEntry;
}

typedef LOGPALETTE* PLOGPALETTE;
typedef LOGPALETTE* NPLOGPALETTE;
typedef LOGPALETTE* LPLOGPALETTE;

/* Logical Font */
const auto LF_FACESIZE         = 32;

struct LOGFONTA {
	LONG      lfHeight;
	LONG      lfWidth;
	LONG      lfEscapement;
	LONG      lfOrientation;
	LONG      lfWeight;
	BYTE      lfItalic;
	BYTE      lfUnderline;
	BYTE      lfStrikeOut;
	BYTE      lfCharSet;
	BYTE      lfOutPrecision;
	BYTE      lfClipPrecision;
	BYTE      lfQuality;
	BYTE      lfPitchAndFamily;
	CHAR      lfFaceName[LF_FACESIZE];
}

typedef LOGFONTA* PLOGFONTA;
typedef LOGFONTA* NPLOGFONTA;
typedef LOGFONTA* LPLOGFONTA;

struct LOGFONTW {
	LONG      lfHeight;
	LONG      lfWidth;
	LONG      lfEscapement;
	LONG      lfOrientation;
	LONG      lfWeight;
	BYTE      lfItalic;
	BYTE      lfUnderline;
	BYTE      lfStrikeOut;
	BYTE      lfCharSet;
	BYTE      lfOutPrecision;
	BYTE      lfClipPrecision;
	BYTE      lfQuality;
	BYTE      lfPitchAndFamily;
	WCHAR     lfFaceName[LF_FACESIZE];
}

typedef LOGFONTW* PLOGFONTW;
typedef LOGFONTW* NPLOGFONTW;
typedef LOGFONTW* LPLOGFONTW;

version(UNICODE) {
	typedef LOGFONTW LOGFONT;
	typedef PLOGFONTW PLOGFONT;
	typedef NPLOGFONTW NPLOGFONT;
	typedef LPLOGFONTW LPLOGFONT;
}
else {
	typedef LOGFONTA LOGFONT;
	typedef PLOGFONTA PLOGFONT;
	typedef NPLOGFONTA NPLOGFONT;
	typedef LPLOGFONTA LPLOGFONT;
}

const auto LF_FULLFACESIZE     = 64;

/* Structure passed to FONTENUMPROC */
struct ENUMLOGFONTA {
    LOGFONTA elfLogFont;
    BYTE     elfFullName[LF_FULLFACESIZE];
    BYTE     elfStyle[LF_FACESIZE];
}

typedef ENUMLOGFONTA* LPENUMLOGFONTA;

/* Structure passed to FONTENUMPROC */
struct ENUMLOGFONTW {
    LOGFONTW elfLogFont;
    WCHAR[LF_FULLFACESIZE]    elfFullName;
    WCHAR[LF_FACESIZE]    elfStyle;
}

typedef ENUMLOGFONTW* LPENUMLOGFONTW;

version(UNICODE) {
	typedef ENUMLOGFONTW ENUMLOGFONT;
	typedef LPENUMLOGFONTW LPENUMLOGFONT;
}
else {
	typedef ENUMLOGFONTA ENUMLOGFONT;
	typedef LPENUMLOGFONTA LPENUMLOGFONT;
}

struct ENUMLOGFONTEXA {
    LOGFONTA    elfLogFont;
    BYTE        elfFullName[LF_FULLFACESIZE];
    BYTE        elfStyle[LF_FACESIZE];
    BYTE        elfScript[LF_FACESIZE];
}

typedef ENUMLOGFONTEXA* LPENUMLOGFONTEXA;

struct ENUMLOGFONTEXW {
    LOGFONTW    elfLogFont;
    WCHAR[LF_FULLFACESIZE]       elfFullName;
    WCHAR[LF_FACESIZE]       elfStyle;
    WCHAR[LF_FACESIZE]       elfScript;
}

typedef ENUMLOGFONTEXW* LPENUMLOGFONTEXW;

version(UNICODE) {
	typedef ENUMLOGFONTEXW ENUMLOGFONTEX;
	typedef LPENUMLOGFONTEXW LPENUMLOGFONTEX;
}
else {
	typedef ENUMLOGFONTEXA ENUMLOGFONTEX;
	typedef LPENUMLOGFONTEXA LPENUMLOGFONTEX;
}

const auto OUT_DEFAULT_PRECIS          = 0;
const auto OUT_STRING_PRECIS           = 1;
const auto OUT_CHARACTER_PRECIS        = 2;
const auto OUT_STROKE_PRECIS           = 3;
const auto OUT_TT_PRECIS               = 4;
const auto OUT_DEVICE_PRECIS           = 5;
const auto OUT_RASTER_PRECIS           = 6;
const auto OUT_TT_ONLY_PRECIS          = 7;
const auto OUT_OUTLINE_PRECIS          = 8;
const auto OUT_SCREEN_OUTLINE_PRECIS   = 9;
const auto OUT_PS_ONLY_PRECIS          = 10;

const auto CLIP_DEFAULT_PRECIS     = 0;
const auto CLIP_CHARACTER_PRECIS   = 1;
const auto CLIP_STROKE_PRECIS      = 2;
const auto CLIP_MASK               = 0xf;
const auto CLIP_LH_ANGLES          = (1<<4);
const auto CLIP_TT_ALWAYS          = (2<<4);

const auto CLIP_DFA_DISABLE        = (4<<4);

const auto CLIP_EMBEDDED           = (8<<4);

const auto DEFAULT_QUALITY         = 0;
const auto DRAFT_QUALITY           = 1;
const auto PROOF_QUALITY           = 2;

const auto NONANTIALIASED_QUALITY  = 3;
const auto ANTIALIASED_QUALITY     = 4;

const auto CLEARTYPE_QUALITY         = 5;
const auto CLEARTYPE_NATURAL_QUALITY       = 6;

const auto DEFAULT_PITCH           = 0;
const auto FIXED_PITCH             = 1;
const auto VARIABLE_PITCH          = 2;

const auto MONO_FONT               = 8;

const auto ANSI_CHARSET            = 0;
const auto DEFAULT_CHARSET         = 1;
const auto SYMBOL_CHARSET          = 2;
const auto SHIFTJIS_CHARSET        = 128;
const auto HANGEUL_CHARSET         = 129;
const auto HANGUL_CHARSET          = 129;
const auto GB2312_CHARSET          = 134;
const auto CHINESEBIG5_CHARSET     = 136;
const auto OEM_CHARSET             = 255;

const auto JOHAB_CHARSET           = 130;
const auto HEBREW_CHARSET          = 177;
const auto ARABIC_CHARSET          = 178;
const auto GREEK_CHARSET           = 161;
const auto TURKISH_CHARSET         = 162;
const auto VIETNAMESE_CHARSET      = 163;
const auto THAI_CHARSET            = 222;
const auto EASTEUROPE_CHARSET      = 238;
const auto RUSSIAN_CHARSET         = 204;

const auto MAC_CHARSET             = 77;
const auto BALTIC_CHARSET          = 186;

const auto FS_LATIN1               = 0x00000001;
const auto FS_LATIN2               = 0x00000002;
const auto FS_CYRILLIC             = 0x00000004;
const auto FS_GREEK                = 0x00000008;
const auto FS_TURKISH              = 0x00000010;
const auto FS_HEBREW               = 0x00000020;
const auto FS_ARABIC               = 0x00000040;
const auto FS_BALTIC               = 0x00000080;
const auto FS_VIETNAMESE           = 0x00000100;
const auto FS_THAI                 = 0x00010000;
const auto FS_JISJAPAN             = 0x00020000;
const auto FS_CHINESESIMP          = 0x00040000;
const auto FS_WANSUNG              = 0x00080000;
const auto FS_CHINESETRAD          = 0x00100000;
const auto FS_JOHAB                = 0x00200000;
const auto FS_SYMBOL               = 0x80000000;

/* Font Families */
const auto FF_DONTCARE         = (0<<4);  /* Don't care or don't know. */
const auto FF_ROMAN            = (1<<4);  /* Variable stroke width, serifed. */
                                    /* Times Roman, Century Schoolbook, etc. */
const auto FF_SWISS            = (2<<4);  /* Variable stroke width, sans-serifed. */
                                    /* Helvetica, Swiss, etc. */
const auto FF_MODERN           = (3<<4);  /* Constant stroke width, serifed or sans-serifed. */
                                    /* Pica, Elite, Courier, etc. */
const auto FF_SCRIPT           = (4<<4);  /* Cursive, etc. */
const auto FF_DECORATIVE       = (5<<4);  /* Old English, etc. */

/* Font Weights */
const auto FW_DONTCARE         = 0;
const auto FW_THIN             = 100;
const auto FW_EXTRALIGHT       = 200;
const auto FW_LIGHT            = 300;
const auto FW_NORMAL           = 400;
const auto FW_MEDIUM           = 500;
const auto FW_SEMIBOLD         = 600;
const auto FW_BOLD             = 700;
const auto FW_EXTRABOLD        = 800;
const auto FW_HEAVY            = 900;

const auto FW_ULTRALIGHT       = FW_EXTRALIGHT;
const auto FW_REGULAR          = FW_NORMAL;
const auto FW_DEMIBOLD         = FW_SEMIBOLD;
const auto FW_ULTRABOLD        = FW_EXTRABOLD;
const auto FW_BLACK            = FW_HEAVY;

const auto PANOSE_COUNT               = 10;
const auto PAN_FAMILYTYPE_INDEX        = 0;
const auto PAN_SERIFSTYLE_INDEX        = 1;
const auto PAN_WEIGHT_INDEX            = 2;
const auto PAN_PROPORTION_INDEX        = 3;
const auto PAN_CONTRAST_INDEX          = 4;
const auto PAN_STROKEVARIATION_INDEX   = 5;
const auto PAN_ARMSTYLE_INDEX          = 6;
const auto PAN_LETTERFORM_INDEX        = 7;
const auto PAN_MIDLINE_INDEX           = 8;
const auto PAN_XHEIGHT_INDEX           = 9;

const auto PAN_CULTURE_LATIN           = 0;

struct PANOSE {
	BYTE    bFamilyType;
	BYTE    bSerifStyle;
	BYTE    bWeight;
	BYTE    bProportion;
	BYTE    bContrast;
	BYTE    bStrokeVariation;
	BYTE    bArmStyle;
	BYTE    bLetterform;
	BYTE    bMidline;
	BYTE    bXHeight;
}

typedef PANOSE* LPPANOSE;

const auto PAN_ANY                         = 0; /* Any                            */
const auto PAN_NO_FIT                      = 1; /* No Fit                         */

const auto PAN_FAMILY_TEXT_DISPLAY         = 2; /* Text and Display               */
const auto PAN_FAMILY_SCRIPT               = 3; /* Script                         */
const auto PAN_FAMILY_DECORATIVE           = 4; /* Decorative                     */
const auto PAN_FAMILY_PICTORIAL            = 5; /* Pictorial                      */

const auto PAN_SERIF_COVE                  = 2; /* Cove                           */
const auto PAN_SERIF_OBTUSE_COVE           = 3; /* Obtuse Cove                    */
const auto PAN_SERIF_SQUARE_COVE           = 4; /* Square Cove                    */
const auto PAN_SERIF_OBTUSE_SQUARE_COVE    = 5; /* Obtuse Square Cove             */
const auto PAN_SERIF_SQUARE                = 6; /* Square                         */
const auto PAN_SERIF_THIN                  = 7; /* Thin                           */
const auto PAN_SERIF_BONE                  = 8; /* Bone                           */
const auto PAN_SERIF_EXAGGERATED           = 9; /* Exaggerated                    */
const auto PAN_SERIF_TRIANGLE             = 10; /* Triangle                       */
const auto PAN_SERIF_NORMAL_SANS          = 11; /* Normal Sans                    */
const auto PAN_SERIF_OBTUSE_SANS          = 12; /* Obtuse Sans                    */
const auto PAN_SERIF_PERP_SANS            = 13; /* Prep Sans                      */
const auto PAN_SERIF_FLARED               = 14; /* Flared                         */
const auto PAN_SERIF_ROUNDED              = 15; /* Rounded                        */

const auto PAN_WEIGHT_VERY_LIGHT           = 2; /* Very Light                     */
const auto PAN_WEIGHT_LIGHT                = 3; /* Light                          */
const auto PAN_WEIGHT_THIN                 = 4; /* Thin                           */
const auto PAN_WEIGHT_BOOK                 = 5; /* Book                           */
const auto PAN_WEIGHT_MEDIUM               = 6; /* Medium                         */
const auto PAN_WEIGHT_DEMI                 = 7; /* Demi                           */
const auto PAN_WEIGHT_BOLD                 = 8; /* Bold                           */
const auto PAN_WEIGHT_HEAVY                = 9; /* Heavy                          */
const auto PAN_WEIGHT_BLACK               = 10; /* Black                          */
const auto PAN_WEIGHT_NORD                = 11; /* Nord                           */

const auto PAN_PROP_OLD_STYLE              = 2; /* Old Style                      */
const auto PAN_PROP_MODERN                 = 3; /* Modern                         */
const auto PAN_PROP_EVEN_WIDTH             = 4; /* Even Width                     */
const auto PAN_PROP_EXPANDED               = 5; /* Expanded                       */
const auto PAN_PROP_CONDENSED              = 6; /* Condensed                      */
const auto PAN_PROP_VERY_EXPANDED          = 7; /* Very Expanded                  */
const auto PAN_PROP_VERY_CONDENSED         = 8; /* Very Condensed                 */
const auto PAN_PROP_MONOSPACED             = 9; /* Monospaced                     */

const auto PAN_CONTRAST_NONE               = 2; /* None                           */
const auto PAN_CONTRAST_VERY_LOW           = 3; /* Very Low                       */
const auto PAN_CONTRAST_LOW                = 4; /* Low                            */
const auto PAN_CONTRAST_MEDIUM_LOW         = 5; /* Medium Low                     */
const auto PAN_CONTRAST_MEDIUM             = 6; /* Medium                         */
const auto PAN_CONTRAST_MEDIUM_HIGH        = 7; /* Mediim High                    */
const auto PAN_CONTRAST_HIGH               = 8; /* High                           */
const auto PAN_CONTRAST_VERY_HIGH          = 9; /* Very High                      */

const auto PAN_STROKE_GRADUAL_DIAG         = 2; /* Gradual/Diagonal               */
const auto PAN_STROKE_GRADUAL_TRAN         = 3; /* Gradual/Transitional           */
const auto PAN_STROKE_GRADUAL_VERT         = 4; /* Gradual/Vertical               */
const auto PAN_STROKE_GRADUAL_HORZ         = 5; /* Gradual/Horizontal             */
const auto PAN_STROKE_RAPID_VERT           = 6; /* Rapid/Vertical                 */
const auto PAN_STROKE_RAPID_HORZ           = 7; /* Rapid/Horizontal               */
const auto PAN_STROKE_INSTANT_VERT         = 8; /* Instant/Vertical               */

const auto PAN_STRAIGHT_ARMS_HORZ          = 2; /* Straight Arms/Horizontal       */
const auto PAN_STRAIGHT_ARMS_WEDGE         = 3; /* Straight Arms/Wedge            */
const auto PAN_STRAIGHT_ARMS_VERT          = 4; /* Straight Arms/Vertical         */
const auto PAN_STRAIGHT_ARMS_SINGLE_SERIF  = 5; /* Straight Arms/Single-Serif     */
const auto PAN_STRAIGHT_ARMS_DOUBLE_SERIF  = 6; /* Straight Arms/Double-Serif     */
const auto PAN_BENT_ARMS_HORZ              = 7; /* Non-Straight Arms/Horizontal   */
const auto PAN_BENT_ARMS_WEDGE             = 8; /* Non-Straight Arms/Wedge        */
const auto PAN_BENT_ARMS_VERT              = 9; /* Non-Straight Arms/Vertical     */
const auto PAN_BENT_ARMS_SINGLE_SERIF     = 10; /* Non-Straight Arms/Single-Serif */
const auto PAN_BENT_ARMS_DOUBLE_SERIF     = 11; /* Non-Straight Arms/Double-Serif */

const auto PAN_LETT_NORMAL_CONTACT         = 2; /* Normal/Contact                 */
const auto PAN_LETT_NORMAL_WEIGHTED        = 3; /* Normal/Weighted                */
const auto PAN_LETT_NORMAL_BOXED           = 4; /* Normal/Boxed                   */
const auto PAN_LETT_NORMAL_FLATTENED       = 5; /* Normal/Flattened               */
const auto PAN_LETT_NORMAL_ROUNDED         = 6; /* Normal/Rounded                 */
const auto PAN_LETT_NORMAL_OFF_CENTER      = 7; /* Normal/Off Center              */
const auto PAN_LETT_NORMAL_SQUARE          = 8; /* Normal/Square                  */
const auto PAN_LETT_OBLIQUE_CONTACT        = 9; /* Oblique/Contact                */
const auto PAN_LETT_OBLIQUE_WEIGHTED      = 10; /* Oblique/Weighted               */
const auto PAN_LETT_OBLIQUE_BOXED         = 11; /* Oblique/Boxed                  */
const auto PAN_LETT_OBLIQUE_FLATTENED     = 12; /* Oblique/Flattened              */
const auto PAN_LETT_OBLIQUE_ROUNDED       = 13; /* Oblique/Rounded                */
const auto PAN_LETT_OBLIQUE_OFF_CENTER    = 14; /* Oblique/Off Center             */
const auto PAN_LETT_OBLIQUE_SQUARE        = 15; /* Oblique/Square                 */

const auto PAN_MIDLINE_STANDARD_TRIMMED    = 2; /* Standard/Trimmed               */
const auto PAN_MIDLINE_STANDARD_POINTED    = 3; /* Standard/Pointed               */
const auto PAN_MIDLINE_STANDARD_SERIFED    = 4; /* Standard/Serifed               */
const auto PAN_MIDLINE_HIGH_TRIMMED        = 5; /* High/Trimmed                   */
const auto PAN_MIDLINE_HIGH_POINTED        = 6; /* High/Pointed                   */
const auto PAN_MIDLINE_HIGH_SERIFED        = 7; /* High/Serifed                   */
const auto PAN_MIDLINE_CONSTANT_TRIMMED    = 8; /* Constant/Trimmed               */
const auto PAN_MIDLINE_CONSTANT_POINTED    = 9; /* Constant/Pointed               */
const auto PAN_MIDLINE_CONSTANT_SERIFED   = 10; /* Constant/Serifed               */
const auto PAN_MIDLINE_LOW_TRIMMED        = 11; /* Low/Trimmed                    */
const auto PAN_MIDLINE_LOW_POINTED        = 12; /* Low/Pointed                    */
const auto PAN_MIDLINE_LOW_SERIFED        = 13; /* Low/Serifed                    */

const auto PAN_XHEIGHT_CONSTANT_SMALL      = 2; /* Constant/Small                 */
const auto PAN_XHEIGHT_CONSTANT_STD        = 3; /* Constant/Standard              */
const auto PAN_XHEIGHT_CONSTANT_LARGE      = 4; /* Constant/Large                 */
const auto PAN_XHEIGHT_DUCKING_SMALL       = 5; /* Ducking/Small                  */
const auto PAN_XHEIGHT_DUCKING_STD         = 6; /* Ducking/Standard               */
const auto PAN_XHEIGHT_DUCKING_LARGE       = 7; /* Ducking/Large                  */


const auto ELF_VENDOR_SIZE     = 4;

/* The extended logical font       */
/* An extension of the ENUMLOGFONT */

struct EXTLOGFONTA {
    LOGFONTA    elfLogFont;
    BYTE        elfFullName[LF_FULLFACESIZE];
    BYTE        elfStyle[LF_FACESIZE];
    DWORD       elfVersion;     /* 0 for the first release of NT */
    DWORD       elfStyleSize;
    DWORD       elfMatch;
    DWORD       elfReserved;
    BYTE        elfVendorId[ELF_VENDOR_SIZE];
    DWORD       elfCulture;     /* 0 for Latin                   */
    PANOSE      elfPanose;
}

typedef EXTLOGFONTA* PEXTLOGFONTA;
typedef EXTLOGFONTA* NPEXTLOGFONTA;
typedef EXTLOGFONTA* LPEXTLOGFONTA;

struct EXTLOGFONTW {
    LOGFONTW    elfLogFont;
    WCHAR       elfFullName[LF_FULLFACESIZE];
    WCHAR       elfStyle[LF_FACESIZE];
    DWORD       elfVersion;     /* 0 for the first release of NT */
    DWORD       elfStyleSize;
    DWORD       elfMatch;
    DWORD       elfReserved;
    BYTE        elfVendorId[ELF_VENDOR_SIZE];
    DWORD       elfCulture;     /* 0 for Latin                   */
    PANOSE      elfPanose;
}

typedef EXTLOGFONTW* PEXTLOGFONTW;
typedef EXTLOGFONTW* NPEXTLOGFONTW;
typedef EXTLOGFONTW* LPEXTLOGFONTW;

version(UNICODE) {
	typedef EXTLOGFONTW EXTLOGFONT;
	typedef PEXTLOGFONTW PEXTLOGFONT;
	typedef NPEXTLOGFONTW NPEXTLOGFONT;
	typedef LPEXTLOGFONTW LPEXTLOGFONT;
}
else {
	typedef EXTLOGFONTA EXTLOGFONT;
	typedef PEXTLOGFONTA PEXTLOGFONT;
	typedef NPEXTLOGFONTA NPEXTLOGFONT;
	typedef LPEXTLOGFONTA LPEXTLOGFONT;
}

const auto ELF_VERSION         = 0;
const auto ELF_CULTURE_LATIN   = 0;

/* EnumFonts Masks */
const auto RASTER_FONTTYPE     = 0x0001;
const auto DEVICE_FONTTYPE     = 0x002;
const auto TRUETYPE_FONTTYPE   = 0x004;

template RGB(BYTE r, BYTE g, BYTE b) {
	const COLORREF RGB = (cast(COLORREF)((cast(BYTE)(r)|(cast(WORD)(cast(BYTE)(g))<<8))|((cast(DWORD)cast(BYTE)(b))<<16)));
}

template PALETTERGB(BYTE r, BYTE g, BYTE b) {
	const uint PALETTERGB = (0x2000000 | RGB!(r,g,b));
}

template PALETTEINDEX(BYTE i) {
	const uint PALETTEINDEX = (cast(COLORREF)(0x01000000 | cast(DWORD)cast(WORD)(i)));
}

/* palette entry flags */

const auto PC_RESERVED     = 0x01;    /* palette index used for animation */
const auto PC_EXPLICIT     = 0x02;    /* palette index is explicit to device */
const auto PC_NOCOLLAPSE   = 0x04;    /* do not match color to system palette */

BYTE GetRValue(COLORREF rgb) {
	return LOBYTE(cast(WORD)rgb);
}

BYTE GetGValue(COLORREF rgb) {
	return LOBYTE(cast(WORD)((cast(WORD)rgb) >> 8));
}

BYTE GetBValue(COLORREF rgb) {
	return LOBYTE(cast(WORD)(rgb >> 16));
}

/* Background Modes */
const auto TRANSPARENT         = 1;
const auto OPAQUE              = 2;
const auto BKMODE_LAST         = 2;

/* Graphics Modes */

const auto GM_COMPATIBLE       = 1;
const auto GM_ADVANCED         = 2;
const auto GM_LAST             = 2;

/* PolyDraw and GetPath point types */
const auto PT_CLOSEFIGURE      = 0x01;
const auto PT_LINETO           = 0x02;
const auto PT_BEZIERTO         = 0x04;
const auto PT_MOVETO           = 0x06;

/* Mapping Modes */
const auto MM_TEXT             = 1;
const auto MM_LOMETRIC         = 2;
const auto MM_HIMETRIC         = 3;
const auto MM_LOENGLISH        = 4;
const auto MM_HIENGLISH        = 5;
const auto MM_TWIPS            = 6;
const auto MM_ISOTROPIC        = 7;
const auto MM_ANISOTROPIC      = 8;

/* Min and Max Mapping Mode values */
const auto MM_MIN              = MM_TEXT;
const auto MM_MAX              = MM_ANISOTROPIC;
const auto MM_MAX_FIXEDSCALE   = MM_TWIPS;

/* Coordinate Modes */
const auto ABSOLUTE            = 1;
const auto RELATIVE            = 2;

/* Stock Logical Objects */
const auto WHITE_BRUSH         = 0;
const auto LTGRAY_BRUSH        = 1;
const auto GRAY_BRUSH          = 2;
const auto DKGRAY_BRUSH        = 3;
const auto BLACK_BRUSH         = 4;
const auto NULL_BRUSH          = 5;
const auto HOLLOW_BRUSH        = NULL_BRUSH;
const auto WHITE_PEN           = 6;
const auto BLACK_PEN           = 7;
const auto NULL_PEN            = 8;
const auto OEM_FIXED_FONT      = 10;
const auto ANSI_FIXED_FONT     = 11;
const auto ANSI_VAR_FONT       = 12;
const auto SYSTEM_FONT         = 13;
const auto DEVICE_DEFAULT_FONT = 14;
const auto DEFAULT_PALETTE     = 15;
const auto SYSTEM_FIXED_FONT   = 16;

const auto DEFAULT_GUI_FONT    = 17;

const auto DC_BRUSH            = 18;
const auto DC_PEN              = 19;

const auto STOCK_LAST          = 19;

const auto CLR_INVALID     = 0xFFFFFFFF;

/* Brush Styles */
const auto BS_SOLID            = 0;
const auto BS_NULL             = 1;
const auto BS_HOLLOW           = BS_NULL;
const auto BS_HATCHED          = 2;
const auto BS_PATTERN          = 3;
const auto BS_INDEXED          = 4;
const auto BS_DIBPATTERN       = 5;
const auto BS_DIBPATTERNPT     = 6;
const auto BS_PATTERN8X8       = 7;
const auto BS_DIBPATTERN8X8    = 8;
const auto BS_MONOPATTERN      = 9;

/* Hatch Styles */
const auto HS_HORIZONTAL       = 0;       /* ----- */
const auto HS_VERTICAL         = 1;       /* ||||| */
const auto HS_FDIAGONAL        = 2;       /* \\\\\ */
const auto HS_BDIAGONAL        = 3;       /* ///// */
const auto HS_CROSS            = 4;       /* +++++ */
const auto HS_DIAGCROSS        = 5;       /* xxxxx */

/* Pen Styles */
const auto PS_SOLID            = 0;
const auto PS_DASH             = 1;       /* -------  */
const auto PS_DOT              = 2;       /* .......  */
const auto PS_DASHDOT          = 3;       /* _._._._  */
const auto PS_DASHDOTDOT       = 4;       /* _.._.._  */
const auto PS_NULL             = 5;
const auto PS_INSIDEFRAME      = 6;
const auto PS_USERSTYLE        = 7;
const auto PS_ALTERNATE        = 8;
const auto PS_STYLE_MASK       = 0x0000000F;

const auto PS_ENDCAP_ROUND     = 0x00000000;
const auto PS_ENDCAP_SQUARE    = 0x00000100;
const auto PS_ENDCAP_FLAT      = 0x00000200;
const auto PS_ENDCAP_MASK      = 0x00000F00;

const auto PS_JOIN_ROUND       = 0x00000000;
const auto PS_JOIN_BEVEL       = 0x00001000;
const auto PS_JOIN_MITER       = 0x00002000;
const auto PS_JOIN_MASK        = 0x0000F000;

const auto PS_COSMETIC         = 0x00000000;
const auto PS_GEOMETRIC        = 0x00010000;
const auto PS_TYPE_MASK        = 0x000F0000;

const auto AD_COUNTERCLOCKWISE = 1;
const auto AD_CLOCKWISE        = 2;

/* Device Parameters for GetDeviceCaps() */
const auto DRIVERVERSION = 0;     /* Device driver version                    */
const auto TECHNOLOGY    = 2;     /* Device classification                    */
const auto HORZSIZE      = 4;     /* Horizontal size in millimeters           */
const auto VERTSIZE      = 6;     /* Vertical size in millimeters             */
const auto HORZRES       = 8;     /* Horizontal width in pixels               */
const auto VERTRES       = 10;    /* Vertical height in pixels                */
const auto BITSPIXEL     = 12;    /* Number of bits per pixel                 */
const auto PLANES        = 14;    /* Number of planes                         */
const auto NUMBRUSHES    = 16;    /* Number of brushes the device has         */
const auto NUMPENS       = 18;    /* Number of pens the device has            */
const auto NUMMARKERS    = 20;    /* Number of markers the device has         */
const auto NUMFONTS      = 22;    /* Number of fonts the device has           */
const auto NUMCOLORS     = 24;    /* Number of colors the device supports     */
const auto PDEVICESIZE   = 26;    /* Size required for device descriptor      */
const auto CURVECAPS     = 28;    /* Curve capabilities                       */
const auto LINECAPS      = 30;    /* Line capabilities                        */
const auto POLYGONALCAPS = 32;    /* Polygonal capabilities                   */
const auto TEXTCAPS      = 34;    /* Text capabilities                        */
const auto CLIPCAPS      = 36;    /* Clipping capabilities                    */
const auto RASTERCAPS    = 38;    /* Bitblt capabilities                      */
const auto ASPECTX       = 40;    /* Length of the X leg                      */
const auto ASPECTY       = 42;    /* Length of the Y leg                      */
const auto ASPECTXY      = 44;    /* Length of the hypotenuse                 */

const auto LOGPIXELSX    = 88;    /* Logical pixels/inch in X                 */
const auto LOGPIXELSY    = 90;    /* Logical pixels/inch in Y                 */

const auto SIZEPALETTE  = 104;    /* Number of entries in physical palette    */
const auto NUMRESERVED  = 106;    /* Number of reserved entries in palette    */
const auto COLORRES     = 108;    /* Actual color resolution                  */

// Printing related DeviceCaps. These replace the appropriate Escapes

const auto PHYSICALWIDTH   = 110; /* Physical Width in device units           */
const auto PHYSICALHEIGHT  = 111; /* Physical Height in device units          */
const auto PHYSICALOFFSETX = 112; /* Physical Printable Area x margin         */
const auto PHYSICALOFFSETY = 113; /* Physical Printable Area y margin         */
const auto SCALINGFACTORX  = 114; /* Scaling factor x                         */
const auto SCALINGFACTORY  = 115; /* Scaling factor y                         */

// Display driver specific

const auto VREFRESH        = 116;  /* Current vertical refresh rate of the    */
                             /* display device (for displays only) in Hz*/
const auto DESKTOPVERTRES  = 117;  /* Horizontal width of entire desktop in   */
                             /* pixels                                  */
const auto DESKTOPHORZRES  = 118;  /* Vertical height of entire desktop in    */
                             /* pixels                                  */
const auto BLTALIGNMENT    = 119;  /* Preferred blt alignment                 */

const auto SHADEBLENDCAPS  = 120;  /* Shading and blending caps               */
const auto COLORMGMTCAPS   = 121;  /* Color Management caps                   */

/* Device Capability Masks: */

/* Device Technologies */
const auto DT_PLOTTER          = 0;   /* Vector plotter                   */
const auto DT_RASDISPLAY       = 1;   /* Raster display                   */
const auto DT_RASPRINTER       = 2;   /* Raster printer                   */
const auto DT_RASCAMERA        = 3;   /* Raster camera                    */
const auto DT_CHARSTREAM       = 4;   /* Character-stream, PLP            */
const auto DT_METAFILE         = 5;   /* Metafile, VDM                    */
const auto DT_DISPFILE         = 6;   /* Display-file                     */

/* Curve Capabilities */
const auto CC_NONE             = 0;   /* Curves not supported             */
const auto CC_CIRCLES          = 1;   /* Can do circles                   */
const auto CC_PIE              = 2;   /* Can do pie wedges                */
const auto CC_CHORD            = 4;   /* Can do chord arcs                */
const auto CC_ELLIPSES         = 8;   /* Can do ellipese                  */
const auto CC_WIDE             = 16;  /* Can do wide lines                */
const auto CC_STYLED           = 32;  /* Can do styled lines              */
const auto CC_WIDESTYLED       = 64;  /* Can do wide styled lines         */
const auto CC_INTERIORS        = 128; /* Can do interiors                 */
const auto CC_ROUNDRECT        = 256; /*                                  */

/* Line Capabilities */
const auto LC_NONE             = 0;   /* Lines not supported              */
const auto LC_POLYLINE         = 2;   /* Can do polylines                 */
const auto LC_MARKER           = 4;   /* Can do markers                   */
const auto LC_POLYMARKER       = 8;   /* Can do polymarkers               */
const auto LC_WIDE             = 16;  /* Can do wide lines                */
const auto LC_STYLED           = 32;  /* Can do styled lines              */
const auto LC_WIDESTYLED       = 64;  /* Can do wide styled lines         */
const auto LC_INTERIORS        = 128; /* Can do interiors                 */

/* Polygonal Capabilities */
const auto PC_NONE             = 0;   /* Polygonals not supported         */
const auto PC_POLYGON          = 1;   /* Can do polygons                  */
const auto PC_RECTANGLE        = 2;   /* Can do rectangles                */
const auto PC_WINDPOLYGON      = 4;   /* Can do winding polygons          */
const auto PC_TRAPEZOID        = 4;   /* Can do trapezoids                */
const auto PC_SCANLINE         = 8;   /* Can do scanlines                 */
const auto PC_WIDE             = 16;  /* Can do wide borders              */
const auto PC_STYLED           = 32;  /* Can do styled borders            */
const auto PC_WIDESTYLED       = 64;  /* Can do wide styled borders       */
const auto PC_INTERIORS        = 128; /* Can do interiors                 */
const auto PC_POLYPOLYGON      = 256; /* Can do polypolygons              */
const auto PC_PATHS            = 512; /* Can do paths                     */

/* Clipping Capabilities */
const auto CP_NONE             = 0;   /* No clipping of output            */
const auto CP_RECTANGLE        = 1;   /* Output clipped to rects          */
const auto CP_REGION           = 2;   /* obsolete                         */

/* Text Capabilities */
const auto TC_OP_CHARACTER     = 0x00000001;  /* Can do OutputPrecision   CHARACTER      */
const auto TC_OP_STROKE        = 0x00000002;  /* Can do OutputPrecision   STROKE         */
const auto TC_CP_STROKE        = 0x00000004;  /* Can do ClipPrecision     STROKE         */
const auto TC_CR_90            = 0x00000008;  /* Can do CharRotAbility    90             */
const auto TC_CR_ANY           = 0x00000010;  /* Can do CharRotAbility    ANY            */
const auto TC_SF_X_YINDEP      = 0x00000020;  /* Can do ScaleFreedom      X_YINDEPENDENT */
const auto TC_SA_DOUBLE        = 0x00000040;  /* Can do ScaleAbility      DOUBLE         */
const auto TC_SA_INTEGER       = 0x00000080;  /* Can do ScaleAbility      INTEGER        */
const auto TC_SA_CONTIN        = 0x00000100;  /* Can do ScaleAbility      CONTINUOUS     */
const auto TC_EA_DOUBLE        = 0x00000200;  /* Can do EmboldenAbility   DOUBLE         */
const auto TC_IA_ABLE          = 0x00000400;  /* Can do ItalisizeAbility  ABLE           */
const auto TC_UA_ABLE          = 0x00000800;  /* Can do UnderlineAbility  ABLE           */
const auto TC_SO_ABLE          = 0x00001000;  /* Can do StrikeOutAbility  ABLE           */
const auto TC_RA_ABLE          = 0x00002000;  /* Can do RasterFontAble    ABLE           */
const auto TC_VA_ABLE          = 0x00004000;  /* Can do VectorFontAble    ABLE           */
const auto TC_RESERVED         = 0x00008000;
const auto TC_SCROLLBLT        = 0x00010000;  /* Don't do text scroll with blt           */

/* Raster Capabilities */
const auto RC_NONE = 0;
const auto RC_BITBLT           = 1;       /* Can do standard BLT.             */
const auto RC_BANDING          = 2;       /* Device requires banding support  */
const auto RC_SCALING          = 4;       /* Device requires scaling support  */
const auto RC_BITMAP64         = 8;       /* Device can support >64K bitmap   */
const auto RC_GDI20_OUTPUT     = 0x0010;      /* has 2.0 output calls         */
const auto RC_GDI20_STATE      = 0x0020;
const auto RC_SAVEBITMAP       = 0x0040;
const auto RC_DI_BITMAP        = 0x0080;      /* supports DIB to memory       */
const auto RC_PALETTE          = 0x0100;      /* supports a palette           */
const auto RC_DIBTODEV         = 0x0200;      /* supports DIBitsToDevice      */
const auto RC_BIGFONT          = 0x0400;      /* supports >64K fonts          */
const auto RC_STRETCHBLT       = 0x0800;      /* supports StretchBlt          */
const auto RC_FLOODFILL        = 0x1000;      /* supports FloodFill           */
const auto RC_STRETCHDIB       = 0x2000;      /* supports StretchDIBits       */
const auto RC_OP_DX_OUTPUT     = 0x4000;
const auto RC_DEVBITS          = 0x8000;

/* Shading and blending caps */
const auto SB_NONE             = 0x00000000;
const auto SB_CONST_ALPHA      = 0x00000001;
const auto SB_PIXEL_ALPHA      = 0x00000002;
const auto SB_PREMULT_ALPHA    = 0x00000004;

const auto SB_GRAD_RECT        = 0x00000010;
const auto SB_GRAD_TRI         = 0x00000020;

/* Color Management caps */
const auto CM_NONE             = 0x00000000;
const auto CM_DEVICE_ICM       = 0x00000001;
const auto CM_GAMMA_RAMP       = 0x00000002;
const auto CM_CMYK_COLOR       = 0x00000004;

/* DIB color table identifiers */

const auto DIB_RGB_COLORS      = 0; /* color table in RGBs */
const auto DIB_PAL_COLORS      = 1; /* color table in palette indices */

/* constants for Get/SetSystemPaletteUse() */

const auto SYSPAL_ERROR    		= 0;
const auto SYSPAL_STATIC   		= 1;
const auto SYSPAL_NOSTATIC 		= 2;
const auto SYSPAL_NOSTATIC256	= 3;

/* constants for CreateDIBitmap */
const auto CBM_INIT        = 0x04;   /* initialize bitmap */

/* ExtFloodFill style flags */
const auto  FLOODFILLBORDER   = 0;
const auto  FLOODFILLSURFACE  = 1;

/* size of a device name string */
// import winuser.d:
//const auto CCHDEVICENAME = 32;

/* size of a form name string */
const auto CCHFORMNAME = 32;

struct DEVMODEA {
    BYTE[CCHDEVICENAME]   dmDeviceName;
    WORD dmSpecVersion;
    WORD dmDriverVersion;
    WORD dmSize;
    WORD dmDriverExtra;
    DWORD dmFields;
    union _inner_union {
      /* printer only fields */
      struct _dm_printer {
        short dmOrientation;
        short dmPaperSize;
        short dmPaperLength;
        short dmPaperWidth;
        short dmScale;
        short dmCopies;
        short dmDefaultSource;
        short dmPrintQuality;
      }
      /* display only fields */
      struct _dm_display {
        POINTL dmPosition;
        DWORD  dmDisplayOrientation;
        DWORD  dmDisplayFixedOutput;
      }
      
      _dm_printer printer;
      _dm_display display;
    }
    _inner_union fields;
    short dmColor;
    short dmDuplex;
    short dmYResolution;
    short dmTTOption;
    short dmCollate;
    BYTE   dmFormName[CCHFORMNAME];
    WORD   dmLogPixels;
    DWORD  dmBitsPerPel;
    DWORD  dmPelsWidth;
    DWORD  dmPelsHeight;
    DWORD  dmDisplayFlags;
    DWORD  dmDisplayFrequency;
    DWORD  dmICMMethod;
    DWORD  dmICMIntent;
    DWORD  dmMediaType;
    DWORD  dmDitherType;
    DWORD  dmReserved1;
    DWORD  dmReserved2;
    DWORD  dmPanningWidth;
    DWORD  dmPanningHeight;
}

typedef DEVMODEA* PDEVMODEA;
typedef DEVMODEA* NPDEVMODEA;
typedef DEVMODEA* LPDEVMODEA;

struct DEVMODEW {
    WCHAR[CCHDEVICENAME]  dmDeviceName;
    WORD dmSpecVersion;
    WORD dmDriverVersion;
    WORD dmSize;
    WORD dmDriverExtra;
    DWORD dmFields;

	union _inner_union {
      /* printer only fields */
      struct _dm_printer {
        short dmOrientation;
        short dmPaperSize;
        short dmPaperLength;
        short dmPaperWidth;
        short dmScale;
        short dmCopies;
        short dmDefaultSource;
        short dmPrintQuality;
      }

      /* display only fields */
      struct _dm_display {
        POINTL dmPosition;
        DWORD  dmDisplayOrientation;
        DWORD  dmDisplayFixedOutput;
      }

      _dm_printer printer;
      _dm_display display;
    }

    _inner_union fields;
    short dmColor;
    short dmDuplex;
    short dmYResolution;
    short dmTTOption;
    short dmCollate;
    WCHAR  dmFormName[CCHFORMNAME];
    WORD   dmLogPixels;
    DWORD  dmBitsPerPel;
    DWORD  dmPelsWidth;
    DWORD  dmPelsHeight;
    DWORD  dmDisplayFlags;
    DWORD  dmDisplayFrequency;

    DWORD  dmICMMethod;
    DWORD  dmICMIntent;
    DWORD  dmMediaType;
    DWORD  dmDitherType;
    DWORD  dmReserved1;
    DWORD  dmReserved2;
    DWORD  dmPanningWidth;
    DWORD  dmPanningHeight;
}

typedef DEVMODEW* PDEVMODEW;
typedef DEVMODEW* NPDEVMODEW;
typedef DEVMODEW* LPDEVMODEW;

version(UNICODE) {
	typedef DEVMODEW DEVMODE;
	typedef PDEVMODEW PDEVMODE;
	typedef NPDEVMODEW NPDEVMODE;
	typedef LPDEVMODEW LPDEVMODE;
}
else {
	typedef DEVMODEA DEVMODE;
	typedef PDEVMODEA PDEVMODE;
	typedef NPDEVMODEA NPDEVMODE;
	typedef LPDEVMODEA LPDEVMODE;
}

/* current version of specification */
const auto DM_SPECVERSION = 0x0401;

/* field selection bits */
const auto DM_ORIENTATION          = 0x00000001L;
const auto DM_PAPERSIZE            = 0x00000002L;
const auto DM_PAPERLENGTH          = 0x00000004L;
const auto DM_PAPERWIDTH           = 0x00000008L;
const auto DM_SCALE                = 0x00000010L;

const auto DM_POSITION             = 0x00000020L;
const auto DM_NUP                  = 0x00000040L;

const auto DM_DISPLAYORIENTATION   = 0x00000080L;

const auto DM_COPIES               = 0x00000100L;
const auto DM_DEFAULTSOURCE        = 0x00000200L;
const auto DM_PRINTQUALITY         = 0x00000400L;
const auto DM_COLOR                = 0x00000800L;
const auto DM_DUPLEX               = 0x00001000L;
const auto DM_YRESOLUTION          = 0x00002000L;
const auto DM_TTOPTION             = 0x00004000L;
const auto DM_COLLATE              = 0x00008000L;
const auto DM_FORMNAME             = 0x00010000L;
const auto DM_LOGPIXELS            = 0x00020000L;
const auto DM_BITSPERPEL           = 0x00040000L;
const auto DM_PELSWIDTH            = 0x00080000L;
const auto DM_PELSHEIGHT           = 0x00100000L;
const auto DM_DISPLAYFLAGS         = 0x00200000L;
const auto DM_DISPLAYFREQUENCY     = 0x00400000L;

const auto DM_ICMMETHOD            = 0x00800000L;
const auto DM_ICMINTENT            = 0x01000000L;
const auto DM_MEDIATYPE            = 0x02000000L;
const auto DM_DITHERTYPE           = 0x04000000L;
const auto DM_PANNINGWIDTH         = 0x08000000L;
const auto DM_PANNINGHEIGHT        = 0x10000000L;

const auto DM_DISPLAYFIXEDOUTPUT   = 0x20000000L;

/* orientation selections */
const auto DMORIENT_PORTRAIT   = 1;
const auto DMORIENT_LANDSCAPE  = 2;

/* paper selections */
const auto DMPAPER_LETTER               = 1;  /* Letter 8 1/2 x 11 in               */
const auto DMPAPER_FIRST                = DMPAPER_LETTER;
const auto DMPAPER_LETTERSMALL          = 2;  /* Letter Small 8 1/2 x 11 in         */
const auto DMPAPER_TABLOID              = 3;  /* Tabloid 11 x 17 in                 */
const auto DMPAPER_LEDGER               = 4;  /* Ledger 17 x 11 in                  */
const auto DMPAPER_LEGAL                = 5;  /* Legal 8 1/2 x 14 in                */
const auto DMPAPER_STATEMENT            = 6;  /* Statement 5 1/2 x 8 1/2 in         */
const auto DMPAPER_EXECUTIVE            = 7;  /* Executive 7 1/4 x 10 1/2 in        */
const auto DMPAPER_A3                   = 8;  /* A3 297 x 420 mm                    */
const auto DMPAPER_A4                   = 9;  /* A4 210 x 297 mm                    */
const auto DMPAPER_A4SMALL             = 10;  /* A4 Small 210 x 297 mm              */
const auto DMPAPER_A5                  = 11;  /* A5 148 x 210 mm                    */
const auto DMPAPER_B4                  = 12;  /* B4 (JIS) 250 x 354                 */
const auto DMPAPER_B5                  = 13;  /* B5 (JIS) 182 x 257 mm              */
const auto DMPAPER_FOLIO               = 14;  /* Folio 8 1/2 x 13 in                */
const auto DMPAPER_QUARTO              = 15;  /* Quarto 215 x 275 mm                */
const auto DMPAPER_10X14               = 16;  /* 10x14 in                           */
const auto DMPAPER_11X17               = 17;  /* 11x17 in                           */
const auto DMPAPER_NOTE                = 18;  /* Note 8 1/2 x 11 in                 */
const auto DMPAPER_ENV_9               = 19;  /* Envelope #9 3 7/8 x 8 7/8          */
const auto DMPAPER_ENV_10              = 20;  /* Envelope #10 4 1/8 x 9 1/2         */
const auto DMPAPER_ENV_11              = 21;  /* Envelope #11 4 1/2 x 10 3/8        */
const auto DMPAPER_ENV_12              = 22;  /* Envelope #12 4 \276 x 11           */
const auto DMPAPER_ENV_14              = 23;  /* Envelope #14 5 x 11 1/2            */
const auto DMPAPER_CSHEET              = 24;  /* C size sheet                       */
const auto DMPAPER_DSHEET              = 25;  /* D size sheet                       */
const auto DMPAPER_ESHEET              = 26;  /* E size sheet                       */
const auto DMPAPER_ENV_DL              = 27;  /* Envelope DL 110 x 220mm            */
const auto DMPAPER_ENV_C5              = 28;  /* Envelope C5 162 x 229 mm           */
const auto DMPAPER_ENV_C3              = 29;  /* Envelope C3  324 x 458 mm          */
const auto DMPAPER_ENV_C4              = 30;  /* Envelope C4  229 x 324 mm          */
const auto DMPAPER_ENV_C6              = 31;  /* Envelope C6  114 x 162 mm          */
const auto DMPAPER_ENV_C65             = 32;  /* Envelope C65 114 x 229 mm          */
const auto DMPAPER_ENV_B4              = 33;  /* Envelope B4  250 x 353 mm          */
const auto DMPAPER_ENV_B5              = 34;  /* Envelope B5  176 x 250 mm          */
const auto DMPAPER_ENV_B6              = 35;  /* Envelope B6  176 x 125 mm          */
const auto DMPAPER_ENV_ITALY           = 36;  /* Envelope 110 x 230 mm              */
const auto DMPAPER_ENV_MONARCH         = 37;  /* Envelope Monarch 3.875 x 7.5 in    */
const auto DMPAPER_ENV_PERSONAL        = 38;  /* 6 3/4 Envelope 3 5/8 x 6 1/2 in    */
const auto DMPAPER_FANFOLD_US          = 39;  /* US Std Fanfold 14 7/8 x 11 in      */
const auto DMPAPER_FANFOLD_STD_GERMAN  = 40;  /* German Std Fanfold 8 1/2 x 12 in   */
const auto DMPAPER_FANFOLD_LGL_GERMAN  = 41;  /* German Legal Fanfold 8 1/2 x 13 in */

const auto DMPAPER_ISO_B4              = 42;  /* B4 (ISO) 250 x 353 mm              */
const auto DMPAPER_JAPANESE_POSTCARD   = 43;  /* Japanese Postcard 100 x 148 mm     */
const auto DMPAPER_9X11                = 44;  /* 9 x 11 in                          */
const auto DMPAPER_10X11               = 45;  /* 10 x 11 in                         */
const auto DMPAPER_15X11               = 46;  /* 15 x 11 in                         */
const auto DMPAPER_ENV_INVITE          = 47;  /* Envelope Invite 220 x 220 mm       */
const auto DMPAPER_RESERVED_48         = 48;  /* RESERVED--DO NOT USE               */
const auto DMPAPER_RESERVED_49         = 49;  /* RESERVED--DO NOT USE               */
const auto DMPAPER_LETTER_EXTRA        = 50;  /* Letter Extra 9 \275 x 12 in        */
const auto DMPAPER_LEGAL_EXTRA         = 51;  /* Legal Extra 9 \275 x 15 in         */
const auto DMPAPER_TABLOID_EXTRA       = 52;  /* Tabloid Extra 11.69 x 18 in        */
const auto DMPAPER_A4_EXTRA            = 53;  /* A4 Extra 9.27 x 12.69 in           */
const auto DMPAPER_LETTER_TRANSVERSE   = 54;  /* Letter Transverse 8 \275 x 11 in   */
const auto DMPAPER_A4_TRANSVERSE       = 55;  /* A4 Transverse 210 x 297 mm         */
const auto DMPAPER_LETTER_EXTRA_TRANSVERSE = 56; /* Letter Extra Transverse 9\275 x 12 in */
const auto DMPAPER_A_PLUS              = 57;  /* SuperA/SuperA/A4 227 x 356 mm      */
const auto DMPAPER_B_PLUS              = 58;  /* SuperB/SuperB/A3 305 x 487 mm      */
const auto DMPAPER_LETTER_PLUS         = 59;  /* Letter Plus 8.5 x 12.69 in         */
const auto DMPAPER_A4_PLUS             = 60;  /* A4 Plus 210 x 330 mm               */
const auto DMPAPER_A5_TRANSVERSE       = 61;  /* A5 Transverse 148 x 210 mm         */
const auto DMPAPER_B5_TRANSVERSE       = 62;  /* B5 (JIS) Transverse 182 x 257 mm   */
const auto DMPAPER_A3_EXTRA            = 63;  /* A3 Extra 322 x 445 mm              */
const auto DMPAPER_A5_EXTRA            = 64;  /* A5 Extra 174 x 235 mm              */
const auto DMPAPER_B5_EXTRA            = 65;  /* B5 (ISO) Extra 201 x 276 mm        */
const auto DMPAPER_A2                  = 66;  /* A2 420 x 594 mm                    */
const auto DMPAPER_A3_TRANSVERSE       = 67;  /* A3 Transverse 297 x 420 mm         */
const auto DMPAPER_A3_EXTRA_TRANSVERSE = 68;  /* A3 Extra Transverse 322 x 445 mm   */

const auto DMPAPER_DBL_JAPANESE_POSTCARD = 69; /* Japanese Double Postcard 200 x 148 mm */
const auto DMPAPER_A6                  = 70;  /* A6 105 x 148 mm                 */
const auto DMPAPER_JENV_KAKU2          = 71;  /* Japanese Envelope Kaku #2       */
const auto DMPAPER_JENV_KAKU3          = 72;  /* Japanese Envelope Kaku #3       */
const auto DMPAPER_JENV_CHOU3          = 73;  /* Japanese Envelope Chou #3       */
const auto DMPAPER_JENV_CHOU4          = 74;  /* Japanese Envelope Chou #4       */
const auto DMPAPER_LETTER_ROTATED      = 75;  /* Letter Rotated 11 x 8 1/2 11 in */
const auto DMPAPER_A3_ROTATED          = 76;  /* A3 Rotated 420 x 297 mm         */
const auto DMPAPER_A4_ROTATED          = 77;  /* A4 Rotated 297 x 210 mm         */
const auto DMPAPER_A5_ROTATED          = 78;  /* A5 Rotated 210 x 148 mm         */
const auto DMPAPER_B4_JIS_ROTATED      = 79;  /* B4 (JIS) Rotated 364 x 257 mm   */
const auto DMPAPER_B5_JIS_ROTATED      = 80;  /* B5 (JIS) Rotated 257 x 182 mm   */
const auto DMPAPER_JAPANESE_POSTCARD_ROTATED = 81; /* Japanese Postcard Rotated 148 x 100 mm */
const auto DMPAPER_DBL_JAPANESE_POSTCARD_ROTATED = 82; /* Double Japanese Postcard Rotated 148 x 200 mm */
const auto DMPAPER_A6_ROTATED          = 83;  /* A6 Rotated 148 x 105 mm         */
const auto DMPAPER_JENV_KAKU2_ROTATED  = 84;  /* Japanese Envelope Kaku #2 Rotated */
const auto DMPAPER_JENV_KAKU3_ROTATED  = 85;  /* Japanese Envelope Kaku #3 Rotated */
const auto DMPAPER_JENV_CHOU3_ROTATED  = 86;  /* Japanese Envelope Chou #3 Rotated */
const auto DMPAPER_JENV_CHOU4_ROTATED  = 87;  /* Japanese Envelope Chou #4 Rotated */
const auto DMPAPER_B6_JIS              = 88;  /* B6 (JIS) 128 x 182 mm           */
const auto DMPAPER_B6_JIS_ROTATED      = 89;  /* B6 (JIS) Rotated 182 x 128 mm   */
const auto DMPAPER_12X11               = 90;  /* 12 x 11 in                      */
const auto DMPAPER_JENV_YOU4           = 91;  /* Japanese Envelope You #4        */
const auto DMPAPER_JENV_YOU4_ROTATED   = 92;  /* Japanese Envelope You #4 Rotated*/
const auto DMPAPER_P16K                = 93;  /* PRC 16K 146 x 215 mm            */
const auto DMPAPER_P32K                = 94;  /* PRC 32K 97 x 151 mm             */
const auto DMPAPER_P32KBIG             = 95;  /* PRC 32K(Big) 97 x 151 mm        */
const auto DMPAPER_PENV_1              = 96;  /* PRC Envelope #1 102 x 165 mm    */
const auto DMPAPER_PENV_2              = 97;  /* PRC Envelope #2 102 x 176 mm    */
const auto DMPAPER_PENV_3              = 98;  /* PRC Envelope #3 125 x 176 mm    */
const auto DMPAPER_PENV_4              = 99;  /* PRC Envelope #4 110 x 208 mm    */
const auto DMPAPER_PENV_5              = 100; /* PRC Envelope #5 110 x 220 mm    */
const auto DMPAPER_PENV_6              = 101; /* PRC Envelope #6 120 x 230 mm    */
const auto DMPAPER_PENV_7              = 102; /* PRC Envelope #7 160 x 230 mm    */
const auto DMPAPER_PENV_8              = 103; /* PRC Envelope #8 120 x 309 mm    */
const auto DMPAPER_PENV_9              = 104; /* PRC Envelope #9 229 x 324 mm    */
const auto DMPAPER_PENV_10             = 105; /* PRC Envelope #10 324 x 458 mm   */
const auto DMPAPER_P16K_ROTATED        = 106; /* PRC 16K Rotated                 */
const auto DMPAPER_P32K_ROTATED        = 107; /* PRC 32K Rotated                 */
const auto DMPAPER_P32KBIG_ROTATED     = 108; /* PRC 32K(Big) Rotated            */
const auto DMPAPER_PENV_1_ROTATED      = 109; /* PRC Envelope #1 Rotated 165 x 102 mm */
const auto DMPAPER_PENV_2_ROTATED      = 110; /* PRC Envelope #2 Rotated 176 x 102 mm */
const auto DMPAPER_PENV_3_ROTATED      = 111; /* PRC Envelope #3 Rotated 176 x 125 mm */
const auto DMPAPER_PENV_4_ROTATED      = 112; /* PRC Envelope #4 Rotated 208 x 110 mm */
const auto DMPAPER_PENV_5_ROTATED      = 113; /* PRC Envelope #5 Rotated 220 x 110 mm */
const auto DMPAPER_PENV_6_ROTATED      = 114; /* PRC Envelope #6 Rotated 230 x 120 mm */
const auto DMPAPER_PENV_7_ROTATED      = 115; /* PRC Envelope #7 Rotated 230 x 160 mm */
const auto DMPAPER_PENV_8_ROTATED      = 116; /* PRC Envelope #8 Rotated 309 x 120 mm */
const auto DMPAPER_PENV_9_ROTATED      = 117; /* PRC Envelope #9 Rotated 324 x 229 mm */
const auto DMPAPER_PENV_10_ROTATED     = 118; /* PRC Envelope #10 Rotated 458 x 324 mm */

const auto DMPAPER_LAST                = DMPAPER_PENV_10_ROTATED;

const auto DMPAPER_USER                = 256;

/* bin selections */
const auto DMBIN_UPPER         = 1;
const auto DMBIN_FIRST         = DMBIN_UPPER;
const auto DMBIN_ONLYONE       = 1;
const auto DMBIN_LOWER         = 2;
const auto DMBIN_MIDDLE        = 3;
const auto DMBIN_MANUAL        = 4;
const auto DMBIN_ENVELOPE      = 5;
const auto DMBIN_ENVMANUAL     = 6;
const auto DMBIN_AUTO          = 7;
const auto DMBIN_TRACTOR       = 8;
const auto DMBIN_SMALLFMT      = 9;
const auto DMBIN_LARGEFMT      = 10;
const auto DMBIN_LARGECAPACITY = 11;
const auto DMBIN_CASSETTE      = 14;
const auto DMBIN_FORMSOURCE    = 15;
const auto DMBIN_LAST          = DMBIN_FORMSOURCE;

const auto DMBIN_USER          = 256;     /* device specific bins start here */

/* print qualities */
const auto DMRES_DRAFT         = (-1);
const auto DMRES_LOW           = (-2);
const auto DMRES_MEDIUM        = (-3);
const auto DMRES_HIGH          = (-4);

/* color enable/disable for color printers */
const auto DMCOLOR_MONOCHROME  = 1;
const auto DMCOLOR_COLOR       = 2;

/* duplex enable */
const auto DMDUP_SIMPLEX    = 1;
const auto DMDUP_VERTICAL   = 2;
const auto DMDUP_HORIZONTAL = 3;

/* TrueType options */
const auto DMTT_BITMAP     = 1;       /* print TT fonts as graphics */
const auto DMTT_DOWNLOAD   = 2;       /* download TT fonts as soft fonts */
const auto DMTT_SUBDEV     = 3;       /* substitute device fonts for TT fonts */

const auto DMTT_DOWNLOAD_OUTLINE = 4; /* download TT fonts as outline soft fonts */

/* Collation selections */
const auto DMCOLLATE_FALSE  = 0;
const auto DMCOLLATE_TRUE   = 1;

/* DEVMODE dmDisplayOrientation specifiations */
const auto DMDO_DEFAULT    = 0;
const auto DMDO_90         = 1;
const auto DMDO_180        = 2;
const auto DMDO_270        = 3;

/* DEVMODE dmDisplayFixedOutput specifiations */
const auto DMDFO_DEFAULT   = 0;
const auto DMDFO_STRETCH   = 1;
const auto DMDFO_CENTER    = 2;

/* DEVMODE dmDisplayFlags flags */

// const auto DM_GRAYSCALE            0x00000001 /* This flag is no longer valid */
const auto DM_INTERLACED           = 0x00000002;
const auto DMDISPLAYFLAGS_TEXTMODE = 0x00000004;

/* dmNup , multiple logical page per physical page options */
const auto DMNUP_SYSTEM        = 1;
const auto DMNUP_ONEUP         = 2;

/* ICM methods */
const auto DMICMMETHOD_NONE    = 1;   /* ICM disabled */
const auto DMICMMETHOD_SYSTEM  = 2;   /* ICM handled by system */
const auto DMICMMETHOD_DRIVER  = 3;   /* ICM handled by driver */
const auto DMICMMETHOD_DEVICE  = 4;   /* ICM handled by device */

const auto DMICMMETHOD_USER  = 256;   /* Device-specific methods start here */

/* ICM Intents */
const auto DMICM_SATURATE          = 1;   /* Maximize color saturation */
const auto DMICM_CONTRAST          = 2;   /* Maximize color contrast */
const auto DMICM_COLORIMETRIC       = 3;   /* Use specific color metric */
const auto DMICM_ABS_COLORIMETRIC   = 4;   /* Use specific color metric */

const auto DMICM_USER        = 256;   /* Device-specific intents start here */

/* Media types */

const auto DMMEDIA_STANDARD      = 1;   /* Standard paper */
const auto DMMEDIA_TRANSPARENCY  = 2;   /* Transparency */
const auto DMMEDIA_GLOSSY        = 3;   /* Glossy paper */

const auto DMMEDIA_USER        = 256;   /* Device-specific media start here */

/* Dither types */
const auto DMDITHER_NONE       = 1;      /* No dithering */
const auto DMDITHER_COARSE     = 2;      /* Dither with a coarse brush */
const auto DMDITHER_FINE       = 3;      /* Dither with a fine brush */
const auto DMDITHER_LINEART    = 4;      /* LineArt dithering */
const auto DMDITHER_ERRORDIFFUSION = 5;  /* LineArt dithering */
const auto DMDITHER_RESERVED6      = 6;      /* LineArt dithering */
const auto DMDITHER_RESERVED7      = 7;      /* LineArt dithering */
const auto DMDITHER_RESERVED8      = 8;      /* LineArt dithering */
const auto DMDITHER_RESERVED9      = 9;      /* LineArt dithering */
const auto DMDITHER_GRAYSCALE  = 10;     /* Device does grayscaling */

const auto DMDITHER_USER     = 256;   /* Device-specific dithers start here */

struct DISPLAY_DEVICEA {
    DWORD  cb;
    CHAR[32]   DeviceName;
    CHAR[128]   DeviceString;
    DWORD  StateFlags;
    CHAR[128]   DeviceID;
    CHAR[128]   DeviceKey;
}

typedef DISPLAY_DEVICEA* PDISPLAY_DEVICEA;
typedef DISPLAY_DEVICEA* LPDISPLAY_DEVICEA;

struct DISPLAY_DEVICEW {
    DWORD  cb;
    WCHAR[32]  DeviceName;
    WCHAR[128]  DeviceString;
    DWORD  StateFlags;
    WCHAR[128]  DeviceID;
    WCHAR[128]  DeviceKey;
} 

typedef DISPLAY_DEVICEW* PDISPLAY_DEVICEW;
typedef DISPLAY_DEVICEW* LPDISPLAY_DEVICEW;

version(UNICODE) {
	typedef DISPLAY_DEVICEW DISPLAY_DEVICE;
	typedef PDISPLAY_DEVICEW PDISPLAY_DEVICE;
	typedef LPDISPLAY_DEVICEW LPDISPLAY_DEVICE;
}
else {
	typedef DISPLAY_DEVICEA DISPLAY_DEVICE;
	typedef PDISPLAY_DEVICEA PDISPLAY_DEVICE;
	typedef LPDISPLAY_DEVICEA LPDISPLAY_DEVICE;
}

const auto DISPLAY_DEVICE_ATTACHED_TO_DESKTOP = 0x00000001;
const auto DISPLAY_DEVICE_MULTI_DRIVER        = 0x00000002;
const auto DISPLAY_DEVICE_PRIMARY_DEVICE      = 0x00000004;
const auto DISPLAY_DEVICE_MIRRORING_DRIVER    = 0x00000008;
const auto DISPLAY_DEVICE_VGA_COMPATIBLE      = 0x00000010;
const auto DISPLAY_DEVICE_REMOVABLE           = 0x00000020;
const auto DISPLAY_DEVICE_MODESPRUNED         = 0x08000000;
const auto DISPLAY_DEVICE_REMOTE              = 0x04000000;
const auto DISPLAY_DEVICE_DISCONNECT          = 0x02000000;
const auto DISPLAY_DEVICE_TS_COMPATIBLE       = 0x00200000;
const auto DISPLAY_DEVICE_UNSAFE_MODES_ON     = 0x00080000;

/* Child device state */
const auto DISPLAY_DEVICE_ACTIVE              = 0x00000001;
const auto DISPLAY_DEVICE_ATTACHED            = 0x00000002;

/* GetRegionData/ExtCreateRegion */

const auto RDH_RECTANGLES  = 1;

struct RGNDATAHEADER {
	DWORD   dwSize;
	DWORD   iType;
	DWORD   nCount;
	DWORD   nRgnSize;
	RECT    rcBound;
}

typedef RGNDATAHEADER* PRGNDATAHEADER;

struct RGNDATA {
    RGNDATAHEADER   rdh;
    char[1]            Buffer;
}

typedef RGNDATA* PRGNDATA;
typedef RGNDATA* LPRGNDATA;
typedef RGNDATA* NPRGNDATA;

/* for GetRandomRgn */
const auto SYSRGN  = 4;

struct ABC {
	int     abcA;
	UINT    abcB;
	int     abcC;
}

typedef ABC* PABC;
typedef ABC* NPABC;
typedef ABC* LPABC;

struct ABCFLOAT {
	FLOAT   abcfA;
	FLOAT   abcfB;
	FLOAT   abcfC;
}

typedef ABCFLOAT* PABCFLOAT;
typedef ABCFLOAT* NPABCFLOAT;
typedef ABCFLOAT* LPABCFLOAT;

align(4) struct OUTLINETEXTMETRICA {
    UINT    otmSize;
    TEXTMETRICA otmTextMetrics;
    BYTE    otmFiller;
    PANOSE  otmPanoseNumber;
    UINT    otmfsSelection;
    UINT    otmfsType;
     int    otmsCharSlopeRise;
     int    otmsCharSlopeRun;
     int    otmItalicAngle;
    UINT    otmEMSquare;
     int    otmAscent;
     int    otmDescent;
    UINT    otmLineGap;
    UINT    otmsCapEmHeight;
    UINT    otmsXHeight;
    RECT    otmrcFontBox;
     int    otmMacAscent;
     int    otmMacDescent;
    UINT    otmMacLineGap;
    UINT    otmusMinimumPPEM;
    POINT   otmptSubscriptSize;
    POINT   otmptSubscriptOffset;
    POINT   otmptSuperscriptSize;
    POINT   otmptSuperscriptOffset;
    UINT    otmsStrikeoutSize;
     int    otmsStrikeoutPosition;
     int    otmsUnderscoreSize;
     int    otmsUnderscorePosition;
    PSTR    otmpFamilyName;
    PSTR    otmpFaceName;
    PSTR    otmpStyleName;
    PSTR    otmpFullName;
}

typedef OUTLINETEXTMETRICA* POUTLINETEXTMETRICA;
typedef OUTLINETEXTMETRICA* NPOUTLINETEXTMETRICA;
typedef OUTLINETEXTMETRICA* LPOUTLINETEXTMETRICA;

align(4) struct OUTLINETEXTMETRICW {
    UINT    otmSize;
    TEXTMETRICW otmTextMetrics;
    BYTE    otmFiller;
    PANOSE  otmPanoseNumber;
    UINT    otmfsSelection;
    UINT    otmfsType;
     int    otmsCharSlopeRise;
     int    otmsCharSlopeRun;
     int    otmItalicAngle;
    UINT    otmEMSquare;
     int    otmAscent;
     int    otmDescent;
    UINT    otmLineGap;
    UINT    otmsCapEmHeight;
    UINT    otmsXHeight;
    RECT    otmrcFontBox;
     int    otmMacAscent;
     int    otmMacDescent;
    UINT    otmMacLineGap;
    UINT    otmusMinimumPPEM;
    POINT   otmptSubscriptSize;
    POINT   otmptSubscriptOffset;
    POINT   otmptSuperscriptSize;
    POINT   otmptSuperscriptOffset;
    UINT    otmsStrikeoutSize;
     int    otmsStrikeoutPosition;
     int    otmsUnderscoreSize;
     int    otmsUnderscorePosition;
    PSTR    otmpFamilyName;
    PSTR    otmpFaceName;
    PSTR    otmpStyleName;
    PSTR    otmpFullName;
}

typedef OUTLINETEXTMETRICW* POUTLINETEXTMETRICW;
typedef OUTLINETEXTMETRICW* NPOUTLINETEXTMETRICW;
typedef OUTLINETEXTMETRICW* LPOUTLINETEXTMETRICW;

version(UNICODE) {
	typedef OUTLINETEXTMETRICW OUTLINETEXTMETRIC;
	typedef POUTLINETEXTMETRICW POUTLINETEXTMETRIC;
	typedef NPOUTLINETEXTMETRICW NPOUTLINETEXTMETRIC;
	typedef LPOUTLINETEXTMETRICW LPOUTLINETEXTMETRIC;
}
else {
	typedef OUTLINETEXTMETRICA OUTLINETEXTMETRIC;
	typedef POUTLINETEXTMETRICA POUTLINETEXTMETRIC;
	typedef NPOUTLINETEXTMETRICA NPOUTLINETEXTMETRIC;
	typedef LPOUTLINETEXTMETRICA LPOUTLINETEXTMETRIC;
}

struct POLYTEXTA {
    int       x;
    int       y;
    UINT      n;
    LPCSTR    lpstr;
    UINT      uiFlags;
    RECT      rcl;
    int      *pdx;
}

typedef POLYTEXTA* PPOLYTEXTA;
typedef POLYTEXTA* NPPOLYTEXTA;
typedef POLYTEXTA* LPPOLYTEXTA;

struct POLYTEXTW {
    int       x;
    int       y;
    UINT      n;
    LPCWSTR   lpstr;
    UINT      uiFlags;
    RECT      rcl;
    int      *pdx;
}

typedef POLYTEXTW* PPOLYTEXTW;
typedef POLYTEXTW* NPPOLYTEXTW;
typedef POLYTEXTW* LPPOLYTEXTW;

version(UNICODE) {
	typedef POLYTEXTW POLYTEXT;
	typedef PPOLYTEXTW PPOLYTEXT;
	typedef NPPOLYTEXTW NPPOLYTEXT;
	typedef LPPOLYTEXTW LPPOLYTEXT;
}
else {
	typedef POLYTEXTA POLYTEXT;
	typedef PPOLYTEXTA PPOLYTEXT;
	typedef NPPOLYTEXTA NPPOLYTEXT;
	typedef LPPOLYTEXTA LPPOLYTEXT;
}

struct FIXED {
    short   value;
    WORD    fract;
}

struct MAT2 {
	FIXED  eM11;
	FIXED  eM12;
	FIXED  eM21;
	FIXED  eM22;
}

typedef MAT2* LPMAT2;

struct GLYPHMETRICS {
    UINT    gmBlackBoxX;
    UINT    gmBlackBoxY;
    POINT   gmptGlyphOrigin;
    short   gmCellIncX;
    short   gmCellIncY;
}

typedef GLYPHMETRICS* LPGLYPHMETRICS;

//  GetGlyphOutline constants

const auto GGO_METRICS        = 0;
const auto GGO_BITMAP         = 1;
const auto GGO_NATIVE         = 2;
const auto GGO_BEZIER         = 3;

const auto  GGO_GRAY2_BITMAP   = 4;
const auto  GGO_GRAY4_BITMAP   = 5;
const auto  GGO_GRAY8_BITMAP   = 6;
const auto  GGO_GLYPH_INDEX    = 0x0080;

const auto  GGO_UNHINTED       = 0x0100;

const auto TT_POLYGON_TYPE   = 24;

const auto TT_PRIM_LINE       = 1;
const auto TT_PRIM_QSPLINE    = 2;
const auto TT_PRIM_CSPLINE    = 3;

struct POINTFX {
    FIXED x;
    FIXED y;
}

typedef POINTFX* LPPOINTFX;

struct TTPOLYCURVE {
    WORD    wType;
    WORD    cpfx;
    POINTFX[1] apfx;
}

typedef TTPOLYCURVE* LPTTPOLYCURVE;

struct TTPOLYGONHEADER {
    DWORD   cb;
    DWORD   dwType;
    POINTFX pfxStart;
}

typedef TTPOLYGONHEADER* LPTTPOLYGONHEADER;

const auto GCP_DBCS           = 0x0001;
const auto GCP_REORDER        = 0x0002;
const auto GCP_USEKERNING     = 0x0008;
const auto GCP_GLYPHSHAPE     = 0x0010;
const auto GCP_LIGATE         = 0x0020;
////const auto GCP_GLYPHINDEXING  0x0080
const auto GCP_DIACRITIC      = 0x0100;
const auto GCP_KASHIDA        = 0x0400;
const auto GCP_ERROR          = 0x8000;
const auto FLI_MASK           = 0x103B;

const auto GCP_JUSTIFY        = 0x00010000;
////const auto GCP_NODIACRITICS   0x00020000L
const auto FLI_GLYPHS         = 0x00040000L;
const auto GCP_CLASSIN        = 0x00080000L;
const auto GCP_MAXEXTENT      = 0x00100000L;
const auto GCP_JUSTIFYIN      = 0x00200000L;
const auto GCP_DISPLAYZWG      = 0x00400000L;
const auto GCP_SYMSWAPOFF      = 0x00800000L;
const auto GCP_NUMERICOVERRIDE = 0x01000000L;
const auto GCP_NEUTRALOVERRIDE = 0x02000000L;
const auto GCP_NUMERICSLATIN   = 0x04000000L;
const auto GCP_NUMERICSLOCAL   = 0x08000000L;

const auto GCPCLASS_LATIN                  = 1;
const auto GCPCLASS_HEBREW                 = 2;
const auto GCPCLASS_ARABIC                 = 2;
const auto GCPCLASS_NEUTRAL                = 3;
const auto GCPCLASS_LOCALNUMBER            = 4;
const auto GCPCLASS_LATINNUMBER            = 5;
const auto GCPCLASS_LATINNUMERICTERMINATOR = 6;
const auto GCPCLASS_LATINNUMERICSEPARATOR  = 7;
const auto GCPCLASS_NUMERICSEPARATOR       = 8;
const auto GCPCLASS_PREBOUNDLTR         = 0x80;
const auto GCPCLASS_PREBOUNDRTL         = 0x40;
const auto GCPCLASS_POSTBOUNDLTR        = 0x20;
const auto GCPCLASS_POSTBOUNDRTL        = 0x10;

const auto GCPGLYPH_LINKBEFORE          = 0x8000;
const auto GCPGLYPH_LINKAFTER           = 0x4000;

struct GCP_RESULTSA {
    DWORD   lStructSize;
    LPSTR     lpOutString;
    UINT *lpOrder;
    int   *lpDx;
    int   *lpCaretPos;
    LPSTR   lpClass;
    LPWSTR  lpGlyphs;
    UINT    nGlyphs;
    int     nMaxFit;
}

typedef GCP_RESULTSA* LPGCP_RESULTSA;

struct GCP_RESULTSW {
    DWORD   lStructSize;
    LPWSTR    lpOutString;
    UINT *lpOrder;
    int   *lpDx;
    int   *lpCaretPos;
    LPSTR   lpClass;
    LPWSTR  lpGlyphs;
    UINT    nGlyphs;
    int     nMaxFit;
}

typedef GCP_RESULTSW* LPGCP_RESULTSW;

version(UNICODE) {
	typedef GCP_RESULTSW GCP_RESULTS;
	typedef LPGCP_RESULTSW LPGCP_RESULTS;
}
else {
	typedef GCP_RESULTSA GCP_RESULTS;
	typedef LPGCP_RESULTSA LPGCP_RESULTS;
}

struct RASTERIZER_STATUS {
    short   nSize;
    short   wFlags;
    short   nLanguageID;
}

typedef RASTERIZER_STATUS* LPRASTERIZER_STATUS;

/* bits defined in wFlags of RASTERIZER_STATUS */
const auto TT_AVAILABLE    = 0x0001;
const auto TT_ENABLED      = 0x0002;

/* Pixel format descriptor */
struct PIXELFORMATDESCRIPTOR {
    WORD  nSize;
    WORD  nVersion;
    DWORD dwFlags;
    BYTE  iPixelType;
    BYTE  cColorBits;
    BYTE  cRedBits;
    BYTE  cRedShift;
    BYTE  cGreenBits;
    BYTE  cGreenShift;
    BYTE  cBlueBits;
    BYTE  cBlueShift;
    BYTE  cAlphaBits;
    BYTE  cAlphaShift;
    BYTE  cAccumBits;
    BYTE  cAccumRedBits;
    BYTE  cAccumGreenBits;
    BYTE  cAccumBlueBits;
    BYTE  cAccumAlphaBits;
    BYTE  cDepthBits;
    BYTE  cStencilBits;
    BYTE  cAuxBuffers;
    BYTE  iLayerType;
    BYTE  bReserved;
    DWORD dwLayerMask;
    DWORD dwVisibleMask;
    DWORD dwDamageMask;
}

typedef PIXELFORMATDESCRIPTOR* PPIXELFORMATDESCRIPTOR;
typedef PIXELFORMATDESCRIPTOR* LPPIXELFORMATDESCRIPTOR;

/* pixel types */
const auto PFD_TYPE_RGBA        = 0;
const auto PFD_TYPE_COLORINDEX  = 1;

/* layer types */
const auto PFD_MAIN_PLANE       = 0;
const auto PFD_OVERLAY_PLANE    = 1;
const auto PFD_UNDERLAY_PLANE   = (-1);

/* PIXELFORMATDESCRIPTOR flags */
const auto PFD_DOUBLEBUFFER            = 0x00000001;
const auto PFD_STEREO                  = 0x00000002;
const auto PFD_DRAW_TO_WINDOW          = 0x00000004;
const auto PFD_DRAW_TO_BITMAP          = 0x00000008;
const auto PFD_SUPPORT_GDI             = 0x00000010;
const auto PFD_SUPPORT_OPENGL          = 0x00000020;
const auto PFD_GENERIC_FORMAT          = 0x00000040;
const auto PFD_NEED_PALETTE            = 0x00000080;
const auto PFD_NEED_SYSTEM_PALETTE     = 0x00000100;
const auto PFD_SWAP_EXCHANGE           = 0x00000200;
const auto PFD_SWAP_COPY               = 0x00000400;
const auto PFD_SWAP_LAYER_BUFFERS      = 0x00000800;
const auto PFD_GENERIC_ACCELERATED     = 0x00001000;
const auto PFD_SUPPORT_DIRECTDRAW      = 0x00002000;
const auto PFD_DIRECT3D_ACCELERATED    = 0x00004000;
const auto PFD_SUPPORT_COMPOSITION     = 0x00008000;

/* PIXELFORMATDESCRIPTOR flags for use in ChoosePixelFormat only */
const auto PFD_DEPTH_DONTCARE          = 0x20000000;
const auto PFD_DOUBLEBUFFER_DONTCARE   = 0x40000000;
const auto PFD_STEREO_DONTCARE         = 0x80000000;

typedef int function(LOGFONTA*, TEXTMETRICA*, DWORD, LPARAM) OLDFONTENUMPROCA;
typedef int function(LOGFONTW*, TEXTMETRICW*, DWORD, LPARAM) OLDFONTENUMPROCW;

version (UNICODE) {
	alias OLDFONTENUMPROCW  OLDFONTENUMPROC;
}
else {
	alias OLDFONTENUMPROCA  OLDFONTENUMPROC;
}

typedef OLDFONTENUMPROCA    FONTENUMPROCA;
typedef OLDFONTENUMPROCW    FONTENUMPROCW;

version (UNICODE) {
	typedef FONTENUMPROCW FONTENUMPROC;
}
else {
	typedef FONTENUMPROCA FONTENUMPROC;
}

typedef int function (LPVOID, LPARAM) GOBJENUMPROC;
typedef VOID function(int, int, LPARAM) LINEDDAPROC;

int AddFontResourceA(LPCSTR);
int AddFontResourceW(LPCWSTR);

version (UNICODE) {
	alias AddFontResourceW AddFontResource;
}
else {
	alias AddFontResourceA AddFontResource;
}

BOOL  AnimatePalette(HPALETTE hPal, UINT iStartIndex, UINT cEntries, PALETTEENTRY* ppe);
BOOL  Arc(HDC hdc,int x1,int y1,int x2,int y2,int x3,int y3,int x4,int y4);
BOOL  BitBlt(HDC hdc,int x,int y,int cx,int cy,HDC hdcSrc,int x1,int y1,DWORD rop);
BOOL  CancelDC(HDC hdc);
BOOL  Chord(HDC hdc,int x1,int y1,int x2,int y2,int x3,int y3,int x4,int y4);
int   ChoosePixelFormat(HDC hdc,PIXELFORMATDESCRIPTOR *ppfd);
HMETAFILE  CloseMetaFile(HDC hdc);
int     CombineRgn(HRGN hrgnDst,HRGN hrgnSrc1,HRGN hrgnSrc2,int iMode);
HMETAFILE CopyMetaFileA(HMETAFILE,LPCSTR);
HMETAFILE CopyMetaFileW(HMETAFILE,LPCWSTR);

version(UNICODE) {
	alias CopyMetaFileW  CopyMetaFile;
}
else {
	alias CopyMetaFileA  CopyMetaFile;
}

HBITMAP CreateBitmap(int nWidth,int nHeight,UINT nPlanes,UINT nBitCount,VOID *lpBits);
HBITMAP CreateBitmapIndirect(BITMAP *pbm);
HBRUSH  CreateBrushIndirect(LOGBRUSH *plbrush);
HBITMAP CreateCompatibleBitmap(HDC hdc,int cx,int cy);
HBITMAP CreateDiscardableBitmap(HDC hdc,int cx,int cy);
HDC     CreateCompatibleDC(HDC hdc);
HDC     CreateDCA(LPCSTR pwszDriver,LPCSTR pwszDevice,LPCSTR pszPort,DEVMODEA * pdm);
HDC     CreateDCW(LPCWSTR pwszDriver,LPCWSTR pwszDevice,LPCWSTR pszPort,DEVMODEW * pdm);

version(UNICODE) {
	alias CreateDCW  CreateDC;
}
else {
	alias CreateDCA  CreateDC;
}

HBITMAP CreateDIBitmap(HDC hdc,BITMAPINFOHEADER *pbmih,DWORD flInit,VOID *pjBits,BITMAPINFO *pbmi,UINT iUsage);
HBRUSH  CreateDIBPatternBrush(HGLOBAL h,UINT iUsage);
HBRUSH  CreateDIBPatternBrushPt(VOID *lpPackedDIB,UINT iUsage);
HRGN    CreateEllipticRgn(int x1,int y1,int x2,int y2);
HRGN    CreateEllipticRgnIndirect(RECT *lprect);
HFONT   CreateFontIndirectA(LOGFONTA *lplf);
HFONT   CreateFontIndirectW(LOGFONTW *lplf);

version(UNICODE) {
	alias CreateFontIndirectW  CreateFontIndirect;
}
else {
	alias CreateFontIndirectA  CreateFontIndirect;
}

HFONT   CreateFontA(int cHeight,int cWidth,int cEscapement,int cOrientation,int cWeight,DWORD bItalic,
                            DWORD bUnderline,DWORD bStrikeOut,DWORD iCharSet,DWORD iOutPrecision,DWORD iClipPrecision,
                            DWORD iQuality,DWORD iPitchAndFamily,LPCSTR pszFaceName);
HFONT   CreateFontW(int cHeight,int cWidth,int cEscapement,int cOrientation,int cWeight,DWORD bItalic,
                            DWORD bUnderline,DWORD bStrikeOut,DWORD iCharSet,DWORD iOutPrecision,DWORD iClipPrecision,
                            DWORD iQuality,DWORD iPitchAndFamily,LPCWSTR pszFaceName);

version(UNICODE) {
	alias CreateFontW  CreateFont;
}
else {
	alias CreateFontA  CreateFont;
}

HBRUSH  CreateHatchBrush(int iHatch,COLORREF color);
HDC     CreateICA(LPCSTR pszDriver,LPCSTR pszDevice,LPCSTR pszPort,DEVMODEA * pdm);
HDC     CreateICW(LPCWSTR pszDriver,LPCWSTR pszDevice,LPCWSTR pszPort,DEVMODEW * pdm);

version(UNICODE) {
	alias CreateICW  CreateIC;
}
else {
	alias CreateICA  CreateIC;
}

HDC     CreateMetaFileA(LPCSTR pszFile);
HDC     CreateMetaFileW(LPCWSTR pszFile);

version(UNICODE) {
	alias CreateMetaFileW  CreateMetaFile;
}
else {
	alias CreateMetaFileA  CreateMetaFile;
}

HPALETTE CreatePalette( LOGPALETTE * plpal);
HPEN    CreatePen(int iStyle,int cWidth,COLORREF color);
HPEN    CreatePenIndirect(LOGPEN *plpen);
HRGN    CreatePolyPolygonRgn( POINT *pptl,
                                               INT  *pc,
                                               int cPoly,
                                               int iMode);
HBRUSH  CreatePatternBrush(HBITMAP hbm);
HRGN    CreateRectRgn(int x1,int y1,int x2,int y2);
HRGN    CreateRectRgnIndirect(RECT *lprect);
HRGN    CreateRoundRectRgn(int x1,int y1,int x2,int y2,int w,int h);
BOOL    CreateScalableFontResourceA(DWORD fdwHidden,LPCSTR lpszFont,LPCSTR lpszFile,LPCSTR lpszPath);
BOOL    CreateScalableFontResourceW(DWORD fdwHidden,LPCWSTR lpszFont,LPCWSTR lpszFile,LPCWSTR lpszPath);

version(UNICODE) {
	alias CreateScalableFontResourceW  CreateScalableFontResource;
}
else {
	alias CreateScalableFontResourceA  CreateScalableFontResource;
}

HBRUSH  CreateSolidBrush(COLORREF color);

BOOL DeleteDC(HDC hdc);
BOOL DeleteMetaFile(HMETAFILE hmf);
BOOL DeleteObject(HGDIOBJ ho);
int  DescribePixelFormat( HDC hdc,
                                           int iPixelFormat,
                                           UINT nBytes,LPPIXELFORMATDESCRIPTOR ppfd);

/* define types of pointers to ExtDeviceMode() and DeviceCapabilities()
 * functions for Win 3.1 compatibility
 */

typedef UINT function(HWND, HMODULE, LPDEVMODE, LPSTR, LPSTR, LPDEVMODE, LPSTR, UINT) LPFNDEVMODE;
typedef DWORD function(LPSTR, LPSTR, UINT, LPSTR, LPDEVMODE) LPFNDEVCAPS;

/* mode selections for the device mode function */
// import windef.d:
/*const auto DM_UPDATE           = 1;
const auto DM_COPY             = 2;
const auto DM_PROMPT           = 4;
const auto DM_MODIFY           = 8;*/

// import windef.d:
/*const auto DM_IN_BUFFER        = DM_MODIFY;
const auto DM_IN_PROMPT        = DM_PROMPT;
const auto DM_OUT_BUFFER       = DM_COPY;
const auto DM_OUT_DEFAULT      = DM_UPDATE;*/

/* device capabilities indices */
// import windef.d:
/*const auto DC_FIELDS           = 1;
const auto DC_PAPERS           = 2;
const auto DC_PAPERSIZE        = 3;
const auto DC_MINEXTENT        = 4;
const auto DC_MAXEXTENT        = 5;
const auto DC_BINS             = 6;
const auto DC_DUPLEX           = 7;
const auto DC_SIZE             = 8;
const auto DC_EXTRA            = 9;
const auto DC_VERSION          = 10;
const auto DC_DRIVER           = 11;
const auto DC_BINNAMES         = 12;
const auto DC_ENUMRESOLUTIONS  = 13;
const auto DC_FILEDEPENDENCIES = 14;
const auto DC_TRUETYPE         = 15;
const auto DC_PAPERNAMES       = 16;
const auto DC_ORIENTATION      = 17;
const auto DC_COPIES           = 18;*/

const auto DC_BINADJUST            = 19;
const auto DC_EMF_COMPLIANT        = 20;
const auto DC_DATATYPE_PRODUCED    = 21;
const auto DC_COLLATE              = 22;
const auto DC_MANUFACTURER         = 23;
const auto DC_MODEL                = 24;

const auto DC_PERSONALITY          = 25;
const auto DC_PRINTRATE            = 26;
const auto DC_PRINTRATEUNIT        = 27;
const auto   PRINTRATEUNIT_PPM     = 1;
const auto   PRINTRATEUNIT_CPS     = 2;
const auto   PRINTRATEUNIT_LPM     = 3;
const auto   PRINTRATEUNIT_IPM     = 4;
const auto DC_PRINTERMEM           = 28;
const auto DC_MEDIAREADY           = 29;
const auto DC_STAPLE               = 30;
const auto DC_PRINTRATEPPM         = 31;
const auto DC_COLORDEVICE          = 32;
const auto DC_NUP                  = 33;

const auto DC_MEDIATYPENAMES       = 34;
const auto DC_MEDIATYPES           = 35;

/* bit fields of the return value (DWORD) for DC_TRUETYPE */
const auto DCTT_BITMAP             = 0x0000001L;
const auto DCTT_DOWNLOAD           = 0x0000002L;
const auto DCTT_SUBDEV             = 0x0000004L;

const auto DCTT_DOWNLOAD_OUTLINE   = 0x0000008L;

/* return values for DC_BINADJUST */
const auto DCBA_FACEUPNONE       = 0x0000;
const auto DCBA_FACEUPCENTER     = 0x0001;
const auto DCBA_FACEUPLEFT       = 0x0002;
const auto DCBA_FACEUPRIGHT      = 0x0003;
const auto DCBA_FACEDOWNNONE     = 0x0100;
const auto DCBA_FACEDOWNCENTER   = 0x0101;
const auto DCBA_FACEDOWNLEFT     = 0x0102;
const auto DCBA_FACEDOWNRIGHT    = 0x0103;

int DeviceCapabilitiesA(
                  LPCSTR         pDevice,
              LPCSTR         pPort,
                  WORD             fwCapability,
    	LPSTR          pOutput,
              DEVMODEA   *pDevMode
    );

int DeviceCapabilitiesW(
                  LPCWSTR         pDevice,
              LPCWSTR         pPort,
                  WORD             fwCapability,
    LPWSTR          pOutput,
              DEVMODEW   *pDevMode
    );

version(UNICODE) {
	alias DeviceCapabilitiesW  DeviceCapabilities;
}
else {
	alias DeviceCapabilitiesA  DeviceCapabilities;
}

int  DrawEscape(  HDC    hdc,
                                   int    iEscape,
                                   int    cjIn,
								   LPCSTR lpIn);

BOOL Ellipse(HDC hdc,int left,int top, int right,int bottom);

int  EnumFontFamiliesExA(HDC hdc,LPLOGFONTA lpLogfont,FONTENUMPROCA lpProc,LPARAM lParam,DWORD dwFlags);
int  EnumFontFamiliesExW(HDC hdc,LPLOGFONTW lpLogfont,FONTENUMPROCW lpProc,LPARAM lParam,DWORD dwFlags);

version(UNICODE) {
	alias EnumFontFamiliesExW  EnumFontFamiliesEx;
}
else {
	alias EnumFontFamiliesExA  EnumFontFamiliesEx;
}

int  EnumFontFamiliesA(HDC hdc,LPCSTR lpLogfont,FONTENUMPROCA lpProc,LPARAM lParam);
int  EnumFontFamiliesW(HDC hdc,LPCWSTR lpLogfont,FONTENUMPROCW lpProc,LPARAM lParam);

version(UNICODE) {
	alias EnumFontFamiliesW  EnumFontFamiliesW;
}
else {
	alias EnumFontFamiliesA  EnumFontFamiliesA;
}
int  EnumFontsA(HDC hdc,LPCSTR lpLogfont, FONTENUMPROCA lpProc,LPARAM lParam);
int  EnumFontsW(HDC hdc,LPCWSTR lpLogfont, FONTENUMPROCW lpProc,LPARAM lParam);

version(UNICODE) {
	alias EnumFontsW  EnumFonts;
}
else {
	alias EnumFontsA  EnumFonts;
}

int  EnumObjects(HDC hdc,int nType,GOBJENUMPROC lpFunc,LPVOID lParam);

BOOL EqualRgn(HRGN hrgn1,HRGN hrgn2);
int  Escape(  HDC hdc,
                               int iEscape,
                               int cjIn,
                                LPCSTR pvIn,
                                LPVOID pvOut);
int  ExtEscape(   HDC hdc,
                                   int iEscape,
                                   int cjInput,
                                    LPCSTR lpInData,
                                   int cjOutput,
                                    LPSTR lpOutData);
int  ExcludeClipRect(HDC hdc,int left,int top,int right,int bottom);
HRGN ExtCreateRegion(XFORM * lpx,DWORD nCount, RGNDATA * lpData);
BOOL ExtFloodFill(HDC hdc,int x,int y,COLORREF color,UINT type);
BOOL FillRgn(HDC hdc,HRGN hrgn,HBRUSH hbr);
BOOL FloodFill(HDC hdc,int x,int y,COLORREF color);
BOOL FrameRgn(HDC hdc,HRGN hrgn,HBRUSH hbr,int w,int h);
int  GetROP2(HDC hdc);
BOOL GetAspectRatioFilterEx(HDC hdc,LPSIZE lpsize);
COLORREF GetBkColor(HDC hdc);

COLORREF GetDCBrushColor(HDC hdc);
COLORREF GetDCPenColor(HDC hdc);

int GetBkMode(HDC hdc);

LONG GetBitmapBits(
   HBITMAP hbit,
   LONG cb,
    LPVOID lpvBits
    );

BOOL  GetBitmapDimensionEx(HBITMAP hbit,LPSIZE lpsize);
UINT  GetBoundsRect(HDC hdc,LPRECT lprect,UINT flags);

BOOL  GetBrushOrgEx(HDC hdc,LPPOINT lppt);

BOOL  GetCharWidthA(HDC hdc,UINT iFirst,UINT iLast, LPINT lpBuffer);
BOOL  GetCharWidthW(HDC hdc,UINT iFirst,UINT iLast, LPINT lpBuffer);

version(UNICODE) {
	alias GetCharWidthW  GetCharWidth;
}
else {
	alias GetCharWidthA  GetCharWidth;
}

BOOL  GetCharWidth32A(HDC hdc,UINT iFirst,UINT iLast,  LPINT lpBuffer);
BOOL  GetCharWidth32W(HDC hdc,UINT iFirst,UINT iLast,  LPINT lpBuffer);

version(UNICODE) {
	alias GetCharWidth32W  GetCharWidth32;
}
else {
	alias GetCharWidth32A  GetCharWidth32;
}
BOOL  GetCharWidthFloatA(HDC hdc,UINT iFirst,UINT iLast, PFLOAT lpBuffer);
BOOL GetCharWidthFloatW(HDC hdc,UINT iFirst,UINT iLast, PFLOAT lpBuffer);

version(UNICODE) {
	alias GetCharWidthFloatW  GetCharWidthFloat;
}
else {
	alias GetCharWidthFloatA  GetCharWidthFloat;
}

BOOL GetCharABCWidthsA(HDC hdc,
                                           UINT wFirst,
                                           UINT wLast,
                                           LPABC lpABC);
BOOL GetCharABCWidthsW(HDC hdc,
                                           UINT wFirst,
                                           UINT wLast,
                                            LPABC lpABC);
version(UNICODE) {
	alias GetCharABCWidthsW  GetCharABCWidths;
}
else {
	alias GetCharABCWidthsA  GetCharABCWidths;
}

BOOL GetCharABCWidthsFloatA(HDC hdc,UINT iFirst,UINT iLast, LPABCFLOAT lpABC);
BOOL GetCharABCWidthsFloatW(HDC hdc,UINT iFirst,UINT iLast, LPABCFLOAT lpABC);

version(UNICODE) {
	alias GetCharABCWidthsFloatW  GetCharABCWidthsFloat;
}
else {
	alias GetCharABCWidthsFloatA  GetCharABCWidthsFloat;
}

int   GetClipBox(HDC hdc, LPRECT lprect);
int   GetClipRgn(HDC hdc,HRGN hrgn);
int   GetMetaRgn(HDC hdc,HRGN hrgn);
HGDIOBJ GetCurrentObject(HDC hdc,UINT type);
BOOL  GetCurrentPositionEx(HDC hdc, LPPOINT lppt);
int   GetDeviceCaps(HDC hdc,int index);
int   GetDIBits(HDC hdc,HBITMAP hbm,UINT start,UINT cLines,  LPVOID lpvBits, LPBITMAPINFO lpbmi,UINT usage);  // SAL actual size of lpbmi is computed from structure elements

DWORD GetFontData (   HDC     hdc,
                                       DWORD   dwTable,
                                       DWORD   dwOffset,
                                       PVOID pvBuffer,
                                       DWORD   cjBuffer
                                        );

DWORD GetGlyphOutlineA(   HDC hdc,
                                           UINT uChar,
                                           UINT fuFormat,
                                           LPGLYPHMETRICS lpgm,
                                           DWORD cjBuffer,
                                           LPVOID pvBuffer,
                                           MAT2 *lpmat2
                                        );
DWORD GetGlyphOutlineW(   HDC hdc,
                                           UINT uChar,
                                           UINT fuFormat,
                                           LPGLYPHMETRICS lpgm,
                                           DWORD cjBuffer,
                                           LPVOID pvBuffer,
                                           MAT2 *lpmat2
                                        );

version(UNICODE) {
	alias GetGlyphOutlineW  GetGlyphOutline;
}
else {
	alias GetGlyphOutlineA  GetGlyphOutline;
}

int   GetGraphicsMode(HDC hdc);
int   GetMapMode(HDC hdc);
UINT  GetMetaFileBitsEx(HMETAFILE hMF,UINT cbBuffer, LPVOID lpData);
HMETAFILE   GetMetaFileA(LPCSTR lpName);
HMETAFILE   GetMetaFileW(LPCWSTR lpName);

version(UNICODE) {
	alias GetMetaFileW  GetMetaFile;
}
else {
	alias GetMetaFileA  GetMetaFile;
}

COLORREF GetNearestColor(HDC hdc,COLORREF color);
UINT  GetNearestPaletteIndex(HPALETTE h,COLORREF color);
DWORD GetObjectType(HGDIOBJ h);

UINT GetOutlineTextMetricsA(HDC hdc,
                                               UINT cjCopy,
                                               LPOUTLINETEXTMETRICA potm);
UINT GetOutlineTextMetricsW(HDC hdc,
                                               UINT cjCopy,
                                               LPOUTLINETEXTMETRICW potm);

version(UNICODE) {
	alias GetOutlineTextMetricsW  GetOutlineTextMetrics;
}
else {
	alias GetOutlineTextMetricsA  GetOutlineTextMetrics;
}

UINT  GetPaletteEntries(  HPALETTE hpal,
                                           UINT iStart,
                                           UINT cEntries,
                                           LPPALETTEENTRY pPalEntries);
COLORREF GetPixel(HDC hdc,int x,int y);
int   GetPixelFormat(HDC hdc);
int   GetPolyFillMode(HDC hdc);
BOOL  GetRasterizerCaps(LPRASTERIZER_STATUS lpraststat,
                                           UINT cjBytes);

int   GetRandomRgn (HDC hdc,HRGN hrgn,INT i);
DWORD GetRegionData(  HRGN hrgn,
                                       DWORD nCount,
                                       LPRGNDATA lpRgnData);
int   GetRgnBox(HRGN hrgn, LPRECT lprc);
HGDIOBJ GetStockObject(int i);
int   GetStretchBltMode(HDC hdc);

UINT GetSystemPaletteEntries(
   HDC  hdc,
   UINT iStart,
   UINT cEntries,
   LPPALETTEENTRY pPalEntries
);

UINT  GetSystemPaletteUse(HDC hdc);
int   GetTextCharacterExtra(HDC hdc);
UINT  GetTextAlign(HDC hdc);
COLORREF GetTextColor(HDC hdc);

BOOL GetTextExtentPointA(
   HDC hdc,
   LPCSTR lpString,
   int c,
   LPSIZE lpsz );

BOOL GetTextExtentPointW(
   HDC hdc,
   LPCWSTR lpString,
   int c,
   LPSIZE lpsz
    );

version(UNICODE) {
	alias GetTextExtentPointW  GetTextExtentPoint;
}
else {
	alias GetTextExtentPointA  GetTextExtentPoint;
}

BOOL GetTextExtentPoint32A(
   HDC hdc,
   LPCSTR lpString,
   int c,
   LPSIZE psizl
);

BOOL GetTextExtentPoint32W(
   HDC hdc,
   LPCWSTR lpString,
   int c,
   LPSIZE psizl
);

version(UNICODE) {
	alias GetTextExtentPoint32W  GetTextExtentPoint32;
}
else {
	alias GetTextExtentPoint32A  GetTextExtentPoint32;
}

BOOL GetTextExtentExPointA(
   HDC hdc,
   LPCSTR lpszString,
   int cchString,
   int nMaxExtent,
    LPINT lpnFit,
   LPINT lpnDx,
   LPSIZE lpSize
    );

BOOL GetTextExtentExPointW(
   HDC hdc,
  LPCWSTR lpszString,
   int cchString,
   int nMaxExtent,
    LPINT lpnFit,
   LPINT lpnDx,
   LPSIZE lpSize
    );

version(UNICODE) {
	alias GetTextExtentExPointW  GetTextExtentExPoint;
}
else {
	alias GetTextExtentExPointA  GetTextExtentExPoint;
}

int GetTextCharset(HDC hdc);
int GetTextCharsetInfo(HDC hdc, LPFONTSIGNATURE lpSig,DWORD dwFlags);
BOOL TranslateCharsetInfo(DWORD *lpSrc, LPCHARSETINFO lpCs,DWORD dwFlags);
DWORD GetFontLanguageInfo(HDC hdc);
DWORD GetCharacterPlacementA( HDC hdc, LPCSTR lpString,int nCount,int nMexExtent,LPGCP_RESULTSA lpResults,DWORD dwFlags);
DWORD GetCharacterPlacementW( HDC hdc, LPCWSTR lpString,int nCount,int nMexExtent,LPGCP_RESULTSW lpResults,DWORD dwFlags);

version(UNICODE) {
	alias GetCharacterPlacementW  GetCharacterPlacement;
}
else {
	alias GetCharacterPlacementA  GetCharacterPlacement;
}

struct WCRANGE {
    WCHAR  wcLow;
    USHORT cGlyphs;
}

typedef WCRANGE* PWCRANGE;
typedef WCRANGE* LPWCRANGE;

struct GLYPHSET {
    DWORD    cbThis;
    DWORD    flAccel;
    DWORD    cGlyphsSupported;
    DWORD    cRanges;
    WCRANGE  ranges[1];
}

typedef GLYPHSET* PGLYPHSET;
typedef GLYPHSET* LPGLYPHSET;

/* flAccel flags for the GLYPHSET structure above */

const auto GS_8BIT_INDICES     = 0x00000001;

/* flags for GetGlyphIndices */

const auto GGI_MARK_NONEXISTING_GLYPHS  = 0x0001;

DWORD GetFontUnicodeRanges(HDC hdc, LPGLYPHSET lpgs);
DWORD GetGlyphIndicesA(HDC hdc, LPCSTR lpstr,int c, LPWORD pgi,DWORD fl);
DWORD GetGlyphIndicesW(HDC hdc, LPCWSTR lpstr,int c, LPWORD pgi,DWORD fl);

version(UNICODE) {
	alias GetGlyphIndicesW  GetGlyphIndices;
}
else {
	alias GetGlyphIndicesA  GetGlyphIndices;
}

BOOL  GetTextExtentPointI(HDC hdc, LPWORD pgiIn,int cgi,LPSIZE psize);
BOOL  GetTextExtentExPointI ( HDC hdc,
                                                LPWORD lpwszString,
                                               int cwchString,
                                               int nMaxExtent,
                                                LPINT lpnFit,
                                                 LPINT lpnDx,
                                               LPSIZE lpSize
                                                );

BOOL  GetCharWidthI(  HDC hdc,
                                       UINT giFirst,
                                       UINT cgi,
                                        LPWORD pgi,
                                        LPINT piWidths
                                        );

BOOL  GetCharABCWidthsI(  HDC    hdc,
                                           UINT   giFirst,
                                           UINT   cgi,
                                            LPWORD pgi,
                                            LPABC  pabc
                                        );


const auto STAMP_DESIGNVECTOR  = (0x8000000 + cast(uint)'d' + (cast(uint)'v' << 8));
const auto STAMP_AXESLIST      = (0x8000000 + cast(uint)'a' + (cast(uint)'l' << 8));
const auto MM_MAX_NUMAXES      = 16;



struct DESIGNVECTOR {
    DWORD  dvReserved;
    DWORD  dvNumAxes;
    LONG   dvValues[MM_MAX_NUMAXES];
}

typedef DESIGNVECTOR* PDESIGNVECTOR;
typedef DESIGNVECTOR* LPDESIGNVECTOR;

int  AddFontResourceExA(LPCSTR name,DWORD fl,PVOID res);
int  AddFontResourceExW(LPCWSTR name,DWORD fl,PVOID res);

version(UNICODE) {
	alias AddFontResourceExW  AddFontResourceEx;
}
else {
	alias AddFontResourceExA  AddFontResourceEx;
}

BOOL RemoveFontResourceExA(LPCSTR name,DWORD fl,PVOID pdv);
BOOL RemoveFontResourceExW(LPCWSTR name,DWORD fl,PVOID pdv);

version(UNICODE) {
	alias RemoveFontResourceExW  RemoveFontResourceEx;
}
else {
	alias RemoveFontResourceExA  RemoveFontResourceEx;
}

HANDLE AddFontMemResourceEx(   PVOID pFileView,
                                               DWORD cjSize,
                                               PVOID pvResrved,
                                               DWORD* pNumFonts);

BOOL RemoveFontMemResourceEx(HANDLE h);
const auto FR_PRIVATE     = 0x10;
const auto FR_NOT_ENUM    = 0x20;

// The actual size of the DESIGNVECTOR and ENUMLOGFONTEXDV structures
// is determined by dvNumAxes,
// MM_MAX_NUMAXES only detemines the maximal size allowed

const auto MM_MAX_AXES_NAMELEN = 16;

struct AXISINFOA {
    LONG   axMinValue;
    LONG   axMaxValue;
    BYTE[MM_MAX_AXES_NAMELEN]   axAxisName;
}

typedef AXISINFOA* PAXISINFOA;
typedef AXISINFOA* LPAXISINFOA;

struct AXISINFOW {
    LONG   axMinValue;
    LONG   axMaxValue;
    WCHAR[MM_MAX_AXES_NAMELEN]  axAxisName;
}

typedef AXISINFOW* PAXISINFOW;
typedef AXISINFOW* LPAXISINFOW;

version(UNICODE) {
	typedef AXISINFOW AXISINFO;
	typedef PAXISINFOW PAXISINFO;
	typedef LPAXISINFOW LPAXISINFO;
}
else {
	typedef AXISINFOA AXISINFO;
	typedef PAXISINFOA PAXISINFO;
	typedef LPAXISINFOA LPAXISINFO;
}

struct AXESLISTA {
    DWORD     axlReserved;
    DWORD     axlNumAxes;
    AXISINFOA[MM_MAX_NUMAXES] axlAxisInfo;
}

typedef AXESLISTA* PAXESLISTA;
typedef AXESLISTA* LPAXESLISTA;

struct AXESLISTW {
    DWORD     axlReserved;
    DWORD     axlNumAxes;
    AXISINFOW[MM_MAX_NUMAXES] axlAxisInfo;
}

typedef AXESLISTW* PAXESLISTW;
typedef AXESLISTW* LPAXESLISTW;

version(UNICODE) {
	typedef AXESLISTW AXESLIST;
	typedef PAXESLISTW PAXESLIST;
	typedef LPAXESLISTW LPAXESLIST;
}
else {
	typedef AXESLISTA AXESLIST;
	typedef PAXESLISTA PAXESLIST;
	typedef LPAXESLISTA LPAXESLIST;
}

// The actual size of the AXESLIST and ENUMTEXTMETRIC structure is
// determined by axlNumAxes,
// MM_MAX_NUMAXES only detemines the maximal size allowed

struct ENUMLOGFONTEXDVA {
    ENUMLOGFONTEXA elfEnumLogfontEx;
    DESIGNVECTOR   elfDesignVector;
}

typedef ENUMLOGFONTEXDVA* PENUMLOGFONTEXDVA;
typedef ENUMLOGFONTEXDVA* LPENUMLOGFONTEXDVA;

struct ENUMLOGFONTEXDVW {
    ENUMLOGFONTEXW elfEnumLogfontEx;
    DESIGNVECTOR   elfDesignVector;
}

typedef ENUMLOGFONTEXDVW* PENUMLOGFONTEXDVW;
typedef ENUMLOGFONTEXDVW* LPENUMLOGFONTEXDVW;

version(UNICODE) {
	typedef ENUMLOGFONTEXDVW ENUMLOGFONTEXDV;
	typedef PENUMLOGFONTEXDVW PENUMLOGFONTEXDV;
	typedef LPENUMLOGFONTEXDVW LPENUMLOGFONTEXDV;
}
else {
	typedef ENUMLOGFONTEXDVA ENUMLOGFONTEXDV;
	typedef PENUMLOGFONTEXDVA PENUMLOGFONTEXDV;
	typedef LPENUMLOGFONTEXDVA LPENUMLOGFONTEXDV;
}

HFONT  CreateFontIndirectExA(ENUMLOGFONTEXDVA *);
HFONT  CreateFontIndirectExW(ENUMLOGFONTEXDVW *);

version(UNICODE) {
	alias CreateFontIndirectExW  CreateFontIndirectEx;
}
else {
	alias CreateFontIndirectExA  CreateFontIndirectEx;
}

struct ENUMTEXTMETRICA {
    NEWTEXTMETRICEXA etmNewTextMetricEx;
    AXESLISTA        etmAxesList;
}

typedef ENUMTEXTMETRICA* PENUMTEXTMETRICA;
typedef ENUMTEXTMETRICA* LPENUMTEXTMETRICA;

struct ENUMTEXTMETRICW {
    NEWTEXTMETRICEXW etmNewTextMetricEx;
    AXESLISTW        etmAxesList;
}

typedef ENUMTEXTMETRICW* PENUMTEXTMETRICW;
typedef ENUMTEXTMETRICW* LPENUMTEXTMETRICW;

version(UNICODE) {
	typedef ENUMTEXTMETRICW ENUMTEXTMETRIC;
	typedef PENUMTEXTMETRICW PENUMTEXTMETRIC;
	typedef LPENUMTEXTMETRICW LPENUMTEXTMETRIC;
}
else {
	typedef ENUMTEXTMETRICA ENUMTEXTMETRIC;
	typedef PENUMTEXTMETRICA PENUMTEXTMETRIC;
	typedef LPENUMTEXTMETRICA LPENUMTEXTMETRIC;
}

BOOL  GetViewportExtEx(HDC hdc,LPSIZE lpsize);
BOOL  GetViewportOrgEx(HDC hdc,LPPOINT lppoint);
BOOL  GetWindowExtEx(HDC hdc,LPSIZE lpsize);
BOOL  GetWindowOrgEx(HDC hdc,LPPOINT lppoint);

int  IntersectClipRect(HDC hdc,int left,int top,int right,int bottom);
BOOL InvertRgn(HDC hdc,HRGN hrgn);
BOOL LineDDA(int xStart,int yStart,int xEnd,int yEnd,LINEDDAPROC lpProc,LPARAM data);
BOOL LineTo(HDC hdc,int x,int y);
BOOL MaskBlt(HDC hdcDest,int xDest,int yDest,int width,int height,
             HDC hdcSrc,int xSrc,int ySrc,HBITMAP hbmMask,int xMask,int yMask,DWORD rop);
BOOL PlgBlt(HDC hdcDest, POINT * lpPoint,HDC hdcSrc,int xSrc,int ySrc,int width,
                    int height,HBITMAP hbmMask,int xMask,int yMask);

int  OffsetClipRgn(HDC hdc,int x,int y);
int  OffsetRgn(HRGN hrgn,int x,int y);
BOOL PatBlt(HDC hdc,int x,int y,int w,int h,DWORD rop);
BOOL Pie(HDC hdc,int left,int top,int right,int bottom,int xr1,int yr1,int xr2,int yr2);
BOOL PlayMetaFile(HDC hdc,HMETAFILE hmf);
BOOL PaintRgn(HDC hdc,HRGN hrgn);
BOOL PolyPolygon(HDC hdc, POINT *apt,  INT *asz, int csz);
BOOL PtInRegion(HRGN hrgn,int x,int y);
BOOL PtVisible(HDC hdc,int x,int y);
BOOL RectInRegion(HRGN hrgn,RECT * lprect);
BOOL RectVisible(HDC hdc,RECT * lprect);
BOOL Rectangle(HDC hdc,int left,int top,int right,int bottom);
BOOL RestoreDC(HDC hdc,int nSavedDC);
HDC  ResetDCA(HDC hdc,DEVMODEA * lpdm);
HDC  ResetDCW(HDC hdc,DEVMODEW * lpdm);

version(UNICODE) {
	alias ResetDCW  ResetDC;
}
else {
	alias ResetDCA  ResetDC;
}

UINT RealizePalette(HDC hdc);
BOOL RemoveFontResourceA(LPCSTR lpFileName);
BOOL RemoveFontResourceW(LPCWSTR lpFileName);

version(UNICODE) {
	alias RemoveFontResourceW  RemoveFontResource;
}
else {
	alias RemoveFontResourceA  RemoveFontResource;
}

BOOL  RoundRect(HDC hdc,int left,int top,int right,int bottom,int width,int height);
BOOL ResizePalette(HPALETTE hpal,UINT n);

int  SaveDC(HDC hdc);
int  SelectClipRgn(HDC hdc,HRGN hrgn);
int  ExtSelectClipRgn(HDC hdc,HRGN hrgn,int mode);
int  SetMetaRgn(HDC hdc);
HGDIOBJ SelectObject(HDC hdc,HGDIOBJ h);
HPALETTE SelectPalette(HDC hdc,HPALETTE hPal,BOOL bForceBkgd);
COLORREF SetBkColor(HDC hdc,COLORREF color);

COLORREF SetDCBrushColor(HDC hdc,COLORREF color);
COLORREF SetDCPenColor(HDC hdc,COLORREF color);

int   SetBkMode(HDC hdc,int mode);

LONG SetBitmapBits(
   HBITMAP hbm,
   DWORD cb,
    VOID *pvBits);

UINT  SetBoundsRect(HDC hdc,RECT * lprect,UINT flags);
int   SetDIBits(HDC hdc,HBITMAP hbm,UINT start,UINT cLines,VOID *lpBits,BITMAPINFO * lpbmi,UINT ColorUse);
int   SetDIBitsToDevice(HDC hdc,int xDest,int yDest,DWORD w,DWORD h,int xSrc,
       int ySrc,UINT StartScan,UINT cLines,VOID * lpvBits,BITMAPINFO * lpbmi,UINT ColorUse);
DWORD SetMapperFlags(HDC hdc,DWORD flags);
int   SetGraphicsMode(HDC hdc,int iMode);
int   SetMapMode(HDC hdc,int iMode);

DWORD SetLayout(HDC hdc,DWORD l);
DWORD GetLayout(HDC hdc);

HMETAFILE   SetMetaFileBitsEx(UINT cbBuffer, BYTE *lpData);
UINT  SetPaletteEntries(  HPALETTE hpal,
                                           UINT iStart,
                                           UINT cEntries,
                                            PALETTEENTRY *pPalEntries);
COLORREF SetPixel(HDC hdc,int x,int y,COLORREF color);
BOOL   SetPixelV(HDC hdc,int x,int y,COLORREF color);
BOOL  SetPixelFormat(HDC hdc,int format,PIXELFORMATDESCRIPTOR * ppfd);
int   SetPolyFillMode(HDC hdc,int mode);
BOOL  StretchBlt(HDC hdcDest,int xDest,int yDest,int wDest,int hDest,HDC hdcSrc,int xSrc,int ySrc,int wSrc,int hSrc,DWORD rop);
BOOL   SetRectRgn(HRGN hrgn,int left,int top,int right,int bottom);
int   StretchDIBits(HDC hdc,int xDest,int yDest,int DestWidth,int DestHeight,int xSrc,int ySrc,int SrcWidth,int SrcHeight,
       VOID * lpBits,BITMAPINFO * lpbmi,UINT iUsage,DWORD rop);
int   SetROP2(HDC hdc,int rop2);
int   SetStretchBltMode(HDC hdc,int mode);
UINT  SetSystemPaletteUse(HDC hdc,UINT use);
int   SetTextCharacterExtra(HDC hdc,int extra);
COLORREF SetTextColor(HDC hdc,COLORREF color);
UINT  SetTextAlign(HDC hdc,UINT _align);
BOOL  SetTextJustification(HDC hdc,int extra,int count);
BOOL  UpdateColors(HDC hdc);

typedef PVOID function(DWORD dwSize, LPVOID pGdiRef) GDIMARSHALLOC;

typedef HRESULT function(HGDIOBJ hGdiObj,LPVOID pGdiRef,LPVOID *ppDDrawRef) DDRAWMARSHCALLBACKMARSHAL;
typedef HRESULT function(LPVOID pData,HDC *phdc,LPVOID *ppDDrawRef) DDRAWMARSHCALLBACKUNMARSHAL;
typedef HRESULT function(LPVOID pDDrawRef) DDRAWMARSHCALLBACKRELEASE;

const auto GDIREGISTERDDRAWPACKETVERSION   = 0x1;

struct GDIREGISTERDDRAWPACKET {
    DWORD                       dwSize;
    DWORD                       dwVersion;
    DDRAWMARSHCALLBACKMARSHAL   pfnDdMarshal;
    DDRAWMARSHCALLBACKUNMARSHAL pfnDdUnmarshal;
    DDRAWMARSHCALLBACKRELEASE   pfnDdRelease;
}

typedef GDIREGISTERDDRAWPACKET* PGDIREGISTERDDRAWPACKET;

BOOL      GdiRegisterDdraw(PGDIREGISTERDDRAWPACKET pPacket,GDIMARSHALLOC *ppfnGdiAlloc);

ULONG     GdiMarshalSize();
VOID      GdiMarshal(DWORD dwProcessIdTo,HGDIOBJ hGdiObj,PVOID pData, ULONG ulFlags);
HGDIOBJ   GdiUnmarshal(PVOID pData, ULONG ulFlags);

//
// image blt
//

typedef USHORT COLOR16;

struct TRIVERTEX {
    LONG    x;
    LONG    y;
    COLOR16 Red;
    COLOR16 Green;
    COLOR16 Blue;
    COLOR16 Alpha;
}

typedef TRIVERTEX* PTRIVERTEX;
typedef TRIVERTEX* LPTRIVERTEX;

struct GRADIENT_TRIANGLE {
    ULONG Vertex1;
    ULONG Vertex2;
    ULONG Vertex3;
}

typedef GRADIENT_TRIANGLE* PGRADIENT_TRIANGLE;
typedef GRADIENT_TRIANGLE* LPGRADIENT_TRIANGLE;

struct GRADIENT_RECT {
    ULONG UpperLeft;
    ULONG LowerRight;
}

typedef GRADIENT_RECT* PGRADIENT_RECT;
typedef GRADIENT_RECT* LPGRADIENT_RECT;

struct BLENDFUNCTION {
    BYTE   BlendOp;
    BYTE   BlendFlags;
    BYTE   SourceConstantAlpha;
    BYTE   AlphaFormat;
}

typedef BLENDFUNCTION* PBLENDFUNCTION;
typedef BLENDFUNCTION* LPBLENDFUNCTION;

//
// currentlly defined blend function
//

const auto AC_SRC_OVER                 = 0x00;

//
// alpha format flags
//

const auto AC_SRC_ALPHA                = 0x01;

BOOL AlphaBlend(HDC hdcDest,int xoriginDest,int yoriginDest,int wDest,int hDest,HDC hdcSrc,int xoriginSrc,int yoriginSrc,int wSrc,int hSrc,BLENDFUNCTION ftn);

BOOL TransparentBlt(HDC hdcDest,int xoriginDest,int yoriginDest,int wDest,int hDest,HDC hdcSrc,
                                          int xoriginSrc,int yoriginSrc,int wSrc,int hSrc,UINT crTransparent);


//
// gradient drawing modes
//

const auto GRADIENT_FILL_RECT_H    = 0x00000000;
const auto GRADIENT_FILL_RECT_V    = 0x00000001;
const auto GRADIENT_FILL_TRIANGLE  = 0x00000002;
const auto GRADIENT_FILL_OP_FLAG   = 0x000000ff;

BOOL GradientFill(
   HDC hdc,
   PTRIVERTEX pVertex,
   ULONG nVertex,
   PVOID pMesh,
   ULONG nMesh,
   ULONG ulMode
    );

BOOL  GdiAlphaBlend(HDC hdcDest,int xoriginDest,int yoriginDest,int wDest,int hDest,HDC hdcSrc,int xoriginSrc,int yoriginSrc,int wSrc,int hSrc,BLENDFUNCTION ftn);

BOOL  GdiTransparentBlt(HDC hdcDest,int xoriginDest,int yoriginDest,int wDest,int hDest,HDC hdcSrc,
                                          int xoriginSrc,int yoriginSrc,int wSrc,int hSrc,UINT crTransparent);

BOOL  GdiGradientFill(HDC hdc,
                                        PTRIVERTEX pVertex,
                                       ULONG nVertex,
                                       PVOID pMesh,
                                       ULONG nCount,
                                       ULONG ulMode);



BOOL  PlayMetaFileRecord( HDC hdc,
	LPHANDLETABLE lpHandleTable,
	LPMETARECORD lpMR,
	UINT noObjs);

typedef int function(HDC hdc, HANDLETABLE* lpht,METARECORD* lpMR,int nObj,LPARAM param) MFENUMPROC;
BOOL  EnumMetaFile(HDC hdc,HMETAFILE hmf,MFENUMPROC proc,LPARAM param);

typedef int function (HDC hdc, HANDLETABLE* lpht,ENHMETARECORD * lpmr,int hHandles,LPARAM data) ENHMFENUMPROC;

// Enhanced Metafile Function Declarations

HENHMETAFILE CloseEnhMetaFile(HDC hdc);
HENHMETAFILE CopyEnhMetaFileA(HENHMETAFILE hEnh,LPCSTR lpFileName);
HENHMETAFILE CopyEnhMetaFileW(HENHMETAFILE hEnh,LPCWSTR lpFileName);

version(UNICODE) {
	alias CopyEnhMetaFileW  CopyEnhMetaFile;
}
else {
	alias CopyEnhMetaFileA  CopyEnhMetaFile;
}

HDC   CreateEnhMetaFileA(HDC hdc,LPCSTR lpFilename,RECT *lprc,LPCSTR lpDesc);
HDC   CreateEnhMetaFileW(HDC hdc,LPCWSTR lpFilename,RECT *lprc,LPCWSTR lpDesc);

version(UNICODE) {
	alias CreateEnhMetaFileW  CreateEnhMetaFile;
}
else {
	alias CreateEnhMetaFileA  CreateEnhMetaFile;
}

BOOL  DeleteEnhMetaFile(HENHMETAFILE hmf);
BOOL  EnumEnhMetaFile(HDC hdc,HENHMETAFILE hmf,ENHMFENUMPROC proc,
                                       LPVOID param,RECT * lpRect);
HENHMETAFILE  GetEnhMetaFileA(LPCSTR lpName);
HENHMETAFILE  GetEnhMetaFileW(LPCWSTR lpName);

version(UNICODE) {
	alias GetEnhMetaFileW  GetEnhMetaFile;
}
else {
	alias GetEnhMetaFileA  GetEnhMetaFile;
}

UINT  GetEnhMetaFileBits( HENHMETAFILE hEMF,
                                           UINT nSize,LPBYTE lpData);
UINT  GetEnhMetaFileDescriptionA( HENHMETAFILE hemf,
                                                   UINT cchBuffer,
                                                    LPSTR lpDescription);
UINT  GetEnhMetaFileDescriptionW( HENHMETAFILE hemf,
                                                   UINT cchBuffer,
                                                    LPWSTR lpDescription);

version(UNICODE) {
	alias GetEnhMetaFileDescriptionW  GetEnhMetaFileDescription;
}
else {
	alias GetEnhMetaFileDescriptionA  GetEnhMetaFileDescription;
}

UINT  GetEnhMetaFileHeader(   HENHMETAFILE hemf,
                                               UINT nSize,
                                                LPENHMETAHEADER lpEnhMetaHeader);
UINT  GetEnhMetaFilePaletteEntries(HENHMETAFILE hemf,
                                                   UINT nNumEntries,
                                                    LPPALETTEENTRY lpPaletteEntries);

UINT  GetEnhMetaFilePixelFormat(  HENHMETAFILE hemf,
                                                   UINT cbBuffer,
                                                    PIXELFORMATDESCRIPTOR *ppfd);
UINT  GetWinMetaFileBits( HENHMETAFILE hemf,
                                           UINT cbData16,LPBYTE pData16,
                                           INT iMapMode,
                                           HDC hdcRef);
BOOL  PlayEnhMetaFile(HDC hdc,HENHMETAFILE hmf,RECT * lprect);
BOOL  PlayEnhMetaFileRecord(  HDC hdc,
                                                LPHANDLETABLE pht,
                                               ENHMETARECORD *pmr,
                                               UINT cht);

HENHMETAFILE  SetEnhMetaFileBits( UINT nSize,
                                                    BYTE * pb);

HENHMETAFILE  SetWinMetaFileBits( UINT nSize,
                                                    BYTE *lpMeta16Data,
                                                   HDC hdcRef,
                                                   METAFILEPICT *lpMFP);
BOOL  GdiComment(HDC hdc,UINT nSize, BYTE *lpData);

BOOL GetTextMetricsA(HDC hdc,LPTEXTMETRICA lptm);
BOOL GetTextMetricsW(HDC hdc,LPTEXTMETRICW lptm);

version(UNICODE) {
	alias GetTextMetricsW  GetTextMetrics;
}
else {
	alias GetTextMetricsA  GetTextMetrics;
}

/* new GDI */

struct DIBSECTION {
    BITMAP       dsBm;
    BITMAPINFOHEADER    dsBmih;
    DWORD               dsBitfields[3];
    HANDLE              dshSection;
    DWORD               dsOffset;
}

typedef DIBSECTION* PDIBSECTION;
typedef DIBSECTION* LPDIBSECTION;


BOOL AngleArc(HDC hdc,int x,int y,DWORD r,FLOAT StartAngle,FLOAT SweepAngle);
BOOL PolyPolyline(HDC hdc,POINT *apt, DWORD *asz,DWORD csz);
BOOL GetWorldTransform(HDC hdc,LPXFORM lpxf);
BOOL SetWorldTransform(HDC hdc,XFORM * lpxf);
BOOL ModifyWorldTransform(HDC hdc,XFORM * lpxf,DWORD mode);
BOOL CombineTransform(LPXFORM lpxfOut,XFORM *lpxf1,XFORM *lpxf2);
HBITMAP CreateDIBSection(HDC hdc,BITMAPINFO *lpbmi,UINT usage,VOID **ppvBits,HANDLE hSection,DWORD offset);
UINT GetDIBColorTable(HDC  hdc,
                                       UINT iStart,
                                       UINT cEntries,
                                        RGBQUAD *prgbq);
UINT SetDIBColorTable(HDC  hdc,
                                       UINT iStart,
                                       UINT cEntries,
                                        RGBQUAD *prgbq);

/* Flags value for COLORADJUSTMENT */
const auto CA_NEGATIVE                 = 0x0001;
const auto CA_LOG_FILTER               = 0x0002;

/* IlluminantIndex values */
const auto ILLUMINANT_DEVICE_DEFAULT   = 0;
const auto ILLUMINANT_A                = 1;
const auto ILLUMINANT_B                = 2;
const auto ILLUMINANT_C                = 3;
const auto ILLUMINANT_D50              = 4;
const auto ILLUMINANT_D55              = 5;
const auto ILLUMINANT_D65              = 6;
const auto ILLUMINANT_D75              = 7;
const auto ILLUMINANT_F2               = 8;
const auto ILLUMINANT_MAX_INDEX        = ILLUMINANT_F2;

const auto ILLUMINANT_TUNGSTEN         = ILLUMINANT_A;
const auto ILLUMINANT_DAYLIGHT         = ILLUMINANT_C;
const auto ILLUMINANT_FLUORESCENT      = ILLUMINANT_F2;
const auto ILLUMINANT_NTSC             = ILLUMINANT_C;

/* Min and max for RedGamma, GreenGamma, BlueGamma */
const auto RGB_GAMMA_MIN               = 02500;
const auto RGB_GAMMA_MAX               = 65000;

/* Min and max for ReferenceBlack and ReferenceWhite */
const auto REFERENCE_WHITE_MIN         = 6000;
const auto REFERENCE_WHITE_MAX         = 10000;
const auto REFERENCE_BLACK_MIN         = 0;
const auto REFERENCE_BLACK_MAX         = 4000;

/* Min and max for Contrast, Brightness, Colorfulness, RedGreenTint */
const auto COLOR_ADJ_MIN               = -100;
const auto COLOR_ADJ_MAX               = 100;

struct  COLORADJUSTMENT {
    WORD   caSize;
    WORD   caFlags;
    WORD   caIlluminantIndex;
    WORD   caRedGamma;
    WORD   caGreenGamma;
    WORD   caBlueGamma;
    WORD   caReferenceBlack;
    WORD   caReferenceWhite;
    SHORT  caContrast;
    SHORT  caBrightness;
    SHORT  caColorfulness;
    SHORT  caRedGreenTint;
}

typedef COLORADJUSTMENT* PCOLORADJUSTMENT;
typedef COLORADJUSTMENT* LPCOLORADJUSTMENT;

BOOL SetColorAdjustment(HDC hdc,COLORADJUSTMENT *lpca);
BOOL GetColorAdjustment(HDC hdc,LPCOLORADJUSTMENT lpca);
HPALETTE CreateHalftonePalette(HDC hdc);

typedef BOOL function(HDC, int) ABORTPROC;

struct DOCINFOA {
    int     cbSize;
    LPCSTR   lpszDocName;
    LPCSTR   lpszOutput;
    LPCSTR   lpszDatatype;
    DWORD    fwType;
}

typedef DOCINFOA* LPDOCINFOA;

struct DOCINFOW {
    int     cbSize;
    LPCWSTR  lpszDocName;
    LPCWSTR  lpszOutput;
    LPCWSTR  lpszDatatype;
    DWORD    fwType;
}

typedef DOCINFOW* LPDOCINFOW;

version(UNICODE) {
	typedef DOCINFOW DOCINFO;
	typedef LPDOCINFOW LPDOCINFO;
}
else {
	typedef DOCINFOA DOCINFO;
	typedef LPDOCINFOA LPDOCINFO;
}

const auto DI_APPBANDING               = 0x00000001;
const auto DI_ROPS_READ_DESTINATION    = 0x00000002;

int StartDocA(HDC hdc,DOCINFOA *lpdi);
int StartDocW(HDC hdc,DOCINFOW *lpdi);

version(UNICODE) {
	alias StartDocW  StartDoc;
}
else {
	alias StartDocA  StartDoc;
}

int EndDoc(HDC hdc);
int StartPage(HDC hdc);
int EndPage(HDC hdc);
int AbortDoc(HDC hdc);
int SetAbortProc(HDC hdc,ABORTPROC proc);

BOOL AbortPath(HDC hdc);
BOOL ArcTo(HDC hdc,int left,int top,int right,int bottom,int xr1,int yr1,int xr2,int yr2);
BOOL BeginPath(HDC hdc);
BOOL CloseFigure(HDC hdc);
BOOL EndPath(HDC hdc);
BOOL FillPath(HDC hdc);
BOOL FlattenPath(HDC hdc);
int  GetPath(HDC hdc, LPPOINT apt, LPBYTE aj, int cpt);
HRGN PathToRegion(HDC hdc);
BOOL PolyDraw(HDC hdc, POINT * apt, BYTE * aj,int cpt);
BOOL SelectClipPath(HDC hdc,int mode);
int  SetArcDirection(HDC hdc,int dir);
BOOL SetMiterLimit(HDC hdc,FLOAT limit, PFLOAT old);
BOOL StrokeAndFillPath(HDC hdc);
BOOL StrokePath(HDC hdc);
BOOL WidenPath(HDC hdc);
HPEN ExtCreatePen(DWORD iPenStyle,
                                   DWORD cWidth,
                                   LOGBRUSH *plbrush,
                                   DWORD cStyle,
                                    DWORD *pstyle);
BOOL GetMiterLimit(HDC hdc,PFLOAT plimit);
int  GetArcDirection(HDC hdc);

int   GetObjectA(HANDLE h,int c, LPVOID pv);
int   GetObjectW(HANDLE h,int c, LPVOID pv);

version(UNICODE) {
	alias GetObjectW  GetObject;
}
else {
	alias GetObjectA  GetObject;
}

BOOL  MoveToEx(HDC hdc,int x,int y, LPPOINT lppt);
BOOL  TextOutA(HDC hdc,int x,int y, LPCSTR lpString,int c);
BOOL  TextOutW(HDC hdc,int x,int y, LPCWSTR lpString,int c);

version(UNICODE) {
	alias TextOutW  TextOut;
}
else {
	alias TextOutA  TextOut;
}

BOOL  ExtTextOutA(HDC hdc,int x,int y,UINT options,RECT * lprect, LPCSTR lpString,UINT c, INT * lpDx);
BOOL  ExtTextOutW(HDC hdc,int x,int y,UINT options,RECT * lprect, LPCWSTR lpString,UINT c, INT * lpDx);

version(UNICODE) {
	alias ExtTextOutW  ExtTextOut;
}
else {
	alias ExtTextOutA  ExtTextOut;
}

BOOL  PolyTextOutA(HDC hdc, POLYTEXTA * ppt,int nstrings);
BOOL  PolyTextOutW(HDC hdc, POLYTEXTW * ppt,int nstrings);

version(UNICODE) {
	alias PolyTextOutW  PolyTextOut;
}
else {
	alias PolyTextOutA  PolyTextOut;
}

HRGN  CreatePolygonRgn(    POINT *pptl,
                                           int cPoint,
                                           int iMode);
BOOL  DPtoLP(HDC hdc, LPPOINT lppt,int c);
BOOL  LPtoDP(HDC hdc, LPPOINT lppt,int c);
BOOL  Polygon(HDC hdc, POINT *apt,int cpt);
BOOL  Polyline(HDC hdc, POINT *apt,int cpt);

BOOL  PolyBezier(HDC hdc, POINT * apt,DWORD cpt);
BOOL  PolyBezierTo(HDC hdc, POINT * apt,DWORD cpt);
BOOL  PolylineTo(HDC hdc, POINT * apt,DWORD cpt);

BOOL  SetViewportExtEx(HDC hdc,int x,int y, LPSIZE lpsz);
BOOL  SetViewportOrgEx(HDC hdc,int x,int y, LPPOINT lppt);
BOOL  SetWindowExtEx(HDC hdc,int x,int y, LPSIZE lpsz);
BOOL  SetWindowOrgEx(HDC hdc,int x,int y, LPPOINT lppt);

BOOL  OffsetViewportOrgEx(HDC hdc,int x,int y, LPPOINT lppt);
BOOL  OffsetWindowOrgEx(HDC hdc,int x,int y, LPPOINT lppt);
BOOL  ScaleViewportExtEx(HDC hdc,int xn,int dx,int yn,int yd, LPSIZE lpsz);
BOOL  ScaleWindowExtEx(HDC hdc,int xn,int xd,int yn,int yd, LPSIZE lpsz);
BOOL  SetBitmapDimensionEx(HBITMAP hbm,int w,int h, LPSIZE lpsz);
BOOL  SetBrushOrgEx(HDC hdc,int x,int y, LPPOINT lppt);

int   GetTextFaceA(HDC hdc,int c, LPSTR lpName);
int   GetTextFaceW(HDC hdc,int c, LPWSTR lpName);

version(UNICODE) {
	alias GetTextFaceW  GetTextFace;
}
else {
	alias GetTextFaceA  GetTextFace;
}

const auto FONTMAPPER_MAX = 10;

struct KERNINGPAIR {
   WORD wFirst;
   WORD wSecond;
   int  iKernAmount;
}

typedef KERNINGPAIR* LPKERNINGPAIR;

DWORD GetKerningPairsA(   HDC hdc,
                                           DWORD nPairs,
                                            LPKERNINGPAIR   lpKernPair);
DWORD GetKerningPairsW(   HDC hdc,
                                           DWORD nPairs,
                                            LPKERNINGPAIR   lpKernPair);
version(UNICODE) {
	alias GetKerningPairsW  GetKerningPairs;
}
else {
	alias GetKerningPairsA  GetKerningPairs;
}


BOOL  GetDCOrgEx(HDC hdc,LPPOINT lppt);
BOOL  FixBrushOrgEx(HDC hdc,int x,int y, LPPOINT ptl);
BOOL  UnrealizeObject(HGDIOBJ h);

BOOL  GdiFlush();
DWORD GdiSetBatchLimit(DWORD dw);
DWORD GdiGetBatchLimit();

const auto ICM_OFF               = 1;
const auto ICM_ON                = 2;
const auto ICM_QUERY             = 3;
const auto ICM_DONE_OUTSIDEDC    = 4;

typedef int function(LPSTR, LPARAM) ICMENUMPROCA;
typedef int function(LPWSTR, LPARAM) ICMENUMPROCW;

version(UNICODE) {
	alias ICMENUMPROCW  ICMENUMPROC;
}
else {
	alias ICMENUMPROCA  ICMENUMPROC;
}

int         SetICMMode(HDC hdc,int mode);
BOOL        CheckColorsInGamut(   HDC hdc,
                                                    LPRGBTRIPLE lpRGBTriple,
                                                    LPVOID dlpBuffer,
                                                   DWORD nCount);

HCOLORSPACE GetColorSpace(HDC hdc);
BOOL        GetLogColorSpaceA(HCOLORSPACE hColorSpace,
                                                LPLOGCOLORSPACEA lpBuffer,
                                               DWORD nSize);
BOOL        GetLogColorSpaceW(HCOLORSPACE hColorSpace,
                                                LPLOGCOLORSPACEW lpBuffer,
                                               DWORD nSize);
version(UNICODE) {
	alias GetLogColorSpaceW  GetLogColorSpace;
}
else {
	alias GetLogColorSpaceA  GetLogColorSpace;
}

HCOLORSPACE CreateColorSpaceA(LPLOGCOLORSPACEA lplcs);
HCOLORSPACE CreateColorSpaceW(LPLOGCOLORSPACEW lplcs);

version(UNICODE) {
	alias CreateColorSpaceW  CreateColorSpace;
}
else {
	alias CreateColorSpaceA  CreateColorSpace;
}

HCOLORSPACE SetColorSpace(HDC hdc,HCOLORSPACE hcs);
BOOL        DeleteColorSpace(HCOLORSPACE hcs);
BOOL        GetICMProfileA(   HDC hdc,
                                               LPDWORD pBufSize,
                                                LPSTR pszFilename);
BOOL        GetICMProfileW(   HDC hdc,
                                               LPDWORD pBufSize,
                                                LPWSTR pszFilename);

version(UNICODE) {
	alias GetICMProfileW  GetICMProfile;
}
else {
	alias GetICMProfileA  GetICMProfile;
}

BOOL        SetICMProfileA(HDC hdc,LPSTR lpFileName);
BOOL        SetICMProfileW(HDC hdc,LPWSTR lpFileName);

version(UNICODE) {
	alias SetICMProfileW  SetICMProfile;
}
else {
	alias SetICMProfileA  SetICMProfile;
}

BOOL        GetDeviceGammaRamp(HDC hdc, LPVOID lpRamp);
BOOL        SetDeviceGammaRamp(HDC hdc, LPVOID lpRamp);
BOOL        ColorMatchToTarget(HDC hdc,HDC hdcTarget,DWORD action);
int         EnumICMProfilesA(HDC hdc,ICMENUMPROCA proc,LPARAM param);
int         EnumICMProfilesW(HDC hdc,ICMENUMPROCW proc,LPARAM param);

version(UNICODE) {
	alias EnumICMProfilesW  EnumICMProfilesW;
}
else {
	alias EnumICMProfilesA  EnumICMProfilesA;
}

// The Win95 update API UpdateICMRegKeyA is deprecated to set last error to ERROR_NOT_SUPPORTED and return FALSE
BOOL        UpdateICMRegKeyA(DWORD reserved,LPSTR lpszCMID,LPSTR lpszFileName,UINT command);
// The Win95 update API UpdateICMRegKeyW is deprecated to set last error to ERROR_NOT_SUPPORTED and return FALSE
BOOL        UpdateICMRegKeyW(DWORD reserved,LPWSTR lpszCMID,LPWSTR lpszFileName,UINT command);

version(UNICODE) {
	alias UpdateICMRegKeyW  UpdateICMRegKey;
}
else {
	alias UpdateICMRegKeyA  UpdateICMRegKey;
}
BOOL        ColorCorrectPalette(HDC hdc,HPALETTE hPal,DWORD deFirst,DWORD num);

// Enhanced metafile constants.
const auto ENHMETA_SIGNATURE       = 0x20454D46;

// Stock object flag used in the object handle index in the enhanced
// metafile records.
// E.g. The object handle index (META_STOCK_OBJECT | BLACK_BRUSH)
// represents the stock object BLACK_BRUSH.

const auto ENHMETA_STOCK_OBJECT    = 0x80000000;

// Enhanced metafile record types.

const auto EMR_HEADER                      = 1;
const auto EMR_POLYBEZIER                  = 2;
const auto EMR_POLYGON                     = 3;
const auto EMR_POLYLINE                    = 4;
const auto EMR_POLYBEZIERTO                = 5;
const auto EMR_POLYLINETO                  = 6;
const auto EMR_POLYPOLYLINE                = 7;
const auto EMR_POLYPOLYGON                 = 8;
const auto EMR_SETWINDOWEXTEX              = 9;
const auto EMR_SETWINDOWORGEX              = 10;
const auto EMR_SETVIEWPORTEXTEX            = 11;
const auto EMR_SETVIEWPORTORGEX            = 12;
const auto EMR_SETBRUSHORGEX               = 13;
const auto EMR_EOF                         = 14;
const auto EMR_SETPIXELV                   = 15;
const auto EMR_SETMAPPERFLAGS              = 16;
const auto EMR_SETMAPMODE                  = 17;
const auto EMR_SETBKMODE                   = 18;
const auto EMR_SETPOLYFILLMODE             = 19;
const auto EMR_SETROP2                     = 20;
const auto EMR_SETSTRETCHBLTMODE           = 21;
const auto EMR_SETTEXTALIGN                = 22;
const auto EMR_SETCOLORADJUSTMENT          = 23;
const auto EMR_SETTEXTCOLOR                = 24;
const auto EMR_SETBKCOLOR                  = 25;
const auto EMR_OFFSETCLIPRGN               = 26;
const auto EMR_MOVETOEX                    = 27;
const auto EMR_SETMETARGN                  = 28;
const auto EMR_EXCLUDECLIPRECT             = 29;
const auto EMR_INTERSECTCLIPRECT           = 30;
const auto EMR_SCALEVIEWPORTEXTEX          = 31;
const auto EMR_SCALEWINDOWEXTEX            = 32;
const auto EMR_SAVEDC                      = 33;
const auto EMR_RESTOREDC                   = 34;
const auto EMR_SETWORLDTRANSFORM           = 35;
const auto EMR_MODIFYWORLDTRANSFORM        = 36;
const auto EMR_SELECTOBJECT                = 37;
const auto EMR_CREATEPEN                   = 38;
const auto EMR_CREATEBRUSHINDIRECT         = 39;
const auto EMR_DELETEOBJECT                = 40;
const auto EMR_ANGLEARC                    = 41;
const auto EMR_ELLIPSE                     = 42;
const auto EMR_RECTANGLE                   = 43;
const auto EMR_ROUNDRECT                   = 44;
const auto EMR_ARC                         = 45;
const auto EMR_CHORD                       = 46;
const auto EMR_PIE                         = 47;
const auto EMR_SELECTPALETTE               = 48;
const auto EMR_CREATEPALETTE               = 49;
const auto EMR_SETPALETTEENTRIES           = 50;
const auto EMR_RESIZEPALETTE               = 51;
const auto EMR_REALIZEPALETTE              = 52;
const auto EMR_EXTFLOODFILL                = 53;
const auto EMR_LINETO                      = 54;
const auto EMR_ARCTO                       = 55;
const auto EMR_POLYDRAW                    = 56;
const auto EMR_SETARCDIRECTION             = 57;
const auto EMR_SETMITERLIMIT               = 58;
const auto EMR_BEGINPATH                   = 59;
const auto EMR_ENDPATH                     = 60;
const auto EMR_CLOSEFIGURE                 = 61;
const auto EMR_FILLPATH                    = 62;
const auto EMR_STROKEANDFILLPATH           = 63;
const auto EMR_STROKEPATH                  = 64;
const auto EMR_FLATTENPATH                 = 65;
const auto EMR_WIDENPATH                   = 66;
const auto EMR_SELECTCLIPPATH              = 67;
const auto EMR_ABORTPATH                   = 68;

const auto EMR_GDICOMMENT                  = 70;
const auto EMR_FILLRGN                     = 71;
const auto EMR_FRAMERGN                    = 72;
const auto EMR_INVERTRGN                   = 73;
const auto EMR_PAINTRGN                    = 74;
const auto EMR_EXTSELECTCLIPRGN            = 75;
const auto EMR_BITBLT                      = 76;
const auto EMR_STRETCHBLT                  = 77;
const auto EMR_MASKBLT                     = 78;
const auto EMR_PLGBLT                      = 79;
const auto EMR_SETDIBITSTODEVICE           = 80;
const auto EMR_STRETCHDIBITS               = 81;
const auto EMR_EXTCREATEFONTINDIRECTW      = 82;
const auto EMR_EXTTEXTOUTA                 = 83;
const auto EMR_EXTTEXTOUTW                 = 84;
const auto EMR_POLYBEZIER16                = 85;
const auto EMR_POLYGON16                   = 86;
const auto EMR_POLYLINE16                  = 87;
const auto EMR_POLYBEZIERTO16              = 88;
const auto EMR_POLYLINETO16                = 89;
const auto EMR_POLYPOLYLINE16              = 90;
const auto EMR_POLYPOLYGON16               = 91;
const auto EMR_POLYDRAW16                  = 92;
const auto EMR_CREATEMONOBRUSH             = 93;
const auto EMR_CREATEDIBPATTERNBRUSHPT     = 94;
const auto EMR_EXTCREATEPEN                = 95;
const auto EMR_POLYTEXTOUTA                = 96;
const auto EMR_POLYTEXTOUTW                = 97;

const auto EMR_SETICMMODE                  = 98;
const auto EMR_CREATECOLORSPACE            = 99;
const auto EMR_SETCOLORSPACE              = 100;
const auto EMR_DELETECOLORSPACE           = 101;
const auto EMR_GLSRECORD                  = 102;
const auto EMR_GLSBOUNDEDRECORD           = 103;
const auto EMR_PIXELFORMAT                = 104;

const auto EMR_RESERVED_105               = 105;
const auto EMR_RESERVED_106               = 106;
const auto EMR_RESERVED_107               = 107;
const auto EMR_RESERVED_108               = 108;
const auto EMR_RESERVED_109               = 109;
const auto EMR_RESERVED_110               = 110;
const auto EMR_COLORCORRECTPALETTE        = 111;
const auto EMR_SETICMPROFILEA             = 112;
const auto EMR_SETICMPROFILEW             = 113;
const auto EMR_ALPHABLEND                 = 114;
const auto EMR_SETLAYOUT                  = 115;
const auto EMR_TRANSPARENTBLT             = 116;
const auto EMR_RESERVED_117               = 117;
const auto EMR_GRADIENTFILL               = 118;
const auto EMR_RESERVED_119               = 119;
const auto EMR_RESERVED_120               = 120;
const auto EMR_COLORMATCHTOTARGETW        = 121;
const auto EMR_CREATECOLORSPACEW          = 122;

const auto EMR_MIN                          = 1;

const auto EMR_MAX                        = 122;

// Base record type for the enhanced metafile.

struct EMR {
    DWORD   iType;              // Enhanced metafile record type
    DWORD   nSize;              // Length of the record in bytes.
                                // This must be a multiple of 4.
}

typedef EMR* PEMR;
typedef EMR* LPEMR;

// Base text record type for the enhanced metafile.

struct EMRTEXT {
    POINTL  ptlReference;
    DWORD   nChars;
    DWORD   offString;          // Offset to the string
    DWORD   fOptions;
    RECTL   rcl;
    DWORD   offDx;              // Offset to the inter-character spacing array.
                                // This is always given.
}

typedef EMRTEXT* PEMRTEXT;
typedef EMRTEXT* LPEMRTEXT;

// Record structures for the enhanced metafile.

struct ABORTPATH {
    EMR     emr;
}

typedef ABORTPATH EMRABORTPATH;
typedef ABORTPATH* PEMRABORTPATH;
typedef ABORTPATH* LPEMRABORTPATH;

typedef ABORTPATH EMRBEGINPATH;
typedef ABORTPATH* PEMRBEGINPATH;
typedef ABORTPATH* LPEMRBEGINPATH;

typedef ABORTPATH EMRENDPATH;
typedef ABORTPATH* PEMRENDPATH;
typedef ABORTPATH* LPEMRENDPATH;

typedef ABORTPATH EMRCLOSEFIGURE;
typedef ABORTPATH* PEMRCLOSEFIGURE;
typedef ABORTPATH* LPEMRCLOSEFIGURE;

typedef ABORTPATH EMRFLATTENPATH;
typedef ABORTPATH* PEMRFLATTENPATH;
typedef ABORTPATH* LPEMRFLATTENPATH;

typedef ABORTPATH EMRWIDENPATH;
typedef ABORTPATH* PEMRWIDENPATH;
typedef ABORTPATH* LPEMRWIDENPATH;

typedef ABORTPATH EMRSETMETARGN;
typedef ABORTPATH* PEMRSETMETARGN;
typedef ABORTPATH* LPEMRSETMETARGN;

typedef ABORTPATH EMRSAVEDC;
typedef ABORTPATH* PEMRSAVEDC;
typedef ABORTPATH* LPEMRSAVEDC;

typedef ABORTPATH EMRREALIZEPALETTE;
typedef ABORTPATH* PEMRREALIZEPALETTE;
typedef ABORTPATH* LPEMRREALIZEPALETTE;

struct EMRSELECTCLIPPATH {
    EMR     emr;
    DWORD   iMode;
}

typedef EMRSELECTCLIPPATH* PEMRSELECTCLIPPATH;
typedef EMRSELECTCLIPPATH* LPEMRSELECTCLIPPATH;

typedef EMRSELECTCLIPPATH EMRSETBKMODE;
typedef EMRSELECTCLIPPATH* PEMRSETBKMODE;
typedef EMRSELECTCLIPPATH* LPEMRSETBKMODE;

typedef EMRSELECTCLIPPATH EMRSETLAYOUT;
typedef EMRSELECTCLIPPATH* PEMRSETLAYOUT;
typedef EMRSELECTCLIPPATH* LPEMRSETLAYOUT;

typedef EMRSELECTCLIPPATH EMRSETPOLYFILLMODE;
typedef EMRSELECTCLIPPATH* PEMRSETPOLYFILLMODE;
typedef EMRSELECTCLIPPATH* LPEMRSETPOLYFILLMODE;

typedef EMRSELECTCLIPPATH EMRSETROP2;
typedef EMRSELECTCLIPPATH* PEMRSETROP2;
typedef EMRSELECTCLIPPATH* LPEMRSETROP2;

typedef EMRSELECTCLIPPATH EMRSETSTRETCHBLTMODE;
typedef EMRSELECTCLIPPATH* PEMRSETSTRETCHBLTMODE;
typedef EMRSELECTCLIPPATH* LPEMRSETSTRETCHBLTMODE;

typedef EMRSELECTCLIPPATH EMRSETICMMODE;
typedef EMRSELECTCLIPPATH* PEMRSETICMMODE;
typedef EMRSELECTCLIPPATH* LPEMRSETICMMODE;

typedef EMRSELECTCLIPPATH EMRSETTEXTALIGN;
typedef EMRSELECTCLIPPATH* PEMRSETTEXTALIGN;
typedef EMRSELECTCLIPPATH* LPEMRSETTEXTALIGN;

struct EMRSETMITERLIMIT {
    EMR     emr;
    FLOAT   eMiterLimit;
}

typedef EMRSETMITERLIMIT* PEMRSETMITERLIMIT;
typedef EMRSETMITERLIMIT* LPEMRSETMITERLIMIT;

struct EMRRESTOREDC {
    EMR     emr;
    LONG    iRelative;          // Specifies a relative instance
}

typedef EMRRESTOREDC* PEMRRESTOREDC;
typedef EMRRESTOREDC* LPEMRRESTOREDC;

struct EMRSETARCDIRECTION {
    EMR     emr;
    DWORD   iArcDirection;      // Specifies the arc direction in the
                                // advanced graphics mode.
}

typedef EMRSETARCDIRECTION* PEMRSETARCDIRECTION;
typedef EMRSETARCDIRECTION* LPEMRSETARCDIRECTION;

struct EMRSETMAPPERFLAGS {
    EMR     emr;
    DWORD   dwFlags;
}

typedef EMRSETMAPPERFLAGS* PEMRSETMAPPERFLAGS;
typedef EMRSETMAPPERFLAGS* LPEMRSETMAPPERFLAGS;

struct EMRSETTEXTCOLOR {
    EMR     emr;
    COLORREF crColor;
}

typedef EMRSETTEXTCOLOR EMRSETBKCOLOR;
typedef EMRSETTEXTCOLOR* PEMRSETBKCOLOR;
typedef EMRSETTEXTCOLOR* LPEMRSETBKCOLOR;

typedef EMRSETTEXTCOLOR* PEMRSETTEXTCOLOR;
typedef EMRSETTEXTCOLOR* LPEMRSETTEXTCOLOR;

struct EMRSELECTOBJECT {
    EMR     emr;
    DWORD   ihObject;           // Object handle index
}

typedef EMRSELECTOBJECT* PEMRSELECTOBJECT;
typedef EMRSELECTOBJECT* LPEMRSELECTOBJECT;

typedef EMRSELECTOBJECT EMRDELETEOBJECT;
typedef EMRSELECTOBJECT* PEMRDELETEOBJECT;
typedef EMRSELECTOBJECT* LPEMRDELETEOBJECT;

struct EMRSELECTPALETTE {
    EMR     emr;
    DWORD   ihPal;              // Palette handle index, background mode only
}

typedef EMRSELECTPALETTE* PEMRSELECTPALETTE;
typedef EMRSELECTPALETTE* LPEMRSELECTPALETTE;

struct EMRRESIZEPALETTE {
    EMR     emr;
    DWORD   ihPal;              // Palette handle index
    DWORD   cEntries;
}

typedef EMRRESIZEPALETTE* PEMRRESIZEPALETTE;
typedef EMRRESIZEPALETTE* LPEMRRESIZEPALETTE;

struct EMRSETPALETTEENTRIES {
    EMR     emr;
    DWORD   ihPal;              // Palette handle index
    DWORD   iStart;
    DWORD   cEntries;
    PALETTEENTRY[1] aPalEntries;// The peFlags fields do not contain any flags
}

typedef EMRSETPALETTEENTRIES* PEMRSETPALETTEENTRIES;
typedef EMRSETPALETTEENTRIES* LPEMRSETPALETTEENTRIES;

struct EMRSETCOLORADJUSTMENT {
    EMR     emr;
    COLORADJUSTMENT ColorAdjustment;
}

typedef EMRSETCOLORADJUSTMENT* PEMRSETCOLORADJUSTMENT;
typedef EMRSETCOLORADJUSTMENT* LPEMRSETCOLORADJUSTMENT;

struct EMRGDICOMMENT {
    EMR     emr;
    DWORD   cbData;             // Size of data in bytes
    BYTE[1]    Data;
}

typedef EMRGDICOMMENT* PEMRGDICOMMENT;
typedef EMRGDICOMMENT* LPEMRGDICOMMENT;

struct EMREOF {
    EMR     emr;
    DWORD   nPalEntries;        // Number of palette entries
    DWORD   offPalEntries;      // Offset to the palette entries
    DWORD   nSizeLast;          // Same as nSize and must be the last DWORD
                                // of the record.  The palette entries,
                                // if exist, precede this field.
}

typedef EMREOF* PEMREOF;
typedef EMREOF* LPEMREOF;

struct EMRLINETO {
    EMR     emr;
    POINTL  ptl;
}

typedef EMRLINETO* PEMRLINETO;
typedef EMRLINETO* LPEMRLINETO;

typedef EMRLINETO EMRLINETOEX;
typedef EMRLINETO* PEMRLINETOEX;
typedef EMRLINETO* LPEMRLINETOEX;

struct EMROFFSETCLIPRGN {
    EMR     emr;
    POINTL  ptlOffset;
}

typedef EMROFFSETCLIPRGN* PEMROFFSETCLIPRGN;

struct EMRFILLPATH {
    EMR     emr;
    RECTL   rclBounds;          // Inclusive-inclusive bounds in device units
}

typedef EMRFILLPATH* PEMRFILLPATH;
typedef EMRFILLPATH* LPEMRFILLPATH;

typedef EMRFILLPATH EMRSTROKEANDFILLPATH;
typedef EMRFILLPATH* PEMRSTROKEANDFILLPATH;
typedef EMRFILLPATH* LPEMRSTROKEANDFILLPATH;

typedef EMRFILLPATH EMRSTROKEPATH;
typedef EMRFILLPATH* PEMRSTROKEPATH;
typedef EMRFILLPATH* LPEMRSTROKEPATH;

struct EMREXCLUDECLIPRECT {
    EMR     emr;
    RECTL   rclClip;
}

typedef EMREXCLUDECLIPRECT* PEMREXCLUDECLIPRECT;
typedef EMREXCLUDECLIPRECT* LPEMREXCLUDECLIPRECT;

typedef EMREXCLUDECLIPRECT EMRINTERSECTCLIPRECT;
typedef EMREXCLUDECLIPRECT* PEMRINTERSECTCLIPRECT;
typedef EMREXCLUDECLIPRECT* LPEMRINTERSECTCLIPRECT;

struct EMRSETVIEWPORTORGEX {
    EMR     emr;
    POINTL  ptlOrigin;
}

typedef EMRSETVIEWPORTORGEX* PEMRSETVIEWPORTORGEX;
typedef EMRSETVIEWPORTORGEX* LPEMRSETVIEWPORTORGEX;

typedef EMRSETVIEWPORTORGEX EMRSETWINDOWORGEX;
typedef EMRSETVIEWPORTORGEX* PEMRSETWINDOWORGEX;
typedef EMRSETVIEWPORTORGEX* LPEMRSETWINDOWORGEX;

typedef EMRSETVIEWPORTORGEX EMRSETBRUSHORGEX;
typedef EMRSETVIEWPORTORGEX* PEMRSETBRUSHORGEX;
typedef EMRSETVIEWPORTORGEX* LPEMRSETBRUSHORGEX;

struct EMRSETVIEWPORTEXTEX {
    EMR     emr;
    SIZEL   szlExtent;
}

typedef EMRSETVIEWPORTEXTEX* PEMRSETVIEWPORTEXTEX;
typedef EMRSETVIEWPORTEXTEX* LPEMRSETVIEWPORTEXTEX;

typedef EMRSETVIEWPORTORGEX EMRSETWINDOWEXTEX;
typedef EMRSETVIEWPORTORGEX* PEMRSETWINDOWEXTEX;
typedef EMRSETVIEWPORTORGEX* LPEMRSETWINDOWEXTEX;

struct EMRSCALEVIEWPORTEXTEX {
    EMR     emr;
    LONG    xNum;
    LONG    xDenom;
    LONG    yNum;
    LONG    yDenom;
}

typedef EMRSCALEVIEWPORTEXTEX* PEMRSCALEVIEWPORTEXTEX;
typedef EMRSCALEVIEWPORTEXTEX* LPEMRSCALEVIEWPORTEXTEX;

typedef EMRSCALEVIEWPORTEXTEX EMRSCALEWINDOWEXTEX;
typedef EMRSCALEVIEWPORTEXTEX* PEMRSCALEWINDOWEXTEX;
typedef EMRSCALEVIEWPORTEXTEX* LPEMRSCALEWINDOWEXTEX;

struct EMRSETWORLDTRANSFORM {
    EMR     emr;
    XFORM   xform;
}

typedef EMRSETWORLDTRANSFORM* PEMRSETWORLDTRANSFORM;
typedef EMRSETWORLDTRANSFORM* LPEMRSETWORLDTRANSFORM;

struct EMRMODIFYWORLDTRANSFORM {
    EMR     emr;
    XFORM   xform;
    DWORD   iMode;
}

typedef EMRMODIFYWORLDTRANSFORM* PEMRMODIFYWORLDTRANSFORM;

struct EMRSETPIXELV {
    EMR     emr;
    POINTL  ptlPixel;
    COLORREF crColor;
}

typedef EMRSETPIXELV* PEMRSETPIXELV;

struct EMREXTFLOODFILL {
    EMR     emr;
    POINTL  ptlStart;
    COLORREF crColor;
    DWORD   iMode;
}

typedef EMREXTFLOODFILL* PEMREXTFLOODFILL;

struct EMRELLIPSE {
    EMR     emr;
    RECTL   rclBox;             // Inclusive-inclusive bounding rectangle
}

typedef EMRELLIPSE* PEMRELLIPSE;
typedef EMRELLIPSE* LPEMRELLIPSE;

typedef EMRELLIPSE EMRRECTANGLE;
typedef EMRELLIPSE* PEMRRECTANGLE;
typedef EMRELLIPSE* LPEMRRECTANGLE;

struct EMRROUNDRECT {
    EMR     emr;
    RECTL   rclBox;             // Inclusive-inclusive bounding rectangle
    SIZEL   szlCorner;
}

typedef EMRROUNDRECT* PEMRROUNDRECT;

struct EMRARC {
    EMR     emr;
    RECTL   rclBox;             // Inclusive-inclusive bounding rectangle
    POINTL  ptlStart;
    POINTL  ptlEnd;
}

typedef EMRARC* PEMRARC;
typedef EMRARC* LPEMRARC;

typedef EMRARC EMRARCTO;
typedef EMRARC* PEMRARCTO;
typedef EMRARC* LPEMRARCTO;

typedef EMRARC EMRCHORD;
typedef EMRARC* PEMRCHORD;
typedef EMRARC* LPEMRCHORD;

typedef EMRARC EMRPIE;
typedef EMRARC* PEMRPIE;
typedef EMRARC* LPEMRPIE;

struct EMRANGLEARC {
    EMR     emr;
    POINTL  ptlCenter;
    DWORD   nRadius;
    FLOAT   eStartAngle;
    FLOAT   eSweepAngle;
}

typedef EMRANGLEARC* PEMRANGLEARC;

struct EMRPOLYLINE {
    EMR     emr;
    RECTL   rclBounds;          // Inclusive-inclusive bounds in device units
    DWORD   cptl;
    POINTL[1]  aptl;
}

typedef EMRPOLYLINE* PEMRPOLYLINE;
typedef EMRPOLYLINE* LPEMRPOLYLINE;

typedef EMRPOLYLINE EMRPOLYBEZIER;
typedef EMRPOLYLINE* PEMRPOLYBEZIER;
typedef EMRPOLYLINE* LPEMRPOLYBEZIER;

typedef EMRPOLYLINE EMRPOLYGON;
typedef EMRPOLYLINE* PEMRPOLYGON;
typedef EMRPOLYLINE* LPEMRPOLYGON;

typedef EMRPOLYLINE EMRPOLYBEZIERTO;
typedef EMRPOLYLINE* PEMRPOLYBEZIERTO;
typedef EMRPOLYLINE* LPEMRPOLYBEZIERTO;

typedef EMRPOLYLINE EMRPOLYLINETO;
typedef EMRPOLYLINE* PEMRPOLYLINETO;
typedef EMRPOLYLINE* LPEMRPOLYLINETO;

struct EMRPOLYLINE16 {
    EMR     emr;
    RECTL   rclBounds;          // Inclusive-inclusive bounds in device units
    DWORD   cpts;
    POINTS[1]  apts;
}

typedef EMRPOLYLINE16* PEMRPOLYLINE16;
typedef EMRPOLYLINE16* LPEMRPOLYLINE16;

typedef EMRPOLYLINE16 EMRPOLYBEZIER16;
typedef EMRPOLYLINE16* PEMRPOLYBEZIER16;
typedef EMRPOLYLINE16* LPEMRPOLYBEZIER16;

typedef EMRPOLYLINE16 EMRPOLYGON16;
typedef EMRPOLYLINE16* PEMRPOLYGON16;
typedef EMRPOLYLINE16* LPEMRPOLYGON16;

typedef EMRPOLYLINE16 EMRPOLYBEZIERTO16;
typedef EMRPOLYLINE16* PEMRPOLYBEZIERTO16;
typedef EMRPOLYLINE16* LPEMRPOLYBEZIERTO16;

typedef EMRPOLYLINE16 EMRPOLYLINETO16;
typedef EMRPOLYLINE16* PEMRPOLYLINETO16;
typedef EMRPOLYLINE16* LPEMRPOLYLINETO16;

struct EMRPOLYDRAW {
    EMR     emr;
    RECTL   rclBounds;          // Inclusive-inclusive bounds in device units
    DWORD   cptl;               // Number of points
    POINTL[1]  aptl;            // Array of points
    BYTE[1]    abTypes;         // Array of point types
}

typedef EMRPOLYDRAW* PEMRPOLYDRAW;
typedef EMRPOLYDRAW* LPEMRPOLYDRAW;

struct EMRPOLYDRAW16 {
    EMR     emr;
    RECTL   rclBounds;          // Inclusive-inclusive bounds in device units
    DWORD   cpts;               // Number of points
    POINTS[1]  apts;            // Array of points
    BYTE[1]   abTypes;         // Array of point types
}

typedef EMRPOLYDRAW16* PEMRPOLYDRAW16;
typedef EMRPOLYDRAW16* LPEMRPOLYDRAW16;

struct EMRPOLYPOLYLINE {
    EMR     emr;
    RECTL   rclBounds;          // Inclusive-inclusive bounds in device units
    DWORD   nPolys;             // Number of polys
    DWORD   cptl;               // Total number of points in all polys
    DWORD[1]   aPolyCounts;     // Array of point counts for each poly
    POINTL[1]  aptl;            // Array of points
}

typedef EMRPOLYPOLYLINE* PEMRPOLYPOLYLINE;
typedef EMRPOLYPOLYLINE* LPEMRPOLYPOLYLINE;

typedef EMRPOLYPOLYLINE EMRPOLYPOLYGON;
typedef EMRPOLYPOLYLINE* PEMRPOLYPOLYGON;
typedef EMRPOLYPOLYLINE* LPEMRPOLYPOLYGON;

struct EMRPOLYPOLYLINE16 {
    EMR     emr;
    RECTL   rclBounds;          // Inclusive-inclusive bounds in device units
    DWORD   nPolys;             // Number of polys
    DWORD   cpts;               // Total number of points in all polys
    DWORD[1]   aPolyCounts;     // Array of point counts for each poly
    POINTS[1]  apts;            // Array of points
}

typedef EMRPOLYPOLYLINE16* PEMRPOLYPOLYLINE16;
typedef EMRPOLYPOLYLINE16* LPEMRPOLYPOLYLINE16;

typedef EMRPOLYPOLYLINE16 EMRPOLYPOLYGON16;
typedef EMRPOLYPOLYLINE16* PEMRPOLYPOLYGON16;
typedef EMRPOLYPOLYLINE16* LPEMRPOLYPOLYGON16;

struct EMRINVERTRGN {
    EMR     emr;
    RECTL   rclBounds;          // Inclusive-inclusive bounds in device units
    DWORD   cbRgnData;          // Size of region data in bytes
    BYTE[1]    RgnData;
}

typedef EMRINVERTRGN* PEMRINVERTRGN;
typedef EMRINVERTRGN* LPEMRINVERTRGN;

typedef EMRINVERTRGN EMRPAINTRGN;
typedef EMRINVERTRGN* PEMRPAINTRGN;
typedef EMRINVERTRGN* LPEMRPAINTRGN;

struct EMRFILLRGN {
    EMR     emr;
    RECTL   rclBounds;          // Inclusive-inclusive bounds in device units
    DWORD   cbRgnData;          // Size of region data in bytes
    DWORD   ihBrush;            // Brush handle index
    BYTE[1]    RgnData;
}

typedef EMRFILLRGN* PEMRFILLRGN;
typedef EMRFILLRGN* LPEMRFILLRGN;

struct EMRFRAMERGN {
    EMR     emr;
    RECTL   rclBounds;          // Inclusive-inclusive bounds in device units
    DWORD   cbRgnData;          // Size of region data in bytes
    DWORD   ihBrush;            // Brush handle index
    SIZEL   szlStroke;
    BYTE[1]    RgnData;
}

typedef EMRFRAMERGN* PEMRFRAMERGN;
typedef EMRFRAMERGN* LPEMRFRAMERGN;

struct EMREXTSELECTCLIPRGN {
    EMR     emr;
    DWORD   cbRgnData;          // Size of region data in bytes
    DWORD   iMode;
    BYTE[1]    RgnData;
}

typedef EMREXTSELECTCLIPRGN* PEMREXTSELECTCLIPRGN;
typedef EMREXTSELECTCLIPRGN* LPEMREXTSELECTCLIPRGN;

struct EMREXTTEXTOUTA {
    EMR     emr;
    RECTL   rclBounds;          // Inclusive-inclusive bounds in device units
    DWORD   iGraphicsMode;      // Current graphics mode
    FLOAT   exScale;            // X and Y scales from Page units to .01mm units
    FLOAT   eyScale;            //   if graphics mode is GM_COMPATIBLE.
    EMRTEXT emrtext;            // This is followed by the string and spacing
                                // array
}

typedef EMREXTTEXTOUTA* PEMREXTTEXTOUTA;
typedef EMREXTTEXTOUTA* LPEMREXTTEXTOUTA;

typedef EMREXTTEXTOUTA EMREXTTEXTOUTW;
typedef EMREXTTEXTOUTA* PEMREXTTEXTOUTW;
typedef EMREXTTEXTOUTA* LPEMREXTTEXTOUTW;

struct EMRPOLYTEXTOUTA {
    EMR     emr;
    RECTL   rclBounds;          // Inclusive-inclusive bounds in device units
    DWORD   iGraphicsMode;      // Current graphics mode
    FLOAT   exScale;            // X and Y scales from Page units to .01mm units
    FLOAT   eyScale;            //   if graphics mode is GM_COMPATIBLE.
    LONG    cStrings;
    EMRTEXT[1] aemrtext;        // Array of EMRTEXT structures.  This is
                                // followed by the strings and spacing arrays.
}

typedef EMRPOLYTEXTOUTA* PEMRPOLYTEXTOUTA;
typedef EMRPOLYTEXTOUTA* LPEMRPOLYTEXTOUTA;

typedef EMRPOLYTEXTOUTA EMRPOLYTEXTOUTW;
typedef EMRPOLYTEXTOUTA* PEMRPOLYTEXTOUTW;
typedef EMRPOLYTEXTOUTA* LPEMRPOLYTEXTOUTW;

struct EMRBITBLT {
    EMR     emr;
    RECTL   rclBounds;          // Inclusive-inclusive bounds in device units
    LONG    xDest;
    LONG    yDest;
    LONG    cxDest;
    LONG    cyDest;
    DWORD   dwRop;
    LONG    xSrc;
    LONG    ySrc;
    XFORM   xformSrc;           // Source DC transform
    COLORREF crBkColorSrc;      // Source DC BkColor in RGB
    DWORD   iUsageSrc;          // Source bitmap info color table usage
                                // (DIB_RGB_COLORS)
    DWORD   offBmiSrc;          // Offset to the source BITMAPINFO structure
    DWORD   cbBmiSrc;           // Size of the source BITMAPINFO structure
    DWORD   offBitsSrc;         // Offset to the source bitmap bits
    DWORD   cbBitsSrc;          // Size of the source bitmap bits
}

typedef EMRBITBLT* PEMRBITBLT;
typedef EMRBITBLT* LPEMRBITBLT;

struct EMRSTRETCHBLT {
    EMR     emr;
    RECTL   rclBounds;          // Inclusive-inclusive bounds in device units
    LONG    xDest;
    LONG    yDest;
    LONG    cxDest;
    LONG    cyDest;
    DWORD   dwRop;
    LONG    xSrc;
    LONG    ySrc;
    XFORM   xformSrc;           // Source DC transform
    COLORREF crBkColorSrc;      // Source DC BkColor in RGB
    DWORD   iUsageSrc;          // Source bitmap info color table usage
                                // (DIB_RGB_COLORS)
    DWORD   offBmiSrc;          // Offset to the source BITMAPINFO structure
    DWORD   cbBmiSrc;           // Size of the source BITMAPINFO structure
    DWORD   offBitsSrc;         // Offset to the source bitmap bits
    DWORD   cbBitsSrc;          // Size of the source bitmap bits
    LONG    cxSrc;
    LONG    cySrc;
}

typedef EMRSTRETCHBLT* PEMRSTRETCHBLT;
typedef EMRSTRETCHBLT* LPEMRSTRETCHBLT;

struct EMRMASKBLT {
    EMR     emr;
    RECTL   rclBounds;          // Inclusive-inclusive bounds in device units
    LONG    xDest;
    LONG    yDest;
    LONG    cxDest;
    LONG    cyDest;
    DWORD   dwRop;
    LONG    xSrc;
    LONG    ySrc;
    XFORM   xformSrc;           // Source DC transform
    COLORREF crBkColorSrc;      // Source DC BkColor in RGB
    DWORD   iUsageSrc;          // Source bitmap info color table usage
                                // (DIB_RGB_COLORS)
    DWORD   offBmiSrc;          // Offset to the source BITMAPINFO structure
    DWORD   cbBmiSrc;           // Size of the source BITMAPINFO structure
    DWORD   offBitsSrc;         // Offset to the source bitmap bits
    DWORD   cbBitsSrc;          // Size of the source bitmap bits
    LONG    xMask;
    LONG    yMask;
    DWORD   iUsageMask;         // Mask bitmap info color table usage
    DWORD   offBmiMask;         // Offset to the mask BITMAPINFO structure if any
    DWORD   cbBmiMask;          // Size of the mask BITMAPINFO structure if any
    DWORD   offBitsMask;        // Offset to the mask bitmap bits if any
    DWORD   cbBitsMask;         // Size of the mask bitmap bits if any
}

typedef EMRMASKBLT* PEMRMASKBLT;
typedef EMRMASKBLT* LPEMRMASKBLT;

struct EMRPLGBLT {
    EMR     emr;
    RECTL   rclBounds;          // Inclusive-inclusive bounds in device units
    POINTL[3] aptlDest;
    LONG    xSrc;
    LONG    ySrc;
    LONG    cxSrc;
    LONG    cySrc;
    XFORM   xformSrc;           // Source DC transform
    COLORREF crBkColorSrc;      // Source DC BkColor in RGB
    DWORD   iUsageSrc;          // Source bitmap info color table usage
                                // (DIB_RGB_COLORS)
    DWORD   offBmiSrc;          // Offset to the source BITMAPINFO structure
    DWORD   cbBmiSrc;           // Size of the source BITMAPINFO structure
    DWORD   offBitsSrc;         // Offset to the source bitmap bits
    DWORD   cbBitsSrc;          // Size of the source bitmap bits
    LONG    xMask;
    LONG    yMask;
    DWORD   iUsageMask;         // Mask bitmap info color table usage
    DWORD   offBmiMask;         // Offset to the mask BITMAPINFO structure if any
    DWORD   cbBmiMask;          // Size of the mask BITMAPINFO structure if any
    DWORD   offBitsMask;        // Offset to the mask bitmap bits if any
    DWORD   cbBitsMask;         // Size of the mask bitmap bits if any
}

typedef EMRPLGBLT* PEMRPLGBLT;
typedef EMRPLGBLT* LPEMRPLGBLT;

struct EMRSETDIBITSTODEVICE {
    EMR     emr;
    RECTL   rclBounds;          // Inclusive-inclusive bounds in device units
    LONG    xDest;
    LONG    yDest;
    LONG    xSrc;
    LONG    ySrc;
    LONG    cxSrc;
    LONG    cySrc;
    DWORD   offBmiSrc;          // Offset to the source BITMAPINFO structure
    DWORD   cbBmiSrc;           // Size of the source BITMAPINFO structure
    DWORD   offBitsSrc;         // Offset to the source bitmap bits
    DWORD   cbBitsSrc;          // Size of the source bitmap bits
    DWORD   iUsageSrc;          // Source bitmap info color table usage
    DWORD   iStartScan;
    DWORD   cScans;
}

typedef EMRSETDIBITSTODEVICE* PEMRSETDIBITSTODEVICE;
typedef EMRSETDIBITSTODEVICE* LPEMRSETDIBITSTODEVICE;

struct EMRSTRETCHDIBITS {
    EMR     emr;
    RECTL   rclBounds;          // Inclusive-inclusive bounds in device units
    LONG    xDest;
    LONG    yDest;
    LONG    xSrc;
    LONG    ySrc;
    LONG    cxSrc;
    LONG    cySrc;
    DWORD   offBmiSrc;          // Offset to the source BITMAPINFO structure
    DWORD   cbBmiSrc;           // Size of the source BITMAPINFO structure
    DWORD   offBitsSrc;         // Offset to the source bitmap bits
    DWORD   cbBitsSrc;          // Size of the source bitmap bits
    DWORD   iUsageSrc;          // Source bitmap info color table usage
    DWORD   dwRop;
    LONG    cxDest;
    LONG    cyDest;
}

typedef EMRSTRETCHDIBITS* PEMRSTRETCHDIBITS;
typedef EMRSTRETCHDIBITS* LPEMRSTRETCHDIBITS;

struct EMREXTCREATEFONTINDIRECTW {
    EMR     emr;
    DWORD   ihFont;             // Font handle index
    EXTLOGFONTW elfw;
} 

typedef EMREXTCREATEFONTINDIRECTW* PEMREXTCREATEFONTINDIRECTW;
typedef EMREXTCREATEFONTINDIRECTW* LPEMREXTCREATEFONTINDIRECTW;

struct EMRCREATEPALETTE {
    EMR     emr;
    DWORD   ihPal;              // Palette handle index
    LOGPALETTE lgpl;            // The peFlags fields in the palette entries
                                // do not contain any flags
}

typedef EMRCREATEPALETTE* PEMRCREATEPALETTE;
typedef EMRCREATEPALETTE* LPEMRCREATEPALETTE;

struct EMRCREATEPEN {
    EMR     emr;
    DWORD   ihPen;              // Pen handle index
    LOGPEN  lopn;
}

typedef EMRCREATEPEN* PEMRCREATEPEN;
typedef EMRCREATEPEN* LPEMRCREATEPEN;

struct EMREXTCREATEPEN {
    EMR     emr;
    DWORD   ihPen;              // Pen handle index
    DWORD   offBmi;             // Offset to the BITMAPINFO structure if any
    DWORD   cbBmi;              // Size of the BITMAPINFO structure if any
                                // The bitmap info is followed by the bitmap
                                // bits to form a packed DIB.
    DWORD   offBits;            // Offset to the brush bitmap bits if any
    DWORD   cbBits;             // Size of the brush bitmap bits if any
    EXTLOGPEN elp;              // The extended pen with the style array.
}

typedef EMREXTCREATEPEN* PEMREXTCREATEPEN;
typedef EMREXTCREATEPEN* LPEMREXTCREATEPEN;

struct EMRCREATEBRUSHINDIRECT {
    EMR        emr;
    DWORD      ihBrush;          // Brush handle index
    LOGBRUSH32 lb;               // The style must be BS_SOLID, BS_HOLLOW,
                                 // BS_NULL or BS_HATCHED.
}

typedef EMRCREATEBRUSHINDIRECT* PEMRCREATEBRUSHINDIRECT;
typedef EMRCREATEBRUSHINDIRECT* LPEMRCREATEBRUSHINDIRECT;

struct EMRCREATEMONOBRUSH {
    EMR     emr;
    DWORD   ihBrush;            // Brush handle index
    DWORD   iUsage;             // Bitmap info color table usage
    DWORD   offBmi;             // Offset to the BITMAPINFO structure
    DWORD   cbBmi;              // Size of the BITMAPINFO structure
    DWORD   offBits;            // Offset to the bitmap bits
    DWORD   cbBits;             // Size of the bitmap bits
}

typedef EMRCREATEMONOBRUSH* PEMRCREATEMONOBRUSH;
typedef EMRCREATEMONOBRUSH* LPEMRCREATEMONOBRUSH;

struct EMRCREATEDIBPATTERNBRUSHPT {
    EMR     emr;
    DWORD   ihBrush;            // Brush handle index
    DWORD   iUsage;             // Bitmap info color table usage
    DWORD   offBmi;             // Offset to the BITMAPINFO structure
    DWORD   cbBmi;              // Size of the BITMAPINFO structure
                                // The bitmap info is followed by the bitmap
                                // bits to form a packed DIB.
    DWORD   offBits;            // Offset to the bitmap bits
    DWORD   cbBits;             // Size of the bitmap bits
}

typedef EMRCREATEDIBPATTERNBRUSHPT* PEMRCREATEDIBPATTERNBRUSHPT;
typedef EMRCREATEDIBPATTERNBRUSHPT* LPEMRCREATEDIBPATTERNBRUSHPT;

struct EMRFORMAT {
    DWORD   dSignature;         // Format signature, e.g. ENHMETA_SIGNATURE.
    DWORD   nVersion;           // Format version number.
    DWORD   cbData;             // Size of data in bytes.
    DWORD   offData;            // Offset to data from GDICOMMENT_IDENTIFIER.
                                // It must begin at a DWORD offset.
}

typedef EMRFORMAT* PEMRFORMAT;
typedef EMRFORMAT* LPEMRFORMAT;

struct EMRGLSRECORD {
    EMR     emr;
    DWORD   cbData;             // Size of data in bytes
    BYTE[1]    Data;
}

typedef EMRGLSRECORD* PEMRGLSRECORD;
typedef EMRGLSRECORD* LPEMRGLSRECORD;

struct EMRGLSBOUNDEDRECORD {
    EMR     emr;
    RECTL   rclBounds;          // Bounds in recording coordinates
    DWORD   cbData;             // Size of data in bytes
    BYTE[1]    Data;
}

typedef EMRGLSBOUNDEDRECORD* PEMRGLSBOUNDEDRECORD;
typedef EMRGLSBOUNDEDRECORD* LPEMRGLSBOUNDEDRECORD;

struct EMRPIXELFORMAT {
    EMR     emr;
    PIXELFORMATDESCRIPTOR pfd;
}

typedef EMRPIXELFORMAT* PEMRPIXELFORMAT;
typedef EMRPIXELFORMAT* LPEMRPIXELFORMAT;

struct EMRCREATECOLORSPACE {
    EMR             emr;
    DWORD           ihCS;       // ColorSpace handle index
    LOGCOLORSPACEA  lcs;        // Ansi version of LOGCOLORSPACE
}

typedef EMRCREATECOLORSPACE* PEMRCREATECOLORSPACE;
typedef EMRCREATECOLORSPACE* LPEMRCREATECOLORSPACE;

struct EMRSETCOLORSPACE {
    EMR     emr;
    DWORD   ihCS;               // ColorSpace handle index
}

typedef EMRSETCOLORSPACE* PEMRSETCOLORSPACE;
typedef EMRSETCOLORSPACE* LPEMRSETCOLORSPACE;

typedef EMRSETCOLORSPACE EMRSELECTCOLORSPACE;
typedef EMRSETCOLORSPACE* PEMRSELECTCOLORSPACE;
typedef EMRSETCOLORSPACE* LPEMRSELECTCOLORSPACE;

typedef EMRSETCOLORSPACE EMRDELETECOLORSPACE;
typedef EMRSETCOLORSPACE* PEMRDELETECOLORSPACE;
typedef EMRSETCOLORSPACE* LPEMRDELETECOLORSPACE;

struct EMREXTESCAPE {
    EMR     emr;
    INT     iEscape;            // Escape code
    INT     cbEscData;          // Size of escape data
    BYTE[1]    EscData;         // Escape data
}

typedef EMREXTESCAPE* PEMREXTESCAPE;
typedef EMREXTESCAPE* LPEMREXTESCAPE;

typedef EMREXTESCAPE EMRDRAWESCAPE;
typedef EMREXTESCAPE* PEMRDRAWESCAPE;
typedef EMREXTESCAPE* LPEMRDRAWESCAPE;

struct EMRNAMEDESCAPE {
    EMR     emr;
    INT     iEscape;            // Escape code
    INT     cbDriver;           // Size of driver name
    INT     cbEscData;          // Size of escape data
    BYTE[1]    EscData;         // Driver name and Escape data
}

typedef EMRNAMEDESCAPE* PEMRNAMEDESCAPE;
typedef EMRNAMEDESCAPE* LPEMRNAMEDESCAPE;

const auto SETICMPROFILE_EMBEDED           = 0x00000001;

struct EMRSETICMPROFILE {
    EMR     emr;
    DWORD   dwFlags;            // flags
    DWORD   cbName;             // Size of desired profile name
    DWORD   cbData;             // Size of raw profile data if attached
    BYTE[1]    Data;            // Array size is cbName + cbData
}

typedef EMRSETICMPROFILE* PEMRSETICMPROFILE;
typedef EMRSETICMPROFILE* LPEMRSETICMPROFILE;

typedef EMRSETICMPROFILE EMRSETICMPROFILEA;
typedef EMRSETICMPROFILE* PEMRSETICMPROFILEA;
typedef EMRSETICMPROFILE* LPEMRSETICMPROFILEA;

typedef EMRSETICMPROFILE EMRSETICMPROFILEW;
typedef EMRSETICMPROFILE* PEMRSETICMPROFILEW;
typedef EMRSETICMPROFILE* LPEMRSETICMPROFILEW;

const auto CREATECOLORSPACE_EMBEDED        = 0x00000001;

struct EMRCREATECOLORSPACEW {
    EMR             emr;
    DWORD           ihCS;       // ColorSpace handle index
    LOGCOLORSPACEW  lcs;        // Unicode version of logical color space structure
    DWORD           dwFlags;    // flags
    DWORD           cbData;     // size of raw source profile data if attached
    BYTE[1]            Data;    // Array size is cbData
}

typedef EMRCREATECOLORSPACEW* PEMRCREATECOLORSPACEW;
typedef EMRCREATECOLORSPACEW* LPEMRCREATECOLORSPACEW;

const auto COLORMATCHTOTARGET_EMBEDED      = 0x00000001;

struct EMRCOLORMATCHTOTARGET {
    EMR     emr;
    DWORD   dwAction;           // CS_ENABLE, CS_DISABLE or CS_DELETE_TRANSFORM
    DWORD   dwFlags;            // flags
    DWORD   cbName;             // Size of desired target profile name
    DWORD   cbData;             // Size of raw target profile data if attached
    BYTE[1]    Data;            // Array size is cbName + cbData
}

typedef EMRCOLORMATCHTOTARGET* PEMRCOLORMATCHTOTARGET;
typedef EMRCOLORMATCHTOTARGET* LPEMRCOLORMATCHTOTARGET;

struct EMRCOLORCORRECTPALETTE {
    EMR     emr;
    DWORD   ihPalette;          // Palette handle index
    DWORD   nFirstEntry;        // Index of first entry to correct
    DWORD   nPalEntries;        // Number of palette entries to correct
    DWORD   nReserved;          // Reserved
}

typedef EMRCOLORCORRECTPALETTE* PEMRCOLORCORRECTPALETTE;
typedef EMRCOLORCORRECTPALETTE* LPEMRCOLORCORRECTPALETTE;

struct EMRALPHABLEND {
    EMR     emr;
    RECTL   rclBounds;          // Inclusive-inclusive bounds in device units
    LONG    xDest;
    LONG    yDest;
    LONG    cxDest;
    LONG    cyDest;
    DWORD   dwRop;
    LONG    xSrc;
    LONG    ySrc;
    XFORM   xformSrc;           // Source DC transform
    COLORREF crBkColorSrc;      // Source DC BkColor in RGB
    DWORD   iUsageSrc;          // Source bitmap info color table usage
                                // (DIB_RGB_COLORS)
    DWORD   offBmiSrc;          // Offset to the source BITMAPINFO structure
    DWORD   cbBmiSrc;           // Size of the source BITMAPINFO structure
    DWORD   offBitsSrc;         // Offset to the source bitmap bits
    DWORD   cbBitsSrc;          // Size of the source bitmap bits
    LONG    cxSrc;
    LONG    cySrc;
}

typedef EMRALPHABLEND* PEMRALPHABLEND;
typedef EMRALPHABLEND* LPEMRALPHABLEND;

struct EMRGRADIENTFILL {
    EMR       emr;
    RECTL     rclBounds;          // Inclusive-inclusive bounds in device units
    DWORD     nVer;
    DWORD     nTri;
    ULONG     ulMode;
    TRIVERTEX[1] Ver;
}

typedef EMRGRADIENTFILL* PEMRGRADIENTFILL;
typedef EMRGRADIENTFILL* LPEMRGRADIENTFILL;

struct EMRTRANSPARENTBLT {
    EMR     emr;
    RECTL   rclBounds;          // Inclusive-inclusive bounds in device units
    LONG    xDest;
    LONG    yDest;
    LONG    cxDest;
    LONG    cyDest;
    DWORD   dwRop;
    LONG    xSrc;
    LONG    ySrc;
    XFORM   xformSrc;           // Source DC transform
    COLORREF crBkColorSrc;      // Source DC BkColor in RGB
    DWORD   iUsageSrc;          // Source bitmap info color table usage
                                // (DIB_RGB_COLORS)
    DWORD   offBmiSrc;          // Offset to the source BITMAPINFO structure
    DWORD   cbBmiSrc;           // Size of the source BITMAPINFO structure
    DWORD   offBitsSrc;         // Offset to the source bitmap bits
    DWORD   cbBitsSrc;          // Size of the source bitmap bits
    LONG    cxSrc;
    LONG    cySrc;
}

typedef EMRTRANSPARENTBLT* PEMRTRANSPARENTBLT;
typedef EMRTRANSPARENTBLT* LPEMRTRANSPARENTBLT;

const auto GDICOMMENT_IDENTIFIER           = 0x43494447;
const auto GDICOMMENT_WINDOWS_METAFILE     = 0x80000001;
const auto GDICOMMENT_BEGINGROUP           = 0x00000002;
const auto GDICOMMENT_ENDGROUP             = 0x00000003;
const auto GDICOMMENT_MULTIFORMATS         = 0x40000004;
const auto EPS_SIGNATURE                   = 0x46535045;
const auto GDICOMMENT_UNICODE_STRING       = 0x00000040;
const auto GDICOMMENT_UNICODE_END          = 0x00000080;

// OpenGL wgl prototypes

BOOL  wglCopyContext(HGLRC, HGLRC, UINT);
HGLRC wglCreateContext(HDC);
HGLRC wglCreateLayerContext(HDC, int);
BOOL  wglDeleteContext(HGLRC);
HGLRC wglGetCurrentContext();
HDC   wglGetCurrentDC();
PROC  wglGetProcAddress(LPCSTR);
BOOL  wglMakeCurrent(HDC, HGLRC);
BOOL  wglShareLists(HGLRC, HGLRC);
BOOL  wglUseFontBitmapsA(HDC, DWORD, DWORD, DWORD);
BOOL  wglUseFontBitmapsW(HDC, DWORD, DWORD, DWORD);

version(UNICODE) {
	alias wglUseFontBitmapsW  wglUseFontBitmaps;
}
else {
	alias wglUseFontBitmapsA  wglUseFontBitmaps;
}

BOOL  SwapBuffers(HDC);

struct POINTFLOAT {
    FLOAT   x;
    FLOAT   y;
}

typedef POINTFLOAT* PPOINTFLOAT;
typedef POINTFLOAT* LPPOINTFLOAT;

struct GLYPHMETRICSFLOAT {
    FLOAT       gmfBlackBoxX;
    FLOAT       gmfBlackBoxY;
    POINTFLOAT  gmfptGlyphOrigin;
    FLOAT       gmfCellIncX;
    FLOAT       gmfCellIncY;
}

typedef GLYPHMETRICSFLOAT* PGLYPHMETRICSFLOAT;
typedef GLYPHMETRICSFLOAT* LPGLYPHMETRICSFLOAT;

const auto WGL_FONT_LINES      = 0;
const auto WGL_FONT_POLYGONS   = 1;
BOOL  wglUseFontOutlinesA(HDC, DWORD, DWORD, DWORD, FLOAT,
                                           FLOAT, int, LPGLYPHMETRICSFLOAT);
BOOL  wglUseFontOutlinesW(HDC, DWORD, DWORD, DWORD, FLOAT,
                                           FLOAT, int, LPGLYPHMETRICSFLOAT);

version(UNICODE) {
	alias wglUseFontOutlinesW  wglUseFontOutlines;
}
else {
	alias wglUseFontOutlinesA  wglUseFontOutlines;
}

/* Layer plane descriptor */
struct LAYERPLANEDESCRIPTOR { // lpd
    WORD  nSize;
    WORD  nVersion;
    DWORD dwFlags;
    BYTE  iPixelType;
    BYTE  cColorBits;
    BYTE  cRedBits;
    BYTE  cRedShift;
    BYTE  cGreenBits;
    BYTE  cGreenShift;
    BYTE  cBlueBits;
    BYTE  cBlueShift;
    BYTE  cAlphaBits;
    BYTE  cAlphaShift;
    BYTE  cAccumBits;
    BYTE  cAccumRedBits;
    BYTE  cAccumGreenBits;
    BYTE  cAccumBlueBits;
    BYTE  cAccumAlphaBits;
    BYTE  cDepthBits;
    BYTE  cStencilBits;
    BYTE  cAuxBuffers;
    BYTE  iLayerPlane;
    BYTE  bReserved;
    COLORREF crTransparent;
}

typedef LAYERPLANEDESCRIPTOR* PLAYERPLANEDESCRIPTOR;
typedef LAYERPLANEDESCRIPTOR* LPLAYERPLANEDESCRIPTOR;

/* LAYERPLANEDESCRIPTOR flags */
const auto LPD_DOUBLEBUFFER        = 0x00000001;
const auto LPD_STEREO              = 0x00000002;
const auto LPD_SUPPORT_GDI         = 0x00000010;
const auto LPD_SUPPORT_OPENGL      = 0x00000020;
const auto LPD_SHARE_DEPTH         = 0x00000040;
const auto LPD_SHARE_STENCIL       = 0x00000080;
const auto LPD_SHARE_ACCUM         = 0x00000100;
const auto LPD_SWAP_EXCHANGE       = 0x00000200;
const auto LPD_SWAP_COPY           = 0x00000400;
const auto LPD_TRANSPARENT         = 0x00001000;

const auto LPD_TYPE_RGBA        = 0;
const auto LPD_TYPE_COLORINDEX  = 1;

/* wglSwapLayerBuffers flags */
const auto WGL_SWAP_MAIN_PLANE     = 0x00000001;
const auto WGL_SWAP_OVERLAY1       = 0x00000002;
const auto WGL_SWAP_OVERLAY2       = 0x00000004;
const auto WGL_SWAP_OVERLAY3       = 0x00000008;
const auto WGL_SWAP_OVERLAY4       = 0x00000010;
const auto WGL_SWAP_OVERLAY5       = 0x00000020;
const auto WGL_SWAP_OVERLAY6       = 0x00000040;
const auto WGL_SWAP_OVERLAY7       = 0x00000080;
const auto WGL_SWAP_OVERLAY8       = 0x00000100;
const auto WGL_SWAP_OVERLAY9       = 0x00000200;
const auto WGL_SWAP_OVERLAY10      = 0x00000400;
const auto WGL_SWAP_OVERLAY11      = 0x00000800;
const auto WGL_SWAP_OVERLAY12      = 0x00001000;
const auto WGL_SWAP_OVERLAY13      = 0x00002000;
const auto WGL_SWAP_OVERLAY14      = 0x00004000;
const auto WGL_SWAP_OVERLAY15      = 0x00008000;
const auto WGL_SWAP_UNDERLAY1      = 0x00010000;
const auto WGL_SWAP_UNDERLAY2      = 0x00020000;
const auto WGL_SWAP_UNDERLAY3      = 0x00040000;
const auto WGL_SWAP_UNDERLAY4      = 0x00080000;
const auto WGL_SWAP_UNDERLAY5      = 0x00100000;
const auto WGL_SWAP_UNDERLAY6      = 0x00200000;
const auto WGL_SWAP_UNDERLAY7      = 0x00400000;
const auto WGL_SWAP_UNDERLAY8      = 0x00800000;
const auto WGL_SWAP_UNDERLAY9      = 0x01000000;
const auto WGL_SWAP_UNDERLAY10     = 0x02000000;
const auto WGL_SWAP_UNDERLAY11     = 0x04000000;
const auto WGL_SWAP_UNDERLAY12     = 0x08000000;
const auto WGL_SWAP_UNDERLAY13     = 0x10000000;
const auto WGL_SWAP_UNDERLAY14     = 0x20000000;
const auto WGL_SWAP_UNDERLAY15     = 0x40000000;

BOOL  wglDescribeLayerPlane(HDC, int, int, UINT,
                                             LPLAYERPLANEDESCRIPTOR);
int   wglSetLayerPaletteEntries(HDC, int, int, int,
                                                 COLORREF *);
int   wglGetLayerPaletteEntries(HDC, int, int, int,
                                                 COLORREF *);
BOOL  wglRealizeLayerPalette(HDC, int, BOOL);
BOOL  wglSwapLayerBuffers(HDC, UINT);

struct WGLSWAP {
    HDC hdc;
    UINT uiFlags;
}

typedef WGLSWAP* PWGLSWAP;
typedef WGLSWAP* LPWGLSWAP;

const auto WGL_SWAPMULTIPLE_MAX = 16;

DWORD wglSwapMultipleBuffers(UINT, WGLSWAP *);