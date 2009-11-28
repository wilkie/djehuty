/*
 * gdiplusstringformat.d
 *
 * This module implements GdiPlusStringFormat.h for D. The original
 * copyright info is given below.
 *
 * Author: Dave Wilkinson
 * Originated: November 25th, 2009
 *
 */

module binding.win32.gdiplusstringformat;

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

/**************************************************************************\
*
* Copyright (c) 1998-2001, Microsoft Corp.  All Rights Reserved.
*
* Module Name:
*
*   GdiplusStringFormat.h
*
* Abstract:
*
*   GDI+ StringFormat class
*
\**************************************************************************/

class StringFormat : GdiplusBase {

    this(
        in INT     formatFlags = 0,
        in LANGID  language = LANG_NEUTRAL) {
        nativeFormat = null;
        lastError = GdipCreateStringFormat(
            formatFlags,
            language,
            &nativeFormat
        );
    }

    static StringFormat GenericDefault() {
		StringFormat genericDefaultStringFormat = new StringFormat();

	    genericDefaultStringFormat.lastError =
	        GdipStringFormatGetGenericDefault(
	            &(genericDefaultStringFormat.nativeFormat)
	        );

		return genericDefaultStringFormat;
	}

    static StringFormat GenericTypographic() {
    	StringFormat genericTypographicStringFormat = new StringFormat();

	    genericTypographicStringFormat.lastError =
	        GdipStringFormatGetGenericTypographic(
	            &genericTypographicStringFormat.nativeFormat
	        );

	    return genericTypographicStringFormat;
    }

    this(in StringFormat format) {
        nativeFormat = null;
        lastError = GdipCloneStringFormat(
            format ? format.nativeFormat : null,
            &nativeFormat
        );
    }

    StringFormat Clone() {
        GpStringFormat *clonedStringFormat = null;

        lastError = GdipCloneStringFormat(
            nativeFormat,
            &clonedStringFormat
        );

        if (lastError == Status.Ok)
            return new StringFormat(clonedStringFormat, lastError);
        else
            return null;
    }
    
    alias Clone dup;

    ~this() {
        GdipDeleteStringFormat(nativeFormat);
    }

    Status SetFormatFlags(in INT flags) {
        return SetStatus(GdipSetStringFormatFlags(
            nativeFormat,
            flags
        ));
    }

    INT GetFormatFlags() {
        INT flags;
        SetStatus(GdipGetStringFormatFlags(nativeFormat, &flags));
        return flags;
    }

    Status SetAlignment(in StringAlignment _align) {
        return SetStatus(GdipSetStringFormatAlign(
            nativeFormat,
            _align
        ));
    }

    StringAlignment GetAlignment() {
        StringAlignment alignment;
        SetStatus(GdipGetStringFormatAlign(
            nativeFormat,
            &alignment
        ));
        return alignment;
    }

    Status SetLineAlignment(in StringAlignment _align) {
        return SetStatus(GdipSetStringFormatLineAlign(
            nativeFormat,
            _align
        ));
    }

    StringAlignment GetLineAlignment() {
        StringAlignment alignment;
        SetStatus(GdipGetStringFormatLineAlign(
            nativeFormat,
            &alignment
        ));
        return alignment;
    }

    Status SetHotkeyPrefix(in HotkeyPrefix hotkeyPrefix) {
        return SetStatus(GdipSetStringFormatHotkeyPrefix(
            nativeFormat,
            cast(INT)hotkeyPrefix
        ));
    }

    HotkeyPrefix GetHotkeyPrefix() {
        HotkeyPrefix hotkeyPrefix;
        SetStatus(GdipGetStringFormatHotkeyPrefix(
            nativeFormat,
            cast(INT*)&hotkeyPrefix
        ));
        return hotkeyPrefix;
    }

    Status SetTabStops(
        in REAL    firstTabOffset,
        in INT     count,
        in REAL    *tabStops
    ) {
        return SetStatus(GdipSetStringFormatTabStops(
            nativeFormat,
            firstTabOffset,
            count,
            tabStops
        ));
    }

    INT GetTabStopCount() {
        INT count;
        SetStatus(GdipGetStringFormatTabStopCount(nativeFormat, &count));
        return count;
    }

    Status GetTabStops(
        in INT     count,
        REAL   *firstTabOffset,
        REAL   *tabStops
    ) {
        return SetStatus(GdipGetStringFormatTabStops(
            nativeFormat,
            count,
            firstTabOffset,
            tabStops
        ));
    }

    Status SetDigitSubstitution(
        in LANGID                language,
        in StringDigitSubstitute substitute
    ) {
        return SetStatus(GdipSetStringFormatDigitSubstitution(
            nativeFormat,
            language,
            substitute
        ));
    }

    LANGID GetDigitSubstitutionLanguage() {
        LANGID language;
        SetStatus(GdipGetStringFormatDigitSubstitution(
            nativeFormat,
            &language,
            null
        ));
        return language;
    }

    StringDigitSubstitute GetDigitSubstitutionMethod() {
        StringDigitSubstitute substitute;
        SetStatus(GdipGetStringFormatDigitSubstitution(
            nativeFormat,
            null,
            &substitute
        ));
        return substitute;
    }

    Status SetTrimming(in StringTrimming trimming) {
        return SetStatus(GdipSetStringFormatTrimming(
            nativeFormat,
            trimming
        ));
    }

    StringTrimming GetTrimming() {
        StringTrimming trimming;
        SetStatus(GdipGetStringFormatTrimming(
            nativeFormat,
            &trimming
        ));
        return trimming;
    }

    Status SetMeasurableCharacterRanges(
        in INT                  rangeCount,
        in CharacterRange[] ranges
    ) {
        return SetStatus(GdipSetStringFormatMeasurableCharacterRanges(
            nativeFormat,
            rangeCount,
            ranges.ptr
        ));
    }

    INT GetMeasurableCharacterRangeCount() {
        INT count;
        SetStatus(GdipGetStringFormatMeasurableCharacterRangeCount(
            nativeFormat,
            &count
        ));
        return count;
    }

    Status GetLastStatus() {
        Status lastStatus = lastError;
        lastError = Status.Ok;

        return lastStatus;
    }

protected:

    Status SetStatus(GpStatus newStatus) {
        if (newStatus == Status.Ok) {
            return Status.Ok;
        }
        else {
            return lastError = newStatus;
        }
    }

    package this(GpStringFormat* clonedStringFormat, Status status) {
        lastError = status;
        nativeFormat = clonedStringFormat;

    }

    package GpStringFormat *nativeFormat;
    package Status  lastError;
}
