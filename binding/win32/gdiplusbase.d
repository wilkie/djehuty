/*
 * gdiplusbase.d
 *
 * This module implements GdiPlusBase.h for D. The original copyright
 * info is given below.
 *
 * Author: Dave Wilkinson
 * Originated: November 24th, 2009
 *
 */

module binding.win32.gdiplusbase;

import binding.win32.gdiplusmem;

// The original copyright notice from GdiplusBase.h from which this module
// is based:

/**************************************************************************\
*
* Copyright (c) 1998-2001, Microsoft Corp.  All Rights Reserved.
*
* Module Name:
*
*   GdiplusBase.h
*
* Abstract:
*
*   GDI+ base memory allocation class
*
\**************************************************************************/

// These are C++ class bindings, and cannot be binded

class GdiplusBase {
    /*
    
	delete(void* in_pVoid) {
       GdipFree(in_pVoid);
    }

    new(size_t in_size) {
       return GdipAlloc(in_size);
    }
	
	*/
}