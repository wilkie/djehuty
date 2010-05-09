/*
 * c.d
 *
 * This module binds the C language to D.
 *
 * Author: Dave Wilkinson
 * Originated: July 7th, 2009
 *
 */

/* C long types */

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

version(Tango) {
	public import tango.stdc.stdarg;
	public import tango.stdc.stdio : wchar_t, stdout, _iobuf, FILE, fpos_t;

	extern(C) int printf(char *,...);	///
}
else {
	public import std.c.stdarg;
	version(GNU) {
		public import gcc.config.libc;
		alias gcc.config.libc.fpos_t fpos_t;
	}
	else {
		public import std.c.stdio;
	}
}

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
int	 vfprintf(FILE *,char *,va_list);	///
int	 vprintf(char *,va_list);	///
int	 sprintf(char *,char *,...);	///
int	 vsprintf(char *,char *,va_list);	///
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
