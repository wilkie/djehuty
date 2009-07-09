/*
 * windef.d
 *
 * This module is a port of windef.h to D.
 * The original copyright notice appears after this information block.
 *
 * Author: Dave Wilkinson
 * Originated: July 7th, 2009
 *
 */

/****************************************************************************
*                                                                           *
* windef.h -- Basic Windows Type Definitions                                *
*                                                                           *
* Copyright (c) Microsoft Corporation. All rights reserved.                 *
*                                                                           *
****************************************************************************/

module binding.win32.windef;

public import binding.win32.winnt;
public import binding.win32.specstrings;

import binding.c;

typedef Culong_t	ULONG;
typedef ULONG*		PULONG;
typedef ushort		USHORT;
typedef USHORT*		PUSHORT;
typedef ubyte		UCHAR;
typedef UCHAR*		PUCHAR;
typedef char*		PSZ;

const auto MAX_PATH = 260;

enum : uint {
	FALSE = 0,
	TRUE = 1
}

typedef Culong_t	DWORD;
typedef int			BOOL;
typedef ubyte		BYTE;
typedef ushort		WORD;
typedef float		FLOAT;
typedef FLOAT*		PFLOAT;
typedef BOOL*		PBOOL;
typedef BOOL*		LPBOOL;
typedef BYTE*		PBYTE;
typedef BYTE*		LPBYTE;
typedef int*		PINT;
typedef int*		LPINT;
typedef WORD*		PWORD;
typedef WORD*		LPWORD;
typedef Clong_t*	LPLONG;
typedef DWORD*		PDWORD;
typedef DWORD*		LPDWORD;
typedef void*		LPVOID;
typedef void*		LPCVOID;
typedef int			INT;
typedef uint		UINT;
typedef uint*		PUINT;

/* Types use for passing & returning polymorphic values */
typedef UINT_PTR	WPARAM;
typedef LONG_PTR	LPARAM;
typedef LONG_PTR	LRESULT;

WORD MAKEWORD(WORD a, WORD b) {
	return ((WORD)(((BYTE)((DWORD_PTR)(a) & 0xff)) | ((WORD)((BYTE)((DWORD_PTR)(b) & 0xff))) << 8));
}

LONG MAKELONG(LONG a, LONG b) {
	return ((LONG)(((WORD)((DWORD_PTR)(a) & 0xffff)) | ((DWORD)((WORD)((DWORD_PTR)(b) & 0xffff))) << 16));
}

WORD LOWORD(LONG l) {
	return ((WORD)((DWORD_PTR)(l) & 0xffff));
}

WORD HIWORD(LONG l) {
	return ((WORD)((DWORD_PTR)(l) >> 16));
}

BYTE LOBYTE(WORD w) {
	return ((BYTE)((DWORD_PTR)(w) & 0xff));
}

BYTE HIBYTE(WORD w) {
	return ((BYTE)((DWORD_PTR)(w) >> 8));
}

typedef WORD	ATOM;

typedef HANDLE*	SPHANDLE;
typedef HANDLE*	LPHANDLE;
typedef HANDLE	HGLOBAL;
typedef HANDLE	HLOCAL;
typedef HANDLE	GLOBALHANDLE;
typedef HANDLE	LOCALHANDLE;

version(X86_64) {
	typedef INT_PTR function() FARPROC;
	typedef INT_PTR function() NEARPROC;
	typedef INT_PTR function() PROC;
}
else {
	typedef int function() FARPROC;
	typedef int function() NEARPROC;
	typedef int function() PROC;
}