/*
 * winsock2.d
 *
 * This module binds WinSock2.h to D. The original copyright
 * notice is preserved below.
 *
 * Author: Dave Wilkinson
 * Originated: November 25th, 2009
 *
 */

module binding.win32.winsock2;

import binding.c;

import binding.win32.windef;
import binding.win32.winerror;
import binding.win32.guiddef;
import binding.win32.winbase;
import binding.win32.winnt;
import binding.win32.ws2def;
import binding.win32.qos;
import binding.win32.inaddr;

extern(System):

/*
 * Basic system type definitions, taken from the BSD file sys/types.h.
 */
alias ubyte    u_char;
alias ushort   u_short;
alias uint     u_int;
alias Culong_t u_long;

alias ulong u_int64;

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
 * INCLUDED IN WINSOCK2.H EXACTLY AS SHOWN HERE.
 */

const auto FD_SETSIZE       = 64;

struct fd_set {
        u_int fd_count;               /* how many are SET? */
        SOCKET  fd_array[FD_SETSIZE];   /* an array of SOCKETs */
}


extern(C) int __WSAFDIsSet(SOCKET fd, fd_set *);

/*
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
    u_int __i; \
    for (__i = 0; __i < ((fd_set *)(set))->fd_count; __i++) { \
        if (((fd_set *)(set))->fd_array[__i] == (fd)) { \
            break; \
        } \
    } \
    if (__i == ((fd_set *)(set))->fd_count) { \
        if (((fd_set *)(set))->fd_count < FD_SETSIZE) { \
            ((fd_set *)(set))->fd_array[__i] = (fd); \
            ((fd_set *)(set))->fd_count++; \
        } \
    } \
} while(0)

const auto FD_ZERO(set)  = (((fd_set *)(set))->fd_count=0);

const auto FD_ISSET(fd,  = set) __WSAFDIsSet((SOCKET)(fd), (fd_set *)(set));
*/

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

/*const auto timerisset(tvp)          = ((tvp)->tv_sec || (tvp)->tv_usec);
const auto timercmp(tvp,  = uvp, cmp) \;
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
	const auto _IOR = (IOC_OUT|(((cast(Clong_t)T.sizeof) & IOCPARM_MASK)<<16)|((x)<<8)|(y));
}

template _IOW(char x, uint y, T) {
	const auto _IOW = (IOC_IN|(((cast(Clong_t)T.sizeof) & IOCPARM_MASK)<<16)|((x)<<8)|(y));
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
        char    * * h_aliases;  /* alias list */
        short   h_addrtype;             /* host address type */
        short   h_length;               /* length of address */
        char    * * h_addr_list; /* list of addresses */
//const auto h_addr   = h_addr_list[0]          ; /* address, for backward compat */
}

/*
 * It is assumed here that a network number
 * fits in 32 bits.
 */
struct  netent {
        char    * n_name;           /* official name of net */
        char    * * n_aliases;  /* alias list */
        short   n_addrtype;             /* net address type */
        u_long  n_net;                  /* network # */
}

struct  servent {
        char    * s_name;           /* official service name */
        char    * * s_aliases;  /* alias list */
	version(X86_64) {
	        char    * s_proto;          /* protocol to use */
	        short   s_port;                 /* port # */
	}
	else {
	        short   s_port;                 /* port # */
	        char    * s_proto;          /* protocol to use */
	}
}

struct  protoent {
        char    * p_name;           /* official protocol name */
        char    * * p_aliases;  /* alias list */
        short   p_proto;                /* protocol # */
}

/*
 * Constants and structures defined by the internet system,
 * Per RFC 790, September 1981, taken from the BSD file netinet/in.h.
 * IPv6 additions per RFC 2292.
 */

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

const auto ADDR_ANY                 = INADDR_ANY;

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

alias WSADATA * LPWSADATA;

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
 * The  following  may  be used in place of the address family, socket type, or
 * protocol  in  a  call  to WSASocket to indicate that the corresponding value
 * should  be taken from the supplied WSAPROTOCOL_INFO structure instead of the
 * parameter itself.
 */
const auto FROM_PROTOCOL_INFO  = (-1);

/*
 * Types
 */
 
// defined ws2def.d

//const auto SOCK_STREAM      = 1               ; /* stream socket */
//const auto SOCK_DGRAM       = 2               ; /* datagram socket */
//const auto SOCK_RAW         = 3               ; /* raw-protocol interface */
//const auto SOCK_RDM         = 4               ; /* reliably-delivered message */
//const auto SOCK_SEQPACKET   = 5               ; /* sequenced packet stream */

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

const auto SO_DONTLINGER    = cast(int)(~SO_LINGER);
const auto SO_EXCLUSIVEADDRUSE  = (cast(int)(~SO_REUSEADDR)) ; /* disallow local address reuse */

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
 * WinSock 2 extension -- new options
 */
const auto SO_GROUP_ID        = 0x2001      ; /* ID of a socket group */
const auto SO_GROUP_PRIORITY  = 0x2002      ; /* the relative priority within a group*/
const auto SO_MAX_MSG_SIZE    = 0x2003      ; /* maximum message size */
const auto SO_PROTOCOL_INFOA  = 0x2004      ; /* WSAPROTOCOL_INFOA structure */
const auto SO_PROTOCOL_INFOW  = 0x2005      ; /* WSAPROTOCOL_INFOW structure */

version(UNICODE) {
	alias SO_PROTOCOL_INFOW SO_PROTOCOL_INFO;
}
else {
	alias SO_PROTOCOL_INFOA SO_PROTOCOL_INFO;
}

const auto PVD_CONFIG         = 0x3001       ; /* configuration info for service provider */
const auto SO_CONDITIONAL_ACCEPT  = 0x3002   ; /* enable true conditional accept: */
                                       /*  connection is not ack-ed to the */
                                       /*  other side until conditional */
                                       /*  function returns CF_ACCEPT */

/*
 * Structure used by kernel to pass protocol
 * information in raw sockets.
 */
struct sockproto {
        u_short sp_family;              /* address family */
        u_short sp_protocol;            /* protocol */
}

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
const auto PF_ATM           = AF_ATM;
const auto PF_INET6         = AF_INET6;

const auto PF_BTH           = AF_BTH;

const auto PF_MAX           = AF_MAX;

/*
 * Structure used for manipulating linger option.
 */
struct  linger {
        u_short l_onoff;                /* option on/off */
        u_short l_linger;               /* linger time */
}

/*
 * Level number for (get/set)sockopt() to apply to socket itself.
 */
const auto SOL_SOCKET       = 0xffff          ; /* options for socket level */

/*
 * Maximum queue length specifiable by listen.
 */
const auto SOMAXCONN        = 0x7fffffff;

const auto MSG_OOB          = 0x1             ; /* process out-of-band data */
const auto MSG_PEEK         = 0x2             ; /* peek at incoming message */
const auto MSG_DONTROUTE    = 0x4             ; /* send without using routing tables */

const auto MSG_WAITALL      = 0x8             ; /* do not complete until packet is completely filled */

const auto MSG_PARTIAL      = 0x8000          ; /* partial send or recv for message xport */

/*
 * WinSock 2 extension -- new flags for WSASend(), WSASendTo(), WSARecv() and
 *                          WSARecvFrom()
 */
const auto MSG_INTERRUPT    = 0x10            ; /* send/recv in the interrupt context */

const auto MSG_MAXIOVLEN    = 16;

/*
 * Define constant based on rfc883, used by gethostbyxxxx() calls.
 */
const auto MAXGETHOSTSTRUCT         = 1024;

/*
 * WinSock 2 extension -- bit values and indices for FD_XXX network events
 */
const auto FD_READ_BIT       = 0;
const auto FD_READ           = (1 << FD_READ_BIT);

const auto FD_WRITE_BIT      = 1;
const auto FD_WRITE          = (1 << FD_WRITE_BIT);

const auto FD_OOB_BIT        = 2;
const auto FD_OOB            = (1 << FD_OOB_BIT);

const auto FD_ACCEPT_BIT     = 3;
const auto FD_ACCEPT         = (1 << FD_ACCEPT_BIT);

const auto FD_CONNECT_BIT    = 4;
const auto FD_CONNECT        = (1 << FD_CONNECT_BIT);

const auto FD_CLOSE_BIT      = 5;
const auto FD_CLOSE          = (1 << FD_CLOSE_BIT);

const auto FD_QOS_BIT        = 6;
const auto FD_QOS            = (1 << FD_QOS_BIT);

const auto FD_GROUP_QOS_BIT  = 7;
const auto FD_GROUP_QOS      = (1 << FD_GROUP_QOS_BIT);

const auto FD_ROUTING_INTERFACE_CHANGE_BIT  = 8;
const auto FD_ROUTING_INTERFACE_CHANGE      = (1 << FD_ROUTING_INTERFACE_CHANGE_BIT);

const auto FD_ADDRESS_LIST_CHANGE_BIT  = 9;
const auto FD_ADDRESS_LIST_CHANGE      = (1 << FD_ADDRESS_LIST_CHANGE_BIT);

const auto FD_MAX_EVENTS     = 10;
const auto FD_ALL_EVENTS     = ((1 << FD_MAX_EVENTS) - 1);


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

/*
 * Extended Windows Sockets error constant definitions
 */
const auto WSASYSNOTREADY           = (WSABASEERR+91);
const auto WSAVERNOTSUPPORTED       = (WSABASEERR+92);
const auto WSANOTINITIALISED        = (WSABASEERR+93);
const auto WSAEDISCON               = (WSABASEERR+101);
const auto WSAENOMORE               = (WSABASEERR+102);
const auto WSAECANCELLED            = (WSABASEERR+103);
const auto WSAEINVALIDPROCTABLE     = (WSABASEERR+104);
const auto WSAEINVALIDPROVIDER      = (WSABASEERR+105);
const auto WSAEPROVIDERFAILEDINIT   = (WSABASEERR+106);
const auto WSASYSCALLFAILURE        = (WSABASEERR+107);
const auto WSASERVICE_NOT_FOUND     = (WSABASEERR+108);
const auto WSATYPE_NOT_FOUND        = (WSABASEERR+109);
const auto WSA_E_NO_MORE            = (WSABASEERR+110);
const auto WSA_E_CANCELLED          = (WSABASEERR+111);
const auto WSAEREFUSED              = (WSABASEERR+112);

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

/* Non-recoverable errors, FORMERR, REFUSED, NOTIMP */
const auto WSANO_RECOVERY           = (WSABASEERR+1003);

/* Valid name, no data record of requested type */
const auto WSANO_DATA               = (WSABASEERR+1004);

/*
 * Define QOS related error return codes
 *
 */
const auto   WSA_QOS_RECEIVERS               = (WSABASEERR + 1005);
         /* at least one Reserve has arrived */
const auto   WSA_QOS_SENDERS                 = (WSABASEERR + 1006);
         /* at least one Path has arrived */
const auto   WSA_QOS_NO_SENDERS              = (WSABASEERR + 1007);
         /* there are no senders */
const auto   WSA_QOS_NO_RECEIVERS            = (WSABASEERR + 1008);
         /* there are no receivers */
const auto   WSA_QOS_REQUEST_CONFIRMED       = (WSABASEERR + 1009);
         /* Reserve has been confirmed */
const auto   WSA_QOS_ADMISSION_FAILURE       = (WSABASEERR + 1010);
         /* error due to lack of resources */
const auto   WSA_QOS_POLICY_FAILURE          = (WSABASEERR + 1011);
         /* rejected for administrative reasons - bad credentials */
const auto   WSA_QOS_BAD_STYLE               = (WSABASEERR + 1012);
         /* unknown or conflicting style */
const auto   WSA_QOS_BAD_OBJECT              = (WSABASEERR + 1013);
         /* problem with some part of the filterspec or providerspecific
          * buffer in general */
const auto   WSA_QOS_TRAFFIC_CTRL_ERROR      = (WSABASEERR + 1014);
         /* problem with some part of the flowspec */
const auto   WSA_QOS_GENERIC_ERROR           = (WSABASEERR + 1015);
         /* general error */
const auto   WSA_QOS_ESERVICETYPE            = (WSABASEERR + 1016);
         /* invalid service type in flowspec */
const auto   WSA_QOS_EFLOWSPEC               = (WSABASEERR + 1017);
         /* invalid flowspec */
const auto   WSA_QOS_EPROVSPECBUF            = (WSABASEERR + 1018);
         /* invalid provider specific buffer */
const auto   WSA_QOS_EFILTERSTYLE            = (WSABASEERR + 1019);
         /* invalid filter style */
const auto   WSA_QOS_EFILTERTYPE             = (WSABASEERR + 1020);
         /* invalid filter type */
const auto   WSA_QOS_EFILTERCOUNT            = (WSABASEERR + 1021);
         /* incorrect number of filters */
const auto   WSA_QOS_EOBJLENGTH              = (WSABASEERR + 1022);
         /* invalid object length */
const auto   WSA_QOS_EFLOWCOUNT              = (WSABASEERR + 1023);
         /* incorrect number of flows */
const auto   WSA_QOS_EUNKOWNPSOBJ            = (WSABASEERR + 1024);
         /* unknown object in provider specific buffer */
const auto   WSA_QOS_EPOLICYOBJ              = (WSABASEERR + 1025);
         /* invalid policy object in provider specific buffer */
const auto   WSA_QOS_EFLOWDESC               = (WSABASEERR + 1026);
         /* invalid flow descriptor in the list */
const auto   WSA_QOS_EPSFLOWSPEC             = (WSABASEERR + 1027);
         /* inconsistent flow spec in provider specific buffer */
const auto   WSA_QOS_EPSFILTERSPEC           = (WSABASEERR + 1028);
         /* invalid filter spec in provider specific buffer */
const auto   WSA_QOS_ESDMODEOBJ              = (WSABASEERR + 1029);
         /* invalid shape discard mode object in provider specific buffer */
const auto   WSA_QOS_ESHAPERATEOBJ           = (WSABASEERR + 1030);
         /* invalid shaping rate object in provider specific buffer */
const auto   WSA_QOS_RESERVED_PETYPE         = (WSABASEERR + 1031);
         /* reserved policy element in provider specific buffer */



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
 * WinSock 2 extension -- new error codes and type definition
 */

alias HANDLE WSAEVENT;
alias LPHANDLE LPWSAEVENT;
alias OVERLAPPED WSAOVERLAPPED;
alias OVERLAPPED*    LPWSAOVERLAPPED;

const auto WSA_IO_PENDING           = (ERROR_IO_PENDING);
const auto WSA_IO_INCOMPLETE        = (ERROR_IO_INCOMPLETE);
const auto WSA_INVALID_HANDLE       = (ERROR_INVALID_HANDLE);
const auto WSA_INVALID_PARAMETER    = (ERROR_INVALID_PARAMETER);
const auto WSA_NOT_ENOUGH_MEMORY    = (ERROR_NOT_ENOUGH_MEMORY);
const auto WSA_OPERATION_ABORTED    = (ERROR_OPERATION_ABORTED);

const auto WSA_INVALID_EVENT        = (cast(WSAEVENT)null);
const auto WSA_MAXIMUM_WAIT_EVENTS  = (MAXIMUM_WAIT_OBJECTS);
const auto WSA_WAIT_FAILED          = (WAIT_FAILED);
const auto WSA_WAIT_EVENT_0         = (WAIT_OBJECT_0);
const auto WSA_WAIT_IO_COMPLETION   = (WAIT_IO_COMPLETION);
const auto WSA_WAIT_TIMEOUT         = (WAIT_TIMEOUT);
const auto WSA_INFINITE             = (INFINITE);

/*
 * Include qos.h to pull in FLOWSPEC and related definitions
 */

struct QOS {
    FLOWSPEC      SendingFlowspec;       /* the flow spec for data sending */
    FLOWSPEC      ReceivingFlowspec;     /* the flow spec for data receiving */
    WSABUF        ProviderSpecific;      /* additional provider specific stuff */
}

alias QOS * LPQOS;

/*
 * WinSock 2 extension -- manifest constants for return values of the condition function
 */
const auto CF_ACCEPT        = 0x0000;
const auto CF_REJECT        = 0x0001;
const auto CF_DEFER         = 0x0002;

/*
 * WinSock 2 extension -- manifest constants for shutdown()
 */
const auto SD_RECEIVE       = 0x00;
const auto SD_SEND          = 0x01;
const auto SD_BOTH          = 0x02;

/*
 * WinSock 2 extension -- data type and manifest constants for socket groups
 */
alias uint             GROUP;

const auto SG_UNCONSTRAINED_GROUP    = 0x01;
const auto SG_CONSTRAINED_GROUP      = 0x02;

/*
 * WinSock 2 extension -- data type for WSAEnumNetworkEvents()
 */
struct WSANETWORKEVENTS {
       long lNetworkEvents;
       int[FD_MAX_EVENTS] iErrorCode;
}

alias WSANETWORKEVENTS * LPWSANETWORKEVENTS;

/*
 * WinSock 2 extension -- WSAPROTOCOL_INFO structure and associated
 * manifest constants
 */

const auto MAX_PROTOCOL_CHAIN  = 7;

const auto BASE_PROTOCOL       = 1;
const auto LAYERED_PROTOCOL    = 0;

struct WSAPROTOCOLCHAIN {
    int ChainLen;                                 /* the length of the chain,     */
                                                  /* length = 0 means layered protocol, */
                                                  /* length = 1 means base protocol, */
                                                  /* length > 1 means protocol chain */
    DWORD[MAX_PROTOCOL_CHAIN] ChainEntries;       /* a list of dwCatalogEntryIds */
}

alias WSAPROTOCOLCHAIN * LPWSAPROTOCOLCHAIN;

const auto WSAPROTOCOL_LEN   = 255;

struct WSAPROTOCOL_INFOA {
    DWORD dwServiceFlags1;
    DWORD dwServiceFlags2;
    DWORD dwServiceFlags3;
    DWORD dwServiceFlags4;
    DWORD dwProviderFlags;
    GUID ProviderId;
    DWORD dwCatalogEntryId;
    WSAPROTOCOLCHAIN ProtocolChain;
    int iVersion;
    int iAddressFamily;
    int iMaxSockAddr;
    int iMinSockAddr;
    int iSocketType;
    int iProtocol;
    int iProtocolMaxOffset;
    int iNetworkByteOrder;
    int iSecurityScheme;
    DWORD dwMessageSize;
    DWORD dwProviderReserved;
    CHAR[WSAPROTOCOL_LEN+1]   szProtocol;
}

alias WSAPROTOCOL_INFOA * LPWSAPROTOCOL_INFOA;
struct WSAPROTOCOL_INFOW {
    DWORD dwServiceFlags1;
    DWORD dwServiceFlags2;
    DWORD dwServiceFlags3;
    DWORD dwServiceFlags4;
    DWORD dwProviderFlags;
    GUID ProviderId;
    DWORD dwCatalogEntryId;
    WSAPROTOCOLCHAIN ProtocolChain;
    int iVersion;
    int iAddressFamily;
    int iMaxSockAddr;
    int iMinSockAddr;
    int iSocketType;
    int iProtocol;
    int iProtocolMaxOffset;
    int iNetworkByteOrder;
    int iSecurityScheme;
    DWORD dwMessageSize;
    DWORD dwProviderReserved;
    WCHAR[WSAPROTOCOL_LEN+1]  szProtocol;
}

alias WSAPROTOCOL_INFOW * LPWSAPROTOCOL_INFOW;

version(UNICODE) {
	alias WSAPROTOCOL_INFOW WSAPROTOCOL_INFO;
	alias LPWSAPROTOCOL_INFOW LPWSAPROTOCOL_INFO;
}
else {
	alias WSAPROTOCOL_INFOA WSAPROTOCOL_INFO;
	alias LPWSAPROTOCOL_INFOA LPWSAPROTOCOL_INFO;
}

/* Flag bit definitions for dwProviderFlags */
const auto PFL_MULTIPLE_PROTO_ENTRIES           = 0x00000001;
const auto PFL_RECOMMENDED_PROTO_ENTRY          = 0x00000002;
const auto PFL_HIDDEN                           = 0x00000004;
const auto PFL_MATCHES_PROTOCOL_ZERO            = 0x00000008;

/* Flag bit definitions for dwServiceFlags1 */
const auto XP1_CONNECTIONLESS                   = 0x00000001;
const auto XP1_GUARANTEED_DELIVERY              = 0x00000002;
const auto XP1_GUARANTEED_ORDER                 = 0x00000004;
const auto XP1_MESSAGE_ORIENTED                 = 0x00000008;
const auto XP1_PSEUDO_STREAM                    = 0x00000010;
const auto XP1_GRACEFUL_CLOSE                   = 0x00000020;
const auto XP1_EXPEDITED_DATA                   = 0x00000040;
const auto XP1_CONNECT_DATA                     = 0x00000080;
const auto XP1_DISCONNECT_DATA                  = 0x00000100;
const auto XP1_SUPPORT_BROADCAST                = 0x00000200;
const auto XP1_SUPPORT_MULTIPOINT               = 0x00000400;
const auto XP1_MULTIPOINT_CONTROL_PLANE         = 0x00000800;
const auto XP1_MULTIPOINT_DATA_PLANE            = 0x00001000;
const auto XP1_QOS_SUPPORTED                    = 0x00002000;
const auto XP1_INTERRUPT                        = 0x00004000;
const auto XP1_UNI_SEND                         = 0x00008000;
const auto XP1_UNI_RECV                         = 0x00010000;
const auto XP1_IFS_HANDLES                      = 0x00020000;
const auto XP1_PARTIAL_MESSAGE                  = 0x00040000;
const auto XP1_SAN_SUPPORT_SDP                  = 0x00080000;

const auto BIGENDIAN                            = 0x0000;
const auto LITTLEENDIAN                         = 0x0001;

const auto SECURITY_PROTOCOL_NONE               = 0x0000;

/*
 * WinSock 2 extension -- manifest constants for WSAJoinLeaf()
 */
const auto JL_SENDER_ONLY     = 0x01;
const auto JL_RECEIVER_ONLY   = 0x02;
const auto JL_BOTH            = 0x04;

/*
 * WinSock 2 extension -- manifest constants for WSASocket()
 */
const auto WSA_FLAG_OVERLAPPED            = 0x01;
const auto WSA_FLAG_MULTIPOINT_C_ROOT     = 0x02;
const auto WSA_FLAG_MULTIPOINT_C_LEAF     = 0x04;
const auto WSA_FLAG_MULTIPOINT_D_ROOT     = 0x08;
const auto WSA_FLAG_MULTIPOINT_D_LEAF     = 0x10;
const auto WSA_FLAG_ACCESS_SYSTEM_SECURITY  = 0x40;

/*
 * WinSock 2 extensions -- data types for the condition function in
 * WSAAccept() and overlapped I/O completion routine.
 */

alias int function (
    LPWSABUF lpCallerId,
    LPWSABUF lpCallerData,
    LPQOS lpSQOS,
    LPQOS lpGQOS,
    LPWSABUF lpCalleeId,
    LPWSABUF lpCalleeData,
    GROUP * g,
    DWORD_PTR dwCallbackData
    ) LPCONDITIONPROC;

alias void function (
    DWORD dwError,
    DWORD cbTransferred,
    LPWSAOVERLAPPED lpOverlapped,
    DWORD dwFlags
    ) LPWSAOVERLAPPED_COMPLETION_ROUTINE;

/*
 * WinSock 2 extension -- manifest constants and associated structures
 * for WSANSPIoctl()
 */
const auto SIO_NSP_NOTIFY_CHANGE          = _WSAIOW!(IOC_WS2,25);

enum WSACOMPLETIONTYPE {
    NSP_NOTIFY_IMMEDIATELY = 0,
    NSP_NOTIFY_HWND,
    NSP_NOTIFY_EVENT,
    NSP_NOTIFY_PORT,
    NSP_NOTIFY_APC,
}

alias WSACOMPLETIONTYPE* PWSACOMPLETIONTYPE;
alias WSACOMPLETIONTYPE * LPWSACOMPLETIONTYPE;

struct WSACOMPLETION {
    WSACOMPLETIONTYPE Type;
    union _inner_union {
        struct _inner_struct {
            HWND hWnd;
            UINT uMsg;
            WPARAM context;
        }
		_inner_struct WindowMessage;
        struct _inner_struct2 {
            LPWSAOVERLAPPED lpOverlapped;
        }
		_inner_struct2 Event;
        struct _inner_struct3 {
            LPWSAOVERLAPPED lpOverlapped;
            LPWSAOVERLAPPED_COMPLETION_ROUTINE lpfnCompletionProc;
        }
		_inner_struct3 Apc;
        struct _inner_struct4 {
            LPWSAOVERLAPPED lpOverlapped;
            HANDLE hPort;
            ULONG_PTR Key;
        }
		_inner_struct4 Port;
    }
	_inner_union Parameters;
}

alias WSACOMPLETION* PWSACOMPLETION;
alias WSACOMPLETION *LPWSACOMPLETION;

/*
 * WinSock 2 extension -- manifest constants for SIO_TRANSLATE_HANDLE ioctl
 */
const auto TH_NETDEV         = 0x00000001;
const auto TH_TAPI           = 0x00000002;

/*
 * Manifest constants and type definitions related to name resolution and
 * registration (RNR) API
 */

struct BLOB {
    ULONG cbSize ;
    BYTE *pBlobData ;
}

alias BLOB* LPBLOB ;

/*
 * Service Install Flags
 */

const auto SERVICE_MULTIPLE        = (0x00000001);

/*
 *& Name Spaces
 */

const auto NS_ALL                       = (0);

const auto NS_SAP                       = (1);
const auto NS_NDS                       = (2);
const auto NS_PEER_BROWSE               = (3);
const auto NS_SLP                       = (5);
const auto NS_DHCP                      = (6);

const auto NS_TCPIP_LOCAL               = (10);
const auto NS_TCPIP_HOSTS               = (11);
const auto NS_DNS                       = (12);
const auto NS_NETBT                     = (13);
const auto NS_WINS                      = (14);

const auto NS_NLA                       = (15)    ; /* Network Location Awareness */

const auto NS_BTH                       = (16)    ; /* Bluetooth SDP Namespace */

const auto NS_NBP                       = (20);

const auto NS_MS                        = (30);
const auto NS_STDA                      = (31);
const auto NS_NTDS                      = (32);

const auto NS_EMAIL                     = (37);
const auto NS_PNRPNAME                  = (38);
const auto NS_PNRPCLOUD                 = (39);

const auto NS_X500                      = (40);
const auto NS_NIS                       = (41);
const auto NS_NISPLUS                   = (42);

const auto NS_WRQ                       = (50);

const auto NS_NETDES                    = (60)    ; /* Network Designers Limited */

/*
 * Resolution flags for WSAGetAddressByName().
 * Note these are also used by the 1.1 API GetAddressByName, so
 * leave them around.
 */
const auto RES_UNUSED_1                 = (0x00000001);
const auto RES_FLUSH_CACHE              = (0x00000002);
const auto RES_SERVICE                  = (0x00000004);

/*
 * Well known value names for Service Types
 */

const auto SERVICE_TYPE_VALUE_IPXPORTA       = "IpxSocket\0"c;
const auto SERVICE_TYPE_VALUE_IPXPORTW      = "IpxSocket\0"w;
const auto SERVICE_TYPE_VALUE_SAPIDA         = "SapId\0"c;
const auto SERVICE_TYPE_VALUE_SAPIDW        = "SapId\0"w;

const auto SERVICE_TYPE_VALUE_TCPPORTA       = "TcpPort\0"c;
const auto SERVICE_TYPE_VALUE_TCPPORTW      = "TcpPort\0"w;

const auto SERVICE_TYPE_VALUE_UDPPORTA       = "UdpPort\0"c;
const auto SERVICE_TYPE_VALUE_UDPPORTW      = "UdpPort\0"w;

const auto SERVICE_TYPE_VALUE_OBJECTIDA      = "ObjectId\0"c;
const auto SERVICE_TYPE_VALUE_OBJECTIDW     = "ObjectId\0"w;

version(UNICODE) {
	alias SERVICE_TYPE_VALUE_SAPIDW SERVICE_TYPE_VALUE_SAPID;
	alias SERVICE_TYPE_VALUE_TCPPORTW SERVICE_TYPE_VALUE_TCPPORT;
	alias SERVICE_TYPE_VALUE_UDPPORTW SERVICE_TYPE_VALUE_UDPPORT;
	alias SERVICE_TYPE_VALUE_OBJECTIDW SERVICE_TYPE_VALUE_OBJECTID;
}
else {
	alias SERVICE_TYPE_VALUE_SAPIDA SERVICE_TYPE_VALUE_SAPID;
	alias SERVICE_TYPE_VALUE_TCPPORTA SERVICE_TYPE_VALUE_TCPPORT;
	alias SERVICE_TYPE_VALUE_UDPPORTA SERVICE_TYPE_VALUE_UDPPORT;
	alias SERVICE_TYPE_VALUE_OBJECTIDA SERVICE_TYPE_VALUE_OBJECTID;
}

/*
 *  Address Family/Protocol Tuples
 */
struct AFPROTOCOLS {
    INT iAddressFamily;
    INT iProtocol;
}

alias AFPROTOCOLS* PAFPROTOCOLS;
alias AFPROTOCOLS* LPAFPROTOCOLS;

/*
 * Client Query API Typedefs
 */

/*
 * The comparators
 */
enum WSAECOMPARATOR {
    COMP_EQUAL = 0,
    COMP_NOTLESS
}

alias WSAECOMPARATOR* PWSAECOMPARATOR;
alias WSAECOMPARATOR* LPWSAECOMPARATOR;

struct WSAVERSION {
    DWORD           dwVersion;
    WSAECOMPARATOR  ecHow;
}

alias WSAVERSION* PWSAVERSION;
alias WSAVERSION* LPWSAVERSION;

struct WSAQUERYSETA {
    DWORD           dwSize;
    LPSTR           lpszServiceInstanceName;
    LPGUID          lpServiceClassId;
    LPWSAVERSION    lpVersion;
    LPSTR           lpszComment;
    DWORD           dwNameSpace;
    LPGUID          lpNSProviderId;
    LPSTR           lpszContext;
    DWORD           dwNumberOfProtocols;
    LPAFPROTOCOLS   lpafpProtocols;
    LPSTR           lpszQueryString;
    DWORD           dwNumberOfCsAddrs;
    LPCSADDR_INFO   lpcsaBuffer;
    DWORD           dwOutputFlags;
    LPBLOB          lpBlob;
}

alias WSAQUERYSETA* PWSAQUERYSETA;
alias WSAQUERYSETA* LPWSAQUERYSETA;
struct WSAQUERYSETW {
    DWORD           dwSize;
    LPWSTR          lpszServiceInstanceName;
    LPGUID          lpServiceClassId;
    LPWSAVERSION    lpVersion;
    LPWSTR          lpszComment;
    DWORD           dwNameSpace;
    LPGUID          lpNSProviderId;
    LPWSTR          lpszContext;
    DWORD           dwNumberOfProtocols;
	LPAFPROTOCOLS   lpafpProtocols;
    LPWSTR          lpszQueryString;
    DWORD           dwNumberOfCsAddrs;
	LPCSADDR_INFO   lpcsaBuffer;
    DWORD           dwOutputFlags;
    LPBLOB          lpBlob;
}

alias WSAQUERYSETW* PWSAQUERYSETW;
alias WSAQUERYSETW* LPWSAQUERYSETW;

struct WSAQUERYSET2A {
    DWORD           dwSize;
    LPSTR           lpszServiceInstanceName;
    LPWSAVERSION    lpVersion;
    LPSTR           lpszComment;
    DWORD           dwNameSpace;
    LPGUID          lpNSProviderId;
    LPSTR           lpszContext;
    DWORD           dwNumberOfProtocols;
    LPAFPROTOCOLS   lpafpProtocols;
    LPSTR           lpszQueryString;
    DWORD           dwNumberOfCsAddrs;
    LPCSADDR_INFO   lpcsaBuffer;
    DWORD           dwOutputFlags;
    LPBLOB          lpBlob;
}

alias WSAQUERYSET2A* PWSAQUERYSET2A;
alias WSAQUERYSET2A* LPWSAQUERYSET2A;
struct WSAQUERYSET2W {
    DWORD           dwSize;
    LPWSTR          lpszServiceInstanceName;
    LPWSAVERSION    lpVersion;
    LPWSTR          lpszComment;
    DWORD           dwNameSpace;
    LPGUID          lpNSProviderId;
    LPWSTR          lpszContext;
    DWORD           dwNumberOfProtocols;
	LPAFPROTOCOLS   lpafpProtocols;
    LPWSTR          lpszQueryString;
    DWORD           dwNumberOfCsAddrs;
	LPCSADDR_INFO   lpcsaBuffer;
    DWORD           dwOutputFlags;
    LPBLOB          lpBlob;
}

alias WSAQUERYSET2W* PWSAQUERYSET2W;
alias WSAQUERYSET2W* LPWSAQUERYSET2W;

version(UNICODE) {
	alias WSAQUERYSETW WSAQUERYSET;
	alias PWSAQUERYSETW PWSAQUERYSET;
	alias LPWSAQUERYSETW LPWSAQUERYSET;
	alias WSAQUERYSET2W WSAQUERYSET2;
	alias PWSAQUERYSET2W PWSAQUERYSET2;
	alias LPWSAQUERYSET2W LPWSAQUERYSET2;
}
else {
	alias WSAQUERYSETA WSAQUERYSET;
	alias PWSAQUERYSETA PWSAQUERYSET;
	alias LPWSAQUERYSETA LPWSAQUERYSET;
	alias WSAQUERYSET2A WSAQUERYSET2;
	alias PWSAQUERYSET2A PWSAQUERYSET2;
	alias LPWSAQUERYSET2A LPWSAQUERYSET2;
}

const auto LUP_DEEP                 = 0x0001;
const auto LUP_CONTAINERS           = 0x0002;
const auto LUP_NOCONTAINERS         = 0x0004;
const auto LUP_NEAREST              = 0x0008;
const auto LUP_RETURN_NAME          = 0x0010;
const auto LUP_RETURN_TYPE          = 0x0020;
const auto LUP_RETURN_VERSION       = 0x0040;
const auto LUP_RETURN_COMMENT       = 0x0080;
const auto LUP_RETURN_ADDR          = 0x0100;
const auto LUP_RETURN_BLOB          = 0x0200;
const auto LUP_RETURN_ALIASES       = 0x0400;
const auto LUP_RETURN_QUERY_STRING  = 0x0800;
const auto LUP_RETURN_ALL           = 0x0FF0;
const auto LUP_RES_SERVICE          = 0x8000;

const auto LUP_FLUSHCACHE           = 0x1000;
const auto LUP_FLUSHPREVIOUS        = 0x2000;

const auto LUP_NON_AUTHORITATIVE    = 0x4000;
const auto LUP_SECURE               = 0x8000;
const auto LUP_RETURN_PREFERRED_NAMES   = 0x10000;

const auto LUP_ADDRCONFIG           = 0x00100000;
const auto LUP_DUAL_ADDR            = 0x00200000;


/*
 * Return flags
 */

const auto   RESULT_IS_ALIAS      = 0x0001;

const auto   RESULT_IS_ADDED      = 0x0010;
const auto   RESULT_IS_CHANGED    = 0x0020;
const auto   RESULT_IS_DELETED    = 0x0040;

/*
 * Service Address Registration and Deregistration Data Types.
 */

enum WSAESETSERVICEOP {
    RNRSERVICE_REGISTER=0,
    RNRSERVICE_DEREGISTER,
    RNRSERVICE_DELETE
}

alias WSAESETSERVICEOP* PWSAESETSERVICEOP;
alias WSAESETSERVICEOP* LPWSAESETSERVICEOP;

/*
 * Service Installation/Removal Data Types.
 */

struct WSANSCLASSINFOA {
    LPSTR   lpszName;
    DWORD   dwNameSpace;
    DWORD   dwValueType;
    DWORD   dwValueSize;
    LPVOID  lpValue;
}

alias WSANSCLASSINFOA* PWSANSCLASSINFOA;
alias WSANSCLASSINFOA* LPWSANSCLASSINFOA;
struct WSANSCLASSINFOW {
    LPWSTR  lpszName;
    DWORD   dwNameSpace;
    DWORD   dwValueType;
    DWORD   dwValueSize;
    LPVOID  lpValue;
}

alias WSANSCLASSINFOW* PWSANSCLASSINFOW;
alias WSANSCLASSINFOW* LPWSANSCLASSINFOW;

version(UNICODE) {
	alias WSANSCLASSINFOW WSANSCLASSINFO;
	alias PWSANSCLASSINFOW PWSANSCLASSINFO;
	alias LPWSANSCLASSINFOW LPWSANSCLASSINFO;
}
else {
	alias WSANSCLASSINFOA WSANSCLASSINFO;
	alias PWSANSCLASSINFOA PWSANSCLASSINFO;
	alias LPWSANSCLASSINFOA LPWSANSCLASSINFO;
}

struct WSASERVICECLASSINFOA {
    LPGUID              lpServiceClassId;
    LPSTR               lpszServiceClassName;
    DWORD               dwCount;
    LPWSANSCLASSINFOA   lpClassInfos;
}

alias WSASERVICECLASSINFOA* PWSASERVICECLASSINFOA;
alias WSASERVICECLASSINFOA* LPWSASERVICECLASSINFOA;
struct WSASERVICECLASSINFOW {
    LPGUID              lpServiceClassId;
    LPWSTR              lpszServiceClassName;
    DWORD               dwCount;
    LPWSANSCLASSINFOW   lpClassInfos;
}

alias WSASERVICECLASSINFOW* PWSASERVICECLASSINFOW;
alias WSASERVICECLASSINFOW* LPWSASERVICECLASSINFOW;

version(UNICODE) {
	alias WSASERVICECLASSINFOW WSASERVICECLASSINFO;
	alias PWSASERVICECLASSINFOW PWSASERVICECLASSINFO;
	alias LPWSASERVICECLASSINFOW LPWSASERVICECLASSINFO;
}
else {
	alias WSASERVICECLASSINFOA WSASERVICECLASSINFO;
	alias PWSASERVICECLASSINFOA PWSASERVICECLASSINFO;
	alias LPWSASERVICECLASSINFOA LPWSASERVICECLASSINFO;
}

struct WSANAMESPACE_INFOA {
    GUID                NSProviderId;
    DWORD               dwNameSpace;
    BOOL                fActive;
    DWORD               dwVersion;
    LPSTR               lpszIdentifier;
}

alias WSANAMESPACE_INFOA* PWSANAMESPACE_INFOA;
alias WSANAMESPACE_INFOA* LPWSANAMESPACE_INFOA;

struct WSANAMESPACE_INFOW {
    GUID                NSProviderId;
    DWORD               dwNameSpace;
    BOOL                fActive;
    DWORD               dwVersion;
    LPWSTR              lpszIdentifier;
}

alias WSANAMESPACE_INFOW* PWSANAMESPACE_INFOW;
alias WSANAMESPACE_INFOW* LPWSANAMESPACE_INFOW;

struct WSANAMESPACE_INFOEXA {
    GUID                NSProviderId;
    DWORD               dwNameSpace;
    BOOL                fActive;
    DWORD               dwVersion;
    LPSTR               lpszIdentifier;
    BLOB                ProviderSpecific;
}

alias WSANAMESPACE_INFOEXA* PWSANAMESPACE_INFOEXA;
alias WSANAMESPACE_INFOEXA* LPWSANAMESPACE_INFOEXA;

struct WSANAMESPACE_INFOEXW {
    GUID                NSProviderId;
    DWORD               dwNameSpace;
    BOOL                fActive;
    DWORD               dwVersion;
    LPWSTR              lpszIdentifier;
    BLOB                ProviderSpecific;
}

alias WSANAMESPACE_INFOEXW* PWSANAMESPACE_INFOEXW;
alias WSANAMESPACE_INFOEXW* LPWSANAMESPACE_INFOEXW;


version(UNICODE) {
	alias WSANAMESPACE_INFOW WSANAMESPACE_INFO;
	alias PWSANAMESPACE_INFOW PWSANAMESPACE_INFO;
	alias LPWSANAMESPACE_INFOW LPWSANAMESPACE_INFO;
	alias WSANAMESPACE_INFOEXW WSANAMESPACE_INFOEX;
	alias PWSANAMESPACE_INFOEXW PWSANAMESPACE_INFOEX;
	alias LPWSANAMESPACE_INFOEXW LPWSANAMESPACE_INFOEX;
}
else {
	alias WSANAMESPACE_INFOA WSANAMESPACE_INFO;
	alias PWSANAMESPACE_INFOA PWSANAMESPACE_INFO;
	alias LPWSANAMESPACE_INFOA LPWSANAMESPACE_INFO;
	alias WSANAMESPACE_INFOEXA WSANAMESPACE_INFOEX;
	alias PWSANAMESPACE_INFOEXA PWSANAMESPACE_INFOEX;
	alias LPWSANAMESPACE_INFOEXA LPWSANAMESPACE_INFOEX;
}

/* Event flag definitions for WSAPoll(). */

const auto POLLRDNORM   = 0x0100;
const auto POLLRDBAND   = 0x0200;
const auto POLLIN       = (POLLRDNORM | POLLRDBAND);
const auto POLLPRI      = 0x0400;

const auto POLLWRNORM   = 0x0010;
const auto POLLOUT      = (POLLWRNORM);
const auto POLLWRBAND   = 0x0020;

const auto POLLERR      = 0x0001;
const auto POLLHUP      = 0x0002;
const auto POLLNVAL     = 0x0004;

struct WSAPOLLFD {
    SOCKET  fd;
    SHORT   events;
    SHORT   revents;
}

alias WSAPOLLFD* PWSAPOLLFD;
alias WSAPOLLFD *LPWSAPOLLFD;

/* Socket function prototypes */

SOCKET accept(
    SOCKET s,
	sockaddr * addr,
    int * addrlen
    );

alias SOCKET function(
    SOCKET s,
    sockaddr * addr,
    int * addrlen
    ) LPFN_ACCEPT;

int bind(
    SOCKET s,
    sockaddr * name,
    int namelen
    );

alias int function(
    SOCKET s,
    sockaddr * name,
    int namelen
    ) LPFN_BIND;

int closesocket(
    SOCKET s
    );

alias int function (
    SOCKET s
    ) LPFN_CLOSESOCKET;

int connect(
    SOCKET s,
    sockaddr * name,
    int namelen
    );

alias int function (
    SOCKET s,
    sockaddr * name,
    int namelen
    ) LPFN_CONNECT;

int ioctlsocket(
    SOCKET s,
    Clong_t cmd,
    u_long * argp
    );

alias int function (
    SOCKET s,
    Clong_t cmd,
    u_long * argp
    ) LPFN_IOCTLSOCKET;

int getpeername(
    SOCKET s,
	sockaddr * name,
    int * namelen
    );

alias int function (
    SOCKET s,
    sockaddr * name,
    int * namelen
    ) LPFN_GETPEERNAME;

int getsockname(
    SOCKET s,
    sockaddr * name,
    int * namelen
    );

alias int function (
    SOCKET s,
    sockaddr * name,
    int * namelen
    ) LPFN_GETSOCKNAME;

int getsockopt(
    SOCKET s,
    int level,
    int optname,
    char * optval,
    int * optlen
    );

alias int function (
    SOCKET s,
    int level,
    int optname,
    char * optval,
    int * optlen
    ) LPFN_GETSOCKOPT;

u_long htonl(
    u_long hostlong
    );

alias u_long function (
    u_long hostlong
    ) LPFN_HTONL;

u_short htons(
    u_short hostshort
    );

alias u_short function (
    u_short hostshort
    ) LPFN_HTONS;

Culong_t inet_addr(
    char * cp
    );

alias Culong_t function (
    char * cp
    ) LPFN_INET_ADDR;

char * inet_ntoa(
    in_addr _in
    );

alias char * function (
    in_addr _in
    ) LPFN_INET_NTOA;

int listen(
    SOCKET s,
    int backlog
    );

alias int function (
    SOCKET s,
    int backlog
    ) LPFN_LISTEN;

u_long ntohl(
    u_long netlong
    );

alias u_long function (
    u_long netlong
    ) LPFN_NTOHL;

u_short ntohs(
    u_short netshort
    );

alias u_short function (
    u_short netshort
    ) LPFN_NTOHS;

int recv(
    SOCKET s,
	ubyte * buf,
    int len,
    int flags
    );

alias int function (
    SOCKET s,
	ubyte * buf,
    int len,
    int flags
    ) LPFN_RECV;

int recvfrom(
    SOCKET s,
	ubyte * buf,
    int len,
    int flags,
	sockaddr * from,
    int * fromlen
    );

alias int function (
    SOCKET s,
	ubyte * buf,
    int len,
    int flags,
	sockaddr * from,
    int * fromlen
    ) LPFN_RECVFROM;

int select(
    int nfds,
    fd_set * readfds,
    fd_set * writefds,
    fd_set * exceptfds,
    timeval * timeout
    );

alias int function (
    int nfds,
    fd_set * readfds,
    fd_set * writefds,
    fd_set *exceptfds,
    	timeval * timeout
    ) LPFN_SELECT;

int send(
    SOCKET s,
    ubyte * buf,
    int len,
    int flags
    );

alias int function (
    SOCKET s,
    ubyte * buf,
    int len,
    int flags
    ) LPFN_SEND;

int sendto(
    SOCKET s,
	ubyte * buf,
    int len,
    int flags,
    sockaddr * to,
    int tolen
    );

alias int function (
    SOCKET s,
    ubyte * buf,
    int len,
    int flags,
    sockaddr * to,
    int tolen
    ) LPFN_SENDTO;

int setsockopt(
    SOCKET s,
    int level,
    int optname,
	char * optval,
    int optlen
    );

alias int function (
    SOCKET s,
    int level,
    int optname,
    char * optval,
    int optlen
    ) LPFN_SETSOCKOPT;

int shutdown(
    SOCKET s,
    int how
    );

alias int function (
    SOCKET s,
    int how
    ) LPFN_SHUTDOWN;

SOCKET socket(
    int af,
    int type,
    int protocol
    );

alias SOCKET function (
    int af,
    int type,
    int protocol
    ) LPFN_SOCKET;

/* Database function prototypes */

hostent * gethostbyaddr(
    char * addr,
    int len,
    int type
    );

alias hostent* function (
    char * addr,
    int len,
    int type
    ) LPFN_GETHOSTBYADDR;

hostent * gethostbyname(
    char * name
    );

alias hostent* function (
    char * name
    ) LPFN_GETHOSTBYNAME;

int gethostname(
    char * name,
    int namelen
    );

alias int function (
    char * name,
    int namelen
    ) LPFN_GETHOSTNAME;

servent * getservbyport(
    int port,
    char * proto
    );

alias servent* function (
    int port,
    char * proto
    ) LPFN_GETSERVBYPORT;

servent * getservbyname(
    char * name,
    char * proto
    );

alias servent* function (
    char * name,
    char * proto
    ) LPFN_GETSERVBYNAME;

protoent * getprotobynumber(
    int number
    );

alias protoent* function (
    int number
    ) LPFN_GETPROTOBYNUMBER;

protoent * getprotobyname(
    char * name
    );

alias protoent* function (
    char * name
    ) LPFN_GETPROTOBYNAME;

/* Microsoft Windows Extension function prototypes */

int WSAStartup(
    WORD wVersionRequested,
    LPWSADATA lpWSAData
    );

alias int function (
    WORD wVersionRequested,
    LPWSADATA lpWSAData
    ) LPFN_WSASTARTUP;

int WSACleanup();

alias int function() LPFN_WSACLEANUP;

void WSASetLastError(
    int iError
    );

alias void function(
    int iError
    ) LPFN_WSASETLASTERROR;

int WSAGetLastError();

alias int function() LPFN_WSAGETLASTERROR;

BOOL WSAIsBlocking();

alias BOOL function() LPFN_WSAISBLOCKING;

int WSAUnhookBlockingHook();

alias int function() LPFN_WSAUNHOOKBLOCKINGHOOK;

FARPROC WSASetBlockingHook(
    FARPROC lpBlockFunc
    );

alias FARPROC function (
    FARPROC lpBlockFunc
    ) LPFN_WSASETBLOCKINGHOOK;

int WSACancelBlockingCall();

alias int function() LPFN_WSACANCELBLOCKINGCALL;

HANDLE WSAAsyncGetServByName(
    HWND hWnd,
    u_int wMsg,
    char * name,
    char * proto,
	char * buf,
    int buflen
    );

alias HANDLE function (
    HWND hWnd,
    u_int wMsg,
    char * name,
    char * proto,
	char * buf,
    int buflen
    ) LPFN_WSAASYNCGETSERVBYNAME;

HANDLE WSAAsyncGetServByPort(
    HWND hWnd,
    u_int wMsg,
    int port,
    char * proto,
	char * buf,
    int buflen
    );

alias HANDLE function (
    HWND hWnd,
    u_int wMsg,
    int port,
    char * proto,
    char * buf,
    int buflen
    ) LPFN_WSAASYNCGETSERVBYPORT;

HANDLE WSAAsyncGetProtoByName(
    HWND hWnd,
    u_int wMsg,
    char * name,
	char * buf,
    int buflen
    );

alias HANDLE function (
    HWND hWnd,
    u_int wMsg,
    char * name,
	char * buf,
    int buflen
    ) LPFN_WSAASYNCGETPROTOBYNAME;

HANDLE WSAAsyncGetProtoByNumber(
    HWND hWnd,
    u_int wMsg,
    int number,
	char * buf,
    int buflen
    );

alias HANDLE function (
    HWND hWnd,
    u_int wMsg,
    int number,
	char * buf,
    int buflen
    ) LPFN_WSAASYNCGETPROTOBYNUMBER;

HANDLE WSAAsyncGetHostByName(
    HWND hWnd,
    u_int wMsg,
    char * name,
	char * buf,
    int buflen
    );

alias HANDLE function (
    HWND hWnd,
    u_int wMsg,
    char * name,
    char * buf,
    int buflen
    ) LPFN_WSAASYNCGETHOSTBYNAME;

HANDLE WSAAsyncGetHostByAddr(
    HWND hWnd,
    u_int wMsg,
    char * addr,
    int len,
    int type,
    char * buf,
    int buflen
    );

alias HANDLE function (
    HWND hWnd,
    u_int wMsg,
    char * addr,
    int len,
    int type,
    char * buf,
    int buflen
    ) LPFN_WSAASYNCGETHOSTBYADDR;

int WSACancelAsyncRequest(
    HANDLE hAsyncTaskHandle
    );

alias int function (
    HANDLE hAsyncTaskHandle
    ) LPFN_WSACANCELASYNCREQUEST;

int WSAAsyncSelect(
    SOCKET s,
    HWND hWnd,
    u_int wMsg,
    Clong_t lEvent
    );

alias int function (
    SOCKET s,
    HWND hWnd,
    u_int wMsg,
    Clong_t lEvent
    ) LPFN_WSAASYNCSELECT;


/* WinSock 2 API new function prototypes */

SOCKET WSAAccept(
    SOCKET s,
    sockaddr* addr,
    LPINT addrlen,
    LPCONDITIONPROC lpfnCondition,
    DWORD_PTR dwCallbackData
    );

alias SOCKET function (
    SOCKET s,
    sockaddr * addr,
    LPINT addrlen,
    LPCONDITIONPROC lpfnCondition,
    DWORD_PTR dwCallbackData
    ) LPFN_WSAACCEPT;

BOOL WSACloseEvent(
    WSAEVENT hEvent
    );

alias BOOL function (
    WSAEVENT hEvent
    ) LPFN_WSACLOSEEVENT;

int WSAConnect(
    SOCKET s,
    sockaddr * name,
    int namelen,
    LPWSABUF lpCallerData,
    LPWSABUF lpCalleeData,
    LPQOS lpSQOS,
    LPQOS lpGQOS
    );

version(UNICODE) {
	alias WSAConnectByNameW WSAConnectByName;
}
else {
	alias WSAConnectByNameA WSAConnectByName;
}

BOOL WSAConnectByNameW(
    SOCKET s,
    LPWSTR nodename,
    LPWSTR servicename,
    LPDWORD LocalAddressLength,
	LPSOCKADDR LocalAddress,
    LPDWORD RemoteAddressLength,
	LPSOCKADDR RemoteAddress,
    timeval * timeout,
    LPWSAOVERLAPPED Reserved);

BOOL WSAConnectByNameA(
    SOCKET s,
    LPCSTR nodename,
    LPCSTR servicename,
    LPDWORD LocalAddressLength,
	LPSOCKADDR LocalAddress,
    LPDWORD RemoteAddressLength,
	LPSOCKADDR RemoteAddress,
    timeval * timeout,
    LPWSAOVERLAPPED Reserved);

BOOL WSAConnectByList(
    SOCKET s,
    PSOCKET_ADDRESS_LIST SocketAddress,
    LPDWORD LocalAddressLength,
	LPSOCKADDR LocalAddress,
    LPDWORD RemoteAddressLength,
	LPSOCKADDR RemoteAddress,
    timeval * timeout,
    LPWSAOVERLAPPED Reserved);

alias int function (
    SOCKET s,
    sockaddr * name,
    int namelen,
    LPWSABUF lpCallerData,
    LPWSABUF lpCalleeData,
    LPQOS lpSQOS,
    LPQOS lpGQOS
    ) LPFN_WSACONNECT;

WSAEVENT WSACreateEvent();

alias WSAEVENT function() LPFN_WSACREATEEVENT;

int WSADuplicateSocketA(
    SOCKET s,
    DWORD dwProcessId,
    LPWSAPROTOCOL_INFOA lpProtocolInfo
    );

int WSADuplicateSocketW(
    SOCKET s,
    DWORD dwProcessId,
    LPWSAPROTOCOL_INFOW lpProtocolInfo
    );

version(UNICODE) {
	alias WSADuplicateSocketW WSADuplicateSocket;
}
else {
	alias WSADuplicateSocketA WSADuplicateSocket;
}

alias int function (
    SOCKET s,
    DWORD dwProcessId,
    LPWSAPROTOCOL_INFOA lpProtocolInfo
    ) LPFN_WSADUPLICATESOCKETA;
    
alias int function (
    SOCKET s,
    DWORD dwProcessId,
    LPWSAPROTOCOL_INFOW lpProtocolInfo
    ) LPFN_WSADUPLICATESOCKETW;

version(UNICODE) {
	alias LPFN_WSADUPLICATESOCKETW LPFN_WSADUPLICATESOCKET;
}
else {
	alias LPFN_WSADUPLICATESOCKETA LPFN_WSADUPLICATESOCKET;
}

int WSAEnumNetworkEvents(
    SOCKET s,
    WSAEVENT hEventObject,
    LPWSANETWORKEVENTS lpNetworkEvents
    );

alias int function (
    SOCKET s,
    WSAEVENT hEventObject,
    LPWSANETWORKEVENTS lpNetworkEvents
    ) LPFN_WSAENUMNETWORKEVENTS;

int WSAEnumProtocolsA(
    LPINT lpiProtocols,
	LPWSAPROTOCOL_INFOA lpProtocolBuffer,
    LPDWORD lpdwBufferLength
    );

int WSAEnumProtocolsW(
    LPINT lpiProtocols,
	LPWSAPROTOCOL_INFOW lpProtocolBuffer,
    LPDWORD lpdwBufferLength
    );

version(UNICODE) {
	alias WSAEnumProtocolsW WSAEnumProtocols;
}
else {
	alias WSAEnumProtocolsA WSAEnumProtocols;
}

alias int function (
    LPINT lpiProtocols,
    LPWSAPROTOCOL_INFOA lpProtocolBuffer,
    LPDWORD lpdwBufferLength
    ) LPFN_WSAENUMPROTOCOLSA;

alias int function (
    LPINT lpiProtocols,
    LPWSAPROTOCOL_INFOW lpProtocolBuffer,
    LPDWORD lpdwBufferLength
    ) LPFN_WSAENUMPROTOCOLSW;

version(UNICODE) {
	alias LPFN_WSAENUMPROTOCOLSW LPFN_WSAENUMPROTOCOLS;
}
else {
	alias LPFN_WSAENUMPROTOCOLSA LPFN_WSAENUMPROTOCOLS;
}

int WSAEventSelect(
    SOCKET s,
    WSAEVENT hEventObject,
    Clong_t lNetworkEvents
    );

alias int function (
    SOCKET s,
    WSAEVENT hEventObject,
    Clong_t lNetworkEvents
    ) LPFN_WSAEVENTSELECT;

BOOL WSAGetOverlappedResult(
    SOCKET s,
    LPWSAOVERLAPPED lpOverlapped,
    LPDWORD lpcbTransfer,
    BOOL fWait,
    LPDWORD lpdwFlags
    );

alias BOOL function (
    SOCKET s,
    LPWSAOVERLAPPED lpOverlapped,
    LPDWORD lpcbTransfer,
    BOOL fWait,
    LPDWORD lpdwFlags
    ) LPFN_WSAGETOVERLAPPEDRESULT;

BOOL WSAGetQOSByName(
    SOCKET s,
    LPWSABUF lpQOSName,
    LPQOS lpQOS
    );

alias BOOL function (
    SOCKET s,
    LPWSABUF lpQOSName,
    LPQOS lpQOS
    ) LPFN_WSAGETQOSBYNAME;

int WSAHtonl(
    SOCKET s,
    u_long hostlong,
    u_long * lpnetlong
    );

alias int function (
    SOCKET s,
    u_long hostlong,
    u_long * lpnetlong
    ) LPFN_WSAHTONL;

int WSAHtons(
    SOCKET s,
    u_short hostshort,
    u_short * lpnetshort
    );

alias int function (
    SOCKET s,
    u_short hostshort,
    u_short * lpnetshort
    ) LPFN_WSAHTONS;

int WSAIoctl(
    SOCKET s,
    DWORD dwIoControlCode,
	LPVOID lpvInBuffer,
    DWORD cbInBuffer,
	LPVOID lpvOutBuffer,
    DWORD cbOutBuffer,
	LPDWORD lpcbBytesReturned,
    LPWSAOVERLAPPED lpOverlapped,
    LPWSAOVERLAPPED_COMPLETION_ROUTINE lpCompletionRoutine
    );

alias int function (
    SOCKET s,
    DWORD dwIoControlCode,
	LPVOID lpvInBuffer,
    DWORD cbInBuffer,
	LPVOID lpvOutBuffer,
    DWORD cbOutBuffer,
    LPDWORD lpcbBytesReturned,
    LPWSAOVERLAPPED lpOverlapped,
    LPWSAOVERLAPPED_COMPLETION_ROUTINE lpCompletionRoutine
    ) LPFN_WSAIOCTL;

SOCKET WSAJoinLeaf(
    SOCKET s,
    sockaddr * name,
    int namelen,
    LPWSABUF lpCallerData,
    LPWSABUF lpCalleeData,
    LPQOS lpSQOS,
    LPQOS lpGQOS,
    DWORD dwFlags
    );

alias SOCKET function (
    SOCKET s,
    sockaddr * name,
    int namelen,
    LPWSABUF lpCallerData,
    LPWSABUF lpCalleeData,
    LPQOS lpSQOS,
    LPQOS lpGQOS,
    DWORD dwFlags
    ) LPFN_WSAJOINLEAF;

int WSANtohl(
    SOCKET s,
    u_long netlong,
    u_long * lphostlong
    );

alias int function (
    SOCKET s,
    u_long netlong,
    u_long * lphostlong
    ) LPFN_WSANTOHL;

int WSANtohs(
    SOCKET s,
    u_short netshort,
    u_short * lphostshort
    );

alias int function (
    SOCKET s,
    u_short netshort,
    u_short * lphostshort
    ) LPFN_WSANTOHS;

int WSARecv(
    SOCKET s,
	LPWSABUF lpBuffers,
    DWORD dwBufferCount,
    LPDWORD lpNumberOfBytesRecvd,
    LPDWORD lpFlags,
    LPWSAOVERLAPPED lpOverlapped,
    LPWSAOVERLAPPED_COMPLETION_ROUTINE lpCompletionRoutine
    );

alias int function (
    SOCKET s,
	LPWSABUF lpBuffers,
    DWORD dwBufferCount,
    LPDWORD lpNumberOfBytesRecvd,
    LPDWORD lpFlags,
    LPWSAOVERLAPPED lpOverlapped,
    LPWSAOVERLAPPED_COMPLETION_ROUTINE lpCompletionRoutine
    ) LPFN_WSARECV;

int WSARecvDisconnect(
    SOCKET s,
	LPWSABUF lpInboundDisconnectData
    );

alias int function (
    SOCKET s,
    LPWSABUF lpInboundDisconnectData
    ) LPFN_WSARECVDISCONNECT;



int WSARecvFrom(
    SOCKET s,
	LPWSABUF lpBuffers,
    DWORD dwBufferCount,
    LPDWORD lpNumberOfBytesRecvd,
    LPDWORD lpFlags,
	sockaddr * lpFrom,
    LPINT lpFromlen,
    LPWSAOVERLAPPED lpOverlapped,
    LPWSAOVERLAPPED_COMPLETION_ROUTINE lpCompletionRoutine
    );



alias int function (
    SOCKET s,
	LPWSABUF lpBuffers,
    DWORD dwBufferCount,
    LPDWORD lpNumberOfBytesRecvd,
    LPDWORD lpFlags,
	sockaddr * lpFrom,
    LPINT lpFromlen,
    LPWSAOVERLAPPED lpOverlapped,
    LPWSAOVERLAPPED_COMPLETION_ROUTINE lpCompletionRoutine
    ) LPFN_WSARECVFROM;

BOOL WSAResetEvent(
    WSAEVENT hEvent
    );

alias BOOL function (
    WSAEVENT hEvent
    ) LPFN_WSARESETEVENT;

int WSASend(
    SOCKET s,
	LPWSABUF lpBuffers,
    DWORD dwBufferCount,
    LPDWORD lpNumberOfBytesSent,
    DWORD dwFlags,
    LPWSAOVERLAPPED lpOverlapped,
    LPWSAOVERLAPPED_COMPLETION_ROUTINE lpCompletionRoutine
    );

alias int function (
    SOCKET s,
    LPWSABUF lpBuffers,
    DWORD dwBufferCount,
    LPDWORD lpNumberOfBytesSent,
    DWORD dwFlags,
    LPWSAOVERLAPPED lpOverlapped,
    LPWSAOVERLAPPED_COMPLETION_ROUTINE lpCompletionRoutine
    ) LPFN_WSASEND;

int WSASendMsg(
    SOCKET Handle,
    LPWSAMSG lpMsg,
    DWORD dwFlags,
    LPDWORD lpNumberOfBytesSent,
    LPWSAOVERLAPPED lpOverlapped,
    LPWSAOVERLAPPED_COMPLETION_ROUTINE lpCompletionRoutine
    );

int WSASendDisconnect(
    SOCKET s,
    LPWSABUF lpOutboundDisconnectData
    );

alias int function (
    SOCKET s,
    LPWSABUF lpOutboundDisconnectData
    ) LPFN_WSASENDDISCONNECT;

int WSASendTo(
    SOCKET s,
    LPWSABUF lpBuffers,
    DWORD dwBufferCount,
    LPDWORD lpNumberOfBytesSent,
    DWORD dwFlags,
	sockaddr * lpTo,
    int iTolen,
    LPWSAOVERLAPPED lpOverlapped,
    LPWSAOVERLAPPED_COMPLETION_ROUTINE lpCompletionRoutine
    );

alias int function (
    SOCKET s,
    LPWSABUF lpBuffers,
    DWORD dwBufferCount,
    LPDWORD lpNumberOfBytesSent,
    DWORD dwFlags,
	sockaddr * lpTo,
    int iTolen,
    LPWSAOVERLAPPED lpOverlapped,
    LPWSAOVERLAPPED_COMPLETION_ROUTINE lpCompletionRoutine
    ) LPFN_WSASENDTO;

BOOL WSASetEvent(
    WSAEVENT hEvent
    );

alias BOOL function (
    WSAEVENT hEvent
    ) LPFN_WSASETEVENT;

SOCKET WSASocketA(
    int af,
    int type,
    int protocol,
    LPWSAPROTOCOL_INFOA lpProtocolInfo,
    GROUP g,
    DWORD dwFlags
    );

SOCKET WSASocketW(
    int af,
    int type,
    int protocol,
    LPWSAPROTOCOL_INFOW lpProtocolInfo,
    GROUP g,
    DWORD dwFlags
    );

version(UNICODE) {
	alias WSASocketW WSASocket;
}
else {
	alias WSASocketA WSASocket;
}

alias SOCKET function (
    int af,
    int type,
    int protocol,
    LPWSAPROTOCOL_INFOA lpProtocolInfo,
    GROUP g,
    DWORD dwFlags
    ) LPFN_WSASOCKETA;

alias SOCKET function (
    int af,
    int type,
    int protocol,
    LPWSAPROTOCOL_INFOW lpProtocolInfo,
    GROUP g,
    DWORD dwFlags
    ) LPFN_WSASOCKETW;

version(UNICODE) {
	alias LPFN_WSASOCKETW LPFN_WSASOCKET;
}
else {
	alias LPFN_WSASOCKETA LPFN_WSASOCKET;
}

DWORD WSAWaitForMultipleEvents(
    DWORD cEvents,
    WSAEVENT * lphEvents,
    BOOL fWaitAll,
    DWORD dwTimeout,
    BOOL fAlertable
    );

alias DWORD function (
    DWORD cEvents,
    WSAEVENT * lphEvents,
    BOOL fWaitAll,
    DWORD dwTimeout,
    BOOL fAlertable
    ) LPFN_WSAWAITFORMULTIPLEEVENTS;

INT WSAAddressToStringA(
    LPSOCKADDR lpsaAddress,
    DWORD               dwAddressLength,
    LPWSAPROTOCOL_INFOA lpProtocolInfo,
	LPSTR lpszAddressString,
    LPDWORD            lpdwAddressStringLength
    );

INT WSAAddressToStringW(
    LPSOCKADDR lpsaAddress,
    DWORD               dwAddressLength,
    LPWSAPROTOCOL_INFOW lpProtocolInfo,
	LPWSTR lpszAddressString,
    LPDWORD            lpdwAddressStringLength
    );

version(UNICODE) {
	alias WSAAddressToStringW WSAAddressToString;
}
else {
	alias WSAAddressToStringA WSAAddressToString;
}

alias INT function (
    LPSOCKADDR lpsaAddress,
    DWORD               dwAddressLength,
    LPWSAPROTOCOL_INFOA lpProtocolInfo,
	LPSTR lpszAddressString,
    LPDWORD            lpdwAddressStringLength
    ) LPFN_WSAADDRESSTOSTRINGA;

alias INT function (
    LPSOCKADDR lpsaAddress,
    DWORD               dwAddressLength,
    LPWSAPROTOCOL_INFOW lpProtocolInfo,
    LPWSTR lpszAddressString,
    LPDWORD            lpdwAddressStringLength
    ) LPFN_WSAADDRESSTOSTRINGW;

version(UNICODE) {
	alias LPFN_WSAADDRESSTOSTRINGW LPFN_WSAADDRESSTOSTRING;
}
else {
	alias LPFN_WSAADDRESSTOSTRINGA LPFN_WSAADDRESSTOSTRING;
}

INT WSAStringToAddressA(
    LPSTR               AddressString,
    INT                 AddressFamily,
    LPWSAPROTOCOL_INFOA lpProtocolInfo,
	LPSOCKADDR lpAddress,
    LPINT              lpAddressLength
    );

INT WSAStringToAddressW(
    LPWSTR              AddressString,
    INT                 AddressFamily,
    LPWSAPROTOCOL_INFOW lpProtocolInfo,
	LPSOCKADDR lpAddress,
    LPINT              lpAddressLength
    );

version(UNICODE) {
	alias WSAStringToAddressW WSAStringToAddress;
}
else {
	alias WSAStringToAddressA WSAStringToAddress;
}

alias INT function (
    LPSTR               AddressString,
    INT                 AddressFamily,
    LPWSAPROTOCOL_INFOA lpProtocolInfo,
    LPSOCKADDR lpAddress,
    LPINT              lpAddressLength
    ) LPFN_WSASTRINGTOADDRESSA;

alias INT function (
    LPWSTR              AddressString,
    INT                 AddressFamily,
    LPWSAPROTOCOL_INFOW lpProtocolInfo,
    LPSOCKADDR lpAddress,
    LPINT              lpAddressLength
    ) LPFN_WSASTRINGTOADDRESSW;

version(UNICODE) {
	alias LPFN_WSASTRINGTOADDRESSW LPFN_WSASTRINGTOADDRESS;
}
else {
	alias LPFN_WSASTRINGTOADDRESSA LPFN_WSASTRINGTOADDRESS;
}


/* Registration and Name Resolution API functions */

INT WSALookupServiceBeginA(
    LPWSAQUERYSETA lpqsRestrictions,
    DWORD          dwControlFlags,
    LPHANDLE       lphLookup
    );

INT WSALookupServiceBeginW(
    LPWSAQUERYSETW lpqsRestrictions,
    DWORD          dwControlFlags,
    LPHANDLE       lphLookup
    );

version(UNICODE) {
	alias WSALookupServiceBeginW WSALookupServiceBegin;
}
else {
	alias WSALookupServiceBeginA WSALookupServiceBegin;
}

alias INT function (
    LPWSAQUERYSETA lpqsRestrictions,
    DWORD          dwControlFlags,
    LPHANDLE       lphLookup
    ) LPFN_WSALOOKUPSERVICEBEGINA;

alias INT function (
    LPWSAQUERYSETW lpqsRestrictions,
    DWORD          dwControlFlags,
    LPHANDLE       lphLookup
    ) LPFN_WSALOOKUPSERVICEBEGINW;

version(UNICODE) {
	alias LPFN_WSALOOKUPSERVICEBEGINW LPFN_WSALOOKUPSERVICEBEGIN;
}
else {
	alias LPFN_WSALOOKUPSERVICEBEGINA LPFN_WSALOOKUPSERVICEBEGIN;
}

INT WSALookupServiceNextA(
    HANDLE           hLookup,
    DWORD            dwControlFlags,
    LPDWORD         lpdwBufferLength,
    LPWSAQUERYSETA lpqsResults
    );

INT WSALookupServiceNextW(
    HANDLE           hLookup,
    DWORD            dwControlFlags,
    LPDWORD         lpdwBufferLength,
	LPWSAQUERYSETW lpqsResults
    );

version(UNICODE) {
	alias WSALookupServiceNextW WSALookupServiceNext;
}
else {
	alias WSALookupServiceNextA WSALookupServiceNext;
}

alias INT function (
    HANDLE           hLookup,
    DWORD            dwControlFlags,
    LPDWORD         lpdwBufferLength,
    LPWSAQUERYSETA   lpqsResults
    ) LPFN_WSALOOKUPSERVICENEXTA;

alias INT function (
    HANDLE           hLookup,
    DWORD            dwControlFlags,
    LPDWORD         lpdwBufferLength,
	LPWSAQUERYSETW   lpqsResults
    ) LPFN_WSALOOKUPSERVICENEXTW;

version(UNICODE) {
	alias LPFN_WSALOOKUPSERVICENEXTW LPFN_WSALOOKUPSERVICENEXT;
}
else {
	alias LPFN_WSALOOKUPSERVICENEXTA LPFN_WSALOOKUPSERVICENEXT;
}

INT WSANSPIoctl(
    HANDLE           hLookup,
    DWORD            dwControlCode,
	LPVOID lpvInBuffer,
    DWORD            cbInBuffer,
	LPVOID lpvOutBuffer,
    DWORD            cbOutBuffer,
    LPDWORD        lpcbBytesReturned,
    LPWSACOMPLETION lpCompletion
    );

alias INT function (
    HANDLE           hLookup,
    DWORD            dwControlCode,
	LPVOID lpvInBuffer,
    DWORD            cbInBuffer,
	LPVOID lpvOutBuffer,
    DWORD            cbOutBuffer,
    LPDWORD        lpcbBytesReturned,
    LPWSACOMPLETION lpCompletion
    ) LPFN_WSANSPIOCTL;



INT WSALookupServiceEnd(
    HANDLE  hLookup
    );

alias INT function (
    HANDLE  hLookup
    ) LPFN_WSALOOKUPSERVICEEND;

INT WSAInstallServiceClassA(
     LPWSASERVICECLASSINFOA   lpServiceClassInfo
    );

INT WSAInstallServiceClassW(
     LPWSASERVICECLASSINFOW   lpServiceClassInfo
    );

version(UNICODE) {
	alias WSAInstallServiceClassW WSAInstallServiceClass;
}
else {
	alias WSAInstallServiceClassA WSAInstallServiceClass;
}

alias INT function (
     LPWSASERVICECLASSINFOA   lpServiceClassInfo
    ) LPFN_WSAINSTALLSERVICECLASSA;

alias INT function (
     LPWSASERVICECLASSINFOW   lpServiceClassInfo
    ) LPFN_WSAINSTALLSERVICECLASSW;

version(UNICODE) {
	alias LPFN_WSAINSTALLSERVICECLASSW LPFN_WSAINSTALLSERVICECLASS;
}
else {
	alias LPFN_WSAINSTALLSERVICECLASSA LPFN_WSAINSTALLSERVICECLASS;
}

INT WSARemoveServiceClass(
    LPGUID  lpServiceClassId
    );

alias INT function (
    LPGUID  lpServiceClassId
    ) LPFN_WSAREMOVESERVICECLASS;

INT WSAGetServiceClassInfoA(
    LPGUID  lpProviderId,
    LPGUID  lpServiceClassId,
    LPDWORD  lpdwBufSize,
    LPWSASERVICECLASSINFOA lpServiceClassInfo
    );

INT WSAGetServiceClassInfoW(
    LPGUID  lpProviderId,
    LPGUID  lpServiceClassId,
    LPDWORD  lpdwBufSize,
    LPWSASERVICECLASSINFOW lpServiceClassInfo
    );

version(UNICODE) {
	alias WSAGetServiceClassInfoW WSAGetServiceClassInfo;
}
else {
	alias WSAGetServiceClassInfoA WSAGetServiceClassInfo;
}

alias INT function (
    LPGUID  lpProviderId,
    LPGUID  lpServiceClassId,
    LPDWORD  lpdwBufSize,
    LPWSASERVICECLASSINFOA lpServiceClassInfo
    ) LPFN_WSAGETSERVICECLASSINFOA;

alias INT function (
    LPGUID  lpProviderId,
    LPGUID  lpServiceClassId,
    LPDWORD  lpdwBufSize,
    LPWSASERVICECLASSINFOW lpServiceClassInfo
    ) LPFN_WSAGETSERVICECLASSINFOW;

version(UNICODE) {
	alias LPFN_WSAGETSERVICECLASSINFOW LPFN_WSAGETSERVICECLASSINFO;
}
else {
	alias LPFN_WSAGETSERVICECLASSINFOA LPFN_WSAGETSERVICECLASSINFO;
}

INT WSAEnumNameSpaceProvidersA(
    LPDWORD             lpdwBufferLength,
    LPWSANAMESPACE_INFOA lpnspBuffer
    );

INT WSAEnumNameSpaceProvidersW(
    LPDWORD             lpdwBufferLength,
    LPWSANAMESPACE_INFOW lpnspBuffer
    );


version(UNICODE) {
	alias WSAEnumNameSpaceProvidersW WSAEnumNameSpaceProviders;
}
else {
	alias WSAEnumNameSpaceProvidersA WSAEnumNameSpaceProviders;
}

INT WSAEnumNameSpaceProvidersExA(
    LPDWORD             lpdwBufferLength,
    LPWSANAMESPACE_INFOEXA lpnspBuffer
    );

INT WSAEnumNameSpaceProvidersExW(
    LPDWORD             lpdwBufferLength,
    LPWSANAMESPACE_INFOEXW lpnspBuffer
    );

version(UNICODE) {
	alias WSAEnumNameSpaceProvidersExW WSAEnumNameSpaceProvidersEx;
}
else {
	alias WSAEnumNameSpaceProvidersExA WSAEnumNameSpaceProvidersEx;
}

alias INT function (
    LPDWORD              lpdwBufferLength,
    LPWSANAMESPACE_INFOA lpnspBuffer
    ) LPFN_WSAENUMNAMESPACEPROVIDERSA;

alias INT function (
    LPDWORD              lpdwBufferLength,
    LPWSANAMESPACE_INFOW lpnspBuffer
    ) LPFN_WSAENUMNAMESPACEPROVIDERSW;

version(UNICODE) {
	alias LPFN_WSAENUMNAMESPACEPROVIDERSW LPFN_WSAENUMNAMESPACEPROVIDERS;
}
else {
	alias LPFN_WSAENUMNAMESPACEPROVIDERSA LPFN_WSAENUMNAMESPACEPROVIDERS;
}

alias INT function (
    LPDWORD              lpdwBufferLength,
    LPWSANAMESPACE_INFOEXA lpnspBuffer
    ) LPFN_WSAENUMNAMESPACEPROVIDERSEXA;

alias INT function (
    LPDWORD              lpdwBufferLength,
    LPWSANAMESPACE_INFOEXW lpnspBuffer
    ) LPFN_WSAENUMNAMESPACEPROVIDERSEXW;

version(UNICODE) {
	alias LPFN_WSAENUMNAMESPACEPROVIDERSEXW LPFN_WSAENUMNAMESPACEPROVIDERSEX;
}
else {
	alias LPFN_WSAENUMNAMESPACEPROVIDERSEXA LPFN_WSAENUMNAMESPACEPROVIDERSEX;
}

INT WSAGetServiceClassNameByClassIdA(
    LPGUID  lpServiceClassId,
    LPSTR lpszServiceClassName,
    LPDWORD lpdwBufferLength
    );

INT WSAGetServiceClassNameByClassIdW(
    LPGUID  lpServiceClassId,
    LPWSTR lpszServiceClassName,
    LPDWORD lpdwBufferLength
    );

version(UNICODE) {
	alias WSAGetServiceClassNameByClassIdW WSAGetServiceClassNameByClassId;
}
else {
	alias WSAGetServiceClassNameByClassIdA WSAGetServiceClassNameByClassId;
}



alias INT function (
    LPGUID  lpServiceClassId,
    LPSTR lpszServiceClassName,
    LPDWORD lpdwBufferLength
    ) LPFN_WSAGETSERVICECLASSNAMEBYCLASSIDA;

alias INT function (
    LPGUID  lpServiceClassId,
    LPWSTR lpszServiceClassName,
    LPDWORD lpdwBufferLength
    ) LPFN_WSAGETSERVICECLASSNAMEBYCLASSIDW;

version(UNICODE) {
	alias LPFN_WSAGETSERVICECLASSNAMEBYCLASSIDW LPFN_WSAGETSERVICECLASSNAMEBYCLASSID;
}
else {
	alias LPFN_WSAGETSERVICECLASSNAMEBYCLASSIDA LPFN_WSAGETSERVICECLASSNAMEBYCLASSID;
}

INT WSASetServiceA(
    LPWSAQUERYSETA lpqsRegInfo,
    WSAESETSERVICEOP essoperation,
    DWORD dwControlFlags
    );

INT WSASetServiceW(
    LPWSAQUERYSETW lpqsRegInfo,
    WSAESETSERVICEOP essoperation,
    DWORD dwControlFlags
    );

version(UNICODE) {
	alias WSASetServiceW WSASetService;
}
else {
	alias WSASetServiceA WSASetService;
}



alias INT function (
    LPWSAQUERYSETA lpqsRegInfo,
    WSAESETSERVICEOP essoperation,
    DWORD dwControlFlags
    ) LPFN_WSASETSERVICEA;

alias INT function (
    LPWSAQUERYSETW lpqsRegInfo,
    WSAESETSERVICEOP essoperation,
    DWORD dwControlFlags
    ) LPFN_WSASETSERVICEW;

version(UNICODE) {
	alias LPFN_WSASETSERVICEW LPFN_WSASETSERVICE;
}
else {
	alias LPFN_WSASETSERVICEA LPFN_WSASETSERVICE;
}

INT WSAProviderConfigChange(
    LPHANDLE lpNotificationHandle,
    LPWSAOVERLAPPED lpOverlapped,
    LPWSAOVERLAPPED_COMPLETION_ROUTINE lpCompletionRoutine
    );

alias INT function (
    LPHANDLE lpNotificationHandle,
    LPWSAOVERLAPPED lpOverlapped,
    LPWSAOVERLAPPED_COMPLETION_ROUTINE lpCompletionRoutine
    ) LPFN_WSAPROVIDERCONFIGCHANGE;

int WSAPoll(
    LPWSAPOLLFD fdArray,
    ULONG fds,
    INT timeout
    );

/* Microsoft Windows Extended data types */
alias sockaddr_in *LPSOCKADDR_IN;

alias linger LINGER;
alias linger *PLINGER;
alias linger *LPLINGER;

alias fd_set FD_SET;
alias fd_set *PFD_SET;
alias fd_set *LPFD_SET;

alias hostent HOSTENT;
alias hostent *PHOSTENT;
alias hostent *LPHOSTENT;

alias servent SERVENT;
alias servent *PSERVENT;
alias servent *LPSERVENT;

alias protoent PROTOENT;
alias protoent *PPROTOENT;
alias protoent *LPPROTOENT;

alias timeval TIMEVAL;
alias timeval *PTIMEVAL;
alias timeval *LPTIMEVAL;

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
 * to a WSAAsyncGetXByY().
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
