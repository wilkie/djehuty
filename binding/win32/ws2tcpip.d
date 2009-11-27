/*
 * ws2tcpip.d
 *
 * This module binds WS2tcpip.h to D. The original copyright notice
 * is preserved below.
 *
 * Author: Dave Wilkinson
 * Originated: November 25th, 2009
 *
 */

module binding.win32.ws2tcpip;

import binding.win32.winsock;
import binding.win32.windef;
import binding.win32.winbase;
import binding.win32.winnt;

/*
**  WS2TCPIP.H - WinSock2 Extension for TCP/IP protocols
**
**  This file contains TCP/IP specific information for use
**  by WinSock2 compatible applications.
**
**  Copyright (c) Microsoft Corporation. All rights reserved.
**
**  To provide the backward compatibility, all the TCP/IP
**  specific definitions that were included in the WINSOCK.H
**   file are now included in WINSOCK2.H file. WS2TCPIP.H
**  file includes only the definitions  introduced in the
**  "WinSock 2 Protocol-Specific Annex" document.
**
**  Rev 0.3 Nov 13, 1995
**      Rev 0.4 Dec 15, 1996
*/

/* Error codes from getaddrinfo() */

const auto EAI_AGAIN        = WSATRY_AGAIN;
const auto EAI_BADFLAGS     = WSAEINVAL;
const auto EAI_FAIL         = WSANO_RECOVERY;
const auto EAI_FAMILY       = WSAEAFNOSUPPORT;
const auto EAI_MEMORY       = WSA_NOT_ENOUGH_MEMORY;
//#define EAI_NODATA      WSANO_DATA
const auto EAI_NONAME       = WSAHOST_NOT_FOUND;
const auto EAI_SERVICE      = WSATYPE_NOT_FOUND;
const auto EAI_SOCKTYPE     = WSAESOCKTNOSUPPORT;

//
//  DCR_FIX:  EAI_NODATA remove or fix
//
//  EAI_NODATA was removed from rfc2553bis
//  need to find out from the authors why and
//  determine the error for "no records of this type"
//  temporarily, we'll keep #define to avoid changing
//  code that could change back;  use NONAME
//

const auto EAI_NODATA       = EAI_NONAME;


/* Structure used in getaddrinfo() call */

struct ADDRINFOA {
    int                 ai_flags;       // AI_PASSIVE, AI_CANONNAME, AI_NUMERICHOST
    int                 ai_family;      // PF_xxx
    int                 ai_socktype;    // SOCK_xxx
    int                 ai_protocol;    // 0 or IPPROTO_xxx for IPv4 and IPv6
    size_t              ai_addrlen;     // Length of ai_addr
    char *              ai_canonname;   // Canonical name for nodename
    sockaddr *   ai_addr;        // Binary address
    addrinfo *   ai_next;        // Next structure in linked list
}

alias ADDRINFOA* PADDRINFOA;

struct ADDRINFOW {
    int                 ai_flags;       // AI_PASSIVE, AI_CANONNAME, AI_NUMERICHOST
    int                 ai_family;      // PF_xxx
    int                 ai_socktype;    // SOCK_xxx
    int                 ai_protocol;    // 0 or IPPROTO_xxx for IPv4 and IPv6
    size_t              ai_addrlen;     // Length of ai_addr
    PWSTR               ai_canonname;   // Canonical name for nodename
    sockaddr *   ai_addr;        // Binary address
    addrinfoW *  ai_next;        // Next structure in linked list
}

alias ADDRINFOW* PADDRINFOW;

//  Switchable definition for GetAddrInfo()


version(UNICODE) {
	alias ADDRINFOW ADDRINFOT;
	alias ADDRINFOW* PADDRINFOT;
}
else {
	alias ADDRINFOA       ADDRINFOT;
	alias ADDRINFOA *PADDRINFOT;
}

//  RFC standard definition for getaddrinfo()

alias ADDRINFOA       ADDRINFO;
alias ADDRINFOA* 		LPADDRINFO;

struct ADDRINFOEXA {
    int                 ai_flags;       // AI_PASSIVE, AI_CANONNAME, AI_NUMERICHOST
    int                 ai_family;      // PF_xxx
    int                 ai_socktype;    // SOCK_xxx
    int                 ai_protocol;    // 0 or IPPROTO_xxx for IPv4 and IPv6
    size_t              ai_addrlen;     // Length of ai_addr
    char               *ai_canonname;   // Canonical name for nodename
    sockaddr    *ai_addr;        // Binary address
    void               *ai_blob;
    size_t              ai_bloblen;
    LPGUID              ai_provider;
    addrinfoexA *ai_next;        // Next structure in linked list
}

alias ADDRINFOEXA* PADDRINFOEXA;
alias ADDRINFOEXA* LPADDRINFOEXA;

struct ADDRINFOEXW {
    int                 ai_flags;       // AI_PASSIVE, AI_CANONNAME, AI_NUMERICHOST
    int                 ai_family;      // PF_xxx
    int                 ai_socktype;    // SOCK_xxx
    int                 ai_protocol;    // 0 or IPPROTO_xxx for IPv4 and IPv6
    size_t              ai_addrlen;     // Length of ai_addr
    PWSTR               ai_canonname;   // Canonical name for nodename
    sockaddr    *ai_addr;        // Binary address
    void               *ai_blob;
    size_t              ai_bloblen;
    LPGUID              ai_provider;
    addrinfoexW *ai_next;        // Next structure in linked list
}

alias ADDRINFOEXW* PADDRINFOEXW;
alias ADDRINFOEXW* LPADDRINFOEXW;

version(UNICODE) {
	alias ADDRINFOEXW     ADDRINFOEX;
	alias ADDRINFOEXW *PADDRINFOEX;
}
else {
	alias ADDRINFOEXA     ADDRINFOEX;
	alias ADDRINFOEXA     *PADDRINFOEX;
}

//
//  Flags used in "hints" argument to getaddrinfo()
//      - AI_ADDRCONFIG is supported starting with Vista
//      - default is AI_ADDRCONFIG ON whether the flag is set or not
//        because the performance penalty in not having ADDRCONFIG in
//        the multi-protocol stack environment is severe;
//        this defaulting may be disabled by specifying the AI_ALL flag,
//        in that case AI_ADDRCONFIG must be EXPLICITLY specified to
//        enable ADDRCONFIG behavior
//

const auto AI_PASSIVE       = 0x00000001  ; // Socket address will be used in bind() call
const auto AI_CANONNAME     = 0x00000002  ; // Return canonical name in first ai_canonname
const auto AI_NUMERICHOST   = 0x00000004  ; // Nodename must be a numeric address string
const auto AI_NUMERICSERV   = 0x00000008  ; // Servicename must be a numeric port number

const auto AI_ALL           = 0x00000100  ; // Query both IP6 and IP4 with AI_V4MAPPED
const auto AI_ADDRCONFIG    = 0x00000400  ; // Resolution only if global address configured
const auto AI_V4MAPPED      = 0x00000800  ; // On v6 failure, query v4 and convert to V4MAPPED format


const auto AI_NON_AUTHORITATIVE         = LUP_NON_AUTHORITATIVE       ; // 0x4000
const auto AI_SECURE                    = LUP_SECURE                  ; // 0x8000
const auto AI_RETURN_PREFERRED_NAMES    = LUP_RETURN_PREFERRED_NAMES  ; // 0x10000

INT getaddrinfo(
    PCSTR               pNodeName,
    PCSTR               pServiceName,
    ADDRINFOA *         pHints,
    PADDRINFOA *        ppResult
    );

INT GetAddrInfoW(
    PCWSTR              pNodeName,
    PCWSTR              pServiceName,
    ADDRINFOW *         pHints,
    PADDRINFOW *        ppResult
    );

const auto GetAddrInfoA     = getaddrinfo;

version(UNICODE) {
	alias GetAddrInfoW GetAddrInfo;
}
else {
	alias GetAddrInfoA GetAddrInfo;
}

alias INT function(PCSTR pNodeName, PCSTR pServiceName, ADDRINFOA* pHints, PADDRINFOA* ppResult) LPFN_GETADDRINFO;
alias INT function(PCWSTR pNodeName, PCWSTR pServiceName, ADDRINFOA* pHints, PADDRINFOA* ppResult) LPFN_GETADDRINFOW;

alias LPFN_GETADDRINFO LPFN_GETADDRINFOA;

version(UNICODE) {
	alias LPFN_GETADDRINFOW LPFN_GETADDRINFOT;
}
else {
	alias LPFN_GETADDRINFOA LPFN_GETADDRINFOT;
}

alias void function(DWORD, dwError, DWORD dwBytes, LPWSAOVERLAPPED lpOverlapped) LPLOOKUPSERVICE_COMPLETION_ROUTINE;

INT GetAddrInfoExA(
    PCSTR           pName,
    PCSTR           pServiceName,
    DWORD           dwNameSpace,
    LPGUID          lpNspId,
    ADDRINFOEXA*    hints,
    PADDRINFOEXA*   ppResult,
    timeval*        timeout,
    LPOVERLAPPED    lpOverlapped,
    LPLOOKUPSERVICE_COMPLETION_ROUTINE  lpCompletionRoutine,
    LPHANDLE        lpNameHandle
    );

INT GetAddrInfoExW(
    PCWSTR          pName,
    PCWSTR          pServiceName,
    DWORD           dwNameSpace,
    LPGUID          lpNspId,
    ADDRINFOEXW*    hints,
    PADDRINFOEXW*   ppResult,
    timeval*        timeout,
    LPOVERLAPPED    lpOverlapped,
    LPLOOKUPSERVICE_COMPLETION_ROUTINE  lpCompletionRoutine,
    LPHANDLE        lpHandle
    );

version(UNICODE) {
	alias GetAddrInfoExW GetAddrInfoEx;
}
else {
	alias GetAddrInfoExA GetAddrInfoEx;
}

alias INT function(PCSTR pName, PCSTR pServiceName, DWORD dwNameSpace, LPGUID lpNspId,
	ADDRINFOEXA* hints, PADDRINFOEXA ppResult, timeval* timeout, LPOVERLAPPED lpOverlapped,
	LPLOOKUPSERVICE_COMPLETION_ROUTINE lpCompletionRoutine, LPHANDLE lpNameHandle) LPFN_GETADDRINFOEXA;

alias INT function(
    PCWSTR          pName,
    PCWSTR          pServiceName,
    DWORD           dwNameSpace,
    LPGUID          lpNspId,
    ADDRINFOEXW*    hints,
    PADDRINFOEXW*   ppResult,
    timeval*        timeout,
    LPOVERLAPPED    lpOverlapped,
    LPLOOKUPSERVICE_COMPLETION_ROUTINE  lpCompletionRoutine,
    LPHANDLE        lpHandle
    ) LPFN_GETADDRINFOEXW ;

version(UNICODE) {
	alias LPFN_GETADDRINFOEXW LPFN_GETADDRINFOEX;
}
else {
	alias LPFN_GETADDRINFOEXA LPFN_GETADDRINFOEX;
}

INT SetAddrInfoExA(
    PCSTR           pName,
    PCSTR           pServiceName,
    SOCKET_ADDRESS *pAddresses,
    DWORD           dwAddressCount,
    LPBLOB          lpBlob,
    DWORD           dwFlags,
    DWORD           dwNameSpace,
    LPGUID          lpNspId,
    timeval *timeout,
    LPOVERLAPPED    lpOverlapped,
    LPLOOKUPSERVICE_COMPLETION_ROUTINE  lpCompletionRoutine,
    LPHANDLE        lpNameHandle
    );

INT SetAddrInfoExW(
    PCWSTR          pName,
    PCWSTR          pServiceName,
    SOCKET_ADDRESS *pAddresses,
    DWORD           dwAddressCount,
    LPBLOB          lpBlob,
    DWORD           dwFlags,
    DWORD           dwNameSpace,
    LPGUID          lpNspId,
    timeval *timeout,
    LPOVERLAPPED    lpOverlapped,
    LPLOOKUPSERVICE_COMPLETION_ROUTINE  lpCompletionRoutine,
    LPHANDLE        lpNameHandle
    );


version(UNICODE) {
	alias SetAddrInfoExW SetAddrInfoEx;
}
else {
	alias SetAddrInfoExA SetAddrInfoEx;
}

alias INT function (
    PCSTR           pName,
    PCSTR           pServiceName,
    SOCKET_ADDRESS *pAddresses,
    DWORD           dwAddressCount,
    LPBLOB          lpBlob,
    DWORD           dwFlags,
    DWORD           dwNameSpace,
    LPGUID          lpNspId,
    timeval *timeout,
    LPOVERLAPPED    lpOverlapped,
    LPLOOKUPSERVICE_COMPLETION_ROUTINE  lpCompletionRoutine,
    LPHANDLE        lpNameHandle
    ) LPFN_SETADDRINFOEXA;

alias INT function (
    PCWSTR          pName,
    PCWSTR          pServiceName,
    SOCKET_ADDRESS *pAddresses,
    DWORD           dwAddressCount,
    LPBLOB          lpBlob,
    DWORD           dwFlags,
    DWORD           dwNameSpace,
    LPGUID          lpNspId,
    timeval *timeout,
    LPOVERLAPPED    lpOverlapped,
    LPLOOKUPSERVICE_COMPLETION_ROUTINE  lpCompletionRoutine,
    LPHANDLE        lpNameHandle
    ) LPFN_SETADDRINFOEXW;


version(UNICODE) {
	alias LPFN_SETADDRINFOEXW LPFN_SETADDRINFOEX;
}
else {
	alias LPFN_SETADDRINFOEXA LPFN_SETADDRINFOEX;
}

VOID freeaddrinfo(
        PADDRINFOA      pAddrInfo
    );

VOID FreeAddrInfoW(
        PADDRINFOW      pAddrInfo
    );

alias freeaddrinfo FreeAddrInfoA;

version(UNICODE) {
	alias FreeAddrInfoW FreeAddrInfo;
}
else {
	alias FreeAddrInfoA FreeAddrInfo;
}

alias VOID function (
        PADDRINFOA      pAddrInfo
    ) LPFN_FREEADDRINFO;

alias VOID function (
        PADDRINFOW      pAddrInfo
    ) LPFN_FREEADDRINFOW;

alias LPFN_FREEADDRINFO LPFN_FREEADDRINFOA;

version(UNICODE) {
	alias LPFN_FREEADDRINFOW LPFN_FREEADDRINFOT;
}
else {
	alias LPFN_FREEADDRINFOA LPFN_FREEADDRINFOT;
}

void FreeAddrInfoEx(
    PADDRINFOEXA    pAddrInfoEx
    );

void FreeAddrInfoExW(
    PADDRINFOEXW    pAddrInfoEx
    );

alias FreeAddrInfoEx FreeAddrInfoExA;

version(UNICODE) {
	alias FreeAddrInfoExW FreeAddrInfoEx;
}

alias void function (
    PADDRINFOEXA    pAddrInfoEx
    ) LPFN_FREEADDRINFOEXA;

alias void function (
    PADDRINFOEXW    pAddrInfoEx
    ) LPFN_FREEADDRINFOEXW;

version(UNICODE) {
	alias LPFN_FREEADDRINFOEXW LPFN_FREEADDRINFOEX;
}
else {
	alias LPFN_FREEADDRINFOEXA LPFN_FREEADDRINFOEX;
}

alias int socklen_t;

INT getnameinfo(
    SOCKADDR*           pSockaddr,
    socklen_t           SockaddrLength,
    PCHAR               pNodeBuffer,
    DWORD               NodeBufferSize,
    PCHAR               pServiceBuffer,
    DWORD               ServiceBufferSize,
    INT                 Flags
    );

INT GetNameInfoW(
    SOCKADDR*           pSockaddr,
    socklen_t           SockaddrLength,
    PWCHAR              pNodeBuffer,
    DWORD               NodeBufferSize,
    PWCHAR              pServiceBuffer,
    DWORD               ServiceBufferSize,
    INT                 Flags
    );

alias getnameinfo GetNameInfoA;

version(UNICODE) {
	alias GetNameInfoW GetNameInfo;
}
else {
	alias GetNameInfoA GetNameInfo;
}

alias int function (
    SOCKADDR*           pSockaddr,
    socklen_t           SockaddrLength,
    PCHAR               pNodeBuffer,
    DWORD               NodeBufferSize,
    PCHAR               pServiceBuffer,
    DWORD               ServiceBufferSize,
    INT                 Flags
    ) LPFN_GETNAMEINFO;

alias INT function (
    SOCKADDR*           pSockaddr,
    socklen_t           SockaddrLength,
    PWCHAR              pNodeBuffer,
	DWORD               NodeBufferSize,
    PWCHAR              pServiceBuffer,
    DWORD               ServiceBufferSize,
    INT                 Flags
    ) LPFN_GETNAMEINFOW;

alias LPFN_GETNAMEINFO LPFN_GETNAMEINFOA;

version(UNICODE) {
	alias LPFN_GETNAMEINFOW LPFN_GETNAMEINFOT;
}
else {
	alias LPFN_GETNAMEINFOA LPFN_GETNAMEINFOT;
}

INT inet_pton(
    INT             Family,
    PCSTR           pszAddrString,
    PVOID           pAddrBuf
    );

INT InetPtonW(
    INT             Family,
    PCWSTR          pszAddrString,
    PVOID           pAddrBuf
    );

PCSTR inet_ntop(
    INT             Family,
    PVOID           pAddr,
    PSTR            pStringBuf,
    size_t          StringBufSize
    );

PCWSTR InetNtopW(
    INT             Family,
    PVOID           pAddr,
    PWSTR           pStringBuf,
    size_t          StringBufSize
    );

alias inet_pton InetPtonA;
alias inet_ntop InetNtopA;

version(UNICODE) {
	alias InetPtonW InetPton;
	alias InetNtopW InetNtop;
}
else {
	alias InetPtonA InetPton;
	alias InetNtopA InetNtop;
}

alias INT function (
    INT             Family,
    PCSTR           pszAddrString,
    PVOID           pAddrBuf
    ) LPFN_INET_PTONA;

alias INT function (
    INT             Family,
    PCWSTR          pszAddrString,
    PVOID           pAddrBuf
    ) LPFN_INET_PTONW;

alias PCSTR function (
    INT             Family,
    PVOID           pAddr,
    PSTR            pStringBuf,
    size_t          StringBufSize
    ) LPFN_INET_NTOPA;

alias PCWSTR function (
    INT             Family,
    PVOID           pAddr,
    PWSTR           pStringBuf,
    size_t          StringBufSize
    ) LPFN_INET_NTOPW;

version(UNICODE) {
	alias LPFN_INET_PTONW LPFN_INET_PTON;
	alias LPFN_INET_NTOPW LPFN_INET_NTOP;
}
else {
	alias LPFN_INET_PTONA LPFN_INET_PTON;
	alias LPFN_INET_NTOPA LPFN_INET_NTOP;
}

version(UNICODE) {
	alias gai_strerrorW gai_strerror;
}
else {
	alias gai_strerrorA gai_strerror;
}

// WARNING: The gai_strerror inline functions below use static buffers,
// and hence are not thread-safe.  We'll use buffers long enough to hold
// 1k characters.  Any system error messages longer than this will be
// returned as empty strings.  However 1k should work for the error codes
// used by getaddrinfo().
/*const auto GAI_STRERROR_BUFFER_SIZE  = 1024;

char * gai_strerrorA(
    int ecode) {
    DWORD dwMsgLen;
    static char buff[GAI_STRERROR_BUFFER_SIZE + 1];

    dwMsgLen = FormatMessageA(FORMAT_MESSAGE_FROM_SYSTEM
                             |FORMAT_MESSAGE_IGNORE_INSERTS
                             |FORMAT_MESSAGE_MAX_WIDTH_MASK,
                              NULL,
                              ecode,
                              MAKELANGID(LANG_NEUTRAL, SUBLANG_DEFAULT),
                              (LPSTR)buff,
                              GAI_STRERROR_BUFFER_SIZE,
                              NULL);

    return buff;
}

WS2TCPIP_INLINE
WCHAR *
gai_strerrorW(
    IN int ecode
    )
{
    DWORD dwMsgLen;
    static WCHAR buff[GAI_STRERROR_BUFFER_SIZE + 1];

    dwMsgLen = FormatMessageW(FORMAT_MESSAGE_FROM_SYSTEM
                             |FORMAT_MESSAGE_IGNORE_INSERTS
                             |FORMAT_MESSAGE_MAX_WIDTH_MASK,
                              NULL,
                              ecode,
                              MAKELANGID(LANG_NEUTRAL, SUBLANG_DEFAULT),
                              (LPWSTR)buff,
                              GAI_STRERROR_BUFFER_SIZE,
                              NULL);

    return buff;
}*/

const auto NI_MAXHOST   = 1025  ; /* Max size of a fully-qualified domain name */
const auto NI_MAXSERV     = 32  ; /* Max size of a service name */

/* Flags for getnameinfo() */

const auto NI_NOFQDN        = 0x01  ; /* Only return nodename portion for local hosts */
const auto NI_NUMERICHOST   = 0x02  ; /* Return numeric form of the host's address */
const auto NI_NAMEREQD      = 0x04  ; /* Error if the host's name not in DNS */
const auto NI_NUMERICSERV   = 0x08  ; /* Return numeric form of the service (port #) */
const auto NI_DGRAM         = 0x10  ; /* Service is a datagram service */

/* Multicast source filter APIs from RFC 3678. */
/*
int setipv4sourcefilter(
    IN SOCKET Socket,
    IN IN_ADDR Interface,
    IN IN_ADDR Group,
    IN MULTICAST_MODE_TYPE FilterMode,
    IN ULONG SourceCount,
    IN CONST IN_ADDR *SourceList
    )
{
    int Error;
    DWORD Size, Returned;
    PIP_MSFILTER Filter;

    if (SourceCount >
        (((ULONG) (ULONG_MAX - sizeof(*Filter))) / sizeof(*SourceList))) {
        WSASetLastError(WSAENOBUFS);
        return SOCKET_ERROR;
    }

    Size = IP_MSFILTER_SIZE(SourceCount);
    Filter = (PIP_MSFILTER) HeapAlloc(GetProcessHeap(), 0, Size);
    if (Filter == NULL) {
        WSASetLastError(WSAENOBUFS);
        return SOCKET_ERROR;
    }

    Filter->imsf_multiaddr = Group;
    Filter->imsf_interface = Interface;
    Filter->imsf_fmode = FilterMode;
    Filter->imsf_numsrc = SourceCount;
    if (SourceCount > 0) {
        CopyMemory(Filter->imsf_slist, SourceList,
                   SourceCount * sizeof(*SourceList));
    }

    Error = WSAIoctl(Socket, SIOCSIPMSFILTER, Filter, Size, NULL, 0,
                     &Returned, NULL, NULL);

    HeapFree(GetProcessHeap(), 0, Filter);

    return Error;
}
*/

/*
WS2TCPIP_INLINE
int
getipv4sourcefilter(
    IN SOCKET Socket,
    IN IN_ADDR Interface,
    IN IN_ADDR Group,
    OUT MULTICAST_MODE_TYPE *FilterMode,
    IN OUT ULONG *SourceCount,
    OUT IN_ADDR *SourceList
    )
{
    int Error;
    DWORD Size, Returned;
    PIP_MSFILTER Filter;

    if (*SourceCount >
        (((ULONG) (ULONG_MAX - sizeof(*Filter))) / sizeof(*SourceList))) {
        WSASetLastError(WSAENOBUFS);
        return SOCKET_ERROR;
    }

    Size = IP_MSFILTER_SIZE(*SourceCount);
    Filter = (PIP_MSFILTER) HeapAlloc(GetProcessHeap(), 0, Size);
    if (Filter == NULL) {
        WSASetLastError(WSAENOBUFS);
        return SOCKET_ERROR;
    }

    Filter->imsf_multiaddr = Group;
    Filter->imsf_interface = Interface;
    Filter->imsf_numsrc = *SourceCount;

    Error = WSAIoctl(Socket, SIOCGIPMSFILTER, Filter, Size, Filter, Size,
                     &Returned, NULL, NULL);

    if (Error == 0) {
        if (*SourceCount > 0) {
            CopyMemory(SourceList, Filter->imsf_slist,
                       *SourceCount * sizeof(*SourceList));
            *SourceCount = Filter->imsf_numsrc;
        }
        *FilterMode = Filter->imsf_fmode;
    }

    HeapFree(GetProcessHeap(), 0, Filter);

    return Error;
}
*/

/*
WS2TCPIP_INLINE
int
setsourcefilter(
    IN SOCKET Socket,
    IN ULONG Interface,
    IN CONST SOCKADDR *Group,
    IN int GroupLength,
    IN MULTICAST_MODE_TYPE FilterMode,
    IN ULONG SourceCount,
    IN CONST SOCKADDR_STORAGE *SourceList
    )
{
    int Error;
    DWORD Size, Returned;
    PGROUP_FILTER Filter;

    if (SourceCount >=
        (((ULONG) (ULONG_MAX - sizeof(*Filter))) / sizeof(*SourceList))) {
        WSASetLastError(WSAENOBUFS);
        return SOCKET_ERROR;
    }

    Size = GROUP_FILTER_SIZE(SourceCount);
    Filter = (PGROUP_FILTER) HeapAlloc(GetProcessHeap(), 0, Size);
    if (Filter == NULL) {
        WSASetLastError(WSAENOBUFS);
        return SOCKET_ERROR;
    }

    Filter->gf_interface = Interface;
    ZeroMemory(&Filter->gf_group, sizeof(Filter->gf_group));
    CopyMemory(&Filter->gf_group, Group, GroupLength);
    Filter->gf_fmode = FilterMode;
    Filter->gf_numsrc = SourceCount;
    if (SourceCount > 0) {
        CopyMemory(Filter->gf_slist, SourceList,
                   SourceCount * sizeof(*SourceList));
    }

    Error = WSAIoctl(Socket, SIOCSMSFILTER, Filter, Size, NULL, 0,
                     &Returned, NULL, NULL);

    HeapFree(GetProcessHeap(), 0, Filter);

    return Error;
}
*/

/*
WS2TCPIP_INLINE
int
getsourcefilter(
    IN SOCKET Socket,
    IN ULONG Interface,
    IN CONST SOCKADDR *Group,
    IN int GroupLength,
    OUT MULTICAST_MODE_TYPE *FilterMode,
    IN OUT ULONG *SourceCount,
    OUT SOCKADDR_STORAGE *SourceList
    )
{
    int Error;
    DWORD Size, Returned;
    PGROUP_FILTER Filter;

    if (*SourceCount >
        (((ULONG) (ULONG_MAX - sizeof(*Filter))) / sizeof(*SourceList))) {
        WSASetLastError(WSAENOBUFS);
        return SOCKET_ERROR;
    }

    Size = GROUP_FILTER_SIZE(*SourceCount);
    Filter = (PGROUP_FILTER) HeapAlloc(GetProcessHeap(), 0, Size);
    if (Filter == NULL) {
        WSASetLastError(WSAENOBUFS);
        return SOCKET_ERROR;
    }

    Filter->gf_interface = Interface;
    ZeroMemory(&Filter->gf_group, sizeof(Filter->gf_group));
    CopyMemory(&Filter->gf_group, Group, GroupLength);
    Filter->gf_numsrc = *SourceCount;

    Error = WSAIoctl(Socket, SIOCGMSFILTER, Filter, Size, Filter, Size,
                     &Returned, NULL, NULL);

    if (Error == 0) {
        if (*SourceCount > 0) {
            CopyMemory(SourceList, Filter->gf_slist,
                       *SourceCount * sizeof(*SourceList));
            *SourceCount = Filter->gf_numsrc;
        }
        *FilterMode = Filter->gf_fmode;
    }

    HeapFree(GetProcessHeap(), 0, Filter);

    return Error;
}

*/

//
// Secure socket API definitions
//

INT WSASetSocketSecurity (
   SOCKET Socket,
   SOCKET_SECURITY_SETTINGS* SecuritySettings,
   ULONG SecuritySettingsLen,
   LPWSAOVERLAPPED Overlapped,
   LPWSAOVERLAPPED_COMPLETION_ROUTINE CompletionRoutine
);

INT WSAQuerySocketSecurity (
   SOCKET Socket,
   SOCKET_SECURITY_QUERY_TEMPLATE* SecurityQueryTemplate,
   ULONG SecurityQueryTemplateLen,
   SOCKET_SECURITY_QUERY_INFO* SecurityQueryInfo,
   ULONG* SecurityQueryInfoLen,
   LPWSAOVERLAPPED Overlapped,
   LPWSAOVERLAPPED_COMPLETION_ROUTINE CompletionRoutine
);

INT WSASetSocketPeerTargetName (
   SOCKET Socket,
   SOCKET_PEER_TARGET_NAME* PeerTargetName,
   ULONG PeerTargetNameLen,
   LPWSAOVERLAPPED Overlapped,
   LPWSAOVERLAPPED_COMPLETION_ROUTINE CompletionRoutine
);

INT WSADeleteSocketPeerTargetName (
   SOCKET Socket,
   sockaddr* PeerAddr,
   ULONG PeerAddrLen,
   LPWSAOVERLAPPED Overlapped,
   LPWSAOVERLAPPED_COMPLETION_ROUTINE CompletionRoutine
);

INT WSAImpersonateSocketPeer (
   SOCKET Socket,
   sockaddr* PeerAddr,
   ULONG PeerAddrLen
);

INT WSARevertImpersonation ();
