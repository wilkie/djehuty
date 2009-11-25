/*
 * guiddef.d
 *
 * This module is a port of guiddef.h to D.
 * The original copyright notice appears after this information block.
 *
 * Author: Dave Wilkinson
 * Originated: November 24th, 2009
 *
 */

module binding.win32.guiddef;

//+---------------------------------------------------------------------------
//
//  Microsoft Windows
//  Copyright (c) Microsoft Corporation.  All rights reserved.
//
//  File:       guiddef.h
//
//  Contents:   GUID definition
//
//----------------------------------------------------------------------------

import binding.c;

struct GUID {
    Culong_t Data1;
    ushort Data2;
    ushort Data3;
    byte[8]           Data4;
}

typedef GUID* LPGUID;
typedef GUID* LPCGUID;

typedef GUID IID;
typedef IID* LPIID;
const auto GUID_NULL = GUID.init;
const auto IID_NULL		= GUID_NULL;
const auto CLSID_NULL	= GUID_NULL;
const auto FMTID_NULL	= GUID_NULL;

typedef GUID CLSID;
typedef CLSID *LPCLSID;

typedef GUID FMTID;
typedef FMTID *LPFMTID;

typedef GUID REFGUID;

// Faster (but makes code fatter) inline version...use sparingly
int InlineIsEqualGUID(REFGUID rguid1, REFGUID rguid2) {
   return (
      (cast(Culong_t *) &rguid1)[0] == (cast(Culong_t *) &rguid2)[0] &&
      (cast(Culong_t *) &rguid1)[1] == (cast(Culong_t *) &rguid2)[1] &&
      (cast(Culong_t *) &rguid1)[2] == (cast(Culong_t *) &rguid2)[2] &&
      (cast(Culong_t *) &rguid1)[3] == (cast(Culong_t *) &rguid2)[3]);
}

int IsEqualGUID(REFGUID rguid1, REFGUID rguid2) {
    return !memcmp(&rguid1, &rguid2, sizeof(GUID));
}

// Same type, different name

alias IsEqualGUID IsEqualIID;
alias IsEqualGUID IsEqualCLSID;