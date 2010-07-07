/*
 * c.d
 *
 * This module binds the C language to D.
 *
 * Author: Dave Wilkinson
 * Originated: July 7th, 2009
 *
 */

module binding.c;

/* C long types */
version(PlatformWindows) {
}
else {
	pragma(lib, `"c"`);
}

version(GNU) {
	import gcc.builtins;
    alias __builtin_Clong Clong_t;
    alias __builtin_Culong Culong_t;
}
else version(X86_64) {
    alias long Clong_t;
    alias ulong Culong_t;
}
else {
    alias int Clong_t;
    alias uint Culong_t;
}

/* stdarg */

version(GNU) {
	private import std.c.stdarg;
}
else version(LDC) {
	private import ldc.cstdarg;
}
else {
	private import dmd.cstdarg;
}

alias va_list Cva_list;
alias va_start Cva_start;
alias va_end Cva_end;

/* stdout */

align(1) struct _iobuf {
	version( Win32 ) {
		char* _ptr;
		int   _cnt;
		char* _base;
		int   _flag;
		int   _file;
		int   _charbuf;
		int   _bufsiz;
		int   __tmpnum;
	}
	else version( linux ) {
		char*   _read_ptr;
		char*   _read_end;
		char*   _read_base;
		char*   _write_base;
		char*   _write_ptr;
		char*   _write_end;
		char*   _buf_base;
		char*   _buf_end;
		char*   _save_base;
		char*   _backup_base;
		char*   _save_end;
		void*   _markers;
		_iobuf* _chain;
		int     _fileno;
		int     _blksize;
		int     _old_offset;
		ushort  _cur_column;
		byte    _vtable_offset;
		char[1] _shortbuf;
		void*   _lock;
	}
	else version( darwin ) {
		ubyte*    _p;
		int       _r;
		int       _w;
		short     _flags;
		short     _file;
		__sbuf    _bf;
		int       _lbfsize;

		int* function(void*)                    _close;
		int* function(void*, char*, int)        _read;
		fpos_t* function(void*, fpos_t, int)    _seek;
		int* function(void*, char *, int)       _write;

		__sbuf    _ub;
		__sFILEX* _extra;
		int       _ur;

		ubyte[3]  _ubuf;
		ubyte[1]  _nbuf;

		__sbuf    _lb;

		int       _blksize;
		fpos_t    _offset;
	}
	else version( freebsd ) {
		ubyte*    _p;
		int       _r;
		int       _w;
		short     _flags;
		short     _file;
		__sbuf    _bf;
		int       _lbfsize;

		void* function()                        _cookie;
		int* function(void*)                    _close;
		int* function(void*, char*, int)        _read;
		fpos_t* function(void*, fpos_t, int)    _seek;
		int* function(void*, char *, int)       _write;

		__sbuf    _ub;
		__sFILEX* _extra;
		int       _ur;

		ubyte[3]  _ubuf;
		ubyte[1]  _nbuf;

		__sbuf    _lb;

		int       _blksize;
		fpos_t    _offset;
	}
	else version( solaris ) {
		// From OpenSolaris <ast/sfio_s.h>
		ubyte*  _next;  /* next position to read/write from */
		ubyte*  _endw;  /* end of write buffer          */
		ubyte*  _endr;  /* end of read buffer           */
		ubyte*  _endb;  /* end of buffer            */
		_iobuf* _push;  /* the stream that was pushed on    */
		ushort  _flags; /* type of stream           */
		short   _file;  /* file descriptor          */
		ubyte*  _data;  /* base of data buffer          */
		ptrdiff_t _size;  /* buffer size              */
		ptrdiff_t _val;   /* values or string lengths     */

		//  #ifdef _SFIO_PRIVATE
		// .. I don't think we really need this in D
		//  #endif
	}
	else {
		static assert( false, "Platform not supported." );
	}
}

const int _NFILE = 60;
alias _iobuf FILE;
alias int fpos_t;

version(Win32) {
	extern(C) extern FILE[_NFILE] _iob;
	FILE* stdin  = &_iob[0];
	FILE* stdout = &_iob[1];
	FILE* stderr = &_iob[2];
}
else version(linux) {
	extern(C) extern FILE* stdin;
	extern(C) extern FILE* stdout;
	extern(C) extern FILE* stderr;
}
else version(darwin) {
	extern(C) extern FILE* __stdinp;
	extern(C) extern FILE* __stdoutp;
	extern(C) extern FILE* __stderrp;

	alias __stdinp stdin;
	alias __stdoutp stdout;
	alias __stderrp stderr;
}
else version(freebsd) {
    extern(C) extern FILE[3] __sF;

    FILE* stdin  = &__sF[0];
    FILE* stdout = &__sF[1];
    FILE* stderr = &__sF[2];
}
else version(solaris) {
    extern(C) extern FILE[_NFILE] __iob;
    
    FILE* stdin  = &__iob[0];
    FILE* stdout = &__iob[1];
    FILE* stderr = &__iob[2];
}
else {
	static assert(false, "Platform not supported.");
}

// wchar_t
version(Win32) {
	alias ushort wchar_t;
}
else {
	alias uint wchar_t;
}

extern(C) FILE[_NFILE]* _imp__iob;

	//public import std.c.stdarg;
	//public import std.c.stdio;

extern(C) int printf(char *,...);

const int EOF = -1;
const int FOPEN_MAX = 16;
const int FILENAME_MAX = 4095;
const int TMP_MAX = 238328;
const int L_tmpnam = 20;

enum { SEEK_SET, SEEK_CUR, SEEK_END }

extern(C):

// Standard C

void exit(int);

int system(char*);

char *	 tmpnam(char *);	///
FILE *	 fopen(char *,char *);	///
FILE *	 _fsopen(char *,char *,int );	///
FILE *	 freopen(char *,char *,FILE *);	///
int	 fseek(FILE *,Clong_t,int);	///
Clong_t  ftell(FILE *);	///
char *	 fgets(char *,int,FILE *);	///
int	 fgetc(FILE *);	///
int	 _fgetchar();	///
int	 fflush(FILE *);	///
int	 fclose(FILE *);	///
int	 fputs(char *,FILE *);	///
char *	 gets(char *);	///
int	 fputc(int,FILE *);	///
int	 _fputchar(int);	///
int	 puts(char *);	///
int	 ungetc(int,FILE *);	///
size_t	 fread(void *,size_t,size_t,FILE *);	///
size_t	 fwrite(void *,size_t,size_t,FILE *);	///
int	 fprintf(FILE *,char *,...);	///
int	 vfprintf(FILE *,char *,Cva_list);	///
int	 vprintf(char *,Cva_list);	///
int	 sprintf(char *,char *,...);	///
int	 vsprintf(char *,char *,Cva_list);	///
int	 scanf(char *,...);	///
int	 fscanf(FILE *,char *,...);	///
int	 sscanf(char *,char *,...);	///
void	 setbuf(FILE *,char *);	///
int	 setvbuf(FILE *,char *,int,size_t);	///
int	 remove(char *);	///
int	 rename(char *,char *);	///
void	 perror(char *);	///
int	 fgetpos(FILE *,fpos_t *);	///
int	 fsetpos(FILE *,fpos_t *);	///
FILE *	 tmpfile();	///
int	 _rmtmp();
int      _fillbuf(FILE *);
int      _flushbu(int, FILE *);

int  getw(FILE *FHdl);	///
int  putw(int Word, FILE *FilePtr);	///

int  getchar(); ///
int  putchar(int c); ///
int  getc(FILE *fp); ///
int  putc(int c,FILE *fp); ///

void* malloc(size_t len);
void* realloc(void* ptr, size_t len);
void* calloc(size_t len);
void free(void* ptr);
