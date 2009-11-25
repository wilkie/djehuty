/*
 * winnt.d
 *
 * This module is a port of winnt.h to D.
 * The original copyright notice appears after this information block.
 *
 * Author: Dave Wilkinson
 * Originated: July 7th, 2009
 *
 */

/*++ BUILD Version: 0066     Increment this if a change has global effects

Copyright (c) Microsoft Corporation. All rights reserved.

Module Name:

    winnt.h

Abstract:

    This module defines the 32-Bit Windows types and constants that are
    defined by NT, but exposed through the Win32 API.

Revision History:

--*/

module binding.win32.winnt;

import binding.c;

import binding.win32.windef;

version (X86_64) {
	const auto MEMORY_ALLOCATION_ALIGNMENT = 16;
	const auto MAX_NATURAL_ALIGNMENT = ulong.sizeof;
}
else {
	const auto MEMORY_ALLOCATION_ALIGNMENT = 8;
	const auto MAX_NATURAL_ALIGNMENT = DWORD.sizeof;
}

//
// Void
//

typedef void*	PVOID;
typedef void*	PVOID64;

typedef char	CHAR;
typedef short	SHORT;
typedef Clong_t	LONG;


//
// UNICODE (Wide Character) types
//

typedef ushort WCHAR;    // wc,   16-bit UNICODE character

typedef WCHAR *PWCHAR;

typedef WCHAR *LPWCH;
typedef WCHAR *PWCH;

typedef WCHAR *LPCWCH;
typedef WCHAR *PCWCH;

typedef WCHAR *NWPSTR;
typedef WCHAR *LPWSTR;
typedef WCHAR *PWSTR;

typedef PWSTR *PZPWSTR;
typedef PWSTR *PCZPWSTR;
typedef WCHAR *LPUWSTR;
typedef WCHAR *PUWSTR;
typedef WCHAR *LPCWSTR;
typedef WCHAR *PCWSTR;
typedef PCWSTR *PZPCWSTR;
typedef WCHAR *LPCUWSTR;
typedef WCHAR *PCUWSTR;

//
// ANSI (Multi-byte Character) types
//
typedef CHAR *PCHAR;
typedef CHAR *LPCH;
typedef CHAR *PCH;
typedef CHAR *LPCCH;
typedef CHAR *PCCH;

typedef CHAR *NPSTR;
typedef CHAR *LPSTR;
typedef CHAR *PSTR;
typedef PSTR *PZPSTR;
typedef PSTR *PCZPSTR;
typedef CHAR *LPCSTR; 
typedef CHAR *PCSTR;
typedef PCSTR *PZPCSTR;

//
// Neutral ANSI/UNICODE types and macros
//

version(UNICODE) {
	typedef WCHAR TCHAR;
	typedef WCHAR *PTCHAR;
	typedef WCHAR TBYTE;
	typedef WCHAR *PTBYTE ;

	typedef LPWSTR LPTCH;
	typedef LPWSTR PTCH;
	typedef LPWSTR PTSTR;
	typedef LPWSTR LPTSTR;
	typedef LPCWSTR PCTSTR;
	typedef LPCWSTR LPCTSTR;
	typedef LPUWSTR PUTSTR;
	typedef LPUWSTR LPUTSTR;
	typedef LPCUWSTR PCUTSTR;
	typedef LPCUWSTR LPCUTSTR;
	typedef LPWSTR LP;
}
else {
	typedef char TCHAR;
	typedef char *PTCHAR;
	typedef ubyte TBYTE ;
	typedef ubyte *PTBYTE ;

	typedef LPSTR LPTCH;
	typedef LPSTR PTCH;
	typedef LPSTR PTSTR;
	typedef LPSTR LPTSTR;
	typedef LPSTR PUTSTR;
	typedef LPSTR LPUTSTR;
	typedef LPCSTR PCTSTR;
	typedef LPCSTR LPCTSTR;
	typedef LPCSTR PCUTSTR;
	typedef LPCSTR LPCUTSTR;
}

typedef SHORT*	PSHORT;
typedef LONG*	PLONG;

typedef PVOID HANDLE;

typedef HANDLE *PHANDLE;

//
// Flag (bit) fields
//

typedef BYTE	FCHAR;
typedef WORD	FSHORT;
typedef DWORD	FLONG;

// Component Object Model defines, and macros

typedef LONG	HRESULT;

typedef char	CCHAR;
typedef DWORD	LCID;
typedef PDWORD	PLCID;
typedef WORD	LANGID;

const auto APPLICATION_ERROR_MASK		= 0x20000000;
const auto ERROR_SEVERITY_SUCCESS		= 0x00000000;
const auto ERROR_SEVERITY_INFORMATIONAL	= 0x40000000;
const auto ERROR_SEVERITY_WARNING		= 0x80000000;
const auto ERROR_SEVERITY_ERROR			= 0xC0000000;

struct FLOAT128 {
    long LowPart;
    long HighPart;
}

typedef FLOAT128*	PFLOAT128;

typedef long LONGLONG;
typedef ulong ULONGLONG;

const auto MAXLONGLONG = long.max;

typedef LONGLONG*	PLONGLONG;
typedef ULONGLONG*	PULONGLONG;

// Update Sequence Number

typedef LONGLONG USN;

struct LARGE_INTEGER {
    LONGLONG QuadPart;
}

typedef LARGE_INTEGER*	PLARGE_INTEGER;

struct ULARGE_INTEGER {
	ULONGLONG QuadPart;
}

typedef ULARGE_INTEGER*	PULARGE_INTEGER;

//
// Locally Unique Identifier
//

struct LUID {
    DWORD LowPart;
    LONG HighPart;
}
typedef LUID*	PLUID;

typedef ULONGLONG	DWORDLONG;
typedef DWORDLONG*	PDWORDLONG;

const auto ANSI_NULL				= (cast(CHAR)0);
const auto UNICODE_NULL				= (cast(WCHAR)0);
const auto UNICODE_STRING_MAX_BYTES	= (cast(WORD)65534);
const auto UNICODE_STRING_MAX_CHARS = (32767);

typedef BYTE 		BOOLEAN;
typedef BOOLEAN*	PBOOLEAN;

//
//  Doubly linked list structure.  Can be used as either a list head, or
//  as link words.
//

struct LIST_ENTRY {
   LIST_ENTRY* Flink;
   LIST_ENTRY* Blink;
}

typedef LIST_ENTRY* PLIST_ENTRY;
typedef LIST_ENTRY* PRLIST_ENTRY;

//
//  Singly linked list structure. Can be used as either a list head, or
//  as link words.
//

struct SINGLE_LIST_ENTRY {
    SINGLE_LIST_ENTRY* Next;
}

typedef SINGLE_LIST_ENTRY* PSINGLE_LIST_ENTRY;

//
// These are needed for portable debugger support.
//

struct LIST_ENTRY32 {
    DWORD Flink;
    DWORD Blink;
}

typedef LIST_ENTRY32 *PLIST_ENTRY32;

struct LIST_ENTRY64 {
    ULONGLONG Flink;
    ULONGLONG Blink;
}

typedef LIST_ENTRY64 *PLIST_ENTRY64;

public import binding.win32.guiddef;

struct OBJECTID {     // size is 20
    GUID Lineage;
    DWORD Uniquifier;
}

const auto MINCHAR	= 0x80;
const auto MAXCHAR	= 0x7f;
const auto MINSHORT	= 0x8000;
const auto MAXSHORT	= 0x7fff;
const auto MINLONG	= 0x80000000;
const auto MAXLONG	= 0x7fffffff;
const auto MAXBYTE	= 0xff;
const auto MAXWORD	= 0xffff;
const auto MAXDWORD	= 0xffffffff;

const auto VER_SERVER_NT						= 0x80000000;
const auto VER_WORKSTATION_NT					= 0x40000000;
const auto VER_SUITE_SMALLBUSINESS				= 0x00000001;
const auto VER_SUITE_ENTERPRISE					= 0x00000002;
const auto VER_SUITE_BACKOFFICE					= 0x00000004;
const auto VER_SUITE_COMMUNICATIONS				= 0x00000008;
const auto VER_SUITE_TERMINAL					= 0x00000010;
const auto VER_SUITE_SMALLBUSINESS_RESTRICTED	= 0x00000020;
const auto VER_SUITE_EMBEDDEDNT 				= 0x00000040;
const auto VER_SUITE_DATACENTER					= 0x00000080;
const auto VER_SUITE_SINGLEUSERTS				= 0x00000100;
const auto VER_SUITE_PERSONAL					= 0x00000200;
const auto VER_SUITE_BLADE						= 0x00000400;
const auto VER_SUITE_EMBEDDED_RESTRICTED		= 0x00000800;
const auto VER_SUITE_SECURITY_APPLIANCE			= 0x00001000;
const auto VER_SUITE_STORAGE_SERVER				= 0x00002000;
const auto VER_SUITE_COMPUTE_SERVER				= 0x00004000;