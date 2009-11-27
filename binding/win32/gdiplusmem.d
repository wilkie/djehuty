/*
 * gdiplusmem.d
 *
 * This module binds GdiPlusMem.h to D. The original copyright
 * notice is preserved below.
 *
 * Author: Dave Wilkinson
 * Originated: November 25th, 2009
 *
 */

module binding.win32.gdiplusmem;

extern(System):

/**************************************************************************\
*
* Copyright (c) 1998-2001, Microsoft Corp.  All Rights Reserved.
*
* Module Name:
*
*   GdiplusMem.h
*
* Abstract:
*
*   GDI+ Private Memory Management APIs
*
\**************************************************************************/

void* GdipAlloc(size_t size);

void GdipFree(void* ptr);