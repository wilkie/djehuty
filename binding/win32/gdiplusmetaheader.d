/*
 * gdiplusmetaheader.d
 *
 * This module implements GdiPlusMetaHeader.h for D. The original copyright
 * info is given below.
 *
 * Author: Dave Wilkinson
 * Originated: November 25th, 2009
 *
 */

module binding.win32.gdiplusmetaheader;

import binding.win32.windef;
import binding.win32.winbase;
import binding.win32.winnt;
import binding.win32.wingdi;

import binding.win32.gdiplustypes;
import binding.win32.gdipluspixelformats;
import binding.win32.gdiplusenums;

/**************************************************************************\
*
* Copyright (c) 1998-2001, Microsoft Corp.  All Rights Reserved.
*
* Module Name:
*
*   Metafile headers
*
* Abstract:
*
*   GDI+ Metafile Related Structures
*
\**************************************************************************/

struct ENHMETAHEADER3 {
    DWORD   iType;              // Record type EMR_HEADER
    DWORD   nSize;              // Record size in bytes.  This may be greater
                                // than the sizeof(ENHMETAHEADER).
    RECTL   rclBounds;          // Inclusive-inclusive bounds in device units
    RECTL   rclFrame;           // Inclusive-inclusive Picture Frame .01mm unit
    DWORD   dSignature;         // Signature.  Must be ENHMETA_SIGNATURE.
    DWORD   nVersion;           // Version number
    DWORD   nBytes;             // Size of the metafile in bytes
    DWORD   nRecords;           // Number of records in the metafile
    WORD    nHandles;           // Number of handles in the handle table
                                // Handle index zero is reserved.
    WORD    sReserved;          // Reserved.  Must be zero.
    DWORD   nDescription;       // Number of chars in the unicode desc string
                                // This is 0 if there is no description string
    DWORD   offDescription;     // Offset to the metafile description record.
                                // This is 0 if there is no description string
    DWORD   nPalEntries;        // Number of entries in the metafile palette.
    SIZEL   szlDevice;          // Size of the reference device in pels
    SIZEL   szlMillimeters;     // Size of the reference device in millimeters
}

// Placeable WMFs

// Placeable Metafiles were created as a non-standard way of specifying how
// a metafile is mapped and scaled on an output device.
// Placeable metafiles are quite wide-spread, but not directly supported by
// the Windows API. To playback a placeable metafile using the Windows API,
// you will first need to strip the placeable metafile header from the file.
// This is typically performed by copying the metafile to a temporary file
// starting at file offset 22 (0x16). The contents of the temporary file may
// then be used as input to the Windows GetMetaFile(), PlayMetaFile(),
// CopyMetaFile(), etc. GDI functions.

// Each placeable metafile begins with a 22-byte header,
//  followed by a standard metafile:

align(2) struct PWMFRect16 {
    INT16           Left;
    INT16           Top;
    INT16           Right;
    INT16           Bottom;
}

align(2) struct WmfPlaceableFileHeader {
    UINT32          Key;            // GDIP_WMF_PLACEABLEKEY
    INT16           Hmf;            // Metafile HANDLE number (always 0)
    PWMFRect16      BoundingBox;    // Coordinates in metafile units
    INT16           Inch;           // Number of metafile units per inch
    UINT32          Reserved;       // Reserved (always 0)
    INT16           Checksum;       // Checksum value for previous 10 WORDs
}

// Key contains a special identification value that indicates the presence
// of a placeable metafile header and is always 0x9AC6CDD7.

// Handle is used to stored the handle of the metafile in memory. When written
// to disk, this field is not used and will always contains the value 0.

// Left, Top, Right, and Bottom contain the coordinates of the upper-left
// and lower-right corners of the image on the output device. These are
// measured in twips.

// A twip (meaning "twentieth of a point") is the logical unit of measurement
// used in Windows Metafiles. A twip is equal to 1/1440 of an inch. Thus 720
// twips equal 1/2 inch, while 32,768 twips is 22.75 inches.

// Inch contains the number of twips per inch used to represent the image.
// Normally, there are 1440 twips per inch; however, this number may be
// changed to scale the image. A value of 720 indicates that the image is
// double its normal size, or scaled to a factor of 2:1. A value of 360
// indicates a scale of 4:1, while a value of 2880 indicates that the image
// is scaled down in size by a factor of two. A value of 1440 indicates
// a 1:1 scale ratio.

// Reserved is not used and is always set to 0.

// Checksum contains a checksum value for the previous 10 WORDs in the header.
// This value can be used in an attempt to detect if the metafile has become
// corrupted. The checksum is calculated by XORing each WORD value to an
// initial value of 0.

// If the metafile was recorded with a reference Hdc that was a display.

const auto GDIP_EMFPLUSFLAGS_DISPLAY       = 0x00000001;

struct MetafileHeader {
public:
    MetafileType        Type;
    UINT                Size;               // Size of the metafile (in bytes)
    UINT                Version;            // EMF+, EMF, or WMF version
    UINT                EmfPlusFlags;
    REAL                DpiX;
    REAL                DpiY;
    INT                 X;                  // Bounds in device units
    INT                 Y;
    INT                 Width;
    INT                 Height;
    union _inner_union {
        METAHEADER      WmfHeader;
        ENHMETAHEADER3  EmfHeader;
    }
    _inner_union fields;
    INT                 EmfPlusHeaderSize;  // size of the EMF+ header in file
    INT                 LogicalDpiX;        // Logical Dpi of reference Hdc
    INT                 LogicalDpiY;        // usually valid only for EMF+

    MetafileType GetType() {
		return Type;
	}

    UINT GetMetafileSize() {
		return Size;
	}

    // If IsEmfPlus, this is the EMF+ version; else it is the WMF or EMF ver

    UINT GetVersion() {
		return Version;
	}

    // Get the EMF+ flags associated with the metafile

    UINT GetEmfPlusFlags() {
		return EmfPlusFlags;
	}

    REAL GetDpiX() {
		return DpiX;
	}

    REAL GetDpiY() {
		return DpiY;
	}

    VOID GetBounds (out Rect rect) {
        rect.X = X;
        rect.Y = Y;
        rect.Width = Width;
        rect.Height = Height;
    }

    // Is it any type of WMF (standard or Placeable Metafile)?

    BOOL IsWmf() {
       return ((Type == MetafileType.MetafileTypeWmf) || (Type == MetafileType.MetafileTypeWmfPlaceable));
    }

    // Is this an Placeable Metafile?

    BOOL IsWmfPlaceable() {
		return (Type == MetafileType.MetafileTypeWmfPlaceable);
	}

    // Is this an EMF (not an EMF+)?

    BOOL IsEmf() {
		return (Type == MetafileType.MetafileTypeEmf);
	}

    // Is this an EMF or EMF+ file?

    BOOL IsEmfOrEmfPlus() {
		return (Type >= MetafileType.MetafileTypeEmf);
	}

    // Is this an EMF+ file?

    BOOL IsEmfPlus() {
		return (Type >= MetafileType.MetafileTypeEmfPlusOnly);
	}

    // Is this an EMF+ dual (has dual, down-level records) file?

    BOOL IsEmfPlusDual() {
		return (Type == MetafileType.MetafileTypeEmfPlusDual);
	}

    // Is this an EMF+ only (no dual records) file?

    BOOL IsEmfPlusOnly() {
		return (Type == MetafileType.MetafileTypeEmfPlusOnly);
	}

    // If it's an EMF+ file, was it recorded against a display Hdc?

    BOOL IsDisplay() {
        return (IsEmfPlus() &&
                ((EmfPlusFlags & GDIP_EMFPLUSFLAGS_DISPLAY) != 0));
    }

    // Get the WMF header of the metafile (if it is a WMF)

    METAHEADER* GetWmfHeader() {
        if (IsWmf()) {
            return &fields.WmfHeader;
        }
        return null;
    }

    // Get the EMF header of the metafile (if it is an EMF)

    ENHMETAHEADER3* GetEmfHeader() {
        if (IsEmfOrEmfPlus()) {
            return &fields.EmfHeader;
        }
        return null;
    }
}