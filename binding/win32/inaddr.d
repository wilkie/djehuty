/*
 * inaddr.d
 *
 * This module binds inaddr.h to D. The original copyright notice is
 * preserved below.
 *
 * Author: Dave Wilkinson
 * Originated: November 25th, 2009
 *
 */

module binding.win32.inaddr;

import binding.win32.windef;
import binding.win32.winbase;
import binding.win32.winnt;
import binding.win32.inaddr;

extern(System):

/*++

Copyright (c) Microsoft Corporation

Module Name:

    inaddr.h

Environment:

    user mode or kernel mode

--*/

//
// IPv4 Internet address
// This is an 'on-wire' format structure.
//
struct in_addr {
        union _inner_union {
                struct _inner_struct {
					UCHAR s_b1;
					UCHAR s_b2;
					UCHAR s_b3;
					UCHAR s_b4;
				}
				_inner_struct S_un_b;
                struct _inner_struct2 {
					USHORT s_w1;
					USHORT s_w2;
				}
				_inner_struct2 S_un_w;
                ULONG S_addr;
        }
		_inner_union S_un;

		ULONG s_addr() {
			return S_un.S_addr;
		}

		void s_addr(ULONG val) {
			S_un.S_addr = val;
		}

		UCHAR s_host() {
			return S_un.S_un_b.s_b2;
		}

		void s_host(UCHAR val) {
			S_un.S_un_b.s_b2 = val;
		}

		UCHAR s_net() {
			return S_un.S_un_b.s_b1;
		}

		void s_net(UCHAR val) {
			S_un.S_un_b.s_b1 = val;
		}

		USHORT s_imp() {
			return S_un.S_un_w.s_w2;
		}

		void s_imp(USHORT val) {
			S_un.S_un_w.s_w2 = val;
		}

		UCHAR s_impno() {
			return S_un.S_un_b.s_b4;
		}

		void s_impno(UCHAR val) {
			S_un.S_un_b.s_b4 = val;
		}

		UCHAR s_lh() {
			return S_un.S_un_b.s_b3;
		}

		void s_lh(UCHAR val) {
			S_un.S_un_b.s_b3 = val;
		}

		//#define s_addr  S_un.S_addr /* can be used for most tcp & ip code */
		//#define s_host  S_un.S_un_b.s_b2    // host on imp
		//#define s_net   S_un.S_un_b.s_b1    // network
		//#define s_imp   S_un.S_un_w.s_w2    // imp
		//#define s_impno S_un.S_un_b.s_b4    // imp #
		//#define s_lh    S_un.S_un_b.s_b3    // logical host
}

alias in_addr IN_ADDR;
alias in_addr* PIN_ADDR;
alias in_addr* LPIN_ADDR;