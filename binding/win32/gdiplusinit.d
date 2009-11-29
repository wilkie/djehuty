/*
 * gdiplusinit.d
 *
 * This module binds GdiPlusInit.h to D. The original copyright
 * notice is preserved below.
 *
 * Author: Dave Wilkinson
 * Originated: November 25th, 2009
 *
 */

module binding.win32.gdiplusinit;

import binding.win32.windef;
import binding.win32.winbase;
import binding.win32.winnt;

import binding.win32.gdiplustypes;

extern(System):

/**************************************************************************
*
* Copyright (c) 2000-2003 Microsoft Corporation
*
* Module Name:
*
*   Gdiplus initialization
*
* Abstract:
*
*   GDI+ Startup and Shutdown APIs
*
**************************************************************************/

enum DebugEventLevel {
    DebugEventLevelFatal,
    DebugEventLevelWarning
}

// Callback function that GDI+ can call, on debug builds, for assertions
// and warnings.

alias VOID function(DebugEventLevel level, CHAR* message) DebugEventProc;

// Notification functions which the user must call appropriately if
// "SuppressBackgroundThread" (below) is set.

alias Status function(ULONG_PTR* token) NotificationHookProc;
alias VOID function(ULONG_PTR token) NotificationUnhookProc;

// Input structure for GdiplusStartup()

struct GdiplusStartupInput {
    UINT32 GdiplusVersion = 1;             // Must be 1  (or 2 for the Ex version)
    DebugEventProc DebugEventCallback = null; // Ignored on free builds
    BOOL SuppressBackgroundThread = FALSE;     // FALSE unless you're prepared to call
                                       // the hook/unhook functions properly
    BOOL SuppressExternalCodecs = FALSE;       // FALSE unless you want GDI+ only to use
                                       // its internal image codecs.

    GdiplusStartupInput init(
	  DebugEventProc debugEventCallback = null,
      BOOL suppressBackgroundThread = FALSE,
      BOOL suppressExternalCodecs = FALSE) {

		GdiplusStartupInput ret;
        ret.GdiplusVersion = 1;
        ret.DebugEventCallback = debugEventCallback;
        ret.SuppressBackgroundThread = suppressBackgroundThread;
        ret.SuppressExternalCodecs = suppressExternalCodecs;
        return ret;
    }
}

struct GdiplusStartupInputEx {
    UINT32 GdiplusVersion = 2;             // Must be 1  (or 2 for the Ex version)
    DebugEventProc DebugEventCallback = null; // Ignored on free builds
    BOOL SuppressBackgroundThread = FALSE;     // FALSE unless you're prepared to call
                                       // the hook/unhook functions properly
    BOOL SuppressExternalCodecs = FALSE;       // FALSE unless you want GDI+ only to use
                                       // its internal image codecs.
    INT StartupParameters = 0;  // Do we not set the FPU rounding mode

    GdiplusStartupInputEx init(
      INT startupParameters = 0,
      DebugEventProc debugEventCallback = null,
      BOOL suppressBackgroundThread = FALSE,
      BOOL suppressExternalCodecs = FALSE) {

		GdiplusStartupInputEx ret;
        ret.GdiplusVersion = 2;
        ret.DebugEventCallback = debugEventCallback;
        ret.SuppressBackgroundThread = suppressBackgroundThread;
        ret.SuppressExternalCodecs = suppressExternalCodecs;
        ret.StartupParameters = startupParameters;
        return ret;
    }
}

enum GdiplusStartupParams {
    GdiplusStartupDefault = 0,
    GdiplusStartupNoSetRound = 1,
    GdiplusStartupSetPSValue = 2,
    GdiplusStartupTransparencyMask = 0xFF000000
}

// Output structure for GdiplusStartup()

struct GdiplusStartupOutput {
    // The following 2 fields are NULL if SuppressBackgroundThread is FALSE.
    // Otherwise, they are functions which must be called appropriately to
    // replace the background thread.
    //
    // These should be called on the application's main message loop - i.e.
    // a message loop which is active for the lifetime of GDI+.
    // "NotificationHook" should be called before starting the loop,
    // and "NotificationUnhook" should be called after the loop ends.

    NotificationHookProc NotificationHook;
    NotificationUnhookProc NotificationUnhook;
}

// GDI+ initialization. Must not be called from DllMain - can cause deadlock.
//
// Must be called before GDI+ API's or constructors are used.
//
// token  - may not be NULL - accepts a token to be passed in the corresponding
//          GdiplusShutdown call.
// input  - may not be NULL
// output - may be NULL only if input->SuppressBackgroundThread is FALSE.

Status GdiplusStartup(
    ULONG_PTR *token,
    GdiplusStartupInput *input,
    GdiplusStartupOutput *output);

// GDI+ termination. Must be called before GDI+ is unloaded.
// Must not be called from DllMain - can cause deadlock.
//
// GDI+ API's may not be called after GdiplusShutdown. Pay careful attention
// to GDI+ object destructors.

VOID GdiplusShutdown(ULONG_PTR token);
