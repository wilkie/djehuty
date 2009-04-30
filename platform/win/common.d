
module platform.win.common;

// import the windows libraries from Phobos
public import std.c.windows.windows;
public import std.c.windows.winsock;

// extra stuff somehow left out of the Phobos libraries

const long GWL_STYLE = -16;
const long GWL_EXSTYLE = -20;
const long GWLP_HINSTANCE = (-6);
HWND CreateWindowW(LPCWSTR a,LPCWSTR b,DWORD c,int d,int e,int f,int g,HWND h,HMENU i,HINSTANCE j,LPVOID k)
{
    return CreateWindowExW(0,a,b,c,d,e,f,g,h,i,j,k);
}

const auto AC_SRC_OVER                 = 0x00;

//
// alpha format flags
//

const auto AC_SRC_ALPHA                = 0x01;

	// RAW INPUT

struct RAWINPUTDEVICELIST {
    HANDLE hDevice;
    DWORD dwType;
}

struct RAWINPUTDEVICE {
    ushort usUsagePage;
    ushort usUsage;
    DWORD dwFlags;
    HWND hwndTarget;
}

struct RAWINPUTHEADER {
    DWORD dwType;
    DWORD dwSize;
    HANDLE hDevice;
    WPARAM wParam;
}

const auto RIDI_PREPARSEDDATA = 0x20000005;
const auto RIDI_DEVICENAME = 0x20000007;     //   the   return   valus   is   the   character   length,   not   the   byte   size
const auto RIDI_DEVICEINFO = 0x2000000b;

const auto RIM_TYPEMOUSE = 0;
const auto RIM_TYPEKEYBOARD = 1;
const auto RIM_TYPEHID = 2;

const auto RIDEV_REMOVE = 0x00000001;
const auto RIDEV_EXCLUDE = 0x00000010;
const auto RIDEV_PAGEONLY = 0x00000020;
const auto RIDEV_NOLEGACY = 0x00000030;
const auto RIDEV_INPUTSINK = 0x00000100;
const auto RIDEV_CAPTUREMOUSE = 0x00000200; // effective when mouse nolegacy is specified, otherwise it would be an error
const auto RIDEV_NOHOTKEYS = 0x00000200; // effective for keyboard.
const auto RIDEV_APPKEYS = 0x00000400; // effective for keyboard.
const auto RIDEV_EXINPUTSINK = 0x00001000;
const auto RIDEV_DEVNOTIFY = 0x00002000;
const auto RIDEV_EXMODEMASK = 0x000000F0;
//const auto RIDEV_EXMODE(mode) ((mode) & RIDEV_EXMODEMASK)



const auto ERROR_MORE_DATA = 234;

	// REGISTRY

const HANDLE HKEY_CLASSES_ROOT           = cast(HANDLE)-2147483648;
const HANDLE HKEY_CURRENT_USER           = cast(HANDLE)-2147483647;
const HANDLE HKEY_LOCAL_MACHINE          = cast(HANDLE)-2147483646;
const HANDLE HKEY_USERS                  = cast(HANDLE)-2147483645;

const auto KEY_READ = 0x20019;

const auto REG_SZ = 1;

align(1) struct BLENDFUNCTION
{
    ubyte   BlendOp;
    ubyte   BlendFlags;
    ubyte   SourceConstantAlpha;
    ubyte   AlphaFormat;
}

struct WNDCLASSW {
    UINT        style;
    WNDPROC     lpfnWndProc;
    int         cbClsExtra;
    int         cbWndExtra;
    HINSTANCE   hInstance;
    HICON       hIcon;
    HCURSOR     hCursor;
    HBRUSH      hbrBackground;
    LPCWSTR      lpszMenuName;
    LPCWSTR      lpszClassName;
}

struct ADDRINFOW {
  int ai_flags;
  int ai_family;
  int ai_socktype;
  int ai_protocol;
  size_t ai_addrlen;
  LPCWSTR ai_canonname;
  sockaddr* ai_addr;
  ADDRINFOW* ai_next;
}

struct SCROLLINFO
{
    uint    cbSize;
    uint    fMask;
    int     nMin;
    int     nMax;
    uint    nPage;
    int     nPos;
    int     nTrackPos;
}

struct LARGE_INTEGER_part{
  DWORD LowPart;
  LONG HighPart;
}

union LARGE_INTEGER {

  LARGE_INTEGER_part u;

  ulong QuadPart;
}

/*
 * Track Bar Styles
 */

const auto TBS_AUTOTICKS           = 0x0001;
const auto TBS_VERT                = 0x0002;
const auto TBS_HORZ                = 0x0000;
const auto TBS_TOP                 = 0x0004;
const auto TBS_BOTTOM              = 0x0000;
const auto TBS_LEFT                = 0x0004;
const auto TBS_RIGHT               = 0x0000;
const auto TBS_BOTH                = 0x0008;
const auto TBS_NOTICKS             = 0x0010;
const auto TBS_ENABLESELRANGE      = 0x0020;
const auto TBS_FIXEDLENGTH         = 0x0040;
const auto TBS_NOTHUMB             = 0x0080;
const auto TBS_TOOLTIPS            = 0x0100;

/*
 * Scroll Bar Styles
 */

const auto SBS_HORZ                    = 0x0000;
const auto SBS_VERT                    = 0x0001;
const auto SBS_TOPALIGN                = 0x0002;
const auto SBS_LEFTALIGN               = 0x0002;
const auto SBS_BOTTOMALIGN             = 0x0004;
const auto SBS_RIGHTALIGN              = 0x0004;
const auto SBS_SIZEBOXTOPLEFTALIGN     = 0x0002;
const auto SBS_SIZEBOXBOTTOMRIGHTALIGN = 0x0004;
const auto SBS_SIZEBOX                 = 0x0008;
const auto SBS_SIZEGRIP                = 0x0010;

const auto SIF_RANGE           = 0x0001;
const auto SIF_PAGE            = 0x0002;
const auto SIF_POS             = 0x0004;
const auto SIF_DISABLENOSCROLL = 0x0008;
const auto SIF_TRACKPOS        = 0x0010;
const auto SIF_ALL             = (SIF_RANGE | SIF_PAGE | SIF_POS | SIF_TRACKPOS);

alias LARGE_INTEGER* PLARGE_INTEGER;

alias HANDLE HTHEME;

const auto DIB_RGB_COLORS = 0;

const auto STD_INPUT_HANDLE    = (cast(DWORD)-10);
const auto STD_OUTPUT_HANDLE   = (cast(DWORD)-11);
const auto STD_ERROR_HANDLE    = (cast(DWORD)-12);

const auto FOREGROUND_BLUE      = 0x0001; // text color contains blue.
const auto FOREGROUND_GREEN     = 0x0002; // text color contains green.
const auto FOREGROUND_RED       = 0x0004; // text color contains red.
const auto FOREGROUND_INTENSITY = 0x0008; // text color is intensified.
const auto BACKGROUND_BLUE      = 0x0010; // background color contains blue.
const auto BACKGROUND_GREEN     = 0x0020; // background color contains green.
const auto BACKGROUND_RED       = 0x0040; // background color contains red.
const auto BACKGROUND_INTENSITY = 0x0080; // background color is intensified.
const auto COMMON_LVB_LEADING_BYTE    = 0x0100; // Leading Byte of DBCS
const auto COMMON_LVB_TRAILING_BYTE   = 0x0200; // Trailing Byte of DBCS
const auto COMMON_LVB_GRID_HORIZONTAL = 0x0400; // DBCS: Grid attribute: top horizontal.
const auto COMMON_LVB_GRID_LVERTICAL  = 0x0800; // DBCS: Grid attribute: left vertical.
const auto COMMON_LVB_GRID_RVERTICAL  = 0x1000; // DBCS: Grid attribute: right vertical.
const auto COMMON_LVB_REVERSE_VIDEO   = 0x4000; // DBCS: Reverse fore/back ground attribute.
const auto COMMON_LVB_UNDERSCORE      = 0x8000; // DBCS: Underscore.

const auto FROM_LEFT_1ST_BUTTON_PRESSED    = 0x0001;
const auto RIGHTMOST_BUTTON_PRESSED        = 0x0002;
const auto FROM_LEFT_2ND_BUTTON_PRESSED    = 0x0004;
const auto FROM_LEFT_3RD_BUTTON_PRESSED    = 0x0008;
const auto FROM_LEFT_4TH_BUTTON_PRESSED    = 0x0010;

const auto MOUSE_MOVED   	= 0x0001;
const auto DOUBLE_CLICK  	= 0x0002;
const auto MOUSE_WHEELED 	= 0x0004;
const auto MOUSE_HWHEELED 	= 0x0008;

/*
 * Listbox Styles
 */
const auto LBS_NOTIFY            = 0x0001;
const auto LBS_SORT              = 0x0002;
const auto LBS_NOREDRAW          = 0x0004;
const auto LBS_MULTIPLESEL       = 0x0008;
const auto LBS_OWNERDRAWFIXED    = 0x0010;
const auto LBS_OWNERDRAWVARIABLE = 0x0020;
const auto LBS_HASSTRINGS        = 0x0040;
const auto LBS_USETABSTOPS       = 0x0080;
const auto LBS_NOINTEGRALHEIGHT  = 0x0100;
const auto LBS_MULTICOLUMN       = 0x0200;
const auto LBS_WANTKEYBOARDINPUT = 0x0400;
const auto LBS_EXTENDEDSEL       = 0x0800;
const auto LBS_DISABLENOSCROLL   = 0x1000;
const auto LBS_NODATA            = 0x2000;

const auto LBS_NOSEL             = 0x4000;

const auto LBS_COMBOBOX          = 0x8000;

const auto LBS_STANDARD          = (LBS_NOTIFY | LBS_SORT | WS_VSCROLL | WS_BORDER);

/*
 * Listbox messages
 */
const auto LB_ADDSTRING            = 0x0180;
const auto LB_INSERTSTRING         = 0x0181;
const auto LB_DELETESTRING         = 0x0182;
const auto LB_SELITEMRANGEEX       = 0x0183;
const auto LB_RESETCONTENT         = 0x0184;
const auto LB_SETSEL               = 0x0185;
const auto LB_SETCURSEL            = 0x0186;
const auto LB_GETSEL               = 0x0187;
const auto LB_GETCURSEL            = 0x0188;
const auto LB_GETTEXT              = 0x0189;
const auto LB_GETTEXTLEN           = 0x018A;
const auto LB_GETCOUNT             = 0x018B;
const auto LB_SELECTSTRING         = 0x018C;
const auto LB_DIR                  = 0x018D;
const auto LB_GETTOPINDEX          = 0x018E;
const auto LB_FINDSTRING           = 0x018F;
const auto LB_GETSELCOUNT          = 0x0190;
const auto LB_GETSELITEMS          = 0x0191;
const auto LB_SETTABSTOPS          = 0x0192;
const auto LB_GETHORIZONTALEXTENT  = 0x0193;
const auto LB_SETHORIZONTALEXTENT  = 0x0194;
const auto LB_SETCOLUMNWIDTH       = 0x0195;
const auto LB_ADDFILE              = 0x0196;
const auto LB_SETTOPINDEX          = 0x0197;
const auto LB_GETITEMRECT          = 0x0198;
const auto LB_GETITEMDATA          = 0x0199;
const auto LB_SETITEMDATA          = 0x019A;
const auto LB_SELITEMRANGE         = 0x019B;
const auto LB_SETANCHORINDEX       = 0x019C;
const auto LB_GETANCHORINDEX       = 0x019D;
const auto LB_SETCARETINDEX        = 0x019E;
const auto LB_GETCARETINDEX        = 0x019F;
const auto LB_SETITEMHEIGHT        = 0x01A0;
const auto LB_GETITEMHEIGHT        = 0x01A1;
const auto LB_FINDSTRINGEXACT      = 0x01A2;
const auto LB_SETLOCALE            = 0x01A5;
const auto LB_GETLOCALE            = 0x01A6;
const auto LB_SETCOUNT             = 0x01A7;

const auto LB_INITSTORAGE          = 0x01A8;
const auto LB_ITEMFROMPOINT        = 0x01A9;
//CE:
const auto LB_MULTIPLEADDSTRING    = 0x01B1;



/*
 * Combo Box styles
 */
const auto CBS_SIMPLE            = 0x0001;
const auto CBS_DROPDOWN          = 0x0002;
const auto CBS_DROPDOWNLIST      = 0x0003;
const auto CBS_OWNERDRAWFIXED    = 0x0010;
const auto CBS_OWNERDRAWVARIABLE = 0x0020;
const auto CBS_AUTOHSCROLL       = 0x0040;
const auto CBS_OEMCONVERT        = 0x0080;
const auto CBS_SORT              = 0x0100;
const auto CBS_HASSTRINGS        = 0x0200;
const auto CBS_NOINTEGRALHEIGHT  = 0x0400;
const auto CBS_DISABLENOSCROLL   = 0x0800;

const auto CBS_UPPERCASE         = 0x2000;
const auto CBS_LOWERCASE         = 0x4000;



/*
 * Combo Box messages
 */
const auto CB_GETEDITSEL               = 0x0140;
const auto CB_LIMITTEXT                = 0x0141;
const auto CB_SETEDITSEL               = 0x0142;
const auto CB_ADDSTRING                = 0x0143;
const auto CB_DELETESTRING             = 0x0144;
const auto CB_DIR                      = 0x0145;
const auto CB_GETCOUNT                 = 0x0146;
const auto CB_GETCURSEL                = 0x0147;
const auto CB_GETLBTEXT                = 0x0148;
const auto CB_GETLBTEXTLEN             = 0x0149;
const auto CB_INSERTSTRING             = 0x014A;
const auto CB_RESETCONTENT             = 0x014B;
const auto CB_FINDSTRING               = 0x014C;
const auto CB_SELECTSTRING             = 0x014D;
const auto CB_SETCURSEL                = 0x014E;
const auto CB_SHOWDROPDOWN             = 0x014F;
const auto CB_GETITEMDATA              = 0x0150;
const auto CB_SETITEMDATA              = 0x0151;
const auto CB_GETDROPPEDCONTROLRECT    = 0x0152;
const auto CB_SETITEMHEIGHT            = 0x0153;
const auto CB_GETITEMHEIGHT            = 0x0154;
const auto CB_SETEXTENDEDUI            = 0x0155;
const auto CB_GETEXTENDEDUI            = 0x0156;
const auto CB_GETDROPPEDSTATE          = 0x0157;
const auto CB_FINDSTRINGEXACT          = 0x0158;
const auto CB_SETLOCALE                = 0x0159;
const auto CB_GETLOCALE                = 0x015A;
//#if(WINVER >= 0x0400)
const auto CB_GETTOPINDEX              = 0x015b;
const auto CB_SETTOPINDEX              = 0x015c;
const auto CB_GETHORIZONTALEXTENT      = 0x015d;
const auto CB_SETHORIZONTALEXTENT      = 0x015e;
const auto CB_GETDROPPEDWIDTH          = 0x015f;
const auto CB_SETDROPPEDWIDTH          = 0x0160;
const auto CB_INITSTORAGE              = 0x0161;
//#if(_WIN32_WCE >= 0x0400)
const auto CB_MULTIPLEADDSTRING        = 0x0163;

//#if(_WIN32_WINNT >= 0x0501)
const auto CB_GETCOMBOBOXINFO          = 0x0164;
//#endif /* _WIN32_WINNT >= 0x0501 */

//#if(_WIN32_WINNT >= 0x0501)
const auto CB_MSGMAX                   = 0x0165;
//#elif(_WIN32_WCE >= 0x0400)
//const auto CB_MSGMAX                   = 0x0163
//#elif(WINVER >= 0x0400)
//const auto CB_MSGMAX                   = 0x0162
//#else
//const auto CB_MSGMAX                   = 0x015B
//#endif
//#endif  /* !NOWINMESSAGES */

struct COORD {
	SHORT X;
	SHORT Y;
}

struct SMALL_RECT {
	SHORT Left;
	SHORT Top;
	SHORT Right;
	SHORT Bottom;
}

struct CONSOLE_SCREEN_BUFFER_INFO {
	COORD dwSize;
	COORD dwCursorPosition;
	WORD wAttributes;
	SMALL_RECT srWindow;
	COORD dwMaximumWindowSize;
}

union INPUT_RECORD_Event
{
	KEY_EVENT_RECORD KeyEvent;
	MOUSE_EVENT_RECORD MouseEvent;
	WINDOW_BUFFER_SIZE_RECORD WindowBufferSizeEvent;
	MENU_EVENT_RECORD MenuEvent;
	FOCUS_EVENT_RECORD FocusEvent;
}

struct INPUT_RECORD
{
	WORD EventType;
	INPUT_RECORD_Event Event;
}

union KEY_EVENT_RECORD_uChar
{
	WCHAR UnicodeChar;
	CHAR AsciiChar;
}

struct KEY_EVENT_RECORD
{
	BOOL bKeyDown;
	WORD wRepeatCount;
	WORD wVirtualKeyCode;
	WORD wVirtualScanCode;
	KEY_EVENT_RECORD_uChar uChar;
	DWORD dwControlKeyState;
}

struct FOCUS_EVENT_RECORD
{
	BOOL bSetFocus;
}

struct MENU_EVENT_RECORD
{
	UINT dwCommandId;
}

struct MOUSE_EVENT_RECORD
{
	COORD dwMousePosition;
	DWORD dwButtonState;
	DWORD dwControlKeyState;
	DWORD dwEventFlags;
}

struct WINDOW_BUFFER_SIZE_RECORD
{
	COORD dwSize;
}

struct CONSOLE_CURSOR_INFO {
  DWORD dwSize;
  BOOL bVisible;
}

/* Text Alignment Options */
const auto TA_NOUPDATECP                = 0;
const auto TA_UPDATECP                  = 1;

const auto TA_LEFT                      = 0;
const auto TA_RIGHT                     = 2;
const auto TA_CENTER                    = 6;

const auto TA_TOP                       = 0;
const auto TA_BOTTOM                    = 8;
const auto TA_BASELINE                  = 24;

const auto TA_RTLREADING                = 256;
const auto TA_MASK       = (TA_BASELINE+TA_CENTER+TA_UPDATECP+TA_RTLREADING);


const auto VTA_BASELINE = TA_BASELINE;
const auto VTA_LEFT     = TA_BOTTOM;
const auto VTA_RIGHT    = TA_TOP;
const auto VTA_CENTER   = TA_CENTER;
const auto VTA_BOTTOM   = TA_RIGHT;
const auto VTA_TOP      = TA_LEFT;

const auto ETO_OPAQUE                   = 0x0002;
const auto ETO_CLIPPED                  = 0x0004;

const auto ETO_GLYPH_INDEX              = 0x0010;
const auto ETO_RTLREADING               = 0x0080;
const auto ETO_NUMERICSLOCAL            = 0x0400;
const auto ETO_NUMERICSLATIN            = 0x0800;
const auto ETO_IGNORELANGUAGE           = 0x1000;


const auto ETO_PDY                      = 0x2000;

const auto ETO_REVERSE_INDEX_MAP        = 0x10000;




/*
 * Menu flags for Add/Check/EnableMenuItem()
 */
const auto MF_INSERT           = 0x00000000;
const auto MF_CHANGE           = 0x00000080;
const auto MF_APPEND           = 0x00000100;
const auto MF_DELETE           = 0x00000200;
const auto MF_REMOVE           = 0x00001000;

const auto MF_BYCOMMAND        = 0x00000000;
const auto MF_BYPOSITION       = 0x00000400;

const auto MF_SEPARATOR        = 0x00000800;

const auto MF_ENABLED          = 0x00000000;
const auto MF_GRAYED           = 0x00000001;
const auto MF_DISABLED         = 0x00000002;

const auto MF_UNCHECKED        = 0x00000000;
const auto MF_CHECKED          = 0x00000008;
const auto MF_USECHECKBITMAPS  = 0x00000200;

const auto MF_STRING           = 0x00000000;
const auto MF_BITMAP           = 0x00000004;
const auto MF_OWNERDRAW        = 0x00000100;

const auto MF_POPUP            = 0x00000010;
const auto MF_MENUBARBREAK     = 0x00000020;
const auto MF_MENUBREAK        = 0x00000040;

const auto MF_UNHILITE         = 0x00000000;
const auto MF_HILITE           = 0x00000080;


const auto MF_DEFAULT          = 0x00001000;

const auto MF_SYSMENU          = 0x00002000;
const auto MF_HELP             = 0x00004000;

const auto MF_RIGHTJUSTIFY     = 0x00004000;


const auto MF_MOUSESELECT      = 0x00008000;

const auto MF_END              = 0x00000080;  /* Obsolete -- only used by old RES files */



const auto MFT_STRING          = MF_STRING;
const auto MFT_BITMAP          = MF_BITMAP;
const auto MFT_MENUBARBREAK    = MF_MENUBARBREAK;
const auto MFT_MENUBREAK       = MF_MENUBREAK;
const auto MFT_OWNERDRAW       = MF_OWNERDRAW;
const auto MFT_RADIOCHECK      = 0x00000200;
const auto MFT_SEPARATOR       = MF_SEPARATOR;
const auto MFT_RIGHTORDER      = 0x00002000;
const auto MFT_RIGHTJUSTIFY    = MF_RIGHTJUSTIFY;

/* Menu flags for Add/Check/EnableMenuItem() */
const auto MFS_GRAYED          = 0x00000003;
const auto MFS_DISABLED        = MFS_GRAYED;
const auto MFS_CHECKED         = MF_CHECKED;
const auto MFS_HILITE          = MF_HILITE;
const auto MFS_ENABLED         = MF_ENABLED;
const auto MFS_UNCHECKED       = MF_UNCHECKED;
const auto MFS_UNHILITE        = MF_UNHILITE;
const auto MFS_DEFAULT         = MF_DEFAULT;

const auto MFS_MASK            = 0x0000108B;
const auto MFS_HOTTRACKDRAWN   = 0x10000000;
const auto MFS_CACHEDBMP       = 0x20000000;
const auto MFS_BOTTOMGAPDROP   = 0x40000000;
const auto MFS_TOPGAPDROP      = 0x80000000;
const auto MFS_GAPDROP         = 0xC0000000;

const auto RGN_AND             = 1;
const auto RGN_OR              = 2;
const auto RGN_XOR             = 3;
const auto RGN_DIFF            = 4;
const auto RGN_COPY            = 5;
const auto RGN_MIN             = RGN_AND;
const auto RGN_MAX             = RGN_COPY;

struct SECURITY_ATTRIBUTES {
  DWORD nLength;
  LPVOID lpSecurityDescriptor;
  BOOL bInheritHandle;
}


struct LIST_ENTRY {
   LIST_ENTRY *Flink;
   LIST_ENTRY *Blink;
}

struct RTL_CRITICAL_SECTION_DEBUG {
    WORD   Type;
    WORD   CreatorBackTraceIndex;
    CRITICAL_SECTION *CriticalSection;
    LIST_ENTRY ProcessLocksList;
    DWORD EntryCount;
    DWORD ContentionCount;
    DWORD Flags;
    WORD   CreatorBackTraceIndexHigh;
    WORD   SpareWORD  ;
}

struct CRITICAL_SECTION {
    void* DebugInfo;

    //
    //  The following three fields control entering and exiting the critical
    //  section for the resource
    //

    LONG LockCount;
    LONG RecursionCount;
    HANDLE OwningThread;        // from the thread's ClientId->UniqueThread
    HANDLE LockSemaphore;
    void* SpinCount;        // force size on 64-bit systems when packed
}

alias UINT MMRESULT;

const auto MMSYSERR_BASE          = 0;
const auto WAVERR_BASE            = 32;
const auto MIDIERR_BASE           = 64;
const auto TIMERR_BASE            = 96;
const auto JOYERR_BASE            = 160;
const auto MCIERR_BASE            = 256;
const auto MIXERR_BASE            = 1024;

/* waveform audio data types */

struct HWAVE
{
	int unused;
}

struct HWAVEIN
{
	int unused;
}

struct HWAVEOUT
{
	int unused;
}

struct HDRVR
{
	int unused;
}

/* flags used with waveOutOpen(), waveInOpen(), midiInOpen(), and */
/* midiOutOpen() to specify the type of the dwCallback parameter. */

const auto CALLBACK_TYPEMASK   = 0x00070000;    /* callback type mask */
const auto CALLBACK_NULL       = 0x00000000;    /* no callback */
const auto CALLBACK_WINDOW     = 0x00010000;    /* dwCallback is a HWND */
const auto CALLBACK_TASK       = 0x00020000;    /* dwCallback is a HTASK */
const auto CALLBACK_FUNCTION   = 0x00030000;    /* dwCallback is a FARPROC */

const auto CALLBACK_THREAD     = CALLBACK_TASK; /* thread ID replaces 16 bit task */
const auto CALLBACK_EVENT      = 0x00050000;    /* dwCallback is an EVENT Handle */

alias void function(HDRVR hdrvr, UINT uMsg, DWORD* dwUser, DWORD* dw1, DWORD* dw2) DRVCALLBACK;
alias extern (C) void function(HDRVR hdrvr, UINT uMsg, DWORD dwInstance, DWORD dw1, DWORD dw2) WAVECALLBACK;

/* waveform audio error return values */
const auto WAVERR_BADFORMAT      = (WAVERR_BASE + 0);    /* unsupported wave format */
const auto WAVERR_STILLPLAYING   = (WAVERR_BASE + 1);    /* still something playing */
const auto WAVERR_UNPREPARED     = (WAVERR_BASE + 2);    /* header not prepared */
const auto WAVERR_SYNC           = (WAVERR_BASE + 3);    /* device is synchronous */
const auto WAVERR_LASTERROR      = (WAVERR_BASE + 3);    /* last error in range */

/*
typedef DRVCALLBACK WAVECALLBACK;
typedef WAVECALLBACK FAR *LPWAVECALLBACK; */

const auto MM_WOM_OPEN         = 0x3BB;           /* waveform output */
const auto MM_WOM_CLOSE        = 0x3BC;
const auto MM_WOM_DONE         = 0x3BD;

const auto MM_WIM_OPEN         = 0x3BE;           /* waveform input */
const auto MM_WIM_CLOSE        = 0x3BF;
const auto MM_WIM_DATA         = 0x3C0;

/* wave callback messages */
const auto WOM_OPEN        = MM_WOM_OPEN;
const auto WOM_CLOSE       = MM_WOM_CLOSE;
const auto WOM_DONE        = MM_WOM_DONE;
const auto WIM_OPEN        = MM_WIM_OPEN;
const auto WIM_CLOSE       = MM_WIM_CLOSE;
const auto WIM_DATA        = MM_WIM_DATA;

/* device ID for wave device mapper */
const auto WAVE_MAPPER     = cast(UINT*)-1;

/* flags for dwFlags parameter in waveOutOpen() and waveInOpen() */
const auto  WAVE_FORMAT_QUERY         = 0x0001;
const auto  WAVE_ALLOWSYNC            = 0x0002;

const auto  WAVE_MAPPED               = 0x0004;
const auto  WAVE_FORMAT_DIRECT        = 0x0008;
const auto  WAVE_FORMAT_DIRECT_QUERY  = (WAVE_FORMAT_QUERY | WAVE_FORMAT_DIRECT);

/* wave data block header */
struct WAVEHDR {
    ubyte*       lpData;                 /* pointer to locked data buffer */
    DWORD       dwBufferLength;         /* length of data buffer */
    DWORD       dwBytesRecorded;        /* used for input only */
    DWORD*		dwUser;                 /* for client's use */
    DWORD       dwFlags;                /* assorted flags (see defines) */
    DWORD       dwLoops;                /* loop control counter */
    WAVEHDR* 	lpNext;     			/* reserved for driver */
    DWORD*   	reserved;               /* reserved for driver */
}


/* OLD general waveform format structure (information common to all formats) */
struct WAVEFORMAT {
    WORD    wFormatTag;        /* format type */
    WORD    nChannels;         /* number of channels (i.e. mono, stereo, etc.) */
    DWORD   nSamplesPerSec;    /* sample rate */
    DWORD   nAvgBytesPerSec;   /* for buffer estimation */
    WORD    nBlockAlign;       /* block size of data */
}

/* flags for wFormatTag field of WAVEFORMAT */
const auto WAVE_FORMAT_PCM     = 1;

/* specific waveform format structure for PCM data */
struct PCMWAVEFORMAT {
    WAVEFORMAT  wf;
    WORD        wBitsPerSample;
}

/*
 *  extended waveform format structure used for all non-PCM formats. this
 *  structure is common to all non-PCM formats.
 */
struct WAVEFORMATEX
{
    WORD        wFormatTag;         /* format type */
    WORD        nChannels;          /* number of channels (i.e. mono, stereo...) */
    DWORD       nSamplesPerSec;     /* sample rate */
    DWORD       nAvgBytesPerSec;    /* for buffer estimation */
    WORD        nBlockAlign;        /* block size of data */
    WORD        wBitsPerSample;     /* number of bits per sample of mono data */
    WORD        cbSize;             /* the count in bytes of the size of */
                                    /* extra information (after cbSize) */
}

/* MMTIME data structure */

/* SMPTE */
struct MMTIME_u_smpte
{
    BYTE    hour;       /* hours */
    BYTE    min;        /* minutes */
    BYTE    sec;        /* seconds */
    BYTE    frame;      /* frames  */
    BYTE    fps;        /* frames per second */
    BYTE    dummy;      /* pad */

    BYTE    pad[2];
}

/* MIDI */
struct MMTIME_u_midi
{
    DWORD songptrpos;   /* song pointer position */
}

/* inner union */
union MMTIME_u
{
    DWORD       ms;         /* milliseconds */
    DWORD       sample;     /* samples */
    DWORD       cb;         /* byte count */
    DWORD       ticks;      /* ticks in MIDI stream */

	MMTIME_u_smpte smpte;

	MMTIME_u_midi midi;
}

/* main structure */
struct MMTIME
{
    UINT            wType;      /* indicates the contents of the union */

    MMTIME_u u;
}

/* types for wType field in MMTIME struct */
const auto TIME_MS         = 0x0001;  /* time in milliseconds */
const auto TIME_SAMPLES    = 0x0002;  /* number of wave samples */
const auto TIME_BYTES      = 0x0004;  /* current byte offset */
const auto TIME_SMPTE      = 0x0008;  /* SMPTE time */
const auto TIME_MIDI       = 0x0010;  /* MIDI time */
const auto TIME_TICKS      = 0x0020;  /* Ticks within MIDI stream */

const auto WM_USER         = 0x0400;
const auto WM_INPUT        = 0x00FF;

/*
 * Progress Bar Messages
 */

const auto PBM_SETRANGE 		= (WM_USER + 1);
const auto PBM_SETPOS 			= (WM_USER + 2);
const auto PBM_SETSTEP 			= (WM_USER + 4);
const auto PBM_STEPIT 			= (WM_USER + 5);
const auto PBM_SETRANGE32 		= (WM_USER + 6);
const auto PBM_GETRANGE 		= (WM_USER + 7);


/*
 * Track Bar Messages
 */

const auto TBM_GETPOS              = (WM_USER);
const auto TBM_GETRANGEMIN         = (WM_USER+1);
const auto TBM_GETRANGEMAX         = (WM_USER+2);
const auto TBM_GETTIC              = (WM_USER+3);
const auto TBM_SETTIC              = (WM_USER+4);
const auto TBM_SETPOS              = (WM_USER+5);
const auto TBM_SETRANGE            = (WM_USER+6);
const auto TBM_SETRANGEMIN         = (WM_USER+7);
const auto TBM_SETRANGEMAX         = (WM_USER+8);
const auto TBM_CLEARTICS           = (WM_USER+9);
const auto TBM_SETSEL              = (WM_USER+10);
const auto TBM_SETSELSTART         = (WM_USER+11);
const auto TBM_SETSELEND           = (WM_USER+12);
const auto TBM_GETPTICS            = (WM_USER+14);
const auto TBM_GETTICPOS           = (WM_USER+15);
const auto TBM_GETNUMTICS          = (WM_USER+16);
const auto TBM_GETSELSTART         = (WM_USER+17);
const auto TBM_GETSELEND           = (WM_USER+18);
const auto TBM_CLEARSEL            = (WM_USER+19);
const auto TBM_SETTICFREQ          = (WM_USER+20);



struct PIXELFORMATDESCRIPTOR {
  ushort nSize;
  ushort nVersion;
  uint dwFlags;
  ubyte iPixelType;
  ubyte cColorBits;
  ubyte cRedBits;
  ubyte cRedShift;
  ubyte cGreenBits;
  ubyte cGreenShift;
  ubyte cBlueBits;
  ubyte cBlueShift;
  ubyte cAlphaBits;
  ubyte cAlphaShift;
  ubyte cAccumBits;
  ubyte cAccumRedBits;
  ubyte cAccumGreenBits;
  ubyte cAccumBlueBits;
  ubyte cAccumAlphaBits;
  ubyte cDepthBits;
  ubyte cStencilBits;
  ubyte cAuxBuffers;
  ubyte iLayerType;
  ubyte bReserved;
  uint dwLayerMask;
  uint dwVisibleMask;
  uint dwDamageMask;
}

struct WIN32_FIND_DATAW {
  DWORD    dwFileAttributes;
  FILETIME ftCreationTime;
  FILETIME ftLastAccessTime;
  FILETIME ftLastWriteTime;
  DWORD    nFileSizeHigh;
  DWORD    nFileSizeLow;
  DWORD    dwReserved0;
  DWORD    dwReserved1;
  wchar    cFileName[MAX_PATH];
  wchar    cAlternateFileName[14];
}

extern(Windows)
{
	DWORD timeGetTime();

	int MessageBoxW(HWND hWnd, LPCWSTR lpText, LPCWSTR lpCaption, UINT uType);

	ulong GetWindowLongW(HWND hWnd, int nIndex);
	ulong SetWindowLongW(HWND hWnd, int nIndex, ulong newValue);

	int ChoosePixelFormat(HDC hdc, PIXELFORMATDESCRIPTOR* ppfd);
	BOOL SetPixelFormat(HDC hdc, int iPixelFormat, PIXELFORMATDESCRIPTOR* ppfd);


	HMODULE LoadLibraryW(LPCWSTR);
	FARPROC GetProcAddress (HMODULE,LPCSTR);

	LRESULT DefWindowProcW(HWND hWnd, UINT Msg, WPARAM wParam, LPARAM lParam);

	HBRUSH CreateSolidBrush(COLORREF color);

	BOOL KillTimer(HWND hWnd, uint uIDEvent);
	uint SetTimer(HWND hWnd, uint nIDEvent, UINT uElapse, TIMERPROC lpTimerFunc);

	LRESULT SendMessageW(HWND hWnd, UINT Msg, WPARAM wParam, LPARAM lParam);
	BOOL GetMessageW(LPMSG,HWND,uint,uint);
	LRESULT DispatchMessageW(MSG *lpMsg);
	BOOL PeekMessageW(LPMSG,HWND,UINT,UINT,UINT);
	BOOL PostThreadMessageW(DWORD, UINT, WPARAM, LPARAM);
	LPARAM GetMessageExtraInfo();

	BOOL IsWindowUnicode(HWND hWnd);

	BOOL GetVersionExW(OSVERSIONINFOW* VersionInformation);

	UINT GetDoubleClickTime();
	BOOL DestroyWindow(HWND);

	LRESULT CallWindowProcW(WNDPROC, HWND, uint, WPARAM, LPARAM);
	BOOL GetScrollInfo(HWND,int,SCROLLINFO*);

	// CONSOLE
	HANDLE GetStdHandle(DWORD);

	BOOL SetConsoleTextAttribute(HANDLE, WORD);

	BOOL GetConsoleScreenBufferInfo(HANDLE, CONSOLE_SCREEN_BUFFER_INFO*);
	BOOL SetConsoleWindowInfo(HANDLE,BOOL,SMALL_RECT*);
	BOOL SetConsoleScreenBufferSize(HANDLE, COORD);

	BOOL SetConsoleCursorInfo(HANDLE, CONSOLE_CURSOR_INFO*);
	BOOL GetConsoleCursorInfo(HANDLE, CONSOLE_CURSOR_INFO*);

	BOOL SetConsoleCursorPosition(HANDLE, COORD);

	HWND GetConsoleWindow();

	BOOL FillConsoleOutputCharacterW(HANDLE, WCHAR, DWORD, COORD, DWORD*);
	BOOL FillConsoleOutputAttribute(HANDLE, WORD, DWORD, COORD, DWORD*);

	HANDLE FindFirstFileW(LPCWSTR lpFileName, WIN32_FIND_DATAW* lpFindFileData);
	BOOL FindNextFileW(HANDLE hFindFile, WIN32_FIND_DATAW*);

	BOOL ReadConsoleInputW(HANDLE, INPUT_RECORD*, DWORD, DWORD*);
	BOOL PeekConsoleInput(HANDLE, INPUT_RECORD*, DWORD, DWORD*);
	BOOL WriteConsoleInput(HANDLE, INPUT_RECORD*, DWORD, DWORD*);

	BOOL WriteConsoleOutputCharacterW(HANDLE, LPCWSTR, DWORD, COORD, DWORD*);
	BOOL WriteConsoleOutputCharacterA(HANDLE, LPCTSTR, DWORD, COORD, DWORD*);
	BOOL WriteConsoleOutputAttribute(HANDLE, WORD*, DWORD, COORD, DWORD*);
	BOOL WriteConsoleW(HANDLE, VOID*, DWORD, DWORD*, VOID*);

	BOOL SetConsoleOutputCP(UINT);

	// AUDIO FUNCTION
	MMRESULT waveOutOpen(HWAVEOUT*, UINT*, WAVEFORMATEX*, void function(HWAVEOUT, UINT, DWORD, DWORD, DWORD), DWORD, DWORD);
	MMRESULT waveOutPause(HWAVEOUT);
	MMRESULT waveOutRestart(HWAVEOUT);
	MMRESULT waveOutPrepareHeader(HWAVEOUT, WAVEHDR*, UINT cbwh);
	MMRESULT waveOutUnprepareHeader(HWAVEOUT, WAVEHDR*, UINT);
	MMRESULT waveOutClose(HWAVEOUT);
	MMRESULT waveOutReset(HWAVEOUT);
	MMRESULT waveOutGetPosition(HWAVEOUT, MMTIME*, UINT);
	MMRESULT waveOutWrite(HWAVEOUT, WAVEHDR*, UINT cbwh);

	// GRAPHICS FUNCTIONS
	BOOL BitBlt(HDC, int, int, int, int, HDC hdcSrc, int x1, int y1, DWORD rop);
	BOOL Rectangle(HDC , int , int , int , int );
	BOOL Ellipse(HDC , int , int , int , int );
	BOOL ExtTextOutW( HDC, int, int, UINT, RECT*, LPCWSTR, UINT, INT*);
	HBITMAP CreateDIBSection(HDC,BITMAPINFO*,UINT,VOID**,HANDLE,DWORD);
	BOOL AlphaBlend(HDC, int, int, int, int, HDC, int, int, int, int, BLENDFUNCTION);
	BOOL GetTextExtentPoint32W(HDC, LPCWSTR, int, SIZE*);
	COLORREF SetBkColor(HDC, COLORREF);
	HBITMAP CreateCompatibleBitmap(HDC, int, int cy);
	int ReleaseDC(HWND, HDC);
	DWORD GetSysColor(int);
	int SwapBuffers(HDC hdc);
	HFONT CreateFontIndirectW(LOGFONTW*);

	// WINDOW AND PROCESS MANAGEMENT
	HWND CreateWindowExW(DWORD,LPCWSTR,LPCWSTR,DWORD,int,int,int,int,HWND,HMENU,HINSTANCE,LPVOID);
	BOOL SetWindowTextW(HWND, wchar*);
	int GetWindowTextW(HWND, LPWSTR, int);
	ATOM RegisterClassW(WNDCLASSW*);
	BOOL PostMessageW(HWND hWnd, UINT Msg,WPARAM wParam,LPARAM lParam);
	void InitCommonControls();
	BOOL SetWindowPos(HWND, HWND, int, int, int, int, UINT);
	void ExitProcess(uint uExitCode);

	// MISC
	int MulDiv(int,int,int);

	// FILE
    HANDLE CreateFileW(LPCWSTR, DWORD, DWORD, LPSECURITY_ATTRIBUTES, DWORD, DWORD, HANDLE);
	BOOL GetFileSizeEx(HANDLE, PLARGE_INTEGER);
	BOOL MoveFileW(LPCWSTR, LPCWSTR);
	BOOL MoveFileExW(LPCWSTR, LPCWSTR, DWORD);
	
	// DIRECTORY
	DWORD GetCurrentDirectoryW(DWORD, LPCWSTR);
	DWORD GetModuleFileNameW(HMODULE, LPCWSTR, DWORD);
	
	// VOLUME
	HANDLE FindFirstVolumeW(LPCWSTR, DWORD);
	BOOL FindNextVolumeW(HANDLE, LPCWSTR, DWORD);
	DWORD GetLogicalDrives();

	// SOCKET
	int GetAddrInfoW(LPCWSTR pNodeName,LPCWSTR pServiceName,ADDRINFOW* pHints,ADDRINFOW**ppResult);

	// MOUSE CAPTURE
	HWND SetCapture(HWND);
	BOOL ReleaseCapture();

	// PEN, OTHER INPUT DEVICES
	uint GetRawInputDeviceList(RAWINPUTDEVICELIST* pRawInputDeviceList, uint* puiNumDevices, uint cbSize);
	int GetRawInputDeviceInfoW(HANDLE hDevice, uint uiCommand, void* pData, uint* pcbSize);
	int GetRawInputDeviceInfoA(HANDLE hDevice, uint uiCommand, void* pData, uint* pcbSize);
	BOOL RegisterRawInputDevices(RAWINPUTDEVICE* pRawInputDevices, uint uiNumDevices, uint cbSize);
	uint GetRawInputData(HANDLE hRawInput, uint uiCommand, void* pData, uint* pcbSize, uint cbSizeHeader);

	// REGISTRY
	LONG RegOpenKeyExW(HKEY hKey, LPCWSTR lpSubKey, DWORD ulOptions, REGSAM samDesired, HKEY* phkResult);
	LONG RegCloseKey(HKEY hKey);
	LONG RegQueryValueExW(HKEY hKey, LPCWSTR lpValueName, DWORD* lpReserved, DWORD* lpType, BYTE* lpData, DWORD* lpcbData);

	// THREAD
	HANDLE CreateThread(LPSECURITY_ATTRIBUTES,uint,DWORD function(LPVOID),LPVOID,DWORD,LPDWORD);
	VOID ExitThread(DWORD);
	BOOL TerminateThread(HANDLE,DWORD);

	// EVENT (PULSE LOCKS)
	HANDLE CreateEventW(SECURITY_ATTRIBUTES* lpEventAttributes, BOOL, BOOL, LPCWSTR lpName);
	BOOL ResetEvent(HANDLE);
	BOOL PulseEvent(HANDLE);
	BOOL SetEvent(HANDLE);

	// MUTEXES
	HANDLE CreateMutexW(SECURITY_ATTRIBUTES* lpMutexAttributes, BOOL bInitialOwner, LPCWSTR lpName);
	void EnterCriticalSection(CRITICAL_SECTION* lpCriticalSection);
	void LeaveCriticalSection(CRITICAL_SECTION* lpCriticalSection);
	void InitializeCriticalSection(CRITICAL_SECTION* lpCriticalSection);
	void DeleteCriticalSection(CRITICAL_SECTION* lpCriticalSection);

	// MENUS
	BOOL DestroyMenu(HMENU);
	HMENU CreateMenu();
	BOOL SetMenu(HWND, HMENU);
	BOOL AppendMenuW(HMENU, uint, uint*,LPCWSTR);
	BOOL ModifyMenuW(HMENU, uint, uint, uint*, LPCWSTR);
}

// FLAGS

enum: DWORD
{
	WS_EX_NOPARENTNOTIFY = 0x00000004,
	WS_EX_ACCEPTFILES = 0x00000010,
	WS_EX_TRANSPARENT = 0x00000020,
	WS_EX_RTLREADING = 0x00002000,
	WS_EX_APPWINDOW = 0x00040000,
	WS_EX_DLGMODALFRAME = 0x00000001,
	WS_EX_CONTROLPARENT = 0x00010000,
	WS_EX_WINDOWEDGE = 0x00000100,
	WS_EX_CLIENTEDGE = 0x00000200,
	WS_EX_TOOLWINDOW = 0x00000080,
	WS_EX_STATICEDGE = 0x00020000,
	WS_EX_CONTEXTHELP = 0x00000400,
	WS_EX_MDICHILD = 0x00000040,
	WS_EX_LAYERED = 0x00080000,
	WS_EX_TOPMOST = 0x00000008,
}

enum: DWORD
{
	MK_LBUTTON          = 0x0001,
	MK_RBUTTON          = 0x0002,
	MK_SHIFT            = 0x0004,
	MK_CONTROL          = 0x0008,
	MK_MBUTTON          = 0x0010,

	MK_XBUTTON1         = 0x0020,
	MK_XBUTTON2         = 0x0040,
}

enum: DWORD
{
	SWP_NOSIZE         = 0x0001,
	SWP_NOMOVE         = 0x0002,
	SWP_NOZORDER       = 0x0004,
	SWP_NOREDRAW       = 0x0008,
	SWP_NOACTIVATE     = 0x0010,
	SWP_FRAMECHANGED   = 0x0020, /* The frame changed: send WM_NCCALCSIZE */
	SWP_SHOWWINDOW     = 0x0040,
	SWP_HIDEWINDOW     = 0x0080,
	SWP_NOCOPYBITS     = 0x0100,
	SWP_NOOWNERZORDER  = 0x0200, /* Don't do owner Z ordering */
	SWP_NOSENDCHANGING = 0x0400, /* Don't send WM_WINDOWPOSCHANGING */
}

enum: uint
{
	HWND_TOP        = 0,
	HWND_BOTTOM     = 1,
	HWND_TOPMOST    = -1,
	HWND_NOTOPMOST  = -2,
}

enum: uint
{
	VER_MINORVERSION                = 0x0000001,
	VER_MAJORVERSION                = 0x0000002,
	VER_BUILDNUMBER                 = 0x0000004,
	VER_PLATFORMID                  = 0x0000008,
	VER_SERVICEPACKMINOR            = 0x0000010,
	VER_SERVICEPACKMAJOR            = 0x0000020,
	VER_SUITENAME                   = 0x0000040,
	VER_PRODUCT_TYPE                = 0x0000080,

	//
	// RtlVerifyVersionInfo() os product type values
	//

	VER_NT_WORKSTATION              = 0x0000001,
	VER_NT_DOMAIN_CONTROLLER        = 0x0000002,
	VER_NT_SERVER                   = 0x0000003,

	//
	// dwPlatformId defines:
	//

	VER_PLATFORM_WIN32s             = 0,
	VER_PLATFORM_WIN32_WINDOWS      = 1,
	VER_PLATFORM_WIN32_NT           = 2,
}

const auto CTRL_C_EVENT        = 0;
const auto CTRL_BREAK_EVENT    = 1;
const auto CTRL_CLOSE_EVENT    = 2;
// 3 is reserved!
// 4 is reserved!
const auto CTRL_LOGOFF_EVENT   = 5;
const auto CTRL_SHUTDOWN_EVENT = 6;

const int TRANSPARENT         = 1;
const int OPAQUE              = 2;

struct SIZE
{
    int        x;
    int        y;
}

const int IDC_BTNCLICK = 101;
const int IDC_BTNDONTCLICK = 102;

const int GWLP_USERDATA = -21;
const int GWLP_WNDPROC = -4;

const int WM_MOUSEWHEEL = 0x20A;
const int WM_MOUSEHWHEEL = 0x020E;

const int WM_XBUTTONDOWN = 0x020B;
const int WM_XBUTTONUP = 0x020C;

const int WM_MOUSELEAVE = 0x0402;

const int WM_UNICHAR = 0x0109;

struct CREATESTRUCTW {
    LPVOID      lpCreateParams;
    HINSTANCE   hInstance;
    HMENU       hMenu;
    HWND        hwndParent;
    int         cy;
    int         cx;
    int         y;
    int         x;
    LONG        style;
    LPCWSTR     lpszName;
    LPCWSTR     lpszClass;
    DWORD       dwExStyle;
}

struct OSVERSIONINFOW {
    DWORD dwOSVersionInfoSize;
    DWORD dwMajorVersion;
    DWORD dwMinorVersion;
    DWORD dwBuildNumber;
    DWORD dwPlatformId;
    wchar  szCSDVersion[ 128 ];     // Maintenance string for PSS usage
}

struct OSVERSIONINFOEXW {
    DWORD dwOSVersionInfoSize;
    DWORD dwMajorVersion;
    DWORD dwMinorVersion;
    DWORD dwBuildNumber;
    DWORD dwPlatformId;
    wchar  szCSDVersion[ 128 ];     // Maintenance string for PSS usage
    WORD   wServicePackMajor;
    WORD   wServicePackMinor;
    WORD   wSuiteMask;
    byte  wProductType;
    byte  wReserved;
}

const int LF_FACESIZE        = 32;
struct LOGFONTW
{
    long      lfHeight;
    long      lfWidth;
    long      lfEscapement;
    long      lfOrientation;
    long      lfWeight;
    byte      lfItalic;
    byte      lfUnderline;
    byte      lfStrikeOut;
    byte      lfCharSet;
    byte      lfOutPrecision;
    byte      lfClipPrecision;
    byte      lfQuality;
    byte      lfPitchAndFamily;
    wchar     lfFaceName[LF_FACESIZE];
}

enum : uint
{
	OsVersionWindows95			= 0,
	OsVersionWindowsNT			= 1,
	OsVersionWindows98			= 2,
	OsVersionWindows98Se		= 3,
	OsVersionWindowsMe			= 4,
	OsVersionWindows2000		= 5,
	OsVersionWindowsXp			= 6,
	OsVersionWindowsServer2003	= 7,
	OsVersionWindowsVista		= 8,
	OsVersionWindowsLonghorn	= 9,
	OsVersionWindowsMax			= 10,
}

const int S_OK                                  = (cast(HRESULT)0x00000000);
const int S_FALSE                               = (cast(HRESULT)0x00000001);

enum : uint
{
 SIZE_RESTORED      = 0,
 SIZE_MINIMIZED     = 1,
 SIZE_MAXIMIZED     = 2,
 SIZE_MAXSHOW       = 3,
 SIZE_MAXHIDE       = 4
}

const int WM_SETFONT                      = 0x0030;
