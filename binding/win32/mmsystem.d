/*
 * mmsystem.d
 *
 * This module binds MMSystem.h to D. The original copyright notice is
 * preserved below.
 *
 * Author: Dave Wilkinson
 * Originated: November 25th, 2009
 *
 */

module binding.win32.mmsystem;

import binding.win32.windef;
import binding.win32.winnt;
import binding.win32.winuser;

extern(System):

/*==========================================================================
 *
 *  mmsystem.h -- Include file for Multimedia API's
 *
 *  Version 4.00
 *
 *  Copyright (C) 1992-1998 Microsoft Corporation.  All Rights Reserved.
 *
 *--------------------------------------------------------------------------
 *
 *  Define:         Prevent inclusion of:
 *  --------------  --------------------------------------------------------
 *  MMNODRV         Installable driver support
 *  MMNOSOUND       Sound support
 *  MMNOWAVE        Waveform support
 *  MMNOMIDI        MIDI support
 *  MMNOAUX         Auxiliary audio support
 *  MMNOMIXER       Mixer support
 *  MMNOTIMER       Timer support
 *  MMNOJOY         Joystick support
 *  MMNOMCI         MCI support
 *  MMNOMMIO        Multimedia file I/O support
 *  MMNOMMSYSTEM    General MMSYSTEM functions
 *
 *==========================================================================
 */

/****************************************************************************

                    General constants and data types

****************************************************************************/

/* general constants */
const auto MAXPNAMELEN       = 32     ; /* max product name length (including NULL) */
const auto MAXERRORLENGTH    = 256    ; /* max error text length (including NULL) */
const auto MAX_JOYSTICKOEMVXDNAME  = 260 ; /* max oem vxd name length (including NULL) */

/*
 *  Microsoft Manufacturer and Product ID's (these have been moved to
 *  MMREG.H for Windows 4.00 and above).
 */

const auto MM_MIDI_MAPPER           = 1   ; /* MIDI Mapper */
const auto MM_WAVE_MAPPER           = 2   ; /* Wave Mapper */
const auto MM_SNDBLST_MIDIOUT       = 3   ; /* Sound Blaster MIDI output port */
const auto MM_SNDBLST_MIDIIN        = 4   ; /* Sound Blaster MIDI input port */
const auto MM_SNDBLST_SYNTH         = 5   ; /* Sound Blaster internal synthesizer */
const auto MM_SNDBLST_WAVEOUT       = 6   ; /* Sound Blaster waveform output */
const auto MM_SNDBLST_WAVEIN        = 7   ; /* Sound Blaster waveform input */
const auto MM_ADLIB                 = 9   ; /* Ad Lib-compatible synthesizer */
const auto MM_MPU401_MIDIOUT       = 10   ; /* MPU401-compatible MIDI output port */
const auto MM_MPU401_MIDIIN        = 11   ; /* MPU401-compatible MIDI input port */
const auto MM_PC_JOYSTICK          = 12   ; /* Joystick adapter */

/* general data types */

alias UINT        MMVERSION;  /* major (high byte), minor (low byte) */
alias UINT        VERSION;    /* major (high byte), minor (low byte) */
alias UINT        MMRESULT;   /* error return code, 0 means no error */
                                /* call as if(err=xxxx(...)) Error(err); else */
alias UINT   *LPUINT;



/* MMTIME data align(2) structure */
align(2) struct MMTIME {
    UINT            wType;      /* indicates the contents of the align(2) union */
    align(2) union _inner_union {
        DWORD       ms;         /* milliseconds */
        DWORD       sample;     /* samples */
        DWORD       cb;         /* byte count */
        DWORD       ticks;      /* ticks in MIDI stream */

        /* SMPTE */
        align(2) struct _inner_struct {
            BYTE    hour;       /* hours */
            BYTE    min;        /* minutes */
            BYTE    sec;        /* seconds */
            BYTE    frame;      /* frames  */
            BYTE    fps;        /* frames per second */
            BYTE    dummy;      /* pad */
            BYTE    pad[2];
        }
		_inner_struct smpte;

        /* MIDI */
        align(2) struct _inner_struct2 {
            DWORD songptrpos;   /* song pointer position */
        }
		_inner_struct2 midi;
    }
	_inner_union u;
}

alias MMTIME* PMMTIME;
alias MMTIME *NPMMTIME;
alias MMTIME* LPMMTIME;

/* types for wType field in MMTIME align(2) struct */
const auto TIME_MS          = 0x0001  ; /* time in milliseconds */
const auto TIME_SAMPLES     = 0x0002  ; /* number of wave samples */
const auto TIME_BYTES       = 0x0004  ; /* current byte offset */
const auto TIME_SMPTE       = 0x0008  ; /* SMPTE time */
const auto TIME_MIDI        = 0x0010  ; /* MIDI time */
const auto TIME_TICKS       = 0x0020  ; /* Ticks within MIDI stream */

/*
 *
 *
 */
template MAKEFOURCC(char ch0, char ch1, char ch2, char ch3) {
	const auto MAKEFOURCC =
              	(cast(DWORD)cast(BYTE)(ch0) | (cast(DWORD)cast(BYTE)(ch1) << 8) |
                (cast(DWORD)cast(BYTE)(ch2) << 16) | (cast(DWORD)cast(BYTE)(ch3) << 24 ));
}




/****************************************************************************

                    Multimedia Extensions Window Messages

****************************************************************************/

const auto MM_JOY1MOVE          = 0x3A0           ; /* joystick */
const auto MM_JOY2MOVE          = 0x3A1;
const auto MM_JOY1ZMOVE         = 0x3A2;
const auto MM_JOY2ZMOVE         = 0x3A3;
const auto MM_JOY1BUTTONDOWN    = 0x3B5;
const auto MM_JOY2BUTTONDOWN    = 0x3B6;
const auto MM_JOY1BUTTONUP      = 0x3B7;
const auto MM_JOY2BUTTONUP      = 0x3B8;

const auto MM_MCINOTIFY         = 0x3B9           ; /* MCI */

const auto MM_WOM_OPEN          = 0x3BB           ; /* waveform output */
const auto MM_WOM_CLOSE         = 0x3BC;
const auto MM_WOM_DONE          = 0x3BD;

const auto MM_WIM_OPEN          = 0x3BE           ; /* waveform input */
const auto MM_WIM_CLOSE         = 0x3BF;
const auto MM_WIM_DATA          = 0x3C0;

const auto MM_MIM_OPEN          = 0x3C1           ; /* MIDI input */
const auto MM_MIM_CLOSE         = 0x3C2;
const auto MM_MIM_DATA          = 0x3C3;
const auto MM_MIM_LONGDATA      = 0x3C4;
const auto MM_MIM_ERROR         = 0x3C5;
const auto MM_MIM_LONGERROR     = 0x3C6;

const auto MM_MOM_OPEN          = 0x3C7           ; /* MIDI output */
const auto MM_MOM_CLOSE         = 0x3C8;
const auto MM_MOM_DONE          = 0x3C9;

/* these are also in msvideo.h */
const auto MM_DRVM_OPEN       = 0x3D0;           /* installable drivers */
const auto MM_DRVM_CLOSE      = 0x3D1;
const auto MM_DRVM_DATA       = 0x3D2;
const auto MM_DRVM_ERROR      = 0x3D3;

/* these are used by msacm.h */
const auto MM_STREAM_OPEN       = 0x3D4;
const auto MM_STREAM_CLOSE      = 0x3D5;
const auto MM_STREAM_DONE       = 0x3D6;
const auto MM_STREAM_ERROR      = 0x3D7;

const auto MM_MOM_POSITIONCB    = 0x3CA           ; /* Callback for MEVT_POSITIONCB */

const auto MM_MCISIGNAL         = 0x3CB;

const auto MM_MIM_MOREDATA       = 0x3CC          ; /* MIM_DONE w/ pending events */

const auto MM_MIXM_LINE_CHANGE      = 0x3D0       ; /* mixer line change notify */
const auto MM_MIXM_CONTROL_CHANGE   = 0x3D1       ; /* mixer control change notify */


/****************************************************************************

                String resource number bases (internal use)

****************************************************************************/

const auto MMSYSERR_BASE           = 0;
const auto WAVERR_BASE             = 32;
const auto MIDIERR_BASE            = 64;
const auto TIMERR_BASE             = 96;
const auto JOYERR_BASE             = 160;
const auto MCIERR_BASE             = 256;
const auto MIXERR_BASE             = 1024;

const auto MCI_STRING_OFFSET       = 512;
const auto MCI_VD_OFFSET           = 1024;
const auto MCI_CD_OFFSET           = 1088;
const auto MCI_WAVE_OFFSET         = 1152;
const auto MCI_SEQ_OFFSET          = 1216;

/****************************************************************************

                        General error return values

****************************************************************************/

/* general error return values */
const auto MMSYSERR_NOERROR       = 0                    ; /* no error */
const auto MMSYSERR_ERROR         = (MMSYSERR_BASE + 1)  ; /* unspecified error */
const auto MMSYSERR_BADDEVICEID   = (MMSYSERR_BASE + 2)  ; /* device ID out of range */
const auto MMSYSERR_NOTENABLED    = (MMSYSERR_BASE + 3)  ; /* driver failed enable */
const auto MMSYSERR_ALLOCATED     = (MMSYSERR_BASE + 4)  ; /* device already allocated */
const auto MMSYSERR_INVALHANDLE   = (MMSYSERR_BASE + 5)  ; /* device handle is invalid */
const auto MMSYSERR_NODRIVER      = (MMSYSERR_BASE + 6)  ; /* no device driver present */
const auto MMSYSERR_NOMEM         = (MMSYSERR_BASE + 7)  ; /* memory allocation error */
const auto MMSYSERR_NOTSUPPORTED  = (MMSYSERR_BASE + 8)  ; /* function isn't supported */
const auto MMSYSERR_BADERRNUM     = (MMSYSERR_BASE + 9)  ; /* error value out of range */
const auto MMSYSERR_INVALFLAG     = (MMSYSERR_BASE + 10) ; /* invalid flag passed */
const auto MMSYSERR_INVALPARAM    = (MMSYSERR_BASE + 11) ; /* invalid parameter passed */
const auto MMSYSERR_HANDLEBUSY    = (MMSYSERR_BASE + 12) ; /* handle being used */
                                                   /* simultaneously on another */
                                                   /* thread (eg callback) */
const auto MMSYSERR_INVALIDALIAS  = (MMSYSERR_BASE + 13) ; /* specified alias not found */
const auto MMSYSERR_BADDB         = (MMSYSERR_BASE + 14) ; /* bad registry database */
const auto MMSYSERR_KEYNOTFOUND   = (MMSYSERR_BASE + 15) ; /* registry key not found */
const auto MMSYSERR_READERROR     = (MMSYSERR_BASE + 16) ; /* registry read error */
const auto MMSYSERR_WRITEERROR    = (MMSYSERR_BASE + 17) ; /* registry write error */
const auto MMSYSERR_DELETEERROR   = (MMSYSERR_BASE + 18) ; /* registry delete error */
const auto MMSYSERR_VALNOTFOUND   = (MMSYSERR_BASE + 19) ; /* registry value not found */
const auto MMSYSERR_NODRIVERCB    = (MMSYSERR_BASE + 20) ; /* driver does not call DriverCallback */
const auto MMSYSERR_MOREDATA      = (MMSYSERR_BASE + 21) ; /* more data to be returned */
const auto MMSYSERR_LASTERROR     = (MMSYSERR_BASE + 21) ; /* last error in range */

alias HANDLE HDRVR;

/****************************************************************************

                        Installable driver support

****************************************************************************/

version(MMNODRV) {
}
else {
	align(2) struct DRVCONFIGINFOEX {
	    DWORD   dwDCISize;
	    LPCWSTR  lpszDCISectionName;
	    LPCWSTR  lpszDCIAliasName;
	    DWORD    dnDevNode;
	}
	
	alias DRVCONFIGINFOEX* PDRVCONFIGINFOEX;
	alias DRVCONFIGINFOEX *NPDRVCONFIGINFOEX;
	alias DRVCONFIGINFOEX* LPDRVCONFIGINFOEX;
	
	/* Driver messages */
	const auto DRV_LOAD                 = 0x0001;
	const auto DRV_ENABLE               = 0x0002;
	const auto DRV_OPEN                 = 0x0003;
	const auto DRV_CLOSE                = 0x0004;
	const auto DRV_DISABLE              = 0x0005;
	const auto DRV_FREE                 = 0x0006;
	const auto DRV_CONFIGURE            = 0x0007;
	const auto DRV_QUERYCONFIGURE       = 0x0008;
	const auto DRV_INSTALL              = 0x0009;
	const auto DRV_REMOVE               = 0x000A;
	const auto DRV_EXITSESSION          = 0x000B;
	const auto DRV_POWER                = 0x000F;
	const auto DRV_RESERVED             = 0x0800;
	const auto DRV_USER                 = 0x4000;
	
	/* LPARAM of DRV_CONFIGURE message */
	align(2) struct DRVCONFIGINFO {
	    DWORD   dwDCISize;
	    LPCWSTR  lpszDCISectionName;
	    LPCWSTR  lpszDCIAliasName;
	}
	
	alias DRVCONFIGINFO* PDRVCONFIGINFO;
	alias DRVCONFIGINFO *NPDRVCONFIGINFO;
	alias DRVCONFIGINFO* LPDRVCONFIGINFO;
	
	/* Supported return values for DRV_CONFIGURE message */
	const auto DRVCNF_CANCEL            = 0x0000;
	const auto DRVCNF_OK                = 0x0001;
	const auto DRVCNF_RESTART           = 0x0002;
	
	/* installable driver function prototypes */
	alias LRESULT function(DWORD_PTR, HDRVR, UINT, LPARAM, LPARAM) DRIVERPROC;
	
	LRESULT   CloseDriver( HDRVR hDriver, LPARAM lParam1, LPARAM lParam2);
	HDRVR     OpenDriver( LPCWSTR szDriverName, LPCWSTR szSectionName, LPARAM lParam2);
	LRESULT   SendDriverMessage( HDRVR hDriver, UINT message, LPARAM lParam1, LPARAM lParam2);
	HMODULE   DrvGetModuleHandle( HDRVR hDriver);
	HMODULE   GetDriverModuleHandle( HDRVR hDriver);
	LRESULT   DefDriverProc( DWORD_PTR dwDriverIdentifier, HDRVR hdrvr, UINT uMsg, LPARAM lParam1, LPARAM lParam2);
	
	/* return values from DriverProc() function */
	const auto DRV_CANCEL              = DRVCNF_CANCEL;
	const auto DRV_OK                  = DRVCNF_OK;
	const auto DRV_RESTART             = DRVCNF_RESTART;

	const auto DRV_MCI_FIRST           = DRV_RESERVED;
	const auto DRV_MCI_LAST            = (DRV_RESERVED + 0xFFF);
}

/****************************************************************************

                          Driver callback support

****************************************************************************/

/* flags used with waveOutOpen(), waveInOpen(), midiInOpen(), and */
/* midiOutOpen() to specify the type of the dwCallback parameter. */

const auto CALLBACK_TYPEMASK    = 0x00070000    ; /* callback type mask */
const auto CALLBACK_NULL        = 0x00000000    ; /* no callback */
const auto CALLBACK_WINDOW      = 0x00010000    ; /* dwCallback is a HWND */
const auto CALLBACK_TASK        = 0x00020000    ; /* dwCallback is a HTASK */
const auto CALLBACK_FUNCTION    = 0x00030000    ; /* dwCallback is a FARPROC */

const auto CALLBACK_THREAD      = (CALLBACK_TASK); /* thread ID replaces 16 bit task */
const auto CALLBACK_EVENT       = 0x00050000    ; /* dwCallback is an EVENT Handle */

alias void function(HDRVR hdrvr, UINT uMsg, DWORD_PTR dwUser, DWORD_PTR dw1, DWORD_PTR dw2) DRVCALLBACK;

alias DRVCALLBACK *LPDRVCALLBACK;

alias DRVCALLBACK     *PDRVCALLBACK;

/****************************************************************************

                    General MMSYSTEM support

****************************************************************************/

version(MMNOMMSYSTEM) {
}
else {
	UINT mmsystemGetVersion();
}

/****************************************************************************

                            Sound support

****************************************************************************/

version(MMNOSOUND) {
}
else {
	BOOL sndPlaySoundA( LPCSTR pszSound, UINT fuSound);
	BOOL sndPlaySoundW( LPCWSTR pszSound, UINT fuSound);
	
	version(UNICODE) {
		alias sndPlaySoundW sndPlaySound;
	}
	else {
		alias sndPlaySoundA sndPlaySound;
	}
	
	/*
	 *  flag values for fuSound and fdwSound arguments on [snd]PlaySound
	 */
	const auto SND_SYNC             = 0x0000  ; /* play synchronously (default) */
	const auto SND_ASYNC            = 0x0001  ; /* play asynchronously */
	const auto SND_NODEFAULT        = 0x0002  ; /* silence (!default) if sound not found */
	const auto SND_MEMORY           = 0x0004  ; /* pszSound points to a memory file */
	const auto SND_LOOP             = 0x0008  ; /* loop the sound until next sndPlaySound */
	const auto SND_NOSTOP           = 0x0010  ; /* don't stop any currently playing sound */
	
	const auto SND_NOWAIT       = 0x00002000L ; /* don't wait if the driver is busy */
	const auto SND_ALIAS        = 0x00010000L ; /* name is a registry alias */
	const auto SND_ALIAS_ID     = 0x00110000L ; /* alias is a predefined ID */
	const auto SND_FILENAME     = 0x00020000L ; /* name is file name */
	const auto SND_RESOURCE     = 0x00040004L ; /* name is resource name or atom */
	
	const auto SND_PURGE            = 0x0040  ; /* purge non-static events for task */
	const auto SND_APPLICATION      = 0x0080  ; /* look for application specific association */
	
	const auto SND_SENTRY       = 0x00080000L ; /* Generate a SoundSentry event with this sound */
	const auto SND_SYSTEM       = 0x00200000L ; /* Treat this as a system sound */
	
	const auto SND_ALIAS_START  = 0           ; /* alias base */
	
	template sndAlias(char ch0, char ch1) {
		const DWORD sndAlias = (SND_ALIAS_START + cast(DWORD)cast(BYTE)(ch0) | (cast(DWORD)cast(BYTE)(ch1) << 8));
	}
	
	const auto SND_ALIAS_SYSTEMASTERISK         = sndAlias!('S', '*');
	const auto SND_ALIAS_SYSTEMQUESTION         = sndAlias!('S', '?');
	const auto SND_ALIAS_SYSTEMHAND             = sndAlias!('S', 'H');
	const auto SND_ALIAS_SYSTEMEXIT             = sndAlias!('S', 'E');
	const auto SND_ALIAS_SYSTEMSTART            = sndAlias!('S', 'S');
	const auto SND_ALIAS_SYSTEMWELCOME          = sndAlias!('S', 'W');
	const auto SND_ALIAS_SYSTEMEXCLAMATION      = sndAlias!('S', '!');
	const auto SND_ALIAS_SYSTEMDEFAULT          = sndAlias!('S', 'D');
	
	BOOL PlaySoundA( LPCSTR pszSound, HMODULE hmod, DWORD fdwSound);
	BOOL PlaySoundW( LPCWSTR pszSound, HMODULE hmod, DWORD fdwSound);

	version(UNICODE) {
		alias PlaySoundW PlaySound;
	}
	else {
		alias PlaySoundA PlaySound;
	}
}

/****************************************************************************

                        Waveform audio support

****************************************************************************/

version(MMNOWAVE) {
}
else {
	/* waveform audio error return values */
	const auto WAVERR_BADFORMAT       = (WAVERR_BASE + 0)    ; /* unsupported wave format */
	const auto WAVERR_STILLPLAYING    = (WAVERR_BASE + 1)    ; /* still something playing */
	const auto WAVERR_UNPREPARED      = (WAVERR_BASE + 2)    ; /* header not prepared */
	const auto WAVERR_SYNC            = (WAVERR_BASE + 3)    ; /* device is synchronous */
	const auto WAVERR_LASTERROR       = (WAVERR_BASE + 3)    ; /* last error in range */
	
	/* waveform audio data types */
	alias HANDLE HWAVE;
	alias HANDLE HWAVEIN;
	alias HANDLE HWAVEOUT;
	
	alias HWAVEIN *LPHWAVEIN;
	alias HWAVEOUT *LPHWAVEOUT;
	
	alias DRVCALLBACK WAVECALLBACK;
	alias WAVECALLBACK *LPWAVECALLBACK;
	
	/* wave callback messages */
	const auto WOM_OPEN         = MM_WOM_OPEN;
	const auto WOM_CLOSE        = MM_WOM_CLOSE;
	const auto WOM_DONE         = MM_WOM_DONE;
	const auto WIM_OPEN         = MM_WIM_OPEN;
	const auto WIM_CLOSE        = MM_WIM_CLOSE;
	const auto WIM_DATA         = MM_WIM_DATA;
	
	/* device ID for wave device mapper */
	const auto WAVE_MAPPER      = (cast(UINT)-1);
	
	/* flags for dwFlags parameter in waveOutOpen() and waveInOpen() */
	const auto   WAVE_FORMAT_QUERY         = 0x0001;
	const auto   WAVE_ALLOWSYNC            = 0x0002;

	const auto   WAVE_MAPPED               = 0x0004;
	const auto   WAVE_FORMAT_DIRECT        = 0x0008;
	const auto   WAVE_FORMAT_DIRECT_QUERY  = (WAVE_FORMAT_QUERY | WAVE_FORMAT_DIRECT);
	
	/* wave data block header */
	align(2) struct WAVEHDR {
	    ubyte*      lpData;                 /* pointer to locked data buffer */
	    DWORD       dwBufferLength;         /* length of data buffer */
	    DWORD       dwBytesRecorded;        /* used for input only */
	    DWORD_PTR   dwUser;                 /* for client's use */
	    DWORD       dwFlags;                /* assorted flags (see defines) */
	    DWORD       dwLoops;                /* loop control counter */
	    WAVEHDR*    lpNext;                 /* reserved for driver */
	    DWORD_PTR   reserved;               /* reserved for driver */
	}
	
	alias WAVEHDR* PWAVEHDR;
	alias WAVEHDR* NPWAVEHDR;
	alias WAVEHDR* LPWAVEHDR;
	
	/* flags for dwFlags field of WAVEHDR */
	const auto WHDR_DONE        = 0x00000001  ; /* done bit */
	const auto WHDR_PREPARED    = 0x00000002  ; /* set if this header has been prepared */
	const auto WHDR_BEGINLOOP   = 0x00000004  ; /* loop start block */
	const auto WHDR_ENDLOOP     = 0x00000008  ; /* loop end block */
	const auto WHDR_INQUEUE     = 0x00000010  ; /* reserved for driver */
	
	/* waveform output device capabilities align(2) structure */
	align(2) struct WAVEOUTCAPSA {
	    WORD    wMid;                  /* manufacturer ID */
	    WORD    wPid;                  /* product ID */
	    MMVERSION vDriverVersion;      /* version of the driver */
	    CHAR[MAXPNAMELEN] szPname;     /* product name (NULL terminated string) */
	    DWORD   dwFormats;             /* formats supported */
	    WORD    wChannels;             /* number of sources supported */
	    WORD    wReserved1;            /* packing */
	    DWORD   dwSupport;             /* functionality supported by driver */
	}
	
	alias WAVEOUTCAPSA* PWAVEOUTCAPSA;
	alias WAVEOUTCAPSA* NPWAVEOUTCAPSA;
	alias WAVEOUTCAPSA* LPWAVEOUTCAPSA;
	align(2) struct WAVEOUTCAPSW {
	    WORD    wMid;                  /* manufacturer ID */
	    WORD    wPid;                  /* product ID */
	    MMVERSION vDriverVersion;      /* version of the driver */
	    WCHAR[MAXPNAMELEN]   szPname;  /* product name (NULL terminated string) */
	    DWORD   dwFormats;             /* formats supported */
	    WORD    wChannels;             /* number of sources supported */
	    WORD    wReserved1;            /* packing */
	    DWORD   dwSupport;             /* functionality supported by driver */
	}
	
	alias WAVEOUTCAPSW* PWAVEOUTCAPSW;
	alias WAVEOUTCAPSW* NPWAVEOUTCAPSW;
	alias WAVEOUTCAPSW* LPWAVEOUTCAPSW;
	
	version(UNICODE) {
		alias WAVEOUTCAPSW WAVEOUTCAPS;
		alias PWAVEOUTCAPSW PWAVEOUTCAPS;
		alias NPWAVEOUTCAPSW NPWAVEOUTCAPS;
		alias LPWAVEOUTCAPSW LPWAVEOUTCAPS;
	}
	else {
		alias WAVEOUTCAPSA WAVEOUTCAPS;
		alias PWAVEOUTCAPSA PWAVEOUTCAPS;
		alias NPWAVEOUTCAPSA NPWAVEOUTCAPS;
		alias LPWAVEOUTCAPSA LPWAVEOUTCAPS;
	}
	align(2) struct WAVEOUTCAPS2A {
	    WORD    wMid;                  /* manufacturer ID */
	    WORD    wPid;                  /* product ID */
	    MMVERSION vDriverVersion;      /* version of the driver */
	    CHAR[MAXPNAMELEN]    szPname;  /* product name (NULL terminated string) */
	    DWORD   dwFormats;             /* formats supported */
	    WORD    wChannels;             /* number of sources supported */
	    WORD    wReserved1;            /* packing */
	    DWORD   dwSupport;             /* functionality supported by driver */
	    GUID    ManufacturerGuid;      /* for extensible MID mapping */
	    GUID    ProductGuid;           /* for extensible PID mapping */
	    GUID    NameGuid;              /* for name lookup in registry */
	}
	
	alias WAVEOUTCAPS2A* PWAVEOUTCAPS2A;
	alias WAVEOUTCAPS2A* NPWAVEOUTCAPS2A;
	alias WAVEOUTCAPS2A* LPWAVEOUTCAPS2A;
	align(2) struct WAVEOUTCAPS2W {
	    WORD    wMid;                  /* manufacturer ID */
	    WORD    wPid;                  /* product ID */
	    MMVERSION vDriverVersion;      /* version of the driver */
	    WCHAR[MAXPNAMELEN]   szPname;  /* product name (NULL terminated string) */
	    DWORD   dwFormats;             /* formats supported */
	    WORD    wChannels;             /* number of sources supported */
	    WORD    wReserved1;            /* packing */
	    DWORD   dwSupport;             /* functionality supported by driver */
	    GUID    ManufacturerGuid;      /* for extensible MID mapping */
	    GUID    ProductGuid;           /* for extensible PID mapping */
	    GUID    NameGuid;              /* for name lookup in registry */
	}
	
	alias WAVEOUTCAPS2W* PWAVEOUTCAPS2W;
	alias WAVEOUTCAPS2W* NPWAVEOUTCAPS2W;
	alias WAVEOUTCAPS2W* LPWAVEOUTCAPS2W;
	
	version(UNICODE) {
		alias WAVEOUTCAPS2W WAVEOUTCAPS2;
		alias PWAVEOUTCAPS2W PWAVEOUTCAPS2;
		alias NPWAVEOUTCAPS2W NPWAVEOUTCAPS2;
		alias LPWAVEOUTCAPS2W LPWAVEOUTCAPS2;
	}
	else {
		alias WAVEOUTCAPS2A WAVEOUTCAPS2;
		alias PWAVEOUTCAPS2A PWAVEOUTCAPS2;
		alias NPWAVEOUTCAPS2A NPWAVEOUTCAPS2;
		alias LPWAVEOUTCAPS2A LPWAVEOUTCAPS2;
	}
	
	/* flags for dwSupport field of WAVEOUTCAPS */
	const auto WAVECAPS_PITCH           = 0x0001   ; /* supports pitch control */
	const auto WAVECAPS_PLAYBACKRATE    = 0x0002   ; /* supports playback rate control */
	const auto WAVECAPS_VOLUME          = 0x0004   ; /* supports volume control */
	const auto WAVECAPS_LRVOLUME        = 0x0008   ; /* separate left-right volume control */
	const auto WAVECAPS_SYNC            = 0x0010;
	const auto WAVECAPS_SAMPLEACCURATE  = 0x0020;
	
	/* waveform input device capabilities align(2) structure */
	align(2) struct WAVEINCAPSA {
	    WORD    wMid;                    /* manufacturer ID */
	    WORD    wPid;                    /* product ID */
	    MMVERSION vDriverVersion;        /* version of the driver */
	    CHAR[MAXPNAMELEN]    szPname;    /* product name (NULL terminated string) */
	    DWORD   dwFormats;               /* formats supported */
	    WORD    wChannels;               /* number of channels supported */
	    WORD    wReserved1;              /* align(2) structure packing */
	}
	
	alias WAVEINCAPSA* PWAVEINCAPSA;
	alias WAVEINCAPSA* NPWAVEINCAPSA;
	alias WAVEINCAPSA* LPWAVEINCAPSA;
	align(2) struct WAVEINCAPSW {
	    WORD    wMid;                    /* manufacturer ID */
	    WORD    wPid;                    /* product ID */
	    MMVERSION vDriverVersion;        /* version of the driver */
	    WCHAR[MAXPNAMELEN]   szPname;    /* product name (NULL terminated string) */
	    DWORD   dwFormats;               /* formats supported */
	    WORD    wChannels;               /* number of channels supported */
	    WORD    wReserved1;              /* align(2) structure packing */
	}
	
	alias WAVEINCAPSW* PWAVEINCAPSW;
	alias WAVEINCAPSW* NPWAVEINCAPSW;
	alias WAVEINCAPSW* LPWAVEINCAPSW;
	
	version(UNICODE) {
		alias WAVEINCAPSW WAVEINCAPS;
		alias PWAVEINCAPSW PWAVEINCAPS;
		alias NPWAVEINCAPSW NPWAVEINCAPS;
		alias LPWAVEINCAPSW LPWAVEINCAPS;
	}
	else {
		alias WAVEINCAPSA WAVEINCAPS;
		alias PWAVEINCAPSA PWAVEINCAPS;
		alias NPWAVEINCAPSA NPWAVEINCAPS;
		alias LPWAVEINCAPSA LPWAVEINCAPS;
	}
	
	align(2) struct WAVEINCAPS2A {
	    WORD    wMid;                    /* manufacturer ID */
	    WORD    wPid;                    /* product ID */
	    MMVERSION vDriverVersion;        /* version of the driver */
	    CHAR[MAXPNAMELEN]    szPname;    /* product name (NULL terminated string) */
	    DWORD   dwFormats;               /* formats supported */
	    WORD    wChannels;               /* number of channels supported */
	    WORD    wReserved1;              /* align(2) structure packing */
	    GUID    ManufacturerGuid;        /* for extensible MID mapping */
	    GUID    ProductGuid;             /* for extensible PID mapping */
	    GUID    NameGuid;                /* for name lookup in registry */
	}
	
	alias WAVEINCAPS2A* PWAVEINCAPS2A;
	alias WAVEINCAPS2A* NPWAVEINCAPS2A;
	alias WAVEINCAPS2A* LPWAVEINCAPS2A;
	align(2) struct WAVEINCAPS2W {
	    WORD    wMid;                    /* manufacturer ID */
	    WORD    wPid;                    /* product ID */
	    MMVERSION vDriverVersion;        /* version of the driver */
	    WCHAR[MAXPNAMELEN]   szPname;    /* product name (NULL terminated string) */
	    DWORD   dwFormats;               /* formats supported */
	    WORD    wChannels;               /* number of channels supported */
	    WORD    wReserved1;              /* align(2) structure packing */
	    GUID    ManufacturerGuid;        /* for extensible MID mapping */
	    GUID    ProductGuid;             /* for extensible PID mapping */
	    GUID    NameGuid;                /* for name lookup in registry */
	}
	
	alias WAVEINCAPS2W* PWAVEINCAPS2W;
	alias WAVEINCAPS2W* NPWAVEINCAPS2W;
	alias WAVEINCAPS2W* LPWAVEINCAPS2W;
	
	version(UNICODE) {
		alias WAVEINCAPS2W WAVEINCAPS2;
		alias PWAVEINCAPS2W PWAVEINCAPS2;
		alias NPWAVEINCAPS2W NPWAVEINCAPS2;
		alias LPWAVEINCAPS2W LPWAVEINCAPS2;
	}
	else {
		alias WAVEINCAPS2A WAVEINCAPS2;
		alias PWAVEINCAPS2A PWAVEINCAPS2;
		alias NPWAVEINCAPS2A NPWAVEINCAPS2;
		alias LPWAVEINCAPS2A LPWAVEINCAPS2;
	}
	
	/* defines for dwFormat field of WAVEINCAPS and WAVEOUTCAPS */
	const auto WAVE_INVALIDFORMAT      = 0x00000000       ; /* invalid format */
	const auto WAVE_FORMAT_1M08        = 0x00000001       ; /* 11.025 kHz, Mono,   8-bit  */
	const auto WAVE_FORMAT_1S08        = 0x00000002       ; /* 11.025 kHz, Stereo, 8-bit  */
	const auto WAVE_FORMAT_1M16        = 0x00000004       ; /* 11.025 kHz, Mono,   16-bit */
	const auto WAVE_FORMAT_1S16        = 0x00000008       ; /* 11.025 kHz, Stereo, 16-bit */
	const auto WAVE_FORMAT_2M08        = 0x00000010       ; /* 22.05  kHz, Mono,   8-bit  */
	const auto WAVE_FORMAT_2S08        = 0x00000020       ; /* 22.05  kHz, Stereo, 8-bit  */
	const auto WAVE_FORMAT_2M16        = 0x00000040       ; /* 22.05  kHz, Mono,   16-bit */
	const auto WAVE_FORMAT_2S16        = 0x00000080       ; /* 22.05  kHz, Stereo, 16-bit */
	const auto WAVE_FORMAT_4M08        = 0x00000100       ; /* 44.1   kHz, Mono,   8-bit  */
	const auto WAVE_FORMAT_4S08        = 0x00000200       ; /* 44.1   kHz, Stereo, 8-bit  */
	const auto WAVE_FORMAT_4M16        = 0x00000400       ; /* 44.1   kHz, Mono,   16-bit */
	const auto WAVE_FORMAT_4S16        = 0x00000800       ; /* 44.1   kHz, Stereo, 16-bit */
	
	const auto WAVE_FORMAT_44M08       = 0x00000100       ; /* 44.1   kHz, Mono,   8-bit  */
	const auto WAVE_FORMAT_44S08       = 0x00000200       ; /* 44.1   kHz, Stereo, 8-bit  */
	const auto WAVE_FORMAT_44M16       = 0x00000400       ; /* 44.1   kHz, Mono,   16-bit */
	const auto WAVE_FORMAT_44S16       = 0x00000800       ; /* 44.1   kHz, Stereo, 16-bit */
	const auto WAVE_FORMAT_48M08       = 0x00001000       ; /* 48     kHz, Mono,   8-bit  */
	const auto WAVE_FORMAT_48S08       = 0x00002000       ; /* 48     kHz, Stereo, 8-bit  */
	const auto WAVE_FORMAT_48M16       = 0x00004000       ; /* 48     kHz, Mono,   16-bit */
	const auto WAVE_FORMAT_48S16       = 0x00008000       ; /* 48     kHz, Stereo, 16-bit */
	const auto WAVE_FORMAT_96M08       = 0x00010000       ; /* 96     kHz, Mono,   8-bit  */
	const auto WAVE_FORMAT_96S08       = 0x00020000       ; /* 96     kHz, Stereo, 8-bit  */
	const auto WAVE_FORMAT_96M16       = 0x00040000       ; /* 96     kHz, Mono,   16-bit */
	const auto WAVE_FORMAT_96S16       = 0x00080000       ; /* 96     kHz, Stereo, 16-bit */
	
	/* OLD general waveform format align(2) structure (information common to all formats) */
	align(2) struct WAVEFORMAT {
	    WORD    wFormatTag;        /* format type */
	    WORD    nChannels;         /* number of channels (i.e. mono, stereo, etc.) */
	    DWORD   nSamplesPerSec;    /* sample rate */
	    DWORD   nAvgBytesPerSec;   /* for buffer estimation */
	    WORD    nBlockAlign;       /* block size of data */
	}
	
	alias WAVEFORMAT* PWAVEFORMAT;
	alias WAVEFORMAT *NPWAVEFORMAT;
	alias WAVEFORMAT* LPWAVEFORMAT;
	
	/* flags for wFormatTag field of WAVEFORMAT */
	const auto WAVE_FORMAT_PCM      = 1;
	
	/* specific waveform format align(2) structure for PCM data */
	align(2) struct PCMWAVEFORMAT {
	    WAVEFORMAT  wf;
	    WORD        wBitsPerSample;
	}

	alias PCMWAVEFORMAT* PPCMWAVEFORMAT;
	alias PCMWAVEFORMAT *NPPCMWAVEFORMAT;
	alias PCMWAVEFORMAT* LPPCMWAVEFORMAT;
	
	/*
	 *  extended waveform format align(2) structure used for all non-PCM formats. this
	 *  align(2) structure is common to all non-PCM formats.
	 */
	align(2) struct WAVEFORMATEX {
	    WORD        wFormatTag;         /* format type */
	    WORD        nChannels;          /* number of channels (i.e. mono, stereo...) */
	    DWORD       nSamplesPerSec;     /* sample rate */
	    DWORD       nAvgBytesPerSec;    /* for buffer estimation */
	    WORD        nBlockAlign;        /* block size of data */
	    WORD        wBitsPerSample;     /* number of bits per sample of mono data */
	    WORD        cbSize;             /* the count in bytes of the size of */
	                                    /* extra information (after cbSize) */
	}
	
	alias WAVEFORMATEX* PWAVEFORMATEX;
	alias WAVEFORMATEX *NPWAVEFORMATEX;
	alias WAVEFORMATEX* LPWAVEFORMATEX;
	
	alias WAVEFORMATEX *LPCWAVEFORMATEX;
	
	/* waveform audio function prototypes */
	UINT waveOutGetNumDevs();
	
	MMRESULT waveOutGetDevCapsA( UINT_PTR uDeviceID, LPWAVEOUTCAPSA pwoc, UINT cbwoc);
	MMRESULT waveOutGetDevCapsW( UINT_PTR uDeviceID, LPWAVEOUTCAPSW pwoc, UINT cbwoc);
	
	version(UNICODE) {
		alias waveOutGetDevCapsW waveOutGetDevCaps;
	}
	else {
		alias waveOutGetDevCapsA waveOutGetDevCaps;
	}
	
	MMRESULT waveOutGetVolume( HWAVEOUT hwo, LPDWORD pdwVolume);
	MMRESULT waveOutSetVolume( HWAVEOUT hwo, DWORD dwVolume);

	MMRESULT waveOutGetErrorTextA( MMRESULT mmrError, LPSTR pszText, UINT cchText);
	MMRESULT waveOutGetErrorTextW( MMRESULT mmrError, LPWSTR pszText, UINT cchText);
	
	version(UNICODE) {
		alias waveOutGetErrorTextW waveOutGetErrorText;
	}
	else {
		alias waveOutGetErrorTextA waveOutGetErrorText;
	}
	
	MMRESULT waveOutOpen( LPHWAVEOUT phwo, UINT uDeviceID,
	    LPCWAVEFORMATEX pwfx, DWORD_PTR dwCallback, DWORD_PTR dwInstance, DWORD fdwOpen);
	
	MMRESULT waveOutClose( HWAVEOUT hwo);
	MMRESULT waveOutPrepareHeader( HWAVEOUT hwo, LPWAVEHDR pwh,  UINT cbwh);
	MMRESULT waveOutUnprepareHeader( HWAVEOUT hwo, LPWAVEHDR pwh, UINT cbwh);
	MMRESULT waveOutWrite( HWAVEOUT hwo, LPWAVEHDR pwh, UINT cbwh);
	MMRESULT waveOutPause( HWAVEOUT hwo);
	MMRESULT waveOutRestart( HWAVEOUT hwo);
	MMRESULT waveOutReset( HWAVEOUT hwo);
	MMRESULT waveOutBreakLoop( HWAVEOUT hwo);
	MMRESULT waveOutGetPosition( HWAVEOUT hwo, LPMMTIME pmmt, UINT cbmmt);
	MMRESULT waveOutGetPitch( HWAVEOUT hwo, LPDWORD pdwPitch);
	MMRESULT waveOutSetPitch( HWAVEOUT hwo, DWORD dwPitch);
	MMRESULT waveOutGetPlaybackRate( HWAVEOUT hwo, LPDWORD pdwRate);
	MMRESULT waveOutSetPlaybackRate( HWAVEOUT hwo, DWORD dwRate);
	MMRESULT waveOutGetID( HWAVEOUT hwo, LPUINT puDeviceID);
	
	MMRESULT waveOutMessage( HWAVEOUT hwo, UINT uMsg, DWORD_PTR dw1, DWORD_PTR dw2);
	
	UINT waveInGetNumDevs();
	
	MMRESULT waveInGetDevCapsA( UINT_PTR uDeviceID, LPWAVEINCAPSA pwic, UINT cbwic);
	MMRESULT waveInGetDevCapsW( UINT_PTR uDeviceID, LPWAVEINCAPSW pwic, UINT cbwic);
	
	version(UNICODE) {
		alias waveInGetDevCapsW waveInGetDevCaps;
	}
	else {
		alias waveInGetDevCapsA waveInGetDevCaps;
	}
	
	MMRESULT waveInGetErrorTextA(MMRESULT mmrError, LPSTR pszText, UINT cchText);
	MMRESULT waveInGetErrorTextW(MMRESULT mmrError, LPWSTR pszText, UINT cchText);
	
	version(UNICODE) {
		alias waveInGetErrorTextW waveInGetErrorText;
	}
	else {
		alias waveInGetErrorTextA waveInGetErrorText;
	}
	
	MMRESULT waveInOpen( LPHWAVEIN phwi, UINT uDeviceID,
	    LPCWAVEFORMATEX pwfx, DWORD_PTR dwCallback, DWORD_PTR dwInstance, DWORD fdwOpen);
	
	MMRESULT waveInClose( HWAVEIN hwi);
	MMRESULT waveInPrepareHeader( HWAVEIN hwi, LPWAVEHDR pwh, UINT cbwh);
	MMRESULT waveInUnprepareHeader( HWAVEIN hwi, LPWAVEHDR pwh, UINT cbwh);
	MMRESULT waveInAddBuffer( HWAVEIN hwi, LPWAVEHDR pwh, UINT cbwh);
	MMRESULT waveInStart( HWAVEIN hwi);
	MMRESULT waveInStop( HWAVEIN hwi);
	MMRESULT waveInReset( HWAVEIN hwi);
	MMRESULT waveInGetPosition( HWAVEIN hwi, LPMMTIME pmmt, UINT cbmmt);
	MMRESULT waveInGetID( HWAVEIN hwi, LPUINT puDeviceID);

	MMRESULT waveInMessage( HWAVEIN hwi, UINT uMsg, DWORD_PTR dw1, DWORD_PTR dw2);

}

/****************************************************************************

                            MIDI audio support

****************************************************************************/
version(MMNOMIDI) {
}
else {
	/* MIDI error return values */
	const auto MIDIERR_UNPREPARED     = (MIDIERR_BASE + 0)   ; /* header not prepared */
	const auto MIDIERR_STILLPLAYING   = (MIDIERR_BASE + 1)   ; /* still something playing */
	const auto MIDIERR_NOMAP          = (MIDIERR_BASE + 2)   ; /* no configured instruments */
	const auto MIDIERR_NOTREADY       = (MIDIERR_BASE + 3)   ; /* hardware is still busy */
	const auto MIDIERR_NODEVICE       = (MIDIERR_BASE + 4)   ; /* port no longer connected */
	const auto MIDIERR_INVALIDSETUP   = (MIDIERR_BASE + 5)   ; /* invalid MIF */
	const auto MIDIERR_BADOPENMODE    = (MIDIERR_BASE + 6)   ; /* operation unsupported w/ open mode */
	const auto MIDIERR_DONT_CONTINUE  = (MIDIERR_BASE + 7)   ; /* thru device 'eating' a message */
	const auto MIDIERR_LASTERROR      = (MIDIERR_BASE + 7)   ; /* last error in range */
	
	/* MIDI audio data types */
	alias HANDLE HMIDI;
	alias HANDLE HMIDIIN;
	alias HANDLE HMIDIOUT;
	alias HANDLE HMIDISTRM;
	
	alias HMIDI *LPHMIDI;
	alias HMIDIIN *LPHMIDIIN;
	alias HMIDIOUT *LPHMIDIOUT;
	alias HMIDISTRM *LPHMIDISTRM;
	
	alias DRVCALLBACK MIDICALLBACK;
	alias MIDICALLBACK *LPMIDICALLBACK;
	
	const auto MIDIPATCHSIZE    = 128;
	
	alias WORD[MIDIPATCHSIZE] PATCHARRAY;
	alias WORD *LPPATCHARRAY;
	alias WORD[MIDIPATCHSIZE] KEYARRAY;
	alias WORD *LPKEYARRAY;
	
	/* MIDI callback messages */
	const auto MIM_OPEN         = MM_MIM_OPEN;
	const auto MIM_CLOSE        = MM_MIM_CLOSE;
	const auto MIM_DATA         = MM_MIM_DATA;
	const auto MIM_LONGDATA     = MM_MIM_LONGDATA;
	const auto MIM_ERROR        = MM_MIM_ERROR;
	const auto MIM_LONGERROR    = MM_MIM_LONGERROR;
	const auto MOM_OPEN         = MM_MOM_OPEN;
	const auto MOM_CLOSE        = MM_MOM_CLOSE;
	const auto MOM_DONE         = MM_MOM_DONE;
	
	const auto MIM_MOREDATA       = MM_MIM_MOREDATA;
	const auto MOM_POSITIONCB     = MM_MOM_POSITIONCB;
	
	/* device ID for MIDI mapper */
	const auto MIDIMAPPER      = (cast(UINT)-1);
	const auto MIDI_MAPPER     = (cast(UINT)-1);
	
	/* flags for dwFlags parm of midiInOpen() */
	const auto MIDI_IO_STATUS       = 0x00000020L;
	
	/* flags for wFlags parm of midiOutCachePatches(), midiOutCacheDrumPatches() */
	const auto MIDI_CACHE_ALL       = 1;
	const auto MIDI_CACHE_BESTFIT   = 2;
	const auto MIDI_CACHE_QUERY     = 3;
	const auto MIDI_UNCACHE         = 4;
	
	/* MIDI output device capabilities align(2) structure */
	align(2) struct MIDIOUTCAPSA {
	    WORD    wMid;                  /* manufacturer ID */
	    WORD    wPid;                  /* product ID */
	    MMVERSION vDriverVersion;      /* version of the driver */
	    CHAR[MAXPNAMELEN]    szPname;  /* product name (NULL terminated string) */
	    WORD    wTechnology;           /* type of device */
	    WORD    wVoices;               /* # of voices (internal synth only) */
	    WORD    wNotes;                /* max # of notes (internal synth only) */
	    WORD    wChannelMask;          /* channels used (internal synth only) */
	    DWORD   dwSupport;             /* functionality supported by driver */
	}
	
	alias MIDIOUTCAPSA* PMIDIOUTCAPSA;
	alias MIDIOUTCAPSA* NPMIDIOUTCAPSA;
	alias MIDIOUTCAPSA* LPMIDIOUTCAPSA;
	
	align(2) struct MIDIOUTCAPSW {
	    WORD    wMid;                  /* manufacturer ID */
	    WORD    wPid;                  /* product ID */
	    MMVERSION vDriverVersion;      /* version of the driver */
	    WCHAR[MAXPNAMELEN]   szPname;  /* product name (NULL terminated string) */
	    WORD    wTechnology;           /* type of device */
	    WORD    wVoices;               /* # of voices (internal synth only) */
	    WORD    wNotes;                /* max # of notes (internal synth only) */
	    WORD    wChannelMask;          /* channels used (internal synth only) */
	    DWORD   dwSupport;             /* functionality supported by driver */
	}
	
	alias MIDIOUTCAPSW* PMIDIOUTCAPSW;
	alias MIDIOUTCAPSW* NPMIDIOUTCAPSW;
	alias MIDIOUTCAPSW* LPMIDIOUTCAPSW;
	
	version(UNICODE) {
		alias MIDIOUTCAPSW MIDIOUTCAPS;
		alias PMIDIOUTCAPSW PMIDIOUTCAPS;
		alias NPMIDIOUTCAPSW NPMIDIOUTCAPS;
		alias LPMIDIOUTCAPSW LPMIDIOUTCAPS;
	}
	else {
		alias MIDIOUTCAPSA MIDIOUTCAPS;
		alias PMIDIOUTCAPSA PMIDIOUTCAPS;
		alias NPMIDIOUTCAPSA NPMIDIOUTCAPS;
		alias LPMIDIOUTCAPSA LPMIDIOUTCAPS;
	}
	
	align(2) struct MIDIOUTCAPS2A {
	    WORD    wMid;                  /* manufacturer ID */
	    WORD    wPid;                  /* product ID */
	    MMVERSION vDriverVersion;      /* version of the driver */
	    CHAR[MAXPNAMELEN]    szPname;  /* product name (NULL terminated string) */
	    WORD    wTechnology;           /* type of device */
	    WORD    wVoices;               /* # of voices (internal synth only) */
	    WORD    wNotes;                /* max # of notes (internal synth only) */
	    WORD    wChannelMask;          /* channels used (internal synth only) */
	    DWORD   dwSupport;             /* functionality supported by driver */
	    GUID    ManufacturerGuid;      /* for extensible MID mapping */
	    GUID    ProductGuid;           /* for extensible PID mapping */
	    GUID    NameGuid;              /* for name lookup in registry */
	}
	
	alias MIDIOUTCAPS2A* PMIDIOUTCAPS2A;
	alias MIDIOUTCAPS2A* NPMIDIOUTCAPS2A;
	alias MIDIOUTCAPS2A* LPMIDIOUTCAPS2A;
	
	align(2) struct MIDIOUTCAPS2W {
	    WORD    wMid;                  /* manufacturer ID */
	    WORD    wPid;                  /* product ID */
	    MMVERSION vDriverVersion;      /* version of the driver */
	    WCHAR[MAXPNAMELEN]   szPname;  /* product name (NULL terminated string) */
	    WORD    wTechnology;           /* type of device */
	    WORD    wVoices;               /* # of voices (internal synth only) */
	    WORD    wNotes;                /* max # of notes (internal synth only) */
	    WORD    wChannelMask;          /* channels used (internal synth only) */
	    DWORD   dwSupport;             /* functionality supported by driver */
	    GUID    ManufacturerGuid;      /* for extensible MID mapping */
	    GUID    ProductGuid;           /* for extensible PID mapping */
	    GUID    NameGuid;              /* for name lookup in registry */
	}
	
	alias MIDIOUTCAPS2W* PMIDIOUTCAPS2W;
	alias MIDIOUTCAPS2W* NPMIDIOUTCAPS2W;
	alias MIDIOUTCAPS2W* LPMIDIOUTCAPS2W;
	
	version(UNICODE) {
		alias MIDIOUTCAPS2W MIDIOUTCAPS2;
		alias PMIDIOUTCAPS2W PMIDIOUTCAPS2;
		alias NPMIDIOUTCAPS2W NPMIDIOUTCAPS2;
		alias LPMIDIOUTCAPS2W LPMIDIOUTCAPS2;
	}
	else {
		alias MIDIOUTCAPS2A MIDIOUTCAPS2;
		alias PMIDIOUTCAPS2A PMIDIOUTCAPS2;
		alias NPMIDIOUTCAPS2A NPMIDIOUTCAPS2;
		alias LPMIDIOUTCAPS2A LPMIDIOUTCAPS2;
	}
	
	/* flags for wTechnology field of MIDIOUTCAPS align(2) structure */
	const auto MOD_MIDIPORT     = 1  ; /* output port */
	const auto MOD_SYNTH        = 2  ; /* generic internal synth */
	const auto MOD_SQSYNTH      = 3  ; /* square wave internal synth */
	const auto MOD_FMSYNTH      = 4  ; /* FM internal synth */
	const auto MOD_MAPPER       = 5  ; /* MIDI mapper */
	const auto MOD_WAVETABLE    = 6  ; /* hardware wavetable synth */
	const auto MOD_SWSYNTH      = 7  ; /* software synth */
	
	/* flags for dwSupport field of MIDIOUTCAPS align(2) structure */
	const auto MIDICAPS_VOLUME           = 0x0001  ; /* supports volume control */
	const auto MIDICAPS_LRVOLUME         = 0x0002  ; /* separate left-right volume control */
	const auto MIDICAPS_CACHE            = 0x0004;
	
	const auto MIDICAPS_STREAM           = 0x0008  ; /* driver supports midiStreamOut directly */
	
	/* MIDI input device capabilities align(2) structure */
	align(2) struct MIDIINCAPSA {
	    WORD        wMid;                   /* manufacturer ID */
	    WORD        wPid;                   /* product ID */
	    MMVERSION   vDriverVersion;         /* version of the driver */
	    CHAR        szPname[MAXPNAMELEN];   /* product name (NULL terminated string) */
	    DWORD   dwSupport;             /* functionality supported by driver */
	}
	
	alias MIDIINCAPSA* PMIDIINCAPSA;
	alias MIDIINCAPSA* NPMIDIINCAPSA;
	alias MIDIINCAPSA* LPMIDIINCAPSA;
	
	align(2) struct MIDIINCAPSW {
	    WORD        wMid;                   /* manufacturer ID */
	    WORD        wPid;                   /* product ID */
	    MMVERSION   vDriverVersion;         /* version of the driver */
	    WCHAR       szPname[MAXPNAMELEN];   /* product name (NULL terminated string) */
	    DWORD   dwSupport;             /* functionality supported by driver */
	}
	
	alias MIDIINCAPSW* PMIDIINCAPSW;
	alias MIDIINCAPSW* NPMIDIINCAPSW;
	alias MIDIINCAPSW* LPMIDIINCAPSW;
	
	version(UNICODE) {
		alias MIDIINCAPSW MIDIINCAPS;
		alias PMIDIINCAPSW PMIDIINCAPS;
		alias NPMIDIINCAPSW NPMIDIINCAPS;
		alias LPMIDIINCAPSW LPMIDIINCAPS;
	}
	else {
		alias MIDIINCAPSA MIDIINCAPS;
		alias PMIDIINCAPSA PMIDIINCAPS;
		alias NPMIDIINCAPSA NPMIDIINCAPS;
		alias LPMIDIINCAPSA LPMIDIINCAPS;
	}
	
	align(2) struct MIDIINCAPS2A {
	    WORD        wMid;                   /* manufacturer ID */
	    WORD        wPid;                   /* product ID */
	    MMVERSION   vDriverVersion;         /* version of the driver */
	    CHAR[MAXPNAMELEN]        szPname;   /* product name (NULL terminated string) */
	    DWORD       dwSupport;              /* functionality supported by driver */
	    GUID        ManufacturerGuid;       /* for extensible MID mapping */
	    GUID        ProductGuid;            /* for extensible PID mapping */
	    GUID        NameGuid;               /* for name lookup in registry */
	}
	
	alias MIDIINCAPS2A* PMIDIINCAPS2A;
	alias MIDIINCAPS2A* NPMIDIINCAPS2A;
	alias MIDIINCAPS2A* LPMIDIINCAPS2A;
	
	align(2) struct MIDIINCAPS2W {
	    WORD        wMid;                   /* manufacturer ID */
	    WORD        wPid;                   /* product ID */
	    MMVERSION   vDriverVersion;         /* version of the driver */
	    WCHAR[MAXPNAMELEN]       szPname;   /* product name (NULL terminated string) */
	    DWORD       dwSupport;              /* functionality supported by driver */
	    GUID        ManufacturerGuid;       /* for extensible MID mapping */
	    GUID        ProductGuid;            /* for extensible PID mapping */
	    GUID        NameGuid;               /* for name lookup in registry */
	}
	
	alias MIDIINCAPS2W* PMIDIINCAPS2W;
	alias MIDIINCAPS2W* NPMIDIINCAPS2W;
	alias MIDIINCAPS2W* LPMIDIINCAPS2W;
	
	version(UNICODE) {
		alias MIDIINCAPS2W MIDIINCAPS2;
		alias PMIDIINCAPS2W PMIDIINCAPS2;
		alias NPMIDIINCAPS2W NPMIDIINCAPS2;
		alias LPMIDIINCAPS2W LPMIDIINCAPS2;
	}
	else {
		alias MIDIINCAPS2A MIDIINCAPS2;
		alias PMIDIINCAPS2A PMIDIINCAPS2;
		alias NPMIDIINCAPS2A NPMIDIINCAPS2;
		alias LPMIDIINCAPS2A LPMIDIINCAPS2;
	}
	
	/* MIDI data block header */
	align(2) struct MIDIHDR {
	    LPSTR       lpData;               /* pointer to locked data block */
	    DWORD       dwBufferLength;       /* length of data in data block */
	    DWORD       dwBytesRecorded;      /* used for input only */
	    DWORD_PTR   dwUser;               /* for client's use */
	    DWORD       dwFlags;              /* assorted flags (see defines) */
	    MIDIHDR* lpNext;                  /* reserved for driver */
	    DWORD_PTR   reserved;             /* reserved for driver */
	    DWORD       dwOffset;             /* Callback offset into buffer */
	    DWORD_PTR[8]   dwReserved;        /* Reserved for MMSYSTEM */
	}
	
	alias MIDIHDR* PMIDIHDR;
	alias MIDIHDR *NPMIDIHDR;
	alias MIDIHDR* LPMIDIHDR;
	
	align(2) struct MIDIEVENT {
	    DWORD       dwDeltaTime;          /* Ticks since last event */
	    DWORD       dwStreamID;           /* Reserved; must be zero */
	    DWORD       dwEvent;              /* Event type and parameters */
	    DWORD[1]    dwParms;              /* Parameters if this is a long event */
	}
	
	align(2) struct MIDISTRMBUFFVER {
	    DWORD       dwVersion;                  /* Stream buffer format version */
	    DWORD       dwMid;                      /* Manufacturer ID as defined in MMREG.H */
	    DWORD       dwOEMVersion;               /* Manufacturer version for custom ext */
	}
	
	/* flags for dwFlags field of MIDIHDR align(2) structure */
	const auto MHDR_DONE        = 0x00000001       ; /* done bit */
	const auto MHDR_PREPARED    = 0x00000002       ; /* set if header prepared */
	const auto MHDR_INQUEUE     = 0x00000004       ; /* reserved for driver */
	const auto MHDR_ISSTRM      = 0x00000008       ; /* Buffer is stream buffer */
	
	/* */
	/* Type codes which go in the high byte of the event DWORD of a stream buffer */
	/* */
	/* Type codes 00-7F contain parameters within the low 24 bits */
	/* Type codes 80-FF contain a length of their parameter in the low 24 */
	/* bits, followed by their parameter data in the buffer. The event */
	/* DWORD contains the exact byte length; the parm data itself must be */
	/* padded to be an even multiple of 4 bytes long. */
	/* */
	
	const auto MEVT_F_SHORT         = 0x00000000L;
	const auto MEVT_F_LONG          = 0x80000000L;
	const auto MEVT_F_CALLBACK      = 0x40000000L;
	
	template MEVT_EVENTTYPE(DWORD x) {
		const auto MEVT_EVENTTYPE    = (cast(BYTE)(((x)>>24)&0xFF));
	}
	template MEVT_EVENTPARM(DWORD x) {
		const auto MEVT_EVENTPARM    = (cast(DWORD)((x)&0x00FFFFFFL));
	}

	const auto MEVT_SHORTMSG        = (cast(BYTE)0x00)    ; /* parm = shortmsg for midiOutShortMsg */
	const auto MEVT_TEMPO           = (cast(BYTE)0x01)    ; /* parm = new tempo in microsec/qn     */
	const auto MEVT_NOP             = (cast(BYTE)0x02)    ; /* parm = unused; does nothing         */

	/* 0x04-0x7F reserved */

	const auto MEVT_LONGMSG         = (cast(BYTE)0x80)    ; /* parm = bytes to send verbatim       */
	const auto MEVT_COMMENT         = (cast(BYTE)0x82)    ; /* parm = comment data                 */
	const auto MEVT_VERSION         = (cast(BYTE)0x84)    ; /* parm = MIDISTRMBUFFVER align(2) struct       */
	
	/* 0x81-0xFF reserved */
	
	const auto MIDISTRM_ERROR       = (-2);
	
	/* */
	/* Structures and defines for midiStreamProperty */
	/* */
	const auto MIDIPROP_SET         = 0x80000000L;
	const auto MIDIPROP_GET         = 0x40000000L;
	
	/* These are intentionally both non-zero so the app cannot accidentally */
	/* leave the operation off and happen to appear to work due to default */
	/* action. */
	
	const auto MIDIPROP_TIMEDIV     = 0x00000001L;
	const auto MIDIPROP_TEMPO       = 0x00000002L;
	
	align(2) struct MIDIPROPTIMEDIV {
	    DWORD       cbStruct;
	    DWORD       dwTimeDiv;
	}
	
	alias MIDIPROPTIMEDIV* LPMIDIPROPTIMEDIV;
	
	align(2) struct MIDIPROPTEMPO {
	    DWORD       cbStruct;
	    DWORD       dwTempo;
	}

	alias MIDIPROPTEMPO* LPMIDIPROPTEMPO;
	
	/* MIDI function prototypes */
	UINT midiOutGetNumDevs();
	
	MMRESULT midiStreamOpen( LPHMIDISTRM phms, LPUINT puDeviceID, DWORD cMidi, DWORD_PTR dwCallback, DWORD_PTR dwInstance, DWORD fdwOpen);
	MMRESULT midiStreamClose( HMIDISTRM hms);
	
	MMRESULT midiStreamProperty( HMIDISTRM hms, LPBYTE lppropdata, DWORD dwProperty);
	MMRESULT midiStreamPosition( HMIDISTRM hms, LPMMTIME lpmmt, UINT cbmmt);
	
	MMRESULT midiStreamOut( HMIDISTRM hms, LPMIDIHDR pmh, UINT cbmh);
	MMRESULT midiStreamPause( HMIDISTRM hms);
	MMRESULT midiStreamRestart( HMIDISTRM hms);
	MMRESULT midiStreamStop( HMIDISTRM hms);
	
	MMRESULT midiConnect( HMIDI hmi, HMIDIOUT hmo, LPVOID pReserved);
	MMRESULT midiDisconnect( HMIDI hmi, HMIDIOUT hmo, LPVOID pReserved);
	
	MMRESULT midiOutGetDevCapsA( UINT_PTR uDeviceID, LPMIDIOUTCAPSA pmoc, UINT cbmoc);
	MMRESULT midiOutGetDevCapsW( UINT_PTR uDeviceID, LPMIDIOUTCAPSW pmoc, UINT cbmoc);
	
	version(UNICODE) {
		alias midiOutGetDevCapsW midiOutGetDevCaps;
	}
	else {
		alias midiOutGetDevCapsA midiOutGetDevCaps;
	}
	
	MMRESULT midiOutGetVolume( HMIDIOUT hmo, LPDWORD pdwVolume);
	MMRESULT midiOutSetVolume( HMIDIOUT hmo, DWORD dwVolume);
	
	MMRESULT midiOutGetErrorTextA( MMRESULT mmrError, LPSTR pszText, UINT cchText);
	MMRESULT midiOutGetErrorTextW( MMRESULT mmrError, LPWSTR pszText, UINT cchText);
	
	version(UNICODE) {
		alias midiOutGetErrorTextW midiOutGetErrorText;
	}
	else {
		alias midiOutGetErrorTextA midiOutGetErrorText;
	}
	
	MMRESULT midiOutOpen( LPHMIDIOUT phmo, UINT uDeviceID,
	    DWORD_PTR dwCallback, DWORD_PTR dwInstance, DWORD fdwOpen);
	MMRESULT midiOutClose( HMIDIOUT hmo);
	MMRESULT midiOutPrepareHeader( HMIDIOUT hmo, LPMIDIHDR pmh, UINT cbmh);
	MMRESULT midiOutUnprepareHeader(HMIDIOUT hmo, LPMIDIHDR pmh, UINT cbmh);
	MMRESULT midiOutShortMsg( HMIDIOUT hmo, DWORD dwMsg);
	MMRESULT midiOutLongMsg(HMIDIOUT hmo, LPMIDIHDR pmh, UINT cbmh);
	MMRESULT midiOutReset( HMIDIOUT hmo);
	MMRESULT midiOutCachePatches( HMIDIOUT hmo, UINT uBank, LPWORD pwpa, UINT fuCache);
	MMRESULT midiOutCacheDrumPatches( HMIDIOUT hmo, UINT uPatch, LPWORD pwkya, UINT fuCache);
	MMRESULT midiOutGetID( HMIDIOUT hmo, LPUINT puDeviceID);
	
	MMRESULT midiOutMessage( HMIDIOUT hmo, UINT uMsg, DWORD_PTR dw1, DWORD_PTR dw2);
	
	UINT midiInGetNumDevs();
	
	MMRESULT midiInGetDevCapsA( UINT_PTR uDeviceID, LPMIDIINCAPSA pmic, UINT cbmic);
	MMRESULT midiInGetDevCapsW( UINT_PTR uDeviceID, LPMIDIINCAPSW pmic, UINT cbmic);
	
	version(UNICODE) {
		alias midiInGetDevCapsW midiInGetDevCaps;
	}
	else {
		alias midiInGetDevCapsA midiInGetDevCaps;
	}
	
	MMRESULT midiInGetErrorTextA( MMRESULT mmrError, LPSTR pszText, UINT cchText);
	MMRESULT midiInGetErrorTextW( MMRESULT mmrError, LPWSTR pszText, UINT cchText);
	
	version(UNICODE) {
		alias midiInGetErrorTextW midiInGetErrorText;
	}
	else {
		alias midiInGetErrorTextA midiInGetErrorText;
	}
	
	MMRESULT midiInOpen( LPHMIDIIN phmi, UINT uDeviceID,
	        DWORD_PTR dwCallback, DWORD_PTR dwInstance, DWORD fdwOpen);
	MMRESULT midiInClose( HMIDIIN hmi);
	MMRESULT midiInPrepareHeader( HMIDIIN hmi, LPMIDIHDR pmh, UINT cbmh);
	MMRESULT midiInUnprepareHeader( HMIDIIN hmi, LPMIDIHDR pmh, UINT cbmh);
	MMRESULT midiInAddBuffer( HMIDIIN hmi, LPMIDIHDR pmh, UINT cbmh);
	MMRESULT midiInStart( HMIDIIN hmi);
	MMRESULT midiInStop( HMIDIIN hmi);
	MMRESULT midiInReset( HMIDIIN hmi);
	MMRESULT midiInGetID( HMIDIIN hmi, LPUINT puDeviceID);
	
	MMRESULT midiInMessage( HMIDIIN hmi, UINT uMsg, DWORD_PTR dw1, DWORD_PTR dw2);
}

/****************************************************************************

                        Auxiliary audio support

****************************************************************************/
version(MMNOAUX) {
}
else {
	/* device ID for aux device mapper */
	const auto AUX_MAPPER      = (cast(UINT)-1);
	
	/* Auxiliary audio device capabilities align(2) structure */
	align(2) struct AUXCAPSA {
	    WORD        wMid;                /* manufacturer ID */
	    WORD        wPid;                /* product ID */
	    MMVERSION   vDriverVersion;      /* version of the driver */
	    CHAR[MAXPNAMELEN]        szPname;/* product name (NULL terminated string) */
	    WORD        wTechnology;         /* type of device */
	    WORD        wReserved1;          /* padding */
	    DWORD       dwSupport;           /* functionality supported by driver */
	}
	
	alias AUXCAPSA* PAUXCAPSA;
	alias AUXCAPSA* NPAUXCAPSA;
	alias AUXCAPSA* LPAUXCAPSA;
	
	align(2) struct AUXCAPSW {
	    WORD        wMid;                /* manufacturer ID */
	    WORD        wPid;                /* product ID */
	    MMVERSION   vDriverVersion;      /* version of the driver */
	    WCHAR[MAXPNAMELEN]       szPname;/* product name (NULL terminated string) */
	    WORD        wTechnology;         /* type of device */
	    WORD        wReserved1;          /* padding */
	    DWORD       dwSupport;           /* functionality supported by driver */
	}
	
	alias AUXCAPSW* PAUXCAPSW;
	alias AUXCAPSW* NPAUXCAPSW;
	alias AUXCAPSW* LPAUXCAPSW;
	
	version(UNICODE) {
		alias AUXCAPSW AUXCAPS;
		alias PAUXCAPSW PAUXCAPS;
		alias NPAUXCAPSW NPAUXCAPS;
		alias LPAUXCAPSW LPAUXCAPS;
	}
	else {
		alias AUXCAPSA AUXCAPS;
		alias PAUXCAPSA PAUXCAPS;
		alias NPAUXCAPSA NPAUXCAPS;
		alias LPAUXCAPSA LPAUXCAPS;
	}
	
	align(2) struct AUXCAPS2A {
	    WORD        wMid;                /* manufacturer ID */
	    WORD        wPid;                /* product ID */
	    MMVERSION   vDriverVersion;      /* version of the driver */
	    CHAR[MAXPNAMELEN]        szPname;/* product name (NULL terminated string) */
	    WORD        wTechnology;         /* type of device */
	    WORD        wReserved1;          /* padding */
	    DWORD       dwSupport;           /* functionality supported by driver */
	    GUID        ManufacturerGuid;    /* for extensible MID mapping */
	    GUID        ProductGuid;         /* for extensible PID mapping */
	    GUID        NameGuid;            /* for name lookup in registry */
	}
	
	alias AUXCAPS2A* PAUXCAPS2A;
	alias AUXCAPS2A* NPAUXCAPS2A;
	alias AUXCAPS2A* LPAUXCAPS2A;
	
	align(2) struct AUXCAPS2W {
	    WORD        wMid;                /* manufacturer ID */
	    WORD        wPid;                /* product ID */
	    MMVERSION   vDriverVersion;      /* version of the driver */
	    WCHAR[MAXPNAMELEN]       szPname;/* product name (NULL terminated string) */
	    WORD        wTechnology;         /* type of device */
	    WORD        wReserved1;          /* padding */
	    DWORD       dwSupport;           /* functionality supported by driver */
	    GUID        ManufacturerGuid;    /* for extensible MID mapping */
	    GUID        ProductGuid;         /* for extensible PID mapping */
	    GUID        NameGuid;            /* for name lookup in registry */
	}
	
	alias AUXCAPS2W* PAUXCAPS2W;
	alias AUXCAPS2W* NPAUXCAPS2W;
	alias AUXCAPS2W* LPAUXCAPS2W;
	
	version(UNICODE) {
		alias AUXCAPS2W AUXCAPS2;
		alias PAUXCAPS2W PAUXCAPS2;
		alias NPAUXCAPS2W NPAUXCAPS2;
		alias LPAUXCAPS2W LPAUXCAPS2;
	}
	else {
		alias AUXCAPS2A AUXCAPS2;
		alias PAUXCAPS2A PAUXCAPS2;
		alias NPAUXCAPS2A NPAUXCAPS2;
		alias LPAUXCAPS2A LPAUXCAPS2;
	}
	
	/* flags for wTechnology field in AUXCAPS align(2) structure */
	const auto AUXCAPS_CDAUDIO     = 1       ; /* audio from internal CD-ROM drive */
	const auto AUXCAPS_AUXIN       = 2       ; /* audio from auxiliary input jacks */
	
	/* flags for dwSupport field in AUXCAPS align(2) structure */
	const auto AUXCAPS_VOLUME           = 0x0001  ; /* supports volume control */
	const auto AUXCAPS_LRVOLUME         = 0x0002  ; /* separate left-right volume control */
	
	/* auxiliary audio function prototypes */
	UINT auxGetNumDevs();
	
	MMRESULT auxGetDevCapsA( UINT_PTR uDeviceID, LPAUXCAPSA pac, UINT cbac);
	MMRESULT auxGetDevCapsW( UINT_PTR uDeviceID, LPAUXCAPSW pac, UINT cbac);
	
	version(UNICODE) {
		alias auxGetDevCapsW auxGetDevCaps;
	}
	else {
		alias auxGetDevCapsA auxGetDevCaps;
	}
	
	MMRESULT auxSetVolume( UINT uDeviceID, DWORD dwVolume);
	MMRESULT auxGetVolume( UINT uDeviceID, LPDWORD pdwVolume);

	MMRESULT auxOutMessage( UINT uDeviceID, UINT uMsg, DWORD_PTR dw1, DWORD_PTR dw2);
}

/****************************************************************************

                            Mixer Support

****************************************************************************/
version(MMNOMIXER) {
}
else {
	alias HANDLE HMIXEROBJ;
	alias HMIXEROBJ *LPHMIXEROBJ;
	
	alias HANDLE HMIXER;
	alias HMIXER     *LPHMIXER;
	
	const auto MIXER_SHORT_NAME_CHARS    = 16;
	const auto MIXER_LONG_NAME_CHARS     = 64;
	
	/* */
	/*  MMRESULT error return values specific to the mixer API */
	/* */
	/* */
	const auto MIXERR_INVALLINE             = (MIXERR_BASE + 0);
	const auto MIXERR_INVALCONTROL          = (MIXERR_BASE + 1);
	const auto MIXERR_INVALVALUE            = (MIXERR_BASE + 2);
	const auto MIXERR_LASTERROR             = (MIXERR_BASE + 2);
	
	
	const auto MIXER_OBJECTF_HANDLE     = 0x80000000L;
	const auto MIXER_OBJECTF_MIXER      = 0x00000000L;
	const auto MIXER_OBJECTF_HMIXER     = (MIXER_OBJECTF_HANDLE|MIXER_OBJECTF_MIXER);
	const auto MIXER_OBJECTF_WAVEOUT    = 0x10000000L;
	const auto MIXER_OBJECTF_HWAVEOUT   = (MIXER_OBJECTF_HANDLE|MIXER_OBJECTF_WAVEOUT);
	const auto MIXER_OBJECTF_WAVEIN     = 0x20000000L;
	const auto MIXER_OBJECTF_HWAVEIN    = (MIXER_OBJECTF_HANDLE|MIXER_OBJECTF_WAVEIN);
	const auto MIXER_OBJECTF_MIDIOUT    = 0x30000000L;
	const auto MIXER_OBJECTF_HMIDIOUT   = (MIXER_OBJECTF_HANDLE|MIXER_OBJECTF_MIDIOUT);
	const auto MIXER_OBJECTF_MIDIIN     = 0x40000000L;
	const auto MIXER_OBJECTF_HMIDIIN    = (MIXER_OBJECTF_HANDLE|MIXER_OBJECTF_MIDIIN);
	const auto MIXER_OBJECTF_AUX        = 0x50000000L;
	
	
	UINT mixerGetNumDevs();
	
	align(2) struct MIXERCAPSA {
	    WORD            wMid;                   /* manufacturer id */
	    WORD            wPid;                   /* product id */
	    MMVERSION       vDriverVersion;         /* version of the driver */
	    CHAR[MAXPNAMELEN]            szPname;   /* product name */
	    DWORD           fdwSupport;             /* misc. support bits */
	    DWORD           cDestinations;          /* count of destinations */
	}
	
	alias MIXERCAPSA* PMIXERCAPSA;
	alias MIXERCAPSA* LPMIXERCAPSA;
	align(2) struct MIXERCAPSW {
	    WORD            wMid;                   /* manufacturer id */
	    WORD            wPid;                   /* product id */
	    MMVERSION       vDriverVersion;         /* version of the driver */
	    WCHAR[MAXPNAMELEN]           szPname;   /* product name */
	    DWORD           fdwSupport;             /* misc. support bits */
	    DWORD           cDestinations;          /* count of destinations */
	}
	
	alias MIXERCAPSW* PMIXERCAPSW;
	alias MIXERCAPSW* LPMIXERCAPSW;
	
	version(UNICODE) {
		alias MIXERCAPSW MIXERCAPS;
		alias PMIXERCAPSW PMIXERCAPS;
		alias LPMIXERCAPSW LPMIXERCAPS;
	}
	else {
		alias MIXERCAPSA MIXERCAPS;
		alias PMIXERCAPSA PMIXERCAPS;
		alias LPMIXERCAPSA LPMIXERCAPS;
	}
	align(2) struct MIXERCAPS2A {
	    WORD            wMid;                   /* manufacturer id */
	    WORD            wPid;                   /* product id */
	    MMVERSION       vDriverVersion;         /* version of the driver */
	    CHAR[MAXPNAMELEN]            szPname;   /* product name */
	    DWORD           fdwSupport;             /* misc. support bits */
	    DWORD           cDestinations;          /* count of destinations */
	    GUID            ManufacturerGuid;       /* for extensible MID mapping */
	    GUID            ProductGuid;            /* for extensible PID mapping */
	    GUID            NameGuid;               /* for name lookup in registry */
	}
	
	alias MIXERCAPS2A* PMIXERCAPS2A;
	alias MIXERCAPS2A* LPMIXERCAPS2A;
	align(2) struct MIXERCAPS2W {
	    WORD            wMid;                   /* manufacturer id */
	    WORD            wPid;                   /* product id */
	    MMVERSION       vDriverVersion;         /* version of the driver */
	    WCHAR[MAXPNAMELEN]           szPname;   /* product name */
	    DWORD           fdwSupport;             /* misc. support bits */
	    DWORD           cDestinations;          /* count of destinations */
	    GUID            ManufacturerGuid;       /* for extensible MID mapping */
	    GUID            ProductGuid;            /* for extensible PID mapping */
	    GUID            NameGuid;               /* for name lookup in registry */
	}
	
	alias MIXERCAPS2W* PMIXERCAPS2W;
	alias MIXERCAPS2W* LPMIXERCAPS2W;
	
	version(UNICODE) {
		alias MIXERCAPS2W MIXERCAPS2;
		alias PMIXERCAPS2W PMIXERCAPS2;
		alias LPMIXERCAPS2W LPMIXERCAPS2;
	}
	else {
		alias MIXERCAPS2A MIXERCAPS2;
		alias PMIXERCAPS2A PMIXERCAPS2;
		alias LPMIXERCAPS2A LPMIXERCAPS2;
	}
	
	MMRESULT mixerGetDevCapsA( UINT_PTR uMxId, LPMIXERCAPSA pmxcaps, UINT cbmxcaps);
	MMRESULT mixerGetDevCapsW( UINT_PTR uMxId, LPMIXERCAPSW pmxcaps, UINT cbmxcaps);
	
	version(UNICODE) {
		alias mixerGetDevCapsW mixerGetDevCaps;
	}
	else {
		alias mixerGetDevCapsA mixerGetDevCaps;
	}
	
	MMRESULT mixerOpen( LPHMIXER phmx, UINT uMxId, DWORD_PTR dwCallback, DWORD_PTR dwInstance, DWORD fdwOpen);
	MMRESULT mixerClose( HMIXER hmx);
	
	DWORD mixerMessage( HMIXER hmx, UINT uMsg, DWORD_PTR dwParam1, DWORD_PTR dwParam2);
	
	align(2) struct MIXERLINEA {
	    DWORD       cbStruct;               /* size of MIXERLINE align(2) structure */
	    DWORD       dwDestination;          /* zero based destination index */
	    DWORD       dwSource;               /* zero based source index (if source) */
	    DWORD       dwLineID;               /* unique line id for mixer device */
	    DWORD       fdwLine;                /* state/information about line */
	    DWORD_PTR   dwUser;                 /* driver specific information */
	    DWORD       dwComponentType;        /* component type line connects to */
	    DWORD       cChannels;              /* number of channels line supports */
	    DWORD       cConnections;           /* number of connections [possible] */
	    DWORD       cControls;              /* number of controls at this line */
	    CHAR[MIXER_SHORT_NAME_CHARS]        szShortName;
	    CHAR[MIXER_LONG_NAME_CHARS]        szName;
	    align(2) struct _inner_struct {
	        DWORD       dwType;                 /* MIXERLINE_TARGETTYPE_xxxx */
	        DWORD       dwDeviceID;             /* target device ID of device type */
	        WORD        wMid;                   /* of target device */
	        WORD        wPid;                   /*      " */
	        MMVERSION   vDriverVersion;         /*      " */
	        CHAR[MAXPNAMELEN]        szPname;   /*      " */
	    }
		_inner_struct Target;
	}
	
	alias MIXERLINEA* PMIXERLINEA;
	alias MIXERLINEA* LPMIXERLINEA;
	align(2) struct MIXERLINEW {
	    DWORD       cbStruct;               /* size of MIXERLINE align(2) structure */
	    DWORD       dwDestination;          /* zero based destination index */
	    DWORD       dwSource;               /* zero based source index (if source) */
	    DWORD       dwLineID;               /* unique line id for mixer device */
	    DWORD       fdwLine;                /* state/information about line */
	    DWORD_PTR   dwUser;                 /* driver specific information */
	    DWORD       dwComponentType;        /* component type line connects to */
	    DWORD       cChannels;              /* number of channels line supports */
	    DWORD       cConnections;           /* number of connections [possible] */
	    DWORD       cControls;              /* number of controls at this line */
	    WCHAR[MIXER_SHORT_NAME_CHARS]       szShortName;
	    WCHAR[MIXER_LONG_NAME_CHARS]       szName;
	    align(2) struct _inner_struct {
	        DWORD       dwType;                 /* MIXERLINE_TARGETTYPE_xxxx */
	        DWORD       dwDeviceID;             /* target device ID of device type */
	        WORD        wMid;                   /* of target device */
	        WORD        wPid;                   /*      " */
	        MMVERSION   vDriverVersion;         /*      " */
	        WCHAR[MAXPNAMELEN]       szPname;   /*      " */
	    }
		_inner_struct Target;
	}
	
	alias MIXERLINEW* PMIXERLINEW;
	alias MIXERLINEW* LPMIXERLINEW;
	
	version(UNICODE) {
		alias MIXERLINEW MIXERLINE;
		alias PMIXERLINEW PMIXERLINE;
		alias LPMIXERLINEW LPMIXERLINE;
	}
	else {
		alias MIXERLINEA MIXERLINE;
		alias PMIXERLINEA PMIXERLINE;
		alias LPMIXERLINEA LPMIXERLINE;
	}
	
	/* */
	/*  MIXERLINE.fdwLine */
	/* */
	/* */
	const auto MIXERLINE_LINEF_ACTIVE               = 0x00000001L;
	const auto MIXERLINE_LINEF_DISCONNECTED         = 0x00008000L;
	const auto MIXERLINE_LINEF_SOURCE               = 0x80000000L;
	
	
	/* */
	/*  MIXERLINE.dwComponentType */
	/* */
	/*  component types for destinations and sources */
	/* */
	/* */
	const auto MIXERLINE_COMPONENTTYPE_DST_FIRST        = 0x00000000L;
	const auto MIXERLINE_COMPONENTTYPE_DST_UNDEFINED    = (MIXERLINE_COMPONENTTYPE_DST_FIRST + 0);
	const auto MIXERLINE_COMPONENTTYPE_DST_DIGITAL      = (MIXERLINE_COMPONENTTYPE_DST_FIRST + 1);
	const auto MIXERLINE_COMPONENTTYPE_DST_LINE         = (MIXERLINE_COMPONENTTYPE_DST_FIRST + 2);
	const auto MIXERLINE_COMPONENTTYPE_DST_MONITOR      = (MIXERLINE_COMPONENTTYPE_DST_FIRST + 3);
	const auto MIXERLINE_COMPONENTTYPE_DST_SPEAKERS     = (MIXERLINE_COMPONENTTYPE_DST_FIRST + 4);
	const auto MIXERLINE_COMPONENTTYPE_DST_HEADPHONES   = (MIXERLINE_COMPONENTTYPE_DST_FIRST + 5);
	const auto MIXERLINE_COMPONENTTYPE_DST_TELEPHONE    = (MIXERLINE_COMPONENTTYPE_DST_FIRST + 6);
	const auto MIXERLINE_COMPONENTTYPE_DST_WAVEIN       = (MIXERLINE_COMPONENTTYPE_DST_FIRST + 7);
	const auto MIXERLINE_COMPONENTTYPE_DST_VOICEIN      = (MIXERLINE_COMPONENTTYPE_DST_FIRST + 8);
	const auto MIXERLINE_COMPONENTTYPE_DST_LAST         = (MIXERLINE_COMPONENTTYPE_DST_FIRST + 8);
	
	const auto MIXERLINE_COMPONENTTYPE_SRC_FIRST        = 0x00001000L;
	const auto MIXERLINE_COMPONENTTYPE_SRC_UNDEFINED    = (MIXERLINE_COMPONENTTYPE_SRC_FIRST + 0);
	const auto MIXERLINE_COMPONENTTYPE_SRC_DIGITAL      = (MIXERLINE_COMPONENTTYPE_SRC_FIRST + 1);
	const auto MIXERLINE_COMPONENTTYPE_SRC_LINE         = (MIXERLINE_COMPONENTTYPE_SRC_FIRST + 2);
	const auto MIXERLINE_COMPONENTTYPE_SRC_MICROPHONE   = (MIXERLINE_COMPONENTTYPE_SRC_FIRST + 3);
	const auto MIXERLINE_COMPONENTTYPE_SRC_SYNTHESIZER  = (MIXERLINE_COMPONENTTYPE_SRC_FIRST + 4);
	const auto MIXERLINE_COMPONENTTYPE_SRC_COMPACTDISC  = (MIXERLINE_COMPONENTTYPE_SRC_FIRST + 5);
	const auto MIXERLINE_COMPONENTTYPE_SRC_TELEPHONE    = (MIXERLINE_COMPONENTTYPE_SRC_FIRST + 6);
	const auto MIXERLINE_COMPONENTTYPE_SRC_PCSPEAKER    = (MIXERLINE_COMPONENTTYPE_SRC_FIRST + 7);
	const auto MIXERLINE_COMPONENTTYPE_SRC_WAVEOUT      = (MIXERLINE_COMPONENTTYPE_SRC_FIRST + 8);
	const auto MIXERLINE_COMPONENTTYPE_SRC_AUXILIARY    = (MIXERLINE_COMPONENTTYPE_SRC_FIRST + 9);
	const auto MIXERLINE_COMPONENTTYPE_SRC_ANALOG       = (MIXERLINE_COMPONENTTYPE_SRC_FIRST + 10);
	const auto MIXERLINE_COMPONENTTYPE_SRC_LAST         = (MIXERLINE_COMPONENTTYPE_SRC_FIRST + 10);
	
	
	/* */
	/*  MIXERLINE.Target.dwType */
	/* */
	/* */
	const auto MIXERLINE_TARGETTYPE_UNDEFINED       = 0;
	const auto MIXERLINE_TARGETTYPE_WAVEOUT         = 1;
	const auto MIXERLINE_TARGETTYPE_WAVEIN          = 2;
	const auto MIXERLINE_TARGETTYPE_MIDIOUT         = 3;
	const auto MIXERLINE_TARGETTYPE_MIDIIN          = 4;
	const auto MIXERLINE_TARGETTYPE_AUX             = 5;
	
	MMRESULT mixerGetLineInfoA( HMIXEROBJ hmxobj, LPMIXERLINEA pmxl, DWORD fdwInfo);
	MMRESULT mixerGetLineInfoW( HMIXEROBJ hmxobj, LPMIXERLINEW pmxl, DWORD fdwInfo);
	
	version(UNICODE) {
		alias mixerGetLineInfoW mixerGetLineInfo;
	}
	else {
		alias mixerGetLineInfoA mixerGetLineInfo;
	}
	
	const auto MIXER_GETLINEINFOF_DESTINATION       = 0x00000000L;
	const auto MIXER_GETLINEINFOF_SOURCE            = 0x00000001L;
	const auto MIXER_GETLINEINFOF_LINEID            = 0x00000002L;
	const auto MIXER_GETLINEINFOF_COMPONENTTYPE     = 0x00000003L;
	const auto MIXER_GETLINEINFOF_TARGETTYPE        = 0x00000004L;
	
	const auto MIXER_GETLINEINFOF_QUERYMASK         = 0x0000000FL;
	
	MMRESULT mixerGetID( HMIXEROBJ hmxobj, UINT *puMxId, DWORD fdwId);
	
	
	/* */
	/*  MIXERCONTROL */
	/* */
	/* */
	align(2) struct MIXERCONTROLA {
	    DWORD           cbStruct;           /* size in bytes of MIXERCONTROL */
	    DWORD           dwControlID;        /* unique control id for mixer device */
	    DWORD           dwControlType;      /* MIXERCONTROL_CONTROLTYPE_xxx */
	    DWORD           fdwControl;         /* MIXERCONTROL_CONTROLF_xxx */
	    DWORD           cMultipleItems;     /* if MIXERCONTROL_CONTROLF_MULTIPLE set */
	    CHAR[MIXER_SHORT_NAME_CHARS]            szShortName;
	    CHAR[MIXER_LONG_NAME_CHARS]            szName;
	    align(2) union _inner_union {
	        align(2) struct _inner_struct {
	            LONG    lMinimum;           /* signed minimum for this control */
	            LONG    lMaximum;           /* signed maximum for this control */
	        }
	        _inner_struct Signed;
	        align(2) struct _inner_struct2 {
	            DWORD   dwMinimum;          /* unsigned minimum for this control */
	            DWORD   dwMaximum;          /* unsigned maximum for this control */
	        }
	        _inner_struct2 Unsigned;
	        DWORD       dwReserved[6];
	    }
		_inner_union Bounds;
	    align(2) union _inner_union2 {
	        DWORD       cSteps;             /* # of steps between min & max */
	        DWORD       cbCustomData;       /* size in bytes of custom data */
	        DWORD[6]    dwReserved;         /* !!! needed? we have cbStruct.... */
	    }
		_inner_union2 Metrics;
	}
	
	alias MIXERCONTROLA* PMIXERCONTROLA;
	alias MIXERCONTROLA* LPMIXERCONTROLA;
	align(2) struct MIXERCONTROLW {
	    DWORD           cbStruct;           /* size in bytes of MIXERCONTROL */
	    DWORD           dwControlID;        /* unique control id for mixer device */
	    DWORD           dwControlType;      /* MIXERCONTROL_CONTROLTYPE_xxx */
	    DWORD           fdwControl;         /* MIXERCONTROL_CONTROLF_xxx */
	    DWORD           cMultipleItems;     /* if MIXERCONTROL_CONTROLF_MULTIPLE set */
	    WCHAR           szShortName[MIXER_SHORT_NAME_CHARS];
	    WCHAR           szName[MIXER_LONG_NAME_CHARS];
	    align(2) union _inner_union {
	        align(2) struct _inner_struct {
	            LONG    lMinimum;           /* signed minimum for this control */
	            LONG    lMaximum;           /* signed maximum for this control */
	        }
	        _inner_struct Signed;
	        align(2) struct _inner_struct2 {
	            DWORD   dwMinimum;          /* unsigned minimum for this control */
	            DWORD   dwMaximum;          /* unsigned maximum for this control */
	        }
	        _inner_struct2 Unsigned;
	        DWORD[6]       dwReserved;
	    }
		_inner_union Bounds;
	    align(2) union _inner_union2 {
	        DWORD       cSteps;             /* # of steps between min & max */
	        DWORD       cbCustomData;       /* size in bytes of custom data */
	        DWORD[6]       dwReserved;      /* !!! needed? we have cbStruct.... */
	    }
		_inner_union2 Metrics;
	}
	
	alias MIXERCONTROLW* PMIXERCONTROLW;
	alias MIXERCONTROLW* LPMIXERCONTROLW;
	
	version(UNICODE) {
		alias MIXERCONTROLW MIXERCONTROL;
		alias PMIXERCONTROLW PMIXERCONTROL;
		alias LPMIXERCONTROLW LPMIXERCONTROL;
	}
	else {
		alias MIXERCONTROLA MIXERCONTROL;
		alias PMIXERCONTROLA PMIXERCONTROL;
		alias LPMIXERCONTROLA LPMIXERCONTROL;
	}
	
	/* */
	/*  MIXERCONTROL.fdwControl */
	/* */
	/* */
	const auto MIXERCONTROL_CONTROLF_UNIFORM    = 0x00000001L;
	const auto MIXERCONTROL_CONTROLF_MULTIPLE   = 0x00000002L;
	const auto MIXERCONTROL_CONTROLF_DISABLED   = 0x80000000L;
	
	
	/* */
	/*  MIXERCONTROL_CONTROLTYPE_xxx building block defines */
	/* */
	/* */
	const auto MIXERCONTROL_CT_CLASS_MASK           = 0xF0000000L;
	const auto MIXERCONTROL_CT_CLASS_CUSTOM         = 0x00000000L;
	const auto MIXERCONTROL_CT_CLASS_METER          = 0x10000000L;
	const auto MIXERCONTROL_CT_CLASS_SWITCH         = 0x20000000L;
	const auto MIXERCONTROL_CT_CLASS_NUMBER         = 0x30000000L;
	const auto MIXERCONTROL_CT_CLASS_SLIDER         = 0x40000000L;
	const auto MIXERCONTROL_CT_CLASS_FADER          = 0x50000000L;
	const auto MIXERCONTROL_CT_CLASS_TIME           = 0x60000000L;
	const auto MIXERCONTROL_CT_CLASS_LIST           = 0x70000000L;
	
	
	const auto MIXERCONTROL_CT_SUBCLASS_MASK        = 0x0F000000L;
	
	const auto MIXERCONTROL_CT_SC_SWITCH_BOOLEAN    = 0x00000000L;
	const auto MIXERCONTROL_CT_SC_SWITCH_BUTTON     = 0x01000000L;
	
	const auto MIXERCONTROL_CT_SC_METER_POLLED      = 0x00000000L;
	
	const auto MIXERCONTROL_CT_SC_TIME_MICROSECS    = 0x00000000L;
	const auto MIXERCONTROL_CT_SC_TIME_MILLISECS    = 0x01000000L;
	
	const auto MIXERCONTROL_CT_SC_LIST_SINGLE       = 0x00000000L;
	const auto MIXERCONTROL_CT_SC_LIST_MULTIPLE     = 0x01000000L;
	
	
	const auto MIXERCONTROL_CT_UNITS_MASK           = 0x00FF0000L;
	const auto MIXERCONTROL_CT_UNITS_CUSTOM         = 0x00000000L;
	const auto MIXERCONTROL_CT_UNITS_BOOLEAN        = 0x00010000L;
	const auto MIXERCONTROL_CT_UNITS_SIGNED         = 0x00020000L;
	const auto MIXERCONTROL_CT_UNITS_UNSIGNED       = 0x00030000L;
	const auto MIXERCONTROL_CT_UNITS_DECIBELS       = 0x00040000L ; /* in 10ths */
	const auto MIXERCONTROL_CT_UNITS_PERCENT        = 0x00050000L ; /* in 10ths */
	
	
	/* */
	/*  Commonly used control types for specifying MIXERCONTROL.dwControlType */
	/* */
	
	const auto MIXERCONTROL_CONTROLTYPE_CUSTOM          = (MIXERCONTROL_CT_CLASS_CUSTOM | MIXERCONTROL_CT_UNITS_CUSTOM);
	const auto MIXERCONTROL_CONTROLTYPE_BOOLEANMETER    = (MIXERCONTROL_CT_CLASS_METER | MIXERCONTROL_CT_SC_METER_POLLED | MIXERCONTROL_CT_UNITS_BOOLEAN);
	const auto MIXERCONTROL_CONTROLTYPE_SIGNEDMETER     = (MIXERCONTROL_CT_CLASS_METER | MIXERCONTROL_CT_SC_METER_POLLED | MIXERCONTROL_CT_UNITS_SIGNED);
	const auto MIXERCONTROL_CONTROLTYPE_PEAKMETER       = (MIXERCONTROL_CONTROLTYPE_SIGNEDMETER + 1);
	const auto MIXERCONTROL_CONTROLTYPE_UNSIGNEDMETER   = (MIXERCONTROL_CT_CLASS_METER | MIXERCONTROL_CT_SC_METER_POLLED | MIXERCONTROL_CT_UNITS_UNSIGNED);
	const auto MIXERCONTROL_CONTROLTYPE_BOOLEAN         = (MIXERCONTROL_CT_CLASS_SWITCH | MIXERCONTROL_CT_SC_SWITCH_BOOLEAN | MIXERCONTROL_CT_UNITS_BOOLEAN);
	const auto MIXERCONTROL_CONTROLTYPE_ONOFF           = (MIXERCONTROL_CONTROLTYPE_BOOLEAN + 1);
	const auto MIXERCONTROL_CONTROLTYPE_MUTE            = (MIXERCONTROL_CONTROLTYPE_BOOLEAN + 2);
	const auto MIXERCONTROL_CONTROLTYPE_MONO            = (MIXERCONTROL_CONTROLTYPE_BOOLEAN + 3);
	const auto MIXERCONTROL_CONTROLTYPE_LOUDNESS        = (MIXERCONTROL_CONTROLTYPE_BOOLEAN + 4);
	const auto MIXERCONTROL_CONTROLTYPE_STEREOENH       = (MIXERCONTROL_CONTROLTYPE_BOOLEAN + 5);
	const auto MIXERCONTROL_CONTROLTYPE_BASS_BOOST      = (MIXERCONTROL_CONTROLTYPE_BOOLEAN + 0x00002277);
	const auto MIXERCONTROL_CONTROLTYPE_BUTTON          = (MIXERCONTROL_CT_CLASS_SWITCH | MIXERCONTROL_CT_SC_SWITCH_BUTTON | MIXERCONTROL_CT_UNITS_BOOLEAN);
	const auto MIXERCONTROL_CONTROLTYPE_DECIBELS        = (MIXERCONTROL_CT_CLASS_NUMBER | MIXERCONTROL_CT_UNITS_DECIBELS);
	const auto MIXERCONTROL_CONTROLTYPE_SIGNED          = (MIXERCONTROL_CT_CLASS_NUMBER | MIXERCONTROL_CT_UNITS_SIGNED);
	const auto MIXERCONTROL_CONTROLTYPE_UNSIGNED        = (MIXERCONTROL_CT_CLASS_NUMBER | MIXERCONTROL_CT_UNITS_UNSIGNED);
	const auto MIXERCONTROL_CONTROLTYPE_PERCENT         = (MIXERCONTROL_CT_CLASS_NUMBER | MIXERCONTROL_CT_UNITS_PERCENT);
	const auto MIXERCONTROL_CONTROLTYPE_SLIDER          = (MIXERCONTROL_CT_CLASS_SLIDER | MIXERCONTROL_CT_UNITS_SIGNED);
	const auto MIXERCONTROL_CONTROLTYPE_PAN             = (MIXERCONTROL_CONTROLTYPE_SLIDER + 1);
	const auto MIXERCONTROL_CONTROLTYPE_QSOUNDPAN       = (MIXERCONTROL_CONTROLTYPE_SLIDER + 2);
	const auto MIXERCONTROL_CONTROLTYPE_FADER           = (MIXERCONTROL_CT_CLASS_FADER | MIXERCONTROL_CT_UNITS_UNSIGNED);
	const auto MIXERCONTROL_CONTROLTYPE_VOLUME          = (MIXERCONTROL_CONTROLTYPE_FADER + 1);
	const auto MIXERCONTROL_CONTROLTYPE_BASS            = (MIXERCONTROL_CONTROLTYPE_FADER + 2);
	const auto MIXERCONTROL_CONTROLTYPE_TREBLE          = (MIXERCONTROL_CONTROLTYPE_FADER + 3);
	const auto MIXERCONTROL_CONTROLTYPE_EQUALIZER       = (MIXERCONTROL_CONTROLTYPE_FADER + 4);
	const auto MIXERCONTROL_CONTROLTYPE_SINGLESELECT    = (MIXERCONTROL_CT_CLASS_LIST | MIXERCONTROL_CT_SC_LIST_SINGLE | MIXERCONTROL_CT_UNITS_BOOLEAN);
	const auto MIXERCONTROL_CONTROLTYPE_MUX             = (MIXERCONTROL_CONTROLTYPE_SINGLESELECT + 1);
	const auto MIXERCONTROL_CONTROLTYPE_MULTIPLESELECT  = (MIXERCONTROL_CT_CLASS_LIST | MIXERCONTROL_CT_SC_LIST_MULTIPLE | MIXERCONTROL_CT_UNITS_BOOLEAN);
	const auto MIXERCONTROL_CONTROLTYPE_MIXER           = (MIXERCONTROL_CONTROLTYPE_MULTIPLESELECT + 1);
	const auto MIXERCONTROL_CONTROLTYPE_MICROTIME       = (MIXERCONTROL_CT_CLASS_TIME | MIXERCONTROL_CT_SC_TIME_MICROSECS | MIXERCONTROL_CT_UNITS_UNSIGNED);
	const auto MIXERCONTROL_CONTROLTYPE_MILLITIME       = (MIXERCONTROL_CT_CLASS_TIME | MIXERCONTROL_CT_SC_TIME_MILLISECS | MIXERCONTROL_CT_UNITS_UNSIGNED);
	
	/* */
	/*  MIXERLINECONTROLS */
	/* */
	align(2) struct MIXERLINECONTROLSA {
	    DWORD           cbStruct;       /* size in bytes of MIXERLINECONTROLS */
	    DWORD           dwLineID;       /* line id (from MIXERLINE.dwLineID) */
	    align(2) union _inner_union {
	        DWORD       dwControlID;    /* MIXER_GETLINECONTROLSF_ONEBYID */
	        DWORD       dwControlType;  /* MIXER_GETLINECONTROLSF_ONEBYTYPE */
	    }
	    _inner_union fields;
	    DWORD           cControls;      /* count of controls pmxctrl points to */
	    DWORD           cbmxctrl;       /* size in bytes of _one_ MIXERCONTROL */
	    LPMIXERCONTROLA pamxctrl;       /* pointer to first MIXERCONTROL array */
	}
	
	alias MIXERLINECONTROLSA* PMIXERLINECONTROLSA;
	alias MIXERLINECONTROLSA* LPMIXERLINECONTROLSA;
	align(2) struct MIXERLINECONTROLSW {
	    DWORD           cbStruct;       /* size in bytes of MIXERLINECONTROLS */
	    DWORD           dwLineID;       /* line id (from MIXERLINE.dwLineID) */
	    align(2) union _inner_union {
	        DWORD       dwControlID;    /* MIXER_GETLINECONTROLSF_ONEBYID */
	        DWORD       dwControlType;  /* MIXER_GETLINECONTROLSF_ONEBYTYPE */
	    }
	    _inner_union fields;
	    DWORD           cControls;      /* count of controls pmxctrl points to */
	    DWORD           cbmxctrl;       /* size in bytes of _one_ MIXERCONTROL */
	    LPMIXERCONTROLW pamxctrl;       /* pointer to first MIXERCONTROL array */
	}
	
	alias MIXERLINECONTROLSW* PMIXERLINECONTROLSW;
	alias MIXERLINECONTROLSW* LPMIXERLINECONTROLSW;
	
	version(UNICODE) {
		alias MIXERLINECONTROLSW MIXERLINECONTROLS;
		alias PMIXERLINECONTROLSW PMIXERLINECONTROLS;
		alias LPMIXERLINECONTROLSW LPMIXERLINECONTROLS;
	}
	else {
		alias MIXERLINECONTROLSA MIXERLINECONTROLS;
		alias PMIXERLINECONTROLSA PMIXERLINECONTROLS;
		alias LPMIXERLINECONTROLSA LPMIXERLINECONTROLS;
	}
	
	/* */
	/* */
	/* */
	MMRESULT mixerGetLineControlsA( HMIXEROBJ hmxobj, LPMIXERLINECONTROLSA pmxlc, DWORD fdwControls);
	MMRESULT mixerGetLineControlsW( HMIXEROBJ hmxobj, LPMIXERLINECONTROLSW pmxlc, DWORD fdwControls);
	
	version(UNICODE) {
		alias mixerGetLineControlsW mixerGetLineControls;
	}
	else {
		alias mixerGetLineControlsA mixerGetLineControls;
	}
	
	const auto MIXER_GETLINECONTROLSF_ALL           = 0x00000000L;
	const auto MIXER_GETLINECONTROLSF_ONEBYID       = 0x00000001L;
	const auto MIXER_GETLINECONTROLSF_ONEBYTYPE     = 0x00000002L;
	
	const auto MIXER_GETLINECONTROLSF_QUERYMASK     = 0x0000000FL;
	
	align(2) struct MIXERCONTROLDETAILS {
	    DWORD           cbStruct;       /* size in bytes of MIXERCONTROLDETAILS */
	    DWORD           dwControlID;    /* control id to get/set details on */
	    DWORD           cChannels;      /* number of channels in paDetails array */
	    align(2) union _inner_union {
	        HWND        hwndOwner;      /* for MIXER_SETCONTROLDETAILSF_CUSTOM */
	        DWORD       cMultipleItems; /* if _MULTIPLE, the number of items per channel */
	    }
	    _inner_union fields;
	    DWORD           cbDetails;      /* size of _one_ details_XX align(2) struct */
	    LPVOID          paDetails;      /* pointer to array of details_XX align(2) structs */
	}
	
	alias MIXERCONTROLDETAILS* PMIXERCONTROLDETAILS;
	alias MIXERCONTROLDETAILS* LPMIXERCONTROLDETAILS;
	
	
	/* */
	/*  MIXER_GETCONTROLDETAILSF_LISTTEXT */
	/* */
	/* */
	align(2) struct MIXERCONTROLDETAILS_LISTTEXTA {
	    DWORD           dwParam1;
	    DWORD           dwParam2;
	    CHAR[MIXER_LONG_NAME_CHARS]            szName;
	}
	
	alias MIXERCONTROLDETAILS_LISTTEXTA* PMIXERCONTROLDETAILS_LISTTEXTA;
	alias MIXERCONTROLDETAILS_LISTTEXTA* LPMIXERCONTROLDETAILS_LISTTEXTA;
	align(2) struct MIXERCONTROLDETAILS_LISTTEXTW {
	    DWORD           dwParam1;
	    DWORD           dwParam2;
	    WCHAR[MIXER_LONG_NAME_CHARS]           szName;
	}
	
	alias MIXERCONTROLDETAILS_LISTTEXTW* PMIXERCONTROLDETAILS_LISTTEXTW;
	alias MIXERCONTROLDETAILS_LISTTEXTW* LPMIXERCONTROLDETAILS_LISTTEXTW;
	
	version(UNICODE) {
		alias MIXERCONTROLDETAILS_LISTTEXTW MIXERCONTROLDETAILS_LISTTEXT;
		alias PMIXERCONTROLDETAILS_LISTTEXTW PMIXERCONTROLDETAILS_LISTTEXT;
		alias LPMIXERCONTROLDETAILS_LISTTEXTW LPMIXERCONTROLDETAILS_LISTTEXT;
	}
	else {
		alias MIXERCONTROLDETAILS_LISTTEXTA MIXERCONTROLDETAILS_LISTTEXT;
		alias PMIXERCONTROLDETAILS_LISTTEXTA PMIXERCONTROLDETAILS_LISTTEXT;
		alias LPMIXERCONTROLDETAILS_LISTTEXTA LPMIXERCONTROLDETAILS_LISTTEXT;
	}
	
	/* */
	/*  MIXER_GETCONTROLDETAILSF_VALUE */
	/* */
	/* */
	align(2) struct MIXERCONTROLDETAILS_BOOLEAN {
	    LONG            fValue;
	}
	
	alias MIXERCONTROLDETAILS_BOOLEAN* PMIXERCONTROLDETAILS_BOOLEAN;
	alias MIXERCONTROLDETAILS_BOOLEAN* LPMIXERCONTROLDETAILS_BOOLEAN;
	
	align(2) struct MIXERCONTROLDETAILS_SIGNED {
	    LONG            lValue;
	}
	
	alias MIXERCONTROLDETAILS_SIGNED* PMIXERCONTROLDETAILS_SIGNED;
	alias MIXERCONTROLDETAILS_SIGNED* LPMIXERCONTROLDETAILS_SIGNED;
	
	
	align(2) struct MIXERCONTROLDETAILS_UNSIGNED {
	    DWORD           dwValue;
	}
	
	alias MIXERCONTROLDETAILS_UNSIGNED* PMIXERCONTROLDETAILS_UNSIGNED;
	alias MIXERCONTROLDETAILS_UNSIGNED* LPMIXERCONTROLDETAILS_UNSIGNED;
	
	
	MMRESULT mixerGetControlDetailsA( HMIXEROBJ hmxobj, LPMIXERCONTROLDETAILS pmxcd, DWORD fdwDetails);
	MMRESULT mixerGetControlDetailsW( HMIXEROBJ hmxobj, LPMIXERCONTROLDETAILS pmxcd, DWORD fdwDetails);
	
	version(UNICODE) {
		alias mixerGetControlDetailsW mixerGetControlDetails;
	}
	else {
		alias mixerGetControlDetailsA mixerGetControlDetails;
	}
	
	const auto MIXER_GETCONTROLDETAILSF_VALUE       = 0x00000000L;
	const auto MIXER_GETCONTROLDETAILSF_LISTTEXT    = 0x00000001L;
	
	const auto MIXER_GETCONTROLDETAILSF_QUERYMASK   = 0x0000000FL;
	
	
	MMRESULT mixerSetControlDetails( HMIXEROBJ hmxobj, LPMIXERCONTROLDETAILS pmxcd, DWORD fdwDetails);
	
	const auto MIXER_SETCONTROLDETAILSF_VALUE       = 0x00000000L;
	const auto MIXER_SETCONTROLDETAILSF_CUSTOM      = 0x00000001L;
	
	const auto MIXER_SETCONTROLDETAILSF_QUERYMASK   = 0x0000000FL;
}

/****************************************************************************

                            Timer support

****************************************************************************/
version(MMNOTIMER) {
}
else {
	/* timer error return values */
	const auto TIMERR_NOERROR         = (0)                  ; /* no error */
	const auto TIMERR_NOCANDO         = (TIMERR_BASE+1)      ; /* request not completed */
	const auto TIMERR_STRUCT          = (TIMERR_BASE+33)     ; /* time align(2) struct size */
	
	/* timer data types */
	alias void function(UINT uTimerID, UINT uMsg, DWORD_PTR dwUser, DWORD_PTR dw1, DWORD_PTR dw2) TIMECALLBACK;
	alias TIMECALLBACK *LPTIMECALLBACK;
	
	/* flags for fuEvent parameter of timeSetEvent() function */
	const auto TIME_ONESHOT     = 0x0000   ; /* program timer for single event */
	const auto TIME_PERIODIC    = 0x0001   ; /* program for continuous periodic event */
	
	const auto TIME_CALLBACK_FUNCTION       = 0x0000  ; /* callback is function */
	const auto TIME_CALLBACK_EVENT_SET      = 0x0010  ; /* callback is event - use SetEvent */
	const auto TIME_CALLBACK_EVENT_PULSE    = 0x0020  ; /* callback is event - use PulseEvent */
	
	const auto TIME_KILL_SYNCHRONOUS    = 0x0100  ; /* This flag prevents the event from occurring */
	                                        /* after the user calls timeKillEvent() to */
	                                        /* destroy it. */
	
	/* timer device capabilities data align(2) structure */
	align(2) struct TIMECAPS {
	    UINT    wPeriodMin;     /* minimum period supported  */
	    UINT    wPeriodMax;     /* maximum period supported  */
	}
	
	alias TIMECAPS* PTIMECAPS;
	alias TIMECAPS *NPTIMECAPS;
	alias TIMECAPS* LPTIMECAPS;
	
	/* timer function prototypes */
	MMRESULT timeGetSystemTime( LPMMTIME pmmt, UINT cbmmt);
	DWORD timeGetTime();
	MMRESULT timeSetEvent( UINT uDelay, UINT uResolution,
	    LPTIMECALLBACK fptc, DWORD_PTR dwUser, UINT fuEvent);
	MMRESULT timeKillEvent( UINT uTimerID);
	MMRESULT timeGetDevCaps( LPTIMECAPS ptc, UINT cbtc);
	MMRESULT timeBeginPeriod( UINT uPeriod);
	MMRESULT timeEndPeriod( UINT uPeriod);
}

/****************************************************************************

                            Joystick support

****************************************************************************/
version(MMNOJOY) {
}
else {
	/* joystick error return values */
	const auto JOYERR_NOERROR         = (0)                  ; /* no error */
	const auto JOYERR_PARMS           = (JOYERR_BASE+5)      ; /* bad parameters */
	const auto JOYERR_NOCANDO         = (JOYERR_BASE+6)      ; /* request not completed */
	const auto JOYERR_UNPLUGGED       = (JOYERR_BASE+7)      ; /* joystick is unplugged */
	
	/* constants used with JOYINFO and JOYINFOEX align(2) structures and MM_JOY* messages */
	const auto JOY_BUTTON1          = 0x0001;
	const auto JOY_BUTTON2          = 0x0002;
	const auto JOY_BUTTON3          = 0x0004;
	const auto JOY_BUTTON4          = 0x0008;
	const auto JOY_BUTTON1CHG       = 0x0100;
	const auto JOY_BUTTON2CHG       = 0x0200;
	const auto JOY_BUTTON3CHG       = 0x0400;
	const auto JOY_BUTTON4CHG       = 0x0800;

	/* constants used with JOYINFOEX */
	const auto JOY_BUTTON5          = 0x00000010;
	const auto JOY_BUTTON6          = 0x00000020;
	const auto JOY_BUTTON7          = 0x00000040;
	const auto JOY_BUTTON8          = 0x00000080;
	const auto JOY_BUTTON9          = 0x00000100;
	const auto JOY_BUTTON10         = 0x00000200;
	const auto JOY_BUTTON11         = 0x00000400;
	const auto JOY_BUTTON12         = 0x00000800;
	const auto JOY_BUTTON13         = 0x00001000;
	const auto JOY_BUTTON14         = 0x00002000;
	const auto JOY_BUTTON15         = 0x00004000;
	const auto JOY_BUTTON16         = 0x00008000;
	const auto JOY_BUTTON17         = 0x00010000;
	const auto JOY_BUTTON18         = 0x00020000;
	const auto JOY_BUTTON19         = 0x00040000;
	const auto JOY_BUTTON20         = 0x00080000;
	const auto JOY_BUTTON21         = 0x00100000;
	const auto JOY_BUTTON22         = 0x00200000;
	const auto JOY_BUTTON23         = 0x00400000;
	const auto JOY_BUTTON24         = 0x00800000;
	const auto JOY_BUTTON25         = 0x01000000;
	const auto JOY_BUTTON26         = 0x02000000;
	const auto JOY_BUTTON27         = 0x04000000;
	const auto JOY_BUTTON28         = 0x08000000;
	const auto JOY_BUTTON29         = 0x10000000;
	const auto JOY_BUTTON30         = 0x20000000;
	const auto JOY_BUTTON31         = 0x40000000;
	const auto JOY_BUTTON32         = 0x80000000;

	/* constants used with JOYINFOEX align(2) structure */
	const auto JOY_POVCENTERED          = cast(WORD) -1;
	const auto JOY_POVFORWARD           = 0;
	const auto JOY_POVRIGHT             = 9000;
	const auto JOY_POVBACKWARD          = 18000;
	const auto JOY_POVLEFT              = 27000;

	const auto JOY_RETURNX              = 0x00000001;
	const auto JOY_RETURNY              = 0x00000002;
	const auto JOY_RETURNZ              = 0x00000004;
	const auto JOY_RETURNR              = 0x00000008;
	const auto JOY_RETURNU              = 0x00000010     ; /* axis 5 */
	const auto JOY_RETURNV              = 0x00000020     ; /* axis 6 */
	const auto JOY_RETURNPOV            = 0x00000040;
	const auto JOY_RETURNBUTTONS        = 0x00000080;
	const auto JOY_RETURNRAWDATA        = 0x00000100;
	const auto JOY_RETURNPOVCTS         = 0x00000200;
	const auto JOY_RETURNCENTERED       = 0x00000400;
	const auto JOY_USEDEADZONE          = 0x00000800;
	const auto JOY_RETURNALL            = (JOY_RETURNX | JOY_RETURNY | JOY_RETURNZ |
	                                 JOY_RETURNR | JOY_RETURNU | JOY_RETURNV |
	                                 JOY_RETURNPOV | JOY_RETURNBUTTONS);
	const auto JOY_CAL_READALWAYS       = 0x00010000;
	const auto JOY_CAL_READXYONLY       = 0x00020000;
	const auto JOY_CAL_READ3            = 0x00040000;
	const auto JOY_CAL_READ4            = 0x00080000;
	const auto JOY_CAL_READXONLY        = 0x00100000;
	const auto JOY_CAL_READYONLY        = 0x00200000;
	const auto JOY_CAL_READ5            = 0x00400000;
	const auto JOY_CAL_READ6            = 0x00800000;
	const auto JOY_CAL_READZONLY        = 0x01000000;
	const auto JOY_CAL_READRONLY        = 0x02000000;
	const auto JOY_CAL_READUONLY        = 0x04000000;
	const auto JOY_CAL_READVONLY        = 0x08000000;

	/* joystick ID constants */
	const auto JOYSTICKID1          = 0;
	const auto JOYSTICKID2          = 1;
	
	/* joystick driver capabilites */
	const auto JOYCAPS_HASZ             = 0x0001;
	const auto JOYCAPS_HASR             = 0x0002;
	const auto JOYCAPS_HASU             = 0x0004;
	const auto JOYCAPS_HASV             = 0x0008;
	const auto JOYCAPS_HASPOV           = 0x0010;
	const auto JOYCAPS_POV4DIR          = 0x0020;
	const auto JOYCAPS_POVCTS           = 0x0040;
	
	
	
	/* joystick device capabilities data align(2) structure */
	align(2) struct JOYCAPSA {
	    WORD    wMid;                /* manufacturer ID */
	    WORD    wPid;                /* product ID */
	    CHAR[MAXPNAMELEN]    szPname;/* product name (NULL terminated string) */
	    UINT    wXmin;               /* minimum x position value */
	    UINT    wXmax;               /* maximum x position value */
	    UINT    wYmin;               /* minimum y position value */
	    UINT    wYmax;               /* maximum y position value */
	    UINT    wZmin;               /* minimum z position value */
	    UINT    wZmax;               /* maximum z position value */
	    UINT    wNumButtons;         /* number of buttons */
	    UINT    wPeriodMin;          /* minimum message period when captured */
	    UINT    wPeriodMax;          /* maximum message period when captured */

	    UINT    wRmin;               /* minimum r position value */
	    UINT    wRmax;               /* maximum r position value */
	    UINT    wUmin;               /* minimum u (5th axis) position value */
	    UINT    wUmax;               /* maximum u (5th axis) position value */
	    UINT    wVmin;               /* minimum v (6th axis) position value */
	    UINT    wVmax;               /* maximum v (6th axis) position value */
	    UINT    wCaps;               /* joystick capabilites */
	    UINT    wMaxAxes;            /* maximum number of axes supported */
	    UINT    wNumAxes;            /* number of axes in use */
	    UINT    wMaxButtons;         /* maximum number of buttons supported */
	    CHAR[MAXPNAMELEN]    szRegKey;/* registry key */
	    CHAR[MAX_JOYSTICKOEMVXDNAME]    szOEMVxD; /* OEM VxD in use */
	}
	
	alias JOYCAPSA* PJOYCAPSA;
	alias JOYCAPSA* NPJOYCAPSA;
	alias JOYCAPSA* LPJOYCAPSA;
	align(2) struct JOYCAPSW {
	    WORD    wMid;                /* manufacturer ID */
	    WORD    wPid;                /* product ID */
	    WCHAR[MAXPNAMELEN]   szPname;/* product name (NULL terminated string) */
	    UINT    wXmin;               /* minimum x position value */
	    UINT    wXmax;               /* maximum x position value */
	    UINT    wYmin;               /* minimum y position value */
	    UINT    wYmax;               /* maximum y position value */
	    UINT    wZmin;               /* minimum z position value */
	    UINT    wZmax;               /* maximum z position value */
	    UINT    wNumButtons;         /* number of buttons */
	    UINT    wPeriodMin;          /* minimum message period when captured */
	    UINT    wPeriodMax;          /* maximum message period when captured */
	
	    UINT    wRmin;               /* minimum r position value */
	    UINT    wRmax;               /* maximum r position value */
	    UINT    wUmin;               /* minimum u (5th axis) position value */
	    UINT    wUmax;               /* maximum u (5th axis) position value */
	    UINT    wVmin;               /* minimum v (6th axis) position value */
	    UINT    wVmax;               /* maximum v (6th axis) position value */
	    UINT    wCaps;               /* joystick capabilites */
	    UINT    wMaxAxes;            /* maximum number of axes supported */
	    UINT    wNumAxes;            /* number of axes in use */
	    UINT    wMaxButtons;         /* maximum number of buttons supported */
	    WCHAR[MAXPNAMELEN]   szRegKey;/* registry key */
	    WCHAR[MAX_JOYSTICKOEMVXDNAME]   szOEMVxD; /* OEM VxD in use */
	}
	
	alias JOYCAPSW* PJOYCAPSW;
	alias JOYCAPSW* NPJOYCAPSW;
	alias JOYCAPSW* LPJOYCAPSW;
	
	version(UNICODE) {
		alias JOYCAPSW JOYCAPS;
		alias PJOYCAPSW PJOYCAPS;
		alias NPJOYCAPSW NPJOYCAPS;
		alias LPJOYCAPSW LPJOYCAPS;
	}
	else {
		alias JOYCAPSA JOYCAPS;
		alias PJOYCAPSA PJOYCAPS;
		alias NPJOYCAPSA NPJOYCAPS;
		alias LPJOYCAPSA LPJOYCAPS;
	}
	
	align(2) struct JOYCAPS2A {
	    WORD    wMid;                /* manufacturer ID */
	    WORD    wPid;                /* product ID */
	    CHAR[MAXPNAMELEN]    szPname;/* product name (NULL terminated string) */
	    UINT    wXmin;               /* minimum x position value */
	    UINT    wXmax;               /* maximum x position value */
	    UINT    wYmin;               /* minimum y position value */
	    UINT    wYmax;               /* maximum y position value */
	    UINT    wZmin;               /* minimum z position value */
	    UINT    wZmax;               /* maximum z position value */
	    UINT    wNumButtons;         /* number of buttons */
	    UINT    wPeriodMin;          /* minimum message period when captured */
	    UINT    wPeriodMax;          /* maximum message period when captured */
	    UINT    wRmin;               /* minimum r position value */
	    UINT    wRmax;               /* maximum r position value */
	    UINT    wUmin;               /* minimum u (5th axis) position value */
	    UINT    wUmax;               /* maximum u (5th axis) position value */
	    UINT    wVmin;               /* minimum v (6th axis) position value */
	    UINT    wVmax;               /* maximum v (6th axis) position value */
	    UINT    wCaps;               /* joystick capabilites */
	    UINT    wMaxAxes;            /* maximum number of axes supported */
	    UINT    wNumAxes;            /* number of axes in use */
	    UINT    wMaxButtons;         /* maximum number of buttons supported */
	    CHAR[MAXPNAMELEN]    szRegKey;/* registry key */
	    CHAR[MAX_JOYSTICKOEMVXDNAME]    szOEMVxD; /* OEM VxD in use */
	    GUID    ManufacturerGuid;    /* for extensible MID mapping */
	    GUID    ProductGuid;         /* for extensible PID mapping */
	    GUID    NameGuid;            /* for name lookup in registry */
	}
	
	alias JOYCAPS2A* PJOYCAPS2A;
	alias JOYCAPS2A* NPJOYCAPS2A;
	alias JOYCAPS2A* LPJOYCAPS2A;
	align(2) struct JOYCAPS2W {
	    WORD    wMid;                /* manufacturer ID */
	    WORD    wPid;                /* product ID */
	    WCHAR[MAXPNAMELEN]   szPname;/* product name (NULL terminated string) */
	    UINT    wXmin;               /* minimum x position value */
	    UINT    wXmax;               /* maximum x position value */
	    UINT    wYmin;               /* minimum y position value */
	    UINT    wYmax;               /* maximum y position value */
	    UINT    wZmin;               /* minimum z position value */
	    UINT    wZmax;               /* maximum z position value */
	    UINT    wNumButtons;         /* number of buttons */
	    UINT    wPeriodMin;          /* minimum message period when captured */
	    UINT    wPeriodMax;          /* maximum message period when captured */
	    UINT    wRmin;               /* minimum r position value */
	    UINT    wRmax;               /* maximum r position value */
	    UINT    wUmin;               /* minimum u (5th axis) position value */
	    UINT    wUmax;               /* maximum u (5th axis) position value */
	    UINT    wVmin;               /* minimum v (6th axis) position value */
	    UINT    wVmax;               /* maximum v (6th axis) position value */
	    UINT    wCaps;               /* joystick capabilites */
	    UINT    wMaxAxes;            /* maximum number of axes supported */
	    UINT    wNumAxes;            /* number of axes in use */
	    UINT    wMaxButtons;         /* maximum number of buttons supported */
	    WCHAR[MAXPNAMELEN]   szRegKey;/* registry key */
	    WCHAR[MAX_JOYSTICKOEMVXDNAME]   szOEMVxD; /* OEM VxD in use */
	    GUID    ManufacturerGuid;    /* for extensible MID mapping */
	    GUID    ProductGuid;         /* for extensible PID mapping */
	    GUID    NameGuid;            /* for name lookup in registry */
	}
	
	alias JOYCAPS2W* PJOYCAPS2W;
	alias JOYCAPS2W* NPJOYCAPS2W;
	alias JOYCAPS2W* LPJOYCAPS2W;
	
	version(UNICODE) {
		alias JOYCAPS2W JOYCAPS2;
		alias PJOYCAPS2W PJOYCAPS2;
		alias NPJOYCAPS2W NPJOYCAPS2;
		alias LPJOYCAPS2W LPJOYCAPS2;
	}
	else {
		alias JOYCAPS2A JOYCAPS2;
		alias PJOYCAPS2A PJOYCAPS2;
		alias NPJOYCAPS2A NPJOYCAPS2;
		alias LPJOYCAPS2A LPJOYCAPS2;
	}
	
	/* joystick information data align(2) structure */
	align(2) struct JOYINFO {
	    UINT wXpos;                 /* x position */
	    UINT wYpos;                 /* y position */
	    UINT wZpos;                 /* z position */
	    UINT wButtons;              /* button states */
	}
	
	alias JOYINFO* PJOYINFO;
	alias JOYINFO *NPJOYINFO;
	alias JOYINFO* LPJOYINFO;
	
	align(2) struct JOYINFOEX {
	    DWORD dwSize;                /* size of align(2) structure */
	    DWORD dwFlags;               /* flags to indicate what to return */
	    DWORD dwXpos;                /* x position */
	    DWORD dwYpos;                /* y position */
	    DWORD dwZpos;                /* z position */
	    DWORD dwRpos;                /* rudder/4th axis position */
	    DWORD dwUpos;                /* 5th axis position */
	    DWORD dwVpos;                /* 6th axis position */
	    DWORD dwButtons;             /* button states */
	    DWORD dwButtonNumber;        /* current button number pressed */
	    DWORD dwPOV;                 /* point of view state */
	    DWORD dwReserved1;           /* reserved for communication between winmm & driver */
	    DWORD dwReserved2;           /* reserved for future expansion */
	}
	
	alias JOYINFOEX* PJOYINFOEX;
	alias JOYINFOEX *NPJOYINFOEX;
	alias JOYINFOEX* LPJOYINFOEX;
	
	/* joystick function prototypes */
	UINT joyGetNumDevs();
	
	MMRESULT joyGetDevCapsA( UINT_PTR uJoyID, LPJOYCAPSA pjc, UINT cbjc);
	MMRESULT joyGetDevCapsW( UINT_PTR uJoyID, LPJOYCAPSW pjc, UINT cbjc);
	
	version(UNICODE) {
		alias joyGetDevCapsW joyGetDevCaps;
	}
	else {
		alias joyGetDevCapsA joyGetDevCaps;
	}

	MMRESULT joyGetPosEx( UINT uJoyID, LPJOYINFOEX pji);

	MMRESULT joyGetThreshold( UINT uJoyID, LPUINT puThreshold);
	MMRESULT joyReleaseCapture( UINT uJoyID);
	MMRESULT joySetCapture( HWND hwnd, UINT uJoyID, UINT uPeriod,
	    BOOL fChanged);
	MMRESULT joySetThreshold( UINT uJoyID, UINT uThreshold);
}

/****************************************************************************

                        Multimedia File I/O support

****************************************************************************/
version(MMNOMMIO) {
}
else {
	/* MMIO error return values */
	const auto MMIOERR_BASE                 = 256;
	const auto MMIOERR_FILENOTFOUND         = (MMIOERR_BASE + 1)  ; /* file not found */
	const auto MMIOERR_OUTOFMEMORY          = (MMIOERR_BASE + 2)  ; /* out of memory */
	const auto MMIOERR_CANNOTOPEN           = (MMIOERR_BASE + 3)  ; /* cannot open */
	const auto MMIOERR_CANNOTCLOSE          = (MMIOERR_BASE + 4)  ; /* cannot close */
	const auto MMIOERR_CANNOTREAD           = (MMIOERR_BASE + 5)  ; /* cannot read */
	const auto MMIOERR_CANNOTWRITE          = (MMIOERR_BASE + 6)  ; /* cannot write */
	const auto MMIOERR_CANNOTSEEK           = (MMIOERR_BASE + 7)  ; /* cannot seek */
	const auto MMIOERR_CANNOTEXPAND         = (MMIOERR_BASE + 8)  ; /* cannot expand file */
	const auto MMIOERR_CHUNKNOTFOUND        = (MMIOERR_BASE + 9)  ; /* chunk not found */
	const auto MMIOERR_UNBUFFERED           = (MMIOERR_BASE + 10) ; /*  */
	const auto MMIOERR_PATHNOTFOUND         = (MMIOERR_BASE + 11) ; /* path incorrect */
	const auto MMIOERR_ACCESSDENIED         = (MMIOERR_BASE + 12) ; /* file was protected */
	const auto MMIOERR_SHARINGVIOLATION     = (MMIOERR_BASE + 13) ; /* file in use */
	const auto MMIOERR_NETWORKERROR         = (MMIOERR_BASE + 14) ; /* network not responding */
	const auto MMIOERR_TOOMANYOPENFILES     = (MMIOERR_BASE + 15) ; /* no more file handles  */
	const auto MMIOERR_INVALIDFILE          = (MMIOERR_BASE + 16) ; /* default error file error */
	
	/* MMIO constants */
	const auto CFSEPCHAR        = '+'             ; /* compound file name separator char. */
	
	/* MMIO data types */
	alias DWORD           FOURCC;         /* a four character code */
	alias char*    HPSTR;                 /* a huge version of LPSTR */
	alias HANDLE HMMIO;                   /* a handle to an open file */
	
	alias LRESULT function(LPSTR lpmmioinfo, UINT uMsg,
	            LPARAM lParam1, LPARAM lParam2) MMIOPROC;
	alias MMIOPROC *LPMMIOPROC;

	/* general MMIO information data align(2) structure */
	align(2) struct MMIOINFO {
	        /* general fields */
	        DWORD           dwFlags;        /* general status flags */
	        FOURCC          fccIOProc;      /* pointer to I/O procedure */
	        LPMMIOPROC      pIOProc;        /* pointer to I/O procedure */
	        UINT            wErrorRet;      /* place for error to be returned */
	        HTASK           htask;          /* alternate local task */
	
	        /* fields maintained by MMIO functions during buffered I/O */
	        LONG            cchBuffer;      /* size of I/O buffer (or 0L) */
	        HPSTR           pchBuffer;      /* start of I/O buffer (or NULL) */
	        HPSTR           pchNext;        /* pointer to next byte to read/write */
	        HPSTR           pchEndRead;     /* pointer to last valid byte to read */
	        HPSTR           pchEndWrite;    /* pointer to last byte to write */
	        LONG            lBufOffset;     /* disk offset of start of buffer */
	
	        /* fields maintained by I/O procedure */
	        LONG            lDiskOffset;    /* disk offset of next read or write */
	        DWORD[3]           adwInfo;     /* data specific to type of MMIOPROC */
	
	        /* other fields maintained by MMIO */
	        DWORD           dwReserved1;    /* reserved for MMIO use */
	        DWORD           dwReserved2;    /* reserved for MMIO use */
	        HMMIO           hmmio;          /* handle to open file */
	}
	
	alias MMIOINFO* PMMIOINFO;
	alias MMIOINFO *NPMMIOINFO;
	alias MMIOINFO* LPMMIOINFO;
	alias MMIOINFO *LPCMMIOINFO;
	
	/* RIFF chunk information data align(2) structure */
	align(2) struct MMCKINFO {
	        FOURCC          ckid;           /* chunk ID */
	        DWORD           cksize;         /* chunk size */
	        FOURCC          fccType;        /* form type or list type */
	        DWORD           dwDataOffset;   /* offset of data portion of chunk */
	        DWORD           dwFlags;        /* flags used by MMIO functions */
	}
	
	alias MMCKINFO* PMMCKINFO;
	alias MMCKINFO *NPMMCKINFO;
	alias MMCKINFO* LPMMCKINFO;
	alias MMCKINFO *LPCMMCKINFO;
	
	/* bit field masks */
	const auto MMIO_RWMODE      = 0x00000003      ; /* open file for reading/writing/both */
	const auto MMIO_SHAREMODE   = 0x00000070      ; /* file sharing mode number */
	
	/* constants for dwFlags field of MMIOINFO */
	const auto MMIO_CREATE      = 0x00001000      ; /* create new file (or truncate file) */
	const auto MMIO_PARSE       = 0x00000100      ; /* parse new file returning path */
	const auto MMIO_DELETE      = 0x00000200      ; /* create new file (or truncate file) */
	const auto MMIO_EXIST       = 0x00004000      ; /* checks for existence of file */
	const auto MMIO_ALLOCBUF    = 0x00010000      ; /* mmioOpen() should allocate a buffer */
	const auto MMIO_GETTEMP     = 0x00020000      ; /* mmioOpen() should retrieve temp name */
	
	const auto MMIO_DIRTY       = 0x10000000      ; /* I/O buffer is dirty */
	
	
	/* read/write mode numbers (bit field MMIO_RWMODE) */
	const auto MMIO_READ        = 0x00000000      ; /* open file for reading only */
	const auto MMIO_WRITE       = 0x00000001      ; /* open file for writing only */
	const auto MMIO_READWRITE   = 0x00000002      ; /* open file for reading and writing */
	
	/* share mode numbers (bit field MMIO_SHAREMODE) */
	const auto MMIO_COMPAT      = 0x00000000      ; /* compatibility mode */
	const auto MMIO_EXCLUSIVE   = 0x00000010      ; /* exclusive-access mode */
	const auto MMIO_DENYWRITE   = 0x00000020      ; /* deny writing to other processes */
	const auto MMIO_DENYREAD    = 0x00000030      ; /* deny reading to other processes */
	const auto MMIO_DENYNONE    = 0x00000040      ; /* deny nothing to other processes */
	
	/* various MMIO flags */
	const auto MMIO_FHOPEN              = 0x0010  ; /* mmioClose: keep file handle open */
	const auto MMIO_EMPTYBUF            = 0x0010  ; /* mmioFlush: empty the I/O buffer */
	const auto MMIO_TOUPPER             = 0x0010  ; /* mmioStringToFOURCC: to u-case */
	const auto MMIO_INSTALLPROC     = 0x00010000  ; /* mmioInstallIOProc: install MMIOProc */
	const auto MMIO_GLOBALPROC      = 0x10000000  ; /* mmioInstallIOProc: install globally */
	const auto MMIO_REMOVEPROC      = 0x00020000  ; /* mmioInstallIOProc: remove MMIOProc */
	const auto MMIO_UNICODEPROC     = 0x01000000  ; /* mmioInstallIOProc: Unicode MMIOProc */
	const auto MMIO_FINDPROC        = 0x00040000  ; /* mmioInstallIOProc: find an MMIOProc */
	const auto MMIO_FINDCHUNK           = 0x0010  ; /* mmioDescend: find a chunk by ID */
	const auto MMIO_FINDRIFF            = 0x0020  ; /* mmioDescend: find a LIST chunk */
	const auto MMIO_FINDLIST            = 0x0040  ; /* mmioDescend: find a RIFF chunk */
	const auto MMIO_CREATERIFF          = 0x0020  ; /* mmioCreateChunk: make a LIST chunk */
	const auto MMIO_CREATELIST          = 0x0040  ; /* mmioCreateChunk: make a RIFF chunk */
	
	
	/* message numbers for MMIOPROC I/O procedure functions */
	const auto MMIOM_READ       = MMIO_READ       ; /* read */
	const auto MMIOM_WRITE     = MMIO_WRITE       ; /* write */
	const auto MMIOM_SEEK               = 2       ; /* seek to a new position in file */
	const auto MMIOM_OPEN               = 3       ; /* open file */
	const auto MMIOM_CLOSE              = 4       ; /* close file */
	const auto MMIOM_WRITEFLUSH         = 5       ; /* write and flush */
	
	const auto MMIOM_RENAME             = 6       ; /* rename specified file */
	
	const auto MMIOM_USER          = 0x8000       ; /* beginning of user-defined messages */
	
	/* MMIO macros */
	template mmioFOURCC(char ch0, char ch1, char ch2, char ch3) {
		const auto mmioFOURCC = MAKEFOURCC!(ch0,ch1,ch2,ch3);
	}
	
	/* standard four character codes */
	const auto FOURCC_RIFF      = mmioFOURCC!('R', 'I', 'F', 'F');
	const auto FOURCC_LIST      = mmioFOURCC!('L', 'I', 'S', 'T');

	/* four character codes used to identify standard built-in I/O procedures */
	const auto FOURCC_DOS       = mmioFOURCC!('D', 'O', 'S', ' ');
	const auto FOURCC_MEM       = mmioFOURCC!('M', 'E', 'M', ' ');
	
	/* flags for mmioSeek() */
	const auto SEEK_SET         = 0               ; /* seek to an absolute position */
	const auto SEEK_CUR         = 1               ; /* seek relative to current position */
	const auto SEEK_END         = 2               ; /* seek relative to end of file */
	
	/* other constants */
	const auto MMIO_DEFAULTBUFFER       = 8192    ; /* default buffer size */

	/* MMIO function prototypes */
	FOURCC mmioStringToFOURCCA( LPCSTR sz, UINT uFlags);
	FOURCC mmioStringToFOURCCW( LPCWSTR sz, UINT uFlags);
	
	version(UNICODE) {
		alias mmioStringToFOURCCW mmioStringToFOURCC;
	}
	else {
		alias mmioStringToFOURCCA mmioStringToFOURCC;
	}
	
	LPMMIOPROC mmioInstallIOProcA( FOURCC fccIOProc, LPMMIOPROC pIOProc, DWORD dwFlags);
	LPMMIOPROC mmioInstallIOProcW( FOURCC fccIOProc, LPMMIOPROC pIOProc, DWORD dwFlags);
	
	version(UNICODE) {
		alias mmioInstallIOProcW mmioInstallIOProc;
	}
	else {
		alias mmioInstallIOProcA mmioInstallIOProc;
	}
	
	HMMIO mmioOpenA( LPSTR pszFileName,  LPMMIOINFO pmmioinfo,  DWORD fdwOpen);
	HMMIO mmioOpenW( LPWSTR pszFileName,  LPMMIOINFO pmmioinfo,  DWORD fdwOpen);
	
	version(UNICODE) {
		alias mmioOpenW mmioOpen;
	}
	else {
		alias mmioOpenA mmioOpen;
	}
	MMRESULT mmioRenameA( LPCSTR pszFileName, LPCSTR pszNewFileName, LPCMMIOINFO pmmioinfo, DWORD fdwRename);
	MMRESULT mmioRenameW( LPCWSTR pszFileName, LPCWSTR pszNewFileName, LPCMMIOINFO pmmioinfo, DWORD fdwRename);
	
	version(UNICODE) {
		alias mmioRenameW mmioRename;
	}
	else {
		alias mmioRenameA mmioRename;
	}
	
	MMRESULT mmioClose( HMMIO hmmio, UINT fuClose);
	LONG mmioRead( HMMIO hmmio, HPSTR pch, LONG cch);
	LONG mmioWrite( HMMIO hmmio, char* pch, LONG cch);
	LONG mmioSeek( HMMIO hmmio, LONG lOffset, int iOrigin);
	MMRESULT mmioGetInfo( HMMIO hmmio, LPMMIOINFO pmmioinfo, UINT fuInfo);
	MMRESULT mmioSetInfo( HMMIO hmmio, LPCMMIOINFO pmmioinfo, UINT fuInfo);
	MMRESULT mmioSetBuffer( HMMIO hmmio, LPSTR pchBuffer, LONG cchBuffer,
	    UINT fuBuffer);
	MMRESULT mmioFlush( HMMIO hmmio, UINT fuFlush);
	MMRESULT mmioAdvance( HMMIO hmmio, LPMMIOINFO pmmioinfo, UINT fuAdvance);
	LRESULT mmioSendMessage( HMMIO hmmio, UINT uMsg,
	    LPARAM lParam1, LPARAM lParam2);
	MMRESULT mmioDescend( HMMIO hmmio, LPMMCKINFO pmmcki,
	    MMCKINFO* pmmckiParent, UINT fuDescend);
	MMRESULT mmioAscend( HMMIO hmmio, LPMMCKINFO pmmcki, UINT fuAscend);
	MMRESULT mmioCreateChunk(HMMIO hmmio, LPMMCKINFO pmmcki, UINT fuCreate);
}

/****************************************************************************

                            MCI support

****************************************************************************/
version(MMNOMCI) {
}
else {
	alias DWORD   MCIERROR;       /* error return code, 0 means no error */
	alias UINT    MCIDEVICEID;    /* MCI device ID type */
	
	alias UINT function(MCIDEVICEID mciId, DWORD dwYieldData) YIELDPROC;
	
	/* MCI function prototypes */
	MCIERROR mciSendCommandA( MCIDEVICEID mciId, UINT uMsg, DWORD_PTR dwParam1, DWORD_PTR dwParam2);
	MCIERROR mciSendCommandW( MCIDEVICEID mciId, UINT uMsg, DWORD_PTR dwParam1, DWORD_PTR dwParam2);
	
	version(UNICODE) {
		alias mciSendCommandW mciSendCommand;
	}
	else {
		alias mciSendCommandA mciSendCommand;
	}
	
	MCIERROR  mciSendStringA( LPCSTR lpstrCommand, LPSTR lpstrReturnString, UINT uReturnLength, HWND hwndCallback);
	MCIERROR  mciSendStringW( LPCWSTR lpstrCommand, LPWSTR lpstrReturnString, UINT uReturnLength, HWND hwndCallback);
	
	version(UNICODE) {
		alias mciSendStringW mciSendString;
	}
	else {
		alias mciSendStringA mciSendString;
	}
	
	MCIDEVICEID mciGetDeviceIDA( LPCSTR pszDevice);
	MCIDEVICEID mciGetDeviceIDW( LPCWSTR pszDevice);
	
	version(UNICODE) {
		alias mciGetDeviceIDW mciGetDeviceID;
	}
	else {
		alias mciGetDeviceIDA mciGetDeviceID;
	}
	
	MCIDEVICEID mciGetDeviceIDFromElementIDA( DWORD dwElementID, LPCSTR lpstrType );
	MCIDEVICEID mciGetDeviceIDFromElementIDW( DWORD dwElementID, LPCWSTR lpstrType );
	
	version(UNICODE) {
		alias mciGetDeviceIDFromElementIDW mciGetDeviceIDFromElementID;
	}
	else {
		alias mciGetDeviceIDFromElementIDA mciGetDeviceIDFromElementID;
	}
	
	BOOL mciGetErrorStringA( MCIERROR mcierr, LPSTR pszText, UINT cchText);
	BOOL mciGetErrorStringW( MCIERROR mcierr, LPWSTR pszText, UINT cchText);
	
	version(UNICODE) {
		alias mciGetErrorStringW mciGetErrorString;
	}
	else {
		alias mciGetErrorStringA mciGetErrorString;
	}
	
	BOOL mciSetYieldProc( MCIDEVICEID mciId, YIELDPROC fpYieldProc,
	    DWORD dwYieldData);
	
	HTASK mciGetCreatorTask( MCIDEVICEID mciId);
	YIELDPROC mciGetYieldProc( MCIDEVICEID mciId, LPDWORD pdwYieldData);
	
	BOOL mciExecute(LPCSTR pszCommand);
	
	/* MCI error return values */
	const auto MCIERR_INVALID_DEVICE_ID         = (MCIERR_BASE + 1);
	const auto MCIERR_UNRECOGNIZED_KEYWORD      = (MCIERR_BASE + 3);
	const auto MCIERR_UNRECOGNIZED_COMMAND      = (MCIERR_BASE + 5);
	const auto MCIERR_HARDWARE                  = (MCIERR_BASE + 6);
	const auto MCIERR_INVALID_DEVICE_NAME       = (MCIERR_BASE + 7);
	const auto MCIERR_OUT_OF_MEMORY             = (MCIERR_BASE + 8);
	const auto MCIERR_DEVICE_OPEN               = (MCIERR_BASE + 9);
	const auto MCIERR_CANNOT_LOAD_DRIVER        = (MCIERR_BASE + 10);
	const auto MCIERR_MISSING_COMMAND_STRING    = (MCIERR_BASE + 11);
	const auto MCIERR_PARAM_OVERFLOW            = (MCIERR_BASE + 12);
	const auto MCIERR_MISSING_STRING_ARGUMENT   = (MCIERR_BASE + 13);
	const auto MCIERR_BAD_INTEGER               = (MCIERR_BASE + 14);
	const auto MCIERR_PARSER_INTERNAL           = (MCIERR_BASE + 15);
	const auto MCIERR_DRIVER_INTERNAL           = (MCIERR_BASE + 16);
	const auto MCIERR_MISSING_PARAMETER         = (MCIERR_BASE + 17);
	const auto MCIERR_UNSUPPORTED_FUNCTION      = (MCIERR_BASE + 18);
	const auto MCIERR_FILE_NOT_FOUND            = (MCIERR_BASE + 19);
	const auto MCIERR_DEVICE_NOT_READY          = (MCIERR_BASE + 20);
	const auto MCIERR_INTERNAL                  = (MCIERR_BASE + 21);
	const auto MCIERR_DRIVER                    = (MCIERR_BASE + 22);
	const auto MCIERR_CANNOT_USE_ALL            = (MCIERR_BASE + 23);
	const auto MCIERR_MULTIPLE                  = (MCIERR_BASE + 24);
	const auto MCIERR_EXTENSION_NOT_FOUND       = (MCIERR_BASE + 25);
	const auto MCIERR_OUTOFRANGE                = (MCIERR_BASE + 26);
	const auto MCIERR_FLAGS_NOT_COMPATIBLE      = (MCIERR_BASE + 28);
	const auto MCIERR_FILE_NOT_SAVED            = (MCIERR_BASE + 30);
	const auto MCIERR_DEVICE_TYPE_REQUIRED      = (MCIERR_BASE + 31);
	const auto MCIERR_DEVICE_LOCKED             = (MCIERR_BASE + 32);
	const auto MCIERR_DUPLICATE_ALIAS           = (MCIERR_BASE + 33);
	const auto MCIERR_BAD_CONSTANT              = (MCIERR_BASE + 34);
	const auto MCIERR_MUST_USE_SHAREABLE        = (MCIERR_BASE + 35);
	const auto MCIERR_MISSING_DEVICE_NAME       = (MCIERR_BASE + 36);
	const auto MCIERR_BAD_TIME_FORMAT           = (MCIERR_BASE + 37);
	const auto MCIERR_NO_CLOSING_QUOTE          = (MCIERR_BASE + 38);
	const auto MCIERR_DUPLICATE_FLAGS           = (MCIERR_BASE + 39);
	const auto MCIERR_INVALID_FILE              = (MCIERR_BASE + 40);
	const auto MCIERR_NULL_PARAMETER_BLOCK      = (MCIERR_BASE + 41);
	const auto MCIERR_UNNAMED_RESOURCE          = (MCIERR_BASE + 42);
	const auto MCIERR_NEW_REQUIRES_ALIAS        = (MCIERR_BASE + 43);
	const auto MCIERR_NOTIFY_ON_AUTO_OPEN       = (MCIERR_BASE + 44);
	const auto MCIERR_NO_ELEMENT_ALLOWED        = (MCIERR_BASE + 45);
	const auto MCIERR_NONAPPLICABLE_FUNCTION    = (MCIERR_BASE + 46);
	const auto MCIERR_ILLEGAL_FOR_AUTO_OPEN     = (MCIERR_BASE + 47);
	const auto MCIERR_FILENAME_REQUIRED         = (MCIERR_BASE + 48);
	const auto MCIERR_EXTRA_CHARACTERS          = (MCIERR_BASE + 49);
	const auto MCIERR_DEVICE_NOT_INSTALLED      = (MCIERR_BASE + 50);
	const auto MCIERR_GET_CD                    = (MCIERR_BASE + 51);
	const auto MCIERR_SET_CD                    = (MCIERR_BASE + 52);
	const auto MCIERR_SET_DRIVE                 = (MCIERR_BASE + 53);
	const auto MCIERR_DEVICE_LENGTH             = (MCIERR_BASE + 54);
	const auto MCIERR_DEVICE_ORD_LENGTH         = (MCIERR_BASE + 55);
	const auto MCIERR_NO_INTEGER                = (MCIERR_BASE + 56);
	
	const auto MCIERR_WAVE_OUTPUTSINUSE         = (MCIERR_BASE + 64);
	const auto MCIERR_WAVE_SETOUTPUTINUSE       = (MCIERR_BASE + 65);
	const auto MCIERR_WAVE_INPUTSINUSE          = (MCIERR_BASE + 66);
	const auto MCIERR_WAVE_SETINPUTINUSE        = (MCIERR_BASE + 67);
	const auto MCIERR_WAVE_OUTPUTUNSPECIFIED    = (MCIERR_BASE + 68);
	const auto MCIERR_WAVE_INPUTUNSPECIFIED     = (MCIERR_BASE + 69);
	const auto MCIERR_WAVE_OUTPUTSUNSUITABLE    = (MCIERR_BASE + 70);
	const auto MCIERR_WAVE_SETOUTPUTUNSUITABLE  = (MCIERR_BASE + 71);
	const auto MCIERR_WAVE_INPUTSUNSUITABLE     = (MCIERR_BASE + 72);
	const auto MCIERR_WAVE_SETINPUTUNSUITABLE   = (MCIERR_BASE + 73);
	
	const auto MCIERR_SEQ_DIV_INCOMPATIBLE      = (MCIERR_BASE + 80);
	const auto MCIERR_SEQ_PORT_INUSE            = (MCIERR_BASE + 81);
	const auto MCIERR_SEQ_PORT_NONEXISTENT      = (MCIERR_BASE + 82);
	const auto MCIERR_SEQ_PORT_MAPNODEVICE      = (MCIERR_BASE + 83);
	const auto MCIERR_SEQ_PORT_MISCERROR        = (MCIERR_BASE + 84);
	const auto MCIERR_SEQ_TIMER                 = (MCIERR_BASE + 85);
	const auto MCIERR_SEQ_PORTUNSPECIFIED       = (MCIERR_BASE + 86);
	const auto MCIERR_SEQ_NOMIDIPRESENT         = (MCIERR_BASE + 87);
	
	const auto MCIERR_NO_WINDOW                 = (MCIERR_BASE + 90);
	const auto MCIERR_CREATEWINDOW              = (MCIERR_BASE + 91);
	const auto MCIERR_FILE_READ                 = (MCIERR_BASE + 92);
	const auto MCIERR_FILE_WRITE                = (MCIERR_BASE + 93);
	
	const auto MCIERR_NO_IDENTITY               = (MCIERR_BASE + 94);
	
	/* all custom device driver errors must be >= than this value */
	const auto MCIERR_CUSTOM_DRIVER_BASE        = (MCIERR_BASE + 256);

	const auto MCI_FIRST                        = DRV_MCI_FIRST   ; /* 0x0800 */
	/* MCI command message identifiers */
	const auto MCI_OPEN                         = 0x0803;
	const auto MCI_CLOSE                        = 0x0804;
	const auto MCI_ESCAPE                       = 0x0805;
	const auto MCI_PLAY                         = 0x0806;
	const auto MCI_SEEK                         = 0x0807;
	const auto MCI_STOP                         = 0x0808;
	const auto MCI_PAUSE                        = 0x0809;
	const auto MCI_INFO                         = 0x080A;
	const auto MCI_GETDEVCAPS                   = 0x080B;
	const auto MCI_SPIN                         = 0x080C;
	const auto MCI_SET                          = 0x080D;
	const auto MCI_STEP                         = 0x080E;
	const auto MCI_RECORD                       = 0x080F;
	const auto MCI_SYSINFO                      = 0x0810;
	const auto MCI_BREAK                        = 0x0811;
	const auto MCI_SAVE                         = 0x0813;
	const auto MCI_STATUS                       = 0x0814;
	const auto MCI_CUE                          = 0x0830;
	const auto MCI_REALIZE                      = 0x0840;
	const auto MCI_WINDOW                       = 0x0841;
	const auto MCI_PUT                          = 0x0842;
	const auto MCI_WHERE                        = 0x0843;
	const auto MCI_FREEZE                       = 0x0844;
	const auto MCI_UNFREEZE                     = 0x0845;
	const auto MCI_LOAD                         = 0x0850;
	const auto MCI_CUT                          = 0x0851;
	const auto MCI_COPY                         = 0x0852;
	const auto MCI_PASTE                        = 0x0853;
	const auto MCI_UPDATE                       = 0x0854;
	const auto MCI_RESUME                       = 0x0855;
	const auto MCI_DELETE                       = 0x0856;
	
	/* all custom MCI command messages must be >= than this value */
	const auto MCI_USER_MESSAGES                = (DRV_MCI_FIRST + 0x400);
	const auto MCI_LAST                         = 0x0FFF;
	
	
	/* device ID for "all devices" */
	const auto MCI_ALL_DEVICE_ID                = (cast(MCIDEVICEID)-1);
	
	/* constants for predefined MCI device types */
	const auto MCI_DEVTYPE_VCR                  = 513 ; /* (MCI_STRING_OFFSET + 1) */
	const auto MCI_DEVTYPE_VIDEODISC            = 514 ; /* (MCI_STRING_OFFSET + 2) */
	const auto MCI_DEVTYPE_OVERLAY              = 515 ; /* (MCI_STRING_OFFSET + 3) */
	const auto MCI_DEVTYPE_CD_AUDIO             = 516 ; /* (MCI_STRING_OFFSET + 4) */
	const auto MCI_DEVTYPE_DAT                  = 517 ; /* (MCI_STRING_OFFSET + 5) */
	const auto MCI_DEVTYPE_SCANNER              = 518 ; /* (MCI_STRING_OFFSET + 6) */
	const auto MCI_DEVTYPE_ANIMATION            = 519 ; /* (MCI_STRING_OFFSET + 7) */
	const auto MCI_DEVTYPE_DIGITAL_VIDEO        = 520 ; /* (MCI_STRING_OFFSET + 8) */
	const auto MCI_DEVTYPE_OTHER                = 521 ; /* (MCI_STRING_OFFSET + 9) */
	const auto MCI_DEVTYPE_WAVEFORM_AUDIO       = 522 ; /* (MCI_STRING_OFFSET + 10) */
	const auto MCI_DEVTYPE_SEQUENCER            = 523 ; /* (MCI_STRING_OFFSET + 11) */
	
	const auto MCI_DEVTYPE_FIRST                = MCI_DEVTYPE_VCR;
	const auto MCI_DEVTYPE_LAST                 = MCI_DEVTYPE_SEQUENCER;
	
	const auto MCI_DEVTYPE_FIRST_USER           = 0x1000;
	/* return values for 'status mode' command */
	const auto MCI_MODE_NOT_READY               = (MCI_STRING_OFFSET + 12);
	const auto MCI_MODE_STOP                    = (MCI_STRING_OFFSET + 13);
	const auto MCI_MODE_PLAY                    = (MCI_STRING_OFFSET + 14);
	const auto MCI_MODE_RECORD                  = (MCI_STRING_OFFSET + 15);
	const auto MCI_MODE_SEEK                    = (MCI_STRING_OFFSET + 16);
	const auto MCI_MODE_PAUSE                   = (MCI_STRING_OFFSET + 17);
	const auto MCI_MODE_OPEN                    = (MCI_STRING_OFFSET + 18);
	
	/* constants used in 'set time format' and 'status time format' commands */
	const auto MCI_FORMAT_MILLISECONDS          = 0;
	const auto MCI_FORMAT_HMS                   = 1;
	const auto MCI_FORMAT_MSF                   = 2;
	const auto MCI_FORMAT_FRAMES                = 3;
	const auto MCI_FORMAT_SMPTE_24              = 4;
	const auto MCI_FORMAT_SMPTE_25              = 5;
	const auto MCI_FORMAT_SMPTE_30              = 6;
	const auto MCI_FORMAT_SMPTE_30DROP          = 7;
	const auto MCI_FORMAT_BYTES                 = 8;
	const auto MCI_FORMAT_SAMPLES               = 9;
	const auto MCI_FORMAT_TMSF                  = 10;
	
	/* MCI time format conversion macros */
	template MCI_MSF_MINUTE(T) {
		BYTE MCI_MSF_MINUTE(T msf) {
			return cast(BYTE)(msf);
		}
	}
	template MCI_MSF_SECOND(T) {
		BYTE MCI_MSF_SECOND(T msf) {
			return (cast(BYTE)((cast(WORD)(msf)) >> 8));
		}
	}
	template MCI_MSF_FRAME(T) {
		BYTE MCI_MSF_FRAME(T msf) {
			return (cast(BYTE)(msf >> 16));
		}
	}

	template MCI_MAKE_MSF(T, R, S) {
		DWORD MCI_MAKE_MSF(T m, R s, S f) {
			return (cast(DWORD)((cast(BYTE)(m) |
	                       (cast(WORD)(s)<<8)) |
	                       ((cast(DWORD)cast(BYTE)(f))<<16)));
		}
	}
	
	template MCI_TMSF_TRACK(T) {
		BYTE MCI_TMSF_TRACK(T tmsf) {
			return cast(BYTE)tmsf;
		}
	}
	template MCI_TMSF_MINUTE(T) {
		BYTE MCI_TMSF_MINUTE(T tmsf) {
			return (cast(BYTE)((cast(WORD)(tmsf)) >> 8));
		}
	}
	template MCI_TMSF_SECOND(T) {
		BYTE MCI_TMSF_SECOND(T tmsf) {
			return (cast(BYTE)(tmsf >> 16));
		}
	}
	template MCI_TMSF_FRAME(T) {
		BYTE MCI_TMSF_FRAME(T tmsf) {
			return (cast(BYTE)(tmsf >> 24));
		}
	}
	
	template MCI_MAKE_TMSF(T, R, S, Q) {
		DWORD MCI_MAKE_TMSF(T t, R m, S s, Q f) {
			return (cast(DWORD)((cast(BYTE)(t) |
	                       (cast(WORD)(m)<<8)) |
	                ((cast(DWORD)cast(BYTE)(s) |
	                (cast(WORD)(f)<<8))<<16)));
		}
	}

	template MCI_HMS_HOUR(T) {
		BYTE MCI_HMS_HOUR(T tmsf) {
			return cast(BYTE)hms;
		}
	}
	template MCI_HMS_MINUTE(T) {
		BYTE MCI_HMS_MINUTE(T hms) {
			return (cast(BYTE)((cast(WORD)(tmsf)) >> 8));
		}
	}
	template MCI_HMS_SECOND(T) {
		BYTE MCI_HMS_SECOND(T hms) {
			return (cast(BYTE)(tmsf >> 16));
		}
	}

	template MCI_MAKE_HMS(T, R, S) {
		DWORD MCI_MAKE_HMS(T h, R m, S s) {
			return MCI_MAKE_MSF(h,m,s);
		}
	}
	
	/* flags for wParam of MM_MCINOTIFY message */
	const auto MCI_NOTIFY_SUCCESSFUL            = 0x0001;
	const auto MCI_NOTIFY_SUPERSEDED            = 0x0002;
	const auto MCI_NOTIFY_ABORTED               = 0x0004;
	const auto MCI_NOTIFY_FAILURE               = 0x0008;
	
	
	/* common flags for dwFlags parameter of MCI command messages */
	const auto MCI_NOTIFY                       = 0x00000001L;
	const auto MCI_WAIT                         = 0x00000002L;
	const auto MCI_FROM                         = 0x00000004L;
	const auto MCI_TO                           = 0x00000008L;
	const auto MCI_TRACK                        = 0x00000010L;
	
	/* flags for dwFlags parameter of MCI_OPEN command message */
	const auto MCI_OPEN_SHAREABLE               = 0x00000100L;
	const auto MCI_OPEN_ELEMENT                 = 0x00000200L;
	const auto MCI_OPEN_ALIAS                   = 0x00000400L;
	const auto MCI_OPEN_ELEMENT_ID              = 0x00000800L;
	const auto MCI_OPEN_TYPE_ID                 = 0x00001000L;
	const auto MCI_OPEN_TYPE                    = 0x00002000L;
	
	/* flags for dwFlags parameter of MCI_SEEK command message */
	const auto MCI_SEEK_TO_START                = 0x00000100L;
	const auto MCI_SEEK_TO_END                  = 0x00000200L;
	
	/* flags for dwFlags parameter of MCI_STATUS command message */
	const auto MCI_STATUS_ITEM                  = 0x00000100L;
	const auto MCI_STATUS_START                 = 0x00000200L;
	
	/* flags for dwItem field of the MCI_STATUS_PARMS parameter block */
	const auto MCI_STATUS_LENGTH                = 0x00000001L;
	const auto MCI_STATUS_POSITION              = 0x00000002L;
	const auto MCI_STATUS_NUMBER_OF_TRACKS      = 0x00000003L;
	const auto MCI_STATUS_MODE                  = 0x00000004L;
	const auto MCI_STATUS_MEDIA_PRESENT         = 0x00000005L;
	const auto MCI_STATUS_TIME_FORMAT           = 0x00000006L;
	const auto MCI_STATUS_READY                 = 0x00000007L;
	const auto MCI_STATUS_CURRENT_TRACK         = 0x00000008L;
	
	/* flags for dwFlags parameter of MCI_INFO command message */
	const auto MCI_INFO_PRODUCT                 = 0x00000100L;
	const auto MCI_INFO_FILE                    = 0x00000200L;
	const auto MCI_INFO_MEDIA_UPC               = 0x00000400L;
	const auto MCI_INFO_MEDIA_IDENTITY          = 0x00000800L;
	const auto MCI_INFO_NAME                    = 0x00001000L;
	const auto MCI_INFO_COPYRIGHT               = 0x00002000L;
	
	/* flags for dwFlags parameter of MCI_GETDEVCAPS command message */
	const auto MCI_GETDEVCAPS_ITEM              = 0x00000100L;
	
	/* flags for dwItem field of the MCI_GETDEVCAPS_PARMS parameter block */
	const auto MCI_GETDEVCAPS_CAN_RECORD        = 0x00000001L;
	const auto MCI_GETDEVCAPS_HAS_AUDIO         = 0x00000002L;
	const auto MCI_GETDEVCAPS_HAS_VIDEO         = 0x00000003L;
	const auto MCI_GETDEVCAPS_DEVICE_TYPE       = 0x00000004L;
	const auto MCI_GETDEVCAPS_USES_FILES        = 0x00000005L;
	const auto MCI_GETDEVCAPS_COMPOUND_DEVICE   = 0x00000006L;
	const auto MCI_GETDEVCAPS_CAN_EJECT         = 0x00000007L;
	const auto MCI_GETDEVCAPS_CAN_PLAY          = 0x00000008L;
	const auto MCI_GETDEVCAPS_CAN_SAVE          = 0x00000009L;
	
	/* flags for dwFlags parameter of MCI_SYSINFO command message */
	const auto MCI_SYSINFO_QUANTITY             = 0x00000100L;
	const auto MCI_SYSINFO_OPEN                 = 0x00000200L;
	const auto MCI_SYSINFO_NAME                 = 0x00000400L;
	const auto MCI_SYSINFO_INSTALLNAME          = 0x00000800L;
	
	/* flags for dwFlags parameter of MCI_SET command message */
	const auto MCI_SET_DOOR_OPEN                = 0x00000100L;
	const auto MCI_SET_DOOR_CLOSED              = 0x00000200L;
	const auto MCI_SET_TIME_FORMAT              = 0x00000400L;
	const auto MCI_SET_AUDIO                    = 0x00000800L;
	const auto MCI_SET_VIDEO                    = 0x00001000L;
	const auto MCI_SET_ON                       = 0x00002000L;
	const auto MCI_SET_OFF                      = 0x00004000L;
	
	/* flags for dwAudio field of MCI_SET_PARMS or MCI_SEQ_SET_PARMS */
	const auto MCI_SET_AUDIO_ALL                = 0x00000000L;
	const auto MCI_SET_AUDIO_LEFT               = 0x00000001L;
	const auto MCI_SET_AUDIO_RIGHT              = 0x00000002L;
	
	/* flags for dwFlags parameter of MCI_BREAK command message */
	const auto MCI_BREAK_KEY                    = 0x00000100L;
	const auto MCI_BREAK_HWND                   = 0x00000200L;
	const auto MCI_BREAK_OFF                    = 0x00000400L;

	/* flags for dwFlags parameter of MCI_RECORD command message */
	const auto MCI_RECORD_INSERT                = 0x00000100L;
	const auto MCI_RECORD_OVERWRITE             = 0x00000200L;
	
	/* flags for dwFlags parameter of MCI_SAVE command message */
	const auto MCI_SAVE_FILE                    = 0x00000100L;
	
	/* flags for dwFlags parameter of MCI_LOAD command message */
	const auto MCI_LOAD_FILE                    = 0x00000100L;
	
	
	/* generic parameter block for MCI command messages with no special parameters */
	align(2) struct MCI_GENERIC_PARMS {
	    DWORD_PTR   dwCallback;
	}
	
	alias MCI_GENERIC_PARMS* PMCI_GENERIC_PARMS;
	alias MCI_GENERIC_PARMS* LPMCI_GENERIC_PARMS;
	
	
	/* parameter block for MCI_OPEN command message */
	align(2) struct MCI_OPEN_PARMSA {
	    DWORD_PTR   dwCallback;
	    MCIDEVICEID wDeviceID;
	    LPCSTR     lpstrDeviceType;
	    LPCSTR     lpstrElementName;
	    LPCSTR     lpstrAlias;
	}
	
	alias MCI_OPEN_PARMSA* PMCI_OPEN_PARMSA;
	alias MCI_OPEN_PARMSA* LPMCI_OPEN_PARMSA;
	align(2) struct MCI_OPEN_PARMSW {
	    DWORD_PTR   dwCallback;
	    MCIDEVICEID wDeviceID;
	    LPCWSTR    lpstrDeviceType;
	    LPCWSTR    lpstrElementName;
	    LPCWSTR    lpstrAlias;
	}
	
	alias MCI_OPEN_PARMSW* PMCI_OPEN_PARMSW;
	alias MCI_OPEN_PARMSW* LPMCI_OPEN_PARMSW;
	
	version(UNICODE) {
		alias MCI_OPEN_PARMSW MCI_OPEN_PARMS;
		alias PMCI_OPEN_PARMSW PMCI_OPEN_PARMS;
		alias LPMCI_OPEN_PARMSW LPMCI_OPEN_PARMS;
	}
	else {
		alias MCI_OPEN_PARMSA MCI_OPEN_PARMS;
		alias PMCI_OPEN_PARMSA PMCI_OPEN_PARMS;
		alias LPMCI_OPEN_PARMSA LPMCI_OPEN_PARMS;
	}
	
	/* parameter block for MCI_PLAY command message */
	align(2) struct MCI_PLAY_PARMS {
	    DWORD_PTR   dwCallback;
	    DWORD       dwFrom;
	    DWORD       dwTo;
	}
	
	alias MCI_PLAY_PARMS* PMCI_PLAY_PARMS;
	alias MCI_PLAY_PARMS* LPMCI_PLAY_PARMS;
	
	
	/* parameter block for MCI_SEEK command message */
	align(2) struct MCI_SEEK_PARMS {
	    DWORD_PTR   dwCallback;
	    DWORD       dwTo;
	}
	
	alias MCI_SEEK_PARMS* PMCI_SEEK_PARMS;
	alias MCI_SEEK_PARMS* LPMCI_SEEK_PARMS;
	
	
	/* parameter block for MCI_STATUS command message */
	align(2) struct MCI_STATUS_PARMS {
	    DWORD_PTR   dwCallback;
	    DWORD_PTR   dwReturn;
	    DWORD       dwItem;
	    DWORD       dwTrack;
	}
	
	alias MCI_STATUS_PARMS* PMCI_STATUS_PARMS;
	alias MCI_STATUS_PARMS*  LPMCI_STATUS_PARMS;
	
	
	/* parameter block for MCI_INFO command message */
	align(2) struct MCI_INFO_PARMSA {
	    DWORD_PTR dwCallback;
	    LPSTR     lpstrReturn;
	    DWORD     dwRetSize;
	}
	
	alias MCI_INFO_PARMSA*  LPMCI_INFO_PARMSA;
	align(2) struct MCI_INFO_PARMSW {
	    DWORD_PTR dwCallback;
	    LPWSTR    lpstrReturn;
	    DWORD     dwRetSize;
	}
	
	alias MCI_INFO_PARMSW*  LPMCI_INFO_PARMSW;
	
	version(UNICODE) {
		alias MCI_INFO_PARMSW MCI_INFO_PARMS;
		alias LPMCI_INFO_PARMSW LPMCI_INFO_PARMS;
	}
	else {
		alias MCI_INFO_PARMSA MCI_INFO_PARMS;
		alias LPMCI_INFO_PARMSA LPMCI_INFO_PARMS;
	}
	
	/* parameter block for MCI_GETDEVCAPS command message */
	align(2) struct MCI_GETDEVCAPS_PARMS {
	    DWORD_PTR   dwCallback;
	    DWORD       dwReturn;
	    DWORD       dwItem;
	}
	
	alias MCI_GETDEVCAPS_PARMS* PMCI_GETDEVCAPS_PARMS;
	alias MCI_GETDEVCAPS_PARMS*  LPMCI_GETDEVCAPS_PARMS;
	
	/* parameter block for MCI_SYSINFO command message */
	align(2) struct MCI_SYSINFO_PARMSA {
	    DWORD_PTR   dwCallback;
	    LPSTR       lpstrReturn;
	    DWORD       dwRetSize;
	    DWORD       dwNumber;
	    UINT        wDeviceType;
	}
	
	alias MCI_SYSINFO_PARMSA* PMCI_SYSINFO_PARMSA;
	alias MCI_SYSINFO_PARMSA*  LPMCI_SYSINFO_PARMSA;
	align(2) struct MCI_SYSINFO_PARMSW {
	    DWORD_PTR   dwCallback;
	    LPWSTR      lpstrReturn;
	    DWORD       dwRetSize;
	    DWORD       dwNumber;
	    UINT        wDeviceType;
	}
	
	alias MCI_SYSINFO_PARMSW* PMCI_SYSINFO_PARMSW;
	alias MCI_SYSINFO_PARMSW*  LPMCI_SYSINFO_PARMSW;
	
	version(UNICODE) {
		alias MCI_SYSINFO_PARMSW MCI_SYSINFO_PARMS;
		alias PMCI_SYSINFO_PARMSW PMCI_SYSINFO_PARMS;
		alias LPMCI_SYSINFO_PARMSW LPMCI_SYSINFO_PARMS;
	}
	else {
		alias MCI_SYSINFO_PARMSA MCI_SYSINFO_PARMS;
		alias PMCI_SYSINFO_PARMSA PMCI_SYSINFO_PARMS;
		alias LPMCI_SYSINFO_PARMSA LPMCI_SYSINFO_PARMS;
	}
	
	/* parameter block for MCI_SET command message */
	align(2) struct MCI_SET_PARMS {
	    DWORD_PTR   dwCallback;
	    DWORD       dwTimeFormat;
	    DWORD       dwAudio;
	}
	
	alias MCI_SET_PARMS* PMCI_SET_PARMS;
	alias MCI_SET_PARMS* LPMCI_SET_PARMS;
	
	
	/* parameter block for MCI_BREAK command message */
	align(2) struct MCI_BREAK_PARMS {
	    DWORD_PTR   dwCallback;
	    int         nVirtKey;
	    HWND        hwndBreak;
	}
	
	alias MCI_BREAK_PARMS* PMCI_BREAK_PARMS;
	alias MCI_BREAK_PARMS*  LPMCI_BREAK_PARMS;
	
	
	/* parameter block for MCI_SAVE command message */
	
	align(2) struct MCI_SAVE_PARMSA {
	    DWORD_PTR    dwCallback;
	    LPCSTR       lpfilename;
	}
	
	alias MCI_SAVE_PARMSA* PMCI_SAVE_PARMSA;
	alias MCI_SAVE_PARMSA*  LPMCI_SAVE_PARMSA;
	align(2) struct MCI_SAVE_PARMSW {
	    DWORD_PTR    dwCallback;
	    LPCWSTR      lpfilename;
	}
	
	alias MCI_SAVE_PARMSW* PMCI_SAVE_PARMSW;
	alias MCI_SAVE_PARMSW*  LPMCI_SAVE_PARMSW;
	
	version(UNICODE) {
		alias MCI_SAVE_PARMSW MCI_SAVE_PARMS;
		alias PMCI_SAVE_PARMSW PMCI_SAVE_PARMS;
		alias LPMCI_SAVE_PARMSW LPMCI_SAVE_PARMS;
	}
	else {
		alias MCI_SAVE_PARMSA MCI_SAVE_PARMS;
		alias PMCI_SAVE_PARMSA PMCI_SAVE_PARMS;
		alias LPMCI_SAVE_PARMSA LPMCI_SAVE_PARMS;
	}
	
	/* parameter block for MCI_LOAD command message */
	align(2) struct MCI_LOAD_PARMSA {
	    DWORD_PTR    dwCallback;
	    LPCSTR       lpfilename;
	}
	
	alias MCI_LOAD_PARMSA* PMCI_LOAD_PARMSA;
	alias MCI_LOAD_PARMSA*  LPMCI_LOAD_PARMSA;
	align(2) struct MCI_LOAD_PARMSW {
	    DWORD_PTR    dwCallback;
	    LPCWSTR      lpfilename;
	}
	
	alias MCI_LOAD_PARMSW* PMCI_LOAD_PARMSW;
	alias MCI_LOAD_PARMSW*  LPMCI_LOAD_PARMSW;
	
	version(UNICODE) {
		alias MCI_LOAD_PARMSW MCI_LOAD_PARMS;
		alias PMCI_LOAD_PARMSW PMCI_LOAD_PARMS;
		alias LPMCI_LOAD_PARMSW LPMCI_LOAD_PARMS;
	}
	else {
		alias MCI_LOAD_PARMSA MCI_LOAD_PARMS;
		alias PMCI_LOAD_PARMSA PMCI_LOAD_PARMS;
		alias LPMCI_LOAD_PARMSA LPMCI_LOAD_PARMS;
	}
	
	/* parameter block for MCI_RECORD command message */
	align(2) struct MCI_RECORD_PARMS {
	    DWORD_PTR   dwCallback;
	    DWORD       dwFrom;
	    DWORD       dwTo;
	}
	
	alias MCI_RECORD_PARMS* LPMCI_RECORD_PARMS;
	
	
	/* MCI extensions for videodisc devices */
	
	/* flag for dwReturn field of MCI_STATUS_PARMS */
	/* MCI_STATUS command, (dwItem == MCI_STATUS_MODE) */
	const auto MCI_VD_MODE_PARK                 = (MCI_VD_OFFSET + 1);
	
	/* flag for dwReturn field of MCI_STATUS_PARMS */
	/* MCI_STATUS command, (dwItem == MCI_VD_STATUS_MEDIA_TYPE) */
	const auto MCI_VD_MEDIA_CLV                 = (MCI_VD_OFFSET + 2);
	const auto MCI_VD_MEDIA_CAV                 = (MCI_VD_OFFSET + 3);
	const auto MCI_VD_MEDIA_OTHER               = (MCI_VD_OFFSET + 4);
	
	const auto MCI_VD_FORMAT_TRACK              = 0x4001;
	
	/* flags for dwFlags parameter of MCI_PLAY command message */
	const auto MCI_VD_PLAY_REVERSE              = 0x00010000L;
	const auto MCI_VD_PLAY_FAST                 = 0x00020000L;
	const auto MCI_VD_PLAY_SPEED                = 0x00040000L;
	const auto MCI_VD_PLAY_SCAN                 = 0x00080000L;
	const auto MCI_VD_PLAY_SLOW                 = 0x00100000L;
	
	/* flag for dwFlags parameter of MCI_SEEK command message */
	const auto MCI_VD_SEEK_REVERSE              = 0x00010000L;
	
	/* flags for dwItem field of MCI_STATUS_PARMS parameter block */
	const auto MCI_VD_STATUS_SPEED              = 0x00004002L;
	const auto MCI_VD_STATUS_FORWARD            = 0x00004003L;
	const auto MCI_VD_STATUS_MEDIA_TYPE         = 0x00004004L;
	const auto MCI_VD_STATUS_SIDE               = 0x00004005L;
	const auto MCI_VD_STATUS_DISC_SIZE          = 0x00004006L;
	
	/* flags for dwFlags parameter of MCI_GETDEVCAPS command message */
	const auto MCI_VD_GETDEVCAPS_CLV            = 0x00010000L;
	const auto MCI_VD_GETDEVCAPS_CAV            = 0x00020000L;
	
	const auto MCI_VD_SPIN_UP                   = 0x00010000L;
	const auto MCI_VD_SPIN_DOWN                 = 0x00020000L;
	
	/* flags for dwItem field of MCI_GETDEVCAPS_PARMS parameter block */
	const auto MCI_VD_GETDEVCAPS_CAN_REVERSE    = 0x00004002L;
	const auto MCI_VD_GETDEVCAPS_FAST_RATE      = 0x00004003L;
	const auto MCI_VD_GETDEVCAPS_SLOW_RATE      = 0x00004004L;
	const auto MCI_VD_GETDEVCAPS_NORMAL_RATE    = 0x00004005L;
	
	/* flags for the dwFlags parameter of MCI_STEP command message */
	const auto MCI_VD_STEP_FRAMES               = 0x00010000L;
	const auto MCI_VD_STEP_REVERSE              = 0x00020000L;
	
	/* flag for the MCI_ESCAPE command message */
	const auto MCI_VD_ESCAPE_STRING             = 0x00000100L;
	
	
	/* parameter block for MCI_PLAY command message */
	align(2) struct MCI_VD_PLAY_PARMS {
	    DWORD_PTR   dwCallback;
	    DWORD       dwFrom;
	    DWORD       dwTo;
	    DWORD       dwSpeed;
	}
	
	alias MCI_VD_PLAY_PARMS* PMCI_VD_PLAY_PARMS;
	alias MCI_VD_PLAY_PARMS* LPMCI_VD_PLAY_PARMS;
	
	
	/* parameter block for MCI_STEP command message */
	align(2) struct MCI_VD_STEP_PARMS {
	    DWORD_PTR   dwCallback;
	    DWORD       dwFrames;
	}
	
	alias MCI_VD_STEP_PARMS* PMCI_VD_STEP_PARMS;
	alias MCI_VD_STEP_PARMS* LPMCI_VD_STEP_PARMS;
	
	
	/* parameter block for MCI_ESCAPE command message */
	align(2) struct MCI_VD_ESCAPE_PARMSA {
	    DWORD_PTR   dwCallback;
	    LPCSTR      lpstrCommand;
	}
	
	alias MCI_VD_ESCAPE_PARMSA* PMCI_VD_ESCAPE_PARMSA;
	alias MCI_VD_ESCAPE_PARMSA* LPMCI_VD_ESCAPE_PARMSA;
	align(2) struct MCI_VD_ESCAPE_PARMSW {
	    DWORD_PTR   dwCallback;
	    LPCWSTR     lpstrCommand;
	}
	
	alias MCI_VD_ESCAPE_PARMSW* PMCI_VD_ESCAPE_PARMSW;
	alias MCI_VD_ESCAPE_PARMSW* LPMCI_VD_ESCAPE_PARMSW;
	
	version(UNICODE) {
		alias MCI_VD_ESCAPE_PARMSW MCI_VD_ESCAPE_PARMS;
		alias PMCI_VD_ESCAPE_PARMSW PMCI_VD_ESCAPE_PARMS;
		alias LPMCI_VD_ESCAPE_PARMSW LPMCI_VD_ESCAPE_PARMS;
	}
	else {
		alias MCI_VD_ESCAPE_PARMSA MCI_VD_ESCAPE_PARMS;
		alias PMCI_VD_ESCAPE_PARMSA PMCI_VD_ESCAPE_PARMS;
		alias LPMCI_VD_ESCAPE_PARMSA LPMCI_VD_ESCAPE_PARMS;
	}
	
	/* MCI extensions for CD audio devices */
	
	/* flags for the dwItem field of the MCI_STATUS_PARMS parameter block */
	const auto MCI_CDA_STATUS_TYPE_TRACK        = 0x00004001L;
	
	/* flags for the dwReturn field of MCI_STATUS_PARMS parameter block */
	/* MCI_STATUS command, (dwItem == MCI_CDA_STATUS_TYPE_TRACK) */
	const auto MCI_CDA_TRACK_AUDIO              = (MCI_CD_OFFSET + 0);
	const auto MCI_CDA_TRACK_OTHER              = (MCI_CD_OFFSET + 1);
	
	/* MCI extensions for waveform audio devices */
	
	const auto MCI_WAVE_PCM                     = (MCI_WAVE_OFFSET + 0);
	const auto MCI_WAVE_MAPPER                  = (MCI_WAVE_OFFSET + 1);
	
	/* flags for the dwFlags parameter of MCI_OPEN command message */
	const auto MCI_WAVE_OPEN_BUFFER             = 0x00010000L;
	
	/* flags for the dwFlags parameter of MCI_SET command message */
	const auto MCI_WAVE_SET_FORMATTAG           = 0x00010000L;
	const auto MCI_WAVE_SET_CHANNELS            = 0x00020000L;
	const auto MCI_WAVE_SET_SAMPLESPERSEC       = 0x00040000L;
	const auto MCI_WAVE_SET_AVGBYTESPERSEC      = 0x00080000L;
	const auto MCI_WAVE_SET_BLOCKALIGN          = 0x00100000L;
	const auto MCI_WAVE_SET_BITSPERSAMPLE       = 0x00200000L;
	
	/* flags for the dwFlags parameter of MCI_STATUS, MCI_SET command messages */
	const auto MCI_WAVE_INPUT                   = 0x00400000L;
	const auto MCI_WAVE_OUTPUT                  = 0x00800000L;
	
	/* flags for the dwItem field of MCI_STATUS_PARMS parameter block */
	const auto MCI_WAVE_STATUS_FORMATTAG        = 0x00004001L;
	const auto MCI_WAVE_STATUS_CHANNELS         = 0x00004002L;
	const auto MCI_WAVE_STATUS_SAMPLESPERSEC    = 0x00004003L;
	const auto MCI_WAVE_STATUS_AVGBYTESPERSEC   = 0x00004004L;
	const auto MCI_WAVE_STATUS_BLOCKALIGN       = 0x00004005L;
	const auto MCI_WAVE_STATUS_BITSPERSAMPLE    = 0x00004006L;
	const auto MCI_WAVE_STATUS_LEVEL            = 0x00004007L;
	
	/* flags for the dwFlags parameter of MCI_SET command message */
	const auto MCI_WAVE_SET_ANYINPUT            = 0x04000000L;
	const auto MCI_WAVE_SET_ANYOUTPUT           = 0x08000000L;
	
	/* flags for the dwFlags parameter of MCI_GETDEVCAPS command message */
	const auto MCI_WAVE_GETDEVCAPS_INPUTS       = 0x00004001L;
	const auto MCI_WAVE_GETDEVCAPS_OUTPUTS      = 0x00004002L;
	
	
	/* parameter block for MCI_OPEN command message */
	align(2) struct MCI_WAVE_OPEN_PARMSA {
	    DWORD_PTR   dwCallback;
	    MCIDEVICEID wDeviceID;
	    LPCSTR     lpstrDeviceType;
	    LPCSTR     lpstrElementName;
	    LPCSTR     lpstrAlias;
	    DWORD   dwBufferSeconds;
	}
	
	alias MCI_WAVE_OPEN_PARMSA* PMCI_WAVE_OPEN_PARMSA;
	alias MCI_WAVE_OPEN_PARMSA* LPMCI_WAVE_OPEN_PARMSA;
	
	align(2) struct MCI_WAVE_OPEN_PARMSW {
	    DWORD_PTR   dwCallback;
	    MCIDEVICEID wDeviceID;
	    LPCWSTR    lpstrDeviceType;
	    LPCWSTR    lpstrElementName;
	    LPCWSTR    lpstrAlias;
	    DWORD   dwBufferSeconds;
	}
	
	alias MCI_WAVE_OPEN_PARMSW* PMCI_WAVE_OPEN_PARMSW;
	alias MCI_WAVE_OPEN_PARMSW* LPMCI_WAVE_OPEN_PARMSW;
	
	version(UNICODE) {
		alias MCI_WAVE_OPEN_PARMSW MCI_WAVE_OPEN_PARMS;
		alias PMCI_WAVE_OPEN_PARMSW PMCI_WAVE_OPEN_PARMS;
		alias LPMCI_WAVE_OPEN_PARMSW LPMCI_WAVE_OPEN_PARMS;
	}
	else {
		alias MCI_WAVE_OPEN_PARMSA MCI_WAVE_OPEN_PARMS;
		alias PMCI_WAVE_OPEN_PARMSA PMCI_WAVE_OPEN_PARMS;
		alias LPMCI_WAVE_OPEN_PARMSA LPMCI_WAVE_OPEN_PARMS;
	}
	
	/* parameter block for MCI_DELETE command message */
	align(2) struct MCI_WAVE_DELETE_PARMS {
	    DWORD_PTR   dwCallback;
	    DWORD       dwFrom;
	    DWORD       dwTo;
	}
	
	alias MCI_WAVE_DELETE_PARMS* PMCI_WAVE_DELETE_PARMS;
	alias MCI_WAVE_DELETE_PARMS* LPMCI_WAVE_DELETE_PARMS;
	
	
	/* parameter block for MCI_SET command message */
	align(2) struct MCI_WAVE_SET_PARMS {
	    DWORD_PTR   dwCallback;
	    DWORD       dwTimeFormat;
	    DWORD       dwAudio;
	    UINT    wInput;
	    UINT    wOutput;
	    WORD    wFormatTag;
	    WORD    wReserved2;
	    WORD    nChannels;
	    WORD    wReserved3;
	    DWORD   nSamplesPerSec;
	    DWORD   nAvgBytesPerSec;
	    WORD    nBlockAlign;
	    WORD    wReserved4;
	    WORD    wBitsPerSample;
	    WORD    wReserved5;
	}
	
	alias MCI_WAVE_SET_PARMS* PMCI_WAVE_SET_PARMS;
	alias MCI_WAVE_SET_PARMS*  LPMCI_WAVE_SET_PARMS;
	
	
	/* MCI extensions for MIDI sequencer devices */
	
	/* flags for the dwReturn field of MCI_STATUS_PARMS parameter block */
	/* MCI_STATUS command, (dwItem == MCI_SEQ_STATUS_DIVTYPE) */
	const auto      MCI_SEQ_DIV_PPQN            = (0 + MCI_SEQ_OFFSET);
	const auto      MCI_SEQ_DIV_SMPTE_24        = (1 + MCI_SEQ_OFFSET);
	const auto      MCI_SEQ_DIV_SMPTE_25        = (2 + MCI_SEQ_OFFSET);
	const auto      MCI_SEQ_DIV_SMPTE_30DROP    = (3 + MCI_SEQ_OFFSET);
	const auto      MCI_SEQ_DIV_SMPTE_30        = (4 + MCI_SEQ_OFFSET);

	/* flags for the dwMaster field of MCI_SEQ_SET_PARMS parameter block */
	/* MCI_SET command, (dwFlags == MCI_SEQ_SET_MASTER) */
	const auto      MCI_SEQ_FORMAT_SONGPTR      = 0x4001;
	const auto      MCI_SEQ_FILE                = 0x4002;
	const auto      MCI_SEQ_MIDI                = 0x4003;
	const auto      MCI_SEQ_SMPTE               = 0x4004;
	const auto      MCI_SEQ_NONE                = 65533;
	const auto      MCI_SEQ_MAPPER              = 65535;

	/* flags for the dwItem field of MCI_STATUS_PARMS parameter block */
	const auto MCI_SEQ_STATUS_TEMPO             = 0x00004002;
	const auto MCI_SEQ_STATUS_PORT              = 0x00004003;
	const auto MCI_SEQ_STATUS_SLAVE             = 0x00004007;
	const auto MCI_SEQ_STATUS_MASTER            = 0x00004008;
	const auto MCI_SEQ_STATUS_OFFSET            = 0x00004009;
	const auto MCI_SEQ_STATUS_DIVTYPE           = 0x0000400A;
	const auto MCI_SEQ_STATUS_NAME              = 0x0000400B;
	const auto MCI_SEQ_STATUS_COPYRIGHT         = 0x0000400C;
	
	/* flags for the dwFlags parameter of MCI_SET command message */
	const auto MCI_SEQ_SET_TEMPO                = 0x00010000L;
	const auto MCI_SEQ_SET_PORT                 = 0x00020000L;
	const auto MCI_SEQ_SET_SLAVE                = 0x00040000L;
	const auto MCI_SEQ_SET_MASTER               = 0x00080000L;
	const auto MCI_SEQ_SET_OFFSET               = 0x01000000L;
	
	
	/* parameter block for MCI_SET command message */
	align(2) struct MCI_SEQ_SET_PARMS {
	    DWORD_PTR   dwCallback;
	    DWORD       dwTimeFormat;
	    DWORD       dwAudio;
	    DWORD       dwTempo;
	    DWORD       dwPort;
	    DWORD       dwSlave;
	    DWORD       dwMaster;
	    DWORD       dwOffset;
	}
	
	alias MCI_SEQ_SET_PARMS* PMCI_SEQ_SET_PARMS;
	alias MCI_SEQ_SET_PARMS*  LPMCI_SEQ_SET_PARMS;
	
	
	/* MCI extensions for animation devices */
	
	/* flags for dwFlags parameter of MCI_OPEN command message */
	const auto MCI_ANIM_OPEN_WS                 = 0x00010000L;
	const auto MCI_ANIM_OPEN_PARENT             = 0x00020000L;
	const auto MCI_ANIM_OPEN_NOSTATIC           = 0x00040000L;
	
	/* flags for dwFlags parameter of MCI_PLAY command message */
	const auto MCI_ANIM_PLAY_SPEED              = 0x00010000L;
	const auto MCI_ANIM_PLAY_REVERSE            = 0x00020000L;
	const auto MCI_ANIM_PLAY_FAST               = 0x00040000L;
	const auto MCI_ANIM_PLAY_SLOW               = 0x00080000L;
	const auto MCI_ANIM_PLAY_SCAN               = 0x00100000L;
	
	/* flags for dwFlags parameter of MCI_STEP command message */
	const auto MCI_ANIM_STEP_REVERSE            = 0x00010000L;
	const auto MCI_ANIM_STEP_FRAMES             = 0x00020000L;
	
	/* flags for dwItem field of MCI_STATUS_PARMS parameter block */
	const auto MCI_ANIM_STATUS_SPEED            = 0x00004001L;
	const auto MCI_ANIM_STATUS_FORWARD          = 0x00004002L;
	const auto MCI_ANIM_STATUS_HWND             = 0x00004003L;
	const auto MCI_ANIM_STATUS_HPAL             = 0x00004004L;
	const auto MCI_ANIM_STATUS_STRETCH          = 0x00004005L;
	
	/* flags for the dwFlags parameter of MCI_INFO command message */
	const auto MCI_ANIM_INFO_TEXT               = 0x00010000L;
	
	/* flags for dwItem field of MCI_GETDEVCAPS_PARMS parameter block */
	const auto MCI_ANIM_GETDEVCAPS_CAN_REVERSE  = 0x00004001L;
	const auto MCI_ANIM_GETDEVCAPS_FAST_RATE    = 0x00004002L;
	const auto MCI_ANIM_GETDEVCAPS_SLOW_RATE    = 0x00004003L;
	const auto MCI_ANIM_GETDEVCAPS_NORMAL_RATE  = 0x00004004L;
	const auto MCI_ANIM_GETDEVCAPS_PALETTES     = 0x00004006L;
	const auto MCI_ANIM_GETDEVCAPS_CAN_STRETCH  = 0x00004007L;
	const auto MCI_ANIM_GETDEVCAPS_MAX_WINDOWS  = 0x00004008L;
	
	/* flags for the MCI_REALIZE command message */
	const auto MCI_ANIM_REALIZE_NORM            = 0x00010000L;
	const auto MCI_ANIM_REALIZE_BKGD            = 0x00020000L;
	
	/* flags for dwFlags parameter of MCI_WINDOW command message */
	const auto MCI_ANIM_WINDOW_HWND             = 0x00010000L;
	const auto MCI_ANIM_WINDOW_STATE            = 0x00040000L;
	const auto MCI_ANIM_WINDOW_TEXT             = 0x00080000L;
	const auto MCI_ANIM_WINDOW_ENABLE_STRETCH   = 0x00100000L;
	const auto MCI_ANIM_WINDOW_DISABLE_STRETCH  = 0x00200000L;
	
	/* flags for hWnd field of MCI_ANIM_WINDOW_PARMS parameter block */
	/* MCI_WINDOW command message, (dwFlags == MCI_ANIM_WINDOW_HWND) */
	const auto MCI_ANIM_WINDOW_DEFAULT          = 0x00000000L;
	
	/* flags for dwFlags parameter of MCI_PUT command message */
	const auto MCI_ANIM_RECT                    = 0x00010000L;
	const auto MCI_ANIM_PUT_SOURCE              = 0x00020000L;
	const auto MCI_ANIM_PUT_DESTINATION         = 0x00040000L;
	
	/* flags for dwFlags parameter of MCI_WHERE command message */
	const auto MCI_ANIM_WHERE_SOURCE            = 0x00020000L;
	const auto MCI_ANIM_WHERE_DESTINATION       = 0x00040000L;
	
	/* flags for dwFlags parameter of MCI_UPDATE command message */
	const auto MCI_ANIM_UPDATE_HDC              = 0x00020000L;
	
	
	/* parameter block for MCI_OPEN command message */
	align(2) struct MCI_ANIM_OPEN_PARMSA {
	    DWORD_PTR   dwCallback;
	    MCIDEVICEID wDeviceID;
	    LPCSTR      lpstrDeviceType;
	    LPCSTR      lpstrElementName;
	    LPCSTR      lpstrAlias;
	    DWORD   dwStyle;
	    HWND    hWndParent;
	}
	
	alias MCI_ANIM_OPEN_PARMSA* PMCI_ANIM_OPEN_PARMSA;
	alias MCI_ANIM_OPEN_PARMSA* LPMCI_ANIM_OPEN_PARMSA;
	align(2) struct MCI_ANIM_OPEN_PARMSW {
	    DWORD_PTR   dwCallback;
	    MCIDEVICEID wDeviceID;
	    LPCWSTR     lpstrDeviceType;
	    LPCWSTR     lpstrElementName;
	    LPCWSTR     lpstrAlias;
	    DWORD   dwStyle;
	    HWND    hWndParent;
	}
	
	alias MCI_ANIM_OPEN_PARMSW* PMCI_ANIM_OPEN_PARMSW;
	alias MCI_ANIM_OPEN_PARMSW* LPMCI_ANIM_OPEN_PARMSW;
	
	version(UNICODE) {
		alias MCI_ANIM_OPEN_PARMSW MCI_ANIM_OPEN_PARMS;
		alias PMCI_ANIM_OPEN_PARMSW PMCI_ANIM_OPEN_PARMS;
		alias LPMCI_ANIM_OPEN_PARMSW LPMCI_ANIM_OPEN_PARMS;
	}
	else {
		alias MCI_ANIM_OPEN_PARMSA MCI_ANIM_OPEN_PARMS;
		alias PMCI_ANIM_OPEN_PARMSA PMCI_ANIM_OPEN_PARMS;
		alias LPMCI_ANIM_OPEN_PARMSA LPMCI_ANIM_OPEN_PARMS;
	}
	
	/* parameter block for MCI_PLAY command message */
	align(2) struct MCI_ANIM_PLAY_PARMS {
	    DWORD_PTR   dwCallback;
	    DWORD       dwFrom;
	    DWORD       dwTo;
	    DWORD       dwSpeed;
	}
	
	alias MCI_ANIM_PLAY_PARMS* PMCI_ANIM_PLAY_PARMS;
	alias MCI_ANIM_PLAY_PARMS* LPMCI_ANIM_PLAY_PARMS;
	
	/* parameter block for MCI_STEP command message */
	align(2) struct MCI_ANIM_STEP_PARMS {
	    DWORD_PTR   dwCallback;
	    DWORD       dwFrames;
	}
	
	alias MCI_ANIM_STEP_PARMS* PMCI_ANIM_STEP_PARMS;
	alias MCI_ANIM_STEP_PARMS* LPMCI_ANIM_STEP_PARMS;
	
	/* parameter block for MCI_WINDOW command message */
	align(2) struct MCI_ANIM_WINDOW_PARMSA {
	    DWORD_PTR   dwCallback;
	    HWND        hWnd;
	    UINT        nCmdShow;
	    LPCSTR     lpstrText;
	}
	
	alias MCI_ANIM_WINDOW_PARMSA* PMCI_ANIM_WINDOW_PARMSA;
	alias MCI_ANIM_WINDOW_PARMSA*  LPMCI_ANIM_WINDOW_PARMSA;
	align(2) struct MCI_ANIM_WINDOW_PARMSW {
	    DWORD_PTR   dwCallback;
	    HWND        hWnd;
	    UINT        nCmdShow;
	    LPCWSTR    lpstrText;
	}
	
	alias MCI_ANIM_WINDOW_PARMSW* PMCI_ANIM_WINDOW_PARMSW;
	alias MCI_ANIM_WINDOW_PARMSW*  LPMCI_ANIM_WINDOW_PARMSW;
	
	version(UNICODE) {
		alias MCI_ANIM_WINDOW_PARMSW MCI_ANIM_WINDOW_PARMS;
		alias PMCI_ANIM_WINDOW_PARMSW PMCI_ANIM_WINDOW_PARMS;
		alias LPMCI_ANIM_WINDOW_PARMSW LPMCI_ANIM_WINDOW_PARMS;
	}
	else {
		alias MCI_ANIM_WINDOW_PARMSA MCI_ANIM_WINDOW_PARMS;
		alias PMCI_ANIM_WINDOW_PARMSA PMCI_ANIM_WINDOW_PARMS;
		alias LPMCI_ANIM_WINDOW_PARMSA LPMCI_ANIM_WINDOW_PARMS;
	}
	
	/* parameter block for MCI_PUT, MCI_UPDATE, MCI_WHERE command messages */
	align(2) struct MCI_ANIM_RECT_PARMS {
	    DWORD_PTR   dwCallback;
		version(MCI_USE_OFFEXT) {
		    POINT   ptOffset;
		    POINT   ptExtent;
		}
		else {   /* !MCI_USE_OFFEXT */
		    RECT    rc;
		}
	}
	
	alias MCI_ANIM_RECT_PARMS * PMCI_ANIM_RECT_PARMS;
	alias MCI_ANIM_RECT_PARMS * LPMCI_ANIM_RECT_PARMS;
	
	/* parameter block for MCI_UPDATE PARMS */
	align(2) struct MCI_ANIM_UPDATE_PARMS {
	    DWORD_PTR   dwCallback;
	    RECT        rc;
	    HDC         hDC;
	}
	
	alias MCI_ANIM_UPDATE_PARMS* PMCI_ANIM_UPDATE_PARMS;
	alias MCI_ANIM_UPDATE_PARMS*  LPMCI_ANIM_UPDATE_PARMS;
	
	/* MCI extensions for video overlay devices */
	
	/* flags for dwFlags parameter of MCI_OPEN command message */
	const auto MCI_OVLY_OPEN_WS                 = 0x00010000L;
	const auto MCI_OVLY_OPEN_PARENT             = 0x00020000L;
	
	/* flags for dwFlags parameter of MCI_STATUS command message */
	const auto MCI_OVLY_STATUS_HWND             = 0x00004001L;
	const auto MCI_OVLY_STATUS_STRETCH          = 0x00004002L;
	
	/* flags for dwFlags parameter of MCI_INFO command message */
	const auto MCI_OVLY_INFO_TEXT               = 0x00010000L;
	
	/* flags for dwItem field of MCI_GETDEVCAPS_PARMS parameter block */
	const auto MCI_OVLY_GETDEVCAPS_CAN_STRETCH  = 0x00004001L;
	const auto MCI_OVLY_GETDEVCAPS_CAN_FREEZE   = 0x00004002L;
	const auto MCI_OVLY_GETDEVCAPS_MAX_WINDOWS  = 0x00004003L;
	
	/* flags for dwFlags parameter of MCI_WINDOW command message */
	const auto MCI_OVLY_WINDOW_HWND             = 0x00010000L;
	const auto MCI_OVLY_WINDOW_STATE            = 0x00040000L;
	const auto MCI_OVLY_WINDOW_TEXT             = 0x00080000L;
	const auto MCI_OVLY_WINDOW_ENABLE_STRETCH   = 0x00100000L;
	const auto MCI_OVLY_WINDOW_DISABLE_STRETCH  = 0x00200000L;
	
	/* flags for hWnd parameter of MCI_OVLY_WINDOW_PARMS parameter block */
	const auto MCI_OVLY_WINDOW_DEFAULT          = 0x00000000L;
	
	/* flags for dwFlags parameter of MCI_PUT command message */
	const auto MCI_OVLY_RECT                    = 0x00010000L;
	const auto MCI_OVLY_PUT_SOURCE              = 0x00020000L;
	const auto MCI_OVLY_PUT_DESTINATION         = 0x00040000L;
	const auto MCI_OVLY_PUT_FRAME               = 0x00080000L;
	const auto MCI_OVLY_PUT_VIDEO               = 0x00100000L;
	
	/* flags for dwFlags parameter of MCI_WHERE command message */
	const auto MCI_OVLY_WHERE_SOURCE            = 0x00020000L;
	const auto MCI_OVLY_WHERE_DESTINATION       = 0x00040000L;
	const auto MCI_OVLY_WHERE_FRAME             = 0x00080000L;
	const auto MCI_OVLY_WHERE_VIDEO             = 0x00100000L;
	
	
	/* parameter block for MCI_OPEN command message */
	align(2) struct MCI_OVLY_OPEN_PARMSA {
	    DWORD_PTR   dwCallback;
	    MCIDEVICEID wDeviceID;
	    LPCSTR      lpstrDeviceType;
	    LPCSTR      lpstrElementName;
	    LPCSTR      lpstrAlias;
	    DWORD   dwStyle;
	    HWND    hWndParent;
	}
	
	alias MCI_OVLY_OPEN_PARMSA* PMCI_OVLY_OPEN_PARMSA;
	alias MCI_OVLY_OPEN_PARMSA* LPMCI_OVLY_OPEN_PARMSA;
	align(2) struct MCI_OVLY_OPEN_PARMSW {
	    DWORD_PTR   dwCallback;
	    MCIDEVICEID wDeviceID;
	    LPCWSTR     lpstrDeviceType;
	    LPCWSTR     lpstrElementName;
	    LPCWSTR     lpstrAlias;
	    DWORD   dwStyle;
	    HWND    hWndParent;
	}
	
	alias MCI_OVLY_OPEN_PARMSW* PMCI_OVLY_OPEN_PARMSW;
	alias MCI_OVLY_OPEN_PARMSW* LPMCI_OVLY_OPEN_PARMSW;
	
	version(UNICODE) {
		alias MCI_OVLY_OPEN_PARMSW MCI_OVLY_OPEN_PARMS;
		alias PMCI_OVLY_OPEN_PARMSW PMCI_OVLY_OPEN_PARMS;
		alias LPMCI_OVLY_OPEN_PARMSW LPMCI_OVLY_OPEN_PARMS;
	}
	else {
		alias MCI_OVLY_OPEN_PARMSA MCI_OVLY_OPEN_PARMS;
		alias PMCI_OVLY_OPEN_PARMSA PMCI_OVLY_OPEN_PARMS;
		alias LPMCI_OVLY_OPEN_PARMSA LPMCI_OVLY_OPEN_PARMS;
	}
	
	/* parameter block for MCI_WINDOW command message */
	align(2) struct MCI_OVLY_WINDOW_PARMSA {
	    DWORD_PTR   dwCallback;
	    HWND        hWnd;
	    UINT        nCmdShow;
	    LPCSTR      lpstrText;
	}
	
	alias MCI_OVLY_WINDOW_PARMSA* PMCI_OVLY_WINDOW_PARMSA;
	alias MCI_OVLY_WINDOW_PARMSA*  LPMCI_OVLY_WINDOW_PARMSA;
	align(2) struct MCI_OVLY_WINDOW_PARMSW {
	    DWORD_PTR   dwCallback;
	    HWND        hWnd;
	    UINT        nCmdShow;
	    LPCWSTR     lpstrText;
	}
	
	alias MCI_OVLY_WINDOW_PARMSW* PMCI_OVLY_WINDOW_PARMSW;
	alias MCI_OVLY_WINDOW_PARMSW*  LPMCI_OVLY_WINDOW_PARMSW;
	
	version(UNICODE) {
		alias MCI_OVLY_WINDOW_PARMSW MCI_OVLY_WINDOW_PARMS;
		alias PMCI_OVLY_WINDOW_PARMSW PMCI_OVLY_WINDOW_PARMS;
		alias LPMCI_OVLY_WINDOW_PARMSW LPMCI_OVLY_WINDOW_PARMS;
	}
	else {
		alias MCI_OVLY_WINDOW_PARMSA MCI_OVLY_WINDOW_PARMS;
		alias PMCI_OVLY_WINDOW_PARMSA PMCI_OVLY_WINDOW_PARMS;
		alias LPMCI_OVLY_WINDOW_PARMSA LPMCI_OVLY_WINDOW_PARMS;
	}
	
	/* parameter block for MCI_PUT, MCI_UPDATE, and MCI_WHERE command messages */
	align(2) struct MCI_OVLY_RECT_PARMS {
	    DWORD_PTR   dwCallback;
		version(MCI_USE_OFFEXT) {
		    POINT   ptOffset;
	    	POINT   ptExtent;
		}
		else { /* !MCI_USE_OFFEXT */
		    RECT    rc;
		}
	}
	
	alias MCI_OVLY_RECT_PARMS* PMCI_OVLY_RECT_PARMS;
	alias MCI_OVLY_RECT_PARMS*  LPMCI_OVLY_RECT_PARMS;
	
	
	/* parameter block for MCI_SAVE command message */
	align(2) struct MCI_OVLY_SAVE_PARMSA {
	    DWORD_PTR   dwCallback;
	    LPCSTR      lpfilename;
	    RECT        rc;
	}
	
	alias MCI_OVLY_SAVE_PARMSA* PMCI_OVLY_SAVE_PARMSA;
	alias MCI_OVLY_SAVE_PARMSA*  LPMCI_OVLY_SAVE_PARMSA;
	align(2) struct MCI_OVLY_SAVE_PARMSW {
	    DWORD_PTR   dwCallback;
	    LPCWSTR     lpfilename;
	    RECT        rc;
	}
	
	alias MCI_OVLY_SAVE_PARMSW* PMCI_OVLY_SAVE_PARMSW;
	alias MCI_OVLY_SAVE_PARMSW*  LPMCI_OVLY_SAVE_PARMSW;
	
	version(UNICODE) {
		alias MCI_OVLY_SAVE_PARMSW MCI_OVLY_SAVE_PARMS;
		alias PMCI_OVLY_SAVE_PARMSW PMCI_OVLY_SAVE_PARMS;
		alias LPMCI_OVLY_SAVE_PARMSW LPMCI_OVLY_SAVE_PARMS;
	}
	else {
		alias MCI_OVLY_SAVE_PARMSA MCI_OVLY_SAVE_PARMS;
		alias PMCI_OVLY_SAVE_PARMSA PMCI_OVLY_SAVE_PARMS;
		alias LPMCI_OVLY_SAVE_PARMSA LPMCI_OVLY_SAVE_PARMS;
	}
	
	/* parameter block for MCI_LOAD command message */
	align(2) struct MCI_OVLY_LOAD_PARMSA {
	    DWORD_PTR   dwCallback;
	    LPCSTR      lpfilename;
	    RECT    rc;
	}
	
	alias MCI_OVLY_LOAD_PARMSA* PMCI_OVLY_LOAD_PARMSA;
	alias MCI_OVLY_LOAD_PARMSA*  LPMCI_OVLY_LOAD_PARMSA;
	align(2) struct MCI_OVLY_LOAD_PARMSW {
	    DWORD_PTR   dwCallback;
	    LPCWSTR     lpfilename;
	    RECT    rc;
	}
	
	alias MCI_OVLY_LOAD_PARMSW* PMCI_OVLY_LOAD_PARMSW;
	alias MCI_OVLY_LOAD_PARMSW*  LPMCI_OVLY_LOAD_PARMSW;
	
	version(UNICODE) {
		alias MCI_OVLY_LOAD_PARMSW MCI_OVLY_LOAD_PARMS;
		alias PMCI_OVLY_LOAD_PARMSW PMCI_OVLY_LOAD_PARMS;
		alias LPMCI_OVLY_LOAD_PARMSW LPMCI_OVLY_LOAD_PARMS;
	}
	else {
		alias MCI_OVLY_LOAD_PARMSA MCI_OVLY_LOAD_PARMS;
		alias PMCI_OVLY_LOAD_PARMSA PMCI_OVLY_LOAD_PARMS;
		alias LPMCI_OVLY_LOAD_PARMSA LPMCI_OVLY_LOAD_PARMS;
	}
}

/****************************************************************************

                        DISPLAY Driver extensions

****************************************************************************/

const auto NEWTRANSPARENT  = 3;           /* use with SetBkMode() */
const auto QUERYROPSUPPORT = 40;          /* use to determine ROP support */

/****************************************************************************

                        DIB Driver extensions

****************************************************************************/

const auto SELECTDIB        = 41                      ; /* DIB.DRV select dib escape */
//const auto DIBINDEX(n)      = MAKELONG((n),0x10FF);


/****************************************************************************

                        ScreenSaver support

    The current application will receive a syscommand of SC_SCREENSAVE just
    before the screen saver is invoked.  If the app wishes to prevent a
    screen save, return non-zero value, otherwise call DefWindowProc().

****************************************************************************/

// already defined elsewhere
//const auto SC_SCREENSAVE   = 0xF140;

