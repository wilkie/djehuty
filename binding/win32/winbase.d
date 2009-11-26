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

import binding.c;

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

const auto INVALID_HANDLE_VALUE  = (cast(HANDLE)cast(LONG_PTR)-1);
const auto INVALID_FILE_SIZE  = (cast(DWORD)0xFFFFFFFF);
const auto INVALID_SET_FILE_POINTER  = (cast(DWORD)-1);
const auto INVALID_FILE_ATTRIBUTES  = (cast(DWORD)-1);

const auto FILE_BEGIN            = 0;
const auto FILE_CURRENT          = 1;
const auto FILE_END              = 2;

const auto TIME_ZONE_ID_INVALID  = (cast(DWORD)0xFFFFFFFF);

const auto WAIT_FAILED  = (cast(DWORD)0xFFFFFFFF);
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

alias RtlMoveMemory MoveMemory;
alias RtlCopyMemory CopyMemory;
alias RtlFillMemory FillMemory;
alias RtlZeroMemory ZeroMemory;
//alias SecureZeroMemory RtlSecureZeroMemory;
//alias CaptureStackBackTrace RtlCaptureStackBackTrace;

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

const auto COPY_FILE_COPY_SYMLINK                 = 0x00000800;

//
// Define ReplaceFile option flags
//

const auto REPLACEFILE_WRITE_THROUGH        = 0x00000001;
const auto REPLACEFILE_IGNORE_MERGE_ERRORS  = 0x00000002;

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

const auto SECURITY_ANONYMOUS           = ( SECURITY_IMPERSONATION_LEVEL.SecurityAnonymous      << 16 );
const auto SECURITY_IDENTIFICATION      = ( SECURITY_IMPERSONATION_LEVEL.SecurityIdentification << 16 );
const auto SECURITY_IMPERSONATION       = ( SECURITY_IMPERSONATION_LEVEL.SecurityImpersonation  << 16 );
const auto SECURITY_DELEGATION          = ( SECURITY_IMPERSONATION_LEVEL.SecurityDelegation     << 16 );

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
    union _inner_union {
        struct _inner_struct {
            DWORD Offset;
            DWORD OffsetHigh;
        }
        _inner_struct data;

        PVOID Pointer;
    }
    _inner_union fields;

    HANDLE  hEvent;
}

alias OVERLAPPED* LPOVERLAPPED;

struct OVERLAPPED_ENTRY {
    ULONG_PTR lpCompletionKey;
    LPOVERLAPPED lpOverlapped;
    ULONG_PTR Internal;
    DWORD dwNumberOfBytesTransferred;
}

alias OVERLAPPED_ENTRY* LPOVERLAPPED_ENTRY;

struct SECURITY_ATTRIBUTES {
    DWORD nLength;
    LPVOID lpSecurityDescriptor;
    BOOL bInheritHandle;
}

alias SECURITY_ATTRIBUTES* PSECURITY_ATTRIBUTES;
alias SECURITY_ATTRIBUTES* LPSECURITY_ATTRIBUTES;

struct PROCESS_INFORMATION {
    HANDLE hProcess;
    HANDLE hThread;
    DWORD dwProcessId;
    DWORD dwThreadId;
}

alias PROCESS_INFORMATION* PPROCESS_INFORMATION;
alias PROCESS_INFORMATION* LPPROCESS_INFORMATION;

//
//  File System time stamps are represented with the following structure:
//

struct FILETIME {
    DWORD dwLowDateTime;
    DWORD dwHighDateTime;
}

alias FILETIME* PFILETIME;
alias FILETIME* LPFILETIME;

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

alias SYSTEMTIME* PSYSTEMTIME;
alias SYSTEMTIME* LPSYSTEMTIME;

alias DWORD function(LPVOID lpThreadParameter) PTHREAD_START_ROUTINE;

alias PTHREAD_START_ROUTINE LPTHREAD_START_ROUTINE;

alias VOID function(LPVOID) PFIBER_START_ROUTINE;

alias PFIBER_START_ROUTINE LPFIBER_START_ROUTINE;

alias RTL_CRITICAL_SECTION CRITICAL_SECTION;
alias PRTL_CRITICAL_SECTION PCRITICAL_SECTION;
alias PRTL_CRITICAL_SECTION LPCRITICAL_SECTION;

alias RTL_CRITICAL_SECTION_DEBUG CRITICAL_SECTION_DEBUG;
alias PRTL_CRITICAL_SECTION_DEBUG PCRITICAL_SECTION_DEBUG;
alias PRTL_CRITICAL_SECTION_DEBUG LPCRITICAL_SECTION_DEBUG;

//
// Define one-time initialization primitive
//

alias RTL_RUN_ONCE INIT_ONCE;
alias PRTL_RUN_ONCE PINIT_ONCE;
alias PRTL_RUN_ONCE LPINIT_ONCE;

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

alias BOOL function(PINIT_ONCE InitOnce, PVOID Parameter, PVOID* Context) PINIT_ONCE_FN;

VOID InitOnceInitialize (
    PINIT_ONCE InitOnce
    );

BOOL InitOnceExecuteOnce (
    PINIT_ONCE InitOnce,
    PINIT_ONCE_FN InitFn,
    PVOID Parameter,
    LPVOID *Context
    );

BOOL InitOnceBeginInitialize (
    LPINIT_ONCE lpInitOnce,
    DWORD dwFlags,
    PBOOL fPending,
    LPVOID *lpContext
    );

BOOL InitOnceComplete (
    LPINIT_ONCE lpInitOnce,
    DWORD dwFlags,
    LPVOID lpContext
    );

//
// Define the slim r/w lock
//

alias RTL_SRWLOCK SRWLOCK;
alias RTL_SRWLOCK* PSRWLOCK;

const auto SRWLOCK_INIT  = RTL_SRWLOCK_INIT;

VOID InitializeSRWLock (
     PSRWLOCK SRWLock
     );

VOID ReleaseSRWLockExclusive (
     PSRWLOCK SRWLock
     );

VOID ReleaseSRWLockShared (
     PSRWLOCK SRWLock
     );

VOID AcquireSRWLockExclusive (
     PSRWLOCK SRWLock
     );

VOID AcquireSRWLockShared (
     PSRWLOCK SRWLock
     );

//
// Define condition variable
//

alias RTL_CONDITION_VARIABLE CONDITION_VARIABLE;
alias RTL_CONDITION_VARIABLE* PCONDITION_VARIABLE;

VOID InitializeConditionVariable (
    PCONDITION_VARIABLE ConditionVariable
    );

VOID WakeConditionVariable (
    PCONDITION_VARIABLE ConditionVariable
    );

VOID WakeAllConditionVariable (
    PCONDITION_VARIABLE ConditionVariable
    );

BOOL SleepConditionVariableCS (
    PCONDITION_VARIABLE ConditionVariable,
    PCRITICAL_SECTION CriticalSection,
    DWORD dwMilliseconds
    );

BOOL SleepConditionVariableSRW (
    PCONDITION_VARIABLE ConditionVariable,
    PSRWLOCK SRWLock,
    DWORD dwMilliseconds,
    ULONG Flags
    );

//
// Static initializer for the condition variable
//

const auto CONDITION_VARIABLE_INIT  = RTL_CONDITION_VARIABLE_INIT;

//
// Flags for condition variables
//
const auto CONDITION_VARIABLE_LOCKMODE_SHARED  = RTL_CONDITION_VARIABLE_LOCKMODE_SHARED;


PVOID EncodePointer (
    PVOID Ptr
    );

PVOID DecodePointer (
    PVOID Ptr
    );

PVOID EncodeSystemPointer (
    PVOID Ptr
    );

PVOID DecodeSystemPointer (
    PVOID Ptr
    );

version(X86) {
	//alias PLDT_ENTRY LPLDT_ENTRY;
	alias LPVOID LPLDT_ENTRY;
}
else {
	alias LPVOID LPLDT_ENTRY;
}

const auto MUTEX_MODIFY_STATE  = MUTANT_QUERY_STATE;
const auto MUTEX_ALL_ACCESS  = MUTANT_ALL_ACCESS;

//
// Serial provider type.
//

const auto SP_SERIALCOMM     = (cast(DWORD)0x00000001);

//
// Provider SubTypes
//

const auto PST_UNSPECIFIED       = (cast(DWORD)0x00000000);
const auto PST_RS232             = (cast(DWORD)0x00000001);
const auto PST_PARALLELPORT      = (cast(DWORD)0x00000002);
const auto PST_RS422             = (cast(DWORD)0x00000003);
const auto PST_RS423             = (cast(DWORD)0x00000004);
const auto PST_RS449             = (cast(DWORD)0x00000005);
const auto PST_MODEM             = (cast(DWORD)0x00000006);
const auto PST_FAX               = (cast(DWORD)0x00000021);
const auto PST_SCANNER           = (cast(DWORD)0x00000022);
const auto PST_NETWORK_BRIDGE    = (cast(DWORD)0x00000100);
const auto PST_LAT               = (cast(DWORD)0x00000101);
const auto PST_TCPIP_TELNET      = (cast(DWORD)0x00000102);
const auto PST_X25               = (cast(DWORD)0x00000103);


//
// Provider capabilities flags.
//

const auto PCF_DTRDSR         = (cast(DWORD)0x0001);
const auto PCF_RTSCTS         = (cast(DWORD)0x0002);
const auto PCF_RLSD           = (cast(DWORD)0x0004);
const auto PCF_PARITY_CHECK   = (cast(DWORD)0x0008);
const auto PCF_XONXOFF        = (cast(DWORD)0x0010);
const auto PCF_SETXCHAR       = (cast(DWORD)0x0020);
const auto PCF_TOTALTIMEOUTS  = (cast(DWORD)0x0040);
const auto PCF_INTTIMEOUTS    = (cast(DWORD)0x0080);
const auto PCF_SPECIALCHARS   = (cast(DWORD)0x0100);
const auto PCF_16BITMODE      = (cast(DWORD)0x0200);

//
// Comm provider settable parameters.
//

const auto SP_PARITY          = (cast(DWORD)0x0001);
const auto SP_BAUD            = (cast(DWORD)0x0002);
const auto SP_DATABITS        = (cast(DWORD)0x0004);
const auto SP_STOPBITS        = (cast(DWORD)0x0008);
const auto SP_HANDSHAKING     = (cast(DWORD)0x0010);
const auto SP_PARITY_CHECK    = (cast(DWORD)0x0020);
const auto SP_RLSD            = (cast(DWORD)0x0040);

//
// Settable baud rates in the provider.
//

const auto BAUD_075           = (cast(DWORD)0x00000001);
const auto BAUD_110           = (cast(DWORD)0x00000002);
const auto BAUD_134_5         = (cast(DWORD)0x00000004);
const auto BAUD_150           = (cast(DWORD)0x00000008);
const auto BAUD_300           = (cast(DWORD)0x00000010);
const auto BAUD_600           = (cast(DWORD)0x00000020);
const auto BAUD_1200          = (cast(DWORD)0x00000040);
const auto BAUD_1800          = (cast(DWORD)0x00000080);
const auto BAUD_2400          = (cast(DWORD)0x00000100);
const auto BAUD_4800          = (cast(DWORD)0x00000200);
const auto BAUD_7200          = (cast(DWORD)0x00000400);
const auto BAUD_9600          = (cast(DWORD)0x00000800);
const auto BAUD_14400         = (cast(DWORD)0x00001000);
const auto BAUD_19200         = (cast(DWORD)0x00002000);
const auto BAUD_38400         = (cast(DWORD)0x00004000);
const auto BAUD_56K           = (cast(DWORD)0x00008000);
const auto BAUD_128K          = (cast(DWORD)0x00010000);
const auto BAUD_115200        = (cast(DWORD)0x00020000);
const auto BAUD_57600         = (cast(DWORD)0x00040000);
const auto BAUD_USER          = (cast(DWORD)0x10000000);

//
// Settable Data Bits
//

const auto DATABITS_5         = (cast(WORD)0x0001);
const auto DATABITS_6         = (cast(WORD)0x0002);
const auto DATABITS_7         = (cast(WORD)0x0004);
const auto DATABITS_8         = (cast(WORD)0x0008);
const auto DATABITS_16        = (cast(WORD)0x0010);
const auto DATABITS_16X       = (cast(WORD)0x0020);

//
// Settable Stop and Parity bits.
//

const auto STOPBITS_10        = (cast(WORD)0x0001);
const auto STOPBITS_15        = (cast(WORD)0x0002);
const auto STOPBITS_20        = (cast(WORD)0x0004);
const auto PARITY_NONE        = (cast(WORD)0x0100);
const auto PARITY_ODD         = (cast(WORD)0x0200);
const auto PARITY_EVEN        = (cast(WORD)0x0400);
const auto PARITY_MARK        = (cast(WORD)0x0800);
const auto PARITY_SPACE       = (cast(WORD)0x1000);

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
    WCHAR[1] wcProvChar;
}

alias COMMPROP* LPCOMMPROP;

//
// Set dwProvSpec1 to COMMPROP_INITIALIZED to indicate that wPacketLength
// is valid before a call to GetCommProperties().
//
const auto COMMPROP_INITIALIZED  = (cast(DWORD)0xE73CF52E);

struct COMSTAT {
	DWORD flags;
/*    DWORD fCtsHold : 1;
    DWORD fDsrHold : 1;
    DWORD fRlsdHold : 1;
    DWORD fXoffHold : 1;
    DWORD fXoffSent : 1;
    DWORD fEof : 1;
    DWORD fTxim : 1;
    DWORD fReserved : 25;
    */
    DWORD cbInQue;
    DWORD cbOutQue;
}

alias COMSTAT* LPCOMSTAT;

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

	DWORD flags;

/+	DWORD fBinary: 1;     /* Binary Mode (skip EOF check)    */
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
+/

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

alias DCB* LPDCB;

struct COMMTIMEOUTS {
    DWORD ReadIntervalTimeout;          /* Maximum time between read chars. */
    DWORD ReadTotalTimeoutMultiplier;   /* Multiplier of characters.        */
    DWORD ReadTotalTimeoutConstant;     /* Constant in milliseconds.        */
    DWORD WriteTotalTimeoutMultiplier;  /* Multiplier of characters.        */
    DWORD WriteTotalTimeoutConstant;    /* Constant in milliseconds.        */
}

alias COMMTIMEOUTS* LPCOMMTIMEOUTS;

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

alias COMMCONFIG* LPCOMMCONFIG;

struct SYSTEM_INFO {
    WORD wProcessorArchitecture;
    WORD wReserved;
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

alias SYSTEM_INFO* LPSYSTEM_INFO;

//
//

alias FreeLibrary FreeModule;
//const auto MakeProcInstance(lpProc,hInstance)  = (lpProc);
//const auto FreeProcInstance(lpProc)  = (lpProc);

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

//const auto GlobalLRUNewest(  = h )    ((HANDLE)(h));
//const auto GlobalLRUOldest(  = h )    ((HANDLE)(h));
//const auto GlobalDiscard(  = h )      GlobalReAlloc( (h), 0, GMEM_MOVEABLE );

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

alias MEMORYSTATUS* LPMEMORYSTATUS;

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

//const auto LocalDiscard(  = h )   LocalReAlloc( (h), 0, LMEM_MOVEABLE );

/* Flags returned by LocalFlags (in addition to LMEM_DISCARDABLE) */
const auto LMEM_DISCARDED       = 0x4000;
const auto LMEM_LOCKCOUNT       = 0x00FF;

//
// NUMA values
//
const auto NUMA_NO_PREFERRED_NODE  = (cast(DWORD) -1);

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

alias EXCEPTION_DEBUG_INFO* LPEXCEPTION_DEBUG_INFO;

struct CREATE_THREAD_DEBUG_INFO {
    HANDLE hThread;
    LPVOID lpThreadLocalBase;
    LPTHREAD_START_ROUTINE lpStartAddress;
}

alias CREATE_THREAD_DEBUG_INFO* LPCREATE_THREAD_DEBUG_INFO;

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

alias CREATE_PROCESS_DEBUG_INFO* LPCREATE_PROCESS_DEBUG_INFO;

struct EXIT_THREAD_DEBUG_INFO {
    DWORD dwExitCode;
}

alias EXIT_THREAD_DEBUG_INFO* LPEXIT_THREAD_DEBUG_INFO;

struct EXIT_PROCESS_DEBUG_INFO {
    DWORD dwExitCode;
}

alias EXIT_PROCESS_DEBUG_INFO* LPEXIT_PROCESS_DEBUG_INFO;

struct LOAD_DLL_DEBUG_INFO {
    HANDLE hFile;
    LPVOID lpBaseOfDll;
    DWORD dwDebugInfoFileOffset;
    DWORD nDebugInfoSize;
    LPVOID lpImageName;
    WORD fUnicode;
}

alias LOAD_DLL_DEBUG_INFO* LPLOAD_DLL_DEBUG_INFO;

struct UNLOAD_DLL_DEBUG_INFO {
    LPVOID lpBaseOfDll;
}

alias UNLOAD_DLL_DEBUG_INFO* LPUNLOAD_DLL_DEBUG_INFO;

struct OUTPUT_DEBUG_STRING_INFO {
    LPSTR lpDebugStringData;
    WORD fUnicode;
    WORD nDebugStringLength;
}

alias OUTPUT_DEBUG_STRING_INFO* LPOUTPUT_DEBUG_STRING_INFO;

struct RIP_INFO {
    DWORD dwError;
    DWORD dwType;
}

alias RIP_INFO* LPRIP_INFO;


struct DEBUG_EVENT {
    DWORD dwDebugEventCode;
    DWORD dwProcessId;
    DWORD dwThreadId;
    union _inner_union {
        EXCEPTION_DEBUG_INFO Exception;
        CREATE_THREAD_DEBUG_INFO CreateThread;
        CREATE_PROCESS_DEBUG_INFO CreateProcessInfo;
        EXIT_THREAD_DEBUG_INFO ExitThread;
        EXIT_PROCESS_DEBUG_INFO ExitProcess;
        LOAD_DLL_DEBUG_INFO LoadDll;
        UNLOAD_DLL_DEBUG_INFO UnloadDll;
        OUTPUT_DEBUG_STRING_INFO DebugString;
        RIP_INFO RipInfo;
    }
	_inner_union u;
}

alias DEBUG_EVENT* LPDEBUG_EVENT;

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

alias JIT_DEBUG_INFO* LPJIT_DEBUG_INFO;

alias JIT_DEBUG_INFO JIT_DEBUG_INFO32;
alias JIT_DEBUG_INFO* LPJIT_DEBUG_INFO32;
alias JIT_DEBUG_INFO JIT_DEBUG_INFO64;
alias JIT_DEBUG_INFO* LPJIT_DEBUG_INFO64;

alias PCONTEXT LPCONTEXT;
alias PEXCEPTION_RECORD LPEXCEPTION_RECORD;
alias PEXCEPTION_POINTERS LPEXCEPTION_POINTERS;

const auto DRIVE_UNKNOWN      = 0;
const auto DRIVE_NO_ROOT_DIR  = 1;
const auto DRIVE_REMOVABLE    = 2;
const auto DRIVE_FIXED        = 3;
const auto DRIVE_REMOTE       = 4;
const auto DRIVE_CDROM        = 5;
const auto DRIVE_RAMDISK      = 6;


DWORD GetFreeSpace(uint w) { return (0x100000); }

const auto FILE_TYPE_UNKNOWN    = 0x0000;
const auto FILE_TYPE_DISK       = 0x0001;
const auto FILE_TYPE_CHAR       = 0x0002;
const auto FILE_TYPE_PIPE       = 0x0003;
const auto FILE_TYPE_REMOTE     = 0x8000;

const auto STD_INPUT_HANDLE     = (cast(DWORD)-10);
const auto STD_OUTPUT_HANDLE    = (cast(DWORD)-11);
const auto STD_ERROR_HANDLE     = (cast(DWORD)-12);

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
const auto MS_CTS_ON            = (cast(DWORD)0x0010);
const auto MS_DSR_ON            = (cast(DWORD)0x0020);
const auto MS_RING_ON           = (cast(DWORD)0x0040);
const auto MS_RLSD_ON           = (cast(DWORD)0x0080);

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

alias OFSTRUCT* LPOFSTRUCT;
alias OFSTRUCT* POFSTRUCT;

version(NOWINBASEINTERLOCK) {
}
else {

	LONG InterlockedIncrement (
	    LONG* lpAddend
	    );
	
	LONG InterlockedDecrement (
	    LONG* lpAddend
	    );
	
	LONG InterlockedExchange (
	    LONG* Target,
	       LONG Value
	    );
	
	//const auto InterlockedExchangePointer(Target,  = Value) \;
	//    (PVOID)InterlockedExchange((PLONG)(Target), (LONG)(Value))
	
	LONG InterlockedExchangeAdd (
	    LONG *Addend,
	       LONG Value
	    );
	
	LONG InterlockedCompareExchange (
	    LONG* Destination,
	       LONG Exchange,
	       LONG Comperand
	    );
	
	LONGLONG InterlockedCompareExchange64 (
	    LONGLONG *Destination,
	       LONGLONG Exchange,
	       LONGLONG Comperand
	    );
	
	alias InterlockedIncrement InterlockedIncrementAcquire;
	alias InterlockedIncrement InterlockedIncrementRelease;
	alias InterlockedDecrement InterlockedDecrementAcquire;
	alias InterlockedDecrement InterlockedDecrementRelease;
	alias InterlockedIncrement InterlockedIncrementAcquire;
	alias InterlockedIncrement InterlockedIncrementRelease;
	alias InterlockedCompareExchange InterlockedCompareExchangeAcquire;
	alias InterlockedCompareExchange InterlockedCompareExchangeRelease;
	alias InterlockedCompareExchange64 InterlockedCompareExchangeAcquire64;
	alias InterlockedCompareExchange64 InterlockedCompareExchangeRelease64;
	//alias InterlockedCompareExchangePointer InterlockedCompareExchangePointerAcquire;
	//alias InterlockedCompareExchangePointer InterlockedCompareExchangePointerRelease;

	VOID InitializeSListHead (
	    PSLIST_HEADER ListHead
	    );

	PSLIST_ENTRY InterlockedPopEntrySList (
	    PSLIST_HEADER ListHead
	    );

	PSLIST_ENTRY InterlockedPushEntrySList (
	    PSLIST_HEADER ListHead,
	    PSLIST_ENTRY ListEntry
	    );

	PSLIST_ENTRY InterlockedFlushSList (
	    PSLIST_HEADER ListHead
	    );

	USHORT QueryDepthSList (
	    PSLIST_HEADER ListHead
	    );
}

BOOL FreeResource(
    HGLOBAL hResData
    );

LPVOID LockResource(
    HGLOBAL hResData
    );

//const auto UnlockResource(hResData)  = ((hResData), 0);
const auto MAXINTATOM  = 0xC000;
template MAKEINTATOM(WORD i) {
	const LPTSTR MAKEINTATOM = cast(LPTSTR)(cast(ULONG_PTR)(cast(WORD)(i)));
}
const auto INVALID_ATOM  = (cast(ATOM)0);

int WinMain (
    HINSTANCE hInstance,
    HINSTANCE hPrevInstance,
    LPSTR lpCmdLine,
    int nShowCmd
    );

int wWinMain(
    HINSTANCE hInstance,
    HINSTANCE hPrevInstance,
    LPWSTR lpCmdLine,
    int nShowCmd
    );

BOOL FreeLibrary (
    HMODULE hLibModule
    );

VOID FreeLibraryAndExitThread (
    HMODULE hLibModule,
    DWORD dwExitCode
    );

BOOL DisableThreadLibraryCalls (
    HMODULE hLibModule
    );

FARPROC GetProcAddress (
    HMODULE hModule,
    LPCSTR lpProcName
    );

DWORD GetVersion (
    );

HGLOBAL GlobalAlloc (
    UINT uFlags,
    SIZE_T dwBytes
    );

HGLOBAL GlobalReAlloc (
    HGLOBAL hMem,
    SIZE_T dwBytes,
    UINT uFlags
    );

SIZE_T GlobalSize (
    HGLOBAL hMem
    );

UINT GlobalFlags (
    HGLOBAL hMem
    );

LPVOID GlobalLock (
    HGLOBAL hMem
    );

HGLOBAL GlobalHandle (
    LPCVOID pMem
    );

BOOL GlobalUnlock(
    HGLOBAL hMem
    );

HGLOBAL GlobalFree(
    HGLOBAL hMem
    );

SIZE_T GlobalCompact(
    DWORD dwMinFree
    );

VOID GlobalFix(
    HGLOBAL hMem
    );

VOID GlobalUnfix(
    HGLOBAL hMem
    );

LPVOID GlobalWire(
    HGLOBAL hMem
    );

BOOL GlobalUnWire(
    HGLOBAL hMem
    );

VOID GlobalMemoryStatus(
    LPMEMORYSTATUS lpBuffer
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

alias MEMORYSTATUSEX* LPMEMORYSTATUSEX;

BOOL GlobalMemoryStatusEx(
    LPMEMORYSTATUSEX lpBuffer
    );

HLOCAL LocalAlloc(
    UINT uFlags,
    SIZE_T uBytes
    );

HLOCAL LocalReAlloc(
    HLOCAL hMem,
    SIZE_T uBytes,
    UINT uFlags
    );


LPVOID LocalLock(
    HLOCAL hMem
    );


HLOCAL LocalHandle(
    LPCVOID pMem
    );

BOOL LocalUnlock(
    HLOCAL hMem
    );

SIZE_T LocalSize(
    HLOCAL hMem
    );

UINT LocalFlags(
    HLOCAL hMem
    );

HLOCAL LocalFree(
    HLOCAL hMem
    );

SIZE_T LocalShrink(
    HLOCAL hMem,
    UINT cbNewSize
    );

SIZE_T LocalCompact(
    UINT uMinFree
    );

BOOL FlushInstructionCache(
    HANDLE hProcess,
    LPCVOID lpBaseAddress,
    SIZE_T dwSize
    );

VOID FlushProcessWriteBuffers();

BOOL QueryThreadCycleTime (
    HANDLE ThreadHandle,
    PULONG64 CycleTime
    );

BOOL QueryProcessCycleTime (
    HANDLE ProcessHandle,
    PULONG64 CycleTime
    );

BOOL QueryIdleProcessorCycleTime (
    PULONG BufferLength,
    PULONG64 ProcessorIdleCycleTime
    );

LPVOID VirtualAlloc(
    LPVOID lpAddress,
        SIZE_T dwSize,
        DWORD flAllocationType,
        DWORD flProtect
    );

BOOL VirtualFree(
    LPVOID lpAddress,
    SIZE_T dwSize,
    DWORD dwFreeType
    );

BOOL VirtualProtect(
     LPVOID lpAddress,
     SIZE_T dwSize,
     DWORD flNewProtect,
    PDWORD lpflOldProtect
    );

SIZE_T VirtualQuery(
    LPCVOID lpAddress,
    PMEMORY_BASIC_INFORMATION lpBuffer,
    SIZE_T dwLength
    );

LPVOID VirtualAllocEx(
    HANDLE hProcess,
    LPVOID lpAddress,
    SIZE_T dwSize,
    DWORD flAllocationType,
	DWORD flProtect
    );

LPVOID VirtualAllocExNuma(
    HANDLE hProcess,
    LPVOID lpAddress,
	SIZE_T dwSize,
	DWORD  flAllocationType,
	DWORD  flProtect,
    DWORD  nndPreferred
    );

UINT GetWriteWatch(
    DWORD dwFlags,
    PVOID lpBaseAddress,
    SIZE_T dwRegionSize,
    PVOID *lpAddresses,
    ULONG_PTR *lpdwCount,
    PULONG lpdwGranularity
    );

UINT ResetWriteWatch(
    LPVOID lpBaseAddress,
    SIZE_T dwRegionSize
    );

SIZE_T GetLargePageMinimum();

UINT EnumSystemFirmwareTables(
    DWORD FirmwareTableProviderSignature,
    PVOID pFirmwareTableEnumBuffer,
    DWORD BufferSize
    );

UINT GetSystemFirmwareTable(
    DWORD FirmwareTableProviderSignature,
    DWORD FirmwareTableID,
    PVOID pFirmwareTableBuffer,
    DWORD BufferSize
    );

BOOL VirtualFreeEx(
    HANDLE hProcess,
    LPVOID lpAddress,
    SIZE_T dwSize,
    DWORD  dwFreeType
    );

BOOL VirtualProtectEx(
    HANDLE hProcess,
    LPVOID lpAddress,
    SIZE_T dwSize,
    DWORD flNewProtect,
    PDWORD lpflOldProtect
    );

SIZE_T VirtualQueryEx(
    HANDLE hProcess,
    LPCVOID lpAddress,
    PMEMORY_BASIC_INFORMATION lpBuffer,
    SIZE_T dwLength
    );


HANDLE HeapCreate(
    DWORD flOptions,
    SIZE_T dwInitialSize,
    SIZE_T dwMaximumSize
    );

BOOL HeapDestroy(
    HANDLE hHeap
    );

LPVOID HeapAlloc(
    HANDLE hHeap,
    DWORD dwFlags,
    SIZE_T dwBytes
    );

LPVOID HeapReAlloc(
    HANDLE hHeap,
    DWORD dwFlags,
    LPVOID lpMem,
    SIZE_T dwBytes
    );

BOOL HeapFree(
    HANDLE hHeap,
    DWORD dwFlags,
    LPVOID lpMem
    );

SIZE_T HeapSize(
    HANDLE hHeap,
    DWORD dwFlags,
    LPCVOID lpMem
    );

BOOL HeapValidate(
    HANDLE hHeap,
    DWORD dwFlags,
    LPCVOID lpMem
    );

SIZE_T HeapCompact(
    HANDLE hHeap,
    DWORD dwFlags
    );


HANDLE GetProcessHeap();

DWORD GetProcessHeaps(
    DWORD NumberOfHeaps,
    PHANDLE ProcessHeaps
    );

struct PROCESS_HEAP_ENTRY {
    PVOID lpData;
    DWORD cbData;
    BYTE cbOverhead;
    BYTE iRegionIndex;
    WORD wFlags;
    union _inner_union {
        struct _inner_struct {
            HANDLE hMem;
            DWORD[3] dwReserved;
        }
		_inner_struct Block;
        struct _inner_struct2 {
            DWORD dwCommittedSize;
            DWORD dwUnCommittedSize;
            LPVOID lpFirstBlock;
            LPVOID lpLastBlock;
        }
		_inner_struct2 Region;
    }
    _inner_union fields;
}

alias PROCESS_HEAP_ENTRY* LPPROCESS_HEAP_ENTRY;
alias PROCESS_HEAP_ENTRY* PPROCESS_HEAP_ENTRY;

const auto PROCESS_HEAP_REGION              = 0x0001;
const auto PROCESS_HEAP_UNCOMMITTED_RANGE   = 0x0002;
const auto PROCESS_HEAP_ENTRY_BUSY          = 0x0004;
const auto PROCESS_HEAP_ENTRY_MOVEABLE      = 0x0010;
const auto PROCESS_HEAP_ENTRY_DDESHARE      = 0x0020;

BOOL HeapLock(
    HANDLE hHeap
    );

BOOL HeapUnlock(
    HANDLE hHeap
    );


BOOL HeapWalk(
    HANDLE hHeap,
    LPPROCESS_HEAP_ENTRY lpEntry
    );

BOOL HeapSetInformation (
    HANDLE HeapHandle,
    HEAP_INFORMATION_CLASS HeapInformationClass,
    PVOID HeapInformation,
    SIZE_T HeapInformationLength
    );

BOOL HeapQueryInformation (
    HANDLE HeapHandle,
    HEAP_INFORMATION_CLASS HeapInformationClass,
    PVOID HeapInformation,
    SIZE_T HeapInformationLength,
    PSIZE_T ReturnLength
    );

// GetBinaryType return values.

const auto SCS_32BIT_BINARY     = 0;
const auto SCS_DOS_BINARY       = 1;
const auto SCS_WOW_BINARY       = 2;
const auto SCS_PIF_BINARY       = 3;
const auto SCS_POSIX_BINARY     = 4;
const auto SCS_OS216_BINARY     = 5;
const auto SCS_64BIT_BINARY     = 6;

version(X86_64) {
	const auto SCS_THIS_PLATFORM_BINARY = SCS_64BIT_BINARY;
}
else {
	const auto SCS_THIS_PLATFORM_BINARY = SCS_32BIT_BINARY;
}

BOOL GetBinaryTypeA(
    LPCSTR lpApplicationName,
    LPDWORD  lpBinaryType
    );
BOOL GetBinaryTypeW(
    LPCWSTR lpApplicationName,
    LPDWORD  lpBinaryType
    );

version(UNICODE) {
	alias GetBinaryTypeW GetBinaryType;
}
else {
	alias GetBinaryTypeA GetBinaryType;
}

DWORD GetShortPathNameA(
    LPCSTR lpszLongPath,
    LPSTR  lpszShortPath,
    DWORD cchBuffer
    );

DWORD GetShortPathNameW(
    LPCWSTR lpszLongPath,
    LPWSTR  lpszShortPath,
    DWORD cchBuffer
    );

version(UNICODE) {
	alias GetShortPathNameW GetShortPathName;
}
else {
	alias GetShortPathNameA GetShortPathName;
}

DWORD GetLongPathNameA(
    LPCSTR lpszShortPath,
    LPSTR  lpszLongPath,
    DWORD cchBuffer
    );

DWORD GetLongPathNameW(
    LPCWSTR lpszShortPath,
    LPWSTR  lpszLongPath,
    DWORD cchBuffer
    );

version(UNICODE) {
	alias GetLongPathNameW GetLongPathName;
}
else {
	alias GetLongPathNameA GetLongPathName;
}

DWORD GetLongPathNameTransactedA(
    LPCSTR lpszShortPath,
    LPSTR  lpszLongPath,
    DWORD cchBuffer,
	HANDLE hTransaction
    );

DWORD GetLongPathNameTransactedW(
    LPCWSTR lpszShortPath,
    LPWSTR  lpszLongPath,
    DWORD cchBuffer,
	HANDLE hTransaction
    );

version(UNICODE) {
	alias GetLongPathNameTransactedW GetLongPathNameTransacted;
}
else {
	alias GetLongPathNameTransactedA GetLongPathNameTransacted;
}

BOOL GetProcessAffinityMask(
    HANDLE hProcess,
    PDWORD_PTR lpProcessAffinityMask,
    PDWORD_PTR lpSystemAffinityMask
    );

BOOL SetProcessAffinityMask(
    HANDLE hProcess,
    DWORD_PTR dwProcessAffinityMask
    );

BOOL GetProcessHandleCount(
    HANDLE hProcess,
    PDWORD pdwHandleCount
    );

BOOL GetProcessTimes(
    HANDLE hProcess,
    LPFILETIME lpCreationTime,
    LPFILETIME lpExitTime,
    LPFILETIME lpKernelTime,
    LPFILETIME lpUserTime
    );

BOOL GetProcessIoCounters(
     HANDLE hProcess,
    PIO_COUNTERS lpIoCounters
    );

BOOL GetProcessWorkingSetSize(
    HANDLE hProcess,
    PSIZE_T lpMinimumWorkingSetSize,
    PSIZE_T lpMaximumWorkingSetSize
    );

BOOL GetProcessWorkingSetSizeEx(
    HANDLE hProcess,
    PSIZE_T lpMinimumWorkingSetSize,
    PSIZE_T lpMaximumWorkingSetSize,
    PDWORD Flags
    );

BOOL SetProcessWorkingSetSize(
    HANDLE hProcess,
    SIZE_T dwMinimumWorkingSetSize,
    SIZE_T dwMaximumWorkingSetSize
    );

BOOL SetProcessWorkingSetSizeEx(
    HANDLE hProcess,
    SIZE_T dwMinimumWorkingSetSize,
    SIZE_T dwMaximumWorkingSetSize,
    DWORD Flags
    );

HANDLE OpenProcess(
    DWORD dwDesiredAccess,
    BOOL bInheritHandle,
    DWORD dwProcessId
    );


HANDLE GetCurrentProcess();

DWORD GetCurrentProcessId();

VOID ExitProcess(
    UINT uExitCode
    );

BOOL TerminateProcess(
    HANDLE hProcess,
    UINT uExitCode
    );

BOOL GetExitCodeProcess(
    HANDLE hProcess,
    LPDWORD lpExitCode
    );

VOID FatalExit(
    int ExitCode
    );

LPCH GetEnvironmentStrings();

LPWCH
GetEnvironmentStringsW();

version(UNICODE) {
	alias GetEnvironmentStringsW GetEnvironmentStrings;
}
else {
	alias GetEnvironmentStrings GetEnvironmentStringsA;
}

BOOL SetEnvironmentStringsA(
    LPCH NewEnvironment
    );

BOOL SetEnvironmentStringsW(
    LPWCH NewEnvironment
    );

version(UNICODE) {
	alias SetEnvironmentStringsW SetEnvironmentStrings;
}
else {
	alias SetEnvironmentStringsA SetEnvironmentStrings;
}

BOOL FreeEnvironmentStringsA(
    LPCH
    );

BOOL FreeEnvironmentStringsW(
    LPWCH
    );

version(UNICODE) {
	alias FreeEnvironmentStringsW FreeEnvironmentStrings;
}
else {
	alias FreeEnvironmentStringsA FreeEnvironmentStrings;
}

VOID RaiseException(
    DWORD dwExceptionCode,
    DWORD dwExceptionFlags,
    DWORD nNumberOfArguments,
    ULONG_PTR *lpArguments
    );

LONG UnhandledExceptionFilter(
    EXCEPTION_POINTERS *ExceptionInfo
    );

alias LONG function(EXCEPTION_POINTERS* ExceptionInfo) PTOP_LEVEL_EXCEPTION_FILTER;
alias PTOP_LEVEL_EXCEPTION_FILTER LPTOP_LEVEL_EXCEPTION_FILTER;

LPTOP_LEVEL_EXCEPTION_FILTER SetUnhandledExceptionFilter(
    LPTOP_LEVEL_EXCEPTION_FILTER lpTopLevelExceptionFilter
    );

//
// Fiber creation flags
//

const auto FIBER_FLAG_FLOAT_SWITCH  = 0x1     ; // context switch floating point

LPVOID CreateFiber(
    SIZE_T dwStackSize,
    LPFIBER_START_ROUTINE lpStartAddress,
    LPVOID lpParameter
    );

LPVOID CreateFiberEx(
	SIZE_T dwStackCommitSize,
    SIZE_T dwStackReserveSize,
    DWORD dwFlags,
    LPFIBER_START_ROUTINE lpStartAddress,
    LPVOID lpParameter
    );

VOID DeleteFiber(
    LPVOID lpFiber
    );


LPVOID ConvertThreadToFiber(
    LPVOID lpParameter
    );


LPVOID ConvertThreadToFiberEx(
    LPVOID lpParameter,
    DWORD dwFlags
    );

BOOL ConvertFiberToThread();

BOOL IsThreadAFiber();

VOID SwitchToFiber(
    LPVOID lpFiber
    );

BOOL SwitchToThread();

HANDLE CreateThread(
    LPSECURITY_ATTRIBUTES lpThreadAttributes,
	SIZE_T dwStackSize,
	LPTHREAD_START_ROUTINE lpStartAddress,
    LPVOID lpParameter,
	DWORD dwCreationFlags,
    LPDWORD lpThreadId
    );

HANDLE CreateRemoteThread(
    HANDLE hProcess,
    LPSECURITY_ATTRIBUTES lpThreadAttributes,
    SIZE_T dwStackSize,
    LPTHREAD_START_ROUTINE lpStartAddress,
    LPVOID lpParameter,
    DWORD dwCreationFlags,
    LPDWORD lpThreadId
    );

HANDLE GetCurrentThread();

DWORD GetCurrentThreadId();

BOOL SetThreadStackGuarantee (
    PULONG StackSizeInBytes
    );

DWORD GetProcessIdOfThread(
    HANDLE Thread
    );

DWORD GetThreadId(
    HANDLE Thread
    );

DWORD GetProcessId(
    HANDLE Process
    );

DWORD GetCurrentProcessorNumber();

DWORD_PTR SetThreadAffinityMask(
    HANDLE hThread,
    DWORD_PTR dwThreadAffinityMask
    );

DWORD SetThreadIdealProcessor(
    HANDLE hThread,
    DWORD dwIdealProcessor
    );

BOOL SetProcessPriorityBoost(
    HANDLE hProcess,
    BOOL bDisablePriorityBoost
    );

BOOL GetProcessPriorityBoost(
    HANDLE hProcess,
    PBOOL  pDisablePriorityBoost
    );

BOOL RequestWakeupLatency(
    LATENCY_TIME latency
    );

BOOL IsSystemResumeAutomatic();

HANDLE OpenThread(
    DWORD dwDesiredAccess,
    BOOL bInheritHandle,
    DWORD dwThreadId
    );

BOOL SetThreadPriority(
    HANDLE hThread,
    int nPriority
    );

BOOL SetThreadPriorityBoost(
    HANDLE hThread,
    BOOL bDisablePriorityBoost
    );

BOOL GetThreadPriorityBoost(
    HANDLE hThread,
    PBOOL pDisablePriorityBoost
    );

int GetThreadPriority(
    HANDLE hThread
    );

BOOL GetThreadTimes(
    HANDLE hThread,
    LPFILETIME lpCreationTime,
    LPFILETIME lpExitTime,
    LPFILETIME lpKernelTime,
    LPFILETIME lpUserTime
    );

BOOL GetThreadIOPendingFlag(
    HANDLE hThread,
    PBOOL  lpIOIsPending
    );

VOID ExitThread(
    DWORD dwExitCode
    );

BOOL TerminateThread(
    HANDLE hThread,
    DWORD dwExitCode
    );

BOOL GetExitCodeThread(
    HANDLE hThread,
    LPDWORD lpExitCode
    );

BOOL GetThreadSelectorEntry(
    HANDLE hThread,
    DWORD dwSelector,
    LPLDT_ENTRY lpSelectorEntry
    );

EXECUTION_STATE SetThreadExecutionState(
    EXECUTION_STATE esFlags
    );

DWORD GetLastError();

VOID SetLastError(
    DWORD dwErrCode
    );

VOID RestoreLastError(
    DWORD dwErrCode
    );

alias VOID function(DWORD) PRESTORE_LAST_ERROR;
const auto RESTORE_LAST_ERROR_NAME_A       = "RestoreLastError\0"c;
const auto RESTORE_LAST_ERROR_NAME_W       = "RestoreLastError\0"w;

version(UNICODE) {
	const auto RESTORE_LAST_ERROR_NAME    = RESTORE_LAST_ERROR_NAME_W;
}
else {
	const auto RESTORE_LAST_ERROR_NAME    = RESTORE_LAST_ERROR_NAME_A;
}

//const auto HasOverlappedIoCompleted(lpOverlapped)  = (((DWORD)(lpOverlapped)->Internal) != STATUS_PENDING);

BOOL GetOverlappedResult(
    HANDLE hFile,
    LPOVERLAPPED lpOverlapped,
    LPDWORD lpNumberOfBytesTransferred,
    BOOL bWait
    );


HANDLE CreateIoCompletionPort(
    HANDLE FileHandle,
    HANDLE ExistingCompletionPort,
    ULONG_PTR CompletionKey,
    DWORD NumberOfConcurrentThreads
    );

BOOL GetQueuedCompletionStatus(
    HANDLE CompletionPort,
    LPDWORD lpNumberOfBytesTransferred,
    PULONG_PTR lpCompletionKey,
    LPOVERLAPPED *lpOverlapped,
    DWORD dwMilliseconds
    );

BOOL GetQueuedCompletionStatusEx(
    HANDLE CompletionPort,
    LPOVERLAPPED_ENTRY lpCompletionPortEntries,
    ULONG ulCount,
    PULONG ulNumEntriesRemoved,
    DWORD dwMilliseconds,
    BOOL fAlertable
    );

BOOL PostQueuedCompletionStatus(
    HANDLE CompletionPort,
	DWORD dwNumberOfBytesTransferred,
    ULONG_PTR dwCompletionKey,
    LPOVERLAPPED lpOverlapped
    );

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

BOOL SetFileCompletionNotificationModes(
    HANDLE FileHandle,
    UCHAR Flags
    );

BOOL SetFileIoOverlappedRange(
    HANDLE FileHandle,
    PUCHAR OverlappedRangeStart,
    ULONG Length
    );

const auto SEM_FAILCRITICALERRORS       = 0x0001;
const auto SEM_NOGPFAULTERRORBOX        = 0x0002;
const auto SEM_NOALIGNMENTFAULTEXCEPT   = 0x0004;
const auto SEM_NOOPENFILEERRORBOX       = 0x8000;

UINT GetErrorMode();

UINT SetErrorMode(
    UINT uMode
    );

BOOL ReadProcessMemory(
    HANDLE hProcess,
    LPCVOID lpBaseAddress,
    LPVOID lpBuffer,
	SIZE_T nSize,
    SIZE_T * lpNumberOfBytesRead
    );

BOOL WriteProcessMemory(
    HANDLE hProcess,
    LPVOID lpBaseAddress,
    LPCVOID lpBuffer,
	SIZE_T nSize,
    SIZE_T * lpNumberOfBytesWritten
    );

BOOL GetThreadContext(
    HANDLE hThread,
    LPCONTEXT lpContext
    );

BOOL SetThreadContext(
    HANDLE hThread,
    CONTEXT *lpContext
    );

BOOL Wow64GetThreadContext(
    HANDLE hThread,
    PWOW64_CONTEXT lpContext
    );

BOOL Wow64SetThreadContext(
    HANDLE hThread,
    WOW64_CONTEXT *lpContext
    );

DWORD SuspendThread(
    HANDLE hThread
    );

DWORD Wow64SuspendThread(
    HANDLE hThread
    );

DWORD ResumeThread(
    HANDLE hThread
    );

alias VOID function(ULONG_PTR dwParam) PAPCFUNC;

DWORD QueueUserAPC(
    PAPCFUNC pfnAPC,
    HANDLE hThread,
    ULONG_PTR dwData
    );

BOOL IsDebuggerPresent();

BOOL CheckRemoteDebuggerPresent(
    HANDLE hProcess,
    PBOOL pbDebuggerPresent
    );

VOID DebugBreak();

BOOL WaitForDebugEvent(
    LPDEBUG_EVENT lpDebugEvent,
    DWORD dwMilliseconds
    );

BOOL ContinueDebugEvent(
    DWORD dwProcessId,
    DWORD dwThreadId,
    DWORD dwContinueStatus
    );

BOOL DebugActiveProcess(
    DWORD dwProcessId
    );

BOOL DebugActiveProcessStop(
    DWORD dwProcessId
    );

BOOL DebugSetProcessKillOnExit(
    BOOL KillOnExit
    );

BOOL DebugBreakProcess (
    HANDLE Process
    );

VOID InitializeCriticalSection(
    LPCRITICAL_SECTION lpCriticalSection
    );

VOID EnterCriticalSection(
    LPCRITICAL_SECTION lpCriticalSection
    );

VOID LeaveCriticalSection(
    LPCRITICAL_SECTION lpCriticalSection
    );

const auto CRITICAL_SECTION_NO_DEBUG_INFO   = RTL_CRITICAL_SECTION_FLAG_NO_DEBUG_INFO;

BOOL InitializeCriticalSectionAndSpinCount(
    LPCRITICAL_SECTION lpCriticalSection,
    DWORD dwSpinCount
    );

BOOL InitializeCriticalSectionEx(
    LPCRITICAL_SECTION lpCriticalSection,
    DWORD dwSpinCount,
    DWORD Flags
    );

DWORD SetCriticalSectionSpinCount(
    LPCRITICAL_SECTION lpCriticalSection,
    DWORD dwSpinCount
    );

BOOL TryEnterCriticalSection(
    LPCRITICAL_SECTION lpCriticalSection
    );

VOID DeleteCriticalSection(
    LPCRITICAL_SECTION lpCriticalSection
    );

BOOL SetEvent(
    HANDLE hEvent
    );

BOOL ResetEvent(
    HANDLE hEvent
    );

BOOL PulseEvent(
    HANDLE hEvent
    );

BOOL ReleaseSemaphore(
    HANDLE hSemaphore,
    LONG lReleaseCount,
    LPLONG lpPreviousCount
    );

BOOL ReleaseMutex(
    HANDLE hMutex
    );

DWORD WaitForSingleObject(
    HANDLE hHandle,
    DWORD dwMilliseconds
    );

DWORD WaitForMultipleObjects(
    DWORD nCount,
    HANDLE *lpHandles,
    BOOL bWaitAll,
    DWORD dwMilliseconds
    );

VOID Sleep(
    DWORD dwMilliseconds
    );


HGLOBAL LoadResource(
    HMODULE hModule,
    HRSRC hResInfo
    );

DWORD SizeofResource(
    HMODULE hModule,
    HRSRC hResInfo
    );


ATOM GlobalDeleteAtom(
    ATOM nAtom
    );

BOOL InitAtomTable(
    DWORD nSize
    );

ATOM DeleteAtom(
    ATOM nAtom
    );

UINT SetHandleCount(
    UINT uNumber
    );

DWORD GetLogicalDrives();

BOOL LockFile(
    HANDLE hFile,
    DWORD dwFileOffsetLow,
    DWORD dwFileOffsetHigh,
    DWORD nNumberOfBytesToLockLow,
    DWORD nNumberOfBytesToLockHigh
    );

BOOL UnlockFile(
    HANDLE hFile,
    DWORD dwFileOffsetLow,
    DWORD dwFileOffsetHigh,
    DWORD nNumberOfBytesToUnlockLow,
    DWORD nNumberOfBytesToUnlockHigh
    );

BOOL LockFileEx(
    HANDLE hFile,
    DWORD dwFlags,
    DWORD dwReserved,
    DWORD nNumberOfBytesToLockLow,
    DWORD nNumberOfBytesToLockHigh,
    LPOVERLAPPED lpOverlapped
    );

const auto LOCKFILE_FAIL_IMMEDIATELY    = 0x00000001;
const auto LOCKFILE_EXCLUSIVE_LOCK      = 0x00000002;

BOOL UnlockFileEx(
    HANDLE hFile,
    DWORD dwReserved,
	DWORD nNumberOfBytesToUnlockLow,
    DWORD nNumberOfBytesToUnlockHigh,
    LPOVERLAPPED lpOverlapped
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

alias BY_HANDLE_FILE_INFORMATION* PBY_HANDLE_FILE_INFORMATION;
alias BY_HANDLE_FILE_INFORMATION* LPBY_HANDLE_FILE_INFORMATION;

BOOL GetFileInformationByHandle(
    HANDLE hFile,
    LPBY_HANDLE_FILE_INFORMATION lpFileInformation
    );

DWORD GetFileType(
    HANDLE hFile
    );

DWORD GetFileSize(
    HANDLE hFile,
    LPDWORD lpFileSizeHigh
    );

BOOL GetFileSizeEx(
    HANDLE hFile,
    PLARGE_INTEGER lpFileSize
    );


HANDLE GetStdHandle(
    DWORD nStdHandle
    );

BOOL SetStdHandle(
    DWORD nStdHandle,
    HANDLE hHandle
    );

BOOL SetStdHandleEx(
	DWORD nStdHandle,
    HANDLE hHandle,
    PHANDLE phPrevValue
    );

BOOL WriteFile(
    HANDLE hFile,
	LPCVOID lpBuffer,
    DWORD nNumberOfBytesToWrite,
	LPDWORD lpNumberOfBytesWritten,
    LPOVERLAPPED lpOverlapped
    );

BOOL ReadFile(
    HANDLE hFile,
    LPVOID lpBuffer,
	DWORD nNumberOfBytesToRead,
	LPDWORD lpNumberOfBytesRead,
    LPOVERLAPPED lpOverlapped
    );

BOOL FlushFileBuffers(
    HANDLE hFile
    );

BOOL DeviceIoControl(
    HANDLE hDevice,
	DWORD dwIoControlCode,
    LPVOID lpInBuffer,
	DWORD nInBufferSize,
    LPVOID lpOutBuffer,
    DWORD nOutBufferSize,
    LPDWORD lpBytesReturned,
    LPOVERLAPPED lpOverlapped
    );

BOOL RequestDeviceWakeup(
    HANDLE hDevice
    );

BOOL CancelDeviceWakeupRequest(
    HANDLE hDevice
    );

BOOL GetDevicePowerState(
    HANDLE hDevice,
    BOOL *pfOn
    );

BOOL SetMessageWaitingIndicator(
    HANDLE hMsgIndicator,
    ULONG ulMsgCount
    );

BOOL SetEndOfFile(
    HANDLE hFile
    );

DWORD SetFilePointer(
    HANDLE hFile,
    LONG lDistanceToMove,
    PLONG lpDistanceToMoveHigh,
    DWORD dwMoveMethod
    );

BOOL SetFilePointerEx(
    HANDLE hFile,
    LARGE_INTEGER liDistanceToMove,
    PLARGE_INTEGER lpNewFilePointer,
    DWORD dwMoveMethod
    );

BOOL FindClose(
    HANDLE hFindFile
    );

BOOL GetFileTime(
    HANDLE hFile,
    LPFILETIME lpCreationTime,
    LPFILETIME lpLastAccessTime,
    LPFILETIME lpLastWriteTime
    );

BOOL SetFileTime(
    HANDLE hFile,
    FILETIME *lpCreationTime,
    FILETIME *lpLastAccessTime,
    FILETIME *lpLastWriteTime
    );

BOOL SetFileValidData(
    HANDLE hFile,
    LONGLONG ValidDataLength
    );

BOOL SetFileShortNameA(
    HANDLE hFile,
    LPCSTR lpShortName
    );

BOOL SetFileShortNameW(
    HANDLE hFile,
    LPCWSTR lpShortName
    );

version(UNICODE) {
	alias SetFileShortNameW SetFileShortName;
}
else {
	alias SetFileShortNameA SetFileShortName;
}

BOOL CloseHandle(
    HANDLE hObject
    );

BOOL DuplicateHandle(
    HANDLE hSourceProcessHandle,
    HANDLE hSourceHandle,
    HANDLE hTargetProcessHandle,
    LPHANDLE lpTargetHandle,
    DWORD dwDesiredAccess,
    BOOL bInheritHandle,
	DWORD dwOptions
    );

BOOL GetHandleInformation(
    HANDLE hObject,
    LPDWORD lpdwFlags
    );

BOOL SetHandleInformation(
    HANDLE hObject,
    DWORD dwMask,
    DWORD dwFlags
    );

const auto HANDLE_FLAG_INHERIT              = 0x00000001;
const auto HANDLE_FLAG_PROTECT_FROM_CLOSE   = 0x00000002;

const auto HINSTANCE_ERROR  = 32;

DWORD LoadModule(
    LPCSTR lpModuleName,
    LPVOID lpParameterBlock
    );


UINT WinExec(
    LPCSTR lpCmdLine,
    UINT uCmdShow
    );

BOOL ClearCommBreak(
    HANDLE hFile
    );

BOOL ClearCommError(
    HANDLE hFile,
    LPDWORD lpErrors,
    LPCOMSTAT lpStat
    );

BOOL SetupComm(
    HANDLE hFile,
    DWORD dwInQueue,
    DWORD dwOutQueue
    );

BOOL EscapeCommFunction(
    HANDLE hFile,
    DWORD dwFunc
    );

BOOL GetCommConfig(
    HANDLE hCommDev,
    LPCOMMCONFIG lpCC,
    LPDWORD lpdwSize
    );

BOOL GetCommMask(
    HANDLE hFile,
    LPDWORD lpEvtMask
    );

BOOL GetCommProperties(
    HANDLE hFile,
    LPCOMMPROP lpCommProp
    );

BOOL GetCommModemStatus(
    HANDLE hFile,
    LPDWORD lpModemStat
    );

BOOL GetCommState(
    HANDLE hFile,
    LPDCB lpDCB
    );

BOOL GetCommTimeouts(
    HANDLE hFile,
    LPCOMMTIMEOUTS lpCommTimeouts
    );

BOOL PurgeComm(
    HANDLE hFile,
    DWORD dwFlags
    );

BOOL SetCommBreak(
    HANDLE hFile
    );

BOOL SetCommConfig(
    HANDLE hCommDev,
    LPCOMMCONFIG lpCC,
    DWORD dwSize
    );

BOOL SetCommMask(
    HANDLE hFile,
    DWORD dwEvtMask
    );

BOOL SetCommState(
    HANDLE hFile,
    LPDCB lpDCB
    );

BOOL SetCommTimeouts(
    HANDLE hFile,
    LPCOMMTIMEOUTS lpCommTimeouts
    );

BOOL TransmitCommChar(
    HANDLE hFile,
    char cChar
    );

BOOL WaitCommEvent(
    HANDLE hFile,
    LPDWORD lpEvtMask,
    LPOVERLAPPED lpOverlapped
    );


DWORD SetTapePosition(
    HANDLE hDevice,
    DWORD dwPositionMethod,
    DWORD dwPartition,
    DWORD dwOffsetLow,
    DWORD dwOffsetHigh,
    BOOL bImmediate
    );

DWORD GetTapePosition(
    HANDLE hDevice,
    DWORD dwPositionType,
    LPDWORD lpdwPartition,
    LPDWORD lpdwOffsetLow,
    LPDWORD lpdwOffsetHigh
    );

DWORD PrepareTape(
    HANDLE hDevice,
    DWORD dwOperation,
    BOOL bImmediate
    );

DWORD EraseTape(
    HANDLE hDevice,
    DWORD dwEraseType,
    BOOL bImmediate
    );

DWORD CreateTapePartition(
    HANDLE hDevice,
    DWORD dwPartitionMethod,
    DWORD dwCount,
    DWORD dwSize
    );

DWORD WriteTapemark(
    HANDLE hDevice,
    DWORD dwTapemarkType,
    DWORD dwTapemarkCount,
    BOOL bImmediate
    );

DWORD GetTapeStatus(
    HANDLE hDevice
    );

DWORD GetTapeParameters(
       HANDLE hDevice,
       DWORD dwOperation,
    LPDWORD lpdwSize,
    LPVOID lpTapeInformation
    );

const auto GET_TAPE_MEDIA_INFORMATION  = 0;
const auto GET_TAPE_DRIVE_INFORMATION  = 1;

DWORD SetTapeParameters(
    HANDLE hDevice,
    DWORD dwOperation,
    LPVOID lpTapeInformation
    );

const auto SET_TAPE_MEDIA_INFORMATION  = 0;
const auto SET_TAPE_DRIVE_INFORMATION  = 1;

BOOL Beep(
    DWORD dwFreq,
    DWORD dwDuration
    );

int MulDiv(
    int nNumber,
    int nNumerator,
    int nDenominator
    );

VOID GetSystemTime(
    LPSYSTEMTIME lpSystemTime
    );

VOID GetSystemTimeAsFileTime(
    LPFILETIME lpSystemTimeAsFileTime
    );

BOOL SetSystemTime(
    SYSTEMTIME *lpSystemTime
    );

VOID GetLocalTime(
    LPSYSTEMTIME lpSystemTime
    );

BOOL SetLocalTime(
    SYSTEMTIME *lpSystemTime
    );

VOID GetSystemInfo(
    LPSYSTEM_INFO lpSystemInfo
    );

BOOL SetSystemFileCacheSize (
    SIZE_T MinimumFileCacheSize,
    SIZE_T MaximumFileCacheSize,
    DWORD Flags
    );

BOOL GetSystemFileCacheSize (
    PSIZE_T lpMinimumFileCacheSize,
    PSIZE_T lpMaximumFileCacheSize,
    PDWORD lpFlags
    );

BOOL GetSystemRegistryQuota(
     PDWORD pdwQuotaAllowed,
     PDWORD pdwQuotaUsed
    );

BOOL GetSystemTimes(
     LPFILETIME lpIdleTime,
     LPFILETIME lpKernelTime,
     LPFILETIME lpUserTime
    );

VOID GetNativeSystemInfo(
    LPSYSTEM_INFO lpSystemInfo
    );

BOOL IsProcessorFeaturePresent(
    DWORD ProcessorFeature
    );

struct TIME_ZONE_INFORMATION {
    LONG Bias;
    WCHAR[32] StandardName;
    SYSTEMTIME StandardDate;
    LONG StandardBias;
    WCHAR[32] DaylightName;
    SYSTEMTIME DaylightDate;
    LONG DaylightBias;
}

alias TIME_ZONE_INFORMATION* PTIME_ZONE_INFORMATION;
alias TIME_ZONE_INFORMATION* LPTIME_ZONE_INFORMATION;

struct DYNAMIC_TIME_ZONE_INFORMATION {
    LONG Bias;
    WCHAR[32] StandardName;
    SYSTEMTIME StandardDate;
    LONG StandardBias;
    WCHAR[32] DaylightName;
    SYSTEMTIME DaylightDate;
    LONG DaylightBias;
    WCHAR[128] TimeZoneKeyName;
    BOOLEAN DynamicDaylightTimeDisabled;
}

alias DYNAMIC_TIME_ZONE_INFORMATION* PDYNAMIC_TIME_ZONE_INFORMATION;

BOOL SystemTimeToTzSpecificLocalTime(
    TIME_ZONE_INFORMATION *lpTimeZoneInformation,
        SYSTEMTIME *lpUniversalTime,
       LPSYSTEMTIME lpLocalTime
    );

BOOL TzSpecificLocalTimeToSystemTime(
    TIME_ZONE_INFORMATION *lpTimeZoneInformation,
        SYSTEMTIME *lpLocalTime,
       LPSYSTEMTIME lpUniversalTime
    );

DWORD GetTimeZoneInformation(
    LPTIME_ZONE_INFORMATION lpTimeZoneInformation
    );

BOOL SetTimeZoneInformation(
    TIME_ZONE_INFORMATION *lpTimeZoneInformation
    );

DWORD GetDynamicTimeZoneInformation(
    PDYNAMIC_TIME_ZONE_INFORMATION pTimeZoneInformation
    );

BOOL SetDynamicTimeZoneInformation(
    DYNAMIC_TIME_ZONE_INFORMATION *lpTimeZoneInformation
    );



//
// Routines to convert back and forth between system time and file time
//

BOOL SystemTimeToFileTime(
    SYSTEMTIME *lpSystemTime,
    LPFILETIME lpFileTime
    );

BOOL FileTimeToLocalFileTime(
    FILETIME *lpFileTime,
    LPFILETIME lpLocalFileTime
    );

BOOL LocalFileTimeToFileTime(
    FILETIME *lpLocalFileTime,
    LPFILETIME lpFileTime
    );

BOOL FileTimeToSystemTime(
    FILETIME *lpFileTime,
    LPSYSTEMTIME lpSystemTime
    );

LONG CompareFileTime(
    FILETIME *lpFileTime1,
    FILETIME *lpFileTime2
    );

BOOL FileTimeToDosDateTime(
    FILETIME *lpFileTime,
    LPWORD lpFatDate,
    LPWORD lpFatTime
    );

BOOL DosDateTimeToFileTime(
    WORD wFatDate,
    WORD wFatTime,
    LPFILETIME lpFileTime
    );

DWORD GetTickCount();

ULONGLONG GetTickCount64();

BOOL SetSystemTimeAdjustment(
    DWORD dwTimeAdjustment,
    BOOL  bTimeAdjustmentDisabled
    );

BOOL GetSystemTimeAdjustment(
    PDWORD lpTimeAdjustment,
    PDWORD lpTimeIncrement,
    PBOOL  lpTimeAdjustmentDisabled
    );

// #if !defined(MIDL_PASS)
// DWORD
// FormatMessageA(
//         DWORD dwFlags,
//     LPCVOID lpSource,
//         DWORD dwMessageId,
//         DWORD dwLanguageId,
//        LPSTR lpBuffer,
//         DWORD nSize,
//     va_list *Arguments
//     );
// DWORD
// FormatMessageW(
//         DWORD dwFlags,
//     LPCVOID lpSource,
//         DWORD dwMessageId,
//         DWORD dwLanguageId,
//        LPWSTR lpBuffer,
//         DWORD nSize,
//     va_list *Arguments
//     );
// 
/*version(UNICODE) {
	alias FormatMessageW FormatMessage;
}
else {
	alias FormatMessageA FormatMessage;
}*/

const auto FORMAT_MESSAGE_ALLOCATE_BUFFER  = 0x00000100;
const auto FORMAT_MESSAGE_IGNORE_INSERTS   = 0x00000200;
const auto FORMAT_MESSAGE_FROM_STRING      = 0x00000400;
const auto FORMAT_MESSAGE_FROM_HMODULE     = 0x00000800;
const auto FORMAT_MESSAGE_FROM_SYSTEM      = 0x00001000;
const auto FORMAT_MESSAGE_ARGUMENT_ARRAY   = 0x00002000;
const auto FORMAT_MESSAGE_MAX_WIDTH_MASK   = 0x000000FF;

BOOL CreatePipe(
    PHANDLE hReadPipe,
    PHANDLE hWritePipe,
    LPSECURITY_ATTRIBUTES lpPipeAttributes,
    DWORD nSize
    );

BOOL ConnectNamedPipe(
    HANDLE hNamedPipe,
    LPOVERLAPPED lpOverlapped
    );

BOOL DisconnectNamedPipe(
    HANDLE hNamedPipe
    );

BOOL SetNamedPipeHandleState(
    HANDLE hNamedPipe,
    LPDWORD lpMode,
    LPDWORD lpMaxCollectionCount,
    LPDWORD lpCollectDataTimeout
    );

BOOL GetNamedPipeInfo(
    HANDLE hNamedPipe,
    LPDWORD lpFlags,
    LPDWORD lpOutBufferSize,
    LPDWORD lpInBufferSize,
    LPDWORD lpMaxInstances
    );

BOOL PeekNamedPipe(
    HANDLE hNamedPipe,
    LPVOID lpBuffer,
    DWORD nBufferSize,
    LPDWORD lpBytesRead,
    LPDWORD lpTotalBytesAvail,
    LPDWORD lpBytesLeftThisMessage
    );

BOOL TransactNamedPipe(
    HANDLE hNamedPipe,
    LPVOID lpInBuffer,
    DWORD nInBufferSize,
    LPVOID lpOutBuffer,
    DWORD nOutBufferSize,
    LPDWORD lpBytesRead,
    LPOVERLAPPED lpOverlapped
    );


HANDLE CreateMailslotA(
    LPCSTR lpName,
    DWORD nMaxMessageSize,
    DWORD lReadTimeout,
    LPSECURITY_ATTRIBUTES lpSecurityAttributes
    );

HANDLE CreateMailslotW(
    LPCWSTR lpName,
    DWORD nMaxMessageSize,
    DWORD lReadTimeout,
    LPSECURITY_ATTRIBUTES lpSecurityAttributes
    );

version(UNICODE) {
	alias CreateMailslotW CreateMailslot;
}
else {
	alias CreateMailslotA CreateMailslot;
}

BOOL GetMailslotInfo(
    HANDLE hMailslot,
    LPDWORD lpMaxMessageSize,
    LPDWORD lpNextSize,
    LPDWORD lpMessageCount,
    LPDWORD lpReadTimeout
    );

BOOL SetMailslotInfo(
    HANDLE hMailslot,
    DWORD lReadTimeout
    );

LPVOID MapViewOfFile(
    HANDLE hFileMappingObject,
    DWORD dwDesiredAccess,
    DWORD dwFileOffsetHigh,
    DWORD dwFileOffsetLow,
    SIZE_T dwNumberOfBytesToMap
    );

BOOL FlushViewOfFile(
    LPCVOID lpBaseAddress,
    SIZE_T dwNumberOfBytesToFlush
    );

BOOL UnmapViewOfFile(
    LPCVOID lpBaseAddress
    );

//
// File Encryption API
//

BOOL EncryptFileA(
    LPCSTR lpFileName
    );

BOOL EncryptFileW(
    LPCWSTR lpFileName
    );

version(UNICODE) {
	alias EncryptFileW EncryptFile;
}
else {
	alias EncryptFileA EncryptFile;
}

BOOL DecryptFileA(
    LPCSTR lpFileName,
    DWORD dwReserved
    );

BOOL DecryptFileW(
    LPCWSTR lpFileName,
    DWORD dwReserved
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


BOOL FileEncryptionStatusA(
    LPCSTR lpFileName,
    LPDWORD  lpStatus
    );

BOOL FileEncryptionStatusW(
    LPCWSTR lpFileName,
    LPDWORD  lpStatus
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

alias DWORD function(PBYTE pbData, PVOID pvCallbackContext, ULONG ulLength) PFE_EXPORT_FUNC;
alias DWORD function(PBYTE pbData, PVOID pvCallbackContext, PULONG ulLength) PFE_IMPORT_FUNC;

//
//  OpenRaw flag values
//

const auto CREATE_FOR_IMPORT   = (1);
const auto CREATE_FOR_DIR      = (2);
const auto OVERWRITE_HIDDEN    = (4);
const auto EFSRPC_SECURE_ONLY  = (8);


DWORD OpenEncryptedFileRawA(
    LPCSTR lpFileName,
    ULONG    ulFlags,
    PVOID   *pvContext
    );

DWORD OpenEncryptedFileRawW(
    LPCWSTR lpFileName,
    ULONG    ulFlags,
    PVOID   *pvContext
    );

version(UNICODE) {
	alias OpenEncryptedFileRawW OpenEncryptedFileRaw;
}
else {
	alias OpenEncryptedFileRawA OpenEncryptedFileRaw;
}


DWORD ReadEncryptedFileRaw(
	PFE_EXPORT_FUNC pfExportCallback,
    PVOID           pvCallbackContext,
    PVOID           pvContext
    );

DWORD WriteEncryptedFileRaw(
	PFE_IMPORT_FUNC pfImportCallback,
    PVOID           pvCallbackContext,
    PVOID           pvContext
    );

VOID CloseEncryptedFileRaw(
    PVOID           pvContext
    );

//
// _l Compat Functions
//

int lstrcmpA(
    LPCSTR lpString1,
    LPCSTR lpString2
    );

int lstrcmpW(
    LPCWSTR lpString1,
    LPCWSTR lpString2
    );

version(UNICODE) {
	alias lstrcmpW lstrcmp;
}
else {
	alias lstrcmpA lstrcmp;
}

int lstrcmpiA(
    LPCSTR lpString1,
    LPCSTR lpString2
    );

int lstrcmpiW(
    LPCWSTR lpString1,
    LPCWSTR lpString2
    );

version(UNICODE) {
	alias lstrcmpiW lstrcmpi;
}
else {
	alias lstrcmpiA lstrcmpi;
}

LPSTR lstrcpynA(
    LPSTR lpString1,
    LPCSTR lpString2,
    int iMaxLength
    );

LPWSTR lstrcpynW(
    LPWSTR lpString1,
    LPCWSTR lpString2,
    int iMaxLength
    );

version(UNICODE) {
	alias lstrcpynW lstrcpyn;
}
else {
	alias lstrcpynA lstrcpyn;
}

LPSTR lstrcpyA(
    LPSTR lpString1,
    LPCSTR lpString2
    );

LPWSTR lstrcpyW(
    LPWSTR lpString1,
    LPCWSTR lpString2
    );

version(UNICODE) {
	alias lstrcpyW lstrcpy;
}
else {
	alias lstrcpyA lstrcpy;
}


LPSTR lstrcatA(
    LPSTR lpString1,
    LPCSTR lpString2
    );

LPWSTR lstrcatW(
    LPWSTR lpString1,
    LPCWSTR lpString2
    );

version(UNICODE) {
	alias lstrcatW lstrcat;
}
else {
	alias lstrcatA lstrcat;
}

int lstrlenA(
    LPCSTR lpString
    );
int lstrlenW(
    LPCWSTR lpString
    );

version(UNICODE) {
	alias lstrlenW lstrlen;
}
else {
	alias lstrlenA lstrlen;
}

HFILE OpenFile(
    LPCSTR lpFileName,
    LPOFSTRUCT lpReOpenBuff,
    UINT uStyle
    );

HFILE _lopen(
    LPCSTR lpPathName,
    int iReadWrite
    );

HFILE _lcreat(
    LPCSTR lpPathName,
    int  iAttribute
    );

UINT _lread(
    HFILE hFile,
    LPVOID lpBuffer,
    UINT uBytes
    );

UINT _lwrite(
    HFILE hFile,
    LPCCH lpBuffer,
    UINT uBytes
    );

Clong_t _hread(
    HFILE hFile,
    LPVOID lpBuffer,
    Clong_t lBytes
    );

Clong_t _hwrite(
    HFILE hFile,
    LPCCH lpBuffer,
    Clong_t lBytes
    );

HFILE _lclose(
    HFILE hFile
    );

LONG _llseek(
    HFILE hFile,
    LONG lOffset,
    int iOrigin
    );


BOOL IsTextUnicode(
    VOID* lpv,
	int iSize,
    LPINT lpiResult
    );

const auto FLS_OUT_OF_INDEXES  = (cast(DWORD)0xFFFFFFFF);

DWORD FlsAlloc(
    PFLS_CALLBACK_FUNCTION lpCallback
    );

PVOID FlsGetValue(
    DWORD dwFlsIndex
    );

BOOL FlsSetValue(
    DWORD dwFlsIndex,
    PVOID lpFlsData
    );

BOOL FlsFree(
    DWORD dwFlsIndex
    );

const auto TLS_OUT_OF_INDEXES  = (cast(DWORD)0xFFFFFFFF);

DWORD TlsAlloc();

LPVOID TlsGetValue(
    DWORD dwTlsIndex
    );

BOOL TlsSetValue(
    DWORD dwTlsIndex,
    LPVOID lpTlsValue
    );

BOOL TlsFree(
    DWORD dwTlsIndex
    );

alias VOID function(DWORD dwErrorCode, DWORD dwNumberOfBytesTransfered, LPOVERLAPPED lpOverlapped) LPOVERLAPPED_COMPLETION_ROUTINE;

DWORD SleepEx(
    DWORD dwMilliseconds,
    BOOL bAlertable
    );

DWORD WaitForSingleObjectEx(
    HANDLE hHandle,
    DWORD dwMilliseconds,
    BOOL bAlertable
    );

DWORD WaitForMultipleObjectsEx(
    DWORD nCount,
    HANDLE *lpHandles,
    BOOL bWaitAll,
    DWORD dwMilliseconds,
    BOOL bAlertable
    );

DWORD SignalObjectAndWait(
    HANDLE hObjectToSignal,
    HANDLE hObjectToWaitOn,
    DWORD dwMilliseconds,
    BOOL bAlertable
    );

BOOL ReadFileEx(
    HANDLE hFile,
    LPVOID lpBuffer,
	DWORD nNumberOfBytesToRead,
    LPOVERLAPPED lpOverlapped,
    LPOVERLAPPED_COMPLETION_ROUTINE lpCompletionRoutine
    );

BOOL WriteFileEx(
    HANDLE hFile,
    LPCVOID lpBuffer,
	DWORD nNumberOfBytesToWrite,
    LPOVERLAPPED lpOverlapped,
    LPOVERLAPPED_COMPLETION_ROUTINE lpCompletionRoutine
    );

BOOL BackupRead(
    HANDLE hFile,
    LPBYTE lpBuffer,
    DWORD nNumberOfBytesToRead,
    LPDWORD lpNumberOfBytesRead,
	BOOL bAbort,
    BOOL bProcessSecurity,
    LPVOID *lpContext
    );

BOOL BackupSeek(
    HANDLE hFile,
    DWORD  dwLowBytesToSeek,
    DWORD  dwHighBytesToSeek,
    LPDWORD lpdwLowByteSeeked,
    LPDWORD lpdwHighByteSeeked,
    LPVOID *lpContext
    );

BOOL BackupWrite(
    HANDLE hFile,
    LPBYTE lpBuffer,
    DWORD nNumberOfBytesToWrite,
    LPDWORD lpNumberOfBytesWritten,
    BOOL bAbort,
    BOOL bProcessSecurity,
    LPVOID *lpContext
    );

//
//  Stream id structure
//
struct WIN32_STREAM_ID {
        DWORD          dwStreamId ;
        DWORD          dwStreamAttributes ;
        LARGE_INTEGER  Size ;
        DWORD          dwStreamNameSize ;
        WCHAR[]        cStreamName;
}

alias WIN32_STREAM_ID* LPWIN32_STREAM_ID ;

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

BOOL ReadFileScatter(
    HANDLE hFile,
    FILE_SEGMENT_ELEMENT aSegmentArray[],
    DWORD nNumberOfBytesToRead,
    LPDWORD lpReserved,
    LPOVERLAPPED lpOverlapped
    );

BOOL WriteFileGather(
    HANDLE hFile,
    FILE_SEGMENT_ELEMENT aSegmentArray[],
    DWORD nNumberOfBytesToWrite,
    LPDWORD lpReserved,
    LPOVERLAPPED lpOverlapped
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

const auto STARTF_USEHOTKEY         = 0x00000200;

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

alias STARTUPINFOA* LPSTARTUPINFOA;
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

alias STARTUPINFOW* LPSTARTUPINFOW;

version(UNICODE) {
	alias STARTUPINFOW STARTUPINFO;
	alias LPSTARTUPINFOW LPSTARTUPINFO;
}
else {
	alias STARTUPINFOA STARTUPINFO;
	alias LPSTARTUPINFOA LPSTARTUPINFO;
}

alias LPVOID PROC_THREAD_ATTRIBUTE_LIST;

struct STARTUPINFOEXA {
    STARTUPINFOA StartupInfo;
    PROC_THREAD_ATTRIBUTE_LIST *lpAttributeList;
}

alias STARTUPINFOEXA* LPSTARTUPINFOEXA;
struct STARTUPINFOEXW {
    STARTUPINFOW StartupInfo;
    PROC_THREAD_ATTRIBUTE_LIST *lpAttributeList;
}

alias STARTUPINFOEXW* LPSTARTUPINFOEXW;

version(UNICODE) {
	alias STARTUPINFOEXW STARTUPINFOEX;
	alias LPSTARTUPINFOEXW LPSTARTUPINFOEX;
}
else {
	alias STARTUPINFOEXA STARTUPINFOEX;
	alias LPSTARTUPINFOEXA LPSTARTUPINFOEX;
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
}

alias WIN32_FIND_DATAA* PWIN32_FIND_DATAA;
alias WIN32_FIND_DATAA* LPWIN32_FIND_DATAA;
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
}

alias WIN32_FIND_DATAW* PWIN32_FIND_DATAW;
alias WIN32_FIND_DATAW* LPWIN32_FIND_DATAW;

version(UNICODE) {
	alias WIN32_FIND_DATAW WIN32_FIND_DATA;
	alias PWIN32_FIND_DATAW PWIN32_FIND_DATA;
	alias LPWIN32_FIND_DATAW LPWIN32_FIND_DATA;
}
else {
	alias WIN32_FIND_DATAA WIN32_FIND_DATA;
	alias PWIN32_FIND_DATAA PWIN32_FIND_DATA;
	alias LPWIN32_FIND_DATAA LPWIN32_FIND_DATA;
}

struct WIN32_FILE_ATTRIBUTE_DATA {
    DWORD dwFileAttributes;
    FILETIME ftCreationTime;
    FILETIME ftLastAccessTime;
    FILETIME ftLastWriteTime;
    DWORD nFileSizeHigh;
    DWORD nFileSizeLow;
}

alias WIN32_FILE_ATTRIBUTE_DATA* LPWIN32_FILE_ATTRIBUTE_DATA;

//
// Synchronization APIs
//


HANDLE CreateMutexA(
    LPSECURITY_ATTRIBUTES lpMutexAttributes,
	BOOL bInitialOwner,
    LPCSTR lpName
    );

HANDLE CreateMutexW(
    LPSECURITY_ATTRIBUTES lpMutexAttributes,
    BOOL bInitialOwner,
    LPCWSTR lpName
    );

version(UNICODE) {
	alias CreateMutexW CreateMutex;
}
else {
	alias CreateMutexA CreateMutex;
}


HANDLE OpenMutexA(
    DWORD dwDesiredAccess,
    BOOL bInheritHandle,
    LPCSTR lpName
    );

HANDLE OpenMutexW(
    DWORD dwDesiredAccess,
    BOOL bInheritHandle,
    LPCWSTR lpName
    );

version(UNICODE) {
	alias OpenMutexW OpenMutex;
}
else {
	alias OpenMutexA OpenMutex;
}

HANDLE CreateEventA(
    LPSECURITY_ATTRIBUTES lpEventAttributes,
    BOOL bManualReset,
    BOOL bInitialState,
    LPCSTR lpName
    );

HANDLE
CreateEventW(
    LPSECURITY_ATTRIBUTES lpEventAttributes,
        BOOL bManualReset,
        BOOL bInitialState,
    LPCWSTR lpName
    );

version(UNICODE) {
	alias CreateEventW CreateEvent;
}
else {
	alias CreateEventA CreateEvent;
}


HANDLE
OpenEventA(
    DWORD dwDesiredAccess,
    BOOL bInheritHandle,
    LPCSTR lpName
    );

HANDLE
OpenEventW(
    DWORD dwDesiredAccess,
    BOOL bInheritHandle,
    LPCWSTR lpName
    );

version(UNICODE) {
	alias OpenEventW OpenEvent;
}
else {
	alias OpenEventA OpenEvent;
}


HANDLE
CreateSemaphoreA(
    LPSECURITY_ATTRIBUTES lpSemaphoreAttributes,
        LONG lInitialCount,
        LONG lMaximumCount,
    LPCSTR lpName
    );

HANDLE
CreateSemaphoreW(
    LPSECURITY_ATTRIBUTES lpSemaphoreAttributes,
        LONG lInitialCount,
        LONG lMaximumCount,
    LPCWSTR lpName
    );

version(UNICODE) {
	alias CreateSemaphoreW CreateSemaphore;
}
else {
	alias CreateSemaphoreA CreateSemaphore;
}


HANDLE
OpenSemaphoreA(
    DWORD dwDesiredAccess,
    BOOL bInheritHandle,
    LPCSTR lpName
    );

HANDLE
OpenSemaphoreW(
    DWORD dwDesiredAccess,
    BOOL bInheritHandle,
    LPCWSTR lpName
    );

version(UNICODE) {
	alias OpenSemaphoreW OpenSemaphore;
}
else {
	alias OpenSemaphoreA OpenSemaphore;
}

alias VOID function(LPVOID lpArgToCompletionRoutine, DWORD dwTimerLowValue, DWORD dwTimerHighValue) PTIMERAPCROUTINE;

HANDLE
CreateWaitableTimerA(
    LPSECURITY_ATTRIBUTES lpTimerAttributes,
        BOOL bManualReset,
    LPCSTR lpTimerName
    );

HANDLE
CreateWaitableTimerW(
    LPSECURITY_ATTRIBUTES lpTimerAttributes,
        BOOL bManualReset,
    LPCWSTR lpTimerName
    );

version(UNICODE) {
	alias CreateWaitableTimerW CreateWaitableTimer;
}
else {
	alias CreateWaitableTimerA CreateWaitableTimer;
}


HANDLE
OpenWaitableTimerA(
    DWORD dwDesiredAccess,
    BOOL bInheritHandle,
    LPCSTR lpTimerName
    );

HANDLE
OpenWaitableTimerW(
    DWORD dwDesiredAccess,
    BOOL bInheritHandle,
    LPCWSTR lpTimerName
    );

version(UNICODE) {
	alias OpenWaitableTimerW OpenWaitableTimer;
}
else {
	alias OpenWaitableTimerA OpenWaitableTimer;
}

BOOL
SetWaitableTimer(
        HANDLE hTimer,
        LARGE_INTEGER *lpDueTime,
        LONG lPeriod,
    PTIMERAPCROUTINE pfnCompletionRoutine,
    LPVOID lpArgToCompletionRoutine,
        BOOL fResume
    );

BOOL
CancelWaitableTimer(
    HANDLE hTimer
    );

const auto CREATE_MUTEX_INITIAL_OWNER   = 0x00000001;

HANDLE
CreateMutexExA(
    LPSECURITY_ATTRIBUTES lpMutexAttributes,
    LPCSTR lpName,
        DWORD dwFlags,
        DWORD dwDesiredAccess
    );

HANDLE
CreateMutexExW(
    LPSECURITY_ATTRIBUTES lpMutexAttributes,
    LPCWSTR lpName,
        DWORD dwFlags,
        DWORD dwDesiredAccess
    );

version(UNICODE) {
	alias CreateMutexExW CreateMutexEx;
}
else {
	alias CreateMutexExA CreateMutexEx;
}

const auto CREATE_EVENT_MANUAL_RESET    = 0x00000001;
const auto CREATE_EVENT_INITIAL_SET     = 0x00000002;


HANDLE
CreateEventExA(
    LPSECURITY_ATTRIBUTES lpEventAttributes,
    LPCSTR lpName,
        DWORD dwFlags,
        DWORD dwDesiredAccess
    );

HANDLE
CreateEventExW(
    LPSECURITY_ATTRIBUTES lpEventAttributes,
    LPCWSTR lpName,
        DWORD dwFlags,
        DWORD dwDesiredAccess
    );

version(UNICODE) {
	alias CreateEventExW CreateEventEx;
}
else {
	alias CreateEventExA CreateEventEx;
}


HANDLE
CreateSemaphoreExA(
       LPSECURITY_ATTRIBUTES lpSemaphoreAttributes,
           LONG lInitialCount,
           LONG lMaximumCount,
       LPCSTR lpName,
     DWORD dwFlags,
           DWORD dwDesiredAccess
    );

HANDLE
CreateSemaphoreExW(
       LPSECURITY_ATTRIBUTES lpSemaphoreAttributes,
           LONG lInitialCount,
           LONG lMaximumCount,
       LPCWSTR lpName,
     DWORD dwFlags,
           DWORD dwDesiredAccess
    );

version(UNICODE) {
	alias CreateSemaphoreExW CreateSemaphoreEx;
}
else {
	alias CreateSemaphoreExA CreateSemaphoreEx;
}

const auto CREATE_WAITABLE_TIMER_MANUAL_RESET   = 0x00000001;


HANDLE
CreateWaitableTimerExA(
    LPSECURITY_ATTRIBUTES lpTimerAttributes,
    LPCSTR lpTimerName,
        DWORD dwFlags,
        DWORD dwDesiredAccess
    );

HANDLE
CreateWaitableTimerExW(
    LPSECURITY_ATTRIBUTES lpTimerAttributes,
    LPCWSTR lpTimerName,
        DWORD dwFlags,
        DWORD dwDesiredAccess
    );

version(UNICODE) {
	alias CreateWaitableTimerExW CreateWaitableTimerEx;
}
else {
	alias CreateWaitableTimerExA CreateWaitableTimerEx;
}



HANDLE
CreateFileMappingA(
        HANDLE hFile,
    LPSECURITY_ATTRIBUTES lpFileMappingAttributes,
        DWORD flProtect,
        DWORD dwMaximumSizeHigh,
        DWORD dwMaximumSizeLow,
    LPCSTR lpName
    );

HANDLE
CreateFileMappingW(
        HANDLE hFile,
    LPSECURITY_ATTRIBUTES lpFileMappingAttributes,
        DWORD flProtect,
        DWORD dwMaximumSizeHigh,
        DWORD dwMaximumSizeLow,
    LPCWSTR lpName
    );

version(UNICODE) {
	alias CreateFileMappingW CreateFileMapping;
}
else {
	alias CreateFileMappingA CreateFileMapping;
}

HANDLE
CreateFileMappingNumaA(
        HANDLE hFile,
    LPSECURITY_ATTRIBUTES lpFileMappingAttributes,
        DWORD flProtect,
        DWORD dwMaximumSizeHigh,
        DWORD dwMaximumSizeLow,
    LPCSTR lpName,
        DWORD nndPreferred
    );

HANDLE
CreateFileMappingNumaW(
        HANDLE hFile,
    LPSECURITY_ATTRIBUTES lpFileMappingAttributes,
        DWORD flProtect,
        DWORD dwMaximumSizeHigh,
        DWORD dwMaximumSizeLow,
    LPCWSTR lpName,
        DWORD nndPreferred
    );

version(UNICODE) {
	alias CreateFileMappingNumaW CreateFileMappingNuma;
}
else {
	alias CreateFileMappingNumaA CreateFileMappingNuma;
}


HANDLE
OpenFileMappingA(
    DWORD dwDesiredAccess,
    BOOL bInheritHandle,
    LPCSTR lpName
    );

HANDLE
OpenFileMappingW(
    DWORD dwDesiredAccess,
    BOOL bInheritHandle,
    LPCWSTR lpName
    );

version(UNICODE) {
	alias OpenFileMappingW OpenFileMapping;
}
else {
	alias OpenFileMappingA OpenFileMapping;
}

DWORD
GetLogicalDriveStringsA(
    DWORD nBufferLength,
    LPSTR lpBuffer
    );
DWORD
GetLogicalDriveStringsW(
    DWORD nBufferLength,
    LPWSTR lpBuffer
    );

version(UNICODE) {
	alias GetLogicalDriveStringsW GetLogicalDriveStrings;
}
else {
	alias GetLogicalDriveStringsA GetLogicalDriveStrings;
}

enum MEMORY_RESOURCE_NOTIFICATION_TYPE {
    LowMemoryResourceNotification,
    HighMemoryResourceNotification
}


HANDLE
CreateMemoryResourceNotification(
    MEMORY_RESOURCE_NOTIFICATION_TYPE NotificationType
    );

BOOL
QueryMemoryResourceNotification(
     HANDLE ResourceNotificationHandle,
    PBOOL  ResourceState
    );




HMODULE
LoadLibraryA(
    LPCSTR lpLibFileName
    );

HMODULE
LoadLibraryW(
    LPCWSTR lpLibFileName
    );

version(UNICODE) {
	alias LoadLibraryW LoadLibrary;
}
else {
	alias LoadLibraryA LoadLibrary;
}


HMODULE
LoadLibraryExA(
          LPCSTR lpLibFileName,
    HANDLE hFile,
          DWORD dwFlags
    );

HMODULE
LoadLibraryExW(
          LPCWSTR lpLibFileName,
    HANDLE hFile,
          DWORD dwFlags
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
    HMODULE hModule,
    LPCH lpFilename,
        DWORD nSize
    );
DWORD
GetModuleFileNameW(
    HMODULE hModule,
    LPWCH lpFilename,
        DWORD nSize
    );

version(UNICODE) {
	alias GetModuleFileNameW GetModuleFileName;
}
else {
	alias GetModuleFileNameA GetModuleFileName;
}


HMODULE
GetModuleHandleA(
    LPCSTR lpModuleName
    );

HMODULE
GetModuleHandleW(
    LPCWSTR lpModuleName
    );

version(UNICODE) {
	alias GetModuleHandleW GetModuleHandle;
}
else {
	alias GetModuleHandleA GetModuleHandle;
}

const auto GET_MODULE_HANDLE_EX_FLAG_PIN                  = (0x00000001);
const auto GET_MODULE_HANDLE_EX_FLAG_UNCHANGED_REFCOUNT   = (0x00000002);
const auto GET_MODULE_HANDLE_EX_FLAG_FROM_ADDRESS         = (0x00000004);

alias BOOL function(DWORD dwFlags, LPCSTR lpModuleName, HMODULE* phModule) PGET_MODULE_HANDLE_EXA;

alias BOOL function(DWORD dwFlags, LPCWSTR lpModuleName, HMODULE* phModule) PGET_MODULE_HANDLE_EXW;

version(UNICODE) {
	alias PGET_MODULE_HANDLE_EXW PGET_MODULE_HANDLE_EX;
}
else {
	alias PGET_MODULE_HANDLE_EXA PGET_MODULE_HANDLE_EX;
}

BOOL
GetModuleHandleExA(
           DWORD    dwFlags,
       LPCSTR lpModuleName,
    HMODULE* phModule
    );
BOOL
GetModuleHandleExW(
           DWORD    dwFlags,
       LPCWSTR lpModuleName,
    HMODULE* phModule
    );

version(UNICODE) {
	alias GetModuleHandleExW GetModuleHandleEx;
}
else {
	alias GetModuleHandleExA GetModuleHandleEx;
}

BOOL
NeedCurrentDirectoryForExePathA(
    LPCSTR ExeName
    );
BOOL
NeedCurrentDirectoryForExePathW(
    LPCWSTR ExeName
    );

version(UNICODE) {
	alias NeedCurrentDirectoryForExePathW NeedCurrentDirectoryForExePath;
}
else {
	alias NeedCurrentDirectoryForExePathA NeedCurrentDirectoryForExePath;
}

const auto PROCESS_NAME_NATIVE      = 0x00000001;

BOOL
QueryFullProcessImageNameA(
    HANDLE hProcess,
    DWORD dwFlags,
    LPSTR lpExeName,
    PDWORD lpdwSize
    );
BOOL
QueryFullProcessImageNameW(
    HANDLE hProcess,
    DWORD dwFlags,
	LPWSTR lpExeName,
    PDWORD lpdwSize
    );

version(UNICODE) {
	alias QueryFullProcessImageNameW QueryFullProcessImageName;
}
else {
	alias QueryFullProcessImageNameA QueryFullProcessImageName;
}


//
// Extended process and thread attribute support
//

const auto PROC_THREAD_ATTRIBUTE_NUMBER     = 0x0000FFFF;
const auto PROC_THREAD_ATTRIBUTE_THREAD     = 0x00010000  ; // Attribute may be used with thread creation
const auto PROC_THREAD_ATTRIBUTE_INPUT      = 0x00020000  ; // Attribute is input only
const auto PROC_THREAD_ATTRIBUTE_ADDITIVE   = 0x00040000  ; // Attribute may be "accumulated," e.g. bitmasks, counters, etc.

enum PROC_THREAD_ATTRIBUTE_NUM {
    ProcThreadAttributeParentProcess = 0,
    ProcThreadAttributeExtendedFlags,
    ProcThreadAttributeHandleList,
    ProcThreadAttributeMax
}

/*const auto ProcThreadAttributeValue(Number,  = Thread, Input, Additive) \;
    (((Number) & PROC_THREAD_ATTRIBUTE_NUMBER) | \
     ((Thread != FALSE) ? PROC_THREAD_ATTRIBUTE_THREAD : 0) | \
     ((Input != FALSE) ? PROC_THREAD_ATTRIBUTE_INPUT : 0) | \
     ((Additive != FALSE) ? PROC_THREAD_ATTRIBUTE_ADDITIVE : 0))
*/

/*const auto PROC_THREAD_ATTRIBUTE_PARENT_PROCESS  = \;
    ProcThreadAttributeValue (ProcThreadAttributeParentProcess, FALSE, TRUE, FALSE)
const auto PROC_THREAD_ATTRIBUTE_EXTENDED_FLAGS  = \;
    ProcThreadAttributeValue (ProcThreadAttributeExtendedFlags, FALSE, TRUE, TRUE)
const auto PROC_THREAD_ATTRIBUTE_HANDLE_LIST  = \;
    ProcThreadAttributeValue (ProcThreadAttributeHandleList, FALSE, TRUE, FALSE)
*/

alias PROC_THREAD_ATTRIBUTE_LIST *PPROC_THREAD_ATTRIBUTE_LIST;
alias PROC_THREAD_ATTRIBUTE_LIST *LPPROC_THREAD_ATTRIBUTE_LIST;


BOOL
InitializeProcThreadAttributeList(
    LPPROC_THREAD_ATTRIBUTE_LIST lpAttributeList,
    DWORD dwAttributeCount,
    DWORD dwFlags,
    PSIZE_T lpSize
    );

VOID
DeleteProcThreadAttributeList(
    LPPROC_THREAD_ATTRIBUTE_LIST lpAttributeList
    );

const auto PROC_THREAD_ATTRIBUTE_REPLACE_VALUE      = 0x00000001;

BOOL
UpdateProcThreadAttribute(
    LPPROC_THREAD_ATTRIBUTE_LIST lpAttributeList,
    DWORD dwFlags,
    DWORD_PTR Attribute,
    PVOID lpValue,
    SIZE_T cbSize,
    PVOID lpPreviousValue,
    PSIZE_T lpReturnSize
    );


BOOL
CreateProcessA(
       LPCSTR lpApplicationName,
    LPSTR lpCommandLine,
       LPSECURITY_ATTRIBUTES lpProcessAttributes,
       LPSECURITY_ATTRIBUTES lpThreadAttributes,
           BOOL bInheritHandles,
           DWORD dwCreationFlags,
       LPVOID lpEnvironment,
       LPCSTR lpCurrentDirectory,
           LPSTARTUPINFOA lpStartupInfo,
          LPPROCESS_INFORMATION lpProcessInformation
    );
BOOL
CreateProcessW(
       LPCWSTR lpApplicationName,
    LPWSTR lpCommandLine,
       LPSECURITY_ATTRIBUTES lpProcessAttributes,
       LPSECURITY_ATTRIBUTES lpThreadAttributes,
           BOOL bInheritHandles,
           DWORD dwCreationFlags,
       LPVOID lpEnvironment,
       LPCWSTR lpCurrentDirectory,
           LPSTARTUPINFOW lpStartupInfo,
          LPPROCESS_INFORMATION lpProcessInformation
    );

version(UNICODE) {
	alias CreateProcessW CreateProcess;
}
else {
	alias CreateProcessA CreateProcess;
}



BOOL
SetProcessShutdownParameters(
    DWORD dwLevel,
    DWORD dwFlags
    );

BOOL
GetProcessShutdownParameters(
    LPDWORD lpdwLevel,
    LPDWORD lpdwFlags
    );

DWORD
GetProcessVersion(
    DWORD ProcessId
    );

VOID
FatalAppExitA(
    UINT uAction,
    LPCSTR lpMessageText
    );
VOID
FatalAppExitW(
    UINT uAction,
    LPCWSTR lpMessageText
    );

version(UNICODE) {
	alias FatalAppExitW FatalAppExit;
}
else {
	alias FatalAppExitA FatalAppExit;
}

VOID
GetStartupInfoA(
    LPSTARTUPINFOA lpStartupInfo
    );
VOID
GetStartupInfoW(
    LPSTARTUPINFOW lpStartupInfo
    );

version(UNICODE) {
	alias GetStartupInfoW GetStartupInfo;
}
else {
	alias GetStartupInfoA GetStartupInfo;
}


LPSTR GetCommandLineA();

LPWSTR GetCommandLineW();

version(UNICODE) {
	alias GetCommandLineW GetCommandLine;
}
else {
	alias GetCommandLineA GetCommandLine;
}

DWORD
GetEnvironmentVariableA(
    LPCSTR lpName,
    LPSTR lpBuffer,
    DWORD nSize
    );

DWORD
GetEnvironmentVariableW(
    LPCWSTR lpName,
    LPWSTR lpBuffer,
    DWORD nSize
    );

version(UNICODE) {
	alias GetEnvironmentVariableW GetEnvironmentVariable;
}
else {
	alias GetEnvironmentVariableA GetEnvironmentVariable;
}

BOOL
SetEnvironmentVariableA(
        LPCSTR lpName,
    LPCSTR lpValue
    );
BOOL
SetEnvironmentVariableW(
        LPCWSTR lpName,
    LPCWSTR lpValue
    );

version(UNICODE) {
	alias SetEnvironmentVariableW SetEnvironmentVariable;
}
else {
	alias SetEnvironmentVariableA SetEnvironmentVariable;
}

DWORD ExpandEnvironmentStringsA(
    LPCSTR lpSrc,
    LPSTR lpDst,
    DWORD nSize
    );

DWORD ExpandEnvironmentStringsW(
    LPCWSTR lpSrc,
    LPWSTR lpDst,
    DWORD nSize
    );

version(UNICODE) {
	alias ExpandEnvironmentStringsW ExpandEnvironmentStrings;
}
else {
	alias ExpandEnvironmentStringsA ExpandEnvironmentStrings;
}

DWORD
GetFirmwareEnvironmentVariableA(
    LPCSTR lpName,
    LPCSTR lpGuid,
    PVOID pBuffer,
    DWORD    nSize
    );
DWORD
GetFirmwareEnvironmentVariableW(
    LPCWSTR lpName,
    LPCWSTR lpGuid,
    PVOID pBuffer,
    DWORD    nSize
    );

version(UNICODE) {
	alias GetFirmwareEnvironmentVariableW GetFirmwareEnvironmentVariable;
}
else {
	alias GetFirmwareEnvironmentVariableA GetFirmwareEnvironmentVariable;
}

BOOL
SetFirmwareEnvironmentVariableA(
    LPCSTR lpName,
    LPCSTR lpGuid,
    PVOID pValue,
    DWORD    nSize
    );
BOOL
SetFirmwareEnvironmentVariableW(
    LPCWSTR lpName,
    LPCWSTR lpGuid,
    PVOID pValue,
    DWORD    nSize
    );

version(UNICODE) {
	alias SetFirmwareEnvironmentVariableW SetFirmwareEnvironmentVariable;
}
else {
	alias SetFirmwareEnvironmentVariableA SetFirmwareEnvironmentVariable;
}


VOID
OutputDebugStringA(
    LPCSTR lpOutputString
    );
VOID
OutputDebugStringW(
    LPCWSTR lpOutputString
    );

version(UNICODE) {
	alias OutputDebugStringW OutputDebugString;
}
else {
	alias OutputDebugStringA OutputDebugString;
}


HRSRC
FindResourceA(
    HMODULE hModule,
        LPCSTR lpName,
        LPCSTR lpType
    );

HRSRC
FindResourceW(
    HMODULE hModule,
        LPCWSTR lpName,
        LPCWSTR lpType
    );

version(UNICODE) {
	alias FindResourceW FindResource;
}
else {
	alias FindResourceA FindResource;
}


HRSRC
FindResourceExA(
    HMODULE hModule,
        LPCSTR lpType,
        LPCSTR lpName,
        WORD    wLanguage
    );

HRSRC
FindResourceExW(
    HMODULE hModule,
        LPCWSTR lpType,
        LPCWSTR lpName,
        WORD    wLanguage
    );

version(UNICODE) {
	alias FindResourceExW FindResourceEx;
}
else {
	alias FindResourceExA FindResourceEx;
}

alias BOOL function(HMODULE hModule, LPSTR lpType,
LONG_PTR lParam) ENUMRESTYPEPROCA;
alias BOOL function(HMODULE hModule, LPWSTR lpType,
LONG_PTR lParam) ENUMRESTYPEPROCW;

version(UNICODE) {
	alias ENUMRESTYPEPROCW ENUMRESTYPEPROC;
}
else {
	alias ENUMRESTYPEPROCA ENUMRESTYPEPROC;
}

alias BOOL function(HMODULE hModule, LPCSTR lpType,
LPSTR lpName, LONG_PTR lParam) ENUMRESNAMEPROCA;
alias BOOL function(HMODULE hModule, LPCWSTR lpType,
LPWSTR lpName, LONG_PTR lParam) ENUMRESNAMEPROCW;

version(UNICODE) {
	alias ENUMRESNAMEPROCW ENUMRESNAMEPROC;
}
else {
	alias ENUMRESNAMEPROCA ENUMRESNAMEPROC;
}

alias BOOL function(HMODULE hModule, LPCSTR lpType,
LPCSTR lpName, WORD  wLanguage, LONG_PTR lParam) ENUMRESLANGPROCA;
alias BOOL function(HMODULE hModule, LPCWSTR lpType,
LPCWSTR lpName, WORD  wLanguage, LONG_PTR lParam) ENUMRESLANGPROCW;

version(UNICODE) {
	alias ENUMRESLANGPROCW ENUMRESLANGPROC;
}
else {
	alias ENUMRESLANGPROCA ENUMRESLANGPROC;
}

BOOL
EnumResourceTypesA(
    HMODULE hModule,
        ENUMRESTYPEPROCA lpEnumFunc,
        LONG_PTR lParam
    );
BOOL
EnumResourceTypesW(
    HMODULE hModule,
        ENUMRESTYPEPROCW lpEnumFunc,
        LONG_PTR lParam
    );

version(UNICODE) {
	alias EnumResourceTypesW EnumResourceTypes;
}
else {
	alias EnumResourceTypesA EnumResourceTypes;
}

BOOL
EnumResourceNamesA(
    HMODULE hModule,
        LPCSTR lpType,
        ENUMRESNAMEPROCA lpEnumFunc,
        LONG_PTR lParam
    );
BOOL
EnumResourceNamesW(
    HMODULE hModule,
        LPCWSTR lpType,
        ENUMRESNAMEPROCW lpEnumFunc,
        LONG_PTR lParam
    );

version(UNICODE) {
	alias EnumResourceNamesW EnumResourceNames;
}
else {
	alias EnumResourceNamesA EnumResourceNames;
}

BOOL
EnumResourceLanguagesA(
    HMODULE hModule,
        LPCSTR lpType,
        LPCSTR lpName,
        ENUMRESLANGPROCA lpEnumFunc,
        LONG_PTR lParam
    );
BOOL
EnumResourceLanguagesW(
    HMODULE hModule,
        LPCWSTR lpType,
        LPCWSTR lpName,
        ENUMRESLANGPROCW lpEnumFunc,
        LONG_PTR lParam
    );

version(UNICODE) {
	alias EnumResourceLanguagesW EnumResourceLanguages;
}
else {
	alias EnumResourceLanguagesA EnumResourceLanguages;
}

const auto   RESOURCE_ENUM_LN               = (0x0001);
const auto   RESOURCE_ENUM_MUI              = (0x0002);
const auto   RESOURCE_ENUM_MUI_SYSTEM       = (0x0004);
const auto   RESOURCE_UPDATE_LN             = (0x0010);
const auto   RESOURCE_UPDATE_MUI            = (0x0020);

BOOL
EnumResourceTypesExA(
    HMODULE hModule,
    ENUMRESTYPEPROCA lpEnumFunc,
    LONG_PTR lParam,
    DWORD dwFlags,
    LANGID LangId
    );
BOOL
EnumResourceTypesExW(
    HMODULE hModule,
    ENUMRESTYPEPROCW lpEnumFunc,
    LONG_PTR lParam,
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
    HMODULE hModule,
    LPCSTR lpType,
    ENUMRESNAMEPROCA lpEnumFunc,
    LONG_PTR lParam,
    DWORD dwFlags,
    LANGID LangId
    );
BOOL
EnumResourceNamesExW(
    HMODULE hModule,
    LPCWSTR lpType,
    ENUMRESNAMEPROCW lpEnumFunc,
    LONG_PTR lParam,
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
    HMODULE hModule,
    LPCSTR lpType,
    LPCSTR lpName,
    ENUMRESLANGPROCA lpEnumFunc,
    LONG_PTR lParam,
    DWORD dwFlags,
    LANGID LangId
    );
BOOL
EnumResourceLanguagesExW(
    HMODULE hModule,
    LPCWSTR lpType,
    LPCWSTR lpName,
    ENUMRESLANGPROCW lpEnumFunc,
    LONG_PTR lParam,
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
    LPCSTR pFileName,
    BOOL bDeleteExistingResources
    );
HANDLE
BeginUpdateResourceW(
    LPCWSTR pFileName,
    BOOL bDeleteExistingResources
    );

version(UNICODE) {
	alias BeginUpdateResourceW BeginUpdateResource;
}
else {
	alias BeginUpdateResourceA BeginUpdateResource;
}

BOOL
UpdateResourceA(
    HANDLE hUpdate,
    LPCSTR lpType,
    LPCSTR lpName,
    WORD wLanguage,
    LPVOID lpData,
    DWORD cb
    );
BOOL
UpdateResourceW(
    HANDLE hUpdate,
    LPCWSTR lpType,
    LPCWSTR lpName,
    WORD wLanguage,
    LPVOID lpData,
    DWORD cb
    );

version(UNICODE) {
	alias UpdateResourceW UpdateResource;
}
else {
	alias UpdateResourceA UpdateResource;
}

BOOL
EndUpdateResourceA(
    HANDLE hUpdate,
    BOOL   fDiscard
    );
BOOL
EndUpdateResourceW(
    HANDLE hUpdate,
    BOOL   fDiscard
    );

version(UNICODE) {
	alias EndUpdateResourceW EndUpdateResource;
}
else {
	alias EndUpdateResourceA EndUpdateResource;
}


ATOM
GlobalAddAtomA(
    LPCSTR lpString
    );
ATOM
GlobalAddAtomW(
    LPCWSTR lpString
    );

version(UNICODE) {
	alias GlobalAddAtomW GlobalAddAtom;
}
else {
	alias GlobalAddAtomA GlobalAddAtom;
}

ATOM
GlobalFindAtomA(
    LPCSTR lpString
    );
ATOM
GlobalFindAtomW(
    LPCWSTR lpString
    );

version(UNICODE) {
	alias GlobalFindAtomW GlobalFindAtom;
}
else {
	alias GlobalFindAtomA GlobalFindAtom;
}

UINT
GlobalGetAtomNameA(
    ATOM nAtom,
    LPSTR lpBuffer,
    int nSize
    );
UINT
GlobalGetAtomNameW(
    ATOM nAtom,
    LPWSTR lpBuffer,
    int nSize
    );

version(UNICODE) {
	alias GlobalGetAtomNameW GlobalGetAtomName;
}
else {
	alias GlobalGetAtomNameA GlobalGetAtomName;
}

ATOM
AddAtomA(
    LPCSTR lpString
    );
ATOM
AddAtomW(
    LPCWSTR lpString
    );

version(UNICODE) {
	alias AddAtomW AddAtom;
}
else {
	alias AddAtomA AddAtom;
}

ATOM
FindAtomA(
    LPCSTR lpString
    );
ATOM
FindAtomW(
    LPCWSTR lpString
    );

version(UNICODE) {
	alias FindAtomW FindAtom;
}
else {
	alias FindAtomA FindAtom;
}

UINT
GetAtomNameA(
    ATOM nAtom,
    LPSTR lpBuffer,
    int nSize
    );
UINT
GetAtomNameW(
    ATOM nAtom,
    LPWSTR lpBuffer,
    int nSize
    );

version(UNICODE) {
	alias GetAtomNameW GetAtomName;
}
else {
	alias GetAtomNameA GetAtomName;
}

UINT
GetProfileIntA(
    LPCSTR lpAppName,
    LPCSTR lpKeyName,
    INT nDefault
    );
UINT
GetProfileIntW(
    LPCWSTR lpAppName,
    LPCWSTR lpKeyName,
    INT nDefault
    );

version(UNICODE) {
	alias GetProfileIntW GetProfileInt;
}
else {
	alias GetProfileIntA GetProfileInt;
}

DWORD GetProfileStringA(
    LPCSTR lpAppName,
    LPCSTR lpKeyName,
    LPCSTR lpDefault,
    LPSTR lpReturnedString,
    DWORD nSize
    );

DWORD GetProfileStringW(
    LPCWSTR lpAppName,
    LPCWSTR lpKeyName,
    LPCWSTR lpDefault,
    LPWSTR lpReturnedString,
    DWORD nSize
    );

version(UNICODE) {
	alias GetProfileStringW GetProfileString;
}
else {
	alias GetProfileStringA GetProfileString;
}

BOOL
WriteProfileStringA(
    LPCSTR lpAppName,
    LPCSTR lpKeyName,
    LPCSTR lpString
    );
BOOL
WriteProfileStringW(
    LPCWSTR lpAppName,
    LPCWSTR lpKeyName,
    LPCWSTR lpString
    );

version(UNICODE) {
	alias WriteProfileStringW WriteProfileString;
}
else {
	alias WriteProfileStringA WriteProfileString;
}

DWORD
GetProfileSectionA(
    LPCSTR lpAppName,
    LPSTR lpReturnedString,
    DWORD nSize
    );
DWORD
GetProfileSectionW(
    LPCWSTR lpAppName,
	LPWSTR lpReturnedString,
    DWORD nSize
    );

version(UNICODE) {
	alias GetProfileSectionW GetProfileSection;
}
else {
	alias GetProfileSectionA GetProfileSection;
}

BOOL
WriteProfileSectionA(
    LPCSTR lpAppName,
    LPCSTR lpString
    );
BOOL
WriteProfileSectionW(
    LPCWSTR lpAppName,
    LPCWSTR lpString
    );

version(UNICODE) {
	alias WriteProfileSectionW WriteProfileSection;
}
else {
	alias WriteProfileSectionA WriteProfileSection;
}

UINT
GetPrivateProfileIntA(
        LPCSTR lpAppName,
        LPCSTR lpKeyName,
        INT nDefault,
    LPCSTR lpFileName
    );
UINT
GetPrivateProfileIntW(
        LPCWSTR lpAppName,
        LPCWSTR lpKeyName,
        INT nDefault,
    LPCWSTR lpFileName
    );

version(UNICODE) {
	alias GetPrivateProfileIntW GetPrivateProfileInt;
}
else {
	alias GetPrivateProfileIntA GetPrivateProfileInt;
}

DWORD
GetPrivateProfileStringA(
    LPCSTR lpAppName,
    LPCSTR lpKeyName,
    LPCSTR lpDefault,
    LPSTR lpReturnedString,
        DWORD nSize,
    LPCSTR lpFileName
    );
DWORD
GetPrivateProfileStringW(
    LPCWSTR lpAppName,
    LPCWSTR lpKeyName,
    LPCWSTR lpDefault,
    LPWSTR lpReturnedString,
        DWORD nSize,
    LPCWSTR lpFileName
    );

version(UNICODE) {
	alias GetPrivateProfileStringW GetPrivateProfileString;
}
else {
	alias GetPrivateProfileStringA GetPrivateProfileString;
}

BOOL
WritePrivateProfileStringA(
    LPCSTR lpAppName,
    LPCSTR lpKeyName,
    LPCSTR lpString,
    LPCSTR lpFileName
    );
BOOL
WritePrivateProfileStringW(
    LPCWSTR lpAppName,
    LPCWSTR lpKeyName,
    LPCWSTR lpString,
    LPCWSTR lpFileName
    );

version(UNICODE) {
	alias WritePrivateProfileStringW WritePrivateProfileString;
}
else {
	alias WritePrivateProfileStringA WritePrivateProfileString;
}

DWORD
GetPrivateProfileSectionA(
        LPCSTR lpAppName,
		LPSTR lpReturnedString,
        DWORD nSize,
    LPCSTR lpFileName
    );
DWORD
GetPrivateProfileSectionW(
        LPCWSTR lpAppName,
    LPWSTR lpReturnedString,
        DWORD nSize,
    LPCWSTR lpFileName
    );

version(UNICODE) {
	alias GetPrivateProfileSectionW GetPrivateProfileSection;
}
else {
	alias GetPrivateProfileSectionA GetPrivateProfileSection;
}

BOOL
WritePrivateProfileSectionA(
        LPCSTR lpAppName,
        LPCSTR lpString,
    LPCSTR lpFileName
    );
BOOL
WritePrivateProfileSectionW(
        LPCWSTR lpAppName,
        LPCWSTR lpString,
    LPCWSTR lpFileName
    );

version(UNICODE) {
	alias WritePrivateProfileSectionW WritePrivateProfileSection;
}
else {
	alias WritePrivateProfileSectionA WritePrivateProfileSection;
}


DWORD
GetPrivateProfileSectionNamesA(
    LPSTR lpszReturnBuffer,
        DWORD nSize,
    LPCSTR lpFileName
    );
DWORD
GetPrivateProfileSectionNamesW(
    LPWSTR lpszReturnBuffer,
        DWORD nSize,
    LPCWSTR lpFileName
    );

version(UNICODE) {
	alias GetPrivateProfileSectionNamesW GetPrivateProfileSectionNames;
}
else {
	alias GetPrivateProfileSectionNamesA GetPrivateProfileSectionNames;
}

BOOL
GetPrivateProfileStructA(
        LPCSTR lpszSection,
        LPCSTR lpszKey,
    LPVOID   lpStruct,
        UINT     uSizeStruct,
    LPCSTR szFile
    );
BOOL
GetPrivateProfileStructW(
        LPCWSTR lpszSection,
        LPCWSTR lpszKey,
    LPVOID   lpStruct,
        UINT     uSizeStruct,
    LPCWSTR szFile
    );

version(UNICODE) {
	alias GetPrivateProfileStructW GetPrivateProfileStruct;
}
else {
	alias GetPrivateProfileStructA GetPrivateProfileStruct;
}

BOOL
WritePrivateProfileStructA(
        LPCSTR lpszSection,
        LPCSTR lpszKey,LPVOID lpStruct,
        UINT     uSizeStruct,
    LPCSTR szFile
    );
BOOL
WritePrivateProfileStructW(
        LPCWSTR lpszSection,
        LPCWSTR lpszKey,
    LPVOID lpStruct,
        UINT     uSizeStruct,
    LPCWSTR szFile
    );

version(UNICODE) {
	alias WritePrivateProfileStructW WritePrivateProfileStruct;
}
else {
	alias WritePrivateProfileStructA WritePrivateProfileStruct;
}


UINT
GetDriveTypeA(
    LPCSTR lpRootPathName
    );
UINT
GetDriveTypeW(
    LPCWSTR lpRootPathName
    );

version(UNICODE) {
	alias GetDriveTypeW GetDriveType;
}
else {
	alias GetDriveTypeA GetDriveType;
}

UINT
GetSystemDirectoryA(
    LPSTR lpBuffer,
    UINT uSize
    );
UINT
GetSystemDirectoryW(
    LPWSTR lpBuffer,
    UINT uSize
    );

version(UNICODE) {
	alias GetSystemDirectoryW GetSystemDirectory;
}
else {
	alias GetSystemDirectoryA GetSystemDirectory;
}

DWORD
GetTempPathA(
    DWORD nBufferLength,
    LPSTR lpBuffer
    );
DWORD
GetTempPathW(
    DWORD nBufferLength,
    LPWSTR lpBuffer
    );

version(UNICODE) {
	alias GetTempPathW GetTempPath;
}
else {
	alias GetTempPathA GetTempPath;
}

UINT
GetTempFileNameA(
    LPCSTR lpPathName,
    LPCSTR lpPrefixString,
    UINT uUnique,
    LPSTR lpTempFileName
    );
UINT
GetTempFileNameW(
    LPCWSTR lpPathName,
    LPCWSTR lpPrefixString,
    UINT uUnique,
    LPWSTR lpTempFileName
    );

version(UNICODE) {
	alias GetTempFileNameW GetTempFileName;
}
else {
	alias GetTempFileNameA GetTempFileName;
}


UINT GetWindowsDirectoryA(
    LPSTR lpBuffer,
    UINT uSize
    );
UINT GetWindowsDirectoryW(
    LPWSTR lpBuffer,
    UINT uSize
    );

version(UNICODE) {
	alias GetWindowsDirectoryW GetWindowsDirectory;
}
else {
	alias GetWindowsDirectoryA GetWindowsDirectory;
}

UINT
GetSystemWindowsDirectoryA(
    LPSTR lpBuffer,
    UINT uSize
    );
UINT
GetSystemWindowsDirectoryW(
    LPWSTR lpBuffer,
    UINT uSize
    );

version(UNICODE) {
	alias GetSystemWindowsDirectoryW GetSystemWindowsDirectory;
}
else {
	alias GetSystemWindowsDirectoryA GetSystemWindowsDirectory;
}

UINT GetSystemWow64DirectoryA(
    LPSTR lpBuffer,
    UINT uSize
    );
UINT
GetSystemWow64DirectoryW(
    LPWSTR lpBuffer,
    UINT uSize
    );

version(UNICODE) {
	alias GetSystemWow64DirectoryW GetSystemWow64Directory;
}
else {
	alias GetSystemWow64DirectoryA GetSystemWow64Directory;
}

BOOLEAN
Wow64EnableWow64FsRedirection (
    BOOLEAN Wow64FsEnableRedirection
    );

BOOL
Wow64DisableWow64FsRedirection (
    PVOID *OldValue
    );

BOOL
Wow64RevertWow64FsRedirection (
    PVOID OlValue
    );


//
// for GetProcAddress
//
alias UINT function(LPSTR lpBuffer, UINT uSize) PGET_SYSTEM_WOW64_DIRECTORY_A;
alias UINT function(LPWSTR lpBuffer, UINT uSize) PGET_SYSTEM_WOW64_DIRECTORY_W;

//
// GetProcAddress only accepts GET_SYSTEM_WOW64_DIRECTORY_NAME_A_A,
// GET_SYSTEM_WOW64_DIRECTORY_NAME_W_A, GET_SYSTEM_WOW64_DIRECTORY_NAME_T_A.
// The others are if you want to use the strings in some other way.
//
const auto GET_SYSTEM_WOW64_DIRECTORY_NAME_A_A       = "GetSystemWow64DirectoryA\0"c;
const auto GET_SYSTEM_WOW64_DIRECTORY_NAME_A_W      = "GetSystemWow64DirectoryA\0"w;
const auto GET_SYSTEM_WOW64_DIRECTORY_NAME_W_A       = "GetSystemWow64DirectoryW\0"c;
const auto GET_SYSTEM_WOW64_DIRECTORY_NAME_W_W      = "GetSystemWow64DirectoryW\0"w;

version(UNICODE) {
	const auto GET_SYSTEM_WOW64_DIRECTORY_NAME_A_T  = GET_SYSTEM_WOW64_DIRECTORY_NAME_A_W;
	const auto GET_SYSTEM_WOW64_DIRECTORY_NAME_W_T  = GET_SYSTEM_WOW64_DIRECTORY_NAME_W_W;
}
else {
	const auto GET_SYSTEM_WOW64_DIRECTORY_NAME_A_T  = GET_SYSTEM_WOW64_DIRECTORY_NAME_A_A;
	const auto GET_SYSTEM_WOW64_DIRECTORY_NAME_W_T  = GET_SYSTEM_WOW64_DIRECTORY_NAME_W_A;
}


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


BOOL
SetCurrentDirectoryA(
    LPCSTR lpPathName
    );
BOOL
SetCurrentDirectoryW(
    LPCWSTR lpPathName
    );

version(UNICODE) {
	alias SetCurrentDirectoryW SetCurrentDirectory;
}
else {
	alias SetCurrentDirectoryA SetCurrentDirectory;
}

DWORD GetCurrentDirectoryA(
    DWORD nBufferLength,
	LPSTR lpBuffer
    );

DWORD GetCurrentDirectoryW(
    DWORD nBufferLength,
    LPWSTR lpBuffer
    );

version(UNICODE) {
	alias GetCurrentDirectoryW GetCurrentDirectory;
}
else {
	alias GetCurrentDirectoryA GetCurrentDirectory;
}

BOOL
SetDllDirectoryA(
    LPCSTR lpPathName
    );
BOOL
SetDllDirectoryW(
    LPCWSTR lpPathName
    );

version(UNICODE) {
	alias SetDllDirectoryW SetDllDirectory;
}
else {
	alias SetDllDirectoryA SetDllDirectory;
}

DWORD
GetDllDirectoryA(
    DWORD nBufferLength,
    LPSTR lpBuffer
    );
DWORD
GetDllDirectoryW(
    DWORD nBufferLength,
	LPWSTR lpBuffer
    );

version(UNICODE) {
	alias GetDllDirectoryW GetDllDirectory;
}
else {
	alias GetDllDirectoryA GetDllDirectory;
}


BOOL
GetDiskFreeSpaceA(
     LPCSTR lpRootPathName,
     LPDWORD lpSectorsPerCluster,
     LPDWORD lpBytesPerSector,
     LPDWORD lpNumberOfFreeClusters,
     LPDWORD lpTotalNumberOfClusters
    );
BOOL
GetDiskFreeSpaceW(
     LPCWSTR lpRootPathName,
     LPDWORD lpSectorsPerCluster,
     LPDWORD lpBytesPerSector,
     LPDWORD lpNumberOfFreeClusters,
     LPDWORD lpTotalNumberOfClusters
    );

version(UNICODE) {
	alias GetDiskFreeSpaceW GetDiskFreeSpace;
}
else {
	alias GetDiskFreeSpaceA GetDiskFreeSpace;
}

BOOL
GetDiskFreeSpaceExA(
     LPCSTR lpDirectoryName,
     PULARGE_INTEGER lpFreeBytesAvailableToCaller,
     PULARGE_INTEGER lpTotalNumberOfBytes,
     PULARGE_INTEGER lpTotalNumberOfFreeBytes
    );
BOOL
GetDiskFreeSpaceExW(
     LPCWSTR lpDirectoryName,
     PULARGE_INTEGER lpFreeBytesAvailableToCaller,
     PULARGE_INTEGER lpTotalNumberOfBytes,
     PULARGE_INTEGER lpTotalNumberOfFreeBytes
    );

version(UNICODE) {
	alias GetDiskFreeSpaceExW GetDiskFreeSpaceEx;
}
else {
	alias GetDiskFreeSpaceExA GetDiskFreeSpaceEx;
}

BOOL
CreateDirectoryA(
        LPCSTR lpPathName,
    LPSECURITY_ATTRIBUTES lpSecurityAttributes
    );
BOOL
CreateDirectoryW(
        LPCWSTR lpPathName,
    LPSECURITY_ATTRIBUTES lpSecurityAttributes
    );

version(UNICODE) {
	alias CreateDirectoryW CreateDirectory;
}
else {
	alias CreateDirectoryA CreateDirectory;
}

BOOL
CreateDirectoryExA(
        LPCSTR lpTemplateDirectory,
        LPCSTR lpNewDirectory,
    LPSECURITY_ATTRIBUTES lpSecurityAttributes
    );
BOOL
CreateDirectoryExW(
        LPCWSTR lpTemplateDirectory,
        LPCWSTR lpNewDirectory,
    LPSECURITY_ATTRIBUTES lpSecurityAttributes
    );

version(UNICODE) {
	alias CreateDirectoryExW CreateDirectoryEx;
}
else {
	alias CreateDirectoryExA CreateDirectoryEx;
}

BOOL
CreateDirectoryTransactedA(
        LPCSTR lpTemplateDirectory,
        LPCSTR lpNewDirectory,
    LPSECURITY_ATTRIBUTES lpSecurityAttributes,
        HANDLE hTransaction
    );
BOOL
CreateDirectoryTransactedW(
        LPCWSTR lpTemplateDirectory,
        LPCWSTR lpNewDirectory,
    LPSECURITY_ATTRIBUTES lpSecurityAttributes,
        HANDLE hTransaction
    );

version(UNICODE) {
	alias CreateDirectoryTransactedW CreateDirectoryTransacted;
}
else {
	alias CreateDirectoryTransactedA CreateDirectoryTransacted;
}


BOOL
RemoveDirectoryA(
    LPCSTR lpPathName
    );
BOOL
RemoveDirectoryW(
    LPCWSTR lpPathName
    );

version(UNICODE) {
	alias RemoveDirectoryW RemoveDirectory;
}
else {
	alias RemoveDirectoryA RemoveDirectory;
}

BOOL
RemoveDirectoryTransactedA(
    LPCSTR lpPathName,
        HANDLE hTransaction
    );
BOOL
RemoveDirectoryTransactedW(
    LPCWSTR lpPathName,
        HANDLE hTransaction
    );

version(UNICODE) {
	alias RemoveDirectoryTransactedW RemoveDirectoryTransacted;
}
else {
	alias RemoveDirectoryTransactedA RemoveDirectoryTransacted;
}


DWORD
GetFullPathNameA(
               LPCSTR lpFileName,
               DWORD nBufferLength,
    LPSTR lpBuffer,
    LPSTR *lpFilePart
    );
DWORD
GetFullPathNameW(
               LPCWSTR lpFileName,
               DWORD nBufferLength,
			   LPWSTR lpBuffer,
    LPWSTR *lpFilePart
    );

version(UNICODE) {
	alias GetFullPathNameW GetFullPathName;
}
else {
	alias GetFullPathNameA GetFullPathName;
}

DWORD
GetFullPathNameTransactedA(
               LPCSTR lpFileName,
               DWORD nBufferLength,
    LPSTR lpBuffer,
    LPSTR *lpFilePart,
               HANDLE hTransaction
    );
DWORD
GetFullPathNameTransactedW(
               LPCWSTR lpFileName,
               DWORD nBufferLength,
    LPWSTR lpBuffer,
    LPWSTR *lpFilePart,
               HANDLE hTransaction
    );

version(UNICODE) {
	alias GetFullPathNameTransactedW GetFullPathNameTransacted;
}
else {
	alias GetFullPathNameTransactedA GetFullPathNameTransacted;
}


const auto DDD_RAW_TARGET_PATH          = 0x00000001;
const auto DDD_REMOVE_DEFINITION        = 0x00000002;
const auto DDD_EXACT_MATCH_ON_REMOVE    = 0x00000004;
const auto DDD_NO_BROADCAST_SYSTEM      = 0x00000008;
const auto DDD_LUID_BROADCAST_DRIVE     = 0x00000010;

BOOL
DefineDosDeviceA(
        DWORD dwFlags,
        LPCSTR lpDeviceName,
    LPCSTR lpTargetPath
    );
BOOL
DefineDosDeviceW(
        DWORD dwFlags,
        LPCWSTR lpDeviceName,
    LPCWSTR lpTargetPath
    );

version(UNICODE) {
	alias DefineDosDeviceW DefineDosDevice;
}
else {
	alias DefineDosDeviceA DefineDosDevice;
}

DWORD
QueryDosDeviceA(
    LPCSTR lpDeviceName,
    LPSTR lpTargetPath,
        DWORD ucchMax
    );
DWORD
QueryDosDeviceW(
    LPCWSTR lpDeviceName,
    LPWSTR lpTargetPath,
        DWORD ucchMax
    );

version(UNICODE) {
	alias QueryDosDeviceW QueryDosDevice;
}
else {
	alias QueryDosDeviceA QueryDosDevice;
}

HANDLE
CreateFileA(
        LPCSTR lpFileName,
        DWORD dwDesiredAccess,
        DWORD dwShareMode,
    LPSECURITY_ATTRIBUTES lpSecurityAttributes,
        DWORD dwCreationDisposition,
        DWORD dwFlagsAndAttributes,
    HANDLE hTemplateFile
    );

HANDLE
CreateFileW(
        LPCWSTR lpFileName,
        DWORD dwDesiredAccess,
        DWORD dwShareMode,
    LPSECURITY_ATTRIBUTES lpSecurityAttributes,
        DWORD dwCreationDisposition,
        DWORD dwFlagsAndAttributes,
    HANDLE hTemplateFile
    );

version(UNICODE) {
	alias CreateFileW CreateFile;
}
else {
	alias CreateFileA CreateFile;
}

HANDLE
CreateFileTransactedA(
          LPCSTR lpFileName,
          DWORD dwDesiredAccess,
          DWORD dwShareMode,
      LPSECURITY_ATTRIBUTES lpSecurityAttributes,
          DWORD dwCreationDisposition,
          DWORD dwFlagsAndAttributes,
      HANDLE hTemplateFile,
          HANDLE hTransaction,
      PUSHORT pusMiniVersion,
    PVOID  lpExtendedParameter
    );

HANDLE
CreateFileTransactedW(
          LPCWSTR lpFileName,
          DWORD dwDesiredAccess,
          DWORD dwShareMode,
      LPSECURITY_ATTRIBUTES lpSecurityAttributes,
          DWORD dwCreationDisposition,
          DWORD dwFlagsAndAttributes,
      HANDLE hTemplateFile,
          HANDLE hTransaction,
      PUSHORT pusMiniVersion,
    PVOID  lpExtendedParameter
    );

version(UNICODE) {
	alias CreateFileTransactedW CreateFileTransacted;
}
else {
	alias CreateFileTransactedA CreateFileTransacted;
}


HANDLE
ReOpenFile(
    HANDLE  hOriginalFile,
    DWORD   dwDesiredAccess,
    DWORD   dwShareMode,
    DWORD   dwFlagsAndAttributes
    );


BOOL
SetFileAttributesA(
    LPCSTR lpFileName,
    DWORD dwFileAttributes
    );
BOOL
SetFileAttributesW(
    LPCWSTR lpFileName,
    DWORD dwFileAttributes
    );

version(UNICODE) {
	alias SetFileAttributesW SetFileAttributes;
}
else {
	alias SetFileAttributesA SetFileAttributes;
}

DWORD
GetFileAttributesA(
    LPCSTR lpFileName
    );
DWORD
GetFileAttributesW(
    LPCWSTR lpFileName
    );

version(UNICODE) {
	alias GetFileAttributesW GetFileAttributes;
}
else {
	alias GetFileAttributesA GetFileAttributes;
}

BOOL
SetFileAttributesTransactedA(
        LPCSTR lpFileName,
        DWORD dwFileAttributes,
        HANDLE hTransaction
    );
BOOL
SetFileAttributesTransactedW(
        LPCWSTR lpFileName,
        DWORD dwFileAttributes,
        HANDLE hTransaction
    );

version(UNICODE) {
	alias SetFileAttributesTransactedW SetFileAttributesTransacted;
}
else {
	alias SetFileAttributesTransactedA SetFileAttributesTransacted;
}

enum GET_FILEEX_INFO_LEVELS {
    GetFileExInfoStandard,
    GetFileExMaxInfoLevel
}

BOOL
GetFileAttributesTransactedA(
     LPCSTR lpFileName,
     GET_FILEEX_INFO_LEVELS fInfoLevelId,
    LPVOID lpFileInformation,
        HANDLE hTransaction
    );
BOOL
GetFileAttributesTransactedW(
     LPCWSTR lpFileName,
     GET_FILEEX_INFO_LEVELS fInfoLevelId,
    LPVOID lpFileInformation,
        HANDLE hTransaction
    );

version(UNICODE) {
	alias GetFileAttributesTransactedW GetFileAttributesTransacted;
}
else {
	alias GetFileAttributesTransactedA GetFileAttributesTransacted;
}

BOOL
GetFileAttributesExA(
     LPCSTR lpFileName,
     GET_FILEEX_INFO_LEVELS fInfoLevelId,
    LPVOID lpFileInformation
    );
BOOL
GetFileAttributesExW(
     LPCWSTR lpFileName,
     GET_FILEEX_INFO_LEVELS fInfoLevelId,
    LPVOID lpFileInformation
    );

version(UNICODE) {
	alias GetFileAttributesExW GetFileAttributesEx;
}
else {
	alias GetFileAttributesExA GetFileAttributesEx;
}

DWORD
GetCompressedFileSizeA(
     LPCSTR lpFileName,
     LPDWORD  lpFileSizeHigh
    );
DWORD
GetCompressedFileSizeW(
     LPCWSTR lpFileName,
     LPDWORD  lpFileSizeHigh
    );

version(UNICODE) {
	alias GetCompressedFileSizeW GetCompressedFileSize;
}
else {
	alias GetCompressedFileSizeA GetCompressedFileSize;
}

DWORD
GetCompressedFileSizeTransactedA(
         LPCSTR lpFileName,
     LPDWORD  lpFileSizeHigh,
         HANDLE hTransaction
    );
DWORD
GetCompressedFileSizeTransactedW(
         LPCWSTR lpFileName,
     LPDWORD  lpFileSizeHigh,
         HANDLE hTransaction
    );

version(UNICODE) {
	alias GetCompressedFileSizeTransactedW GetCompressedFileSizeTransacted;
}
else {
	alias GetCompressedFileSizeTransactedA GetCompressedFileSizeTransacted;
}

BOOL
DeleteFileA(
    LPCSTR lpFileName
    );
BOOL
DeleteFileW(
    LPCWSTR lpFileName
    );

version(UNICODE) {
	alias DeleteFileW DeleteFile;
}
else {
	alias DeleteFileA DeleteFile;
}

BOOL
DeleteFileTransactedA(
        LPCSTR lpFileName,
        HANDLE hTransaction
    );
BOOL
DeleteFileTransactedW(
        LPCWSTR lpFileName,
        HANDLE hTransaction
    );

version(UNICODE) {
	alias DeleteFileTransactedW DeleteFileTransacted;
}
else {
	alias DeleteFileTransactedA DeleteFileTransacted;
}

BOOL
CheckNameLegalDOS8Dot3A(
         LPCSTR lpName,
    LPSTR lpOemName,
         DWORD OemNameSize,
     PBOOL pbNameContainsSpaces ,
        PBOOL pbNameLegal
    );

BOOL
CheckNameLegalDOS8Dot3W(
         LPCWSTR lpName,
    LPSTR lpOemName,
         DWORD OemNameSize,
     PBOOL pbNameContainsSpaces ,
        PBOOL pbNameLegal
    );

version(UNICODE) {
	alias CheckNameLegalDOS8Dot3W CheckNameLegalDOS8Dot3;
}
else {
	alias CheckNameLegalDOS8Dot3A CheckNameLegalDOS8Dot3;
}

enum FINDEX_INFO_LEVELS {
    FindExInfoStandard,
    FindExInfoMaxInfoLevel
} 

enum FINDEX_SEARCH_OPS {
    FindExSearchNameMatch,
    FindExSearchLimitToDirectories,
    FindExSearchLimitToDevices,
    FindExSearchMaxSearchOp
} 

const auto FIND_FIRST_EX_CASE_SENSITIVE    = 0x00000001;


HANDLE
FindFirstFileExA(
          LPCSTR lpFileName,
          FINDEX_INFO_LEVELS fInfoLevelId,
         LPVOID lpFindFileData,
          FINDEX_SEARCH_OPS fSearchOp,
    LPVOID lpSearchFilter,
          DWORD dwAdditionalFlags
    );

HANDLE
FindFirstFileExW(
          LPCWSTR lpFileName,
          FINDEX_INFO_LEVELS fInfoLevelId,
         LPVOID lpFindFileData,
          FINDEX_SEARCH_OPS fSearchOp,
    LPVOID lpSearchFilter,
          DWORD dwAdditionalFlags
    );

version(UNICODE) {
	alias FindFirstFileExW FindFirstFileEx;
}
else {
	alias FindFirstFileExA FindFirstFileEx;
}


HANDLE
FindFirstFileTransactedA(
          LPCSTR lpFileName,
          FINDEX_INFO_LEVELS fInfoLevelId,
         LPVOID lpFindFileData,
          FINDEX_SEARCH_OPS fSearchOp,
    LPVOID lpSearchFilter,
          DWORD dwAdditionalFlags,
          HANDLE hTransaction
    );

HANDLE
FindFirstFileTransactedW(
          LPCWSTR lpFileName,
          FINDEX_INFO_LEVELS fInfoLevelId,
         LPVOID lpFindFileData,
          FINDEX_SEARCH_OPS fSearchOp,
    LPVOID lpSearchFilter,
          DWORD dwAdditionalFlags,
          HANDLE hTransaction
    );

version(UNICODE) {
	alias FindFirstFileTransactedW FindFirstFileTransacted;
}
else {
	alias FindFirstFileTransactedA FindFirstFileTransacted;
}


HANDLE
FindFirstFileA(
     LPCSTR lpFileName,
    LPWIN32_FIND_DATAA lpFindFileData
    );

HANDLE
FindFirstFileW(
     LPCWSTR lpFileName,
    LPWIN32_FIND_DATAW lpFindFileData
    );

version(UNICODE) {
	alias FindFirstFileW FindFirstFile;
}
else {
	alias FindFirstFileA FindFirstFile;
}

BOOL
FindNextFileA(
     HANDLE hFindFile,
    LPWIN32_FIND_DATAA lpFindFileData
    );
BOOL
FindNextFileW(
     HANDLE hFindFile,
    LPWIN32_FIND_DATAW lpFindFileData
    );

version(UNICODE) {
	alias FindNextFileW FindNextFile;
}
else {
	alias FindNextFileA FindNextFile;
}


DWORD
SearchPathA(
     LPCSTR lpPath,
         LPCSTR lpFileName,
     LPCSTR lpExtension,
         DWORD nBufferLength,
    LPSTR lpBuffer,
     LPSTR *lpFilePart
    );
DWORD
SearchPathW(
     LPCWSTR lpPath,
         LPCWSTR lpFileName,
     LPCWSTR lpExtension,
         DWORD nBufferLength,
    LPWSTR lpBuffer,
     LPWSTR *lpFilePart
    );

version(UNICODE) {
	alias SearchPathW SearchPath;
}
else {
	alias SearchPathA SearchPath;
}

BOOL
CopyFileA(
    LPCSTR lpExistingFileName,
    LPCSTR lpNewFileName,
    BOOL bFailIfExists
    );
BOOL
CopyFileW(
    LPCWSTR lpExistingFileName,
    LPCWSTR lpNewFileName,
    BOOL bFailIfExists
    );

version(UNICODE) {
	alias CopyFileW CopyFile;
}
else {
	alias CopyFileA CopyFile;
}

alias DWORD function(
        LARGE_INTEGER TotalFileSize,
        LARGE_INTEGER TotalBytesTransferred,
        LARGE_INTEGER StreamSize,
        LARGE_INTEGER StreamBytesTransferred,
        DWORD dwStreamNumber,
        DWORD dwCallbackReason,
        HANDLE hSourceFile,
        HANDLE hDestinationFile,
    LPVOID lpData
    ) LPPROGRESS_ROUTINE;

BOOL
CopyFileExA(
        LPCSTR lpExistingFileName,
        LPCSTR lpNewFileName,
    LPPROGRESS_ROUTINE lpProgressRoutine,
    LPVOID lpData,
    LPBOOL pbCancel,
        DWORD dwCopyFlags
    );
BOOL
CopyFileExW(
        LPCWSTR lpExistingFileName,
        LPCWSTR lpNewFileName,
    LPPROGRESS_ROUTINE lpProgressRoutine,
    LPVOID lpData,
    LPBOOL pbCancel,
        DWORD dwCopyFlags
    );

version(UNICODE) {
	alias CopyFileExW CopyFileEx;
}
else {
	alias CopyFileExA CopyFileEx;
}

BOOL
CopyFileTransactedA(
        LPCSTR lpExistingFileName,
        LPCSTR lpNewFileName,
    LPPROGRESS_ROUTINE lpProgressRoutine,
    LPVOID lpData,
    LPBOOL pbCancel,
        DWORD dwCopyFlags,
        HANDLE hTransaction
    );
BOOL
CopyFileTransactedW(
        LPCWSTR lpExistingFileName,
        LPCWSTR lpNewFileName,
    LPPROGRESS_ROUTINE lpProgressRoutine,
    LPVOID lpData,
    LPBOOL pbCancel,
        DWORD dwCopyFlags,
        HANDLE hTransaction
    );

version(UNICODE) {
	alias CopyFileTransactedW CopyFileTransacted;
}
else {
	alias CopyFileTransactedA CopyFileTransacted;
}

BOOL
MoveFileA(
    LPCSTR lpExistingFileName,
    LPCSTR lpNewFileName
    );
BOOL
MoveFileW(
    LPCWSTR lpExistingFileName,
    LPCWSTR lpNewFileName
    );

version(UNICODE) {
	alias MoveFileW MoveFile;
}
else {
	alias MoveFileA MoveFile;
}

BOOL
MoveFileExA(
        LPCSTR lpExistingFileName,
    LPCSTR lpNewFileName,
        DWORD    dwFlags
    );
BOOL
MoveFileExW(
        LPCWSTR lpExistingFileName,
    LPCWSTR lpNewFileName,
        DWORD    dwFlags
    );

version(UNICODE) {
	alias MoveFileExW MoveFileEx;
}
else {
	alias MoveFileExA MoveFileEx;
}

BOOL MoveFileWithProgressA(
        LPCSTR lpExistingFileName,
    LPCSTR lpNewFileName,
    LPPROGRESS_ROUTINE lpProgressRoutine,
    LPVOID lpData,
        DWORD dwFlags
    );

BOOL MoveFileWithProgressW(
        LPCWSTR lpExistingFileName,
    LPCWSTR lpNewFileName,
    LPPROGRESS_ROUTINE lpProgressRoutine,
    LPVOID lpData,
        DWORD dwFlags
    );

version(UNICODE) {
	alias MoveFileWithProgressW MoveFileWithProgress;
}
else {
	alias MoveFileWithProgressA MoveFileWithProgress;
}

BOOL MoveFileTransactedA(
        LPCSTR lpExistingFileName,
    LPCSTR lpNewFileName,
    LPPROGRESS_ROUTINE lpProgressRoutine,
    LPVOID lpData,
        DWORD dwFlags,
        HANDLE hTransaction
    );

BOOL MoveFileTransactedW(
        LPCWSTR lpExistingFileName,
    LPCWSTR lpNewFileName,
    LPPROGRESS_ROUTINE lpProgressRoutine,
    LPVOID lpData,
        DWORD dwFlags,
        HANDLE hTransaction
    );

version(UNICODE) {
	alias MoveFileTransactedW MoveFileTransacted;
}
else {
	alias MoveFileTransactedA MoveFileTransacted;
}

const auto MOVEFILE_REPLACE_EXISTING        = 0x00000001;
const auto MOVEFILE_COPY_ALLOWED            = 0x00000002;
const auto MOVEFILE_DELAY_UNTIL_REBOOT      = 0x00000004;
const auto MOVEFILE_WRITE_THROUGH           = 0x00000008;

const auto MOVEFILE_CREATE_HARDLINK         = 0x00000010;
const auto MOVEFILE_FAIL_IF_NOT_TRACKABLE   = 0x00000020;

BOOL ReplaceFileA(
          LPCSTR  lpReplacedFileName,
          LPCSTR  lpReplacementFileName,
      LPCSTR  lpBackupFileName,
          DWORD   dwReplaceFlags,
    LPVOID  lpExclude,
    LPVOID  lpReserved
    );
BOOL
ReplaceFileW(
          LPCWSTR lpReplacedFileName,
          LPCWSTR lpReplacementFileName,
      LPCWSTR lpBackupFileName,
          DWORD   dwReplaceFlags,
    LPVOID  lpExclude,
    LPVOID  lpReserved
    );

version(UNICODE) {
	alias ReplaceFileW ReplaceFile;
}
else {
	alias ReplaceFileA ReplaceFile;
}


//
// API call to create hard links.
//

BOOL
CreateHardLinkA(
          LPCSTR lpFileName,
          LPCSTR lpExistingFileName,
    LPSECURITY_ATTRIBUTES lpSecurityAttributes
    );
BOOL
CreateHardLinkW(
          LPCWSTR lpFileName,
          LPCWSTR lpExistingFileName,
    LPSECURITY_ATTRIBUTES lpSecurityAttributes
    );

version(UNICODE) {
	alias CreateHardLinkW CreateHardLink;
}
else {
	alias CreateHardLinkA CreateHardLink;
}


//
// API call to create hard links.
//

BOOL
CreateHardLinkTransactedA(
          LPCSTR lpFileName,
          LPCSTR lpExistingFileName,
    LPSECURITY_ATTRIBUTES lpSecurityAttributes,
          HANDLE hTransaction
    );
BOOL
CreateHardLinkTransactedW(
          LPCWSTR lpFileName,
          LPCWSTR lpExistingFileName,
    LPSECURITY_ATTRIBUTES lpSecurityAttributes,
          HANDLE hTransaction
    );

version(UNICODE) {
	alias CreateHardLinkTransactedW CreateHardLinkTransacted;
}
else {
	alias CreateHardLinkTransactedA CreateHardLinkTransacted;
}




//
// API call to enumerate for streams within a file
//

enum STREAM_INFO_LEVELS {

    FindStreamInfoStandard,
    FindStreamInfoMaxInfoLevel

} 

struct WIN32_FIND_STREAM_DATA {

    LARGE_INTEGER StreamSize;
    WCHAR cStreamName[ MAX_PATH + 36 ];

}

alias WIN32_FIND_STREAM_DATA* PWIN32_FIND_STREAM_DATA;


HANDLE
FindFirstStreamW(
          LPCWSTR lpFileName,
          STREAM_INFO_LEVELS InfoLevel,
         LPVOID lpFindStreamData,
    DWORD dwFlags
    );

BOOL

FindNextStreamW(
     HANDLE hFindStream,
    LPVOID lpFindStreamData
    );


HANDLE
FindFirstFileNameW (
       LPCWSTR lpFileName,
       DWORD dwFlags,
    LPDWORD StringLength,
    PWCHAR LinkName
    );

BOOL

FindNextFileNameW (
       HANDLE hFindStream,
    LPDWORD StringLength,PWCHAR LinkName
    );

HANDLE
FindFirstFileNameTransactedW (
        LPCWSTR lpFileName,
        DWORD dwFlags,
     LPDWORD StringLength,PWCHAR LinkName,
    HANDLE hTransaction
    );





HANDLE
CreateNamedPipeA(
        LPCSTR lpName,
        DWORD dwOpenMode,
        DWORD dwPipeMode,
        DWORD nMaxInstances,
        DWORD nOutBufferSize,
        DWORD nInBufferSize,
        DWORD nDefaultTimeOut,
    LPSECURITY_ATTRIBUTES lpSecurityAttributes
    );

HANDLE
CreateNamedPipeW(
        LPCWSTR lpName,
        DWORD dwOpenMode,
        DWORD dwPipeMode,
        DWORD nMaxInstances,
        DWORD nOutBufferSize,
        DWORD nInBufferSize,
        DWORD nDefaultTimeOut,
    LPSECURITY_ATTRIBUTES lpSecurityAttributes
    );

version(UNICODE) {
	alias CreateNamedPipeW CreateNamedPipe;
}
else {
	alias CreateNamedPipeA CreateNamedPipe;
}

BOOL
GetNamedPipeHandleStateA(
         HANDLE hNamedPipe,
     LPDWORD lpState,
     LPDWORD lpCurInstances,
     LPDWORD lpMaxCollectionCount,
     LPDWORD lpCollectDataTimeout,
    LPSTR lpUserName,
         DWORD nMaxUserNameSize
    );
BOOL
GetNamedPipeHandleStateW(
         HANDLE hNamedPipe,
     LPDWORD lpState,
     LPDWORD lpCurInstances,
     LPDWORD lpMaxCollectionCount,
     LPDWORD lpCollectDataTimeout,
    LPWSTR lpUserName,
         DWORD nMaxUserNameSize
    );

version(UNICODE) {
	alias GetNamedPipeHandleStateW GetNamedPipeHandleState;
}
else {
	alias GetNamedPipeHandleStateA GetNamedPipeHandleState;
}

BOOL
CallNamedPipeA(
     LPCSTR lpNamedPipeName,
	 LPVOID lpInBuffer,
     DWORD nInBufferSize,
    LPVOID lpOutBuffer,
     DWORD nOutBufferSize,
    LPDWORD lpBytesRead,
     DWORD nTimeOut
    );
BOOL
CallNamedPipeW(
     LPCWSTR lpNamedPipeName,
	 LPVOID lpInBuffer,
     DWORD nInBufferSize,
    LPVOID lpOutBuffer,
     DWORD nOutBufferSize,
    LPDWORD lpBytesRead,
     DWORD nTimeOut
    );

version(UNICODE) {
	alias CallNamedPipeW CallNamedPipe;
}
else {
	alias CallNamedPipeA CallNamedPipe;
}

BOOL
WaitNamedPipeA(
    LPCSTR lpNamedPipeName,
    DWORD nTimeOut
    );
BOOL
WaitNamedPipeW(
    LPCWSTR lpNamedPipeName,
    DWORD nTimeOut
    );

version(UNICODE) {
	alias WaitNamedPipeW WaitNamedPipe;
}
else {
	alias WaitNamedPipeA WaitNamedPipe;
}

enum PIPE_ATTRIBUTE_TYPE{
    PipeAttribute,
    PipeConnectionAttribute,
    PipeHandleAttribute
}

BOOL
GetNamedPipeAttribute(
    HANDLE Pipe,
    PIPE_ATTRIBUTE_TYPE AttributeType,
    PSTR AttributeName,
    PVOID AttributeValue,
    PSIZE_T AttributeValueLength
    );

BOOL
SetNamedPipeAttribute(
    HANDLE Pipe,
    PIPE_ATTRIBUTE_TYPE AttributeType,
    PSTR AttributeName,
    PVOID AttributeValue,
    SIZE_T AttributeValueLength
    );

BOOL
GetNamedPipeClientComputerNameA(
    HANDLE Pipe,
    LPSTR ClientComputerName,
    ULONG ClientComputerNameLength
    );
BOOL
GetNamedPipeClientComputerNameW(
    HANDLE Pipe,
    LPWSTR ClientComputerName,
    ULONG ClientComputerNameLength
    );

version(UNICODE) {
	alias GetNamedPipeClientComputerNameW GetNamedPipeClientComputerName;
}
else {
	alias GetNamedPipeClientComputerNameA GetNamedPipeClientComputerName;
}

BOOL
GetNamedPipeClientProcessId(
    HANDLE Pipe,
    PULONG ClientProcessId
    );

BOOL
GetNamedPipeClientSessionId(
    HANDLE Pipe,
    PULONG ClientSessionId
    );

BOOL
GetNamedPipeServerProcessId(
    HANDLE Pipe,
    PULONG ServerProcessId
    );

BOOL
GetNamedPipeServerSessionId(
    HANDLE Pipe,
    PULONG ServerSessionId
    );

BOOL
SetVolumeLabelA(
    LPCSTR lpRootPathName,
    LPCSTR lpVolumeName
    );
BOOL
SetVolumeLabelW(
    LPCWSTR lpRootPathName,
    LPCWSTR lpVolumeName
    );

version(UNICODE) {
	alias SetVolumeLabelW SetVolumeLabel;
}
else {
	alias SetVolumeLabelA SetVolumeLabel;
}

VOID SetFileApisToOEM();

VOID SetFileApisToANSI();

BOOL AreFileApisANSI();

BOOL
GetVolumeInformationA(
     LPCSTR lpRootPathName,
    LPSTR lpVolumeNameBuffer,
         DWORD nVolumeNameSize,
     LPDWORD lpVolumeSerialNumber,
     LPDWORD lpMaximumComponentLength,
     LPDWORD lpFileSystemFlags,
    LPSTR lpFileSystemNameBuffer,
         DWORD nFileSystemNameSize
    );
BOOL
GetVolumeInformationW(
     LPCWSTR lpRootPathName,
    LPWSTR lpVolumeNameBuffer,
         DWORD nVolumeNameSize,
     LPDWORD lpVolumeSerialNumber,
     LPDWORD lpMaximumComponentLength,
     LPDWORD lpFileSystemFlags,
    LPWSTR lpFileSystemNameBuffer,
         DWORD nFileSystemNameSize
    );

version(UNICODE) {
	alias GetVolumeInformationW GetVolumeInformation;
}
else {
	alias GetVolumeInformationA GetVolumeInformation;
}

BOOL
GetVolumeInformationByHandleW(
         HANDLE hFile,
    LPWSTR lpVolumeNameBuffer,
         DWORD nVolumeNameSize,
     LPDWORD lpVolumeSerialNumber,
     LPDWORD lpMaximumComponentLength,
     LPDWORD lpFileSystemFlags,
    LPWSTR lpFileSystemNameBuffer,
         DWORD nFileSystemNameSize
    );

BOOL
CancelSynchronousIo(
    HANDLE hThread
    );

BOOL
CancelIoEx(
    HANDLE hFile,
    LPOVERLAPPED lpOverlapped
    );

BOOL
CancelIo(
    HANDLE hFile
    );

BOOL
SetFileBandwidthReservation(
     HANDLE  hFile,
     DWORD   nPeriodMilliseconds,
     DWORD   nBytesPerPeriod,
     BOOL    bDiscardable,
    LPDWORD lpTransferSize,
    LPDWORD lpNumOutstandingRequests
    );

BOOL
GetFileBandwidthReservation(
     HANDLE  hFile,
    LPDWORD lpPeriodMilliseconds,
    LPDWORD lpBytesPerPeriod,
    LPBOOL  pDiscardable,
    LPDWORD lpTransferSize,
    LPDWORD lpNumOutstandingRequests
    );

//
// Event logging APIs
//


BOOL
ClearEventLogA (
        HANDLE hEventLog,
    LPCSTR lpBackupFileName
    );

BOOL
ClearEventLogW (
        HANDLE hEventLog,
    LPCWSTR lpBackupFileName
    );

version(UNICODE) {
	alias ClearEventLogW ClearEventLog;
}
else {
	alias ClearEventLogA ClearEventLog;
}


BOOL
BackupEventLogA (
    HANDLE hEventLog,
    LPCSTR lpBackupFileName
    );

BOOL
BackupEventLogW (
    HANDLE hEventLog,
    LPCWSTR lpBackupFileName
    );

version(UNICODE) {
	alias BackupEventLogW BackupEventLog;
}
else {
	alias BackupEventLogA BackupEventLog;
}


BOOL
CloseEventLog (
    HANDLE hEventLog
    );


BOOL
DeregisterEventSource (
    HANDLE hEventLog
    );


BOOL
NotifyChangeEventLog(
    HANDLE  hEventLog,
    HANDLE  hEvent
    );


BOOL
GetNumberOfEventLogRecords (
     HANDLE hEventLog,
    PDWORD NumberOfRecords
    );


BOOL
GetOldestEventLogRecord (
     HANDLE hEventLog,
    PDWORD OldestRecord
    );



HANDLE
OpenEventLogA (
    LPCSTR lpUNCServerName,
        LPCSTR lpSourceName
    );


HANDLE
OpenEventLogW (
    LPCWSTR lpUNCServerName,
        LPCWSTR lpSourceName
    );

version(UNICODE) {
	alias OpenEventLogW OpenEventLog;
}
else {
	alias OpenEventLogA OpenEventLog;
}



HANDLE
RegisterEventSourceA (
    LPCSTR lpUNCServerName,
        LPCSTR lpSourceName
    );


HANDLE
RegisterEventSourceW (
    LPCWSTR lpUNCServerName,
        LPCWSTR lpSourceName
    );

version(UNICODE) {
	alias RegisterEventSourceW RegisterEventSource;
}
else {
	alias RegisterEventSourceA RegisterEventSource;
}



HANDLE
OpenBackupEventLogA (
    LPCSTR lpUNCServerName,
        LPCSTR lpFileName
    );


HANDLE
OpenBackupEventLogW (
    LPCWSTR lpUNCServerName,
        LPCWSTR lpFileName
    );

version(UNICODE) {
	alias OpenBackupEventLogW OpenBackupEventLog;
}
else {
	alias OpenBackupEventLogA OpenBackupEventLog;
}


BOOL
ReadEventLogA (
     HANDLE     hEventLog,
     DWORD      dwReadFlags,
     DWORD      dwRecordOffset,
    LPVOID     lpBuffer,
     DWORD      nNumberOfBytesToRead,
    DWORD      *pnBytesRead,
    DWORD      *pnMinNumberOfBytesNeeded
    );

BOOL
ReadEventLogW (
     HANDLE     hEventLog,
     DWORD      dwReadFlags,
     DWORD      dwRecordOffset,
    LPVOID     lpBuffer,
     DWORD      nNumberOfBytesToRead,
    DWORD      *pnBytesRead,
    DWORD      *pnMinNumberOfBytesNeeded
    );

version(UNICODE) {
	alias ReadEventLogW ReadEventLog;
}
else {
	alias ReadEventLogA ReadEventLog;
}


BOOL
ReportEventA (
        HANDLE     hEventLog,
        WORD       wType,
        WORD       wCategory,
        DWORD      dwEventID,
    PSID       lpUserSid,
        WORD       wNumStrings,
        DWORD      dwDataSize,
    LPCSTR *lpStrings,
    LPVOID lpRawData
    );

BOOL
ReportEventW (
        HANDLE     hEventLog,
        WORD       wType,
        WORD       wCategory,
        DWORD      dwEventID,
    PSID       lpUserSid,
        WORD       wNumStrings,
        DWORD      dwDataSize,
    LPCWSTR *lpStrings,
	LPVOID lpRawData
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

alias EVENTLOG_FULL_INFORMATION* LPEVENTLOG_FULL_INFORMATION;


BOOL
GetEventLogInformation (
     HANDLE     hEventLog,
     DWORD      dwInfoLevel,
    LPVOID lpBuffer,
     DWORD      cbBufSize,
    LPDWORD    pcbBytesNeeded
    );

//
//
// Security APIs
//



BOOL
DuplicateToken(
           HANDLE ExistingTokenHandle,
           SECURITY_IMPERSONATION_LEVEL ImpersonationLevel,
    PHANDLE DuplicateTokenHandle
    );


BOOL
GetKernelObjectSecurity (
     HANDLE Handle,
     SECURITY_INFORMATION RequestedInformation,
    PSECURITY_DESCRIPTOR pSecurityDescriptor,
     DWORD nLength,
    LPDWORD lpnLengthNeeded
    );


BOOL
ImpersonateNamedPipeClient(
    HANDLE hNamedPipe
    );


BOOL
ImpersonateSelf(
    SECURITY_IMPERSONATION_LEVEL ImpersonationLevel
    );



BOOL
RevertToSelf ();


BOOL

SetThreadToken (
    PHANDLE Thread,
    HANDLE Token
    );


BOOL
AccessCheck (
       PSECURITY_DESCRIPTOR pSecurityDescriptor,
       HANDLE ClientToken,
       DWORD DesiredAccess,
       PGENERIC_MAPPING GenericMapping,
    PPRIVILEGE_SET PrivilegeSet,
    LPDWORD PrivilegeSetLength,
      LPDWORD GrantedAccess,
      LPBOOL AccessStatus
    );


BOOL
AccessCheckByType (
        PSECURITY_DESCRIPTOR pSecurityDescriptor,
    PSID PrincipalSelfSid,
        HANDLE ClientToken,
        DWORD DesiredAccess,
    POBJECT_TYPE_LIST ObjectTypeList,
        DWORD ObjectTypeListLength,
        PGENERIC_MAPPING GenericMapping,
    PPRIVILEGE_SET PrivilegeSet,
     LPDWORD PrivilegeSetLength,
       LPDWORD GrantedAccess,
       LPBOOL AccessStatus
    );


BOOL
AccessCheckByTypeResultList (
        PSECURITY_DESCRIPTOR pSecurityDescriptor,
    PSID PrincipalSelfSid,
        HANDLE ClientToken,
        DWORD DesiredAccess,
		POBJECT_TYPE_LIST ObjectTypeList,
        DWORD ObjectTypeListLength,
        PGENERIC_MAPPING GenericMapping,
    PPRIVILEGE_SET PrivilegeSet,
     LPDWORD PrivilegeSetLength,
       LPDWORD GrantedAccessList,
       LPDWORD AccessStatusList
    );



BOOL
OpenProcessToken (
           HANDLE ProcessHandle,
           DWORD DesiredAccess,
    PHANDLE TokenHandle
    );



BOOL
OpenThreadToken (
           HANDLE ThreadHandle,
           DWORD DesiredAccess,
           BOOL OpenAsSelf,
    PHANDLE TokenHandle
    );



BOOL
GetTokenInformation (
         HANDLE TokenHandle,
         TOKEN_INFORMATION_CLASS TokenInformationClass,
    LPVOID TokenInformation,
         DWORD TokenInformationLength,
        PDWORD ReturnLength
    );



BOOL
SetTokenInformation (
    HANDLE TokenHandle,
    TOKEN_INFORMATION_CLASS TokenInformationClass,
    LPVOID TokenInformation,
    DWORD TokenInformationLength
    );



BOOL
AdjustTokenPrivileges (
         HANDLE TokenHandle,
         BOOL DisableAllPrivileges,
     PTOKEN_PRIVILEGES NewState,
         DWORD BufferLength,
    PTOKEN_PRIVILEGES PreviousState,
     PDWORD ReturnLength
    );



BOOL
AdjustTokenGroups (
         HANDLE TokenHandle,
         BOOL ResetToDefault,
     PTOKEN_GROUPS NewState,
         DWORD BufferLength,
    PTOKEN_GROUPS PreviousState,
     PDWORD ReturnLength
    );



BOOL
PrivilegeCheck (
       HANDLE ClientToken,
    PPRIVILEGE_SET RequiredPrivileges,
      LPBOOL pfResult
    );



BOOL
AccessCheckAndAuditAlarmA (
        LPCSTR SubsystemName,
    LPVOID HandleId,
        LPSTR ObjectTypeName,
    LPSTR ObjectName,
        PSECURITY_DESCRIPTOR SecurityDescriptor,
        DWORD DesiredAccess,
        PGENERIC_MAPPING GenericMapping,
        BOOL ObjectCreation,
       LPDWORD GrantedAccess,
       LPBOOL AccessStatus,
       LPBOOL pfGenerateOnClose
    );

BOOL
AccessCheckAndAuditAlarmW (
        LPCWSTR SubsystemName,
    LPVOID HandleId,
        LPWSTR ObjectTypeName,
    LPWSTR ObjectName,
        PSECURITY_DESCRIPTOR SecurityDescriptor,
        DWORD DesiredAccess,
        PGENERIC_MAPPING GenericMapping,
        BOOL ObjectCreation,
       LPDWORD GrantedAccess,
       LPBOOL AccessStatus,
       LPBOOL pfGenerateOnClose
    );

version(UNICODE) {
	alias AccessCheckAndAuditAlarmW AccessCheckAndAuditAlarm;
}
else {
	alias AccessCheckAndAuditAlarmA AccessCheckAndAuditAlarm;
}



BOOL
AccessCheckByTypeAndAuditAlarmA (
        LPCSTR SubsystemName,
        LPVOID HandleId,
        LPCSTR ObjectTypeName,
    LPCSTR ObjectName,
        PSECURITY_DESCRIPTOR SecurityDescriptor,
    PSID PrincipalSelfSid,
        DWORD DesiredAccess,
        AUDIT_EVENT_TYPE AuditType,
        DWORD Flags,
    POBJECT_TYPE_LIST ObjectTypeList,
        DWORD ObjectTypeListLength,
        PGENERIC_MAPPING GenericMapping,
        BOOL ObjectCreation,
       LPDWORD GrantedAccess,
       LPBOOL AccessStatus,
       LPBOOL pfGenerateOnClose
    );

BOOL
AccessCheckByTypeAndAuditAlarmW (
        LPCWSTR SubsystemName,
        LPVOID HandleId,
        LPCWSTR ObjectTypeName,
    LPCWSTR ObjectName,
        PSECURITY_DESCRIPTOR SecurityDescriptor,
    PSID PrincipalSelfSid,
        DWORD DesiredAccess,
        AUDIT_EVENT_TYPE AuditType,
        DWORD Flags,
    POBJECT_TYPE_LIST ObjectTypeList,
        DWORD ObjectTypeListLength,
        PGENERIC_MAPPING GenericMapping,
        BOOL ObjectCreation,
       LPDWORD GrantedAccess,
       LPBOOL AccessStatus,
       LPBOOL pfGenerateOnClose
    );

version(UNICODE) {
	alias AccessCheckByTypeAndAuditAlarmW AccessCheckByTypeAndAuditAlarm;
}
else {
	alias AccessCheckByTypeAndAuditAlarmA AccessCheckByTypeAndAuditAlarm;
}


BOOL
AccessCheckByTypeResultListAndAuditAlarmA (
        LPCSTR SubsystemName,
        LPVOID HandleId,
        LPCSTR ObjectTypeName,
    LPCSTR ObjectName,
        PSECURITY_DESCRIPTOR SecurityDescriptor,
    PSID PrincipalSelfSid,
        DWORD DesiredAccess,
        AUDIT_EVENT_TYPE AuditType,
        DWORD Flags,
    POBJECT_TYPE_LIST ObjectTypeList,
        DWORD ObjectTypeListLength,
        PGENERIC_MAPPING GenericMapping,
        BOOL ObjectCreation,
       LPDWORD GrantedAccess,
       LPDWORD AccessStatusList,
       LPBOOL pfGenerateOnClose
    );

BOOL
AccessCheckByTypeResultListAndAuditAlarmW (
        LPCWSTR SubsystemName,
        LPVOID HandleId,
        LPCWSTR ObjectTypeName,
    LPCWSTR ObjectName,
        PSECURITY_DESCRIPTOR SecurityDescriptor,
    PSID PrincipalSelfSid,
        DWORD DesiredAccess,
        AUDIT_EVENT_TYPE AuditType,
        DWORD Flags,
    POBJECT_TYPE_LIST ObjectTypeList,
        DWORD ObjectTypeListLength,
        PGENERIC_MAPPING GenericMapping,
        BOOL ObjectCreation,
       LPDWORD GrantedAccess,
       LPDWORD AccessStatusList,
       LPBOOL pfGenerateOnClose
    );

version(UNICODE) {
	alias AccessCheckByTypeResultListAndAuditAlarmW AccessCheckByTypeResultListAndAuditAlarm;
}
else {
	alias AccessCheckByTypeResultListAndAuditAlarmA AccessCheckByTypeResultListAndAuditAlarm;
}


BOOL
AccessCheckByTypeResultListAndAuditAlarmByHandleA (
        LPCSTR SubsystemName,
        LPVOID HandleId,
        HANDLE ClientToken,
        LPCSTR ObjectTypeName,
    LPCSTR ObjectName,
        PSECURITY_DESCRIPTOR SecurityDescriptor,
    PSID PrincipalSelfSid,
        DWORD DesiredAccess,
        AUDIT_EVENT_TYPE AuditType,
        DWORD Flags,
    POBJECT_TYPE_LIST ObjectTypeList,
        DWORD ObjectTypeListLength,
        PGENERIC_MAPPING GenericMapping,
        BOOL ObjectCreation,
       LPDWORD GrantedAccess,
       LPDWORD AccessStatusList,
       LPBOOL pfGenerateOnClose
    );

BOOL
AccessCheckByTypeResultListAndAuditAlarmByHandleW (
        LPCWSTR SubsystemName,
        LPVOID HandleId,
        HANDLE ClientToken,
        LPCWSTR ObjectTypeName,
    LPCWSTR ObjectName,
        PSECURITY_DESCRIPTOR SecurityDescriptor,
    PSID PrincipalSelfSid,
        DWORD DesiredAccess,
        AUDIT_EVENT_TYPE AuditType,
        DWORD Flags,
    POBJECT_TYPE_LIST ObjectTypeList,
        DWORD ObjectTypeListLength,
        PGENERIC_MAPPING GenericMapping,
        BOOL ObjectCreation,
       LPDWORD GrantedAccess,
       LPDWORD AccessStatusList,
       LPBOOL pfGenerateOnClose
    );

version(UNICODE) {
	alias AccessCheckByTypeResultListAndAuditAlarmByHandleW AccessCheckByTypeResultListAndAuditAlarmByHandle;
}
else {
	alias AccessCheckByTypeResultListAndAuditAlarmByHandleA AccessCheckByTypeResultListAndAuditAlarmByHandle;
}



BOOL
ObjectOpenAuditAlarmA (
        LPCSTR SubsystemName,
        LPVOID HandleId,
        LPSTR ObjectTypeName,
    LPSTR ObjectName,
        PSECURITY_DESCRIPTOR pSecurityDescriptor,
        HANDLE ClientToken,
        DWORD DesiredAccess,
        DWORD GrantedAccess,
    PPRIVILEGE_SET Privileges,
        BOOL ObjectCreation,
        BOOL AccessGranted,
       LPBOOL GenerateOnClose
    );

BOOL
ObjectOpenAuditAlarmW (
        LPCWSTR SubsystemName,
        LPVOID HandleId,
        LPWSTR ObjectTypeName,
    LPWSTR ObjectName,
        PSECURITY_DESCRIPTOR pSecurityDescriptor,
        HANDLE ClientToken,
        DWORD DesiredAccess,
        DWORD GrantedAccess,
    PPRIVILEGE_SET Privileges,
        BOOL ObjectCreation,
        BOOL AccessGranted,
       LPBOOL GenerateOnClose
    );

version(UNICODE) {
	alias ObjectOpenAuditAlarmW ObjectOpenAuditAlarm;
}
else {
	alias ObjectOpenAuditAlarmA ObjectOpenAuditAlarm;
}



BOOL
ObjectPrivilegeAuditAlarmA (
    LPCSTR SubsystemName,
    LPVOID HandleId,
    HANDLE ClientToken,
    DWORD DesiredAccess,
    PPRIVILEGE_SET Privileges,
    BOOL AccessGranted
    );

BOOL
ObjectPrivilegeAuditAlarmW (
    LPCWSTR SubsystemName,
    LPVOID HandleId,
    HANDLE ClientToken,
    DWORD DesiredAccess,
    PPRIVILEGE_SET Privileges,
    BOOL AccessGranted
    );

version(UNICODE) {
	alias ObjectPrivilegeAuditAlarmW ObjectPrivilegeAuditAlarm;
}
else {
	alias ObjectPrivilegeAuditAlarmA ObjectPrivilegeAuditAlarm;
}



BOOL
ObjectCloseAuditAlarmA (
    LPCSTR SubsystemName,
    LPVOID HandleId,
    BOOL GenerateOnClose
    );

BOOL
ObjectCloseAuditAlarmW (
    LPCWSTR SubsystemName,
    LPVOID HandleId,
    BOOL GenerateOnClose
    );

version(UNICODE) {
	alias ObjectCloseAuditAlarmW ObjectCloseAuditAlarm;
}
else {
	alias ObjectCloseAuditAlarmA ObjectCloseAuditAlarm;
}



BOOL
ObjectDeleteAuditAlarmA (
    LPCSTR SubsystemName,
    LPVOID HandleId,
    BOOL GenerateOnClose
    );

BOOL
ObjectDeleteAuditAlarmW (
    LPCWSTR SubsystemName,
    LPVOID HandleId,
    BOOL GenerateOnClose
    );

version(UNICODE) {
	alias ObjectDeleteAuditAlarmW ObjectDeleteAuditAlarm;
}
else {
	alias ObjectDeleteAuditAlarmA ObjectDeleteAuditAlarm;
}



BOOL
PrivilegedServiceAuditAlarmA (
    LPCSTR SubsystemName,
    LPCSTR ServiceName,
    HANDLE ClientToken,
    PPRIVILEGE_SET Privileges,
    BOOL AccessGranted
    );

BOOL
PrivilegedServiceAuditAlarmW (
    LPCWSTR SubsystemName,
    LPCWSTR ServiceName,
    HANDLE ClientToken,
    PPRIVILEGE_SET Privileges,
    BOOL AccessGranted
    );

version(UNICODE) {
	alias PrivilegedServiceAuditAlarmW PrivilegedServiceAuditAlarm;
}
else {
	alias PrivilegedServiceAuditAlarmA PrivilegedServiceAuditAlarm;
}






BOOL
IsWellKnownSid (
    PSID pSid,
    WELL_KNOWN_SID_TYPE WellKnownSidType
    );


BOOL
CreateWellKnownSid(
        WELL_KNOWN_SID_TYPE WellKnownSidType,
    PSID DomainSid,
    PSID pSid,
     DWORD *cbSid
    );


BOOL
EqualDomainSid(
     PSID pSid1,
     PSID pSid2,
    BOOL *pfEqual
    );


BOOL
GetWindowsAccountDomainSid(
       PSID pSid,
    PSID pDomainSid,
    DWORD* cbDomainSid
    );



BOOL
IsValidSid (
    PSID pSid
    );



BOOL
EqualSid (
    PSID pSid1,
    PSID pSid2
    );



BOOL
EqualPrefixSid (
    PSID pSid1,
    PSID pSid2
    );



DWORD
GetSidLengthRequired (
    UCHAR nSubAuthorityCount
    );



BOOL
AllocateAndInitializeSid (
           PSID_IDENTIFIER_AUTHORITY pIdentifierAuthority,
           BYTE nSubAuthorityCount,
           DWORD nSubAuthority0,
           DWORD nSubAuthority1,
           DWORD nSubAuthority2,
           DWORD nSubAuthority3,
           DWORD nSubAuthority4,
           DWORD nSubAuthority5,
           DWORD nSubAuthority6,
           DWORD nSubAuthority7,
    PSID *pSid
    );


PVOID
FreeSid(
    PSID pSid
    );


BOOL
InitializeSid (
    PSID Sid,
     PSID_IDENTIFIER_AUTHORITY pIdentifierAuthority,
     BYTE nSubAuthorityCount
    );




PSID_IDENTIFIER_AUTHORITY
GetSidIdentifierAuthority (
    PSID pSid
    );




PDWORD
GetSidSubAuthority (
    PSID pSid,
    DWORD nSubAuthority
    );




PUCHAR
GetSidSubAuthorityCount (
    PSID pSid
    );



DWORD
GetLengthSid (
    PSID pSid
    );



BOOL
CopySid (
    DWORD nDestinationSidLength,
	PSID pDestinationSid,
    PSID pSourceSid
    );



BOOL
AreAllAccessesGranted (
    DWORD GrantedAccess,
    DWORD DesiredAccess
    );



BOOL
AreAnyAccessesGranted (
    DWORD GrantedAccess,
    DWORD DesiredAccess
    );



VOID
MapGenericMask (
    PDWORD AccessMask,
       PGENERIC_MAPPING GenericMapping
    );



BOOL
IsValidAcl (
    PACL pAcl
    );



BOOL
InitializeAcl (
    PACL pAcl,
    DWORD nAclLength,
    DWORD dwAclRevision
    );



BOOL
GetAclInformation (
    PACL pAcl,
    LPVOID pAclInformation,
    DWORD nAclInformationLength,
    ACL_INFORMATION_CLASS dwAclInformationClass
    );



BOOL
SetAclInformation (
    PACL pAcl,
    LPVOID pAclInformation,
       DWORD nAclInformationLength,
       ACL_INFORMATION_CLASS dwAclInformationClass
    );



BOOL
AddAce (
    PACL pAcl,
       DWORD dwAceRevision,
       DWORD dwStartingAceIndex,
    LPVOID pAceList,
       DWORD nAceListLength
    );



BOOL
DeleteAce (
    PACL pAcl,
       DWORD dwAceIndex
    );



BOOL
GetAce (
           PACL pAcl,
           DWORD dwAceIndex,
    LPVOID *pAce
    );



BOOL
AddAccessAllowedAce (
    PACL pAcl,
       DWORD dwAceRevision,
       DWORD AccessMask,
       PSID pSid
    );


BOOL
AddAccessAllowedAceEx (
    PACL pAcl,
       DWORD dwAceRevision,
       DWORD AceFlags,
       DWORD AccessMask,
       PSID pSid
    );


BOOL
AddMandatoryAce (
    PACL pAcl,
       DWORD dwAceRevision,
       DWORD AceFlags,
       DWORD MandatoryPolicy,
       PSID pLabelSid
    );


BOOL
AddAccessDeniedAce (
    PACL pAcl,
       DWORD dwAceRevision,
       DWORD AccessMask,
       PSID pSid
    );


BOOL
AddAccessDeniedAceEx (
    PACL pAcl,
       DWORD dwAceRevision,
       DWORD AceFlags,
       DWORD AccessMask,
       PSID pSid
    );


BOOL
AddAuditAccessAce(
    PACL pAcl,
       DWORD dwAceRevision,
       DWORD dwAccessMask,
       PSID pSid,
       BOOL bAuditSuccess,
       BOOL bAuditFailure
    );


BOOL
AddAuditAccessAceEx(
    PACL pAcl,
       DWORD dwAceRevision,
       DWORD AceFlags,
       DWORD dwAccessMask,
       PSID pSid,
       BOOL bAuditSuccess,
       BOOL bAuditFailure
    );


BOOL
AddAccessAllowedObjectAce (
     PACL pAcl,
        DWORD dwAceRevision,
        DWORD AceFlags,
        DWORD AccessMask,
    GUID *ObjectTypeGuid,
    GUID *InheritedObjectTypeGuid,
        PSID pSid
    );


BOOL
AddAccessDeniedObjectAce (
     PACL pAcl,
        DWORD dwAceRevision,
        DWORD AceFlags,
        DWORD AccessMask,
    GUID *ObjectTypeGuid,
    GUID *InheritedObjectTypeGuid,
        PSID pSid
    );


BOOL
AddAuditAccessObjectAce (
     PACL pAcl,
        DWORD dwAceRevision,
        DWORD AceFlags,
        DWORD AccessMask,
    GUID *ObjectTypeGuid,
    GUID *InheritedObjectTypeGuid,
        PSID pSid,
        BOOL bAuditSuccess,
        BOOL bAuditFailure
    );


BOOL
FindFirstFreeAce (
           PACL pAcl,
    LPVOID *pAce
    );



BOOL
InitializeSecurityDescriptor (
    PSECURITY_DESCRIPTOR pSecurityDescriptor,
     DWORD dwRevision
    );



BOOL
IsValidSecurityDescriptor (
    PSECURITY_DESCRIPTOR pSecurityDescriptor
    );


BOOL
IsValidRelativeSecurityDescriptor (
    PSECURITY_DESCRIPTOR pSecurityDescriptor,
    ULONG SecurityDescriptorLength,
    SECURITY_INFORMATION RequiredInformation
    );


DWORD
GetSecurityDescriptorLength (
    PSECURITY_DESCRIPTOR pSecurityDescriptor
    );



BOOL
GetSecurityDescriptorControl (
     PSECURITY_DESCRIPTOR pSecurityDescriptor,
    PSECURITY_DESCRIPTOR_CONTROL pControl,
    LPDWORD lpdwRevision
    );


BOOL
SetSecurityDescriptorControl (
    PSECURITY_DESCRIPTOR pSecurityDescriptor,
    SECURITY_DESCRIPTOR_CONTROL ControlBitsOfInterest,
    SECURITY_DESCRIPTOR_CONTROL ControlBitsToSet
    );


BOOL
SetSecurityDescriptorDacl (
     PSECURITY_DESCRIPTOR pSecurityDescriptor,
        BOOL bDaclPresent,
    PACL pDacl,
        BOOL bDaclDefaulted
    );



BOOL
GetSecurityDescriptorDacl (
           PSECURITY_DESCRIPTOR pSecurityDescriptor,
          LPBOOL lpbDaclPresent,
    PACL *pDacl,
          LPBOOL lpbDaclDefaulted
    );



BOOL
SetSecurityDescriptorSacl (
     PSECURITY_DESCRIPTOR pSecurityDescriptor,
        BOOL bSaclPresent,
    PACL pSacl,
        BOOL bSaclDefaulted
    );



BOOL
GetSecurityDescriptorSacl (
           PSECURITY_DESCRIPTOR pSecurityDescriptor,
          LPBOOL lpbSaclPresent,
    PACL *pSacl,
          LPBOOL lpbSaclDefaulted
    );



BOOL
SetSecurityDescriptorOwner (
     PSECURITY_DESCRIPTOR pSecurityDescriptor,
    PSID pOwner,
        BOOL bOwnerDefaulted
    );



BOOL
GetSecurityDescriptorOwner (
           PSECURITY_DESCRIPTOR pSecurityDescriptor,
    PSID *pOwner,
          LPBOOL lpbOwnerDefaulted
    );



BOOL
SetSecurityDescriptorGroup (
     PSECURITY_DESCRIPTOR pSecurityDescriptor,
    PSID pGroup,
        BOOL bGroupDefaulted
    );



BOOL
GetSecurityDescriptorGroup (
           PSECURITY_DESCRIPTOR pSecurityDescriptor,
    PSID *pGroup,
          LPBOOL lpbGroupDefaulted
    );



DWORD
SetSecurityDescriptorRMControl(
     PSECURITY_DESCRIPTOR SecurityDescriptor,
    PUCHAR RMControl
    );


DWORD
GetSecurityDescriptorRMControl(
     PSECURITY_DESCRIPTOR SecurityDescriptor,
    PUCHAR RMControl
    );


BOOL
CreatePrivateObjectSecurity (
       PSECURITY_DESCRIPTOR ParentDescriptor,
       PSECURITY_DESCRIPTOR CreatorDescriptor,
    PSECURITY_DESCRIPTOR * NewDescriptor,
           BOOL IsDirectoryObject,
       HANDLE Token,
           PGENERIC_MAPPING GenericMapping
    );



BOOL
ConvertToAutoInheritPrivateObjectSecurity(
       PSECURITY_DESCRIPTOR ParentDescriptor,
           PSECURITY_DESCRIPTOR CurrentSecurityDescriptor,
    PSECURITY_DESCRIPTOR *NewSecurityDescriptor,
       GUID *ObjectType,
           BOOLEAN IsDirectoryObject,
           PGENERIC_MAPPING GenericMapping
    );


BOOL
CreatePrivateObjectSecurityEx (
       PSECURITY_DESCRIPTOR ParentDescriptor,
       PSECURITY_DESCRIPTOR CreatorDescriptor,
    PSECURITY_DESCRIPTOR * NewDescriptor,
       GUID *ObjectType,
           BOOL IsContainerObject,
           ULONG AutoInheritFlags,
       HANDLE Token,
           PGENERIC_MAPPING GenericMapping
    );


BOOL
CreatePrivateObjectSecurityWithMultipleInheritance (
       PSECURITY_DESCRIPTOR ParentDescriptor,
       PSECURITY_DESCRIPTOR CreatorDescriptor,
    PSECURITY_DESCRIPTOR * NewDescriptor,
    GUID **ObjectTypes,
           ULONG GuidCount,
           BOOL IsContainerObject,
           ULONG AutoInheritFlags,
       HANDLE Token,
           PGENERIC_MAPPING GenericMapping
    );


BOOL
SetPrivateObjectSecurity (
             SECURITY_INFORMATION SecurityInformation,
             PSECURITY_DESCRIPTOR ModificationDescriptor,
    PSECURITY_DESCRIPTOR *ObjectsSecurityDescriptor,
             PGENERIC_MAPPING GenericMapping,
         HANDLE Token
    );


BOOL
SetPrivateObjectSecurityEx (
             SECURITY_INFORMATION SecurityInformation,
             PSECURITY_DESCRIPTOR ModificationDescriptor,
    PSECURITY_DESCRIPTOR *ObjectsSecurityDescriptor,
             ULONG AutoInheritFlags,
             PGENERIC_MAPPING GenericMapping,
         HANDLE Token
    );


BOOL
GetPrivateObjectSecurity (
     PSECURITY_DESCRIPTOR ObjectDescriptor,
     SECURITY_INFORMATION SecurityInformation,
    PSECURITY_DESCRIPTOR ResultantDescriptor,
     DWORD DescriptorLength,
    PDWORD ReturnLength
    );



BOOL
DestroyPrivateObjectSecurity (
    PSECURITY_DESCRIPTOR * ObjectDescriptor
    );



BOOL
MakeSelfRelativeSD (
       PSECURITY_DESCRIPTOR pAbsoluteSecurityDescriptor,
    PSECURITY_DESCRIPTOR pSelfRelativeSecurityDescriptor,
    LPDWORD lpdwBufferLength
    );



BOOL
MakeAbsoluteSD (
       PSECURITY_DESCRIPTOR pSelfRelativeSecurityDescriptor,
    PSECURITY_DESCRIPTOR pAbsoluteSecurityDescriptor,
    LPDWORD lpdwAbsoluteSecurityDescriptorSize,
    PACL pDacl,
    LPDWORD lpdwDaclSize,
    PACL pSacl,
    LPDWORD lpdwSaclSize,
    PSID pOwner,
    LPDWORD lpdwOwnerSize,
    PSID pPrimaryGroup,
    LPDWORD lpdwPrimaryGroupSize
    );



BOOL
MakeAbsoluteSD2 (
    PSECURITY_DESCRIPTOR pSelfRelativeSecurityDescriptor,
    LPDWORD lpdwBufferSize
    );


VOID
QuerySecurityAccessMask(
    SECURITY_INFORMATION SecurityInformation,
    LPDWORD DesiredAccess
    );


VOID
SetSecurityAccessMask(
    SECURITY_INFORMATION SecurityInformation,
    LPDWORD DesiredAccess
    );


BOOL
SetFileSecurityA (
    LPCSTR lpFileName,
    SECURITY_INFORMATION SecurityInformation,
    PSECURITY_DESCRIPTOR pSecurityDescriptor
    );

BOOL
SetFileSecurityW (
    LPCWSTR lpFileName,
    SECURITY_INFORMATION SecurityInformation,
    PSECURITY_DESCRIPTOR pSecurityDescriptor
    );

version(UNICODE) {
	alias SetFileSecurityW SetFileSecurity;
}
else {
	alias SetFileSecurityA SetFileSecurity;
}



BOOL
GetFileSecurityA (
     LPCSTR lpFileName,
     SECURITY_INFORMATION RequestedInformation,
    PSECURITY_DESCRIPTOR pSecurityDescriptor,
     DWORD nLength,
    LPDWORD lpnLengthNeeded
    );

BOOL
GetFileSecurityW (
     LPCWSTR lpFileName,
     SECURITY_INFORMATION RequestedInformation,
    PSECURITY_DESCRIPTOR pSecurityDescriptor,
     DWORD nLength,
    LPDWORD lpnLengthNeeded
    );

version(UNICODE) {
	alias GetFileSecurityW GetFileSecurity;
}
else {
	alias GetFileSecurityA GetFileSecurity;
}



BOOL
SetKernelObjectSecurity (
    HANDLE Handle,
    SECURITY_INFORMATION SecurityInformation,
    PSECURITY_DESCRIPTOR SecurityDescriptor
    );


HANDLE
FindFirstChangeNotificationA(
    LPCSTR lpPathName,
    BOOL bWatchSubtree,
    DWORD dwNotifyFilter
    );

HANDLE
FindFirstChangeNotificationW(
    LPCWSTR lpPathName,
    BOOL bWatchSubtree,
    DWORD dwNotifyFilter
    );

version(UNICODE) {
	alias FindFirstChangeNotificationW FindFirstChangeNotification;
}
else {
	alias FindFirstChangeNotificationA FindFirstChangeNotification;
}

BOOL
FindNextChangeNotification(
    HANDLE hChangeHandle
    );

BOOL
FindCloseChangeNotification(
    HANDLE hChangeHandle
    );

BOOL
ReadDirectoryChangesW(
           HANDLE hDirectory,
    LPVOID lpBuffer,
           DWORD nBufferLength,
           BOOL bWatchSubtree,
           DWORD dwNotifyFilter,
       LPDWORD lpBytesReturned,
    LPOVERLAPPED lpOverlapped,
       LPOVERLAPPED_COMPLETION_ROUTINE lpCompletionRoutine
    );

BOOL
VirtualLock(
    LPVOID lpAddress,
    SIZE_T dwSize
    );

BOOL
VirtualUnlock(
    LPVOID lpAddress,
    SIZE_T dwSize
    );


LPVOID
MapViewOfFileEx(
        HANDLE hFileMappingObject,
        DWORD dwDesiredAccess,
        DWORD dwFileOffsetHigh,
        DWORD dwFileOffsetLow,
        SIZE_T dwNumberOfBytesToMap,
    LPVOID lpBaseAddress
    );



LPVOID
MapViewOfFileExNuma(
        HANDLE hFileMappingObject,
        DWORD dwDesiredAccess,
        DWORD dwFileOffsetHigh,
        DWORD dwFileOffsetLow,
        SIZE_T dwNumberOfBytesToMap,
    LPVOID lpBaseAddress,
        DWORD nndPreferred
    );

BOOL
SetPriorityClass(
    HANDLE hProcess,
    DWORD dwPriorityClass
    );

DWORD
GetPriorityClass(
    HANDLE hProcess
    );

BOOL
IsBadReadPtr(
    VOID *lp,
        UINT_PTR ucb
    );

BOOL
IsBadWritePtr(
    LPVOID lp,
        UINT_PTR ucb
    );

BOOL
IsBadHugeReadPtr(
    VOID *lp,
        UINT_PTR ucb
    );

BOOL
IsBadHugeWritePtr(
    LPVOID lp,
        UINT_PTR ucb
    );

BOOL
IsBadCodePtr(
    FARPROC lpfn
    );

BOOL
IsBadStringPtrA(
    LPCSTR lpsz,
        UINT_PTR ucchMax
    );
BOOL
IsBadStringPtrW(
    LPCWSTR lpsz,
        UINT_PTR ucchMax
    );

version(UNICODE) {
	alias IsBadStringPtrW IsBadStringPtr;
}
else {
	alias IsBadStringPtrA IsBadStringPtr;
}


BOOL
LookupAccountSidA(
    LPCSTR lpSystemName,
    PSID Sid,
    LPSTR Name,
     LPDWORD cchName,
	 LPSTR ReferencedDomainName,
    LPDWORD cchReferencedDomainName,
    PSID_NAME_USE peUse
    );

BOOL
LookupAccountSidW(
    LPCWSTR lpSystemName,
    PSID Sid,
    LPWSTR Name,
     LPDWORD cchName,
    LPWSTR ReferencedDomainName,
    LPDWORD cchReferencedDomainName,
    PSID_NAME_USE peUse
    );

version(UNICODE) {
	alias LookupAccountSidW LookupAccountSid;
}
else {
	alias LookupAccountSidA LookupAccountSid;
}


BOOL
LookupAccountNameA(
    LPCSTR lpSystemName,
        LPCSTR lpAccountName,
    PSID Sid,
     LPDWORD cbSid,
    LPSTR ReferencedDomainName,
     LPDWORD cchReferencedDomainName,
       PSID_NAME_USE peUse
    );

BOOL
LookupAccountNameW(
    LPCWSTR lpSystemName,
        LPCWSTR lpAccountName,
		PSID Sid,
     LPDWORD cbSid,
	 LPWSTR ReferencedDomainName,
     LPDWORD cchReferencedDomainName,
       PSID_NAME_USE peUse
    );

version(UNICODE) {
	alias LookupAccountNameW LookupAccountName;
}
else {
	alias LookupAccountNameA LookupAccountName;
}


BOOL
LookupPrivilegeValueA(
    LPCSTR lpSystemName,
        LPCSTR lpName,
       PLUID   lpLuid
    );

BOOL
LookupPrivilegeValueW(
    LPCWSTR lpSystemName,
        LPCWSTR lpName,
       PLUID   lpLuid
    );

version(UNICODE) {
	alias LookupPrivilegeValueW LookupPrivilegeValue;
}
else {
	alias LookupPrivilegeValueA LookupPrivilegeValue;
}


BOOL
LookupPrivilegeNameA(
    LPCSTR lpSystemName,
        PLUID   lpLuid,
    LPSTR lpName,
     LPDWORD cchName
    );

BOOL
LookupPrivilegeNameW(
    LPCWSTR lpSystemName,
        PLUID   lpLuid,
    LPWSTR lpName,
     LPDWORD cchName
    );

version(UNICODE) {
	alias LookupPrivilegeNameW LookupPrivilegeName;
}
else {
	alias LookupPrivilegeNameA LookupPrivilegeName;
}


BOOL
LookupPrivilegeDisplayNameA(
    LPCSTR lpSystemName,
        LPCSTR lpName,
		LPSTR lpDisplayName,
     LPDWORD cchDisplayName,
       LPDWORD lpLanguageId
    );

BOOL
LookupPrivilegeDisplayNameW(
    LPCWSTR lpSystemName,
        LPCWSTR lpName,
    LPWSTR lpDisplayName,
     LPDWORD cchDisplayName,
       LPDWORD lpLanguageId
    );

version(UNICODE) {
	alias LookupPrivilegeDisplayNameW LookupPrivilegeDisplayName;
}
else {
	alias LookupPrivilegeDisplayNameA LookupPrivilegeDisplayName;
}


BOOL
AllocateLocallyUniqueId(
    PLUID Luid
    );

BOOL
BuildCommDCBA(
     LPCSTR lpDef,
    LPDCB lpDCB
    );
BOOL
BuildCommDCBW(
     LPCWSTR lpDef,
    LPDCB lpDCB
    );

version(UNICODE) {
	alias BuildCommDCBW BuildCommDCB;
}
else {
	alias BuildCommDCBA BuildCommDCB;
}

BOOL
BuildCommDCBAndTimeoutsA(
     LPCSTR lpDef,
    LPDCB lpDCB,
    LPCOMMTIMEOUTS lpCommTimeouts
    );
BOOL
BuildCommDCBAndTimeoutsW(
     LPCWSTR lpDef,
    LPDCB lpDCB,
    LPCOMMTIMEOUTS lpCommTimeouts
    );

version(UNICODE) {
	alias BuildCommDCBAndTimeoutsW BuildCommDCBAndTimeouts;
}
else {
	alias BuildCommDCBAndTimeoutsA BuildCommDCBAndTimeouts;
}

BOOL
CommConfigDialogA(
        LPCSTR lpszName,
    HWND hWnd,
     LPCOMMCONFIG lpCC
    );
BOOL
CommConfigDialogW(
        LPCWSTR lpszName,
    HWND hWnd,
     LPCOMMCONFIG lpCC
    );

version(UNICODE) {
	alias CommConfigDialogW CommConfigDialog;
}
else {
	alias CommConfigDialogA CommConfigDialog;
}

BOOL
GetDefaultCommConfigA(
       LPCSTR lpszName,
    LPCOMMCONFIG lpCC,
    LPDWORD lpdwSize
    );
BOOL
GetDefaultCommConfigW(
       LPCWSTR lpszName,
    LPCOMMCONFIG lpCC,
    LPDWORD lpdwSize
    );

version(UNICODE) {
	alias GetDefaultCommConfigW GetDefaultCommConfig;
}
else {
	alias GetDefaultCommConfigA GetDefaultCommConfig;
}

BOOL
SetDefaultCommConfigA(
    LPCSTR lpszName,
    LPCOMMCONFIG lpCC,
    DWORD dwSize
    );
BOOL
SetDefaultCommConfigW(
    LPCWSTR lpszName,
    LPCOMMCONFIG lpCC,
    DWORD dwSize
    );

version(UNICODE) {
	alias SetDefaultCommConfigW SetDefaultCommConfig;
}
else {
	alias SetDefaultCommConfigA SetDefaultCommConfig;
}

const auto MAX_COMPUTERNAME_LENGTH  = 15;


BOOL
GetComputerNameA (
    LPSTR lpBuffer,
    LPDWORD nSize
    );

BOOL
GetComputerNameW (
    LPWSTR lpBuffer,
    LPDWORD nSize
    );

version(UNICODE) {
	alias GetComputerNameW GetComputerName;
}
else {
	alias GetComputerNameA GetComputerName;
}

BOOL
SetComputerNameA (
    LPCSTR lpComputerName
    );
BOOL
SetComputerNameW (
    LPCWSTR lpComputerName
    );

version(UNICODE) {
	alias SetComputerNameW SetComputerName;
}
else {
	alias SetComputerNameA SetComputerName;
}



enum COMPUTER_NAME_FORMAT {
    ComputerNameNetBIOS,
    ComputerNameDnsHostname,
    ComputerNameDnsDomain,
    ComputerNameDnsFullyQualified,
    ComputerNamePhysicalNetBIOS,
    ComputerNamePhysicalDnsHostname,
    ComputerNamePhysicalDnsDomain,
    ComputerNamePhysicalDnsFullyQualified,
    ComputerNameMax
}

BOOL GetComputerNameExA (
       COMPUTER_NAME_FORMAT NameType,
    LPSTR lpBuffer,
    LPDWORD nSize
    );

BOOL GetComputerNameExW (
       COMPUTER_NAME_FORMAT NameType,
    LPWSTR lpBuffer,
    LPDWORD nSize
    );

version(UNICODE) {
	alias GetComputerNameExW GetComputerNameEx;
}
else {
	alias GetComputerNameExA GetComputerNameEx;
}

BOOL
SetComputerNameExA (
    COMPUTER_NAME_FORMAT NameType,
    LPCSTR lpBuffer
    );
BOOL
SetComputerNameExW (
    COMPUTER_NAME_FORMAT NameType,
    LPCWSTR lpBuffer
    );

version(UNICODE) {
	alias SetComputerNameExW SetComputerNameEx;
}
else {
	alias SetComputerNameExA SetComputerNameEx;
}



BOOL DnsHostnameToComputerNameA (
       LPCSTR Hostname,
    LPSTR ComputerName,
    LPDWORD nSize
    );

BOOL DnsHostnameToComputerNameW (
       LPCWSTR Hostname,
    LPWSTR ComputerName,
    LPDWORD nSize
    );

version(UNICODE) {
	alias DnsHostnameToComputerNameW DnsHostnameToComputerName;
}
else {
	alias DnsHostnameToComputerNameA DnsHostnameToComputerName;
}



BOOL GetUserNameA (
LPSTR lpBuffer,
    LPDWORD pcbBuffer
    );

BOOL
GetUserNameW (
    LPWSTR lpBuffer,
    LPDWORD pcbBuffer
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

const auto LOGON32_LOGON_NETWORK_CLEARTEXT  = 8;
const auto LOGON32_LOGON_NEW_CREDENTIALS    = 9;

const auto LOGON32_PROVIDER_DEFAULT     = 0;
const auto LOGON32_PROVIDER_WINNT35     = 1;

const auto LOGON32_PROVIDER_WINNT40     = 2;

const auto LOGON32_PROVIDER_WINNT50     = 3;




BOOL
LogonUserA (
           LPCSTR lpszUsername,
       LPCSTR lpszDomain,
           LPCSTR lpszPassword,
           DWORD dwLogonType,
           DWORD dwLogonProvider,
    PHANDLE phToken
    );

BOOL
LogonUserW (
           LPCWSTR lpszUsername,
       LPCWSTR lpszDomain,
           LPCWSTR lpszPassword,
           DWORD dwLogonType,
           DWORD dwLogonProvider,
    PHANDLE phToken
    );

version(UNICODE) {
	alias LogonUserW LogonUser;
}
else {
	alias LogonUserA LogonUser;
}


BOOL
LogonUserExA (
               LPCSTR lpszUsername,
           LPCSTR lpszDomain,
               LPCSTR lpszPassword,
               DWORD dwLogonType,
               DWORD dwLogonProvider,
    PHANDLE phToken,
    PSID  *ppLogonSid,
	PVOID *ppProfileBuffer,
           LPDWORD pdwProfileLength,
           PQUOTA_LIMITS pQuotaLimits
    );

BOOL
LogonUserExW (
               LPCWSTR lpszUsername,
           LPCWSTR lpszDomain,
               LPCWSTR lpszPassword,
               DWORD dwLogonType,
               DWORD dwLogonProvider,
    PHANDLE phToken,
    PSID  *ppLogonSid,
	PVOID *ppProfileBuffer,
           LPDWORD pdwProfileLength,
           PQUOTA_LIMITS pQuotaLimits
    );

version(UNICODE) {
	alias LogonUserExW LogonUserEx;
}
else {
	alias LogonUserExA LogonUserEx;
}


BOOL
ImpersonateLoggedOnUser(
    HANDLE  hToken
    );


BOOL
CreateProcessAsUserA (
       HANDLE hToken,
       LPCSTR lpApplicationName,
    LPSTR lpCommandLine,
       LPSECURITY_ATTRIBUTES lpProcessAttributes,
       LPSECURITY_ATTRIBUTES lpThreadAttributes,
           BOOL bInheritHandles,
           DWORD dwCreationFlags,
       LPVOID lpEnvironment,
       LPCSTR lpCurrentDirectory,
           LPSTARTUPINFOA lpStartupInfo,
          LPPROCESS_INFORMATION lpProcessInformation
    );

BOOL
CreateProcessAsUserW (
       HANDLE hToken,
       LPCWSTR lpApplicationName,
    LPWSTR lpCommandLine,
       LPSECURITY_ATTRIBUTES lpProcessAttributes,
       LPSECURITY_ATTRIBUTES lpThreadAttributes,
           BOOL bInheritHandles,
           DWORD dwCreationFlags,
       LPVOID lpEnvironment,
       LPCWSTR lpCurrentDirectory,
           LPSTARTUPINFOW lpStartupInfo,
          LPPROCESS_INFORMATION lpProcessInformation
    );

version(UNICODE) {
	alias CreateProcessAsUserW CreateProcessAsUser;
}
else {
	alias CreateProcessAsUserA CreateProcessAsUser;
}



//
// LogonFlags
//
const auto LOGON_WITH_PROFILE               = 0x00000001;
const auto LOGON_NETCREDENTIALS_ONLY        = 0x00000002;
const auto LOGON_ZERO_PASSWORD_BUFFER       = 0x80000000;


BOOL
CreateProcessWithLogonW(
           LPCWSTR lpUsername,
       LPCWSTR lpDomain,
           LPCWSTR lpPassword,
           DWORD dwLogonFlags,
       LPCWSTR lpApplicationName,
    LPWSTR lpCommandLine,
           DWORD dwCreationFlags,
       LPVOID lpEnvironment,
       LPCWSTR lpCurrentDirectory,
           LPSTARTUPINFOW lpStartupInfo,
          LPPROCESS_INFORMATION lpProcessInformation
      );


BOOL
CreateProcessWithTokenW(
           HANDLE hToken,
           DWORD dwLogonFlags,
       LPCWSTR lpApplicationName,
    LPWSTR lpCommandLine,
           DWORD dwCreationFlags,
       LPVOID lpEnvironment,
       LPCWSTR lpCurrentDirectory,
           LPSTARTUPINFOW lpStartupInfo,
          LPPROCESS_INFORMATION lpProcessInformation
      );

BOOL
ImpersonateAnonymousToken(
    HANDLE ThreadHandle
    );


BOOL
DuplicateTokenEx(
           HANDLE hExistingToken,
           DWORD dwDesiredAccess,
       LPSECURITY_ATTRIBUTES lpTokenAttributes,
           SECURITY_IMPERSONATION_LEVEL ImpersonationLevel,
           TOKEN_TYPE TokenType,
    PHANDLE phNewToken);


BOOL

CreateRestrictedToken(
           HANDLE ExistingTokenHandle,
           DWORD Flags,
           DWORD DisableSidCount,
    PSID_AND_ATTRIBUTES SidsToDisable,
           DWORD DeletePrivilegeCount,
    PLUID_AND_ATTRIBUTES PrivilegesToDelete,
           DWORD RestrictedSidCount,
    PSID_AND_ATTRIBUTES SidsToRestrict,
    PHANDLE NewTokenHandle
    );



BOOL
IsTokenRestricted(
    HANDLE TokenHandle
    );


BOOL
IsTokenUntrusted(
    HANDLE TokenHandle
    );


BOOL

CheckTokenMembership(
    HANDLE TokenHandle,
        PSID SidToCheck,
       PBOOL IsMember
    );

//
// Thread pool API's
//

alias WAITORTIMERCALLBACKFUNC WAITORTIMERCALLBACK ;

BOOL
RegisterWaitForSingleObject(
    PHANDLE phNewWaitObject,
           HANDLE hObject,
           WAITORTIMERCALLBACK Callback,
       PVOID Context,
           ULONG dwMilliseconds,
           ULONG dwFlags
    );

HANDLE
RegisterWaitForSingleObjectEx(
        HANDLE hObject,
        WAITORTIMERCALLBACK Callback,
    PVOID Context,
        ULONG dwMilliseconds,
        ULONG dwFlags
    );


BOOL
UnregisterWait(
    HANDLE WaitHandle
    );


BOOL
UnregisterWaitEx(
        HANDLE WaitHandle,
    HANDLE CompletionEvent
    );

BOOL
QueueUserWorkItem(
        LPTHREAD_START_ROUTINE Function,
    PVOID Context,
        ULONG Flags
    );

BOOL
BindIoCompletionCallback (
    HANDLE FileHandle,
    LPOVERLAPPED_COMPLETION_ROUTINE Function,
    ULONG Flags
    );


HANDLE
CreateTimerQueue();

BOOL
CreateTimerQueueTimer(
    PHANDLE phNewTimer,
       HANDLE TimerQueue,
           WAITORTIMERCALLBACK Callback,
       PVOID Parameter,
           DWORD DueTime,
           DWORD Period,
           ULONG Flags
    ) ;


BOOL
ChangeTimerQueueTimer(
    HANDLE TimerQueue,
     HANDLE Timer,
        ULONG DueTime,
        ULONG Period
    );


BOOL
DeleteTimerQueueTimer(
    HANDLE TimerQueue,
        HANDLE Timer,
    HANDLE CompletionEvent
    );


BOOL
DeleteTimerQueueEx(
        HANDLE TimerQueue,
    HANDLE CompletionEvent
    );

HANDLE
SetTimerQueueTimer(
    HANDLE TimerQueue,
        WAITORTIMERCALLBACK Callback,
    PVOID Parameter,
        DWORD DueTime,
        DWORD Period,
        BOOL PreferIo
    );


BOOL
CancelTimerQueueTimer(
    HANDLE TimerQueue,
        HANDLE Timer
    );


BOOL
DeleteTimerQueue(
    HANDLE TimerQueue
    );

alias VOID function(PVOID Context, PVOID Overlapped, ULONG IoResult, ULONG_PTR NumberOfBytesTransferred, PTP_IO Io) PTP_WIN32_IO_CALLBACK;

PTP_POOL
CreateThreadpool(
    PVOID reserved
    );

VOID
SetThreadpoolThreadMaximum(
    PTP_POOL ptpp,
       DWORD    cthrdMost
    );

BOOL
SetThreadpoolThreadMinimum(
    PTP_POOL ptpp,
       DWORD    cthrdMic
    );

VOID
CloseThreadpool(
    PTP_POOL ptpp
    );



PTP_CLEANUP_GROUP
CreateThreadpoolCleanupGroup();

VOID
CloseThreadpoolCleanupGroupMembers(
        PTP_CLEANUP_GROUP ptpcg,
           BOOL              fCancelPendingCallbacks,
    PVOID             pvCleanupContext
    );

VOID
CloseThreadpoolCleanupGroup(
    PTP_CLEANUP_GROUP ptpcg
    );


VOID
SetEventWhenCallbackReturns(
    PTP_CALLBACK_INSTANCE pci,
       HANDLE                evt
    );

VOID
ReleaseSemaphoreWhenCallbackReturns(
    PTP_CALLBACK_INSTANCE pci,
       HANDLE                sem,
       DWORD                 crel
    );

VOID
ReleaseMutexWhenCallbackReturns(
    PTP_CALLBACK_INSTANCE pci,
       HANDLE                mut
    );

VOID
LeaveCriticalSectionWhenCallbackReturns(
    PTP_CALLBACK_INSTANCE pci,
    PCRITICAL_SECTION     pcs
    );

VOID
FreeLibraryWhenCallbackReturns(
    PTP_CALLBACK_INSTANCE pci,
       HMODULE               mod
    );

BOOL
CallbackMayRunLong(
    PTP_CALLBACK_INSTANCE pci
    );

VOID
DisassociateCurrentThreadFromCallback(
    PTP_CALLBACK_INSTANCE pci
    );


BOOL
TrySubmitThreadpoolCallback(
           PTP_SIMPLE_CALLBACK  pfns,
    PVOID                pv,
       PTP_CALLBACK_ENVIRON pcbe
    );



PTP_WORK
CreateThreadpoolWork(
           PTP_WORK_CALLBACK    pfnwk,
    PVOID                pv,
       PTP_CALLBACK_ENVIRON pcbe
    );

VOID
SubmitThreadpoolWork(
    PTP_WORK pwk
    );

VOID
WaitForThreadpoolWorkCallbacks(
    PTP_WORK pwk,
       BOOL     fCancelPendingCallbacks
    );

VOID
CloseThreadpoolWork(
    PTP_WORK pwk
    );



PTP_TIMER
CreateThreadpoolTimer(
           PTP_TIMER_CALLBACK   pfnti,
    PVOID                pv,
       PTP_CALLBACK_ENVIRON pcbe
    );

VOID
SetThreadpoolTimer(
     PTP_TIMER pti,
    PFILETIME pftDueTime,
        DWORD     msPeriod,
    DWORD     msWindowLength
    );

BOOL
IsThreadpoolTimerSet(
    PTP_TIMER pti
    );

VOID
WaitForThreadpoolTimerCallbacks(
    PTP_TIMER pti,
       BOOL      fCancelPendingCallbacks
    );

VOID
CloseThreadpoolTimer(
    PTP_TIMER pti
    );



PTP_WAIT
CreateThreadpoolWait(
           PTP_WAIT_CALLBACK    pfnwa,
    PVOID                pv,
       PTP_CALLBACK_ENVIRON pcbe
    );

VOID
SetThreadpoolWait(
     PTP_WAIT  pwa,
    HANDLE    h,
    PFILETIME pftTimeout
    );

VOID
WaitForThreadpoolWaitCallbacks(
    PTP_WAIT pwa,
       BOOL     fCancelPendingCallbacks
    );

VOID
CloseThreadpoolWait(
    PTP_WAIT pwa
    );



PTP_IO
CreateThreadpoolIo(
           HANDLE                fl,
           PTP_WIN32_IO_CALLBACK pfnio,
    PVOID                 pv,
       PTP_CALLBACK_ENVIRON  pcbe
    );

VOID
StartThreadpoolIo(
    PTP_IO pio
    );

VOID
CancelThreadpoolIo(
    PTP_IO pio
    );

VOID
WaitForThreadpoolIoCallbacks(
    PTP_IO pio,
       BOOL   fCancelPendingCallbacks
    );

VOID
CloseThreadpoolIo(
    PTP_IO pio
    );

//
//  Private Namespaces support
//


HANDLE
CreatePrivateNamespaceA(
    LPSECURITY_ATTRIBUTES lpPrivateNamespaceAttributes,
        LPVOID lpBoundaryDescriptor,
        LPCSTR lpAliasPrefix
    );

HANDLE
CreatePrivateNamespaceW(
    LPSECURITY_ATTRIBUTES lpPrivateNamespaceAttributes,
        LPVOID lpBoundaryDescriptor,
        LPCWSTR lpAliasPrefix
    );

version(UNICODE) {
	alias CreatePrivateNamespaceW CreatePrivateNamespace;
}
else {
	alias CreatePrivateNamespaceA CreatePrivateNamespace;
}


HANDLE
OpenPrivateNamespaceA(
        LPVOID lpBoundaryDescriptor,
        LPCSTR lpAliasPrefix
    );

HANDLE
OpenPrivateNamespaceW(
        LPVOID lpBoundaryDescriptor,
        LPCWSTR lpAliasPrefix
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
    HANDLE Handle,
    ULONG Flags
    );


//
//  Boundary descriptors support
//


HANDLE

CreateBoundaryDescriptorA(
    LPCSTR Name,
    ULONG Flags
    );

HANDLE

CreateBoundaryDescriptorW(
    LPCWSTR Name,
    ULONG Flags
    );

version(UNICODE) {
	alias CreateBoundaryDescriptorW CreateBoundaryDescriptor;
}
else {
	alias CreateBoundaryDescriptorA CreateBoundaryDescriptor;
}

BOOL
AddSIDToBoundaryDescriptor(
    HANDLE * BoundaryDescriptor,
    PSID RequiredSid
    );


VOID
DeleteBoundaryDescriptor(
    HANDLE BoundaryDescriptor
    );


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

alias HW_PROFILE_INFOA* LPHW_PROFILE_INFOA;
struct HW_PROFILE_INFOW {
    DWORD  dwDockInfo;
    WCHAR  szHwProfileGuid[HW_PROFILE_GUIDLEN];
    WCHAR  szHwProfileName[MAX_PROFILE_LEN];
}

alias HW_PROFILE_INFOW* LPHW_PROFILE_INFOW;

version(UNICODE) {
	alias HW_PROFILE_INFOW HW_PROFILE_INFO;
	alias LPHW_PROFILE_INFOW LPHW_PROFILE_INFO;
}
else {
	alias HW_PROFILE_INFOA HW_PROFILE_INFO;
	alias LPHW_PROFILE_INFOA LPHW_PROFILE_INFO;
}



BOOL
GetCurrentHwProfileA (
    LPHW_PROFILE_INFOA  lpHwProfileInfo
    );

BOOL
GetCurrentHwProfileW (
    LPHW_PROFILE_INFOW  lpHwProfileInfo
    );

version(UNICODE) {
	alias GetCurrentHwProfileW GetCurrentHwProfile;
}
else {
	alias GetCurrentHwProfileA GetCurrentHwProfile;
}

//
// Performance counter API's
//

BOOL
QueryPerformanceCounter(
    LARGE_INTEGER *lpPerformanceCount
    );

BOOL
QueryPerformanceFrequency(
    LARGE_INTEGER *lpFrequency
    );



BOOL
GetVersionExA(
    LPOSVERSIONINFOA lpVersionInformation
    );
BOOL
GetVersionExW(
    LPOSVERSIONINFOW lpVersionInformation
    );

version(UNICODE) {
	alias GetVersionExW GetVersionEx;
}
else {
	alias GetVersionExA GetVersionEx;
}



BOOL
VerifyVersionInfoA(
    LPOSVERSIONINFOEXA lpVersionInformation,
       DWORD dwTypeMask,
       DWORDLONG dwlConditionMask
    );
BOOL
VerifyVersionInfoW(
    LPOSVERSIONINFOEXW lpVersionInformation,
       DWORD dwTypeMask,
       DWORDLONG dwlConditionMask
    );

version(UNICODE) {
	alias VerifyVersionInfoW VerifyVersionInfo;
}
else {
	alias VerifyVersionInfoA VerifyVersionInfo;
}

BOOL
GetProductInfo(
     DWORD  dwOSMajorVersion,
     DWORD  dwOSMinorVersion,
     DWORD  dwSpMajorVersion,
     DWORD  dwSpMinorVersion,
    PDWORD pdwReturnedProductType
    );

// DOS and OS/2 Compatible Error Code definitions returned by the Win32 Base
// API functions.
//

/* Abnormal termination codes */

const auto TC_NORMAL        = 0;
const auto TC_HARDERR       = 1;
const auto TC_GP_TRAP       = 2;
const auto TC_SIGNAL        = 3;

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

alias SYSTEM_POWER_STATUS* LPSYSTEM_POWER_STATUS;

BOOL
GetSystemPowerStatus(
    LPSYSTEM_POWER_STATUS lpSystemPowerStatus
    );

BOOL
SetSystemPowerState(
    BOOL fSuspend,
    BOOL fForce
    );

//
// Very Large Memory API Subset
//

BOOL
AllocateUserPhysicalPages(
       HANDLE hProcess,
    PULONG_PTR NumberOfPages,
    PULONG_PTR PageArray
    );


BOOL
AllocateUserPhysicalPagesNuma(
       HANDLE hProcess,
    PULONG_PTR NumberOfPages,
    PULONG_PTR PageArray,
       DWORD nndPreferred
    );

BOOL
FreeUserPhysicalPages(
       HANDLE hProcess,
    PULONG_PTR NumberOfPages,
    PULONG_PTR PageArray
    );

BOOL
MapUserPhysicalPages(
    PVOID VirtualAddress,
    ULONG_PTR NumberOfPages,
    PULONG_PTR PageArray
    );

BOOL
MapUserPhysicalPagesScatter(
    PVOID *VirtualAddresses,
    ULONG_PTR NumberOfPages,
    PULONG_PTR PageArray
    );


HANDLE
CreateJobObjectA(
    LPSECURITY_ATTRIBUTES lpJobAttributes,
    LPCSTR lpName
    );

HANDLE
CreateJobObjectW(
    LPSECURITY_ATTRIBUTES lpJobAttributes,
    LPCWSTR lpName
    );

version(UNICODE) {
	alias CreateJobObjectW CreateJobObject;
}
else {
	alias CreateJobObjectA CreateJobObject;
}


HANDLE
OpenJobObjectA(
    DWORD dwDesiredAccess,
    BOOL bInheritHandle,
    LPCSTR lpName
    );

HANDLE
OpenJobObjectW(
    DWORD dwDesiredAccess,
    BOOL bInheritHandle,
    LPCWSTR lpName
    );

version(UNICODE) {
	alias OpenJobObjectW OpenJobObject;
}
else {
	alias OpenJobObjectA OpenJobObject;
}

BOOL
AssignProcessToJobObject(
    HANDLE hJob,
    HANDLE hProcess
    );

BOOL
TerminateJobObject(
    HANDLE hJob,
    UINT uExitCode
    );

BOOL
QueryInformationJobObject(
     HANDLE hJob,
         JOBOBJECTINFOCLASS JobObjectInformationClass,
    LPVOID lpJobObjectInformation,
         DWORD cbJobObjectInformationLength,
     LPDWORD lpReturnLength
    );

BOOL
SetInformationJobObject(
    HANDLE hJob,
    JOBOBJECTINFOCLASS JobObjectInformationClass,
    LPVOID lpJobObjectInformation,
    DWORD cbJobObjectInformationLength
    );


BOOL
IsProcessInJob (
        HANDLE ProcessHandle,
    HANDLE JobHandle,
       PBOOL Result
    );

BOOL
CreateJobSet (
    ULONG NumJob,
    PJOB_SET_ARRAY UserJobSet,
    ULONG Flags);


PVOID
AddVectoredExceptionHandler (
    ULONG First,
    PVECTORED_EXCEPTION_HANDLER Handler
    );

ULONG
RemoveVectoredExceptionHandler (
    PVOID Handle
    );


PVOID
AddVectoredContinueHandler (
    ULONG First,
    PVECTORED_EXCEPTION_HANDLER Handler
    );

ULONG
RemoveVectoredContinueHandler (
    PVOID Handle
    );

//
// New Volume Mount Point API.
//


HANDLE
FindFirstVolumeA(
    LPSTR lpszVolumeName,
    DWORD cchBufferLength
    );

HANDLE
FindFirstVolumeW(
    LPWSTR lpszVolumeName,
    DWORD cchBufferLength
    );

version(UNICODE) {
	alias FindFirstVolumeW FindFirstVolume;
}
else {
	alias FindFirstVolumeA FindFirstVolume;
}

BOOL
FindNextVolumeA(
    HANDLE hFindVolume,
    LPSTR lpszVolumeName,
       DWORD cchBufferLength
    );
BOOL
FindNextVolumeW(
    HANDLE hFindVolume,
    LPWSTR lpszVolumeName,
       DWORD cchBufferLength
    );

version(UNICODE) {
	alias FindNextVolumeW FindNextVolume;
}
else {
	alias FindNextVolumeA FindNextVolume;
}

BOOL
FindVolumeClose(
    HANDLE hFindVolume
    );


HANDLE
FindFirstVolumeMountPointA(
    LPCSTR lpszRootPathName,
    LPSTR lpszVolumeMountPoint,
    DWORD cchBufferLength
    );

HANDLE
FindFirstVolumeMountPointW(
    LPCWSTR lpszRootPathName,
    LPWSTR lpszVolumeMountPoint,
    DWORD cchBufferLength
    );

version(UNICODE) {
	alias FindFirstVolumeMountPointW FindFirstVolumeMountPoint;
}
else {
	alias FindFirstVolumeMountPointA FindFirstVolumeMountPoint;
}

BOOL
FindNextVolumeMountPointA(
    HANDLE hFindVolumeMountPoint,
    LPSTR lpszVolumeMountPoint,
    DWORD cchBufferLength
    );
BOOL
FindNextVolumeMountPointW(
    HANDLE hFindVolumeMountPoint,
    LPWSTR lpszVolumeMountPoint,
    DWORD cchBufferLength
    );

version(UNICODE) {
	alias FindNextVolumeMountPointW FindNextVolumeMountPoint;
}
else {
	alias FindNextVolumeMountPointA FindNextVolumeMountPoint;
}

BOOL
FindVolumeMountPointClose(
    HANDLE hFindVolumeMountPoint
    );

BOOL
SetVolumeMountPointA(
    LPCSTR lpszVolumeMountPoint,
    LPCSTR lpszVolumeName
    );
BOOL
SetVolumeMountPointW(
    LPCWSTR lpszVolumeMountPoint,
    LPCWSTR lpszVolumeName
    );

version(UNICODE) {
	alias SetVolumeMountPointW SetVolumeMountPoint;
}
else {
	alias SetVolumeMountPointA SetVolumeMountPoint;
}

BOOL
DeleteVolumeMountPointA(
    LPCSTR lpszVolumeMountPoint
    );
BOOL
DeleteVolumeMountPointW(
    LPCWSTR lpszVolumeMountPoint
    );

version(UNICODE) {
	alias DeleteVolumeMountPointW DeleteVolumeMountPoint;
}
else {
	alias DeleteVolumeMountPointA DeleteVolumeMountPoint;
}

BOOL
GetVolumeNameForVolumeMountPointA(
    LPCSTR lpszVolumeMountPoint,
    LPSTR lpszVolumeName,
    DWORD cchBufferLength
    );
BOOL
GetVolumeNameForVolumeMountPointW(
    LPCWSTR lpszVolumeMountPoint,
    LPWSTR lpszVolumeName,
    DWORD cchBufferLength
    );

version(UNICODE) {
	alias GetVolumeNameForVolumeMountPointW GetVolumeNameForVolumeMountPoint;
}
else {
	alias GetVolumeNameForVolumeMountPointA GetVolumeNameForVolumeMountPoint;
}

BOOL
GetVolumePathNameA(
    LPCSTR lpszFileName,
    LPSTR lpszVolumePathName,
    DWORD cchBufferLength
    );
BOOL
GetVolumePathNameW(
    LPCWSTR lpszFileName,
    LPWSTR lpszVolumePathName,
    DWORD cchBufferLength
    );

version(UNICODE) {
	alias GetVolumePathNameW GetVolumePathName;
}
else {
	alias GetVolumePathNameA GetVolumePathName;
}

BOOL
GetVolumePathNamesForVolumeNameA(
     LPCSTR lpszVolumeName,
    LPCH lpszVolumePathNames,
     DWORD cchBufferLength,
    PDWORD lpcchReturnLength
    );
BOOL
GetVolumePathNamesForVolumeNameW(
     LPCWSTR lpszVolumeName,
    LPWCH lpszVolumePathNames,
     DWORD cchBufferLength,
    PDWORD lpcchReturnLength
    );

version(UNICODE) {
	alias GetVolumePathNamesForVolumeNameW GetVolumePathNamesForVolumeName;
}
else {
	alias GetVolumePathNamesForVolumeNameA GetVolumePathNamesForVolumeName;
}


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

alias ACTCTXA* PACTCTXA;
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

alias ACTCTXW* PACTCTXW;

version(UNICODE) {
	alias ACTCTXW ACTCTX;
	alias PACTCTXW PACTCTX;
}
else {
	alias ACTCTXA ACTCTX;
	alias PACTCTXA PACTCTX;
}

alias ACTCTXA *PCACTCTXA;
alias ACTCTXW *PCACTCTXW;

version(UNICODE) {
	alias PCACTCTXW PCACTCTX;
}
else {
	alias PCACTCTXA PCACTCTX;
}




HANDLE
CreateActCtxA(
    PCACTCTXA pActCtx
    );

HANDLE
CreateActCtxW(
    PCACTCTXW pActCtx
    );

version(UNICODE) {
	alias CreateActCtxW CreateActCtx;
}
else {
	alias CreateActCtxA CreateActCtx;
}

VOID
AddRefActCtx(
    HANDLE hActCtx
    );


VOID
ReleaseActCtx(
    HANDLE hActCtx
    );

BOOL
ZombifyActCtx(
    HANDLE hActCtx
    );


BOOL
ActivateActCtx(
    HANDLE hActCtx,
      ULONG_PTR *lpCookie
    );


const auto DEACTIVATE_ACTCTX_FLAG_FORCE_EARLY_DEACTIVATION  = (0x00000001);

BOOL
DeactivateActCtx(
    DWORD dwFlags,
    ULONG_PTR ulCookie
    );

BOOL
GetCurrentActCtx(
    HANDLE *lphActCtx);


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

alias ACTCTX_SECTION_KEYED_DATA_2600* PACTCTX_SECTION_KEYED_DATA_2600;
alias ACTCTX_SECTION_KEYED_DATA_2600 * PCACTCTX_SECTION_KEYED_DATA_2600;

struct ACTCTX_SECTION_KEYED_DATA_ASSEMBLY_METADATA {
    PVOID lpInformation;
    PVOID lpSectionBase;
    ULONG ulSectionLength;
    PVOID lpSectionGlobalDataBase;
    ULONG ulSectionGlobalDataLength;
}

alias ACTCTX_SECTION_KEYED_DATA_ASSEMBLY_METADATA* PACTCTX_SECTION_KEYED_DATA_ASSEMBLY_METADATA;
alias ACTCTX_SECTION_KEYED_DATA_ASSEMBLY_METADATA *PCACTCTX_SECTION_KEYED_DATA_ASSEMBLY_METADATA;

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

alias ACTCTX_SECTION_KEYED_DATA* PACTCTX_SECTION_KEYED_DATA;
alias ACTCTX_SECTION_KEYED_DATA * PCACTCTX_SECTION_KEYED_DATA;

const auto FIND_ACTCTX_SECTION_KEY_RETURN_HACTCTX  = (0x00000001);
const auto FIND_ACTCTX_SECTION_KEY_RETURN_FLAGS    = (0x00000002);
const auto FIND_ACTCTX_SECTION_KEY_RETURN_ASSEMBLY_METADATA  = (0x00000004);



BOOL
FindActCtxSectionStringA(
          DWORD dwFlags,
    GUID *lpExtensionGuid,
          ULONG ulSectionId,
          LPCSTR lpStringToFind,
         PACTCTX_SECTION_KEYED_DATA ReturnedData
    );
BOOL
FindActCtxSectionStringW(
          DWORD dwFlags,
    GUID *lpExtensionGuid,
          ULONG ulSectionId,
          LPCWSTR lpStringToFind,
         PACTCTX_SECTION_KEYED_DATA ReturnedData
    );

version(UNICODE) {
	alias FindActCtxSectionStringW FindActCtxSectionString;
}
else {
	alias FindActCtxSectionStringA FindActCtxSectionString;
}

BOOL
FindActCtxSectionGuid(
          DWORD dwFlags,
    GUID *lpExtensionGuid,
          ULONG ulSectionId,
      GUID *lpGuidToFind,
         PACTCTX_SECTION_KEYED_DATA ReturnedData
    );


struct ACTIVATION_CONTEXT_BASIC_INFORMATION {
    HANDLE  hActCtx;
    DWORD   dwFlags;
}

alias ACTIVATION_CONTEXT_BASIC_INFORMATION* PACTIVATION_CONTEXT_BASIC_INFORMATION;

alias ACTIVATION_CONTEXT_BASIC_INFORMATION *PCACTIVATION_CONTEXT_BASIC_INFORMATION;

const auto ACTIVATION_CONTEXT_BASIC_INFORMATION_DEFINED  = 1;

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
         DWORD dwFlags,
         HANDLE hActCtx,
     PVOID pvSubInstance,
         ULONG ulInfoClass,
    PVOID pvBuffer,
         SIZE_T cbBuffer,
     SIZE_T *pcbWrittenOrRequired
    );

alias BOOL function(DWORD dwFlags, HANDLE hActCtx, PVOID pvSubInstance, ULONG ulInfoClass, PVOID pvBuffer, SIZE_T cbBuffer, SIZE_T* pcbWrittenOrRequired) PQUERYACTCTXW_FUNC;

BOOL
ProcessIdToSessionId(
     DWORD dwProcessId,
    DWORD *pSessionId
    );

DWORD
WTSGetActiveConsoleSessionId();

BOOL
IsWow64Process(
     HANDLE hProcess,
    PBOOL Wow64Process
    );

BOOL
GetLogicalProcessorInformation(
    PSYSTEM_LOGICAL_PROCESSOR_INFORMATION Buffer,
    PDWORD ReturnedLength
    );

//
// NUMA Information routines.
//

BOOL
GetNumaHighestNodeNumber(
    PULONG HighestNodeNumber
    );

BOOL
GetNumaProcessorNode(
     UCHAR Processor,
    PUCHAR NodeNumber
    );

BOOL
GetNumaNodeProcessorMask(
     UCHAR Node,
    PULONGLONG ProcessorMask
    );

BOOL
GetNumaAvailableMemoryNode(
     UCHAR Node,
    PULONGLONG AvailableBytes
    );

BOOL
GetNumaProximityNode(
     ULONG ProximityId,
    PUCHAR NodeNumber
    );

//
// Application restart and data recovery callback
//
alias DWORD function(PVOID pvParameter) APPLICATION_RECOVERY_CALLBACK;

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
     APPLICATION_RECOVERY_CALLBACK pRecoveyCallback,
     PVOID pvParameter,
    DWORD dwPingInterval,
    DWORD dwFlags
    );

HRESULT
UnregisterApplicationRecoveryCallback();

HRESULT
RegisterApplicationRestart(
    PCWSTR pwzCommandline,
    DWORD dwFlags
    );

HRESULT
UnregisterApplicationRestart();


const auto RECOVERY_DEFAULT_PING_INTERVAL   = 5000;
const auto RECOVERY_MAX_PING_INTERVAL       = (5 * 60 * 1000);

HRESULT
GetApplicationRecoveryCallback(
     HANDLE hProcess,
    APPLICATION_RECOVERY_CALLBACK* pRecoveryCallback,
    PVOID* ppvParameter,
     PDWORD pdwPingInterval,
     PDWORD pdwFlags
    );

HRESULT
GetApplicationRestartSettings(
    HANDLE hProcess,
    PWSTR pwzCommandline,
    PDWORD pcchSize,
     PDWORD pdwFlags
    );

HRESULT
ApplicationRecoveryInProgress(
    PBOOL pbCancelled
    );

VOID
ApplicationRecoveryFinished(
    BOOL bSuccess
    );

enum FILE_INFO_BY_HANDLE_CLASS {
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
}

alias FILE_INFO_BY_HANDLE_CLASS* PFILE_INFO_BY_HANDLE_CLASS;

struct FILE_BASIC_INFO {
    LARGE_INTEGER CreationTime;
    LARGE_INTEGER LastAccessTime;
    LARGE_INTEGER LastWriteTime;
    LARGE_INTEGER ChangeTime;
    DWORD FileAttributes;
}

alias FILE_BASIC_INFO* PFILE_BASIC_INFO;

struct FILE_STANDARD_INFO {
    LARGE_INTEGER AllocationSize;
    LARGE_INTEGER EndOfFile;
    DWORD NumberOfLinks;
    BOOLEAN DeletePending;
    BOOLEAN Directory;
}

alias FILE_STANDARD_INFO* PFILE_STANDARD_INFO;

struct FILE_NAME_INFO {
    DWORD FileNameLength;
    WCHAR FileName[1];
}

alias FILE_NAME_INFO* PFILE_NAME_INFO;

struct FILE_RENAME_INFO {
    BOOLEAN ReplaceIfExists;
    HANDLE RootDirectory;
    DWORD FileNameLength;
    WCHAR FileName[1];
}

alias FILE_RENAME_INFO* PFILE_RENAME_INFO;

struct FILE_ALLOCATION_INFO {
    LARGE_INTEGER AllocationSize;
}

alias FILE_ALLOCATION_INFO* PFILE_ALLOCATION_INFO;

struct FILE_END_OF_FILE_INFO {
    LARGE_INTEGER EndOfFile;
}

alias FILE_END_OF_FILE_INFO* PFILE_END_OF_FILE_INFO;

struct FILE_STREAM_INFO {
    DWORD NextEntryOffset;
    DWORD StreamNameLength;
    LARGE_INTEGER StreamSize;
    LARGE_INTEGER StreamAllocationSize;
    WCHAR StreamName[1];
}

alias FILE_STREAM_INFO* PFILE_STREAM_INFO;

struct FILE_COMPRESSION_INFO {
    LARGE_INTEGER CompressedFileSize;
    WORD CompressionFormat;
    UCHAR CompressionUnitShift;
    UCHAR ChunkShift;
    UCHAR ClusterShift;
    UCHAR Reserved[3];
}

alias FILE_COMPRESSION_INFO* PFILE_COMPRESSION_INFO;

struct FILE_ATTRIBUTE_TAG_INFO {
    DWORD FileAttributes;
    DWORD ReparseTag;
}

alias FILE_ATTRIBUTE_TAG_INFO* PFILE_ATTRIBUTE_TAG_INFO;

struct FILE_DISPOSITION_INFO {
    BOOLEAN DeleteFile;
}

alias FILE_DISPOSITION_INFO* PFILE_DISPOSITION_INFO;

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

alias FILE_ID_BOTH_DIR_INFO* PFILE_ID_BOTH_DIR_INFO;

enum PRIORITY_HINT {
      IoPriorityHintVeryLow = 0,
      IoPriorityHintLow,
      IoPriorityHintNormal,
      MaximumIoPriorityHintType
}

struct FILE_IO_PRIORITY_HINT_INFO {
    PRIORITY_HINT PriorityHint;
}

alias FILE_IO_PRIORITY_HINT_INFO* PFILE_IO_PRIORITY_HINT_INFO;

BOOL
SetFileInformationByHandle(
     HANDLE hFile,
     FILE_INFO_BY_HANDLE_CLASS FileInformationClass,
    LPVOID lpFileInformation,
     DWORD dwBufferSize
);

BOOL
GetFileInformationByHandleEx(
     HANDLE hFile,
     FILE_INFO_BY_HANDLE_CLASS FileInformationClass,
    LPVOID lpFileInformation,
     DWORD dwBufferSize
);

enum FILE_ID_TYPE {
      FileIdType,
      ObjectIdType,
      MaximumFileIdType
}

alias FILE_ID_TYPE* PFILE_ID_TYPE;

struct FILE_ID_DESCRIPTOR {
    DWORD dwSize;  // Size of the struct
    FILE_ID_TYPE Type; // Describes the type of identifier passed in.
    union {
        LARGE_INTEGER FileId;
        GUID ObjectId;
    };
}

alias FILE_ID_DESCRIPTOR* LPFILE_ID_DESCRIPTOR;


HANDLE
OpenFileById (
        HANDLE hVolumeHint,
        LPFILE_ID_DESCRIPTOR lpFileId,
        DWORD dwDesiredAccess,
        DWORD dwShareMode,
    LPSECURITY_ATTRIBUTES lpSecurityAttributes,
        DWORD dwFlagsAndAttributes
    );


//
//  Flags to be passed into CREATE_SYMBOLIC_LINK
//

const auto SYMBOLIC_LINK_FLAG_DIRECTORY             = (0x1);

const auto VALID_SYMBOLIC_LINK_FLAGS   = SYMBOLIC_LINK_FLAG_DIRECTORY ; // & whatever other flags we think of!

BOOLEAN

CreateSymbolicLinkA (
    LPCSTR lpSymlinkFileName,
    LPCSTR lpTargetFileName,
    DWORD dwFlags
    );
BOOLEAN

CreateSymbolicLinkW (
    LPCWSTR lpSymlinkFileName,
    LPCWSTR lpTargetFileName,
    DWORD dwFlags
    );

version(UNICODE) {
	alias CreateSymbolicLinkW CreateSymbolicLink;
}
else {
	alias CreateSymbolicLinkA CreateSymbolicLink;
}

BOOLEAN

CreateSymbolicLinkTransactedA (
        LPCSTR lpSymlinkFileName,
        LPCSTR lpTargetFileName,
        DWORD dwFlags,
        HANDLE hTransaction
    );
BOOLEAN

CreateSymbolicLinkTransactedW (
        LPCWSTR lpSymlinkFileName,
        LPCWSTR lpTargetFileName,
        DWORD dwFlags,
        HANDLE hTransaction
    );

version(UNICODE) {
	alias CreateSymbolicLinkTransactedW CreateSymbolicLinkTransacted;
}
else {
	alias CreateSymbolicLinkTransactedA CreateSymbolicLinkTransacted;
}

DWORD
GetFinalPathNameByHandleA (
    HANDLE hFile,
    LPSTR lpszFilePath,
    DWORD cchFilePath,
    DWORD dwFlags
);
DWORD
GetFinalPathNameByHandleW (
    HANDLE hFile,
    LPWSTR lpszFilePath,
    DWORD cchFilePath,
    DWORD dwFlags
);

version(UNICODE) {
	alias GetFinalPathNameByHandleW GetFinalPathNameByHandle;
}
else {
	alias GetFinalPathNameByHandleA GetFinalPathNameByHandle;
}


BOOL
QueryActCtxSettingsW(
         DWORD dwFlags,
         HANDLE hActCtx,
         PCWSTR settingsNameSpace,
             PCWSTR settingName,
    PWSTR pvBuffer,
         SIZE_T dwBuffer,
     SIZE_T *pdwWrittenOrRequired
    );

// Expose Hidden Function:
FARPROC GetProcAddressW (
    HMODULE hModule,
    LPCWSTR lpProcName
    );

