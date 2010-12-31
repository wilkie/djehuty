/*
 * dwmapi.d
 *
 * This module binds dwmapi.h to D. The original copyright
 * notice is preserved below.
 *
 */

module binding.win32.dwmapi;

import binding.win32.windef;
import binding.win32.winnt;
import binding.win32.wingdi;

import binding.win32.uxtheme;

extern(System):

// Blur behind data structures
static const auto DWM_BB_ENABLE                 = 0x00000001;  // fEnable has been specified
static const auto DWM_BB_BLURREGION             = 0x00000002;  // hRgnBlur has been specified
static const auto DWM_BB_TRANSITIONONMAXIMIZED  = 0x00000004;  // fTransitionOnMaximized has been specified

align(1) struct DWM_BLURBEHIND {
	DWORD dwFlags;
	BOOL fEnable;
	HRGN hRgnBlur;
	BOOL fTransitionOnMaximized;
}

alias DWM_BLURBEHIND* PDWM_BLURBEHIND;

enum DWMWINDOWATTRIBUTE {
    DWMWA_NCRENDERING_ENABLED = 1,      // [get] Is non-client rendering enabled/disabled
    DWMWA_NCRENDERING_POLICY,           // [set] Non-client rendering policy
    DWMWA_TRANSITIONS_FORCEDISABLED,    // [set] Potentially enable/forcibly disable transitions
    DWMWA_ALLOW_NCPAINT,                // [set] Allow contents rendered in the non-client area to be visible on the DWM-drawn frame.
    DWMWA_CAPTION_BUTTON_BOUNDS,        // [get] Bounds of the caption button area in window-relative space.
    DWMWA_NONCLIENT_RTL_LAYOUT,         // [set] Is non-client content RTL mirrored
    DWMWA_FORCE_ICONIC_REPRESENTATION,  // [set] Force this window to display iconic thumbnails.
    DWMWA_FLIP3D_POLICY,                // [set] Designates how Flip3D will treat the window.
    DWMWA_EXTENDED_FRAME_BOUNDS,        // [get] Gets the extended frame bounds rectangle in screen space
    DWMWA_HAS_ICONIC_BITMAP,            // [set] Indicates an available bitmap when there is no better thumbnail representation.
    DWMWA_DISALLOW_PEEK,                // [set] Don't invoke Peek on the window.
    DWMWA_EXCLUDED_FROM_PEEK,           // [set] LivePreview exclusion information
    DWMWA_LAST
}

// Non-client rendering policy attribute values
enum DWMNCRENDERINGPOLICY {
    DWMNCRP_USEWINDOWSTYLE, // Enable/disable non-client rendering based on window style
    DWMNCRP_DISABLED,       // Disabled non-client rendering; window style is ignored
    DWMNCRP_ENABLED,        // Enabled non-client rendering; window style is ignored
    DWMNCRP_LAST
}

// Values designating how Flip3D treats a given window.
enum DWMFLIP3DWINDOWPOLICY {
    DWMFLIP3D_DEFAULT,      // Hide or include the window in Flip3D based on window style and visibility.
    DWMFLIP3D_EXCLUDEBELOW, // Display the window under Flip3D and disabled.
    DWMFLIP3D_EXCLUDEABOVE, // Display the window above Flip3D and enabled.
    DWMFLIP3D_LAST
}

// Thumbnails
alias HANDLE HTHUMBNAIL;
alias HTHUMBNAIL* PHTHUMBNAIL;

static const auto DWM_TNP_RECTDESTINATION      = 0x00000001;
static const auto DWM_TNP_RECTSOURCE           = 0x00000002;
static const auto DWM_TNP_OPACITY              = 0x00000004;
static const auto DWM_TNP_VISIBLE              = 0x00000008;
static const auto DWM_TNP_SOURCECLIENTAREAONLY = 0x00000010;

align(1) struct DWM_THUMBNAIL_PROPERTIES {
    DWORD dwFlags;
    RECT rcDestination;
    RECT rcSource;
    BYTE opacity;
    BOOL fVisible;
    BOOL fSourceClientAreaOnly;
}

alias DWM_THUMBNAIL_PROPERTIES* PDWM_THUMBNAIL_PROPERTIES;

// Video enabling apis

alias ULONGLONG DWM_FRAME_COUNT;
alias ULONGLONG QPC_TIME;

align(1) struct UNSIGNED_RATIO {
    UINT32 uiNumerator;
    UINT32 uiDenominator;
}

align(1) struct DWM_TIMING_INFO {
    UINT32          cbSize;

    // Data on DWM composition overall
    
    // Monitor refresh rate
    UNSIGNED_RATIO  rateRefresh;

    // Actual period
    QPC_TIME        qpcRefreshPeriod;

    // composition rate     
    UNSIGNED_RATIO  rateCompose;

    // QPC time at a VSync interupt
    QPC_TIME        qpcVBlank;

    // DWM refresh count of the last vsync
    // DWM refresh count is a 64bit number where zero is
    // the first refresh the DWM woke up to process
    DWM_FRAME_COUNT cRefresh;

    // DX refresh count at the last Vsync Interupt
    // DX refresh count is a 32bit number with zero 
    // being the first refresh after the card was initialized
    // DX increments a counter when ever a VSync ISR is processed
    // It is possible for DX to miss VSyncs
    //
    // There is not a fixed mapping between DX and DWM refresh counts
    // because the DX will rollover and may miss VSync interupts
    UINT cDXRefresh;

    // QPC time at a compose time.  
    QPC_TIME        qpcCompose;

    // Frame number that was composed at qpcCompose
    DWM_FRAME_COUNT cFrame;

    // The present number DX uses to identify renderer frames
    UINT            cDXPresent;

    // Refresh count of the frame that was composed at qpcCompose
    DWM_FRAME_COUNT cRefreshFrame;


    // DWM frame number that was last submitted
    DWM_FRAME_COUNT cFrameSubmitted;

    // DX Present number that was last submitted
    UINT cDXPresentSubmitted;

    // DWM frame number that was last confirmed presented
    DWM_FRAME_COUNT cFrameConfirmed;

    // DX Present number that was last confirmed presented
    UINT cDXPresentConfirmed;

    // The target refresh count of the last
    // frame confirmed completed by the GPU
    DWM_FRAME_COUNT cRefreshConfirmed;

    // DX refresh count when the frame was confirmed presented
    UINT cDXRefreshConfirmed;

    // Number of frames the DWM presented late
    // AKA Glitches
    DWM_FRAME_COUNT          cFramesLate;
    
    // the number of composition frames that 
    // have been issued but not confirmed completed
    UINT          cFramesOutstanding;


    // Following fields are only relavent when an HWND is specified
    // Display frame


    // Last frame displayed
    DWM_FRAME_COUNT cFrameDisplayed;

    // QPC time of the composition pass when the frame was displayed
    QPC_TIME        qpcFrameDisplayed; 

    // Count of the VSync when the frame should have become visible
    DWM_FRAME_COUNT cRefreshFrameDisplayed;

    // Complete frames: DX has notified the DWM that the frame is done rendering

    // ID of the the last frame marked complete (starts at 0)
    DWM_FRAME_COUNT cFrameComplete;

    // QPC time when the last frame was marked complete
    QPC_TIME        qpcFrameComplete;

    // Pending frames:
    // The application has been submitted to DX but not completed by the GPU
 
    // ID of the the last frame marked pending (starts at 0)
    DWM_FRAME_COUNT cFramePending;

    // QPC time when the last frame was marked pending
    QPC_TIME        qpcFramePending;

    // number of unique frames displayed
    DWM_FRAME_COUNT cFramesDisplayed;

    // number of new completed frames that have been received
    DWM_FRAME_COUNT cFramesComplete;

     // number of new frames submitted to DX but not yet complete
    DWM_FRAME_COUNT cFramesPending;

    // number of frames available but not displayed, used or dropped
    DWM_FRAME_COUNT cFramesAvailable;

    // number of rendered frames that were never
    // displayed because composition occured too late
    DWM_FRAME_COUNT cFramesDropped;
    
    // number of times an old frame was composed 
    // when a new frame should have been used
    // but was not available
    DWM_FRAME_COUNT cFramesMissed;
    
    // the refresh at which the next frame is
    // scheduled to be displayed
    DWM_FRAME_COUNT cRefreshNextDisplayed;

    // the refresh at which the next DX present is 
    // scheduled to be displayed
    DWM_FRAME_COUNT cRefreshNextPresented;

    // The total number of refreshes worth of content
    // for this HWND that have been displayed by the DWM
    // since DwmSetPresentParameters was called
    DWM_FRAME_COUNT cRefreshesDisplayed;
	
    // The total number of refreshes worth of content
    // that have been presented by the application
    // since DwmSetPresentParameters was called
    DWM_FRAME_COUNT cRefreshesPresented;


    // The actual refresh # when content for this
    // window started to be displayed
    // it may be different than that requested
    // DwmSetPresentParameters
    DWM_FRAME_COUNT cRefreshStarted;

    // Total number of pixels DX redirected
    // to the DWM.
    // If Queueing is used the full buffer
    // is transfered on each present.
    // If not queuing it is possible only 
    // a dirty region is updated
    ULONGLONG  cPixelsReceived;

    // Total number of pixels drawn.
    // Does not take into account if
    // if the window is only partial drawn
    // do to clipping or dirty rect management 
    ULONGLONG  cPixelsDrawn;

    // The number of buffers in the flipchain
    // that are empty.   An application can 
    // present that number of times and guarantee 
    // it won't be blocked waiting for a buffer to 
    // become empty to present to
    DWM_FRAME_COUNT      cBuffersEmpty;

}

enum DWM_SOURCE_FRAME_SAMPLING {
    // Use the first source frame that 
    // includes the first refresh of the output frame
    DWM_SOURCE_FRAME_SAMPLING_POINT,

    // use the source frame that includes the most 
    // refreshes of out the output frame
    // in case of multiple source frames with the 
    // same coverage the last will be used
    DWM_SOURCE_FRAME_SAMPLING_COVERAGE,

       // Sentinel value
    DWM_SOURCE_FRAME_SAMPLING_LAST
} 

static const UINT c_DwmMaxQueuedBuffers = 8;
static const UINT c_DwmMaxMonitors = 16;
static const UINT c_DwmMaxAdapters = 16;

align(1) struct DWM_PRESENT_PARAMETERS {
    UINT32          cbSize;
    BOOL            fQueue;
    DWM_FRAME_COUNT cRefreshStart;
    UINT            cBuffer;
    BOOL            fUseSourceRate;
    UNSIGNED_RATIO  rateSource;
    UINT            cRefreshesPerFrame;
    DWM_SOURCE_FRAME_SAMPLING  eSampling;
} 

static const auto DWM_FRAME_DURATION_DEFAULT = -1;

BOOL DwmDefWindowProc(HWND hWnd, UINT msg, WPARAM wParam, LPARAM lParam, LRESULT *plResult);

void DwmEnableBlurBehindWindow(HWND hWnd, DWM_BLURBEHIND* pBlurBehind);

static const auto DWM_EC_DISABLECOMPOSITION         = 0;
static const auto DWM_EC_ENABLECOMPOSITION          = 1;


void DwmEnableComposition(UINT uCompositionAction);

void DwmEnableMMCSS(BOOL fEnableMMCSS);

void DwmExtendFrameIntoClientArea(HWND hWnd, MARGINS* pMarInset);
    
void DwmGetColorizationColor(DWORD* pcrColorization, BOOL* pfOpaqueBlend);

void DwmGetCompositionTimingInfo(HWND hwnd, DWM_TIMING_INFO* pTimingInfo);

void DwmGetWindowAttribute(HWND hwnd, DWORD dwAttribute, PVOID pvAttribute, DWORD cbAttribute);

void DwmIsCompositionEnabled(BOOL* pfEnabled);

void DwmModifyPreviousDxFrameDuration(HWND hwnd, INT cRefreshes, BOOL fRelative);

void DwmQueryThumbnailSourceSize(HTHUMBNAIL hThumbnail, PSIZE pSize);

void DwmRegisterThumbnail(HWND hwndDestination, HWND hwndSource, PHTHUMBNAIL phThumbnailId);

void DwmSetDxFrameDuration(HWND hwnd, INT cRefreshes);

void DwmSetPresentParameters(HWND hwnd, DWM_PRESENT_PARAMETERS* pPresentParams);

void DwmSetWindowAttribute(HWND hwnd, DWORD dwAttribute, LPCVOID pvAttribute, DWORD cbAttribute);

void DwmUnregisterThumbnail(HTHUMBNAIL hThumbnailId);

void DwmUpdateThumbnailProperties(HTHUMBNAIL hThumbnailId, DWM_THUMBNAIL_PROPERTIES* ptnProperties);

static const auto DWM_SIT_DISPLAYFRAME    = 0x00000001;  // Display a window frame around the provided bitmap

void DwmSetIconicThumbnail(HWND hwnd,HBITMAP hbmp, DWORD dwSITFlags);

void DwmSetIconicLivePreviewBitmap(HWND hwnd, HBITMAP hbmp, POINT *pptClient, DWORD dwSITFlags);

void DwmInvalidateIconicBitmaps(HWND hwnd);

void DwmAttachMilContent(HWND hwnd);

void DwmDetachMilContent(HWND hwnd);

void DwmFlush();

/*
align(1) struct MilMatrix3x2D {
    DOUBLE S_11;
    DOUBLE S_12;
    DOUBLE S_21;
    DOUBLE S_22;
    DOUBLE DX;
    DOUBLE DY;
}

// Compatibility for Vista dwm api.
alias MilMatrix3x2D MIL_MATRIX3X2D;

void DwmGetGraphicsStreamTransformHint(UINT uIndex, MilMatrix3x2D *pTransform);

void DwmGetGraphicsStreamClient(UINT uIndex, UUID *pClientUuid);

void DwmGetTransportAttributes(BOOL *pfIsRemoting, BOOL *pfIsConnected, DWORD *pDwGeneration);
*/
