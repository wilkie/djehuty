/*
 * common.d
 *
 * This file gives the external references for libraries and native APIs.
 * For the UNIX environment, this is largely the C standard library. Some
 * magic goes into hinting to the runtime in place.
 *
 * Author: Dave Wilkinson
 *
 */

module platform.unix.common;

public import X = binding.x.Xlib;

public import Cairo = binding.cairo.cairo;
public import CairoX = binding.cairo.xlib;

public import Pango = binding.pango.pango;

public import binding.c;
public import Curses = binding.ncurses.ncurses;

extern(C):

size_t readlink(char* path, char* buf, size_t len);
int getpid();

char* getenv(char*);

// Directory Streams

struct __direntry;
alias __direntry DIR;

struct dirent
{
	Culong_t d_ino;
	Culong_t d_off;

	ushort d_reclen;
	ubyte d_type;
	char d_name[256];
}

struct dirent64
{
	ulong d_ino;
	ulong d_off;

	ushort d_reclen;
	ubyte d_type;
	char d_name[256];
}

DIR* opendir(char* name);
int closedir(DIR* dp);
dirent* readdir(DIR* dp);
dirent64* readdir64(DIR* dp);
void rewinddir(DIR* dp);
void seekdir(DIR* dp, Clong_t pos);
Clong_t telldir(DIR* dp);

// Network

alias uint mode_t;
alias int pid_t;
alias uint uid_t;
alias uint gid_t;
alias long off_t;
alias long ssize_t;

struct hostent
{
    char* h_name;
    char** h_aliases;
    int h_addrtype;
    int h_length;
    char** h_addr_list;

  char* h_addr()
  {
      return h_addr_list[0];
  }

}

struct addrinfo { }
struct passwd
{
    char* pw_name;
    char* pw_passwd;
    uint pw_uid;
    uint pw_gid;
    char* pw_gecos;
    char* pw_dir;
    char* pw_shell;
}

struct in_addr
{
    uint s_addr;
}

struct timespec
{
    long tv_sec;
    long tv_nsec;
}

struct timeval
{
    long tv_sec;
    long tv_usec;
}

struct timezone
{
    int tz_minuteswest;
    int tz_dsttime;
}

struct sem_t
{
    byte[32] __opaque;
}

alias ulong pthread_t;
struct pthread_attr_t
{
    byte[56] __opaque;
}

struct pthread_cond_t
{
    byte[48] __opaque;
}

struct pthread_condattr_t
{
    byte[4] __opaque;
}

struct pthread_mutex_t
{
    byte[40] __opaque;
}

struct pthread_mutexattr_t
{
    byte[4] __opaque;
}

struct sched_param
{
    int sched_priority;
}

struct pthread_barrier_t
{
    byte[32] __opaque;
}

struct pthread_barrierattr_t
{
    byte[4] __opaque;
}

struct pthread_rwlock_t
{
    byte[56] __opaque;
}

struct pthread_rwlockattr_t
{
    byte[8] __opaque;
}

alias int pthread_spinlock_t;
enum
{
  PTHREAD_CANCEL_DEFERRED = 0,
  PTHREAD_CANCEL_ASYNCHRONOUS = 1,
  PTHREAD_CANCEL_ENABLE = 0,
  PTHREAD_CANCEL_DISABLE = 1,
}

//alias int clockid_t;
struct utimbuf
{
    long actime;
    long modtime;
}

struct struct_stat
{
    ulong st_dev;
    ulong st_ino;
    ulong st_nlink;
    uint st_mode;
    uint st_uid;
    uint st_gid;
    ubyte[4] __pad1;
    ulong st_rdev;
    long st_size;
    long st_blksize;
    long st_blocks;
    long st_atime;
    ubyte[8] __pad2;
    long st_mtime;
    ubyte[8] __pad3;
    long st_ctime;
   ubyte[32] __pad4;
}

const auto S_IFMT	= 0170000;
const auto S_IFSOCK	= 0140000;
const auto S_IFLNK	= 0120000;
const auto S_IFREG	= 0100000;
const auto S_IFBLK	= 0060000;
const auto S_IFDIR	= 0040000;
const auto S_IFCHR	= 0020000;
const auto S_IFIFO	= 0010000;
const auto S_ISUID	= 0004000;
const auto S_ISGID	= 0002000;
const auto S_ISVTX	= 0001000;

bool S_ISLNK(uint mode) {
	return (mode & S_IFMT) == S_IFLNK;
}

bool S_ISREG(uint mode) {
	return (mode & S_IFMT) == S_IFREG;
}

bool S_ISDIR(uint mode) {
	return (mode & S_IFMT) == S_IFDIR;
}

bool S_ISCHR(uint mode) {
	return (mode & S_IFMT) == S_IFCHR;
}

bool S_ISBLK(uint mode) {
	return (mode & S_IFMT) == S_IFBLK;
}

bool S_ISFIFO(uint mode) {
	return (mode & S_IFMT) == S_IFIFO;
}

bool S_ISSOCK(uint mode) {
	return (mode & S_IFMT) == S_IFSOCK;
}

struct sigaction_t {
    union {
        extern(C) void function(int) sa_handler;
        extern(C) void function(int, siginfo_t *, void *) sa_sigaction;
    }
    sigset_t sa_mask;
    int sa_flags;
   ubyte[12] __pad1;
}


struct sockaddr {
    ushort sa_family;
    byte[14] sa_data;
}

struct fd_set {
    byte[128] __opaque;
}


enum
{
  AF_MAX = 34,
  AF_APPLETALK = 5,
  AF_INET6 = 10,
  AF_NETLINK = 16,
  AF_FILE = 1,
  AF_ROSE = 11,
  AF_NETROM = 6,
  AF_ATMPVC = 8,
  AF_WANPIPE = 25,
  AF_UNSPEC = 0,
  AF_BRIDGE = 7,
  AF_X25 = 9,
  AF_BLUETOOTH = 31,
  AF_ROUTE = 16,
  AF_SECURITY = 14,
  AF_RXRPC = 33,
  AF_AX25 = 3,
  AF_KEY = 15,
  AF_IUCV = 32,
  AF_ECONET = 19,
  AF_INET = 2,
  AF_ATMSVC = 20,
  AF_PPPOX = 24,
  AF_PACKET = 17,
  AF_IRDA = 23,
  AF_NETBEUI = 13,
  AF_SNA = 22,
  AF_LOCAL = 1,
  AF_ASH = 18,
  AF_UNIX = 1,
  AF_DECnet = 12,
  AF_IPX = 4,
}

struct sockaddr_in
{
    ushort sin_family = AF_INET;
    ushort sin_port;
    in_addr sin_addr;
    ubyte[8] sin_zero;
}

struct protoent
{
    char* p_name;
    char** p_aliases;
    int p_proto;
   ubyte[4] __pad1;
}

struct servent
{
    char* s_name;
    char** s_aliases;
    int s_port;
    ubyte[4] __pad1;
    char* s_proto;
}

alias uint socklen_t;
enum
{
  SOL_ATM = 264,
  SOL_PACKET = 263,
  SOL_IPV6 = 41,
  SOL_DECNET = 261,
  SOL_X25 = 262,
  SOL_IP = 0,
  SOL_ICMPV6 = 58,
  SOL_SOCKET = 1,
  SOL_TCP = 6,
  SOL_RAW = 255,
  SOL_IRDA = 266,
  SOL_AAL = 265,
}

struct sigset_t
{
    byte[128] __opaque;
}

//alias extern(C) void function(int) __sighandler_t;
const __sighandler_t SIG_DFL = cast(__sighandler_t) 0;
const __sighandler_t SIG_IGN = cast(__sighandler_t) 1;
const __sighandler_t SIG_ERR = cast(__sighandler_t) 0xffffffffffffffffUL;
struct siginfo_t
{
    int si_signo;
    int si_errno;
    int si_code;
   ubyte[116] __pad1;
}

extern (C):

// DMD linux.d has dirent.h declarations
//public import std.c.dirent;
//int dirfd(DIR*);
//public import std.c.stdio;
int fseeko(FILE*, off_t, int);
off_t ftello(FILE*);

int open(in char*, int, ...);
ssize_t read(int, void*, size_t);
ssize_t write(int, in void*, size_t);
int close(int);
off_t lseek(int, off_t, int);
int access(in char *path, int mode);
int utime(char *path, utimbuf *buf);
int fstat(int, struct_stat*);
int stat(in char*, struct_stat*);
int	lstat(in char *, struct_stat *);
int	chmod(in char *, mode_t);
int chdir(in char*);
int mkdir(in char*, mode_t);
int rmdir(in char*);
char* getcwd(char*, size_t);

pid_t fork();
int dup(int);
int dup2(int, int);
int pipe(int[2]);
pid_t wait(int*);
pid_t waitpid(pid_t, int*, int);
int kill(pid_t, int);

int gettimeofday(timeval*, void*);
int settimeofday(in timeval *, in void *);
time_t time(time_t*);
//tm *localtime(time_t*);

int sem_init (sem_t *, int, uint);
int sem_destroy (sem_t *);
sem_t * sem_open (char *, int, ...);
int sem_close(sem_t *);
int sem_wait(sem_t*);
int sem_post(sem_t*);
int sem_trywait(sem_t*);
int sem_getvalue(sem_t*, int*);

int sigemptyset(sigset_t*);
int sigfillset(sigset_t*);
int sigdelset(sigset_t*, int);
int sigismember(sigset_t *set, int);
int sigaction(int, sigaction_t*, sigaction_t*);
int sigsuspend(sigset_t*);

//Clong_t sysconf(int name);

// version ( Unix_Pthread )...
int pthread_attr_init(pthread_attr_t *);
int pthread_attr_destroy(pthread_attr_t *);
int pthread_attr_setdetachstate(pthread_attr_t *, int);
int pthread_attr_getdetachstate(pthread_attr_t *, int *);
int pthread_attr_setguardsize(pthread_attr_t*, size_t);
int pthread_attr_getguardsize(pthread_attr_t*, size_t *);
int pthread_attr_setinheritsched(pthread_attr_t *, int);
int pthread_attr_getinheritsched(pthread_attr_t *, int *);
int pthread_attr_setschedparam(pthread_attr_t *, sched_param *);
int pthread_attr_getschedparam(pthread_attr_t *, sched_param *);
int pthread_attr_setschedpolicy(pthread_attr_t *, int);
int pthread_attr_getschedpolicy(pthread_attr_t *, int*);
int pthread_attr_setscope(pthread_attr_t *, int);
int pthread_attr_getscope(pthread_attr_t *, int*);
int pthread_attr_setstack(pthread_attr_t *, void*, size_t);
int pthread_attr_getstack(pthread_attr_t *, void**, size_t *);
int pthread_attr_setstackaddr(pthread_attr_t *, void *);
int pthread_attr_getstackaddr(pthread_attr_t *, void **);
int pthread_attr_setstacksize(pthread_attr_t *, size_t);
int pthread_attr_getstacksize(pthread_attr_t *, size_t *);

int pthread_create(pthread_t*, pthread_attr_t*, void* (*)(void*), void*);
int pthread_join(pthread_t, void**);
int pthread_kill(pthread_t, int);
pthread_t pthread_self();
int pthread_equal(pthread_t, pthread_t);
int pthread_suspend_np(pthread_t);
int pthread_continue_np(pthread_t);
int pthread_cancel(pthread_t);
int pthread_setcancelstate(int state, int *oldstate);
int pthread_setcanceltype(int type, int *oldtype);
void pthread_testcancel();
int pthread_detach(pthread_t);
void pthread_exit(void*);
int pthread_getattr_np(pthread_t, pthread_attr_t*);
int pthread_getconcurrency();
int pthread_getcpuclockid(pthread_t, clockid_t*);

int pthread_cond_init(pthread_cond_t *, pthread_condattr_t *);
int pthread_cond_destroy(pthread_cond_t *);
int pthread_cond_signal(pthread_cond_t *);
int pthread_cond_broadcast(pthread_cond_t *);
int pthread_cond_wait(pthread_cond_t *, pthread_mutex_t *);
int pthread_cond_timedwait(pthread_cond_t *, pthread_mutex_t *, timespec *);
int pthread_condattr_init(pthread_condattr_t *);
int pthread_condattr_destroy(pthread_condattr_t *);
int pthread_condattr_getpshared(pthread_condattr_t *, int *);
int pthread_condattr_setpshared(pthread_condattr_t *, int);

int pthread_mutex_init(pthread_mutex_t *, pthread_mutexattr_t *);
int pthread_mutex_lock(pthread_mutex_t *);
int pthread_mutex_trylock(pthread_mutex_t *);
int pthread_mutex_unlock(pthread_mutex_t *);
int pthread_mutex_destroy(pthread_mutex_t *);
int pthread_mutexattr_init(pthread_mutexattr_t *);
int pthread_mutexattr_destroy(pthread_mutexattr_t *);
int pthread_mutexattr_getpshared(pthread_mutexattr_t *, int *);
int pthread_mutexattr_setpshared(pthread_mutexattr_t *, int);

int pthread_barrierattr_init(pthread_barrierattr_t*);
int pthread_barrierattr_getpshared(pthread_barrierattr_t*, int*);
int pthread_barrierattr_destroy(pthread_barrierattr_t*);
int pthread_barrierattr_setpshared(pthread_barrierattr_t*, int);

int pthread_barrier_init(pthread_barrier_t*, pthread_barrierattr_t*, uint);
int pthread_barrier_destroy(pthread_barrier_t*);
int pthread_barrier_wait(pthread_barrier_t*);

// version ( Unix_Sched )
void sched_yield();

// from <sys/mman.h>
void* mmap(void* addr, size_t len, int prot, int flags, int fd, off_t offset);
int munmap(void* addr, size_t len);
int msync(void* start, size_t length, int flags);
int madvise(void*, size_t, int);
int mlock(void*, size_t);
int munlock(void*, size_t);
int mlockall(int);
int munlockall();
//void* mremap(void*, size_t, size_t, Culong_t); // Linux specific
int mincore(void*, size_t, ubyte*);
int remap_file_pages(void*, size_t, int, ssize_t, int); // Linux specific
int shm_open(in char*, int, mode_t);
int shm_unlink(in char*);

// from <fcntl.h>
int fcntl(int fd, int cmd, ...);

int select(int n, fd_set *, fd_set *, fd_set *, timeval *);

// could probably rewrite fd_set stuff in D, but for now...
private void _d_gnu_fd_set(int n, fd_set * p);
private void _d_gnu_fd_clr(int n, fd_set * p);
private int  _d_gnu_fd_isset(int n, fd_set * p);
private void _d_gnu_fd_copy(fd_set * f, fd_set * t);
private void _d_gnu_fd_zero(fd_set * p);
// maybe these should go away in favor of fd_set methods
/*version (none)
{
    void FD_SET(int n, inout fd_set p) { return _d_gnu_fd_set(n, & p); }
    void FD_CLR(int n, inout fd_set p) { return _d_gnu_fd_clr(n, & p); }
    int FD_ISSET(int n, inout fd_set p) { return _d_gnu_fd_isset(n, & p); }
    void FD_COPY(inout fd_set f, inout fd_set t) { return _d_gnu_fd_copy(& f, & t); }
    void FD_ZERO(inout fd_set p) { return _d_gnu_fd_zero(& p); }
}*/
/*void FD_SET(int n,  fd_set * p) { return _d_gnu_fd_set(n, p); }
void FD_CLR(int n,  fd_set * p) { return _d_gnu_fd_clr(n, p); }
int FD_ISSET(int n, fd_set * p) { return _d_gnu_fd_isset(n, p); }
void FD_COPY(fd_set * f, inout fd_set * t) { return _d_gnu_fd_copy(f, t); }
void FD_ZERO(fd_set * p) { return _d_gnu_fd_zero(p); }*/

//void FD_SET(int, fd_set*p);

// from <pwd.h>
passwd *getpwnam(in char *name);
passwd *getpwuid(uid_t uid);
int getpwnam_r(char *name, passwd *pwbuf, char *buf, size_t buflen, passwd **pwbufp);
int getpwuid_r(uid_t uid, passwd *pwbuf, char *buf, size_t buflen, passwd **pwbufp);

// std/socket.d
enum: int
{
    SD_RECEIVE =  0,
    SD_SEND =     1,
    SD_BOTH =     2,
}

int socket(int af, int type, int protocol);
int bind(int s, sockaddr* name, int namelen);
int connect(int s, sockaddr* name, int namelen);
int listen(int s, int backlog);
int accept(int s, sockaddr* addr, int* addrlen);
int shutdown(int s, int how);
int getpeername(int s, sockaddr* name, int* namelen);
int getsockname(int s, sockaddr* name, int* namelen);
ssize_t send(int s, void* buf, size_t len, int flags);
ssize_t sendto(int s, void* buf, size_t len, int flags, sockaddr* to, int tolen);
ssize_t recv(int s, void* buf, size_t len, int flags);
ssize_t recvfrom(int s, void* buf, size_t len, int flags, sockaddr* from, int* fromlen);
int getsockopt(int s, int level, int optname, void* optval, int* optlen);
int setsockopt(int s, int level, int optname, void* optval, int optlen);
uint inet_addr(char* cp);
char* inet_ntoa(in_addr ina);
hostent* gethostbyname(char* name);
int gethostbyname_r(char* name, hostent* ret, void* buf, size_t buflen, hostent** result, int* h_errnop);
int gethostbyname2_r(char* name, int af, hostent* ret, void* buf, size_t buflen, hostent** result, int* h_errnop);
hostent* gethostbyaddr(void* addr, int len, int type);
protoent* getprotobyname(char* name);
protoent* getprotobynumber(int number);
servent* getservbyname(char* name, char* proto);
servent* getservbyport(int port, char* proto);
int gethostname(char* name, int namelen);
int getaddrinfo(char* nodename, char* servname, addrinfo* hints, addrinfo** res);
void freeaddrinfo(addrinfo* ai);
int getnameinfo(sockaddr* sa, socklen_t salen, char* node, socklen_t nodelen, char* service, socklen_t servicelen, int flags);

int htonl(int x);
short htons(int x);


//private import std.stdint;

/*version(BigEndian)
{
	uint16_t htons(uint16_t x)
	{
		return x;
	}


	uint32_t htonl(uint32_t x)
	{
		return x;
	}
}
else version(LittleEndian)
{
	private import std.intrinsic;


	uint16_t htons(uint16_t x)
	{
		return (x >> 8) | (x << 8);
	}


	uint32_t htonl(uint32_t x)
	{
		return bswap(x);
	}
}
else
{
	static assert(0);
}*/

//alias htons ntohs;
//alias htonl ntohl;

// from <time.h>
//char* asctime_r(in tm* t, char* buf);
char* ctime_r(in time_t* timep, char* buf);
//tm* gmtime_r(in time_t* timep, tm* result);
//tm* localtime_r(in time_t* timep, tm* result);

// misc.
uint alarm(uint);
char* basename(char*);
//wint_t btowc(int);
int chown(in char*, uid_t, gid_t);
int chroot(in char*);
size_t confstr(int, char*, size_t);
int creat(in char*, mode_t);
char* ctermid(char*);
char* dirname(char*);
int fattach(int, char*);
int fchmod(int, mode_t);
int fdatasync(int);
int ffs(int);
int fmtmsg(int, char*, int, char*, char*, char*);
int fpathconf(int, int);

extern char** environ;

// unix common somehow missing from phobos

alias int clockid_t;
alias void* timer_t;
alias int time_t;

alias int __pid_t;

//struct timespec {
//	time_t tv_sec;		/* Seconds.  */
//	int tv_nsec;		/* Nanoseconds.  */
//};//

struct itimerspec {
	timespec it_interval;
	timespec it_value;
};

const auto SIGEV_SIGNAL	= 0;	/* notify via signal */
const auto SIGEV_NONE	= 1;	/* other notification: meaningless */
const auto SIGEV_THREAD	= 2;	/* deliver via thread creation */

union sigval {
	int	sival_int;	/* integer value */
	void *sival_ptr;	/* pointer value */
}

const int __SIGEV_PAD_SIZE = 13;

// signals

alias void function(int) sighandler_t;

extern(C)
sighandler_t signal(int signum, sighandler_t handler);

enum
{
	SIGHUP = 1,
	SIGINT,
	SIGQUIT,
	SIGILL,
	SIGTRAP,
	SIGABRT,
	SIGBUS,
	SIGFPE,
	SIGKILL,
	SIGUSR1,
	SIGSEGV,
	SIGUSR2,
	SIGPIPE,
	SIGALRM,
	SIGTERM,
	SIGSTKFLT,
	SIGCHLD,
	SIGCONT,
	SIGSTOP,
	SIGTSTP,
	SIGTTIN,
	SIGTTOU,
	SIGURG,
	SIGXCPU,
	SIGXFSZ,
	SIGVALRM,
	SIGPROF,
	SIGWINCH,
	SIGIO
}

/* c_iflag bits */
const auto IGNBRK	= 0000001;
const auto BRKINT	= 0000002;
const auto IGNPAR	= 0000004;
const auto PARMRK	= 0000010;
const auto INPCK	= 0000020;
const auto ISTRIP	= 0000040;
const auto INLCR	= 0000100;
const auto IGNCR	= 0000200;
const auto ICRNL	= 0000400;
const auto IUCLC	= 0001000;
const auto IXON		= 0002000;
const auto IXANY	= 0004000;
const auto IXOFF	= 0010000;
const auto IMAXBEL	= 0020000;
const auto IUTF8	= 0040000;

/* c_lflag bits */
const auto ISIG		= 0000001;
const auto ICANON	= 0000002;
const auto XCASE	= 0000004;
const auto ECHO		= 0000010;
const auto ECHOE	= 0000020;
const auto ECHOK	= 0000040;
const auto ECHONL	= 0000100;
const auto NOFLSH	= 0000200;
const auto TOSTOP	= 0000400;
const auto ECHOCTL	= 0001000;
const auto ECHOPRT	= 0002000;
const auto ECHOKE	= 0004000;
const auto FLUSHO	= 0010000;
const auto PENDIN	= 0040000;
const auto IEXTEN	= 0100000;



struct sigevent_sigev_un_sigev_thread
{
	void function (sigval) _function; /* Function to start.  */
	void* _attribute;			/* Really pthread_attr_t.  */
}

union sigevent_sigev_un
{
	int _pad[__SIGEV_PAD_SIZE];

	/* When SIGEV_SIGNAL and SIGEV_THREAD_ID set, LWP ID of the
		thread to receive the signal.  */
	__pid_t _tid;

	sigevent_sigev_un_sigev_thread _sigev_thread;

}

struct sigevent
{
	sigval sigev_value;
	int sigev_signo;
	int sigev_notify;

	sigevent_sigev_un _sigev_un;
}

/+
struct sigevent {
	int		sigev_notify;	/* notification mode */
	int		sigev_signo;	/* signal number */
	sigval	sigev_value;	/* signal value */
	void function(sigval) sigev_notify_function;
	pthread_attr_t	*sigev_notify_attributes;
	int		__sigev_pad2;
}
+/

enum:uint
{
	STDIN = 0,
	STDOUT = 1,
	STDERR = 2
}

alias ubyte	cc_t;
alias uint	speed_t;
alias uint	tcflag_t;

const auto NCCS = 19;

struct termios {
	tcflag_t c_iflag;		/* input mode flags */
	tcflag_t c_oflag;		/* output mode flags */
	tcflag_t c_cflag;		/* control mode flags */
	tcflag_t c_lflag;		/* local mode flags */
	cc_t c_line;			/* line discipline */
	cc_t c_cc[NCCS];		/* control characters */
}

extern(C)
char *setlocale(int category, char *locale);

extern(C)
int timer_create(clockid_t clockid, sigevent* evp,
    timer_t *timerid);

extern(C)
int timer_delete(timer_t timerid);

extern(C)
int timer_settime(timer_t timerid, int flags,
    itimerspec* value, itimerspec* ovalue);

extern(C)
int nanosleep(timespec* rqtp, timespec* rmtp);

extern (C)
int ioctl (int, uint, ...);

alias void function(int) __sighandler_t;

extern(C) __sighandler_t sigset (int, __sighandler_t);

const int CLOCK_REALTIME = 0;

enum:int
{
  LC_CTYPE = 0,
  LC_NUMERIC = 1,
  LC_TIME = 2,
  LC_COLLATE = 3,
  LC_MONETARY = 4,
  LC_MESSAGES = 5,
  LC_ALL = 6,
  LC_PAPER = 7,
  LC_NAME = 8,
  LC_ADDRESS = 9,
  LC_TELEPHONE = 10,
  LC_MEASUREMENT = 11,
  LC_IDENTIFICATION = 12,
}


/* 0x54 is just a magic number to make these relatively unique ('T') */

const auto TCGETS		= 0x5401;
const auto TCSETS		= 0x5402; /* Clashes with SNDCTL_TMR_START sound ioctl */
const auto TCSETSW		= 0x5403;
const auto TCSETSF		= 0x5404;
const auto TCGETA		= 0x5405;
const auto TCSETA		= 0x5406;
const auto TCSETAW		= 0x5407;
const auto TCSETAF		= 0x5408;
const auto TCSBRK		= 0x5409;
const auto TCXONC		= 0x540A;
const auto TCFLSH		= 0x540B;
const auto TIOCEXCL		= 0x540C;
const auto TIOCNXCL		= 0x540D;
const auto TIOCSCTTY	= 0x540E;
const auto TIOCGPGRP	= 0x540F;
const auto TIOCSPGRP	= 0x5410;
const auto TIOCOUTQ		= 0x5411;
const auto TIOCSTI		= 0x5412;
const auto TIOCGWINSZ	= 0x5413;
const auto TIOCSWINSZ	= 0x5414;
const auto TIOCMGET		= 0x5415;
const auto TIOCMBIS		= 0x5416;
const auto TIOCMBIC		= 0x5417;
const auto TIOCMSET		= 0x5418;
const auto TIOCGSOFTCAR	= 0x5419;
const auto TIOCSSOFTCAR	= 0x541A;
const auto FIONREAD		= 0x541B;
const auto TIOCINQ		= FIONREAD;
const auto TIOCLINUX	= 0x541C;
const auto TIOCCONS		= 0x541D;
const auto TIOCGSERIAL	= 0x541E;
const auto TIOCSSERIAL	= 0x541F;
const auto TIOCPKT		= 0x5420;
const auto FIONBIO		= 0x5421;
const auto TIOCNOTTY	= 0x5422;
const auto TIOCSETD		= 0x5423;
const auto TIOCGETD		= 0x5424;
const auto TCSBRKP		= 0x5425;	/* Needed for POSIX tcsendbreak() */
/* const auto TIOCTTYGSTRUCT 0x5426 - Former debugging-only ioctl */
const auto TIOCSBRK		= 0x5427;  /* BSD compatibility */
const auto TIOCCBRK		= 0x5428;  /* BSD compatibility */
const auto TIOCGSID		= 0x5429;  /* Return the session ID of FD */
//const auto TIOCGPTN	_IOR('T',0x30, unsigned int) /* Get Pty Number (of pty-mux device) */
//const auto TIOCSPTLCK	_IOW('T',0x31, int)  /* Lock/unlock Pty */

const auto FIONCLEX			= 0x5450;
const auto FIOCLEX			= 0x5451;
const auto FIOASYNC			= 0x5452;
const auto TIOCSERCONFIG	= 0x5453;
const auto TIOCSERGWILD		= 0x5454;
const auto TIOCSERSWILD		= 0x5455;
const auto TIOCGLCKTRMIOS	= 0x5456;
const auto TIOCSLCKTRMIOS	= 0x5457;
const auto TIOCSERGSTRUCT	= 0x5458; /* For debugging only */
const auto TIOCSERGETLSR   	= 0x5459; /* Get line status register */
const auto TIOCSERGETMULTI 	= 0x545A; /* Get multiport config  */
const auto TIOCSERSETMULTI 	= 0x545B; /* Set multiport config */

const auto TIOCMIWAIT		= 0x545C;	/* wait for a change on serial input line(s) */
const auto TIOCGICOUNT		= 0x545D;	/* read serial port __inline__ interrupt counts */
const auto TIOCGHAYESESP   	= 0x545E;  /* Get Hayes ESP configuration */
const auto TIOCSHAYESESP   	= 0x545F;  /* Set Hayes ESP configuration */
const auto FIOQSIZE			= 0x5460;

/* Used for packet mode */
const auto TIOCPKT_DATA		 	=  0;
const auto TIOCPKT_FLUSHREAD	=  1;
const auto TIOCPKT_FLUSHWRITE	=  2;
const auto TIOCPKT_STOP		 	=  4;
const auto TIOCPKT_START		=  8;
const auto TIOCPKT_NOSTOP		= 16;
const auto TIOCPKT_DOSTOP		= 32;

const auto TIOCSER_TEMT    		= 0x01;	/* Transmitter physically empty */

enum
{
  IPPROTO_IP = 0,
  IPPROTO_ROUTING = 43,
  IPPROTO_EGP = 8,
  IPPROTO_PIM = 103,
  IPPROTO_ENCAP = 98,
  IPPROTO_ESP = 50,
  IPPROTO_PUP = 12,
  IPPROTO_IDP = 22,
  IPPROTO_IPIP = 4,
  IPPROTO_TCP = 6,
  IPPROTO_IPV6 = 41,
  IPPROTO_SCTP = 132,
  IPPROTO_AH = 51,
  IPPROTO_MTP = 92,
  IPPROTO_TP = 29,
  IPPROTO_UDP = 17,
  IPPROTO_HOPOPTS = 0,
  IPPROTO_RAW = 255,
  IPPROTO_ICMP = 1,
  IPPROTO_GGP = 3,
  IPPROTO_FRAGMENT = 44,
  IPPROTO_GRE = 47,
  IPPROTO_DSTOPTS = 60,
  IPPROTO_NONE = 59,
  IPPROTO_RSVP = 46,
  IPPROTO_IGMP = 2,
  IPPROTO_ICMPV6 = 58,
  IPPROTO_COMP = 108,
}

enum
{
  IPV6_RTHDR_TYPE_0 = 0,
  IPV6_LEAVE_GROUP = 21,
  IPV6_PMTUDISC_WANT = 1,
  IPV6_NEXTHOP = 9,
  IPV6_IPSEC_POLICY = 34,
  IPV6_2292HOPOPTS = 3,
  IPV6_HOPOPTS = 54,
  IPV6_MTU_DISCOVER = 23,
  IPV6_AUTHHDR = 10,
  IPV6_ADD_MEMBERSHIP = 20,
  IPV6_DSTOPTS = 59,
  IPV6_2292PKTOPTIONS = 6,
  IPV6_RECVHOPOPTS = 53,
  IPV6_XFRM_POLICY = 35,
  IPV6_RXHOPOPTS = 54,
  IPV6_UNICAST_HOPS = 16,
  IPV6_ROUTER_ALERT = 22,
  IPV6_V6ONLY = 26,
  IPV6_RECVRTHDR = 56,
  IPV6_RECVHOPLIMIT = 51,
  IPV6_RECVTCLASS = 66,
  IPV6_RTHDR_STRICT = 1,
  IPV6_MTU = 24,
  IPV6_RECVDSTOPTS = 58,
  IPV6_MULTICAST_IF = 17,
  IPV6_RECVERR = 25,
  IPV6_RXDSTOPTS = 59,
  IPV6_2292PKTINFO = 2,
  IPV6_2292DSTOPTS = 4,
  IPV6_MULTICAST_HOPS = 18,
  IPV6_HOPLIMIT = 52,
  IPV6_PMTUDISC_DO = 2,
  IPV6_PKTINFO = 50,
  IPV6_RTHDRDSTOPTS = 55,
  IPV6_JOIN_ANYCAST = 27,
  IPV6_TCLASS = 67,
  IPV6_2292RTHDR = 5,
  IPV6_RTHDR_LOOSE = 0,
  IPV6_ADDRFORM = 1,
  IPV6_JOIN_GROUP = 20,
  IPV6_RTHDR = 57,
  IPV6_RECVPKTINFO = 49,
  IPV6_DROP_MEMBERSHIP = 21,
  IPV6_MULTICAST_LOOP = 19,
  IPV6_2292HOPLIMIT = 8,
  IPV6_LEAVE_ANYCAST = 28,
  IPV6_PMTUDISC_DONT = 0,
  IPV6_CHECKSUM = 7,
}

enum : uint
{
  INADDR_MAX_LOCAL_GROUP = -536870657,
  INADDR_ALLHOSTS_GROUP = -536870911,
  INADDR_ANY = 0,
  INADDR_UNSPEC_GROUP = -536870912,
  INADDR_NONE = -1,
  INADDR_ALLRTRS_GROUP = -536870910,
  INADDR_LOOPBACK = 2130706433,
  INADDR_BROADCAST = -1,
}

enum { ADDR_ANY = INADDR_ANY }
enum
{
  TCP_KEEPCNT = 6,
  TCP_CONGESTION = 13,
  TCP_CORK = 3,
  TCP_WINDOW_CLAMP = 10,
  TCP_MSS = 512,
  TCP_DEFER_ACCEPT = 9,
  TCP_KEEPIDLE = 4,
  TCP_MD5SIG_MAXKEYLEN = 80,
  TCP_MAX_WINSHIFT = 14,
  TCP_SYNCNT = 7,
  TCP_MAXSEG = 2,
  TCP_QUICKACK = 12,
  TCP_MAXWIN = 65535,
  TCP_KEEPINTVL = 5,
  TCP_INFO = 11,
  TCP_LINGER2 = 8,
  TCP_MD5SIG = 14,
  TCP_NODELAY = 1,
}


enum
{
  SOCK_RAW = 3,
  SOCK_RDM = 4,
  SOCK_SEQPACKET = 5,
  SOCK_PACKET = 10,
  SOCK_DGRAM = 2,
  SOCK_STREAM = 1,
}

