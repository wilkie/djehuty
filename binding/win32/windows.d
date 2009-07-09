/*
 * windows.d
 *
 * This module binds the Windows API and mimics windows.h.
 * The original header and copyright information for the file this module
 * was based upon are given below.
 *
 * Author: Dave Wilkinson
 * Originated: July 7th, 2009
 *
 */

/*++ BUILD Version: 0001    Increment this if a change has global effects

Copyright (c) Microsoft Corporation. All rights reserved.

Module Name:

    windows.h

Abstract:

    Master include file for Windows applications.

--*/

/*  If defined, the following flags inhibit definition
 *     of the indicated items.
 *
 *  NOGDICAPMASKS     - CC_*, LC_*, PC_*, CP_*, TC_*, RC_
 *  NOVIRTUALKEYCODES - VK_*
 *  NOWINMESSAGES     - WM_*, EM_*, LB_*, CB_*
 *  NOWINSTYLES       - WS_*, CS_*, ES_*, LBS_*, SBS_*, CBS_*
 *  NOSYSMETRICS      - SM_*
 *  NOMENUS           - MF_*
 *  NOICONS           - IDI_*
 *  NOKEYSTATES       - MK_*
 *  NOSYSCOMMANDS     - SC_*
 *  NORASTEROPS       - Binary and Tertiary raster ops
 *  NOSHOWWINDOW      - SW_*
 *  OEMRESOURCE       - OEM Resource values
 *  NOATOM            - Atom Manager routines
 *  NOCLIPBOARD       - Clipboard routines
 *  NOCOLOR           - Screen colors
 *  NOCTLMGR          - Control and Dialog routines
 *  NODRAWTEXT        - DrawText() and DT_*
 *  NOGDI             - All GDI defines and routines
 *  NOKERNEL          - All KERNEL defines and routines
 *  NOUSER            - All USER defines and routines
 *  NONLS             - All NLS defines and routines
 *  NOMB              - MB_* and MessageBox()
 *  NOMEMMGR          - GMEM_*, LMEM_*, GHND, LHND, associated routines
 *  NOMETAFILE        - typedef METAFILEPICT
 *  NOMINMAX          - Macros min(a,b) and max(a,b)
 *  NOMSG             - typedef MSG and associated routines
 *  NOOPENFILE        - OpenFile(), OemToAnsi, AnsiToOem, and OF_*
 *  NOSCROLL          - SB_* and scrolling routines
 *  NOSERVICE         - All Service Controller routines, SERVICE_ equates, etc.
 *  NOSOUND           - Sound driver routines
 *  NOTEXTMETRIC      - typedef TEXTMETRIC and associated routines
 *  NOWH              - SetWindowsHook and WH_*
 *  NOWINOFFSETS      - GWL_*, GCL_*, associated routines
 *  NOCOMM            - COMM driver routines
 *  NOKANJI           - Kanji support stuff.
 *  NOHELP            - Help engine interface.
 *  NOPROFILER        - Profiler interface.
 *  NODEFERWINDOWPOS  - DeferWindowPos routines
 *  NOMCX             - Modem Configuration Extensions
 */

public import binding.win32.windef;
public import binding.win32.winbase;
public import binding.win32.wingdi;
public import binding.win32.winuser;
public import binding.win32.stralign;

version(RC_INVOKED) {
	version(NOWINRES) {
	}
	else {
		public import binding.win32.winresrc;
	}
}

version(_WIN32NLS) {
	public import binding.win32.winnls;
}

version(_WIN32REG) {
	public import binding.win32.winreg;
}

version(INC_OLE2) {
	public import binding.win32.ole2;
}

version(_MAC) {
	public import binding.win32.winwlm;
}
else {

	version(NOSERVICE) {
	}
	else {
		public import binding.win32.winsvc;
	}

	version(NOMCX) {
	}
	else {
		public import binding.win32.mcx;
	}

	version(NOIME) {
	}
	else {
		public import binding.win32.imm;
	}

	version(_WIN32NLS) {
	}
	else {
		public import binding.win32.winnls;
	}

	version(_WIN32REG) {
	}
	else {
		public import binding.win32.winreg;
	}

	public import binding.win32.wincon;
	public import binding.win32.winver;
	public import binding.win32.winnetwk;
}

version(WIN32_LEAN_AND_MEAN) {
}
else {
	public import binding.win32.cderr;
	public import binding.win32.dde;
	public import binding.win32.ddeml;
	public import binding.win32.dlgs;
	public import binding.win32.shellapi;

	version(_MAC) {
	}
	else {
		public import binding.win32.lzexpand;
		public import binding.win32.mmsystem;
		public import binding.win32.nb30;
		public import binding.win32.rpc;
		public import binding.win32.winperf;
		public import binding.win32.winsock;
	}

	version(NO_CRYPT) {
	}
	else {
		public import binding.win32.wincrypt;
		public import binding.win32.winefs;
		public import binding.win32.winscard;
	}

	version(NO_GDI) {
	}
	else {
		version(_MAC) {
		}
		else {
			public import binding.win32.winspool;
			version(INC_OLE1) {
				public import binding.win32.ole;
			}
			else {
				version(INC_OLE2) {
				}
				else {
					public import binding.win32.ole2;
				}
			}
		}

		public import binding.win32.commdlg;
	}
}