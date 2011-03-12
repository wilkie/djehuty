/*
 * ruby.d
 *
 * This file holds bindings to ruby. The original copyrights
 * are displayed below, but do not pertain to this file.
 *
 */

module binding.ruby.ruby;

import binding.c;

extern (C):

/**********************************************************************

  ruby.h -

  $Author$
  created at: Sun 10 12:06:15 Jun JST 2007

  Copyright (C) 2007-2008 Yukihiro Matsumoto

**********************************************************************/

// ruby.h

const auto HAVE_RUBY_DEFINES_H = 1;
const auto HAVE_RUBY_ENCODING_H   = 1;
const auto HAVE_RUBY_INTERN_H     = 1;
const auto HAVE_RUBY_IO_H         = 1;
const auto HAVE_RUBY_MISSING_H    = 1;
const auto HAVE_RUBY_ONIGURUMA_H  = 1;
const auto HAVE_RUBY_RE_H         = 1;
const auto HAVE_RUBY_REGEX_H      = 1;
const auto HAVE_RUBY_RUBY_H       = 1;
const auto HAVE_RUBY_ST_H         = 1;
const auto HAVE_RUBY_UTIL_H       = 1;
const auto HAVE_RUBY_VERSION_H    = 1;
const auto HAVE_RUBY_VM_H         = 1;

version(PlatformWindows) {
	const auto HAVE_RUBY_WIN32_H      = 1;
}

// ruby/ruby.h follows

/**********************************************************************

  ruby/ruby.h -

  $Author: yugui $
  created at: Thu Jun 10 14:26:32 JST 1993

  Copyright (C) 1993-2008 Yukihiro Matsumoto
  Copyright (C) 2000  Network Applied Communication Laboratory, Inc.
  Copyright (C) 2000  Information-technology Promotion Agency, Japan

**********************************************************************/

const auto NORETURN_STYLE_NEW = 1;

public import binding.ruby.defines;
public import binding.ruby.intern;

alias uint* VALUE;
alias uint* ID;
alias int* SIGNED_VALUE;
const auto SIZEOF_VALUE = (uint*).sizeof;

const auto FIXNUM_MAX = (Clong_t.max>>1);
const auto FIXNUM_MIN = (cast(Clong_t)Clong_t.min) >> 1;

template INT2FIX(i) {
	const auto INT2FIX = cast(VALUE)((cast(SIGNED_VALUE)i) << 1 | FIXNUM_FLAG);
}
template LONG2FIX(i) {
	const auto LONG2FIX = INT2FIX!(i);
}
template rb_fix_new(v) {
	const auto rb_fix_new = INT2FIX!(v);
}

VALUE rb_int2inum(SIGNED_VALUE);

alias rb_int2inum rb_int_new;

VALUE rb_uint2inum(VALUE);

alias rb_uint2inum rb_uint_new;

VALUE rb_ll2inum(long);
alias rb_ll2inum LL2NUM;

VALUE rb_ull2inum(ulong);
alias rb_ull2inum ULL2NUM;

const auto SSIZE_MAX = size_t.max;
const auto SSIZE_MIN = size_t.min;

void rb_out_of_int(SIGNED_VALUE);

template FIX2LONG(x) {
	const auto FIX2LONG = (cast(SIGNED_VALUE)x) >> 1;
}
template FIX2ULONG(x) {
	const auto FIX2ULONG = ((cast(VALUE)x) >> 1) & LONG_MAX;
}
template FIXNUM_P(f) {
	const auto FIXNUM_P = (cast(SIGNED_VALUE)f) & FIXNUM_FLAG;
}
template POSFIXABLE(f) {
	const auto POSFIXABLE = f < (FIXNUM_MAX+1);
}

template NEGFIXABLE(f) {
	const auto NEGFIXABLE = f >= FIXNUM_MIN;
}
template FIXABLE(f) {
	const auto FIXABLE = POSFIXABLE!(f) && NEGFIXABLE!(f);
}
template IMMEDIATE_P(x) {
	const auto IMMEDIATE_P = cast(VALUE)x & IMMEDIATE_MASK;
}
template SYMBOL_P(x) {
	const auto SYMBOL_P = (cast(VALUE)x & ~((~cast(VALUE)0) << RubySpecialConstants.RUBY_SPECIAL_SHIFT)) == SYMBOL_FLAG;
}
template ID2SYM(x) {
	const auto ID2SYM = ((cast(VALUE)x << RubySpecialConstants.RUBY_SPECIAL_SHIFT) | SYMBOL_FLAG);
}

template SYM2ID(x) {
	const auto SYM2ID = cast(Culong_t)x >> RubySpecialConstants.RUBY_SPECIAL_SHIFT;
}

/* Module#methods, #singleton_methods and so on return Symbols */
const auto USE_SYMBOL_AS_METHOD_NAME = 1;

/* special constants - i.e. non-zero and non-fixnum constants */
enum RubySpecialConstants {
    RUBY_Qfalse = 0,
    RUBY_Qtrue  = 2,
    RUBY_Qnil   = 4,
    RUBY_Qundef = 6,

    RUBY_IMMEDIATE_MASK = 0x03,
    RUBY_FIXNUM_FLAG    = 0x01,
    RUBY_SYMBOL_FLAG    = 0x0e,
    RUBY_SPECIAL_SHIFT  = 8
}

const auto Qfalse = (cast(VALUE)RubySpecialConstants.RUBY_Qfalse);
const auto Qtrue = (cast(VALUE)RubySpecialConstants.RUBY_Qtrue);
const auto Qnil  = (cast(VALUE)RubySpecialConstants.RUBY_Qnil);
/* undefined value for placeholder */
const auto Qundef = (cast(VALUE)RubySpecialConstants.RUBY_Qundef);

const auto IMMEDIATE_MASK = RubySpecialConstants.RUBY_IMMEDIATE_MASK;
const auto FIXNUM_FLAG = RubySpecialConstants.RUBY_FIXNUM_FLAG;
const auto SYMBOL_FLAG = RubySpecialConstants.RUBY_SYMBOL_FLAG;

template RTEST(v) {
	const auto RTEST = (cast(VALUE)v & ~Qnil) != 0;
}
template NIL_P(v) {
	const auto NIL_P = cast(VALUE)(v) == Qnil;
}

enum RubyValueType {
    RUBY_T_NONE   = 0x00,

    RUBY_T_OBJECT = 0x01,
    RUBY_T_CLASS  = 0x02,
    RUBY_T_MODULE = 0x03,
    RUBY_T_FLOAT  = 0x04,
    RUBY_T_STRING = 0x05,
    RUBY_T_REGEXP = 0x06,
    RUBY_T_ARRAY  = 0x07,
    RUBY_T_HASH   = 0x08,
    RUBY_T_STRUCT = 0x09,
    RUBY_T_BIGNUM = 0x0a,
    RUBY_T_FILE   = 0x0b,
    RUBY_T_DATA   = 0x0c,
    RUBY_T_MATCH  = 0x0d,
    RUBY_T_COMPLEX  = 0x0e,
    RUBY_T_RATIONAL = 0x0f,

    RUBY_T_NIL    = 0x11,
    RUBY_T_TRUE   = 0x12,
    RUBY_T_FALSE  = 0x13,
    RUBY_T_SYMBOL = 0x14,
    RUBY_T_FIXNUM = 0x15,

    RUBY_T_UNDEF  = 0x1b,
    RUBY_T_NODE   = 0x1c,
    RUBY_T_ICLASS = 0x1d,
    RUBY_T_ZOMBIE = 0x1e,

    RUBY_T_MASK   = 0x1f
}

const auto T_NONE   = RubyValueType.RUBY_T_NONE;
const auto T_NIL    = RubyValueType.RUBY_T_NIL;
const auto T_OBJECT = RubyValueType.RUBY_T_OBJECT;
const auto T_CLASS  = RubyValueType.RUBY_T_CLASS;
const auto T_ICLASS = RubyValueType.RUBY_T_ICLASS;
const auto T_MODULE = RubyValueType.RUBY_T_MODULE;
const auto T_FLOAT  = RubyValueType.RUBY_T_FLOAT;
const auto T_STRING = RubyValueType.RUBY_T_STRING;
const auto T_REGEXP = RubyValueType.RUBY_T_REGEXP;
const auto T_ARRAY  = RubyValueType.RUBY_T_ARRAY;
const auto T_HASH   = RubyValueType.RUBY_T_HASH;
const auto T_STRUCT = RubyValueType.RUBY_T_STRUCT;
const auto T_BIGNUM = RubyValueType.RUBY_T_BIGNUM;
const auto T_FILE   = RubyValueType.RUBY_T_FILE;
const auto T_FIXNUM = RubyValueType.RUBY_T_FIXNUM;
const auto T_TRUE   = RubyValueType.RUBY_T_TRUE;
const auto T_FALSE  = RubyValueType.RUBY_T_FALSE;
const auto T_DATA   = RubyValueType.RUBY_T_DATA;
const auto T_MATCH  = RubyValueType.RUBY_T_MATCH;
const auto T_SYMBOL = RubyValueType.RUBY_T_SYMBOL;
const auto T_RATIONAL = RubyValueType.RUBY_T_RATIONAL;
const auto T_COMPLEX = RubyValueType.RUBY_T_COMPLEX;
const auto T_UNDEF  = RubyValueType.RUBY_T_UNDEF;
const auto T_NODE   = RubyValueType.RUBY_T_NODE;
const auto T_ZOMBIE = RubyValueType.RUBY_T_ZOMBIE;
const auto T_MASK   = RubyValueType.RUBY_T_MASK;

int rb_type(VALUE);
alias rb_type TYPE;

VALUE* rb_gc_guarded_ptr(VALUE* ptr) {
	return ptr;
}
alias rb_gc_guarded_ptr RB_GC_GUARD_PTR;
VALUE RB_GC_GUARD(in VALUE v) {
	return *RB_GC_GUARD_PTR(&v);
}

void rb_check_type(VALUE,int);
alias rb_check_type Check_Type;

VALUE rb_str_to_str(VALUE);
VALUE rb_string_value(VALUE*);
char* rb_string_value_ptr(VALUE*);
char* rb_string_value_cstr(VALUE*);

VALUE StringValue(in VALUE v) {
	return rb_string_value(&v);
}
char* StringValuePtr(in VALUE v) {
	return rb_string_value_ptr(&v);
}
char* StringValueCStr(in VALUE v) {
	return rb_string_value_cstr(&v);
}

void rb_check_safe_obj(VALUE);
void SafeStringValue(in VALUE v) {
	StringValue(v);
	rb_check_safe_obj(v);
}

VALUE rb_str_export(VALUE);
void ExportStringValue(in VALUE v) {
	SafeStringValue(v);
	v = rb_str_export(v);
}
VALUE rb_str_export_locale(VALUE);

VALUE rb_get_path(VALUE);
VALUE FilePathValue(in VALUE v) {
	v = rb_get_path(v);
	return RB_GC_GUARD(v);
}

VALUE rb_get_path_no_checksafe(VALUE);

void rb_secure(int);
int rb_safe_level();
void rb_set_safe_level(int);
void rb_set_safe_level_force(int);
void rb_secure_update(VALUE);
void rb_insecure_operation();

VALUE rb_errinfo();
void rb_set_errinfo(VALUE);

SIGNED_VALUE rb_num2long(VALUE);
VALUE rb_num2ulong(VALUE);

Clong_t rb_num2int(VALUE);
Clong_t rb_fix2int(VALUE);
Culong_t rb_num2uint(VALUE);
Culong_t rb_fix2uint(VALUE);

long rb_num2ll(VALUE);
ulong rb_num2ull(VALUE);

double rb_num2dbl(VALUE);

VALUE rb_uint2big(VALUE);
VALUE rb_int2big(SIGNED_VALUE);

VALUE rb_newobj();

struct RBasic {
    VALUE flags;
    VALUE klass;
}

const auto ROBJECT_EMBED_LEN_MAX = 3;

struct RObject {
    RBasic basic;

    union _as {
		struct _heap {
			Clong_t numiv;
			VALUE *ivptr;
			st_table* iv_index_tbl; /* shortcut for RCLASS_IV_INDEX_TBL(rb_obj_class(obj)) */
		}
		_heap heap;
		VALUE ary[ROBJECT_EMBED_LEN_MAX];
	}
	_as as;
}

const auto ROBJECT_EMBED = FL_USER1;

struct rb_classext_t {
    VALUE _super;
    st_table* iv_tbl;
}

struct RClass {
    RBasic basic;
    rb_classext_t* ptr;
    st_table* m_tbl;
    st_table* iv_index_tbl;
}

struct RFloat {
    RBasic basic;
    double float_value;
}

alias FL_USER2 ELTS_SHARED;

const auto RSTRING_EMBED_LEN_MAX = (cast(int)((VALUE.sizeof*3)/char.sizeof-1));

struct RString {
    RBasic basic;
	union _as {
		struct _heap {
			Clong_t len;
			char *ptr;
			union _aux {
				Clong_t capa;
				VALUE shared;
			}
			_aux aux;
		} 
		_heap heap;
		char[RSTRING_EMBED_LEN_MAX + 1] ary;
	} 
	_as as;
}

const auto RSTRING_NOEMBED = FL_USER1;
const auto RSTRING_EMBED_LEN_MASK = (cast(int)FL_USER2|cast(int)FL_USER3|cast(int)FL_USER4|cast(int)FL_USER5|cast(int)FL_USER6);
const auto RSTRING_EMBED_LEN_SHIFT = (FL_USHIFT+2);

const auto RARRAY_EMBED_LEN_MAX = 3;

struct RArray {
    RBasic basic;
	union _as {
		struct _heap {
			Clong_t len;
			union _aux {
				Clong_t capa;
				VALUE shared;
			} 
			_aux aux;
			VALUE *ptr;
		} 
		_heap heap;
		VALUE[RARRAY_EMBED_LEN_MAX] ary;
	} 
	_as as;
}

const auto RARRAY_EMBED_FLAG= FL_USER1;
/* FL_USER2 is for ELTS_SHARED */
const auto RARRAY_EMBED_LEN_MASK= (cast(int)FL_USER4|cast(int)FL_USER3);
const auto RARRAY_EMBED_LEN_SHIFT= (FL_USHIFT+3);

struct re_pattern_buffer;

struct RRegexp {
    RBasic basic;
    re_pattern_buffer *ptr;
    VALUE src;
    Culong_t usecnt;
}

struct RHash {
    RBasic basic;
    st_table *ntbl;      /* possibly 0 */
    int iter_lev;
    VALUE ifnone;
}

/* RHASH_TBL allocates st_table if not available. */

struct rb_io_t;

struct RFile {
    RBasic basic;
    rb_io_t *fptr;
}

struct RRational {
    RBasic basic;
    VALUE num;
    VALUE den;
}

struct RComplex {
    RBasic basic;
    VALUE _real;
    VALUE imag;
}

struct RData {
    RBasic basic;
    void function(void*) dmark;
    void function(void*) dfree;
    void *data;
}

struct rb_data_type_t {
    char *wrap_struct_name;
    void function(void*) dmark;
    void function(void*) dfree;
	size_t function(void*) dsize;
    void*[3] reserved; /* For future extension.
                          This array *must* be filled with ZERO. */
    void *data;        /* This area can be used for any purpose
                          by a programmer who define the type. */
}

struct RTypedData {
    RBasic basic;
    rb_data_type_t *type;
    VALUE typed_flag; /* 1 or not */
    void *data;
}

alias void function(void*) RUBY_DATA_FUNC;

VALUE rb_data_object_alloc(VALUE,void*,RUBY_DATA_FUNC,RUBY_DATA_FUNC);
VALUE rb_data_typed_object_alloc(VALUE klass, void *datap, rb_data_type_t *);
int rb_typeddata_is_kind_of(VALUE, rb_data_type_t *);
void *rb_check_typeddata(VALUE, rb_data_type_t *);

const auto RSTRUCT_EMBED_LEN_MAX = 3;

struct RStruct {
	RBasic basic;
	union _as {
		struct _heap {
			Clong_t len;
			VALUE *ptr;
		} 
		_heap heap;
		VALUE[RSTRUCT_EMBED_LEN_MAX] ary;
	} 
	_as as;
}

const auto RSTRUCT_EMBED_LEN_MASK= (cast(int)FL_USER2|cast(int)FL_USER1);
const auto RSTRUCT_EMBED_LEN_SHIFT= (FL_USHIFT+1);

const auto RBIGNUM_EMBED_LEN_MAX= (cast(int)(((VALUE.sizeof)*3)/(BDIGIT.sizeof)));

struct RBignum {
    RBasic basic;
    union _as {
        struct _heap {
            Clong_t len;
            BDIGIT *digits;
        } 
		_heap heap;
        BDIGIT[RBIGNUM_EMBED_LEN_MAX] ary;
    } 
	_as as;
}

const auto RBIGNUM_SIGN_BIT= FL_USER1;
/* sign: positive:1, negative:0 */

const auto RBIGNUM_EMBED_FLAG= FL_USER2;
const auto RBIGNUM_EMBED_LEN_MASK= (cast(int)FL_USER5|cast(int)FL_USER4|cast(int)FL_USER3);
const auto RBIGNUM_EMBED_LEN_SHIFT= (FL_USHIFT+3);

const auto FL_SINGLETON= FL_USER0;
const auto FL_MARK     = cast(VALUE)(1<<5);
const auto FL_RESERVED = cast(VALUE)(1<<6); /* will be used in the future GC */
const auto FL_FINALIZE = cast(VALUE)(1<<7);
const auto FL_TAINT    = cast(VALUE)(1<<8);
const auto FL_UNTRUSTED= cast(VALUE)(1<<9);
const auto FL_EXIVAR   = cast(VALUE)(1<<10);
const auto FL_FREEZE   = cast(VALUE)(1<<11);

const auto FL_USHIFT   = 12;

const auto FL_USER0    = cast(VALUE)(1<<(FL_USHIFT+0));
const auto FL_USER1    = cast(VALUE)(1<<(FL_USHIFT+1));
const auto FL_USER2    = cast(VALUE)(1<<(FL_USHIFT+2));
const auto FL_USER3    = cast(VALUE)(1<<(FL_USHIFT+3));
const auto FL_USER4    = cast(VALUE)(1<<(FL_USHIFT+4));
const auto FL_USER5    = cast(VALUE)(1<<(FL_USHIFT+5));
const auto FL_USER6    = cast(VALUE)(1<<(FL_USHIFT+6));
const auto FL_USER7    = cast(VALUE)(1<<(FL_USHIFT+7));
const auto FL_USER8    = cast(VALUE)(1<<(FL_USHIFT+8));
const auto FL_USER9    = cast(VALUE)(1<<(FL_USHIFT+9));
const auto FL_USER10   = cast(VALUE)(1<<(FL_USHIFT+10));
const auto FL_USER11   = cast(VALUE)(1<<(FL_USHIFT+11));
const auto FL_USER12   = cast(VALUE)(1<<(FL_USHIFT+12));
const auto FL_USER13   = cast(VALUE)(1<<(FL_USHIFT+13));
const auto FL_USER14   = cast(VALUE)(1<<(FL_USHIFT+14));
const auto FL_USER15   = cast(VALUE)(1<<(FL_USHIFT+15));
const auto FL_USER16   = cast(VALUE)(1<<(FL_USHIFT+16));
const auto FL_USER17   = cast(VALUE)(1<<(FL_USHIFT+17));
const auto FL_USER18   = cast(VALUE)(1<<(FL_USHIFT+18));
const auto FL_USER19   = cast(VALUE)(1<<(FL_USHIFT+19));

void rb_obj_infect(VALUE,VALUE);

alias int function(char* VALUE, void*) ruby_glob_func;

void rb_glob(char*, void function(char*,VALUE,void*), VALUE);
int ruby_glob(char*,int,ruby_glob_func*,VALUE);
int ruby_brace_glob(char*,int,ruby_glob_func*,VALUE);

VALUE rb_define_class(char*,VALUE);
VALUE rb_define_module(char*);
VALUE rb_define_class_under(VALUE, char*, VALUE);
VALUE rb_define_module_under(VALUE, char*);

void rb_include_module(VALUE,VALUE);
void rb_extend_object(VALUE,VALUE);

struct rb_global_variable;

alias VALUE function(ID, void*, rb_global_variable*) rb_gvar_getter_t;
alias void function(VALUE, ID, void*, rb_global_variable*) rb_gvar_setter_t;
alias void function(VALUE*) rb_gvar_marker_t;

VALUE rb_gvar_undef_getter(ID id, void *data, rb_global_variable *gvar);
void  rb_gvar_undef_setter(VALUE val, ID id, void *data, rb_global_variable *gvar);
void  rb_gvar_undef_marker(VALUE *var);

VALUE rb_gvar_val_getter(ID id, void *data, rb_global_variable *gvar);
void  rb_gvar_val_setter(VALUE val, ID id, void *data, rb_global_variable *gvar);
void  rb_gvar_val_marker(VALUE *var);

VALUE rb_gvar_var_getter(ID id, void *data, rb_global_variable *gvar);
void  rb_gvar_var_setter(VALUE val, ID id, void *data, rb_global_variable *gvar);
void  rb_gvar_var_marker(VALUE *var);

void  rb_gvar_readonly_setter(VALUE val, ID id, void *data, rb_global_variable *gvar);

void rb_define_variable(char*,VALUE*);
void rb_define_virtual_variable(char*, VALUE function(), void function());
void rb_define_hooked_variable(char*,VALUE*,VALUE function(), void function());
void rb_define_readonly_variable(char*,VALUE*);
void rb_define_const(VALUE,char*,VALUE);
void rb_define_global_const(char*,VALUE);

void rb_define_method(VALUE,char*,VALUE function(),int);
void rb_define_module_function(VALUE,char*,VALUE function(),int);
void rb_define_global_function(char*,VALUE function(),int);

void rb_undef_method(VALUE,char*);
void rb_define_alias(VALUE,char*,char*);
void rb_define_attr(VALUE,char*,int,int);

void rb_gc_register_mark_object(VALUE);
void rb_gc_register_address(VALUE*);
void rb_gc_unregister_address(VALUE*);

ID rb_intern(char*);
ID rb_intern2(char*, long);
ID rb_intern_str(VALUE str);
char *rb_id2name(ID);
ID rb_to_id(VALUE);
VALUE rb_id2str(ID);

char *rb_class2name(VALUE);
char *rb_obj_classname(VALUE);

void rb_p(VALUE);

VALUE rb_eval_string(char*);
VALUE rb_eval_string_protect(char*, int*);
VALUE rb_eval_string_wrap(char*, int*);
VALUE rb_funcall(VALUE, ID, int, ...);
VALUE rb_funcall2(VALUE, ID, int, VALUE*);
VALUE rb_funcall3(VALUE, ID, int, VALUE*);
int rb_scan_args(int, VALUE*, char*, ...);
VALUE rb_call_super(int, VALUE*);

VALUE rb_gv_set(char*, VALUE);
VALUE rb_gv_get(char*);
VALUE rb_iv_get(VALUE, char*);
VALUE rb_iv_set(VALUE, char*, VALUE);

VALUE rb_equal(VALUE,VALUE);

VALUE *rb_ruby_verbose_ptr();
VALUE *rb_ruby_debug_ptr();

void rb_raise(VALUE, char*, ...);
void rb_fatal(char*, ...);
void rb_bug(char*, ...);
void rb_bug_errno(char*, int);
void rb_sys_fail(char*);
void rb_mod_sys_fail(VALUE, char*);
void rb_iter_break();
void rb_exit(int);
void rb_notimplement();

/* reports if `-W' specified */
void rb_warning(char*, ...);
void rb_compile_warning(char *, int, char*, ...);
void rb_sys_warning(char*, ...);
/* reports always */
void rb_warn(char*, ...);
void rb_compile_warn(char *, int, char*, ...);

VALUE rb_block_call_func(VALUE, VALUE, int, VALUE*);

VALUE rb_each(VALUE);
VALUE rb_yield(VALUE);
VALUE rb_yield_values(int n, ...);
VALUE rb_yield_values2(int n, VALUE *argv);
VALUE rb_yield_splat(VALUE);
int rb_block_given_p();
void rb_need_block();

VALUE rb_iterate(VALUE function(VALUE),VALUE,VALUE function(),VALUE);
VALUE rb_block_call(VALUE,ID,int,VALUE*,VALUE function(),VALUE);
VALUE rb_rescue(VALUE function(),VALUE,VALUE function(),VALUE);
VALUE rb_rescue2(VALUE function(),VALUE,VALUE function(),VALUE,...);
VALUE rb_ensure(VALUE function(),VALUE,VALUE function(),VALUE);
VALUE rb_catch(char*,VALUE function(),VALUE);
VALUE rb_catch_obj(VALUE,VALUE function(),VALUE);
void rb_throw(char*,VALUE);
void rb_throw_obj(VALUE,VALUE);

VALUE rb_require(char*);

void ruby_init_stack(VALUE*);

void ruby_init();
void *ruby_options(int, char**);
int ruby_run_node(void *);
int ruby_exec_node(void *);

extern VALUE rb_mKernel;
extern VALUE rb_mComparable;
extern VALUE rb_mEnumerable;
extern VALUE rb_mErrno;
extern VALUE rb_mFileTest;
extern VALUE rb_mGC;
extern VALUE rb_mMath;
extern VALUE rb_mProcess;
extern VALUE rb_mWaitReadable;
extern VALUE rb_mWaitWritable;

extern VALUE rb_cBasicObject;
extern VALUE rb_cObject;
extern VALUE rb_cArray;
extern VALUE rb_cBignum;
extern VALUE rb_cBinding;
extern VALUE rb_cClass;
extern VALUE rb_cCont;
extern VALUE rb_cDir;
extern VALUE rb_cData;
extern VALUE rb_cFalseClass;
extern VALUE rb_cEncoding;
extern VALUE rb_cEnumerator;
extern VALUE rb_cFile;
extern VALUE rb_cFixnum;
extern VALUE rb_cFloat;
extern VALUE rb_cHash;
extern VALUE rb_cInteger;
extern VALUE rb_cIO;
extern VALUE rb_cMatch;
extern VALUE rb_cMethod;
extern VALUE rb_cModule;
extern VALUE rb_cNameErrorMesg;
extern VALUE rb_cNilClass;
extern VALUE rb_cNumeric;
extern VALUE rb_cProc;
extern VALUE rb_cRandom;
extern VALUE rb_cRange;
extern VALUE rb_cRational;
extern VALUE rb_cComplex;
extern VALUE rb_cRegexp;
extern VALUE rb_cStat;
extern VALUE rb_cString;
extern VALUE rb_cStruct;
extern VALUE rb_cSymbol;
extern VALUE rb_cThread;
extern VALUE rb_cTime;
extern VALUE rb_cTrueClass;
extern VALUE rb_cUnboundMethod;

extern VALUE rb_eException;
extern VALUE rb_eStandardError;
extern VALUE rb_eSystemExit;
extern VALUE rb_eInterrupt;
extern VALUE rb_eSignal;
extern VALUE rb_eFatal;
extern VALUE rb_eArgError;
extern VALUE rb_eEOFError;
extern VALUE rb_eIndexError;
extern VALUE rb_eStopIteration;
extern VALUE rb_eKeyError;
extern VALUE rb_eRangeError;
extern VALUE rb_eIOError;
extern VALUE rb_eRuntimeError;
extern VALUE rb_eSecurityError;
extern VALUE rb_eSystemCallError;
extern VALUE rb_eThreadError;
extern VALUE rb_eTypeError;
extern VALUE rb_eZeroDivError;
extern VALUE rb_eNotImpError;
extern VALUE rb_eNoMemError;
extern VALUE rb_eNoMethodError;
extern VALUE rb_eFloatDomainError;
extern VALUE rb_eLocalJumpError;
extern VALUE rb_eSysStackError;
extern VALUE rb_eRegexpError;
extern VALUE rb_eEncodingError;
extern VALUE rb_eEncCompatError;

extern VALUE rb_eScriptError;
extern VALUE rb_eNameError;
extern VALUE rb_eSyntaxError;
extern VALUE rb_eLoadError;

extern VALUE rb_eMathDomainError;

extern VALUE rb_stdin, rb_stdout, rb_stderr;

void ruby_sysinit(int *, char ***);

const auto RUBY_VM = 1; /* YARV */;
const auto HAVE_NATIVETHREAD = 1;
int ruby_native_thread_p();

const auto RUBY_EVENT_NONE     = 0x0000;
const auto RUBY_EVENT_LINE     = 0x0001;
const auto RUBY_EVENT_CLASS    = 0x0002;
const auto RUBY_EVENT_END      = 0x0004;
const auto RUBY_EVENT_CALL     = 0x0008;
const auto RUBY_EVENT_RETURN   = 0x0010;
const auto RUBY_EVENT_C_CALL   = 0x0020;
const auto RUBY_EVENT_C_RETURN = 0x0040;
const auto RUBY_EVENT_RAISE    = 0x0080;
const auto RUBY_EVENT_ALL      = 0xffff;
const auto RUBY_EVENT_VM      = 0x10000;
const auto RUBY_EVENT_SWITCH  = 0x20000;
const auto RUBY_EVENT_COVERAGE= 0x40000;

alias uint rb_event_flag_t;
alias void function(rb_event_flag_t, VALUE, VALUE, ID, VALUE) rb_event_hook_func_t;

struct rb_event_hook_t {
    rb_event_flag_t flag;
    rb_event_hook_func_t func;
    VALUE data;
    rb_event_hook_t* next;
}

const auto RB_EVENT_HOOKS_HAVE_CALLBACK_DATA = 1;
void rb_add_event_hook(rb_event_hook_func_t func, rb_event_flag_t events,
		       VALUE data);
int rb_remove_event_hook(rb_event_hook_func_t func);

/* locale insensitive functions */

int rb_isalnum(int c);
int rb_isalpha(int c);
int rb_isblank(int c);
int rb_iscntrl(int c);
int rb_isdigit(int c);
int rb_isgraph(int c);
int rb_islower(int c);
int rb_isprint(int c);
int rb_ispunct(int c);
int rb_isspace(int c);
int rb_isupper(int c);
int rb_isxdigit(int c);
int rb_tolower(int c);
int rb_toupper(int c);

int st_strcasecmp(char *s1, char *s2);
int st_strncasecmp(char *s1, char *s2, size_t n);

Culong_t ruby_strtoul(char *str, char **endptr, int base);

int ruby_snprintf(char *str, size_t n, char *fmt, ...);
int ruby_vsnprintf(char *str, size_t n, char *fmt, Cva_list ap);
