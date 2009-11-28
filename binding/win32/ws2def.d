/*
 * ws2def.d
 *
 * This module binds ws2def.h to D. The original copyright notice
 * is preserved below.
 *
 * Author: Dave Wilkinson
 * Originated: November 25th, 2009
 *
 */

module binding.win32.ws2def;

import binding.c;

import binding.win32.windef;
import binding.win32.winbase;
import binding.win32.winnt;
import binding.win32.inaddr;

//
// Address families.
//

alias USHORT ADDRESS_FAMILY;

//#endif//(_WIN32_WINNT >= 0x0600)

//
// Although AF_UNSPEC is defined for backwards compatibility, using
// AF_UNSPEC for the "af" parameter when creating a socket is STRONGLY
// DISCOURAGED.  The interpretation of the "protocol" parameter
// depends on the actual address family chosen.  As environments grow
// to include more and more address families that use overlapping
// protocol values there is more and more chance of choosing an
// undesired address family when AF_UNSPEC is used.
//
const auto AF_UNSPEC        = 0               ; // unspecified
const auto AF_UNIX          = 1               ; // local to host (pipes, portals)
const auto AF_INET          = 2               ; // internetwork: UDP, TCP, etc.
const auto AF_IMPLINK       = 3               ; // arpanet imp addresses
const auto AF_PUP           = 4               ; // pup protocols: e.g. BSP
const auto AF_CHAOS         = 5               ; // mit CHAOS protocols
const auto AF_NS            = 6               ; // XEROX NS protocols
const auto AF_IPX           = AF_NS           ; // IPX protocols: IPX, SPX, etc.
const auto AF_ISO           = 7               ; // ISO protocols
const auto AF_OSI           = AF_ISO          ; // OSI is ISO
const auto AF_ECMA          = 8               ; // european computer manufacturers
const auto AF_DATAKIT       = 9               ; // datakit protocols
const auto AF_CCITT         = 10              ; // CCITT protocols, X.25 etc
const auto AF_SNA           = 11              ; // IBM SNA
const auto AF_DECnet        = 12              ; // DECnet
const auto AF_DLI           = 13              ; // Direct data link interface
const auto AF_LAT           = 14              ; // LAT
const auto AF_HYLINK        = 15              ; // NSC Hyperchannel
const auto AF_APPLETALK     = 16              ; // AppleTalk
const auto AF_NETBIOS       = 17              ; // NetBios-style addresses
const auto AF_VOICEVIEW     = 18              ; // VoiceView
const auto AF_FIREFOX       = 19              ; // Protocols from Firefox
const auto AF_UNKNOWN1      = 20              ; // Somebody is using this!
const auto AF_BAN           = 21              ; // Banyan
const auto AF_ATM           = 22              ; // Native ATM Services
const auto AF_INET6         = 23              ; // Internetwork Version 6
const auto AF_CLUSTER       = 24              ; // Microsoft Wolfpack
const auto AF_12844         = 25              ; // IEEE 1284.4 WG AF
const auto AF_IRDA          = 26              ; // IrDA
const auto AF_NETDES        = 28              ; // Network Designers OSI & gateway

const auto AF_TCNPROCESS    = 29;
const auto AF_TCNMESSAGE    = 30;
const auto AF_ICLFXBM       = 31;

const auto AF_BTH           = 32              ; // Bluetooth RFCOMM/L2CAP protocols
const auto AF_MAX           = 33;

//
// Socket types.
//

const auto SOCK_STREAM      = 1;
const auto SOCK_DGRAM       = 2;
const auto SOCK_RAW         = 3;
const auto SOCK_RDM         = 4;
const auto SOCK_SEQPACKET   = 5;

//
// Define a level for socket I/O controls in the same numbering space as
// IPPROTO_TCP, IPPROTO_IP, etc.
//

const auto SOL_SOCKET  = 0xffff;

//
// Define socket-level options.
//

const auto SO_DEBUG         = 0x0001      ; // turn on debugging info recording
const auto SO_ACCEPTCONN    = 0x0002      ; // socket has had listen()
const auto SO_REUSEADDR     = 0x0004      ; // allow local address reuse
const auto SO_KEEPALIVE     = 0x0008      ; // keep connections alive
const auto SO_DONTROUTE     = 0x0010      ; // just use interface addresses
const auto SO_BROADCAST     = 0x0020      ; // permit sending of broadcast msgs
const auto SO_USELOOPBACK   = 0x0040      ; // bypass hardware when possible
const auto SO_LINGER        = 0x0080      ; // linger on close if data present
const auto SO_OOBINLINE     = 0x0100      ; // leave received OOB data in line

const auto SO_DONTLINGER    = cast(int)(~SO_LINGER);
const auto SO_EXCLUSIVEADDRUSE  = (cast(int)(~SO_REUSEADDR))          ; // disallow local address reuse

const auto SO_SNDBUF        = 0x1001      ; // send buffer size
const auto SO_RCVBUF        = 0x1002      ; // receive buffer size
const auto SO_SNDLOWAT      = 0x1003      ; // send low-water mark
const auto SO_RCVLOWAT      = 0x1004      ; // receive low-water mark
const auto SO_SNDTIMEO      = 0x1005      ; // send timeout
const auto SO_RCVTIMEO      = 0x1006      ; // receive timeout
const auto SO_ERROR         = 0x1007      ; // get error status and clear
const auto SO_TYPE          = 0x1008      ; // get socket type
const auto SO_BSP_STATE     = 0x1009      ; // get socket 5-tuple state

const auto SO_GROUP_ID      = 0x2001      ; // ID of a socket group
const auto SO_GROUP_PRIORITY  = 0x2002    ; // the relative priority within a group
const auto SO_MAX_MSG_SIZE  = 0x2003      ; // maximum message size

const auto SO_CONDITIONAL_ACCEPT  = 0x3002 ; // enable true conditional accept:
                                    // connection is not ack-ed to the
                                    // other side until conditional
                                    // function returns CF_ACCEPT
const auto SO_PAUSE_ACCEPT  = 0x3003      ; // pause accepting new connections
const auto SO_COMPARTMENT_ID  = 0x3004    ; // get/set the compartment for a socket

const auto SO_RANDOMIZE_PORT  = 0x3005    ; // randomize assignment of wildcard ports

//
// Base constant used for defining WSK-specific options.
//

const auto WSK_SO_BASE   = 0x4000;

//
// Options to use with [gs]etsockopt at the IPPROTO_TCP level.
//

const auto TCP_NODELAY          = 0x0001;

//
// Structure used to store most addresses.
//
struct SOCKADDR {
    ADDRESS_FAMILY sa_family;           // Address family.

    CHAR[14] sa_data;                   // Up to 14 bytes of direct address.
}

alias SOCKADDR sockaddr;

alias SOCKADDR* PSOCKADDR;
alias SOCKADDR* LPSOCKADDR;

/*
 * SockAddr Information
 */
struct SOCKET_ADDRESS {
    LPSOCKADDR lpSockaddr;
    INT iSockaddrLength;
}

alias SOCKET_ADDRESS* PSOCKET_ADDRESS;
alias SOCKET_ADDRESS* LPSOCKET_ADDRESS;

/*
 * Address list returned via SIO_ADDRESS_LIST_QUERY
 */
struct SOCKET_ADDRESS_LIST {
    INT             iAddressCount;
    SOCKET_ADDRESS[1]  Address;
}

alias SOCKET_ADDRESS_LIST* PSOCKET_ADDRESS_LIST;
alias SOCKET_ADDRESS_LIST* LPSOCKET_ADDRESS_LIST;

/*
template SIZEOF_SOCKET_ADDRESS_LIST(uint AddressCount) {
	const auto SIZEOF_SOCKET_ADDRESS_LIST =
    (FIELD_OFFSET(SOCKET_ADDRESS_LIST, Address) +
     AddressCount * SOCKET_ADDRESS.sizeof);
}
template SIZEOF_SOCKET_ADDRESS_LIST(uint AddressCount)
 	const auto SIZEOF_SOCKET_ADDRESS_LIST =
    (FIELD_OFFSET(SOCKET_ADDRESS_LIST, Address) +
     AddressCount * SOCKET_ADDRESS.sizeof);
}
*/

/*
 * CSAddr Information
 */
struct CSADDR_INFO {
    SOCKET_ADDRESS LocalAddr ;
    SOCKET_ADDRESS RemoteAddr ;
    INT iSocketType ;
    INT iProtocol ;
}

alias CSADDR_INFO* PCSADDR_INFO;
alias CSADDR_INFO*  LPCSADDR_INFO ;

//
// Portable socket structure (RFC 2553).
//

//
// Desired design of maximum size and alignment.
// These are implementation specific.
//
const auto _SS_MAXSIZE  = 128                 ; // Maximum size
const auto _SS_ALIGNSIZE  = (long.sizeof) ; // Desired alignment

//
// Definitions used for sockaddr_storage structure paddings design.
//

const auto _SS_PAD1SIZE  = (_SS_ALIGNSIZE - USHORT.sizeof);
const auto _SS_PAD2SIZE  = (_SS_MAXSIZE - (USHORT.sizeof + _SS_PAD1SIZE + _SS_ALIGNSIZE));

struct SOCKADDR_STORAGE_LH {
    ADDRESS_FAMILY ss_family;      // address family

    CHAR[_SS_PAD1SIZE] __ss_pad1;  // 6 byte pad, this is to make
                                   //   implementation specific pad up to
                                   //   alignment field that follows explicit
                                   //   in the data structure
    long __ss_align;            // Field to force desired structure
    CHAR[_SS_PAD2SIZE] __ss_pad2;  // 112 byte pad to achieve desired size;
                                   //   _SS_MAXSIZE value minus size of
                                   //   ss_family, __ss_pad1, and
                                   //   __ss_align fields is 112
}

alias SOCKADDR_STORAGE_LH* PSOCKADDR_STORAGE_LH;
alias SOCKADDR_STORAGE_LH* LPSOCKADDR_STORAGE_LH;

struct SOCKADDR_STORAGE_XP {
    short ss_family;               // Address family.

    CHAR[_SS_PAD1SIZE] __ss_pad1;  // 6 byte pad, this is to make
                                   //   implementation specific pad up to
                                   //   alignment field that follows explicit
                                   //   in the data structure
    long __ss_align;            // Field to force desired structure
    CHAR[_SS_PAD2SIZE] __ss_pad2;  // 112 byte pad to achieve desired size;
                                   //   _SS_MAXSIZE value minus size of
                                   //   ss_family, __ss_pad1, and
                                   //   __ss_align fields is 112
}

alias SOCKADDR_STORAGE_XP* PSOCKADDR_STORAGE_XP;
alias SOCKADDR_STORAGE_XP* LPSOCKADDR_STORAGE_XP;


alias SOCKADDR_STORAGE_LH SOCKADDR_STORAGE;
alias SOCKADDR_STORAGE* PSOCKADDR_STORAGE;
alias SOCKADDR_STORAGE* LPSOCKADDR_STORAGE;

/*
 * WinSock 2 extension -- manifest constants for WSAIoctl()
 */
const auto IOC_UNIX                       = 0x00000000;
const auto IOC_WS2                        = 0x08000000;
const auto IOC_PROTOCOL                   = 0x10000000;
const auto IOC_VENDOR                     = 0x18000000;

/*
 * WSK-specific IO control codes are Winsock2 codes with the highest-order
 * 3 bits of the Vendor/AddressFamily-specific field set to 1.
 */
const auto IOC_WSK                        = (IOC_WS2|0x07000000);

const auto IOCPARM_MASK     = 0x7f            ; /* parameters must be < 128 bytes */
const auto IOC_VOID         = 0x20000000      ; /* no parameters */
const auto IOC_OUT          = 0x40000000      ; /* copy out parameters */
const auto IOC_IN           = 0x80000000      ; /* copy in parameters */
const auto IOC_INOUT        = (IOC_IN|IOC_OUT);
                                        /* 0x20000000 distinguishes new &
                                           old ioctl's */

template _WSAIO(uint x, uint y) {
	const auto _WSAIO = (IOC_VOID|(x)|(y));
}

template _WSAIOR(uint x, uint y) {
	const auto _WSAIOR = (IOC_OUT|(x)|(y));
}

template _WSAIOW(uint x, uint y) {
	const auto _WSAIOW = (IOC_IN|(x)|(y));
}

template _WSAIORW(uint x, uint y) {
	const auto _WSAIORW = (IOC_INOUT|(x)|(y));
}

const auto SIO_ASSOCIATE_HANDLE           = _WSAIOW!(IOC_WS2,1);
const auto SIO_ENABLE_CIRCULAR_QUEUEING   = _WSAIO!(IOC_WS2,2);
const auto SIO_FIND_ROUTE                 = _WSAIOR!(IOC_WS2,3);
const auto SIO_FLUSH                      = _WSAIO!(IOC_WS2,4);
const auto SIO_GET_BROADCAST_ADDRESS      = _WSAIOR!(IOC_WS2,5);
const auto SIO_GET_EXTENSION_FUNCTION_POINTER   = _WSAIORW!(IOC_WS2,6);
const auto SIO_GET_QOS                    = _WSAIORW!(IOC_WS2,7);
const auto SIO_GET_GROUP_QOS              = _WSAIORW!(IOC_WS2,8);
const auto SIO_MULTIPOINT_LOOPBACK        = _WSAIOW!(IOC_WS2,9);
const auto SIO_MULTICAST_SCOPE            = _WSAIOW!(IOC_WS2,10);
const auto SIO_SET_QOS                    = _WSAIOW!(IOC_WS2,11);
const auto SIO_SET_GROUP_QOS              = _WSAIOW!(IOC_WS2,12);
const auto SIO_TRANSLATE_HANDLE           = _WSAIORW!(IOC_WS2,13);
const auto SIO_ROUTING_INTERFACE_QUERY    = _WSAIORW!(IOC_WS2,20);
const auto SIO_ROUTING_INTERFACE_CHANGE   = _WSAIOW!(IOC_WS2,21);
const auto SIO_ADDRESS_LIST_QUERY         = _WSAIOR!(IOC_WS2,22);
const auto SIO_ADDRESS_LIST_CHANGE        = _WSAIO!(IOC_WS2,23);
const auto SIO_QUERY_TARGET_PNP_HANDLE    = _WSAIOR!(IOC_WS2,24);

const auto SIO_ADDRESS_LIST_SORT          = _WSAIORW!(IOC_WS2,25);

const auto SIO_RESERVED_1                 = _WSAIOW!(IOC_WS2,26);
const auto SIO_RESERVED_2                 = _WSAIOW!(IOC_WS2,33);

//
// Constants and structures defined by the internet system (RFC 790)
//

//
// N.B. required for backwards compatability to support 0 = IP for the
// level argument to get/setsockopt.
//
const auto IPPROTO_IP               = 0;

//
// Protocols.  The IPv6 defines are specified in RFC 2292.
//
enum IPPROTO {
    IPPROTO_HOPOPTS       = 0,  // IPv6 Hop-by-Hop options

    IPPROTO_ICMP          = 1,
    IPPROTO_IGMP          = 2,
    IPPROTO_GGP           = 3,

    IPPROTO_IPV4          = 4,

    IPPROTO_ST            = 5,

    IPPROTO_TCP           = 6,

    IPPROTO_CBT           = 7,
    IPPROTO_EGP           = 8,
    IPPROTO_IGP           = 9,

    IPPROTO_PUP           = 12,
    IPPROTO_UDP           = 17,
    IPPROTO_IDP           = 22,

    IPPROTO_RDP           = 27,

    IPPROTO_IPV6          = 41, // IPv6 header
    IPPROTO_ROUTING       = 43, // IPv6 Routing header
    IPPROTO_FRAGMENT      = 44, // IPv6 fragmentation header
    IPPROTO_ESP           = 50, // encapsulating security payload
    IPPROTO_AH            = 51, // authentication header
    IPPROTO_ICMPV6        = 58, // ICMPv6
    IPPROTO_NONE          = 59, // IPv6 no next header
    IPPROTO_DSTOPTS       = 60, // IPv6 Destination options

    IPPROTO_ND            = 77,
    IPPROTO_ICLFXBM       = 78,
    IPPROTO_PIM           = 103,
    IPPROTO_PGM           = 113,
    IPPROTO_L2TP          = 115,
    IPPROTO_SCTP          = 132,
    IPPROTO_RAW           = 255,

    IPPROTO_MAX           = 256,
//
//  These are reserved for internal use by Windows.
//
    IPPROTO_RESERVED_RAW  = 257,
    IPPROTO_RESERVED_IPSEC  = 258,
    IPPROTO_RESERVED_IPSECOFFLOAD  = 259,
    IPPROTO_RESERVED_MAX  = 260
}

alias IPPROTO* PIPROTO;

//
// Port/socket numbers: network standard functions
//
const auto IPPORT_TCPMUX            = 1;
const auto IPPORT_ECHO              = 7;
const auto IPPORT_DISCARD           = 9;
const auto IPPORT_SYSTAT            = 11;
const auto IPPORT_DAYTIME           = 13;
const auto IPPORT_NETSTAT           = 15;
const auto IPPORT_QOTD              = 17;
const auto IPPORT_MSP               = 18;
const auto IPPORT_CHARGEN           = 19;
const auto IPPORT_FTP_DATA          = 20;
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
const auto IPPORT_POP3              = 110;
const auto IPPORT_NTP               = 123;
const auto IPPORT_EPMAP             = 135;
const auto IPPORT_NETBIOS_NS        = 137;
const auto IPPORT_NETBIOS_DGM       = 138;
const auto IPPORT_NETBIOS_SSN       = 139;
const auto IPPORT_IMAP              = 143;
const auto IPPORT_SNMP              = 161;
const auto IPPORT_SNMP_TRAP         = 162;
const auto IPPORT_IMAP3             = 220;
const auto IPPORT_LDAP              = 389;
const auto IPPORT_HTTPS             = 443;
const auto IPPORT_MICROSOFT_DS      = 445;
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

const auto IPPORT_REGISTERED_MIN    = IPPORT_RESERVED;
const auto IPPORT_REGISTERED_MAX    = 0xbfff;
const auto IPPORT_DYNAMIC_MIN       = 0xc000;
const auto IPPORT_DYNAMIC_MAX       = 0xffff;

/*
 * Definitions of bits in internet address integers.
 * On subnets, the decomposition of addresses to host and net parts
 * is done according to subnet mask, not the masks here.
 *
 * N.B. RFC-compliant definitions for host-order elements are named IN_xxx,
 * while network-order elements are named IN4_xxx.
 */
//const auto IN_CLASSA(i)             = ((cast(LONG)(i) & 0x80000000) == 0);
const auto IN_CLASSA_NET            = 0xff000000;
const auto IN_CLASSA_NSHIFT         = 24;
const auto IN_CLASSA_HOST           = 0x00ffffff;
const auto IN_CLASSA_MAX            = 128;

//const auto IN_CLASSB(i)             = ((cast(LONG)(i) & 0xc0000000) == 0x80000000);
const auto IN_CLASSB_NET            = 0xffff0000;
const auto IN_CLASSB_NSHIFT         = 16;
const auto IN_CLASSB_HOST           = 0x0000ffff;
const auto IN_CLASSB_MAX            = 65536;

//const auto IN_CLASSC(i)             = ((cast(LONG)(i) & 0xe0000000) == 0xc0000000);
const auto IN_CLASSC_NET            = 0xffffff00;
const auto IN_CLASSC_NSHIFT         = 8;
const auto IN_CLASSC_HOST           = 0x000000ff;

//const auto IN_CLASSD(i)             = ((cast(CClong_t_t)(i) & 0xf0000000) == 0xe0000000);
const auto IN_CLASSD_NET            = 0xf0000000       ; /* These ones aren't really */
const auto IN_CLASSD_NSHIFT         = 28               ; /* net and host fields, but */
const auto IN_CLASSD_HOST           = 0x0fffffff       ; /* routing needn't know.    */
//const auto IN_MULTICAST(i)          = IN_CLASSD(i);

const auto INADDR_ANY               = cast(ULONG)0x00000000;
const auto INADDR_LOOPBACK          = 0x7f000001;
const auto INADDR_BROADCAST         = cast(ULONG)0xffffffff;
const auto INADDR_NONE              = 0xffffffff;


//
// Scope ID definition
//
enum SCOPE_LEVEL {
    ScopeLevelInterface    = 1,
    ScopeLevelLink         = 2,
    ScopeLevelSubnet       = 3,
    ScopeLevelAdmin        = 4,
    ScopeLevelSite         = 5,
    ScopeLevelOrganization = 8,
    ScopeLevelGlobal       = 14,
    ScopeLevelCount        = 16
}

struct SCOPE_ID {
    union _inner_union {
        //    ULONG Zone : 28;
        //    ULONG Level : 4;
        ULONG Zone() {
        	return Value & ((1 << 28) - 1);
        }

        ULONG Level() {
        	return Value >> 28;
        }

        ULONG Value;
    }
    _inner_union fields;
}

alias SCOPE_ID* PSCOPE_ID;

const auto SCOPEID_UNSPECIFIED_INIT     = SCOPE_ID.init;

//
// IPv4 Socket address, Internet style
//

struct SOCKADDR_IN {

    ADDRESS_FAMILY sin_family;

    USHORT sin_port;
    IN_ADDR sin_addr;
    CHAR[8] sin_zero;
}

alias SOCKADDR_IN sockaddr_in;
alias SOCKADDR_IN* PSOCKADDR_IN;

template _IO(uint x, uint y) {
	const auto _IO = (IOC_VOID|((x)<<8)|(y));
}

template _IOR(uint x, uint y, T) {
	const auto _IOR = (IOC_OUT|(((cast(Clong_t)t.sizeof) & IOCPARM_MASK)<<16)|((x)<<8)|(y));
}

template _IOW(uint x, uint y, T) {
	const auto _IOW = (IOC_IN|(((cast(Clong_t)t.sizeof) & IOCPARM_MASK)<<16)|((x)<<8)|(y));
}

/*
 * WinSock 2 extension -- WSABUF and QOS struct, include qos.h
 * to pull in FLOWSPEC and related definitions
 */

struct WSABUF {
    ULONG len;     /* the length of the buffer */
    CHAR *buf; /* the pointer to the buffer */
}

alias WSABUF*  LPWSABUF;

/*
 * WSAMSG -- for WSASendMsg
 */

struct WSAMSG {
    LPSOCKADDR       name;              /* Remote address */
    INT              namelen;           /* Remote address length */
    LPWSABUF         lpBuffers;         /* Data buffer array */
    ULONG            dwBufferCount;     /* Number of elements in the array */

    WSABUF           Control;           /* Control buffer */
    ULONG            dwFlags;           /* Flags */
}

alias WSAMSG* PWSAMSG;
alias WSAMSG*  LPWSAMSG;

/*
 * Layout of ancillary data objects in the control buffer (RFC 2292).
 */
alias WSACMSGHDR cmsghdr;

struct WSACMSGHDR {
    SIZE_T      cmsg_len;
    INT         cmsg_level;
    INT         cmsg_type;
    /* followed by UCHAR cmsg_data[] */
}

alias WSACMSGHDR* PWSACMSGHDR;
alias WSACMSGHDR* LPWSACMSGHDR;

alias WSACMSGHDR CMSGHDR;
alias WSACMSGHDR* PCMSGHDR;

/*
 * Alignment macros for header and data members of
 * the control buffer.
 */
/*const auto WSA_CMSGHDR_ALIGN(length)                            =
            ( ((length) + TYPE_ALIGNMENT(WSACMSGHDR)-1) &
                (~(TYPE_ALIGNMENT(WSACMSGHDR)-1)) );

const auto WSA_CMSGDATA_ALIGN(length)                           = \;
            ( ((length) + MAX_NATURAL_ALIGNMENT-1) &        \
                (~(MAX_NATURAL_ALIGNMENT-1)) )

const auto CMSGHDR_ALIGN  = WSA_CMSGHDR_ALIGN;
const auto CMSGDATA_ALIGN  = WSA_CMSGDATA_ALIGN;
*/

/*
 *  WSA_CMSG_FIRSTHDR
 *
 *  Returns a pointer to the first ancillary data object,
 *  or a null pointer if there is no ancillary data in the
 *  control buffer of the WSAMSG structure.
 *
 *  LPCMSGHDR
 *  WSA_CMSG_FIRSTHDR (
 *      LPWSAMSG    msg
 *      );
 */

/*const auto WSA_CMSG_FIRSTHDR(msg)  =
    ( ((msg)->Control.len >= sizeof(WSACMSGHDR))
        ? (LPWSACMSGHDR)(msg)->Control.buf
        : (LPWSACMSGHDR)NULL );

const auto CMSG_FIRSTHDR  = WSA_CMSG_FIRSTHDR;
*/
/*
 *  WSA_CMSG_NXTHDR
 *
 *  Returns a pointer to the next ancillary data object,
 *  or a null if there are no more data objects.
 *
 *  LPCMSGHDR
 *  WSA_CMSG_NEXTHDR (
 *      LPWSAMSG        msg,
 *      LPWSACMSGHDR    cmsg
 *      );
 */
/*const auto WSA_CMSG_NXTHDR(msg,  = cmsg)                          \;
    ( ((cmsg) == NULL)                                      \
        ? WSA_CMSG_FIRSTHDR(msg)                            \
        : ( ( ((PUCHAR)(cmsg) +                             \
                    WSA_CMSGHDR_ALIGN((cmsg)->cmsg_len) +   \
                    sizeof(WSACMSGHDR) ) >                  \
                (PUCHAR)((msg)->Control.buf) +              \
                    (msg)->Control.len )                    \
            ? (LPWSACMSGHDR)NULL                            \
            : (LPWSACMSGHDR)((PUCHAR)(cmsg) +               \
                WSA_CMSGHDR_ALIGN((cmsg)->cmsg_len)) ) )

const auto CMSG_NXTHDR  = WSA_CMSG_NXTHDR;
*/
/*
 *  WSA_CMSG_DATA
 *
 *  Returns a pointer to the first byte of data (what is referred
 *  to as the cmsg_data member though it is not defined in
 *  the structure).
 *
 *  Note that RFC 2292 defines this as CMSG_DATA, but that name
 *  is already used by wincrypt.h, and so Windows has used WSA_CMSG_DATA.
 *
 *  PUCHAR
 *  WSA_CMSG_DATA (
 *      LPWSACMSGHDR   pcmsg
 *      );
 */
/*const auto WSA_CMSG_DATA(cmsg)              = \;
            ( (PUCHAR)(cmsg) + WSA_CMSGDATA_ALIGN(sizeof(WSACMSGHDR)) )
*/
/*
 *  WSA_CMSG_SPACE
 *
 *  Returns total size of an ancillary data object given
 *  the amount of data. Used to allocate the correct amount
 *  of space.
 *
 *  SIZE_T
 *  WSA_CMSG_SPACE (
 *      SIZE_T length
 *      );
 */
/*const auto WSA_CMSG_SPACE(length)   = \;
        (WSA_CMSGDATA_ALIGN(sizeof(WSACMSGHDR) + WSA_CMSGHDR_ALIGN(length)))

const auto CMSG_SPACE  = WSA_CMSG_SPACE;
*/
/*
 *  WSA_CMSG_LEN
 *
 *  Returns the value to store in cmsg_len given the amount of data.
 *
 *  SIZE_T
 *  WSA_CMSG_LEN (
 *      SIZE_T length
 *  );
 */
/*const auto WSA_CMSG_LEN(length)     = \;
         (WSA_CMSGDATA_ALIGN(sizeof(WSACMSGHDR)) + length)

const auto CMSG_LEN  = WSA_CMSG_LEN;
*/
/*
 * Definition for flags member of the WSAMSG structure
 * This is in addition to other MSG_xxx flags defined
 * for recv/recvfrom/send/sendto.
 */
const auto MSG_TRUNC        = 0x0100;
const auto MSG_CTRUNC       = 0x0200;
const auto MSG_BCAST        = 0x0400;
const auto MSG_MCAST        = 0x0800;

