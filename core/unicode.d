/*
 * unicode.d
 *
 * This module implements unicode functions that were badly needed.
 *
 * Author: Dave Wilkinson
 *
 */

module core.unicode;

import core.definitions;
import core.util;

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

private static const ubyte firstByteMark[7] = [ 0x00, 0x00, 0xC0, 0xE0, 0xF0, 0xF8, 0xFC ];

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

private bool isLegalUTF8(char* source, int length) {
    char a;
    char *srcptr = source+length;
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

struct Unicode {
static:
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

public:

	string toUtf8(string src) {
		return cast(string)src.dup;
	}

	string toUtf8(wstring src) {
		if (src.length == 0) {
			return cast(string)"";
		}

		char[] container = new char[src.length*4];

		const auto byteMask = 0xBF;
		const auto byteMark = 0x80;

		wchar* source = src.ptr;
		wchar* sourceEnd = &src[$-1] + 1;

		char* target = container.ptr;
		char* targetEnd = &container[$-1] + 1;

		uint bytesToWrite;

		dchar ch;

		while(source !is sourceEnd) {

			ch = *source++;

			// If we have a surrogate pair, we convert to UTF-32
			if (ch >= UNI_SUR_HIGH_START && ch <= UNI_SUR_HIGH_END) {
				dchar ch2 = cast(dchar)*source;

				/* If it's a low surrogate, convert to UTF32. */
				if (ch2 >= UNI_SUR_LOW_START && ch2 <= UNI_SUR_LOW_END) {
					ch = ((ch - UNI_SUR_HIGH_START) << 10) + (ch2 - UNI_SUR_LOW_START) + halfBase;
					source++;
				}
				else {
					// unpaired high surrogate
					// illegal

					// TODO: do not break, just add a character and continue to produce valid string
					source--;
					break;
				}
			}
			else if (ch >= UNI_SUR_LOW_START && ch <= UNI_SUR_LOW_END) {
				// illegal

				// TODO: do not break, just add a character and continue to produce valid string
				source--;
				break;
			}

			/* Figure out how many bytes the result will require */
			if (ch < cast(dchar)0x80) {
				bytesToWrite = 1;
			}
			else if (ch < cast(dchar)0x800) {
				bytesToWrite = 2;
			}
			else if (ch < cast(dchar)0x10000) {
				bytesToWrite = 3;
			}
			else if (ch < cast(dchar)0x110000) {
				bytesToWrite = 4;
			}
			else {
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

		return container[0..target - container.ptr];
//		return "";
	}

	string toUtf8(dstring src) {
		if (src is null || src.length == 0) {
			return cast(string)"";
		}

		char[] container = new char[src.length*4];

		const auto byteMask = 0xBF;
		const auto byteMark = 0x80;

		dchar* source = src.ptr;
		dchar* sourceEnd = &src[$-1] + 1;

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

			if (ch < cast(dchar)0x80) {
				bytesToWrite = 1;
			}
			else if (ch < cast(dchar)0x800) {
				bytesToWrite = 2;
			}
			else if (ch < cast(dchar)0x10000) {
				bytesToWrite = 3;
			}
			else if (ch <= UNI_MAX_LEGAL_UTF32) {
				bytesToWrite = 4;
			}
			else {
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

		string ret = cast(string)container[0..targetLen];
		return ret;
	}

	wstring toUtf16(string src) {
		if (src.length == 0) {
			return cast(wstring)"";
		}

		wchar[] container = new wchar[src.length];

		char* source = src.ptr;
		char* sourceEnd = &src[$-1] + 1;

		wchar* target = container.ptr;
		wchar* targetEnd = &container[$-1] + 1;

		dchar ch;

		while (source < sourceEnd) {
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
				if (ch >= UNI_SUR_HIGH_START && ch <= UNI_SUR_LOW_END) {
					// illegal
					*target++ = UNI_REPLACEMENT_CHAR;
				}
				else {
					*target++ = cast(wchar)ch; /* normal case */
				}
			}
			else if (ch > UNI_MAX_UTF16) {
				// illegal
				*target++ = UNI_REPLACEMENT_CHAR;
			}
			else {
				/* target is a character in range 0xFFFF - 0x10FFFF. */

				ch -= halfBase;
				*target++ = cast(wchar)((ch >> halfShift) + UNI_SUR_HIGH_START);
				*target++ = cast(wchar)((ch & halfMask) + UNI_SUR_LOW_START);
			}
		}

		return cast(wstring)container[0..target - container.ptr];
	}

	wstring toUtf16(wstring src) {
		return cast(wstring)src.dup;
	}

	wstring toUtf16(dstring src) {
		if (src.length == 0) {
			return cast(wstring)"";
		}

		wchar[] container = new wchar[src.length];

		dchar* source = src.ptr;
		dchar* sourceEnd = &src[$-1] + 1;

		wchar* target = container.ptr;
		wchar* targetEnd = &container[$-1] + 1;

		dchar ch;

		while (source < sourceEnd) {
			ch = *source++;
			if (ch <= UNI_MAX_BMP) {
				/* Target is a character <= 0xFFFF */

				/* UTF-16 surrogate values are illegal in UTF-32; 0xffff or 0xfffe are both reserved values */
				if (ch >= UNI_SUR_HIGH_START && ch <= UNI_SUR_LOW_END) {
					*target++ = UNI_REPLACEMENT_CHAR;
				}
				else {
					*target++ = cast(wchar)ch; /* normal case */
				}
			}
			else if (ch > UNI_MAX_LEGAL_UTF32) {
				*target++ = UNI_REPLACEMENT_CHAR;
			}
			else {
				/* target is a character in range 0xFFFF - 0x10FFFF. */
				ch -= halfBase;
				*target++ = cast(wchar)((ch >> halfShift) + UNI_SUR_HIGH_START);
				*target++ = cast(wchar)((ch & halfMask) + UNI_SUR_LOW_START);
			}
		}

		return cast(wstring)container[0..target - container.ptr];
	}

	dstring toUtf32(string src) {
		if (src.length == 0) {
			return cast(dstring)"";
		}

		dchar[] container = new dchar[src.length];

		char* source = src.ptr;
		char* sourceEnd = &src[$-1] + 1;

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
				if (ch >= UNI_SUR_HIGH_START && ch <= UNI_SUR_LOW_END) {
					*target++ = UNI_REPLACEMENT_CHAR;
				}
				else {
					*target++ = ch;
				}
			}
			else {
				/* i.e., ch > UNI_MAX_LEGAL_UTF32 */
				// sourceIllegal
				*target++ = UNI_REPLACEMENT_CHAR;
			}
		}

		return cast(dstring)container[0..target - container.ptr];
	}

	dstring toUtf32(wstring src) {
		if (src.length == 0) {
			return cast(dstring)"";
		}

		dchar[] container = new dchar[src.length];

		wchar* source = src.ptr;
		wchar* sourceEnd = &src[$-1] + 1;

		dchar* target = container.ptr;
		dchar* targetEnd = &container[$-1] + 1;

		dchar ch, ch2;

		while (source < sourceEnd) {
			ch = *source++;
			/* If we have a surrogate pair, convert to UTF32 first. */
			if (ch >= UNI_SUR_HIGH_START && ch <= UNI_SUR_HIGH_END) {
				/* If the 16 bits following the high surrogate are in the source buffer... */
				if (source < sourceEnd) {
					ch2 = *source;
					/* If it's a low surrogate, convert to UTF32. */
					if (ch2 >= UNI_SUR_LOW_START && ch2 <= UNI_SUR_LOW_END) {
						ch = ((ch - UNI_SUR_HIGH_START) << halfShift) + (ch2 - UNI_SUR_LOW_START) + halfBase;
						source++;
					}
				}
				else {
					/* We don't have the 16 bits following the high surrogate. */
					//--source; /* return to the high surrogate */
					// sourceExhausted
					break;
				}
			}

			*target++ = ch;
		}

		return cast(dstring)container[0..target - container.ptr];
	}

	dstring toUtf32(dstring src) {
		return cast(dstring)src.dup;
	}

	// character conversions
	dchar toUtf32Char(string src) {
		// grab the first character,
		// convert it to a UTF-32 character,
		// and then return
		return toUtf32(src)[0];
	}

	dchar toUtf32Char(wstring src) {
		return toUtf32(src)[0];
	}

	dchar toUtf32Char(dstring src) {
		// Useless function
		return src[0];
	}

	bool isDeadChar(char[] chr) {
		dchar dchr = toUtf32Char(chr);
		return isDeadChar(dchr);
	}

	bool isDeadChar(wchar[] chr) {
		dchar dchr = toUtf32Char(chr);
		return isDeadChar(dchr);
	}

	bool isDeadChar(dchar[] chr) {
		return isDeadChar(chr[0]);
	}

	private template BuildDeadList(string content) {
		const string BuildDeadList = `static bool _isDead[] = [
			` ~ content[0..$-1]
			~ `
			];
		`;
	}

	private template BuildDeadListItemsImpl(uint index = 0, items...) {
		static if (index == items.length) {
			const string BuildDeadListItemsImpl = "";
		}
		else {
			const string BuildDeadListItemsImpl = `
				` ~ items[index].stringof ~ `: true,
` ~ BuildDeadListItemsImpl!(index+1,items);
		}
	}

	private template BuildDeadListItems(items...) {
		const string BuildDeadListItems = BuildDeadListItemsImpl!(0, items);
	}

	bool isDeadChar(dchar chr) {
		// Because Unicode spec cannot put these in order
		// since that would be too useful.

		mixin(BuildDeadList!(
			// Combining Diacritical Marks
			BuildDeadListItems!(Range!(0x300, 0x36F)) ~
			// Hebrew
			BuildDeadListItems!(Range!(0x591, 0x5bd), 0x5c1, 0x5c2, 0x5c4, 0x5c5, 0x5c7) ~
			// Arabic
			BuildDeadListItems!(Range!(0x610, 0x61a), Range!(0x64b, 0x65e),	0x670, Range!(0x6d6, 0x6dc)) ~
			BuildDeadListItems!(Range!(0x6df, 0x6e4), 0x6e7, 0x6e8, Range!(0x6ea, 0x6ed)) ~
			// Syriac
			BuildDeadListItems!(0x711, Range!(0x730, 0x74a)) ~
			// Thaana
			BuildDeadListItems!(Range!(0x7a6, 0x7b0)) ~
			// NKO
			BuildDeadListItems!(Range!(0x7eb, 0x7f3)) ~
			// Devanagari
			BuildDeadListItems!(0x901, 0x902, 0x93c, Range!(0x941, 0x948), 0x94d, Range!(0x951, 0x954),
			0x962, 0x963) ~
			// Bengali
			BuildDeadListItems!(0x981, 0x9bc, Range!(0x9c1, 0x9c4), 0x9cd, 0x9e2, 0x9e3) ~
			// Gurmukhi
			BuildDeadListItems!(0xa01, 0xa02, 0xa3c, 0xa41, 0xa42, 0xa47, 0xa48, Range!(0xa4b, 0xa4d),
			0xa51, 0xa70, 0xa71, 0xa75, 0xa81, 0xa82, 0xabc, Range!(0xac1, 0xac5),
			0xac7, 0xac8, 0xacd, 0xae2, 0xae3) ~
			// Oriya
			BuildDeadListItems!(0xb01, 0xb3c, 0xb3f, Range!(0xb41, 0xb44), 0xb4d, 0xb56, 0xb62, 0xb63) ~
			// Tamil
			BuildDeadListItems!(0xb82, 0xbc0, 0xbcd) ~
			// Telugu
			BuildDeadListItems!(0xc3e, 0xc3f, 0xc40, Range!(0xc46, 0xc48), Range!(0xc4a, 0xc4d), 0xc55,
			0xc56, 0xc62, 0xc63) ~
			// Kannada
			BuildDeadListItems!(0xcbc, 0xcbf, 0xcc6, 0xccc, 0xccd, 0xce2, 0xce3) ~
			// Malayalam
			BuildDeadListItems!(Range!(0xd41, 0xd44), 0xd4d, 0xd62, 0xd63) ~
			// Sinhala
			BuildDeadListItems!(0xdca, Range!(0xdd2, 0xdd4), 0xdd6) ~
			// Thai
			BuildDeadListItems!(0xe31, Range!(0xe34, 0xe3a), Range!(0xe47, 0xe4e)) ~
			// Lao
			BuildDeadListItems!(0xeb1, Range!(0xeb4, 0xeb9), 0xebb, 0xebc, Range!(0xec8, 0xecd)) ~
			// Tibetan
			BuildDeadListItems!(0xf18, 0xf19, 0xf35, 0xf37, 0xf39, Range!(0xf71, 0xf7e),
			Range!(0xf80, 0xf84), 0xf86, 0xf87, Range!(0xf90, 0xfbc), 0xfc6) ~
			// Myanmar
			BuildDeadListItems!(Range!(0x102d, 0x1030), Range!(0x1032, 0x1037), 0x1039, 0x103a, 0x103d,
			0x103e, 0x1058, 0x1059, Range!(0x105e, 0x1060), Range!(0x1071, 0x1074),
			0x1082, 0x1085, 0x1086, 0x108d) ~
			// Ethiopic
			BuildDeadListItems!(0x135f) ~
			// Tagalog
			BuildDeadListItems!(Range!(0x1712, 0x1714)) ~
			// Hanunoo
			BuildDeadListItems!(Range!(0x1732, 0x1734)) ~
			// Buhid
			BuildDeadListItems!(0x1752, 0x1753) ~
			// Tagbanwa
			BuildDeadListItems!(0x1772, 0x1773) ~
			// Khmer
			BuildDeadListItems!(Range!(0x17b7, 0x17bd), 0x17c6, Range!(0x17c9, 0x17d3), 0x17dd) ~
			// Mongolian
			BuildDeadListItems!(Range!(0x180b, 0x180d), 0x18a9) ~
			// Limbu
			BuildDeadListItems!(Range!(0x1920, 0x1922), 0x1927, 0x1928, 0x1932, Range!(0x1939, 0x193b)) ~
			// Buginese
			BuildDeadListItems!(0x1a17, 0x1a18) ~
			// Balinese
			BuildDeadListItems!(Range!(0x1b00, 0x1b03), 0x1b34, Range!(0x1b36, 0x1b3a), 0x1b3c, 0x1b42,
			Range!(0x1b6b, 0x1b73)) ~
			// Sundanese
			BuildDeadListItems!(0x1b80, 0x1b81, Range!(0x1ba2, 0x1ba5), 0x1ba8, 0x1ba9) ~
			// Lepcha
			BuildDeadListItems!(Range!(0x1c2c, 0x1c33), 0x1c36, 0x1c37) ~
			// Combining Diacritical Marks Supplement
			BuildDeadListItems!(Range!(0x1dc0, 0x1dff)) ~
			// Combining Diacritical Marks for Symbols
			BuildDeadListItems!(Range!(0x20d0, 0x20ff)) ~
			// Combining Cyrillic
			BuildDeadListItems!(Range!(0x2d30, 0x2dff)) ~
			// Ideographic
			BuildDeadListItems!(Range!(0x302a, 0x302d)) ~
			// Hangul
			BuildDeadListItems!(0x302e, 0x302f) ~
			// Combining Katakana-Hiragana
			BuildDeadListItems!(0x3099, 0x309a) ~
			// Combining Cyrillic
			BuildDeadListItems!(0xa66f, 0xa67c, 0xa67d) ~
			// Syloti
			BuildDeadListItems!(0xa802, 0xa806, 0xa80b, 0xa825, 0xa826) ~
			// Saurashtra
			BuildDeadListItems!(0xa8c4) ~
			// Kayah
			BuildDeadListItems!(Range!(0xa926, 0xa92d)) ~
			// Rejang
			BuildDeadListItems!(Range!(0xa947, 0xa951)) ~
			// Cham
			BuildDeadListItems!(Range!(0xaa29, 0xaa2e), 0xaa31, 0xaa32, 0xaa35, 0xaa36, 0xaa43, 0xaa4c) ~
			// Hebrew Judeo-Spanish Varika
			BuildDeadListItems!(0xfb1e) ~
			// Variation Selector
			BuildDeadListItems!(Range!(0xfe00, 0xfe0f)) ~
			// Combining Half Marks
			BuildDeadListItems!(Range!(0xfe20, 0xfeff)) ~
			// Phaistos Disc Sign Combining Oblique Stroke
			BuildDeadListItems!(0x101dd) ~
			// Kharoshthi
			BuildDeadListItems!(Range!(0x10a01, 0x10a03), 0x10a05, 0x10a06, Range!(0x10a0c, 0x10a0f),
			0x10a38, 0x10a39, 0x10a3a, 0x10a3f) ~
			// Musical Symbols
			BuildDeadListItems!(Range!(0x1d167, 0x1d169), Range!(0x1d17b, 0x1d182),
			Range!(0x1d185, 0x1d18b), Range!(0x1d1aa, 0x1d1ad)) ~
			// Combining Greek Musical Symbols
			BuildDeadListItems!(Range!(0x1d242, 0x1d244))
		));

		return (chr < _isDead.length && _isDead[chr]);
	}

	// character conversions
	dchar[] toUtf32Chars(string src) {
		// grab the first character,
		// convert it to a UTF-32 character,
		// and then return

		dchar[] container;

		if (src.length == 0) {
			return [];
		}

		char* source = src.ptr;
		char* sourceEnd = &src[$-1] + 1;
		ushort extraBytesToRead;

		dchar ch;

		while (source < sourceEnd) {
			ch = 0;

			extraBytesToRead = trailingBytesForUTF8[*source];

			if (source + extraBytesToRead >= sourceEnd) {
				// sourceExhausted
				if (container.length == 0) {
					container ~=  UNI_REPLACEMENT_CHAR;
				}
				return container;
			}

			if (!isLegalUTF8(source, extraBytesToRead+1)) {
				// sourceIllegal
				if (container.length == 0) {
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
				if (ch >= UNI_SUR_HIGH_START && ch <= UNI_SUR_LOW_END) {
					if (container.length == 0) {
						container ~=  UNI_REPLACEMENT_CHAR;
					}
					return container;
				}
				// else: found a valid character
			}
			else {
				/* i.e., ch > UNI_MAX_LEGAL_UTF32 */
				// sourceIllegal
				if (container.length == 0) {
					container ~=  UNI_REPLACEMENT_CHAR;
				}
				return container;
			}

			if (container.length > 0) {
				if (!isDeadChar(ch)) {
					break;
				}
			}
			container ~=  ch;
		}

		return container;
	}

	dchar[] toUtf32Chars(wstring src) {
		// grab the first character,
		// convert it to a UTF-32 character,
		// and then return
		dchar[] container;

		if (src.length == 0) {
			return [];
		}

		wchar* source = src.ptr;
		wchar* sourceEnd = &src[$-1] + 1;

		dchar ch, ch2;

		while(source < sourceEnd) {
			ch = *source++;
			/* If we have a surrogate pair, convert to UTF32 first. */
			if (ch >= UNI_SUR_HIGH_START && ch <= UNI_SUR_HIGH_END) {
				/* If the 16 bits following the high surrogate are in the source buffer... */
				if (source < sourceEnd) {
					ch2 = *source;
					/* If it's a low surrogate, convert to UTF32. */
					if (ch2 >= UNI_SUR_LOW_START && ch2 <= UNI_SUR_LOW_END) {
						ch = ((ch - UNI_SUR_HIGH_START) << halfShift) + (ch2 - UNI_SUR_LOW_START) + halfBase;
						// found a valid character
					}
					else {
						container ~= UNI_REPLACEMENT_CHAR;
						return container;
					}
				}
				else {
					/* We don't have the 16 bits following the high surrogate. */
					// sourceExhausted
					container ~= UNI_REPLACEMENT_CHAR;
					return container;
				}
			}
			// else: found a valid character
			if (container.length > 0) {
				if (isDeadChar(ch)) {
					container ~= ch;
				}
				else {
					break;
				}
			}
			else {
				container ~= ch;
			}
		}

		return container;
	}

	dchar[] toUtf32Chars(dstring src) {
		dchar[] container;

		if (src.length == 0) {
			return [];
		}

		container ~= src[0];

		foreach(s; src[1..$]) {
			if (isDeadChar(s)) {
				container ~= s;
			}
			else {
				break;
			}
		}

		return cast(dchar[])container;
	}

	wchar[] toUtf16Chars(dstring src) {
		wchar[] container;

		if (src.length == 0) {
			return cast(wchar[])container;
		}

		dchar* source = src.ptr;
		dchar* sourceEnd = &src[$-1] + 1;

		dchar ch;

		while (source < sourceEnd) {
			ch = *source++;
			if (ch <= UNI_MAX_BMP) {
				/* Target is a character <= 0xFFFF */

				/* UTF-16 surrogate values are illegal in UTF-32; 0xffff or 0xfffe are both reserved values */
				if (ch >= UNI_SUR_HIGH_START && ch <= UNI_SUR_LOW_END) {
					if (container.length == 0) {
						container ~= UNI_REPLACEMENT_CHAR;
					}
					return cast(wchar[])container;
				}
				else {
					if (container.length > 0 && !isDeadChar(ch)) {
						break;
					}
					container ~= cast(wchar)ch; /* normal case */
				}
			}
			else if (ch > UNI_MAX_LEGAL_UTF32) {
				if (container.length == 0) {
					container ~= UNI_REPLACEMENT_CHAR;
				}
				return cast(wchar[])container;
			}
			else {
				/* target is a character in range 0xFFFF - 0x10FFFF. */
				ch -= halfBase;
				if (container.length > 0 && !isDeadChar(ch)) {
					break;
				}
				container ~= cast(wchar)((ch >> halfShift) + UNI_SUR_HIGH_START);
				container ~= cast(wchar)((ch & halfMask) + UNI_SUR_LOW_START);
			}
		}

		return cast(wchar[])container;
	}

	char[] toUtf8Chars(dstring src) {
		char[] container;

		if (src.length == 0) {
			return [];
		}

		dchar* source = src.ptr;
		dchar* sourceEnd = &src[$-1] + 1;

		dchar ch;

		return cast(char[])container;
	}

	// string length stuffs
	uint utflen(string src) {
		if (src.length == 0) {
			return 0;
		}

		char* source = src.ptr;
		char* sourceEnd = &src[$-1] + 1;

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
				if (ch >= UNI_SUR_HIGH_START && ch <= UNI_SUR_LOW_END) {
					ch = UNI_REPLACEMENT_CHAR;
				}
			}
			else {
				/* i.e., ch > UNI_MAX_LEGAL_UTF32 */
				// sourceIllegal
				ch = UNI_REPLACEMENT_CHAR;
			}

			// if it is not a dead character
			if (!isDeadChar(ch)) {
				// it is a valid character
				len++;
			}
		}

		return len;
	}

	uint utflen(wstring src) {
		if (src.length == 0) {
			return 0;
		}

		wchar* source = src.ptr;
		wchar* sourceEnd = &src[$-1] + 1;

		uint len = 0;

		dchar ch, ch2;

		while(source < sourceEnd) {
			ch = *source++;
			if (ch >= UNI_SUR_HIGH_START && ch <= UNI_SUR_HIGH_END) {
				if (source < sourceEnd) {
					ch2 = *source;
					if (!(ch2 >= UNI_SUR_LOW_START && ch2 <= UNI_SUR_LOW_END)) {
						// invalid surrogate
						source--;
						ch = UNI_REPLACEMENT_CHAR;
					}
					else {
						ch = ((ch - UNI_SUR_HIGH_START) << halfShift) + (ch2 - UNI_SUR_LOW_START) + halfBase;
					}
				}
				else {
					break;
				}
			}

			// if it is not a dead character
			if (!isDeadChar(ch)) {
				// it is a valid character
				len++;
			}
		}

		return len;
	}

	uint utflen(dstring src) {
		if (src.length == 0) {
			return 0;
		}

		uint len;

		for (int i=0; i<src.length; i++) {
			// if it is not a dead character
			if (!isDeadChar(src[i])) {
				// it is a valid character
				len++;
			}
		}

		return len;
	}

	// Unicode Indices

	uint[] calcIndices(string src) {
		if (src is null || src == "") {
			return [];
		}

		uint[] ret = new uint[src.length];

		char* source = src.ptr;
		char* sourceEnd = &src[$-1] + 1;

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
				if (ch >= UNI_SUR_HIGH_START && ch <= UNI_SUR_LOW_END) {
					ch = UNI_REPLACEMENT_CHAR;
				}
			}
			else {
				/* i.e., ch > UNI_MAX_LEGAL_UTF32 */
				// sourceIllegal
				ch = UNI_REPLACEMENT_CHAR;
			}

			// if it is not a dead character
			if (!isDeadChar(ch)) {
				// it is a valid character
				*retPtr++ = i;
				len++;
			}

			i += extraBytesToRead+1;
		}

		return ret[0..len];
	}

	uint[] calcIndices(wstring src) {
		if (src is null || src == "") {
			return [];
		}

		uint[] ret = new uint[src.length];

		wchar* source = src.ptr;
		wchar* sourceEnd = &src[$-1] + 1;

		uint len;
		uint i;
		uint mv;
		uint* retPtr = ret.ptr;

		dchar ch, ch2;

		while(source < sourceEnd) {
			ch = *source++;
			mv++;
			if (ch >= UNI_SUR_HIGH_START && ch <= UNI_SUR_HIGH_END) {
				if (source < sourceEnd) {
					ch2 = *source++;
					mv++;
					if (!(ch2 >= UNI_SUR_LOW_START && ch2 <= UNI_SUR_LOW_END)) {
						// invalid surrogate
						mv--;
						source--;
						ch = UNI_REPLACEMENT_CHAR;
					}
					else {
						ch = ((ch - UNI_SUR_HIGH_START) << halfShift) + (ch2 - UNI_SUR_LOW_START) + halfBase;
					}
				}
				else {
					break;
				}
			}

			// if it is not a dead character
			if (!isDeadChar(ch)) {
				// it is a valid character
				*retPtr++ = i;
				len++;
			}

			i += mv;
			mv = 0;
		}

		return ret[0..len];
	}

	uint[] calcIndices(dstring src) {
		if (src is null || src == "") {
			return [];
		}

		uint[] ret = new uint[src.length];

		uint len;

		for (int i=0; i<src.length; i++) {
			// if it is not a dead character
			if (!isDeadChar(src[i])) {
				// it is a valid character
				ret[len] = i;
				len++;
			}
		}

		return ret;
	}

	bool isStartChar(char chr) {
		// Look for non-surrogate entries
		if ((chr & 0b11000000) == 0b10000000) { // Signature for a follow up byte
			return false;
		}
		return true;
	}

	bool isStartChar(wchar chr) {
		// Look for non-surrogate entries
		if (chr >= UNI_SUR_LOW_START && chr <= UNI_SUR_LOW_END) {
			return false;
		}
		return true;
	}

	bool isStartChar(dchar chr) {
		// Obvious
		return true;
	}

	dchar fromCP866(char chr) {
		if (chr < 0x80) {
			return cast(dchar)chr;
		}

		return CP866_to_UTF32[chr-128];
	}

	dchar[] combine(dchar chr, dchar combiningMark) {
		return combine([chr], combiningMark);
	}

	dchar[] combine(dchar[] chr, dchar combiningMark) {
		switch(combiningMark) {
			case '\u0300': // grave
				switch(chr[0]) {
					case 'a':
						return "\u00e0";
					case 'e':
						return "\u00e8";
					case 'i':
						return "\u00ec";
					case 'o':
						return "\u00f2";
					case 'u':
						return "\u00f9";
					case 'A':
						return "\u00c0";
					case 'E':
						return "\u00c8";
					case 'I':
						return "\u00cc";
					case 'O':
						return "\u00d2";
					case 'U':
						return "\u00d9";
					case 'W':
						return "\u1e80";
					case 'w':
						return "\u1e81";
					case 'Y':
						return "\u1ef2";
					case 'y':
						return "\u1ef3";
					case ' ':
						return "`";
					default:
						break;
				}
				break;
			case '\u0301': // acute
				switch(chr[0]) {
					case 'a':
						return "\u00e1";
					case 'e':
						return "\u00e9";
					case 'i':
						return "\u00ed";
					case 'o':
						return "\u00f3";
					case 'u':
						return "\u00fa";
					case 'y':
						return "\u00fd";
					case 'A':
						return "\u00c1";
					case 'E':
						return "\u00c9";
					case 'I':
						return "\u00cd";
					case 'O':
						return "\u00d3";
					case 'U':
						return "\u00da";
					case 'Y':
						return "\u00dd";
					case 'C':
						return "\u0106";
					case 'c':
						return "\u0107";
					case 'L':
						return "\u0139";
					case 'l':
						return "\u013a";
					case 'N':
						return "\u0143";
					case 'n':
						return "\u0144";
					case 'R':
						return "\u0154";
					case 'r':
						return "\u0155";
					case 'S':
						return "\u015a";
					case 's':
						return "\u015b";
					case 'Z':
						return "\u0179";
					case 'z':
						return "\u017a";
					case '\u00c6': // Latin AE (capital)
						return "\u01fc";
					case '\u00e6': // Latin AE (small)
						return "\u01fd";
					case '\u00d8': // O with stroke (capital)
						return "\u01fe";
					case '\u00f8': // O with stroke (small)
						return "\u01ff";
					case 'W':
						return "\u1e82";
					case 'w':
						return "\u1e83";
					case ' ':
						return "\u00b4";
					default:
						break;
				}
				break;
			case '\u0302': // circumflex
				switch(chr[0]) {
					case 'a':
						return "\u00e2";
					case 'e':
						return "\u00ea";
					case 'i':
						return "\u00ee";
					case 'o':
						return "\u00f4";
					case 'c':
						return "\u0109";
					case 'g':
						return "\u011d";
					case 'h':
						return "\u0125";
					case 'j':
						return "\u0135";
					case 's':
						return "\u015d";
					case 'u':
						return "\u00fb";
					case 'w':
						return "\u0175";
					case 'y':
						return "\u0177";
					case 'A':
						return "\u00c2";
					case 'E':
						return "\u00ca";
					case 'I':
						return "\u00ce";
					case 'O':
						return "\u00d4";
					case 'C':
						return "\u0108";
					case 'G':
						return "\u011c";
					case 'H':
						return "\u0124";
					case 'J':
						return "\u0134";
					case 'S':
						return "\u015c";
					case 'U':
						return "\u00db";
					case 'W':
						return "\u0174";
					case 'Y':
						return "\u0176";
					case ' ':
						return "^";
					default:
						break;
				}
				break;
			case '\u0303': // tilde
				switch(chr[0]) {
					case 'a':
						return "\u00e3";
					case 'A':
						return "\u00c3";
					case 'n':
						return "\u00f1";
					case 'u':
						return "\u0169";
					case 'N':
						return "\u00d1";
					case 'U':
						return "\u0168";
					case 'o':
						return "\u00f5";
					case 'O':
						return "\u00d5";
					case 'i':
						return "\u0129";
					case 'I':
						return "\u0128";
					case ' ':
						return "~";
					default:
						break;
				}
				break;
			case '\u0304': // macron
				switch(chr[0]) {
					case 'A':
						return "\u0100";
					case 'a':
						return "\u0101";
					case 'E':
						return "\u0112";
					case 'e':
						return "\u0113";
					case 'I':
						return "\u012a";
					case 'i':
						return "\u012b";
					case 'O':
						return "\u014c";
					case 'o':
						return "\u014d";
					case 'U':
						return "\u016a";
					case 'u':
						return "\u016b";
					case '\u00c6': // Latin AE (capital)
						return "\u01e2";
					case '\u00e6': // Latin AE (small)
						return "\u01e3";
					case ' ':
						return "\u00af";
					default:
						break;
				}
				break;
			case '\u0305': // overline
				break;
			case '\u0306': // breve
				switch(chr[0]) {
					case 'A':
						return "\u0102";
					case 'a':
						return "\u0103";
					case 'E':
						return "\u0114";
					case 'e':
						return "\u0115";
					case 'G':
						return "\u011e";
					case 'g':
						return "\u011f";
					case 'I':
						return "\u012c";
					case 'i':
						return "\u012d";
					case 'O':
						return "\u014e";
					case 'o':
						return "\u014f";
					case 'U':
						return "\u016c";
					case 'u':
						return "\u016d";
					case '\u0416': // Cyrillic Letter Zhe (Capital)
						return "\u04c1";
					case '\u0436': // Cyrillic Letter Zhe (Small)
						return "\u04c2";
					case ' ':
						return "\u02d8";
					default:
						break;
				}
				break;
			case '\u0307': // dot above
				switch(chr[0]) {
					case 'C':
						return "\u010a";
					case 'c':
						return "\u010b";
					case 'E':
						return "\u0116";
					case 'e':
						return "\u0117";
					case 'G':
						return "\u0120";
					case 'g':
						return "\u0121";
					case 'I':
						return "\u0130";
					case 'Z':
						return "\u017b";
					case 'z':
						return "\u017c";
					case ' ':
						return "\u02d9";
					default:
						break;
				}
				break;
			case '\u0308': // diaeresis
				switch(chr[0]) {
					case 'a':
						return "\u00e4";
					case 'e':
						return "\u00eb";
					case 'i':
						return "\u00ef";
					case 'o':
						return "\u00f6";
					case 'u':
						return "\u00fc";
					case 'y':
						return "\u00ff";
					case 'A':
						return "\u00c4";
					case 'E':
						return "\u00cb";
					case 'I':
						return "\u00cf";
					case 'O':
						return "\u00d6";
					case 'U':
						return "\u00dc";
					case 'Y':
						return "\u00df";
					case 'W':
						return "\u1e84";
					case 'w':
						return "\u1e85";
					case ' ':
						return "\u00a8";
					default:
						break;
				}
				break;
			case '\u0309': // hook above
				break;
			case '\u030a': // ring above
				switch(chr[0]) {
					case 'A':
						return "\u00c5";
					case 'a':
						return "\u00e5";
					case 'U':
						return "\u016e";
					case 'u':
						return "\u016f";
					case ' ':
						return "\u02da";
					default:
						break;
				}
				break;
			case '\u030b': // double acute
				switch(chr[0]) {
					case 'O':
						return "\u0150";
					case 'o':
						return "\u0151";
					case 'U':
						return "\u0170";
					case 'u':
						return "\u0171";
					case ' ':
						return "\u02dd";
					default:
						break;
				}
				break;
			case '\u030c': // caron
				switch(chr[0]) {
					case 'C':
						return "\u010c";
					case 'c':
						return "\u010d";
					case 'D':
						return "\u010e";
					case 'd':
						return "\u010f";
					case 'E':
						return "\u011a";
					case 'e':
						return "\u011b";
					case 'L':
						return "\u013d";
					case 'l':
						return "\u013e";
					case 'N':
						return "\u0147";
					case 'n':
						return "\u0148";
					case 'R':
						return "\u0158";
					case 'r':
						return "\u0159";
					case 'S':
						return "\u0160";
					case 's':
						return "\u0161";
					case 'T':
						return "\u0164";
					case 't':
						return "\u0165";
					case 'Z':
						return "\u017d";
					case 'z':
						return "\u017e";
					case '\u02a3': // Latin letter dz (small, digraph)
						return "\u01c6";
					case 'A':
						return "\u01cd";
					case 'a':
						return "\u01ce";
					case 'I':
						return "\u01cf";
					case 'i':
						return "\u01d0";
					case 'O':
						return "\u01d1";
					case 'o':
						return "\u01d2";
					case 'U':
						return "\u01d3";
					case 'u':
						return "\u01d4";
					case 'G':
						return "\u01e6";
					case 'g':
						return "\u01e7";
					case 'K':
						return "\u01e8";
					case 'k':
						return "\u01e9";
					case '\u01b7': // Ezh (capital)
						return "\u01ee";
					case '\u0292': // Ezh (small)
						return "\u01ef";
					case 'j':
						return "\u01f0";
					case ' ':
						return "\u02c7";
					default:
						break;
				}
				break;
			case '\u031b': // horn
				switch(chr[0]) {
					case 'O':
						return "\u01a0";
					case 'o':
						return "\u01a1";
					case 'U':
						return "\u01af";
					case 'u':
						return "\u01b0";
					default:
						break;
				}
				break;
			case '\u0326': // comma below
				switch(chr[0]) {
					case 'S':
						return "\u0218";
					case 's':
						return "\u0219";
					case 'T':
						return "\u021a";
					case 't':
						return "\u021b";
					case ' ':
						return ",";
					default:
						break;
				}
				break;
			case '\u0327': // cedilla
				switch(chr[0]) {
					case 'C':
						return "\u00c7";
					case 'c':
						return "\u00e7";
					case 'G':
						return "\u0122";
					case 'g':
						return "\u0123";
					case 'K':
						return "\u0136";
					case 'k':
						return "\u0137";
					case 'L':
						return "\u013b";
					case 'l':
						return "\u013c";
					case 'N':
						return "\u0145";
					case 'n':
						return "\u0146";
					case 'R':
						return "\u0156";
					case 'r':
						return "\u0157";
					case 'S':
						return "\u015e";
					case 's':
						return "\u015f";
					case 'T':
						return "\u0162";
					case 't':
						return "\u0163";
					case ' ':
						return "\u00b8";
					default:
						break;
				}
				break;
			case '\u0328': // ogonek
				switch(chr[0]) {
					case 'A':
						return "\u0104";
					case 'a':
						return "\u0105";
					case 'E':
						return "\u0118";
					case 'e':
						return "\u0119";
					case 'I':
						return "\u012e";
					case 'i':
						return "\u012f";
					case 'U':
						return "\u0172";
					case 'u':
						return "\u0173";
					case 'O':
						return "\u01ea";
					case 'o':
						return "\u01eb";
					case ' ':
						return "\u02db";
					default:
						break;
				}
				break;
			case '\u05bc': // hebrew point dagesh or mapiq
				switch(chr[0]) {
					case '\u05d1':
						return "\ufb31";
					case '\u05db':
						return "\ufb3b";
					case '\u05da':
						return "\ufb3a";
					case '\u05e4':
						return "\ufb44";
					case '\u05e3':
						return "\ufb43";
					case '\u05e9':
						return "\ufb49";
					default:
						break;
				}
				break;
			case '\u05bf': // hebrew point rafe
				switch(chr[0]) {
					case '\u05d1':
						return "\ufb4c";
					case '\u05db':
						return "\ufb4d";
					case '\u05e4':
						return "\ufb4e";
					default:
						break;
				}
				break;
			case '\u05c1': // hebrew point shin dot
				switch(chr[0]) {
					case '\u05e9':
						return "\ufb2a";
					default:
						break;
				}
				break;
			case '\u05c2': // hebrew point sin dot
				switch(chr[0]) {
					case '\u05e9':
						return "\ufb2b";
					default:
						break;
				}
				break;
			case '\u0654': // arabic hamza above
				switch(chr[0]) {
					case '\u0627':
						return "\u0623";
					case '\u06c1':
						return "\u06c2";
					case '\u0648':
						return "\u0624";
					case '\u064a':
						return "\u0626";
					case '\u06d2':
						return "\u06d3";
					default:
						break;
				}
				break;
			default:
				break;
		}

		// Default case is to just concatenate the combining mark
		return chr[0] ~ [combiningMark] ~ chr[1..$];
	}
}