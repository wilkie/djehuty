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

import binding.win32.winnt;

import binding.c;

extern(System):

alias Culong_t	ULONG;
alias ULONG*		PULONG;
alias ushort		USHORT;
alias USHORT*		PUSHORT;
alias ubyte		UCHAR;
alias UCHAR*		PUCHAR;
alias char*		PSZ;

alias size_t		SIZE_T;
alias size_t*		PSIZE_T;

alias ULONG	PROPID;

const auto MAX_PATH = 260;

enum : uint {
	FALSE = 0,
	TRUE = 1
}

version(X86_64) {
	alias	ulong DWORD;
}
else {
	alias	uint DWORD;
}

alias ulong DWORD64;

alias int			BOOL;
alias ubyte		BYTE;
alias ushort		WORD;
alias float		FLOAT;
alias FLOAT*		PFLOAT;
alias BOOL*		PBOOL;
alias BOOL*		LPBOOL;
alias BYTE*		PBYTE;
alias BYTE*		LPBYTE;
alias int*		PINT;
alias int*		LPINT;
alias WORD*		PWORD;
alias WORD*		LPWORD;
alias Clong_t*	LPLONG;
alias DWORD*		PDWORD;
alias DWORD*		LPDWORD;
alias void		VOID;
alias void*		LPVOID;
alias void*		LPCVOID;
alias int			INT;
alias uint		UINT;
alias uint*		PUINT;

alias long		LONG64;
alias long*		PLONG64;
alias ulong		ULONG64;
alias ulong*		PULONG64;

alias Culong_t	ULONG_PTR;
alias Culong_t**	PULONG_PTR;
alias Clong_t	LONG_PTR;
alias Clong_t**	PLONG_PTR;
alias LONG_PTR	INT_PTR;
alias ULONG_PTR UINT_PTR;
alias UINT**		PUINT_PTR;
alias Culong_t** PDWORD_PTR;
alias ULONG_PTR	DWORD_PTR;

alias ubyte	UINT8;
alias ushort UINT16;
alias uint	UINT32;
alias ulong	UINT64;

alias byte	INT8;
alias short INT16;
alias int	INT32;
alias long	INT64;

alias ulong	QWORD;

alias long*		LONGLONG_PTR;
alias ulong*		ULONGLONG_PTR;

/* Types use for passing & returning polymorphic values */
alias UINT_PTR	WPARAM;
alias LONG_PTR	LPARAM;
alias LONG_PTR	LRESULT;

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

alias WORD	ATOM;

alias HANDLE*	SPHANDLE;
alias HANDLE*	LPHANDLE;
alias HANDLE	HGLOBAL;
alias HANDLE	HLOCAL;
alias HANDLE	GLOBALHANDLE;
alias HANDLE	LOCALHANDLE;

version(X86_64) {
	alias INT_PTR function() FARPROC;
	alias INT_PTR function() NEARPROC;
	alias INT_PTR function() PROC;
}
else {
	alias int function() FARPROC;
	alias int function() NEARPROC;
	alias int function() PROC;
}

alias void* HGDIOBJ;

alias HANDLE HKEY;
alias HKEY* PHKEY;

alias HANDLE (HACCEL);

alias HANDLE (HBITMAP);
alias HANDLE (HBRUSH);

alias HANDLE (HCOLORSPACE);

alias HANDLE (HDC);

alias HANDLE (HGLRC);          // OpenGL
alias HANDLE (HDESK);
alias HANDLE (HENHMETAFILE);

alias HANDLE (HFONT);

alias HANDLE (HICON);

alias HANDLE (HMENU);

alias HANDLE (HHOOK);

alias HANDLE (HMETAFILE);
alias HANDLE (HINSTANCE);
alias HINSTANCE HMODULE;      /* HMODULEs can be used in place of HINSTANCEs */

alias HANDLE (HPALETTE);
alias HANDLE (HPEN);

alias HANDLE (HRGN);
alias HANDLE (HRSRC);
alias HANDLE (HSPRITE);
alias HANDLE (HSTR);
alias HANDLE (HTASK);
alias HANDLE (HWINSTA);
alias HANDLE (HKL);

alias HANDLE (HWND);

alias HANDLE HWINEVENTHOOK;

alias HANDLE HMONITOR;

alias int HFILE;
alias HICON HCURSOR;      /* HICONs & HCURSORs are polymorphic */

alias DWORD   COLORREF;
alias DWORD   *LPCOLORREF;

const auto HFILE_ERROR = (cast(HFILE)-1);

struct RECT {
    LONG    left;
    LONG    top;
    LONG    right;
    LONG    bottom;
}

alias RECT* PRECT;
alias RECT* NPRECT;
alias RECT* LPRECT;

alias RECT* LPCRECT;

struct RECTL {       /* rcl */
    LONG    left;
    LONG    top;
    LONG    right;
    LONG    bottom;
}

alias RECTL* PRECTL;
alias RECTL* LPRECTL;

alias RECTL* LPCRECTL;

struct POINT {
    LONG  x;
    LONG  y;
}

alias POINT* PPOINT;
alias POINT* NPPOINT;
alias POINT* LPPOINT;

struct POINTL {    /* ptl  */
    LONG  x;
    LONG  y;
}

alias POINTL* PPOINTL;
alias POINTL* LPPOINTL;

struct SIZE {
    LONG        cx;
    LONG        cy;
}

alias SIZE* PSIZE;
alias SIZE* LPSIZE;

alias SIZE SIZEL;
alias SIZE* PSIZEL;
alias SIZE* LPSIZEL;

struct POINTS {
    SHORT   y;
    SHORT   x;
}

alias POINTS* PPOINTS;
alias POINTS* LPPOINTS;

//
//  File System time stamps are represented with the following structure:
//

struct FILETIME {
    DWORD dwLowDateTime;
    DWORD dwHighDateTime;
}

alias FILETIME* PFILETIME;
alias FILETIME* LPFILETIME;

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
