
module core.unicode;

import core.definitions;
import core.literals;

import core.stringliteral;

private static const uint halfShift = 10;
private static const uint halfBase = 0x0010000;
private static const uint halfMask = 0x3FF;

private const auto UNI_SUR_HIGH_START	= 0xD800;
private const auto UNI_SUR_HIGH_END		= 0xDBFF;
private const auto UNI_SUR_LOW_START	= 0xDC00;
private const auto UNI_SUR_LOW_END		= 0xDFFF;

private const auto UNI_REPLACEMENT_CHAR = cast(dchar)0x0000FFFD;
private const auto UNI_MAX_BMP = cast(dchar)0x0000FFFF;
private const auto UNI_MAX_UTF16 = cast(dchar)0x0010FFFF;
private const auto UNI_MAX_UTF32 = cast(dchar)0x7FFFFFFF;
private const auto UNI_MAX_LEGAL_UTF32 = cast(dchar)0x0010FFFF;

private static const char firstByteMark[7] = [ 0x00, 0x00, 0xC0, 0xE0, 0xF0, 0xF8, 0xFC ];

/*
 * Index into the table below with the first byte of a UTF-8 sequence to
 * get the number of trailing bytes that are supposed to follow it.
 * Note that *legal* UTF-8 values can't have 4 or 5-bytes. The table is
 * left as-is for anyone who may want to do such conversion, which was
 * allowed in earlier algorithms.
 */
static const char trailingBytesForUTF8[256] = [
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1, 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
    2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2, 3,3,3,3,3,3,3,3,4,4,4,4,5,5,5,5
];

/*
 * Magic values subtracted from a buffer value during UTF8 conversion.
 * This table contains as many values as there might be trailing bytes
 * in a UTF-8 sequence.
 */
static const uint offsetsFromUTF8[6] = [ 0x00000000, 0x00003080, 0x000E2080,
		     0x03C82080, 0xFA082080, 0x82082080 ];


/*
 * Utility routine to tell whether a sequence of bytes is legal UTF-8.
 * This must be called with the length pre-determined by the first byte.
 * If not calling this from ConvertUTF8to*, then the length can be set by:
 *  length = trailingBytesForUTF8[*source]+1;
 * and the sequence is illegal right away if there aren't that many bytes
 * available.
 * If presented with a length > 4, this returns false.  The Unicode
 * definition of UTF-8 goes up to 4-byte sequences.
 */

private bool isLegalUTF8(CharLiteral8* source, int length) {
    char a;
    CharLiteral8 *srcptr = source+length;
    switch (length) {
	    default: return false;
		/* Everything else falls through when "true"... */
	    case 4: if ((a = (*--srcptr)) < 0x80 || a > 0xBF) return false;
	    case 3: if ((a = (*--srcptr)) < 0x80 || a > 0xBF) return false;
	    case 2: if ((a = (*--srcptr)) > 0xBF) return false;

		switch (*source) {
		    /* no fall-through in this inner switch */
		    case 0xE0: if (a < 0xA0) return false; break;
		    case 0xED: if (a > 0x9F) return false; break;
		    case 0xF0: if (a < 0x90) return false; break;
		    case 0xF4: if (a > 0x8F) return false; break;
		    default:   if (a < 0x80) return false;
		}

	    case 1: if (*source >= 0x80 && *source < 0xC2) return false;
    }
    if (*source > 0xF4) return false;
    return true;
}

// For efficiency, we have full
// control of the buffer length.

struct Unicode
{
static:

	StringLiteral8 toUtf8(StringLiteral8 src)
	{
		return cast(StringLiteral8)src.dup;
	}

	StringLiteral8 toUtf8(StringLiteral16 src)
	{
		if (src.length == 0)
		{
			return cast(StringLiteral8)"";
		}

		char[] container = new char[src.length*2];

		const auto byteMask = 0xBF;
		const auto byteMark = 0x80;

		CharLiteral16* source = src.ptr;
		CharLiteral16* sourceEnd = &src[$-1] + 1;

		char* target = container.ptr;
		char* targetEnd = &container[$-1] + 1;

		uint bytesToWrite;

		dchar ch;

		while(source !is sourceEnd)
		{

			ch = *source++;

			// If we have a surrogate pair, we convert to UTF-32
			if (ch >= UNI_SUR_HIGH_START && ch <= UNI_SUR_HIGH_END)
			{
				dchar ch2 = cast(dchar)*source;

				/* If it's a low surrogate, convert to UTF32. */
				if (ch2 >= UNI_SUR_LOW_START && ch2 <= UNI_SUR_LOW_END)
				{
					ch = ((ch - UNI_SUR_HIGH_START) << 10) + (ch2 - UNI_SUR_LOW_START) + halfBase;
					source++;
				}
				else
				{
					// unpaired high surrogate
					// illegal

					// TODO: do not break, just add a character and continue to produce valid string
					source--;
					break;
				}
			}
			else if (ch >= UNI_SUR_LOW_START && ch <= UNI_SUR_LOW_END)
			{
				// illegal

				// TODO: do not break, just add a character and continue to produce valid string
				source--;
				break;
			}

			/* Figure out how many bytes the result will require */
			if (ch < cast(dchar)0x80) {
				bytesToWrite = 1;
			}
			else if (ch < cast(dchar)0x800)
			{
				bytesToWrite = 2;
			}
			else if (ch < cast(dchar)0x10000)
			{
				bytesToWrite = 3;
			}
			else if (ch < cast(dchar)0x110000)
			{
				bytesToWrite = 4;
			}
			else
			{
				bytesToWrite = 3;
				ch = UNI_REPLACEMENT_CHAR;
			}

			target += bytesToWrite;

			switch (bytesToWrite) { /* note: everything falls through. */
				case 4: *--target = cast(char)((ch | byteMark) & byteMask); ch >>= 6;
				case 3: *--target = cast(char)((ch | byteMark) & byteMask); ch >>= 6;
				case 2: *--target = cast(char)((ch | byteMark) & byteMask); ch >>= 6;
				case 1: *--target = cast(char)(ch | firstByteMark[bytesToWrite]);

				default: break;
			}
			target += bytesToWrite;
		}

		return cast(StringLiteral8)container[0..target - container.ptr];
	}

	StringLiteral8 toUtf8(StringLiteral32 src)
	{
		if (src is null || src.length == 0)
		{
			return cast(StringLiteral8)"";
		}

		char[] container = new char[src.length*4];

		const auto byteMask = 0xBF;
		const auto byteMark = 0x80;

		CharLiteral32* source = src.ptr;
		CharLiteral32* sourceEnd = &src[$-1] + 1;

		char* target = container.ptr;
		char* targetEnd = &container[$-1] + 1;

		uint bytesToWrite;

		dchar ch;

		while (source < sourceEnd) {

			bytesToWrite = 0;
			ch = *source++;

			/*
			 * Figure out how many bytes the result will require. Turn any
			 * illegally large UTF32 things (> Plane 17) into replacement chars.
			 */

			if (ch < cast(dchar)0x80)
			{
				bytesToWrite = 1;
			}
			else if (ch < cast(dchar)0x800)
			{
				bytesToWrite = 2;
			}
			else if (ch < cast(dchar)0x10000)
			{
				bytesToWrite = 3;
			}
			else if (ch <= UNI_MAX_LEGAL_UTF32)
			{
				bytesToWrite = 4;
			}
			else
			{
				bytesToWrite = 3;
				ch = UNI_REPLACEMENT_CHAR;
			}

			target += bytesToWrite;

			switch (bytesToWrite) { /* note: everything falls through. */
				case 4: *--target = cast(char)((ch | byteMark) & byteMask); ch >>= 6;
				case 3: *--target = cast(char)((ch | byteMark) & byteMask); ch >>= 6;
				case 2: *--target = cast(char)((ch | byteMark) & byteMask); ch >>= 6;
				case 1: *--target = cast(char) (ch | firstByteMark[bytesToWrite]);

				default: break;
			}
			target += bytesToWrite;
		}

		uint targetLen = target - container.ptr;

		StringLiteral8 ret = cast(StringLiteral8)container[0..targetLen];
		return ret;
	}

	StringLiteral16 toUtf16(StringLiteral8 src)
	{
		if (src.length == 0)
		{
			return cast(StringLiteral16)"";
		}

		wchar[] container = new wchar[src.length];

		CharLiteral8* source = src.ptr;
		CharLiteral8* sourceEnd = &src[$-1] + 1;

		wchar* target = container.ptr;
		wchar* targetEnd = &container[$-1] + 1;

		dchar ch;

		while (source < sourceEnd)
		{
			ch = 0;

			ushort extraBytesToRead = trailingBytesForUTF8[*source];

			if (source + extraBytesToRead >= sourceEnd) {
				// sourceExhausted
				break;
			}
			/* Do this check whether lenient or strict */
			if (! isLegalUTF8(source, extraBytesToRead+1)) {
				// sourceIllegal
				break;
			}

			switch (extraBytesToRead) {
				case 5: ch += *source++; ch <<= 6; /* remember, illegal UTF-8 */
				case 4: ch += *source++; ch <<= 6; /* remember, illegal UTF-8 */
				case 3: ch += *source++; ch <<= 6;
				case 2: ch += *source++; ch <<= 6;
				case 1: ch += *source++; ch <<= 6;
				case 0: ch += *source++;
				default: break;
			}
			ch -= offsetsFromUTF8[extraBytesToRead];

			if (ch <= UNI_MAX_BMP) { /* Target is a character <= 0xFFFF */
				/* UTF-16 surrogate values are illegal in UTF-32 */
				if (ch >= UNI_SUR_HIGH_START && ch <= UNI_SUR_LOW_END)
				{
					// illegal
					*target++ = UNI_REPLACEMENT_CHAR;
				}
				else
				{
					*target++ = cast(wchar)ch; /* normal case */
				}
			}
			else if (ch > UNI_MAX_UTF16)
			{
				// illegal
				*target++ = UNI_REPLACEMENT_CHAR;
			}
			else
			{
				/* target is a character in range 0xFFFF - 0x10FFFF. */

				ch -= halfBase;
				*target++ = cast(wchar)((ch >> halfShift) + UNI_SUR_HIGH_START);
				*target++ = cast(wchar)((ch & halfMask) + UNI_SUR_LOW_START);
			}
		}

		return cast(StringLiteral16)container[0..target - container.ptr];
	}

	StringLiteral16 toUtf16(StringLiteral16 src)
	{
		return cast(StringLiteral16)src.dup;
	}

	StringLiteral16 toUtf16(StringLiteral32 src)
	{
		if (src.length == 0)
		{
			return cast(StringLiteral16)"";
		}

		wchar[] container = new wchar[src.length];

		CharLiteral32* source = src.ptr;
		CharLiteral32* sourceEnd = &src[$-1] + 1;

		wchar* target = container.ptr;
		wchar* targetEnd = &container[$-1] + 1;

		dchar ch;

		while (source < sourceEnd) {
			ch = *source++;
			if (ch <= UNI_MAX_BMP)
			{
				/* Target is a character <= 0xFFFF */

				/* UTF-16 surrogate values are illegal in UTF-32; 0xffff or 0xfffe are both reserved values */
				if (ch >= UNI_SUR_HIGH_START && ch <= UNI_SUR_LOW_END)
				{
					*target++ = UNI_REPLACEMENT_CHAR;
				}
				else
				{
					*target++ = cast(wchar)ch; /* normal case */
				}
			}
			else if (ch > UNI_MAX_LEGAL_UTF32)
			{
				*target++ = UNI_REPLACEMENT_CHAR;
			}
			else
			{
				/* target is a character in range 0xFFFF - 0x10FFFF. */
				ch -= halfBase;
				*target++ = cast(wchar)((ch >> halfShift) + UNI_SUR_HIGH_START);
				*target++ = cast(wchar)((ch & halfMask) + UNI_SUR_LOW_START);
			}
		}

		return cast(StringLiteral16)container[0..target - container.ptr];
	}

	StringLiteral32 toUtf32(StringLiteral8 src)
	{
		if (src.length == 0)
		{
			return cast(StringLiteral32)"";
		}

		dchar[] container = new dchar[src.length];

		CharLiteral8* source = src.ptr;
		CharLiteral8* sourceEnd = &src[$-1] + 1;

		dchar* target = container.ptr;
		dchar* targetEnd = &container[$-1] + 1;

		ushort extraBytesToRead;

		dchar ch;

		while (source < sourceEnd) {
			ch = 0;
			extraBytesToRead = trailingBytesForUTF8[*source];

			if (source + extraBytesToRead >= sourceEnd) {
				// sourceExhausted
				break;
			}

			if (!isLegalUTF8(source, extraBytesToRead+1)) {
				// sourceIllegal
				break;
			}

			/*
			 * The cases all fall through. See "Note A" below.
			 */
			switch (extraBytesToRead) {
				case 5: ch += *source++; ch <<= 6;
				case 4: ch += *source++; ch <<= 6;
				case 3: ch += *source++; ch <<= 6;
				case 2: ch += *source++; ch <<= 6;
				case 1: ch += *source++; ch <<= 6;
				case 0: ch += *source++;
				default: break;
			}

			ch -= offsetsFromUTF8[extraBytesToRead];

			if (ch <= UNI_MAX_LEGAL_UTF32) {
				/*
				 * UTF-16 surrogate values are illegal in UTF-32, and anything
				 * over Plane 17 (> 0x10FFFF) is illegal.
				 */
				if (ch >= UNI_SUR_HIGH_START && ch <= UNI_SUR_LOW_END)
				{
					*target++ = UNI_REPLACEMENT_CHAR;
				}
				else
				{
					*target++ = ch;
				}
			}
			else
			{
				/* i.e., ch > UNI_MAX_LEGAL_UTF32 */
				// sourceIllegal
				*target++ = UNI_REPLACEMENT_CHAR;
			}
		}

		return cast(StringLiteral32)container[0..target - container.ptr];
	}

	StringLiteral32 toUtf32(StringLiteral16 src)
	{
		if (src.length == 0)
		{
			return cast(StringLiteral32)"";
		}

		dchar[] container = new dchar[src.length];

		CharLiteral16* source = src.ptr;
		CharLiteral16* sourceEnd = &src[$-1] + 1;

		dchar* target = container.ptr;
		dchar* targetEnd = &container[$-1] + 1;

		dchar ch, ch2;

		while (source < sourceEnd) {
			ch = *source++;
			/* If we have a surrogate pair, convert to UTF32 first. */
			if (ch >= UNI_SUR_HIGH_START && ch <= UNI_SUR_HIGH_END)
			{
				/* If the 16 bits following the high surrogate are in the source buffer... */
				if (source < sourceEnd)
				{
					ch2 = *source;
					/* If it's a low surrogate, convert to UTF32. */
					if (ch2 >= UNI_SUR_LOW_START && ch2 <= UNI_SUR_LOW_END)
					{
						ch = ((ch - UNI_SUR_HIGH_START) << halfShift) + (ch2 - UNI_SUR_LOW_START) + halfBase;
						source++;
					}
				}
				else
				{ /* We don't have the 16 bits following the high surrogate. */
					//--source; /* return to the high surrogate */
					// sourceExhausted
					break;
				}
			}

			*target++ = ch;
		}

		return cast(StringLiteral32)container[0..target - container.ptr];
	}

	StringLiteral32 toUtf32(StringLiteral32 src)
	{
		return cast(StringLiteral32)src.dup;
	}

	StringLiteral toNative(StringLiteral8 src)
	{
		static if (Char.sizeof == dchar.sizeof)
		{
			return cast(StringLiteral)toUtf32(src);
		}
		else static if (Char.sizeof == wchar.sizeof)
		{
			return cast(StringLiteral)toUtf16(src);
		}
		else
		{
			return cast(StringLiteral)toUtf8(src);
		}
	}

	StringLiteral toNative(StringLiteral16 src)
	{
		static if (Char.sizeof == dchar.sizeof)
		{
			return cast(StringLiteral)toUtf32(src);
		}
		else static if (Char.sizeof == wchar.sizeof)
		{
			return cast(StringLiteral)toUtf16(src);
		}
		else
		{
			return cast(StringLiteral)toUtf8(src);
		}
	}

	StringLiteral toNative(StringLiteral32 src)
	{
		static if (Char.sizeof == dchar.sizeof)
		{
			return cast(StringLiteral)toUtf32(src);
		}
		else static if (Char.sizeof == wchar.sizeof)
		{
			return cast(StringLiteral)toUtf16(src);
		}
		else
		{
			return cast(StringLiteral)toUtf8(src);
		}
	}




	// character conversions
	dchar toUtf32Char(StringLiteral8 src)
	{
		// grab the first character,
		// convert it to a UTF-32 character,
		// and then return
		return toUtf32(src)[0];

		/+dchar[] container = new dchar[src.length];

		CharLiteral8* source = src.ptr;
		CharLiteral8* sourceEnd = &src[$-1] + 1;

		dchar* target = container.ptr;
		dchar* targetEnd = &container[$-1] + 1;

		ushort extraBytesToRead;

		dchar ch;

		extraBytesToRead = trailingBytesForUTF8[*source];

		if (source + extraBytesToRead >= sourceEnd) {
			// sourceExhausted
			return UNI_REPLACEMENT_CHAR;
		}

		if (!isLegalUTF8(source, extraBytesToRead+1)) {
			// sourceIllegal
			return UNI_REPLACEMENT_CHAR;
		}

		/*
		 * The cases all fall through. See "Note A" below.
		 */
		switch (extraBytesToRead) {
			case 5: ch += *source++; ch <<= 6;
			case 4: ch += *source++; ch <<= 6;
			case 3: ch += *source++; ch <<= 6;
			case 2: ch += *source++; ch <<= 6;
			case 1: ch += *source++; ch <<= 6;
			case 0: ch += *source++;
			default: break;
		}

		ch -= offsetsFromUTF8[extraBytesToRead];

		if (ch <= UNI_MAX_LEGAL_UTF32) {
			/*
			 * UTF-16 surrogate values are illegal in UTF-32, and anything
			 * over Plane 17 (> 0x10FFFF) is illegal.
			 */
			if (ch >= UNI_SUR_HIGH_START && ch <= UNI_SUR_LOW_END)
			{
				return UNI_REPLACEMENT_CHAR;
			}
			// else: found a valid character
		}
		else
		{
			/* i.e., ch > UNI_MAX_LEGAL_UTF32 */
			// sourceIllegal
			return UNI_REPLACEMENT_CHAR;
		}

		return ch;
		+/
	}

	dchar toUtf32Char(StringLiteral16 src)
	{
		// grab the first character,
		// convert it to a UTF-32 character,
		// and then return

		CharLiteral16* source = src.ptr;
		CharLiteral16* sourceEnd = &src[$-1] + 1;

		dchar ch, ch2;

		ch = *source++;
		/* If we have a surrogate pair, convert to UTF32 first. */
		if (ch >= UNI_SUR_HIGH_START && ch <= UNI_SUR_HIGH_END)
		{
			/* If the 16 bits following the high surrogate are in the source buffer... */
			if (source < sourceEnd)
			{
				ch2 = *source;
				/* If it's a low surrogate, convert to UTF32. */
				if (ch2 >= UNI_SUR_LOW_START && ch2 <= UNI_SUR_LOW_END)
				{
					ch = ((ch - UNI_SUR_HIGH_START) << halfShift) + (ch2 - UNI_SUR_LOW_START) + halfBase;
					// found a valid character
				}
				else
				{
					return UNI_REPLACEMENT_CHAR;
				}
			}
			else
			{
				/* We don't have the 16 bits following the high surrogate. */
				// sourceExhausted
				return UNI_REPLACEMENT_CHAR;
			}
		}
		// else: found a valid character

		return ch;
	}

	dchar toUtf32Char(StringLiteral32 src)
	{
		// Useless function

		return src[0];
	}






	bool isDeadChar(dchar chr)
	{
		// if it is a dead character
		return ((
			(chr >= 0x300 && chr <= 0x36F) ||		// Combining Diacritical Marks
			(chr >= 0x1DC0 && chr <= 0x1DFF) ||		// Combining Diacritical Marks Supplement
			(chr >= 0x20D0 && chr <= 0x20FF) ||		// Combining Diacritical Marks for Symbols
			(chr >= 0xFE20 && chr <= 0xFE2F)		// Combining Half Marks
			));
	}














	// character conversions
	dchar[] toUtf32Chars(StringLiteral8 src)
	{
		// grab the first character,
		// convert it to a UTF-32 character,
		// and then return

		dchar[] container;

		if (src.length == 0)
		{
			return [];
		}

		CharLiteral8* source = src.ptr;
		CharLiteral8* sourceEnd = &src[$-1] + 1;

		ushort extraBytesToRead;

		dchar ch;

		while (source < sourceEnd)
		{
			ch = 0;

			extraBytesToRead = trailingBytesForUTF8[*source];

			if (source + extraBytesToRead >= sourceEnd) {
				// sourceExhausted
				if (container.length == 0)
				{
					container ~=  UNI_REPLACEMENT_CHAR;
				}
				return container;
			}

			if (!isLegalUTF8(source, extraBytesToRead+1)) {
				// sourceIllegal
				if (container.length == 0)
				{
					container ~=  UNI_REPLACEMENT_CHAR;
				}
				return container;
			}

			/*
			 * The cases all fall through. See "Note A" below.
			 */
			switch (extraBytesToRead) {
				case 5: ch += *source++; ch <<= 6;
				case 4: ch += *source++; ch <<= 6;
				case 3: ch += *source++; ch <<= 6;
				case 2: ch += *source++; ch <<= 6;
				case 1: ch += *source++; ch <<= 6;
				case 0: ch += *source++;
				default: break;
			}

			ch -= offsetsFromUTF8[extraBytesToRead];

			if (ch <= UNI_MAX_LEGAL_UTF32) {
				/*
				 * UTF-16 surrogate values are illegal in UTF-32, and anything
				 * over Plane 17 (> 0x10FFFF) is illegal.
				 */
				if (ch >= UNI_SUR_HIGH_START && ch <= UNI_SUR_LOW_END)
				{
					if (container.length == 0)
					{
						container ~=  UNI_REPLACEMENT_CHAR;
					}
					return container;
				}
				// else: found a valid character
			}
			else
			{
				/* i.e., ch > UNI_MAX_LEGAL_UTF32 */
				// sourceIllegal
				if (container.length == 0)
				{
					container ~=  UNI_REPLACEMENT_CHAR;
				}
				return container;
			}

			if (container.length > 0)
			{
				if (!isDeadChar(ch))
				{
					break;
				}
			}
			container ~=  ch;
		}

		return container;
	}

	dchar[] toUtf32Chars(StringLiteral16 src)
	{
		// grab the first character,
		// convert it to a UTF-32 character,
		// and then return
		dchar[] container;

		if (src.length == 0)
		{
			return [];
		}

		CharLiteral16* source = src.ptr;
		CharLiteral16* sourceEnd = &src[$-1] + 1;

		dchar ch, ch2;

		while(source < sourceEnd)
		{
			ch = *source++;
			/* If we have a surrogate pair, convert to UTF32 first. */
			if (ch >= UNI_SUR_HIGH_START && ch <= UNI_SUR_HIGH_END)
			{
				/* If the 16 bits following the high surrogate are in the source buffer... */
				if (source < sourceEnd)
				{
					ch2 = *source;
					/* If it's a low surrogate, convert to UTF32. */
					if (ch2 >= UNI_SUR_LOW_START && ch2 <= UNI_SUR_LOW_END)
					{
						ch = ((ch - UNI_SUR_HIGH_START) << halfShift) + (ch2 - UNI_SUR_LOW_START) + halfBase;
						// found a valid character
					}
					else
					{
						container ~= UNI_REPLACEMENT_CHAR;
						return container;
					}
				}
				else
				{
					/* We don't have the 16 bits following the high surrogate. */
					// sourceExhausted
					container ~= UNI_REPLACEMENT_CHAR;
					return container;
				}
			}
			// else: found a valid character
			if (container.length > 0)
			{
				if (isDeadChar(ch))
				{
					container ~= ch;
				}
				else
				{
					break;
				}
			}
			else
			{
				container ~= ch;
			}
		}

		return container;
	}

	dchar[] toUtf32Chars(StringLiteral32 src)
	{
		CharLiteral32[] container;

		if (src.length == 0)
		{
			return [];
		}

		container ~= src[0];

		foreach(s; src[1..$])
		{
			if (isDeadChar(s))
			{
				container ~= s;
			}
			else
			{
				break;
			}
		}

		return cast(dchar[])container;
	}




	wchar[] toUtf16Chars(StringLiteral32 src)
	{
		CharLiteral16[] container;

		if (src.length == 0)
		{
			return cast(wchar[])container;
		}

		CharLiteral32* source = src.ptr;
		CharLiteral32* sourceEnd = &src[$-1] + 1;

		dchar ch;

		while (source < sourceEnd) {
			ch = *source++;
			if (ch <= UNI_MAX_BMP)
			{
				/* Target is a character <= 0xFFFF */

				/* UTF-16 surrogate values are illegal in UTF-32; 0xffff or 0xfffe are both reserved values */
				if (ch >= UNI_SUR_HIGH_START && ch <= UNI_SUR_LOW_END)
				{
					if (container.length == 0)
					{
						container ~= UNI_REPLACEMENT_CHAR;
					}
					return cast(wchar[])container;
				}
				else
				{
					if (container.length > 0 && !isDeadChar(ch))
					{
						break;
					}
					container ~= cast(wchar)ch; /* normal case */
				}
			}
			else if (ch > UNI_MAX_LEGAL_UTF32)
			{
				if (container.length == 0)
				{
					container ~= UNI_REPLACEMENT_CHAR;
				}
				return cast(wchar[])container;
			}
			else
			{
				/* target is a character in range 0xFFFF - 0x10FFFF. */
				ch -= halfBase;
				if (container.length > 0 && !isDeadChar(ch))
				{
					break;
				}
				container ~= cast(CharLiteral16)((ch >> halfShift) + UNI_SUR_HIGH_START);
				container ~= cast(CharLiteral16)((ch & halfMask) + UNI_SUR_LOW_START);
			}
		}

		return cast(wchar[])container;
	}




	char[] toUtf8Chars(StringLiteral32 src)
	{
		CharLiteral8[] container;

		if (src.length == 0)
		{
			return [];
		}

		CharLiteral32* source = src.ptr;
		CharLiteral32* sourceEnd = &src[$-1] + 1;

		dchar ch;

		return cast(char[])container;
	}




	// string length stuffs
	uint utflen(StringLiteral8 src)
	{
		if (src.length == 0)
		{
			return 0;
		}

		CharLiteral8* source = src.ptr;
		CharLiteral8* sourceEnd = &src[$-1] + 1;

		ushort extraBytesToRead;

		dchar ch;

		uint len;

		while (source < sourceEnd) {
			ch = 0;
			extraBytesToRead = trailingBytesForUTF8[*source];

			if (source + extraBytesToRead >= sourceEnd) {
				// sourceExhausted
				break;
			}

			if (!isLegalUTF8(source, extraBytesToRead+1)) {
				// sourceIllegal
				break;
			}

			/*
			 * The cases all fall through. See "Note A" below.
			 */
			switch (extraBytesToRead) {
				case 5: ch += *source++; ch <<= 6;
				case 4: ch += *source++; ch <<= 6;
				case 3: ch += *source++; ch <<= 6;
				case 2: ch += *source++; ch <<= 6;
				case 1: ch += *source++; ch <<= 6;
				case 0: ch += *source++;
				default: break;
			}

			ch -= offsetsFromUTF8[extraBytesToRead];

			if (ch <= UNI_MAX_LEGAL_UTF32) {
				/*
				 * UTF-16 surrogate values are illegal in UTF-32, and anything
				 * over Plane 17 (> 0x10FFFF) is illegal.
				 */
				if (ch >= UNI_SUR_HIGH_START && ch <= UNI_SUR_LOW_END)
				{
					ch = UNI_REPLACEMENT_CHAR;
				}
			}
			else
			{
				/* i.e., ch > UNI_MAX_LEGAL_UTF32 */
				// sourceIllegal
				ch = UNI_REPLACEMENT_CHAR;
			}

			// if it is not a dead character
			if (!isDeadChar(ch))
			{
				// it is a valid character
				len++;
			}
		}

		return len;
	}

	uint utflen(StringLiteral16 src)
	{
		if (src.length == 0)
		{
			return 0;
		}

		CharLiteral16* source = src.ptr;
		CharLiteral16* sourceEnd = &src[$-1] + 1;

		uint len = 0;

		dchar ch, ch2;

		while(source < sourceEnd)
		{
			ch = *source++;
			if (ch >= UNI_SUR_HIGH_START && ch <= UNI_SUR_HIGH_END)
			{
				if (source < sourceEnd)
				{
					ch2 = *source;
					if (!(ch2 >= UNI_SUR_LOW_START && ch2 <= UNI_SUR_LOW_END))
					{
						// invalid surrogate
						source--;
						ch = UNI_REPLACEMENT_CHAR;
					}
					else
					{
						ch = ((ch - UNI_SUR_HIGH_START) << halfShift) + (ch2 - UNI_SUR_LOW_START) + halfBase;
					}
				}
				else
				{
					break;
				}
			}

			// if it is not a dead character
			if (!isDeadChar(ch))
			{
				// it is a valid character
				len++;
			}
		}

		return len;
	}

	uint utflen(StringLiteral32 src)
	{
		if (src.length == 0)
		{
			return 0;
		}

		uint len;

		for (int i=0; i<src.length; i++)
		{
			// if it is not a dead character
			if (!isDeadChar(src[i]))
			{
				// it is a valid character
				len++;
			}
		}

		return len;
	}








	// Unicode Indices

	uint[] calcIndices(StringLiteral8 src)
	{
		if (src is null)
		{
			return [];
		}

		uint[] ret = new uint[src.length];

		CharLiteral8* source = src.ptr;
		CharLiteral8* sourceEnd = &src[$-1] + 1;

		ushort extraBytesToRead;

		dchar ch;

		uint len;
		uint i;
		uint* retPtr = ret.ptr;

		while (source < sourceEnd) {
			ch = 0;
			extraBytesToRead = trailingBytesForUTF8[*source];

			if (source + extraBytesToRead >= sourceEnd) {
				// sourceExhausted
				break;
			}

			if (!isLegalUTF8(source, extraBytesToRead+1)) {
				// sourceIllegal
				break;
			}

			/*
			 * The cases all fall through. See "Note A" below.
			 */
			switch (extraBytesToRead) {
				case 5: ch += *source++; ch <<= 6;
				case 4: ch += *source++; ch <<= 6;
				case 3: ch += *source++; ch <<= 6;
				case 2: ch += *source++; ch <<= 6;
				case 1: ch += *source++; ch <<= 6;
				case 0: ch += *source++;
				default: break;
			}

			ch -= offsetsFromUTF8[extraBytesToRead];

			if (ch <= UNI_MAX_LEGAL_UTF32) {
				/*
				 * UTF-16 surrogate values are illegal in UTF-32, and anything
				 * over Plane 17 (> 0x10FFFF) is illegal.
				 */
				if (ch >= UNI_SUR_HIGH_START && ch <= UNI_SUR_LOW_END)
				{
					ch = UNI_REPLACEMENT_CHAR;
				}
			}
			else
			{
				/* i.e., ch > UNI_MAX_LEGAL_UTF32 */
				// sourceIllegal
				ch = UNI_REPLACEMENT_CHAR;
			}

			// if it is not a dead character
			if (!isDeadChar(ch))
			{
				// it is a valid character
				*retPtr++ = i;
				len++;
			}

			i += extraBytesToRead+1;
		}

		return ret[0..len];
	}

	uint[] calcIndices(StringLiteral16 src)
	{
		if (src is null)
		{
			return [];
		}

		uint[] ret = new uint[src.length];

		CharLiteral16* source = src.ptr;
		CharLiteral16* sourceEnd = &src[$-1] + 1;

		uint len;
		uint i;
		uint mv;
		uint* retPtr = ret.ptr;

		dchar ch, ch2;

		while(source < sourceEnd)
		{
			ch = *source++;
			mv++;
			if (ch >= UNI_SUR_HIGH_START && ch <= UNI_SUR_HIGH_END)
			{
				if (source < sourceEnd)
				{
					ch2 = *source++;
					mv++;
					if (!(ch2 >= UNI_SUR_LOW_START && ch2 <= UNI_SUR_LOW_END))
					{
						// invalid surrogate
						mv--;
						source--;
						ch = UNI_REPLACEMENT_CHAR;
					}
					else
					{
						ch = ((ch - UNI_SUR_HIGH_START) << halfShift) + (ch2 - UNI_SUR_LOW_START) + halfBase;
					}
				}
				else
				{
					break;
				}
			}

			// if it is not a dead character
			if (!isDeadChar(ch))
			{
				// it is a valid character
				*retPtr++ = i;
				len++;
			}

			i += mv;
			mv = 0;
		}

		return ret[0..len];
	}

	uint[] calcIndices(StringLiteral32 src)
	{
		if (src is null)
		{
			return [];
		}

		uint[] ret = new uint[src.length];

		uint len;

		for (int i=0; i<src.length; i++)
		{
			// if it is not a dead character
			if (!isDeadChar(src[i]))
			{
				// it is a valid character
				ret[len] = i;
				len++;
			}
		}

		return ret;
	}


	dchar fromCP866(char chr)
	{
		if (chr < 0x80)
		{
			return cast(dchar)chr;
		}

		return CP866_to_UTF32[chr-128];
	}


private:
	// Codepage Encodings

	dchar CP866_to_UTF32[] = [

		0x0410, 0x0411, 0x0412, 0x0413, 0x0414, 0x0415, 0x0416, 0x0417, 0x0418, 0x0419, 0x041a, 0x041b, 0x041c, 0x041d, 0x041e, 0x041f,
		0x0420, 0x0421, 0x0422, 0x0423, 0x0424, 0x0425, 0x0426, 0x0427, 0x0428, 0x0429, 0x042a, 0x042b, 0x042c, 0x042d, 0x042e, 0x042f,
		0x0430, 0x0431, 0x0432, 0x0433, 0x0434, 0x0435, 0x0436, 0x0437, 0x0438, 0x0439, 0x043a, 0x043b, 0x043c, 0x043d, 0x043e, 0x043f,

		0x2591, 0x2592, 0x2593, 0x2502, 0x2524, 0x2561, 0x2562, 0x2556, 0x2555, 0x2563, 0x2551, 0x2557, 0x255D, 0x255C, 0x255B, 0x2510,
		0x2514, 0x2534, 0x252C, 0x251C, 0x2500, 0x253C, 0x255E, 0x255F, 0x255A, 0x2554, 0x2569, 0x2566, 0x2560, 0x2550, 0x256C, 0x2567,
		0x2568, 0x2564, 0x2565, 0x2559, 0x2558, 0x2552, 0x2553, 0x256B, 0x256A, 0x2518, 0x250C, 0x2588, 0x2584, 0x258C, 0x2590, 0x2580,

		0x0440, 0x0441, 0x0442, 0x0443, 0x0444, 0x0445, 0x0446, 0x0447, 0x0448, 0x0449, 0x044a, 0x044b, 0x044c, 0x044d, 0x044e, 0x044F,
		0x0401, 0x0451, 0x0404, 0x0454, 0x0407, 0x0457, 0x040E, 0x045E, 0x00B0, 0x2219, 0x00B7, 0x221A, 0x2116, 0x00A4, 0x25A0, 0x00A0,

	];

}
