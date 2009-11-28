/*
 * winnt.d
 *
 * This module is a port of winnt.h to D.
 * The original copyright notice appears after this information block.
 *
 * Author: Dave Wilkinson
 * Originated: July 7th, 2009
 *
 */

module binding.win32.winnt;

/*++ BUILD Version: 0066     Increment this if a change has global effects

Copyright (c) Microsoft Corporation. All rights reserved.

Module Name:

    winnt.h

Abstract:

    This module defines the 32-Bit Windows types and constants that are
    defined by NT, but exposed through the Win32 API.

Revision History:

--*/

import binding.c;

import binding.win32.windef;

extern(System):

version (X86_64) {
	const auto MEMORY_ALLOCATION_ALIGNMENT = 16;
	const auto MAX_NATURAL_ALIGNMENT = ulong.sizeof;
}
else {
	const auto MEMORY_ALLOCATION_ALIGNMENT = 8;
	const auto MAX_NATURAL_ALIGNMENT = DWORD.sizeof;
}

//
// Void
//

alias void*	PVOID;
alias void*	PVOID64;

alias char	CHAR;
alias short	SHORT;
alias Clong_t	LONG;


//
// UNICODE (Wide Character) types
//

alias wchar WCHAR;    // wc,   16-bit UNICODE character

alias WCHAR *PWCHAR;

alias WCHAR *LPWCH;
alias WCHAR *PWCH;

alias WCHAR *LPCWCH;
alias WCHAR *PCWCH;

alias WCHAR *NWPSTR;
alias WCHAR *LPWSTR;
alias WCHAR *PWSTR;

alias PWSTR *PZPWSTR;
alias PWSTR *PCZPWSTR;
alias WCHAR *LPUWSTR;
alias WCHAR *PUWSTR;
alias WCHAR *LPCWSTR;
alias WCHAR *PCWSTR;
alias PCWSTR *PZPCWSTR;
alias WCHAR *LPCUWSTR;
alias WCHAR *PCUWSTR;

//
// ANSI (Multi-byte Character) types
//
alias CHAR *PCHAR;
alias CHAR *LPCH;
alias CHAR *PCH;
alias CHAR *LPCCH;
alias CHAR *PCCH;

alias CHAR *NPSTR;
alias CHAR *LPSTR;
alias CHAR *PSTR;
alias PSTR *PZPSTR;
alias PSTR *PCZPSTR;
alias CHAR *LPCSTR; 
alias CHAR *PCSTR;
alias PCSTR *PZPCSTR;

//
// Neutral ANSI/UNICODE types and macros
//

version(UNICODE) {
	alias WCHAR TCHAR;
	alias WCHAR *PTCHAR;
	alias WCHAR TBYTE;
	alias WCHAR *PTBYTE ;

	alias LPWSTR LPTCH;
	alias LPWSTR PTCH;
	alias LPWSTR PTSTR;
	alias LPWSTR LPTSTR;
	alias LPCWSTR PCTSTR;
	alias LPCWSTR LPCTSTR;
	alias LPUWSTR PUTSTR;
	alias LPUWSTR LPUTSTR;
	alias LPCUWSTR PCUTSTR;
	alias LPCUWSTR LPCUTSTR;
	alias LPWSTR LP;
}
else {
	alias char TCHAR;
	alias char *PTCHAR;
	alias ubyte TBYTE ;
	alias ubyte *PTBYTE ;

	alias LPSTR LPTCH;
	alias LPSTR PTCH;
	alias LPSTR PTSTR;
	alias LPSTR LPTSTR;
	alias LPSTR PUTSTR;
	alias LPSTR LPUTSTR;
	alias LPCSTR PCTSTR;
	alias LPCSTR LPCTSTR;
	alias LPCSTR PCUTSTR;
	alias LPCSTR LPCUTSTR;
}

alias SHORT*	PSHORT;
alias LONG*	PLONG;

alias void* HANDLE;

alias HANDLE *PHANDLE;

//
// Flag (bit) fields
//

alias BYTE	FCHAR;
alias WORD	FSHORT;
alias DWORD	FLONG;

// Component Object Model defines, and macros

alias LONG	HRESULT;

alias char	CCHAR;
alias DWORD	LCID;
alias PDWORD	PLCID;
alias WORD	LANGID;

const auto APPLICATION_ERROR_MASK		= 0x20000000;
const auto ERROR_SEVERITY_SUCCESS		= 0x00000000;
const auto ERROR_SEVERITY_INFORMATIONAL	= 0x40000000;
const auto ERROR_SEVERITY_WARNING		= 0x80000000;
const auto ERROR_SEVERITY_ERROR			= 0xC0000000;

struct FLOAT128 {
    long LowPart;
    long HighPart;
}

alias FLOAT128*	PFLOAT128;

alias long LONGLONG;
alias ulong ULONGLONG;

const auto MAXLONGLONG = long.max;

alias LONGLONG*	PLONGLONG;
alias ULONGLONG*	PULONGLONG;

// Update Sequence Number

alias LONGLONG USN;

alias LONGLONG LARGE_INTEGER; 

alias LARGE_INTEGER*	PLARGE_INTEGER;

alias ULONGLONG ULARGE_INTEGER;

alias ULARGE_INTEGER*	PULARGE_INTEGER;

//
// Locally Unique Identifier
//

struct LUID {
    DWORD LowPart;
    LONG HighPart;
}
alias LUID*	PLUID;

alias ULONGLONG	DWORDLONG;
alias DWORDLONG*	PDWORDLONG;

const auto ANSI_NULL				= (cast(CHAR)0);
const auto UNICODE_NULL				= (cast(WCHAR)0);
const auto UNICODE_STRING_MAX_BYTES	= (cast(WORD)65534);
const auto UNICODE_STRING_MAX_CHARS = (32767);

alias BYTE 		BOOLEAN;
alias BOOLEAN*	PBOOLEAN;

//
//  Doubly linked list structure.  Can be used as either a list head, or
//  as link words.
//

struct LIST_ENTRY {
   LIST_ENTRY* Flink;
   LIST_ENTRY* Blink;
}

alias LIST_ENTRY* PLIST_ENTRY;
alias LIST_ENTRY* PRLIST_ENTRY;

//
//  Singly linked list structure. Can be used as either a list head, or
//  as link words.
//

struct SINGLE_LIST_ENTRY {
    SINGLE_LIST_ENTRY* Next;
}

alias SINGLE_LIST_ENTRY* PSINGLE_LIST_ENTRY;

//
// These are needed for portable debugger support.
//

struct LIST_ENTRY32 {
    DWORD Flink;
    DWORD Blink;
}

alias LIST_ENTRY32 *PLIST_ENTRY32;

struct LIST_ENTRY64 {
    ULONGLONG Flink;
    ULONGLONG Blink;
}

alias LIST_ENTRY64 *PLIST_ENTRY64;

public import binding.win32.guiddef;

struct OBJECTID {     // size is 20
    GUID Lineage;
    DWORD Uniquifier;
}

struct TP_IO;
alias TP_IO* PTP_IO;

struct TP_POOL;
alias TP_POOL* PTP_POOL;

struct TP_CLEANUP_GROUP;
alias TP_CLEANUP_GROUP* PTP_CLEANUP_GROUP;

alias VOID function(PVOID ObjectContext, PVOID CleanupContext) PTP_CLEANUP_GROUP_CANCEL_CALLBACK;

struct TP_CALLBACK_INSTANCE;
alias TP_CALLBACK_INSTANCE* PTP_CALLBACK_INSTANCE;

alias VOID function(PTP_CALLBACK_INSTANCE Instance, PVOID Context) PTP_SIMPLE_CALLBACK;

struct TP_TIMER;
alias TP_TIMER* PTP_TIMER;

alias VOID function(PTP_CALLBACK_INSTANCE Instance, PVOID Context, PTP_TIMER Timer) PTP_TIMER_CALLBACK;

alias DWORD TP_WAIT_RESULT;

struct TP_WAIT;
alias TP_WAIT* PTP_WAIT;

alias VOID function(PTP_CALLBACK_INSTANCE Instance, PVOID Context, PTP_WAIT Wait, TP_WAIT_RESULT WaitResult) PTP_WAIT_CALLBACK;

struct TP_WORK;
alias TP_WORK* PTP_WORK;

alias VOID function(PTP_CALLBACK_INSTANCE Instance, PVOID Context, PTP_WORK Work) PTP_WORK_CALLBACK;

alias DWORD TP_VERSION;
alias DWORD* PTP_VERSION;

struct _ACTIVATION_CONTEXT;
alias _ACTIVATION_CONTEXT ACTIVATION_CONTEXT;
//
// Do not manipulate this structure directly!  Allocate space for it
// and use the inline interfaces below.
//

struct TP_CALLBACK_ENVIRON {
    TP_VERSION                         Version;
    PTP_POOL                           Pool;
    PTP_CLEANUP_GROUP                  CleanupGroup;
    PTP_CLEANUP_GROUP_CANCEL_CALLBACK  CleanupGroupCancelCallback;
    PVOID                              RaceDll;
    ACTIVATION_CONTEXT        *ActivationContext;
    PTP_SIMPLE_CALLBACK                FinalizationCallback;
    union _inner_union {
        DWORD                          Flags;
        struct _inner_struct {
            //DWORD                      LongFunction :  1;
            //DWORD                      Private      : 31;
        }

		_inner_struct s;
    }

	_inner_union u;
}

alias TP_CALLBACK_ENVIRON* PTP_CALLBACK_ENVIRON;

const auto MINCHAR	= 0x80;
const auto MAXCHAR	= 0x7f;
const auto MINSHORT	= 0x8000;
const auto MAXSHORT	= 0x7fff;
const auto MINLONG	= 0x80000000;
const auto MAXLONG	= 0x7fffffff;
const auto MAXBYTE	= 0xff;
const auto MAXWORD	= 0xffff;
const auto MAXDWORD	= 0xffffffff;

const auto VER_SERVER_NT						= 0x80000000;
const auto VER_WORKSTATION_NT					= 0x40000000;
const auto VER_SUITE_SMALLBUSINESS				= 0x00000001;
const auto VER_SUITE_ENTERPRISE					= 0x00000002;
const auto VER_SUITE_BACKOFFICE					= 0x00000004;
const auto VER_SUITE_COMMUNICATIONS				= 0x00000008;
const auto VER_SUITE_TERMINAL					= 0x00000010;
const auto VER_SUITE_SMALLBUSINESS_RESTRICTED	= 0x00000020;
const auto VER_SUITE_EMBEDDEDNT 				= 0x00000040;
const auto VER_SUITE_DATACENTER					= 0x00000080;
const auto VER_SUITE_SINGLEUSERTS				= 0x00000100;
const auto VER_SUITE_PERSONAL					= 0x00000200;
const auto VER_SUITE_BLADE						= 0x00000400;
const auto VER_SUITE_EMBEDDED_RESTRICTED		= 0x00000800;
const auto VER_SUITE_SECURITY_APPLIANCE			= 0x00001000;
const auto VER_SUITE_STORAGE_SERVER				= 0x00002000;
const auto VER_SUITE_COMPUTE_SERVER				= 0x00004000;




//
// Product types
// This list grows with each OS release.
//
// There is no ordering of values to ensure callers
// do an equality test i.e. greater-than and less-than
// comparisons are not useful.
//
// NOTE: Values in this list should never be deleted.
//       When a product-type 'X' gets dropped from a
//       OS release onwards, the value of 'X' continues
//       to be used in the mapping table of GetProductInfo.
//

const auto PRODUCT_UNDEFINED                        = 0x00000000;

const auto PRODUCT_ULTIMATE                         = 0x00000001;
const auto PRODUCT_HOME_BASIC                       = 0x00000002;
const auto PRODUCT_HOME_PREMIUM                     = 0x00000003;
const auto PRODUCT_ENTERPRISE                       = 0x00000004;
const auto PRODUCT_HOME_BASIC_N                     = 0x00000005;
const auto PRODUCT_BUSINESS                         = 0x00000006;
const auto PRODUCT_STANDARD_SERVER                  = 0x00000007;
const auto PRODUCT_DATACENTER_SERVER                = 0x00000008;
const auto PRODUCT_SMALLBUSINESS_SERVER             = 0x00000009;
const auto PRODUCT_ENTERPRISE_SERVER                = 0x0000000A;
const auto PRODUCT_STARTER                          = 0x0000000B;
const auto PRODUCT_DATACENTER_SERVER_CORE           = 0x0000000C;
const auto PRODUCT_STANDARD_SERVER_CORE             = 0x0000000D;
const auto PRODUCT_ENTERPRISE_SERVER_CORE           = 0x0000000E;
const auto PRODUCT_ENTERPRISE_SERVER_IA64           = 0x0000000F;
const auto PRODUCT_BUSINESS_N                       = 0x00000010;
const auto PRODUCT_WEB_SERVER                       = 0x00000011;
const auto PRODUCT_CLUSTER_SERVER                   = 0x00000012;
const auto PRODUCT_HOME_SERVER                      = 0x00000013;
const auto PRODUCT_STORAGE_EXPRESS_SERVER           = 0x00000014;
const auto PRODUCT_STORAGE_STANDARD_SERVER          = 0x00000015;
const auto PRODUCT_STORAGE_WORKGROUP_SERVER         = 0x00000016;
const auto PRODUCT_STORAGE_ENTERPRISE_SERVER        = 0x00000017;
const auto PRODUCT_SERVER_FOR_SMALLBUSINESS         = 0x00000018;
const auto PRODUCT_SMALLBUSINESS_SERVER_PREMIUM     = 0x00000019;

const auto PRODUCT_UNLICENSED                       = 0xABCDABCD;

//
//  Language IDs.
//
//  The following two combinations of primary language ID and
//  sublanguage ID have special semantics:
//
//    Primary Language ID   Sublanguage ID      Result
//    -------------------   ---------------     ------------------------
//    LANG_NEUTRAL          SUBLANG_NEUTRAL     Language neutral
//    LANG_NEUTRAL          SUBLANG_DEFAULT     User default language
//    LANG_NEUTRAL          SUBLANG_SYS_DEFAULT System default language
//    LANG_INVARIANT        SUBLANG_NEUTRAL     Invariant locale
//

//
//  Primary language IDs.
//

const auto LANG_NEUTRAL                      = 0x00;
const auto LANG_INVARIANT                    = 0x7f;

const auto LANG_AFRIKAANS                    = 0x36;
const auto LANG_ALBANIAN                     = 0x1c;
const auto LANG_ALSATIAN                     = 0x84;
const auto LANG_AMHARIC                      = 0x5e;
const auto LANG_ARABIC                       = 0x01;
const auto LANG_ARMENIAN                     = 0x2b;
const auto LANG_ASSAMESE                     = 0x4d;
const auto LANG_AZERI                        = 0x2c;
const auto LANG_BASHKIR                      = 0x6d;
const auto LANG_BASQUE                       = 0x2d;
const auto LANG_BELARUSIAN                   = 0x23;
const auto LANG_BENGALI                      = 0x45;
const auto LANG_BRETON                       = 0x7e;
const auto LANG_BOSNIAN                      = 0x1a   ; // Use with SUBLANG_BOSNIAN_* Sublanguage IDs
const auto LANG_BOSNIAN_NEUTRAL            = 0x781a   ; // Use with the ConvertDefaultLocale function
const auto LANG_BULGARIAN                    = 0x02;
const auto LANG_CATALAN                      = 0x03;
const auto LANG_CHINESE                      = 0x04   ; // Use with SUBLANG_CHINESE_* Sublanguage IDs
const auto LANG_CHINESE_SIMPLIFIED           = 0x04   ; // Use with the ConvertDefaultLocale function
const auto LANG_CHINESE_TRADITIONAL        = 0x7c04   ; // Use with the ConvertDefaultLocale function
const auto LANG_CORSICAN                     = 0x83;
const auto LANG_CROATIAN                     = 0x1a;
const auto LANG_CZECH                        = 0x05;
const auto LANG_DANISH                       = 0x06;
const auto LANG_DARI                         = 0x8c;
const auto LANG_DIVEHI                       = 0x65;
const auto LANG_DUTCH                        = 0x13;
const auto LANG_ENGLISH                      = 0x09;
const auto LANG_ESTONIAN                     = 0x25;
const auto LANG_FAEROESE                     = 0x38;
const auto LANG_FARSI                        = 0x29   ; // Deprecated: use LANG_PERSIAN instead
const auto LANG_FILIPINO                     = 0x64;
const auto LANG_FINNISH                      = 0x0b;
const auto LANG_FRENCH                       = 0x0c;
const auto LANG_FRISIAN                      = 0x62;
const auto LANG_GALICIAN                     = 0x56;
const auto LANG_GEORGIAN                     = 0x37;
const auto LANG_GERMAN                       = 0x07;
const auto LANG_GREEK                        = 0x08;
const auto LANG_GREENLANDIC                  = 0x6f;
const auto LANG_GUJARATI                     = 0x47;
const auto LANG_HAUSA                        = 0x68;
const auto LANG_HEBREW                       = 0x0d;
const auto LANG_HINDI                        = 0x39;
const auto LANG_HUNGARIAN                    = 0x0e;
const auto LANG_ICELANDIC                    = 0x0f;
const auto LANG_IGBO                         = 0x70;
const auto LANG_INDONESIAN                   = 0x21;
const auto LANG_INUKTITUT                    = 0x5d;
const auto LANG_IRISH                        = 0x3c   ; // Use with the SUBLANG_IRISH_IRELAND Sublanguage ID
const auto LANG_ITALIAN                      = 0x10;
const auto LANG_JAPANESE                     = 0x11;
const auto LANG_KANNADA                      = 0x4b;
const auto LANG_KASHMIRI                     = 0x60;
const auto LANG_KAZAK                        = 0x3f;
const auto LANG_KHMER                        = 0x53;
const auto LANG_KICHE                        = 0x86;
const auto LANG_KINYARWANDA                  = 0x87;
const auto LANG_KONKANI                      = 0x57;
const auto LANG_KOREAN                       = 0x12;
const auto LANG_KYRGYZ                       = 0x40;
const auto LANG_LAO                          = 0x54;
const auto LANG_LATVIAN                      = 0x26;
const auto LANG_LITHUANIAN                   = 0x27;
const auto LANG_LOWER_SORBIAN                = 0x2e;
const auto LANG_LUXEMBOURGISH                = 0x6e;
const auto LANG_MACEDONIAN                   = 0x2f   ; // the Former Yugoslav Republic of Macedonia
const auto LANG_MALAY                        = 0x3e;
const auto LANG_MALAYALAM                    = 0x4c;
const auto LANG_MALTESE                      = 0x3a;
const auto LANG_MANIPURI                     = 0x58;
const auto LANG_MAORI                        = 0x81;
const auto LANG_MAPUDUNGUN                   = 0x7a;
const auto LANG_MARATHI                      = 0x4e;
const auto LANG_MOHAWK                       = 0x7c;
const auto LANG_MONGOLIAN                    = 0x50;
const auto LANG_NEPALI                       = 0x61;
const auto LANG_NORWEGIAN                    = 0x14;
const auto LANG_OCCITAN                      = 0x82;
const auto LANG_ORIYA                        = 0x48;
const auto LANG_PASHTO                       = 0x63;
const auto LANG_PERSIAN                      = 0x29;
const auto LANG_POLISH                       = 0x15;
const auto LANG_PORTUGUESE                   = 0x16;
const auto LANG_PUNJABI                      = 0x46;
const auto LANG_QUECHUA                      = 0x6b;
const auto LANG_ROMANIAN                     = 0x18;
const auto LANG_ROMANSH                      = 0x17;
const auto LANG_RUSSIAN                      = 0x19;
const auto LANG_SAMI                         = 0x3b;
const auto LANG_SANSKRIT                     = 0x4f;
const auto LANG_SERBIAN                      = 0x1a   ; // Use with the SUBLANG_SERBIAN_* Sublanguage IDs
const auto LANG_SERBIAN_NEUTRAL            = 0x7c1a   ; // Use with the ConvertDefaultLocale function
const auto LANG_SINDHI                       = 0x59;
const auto LANG_SINHALESE                    = 0x5b;
const auto LANG_SLOVAK                       = 0x1b;
const auto LANG_SLOVENIAN                    = 0x24;
const auto LANG_SOTHO                        = 0x6c;
const auto LANG_SPANISH                      = 0x0a;
const auto LANG_SWAHILI                      = 0x41;
const auto LANG_SWEDISH                      = 0x1d;
const auto LANG_SYRIAC                       = 0x5a;
const auto LANG_TAJIK                        = 0x28;
const auto LANG_TAMAZIGHT                    = 0x5f;
const auto LANG_TAMIL                        = 0x49;
const auto LANG_TATAR                        = 0x44;
const auto LANG_TELUGU                       = 0x4a;
const auto LANG_THAI                         = 0x1e;
const auto LANG_TIBETAN                      = 0x51;
const auto LANG_TIGRIGNA                     = 0x73;
const auto LANG_TSWANA                       = 0x32;
const auto LANG_TURKISH                      = 0x1f;
const auto LANG_TURKMEN                      = 0x42;
const auto LANG_UIGHUR                       = 0x80;
const auto LANG_UKRAINIAN                    = 0x22;
const auto LANG_UPPER_SORBIAN                = 0x2e;
const auto LANG_URDU                         = 0x20;
const auto LANG_UZBEK                        = 0x43;
const auto LANG_VIETNAMESE                   = 0x2a;
const auto LANG_WELSH                        = 0x52;
const auto LANG_WOLOF                        = 0x88;
const auto LANG_XHOSA                        = 0x34;
const auto LANG_YAKUT                        = 0x85;
const auto LANG_YI                           = 0x78;
const auto LANG_YORUBA                       = 0x6a;
const auto LANG_ZULU                         = 0x35;

//
//  Sublanguage IDs.
//
//  The name immediately following SUBLANG_ dictates which primary
//  language ID that sublanguage ID can be combined with to form a
//  valid language ID.
//

const auto SUBLANG_NEUTRAL                              = 0x00    ; // language neutral
const auto SUBLANG_DEFAULT                              = 0x01    ; // user default
const auto SUBLANG_SYS_DEFAULT                          = 0x02    ; // system default
const auto SUBLANG_CUSTOM_DEFAULT                       = 0x03    ; // default custom language/locale
const auto SUBLANG_CUSTOM_UNSPECIFIED                   = 0x04    ; // custom language/locale
const auto SUBLANG_UI_CUSTOM_DEFAULT                    = 0x05    ; // Default custom MUI language/locale


const auto SUBLANG_AFRIKAANS_SOUTH_AFRICA               = 0x01    ; // Afrikaans (South Africa) 0x0436 af-ZA
const auto SUBLANG_ALBANIAN_ALBANIA                     = 0x01    ; // Albanian (Albania) 0x041c sq-AL
const auto SUBLANG_ALSATIAN_FRANCE                      = 0x01    ; // Alsatian (France) 0x0484
const auto SUBLANG_AMHARIC_ETHIOPIA                     = 0x01    ; // Amharic (Ethiopia) 0x045e
const auto SUBLANG_ARABIC_SAUDI_ARABIA                  = 0x01    ; // Arabic (Saudi Arabia)
const auto SUBLANG_ARABIC_IRAQ                          = 0x02    ; // Arabic (Iraq)
const auto SUBLANG_ARABIC_EGYPT                         = 0x03    ; // Arabic (Egypt)
const auto SUBLANG_ARABIC_LIBYA                         = 0x04    ; // Arabic (Libya)
const auto SUBLANG_ARABIC_ALGERIA                       = 0x05    ; // Arabic (Algeria)
const auto SUBLANG_ARABIC_MOROCCO                       = 0x06    ; // Arabic (Morocco)
const auto SUBLANG_ARABIC_TUNISIA                       = 0x07    ; // Arabic (Tunisia)
const auto SUBLANG_ARABIC_OMAN                          = 0x08    ; // Arabic (Oman)
const auto SUBLANG_ARABIC_YEMEN                         = 0x09    ; // Arabic (Yemen)
const auto SUBLANG_ARABIC_SYRIA                         = 0x0a    ; // Arabic (Syria)
const auto SUBLANG_ARABIC_JORDAN                        = 0x0b    ; // Arabic (Jordan)
const auto SUBLANG_ARABIC_LEBANON                       = 0x0c    ; // Arabic (Lebanon)
const auto SUBLANG_ARABIC_KUWAIT                        = 0x0d    ; // Arabic (Kuwait)
const auto SUBLANG_ARABIC_UAE                           = 0x0e    ; // Arabic (U.A.E)
const auto SUBLANG_ARABIC_BAHRAIN                       = 0x0f    ; // Arabic (Bahrain)
const auto SUBLANG_ARABIC_QATAR                         = 0x10    ; // Arabic (Qatar)
const auto SUBLANG_ARMENIAN_ARMENIA                     = 0x01    ; // Armenian (Armenia) 0x042b hy-AM
const auto SUBLANG_ASSAMESE_INDIA                       = 0x01    ; // Assamese (India) 0x044d
const auto SUBLANG_AZERI_LATIN                          = 0x01    ; // Azeri (Latin)
const auto SUBLANG_AZERI_CYRILLIC                       = 0x02    ; // Azeri (Cyrillic)
const auto SUBLANG_BASHKIR_RUSSIA                       = 0x01    ; // Bashkir (Russia) 0x046d ba-RU
const auto SUBLANG_BASQUE_BASQUE                        = 0x01    ; // Basque (Basque) 0x042d eu-ES
const auto SUBLANG_BELARUSIAN_BELARUS                   = 0x01    ; // Belarusian (Belarus) 0x0423 be-BY
const auto SUBLANG_BENGALI_INDIA                        = 0x01    ; // Bengali (India)
const auto SUBLANG_BENGALI_BANGLADESH                   = 0x02    ; // Bengali (Bangladesh)
const auto SUBLANG_BOSNIAN_BOSNIA_HERZEGOVINA_LATIN     = 0x05    ; // Bosnian (Bosnia and Herzegovina - Latin) 0x141a bs-BA-Latn
const auto SUBLANG_BOSNIAN_BOSNIA_HERZEGOVINA_CYRILLIC  = 0x08    ; // Bosnian (Bosnia and Herzegovina - Cyrillic) 0x201a bs-BA-Cyrl
const auto SUBLANG_BRETON_FRANCE                        = 0x01    ; // Breton (France) 0x047e
const auto SUBLANG_BULGARIAN_BULGARIA                   = 0x01    ; // Bulgarian (Bulgaria) 0x0402
const auto SUBLANG_CATALAN_CATALAN                      = 0x01    ; // Catalan (Catalan) 0x0403
const auto SUBLANG_CHINESE_TRADITIONAL                  = 0x01    ; // Chinese (Taiwan) 0x0404 zh-TW
const auto SUBLANG_CHINESE_SIMPLIFIED                   = 0x02    ; // Chinese (PR China) 0x0804 zh-CN
const auto SUBLANG_CHINESE_HONGKONG                     = 0x03    ; // Chinese (Hong Kong S.A.R., P.R.C.) 0x0c04 zh-HK
const auto SUBLANG_CHINESE_SINGAPORE                    = 0x04    ; // Chinese (Singapore) 0x1004 zh-SG
const auto SUBLANG_CHINESE_MACAU                        = 0x05    ; // Chinese (Macau S.A.R.) 0x1404 zh-MO
const auto SUBLANG_CORSICAN_FRANCE                      = 0x01    ; // Corsican (France) 0x0483
const auto SUBLANG_CZECH_CZECH_REPUBLIC                 = 0x01    ; // Czech (Czech Republic) 0x0405
const auto SUBLANG_CROATIAN_CROATIA                     = 0x01    ; // Croatian (Croatia)
const auto SUBLANG_CROATIAN_BOSNIA_HERZEGOVINA_LATIN    = 0x04    ; // Croatian (Bosnia and Herzegovina - Latin) 0x101a hr-BA
const auto SUBLANG_DANISH_DENMARK                       = 0x01    ; // Danish (Denmark) 0x0406
const auto SUBLANG_DARI_AFGHANISTAN                     = 0x01    ; // Dari (Afghanistan)
const auto SUBLANG_DIVEHI_MALDIVES                      = 0x01    ; // Divehi (Maldives) 0x0465 div-MV
const auto SUBLANG_DUTCH                                = 0x01    ; // Dutch
const auto SUBLANG_DUTCH_BELGIAN                        = 0x02    ; // Dutch (Belgian)
const auto SUBLANG_ENGLISH_US                           = 0x01    ; // English (USA)
const auto SUBLANG_ENGLISH_UK                           = 0x02    ; // English (UK)
const auto SUBLANG_ENGLISH_AUS                          = 0x03    ; // English (Australian)
const auto SUBLANG_ENGLISH_CAN                          = 0x04    ; // English (Canadian)
const auto SUBLANG_ENGLISH_NZ                           = 0x05    ; // English (New Zealand)
const auto SUBLANG_ENGLISH_EIRE                         = 0x06    ; // English (Irish)
const auto SUBLANG_ENGLISH_SOUTH_AFRICA                 = 0x07    ; // English (South Africa)
const auto SUBLANG_ENGLISH_JAMAICA                      = 0x08    ; // English (Jamaica)
const auto SUBLANG_ENGLISH_CARIBBEAN                    = 0x09    ; // English (Caribbean)
const auto SUBLANG_ENGLISH_BELIZE                       = 0x0a    ; // English (Belize)
const auto SUBLANG_ENGLISH_TRINIDAD                     = 0x0b    ; // English (Trinidad)
const auto SUBLANG_ENGLISH_ZIMBABWE                     = 0x0c    ; // English (Zimbabwe)
const auto SUBLANG_ENGLISH_PHILIPPINES                  = 0x0d    ; // English (Philippines)
const auto SUBLANG_ENGLISH_INDIA                        = 0x10    ; // English (India)
const auto SUBLANG_ENGLISH_MALAYSIA                     = 0x11    ; // English (Malaysia)
const auto SUBLANG_ENGLISH_SINGAPORE                    = 0x12    ; // English (Singapore)
const auto SUBLANG_ESTONIAN_ESTONIA                     = 0x01    ; // Estonian (Estonia) 0x0425 et-EE
const auto SUBLANG_FAEROESE_FAROE_ISLANDS               = 0x01    ; // Faroese (Faroe Islands) 0x0438 fo-FO
const auto SUBLANG_FILIPINO_PHILIPPINES                 = 0x01    ; // Filipino (Philippines) 0x0464 fil-PH
const auto SUBLANG_FINNISH_FINLAND                      = 0x01    ; // Finnish (Finland) 0x040b
const auto SUBLANG_FRENCH                               = 0x01    ; // French
const auto SUBLANG_FRENCH_BELGIAN                       = 0x02    ; // French (Belgian)
const auto SUBLANG_FRENCH_CANADIAN                      = 0x03    ; // French (Canadian)
const auto SUBLANG_FRENCH_SWISS                         = 0x04    ; // French (Swiss)
const auto SUBLANG_FRENCH_LUXEMBOURG                    = 0x05    ; // French (Luxembourg)
const auto SUBLANG_FRENCH_MONACO                        = 0x06    ; // French (Monaco)
const auto SUBLANG_FRISIAN_NETHERLANDS                  = 0x01    ; // Frisian (Netherlands) 0x0462 fy-NL
const auto SUBLANG_GALICIAN_GALICIAN                    = 0x01    ; // Galician (Galician) 0x0456 gl-ES
const auto SUBLANG_GEORGIAN_GEORGIA                     = 0x01    ; // Georgian (Georgia) 0x0437 ka-GE
const auto SUBLANG_GERMAN                               = 0x01    ; // German
const auto SUBLANG_GERMAN_SWISS                         = 0x02    ; // German (Swiss)
const auto SUBLANG_GERMAN_AUSTRIAN                      = 0x03    ; // German (Austrian)
const auto SUBLANG_GERMAN_LUXEMBOURG                    = 0x04    ; // German (Luxembourg)
const auto SUBLANG_GERMAN_LIECHTENSTEIN                 = 0x05    ; // German (Liechtenstein)
const auto SUBLANG_GREEK_GREECE                         = 0x01    ; // Greek (Greece)
const auto SUBLANG_GREENLANDIC_GREENLAND                = 0x01    ; // Greenlandic (Greenland) 0x046f kl-GL
const auto SUBLANG_GUJARATI_INDIA                       = 0x01    ; // Gujarati (India (Gujarati Script)) 0x0447 gu-
const auto SUBLANG_HAUSA_NIGERIA_LATIN                  = 0x01    ; // Hausa (Latin, Nigeria) 0x0468 ha-NG-Latn
const auto SUBLANG_HEBREW_ISRAEL                        = 0x01    ; // Hebrew (Israel) 0x040d
const auto SUBLANG_HINDI_INDIA                          = 0x01    ; // Hindi (India) 0x0439 hi-
const auto SUBLANG_HUNGARIAN_HUNGARY                    = 0x01    ; // Hungarian (Hungary) 0x040e
const auto SUBLANG_ICELANDIC_ICELAND                    = 0x01    ; // Icelandic (Iceland) 0x040f
const auto SUBLANG_IGBO_NIGERIA                         = 0x01    ; // Igbo (Nigeria) 0x0470 ig-NG
const auto SUBLANG_INDONESIAN_INDONESIA                 = 0x01    ; // Indonesian (Indonesia) 0x0421 id-ID
const auto SUBLANG_INUKTITUT_CANADA                     = 0x01    ; // Inuktitut (Syllabics) (Canada) 0x045d iu-CA-Cans
const auto SUBLANG_INUKTITUT_CANADA_LATIN               = 0x02    ; // Inuktitut (Canada - Latin)
const auto SUBLANG_IRISH_IRELAND                        = 0x02    ; // Irish (Ireland)
const auto SUBLANG_ITALIAN                              = 0x01    ; // Italian
const auto SUBLANG_ITALIAN_SWISS                        = 0x02    ; // Italian (Swiss)
const auto SUBLANG_JAPANESE_JAPAN                       = 0x01    ; // Japanese (Japan) 0x0411
const auto SUBLANG_KANNADA_INDIA                        = 0x01    ; // Kannada (India (Kannada Script)) 0x044b kn-
const auto SUBLANG_KASHMIRI_SASIA                       = 0x02    ; // Kashmiri (South Asia)
const auto SUBLANG_KASHMIRI_INDIA                       = 0x02    ; // For app compatibility only
const auto SUBLANG_KAZAK_KAZAKHSTAN                     = 0x01    ; // Kazakh (Kazakhstan) 0x043f kk-KZ
const auto SUBLANG_KHMER_CAMBODIA                       = 0x01    ; // Khmer (Cambodia) 0x0453 kh-KH
const auto SUBLANG_KICHE_GUATEMALA                      = 0x01    ; // K'iche (Guatemala)
const auto SUBLANG_KINYARWANDA_RWANDA                   = 0x01    ; // Kinyarwanda (Rwanda) 0x0487 rw-RW
const auto SUBLANG_KONKANI_INDIA                        = 0x01    ; // Konkani (India) 0x0457 kok-
const auto SUBLANG_KOREAN                               = 0x01    ; // Korean (Extended Wansung)
const auto SUBLANG_KYRGYZ_KYRGYZSTAN                    = 0x01    ; // Kyrgyz (Kyrgyzstan) 0x0440 ky-KG
const auto SUBLANG_LAO_LAO                              = 0x01    ; // Lao (Lao PDR) 0x0454 lo-LA
const auto SUBLANG_LATVIAN_LATVIA                       = 0x01    ; // Latvian (Latvia) 0x0426 lv-LV
const auto SUBLANG_LITHUANIAN                           = 0x01    ; // Lithuanian
const auto SUBLANG_LOWER_SORBIAN_GERMANY                = 0x02    ; // Lower Sorbian (Germany) 0x082e wee-DE
const auto SUBLANG_LUXEMBOURGISH_LUXEMBOURG             = 0x01    ; // Luxembourgish (Luxembourg) 0x046e lb-LU
const auto SUBLANG_MACEDONIAN_MACEDONIA                 = 0x01    ; // Macedonian (Macedonia (FYROM)) 0x042f mk-MK
const auto SUBLANG_MALAY_MALAYSIA                       = 0x01    ; // Malay (Malaysia)
const auto SUBLANG_MALAY_BRUNEI_DARUSSALAM              = 0x02    ; // Malay (Brunei Darussalam)
const auto SUBLANG_MALAYALAM_INDIA                      = 0x01    ; // Malayalam (India (Malayalam Script) ) 0x044c ml-
const auto SUBLANG_MALTESE_MALTA                        = 0x01    ; // Maltese (Malta) 0x043a mt-MT
const auto SUBLANG_MAORI_NEW_ZEALAND                    = 0x01    ; // Maori (New Zealand) 0x0481 mi-NZ
const auto SUBLANG_MAPUDUNGUN_CHILE                     = 0x01    ; // Mapudungun (Chile) 0x047a arn-CL
const auto SUBLANG_MARATHI_INDIA                        = 0x01    ; // Marathi (India) 0x044e mr-
const auto SUBLANG_MOHAWK_MOHAWK                        = 0x01    ; // Mohawk (Mohawk) 0x047c moh-CA
const auto SUBLANG_MONGOLIAN_CYRILLIC_MONGOLIA          = 0x01    ; // Mongolian (Cyrillic, Mongolia)
const auto SUBLANG_MONGOLIAN_PRC                        = 0x02    ; // Mongolian (PRC)
const auto SUBLANG_NEPALI_INDIA                         = 0x02    ; // Nepali (India)
const auto SUBLANG_NEPALI_NEPAL                         = 0x01    ; // Nepali (Nepal) 0x0461 ne-NP
const auto SUBLANG_NORWEGIAN_BOKMAL                     = 0x01    ; // Norwegian (Bokmal)
const auto SUBLANG_NORWEGIAN_NYNORSK                    = 0x02    ; // Norwegian (Nynorsk)
const auto SUBLANG_OCCITAN_FRANCE                       = 0x01    ; // Occitan (France) 0x0482 oc-FR
const auto SUBLANG_ORIYA_INDIA                          = 0x01    ; // Oriya (India (Oriya Script)) 0x0448 or-
const auto SUBLANG_PASHTO_AFGHANISTAN                   = 0x01    ; // Pashto (Afghanistan)
const auto SUBLANG_PERSIAN_IRAN                         = 0x01    ; // Persian (Iran) 0x0429 fa-IR
const auto SUBLANG_POLISH_POLAND                        = 0x01    ; // Polish (Poland) 0x0415
const auto SUBLANG_PORTUGUESE                           = 0x02    ; // Portuguese
const auto SUBLANG_PORTUGUESE_BRAZILIAN                 = 0x01    ; // Portuguese (Brazilian)
const auto SUBLANG_PUNJABI_INDIA                        = 0x01    ; // Punjabi (India (Gurmukhi Script)) 0x0446 pa-
const auto SUBLANG_QUECHUA_BOLIVIA                      = 0x01    ; // Quechua (Bolivia)
const auto SUBLANG_QUECHUA_ECUADOR                      = 0x02    ; // Quechua (Ecuador)
const auto SUBLANG_QUECHUA_PERU                         = 0x03    ; // Quechua (Peru)
const auto SUBLANG_ROMANIAN_ROMANIA                     = 0x01    ; // Romanian (Romania) 0x0418
const auto SUBLANG_ROMANSH_SWITZERLAND                  = 0x01    ; // Romansh (Switzerland) 0x0417 rm-CH
const auto SUBLANG_RUSSIAN_RUSSIA                       = 0x01    ; // Russian (Russia) 0x0419
const auto SUBLANG_SAMI_NORTHERN_NORWAY                 = 0x01    ; // Northern Sami (Norway)
const auto SUBLANG_SAMI_NORTHERN_SWEDEN                 = 0x02    ; // Northern Sami (Sweden)
const auto SUBLANG_SAMI_NORTHERN_FINLAND                = 0x03    ; // Northern Sami (Finland)
const auto SUBLANG_SAMI_LULE_NORWAY                     = 0x04    ; // Lule Sami (Norway)
const auto SUBLANG_SAMI_LULE_SWEDEN                     = 0x05    ; // Lule Sami (Sweden)
const auto SUBLANG_SAMI_SOUTHERN_NORWAY                 = 0x06    ; // Southern Sami (Norway)
const auto SUBLANG_SAMI_SOUTHERN_SWEDEN                 = 0x07    ; // Southern Sami (Sweden)
const auto SUBLANG_SAMI_SKOLT_FINLAND                   = 0x08    ; // Skolt Sami (Finland)
const auto SUBLANG_SAMI_INARI_FINLAND                   = 0x09    ; // Inari Sami (Finland)
const auto SUBLANG_SANSKRIT_INDIA                       = 0x01    ; // Sanskrit (India) 0x044f sa-
const auto SUBLANG_SERBIAN_BOSNIA_HERZEGOVINA_LATIN     = 0x06    ; // Serbian (Bosnia and Herzegovina - Latin)
const auto SUBLANG_SERBIAN_BOSNIA_HERZEGOVINA_CYRILLIC  = 0x07    ; // Serbian (Bosnia and Herzegovina - Cyrillic)
const auto SUBLANG_SERBIAN_CROATIA                      = 0x01    ; // Croatian (Croatia) 0x041a hr-HR
const auto SUBLANG_SERBIAN_LATIN                        = 0x02    ; // Serbian (Latin)
const auto SUBLANG_SERBIAN_CYRILLIC                     = 0x03    ; // Serbian (Cyrillic)
const auto SUBLANG_SINDHI_INDIA                         = 0x01    ; // Sindhi (India) reserved 0x0459
const auto SUBLANG_SINDHI_PAKISTAN                      = 0x02    ; // Sindhi (Pakistan) reserved 0x0859
const auto SUBLANG_SINDHI_AFGHANISTAN                   = 0x02    ; // For app compatibility only
const auto SUBLANG_SINHALESE_SRI_LANKA                  = 0x01    ; // Sinhalese (Sri Lanka)
const auto SUBLANG_SOTHO_NORTHERN_SOUTH_AFRICA          = 0x01    ; // Northern Sotho (South Africa)
const auto SUBLANG_SLOVAK_SLOVAKIA                      = 0x01    ; // Slovak (Slovakia) 0x041b sk-SK
const auto SUBLANG_SLOVENIAN_SLOVENIA                   = 0x01    ; // Slovenian (Slovenia) 0x0424 sl-SI
const auto SUBLANG_SPANISH                              = 0x01    ; // Spanish (Castilian)
const auto SUBLANG_SPANISH_MEXICAN                      = 0x02    ; // Spanish (Mexican)
const auto SUBLANG_SPANISH_MODERN                       = 0x03    ; // Spanish (Modern)
const auto SUBLANG_SPANISH_GUATEMALA                    = 0x04    ; // Spanish (Guatemala)
const auto SUBLANG_SPANISH_COSTA_RICA                   = 0x05    ; // Spanish (Costa Rica)
const auto SUBLANG_SPANISH_PANAMA                       = 0x06    ; // Spanish (Panama)
const auto SUBLANG_SPANISH_DOMINICAN_REPUBLIC           = 0x07    ; // Spanish (Dominican Republic)
const auto SUBLANG_SPANISH_VENEZUELA                    = 0x08    ; // Spanish (Venezuela)
const auto SUBLANG_SPANISH_COLOMBIA                     = 0x09    ; // Spanish (Colombia)
const auto SUBLANG_SPANISH_PERU                         = 0x0a    ; // Spanish (Peru)
const auto SUBLANG_SPANISH_ARGENTINA                    = 0x0b    ; // Spanish (Argentina)
const auto SUBLANG_SPANISH_ECUADOR                      = 0x0c    ; // Spanish (Ecuador)
const auto SUBLANG_SPANISH_CHILE                        = 0x0d    ; // Spanish (Chile)
const auto SUBLANG_SPANISH_URUGUAY                      = 0x0e    ; // Spanish (Uruguay)
const auto SUBLANG_SPANISH_PARAGUAY                     = 0x0f    ; // Spanish (Paraguay)
const auto SUBLANG_SPANISH_BOLIVIA                      = 0x10    ; // Spanish (Bolivia)
const auto SUBLANG_SPANISH_EL_SALVADOR                  = 0x11    ; // Spanish (El Salvador)
const auto SUBLANG_SPANISH_HONDURAS                     = 0x12    ; // Spanish (Honduras)
const auto SUBLANG_SPANISH_NICARAGUA                    = 0x13    ; // Spanish (Nicaragua)
const auto SUBLANG_SPANISH_PUERTO_RICO                  = 0x14    ; // Spanish (Puerto Rico)
const auto SUBLANG_SPANISH_US                           = 0x15    ; // Spanish (United States)
const auto SUBLANG_SWAHILI_KENYA                        = 0x01    ; // Swahili (Kenya) 0x0441 sw-KE
const auto SUBLANG_SWEDISH                              = 0x01    ; // Swedish
const auto SUBLANG_SWEDISH_FINLAND                      = 0x02    ; // Swedish (Finland)
const auto SUBLANG_SYRIAC_SYRIA                         = 0x01    ; // Syriac (Syria) 0x045a syr-SY
const auto SUBLANG_TAJIK_TAJIKISTAN                     = 0x01    ; // Tajik (Tajikistan) 0x0428 tg-TJ-Cyrl
const auto SUBLANG_TAMAZIGHT_ALGERIA_LATIN              = 0x02    ; // Tamazight (Latin, Algeria) 0x085f tmz-DZ-Latn
const auto SUBLANG_TAMIL_INDIA                          = 0x01    ; // Tamil (India)
const auto SUBLANG_TATAR_RUSSIA                         = 0x01    ; // Tatar (Russia) 0x0444 tt-RU
const auto SUBLANG_TELUGU_INDIA                         = 0x01    ; // Telugu (India (Telugu Script)) 0x044a te-
const auto SUBLANG_THAI_THAILAND                        = 0x01    ; // Thai (Thailand) 0x041e th-TH
const auto SUBLANG_TIBETAN_PRC                          = 0x01    ; // Tibetan (PRC)
const auto SUBLANG_TIGRIGNA_ERITREA                     = 0x02    ; // Tigrigna (Eritrea)
const auto SUBLANG_TSWANA_SOUTH_AFRICA                  = 0x01    ; // Setswana / Tswana (South Africa) 0x0432 tn-ZA
const auto SUBLANG_TURKISH_TURKEY                       = 0x01    ; // Turkish (Turkey) 0x041f tr-TR
const auto SUBLANG_TURKMEN_TURKMENISTAN                 = 0x01    ; // Turkmen (Turkmenistan) 0x0442 tk-TM
const auto SUBLANG_UIGHUR_PRC                           = 0x01    ; // Uighur (PRC) 0x0480 ug-CN
const auto SUBLANG_UKRAINIAN_UKRAINE                    = 0x01    ; // Ukrainian (Ukraine) 0x0422 uk-UA
const auto SUBLANG_UPPER_SORBIAN_GERMANY                = 0x01    ; // Upper Sorbian (Germany) 0x042e wen-DE
const auto SUBLANG_URDU_PAKISTAN                        = 0x01    ; // Urdu (Pakistan)
const auto SUBLANG_URDU_INDIA                           = 0x02    ; // Urdu (India)
const auto SUBLANG_UZBEK_LATIN                          = 0x01    ; // Uzbek (Latin)
const auto SUBLANG_UZBEK_CYRILLIC                       = 0x02    ; // Uzbek (Cyrillic)
const auto SUBLANG_VIETNAMESE_VIETNAM                   = 0x01    ; // Vietnamese (Vietnam) 0x042a vi-VN
const auto SUBLANG_WELSH_UNITED_KINGDOM                 = 0x01    ; // Welsh (United Kingdom) 0x0452 cy-GB
const auto SUBLANG_WOLOF_SENEGAL                        = 0x01    ; // Wolof (Senegal)
const auto SUBLANG_XHOSA_SOUTH_AFRICA                   = 0x01    ; // isiXhosa / Xhosa (South Africa) 0x0434 xh-ZA
const auto SUBLANG_YAKUT_RUSSIA                         = 0x01    ; // Yakut (Russia) 0x0485 sah-RU
const auto SUBLANG_YI_PRC                               = 0x01    ; // Yi (PRC)) 0x0478
const auto SUBLANG_YORUBA_NIGERIA                       = 0x01    ; // Yoruba (Nigeria) 046a yo-NG
const auto SUBLANG_ZULU_SOUTH_AFRICA                    = 0x01    ; // isiZulu / Zulu (South Africa) 0x0435 zu-ZA




//
//  Sorting IDs.
//

const auto SORT_DEFAULT                      = 0x0     ; // sorting default

const auto SORT_INVARIANT_MATH               = 0x1     ; // Invariant (Mathematical Symbols)

const auto SORT_JAPANESE_XJIS                = 0x0     ; // Japanese XJIS order
const auto SORT_JAPANESE_UNICODE             = 0x1     ; // Japanese Unicode order (no longer supported)
const auto SORT_JAPANESE_RADICALSTROKE       = 0x4     ; // Japanese radical/stroke order

const auto SORT_CHINESE_BIG5                 = 0x0     ; // Chinese BIG5 order
const auto SORT_CHINESE_PRCP                 = 0x0     ; // PRC Chinese Phonetic order
const auto SORT_CHINESE_UNICODE              = 0x1     ; // Chinese Unicode order (no longer supported)
const auto SORT_CHINESE_PRC                  = 0x2     ; // PRC Chinese Stroke Count order
const auto SORT_CHINESE_BOPOMOFO             = 0x3     ; // Traditional Chinese Bopomofo order

const auto SORT_KOREAN_KSC                   = 0x0     ; // Korean KSC order
const auto SORT_KOREAN_UNICODE               = 0x1     ; // Korean Unicode order (no longer supported)

const auto SORT_GERMAN_PHONE_BOOK            = 0x1     ; // German Phone Book order

const auto SORT_HUNGARIAN_DEFAULT            = 0x0     ; // Hungarian Default order
const auto SORT_HUNGARIAN_TECHNICAL          = 0x1     ; // Hungarian Technical order

const auto SORT_GEORGIAN_TRADITIONAL         = 0x0     ; // Georgian Traditional order
const auto SORT_GEORGIAN_MODERN              = 0x1     ; // Georgian Modern order

// end_r_winnt

//
//  A language ID is a 16 bit value which is the combination of a
//  primary language ID and a secondary language ID.  The bits are
//  allocated as follows:
//
//       +-----------------------+-------------------------+
//       |     Sublanguage ID    |   Primary Language ID   |
//       +-----------------------+-------------------------+
//        15                   10 9                       0   bit
//
//
//  Language ID creation/extraction macros:
//
//    MAKELANGID    - construct language id from a primary language id and
//                    a sublanguage id.
//    PRIMARYLANGID - extract primary language id from a language id.
//    SUBLANGID     - extract sublanguage id from a language id.
//

template MAKELANGID(uint p, uint s) {
	const WORD MAKELANGID = ((cast(WORD)s) << 10) | cast(WORD)p;
}
/*
const auto MAKELANGID(p,  = s)       ((((WORD  )(s)) << 10) | (WORD  )(p));
const auto PRIMARYLANGID(lgid)     = ((WORD  )(lgid) & 0x3ff);
const auto SUBLANGID(lgid)         = ((WORD  )(lgid) >> 10); */


//
//  A locale ID is a 32 bit value which is the combination of a
//  language ID, a sort ID, and a reserved area.  The bits are
//  allocated as follows:
//
//       +-------------+---------+-------------------------+
//       |   Reserved  | Sort ID |      Language ID        |
//       +-------------+---------+-------------------------+
//        31         20 19     16 15                      0   bit
//
//
//  Locale ID creation/extraction macros:
//
//    MAKELCID            - construct the locale id from a language id and a sort id.
//    MAKESORTLCID        - construct the locale id from a language id, sort id, and sort version.
//    LANGIDFROMLCID      - extract the language id from a locale id.
//    SORTIDFROMLCID      - extract the sort id from a locale id.
//    SORTVERSIONFROMLCID - extract the sort version from a locale id.
//

const auto NLS_VALID_LOCALE_MASK   = 0x000fffff;

template MAKELCID(uint lgid, uint srtid) {
	const DWORD MAKELCID = (cast(DWORD)(((cast(DWORD)(cast(WORD)(srtid))) << 16) |(cast(DWORD)(cast(WORD)(lgid)))));
}
// const auto MAKELCID(lgid,  = srtid)  ((DWORD)((((DWORD)((WORD  )(srtid))) << 16) |((DWORD)((WORD  )(lgid)))))
// const auto MAKESORTLCID(lgid,  = srtid, ver)                                            \;
//                                ((DWORD)((MAKELCID(lgid, srtid)) |             \
//                                     (((DWORD)((WORD  )(ver))) << 20)))
// const auto LANGIDFROMLCID(lcid)    = ((WORD  )(lcid));
// const auto SORTIDFROMLCID(lcid)    = ((WORD  )((((DWORD)(lcid)) >> 16) & 0xf));
// const auto SORTVERSIONFROMLCID(lcid)   = ((WORD  )((((DWORD)(lcid)) >> 20) & 0xf));

// 8 characters for language
// 8 characters for region
// 64 characters for suffix (script)
// 2 characters for '-' separators
// 2 characters for prefix like "i-" or "x-"
// 1 null termination
const auto LOCALE_NAME_MAX_LENGTH    = 85;

//
//  Default System and User IDs for language and locale.
//

const auto LANG_SYSTEM_DEFAULT     = (MAKELANGID!(LANG_NEUTRAL, SUBLANG_SYS_DEFAULT));
const auto LANG_USER_DEFAULT       = (MAKELANGID!(LANG_NEUTRAL, SUBLANG_DEFAULT));
//
const auto LOCALE_SYSTEM_DEFAULT   = (MAKELCID!(LANG_SYSTEM_DEFAULT, SORT_DEFAULT));
const auto LOCALE_USER_DEFAULT     = (MAKELCID!(LANG_USER_DEFAULT, SORT_DEFAULT));

//
//  Other special IDs for language and locale.
//
const auto LOCALE_CUSTOM_DEFAULT                                                  =
          (MAKELCID!(MAKELANGID!(LANG_NEUTRAL, SUBLANG_CUSTOM_DEFAULT), SORT_DEFAULT));

const auto LOCALE_CUSTOM_UNSPECIFIED                                              =
          (MAKELCID!(MAKELANGID!(LANG_NEUTRAL, SUBLANG_CUSTOM_UNSPECIFIED), SORT_DEFAULT));

const auto LOCALE_CUSTOM_UI_DEFAULT                                               =
          (MAKELCID!(MAKELANGID!(LANG_NEUTRAL, SUBLANG_UI_CUSTOM_DEFAULT), SORT_DEFAULT));

const auto LOCALE_NEUTRAL                                                         =
          (MAKELCID!(MAKELANGID!(LANG_NEUTRAL, SUBLANG_NEUTRAL), SORT_DEFAULT));

const auto LOCALE_INVARIANT                                                       =
          (MAKELCID!(MAKELANGID!(LANG_INVARIANT, SUBLANG_NEUTRAL), SORT_DEFAULT));

// begin_ntminiport begin_ntndis begin_ntminitape

//
// Macros used to eliminate compiler warning generated when formal
// parameters or local variables are not declared.
//
// Use DBG_UNREFERENCED_PARAMETER() when a parameter is not yet
// referenced but will be once the module is completely developed.
//
// Use DBG_UNREFERENCED_LOCAL_VARIABLE() when a local variable is not yet
// referenced but will be once the module is completely developed.
//
// Use UNREFERENCED_PARAMETER() if a parameter will never be referenced.
//
// DBG_UNREFERENCED_PARAMETER and DBG_UNREFERENCED_LOCAL_VARIABLE will
// eventually be made into a null macro to help determine whether there
// is unfinished work.
//

// Note: lint -e530 says don't complain about uninitialized variables for
// this varible.  Error 527 has to do with unreachable code.
// -restore restores checking to the -save state

//
// Macro used to eliminate compiler warning 4715 within a switch statement
// when all possible cases have already been accounted for.
//
// switch (a & 3) {
//     case 0: return 1;
//     case 1: return Foo();
//     case 2: return Bar();
//     case 3: return 1;
//     DEFAULT_UNREACHABLE;
//

//
// Older compilers do not support __assume(), and there is no other free
// method of eliminating the warning.
//

/*lint -save -e767 */  
const auto STATUS_WAIT_0                     = (cast(DWORD   )0x00000000L)    ;
const auto STATUS_ABANDONED_WAIT_0           = (cast(DWORD   )0x00000080L)    ;
const auto STATUS_USER_APC                   = (cast(DWORD   )0x000000C0L)    ;
const auto STATUS_TIMEOUT                    = (cast(DWORD   )0x00000102L)    ;
const auto STATUS_PENDING                    = (cast(DWORD   )0x00000103L)    ;
const auto DBG_EXCEPTION_HANDLED             = (cast(DWORD   )0x00010001L)    ;
const auto DBG_CONTINUE                      = (cast(DWORD   )0x00010002L)    ;
const auto STATUS_SEGMENT_NOTIFICATION       = (cast(DWORD   )0x40000005L)    ;
const auto DBG_TERMINATE_THREAD              = (cast(DWORD   )0x40010003L)    ;
const auto DBG_TERMINATE_PROCESS             = (cast(DWORD   )0x40010004L)    ;
const auto DBG_CONTROL_C                     = (cast(DWORD   )0x40010005L)    ;
const auto DBG_CONTROL_BREAK                 = (cast(DWORD   )0x40010008L)    ;
const auto DBG_COMMAND_EXCEPTION             = (cast(DWORD   )0x40010009L)    ;
const auto STATUS_GUARD_PAGE_VIOLATION       = (cast(DWORD   )0x80000001L)    ;
const auto STATUS_DATATYPE_MISALIGNMENT      = (cast(DWORD   )0x80000002L)    ;
const auto STATUS_BREAKPOINT                 = (cast(DWORD   )0x80000003L)    ;
const auto STATUS_SINGLE_STEP                = (cast(DWORD   )0x80000004L)    ;
const auto DBG_EXCEPTION_NOT_HANDLED         = (cast(DWORD   )0x80010001L)    ;
const auto STATUS_ACCESS_VIOLATION           = (cast(DWORD   )0xC0000005L)    ;
const auto STATUS_IN_PAGE_ERROR              = (cast(DWORD   )0xC0000006L)    ;
const auto STATUS_INVALID_HANDLE             = (cast(DWORD   )0xC0000008L)    ;
const auto STATUS_NO_MEMORY                  = (cast(DWORD   )0xC0000017L)    ;
const auto STATUS_ILLEGAL_INSTRUCTION        = (cast(DWORD   )0xC000001DL)    ;
const auto STATUS_NONCONTINUABLE_EXCEPTION   = (cast(DWORD   )0xC0000025L)    ;
const auto STATUS_INVALID_DISPOSITION        = (cast(DWORD   )0xC0000026L)    ;
const auto STATUS_ARRAY_BOUNDS_EXCEEDED      = (cast(DWORD   )0xC000008CL)    ;
const auto STATUS_FLOAT_DENORMAL_OPERAND     = (cast(DWORD   )0xC000008DL)    ;
const auto STATUS_FLOAT_DIVIDE_BY_ZERO       = (cast(DWORD   )0xC000008EL)    ;
const auto STATUS_FLOAT_INEXACT_RESULT       = (cast(DWORD   )0xC000008FL)    ;
const auto STATUS_FLOAT_INVALID_OPERATION    = (cast(DWORD   )0xC0000090L)    ;
const auto STATUS_FLOAT_OVERFLOW             = (cast(DWORD   )0xC0000091L)    ;
const auto STATUS_FLOAT_STACK_CHECK          = (cast(DWORD   )0xC0000092L)    ;
const auto STATUS_FLOAT_UNDERFLOW            = (cast(DWORD   )0xC0000093L)    ;
const auto STATUS_INTEGER_DIVIDE_BY_ZERO     = (cast(DWORD   )0xC0000094L)    ;
const auto STATUS_INTEGER_OVERFLOW           = (cast(DWORD   )0xC0000095L)    ;
const auto STATUS_PRIVILEGED_INSTRUCTION     = (cast(DWORD   )0xC0000096L)    ;
const auto STATUS_STACK_OVERFLOW             = (cast(DWORD   )0xC00000FDL)    ;
const auto STATUS_CONTROL_C_EXIT             = (cast(DWORD   )0xC000013AL)    ;
const auto STATUS_FLOAT_MULTIPLE_FAULTS      = (cast(DWORD   )0xC00002B4L)    ;
const auto STATUS_FLOAT_MULTIPLE_TRAPS       = (cast(DWORD   )0xC00002B5L)    ;
const auto STATUS_REG_NAT_CONSUMPTION        = (cast(DWORD   )0xC00002C9L)    ;

const auto STATUS_SXS_EARLY_DEACTIVATION     = (cast(DWORD   )0xC015000FL)    ;
const auto STATUS_SXS_INVALID_DEACTIVATION   = (cast(DWORD   )0xC0150010L)    ;

const auto MAXIMUM_WAIT_OBJECTS  = 64     ; // Maximum number of wait objects

const auto MAXIMUM_SUSPEND_COUNT  = MAXCHAR ; // Maximum times thread can be suspended

alias ULONG_PTR KSPIN_LOCK;
alias KSPIN_LOCK *PKSPIN_LOCK;

//
// PreFetchCacheLine level defines.
//

/*const auto PF_TEMPORAL_LEVEL_1  = _MM_HINT_T0;
const auto PF_TEMPORAL_LEVEL_2  = _MM_HINT_T1;
const auto PF_TEMPORAL_LEVEL_3  = _MM_HINT_T2;
const auto PF_NON_TEMPORAL_LEVEL_ALL  = _MM_HINT_NTA;
*/

//
// The following values specify the type of access in the first parameter
// of the exception record whan the exception code specifies an access
// violation.
//

const auto EXCEPTION_READ_FAULT  = 0          ; // exception caused by a read
const auto EXCEPTION_WRITE_FAULT  = 1         ; // exception caused by a write
const auto EXCEPTION_EXECUTE_FAULT  = 8       ; // exception caused by an instruction fetch

// begin_wx86
//
// The following flags control the contents of the CONTEXT structure.
//

const auto CONTEXT_AMD64    = 0x100000;

// end_wx86

const auto CONTEXT_CONTROL  = (CONTEXT_AMD64 | 0x1L);
const auto CONTEXT_INTEGER  = (CONTEXT_AMD64 | 0x2L);
const auto CONTEXT_SEGMENTS  = (CONTEXT_AMD64 | 0x4L);
const auto CONTEXT_FLOATING_POINT   = (CONTEXT_AMD64 | 0x8L);
const auto CONTEXT_DEBUG_REGISTERS  = (CONTEXT_AMD64 | 0x10L);

const auto CONTEXT_FULL  = (CONTEXT_CONTROL | CONTEXT_INTEGER | CONTEXT_FLOATING_POINT);

const auto CONTEXT_ALL  = (CONTEXT_CONTROL | CONTEXT_INTEGER | CONTEXT_SEGMENTS | CONTEXT_FLOATING_POINT | CONTEXT_DEBUG_REGISTERS);

const auto CONTEXT_EXCEPTION_ACTIVE  = 0x8000000;
const auto CONTEXT_SERVICE_ACTIVE  = 0x10000000;
const auto CONTEXT_EXCEPTION_REQUEST  = 0x40000000;
const auto CONTEXT_EXCEPTION_REPORTING  = 0x80000000;

// begin_wx86

//
// Define initial MxCsr and FpCsr control.
//

const auto INITIAL_MXCSR  = 0x1f80            ; // initial MXCSR value
const auto INITIAL_FPCSR  = 0x027f            ; // initial FPCSR value

//
// Define 128-bit 16-byte aligned xmm register type.
//

struct M128A {
    ULONGLONG Low;
    LONGLONG High;
}

alias M128A* PM128A;

//
// Format of data for 32-bit fxsave/fxrstor instructions.
//

struct XMM_SAVE_AREA32 {
    WORD   ControlWord;
    WORD   StatusWord;
    BYTE  TagWord;
    BYTE  Reserved1;
    WORD   ErrorOpcode;
    DWORD ErrorOffset;
    WORD   ErrorSelector;
    WORD   Reserved2;
    DWORD DataOffset;
    WORD   DataSelector;
    WORD   Reserved3;
    DWORD MxCsr;
    DWORD MxCsr_Mask;
    M128A[8] FloatRegisters;
    M128A[16] XmmRegisters;
    BYTE[96]  Reserved4;
}

alias XMM_SAVE_AREA32* PXMM_SAVE_AREA32;

const auto LEGACY_SAVE_AREA_LENGTH  = XMM_SAVE_AREA32.sizeof;

//
// Context Frame
//
//  This frame has a several purposes: 1) it is used as an argument to
//  NtContinue, 2) is is used to constuct a call frame for APC delivery,
//  and 3) it is used in the user level thread creation routines.
//
//
// The flags field within this record controls the contents of a CONTEXT
// record.
//
// If the context record is used as an input parameter, then for each
// portion of the context record controlled by a flag whose value is
// set, it is assumed that that portion of the context record contains
// valid context. If the context record is being used to modify a threads
// context, then only that portion of the threads context is modified.
//
// If the context record is used as an output parameter to capture the
// context of a thread, then only those portions of the thread's context
// corresponding to set flags will be returned.
//
// CONTEXT_CONTROL specifies SegSs, Rsp, SegCs, Rip, and EFlags.
//
// CONTEXT_INTEGER specifies Rax, Rcx, Rdx, Rbx, Rbp, Rsi, Rdi, and R8-R15.
//
// CONTEXT_SEGMENTS specifies SegDs, SegEs, SegFs, and SegGs.
//
// CONTEXT_DEBUG_REGISTERS specifies Dr0-Dr3 and Dr6-Dr7.
//
// CONTEXT_MMX_REGISTERS specifies the floating point and extended registers
//     Mm0/St0-Mm7/St7 and Xmm0-Xmm15).
//

struct CONTEXT {

    //
    // Register parameter home addresses.
    //
    // N.B. These fields are for convience - they could be used to extend the
    //      context record in the future.
    //

    DWORD64 P1Home;
    DWORD64 P2Home;
    DWORD64 P3Home;
    DWORD64 P4Home;
    DWORD64 P5Home;
    DWORD64 P6Home;

    //
    // Control flags.
    //

    DWORD ContextFlags;
    DWORD MxCsr;

    //
    // Segment Registers and processor flags.
    //

    WORD   SegCs;
    WORD   SegDs;
    WORD   SegEs;
    WORD   SegFs;
    WORD   SegGs;
    WORD   SegSs;
    DWORD EFlags;

    //
    // Debug registers
    //

    DWORD64 Dr0;
    DWORD64 Dr1;
    DWORD64 Dr2;
    DWORD64 Dr3;
    DWORD64 Dr6;
    DWORD64 Dr7;

    //
    // Integer registers.
    //

    DWORD64 Rax;
    DWORD64 Rcx;
    DWORD64 Rdx;
    DWORD64 Rbx;
    DWORD64 Rsp;
    DWORD64 Rbp;
    DWORD64 Rsi;
    DWORD64 Rdi;
    DWORD64 R8;
    DWORD64 R9;
    DWORD64 R10;
    DWORD64 R11;
    DWORD64 R12;
    DWORD64 R13;
    DWORD64 R14;
    DWORD64 R15;

    //
    // Program counter.
    //

    DWORD64 Rip;

    //
    // Floating point state.
    //

    union _inner_union {
        XMM_SAVE_AREA32 FltSave;
        struct _inner_struct {
            M128A Header[2];
            M128A Legacy[8];
            M128A Xmm0;
            M128A Xmm1;
            M128A Xmm2;
            M128A Xmm3;
            M128A Xmm4;
            M128A Xmm5;
            M128A Xmm6;
            M128A Xmm7;
            M128A Xmm8;
            M128A Xmm9;
            M128A Xmm10;
            M128A Xmm11;
            M128A Xmm12;
            M128A Xmm13;
            M128A Xmm14;
            M128A Xmm15;
        }

        _inner_struct regs;
    }

    _inner_union xmm;

    //
    // Vector registers.
    //

    M128A VectorRegister[26];
    DWORD64 VectorControl;

    //
    // Special debug control registers.
    //

    DWORD64 DebugControl;
    DWORD64 LastBranchToRip;
    DWORD64 LastBranchFromRip;
    DWORD64 LastExceptionToRip;
    DWORD64 LastExceptionFromRip;
}

alias CONTEXT* PCONTEXT;

//
// Define function table entry - a function table entry is generated for
// each frame function.
//

const auto RUNTIME_FUNCTION_INDIRECT  = 0x1;

struct RUNTIME_FUNCTION {
    DWORD BeginAddress;
    DWORD EndAddress;
    DWORD UnwindData;
}

alias RUNTIME_FUNCTION* PRUNTIME_FUNCTION;

//
// Define dynamic function table entry.
//

alias PRUNTIME_FUNCTION function(DWORD64, PVOID) PGET_RUNTIME_FUNCTION_CALLBACK;

alias DWORD function(HANDLE, PVOID, PDWORD, PRUNTIME_FUNCTION* Functions) POUT_OF_PROCESS_FUNCTION_TABLE_CALLBACK;

const auto OUT_OF_PROCESS_FUNCTION_TABLE_CALLBACK_EXPORT_NAME  = "OutOfProcessFunctionTableCallback"c;

//
// Define runtime exception handling prototypes.
//


VOID

RtlRestoreContext (
     PCONTEXT ContextRecord,
     EXCEPTION_RECORD *ExceptionRecord
   );



BOOLEAN

RtlAddFunctionTable (
     PRUNTIME_FUNCTION FunctionTable,
     DWORD EntryCount,
     DWORD64 BaseAddress
    );


BOOLEAN

RtlInstallFunctionTableCallback (
     DWORD64 TableIdentifier,
     DWORD64 BaseAddress,
     DWORD Length,
     PGET_RUNTIME_FUNCTION_CALLBACK Callback,
     PVOID Context,
     PCWSTR OutOfProcessCallbackDll 
    );


BOOLEAN

RtlDeleteFunctionTable (
     PRUNTIME_FUNCTION FunctionTable
    );

// begin_wx86
// begin_ntddk

//
//  Define the size of the 80387 save area, which is in the context frame.
//

const auto SIZE_OF_80387_REGISTERS       = 80;

//
// The following flags control the contents of the CONTEXT structure.
//

const auto CONTEXT_i386     = 0x00010000    ; // this assumes that i386 and
const auto CONTEXT_i486     = 0x00010000    ; // i486 have identical context records


// begin_wx86

const auto MAXIMUM_SUPPORTED_EXTENSION      = 512;

struct FLOATING_SAVE_AREA {
    DWORD   ControlWord;
    DWORD   StatusWord;
    DWORD   TagWord;
    DWORD   ErrorOffset;
    DWORD   ErrorSelector;
    DWORD   DataOffset;
    DWORD   DataSelector;
    BYTE    RegisterArea[SIZE_OF_80387_REGISTERS];
    DWORD   Cr0NpxState;
}


alias FLOATING_SAVE_AREA *PFLOATING_SAVE_AREA;

//
// Context Frame
//
//  This frame has a several purposes: 1) it is used as an argument to
//  NtContinue, 2) is is used to constuct a call frame for APC delivery,
//  and 3) it is used in the user level thread creation routines.
//
//  The layout of the record conforms to a standard call frame.
//

struct _CONTEXT {

    //
    // The flags values within this flag control the contents of
    // a CONTEXT record.
    //
    // If the context record is used as an input parameter, then
    // for each portion of the context record controlled by a flag
    // whose value is set, it is assumed that that portion of the
    // context record contains valid context. If the context record
    // is being used to modify a threads context, then only that
    // portion of the threads context will be modified.
    //
    // If the context record is used as an   parameter to capture
    // the context of a thread, then only those portions of the thread's
    // context corresponding to set flags will be returned.
    //
    // The context record is never used as an  only parameter.
    //

    DWORD ContextFlags;

    //
    // This section is specified/returned if CONTEXT_DEBUG_REGISTERS is
    // set in ContextFlags.  Note that CONTEXT_DEBUG_REGISTERS is NOT
    // included in CONTEXT_FULL.
    //

    DWORD   Dr0;
    DWORD   Dr1;
    DWORD   Dr2;
    DWORD   Dr3;
    DWORD   Dr6;
    DWORD   Dr7;

    //
    // This section is specified/returned if the
    // ContextFlags word contians the flag CONTEXT_FLOATING_POINT.
    //

    FLOATING_SAVE_AREA FloatSave;

    //
    // This section is specified/returned if the
    // ContextFlags word contians the flag CONTEXT_SEGMENTS.
    //

    DWORD   SegGs;
    DWORD   SegFs;
    DWORD   SegEs;
    DWORD   SegDs;

    //
    // This section is specified/returned if the
    // ContextFlags word contians the flag CONTEXT_INTEGER.
    //

    DWORD   Edi;
    DWORD   Esi;
    DWORD   Ebx;
    DWORD   Edx;
    DWORD   Ecx;
    DWORD   Eax;

    //
    // This section is specified/returned if the
    // ContextFlags word contians the flag CONTEXT_CONTROL.
    //

    DWORD   Ebp;
    DWORD   Eip;
    DWORD   SegCs;              // MUST BE SANITIZED
    DWORD   EFlags;             // MUST BE SANITIZED
    DWORD   Esp;
    DWORD   SegSs;

    //
    // This section is specified/returned if the ContextFlags word
    // contains the flag CONTEXT_EXTENDED_REGISTERS.
    // The format and contexts are processor specific
    //

    BYTE    ExtendedRegisters[MAXIMUM_SUPPORTED_EXTENSION];

}




alias _CONTEXT *_PCONTEXT;

//
// __lfetch control defines.
//

const auto MD_LFHINT_NONE     = 0x00;
const auto MD_LFHINT_NT1      = 0x01;
const auto MD_LFHINT_NT2      = 0x02;
const auto MD_LFHINT_NTA      = 0x03;

//
// PreFetchCacheLine level defines.
//

const auto _PF_TEMPORAL_LEVEL_1          = MD_LFHINT_NONE;
const auto _PF_TEMPORAL_LEVEL_2          = MD_LFHINT_NT1;
const auto _PF_TEMPORAL_LEVEL_3          = MD_LFHINT_NT2;
const auto _PF_NON_TEMPORAL_LEVEL_ALL    = MD_LFHINT_NTA;


const auto CONTEXT_IA64                     = 0x00080000;

const auto _CONTEXT_CONTROL                  = (CONTEXT_IA64 | 0x00000001L);
const auto _CONTEXT_LOWER_FLOATING_POINT     = (CONTEXT_IA64 | 0x00000002L);
const auto _CONTEXT_HIGHER_FLOATING_POINT    = (CONTEXT_IA64 | 0x00000004L);
const auto _CONTEXT_INTEGER                  = (CONTEXT_IA64 | 0x00000008L);
const auto _CONTEXT_DEBUG                    = (CONTEXT_IA64 | 0x00000010L);
const auto _CONTEXT_IA32_CONTROL             = (CONTEXT_IA64 | 0x00000020L)  ; // Includes StIPSR


const auto _CONTEXT_FLOATING_POINT           = (_CONTEXT_LOWER_FLOATING_POINT | _CONTEXT_HIGHER_FLOATING_POINT);
const auto _CONTEXT_FULL                     = (_CONTEXT_CONTROL | _CONTEXT_FLOATING_POINT | _CONTEXT_INTEGER | _CONTEXT_IA32_CONTROL);
const auto _CONTEXT_ALL                      = (_CONTEXT_CONTROL | _CONTEXT_FLOATING_POINT | _CONTEXT_INTEGER | _CONTEXT_DEBUG | _CONTEXT_IA32_CONTROL);

const auto _CONTEXT_EXCEPTION_ACTIVE         = 0x8000000;
const auto _CONTEXT_SERVICE_ACTIVE           = 0x10000000;
const auto _CONTEXT_EXCEPTION_REQUEST        = 0x40000000;
const auto _CONTEXT_EXCEPTION_REPORTING      = 0x80000000;

const auto _OUT_OF_PROCESS_FUNCTION_TABLE_CALLBACK_EXPORT_NAME  = "OutOfProcessFunctionTableCallback"c;

const auto WOW64_CONTEXT_i386       = 0x00010000    ; // this assumes that i386 and
const auto WOW64_CONTEXT_i486       = 0x00010000    ; // i486 have identical context records

const auto WOW64_CONTEXT_CONTROL                = (WOW64_CONTEXT_i386 | 0x00000001L) ; // SS:SP, CS:IP, FLAGS, BP
const auto WOW64_CONTEXT_INTEGER                = (WOW64_CONTEXT_i386 | 0x00000002L) ; // AX, BX, CX, DX, SI, DI
const auto WOW64_CONTEXT_SEGMENTS               = (WOW64_CONTEXT_i386 | 0x00000004L) ; // DS, ES, FS, GS
const auto WOW64_CONTEXT_FLOATING_POINT         = (WOW64_CONTEXT_i386 | 0x00000008L) ; // 387 state
const auto WOW64_CONTEXT_DEBUG_REGISTERS        = (WOW64_CONTEXT_i386 | 0x00000010L) ; // DB 0-3,6,7
const auto WOW64_CONTEXT_EXTENDED_REGISTERS     = (WOW64_CONTEXT_i386 | 0x00000020L) ; // cpu specific extensions

const auto WOW64_CONTEXT_FULL       = (WOW64_CONTEXT_CONTROL | WOW64_CONTEXT_INTEGER | WOW64_CONTEXT_SEGMENTS);

const auto WOW64_CONTEXT_ALL        = (WOW64_CONTEXT_CONTROL | WOW64_CONTEXT_INTEGER | WOW64_CONTEXT_SEGMENTS |
                                 WOW64_CONTEXT_FLOATING_POINT | WOW64_CONTEXT_DEBUG_REGISTERS |
                                 WOW64_CONTEXT_EXTENDED_REGISTERS);

//
//  Define the size of the 80387 save area, which is in the context frame.
//

const auto WOW64_SIZE_OF_80387_REGISTERS       = 80;

const auto WOW64_MAXIMUM_SUPPORTED_EXTENSION      = 512;

struct WOW64_FLOATING_SAVE_AREA {
    DWORD   ControlWord;
    DWORD   StatusWord;
    DWORD   TagWord;
    DWORD   ErrorOffset;
    DWORD   ErrorSelector;
    DWORD   DataOffset;
    DWORD   DataSelector;
    BYTE    RegisterArea[WOW64_SIZE_OF_80387_REGISTERS];
    DWORD   Cr0NpxState;
}


alias WOW64_FLOATING_SAVE_AREA *PWOW64_FLOATING_SAVE_AREA;

//
// Context Frame
//
//  This frame has a several purposes: 1) it is used as an argument to
//  NtContinue, 2) is is used to constuct a call frame for APC delivery,
//  and 3) it is used in the user level thread creation routines.
//
//  The layout of the record conforms to a standard call frame.
//

struct WOW64_CONTEXT {

    //
    // The flags values within this flag control the contents of
    // a CONTEXT record.
    //
    // If the context record is used as an input parameter, then
    // for each portion of the context record controlled by a flag
    // whose value is set, it is assumed that that portion of the
    // context record contains valid context. If the context record
    // is being used to modify a threads context, then only that
    // portion of the threads context will be modified.
    //
    // If the context record is used as an   parameter to capture
    // the context of a thread, then only those portions of the thread's
    // context corresponding to set flags will be returned.
    //
    // The context record is never used as an  only parameter.
    //

    DWORD ContextFlags;

    //
    // This section is specified/returned if CONTEXT_DEBUG_REGISTERS is
    // set in ContextFlags.  Note that CONTEXT_DEBUG_REGISTERS is NOT
    // included in CONTEXT_FULL.
    //

    DWORD   Dr0;
    DWORD   Dr1;
    DWORD   Dr2;
    DWORD   Dr3;
    DWORD   Dr6;
    DWORD   Dr7;

    //
    // This section is specified/returned if the
    // ContextFlags word contians the flag CONTEXT_FLOATING_POINT.
    //

    WOW64_FLOATING_SAVE_AREA FloatSave;

    //
    // This section is specified/returned if the
    // ContextFlags word contians the flag CONTEXT_SEGMENTS.
    //

    DWORD   SegGs;
    DWORD   SegFs;
    DWORD   SegEs;
    DWORD   SegDs;

    //
    // This section is specified/returned if the
    // ContextFlags word contians the flag CONTEXT_INTEGER.
    //

    DWORD   Edi;
    DWORD   Esi;
    DWORD   Ebx;
    DWORD   Edx;
    DWORD   Ecx;
    DWORD   Eax;

    //
    // This section is specified/returned if the
    // ContextFlags word contians the flag CONTEXT_CONTROL.
    //

    DWORD   Ebp;
    DWORD   Eip;
    DWORD   SegCs;              // MUST BE SANITIZED
    DWORD   EFlags;             // MUST BE SANITIZED
    DWORD   Esp;
    DWORD   SegSs;

    //
    // This section is specified/returned if the ContextFlags word
    // contains the flag CONTEXT_EXTENDED_REGISTERS.
    // The format and contexts are processor specific
    //

    BYTE    ExtendedRegisters[WOW64_MAXIMUM_SUPPORTED_EXTENSION];

}


alias WOW64_CONTEXT *PWOW64_CONTEXT;

const auto EXCEPTION_NONCONTINUABLE  = 0x1    ; // Noncontinuable exception
const auto EXCEPTION_MAXIMUM_PARAMETERS  = 15 ; // maximum number of exception parameters

//
// Exception record definition.
//

struct EXCEPTION_RECORD {
    DWORD    ExceptionCode;
    DWORD ExceptionFlags;
    EXCEPTION_RECORD *ExceptionRecord;
    PVOID ExceptionAddress;
    DWORD NumberParameters;
    ULONG_PTR ExceptionInformation[EXCEPTION_MAXIMUM_PARAMETERS];
}


alias EXCEPTION_RECORD *PEXCEPTION_RECORD;

struct EXCEPTION_RECORD32 {
    DWORD    ExceptionCode;
    DWORD ExceptionFlags;
    DWORD ExceptionRecord;
    DWORD ExceptionAddress;
    DWORD NumberParameters;
    DWORD ExceptionInformation[EXCEPTION_MAXIMUM_PARAMETERS];
}

alias EXCEPTION_RECORD32* PEXCEPTION_RECORD32;

struct EXCEPTION_RECORD64 {
    DWORD    ExceptionCode;
    DWORD ExceptionFlags;
    DWORD64 ExceptionRecord;
    DWORD64 ExceptionAddress;
    DWORD NumberParameters;
    DWORD __unusedAlignment;
    DWORD64 ExceptionInformation[EXCEPTION_MAXIMUM_PARAMETERS];
}

alias EXCEPTION_RECORD64* PEXCEPTION_RECORD64;

//
// Typedef for pointer returned by exception_info()
//

struct EXCEPTION_POINTERS {
    PEXCEPTION_RECORD ExceptionRecord;
    PCONTEXT ContextRecord;
}

alias EXCEPTION_POINTERS* PEXCEPTION_POINTERS;
alias PVOID PACCESS_TOKEN;            
alias PVOID PSECURITY_DESCRIPTOR;     
alias PVOID PSID;     
////////////////////////////////////////////////////////////////////////
//                                                                    //
//                             ACCESS MASK                            //
//                                                                    //
////////////////////////////////////////////////////////////////////////

//
//  Define the access mask as a longword sized structure divided up as
//  follows:
//
//       3 3 2 2 2 2 2 2 2 2 2 2 1 1 1 1 1 1 1 1 1 1
//       1 0 9 8 7 6 5 4 3 2 1 0 9 8 7 6 5 4 3 2 1 0 9 8 7 6 5 4 3 2 1 0
//      +---------------+---------------+-------------------------------+
//      |G|G|G|G|Res'd|A| StandardRights|         SpecificRights        |
//      |R|W|E|A|     |S|               |                               |
//      +-+-------------+---------------+-------------------------------+
//
//      alias struct _ACCESS_MASK {
//          WORD   SpecificRights;
//          BYTE  StandardRights;
//          BYTE  AccessSystemAcl : 1;
//          BYTE  Reserved : 3;
//          BYTE  GenericAll : 1;
//          BYTE  GenericExecute : 1;
//          BYTE  GenericWrite : 1;
//          BYTE  GenericRead : 1;
//      } ACCESS_MASK;
//      alias ACCESS_MASK *PACCESS_MASK;
//
//  but to make life simple for programmer's we'll allow them to specify
//  a desired access mask by simply OR'ing together mulitple single rights
//  and treat an access mask as a DWORD.  For example
//
//      DesiredAccess = DELETE | READ_CONTROL
//
//  So we'll declare ACCESS_MASK as DWORD
//

// begin_wdm
alias DWORD ACCESS_MASK;
alias ACCESS_MASK *PACCESS_MASK;

////////////////////////////////////////////////////////////////////////
//                                                                    //
//                             ACCESS TYPES                           //
//                                                                    //
////////////////////////////////////////////////////////////////////////


// begin_wdm
//
//  The following are masks for the predefined standard access types
//

const auto DELETE                            = (0x00010000);
const auto READ_CONTROL                      = (0x00020000);
const auto WRITE_DAC                         = (0x00040000);
const auto WRITE_OWNER                       = (0x00080000);
const auto SYNCHRONIZE                       = (0x00100000);

const auto STANDARD_RIGHTS_REQUIRED          = (0x000F0000);

const auto STANDARD_RIGHTS_READ              = (READ_CONTROL);
const auto STANDARD_RIGHTS_WRITE             = (READ_CONTROL);
const auto STANDARD_RIGHTS_EXECUTE           = (READ_CONTROL);

const auto STANDARD_RIGHTS_ALL               = (0x001F0000);

const auto SPECIFIC_RIGHTS_ALL               = (0x0000FFFF);

//
// AccessSystemAcl access type
//

const auto ACCESS_SYSTEM_SECURITY            = (0x01000000);

//
// MaximumAllowed access type
//

const auto MAXIMUM_ALLOWED                   = (0x02000000);

//
//  These are the generic rights.
//

const auto GENERIC_READ                      = (0x80000000);
const auto GENERIC_WRITE                     = (0x40000000L);
const auto GENERIC_EXECUTE                   = (0x20000000L);
const auto GENERIC_ALL                       = (0x10000000L);


//
//  Define the generic mapping array.  This is used to denote the
//  mapping of each generic access right to a specific access mask.
//

struct GENERIC_MAPPING {
    ACCESS_MASK GenericRead;
    ACCESS_MASK GenericWrite;
    ACCESS_MASK GenericExecute;
    ACCESS_MASK GenericAll;
}

alias GENERIC_MAPPING *PGENERIC_MAPPING;



////////////////////////////////////////////////////////////////////////
//                                                                    //
//                        LUID_AND_ATTRIBUTES                         //
//                                                                    //
////////////////////////////////////////////////////////////////////////
//
//



align(4) struct LUID_AND_ATTRIBUTES {
    LUID Luid;
    DWORD Attributes;
}

alias LUID_AND_ATTRIBUTES*  PLUID_AND_ATTRIBUTES;
alias LUID_AND_ATTRIBUTES LUID_AND_ATTRIBUTES_ARRAY[];
alias LUID_AND_ATTRIBUTES_ARRAY *PLUID_AND_ATTRIBUTES_ARRAY;



////////////////////////////////////////////////////////////////////////
//                                                                    //
//              Security Id     (SID)                                 //
//                                                                    //
////////////////////////////////////////////////////////////////////////
//
//
// Pictorially the structure of an SID is as follows:
//
//         1   1   1   1   1   1
//         5   4   3   2   1   0   9   8   7   6   5   4   3   2   1   0
//      +---------------------------------------------------------------+
//      |      SubAuthorityCount        |Reserved1 (SBZ)|   Revision    |
//      +---------------------------------------------------------------+
//      |                   IdentifierAuthority[0]                      |
//      +---------------------------------------------------------------+
//      |                   IdentifierAuthority[1]                      |
//      +---------------------------------------------------------------+
//      |                   IdentifierAuthority[2]                      |
//      +---------------------------------------------------------------+
//      |                                                               |
//      +- -  -  -  -  -  -  -  SubAuthority[]  -  -  -  -  -  -  -  - -+
//      |                                                               |
//      +---------------------------------------------------------------+
//
//


// begin_ntifs

struct SID_IDENTIFIER_AUTHORITY {
    BYTE  Value[6];
}

alias SID_IDENTIFIER_AUTHORITY* PSID_IDENTIFIER_AUTHORITY;

struct SID {
   BYTE  Revision;
   BYTE  SubAuthorityCount;
   SID_IDENTIFIER_AUTHORITY IdentifierAuthority;
   DWORD SubAuthority[];
}

alias SID* PISID;

const auto SID_REVISION                      = (1)    ; // Current revision level
const auto SID_MAX_SUB_AUTHORITIES           = (15);
const auto SID_RECOMMENDED_SUB_AUTHORITIES   = (1)    ; // Will change to around 6

                                                // in a future release.


enum SID_NAME_USE {
    SidTypeUser = 1,
    SidTypeGroup,
    SidTypeDomain,
    SidTypeAlias,
    SidTypeWellKnownGroup,
    SidTypeDeletedAccount,
    SidTypeInvalid,
    SidTypeUnknown,
    SidTypeComputer,
    SidTypeLabel
}

alias SID_NAME_USE* PSID_NAME_USE;

struct SID_AND_ATTRIBUTES {
    PSID Sid;
    DWORD Attributes;
    }

alias SID_AND_ATTRIBUTES*  PSID_AND_ATTRIBUTES;

alias SID_AND_ATTRIBUTES SID_AND_ATTRIBUTES_ARRAY[];
alias SID_AND_ATTRIBUTES_ARRAY *PSID_AND_ATTRIBUTES_ARRAY;

const auto SID_HASH_SIZE  = 32;
alias ULONG_PTR SID_HASH_ENTRY;
alias ULONG_PTR* PSID_HASH_ENTRY;

struct SID_AND_ATTRIBUTES_HASH {
    DWORD SidCount;
    PSID_AND_ATTRIBUTES SidAttr;
    SID_HASH_ENTRY Hash[SID_HASH_SIZE];
}

alias SID_AND_ATTRIBUTES_HASH* PSID_AND_ATTRIBUTES_HASH;

/////////////////////////////////////////////////////////////////////////////
//                                                                         //
// Universal well-known SIDs                                               //
//                                                                         //
//     Null SID                     S-1-0-0                                //
//     World                        S-1-1-0                                //
//     Local                        S-1-2-0                                //
//     Creator Owner ID             S-1-3-0                                //
//     Creator Group ID             S-1-3-1                                //
//     Creator Owner Server ID      S-1-3-2                                //
//     Creator Group Server ID      S-1-3-3                                //
//                                                                         //
//     (Non-unique IDs)             S-1-4                                  //
//                                                                         //
/////////////////////////////////////////////////////////////////////////////

const auto SECURITY_NULL_SID_AUTHORITY          = [0,0,0,0,0,0];
const auto SECURITY_WORLD_SID_AUTHORITY         = [0,0,0,0,0,1];
const auto SECURITY_LOCAL_SID_AUTHORITY         = [0,0,0,0,0,2];
const auto SECURITY_CREATOR_SID_AUTHORITY       = [0,0,0,0,0,3];
const auto SECURITY_NON_UNIQUE_AUTHORITY        = [0,0,0,0,0,4];
const auto SECURITY_RESOURCE_MANAGER_AUTHORITY  = [0,0,0,0,0,9];

const auto SECURITY_NULL_RID                  = (0x00000000L);
const auto SECURITY_WORLD_RID                 = (0x00000000L);
const auto SECURITY_LOCAL_RID                 = (0x00000000L);

const auto SECURITY_CREATOR_OWNER_RID         = (0x00000000L);
const auto SECURITY_CREATOR_GROUP_RID         = (0x00000001L);

const auto SECURITY_CREATOR_OWNER_SERVER_RID  = (0x00000002L);
const auto SECURITY_CREATOR_GROUP_SERVER_RID  = (0x00000003L);

const auto SECURITY_CREATOR_OWNER_RIGHTS_RID  = (0x00000004L);


///////////////////////////////////////////////////////////////////////////////
//                                                                           //
// NT well-known SIDs                                                        //
//                                                                           //
//     NT Authority            S-1-5                                         //
//     Dialup                  S-1-5-1                                       //
//                                                                           //
//     Network                 S-1-5-2                                       //
//     Batch                   S-1-5-3                                       //
//     Interactive             S-1-5-4                                       //
//     (Logon IDs)             S-1-5-5-X-Y                                   //
//     Service                 S-1-5-6                                       //
//     AnonymousLogon          S-1-5-7       (aka null logon session)        //
//     Proxy                   S-1-5-8                                       //
//     Enterprise DC (EDC)     S-1-5-9       (aka domain controller account) //
//     Self                    S-1-5-10      (self RID)                      //
//     Authenticated User      S-1-5-11      (Authenticated user somewhere)  //
//     Restricted Code         S-1-5-12      (Running restricted code)       //
//     Terminal Server         S-1-5-13      (Running on Terminal Server)    //
//     Remote Logon            S-1-5-14      (Remote Interactive Logon)      //
//     This Organization       S-1-5-15                                      //
//                                                                           //
//     IUser                   S-1-5-17
//     Local System            S-1-5-18                                      //
//     Local Service           S-1-5-19                                      //
//     Network Service         S-1-5-20                                      //
//                                                                           //
//     (NT non-unique IDs)     S-1-5-0x15-... (NT Domain Sids)               //
//                                                                           //
//     (Built-in domain)       S-1-5-0x20                                    //
//                                                                           //
//     (Security Package IDs)  S-1-5-0x40                                    //
//     NTLM Authentication     S-1-5-0x40-10                                 //
//     SChannel Authentication S-1-5-0x40-14                                 //
//     Digest Authentication   S-1-5-0x40-21                                 //
//                                                                           //
//     Other Organization      S-1-5-1000    (>=1000 can not be filtered)    //
//                                                                           //
//                                                                           //
// NOTE: the relative identifier values (RIDs) determine which security      //
//       boundaries the SID is allowed to cross.  Before adding new RIDs,    //
//       a determination needs to be made regarding which range they should  //
//       be added to in order to ensure proper "SID filtering"               //
//                                                                           //
///////////////////////////////////////////////////////////////////////////////


const auto SECURITY_NT_AUTHORITY            = [0,0,0,0,0,5]   ; // ntifs

const auto SECURITY_DIALUP_RID              = (0x00000001L);
const auto SECURITY_NETWORK_RID             = (0x00000002L);
const auto SECURITY_BATCH_RID               = (0x00000003L);
const auto SECURITY_INTERACTIVE_RID         = (0x00000004L);
const auto SECURITY_LOGON_IDS_RID           = (0x00000005L);
const auto SECURITY_LOGON_IDS_RID_COUNT     = (3L);
const auto SECURITY_SERVICE_RID             = (0x00000006L);
const auto SECURITY_ANONYMOUS_LOGON_RID     = (0x00000007L);
const auto SECURITY_PROXY_RID               = (0x00000008L);
const auto SECURITY_ENTERPRISE_CONTROLLERS_RID  = (0x00000009L);
const auto SECURITY_SERVER_LOGON_RID        = SECURITY_ENTERPRISE_CONTROLLERS_RID;
const auto SECURITY_PRINCIPAL_SELF_RID      = (0x0000000AL);
const auto SECURITY_AUTHENTICATED_USER_RID  = (0x0000000BL);
const auto SECURITY_RESTRICTED_CODE_RID     = (0x0000000CL);
const auto SECURITY_TERMINAL_SERVER_RID     = (0x0000000DL);
const auto SECURITY_REMOTE_LOGON_RID        = (0x0000000EL);
const auto SECURITY_THIS_ORGANIZATION_RID   = (0x0000000FL);
const auto SECURITY_IUSER_RID               = (0x00000011L);
const auto SECURITY_LOCAL_SYSTEM_RID        = (0x00000012L);
const auto SECURITY_LOCAL_SERVICE_RID       = (0x00000013L);
const auto SECURITY_NETWORK_SERVICE_RID     = (0x00000014L);

const auto SECURITY_NT_NON_UNIQUE           = (0x00000015L);
const auto SECURITY_NT_NON_UNIQUE_SUB_AUTH_COUNT   = (3L);

const auto SECURITY_ENTERPRISE_READONLY_CONTROLLERS_RID  = (0x00000016L);

const auto SECURITY_BUILTIN_DOMAIN_RID      = (0x00000020L);
const auto SECURITY_WRITE_RESTRICTED_CODE_RID  = (0x00000021L);


const auto SECURITY_PACKAGE_BASE_RID        = (0x00000040L);
const auto SECURITY_PACKAGE_RID_COUNT       = (2L);
const auto SECURITY_PACKAGE_NTLM_RID        = (0x0000000AL);
const auto SECURITY_PACKAGE_SCHANNEL_RID    = (0x0000000EL);
const auto SECURITY_PACKAGE_DIGEST_RID      = (0x00000015L);

const auto SECURITY_SERVICE_ID_BASE_RID     = (0x00000050L);
const auto SECURITY_SERVICE_ID_RID_COUNT    = (6L);

const auto SECURITY_RESERVED_ID_BASE_RID    = (0x00000051L);

const auto SECURITY_MAX_ALWAYS_FILTERED     = (0x000003E7L);
const auto SECURITY_MIN_NEVER_FILTERED      = (0x000003E8L);

const auto SECURITY_OTHER_ORGANIZATION_RID  = (0x000003E8L);



/////////////////////////////////////////////////////////////////////////////
//                                                                         //
// well-known domain relative sub-authority values (RIDs)...               //
//                                                                         //
/////////////////////////////////////////////////////////////////////////////

// Well-known users ...

const auto FOREST_USER_RID_MAX             = (0x000001F3L);

const auto DOMAIN_USER_RID_ADMIN           = (0x000001F4L);
const auto DOMAIN_USER_RID_GUEST           = (0x000001F5L);
const auto DOMAIN_USER_RID_KRBTGT          = (0x000001F6L);

const auto DOMAIN_USER_RID_MAX             = (0x000003E7L);


// well-known groups ...

const auto DOMAIN_GROUP_RID_ADMINS         = (0x00000200L);
const auto DOMAIN_GROUP_RID_USERS          = (0x00000201L);
const auto DOMAIN_GROUP_RID_GUESTS         = (0x00000202L);
const auto DOMAIN_GROUP_RID_COMPUTERS      = (0x00000203L);
const auto DOMAIN_GROUP_RID_CONTROLLERS    = (0x00000204L);
const auto DOMAIN_GROUP_RID_CERT_ADMINS    = (0x00000205L);
const auto DOMAIN_GROUP_RID_SCHEMA_ADMINS  = (0x00000206L);
const auto DOMAIN_GROUP_RID_ENTERPRISE_ADMINS  = (0x00000207L);
const auto DOMAIN_GROUP_RID_POLICY_ADMINS  = (0x00000208L);
const auto DOMAIN_GROUP_RID_READONLY_CONTROLLERS  = (0x00000209L);




// well-known aliases ...

const auto DOMAIN_ALIAS_RID_ADMINS                          = (0x00000220L);
const auto DOMAIN_ALIAS_RID_USERS                           = (0x00000221L);
const auto DOMAIN_ALIAS_RID_GUESTS                          = (0x00000222L);
const auto DOMAIN_ALIAS_RID_POWER_USERS                     = (0x00000223L);

const auto DOMAIN_ALIAS_RID_ACCOUNT_OPS                     = (0x00000224L);
const auto DOMAIN_ALIAS_RID_SYSTEM_OPS                      = (0x00000225L);
const auto DOMAIN_ALIAS_RID_PRINT_OPS                       = (0x00000226L);
const auto DOMAIN_ALIAS_RID_BACKUP_OPS                      = (0x00000227L);

const auto DOMAIN_ALIAS_RID_REPLICATOR                      = (0x00000228L);
const auto DOMAIN_ALIAS_RID_RAS_SERVERS                     = (0x00000229L);
const auto DOMAIN_ALIAS_RID_PREW2KCOMPACCESS                = (0x0000022AL);
const auto DOMAIN_ALIAS_RID_REMOTE_DESKTOP_USERS            = (0x0000022BL);
const auto DOMAIN_ALIAS_RID_NETWORK_CONFIGURATION_OPS       = (0x0000022CL);
const auto DOMAIN_ALIAS_RID_INCOMING_FOREST_TRUST_BUILDERS  = (0x0000022DL);

const auto DOMAIN_ALIAS_RID_MONITORING_USERS                = (0x0000022EL);
const auto DOMAIN_ALIAS_RID_LOGGING_USERS                   = (0x0000022FL);
const auto DOMAIN_ALIAS_RID_AUTHORIZATIONACCESS             = (0x00000230L);
const auto DOMAIN_ALIAS_RID_TS_LICENSE_SERVERS              = (0x00000231L);
const auto DOMAIN_ALIAS_RID_DCOM_USERS                      = (0x00000232L);
const auto DOMAIN_ALIAS_RID_IUSERS                          = (0x00000238L);
const auto DOMAIN_ALIAS_RID_CRYPTO_OPERATORS                = (0x00000239L);
const auto DOMAIN_ALIAS_RID_CACHEABLE_PRINCIPALS_GROUP      = (0x0000023BL);
const auto DOMAIN_ALIAS_RID_NON_CACHEABLE_PRINCIPALS_GROUP  = (0x0000023CL);
const auto DOMAIN_ALIAS_RID_EVENT_LOG_READERS_GROUP         = (0x0000023DL);

const auto SECURITY_MANDATORY_LABEL_AUTHORITY           = [0,0,0,0,0,16];
const auto SECURITY_MANDATORY_UNTRUSTED_RID             = (0x00000000L);
const auto SECURITY_MANDATORY_LOW_RID                   = (0x00001000L);
const auto SECURITY_MANDATORY_MEDIUM_RID                = (0x00002000L);
const auto SECURITY_MANDATORY_HIGH_RID                  = (0x00003000L);
const auto SECURITY_MANDATORY_SYSTEM_RID                = (0x00004000L);
const auto SECURITY_MANDATORY_PROTECTED_PROCESS_RID     = (0x00005000L);

//
// SECURITY_MANDATORY_MAXIMUM_USER_RID is the highest RID that
// can be set by a usermode caller.
//

const auto SECURITY_MANDATORY_MAXIMUM_USER_RID    = SECURITY_MANDATORY_SYSTEM_RID;


//
// Well known SID definitions for lookup.
//

enum WELL_KNOWN_SID_TYPE {

    WinNullSid                                  = 0,
    WinWorldSid                                 = 1,
    WinLocalSid                                 = 2,
    WinCreatorOwnerSid                          = 3,
    WinCreatorGroupSid                          = 4,
    WinCreatorOwnerServerSid                    = 5,
    WinCreatorGroupServerSid                    = 6,
    WinNtAuthoritySid                           = 7,
    WinDialupSid                                = 8,
    WinNetworkSid                               = 9,
    WinBatchSid                                 = 10,
    WinInteractiveSid                           = 11,
    WinServiceSid                               = 12,
    WinAnonymousSid                             = 13,
    WinProxySid                                 = 14,
    WinEnterpriseControllersSid                 = 15,
    WinSelfSid                                  = 16,
    WinAuthenticatedUserSid                     = 17,
    WinRestrictedCodeSid                        = 18,
    WinTerminalServerSid                        = 19,
    WinRemoteLogonIdSid                         = 20,
    WinLogonIdsSid                              = 21,
    WinLocalSystemSid                           = 22,
    WinLocalServiceSid                          = 23,
    WinNetworkServiceSid                        = 24,
    WinBuiltinDomainSid                         = 25,
    WinBuiltinAdministratorsSid                 = 26,
    WinBuiltinUsersSid                          = 27,
    WinBuiltinGuestsSid                         = 28,
    WinBuiltinPowerUsersSid                     = 29,
    WinBuiltinAccountOperatorsSid               = 30,
    WinBuiltinSystemOperatorsSid                = 31,
    WinBuiltinPrintOperatorsSid                 = 32,
    WinBuiltinBackupOperatorsSid                = 33,
    WinBuiltinReplicatorSid                     = 34,
    WinBuiltinPreWindows2000CompatibleAccessSid = 35,
    WinBuiltinRemoteDesktopUsersSid             = 36,
    WinBuiltinNetworkConfigurationOperatorsSid  = 37,
    WinAccountAdministratorSid                  = 38,
    WinAccountGuestSid                          = 39,
    WinAccountKrbtgtSid                         = 40,
    WinAccountDomainAdminsSid                   = 41,
    WinAccountDomainUsersSid                    = 42,
    WinAccountDomainGuestsSid                   = 43,
    WinAccountComputersSid                      = 44,
    WinAccountControllersSid                    = 45,
    WinAccountCertAdminsSid                     = 46,
    WinAccountSchemaAdminsSid                   = 47,
    WinAccountEnterpriseAdminsSid               = 48,
    WinAccountPolicyAdminsSid                   = 49,
    WinAccountRasAndIasServersSid               = 50,
    WinNTLMAuthenticationSid                    = 51,
    WinDigestAuthenticationSid                  = 52,
    WinSChannelAuthenticationSid                = 53,
    WinThisOrganizationSid                      = 54,
    WinOtherOrganizationSid                     = 55,
    WinBuiltinIncomingForestTrustBuildersSid    = 56,
    WinBuiltinPerfMonitoringUsersSid            = 57,
    WinBuiltinPerfLoggingUsersSid               = 58,
    WinBuiltinAuthorizationAccessSid            = 59,
    WinBuiltinTerminalServerLicenseServersSid   = 60,
    WinBuiltinDCOMUsersSid                      = 61,
    WinBuiltinIUsersSid                         = 62,
    WinIUserSid                                 = 63,
    WinBuiltinCryptoOperatorsSid                = 64,
    WinUntrustedLabelSid                        = 65,
    WinLowLabelSid                              = 66,
    WinMediumLabelSid                           = 67,
    WinHighLabelSid                             = 68,
    WinSystemLabelSid                           = 69,
    WinWriteRestrictedCodeSid                   = 70,
    WinCreatorOwnerRightsSid                    = 71,
    WinCacheablePrincipalsGroupSid              = 72,
    WinNonCacheablePrincipalsGroupSid           = 73,
    WinEnterpriseReadonlyControllersSid         = 74,
    WinAccountReadonlyControllersSid            = 75,
    WinBuiltinEventLogReadersGroup              = 76,

}

//
// Allocate the System Luid.  The first 1000 LUIDs are reserved.
// Use #999 here (0x3e7 = 999)
//

const auto SYSTEM_LUID                      = [ 0x3e7, 0x0 ];
const auto ANONYMOUS_LOGON_LUID             = [ 0x3e6, 0x0 ];
const auto LOCALSERVICE_LUID                = [ 0x3e5, 0x0 ];
const auto NETWORKSERVICE_LUID              = [ 0x3e4, 0x0 ];
const auto IUSER_LUID                       = [ 0x3e3, 0x0 ];

// end_ntifs

////////////////////////////////////////////////////////////////////////
//                                                                    //
//                          User and Group related SID attributes     //
//                                                                    //
////////////////////////////////////////////////////////////////////////

//
// Group attributes
//

const auto SE_GROUP_MANDATORY                  = (0x00000001L);
const auto SE_GROUP_ENABLED_BY_DEFAULT         = (0x00000002L);
const auto SE_GROUP_ENABLED                    = (0x00000004L);
const auto SE_GROUP_OWNER                      = (0x00000008L);
const auto SE_GROUP_USE_FOR_DENY_ONLY          = (0x00000010L);
const auto SE_GROUP_INTEGRITY                  = (0x00000020L);
const auto SE_GROUP_INTEGRITY_ENABLED          = (0x00000040L);
const auto SE_GROUP_LOGON_ID                   = (0xC0000000L);
const auto SE_GROUP_RESOURCE                   = (0x20000000L);

const auto SE_GROUP_VALID_ATTRIBUTES           = (SE_GROUP_MANDATORY          |
                                            SE_GROUP_ENABLED_BY_DEFAULT |
                                            SE_GROUP_ENABLED            |
                                            SE_GROUP_OWNER              |
                                            SE_GROUP_USE_FOR_DENY_ONLY  |
                                            SE_GROUP_LOGON_ID           |
                                            SE_GROUP_RESOURCE           |
                                            SE_GROUP_INTEGRITY          |
                                            SE_GROUP_INTEGRITY_ENABLED);

//
// User attributes
//

// (None yet defined.)




////////////////////////////////////////////////////////////////////////
//                                                                    //
//                         ACL  and  ACE                              //
//                                                                    //
////////////////////////////////////////////////////////////////////////

//
//  Define an ACL and the ACE format.  The structure of an ACL header
//  followed by one or more ACEs.  Pictorally the structure of an ACL header
//  is as follows:
//
//       3 3 2 2 2 2 2 2 2 2 2 2 1 1 1 1 1 1 1 1 1 1
//       1 0 9 8 7 6 5 4 3 2 1 0 9 8 7 6 5 4 3 2 1 0 9 8 7 6 5 4 3 2 1 0
//      +-------------------------------+---------------+---------------+
//      |            AclSize            |      Sbz1     |  AclRevision  |
//      +-------------------------------+---------------+---------------+
//      |              Sbz2             |           AceCount            |
//      +-------------------------------+-------------------------------+
//
//  The current AclRevision is defined to be ACL_REVISION.
//
//  AclSize is the size, in bytes, allocated for the ACL.  This includes
//  the ACL header, ACES, and remaining free space in the buffer.
//
//  AceCount is the number of ACES in the ACL.
//

// begin_wdm
// This is the *current* ACL revision

const auto ACL_REVISION      = (2);
const auto ACL_REVISION_DS   = (4);

// This is the history of ACL revisions.  Add a new one whenever
// ACL_REVISION is updated

const auto ACL_REVISION1    = (1);
const auto ACL_REVISION2    = (2);
const auto MIN_ACL_REVISION  = ACL_REVISION2;
const auto ACL_REVISION3    = (3);
const auto ACL_REVISION4    = (4);
const auto MAX_ACL_REVISION  = ACL_REVISION4;

struct ACL {
    BYTE  AclRevision;
    BYTE  Sbz1;
    WORD   AclSize;
    WORD   AceCount;
    WORD   Sbz2;
}

alias ACL *PACL;

// end_wdm
// begin_ntifs

//
//  The structure of an ACE is a common ace header followed by ace type
//  specific data.  Pictorally the structure of the common ace header is
//  as follows:
//
//       3 3 2 2 2 2 2 2 2 2 2 2 1 1 1 1 1 1 1 1 1 1
//       1 0 9 8 7 6 5 4 3 2 1 0 9 8 7 6 5 4 3 2 1 0 9 8 7 6 5 4 3 2 1 0
//      +---------------+-------+-------+---------------+---------------+
//      |            AceSize            |    AceFlags   |     AceType   |
//      +---------------+-------+-------+---------------+---------------+
//
//  AceType denotes the type of the ace, there are some predefined ace
//  types
//
//  AceSize is the size, in bytes, of ace.
//
//  AceFlags are the Ace flags for audit and inheritance, defined shortly.

struct ACE_HEADER {
    BYTE  AceType;
    BYTE  AceFlags;
    WORD   AceSize;
}

alias ACE_HEADER *PACE_HEADER;

//
//  The following are the predefined ace types that go into the AceType
//  field of an Ace header.
//

const auto ACCESS_MIN_MS_ACE_TYPE                   = (0x0);
const auto ACCESS_ALLOWED_ACE_TYPE                  = (0x0);
const auto ACCESS_DENIED_ACE_TYPE                   = (0x1);
const auto SYSTEM_AUDIT_ACE_TYPE                    = (0x2);
const auto SYSTEM_ALARM_ACE_TYPE                    = (0x3);
const auto ACCESS_MAX_MS_V2_ACE_TYPE                = (0x3);

const auto ACCESS_ALLOWED_COMPOUND_ACE_TYPE         = (0x4);
const auto ACCESS_MAX_MS_V3_ACE_TYPE                = (0x4);

const auto ACCESS_MIN_MS_OBJECT_ACE_TYPE            = (0x5);
const auto ACCESS_ALLOWED_OBJECT_ACE_TYPE           = (0x5);
const auto ACCESS_DENIED_OBJECT_ACE_TYPE            = (0x6);
const auto SYSTEM_AUDIT_OBJECT_ACE_TYPE             = (0x7);
const auto SYSTEM_ALARM_OBJECT_ACE_TYPE             = (0x8);
const auto ACCESS_MAX_MS_OBJECT_ACE_TYPE            = (0x8);

const auto ACCESS_MAX_MS_V4_ACE_TYPE                = (0x8);
const auto ACCESS_MAX_MS_ACE_TYPE                   = (0x8);

const auto ACCESS_ALLOWED_CALLBACK_ACE_TYPE         = (0x9);
const auto ACCESS_DENIED_CALLBACK_ACE_TYPE          = (0xA);
const auto ACCESS_ALLOWED_CALLBACK_OBJECT_ACE_TYPE  = (0xB);
const auto ACCESS_DENIED_CALLBACK_OBJECT_ACE_TYPE   = (0xC);
const auto SYSTEM_AUDIT_CALLBACK_ACE_TYPE           = (0xD);
const auto SYSTEM_ALARM_CALLBACK_ACE_TYPE           = (0xE);
const auto SYSTEM_AUDIT_CALLBACK_OBJECT_ACE_TYPE    = (0xF);
const auto SYSTEM_ALARM_CALLBACK_OBJECT_ACE_TYPE    = (0x10);

const auto SYSTEM_MANDATORY_LABEL_ACE_TYPE          = (0x11);
const auto ACCESS_MAX_MS_V5_ACE_TYPE                = (0x11);


//
//  The following are the inherit flags that go into the AceFlags field
//  of an Ace header.
//

const auto OBJECT_INHERIT_ACE                 = (0x1);
const auto CONTAINER_INHERIT_ACE              = (0x2);
const auto NO_PROPAGATE_INHERIT_ACE           = (0x4);
const auto INHERIT_ONLY_ACE                   = (0x8);
const auto INHERITED_ACE                      = (0x10);
const auto VALID_INHERIT_FLAGS                = (0x1F);


//  The following are the currently defined ACE flags that go into the
//  AceFlags field of an ACE header.  Each ACE type has its own set of
//  AceFlags.
//
//  SUCCESSFUL_ACCESS_ACE_FLAG - used only with system audit and alarm ACE
//  types to indicate that a message is generated for successful accesses.
//
//  FAILED_ACCESS_ACE_FLAG - used only with system audit and alarm ACE types
//  to indicate that a message is generated for failed accesses.
//

//
//  SYSTEM_AUDIT and SYSTEM_ALARM AceFlags
//
//  These control the signaling of audit and alarms for success or failure.
//

const auto SUCCESSFUL_ACCESS_ACE_FLAG        = (0x40);
const auto FAILED_ACCESS_ACE_FLAG            = (0x80);


//
//  We'll define the structure of the predefined ACE types.  Pictorally
//  the structure of the predefined ACE's is as follows:
//
//       3 3 2 2 2 2 2 2 2 2 2 2 1 1 1 1 1 1 1 1 1 1
//       1 0 9 8 7 6 5 4 3 2 1 0 9 8 7 6 5 4 3 2 1 0 9 8 7 6 5 4 3 2 1 0
//      +---------------+-------+-------+---------------+---------------+
//      |    AceFlags   | Resd  |Inherit|    AceSize    |     AceType   |
//      +---------------+-------+-------+---------------+---------------+
//      |                              Mask                             |
//      +---------------------------------------------------------------+
//      |                                                               |
//      +                                                               +
//      |                                                               |
//      +                              Sid                              +
//      |                                                               |
//      +                                                               +
//      |                                                               |
//      +---------------------------------------------------------------+
//
//  Mask is the access mask associated with the ACE.  This is either the
//  access allowed, access denied, audit, or alarm mask.
//
//  Sid is the Sid associated with the ACE.
//

//  The following are the four predefined ACE types.

//  Examine the AceType field in the Header to determine
//  which structure is appropriate to use for casting.


struct ACCESS_ALLOWED_ACE {
    ACE_HEADER Header;
    ACCESS_MASK Mask;
    DWORD SidStart;
}


alias ACCESS_ALLOWED_ACE *PACCESS_ALLOWED_ACE;

struct ACCESS_DENIED_ACE {
    ACE_HEADER Header;
    ACCESS_MASK Mask;
    DWORD SidStart;
}

alias ACCESS_DENIED_ACE *PACCESS_DENIED_ACE;

struct SYSTEM_AUDIT_ACE {
    ACE_HEADER Header;
    ACCESS_MASK Mask;
    DWORD SidStart;
}

alias SYSTEM_AUDIT_ACE *PSYSTEM_AUDIT_ACE;

struct SYSTEM_ALARM_ACE {
    ACE_HEADER Header;
    ACCESS_MASK Mask;
    DWORD SidStart;
}

alias SYSTEM_ALARM_ACE *PSYSTEM_ALARM_ACE;

struct SYSTEM_MANDATORY_LABEL_ACE {
    ACE_HEADER Header;
    ACCESS_MASK Mask;
    DWORD SidStart;
}

alias SYSTEM_MANDATORY_LABEL_ACE* PSYSTEM_MANDATORY_LABEL_ACE;

const auto SYSTEM_MANDATORY_LABEL_NO_WRITE_UP          = 0x1;
const auto SYSTEM_MANDATORY_LABEL_NO_READ_UP           = 0x2;
const auto SYSTEM_MANDATORY_LABEL_NO_EXECUTE_UP        = 0x4;

const auto SYSTEM_MANDATORY_LABEL_VALID_MASK  = (SYSTEM_MANDATORY_LABEL_NO_WRITE_UP   |
                                           SYSTEM_MANDATORY_LABEL_NO_READ_UP    |
                                           SYSTEM_MANDATORY_LABEL_NO_EXECUTE_UP);
// end_ntifs


struct ACCESS_ALLOWED_OBJECT_ACE {
    ACE_HEADER Header;
    ACCESS_MASK Mask;
    DWORD Flags;
    GUID ObjectType;
    GUID InheritedObjectType;
    DWORD SidStart;
}

alias ACCESS_ALLOWED_OBJECT_ACE* PACCESS_ALLOWED_OBJECT_ACE;

struct ACCESS_DENIED_OBJECT_ACE {
    ACE_HEADER Header;
    ACCESS_MASK Mask;
    DWORD Flags;
    GUID ObjectType;
    GUID InheritedObjectType;
    DWORD SidStart;
}

alias ACCESS_DENIED_OBJECT_ACE* PACCESS_DENIED_OBJECT_ACE;

struct SYSTEM_AUDIT_OBJECT_ACE {
    ACE_HEADER Header;
    ACCESS_MASK Mask;
    DWORD Flags;
    GUID ObjectType;
    GUID InheritedObjectType;
    DWORD SidStart;
}

alias SYSTEM_AUDIT_OBJECT_ACE* PSYSTEM_AUDIT_OBJECT_ACE;

struct SYSTEM_ALARM_OBJECT_ACE {
    ACE_HEADER Header;
    ACCESS_MASK Mask;
    DWORD Flags;
    GUID ObjectType;
    GUID InheritedObjectType;
    DWORD SidStart;
}

alias SYSTEM_ALARM_OBJECT_ACE* PSYSTEM_ALARM_OBJECT_ACE;

//
// Callback ace support in post Win2000.
// Resource managers can put their own data after Sidstart + Length of the sid
//

struct ACCESS_ALLOWED_CALLBACK_ACE {
    ACE_HEADER Header;
    ACCESS_MASK Mask;
    DWORD SidStart;
    // Opaque resouce manager specific data
}

alias ACCESS_ALLOWED_CALLBACK_ACE* PACCESS_ALLOWED_CALLBACK_ACE;

struct ACCESS_DENIED_CALLBACK_ACE {
    ACE_HEADER Header;
    ACCESS_MASK Mask;
    DWORD SidStart;
    // Opaque resouce manager specific data
}

alias ACCESS_DENIED_CALLBACK_ACE* PACCESS_DENIED_CALLBACK_ACE;

struct SYSTEM_AUDIT_CALLBACK_ACE {
    ACE_HEADER Header;
    ACCESS_MASK Mask;
    DWORD SidStart;
    // Opaque resouce manager specific data
}

alias SYSTEM_AUDIT_CALLBACK_ACE* PSYSTEM_AUDIT_CALLBACK_ACE;

struct SYSTEM_ALARM_CALLBACK_ACE {
    ACE_HEADER Header;
    ACCESS_MASK Mask;
    DWORD SidStart;
    // Opaque resouce manager specific data
}

alias SYSTEM_ALARM_CALLBACK_ACE* PSYSTEM_ALARM_CALLBACK_ACE;

struct ACCESS_ALLOWED_CALLBACK_OBJECT_ACE {
    ACE_HEADER Header;
    ACCESS_MASK Mask;
    DWORD Flags;
    GUID ObjectType;
    GUID InheritedObjectType;
    DWORD SidStart;
    // Opaque resouce manager specific data
}

alias ACCESS_ALLOWED_CALLBACK_OBJECT_ACE* PACCESS_ALLOWED_CALLBACK_OBJECT_ACE;

struct ACCESS_DENIED_CALLBACK_OBJECT_ACE {
    ACE_HEADER Header;
    ACCESS_MASK Mask;
    DWORD Flags;
    GUID ObjectType;
    GUID InheritedObjectType;
    DWORD SidStart;
    // Opaque resouce manager specific data
}

alias ACCESS_DENIED_CALLBACK_OBJECT_ACE* PACCESS_DENIED_CALLBACK_OBJECT_ACE;

struct SYSTEM_AUDIT_CALLBACK_OBJECT_ACE {
    ACE_HEADER Header;
    ACCESS_MASK Mask;
    DWORD Flags;
    GUID ObjectType;
    GUID InheritedObjectType;
    DWORD SidStart;
    // Opaque resouce manager specific data
}

alias SYSTEM_AUDIT_CALLBACK_OBJECT_ACE* PSYSTEM_AUDIT_CALLBACK_OBJECT_ACE;

struct SYSTEM_ALARM_CALLBACK_OBJECT_ACE {
    ACE_HEADER Header;
    ACCESS_MASK Mask;
    DWORD Flags;
    GUID ObjectType;
    GUID InheritedObjectType;
    DWORD SidStart;
    // Opaque resouce manager specific data
}

alias SYSTEM_ALARM_CALLBACK_OBJECT_ACE* PSYSTEM_ALARM_CALLBACK_OBJECT_ACE;

//
// Currently define Flags for "OBJECT" ACE types.
//

const auto ACE_OBJECT_TYPE_PRESENT            = 0x1;
const auto ACE_INHERITED_OBJECT_TYPE_PRESENT  = 0x2;

//
//  The following declarations are used for setting and querying information
//  about and ACL.  First are the various information classes available to
//  the user.
//

enum ACL_INFORMATION_CLASS {
    AclRevisionInformation = 1,
    AclSizeInformation
} 

//
//  This record is returned/sent if the user is requesting/setting the
//  AclRevisionInformation
//

struct ACL_REVISION_INFORMATION {
    DWORD AclRevision;
}

alias ACL_REVISION_INFORMATION *PACL_REVISION_INFORMATION;

//
//  This record is returned if the user is requesting AclSizeInformation
//

struct ACL_SIZE_INFORMATION {
    DWORD AceCount;
    DWORD AclBytesInUse;
    DWORD AclBytesFree;
}

alias ACL_SIZE_INFORMATION *PACL_SIZE_INFORMATION;


////////////////////////////////////////////////////////////////////////
//                                                                    //
//                             SECURITY_DESCRIPTOR                    //
//                                                                    //
////////////////////////////////////////////////////////////////////////
//
//  Define the Security Descriptor and related data types.
//  This is an opaque data structure.
//

// begin_wdm
//
// Current security descriptor revision value
//

const auto SECURITY_DESCRIPTOR_REVISION      = (1);
const auto SECURITY_DESCRIPTOR_REVISION1     = (1);

// end_wdm
// begin_ntifs


alias WORD   SECURITY_DESCRIPTOR_CONTROL;
alias WORD* PSECURITY_DESCRIPTOR_CONTROL;

const auto SE_OWNER_DEFAULTED                = (0x0001);
const auto SE_GROUP_DEFAULTED                = (0x0002);
const auto SE_DACL_PRESENT                   = (0x0004);
const auto SE_DACL_DEFAULTED                 = (0x0008);
const auto SE_SACL_PRESENT                   = (0x0010);
const auto SE_SACL_DEFAULTED                 = (0x0020);
const auto SE_DACL_AUTO_INHERIT_REQ          = (0x0100);
const auto SE_SACL_AUTO_INHERIT_REQ          = (0x0200);
const auto SE_DACL_AUTO_INHERITED            = (0x0400);
const auto SE_SACL_AUTO_INHERITED            = (0x0800);
const auto SE_DACL_PROTECTED                 = (0x1000);
const auto SE_SACL_PROTECTED                 = (0x2000);
const auto SE_RM_CONTROL_VALID               = (0x4000);
const auto SE_SELF_RELATIVE                  = (0x8000);

//
//  Where:
//
//      SE_OWNER_DEFAULTED - This boolean flag, when set, indicates that the
//          SID pointed to by the Owner field was provided by a
//          defaulting mechanism rather than explicitly provided by the
//          original provider of the security descriptor.  This may
//          affect the treatment of the SID with respect to inheritence
//          of an owner.
//
//      SE_GROUP_DEFAULTED - This boolean flag, when set, indicates that the
//          SID in the Group field was provided by a defaulting mechanism
//          rather than explicitly provided by the original provider of
//          the security descriptor.  This may affect the treatment of
//          the SID with respect to inheritence of a primary group.
//
//      SE_DACL_PRESENT - This boolean flag, when set, indicates that the
//          security descriptor contains a discretionary ACL.  If this
//          flag is set and the Dacl field of the SECURITY_DESCRIPTOR is
//          null, then a null ACL is explicitly being specified.
//
//      SE_DACL_DEFAULTED - This boolean flag, when set, indicates that the
//          ACL pointed to by the Dacl field was provided by a defaulting
//          mechanism rather than explicitly provided by the original
//          provider of the security descriptor.  This may affect the
//          treatment of the ACL with respect to inheritence of an ACL.
//          This flag is ignored if the DaclPresent flag is not set.
//
//      SE_SACL_PRESENT - This boolean flag, when set,  indicates that the
//          security descriptor contains a system ACL pointed to by the
//          Sacl field.  If this flag is set and the Sacl field of the
//          SECURITY_DESCRIPTOR is null, then an empty (but present)
//          ACL is being specified.
//
//      SE_SACL_DEFAULTED - This boolean flag, when set, indicates that the
//          ACL pointed to by the Sacl field was provided by a defaulting
//          mechanism rather than explicitly provided by the original
//          provider of the security descriptor.  This may affect the
//          treatment of the ACL with respect to inheritence of an ACL.
//          This flag is ignored if the SaclPresent flag is not set.
//
//      SE_SELF_RELATIVE - This boolean flag, when set, indicates that the
//          security descriptor is in self-relative form.  In this form,
//          all fields of the security descriptor are contiguous in memory
//          and all pointer fields are expressed as offsets from the
//          beginning of the security descriptor.  This form is useful
//          for treating security descriptors as opaque data structures
//          for transmission in communication protocol or for storage on
//          secondary media.
//
//
//
// Pictorially the structure of a security descriptor is as follows:
//
//       3 3 2 2 2 2 2 2 2 2 2 2 1 1 1 1 1 1 1 1 1 1
//       1 0 9 8 7 6 5 4 3 2 1 0 9 8 7 6 5 4 3 2 1 0 9 8 7 6 5 4 3 2 1 0
//      +---------------------------------------------------------------+
//      |            Control            |Reserved1 (SBZ)|   Revision    |
//      +---------------------------------------------------------------+
//      |                            Owner                              |
//      +---------------------------------------------------------------+
//      |                            Group                              |
//      +---------------------------------------------------------------+
//      |                            Sacl                               |
//      +---------------------------------------------------------------+
//      |                            Dacl                               |
//      +---------------------------------------------------------------+
//
// In general, this data structure should be treated opaquely to ensure future
// compatibility.
//
//

struct SECURITY_DESCRIPTOR_RELATIVE {
    BYTE  Revision;
    BYTE  Sbz1;
    SECURITY_DESCRIPTOR_CONTROL Control;
    DWORD Owner;
    DWORD Group;
    DWORD Sacl;
    DWORD Dacl;
    }

alias SECURITY_DESCRIPTOR_RELATIVE* PISECURITY_DESCRIPTOR_RELATIVE;

struct SECURITY_DESCRIPTOR {
   BYTE  Revision;
   BYTE  Sbz1;
   SECURITY_DESCRIPTOR_CONTROL Control;
   PSID Owner;
   PSID Group;
   PACL Sacl;
   PACL Dacl;

   }

alias SECURITY_DESCRIPTOR* PISECURITY_DESCRIPTOR;


const auto SECURITY_DESCRIPTOR_MIN_LENGTH    = ((SECURITY_DESCRIPTOR.sizeof));
// end_ntifs

// Where:
//
//     Revision - Contains the revision level of the security
//         descriptor.  This allows this structure to be passed between
//         systems or stored on disk even though it is expected to
//         change in the future.
//
//     Control - A set of flags which qualify the meaning of the
//         security descriptor or individual fields of the security
//         descriptor.
//
//     Owner - is a pointer to an SID representing an object's owner.
//         If this field is null, then no owner SID is present in the
//         security descriptor.  If the security descriptor is in
//         self-relative form, then this field contains an offset to
//         the SID, rather than a pointer.
//
//     Group - is a pointer to an SID representing an object's primary
//         group.  If this field is null, then no primary group SID is
//         present in the security descriptor.  If the security descriptor
//         is in self-relative form, then this field contains an offset to
//         the SID, rather than a pointer.
//
//     Sacl - is a pointer to a system ACL.  This field value is only
//         valid if the DaclPresent control flag is set.  If the
//         SaclPresent flag is set and this field is null, then a null
//         ACL  is specified.  If the security descriptor is in
//         self-relative form, then this field contains an offset to
//         the ACL, rather than a pointer.
//
//     Dacl - is a pointer to a discretionary ACL.  This field value is
//         only valid if the DaclPresent control flag is set.  If the
//         DaclPresent flag is set and this field is null, then a null
//         ACL (unconditionally granting access) is specified.  If the
//         security descriptor is in self-relative form, then this field
//         contains an offset to the ACL, rather than a pointer.
//




////////////////////////////////////////////////////////////////////////
//                                                                    //
//               Object Type list for AccessCheckByType               //
//                                                                    //
////////////////////////////////////////////////////////////////////////

struct OBJECT_TYPE_LIST {
    WORD   Level;
    WORD   Sbz;
    GUID *ObjectType;
}

alias OBJECT_TYPE_LIST* POBJECT_TYPE_LIST;

//
// DS values for Level
//

const auto ACCESS_OBJECT_GUID        = 0;
const auto ACCESS_PROPERTY_SET_GUID  = 1;
const auto ACCESS_PROPERTY_GUID      = 2;

const auto ACCESS_MAX_LEVEL          = 4;

//
// Parameters to NtAccessCheckByTypeAndAditAlarm
//

enum AUDIT_EVENT_TYPE {
    AuditEventObjectAccess,
    AuditEventDirectoryServiceAccess
}

alias AUDIT_EVENT_TYPE* PAUDIT_EVENT_TYPE;

const auto AUDIT_ALLOW_NO_PRIVILEGE  = 0x1;

//
// DS values for Source and ObjectTypeName
//

const auto ACCESS_DS_SOURCE_A  = "DS"c;
const auto ACCESS_DS_SOURCE_W  = "DS"w;
const auto ACCESS_DS_OBJECT_TYPE_NAME_A  = "Directory Service Object"c;
const auto ACCESS_DS_OBJECT_TYPE_NAME_W  = "Directory Service Object"w;


////////////////////////////////////////////////////////////////////////
//                                                                    //
//               Privilege Related Data Structures                    //
//                                                                    //
////////////////////////////////////////////////////////////////////////

// end_ntifs
// begin_wdm
//
// Privilege attributes
//

const auto SE_PRIVILEGE_ENABLED_BY_DEFAULT  = (0x00000001L);
const auto SE_PRIVILEGE_ENABLED             = (0x00000002L);
const auto SE_PRIVILEGE_REMOVED             = (0X00000004L);
const auto SE_PRIVILEGE_USED_FOR_ACCESS     = (0x80000000L);

const auto SE_PRIVILEGE_VALID_ATTRIBUTES    = (SE_PRIVILEGE_ENABLED_BY_DEFAULT |
                                         SE_PRIVILEGE_ENABLED            |
                                         SE_PRIVILEGE_REMOVED            |
                                         SE_PRIVILEGE_USED_FOR_ACCESS);


//
// Privilege Set Control flags
//

const auto PRIVILEGE_SET_ALL_NECESSARY     = (1);

//
//  Privilege Set - This is defined for a privilege set of one.
//                  If more than one privilege is needed, then this structure
//                  will need to be allocated with more space.
//
//  Note: don't change this structure without fixing the INITIAL_PRIVILEGE_SET
//  structure (defined in se.h)
//

struct PRIVILEGE_SET {
    DWORD PrivilegeCount;
    DWORD Control;
    LUID_AND_ATTRIBUTES Privilege[];
    }

alias PRIVILEGE_SET*  PPRIVILEGE_SET;


////////////////////////////////////////////////////////////////////////
//                                                                    //
//               NT Defined Privileges                                //
//                                                                    //
////////////////////////////////////////////////////////////////////////

version (UNICODE) {
	const auto SE_CREATE_TOKEN_NAME               = "SeCreateTokenPrivilege"w;
	const auto SE_ASSIGNPRIMARYTOKEN_NAME         = "SeAssignPrimaryTokenPrivilege"w;
	const auto SE_LOCK_MEMORY_NAME                = "SeLockMemoryPrivilege"w;
	const auto SE_INCREASE_QUOTA_NAME             = "SeIncreaseQuotaPrivilege"w;
	const auto SE_UNSOLICITED_INPUT_NAME          = "SeUnsolicitedInputPrivilege"w;
	const auto SE_MACHINE_ACCOUNT_NAME            = "SeMachineAccountPrivilege"w;
	const auto SE_TCB_NAME                        = "SeTcbPrivilege"w;
	const auto SE_SECURITY_NAME                   = "SeSecurityPrivilege"w;
	const auto SE_TAKE_OWNERSHIP_NAME             = "SeTakeOwnershipPrivilege"w;
	const auto SE_LOAD_DRIVER_NAME                = "SeLoadDriverPrivilege"w;
	const auto SE_SYSTEM_PROFILE_NAME             = "SeSystemProfilePrivilege"w;
	const auto SE_SYSTEMTIME_NAME                 = "SeSystemtimePrivilege"w;
	const auto SE_PROF_SINGLE_PROCESS_NAME        = "SeProfileSingleProcessPrivilege"w;
	const auto SE_INC_BASE_PRIORITY_NAME          = "SeIncreaseBasePriorityPrivilege"w;
	const auto SE_CREATE_PAGEFILE_NAME            = "SeCreatePagefilePrivilege"w;
	const auto SE_CREATE_PERMANENT_NAME           = "SeCreatePermanentPrivilege"w;
	const auto SE_BACKUP_NAME                     = "SeBackupPrivilege"w;
	const auto SE_RESTORE_NAME                    = "SeRestorePrivilege"w;
	const auto SE_SHUTDOWN_NAME                   = "SeShutdownPrivilege"w;
	const auto SE_DEBUG_NAME                      = "SeDebugPrivilege"w;
	const auto SE_AUDIT_NAME                      = "SeAuditPrivilege"w;
	const auto SE_SYSTEM_ENVIRONMENT_NAME         = "SeSystemEnvironmentPrivilege"w;
	const auto SE_CHANGE_NOTIFY_NAME              = "SeChangeNotifyPrivilege"w;
	const auto SE_REMOTE_SHUTDOWN_NAME            = "SeRemoteShutdownPrivilege"w;
	const auto SE_UNDOCK_NAME                     = "SeUndockPrivilege"w;
	const auto SE_SYNC_AGENT_NAME                 = "SeSyncAgentPrivilege"w;
	const auto SE_ENABLE_DELEGATION_NAME          = "SeEnableDelegationPrivilege"w;
	const auto SE_MANAGE_VOLUME_NAME              = "SeManageVolumePrivilege"w;
	const auto SE_IMPERSONATE_NAME                = "SeImpersonatePrivilege"w;
	const auto SE_CREATE_GLOBAL_NAME              = "SeCreateGlobalPrivilege"w;
	const auto SE_TRUSTED_CREDMAN_ACCESS_NAME     = "SeTrustedCredManAccessPrivilege"w;
	const auto SE_RELABEL_NAME                    = "SeRelabelPrivilege"w;
	const auto SE_INC_WORKING_SET_NAME            = "SeIncreaseWorkingSetPrivilege"w;
	const auto SE_TIME_ZONE_NAME                  = "SeTimeZonePrivilege"w;
	const auto SE_CREATE_SYMBOLIC_LINK_NAME       = "SeCreateSymbolicLinkPrivilege"w;
}
else {
	const auto SE_CREATE_TOKEN_NAME               = "SeCreateTokenPrivilege"c;
	const auto SE_ASSIGNPRIMARYTOKEN_NAME         = "SeAssignPrimaryTokenPrivilege"c;
	const auto SE_LOCK_MEMORY_NAME                = "SeLockMemoryPrivilege"c;
	const auto SE_INCREASE_QUOTA_NAME             = "SeIncreaseQuotaPrivilege"c;
	const auto SE_UNSOLICITED_INPUT_NAME          = "SeUnsolicitedInputPrivilege"c;
	const auto SE_MACHINE_ACCOUNT_NAME            = "SeMachineAccountPrivilege"c;
	const auto SE_TCB_NAME                        = "SeTcbPrivilege"c;
	const auto SE_SECURITY_NAME                   = "SeSecurityPrivilege"c;
	const auto SE_TAKE_OWNERSHIP_NAME             = "SeTakeOwnershipPrivilege"c;
	const auto SE_LOAD_DRIVER_NAME                = "SeLoadDriverPrivilege"c;
	const auto SE_SYSTEM_PROFILE_NAME             = "SeSystemProfilePrivilege"c;
	const auto SE_SYSTEMTIME_NAME                 = "SeSystemtimePrivilege"c;
	const auto SE_PROF_SINGLE_PROCESS_NAME        = "SeProfileSingleProcessPrivilege"c;
	const auto SE_INC_BASE_PRIORITY_NAME          = "SeIncreaseBasePriorityPrivilege"c;
	const auto SE_CREATE_PAGEFILE_NAME            = "SeCreatePagefilePrivilege"c;
	const auto SE_CREATE_PERMANENT_NAME           = "SeCreatePermanentPrivilege"c;
	const auto SE_BACKUP_NAME                     = "SeBackupPrivilege"c;
	const auto SE_RESTORE_NAME                    = "SeRestorePrivilege"c;
	const auto SE_SHUTDOWN_NAME                   = "SeShutdownPrivilege"c;
	const auto SE_DEBUG_NAME                      = "SeDebugPrivilege"c;
	const auto SE_AUDIT_NAME                      = "SeAuditPrivilege"c;
	const auto SE_SYSTEM_ENVIRONMENT_NAME         = "SeSystemEnvironmentPrivilege"c;
	const auto SE_CHANGE_NOTIFY_NAME              = "SeChangeNotifyPrivilege"c;
	const auto SE_REMOTE_SHUTDOWN_NAME            = "SeRemoteShutdownPrivilege"c;
	const auto SE_UNDOCK_NAME                     = "SeUndockPrivilege"c;
	const auto SE_SYNC_AGENT_NAME                 = "SeSyncAgentPrivilege"c;
	const auto SE_ENABLE_DELEGATION_NAME          = "SeEnableDelegationPrivilege"c;
	const auto SE_MANAGE_VOLUME_NAME              = "SeManageVolumePrivilege"c;
	const auto SE_IMPERSONATE_NAME                = "SeImpersonatePrivilege"c;
	const auto SE_CREATE_GLOBAL_NAME              = "SeCreateGlobalPrivilege"c;
	const auto SE_TRUSTED_CREDMAN_ACCESS_NAME     = "SeTrustedCredManAccessPrivilege"c;
	const auto SE_RELABEL_NAME                    = "SeRelabelPrivilege"c;
	const auto SE_INC_WORKING_SET_NAME            = "SeIncreaseWorkingSetPrivilege"c;
	const auto SE_TIME_ZONE_NAME                  = "SeTimeZonePrivilege"c;
	const auto SE_CREATE_SYMBOLIC_LINK_NAME       = "SeCreateSymbolicLinkPrivilege"c;
}


////////////////////////////////////////////////////////////////////
//                                                                //
//           Security Quality Of Service                          //
//                                                                //
//                                                                //
////////////////////////////////////////////////////////////////////

// begin_wdm
//
// Impersonation Level
//
// Impersonation level is represented by a pair of bits in Windows.
// If a new impersonation level is added or lowest value is changed from
// 0 to something else, fix the Windows CreateFile call.
//

enum SECURITY_IMPERSONATION_LEVEL {
    SecurityAnonymous,
    SecurityIdentification,
    SecurityImpersonation,
    SecurityDelegation
}

alias SECURITY_IMPERSONATION_LEVEL* PSECURITY_IMPERSONATION_LEVEL;

const auto SECURITY_MAX_IMPERSONATION_LEVEL  = SECURITY_IMPERSONATION_LEVEL.SecurityDelegation;
const auto SECURITY_MIN_IMPERSONATION_LEVEL  = SECURITY_IMPERSONATION_LEVEL.SecurityAnonymous;
const auto DEFAULT_IMPERSONATION_LEVEL  = SECURITY_IMPERSONATION_LEVEL.SecurityImpersonation;
///const auto VALID_IMPERSONATION_LEVEL(L)  = (((L) >= SECURITY_MIN_IMPERSONATION_LEVEL) && ((L) <= SECURITY_MAX_IMPERSONATION_LEVEL));

////////////////////////////////////////////////////////////////////
//                                                                //
//           Token Object Definitions                             //
//                                                                //
//                                                                //
////////////////////////////////////////////////////////////////////


//
// Token Specific Access Rights.
//

const auto TOKEN_ASSIGN_PRIMARY     = (0x0001);
const auto TOKEN_DUPLICATE          = (0x0002);
const auto TOKEN_IMPERSONATE        = (0x0004);
const auto TOKEN_QUERY              = (0x0008);
const auto TOKEN_QUERY_SOURCE       = (0x0010);
const auto TOKEN_ADJUST_PRIVILEGES  = (0x0020);
const auto TOKEN_ADJUST_GROUPS      = (0x0040);
const auto TOKEN_ADJUST_DEFAULT     = (0x0080);
const auto TOKEN_ADJUST_SESSIONID   = (0x0100);

const auto TOKEN_ALL_ACCESS_P  = (STANDARD_RIGHTS_REQUIRED  |
                          TOKEN_ASSIGN_PRIMARY      |
                          TOKEN_DUPLICATE           |
                          TOKEN_IMPERSONATE         |
                          TOKEN_QUERY               |
                          TOKEN_QUERY_SOURCE        |
                          TOKEN_ADJUST_PRIVILEGES   |
                          TOKEN_ADJUST_GROUPS       |
                          TOKEN_ADJUST_DEFAULT );

const auto TOKEN_ALL_ACCESS   = (TOKEN_ALL_ACCESS_P |
                          TOKEN_ADJUST_SESSIONID );

const auto TOKEN_READ        = (STANDARD_RIGHTS_READ      |
                          TOKEN_QUERY);


const auto TOKEN_WRITE       = (STANDARD_RIGHTS_WRITE     |
                          TOKEN_ADJUST_PRIVILEGES   |
                          TOKEN_ADJUST_GROUPS       |
                          TOKEN_ADJUST_DEFAULT);

const auto TOKEN_EXECUTE     = (STANDARD_RIGHTS_EXECUTE);

//
//
// Token Types
//

enum TOKEN_TYPE {
    TokenPrimary = 1,
    TokenImpersonation
}
alias TOKEN_TYPE *PTOKEN_TYPE;

//
// Token elevation values describe the relative strength of a given token.
// A full token is a token with all groups and privileges to which the principal
// is authorized.  A limited token is one with some groups or privileges removed.
//

enum TOKEN_ELEVATION_TYPE {
    TokenElevationTypeDefault = 1,
    TokenElevationTypeFull,
    TokenElevationTypeLimited,
}

alias TOKEN_ELEVATION_TYPE* PTOKEN_ELEVATION_TYPE;

//
// Token Information Classes.
//


enum TOKEN_INFORMATION_CLASS {
    TokenUser = 1,
    TokenGroups,
    TokenPrivileges,
    TokenOwner,
    TokenPrimaryGroup,
    TokenDefaultDacl,
    TokenSource,
    TokenType,
    TokenImpersonationLevel,
    TokenStatistics,
    TokenRestrictedSids,
    TokenSessionId,
    TokenGroupsAndPrivileges,
    TokenSessionReference,
    TokenSandBoxInert,
    TokenAuditPolicy,
    TokenOrigin,
    TokenElevationType,
    TokenLinkedToken,
    TokenElevation,
    TokenHasRestrictions,
    TokenAccessInformation,
    TokenVirtualizationAllowed,
    TokenVirtualizationEnabled,
    TokenIntegrityLevel,
    TokenUIAccess,
    TokenMandatoryPolicy,
    TokenLogonSid,
    MaxTokenInfoClass  // MaxTokenInfoClass should always be the last enum
}

alias TOKEN_INFORMATION_CLASS* PTOKEN_INFORMATION_CLASS;

//
// Token information class structures
//


struct TOKEN_USER {
    SID_AND_ATTRIBUTES User;
}

alias TOKEN_USER* PTOKEN_USER;

struct TOKEN_GROUPS {
    DWORD GroupCount;
    SID_AND_ATTRIBUTES[] Groups;
}

alias TOKEN_GROUPS* PTOKEN_GROUPS;


struct TOKEN_PRIVILEGES {
    DWORD PrivilegeCount;
    LUID_AND_ATTRIBUTES[] Privileges;
}

alias TOKEN_PRIVILEGES* PTOKEN_PRIVILEGES;


struct TOKEN_OWNER {
    PSID Owner;
}

alias TOKEN_OWNER* PTOKEN_OWNER;


struct TOKEN_PRIMARY_GROUP {
    PSID PrimaryGroup;
}

alias TOKEN_PRIMARY_GROUP* PTOKEN_PRIMARY_GROUP;


struct TOKEN_DEFAULT_DACL {
    PACL DefaultDacl;
}

alias TOKEN_DEFAULT_DACL* PTOKEN_DEFAULT_DACL;

struct TOKEN_GROUPS_AND_PRIVILEGES {
    DWORD SidCount;
    DWORD SidLength;
    PSID_AND_ATTRIBUTES Sids;
    DWORD RestrictedSidCount;
    DWORD RestrictedSidLength;
    PSID_AND_ATTRIBUTES RestrictedSids;
    DWORD PrivilegeCount;
    DWORD PrivilegeLength;
    PLUID_AND_ATTRIBUTES Privileges;
    LUID AuthenticationId;
}

alias TOKEN_GROUPS_AND_PRIVILEGES* PTOKEN_GROUPS_AND_PRIVILEGES;

struct TOKEN_LINKED_TOKEN {
    HANDLE LinkedToken;
}

alias TOKEN_LINKED_TOKEN* PTOKEN_LINKED_TOKEN;

struct TOKEN_ELEVATION {
    DWORD TokenIsElevated;
}

alias TOKEN_ELEVATION* PTOKEN_ELEVATION;

struct TOKEN_MANDATORY_LABEL {
    SID_AND_ATTRIBUTES Label;
}

alias TOKEN_MANDATORY_LABEL* PTOKEN_MANDATORY_LABEL;

const auto TOKEN_MANDATORY_POLICY_OFF              = 0x0;
const auto TOKEN_MANDATORY_POLICY_NO_WRITE_UP      = 0x1;
const auto TOKEN_MANDATORY_POLICY_NEW_PROCESS_MIN  = 0x2;

const auto TOKEN_MANDATORY_POLICY_VALID_MASK       = (TOKEN_MANDATORY_POLICY_NO_WRITE_UP |
                                                TOKEN_MANDATORY_POLICY_NEW_PROCESS_MIN);

struct TOKEN_MANDATORY_POLICY {
    DWORD Policy;
}

alias TOKEN_MANDATORY_POLICY* PTOKEN_MANDATORY_POLICY;

struct TOKEN_ACCESS_INFORMATION {
    PSID_AND_ATTRIBUTES_HASH SidHash;
    PSID_AND_ATTRIBUTES_HASH RestrictedSidHash;
    PTOKEN_PRIVILEGES Privileges;
    LUID AuthenticationId;
    TOKEN_TYPE TokenType;
    SECURITY_IMPERSONATION_LEVEL ImpersonationLevel;
    TOKEN_MANDATORY_POLICY MandatoryPolicy;
    DWORD Flags;
}

alias TOKEN_ACCESS_INFORMATION* PTOKEN_ACCESS_INFORMATION;

//
// Valid bits for each TOKEN_AUDIT_POLICY policy mask field.
//

const auto POLICY_AUDIT_SUBCATEGORY_COUNT  = (50);

struct TOKEN_AUDIT_POLICY {
    BYTE[((POLICY_AUDIT_SUBCATEGORY_COUNT) >> 1) + 1]  PerUserPolicy;
}

alias TOKEN_AUDIT_POLICY* PTOKEN_AUDIT_POLICY;

const auto TOKEN_SOURCE_LENGTH  = 8;

struct TOKEN_SOURCE {
    CHAR[TOKEN_SOURCE_LENGTH] SourceName;
    LUID SourceIdentifier;
}

alias TOKEN_SOURCE* PTOKEN_SOURCE;


struct TOKEN_STATISTICS {
    LUID TokenId;
    LUID AuthenticationId;
    LARGE_INTEGER ExpirationTime;
    TOKEN_TYPE TokenType;
    SECURITY_IMPERSONATION_LEVEL ImpersonationLevel;
    DWORD DynamicCharged;
    DWORD DynamicAvailable;
    DWORD GroupCount;
    DWORD PrivilegeCount;
    LUID ModifiedId;
}

alias TOKEN_STATISTICS* PTOKEN_STATISTICS;



struct TOKEN_CONTROL {
    LUID TokenId;
    LUID AuthenticationId;
    LUID ModifiedId;
    TOKEN_SOURCE TokenSource;
}

alias TOKEN_CONTROL* PTOKEN_CONTROL;

struct TOKEN_ORIGIN {
    LUID OriginatingLogonSession ;
}

alias TOKEN_ORIGIN*  PTOKEN_ORIGIN ;

enum MANDATORY_LEVEL {
    MandatoryLevelUntrusted = 0,
    MandatoryLevelLow,
    MandatoryLevelMedium,
    MandatoryLevelHigh,
    MandatoryLevelSystem,
    MandatoryLevelSecureProcess,
    MandatoryLevelCount
}

alias MANDATORY_LEVEL* PMANDATORY_LEVEL;

//
// Security Tracking Mode
//

const auto SECURITY_DYNAMIC_TRACKING       = 1;
const auto SECURITY_STATIC_TRACKING        = 0;

alias BOOLEAN SECURITY_CONTEXT_TRACKING_MODE;
alias BOOLEAN* PSECURITY_CONTEXT_TRACKING_MODE;



//
// Quality Of Service
//

struct SECURITY_QUALITY_OF_SERVICE {
    DWORD Length;
    SECURITY_IMPERSONATION_LEVEL ImpersonationLevel;
    SECURITY_CONTEXT_TRACKING_MODE ContextTrackingMode;
    BOOLEAN EffectiveOnly;
    }

alias SECURITY_QUALITY_OF_SERVICE*  PSECURITY_QUALITY_OF_SERVICE;


//
// Used to represent information related to a thread impersonation
//

struct SE_IMPERSONATION_STATE {
    PACCESS_TOKEN Token;
    BOOLEAN CopyOnOpen;
    BOOLEAN EffectiveOnly;
    SECURITY_IMPERSONATION_LEVEL Level;
}

alias SE_IMPERSONATION_STATE* PSE_IMPERSONATION_STATE;

const auto DISABLE_MAX_PRIVILEGE    = 0x1 ;
const auto SANDBOX_INERT            = 0x2 ;
const auto LUA_TOKEN                = 0x4 ;
const auto WRITE_RESTRICTED         = 0x8 ;

alias DWORD SECURITY_INFORMATION;
alias DWORD* PSECURITY_INFORMATION;

const auto OWNER_SECURITY_INFORMATION        = (0x00000001L);
const auto GROUP_SECURITY_INFORMATION        = (0x00000002L);
const auto DACL_SECURITY_INFORMATION         = (0x00000004L);
const auto SACL_SECURITY_INFORMATION         = (0x00000008L);
const auto LABEL_SECURITY_INFORMATION        = (0x00000010L);

const auto PROTECTED_DACL_SECURITY_INFORMATION      = (0x80000000L);
const auto PROTECTED_SACL_SECURITY_INFORMATION      = (0x40000000L);
const auto UNPROTECTED_DACL_SECURITY_INFORMATION    = (0x20000000L);
const auto UNPROTECTED_SACL_SECURITY_INFORMATION    = (0x10000000L);

const auto PROCESS_TERMINATE                   = (0x0001)  ;
const auto PROCESS_CREATE_THREAD               = (0x0002)  ;
const auto PROCESS_SET_SESSIONID               = (0x0004)  ;
const auto PROCESS_VM_OPERATION                = (0x0008)  ;
const auto PROCESS_VM_READ                     = (0x0010)  ;
const auto PROCESS_VM_WRITE                    = (0x0020)  ;
const auto PROCESS_DUP_HANDLE                  = (0x0040)  ;
const auto PROCESS_CREATE_PROCESS              = (0x0080)  ;
const auto PROCESS_SET_QUOTA                   = (0x0100)  ;
const auto PROCESS_SET_INFORMATION             = (0x0200)  ;
const auto PROCESS_QUERY_INFORMATION           = (0x0400)  ;
const auto PROCESS_SUSPEND_RESUME              = (0x0800)  ;
const auto PROCESS_QUERY_LIMITED_INFORMATION   = (0x1000)  ;

const auto PROCESS_ALL_ACCESS         = (STANDARD_RIGHTS_REQUIRED | SYNCHRONIZE |
                                   0xFFFF);

version(X86_64) {
	const auto MAXIMUM_PROCESSORS  = 64;
}
else {
	const auto MAXIMUM_PROCESSORS  = 32;
}

const auto THREAD_TERMINATE                  = (0x0001)  ;
const auto THREAD_SUSPEND_RESUME             = (0x0002)  ;
const auto THREAD_GET_CONTEXT                = (0x0008)  ;
const auto THREAD_SET_CONTEXT                = (0x0010)  ;
const auto THREAD_QUERY_INFORMATION          = (0x0040)  ;
const auto THREAD_SET_INFORMATION            = (0x0020)  ;
const auto THREAD_SET_THREAD_TOKEN           = (0x0080);
const auto THREAD_IMPERSONATE                = (0x0100);
const auto THREAD_DIRECT_IMPERSONATION       = (0x0200);
// begin_wdm
const auto THREAD_SET_LIMITED_INFORMATION    = (0x0400)  ; // winnt
const auto THREAD_QUERY_LIMITED_INFORMATION  = (0x0800)  ; // winnt

const auto THREAD_ALL_ACCESS          = (STANDARD_RIGHTS_REQUIRED | SYNCHRONIZE |
                                   0xFFFF);
const auto JOB_OBJECT_ASSIGN_PROCESS            = (0x0001);
const auto JOB_OBJECT_SET_ATTRIBUTES            = (0x0002);
const auto JOB_OBJECT_QUERY                     = (0x0004);
const auto JOB_OBJECT_TERMINATE                 = (0x0008);
const auto JOB_OBJECT_SET_SECURITY_ATTRIBUTES   = (0x0010);
const auto JOB_OBJECT_ALL_ACCESS        = (STANDARD_RIGHTS_REQUIRED | SYNCHRONIZE |
                                        0x1F );

struct JOB_SET_ARRAY {
    HANDLE JobHandle;   // Handle to job object to insert
    DWORD MemberLevel;  // Level of this job in the set. Must be > 0. Can be sparse.
    DWORD Flags;        // Unused. Must be zero
}

alias JOB_SET_ARRAY* PJOB_SET_ARRAY;

const auto FLS_MAXIMUM_AVAILABLE  = 128   ;
const auto TLS_MINIMUM_AVAILABLE  = 64    ;

/*struct NT_TIB {
    EXCEPTION_REGISTRATION_RECORD *ExceptionList;
    PVOID StackBase;
    PVOID StackLimit;
    PVOID SubSystemTib;
    union _inner_union {
        PVOID FiberData;
        DWORD Version;
    }
    _inner_union fields;
    PVOID ArbitraryUserPointer;
    NT_TIB *Self;
}

alias NT_TIB *PNT_TIB;
*/

//
// 32 and 64 bit specific version for wow64 and the debugger
//
struct NT_TIB32 {
    DWORD ExceptionList;
    DWORD StackBase;
    DWORD StackLimit;
    DWORD SubSystemTib;
    union _inner_union {
        DWORD FiberData;
        DWORD Version;
    }
    _inner_union fields;
    DWORD ArbitraryUserPointer;
    DWORD Self;
}

alias NT_TIB32* PNT_TIB32;

struct NT_TIB64 {
    DWORD64 ExceptionList;
    DWORD64 StackBase;
    DWORD64 StackLimit;
    DWORD64 SubSystemTib;
    union _inner_union {
        DWORD64 FiberData;
        DWORD Version;
    }
    _inner_union fields;
    DWORD64 ArbitraryUserPointer;
    DWORD64 Self;
}

alias NT_TIB64* PNT_TIB64;

const auto THREAD_BASE_PRIORITY_LOWRT   = 15  ; // value that gets a thread to LowRealtime-1
const auto THREAD_BASE_PRIORITY_MAX     = 2   ; // maximum thread base priority boost
const auto THREAD_BASE_PRIORITY_MIN     = (-2)  ; // minimum thread base priority boost
const auto THREAD_BASE_PRIORITY_IDLE    = (-15) ; // value that gets a thread to idle


struct QUOTA_LIMITS {
    SIZE_T PagedPoolLimit;
    SIZE_T NonPagedPoolLimit;
    SIZE_T MinimumWorkingSetSize;
    SIZE_T MaximumWorkingSetSize;
    SIZE_T PagefileLimit;
    LARGE_INTEGER TimeLimit;
}

alias QUOTA_LIMITS* PQUOTA_LIMITS;

const auto QUOTA_LIMITS_HARDWS_MIN_ENABLE   = 0x00000001;
const auto QUOTA_LIMITS_HARDWS_MIN_DISABLE  = 0x00000002;
const auto QUOTA_LIMITS_HARDWS_MAX_ENABLE   = 0x00000004;
const auto QUOTA_LIMITS_HARDWS_MAX_DISABLE  = 0x00000008;
const auto QUOTA_LIMITS_USE_DEFAULT_LIMITS  = 0x00000010;

const auto PS_RATE_PHASE_BITS   = 4;
const auto PS_RATE_PHASE_MASK   = ((cast(ulong)1 << PS_RATE_PHASE_BITS) - 1);

enum PS_RATE_PHASE {
    PsRateOneSecond = 0,
    PsRateTwoSecond,
    PsRateThreeSecond,
    PsRateMaxPhase
}

union RATE_QUOTA_LIMIT {
	DWORD RateData;

    DWORD RatePhase() {
    	return RateData & ((PS_RATE_PHASE_BITS << 1) - 1);
	}

    DWORD RatePercent() {
    	return (RateData >> PS_RATE_PHASE_BITS);
    }
}

alias RATE_QUOTA_LIMIT* PRATE_QUOTA_LIMIT;

struct QUOTA_LIMITS_EX {
    SIZE_T PagedPoolLimit;
    SIZE_T NonPagedPoolLimit;
    SIZE_T MinimumWorkingSetSize;
    SIZE_T MaximumWorkingSetSize;
    SIZE_T PagefileLimit;               // Limit expressed in pages
    LARGE_INTEGER TimeLimit;
    SIZE_T WorkingSetLimit;             // Limit expressed in pages
    SIZE_T Reserved2;
    SIZE_T Reserved3;
    SIZE_T Reserved4;
    DWORD  Flags;
    RATE_QUOTA_LIMIT CpuRateLimit;
}

alias QUOTA_LIMITS_EX* PQUOTA_LIMITS_EX;

struct IO_COUNTERS {
    ULONGLONG  ReadOperationCount;
    ULONGLONG  WriteOperationCount;
    ULONGLONG  OtherOperationCount;
    ULONGLONG ReadTransferCount;
    ULONGLONG WriteTransferCount;
    ULONGLONG OtherTransferCount;
}

alias IO_COUNTERS *PIO_COUNTERS;

struct JOBOBJECT_BASIC_ACCOUNTING_INFORMATION {
    LARGE_INTEGER TotalUserTime;
    LARGE_INTEGER TotalKernelTime;
    LARGE_INTEGER ThisPeriodTotalUserTime;
    LARGE_INTEGER ThisPeriodTotalKernelTime;
    DWORD TotalPageFaultCount;
    DWORD TotalProcesses;
    DWORD ActiveProcesses;
    DWORD TotalTerminatedProcesses;
}

alias JOBOBJECT_BASIC_ACCOUNTING_INFORMATION* PJOBOBJECT_BASIC_ACCOUNTING_INFORMATION;

struct JOBOBJECT_BASIC_LIMIT_INFORMATION {
    LARGE_INTEGER PerProcessUserTimeLimit;
    LARGE_INTEGER PerJobUserTimeLimit;
    DWORD LimitFlags;
    SIZE_T MinimumWorkingSetSize;
    SIZE_T MaximumWorkingSetSize;
    DWORD ActiveProcessLimit;
    ULONG_PTR Affinity;
    DWORD PriorityClass;
    DWORD SchedulingClass;
}

alias JOBOBJECT_BASIC_LIMIT_INFORMATION* PJOBOBJECT_BASIC_LIMIT_INFORMATION;

struct JOBOBJECT_EXTENDED_LIMIT_INFORMATION {
    JOBOBJECT_BASIC_LIMIT_INFORMATION BasicLimitInformation;
    IO_COUNTERS IoInfo;
    SIZE_T ProcessMemoryLimit;
    SIZE_T JobMemoryLimit;
    SIZE_T PeakProcessMemoryUsed;
    SIZE_T PeakJobMemoryUsed;
}

alias JOBOBJECT_EXTENDED_LIMIT_INFORMATION* PJOBOBJECT_EXTENDED_LIMIT_INFORMATION;

struct JOBOBJECT_BASIC_PROCESS_ID_LIST {
    DWORD NumberOfAssignedProcesses;
    DWORD NumberOfProcessIdsInList;
    ULONG_PTR[1] ProcessIdList;
}

alias JOBOBJECT_BASIC_PROCESS_ID_LIST* PJOBOBJECT_BASIC_PROCESS_ID_LIST;

struct JOBOBJECT_BASIC_UI_RESTRICTIONS {
    DWORD UIRestrictionsClass;
}

alias JOBOBJECT_BASIC_UI_RESTRICTIONS* PJOBOBJECT_BASIC_UI_RESTRICTIONS;

struct JOBOBJECT_SECURITY_LIMIT_INFORMATION {
    DWORD SecurityLimitFlags ;
    HANDLE JobToken ;
    PTOKEN_GROUPS SidsToDisable ;
    PTOKEN_PRIVILEGES PrivilegesToDelete ;
    PTOKEN_GROUPS RestrictedSids ;
}

alias JOBOBJECT_SECURITY_LIMIT_INFORMATION* PJOBOBJECT_SECURITY_LIMIT_INFORMATION ;

struct JOBOBJECT_END_OF_JOB_TIME_INFORMATION {
    DWORD EndOfJobTimeAction;
}

alias JOBOBJECT_END_OF_JOB_TIME_INFORMATION* PJOBOBJECT_END_OF_JOB_TIME_INFORMATION;

struct JOBOBJECT_ASSOCIATE_COMPLETION_PORT {
    PVOID CompletionKey;
    HANDLE CompletionPort;
}

alias JOBOBJECT_ASSOCIATE_COMPLETION_PORT* PJOBOBJECT_ASSOCIATE_COMPLETION_PORT;

struct JOBOBJECT_BASIC_AND_IO_ACCOUNTING_INFORMATION {
    JOBOBJECT_BASIC_ACCOUNTING_INFORMATION BasicInfo;
    IO_COUNTERS IoInfo;
}

alias JOBOBJECT_BASIC_AND_IO_ACCOUNTING_INFORMATION* PJOBOBJECT_BASIC_AND_IO_ACCOUNTING_INFORMATION;

struct JOBOBJECT_JOBSET_INFORMATION {
    DWORD MemberLevel;
}

alias JOBOBJECT_JOBSET_INFORMATION* PJOBOBJECT_JOBSET_INFORMATION;

const auto JOB_OBJECT_TERMINATE_AT_END_OF_JOB   = 0;
const auto JOB_OBJECT_POST_AT_END_OF_JOB        = 1;

//
// Completion Port Messages for job objects
//
// These values are returned via the lpNumberOfBytesTransferred parameter
//

const auto JOB_OBJECT_MSG_END_OF_JOB_TIME           = 1;
const auto JOB_OBJECT_MSG_END_OF_PROCESS_TIME       = 2;
const auto JOB_OBJECT_MSG_ACTIVE_PROCESS_LIMIT      = 3;
const auto JOB_OBJECT_MSG_ACTIVE_PROCESS_ZERO       = 4;
const auto JOB_OBJECT_MSG_NEW_PROCESS               = 6;
const auto JOB_OBJECT_MSG_EXIT_PROCESS              = 7;
const auto JOB_OBJECT_MSG_ABNORMAL_EXIT_PROCESS     = 8;
const auto JOB_OBJECT_MSG_PROCESS_MEMORY_LIMIT      = 9;
const auto JOB_OBJECT_MSG_JOB_MEMORY_LIMIT          = 10;

//
// Basic Limits
//
const auto JOB_OBJECT_LIMIT_WORKINGSET                  = 0x00000001;
const auto JOB_OBJECT_LIMIT_PROCESS_TIME                = 0x00000002;
const auto JOB_OBJECT_LIMIT_JOB_TIME                    = 0x00000004;
const auto JOB_OBJECT_LIMIT_ACTIVE_PROCESS              = 0x00000008;
const auto JOB_OBJECT_LIMIT_AFFINITY                    = 0x00000010;
const auto JOB_OBJECT_LIMIT_PRIORITY_CLASS              = 0x00000020;
const auto JOB_OBJECT_LIMIT_PRESERVE_JOB_TIME           = 0x00000040;
const auto JOB_OBJECT_LIMIT_SCHEDULING_CLASS            = 0x00000080;

//
// Extended Limits
//
const auto JOB_OBJECT_LIMIT_PROCESS_MEMORY              = 0x00000100;
const auto JOB_OBJECT_LIMIT_JOB_MEMORY                  = 0x00000200;
const auto JOB_OBJECT_LIMIT_DIE_ON_UNHANDLED_EXCEPTION  = 0x00000400;
const auto JOB_OBJECT_LIMIT_BREAKAWAY_OK                = 0x00000800;
const auto JOB_OBJECT_LIMIT_SILENT_BREAKAWAY_OK         = 0x00001000;
const auto JOB_OBJECT_LIMIT_KILL_ON_JOB_CLOSE           = 0x00002000;

const auto JOB_OBJECT_LIMIT_RESERVED2                   = 0x00004000;
const auto JOB_OBJECT_LIMIT_RESERVED3                   = 0x00008000;
const auto JOB_OBJECT_LIMIT_RESERVED4                   = 0x00010000;
const auto JOB_OBJECT_LIMIT_RESERVED5                   = 0x00020000;
const auto JOB_OBJECT_LIMIT_RESERVED6                   = 0x00040000;


const auto JOB_OBJECT_LIMIT_VALID_FLAGS             = 0x0007ffff;

const auto JOB_OBJECT_BASIC_LIMIT_VALID_FLAGS       = 0x000000ff;
const auto JOB_OBJECT_EXTENDED_LIMIT_VALID_FLAGS    = 0x00003fff;
const auto JOB_OBJECT_RESERVED_LIMIT_VALID_FLAGS    = 0x0007ffff;

//
// UI restrictions for jobs
//

const auto JOB_OBJECT_UILIMIT_NONE              = 0x00000000;

const auto JOB_OBJECT_UILIMIT_HANDLES           = 0x00000001;
const auto JOB_OBJECT_UILIMIT_READCLIPBOARD     = 0x00000002;
const auto JOB_OBJECT_UILIMIT_WRITECLIPBOARD    = 0x00000004;
const auto JOB_OBJECT_UILIMIT_SYSTEMPARAMETERS  = 0x00000008;
const auto JOB_OBJECT_UILIMIT_DISPLAYSETTINGS   = 0x00000010;
const auto JOB_OBJECT_UILIMIT_GLOBALATOMS       = 0x00000020;
const auto JOB_OBJECT_UILIMIT_DESKTOP           = 0x00000040;
const auto JOB_OBJECT_UILIMIT_EXITWINDOWS       = 0x00000080;

const auto JOB_OBJECT_UILIMIT_ALL               = 0x000000FF;

const auto JOB_OBJECT_UI_VALID_FLAGS            = 0x000000FF;

const auto JOB_OBJECT_SECURITY_NO_ADMIN             = 0x00000001;
const auto JOB_OBJECT_SECURITY_RESTRICTED_TOKEN     = 0x00000002;
const auto JOB_OBJECT_SECURITY_ONLY_TOKEN           = 0x00000004;
const auto JOB_OBJECT_SECURITY_FILTER_TOKENS        = 0x00000008;

const auto JOB_OBJECT_SECURITY_VALID_FLAGS          = 0x0000000f;

enum JOBOBJECTINFOCLASS {
    JobObjectBasicAccountingInformation = 1,
    JobObjectBasicLimitInformation,
    JobObjectBasicProcessIdList,
    JobObjectBasicUIRestrictions,
    JobObjectSecurityLimitInformation,
    JobObjectEndOfJobTimeInformation,
    JobObjectAssociateCompletionPortInformation,
    JobObjectBasicAndIoAccountingInformation,
    JobObjectExtendedLimitInformation,
    JobObjectJobSetInformation,
    MaxJobObjectInfoClass
} 

//
const auto EVENT_MODIFY_STATE       = 0x0002  ;
const auto EVENT_ALL_ACCESS  = (STANDARD_RIGHTS_REQUIRED|SYNCHRONIZE|0x3) ;
const auto MUTANT_QUERY_STATE       = 0x0001;

const auto MUTANT_ALL_ACCESS  = (STANDARD_RIGHTS_REQUIRED|SYNCHRONIZE|
                          MUTANT_QUERY_STATE);
const auto SEMAPHORE_MODIFY_STATE       = 0x0002  ;
const auto SEMAPHORE_ALL_ACCESS  = (STANDARD_RIGHTS_REQUIRED|SYNCHRONIZE|0x3) ;
//
// Timer Specific Access Rights.
//

const auto TIMER_QUERY_STATE        = 0x0001;
const auto TIMER_MODIFY_STATE       = 0x0002;

const auto TIMER_ALL_ACCESS  = (STANDARD_RIGHTS_REQUIRED|SYNCHRONIZE|
                          TIMER_QUERY_STATE|TIMER_MODIFY_STATE);

const auto TIME_ZONE_ID_UNKNOWN   = 0;
const auto TIME_ZONE_ID_STANDARD  = 1;
const auto TIME_ZONE_ID_DAYLIGHT  = 2;

enum LOGICAL_PROCESSOR_RELATIONSHIP {
    RelationProcessorCore,
    RelationNumaNode,
    RelationCache,
    RelationProcessorPackage
}

const auto LTP_PC_SMT  = 0x1;

enum PROCESSOR_CACHE_TYPE {
    CacheUnified,
    CacheInstruction,
    CacheData,
    CacheTrace
}

const auto CACHE_FULLY_ASSOCIATIVE  = 0xFF;

struct CACHE_DESCRIPTOR {
    BYTE   Level;
    BYTE   Associativity;
    WORD   LineSize;
    DWORD  Size;
    PROCESSOR_CACHE_TYPE Type;
}

alias CACHE_DESCRIPTOR* PCACHE_DESCRIPTOR;

struct SYSTEM_LOGICAL_PROCESSOR_INFORMATION {
    ULONG_PTR   ProcessorMask;
    LOGICAL_PROCESSOR_RELATIONSHIP Relationship;
    union _inner_union{
        struct _inner_struct {
            BYTE  Flags;
        }

		_inner_struct ProcessorCore;
        struct _inner_struct2 {
            DWORD NodeNumber;
        }
		_inner_struct2 NumaNode;
        CACHE_DESCRIPTOR Cache;
        ULONGLONG  Reserved[2];
    }
    _inner_union fields;
}

alias SYSTEM_LOGICAL_PROCESSOR_INFORMATION* PSYSTEM_LOGICAL_PROCESSOR_INFORMATION;


const auto PROCESSOR_INTEL_386      = 386;
const auto PROCESSOR_INTEL_486      = 486;
const auto PROCESSOR_INTEL_PENTIUM  = 586;
const auto PROCESSOR_INTEL_IA64     = 2200;
const auto PROCESSOR_AMD_X8664      = 8664;
const auto PROCESSOR_MIPS_R4000     = 4000    ; // incl R4101 & R3910 for Windows CE
const auto PROCESSOR_ALPHA_21064    = 21064;
const auto PROCESSOR_PPC_601        = 601;
const auto PROCESSOR_PPC_603        = 603;
const auto PROCESSOR_PPC_604        = 604;
const auto PROCESSOR_PPC_620        = 620;
const auto PROCESSOR_HITACHI_SH3    = 10003   ; // Windows CE
const auto PROCESSOR_HITACHI_SH3E   = 10004   ; // Windows CE
const auto PROCESSOR_HITACHI_SH4    = 10005   ; // Windows CE
const auto PROCESSOR_MOTOROLA_821   = 821     ; // Windows CE
const auto PROCESSOR_SHx_SH3        = 103     ; // Windows CE
const auto PROCESSOR_SHx_SH4        = 104     ; // Windows CE
const auto PROCESSOR_STRONGARM      = 2577    ; // Windows CE - 0xA11
const auto PROCESSOR_ARM720         = 1824    ; // Windows CE - 0x720
const auto PROCESSOR_ARM820         = 2080    ; // Windows CE - 0x820
const auto PROCESSOR_ARM920         = 2336    ; // Windows CE - 0x920
const auto PROCESSOR_ARM_7TDMI      = 70001   ; // Windows CE
const auto PROCESSOR_OPTIL          = 0x494f  ; // MSIL

const auto PROCESSOR_ARCHITECTURE_INTEL             = 0;
const auto PROCESSOR_ARCHITECTURE_MIPS              = 1;
const auto PROCESSOR_ARCHITECTURE_ALPHA             = 2;
const auto PROCESSOR_ARCHITECTURE_PPC               = 3;
const auto PROCESSOR_ARCHITECTURE_SHX               = 4;
const auto PROCESSOR_ARCHITECTURE_ARM               = 5;
const auto PROCESSOR_ARCHITECTURE_IA64              = 6;
const auto PROCESSOR_ARCHITECTURE_ALPHA64           = 7;
const auto PROCESSOR_ARCHITECTURE_MSIL              = 8;
const auto PROCESSOR_ARCHITECTURE_AMD64             = 9;
const auto PROCESSOR_ARCHITECTURE_IA32_ON_WIN64     = 10;

const auto PROCESSOR_ARCHITECTURE_UNKNOWN  = 0xFFFF;

const auto PF_FLOATING_POINT_PRECISION_ERRATA   = 0   ;
const auto PF_FLOATING_POINT_EMULATED           = 1   ;
const auto PF_COMPARE_EXCHANGE_DOUBLE           = 2   ;
const auto PF_MMX_INSTRUCTIONS_AVAILABLE        = 3   ;
const auto PF_PPC_MOVEMEM_64BIT_OK              = 4   ;
const auto PF_ALPHA_BYTE_INSTRUCTIONS           = 5   ;
const auto PF_XMMI_INSTRUCTIONS_AVAILABLE       = 6   ;
const auto PF_3DNOW_INSTRUCTIONS_AVAILABLE      = 7   ;
const auto PF_RDTSC_INSTRUCTION_AVAILABLE       = 8   ;
const auto PF_PAE_ENABLED                       = 9   ;
const auto PF_XMMI64_INSTRUCTIONS_AVAILABLE    = 10   ;
const auto PF_SSE_DAZ_MODE_AVAILABLE           = 11   ;
const auto PF_NX_ENABLED                       = 12   ;
const auto PF_SSE3_INSTRUCTIONS_AVAILABLE      = 13   ;
const auto PF_COMPARE_EXCHANGE128              = 14   ;
const auto PF_COMPARE64_EXCHANGE128            = 15   ;
const auto PF_CHANNELS_ENABLED                 = 16   ;

struct MEMORY_BASIC_INFORMATION {
    PVOID BaseAddress;
    PVOID AllocationBase;
    DWORD AllocationProtect;
    SIZE_T RegionSize;
    DWORD State;
    DWORD Protect;
    DWORD Type;
}

alias MEMORY_BASIC_INFORMATION* PMEMORY_BASIC_INFORMATION;

struct MEMORY_BASIC_INFORMATION32 {
    DWORD BaseAddress;
    DWORD AllocationBase;
    DWORD AllocationProtect;
    DWORD RegionSize;
    DWORD State;
    DWORD Protect;
    DWORD Type;
}

alias MEMORY_BASIC_INFORMATION32* PMEMORY_BASIC_INFORMATION32;

struct MEMORY_BASIC_INFORMATION64 {
    ULONGLONG BaseAddress;
    ULONGLONG AllocationBase;
    DWORD     AllocationProtect;
    DWORD     __alignment1;
    ULONGLONG RegionSize;
    DWORD     State;
    DWORD     Protect;
    DWORD     Type;
    DWORD     __alignment2;
}

alias MEMORY_BASIC_INFORMATION64* PMEMORY_BASIC_INFORMATION64;

const auto SECTION_QUERY                 = 0x0001;
const auto SECTION_MAP_WRITE             = 0x0002;
const auto SECTION_MAP_READ              = 0x0004;
const auto SECTION_MAP_EXECUTE           = 0x0008;
const auto SECTION_EXTEND_SIZE           = 0x0010;
const auto SECTION_MAP_EXECUTE_EXPLICIT  = 0x0020 ; // not included in SECTION_ALL_ACCESS

const auto SECTION_ALL_ACCESS  = (STANDARD_RIGHTS_REQUIRED|SECTION_QUERY|
                            SECTION_MAP_WRITE |
                            SECTION_MAP_READ |
                            SECTION_MAP_EXECUTE |
                            SECTION_EXTEND_SIZE);

const auto SESSION_QUERY_ACCESS   = 0x0001;
const auto SESSION_MODIFY_ACCESS  = 0x0002;

const auto SESSION_ALL_ACCESS  = (STANDARD_RIGHTS_REQUIRED |
                            SESSION_QUERY_ACCESS |
                            SESSION_MODIFY_ACCESS);

const auto PAGE_NOACCESS           = 0x01     ;
const auto PAGE_READONLY           = 0x02     ;
const auto PAGE_READWRITE          = 0x04     ;
const auto PAGE_WRITECOPY          = 0x08     ;
const auto PAGE_EXECUTE            = 0x10     ;
const auto PAGE_EXECUTE_READ       = 0x20     ;
const auto PAGE_EXECUTE_READWRITE  = 0x40     ;
const auto PAGE_EXECUTE_WRITECOPY  = 0x80     ;
const auto PAGE_GUARD             = 0x100     ;
const auto PAGE_NOCACHE           = 0x200     ;
const auto PAGE_WRITECOMBINE      = 0x400     ;
const auto MEM_COMMIT            = 0x1000     ;
const auto MEM_RESERVE           = 0x2000     ;
const auto MEM_DECOMMIT          = 0x4000     ;
const auto MEM_RELEASE           = 0x8000     ;
const auto MEM_FREE             = 0x10000     ;
const auto MEM_PRIVATE          = 0x20000     ;
const auto MEM_MAPPED           = 0x40000     ;
const auto MEM_RESET            = 0x80000     ;
const auto MEM_TOP_DOWN        = 0x100000     ;
const auto MEM_WRITE_WATCH     = 0x200000     ;
const auto MEM_PHYSICAL        = 0x400000     ;
const auto MEM_ROTATE          = 0x800000     ;
const auto MEM_LARGE_PAGES   = 0x20000000     ;
const auto MEM_4MB_PAGES     = 0x80000000     ;
const auto SEC_FILE            = 0x800000     ;
const auto SEC_IMAGE          = 0x1000000     ;
const auto SEC_PROTECTED_IMAGE   = 0x2000000     ;
const auto SEC_RESERVE        = 0x4000000     ;
const auto SEC_COMMIT         = 0x8000000     ;
const auto SEC_NOCACHE       = 0x10000000     ;
const auto SEC_WRITECOMBINE  = 0x40000000     ;
const auto SEC_LARGE_PAGES   = 0x80000000     ;
const auto MEM_IMAGE          = SEC_IMAGE     ;
const auto WRITE_WATCH_FLAG_RESET  = 0x01     ;

//
// Define access rights to files and directories
//

//
// The FILE_READ_DATA and FILE_WRITE_DATA constants are also defined in
// devioctl.h as FILE_READ_ACCESS and FILE_WRITE_ACCESS. The values for these
// constants *MUST* always be in sync.
// The values are redefined in devioctl.h because they must be available to
// both DOS and NT.
//

const auto FILE_READ_DATA             = ( 0x0001 )    ; // file & pipe
const auto FILE_LIST_DIRECTORY        = ( 0x0001 )    ; // directory

const auto FILE_WRITE_DATA            = ( 0x0002 )    ; // file & pipe
const auto FILE_ADD_FILE              = ( 0x0002 )    ; // directory

const auto FILE_APPEND_DATA           = ( 0x0004 )    ; // file
const auto FILE_ADD_SUBDIRECTORY      = ( 0x0004 )    ; // directory
const auto FILE_CREATE_PIPE_INSTANCE  = ( 0x0004 )    ; // named pipe


const auto FILE_READ_EA               = ( 0x0008 )    ; // file & directory

const auto FILE_WRITE_EA              = ( 0x0010 )    ; // file & directory

const auto FILE_EXECUTE               = ( 0x0020 )    ; // file
const auto FILE_TRAVERSE              = ( 0x0020 )    ; // directory

const auto FILE_DELETE_CHILD          = ( 0x0040 )    ; // directory

const auto FILE_READ_ATTRIBUTES       = ( 0x0080 )    ; // all

const auto FILE_WRITE_ATTRIBUTES      = ( 0x0100 )    ; // all

const auto FILE_ALL_ACCESS  = (STANDARD_RIGHTS_REQUIRED | SYNCHRONIZE | 0x1FF);

const auto FILE_GENERIC_READ          = (STANDARD_RIGHTS_READ     |
                                   FILE_READ_DATA           |
                                   FILE_READ_ATTRIBUTES     |
                                   FILE_READ_EA             |
                                   SYNCHRONIZE);


const auto FILE_GENERIC_WRITE         = (STANDARD_RIGHTS_WRITE    |
                                   FILE_WRITE_DATA          |
                                   FILE_WRITE_ATTRIBUTES    |
                                   FILE_WRITE_EA            |
                                   FILE_APPEND_DATA         |
                                   SYNCHRONIZE);


const auto FILE_GENERIC_EXECUTE       = (STANDARD_RIGHTS_EXECUTE  |
                                   FILE_READ_ATTRIBUTES     |
                                   FILE_EXECUTE             |
                                   SYNCHRONIZE);

const auto FILE_SHARE_READ                  = 0x00000001  ;
const auto FILE_SHARE_WRITE                 = 0x00000002  ;
const auto FILE_SHARE_DELETE                = 0x00000004  ;
const auto FILE_ATTRIBUTE_READONLY              = 0x00000001  ;
const auto FILE_ATTRIBUTE_HIDDEN                = 0x00000002  ;
const auto FILE_ATTRIBUTE_SYSTEM                = 0x00000004  ;
const auto FILE_ATTRIBUTE_DIRECTORY             = 0x00000010  ;
const auto FILE_ATTRIBUTE_ARCHIVE               = 0x00000020  ;
const auto FILE_ATTRIBUTE_DEVICE                = 0x00000040  ;
const auto FILE_ATTRIBUTE_NORMAL                = 0x00000080  ;
const auto FILE_ATTRIBUTE_TEMPORARY             = 0x00000100  ;
const auto FILE_ATTRIBUTE_SPARSE_FILE           = 0x00000200  ;
const auto FILE_ATTRIBUTE_REPARSE_POINT         = 0x00000400  ;
const auto FILE_ATTRIBUTE_COMPRESSED            = 0x00000800  ;
const auto FILE_ATTRIBUTE_OFFLINE               = 0x00001000  ;
const auto FILE_ATTRIBUTE_NOT_CONTENT_INDEXED   = 0x00002000  ;
const auto FILE_ATTRIBUTE_ENCRYPTED             = 0x00004000  ;
const auto FILE_ATTRIBUTE_VIRTUAL               = 0x00010000  ;
const auto FILE_NOTIFY_CHANGE_FILE_NAME     = 0x00000001   ;
const auto FILE_NOTIFY_CHANGE_DIR_NAME      = 0x00000002   ;
const auto FILE_NOTIFY_CHANGE_ATTRIBUTES    = 0x00000004   ;
const auto FILE_NOTIFY_CHANGE_SIZE          = 0x00000008   ;
const auto FILE_NOTIFY_CHANGE_LAST_WRITE    = 0x00000010   ;
const auto FILE_NOTIFY_CHANGE_LAST_ACCESS   = 0x00000020   ;
const auto FILE_NOTIFY_CHANGE_CREATION      = 0x00000040   ;
const auto FILE_NOTIFY_CHANGE_SECURITY      = 0x00000100   ;
const auto FILE_ACTION_ADDED                    = 0x00000001   ;
const auto FILE_ACTION_REMOVED                  = 0x00000002   ;
const auto FILE_ACTION_MODIFIED                 = 0x00000003   ;
const auto FILE_ACTION_RENAMED_OLD_NAME         = 0x00000004   ;
const auto FILE_ACTION_RENAMED_NEW_NAME         = 0x00000005   ;
const auto MAILSLOT_NO_MESSAGE              = ((DWORD)-1) ;
const auto MAILSLOT_WAIT_FOREVER            = ((DWORD)-1) ;
const auto FILE_CASE_SENSITIVE_SEARCH       = 0x00000001  ;
const auto FILE_CASE_PRESERVED_NAMES        = 0x00000002  ;
const auto FILE_UNICODE_ON_DISK             = 0x00000004  ;
const auto FILE_PERSISTENT_ACLS             = 0x00000008  ;
const auto FILE_FILE_COMPRESSION            = 0x00000010  ;
const auto FILE_VOLUME_QUOTAS               = 0x00000020  ;
const auto FILE_SUPPORTS_SPARSE_FILES       = 0x00000040  ;
const auto FILE_SUPPORTS_REPARSE_POINTS     = 0x00000080  ;
const auto FILE_SUPPORTS_REMOTE_STORAGE     = 0x00000100  ;
const auto FILE_VOLUME_IS_COMPRESSED        = 0x00008000  ;
const auto FILE_SUPPORTS_OBJECT_IDS         = 0x00010000  ;
const auto FILE_SUPPORTS_ENCRYPTION         = 0x00020000  ;
const auto FILE_NAMED_STREAMS               = 0x00040000  ;
const auto FILE_READ_ONLY_VOLUME            = 0x00080000  ;
const auto FILE_SEQUENTIAL_WRITE_ONCE       = 0x00100000  ;
const auto FILE_SUPPORTS_TRANSACTIONS       = 0x00200000  ;

//
// Define the file notification information structure
//

struct FILE_NOTIFY_INFORMATION {
    DWORD NextEntryOffset;
    DWORD Action;
    DWORD FileNameLength;
    WCHAR FileName[1];
}

alias FILE_NOTIFY_INFORMATION* PFILE_NOTIFY_INFORMATION;


//
// Define segement buffer structure for scatter/gather read/write.
//

union FILE_SEGMENT_ELEMENT {
    PVOID64 Buffer;
    ULONGLONG Alignment;
}

alias FILE_SEGMENT_ELEMENT* PFILE_SEGMENT_ELEMENT;

//
// The reparse GUID structure is used by all 3rd party layered drivers to
// store data in a reparse point. For non-Microsoft tags, The GUID field
// cannot be GUID_NULL.
// The constraints on reparse tags are defined below.
// Microsoft tags can also be used with this format of the reparse point buffer.
//

struct REPARSE_GUID_DATA_BUFFER {
    DWORD  ReparseTag;
    WORD   ReparseDataLength;
    WORD   Reserved;
    GUID   ReparseGuid;
    struct _inner_struct {
        BYTE[1]   DataBuffer;
    }
	_inner_struct GenericReparseBuffer;
}

alias REPARSE_GUID_DATA_BUFFER* PREPARSE_GUID_DATA_BUFFER;

//const auto REPARSE_GUID_DATA_BUFFER_HEADER_SIZE    = FIELD_OFFSET(REPARSE_GUID_DATA_BUFFER, GenericReparseBuffer);



//
// Maximum allowed size of the reparse data.
//

const auto MAXIMUM_REPARSE_DATA_BUFFER_SIZE       = ( 16 * 1024 );

//
// Predefined reparse tags.
// These tags need to avoid conflicting with IO_REMOUNT defined in ntos\inc\io.h
//

const auto IO_REPARSE_TAG_RESERVED_ZERO              = (0);
const auto IO_REPARSE_TAG_RESERVED_ONE               = (1);

//
// The value of the following constant needs to satisfy the following conditions:
//  (1) Be at least as large as the largest of the reserved tags.
//  (2) Be strictly smaller than all the tags in use.
//

const auto IO_REPARSE_TAG_RESERVED_RANGE             = IO_REPARSE_TAG_RESERVED_ONE;

//
// The reparse tags are a DWORD. The 32 bits are laid out as follows:
//
//   3 3 2 2 2 2 2 2 2 2 2 2 1 1 1 1 1 1 1 1 1 1
//   1 0 9 8 7 6 5 4 3 2 1 0 9 8 7 6 5 4 3 2 1 0 9 8 7 6 5 4 3 2 1 0
//  +-+-+-+-+-----------------------+-------------------------------+
//  |M|R|N|R|     Reserved bits     |       Reparse Tag Value       |
//  +-+-+-+-+-----------------------+-------------------------------+
//
// M is the Microsoft bit. When set to 1, it denotes a tag owned by Microsoft.
//   All ISVs must use a tag with a 0 in this position.
//   Note: If a Microsoft tag is used by non-Microsoft software, the
//   behavior is not defined.
//
// R is reserved.  Must be zero for non-Microsoft tags.
//
// N is name surrogate. When set to 1, the file represents another named
//   entity in the system.
//
// The M and N bits are OR-able.
// The following macros check for the M and N bit values:
//

//
// Macro to determine whether a reparse point tag corresponds to a tag
// owned by Microsoft.
//

// const auto IsReparseTagMicrosoft(_tag)  = (              \;
//                            ((_tag) & 0x80000000)   \
//                            )

//
// Macro to determine whether a reparse point tag is a name surrogate
//

// const auto IsReparseTagNameSurrogate(_tag)  = (          \;
//                            ((_tag) & 0x20000000)   \
//                            )

const auto IO_REPARSE_TAG_MOUNT_POINT               = (0xA0000003L)       ;
const auto IO_REPARSE_TAG_HSM                       = (0xC0000004L)       ;
const auto IO_REPARSE_TAG_SIS                       = (0x80000007L)       ;
const auto IO_REPARSE_TAG_DFS                       = (0x8000000AL)       ;
const auto IO_REPARSE_TAG_SYMLINK                   = (0xA000000CL)       ;
const auto IO_REPARSE_TAG_DFSR                      = (0x80000012L)       ;

//
// I/O Completion Specific Access Rights.
//

const auto IO_COMPLETION_MODIFY_STATE   = 0x0002  ;
const auto IO_COMPLETION_ALL_ACCESS  = (STANDARD_RIGHTS_REQUIRED|SYNCHRONIZE|0x3) ;

//
// Object Manager Symbolic Link Specific Access Rights.
//

const auto DUPLICATE_CLOSE_SOURCE       = 0x00000001  ;
const auto DUPLICATE_SAME_ACCESS        = 0x00000002  ;

//
// =========================================
// Define GUIDs which represent well-known power schemes
// =========================================
//

/*
//
// Maximum Power Savings - indicates that very aggressive power savings measures will be used to help
//                         stretch battery life.
//
// {a1841308-3541-4fab-bc81-f71556f20b4a}
//
DEFINE_GUID( GUID_MAX_POWER_SAVINGS, 0xA1841308, 0x3541, 0x4FAB, 0xBC, 0x81, 0xF7, 0x15, 0x56, 0xF2, 0x0B, 0x4A );

//
// No Power Savings - indicates that almost no power savings measures will be used.
//
// {8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c}
//
DEFINE_GUID( GUID_MIN_POWER_SAVINGS, 0x8C5E7FDA, 0xE8BF, 0x4A96, 0x9A, 0x85, 0xA6, 0xE2, 0x3A, 0x8C, 0x63, 0x5C );

//
// Typical Power Savings - indicates that fairly aggressive power savings measures will be used.
//
// {381b4222-f694-41f0-9685-ff5bb260df2e}
//
DEFINE_GUID( GUID_TYPICAL_POWER_SAVINGS, 0x381B4222, 0xF694, 0x41F0, 0x96, 0x85, 0xFF, 0x5B, 0xB2, 0x60, 0xDF, 0x2E );

//
// This is a special GUID that represents "no subgroup" of settings.  That is, it indicates
// that settings that are in the root of the power policy hierarchy as opposed to settings
// that are buried under a subgroup of settings.  This should be used when querying for
// power settings that may not fall into a subgroup.
//
DEFINE_GUID( NO_SUBGROUP_GUID, 0xFEA3413E, 0x7E05, 0x4911, 0x9A, 0x71, 0x70, 0x03, 0x31, 0xF1, 0xC2, 0x94 );

//
// This is a special GUID that represents "every power scheme".  That is, it indicates
// that any write to this power scheme should be reflected to every scheme present.
// This allows users to write a single setting once and have it apply to all schemes.  They
// can then apply custom settings to specific power schemes that they care about.
//
DEFINE_GUID( ALL_POWERSCHEMES_GUID, 0x68A1E95E, 0x13EA, 0x41E1, 0x80, 0x11, 0x0C, 0x49, 0x6C, 0xA4, 0x90, 0xB0 );

//
// This is a special GUID that represents a 'personality' that each power scheme will have.
// In other words, each power scheme will have this key indicating "I'm most like *this* base
// power scheme."  This individual setting will have one of three settings:
// GUID_MAX_POWER_SAVINGS
// GUID_MIN_POWER_SAVINGS
// GUID_TYPICAL_POWER_SAVINGS
//
// This allows several features:
// 1. Drivers and applications can register for notification of this GUID.  So when this power
//    scheme is activiated, this GUID's setting will be sent across the system and drivers/applications
//    can see "GUID_MAX_POWER_SAVINGS" which will tell them in a generic fashion "get real aggressive
//    about conserving power".
// 2. UserB may install a driver or application which creates power settings, and UserB may modify
//    those power settings.  Now UserA logs in.  How does he see those settings?  They simply don't
//    exist in his private power key.  Well they do exist over in the system power key.  When we
//    enumerate all the power settings in this system power key and don't find a corresponding entry
//    in the user's private power key, then we can go look at this "personality" key in the users
//    power scheme.  We can then go get a default value for the power setting, depending on which
//    "personality" power scheme is being operated on.  Here's an example:
//    A. UserB installs an application that creates a power setting Seetting1
//    B. UserB changes Setting1 to have a value of 50 because that's one of the possible settings
//       available for setting1.
//    C. UserB logs out
//    D. UserA logs in and his active power scheme is some custom scheme that was derived from
//       the GUID_TYPICAL_POWER_SAVINGS.  But remember that UserA has no setting1 in his 
//       private power key.
//    E. When activating UserA's selected power scheme, all power settings in the system power key will
//       be enumerated (including Setting1).
//    F. The power manager will see that UserA has no Setting1 power setting in his private power scheme.
//    G. The power manager will query UserA's power scheme for its personality and retrieve
//       GUID_TYPICAL_POWER_SAVINGS.
//    H. The power manager then looks in Setting1 in the system power key and looks in its set of default
//       values for the corresponding value for GUID_TYPICAL_POWER_SAVINGS power schemes.
//    I. This derived power setting is applied.
DEFINE_GUID( GUID_POWERSCHEME_PERSONALITY, 0x245D8541, 0x3943, 0x4422, 0xB0, 0x25, 0x13, 0xA7, 0x84, 0xF6, 0x79, 0xB7 );

//
// Define a special GUID which will be used to define the active power scheme.
// User will register for this power setting GUID, and when the active power
// scheme changes, they'll get a callback where the payload is the GUID
// representing the active powerscheme.
// ( 31F9F286-5084-42FE-B720-2B0264993763 }
//
DEFINE_GUID( GUID_ACTIVE_POWERSCHEME, 0x31F9F286, 0x5084, 0x42FE, 0xB7, 0x20, 0x2B, 0x02, 0x64, 0x99, 0x37, 0x63 );

//
// =========================================
// Define GUIDs which represent well-known power settings
// =========================================
//

// Video settings
// --------------
//
// Specifies the subgroup which will contain all of the video
// settings for a single policy.
//
DEFINE_GUID( GUID_VIDEO_SUBGROUP, 0x7516B95F, 0xF776, 0x4464, 0x8C, 0x53, 0x06, 0x16, 0x7F, 0x40, 0xCC, 0x99 );

//
// Specifies (in seconds) how long we wait after the last user input has been
// recieved before we power off the video.
//
DEFINE_GUID( GUID_VIDEO_POWERDOWN_TIMEOUT, 0x3C0BC021, 0xC8A8, 0x4E07, 0xA9, 0x73, 0x6B, 0x14, 0xCB, 0xCB, 0x2B, 0x7E );

//
// Specifies if the operating system should use adaptive timers (based on
// previous behavior) to power down the video,
//
DEFINE_GUID( GUID_VIDEO_ADAPTIVE_POWERDOWN, 0x90959D22, 0xD6A1, 0x49B9, 0xAF, 0x93, 0xBC, 0xE8, 0x85, 0xAD, 0x33, 0x5B );

//
// Specifies if the monitor is currently being powered or not.
// 02731015-4510-4526-99E6-E5A17EBD1AEA
//
DEFINE_GUID( GUID_MONITOR_POWER_ON, 0x02731015, 0x4510, 0x4526, 0x99, 0xE6, 0xE5, 0xA1, 0x7E, 0xBD, 0x1A, 0xEA );



// Harddisk settings
// -----------------
//
// Specifies the subgroup which will contain all of the harddisk
// settings for a single policy.
//
DEFINE_GUID( GUID_DISK_SUBGROUP, 0x0012EE47, 0x9041, 0x4B5D, 0x9B, 0x77, 0x53, 0x5F, 0xBA, 0x8B, 0x14, 0x42 );

//
// Specifies (in seconds) how long we wait after the last disk access
// before we power off the disk.
//
DEFINE_GUID( GUID_DISK_POWERDOWN_TIMEOUT, 0x6738E2C4, 0xE8A5, 0x4A42, 0xB1, 0x6A, 0xE0, 0x40, 0xE7, 0x69, 0x75, 0x6E );

//
// Specifies if the operating system should use adaptive timers (based on
// previous behavior) to power down the disk,
//
DEFINE_GUID( GUID_DISK_ADAPTIVE_POWERDOWN, 0x396A32E1, 0x499A, 0x40B2, 0x91, 0x24, 0xA9, 0x6A, 0xFE, 0x70, 0x76, 0x67 );




// System sleep settings
// ---------------------
//
// Specifies the subgroup which will contain all of the sleep
// settings for a single policy.
// { 238C9FA8-0AAD-41ED-83F4-97BE242C8F20 }
//
DEFINE_GUID( GUID_SLEEP_SUBGROUP, 0x238C9FA8, 0x0AAD, 0x41ED, 0x83, 0xF4, 0x97, 0xBE, 0x24, 0x2C, 0x8F, 0x20 );

//
// Specifies an idle treshold percentage (0-100). The system must be this idle
// over a period of time in order to idle to sleep.
//
DEFINE_GUID( GUID_SLEEP_IDLE_THRESHOLD, 0x81cd32e0, 0x7833, 0x44f3, 0x87, 0x37, 0x70, 0x81, 0xf3, 0x8d, 0x1f, 0x70 );
                                  
//
// Specifies (in seconds) how long we wait after the system is deemed
// "idle" before moving to standby (S1, S2 or S3).
//
DEFINE_GUID( GUID_STANDBY_TIMEOUT, 0x29F6C1DB, 0x86DA, 0x48C5, 0x9F, 0xDB, 0xF2, 0xB6, 0x7B, 0x1F, 0x44, 0xDA );

//
// Specifies (in seconds) how long we wait after the system is deemed
// "idle" before moving to hibernate (S4).
//
DEFINE_GUID( GUID_HIBERNATE_TIMEOUT, 0x9D7815A6, 0x7EE4, 0x497E, 0x88, 0x88, 0x51, 0x5A, 0x05, 0xF0, 0x23, 0x64 );

//
// Specifies whether or not Fast S4 should be enabled if the system supports it
// 94AC6D29-73CE-41A6-809F-6363BA21B47E
//
DEFINE_GUID( GUID_HIBERNATE_FASTS4_POLICY, 0x94AC6D29, 0x73CE, 0x41A6, 0x80, 0x9F, 0x63, 0x63, 0xBA, 0x21, 0xB4, 0x7E );

//
// Define a GUID for controlling the criticality of sleep state transitions.
// Critical sleep transitions do not query applications, services or drivers
// before transitioning the platform to a sleep state.
//
// {B7A27025-E569-46c2-A504-2B96CAD225A1}
//
DEFINE_GUID( GUID_CRITICAL_POWER_TRANSITION,  0xB7A27025, 0xE569, 0x46c2, 0xA5, 0x04, 0x2B, 0x96, 0xCA, 0xD2, 0x25, 0xA1);

//
// Specifies if the system is entering or exiting 'away mode'.
// 98A7F580-01F7-48AA-9C0F-44352C29E5C0
//
DEFINE_GUID( GUID_SYSTEM_AWAYMODE, 0x98A7F580, 0x01F7, 0x48AA, 0x9C, 0x0F, 0x44, 0x35, 0x2C, 0x29, 0xE5, 0xC0 );

// Specify whether away mode is allowed 
//
// {25DFA149-5DD1-4736-B5AB-E8A37B5B8187}
//
DEFINE_GUID( GUID_ALLOW_AWAYMODE, 0x25dfa149, 0x5dd1, 0x4736, 0xb5, 0xab, 0xe8, 0xa3, 0x7b, 0x5b, 0x81, 0x87 );

//
// Defines a guid for enabling/disabling standby (S1-S3) states. This does not
// affect hibernation (S4).
//
// {abfc2519-3608-4c2a-94ea-171b0ed546ab}
//
DEFINE_GUID( GUID_ALLOW_STANDBY_STATES, 0xabfc2519, 0x3608, 0x4c2a, 0x94, 0xea, 0x17, 0x1b, 0x0e, 0xd5, 0x46, 0xab );

//
// Defines a guid for enabling/disabling the ability to wake via RTC.
//
// {BD3B718A-0680-4D9D-8AB2-E1D2B4AC806D}
//
DEFINE_GUID( GUID_ALLOW_RTC_WAKE, 0xBD3B718A, 0x0680, 0x4D9D, 0x8A, 0xB2, 0xE1, 0xD2, 0xB4, 0xAC, 0x80, 0x6D );

// System button actions
// ---------------------
//
//
// Specifies the subgroup which will contain all of the system button
// settings for a single policy.
//
DEFINE_GUID( GUID_SYSTEM_BUTTON_SUBGROUP, 0x4F971E89, 0xEEBD, 0x4455, 0xA8, 0xDE, 0x9E, 0x59, 0x04, 0x0E, 0x73, 0x47 );

// Specifies (in a POWER_ACTION_POLICY structure) the appropriate action to
// take when the system power button is pressed.
//
DEFINE_GUID( GUID_POWERBUTTON_ACTION, 0x7648EFA3, 0xDD9C, 0x4E3E, 0xB5, 0x66, 0x50, 0xF9, 0x29, 0x38, 0x62, 0x80 );
DEFINE_GUID( GUID_POWERBUTTON_ACTION_FLAGS, 0x857E7FAC, 0x034B, 0x4704, 0xAB, 0xB1, 0xBC, 0xA5, 0x4A, 0xA3, 0x14, 0x78 );

//
// Specifies (in a POWER_ACTION_POLICY structure) the appropriate action to
// take when the system sleep button is pressed.
//
DEFINE_GUID( GUID_SLEEPBUTTON_ACTION, 0x96996BC0, 0xAD50, 0x47EC, 0x92, 0x3B, 0x6F, 0x41, 0x87, 0x4D, 0xD9, 0xEB );
DEFINE_GUID( GUID_SLEEPBUTTON_ACTION_FLAGS, 0x2A160AB1, 0xB69D, 0x4743, 0xB7, 0x18, 0xBF, 0x14, 0x41, 0xD5, 0xE4, 0x93 );

//
// Specifies (in a POWER_ACTION_POLICY structure) the appropriate action to
// take when the system sleep button is pressed.
// { A7066653-8D6C-40A8-910E-A1F54B84C7E5 }
//
DEFINE_GUID( GUID_USERINTERFACEBUTTON_ACTION, 0xA7066653, 0x8D6C, 0x40A8, 0x91, 0x0E, 0xA1, 0xF5, 0x4B, 0x84, 0xC7, 0xE5 );

//
// Specifies (in a POWER_ACTION_POLICY structure) the appropriate action to
// take when the system lid is closed.
//
DEFINE_GUID( GUID_LIDCLOSE_ACTION, 0x5CA83367, 0x6E45, 0x459F, 0xA2, 0x7B, 0x47, 0x6B, 0x1D, 0x01, 0xC9, 0x36 );
DEFINE_GUID( GUID_LIDCLOSE_ACTION_FLAGS, 0x97E969AC, 0x0D6C, 0x4D08, 0x92, 0x7C, 0xD7, 0xBD, 0x7A, 0xD7, 0x85, 0x7B );
DEFINE_GUID( GUID_LIDOPEN_POWERSTATE, 0x99FF10E7, 0x23B1, 0x4C07, 0xA9, 0xD1, 0x5C, 0x32, 0x06, 0xD7, 0x41, 0xB4 );


// Battery Discharge Settings
// --------------------------
//
// Specifies the subgroup which will contain all of the battery discharge
// settings for a single policy.
//
DEFINE_GUID( GUID_BATTERY_SUBGROUP, 0xE73A048D, 0xBF27, 0x4F12, 0x97, 0x31, 0x8B, 0x20, 0x76, 0xE8, 0x89, 0x1F );

//
// 4 battery discharge alarm settings.
//
// GUID_BATTERY_DISCHARGE_ACTION_x - This is the action to take.  It is a value
//                                   of type POWER_ACTION
// GUID_BATTERY_DISCHARGE_LEVEL_x  - This is the battery level (%)
// GUID_BATTERY_DISCHARGE_FLAGS_x  - Flags defined below:
//                                   POWER_ACTION_POLICY->EventCode flags
//                                   BATTERY_DISCHARGE_FLAGS_EVENTCODE_MASK
//                                   BATTERY_DISCHARGE_FLAGS_ENABLE
DEFINE_GUID( GUID_BATTERY_DISCHARGE_ACTION_0, 0x637EA02F, 0xBBCB, 0x4015, 0x8E, 0x2C, 0xA1, 0xC7, 0xB9, 0xC0, 0xB5, 0x46 );
DEFINE_GUID( GUID_BATTERY_DISCHARGE_LEVEL_0, 0x9A66D8D7, 0x4FF7, 0x4EF9, 0xB5, 0xA2, 0x5A, 0x32, 0x6C, 0xA2, 0xA4, 0x69 );
DEFINE_GUID( GUID_BATTERY_DISCHARGE_FLAGS_0, 0x5dbb7c9f, 0x38e9, 0x40d2, 0x97, 0x49, 0x4f, 0x8a, 0x0e, 0x9f, 0x64, 0x0f );

DEFINE_GUID( GUID_BATTERY_DISCHARGE_ACTION_1, 0xD8742DCB, 0x3E6A, 0x4B3C, 0xB3, 0xFE, 0x37, 0x46, 0x23, 0xCD, 0xCF, 0x06 );
DEFINE_GUID( GUID_BATTERY_DISCHARGE_LEVEL_1, 0x8183BA9A, 0xE910, 0x48DA, 0x87, 0x69, 0x14, 0xAE, 0x6D, 0xC1, 0x17, 0x0A );
DEFINE_GUID( GUID_BATTERY_DISCHARGE_FLAGS_1, 0xbcded951, 0x187b, 0x4d05, 0xbc, 0xcc, 0xf7, 0xe5, 0x19, 0x60, 0xc2, 0x58 );

DEFINE_GUID( GUID_BATTERY_DISCHARGE_ACTION_2, 0x421CBA38, 0x1A8E, 0x4881, 0xAC, 0x89, 0xE3, 0x3A, 0x8B, 0x04, 0xEC, 0xE4 );
DEFINE_GUID( GUID_BATTERY_DISCHARGE_LEVEL_2, 0x07A07CA2, 0xADAF, 0x40D7, 0xB0, 0x77, 0x53, 0x3A, 0xAD, 0xED, 0x1B, 0xFA );
DEFINE_GUID( GUID_BATTERY_DISCHARGE_FLAGS_2, 0x7fd2f0c4, 0xfeb7, 0x4da3, 0x81, 0x17, 0xe3, 0xfb, 0xed, 0xc4, 0x65, 0x82 );

DEFINE_GUID( GUID_BATTERY_DISCHARGE_ACTION_3, 0x80472613, 0x9780, 0x455E, 0xB3, 0x08, 0x72, 0xD3, 0x00, 0x3C, 0xF2, 0xF8 );
DEFINE_GUID( GUID_BATTERY_DISCHARGE_LEVEL_3, 0x58AFD5A6, 0xC2DD, 0x47D2, 0x9F, 0xBF, 0xEF, 0x70, 0xCC, 0x5C, 0x59, 0x65 );
DEFINE_GUID( GUID_BATTERY_DISCHARGE_FLAGS_3, 0x73613ccf, 0xdbfa, 0x4279, 0x83, 0x56, 0x49, 0x35, 0xf6, 0xbf, 0x62, 0xf3 );

// Processor power settings
// ------------------------
//

// Specifies the subgroup which will contain all of the processor
// settings for a single policy.
//
DEFINE_GUID( GUID_PROCESSOR_SETTINGS_SUBGROUP, 0x54533251, 0x82BE, 0x4824, 0x96, 0xC1, 0x47, 0xB6, 0x0B, 0x74, 0x0D, 0x00 );


DEFINE_GUID( GUID_PROCESSOR_THROTTLE_POLICY, 0x57027304, 0x4AF6, 0x4104, 0x92, 0x60, 0xE3, 0xD9, 0x52, 0x48, 0xFC, 0x36 );

//
// Specifies a percentage (between 0 and 100) that the processor frequency
// should never go above.  For example, if this value is set to 80, then
// the processor frequency will never be throttled above 80 percent of its 
// maximum frequency by the system.
// 
DEFINE_GUID( GUID_PROCESSOR_THROTTLE_MAXIMUM, 0xBC5038F7, 0x23E0, 0x4960, 0x96, 0xDA, 0x33, 0xAB, 0xAF, 0x59, 0x35, 0xEC );

//
// Specifies a percentage (between 0 and 100) that the processor frequency
// should not drop below.  For example, if this value is set to 50, then the
// processor frequency will never be throttled below 50 percent of its
// maximum frequency by the system.
//
DEFINE_GUID( GUID_PROCESSOR_THROTTLE_MINIMUM, 0x893DEE8E, 0x2BEF, 0x41E0, 0x89, 0xC6, 0xB5, 0x5D, 0x09, 0x29, 0x96, 0x4C );

//
// Specifies processor power settings for CState policy data
// {68F262A7-F621-4069-B9A5-4874169BE23C}
//
DEFINE_GUID( GUID_PROCESSOR_IDLESTATE_POLICY, 0x68f262a7, 0xf621, 0x4069, 0xb9, 0xa5, 0x48, 0x74, 0x16, 0x9b, 0xe2, 0x3c);

//
// Specifies processor power settings for PerfState policy data
// {BBDC3814-18E9-4463-8A55-D197327C45C0}
//
DEFINE_GUID( GUID_PROCESSOR_PERFSTATE_POLICY, 0xBBDC3814, 0x18E9, 0x4463, 0x8A, 0x55, 0xD1, 0x97, 0x32, 0x7C, 0x45, 0xC0);

//
// Specifies active vs passive cooling.  Although not directly related to
// processor settings, it is the processor that gets throttled if we're doing
// passive cooling, so it is fairly strongly related.
// {94D3A615-A899-4AC5-AE2B-E4D8F634367F}
//
DEFINE_GUID( GUID_SYSTEM_COOLING_POLICY, 0x94D3A615, 0xA899, 0x4AC5, 0xAE, 0x2B, 0xE4, 0xD8, 0xF6, 0x34, 0x36, 0x7F);



// Lock Console on Wake
// --------------------
//

// Specifies the behavior of the system when we wake from standby or
// hibernate.  If this is set, then we will cause the console to lock
// after we resume.
//
DEFINE_GUID( GUID_LOCK_CONSOLE_ON_WAKE, 0x0E796BDB, 0x100D, 0x47D6, 0xA2, 0xD5, 0xF7, 0xD2, 0xDA, 0xA5, 0x1F, 0x51 );



// AC/DC power source
// ------------------
//

// Specifies the power source for the system.  consumers may register for
// notification when the power source changes and will be notified with
// one of 3 values:
// 0 - Indicates the system is being powered by an AC power source.
// 1 - Indicates the system is being powered by a DC power source.
// 2 - Indicates the system is being powered by a short-term DC power
//     source.  For example, this would be the case if the system is
//     being powed by a short-term battery supply in a backing UPS
//     system.  When this value is recieved, the consumer should make
//     preparations for either a system hibernate or system shutdown.
//
// { 5D3E9A59-E9D5-4B00-A6BD-FF34FF516548 }
DEFINE_GUID( GUID_ACDC_POWER_SOURCE, 0x5D3E9A59, 0xE9D5, 0x4B00, 0xA6, 0xBD, 0xFF, 0x34, 0xFF, 0x51, 0x65, 0x48 );

// Lid state changes
// -----------------
//
// Specifies the current state of the lid (open or closed). The callback won't
// be called at all until a lid device is found and its current state is known.
//
// Values:
//
// 0 - closed
// 1 - opened
//
// { BA3E0F4D-B817-4094-A2D1-D56379E6A0F3 }
//

DEFINE_GUID( GUID_LIDSWITCH_STATE_CHANGE,  0xBA3E0F4D, 0xB817, 0x4094, 0xA2, 0xD1, 0xD5, 0x63, 0x79, 0xE6, 0xA0, 0xF3 );

// Battery life remaining
// ----------------------
//

// Specifies the percentage of battery life remaining.  The consumer
// may register for notification in order to track battery life in
// a fine-grained manner.
//
// Once registered, the consumer can expect to be notified as the battery
// life percentage changes.
// 
// The consumer will recieve a value between 0 and 100 (inclusive) which
// indicates percent battery life remaining.
//
// { A7AD8041-B45A-4CAE-87A3-EECBB468A9E1 }
DEFINE_GUID( GUID_BATTERY_PERCENTAGE_REMAINING, 0xA7AD8041, 0xB45A, 0x4CAE, 0x87, 0xA3, 0xEE, 0xCB, 0xB4, 0x68, 0xA9, 0xE1 );


// Notification to listeners that the system is fairly busy and won't be moving
// into an idle state any time soon.  This can be used as a hint to listeners
// that now might be a good time to do background tasks.
//
DEFINE_GUID( GUID_IDLE_BACKGROUND_TASK, 0x515C31D8, 0xF734, 0x163D, 0xA0, 0xFD, 0x11, 0xA0, 0x8C, 0x91, 0xE8, 0xF1 );

// Notification to listeners that the system is fairly busy and won't be moving
// into an idle state any time soon.  This can be used as a hint to listeners
// that now might be a good time to do background tasks.
//
// { CF23F240-2A54-48D8-B114-DE1518FF052E }
DEFINE_GUID( GUID_BACKGROUND_TASK_NOTIFICATION, 0xCF23F240, 0x2A54, 0x48D8, 0xB1, 0x14, 0xDE, 0x15, 0x18, 0xFF, 0x05, 0x2E );

// Define a GUID that will represent the action of a direct experience button
// on the platform.  Users will register for this DPPE setting and recieve
// notification when the h/w button is pressed.
//
// { 1A689231-7399-4E9A-8F99-B71F999DB3FA }
//
DEFINE_GUID( GUID_APPLAUNCH_BUTTON, 0x1A689231, 0x7399, 0x4E9A, 0x8F, 0x99, 0xB7, 0x1F, 0x99, 0x9D, 0xB3, 0xFA );

// PCI Express power settings
// ------------------------
//

// Specifies the subgroup which will contain all of the PCI Express
// settings for a single policy.
// 
// {501a4d13-42af-4429-9fd1-a8218c268e20}
// 
DEFINE_GUID( GUID_PCIEXPRESS_SETTINGS_SUBGROUP, 0x501a4d13, 0x42af,0x4429, 0x9f, 0xd1, 0xa8, 0x21, 0x8c, 0x26, 0x8e, 0x20 );

// Specifies the PCI Express ASPM power policy.
//
// {ee12f906-d277-404b-b6da-e5fa1a576df5}
//
DEFINE_GUID( GUID_PCIEXPRESS_ASPM_POLICY, 0xee12f906, 0xd277, 0x404b, 0xb6, 0xda, 0xe5, 0xfa, 0x1a, 0x57, 0x6d, 0xf5 );

*/

enum SYSTEM_POWER_STATE {
    PowerSystemUnspecified = 0,
    PowerSystemWorking     = 1,
    PowerSystemSleeping1   = 2,
    PowerSystemSleeping2   = 3,
    PowerSystemSleeping3   = 4,
    PowerSystemHibernate   = 5,
    PowerSystemShutdown    = 6,
    PowerSystemMaximum     = 7
}

alias SYSTEM_POWER_STATE* PSYSTEM_POWER_STATE;

const auto POWER_SYSTEM_MAXIMUM  = 7;

enum POWER_ACTION {
    PowerActionNone = 0,
    PowerActionReserved,
    PowerActionSleep,
    PowerActionHibernate,
    PowerActionShutdown,
    PowerActionShutdownReset,
    PowerActionShutdownOff,
    PowerActionWarmEject
}

alias POWER_ACTION* PPOWER_ACTION;

enum DEVICE_POWER_STATE {
    PowerDeviceUnspecified = 0,
    PowerDeviceD0,
    PowerDeviceD1,
    PowerDeviceD2,
    PowerDeviceD3,
    PowerDeviceMaximum
}

alias DEVICE_POWER_STATE* PDEVICE_POWER_STATE;



const auto ES_SYSTEM_REQUIRED    = (cast(DWORD)0x00000001);
const auto ES_DISPLAY_REQUIRED   = (cast(DWORD)0x00000002);
const auto ES_USER_PRESENT       = (cast(DWORD)0x00000004);
const auto ES_AWAYMODE_REQUIRED  = (cast(DWORD)0x00000040);
const auto ES_CONTINUOUS         = (cast(DWORD)0x80000000);

alias DWORD EXECUTION_STATE;

enum LATENCY_TIME {
    LT_DONT_CARE,
    LT_LOWEST_LATENCY
}

// end_ntminiport 

//-----------------------------------------------------------------------------
// Device Power Information
// Accessable via CM_Get_DevInst_Registry_Property_Ex(CM_DRP_DEVICE_POWER_DATA)
//-----------------------------------------------------------------------------

const auto PDCAP_D0_SUPPORTED               = 0x00000001;
const auto PDCAP_D1_SUPPORTED               = 0x00000002;
const auto PDCAP_D2_SUPPORTED               = 0x00000004;
const auto PDCAP_D3_SUPPORTED               = 0x00000008;
const auto PDCAP_WAKE_FROM_D0_SUPPORTED     = 0x00000010;
const auto PDCAP_WAKE_FROM_D1_SUPPORTED     = 0x00000020;
const auto PDCAP_WAKE_FROM_D2_SUPPORTED     = 0x00000040;
const auto PDCAP_WAKE_FROM_D3_SUPPORTED     = 0x00000080;
const auto PDCAP_WARM_EJECT_SUPPORTED       = 0x00000100;

struct CM_POWER_DATA {
    DWORD               PD_Size;
    DEVICE_POWER_STATE  PD_MostRecentPowerState;
    DWORD               PD_Capabilities;
    DWORD               PD_D1Latency;
    DWORD               PD_D2Latency;
    DWORD               PD_D3Latency;
    DEVICE_POWER_STATE  PD_PowerStateMapping[POWER_SYSTEM_MAXIMUM];
    SYSTEM_POWER_STATE  PD_DeepestSystemWake;
}

alias CM_POWER_DATA* PCM_POWER_DATA;

// begin_wdm

enum  POWER_INFORMATION_LEVEL {
    SystemPowerPolicyAc,
    SystemPowerPolicyDc,
    VerifySystemPolicyAc,
    VerifySystemPolicyDc,
    SystemPowerCapabilities,
    SystemBatteryState,
    SystemPowerStateHandler,
    ProcessorStateHandler,
    SystemPowerPolicyCurrent,
    AdministratorPowerPolicy,
    SystemReserveHiberFile,
    ProcessorInformation,
    SystemPowerInformation,
    ProcessorStateHandler2,
    LastWakeTime,                                   // Compare with KeQueryInterruptTime()
    LastSleepTime,                                  // Compare with KeQueryInterruptTime()
    SystemExecutionState,
    SystemPowerStateNotifyHandler,
    ProcessorPowerPolicyAc,
    ProcessorPowerPolicyDc,
    VerifyProcessorPowerPolicyAc,
    VerifyProcessorPowerPolicyDc,
    ProcessorPowerPolicyCurrent,
    SystemPowerStateLogging,
    SystemPowerLoggingEntry,
    SetPowerSettingValue,
    NotifyUserPowerSetting,
    GetPowerTransitionVetoes,
    SetPowerTransitionVeto,
    SystemVideoState,
    TraceApplicationPowerMessage,
    TraceApplicationPowerMessageEnd,
    ProcessorPerfStates,
    ProcessorIdleStates,
    ProcessorThrottleStates,
    SystemWakeSource,
    SystemHiberFileInformation,
    TraceServicePowerMessage,
    ProcessorLoad,
    PowerShutdownNotification
}

//
// Power Transition Vetos
//

const auto PO_TRANSITION_VETO_TYPE_WINDOW   = 0x00000001;
const auto PO_TRANSITION_VETO_TYPE_SERVICE  = 0x00000002;
//#define PO_TRANSITION_VETO_TYPE_DRIVER  0x00000004

const auto PO_TRANSITION_VETO_TYPE_ALL      =
    (PO_TRANSITION_VETO_TYPE_WINDOW | PO_TRANSITION_VETO_TYPE_SERVICE);

struct PO_TRANSITION_VETO_REASON {
    DWORD ResourceId;
    DWORD ModuleNameOffset;
}

alias PO_TRANSITION_VETO_REASON* PPO_TRANSITION_VETO_REASON;

struct PO_TRANSITION_VETO_WINDOW {
    HANDLE Handle;
}

alias PO_TRANSITION_VETO_WINDOW* PPO_TRANSITION_VETO_WINDOW;

struct PO_TRANSITION_VETO_SERVICE {
    DWORD ServiceNameOffset;
}

alias PO_TRANSITION_VETO_SERVICE* PPO_TRANSITION_VETO_SERVICE;

/*

struct PO_TRANSITION_VETO_DRIVER {
    DWORD InstancePathOffset;
    DWORD DriverNameOffset;
}

alias PO_TRANSITION_VETO_DRIVER* PPO_TRANSITION_VETO_DRIVER;

*/

struct PO_TRANSITION_VETO {
    DWORD Type;
    PO_TRANSITION_VETO_REASON Reason;
    DWORD ProcessId;    

    union {
        PO_TRANSITION_VETO_WINDOW Window;
        PO_TRANSITION_VETO_SERVICE Service;
        //PO_TRANSITION_VETO_DRIVER Driver;
    };
}

alias PO_TRANSITION_VETO* PPO_TRANSITION_VETO;

struct PO_TRANSITION_VETOES {
    DWORD Count;
    PO_TRANSITION_VETO Vetoes[];
}

alias PO_TRANSITION_VETOES* PPO_TRANSITION_VETOES;

//
// Power Setting definitions
//

enum SYSTEM_POWER_CONDITION {
    PoAc,
    PoDc,
    PoHot,
    PoConditionMaximum
}

struct SET_POWER_SETTING_VALUE {
    
    //
    // Version of this structure.  Currently should be set to
    // POWER_SETTING_VALUE_VERSION.
    //
    DWORD       Version;
    
    
    //
    // GUID representing the power setting being applied.
    //
    GUID        Guid;
    
    
    //
    // What power state should this setting be applied to?  E.g.
    // AC, DC, thermal, ...
    //
    SYSTEM_POWER_CONDITION PowerCondition;
    
    //
    // Length (in bytes) of the 'Data' member.
    //
    DWORD       DataLength;
    
    //
    // Data which contains the actual setting value.
    // 
    BYTE    Data[];
}

alias SET_POWER_SETTING_VALUE* PSET_POWER_SETTING_VALUE;

const auto POWER_SETTING_VALUE_VERSION  = (0x1);

struct NOTIFY_USER_POWER_SETTING {
    GUID Guid;
}

alias NOTIFY_USER_POWER_SETTING* PNOTIFY_USER_POWER_SETTING;

//
// Package definition for an experience button device notification.  When
// someone registers for GUID_EXPERIENCE_BUTTON, this is the definition of
// the setting data they'll get.
//
struct APPLICATIONLAUNCH_SETTING_VALUE {

    //
    // System time when the most recent button press ocurred.  Note that this is
    // specified in 100ns internvals since January 1, 1601.
    //    
    LARGE_INTEGER       ActivationTime;
    
    //
    // Reserved for internal use.
    //
    DWORD               Flags;

    //
    // which instance of this device was pressed?
    //
    DWORD               ButtonInstanceID;


}

alias APPLICATIONLAUNCH_SETTING_VALUE* PAPPLICATIONLAUNCH_SETTING_VALUE;

//
// define platform roles
//

enum POWER_PLATFORM_ROLE {
    PlatformRoleUnspecified = 0,
    PlatformRoleDesktop,
    PlatformRoleMobile,
    PlatformRoleWorkstation,
    PlatformRoleEnterpriseServer,
    PlatformRoleSOHOServer,
    PlatformRoleAppliancePC,
    PlatformRolePerformanceServer,
    PlatformRoleMaximum
}

//
// Wake source tracking
//

enum PO_WAKE_SOURCE_TYPE {
    DeviceWakeSourceType,
    FixedWakeSourceType
}

alias PO_WAKE_SOURCE_TYPE* PPO_WAKE_SOURCE_TYPE;

enum PO_FIXED_WAKE_SOURCE_TYPE {
    FixedWakeSourcePowerButton,
    FixedWakeSourceSleepButton,
    FixedWakeSourceRtc
}

alias PO_FIXED_WAKE_SOURCE_TYPE* PPO_FIXED_WAKE_SOURCE_TYPE;

struct PO_WAKE_SOURCE_HEADER {
    PO_WAKE_SOURCE_TYPE Type;
    DWORD Size;
}

alias PO_WAKE_SOURCE_HEADER* PPO_WAKE_SOURCE_HEADER;

struct PO_WAKE_SOURCE_DEVICE {
    PO_WAKE_SOURCE_HEADER Header;
    WCHAR InstancePath[];
}

alias PO_WAKE_SOURCE_DEVICE* PPO_WAKE_SOURCE_DEVICE;

struct PO_WAKE_SOURCE_FIXED {
    PO_WAKE_SOURCE_HEADER Header;
    PO_FIXED_WAKE_SOURCE_TYPE FixedWakeSourceType;
}

alias PO_WAKE_SOURCE_FIXED* PPO_WAKE_SOURCE_FIXED;

struct PO_WAKE_SOURCE_INFO {
    DWORD Count;
    DWORD Offsets[];
}

alias PO_WAKE_SOURCE_INFO* PPO_WAKE_SOURCE_INFO;

struct PO_WAKE_SOURCE_HISTORY {
    DWORD Count;
    DWORD Offsets[];
}

alias PO_WAKE_SOURCE_HISTORY* PPO_WAKE_SOURCE_HISTORY;

//
// System power manager capabilities
//

struct BATTERY_REPORTING_SCALE {
    DWORD       Granularity;
    DWORD       Capacity;
}

alias BATTERY_REPORTING_SCALE* PBATTERY_REPORTING_SCALE;

//

struct PPM_SIMULATED_PROCESSOR_LOAD {
    BOOLEAN Enabled;
    BYTE  PercentBusy[MAXIMUM_PROCESSORS];
}

alias PPM_SIMULATED_PROCESSOR_LOAD* PPPM_SIMULATED_PROCESSOR_LOAD;

struct PPM_WMI_LEGACY_PERFSTATE {
    DWORD   Frequency;
    DWORD   Flags;
    DWORD   PercentFrequency;
}

alias PPM_WMI_LEGACY_PERFSTATE* PPPM_WMI_LEGACY_PERFSTATE;

struct PPM_WMI_IDLE_STATE {
    DWORD Latency;
    DWORD Power;
    DWORD TimeCheck;
    BYTE  PromotePercent;
    BYTE  DemotePercent;
    BYTE  StateType;
    BYTE  Reserved;
    DWORD StateFlags;
    DWORD Context;
    DWORD IdleHandler;
    DWORD Reserved1;            // reserved for future use
}

alias PPM_WMI_IDLE_STATE* PPPM_WMI_IDLE_STATE;

struct PPM_WMI_IDLE_STATES {
    DWORD Type;
    DWORD Count;
    DWORD TargetState;          // current idle state
    DWORD OldState;             // previous idle state
    DWORD64 TargetProcessors;
    PPM_WMI_IDLE_STATE State[];
}

alias PPM_WMI_IDLE_STATES* PPPM_WMI_IDLE_STATES;

struct PPM_WMI_PERF_STATE {
    DWORD Frequency;            // in Mhz
    DWORD Power;                // in milliwatts
    BYTE  PercentFrequency;
    BYTE  IncreaseLevel;        // goto higher state
    BYTE  DecreaseLevel;        // goto lower state
    BYTE  Type;                 // performance or throttle
    DWORD IncreaseTime;         // in tick counts
    DWORD DecreaseTime;         // in tick counts
    DWORD64 Control;            // control value
    DWORD64 Status;             // control value
    DWORD HitCount;
    DWORD Reserved1;            // reserved for future use
    DWORD64 Reserved2;
    DWORD64 Reserved3;
}

alias PPM_WMI_PERF_STATE* PPPM_WMI_PERF_STATE;

struct PPM_WMI_PERF_STATES {
    DWORD Count;
    DWORD MaxFrequency;
    DWORD CurrentState;         // current state
    DWORD MaxPerfState;         // fastest state considering policy restrictions
    DWORD MinPerfState;         // slowest state considering policy restrictions
    DWORD LowestPerfState;      // slowest perf state, fixed, aka the "knee"
    DWORD ThermalConstraint;
    BYTE  BusyAdjThreshold;
    BYTE  PolicyType;           // domain coordination
    BYTE  Type;
    BYTE  Reserved;
    DWORD TimerInterval;
    DWORD64 TargetProcessors;   // domain affinity
    DWORD PStateHandler;
    DWORD PStateContext;
    DWORD TStateHandler;
    DWORD TStateContext;
    DWORD FeedbackHandler;
    DWORD Reserved1;
    DWORD64 Reserved2;
    PPM_WMI_PERF_STATE State[];
}

alias PPM_WMI_PERF_STATES* PPPM_WMI_PERF_STATES;

//
// Accounting info.
//

const auto PROC_IDLE_BUCKET_COUNT   = 6;

struct PPM_IDLE_STATE_ACCOUNTING {
    DWORD IdleTransitions;
    DWORD FailedTransitions;
    DWORD InvalidBucketIndex;
    DWORD64 TotalTime;
    DWORD IdleTimeBuckets[PROC_IDLE_BUCKET_COUNT];
}

alias PPM_IDLE_STATE_ACCOUNTING* PPPM_IDLE_STATE_ACCOUNTING;

struct PPM_IDLE_ACCOUNTING {
    DWORD StateCount;
    DWORD TotalTransitions;
    DWORD ResetCount;
    DWORD64 StartTime;
    PPM_IDLE_STATE_ACCOUNTING State[];
}

alias PPM_IDLE_ACCOUNTING* PPPM_IDLE_ACCOUNTING;

//
// Definitions of coordination types for _PSD, _TSD, and _CSD BIOS objects from
// the Acpi 3.0 specification
//

const auto ACPI_PPM_SOFTWARE_ALL      = 0xFC;
const auto ACPI_PPM_SOFTWARE_ANY      = 0xFD;
const auto ACPI_PPM_HARDWARE_ALL      = 0xFE;

//
// Definition of Microsoft PPM coordination types.
//

const auto MS_PPM_SOFTWARE_ALL        = 0x1;



//
// Processor Power Management WMI interface.
//

// {A5B32DDD-7F39-4abc-B892-900E43B59EBB}

/*
DEFINE_GUID(PPM_PERFSTATE_CHANGE_GUID,
0xa5b32ddd, 0x7f39, 0x4abc, 0xb8, 0x92, 0x90, 0xe, 0x43, 0xb5, 0x9e, 0xbb);

// {995e6b7f-d653-497a-b978-36a30c29bf01}
DEFINE_GUID(PPM_PERFSTATE_DOMAIN_CHANGE_GUID,
0x995e6b7f, 0xd653, 0x497a, 0xb9, 0x78, 0x36, 0xa3, 0xc, 0x29, 0xbf, 0x1);

// {4838fe4f-f71c-4e51-9ecc-8430a7ac4c6c}
DEFINE_GUID(PPM_IDLESTATE_CHANGE_GUID,
0x4838fe4f, 0xf71c, 0x4e51, 0x9e, 0xcc, 0x84, 0x30, 0xa7, 0xac, 0x4c, 0x6c);

// {5708cc20-7d40-4bf4-b4aa-2b01338d0126}
DEFINE_GUID(PPM_PERFSTATES_DATA_GUID,
0x5708cc20, 0x7d40, 0x4bf4, 0xb4, 0xaa, 0x2b, 0x01, 0x33, 0x8d, 0x01, 0x26);

// {ba138e10-e250-4ad7-8616-cf1a7ad410e7}
DEFINE_GUID(PPM_IDLESTATES_DATA_GUID,
0xba138e10, 0xe250, 0x4ad7, 0x86, 0x16, 0xcf, 0x1a, 0x7a, 0xd4, 0x10, 0xe7);

// {e2a26f78-ae07-4ee0-a30f-ce354f5a94cd}
DEFINE_GUID(PPM_IDLE_ACCOUNTING_GUID,
0xe2a26f78, 0xae07, 0x4ee0, 0xa3, 0x0f, 0xce, 0x54, 0xf5, 0x5a, 0x94, 0xcd);

// {a852c2c8-1a4c-423b-8c2c-f30d82931a88}
DEFINE_GUID(PPM_THERMALCONSTRAINT_GUID,
0xa852c2c8, 0x1a4c, 0x423b, 0x8c, 0x2c, 0xf3, 0x0d, 0x82, 0x93, 0x1a, 0x88);

// {7fd18652-0cfe-40d2-b0a1-0b066a87759e}
DEFINE_GUID(PPM_PERFMON_PERFSTATE_GUID,
0x7fd18652, 0xcfe, 0x40d2, 0xb0, 0xa1, 0xb, 0x6, 0x6a, 0x87, 0x75, 0x9e);

// {48f377b8-6880-4c7b-8bdc-380176c6654d}
DEFINE_GUID(PPM_THERMAL_POLICY_CHANGE_GUID,
0x48f377b8, 0x6880, 0x4c7b, 0x8b, 0xdc, 0x38, 0x1, 0x76, 0xc6, 0x65, 0x4d);
*/

struct PPM_PERFSTATE_EVENT {
    DWORD State;
    DWORD Status;
    DWORD Latency;
    DWORD Speed;
    DWORD Processor;
}

alias PPM_PERFSTATE_EVENT* PPPM_PERFSTATE_EVENT;

struct PPM_PERFSTATE_DOMAIN_EVENT {
    DWORD State;
    DWORD Latency;
    DWORD Speed;
    DWORD64 Processors;
}

alias PPM_PERFSTATE_DOMAIN_EVENT* PPPM_PERFSTATE_DOMAIN_EVENT;

struct PPM_IDLESTATE_EVENT {
    DWORD NewState;
    DWORD OldState;
    DWORD64 Processors;
}

alias PPM_IDLESTATE_EVENT* PPPM_IDLESTATE_EVENT;

struct PPM_THERMALCHANGE_EVENT {
    DWORD ThermalConstraint;
    DWORD64 Processors;
}

alias PPM_THERMALCHANGE_EVENT* PPPM_THERMALCHANGE_EVENT;

struct PPM_THERMAL_POLICY_EVENT {
    BYTE  Mode;
    DWORD64 Processors;
}

alias PPM_THERMAL_POLICY_EVENT* PPPM_THERMAL_POLICY_EVENT;

// Power Policy Management interfaces
//

struct POWER_ACTION_POLICY {
    POWER_ACTION    Action;
    DWORD           Flags;
    DWORD           EventCode;
}

alias POWER_ACTION_POLICY* PPOWER_ACTION_POLICY;

// POWER_ACTION_POLICY->Flags:
const auto POWER_ACTION_QUERY_ALLOWED       = 0x00000001;
const auto POWER_ACTION_UI_ALLOWED          = 0x00000002;
const auto POWER_ACTION_OVERRIDE_APPS       = 0x00000004;
const auto POWER_ACTION_LIGHTEST_FIRST      = 0x10000000;
const auto POWER_ACTION_LOCK_CONSOLE        = 0x20000000;
const auto POWER_ACTION_DISABLE_WAKES       = 0x40000000;
const auto POWER_ACTION_CRITICAL            = 0x80000000;

// POWER_ACTION_POLICY->EventCode flags
const auto POWER_LEVEL_USER_NOTIFY_TEXT     = 0x00000001;
const auto POWER_LEVEL_USER_NOTIFY_SOUND    = 0x00000002;
const auto POWER_LEVEL_USER_NOTIFY_EXEC     = 0x00000004;
const auto POWER_USER_NOTIFY_BUTTON         = 0x00000008;
const auto POWER_USER_NOTIFY_SHUTDOWN       = 0x00000010;
const auto POWER_FORCE_TRIGGER_RESET        = 0x80000000;

// Note: for battery alarm EventCodes, the ID of the battery alarm << 16 is ORed
// into the flags.  For example: DISCHARGE_POLICY_LOW << 16

//
// The GUID_BATTERY_DISCHARGE_FLAGS_x power settings use a subset of EventCode
// flags.  The POWER_FORCE_TRIGGER_RESET flag doesn't make sense for a battery
// alarm so it is overloaded for other purposes (gerneral enable/disable).
const auto BATTERY_DISCHARGE_FLAGS_EVENTCODE_MASK   = 0x00000007;
const auto BATTERY_DISCHARGE_FLAGS_ENABLE   = 0x80000000;

// system battery drain policies
struct SYSTEM_POWER_LEVEL {
    BOOLEAN                 Enable;
    BYTE                    Spare[3];
    DWORD                   BatteryLevel;
    POWER_ACTION_POLICY     PowerPolicy;
    SYSTEM_POWER_STATE      MinSystemState;
}

alias SYSTEM_POWER_LEVEL* PSYSTEM_POWER_LEVEL;

// Discharge policy constants
const auto NUM_DISCHARGE_POLICIES       = 4;
const auto DISCHARGE_POLICY_CRITICAL    = 0;
const auto DISCHARGE_POLICY_LOW         = 1;


// system power policies
struct SYSTEM_POWER_POLICY {
    DWORD                   Revision;       // 1

    // events
    POWER_ACTION_POLICY     PowerButton;
    POWER_ACTION_POLICY     SleepButton;
    POWER_ACTION_POLICY     LidClose;
    SYSTEM_POWER_STATE      LidOpenWake;
    DWORD                   Reserved;

    // "system idle" detection
    POWER_ACTION_POLICY     Idle;
    DWORD                   IdleTimeout;
    BYTE                    IdleSensitivity;

    BYTE                    DynamicThrottle;
    BYTE                    Spare2[2];

    // meaning of power action "sleep"
    SYSTEM_POWER_STATE      MinSleep;
    SYSTEM_POWER_STATE      MaxSleep;
    SYSTEM_POWER_STATE      ReducedLatencySleep;
    DWORD                   WinLogonFlags;

    DWORD                   Spare3;

    // parameters for dozing
    //
    DWORD                   DozeS4Timeout;

    // battery policies
    DWORD                   BroadcastCapacityResolution;
    SYSTEM_POWER_LEVEL      DischargePolicy[NUM_DISCHARGE_POLICIES];

    // video policies
    DWORD                   VideoTimeout;
    BOOLEAN                 VideoDimDisplay;
    DWORD                   VideoReserved[3];

    // hard disk policies
    DWORD                   SpindownTimeout;

    // processor policies
    BOOLEAN                 OptimizeForPower;
    BYTE                    FanThrottleTolerance;
    BYTE                    ForcedThrottle;
    BYTE                    MinThrottle;
    POWER_ACTION_POLICY     OverThrottled;

}

alias SYSTEM_POWER_POLICY* PSYSTEM_POWER_POLICY;


// processor power policy state

//
// Processor Idle State Policy.
//

const auto PROCESSOR_IDLESTATE_POLICY_COUNT  = 0x3;

struct PROCESSOR_IDLESTATE_INFO {
    DWORD TimeCheck;
    BYTE  DemotePercent;
    BYTE  PromotePercent;
    BYTE  Spare[2];
}

alias PROCESSOR_IDLESTATE_INFO* PPROCESSOR_IDLESTATE_INFO;

struct PROCESSOR_IDLESTATE_POLICY {
    WORD   Revision;
    union _inner_union {
        WORD   AsWORD  ;
        WORD AllowScaling() {
        	return AsWord & 1;
        }
        WORD Disabled() {
        	return (AsWord >> 1) & 1;
        }
        WORD Reserved() {
        	return (AsWord >> 2);
        }
    } 

	_inner_union Flags;

    DWORD PolicyCount;
    PROCESSOR_IDLESTATE_INFO Policy[PROCESSOR_IDLESTATE_POLICY_COUNT];
}

alias PROCESSOR_IDLESTATE_POLICY* PPROCESSOR_IDLESTATE_POLICY;

//
// Legacy Processor Policy.  This is only provided to allow legacy 
// applications to compile.  New applications must use 
// PROCESSOR_IDLESTATE_POLICY.
//

const auto PO_THROTTLE_NONE             = 0;
const auto PO_THROTTLE_CONSTANT         = 1;
const auto PO_THROTTLE_DEGRADE          = 2;
const auto PO_THROTTLE_ADAPTIVE         = 3;
const auto PO_THROTTLE_MAXIMUM          = 4   ; // not a policy, just a limit


struct PROCESSOR_POWER_POLICY_INFO {

    // Time based information (will be converted to kernel units)
    DWORD                   TimeCheck;                      // in US
    DWORD                   DemoteLimit;                    // in US
    DWORD                   PromoteLimit;                   // in US

    // Percentage based information
    BYTE                    DemotePercent;
    BYTE                    PromotePercent;
    BYTE[2]                    Spare;

    // Flags
    DWORD flags;
    
	DWORD AllowDemotion() {
    	return flags & 1;
    }

    DWORD AllowPromotion() {
    	return (flags >> 1) & 1;
    }
    
    DWORD Reserved() {
    	return (flags >> 2);
    }
}

alias PROCESSOR_POWER_POLICY_INFO* PPROCESSOR_POWER_POLICY_INFO;

// processor power policy
struct PROCESSOR_POWER_POLICY {
    DWORD                       Revision;       // 1

    // Dynamic Throttling Policy
    BYTE                        DynamicThrottle;
    BYTE[3]                        Spare;

    // Flags
    DWORD flags;
    
    DWORD DisableCStates() {
    	return flags & 1;
    }
    
    DWORD Reserved() {
    	return flags >> 1;
    }

    // System policy information
    // The Array is last, in case it needs to be grown and the structure
    // revision incremented.
    DWORD                       PolicyCount;
    PROCESSOR_POWER_POLICY_INFO[3] Policy;

}

alias PROCESSOR_POWER_POLICY* PPROCESSOR_POWER_POLICY;

//
// Processor Perf State Policy.
//

const auto PERFSTATE_POLICY_CHANGE_IDEAL   = 0x00;
const auto PERFSTATE_POLICY_CHANGE_SINGLE  = 0x01;
const auto PERFSTATE_POLICY_CHANGE_ROCKET  = 0x02;
const auto PERFSTATE_POLICY_CHANGE_MAX  = PERFSTATE_POLICY_CHANGE_ROCKET;

struct PROCESSOR_PERFSTATE_POLICY {
    DWORD Revision;
    BYTE  MaxThrottle;
    BYTE  MinThrottle;
    BYTE  BusyAdjThreshold;
    union _inner_union {
        BYTE  Spare;
        union _inner_inner_union {
            BYTE  AsBYTE ;
            
            BYTE NoDomainAccounting() {
            	return AsBYTE & 1;
            }
            
            BYTE IncreasePolicy() {
            	return (AsBYTE >> 1) & 0x3;
            }

            BYTE DecreasePolicy() {
            	return (AsBYTE >> 3) & 0x3;
            }
            
            BYTE Reserved() {
            	return AsBYTE >> 5;
            }
        }
		_inner_inner_union Flags;
    }

    _inner_union fields;

    DWORD TimeCheck;
    DWORD IncreaseTime;
    DWORD DecreaseTime;
    DWORD IncreasePercent;
    DWORD DecreasePercent;
}

alias PROCESSOR_PERFSTATE_POLICY* PPROCESSOR_PERFSTATE_POLICY;

// administrator power policy overrides
struct ADMINISTRATOR_POWER_POLICY {

    // meaning of power action "sleep"
    SYSTEM_POWER_STATE      MinSleep;
    SYSTEM_POWER_STATE      MaxSleep;

    // video policies
    DWORD                   MinVideoTimeout;
    DWORD                   MaxVideoTimeout;

    // disk policies
    DWORD                   MinSpindownTimeout;
    DWORD                   MaxSpindownTimeout;
}

alias ADMINISTRATOR_POWER_POLICY* PADMINISTRATOR_POWER_POLICY;




struct SYSTEM_POWER_CAPABILITIES {
    // Misc supported system features
    BOOLEAN             PowerButtonPresent;
    BOOLEAN             SleepButtonPresent;
    BOOLEAN             LidPresent;
    BOOLEAN             SystemS1;
    BOOLEAN             SystemS2;
    BOOLEAN             SystemS3;
    BOOLEAN             SystemS4;           // hibernate
    BOOLEAN             SystemS5;           // off
    BOOLEAN             HiberFilePresent;
    BOOLEAN             FullWake;
    BOOLEAN             VideoDimPresent;
    BOOLEAN             ApmPresent;
    BOOLEAN             UpsPresent;

    // Processors
    BOOLEAN             ThermalControl;
    BOOLEAN             ProcessorThrottle;
    BYTE                ProcessorMinThrottle;

    BYTE                ProcessorMaxThrottle;
    BOOLEAN             FastSystemS4;
    BYTE                spare2[3];

    // Disk
    BOOLEAN             DiskSpinDown;
    BYTE                spare3[8];

    // System Battery
    BOOLEAN             SystemBatteriesPresent;
    BOOLEAN             BatteriesAreShortTerm;
    BATTERY_REPORTING_SCALE BatteryScale[3];

    // Wake
    SYSTEM_POWER_STATE  AcOnLineWake;
    SYSTEM_POWER_STATE  SoftLidWake;
    SYSTEM_POWER_STATE  RtcWake;
    SYSTEM_POWER_STATE  MinDeviceWakeState; // note this may change on driver load
    SYSTEM_POWER_STATE  DefaultLowLatencyWake;
}

alias SYSTEM_POWER_CAPABILITIES* PSYSTEM_POWER_CAPABILITIES;

struct SYSTEM_BATTERY_STATE {
    BOOLEAN             AcOnLine;
    BOOLEAN             BatteryPresent;
    BOOLEAN             Charging;
    BOOLEAN             Discharging;
    BOOLEAN             Spare1[4];

    DWORD               MaxCapacity;
    DWORD               RemainingCapacity;
    DWORD               Rate;
    DWORD               EstimatedTime;

    DWORD               DefaultAlert1;
    DWORD               DefaultAlert2;
}

alias SYSTEM_BATTERY_STATE* PSYSTEM_BATTERY_STATE;



//
// Image Format
//


const auto IMAGE_DOS_SIGNATURE                  = 0x5A4D      ; // MZ
const auto IMAGE_OS2_SIGNATURE                  = 0x454E      ; // NE
const auto IMAGE_OS2_SIGNATURE_LE               = 0x454C      ; // LE
const auto IMAGE_VXD_SIGNATURE                  = 0x454C      ; // LE
const auto IMAGE_NT_SIGNATURE                   = 0x00004550  ; // PE00

align(2) struct IMAGE_DOS_HEADER {      // DOS .EXE header
    WORD   e_magic;                     // Magic number
    WORD   e_cblp;                      // Bytes on last page of file
    WORD   e_cp;                        // Pages in file
    WORD   e_crlc;                      // Relocations
    WORD   e_cparhdr;                   // Size of header in paragraphs
    WORD   e_minalloc;                  // Minimum extra paragraphs needed
    WORD   e_maxalloc;                  // Maximum extra paragraphs needed
    WORD   e_ss;                        // Initial (relative) SS value
    WORD   e_sp;                        // Initial SP value
    WORD   e_csum;                      // Checksum
    WORD   e_ip;                        // Initial IP value
    WORD   e_cs;                        // Initial (relative) CS value
    WORD   e_lfarlc;                    // File address of relocation table
    WORD   e_ovno;                      // Overlay number
    WORD   e_res[4];                    // Reserved words
    WORD   e_oemid;                     // OEM identifier (for e_oeminfo)
    WORD   e_oeminfo;                   // OEM information; e_oemid specific
    WORD   e_res2[10];                  // Reserved words
    LONG   e_lfanew;                    // File address of new exe header
  }

alias IMAGE_DOS_HEADER* PIMAGE_DOS_HEADER;

align(2) struct IMAGE_OS2_HEADER {      // OS/2 .EXE header
    WORD   ne_magic;                    // Magic number
    CHAR   ne_ver;                      // Version number
    CHAR   ne_rev;                      // Revision number
    WORD   ne_enttab;                   // Offset of Entry Table
    WORD   ne_cbenttab;                 // Number of bytes in Entry Table
    LONG   ne_crc;                      // Checksum of whole file
    WORD   ne_flags;                    // Flag word
    WORD   ne_autodata;                 // Automatic data segment number
    WORD   ne_heap;                     // Initial heap allocation
    WORD   ne_stack;                    // Initial stack allocation
    LONG   ne_csip;                     // Initial CS:IP setting
    LONG   ne_sssp;                     // Initial SS:SP setting
    WORD   ne_cseg;                     // Count of file segments
    WORD   ne_cmod;                     // Entries in Module Reference Table
    WORD   ne_cbnrestab;                // Size of non-resident name table
    WORD   ne_segtab;                   // Offset of Segment Table
    WORD   ne_rsrctab;                  // Offset of Resource Table
    WORD   ne_restab;                   // Offset of resident name table
    WORD   ne_modtab;                   // Offset of Module Reference Table
    WORD   ne_imptab;                   // Offset of Imported Names Table
    LONG   ne_nrestab;                  // Offset of Non-resident Names Table
    WORD   ne_cmovent;                  // Count of movable entries
    WORD   ne_align;                    // Segment alignment shift count
    WORD   ne_cres;                     // Count of resource segments
    BYTE   ne_exetyp;                   // Target Operating system
    BYTE   ne_flagsothers;              // Other .EXE flags
    WORD   ne_pretthunks;               // offset to return thunks
    WORD   ne_psegrefbytes;             // offset to segment ref. bytes
    WORD   ne_swaparea;                 // Minimum code swap area size
    WORD   ne_expver;                   // Expected Windows version number
  }

alias IMAGE_OS2_HEADER* PIMAGE_OS2_HEADER;

align(2) struct IMAGE_VXD_HEADER {      // Windows VXD header
    WORD   e32_magic;                   // Magic number
    BYTE   e32_border;                  // The byte ordering for the VXD
    BYTE   e32_worder;                  // The word ordering for the VXD
    DWORD  e32_level;                   // The EXE format level for now = 0
    WORD   e32_cpu;                     // The CPU type
    WORD   e32_os;                      // The OS type
    DWORD  e32_ver;                     // Module version
    DWORD  e32_mflags;                  // Module flags
    DWORD  e32_mpages;                  // Module # pages
    DWORD  e32_startobj;                // Object # for instruction pointer
    DWORD  e32_eip;                     // Extended instruction pointer
    DWORD  e32_stackobj;                // Object # for stack pointer
    DWORD  e32_esp;                     // Extended stack pointer
    DWORD  e32_pagesize;                // VXD page size
    DWORD  e32_lastpagesize;            // Last page size in VXD
    DWORD  e32_fixupsize;               // Fixup section size
    DWORD  e32_fixupsum;                // Fixup section checksum
    DWORD  e32_ldrsize;                 // Loader section size
    DWORD  e32_ldrsum;                  // Loader section checksum
    DWORD  e32_objtab;                  // Object table offset
    DWORD  e32_objcnt;                  // Number of objects in module
    DWORD  e32_objmap;                  // Object page map offset
    DWORD  e32_itermap;                 // Object iterated data map offset
    DWORD  e32_rsrctab;                 // Offset of Resource Table
    DWORD  e32_rsrccnt;                 // Number of resource entries
    DWORD  e32_restab;                  // Offset of resident name table
    DWORD  e32_enttab;                  // Offset of Entry Table
    DWORD  e32_dirtab;                  // Offset of Module Directive Table
    DWORD  e32_dircnt;                  // Number of module directives
    DWORD  e32_fpagetab;                // Offset of Fixup Page Table
    DWORD  e32_frectab;                 // Offset of Fixup Record Table
    DWORD  e32_impmod;                  // Offset of Import Module Name Table
    DWORD  e32_impmodcnt;               // Number of entries in Import Module Name Table
    DWORD  e32_impproc;                 // Offset of Import Procedure Name Table
    DWORD  e32_pagesum;                 // Offset of Per-Page Checksum Table
    DWORD  e32_datapage;                // Offset of Enumerated Data Pages
    DWORD  e32_preload;                 // Number of preload pages
    DWORD  e32_nrestab;                 // Offset of Non-resident Names Table
    DWORD  e32_cbnrestab;               // Size of Non-resident Name Table
    DWORD  e32_nressum;                 // Non-resident Name Table Checksum
    DWORD  e32_autodata;                // Object # for automatic data object
    DWORD  e32_debuginfo;               // Offset of the debugging information
    DWORD  e32_debuglen;                // The length of the debugging info. in bytes
    DWORD  e32_instpreload;             // Number of instance pages in preload section of VXD file
    DWORD  e32_instdemand;              // Number of instance pages in demand load section of VXD file
    DWORD  e32_heapsize;                // Size of heap - for 16-bit apps
    BYTE   e32_res3[12];                // Reserved words
    DWORD  e32_winresoff;
    DWORD  e32_winreslen;
    WORD   e32_devid;                   // Device ID for VxD
    WORD   e32_ddkver;                  // DDK version for VxD
  }

alias IMAGE_VXD_HEADER* PIMAGE_VXD_HEADER;


//
// File header format.
//

align(2) struct IMAGE_FILE_HEADER {
    WORD    Machine;
    WORD    NumberOfSections;
    DWORD   TimeDateStamp;
    DWORD   PointerToSymbolTable;
    DWORD   NumberOfSymbols;
    WORD    SizeOfOptionalHeader;
    WORD    Characteristics;
}

alias IMAGE_FILE_HEADER* PIMAGE_FILE_HEADER;

const auto IMAGE_SIZEOF_FILE_HEADER              = 20;

const auto IMAGE_FILE_RELOCS_STRIPPED            = 0x0001  ; // Relocation info stripped from file.
const auto IMAGE_FILE_EXECUTABLE_IMAGE           = 0x0002  ; // File is executable  (i.e. no unresolved externel references).
const auto IMAGE_FILE_LINE_NUMS_STRIPPED         = 0x0004  ; // Line nunbers stripped from file.
const auto IMAGE_FILE_LOCAL_SYMS_STRIPPED        = 0x0008  ; // Local symbols stripped from file.
const auto IMAGE_FILE_AGGRESIVE_WS_TRIM          = 0x0010  ; // Agressively trim working set
const auto IMAGE_FILE_LARGE_ADDRESS_AWARE        = 0x0020  ; // App can handle >2gb addresses
const auto IMAGE_FILE_BYTES_REVERSED_LO          = 0x0080  ; // Bytes of machine word are reversed.
const auto IMAGE_FILE_32BIT_MACHINE              = 0x0100  ; // 32 bit word machine.
const auto IMAGE_FILE_DEBUG_STRIPPED             = 0x0200  ; // Debugging info stripped from file in .DBG file
const auto IMAGE_FILE_REMOVABLE_RUN_FROM_SWAP    = 0x0400  ; // If Image is on removable media, copy and run from the swap file.
const auto IMAGE_FILE_NET_RUN_FROM_SWAP          = 0x0800  ; // If Image is on Net, copy and run from the swap file.
const auto IMAGE_FILE_SYSTEM                     = 0x1000  ; // System File.
const auto IMAGE_FILE_DLL                        = 0x2000  ; // File is a DLL.
const auto IMAGE_FILE_UP_SYSTEM_ONLY             = 0x4000  ; // File should only be run on a UP machine
const auto IMAGE_FILE_BYTES_REVERSED_HI          = 0x8000  ; // Bytes of machine word are reversed.

const auto IMAGE_FILE_MACHINE_UNKNOWN            = 0;
const auto IMAGE_FILE_MACHINE_I386               = 0x014c  ; // Intel 386.
const auto IMAGE_FILE_MACHINE_R3000              = 0x0162  ; // MIPS little-endian, 0x160 big-endian
const auto IMAGE_FILE_MACHINE_R4000              = 0x0166  ; // MIPS little-endian
const auto IMAGE_FILE_MACHINE_R10000             = 0x0168  ; // MIPS little-endian
const auto IMAGE_FILE_MACHINE_WCEMIPSV2          = 0x0169  ; // MIPS little-endian WCE v2
const auto IMAGE_FILE_MACHINE_ALPHA              = 0x0184  ; // Alpha_AXP
const auto IMAGE_FILE_MACHINE_SH3                = 0x01a2  ; // SH3 little-endian
const auto IMAGE_FILE_MACHINE_SH3DSP             = 0x01a3;
const auto IMAGE_FILE_MACHINE_SH3E               = 0x01a4  ; // SH3E little-endian
const auto IMAGE_FILE_MACHINE_SH4                = 0x01a6  ; // SH4 little-endian
const auto IMAGE_FILE_MACHINE_SH5                = 0x01a8  ; // SH5
const auto IMAGE_FILE_MACHINE_ARM                = 0x01c0  ; // ARM Little-Endian
const auto IMAGE_FILE_MACHINE_THUMB              = 0x01c2;
const auto IMAGE_FILE_MACHINE_AM33               = 0x01d3;
const auto IMAGE_FILE_MACHINE_POWERPC            = 0x01F0  ; // IBM PowerPC Little-Endian
const auto IMAGE_FILE_MACHINE_POWERPCFP          = 0x01f1;
const auto IMAGE_FILE_MACHINE_IA64               = 0x0200  ; // Intel 64
const auto IMAGE_FILE_MACHINE_MIPS16             = 0x0266  ; // MIPS
const auto IMAGE_FILE_MACHINE_ALPHA64            = 0x0284  ; // ALPHA64
const auto IMAGE_FILE_MACHINE_MIPSFPU            = 0x0366  ; // MIPS
const auto IMAGE_FILE_MACHINE_MIPSFPU16          = 0x0466  ; // MIPS
const auto IMAGE_FILE_MACHINE_AXP64              = IMAGE_FILE_MACHINE_ALPHA64;
const auto IMAGE_FILE_MACHINE_TRICORE            = 0x0520  ; // Infineon
const auto IMAGE_FILE_MACHINE_CEF                = 0x0CEF;
const auto IMAGE_FILE_MACHINE_EBC                = 0x0EBC  ; // EFI Byte Code
const auto IMAGE_FILE_MACHINE_AMD64              = 0x8664  ; // AMD64 (K8)
const auto IMAGE_FILE_MACHINE_M32R               = 0x9041  ; // M32R little-endian
const auto IMAGE_FILE_MACHINE_CEE                = 0xC0EE;

//
// Directory format.
//

align(2) struct IMAGE_DATA_DIRECTORY {
    DWORD   VirtualAddress;
    DWORD   Size;
}

alias IMAGE_DATA_DIRECTORY* PIMAGE_DATA_DIRECTORY;

const auto IMAGE_NUMBEROF_DIRECTORY_ENTRIES     = 16;

//
// Optional header format.
//

align(2) struct IMAGE__HEADER32 {
    //
    // Standard fields.
    //

    WORD    Magic;
    BYTE    MajorLinkerVersion;
    BYTE    MinorLinkerVersion;
    DWORD   SizeOfCode;
    DWORD   SizeOfInitializedData;
    DWORD   SizeOfUninitializedData;
    DWORD   AddressOfEntryPoint;
    DWORD   BaseOfCode;
    DWORD   BaseOfData;

    //
    // NT additional fields.
    //

    DWORD   ImageBase;
    DWORD   SectionAlignment;
    DWORD   FileAlignment;
    WORD    MajorOperatingSystemVersion;
    WORD    MinorOperatingSystemVersion;
    WORD    MajorImageVersion;
    WORD    MinorImageVersion;
    WORD    MajorSubsystemVersion;
    WORD    MinorSubsystemVersion;
    DWORD   Win32VersionValue;
    DWORD   SizeOfImage;
    DWORD   SizeOfHeaders;
    DWORD   CheckSum;
    WORD    Subsystem;
    WORD    DllCharacteristics;
    DWORD   SizeOfStackReserve;
    DWORD   SizeOfStackCommit;
    DWORD   SizeOfHeapReserve;
    DWORD   SizeOfHeapCommit;
    DWORD   LoaderFlags;
    DWORD   NumberOfRvaAndSizes;
    IMAGE_DATA_DIRECTORY DataDirectory[IMAGE_NUMBEROF_DIRECTORY_ENTRIES];
}

alias IMAGE__HEADER32* PIMAGE__HEADER32;

align(2) struct IMAGE_ROM__HEADER {
    WORD   Magic;
    BYTE   MajorLinkerVersion;
    BYTE   MinorLinkerVersion;
    DWORD  SizeOfCode;
    DWORD  SizeOfInitializedData;
    DWORD  SizeOfUninitializedData;
    DWORD  AddressOfEntryPoint;
    DWORD  BaseOfCode;
    DWORD  BaseOfData;
    DWORD  BaseOfBss;
    DWORD  GprMask;
    DWORD  CprMask[4];
    DWORD  GpValue;
}

alias IMAGE_ROM__HEADER* PIMAGE_ROM__HEADER;

struct IMAGE__HEADER64 {
    WORD        Magic;
    BYTE        MajorLinkerVersion;
    BYTE        MinorLinkerVersion;
    DWORD       SizeOfCode;
    DWORD       SizeOfInitializedData;
    DWORD       SizeOfUninitializedData;
    DWORD       AddressOfEntryPoint;
    DWORD       BaseOfCode;
    ULONGLONG   ImageBase;
    DWORD       SectionAlignment;
    DWORD       FileAlignment;
    WORD        MajorOperatingSystemVersion;
    WORD        MinorOperatingSystemVersion;
    WORD        MajorImageVersion;
    WORD        MinorImageVersion;
    WORD        MajorSubsystemVersion;
    WORD        MinorSubsystemVersion;
    DWORD       Win32VersionValue;
    DWORD       SizeOfImage;
    DWORD       SizeOfHeaders;
    DWORD       CheckSum;
    WORD        Subsystem;
    WORD        DllCharacteristics;
    ULONGLONG   SizeOfStackReserve;
    ULONGLONG   SizeOfStackCommit;
    ULONGLONG   SizeOfHeapReserve;
    ULONGLONG   SizeOfHeapCommit;
    DWORD       LoaderFlags;
    DWORD       NumberOfRvaAndSizes;
    IMAGE_DATA_DIRECTORY DataDirectory[IMAGE_NUMBEROF_DIRECTORY_ENTRIES];
}

alias IMAGE__HEADER64* PIMAGE__HEADER64;

const auto IMAGE_NT__HDR32_MAGIC       = 0x10b;
const auto IMAGE_NT__HDR64_MAGIC       = 0x20b;
const auto IMAGE_ROM__HDR_MAGIC        = 0x107;

version(X86_64) {
	alias IMAGE__HEADER64             IMAGE__HEADER;
	alias PIMAGE__HEADER64            PIMAGE__HEADER;
	const auto IMAGE_NT__HDR_MAGIC          = IMAGE_NT__HDR64_MAGIC;
}
else {
	alias IMAGE__HEADER32             IMAGE__HEADER;
	alias PIMAGE__HEADER32            PIMAGE__HEADER;
	const auto IMAGE_NT__HDR_MAGIC          = IMAGE_NT__HDR32_MAGIC;
}

struct IMAGE_NT_HEADERS64 {
    DWORD Signature;
    IMAGE_FILE_HEADER FileHeader;
    IMAGE__HEADER64 OptionalHeader;
}

alias IMAGE_NT_HEADERS64* PIMAGE_NT_HEADERS64;

struct IMAGE_NT_HEADERS32 {
    DWORD Signature;
    IMAGE_FILE_HEADER FileHeader;
    IMAGE__HEADER32 OptionalHeader;
}

alias IMAGE_NT_HEADERS32* PIMAGE_NT_HEADERS32;

struct IMAGE_ROM_HEADERS {
    IMAGE_FILE_HEADER FileHeader;
    IMAGE_ROM__HEADER OptionalHeader;
}

alias IMAGE_ROM_HEADERS* PIMAGE_ROM_HEADERS;

version(X86_64) {
	alias IMAGE_NT_HEADERS64                  IMAGE_NT_HEADERS;
	alias PIMAGE_NT_HEADERS64                 PIMAGE_NT_HEADERS;
}
else {
	alias IMAGE_NT_HEADERS32                  IMAGE_NT_HEADERS;
	alias PIMAGE_NT_HEADERS32                 PIMAGE_NT_HEADERS;
}

// Subsystem Values

const auto IMAGE_SUBSYSTEM_UNKNOWN               = 0   ; // Unknown subsystem.
const auto IMAGE_SUBSYSTEM_NATIVE                = 1   ; // Image doesn't require a subsystem.
const auto IMAGE_SUBSYSTEM_WINDOWS_GUI           = 2   ; // Image runs in the Windows GUI subsystem.
const auto IMAGE_SUBSYSTEM_WINDOWS_CUI           = 3   ; // Image runs in the Windows character subsystem.
const auto IMAGE_SUBSYSTEM_OS2_CUI               = 5   ; // image runs in the OS/2 character subsystem.
const auto IMAGE_SUBSYSTEM_POSIX_CUI             = 7   ; // image runs in the Posix character subsystem.
const auto IMAGE_SUBSYSTEM_NATIVE_WINDOWS        = 8   ; // image is a native Win9x driver.
const auto IMAGE_SUBSYSTEM_WINDOWS_CE_GUI        = 9   ; // Image runs in the Windows CE subsystem.
const auto IMAGE_SUBSYSTEM_EFI_APPLICATION       = 10  ; //
const auto IMAGE_SUBSYSTEM_EFI_BOOT_SERVICE_DRIVER   = 11   ; //
const auto IMAGE_SUBSYSTEM_EFI_RUNTIME_DRIVER    = 12  ; //
const auto IMAGE_SUBSYSTEM_EFI_ROM               = 13;
const auto IMAGE_SUBSYSTEM_XBOX                  = 14;
const auto IMAGE_SUBSYSTEM_WINDOWS_BOOT_APPLICATION  = 16;

// DllCharacteristics Entries

//      IMAGE_LIBRARY_PROCESS_INIT            0x0001     // Reserved.
//      IMAGE_LIBRARY_PROCESS_TERM            0x0002     // Reserved.
//      IMAGE_LIBRARY_THREAD_INIT             0x0004     // Reserved.
//      IMAGE_LIBRARY_THREAD_TERM             0x0008     // Reserved.
const auto IMAGE_DLLCHARACTERISTICS_DYNAMIC_BASE  = 0x0040     ; // DLL can move.
const auto IMAGE_DLLCHARACTERISTICS_FORCE_INTEGRITY     = 0x0080     ; // Code Integrity Image
const auto IMAGE_DLLCHARACTERISTICS_NX_COMPAT     = 0x0100     ; // Image is NX compatible
const auto IMAGE_DLLCHARACTERISTICS_NO_ISOLATION  = 0x0200     ; // Image understands isolation and doesn't want it
const auto IMAGE_DLLCHARACTERISTICS_NO_SEH        = 0x0400     ; // Image does not use SEH.  No SE handler may reside in this image
const auto IMAGE_DLLCHARACTERISTICS_NO_BIND       = 0x0800     ; // Do not bind this image.
//                                            0x1000     // Reserved.
const auto IMAGE_DLLCHARACTERISTICS_WDM_DRIVER    = 0x2000     ; // Driver uses WDM model
//                                            0x4000     // Reserved.
const auto IMAGE_DLLCHARACTERISTICS_TERMINAL_SERVER_AWARE      = 0x8000;

// Directory Entries

const auto IMAGE_DIRECTORY_ENTRY_EXPORT           = 0   ; // Export Directory
const auto IMAGE_DIRECTORY_ENTRY_IMPORT           = 1   ; // Import Directory
const auto IMAGE_DIRECTORY_ENTRY_RESOURCE         = 2   ; // Resource Directory
const auto IMAGE_DIRECTORY_ENTRY_EXCEPTION        = 3   ; // Exception Directory
const auto IMAGE_DIRECTORY_ENTRY_SECURITY         = 4   ; // Security Directory
const auto IMAGE_DIRECTORY_ENTRY_BASERELOC        = 5   ; // Base Relocation Table
const auto IMAGE_DIRECTORY_ENTRY_DEBUG            = 6   ; // Debug Directory
//      IMAGE_DIRECTORY_ENTRY_COPYRIGHT       7   // (X86 usage)
const auto IMAGE_DIRECTORY_ENTRY_ARCHITECTURE     = 7   ; // Architecture Specific Data
const auto IMAGE_DIRECTORY_ENTRY_GLOBALPTR        = 8   ; // RVA of GP
const auto IMAGE_DIRECTORY_ENTRY_TLS              = 9   ; // TLS Directory
const auto IMAGE_DIRECTORY_ENTRY_LOAD_CONFIG     = 10   ; // Load Configuration Directory
const auto IMAGE_DIRECTORY_ENTRY_BOUND_IMPORT    = 11   ; // Bound Import Directory in headers
const auto IMAGE_DIRECTORY_ENTRY_IAT             = 12   ; // Import Address Table
const auto IMAGE_DIRECTORY_ENTRY_DELAY_IMPORT    = 13   ; // Delay Load Import Descriptors
const auto IMAGE_DIRECTORY_ENTRY_COM_DESCRIPTOR  = 14   ; // COM Runtime descriptor

//
// Non-COFF Object file header
//

struct ANON_OBJECT_HEADER {
    WORD    Sig1;            // Must be IMAGE_FILE_MACHINE_UNKNOWN
    WORD    Sig2;            // Must be 0xffff
    WORD    Version;         // >= 1 (implies the CLSID field is present)
    WORD    Machine;
    DWORD   TimeDateStamp;
    CLSID   ClassID;         // Used to invoke CoCreateInstance
    DWORD   SizeOfData;      // Size of data that follows the header
}


struct ANON_OBJECT_HEADER_V2 {
    WORD    Sig1;            // Must be IMAGE_FILE_MACHINE_UNKNOWN
    WORD    Sig2;            // Must be 0xffff
    WORD    Version;         // >= 2 (implies the Flags field is present - otherwise V1)
    WORD    Machine;
    DWORD   TimeDateStamp;
    CLSID   ClassID;         // Used to invoke CoCreateInstance
    DWORD   SizeOfData;      // Size of data that follows the header
    DWORD   Flags;           // 0x1 -> contains metadata
    DWORD   MetaDataSize;    // Size of CLR metadata
    DWORD   MetaDataOffset;  // Offset of CLR metadata
}

//
// Section header format.
//

const auto IMAGE_SIZEOF_SHORT_NAME               = 8;

struct IMAGE_SECTION_HEADER {
    BYTE    Name[IMAGE_SIZEOF_SHORT_NAME];
    union _inner_union {
            DWORD   PhysicalAddress;
            DWORD   VirtualSize;
    }
    _inner_union Misc;

    DWORD   VirtualAddress;
    DWORD   SizeOfRawData;
    DWORD   PointerToRawData;
    DWORD   PointerToRelocations;
    DWORD   PointerToLinenumbers;
    WORD    NumberOfRelocations;
    WORD    NumberOfLinenumbers;
    DWORD   Characteristics;
}

alias IMAGE_SECTION_HEADER* PIMAGE_SECTION_HEADER;

const auto IMAGE_SIZEOF_SECTION_HEADER           = 40;

//
// Section characteristics.
//
//      IMAGE_SCN_TYPE_REG                   0x00000000  // Reserved.
//      IMAGE_SCN_TYPE_DSECT                 0x00000001  // Reserved.
//      IMAGE_SCN_TYPE_NOLOAD                0x00000002  // Reserved.
//      IMAGE_SCN_TYPE_GROUP                 0x00000004  // Reserved.
const auto IMAGE_SCN_TYPE_NO_PAD                 = 0x00000008  ; // Reserved.
//      IMAGE_SCN_TYPE_COPY                  0x00000010  // Reserved.

const auto IMAGE_SCN_CNT_CODE                    = 0x00000020  ; // Section contains code.
const auto IMAGE_SCN_CNT_INITIALIZED_DATA        = 0x00000040  ; // Section contains initialized data.
const auto IMAGE_SCN_CNT_UNINITIALIZED_DATA      = 0x00000080  ; // Section contains uninitialized data.

const auto IMAGE_SCN_LNK_OTHER                   = 0x00000100  ; // Reserved.
const auto IMAGE_SCN_LNK_INFO                    = 0x00000200  ; // Section contains comments or some other type of information.
//      IMAGE_SCN_TYPE_OVER                  0x00000400  // Reserved.
const auto IMAGE_SCN_LNK_REMOVE                  = 0x00000800  ; // Section contents will not become part of image.
const auto IMAGE_SCN_LNK_COMDAT                  = 0x00001000  ; // Section contents comdat.
//                                           0x00002000  // Reserved.
//      IMAGE_SCN_MEM_PROTECTED - Obsolete   0x00004000
const auto IMAGE_SCN_NO_DEFER_SPEC_EXC           = 0x00004000  ; // Reset speculative exceptions handling bits in the TLB entries for this section.
const auto IMAGE_SCN_GPREL                       = 0x00008000  ; // Section content can be accessed relative to GP
const auto IMAGE_SCN_MEM_FARDATA                 = 0x00008000;
//      IMAGE_SCN_MEM_SYSHEAP  - Obsolete    0x00010000
const auto IMAGE_SCN_MEM_PURGEABLE               = 0x00020000;
const auto IMAGE_SCN_MEM_16BIT                   = 0x00020000;
const auto IMAGE_SCN_MEM_LOCKED                  = 0x00040000;
const auto IMAGE_SCN_MEM_PRELOAD                 = 0x00080000;

const auto IMAGE_SCN_ALIGN_1BYTES                = 0x00100000  ; //
const auto IMAGE_SCN_ALIGN_2BYTES                = 0x00200000  ; //
const auto IMAGE_SCN_ALIGN_4BYTES                = 0x00300000  ; //
const auto IMAGE_SCN_ALIGN_8BYTES                = 0x00400000  ; //
const auto IMAGE_SCN_ALIGN_16BYTES               = 0x00500000  ; // Default alignment if no others are specified.
const auto IMAGE_SCN_ALIGN_32BYTES               = 0x00600000  ; //
const auto IMAGE_SCN_ALIGN_64BYTES               = 0x00700000  ; //
const auto IMAGE_SCN_ALIGN_128BYTES              = 0x00800000  ; //
const auto IMAGE_SCN_ALIGN_256BYTES              = 0x00900000  ; //
const auto IMAGE_SCN_ALIGN_512BYTES              = 0x00A00000  ; //
const auto IMAGE_SCN_ALIGN_1024BYTES             = 0x00B00000  ; //
const auto IMAGE_SCN_ALIGN_2048BYTES             = 0x00C00000  ; //
const auto IMAGE_SCN_ALIGN_4096BYTES             = 0x00D00000  ; //
const auto IMAGE_SCN_ALIGN_8192BYTES             = 0x00E00000  ; //
// Unused                                    0x00F00000
const auto IMAGE_SCN_ALIGN_MASK                  = 0x00F00000;

const auto IMAGE_SCN_LNK_NRELOC_OVFL             = 0x01000000  ; // Section contains extended relocations.
const auto IMAGE_SCN_MEM_DISCARDABLE             = 0x02000000  ; // Section can be discarded.
const auto IMAGE_SCN_MEM_NOT_CACHED              = 0x04000000  ; // Section is not cachable.
const auto IMAGE_SCN_MEM_NOT_PAGED               = 0x08000000  ; // Section is not pageable.
const auto IMAGE_SCN_MEM_SHARED                  = 0x10000000  ; // Section is shareable.
const auto IMAGE_SCN_MEM_EXECUTE                 = 0x20000000  ; // Section is executable.
const auto IMAGE_SCN_MEM_READ                    = 0x40000000  ; // Section is readable.
const auto IMAGE_SCN_MEM_WRITE                   = 0x80000000  ; // Section is writeable.

//
// TLS Chaacteristic Flags
//
const auto IMAGE_SCN_SCALE_INDEX                 = 0x00000001  ; // Tls index is scaled

//
// Symbol format.
//

align(2) struct IMAGE_SYMBOL {
    union _inner_union {
        BYTE[8]    ShortName;
        struct _inner_struct {
            DWORD   Short;     // if 0, use LongName
            DWORD   Long;      // offset into string table
        }
        _inner_struct Name;
        DWORD[2]   LongName;    // PBYTE [2]
    }
    _inner_union N;
    DWORD   Value;
    SHORT   SectionNumber;
    WORD    Type;
    BYTE    StorageClass;
    BYTE    NumberOfAuxSymbols;
}

alias IMAGE_SYMBOL *PIMAGE_SYMBOL;


const auto IMAGE_SIZEOF_SYMBOL                   = 18;

//
// Section values.
//
// Symbols have a section number of the section in which they are
// defined. Otherwise, section numbers have the following meanings:
//

const auto IMAGE_SYM_UNDEFINED            = cast(SHORT)0          ; // Symbol is undefined or is common.
const auto IMAGE_SYM_ABSOLUTE             = cast(SHORT)-1         ; // Symbol is an absolute value.
const auto IMAGE_SYM_DEBUG                = cast(SHORT)-2         ; // Symbol is a special debug item.
const auto IMAGE_SYM_SECTION_MAX          = 0xFEFF            ; // Values 0xFF00-0xFFFF are special

//
// Type (fundamental) values.
//

const auto IMAGE_SYM_TYPE_NULL                  = 0x0000  ; // no type.
const auto IMAGE_SYM_TYPE_VOID                  = 0x0001  ; //
const auto IMAGE_SYM_TYPE_CHAR                  = 0x0002  ; // type character.
const auto IMAGE_SYM_TYPE_SHORT                 = 0x0003  ; // type short integer.
const auto IMAGE_SYM_TYPE_INT                   = 0x0004  ; //
const auto IMAGE_SYM_TYPE_LONG                  = 0x0005  ; //
const auto IMAGE_SYM_TYPE_FLOAT                 = 0x0006  ; //
const auto IMAGE_SYM_TYPE_DOUBLE                = 0x0007  ; //
const auto IMAGE_SYM_TYPE_STRUCT                = 0x0008  ; //
const auto IMAGE_SYM_TYPE_UNION                 = 0x0009  ; //
const auto IMAGE_SYM_TYPE_ENUM                  = 0x000A  ; // enumeration.
const auto IMAGE_SYM_TYPE_MOE                   = 0x000B  ; // member of enumeration.
const auto IMAGE_SYM_TYPE_BYTE                  = 0x000C  ; //
const auto IMAGE_SYM_TYPE_WORD                  = 0x000D  ; //
const auto IMAGE_SYM_TYPE_UINT                  = 0x000E  ; //
const auto IMAGE_SYM_TYPE_DWORD                 = 0x000F  ; //
const auto IMAGE_SYM_TYPE_PCODE                 = 0x8000  ; //
//
// Type (derived) values.
//

const auto IMAGE_SYM_DTYPE_NULL                 = 0       ; // no derived type.
const auto IMAGE_SYM_DTYPE_POINTER              = 1       ; // pointer.
const auto IMAGE_SYM_DTYPE_FUNCTION             = 2       ; // function.
const auto IMAGE_SYM_DTYPE_ARRAY                = 3       ; // array.

//
// Storage classes.
//
const auto IMAGE_SYM_CLASS_END_OF_FUNCTION      = (BYTE )-1;
const auto IMAGE_SYM_CLASS_NULL                 = 0x0000;
const auto IMAGE_SYM_CLASS_AUTOMATIC            = 0x0001;
const auto IMAGE_SYM_CLASS_EXTERNAL             = 0x0002;
const auto IMAGE_SYM_CLASS_STATIC               = 0x0003;
const auto IMAGE_SYM_CLASS_REGISTER             = 0x0004;
const auto IMAGE_SYM_CLASS_EXTERNAL_DEF         = 0x0005;
const auto IMAGE_SYM_CLASS_LABEL                = 0x0006;
const auto IMAGE_SYM_CLASS_UNDEFINED_LABEL      = 0x0007;
const auto IMAGE_SYM_CLASS_MEMBER_OF_STRUCT     = 0x0008;
const auto IMAGE_SYM_CLASS_ARGUMENT             = 0x0009;
const auto IMAGE_SYM_CLASS_STRUCT_TAG           = 0x000A;
const auto IMAGE_SYM_CLASS_MEMBER_OF_UNION      = 0x000B;
const auto IMAGE_SYM_CLASS_UNION_TAG            = 0x000C;
const auto IMAGE_SYM_CLASS_TYPE_DEFINITION      = 0x000D;
const auto IMAGE_SYM_CLASS_UNDEFINED_STATIC     = 0x000E;
const auto IMAGE_SYM_CLASS_ENUM_TAG             = 0x000F;
const auto IMAGE_SYM_CLASS_MEMBER_OF_ENUM       = 0x0010;
const auto IMAGE_SYM_CLASS_REGISTER_PARAM       = 0x0011;
const auto IMAGE_SYM_CLASS_BIT_FIELD            = 0x0012;

const auto IMAGE_SYM_CLASS_FAR_EXTERNAL         = 0x0044  ; //

const auto IMAGE_SYM_CLASS_BLOCK                = 0x0064;
const auto IMAGE_SYM_CLASS_FUNCTION             = 0x0065;
const auto IMAGE_SYM_CLASS_END_OF_STRUCT        = 0x0066;
const auto IMAGE_SYM_CLASS_FILE                 = 0x0067;
// new
const auto IMAGE_SYM_CLASS_SECTION              = 0x0068;
const auto IMAGE_SYM_CLASS_WEAK_EXTERNAL        = 0x0069;

const auto IMAGE_SYM_CLASS_CLR_TOKEN            = 0x006B;

// type packing constants

const auto N_BTMASK                             = 0x000F;
const auto N_TMASK                              = 0x0030;
const auto N_TMASK1                             = 0x00C0;
const auto N_TMASK2                             = 0x00F0;
const auto N_BTSHFT                             = 4;
const auto N_TSHIFT                             = 2;
// MACROS

//
// Auxiliary entry format.
//
/*
alias union _IMAGE_AUX_SYMBOL {
    struct {
        DWORD    TagIndex;                      // struct, union, or enum tag index
        union {
            struct {
                WORD    Linenumber;             // declaration line number
                WORD    Size;                   // size of struct, union, or enum
            } LnSz;
           DWORD    TotalSize;
        } Misc;
        union {
            struct {                            // if ISFCN, tag, or .bb
                DWORD    PointerToLinenumber;
                DWORD    PointerToNextFunction;
            } Function;
            struct {                            // if ISARY, up to 4 dimen.
                WORD     Dimension[4];
            } Array;
        } FcnAry;
        WORD    TvIndex;                        // tv index
    } Sym;
    struct {
        BYTE    Name[IMAGE_SIZEOF_SYMBOL];
    } File;
    struct {
        DWORD   Length;                         // section length
        WORD    NumberOfRelocations;            // number of relocation entries
        WORD    NumberOfLinenumbers;            // number of line numbers
        DWORD   CheckSum;                       // checksum for communal
        SHORT   Number;                         // section number to associate with
        BYTE    Selection;                      // communal selection type
    } Section;
} IMAGE_AUX_SYMBOL;
alias IMAGE_AUX_SYMBOL UNALIGNED *PIMAGE_AUX_SYMBOL;

enum IMAGE_AUX_SYMBOL_TYPE {
    IMAGE_AUX_SYMBOL_TYPE_TOKEN_DEF = 1,
}

align(2) struct IMAGE_AUX_SYMBOL_TOKEN_DEF {
    BYTE  bAuxType;                  // IMAGE_AUX_SYMBOL_TYPE
    BYTE  bReserved;                 // Must be 0
    DWORD SymbolTableIndex;
    BYTE  rgbReserved[12];           // Must be 0
}


alias IMAGE_AUX_SYMBOL_TOKEN_DEF UNALIGNED *PIMAGE_AUX_SYMBOL_TOKEN_DEF;
*/

//
// Communal selection types.
//

const auto IMAGE_COMDAT_SELECT_NODUPLICATES     = 1;
const auto IMAGE_COMDAT_SELECT_ANY              = 2;
const auto IMAGE_COMDAT_SELECT_SAME_SIZE        = 3;
const auto IMAGE_COMDAT_SELECT_EXACT_MATCH      = 4;
const auto IMAGE_COMDAT_SELECT_ASSOCIATIVE      = 5;
const auto IMAGE_COMDAT_SELECT_LARGEST          = 6;
const auto IMAGE_COMDAT_SELECT_NEWEST           = 7;

const auto IMAGE_WEAK_EXTERN_SEARCH_NOLIBRARY   = 1;
const auto IMAGE_WEAK_EXTERN_SEARCH_LIBRARY     = 2;
const auto IMAGE_WEAK_EXTERN_SEARCH_ALIAS       = 3;

//
// Relocation format.
//

struct IMAGE_RELOCATION {
    union _inner_union {
        DWORD   VirtualAddress;
        DWORD   RelocCount;             // Set to the real count when IMAGE_SCN_LNK_NRELOC_OVFL is set
    }
    _inner_union fields;
    DWORD   SymbolTableIndex;
    WORD    Type;
}

alias IMAGE_RELOCATION  *PIMAGE_RELOCATION;

//
// I386 relocation types.
//
const auto IMAGE_REL_I386_ABSOLUTE          = 0x0000  ; // Reference is absolute, no relocation is necessary
const auto IMAGE_REL_I386_DIR16             = 0x0001  ; // Direct 16-bit reference to the symbols virtual address
const auto IMAGE_REL_I386_REL16             = 0x0002  ; // PC-relative 16-bit reference to the symbols virtual address
const auto IMAGE_REL_I386_DIR32             = 0x0006  ; // Direct 32-bit reference to the symbols virtual address
const auto IMAGE_REL_I386_DIR32NB           = 0x0007  ; // Direct 32-bit reference to the symbols virtual address, base not included
const auto IMAGE_REL_I386_SEG12             = 0x0009  ; // Direct 16-bit reference to the segment-selector bits of a 32-bit virtual address
const auto IMAGE_REL_I386_SECTION           = 0x000A;
const auto IMAGE_REL_I386_SECREL            = 0x000B;
const auto IMAGE_REL_I386_TOKEN             = 0x000C  ; // clr token
const auto IMAGE_REL_I386_SECREL7           = 0x000D  ; // 7 bit offset from base of section containing target
const auto IMAGE_REL_I386_REL32             = 0x0014  ; // PC-relative 32-bit reference to the symbols virtual address

//
// MIPS relocation types.
//
const auto IMAGE_REL_MIPS_ABSOLUTE          = 0x0000  ; // Reference is absolute, no relocation is necessary
const auto IMAGE_REL_MIPS_REFHALF           = 0x0001;
const auto IMAGE_REL_MIPS_REFWORD           = 0x0002;
const auto IMAGE_REL_MIPS_JMPADDR           = 0x0003;
const auto IMAGE_REL_MIPS_REFHI             = 0x0004;
const auto IMAGE_REL_MIPS_REFLO             = 0x0005;
const auto IMAGE_REL_MIPS_GPREL             = 0x0006;
const auto IMAGE_REL_MIPS_LITERAL           = 0x0007;
const auto IMAGE_REL_MIPS_SECTION           = 0x000A;
const auto IMAGE_REL_MIPS_SECREL            = 0x000B;
const auto IMAGE_REL_MIPS_SECRELLO          = 0x000C  ; // Low 16-bit section relative referemce (used for >32k TLS)
const auto IMAGE_REL_MIPS_SECRELHI          = 0x000D  ; // High 16-bit section relative reference (used for >32k TLS)
const auto IMAGE_REL_MIPS_TOKEN             = 0x000E  ; // clr token
const auto IMAGE_REL_MIPS_JMPADDR16         = 0x0010;
const auto IMAGE_REL_MIPS_REFWORDNB         = 0x0022;
const auto IMAGE_REL_MIPS_PAIR              = 0x0025;

//
// Alpha Relocation types.
//
const auto IMAGE_REL_ALPHA_ABSOLUTE         = 0x0000;
const auto IMAGE_REL_ALPHA_REFLONG          = 0x0001;
const auto IMAGE_REL_ALPHA_REFQUAD          = 0x0002;
const auto IMAGE_REL_ALPHA_GPREL32          = 0x0003;
const auto IMAGE_REL_ALPHA_LITERAL          = 0x0004;
const auto IMAGE_REL_ALPHA_LITUSE           = 0x0005;
const auto IMAGE_REL_ALPHA_GPDISP           = 0x0006;
const auto IMAGE_REL_ALPHA_BRADDR           = 0x0007;
const auto IMAGE_REL_ALPHA_HINT             = 0x0008;
const auto IMAGE_REL_ALPHA_INLINE_REFLONG   = 0x0009;
const auto IMAGE_REL_ALPHA_REFHI            = 0x000A;
const auto IMAGE_REL_ALPHA_REFLO            = 0x000B;
const auto IMAGE_REL_ALPHA_PAIR             = 0x000C;
const auto IMAGE_REL_ALPHA_MATCH            = 0x000D;
const auto IMAGE_REL_ALPHA_SECTION          = 0x000E;
const auto IMAGE_REL_ALPHA_SECREL           = 0x000F;
const auto IMAGE_REL_ALPHA_REFLONGNB        = 0x0010;
const auto IMAGE_REL_ALPHA_SECRELLO         = 0x0011  ; // Low 16-bit section relative reference
const auto IMAGE_REL_ALPHA_SECRELHI         = 0x0012  ; // High 16-bit section relative reference
const auto IMAGE_REL_ALPHA_REFQ3            = 0x0013  ; // High 16 bits of 48 bit reference
const auto IMAGE_REL_ALPHA_REFQ2            = 0x0014  ; // Middle 16 bits of 48 bit reference
const auto IMAGE_REL_ALPHA_REFQ1            = 0x0015  ; // Low 16 bits of 48 bit reference
const auto IMAGE_REL_ALPHA_GPRELLO          = 0x0016  ; // Low 16-bit GP relative reference
const auto IMAGE_REL_ALPHA_GPRELHI          = 0x0017  ; // High 16-bit GP relative reference

//
// IBM PowerPC relocation types.
//
const auto IMAGE_REL_PPC_ABSOLUTE           = 0x0000  ; // NOP
const auto IMAGE_REL_PPC_ADDR64             = 0x0001  ; // 64-bit address
const auto IMAGE_REL_PPC_ADDR32             = 0x0002  ; // 32-bit address
const auto IMAGE_REL_PPC_ADDR24             = 0x0003  ; // 26-bit address, shifted left 2 (branch absolute)
const auto IMAGE_REL_PPC_ADDR16             = 0x0004  ; // 16-bit address
const auto IMAGE_REL_PPC_ADDR14             = 0x0005  ; // 16-bit address, shifted left 2 (load doubleword)
const auto IMAGE_REL_PPC_REL24              = 0x0006  ; // 26-bit PC-relative offset, shifted left 2 (branch relative)
const auto IMAGE_REL_PPC_REL14              = 0x0007  ; // 16-bit PC-relative offset, shifted left 2 (br cond relative)
const auto IMAGE_REL_PPC_TOCREL16           = 0x0008  ; // 16-bit offset from TOC base
const auto IMAGE_REL_PPC_TOCREL14           = 0x0009  ; // 16-bit offset from TOC base, shifted left 2 (load doubleword)

const auto IMAGE_REL_PPC_ADDR32NB           = 0x000A  ; // 32-bit addr w/o image base
const auto IMAGE_REL_PPC_SECREL             = 0x000B  ; // va of containing section (as in an image sectionhdr)
const auto IMAGE_REL_PPC_SECTION            = 0x000C  ; // sectionheader number
const auto IMAGE_REL_PPC_IFGLUE             = 0x000D  ; // substitute TOC restore instruction iff symbol is glue code
const auto IMAGE_REL_PPC_IMGLUE             = 0x000E  ; // symbol is glue code; virtual address is TOC restore instruction
const auto IMAGE_REL_PPC_SECREL16           = 0x000F  ; // va of containing section (limited to 16 bits)
const auto IMAGE_REL_PPC_REFHI              = 0x0010;
const auto IMAGE_REL_PPC_REFLO              = 0x0011;
const auto IMAGE_REL_PPC_PAIR               = 0x0012;
const auto IMAGE_REL_PPC_SECRELLO           = 0x0013  ; // Low 16-bit section relative reference (used for >32k TLS)
const auto IMAGE_REL_PPC_SECRELHI           = 0x0014  ; // High 16-bit section relative reference (used for >32k TLS)
const auto IMAGE_REL_PPC_GPREL              = 0x0015;
const auto IMAGE_REL_PPC_TOKEN              = 0x0016  ; // clr token

const auto IMAGE_REL_PPC_TYPEMASK           = 0x00FF  ; // mask to isolate above values in IMAGE_RELOCATION.Type

// Flag bits in IMAGE_RELOCATION.TYPE

const auto IMAGE_REL_PPC_NEG                = 0x0100  ; // subtract reloc value rather than adding it
const auto IMAGE_REL_PPC_BRTAKEN            = 0x0200  ; // fix branch prediction bit to predict branch taken
const auto IMAGE_REL_PPC_BRNTAKEN           = 0x0400  ; // fix branch prediction bit to predict branch not taken
const auto IMAGE_REL_PPC_TOCDEFN            = 0x0800  ; // toc slot defined in file (or, data in toc)

//
// Hitachi SH3 relocation types.
//
const auto IMAGE_REL_SH3_ABSOLUTE           = 0x0000  ; // No relocation
const auto IMAGE_REL_SH3_DIRECT16           = 0x0001  ; // 16 bit direct
const auto IMAGE_REL_SH3_DIRECT32           = 0x0002  ; // 32 bit direct
const auto IMAGE_REL_SH3_DIRECT8            = 0x0003  ; // 8 bit direct, -128..255
const auto IMAGE_REL_SH3_DIRECT8_WORD       = 0x0004  ; // 8 bit direct .W (0 ext.)
const auto IMAGE_REL_SH3_DIRECT8_LONG       = 0x0005  ; // 8 bit direct .L (0 ext.)
const auto IMAGE_REL_SH3_DIRECT4            = 0x0006  ; // 4 bit direct (0 ext.)
const auto IMAGE_REL_SH3_DIRECT4_WORD       = 0x0007  ; // 4 bit direct .W (0 ext.)
const auto IMAGE_REL_SH3_DIRECT4_LONG       = 0x0008  ; // 4 bit direct .L (0 ext.)
const auto IMAGE_REL_SH3_PCREL8_WORD        = 0x0009  ; // 8 bit PC relative .W
const auto IMAGE_REL_SH3_PCREL8_LONG        = 0x000A  ; // 8 bit PC relative .L
const auto IMAGE_REL_SH3_PCREL12_WORD       = 0x000B  ; // 12 LSB PC relative .W
const auto IMAGE_REL_SH3_STARTOF_SECTION    = 0x000C  ; // Start of EXE section
const auto IMAGE_REL_SH3_SIZEOF_SECTION     = 0x000D  ; // Size of EXE section
const auto IMAGE_REL_SH3_SECTION            = 0x000E  ; // Section table index
const auto IMAGE_REL_SH3_SECREL             = 0x000F  ; // Offset within section
const auto IMAGE_REL_SH3_DIRECT32_NB        = 0x0010  ; // 32 bit direct not based
const auto IMAGE_REL_SH3_GPREL4_LONG        = 0x0011  ; // GP-relative addressing
const auto IMAGE_REL_SH3_TOKEN              = 0x0012  ; // clr token
const auto IMAGE_REL_SHM_PCRELPT            = 0x0013  ; // Offset from current
                                                //  instruction in longwords
                                                //  if not NOMODE, insert the
                                                //  inverse of the low bit at
                                                //  bit 32 to select PTA/PTB
const auto IMAGE_REL_SHM_REFLO              = 0x0014  ; // Low bits of 32-bit address
const auto IMAGE_REL_SHM_REFHALF            = 0x0015  ; // High bits of 32-bit address
const auto IMAGE_REL_SHM_RELLO              = 0x0016  ; // Low bits of relative reference
const auto IMAGE_REL_SHM_RELHALF            = 0x0017  ; // High bits of relative reference
const auto IMAGE_REL_SHM_PAIR               = 0x0018  ; // offset operand for relocation

const auto IMAGE_REL_SH_NOMODE              = 0x8000  ; // relocation ignores section mode


const auto IMAGE_REL_ARM_ABSOLUTE           = 0x0000  ; // No relocation required
const auto IMAGE_REL_ARM_ADDR32             = 0x0001  ; // 32 bit address
const auto IMAGE_REL_ARM_ADDR32NB           = 0x0002  ; // 32 bit address w/o image base
const auto IMAGE_REL_ARM_BRANCH24           = 0x0003  ; // 24 bit offset << 2 & sign ext.
const auto IMAGE_REL_ARM_BRANCH11           = 0x0004  ; // Thumb: 2 11 bit offsets
const auto IMAGE_REL_ARM_TOKEN              = 0x0005  ; // clr token
const auto IMAGE_REL_ARM_GPREL12            = 0x0006  ; // GP-relative addressing (ARM)
const auto IMAGE_REL_ARM_GPREL7             = 0x0007  ; // GP-relative addressing (Thumb)
const auto IMAGE_REL_ARM_BLX24              = 0x0008;
const auto IMAGE_REL_ARM_BLX11              = 0x0009;
const auto IMAGE_REL_ARM_SECTION            = 0x000E  ; // Section table index
const auto IMAGE_REL_ARM_SECREL             = 0x000F  ; // Offset within section

const auto IMAGE_REL_AM_ABSOLUTE            = 0x0000;
const auto IMAGE_REL_AM_ADDR32              = 0x0001;
const auto IMAGE_REL_AM_ADDR32NB            = 0x0002;
const auto IMAGE_REL_AM_CALL32              = 0x0003;
const auto IMAGE_REL_AM_FUNCINFO            = 0x0004;
const auto IMAGE_REL_AM_REL32_1             = 0x0005;
const auto IMAGE_REL_AM_REL32_2             = 0x0006;
const auto IMAGE_REL_AM_SECREL              = 0x0007;
const auto IMAGE_REL_AM_SECTION             = 0x0008;
const auto IMAGE_REL_AM_TOKEN               = 0x0009;

//
// x64 relocations
//
const auto IMAGE_REL_AMD64_ABSOLUTE         = 0x0000  ; // Reference is absolute, no relocation is necessary
const auto IMAGE_REL_AMD64_ADDR64           = 0x0001  ; // 64-bit address (VA).
const auto IMAGE_REL_AMD64_ADDR32           = 0x0002  ; // 32-bit address (VA).
const auto IMAGE_REL_AMD64_ADDR32NB         = 0x0003  ; // 32-bit address w/o image base (RVA).
const auto IMAGE_REL_AMD64_REL32            = 0x0004  ; // 32-bit relative address from byte following reloc
const auto IMAGE_REL_AMD64_REL32_1          = 0x0005  ; // 32-bit relative address from byte distance 1 from reloc
const auto IMAGE_REL_AMD64_REL32_2          = 0x0006  ; // 32-bit relative address from byte distance 2 from reloc
const auto IMAGE_REL_AMD64_REL32_3          = 0x0007  ; // 32-bit relative address from byte distance 3 from reloc
const auto IMAGE_REL_AMD64_REL32_4          = 0x0008  ; // 32-bit relative address from byte distance 4 from reloc
const auto IMAGE_REL_AMD64_REL32_5          = 0x0009  ; // 32-bit relative address from byte distance 5 from reloc
const auto IMAGE_REL_AMD64_SECTION          = 0x000A  ; // Section index
const auto IMAGE_REL_AMD64_SECREL           = 0x000B  ; // 32 bit offset from base of section containing target
const auto IMAGE_REL_AMD64_SECREL7          = 0x000C  ; // 7 bit unsigned offset from base of section containing target
const auto IMAGE_REL_AMD64_TOKEN            = 0x000D  ; // 32 bit metadata token
const auto IMAGE_REL_AMD64_SREL32           = 0x000E  ; // 32 bit signed span-dependent value emitted into object
const auto IMAGE_REL_AMD64_PAIR             = 0x000F;
const auto IMAGE_REL_AMD64_SSPAN32          = 0x0010  ; // 32 bit signed span-dependent value applied at link time

//
// IA64 relocation types.
//
const auto IMAGE_REL_IA64_ABSOLUTE          = 0x0000;
const auto IMAGE_REL_IA64_IMM14             = 0x0001;
const auto IMAGE_REL_IA64_IMM22             = 0x0002;
const auto IMAGE_REL_IA64_IMM64             = 0x0003;
const auto IMAGE_REL_IA64_DIR32             = 0x0004;
const auto IMAGE_REL_IA64_DIR64             = 0x0005;
const auto IMAGE_REL_IA64_PCREL21B          = 0x0006;
const auto IMAGE_REL_IA64_PCREL21M          = 0x0007;
const auto IMAGE_REL_IA64_PCREL21F          = 0x0008;
const auto IMAGE_REL_IA64_GPREL22           = 0x0009;
const auto IMAGE_REL_IA64_LTOFF22           = 0x000A;
const auto IMAGE_REL_IA64_SECTION           = 0x000B;
const auto IMAGE_REL_IA64_SECREL22          = 0x000C;
const auto IMAGE_REL_IA64_SECREL64I         = 0x000D;
const auto IMAGE_REL_IA64_SECREL32          = 0x000E;
//
const auto IMAGE_REL_IA64_DIR32NB           = 0x0010;
const auto IMAGE_REL_IA64_SREL14            = 0x0011;
const auto IMAGE_REL_IA64_SREL22            = 0x0012;
const auto IMAGE_REL_IA64_SREL32            = 0x0013;
const auto IMAGE_REL_IA64_UREL32            = 0x0014;
const auto IMAGE_REL_IA64_PCREL60X          = 0x0015  ; // This is always a BRL and never converted
const auto IMAGE_REL_IA64_PCREL60B          = 0x0016  ; // If possible, convert to MBB bundle with NOP.B in slot 1
const auto IMAGE_REL_IA64_PCREL60F          = 0x0017  ; // If possible, convert to MFB bundle with NOP.F in slot 1
const auto IMAGE_REL_IA64_PCREL60I          = 0x0018  ; // If possible, convert to MIB bundle with NOP.I in slot 1
const auto IMAGE_REL_IA64_PCREL60M          = 0x0019  ; // If possible, convert to MMB bundle with NOP.M in slot 1
const auto IMAGE_REL_IA64_IMMGPREL64        = 0x001A;
const auto IMAGE_REL_IA64_TOKEN             = 0x001B  ; // clr token
const auto IMAGE_REL_IA64_GPREL32           = 0x001C;
const auto IMAGE_REL_IA64_ADDEND            = 0x001F;

//
// CEF relocation types.
//
const auto IMAGE_REL_CEF_ABSOLUTE           = 0x0000  ; // Reference is absolute, no relocation is necessary
const auto IMAGE_REL_CEF_ADDR32             = 0x0001  ; // 32-bit address (VA).
const auto IMAGE_REL_CEF_ADDR64             = 0x0002  ; // 64-bit address (VA).
const auto IMAGE_REL_CEF_ADDR32NB           = 0x0003  ; // 32-bit address w/o image base (RVA).
const auto IMAGE_REL_CEF_SECTION            = 0x0004  ; // Section index
const auto IMAGE_REL_CEF_SECREL             = 0x0005  ; // 32 bit offset from base of section containing target
const auto IMAGE_REL_CEF_TOKEN              = 0x0006  ; // 32 bit metadata token

//
// clr relocation types.
//
const auto IMAGE_REL_CEE_ABSOLUTE           = 0x0000  ; // Reference is absolute, no relocation is necessary
const auto IMAGE_REL_CEE_ADDR32             = 0x0001  ; // 32-bit address (VA).
const auto IMAGE_REL_CEE_ADDR64             = 0x0002  ; // 64-bit address (VA).
const auto IMAGE_REL_CEE_ADDR32NB           = 0x0003  ; // 32-bit address w/o image base (RVA).
const auto IMAGE_REL_CEE_SECTION            = 0x0004  ; // Section index
const auto IMAGE_REL_CEE_SECREL             = 0x0005  ; // 32 bit offset from base of section containing target
const auto IMAGE_REL_CEE_TOKEN              = 0x0006  ; // 32 bit metadata token


const auto IMAGE_REL_M32R_ABSOLUTE          = 0x0000  ; // No relocation required
const auto IMAGE_REL_M32R_ADDR32            = 0x0001  ; // 32 bit address
const auto IMAGE_REL_M32R_ADDR32NB          = 0x0002  ; // 32 bit address w/o image base
const auto IMAGE_REL_M32R_ADDR24            = 0x0003  ; // 24 bit address
const auto IMAGE_REL_M32R_GPREL16           = 0x0004  ; // GP relative addressing
const auto IMAGE_REL_M32R_PCREL24           = 0x0005  ; // 24 bit offset << 2 & sign ext.
const auto IMAGE_REL_M32R_PCREL16           = 0x0006  ; // 16 bit offset << 2 & sign ext.
const auto IMAGE_REL_M32R_PCREL8            = 0x0007  ; // 8 bit offset << 2 & sign ext.
const auto IMAGE_REL_M32R_REFHALF           = 0x0008  ; // 16 MSBs
const auto IMAGE_REL_M32R_REFHI             = 0x0009  ; // 16 MSBs; adj for LSB sign ext.
const auto IMAGE_REL_M32R_REFLO             = 0x000A  ; // 16 LSBs
const auto IMAGE_REL_M32R_PAIR              = 0x000B  ; // Link HI and LO
const auto IMAGE_REL_M32R_SECTION           = 0x000C  ; // Section table index
const auto IMAGE_REL_M32R_SECREL32          = 0x000D  ; // 32 bit section relative reference
const auto IMAGE_REL_M32R_TOKEN             = 0x000E  ; // clr token

const auto IMAGE_REL_EBC_ABSOLUTE           = 0x0000  ; // No relocation required
const auto IMAGE_REL_EBC_ADDR32NB           = 0x0001  ; // 32 bit address w/o image base
const auto IMAGE_REL_EBC_REL32              = 0x0002  ; // 32-bit relative address from byte following reloc
const auto IMAGE_REL_EBC_SECTION            = 0x0003  ; // Section table index
const auto IMAGE_REL_EBC_SECREL             = 0x0004  ; // Offset within section

const auto EMARCH_ENC_I17_IMM7B_INST_WORD_X          = 3  ; // Intel-IA64-Filler
const auto EMARCH_ENC_I17_IMM7B_SIZE_X               = 7  ; // Intel-IA64-Filler
const auto EMARCH_ENC_I17_IMM7B_INST_WORD_POS_X      = 4  ; // Intel-IA64-Filler
const auto EMARCH_ENC_I17_IMM7B_VAL_POS_X            = 0  ; // Intel-IA64-Filler

const auto EMARCH_ENC_I17_IMM9D_INST_WORD_X          = 3  ; // Intel-IA64-Filler
const auto EMARCH_ENC_I17_IMM9D_SIZE_X               = 9  ; // Intel-IA64-Filler
const auto EMARCH_ENC_I17_IMM9D_INST_WORD_POS_X      = 18 ; // Intel-IA64-Filler
const auto EMARCH_ENC_I17_IMM9D_VAL_POS_X            = 7  ; // Intel-IA64-Filler

const auto EMARCH_ENC_I17_IMM5C_INST_WORD_X          = 3  ; // Intel-IA64-Filler
const auto EMARCH_ENC_I17_IMM5C_SIZE_X               = 5  ; // Intel-IA64-Filler
const auto EMARCH_ENC_I17_IMM5C_INST_WORD_POS_X      = 13 ; // Intel-IA64-Filler
const auto EMARCH_ENC_I17_IMM5C_VAL_POS_X            = 16 ; // Intel-IA64-Filler

const auto EMARCH_ENC_I17_IC_INST_WORD_X             = 3  ; // Intel-IA64-Filler
const auto EMARCH_ENC_I17_IC_SIZE_X                  = 1  ; // Intel-IA64-Filler
const auto EMARCH_ENC_I17_IC_INST_WORD_POS_X         = 12 ; // Intel-IA64-Filler
const auto EMARCH_ENC_I17_IC_VAL_POS_X               = 21 ; // Intel-IA64-Filler

const auto EMARCH_ENC_I17_IMM41a_INST_WORD_X         = 1  ; // Intel-IA64-Filler
const auto EMARCH_ENC_I17_IMM41a_SIZE_X              = 10 ; // Intel-IA64-Filler
const auto EMARCH_ENC_I17_IMM41a_INST_WORD_POS_X     = 14 ; // Intel-IA64-Filler
const auto EMARCH_ENC_I17_IMM41a_VAL_POS_X           = 22 ; // Intel-IA64-Filler

const auto EMARCH_ENC_I17_IMM41b_INST_WORD_X         = 1  ; // Intel-IA64-Filler
const auto EMARCH_ENC_I17_IMM41b_SIZE_X              = 8  ; // Intel-IA64-Filler
const auto EMARCH_ENC_I17_IMM41b_INST_WORD_POS_X     = 24 ; // Intel-IA64-Filler
const auto EMARCH_ENC_I17_IMM41b_VAL_POS_X           = 32 ; // Intel-IA64-Filler

const auto EMARCH_ENC_I17_IMM41c_INST_WORD_X         = 2  ; // Intel-IA64-Filler
const auto EMARCH_ENC_I17_IMM41c_SIZE_X              = 23 ; // Intel-IA64-Filler
const auto EMARCH_ENC_I17_IMM41c_INST_WORD_POS_X     = 0  ; // Intel-IA64-Filler
const auto EMARCH_ENC_I17_IMM41c_VAL_POS_X           = 40 ; // Intel-IA64-Filler

const auto EMARCH_ENC_I17_SIGN_INST_WORD_X           = 3  ; // Intel-IA64-Filler
const auto EMARCH_ENC_I17_SIGN_SIZE_X                = 1  ; // Intel-IA64-Filler
const auto EMARCH_ENC_I17_SIGN_INST_WORD_POS_X       = 27 ; // Intel-IA64-Filler
const auto EMARCH_ENC_I17_SIGN_VAL_POS_X             = 63 ; // Intel-IA64-Filler

const auto X3_OPCODE_INST_WORD_X                     = 3  ; // Intel-IA64-Filler
const auto X3_OPCODE_SIZE_X                          = 4  ; // Intel-IA64-Filler
const auto X3_OPCODE_INST_WORD_POS_X                 = 28 ; // Intel-IA64-Filler
const auto X3_OPCODE_SIGN_VAL_POS_X                  = 0  ; // Intel-IA64-Filler

const auto X3_I_INST_WORD_X                          = 3  ; // Intel-IA64-Filler
const auto X3_I_SIZE_X                               = 1  ; // Intel-IA64-Filler
const auto X3_I_INST_WORD_POS_X                      = 27 ; // Intel-IA64-Filler
const auto X3_I_SIGN_VAL_POS_X                       = 59 ; // Intel-IA64-Filler

const auto X3_D_WH_INST_WORD_X                       = 3  ; // Intel-IA64-Filler
const auto X3_D_WH_SIZE_X                            = 3  ; // Intel-IA64-Filler
const auto X3_D_WH_INST_WORD_POS_X                   = 24 ; // Intel-IA64-Filler
const auto X3_D_WH_SIGN_VAL_POS_X                    = 0  ; // Intel-IA64-Filler

const auto X3_IMM20_INST_WORD_X                      = 3  ; // Intel-IA64-Filler
const auto X3_IMM20_SIZE_X                           = 20 ; // Intel-IA64-Filler
const auto X3_IMM20_INST_WORD_POS_X                  = 4  ; // Intel-IA64-Filler
const auto X3_IMM20_SIGN_VAL_POS_X                   = 0  ; // Intel-IA64-Filler

const auto X3_IMM39_1_INST_WORD_X                    = 2  ; // Intel-IA64-Filler
const auto X3_IMM39_1_SIZE_X                         = 23 ; // Intel-IA64-Filler
const auto X3_IMM39_1_INST_WORD_POS_X                = 0  ; // Intel-IA64-Filler
const auto X3_IMM39_1_SIGN_VAL_POS_X                 = 36 ; // Intel-IA64-Filler

const auto X3_IMM39_2_INST_WORD_X                    = 1  ; // Intel-IA64-Filler
const auto X3_IMM39_2_SIZE_X                         = 16 ; // Intel-IA64-Filler
const auto X3_IMM39_2_INST_WORD_POS_X                = 16 ; // Intel-IA64-Filler
const auto X3_IMM39_2_SIGN_VAL_POS_X                 = 20 ; // Intel-IA64-Filler

const auto X3_P_INST_WORD_X                          = 3  ; // Intel-IA64-Filler
const auto X3_P_SIZE_X                               = 4  ; // Intel-IA64-Filler
const auto X3_P_INST_WORD_POS_X                      = 0  ; // Intel-IA64-Filler
const auto X3_P_SIGN_VAL_POS_X                       = 0  ; // Intel-IA64-Filler

const auto X3_TMPLT_INST_WORD_X                      = 0  ; // Intel-IA64-Filler
const auto X3_TMPLT_SIZE_X                           = 4  ; // Intel-IA64-Filler
const auto X3_TMPLT_INST_WORD_POS_X                  = 0  ; // Intel-IA64-Filler
const auto X3_TMPLT_SIGN_VAL_POS_X                   = 0  ; // Intel-IA64-Filler

const auto X3_BTYPE_QP_INST_WORD_X                   = 2  ; // Intel-IA64-Filler
const auto X3_BTYPE_QP_SIZE_X                        = 9  ; // Intel-IA64-Filler
const auto X3_BTYPE_QP_INST_WORD_POS_X               = 23 ; // Intel-IA64-Filler
const auto X3_BTYPE_QP_INST_VAL_POS_X                = 0  ; // Intel-IA64-Filler

const auto X3_EMPTY_INST_WORD_X                      = 1  ; // Intel-IA64-Filler
const auto X3_EMPTY_SIZE_X                           = 2  ; // Intel-IA64-Filler
const auto X3_EMPTY_INST_WORD_POS_X                  = 14 ; // Intel-IA64-Filler
const auto X3_EMPTY_INST_VAL_POS_X                   = 0  ; // Intel-IA64-Filler

//
// Line number format.
//

struct IMAGE_LINENUMBER {
    union _inner_union {
        DWORD   SymbolTableIndex;               // Symbol table index of function name if Linenumber is 0.
        DWORD   VirtualAddress;                 // Virtual address of line number.
    } 
    _inner_union Type;
    WORD    Linenumber;                         // Line number.
}

alias IMAGE_LINENUMBER  *PIMAGE_LINENUMBER;


//
// Based relocation format.
//

struct IMAGE_BASE_RELOCATION {
    DWORD   VirtualAddress;
    DWORD   SizeOfBlock;
//  WORD    TypeOffset[1];
}

alias IMAGE_BASE_RELOCATION  * PIMAGE_BASE_RELOCATION;

//
// Based relocation types.
//

const auto IMAGE_REL_BASED_ABSOLUTE               = 0;
const auto IMAGE_REL_BASED_HIGH                   = 1;
const auto IMAGE_REL_BASED_LOW                    = 2;
const auto IMAGE_REL_BASED_HIGHLOW                = 3;
const auto IMAGE_REL_BASED_HIGHADJ                = 4;
const auto IMAGE_REL_BASED_MIPS_JMPADDR           = 5;
const auto IMAGE_REL_BASED_MIPS_JMPADDR16         = 9;
const auto IMAGE_REL_BASED_IA64_IMM64             = 9;
const auto IMAGE_REL_BASED_DIR64                  = 10;


//
// Archive format.
//

const auto IMAGE_ARCHIVE_START_SIZE              = 8;
const auto IMAGE_ARCHIVE_START                   = "!<arch>\n"c;
const auto IMAGE_ARCHIVE_END                     = "`\n"c;
const auto IMAGE_ARCHIVE_PAD                     = "\n"c;
const auto IMAGE_ARCHIVE_LINKER_MEMBER           = "/               "c;
const auto IMAGE_ARCHIVE_LONGNAMES_MEMBER        = "//              "c;

struct IMAGE_ARCHIVE_MEMBER_HEADER {
    BYTE     Name[16];                          // File member name - `/' terminated.
    BYTE     Date[12];                          // File member date - decimal.
    BYTE     UserID[6];                         // File member user id - decimal.
    BYTE     GroupID[6];                        // File member group id - decimal.
    BYTE     Mode[8];                           // File member mode - octal.
    BYTE     Size[10];                          // File member size - decimal.
    BYTE     EndHeader[2];                      // String to end header.
}

alias IMAGE_ARCHIVE_MEMBER_HEADER* PIMAGE_ARCHIVE_MEMBER_HEADER;

const auto IMAGE_SIZEOF_ARCHIVE_MEMBER_HDR       = 60;

//
// DLL support.
//

//
// Export Format
//

struct IMAGE_EXPORT_DIRECTORY {
    DWORD   Characteristics;
    DWORD   TimeDateStamp;
    WORD    MajorVersion;
    WORD    MinorVersion;
    DWORD   Name;
    DWORD   Base;
    DWORD   NumberOfFunctions;
    DWORD   NumberOfNames;
    DWORD   AddressOfFunctions;     // RVA from base of image
    DWORD   AddressOfNames;         // RVA from base of image
    DWORD   AddressOfNameOrdinals;  // RVA from base of image
}

alias IMAGE_EXPORT_DIRECTORY* PIMAGE_EXPORT_DIRECTORY;

//
// Import Format
//

struct IMAGE_IMPORT_BY_NAME {
    WORD    Hint;
    BYTE    Name[1];
}

alias IMAGE_IMPORT_BY_NAME* PIMAGE_IMPORT_BY_NAME;

align(8) struct IMAGE_THUNK_DATA64 {
    union _inner_union {
        ULONGLONG ForwarderString;  // PBYTE
        ULONGLONG Function;         // PDWORD
        ULONGLONG Ordinal;
        ULONGLONG AddressOfData;    // PIMAGE_IMPORT_BY_NAME
    }
    _inner_union u1;
}

alias IMAGE_THUNK_DATA64 * PIMAGE_THUNK_DATA64;

struct IMAGE_THUNK_DATA32 {
    union _inner_union {
        DWORD ForwarderString;      // PBYTE
        DWORD Function;             // PDWORD
        DWORD Ordinal;
        DWORD AddressOfData;        // PIMAGE_IMPORT_BY_NAME
    } 
	_inner_union u1;
}

alias IMAGE_THUNK_DATA32 * PIMAGE_THUNK_DATA32;

const auto IMAGE_ORDINAL_FLAG64  = 0x8000000000000000;
const auto IMAGE_ORDINAL_FLAG32  = 0x80000000;
//const auto IMAGE_ORDINAL64(Ordinal)  = (Ordinal & 0xffff);
//const auto IMAGE_ORDINAL32(Ordinal)  = (Ordinal & 0xffff);
//const auto IMAGE_SNAP_BY_ORDINAL64(Ordinal)  = ((Ordinal & IMAGE_ORDINAL_FLAG64) != 0);
//const auto IMAGE_SNAP_BY_ORDINAL32(Ordinal)  = ((Ordinal & IMAGE_ORDINAL_FLAG32) != 0);

//
// Thread Local Storage
//

alias VOID function(PVOID DllHandle, DWORD Reason, PVOID Reserved) PIMAGE_TLS_CALLBACK;

struct IMAGE_TLS_DIRECTORY64 {
    ULONGLONG   StartAddressOfRawData;
    ULONGLONG   EndAddressOfRawData;
    ULONGLONG   AddressOfIndex;         // PDWORD
    ULONGLONG   AddressOfCallBacks;     // PIMAGE_TLS_CALLBACK *;
    DWORD   SizeOfZeroFill;
    DWORD   Characteristics;
}

alias IMAGE_TLS_DIRECTORY64 * PIMAGE_TLS_DIRECTORY64;

struct IMAGE_TLS_DIRECTORY32 {
    DWORD   StartAddressOfRawData;
    DWORD   EndAddressOfRawData;
    DWORD   AddressOfIndex;             // PDWORD
    DWORD   AddressOfCallBacks;         // PIMAGE_TLS_CALLBACK *
    DWORD   SizeOfZeroFill;
    DWORD   Characteristics;
}

alias IMAGE_TLS_DIRECTORY32 * PIMAGE_TLS_DIRECTORY32;

version(X86_64) {
	const auto IMAGE_ORDINAL_FLAG               = IMAGE_ORDINAL_FLAG64;
	alias IMAGE_THUNK_DATA64              IMAGE_THUNK_DATA;
	alias PIMAGE_THUNK_DATA64             PIMAGE_THUNK_DATA;
	alias IMAGE_TLS_DIRECTORY64           IMAGE_TLS_DIRECTORY;
	alias PIMAGE_TLS_DIRECTORY64          PIMAGE_TLS_DIRECTORY;
}
else {
	const auto IMAGE_ORDINAL_FLAG               = IMAGE_ORDINAL_FLAG32;
	alias IMAGE_THUNK_DATA32              IMAGE_THUNK_DATA;
	alias PIMAGE_THUNK_DATA32             PIMAGE_THUNK_DATA;
	alias IMAGE_TLS_DIRECTORY32           IMAGE_TLS_DIRECTORY;
	alias PIMAGE_TLS_DIRECTORY32          PIMAGE_TLS_DIRECTORY;
}

struct IMAGE_IMPORT_DESCRIPTOR {
    union _inner_union {
        DWORD   Characteristics;            // 0 for terminating null import descriptor
        DWORD   OriginalFirstThunk;         // RVA to original unbound IAT (PIMAGE_THUNK_DATA)
    }
    _inner_union fields;
    DWORD   TimeDateStamp;                  // 0 if not bound,
                                            // -1 if bound, and real date\time stamp
                                            //     in IMAGE_DIRECTORY_ENTRY_BOUND_IMPORT (new BIND)
                                            // O.W. date/time stamp of DLL bound to (Old BIND)

    DWORD   ForwarderChain;                 // -1 if no forwarders
    DWORD   Name;
    DWORD   FirstThunk;                     // RVA to IAT (if bound this IAT has actual addresses)
}

alias IMAGE_IMPORT_DESCRIPTOR  *PIMAGE_IMPORT_DESCRIPTOR;

//
// New format import descriptors pointed to by DataDirectory[ IMAGE_DIRECTORY_ENTRY_BOUND_IMPORT ]
//

struct IMAGE_BOUND_IMPORT_DESCRIPTOR {
    DWORD   TimeDateStamp;
    WORD    OffsetModuleName;
    WORD    NumberOfModuleForwarderRefs;
// Array of zero or more IMAGE_BOUND_FORWARDER_REF follows
}

alias IMAGE_BOUND_IMPORT_DESCRIPTOR* PIMAGE_BOUND_IMPORT_DESCRIPTOR;

struct IMAGE_BOUND_FORWARDER_REF {
    DWORD   TimeDateStamp;
    WORD    OffsetModuleName;
    WORD    Reserved;
}

alias IMAGE_BOUND_FORWARDER_REF* PIMAGE_BOUND_FORWARDER_REF;

//
// Resource Format.
//

//
// Resource directory consists of two counts, following by a variable length
// array of directory entries.  The first count is the number of entries at
// beginning of the array that have actual names associated with each entry.
// The entries are in ascending order, case insensitive strings.  The second
// count is the number of entries that immediately follow the named entries.
// This second count identifies the number of entries that have 16-bit integer
// Ids as their name.  These entries are also sorted in ascending order.
//
// This structure allows fast lookup by either name or number, but for any
// given resource entry only one form of lookup is supported, not both.
// This is consistant with the syntax of the .RC file and the .RES file.
//

struct IMAGE_RESOURCE_DIRECTORY {
    DWORD   Characteristics;
    DWORD   TimeDateStamp;
    WORD    MajorVersion;
    WORD    MinorVersion;
    WORD    NumberOfNamedEntries;
    WORD    NumberOfIdEntries;
//  IMAGE_RESOURCE_DIRECTORY_ENTRY DirectoryEntries[];
}

alias IMAGE_RESOURCE_DIRECTORY* PIMAGE_RESOURCE_DIRECTORY;

const auto IMAGE_RESOURCE_NAME_IS_STRING         = 0x80000000;
const auto IMAGE_RESOURCE_DATA_IS_DIRECTORY      = 0x80000000;
//
// Each directory contains the 32-bit Name of the entry and an offset,
// relative to the beginning of the resource directory of the data associated
// with this directory entry.  If the name of the entry is an actual text
// string instead of an integer Id, then the high order bit of the name field
// is set to one and the low order 31-bits are an offset, relative to the
// beginning of the resource directory of the string, which is of type
// IMAGE_RESOURCE_DIRECTORY_STRING.  Otherwise the high bit is clear and the
// low-order 16-bits are the integer Id that identify this resource directory
// entry. If the directory entry is yet another resource directory (i.e. a
// subdirectory), then the high order bit of the offset field will be
// set to indicate this.  Otherwise the high bit is clear and the offset
// field points to a resource data entry.
//

struct IMAGE_RESOURCE_DIRECTORY_ENTRY {
    union _inner_union {
    	DWORD NameOffset() {
    		return Name & ((1 << 31) - 1);
    	}
    	DWORD NameIsString() {
    		return Name & 0x80000000;
    	}
        DWORD   Name;
        WORD    Id;
    }
    _inner_union name;
    union _inner_union2{
        DWORD   OffsetToData;
    	DWORD OffsetToDirectory() {
    		return Name & ((1 << 31) - 1);
    	}
    	DWORD DataIsDirectory() {
    		return Name & 0x80000000;
    	}
    }
    _inner_union2 data;
}

alias IMAGE_RESOURCE_DIRECTORY_ENTRY* PIMAGE_RESOURCE_DIRECTORY_ENTRY;

//
// For resource directory entries that have actual string names, the Name
// field of the directory entry points to an object of the following type.
// All of these string objects are stored together after the last resource
// directory entry and before the first resource data object.  This minimizes
// the impact of these variable length objects on the alignment of the fixed
// size directory entry objects.
//

struct IMAGE_RESOURCE_DIRECTORY_STRING {
    WORD    Length;
    CHAR[1]    NameString;
}

alias IMAGE_RESOURCE_DIRECTORY_STRING* PIMAGE_RESOURCE_DIRECTORY_STRING;


struct IMAGE_RESOURCE_DIR_STRING_U {
    WORD    Length;
    WCHAR[1]   NameString;
}

alias IMAGE_RESOURCE_DIR_STRING_U* PIMAGE_RESOURCE_DIR_STRING_U;


//
// Each resource data entry describes a leaf node in the resource directory
// tree.  It contains an offset, relative to the beginning of the resource
// directory of the data for the resource, a size field that gives the number
// of bytes of data at that offset, a CodePage that should be used when
// decoding code point values within the resource data.  Typically for new
// applications the code page would be the unicode code page.
//

struct IMAGE_RESOURCE_DATA_ENTRY {
    DWORD   OffsetToData;
    DWORD   Size;
    DWORD   CodePage;
    DWORD   Reserved;
}

alias IMAGE_RESOURCE_DATA_ENTRY* PIMAGE_RESOURCE_DATA_ENTRY;

//
// Load Configuration Directory Entry
//

struct IMAGE_LOAD_CONFIG_DIRECTORY32 {
    DWORD   Size;
    DWORD   TimeDateStamp;
    WORD    MajorVersion;
    WORD    MinorVersion;
    DWORD   GlobalFlagsClear;
    DWORD   GlobalFlagsSet;
    DWORD   CriticalSectionDefaultTimeout;
    DWORD   DeCommitFreeBlockThreshold;
    DWORD   DeCommitTotalFreeThreshold;
    DWORD   LockPrefixTable;            // VA
    DWORD   MaximumAllocationSize;
    DWORD   VirtualMemoryThreshold;
    DWORD   ProcessHeapFlags;
    DWORD   ProcessAffinityMask;
    WORD    CSDVersion;
    WORD    Reserved1;
    DWORD   EditList;                   // VA
    DWORD   SecurityCookie;             // VA
    DWORD   SEHandlerTable;             // VA
    DWORD   SEHandlerCount;
}

alias IMAGE_LOAD_CONFIG_DIRECTORY32* PIMAGE_LOAD_CONFIG_DIRECTORY32;

struct IMAGE_LOAD_CONFIG_DIRECTORY64 {
    DWORD      Size;
    DWORD      TimeDateStamp;
    WORD       MajorVersion;
    WORD       MinorVersion;
    DWORD      GlobalFlagsClear;
    DWORD      GlobalFlagsSet;
    DWORD      CriticalSectionDefaultTimeout;
    ULONGLONG  DeCommitFreeBlockThreshold;
    ULONGLONG  DeCommitTotalFreeThreshold;
    ULONGLONG  LockPrefixTable;         // VA
    ULONGLONG  MaximumAllocationSize;
    ULONGLONG  VirtualMemoryThreshold;
    ULONGLONG  ProcessAffinityMask;
    DWORD      ProcessHeapFlags;
    WORD       CSDVersion;
    WORD       Reserved1;
    ULONGLONG  EditList;                // VA
    ULONGLONG  SecurityCookie;          // VA
    ULONGLONG  SEHandlerTable;          // VA
    ULONGLONG  SEHandlerCount;
}

alias IMAGE_LOAD_CONFIG_DIRECTORY64* PIMAGE_LOAD_CONFIG_DIRECTORY64;

version(X86_64) {
	alias IMAGE_LOAD_CONFIG_DIRECTORY64     IMAGE_LOAD_CONFIG_DIRECTORY;
	alias PIMAGE_LOAD_CONFIG_DIRECTORY64    PIMAGE_LOAD_CONFIG_DIRECTORY;
}
else {
	alias IMAGE_LOAD_CONFIG_DIRECTORY32     IMAGE_LOAD_CONFIG_DIRECTORY;
	alias PIMAGE_LOAD_CONFIG_DIRECTORY32    PIMAGE_LOAD_CONFIG_DIRECTORY;
}

//
// WIN CE Exception table format
//

//
// Function table entry format.  Function table is pointed to by the
// IMAGE_DIRECTORY_ENTRY_EXCEPTION directory entry.
//
/*
struct IMAGE_CE_RUNTIME_FUNCTION_ENTRY {
    DWORD FuncStart;
    DWORD PrologLen : 8;
    DWORD FuncLen : 22;
    DWORD ThirtyTwoBit : 1;
    DWORD ExceptionFlag : 1;
}

alias IMAGE_CE_RUNTIME_FUNCTION_ENTRY*  PIMAGE_CE_RUNTIME_FUNCTION_ENTRY;
*/
struct IMAGE_ALPHA64_RUNTIME_FUNCTION_ENTRY {
    ULONGLONG BeginAddress;
    ULONGLONG EndAddress;
    ULONGLONG ExceptionHandler;
    ULONGLONG HandlerData;
    ULONGLONG PrologEndAddress;
}

alias IMAGE_ALPHA64_RUNTIME_FUNCTION_ENTRY* PIMAGE_ALPHA64_RUNTIME_FUNCTION_ENTRY;

struct IMAGE_ALPHA_RUNTIME_FUNCTION_ENTRY {
    DWORD BeginAddress;
    DWORD EndAddress;
    DWORD ExceptionHandler;
    DWORD HandlerData;
    DWORD PrologEndAddress;
}

alias IMAGE_ALPHA_RUNTIME_FUNCTION_ENTRY* PIMAGE_ALPHA_RUNTIME_FUNCTION_ENTRY;

struct _IMAGE_RUNTIME_FUNCTION_ENTRY {
    DWORD BeginAddress;
    DWORD EndAddress;
    DWORD UnwindInfoAddress;
}

alias _IMAGE_RUNTIME_FUNCTION_ENTRY* _PIMAGE_RUNTIME_FUNCTION_ENTRY;

alias  _IMAGE_RUNTIME_FUNCTION_ENTRY  IMAGE_IA64_RUNTIME_FUNCTION_ENTRY;
alias _PIMAGE_RUNTIME_FUNCTION_ENTRY PIMAGE_IA64_RUNTIME_FUNCTION_ENTRY;

alias  _IMAGE_RUNTIME_FUNCTION_ENTRY  IMAGE_RUNTIME_FUNCTION_ENTRY;
alias _PIMAGE_RUNTIME_FUNCTION_ENTRY PIMAGE_RUNTIME_FUNCTION_ENTRY;

//
// Debug Format
//

struct IMAGE_DEBUG_DIRECTORY {
    DWORD   Characteristics;
    DWORD   TimeDateStamp;
    WORD    MajorVersion;
    WORD    MinorVersion;
    DWORD   Type;
    DWORD   SizeOfData;
    DWORD   AddressOfRawData;
    DWORD   PointerToRawData;
}

alias IMAGE_DEBUG_DIRECTORY* PIMAGE_DEBUG_DIRECTORY;

const auto IMAGE_DEBUG_TYPE_UNKNOWN           = 0;
const auto IMAGE_DEBUG_TYPE_COFF              = 1;
const auto IMAGE_DEBUG_TYPE_CODEVIEW          = 2;
const auto IMAGE_DEBUG_TYPE_FPO               = 3;
const auto IMAGE_DEBUG_TYPE_MISC              = 4;
const auto IMAGE_DEBUG_TYPE_EXCEPTION         = 5;
const auto IMAGE_DEBUG_TYPE_FIXUP             = 6;
const auto IMAGE_DEBUG_TYPE_OMAP_TO_SRC       = 7;
const auto IMAGE_DEBUG_TYPE_OMAP_FROM_SRC     = 8;
const auto IMAGE_DEBUG_TYPE_BORLAND           = 9;
const auto IMAGE_DEBUG_TYPE_RESERVED10        = 10;
const auto IMAGE_DEBUG_TYPE_CLSID             = 11;


struct IMAGE_COFF_SYMBOLS_HEADER {
    DWORD   NumberOfSymbols;
    DWORD   LvaToFirstSymbol;
    DWORD   NumberOfLinenumbers;
    DWORD   LvaToFirstLinenumber;
    DWORD   RvaToFirstByteOfCode;
    DWORD   RvaToLastByteOfCode;
    DWORD   RvaToFirstByteOfData;
    DWORD   RvaToLastByteOfData;
}

alias IMAGE_COFF_SYMBOLS_HEADER* PIMAGE_COFF_SYMBOLS_HEADER;

const auto FRAME_FPO        = 0;
const auto FRAME_TRAP       = 1;
const auto FRAME_TSS        = 2;
const auto FRAME_NONFPO     = 3;

struct FPO_DATA {
    DWORD       ulOffStart;             // offset 1st byte of function code
    DWORD       cbProcSize;             // # bytes in function
    DWORD       cdwLocals;              // # bytes in locals/4
    WORD        cdwParams;              // # bytes in params/4
    WORD flags;
    
    WORD cbProlog() {
    	return flags & 0xff;
    }
    
    WORD cbRegs() {
    	return (flags >> 8) & 0x7;
    }
    
    WORD fHasSEH() {
    	return (flags >> 11) & 1;
    }
    
    WORD fUseBP() {
    	return (flags >> 12) & 1;
    }

    WORD reserved() {
    	return (flags >> 13) & 1;
    }
    
    WORD cbFrame() {
    	return (flags >> 14) & 3;
    }
}

alias FPO_DATA* PFPO_DATA;
const auto SIZEOF_RFPO_DATA  = 16;


const auto IMAGE_DEBUG_MISC_EXENAME     = 1;

struct IMAGE_DEBUG_MISC {
    DWORD       DataType;               // type of misc data, see defines
    DWORD       Length;                 // total length of record, rounded to four
                                        // byte multiple.
    BOOLEAN     Unicode;                // TRUE if data is unicode string
    BYTE        Reserved[ 3 ];
    BYTE        Data[ 1 ];              // Actual data
}

alias IMAGE_DEBUG_MISC* PIMAGE_DEBUG_MISC;


//
// Function table extracted from MIPS/ALPHA/IA64 images.  Does not contain
// information needed only for runtime support.  Just those fields for
// each entry needed by a debugger.
//

struct IMAGE_FUNCTION_ENTRY {
    DWORD   StartingAddress;
    DWORD   EndingAddress;
    DWORD   EndOfPrologue;
}

alias IMAGE_FUNCTION_ENTRY* PIMAGE_FUNCTION_ENTRY;

struct IMAGE_FUNCTION_ENTRY64 {
    ULONGLONG   StartingAddress;
    ULONGLONG   EndingAddress;
    union _inner_union {
        ULONGLONG   EndOfPrologue;
        ULONGLONG   UnwindInfoAddress;
    }
    _inner_union fields;
}

alias IMAGE_FUNCTION_ENTRY64* PIMAGE_FUNCTION_ENTRY64;

//
// Debugging information can be stripped from an image file and placed
// in a separate .DBG file, whose file name part is the same as the
// image file name part (e.g. symbols for CMD.EXE could be stripped
// and placed in CMD.DBG).  This is indicated by the IMAGE_FILE_DEBUG_STRIPPED
// flag in the Characteristics field of the file header.  The beginning of
// the .DBG file contains the following structure which captures certain
// information from the image file.  This allows a debug to proceed even if
// the original image file is not accessable.  This header is followed by
// zero of more IMAGE_SECTION_HEADER structures, followed by zero or more
// IMAGE_DEBUG_DIRECTORY structures.  The latter structures and those in
// the image file contain file offsets relative to the beginning of the
// .DBG file.
//
// If symbols have been stripped from an image, the IMAGE_DEBUG_MISC structure
// is left in the image file, but not mapped.  This allows a debugger to
// compute the name of the .DBG file, from the name of the image in the
// IMAGE_DEBUG_MISC structure.
//

struct IMAGE_SEPARATE_DEBUG_HEADER {
    WORD        Signature;
    WORD        Flags;
    WORD        Machine;
    WORD        Characteristics;
    DWORD       TimeDateStamp;
    DWORD       CheckSum;
    DWORD       ImageBase;
    DWORD       SizeOfImage;
    DWORD       NumberOfSections;
    DWORD       ExportedNamesSize;
    DWORD       DebugDirectorySize;
    DWORD       SectionAlignment;
    DWORD       Reserved[2];
}

alias IMAGE_SEPARATE_DEBUG_HEADER* PIMAGE_SEPARATE_DEBUG_HEADER;

struct NON_PAGED_DEBUG_INFO {
    WORD        Signature;
    WORD        Flags;
    DWORD       Size;
    WORD        Machine;
    WORD        Characteristics;
    DWORD       TimeDateStamp;
    DWORD       CheckSum;
    DWORD       SizeOfImage;
    ULONGLONG   ImageBase;
    //DebugDirectorySize
    //IMAGE_DEBUG_DIRECTORY
}

alias NON_PAGED_DEBUG_INFO* PNON_PAGED_DEBUG_INFO;

const auto IMAGE_SEPARATE_DEBUG_SIGNATURE  = 0x4944;
const auto NON_PAGED_DEBUG_SIGNATURE       = 0x494E;

const auto IMAGE_SEPARATE_DEBUG_FLAGS_MASK  = 0x8000;
const auto IMAGE_SEPARATE_DEBUG_MISMATCH    = 0x8000  ; // when DBG was updated, the
                                                // old checksum didn't match.

//
//  The .arch section is made up of headers, each describing an amask position/value
//  pointing to an array of IMAGE_ARCHITECTURE_ENTRY's.  Each "array" (both the header
//  and entry arrays) are terminiated by a quadword of 0xffffffffL.
//
//  NOTE: There may be quadwords of 0 sprinkled around and must be skipped.
//
/*
struct IMAGE_ARCHITECTURE_HEADER {
    unsigned int AmaskValue: 1;                 // 1 -> code section depends on mask bit
                                                // 0 -> new instruction depends on mask bit
    int :7;                                     // MBZ
    unsigned int AmaskShift: 8;                 // Amask bit in question for this fixup
    int :16;                                    // MBZ
    DWORD FirstEntryRVA;                        // RVA into .arch section to array of ARCHITECTURE_ENTRY's
}
alias IMAGE_ARCHITECTURE_HEADER* PIMAGE_ARCHITECTURE_HEADER;
+/

struct IMAGE_ARCHITECTURE_ENTRY {
    DWORD FixupInstRVA;                         // RVA of instruction to fixup
    DWORD NewInst;                              // fixup instruction (see alphaops.h)
}

alias IMAGE_ARCHITECTURE_ENTRY* PIMAGE_ARCHITECTURE_ENTRY;


// The following structure defines the new import object.  Note the values of the first two fields,
// which must be set as stated in order to differentiate old and new import members.
// Following this structure, the linker emits two null-terminated strings used to recreate the
// import at the time of use.  The first string is the import's name, the second is the dll's name.

const auto IMPORT_OBJECT_HDR_SIG2   = 0xffff;
/*
struct IMPORT_OBJECT_HEADER {
    WORD    Sig1;                       // Must be IMAGE_FILE_MACHINE_UNKNOWN
    WORD    Sig2;                       // Must be IMPORT_OBJECT_HDR_SIG2.
    WORD    Version;
    WORD    Machine;
    DWORD   TimeDateStamp;              // Time/date stamp
    DWORD   SizeOfData;                 // particularly useful for incremental links

    union _inner_union{
        WORD    Ordinal;                // if grf & IMPORT_OBJECT_ORDINAL
        WORD    Hint;
    }
    _inner_union fields;

    WORD flags;

    //WORD    Type : 2;                   // IMPORT_TYPE
    //WORD    NameType : 3;               // IMPORT_NAME_TYPE
    //WORD    Reserved : 11;              // Reserved. Must be zero.

}*/

enum IMPORT_OBJECT_TYPE {
    IMPORT_OBJECT_CODE = 0,
    IMPORT_OBJECT_DATA = 1,
    IMPORT_OBJECT_CONST = 2,
}

enum IMPORT_OBJECT_NAME_TYPE {
    IMPORT_OBJECT_ORDINAL = 0,          // Import by ordinal
    IMPORT_OBJECT_NAME = 1,             // Import name == public symbol name.
    IMPORT_OBJECT_NAME_NO_PREFIX = 2,   // Import name == public symbol name skipping leading ?, @, or optionally _.
    IMPORT_OBJECT_NAME_UNDECORATE = 3,  // Import name == public symbol name skipping leading ?, @, or optionally _
                                        // and truncating at first @
}



enum ReplacesCorHdrNumericDefines {
// COM+ Header entry point flags.
    COMIMAGE_FLAGS_ILONLY               =0x00000001,
    COMIMAGE_FLAGS_32BITREQUIRED        =0x00000002,
    COMIMAGE_FLAGS_IL_LIBRARY           =0x00000004,
    COMIMAGE_FLAGS_STRONGNAMESIGNED     =0x00000008,
    COMIMAGE_FLAGS_TRACKDEBUGDATA       =0x00010000,

// Version flags for image.
    COR_VERSION_MAJOR_V2                =2,
    COR_VERSION_MAJOR                   =COR_VERSION_MAJOR_V2,
    COR_VERSION_MINOR                   =0,
    COR_DELETED_NAME_LENGTH             =8,
    COR_VTABLEGAP_NAME_LENGTH           =8,

// Maximum size of a NativeType descriptor.
    NATIVE_TYPE_MAX_CB                  =1,
    COR_ILMETHOD_SECT_SMALL_MAX_DATASIZE=0xFF,

// #defines for the MIH FLAGS
    IMAGE_COR_MIH_METHODRVA             =0x01,
    IMAGE_COR_MIH_EHRVA                 =0x02,
    IMAGE_COR_MIH_BASICBLOCK            =0x08,

// V-table constants
    COR_VTABLE_32BIT                    =0x01,          // V-table slots are 32-bits in size.
    COR_VTABLE_64BIT                    =0x02,          // V-table slots are 64-bits in size.
    COR_VTABLE_FROM_UNMANAGED           =0x04,          // If set, transition from unmanaged.
    COR_VTABLE_FROM_UNMANAGED_RETAIN_APPDOMAIN  =0x08,  // If set, transition from unmanaged with keeping the current appdomain.
    COR_VTABLE_CALL_MOST_DERIVED        =0x10,          // Call most derived method described by

// EATJ constants
    IMAGE_COR_EATJ_THUNK_SIZE           =32,            // Size of a jump thunk reserved range.

// Max name lengths
    //@todo: Change to unlimited name lengths.
    MAX_CLASS_NAME                      =1024,
    MAX_PACKAGE_NAME                    =1024,
}

// CLR 2.0 header structure.
struct SLIST_ENTRY {
    SLIST_ENTRY* Next;
}

version(X86_64) {
	align(16) union SLIST_HEADER {
	    struct _inner_struct {  // original struct
	        ULONGLONG Alignment;
	        ULONGLONG Region;
	    }
	    _inner_struct original;

	    struct _inner_struct2 {  // 8-byte header
	     /*   ULONGLONG Depth:16;
	        ULONGLONG Sequence:9;
	        ULONGLONG NextEntry:39;
	        ULONGLONG HeaderType:1; // 0: 8-byte; 1: 16-byte
	        ULONGLONG Init:1;       // 0: uninitialized; 1: initialized
	        ULONGLONG Reserved:59;
	        ULONGLONG Region:3;
	        
	        */
	    }
		_inner_struct2 Header8;

	    struct _inner_struct3 {  // 16-byte header
	        /*ULONGLONG Depth:16;
	        ULONGLONG Sequence:48;
	        ULONGLONG HeaderType:1; // 0: 8-byte; 1: 16-byte
	        ULONGLONG Init:1;       // 0: uninitialized; 1: initialized
	        ULONGLONG Reserved:2;
	        ULONGLONG NextEntry:60; // last 4 bits are always 0's
	        */
	    }
		_inner_struct3 Header16;
	}

}
else {

	union SLIST_HEADER {
	    ULONGLONG Alignment;
	    struct _inner_struct {
	        SLIST_ENTRY Next;
	        WORD   Depth;
	        WORD   Sequence;
	    }
	    _inner_struct fields;
	}

}

alias SLIST_ENTRY* PSLIST_ENTRY;
alias SLIST_HEADER* PSLIST_HEADER;

VOID

RtlInitializeSListHead (
     PSLIST_HEADER ListHead
    );


PSLIST_ENTRY

RtlFirstEntrySList (
	SLIST_HEADER *ListHead
    );


PSLIST_ENTRY

RtlInterlockedPopEntrySList (
     PSLIST_HEADER ListHead
    );


PSLIST_ENTRY

RtlInterlockedPushEntrySList (
     PSLIST_HEADER ListHead,
     PSLIST_ENTRY ListEntry
    );


PSLIST_ENTRY

RtlInterlockedFlushSList (
     PSLIST_HEADER ListHead
    );


WORD  

RtlQueryDepthSList (
     PSLIST_HEADER ListHead
    );

// begin_ntddk

//
// Run once
//

const auto RTL_RUN_ONCE_INIT = RTL_RUN_ONCE.init;   // Static initializer

//
// Run once flags
//

const auto RTL_RUN_ONCE_CHECK_ONLY      = 0x00000001UL;
const auto RTL_RUN_ONCE_ASYNC           = 0x00000002UL;
const auto RTL_RUN_ONCE_INIT_FAILED     = 0x00000004UL;

//
// The context stored in the run once structure must leave the following number
// of low order bits unused.
//

const auto RTL_RUN_ONCE_CTX_RESERVED_BITS  = 2;


union RTL_RUN_ONCE {
    PVOID Ptr;
}

alias RTL_RUN_ONCE* PRTL_RUN_ONCE;

alias DWORD function(PRTL_RUN_ONCE RunOnce, PVOID Parameter, PVOID* Context) PRTL_RUN_ONCE_INIT_FN;

VOID
RtlRunOnceInitialize (
     PRTL_RUN_ONCE RunOnce
    );

DWORD
RtlRunOnceExecuteOnce (
    PRTL_RUN_ONCE RunOnce,
      PRTL_RUN_ONCE_INIT_FN InitFn,
     PVOID Parameter,
     PVOID *Context
    );

DWORD
RtlRunOnceBeginInitialize (
    PRTL_RUN_ONCE RunOnce,
     DWORD Flags,
     PVOID *Context
    );

DWORD
RtlRunOnceComplete (
    PRTL_RUN_ONCE RunOnce,
     DWORD Flags,
     PVOID Context
    );

const auto HEAP_NO_SERIALIZE                = 0x00000001      ;
const auto HEAP_GROWABLE                    = 0x00000002      ;
const auto HEAP_GENERATE_EXCEPTIONS         = 0x00000004      ;
const auto HEAP_ZERO_MEMORY                 = 0x00000008      ;
const auto HEAP_REALLOC_IN_PLACE_ONLY       = 0x00000010      ;
const auto HEAP_TAIL_CHECKING_ENABLED       = 0x00000020      ;
const auto HEAP_FREE_CHECKING_ENABLED       = 0x00000040      ;
const auto HEAP_DISABLE_COALESCE_ON_FREE    = 0x00000080      ;
const auto HEAP_CREATE_ALIGN_16             = 0x00010000      ;
const auto HEAP_CREATE_ENABLE_TRACING       = 0x00020000      ;
const auto HEAP_CREATE_ENABLE_EXECUTE       = 0x00040000      ;
const auto HEAP_MAXIMUM_TAG                 = 0x0FFF              ;
const auto HEAP_PSEUDO_TAG_FLAG             = 0x8000              ;
const auto HEAP_TAG_SHIFT                   = 18                  ;

WORD

RtlCaptureStackBackTrace(
     DWORD FramesToSkip,
     DWORD FramesToCapture,
    PVOID *BackTrace,
     PDWORD BackTraceHash
   );

VOID

RtlCaptureContext (
     CONTEXT* ContextRecord
    );


const auto IS_TEXT_UNICODE_ASCII16                = 0x0001;
const auto IS_TEXT_UNICODE_REVERSE_ASCII16        = 0x0010;

const auto IS_TEXT_UNICODE_STATISTICS             = 0x0002;
const auto IS_TEXT_UNICODE_REVERSE_STATISTICS     = 0x0020;

const auto IS_TEXT_UNICODE_CONTROLS               = 0x0004;
const auto IS_TEXT_UNICODE_REVERSE_CONTROLS       = 0x0040;

const auto IS_TEXT_UNICODE_SIGNATURE              = 0x0008;
const auto IS_TEXT_UNICODE_REVERSE_SIGNATURE      = 0x0080;

const auto IS_TEXT_UNICODE_ILLEGAL_CHARS          = 0x0100;
const auto IS_TEXT_UNICODE_ODD_LENGTH             = 0x0200;
const auto IS_TEXT_UNICODE_DBCS_LEADBYTE          = 0x0400;
const auto IS_TEXT_UNICODE_NULL_BYTES             = 0x1000;

const auto IS_TEXT_UNICODE_UNICODE_MASK           = 0x000F;
const auto IS_TEXT_UNICODE_REVERSE_MASK           = 0x00F0;
const auto IS_TEXT_UNICODE_NOT_UNICODE_MASK       = 0x0F00;
const auto IS_TEXT_UNICODE_NOT_ASCII_MASK         = 0xF000;

const auto COMPRESSION_FORMAT_NONE           = (0x0000)   ;
const auto COMPRESSION_FORMAT_DEFAULT        = (0x0001)   ;
const auto COMPRESSION_FORMAT_LZNT1          = (0x0002)   ;
const auto COMPRESSION_ENGINE_STANDARD       = (0x0000)   ;
const auto COMPRESSION_ENGINE_MAXIMUM        = (0x0100)   ;
const auto COMPRESSION_ENGINE_HIBER          = (0x0200)   ;


SIZE_T

RtlCompareMemory (
    VOID *Source1,
    VOID *Source2,
    SIZE_T Length
    );

void RtlMoveMemory(void* Destination, void* Source, size_t Length) {
	memmove(Destination, Source, Length);
}

void RtlCopyMemory(void* Destination, void* Source, size_t Length) {
	memcpy(Destination, Source, Length);
}

bool RtlEqualMemory(void* Destination, void* Source, size_t Length) {
	return !memcmp(Destination, Source, Length);
}

void RtlFillMemory(void* Destination, size_t Length, UCHAR Fill) {
	memset(Destination, Fill, Length);
}

void RtlZeroMemory(void* Destination, size_t Length) {
	memset(Destination, 0, Length);
}


const auto SEF_DACL_AUTO_INHERIT              = 0x01;
const auto SEF_SACL_AUTO_INHERIT              = 0x02;
const auto SEF_DEFAULT_DESCRIPTOR_FOR_OBJECT  = 0x04;
const auto SEF_AVOID_PRIVILEGE_CHECK          = 0x08;
const auto SEF_AVOID_OWNER_CHECK              = 0x10;
const auto SEF_DEFAULT_OWNER_FROM_PARENT      = 0x20;
const auto SEF_DEFAULT_GROUP_FROM_PARENT      = 0x40;
const auto SEF_MACL_NO_WRITE_UP               = 0x100;
const auto SEF_MACL_NO_READ_UP                = 0x200;
const auto SEF_MACL_NO_EXECUTE_UP             = 0x400;
const auto SEF_AVOID_OWNER_RESTRICTION        = 0x1000;

const auto SEF_MACL_VALID_FLAGS               = (SEF_MACL_NO_WRITE_UP   |
                                           SEF_MACL_NO_READ_UP    |
                                           SEF_MACL_NO_EXECUTE_UP);


struct MESSAGE_RESOURCE_ENTRY {
    WORD   Length;
    WORD   Flags;
    BYTE  Text[ 1 ];
}

alias MESSAGE_RESOURCE_ENTRY* PMESSAGE_RESOURCE_ENTRY;

const auto MESSAGE_RESOURCE_UNICODE  = 0x0001;

struct MESSAGE_RESOURCE_BLOCK {
    DWORD LowId;
    DWORD HighId;
    DWORD OffsetToEntries;
}

alias MESSAGE_RESOURCE_BLOCK* PMESSAGE_RESOURCE_BLOCK;

struct MESSAGE_RESOURCE_DATA {
    DWORD NumberOfBlocks;
    MESSAGE_RESOURCE_BLOCK Blocks[ 1 ];
}

alias MESSAGE_RESOURCE_DATA* PMESSAGE_RESOURCE_DATA;

struct OSVERSIONINFOA {
    DWORD dwOSVersionInfoSize;
    DWORD dwMajorVersion;
    DWORD dwMinorVersion;
    DWORD dwBuildNumber;
    DWORD dwPlatformId;
    CHAR   szCSDVersion[ 128 ];     // Maintenance string for PSS usage
}

alias OSVERSIONINFOA* POSVERSIONINFOA;
alias OSVERSIONINFOA* LPOSVERSIONINFOA;

struct OSVERSIONINFOW {
    DWORD dwOSVersionInfoSize;
    DWORD dwMajorVersion;
    DWORD dwMinorVersion;
    DWORD dwBuildNumber;
    DWORD dwPlatformId;
    WCHAR  szCSDVersion[ 128 ];     // Maintenance string for PSS usage
}

alias OSVERSIONINFOW* POSVERSIONINFOW;
alias OSVERSIONINFOW* LPOSVERSIONINFOW;
alias OSVERSIONINFOW RTL_OSVERSIONINFOW;
alias OSVERSIONINFOW* PRTL_OSVERSIONINFOW;

version(UNICODE) {
	alias OSVERSIONINFOW OSVERSIONINFO;
	alias POSVERSIONINFOW POSVERSIONINFO;
	alias LPOSVERSIONINFOW LPOSVERSIONINFO;
}
else {
	alias OSVERSIONINFOA OSVERSIONINFO;
	alias POSVERSIONINFOA POSVERSIONINFO;
	alias LPOSVERSIONINFOA LPOSVERSIONINFO;
}

struct OSVERSIONINFOEXA {
    DWORD dwOSVersionInfoSize;
    DWORD dwMajorVersion;
    DWORD dwMinorVersion;
    DWORD dwBuildNumber;
    DWORD dwPlatformId;
    CHAR   szCSDVersion[ 128 ];     // Maintenance string for PSS usage
    WORD   wServicePackMajor;
    WORD   wServicePackMinor;
    WORD   wSuiteMask;
    BYTE  wProductType;
    BYTE  wReserved;
}

alias OSVERSIONINFOEXA* POSVERSIONINFOEXA;
alias OSVERSIONINFOEXA* LPOSVERSIONINFOEXA;
struct OSVERSIONINFOEXW {
    DWORD dwOSVersionInfoSize;
    DWORD dwMajorVersion;
    DWORD dwMinorVersion;
    DWORD dwBuildNumber;
    DWORD dwPlatformId;
    WCHAR  szCSDVersion[ 128 ];     // Maintenance string for PSS usage
    WORD   wServicePackMajor;
    WORD   wServicePackMinor;
    WORD   wSuiteMask;
    BYTE  wProductType;
    BYTE  wReserved;
}

alias OSVERSIONINFOEXW* POSVERSIONINFOEXW;
alias OSVERSIONINFOEXW* LPOSVERSIONINFOEXW;
alias OSVERSIONINFOEXW RTL_OSVERSIONINFOEXW;
alias OSVERSIONINFOEXW* PRTL_OSVERSIONINFOEXW;

version(UNICODE) {
	alias OSVERSIONINFOEXW OSVERSIONINFOEX;
	alias POSVERSIONINFOEXW POSVERSIONINFOEX;
	alias LPOSVERSIONINFOEXW LPOSVERSIONINFOEX;
}
else {
	alias OSVERSIONINFOEXA OSVERSIONINFOEX;
	alias POSVERSIONINFOEXA POSVERSIONINFOEX;
	alias LPOSVERSIONINFOEXA LPOSVERSIONINFOEX;
}

//
// RtlVerifyVersionInfo() conditions
//

const auto VER_EQUAL                        = 1;
const auto VER_GREATER                      = 2;
const auto VER_GREATER_EQUAL                = 3;
const auto VER_LESS                         = 4;
const auto VER_LESS_EQUAL                   = 5;
const auto VER_AND                          = 6;
const auto VER_OR                           = 7;

const auto VER_CONDITION_MASK               = 7;
const auto VER_NUM_BITS_PER_CONDITION_MASK  = 3;

//
// RtlVerifyVersionInfo() type mask bits
//

const auto VER_MINORVERSION                 = 0x0000001;
const auto VER_MAJORVERSION                 = 0x0000002;
const auto VER_BUILDNUMBER                  = 0x0000004;
const auto VER_PLATFORMID                   = 0x0000008;
const auto VER_SERVICEPACKMINOR             = 0x0000010;
const auto VER_SERVICEPACKMAJOR             = 0x0000020;
const auto VER_SUITENAME                    = 0x0000040;
const auto VER_PRODUCT_TYPE                 = 0x0000080;

//
// RtlVerifyVersionInfo() os product type values
//

const auto VER_NT_WORKSTATION               = 0x0000001;
const auto VER_NT_DOMAIN_CONTROLLER         = 0x0000002;
const auto VER_NT_SERVER                    = 0x0000003;

//
// dwPlatformId defines:
//

const auto VER_PLATFORM_WIN32s              = 0;
const auto VER_PLATFORM_WIN32_WINDOWS       = 1;
const auto VER_PLATFORM_WIN32_NT            = 2;


//
//
// VerifyVersionInfo() macro to set the condition mask
//
// For documentation sakes here's the old version of the macro that got
// changed to call an API
// #define VER_SET_CONDITION(_m_,_t_,_c_)  _m_=(_m_|(_c_<<(1<<_t_)))
//

/*const auto VER_SET_CONDITION(_m_,_t_,_c_)   = \;
        ((_m_)=VerSetConditionMask((_m_),(_t_),(_c_)))
*/

ULONGLONG

VerSetConditionMask(
          ULONGLONG   ConditionMask,
          DWORD   TypeMask,
          BYTE    Condition
        );

//


BOOLEAN

RtlGetProductInfo(
      DWORD  OSMajorVersion,
      DWORD  OSMinorVersion,
      DWORD  SpMajorVersion,
      DWORD  SpMinorVersion,
     PDWORD ReturnedProductType
    );

struct RTL_CRITICAL_SECTION_DEBUG {
    WORD   Type;
    WORD   CreatorBackTraceIndex;
    RTL_CRITICAL_SECTION *CriticalSection;
    LIST_ENTRY ProcessLocksList;
    DWORD EntryCount;
    DWORD ContentionCount;
    DWORD Flags;
    WORD   CreatorBackTraceIndexHigh;
    WORD   SpareWORD  ;
}

alias RTL_CRITICAL_SECTION_DEBUG* PRTL_CRITICAL_SECTION_DEBUG;
alias RTL_CRITICAL_SECTION_DEBUG RTL_RESOURCE_DEBUG;
alias RTL_CRITICAL_SECTION_DEBUG* PRTL_RESOURCE_DEBUG;

const auto RTL_CRITSECT_TYPE  = 0;
const auto RTL_RESOURCE_TYPE  = 1;

//
// These flags define the upper byte of the critical section SpinCount field
//
const auto RTL_CRITICAL_SECTION_FLAG_NO_DEBUG_INFO          = 0x01000000;
const auto RTL_CRITICAL_SECTION_FLAG_DYNAMIC_SPIN           = 0x02000000;
const auto RTL_CRITICAL_SECTION_FLAG_STATIC_INIT            = 0x04000000;
const auto RTL_CRITICAL_SECTION_ALL_FLAG_BITS               = 0xFF000000;
const auto RTL_CRITICAL_SECTION_FLAG_RESERVED               = (RTL_CRITICAL_SECTION_ALL_FLAG_BITS & (~(RTL_CRITICAL_SECTION_FLAG_NO_DEBUG_INFO | RTL_CRITICAL_SECTION_FLAG_DYNAMIC_SPIN | RTL_CRITICAL_SECTION_FLAG_STATIC_INIT)));

//
// These flags define possible values stored in the Flags field of a critsec debuginfo.
//
const auto RTL_CRITICAL_SECTION_DEBUG_FLAG_STATIC_INIT      = 0x00000001;

align(8) struct RTL_CRITICAL_SECTION {
    PRTL_CRITICAL_SECTION_DEBUG DebugInfo;

    //
    //  The following three fields control entering and exiting the critical
    //  section for the resource
    //

    LONG LockCount;
    LONG RecursionCount;
    HANDLE OwningThread;        // from the thread's ClientId->UniqueThread
    HANDLE LockSemaphore;
    ULONG_PTR SpinCount;        // force size on 64-bit systems when packed
}

alias RTL_CRITICAL_SECTION* PRTL_CRITICAL_SECTION;

struct RTL_SRWLOCK {
        PVOID Ptr;
}

alias RTL_SRWLOCK* PRTL_SRWLOCK;
const auto RTL_SRWLOCK_INIT  = RTL_SRWLOCK.init                            ;
struct RTL_CONDITION_VARIABLE {
        PVOID Ptr;
}

alias RTL_CONDITION_VARIABLE* PRTL_CONDITION_VARIABLE;
const auto RTL_CONDITION_VARIABLE_INIT  = RTL_CONDITION_VARIABLE.init                 ;
const auto RTL_CONDITION_VARIABLE_LOCKMODE_SHARED   = 0x1     ;

alias LONG function(EXCEPTION_POINTERS* ExceptionInfo) PVECTORED_EXCEPTION_HANDLER;

enum HEAP_INFORMATION_CLASS {

    HeapCompatibilityInformation,
    HeapEnableTerminationOnCorruption


}


const auto WT_EXECUTEDEFAULT        = 0x00000000                           ;
const auto WT_EXECUTEINIOTHREAD     = 0x00000001                           ;
const auto WT_EXECUTEINUITHREAD     = 0x00000002                           ;
const auto WT_EXECUTEINWAITTHREAD   = 0x00000004                           ;
const auto WT_EXECUTEONLYONCE       = 0x00000008                           ;
const auto WT_EXECUTEINTIMERTHREAD  = 0x00000020                           ;
const auto WT_EXECUTELONGFUNCTION   = 0x00000010                           ;
const auto WT_EXECUTEINPERSISTENTIOTHREAD   = 0x00000040                   ;
const auto WT_EXECUTEINPERSISTENTTHREAD  = 0x00000080                      ;
const auto WT_TRANSFER_IMPERSONATION  = 0x00000100                         ;
//const auto WT_SET_MAX_THREADPOOL_THREADS(Flags,  = Limit)  ((Flags) |= (Limit)<<16) ;
alias VOID function(PVOID, BOOLEAN) WAITORTIMERCALLBACKFUNC;
alias VOID function(PVOID) WORKERCALLBACKFUNC;
alias VOID function(DWORD, PVOID, PVOID) APC_CALLBACK_FUNCTION;
alias VOID function(PVOID lpFlsData) PFLS_CALLBACK_FUNCTION;

const auto WT_EXECUTEINLONGTHREAD   = 0x00000010                           ;
const auto WT_EXECUTEDELETEWAIT     = 0x00000008                           ;

enum ACTIVATION_CONTEXT_INFO_CLASS {
    ActivationContextBasicInformation                       = 1,
    ActivationContextDetailedInformation                    = 2,
    AssemblyDetailedInformationInActivationContext          = 3,
    FileInformationInAssemblyOfAssemblyInActivationContext  = 4,
    RunlevelInformationInActivationContext                  = 5,
    MaxActivationContextInfoClass,

    //
    // compatibility with old names
    //
    AssemblyDetailedInformationInActivationContxt           = 3,
    FileInformationInAssemblyOfAssemblyInActivationContxt   = 4
}

const auto ACTIVATIONCONTEXTINFOCLASS  = ACTIVATION_CONTEXT_INFO_CLASS;


struct ACTIVATION_CONTEXT_QUERY_INDEX {
    DWORD ulAssemblyIndex;
    DWORD ulFileIndexInAssembly;
}

alias ACTIVATION_CONTEXT_QUERY_INDEX*  PACTIVATION_CONTEXT_QUERY_INDEX;

alias ACTIVATION_CONTEXT_QUERY_INDEX* PCACTIVATION_CONTEXT_QUERY_INDEX;


const auto ACTIVATION_CONTEXT_PATH_TYPE_NONE  = (1);
const auto ACTIVATION_CONTEXT_PATH_TYPE_WIN32_FILE  = (2);
const auto ACTIVATION_CONTEXT_PATH_TYPE_URL  = (3);
const auto ACTIVATION_CONTEXT_PATH_TYPE_ASSEMBLYREF  = (4);

struct ASSEMBLY_FILE_DETAILED_INFORMATION {
    DWORD ulFlags;
    DWORD ulFilenameLength;
    DWORD ulPathLength;

    PCWSTR lpFileName;
    PCWSTR lpFilePath;
}

alias ASSEMBLY_FILE_DETAILED_INFORMATION* PASSEMBLY_FILE_DETAILED_INFORMATION;
alias ASSEMBLY_FILE_DETAILED_INFORMATION *PCASSEMBLY_FILE_DETAILED_INFORMATION;

//
// compatibility with old names
// The new names use "file" consistently.
//
const auto _ASSEMBLY_DLL_REDIRECTION_DETAILED_INFORMATION = ASSEMBLY_FILE_DETAILED_INFORMATION;
const auto ASSEMBLY_DLL_REDIRECTION_DETAILED_INFORMATION  = ASSEMBLY_FILE_DETAILED_INFORMATION;
const auto PASSEMBLY_DLL_REDIRECTION_DETAILED_INFORMATION = PASSEMBLY_FILE_DETAILED_INFORMATION;
const auto PCASSEMBLY_DLL_REDIRECTION_DETAILED_INFORMATION  = PCASSEMBLY_FILE_DETAILED_INFORMATION;

struct ACTIVATION_CONTEXT_ASSEMBLY_DETAILED_INFORMATION {
    DWORD ulFlags;
    DWORD ulEncodedAssemblyIdentityLength;      // in bytes
    DWORD ulManifestPathType;                   // ACTIVATION_CONTEXT_PATH_TYPE_*
    DWORD ulManifestPathLength;                 // in bytes
    LARGE_INTEGER liManifestLastWriteTime;      // FILETIME
    DWORD ulPolicyPathType;                     // ACTIVATION_CONTEXT_PATH_TYPE_*
    DWORD ulPolicyPathLength;                   // in bytes
    LARGE_INTEGER liPolicyLastWriteTime;        // FILETIME
    DWORD ulMetadataSatelliteRosterIndex;

    DWORD ulManifestVersionMajor;               // 1
    DWORD ulManifestVersionMinor;               // 0
    DWORD ulPolicyVersionMajor;                 // 0
    DWORD ulPolicyVersionMinor;                 // 0
    DWORD ulAssemblyDirectoryNameLength;        // in bytes

    PCWSTR lpAssemblyEncodedAssemblyIdentity;
    PCWSTR lpAssemblyManifestPath;
    PCWSTR lpAssemblyPolicyPath;
    PCWSTR lpAssemblyDirectoryName;

    DWORD  ulFileCount;
}

alias ACTIVATION_CONTEXT_ASSEMBLY_DETAILED_INFORMATION*  PACTIVATION_CONTEXT_ASSEMBLY_DETAILED_INFORMATION;

alias ACTIVATION_CONTEXT_ASSEMBLY_DETAILED_INFORMATION * PCACTIVATION_CONTEXT_ASSEMBLY_DETAILED_INFORMATION ;

enum ACTCTX_REQUESTED_RUN_LEVEL {
    ACTCTX_RUN_LEVEL_UNSPECIFIED = 0,
    ACTCTX_RUN_LEVEL_AS_INVOKER,
    ACTCTX_RUN_LEVEL_HIGHEST_AVAILABLE,
    ACTCTX_RUN_LEVEL_REQUIRE_ADMIN,
    ACTCTX_RUN_LEVEL_NUMBERS
}

struct ACTIVATION_CONTEXT_RUN_LEVEL_INFORMATION {
    DWORD ulFlags;
    ACTCTX_REQUESTED_RUN_LEVEL  RunLevel;
    DWORD UiAccess;
}

alias ACTIVATION_CONTEXT_RUN_LEVEL_INFORMATION*  PACTIVATION_CONTEXT_RUN_LEVEL_INFORMATION;

alias ACTIVATION_CONTEXT_RUN_LEVEL_INFORMATION * PCACTIVATION_CONTEXT_RUN_LEVEL_INFORMATION ;

struct ACTIVATION_CONTEXT_DETAILED_INFORMATION {
    DWORD dwFlags;
    DWORD ulFormatVersion;
    DWORD ulAssemblyCount;
    DWORD ulRootManifestPathType;
    DWORD ulRootManifestPathChars;
    DWORD ulRootConfigurationPathType;
    DWORD ulRootConfigurationPathChars;
    DWORD ulAppDirPathType;
    DWORD ulAppDirPathChars;
    PCWSTR lpRootManifestPath;
    PCWSTR lpRootConfigurationPath;
    PCWSTR lpAppDirPath;
}

alias ACTIVATION_CONTEXT_DETAILED_INFORMATION* PACTIVATION_CONTEXT_DETAILED_INFORMATION;

alias ACTIVATION_CONTEXT_DETAILED_INFORMATION *PCACTIVATION_CONTEXT_DETAILED_INFORMATION;

const auto DLL_PROCESS_ATTACH    = 1    ;
const auto DLL_THREAD_ATTACH     = 2    ;
const auto DLL_THREAD_DETACH     = 3    ;
const auto DLL_PROCESS_DETACH    = 0    ;

//
// Defines for the READ flags for Eventlogging
//
const auto EVENTLOG_SEQUENTIAL_READ         = 0x0001;
const auto EVENTLOG_SEEK_READ               = 0x0002;
const auto EVENTLOG_FORWARDS_READ           = 0x0004;
const auto EVENTLOG_BACKWARDS_READ          = 0x0008;

//
// The types of events that can be logged.
//
const auto EVENTLOG_SUCCESS                 = 0x0000;
const auto EVENTLOG_ERROR_TYPE              = 0x0001;
const auto EVENTLOG_WARNING_TYPE            = 0x0002;
const auto EVENTLOG_INFORMATION_TYPE        = 0x0004;
const auto EVENTLOG_AUDIT_SUCCESS           = 0x0008;
const auto EVENTLOG_AUDIT_FAILURE           = 0x0010;

//
// Defines for the WRITE flags used by Auditing for paired events
// These are not implemented in Product 1
//

const auto EVENTLOG_START_PAIRED_EVENT     = 0x0001;
const auto EVENTLOG_END_PAIRED_EVENT       = 0x0002;
const auto EVENTLOG_END_ALL_PAIRED_EVENTS  = 0x0004;
const auto EVENTLOG_PAIRED_EVENT_ACTIVE    = 0x0008;
const auto EVENTLOG_PAIRED_EVENT_INACTIVE  = 0x0010;

//
// Structure that defines the header of the Eventlog record. This is the
// fixed-sized portion before all the variable-length strings, binary
// data and pad bytes.
//
// TimeGenerated is the time it was generated at the client.
// TimeWritten is the time it was put into the log at the server end.
//

struct EVENTLOGRECORD {
    DWORD  Length;        // Length of full record
    DWORD  Reserved;      // Used by the service
    DWORD  RecordNumber;  // Absolute record number
    DWORD  TimeGenerated; // Seconds since 1-1-1970
    DWORD  TimeWritten;   // Seconds since 1-1-1970
    DWORD  EventID;
    WORD   EventType;
    WORD   NumStrings;
    WORD   EventCategory;
    WORD   ReservedFlags; // For use with paired events (auditing)
    DWORD  ClosingRecordNumber; // For use with paired events (auditing)
    DWORD  StringOffset;  // Offset from beginning of record
    DWORD  UserSidLength;
    DWORD  UserSidOffset;
    DWORD  DataLength;
    DWORD  DataOffset;    // Offset from beginning of record
    //
    // Then follow:
    //
    // WCHAR SourceName[]
    // WCHAR Computername[]
    // SID   UserSid
    // WCHAR Strings[]
    // BYTE  Data[]
    // CHAR  Pad[]
    // DWORD Length;
    //
}

alias EVENTLOGRECORD* PEVENTLOGRECORD;

//SS: start of changes to support clustering
//SS: ideally the
const auto MAXLOGICALLOGNAMESIZE    = 256;

struct EVENTSFORLOGFILE {
    DWORD           ulSize;
    WCHAR           szLogicalLogFile[MAXLOGICALLOGNAMESIZE];        //name of the logical file-security/application/system
    DWORD           ulNumRecords;
    EVENTLOGRECORD  pEventLogRecords[];
}

alias EVENTSFORLOGFILE* PEVENTSFORLOGFILE;

struct PACKEDEVENTINFO {
    DWORD               ulSize;  //total size of the structure
    DWORD               ulNumEventsForLogFile; //number of EventsForLogFile structure that follow
    DWORD               ulOffsets[];           //the offsets from the start of this structure to the EVENTSFORLOGFILE structure
}

alias PACKEDEVENTINFO* PPACKEDEVENTINFO;

//SS: end of changes to support clustering
//

// begin_wdm
//
// Registry Specific Access Rights.
//

const auto KEY_QUERY_VALUE          = (0x0001);
const auto KEY_SET_VALUE            = (0x0002);
const auto KEY_CREATE_SUB_KEY       = (0x0004);
const auto KEY_ENUMERATE_SUB_KEYS   = (0x0008);
const auto KEY_NOTIFY               = (0x0010);
const auto KEY_CREATE_LINK          = (0x0020);
const auto KEY_WOW64_32KEY          = (0x0200);
const auto KEY_WOW64_64KEY          = (0x0100);
const auto KEY_WOW64_RES            = (0x0300);

const auto KEY_READ                 = ((STANDARD_RIGHTS_READ       |
                                  KEY_QUERY_VALUE            |
                                  KEY_ENUMERATE_SUB_KEYS     |
                                  KEY_NOTIFY)
                                  &
                                 (~SYNCHRONIZE));


const auto KEY_WRITE                = ((STANDARD_RIGHTS_WRITE      |
                                  KEY_SET_VALUE              |
                                  KEY_CREATE_SUB_KEY)
                                  &
                                 (~SYNCHRONIZE));

const auto KEY_EXECUTE              = ((KEY_READ)
                                  &
                                 (~SYNCHRONIZE));

const auto KEY_ALL_ACCESS           = ((STANDARD_RIGHTS_ALL        |
                                  KEY_QUERY_VALUE            |
                                  KEY_SET_VALUE              |
                                  KEY_CREATE_SUB_KEY         |
                                  KEY_ENUMERATE_SUB_KEYS     |
                                  KEY_NOTIFY                 |
                                  KEY_CREATE_LINK)
                                  &
                                 (~SYNCHRONIZE));

//
// Open/Create Options
//

const auto REG_OPTION_RESERVED          = (0x00000000L)   ; // Parameter is reserved

const auto REG_OPTION_NON_VOLATILE      = (0x00000000L)   ; // Key is preserved
                                                    // when system is rebooted

const auto REG_OPTION_VOLATILE          = (0x00000001L)   ; // Key is not preserved
                                                    // when system is rebooted

const auto REG_OPTION_CREATE_LINK       = (0x00000002L)   ; // Created key is a
                                                    // symbolic link

const auto REG_OPTION_BACKUP_RESTORE    = (0x00000004L)   ; // open for backup or restore
                                                    // special access rules
                                                    // privilege required

const auto REG_OPTION_OPEN_LINK         = (0x00000008L)   ; // Open symbolic link

const auto REG_LEGAL_OPTION             =
                (REG_OPTION_RESERVED            |
                 REG_OPTION_NON_VOLATILE        |
                 REG_OPTION_VOLATILE            |
                 REG_OPTION_CREATE_LINK         |
                 REG_OPTION_BACKUP_RESTORE      |
                 REG_OPTION_OPEN_LINK);

//
// Key creation/open disposition
//

const auto REG_CREATED_NEW_KEY          = (0x00000001L)   ; // New Registry Key created
const auto REG_OPENED_EXISTING_KEY      = (0x00000002L)   ; // Existing Key opened

//
// hive format to be used by Reg(Nt)SaveKeyEx
//
const auto REG_STANDARD_FORMAT      = 1;
const auto REG_LATEST_FORMAT        = 2;
const auto REG_NO_COMPRESSION       = 4;

//
// Key restore & hive load flags
//

const auto REG_WHOLE_HIVE_VOLATILE          = (0x00000001L)   ; // Restore whole hive volatile
const auto REG_REFRESH_HIVE                 = (0x00000002L)   ; // Unwind changes to last flush
const auto REG_NO_LAZY_FLUSH                = (0x00000004L)   ; // Never lazy flush this hive
const auto REG_FORCE_RESTORE                = (0x00000008L)   ; // Force the restore process even when we have open handles on subkeys
const auto REG_APP_HIVE                     = (0x00000010L)   ; // Loads the hive visible to the calling process
const auto REG_PROCESS_PRIVATE              = (0x00000020L)   ; // Hive cannot be mounted by any other process while in use
const auto REG_START_JOURNAL                = (0x00000040L)   ; // Starts Hive Journal
const auto REG_HIVE_EXACT_FILE_GROWTH       = (0x00000080L)   ; // Grow hive file in exact 4k increments
const auto REG_HIVE_NO_RM                   = (0x00000100L)   ; // No RM is started for this hive (no transactions)
const auto REG_HIVE_SINGLE_LOG              = (0x00000200L)   ; // Legacy single logging is used for this hive

//
// Unload Flags
//
const auto REG_FORCE_UNLOAD             = 1;

//
// Notify filter values
//

const auto REG_NOTIFY_CHANGE_NAME           = (0x00000001L) ; // Create or delete (child)
const auto REG_NOTIFY_CHANGE_ATTRIBUTES     = (0x00000002L);
const auto REG_NOTIFY_CHANGE_LAST_SET       = (0x00000004L) ; // time stamp
const auto REG_NOTIFY_CHANGE_SECURITY       = (0x00000008L);

const auto REG_LEGAL_CHANGE_FILTER                  =
                (REG_NOTIFY_CHANGE_NAME          |
                 REG_NOTIFY_CHANGE_ATTRIBUTES    |
                 REG_NOTIFY_CHANGE_LAST_SET      |
                 REG_NOTIFY_CHANGE_SECURITY);
 
// end_wdm 

//
//
// Predefined Value Types.
//

const auto REG_NONE                     = ( 0 )   ; // No value type
const auto REG_SZ                       = ( 1 )   ; // Unicode nul terminated string
const auto REG_EXPAND_SZ                = ( 2 )   ; // Unicode nul terminated string
                                            // (with environment variable references)
const auto REG_BINARY                   = ( 3 )   ; // Free form binary
const auto REG_DWORD                    = ( 4 )   ; // 32-bit number
const auto REG_DWORD_LITTLE_ENDIAN      = ( 4 )   ; // 32-bit number (same as REG_DWORD)
const auto REG_DWORD_BIG_ENDIAN         = ( 5 )   ; // 32-bit number
const auto REG_LINK                     = ( 6 )   ; // Symbolic Link (unicode)
const auto REG_MULTI_SZ                 = ( 7 )   ; // Multiple Unicode strings
const auto REG_RESOURCE_LIST            = ( 8 )   ; // Resource list in the resource map
const auto REG_FULL_RESOURCE_DESCRIPTOR  = ( 9 )  ; // Resource list in the hardware description
const auto REG_RESOURCE_REQUIREMENTS_LIST  = ( 10 );
const auto REG_QWORD                    = ( 11 )  ; // 64-bit number
const auto REG_QWORD_LITTLE_ENDIAN      = ( 11 )  ; // 64-bit number (same as REG_QWORD)

// end_wdm

// begin_wdm
//
// Service Types (Bit Mask)
//
const auto SERVICE_KERNEL_DRIVER           = 0x00000001;
const auto SERVICE_FILE_SYSTEM_DRIVER      = 0x00000002;
const auto SERVICE_ADAPTER                 = 0x00000004;
const auto SERVICE_RECOGNIZER_DRIVER       = 0x00000008;

const auto SERVICE_DRIVER                  = (SERVICE_KERNEL_DRIVER |
                                        SERVICE_FILE_SYSTEM_DRIVER |
                                        SERVICE_RECOGNIZER_DRIVER);

const auto SERVICE_WIN32_OWN_PROCESS       = 0x00000010;
const auto SERVICE_WIN32_SHARE_PROCESS     = 0x00000020;
const auto SERVICE_WIN32                   = (SERVICE_WIN32_OWN_PROCESS |
                                        SERVICE_WIN32_SHARE_PROCESS);

const auto SERVICE_INTERACTIVE_PROCESS     = 0x00000100;

const auto SERVICE_TYPE_ALL                = (SERVICE_WIN32  |
                                        SERVICE_ADAPTER |
                                        SERVICE_DRIVER  |
                                        SERVICE_INTERACTIVE_PROCESS);

//
// Start Type
//

const auto SERVICE_BOOT_START              = 0x00000000;
const auto SERVICE_SYSTEM_START            = 0x00000001;
const auto SERVICE_AUTO_START              = 0x00000002;
const auto SERVICE_DEMAND_START            = 0x00000003;
const auto SERVICE_DISABLED                = 0x00000004;

//
// Error control type
//
const auto SERVICE_ERROR_IGNORE            = 0x00000000;
const auto SERVICE_ERROR_NORMAL            = 0x00000001;
const auto SERVICE_ERROR_SEVERE            = 0x00000002;
const auto SERVICE_ERROR_CRITICAL          = 0x00000003;

//
//
// Define the registry driver node enumerations
//

enum CM_SERVICE_NODE_TYPE {
    DriverType               = SERVICE_KERNEL_DRIVER,
    FileSystemType           = SERVICE_FILE_SYSTEM_DRIVER,
    Win32ServiceOwnProcess   = SERVICE_WIN32_OWN_PROCESS,
    Win32ServiceShareProcess = SERVICE_WIN32_SHARE_PROCESS,
    AdapterType              = SERVICE_ADAPTER,
    RecognizerType           = SERVICE_RECOGNIZER_DRIVER
}
alias CM_SERVICE_NODE_TYPE SERVICE_NODE_TYPE;

enum CM_SERVICE_LOAD_TYPE {
    BootLoad    = SERVICE_BOOT_START,
    SystemLoad  = SERVICE_SYSTEM_START,
    AutoLoad    = SERVICE_AUTO_START,
    DemandLoad  = SERVICE_DEMAND_START,
    DisableLoad = SERVICE_DISABLED
}

alias CM_SERVICE_LOAD_TYPE SERVICE_LOAD_TYPE;

enum CM_ERROR_CONTROL_TYPE {
    IgnoreError   = SERVICE_ERROR_IGNORE,
    NormalError   = SERVICE_ERROR_NORMAL,
    SevereError   = SERVICE_ERROR_SEVERE,
    CriticalError = SERVICE_ERROR_CRITICAL
}

alias CM_ERROR_CONTROL_TYPE SERVICE_ERROR_TYPE;



//
// IOCTL_TAPE_ERASE definitions
//

const auto TAPE_ERASE_SHORT             = 0L;
const auto TAPE_ERASE_LONG              = 1L;

struct TAPE_ERASE {
    DWORD Type;
    BOOLEAN Immediate;
}

alias TAPE_ERASE* PTAPE_ERASE;

//
// IOCTL_TAPE_PREPARE definitions
//

const auto TAPE_LOAD                    = 0L;
const auto TAPE_UNLOAD                  = 1L;
const auto TAPE_TENSION                 = 2L;
const auto TAPE_LOCK                    = 3L;
const auto TAPE_UNLOCK                  = 4L;
const auto TAPE_FORMAT                  = 5L;

struct TAPE_PREPARE {
    DWORD Operation;
    BOOLEAN Immediate;
}

alias TAPE_PREPARE* PTAPE_PREPARE;

//
// IOCTL_TAPE_WRITE_MARKS definitions
//

const auto TAPE_SETMARKS                = 0L;
const auto TAPE_FILEMARKS               = 1L;
const auto TAPE_SHORT_FILEMARKS         = 2L;
const auto TAPE_LONG_FILEMARKS          = 3L;

struct TAPE_WRITE_MARKS {
    DWORD Type;
    DWORD Count;
    BOOLEAN Immediate;
}

alias TAPE_WRITE_MARKS* PTAPE_WRITE_MARKS;

//
// IOCTL_TAPE_GET_POSITION definitions
//

const auto TAPE_ABSOLUTE_POSITION        = 0L;
const auto TAPE_LOGICAL_POSITION         = 1L;
const auto TAPE_PSEUDO_LOGICAL_POSITION  = 2L;

struct TAPE_GET_POSITION {
    DWORD Type;
    DWORD Partition;
    LARGE_INTEGER Offset;
}

alias TAPE_GET_POSITION* PTAPE_GET_POSITION;

//
// IOCTL_TAPE_SET_POSITION definitions
//

const auto TAPE_REWIND                  = 0L;
const auto TAPE_ABSOLUTE_BLOCK          = 1L;
const auto TAPE_LOGICAL_BLOCK           = 2L;
const auto TAPE_PSEUDO_LOGICAL_BLOCK    = 3L;
const auto TAPE_SPACE_END_OF_DATA       = 4L;
const auto TAPE_SPACE_RELATIVE_BLOCKS   = 5L;
const auto TAPE_SPACE_FILEMARKS         = 6L;
const auto TAPE_SPACE_SEQUENTIAL_FMKS   = 7L;
const auto TAPE_SPACE_SETMARKS          = 8L;
const auto TAPE_SPACE_SEQUENTIAL_SMKS   = 9L;

struct TAPE_SET_POSITION {
    DWORD Method;
    DWORD Partition;
    LARGE_INTEGER Offset;
    BOOLEAN Immediate;
}

alias TAPE_SET_POSITION* PTAPE_SET_POSITION;

//
// IOCTL_TAPE_GET_DRIVE_PARAMS definitions
//

//
// Definitions for FeaturesLow parameter
//

const auto TAPE_DRIVE_FIXED             = 0x00000001;
const auto TAPE_DRIVE_SELECT            = 0x00000002;
const auto TAPE_DRIVE_INITIATOR         = 0x00000004;

const auto TAPE_DRIVE_ERASE_SHORT       = 0x00000010;
const auto TAPE_DRIVE_ERASE_LONG        = 0x00000020;
const auto TAPE_DRIVE_ERASE_BOP_ONLY    = 0x00000040;
const auto TAPE_DRIVE_ERASE_IMMEDIATE   = 0x00000080;

const auto TAPE_DRIVE_TAPE_CAPACITY     = 0x00000100;
const auto TAPE_DRIVE_TAPE_REMAINING    = 0x00000200;
const auto TAPE_DRIVE_FIXED_BLOCK       = 0x00000400;
const auto TAPE_DRIVE_VARIABLE_BLOCK    = 0x00000800;

const auto TAPE_DRIVE_WRITE_PROTECT     = 0x00001000;
const auto TAPE_DRIVE_EOT_WZ_SIZE       = 0x00002000;

const auto TAPE_DRIVE_ECC               = 0x00010000;
const auto TAPE_DRIVE_COMPRESSION       = 0x00020000;
const auto TAPE_DRIVE_PADDING           = 0x00040000;
const auto TAPE_DRIVE_REPORT_SMKS       = 0x00080000;

const auto TAPE_DRIVE_GET_ABSOLUTE_BLK  = 0x00100000;
const auto TAPE_DRIVE_GET_LOGICAL_BLK   = 0x00200000;
const auto TAPE_DRIVE_SET_EOT_WZ_SIZE   = 0x00400000;

const auto TAPE_DRIVE_EJECT_MEDIA       = 0x01000000;
const auto TAPE_DRIVE_CLEAN_REQUESTS    = 0x02000000;
const auto TAPE_DRIVE_SET_CMP_BOP_ONLY  = 0x04000000;

const auto TAPE_DRIVE_RESERVED_BIT      = 0x80000000  ; //don't use this bit!
//                                              //can't be a low features bit!
//                                              //reserved; high features only

//
// Definitions for FeaturesHigh parameter
//

const auto TAPE_DRIVE_LOAD_UNLOAD       = 0x80000001;
const auto TAPE_DRIVE_TENSION           = 0x80000002;
const auto TAPE_DRIVE_LOCK_UNLOCK       = 0x80000004;
const auto TAPE_DRIVE_REWIND_IMMEDIATE  = 0x80000008;

const auto TAPE_DRIVE_SET_BLOCK_SIZE    = 0x80000010;
const auto TAPE_DRIVE_LOAD_UNLD_IMMED   = 0x80000020;
const auto TAPE_DRIVE_TENSION_IMMED     = 0x80000040;
const auto TAPE_DRIVE_LOCK_UNLK_IMMED   = 0x80000080;

const auto TAPE_DRIVE_SET_ECC           = 0x80000100;
const auto TAPE_DRIVE_SET_COMPRESSION   = 0x80000200;
const auto TAPE_DRIVE_SET_PADDING       = 0x80000400;
const auto TAPE_DRIVE_SET_REPORT_SMKS   = 0x80000800;

const auto TAPE_DRIVE_ABSOLUTE_BLK      = 0x80001000;
const auto TAPE_DRIVE_ABS_BLK_IMMED     = 0x80002000;
const auto TAPE_DRIVE_LOGICAL_BLK       = 0x80004000;
const auto TAPE_DRIVE_LOG_BLK_IMMED     = 0x80008000;

const auto TAPE_DRIVE_END_OF_DATA       = 0x80010000;
const auto TAPE_DRIVE_RELATIVE_BLKS     = 0x80020000;
const auto TAPE_DRIVE_FILEMARKS         = 0x80040000;
const auto TAPE_DRIVE_SEQUENTIAL_FMKS   = 0x80080000;

const auto TAPE_DRIVE_SETMARKS          = 0x80100000;
const auto TAPE_DRIVE_SEQUENTIAL_SMKS   = 0x80200000;
const auto TAPE_DRIVE_REVERSE_POSITION  = 0x80400000;
const auto TAPE_DRIVE_SPACE_IMMEDIATE   = 0x80800000;

const auto TAPE_DRIVE_WRITE_SETMARKS    = 0x81000000;
const auto TAPE_DRIVE_WRITE_FILEMARKS   = 0x82000000;
const auto TAPE_DRIVE_WRITE_SHORT_FMKS  = 0x84000000;
const auto TAPE_DRIVE_WRITE_LONG_FMKS   = 0x88000000;

const auto TAPE_DRIVE_WRITE_MARK_IMMED  = 0x90000000;
const auto TAPE_DRIVE_FORMAT            = 0xA0000000;
const auto TAPE_DRIVE_FORMAT_IMMEDIATE  = 0xC0000000;
const auto TAPE_DRIVE_HIGH_FEATURES     = 0x80000000  ; //mask for high features flag

struct TAPE_GET_DRIVE_PARAMETERS {
    BOOLEAN ECC;
    BOOLEAN Compression;
    BOOLEAN DataPadding;
    BOOLEAN ReportSetmarks;
    DWORD DefaultBlockSize;
    DWORD MaximumBlockSize;
    DWORD MinimumBlockSize;
    DWORD MaximumPartitionCount;
    DWORD FeaturesLow;
    DWORD FeaturesHigh;
    DWORD EOTWarningZoneSize;
}

alias TAPE_GET_DRIVE_PARAMETERS* PTAPE_GET_DRIVE_PARAMETERS;

//
// IOCTL_TAPE_SET_DRIVE_PARAMETERS definitions
//

struct TAPE_SET_DRIVE_PARAMETERS {
    BOOLEAN ECC;
    BOOLEAN Compression;
    BOOLEAN DataPadding;
    BOOLEAN ReportSetmarks;
    DWORD EOTWarningZoneSize;
}

alias TAPE_SET_DRIVE_PARAMETERS* PTAPE_SET_DRIVE_PARAMETERS;

//
// IOCTL_TAPE_GET_MEDIA_PARAMETERS definitions
//

struct TAPE_GET_MEDIA_PARAMETERS {
    LARGE_INTEGER Capacity;
    LARGE_INTEGER Remaining;
    DWORD BlockSize;
    DWORD PartitionCount;
    BOOLEAN WriteProtected;
}

alias TAPE_GET_MEDIA_PARAMETERS* PTAPE_GET_MEDIA_PARAMETERS;

//
// IOCTL_TAPE_SET_MEDIA_PARAMETERS definitions
//

struct TAPE_SET_MEDIA_PARAMETERS {
    DWORD BlockSize;
}

alias TAPE_SET_MEDIA_PARAMETERS* PTAPE_SET_MEDIA_PARAMETERS;

//
// IOCTL_TAPE_CREATE_PARTITION definitions
//

const auto TAPE_FIXED_PARTITIONS        = 0L;
const auto TAPE_SELECT_PARTITIONS       = 1L;
const auto TAPE_INITIATOR_PARTITIONS    = 2L;

struct TAPE_CREATE_PARTITION {
    DWORD Method;
    DWORD Count;
    DWORD Size;
}

alias TAPE_CREATE_PARTITION* PTAPE_CREATE_PARTITION;


//
// WMI Methods
//
const auto TAPE_QUERY_DRIVE_PARAMETERS        = 0L;
const auto TAPE_QUERY_MEDIA_CAPACITY          = 1L;
const auto TAPE_CHECK_FOR_DRIVE_PROBLEM       = 2L;
const auto TAPE_QUERY_IO_ERROR_DATA           = 3L;
const auto TAPE_QUERY_DEVICE_ERROR_DATA       = 4L;

struct TAPE_WMI_OPERATIONS {
   DWORD Method;
   DWORD DataBufferSize;
   PVOID DataBuffer;
}

alias TAPE_WMI_OPERATIONS* PTAPE_WMI_OPERATIONS;

//
// Type of drive errors
//
enum TAPE_DRIVE_PROBLEM_TYPE {
   TapeDriveProblemNone, TapeDriveReadWriteWarning,
   TapeDriveReadWriteError, TapeDriveReadWarning,
   TapeDriveWriteWarning, TapeDriveReadError,
   TapeDriveWriteError, TapeDriveHardwareError,
   TapeDriveUnsupportedMedia, TapeDriveScsiConnectionError,
   TapeDriveTimetoClean, TapeDriveCleanDriveNow,
   TapeDriveMediaLifeExpired, TapeDriveSnappedTape
}
//
// Types for Nt level TM calls
//

//
// KTM Tm object rights
//
const auto TRANSACTIONMANAGER_QUERY_INFORMATION      = ( 0x0001 );
const auto TRANSACTIONMANAGER_SET_INFORMATION        = ( 0x0002 );
const auto TRANSACTIONMANAGER_RECOVER                = ( 0x0004 );
const auto TRANSACTIONMANAGER_RENAME                 = ( 0x0008 );
const auto TRANSACTIONMANAGER_CREATE_RM              = ( 0x0010 );

// The following right is intended for DTC's use only; it will be
// deprecated, and no one else should take a dependency on it.
const auto TRANSACTIONMANAGER_BIND_TRANSACTION       = ( 0x0020 );

//
// Generic mappings for transaction manager rights.
//

const auto TRANSACTIONMANAGER_GENERIC_READ             = (STANDARD_RIGHTS_READ            |
                                                    TRANSACTIONMANAGER_QUERY_INFORMATION);

const auto TRANSACTIONMANAGER_GENERIC_WRITE            = (STANDARD_RIGHTS_WRITE           |
                                                    TRANSACTIONMANAGER_SET_INFORMATION     |
                                                    TRANSACTIONMANAGER_RECOVER             |
                                                    TRANSACTIONMANAGER_RENAME              |
                                                    TRANSACTIONMANAGER_CREATE_RM);

const auto TRANSACTIONMANAGER_GENERIC_EXECUTE          = (STANDARD_RIGHTS_EXECUTE);

const auto TRANSACTIONMANAGER_ALL_ACCESS               = (STANDARD_RIGHTS_REQUIRED        |
                                                    TRANSACTIONMANAGER_GENERIC_READ        |
                                                    TRANSACTIONMANAGER_GENERIC_WRITE       |
                                                    TRANSACTIONMANAGER_GENERIC_EXECUTE     |
                                                    TRANSACTIONMANAGER_BIND_TRANSACTION);


//
// KTM transaction object rights.
//
const auto TRANSACTION_QUERY_INFORMATION      = ( 0x0001 );
const auto TRANSACTION_SET_INFORMATION        = ( 0x0002 );
const auto TRANSACTION_ENLIST                 = ( 0x0004 );
const auto TRANSACTION_COMMIT                 = ( 0x0008 );
const auto TRANSACTION_ROLLBACK               = ( 0x0010 );
const auto TRANSACTION_PROPAGATE              = ( 0x0020 );
const auto TRANSACTION_SAVEPOINT              = ( 0x0040 );
const auto TRANSACTION_MARSHALL               = ( TRANSACTION_QUERY_INFORMATION );

//
// Generic mappings for transaction rights.
// Resource managers, when enlisting, should generally use the macro
// TRANSACTION_RESOURCE_MANAGER_RIGHTS when opening a transaction.
// It's the same as generic read and write except that it does not allow
// a commit decision to be made.
//

const auto TRANSACTION_GENERIC_READ             = (STANDARD_RIGHTS_READ            |
                                             TRANSACTION_QUERY_INFORMATION   |
                                             SYNCHRONIZE);

const auto TRANSACTION_GENERIC_WRITE            = (STANDARD_RIGHTS_WRITE           |
                                             TRANSACTION_SET_INFORMATION     |
                                             TRANSACTION_COMMIT              |
                                             TRANSACTION_ENLIST              |
                                             TRANSACTION_ROLLBACK            |
                                             TRANSACTION_PROPAGATE           |
                                             TRANSACTION_SAVEPOINT           |
                                             SYNCHRONIZE);

const auto TRANSACTION_GENERIC_EXECUTE          = (STANDARD_RIGHTS_EXECUTE         |
                                             TRANSACTION_COMMIT              |
                                             TRANSACTION_ROLLBACK            |
                                             SYNCHRONIZE);

const auto TRANSACTION_ALL_ACCESS               = (STANDARD_RIGHTS_REQUIRED        |
                                             TRANSACTION_GENERIC_READ        |
                                             TRANSACTION_GENERIC_WRITE       |
                                             TRANSACTION_GENERIC_EXECUTE);

const auto TRANSACTION_RESOURCE_MANAGER_RIGHTS  = (TRANSACTION_GENERIC_READ        |
                                             STANDARD_RIGHTS_WRITE           |
                                             TRANSACTION_SET_INFORMATION     |
                                             TRANSACTION_ENLIST              |
                                             TRANSACTION_ROLLBACK            |
                                             TRANSACTION_PROPAGATE           |
                                             SYNCHRONIZE);

//
// KTM resource manager object rights.
//
const auto RESOURCEMANAGER_QUERY_INFORMATION      = ( 0x0001 );
const auto RESOURCEMANAGER_SET_INFORMATION        = ( 0x0002 );
const auto RESOURCEMANAGER_RECOVER                = ( 0x0004 );
const auto RESOURCEMANAGER_ENLIST                 = ( 0x0008 );
const auto RESOURCEMANAGER_GET_NOTIFICATION       = ( 0x0010 );
const auto RESOURCEMANAGER_REGISTER_PROTOCOL      = ( 0x0020 );
const auto RESOURCEMANAGER_COMPLETE_PROPAGATION   = ( 0x0040 );

//
// Generic mappings for resource manager rights.
//
const auto RESOURCEMANAGER_GENERIC_READ         = (STANDARD_RIGHTS_READ                 |
                                             RESOURCEMANAGER_QUERY_INFORMATION    |
                                             SYNCHRONIZE);

const auto RESOURCEMANAGER_GENERIC_WRITE        = (STANDARD_RIGHTS_WRITE                |
                                             RESOURCEMANAGER_SET_INFORMATION      |
                                             RESOURCEMANAGER_RECOVER              |
                                             RESOURCEMANAGER_ENLIST               |
                                             RESOURCEMANAGER_GET_NOTIFICATION     |
                                             RESOURCEMANAGER_REGISTER_PROTOCOL    |
                                             RESOURCEMANAGER_COMPLETE_PROPAGATION |
                                             SYNCHRONIZE);

const auto RESOURCEMANAGER_GENERIC_EXECUTE      = (STANDARD_RIGHTS_EXECUTE              |
                                             RESOURCEMANAGER_RECOVER              |
                                             RESOURCEMANAGER_ENLIST               |
                                             RESOURCEMANAGER_GET_NOTIFICATION     |
                                             RESOURCEMANAGER_COMPLETE_PROPAGATION |
                                             SYNCHRONIZE);

const auto RESOURCEMANAGER_ALL_ACCESS           = (STANDARD_RIGHTS_REQUIRED             |
                                             RESOURCEMANAGER_GENERIC_READ         |
                                             RESOURCEMANAGER_GENERIC_WRITE        |
                                             RESOURCEMANAGER_GENERIC_EXECUTE);


//
// KTM enlistment object rights.
//
const auto ENLISTMENT_QUERY_INFORMATION      = ( 0x0001 );
const auto ENLISTMENT_SET_INFORMATION        = ( 0x0002 );
const auto ENLISTMENT_RECOVER                = ( 0x0004 );
const auto ENLISTMENT_SUBORDINATE_RIGHTS     = ( 0x0008 );
const auto ENLISTMENT_SUPERIOR_RIGHTS        = ( 0x0010 );

//
// Generic mappings for enlistment rights.
//
const auto ENLISTMENT_GENERIC_READ         = (STANDARD_RIGHTS_READ           |
                                        ENLISTMENT_QUERY_INFORMATION);

const auto ENLISTMENT_GENERIC_WRITE        = (STANDARD_RIGHTS_WRITE          |
                                        ENLISTMENT_SET_INFORMATION     |
                                        ENLISTMENT_RECOVER             |
                                        ENLISTMENT_SUBORDINATE_RIGHTS  |
                                        ENLISTMENT_SUPERIOR_RIGHTS);

const auto ENLISTMENT_GENERIC_EXECUTE      = (STANDARD_RIGHTS_EXECUTE        |
                                        ENLISTMENT_RECOVER             |
                                        ENLISTMENT_SUBORDINATE_RIGHTS  |
                                        ENLISTMENT_SUPERIOR_RIGHTS);

const auto ENLISTMENT_ALL_ACCESS           = (STANDARD_RIGHTS_REQUIRED       |
                                        ENLISTMENT_GENERIC_READ        |
                                        ENLISTMENT_GENERIC_WRITE       |
                                        ENLISTMENT_GENERIC_EXECUTE);




