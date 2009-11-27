/*
 * winsock.d
 *
 * This module binds WinSock.h to D. The original copyright notice
 * is preserved below.
 *
 * Author: Dave Wilkinson
 * Originated: November 25th, 2009
 *
 */

module binding.win32.winsock;

import binding.c;

import binding.win32.windef;
import binding.win32.winbase;
import binding.win32.winnt;
import binding.win32.inaddr;

extern(System):

//$TAG BIZDEV
//  $IPCategory:
//  $DealPointID:    118736
//  $AgreementName:  berkeley software distribution license
//  $AgreementType:  oss license
//  $ExternalOrigin: regents of the university of california
//$ENDTAG

//$TAG ENGR
//  $Owner:    vadime
//  $Module:   published_inc
//
//$ENDTAG

/* WINSOCK.H--definitions to be used with the WINSOCK.DLL
 * Copyright (c) Microsoft Corporation. All rights reserved.
 *
 * This header file corresponds to version 1.1 of the Windows Sockets specification.
 *
 * This file includes parts which are Copyright (c) 1982-1986 Regents
 * of the University of California.  All rights reserved.  The
 * Berkeley Software License Agreement specifies the terms and
 * conditions for redistribution.
 *
 */


/*
 * Basic system type definitions, taken from the BSD file sys/types.h.
 */
alias ubyte   u_char;
alias ushort  u_short;
alias uint    u_int;
alias Culong_t   u_long;

/*
 * The new type to be used in all
 * instances which refer to sockets.
 */

alias UINT_PTR        SOCKET;

/*
 * Select uses arrays of SOCKETs.  These macros manipulate such
 * arrays.  FD_SETSIZE may be defined by the user before including
 * this file, but the default here should be >= 64.
 *
 * CAVEAT IMPLEMENTOR and USER: THESE MACROS AND TYPES MUST BE
 * INCLUDED IN WINSOCK.H EXACTLY AS SHOWN HERE.
 */

const auto FD_SETSIZE       = 64;

struct fd_set {
        u_int   fd_count;               /* how many are SET? */
        SOCKET[FD_SETSIZE]  fd_array;   /* an array of SOCKETs */
}

extern(C) int __WSAFDIsSet(SOCKET, fd_set*);
/+
const auto FD_CLR(fd,  = set) do { \;
    u_int __i; \
    for (__i = 0; __i < ((fd_set *)(set))->fd_count ; __i++) { \
        if (((fd_set *)(set))->fd_array[__i] == fd) { \
            while (__i < ((fd_set *)(set))->fd_count-1) { \
                ((fd_set *)(set))->fd_array[__i] = \
                    ((fd_set *)(set))->fd_array[__i+1]; \
                __i++; \
            } \
            ((fd_set *)(set))->fd_count--; \
            break; \
        } \
    } \
} while(0)

const auto FD_SET(fd,  = set) do { \;
    if (((fd_set *)(set))->fd_count < FD_SETSIZE) \
        ((fd_set *)(set))->fd_array[((fd_set *)(set))->fd_count++]=(fd);\
} while(0)

const auto FD_ZERO(set)  = (((fd_set *)(set))->fd_count=0);

const auto FD_ISSET(fd,  = set) __WSAFDIsSet((SOCKET)(fd), (fd_set *)(set));
+/
/*
 * Structure used in select() call, taken from the BSD file sys/time.h.
 */
struct timeval {
        Clong_t    tv_sec;         /* seconds */
        Clong_t    tv_usec;        /* and microseconds */
}

/*
 * Operations on timevals.
 *
 * NB: timercmp does not work for >= or <=.
 */
//const auto timerisset(tvp)          = ((tvp)->tv_sec || (tvp)->tv_usec);
/*const auto timercmp(tvp,  = uvp, cmp) \;
        ((tvp)->tv_sec cmp (uvp)->tv_sec || \
         (tvp)->tv_sec == (uvp)->tv_sec && (tvp)->tv_usec cmp (uvp)->tv_usec)
const auto timerclear(tvp)          = (tvp)->tv_sec = (tvp)->tv_usec = 0;
*/
/*
 * Commands for ioctlsocket(),  taken from the BSD file fcntl.h.
 *
 *
 * Ioctl's have the command encoded in the lower word,
 * and the size of any in or out parameters in the upper
 * word.  The high 2 bits of the upper word are used
 * to encode the in/out status of the parameter; for now
 * we restrict parameters to at most 128 bytes.
 */
const auto IOCPARM_MASK     = 0x7f            ; /* parameters must be < 128 bytes */
const auto IOC_VOID         = 0x20000000      ; /* no parameters */
const auto IOC_OUT          = 0x40000000      ; /* copy out parameters */
const auto IOC_IN           = 0x80000000      ; /* copy in parameters */
const auto IOC_INOUT        = (IOC_IN|IOC_OUT);
                                        /* 0x20000000 distinguishes new &
                                           old ioctl's */
template _IO(uint x, uint y) {
	const auto _IO = (IOC_VOID|((x)<<8)|(y));
}

template _IOR(char x, uint y, T) {
	const auto _IOR = (IOC_OUT|((cast(Clong_t)(T.sizeof) & IOCPARM_MASK)<<16)|((x)<<8)|(y));
}

template _IOW(char x, uint y, T) {
	const auto _IOW = (IOC_IN|((cast(Clong_t)(T.sizeof) & IOCPARM_MASK)<<16)|((x)<<8)|(y));
}

const auto FIONREAD     = _IOR!('f', 127, u_long) ; /* get # bytes to read */
const auto FIONBIO      = _IOW!('f', 126, u_long) ; /* set/clear non-blocking i/o */
const auto FIOASYNC     = _IOW!('f', 125, u_long) ; /* set/clear async i/o */

/* Socket I/O Controls */
const auto SIOCSHIWAT   = _IOW!('s',  0, u_long)  ; /* set high watermark */
const auto SIOCGHIWAT   = _IOR!('s',  1, u_long)  ; /* get high watermark */
const auto SIOCSLOWAT   = _IOW!('s',  2, u_long)  ; /* set low watermark */
const auto SIOCGLOWAT   = _IOR!('s',  3, u_long)  ; /* get low watermark */
const auto SIOCATMARK   = _IOR!('s',  7, u_long)  ; /* at oob mark? */

/*
 * Structures returned by network data base library, taken from the
 * BSD file netdb.h.  All addresses are supplied in host order, and
 * returned in network order (suitable for use in system calls).
 */

struct  hostent {
        char    * h_name;           /* official name of host */
        char    ** h_aliases;       /* alias list */
        short   h_addrtype;             /* host address type */
        short   h_length;               /* length of address */
        char    ** h_addr_list; /* list of addresses */
}

/*
 * It is assumed here that a network number
 * fits in 32 bits.
 */
struct  netent {
        char    * n_name;           /* official name of net */
        char    ** n_aliases;  /* alias list */
        short   n_addrtype;             /* net address type */
        u_long  n_net;                  /* network # */
};

struct  servent {
    char    * s_name;           /* official service name */
    char    ** s_aliases;  /* alias list */
	version(X86_64) {
	    char    * s_proto;          /* protocol to use */
	    short   s_port;                 /* port # */
	}
	else {
	    short   s_port;                 /* port # */
	    char    * s_proto;          /* protocol to use */
	}
};

struct  protoent {
    char    * p_name;           /* official protocol name */
    char    ** p_aliases;  /* alias list */
    short   p_proto;                /* protocol # */
}
/*
 * Constants and structures defined by the internet system,
 * Per RFC 790, September 1981, taken from the BSD file netinet/in.h.
 */

/*
 * Protocols
 */
const auto IPPROTO_IP               = 0               ; /* dummy for IP */
const auto IPPROTO_ICMP             = 1               ; /* control message protocol */
const auto IPPROTO_IGMP             = 2               ; /* group management protocol */
const auto IPPROTO_GGP              = 3               ; /* gateway^2 (deprecated) */
const auto IPPROTO_TCP              = 6               ; /* tcp */
const auto IPPROTO_PUP              = 12              ; /* pup */
const auto IPPROTO_UDP              = 17              ; /* user datagram protocol */
const auto IPPROTO_IDP              = 22              ; /* xns idp */
const auto IPPROTO_ND               = 77              ; /* UNOFFICIAL net disk proto */

const auto IPPROTO_RAW              = 255             ; /* raw IP packet */
const auto IPPROTO_MAX              = 256;

/*
 * Port/socket numbers: network standard functions
 */
const auto IPPORT_ECHO              = 7;
const auto IPPORT_DISCARD           = 9;
const auto IPPORT_SYSTAT            = 11;
const auto IPPORT_DAYTIME           = 13;
const auto IPPORT_NETSTAT           = 15;
const auto IPPORT_FTP               = 21;
const auto IPPORT_TELNET            = 23;
const auto IPPORT_SMTP              = 25;
const auto IPPORT_TIMESERVER        = 37;
const auto IPPORT_NAMESERVER        = 42;
const auto IPPORT_WHOIS             = 43;
const auto IPPORT_MTP               = 57;

/*
 * Port/socket numbers: host specific functions
 */
const auto IPPORT_TFTP              = 69;
const auto IPPORT_RJE               = 77;
const auto IPPORT_FINGER            = 79;
const auto IPPORT_TTYLINK           = 87;
const auto IPPORT_SUPDUP            = 95;

/*
 * UNIX TCP sockets
 */
const auto IPPORT_EXECSERVER        = 512;
const auto IPPORT_LOGINSERVER       = 513;
const auto IPPORT_CMDSERVER         = 514;
const auto IPPORT_EFSSERVER         = 520;

/*
 * UNIX UDP sockets
 */
const auto IPPORT_BIFFUDP           = 512;
const auto IPPORT_WHOSERVER         = 513;
const auto IPPORT_ROUTESERVER       = 520;
                                        /* 520+1 also used */

/*
 * Ports < IPPORT_RESERVED are reserved for
 * privileged processes (e.g. root).
 */
const auto IPPORT_RESERVED          = 1024;

/*
 * Link numbers
 */
const auto IMPLINK_IP               = 155;
const auto IMPLINK_LOWEXPER         = 156;
const auto IMPLINK_HIGHEXPER        = 158;

// #include <inaddr.h>

/*
 * Definitions of bits in internet address integers.
 * On subnets, the decomposition of addresses to host and net parts
 * is done according to subnet mask, not the masks here.
 */
//const auto IN_CLASSA(i)             = ((cast(Clong_t)(i) & 0x80000000) == 0);
const auto IN_CLASSA_NET            = 0xff000000;
const auto IN_CLASSA_NSHIFT         = 24;
const auto IN_CLASSA_HOST           = 0x00ffffff;
const auto IN_CLASSA_MAX            = 128;

//const auto IN_CLASSB(i)             = ((cast(Clong_t)(i) & 0xc0000000) == 0x80000000);
const auto IN_CLASSB_NET            = 0xffff0000;
const auto IN_CLASSB_NSHIFT         = 16;
const auto IN_CLASSB_HOST           = 0x0000ffff;
const auto IN_CLASSB_MAX            = 65536;

//const auto IN_CLASSC(i)             = ((cast(Clong_t)(i) & 0xe0000000) == 0xc0000000);
const auto IN_CLASSC_NET            = 0xffffff00;
const auto IN_CLASSC_NSHIFT         = 8;
const auto IN_CLASSC_HOST           = 0x000000ff;

const auto INADDR_ANY               = cast(u_long)0x00000000;
const auto INADDR_LOOPBACK          = 0x7f000001;
const auto INADDR_BROADCAST         = cast(u_long)0xffffffff;
const auto INADDR_NONE              = 0xffffffff;

/*
 * Socket address, internet style.
 */
struct sockaddr_in {
        short   sin_family;
        u_short sin_port;
        in_addr sin_addr;
        char[8]    sin_zero;
};

const auto WSADESCRIPTION_LEN       = 256;
const auto WSASYS_STATUS_LEN        = 128;

struct WSADATA {
        WORD                    wVersion;
        WORD                    wHighVersion;
		version(X86_64) {
		        ushort          iMaxSockets;
		        ushort          iMaxUdpDg;
		        char *              lpVendorInfo;
		        char[WSADESCRIPTION_LEN+1]                    szDescription;
		        char[WSASYS_STATUS_LEN+1]                    szSystemStatus;
		}
		else {
		        char[WSADESCRIPTION_LEN+1]                    szDescription;
		        char[WSASYS_STATUS_LEN+1]                    szSystemStatus;
		        ushort          iMaxSockets;
		        ushort          iMaxUdpDg;
		        char *              lpVendorInfo;
		}
}


alias WSADATA *LPWSADATA;

/*
 * Options for use with [gs]etsockopt at the IP level.
 */
const auto IP_OPTIONS           = 1           ; /* set/get IP per-packet options    */
const auto IP_MULTICAST_IF      = 2           ; /* set/get IP multicast interface   */
const auto IP_MULTICAST_TTL     = 3           ; /* set/get IP multicast timetolive  */
const auto IP_MULTICAST_LOOP    = 4           ; /* set/get IP multicast loopback    */
const auto IP_ADD_MEMBERSHIP    = 5           ; /* add  an IP group membership      */
const auto IP_DROP_MEMBERSHIP   = 6           ; /* drop an IP group membership      */
const auto IP_TTL               = 7           ; /* set/get IP Time To Live          */
const auto IP_TOS               = 8           ; /* set/get IP Type Of Service       */
const auto IP_DONTFRAGMENT      = 9           ; /* set/get IP Don't Fragment flag   */


const auto IP_DEFAULT_MULTICAST_TTL    = 1    ; /* normally limit m'casts to 1 hop  */
const auto IP_DEFAULT_MULTICAST_LOOP   = 1    ; /* normally hear sends if a member  */
const auto IP_MAX_MEMBERSHIPS          = 20   ; /* per socket; must fit in one mbuf */

/*
 * Argument structure for IP_ADD_MEMBERSHIP and IP_DROP_MEMBERSHIP.
 */
struct ip_mreq {
        in_addr  imr_multiaddr;  /* IP multicast address of group */
        in_addr  imr_interface;  /* local IP address of interface */
}

/*
 * Definitions related to sockets: types, address families, options,
 * taken from the BSD file sys/socket.h.
 */

/*
 * This is used instead of -1, since the
 * SOCKET type is unsigned.
 */
const auto INVALID_SOCKET   = cast(SOCKET)(~0);
const auto SOCKET_ERROR             = (-1);

/*
 * Types
 */
const auto SOCK_STREAM      = 1               ; /* stream socket */
const auto SOCK_DGRAM       = 2               ; /* datagram socket */
const auto SOCK_RAW         = 3               ; /* raw-protocol interface */
const auto SOCK_RDM         = 4               ; /* reliably-delivered message */
const auto SOCK_SEQPACKET   = 5               ; /* sequenced packet stream */

/*
 * Option flags per-socket.
 */
const auto SO_DEBUG         = 0x0001          ; /* turn on debugging info recording */
const auto SO_ACCEPTCONN    = 0x0002          ; /* socket has had listen() */
const auto SO_REUSEADDR     = 0x0004          ; /* allow local address reuse */
const auto SO_KEEPALIVE     = 0x0008          ; /* keep connections alive */
const auto SO_DONTROUTE     = 0x0010          ; /* just use interface addresses */
const auto SO_BROADCAST     = 0x0020          ; /* permit sending of broadcast msgs */
const auto SO_USELOOPBACK   = 0x0040          ; /* bypass hardware when possible */
const auto SO_LINGER        = 0x0080          ; /* linger on close if data present */
const auto SO_OOBINLINE     = 0x0100          ; /* leave received OOB data in line */

const auto SO_DONTLINGER    = cast(u_int)(~SO_LINGER);

/*
 * Additional options.
 */
const auto SO_SNDBUF        = 0x1001          ; /* send buffer size */
const auto SO_RCVBUF        = 0x1002          ; /* receive buffer size */
const auto SO_SNDLOWAT      = 0x1003          ; /* send low-water mark */
const auto SO_RCVLOWAT      = 0x1004          ; /* receive low-water mark */
const auto SO_SNDTIMEO      = 0x1005          ; /* send timeout */
const auto SO_RCVTIMEO      = 0x1006          ; /* receive timeout */
const auto SO_ERROR         = 0x1007          ; /* get error status and clear */
const auto SO_TYPE          = 0x1008          ; /* get socket type */

/*
 * Options for connect and disconnect data and options.  Used only by
 * non-TCP/IP transports such as DECNet, OSI TP4, etc.
 */
const auto SO_CONNDATA      = 0x7000;
const auto SO_CONNOPT       = 0x7001;
const auto SO_DISCDATA      = 0x7002;
const auto SO_DISCOPT       = 0x7003;
const auto SO_CONNDATALEN   = 0x7004;
const auto SO_CONNOPTLEN    = 0x7005;
const auto SO_DISCDATALEN   = 0x7006;
const auto SO_DISCOPTLEN    = 0x7007;

/*
 * Option for opening sockets for synchronous access.
 */
const auto SO_OPENTYPE      = 0x7008;

const auto SO_SYNCHRONOUS_ALERT     = 0x10;
const auto SO_SYNCHRONOUS_NONALERT  = 0x20;

/*
 * Other NT-specific options.
 */
const auto SO_MAXDG         = 0x7009;
const auto SO_MAXPATHDG     = 0x700A;
const auto SO_UPDATE_ACCEPT_CONTEXT  = 0x700B;
const auto SO_CONNECT_TIME  = 0x700C;

/*
 * TCP options.
 */
const auto TCP_NODELAY      = 0x0001;
const auto TCP_BSDURGENT    = 0x7000;

/*
 * Address families.
 */
const auto AF_UNSPEC        = 0               ; /* unspecified */
const auto AF_UNIX          = 1               ; /* local to host (pipes, portals) */
const auto AF_INET          = 2               ; /* internetwork: UDP, TCP, etc. */
const auto AF_IMPLINK       = 3               ; /* arpanet imp addresses */
const auto AF_PUP           = 4               ; /* pup protocols: e.g. BSP */
const auto AF_CHAOS         = 5               ; /* mit CHAOS protocols */
const auto AF_IPX           = 6               ; /* IPX and SPX */
const auto AF_NS            = 6               ; /* XEROX NS protocols */
const auto AF_ISO           = 7               ; /* ISO protocols */
const auto AF_OSI           = AF_ISO          ; /* OSI is ISO */
const auto AF_ECMA          = 8               ; /* european computer manufacturers */
const auto AF_DATAKIT       = 9               ; /* datakit protocols */
const auto AF_CCITT         = 10              ; /* CCITT protocols, X.25 etc */
const auto AF_SNA           = 11              ; /* IBM SNA */
const auto AF_DECnet        = 12              ; /* DECnet */
const auto AF_DLI           = 13              ; /* Direct data link interface */
const auto AF_LAT           = 14              ; /* LAT */
const auto AF_HYLINK        = 15              ; /* NSC Hyperchannel */
const auto AF_APPLETALK     = 16              ; /* AppleTalk */
const auto AF_NETBIOS       = 17              ; /* NetBios-style addresses */
const auto AF_VOICEVIEW     = 18              ; /* VoiceView */
const auto AF_FIREFOX       = 19              ; /* FireFox */
const auto AF_UNKNOWN1      = 20              ; /* Somebody is using this! */
const auto AF_BAN           = 21              ; /* Banyan */

const auto AF_MAX           = 22;

/*
 * Structure used by kernel to store most
 * addresses.
 */
struct sockaddr {
        u_short sa_family;              /* address family */
        char[14]    sa_data;            /* up to 14 bytes of direct address */
};

/*
 * Structure used by kernel to pass protocol
 * information in raw sockets.
 */
struct sockproto {
        u_short sp_family;              /* address family */
        u_short sp_protocol;            /* protocol */
};

/*
 * Protocol families, same as address families for now.
 */
const auto PF_UNSPEC        = AF_UNSPEC;
const auto PF_UNIX          = AF_UNIX;
const auto PF_INET          = AF_INET;
const auto PF_IMPLINK       = AF_IMPLINK;
const auto PF_PUP           = AF_PUP;
const auto PF_CHAOS         = AF_CHAOS;
const auto PF_NS            = AF_NS;
const auto PF_IPX           = AF_IPX;
const auto PF_ISO           = AF_ISO;
const auto PF_OSI           = AF_OSI;
const auto PF_ECMA          = AF_ECMA;
const auto PF_DATAKIT       = AF_DATAKIT;
const auto PF_CCITT         = AF_CCITT;
const auto PF_SNA           = AF_SNA;
const auto PF_DECnet        = AF_DECnet;
const auto PF_DLI           = AF_DLI;
const auto PF_LAT           = AF_LAT;
const auto PF_HYLINK        = AF_HYLINK;
const auto PF_APPLETALK     = AF_APPLETALK;
const auto PF_VOICEVIEW     = AF_VOICEVIEW;
const auto PF_FIREFOX       = AF_FIREFOX;
const auto PF_UNKNOWN1      = AF_UNKNOWN1;
const auto PF_BAN           = AF_BAN;

const auto PF_MAX           = AF_MAX;

/*
 * Structure used for manipulating linger option.
 */
struct  linger {
        u_short l_onoff;                /* option on/off */
        u_short l_linger;               /* linger time */
};

/*
 * Level number for (get/set)sockopt() to apply to socket itself.
 */
const auto SOL_SOCKET       = 0xffff          ; /* options for socket level */

/*
 * Maximum queue length specifiable by listen.
 */
const auto SOMAXCONN        = 5;

const auto MSG_OOB          = 0x1             ; /* process out-of-band data */
const auto MSG_PEEK         = 0x2             ; /* peek at incoming message */
const auto MSG_DONTROUTE    = 0x4             ; /* send without using routing tables */

const auto MSG_MAXIOVLEN    = 16;

const auto MSG_PARTIAL      = 0x8000          ; /* partial send or recv for message xport */

/*
 * Define constant based on rfc883, used by gethostbyxxxx() calls.
 */
const auto MAXGETHOSTSTRUCT         = 1024;

/*
 * Define flags to be used with the WSAAsyncSelect() call.
 */
const auto FD_READ          = 0x01;
const auto FD_WRITE         = 0x02;
const auto FD_OOB           = 0x04;
const auto FD_ACCEPT        = 0x08;
const auto FD_CONNECT       = 0x10;
const auto FD_CLOSE         = 0x20;

/*
 * WinSock error codes are also defined in winerror.h
 * Hence the IFDEF.
 */

/*
 * All Windows Sockets error constants are biased by WSABASEERR from
 * the "normal"
 */
const auto WSABASEERR               = 10000;
/*
 * Windows Sockets definitions of regular Microsoft C error constants
 */
const auto WSAEINTR                 = (WSABASEERR+4);
const auto WSAEBADF                 = (WSABASEERR+9);
const auto WSAEACCES                = (WSABASEERR+13);
const auto WSAEFAULT                = (WSABASEERR+14);
const auto WSAEINVAL                = (WSABASEERR+22);
const auto WSAEMFILE                = (WSABASEERR+24);

/*
 * Windows Sockets definitions of regular Berkeley error constants
 */
const auto WSAEWOULDBLOCK           = (WSABASEERR+35);
const auto WSAEINPROGRESS           = (WSABASEERR+36);
const auto WSAEALREADY              = (WSABASEERR+37);
const auto WSAENOTSOCK              = (WSABASEERR+38);
const auto WSAEDESTADDRREQ          = (WSABASEERR+39);
const auto WSAEMSGSIZE              = (WSABASEERR+40);
const auto WSAEPROTOTYPE            = (WSABASEERR+41);
const auto WSAENOPROTOOPT           = (WSABASEERR+42);
const auto WSAEPROTONOSUPPORT       = (WSABASEERR+43);
const auto WSAESOCKTNOSUPPORT       = (WSABASEERR+44);
const auto WSAEOPNOTSUPP            = (WSABASEERR+45);
const auto WSAEPFNOSUPPORT          = (WSABASEERR+46);
const auto WSAEAFNOSUPPORT          = (WSABASEERR+47);
const auto WSAEADDRINUSE            = (WSABASEERR+48);
const auto WSAEADDRNOTAVAIL         = (WSABASEERR+49);
const auto WSAENETDOWN              = (WSABASEERR+50);
const auto WSAENETUNREACH           = (WSABASEERR+51);
const auto WSAENETRESET             = (WSABASEERR+52);
const auto WSAECONNABORTED          = (WSABASEERR+53);
const auto WSAECONNRESET            = (WSABASEERR+54);
const auto WSAENOBUFS               = (WSABASEERR+55);
const auto WSAEISCONN               = (WSABASEERR+56);
const auto WSAENOTCONN              = (WSABASEERR+57);
const auto WSAESHUTDOWN             = (WSABASEERR+58);
const auto WSAETOOMANYREFS          = (WSABASEERR+59);
const auto WSAETIMEDOUT             = (WSABASEERR+60);
const auto WSAECONNREFUSED          = (WSABASEERR+61);
const auto WSAELOOP                 = (WSABASEERR+62);
const auto WSAENAMETOOLONG          = (WSABASEERR+63);
const auto WSAEHOSTDOWN             = (WSABASEERR+64);
const auto WSAEHOSTUNREACH          = (WSABASEERR+65);
const auto WSAENOTEMPTY             = (WSABASEERR+66);
const auto WSAEPROCLIM              = (WSABASEERR+67);
const auto WSAEUSERS                = (WSABASEERR+68);
const auto WSAEDQUOT                = (WSABASEERR+69);
const auto WSAESTALE                = (WSABASEERR+70);
const auto WSAEREMOTE               = (WSABASEERR+71);

const auto WSAEDISCON               = (WSABASEERR+101);

/*
 * Extended Windows Sockets error constant definitions
 */
const auto WSASYSNOTREADY           = (WSABASEERR+91);
const auto WSAVERNOTSUPPORTED       = (WSABASEERR+92);
const auto WSANOTINITIALISED        = (WSABASEERR+93);

/*
 * Error return codes from gethostbyname() and gethostbyaddr()
 * (when using the resolver). Note that these errors are
 * retrieved via WSAGetLastError() and must therefore follow
 * the rules for avoiding clashes with error numbers from
 * specific implementations or language run-time systems.
 * For this reason the codes are based at WSABASEERR+1001.
 * Note also that [WSA]NO_ADDRESS is defined only for
 * compatibility purposes.
 */


/* Authoritative Answer: Host not found */
const auto WSAHOST_NOT_FOUND        = (WSABASEERR+1001);

/* Non-Authoritative: Host not found, or SERVERFAIL */
const auto WSATRY_AGAIN             = (WSABASEERR+1002);

/* Non recoverable errors, FORMERR, REFUSED, NOTIMP */
const auto WSANO_RECOVERY           = (WSABASEERR+1003);

/* Valid name, no data record of requested type */
const auto WSANO_DATA               = (WSABASEERR+1004);

/*
 * WinSock error codes are also defined in winerror.h
 * Hence the IFDEF.
 */

/*
 * Compatibility macros.
 */


alias WSAGetLastError h_errno;

const auto HOST_NOT_FOUND           = WSAHOST_NOT_FOUND;
const auto TRY_AGAIN                = WSATRY_AGAIN;
const auto NO_RECOVERY              = WSANO_RECOVERY;
const auto NO_DATA                  = WSANO_DATA;
/* no address, look for MX record */
const auto WSANO_ADDRESS            = WSANO_DATA;
const auto NO_ADDRESS               = WSANO_ADDRESS;

/*
 * Windows Sockets errors redefined as regular Berkeley error constants.
 * These are commented out in Windows NT to avoid conflicts with errno.h.
 * Use the WSA constants instead.
 */

/* Socket function prototypes */

SOCKET accept (
                          SOCKET s,
                          sockaddr *addr,
                          int *addrlen);

int bind (
                     SOCKET s,
                     sockaddr *addr,
                     int namelen);

int closesocket ( SOCKET s);

int connect (
                        SOCKET s,
                        sockaddr *name,
                        int namelen);

int ioctlsocket (
							SOCKET s,
                            Clong_t cmd,
                            u_long *argp);

int getpeername (
                            SOCKET s,
                            sockaddr *name,
                            int * namelen);

int getsockname (
                            SOCKET s,
                            sockaddr *name,
                            int * namelen);

int getsockopt (
                           SOCKET s,
                           int level,
                           int optname,
    						char * optval,
                           int *optlen);

u_long htonl ( u_long hostlong);

u_short htons (u_short hostshort);

Culong_t inet_addr (char * cp);

char * inet_ntoa (in_addr _in);

int listen (
                       SOCKET s,
                       int backlog);

u_long ntohl (u_long netlong);

u_short ntohs (u_short netshort);

int recv (
                     SOCKET s,
					 char * buf,
                     int len,
                     int flags);

int recvfrom (
                         SOCKET s,
						 char * buf,
                         int len,
                         int flags,
						 sockaddr * from,
                         int * fromlen);

int select (
                        int nfds,
                        fd_set *readfds,
                        fd_set *writefds,
                        fd_set *exceptfds,
                        timeval *timeout);

int send (
                     SOCKET s,
                     char * buf,
                     int len,
                     int flags);

int sendto (
                       SOCKET s,
                       char * buf,
                       int len,
                       int flags,
                       sockaddr *to,
                       int tolen);

int setsockopt (
                           SOCKET s,
                           int level,
                           int optname,
                           char * optval,
                           int optlen);

int shutdown (
                         SOCKET s,
                         int how);

SOCKET socket (
                          int af,
                          int type,
                          int protocol);

/* Database function prototypes */

hostent * gethostbyaddr(
                                              char * addr,
                                              int len,
                                              int type);

hostent * gethostbyname(char * name);

int gethostname (
	 						char * name,
                            int namelen);

servent * getservbyport(
                                              int port,
                                              char * proto);

servent * getservbyname(
                                              char * name,
                                              char * proto);

protoent * getprotobynumber(int proto);

protoent * getprotobyname(char * name);

/* Microsoft Windows Extension function prototypes */

int WSAStartup(
                          WORD wVersionRequired,
                          LPWSADATA lpWSAData);

int WSACleanup();

void WSASetLastError(int iError);

int WSAGetLastError();

BOOL WSAIsBlocking();

int WSAUnhookBlockingHook();

FARPROC WSASetBlockingHook(FARPROC lpBlockFunc);

int WSACancelBlockingCall();

HANDLE WSAAsyncGetServByName(
                                        HWND hWnd,
                                        u_int wMsg,
                                        char * name,
                                        char * proto,
										char * buf,
                                        int buflen);

HANDLE WSAAsyncGetServByPort(
                                        HWND hWnd,
                                        u_int wMsg,
                                        int port,
                                        char * proto,
										char * buf,
                                        int buflen);

HANDLE WSAAsyncGetProtoByName(
                                         HWND hWnd,
                                         u_int wMsg,
                                         char * name,
										 char * buf,
                                         int buflen);

HANDLE WSAAsyncGetProtoByNumber(
                                           HWND hWnd,
                                           u_int wMsg,
                                           int number,
										   char * buf,
                                           int buflen);

HANDLE WSAAsyncGetHostByName(
                                        HWND hWnd,
                                        u_int wMsg,
                                        char * name,
										char * buf,
                                        int buflen);

HANDLE WSAAsyncGetHostByAddr(
                                        HWND hWnd,
                                        u_int wMsg,
                                        char * addr,
                                        int len,
                                        int type,
										char * buf,
                                        int buflen);

int WSACancelAsyncRequest(HANDLE hAsyncTaskHandle);

int WSAAsyncSelect(
                              SOCKET s,
                              HWND hWnd,
                              u_int wMsg,
                              Clong_t lEvent);

int WSARecvEx (
                          SOCKET s,
						  char * buf,
                          int len,
                          int *flags);

struct TRANSMIT_FILE_BUFFERS {
    PVOID Head;
    DWORD HeadLength;
    PVOID Tail;
    DWORD TailLength;
}

typedef TRANSMIT_FILE_BUFFERS* PTRANSMIT_FILE_BUFFERS;
typedef TRANSMIT_FILE_BUFFERS* LPTRANSMIT_FILE_BUFFERS;

const auto TF_DISCONNECT        = 0x01;
const auto TF_REUSE_SOCKET      = 0x02;
const auto TF_WRITE_BEHIND      = 0x04;

BOOL TransmitFile (
    SOCKET hSocket,
    HANDLE hFile,
    DWORD nNumberOfBytesToWrite,
    DWORD nNumberOfBytesPerSend,
    LPOVERLAPPED lpOverlapped,
    LPTRANSMIT_FILE_BUFFERS lpTransmitBuffers,
    DWORD dwReserved
    );

BOOL AcceptEx (
    SOCKET sListenSocket,
    SOCKET sAcceptSocket,
    PVOID lpOutputBuffer,
    DWORD dwReceiveDataLength,
    DWORD dwLocalAddressLength,
    DWORD dwRemoteAddressLength,
    LPDWORD lpdwBytesReceived,
    LPOVERLAPPED lpOverlapped
    );

VOID GetAcceptExSockaddrs (
    PVOID lpOutputBuffer,
    DWORD dwReceiveDataLength,
    DWORD dwLocalAddressLength,
    DWORD dwRemoteAddressLength,
    sockaddr **LocalSockaddr,
    LPINT LocalSockaddrLength,
    sockaddr **RemoteSockaddr,
    LPINT RemoteSockaddrLength
    );

/* Microsoft Windows Extended data types */
typedef sockaddr SOCKADDR;
typedef sockaddr *PSOCKADDR;
typedef sockaddr *LPSOCKADDR;

typedef sockaddr_in SOCKADDR_IN;
typedef sockaddr_in *PSOCKADDR_IN;
typedef sockaddr_in *LPSOCKADDR_IN;

typedef linger LINGER;
typedef linger *PLINGER;
typedef linger *LPLINGER;

typedef fd_set FD_SET;
typedef fd_set *PFD_SET;
typedef fd_set *LPFD_SET;

typedef hostent HOSTENT;
typedef hostent *PHOSTENT;
typedef hostent *LPHOSTENT;

typedef servent SERVENT;
typedef servent *PSERVENT;
typedef servent *LPSERVENT;

typedef protoent PROTOENT;
typedef protoent *PPROTOENT;
typedef protoent *LPPROTOENT;

typedef timeval TIMEVAL;
typedef timeval *PTIMEVAL;
typedef timeval *LPTIMEVAL;

/*
 * Windows message parameter composition and decomposition
 * macros.
 *
 * WSAMAKEASYNCREPLY is intended for use by the Windows Sockets implementation
 * when constructing the response to a WSAAsyncGetXByY() routine.
 */
//const auto WSAMAKEASYNCREPLY(buflen,error)      = MAKELONG(buflen,error);
/*
 * WSAMAKESELECTREPLY is intended for use by the Windows Sockets implementation
 * when constructing the response to WSAAsyncSelect().
 */
//const auto WSAMAKESELECTREPLY(event,error)      = MAKELONG(event,error);
/*
 * WSAGETASYNCBUFLEN is intended for use by the Windows Sockets application
 * to extract the buffer length from the lParam in the response
 * to a WSAGetXByY().
 */
//const auto WSAGETASYNCBUFLEN(lParam)            = LOWORD(lParam);
/*
 * WSAGETASYNCERROR is intended for use by the Windows Sockets application
 * to extract the error code from the lParam in the response
 * to a WSAGetXByY().
 */
//const auto WSAGETASYNCERROR(lParam)             = HIWORD(lParam);
/*
 * WSAGETSELECTEVENT is intended for use by the Windows Sockets application
 * to extract the event code from the lParam in the response
 * to a WSAAsyncSelect().
 */
//const auto WSAGETSELECTEVENT(lParam)            = LOWORD(lParam);
/*
 * WSAGETSELECTERROR is intended for use by the Windows Sockets application
 * to extract the error code from the lParam in the response
 * to a WSAAsyncSelect().
 */
//const auto WSAGETSELECTERROR(lParam)            = HIWORD(lParam);

