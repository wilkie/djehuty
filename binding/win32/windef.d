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

version(X86_64) {
	typedef	ulong DWORD;
}
else {
	typedef	uint DWORD;
}

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
typedef void		VOID;
typedef void*		LPVOID;
typedef void*		LPCVOID;
typedef int			INT;
typedef uint		UINT;
typedef uint*		PUINT;

typedef Culong_t*	ULONG_PTR;
typedef Clong_t*	LONG_PTR;
typedef UINT*		UINT_PTR;

/* Types use for passing & returning polymorphic values */
typedef UINT_PTR	WPARAM;
typedef LONG_PTR	LPARAM;
typedef LONG_PTR	LRESULT;

WORD MAKEWORD(WORD a, WORD b) {
	return (cast(WORD)((cast(BYTE)(cast(DWORD_PTR)(a) & 0xff)) | (cast(WORD)(cast(BYTE)(cast(DWORD_PTR)(b) & 0xff))) << 8));
}

LONG MAKELONG(LONG a, LONG b) {
	return (cast(LONG)((cast(WORD)(cast(DWORD_PTR)(a) & 0xffff)) | (cast(DWORD)(cast(WORD)(cast(DWORD_PTR)(b) & 0xffff))) << 16));
}

WORD LOWORD(LONG l) {
	return (cast(WORD)(cast(DWORD_PTR)(l) & 0xffff));
}

WORD HIWORD(LONG l) {
	return (cast(WORD)(cast(DWORD_PTR)(l) >> 16));
}

BYTE LOBYTE(WORD w) {
	return (cast(BYTE)(cast(DWORD_PTR)(w) & 0xff));
}

BYTE HIBYTE(WORD w) {
	return (cast(BYTE)(cast(DWORD_PTR)(w) >> 8));
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

typedef void* HGDIOBJ;

typedef HANDLE HKEY;
typedef HKEY* PHKEY;

typedef HANDLE (HACCEL);

typedef HANDLE (HBITMAP);
typedef HANDLE (HBRUSH);

typedef HANDLE (HCOLORSPACE);

typedef HANDLE (HDC);

typedef HANDLE (HGLRC);          // OpenGL
typedef HANDLE (HDESK);
typedef HANDLE (HENHMETAFILE);

typedef HANDLE (HFONT);

typedef HANDLE (HICON);

typedef HANDLE (HMENU);

typedef HANDLE (HMETAFILE);
typedef HANDLE (HINSTANCE);
typedef HINSTANCE HMODULE;      /* HMODULEs can be used in place of HINSTANCEs */

typedef HANDLE (HPALETTE);
typedef HANDLE (HPEN);

typedef HANDLE (HRGN);
typedef HANDLE (HRSRC);
typedef HANDLE (HSPRITE);
typedef HANDLE (HSTR);
typedef HANDLE (HTASK);
typedef HANDLE (HWINSTA);
typedef HANDLE (HKL);

typedef HANDLE (HWND);

typedef HANDLE HWINEVENTHOOK;

typedef HANDLE HMONITOR;

typedef int HFILE;
typedef HICON HCURSOR;      /* HICONs & HCURSORs are polymorphic */

typedef DWORD   COLORREF;
typedef DWORD   *LPCOLORREF;

const auto HFILE_ERROR = (cast(HFILE)-1);

struct RECT {
    LONG    left;
    LONG    top;
    LONG    right;
    LONG    bottom;
}

typedef RECT* PRECT;
typedef RECT* NPRECT;
typedef RECT* LPRECT;

typedef RECT* LPCRECT;

struct RECTL {       /* rcl */
    LONG    left;
    LONG    top;
    LONG    right;
    LONG    bottom;
}

typedef RECTL* PRECTL;
typedef RECTL* LPRECTL;

typedef RECTL* LPCRECTL;

struct POINT {
    LONG  x;
    LONG  y;
}

typedef POINT* PPOINT;
typedef POINT* NPPOINT;
typedef POINT* LPPOINT;

struct POINTL {    /* ptl  */
    LONG  x;
    LONG  y;
}

typedef POINTL* PPOINTL;
typedef POINTL* LPPOINTL;

struct SIZE {
    LONG        cx;
    LONG        cy;
}

typedef SIZE* PSIZE;
typedef SIZE* LPSIZE;

typedef SIZE SIZEL;
typedef SIZE* PSIZEL;
typedef SIZE* LPSIZEL;

struct POINTS {
    SHORT   y;
    SHORT   x;
}

typedef POINTS* PPOINTS;
typedef POINTS* LPPOINTS;

//
//  File System time stamps are represented with the following structure:
//

struct FILETIME {
    DWORD dwLowDateTime;
    DWORD dwHighDateTime;
}

typedef FILETIME* PFILETIME;
typedef FILETIME* LPFILETIME;

/* mode selections for the device mode function */
const auto DM_UPDATE           = 1;
const auto DM_COPY             = 2;
const auto DM_PROMPT           = 4;
const auto DM_MODIFY           = 8;

const auto DM_IN_BUFFER        = DM_MODIFY;
const auto DM_IN_PROMPT        = DM_PROMPT;
const auto DM_OUT_BUFFER       = DM_COPY;
const auto DM_OUT_DEFAULT      = DM_UPDATE;

/* device capabilities indices */
const auto DC_FIELDS           = 1;
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
const auto DC_COPIES           = 18;
