/*
 * winbase.d
 *
 * This module is a port of winbase.h to D.
 * The original copyright notice appears after this information block.
 *
 * Author: Dave Wilkinson
 * Originated: November 24th, 2009
 *
 */

module binding.win32.winbase;

import binding.win32.guiddef;
import binding.win32.windef;
import binding.win32.winnt;
import binding.win32.ntstatus;

extern(System):

/************************************************************************
*                                                                       *
*   winbase.h -- This module defines the 32-Bit Windows Base APIs       *
*                                                                       *
*   Copyright (c) Microsoft Corp. All rights reserved.                  *
*                                                                       *
************************************************************************/

const auto INVALID_HANDLE_VALUE  = ((HANDLE)(LONG_PTR)-1);
const auto INVALID_FILE_SIZE  = ((DWORD)0xFFFFFFFF);
const auto INVALID_SET_FILE_POINTER  = ((DWORD)-1);
const auto INVALID_FILE_ATTRIBUTES  = ((DWORD)-1);

const auto FILE_BEGIN            = 0;
const auto FILE_CURRENT          = 1;
const auto FILE_END              = 2;

const auto TIME_ZONE_ID_INVALID  = ((DWORD)0xFFFFFFFF);

const auto WAIT_FAILED  = ((DWORD)0xFFFFFFFF);
const auto WAIT_OBJECT_0        = ((STATUS_WAIT_0 ) + 0 );

const auto WAIT_ABANDONED          = ((STATUS_ABANDONED_WAIT_0 ) + 0 );
const auto WAIT_ABANDONED_0        = ((STATUS_ABANDONED_WAIT_0 ) + 0 );

const auto WAIT_IO_COMPLETION                   = STATUS_USER_APC;
const auto STILL_ACTIVE                         = STATUS_PENDING;
const auto EXCEPTION_ACCESS_VIOLATION           = STATUS_ACCESS_VIOLATION;
const auto EXCEPTION_DATATYPE_MISALIGNMENT      = STATUS_DATATYPE_MISALIGNMENT;
const auto EXCEPTION_BREAKPOINT                 = STATUS_BREAKPOINT;
const auto EXCEPTION_SINGLE_STEP                = STATUS_SINGLE_STEP;
const auto EXCEPTION_ARRAY_BOUNDS_EXCEEDED      = STATUS_ARRAY_BOUNDS_EXCEEDED;
const auto EXCEPTION_FLT_DENORMAL_OPERAND       = STATUS_FLOAT_DENORMAL_OPERAND;
const auto EXCEPTION_FLT_DIVIDE_BY_ZERO         = STATUS_FLOAT_DIVIDE_BY_ZERO;
const auto EXCEPTION_FLT_INEXACT_RESULT         = STATUS_FLOAT_INEXACT_RESULT;
const auto EXCEPTION_FLT_INVALID_OPERATION      = STATUS_FLOAT_INVALID_OPERATION;
const auto EXCEPTION_FLT_OVERFLOW               = STATUS_FLOAT_OVERFLOW;
const auto EXCEPTION_FLT_STACK_CHECK            = STATUS_FLOAT_STACK_CHECK;
const auto EXCEPTION_FLT_UNDERFLOW              = STATUS_FLOAT_UNDERFLOW;
const auto EXCEPTION_INT_DIVIDE_BY_ZERO         = STATUS_INTEGER_DIVIDE_BY_ZERO;
const auto EXCEPTION_INT_OVERFLOW               = STATUS_INTEGER_OVERFLOW;
const auto EXCEPTION_PRIV_INSTRUCTION           = STATUS_PRIVILEGED_INSTRUCTION;
const auto EXCEPTION_IN_PAGE_ERROR              = STATUS_IN_PAGE_ERROR;
const auto EXCEPTION_ILLEGAL_INSTRUCTION        = STATUS_ILLEGAL_INSTRUCTION;
const auto EXCEPTION_NONCONTINUABLE_EXCEPTION   = STATUS_NONCONTINUABLE_EXCEPTION;
const auto EXCEPTION_STACK_OVERFLOW             = STATUS_STACK_OVERFLOW;
const auto EXCEPTION_INVALID_DISPOSITION        = STATUS_INVALID_DISPOSITION;
const auto EXCEPTION_GUARD_PAGE                 = STATUS_GUARD_PAGE_VIOLATION;
const auto EXCEPTION_INVALID_HANDLE             = STATUS_INVALID_HANDLE;
const auto EXCEPTION_POSSIBLE_DEADLOCK          = STATUS_POSSIBLE_DEADLOCK;
const auto CONTROL_C_EXIT                       = STATUS_CONTROL_C_EXIT;

const auto MoveMemory  = RtlMoveMemory;
const auto CopyMemory  = RtlCopyMemory;
const auto FillMemory  = RtlFillMemory;
const auto ZeroMemory  = RtlZeroMemory;
const auto SecureZeroMemory  = RtlSecureZeroMemory;
const auto CaptureStackBackTrace  = RtlCaptureStackBackTrace;

//
// File creation flags must start at the high end since they
// are combined with the attributes
//

const auto FILE_FLAG_WRITE_THROUGH          = 0x80000000;
const auto FILE_FLAG_OVERLAPPED             = 0x40000000;
const auto FILE_FLAG_NO_BUFFERING           = 0x20000000;
const auto FILE_FLAG_RANDOM_ACCESS          = 0x10000000;
const auto FILE_FLAG_SEQUENTIAL_SCAN        = 0x08000000;
const auto FILE_FLAG_DELETE_ON_CLOSE        = 0x04000000;
const auto FILE_FLAG_BACKUP_SEMANTICS       = 0x02000000;
const auto FILE_FLAG_POSIX_SEMANTICS        = 0x01000000;
const auto FILE_FLAG_OPEN_REPARSE_POINT     = 0x00200000;
const auto FILE_FLAG_OPEN_NO_RECALL         = 0x00100000;
const auto FILE_FLAG_FIRST_PIPE_INSTANCE    = 0x00080000;

const auto CREATE_NEW           = 1;
const auto CREATE_ALWAYS        = 2;
const auto OPEN_EXISTING        = 3;
const auto OPEN_ALWAYS          = 4;
const auto TRUNCATE_EXISTING    = 5;

#if(_WIN32_WINNT >= 0x0400)
//
// Define possible return codes from the CopyFileEx callback routine
//

const auto PROGRESS_CONTINUE    = 0;
const auto PROGRESS_CANCEL      = 1;
const auto PROGRESS_STOP        = 2;
const auto PROGRESS_QUIET       = 3;

//
// Define CopyFileEx callback routine state change values
//

const auto CALLBACK_CHUNK_FINISHED          = 0x00000000;
const auto CALLBACK_STREAM_SWITCH           = 0x00000001;

//
// Define CopyFileEx option flags
//

const auto COPY_FILE_FAIL_IF_EXISTS               = 0x00000001;
const auto COPY_FILE_RESTARTABLE                  = 0x00000002;
const auto COPY_FILE_OPEN_SOURCE_FOR_WRITE        = 0x00000004;
const auto COPY_FILE_ALLOW_DECRYPTED_DESTINATION  = 0x00000008;

//
//  Gap for private copyfile flags
//

#if (_WIN32_WINNT >= 0x0600)
const auto COPY_FILE_COPY_SYMLINK                 = 0x00000800;
#endif
#endif /* _WIN32_WINNT >= 0x0400 */

#if (_WIN32_WINNT >= 0x0500)
//
// Define ReplaceFile option flags
//

const auto REPLACEFILE_WRITE_THROUGH        = 0x00000001;
const auto REPLACEFILE_IGNORE_MERGE_ERRORS  = 0x00000002;

#endif // #if (_WIN32_WINNT >= 0x0500)

//
// Define the NamedPipe definitions
//


//
// Define the dwOpenMode values for CreateNamedPipe
//

const auto PIPE_ACCESS_INBOUND          = 0x00000001;
const auto PIPE_ACCESS_OUTBOUND         = 0x00000002;
const auto PIPE_ACCESS_DUPLEX           = 0x00000003;

//
// Define the Named Pipe End flags for GetNamedPipeInfo
//

const auto PIPE_CLIENT_END              = 0x00000000;
const auto PIPE_SERVER_END              = 0x00000001;

//
// Define the dwPipeMode values for CreateNamedPipe
//

const auto PIPE_WAIT                    = 0x00000000;
const auto PIPE_NOWAIT                  = 0x00000001;
const auto PIPE_READMODE_BYTE           = 0x00000000;
const auto PIPE_READMODE_MESSAGE        = 0x00000002;
const auto PIPE_TYPE_BYTE               = 0x00000000;
const auto PIPE_TYPE_MESSAGE            = 0x00000004;
const auto PIPE_ACCEPT_REMOTE_CLIENTS   = 0x00000000;
const auto PIPE_REJECT_REMOTE_CLIENTS   = 0x00000008;

//
// Define the well known values for CreateNamedPipe nMaxInstances
//

const auto PIPE_UNLIMITED_INSTANCES     = 255;

//
// Define the Security Quality of Service bits to be passed
// into CreateFile
//

const auto SECURITY_ANONYMOUS           = ( SecurityAnonymous      << 16 );
const auto SECURITY_IDENTIFICATION      = ( SecurityIdentification << 16 );
const auto SECURITY_IMPERSONATION       = ( SecurityImpersonation  << 16 );
const auto SECURITY_DELEGATION          = ( SecurityDelegation     << 16 );

const auto SECURITY_CONTEXT_TRACKING   = 0x00040000;
const auto SECURITY_EFFECTIVE_ONLY     = 0x00080000;

const auto SECURITY_SQOS_PRESENT       = 0x00100000;
const auto SECURITY_VALID_SQOS_FLAGS   = 0x001F0000;

//
//  File structures
//

struct OVERLAPPED {
    ULONG_PTR Internal;
    ULONG_PTR InternalHigh;
    union {
        struct {
            DWORD Offset;
            DWORD OffsetHigh;
        };

        PVOID Pointer;
    };

    HANDLE  hEvent;
}

typedef OVERLAPPED* LPOVERLAPPED;

struct OVERLAPPED_ENTRY {
    ULONG_PTR lpCompletionKey;
    LPOVERLAPPED lpOverlapped;
    ULONG_PTR Internal;
    DWORD dwNumberOfBytesTransferred;
}

typedef OVERLAPPED_ENTRY* LPOVERLAPPED_ENTRY;

struct SECURITY_ATTRIBUTES {
    DWORD nLength;
    LPVOID lpSecurityDescriptor;
    BOOL bInheritHandle;
}

typedef SECURITY_ATTRIBUTES* PSECURITY_ATTRIBUTES;
typedef SECURITY_ATTRIBUTES* LPSECURITY_ATTRIBUTES;

struct PROCESS_INFORMATION {
    HANDLE hProcess;
    HANDLE hThread;
    DWORD dwProcessId;
    DWORD dwThreadId;
}

typedef PROCESS_INFORMATION* PPROCESS_INFORMATION;
typedef PROCESS_INFORMATION* LPPROCESS_INFORMATION;

//
//  File System time stamps are represented with the following structure:
//


#ifndef _FILETIME_
#define _FILETIME_
struct FILETIME {
    DWORD dwLowDateTime;
    DWORD dwHighDateTime;
}

typedef FILETIME* PFILETIME;
typedef FILETIME* LPFILETIME;
#endif

//
// System time is represented with the following structure:
//


struct SYSTEMTIME {
    WORD wYear;
    WORD wMonth;
    WORD wDayOfWeek;
    WORD wDay;
    WORD wHour;
    WORD wMinute;
    WORD wSecond;
    WORD wMilliseconds;
}

typedef SYSTEMTIME* PSYSTEMTIME;
typedef SYSTEMTIME* LPSYSTEMTIME;


typedef DWORD (WINAPI *PTHREAD_START_ROUTINE)(
    LPVOID lpThreadParameter
    );
typedef PTHREAD_START_ROUTINE LPTHREAD_START_ROUTINE;

#if(_WIN32_WINNT >= 0x0400)
typedef VOID (WINAPI *PFIBER_START_ROUTINE)(
    LPVOID lpFiberParameter
    );
typedef PFIBER_START_ROUTINE LPFIBER_START_ROUTINE;
#endif /* _WIN32_WINNT >= 0x0400 */

typedef RTL_CRITICAL_SECTION CRITICAL_SECTION;
typedef PRTL_CRITICAL_SECTION PCRITICAL_SECTION;
typedef PRTL_CRITICAL_SECTION LPCRITICAL_SECTION;

typedef RTL_CRITICAL_SECTION_DEBUG CRITICAL_SECTION_DEBUG;
typedef PRTL_CRITICAL_SECTION_DEBUG PCRITICAL_SECTION_DEBUG;
typedef PRTL_CRITICAL_SECTION_DEBUG LPCRITICAL_SECTION_DEBUG;

#if (_WIN32_WINNT >= 0x0600)

//
// Define one-time initialization primitive
//

typedef RTL_RUN_ONCE INIT_ONCE;
typedef PRTL_RUN_ONCE PINIT_ONCE;
typedef PRTL_RUN_ONCE LPINIT_ONCE;

const auto INIT_ONCE_STATIC_INIT    = RTL_RUN_ONCE_INIT;

//
// Run once flags
//

const auto INIT_ONCE_CHECK_ONLY         = RTL_RUN_ONCE_CHECK_ONLY;
const auto INIT_ONCE_ASYNC              = RTL_RUN_ONCE_ASYNC;
const auto INIT_ONCE_INIT_FAILED        = RTL_RUN_ONCE_INIT_FAILED;

//
// The context stored in the run once structure must leave the following number
// of low order bits unused.
//

const auto INIT_ONCE_CTX_RESERVED_BITS  = RTL_RUN_ONCE_CTX_RESERVED_BITS;

typedef
BOOL
(WINAPI *PINIT_ONCE_FN) (
    __inout PINIT_ONCE InitOnce,
    __inout_opt PVOID Parameter,
    __deref_opt_out_opt PVOID *Context
    );

VOID
InitOnceInitialize (
    __out PINIT_ONCE InitOnce
    );

BOOL
InitOnceExecuteOnce (
    __inout PINIT_ONCE InitOnce,
    __in __callback PINIT_ONCE_FN InitFn,
    __inout_opt PVOID Parameter,
    __deref_opt_out_opt LPVOID *Context
    );

BOOL
InitOnceBeginInitialize (
    __inout LPINIT_ONCE lpInitOnce,
    __in DWORD dwFlags,
    __out PBOOL fPending,
    __deref_opt_out_opt LPVOID *lpContext
    );

BOOL
InitOnceComplete (
    __inout LPINIT_ONCE lpInitOnce,
    __in DWORD dwFlags,
    __in_opt LPVOID lpContext
    );

#endif

//
// Define the slim r/w lock
//

typedef RTL_SRWLOCK SRWLOCK, *PSRWLOCK;

const auto SRWLOCK_INIT  = RTL_SRWLOCK_INIT;

VOID
InitializeSRWLock (
     __out PSRWLOCK SRWLock
     );

VOID
ReleaseSRWLockExclusive (
     __inout PSRWLOCK SRWLock
     );

VOID
ReleaseSRWLockShared (
     __inout PSRWLOCK SRWLock
     );

VOID
AcquireSRWLockExclusive (
     __inout PSRWLOCK SRWLock
     );

VOID
AcquireSRWLockShared (
     __inout PSRWLOCK SRWLock
     );

//
// Define condition variable
//

typedef RTL_CONDITION_VARIABLE CONDITION_VARIABLE, *PCONDITION_VARIABLE;

VOID
InitializeConditionVariable (
    __out PCONDITION_VARIABLE ConditionVariable
    );

VOID
WakeConditionVariable (
    __inout PCONDITION_VARIABLE ConditionVariable
    );

VOID
WakeAllConditionVariable (
    __inout PCONDITION_VARIABLE ConditionVariable
    );

BOOL
SleepConditionVariableCS (
    __inout PCONDITION_VARIABLE ConditionVariable,
    __inout PCRITICAL_SECTION CriticalSection,
    __in DWORD dwMilliseconds
    );

BOOL
SleepConditionVariableSRW (
    __inout PCONDITION_VARIABLE ConditionVariable,
    __inout PSRWLOCK SRWLock,
    __in DWORD dwMilliseconds,
    __in ULONG Flags
    );

//
// Static initializer for the condition variable
//

const auto CONDITION_VARIABLE_INIT  = RTL_CONDITION_VARIABLE_INIT;

//
// Flags for condition variables
//
const auto CONDITION_VARIABLE_LOCKMODE_SHARED  = RTL_CONDITION_VARIABLE_LOCKMODE_SHARED;


__out_opt
PVOID
EncodePointer (
    __in_opt PVOID Ptr
    );

__out_opt
PVOID
DecodePointer (
    __in_opt PVOID Ptr
    );

__out_opt
PVOID
EncodeSystemPointer (
    __in_opt PVOID Ptr
    );

__out_opt
PVOID
DecodeSystemPointer (
    __in_opt PVOID Ptr
    );

#if defined(_X86_)
typedef PLDT_ENTRY LPLDT_ENTRY;
#else
typedef LPVOID LPLDT_ENTRY;
#endif

const auto MUTEX_MODIFY_STATE  = MUTANT_QUERY_STATE;
const auto MUTEX_ALL_ACCESS  = MUTANT_ALL_ACCESS;

//
// Serial provider type.
//

const auto SP_SERIALCOMM     = ((DWORD)0x00000001);

//
// Provider SubTypes
//

const auto PST_UNSPECIFIED       = ((DWORD)0x00000000);
const auto PST_RS232             = ((DWORD)0x00000001);
const auto PST_PARALLELPORT      = ((DWORD)0x00000002);
const auto PST_RS422             = ((DWORD)0x00000003);
const auto PST_RS423             = ((DWORD)0x00000004);
const auto PST_RS449             = ((DWORD)0x00000005);
const auto PST_MODEM             = ((DWORD)0x00000006);
const auto PST_FAX               = ((DWORD)0x00000021);
const auto PST_SCANNER           = ((DWORD)0x00000022);
const auto PST_NETWORK_BRIDGE    = ((DWORD)0x00000100);
const auto PST_LAT               = ((DWORD)0x00000101);
const auto PST_TCPIP_TELNET      = ((DWORD)0x00000102);
const auto PST_X25               = ((DWORD)0x00000103);


//
// Provider capabilities flags.
//

const auto PCF_DTRDSR         = ((DWORD)0x0001);
const auto PCF_RTSCTS         = ((DWORD)0x0002);
const auto PCF_RLSD           = ((DWORD)0x0004);
const auto PCF_PARITY_CHECK   = ((DWORD)0x0008);
const auto PCF_XONXOFF        = ((DWORD)0x0010);
const auto PCF_SETXCHAR       = ((DWORD)0x0020);
const auto PCF_TOTALTIMEOUTS  = ((DWORD)0x0040);
const auto PCF_INTTIMEOUTS    = ((DWORD)0x0080);
const auto PCF_SPECIALCHARS   = ((DWORD)0x0100);
const auto PCF_16BITMODE      = ((DWORD)0x0200);

//
// Comm provider settable parameters.
//

const auto SP_PARITY          = ((DWORD)0x0001);
const auto SP_BAUD            = ((DWORD)0x0002);
const auto SP_DATABITS        = ((DWORD)0x0004);
const auto SP_STOPBITS        = ((DWORD)0x0008);
const auto SP_HANDSHAKING     = ((DWORD)0x0010);
const auto SP_PARITY_CHECK    = ((DWORD)0x0020);
const auto SP_RLSD            = ((DWORD)0x0040);

//
// Settable baud rates in the provider.
//

const auto BAUD_075           = ((DWORD)0x00000001);
const auto BAUD_110           = ((DWORD)0x00000002);
const auto BAUD_134_5         = ((DWORD)0x00000004);
const auto BAUD_150           = ((DWORD)0x00000008);
const auto BAUD_300           = ((DWORD)0x00000010);
const auto BAUD_600           = ((DWORD)0x00000020);
const auto BAUD_1200          = ((DWORD)0x00000040);
const auto BAUD_1800          = ((DWORD)0x00000080);
const auto BAUD_2400          = ((DWORD)0x00000100);
const auto BAUD_4800          = ((DWORD)0x00000200);
const auto BAUD_7200          = ((DWORD)0x00000400);
const auto BAUD_9600          = ((DWORD)0x00000800);
const auto BAUD_14400         = ((DWORD)0x00001000);
const auto BAUD_19200         = ((DWORD)0x00002000);
const auto BAUD_38400         = ((DWORD)0x00004000);
const auto BAUD_56K           = ((DWORD)0x00008000);
const auto BAUD_128K          = ((DWORD)0x00010000);
const auto BAUD_115200        = ((DWORD)0x00020000);
const auto BAUD_57600         = ((DWORD)0x00040000);
const auto BAUD_USER          = ((DWORD)0x10000000);

//
// Settable Data Bits
//

const auto DATABITS_5         = ((WORD)0x0001);
const auto DATABITS_6         = ((WORD)0x0002);
const auto DATABITS_7         = ((WORD)0x0004);
const auto DATABITS_8         = ((WORD)0x0008);
const auto DATABITS_16        = ((WORD)0x0010);
const auto DATABITS_16X       = ((WORD)0x0020);

//
// Settable Stop and Parity bits.
//

const auto STOPBITS_10        = ((WORD)0x0001);
const auto STOPBITS_15        = ((WORD)0x0002);
const auto STOPBITS_20        = ((WORD)0x0004);
const auto PARITY_NONE        = ((WORD)0x0100);
const auto PARITY_ODD         = ((WORD)0x0200);
const auto PARITY_EVEN        = ((WORD)0x0400);
const auto PARITY_MARK        = ((WORD)0x0800);
const auto PARITY_SPACE       = ((WORD)0x1000);

struct COMMPROP {
    WORD wPacketLength;
    WORD wPacketVersion;
    DWORD dwServiceMask;
    DWORD dwReserved1;
    DWORD dwMaxTxQueue;
    DWORD dwMaxRxQueue;
    DWORD dwMaxBaud;
    DWORD dwProvSubType;
    DWORD dwProvCapabilities;
    DWORD dwSettableParams;
    DWORD dwSettableBaud;
    WORD wSettableData;
    WORD wSettableStopParity;
    DWORD dwCurrentTxQueue;
    DWORD dwCurrentRxQueue;
    DWORD dwProvSpec1;
    DWORD dwProvSpec2;
    WCHAR wcProvChar[1];
}

typedef COMMPROP* LPCOMMPROP;

//
// Set dwProvSpec1 to COMMPROP_INITIALIZED to indicate that wPacketLength
// is valid before a call to GetCommProperties().
//
const auto COMMPROP_INITIALIZED  = ((DWORD)0xE73CF52E);

struct COMSTAT {
    DWORD fCtsHold : 1;
    DWORD fDsrHold : 1;
    DWORD fRlsdHold : 1;
    DWORD fXoffHold : 1;
    DWORD fXoffSent : 1;
    DWORD fEof : 1;
    DWORD fTxim : 1;
    DWORD fReserved : 25;
    DWORD cbInQue;
    DWORD cbOutQue;
}

typedef COMSTAT* LPCOMSTAT;

//
// DTR Control Flow Values.
//
const auto DTR_CONTROL_DISABLE     = 0x00;
const auto DTR_CONTROL_ENABLE      = 0x01;
const auto DTR_CONTROL_HANDSHAKE   = 0x02;

//
// RTS Control Flow Values
//
const auto RTS_CONTROL_DISABLE     = 0x00;
const auto RTS_CONTROL_ENABLE      = 0x01;
const auto RTS_CONTROL_HANDSHAKE   = 0x02;
const auto RTS_CONTROL_TOGGLE      = 0x03;

struct DCB {
    DWORD DCBlength;      /* sizeof(DCB)                     */
    DWORD BaudRate;       /* Baudrate at which running       */
    DWORD fBinary: 1;     /* Binary Mode (skip EOF check)    */
    DWORD fParity: 1;     /* Enable parity checking          */
    DWORD fOutxCtsFlow:1; /* CTS handshaking on output       */
    DWORD fOutxDsrFlow:1; /* DSR handshaking on output       */
    DWORD fDtrControl:2;  /* DTR Flow control                */
    DWORD fDsrSensitivity:1; /* DSR Sensitivity              */
    DWORD fTXContinueOnXoff: 1; /* Continue TX when Xoff sent */
    DWORD fOutX: 1;       /* Enable output X-ON/X-OFF        */
    DWORD fInX: 1;        /* Enable input X-ON/X-OFF         */
    DWORD fErrorChar: 1;  /* Enable Err Replacement          */
    DWORD fNull: 1;       /* Enable Null stripping           */
    DWORD fRtsControl:2;  /* Rts Flow control                */
    DWORD fAbortOnError:1; /* Abort all reads and writes on Error */
    DWORD fDummy2:17;     /* Reserved                        */
    WORD wReserved;       /* Not currently used              */
    WORD XonLim;          /* Transmit X-ON threshold         */
    WORD XoffLim;         /* Transmit X-OFF threshold        */
    BYTE ByteSize;        /* Number of bits/byte, 4-8        */
    BYTE Parity;          /* 0-4=None,Odd,Even,Mark,Space    */
    BYTE StopBits;        /* 0,1,2 = 1, 1.5, 2               */
    char XonChar;         /* Tx and Rx X-ON character        */
    char XoffChar;        /* Tx and Rx X-OFF character       */
    char ErrorChar;       /* Error replacement char          */
    char EofChar;         /* End of Input character          */
    char EvtChar;         /* Received Event character        */
    WORD wReserved1;      /* Fill for now.                   */
}

typedef DCB* LPDCB;

struct COMMTIMEOUTS {
    DWORD ReadIntervalTimeout;          /* Maximum time between read chars. */
    DWORD ReadTotalTimeoutMultiplier;   /* Multiplier of characters.        */
    DWORD ReadTotalTimeoutConstant;     /* Constant in milliseconds.        */
    DWORD WriteTotalTimeoutMultiplier;  /* Multiplier of characters.        */
    DWORD WriteTotalTimeoutConstant;    /* Constant in milliseconds.        */
}

typedef COMMTIMEOUTS* LPCOMMTIMEOUTS;

struct COMMCONFIG {
    DWORD dwSize;               /* Size of the entire struct */
    WORD wVersion;              /* version of the structure */
    WORD wReserved;             /* alignment */
    DCB dcb;                    /* device control block */
    DWORD dwProviderSubType;    /* ordinal value for identifying
                                   provider-defined data structure format*/
    DWORD dwProviderOffset;     /* Specifies the offset of provider specific
                                   data field in bytes from the start */
    DWORD dwProviderSize;       /* size of the provider-specific data field */
    WCHAR wcProviderData[1];    /* provider-specific data */
}

typedef COMMCONFIG* LPCOMMCONFIG;

struct SYSTEM_INFO {
    union {
        DWORD dwOemId;          // Obsolete field...do not use
        struct {
            WORD wProcessorArchitecture;
            WORD wReserved;
        };
    };
    DWORD dwPageSize;
    LPVOID lpMinimumApplicationAddress;
    LPVOID lpMaximumApplicationAddress;
    DWORD_PTR dwActiveProcessorMask;
    DWORD dwNumberOfProcessors;
    DWORD dwProcessorType;
    DWORD dwAllocationGranularity;
    WORD wProcessorLevel;
    WORD wProcessorRevision;
}

typedef SYSTEM_INFO* LPSYSTEM_INFO;

//
//


const auto FreeModule(hLibModule)  = FreeLibrary((hLibModule));
const auto MakeProcInstance(lpProc,hInstance)  = (lpProc);
const auto FreeProcInstance(lpProc)  = (lpProc);

/* Global Memory Flags */
const auto GMEM_FIXED           = 0x0000;
const auto GMEM_MOVEABLE        = 0x0002;
const auto GMEM_NOCOMPACT       = 0x0010;
const auto GMEM_NODISCARD       = 0x0020;
const auto GMEM_ZEROINIT        = 0x0040;
const auto GMEM_MODIFY          = 0x0080;
const auto GMEM_DISCARDABLE     = 0x0100;
const auto GMEM_NOT_BANKED      = 0x1000;
const auto GMEM_SHARE           = 0x2000;
const auto GMEM_DDESHARE        = 0x2000;
const auto GMEM_NOTIFY          = 0x4000;
const auto GMEM_LOWER           = GMEM_NOT_BANKED;
const auto GMEM_VALID_FLAGS     = 0x7F72;
const auto GMEM_INVALID_HANDLE  = 0x8000;

const auto GHND                 = (GMEM_MOVEABLE | GMEM_ZEROINIT);
const auto GPTR                 = (GMEM_FIXED | GMEM_ZEROINIT);

const auto GlobalLRUNewest(  = h )    ((HANDLE)(h));
const auto GlobalLRUOldest(  = h )    ((HANDLE)(h));
const auto GlobalDiscard(  = h )      GlobalReAlloc( (h), 0, GMEM_MOVEABLE );

/* Flags returned by GlobalFlags (in addition to GMEM_DISCARDABLE) */
const auto GMEM_DISCARDED       = 0x4000;
const auto GMEM_LOCKCOUNT       = 0x00FF;

struct MEMORYSTATUS {
    DWORD dwLength;
    DWORD dwMemoryLoad;
    SIZE_T dwTotalPhys;
    SIZE_T dwAvailPhys;
    SIZE_T dwTotalPageFile;
    SIZE_T dwAvailPageFile;
    SIZE_T dwTotalVirtual;
    SIZE_T dwAvailVirtual;
}

typedef MEMORYSTATUS* LPMEMORYSTATUS;

/* Local Memory Flags */
const auto LMEM_FIXED           = 0x0000;
const auto LMEM_MOVEABLE        = 0x0002;
const auto LMEM_NOCOMPACT       = 0x0010;
const auto LMEM_NODISCARD       = 0x0020;
const auto LMEM_ZEROINIT        = 0x0040;
const auto LMEM_MODIFY          = 0x0080;
const auto LMEM_DISCARDABLE     = 0x0F00;
const auto LMEM_VALID_FLAGS     = 0x0F72;
const auto LMEM_INVALID_HANDLE  = 0x8000;

const auto LHND                 = (LMEM_MOVEABLE | LMEM_ZEROINIT);
const auto LPTR                 = (LMEM_FIXED | LMEM_ZEROINIT);

const auto NONZEROLHND          = (LMEM_MOVEABLE);
const auto NONZEROLPTR          = (LMEM_FIXED);

const auto LocalDiscard(  = h )   LocalReAlloc( (h), 0, LMEM_MOVEABLE );

/* Flags returned by LocalFlags (in addition to LMEM_DISCARDABLE) */
const auto LMEM_DISCARDED       = 0x4000;
const auto LMEM_LOCKCOUNT       = 0x00FF;

//
// NUMA values
//
const auto NUMA_NO_PREFERRED_NODE  = ((DWORD) -1);

//
// dwCreationFlag values
//

const auto DEBUG_PROCESS                      = 0x00000001;
const auto DEBUG_ONLY_THIS_PROCESS            = 0x00000002;

const auto CREATE_SUSPENDED                   = 0x00000004;

const auto DETACHED_PROCESS                   = 0x00000008;

const auto CREATE_NEW_CONSOLE                 = 0x00000010;

const auto NORMAL_PRIORITY_CLASS              = 0x00000020;
const auto IDLE_PRIORITY_CLASS                = 0x00000040;
const auto HIGH_PRIORITY_CLASS                = 0x00000080;
const auto REALTIME_PRIORITY_CLASS            = 0x00000100;

const auto CREATE_NEW_PROCESS_GROUP           = 0x00000200;
const auto CREATE_UNICODE_ENVIRONMENT         = 0x00000400;

const auto CREATE_SEPARATE_WOW_VDM            = 0x00000800;
const auto CREATE_SHARED_WOW_VDM              = 0x00001000;
const auto CREATE_FORCEDOS                    = 0x00002000;

const auto BELOW_NORMAL_PRIORITY_CLASS        = 0x00004000;
const auto ABOVE_NORMAL_PRIORITY_CLASS        = 0x00008000;

const auto STACK_SIZE_PARAM_IS_A_RESERVATION  = 0x00010000;
const auto INHERIT_CALLER_PRIORITY            = 0x00020000;

const auto CREATE_PROTECTED_PROCESS           = 0x00040000;

const auto EXTENDED_STARTUPINFO_PRESENT       = 0x00080000;

const auto PROCESS_MODE_BACKGROUND_BEGIN      = 0x00100000;
const auto PROCESS_MODE_BACKGROUND_END        = 0x00200000;

const auto CREATE_BREAKAWAY_FROM_JOB          = 0x01000000;
const auto CREATE_PRESERVE_CODE_AUTHZ_LEVEL   = 0x02000000;

const auto CREATE_DEFAULT_ERROR_MODE          = 0x04000000;

const auto CREATE_NO_WINDOW                   = 0x08000000;

const auto PROFILE_USER                       = 0x10000000;
const auto PROFILE_KERNEL                     = 0x20000000;
const auto PROFILE_SERVER                     = 0x40000000;

const auto CREATE_IGNORE_SYSTEM_DEFAULT       = 0x80000000;

const auto THREAD_PRIORITY_LOWEST           = THREAD_BASE_PRIORITY_MIN;
const auto THREAD_PRIORITY_BELOW_NORMAL     = (THREAD_PRIORITY_LOWEST+1);
const auto THREAD_PRIORITY_NORMAL           = 0;
const auto THREAD_PRIORITY_HIGHEST          = THREAD_BASE_PRIORITY_MAX;
const auto THREAD_PRIORITY_ABOVE_NORMAL     = (THREAD_PRIORITY_HIGHEST-1);
const auto THREAD_PRIORITY_ERROR_RETURN     = (MAXLONG);

const auto THREAD_PRIORITY_TIME_CRITICAL    = THREAD_BASE_PRIORITY_LOWRT;
const auto THREAD_PRIORITY_IDLE             = THREAD_BASE_PRIORITY_IDLE;

const auto THREAD_MODE_BACKGROUND_BEGIN     = 0x00010000;
const auto THREAD_MODE_BACKGROUND_END       = 0x00020000;

//
// GetFinalPathNameByHandle
//

const auto VOLUME_NAME_DOS   = 0x0      ; //default
const auto VOLUME_NAME_GUID  = 0x1;
const auto VOLUME_NAME_NT    = 0x2;
const auto VOLUME_NAME_NONE  = 0x4;

const auto FILE_NAME_NORMALIZED  = 0x0  ; //default
const auto FILE_NAME_OPENED      = 0x8;

//
// Debug APIs
//
const auto EXCEPTION_DEBUG_EVENT        = 1;
const auto CREATE_THREAD_DEBUG_EVENT    = 2;
const auto CREATE_PROCESS_DEBUG_EVENT   = 3;
const auto EXIT_THREAD_DEBUG_EVENT      = 4;
const auto EXIT_PROCESS_DEBUG_EVENT     = 5;
const auto LOAD_DLL_DEBUG_EVENT         = 6;
const auto UNLOAD_DLL_DEBUG_EVENT       = 7;
const auto OUTPUT_DEBUG_STRING_EVENT    = 8;
const auto RIP_EVENT                    = 9;

struct EXCEPTION_DEBUG_INFO {
    EXCEPTION_RECORD ExceptionRecord;
    DWORD dwFirstChance;
}

typedef EXCEPTION_DEBUG_INFO* LPEXCEPTION_DEBUG_INFO;

struct CREATE_THREAD_DEBUG_INFO {
    HANDLE hThread;
    LPVOID lpThreadLocalBase;
    LPTHREAD_START_ROUTINE lpStartAddress;
}

typedef CREATE_THREAD_DEBUG_INFO* LPCREATE_THREAD_DEBUG_INFO;

struct CREATE_PROCESS_DEBUG_INFO {
    HANDLE hFile;
    HANDLE hProcess;
    HANDLE hThread;
    LPVOID lpBaseOfImage;
    DWORD dwDebugInfoFileOffset;
    DWORD nDebugInfoSize;
    LPVOID lpThreadLocalBase;
    LPTHREAD_START_ROUTINE lpStartAddress;
    LPVOID lpImageName;
    WORD fUnicode;
}

typedef CREATE_PROCESS_DEBUG_INFO* LPCREATE_PROCESS_DEBUG_INFO;

struct EXIT_THREAD_DEBUG_INFO {
    DWORD dwExitCode;
}

typedef EXIT_THREAD_DEBUG_INFO* LPEXIT_THREAD_DEBUG_INFO;

struct EXIT_PROCESS_DEBUG_INFO {
    DWORD dwExitCode;
}

typedef EXIT_PROCESS_DEBUG_INFO* LPEXIT_PROCESS_DEBUG_INFO;

struct LOAD_DLL_DEBUG_INFO {
    HANDLE hFile;
    LPVOID lpBaseOfDll;
    DWORD dwDebugInfoFileOffset;
    DWORD nDebugInfoSize;
    LPVOID lpImageName;
    WORD fUnicode;
}

typedef LOAD_DLL_DEBUG_INFO* LPLOAD_DLL_DEBUG_INFO;

struct UNLOAD_DLL_DEBUG_INFO {
    LPVOID lpBaseOfDll;
}

typedef UNLOAD_DLL_DEBUG_INFO* LPUNLOAD_DLL_DEBUG_INFO;

struct OUTPUT_DEBUG_STRING_INFO {
    LPSTR lpDebugStringData;
    WORD fUnicode;
    WORD nDebugStringLength;
}

typedef OUTPUT_DEBUG_STRING_INFO* LPOUTPUT_DEBUG_STRING_INFO;

struct RIP_INFO {
    DWORD dwError;
    DWORD dwType;
}

typedef RIP_INFO* LPRIP_INFO;


struct DEBUG_EVENT {
    DWORD dwDebugEventCode;
    DWORD dwProcessId;
    DWORD dwThreadId;
    union {
        EXCEPTION_DEBUG_INFO Exception;
        CREATE_THREAD_DEBUG_INFO CreateThread;
        CREATE_PROCESS_DEBUG_INFO CreateProcessInfo;
        EXIT_THREAD_DEBUG_INFO ExitThread;
        EXIT_PROCESS_DEBUG_INFO ExitProcess;
        LOAD_DLL_DEBUG_INFO LoadDll;
        UNLOAD_DLL_DEBUG_INFO UnloadDll;
        OUTPUT_DEBUG_STRING_INFO DebugString;
        RIP_INFO RipInfo;
    } u;
}

typedef DEBUG_EVENT* LPDEBUG_EVENT;

//
// JIT Debugging Info. This structure is defined to have constant size in
// both the emulated and native environment.
//

struct JIT_DEBUG_INFO {
    DWORD dwSize;
    DWORD dwProcessorArchitecture;
    DWORD dwThreadID;
    DWORD dwReserved0;
    ULONG64 lpExceptionAddress;
    ULONG64 lpExceptionRecord;
    ULONG64 lpContextRecord;
}

typedef JIT_DEBUG_INFO* LPJIT_DEBUG_INFO;

typedef JIT_DEBUG_INFO JIT_DEBUG_INFO32, *LPJIT_DEBUG_INFO32;
typedef JIT_DEBUG_INFO JIT_DEBUG_INFO64, *LPJIT_DEBUG_INFO64;

#if !defined(MIDL_PASS)
typedef PCONTEXT LPCONTEXT;
typedef PEXCEPTION_RECORD LPEXCEPTION_RECORD;
typedef PEXCEPTION_POINTERS LPEXCEPTION_POINTERS;
#endif

const auto DRIVE_UNKNOWN      = 0;
const auto DRIVE_NO_ROOT_DIR  = 1;
const auto DRIVE_REMOVABLE    = 2;
const auto DRIVE_FIXED        = 3;
const auto DRIVE_REMOTE       = 4;
const auto DRIVE_CDROM        = 5;
const auto DRIVE_RAMDISK      = 6;


#ifndef _MAC
const auto GetFreeSpace(w)                  = (0x100000L);
#else
WINBASEAPI DWORD WINAPI GetFreeSpace(__in UINT);
#endif


const auto FILE_TYPE_UNKNOWN    = 0x0000;
const auto FILE_TYPE_DISK       = 0x0001;
const auto FILE_TYPE_CHAR       = 0x0002;
const auto FILE_TYPE_PIPE       = 0x0003;
const auto FILE_TYPE_REMOTE     = 0x8000;


const auto STD_INPUT_HANDLE     = ((DWORD)-10);
const auto STD_OUTPUT_HANDLE    = ((DWORD)-11);
const auto STD_ERROR_HANDLE     = ((DWORD)-12);

const auto NOPARITY             = 0;
const auto ODDPARITY            = 1;
const auto EVENPARITY           = 2;
const auto MARKPARITY           = 3;
const auto SPACEPARITY          = 4;

const auto ONESTOPBIT           = 0;
const auto ONE5STOPBITS         = 1;
const auto TWOSTOPBITS          = 2;

const auto IGNORE               = 0       ; // Ignore signal
const auto INFINITE             = 0xFFFFFFFF  ; // Infinite timeout

//
// Baud rates at which the communication device operates
//

const auto CBR_110              = 110;
const auto CBR_300              = 300;
const auto CBR_600              = 600;
const auto CBR_1200             = 1200;
const auto CBR_2400             = 2400;
const auto CBR_4800             = 4800;
const auto CBR_9600             = 9600;
const auto CBR_14400            = 14400;
const auto CBR_19200            = 19200;
const auto CBR_38400            = 38400;
const auto CBR_56000            = 56000;
const auto CBR_57600            = 57600;
const auto CBR_115200           = 115200;
const auto CBR_128000           = 128000;
const auto CBR_256000           = 256000;

//
// Error Flags
//

const auto CE_RXOVER            = 0x0001  ; // Receive Queue overflow
const auto CE_OVERRUN           = 0x0002  ; // Receive Overrun Error
const auto CE_RXPARITY          = 0x0004  ; // Receive Parity Error
const auto CE_FRAME             = 0x0008  ; // Receive Framing error
const auto CE_BREAK             = 0x0010  ; // Break Detected
const auto CE_TXFULL            = 0x0100  ; // TX Queue is full
const auto CE_PTO               = 0x0200  ; // LPTx Timeout
const auto CE_IOE               = 0x0400  ; // LPTx I/O Error
const auto CE_DNS               = 0x0800  ; // LPTx Device not selected
const auto CE_OOP               = 0x1000  ; // LPTx Out-Of-Paper
const auto CE_MODE              = 0x8000  ; // Requested mode unsupported

const auto IE_BADID             = (-1)    ; // Invalid or unsupported id
const auto IE_OPEN              = (-2)    ; // Device Already Open
const auto IE_NOPEN             = (-3)    ; // Device Not Open
const auto IE_MEMORY            = (-4)    ; // Unable to allocate queues
const auto IE_DEFAULT           = (-5)    ; // Error in default parameters
const auto IE_HARDWARE          = (-10)   ; // Hardware Not Present
const auto IE_BYTESIZE          = (-11)   ; // Illegal Byte Size
const auto IE_BAUDRATE          = (-12)   ; // Unsupported BaudRate

//
// Events
//

const auto EV_RXCHAR            = 0x0001  ; // Any Character received
const auto EV_RXFLAG            = 0x0002  ; // Received certain character
const auto EV_TXEMPTY           = 0x0004  ; // Transmitt Queue Empty
const auto EV_CTS               = 0x0008  ; // CTS changed state
const auto EV_DSR               = 0x0010  ; // DSR changed state
const auto EV_RLSD              = 0x0020  ; // RLSD changed state
const auto EV_BREAK             = 0x0040  ; // BREAK received
const auto EV_ERR               = 0x0080  ; // Line status error occurred
const auto EV_RING              = 0x0100  ; // Ring signal detected
const auto EV_PERR              = 0x0200  ; // Printer error occured
const auto EV_RX80FULL          = 0x0400  ; // Receive buffer is 80 percent full
const auto EV_EVENT1            = 0x0800  ; // Provider specific event 1
const auto EV_EVENT2            = 0x1000  ; // Provider specific event 2

//
// Escape Functions
//

const auto SETXOFF              = 1       ; // Simulate XOFF received
const auto SETXON               = 2       ; // Simulate XON received
const auto SETRTS               = 3       ; // Set RTS high
const auto CLRRTS               = 4       ; // Set RTS low
const auto SETDTR               = 5       ; // Set DTR high
const auto CLRDTR               = 6       ; // Set DTR low
const auto RESETDEV             = 7       ; // Reset device if possible
const auto SETBREAK             = 8       ; // Set the device break line.
const auto CLRBREAK             = 9       ; // Clear the device break line.

//
// PURGE function flags.
//
const auto PURGE_TXABORT        = 0x0001  ; // Kill the pending/current writes to the comm port.
const auto PURGE_RXABORT        = 0x0002  ; // Kill the pending/current reads to the comm port.
const auto PURGE_TXCLEAR        = 0x0004  ; // Kill the transmit queue if there.
const auto PURGE_RXCLEAR        = 0x0008  ; // Kill the typeahead buffer if there.

const auto LPTx                 = 0x80    ; // Set if ID is for LPT device

//
// Modem Status Flags
//
const auto MS_CTS_ON            = ((DWORD)0x0010);
const auto MS_DSR_ON            = ((DWORD)0x0020);
const auto MS_RING_ON           = ((DWORD)0x0040);
const auto MS_RLSD_ON           = ((DWORD)0x0080);

//
// WaitSoundState() Constants
//

const auto S_QUEUEEMPTY         = 0;
const auto S_THRESHOLD          = 1;
const auto S_ALLTHRESHOLD       = 2;

//
// Accent Modes
//

const auto S_NORMAL       = 0;
const auto S_LEGATO       = 1;
const auto S_STACCATO     = 2;

//
// SetSoundNoise() Sources
//

const auto S_PERIOD512    = 0     ; // Freq = N/512 high pitch, less coarse hiss
const auto S_PERIOD1024   = 1     ; // Freq = N/1024
const auto S_PERIOD2048   = 2     ; // Freq = N/2048 low pitch, more coarse hiss
const auto S_PERIODVOICE  = 3     ; // Source is frequency from voice channel (3)
const auto S_WHITE512     = 4     ; // Freq = N/512 high pitch, less coarse hiss
const auto S_WHITE1024    = 5     ; // Freq = N/1024
const auto S_WHITE2048    = 6     ; // Freq = N/2048 low pitch, more coarse hiss
const auto S_WHITEVOICE   = 7     ; // Source is frequency from voice channel (3)

const auto S_SERDVNA      = (-1)  ; // Device not available
const auto S_SEROFM       = (-2)  ; // Out of memory
const auto S_SERMACT      = (-3)  ; // Music active
const auto S_SERQFUL      = (-4)  ; // Queue full
const auto S_SERBDNT      = (-5)  ; // Invalid note
const auto S_SERDLN       = (-6)  ; // Invalid note length
const auto S_SERDCC       = (-7)  ; // Invalid note count
const auto S_SERDTP       = (-8)  ; // Invalid tempo
const auto S_SERDVL       = (-9)  ; // Invalid volume
const auto S_SERDMD       = (-10) ; // Invalid mode
const auto S_SERDSH       = (-11) ; // Invalid shape
const auto S_SERDPT       = (-12) ; // Invalid pitch
const auto S_SERDFQ       = (-13) ; // Invalid frequency
const auto S_SERDDR       = (-14) ; // Invalid duration
const auto S_SERDSR       = (-15) ; // Invalid source
const auto S_SERDST       = (-16) ; // Invalid state

const auto NMPWAIT_WAIT_FOREVER             = 0xffffffff;
const auto NMPWAIT_NOWAIT                   = 0x00000001;
const auto NMPWAIT_USE_DEFAULT_WAIT         = 0x00000000;

const auto FS_CASE_IS_PRESERVED             = FILE_CASE_PRESERVED_NAMES;
const auto FS_CASE_SENSITIVE                = FILE_CASE_SENSITIVE_SEARCH;
const auto FS_UNICODE_STORED_ON_DISK        = FILE_UNICODE_ON_DISK;
const auto FS_PERSISTENT_ACLS               = FILE_PERSISTENT_ACLS;
const auto FS_VOL_IS_COMPRESSED             = FILE_VOLUME_IS_COMPRESSED;
const auto FS_FILE_COMPRESSION              = FILE_FILE_COMPRESSION;
const auto FS_FILE_ENCRYPTION               = FILE_SUPPORTS_ENCRYPTION;

const auto FILE_MAP_COPY        = SECTION_QUERY;
const auto FILE_MAP_WRITE       = SECTION_MAP_WRITE;
const auto FILE_MAP_READ        = SECTION_MAP_READ;
const auto FILE_MAP_ALL_ACCESS  = SECTION_ALL_ACCESS;
const auto FILE_MAP_EXECUTE     = SECTION_MAP_EXECUTE_EXPLICIT    ; // not included in FILE_MAP_ALL_ACCESS

const auto OF_READ              = 0x00000000;
const auto OF_WRITE             = 0x00000001;
const auto OF_READWRITE         = 0x00000002;
const auto OF_SHARE_COMPAT      = 0x00000000;
const auto OF_SHARE_EXCLUSIVE   = 0x00000010;
const auto OF_SHARE_DENY_WRITE  = 0x00000020;
const auto OF_SHARE_DENY_READ   = 0x00000030;
const auto OF_SHARE_DENY_NONE   = 0x00000040;
const auto OF_PARSE             = 0x00000100;
const auto OF_DELETE            = 0x00000200;
const auto OF_VERIFY            = 0x00000400;
const auto OF_CANCEL            = 0x00000800;
const auto OF_CREATE            = 0x00001000;
const auto OF_PROMPT            = 0x00002000;
const auto OF_EXIST             = 0x00004000;
const auto OF_REOPEN            = 0x00008000;

const auto OFS_MAXPATHNAME  = 128;
struct OFSTRUCT {
    BYTE cBytes;
    BYTE fFixedDisk;
    WORD nErrCode;
    WORD Reserved1;
    WORD Reserved2;
    CHAR szPathName[OFS_MAXPATHNAME];
}

typedef OFSTRUCT* LPOFSTRUCT;
typedef OFSTRUCT* POFSTRUCT;

#ifndef NOWINBASEINTERLOCK

#ifndef _NTOS_

#if defined(_M_IA64) && !defined(RC_INVOKED)

const auto InterlockedIncrement  = _InterlockedIncrement;
const auto InterlockedIncrementAcquire  = _InterlockedIncrement_acq;
const auto InterlockedIncrementRelease  = _InterlockedIncrement_rel;
const auto InterlockedDecrement  = _InterlockedDecrement;
const auto InterlockedDecrementAcquire  = _InterlockedDecrement_acq;
const auto InterlockedDecrementRelease  = _InterlockedDecrement_rel;
const auto InterlockedExchange  = _InterlockedExchange;
const auto InterlockedExchangeAdd  = _InterlockedExchangeAdd;
const auto InterlockedCompareExchange  = _InterlockedCompareExchange;
const auto InterlockedCompareExchangeAcquire  = _InterlockedCompareExchange_acq;
const auto InterlockedCompareExchangeRelease  = _InterlockedCompareExchange_rel;
const auto InterlockedExchangePointer  = _InterlockedExchangePointer;
const auto InterlockedCompareExchangePointer  = _InterlockedCompareExchangePointer;
const auto InterlockedCompareExchangePointerRelease  = _InterlockedCompareExchangePointer_rel;
const auto InterlockedCompareExchangePointerAcquire  = _InterlockedCompareExchangePointer_acq;

const auto InterlockedIncrement64  = _InterlockedIncrement64;
const auto InterlockedDecrement64  = _InterlockedDecrement64;
const auto InterlockedExchange64  = _InterlockedExchange64;
const auto InterlockedExchangeAcquire64  = _InterlockedExchange64_acq;
const auto InterlockedExchangeAdd64  = _InterlockedExchangeAdd64;
const auto InterlockedCompareExchange64  = _InterlockedCompareExchange64;
const auto InterlockedCompareExchangeAcquire64  = _InterlockedCompareExchange64_acq;
const auto InterlockedCompareExchangeRelease64  = _InterlockedCompareExchange64_rel;
const auto InterlockedCompare64Exchange128      = _InterlockedCompare64Exchange128;
const auto InterlockedCompare64ExchangeAcquire128   = _InterlockedCompare64Exchange128_acq;
const auto InterlockedCompare64ExchangeRelease128   = _InterlockedCompare64Exchange128_rel;

const auto InterlockedOr  = _InterlockedOr;
const auto InterlockedOrAcquire  = _InterlockedOr_acq;
const auto InterlockedOrRelease  = _InterlockedOr_rel;
const auto InterlockedOr8  = _InterlockedOr8;
const auto InterlockedOr8Acquire  = _InterlockedOr8_acq;
const auto InterlockedOr8Release  = _InterlockedOr8_rel;
const auto InterlockedOr16  = _InterlockedOr16;
const auto InterlockedOr16Acquire  = _InterlockedOr16_acq;
const auto InterlockedOr16Release  = _InterlockedOr16_rel;
const auto InterlockedOr64  = _InterlockedOr64;
const auto InterlockedOr64Acquire  = _InterlockedOr64_acq;
const auto InterlockedOr64Release  = _InterlockedOr64_rel;
const auto InterlockedXor  = _InterlockedXor;
const auto InterlockedXorAcquire  = _InterlockedXor_acq;
const auto InterlockedXorRelease  = _InterlockedXor_rel;
const auto InterlockedXor8  = _InterlockedXor8;
const auto InterlockedXor8Acquire  = _InterlockedXor8_acq;
const auto InterlockedXor8Release  = _InterlockedXor8_rel;
const auto InterlockedXor16  = _InterlockedXor16;
const auto InterlockedXor16Acquire  = _InterlockedXor16_acq;
const auto InterlockedXor16Release  = _InterlockedXor16_rel;
const auto InterlockedXor64  = _InterlockedXor64;
const auto InterlockedXor64Acquire  = _InterlockedXor64_acq;
const auto InterlockedXor64Release  = _InterlockedXor64_rel;
const auto InterlockedAnd  = _InterlockedAnd;
const auto InterlockedAndAcquire  = _InterlockedAnd_acq;
const auto InterlockedAndRelease  = _InterlockedAnd_rel;
const auto InterlockedAnd8  = _InterlockedAnd8;
const auto InterlockedAnd8Acquire  = _InterlockedAnd8_acq;
const auto InterlockedAnd8Release  = _InterlockedAnd8_rel;
const auto InterlockedAnd16  = _InterlockedAnd16;
const auto InterlockedAnd16Acquire  = _InterlockedAnd16_acq;
const auto InterlockedAnd16Release  = _InterlockedAnd16_rel;
const auto InterlockedAnd64  = _InterlockedAnd64;
const auto InterlockedAnd64Acquire  = _InterlockedAnd64_acq;
const auto InterlockedAnd64Release  = _InterlockedAnd64_rel;

LONG
__cdecl
InterlockedOr (
    __inout LONG volatile *Destination,
    __in    LONG Value
    );

LONG
__cdecl
InterlockedOrAcquire (
    __inout LONG volatile *Destination,
    __in    LONG Value
    );

LONG
__cdecl
InterlockedOrRelease (
    __inout LONG volatile *Destination,
    __in    LONG Value
    );

char
__cdecl
InterlockedOr8 (
    __inout char volatile *Destination,
    __in    char Value
    );

char
__cdecl
InterlockedOr8Acquire (
    __inout char volatile *Destination,
    __in    char Value
    );

char
__cdecl
InterlockedOr8Release (
    __inout char volatile *Destination,
    __in    char Value
    );

SHORT
__cdecl
InterlockedOr16(
    __inout SHORT volatile *Destination,
    __in    SHORT Value
    );

SHORT
__cdecl
InterlockedOr16Acquire (
    __inout SHORT volatile *Destination,
    __in    SHORT Value
    );

SHORT
__cdecl
InterlockedOr16Release (
    __inout SHORT volatile *Destination,
    __in    SHORT Value
    );

LONGLONG
__cdecl
InterlockedOr64 (
    __inout LONGLONG volatile *Destination,
    __in    LONGLONG Value
    );

LONGLONG
__cdecl
InterlockedOr64Acquire (
    __inout LONGLONG volatile *Destination,
    __in    LONGLONG Value
    );

LONGLONG
__cdecl
InterlockedOr64Release (
    __inout LONGLONG volatile *Destination,
    __in    LONGLONG Value
    );

LONG
__cdecl
InterlockedXor (
    __inout LONG volatile *Destination,
    __in    LONG Value
    );

LONG
__cdecl
InterlockedXorAcquire (
    __inout LONG volatile *Destination,
    __in    LONG Value
    );

LONG
__cdecl
InterlockedXorRelease (
    __inout LONG volatile *Destination,
    __in    LONG Value
    );

char
__cdecl
InterlockedXor8 (
    __inout char volatile *Destination,
    __in    char Value
    );

char
__cdecl
InterlockedXor8Acquire (
    __inout char volatile *Destination,
    __in    char Value
    );

char
__cdecl
InterlockedXor8Release (
    __inout char volatile *Destination,
    __in    char Value
    );

SHORT
__cdecl
InterlockedXor16(
    __inout SHORT volatile *Destination,
    __in    SHORT Value
    );

SHORT
__cdecl
InterlockedXor16Acquire (
    __inout SHORT volatile *Destination,
    __in    SHORT Value
    );

SHORT
__cdecl
InterlockedXor16Release (
    __inout SHORT volatile *Destination,
    __in    SHORT Value
    );

LONGLONG
__cdecl
InterlockedXor64 (
    __inout LONGLONG volatile *Destination,
    __in    LONGLONG Value
    );

LONGLONG
__cdecl
InterlockedXor64Acquire (
    __inout LONGLONG volatile *Destination,
    __in    LONGLONG Value
    );

LONGLONG
__cdecl
InterlockedXor64Release (
    __inout LONGLONG volatile *Destination,
    __in    LONGLONG Value
    );

LONG
__cdecl
InterlockedAnd (
    __inout LONG volatile *Destination,
    __in    LONG Value
    );

LONG
__cdecl
InterlockedAndAcquire (
    __inout LONG volatile *Destination,
    __in    LONG Value
    );

LONG
__cdecl
InterlockedAndRelease (
    __inout LONG volatile *Destination,
    __in    LONG Value
    );

char
__cdecl
InterlockedAnd8 (
    __inout char volatile *Destination,
    __in    char Value
    );

char
__cdecl
InterlockedAnd8Acquire (
    __inout char volatile *Destination,
    __in    char Value
    );

char
__cdecl
InterlockedAnd8Release (
    __inout char volatile *Destination,
    __in    char Value
    );

SHORT
__cdecl
InterlockedAnd16(
    __inout SHORT volatile *Destination,
    __in    SHORT Value
    );

SHORT
__cdecl
InterlockedAnd16Acquire (
    __inout SHORT volatile *Destination,
    __in    SHORT Value
    );

SHORT
__cdecl
InterlockedAnd16Release (
    __inout SHORT volatile *Destination,
    __in    SHORT Value
    );

LONGLONG
__cdecl
InterlockedAnd64 (
    __inout LONGLONG volatile *Destination,
    __in    LONGLONG Value
    );

LONGLONG
__cdecl
InterlockedAnd64Acquire (
    __inout LONGLONG volatile *Destination,
    __in    LONGLONG Value
    );

LONGLONG
__cdecl
InterlockedAnd64Release (
    __inout LONGLONG volatile *Destination,
    __in    LONGLONG Value
    );

LONGLONG
__cdecl
InterlockedIncrement64 (
    __inout LONGLONG volatile *Addend
    );

LONGLONG
__cdecl
InterlockedDecrement64 (
    __inout LONGLONG volatile *Addend
    );

LONG
__cdecl
InterlockedIncrementAcquire (
    __inout LONG volatile *Addend
    );

LONG
__cdecl
InterlockedDecrementAcquire (
    __inout LONG volatile *Addend
    );

LONG
__cdecl
InterlockedIncrementRelease (
    __inout LONG volatile *Addend
    );

LONG
__cdecl
InterlockedDecrementRelease (
    __inout LONG volatile *Addend
    );

LONGLONG
__cdecl
InterlockedExchange64 (
    __inout LONGLONG volatile *Target,
    __in    LONGLONG Value
    );

LONGLONG
__cdecl
InterlockedExchangeAcquire64 (
    __inout LONGLONG volatile *Target,
    __in    LONGLONG Value
    );

LONGLONG
__cdecl
InterlockedExchangeAdd64 (
    __inout LONGLONG volatile *Addend,
    __in    LONGLONG Value
    );

LONGLONG
__cdecl
InterlockedCompareExchange64 (
    __inout LONGLONG volatile *Destination,
    __in    LONGLONG ExChange,
    __in    LONGLONG Comperand
    );

LONGLONG
__cdecl
InterlockedCompareExchangeAcquire64 (
    __inout LONGLONG volatile *Destination,
    __in    LONGLONG ExChange,
    __in    LONGLONG Comperand
    );

LONGLONG
__cdecl
InterlockedCompareExchangeRelease64 (
    __inout LONGLONG volatile *Destination,
    __in    LONGLONG ExChange,
    __in    LONGLONG Comperand
    );

LONG64
__cdecl
InterlockedCompare64Exchange128(
    __inout LONG64 volatile * Destination,
    __in LONG64 ExchangeHigh,
    __in LONG64 ExchangeLow,
    __in LONG64 Comperand
    );

LONG64
__cdecl
InterlockedCompare64ExchangeAcquire128(
    __inout LONG64 volatile * Destination,
    __in LONG64 ExchangeHigh,
    __in LONG64 ExchangeLow,
    __in LONG64 Comperand
    );

LONG64
__cdecl
InterlockedCompare64ExchangeRelease128(
    __inout LONG64 volatile * Destination,
    __in LONG64 ExchangeHigh,
    __in LONG64 ExchangeLow,
    __in LONG64 Comperand
    );

LONG
__cdecl
InterlockedIncrement (
    __inout LONG volatile *lpAddend
    );

LONG
__cdecl
InterlockedDecrement (
    __inout LONG volatile *lpAddend
    );

LONG
__cdecl
InterlockedExchange (
    __inout LONG volatile *Target,
    __in    LONG Value
    );

LONG
__cdecl
InterlockedExchangeAdd (
    __inout LONG volatile *Addend,
    __in    LONG Value
    );

LONG
__cdecl
InterlockedCompareExchange (
    __inout LONG volatile *Destination,
    __in    LONG ExChange,
    __in    LONG Comperand
    );

LONG
__cdecl
InterlockedCompareExchangeRelease (
    __inout LONG volatile *Destination,
    __in    LONG ExChange,
    __in    LONG Comperand
    );

LONG
__cdecl
InterlockedCompareExchangeAcquire (
    __inout LONG volatile *Destination,
    __in    LONG ExChange,
    __in    LONG Comperand
    );

PVOID
__cdecl
InterlockedExchangePointer (
    __inout  PVOID volatile *Target,
    __in_opt PVOID Value
    );

PVOID
__cdecl
InterlockedCompareExchangePointer (
    __inout  PVOID volatile *Destination,
    __in_opt PVOID ExChange,
    __in_opt PVOID Comperand
    );

PVOID
__cdecl
InterlockedCompareExchangePointerAcquire (
    __inout  PVOID volatile *Destination,
    __in_opt PVOID Exchange,
    __in_opt PVOID Comperand
    );

PVOID
__cdecl
InterlockedCompareExchangePointerRelease (
    __inout  PVOID volatile *Destination,
    __in_opt PVOID Exchange,
    __in_opt PVOID Comperand
    );


#if !defined(MIDL_PASS)

#if !defined (InterlockedAnd)

const auto InterlockedAnd  = InterlockedAnd_Inline;

FORCEINLINE
LONG
InterlockedAnd_Inline (
    __inout LONG volatile *Target,
    __in    LONG Set
    )
{
    LONG i;
    LONG j;

    j = *Target;
    do {
        i = j;
        j = InterlockedCompareExchange(Target,
                                       i & Set,
                                       i);

    } while (i != j);

    return j;
}

#endif

#if !defined (InterlockedOr)

const auto InterlockedOr  = InterlockedOr_Inline;

FORCEINLINE
LONG
InterlockedOr_Inline (
    __inout LONG volatile *Target,
    __in    LONG Set
    )
{
    LONG i;
    LONG j;

    j = *Target;
    do {
        i = j;
        j = InterlockedCompareExchange(Target,
                                       i | Set,
                                       i);

    } while (i != j);

    return j;
}

#endif

#if !defined (InterlockedXor)

const auto InterlockedXor  = InterlockedXor_Inline;

FORCEINLINE
LONG
InterlockedXor_Inline (
    __inout LONG volatile *Target,
    __in    LONG Set
    )
{
    LONG i;
    LONG j;

    j = *Target;
    do {
        i = j;
        j = InterlockedCompareExchange(Target,
                                       i ^ Set,
                                       i);

    } while (i != j);

    return j;
}

#endif

#if !defined (InterlockedAnd64)

const auto InterlockedAnd64  = InterlockedAnd64_Inline;

FORCEINLINE
LONGLONG
InterlockedAnd64_Inline (
    __inout LONGLONG volatile *Destination,
    __in    LONGLONG Value
    )
{
    LONGLONG Old;

    do {
        Old = *Destination;
    } while (InterlockedCompareExchange64(Destination,
                                          Old & Value,
                                          Old) != Old);

    return Old;
}

#endif

#if !defined (InterlockedOr64)

const auto InterlockedOr64  = InterlockedOr64_Inline;

FORCEINLINE
LONGLONG
InterlockedOr64_Inline (
    __inout LONGLONG volatile *Destination,
    __in    LONGLONG Value
    )
{
    LONGLONG Old;

    do {
        Old = *Destination;
    } while (InterlockedCompareExchange64(Destination,
                                          Old | Value,
                                          Old) != Old);

    return Old;
}

#endif

#if !defined (InterlockedXor64)

const auto InterlockedXor64  = InterlockedXor64_Inline;

FORCEINLINE
LONGLONG
InterlockedXor64_Inline (
    __inout LONGLONG volatile *Destination,
    __in    LONGLONG Value
    )
{
    LONGLONG Old;

    do {
        Old = *Destination;
    } while (InterlockedCompareExchange64(Destination,
                                          Old ^ Value,
                                          Old) != Old);

    return Old;
}

#endif

#if !defined (InterlockedBitTestAndSet)

const auto InterlockedBitTestAndSet  = InterlockedBitTestAndSet_Inline;

FORCEINLINE
BOOLEAN
InterlockedBitTestAndSet_Inline (
    __inout LONG volatile *Base,
    __in LONG Bit
    )
{
    LONG tBit;

    tBit = 1<<(Bit & (sizeof (*Base)*8-1));
    return (BOOLEAN)((InterlockedOr(&Base[Bit/(sizeof(*Base)*8)], tBit)&tBit) != 0);
}

#endif

#if !defined (InterlockedBitTestAndReset)

const auto InterlockedBitTestAndReset  = InterlockedBitTestAndReset_Inline;

FORCEINLINE
BOOLEAN
InterlockedBitTestAndReset_Inline (
    __inout LONG volatile *Base,
    __in LONG Bit
    )
{
    LONG tBit;

    tBit = 1<<(Bit & (sizeof (*Base)*8-1));
    return (BOOLEAN)((InterlockedAnd(&Base[Bit/(sizeof(*Base)*8)], ~tBit)&tBit) != 0);
}

#endif

#if !defined (InterlockedBitTestAndComplement)

const auto InterlockedBitTestAndComplement  = InterlockedBitTestAndComplement_Inline;

FORCEINLINE
BOOLEAN
InterlockedBitTestAndComplement_Inline (
    __inout LONG volatile *Base,
    __in LONG Bit
    )
{
    LONG tBit;

    tBit = 1<<(Bit & (sizeof (*Base)*8-1));
    return (BOOLEAN)((InterlockedXor(&Base[Bit/(sizeof(*Base)*8)], tBit)&tBit) != 0);
}

#endif
#endif

#pragma intrinsic(_InterlockedIncrement)
#pragma intrinsic(_InterlockedIncrement_acq)
#pragma intrinsic(_InterlockedIncrement_rel)
#pragma intrinsic(_InterlockedDecrement)
#pragma intrinsic(_InterlockedDecrement_acq)
#pragma intrinsic(_InterlockedDecrement_rel)
#pragma intrinsic(_InterlockedExchange)
#pragma intrinsic(_InterlockedExchangeAdd)
#pragma intrinsic(_InterlockedCompareExchange)
#pragma intrinsic(_InterlockedCompareExchange_acq)
#pragma intrinsic(_InterlockedCompareExchange_rel)
#pragma intrinsic(_InterlockedExchangePointer)
#pragma intrinsic(_InterlockedCompareExchangePointer)
#pragma intrinsic(_InterlockedCompareExchangePointer_acq)
#pragma intrinsic(_InterlockedCompareExchangePointer_rel)
#pragma intrinsic(_InterlockedIncrement64)
#pragma intrinsic(_InterlockedDecrement64)
#pragma intrinsic(_InterlockedExchange64)
#pragma intrinsic(_InterlockedExchange64_acq)
#pragma intrinsic(_InterlockedCompareExchange64)
#pragma intrinsic(_InterlockedCompareExchange64_acq)
#pragma intrinsic(_InterlockedCompareExchange64_rel)
#pragma intrinsic(_InterlockedExchangeAdd64)
#pragma intrinsic (_InterlockedOr)
#pragma intrinsic (_InterlockedOr_acq)
#pragma intrinsic (_InterlockedOr_rel)
#pragma intrinsic (_InterlockedOr8)
#pragma intrinsic (_InterlockedOr8_acq)
#pragma intrinsic (_InterlockedOr8_rel)
#pragma intrinsic (_InterlockedOr16)
#pragma intrinsic (_InterlockedOr16_acq)
#pragma intrinsic (_InterlockedOr16_rel)
#pragma intrinsic (_InterlockedOr64)
#pragma intrinsic (_InterlockedOr64_acq)
#pragma intrinsic (_InterlockedOr64_rel)
#pragma intrinsic (_InterlockedXor)
#pragma intrinsic (_InterlockedXor_acq)
#pragma intrinsic (_InterlockedXor_rel)
#pragma intrinsic (_InterlockedXor8)
#pragma intrinsic (_InterlockedXor8_acq)
#pragma intrinsic (_InterlockedXor8_rel)
#pragma intrinsic (_InterlockedXor16)
#pragma intrinsic (_InterlockedXor16_acq)
#pragma intrinsic (_InterlockedXor16_rel)
#pragma intrinsic (_InterlockedXor64)
#pragma intrinsic (_InterlockedXor64_acq)
#pragma intrinsic (_InterlockedXor64_rel)
#pragma intrinsic (_InterlockedAnd)
#pragma intrinsic (_InterlockedAnd_acq)
#pragma intrinsic (_InterlockedAnd_rel)
#pragma intrinsic (_InterlockedAnd8)
#pragma intrinsic (_InterlockedAnd8_acq)
#pragma intrinsic (_InterlockedAnd8_rel)
#pragma intrinsic (_InterlockedAnd16)
#pragma intrinsic (_InterlockedAnd16_acq)
#pragma intrinsic (_InterlockedAnd16_rel)
#pragma intrinsic (_InterlockedAnd64)
#pragma intrinsic (_InterlockedAnd64_acq)
#pragma intrinsic (_InterlockedAnd64_rel)

#elif defined(_M_AMD64) && !defined(RC_INVOKED)

const auto InterlockedAnd  = _InterlockedAnd;
const auto InterlockedOr  = _InterlockedOr;
const auto InterlockedXor  = _InterlockedXor;
const auto InterlockedIncrement  = _InterlockedIncrement;
const auto InterlockedIncrementAcquire  = InterlockedIncrement;
const auto InterlockedIncrementRelease  = InterlockedIncrement;
const auto InterlockedDecrement  = _InterlockedDecrement;
const auto InterlockedDecrementAcquire  = InterlockedDecrement;
const auto InterlockedDecrementRelease  = InterlockedDecrement;
const auto InterlockedExchange  = _InterlockedExchange;
const auto InterlockedExchangeAdd  = _InterlockedExchangeAdd;
const auto InterlockedCompareExchange  = _InterlockedCompareExchange;
const auto InterlockedCompareExchangeAcquire  = InterlockedCompareExchange;
const auto InterlockedCompareExchangeRelease  = InterlockedCompareExchange;
const auto InterlockedExchangePointer  = _InterlockedExchangePointer;
const auto InterlockedCompareExchangePointer  = _InterlockedCompareExchangePointer;
const auto InterlockedCompareExchangePointerAcquire  = _InterlockedCompareExchangePointer;
const auto InterlockedCompareExchangePointerRelease  = _InterlockedCompareExchangePointer;

const auto InterlockedAnd64  = _InterlockedAnd64;
const auto InterlockedOr64  = _InterlockedOr64;
const auto InterlockedXor64  = _InterlockedXor64;
const auto InterlockedIncrement64  = _InterlockedIncrement64;
const auto InterlockedDecrement64  = _InterlockedDecrement64;
const auto InterlockedExchange64  = _InterlockedExchange64;
const auto InterlockedExchangeAdd64  = _InterlockedExchangeAdd64;
const auto InterlockedCompareExchange64  = _InterlockedCompareExchange64;
const auto InterlockedCompareExchangeAcquire64  = InterlockedCompareExchange64;
const auto InterlockedCompareExchangeRelease64  = InterlockedCompareExchange64;


LONG
InterlockedAnd (
    __inout LONG volatile *Destination,
    __in LONG Value
    );

LONG
InterlockedOr (
    __inout LONG volatile *Destination,
    __in LONG Value
    );

LONG
InterlockedXor (
    __inout LONG volatile *Destination,
    __in LONG Value
    );

LONG
InterlockedIncrement (
    __inout LONG volatile *Addend
    );

LONG
InterlockedDecrement (
    __inout LONG volatile *Addend
    );

LONG
InterlockedExchange (
    __inout LONG volatile *Target,
    __in LONG Value
    );

LONG
InterlockedExchangeAdd (
    __inout LONG volatile *Addend,
    __in LONG Value
    );

LONG
InterlockedCompareExchange (
    __inout LONG volatile *Destination,
    __in LONG ExChange,
    __in LONG Comperand
    );

PVOID
InterlockedCompareExchangePointer (
    __inout  PVOID volatile *Destination,
    __in_opt PVOID Exchange,
    __in_opt PVOID Comperand
    );

PVOID
InterlockedExchangePointer (
    __inout  PVOID volatile *Target,
    __in_opt PVOID Value
    );

LONG64
InterlockedAnd64 (
    __inout LONG64 volatile *Destination,
    __in LONG64 Value
    );

LONG64
InterlockedOr64 (
    __inout LONG64 volatile *Destination,
    __in LONG64 Value
    );

LONG64
InterlockedXor64 (
    __inout LONG64 volatile *Destination,
    __in LONG64 Value
    );

LONG64
InterlockedIncrement64 (
    __inout LONG64 volatile *Addend
    );

LONG64
InterlockedDecrement64 (
    __inout LONG64 volatile *Addend
    );

LONG64
InterlockedExchange64 (
    __inout LONG64 volatile *Target,
    __in LONG64 Value
    );

LONG64
InterlockedExchangeAdd64 (
    __inout LONG64 volatile *Addend,
    __in LONG64 Value
    );

LONG64
InterlockedCompareExchange64 (
    __inout LONG64 volatile *Destination,
    __in LONG64 ExChange,
    __in LONG64 Comperand
    );

#pragma intrinsic(_InterlockedAnd)
#pragma intrinsic(_InterlockedOr)
#pragma intrinsic(_InterlockedXor)
#pragma intrinsic(_InterlockedIncrement)
#pragma intrinsic(_InterlockedDecrement)
#pragma intrinsic(_InterlockedExchange)
#pragma intrinsic(_InterlockedExchangeAdd)
#pragma intrinsic(_InterlockedCompareExchange)
#pragma intrinsic(_InterlockedExchangePointer)
#pragma intrinsic(_InterlockedCompareExchangePointer)
#pragma intrinsic(_InterlockedAnd64)
#pragma intrinsic(_InterlockedOr64)
#pragma intrinsic(_InterlockedXor64)
#pragma intrinsic(_InterlockedIncrement64)
#pragma intrinsic(_InterlockedDecrement64)
#pragma intrinsic(_InterlockedExchange64)
#pragma intrinsic(_InterlockedExchangeAdd64)
#pragma intrinsic(_InterlockedCompareExchange64)

#if _MSC_FULL_VER >= 140041204

const auto InterlockedAnd8  = _InterlockedAnd8;
const auto InterlockedOr8  = _InterlockedOr8;
const auto InterlockedXor8  = _InterlockedXor8;
const auto InterlockedAnd16  = _InterlockedAnd16;
const auto InterlockedOr16  = _InterlockedOr16;
const auto InterlockedXor16  = _InterlockedXor16;

char
InterlockedAnd8 (
    __inout char volatile *Destination,
    __in char Value
    );

char
InterlockedOr8 (
    __inout char volatile *Destination,
    __in char Value
    );

char
InterlockedXor8 (
    __inout char volatile *Destination,
    __in char Value
    );

SHORT
InterlockedAnd16(
    __inout SHORT volatile *Destination,
    __in SHORT Value
    );

SHORT
InterlockedOr16(
    __inout SHORT volatile *Destination,
    __in SHORT Value
    );

SHORT
InterlockedXor16(
    __inout SHORT volatile *Destination,
    __in SHORT Value
    );

#pragma intrinsic (_InterlockedAnd8)
#pragma intrinsic (_InterlockedOr8)
#pragma intrinsic (_InterlockedXor8)
#pragma intrinsic (_InterlockedAnd16)
#pragma intrinsic (_InterlockedOr16)
#pragma intrinsic (_InterlockedXor16)

#endif

#else           // X86 interlocked definitions

LONG
InterlockedIncrement (
    __inout LONG volatile *lpAddend
    );

LONG
InterlockedDecrement (
    __inout LONG volatile *lpAddend
    );

LONG
InterlockedExchange (
    __inout LONG volatile *Target,
    __in    LONG Value
    );

const auto InterlockedExchangePointer(Target,  = Value) \;
    (PVOID)InterlockedExchange((PLONG)(Target), (LONG)(Value))

LONG
InterlockedExchangeAdd (
    __inout LONG volatile *Addend,
    __in    LONG Value
    );

LONG
InterlockedCompareExchange (
    __inout LONG volatile *Destination,
    __in    LONG Exchange,
    __in    LONG Comperand
    );

#if (_WIN32_WINNT >= 0x0502)

LONGLONG
InterlockedCompareExchange64 (
    __inout LONGLONG volatile *Destination,
    __in    LONGLONG Exchange,
    __in    LONGLONG Comperand
    );

#endif

#if !defined(MIDL_PASS)

#if (_WIN32_WINNT >= 0x0502)

FORCEINLINE
LONGLONG
InterlockedAnd64 (
    __inout LONGLONG volatile *Destination,
    __in    LONGLONG Value
    )
{
    LONGLONG Old;

    do {
        Old = *Destination;
    } while (InterlockedCompareExchange64(Destination,
                                          Old & Value,
                                          Old) != Old);

    return Old;
}

FORCEINLINE
LONGLONG
InterlockedOr64 (
    __inout LONGLONG volatile *Destination,
    __in    LONGLONG Value
    )
{
    LONGLONG Old;

    do {
        Old = *Destination;
    } while (InterlockedCompareExchange64(Destination,
                                          Old | Value,
                                          Old) != Old);

    return Old;
}

FORCEINLINE
LONGLONG
InterlockedXor64 (
    __inout LONGLONG volatile *Destination,
    __in    LONGLONG Value
    )
{
    LONGLONG Old;

    do {
        Old = *Destination;
    } while (InterlockedCompareExchange64(Destination,
                                          Old ^ Value,
                                          Old) != Old);

    return Old;
}

FORCEINLINE
LONGLONG
InterlockedIncrement64 (
    __inout LONGLONG volatile *Addend
    )
{
    LONGLONG Old;

    do {
        Old = *Addend;
    } while (InterlockedCompareExchange64(Addend,
                                          Old + 1,
                                          Old) != Old);

    return Old + 1;
}

FORCEINLINE
LONGLONG
InterlockedDecrement64 (
    __inout LONGLONG volatile *Addend
    )
{
    LONGLONG Old;

    do {
        Old = *Addend;
    } while (InterlockedCompareExchange64(Addend,
                                          Old - 1,
                                          Old) != Old);

    return Old - 1;
}

FORCEINLINE
LONGLONG
InterlockedExchange64 (
    __inout LONGLONG volatile *Target,
    __in    LONGLONG Value
    )
{
    LONGLONG Old;

    do {
        Old = *Target;
    } while (InterlockedCompareExchange64(Target,
                                          Value,
                                          Old) != Old);

    return Old;
}

FORCEINLINE
LONGLONG
InterlockedExchangeAdd64(
    __inout LONGLONG volatile *Addend,
    __in    LONGLONG Value
    )
{
    LONGLONG Old;

    do {
        Old = *Addend;
    } while (InterlockedCompareExchange64(Addend,
                                          Old + Value,
                                          Old) != Old);

    return Old;
}

#endif


#endif

//
// Use a function for C++ so X86 will generate the same errors as RISC.
//

#ifdef __cplusplus

FORCEINLINE
PVOID
#if !defined(_M_CEE_PURE)
__cdecl
#endif
__InlineInterlockedCompareExchangePointer (
    __inout  PVOID volatile *Destination,
    __in_opt PVOID ExChange,
    __in_opt PVOID Comperand
    )
{
    return((PVOID)(LONG_PTR)InterlockedCompareExchange((LONG volatile *)Destination, (LONG)(LONG_PTR)ExChange, (LONG)(LONG_PTR)Comperand));
}

const auto InterlockedCompareExchangePointer  = __InlineInterlockedCompareExchangePointer;

#else

const auto InterlockedCompareExchangePointer(Destination,  = ExChange, Comperand) \;
    (PVOID)(LONG_PTR)InterlockedCompareExchange((LONG volatile *)(Destination), (LONG)(LONG_PTR)(ExChange), (LONG)(LONG_PTR)(Comperand))

#endif /* __cplusplus */

const auto InterlockedIncrementAcquire  = InterlockedIncrement;
const auto InterlockedIncrementRelease  = InterlockedIncrement;
const auto InterlockedDecrementAcquire  = InterlockedDecrement;
const auto InterlockedDecrementRelease  = InterlockedDecrement;
const auto InterlockedIncrementAcquire  = InterlockedIncrement;
const auto InterlockedIncrementRelease  = InterlockedIncrement;
const auto InterlockedCompareExchangeAcquire  = InterlockedCompareExchange;
const auto InterlockedCompareExchangeRelease  = InterlockedCompareExchange;
const auto InterlockedCompareExchangeAcquire64  = InterlockedCompareExchange64;
const auto InterlockedCompareExchangeRelease64  = InterlockedCompareExchange64;
const auto InterlockedCompareExchangePointerAcquire  = InterlockedCompareExchangePointer;
const auto InterlockedCompareExchangePointerRelease  = InterlockedCompareExchangePointer;

#endif /* X86 | IA64 */

#if defined(_SLIST_HEADER_) && !defined(_NTOSP_)

VOID
InitializeSListHead (
    __inout PSLIST_HEADER ListHead
    );

PSLIST_ENTRY
InterlockedPopEntrySList (
    __inout PSLIST_HEADER ListHead
    );

PSLIST_ENTRY
InterlockedPushEntrySList (
    __inout PSLIST_HEADER ListHead,
    __inout PSLIST_ENTRY ListEntry
    );

PSLIST_ENTRY
InterlockedFlushSList (
    __inout PSLIST_HEADER ListHead
    );

USHORT
QueryDepthSList (
    __in PSLIST_HEADER ListHead
    );

#endif /* _SLIST_HEADER_ */

#endif /* _NTOS_ */

#endif /* NOWINBASEINTERLOCK */

BOOL
FreeResource(
    __in HGLOBAL hResData
    );

LPVOID
LockResource(
    __in HGLOBAL hResData
    );

const auto UnlockResource(hResData)  = ((hResData), 0);
const auto MAXINTATOM  = 0xC000;
const auto MAKEINTATOM(i)   = (LPTSTR)((ULONG_PTR)((WORD)(i)));
const auto INVALID_ATOM  = ((ATOM)0);

int
#if !defined(_MAC)
#if defined(_M_CEE_PURE)
__clrcall
#else
#endif
#else
CALLBACK
#endif
WinMain (
    __in HINSTANCE hInstance,
    __in_opt HINSTANCE hPrevInstance,
    __in_opt LPSTR lpCmdLine,
    __in int nShowCmd
    );

int
#if defined(_M_CEE_PURE)
__clrcall
#else
#endif
wWinMain(
    __in HINSTANCE hInstance,
    __in_opt HINSTANCE hPrevInstance,
    __in_opt LPWSTR lpCmdLine,
    __in int nShowCmd
    );

BOOL
FreeLibrary (
    __in HMODULE hLibModule
    );


DECLSPEC_NORETURN
VOID
FreeLibraryAndExitThread (
    __in HMODULE hLibModule,
    __in DWORD dwExitCode
    );

BOOL
DisableThreadLibraryCalls (
    __in HMODULE hLibModule
    );

FARPROC
GetProcAddress (
    __in HMODULE hModule,
    __in LPCSTR lpProcName
    );

DWORD
GetVersion (
    VOID
    );

__out_opt
HGLOBAL
GlobalAlloc (
    __in UINT uFlags,
    __in SIZE_T dwBytes
    );

__out_opt
HGLOBAL
GlobalReAlloc (
    __in HGLOBAL hMem,
    __in SIZE_T dwBytes,
    __in UINT uFlags
    );

SIZE_T
GlobalSize (
    __in HGLOBAL hMem
    );

UINT
GlobalFlags (
    __in HGLOBAL hMem
    );

__out_opt
LPVOID
GlobalLock (
    __in HGLOBAL hMem
    );

__out_opt
HGLOBAL
GlobalHandle (
    __in LPCVOID pMem
    );

BOOL
GlobalUnlock(
    __in HGLOBAL hMem
    );

__out_opt
HGLOBAL
GlobalFree(
    __deref HGLOBAL hMem
    );

SIZE_T
GlobalCompact(
    __in DWORD dwMinFree
    );

VOID
GlobalFix(
    __in HGLOBAL hMem
    );

VOID
GlobalUnfix(
    __in HGLOBAL hMem
    );

__out
LPVOID
GlobalWire(
    __in HGLOBAL hMem
    );

BOOL
GlobalUnWire(
    __in HGLOBAL hMem
    );

VOID
GlobalMemoryStatus(
    __out LPMEMORYSTATUS lpBuffer
    );

struct MEMORYSTATUSEX {
    DWORD dwLength;
    DWORD dwMemoryLoad;
    DWORDLONG ullTotalPhys;
    DWORDLONG ullAvailPhys;
    DWORDLONG ullTotalPageFile;
    DWORDLONG ullAvailPageFile;
    DWORDLONG ullTotalVirtual;
    DWORDLONG ullAvailVirtual;
    DWORDLONG ullAvailExtendedVirtual;
}

typedef MEMORYSTATUSEX* LPMEMORYSTATUSEX;

BOOL
GlobalMemoryStatusEx(
    __out LPMEMORYSTATUSEX lpBuffer
    );

__out_bcount_opt( "(uFlags&LMEM_FIXED) ? uBytes : 0" )
HLOCAL
LocalAlloc(
    __in UINT uFlags,
    __in SIZE_T uBytes
    );

__out_opt
HLOCAL
LocalReAlloc(
    __in HLOCAL hMem,
    __in SIZE_T uBytes,
    __in UINT uFlags
    );

__out_opt
LPVOID
LocalLock(
    __in HLOCAL hMem
    );

__out_opt
HLOCAL
LocalHandle(
    __in LPCVOID pMem
    );

BOOL
LocalUnlock(
    __in HLOCAL hMem
    );

SIZE_T
LocalSize(
    __in HLOCAL hMem
    );

UINT
LocalFlags(
    __in HLOCAL hMem
    );

HLOCAL
LocalFree(
    __deref HLOCAL hMem
    );

SIZE_T
LocalShrink(
    __in HLOCAL hMem,
    __in UINT cbNewSize
    );

SIZE_T
LocalCompact(
    __in UINT uMinFree
    );

BOOL
FlushInstructionCache(
    __in HANDLE hProcess,
    __in_bcount_opt(dwSize) LPCVOID lpBaseAddress,
    __in SIZE_T dwSize
    );

#if (_WIN32_WINNT >= 0x0600)

VOID
FlushProcessWriteBuffers(
    VOID
    );

BOOL
QueryThreadCycleTime (
    __in HANDLE ThreadHandle,
    __out PULONG64 CycleTime
    );

BOOL
QueryProcessCycleTime (
    __in HANDLE ProcessHandle,
    __out PULONG64 CycleTime
    );

BOOL
QueryIdleProcessorCycleTime (
    __inout PULONG BufferLength,
    __out_bcount_opt(*BufferLength) PULONG64 ProcessorIdleCycleTime
    );

#endif

__bcount_opt(dwSize)
LPVOID
VirtualAlloc(
    __in_opt LPVOID lpAddress,
    __in     SIZE_T dwSize,
    __in     DWORD flAllocationType,
    __in     DWORD flProtect
    );

BOOL
VirtualFree(
    __in LPVOID lpAddress,
    __in SIZE_T dwSize,
    __in DWORD dwFreeType
    );

BOOL
VirtualProtect(
    __in  LPVOID lpAddress,
    __in  SIZE_T dwSize,
    __in  DWORD flNewProtect,
    __out PDWORD lpflOldProtect
    );

SIZE_T
VirtualQuery(
    __in_opt LPCVOID lpAddress,
    __out_bcount_part(dwLength, return) PMEMORY_BASIC_INFORMATION lpBuffer,
    __in     SIZE_T dwLength
    );

__bcount_opt(dwSize)
LPVOID
VirtualAllocEx(
    __in     HANDLE hProcess,
    __in_opt LPVOID lpAddress,
    __in     SIZE_T dwSize,
    __in     DWORD flAllocationType,
    __in     DWORD flProtect
    );

#if _WIN32_WINNT >= 0x0600

__bcount(dwSize)
LPVOID
VirtualAllocExNuma(
    __in     HANDLE hProcess,
    __in_opt LPVOID lpAddress,
    __in     SIZE_T dwSize,
    __in     DWORD  flAllocationType,
    __in     DWORD  flProtect,
    __in     DWORD  nndPreferred
    );

#endif // _WIN32_WINNT >= 0x0600

UINT
GetWriteWatch(
    __in DWORD dwFlags,
    __in PVOID lpBaseAddress,
    __in SIZE_T dwRegionSize,
    __out_ecount_part(*lpdwCount, *lpdwCount) PVOID *lpAddresses,
    __inout ULONG_PTR *lpdwCount,
    __out PULONG lpdwGranularity
    );

UINT
ResetWriteWatch(
    __in LPVOID lpBaseAddress,
    __in SIZE_T dwRegionSize
    );

SIZE_T
GetLargePageMinimum(
    VOID
    );

UINT
EnumSystemFirmwareTables(
    __in DWORD FirmwareTableProviderSignature,
    __out_bcount_part_opt(BufferSize, return) PVOID pFirmwareTableEnumBuffer,
    __in DWORD BufferSize
    );

UINT
GetSystemFirmwareTable(
    __in DWORD FirmwareTableProviderSignature,
    __in DWORD FirmwareTableID,
    __out_bcount_part_opt(BufferSize, return) PVOID pFirmwareTableBuffer,
    __in DWORD BufferSize
    );

BOOL
VirtualFreeEx(
    __in HANDLE hProcess,
    __in LPVOID lpAddress,
    __in SIZE_T dwSize,
    __in DWORD  dwFreeType
    );

BOOL
VirtualProtectEx(
    __in  HANDLE hProcess,
    __in  LPVOID lpAddress,
    __in  SIZE_T dwSize,
    __in  DWORD flNewProtect,
    __out PDWORD lpflOldProtect
    );

SIZE_T
VirtualQueryEx(
    __in     HANDLE hProcess,
    __in_opt LPCVOID lpAddress,
    __out_bcount_part(dwLength, return) PMEMORY_BASIC_INFORMATION lpBuffer,
    __in     SIZE_T dwLength
    );

__out_opt
HANDLE
HeapCreate(
    __in DWORD flOptions,
    __in SIZE_T dwInitialSize,
    __in SIZE_T dwMaximumSize
    );

BOOL
HeapDestroy(
    __in HANDLE hHeap
    );

__bcount(dwBytes)
LPVOID
HeapAlloc(
    __in HANDLE hHeap,
    __in DWORD dwFlags,
    __in SIZE_T dwBytes
    );

__bcount(dwBytes)
LPVOID
HeapReAlloc(
    __inout HANDLE hHeap,
    __in    DWORD dwFlags,
    __deref LPVOID lpMem,
    __in    SIZE_T dwBytes
    );

BOOL
HeapFree(
    __inout HANDLE hHeap,
    __in    DWORD dwFlags,
    __deref LPVOID lpMem
    );

SIZE_T
HeapSize(
    __in HANDLE hHeap,
    __in DWORD dwFlags,
    __in LPCVOID lpMem
    );

BOOL
HeapValidate(
    __in     HANDLE hHeap,
    __in     DWORD dwFlags,
    __in_opt LPCVOID lpMem
    );

SIZE_T
HeapCompact(
    __in HANDLE hHeap,
    __in DWORD dwFlags
    );

__out
HANDLE
GetProcessHeap( VOID );

DWORD
GetProcessHeaps(
    __in DWORD NumberOfHeaps,
    __out_ecount_part(NumberOfHeaps, return) PHANDLE ProcessHeaps
    );

struct PROCESS_HEAP_ENTRY {
    PVOID lpData;
    DWORD cbData;
    BYTE cbOverhead;
    BYTE iRegionIndex;
    WORD wFlags;
    union {
        struct {
            HANDLE hMem;
            DWORD dwReserved[ 3 ];
        } Block;
        struct {
            DWORD dwCommittedSize;
            DWORD dwUnCommittedSize;
            LPVOID lpFirstBlock;
            LPVOID lpLastBlock;
        } Region;
    };
}

typedef PROCESS_HEAP_ENTRY* LPPROCESS_HEAP_ENTRY;
typedef PROCESS_HEAP_ENTRY* PPROCESS_HEAP_ENTRY;

const auto PROCESS_HEAP_REGION              = 0x0001;
const auto PROCESS_HEAP_UNCOMMITTED_RANGE   = 0x0002;
const auto PROCESS_HEAP_ENTRY_BUSY          = 0x0004;
const auto PROCESS_HEAP_ENTRY_MOVEABLE      = 0x0010;
const auto PROCESS_HEAP_ENTRY_DDESHARE      = 0x0020;

BOOL
HeapLock(
    __in HANDLE hHeap
    );

BOOL
HeapUnlock(
    __in HANDLE hHeap
    );


BOOL
HeapWalk(
    __in    HANDLE hHeap,
    __inout LPPROCESS_HEAP_ENTRY lpEntry
    );

BOOL
HeapSetInformation (
    __in_opt HANDLE HeapHandle,
    __in HEAP_INFORMATION_CLASS HeapInformationClass,
    __in_bcount_opt(HeapInformationLength) PVOID HeapInformation,
    __in SIZE_T HeapInformationLength
    );

BOOL
HeapQueryInformation (
    __in_opt HANDLE HeapHandle,
    __in HEAP_INFORMATION_CLASS HeapInformationClass,
    __out_bcount_part_opt(HeapInformationLength, *ReturnLength) PVOID HeapInformation,
    __in SIZE_T HeapInformationLength,
    __out_opt PSIZE_T ReturnLength
    );

// GetBinaryType return values.

const auto SCS_32BIT_BINARY     = 0;
const auto SCS_DOS_BINARY       = 1;
const auto SCS_WOW_BINARY       = 2;
const auto SCS_PIF_BINARY       = 3;
const auto SCS_POSIX_BINARY     = 4;
const auto SCS_OS216_BINARY     = 5;
const auto SCS_64BIT_BINARY     = 6;

#if defined(_WIN64)
# define SCS_THIS_PLATFORM_BINARY SCS_64BIT_BINARY
#else
# define SCS_THIS_PLATFORM_BINARY SCS_32BIT_BINARY
#endif

BOOL
GetBinaryTypeA(
    __in  LPCSTR lpApplicationName,
    __out LPDWORD  lpBinaryType
    );
BOOL
GetBinaryTypeW(
    __in  LPCWSTR lpApplicationName,
    __out LPDWORD  lpBinaryType
    );

version(UNICODE) {
	alias GetBinaryTypeW GetBinaryType;
}
else {
	alias GetBinaryTypeA GetBinaryType;
}

DWORD
GetShortPathNameA(
    __in LPCSTR lpszLongPath,
    __out_ecount_part(cchBuffer, return + 1) LPSTR  lpszShortPath,
    __in DWORD cchBuffer
    );
DWORD
GetShortPathNameW(
    __in LPCWSTR lpszLongPath,
    __out_ecount_part(cchBuffer, return + 1) LPWSTR  lpszShortPath,
    __in DWORD cchBuffer
    );

version(UNICODE) {
	alias GetShortPathNameW GetShortPathName;
}
else {
	alias GetShortPathNameA GetShortPathName;
}

DWORD
GetLongPathNameA(
    __in LPCSTR lpszShortPath,
    __out_ecount_part(cchBuffer, return + 1) LPSTR  lpszLongPath,
    __in DWORD cchBuffer
    );
DWORD
GetLongPathNameW(
    __in LPCWSTR lpszShortPath,
    __out_ecount_part(cchBuffer, return + 1) LPWSTR  lpszLongPath,
    __in DWORD cchBuffer
    );

version(UNICODE) {
	alias GetLongPathNameW GetLongPathName;
}
else {
	alias GetLongPathNameA GetLongPathName;
}

#if _WIN32_WINNT >= 0x0600

DWORD
GetLongPathNameTransactedA(
    __in     LPCSTR lpszShortPath,
    __out_ecount_part(cchBuffer, return + 1) LPSTR  lpszLongPath,
    __in     DWORD cchBuffer,
    __in     HANDLE hTransaction
    );
DWORD
GetLongPathNameTransactedW(
    __in     LPCWSTR lpszShortPath,
    __out_ecount_part(cchBuffer, return + 1) LPWSTR  lpszLongPath,
    __in     DWORD cchBuffer,
    __in     HANDLE hTransaction
    );

version(UNICODE) {
	alias GetLongPathNameTransactedW GetLongPathNameTransacted;
}
else {
	alias GetLongPathNameTransactedA GetLongPathNameTransacted;
}

#endif // _WIN32_WINNT >= 0x0600

BOOL
GetProcessAffinityMask(
    __in  HANDLE hProcess,
    __out PDWORD_PTR lpProcessAffinityMask,
    __out PDWORD_PTR lpSystemAffinityMask
    );

BOOL
SetProcessAffinityMask(
    __in HANDLE hProcess,
    __in DWORD_PTR dwProcessAffinityMask
    );

#if _WIN32_WINNT >= 0x0501

BOOL
GetProcessHandleCount(
    __in  HANDLE hProcess,
    __out PDWORD pdwHandleCount
    );

#endif // (_WIN32_WINNT >= 0x0501)

BOOL
GetProcessTimes(
    __in  HANDLE hProcess,
    __out LPFILETIME lpCreationTime,
    __out LPFILETIME lpExitTime,
    __out LPFILETIME lpKernelTime,
    __out LPFILETIME lpUserTime
    );

BOOL
GetProcessIoCounters(
    __in  HANDLE hProcess,
    __out PIO_COUNTERS lpIoCounters
    );

BOOL
GetProcessWorkingSetSize(
    __in  HANDLE hProcess,
    __out PSIZE_T lpMinimumWorkingSetSize,
    __out PSIZE_T lpMaximumWorkingSetSize
    );

BOOL
GetProcessWorkingSetSizeEx(
    __in  HANDLE hProcess,
    __out PSIZE_T lpMinimumWorkingSetSize,
    __out PSIZE_T lpMaximumWorkingSetSize,
    __out PDWORD Flags
    );

BOOL
SetProcessWorkingSetSize(
    __in HANDLE hProcess,
    __in SIZE_T dwMinimumWorkingSetSize,
    __in SIZE_T dwMaximumWorkingSetSize
    );

BOOL
SetProcessWorkingSetSizeEx(
    __in HANDLE hProcess,
    __in SIZE_T dwMinimumWorkingSetSize,
    __in SIZE_T dwMaximumWorkingSetSize,
    __in DWORD Flags
    );

HANDLE
OpenProcess(
    __in DWORD dwDesiredAccess,
    __in BOOL bInheritHandle,
    __in DWORD dwProcessId
    );

__out
HANDLE
GetCurrentProcess(
    VOID
    );

DWORD
GetCurrentProcessId(
    VOID
    );

DECLSPEC_NORETURN
VOID
ExitProcess(
    __in UINT uExitCode
    );

BOOL
TerminateProcess(
    __in HANDLE hProcess,
    __in UINT uExitCode
    );

BOOL
GetExitCodeProcess(
    __in  HANDLE hProcess,
    __out LPDWORD lpExitCode
    );

VOID
FatalExit(
    __in int ExitCode
    );

__out
__nullnullterminated
LPCH
GetEnvironmentStrings(
    VOID
    );

__out
__nullnullterminated
LPWCH
GetEnvironmentStringsW(
    VOID
    );


version(UNICODE) {
	alias GetEnvironmentStringsW GetEnvironmentStrings;
}
else {
	alias GetEnvironmentStrings GetEnvironmentStringsA;
}

BOOL
SetEnvironmentStringsA(
    __in __nullnullterminated LPCH NewEnvironment
    );
BOOL
SetEnvironmentStringsW(
    __in __nullnullterminated LPWCH NewEnvironment
    );

version(UNICODE) {
	alias SetEnvironmentStringsW SetEnvironmentStrings;
}
else {
	alias SetEnvironmentStringsA SetEnvironmentStrings;
}

BOOL
FreeEnvironmentStringsA(
    __in __nullnullterminated LPCH
    );
BOOL
FreeEnvironmentStringsW(
    __in __nullnullterminated LPWCH
    );

version(UNICODE) {
	alias FreeEnvironmentStringsW FreeEnvironmentStrings;
}
else {
	alias FreeEnvironmentStringsA FreeEnvironmentStrings;
}

VOID
RaiseException(
    __in DWORD dwExceptionCode,
    __in DWORD dwExceptionFlags,
    __in DWORD nNumberOfArguments,
    __in_ecount_opt(nNumberOfArguments) CONST ULONG_PTR *lpArguments
    );

__callback
LONG
UnhandledExceptionFilter(
    __in struct _EXCEPTION_POINTERS *ExceptionInfo
    );

typedef LONG (WINAPI *PTOP_LEVEL_EXCEPTION_FILTER)(
    __in struct _EXCEPTION_POINTERS *ExceptionInfo
    );
typedef PTOP_LEVEL_EXCEPTION_FILTER LPTOP_LEVEL_EXCEPTION_FILTER;

LPTOP_LEVEL_EXCEPTION_FILTER
SetUnhandledExceptionFilter(
    __in LPTOP_LEVEL_EXCEPTION_FILTER lpTopLevelExceptionFilter
    );

#if(_WIN32_WINNT >= 0x0400)

//
// Fiber creation flags
//

const auto FIBER_FLAG_FLOAT_SWITCH  = 0x1     ; // context switch floating point

__out_opt
LPVOID
CreateFiber(
    __in     SIZE_T dwStackSize,
    __in     LPFIBER_START_ROUTINE lpStartAddress,
    __in_opt LPVOID lpParameter
    );

__out_opt
LPVOID
CreateFiberEx(
    __in     SIZE_T dwStackCommitSize,
    __in     SIZE_T dwStackReserveSize,
    __in     DWORD dwFlags,
    __in     LPFIBER_START_ROUTINE lpStartAddress,
    __in_opt LPVOID lpParameter
    );

VOID
DeleteFiber(
    __in LPVOID lpFiber
    );

__out_opt
LPVOID
ConvertThreadToFiber(
    __in_opt LPVOID lpParameter
    );

__out_opt
LPVOID
ConvertThreadToFiberEx(
    __in_opt LPVOID lpParameter,
    __in     DWORD dwFlags
    );

#if (_WIN32_WINNT >= 0x0501)

BOOL
ConvertFiberToThread(
    VOID
    );

#endif

#if (_WIN32_WINNT >= 0x0600)

BOOL
IsThreadAFiber(
    VOID
    );

#endif

VOID
SwitchToFiber(
    __in LPVOID lpFiber
    );

BOOL
SwitchToThread(
    VOID
    );

#endif /* _WIN32_WINNT >= 0x0400 */

__out_opt
HANDLE
CreateThread(
    __in_opt  LPSECURITY_ATTRIBUTES lpThreadAttributes,
    __in      SIZE_T dwStackSize,
    __in      LPTHREAD_START_ROUTINE lpStartAddress,
    __in_opt  LPVOID lpParameter,
    __in      DWORD dwCreationFlags,
    __out_opt LPDWORD lpThreadId
    );

__out_opt
HANDLE
CreateRemoteThread(
    __in      HANDLE hProcess,
    __in_opt  LPSECURITY_ATTRIBUTES lpThreadAttributes,
    __in      SIZE_T dwStackSize,
    __in      LPTHREAD_START_ROUTINE lpStartAddress,
    __in_opt  LPVOID lpParameter,
    __in      DWORD dwCreationFlags,
    __out_opt LPDWORD lpThreadId
    );

__out
HANDLE
GetCurrentThread(
    VOID
    );

DWORD
GetCurrentThreadId(
    VOID
    );

BOOL
SetThreadStackGuarantee (
    __inout PULONG StackSizeInBytes
    );

DWORD
GetProcessIdOfThread(
    __in HANDLE Thread
    );

#if (_WIN32_WINNT >= 0x0502)

DWORD
GetThreadId(
    __in HANDLE Thread
    );

#endif // _WIN32_WINNT >= 0x0502

DWORD
GetProcessId(
    __in HANDLE Process
    );

DWORD
GetCurrentProcessorNumber(
    VOID
    );

DWORD_PTR
SetThreadAffinityMask(
    __in HANDLE hThread,
    __in DWORD_PTR dwThreadAffinityMask
    );

#if(_WIN32_WINNT >= 0x0400)
DWORD
SetThreadIdealProcessor(
    __in HANDLE hThread,
    __in DWORD dwIdealProcessor
    );
#endif /* _WIN32_WINNT >= 0x0400 */

BOOL
SetProcessPriorityBoost(
    __in HANDLE hProcess,
    __in BOOL bDisablePriorityBoost
    );

BOOL
GetProcessPriorityBoost(
    __in  HANDLE hProcess,
    __out PBOOL  pDisablePriorityBoost
    );

BOOL
RequestWakeupLatency(
    __in LATENCY_TIME latency
    );

BOOL
IsSystemResumeAutomatic(
    VOID
    );

__out_opt
HANDLE
OpenThread(
    __in DWORD dwDesiredAccess,
    __in BOOL bInheritHandle,
    __in DWORD dwThreadId
    );

BOOL
SetThreadPriority(
    __in HANDLE hThread,
    __in int nPriority
    );

BOOL
SetThreadPriorityBoost(
    __in HANDLE hThread,
    __in BOOL bDisablePriorityBoost
    );

BOOL
GetThreadPriorityBoost(
    __in  HANDLE hThread,
    __out PBOOL pDisablePriorityBoost
    );

int
GetThreadPriority(
    __in HANDLE hThread
    );

BOOL
GetThreadTimes(
    __in  HANDLE hThread,
    __out LPFILETIME lpCreationTime,
    __out LPFILETIME lpExitTime,
    __out LPFILETIME lpKernelTime,
    __out LPFILETIME lpUserTime
    );

#if _WIN32_WINNT >= 0x0501

BOOL
GetThreadIOPendingFlag(
    __in  HANDLE hThread,
    __out PBOOL  lpIOIsPending
    );

#endif // (_WIN32_WINNT >= 0x0501)

DECLSPEC_NORETURN
VOID
ExitThread(
    __in DWORD dwExitCode
    );

BOOL
TerminateThread(
    __in HANDLE hThread,
    __in DWORD dwExitCode
    );

BOOL
GetExitCodeThread(
    __in  HANDLE hThread,
    __out LPDWORD lpExitCode
    );

BOOL
GetThreadSelectorEntry(
    __in  HANDLE hThread,
    __in  DWORD dwSelector,
    __out LPLDT_ENTRY lpSelectorEntry
    );

EXECUTION_STATE
SetThreadExecutionState(
    __in EXECUTION_STATE esFlags
    );

#ifdef _M_CEE_PURE
const auto GetLastError  = System::Runtime::InteropServices::Marshal::GetLastWin32Error;
#else
__checkReturn
DWORD
GetLastError(
    VOID
    );
#endif

VOID
SetLastError(
    __in DWORD dwErrCode
    );

#if !defined(RC_INVOKED) // RC warns because "WINBASE_DECLARE_RESTORE_LAST_ERROR" is a bit long.
//#if _WIN32_WINNT >= 0x0501 || defined(WINBASE_DECLARE_RESTORE_LAST_ERROR)
#if defined(WINBASE_DECLARE_RESTORE_LAST_ERROR)

VOID
RestoreLastError(
    __in DWORD dwErrCode
    );

typedef VOID (WINAPI* PRESTORE_LAST_ERROR)(DWORD);
const auto RESTORE_LAST_ERROR_NAME_A       = "RestoreLastError";
const auto RESTORE_LAST_ERROR_NAME_W      = L"RestoreLastError";
const auto RESTORE_LAST_ERROR_NAME    = TEXT("RestoreLastError");

#endif
#endif

const auto HasOverlappedIoCompleted(lpOverlapped)  = (((DWORD)(lpOverlapped)->Internal) != STATUS_PENDING);

BOOL
GetOverlappedResult(
    __in  HANDLE hFile,
    __in  LPOVERLAPPED lpOverlapped,
    __out LPDWORD lpNumberOfBytesTransferred,
    __in  BOOL bWait
    );

__out_opt
HANDLE
CreateIoCompletionPort(
    __in     HANDLE FileHandle,
    __in_opt HANDLE ExistingCompletionPort,
    __in     ULONG_PTR CompletionKey,
    __in     DWORD NumberOfConcurrentThreads
    );

BOOL
GetQueuedCompletionStatus(
    __in  HANDLE CompletionPort,
    __out LPDWORD lpNumberOfBytesTransferred,
    __out PULONG_PTR lpCompletionKey,
    __out LPOVERLAPPED *lpOverlapped,
    __in  DWORD dwMilliseconds
    );

#if (_WIN32_WINNT >= 0x0600)

BOOL
GetQueuedCompletionStatusEx(
    __in  HANDLE CompletionPort,
    __out_ecount_part(ulCount, *ulNumEntriesRemoved) LPOVERLAPPED_ENTRY lpCompletionPortEntries,
    __in  ULONG ulCount,
    __out PULONG ulNumEntriesRemoved,
    __in  DWORD dwMilliseconds,
    __in  BOOL fAlertable
    );

#endif // _WIN32_WINNT >= 0x0600

BOOL
PostQueuedCompletionStatus(
    __in     HANDLE CompletionPort,
    __in     DWORD dwNumberOfBytesTransferred,
    __in     ULONG_PTR dwCompletionKey,
    __in_opt LPOVERLAPPED lpOverlapped
    );

#if (_WIN32_WINNT >= 0x0600)

//
// The following flags allows an application to change
// the semantics of IO completion notification.
//

//
// Don't queue an entry to an associated completion port if returning success
// synchronously.
//
const auto FILE_SKIP_COMPLETION_PORT_ON_SUCCESS     = 0x1;

//
// Don't set the file handle event on IO completion.
//
const auto FILE_SKIP_SET_EVENT_ON_HANDLE            = 0x2;

BOOL
SetFileCompletionNotificationModes(
    __in HANDLE FileHandle,
    __in UCHAR Flags
    );

BOOL
SetFileIoOverlappedRange(
    __in HANDLE FileHandle,
    __in PUCHAR OverlappedRangeStart,
    __in ULONG Length
    );

#endif // _WIN32_WINNT >= 0x0600

const auto SEM_FAILCRITICALERRORS       = 0x0001;
const auto SEM_NOGPFAULTERRORBOX        = 0x0002;
const auto SEM_NOALIGNMENTFAULTEXCEPT   = 0x0004;
const auto SEM_NOOPENFILEERRORBOX       = 0x8000;

UINT
GetErrorMode(
    VOID
    );

UINT
SetErrorMode(
    __in UINT uMode
    );

BOOL
ReadProcessMemory(
    __in      HANDLE hProcess,
    __in      LPCVOID lpBaseAddress,
    __out_bcount_part(nSize, *lpNumberOfBytesRead) LPVOID lpBuffer,
    __in      SIZE_T nSize,
    __out_opt SIZE_T * lpNumberOfBytesRead
    );

BOOL
WriteProcessMemory(
    __in      HANDLE hProcess,
    __in      LPVOID lpBaseAddress,
    __in_bcount(nSize) LPCVOID lpBuffer,
    __in      SIZE_T nSize,
    __out_opt SIZE_T * lpNumberOfBytesWritten
    );

#if !defined(MIDL_PASS)
BOOL
GetThreadContext(
    __in    HANDLE hThread,
    __inout LPCONTEXT lpContext
    );

BOOL
SetThreadContext(
    __in HANDLE hThread,
    __in CONST CONTEXT *lpContext
    );

BOOL
Wow64GetThreadContext(
    __in    HANDLE hThread,
    __inout PWOW64_CONTEXT lpContext
    );

BOOL
Wow64SetThreadContext(
    __in HANDLE hThread,
    __in CONST WOW64_CONTEXT *lpContext
    );

#endif

DWORD
SuspendThread(
    __in HANDLE hThread
    );

DWORD
Wow64SuspendThread(
    __in HANDLE hThread
    );

DWORD
ResumeThread(
    __in HANDLE hThread
    );


#if(_WIN32_WINNT >= 0x0400) || (_WIN32_WINDOWS > 0x0400)

typedef
VOID
(APIENTRY *PAPCFUNC)(
    __in ULONG_PTR dwParam
    );

DWORD
QueueUserAPC(
    __in PAPCFUNC pfnAPC,
    __in HANDLE hThread,
    __in ULONG_PTR dwData
    );

#endif /* _WIN32_WINNT >= 0x0400 || _WIN32_WINDOWS > 0x0400 */

#if (_WIN32_WINNT >= 0x0400) || (_WIN32_WINDOWS > 0x0400)
BOOL
IsDebuggerPresent(
    VOID
    );
#endif

#if _WIN32_WINNT >= 0x0501

BOOL
CheckRemoteDebuggerPresent(
    __in  HANDLE hProcess,
    __out PBOOL pbDebuggerPresent
    );

#endif // (_WIN32_WINNT >= 0x0501)

VOID
DebugBreak(
    VOID
    );

BOOL
WaitForDebugEvent(
    __in LPDEBUG_EVENT lpDebugEvent,
    __in DWORD dwMilliseconds
    );

BOOL
ContinueDebugEvent(
    __in DWORD dwProcessId,
    __in DWORD dwThreadId,
    __in DWORD dwContinueStatus
    );

BOOL
DebugActiveProcess(
    __in DWORD dwProcessId
    );

BOOL
DebugActiveProcessStop(
    __in DWORD dwProcessId
    );

BOOL
DebugSetProcessKillOnExit(
    __in BOOL KillOnExit
    );

BOOL
DebugBreakProcess (
    __in HANDLE Process
    );

VOID
InitializeCriticalSection(
    __out LPCRITICAL_SECTION lpCriticalSection
    );

VOID
EnterCriticalSection(
    __inout LPCRITICAL_SECTION lpCriticalSection
    );

VOID
LeaveCriticalSection(
    __inout LPCRITICAL_SECTION lpCriticalSection
    );

#if (_WIN32_WINNT >= 0x0403)
const auto CRITICAL_SECTION_NO_DEBUG_INFO   = RTL_CRITICAL_SECTION_FLAG_NO_DEBUG_INFO;

BOOL
InitializeCriticalSectionAndSpinCount(
    __out LPCRITICAL_SECTION lpCriticalSection,
    __in  DWORD dwSpinCount
    );

BOOL
InitializeCriticalSectionEx(
    __out LPCRITICAL_SECTION lpCriticalSection,
    __in  DWORD dwSpinCount,
    __in  DWORD Flags
    );

DWORD
SetCriticalSectionSpinCount(
    __inout LPCRITICAL_SECTION lpCriticalSection,
    __in    DWORD dwSpinCount
    );
#endif

#if(_WIN32_WINNT >= 0x0400)
BOOL
TryEnterCriticalSection(
    __inout LPCRITICAL_SECTION lpCriticalSection
    );
#endif /* _WIN32_WINNT >= 0x0400 */

VOID
DeleteCriticalSection(
    __inout LPCRITICAL_SECTION lpCriticalSection
    );

BOOL
SetEvent(
    __in HANDLE hEvent
    );

BOOL
ResetEvent(
    __in HANDLE hEvent
    );

BOOL
PulseEvent(
    __in HANDLE hEvent
    );

BOOL
ReleaseSemaphore(
    __in      HANDLE hSemaphore,
    __in      LONG lReleaseCount,
    __out_opt LPLONG lpPreviousCount
    );

BOOL
ReleaseMutex(
    __in HANDLE hMutex
    );

DWORD
WaitForSingleObject(
    __in HANDLE hHandle,
    __in DWORD dwMilliseconds
    );

DWORD
WaitForMultipleObjects(
    __in DWORD nCount,
    __in_ecount(nCount) CONST HANDLE *lpHandles,
    __in BOOL bWaitAll,
    __in DWORD dwMilliseconds
    );

VOID
Sleep(
    __in DWORD dwMilliseconds
    );

__out_opt
HGLOBAL
LoadResource(
    __in_opt HMODULE hModule,
    __in HRSRC hResInfo
    );

DWORD
SizeofResource(
    __in_opt HMODULE hModule,
    __in HRSRC hResInfo
    );


ATOM
GlobalDeleteAtom(
    __in ATOM nAtom
    );

BOOL
InitAtomTable(
    __in DWORD nSize
    );

ATOM
DeleteAtom(
    __in ATOM nAtom
    );

UINT
SetHandleCount(
    __in UINT uNumber
    );

DWORD
GetLogicalDrives(
    VOID
    );

BOOL
LockFile(
    __in HANDLE hFile,
    __in DWORD dwFileOffsetLow,
    __in DWORD dwFileOffsetHigh,
    __in DWORD nNumberOfBytesToLockLow,
    __in DWORD nNumberOfBytesToLockHigh
    );

BOOL
UnlockFile(
    __in HANDLE hFile,
    __in DWORD dwFileOffsetLow,
    __in DWORD dwFileOffsetHigh,
    __in DWORD nNumberOfBytesToUnlockLow,
    __in DWORD nNumberOfBytesToUnlockHigh
    );

BOOL
LockFileEx(
    __in       HANDLE hFile,
    __in       DWORD dwFlags,
    __reserved DWORD dwReserved,
    __in       DWORD nNumberOfBytesToLockLow,
    __in       DWORD nNumberOfBytesToLockHigh,
    __inout    LPOVERLAPPED lpOverlapped
    );

const auto LOCKFILE_FAIL_IMMEDIATELY    = 0x00000001;
const auto LOCKFILE_EXCLUSIVE_LOCK      = 0x00000002;

BOOL
UnlockFileEx(
    __in       HANDLE hFile,
    __reserved DWORD dwReserved,
    __in       DWORD nNumberOfBytesToUnlockLow,
    __in       DWORD nNumberOfBytesToUnlockHigh,
    __inout    LPOVERLAPPED lpOverlapped
    );

struct BY_HANDLE_FILE_INFORMATION {
    DWORD dwFileAttributes;
    FILETIME ftCreationTime;
    FILETIME ftLastAccessTime;
    FILETIME ftLastWriteTime;
    DWORD dwVolumeSerialNumber;
    DWORD nFileSizeHigh;
    DWORD nFileSizeLow;
    DWORD nNumberOfLinks;
    DWORD nFileIndexHigh;
    DWORD nFileIndexLow;
}

typedef BY_HANDLE_FILE_INFORMATION* PBY_HANDLE_FILE_INFORMATION;
typedef BY_HANDLE_FILE_INFORMATION* LPBY_HANDLE_FILE_INFORMATION;

BOOL
GetFileInformationByHandle(
    __in  HANDLE hFile,
    __out LPBY_HANDLE_FILE_INFORMATION lpFileInformation
    );

DWORD
GetFileType(
    __in HANDLE hFile
    );

DWORD
GetFileSize(
    __in      HANDLE hFile,
    __out_opt LPDWORD lpFileSizeHigh
    );

BOOL
GetFileSizeEx(
    __in  HANDLE hFile,
    __out PLARGE_INTEGER lpFileSize
    );


HANDLE
GetStdHandle(
    __in DWORD nStdHandle
    );

BOOL
SetStdHandle(
    __in DWORD nStdHandle,
    __in HANDLE hHandle
    );

#if (_WIN32_WINNT >= 0x0600)

BOOL
SetStdHandleEx(
    __in      DWORD nStdHandle,
    __in      HANDLE hHandle,
    __out_opt PHANDLE phPrevValue
    );

#endif // _WIN32_WINNT >= 0x0600

BOOL
WriteFile(
    __in        HANDLE hFile,
    __in_bcount_opt(nNumberOfBytesToWrite) LPCVOID lpBuffer,
    __in        DWORD nNumberOfBytesToWrite,
    __out_opt   LPDWORD lpNumberOfBytesWritten,
    __inout_opt LPOVERLAPPED lpOverlapped
    );

BOOL
ReadFile(
    __in        HANDLE hFile,
    __out_bcount_part_opt(nNumberOfBytesToRead, *lpNumberOfBytesRead) __out_data_source(FILE) LPVOID lpBuffer,
    __in        DWORD nNumberOfBytesToRead,
    __out_opt   LPDWORD lpNumberOfBytesRead,
    __inout_opt LPOVERLAPPED lpOverlapped
    );

BOOL
FlushFileBuffers(
    __in HANDLE hFile
    );

BOOL
DeviceIoControl(
    __in        HANDLE hDevice,
    __in        DWORD dwIoControlCode,
    __in_bcount_opt(nInBufferSize) LPVOID lpInBuffer,
    __in        DWORD nInBufferSize,
    __out_bcount_part_opt(nOutBufferSize, *lpBytesReturned) LPVOID lpOutBuffer,
    __in        DWORD nOutBufferSize,
    __out_opt   LPDWORD lpBytesReturned,
    __inout_opt LPOVERLAPPED lpOverlapped
    );

BOOL
RequestDeviceWakeup(
    __in HANDLE hDevice
    );

BOOL
CancelDeviceWakeupRequest(
    __in HANDLE hDevice
    );

BOOL
GetDevicePowerState(
    __in  HANDLE hDevice,
    __out BOOL *pfOn
    );

BOOL
SetMessageWaitingIndicator(
    __in HANDLE hMsgIndicator,
    __in ULONG ulMsgCount
    );

BOOL
SetEndOfFile(
    __in HANDLE hFile
    );

DWORD
SetFilePointer(
    __in        HANDLE hFile,
    __in        LONG lDistanceToMove,
    __inout_opt PLONG lpDistanceToMoveHigh,
    __in        DWORD dwMoveMethod
    );

BOOL
SetFilePointerEx(
    __in      HANDLE hFile,
    __in      LARGE_INTEGER liDistanceToMove,
    __out_opt PLARGE_INTEGER lpNewFilePointer,
    __in      DWORD dwMoveMethod
    );

BOOL
FindClose(
    __inout HANDLE hFindFile
    );

BOOL
GetFileTime(
    __in      HANDLE hFile,
    __out_opt LPFILETIME lpCreationTime,
    __out_opt LPFILETIME lpLastAccessTime,
    __out_opt LPFILETIME lpLastWriteTime
    );

BOOL
SetFileTime(
    __in     HANDLE hFile,
    __in_opt CONST FILETIME *lpCreationTime,
    __in_opt CONST FILETIME *lpLastAccessTime,
    __in_opt CONST FILETIME *lpLastWriteTime
    );


#if _WIN32_WINNT >= 0x0501

BOOL
SetFileValidData(
    __in HANDLE hFile,
    __in LONGLONG ValidDataLength
    );

#endif // (_WIN32_WINNT >= 0x0501)


BOOL
SetFileShortNameA(
    __in HANDLE hFile,
    __in LPCSTR lpShortName
    );
BOOL
SetFileShortNameW(
    __in HANDLE hFile,
    __in LPCWSTR lpShortName
    );

version(UNICODE) {
	alias SetFileShortNameW SetFileShortName;
}
else {
	alias SetFileShortNameA SetFileShortName;
}

BOOL
CloseHandle(
    __in HANDLE hObject
    );

BOOL
DuplicateHandle(
    __in        HANDLE hSourceProcessHandle,
    __in        HANDLE hSourceHandle,
    __in        HANDLE hTargetProcessHandle,
    __deref_out LPHANDLE lpTargetHandle,
    __in        DWORD dwDesiredAccess,
    __in        BOOL bInheritHandle,
    __in        DWORD dwOptions
    );

BOOL
GetHandleInformation(
    __in  HANDLE hObject,
    __out LPDWORD lpdwFlags
    );

BOOL
SetHandleInformation(
    __in HANDLE hObject,
    __in DWORD dwMask,
    __in DWORD dwFlags
    );

const auto HANDLE_FLAG_INHERIT              = 0x00000001;
const auto HANDLE_FLAG_PROTECT_FROM_CLOSE   = 0x00000002;

const auto HINSTANCE_ERROR  = 32;

DWORD
LoadModule(
    __in LPCSTR lpModuleName,
    __in LPVOID lpParameterBlock
    );


UINT
WinExec(
    __in LPCSTR lpCmdLine,
    __in UINT uCmdShow
    );

BOOL
ClearCommBreak(
    __in HANDLE hFile
    );

BOOL
ClearCommError(
    __in      HANDLE hFile,
    __out_opt LPDWORD lpErrors,
    __out_opt LPCOMSTAT lpStat
    );

BOOL
SetupComm(
    __in HANDLE hFile,
    __in DWORD dwInQueue,
    __in DWORD dwOutQueue
    );

BOOL
EscapeCommFunction(
    __in HANDLE hFile,
    __in DWORD dwFunc
    );

__success(return == TRUE)
BOOL
GetCommConfig(
    __in      HANDLE hCommDev,
    __out_bcount_opt(*lpdwSize) LPCOMMCONFIG lpCC,
    __inout   LPDWORD lpdwSize
    );

BOOL
GetCommMask(
    __in  HANDLE hFile,
    __out LPDWORD lpEvtMask
    );

BOOL
GetCommProperties(
    __in    HANDLE hFile,
    __inout LPCOMMPROP lpCommProp
    );

BOOL
GetCommModemStatus(
    __in  HANDLE hFile,
    __out LPDWORD lpModemStat
    );

BOOL
GetCommState(
    __in  HANDLE hFile,
    __out LPDCB lpDCB
    );

BOOL
GetCommTimeouts(
    __in  HANDLE hFile,
    __out LPCOMMTIMEOUTS lpCommTimeouts
    );

BOOL
PurgeComm(
    __in HANDLE hFile,
    __in DWORD dwFlags
    );

BOOL
SetCommBreak(
    __in HANDLE hFile
    );

BOOL
SetCommConfig(
    __in HANDLE hCommDev,
    __in_bcount(dwSize) LPCOMMCONFIG lpCC,
    __in DWORD dwSize
    );

BOOL
SetCommMask(
    __in HANDLE hFile,
    __in DWORD dwEvtMask
    );

BOOL
SetCommState(
    __in HANDLE hFile,
    __in LPDCB lpDCB
    );

BOOL
SetCommTimeouts(
    __in HANDLE hFile,
    __in LPCOMMTIMEOUTS lpCommTimeouts
    );

BOOL
TransmitCommChar(
    __in HANDLE hFile,
    __in char cChar
    );

BOOL
WaitCommEvent(
    __in        HANDLE hFile,
    __inout     LPDWORD lpEvtMask,
    __inout_opt LPOVERLAPPED lpOverlapped
    );


DWORD
SetTapePosition(
    __in HANDLE hDevice,
    __in DWORD dwPositionMethod,
    __in DWORD dwPartition,
    __in DWORD dwOffsetLow,
    __in DWORD dwOffsetHigh,
    __in BOOL bImmediate
    );

DWORD
GetTapePosition(
    __in  HANDLE hDevice,
    __in  DWORD dwPositionType,
    __out LPDWORD lpdwPartition,
    __out LPDWORD lpdwOffsetLow,
    __out LPDWORD lpdwOffsetHigh
    );

DWORD
PrepareTape(
    __in HANDLE hDevice,
    __in DWORD dwOperation,
    __in BOOL bImmediate
    );

DWORD
EraseTape(
    __in HANDLE hDevice,
    __in DWORD dwEraseType,
    __in BOOL bImmediate
    );

DWORD
CreateTapePartition(
    __in HANDLE hDevice,
    __in DWORD dwPartitionMethod,
    __in DWORD dwCount,
    __in DWORD dwSize
    );

DWORD
WriteTapemark(
    __in HANDLE hDevice,
    __in DWORD dwTapemarkType,
    __in DWORD dwTapemarkCount,
    __in BOOL bImmediate
    );

DWORD
GetTapeStatus(
    __in HANDLE hDevice
    );

DWORD
GetTapeParameters(
    __in    HANDLE hDevice,
    __in    DWORD dwOperation,
    __inout LPDWORD lpdwSize,
    __out_bcount(*lpdwSize) LPVOID lpTapeInformation
    );

const auto GET_TAPE_MEDIA_INFORMATION  = 0;
const auto GET_TAPE_DRIVE_INFORMATION  = 1;

DWORD
SetTapeParameters(
    __in HANDLE hDevice,
    __in DWORD dwOperation,
    __in LPVOID lpTapeInformation
    );

const auto SET_TAPE_MEDIA_INFORMATION  = 0;
const auto SET_TAPE_DRIVE_INFORMATION  = 1;

BOOL
Beep(
    __in DWORD dwFreq,
    __in DWORD dwDuration
    );

int
MulDiv(
    __in int nNumber,
    __in int nNumerator,
    __in int nDenominator
    );

VOID
GetSystemTime(
    __out LPSYSTEMTIME lpSystemTime
    );

VOID
GetSystemTimeAsFileTime(
    __out LPFILETIME lpSystemTimeAsFileTime
    );

BOOL
SetSystemTime(
    __in CONST SYSTEMTIME *lpSystemTime
    );

VOID
GetLocalTime(
    __out LPSYSTEMTIME lpSystemTime
    );

BOOL
SetLocalTime(
    __in CONST SYSTEMTIME *lpSystemTime
    );

VOID
GetSystemInfo(
    __out LPSYSTEM_INFO lpSystemInfo
    );

#if _WIN32_WINNT >= 0x0502

BOOL
SetSystemFileCacheSize (
    __in SIZE_T MinimumFileCacheSize,
    __in SIZE_T MaximumFileCacheSize,
    __in DWORD Flags
    );

BOOL
GetSystemFileCacheSize (
    __out PSIZE_T lpMinimumFileCacheSize,
    __out PSIZE_T lpMaximumFileCacheSize,
    __out PDWORD lpFlags
    );

#endif // (_WIN32_WINNT >= 0x0502)

#if _WIN32_WINNT >= 0x0501

BOOL
GetSystemRegistryQuota(
    __out_opt PDWORD pdwQuotaAllowed,
    __out_opt PDWORD pdwQuotaUsed
    );

BOOL
GetSystemTimes(
    __out_opt LPFILETIME lpIdleTime,
    __out_opt LPFILETIME lpKernelTime,
    __out_opt LPFILETIME lpUserTime
    );

#endif // (_WIN32_WINNT >= 0x0501)

#if _WIN32_WINNT >= 0x0501
VOID
GetNativeSystemInfo(
    __out LPSYSTEM_INFO lpSystemInfo
    );
#endif

BOOL
IsProcessorFeaturePresent(
    __in DWORD ProcessorFeature
    );

struct TIME_ZONE_INFORMATION {
    LONG Bias;
    WCHAR StandardName[ 32 ];
    SYSTEMTIME StandardDate;
    LONG StandardBias;
    WCHAR DaylightName[ 32 ];
    SYSTEMTIME DaylightDate;
    LONG DaylightBias;
}

typedef TIME_ZONE_INFORMATION* PTIME_ZONE_INFORMATION;
typedef TIME_ZONE_INFORMATION* LPTIME_ZONE_INFORMATION;

struct DYNAMIC_TIME_ZONE_INFORMATION {
    LONG Bias;
    WCHAR StandardName[ 32 ];
    SYSTEMTIME StandardDate;
    LONG StandardBias;
    WCHAR DaylightName[ 32 ];
    SYSTEMTIME DaylightDate;
    LONG DaylightBias;
    WCHAR TimeZoneKeyName[ 128 ];
    BOOLEAN DynamicDaylightTimeDisabled;
}

typedef DYNAMIC_TIME_ZONE_INFORMATION* PDYNAMIC_TIME_ZONE_INFORMATION;


BOOL
SystemTimeToTzSpecificLocalTime(
    __in_opt CONST TIME_ZONE_INFORMATION *lpTimeZoneInformation,
    __in     CONST SYSTEMTIME *lpUniversalTime,
    __out    LPSYSTEMTIME lpLocalTime
    );

BOOL
TzSpecificLocalTimeToSystemTime(
    __in_opt CONST TIME_ZONE_INFORMATION *lpTimeZoneInformation,
    __in     CONST SYSTEMTIME *lpLocalTime,
    __out    LPSYSTEMTIME lpUniversalTime
    );

DWORD
GetTimeZoneInformation(
    __out LPTIME_ZONE_INFORMATION lpTimeZoneInformation
    );

BOOL
SetTimeZoneInformation(
    __in CONST TIME_ZONE_INFORMATION *lpTimeZoneInformation
    );

DWORD
GetDynamicTimeZoneInformation(
    __out PDYNAMIC_TIME_ZONE_INFORMATION pTimeZoneInformation
    );

BOOL
SetDynamicTimeZoneInformation(
    __in CONST DYNAMIC_TIME_ZONE_INFORMATION *lpTimeZoneInformation
    );



//
// Routines to convert back and forth between system time and file time
//

BOOL
SystemTimeToFileTime(
    __in  CONST SYSTEMTIME *lpSystemTime,
    __out LPFILETIME lpFileTime
    );

BOOL
FileTimeToLocalFileTime(
    __in  CONST FILETIME *lpFileTime,
    __out LPFILETIME lpLocalFileTime
    );

BOOL
LocalFileTimeToFileTime(
    __in  CONST FILETIME *lpLocalFileTime,
    __out LPFILETIME lpFileTime
    );

BOOL
FileTimeToSystemTime(
    __in  CONST FILETIME *lpFileTime,
    __out LPSYSTEMTIME lpSystemTime
    );

LONG
CompareFileTime(
    __in CONST FILETIME *lpFileTime1,
    __in CONST FILETIME *lpFileTime2
    );

BOOL
FileTimeToDosDateTime(
    __in  CONST FILETIME *lpFileTime,
    __out LPWORD lpFatDate,
    __out LPWORD lpFatTime
    );

BOOL
DosDateTimeToFileTime(
    __in  WORD wFatDate,
    __in  WORD wFatTime,
    __out LPFILETIME lpFileTime
    );

DWORD
GetTickCount(
    VOID
    );

ULONGLONG
GetTickCount64(
    VOID
    );

BOOL
SetSystemTimeAdjustment(
    __in DWORD dwTimeAdjustment,
    __in BOOL  bTimeAdjustmentDisabled
    );

BOOL
GetSystemTimeAdjustment(
    __out PDWORD lpTimeAdjustment,
    __out PDWORD lpTimeIncrement,
    __out PBOOL  lpTimeAdjustmentDisabled
    );

#if !defined(MIDL_PASS)
DWORD
FormatMessageA(
    __in     DWORD dwFlags,
    __in_opt LPCVOID lpSource,
    __in     DWORD dwMessageId,
    __in     DWORD dwLanguageId,
    __out    LPSTR lpBuffer,
    __in     DWORD nSize,
    __in_opt va_list *Arguments
    );
DWORD
FormatMessageW(
    __in     DWORD dwFlags,
    __in_opt LPCVOID lpSource,
    __in     DWORD dwMessageId,
    __in     DWORD dwLanguageId,
    __out    LPWSTR lpBuffer,
    __in     DWORD nSize,
    __in_opt va_list *Arguments
    );

version(UNICODE) {
	alias FormatMessageW FormatMessage;
}
else {
	alias FormatMessageA FormatMessage;
}

#if defined(_M_CEE)
#undef FormatMessage
__inline
DWORD
FormatMessage(
    DWORD dwFlags,
    LPCVOID lpSource,
    DWORD dwMessageId,
    DWORD dwLanguageId,
    LPTSTR lpBuffer,
    DWORD nSize,
    va_list *Arguments
    )
{

version(UNICODE) {
	    return FormatMessageW(
}
else {
	    return FormatMessageA(
}
        dwFlags,
        lpSource,
        dwMessageId,
        dwLanguageId,
        lpBuffer,
        nSize,
        Arguments
        );
}
#endif  /* _M_CEE */
#endif  /* MIDL_PASS */

const auto FORMAT_MESSAGE_ALLOCATE_BUFFER  = 0x00000100;
const auto FORMAT_MESSAGE_IGNORE_INSERTS   = 0x00000200;
const auto FORMAT_MESSAGE_FROM_STRING      = 0x00000400;
const auto FORMAT_MESSAGE_FROM_HMODULE     = 0x00000800;
const auto FORMAT_MESSAGE_FROM_SYSTEM      = 0x00001000;
const auto FORMAT_MESSAGE_ARGUMENT_ARRAY   = 0x00002000;
const auto FORMAT_MESSAGE_MAX_WIDTH_MASK   = 0x000000FF;



BOOL
CreatePipe(
    __out_ecount_full(1) PHANDLE hReadPipe,
    __out_ecount_full(1) PHANDLE hWritePipe,
    __in_opt LPSECURITY_ATTRIBUTES lpPipeAttributes,
    __in     DWORD nSize
    );

BOOL
ConnectNamedPipe(
    __in        HANDLE hNamedPipe,
    __inout_opt LPOVERLAPPED lpOverlapped
    );

BOOL
DisconnectNamedPipe(
    __in HANDLE hNamedPipe
    );

BOOL
SetNamedPipeHandleState(
    __in     HANDLE hNamedPipe,
    __in_opt LPDWORD lpMode,
    __in_opt LPDWORD lpMaxCollectionCount,
    __in_opt LPDWORD lpCollectDataTimeout
    );

BOOL
GetNamedPipeInfo(
    __in      HANDLE hNamedPipe,
    __out_opt LPDWORD lpFlags,
    __out_opt LPDWORD lpOutBufferSize,
    __out_opt LPDWORD lpInBufferSize,
    __out_opt LPDWORD lpMaxInstances
    );

BOOL
PeekNamedPipe(
    __in      HANDLE hNamedPipe,
    __out_bcount_part_opt(nBufferSize, *lpBytesRead) LPVOID lpBuffer,
    __in      DWORD nBufferSize,
    __out_opt LPDWORD lpBytesRead,
    __out_opt LPDWORD lpTotalBytesAvail,
    __out_opt LPDWORD lpBytesLeftThisMessage
    );

BOOL
TransactNamedPipe(
    __in        HANDLE hNamedPipe,
    __in_bcount_opt(nInBufferSize) LPVOID lpInBuffer,
    __in        DWORD nInBufferSize,
    __out_bcount_part_opt(nOutBufferSize, *lpBytesRead) LPVOID lpOutBuffer,
    __in        DWORD nOutBufferSize,
    __out       LPDWORD lpBytesRead,
    __inout_opt LPOVERLAPPED lpOverlapped
    );

__out
HANDLE
CreateMailslotA(
    __in     LPCSTR lpName,
    __in     DWORD nMaxMessageSize,
    __in     DWORD lReadTimeout,
    __in_opt LPSECURITY_ATTRIBUTES lpSecurityAttributes
    );
__out
HANDLE
CreateMailslotW(
    __in     LPCWSTR lpName,
    __in     DWORD nMaxMessageSize,
    __in     DWORD lReadTimeout,
    __in_opt LPSECURITY_ATTRIBUTES lpSecurityAttributes
    );

version(UNICODE) {
	alias CreateMailslotW CreateMailslot;
}
else {
	alias CreateMailslotA CreateMailslot;
}

BOOL
GetMailslotInfo(
    __in      HANDLE hMailslot,
    __out_opt LPDWORD lpMaxMessageSize,
    __out_opt LPDWORD lpNextSize,
    __out_opt LPDWORD lpMessageCount,
    __out_opt LPDWORD lpReadTimeout
    );

BOOL
SetMailslotInfo(
    __in HANDLE hMailslot,
    __in DWORD lReadTimeout
    );

__out_opt __out_data_source(FILE)
LPVOID
MapViewOfFile(
    __in HANDLE hFileMappingObject,
    __in DWORD dwDesiredAccess,
    __in DWORD dwFileOffsetHigh,
    __in DWORD dwFileOffsetLow,
    __in SIZE_T dwNumberOfBytesToMap
    );

BOOL
FlushViewOfFile(
    __in LPCVOID lpBaseAddress,
    __in SIZE_T dwNumberOfBytesToFlush
    );

BOOL
UnmapViewOfFile(
    __in LPCVOID lpBaseAddress
    );

//
// File Encryption API
//

WINADVAPI
BOOL
EncryptFileA(
    __in LPCSTR lpFileName
    );
WINADVAPI
BOOL
EncryptFileW(
    __in LPCWSTR lpFileName
    );

version(UNICODE) {
	alias EncryptFileW EncryptFile;
}
else {
	alias EncryptFileA EncryptFile;
}

WINADVAPI
BOOL
DecryptFileA(
    __in       LPCSTR lpFileName,
    __reserved DWORD dwReserved
    );
WINADVAPI
BOOL
DecryptFileW(
    __in       LPCWSTR lpFileName,
    __reserved DWORD dwReserved
    );

version(UNICODE) {
	alias DecryptFileW DecryptFile;
}
else {
	alias DecryptFileA DecryptFile;
}

//
//  Encryption Status Value
//

const auto FILE_ENCRYPTABLE                 = 0;
const auto FILE_IS_ENCRYPTED                = 1;
const auto FILE_SYSTEM_ATTR                 = 2;
const auto FILE_ROOT_DIR                    = 3;
const auto FILE_SYSTEM_DIR                  = 4;
const auto FILE_UNKNOWN                     = 5;
const auto FILE_SYSTEM_NOT_SUPPORT          = 6;
const auto FILE_USER_DISALLOWED             = 7;
const auto FILE_READ_ONLY                   = 8;
const auto FILE_DIR_DISALLOWED              = 9;

WINADVAPI
BOOL
FileEncryptionStatusA(
    __in  LPCSTR lpFileName,
    __out LPDWORD  lpStatus
    );
WINADVAPI
BOOL
FileEncryptionStatusW(
    __in  LPCWSTR lpFileName,
    __out LPDWORD  lpStatus
    );

version(UNICODE) {
	alias FileEncryptionStatusW FileEncryptionStatus;
}
else {
	alias FileEncryptionStatusA FileEncryptionStatus;
}

//
// Currently defined recovery flags
//

const auto EFS_USE_RECOVERY_KEYS   = (0x1);

typedef
DWORD
(WINAPI *PFE_EXPORT_FUNC)(
    __in_bcount(ulLength) PBYTE pbData,
    __in_opt PVOID pvCallbackContext,
    __in     ULONG ulLength
    );

typedef
DWORD
(WINAPI *PFE_IMPORT_FUNC)(
    __out_bcount_part(*ulLength, *ulLength) PBYTE pbData,
    __in_opt PVOID pvCallbackContext,
    __inout  PULONG ulLength
    );


//
//  OpenRaw flag values
//

const auto CREATE_FOR_IMPORT   = (1);
const auto CREATE_FOR_DIR      = (2);
const auto OVERWRITE_HIDDEN    = (4);
const auto EFSRPC_SECURE_ONLY  = (8);


WINADVAPI
DWORD
OpenEncryptedFileRawA(
    __in        LPCSTR lpFileName,
    __in        ULONG    ulFlags,
    __deref_out PVOID   *pvContext
    );
WINADVAPI
DWORD
OpenEncryptedFileRawW(
    __in        LPCWSTR lpFileName,
    __in        ULONG    ulFlags,
    __deref_out PVOID   *pvContext
    );

version(UNICODE) {
	alias OpenEncryptedFileRawW OpenEncryptedFileRaw;
}
else {
	alias OpenEncryptedFileRawA OpenEncryptedFileRaw;
}

WINADVAPI
DWORD
ReadEncryptedFileRaw(
    __in     PFE_EXPORT_FUNC pfExportCallback,
    __in_opt PVOID           pvCallbackContext,
    __in     PVOID           pvContext
    );

WINADVAPI
DWORD
WriteEncryptedFileRaw(
    __in     PFE_IMPORT_FUNC pfImportCallback,
    __in_opt PVOID           pvCallbackContext,
    __in     PVOID           pvContext
    );

WINADVAPI
VOID
CloseEncryptedFileRaw(
    __in PVOID           pvContext
    );

//
// _l Compat Functions
//

int
lstrcmpA(
    __in LPCSTR lpString1,
    __in LPCSTR lpString2
    );
int
lstrcmpW(
    __in LPCWSTR lpString1,
    __in LPCWSTR lpString2
    );

version(UNICODE) {
	alias lstrcmpW lstrcmp;
}
else {
	alias lstrcmpA lstrcmp;
}

int
lstrcmpiA(
    __in LPCSTR lpString1,
    __in LPCSTR lpString2
    );
int
lstrcmpiW(
    __in LPCWSTR lpString1,
    __in LPCWSTR lpString2
    );

version(UNICODE) {
	alias lstrcmpiW lstrcmpi;
}
else {
	alias lstrcmpiA lstrcmpi;
}

__out
LPSTR
lstrcpynA(
    __out_ecount(iMaxLength) LPSTR lpString1,
    __in LPCSTR lpString2,
    __in int iMaxLength
    );
__out
LPWSTR
lstrcpynW(
    __out_ecount(iMaxLength) LPWSTR lpString1,
    __in LPCWSTR lpString2,
    __in int iMaxLength
    );

version(UNICODE) {
	alias lstrcpynW lstrcpyn;
}
else {
	alias lstrcpynA lstrcpyn;
}

#if defined(DEPRECATE_SUPPORTED)
#pragma warning(push)
#pragma warning(disable:4995)
#endif

__out
LPSTR
lstrcpyA(
    __out LPSTR lpString1,
    __in  LPCSTR lpString2
    );
__out
LPWSTR
lstrcpyW(
    __out LPWSTR lpString1,
    __in  LPCWSTR lpString2
    );

version(UNICODE) {
	alias lstrcpyW lstrcpy;
}
else {
	alias lstrcpyA lstrcpy;
}

__out
LPSTR
lstrcatA(
    __inout LPSTR lpString1,
    __in    LPCSTR lpString2
    );
__out
LPWSTR
lstrcatW(
    __inout LPWSTR lpString1,
    __in    LPCWSTR lpString2
    );

version(UNICODE) {
	alias lstrcatW lstrcat;
}
else {
	alias lstrcatA lstrcat;
}

#if defined(DEPRECATE_SUPPORTED)
#pragma warning(pop)
#endif

int
lstrlenA(
    __in LPCSTR lpString
    );
int
lstrlenW(
    __in LPCWSTR lpString
    );

version(UNICODE) {
	alias lstrlenW lstrlen;
}
else {
	alias lstrlenA lstrlen;
}

HFILE
OpenFile(
    __in    LPCSTR lpFileName,
    __inout LPOFSTRUCT lpReOpenBuff,
    __in    UINT uStyle
    );

HFILE
_lopen(
    __in LPCSTR lpPathName,
    __in int iReadWrite
    );

HFILE
_lcreat(
    __in LPCSTR lpPathName,
    __in int  iAttribute
    );

UINT
_lread(
    __in HFILE hFile,
    __out_bcount_part(uBytes, return) LPVOID lpBuffer,
    __in UINT uBytes
    );

UINT
_lwrite(
    __in HFILE hFile,
    __in_bcount(uBytes) LPCCH lpBuffer,
    __in UINT uBytes
    );

long
_hread(
    __in HFILE hFile,
    __out_bcount_part(lBytes, return) LPVOID lpBuffer,
    __in long lBytes
    );

long
_hwrite(
    __in HFILE hFile,
    __in_bcount(lBytes) LPCCH lpBuffer,
    __in long lBytes
    );

HFILE
_lclose(
    __in HFILE hFile
    );

LONG
_llseek(
    __in HFILE hFile,
    __in LONG lOffset,
    __in int iOrigin
    );

WINADVAPI
BOOL
IsTextUnicode(
    __in_bcount(iSize) CONST VOID* lpv,
    __in        int iSize,
    __inout_opt LPINT lpiResult
    );

const auto FLS_OUT_OF_INDEXES  = ((DWORD)0xFFFFFFFF);

DWORD
FlsAlloc(
    __in_opt PFLS_CALLBACK_FUNCTION lpCallback
    );

PVOID
FlsGetValue(
    __in DWORD dwFlsIndex
    );

BOOL
FlsSetValue(
    __in     DWORD dwFlsIndex,
    __in_opt PVOID lpFlsData
    );

BOOL
FlsFree(
    __in DWORD dwFlsIndex
    );

const auto TLS_OUT_OF_INDEXES  = ((DWORD)0xFFFFFFFF);

DWORD
TlsAlloc(
    VOID
    );

LPVOID
TlsGetValue(
    __in DWORD dwTlsIndex
    );

BOOL
TlsSetValue(
    __in     DWORD dwTlsIndex,
    __in_opt LPVOID lpTlsValue
    );

BOOL
TlsFree(
    __in DWORD dwTlsIndex
    );

typedef
VOID
(WINAPI *LPOVERLAPPED_COMPLETION_ROUTINE)(
    __in    DWORD dwErrorCode,
    __in    DWORD dwNumberOfBytesTransfered,
    __inout LPOVERLAPPED lpOverlapped
    );

DWORD
SleepEx(
    __in DWORD dwMilliseconds,
    __in BOOL bAlertable
    );

DWORD
WaitForSingleObjectEx(
    __in HANDLE hHandle,
    __in DWORD dwMilliseconds,
    __in BOOL bAlertable
    );

DWORD
WaitForMultipleObjectsEx(
    __in DWORD nCount,
    __in_ecount(nCount) CONST HANDLE *lpHandles,
    __in BOOL bWaitAll,
    __in DWORD dwMilliseconds,
    __in BOOL bAlertable
    );

#if(_WIN32_WINNT >= 0x0400)
DWORD
SignalObjectAndWait(
    __in HANDLE hObjectToSignal,
    __in HANDLE hObjectToWaitOn,
    __in DWORD dwMilliseconds,
    __in BOOL bAlertable
    );
#endif /* _WIN32_WINNT >= 0x0400 */

BOOL
ReadFileEx(
    __in     HANDLE hFile,
    __out_bcount_opt(nNumberOfBytesToRead) __out_data_source(FILE) LPVOID lpBuffer,
    __in     DWORD nNumberOfBytesToRead,
    __inout  LPOVERLAPPED lpOverlapped,
    __in_opt LPOVERLAPPED_COMPLETION_ROUTINE lpCompletionRoutine
    );

BOOL
WriteFileEx(
    __in     HANDLE hFile,
    __in_bcount_opt(nNumberOfBytesToWrite) LPCVOID lpBuffer,
    __in     DWORD nNumberOfBytesToWrite,
    __inout  LPOVERLAPPED lpOverlapped,
    __in_opt LPOVERLAPPED_COMPLETION_ROUTINE lpCompletionRoutine
    );

BOOL
BackupRead(
    __in    HANDLE hFile,
    __out_bcount_part(nNumberOfBytesToRead, *lpNumberOfBytesRead) LPBYTE lpBuffer,
    __in    DWORD nNumberOfBytesToRead,
    __out   LPDWORD lpNumberOfBytesRead,
    __in    BOOL bAbort,
    __in    BOOL bProcessSecurity,
    __inout LPVOID *lpContext
    );

BOOL
BackupSeek(
    __in    HANDLE hFile,
    __in    DWORD  dwLowBytesToSeek,
    __in    DWORD  dwHighBytesToSeek,
    __out   LPDWORD lpdwLowByteSeeked,
    __out   LPDWORD lpdwHighByteSeeked,
    __inout LPVOID *lpContext
    );

BOOL
BackupWrite(
    __in    HANDLE hFile,
    __in_bcount(nNumberOfBytesToWrite) LPBYTE lpBuffer,
    __in    DWORD nNumberOfBytesToWrite,
    __out   LPDWORD lpNumberOfBytesWritten,
    __in    BOOL bAbort,
    __in    BOOL bProcessSecurity,
    __inout LPVOID *lpContext
    );

//
//  Stream id structure
//
struct WIN32_STREAM_ID {
        DWORD          dwStreamId ;
        DWORD          dwStreamAttributes ;
        LARGE_INTEGER  Size ;
        DWORD          dwStreamNameSize ;
        WCHAR          cStreamName[ ANYSIZE_ARRAY ] ;
}

typedef WIN32_STREAM_ID* LPWIN32_STREAM_ID ;

//
//  Stream Ids
//

const auto BACKUP_INVALID           = 0x00000000;
const auto BACKUP_DATA              = 0x00000001;
const auto BACKUP_EA_DATA           = 0x00000002;
const auto BACKUP_SECURITY_DATA     = 0x00000003;
const auto BACKUP_ALTERNATE_DATA    = 0x00000004;
const auto BACKUP_LINK              = 0x00000005;
const auto BACKUP_PROPERTY_DATA     = 0x00000006;
const auto BACKUP_OBJECT_ID         = 0x00000007;
const auto BACKUP_REPARSE_DATA      = 0x00000008;
const auto BACKUP_SPARSE_BLOCK      = 0x00000009;
const auto BACKUP_TXFS_DATA         = 0x0000000a;


//
//  Stream Attributes
//

const auto STREAM_NORMAL_ATTRIBUTE          = 0x00000000;
const auto STREAM_MODIFIED_WHEN_READ        = 0x00000001;
const auto STREAM_CONTAINS_SECURITY         = 0x00000002;
const auto STREAM_CONTAINS_PROPERTIES       = 0x00000004;
const auto STREAM_SPARSE_ATTRIBUTE          = 0x00000008;

BOOL
ReadFileScatter(
    __in       HANDLE hFile,
    __in       FILE_SEGMENT_ELEMENT aSegmentArray[],
    __in       DWORD nNumberOfBytesToRead,
    __reserved LPDWORD lpReserved,
    __inout    LPOVERLAPPED lpOverlapped
    );

BOOL
WriteFileGather(
    __in       HANDLE hFile,
    __in       FILE_SEGMENT_ELEMENT aSegmentArray[],
    __in       DWORD nNumberOfBytesToWrite,
    __reserved LPDWORD lpReserved,
    __inout    LPOVERLAPPED lpOverlapped
    );

//
// Dual Mode API below this line. Dual Mode Structures also included.
//

const auto STARTF_USESHOWWINDOW     = 0x00000001;
const auto STARTF_USESIZE           = 0x00000002;
const auto STARTF_USEPOSITION       = 0x00000004;
const auto STARTF_USECOUNTCHARS     = 0x00000008;
const auto STARTF_USEFILLATTRIBUTE  = 0x00000010;
const auto STARTF_RUNFULLSCREEN     = 0x00000020  ; // ignored for non-x86 platforms
const auto STARTF_FORCEONFEEDBACK   = 0x00000040;
const auto STARTF_FORCEOFFFEEDBACK  = 0x00000080;
const auto STARTF_USESTDHANDLES     = 0x00000100;

#if(WINVER >= 0x0400)

const auto STARTF_USEHOTKEY         = 0x00000200;
#endif /* WINVER >= 0x0400 */

struct STARTUPINFOA {
    DWORD   cb;
    LPSTR   lpReserved;
    LPSTR   lpDesktop;
    LPSTR   lpTitle;
    DWORD   dwX;
    DWORD   dwY;
    DWORD   dwXSize;
    DWORD   dwYSize;
    DWORD   dwXCountChars;
    DWORD   dwYCountChars;
    DWORD   dwFillAttribute;
    DWORD   dwFlags;
    WORD    wShowWindow;
    WORD    cbReserved2;
    LPBYTE  lpReserved2;
    HANDLE  hStdInput;
    HANDLE  hStdOutput;
    HANDLE  hStdError;
}

typedef STARTUPINFOA* LPSTARTUPINFOA;
struct STARTUPINFOW {
    DWORD   cb;
    LPWSTR  lpReserved;
    LPWSTR  lpDesktop;
    LPWSTR  lpTitle;
    DWORD   dwX;
    DWORD   dwY;
    DWORD   dwXSize;
    DWORD   dwYSize;
    DWORD   dwXCountChars;
    DWORD   dwYCountChars;
    DWORD   dwFillAttribute;
    DWORD   dwFlags;
    WORD    wShowWindow;
    WORD    cbReserved2;
    LPBYTE  lpReserved2;
    HANDLE  hStdInput;
    HANDLE  hStdOutput;
    HANDLE  hStdError;
}

typedef STARTUPINFOW* LPSTARTUPINFOW;

version(UNICODE) {
	typedef STARTUPINFOW STARTUPINFO;
	typedef LPSTARTUPINFOW LPSTARTUPINFO;
}
else {
	typedef STARTUPINFOA STARTUPINFO;
	typedef LPSTARTUPINFOA LPSTARTUPINFO;
}

struct STARTUPINFOEXA {
    STARTUPINFOA StartupInfo;
    struct _PROC_THREAD_ATTRIBUTE_LIST *lpAttributeList;
}

typedef STARTUPINFOEXA* LPSTARTUPINFOEXA;
struct STARTUPINFOEXW {
    STARTUPINFOW StartupInfo;
    struct _PROC_THREAD_ATTRIBUTE_LIST *lpAttributeList;
}

typedef STARTUPINFOEXW* LPSTARTUPINFOEXW;

version(UNICODE) {
	typedef STARTUPINFOEXW STARTUPINFOEX;
	typedef LPSTARTUPINFOEXW LPSTARTUPINFOEX;
}
else {
	typedef STARTUPINFOEXA STARTUPINFOEX;
	typedef LPSTARTUPINFOEXA LPSTARTUPINFOEX;
}

const auto SHUTDOWN_NORETRY                 = 0x00000001;

struct WIN32_FIND_DATAA {
    DWORD dwFileAttributes;
    FILETIME ftCreationTime;
    FILETIME ftLastAccessTime;
    FILETIME ftLastWriteTime;
    DWORD nFileSizeHigh;
    DWORD nFileSizeLow;
    DWORD dwReserved0;
    DWORD dwReserved1;
    CHAR   cFileName[ MAX_PATH ];
    CHAR   cAlternateFileName[ 14 ];
#ifdef _MAC
    DWORD dwFileType;
    DWORD dwCreatorType;
    WORD  wFinderFlags;
#endif
}

typedef WIN32_FIND_DATAA* PWIN32_FIND_DATAA;
typedef WIN32_FIND_DATAA* LPWIN32_FIND_DATAA;
struct WIN32_FIND_DATAW {
    DWORD dwFileAttributes;
    FILETIME ftCreationTime;
    FILETIME ftLastAccessTime;
    FILETIME ftLastWriteTime;
    DWORD nFileSizeHigh;
    DWORD nFileSizeLow;
    DWORD dwReserved0;
    DWORD dwReserved1;
    WCHAR  cFileName[ MAX_PATH ];
    WCHAR  cAlternateFileName[ 14 ];
#ifdef _MAC
    DWORD dwFileType;
    DWORD dwCreatorType;
    WORD  wFinderFlags;
#endif
}

typedef WIN32_FIND_DATAW* PWIN32_FIND_DATAW;
typedef WIN32_FIND_DATAW* LPWIN32_FIND_DATAW;

version(UNICODE) {
	typedef WIN32_FIND_DATAW WIN32_FIND_DATA;
	typedef PWIN32_FIND_DATAW PWIN32_FIND_DATA;
	typedef LPWIN32_FIND_DATAW LPWIN32_FIND_DATA;
}
else {
	typedef WIN32_FIND_DATAA WIN32_FIND_DATA;
	typedef PWIN32_FIND_DATAA PWIN32_FIND_DATA;
	typedef LPWIN32_FIND_DATAA LPWIN32_FIND_DATA;
}

struct WIN32_FILE_ATTRIBUTE_DATA {
    DWORD dwFileAttributes;
    FILETIME ftCreationTime;
    FILETIME ftLastAccessTime;
    FILETIME ftLastWriteTime;
    DWORD nFileSizeHigh;
    DWORD nFileSizeLow;
}

typedef WIN32_FILE_ATTRIBUTE_DATA* LPWIN32_FILE_ATTRIBUTE_DATA;

//
// Synchronization APIs
//

__out_opt
HANDLE
CreateMutexA(
    __in_opt LPSECURITY_ATTRIBUTES lpMutexAttributes,
    __in     BOOL bInitialOwner,
    __in_opt LPCSTR lpName
    );
__out_opt
HANDLE
CreateMutexW(
    __in_opt LPSECURITY_ATTRIBUTES lpMutexAttributes,
    __in     BOOL bInitialOwner,
    __in_opt LPCWSTR lpName
    );

version(UNICODE) {
	alias CreateMutexW CreateMutex;
}
else {
	alias CreateMutexA CreateMutex;
}

__out_opt
HANDLE
OpenMutexA(
    __in DWORD dwDesiredAccess,
    __in BOOL bInheritHandle,
    __in LPCSTR lpName
    );
__out_opt
HANDLE
OpenMutexW(
    __in DWORD dwDesiredAccess,
    __in BOOL bInheritHandle,
    __in LPCWSTR lpName
    );

version(UNICODE) {
	alias OpenMutexW OpenMutex;
}
else {
	alias OpenMutexA OpenMutex;
}

__out_opt
HANDLE
CreateEventA(
    __in_opt LPSECURITY_ATTRIBUTES lpEventAttributes,
    __in     BOOL bManualReset,
    __in     BOOL bInitialState,
    __in_opt LPCSTR lpName
    );
__out_opt
HANDLE
CreateEventW(
    __in_opt LPSECURITY_ATTRIBUTES lpEventAttributes,
    __in     BOOL bManualReset,
    __in     BOOL bInitialState,
    __in_opt LPCWSTR lpName
    );

version(UNICODE) {
	alias CreateEventW CreateEvent;
}
else {
	alias CreateEventA CreateEvent;
}

__out_opt
HANDLE
OpenEventA(
    __in DWORD dwDesiredAccess,
    __in BOOL bInheritHandle,
    __in LPCSTR lpName
    );
__out_opt
HANDLE
OpenEventW(
    __in DWORD dwDesiredAccess,
    __in BOOL bInheritHandle,
    __in LPCWSTR lpName
    );

version(UNICODE) {
	alias OpenEventW OpenEvent;
}
else {
	alias OpenEventA OpenEvent;
}

__out_opt
HANDLE
CreateSemaphoreA(
    __in_opt LPSECURITY_ATTRIBUTES lpSemaphoreAttributes,
    __in     LONG lInitialCount,
    __in     LONG lMaximumCount,
    __in_opt LPCSTR lpName
    );
__out_opt
HANDLE
CreateSemaphoreW(
    __in_opt LPSECURITY_ATTRIBUTES lpSemaphoreAttributes,
    __in     LONG lInitialCount,
    __in     LONG lMaximumCount,
    __in_opt LPCWSTR lpName
    );

version(UNICODE) {
	alias CreateSemaphoreW CreateSemaphore;
}
else {
	alias CreateSemaphoreA CreateSemaphore;
}

__out_opt
HANDLE
OpenSemaphoreA(
    __in DWORD dwDesiredAccess,
    __in BOOL bInheritHandle,
    __in LPCSTR lpName
    );
__out_opt
HANDLE
OpenSemaphoreW(
    __in DWORD dwDesiredAccess,
    __in BOOL bInheritHandle,
    __in LPCWSTR lpName
    );

version(UNICODE) {
	alias OpenSemaphoreW OpenSemaphore;
}
else {
	alias OpenSemaphoreA OpenSemaphore;
}

#if (_WIN32_WINNT >= 0x0400) || (_WIN32_WINDOWS > 0x0400)
typedef
VOID
(APIENTRY *PTIMERAPCROUTINE)(
    __in_opt LPVOID lpArgToCompletionRoutine,
    __in     DWORD dwTimerLowValue,
    __in     DWORD dwTimerHighValue
    );

__out_opt
HANDLE
CreateWaitableTimerA(
    __in_opt LPSECURITY_ATTRIBUTES lpTimerAttributes,
    __in     BOOL bManualReset,
    __in_opt LPCSTR lpTimerName
    );
__out_opt
HANDLE
CreateWaitableTimerW(
    __in_opt LPSECURITY_ATTRIBUTES lpTimerAttributes,
    __in     BOOL bManualReset,
    __in_opt LPCWSTR lpTimerName
    );

version(UNICODE) {
	alias CreateWaitableTimerW CreateWaitableTimer;
}
else {
	alias CreateWaitableTimerA CreateWaitableTimer;
}

__out_opt
HANDLE
OpenWaitableTimerA(
    __in DWORD dwDesiredAccess,
    __in BOOL bInheritHandle,
    __in LPCSTR lpTimerName
    );
__out_opt
HANDLE
OpenWaitableTimerW(
    __in DWORD dwDesiredAccess,
    __in BOOL bInheritHandle,
    __in LPCWSTR lpTimerName
    );

version(UNICODE) {
	alias OpenWaitableTimerW OpenWaitableTimer;
}
else {
	alias OpenWaitableTimerA OpenWaitableTimer;
}

BOOL
SetWaitableTimer(
    __in     HANDLE hTimer,
    __in     const LARGE_INTEGER *lpDueTime,
    __in     LONG lPeriod,
    __in_opt PTIMERAPCROUTINE pfnCompletionRoutine,
    __in_opt LPVOID lpArgToCompletionRoutine,
    __in     BOOL fResume
    );

BOOL
CancelWaitableTimer(
    __in HANDLE hTimer
    );

#if (_WIN32_WINNT >= 0x0600)

const auto CREATE_MUTEX_INITIAL_OWNER   = 0x00000001;

__out_opt
HANDLE
CreateMutexExA(
    __in_opt LPSECURITY_ATTRIBUTES lpMutexAttributes,
    __in_opt LPCSTR lpName,
    __in     DWORD dwFlags,
    __in     DWORD dwDesiredAccess
    );
__out_opt
HANDLE
CreateMutexExW(
    __in_opt LPSECURITY_ATTRIBUTES lpMutexAttributes,
    __in_opt LPCWSTR lpName,
    __in     DWORD dwFlags,
    __in     DWORD dwDesiredAccess
    );

version(UNICODE) {
	alias CreateMutexExW CreateMutexEx;
}
else {
	alias CreateMutexExA CreateMutexEx;
}

const auto CREATE_EVENT_MANUAL_RESET    = 0x00000001;
const auto CREATE_EVENT_INITIAL_SET     = 0x00000002;

__out_opt
HANDLE
CreateEventExA(
    __in_opt LPSECURITY_ATTRIBUTES lpEventAttributes,
    __in_opt LPCSTR lpName,
    __in     DWORD dwFlags,
    __in     DWORD dwDesiredAccess
    );
__out_opt
HANDLE
CreateEventExW(
    __in_opt LPSECURITY_ATTRIBUTES lpEventAttributes,
    __in_opt LPCWSTR lpName,
    __in     DWORD dwFlags,
    __in     DWORD dwDesiredAccess
    );

version(UNICODE) {
	alias CreateEventExW CreateEventEx;
}
else {
	alias CreateEventExA CreateEventEx;
}

__out_opt
HANDLE
CreateSemaphoreExA(
    __in_opt    LPSECURITY_ATTRIBUTES lpSemaphoreAttributes,
    __in        LONG lInitialCount,
    __in        LONG lMaximumCount,
    __in_opt    LPCSTR lpName,
    __reserved  DWORD dwFlags,
    __in        DWORD dwDesiredAccess
    );
__out_opt
HANDLE
CreateSemaphoreExW(
    __in_opt    LPSECURITY_ATTRIBUTES lpSemaphoreAttributes,
    __in        LONG lInitialCount,
    __in        LONG lMaximumCount,
    __in_opt    LPCWSTR lpName,
    __reserved  DWORD dwFlags,
    __in        DWORD dwDesiredAccess
    );

version(UNICODE) {
	alias CreateSemaphoreExW CreateSemaphoreEx;
}
else {
	alias CreateSemaphoreExA CreateSemaphoreEx;
}

const auto CREATE_WAITABLE_TIMER_MANUAL_RESET   = 0x00000001;

__out_opt
HANDLE
CreateWaitableTimerExA(
    __in_opt LPSECURITY_ATTRIBUTES lpTimerAttributes,
    __in_opt LPCSTR lpTimerName,
    __in     DWORD dwFlags,
    __in     DWORD dwDesiredAccess
    );
__out_opt
HANDLE
CreateWaitableTimerExW(
    __in_opt LPSECURITY_ATTRIBUTES lpTimerAttributes,
    __in_opt LPCWSTR lpTimerName,
    __in     DWORD dwFlags,
    __in     DWORD dwDesiredAccess
    );

version(UNICODE) {
	alias CreateWaitableTimerExW CreateWaitableTimerEx;
}
else {
	alias CreateWaitableTimerExA CreateWaitableTimerEx;
}

#endif /* (_WIN32_WINNT >= 0x0600) */

#endif /* (_WIN32_WINNT >= 0x0400) || (_WIN32_WINDOWS > 0x0400) */

__out_opt
HANDLE
CreateFileMappingA(
    __in     HANDLE hFile,
    __in_opt LPSECURITY_ATTRIBUTES lpFileMappingAttributes,
    __in     DWORD flProtect,
    __in     DWORD dwMaximumSizeHigh,
    __in     DWORD dwMaximumSizeLow,
    __in_opt LPCSTR lpName
    );
__out_opt
HANDLE
CreateFileMappingW(
    __in     HANDLE hFile,
    __in_opt LPSECURITY_ATTRIBUTES lpFileMappingAttributes,
    __in     DWORD flProtect,
    __in     DWORD dwMaximumSizeHigh,
    __in     DWORD dwMaximumSizeLow,
    __in_opt LPCWSTR lpName
    );

version(UNICODE) {
	alias CreateFileMappingW CreateFileMapping;
}
else {
	alias CreateFileMappingA CreateFileMapping;
}

#if _WIN32_WINNT >= 0x0600

__out_opt
HANDLE
CreateFileMappingNumaA(
    __in     HANDLE hFile,
    __in_opt LPSECURITY_ATTRIBUTES lpFileMappingAttributes,
    __in     DWORD flProtect,
    __in     DWORD dwMaximumSizeHigh,
    __in     DWORD dwMaximumSizeLow,
    __in_opt LPCSTR lpName,
    __in     DWORD nndPreferred
    );
__out_opt
HANDLE
CreateFileMappingNumaW(
    __in     HANDLE hFile,
    __in_opt LPSECURITY_ATTRIBUTES lpFileMappingAttributes,
    __in     DWORD flProtect,
    __in     DWORD dwMaximumSizeHigh,
    __in     DWORD dwMaximumSizeLow,
    __in_opt LPCWSTR lpName,
    __in     DWORD nndPreferred
    );

version(UNICODE) {
	alias CreateFileMappingNumaW CreateFileMappingNuma;
}
else {
	alias CreateFileMappingNumaA CreateFileMappingNuma;
}

#endif // _WIN32_WINNT >= 0x0600

__out
HANDLE
OpenFileMappingA(
    __in DWORD dwDesiredAccess,
    __in BOOL bInheritHandle,
    __in LPCSTR lpName
    );
__out
HANDLE
OpenFileMappingW(
    __in DWORD dwDesiredAccess,
    __in BOOL bInheritHandle,
    __in LPCWSTR lpName
    );

version(UNICODE) {
	alias OpenFileMappingW OpenFileMapping;
}
else {
	alias OpenFileMappingA OpenFileMapping;
}

DWORD
GetLogicalDriveStringsA(
    __in DWORD nBufferLength,
    __out_ecount_part_opt(nBufferLength, return + 1) LPSTR lpBuffer
    );
DWORD
GetLogicalDriveStringsW(
    __in DWORD nBufferLength,
    __out_ecount_part_opt(nBufferLength, return + 1) LPWSTR lpBuffer
    );

version(UNICODE) {
	alias GetLogicalDriveStringsW GetLogicalDriveStrings;
}
else {
	alias GetLogicalDriveStringsA GetLogicalDriveStrings;
}

#if _WIN32_WINNT >= 0x0501

typedef enum _MEMORY_RESOURCE_NOTIFICATION_TYPE {
    LowMemoryResourceNotification,
    HighMemoryResourceNotification
} MEMORY_RESOURCE_NOTIFICATION_TYPE;

__out_opt
HANDLE
CreateMemoryResourceNotification(
    __in MEMORY_RESOURCE_NOTIFICATION_TYPE NotificationType
    );

BOOL
QueryMemoryResourceNotification(
    __in  HANDLE ResourceNotificationHandle,
    __out PBOOL  ResourceState
    );

#endif // _WIN32_WINNT >= 0x0501


__out_opt
HMODULE
LoadLibraryA(
    __in LPCSTR lpLibFileName
    );
__out_opt
HMODULE
LoadLibraryW(
    __in LPCWSTR lpLibFileName
    );

version(UNICODE) {
	alias LoadLibraryW LoadLibrary;
}
else {
	alias LoadLibraryA LoadLibrary;
}

__out_opt
HMODULE
LoadLibraryExA(
    __in       LPCSTR lpLibFileName,
    __reserved HANDLE hFile,
    __in       DWORD dwFlags
    );
__out_opt
HMODULE
LoadLibraryExW(
    __in       LPCWSTR lpLibFileName,
    __reserved HANDLE hFile,
    __in       DWORD dwFlags
    );

version(UNICODE) {
	alias LoadLibraryExW LoadLibraryEx;
}
else {
	alias LoadLibraryExA LoadLibraryEx;
}


const auto DONT_RESOLVE_DLL_REFERENCES          = 0x00000001;
const auto LOAD_LIBRARY_AS_DATAFILE             = 0x00000002;
const auto LOAD_WITH_ALTERED_SEARCH_PATH        = 0x00000008;
const auto LOAD_IGNORE_CODE_AUTHZ_LEVEL         = 0x00000010;
const auto LOAD_LIBRARY_AS_IMAGE_RESOURCE       = 0x00000020;
const auto LOAD_LIBRARY_AS_DATAFILE_EXCLUSIVE   = 0x00000040;

DWORD
GetModuleFileNameA(
    __in_opt HMODULE hModule,
    __out_ecount_part(nSize, return + 1) LPCH lpFilename,
    __in     DWORD nSize
    );
DWORD
GetModuleFileNameW(
    __in_opt HMODULE hModule,
    __out_ecount_part(nSize, return + 1) LPWCH lpFilename,
    __in     DWORD nSize
    );

version(UNICODE) {
	alias GetModuleFileNameW GetModuleFileName;
}
else {
	alias GetModuleFileNameA GetModuleFileName;
}

__out_opt
HMODULE
GetModuleHandleA(
    __in_opt LPCSTR lpModuleName
    );
__out_opt
HMODULE
GetModuleHandleW(
    __in_opt LPCWSTR lpModuleName
    );

version(UNICODE) {
	alias GetModuleHandleW GetModuleHandle;
}
else {
	alias GetModuleHandleA GetModuleHandle;
}

#if !defined(RC_INVOKED)
#if _WIN32_WINNT > 0x0500 || defined(WINBASE_DECLARE_GET_MODULE_HANDLE_EX) || ISOLATION_AWARE_ENABLED

const auto GET_MODULE_HANDLE_EX_FLAG_PIN                  = (0x00000001);
const auto GET_MODULE_HANDLE_EX_FLAG_UNCHANGED_REFCOUNT   = (0x00000002);
const auto GET_MODULE_HANDLE_EX_FLAG_FROM_ADDRESS         = (0x00000004);

typedef
BOOL
(WINAPI*
PGET_MODULE_HANDLE_EXA)(
    __in        DWORD        dwFlags,
    __in_opt    LPCSTR     lpModuleName,
    __deref_out HMODULE*    phModule
    );
typedef
BOOL
(WINAPI*
PGET_MODULE_HANDLE_EXW)(
    __in        DWORD        dwFlags,
    __in_opt    LPCWSTR     lpModuleName,
    __deref_out HMODULE*    phModule
    );

version(UNICODE) {
	alias PGET_MODULE_HANDLE_EXW PGET_MODULE_HANDLE_EX;
}
else {
	alias PGET_MODULE_HANDLE_EXA PGET_MODULE_HANDLE_EX;
}

BOOL
GetModuleHandleExA(
    __in        DWORD    dwFlags,
    __in_opt    LPCSTR lpModuleName,
    __out HMODULE* phModule
    );
BOOL
GetModuleHandleExW(
    __in        DWORD    dwFlags,
    __in_opt    LPCWSTR lpModuleName,
    __out HMODULE* phModule
    );

version(UNICODE) {
	alias GetModuleHandleExW GetModuleHandleEx;
}
else {
	alias GetModuleHandleExA GetModuleHandleEx;
}

#endif
#endif

#if _WIN32_WINNT >= 0x0502

BOOL
NeedCurrentDirectoryForExePathA(
    __in LPCSTR ExeName
    );
BOOL
NeedCurrentDirectoryForExePathW(
    __in LPCWSTR ExeName
    );

version(UNICODE) {
	alias NeedCurrentDirectoryForExePathW NeedCurrentDirectoryForExePath;
}
else {
	alias NeedCurrentDirectoryForExePathA NeedCurrentDirectoryForExePath;
}

#endif

#if _WIN32_WINNT >= 0x0600

const auto PROCESS_NAME_NATIVE      = 0x00000001;

BOOL
QueryFullProcessImageNameA(
    __in HANDLE hProcess,
    __in DWORD dwFlags,
    __out_ecount_part(*lpdwSize, *lpdwSize) LPSTR lpExeName,
    __inout PDWORD lpdwSize
    );
BOOL
QueryFullProcessImageNameW(
    __in HANDLE hProcess,
    __in DWORD dwFlags,
    __out_ecount_part(*lpdwSize, *lpdwSize) LPWSTR lpExeName,
    __inout PDWORD lpdwSize
    );

version(UNICODE) {
	alias QueryFullProcessImageNameW QueryFullProcessImageName;
}
else {
	alias QueryFullProcessImageNameA QueryFullProcessImageName;
}

#endif

//
// Extended process and thread attribute support
//

const auto PROC_THREAD_ATTRIBUTE_NUMBER     = 0x0000FFFF;
const auto PROC_THREAD_ATTRIBUTE_THREAD     = 0x00010000  ; // Attribute may be used with thread creation
const auto PROC_THREAD_ATTRIBUTE_INPUT      = 0x00020000  ; // Attribute is input only
const auto PROC_THREAD_ATTRIBUTE_ADDITIVE   = 0x00040000  ; // Attribute may be "accumulated," e.g. bitmasks, counters, etc.

typedef enum _PROC_THREAD_ATTRIBUTE_NUM {
    ProcThreadAttributeParentProcess = 0,
    ProcThreadAttributeExtendedFlags,
    ProcThreadAttributeHandleList,
    ProcThreadAttributeMax
} PROC_THREAD_ATTRIBUTE_NUM;

const auto ProcThreadAttributeValue(Number,  = Thread, Input, Additive) \;
    (((Number) & PROC_THREAD_ATTRIBUTE_NUMBER) | \
     ((Thread != FALSE) ? PROC_THREAD_ATTRIBUTE_THREAD : 0) | \
     ((Input != FALSE) ? PROC_THREAD_ATTRIBUTE_INPUT : 0) | \
     ((Additive != FALSE) ? PROC_THREAD_ATTRIBUTE_ADDITIVE : 0))

const auto PROC_THREAD_ATTRIBUTE_PARENT_PROCESS  = \;
    ProcThreadAttributeValue (ProcThreadAttributeParentProcess, FALSE, TRUE, FALSE)
const auto PROC_THREAD_ATTRIBUTE_EXTENDED_FLAGS  = \;
    ProcThreadAttributeValue (ProcThreadAttributeExtendedFlags, FALSE, TRUE, TRUE)
const auto PROC_THREAD_ATTRIBUTE_HANDLE_LIST  = \;
    ProcThreadAttributeValue (ProcThreadAttributeHandleList, FALSE, TRUE, FALSE)

typedef struct _PROC_THREAD_ATTRIBUTE_LIST *PPROC_THREAD_ATTRIBUTE_LIST, *LPPROC_THREAD_ATTRIBUTE_LIST;


BOOL
InitializeProcThreadAttributeList(
    __out_xcount_opt(*lpSize) LPPROC_THREAD_ATTRIBUTE_LIST lpAttributeList,
    __in DWORD dwAttributeCount,
    __in __reserved DWORD dwFlags,
    __inout PSIZE_T lpSize
    );

VOID
DeleteProcThreadAttributeList(
    __inout LPPROC_THREAD_ATTRIBUTE_LIST lpAttributeList
    );

const auto PROC_THREAD_ATTRIBUTE_REPLACE_VALUE      = 0x00000001;

BOOL
UpdateProcThreadAttribute(
    __inout LPPROC_THREAD_ATTRIBUTE_LIST lpAttributeList,
    __in DWORD dwFlags,
    __in DWORD_PTR Attribute,
    __in_bcount_opt(cbSize) PVOID lpValue,
    __in SIZE_T cbSize,
    __out_bcount_opt(cbSize) PVOID lpPreviousValue,
    __in_opt PSIZE_T lpReturnSize
    );


BOOL
CreateProcessA(
    __in_opt    LPCSTR lpApplicationName,
    __inout_opt LPSTR lpCommandLine,
    __in_opt    LPSECURITY_ATTRIBUTES lpProcessAttributes,
    __in_opt    LPSECURITY_ATTRIBUTES lpThreadAttributes,
    __in        BOOL bInheritHandles,
    __in        DWORD dwCreationFlags,
    __in_opt    LPVOID lpEnvironment,
    __in_opt    LPCSTR lpCurrentDirectory,
    __in        LPSTARTUPINFOA lpStartupInfo,
    __out       LPPROCESS_INFORMATION lpProcessInformation
    );
BOOL
CreateProcessW(
    __in_opt    LPCWSTR lpApplicationName,
    __inout_opt LPWSTR lpCommandLine,
    __in_opt    LPSECURITY_ATTRIBUTES lpProcessAttributes,
    __in_opt    LPSECURITY_ATTRIBUTES lpThreadAttributes,
    __in        BOOL bInheritHandles,
    __in        DWORD dwCreationFlags,
    __in_opt    LPVOID lpEnvironment,
    __in_opt    LPCWSTR lpCurrentDirectory,
    __in        LPSTARTUPINFOW lpStartupInfo,
    __out       LPPROCESS_INFORMATION lpProcessInformation
    );

version(UNICODE) {
	alias CreateProcessW CreateProcess;
}
else {
	alias CreateProcessA CreateProcess;
}



BOOL
SetProcessShutdownParameters(
    __in DWORD dwLevel,
    __in DWORD dwFlags
    );

BOOL
GetProcessShutdownParameters(
    __out LPDWORD lpdwLevel,
    __out LPDWORD lpdwFlags
    );

DWORD
GetProcessVersion(
    __in DWORD ProcessId
    );

VOID
FatalAppExitA(
    __in UINT uAction,
    __in LPCSTR lpMessageText
    );
VOID
FatalAppExitW(
    __in UINT uAction,
    __in LPCWSTR lpMessageText
    );

version(UNICODE) {
	alias FatalAppExitW FatalAppExit;
}
else {
	alias FatalAppExitA FatalAppExit;
}

VOID
GetStartupInfoA(
    __out LPSTARTUPINFOA lpStartupInfo
    );
VOID
GetStartupInfoW(
    __out LPSTARTUPINFOW lpStartupInfo
    );

version(UNICODE) {
	alias GetStartupInfoW GetStartupInfo;
}
else {
	alias GetStartupInfoA GetStartupInfo;
}

__out
LPSTR
GetCommandLineA(
    VOID
    );
__out
LPWSTR
GetCommandLineW(
    VOID
    );

version(UNICODE) {
	alias GetCommandLineW GetCommandLine;
}
else {
	alias GetCommandLineA GetCommandLine;
}

__success(return < nSize)
__success(return != 0)
DWORD
GetEnvironmentVariableA(
    __in_opt LPCSTR lpName,
    __out_ecount_part_opt(nSize, return + 1) LPSTR lpBuffer,
    __in DWORD nSize
    );
__success(return < nSize)
__success(return != 0)
DWORD
GetEnvironmentVariableW(
    __in_opt LPCWSTR lpName,
    __out_ecount_part_opt(nSize, return + 1) LPWSTR lpBuffer,
    __in DWORD nSize
    );

version(UNICODE) {
	alias GetEnvironmentVariableW GetEnvironmentVariable;
}
else {
	alias GetEnvironmentVariableA GetEnvironmentVariable;
}

BOOL
SetEnvironmentVariableA(
    __in     LPCSTR lpName,
    __in_opt LPCSTR lpValue
    );
BOOL
SetEnvironmentVariableW(
    __in     LPCWSTR lpName,
    __in_opt LPCWSTR lpValue
    );

version(UNICODE) {
	alias SetEnvironmentVariableW SetEnvironmentVariable;
}
else {
	alias SetEnvironmentVariableA SetEnvironmentVariable;
}

#if defined(_M_CEE)
#undef SetEnvironmentVariable
__inline
BOOL
SetEnvironmentVariable(
    LPCTSTR lpName,
    LPCTSTR lpValue
    )
{

version(UNICODE) {
	    return SetEnvironmentVariableW(
}
else {
	    return SetEnvironmentVariableA(
}
        lpName,
        lpValue
        );
}
#endif  /* _M_CEE */

__success(return <= nSize)
__success(return != 0)
DWORD
ExpandEnvironmentStringsA(
    __in LPCSTR lpSrc,
    __out_ecount_part_opt(nSize, return) LPSTR lpDst,
    __in DWORD nSize
    );
__success(return <= nSize)
__success(return != 0)
DWORD
ExpandEnvironmentStringsW(
    __in LPCWSTR lpSrc,
    __out_ecount_part_opt(nSize, return) LPWSTR lpDst,
    __in DWORD nSize
    );

version(UNICODE) {
	alias ExpandEnvironmentStringsW ExpandEnvironmentStrings;
}
else {
	alias ExpandEnvironmentStringsA ExpandEnvironmentStrings;
}

DWORD
GetFirmwareEnvironmentVariableA(
    __in LPCSTR lpName,
    __in LPCSTR lpGuid,
    __out_bcount_part_opt(nSize, return) PVOID pBuffer,
    __in DWORD    nSize
    );
DWORD
GetFirmwareEnvironmentVariableW(
    __in LPCWSTR lpName,
    __in LPCWSTR lpGuid,
    __out_bcount_part_opt(nSize, return) PVOID pBuffer,
    __in DWORD    nSize
    );

version(UNICODE) {
	alias GetFirmwareEnvironmentVariableW GetFirmwareEnvironmentVariable;
}
else {
	alias GetFirmwareEnvironmentVariableA GetFirmwareEnvironmentVariable;
}

BOOL
SetFirmwareEnvironmentVariableA(
    __in LPCSTR lpName,
    __in LPCSTR lpGuid,
    __in_bcount_opt(nSize) PVOID pValue,
    __in DWORD    nSize
    );
BOOL
SetFirmwareEnvironmentVariableW(
    __in LPCWSTR lpName,
    __in LPCWSTR lpGuid,
    __in_bcount_opt(nSize) PVOID pValue,
    __in DWORD    nSize
    );

version(UNICODE) {
	alias SetFirmwareEnvironmentVariableW SetFirmwareEnvironmentVariable;
}
else {
	alias SetFirmwareEnvironmentVariableA SetFirmwareEnvironmentVariable;
}


VOID
OutputDebugStringA(
    __in_opt LPCSTR lpOutputString
    );
VOID
OutputDebugStringW(
    __in_opt LPCWSTR lpOutputString
    );

version(UNICODE) {
	alias OutputDebugStringW OutputDebugString;
}
else {
	alias OutputDebugStringA OutputDebugString;
}

__out_opt
HRSRC
FindResourceA(
    __in_opt HMODULE hModule,
    __in     LPCSTR lpName,
    __in     LPCSTR lpType
    );
__out_opt
HRSRC
FindResourceW(
    __in_opt HMODULE hModule,
    __in     LPCWSTR lpName,
    __in     LPCWSTR lpType
    );

version(UNICODE) {
	alias FindResourceW FindResource;
}
else {
	alias FindResourceA FindResource;
}

__out_opt
HRSRC
FindResourceExA(
    __in_opt HMODULE hModule,
    __in     LPCSTR lpType,
    __in     LPCSTR lpName,
    __in     WORD    wLanguage
    );
__out_opt
HRSRC
FindResourceExW(
    __in_opt HMODULE hModule,
    __in     LPCWSTR lpType,
    __in     LPCWSTR lpName,
    __in     WORD    wLanguage
    );

version(UNICODE) {
	alias FindResourceExW FindResourceEx;
}
else {
	alias FindResourceExA FindResourceEx;
}

#ifdef STRICT
typedef BOOL (CALLBACK* ENUMRESTYPEPROCA)(__in_opt HMODULE hModule, __in LPSTR lpType,
__in LONG_PTR lParam);
typedef BOOL (CALLBACK* ENUMRESTYPEPROCW)(__in_opt HMODULE hModule, __in LPWSTR lpType,
__in LONG_PTR lParam);

version(UNICODE) {
	alias ENUMRESTYPEPROCW ENUMRESTYPEPROC;
}
else {
	alias ENUMRESTYPEPROCA ENUMRESTYPEPROC;
}
typedef BOOL (CALLBACK* ENUMRESNAMEPROCA)(__in_opt HMODULE hModule, __in LPCSTR lpType,
__in LPSTR lpName, __in LONG_PTR lParam);
typedef BOOL (CALLBACK* ENUMRESNAMEPROCW)(__in_opt HMODULE hModule, __in LPCWSTR lpType,
__in LPWSTR lpName, __in LONG_PTR lParam);

version(UNICODE) {
	alias ENUMRESNAMEPROCW ENUMRESNAMEPROC;
}
else {
	alias ENUMRESNAMEPROCA ENUMRESNAMEPROC;
}
typedef BOOL (CALLBACK* ENUMRESLANGPROCA)(__in_opt HMODULE hModule, __in LPCSTR lpType,
__in LPCSTR lpName, __in WORD  wLanguage, __in LONG_PTR lParam);
typedef BOOL (CALLBACK* ENUMRESLANGPROCW)(__in_opt HMODULE hModule, __in LPCWSTR lpType,
__in LPCWSTR lpName, __in WORD  wLanguage, __in LONG_PTR lParam);

version(UNICODE) {
	alias ENUMRESLANGPROCW ENUMRESLANGPROC;
}
else {
	alias ENUMRESLANGPROCA ENUMRESLANGPROC;
}
#else
typedef FARPROC ENUMRESTYPEPROCA;
typedef FARPROC ENUMRESTYPEPROCW;

version(UNICODE) {
	typedef ENUMRESTYPEPROCW ENUMRESTYPEPROC;
}
else {
	typedef ENUMRESTYPEPROCA ENUMRESTYPEPROC;
}
typedef FARPROC ENUMRESNAMEPROCA;
typedef FARPROC ENUMRESNAMEPROCW;

version(UNICODE) {
	typedef ENUMRESNAMEPROCW ENUMRESNAMEPROC;
}
else {
	typedef ENUMRESNAMEPROCA ENUMRESNAMEPROC;
}
typedef FARPROC ENUMRESLANGPROCA;
typedef FARPROC ENUMRESLANGPROCW;

version(UNICODE) {
	typedef ENUMRESLANGPROCW ENUMRESLANGPROC;
}
else {
	typedef ENUMRESLANGPROCA ENUMRESLANGPROC;
}
#endif

BOOL
EnumResourceTypesA(
    __in_opt HMODULE hModule,
    __in     ENUMRESTYPEPROCA lpEnumFunc,
    __in     LONG_PTR lParam
    );
BOOL
EnumResourceTypesW(
    __in_opt HMODULE hModule,
    __in     ENUMRESTYPEPROCW lpEnumFunc,
    __in     LONG_PTR lParam
    );

version(UNICODE) {
	alias EnumResourceTypesW EnumResourceTypes;
}
else {
	alias EnumResourceTypesA EnumResourceTypes;
}

BOOL
EnumResourceNamesA(
    __in_opt HMODULE hModule,
    __in     LPCSTR lpType,
    __in     ENUMRESNAMEPROCA lpEnumFunc,
    __in     LONG_PTR lParam
    );
BOOL
EnumResourceNamesW(
    __in_opt HMODULE hModule,
    __in     LPCWSTR lpType,
    __in     ENUMRESNAMEPROCW lpEnumFunc,
    __in     LONG_PTR lParam
    );

version(UNICODE) {
	alias EnumResourceNamesW EnumResourceNames;
}
else {
	alias EnumResourceNamesA EnumResourceNames;
}

BOOL
EnumResourceLanguagesA(
    __in_opt HMODULE hModule,
    __in     LPCSTR lpType,
    __in     LPCSTR lpName,
    __in     ENUMRESLANGPROCA lpEnumFunc,
    __in     LONG_PTR lParam
    );
BOOL
EnumResourceLanguagesW(
    __in_opt HMODULE hModule,
    __in     LPCWSTR lpType,
    __in     LPCWSTR lpName,
    __in     ENUMRESLANGPROCW lpEnumFunc,
    __in     LONG_PTR lParam
    );

version(UNICODE) {
	alias EnumResourceLanguagesW EnumResourceLanguages;
}
else {
	alias EnumResourceLanguagesA EnumResourceLanguages;
}

const auto   = RESOURCE_ENUM_LN               (0x0001);
const auto   = RESOURCE_ENUM_MUI              (0x0002);
const auto   = RESOURCE_ENUM_MUI_SYSTEM       (0x0004);
const auto   = RESOURCE_UPDATE_LN             (0x0010);
const auto   = RESOURCE_UPDATE_MUI            (0x0020);

BOOL
EnumResourceTypesExA(
    __in_opt HMODULE hModule,
    __in ENUMRESTYPEPROCA lpEnumFunc,
    __in LONG_PTR lParam,
    DWORD dwFlags,
    LANGID LangId
    );
BOOL
EnumResourceTypesExW(
    __in_opt HMODULE hModule,
    __in ENUMRESTYPEPROCW lpEnumFunc,
    __in LONG_PTR lParam,
    DWORD dwFlags,
    LANGID LangId
    );

version(UNICODE) {
	alias EnumResourceTypesExW EnumResourceTypesEx;
}
else {
	alias EnumResourceTypesExA EnumResourceTypesEx;
}


BOOL
EnumResourceNamesExA(
    __in_opt HMODULE hModule,
    __in LPCSTR lpType,
    __in ENUMRESNAMEPROCA lpEnumFunc,
    __in LONG_PTR lParam,
    DWORD dwFlags,
    LANGID LangId
    );
BOOL
EnumResourceNamesExW(
    __in_opt HMODULE hModule,
    __in LPCWSTR lpType,
    __in ENUMRESNAMEPROCW lpEnumFunc,
    __in LONG_PTR lParam,
    DWORD dwFlags,
    LANGID LangId
    );

version(UNICODE) {
	alias EnumResourceNamesExW EnumResourceNamesEx;
}
else {
	alias EnumResourceNamesExA EnumResourceNamesEx;
}

BOOL
EnumResourceLanguagesExA(
    __in_opt HMODULE hModule,
    __in LPCSTR lpType,
    __in LPCSTR lpName,
    __in ENUMRESLANGPROCA lpEnumFunc,
    __in LONG_PTR lParam,
    DWORD dwFlags,
    LANGID LangId
    );
BOOL
EnumResourceLanguagesExW(
    __in_opt HMODULE hModule,
    __in LPCWSTR lpType,
    __in LPCWSTR lpName,
    __in ENUMRESLANGPROCW lpEnumFunc,
    __in LONG_PTR lParam,
    DWORD dwFlags,
    LANGID LangId
    );

version(UNICODE) {
	alias EnumResourceLanguagesExW EnumResourceLanguagesEx;
}
else {
	alias EnumResourceLanguagesExA EnumResourceLanguagesEx;
}

HANDLE
BeginUpdateResourceA(
    __in LPCSTR pFileName,
    __in BOOL bDeleteExistingResources
    );
HANDLE
BeginUpdateResourceW(
    __in LPCWSTR pFileName,
    __in BOOL bDeleteExistingResources
    );

version(UNICODE) {
	alias BeginUpdateResourceW BeginUpdateResource;
}
else {
	alias BeginUpdateResourceA BeginUpdateResource;
}

BOOL
UpdateResourceA(
    __in HANDLE hUpdate,
    __in LPCSTR lpType,
    __in LPCSTR lpName,
    __in WORD wLanguage,
    __in_bcount_opt(cb) LPVOID lpData,
    __in DWORD cb
    );
BOOL
UpdateResourceW(
    __in HANDLE hUpdate,
    __in LPCWSTR lpType,
    __in LPCWSTR lpName,
    __in WORD wLanguage,
    __in_bcount_opt(cb) LPVOID lpData,
    __in DWORD cb
    );

version(UNICODE) {
	alias UpdateResourceW UpdateResource;
}
else {
	alias UpdateResourceA UpdateResource;
}

BOOL
EndUpdateResourceA(
    __in HANDLE hUpdate,
    __in BOOL   fDiscard
    );
BOOL
EndUpdateResourceW(
    __in HANDLE hUpdate,
    __in BOOL   fDiscard
    );

version(UNICODE) {
	alias EndUpdateResourceW EndUpdateResource;
}
else {
	alias EndUpdateResourceA EndUpdateResource;
}


ATOM
GlobalAddAtomA(
    __in_opt LPCSTR lpString
    );
ATOM
GlobalAddAtomW(
    __in_opt LPCWSTR lpString
    );

version(UNICODE) {
	alias GlobalAddAtomW GlobalAddAtom;
}
else {
	alias GlobalAddAtomA GlobalAddAtom;
}

ATOM
GlobalFindAtomA(
    __in_opt LPCSTR lpString
    );
ATOM
GlobalFindAtomW(
    __in_opt LPCWSTR lpString
    );

version(UNICODE) {
	alias GlobalFindAtomW GlobalFindAtom;
}
else {
	alias GlobalFindAtomA GlobalFindAtom;
}

UINT
GlobalGetAtomNameA(
    __in ATOM nAtom,
    __out_ecount_part(nSize, return + 1) LPSTR lpBuffer,
    __in int nSize
    );
UINT
GlobalGetAtomNameW(
    __in ATOM nAtom,
    __out_ecount_part(nSize, return + 1) LPWSTR lpBuffer,
    __in int nSize
    );

version(UNICODE) {
	alias GlobalGetAtomNameW GlobalGetAtomName;
}
else {
	alias GlobalGetAtomNameA GlobalGetAtomName;
}

ATOM
AddAtomA(
    __in_opt LPCSTR lpString
    );
ATOM
AddAtomW(
    __in_opt LPCWSTR lpString
    );

version(UNICODE) {
	alias AddAtomW AddAtom;
}
else {
	alias AddAtomA AddAtom;
}

ATOM
FindAtomA(
    __in_opt LPCSTR lpString
    );
ATOM
FindAtomW(
    __in_opt LPCWSTR lpString
    );

version(UNICODE) {
	alias FindAtomW FindAtom;
}
else {
	alias FindAtomA FindAtom;
}

UINT
GetAtomNameA(
    __in ATOM nAtom,
    __out_ecount_part(nSize, return + 1) LPSTR lpBuffer,
    __in int nSize
    );
UINT
GetAtomNameW(
    __in ATOM nAtom,
    __out_ecount_part(nSize, return + 1) LPWSTR lpBuffer,
    __in int nSize
    );

version(UNICODE) {
	alias GetAtomNameW GetAtomName;
}
else {
	alias GetAtomNameA GetAtomName;
}

UINT
GetProfileIntA(
    __in LPCSTR lpAppName,
    __in LPCSTR lpKeyName,
    __in INT nDefault
    );
UINT
GetProfileIntW(
    __in LPCWSTR lpAppName,
    __in LPCWSTR lpKeyName,
    __in INT nDefault
    );

version(UNICODE) {
	alias GetProfileIntW GetProfileInt;
}
else {
	alias GetProfileIntA GetProfileInt;
}

DWORD
GetProfileStringA(
    __in_opt LPCSTR lpAppName,
    __in_opt LPCSTR lpKeyName,
    __in_opt LPCSTR lpDefault,
    __out_ecount_part_opt(nSize, return + 1) LPSTR lpReturnedString,
    __in     DWORD nSize
    );
DWORD
GetProfileStringW(
    __in_opt LPCWSTR lpAppName,
    __in_opt LPCWSTR lpKeyName,
    __in_opt LPCWSTR lpDefault,
    __out_ecount_part_opt(nSize, return + 1) LPWSTR lpReturnedString,
    __in     DWORD nSize
    );

version(UNICODE) {
	alias GetProfileStringW GetProfileString;
}
else {
	alias GetProfileStringA GetProfileString;
}

BOOL
WriteProfileStringA(
    __in_opt LPCSTR lpAppName,
    __in_opt LPCSTR lpKeyName,
    __in_opt LPCSTR lpString
    );
BOOL
WriteProfileStringW(
    __in_opt LPCWSTR lpAppName,
    __in_opt LPCWSTR lpKeyName,
    __in_opt LPCWSTR lpString
    );

version(UNICODE) {
	alias WriteProfileStringW WriteProfileString;
}
else {
	alias WriteProfileStringA WriteProfileString;
}

DWORD
GetProfileSectionA(
    __in LPCSTR lpAppName,
    __out_ecount_part_opt(nSize, return + 1) LPSTR lpReturnedString,
    __in DWORD nSize
    );
DWORD
GetProfileSectionW(
    __in LPCWSTR lpAppName,
    __out_ecount_part_opt(nSize, return + 1) LPWSTR lpReturnedString,
    __in DWORD nSize
    );

version(UNICODE) {
	alias GetProfileSectionW GetProfileSection;
}
else {
	alias GetProfileSectionA GetProfileSection;
}

BOOL
WriteProfileSectionA(
    __in LPCSTR lpAppName,
    __in LPCSTR lpString
    );
BOOL
WriteProfileSectionW(
    __in LPCWSTR lpAppName,
    __in LPCWSTR lpString
    );

version(UNICODE) {
	alias WriteProfileSectionW WriteProfileSection;
}
else {
	alias WriteProfileSectionA WriteProfileSection;
}

UINT
GetPrivateProfileIntA(
    __in     LPCSTR lpAppName,
    __in     LPCSTR lpKeyName,
    __in     INT nDefault,
    __in_opt LPCSTR lpFileName
    );
UINT
GetPrivateProfileIntW(
    __in     LPCWSTR lpAppName,
    __in     LPCWSTR lpKeyName,
    __in     INT nDefault,
    __in_opt LPCWSTR lpFileName
    );

version(UNICODE) {
	alias GetPrivateProfileIntW GetPrivateProfileInt;
}
else {
	alias GetPrivateProfileIntA GetPrivateProfileInt;
}

DWORD
GetPrivateProfileStringA(
    __in_opt LPCSTR lpAppName,
    __in_opt LPCSTR lpKeyName,
    __in_opt LPCSTR lpDefault,
    __out_ecount_part_opt(nSize, return + 1) LPSTR lpReturnedString,
    __in     DWORD nSize,
    __in_opt LPCSTR lpFileName
    );
DWORD
GetPrivateProfileStringW(
    __in_opt LPCWSTR lpAppName,
    __in_opt LPCWSTR lpKeyName,
    __in_opt LPCWSTR lpDefault,
    __out_ecount_part_opt(nSize, return + 1) LPWSTR lpReturnedString,
    __in     DWORD nSize,
    __in_opt LPCWSTR lpFileName
    );

version(UNICODE) {
	alias GetPrivateProfileStringW GetPrivateProfileString;
}
else {
	alias GetPrivateProfileStringA GetPrivateProfileString;
}

BOOL
WritePrivateProfileStringA(
    __in_opt LPCSTR lpAppName,
    __in_opt LPCSTR lpKeyName,
    __in_opt LPCSTR lpString,
    __in_opt LPCSTR lpFileName
    );
BOOL
WritePrivateProfileStringW(
    __in_opt LPCWSTR lpAppName,
    __in_opt LPCWSTR lpKeyName,
    __in_opt LPCWSTR lpString,
    __in_opt LPCWSTR lpFileName
    );

version(UNICODE) {
	alias WritePrivateProfileStringW WritePrivateProfileString;
}
else {
	alias WritePrivateProfileStringA WritePrivateProfileString;
}

DWORD
GetPrivateProfileSectionA(
    __in     LPCSTR lpAppName,
    __out_ecount_part_opt(nSize, return + 1) LPSTR lpReturnedString,
    __in     DWORD nSize,
    __in_opt LPCSTR lpFileName
    );
DWORD
GetPrivateProfileSectionW(
    __in     LPCWSTR lpAppName,
    __out_ecount_part_opt(nSize, return + 1) LPWSTR lpReturnedString,
    __in     DWORD nSize,
    __in_opt LPCWSTR lpFileName
    );

version(UNICODE) {
	alias GetPrivateProfileSectionW GetPrivateProfileSection;
}
else {
	alias GetPrivateProfileSectionA GetPrivateProfileSection;
}

BOOL
WritePrivateProfileSectionA(
    __in     LPCSTR lpAppName,
    __in     LPCSTR lpString,
    __in_opt LPCSTR lpFileName
    );
BOOL
WritePrivateProfileSectionW(
    __in     LPCWSTR lpAppName,
    __in     LPCWSTR lpString,
    __in_opt LPCWSTR lpFileName
    );

version(UNICODE) {
	alias WritePrivateProfileSectionW WritePrivateProfileSection;
}
else {
	alias WritePrivateProfileSectionA WritePrivateProfileSection;
}


DWORD
GetPrivateProfileSectionNamesA(
    __out_ecount_part_opt(nSize, return + 1) LPSTR lpszReturnBuffer,
    __in     DWORD nSize,
    __in_opt LPCSTR lpFileName
    );
DWORD
GetPrivateProfileSectionNamesW(
    __out_ecount_part_opt(nSize, return + 1) LPWSTR lpszReturnBuffer,
    __in     DWORD nSize,
    __in_opt LPCWSTR lpFileName
    );

version(UNICODE) {
	alias GetPrivateProfileSectionNamesW GetPrivateProfileSectionNames;
}
else {
	alias GetPrivateProfileSectionNamesA GetPrivateProfileSectionNames;
}

BOOL
GetPrivateProfileStructA(
    __in     LPCSTR lpszSection,
    __in     LPCSTR lpszKey,
    __out_bcount_opt(uSizeStruct) LPVOID   lpStruct,
    __in     UINT     uSizeStruct,
    __in_opt LPCSTR szFile
    );
BOOL
GetPrivateProfileStructW(
    __in     LPCWSTR lpszSection,
    __in     LPCWSTR lpszKey,
    __out_bcount_opt(uSizeStruct) LPVOID   lpStruct,
    __in     UINT     uSizeStruct,
    __in_opt LPCWSTR szFile
    );

version(UNICODE) {
	alias GetPrivateProfileStructW GetPrivateProfileStruct;
}
else {
	alias GetPrivateProfileStructA GetPrivateProfileStruct;
}

BOOL
WritePrivateProfileStructA(
    __in     LPCSTR lpszSection,
    __in     LPCSTR lpszKey,
    __in_bcount_opt(uSizeStruct) LPVOID lpStruct,
    __in     UINT     uSizeStruct,
    __in_opt LPCSTR szFile
    );
BOOL
WritePrivateProfileStructW(
    __in     LPCWSTR lpszSection,
    __in     LPCWSTR lpszKey,
    __in_bcount_opt(uSizeStruct) LPVOID lpStruct,
    __in     UINT     uSizeStruct,
    __in_opt LPCWSTR szFile
    );

version(UNICODE) {
	alias WritePrivateProfileStructW WritePrivateProfileStruct;
}
else {
	alias WritePrivateProfileStructA WritePrivateProfileStruct;
}


UINT
GetDriveTypeA(
    __in_opt LPCSTR lpRootPathName
    );
UINT
GetDriveTypeW(
    __in_opt LPCWSTR lpRootPathName
    );

version(UNICODE) {
	alias GetDriveTypeW GetDriveType;
}
else {
	alias GetDriveTypeA GetDriveType;
}

UINT
GetSystemDirectoryA(
    __out_ecount_part_opt(uSize, return + 1) LPSTR lpBuffer,
    __in UINT uSize
    );
UINT
GetSystemDirectoryW(
    __out_ecount_part_opt(uSize, return + 1) LPWSTR lpBuffer,
    __in UINT uSize
    );

version(UNICODE) {
	alias GetSystemDirectoryW GetSystemDirectory;
}
else {
	alias GetSystemDirectoryA GetSystemDirectory;
}

DWORD
GetTempPathA(
    __in DWORD nBufferLength,
    __out_ecount_part_opt(nBufferLength, return + 1) LPSTR lpBuffer
    );
DWORD
GetTempPathW(
    __in DWORD nBufferLength,
    __out_ecount_part_opt(nBufferLength, return + 1) LPWSTR lpBuffer
    );

version(UNICODE) {
	alias GetTempPathW GetTempPath;
}
else {
	alias GetTempPathA GetTempPath;
}

UINT
GetTempFileNameA(
    __in LPCSTR lpPathName,
    __in LPCSTR lpPrefixString,
    __in UINT uUnique,
    __out_ecount(MAX_PATH) LPSTR lpTempFileName
    );
UINT
GetTempFileNameW(
    __in LPCWSTR lpPathName,
    __in LPCWSTR lpPrefixString,
    __in UINT uUnique,
    __out_ecount(MAX_PATH) LPWSTR lpTempFileName
    );

version(UNICODE) {
	alias GetTempFileNameW GetTempFileName;
}
else {
	alias GetTempFileNameA GetTempFileName;
}

#if defined(_M_CEE)
#undef GetTempFileName
__inline
UINT
GetTempFileName(
    LPCTSTR lpPathName,
    LPCTSTR lpPrefixString,
    UINT uUnique,
    LPTSTR lpTempFileName
    )
{

version(UNICODE) {
	    return GetTempFileNameW(
}
else {
	    return GetTempFileNameA(
}
        lpPathName,
        lpPrefixString,
        uUnique,
        lpTempFileName
        );
}
#endif  /* _M_CEE */

UINT
GetWindowsDirectoryA(
    __out_ecount_part_opt(uSize, return + 1) LPSTR lpBuffer,
    __in UINT uSize
    );
UINT
GetWindowsDirectoryW(
    __out_ecount_part_opt(uSize, return + 1) LPWSTR lpBuffer,
    __in UINT uSize
    );

version(UNICODE) {
	alias GetWindowsDirectoryW GetWindowsDirectory;
}
else {
	alias GetWindowsDirectoryA GetWindowsDirectory;
}

UINT
GetSystemWindowsDirectoryA(
    __out_ecount_part_opt(uSize, return + 1) LPSTR lpBuffer,
    __in UINT uSize
    );
UINT
GetSystemWindowsDirectoryW(
    __out_ecount_part_opt(uSize, return + 1) LPWSTR lpBuffer,
    __in UINT uSize
    );

version(UNICODE) {
	alias GetSystemWindowsDirectoryW GetSystemWindowsDirectory;
}
else {
	alias GetSystemWindowsDirectoryA GetSystemWindowsDirectory;
}

#if !defined(RC_INVOKED) // RC warns because "WINBASE_DECLARE_GET_SYSTEM_WOW64_DIRECTORY" is a bit long.
#if _WIN32_WINNT >= 0x0501 || defined(WINBASE_DECLARE_GET_SYSTEM_WOW64_DIRECTORY)

UINT
GetSystemWow64DirectoryA(
    __out_ecount_part_opt(uSize, return + 1) LPSTR lpBuffer,
    __in UINT uSize
    );
UINT
GetSystemWow64DirectoryW(
    __out_ecount_part_opt(uSize, return + 1) LPWSTR lpBuffer,
    __in UINT uSize
    );

version(UNICODE) {
	alias GetSystemWow64DirectoryW GetSystemWow64Directory;
}
else {
	alias GetSystemWow64DirectoryA GetSystemWow64Directory;
}

BOOLEAN
Wow64EnableWow64FsRedirection (
    __in BOOLEAN Wow64FsEnableRedirection
    );

BOOL
Wow64DisableWow64FsRedirection (
    __out PVOID *OldValue
    );

BOOL
Wow64RevertWow64FsRedirection (
    __in PVOID OlValue
    );


//
// for GetProcAddress
//
typedef UINT (WINAPI* PGET_SYSTEM_WOW64_DIRECTORY_A)(__out_ecount_part_opt(uSize, return + 1) LPSTR lpBuffer, __in UINT uSize);
typedef UINT (WINAPI* PGET_SYSTEM_WOW64_DIRECTORY_W)(__out_ecount_part_opt(uSize, return + 1) LPWSTR lpBuffer, __in UINT uSize);

//
// GetProcAddress only accepts GET_SYSTEM_WOW64_DIRECTORY_NAME_A_A,
// GET_SYSTEM_WOW64_DIRECTORY_NAME_W_A, GET_SYSTEM_WOW64_DIRECTORY_NAME_T_A.
// The others are if you want to use the strings in some other way.
//
const auto GET_SYSTEM_WOW64_DIRECTORY_NAME_A_A       = "GetSystemWow64DirectoryA";
const auto GET_SYSTEM_WOW64_DIRECTORY_NAME_A_W      = L"GetSystemWow64DirectoryA";
const auto GET_SYSTEM_WOW64_DIRECTORY_NAME_A_T  = TEXT("GetSystemWow64DirectoryA");
const auto GET_SYSTEM_WOW64_DIRECTORY_NAME_W_A       = "GetSystemWow64DirectoryW";
const auto GET_SYSTEM_WOW64_DIRECTORY_NAME_W_W      = L"GetSystemWow64DirectoryW";
const auto GET_SYSTEM_WOW64_DIRECTORY_NAME_W_T  = TEXT("GetSystemWow64DirectoryW");


version(UNICODE) {
	alias GET_SYSTEM_WOW64_DIRECTORY_NAME_W_A GET_SYSTEM_WOW64_DIRECTORY_NAME_T_A;
	alias GET_SYSTEM_WOW64_DIRECTORY_NAME_W_W GET_SYSTEM_WOW64_DIRECTORY_NAME_T_W;
	alias GET_SYSTEM_WOW64_DIRECTORY_NAME_W_T GET_SYSTEM_WOW64_DIRECTORY_NAME_T_T;
}
else {
	alias GET_SYSTEM_WOW64_DIRECTORY_NAME_A_A GET_SYSTEM_WOW64_DIRECTORY_NAME_T_A;
	alias GET_SYSTEM_WOW64_DIRECTORY_NAME_A_W GET_SYSTEM_WOW64_DIRECTORY_NAME_T_W;
	alias GET_SYSTEM_WOW64_DIRECTORY_NAME_A_T GET_SYSTEM_WOW64_DIRECTORY_NAME_T_T;
}

#endif // _WIN32_WINNT >= 0x0501
#endif

BOOL
SetCurrentDirectoryA(
    __in LPCSTR lpPathName
    );
BOOL
SetCurrentDirectoryW(
    __in LPCWSTR lpPathName
    );

version(UNICODE) {
	alias SetCurrentDirectoryW SetCurrentDirectory;
}
else {
	alias SetCurrentDirectoryA SetCurrentDirectory;
}

#if defined(_M_CEE)
#undef SetCurrentDirectory
__inline
BOOL
SetCurrentDirectory(
    LPCTSTR lpPathName
    )
{

version(UNICODE) {
	    return SetCurrentDirectoryW(
}
else {
	    return SetCurrentDirectoryA(
}
        lpPathName
        );
}
#endif  /* _M_CEE */

DWORD
GetCurrentDirectoryA(
    __in DWORD nBufferLength,
    __out_ecount_part_opt(nBufferLength, return + 1) LPSTR lpBuffer
    );
DWORD
GetCurrentDirectoryW(
    __in DWORD nBufferLength,
    __out_ecount_part_opt(nBufferLength, return + 1) LPWSTR lpBuffer
    );

version(UNICODE) {
	alias GetCurrentDirectoryW GetCurrentDirectory;
}
else {
	alias GetCurrentDirectoryA GetCurrentDirectory;
}

#if _WIN32_WINNT >= 0x0502

BOOL
SetDllDirectoryA(
    __in_opt LPCSTR lpPathName
    );
BOOL
SetDllDirectoryW(
    __in_opt LPCWSTR lpPathName
    );

version(UNICODE) {
	alias SetDllDirectoryW SetDllDirectory;
}
else {
	alias SetDllDirectoryA SetDllDirectory;
}

DWORD
GetDllDirectoryA(
    __in DWORD nBufferLength,
    __out_ecount_part_opt(nBufferLength, return + 1) LPSTR lpBuffer
    );
DWORD
GetDllDirectoryW(
    __in DWORD nBufferLength,
    __out_ecount_part_opt(nBufferLength, return + 1) LPWSTR lpBuffer
    );

version(UNICODE) {
	alias GetDllDirectoryW GetDllDirectory;
}
else {
	alias GetDllDirectoryA GetDllDirectory;
}

#endif // _WIN32_WINNT >= 0x0502

BOOL
GetDiskFreeSpaceA(
    __in_opt  LPCSTR lpRootPathName,
    __out_opt LPDWORD lpSectorsPerCluster,
    __out_opt LPDWORD lpBytesPerSector,
    __out_opt LPDWORD lpNumberOfFreeClusters,
    __out_opt LPDWORD lpTotalNumberOfClusters
    );
BOOL
GetDiskFreeSpaceW(
    __in_opt  LPCWSTR lpRootPathName,
    __out_opt LPDWORD lpSectorsPerCluster,
    __out_opt LPDWORD lpBytesPerSector,
    __out_opt LPDWORD lpNumberOfFreeClusters,
    __out_opt LPDWORD lpTotalNumberOfClusters
    );

version(UNICODE) {
	alias GetDiskFreeSpaceW GetDiskFreeSpace;
}
else {
	alias GetDiskFreeSpaceA GetDiskFreeSpace;
}

BOOL
GetDiskFreeSpaceExA(
    __in_opt  LPCSTR lpDirectoryName,
    __out_opt PULARGE_INTEGER lpFreeBytesAvailableToCaller,
    __out_opt PULARGE_INTEGER lpTotalNumberOfBytes,
    __out_opt PULARGE_INTEGER lpTotalNumberOfFreeBytes
    );
BOOL
GetDiskFreeSpaceExW(
    __in_opt  LPCWSTR lpDirectoryName,
    __out_opt PULARGE_INTEGER lpFreeBytesAvailableToCaller,
    __out_opt PULARGE_INTEGER lpTotalNumberOfBytes,
    __out_opt PULARGE_INTEGER lpTotalNumberOfFreeBytes
    );

version(UNICODE) {
	alias GetDiskFreeSpaceExW GetDiskFreeSpaceEx;
}
else {
	alias GetDiskFreeSpaceExA GetDiskFreeSpaceEx;
}

BOOL
CreateDirectoryA(
    __in     LPCSTR lpPathName,
    __in_opt LPSECURITY_ATTRIBUTES lpSecurityAttributes
    );
BOOL
CreateDirectoryW(
    __in     LPCWSTR lpPathName,
    __in_opt LPSECURITY_ATTRIBUTES lpSecurityAttributes
    );

version(UNICODE) {
	alias CreateDirectoryW CreateDirectory;
}
else {
	alias CreateDirectoryA CreateDirectory;
}

#if defined(_M_CEE)
#undef CreateDirectory
__inline
BOOL
CreateDirectory(
    LPCTSTR lpPathName,
    LPSECURITY_ATTRIBUTES lpSecurityAttributes
    )
{

version(UNICODE) {
	    return CreateDirectoryW(
}
else {
	    return CreateDirectoryA(
}
        lpPathName,
        lpSecurityAttributes
        );
}
#endif  /* _M_CEE */

BOOL
CreateDirectoryExA(
    __in     LPCSTR lpTemplateDirectory,
    __in     LPCSTR lpNewDirectory,
    __in_opt LPSECURITY_ATTRIBUTES lpSecurityAttributes
    );
BOOL
CreateDirectoryExW(
    __in     LPCWSTR lpTemplateDirectory,
    __in     LPCWSTR lpNewDirectory,
    __in_opt LPSECURITY_ATTRIBUTES lpSecurityAttributes
    );

version(UNICODE) {
	alias CreateDirectoryExW CreateDirectoryEx;
}
else {
	alias CreateDirectoryExA CreateDirectoryEx;
}

#if _WIN32_WINNT >= 0x0600

BOOL
CreateDirectoryTransactedA(
    __in     LPCSTR lpTemplateDirectory,
    __in     LPCSTR lpNewDirectory,
    __in_opt LPSECURITY_ATTRIBUTES lpSecurityAttributes,
    __in     HANDLE hTransaction
    );
BOOL
CreateDirectoryTransactedW(
    __in     LPCWSTR lpTemplateDirectory,
    __in     LPCWSTR lpNewDirectory,
    __in_opt LPSECURITY_ATTRIBUTES lpSecurityAttributes,
    __in     HANDLE hTransaction
    );

version(UNICODE) {
	alias CreateDirectoryTransactedW CreateDirectoryTransacted;
}
else {
	alias CreateDirectoryTransactedA CreateDirectoryTransacted;
}

#endif // _WIN32_WINNT >= 0x0600

BOOL
RemoveDirectoryA(
    __in LPCSTR lpPathName
    );
BOOL
RemoveDirectoryW(
    __in LPCWSTR lpPathName
    );

version(UNICODE) {
	alias RemoveDirectoryW RemoveDirectory;
}
else {
	alias RemoveDirectoryA RemoveDirectory;
}

#if _WIN32_WINNT >= 0x0600

BOOL
RemoveDirectoryTransactedA(
    __in LPCSTR lpPathName,
    __in     HANDLE hTransaction
    );
BOOL
RemoveDirectoryTransactedW(
    __in LPCWSTR lpPathName,
    __in     HANDLE hTransaction
    );

version(UNICODE) {
	alias RemoveDirectoryTransactedW RemoveDirectoryTransacted;
}
else {
	alias RemoveDirectoryTransactedA RemoveDirectoryTransacted;
}

#endif // _WIN32_WINNT >= 0x0600

DWORD
GetFullPathNameA(
    __in            LPCSTR lpFileName,
    __in            DWORD nBufferLength,
    __out_ecount_part_opt(nBufferLength, return + 1) LPSTR lpBuffer,
    __deref_opt_out LPSTR *lpFilePart
    );
DWORD
GetFullPathNameW(
    __in            LPCWSTR lpFileName,
    __in            DWORD nBufferLength,
    __out_ecount_part_opt(nBufferLength, return + 1) LPWSTR lpBuffer,
    __deref_opt_out LPWSTR *lpFilePart
    );

version(UNICODE) {
	alias GetFullPathNameW GetFullPathName;
}
else {
	alias GetFullPathNameA GetFullPathName;
}
#if _WIN32_WINNT >= 0x0600

DWORD
GetFullPathNameTransactedA(
    __in            LPCSTR lpFileName,
    __in            DWORD nBufferLength,
    __out_ecount_part_opt(nBufferLength, return + 1) LPSTR lpBuffer,
    __deref_opt_out LPSTR *lpFilePart,
    __in            HANDLE hTransaction
    );
DWORD
GetFullPathNameTransactedW(
    __in            LPCWSTR lpFileName,
    __in            DWORD nBufferLength,
    __out_ecount_part_opt(nBufferLength, return + 1) LPWSTR lpBuffer,
    __deref_opt_out LPWSTR *lpFilePart,
    __in            HANDLE hTransaction
    );

version(UNICODE) {
	alias GetFullPathNameTransactedW GetFullPathNameTransacted;
}
else {
	alias GetFullPathNameTransactedA GetFullPathNameTransacted;
}

#endif // _WIN32_WINNT >= 0x0600

const auto DDD_RAW_TARGET_PATH          = 0x00000001;
const auto DDD_REMOVE_DEFINITION        = 0x00000002;
const auto DDD_EXACT_MATCH_ON_REMOVE    = 0x00000004;
const auto DDD_NO_BROADCAST_SYSTEM      = 0x00000008;
const auto DDD_LUID_BROADCAST_DRIVE     = 0x00000010;

BOOL
DefineDosDeviceA(
    __in     DWORD dwFlags,
    __in     LPCSTR lpDeviceName,
    __in_opt LPCSTR lpTargetPath
    );
BOOL
DefineDosDeviceW(
    __in     DWORD dwFlags,
    __in     LPCWSTR lpDeviceName,
    __in_opt LPCWSTR lpTargetPath
    );

version(UNICODE) {
	alias DefineDosDeviceW DefineDosDevice;
}
else {
	alias DefineDosDeviceA DefineDosDevice;
}

DWORD
QueryDosDeviceA(
    __in_opt LPCSTR lpDeviceName,
    __out_ecount_part_opt(ucchMax, return) LPSTR lpTargetPath,
    __in     DWORD ucchMax
    );
DWORD
QueryDosDeviceW(
    __in_opt LPCWSTR lpDeviceName,
    __out_ecount_part_opt(ucchMax, return) LPWSTR lpTargetPath,
    __in     DWORD ucchMax
    );

version(UNICODE) {
	alias QueryDosDeviceW QueryDosDevice;
}
else {
	alias QueryDosDeviceA QueryDosDevice;
}

#define EXPAND_LOCAL_DRIVES

__out
HANDLE
CreateFileA(
    __in     LPCSTR lpFileName,
    __in     DWORD dwDesiredAccess,
    __in     DWORD dwShareMode,
    __in_opt LPSECURITY_ATTRIBUTES lpSecurityAttributes,
    __in     DWORD dwCreationDisposition,
    __in     DWORD dwFlagsAndAttributes,
    __in_opt HANDLE hTemplateFile
    );
__out
HANDLE
CreateFileW(
    __in     LPCWSTR lpFileName,
    __in     DWORD dwDesiredAccess,
    __in     DWORD dwShareMode,
    __in_opt LPSECURITY_ATTRIBUTES lpSecurityAttributes,
    __in     DWORD dwCreationDisposition,
    __in     DWORD dwFlagsAndAttributes,
    __in_opt HANDLE hTemplateFile
    );

version(UNICODE) {
	alias CreateFileW CreateFile;
}
else {
	alias CreateFileA CreateFile;
}

#if _WIN32_WINNT >= 0x0600

__out
HANDLE
CreateFileTransactedA(
    __in       LPCSTR lpFileName,
    __in       DWORD dwDesiredAccess,
    __in       DWORD dwShareMode,
    __in_opt   LPSECURITY_ATTRIBUTES lpSecurityAttributes,
    __in       DWORD dwCreationDisposition,
    __in       DWORD dwFlagsAndAttributes,
    __in_opt   HANDLE hTemplateFile,
    __in       HANDLE hTransaction,
    __in_opt   PUSHORT pusMiniVersion,
    __reserved PVOID  lpExtendedParameter
    );
__out
HANDLE
CreateFileTransactedW(
    __in       LPCWSTR lpFileName,
    __in       DWORD dwDesiredAccess,
    __in       DWORD dwShareMode,
    __in_opt   LPSECURITY_ATTRIBUTES lpSecurityAttributes,
    __in       DWORD dwCreationDisposition,
    __in       DWORD dwFlagsAndAttributes,
    __in_opt   HANDLE hTemplateFile,
    __in       HANDLE hTransaction,
    __in_opt   PUSHORT pusMiniVersion,
    __reserved PVOID  lpExtendedParameter
    );

version(UNICODE) {
	alias CreateFileTransactedW CreateFileTransacted;
}
else {
	alias CreateFileTransactedA CreateFileTransacted;
}

#endif // _WIN32_WINNT >= 0x0600


#if _WIN32_WINNT >= 0x0502

__out
HANDLE
ReOpenFile(
    __in HANDLE  hOriginalFile,
    __in DWORD   dwDesiredAccess,
    __in DWORD   dwShareMode,
    __in DWORD   dwFlagsAndAttributes
    );

#endif // _WIN32_WINNT >= 0x0502

BOOL
SetFileAttributesA(
    __in LPCSTR lpFileName,
    __in DWORD dwFileAttributes
    );
BOOL
SetFileAttributesW(
    __in LPCWSTR lpFileName,
    __in DWORD dwFileAttributes
    );

version(UNICODE) {
	alias SetFileAttributesW SetFileAttributes;
}
else {
	alias SetFileAttributesA SetFileAttributes;
}

DWORD
GetFileAttributesA(
    __in LPCSTR lpFileName
    );
DWORD
GetFileAttributesW(
    __in LPCWSTR lpFileName
    );

version(UNICODE) {
	alias GetFileAttributesW GetFileAttributes;
}
else {
	alias GetFileAttributesA GetFileAttributes;
}

#if _WIN32_WINNT >= 0x0600

BOOL
SetFileAttributesTransactedA(
    __in     LPCSTR lpFileName,
    __in     DWORD dwFileAttributes,
    __in     HANDLE hTransaction
    );
BOOL
SetFileAttributesTransactedW(
    __in     LPCWSTR lpFileName,
    __in     DWORD dwFileAttributes,
    __in     HANDLE hTransaction
    );

version(UNICODE) {
	alias SetFileAttributesTransactedW SetFileAttributesTransacted;
}
else {
	alias SetFileAttributesTransactedA SetFileAttributesTransacted;
}

#endif // _WIN32_WINNT >= 0x0600

typedef enum _GET_FILEEX_INFO_LEVELS {
    GetFileExInfoStandard,
    GetFileExMaxInfoLevel
} GET_FILEEX_INFO_LEVELS;

#if _WIN32_WINNT >= 0x0600

BOOL
GetFileAttributesTransactedA(
    __in  LPCSTR lpFileName,
    __in  GET_FILEEX_INFO_LEVELS fInfoLevelId,
    __out LPVOID lpFileInformation,
    __in     HANDLE hTransaction
    );
BOOL
GetFileAttributesTransactedW(
    __in  LPCWSTR lpFileName,
    __in  GET_FILEEX_INFO_LEVELS fInfoLevelId,
    __out LPVOID lpFileInformation,
    __in     HANDLE hTransaction
    );

version(UNICODE) {
	alias GetFileAttributesTransactedW GetFileAttributesTransacted;
}
else {
	alias GetFileAttributesTransactedA GetFileAttributesTransacted;
}

#endif // _WIN32_WINNT >= 0x0600

BOOL
GetFileAttributesExA(
    __in  LPCSTR lpFileName,
    __in  GET_FILEEX_INFO_LEVELS fInfoLevelId,
    __out LPVOID lpFileInformation
    );
BOOL
GetFileAttributesExW(
    __in  LPCWSTR lpFileName,
    __in  GET_FILEEX_INFO_LEVELS fInfoLevelId,
    __out LPVOID lpFileInformation
    );

version(UNICODE) {
	alias GetFileAttributesExW GetFileAttributesEx;
}
else {
	alias GetFileAttributesExA GetFileAttributesEx;
}

DWORD
GetCompressedFileSizeA(
    __in  LPCSTR lpFileName,
    __out_opt LPDWORD  lpFileSizeHigh
    );
DWORD
GetCompressedFileSizeW(
    __in  LPCWSTR lpFileName,
    __out_opt LPDWORD  lpFileSizeHigh
    );

version(UNICODE) {
	alias GetCompressedFileSizeW GetCompressedFileSize;
}
else {
	alias GetCompressedFileSizeA GetCompressedFileSize;
}

#if _WIN32_WINNT >= 0x0600

DWORD
GetCompressedFileSizeTransactedA(
    __in      LPCSTR lpFileName,
    __out_opt LPDWORD  lpFileSizeHigh,
    __in      HANDLE hTransaction
    );
DWORD
GetCompressedFileSizeTransactedW(
    __in      LPCWSTR lpFileName,
    __out_opt LPDWORD  lpFileSizeHigh,
    __in      HANDLE hTransaction
    );

version(UNICODE) {
	alias GetCompressedFileSizeTransactedW GetCompressedFileSizeTransacted;
}
else {
	alias GetCompressedFileSizeTransactedA GetCompressedFileSizeTransacted;
}

#endif // _WIN32_WINNT >= 0x0600

BOOL
DeleteFileA(
    __in LPCSTR lpFileName
    );
BOOL
DeleteFileW(
    __in LPCWSTR lpFileName
    );

version(UNICODE) {
	alias DeleteFileW DeleteFile;
}
else {
	alias DeleteFileA DeleteFile;
}

#if _WIN32_WINNT >= 0x0600

BOOL
DeleteFileTransactedA(
    __in     LPCSTR lpFileName,
    __in     HANDLE hTransaction
    );
BOOL
DeleteFileTransactedW(
    __in     LPCWSTR lpFileName,
    __in     HANDLE hTransaction
    );

version(UNICODE) {
	alias DeleteFileTransactedW DeleteFileTransacted;
}
else {
	alias DeleteFileTransactedA DeleteFileTransacted;
}

#endif // _WIN32_WINNT >= 0x0600

#if defined(_M_CEE)
#undef DeleteFile
__inline
BOOL
DeleteFile(
    LPCTSTR lpFileName
    )
{

version(UNICODE) {
	    return DeleteFileW(
}
else {
	    return DeleteFileA(
}
        lpFileName
        );
}
#endif  /* _M_CEE */


#if _WIN32_WINNT >= 0x0501

BOOL
CheckNameLegalDOS8Dot3A(
    __in      LPCSTR lpName,
    __out_ecount_opt(OemNameSize) LPSTR lpOemName,
    __in      DWORD OemNameSize,
    __out_opt PBOOL pbNameContainsSpaces OPTIONAL,
    __out     PBOOL pbNameLegal
    );
BOOL
CheckNameLegalDOS8Dot3W(
    __in      LPCWSTR lpName,
    __out_ecount_opt(OemNameSize) LPSTR lpOemName,
    __in      DWORD OemNameSize,
    __out_opt PBOOL pbNameContainsSpaces OPTIONAL,
    __out     PBOOL pbNameLegal
    );

version(UNICODE) {
	alias CheckNameLegalDOS8Dot3W CheckNameLegalDOS8Dot3;
}
else {
	alias CheckNameLegalDOS8Dot3A CheckNameLegalDOS8Dot3;
}

#endif // (_WIN32_WINNT >= 0x0501)

#if(_WIN32_WINNT >= 0x0400)
typedef enum _FINDEX_INFO_LEVELS {
    FindExInfoStandard,
    FindExInfoMaxInfoLevel
} FINDEX_INFO_LEVELS;

typedef enum _FINDEX_SEARCH_OPS {
    FindExSearchNameMatch,
    FindExSearchLimitToDirectories,
    FindExSearchLimitToDevices,
    FindExSearchMaxSearchOp
} FINDEX_SEARCH_OPS;

const auto FIND_FIRST_EX_CASE_SENSITIVE    = 0x00000001;

__out
HANDLE
FindFirstFileExA(
    __in       LPCSTR lpFileName,
    __in       FINDEX_INFO_LEVELS fInfoLevelId,
    __out      LPVOID lpFindFileData,
    __in       FINDEX_SEARCH_OPS fSearchOp,
    __reserved LPVOID lpSearchFilter,
    __in       DWORD dwAdditionalFlags
    );
__out
HANDLE
FindFirstFileExW(
    __in       LPCWSTR lpFileName,
    __in       FINDEX_INFO_LEVELS fInfoLevelId,
    __out      LPVOID lpFindFileData,
    __in       FINDEX_SEARCH_OPS fSearchOp,
    __reserved LPVOID lpSearchFilter,
    __in       DWORD dwAdditionalFlags
    );

version(UNICODE) {
	alias FindFirstFileExW FindFirstFileEx;
}
else {
	alias FindFirstFileExA FindFirstFileEx;
}

#if _WIN32_WINNT >= 0x0600

__out
HANDLE
FindFirstFileTransactedA(
    __in       LPCSTR lpFileName,
    __in       FINDEX_INFO_LEVELS fInfoLevelId,
    __out      LPVOID lpFindFileData,
    __in       FINDEX_SEARCH_OPS fSearchOp,
    __reserved LPVOID lpSearchFilter,
    __in       DWORD dwAdditionalFlags,
    __in       HANDLE hTransaction
    );
__out
HANDLE
FindFirstFileTransactedW(
    __in       LPCWSTR lpFileName,
    __in       FINDEX_INFO_LEVELS fInfoLevelId,
    __out      LPVOID lpFindFileData,
    __in       FINDEX_SEARCH_OPS fSearchOp,
    __reserved LPVOID lpSearchFilter,
    __in       DWORD dwAdditionalFlags,
    __in       HANDLE hTransaction
    );

version(UNICODE) {
	alias FindFirstFileTransactedW FindFirstFileTransacted;
}
else {
	alias FindFirstFileTransactedA FindFirstFileTransacted;
}

#endif

#endif /* _WIN32_WINNT >= 0x0400 */

__out
HANDLE
FindFirstFileA(
    __in  LPCSTR lpFileName,
    __out LPWIN32_FIND_DATAA lpFindFileData
    );
__out
HANDLE
FindFirstFileW(
    __in  LPCWSTR lpFileName,
    __out LPWIN32_FIND_DATAW lpFindFileData
    );

version(UNICODE) {
	alias FindFirstFileW FindFirstFile;
}
else {
	alias FindFirstFileA FindFirstFile;
}

BOOL
FindNextFileA(
    __in  HANDLE hFindFile,
    __out LPWIN32_FIND_DATAA lpFindFileData
    );
BOOL
FindNextFileW(
    __in  HANDLE hFindFile,
    __out LPWIN32_FIND_DATAW lpFindFileData
    );

version(UNICODE) {
	alias FindNextFileW FindNextFile;
}
else {
	alias FindNextFileA FindNextFile;
}


DWORD
SearchPathA(
    __in_opt  LPCSTR lpPath,
    __in      LPCSTR lpFileName,
    __in_opt  LPCSTR lpExtension,
    __in      DWORD nBufferLength,
    __out_ecount_part_opt(nBufferLength, return + 1) LPSTR lpBuffer,
    __out_opt LPSTR *lpFilePart
    );
DWORD
SearchPathW(
    __in_opt  LPCWSTR lpPath,
    __in      LPCWSTR lpFileName,
    __in_opt  LPCWSTR lpExtension,
    __in      DWORD nBufferLength,
    __out_ecount_part_opt(nBufferLength, return + 1) LPWSTR lpBuffer,
    __out_opt LPWSTR *lpFilePart
    );

version(UNICODE) {
	alias SearchPathW SearchPath;
}
else {
	alias SearchPathA SearchPath;
}

BOOL
CopyFileA(
    __in LPCSTR lpExistingFileName,
    __in LPCSTR lpNewFileName,
    __in BOOL bFailIfExists
    );
BOOL
CopyFileW(
    __in LPCWSTR lpExistingFileName,
    __in LPCWSTR lpNewFileName,
    __in BOOL bFailIfExists
    );

version(UNICODE) {
	alias CopyFileW CopyFile;
}
else {
	alias CopyFileA CopyFile;
}

#if defined(_M_CEE)
#undef CopyFile
__inline
BOOL
CopyFile(
    LPCTSTR lpExistingFileName,
    LPCTSTR lpNewFileName,
    BOOL bFailIfExists
    )
{

version(UNICODE) {
	    return CopyFileW(
}
else {
	    return CopyFileA(
}
        lpExistingFileName,
        lpNewFileName,
        bFailIfExists
        );
}
#endif  /* _M_CEE */

#if(_WIN32_WINNT >= 0x0400)
typedef
DWORD
(WINAPI *LPPROGRESS_ROUTINE)(
    __in     LARGE_INTEGER TotalFileSize,
    __in     LARGE_INTEGER TotalBytesTransferred,
    __in     LARGE_INTEGER StreamSize,
    __in     LARGE_INTEGER StreamBytesTransferred,
    __in     DWORD dwStreamNumber,
    __in     DWORD dwCallbackReason,
    __in     HANDLE hSourceFile,
    __in     HANDLE hDestinationFile,
    __in_opt LPVOID lpData
    );

BOOL
CopyFileExA(
    __in     LPCSTR lpExistingFileName,
    __in     LPCSTR lpNewFileName,
    __in_opt LPPROGRESS_ROUTINE lpProgressRoutine,
    __in_opt LPVOID lpData,
    __in_opt LPBOOL pbCancel,
    __in     DWORD dwCopyFlags
    );
BOOL
CopyFileExW(
    __in     LPCWSTR lpExistingFileName,
    __in     LPCWSTR lpNewFileName,
    __in_opt LPPROGRESS_ROUTINE lpProgressRoutine,
    __in_opt LPVOID lpData,
    __in_opt LPBOOL pbCancel,
    __in     DWORD dwCopyFlags
    );

version(UNICODE) {
	alias CopyFileExW CopyFileEx;
}
else {
	alias CopyFileExA CopyFileEx;
}

#if _WIN32_WINNT >= 0x0600

BOOL
CopyFileTransactedA(
    __in     LPCSTR lpExistingFileName,
    __in     LPCSTR lpNewFileName,
    __in_opt LPPROGRESS_ROUTINE lpProgressRoutine,
    __in_opt LPVOID lpData,
    __in_opt LPBOOL pbCancel,
    __in     DWORD dwCopyFlags,
    __in     HANDLE hTransaction
    );
BOOL
CopyFileTransactedW(
    __in     LPCWSTR lpExistingFileName,
    __in     LPCWSTR lpNewFileName,
    __in_opt LPPROGRESS_ROUTINE lpProgressRoutine,
    __in_opt LPVOID lpData,
    __in_opt LPBOOL pbCancel,
    __in     DWORD dwCopyFlags,
    __in     HANDLE hTransaction
    );

version(UNICODE) {
	alias CopyFileTransactedW CopyFileTransacted;
}
else {
	alias CopyFileTransactedA CopyFileTransacted;
}

#endif // _WIN32_WINNT >= 0x0600
#endif /* _WIN32_WINNT >= 0x0400 */

BOOL
MoveFileA(
    __in LPCSTR lpExistingFileName,
    __in LPCSTR lpNewFileName
    );
BOOL
MoveFileW(
    __in LPCWSTR lpExistingFileName,
    __in LPCWSTR lpNewFileName
    );

version(UNICODE) {
	alias MoveFileW MoveFile;
}
else {
	alias MoveFileA MoveFile;
}

#if defined(_M_CEE)
#undef MoveFile
__inline
BOOL
MoveFile(
    LPCTSTR lpExistingFileName,
    LPCTSTR lpNewFileName
    )
{

version(UNICODE) {
	    return MoveFileW(
}
else {
	    return MoveFileA(
}
        lpExistingFileName,
        lpNewFileName
        );
}
#endif  /* _M_CEE */

BOOL
MoveFileExA(
    __in     LPCSTR lpExistingFileName,
    __in_opt LPCSTR lpNewFileName,
    __in     DWORD    dwFlags
    );
BOOL
MoveFileExW(
    __in     LPCWSTR lpExistingFileName,
    __in_opt LPCWSTR lpNewFileName,
    __in     DWORD    dwFlags
    );

version(UNICODE) {
	alias MoveFileExW MoveFileEx;
}
else {
	alias MoveFileExA MoveFileEx;
}

#if (_WIN32_WINNT >= 0x0500)
BOOL
MoveFileWithProgressA(
    __in     LPCSTR lpExistingFileName,
    __in_opt LPCSTR lpNewFileName,
    __in_opt LPPROGRESS_ROUTINE lpProgressRoutine,
    __in_opt LPVOID lpData,
    __in     DWORD dwFlags
    );
BOOL
MoveFileWithProgressW(
    __in     LPCWSTR lpExistingFileName,
    __in_opt LPCWSTR lpNewFileName,
    __in_opt LPPROGRESS_ROUTINE lpProgressRoutine,
    __in_opt LPVOID lpData,
    __in     DWORD dwFlags
    );

version(UNICODE) {
	alias MoveFileWithProgressW MoveFileWithProgress;
}
else {
	alias MoveFileWithProgressA MoveFileWithProgress;
}
#endif // (_WIN32_WINNT >= 0x0500)

#if (_WIN32_WINNT >= 0x0600)
BOOL
MoveFileTransactedA(
    __in     LPCSTR lpExistingFileName,
    __in_opt LPCSTR lpNewFileName,
    __in_opt LPPROGRESS_ROUTINE lpProgressRoutine,
    __in_opt LPVOID lpData,
    __in     DWORD dwFlags,
    __in     HANDLE hTransaction
    );
BOOL
MoveFileTransactedW(
    __in     LPCWSTR lpExistingFileName,
    __in_opt LPCWSTR lpNewFileName,
    __in_opt LPPROGRESS_ROUTINE lpProgressRoutine,
    __in_opt LPVOID lpData,
    __in     DWORD dwFlags,
    __in     HANDLE hTransaction
    );

version(UNICODE) {
	alias MoveFileTransactedW MoveFileTransacted;
}
else {
	alias MoveFileTransactedA MoveFileTransacted;
}
#endif // (_WIN32_WINNT >= 0x0600)

const auto MOVEFILE_REPLACE_EXISTING        = 0x00000001;
const auto MOVEFILE_COPY_ALLOWED            = 0x00000002;
const auto MOVEFILE_DELAY_UNTIL_REBOOT      = 0x00000004;
const auto MOVEFILE_WRITE_THROUGH           = 0x00000008;
#if (_WIN32_WINNT >= 0x0500)
const auto MOVEFILE_CREATE_HARDLINK         = 0x00000010;
const auto MOVEFILE_FAIL_IF_NOT_TRACKABLE   = 0x00000020;
#endif // (_WIN32_WINNT >= 0x0500)



#if (_WIN32_WINNT >= 0x0500)
BOOL
ReplaceFileA(
    __in       LPCSTR  lpReplacedFileName,
    __in       LPCSTR  lpReplacementFileName,
    __in_opt   LPCSTR  lpBackupFileName,
    __in       DWORD   dwReplaceFlags,
    __reserved LPVOID  lpExclude,
    __reserved LPVOID  lpReserved
    );
BOOL
ReplaceFileW(
    __in       LPCWSTR lpReplacedFileName,
    __in       LPCWSTR lpReplacementFileName,
    __in_opt   LPCWSTR lpBackupFileName,
    __in       DWORD   dwReplaceFlags,
    __reserved LPVOID  lpExclude,
    __reserved LPVOID  lpReserved
    );

version(UNICODE) {
	alias ReplaceFileW ReplaceFile;
}
else {
	alias ReplaceFileA ReplaceFile;
}
#endif // (_WIN32_WINNT >= 0x0500)


#if (_WIN32_WINNT >= 0x0500)
//
// API call to create hard links.
//

BOOL
CreateHardLinkA(
    __in       LPCSTR lpFileName,
    __in       LPCSTR lpExistingFileName,
    __reserved LPSECURITY_ATTRIBUTES lpSecurityAttributes
    );
BOOL
CreateHardLinkW(
    __in       LPCWSTR lpFileName,
    __in       LPCWSTR lpExistingFileName,
    __reserved LPSECURITY_ATTRIBUTES lpSecurityAttributes
    );

version(UNICODE) {
	alias CreateHardLinkW CreateHardLink;
}
else {
	alias CreateHardLinkA CreateHardLink;
}

#endif // (_WIN32_WINNT >= 0x0500)

#if (_WIN32_WINNT >= 0x0600)
//
// API call to create hard links.
//

BOOL
CreateHardLinkTransactedA(
    __in       LPCSTR lpFileName,
    __in       LPCSTR lpExistingFileName,
    __reserved LPSECURITY_ATTRIBUTES lpSecurityAttributes,
    __in       HANDLE hTransaction
    );
BOOL
CreateHardLinkTransactedW(
    __in       LPCWSTR lpFileName,
    __in       LPCWSTR lpExistingFileName,
    __reserved LPSECURITY_ATTRIBUTES lpSecurityAttributes,
    __in       HANDLE hTransaction
    );

version(UNICODE) {
	alias CreateHardLinkTransactedW CreateHardLinkTransacted;
}
else {
	alias CreateHardLinkTransactedA CreateHardLinkTransacted;
}

#endif // (_WIN32_WINNT >= 0x0600)


#if (_WIN32_WINNT >= 0x0501)

//
// API call to enumerate for streams within a file
//

typedef enum _STREAM_INFO_LEVELS {

    FindStreamInfoStandard,
    FindStreamInfoMaxInfoLevel

} STREAM_INFO_LEVELS;

struct WIN32_FIND_STREAM_DATA {

    LARGE_INTEGER StreamSize;
    WCHAR cStreamName[ MAX_PATH + 36 ];

}

typedef WIN32_FIND_STREAM_DATA* PWIN32_FIND_STREAM_DATA;

__out
HANDLE
FindFirstStreamW(
    __in       LPCWSTR lpFileName,
    __in       STREAM_INFO_LEVELS InfoLevel,
    __out      LPVOID lpFindStreamData,
    __reserved DWORD dwFlags
    );

BOOL
APIENTRY
FindNextStreamW(
    __in  HANDLE hFindStream,
    __out LPVOID lpFindStreamData
    );
#endif // (_WIN32_WINNT >= 0x0501)

#if _WIN32_WINNT >= 0x0600

HANDLE
FindFirstFileNameW (
    __in    LPCWSTR lpFileName,
    __in    DWORD dwFlags,
    __inout LPDWORD StringLength,
    __inout_ecount(*StringLength) PWCHAR LinkName
    );

BOOL
APIENTRY
FindNextFileNameW (
    __in    HANDLE hFindStream,
    __inout LPDWORD StringLength,
    __inout_ecount(*StringLength) PWCHAR LinkName
    );

HANDLE
FindFirstFileNameTransactedW (
    __in     LPCWSTR lpFileName,
    __in     DWORD dwFlags,
    __inout  LPDWORD StringLength,
    __inout_ecount(*StringLength) PWCHAR LinkName,
    __in_opt HANDLE hTransaction
    );

#endif


__out
HANDLE
CreateNamedPipeA(
    __in     LPCSTR lpName,
    __in     DWORD dwOpenMode,
    __in     DWORD dwPipeMode,
    __in     DWORD nMaxInstances,
    __in     DWORD nOutBufferSize,
    __in     DWORD nInBufferSize,
    __in     DWORD nDefaultTimeOut,
    __in_opt LPSECURITY_ATTRIBUTES lpSecurityAttributes
    );
__out
HANDLE
CreateNamedPipeW(
    __in     LPCWSTR lpName,
    __in     DWORD dwOpenMode,
    __in     DWORD dwPipeMode,
    __in     DWORD nMaxInstances,
    __in     DWORD nOutBufferSize,
    __in     DWORD nInBufferSize,
    __in     DWORD nDefaultTimeOut,
    __in_opt LPSECURITY_ATTRIBUTES lpSecurityAttributes
    );

version(UNICODE) {
	alias CreateNamedPipeW CreateNamedPipe;
}
else {
	alias CreateNamedPipeA CreateNamedPipe;
}

BOOL
GetNamedPipeHandleStateA(
    __in      HANDLE hNamedPipe,
    __out_opt LPDWORD lpState,
    __out_opt LPDWORD lpCurInstances,
    __out_opt LPDWORD lpMaxCollectionCount,
    __out_opt LPDWORD lpCollectDataTimeout,
    __out_ecount_opt(nMaxUserNameSize) LPSTR lpUserName,
    __in      DWORD nMaxUserNameSize
    );
BOOL
GetNamedPipeHandleStateW(
    __in      HANDLE hNamedPipe,
    __out_opt LPDWORD lpState,
    __out_opt LPDWORD lpCurInstances,
    __out_opt LPDWORD lpMaxCollectionCount,
    __out_opt LPDWORD lpCollectDataTimeout,
    __out_ecount_opt(nMaxUserNameSize) LPWSTR lpUserName,
    __in      DWORD nMaxUserNameSize
    );

version(UNICODE) {
	alias GetNamedPipeHandleStateW GetNamedPipeHandleState;
}
else {
	alias GetNamedPipeHandleStateA GetNamedPipeHandleState;
}

BOOL
CallNamedPipeA(
    __in  LPCSTR lpNamedPipeName,
    __in_bcount_opt(nInBufferSize) LPVOID lpInBuffer,
    __in  DWORD nInBufferSize,
    __out_bcount_part_opt(nOutBufferSize, *lpBytesRead) LPVOID lpOutBuffer,
    __in  DWORD nOutBufferSize,
    __out LPDWORD lpBytesRead,
    __in  DWORD nTimeOut
    );
BOOL
CallNamedPipeW(
    __in  LPCWSTR lpNamedPipeName,
    __in_bcount_opt(nInBufferSize) LPVOID lpInBuffer,
    __in  DWORD nInBufferSize,
    __out_bcount_part_opt(nOutBufferSize, *lpBytesRead) LPVOID lpOutBuffer,
    __in  DWORD nOutBufferSize,
    __out LPDWORD lpBytesRead,
    __in  DWORD nTimeOut
    );

version(UNICODE) {
	alias CallNamedPipeW CallNamedPipe;
}
else {
	alias CallNamedPipeA CallNamedPipe;
}

BOOL
WaitNamedPipeA(
    __in LPCSTR lpNamedPipeName,
    __in DWORD nTimeOut
    );
BOOL
WaitNamedPipeW(
    __in LPCWSTR lpNamedPipeName,
    __in DWORD nTimeOut
    );

version(UNICODE) {
	alias WaitNamedPipeW WaitNamedPipe;
}
else {
	alias WaitNamedPipeA WaitNamedPipe;
}

typedef enum {
    PipeAttribute,
    PipeConnectionAttribute,
    PipeHandleAttribute
} PIPE_ATTRIBUTE_TYPE;

BOOL
GetNamedPipeAttribute(
    __in HANDLE Pipe,
    __in PIPE_ATTRIBUTE_TYPE AttributeType,
    __in PSTR AttributeName,
    __out_bcount(*AttributeValueLength) PVOID AttributeValue,
    __inout PSIZE_T AttributeValueLength
    );

BOOL
SetNamedPipeAttribute(
    __in HANDLE Pipe,
    __in PIPE_ATTRIBUTE_TYPE AttributeType,
    __in PSTR AttributeName,
    __in PVOID AttributeValue,
    __in SIZE_T AttributeValueLength
    );

BOOL
GetNamedPipeClientComputerNameA(
    __in HANDLE Pipe,
    __out_bcount(ClientComputerNameLength)  LPSTR ClientComputerName,
    __in ULONG ClientComputerNameLength
    );
BOOL
GetNamedPipeClientComputerNameW(
    __in HANDLE Pipe,
    __out_bcount(ClientComputerNameLength)  LPWSTR ClientComputerName,
    __in ULONG ClientComputerNameLength
    );

version(UNICODE) {
	alias GetNamedPipeClientComputerNameW GetNamedPipeClientComputerName;
}
else {
	alias GetNamedPipeClientComputerNameA GetNamedPipeClientComputerName;
}

BOOL
GetNamedPipeClientProcessId(
    __in HANDLE Pipe,
    __out PULONG ClientProcessId
    );

BOOL
GetNamedPipeClientSessionId(
    __in HANDLE Pipe,
    __out PULONG ClientSessionId
    );

BOOL
GetNamedPipeServerProcessId(
    __in HANDLE Pipe,
    __out PULONG ServerProcessId
    );

BOOL
GetNamedPipeServerSessionId(
    __in HANDLE Pipe,
    __out PULONG ServerSessionId
    );

BOOL
SetVolumeLabelA(
    __in_opt LPCSTR lpRootPathName,
    __in_opt LPCSTR lpVolumeName
    );
BOOL
SetVolumeLabelW(
    __in_opt LPCWSTR lpRootPathName,
    __in_opt LPCWSTR lpVolumeName
    );

version(UNICODE) {
	alias SetVolumeLabelW SetVolumeLabel;
}
else {
	alias SetVolumeLabelA SetVolumeLabel;
}

VOID
SetFileApisToOEM( VOID );

VOID
SetFileApisToANSI( VOID );

BOOL
AreFileApisANSI( VOID );

BOOL
GetVolumeInformationA(
    __in_opt  LPCSTR lpRootPathName,
    __out_ecount_opt(nVolumeNameSize) LPSTR lpVolumeNameBuffer,
    __in      DWORD nVolumeNameSize,
    __out_opt LPDWORD lpVolumeSerialNumber,
    __out_opt LPDWORD lpMaximumComponentLength,
    __out_opt LPDWORD lpFileSystemFlags,
    __out_ecount_opt(nFileSystemNameSize) LPSTR lpFileSystemNameBuffer,
    __in      DWORD nFileSystemNameSize
    );
BOOL
GetVolumeInformationW(
    __in_opt  LPCWSTR lpRootPathName,
    __out_ecount_opt(nVolumeNameSize) LPWSTR lpVolumeNameBuffer,
    __in      DWORD nVolumeNameSize,
    __out_opt LPDWORD lpVolumeSerialNumber,
    __out_opt LPDWORD lpMaximumComponentLength,
    __out_opt LPDWORD lpFileSystemFlags,
    __out_ecount_opt(nFileSystemNameSize) LPWSTR lpFileSystemNameBuffer,
    __in      DWORD nFileSystemNameSize
    );

version(UNICODE) {
	alias GetVolumeInformationW GetVolumeInformation;
}
else {
	alias GetVolumeInformationA GetVolumeInformation;
}

#if(_WIN32_WINNT >= 0x0600)
BOOL
GetVolumeInformationByHandleW(
    __in      HANDLE hFile,
    __out_ecount_opt(nVolumeNameSize) LPWSTR lpVolumeNameBuffer,
    __in      DWORD nVolumeNameSize,
    __out_opt LPDWORD lpVolumeSerialNumber,
    __out_opt LPDWORD lpMaximumComponentLength,
    __out_opt LPDWORD lpFileSystemFlags,
    __out_ecount_opt(nFileSystemNameSize) LPWSTR lpFileSystemNameBuffer,
    __in      DWORD nFileSystemNameSize
    );
#endif /* _WIN32_WINNT >=  0x0600 */

BOOL
CancelSynchronousIo(
    __in HANDLE hThread
    );

BOOL
CancelIoEx(
    __in HANDLE hFile,
    __in_opt LPOVERLAPPED lpOverlapped
    );

BOOL
CancelIo(
    __in HANDLE hFile
    );

BOOL
SetFileBandwidthReservation(
    __in  HANDLE  hFile,
    __in  DWORD   nPeriodMilliseconds,
    __in  DWORD   nBytesPerPeriod,
    __in  BOOL    bDiscardable,
    __out LPDWORD lpTransferSize,
    __out LPDWORD lpNumOutstandingRequests
    );

BOOL
GetFileBandwidthReservation(
    __in  HANDLE  hFile,
    __out LPDWORD lpPeriodMilliseconds,
    __out LPDWORD lpBytesPerPeriod,
    __out LPBOOL  pDiscardable,
    __out LPDWORD lpTransferSize,
    __out LPDWORD lpNumOutstandingRequests
    );

//
// Event logging APIs
//

WINADVAPI
BOOL
ClearEventLogA (
    __in     HANDLE hEventLog,
    __in_opt LPCSTR lpBackupFileName
    );
WINADVAPI
BOOL
ClearEventLogW (
    __in     HANDLE hEventLog,
    __in_opt LPCWSTR lpBackupFileName
    );

version(UNICODE) {
	alias ClearEventLogW ClearEventLog;
}
else {
	alias ClearEventLogA ClearEventLog;
}

WINADVAPI
BOOL
BackupEventLogA (
    __in HANDLE hEventLog,
    __in LPCSTR lpBackupFileName
    );
WINADVAPI
BOOL
BackupEventLogW (
    __in HANDLE hEventLog,
    __in LPCWSTR lpBackupFileName
    );

version(UNICODE) {
	alias BackupEventLogW BackupEventLog;
}
else {
	alias BackupEventLogA BackupEventLog;
}

WINADVAPI
BOOL
CloseEventLog (
    __in HANDLE hEventLog
    );

WINADVAPI
BOOL
DeregisterEventSource (
    __in HANDLE hEventLog
    );

WINADVAPI
BOOL
NotifyChangeEventLog(
    __in HANDLE  hEventLog,
    __in HANDLE  hEvent
    );

WINADVAPI
BOOL
GetNumberOfEventLogRecords (
    __in  HANDLE hEventLog,
    __out PDWORD NumberOfRecords
    );

WINADVAPI
BOOL
GetOldestEventLogRecord (
    __in  HANDLE hEventLog,
    __out PDWORD OldestRecord
    );

WINADVAPI
__out
HANDLE
OpenEventLogA (
    __in_opt LPCSTR lpUNCServerName,
    __in     LPCSTR lpSourceName
    );
WINADVAPI
__out
HANDLE
OpenEventLogW (
    __in_opt LPCWSTR lpUNCServerName,
    __in     LPCWSTR lpSourceName
    );

version(UNICODE) {
	alias OpenEventLogW OpenEventLog;
}
else {
	alias OpenEventLogA OpenEventLog;
}

WINADVAPI
__out
HANDLE
RegisterEventSourceA (
    __in_opt LPCSTR lpUNCServerName,
    __in     LPCSTR lpSourceName
    );
WINADVAPI
__out
HANDLE
RegisterEventSourceW (
    __in_opt LPCWSTR lpUNCServerName,
    __in     LPCWSTR lpSourceName
    );

version(UNICODE) {
	alias RegisterEventSourceW RegisterEventSource;
}
else {
	alias RegisterEventSourceA RegisterEventSource;
}

WINADVAPI
__out
HANDLE
OpenBackupEventLogA (
    __in_opt LPCSTR lpUNCServerName,
    __in     LPCSTR lpFileName
    );
WINADVAPI
__out
HANDLE
OpenBackupEventLogW (
    __in_opt LPCWSTR lpUNCServerName,
    __in     LPCWSTR lpFileName
    );

version(UNICODE) {
	alias OpenBackupEventLogW OpenBackupEventLog;
}
else {
	alias OpenBackupEventLogA OpenBackupEventLog;
}

WINADVAPI
BOOL
ReadEventLogA (
    __in  HANDLE     hEventLog,
    __in  DWORD      dwReadFlags,
    __in  DWORD      dwRecordOffset,
    __out_bcount_part(nNumberOfBytesToRead, *pnBytesRead) LPVOID     lpBuffer,
    __in  DWORD      nNumberOfBytesToRead,
    __out DWORD      *pnBytesRead,
    __out DWORD      *pnMinNumberOfBytesNeeded
    );
WINADVAPI
BOOL
ReadEventLogW (
    __in  HANDLE     hEventLog,
    __in  DWORD      dwReadFlags,
    __in  DWORD      dwRecordOffset,
    __out_bcount_part(nNumberOfBytesToRead, *pnBytesRead) LPVOID     lpBuffer,
    __in  DWORD      nNumberOfBytesToRead,
    __out DWORD      *pnBytesRead,
    __out DWORD      *pnMinNumberOfBytesNeeded
    );

version(UNICODE) {
	alias ReadEventLogW ReadEventLog;
}
else {
	alias ReadEventLogA ReadEventLog;
}

WINADVAPI
BOOL
ReportEventA (
    __in     HANDLE     hEventLog,
    __in     WORD       wType,
    __in     WORD       wCategory,
    __in     DWORD      dwEventID,
    __in_opt PSID       lpUserSid,
    __in     WORD       wNumStrings,
    __in     DWORD      dwDataSize,
    __in_ecount_opt(wNumStrings) LPCSTR *lpStrings,
    __in_bcount_opt(dwDataSize) LPVOID lpRawData
    );
WINADVAPI
BOOL
ReportEventW (
    __in     HANDLE     hEventLog,
    __in     WORD       wType,
    __in     WORD       wCategory,
    __in     DWORD      dwEventID,
    __in_opt PSID       lpUserSid,
    __in     WORD       wNumStrings,
    __in     DWORD      dwDataSize,
    __in_ecount_opt(wNumStrings) LPCWSTR *lpStrings,
    __in_bcount_opt(dwDataSize) LPVOID lpRawData
    );

version(UNICODE) {
	alias ReportEventW ReportEvent;
}
else {
	alias ReportEventA ReportEvent;
}


const auto EVENTLOG_FULL_INFO       = 0;

struct EVENTLOG_FULL_INFORMATION {
    DWORD    dwFull;
}

typedef EVENTLOG_FULL_INFORMATION* LPEVENTLOG_FULL_INFORMATION;

WINADVAPI
BOOL
GetEventLogInformation (
    __in  HANDLE     hEventLog,
    __in  DWORD      dwInfoLevel,
    __out_bcount_part(cbBufSize, *pcbBytesNeeded) LPVOID lpBuffer,
    __in  DWORD      cbBufSize,
    __out LPDWORD    pcbBytesNeeded
    );

//
//
// Security APIs
//


WINADVAPI
BOOL
DuplicateToken(
    __in        HANDLE ExistingTokenHandle,
    __in        SECURITY_IMPERSONATION_LEVEL ImpersonationLevel,
    __deref_out PHANDLE DuplicateTokenHandle
    );

WINADVAPI
BOOL
GetKernelObjectSecurity (
    __in  HANDLE Handle,
    __in  SECURITY_INFORMATION RequestedInformation,
    __out_bcount_opt(nLength) PSECURITY_DESCRIPTOR pSecurityDescriptor,
    __in  DWORD nLength,
    __out LPDWORD lpnLengthNeeded
    );

WINADVAPI
BOOL
ImpersonateNamedPipeClient(
    __in HANDLE hNamedPipe
    );

WINADVAPI
BOOL
ImpersonateSelf(
    __in SECURITY_IMPERSONATION_LEVEL ImpersonationLevel
    );


WINADVAPI
BOOL
RevertToSelf (
    VOID
    );

WINADVAPI
BOOL
APIENTRY
SetThreadToken (
    __in_opt PHANDLE Thread,
    __in_opt HANDLE Token
    );

WINADVAPI
BOOL
AccessCheck (
    __in    PSECURITY_DESCRIPTOR pSecurityDescriptor,
    __in    HANDLE ClientToken,
    __in    DWORD DesiredAccess,
    __in    PGENERIC_MAPPING GenericMapping,
    __out_bcount_part_opt(*PrivilegeSetLength, *PrivilegeSetLength) PPRIVILEGE_SET PrivilegeSet,
    __inout LPDWORD PrivilegeSetLength,
    __out   LPDWORD GrantedAccess,
    __out   LPBOOL AccessStatus
    );

#if(_WIN32_WINNT >= 0x0500)
WINADVAPI
BOOL
AccessCheckByType (
    __in     PSECURITY_DESCRIPTOR pSecurityDescriptor,
    __in_opt PSID PrincipalSelfSid,
    __in     HANDLE ClientToken,
    __in     DWORD DesiredAccess,
    __inout_ecount_opt(ObjectTypeListLength) POBJECT_TYPE_LIST ObjectTypeList,
    __in     DWORD ObjectTypeListLength,
    __in     PGENERIC_MAPPING GenericMapping,
    __out_bcount_part_opt(*PrivilegeSetLength, *PrivilegeSetLength) PPRIVILEGE_SET PrivilegeSet,
    __inout  LPDWORD PrivilegeSetLength,
    __out    LPDWORD GrantedAccess,
    __out    LPBOOL AccessStatus
    );

WINADVAPI
BOOL
AccessCheckByTypeResultList (
    __in     PSECURITY_DESCRIPTOR pSecurityDescriptor,
    __in_opt PSID PrincipalSelfSid,
    __in     HANDLE ClientToken,
    __in     DWORD DesiredAccess,
    __inout_ecount_opt(ObjectTypeListLength) POBJECT_TYPE_LIST ObjectTypeList,
    __in     DWORD ObjectTypeListLength,
    __in     PGENERIC_MAPPING GenericMapping,
    __out_bcount_part_opt(*PrivilegeSetLength, *PrivilegeSetLength) PPRIVILEGE_SET PrivilegeSet,
    __inout  LPDWORD PrivilegeSetLength,
    __out    LPDWORD GrantedAccessList,
    __out    LPDWORD AccessStatusList
    );
#endif /* _WIN32_WINNT >=  0x0500 */


WINADVAPI
BOOL
OpenProcessToken (
    __in        HANDLE ProcessHandle,
    __in        DWORD DesiredAccess,
    __deref_out PHANDLE TokenHandle
    );


WINADVAPI
BOOL
OpenThreadToken (
    __in        HANDLE ThreadHandle,
    __in        DWORD DesiredAccess,
    __in        BOOL OpenAsSelf,
    __deref_out PHANDLE TokenHandle
    );


WINADVAPI
BOOL
GetTokenInformation (
    __in      HANDLE TokenHandle,
    __in      TOKEN_INFORMATION_CLASS TokenInformationClass,
    __out_bcount_part_opt(TokenInformationLength, *ReturnLength) LPVOID TokenInformation,
    __in      DWORD TokenInformationLength,
    __out     PDWORD ReturnLength
    );


WINADVAPI
BOOL
SetTokenInformation (
    __in HANDLE TokenHandle,
    __in TOKEN_INFORMATION_CLASS TokenInformationClass,
    __in_bcount(TokenInformationLength) LPVOID TokenInformation,
    __in DWORD TokenInformationLength
    );


WINADVAPI
BOOL
AdjustTokenPrivileges (
    __in      HANDLE TokenHandle,
    __in      BOOL DisableAllPrivileges,
    __in_opt  PTOKEN_PRIVILEGES NewState,
    __in      DWORD BufferLength,
    __out_bcount_part_opt(BufferLength, *ReturnLength) PTOKEN_PRIVILEGES PreviousState,
    __out_opt PDWORD ReturnLength
    );


WINADVAPI
BOOL
AdjustTokenGroups (
    __in      HANDLE TokenHandle,
    __in      BOOL ResetToDefault,
    __in_opt  PTOKEN_GROUPS NewState,
    __in      DWORD BufferLength,
    __out_bcount_part_opt(BufferLength, *ReturnLength) PTOKEN_GROUPS PreviousState,
    __out_opt PDWORD ReturnLength
    );


WINADVAPI
BOOL
PrivilegeCheck (
    __in    HANDLE ClientToken,
    __inout PPRIVILEGE_SET RequiredPrivileges,
    __out   LPBOOL pfResult
    );


WINADVAPI
BOOL
AccessCheckAndAuditAlarmA (
    __in     LPCSTR SubsystemName,
    __in_opt LPVOID HandleId,
    __in     LPSTR ObjectTypeName,
    __in_opt LPSTR ObjectName,
    __in     PSECURITY_DESCRIPTOR SecurityDescriptor,
    __in     DWORD DesiredAccess,
    __in     PGENERIC_MAPPING GenericMapping,
    __in     BOOL ObjectCreation,
    __out    LPDWORD GrantedAccess,
    __out    LPBOOL AccessStatus,
    __out    LPBOOL pfGenerateOnClose
    );
WINADVAPI
BOOL
AccessCheckAndAuditAlarmW (
    __in     LPCWSTR SubsystemName,
    __in_opt LPVOID HandleId,
    __in     LPWSTR ObjectTypeName,
    __in_opt LPWSTR ObjectName,
    __in     PSECURITY_DESCRIPTOR SecurityDescriptor,
    __in     DWORD DesiredAccess,
    __in     PGENERIC_MAPPING GenericMapping,
    __in     BOOL ObjectCreation,
    __out    LPDWORD GrantedAccess,
    __out    LPBOOL AccessStatus,
    __out    LPBOOL pfGenerateOnClose
    );

version(UNICODE) {
	alias AccessCheckAndAuditAlarmW AccessCheckAndAuditAlarm;
}
else {
	alias AccessCheckAndAuditAlarmA AccessCheckAndAuditAlarm;
}

#if(_WIN32_WINNT >= 0x0500)

WINADVAPI
BOOL
AccessCheckByTypeAndAuditAlarmA (
    __in     LPCSTR SubsystemName,
    __in     LPVOID HandleId,
    __in     LPCSTR ObjectTypeName,
    __in_opt LPCSTR ObjectName,
    __in     PSECURITY_DESCRIPTOR SecurityDescriptor,
    __in_opt PSID PrincipalSelfSid,
    __in     DWORD DesiredAccess,
    __in     AUDIT_EVENT_TYPE AuditType,
    __in     DWORD Flags,
    __inout_ecount_opt(ObjectTypeListLength) POBJECT_TYPE_LIST ObjectTypeList,
    __in     DWORD ObjectTypeListLength,
    __in     PGENERIC_MAPPING GenericMapping,
    __in     BOOL ObjectCreation,
    __out    LPDWORD GrantedAccess,
    __out    LPBOOL AccessStatus,
    __out    LPBOOL pfGenerateOnClose
    );
WINADVAPI
BOOL
AccessCheckByTypeAndAuditAlarmW (
    __in     LPCWSTR SubsystemName,
    __in     LPVOID HandleId,
    __in     LPCWSTR ObjectTypeName,
    __in_opt LPCWSTR ObjectName,
    __in     PSECURITY_DESCRIPTOR SecurityDescriptor,
    __in_opt PSID PrincipalSelfSid,
    __in     DWORD DesiredAccess,
    __in     AUDIT_EVENT_TYPE AuditType,
    __in     DWORD Flags,
    __inout_ecount_opt(ObjectTypeListLength) POBJECT_TYPE_LIST ObjectTypeList,
    __in     DWORD ObjectTypeListLength,
    __in     PGENERIC_MAPPING GenericMapping,
    __in     BOOL ObjectCreation,
    __out    LPDWORD GrantedAccess,
    __out    LPBOOL AccessStatus,
    __out    LPBOOL pfGenerateOnClose
    );

version(UNICODE) {
	alias AccessCheckByTypeAndAuditAlarmW AccessCheckByTypeAndAuditAlarm;
}
else {
	alias AccessCheckByTypeAndAuditAlarmA AccessCheckByTypeAndAuditAlarm;
}

WINADVAPI
BOOL
AccessCheckByTypeResultListAndAuditAlarmA (
    __in     LPCSTR SubsystemName,
    __in     LPVOID HandleId,
    __in     LPCSTR ObjectTypeName,
    __in_opt LPCSTR ObjectName,
    __in     PSECURITY_DESCRIPTOR SecurityDescriptor,
    __in_opt PSID PrincipalSelfSid,
    __in     DWORD DesiredAccess,
    __in     AUDIT_EVENT_TYPE AuditType,
    __in     DWORD Flags,
    __inout_ecount_opt(ObjectTypeListLength) POBJECT_TYPE_LIST ObjectTypeList,
    __in     DWORD ObjectTypeListLength,
    __in     PGENERIC_MAPPING GenericMapping,
    __in     BOOL ObjectCreation,
    __out    LPDWORD GrantedAccess,
    __out    LPDWORD AccessStatusList,
    __out    LPBOOL pfGenerateOnClose
    );
WINADVAPI
BOOL
AccessCheckByTypeResultListAndAuditAlarmW (
    __in     LPCWSTR SubsystemName,
    __in     LPVOID HandleId,
    __in     LPCWSTR ObjectTypeName,
    __in_opt LPCWSTR ObjectName,
    __in     PSECURITY_DESCRIPTOR SecurityDescriptor,
    __in_opt PSID PrincipalSelfSid,
    __in     DWORD DesiredAccess,
    __in     AUDIT_EVENT_TYPE AuditType,
    __in     DWORD Flags,
    __inout_ecount_opt(ObjectTypeListLength) POBJECT_TYPE_LIST ObjectTypeList,
    __in     DWORD ObjectTypeListLength,
    __in     PGENERIC_MAPPING GenericMapping,
    __in     BOOL ObjectCreation,
    __out    LPDWORD GrantedAccess,
    __out    LPDWORD AccessStatusList,
    __out    LPBOOL pfGenerateOnClose
    );

version(UNICODE) {
	alias AccessCheckByTypeResultListAndAuditAlarmW AccessCheckByTypeResultListAndAuditAlarm;
}
else {
	alias AccessCheckByTypeResultListAndAuditAlarmA AccessCheckByTypeResultListAndAuditAlarm;
}

WINADVAPI
BOOL
AccessCheckByTypeResultListAndAuditAlarmByHandleA (
    __in     LPCSTR SubsystemName,
    __in     LPVOID HandleId,
    __in     HANDLE ClientToken,
    __in     LPCSTR ObjectTypeName,
    __in_opt LPCSTR ObjectName,
    __in     PSECURITY_DESCRIPTOR SecurityDescriptor,
    __in_opt PSID PrincipalSelfSid,
    __in     DWORD DesiredAccess,
    __in     AUDIT_EVENT_TYPE AuditType,
    __in     DWORD Flags,
    __inout_ecount_opt(ObjectTypeListLength) POBJECT_TYPE_LIST ObjectTypeList,
    __in     DWORD ObjectTypeListLength,
    __in     PGENERIC_MAPPING GenericMapping,
    __in     BOOL ObjectCreation,
    __out    LPDWORD GrantedAccess,
    __out    LPDWORD AccessStatusList,
    __out    LPBOOL pfGenerateOnClose
    );
WINADVAPI
BOOL
AccessCheckByTypeResultListAndAuditAlarmByHandleW (
    __in     LPCWSTR SubsystemName,
    __in     LPVOID HandleId,
    __in     HANDLE ClientToken,
    __in     LPCWSTR ObjectTypeName,
    __in_opt LPCWSTR ObjectName,
    __in     PSECURITY_DESCRIPTOR SecurityDescriptor,
    __in_opt PSID PrincipalSelfSid,
    __in     DWORD DesiredAccess,
    __in     AUDIT_EVENT_TYPE AuditType,
    __in     DWORD Flags,
    __inout_ecount_opt(ObjectTypeListLength) POBJECT_TYPE_LIST ObjectTypeList,
    __in     DWORD ObjectTypeListLength,
    __in     PGENERIC_MAPPING GenericMapping,
    __in     BOOL ObjectCreation,
    __out    LPDWORD GrantedAccess,
    __out    LPDWORD AccessStatusList,
    __out    LPBOOL pfGenerateOnClose
    );

version(UNICODE) {
	alias AccessCheckByTypeResultListAndAuditAlarmByHandleW AccessCheckByTypeResultListAndAuditAlarmByHandle;
}
else {
	alias AccessCheckByTypeResultListAndAuditAlarmByHandleA AccessCheckByTypeResultListAndAuditAlarmByHandle;
}

#endif //(_WIN32_WINNT >= 0x0500)

WINADVAPI
BOOL
ObjectOpenAuditAlarmA (
    __in     LPCSTR SubsystemName,
    __in     LPVOID HandleId,
    __in     LPSTR ObjectTypeName,
    __in_opt LPSTR ObjectName,
    __in     PSECURITY_DESCRIPTOR pSecurityDescriptor,
    __in     HANDLE ClientToken,
    __in     DWORD DesiredAccess,
    __in     DWORD GrantedAccess,
    __in_opt PPRIVILEGE_SET Privileges,
    __in     BOOL ObjectCreation,
    __in     BOOL AccessGranted,
    __out    LPBOOL GenerateOnClose
    );
WINADVAPI
BOOL
ObjectOpenAuditAlarmW (
    __in     LPCWSTR SubsystemName,
    __in     LPVOID HandleId,
    __in     LPWSTR ObjectTypeName,
    __in_opt LPWSTR ObjectName,
    __in     PSECURITY_DESCRIPTOR pSecurityDescriptor,
    __in     HANDLE ClientToken,
    __in     DWORD DesiredAccess,
    __in     DWORD GrantedAccess,
    __in_opt PPRIVILEGE_SET Privileges,
    __in     BOOL ObjectCreation,
    __in     BOOL AccessGranted,
    __out    LPBOOL GenerateOnClose
    );

version(UNICODE) {
	alias ObjectOpenAuditAlarmW ObjectOpenAuditAlarm;
}
else {
	alias ObjectOpenAuditAlarmA ObjectOpenAuditAlarm;
}


WINADVAPI
BOOL
ObjectPrivilegeAuditAlarmA (
    __in LPCSTR SubsystemName,
    __in LPVOID HandleId,
    __in HANDLE ClientToken,
    __in DWORD DesiredAccess,
    __in PPRIVILEGE_SET Privileges,
    __in BOOL AccessGranted
    );
WINADVAPI
BOOL
ObjectPrivilegeAuditAlarmW (
    __in LPCWSTR SubsystemName,
    __in LPVOID HandleId,
    __in HANDLE ClientToken,
    __in DWORD DesiredAccess,
    __in PPRIVILEGE_SET Privileges,
    __in BOOL AccessGranted
    );

version(UNICODE) {
	alias ObjectPrivilegeAuditAlarmW ObjectPrivilegeAuditAlarm;
}
else {
	alias ObjectPrivilegeAuditAlarmA ObjectPrivilegeAuditAlarm;
}


WINADVAPI
BOOL
ObjectCloseAuditAlarmA (
    __in LPCSTR SubsystemName,
    __in LPVOID HandleId,
    __in BOOL GenerateOnClose
    );
WINADVAPI
BOOL
ObjectCloseAuditAlarmW (
    __in LPCWSTR SubsystemName,
    __in LPVOID HandleId,
    __in BOOL GenerateOnClose
    );

version(UNICODE) {
	alias ObjectCloseAuditAlarmW ObjectCloseAuditAlarm;
}
else {
	alias ObjectCloseAuditAlarmA ObjectCloseAuditAlarm;
}


WINADVAPI
BOOL
ObjectDeleteAuditAlarmA (
    __in LPCSTR SubsystemName,
    __in LPVOID HandleId,
    __in BOOL GenerateOnClose
    );
WINADVAPI
BOOL
ObjectDeleteAuditAlarmW (
    __in LPCWSTR SubsystemName,
    __in LPVOID HandleId,
    __in BOOL GenerateOnClose
    );

version(UNICODE) {
	alias ObjectDeleteAuditAlarmW ObjectDeleteAuditAlarm;
}
else {
	alias ObjectDeleteAuditAlarmA ObjectDeleteAuditAlarm;
}


WINADVAPI
BOOL
PrivilegedServiceAuditAlarmA (
    __in LPCSTR SubsystemName,
    __in LPCSTR ServiceName,
    __in HANDLE ClientToken,
    __in PPRIVILEGE_SET Privileges,
    __in BOOL AccessGranted
    );
WINADVAPI
BOOL
PrivilegedServiceAuditAlarmW (
    __in LPCWSTR SubsystemName,
    __in LPCWSTR ServiceName,
    __in HANDLE ClientToken,
    __in PPRIVILEGE_SET Privileges,
    __in BOOL AccessGranted
    );

version(UNICODE) {
	alias PrivilegedServiceAuditAlarmW PrivilegedServiceAuditAlarm;
}
else {
	alias PrivilegedServiceAuditAlarmA PrivilegedServiceAuditAlarm;
}



#if(_WIN32_WINNT >= 0x0501)


WINADVAPI
BOOL
IsWellKnownSid (
    __in PSID pSid,
    __in WELL_KNOWN_SID_TYPE WellKnownSidType
    );

WINADVAPI
BOOL
CreateWellKnownSid(
    __in     WELL_KNOWN_SID_TYPE WellKnownSidType,
    __in_opt PSID DomainSid,
    __out_bcount_part_opt(*cbSid, *cbSid) PSID pSid,
    __inout  DWORD *cbSid
    );

WINADVAPI
BOOL
EqualDomainSid(
    __in  PSID pSid1,
    __in  PSID pSid2,
    __out BOOL *pfEqual
    );

WINADVAPI
BOOL
GetWindowsAccountDomainSid(
    __in    PSID pSid,
    __out_bcount_part_opt(*cbDomainSid, *cbDomainSid) PSID pDomainSid,
    __inout DWORD* cbDomainSid
    );

#endif //(_WIN32_WINNT >= 0x0501)

WINADVAPI
BOOL
IsValidSid (
    __in PSID pSid
    );


WINADVAPI
BOOL
EqualSid (
    __in PSID pSid1,
    __in PSID pSid2
    );


WINADVAPI
BOOL
EqualPrefixSid (
    __in PSID pSid1,
    __in PSID pSid2
    );


WINADVAPI
DWORD
GetSidLengthRequired (
    __in UCHAR nSubAuthorityCount
    );


WINADVAPI
BOOL
AllocateAndInitializeSid (
    __in        PSID_IDENTIFIER_AUTHORITY pIdentifierAuthority,
    __in        BYTE nSubAuthorityCount,
    __in        DWORD nSubAuthority0,
    __in        DWORD nSubAuthority1,
    __in        DWORD nSubAuthority2,
    __in        DWORD nSubAuthority3,
    __in        DWORD nSubAuthority4,
    __in        DWORD nSubAuthority5,
    __in        DWORD nSubAuthority6,
    __in        DWORD nSubAuthority7,
    __deref_out PSID *pSid
    );

WINADVAPI
PVOID
FreeSid(
    __in PSID pSid
    );

WINADVAPI
BOOL
InitializeSid (
    __out PSID Sid,
    __in  PSID_IDENTIFIER_AUTHORITY pIdentifierAuthority,
    __in  BYTE nSubAuthorityCount
    );


WINADVAPI
__out
PSID_IDENTIFIER_AUTHORITY
GetSidIdentifierAuthority (
    __in PSID pSid
    );


WINADVAPI
__out
PDWORD
GetSidSubAuthority (
    __in PSID pSid,
    __in DWORD nSubAuthority
    );


WINADVAPI
__out
PUCHAR
GetSidSubAuthorityCount (
    __in PSID pSid
    );


WINADVAPI
DWORD
GetLengthSid (
    __in PSID pSid
    );


WINADVAPI
BOOL
CopySid (
    __in DWORD nDestinationSidLength,
    __out_bcount(nDestinationSidLength) PSID pDestinationSid,
    __in PSID pSourceSid
    );


WINADVAPI
BOOL
AreAllAccessesGranted (
    __in DWORD GrantedAccess,
    __in DWORD DesiredAccess
    );


WINADVAPI
BOOL
AreAnyAccessesGranted (
    __in DWORD GrantedAccess,
    __in DWORD DesiredAccess
    );


WINADVAPI
VOID
MapGenericMask (
    __inout PDWORD AccessMask,
    __in    PGENERIC_MAPPING GenericMapping
    );


WINADVAPI
BOOL
IsValidAcl (
    __in PACL pAcl
    );


WINADVAPI
BOOL
InitializeAcl (
    __out_bcount(nAclLength) PACL pAcl,
    __in DWORD nAclLength,
    __in DWORD dwAclRevision
    );


WINADVAPI
BOOL
GetAclInformation (
    __in PACL pAcl,
    __out_bcount(nAclInformationLength) LPVOID pAclInformation,
    __in DWORD nAclInformationLength,
    __in ACL_INFORMATION_CLASS dwAclInformationClass
    );


WINADVAPI
BOOL
SetAclInformation (
    __inout PACL pAcl,
    __in_bcount(nAclInformationLength) LPVOID pAclInformation,
    __in    DWORD nAclInformationLength,
    __in    ACL_INFORMATION_CLASS dwAclInformationClass
    );


WINADVAPI
BOOL
AddAce (
    __inout PACL pAcl,
    __in    DWORD dwAceRevision,
    __in    DWORD dwStartingAceIndex,
    __in_bcount(nAceListLength) LPVOID pAceList,
    __in    DWORD nAceListLength
    );


WINADVAPI
BOOL
DeleteAce (
    __inout PACL pAcl,
    __in    DWORD dwAceIndex
    );


WINADVAPI
BOOL
GetAce (
    __in        PACL pAcl,
    __in        DWORD dwAceIndex,
    __deref_out LPVOID *pAce
    );


WINADVAPI
BOOL
AddAccessAllowedAce (
    __inout PACL pAcl,
    __in    DWORD dwAceRevision,
    __in    DWORD AccessMask,
    __in    PSID pSid
    );

#if(_WIN32_WINNT >= 0x0500)
WINADVAPI
BOOL
AddAccessAllowedAceEx (
    __inout PACL pAcl,
    __in    DWORD dwAceRevision,
    __in    DWORD AceFlags,
    __in    DWORD AccessMask,
    __in    PSID pSid
    );
#endif /* _WIN32_WINNT >=  0x0500 */

#if(_WIN32_WINNT >= 0x0600)
WINADVAPI
BOOL
AddMandatoryAce (
    __inout PACL pAcl,
    __in    DWORD dwAceRevision,
    __in    DWORD AceFlags,
    __in    DWORD MandatoryPolicy,
    __in    PSID pLabelSid
    );
#endif /* _WIN32_WINNT >=  0x0600 */

WINADVAPI
BOOL
AddAccessDeniedAce (
    __inout PACL pAcl,
    __in    DWORD dwAceRevision,
    __in    DWORD AccessMask,
    __in    PSID pSid
    );

#if(_WIN32_WINNT >= 0x0500)
WINADVAPI
BOOL
AddAccessDeniedAceEx (
    __inout PACL pAcl,
    __in    DWORD dwAceRevision,
    __in    DWORD AceFlags,
    __in    DWORD AccessMask,
    __in    PSID pSid
    );
#endif /* _WIN32_WINNT >=  0x0500 */

WINADVAPI
BOOL
AddAuditAccessAce(
    __inout PACL pAcl,
    __in    DWORD dwAceRevision,
    __in    DWORD dwAccessMask,
    __in    PSID pSid,
    __in    BOOL bAuditSuccess,
    __in    BOOL bAuditFailure
    );

#if(_WIN32_WINNT >= 0x0500)
WINADVAPI
BOOL
AddAuditAccessAceEx(
    __inout PACL pAcl,
    __in    DWORD dwAceRevision,
    __in    DWORD AceFlags,
    __in    DWORD dwAccessMask,
    __in    PSID pSid,
    __in    BOOL bAuditSuccess,
    __in    BOOL bAuditFailure
    );

WINADVAPI
BOOL
AddAccessAllowedObjectAce (
    __inout  PACL pAcl,
    __in     DWORD dwAceRevision,
    __in     DWORD AceFlags,
    __in     DWORD AccessMask,
    __in_opt GUID *ObjectTypeGuid,
    __in_opt GUID *InheritedObjectTypeGuid,
    __in     PSID pSid
    );

WINADVAPI
BOOL
AddAccessDeniedObjectAce (
    __inout  PACL pAcl,
    __in     DWORD dwAceRevision,
    __in     DWORD AceFlags,
    __in     DWORD AccessMask,
    __in_opt GUID *ObjectTypeGuid,
    __in_opt GUID *InheritedObjectTypeGuid,
    __in     PSID pSid
    );

WINADVAPI
BOOL
AddAuditAccessObjectAce (
    __inout  PACL pAcl,
    __in     DWORD dwAceRevision,
    __in     DWORD AceFlags,
    __in     DWORD AccessMask,
    __in_opt GUID *ObjectTypeGuid,
    __in_opt GUID *InheritedObjectTypeGuid,
    __in     PSID pSid,
    __in     BOOL bAuditSuccess,
    __in     BOOL bAuditFailure
    );
#endif /* _WIN32_WINNT >=  0x0500 */

WINADVAPI
BOOL
FindFirstFreeAce (
    __in        PACL pAcl,
    __deref_out LPVOID *pAce
    );


WINADVAPI
BOOL
InitializeSecurityDescriptor (
    __out PSECURITY_DESCRIPTOR pSecurityDescriptor,
    __in  DWORD dwRevision
    );


WINADVAPI
BOOL
IsValidSecurityDescriptor (
    __in PSECURITY_DESCRIPTOR pSecurityDescriptor
    );

WINADVAPI
BOOL
IsValidRelativeSecurityDescriptor (
    __in PSECURITY_DESCRIPTOR pSecurityDescriptor,
    __in ULONG SecurityDescriptorLength,
    __in SECURITY_INFORMATION RequiredInformation
    );

WINADVAPI
DWORD
GetSecurityDescriptorLength (
    __in PSECURITY_DESCRIPTOR pSecurityDescriptor
    );


WINADVAPI
BOOL
GetSecurityDescriptorControl (
    __in  PSECURITY_DESCRIPTOR pSecurityDescriptor,
    __out PSECURITY_DESCRIPTOR_CONTROL pControl,
    __out LPDWORD lpdwRevision
    );

#if(_WIN32_WINNT >= 0x0500)
WINADVAPI
BOOL
SetSecurityDescriptorControl (
    __in PSECURITY_DESCRIPTOR pSecurityDescriptor,
    __in SECURITY_DESCRIPTOR_CONTROL ControlBitsOfInterest,
    __in SECURITY_DESCRIPTOR_CONTROL ControlBitsToSet
    );
#endif /* _WIN32_WINNT >=  0x0500 */

WINADVAPI
BOOL
SetSecurityDescriptorDacl (
    __inout  PSECURITY_DESCRIPTOR pSecurityDescriptor,
    __in     BOOL bDaclPresent,
    __in_opt PACL pDacl,
    __in     BOOL bDaclDefaulted
    );


WINADVAPI
BOOL
GetSecurityDescriptorDacl (
    __in        PSECURITY_DESCRIPTOR pSecurityDescriptor,
    __out       LPBOOL lpbDaclPresent,
    __deref_out PACL *pDacl,
    __out       LPBOOL lpbDaclDefaulted
    );


WINADVAPI
BOOL
SetSecurityDescriptorSacl (
    __inout  PSECURITY_DESCRIPTOR pSecurityDescriptor,
    __in     BOOL bSaclPresent,
    __in_opt PACL pSacl,
    __in     BOOL bSaclDefaulted
    );


WINADVAPI
BOOL
GetSecurityDescriptorSacl (
    __in        PSECURITY_DESCRIPTOR pSecurityDescriptor,
    __out       LPBOOL lpbSaclPresent,
    __deref_out PACL *pSacl,
    __out       LPBOOL lpbSaclDefaulted
    );


WINADVAPI
BOOL
SetSecurityDescriptorOwner (
    __inout  PSECURITY_DESCRIPTOR pSecurityDescriptor,
    __in_opt PSID pOwner,
    __in     BOOL bOwnerDefaulted
    );


WINADVAPI
BOOL
GetSecurityDescriptorOwner (
    __in        PSECURITY_DESCRIPTOR pSecurityDescriptor,
    __deref_out PSID *pOwner,
    __out       LPBOOL lpbOwnerDefaulted
    );


WINADVAPI
BOOL
SetSecurityDescriptorGroup (
    __inout  PSECURITY_DESCRIPTOR pSecurityDescriptor,
    __in_opt PSID pGroup,
    __in     BOOL bGroupDefaulted
    );


WINADVAPI
BOOL
GetSecurityDescriptorGroup (
    __in        PSECURITY_DESCRIPTOR pSecurityDescriptor,
    __deref_out PSID *pGroup,
    __out       LPBOOL lpbGroupDefaulted
    );


WINADVAPI
DWORD
SetSecurityDescriptorRMControl(
    __inout  PSECURITY_DESCRIPTOR SecurityDescriptor,
    __in_opt PUCHAR RMControl
    );

WINADVAPI
DWORD
GetSecurityDescriptorRMControl(
    __in  PSECURITY_DESCRIPTOR SecurityDescriptor,
    __out PUCHAR RMControl
    );

WINADVAPI
BOOL
CreatePrivateObjectSecurity (
    __in_opt    PSECURITY_DESCRIPTOR ParentDescriptor,
    __in_opt    PSECURITY_DESCRIPTOR CreatorDescriptor,
    __deref_out PSECURITY_DESCRIPTOR * NewDescriptor,
    __in        BOOL IsDirectoryObject,
    __in_opt    HANDLE Token,
    __in        PGENERIC_MAPPING GenericMapping
    );

#if(_WIN32_WINNT >= 0x0500)
WINADVAPI
BOOL
ConvertToAutoInheritPrivateObjectSecurity(
    __in_opt    PSECURITY_DESCRIPTOR ParentDescriptor,
    __in        PSECURITY_DESCRIPTOR CurrentSecurityDescriptor,
    __deref_out PSECURITY_DESCRIPTOR *NewSecurityDescriptor,
    __in_opt    GUID *ObjectType,
    __in        BOOLEAN IsDirectoryObject,
    __in        PGENERIC_MAPPING GenericMapping
    );

WINADVAPI
BOOL
CreatePrivateObjectSecurityEx (
    __in_opt    PSECURITY_DESCRIPTOR ParentDescriptor,
    __in_opt    PSECURITY_DESCRIPTOR CreatorDescriptor,
    __deref_out PSECURITY_DESCRIPTOR * NewDescriptor,
    __in_opt    GUID *ObjectType,
    __in        BOOL IsContainerObject,
    __in        ULONG AutoInheritFlags,
    __in_opt    HANDLE Token,
    __in        PGENERIC_MAPPING GenericMapping
    );

WINADVAPI
BOOL
CreatePrivateObjectSecurityWithMultipleInheritance (
    __in_opt    PSECURITY_DESCRIPTOR ParentDescriptor,
    __in_opt    PSECURITY_DESCRIPTOR CreatorDescriptor,
    __deref_out PSECURITY_DESCRIPTOR * NewDescriptor,
    __in_ecount_opt(GuidCount) GUID **ObjectTypes,
    __in        ULONG GuidCount,
    __in        BOOL IsContainerObject,
    __in        ULONG AutoInheritFlags,
    __in_opt    HANDLE Token,
    __in        PGENERIC_MAPPING GenericMapping
    );
#endif /* _WIN32_WINNT >=  0x0500 */

WINADVAPI
BOOL
SetPrivateObjectSecurity (
    __in          SECURITY_INFORMATION SecurityInformation,
    __in          PSECURITY_DESCRIPTOR ModificationDescriptor,
    __deref_inout PSECURITY_DESCRIPTOR *ObjectsSecurityDescriptor,
    __in          PGENERIC_MAPPING GenericMapping,
    __in_opt      HANDLE Token
    );

#if(_WIN32_WINNT >= 0x0500)
WINADVAPI
BOOL
SetPrivateObjectSecurityEx (
    __in          SECURITY_INFORMATION SecurityInformation,
    __in          PSECURITY_DESCRIPTOR ModificationDescriptor,
    __deref_inout PSECURITY_DESCRIPTOR *ObjectsSecurityDescriptor,
    __in          ULONG AutoInheritFlags,
    __in          PGENERIC_MAPPING GenericMapping,
    __in_opt      HANDLE Token
    );
#endif /* _WIN32_WINNT >=  0x0500 */

WINADVAPI
BOOL
GetPrivateObjectSecurity (
    __in  PSECURITY_DESCRIPTOR ObjectDescriptor,
    __in  SECURITY_INFORMATION SecurityInformation,
    __out_bcount_part_opt(DescriptorLength, *ReturnLength) PSECURITY_DESCRIPTOR ResultantDescriptor,
    __in  DWORD DescriptorLength,
    __out PDWORD ReturnLength
    );


WINADVAPI
BOOL
DestroyPrivateObjectSecurity (
    __deref PSECURITY_DESCRIPTOR * ObjectDescriptor
    );


WINADVAPI
BOOL
MakeSelfRelativeSD (
    __in    PSECURITY_DESCRIPTOR pAbsoluteSecurityDescriptor,
    __out_bcount_part_opt(*lpdwBufferLength, *lpdwBufferLength) PSECURITY_DESCRIPTOR pSelfRelativeSecurityDescriptor,
    __inout LPDWORD lpdwBufferLength
    );


WINADVAPI
BOOL
MakeAbsoluteSD (
    __in    PSECURITY_DESCRIPTOR pSelfRelativeSecurityDescriptor,
    __out_bcount_part_opt(*lpdwAbsoluteSecurityDescriptorSize, *lpdwAbsoluteSecurityDescriptorSize) PSECURITY_DESCRIPTOR pAbsoluteSecurityDescriptor,
    __inout LPDWORD lpdwAbsoluteSecurityDescriptorSize,
    __out_bcount_part_opt(*lpdwDaclSize, *lpdwDaclSize) PACL pDacl,
    __inout LPDWORD lpdwDaclSize,
    __out_bcount_part_opt(*lpdwSaclSize, *lpdwSaclSize) PACL pSacl,
    __inout LPDWORD lpdwSaclSize,
    __out_bcount_part_opt(*lpdwOwnerSize, *lpdwOwnerSize) PSID pOwner,
    __inout LPDWORD lpdwOwnerSize,
    __out_bcount_part_opt(*lpdwPrimaryGroupSize, *lpdwPrimaryGroupSize) PSID pPrimaryGroup,
    __inout LPDWORD lpdwPrimaryGroupSize
    );


WINADVAPI
BOOL
MakeAbsoluteSD2 (
    __inout_bcount_part(*lpdwBufferSize, *lpdwBufferSize) PSECURITY_DESCRIPTOR pSelfRelativeSecurityDescriptor,
    __inout LPDWORD lpdwBufferSize
    );

WINADVAPI
VOID
QuerySecurityAccessMask(
    __in SECURITY_INFORMATION SecurityInformation,
    __out LPDWORD DesiredAccess
    );

WINADVAPI
VOID
SetSecurityAccessMask(
    __in SECURITY_INFORMATION SecurityInformation,
    __out LPDWORD DesiredAccess
    );

WINADVAPI
BOOL
SetFileSecurityA (
    __in LPCSTR lpFileName,
    __in SECURITY_INFORMATION SecurityInformation,
    __in PSECURITY_DESCRIPTOR pSecurityDescriptor
    );
WINADVAPI
BOOL
SetFileSecurityW (
    __in LPCWSTR lpFileName,
    __in SECURITY_INFORMATION SecurityInformation,
    __in PSECURITY_DESCRIPTOR pSecurityDescriptor
    );

version(UNICODE) {
	alias SetFileSecurityW SetFileSecurity;
}
else {
	alias SetFileSecurityA SetFileSecurity;
}


WINADVAPI
BOOL
GetFileSecurityA (
    __in  LPCSTR lpFileName,
    __in  SECURITY_INFORMATION RequestedInformation,
    __out_bcount_part_opt(nLength, *lpnLengthNeeded) PSECURITY_DESCRIPTOR pSecurityDescriptor,
    __in  DWORD nLength,
    __out LPDWORD lpnLengthNeeded
    );
WINADVAPI
BOOL
GetFileSecurityW (
    __in  LPCWSTR lpFileName,
    __in  SECURITY_INFORMATION RequestedInformation,
    __out_bcount_part_opt(nLength, *lpnLengthNeeded) PSECURITY_DESCRIPTOR pSecurityDescriptor,
    __in  DWORD nLength,
    __out LPDWORD lpnLengthNeeded
    );

version(UNICODE) {
	alias GetFileSecurityW GetFileSecurity;
}
else {
	alias GetFileSecurityA GetFileSecurity;
}


WINADVAPI
BOOL
SetKernelObjectSecurity (
    __in HANDLE Handle,
    __in SECURITY_INFORMATION SecurityInformation,
    __in PSECURITY_DESCRIPTOR SecurityDescriptor
    );

__out
HANDLE
FindFirstChangeNotificationA(
    __in LPCSTR lpPathName,
    __in BOOL bWatchSubtree,
    __in DWORD dwNotifyFilter
    );
__out
HANDLE
FindFirstChangeNotificationW(
    __in LPCWSTR lpPathName,
    __in BOOL bWatchSubtree,
    __in DWORD dwNotifyFilter
    );

version(UNICODE) {
	alias FindFirstChangeNotificationW FindFirstChangeNotification;
}
else {
	alias FindFirstChangeNotificationA FindFirstChangeNotification;
}

BOOL
FindNextChangeNotification(
    __in HANDLE hChangeHandle
    );

BOOL
FindCloseChangeNotification(
    __in HANDLE hChangeHandle
    );

#if(_WIN32_WINNT >= 0x0400)
BOOL
ReadDirectoryChangesW(
    __in        HANDLE hDirectory,
    __out_bcount_part(nBufferLength, *lpBytesReturned) LPVOID lpBuffer,
    __in        DWORD nBufferLength,
    __in        BOOL bWatchSubtree,
    __in        DWORD dwNotifyFilter,
    __out_opt   LPDWORD lpBytesReturned,
    __inout_opt LPOVERLAPPED lpOverlapped,
    __in_opt    LPOVERLAPPED_COMPLETION_ROUTINE lpCompletionRoutine
    );
#endif /* _WIN32_WINNT >= 0x0400 */

BOOL
VirtualLock(
    __in LPVOID lpAddress,
    __in SIZE_T dwSize
    );

BOOL
VirtualUnlock(
    __in LPVOID lpAddress,
    __in SIZE_T dwSize
    );

__out_opt __out_data_source(FILE)
LPVOID
MapViewOfFileEx(
    __in     HANDLE hFileMappingObject,
    __in     DWORD dwDesiredAccess,
    __in     DWORD dwFileOffsetHigh,
    __in     DWORD dwFileOffsetLow,
    __in     SIZE_T dwNumberOfBytesToMap,
    __in_opt LPVOID lpBaseAddress
    );

#if _WIN32_WINNT >= 0x0600

__out __out_data_source(FILE)
LPVOID
MapViewOfFileExNuma(
    __in     HANDLE hFileMappingObject,
    __in     DWORD dwDesiredAccess,
    __in     DWORD dwFileOffsetHigh,
    __in     DWORD dwFileOffsetLow,
    __in     SIZE_T dwNumberOfBytesToMap,
    __in_opt LPVOID lpBaseAddress,
    __in     DWORD nndPreferred
    );

#endif // _WIN32_WINNT >= 0x0600

BOOL
SetPriorityClass(
    __in HANDLE hProcess,
    __in DWORD dwPriorityClass
    );

DWORD
GetPriorityClass(
    __in HANDLE hProcess
    );

BOOL
IsBadReadPtr(
    __in_opt CONST VOID *lp,
    __in     UINT_PTR ucb
    );

BOOL
IsBadWritePtr(
    __in_opt LPVOID lp,
    __in     UINT_PTR ucb
    );

BOOL
IsBadHugeReadPtr(
    __in_opt CONST VOID *lp,
    __in     UINT_PTR ucb
    );

BOOL
IsBadHugeWritePtr(
    __in_opt LPVOID lp,
    __in     UINT_PTR ucb
    );

BOOL
IsBadCodePtr(
    __in_opt FARPROC lpfn
    );

BOOL
IsBadStringPtrA(
    __in_opt LPCSTR lpsz,
    __in     UINT_PTR ucchMax
    );
BOOL
IsBadStringPtrW(
    __in_opt LPCWSTR lpsz,
    __in     UINT_PTR ucchMax
    );

version(UNICODE) {
	alias IsBadStringPtrW IsBadStringPtr;
}
else {
	alias IsBadStringPtrA IsBadStringPtr;
}

WINADVAPI
BOOL
LookupAccountSidA(
    __in_opt LPCSTR lpSystemName,
    __in PSID Sid,
    __out_ecount_part_opt(*cchName, *cchName + 1) LPSTR Name,
    __inout  LPDWORD cchName,
    __out_ecount_part_opt(*cchReferencedDomainName, *cchReferencedDomainName + 1) LPSTR ReferencedDomainName,
    __inout LPDWORD cchReferencedDomainName,
    __out PSID_NAME_USE peUse
    );
WINADVAPI
BOOL
LookupAccountSidW(
    __in_opt LPCWSTR lpSystemName,
    __in PSID Sid,
    __out_ecount_part_opt(*cchName, *cchName + 1) LPWSTR Name,
    __inout  LPDWORD cchName,
    __out_ecount_part_opt(*cchReferencedDomainName, *cchReferencedDomainName + 1) LPWSTR ReferencedDomainName,
    __inout LPDWORD cchReferencedDomainName,
    __out PSID_NAME_USE peUse
    );

version(UNICODE) {
	alias LookupAccountSidW LookupAccountSid;
}
else {
	alias LookupAccountSidA LookupAccountSid;
}

WINADVAPI
BOOL
LookupAccountNameA(
    __in_opt LPCSTR lpSystemName,
    __in     LPCSTR lpAccountName,
    __out_bcount_part_opt(*cbSid, *cbSid) PSID Sid,
    __inout  LPDWORD cbSid,
    __out_ecount_part_opt(*cchReferencedDomainName, *cchReferencedDomainName + 1) LPSTR ReferencedDomainName,
    __inout  LPDWORD cchReferencedDomainName,
    __out    PSID_NAME_USE peUse
    );
WINADVAPI
BOOL
LookupAccountNameW(
    __in_opt LPCWSTR lpSystemName,
    __in     LPCWSTR lpAccountName,
    __out_bcount_part_opt(*cbSid, *cbSid) PSID Sid,
    __inout  LPDWORD cbSid,
    __out_ecount_part_opt(*cchReferencedDomainName, *cchReferencedDomainName + 1) LPWSTR ReferencedDomainName,
    __inout  LPDWORD cchReferencedDomainName,
    __out    PSID_NAME_USE peUse
    );

version(UNICODE) {
	alias LookupAccountNameW LookupAccountName;
}
else {
	alias LookupAccountNameA LookupAccountName;
}

WINADVAPI
BOOL
LookupPrivilegeValueA(
    __in_opt LPCSTR lpSystemName,
    __in     LPCSTR lpName,
    __out    PLUID   lpLuid
    );
WINADVAPI
BOOL
LookupPrivilegeValueW(
    __in_opt LPCWSTR lpSystemName,
    __in     LPCWSTR lpName,
    __out    PLUID   lpLuid
    );

version(UNICODE) {
	alias LookupPrivilegeValueW LookupPrivilegeValue;
}
else {
	alias LookupPrivilegeValueA LookupPrivilegeValue;
}

WINADVAPI
BOOL
LookupPrivilegeNameA(
    __in_opt LPCSTR lpSystemName,
    __in     PLUID   lpLuid,
    __out_ecount_part_opt(*cchName, *cchName + 1) LPSTR lpName,
    __inout  LPDWORD cchName
    );
WINADVAPI
BOOL
LookupPrivilegeNameW(
    __in_opt LPCWSTR lpSystemName,
    __in     PLUID   lpLuid,
    __out_ecount_part_opt(*cchName, *cchName + 1) LPWSTR lpName,
    __inout  LPDWORD cchName
    );

version(UNICODE) {
	alias LookupPrivilegeNameW LookupPrivilegeName;
}
else {
	alias LookupPrivilegeNameA LookupPrivilegeName;
}

WINADVAPI
BOOL
LookupPrivilegeDisplayNameA(
    __in_opt LPCSTR lpSystemName,
    __in     LPCSTR lpName,
    __out_ecount_part_opt(*cchDisplayName, *cchDisplayName + 1) LPSTR lpDisplayName,
    __inout  LPDWORD cchDisplayName,
    __out    LPDWORD lpLanguageId
    );
WINADVAPI
BOOL
LookupPrivilegeDisplayNameW(
    __in_opt LPCWSTR lpSystemName,
    __in     LPCWSTR lpName,
    __out_ecount_part_opt(*cchDisplayName, *cchDisplayName + 1) LPWSTR lpDisplayName,
    __inout  LPDWORD cchDisplayName,
    __out    LPDWORD lpLanguageId
    );

version(UNICODE) {
	alias LookupPrivilegeDisplayNameW LookupPrivilegeDisplayName;
}
else {
	alias LookupPrivilegeDisplayNameA LookupPrivilegeDisplayName;
}

WINADVAPI
BOOL
AllocateLocallyUniqueId(
    __out PLUID Luid
    );

BOOL
BuildCommDCBA(
    __in  LPCSTR lpDef,
    __out LPDCB lpDCB
    );
BOOL
BuildCommDCBW(
    __in  LPCWSTR lpDef,
    __out LPDCB lpDCB
    );

version(UNICODE) {
	alias BuildCommDCBW BuildCommDCB;
}
else {
	alias BuildCommDCBA BuildCommDCB;
}

BOOL
BuildCommDCBAndTimeoutsA(
    __in  LPCSTR lpDef,
    __out LPDCB lpDCB,
    __out LPCOMMTIMEOUTS lpCommTimeouts
    );
BOOL
BuildCommDCBAndTimeoutsW(
    __in  LPCWSTR lpDef,
    __out LPDCB lpDCB,
    __out LPCOMMTIMEOUTS lpCommTimeouts
    );

version(UNICODE) {
	alias BuildCommDCBAndTimeoutsW BuildCommDCBAndTimeouts;
}
else {
	alias BuildCommDCBAndTimeoutsA BuildCommDCBAndTimeouts;
}

BOOL
CommConfigDialogA(
    __in     LPCSTR lpszName,
    __in_opt HWND hWnd,
    __inout  LPCOMMCONFIG lpCC
    );
BOOL
CommConfigDialogW(
    __in     LPCWSTR lpszName,
    __in_opt HWND hWnd,
    __inout  LPCOMMCONFIG lpCC
    );

version(UNICODE) {
	alias CommConfigDialogW CommConfigDialog;
}
else {
	alias CommConfigDialogA CommConfigDialog;
}

BOOL
GetDefaultCommConfigA(
    __in    LPCSTR lpszName,
    __out_bcount_part(*lpdwSize, *lpdwSize) LPCOMMCONFIG lpCC,
    __inout LPDWORD lpdwSize
    );
BOOL
GetDefaultCommConfigW(
    __in    LPCWSTR lpszName,
    __out_bcount_part(*lpdwSize, *lpdwSize) LPCOMMCONFIG lpCC,
    __inout LPDWORD lpdwSize
    );

version(UNICODE) {
	alias GetDefaultCommConfigW GetDefaultCommConfig;
}
else {
	alias GetDefaultCommConfigA GetDefaultCommConfig;
}

BOOL
SetDefaultCommConfigA(
    __in LPCSTR lpszName,
    __in_bcount(dwSize) LPCOMMCONFIG lpCC,
    __in DWORD dwSize
    );
BOOL
SetDefaultCommConfigW(
    __in LPCWSTR lpszName,
    __in_bcount(dwSize) LPCOMMCONFIG lpCC,
    __in DWORD dwSize
    );

version(UNICODE) {
	alias SetDefaultCommConfigW SetDefaultCommConfig;
}
else {
	alias SetDefaultCommConfigA SetDefaultCommConfig;
}

#ifndef _MAC
const auto MAX_COMPUTERNAME_LENGTH  = 15;
#else
const auto MAX_COMPUTERNAME_LENGTH  = 31;
#endif

__success(return != 0)
BOOL
GetComputerNameA (
    __out_ecount_part_opt(*nSize, *nSize + 1) __out_has_type_adt_props(SAL_ValidCompNameT) LPSTR lpBuffer,
    __inout LPDWORD nSize
    );
__success(return != 0)
BOOL
GetComputerNameW (
    __out_ecount_part_opt(*nSize, *nSize + 1) __out_has_type_adt_props(SAL_ValidCompNameT) LPWSTR lpBuffer,
    __inout LPDWORD nSize
    );

version(UNICODE) {
	alias GetComputerNameW GetComputerName;
}
else {
	alias GetComputerNameA GetComputerName;
}

BOOL
SetComputerNameA (
    __in LPCSTR lpComputerName
    );
BOOL
SetComputerNameW (
    __in LPCWSTR lpComputerName
    );

version(UNICODE) {
	alias SetComputerNameW SetComputerName;
}
else {
	alias SetComputerNameA SetComputerName;
}


#if (_WIN32_WINNT >= 0x0500)

typedef enum _COMPUTER_NAME_FORMAT {
    ComputerNameNetBIOS,
    ComputerNameDnsHostname,
    ComputerNameDnsDomain,
    ComputerNameDnsFullyQualified,
    ComputerNamePhysicalNetBIOS,
    ComputerNamePhysicalDnsHostname,
    ComputerNamePhysicalDnsDomain,
    ComputerNamePhysicalDnsFullyQualified,
    ComputerNameMax
} COMPUTER_NAME_FORMAT ;

__success(return != 0)
BOOL
GetComputerNameExA (
    __in    COMPUTER_NAME_FORMAT NameType,
    __out_ecount_part_opt(*nSize, *nSize + 1) LPSTR lpBuffer,
    __inout LPDWORD nSize
    );
__success(return != 0)
BOOL
GetComputerNameExW (
    __in    COMPUTER_NAME_FORMAT NameType,
    __out_ecount_part_opt(*nSize, *nSize + 1) LPWSTR lpBuffer,
    __inout LPDWORD nSize
    );

version(UNICODE) {
	alias GetComputerNameExW GetComputerNameEx;
}
else {
	alias GetComputerNameExA GetComputerNameEx;
}

BOOL
SetComputerNameExA (
    __in COMPUTER_NAME_FORMAT NameType,
    __in LPCSTR lpBuffer
    );
BOOL
SetComputerNameExW (
    __in COMPUTER_NAME_FORMAT NameType,
    __in LPCWSTR lpBuffer
    );

version(UNICODE) {
	alias SetComputerNameExW SetComputerNameEx;
}
else {
	alias SetComputerNameExA SetComputerNameEx;
}


__success(return == TRUE)
BOOL
DnsHostnameToComputerNameA (
    __in    LPCSTR Hostname,
    __out_ecount_part_opt(*nSize, *nSize + 1) __out_has_type_adt_props(SAL_ValidCompNameT) LPSTR ComputerName,
    __inout LPDWORD nSize
    );
__success(return == TRUE)
BOOL
DnsHostnameToComputerNameW (
    __in    LPCWSTR Hostname,
    __out_ecount_part_opt(*nSize, *nSize + 1) __out_has_type_adt_props(SAL_ValidCompNameT) LPWSTR ComputerName,
    __inout LPDWORD nSize
    );

version(UNICODE) {
	alias DnsHostnameToComputerNameW DnsHostnameToComputerName;
}
else {
	alias DnsHostnameToComputerNameA DnsHostnameToComputerName;
}

#endif // _WIN32_WINNT

WINADVAPI
BOOL
GetUserNameA (
    __out_ecount_part_opt(*pcbBuffer, *pcbBuffer) LPSTR lpBuffer,
    __inout LPDWORD pcbBuffer
    );
WINADVAPI
BOOL
GetUserNameW (
    __out_ecount_part_opt(*pcbBuffer, *pcbBuffer) LPWSTR lpBuffer,
    __inout LPDWORD pcbBuffer
    );

version(UNICODE) {
	alias GetUserNameW GetUserName;
}
else {
	alias GetUserNameA GetUserName;
}

//
// Logon Support APIs
//

const auto LOGON32_LOGON_INTERACTIVE        = 2;
const auto LOGON32_LOGON_NETWORK            = 3;
const auto LOGON32_LOGON_BATCH              = 4;
const auto LOGON32_LOGON_SERVICE            = 5;
const auto LOGON32_LOGON_UNLOCK             = 7;
#if(_WIN32_WINNT >= 0x0500)
const auto LOGON32_LOGON_NETWORK_CLEARTEXT  = 8;
const auto LOGON32_LOGON_NEW_CREDENTIALS    = 9;
#endif // (_WIN32_WINNT >= 0x0500)

const auto LOGON32_PROVIDER_DEFAULT     = 0;
const auto LOGON32_PROVIDER_WINNT35     = 1;
#if(_WIN32_WINNT >= 0x0400)
const auto LOGON32_PROVIDER_WINNT40     = 2;
#endif /* _WIN32_WINNT >= 0x0400 */
#if(_WIN32_WINNT >= 0x0500)
const auto LOGON32_PROVIDER_WINNT50     = 3;
#endif // (_WIN32_WINNT >= 0x0500)



WINADVAPI
BOOL
LogonUserA (
    __in        LPCSTR lpszUsername,
    __in_opt    LPCSTR lpszDomain,
    __in        LPCSTR lpszPassword,
    __in        DWORD dwLogonType,
    __in        DWORD dwLogonProvider,
    __deref_out PHANDLE phToken
    );
WINADVAPI
BOOL
LogonUserW (
    __in        LPCWSTR lpszUsername,
    __in_opt    LPCWSTR lpszDomain,
    __in        LPCWSTR lpszPassword,
    __in        DWORD dwLogonType,
    __in        DWORD dwLogonProvider,
    __deref_out PHANDLE phToken
    );

version(UNICODE) {
	alias LogonUserW LogonUser;
}
else {
	alias LogonUserA LogonUser;
}

WINADVAPI
BOOL
LogonUserExA (
    __in            LPCSTR lpszUsername,
    __in_opt        LPCSTR lpszDomain,
    __in            LPCSTR lpszPassword,
    __in            DWORD dwLogonType,
    __in            DWORD dwLogonProvider,
    __deref_opt_out PHANDLE phToken,
    __deref_opt_out PSID  *ppLogonSid,
    __deref_opt_out_bcount_full(*pdwProfileLength) PVOID *ppProfileBuffer,
    __out_opt       LPDWORD pdwProfileLength,
    __out_opt       PQUOTA_LIMITS pQuotaLimits
    );
WINADVAPI
BOOL
LogonUserExW (
    __in            LPCWSTR lpszUsername,
    __in_opt        LPCWSTR lpszDomain,
    __in            LPCWSTR lpszPassword,
    __in            DWORD dwLogonType,
    __in            DWORD dwLogonProvider,
    __deref_opt_out PHANDLE phToken,
    __deref_opt_out PSID  *ppLogonSid,
    __deref_opt_out_bcount_full(*pdwProfileLength) PVOID *ppProfileBuffer,
    __out_opt       LPDWORD pdwProfileLength,
    __out_opt       PQUOTA_LIMITS pQuotaLimits
    );

version(UNICODE) {
	alias LogonUserExW LogonUserEx;
}
else {
	alias LogonUserExA LogonUserEx;
}


#if(_WIN32_WINNT >= 0x0600)


#endif // (_WIN32_WINNT >= 0x0600)

WINADVAPI
BOOL
ImpersonateLoggedOnUser(
    __in HANDLE  hToken
    );

WINADVAPI
BOOL
CreateProcessAsUserA (
    __in_opt    HANDLE hToken,
    __in_opt    LPCSTR lpApplicationName,
    __inout_opt LPSTR lpCommandLine,
    __in_opt    LPSECURITY_ATTRIBUTES lpProcessAttributes,
    __in_opt    LPSECURITY_ATTRIBUTES lpThreadAttributes,
    __in        BOOL bInheritHandles,
    __in        DWORD dwCreationFlags,
    __in_opt    LPVOID lpEnvironment,
    __in_opt    LPCSTR lpCurrentDirectory,
    __in        LPSTARTUPINFOA lpStartupInfo,
    __out       LPPROCESS_INFORMATION lpProcessInformation
    );
WINADVAPI
BOOL
CreateProcessAsUserW (
    __in_opt    HANDLE hToken,
    __in_opt    LPCWSTR lpApplicationName,
    __inout_opt LPWSTR lpCommandLine,
    __in_opt    LPSECURITY_ATTRIBUTES lpProcessAttributes,
    __in_opt    LPSECURITY_ATTRIBUTES lpThreadAttributes,
    __in        BOOL bInheritHandles,
    __in        DWORD dwCreationFlags,
    __in_opt    LPVOID lpEnvironment,
    __in_opt    LPCWSTR lpCurrentDirectory,
    __in        LPSTARTUPINFOW lpStartupInfo,
    __out       LPPROCESS_INFORMATION lpProcessInformation
    );

version(UNICODE) {
	alias CreateProcessAsUserW CreateProcessAsUser;
}
else {
	alias CreateProcessAsUserA CreateProcessAsUser;
}


#if(_WIN32_WINNT >= 0x0500)

//
// LogonFlags
//
const auto LOGON_WITH_PROFILE               = 0x00000001;
const auto LOGON_NETCREDENTIALS_ONLY        = 0x00000002;
const auto LOGON_ZERO_PASSWORD_BUFFER       = 0x80000000;

WINADVAPI
BOOL
CreateProcessWithLogonW(
    __in        LPCWSTR lpUsername,
    __in_opt    LPCWSTR lpDomain,
    __in        LPCWSTR lpPassword,
    __in        DWORD dwLogonFlags,
    __in_opt    LPCWSTR lpApplicationName,
    __inout_opt LPWSTR lpCommandLine,
    __in        DWORD dwCreationFlags,
    __in_opt    LPVOID lpEnvironment,
    __in_opt    LPCWSTR lpCurrentDirectory,
    __in        LPSTARTUPINFOW lpStartupInfo,
    __out       LPPROCESS_INFORMATION lpProcessInformation
      );

WINADVAPI
BOOL
CreateProcessWithTokenW(
    __in        HANDLE hToken,
    __in        DWORD dwLogonFlags,
    __in_opt    LPCWSTR lpApplicationName,
    __inout_opt LPWSTR lpCommandLine,
    __in        DWORD dwCreationFlags,
    __in_opt    LPVOID lpEnvironment,
    __in_opt    LPCWSTR lpCurrentDirectory,
    __in        LPSTARTUPINFOW lpStartupInfo,
    __out       LPPROCESS_INFORMATION lpProcessInformation
      );

#endif // (_WIN32_WINNT >= 0x0500)

WINADVAPI
BOOL
APIENTRY
ImpersonateAnonymousToken(
    __in HANDLE ThreadHandle
    );

WINADVAPI
BOOL
DuplicateTokenEx(
    __in        HANDLE hExistingToken,
    __in        DWORD dwDesiredAccess,
    __in_opt    LPSECURITY_ATTRIBUTES lpTokenAttributes,
    __in        SECURITY_IMPERSONATION_LEVEL ImpersonationLevel,
    __in        TOKEN_TYPE TokenType,
    __deref_out PHANDLE phNewToken);

WINADVAPI
BOOL
APIENTRY
CreateRestrictedToken(
    __in        HANDLE ExistingTokenHandle,
    __in        DWORD Flags,
    __in        DWORD DisableSidCount,
    __in_ecount_opt(DisableSidCount) PSID_AND_ATTRIBUTES SidsToDisable,
    __in        DWORD DeletePrivilegeCount,
    __in_ecount_opt(DeletePrivilegeCount) PLUID_AND_ATTRIBUTES PrivilegesToDelete,
    __in        DWORD RestrictedSidCount,
    __in_ecount_opt(RestrictedSidCount) PSID_AND_ATTRIBUTES SidsToRestrict,
    __deref_out PHANDLE NewTokenHandle
    );


WINADVAPI
BOOL
IsTokenRestricted(
    __in HANDLE TokenHandle
    );

WINADVAPI
BOOL
IsTokenUntrusted(
    __in HANDLE TokenHandle
    );

WINADVAPI
BOOL
APIENTRY
CheckTokenMembership(
    __in_opt HANDLE TokenHandle,
    __in     PSID SidToCheck,
    __out    PBOOL IsMember
    );

//
// Thread pool API's
//

#if (_WIN32_WINNT >= 0x0500)

typedef WAITORTIMERCALLBACKFUNC WAITORTIMERCALLBACK ;

BOOL
RegisterWaitForSingleObject(
    __deref_out PHANDLE phNewWaitObject,
    __in        HANDLE hObject,
    __in        WAITORTIMERCALLBACK Callback,
    __in_opt    PVOID Context,
    __in        ULONG dwMilliseconds,
    __in        ULONG dwFlags
    );

HANDLE
RegisterWaitForSingleObjectEx(
    __in     HANDLE hObject,
    __in     WAITORTIMERCALLBACK Callback,
    __in_opt PVOID Context,
    __in     ULONG dwMilliseconds,
    __in     ULONG dwFlags
    );

__checkReturn
BOOL
UnregisterWait(
    __in HANDLE WaitHandle
    );

__checkReturn
BOOL
UnregisterWaitEx(
    __in     HANDLE WaitHandle,
    __in_opt HANDLE CompletionEvent
    );

BOOL
QueueUserWorkItem(
    __in     LPTHREAD_START_ROUTINE Function,
    __in_opt PVOID Context,
    __in     ULONG Flags
    );

BOOL
BindIoCompletionCallback (
    __in HANDLE FileHandle,
    __in LPOVERLAPPED_COMPLETION_ROUTINE Function,
    __in ULONG Flags
    );

__out_opt
HANDLE
CreateTimerQueue(
    VOID
    );

BOOL
CreateTimerQueueTimer(
    __deref_out PHANDLE phNewTimer,
    __in_opt    HANDLE TimerQueue,
    __in        WAITORTIMERCALLBACK Callback,
    __in_opt    PVOID Parameter,
    __in        DWORD DueTime,
    __in        DWORD Period,
    __in        ULONG Flags
    ) ;

__checkReturn
BOOL
ChangeTimerQueueTimer(
    __in_opt HANDLE TimerQueue,
    __inout  HANDLE Timer,
    __in     ULONG DueTime,
    __in     ULONG Period
    );

__checkReturn
BOOL
DeleteTimerQueueTimer(
    __in_opt HANDLE TimerQueue,
    __in     HANDLE Timer,
    __in_opt HANDLE CompletionEvent
    );

__checkReturn
BOOL
DeleteTimerQueueEx(
    __in     HANDLE TimerQueue,
    __in_opt HANDLE CompletionEvent
    );

HANDLE
SetTimerQueueTimer(
    __in_opt HANDLE TimerQueue,
    __in     WAITORTIMERCALLBACK Callback,
    __in_opt PVOID Parameter,
    __in     DWORD DueTime,
    __in     DWORD Period,
    __in     BOOL PreferIo
    );

__checkReturn
BOOL
CancelTimerQueueTimer(
    __in_opt HANDLE TimerQueue,
    __in     HANDLE Timer
    );

__checkReturn
BOOL
DeleteTimerQueue(
    __in HANDLE TimerQueue
    );

#if (_WIN32_WINNT >= 0x0600)

typedef VOID (WINAPI *PTP_WIN32_IO_CALLBACK)(
    __inout     PTP_CALLBACK_INSTANCE Instance,
    __inout_opt PVOID                 Context,
    __inout_opt PVOID                 Overlapped,
    __in        ULONG                 IoResult,
    __in        ULONG_PTR             NumberOfBytesTransferred,
    __inout     PTP_IO                Io
    );

__checkReturn
__out
PTP_POOL
CreateThreadpool(
    __reserved PVOID reserved
    );

VOID
SetThreadpoolThreadMaximum(
    __inout PTP_POOL ptpp,
    __in    DWORD    cthrdMost
    );

BOOL
SetThreadpoolThreadMinimum(
    __inout PTP_POOL ptpp,
    __in    DWORD    cthrdMic
    );

VOID
CloseThreadpool(
    __inout PTP_POOL ptpp
    );

__checkReturn
__out
PTP_CLEANUP_GROUP
CreateThreadpoolCleanupGroup(
    VOID
    );

VOID
CloseThreadpoolCleanupGroupMembers(
    __inout     PTP_CLEANUP_GROUP ptpcg,
    __in        BOOL              fCancelPendingCallbacks,
    __inout_opt PVOID             pvCleanupContext
    );

VOID
CloseThreadpoolCleanupGroup(
    __inout PTP_CLEANUP_GROUP ptpcg
    );

#if !defined(MIDL_PASS)

FORCEINLINE
VOID
InitializeThreadpoolEnvironment(
    __out PTP_CALLBACK_ENVIRON pcbe
    )
{
    TpInitializeCallbackEnviron(pcbe);
}

FORCEINLINE
VOID
SetThreadpoolCallbackPool(
    __inout PTP_CALLBACK_ENVIRON pcbe,
    __in    PTP_POOL             ptpp
    )
{
    TpSetCallbackThreadpool(pcbe, ptpp);
}

FORCEINLINE
VOID
SetThreadpoolCallbackCleanupGroup(
    __inout  PTP_CALLBACK_ENVIRON              pcbe,
    __in     PTP_CLEANUP_GROUP                 ptpcg,
    __in_opt PTP_CLEANUP_GROUP_CANCEL_CALLBACK pfng
    )
{
    TpSetCallbackCleanupGroup(pcbe, ptpcg, pfng);
}

FORCEINLINE
VOID
SetThreadpoolCallbackRunsLong(
    __inout PTP_CALLBACK_ENVIRON pcbe
    )
{
    TpSetCallbackLongFunction(pcbe);
}

FORCEINLINE
VOID
SetThreadpoolCallbackLibrary(
    __inout PTP_CALLBACK_ENVIRON pcbe,
    __in    PVOID                mod
    )
{
    TpSetCallbackRaceWithDll(pcbe, mod);
}

FORCEINLINE
VOID
DestroyThreadpoolEnvironment(
    __inout PTP_CALLBACK_ENVIRON pcbe
    )
{
    TpDestroyCallbackEnviron(pcbe);
}

#endif // !defined(MIDL_PASS)

VOID
SetEventWhenCallbackReturns(
    __inout PTP_CALLBACK_INSTANCE pci,
    __in    HANDLE                evt
    );

VOID
ReleaseSemaphoreWhenCallbackReturns(
    __inout PTP_CALLBACK_INSTANCE pci,
    __in    HANDLE                sem,
    __in    DWORD                 crel
    );

VOID
ReleaseMutexWhenCallbackReturns(
    __inout PTP_CALLBACK_INSTANCE pci,
    __in    HANDLE                mut
    );

VOID
LeaveCriticalSectionWhenCallbackReturns(
    __inout PTP_CALLBACK_INSTANCE pci,
    __inout PCRITICAL_SECTION     pcs
    );

VOID
FreeLibraryWhenCallbackReturns(
    __inout PTP_CALLBACK_INSTANCE pci,
    __in    HMODULE               mod
    );

BOOL
CallbackMayRunLong(
    __inout PTP_CALLBACK_INSTANCE pci
    );

VOID
DisassociateCurrentThreadFromCallback(
    __inout PTP_CALLBACK_INSTANCE pci
    );

__checkReturn
BOOL
TrySubmitThreadpoolCallback(
    __in        PTP_SIMPLE_CALLBACK  pfns,
    __inout_opt PVOID                pv,
    __in_opt    PTP_CALLBACK_ENVIRON pcbe
    );

__checkReturn
__out
PTP_WORK
CreateThreadpoolWork(
    __in        PTP_WORK_CALLBACK    pfnwk,
    __inout_opt PVOID                pv,
    __in_opt    PTP_CALLBACK_ENVIRON pcbe
    );

VOID
SubmitThreadpoolWork(
    __inout PTP_WORK pwk
    );

VOID
WaitForThreadpoolWorkCallbacks(
    __inout PTP_WORK pwk,
    __in    BOOL     fCancelPendingCallbacks
    );

VOID
CloseThreadpoolWork(
    __inout PTP_WORK pwk
    );

__checkReturn
__out
PTP_TIMER
CreateThreadpoolTimer(
    __in        PTP_TIMER_CALLBACK   pfnti,
    __inout_opt PVOID                pv,
    __in_opt    PTP_CALLBACK_ENVIRON pcbe
    );

VOID
SetThreadpoolTimer(
    __inout  PTP_TIMER pti,
    __in_opt PFILETIME pftDueTime,
    __in     DWORD     msPeriod,
    __in_opt DWORD     msWindowLength
    );

BOOL
IsThreadpoolTimerSet(
    __inout PTP_TIMER pti
    );

VOID
WaitForThreadpoolTimerCallbacks(
    __inout PTP_TIMER pti,
    __in    BOOL      fCancelPendingCallbacks
    );

VOID
CloseThreadpoolTimer(
    __inout PTP_TIMER pti
    );

__checkReturn
__out
PTP_WAIT
CreateThreadpoolWait(
    __in        PTP_WAIT_CALLBACK    pfnwa,
    __inout_opt PVOID                pv,
    __in_opt    PTP_CALLBACK_ENVIRON pcbe
    );

VOID
SetThreadpoolWait(
    __inout  PTP_WAIT  pwa,
    __in_opt HANDLE    h,
    __in_opt PFILETIME pftTimeout
    );

VOID
WaitForThreadpoolWaitCallbacks(
    __inout PTP_WAIT pwa,
    __in    BOOL     fCancelPendingCallbacks
    );

VOID
CloseThreadpoolWait(
    __inout PTP_WAIT pwa
    );

__checkReturn
__out
PTP_IO
CreateThreadpoolIo(
    __in        HANDLE                fl,
    __in        PTP_WIN32_IO_CALLBACK pfnio,
    __inout_opt PVOID                 pv,
    __in_opt    PTP_CALLBACK_ENVIRON  pcbe
    );

VOID
StartThreadpoolIo(
    __inout PTP_IO pio
    );

VOID
CancelThreadpoolIo(
    __inout PTP_IO pio
    );

VOID
WaitForThreadpoolIoCallbacks(
    __inout PTP_IO pio,
    __in    BOOL   fCancelPendingCallbacks
    );

VOID
CloseThreadpoolIo(
    __inout PTP_IO pio
    );

//
//  Private Namespaces support
//

__out_opt
HANDLE
CreatePrivateNamespaceA(
    __in_opt LPSECURITY_ATTRIBUTES lpPrivateNamespaceAttributes,
    __in     LPVOID lpBoundaryDescriptor,
    __in     LPCSTR lpAliasPrefix
    );
__out_opt
HANDLE
CreatePrivateNamespaceW(
    __in_opt LPSECURITY_ATTRIBUTES lpPrivateNamespaceAttributes,
    __in     LPVOID lpBoundaryDescriptor,
    __in     LPCWSTR lpAliasPrefix
    );

version(UNICODE) {
	alias CreatePrivateNamespaceW CreatePrivateNamespace;
}
else {
	alias CreatePrivateNamespaceA CreatePrivateNamespace;
}

__out_opt
HANDLE
OpenPrivateNamespaceA(
    __in     LPVOID lpBoundaryDescriptor,
    __in     LPCSTR lpAliasPrefix
    );
__out_opt
HANDLE
OpenPrivateNamespaceW(
    __in     LPVOID lpBoundaryDescriptor,
    __in     LPCWSTR lpAliasPrefix
    );

version(UNICODE) {
	alias OpenPrivateNamespaceW OpenPrivateNamespace;
}
else {
	alias OpenPrivateNamespaceA OpenPrivateNamespace;
}


const auto PRIVATE_NAMESPACE_FLAG_DESTROY       = 0x00000001;

BOOLEAN
ClosePrivateNamespace(
    __in HANDLE Handle,
    __in ULONG Flags
    );


//
//  Boundary descriptors support
//

__out_opt
HANDLE
APIENTRY
CreateBoundaryDescriptorA(
    __in LPCSTR Name,
    __in ULONG Flags
    );
__out_opt
HANDLE
APIENTRY
CreateBoundaryDescriptorW(
    __in LPCWSTR Name,
    __in ULONG Flags
    );

version(UNICODE) {
	alias CreateBoundaryDescriptorW CreateBoundaryDescriptor;
}
else {
	alias CreateBoundaryDescriptorA CreateBoundaryDescriptor;
}

BOOL
AddSIDToBoundaryDescriptor(
    __inout HANDLE * BoundaryDescriptor,
    __in PSID RequiredSid
    );


VOID
DeleteBoundaryDescriptor(
    __in HANDLE BoundaryDescriptor
    );


#endif // _WIN32_WINNT >= 0x0600

#endif // _WIN32_WINNT >= 0x0500


#if(_WIN32_WINNT >= 0x0400)
//
// Plug-and-Play API's
//

const auto HW_PROFILE_GUIDLEN          = 39      ; // 36-characters plus NULL terminator
const auto MAX_PROFILE_LEN             = 80;

const auto DOCKINFO_UNDOCKED           = (0x1);
const auto DOCKINFO_DOCKED             = (0x2);
const auto DOCKINFO_USER_SUPPLIED      = (0x4);
const auto DOCKINFO_USER_UNDOCKED      = (DOCKINFO_USER_SUPPLIED | DOCKINFO_UNDOCKED);
const auto DOCKINFO_USER_DOCKED        = (DOCKINFO_USER_SUPPLIED | DOCKINFO_DOCKED);

struct HW_PROFILE_INFOA {
    DWORD  dwDockInfo;
    CHAR   szHwProfileGuid[HW_PROFILE_GUIDLEN];
    CHAR   szHwProfileName[MAX_PROFILE_LEN];
}

typedef HW_PROFILE_INFOA* LPHW_PROFILE_INFOA;
struct HW_PROFILE_INFOW {
    DWORD  dwDockInfo;
    WCHAR  szHwProfileGuid[HW_PROFILE_GUIDLEN];
    WCHAR  szHwProfileName[MAX_PROFILE_LEN];
}

typedef HW_PROFILE_INFOW* LPHW_PROFILE_INFOW;

version(UNICODE) {
	typedef HW_PROFILE_INFOW HW_PROFILE_INFO;
	typedef LPHW_PROFILE_INFOW LPHW_PROFILE_INFO;
}
else {
	typedef HW_PROFILE_INFOA HW_PROFILE_INFO;
	typedef LPHW_PROFILE_INFOA LPHW_PROFILE_INFO;
}


WINADVAPI
BOOL
GetCurrentHwProfileA (
    __out LPHW_PROFILE_INFOA  lpHwProfileInfo
    );
WINADVAPI
BOOL
GetCurrentHwProfileW (
    __out LPHW_PROFILE_INFOW  lpHwProfileInfo
    );

version(UNICODE) {
	alias GetCurrentHwProfileW GetCurrentHwProfile;
}
else {
	alias GetCurrentHwProfileA GetCurrentHwProfile;
}
#endif /* _WIN32_WINNT >= 0x0400 */

//
// Performance counter API's
//

BOOL
QueryPerformanceCounter(
    __out LARGE_INTEGER *lpPerformanceCount
    );

BOOL
QueryPerformanceFrequency(
    __out LARGE_INTEGER *lpFrequency
    );



BOOL
GetVersionExA(
    __inout LPOSVERSIONINFOA lpVersionInformation
    );
BOOL
GetVersionExW(
    __inout LPOSVERSIONINFOW lpVersionInformation
    );

version(UNICODE) {
	alias GetVersionExW GetVersionEx;
}
else {
	alias GetVersionExA GetVersionEx;
}



BOOL
VerifyVersionInfoA(
    __inout LPOSVERSIONINFOEXA lpVersionInformation,
    __in    DWORD dwTypeMask,
    __in    DWORDLONG dwlConditionMask
    );
BOOL
VerifyVersionInfoW(
    __inout LPOSVERSIONINFOEXW lpVersionInformation,
    __in    DWORD dwTypeMask,
    __in    DWORDLONG dwlConditionMask
    );

version(UNICODE) {
	alias VerifyVersionInfoW VerifyVersionInfo;
}
else {
	alias VerifyVersionInfoA VerifyVersionInfo;
}

#if (_WIN32_WINNT >= 0x0600)

BOOL
GetProductInfo(
    __in  DWORD  dwOSMajorVersion,
    __in  DWORD  dwOSMinorVersion,
    __in  DWORD  dwSpMajorVersion,
    __in  DWORD  dwSpMinorVersion,
    __out PDWORD pdwReturnedProductType
    );

#endif

// DOS and OS/2 Compatible Error Code definitions returned by the Win32 Base
// API functions.
//

#include <winerror.h>

/* Abnormal termination codes */

const auto TC_NORMAL        = 0;
const auto TC_HARDERR       = 1;
const auto TC_GP_TRAP       = 2;
const auto TC_SIGNAL        = 3;

#if(WINVER >= 0x0400)
//
// Power Management APIs
//

const auto AC_LINE_OFFLINE                  = 0x00;
const auto AC_LINE_ONLINE                   = 0x01;
const auto AC_LINE_BACKUP_POWER             = 0x02;
const auto AC_LINE_UNKNOWN                  = 0xFF;

const auto BATTERY_FLAG_HIGH                = 0x01;
const auto BATTERY_FLAG_LOW                 = 0x02;
const auto BATTERY_FLAG_CRITICAL            = 0x04;
const auto BATTERY_FLAG_CHARGING            = 0x08;
const auto BATTERY_FLAG_NO_BATTERY          = 0x80;
const auto BATTERY_FLAG_UNKNOWN             = 0xFF;

const auto BATTERY_PERCENTAGE_UNKNOWN       = 0xFF;

const auto BATTERY_LIFE_UNKNOWN         = 0xFFFFFFFF;

struct SYSTEM_POWER_STATUS {
    BYTE ACLineStatus;
    BYTE BatteryFlag;
    BYTE BatteryLifePercent;
    BYTE Reserved1;
    DWORD BatteryLifeTime;
    DWORD BatteryFullLifeTime;
}

typedef SYSTEM_POWER_STATUS* LPSYSTEM_POWER_STATUS;

BOOL
GetSystemPowerStatus(
    __out LPSYSTEM_POWER_STATUS lpSystemPowerStatus
    );

BOOL
SetSystemPowerState(
    __in BOOL fSuspend,
    __in BOOL fForce
    );

#endif /* WINVER >= 0x0400 */

#if (_WIN32_WINNT >= 0x0500)
//
// Very Large Memory API Subset
//

BOOL
AllocateUserPhysicalPages(
    __in    HANDLE hProcess,
    __inout PULONG_PTR NumberOfPages,
    __out_ecount_part(*NumberOfPages, *NumberOfPages) PULONG_PTR PageArray
    );

#if _WIN32_WINNT >= 0x0600

BOOL
AllocateUserPhysicalPagesNuma(
    __in    HANDLE hProcess,
    __inout PULONG_PTR NumberOfPages,
    __out_ecount_part(*NumberOfPages, *NumberOfPages) PULONG_PTR PageArray,
    __in    DWORD nndPreferred
    );

#endif // _WIN32_WINNT >= 0x0600

BOOL
FreeUserPhysicalPages(
    __in    HANDLE hProcess,
    __inout PULONG_PTR NumberOfPages,
    __in_ecount(*NumberOfPages) PULONG_PTR PageArray
    );

BOOL
MapUserPhysicalPages(
    __in PVOID VirtualAddress,
    __in ULONG_PTR NumberOfPages,
    __in_ecount_opt(NumberOfPages) PULONG_PTR PageArray
    );

BOOL
MapUserPhysicalPagesScatter(
    __in_ecount(NumberOfPages) PVOID *VirtualAddresses,
    __in ULONG_PTR NumberOfPages,
    __in_ecount_opt(NumberOfPages) PULONG_PTR PageArray
    );

__out_opt
HANDLE
CreateJobObjectA(
    __in_opt LPSECURITY_ATTRIBUTES lpJobAttributes,
    __in_opt LPCSTR lpName
    );
__out_opt
HANDLE
CreateJobObjectW(
    __in_opt LPSECURITY_ATTRIBUTES lpJobAttributes,
    __in_opt LPCWSTR lpName
    );

version(UNICODE) {
	alias CreateJobObjectW CreateJobObject;
}
else {
	alias CreateJobObjectA CreateJobObject;
}

__out_opt
HANDLE
OpenJobObjectA(
    __in DWORD dwDesiredAccess,
    __in BOOL bInheritHandle,
    __in LPCSTR lpName
    );
__out_opt
HANDLE
OpenJobObjectW(
    __in DWORD dwDesiredAccess,
    __in BOOL bInheritHandle,
    __in LPCWSTR lpName
    );

version(UNICODE) {
	alias OpenJobObjectW OpenJobObject;
}
else {
	alias OpenJobObjectA OpenJobObject;
}

BOOL
AssignProcessToJobObject(
    __in HANDLE hJob,
    __in HANDLE hProcess
    );

BOOL
TerminateJobObject(
    __in HANDLE hJob,
    __in UINT uExitCode
    );

BOOL
QueryInformationJobObject(
    __in_opt  HANDLE hJob,
    __in      JOBOBJECTINFOCLASS JobObjectInformationClass,
    __out_bcount_part(cbJobObjectInformationLength, *lpReturnLength) LPVOID lpJobObjectInformation,
    __in      DWORD cbJobObjectInformationLength,
    __out_opt LPDWORD lpReturnLength
    );

BOOL
SetInformationJobObject(
    __in HANDLE hJob,
    __in JOBOBJECTINFOCLASS JobObjectInformationClass,
    __in_bcount(cbJobObjectInformationLength) LPVOID lpJobObjectInformation,
    __in DWORD cbJobObjectInformationLength
    );

#if (_WIN32_WINNT >= 0x0501)

BOOL
IsProcessInJob (
    __in     HANDLE ProcessHandle,
    __in_opt HANDLE JobHandle,
    __out    PBOOL Result
    );

#endif

BOOL
CreateJobSet (
    __in ULONG NumJob,
    __in_ecount(NumJob) PJOB_SET_ARRAY UserJobSet,
    __in ULONG Flags);

__out_opt
PVOID
AddVectoredExceptionHandler (
    __in ULONG First,
    __in PVECTORED_EXCEPTION_HANDLER Handler
    );

ULONG
RemoveVectoredExceptionHandler (
    __in PVOID Handle
    );

__out_opt
PVOID
AddVectoredContinueHandler (
    __in ULONG First,
    __in PVECTORED_EXCEPTION_HANDLER Handler
    );

ULONG
RemoveVectoredContinueHandler (
    __in PVOID Handle
    );

//
// New Volume Mount Point API.
//

__out
HANDLE
FindFirstVolumeA(
    __out_ecount(cchBufferLength) LPSTR lpszVolumeName,
    __in DWORD cchBufferLength
    );
__out
HANDLE
FindFirstVolumeW(
    __out_ecount(cchBufferLength) LPWSTR lpszVolumeName,
    __in DWORD cchBufferLength
    );

version(UNICODE) {
	alias FindFirstVolumeW FindFirstVolume;
}
else {
	alias FindFirstVolumeA FindFirstVolume;
}

BOOL
FindNextVolumeA(
    __inout HANDLE hFindVolume,
    __out_ecount(cchBufferLength) LPSTR lpszVolumeName,
    __in    DWORD cchBufferLength
    );
BOOL
FindNextVolumeW(
    __inout HANDLE hFindVolume,
    __out_ecount(cchBufferLength) LPWSTR lpszVolumeName,
    __in    DWORD cchBufferLength
    );

version(UNICODE) {
	alias FindNextVolumeW FindNextVolume;
}
else {
	alias FindNextVolumeA FindNextVolume;
}

BOOL
FindVolumeClose(
    __in HANDLE hFindVolume
    );

__out
HANDLE
FindFirstVolumeMountPointA(
    __in LPCSTR lpszRootPathName,
    __out_ecount(cchBufferLength) LPSTR lpszVolumeMountPoint,
    __in DWORD cchBufferLength
    );
__out
HANDLE
FindFirstVolumeMountPointW(
    __in LPCWSTR lpszRootPathName,
    __out_ecount(cchBufferLength) LPWSTR lpszVolumeMountPoint,
    __in DWORD cchBufferLength
    );

version(UNICODE) {
	alias FindFirstVolumeMountPointW FindFirstVolumeMountPoint;
}
else {
	alias FindFirstVolumeMountPointA FindFirstVolumeMountPoint;
}

BOOL
FindNextVolumeMountPointA(
    __in HANDLE hFindVolumeMountPoint,
    __out_ecount(cchBufferLength) LPSTR lpszVolumeMountPoint,
    __in DWORD cchBufferLength
    );
BOOL
FindNextVolumeMountPointW(
    __in HANDLE hFindVolumeMountPoint,
    __out_ecount(cchBufferLength) LPWSTR lpszVolumeMountPoint,
    __in DWORD cchBufferLength
    );

version(UNICODE) {
	alias FindNextVolumeMountPointW FindNextVolumeMountPoint;
}
else {
	alias FindNextVolumeMountPointA FindNextVolumeMountPoint;
}

BOOL
FindVolumeMountPointClose(
    __in HANDLE hFindVolumeMountPoint
    );

BOOL
SetVolumeMountPointA(
    __in LPCSTR lpszVolumeMountPoint,
    __in LPCSTR lpszVolumeName
    );
BOOL
SetVolumeMountPointW(
    __in LPCWSTR lpszVolumeMountPoint,
    __in LPCWSTR lpszVolumeName
    );

version(UNICODE) {
	alias SetVolumeMountPointW SetVolumeMountPoint;
}
else {
	alias SetVolumeMountPointA SetVolumeMountPoint;
}

BOOL
DeleteVolumeMountPointA(
    __in LPCSTR lpszVolumeMountPoint
    );
BOOL
DeleteVolumeMountPointW(
    __in LPCWSTR lpszVolumeMountPoint
    );

version(UNICODE) {
	alias DeleteVolumeMountPointW DeleteVolumeMountPoint;
}
else {
	alias DeleteVolumeMountPointA DeleteVolumeMountPoint;
}

BOOL
GetVolumeNameForVolumeMountPointA(
    __in LPCSTR lpszVolumeMountPoint,
    __out_ecount(cchBufferLength) LPSTR lpszVolumeName,
    __in DWORD cchBufferLength
    );
BOOL
GetVolumeNameForVolumeMountPointW(
    __in LPCWSTR lpszVolumeMountPoint,
    __out_ecount(cchBufferLength) LPWSTR lpszVolumeName,
    __in DWORD cchBufferLength
    );

version(UNICODE) {
	alias GetVolumeNameForVolumeMountPointW GetVolumeNameForVolumeMountPoint;
}
else {
	alias GetVolumeNameForVolumeMountPointA GetVolumeNameForVolumeMountPoint;
}

BOOL
GetVolumePathNameA(
    __in LPCSTR lpszFileName,
    __out_ecount(cchBufferLength) LPSTR lpszVolumePathName,
    __in DWORD cchBufferLength
    );
BOOL
GetVolumePathNameW(
    __in LPCWSTR lpszFileName,
    __out_ecount(cchBufferLength) LPWSTR lpszVolumePathName,
    __in DWORD cchBufferLength
    );

version(UNICODE) {
	alias GetVolumePathNameW GetVolumePathName;
}
else {
	alias GetVolumePathNameA GetVolumePathName;
}

BOOL
GetVolumePathNamesForVolumeNameA(
    __in  LPCSTR lpszVolumeName,
    __out_ecount_part_opt(cchBufferLength, *lpcchReturnLength) __nullnullterminated LPCH lpszVolumePathNames,
    __in  DWORD cchBufferLength,
    __out PDWORD lpcchReturnLength
    );
BOOL
GetVolumePathNamesForVolumeNameW(
    __in  LPCWSTR lpszVolumeName,
    __out_ecount_part_opt(cchBufferLength, *lpcchReturnLength) __nullnullterminated LPWCH lpszVolumePathNames,
    __in  DWORD cchBufferLength,
    __out PDWORD lpcchReturnLength
    );

version(UNICODE) {
	alias GetVolumePathNamesForVolumeNameW GetVolumePathNamesForVolumeName;
}
else {
	alias GetVolumePathNamesForVolumeNameA GetVolumePathNamesForVolumeName;
}

#endif

#if (_WIN32_WINNT >= 0x0500) || (_WIN32_FUSION >= 0x0100) || ISOLATION_AWARE_ENABLED

const auto ACTCTX_FLAG_PROCESSOR_ARCHITECTURE_VALID     = (0x00000001);
const auto ACTCTX_FLAG_LANGID_VALID                     = (0x00000002);
const auto ACTCTX_FLAG_ASSEMBLY_DIRECTORY_VALID         = (0x00000004);
const auto ACTCTX_FLAG_RESOURCE_NAME_VALID              = (0x00000008);
const auto ACTCTX_FLAG_SET_PROCESS_DEFAULT              = (0x00000010);
const auto ACTCTX_FLAG_APPLICATION_NAME_VALID           = (0x00000020);
const auto ACTCTX_FLAG_SOURCE_IS_ASSEMBLYREF            = (0x00000040);
const auto ACTCTX_FLAG_HMODULE_VALID                    = (0x00000080);

struct ACTCTXA {
    ULONG       cbSize;
    DWORD       dwFlags;
    LPCSTR      lpSource;
    USHORT      wProcessorArchitecture;
    LANGID      wLangId;
    LPCSTR      lpAssemblyDirectory;
    LPCSTR      lpResourceName;
    LPCSTR      lpApplicationName;
    HMODULE     hModule;
}

typedef ACTCTXA* PACTCTXA;
struct ACTCTXW {
    ULONG       cbSize;
    DWORD       dwFlags;
    LPCWSTR     lpSource;
    USHORT      wProcessorArchitecture;
    LANGID      wLangId;
    LPCWSTR     lpAssemblyDirectory;
    LPCWSTR     lpResourceName;
    LPCWSTR     lpApplicationName;
    HMODULE     hModule;
}

typedef ACTCTXW* PACTCTXW;

version(UNICODE) {
	typedef ACTCTXW ACTCTX;
	typedef PACTCTXW PACTCTX;
}
else {
	typedef ACTCTXA ACTCTX;
	typedef PACTCTXA PACTCTX;
}

typedef const ACTCTXA *PCACTCTXA;
typedef const ACTCTXW *PCACTCTXW;

version(UNICODE) {
	typedef PCACTCTXW PCACTCTX;
}
else {
	typedef PCACTCTXA PCACTCTX;
}



__out
HANDLE
CreateActCtxA(
    __in PCACTCTXA pActCtx
    );
__out
HANDLE
CreateActCtxW(
    __in PCACTCTXW pActCtx
    );

version(UNICODE) {
	alias CreateActCtxW CreateActCtx;
}
else {
	alias CreateActCtxA CreateActCtx;
}

VOID
AddRefActCtx(
    __inout HANDLE hActCtx
    );


VOID
ReleaseActCtx(
    __inout HANDLE hActCtx
    );

BOOL
ZombifyActCtx(
    __inout HANDLE hActCtx
    );


BOOL
ActivateActCtx(
    __inout_opt HANDLE hActCtx,
    __out   ULONG_PTR *lpCookie
    );


const auto DEACTIVATE_ACTCTX_FLAG_FORCE_EARLY_DEACTIVATION  = (0x00000001);

BOOL
DeactivateActCtx(
    __in DWORD dwFlags,
    __in ULONG_PTR ulCookie
    );

BOOL
GetCurrentActCtx(
    __deref_out HANDLE *lphActCtx);


struct ACTCTX_SECTION_KEYED_DATA_2600 {
    ULONG cbSize;
    ULONG ulDataFormatVersion;
    PVOID lpData;
    ULONG ulLength;
    PVOID lpSectionGlobalData;
    ULONG ulSectionGlobalDataLength;
    PVOID lpSectionBase;
    ULONG ulSectionTotalLength;
    HANDLE hActCtx;
    ULONG ulAssemblyRosterIndex;
}

typedef ACTCTX_SECTION_KEYED_DATA_2600* PACTCTX_SECTION_KEYED_DATA_2600;
typedef const ACTCTX_SECTION_KEYED_DATA_2600 * PCACTCTX_SECTION_KEYED_DATA_2600;

struct ACTCTX_SECTION_KEYED_DATA_ASSEMBLY_METADATA {
    PVOID lpInformation;
    PVOID lpSectionBase;
    ULONG ulSectionLength;
    PVOID lpSectionGlobalDataBase;
    ULONG ulSectionGlobalDataLength;
}

typedef ACTCTX_SECTION_KEYED_DATA_ASSEMBLY_METADATA* PACTCTX_SECTION_KEYED_DATA_ASSEMBLY_METADATA;
typedef const ACTCTX_SECTION_KEYED_DATA_ASSEMBLY_METADATA *PCACTCTX_SECTION_KEYED_DATA_ASSEMBLY_METADATA;

struct ACTCTX_SECTION_KEYED_DATA {
    ULONG cbSize;
    ULONG ulDataFormatVersion;
    PVOID lpData;
    ULONG ulLength;
    PVOID lpSectionGlobalData;
    ULONG ulSectionGlobalDataLength;
    PVOID lpSectionBase;
    ULONG ulSectionTotalLength;
    HANDLE hActCtx;
    ULONG ulAssemblyRosterIndex;
// 2600 stops here
    ULONG ulFlags;
    ACTCTX_SECTION_KEYED_DATA_ASSEMBLY_METADATA AssemblyMetadata;
}

typedef ACTCTX_SECTION_KEYED_DATA* PACTCTX_SECTION_KEYED_DATA;
typedef const ACTCTX_SECTION_KEYED_DATA * PCACTCTX_SECTION_KEYED_DATA;

const auto FIND_ACTCTX_SECTION_KEY_RETURN_HACTCTX  = (0x00000001);
const auto FIND_ACTCTX_SECTION_KEY_RETURN_FLAGS    = (0x00000002);
const auto FIND_ACTCTX_SECTION_KEY_RETURN_ASSEMBLY_METADATA  = (0x00000004);



BOOL
FindActCtxSectionStringA(
    __in       DWORD dwFlags,
    __reserved const GUID *lpExtensionGuid,
    __in       ULONG ulSectionId,
    __in       LPCSTR lpStringToFind,
    __out      PACTCTX_SECTION_KEYED_DATA ReturnedData
    );
BOOL
FindActCtxSectionStringW(
    __in       DWORD dwFlags,
    __reserved const GUID *lpExtensionGuid,
    __in       ULONG ulSectionId,
    __in       LPCWSTR lpStringToFind,
    __out      PACTCTX_SECTION_KEYED_DATA ReturnedData
    );

version(UNICODE) {
	alias FindActCtxSectionStringW FindActCtxSectionString;
}
else {
	alias FindActCtxSectionStringA FindActCtxSectionString;
}

BOOL
FindActCtxSectionGuid(
    __in       DWORD dwFlags,
    __reserved const GUID *lpExtensionGuid,
    __in       ULONG ulSectionId,
    __in_opt   const GUID *lpGuidToFind,
    __out      PACTCTX_SECTION_KEYED_DATA ReturnedData
    );


#if !defined(RC_INVOKED) /* RC complains about long symbols in #ifs */
#if !defined(ACTIVATION_CONTEXT_BASIC_INFORMATION_DEFINED)

struct ACTIVATION_CONTEXT_BASIC_INFORMATION {
    HANDLE  hActCtx;
    DWORD   dwFlags;
}

typedef ACTIVATION_CONTEXT_BASIC_INFORMATION* PACTIVATION_CONTEXT_BASIC_INFORMATION;

typedef const struct _ACTIVATION_CONTEXT_BASIC_INFORMATION *PCACTIVATION_CONTEXT_BASIC_INFORMATION;

const auto ACTIVATION_CONTEXT_BASIC_INFORMATION_DEFINED  = 1;

#endif // !defined(ACTIVATION_CONTEXT_BASIC_INFORMATION_DEFINED)
#endif

const auto QUERY_ACTCTX_FLAG_USE_ACTIVE_ACTCTX  = (0x00000004);
const auto QUERY_ACTCTX_FLAG_ACTCTX_IS_HMODULE  = (0x00000008);
const auto QUERY_ACTCTX_FLAG_ACTCTX_IS_ADDRESS  = (0x00000010);
const auto QUERY_ACTCTX_FLAG_NO_ADDREF          = (0x80000000);



//
// switch (ulInfoClass)
//
//  case ActivationContextBasicInformation:
//    pvSubInstance == NULL
//    pvBuffer is of type PACTIVATION_CONTEXT_BASIC_INFORMATION
//
//  case ActivationContextDetailedInformation:
//    pvSubInstance == NULL
//    pvBuffer is of type PACTIVATION_CONTEXT_DETAILED_INFORMATION
//
//  case AssemblyDetailedInformationInActivationContext:
//    pvSubInstance is of type PULONG
//      *pvSubInstance < ACTIVATION_CONTEXT_DETAILED_INFORMATION::ulAssemblyCount
//    pvBuffer is of type PACTIVATION_CONTEXT_ASSEMBLY_DETAILED_INFORMATION
//
//  case FileInformationInAssemblyOfAssemblyInActivationContext:
//    pvSubInstance is of type PACTIVATION_CONTEXT_QUERY_INDEX
//      pvSubInstance->ulAssemblyIndex < ACTIVATION_CONTEXT_DETAILED_INFORMATION::ulAssemblyCount
//      pvSubInstance->ulFileIndexInAssembly < ACTIVATION_CONTEXT_ASSEMBLY_DETAILED_INFORMATION::ulFileCount
//    pvBuffer is of type PASSEMBLY_FILE_DETAILED_INFORMATION
//
//  case RunlevelInformationInActivationContext :
//    pvSubInstance == NULL
//    pvBuffer is of type PACTIVATION_CONTEXT_RUN_LEVEL_INFORMATION
//
// String are placed after the structs.
//
BOOL
QueryActCtxW(
    __in      DWORD dwFlags,
    __in      HANDLE hActCtx,
    __in_opt  PVOID pvSubInstance,
    __in      ULONG ulInfoClass,
    __out_bcount_part_opt(cbBuffer, *pcbWrittenOrRequired) PVOID pvBuffer,
    __in      SIZE_T cbBuffer,
    __out_opt SIZE_T *pcbWrittenOrRequired
    );

typedef BOOL (WINAPI * PQUERYACTCTXW_FUNC)(
    __in      DWORD dwFlags,
    __in      HANDLE hActCtx,
    __in_opt  PVOID pvSubInstance,
    __in      ULONG ulInfoClass,
    __out_bcount_part_opt(cbBuffer, *pcbWrittenOrRequired) PVOID pvBuffer,
    __in      SIZE_T cbBuffer,
    __out_opt SIZE_T *pcbWrittenOrRequired
    );

#endif // (_WIN32_WINNT > 0x0500) || (_WIN32_FUSION >= 0x0100) || ISOLATION_AWARE_ENABLED


BOOL
ProcessIdToSessionId(
    __in  DWORD dwProcessId,
    __out DWORD *pSessionId
    );

#if _WIN32_WINNT >= 0x0501

DWORD
WTSGetActiveConsoleSessionId(
    VOID
    );

BOOL
IsWow64Process(
    __in  HANDLE hProcess,
    __out PBOOL Wow64Process
    );

#endif // (_WIN32_WINNT >= 0x0501)

BOOL
GetLogicalProcessorInformation(
    __out_bcount_part(*ReturnedLength, *ReturnedLength) PSYSTEM_LOGICAL_PROCESSOR_INFORMATION Buffer,
    __inout PDWORD ReturnedLength
    );

//
// NUMA Information routines.
//

BOOL
GetNumaHighestNodeNumber(
    __out PULONG HighestNodeNumber
    );

BOOL
GetNumaProcessorNode(
    __in  UCHAR Processor,
    __out PUCHAR NodeNumber
    );

BOOL
GetNumaNodeProcessorMask(
    __in  UCHAR Node,
    __out PULONGLONG ProcessorMask
    );

BOOL
GetNumaAvailableMemoryNode(
    __in  UCHAR Node,
    __out PULONGLONG AvailableBytes
    );

#if (_WIN32_WINNT >= 0x0600)

BOOL
GetNumaProximityNode(
    __in  ULONG ProximityId,
    __out PUCHAR NodeNumber
    );

#endif

//
// Application restart and data recovery callback
//
typedef DWORD (WINAPI *APPLICATION_RECOVERY_CALLBACK)(PVOID pvParameter);

//
// Max length of commandline in characters (including the NULL character that can be registered for restart)
//
const auto RESTART_MAX_CMD_LINE     = 2048;


//
// Do not restart the process for termination due to application crashes
//
const auto RESTART_NO_CRASH         = 1;

//
// Do not restart the process for termination due to application hangs
//
const auto RESTART_NO_HANG          = 2;

//
// Do not restart the process for termination due to patch installations
//
const auto RESTART_NO_PATCH         = 4;

//
// Do not restart the process when the system is rebooted because the
//
const auto RESTART_NO_REBOOT         = 8;

HRESULT
RegisterApplicationRecoveryCallback(
    __in  APPLICATION_RECOVERY_CALLBACK pRecoveyCallback,
    __in_opt  PVOID pvParameter,
    __in DWORD dwPingInterval,
    __in DWORD dwFlags
    );

HRESULT
UnregisterApplicationRecoveryCallback();

HRESULT
RegisterApplicationRestart(
    __in_opt PCWSTR pwzCommandline,
    __in DWORD dwFlags
    );

HRESULT
UnregisterApplicationRestart();


const auto RECOVERY_DEFAULT_PING_INTERVAL   = 5000;
const auto RECOVERY_MAX_PING_INTERVAL       = (5 * 60 * 1000);

HRESULT
GetApplicationRecoveryCallback(
    __in  HANDLE hProcess,
    __out APPLICATION_RECOVERY_CALLBACK* pRecoveryCallback,
    __deref_opt_out_opt PVOID* ppvParameter,
    __out_opt PDWORD pdwPingInterval,
    __out_opt PDWORD pdwFlags
    );

HRESULT
GetApplicationRestartSettings(
    __in HANDLE hProcess,
    __out_ecount_opt(*pcchSize) PWSTR pwzCommandline,
    __inout PDWORD pcchSize,
    __out_opt PDWORD pdwFlags
    );

HRESULT
ApplicationRecoveryInProgress(
    __out PBOOL pbCancelled
    );

VOID
ApplicationRecoveryFinished(
    __in BOOL bSuccess
    );

#if (_WIN32_WINNT >= 0x0600)
typedef enum _FILE_INFO_BY_HANDLE_CLASS {
    FileBasicInfo,
    FileStandardInfo,
    FileNameInfo,
    FileRenameInfo,
    FileDispositionInfo,
    FileAllocationInfo,
    FileEndOfFileInfo,
    FileStreamInfo,
    FileCompressionInfo,
    FileAttributeTagInfo,
    FileIdBothDirectoryInfo,
    FileIdBothDirectoryRestartInfo,
    FileIoPriorityHintInfo,
    MaximumFileInfoByHandleClass
} FILE_INFO_BY_HANDLE_CLASS, *PFILE_INFO_BY_HANDLE_CLASS;

struct FILE_BASIC_INFO {
    LARGE_INTEGER CreationTime;
    LARGE_INTEGER LastAccessTime;
    LARGE_INTEGER LastWriteTime;
    LARGE_INTEGER ChangeTime;
    DWORD FileAttributes;
}

typedef FILE_BASIC_INFO* PFILE_BASIC_INFO;

struct FILE_STANDARD_INFO {
    LARGE_INTEGER AllocationSize;
    LARGE_INTEGER EndOfFile;
    DWORD NumberOfLinks;
    BOOLEAN DeletePending;
    BOOLEAN Directory;
}

typedef FILE_STANDARD_INFO* PFILE_STANDARD_INFO;

struct FILE_NAME_INFO {
    DWORD FileNameLength;
    WCHAR FileName[1];
}

typedef FILE_NAME_INFO* PFILE_NAME_INFO;

struct FILE_RENAME_INFO {
    BOOLEAN ReplaceIfExists;
    HANDLE RootDirectory;
    DWORD FileNameLength;
    WCHAR FileName[1];
}

typedef FILE_RENAME_INFO* PFILE_RENAME_INFO;

struct FILE_ALLOCATION_INFO {
    LARGE_INTEGER AllocationSize;
}

typedef FILE_ALLOCATION_INFO* PFILE_ALLOCATION_INFO;

struct FILE_END_OF_FILE_INFO {
    LARGE_INTEGER EndOfFile;
}

typedef FILE_END_OF_FILE_INFO* PFILE_END_OF_FILE_INFO;

struct FILE_STREAM_INFO {
    DWORD NextEntryOffset;
    DWORD StreamNameLength;
    LARGE_INTEGER StreamSize;
    LARGE_INTEGER StreamAllocationSize;
    WCHAR StreamName[1];
}

typedef FILE_STREAM_INFO* PFILE_STREAM_INFO;

struct FILE_COMPRESSION_INFO {
    LARGE_INTEGER CompressedFileSize;
    WORD CompressionFormat;
    UCHAR CompressionUnitShift;
    UCHAR ChunkShift;
    UCHAR ClusterShift;
    UCHAR Reserved[3];
}

typedef FILE_COMPRESSION_INFO* PFILE_COMPRESSION_INFO;

struct FILE_ATTRIBUTE_TAG_INFO {
    DWORD FileAttributes;
    DWORD ReparseTag;
}

typedef FILE_ATTRIBUTE_TAG_INFO* PFILE_ATTRIBUTE_TAG_INFO;

struct FILE_DISPOSITION_INFO {
    BOOLEAN DeleteFile;
}

typedef FILE_DISPOSITION_INFO* PFILE_DISPOSITION_INFO;

struct FILE_ID_BOTH_DIR_INFO {
    DWORD NextEntryOffset;
    DWORD FileIndex;
    LARGE_INTEGER CreationTime;
    LARGE_INTEGER LastAccessTime;
    LARGE_INTEGER LastWriteTime;
    LARGE_INTEGER ChangeTime;
    LARGE_INTEGER EndOfFile;
    LARGE_INTEGER AllocationSize;
    DWORD FileAttributes;
    DWORD FileNameLength;
    DWORD EaSize;
    CCHAR ShortNameLength;
    WCHAR ShortName[12];
    LARGE_INTEGER FileId;
    WCHAR FileName[1];
}

typedef FILE_ID_BOTH_DIR_INFO* PFILE_ID_BOTH_DIR_INFO;

typedef enum _PRIORITY_HINT {
      IoPriorityHintVeryLow = 0,
      IoPriorityHintLow,
      IoPriorityHintNormal,
      MaximumIoPriorityHintType
} PRIORITY_HINT;

struct FILE_IO_PRIORITY_HINT_INFO {
    PRIORITY_HINT PriorityHint;
}

typedef FILE_IO_PRIORITY_HINT_INFO* PFILE_IO_PRIORITY_HINT_INFO;

BOOL
SetFileInformationByHandle(
    __in  HANDLE hFile,
    __in  FILE_INFO_BY_HANDLE_CLASS FileInformationClass,
    __in_bcount(dwBufferSize)  LPVOID lpFileInformation,
    __in  DWORD dwBufferSize
);

BOOL
GetFileInformationByHandleEx(
    __in  HANDLE hFile,
    __in  FILE_INFO_BY_HANDLE_CLASS FileInformationClass,
    __out_bcount(dwBufferSize) LPVOID lpFileInformation,
    __in  DWORD dwBufferSize
);

typedef enum _FILE_ID_TYPE {
      FileIdType,
      ObjectIdType,
      MaximumFileIdType
} FILE_ID_TYPE, *PFILE_ID_TYPE;

struct FILE_ID_DESCRIPTOR {
    DWORD dwSize;  // Size of the struct
    FILE_ID_TYPE Type; // Describes the type of identifier passed in.
    union {
        LARGE_INTEGER FileId;
        GUID ObjectId;
    };
}

typedef FILE_ID_DESCRIPTOR* LPFILE_ID_DESCRIPTOR;

__out
HANDLE
OpenFileById (
    __in     HANDLE hVolumeHint,
    __in     LPFILE_ID_DESCRIPTOR lpFileId,
    __in     DWORD dwDesiredAccess,
    __in     DWORD dwShareMode,
    __in_opt LPSECURITY_ATTRIBUTES lpSecurityAttributes,
    __in     DWORD dwFlagsAndAttributes
    );
#endif

#if (_WIN32_WINNT >= 0x0600)

//
//  Flags to be passed into CREATE_SYMBOLIC_LINK
//

const auto SYMBOLIC_LINK_FLAG_DIRECTORY             = (0x1);

const auto VALID_SYMBOLIC_LINK_FLAGS   = SYMBOLIC_LINK_FLAG_DIRECTORY ; // & whatever other flags we think of!

BOOLEAN
APIENTRY
CreateSymbolicLinkA (
    __in LPCSTR lpSymlinkFileName,
    __in LPCSTR lpTargetFileName,
    __in DWORD dwFlags
    );
BOOLEAN
APIENTRY
CreateSymbolicLinkW (
    __in LPCWSTR lpSymlinkFileName,
    __in LPCWSTR lpTargetFileName,
    __in DWORD dwFlags
    );

version(UNICODE) {
	alias CreateSymbolicLinkW CreateSymbolicLink;
}
else {
	alias CreateSymbolicLinkA CreateSymbolicLink;
}

BOOLEAN
APIENTRY
CreateSymbolicLinkTransactedA (
    __in     LPCSTR lpSymlinkFileName,
    __in     LPCSTR lpTargetFileName,
    __in     DWORD dwFlags,
    __in     HANDLE hTransaction
    );
BOOLEAN
APIENTRY
CreateSymbolicLinkTransactedW (
    __in     LPCWSTR lpSymlinkFileName,
    __in     LPCWSTR lpTargetFileName,
    __in     DWORD dwFlags,
    __in     HANDLE hTransaction
    );

version(UNICODE) {
	alias CreateSymbolicLinkTransactedW CreateSymbolicLinkTransacted;
}
else {
	alias CreateSymbolicLinkTransactedA CreateSymbolicLinkTransacted;
}

DWORD
GetFinalPathNameByHandleA (
    __in HANDLE hFile,
    __out_ecount(cchFilePath) LPSTR lpszFilePath,
    __in DWORD cchFilePath,
    __in DWORD dwFlags
);
DWORD
GetFinalPathNameByHandleW (
    __in HANDLE hFile,
    __out_ecount(cchFilePath) LPWSTR lpszFilePath,
    __in DWORD cchFilePath,
    __in DWORD dwFlags
);

version(UNICODE) {
	alias GetFinalPathNameByHandleW GetFinalPathNameByHandle;
}
else {
	alias GetFinalPathNameByHandleA GetFinalPathNameByHandle;
}

#endif // (_WIN32_WINNT >= 0x0600)


#if (_WIN32_WINNT >= 0x0600)

BOOL
QueryActCtxSettingsW(
    __in_opt      DWORD dwFlags,
    __in_opt      HANDLE hActCtx,
    __in_opt      PCWSTR settingsNameSpace,
    __in          PCWSTR settingName,
    __out_bcount_part_opt(dwBuffer, *pdwWrittenOrRequired) PWSTR pvBuffer,
    __in      SIZE_T dwBuffer,
    __out_opt SIZE_T *pdwWrittenOrRequired
    );

#endif

