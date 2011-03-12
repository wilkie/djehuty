/*
 * ruby.d
 *
 * This file holds bindings to ruby. The original copyrights
 * are displayed below, but do not pertain to this file.
 *
 */

module binding.cairo.cairo;

import binding.c;

extern (C):

/**********************************************************************

  intern.h -

  $Author: yugui $
  created at: Thu Jun 10 14:22:17 JST 1993

  Copyright (C) 1993-2007 Yukihiro Matsumoto
  Copyright (C) 2000  Network Applied Communication Laboratory, Inc.
  Copyright (C) 2000  Information-technology Promotion Agency, Japan

**********************************************************************/

struct timeval {
	Clong_t tv_sec;
	Clong_t tv_usec;
}

alias int rb_pid_t;
alias int time_t;

struct st_table;
alias Culong_t st_data_t;
alias st_data_t st_index_t;

alias uint* VALUE;
alias uint* ID;
alias int* SIGNED_VALUE;
const auto SIZEOF_VALUE = (uint*).sizeof;


/*
 * Functions and variables that are used by more than one source file of
 * the kernel.
 */

const auto ID_ALLOCATOR = 1;

/* array.c */
void rb_mem_clear(VALUE*, Clong_t);
VALUE rb_assoc_new(VALUE, VALUE);
VALUE rb_check_array_type(VALUE);
VALUE rb_ary_new();
VALUE rb_ary_new2(Clong_t);
VALUE rb_ary_new3(long,...);
VALUE rb_ary_new4(long, VALUE *);
VALUE rb_ary_tmp_new(Clong_t);
void rb_ary_free(VALUE);
VALUE rb_ary_freeze(VALUE);
VALUE rb_ary_aref(int, VALUE*, VALUE);
VALUE rb_ary_subseq(VALUE, long, Clong_t);
void rb_ary_store(VALUE, long, VALUE);
VALUE rb_ary_dup(VALUE);
VALUE rb_ary_to_ary(VALUE);
VALUE rb_ary_to_s(VALUE);
VALUE rb_ary_push(VALUE, VALUE);
VALUE rb_ary_pop(VALUE);
VALUE rb_ary_shift(VALUE);
VALUE rb_ary_unshift(VALUE, VALUE);
VALUE rb_ary_entry(VALUE, Clong_t);
VALUE rb_ary_each(VALUE);
VALUE rb_ary_join(VALUE, VALUE);
VALUE rb_ary_print_on(VALUE, VALUE);
VALUE rb_ary_reverse(VALUE);
VALUE rb_ary_sort(VALUE);
VALUE rb_ary_sort_bang(VALUE);
VALUE rb_ary_delete(VALUE, VALUE);
VALUE rb_ary_delete_at(VALUE, Clong_t);
VALUE rb_ary_clear(VALUE);
VALUE rb_ary_plus(VALUE, VALUE);
VALUE rb_ary_concat(VALUE, VALUE);
VALUE rb_ary_assoc(VALUE, VALUE);
VALUE rb_ary_rassoc(VALUE, VALUE);
VALUE rb_ary_includes(VALUE, VALUE);
VALUE rb_ary_cmp(VALUE, VALUE);
VALUE rb_ary_replace(VALUE copy, VALUE orig);
VALUE rb_get_values_at(VALUE, long, int, VALUE*, VALUE(*)(VALUE,Clong_t));
/* bignum.c */
VALUE rb_big_new(long, int);
int rb_bigzero_p(VALUE x);
VALUE rb_big_clone(VALUE);
void rb_big_2comp(VALUE);
VALUE rb_big_norm(VALUE);
void rb_big_resize(VALUE big, Clong_t len);
VALUE rb_uint2big(VALUE);
VALUE rb_int2big(SIGNED_VALUE);
VALUE rb_uint2inum(VALUE);
VALUE rb_int2inum(SIGNED_VALUE);
VALUE rb_cstr_to_inum(char*, int, int);
VALUE rb_str_to_inum(VALUE, int, int);
VALUE rb_cstr2inum(char*, int);
VALUE rb_str2inum(VALUE, int);
VALUE rb_big2str(VALUE, int);
VALUE rb_big2str0(VALUE, int, int);
SIGNED_VALUE rb_big2long(VALUE);
VALUE rb_big2ulong(VALUE);

VALUE rb_ll2inum(long);
VALUE rb_ull2inum(ulong);
long rb_big2ll(VALUE);
ulong rb_big2ull(VALUE);

void rb_quad_pack(char*,VALUE);
VALUE rb_quad_unpack(char*,int);
void rb_big_pack(VALUE val, Culong_t *buf, Clong_t num_longs);
VALUE rb_big_unpack(Culong_t *buf, Clong_t num_longs);
int rb_uv_to_utf8(char[6],Culong_t);
VALUE rb_dbl2big(double);
double rb_big2dbl(VALUE);
VALUE rb_big_cmp(VALUE, VALUE);
VALUE rb_big_eq(VALUE, VALUE);
VALUE rb_big_plus(VALUE, VALUE);
VALUE rb_big_minus(VALUE, VALUE);
VALUE rb_big_mul(VALUE, VALUE);
VALUE rb_big_div(VALUE, VALUE);
VALUE rb_big_modulo(VALUE, VALUE);
VALUE rb_big_divmod(VALUE, VALUE);
VALUE rb_big_pow(VALUE, VALUE);
VALUE rb_big_and(VALUE, VALUE);
VALUE rb_big_or(VALUE, VALUE);
VALUE rb_big_xor(VALUE, VALUE);
VALUE rb_big_lshift(VALUE, VALUE);
VALUE rb_big_rshift(VALUE, VALUE);
/* rational.c */
VALUE rb_rational_raw(VALUE, VALUE);
VALUE rb_rational_new(VALUE, VALUE);
VALUE rb_Rational(VALUE, VALUE);
/* complex.c */
VALUE rb_complex_raw(VALUE, VALUE);
VALUE rb_complex_new(VALUE, VALUE);
VALUE rb_complex_polar(VALUE, VALUE);
VALUE rb_Complex(VALUE, VALUE);
/* class.c */
VALUE rb_class_boot(VALUE);
VALUE rb_class_new(VALUE);
VALUE rb_mod_init_copy(VALUE, VALUE);
VALUE rb_class_init_copy(VALUE, VALUE);
VALUE rb_singleton_class_clone(VALUE);
void rb_singleton_class_attached(VALUE,VALUE);
VALUE rb_make_metaclass(VALUE, VALUE);
void rb_check_inheritable(VALUE);
VALUE rb_class_inherited(VALUE, VALUE);
VALUE rb_define_class_id(ID, VALUE);
VALUE rb_define_class_id_under(VALUE, ID, VALUE);
VALUE rb_module_new();
VALUE rb_define_module_id(ID);
VALUE rb_define_module_id_under(VALUE, ID);
VALUE rb_mod_included_modules(VALUE);
VALUE rb_mod_include_p(VALUE, VALUE);
VALUE rb_mod_ancestors(VALUE);
VALUE rb_class_instance_methods(int, VALUE*, VALUE);
VALUE rb_class_public_instance_methods(int, VALUE*, VALUE);
VALUE rb_class_protected_instance_methods(int, VALUE*, VALUE);
VALUE rb_class_private_instance_methods(int, VALUE*, VALUE);
VALUE rb_obj_singleton_methods(int, VALUE*, VALUE);
void rb_define_method_id(VALUE, ID, VALUE function(), int);
void rb_frozen_class_p(VALUE);
void rb_undef(VALUE, ID);
void rb_define_protected_method(VALUE, char*, VALUE function(), int);
void rb_define_private_method(VALUE, char*, VALUE function(), int);
void rb_define_singleton_method(VALUE, char*, VALUE function(), int);
VALUE rb_singleton_class(VALUE);
/* compar.c */
int rb_cmpint(VALUE, VALUE, VALUE);
void rb_cmperr(VALUE, VALUE);
/* cont.c */
VALUE rb_fiber_new(VALUE function(), VALUE);
VALUE rb_fiber_resume(VALUE fib, int argc, VALUE *args);
VALUE rb_fiber_yield(int argc, VALUE *args);
VALUE rb_fiber_current();
VALUE rb_fiber_alive_p(VALUE);
/* enum.c */
/* enumerator.c */
VALUE rb_enumeratorize(VALUE, VALUE, int, VALUE *);
/* error.c */
VALUE rb_exc_new(VALUE, char*, Clong_t);
VALUE rb_exc_new2(VALUE, char*);
VALUE rb_exc_new3(VALUE, VALUE);
void rb_loaderror(char*, ...);
void rb_name_error(ID, char*, ...);
void rb_invalid_str(char*, char*);
void rb_compile_error(char*, int, char*, ...);
void rb_compile_error_append(char*, ...);
void rb_load_fail(char*);
void rb_error_frozen(char*);
void rb_check_frozen(VALUE);
/* eval.c */
int rb_sourceline();
char *rb_sourcefile();
VALUE rb_check_funcall(VALUE, ID, int, VALUE*);

struct rb_fdset_t {
    int maxfd;
    uint *fdset;
}

void rb_fd_init(rb_fdset_t *);
void rb_fd_term(rb_fdset_t *);
void rb_fd_zero(rb_fdset_t *);
void rb_fd_set(int, rb_fdset_t *);
void rb_fd_clr(int, rb_fdset_t *);
int rb_fd_isset(int, rb_fdset_t *);
void rb_fd_copy(rb_fdset_t *, uint *, int);
int rb_fd_select(int, rb_fdset_t *, rb_fdset_t *, rb_fdset_t *, timeval *);

void rb_exc_raise(VALUE);
void rb_exc_fatal(VALUE);
VALUE rb_f_exit(int,VALUE*);
VALUE rb_f_abort(int,VALUE*);
void rb_remove_method(VALUE, char*);
void rb_remove_method_id(VALUE, ID);
typedef VALUE (*rb_alloc_func_t)(VALUE);
void rb_define_alloc_func(VALUE, rb_alloc_func_t);
void rb_undef_alloc_func(VALUE);
rb_alloc_func_t rb_get_alloc_func(VALUE);
void rb_clear_cache();
void rb_clear_cache_by_class(VALUE);
void rb_alias(VALUE, ID, ID);
void rb_attr(VALUE,ID,int,int,int);
int rb_method_boundp(VALUE, ID, int);
int rb_method_basic_definition_p(VALUE, ID);
VALUE rb_eval_cmd(VALUE, VALUE, int);
int rb_obj_respond_to(VALUE, ID, int);
int rb_respond_to(VALUE, ID);
VALUE rb_f_notimplement(int argc, VALUE *argv, VALUE obj);
void rb_interrupt();
VALUE rb_apply(VALUE, ID, VALUE);
void rb_backtrace();
ID rb_frame_this_func();
VALUE rb_obj_instance_eval(int, VALUE*, VALUE);
VALUE rb_obj_instance_exec(int, VALUE*, VALUE);
VALUE rb_mod_module_eval(int, VALUE*, VALUE);
VALUE rb_mod_module_exec(int, VALUE*, VALUE);
void rb_load(VALUE, int);
void rb_load_protect(VALUE, int, int*);
void rb_jump_tag(int);
int rb_provided(char*);
int rb_feature_provided(char *, char **);
void rb_provide(char*);
VALUE rb_f_require(VALUE, VALUE);
VALUE rb_require_safe(VALUE, int);
void rb_obj_call_init(VALUE, int, VALUE*);
VALUE rb_class_new_instance(int, VALUE*, VALUE);
VALUE rb_block_proc();
VALUE rb_f_lambda();
VALUE rb_proc_new(VALUE function(/* VALUE yieldarg[, VALUE procarg] */), VALUE);
VALUE rb_obj_is_proc(VALUE);
VALUE rb_proc_call(VALUE, VALUE);
VALUE rb_proc_call_with_block(VALUE, int argc, VALUE *argv, VALUE);
int rb_proc_arity(VALUE);
VALUE rb_proc_lambda_p(VALUE);
VALUE rb_binding_new();
VALUE rb_obj_method(VALUE, VALUE);
VALUE rb_method_call(int, VALUE*, VALUE);
int rb_mod_method_arity(VALUE, ID);
int rb_obj_method_arity(VALUE, ID);
VALUE rb_protect(VALUE (*)(VALUE), VALUE, int*);
void rb_set_end_proc(void (*)(VALUE), VALUE);
void rb_mark_end_proc();
void rb_exec_end_proc();
void ruby_finalize();
void ruby_stop(int);
int ruby_cleanup(int);
void rb_gc_mark_threads();
void rb_thread_schedule();
void rb_thread_wait_fd(int);
int rb_thread_fd_writable(int);
void rb_thread_fd_close(int);
int rb_thread_alone();
void rb_thread_polling();
void rb_thread_sleep(int);
void rb_thread_sleep_forever();
VALUE rb_thread_stop();
VALUE rb_thread_wakeup(VALUE);
VALUE rb_thread_run(VALUE);
VALUE rb_thread_kill(VALUE);
VALUE rb_thread_create(VALUE function(), void*);
int rb_thread_select(int, uint *, uint *, uint *, timeval *);
int rb_thread_fd_select(int, rb_fdset_t *, rb_fdset_t *, rb_fdset_t *, timeval *);
void rb_thread_wait_for(timeval);
VALUE rb_thread_current();
VALUE rb_thread_main();
VALUE rb_thread_local_aref(VALUE, ID);
VALUE rb_thread_local_aset(VALUE, ID, VALUE);
void rb_thread_atfork();
void rb_thread_atfork_before_exec();
VALUE rb_exec_recursive(VALUE(*)(VALUE, VALUE, int),VALUE,VALUE);
VALUE rb_exec_recursive_paired(VALUE(*)(VALUE, VALUE, int),VALUE,VALUE,VALUE);
VALUE rb_exec_recursive_outer(VALUE(*)(VALUE, VALUE, int),VALUE,VALUE);
/* dir.c */
VALUE rb_dir_getwd();
/* file.c */
VALUE rb_file_s_expand_path(int, VALUE *);
VALUE rb_file_expand_path(VALUE, VALUE);
VALUE rb_file_s_absolute_path(int, VALUE *);
VALUE rb_file_absolute_path(VALUE, VALUE);
VALUE rb_file_dirname(VALUE fname);
void rb_file_const(char*, VALUE);
int rb_file_load_ok(char *);
int rb_find_file_ext_safe(VALUE*, char**, int);
VALUE rb_find_file_safe(VALUE, int);
int rb_find_file_ext(VALUE*, char**);
VALUE rb_find_file(VALUE);
char *rb_path_next(char *);
char *rb_path_skip_prefix(char *);
char *rb_path_last_separator(char *);
char *rb_path_end(char *);
VALUE rb_file_directory_p(VALUE,VALUE);
VALUE rb_str_encode_ospath(VALUE);
int rb_is_absolute_path(char *);
/* gc.c */
void ruby_set_stack_size(size_t);
void rb_memerror();
int ruby_stack_check();
size_t ruby_stack_length(VALUE**);
int rb_during_gc();
void rb_gc_mark_locations(VALUE*, VALUE*);
void rb_mark_tbl(st_table*);
void rb_mark_set(st_table*);
void rb_mark_hash(st_table*);
void rb_gc_mark_maybe(VALUE);
void rb_gc_mark(VALUE);
void rb_gc_force_recycle(VALUE);
void rb_gc();
void rb_gc_copy_finalizer(VALUE,VALUE);
void rb_gc_finalize_deferred();
void rb_gc_call_finalizer_at_exit();
VALUE rb_gc_enable();
VALUE rb_gc_disable();
VALUE rb_gc_start();
/* hash.c */
void st_foreach_safe(st_table *, int function(), st_data_t);
void rb_hash_foreach(VALUE, int function(), VALUE);
VALUE rb_hash(VALUE);
VALUE rb_hash_new();
VALUE rb_hash_dup(VALUE);
VALUE rb_hash_freeze(VALUE);
VALUE rb_hash_aref(VALUE, VALUE);
VALUE rb_hash_lookup(VALUE, VALUE);
VALUE rb_hash_lookup2(VALUE, VALUE, VALUE);
VALUE rb_hash_fetch(VALUE, VALUE);
VALUE rb_hash_aset(VALUE, VALUE, VALUE);
VALUE rb_hash_delete_if(VALUE);
VALUE rb_hash_delete(VALUE,VALUE);
st_table *rb_hash_tbl(VALUE);
int rb_path_check(char*);
int rb_env_path_tainted();
VALUE rb_env_clear();
/* io.c */
extern VALUE rb_fs;
extern VALUE rb_output_fs;
extern VALUE rb_rs;
extern VALUE rb_default_rs;
extern VALUE rb_output_rs;
VALUE rb_io_write(VALUE, VALUE);
VALUE rb_io_gets(VALUE);
VALUE rb_io_getbyte(VALUE);
VALUE rb_io_ungetc(VALUE, VALUE);
VALUE rb_io_ungetbyte(VALUE, VALUE);
VALUE rb_io_close(VALUE);
VALUE rb_io_flush(VALUE);
VALUE rb_io_eof(VALUE);
VALUE rb_io_binmode(VALUE);
VALUE rb_io_ascii8bit_binmode(VALUE);
VALUE rb_io_addstr(VALUE, VALUE);
VALUE rb_io_printf(int, VALUE*, VALUE);
VALUE rb_io_print(int, VALUE*, VALUE);
VALUE rb_io_puts(int, VALUE*, VALUE);
VALUE rb_io_fdopen(int, int, char*);
VALUE rb_io_get_io(VALUE);
VALUE rb_file_open(char*, char*);
VALUE rb_file_open_str(VALUE, char*);
VALUE rb_gets();
void rb_write_error(char*);
void rb_write_error2(char*, Clong_t);
void rb_close_before_exec(int lowfd, int maxhint, VALUE noclose_fds);
int rb_pipe(int *pipes);
/* marshal.c */
VALUE rb_marshal_dump(VALUE, VALUE);
VALUE rb_marshal_load(VALUE);
void rb_marshal_define_compat(VALUE newclass, VALUE oldclass, VALUE (*dumper)(VALUE), VALUE (*loader)(VALUE, VALUE));
/* numeric.c */
void rb_num_zerodiv();
VALUE rb_num_coerce_bin(VALUE, VALUE, ID);
VALUE rb_num_coerce_cmp(VALUE, VALUE, ID);
VALUE rb_num_coerce_relop(VALUE, VALUE, ID);
VALUE rb_float_new(double);
VALUE rb_num2fix(VALUE);
VALUE rb_fix2str(VALUE, int);
VALUE rb_dbl_cmp(double, double);
/* object.c */
int rb_eql(VALUE, VALUE);
VALUE rb_any_to_s(VALUE);
VALUE rb_inspect(VALUE);
VALUE rb_obj_is_instance_of(VALUE, VALUE);
VALUE rb_obj_is_kind_of(VALUE, VALUE);
VALUE rb_obj_alloc(VALUE);
VALUE rb_obj_clone(VALUE);
VALUE rb_obj_dup(VALUE);
VALUE rb_obj_init_copy(VALUE,VALUE);
VALUE rb_obj_taint(VALUE);
VALUE rb_obj_tainted(VALUE);
VALUE rb_obj_untaint(VALUE);
VALUE rb_obj_untrust(VALUE);
VALUE rb_obj_untrusted(VALUE);
VALUE rb_obj_trust(VALUE);
VALUE rb_obj_freeze(VALUE);
VALUE rb_obj_frozen_p(VALUE);
VALUE rb_obj_id(VALUE);
VALUE rb_obj_class(VALUE);
VALUE rb_class_real(VALUE);
VALUE rb_class_inherited_p(VALUE, VALUE);
VALUE rb_convert_type(VALUE,int,char*,char*);
VALUE rb_check_convert_type(VALUE,int,char*,char*);
VALUE rb_check_to_integer(VALUE, char *);
VALUE rb_check_to_float(VALUE);
VALUE rb_to_int(VALUE);
VALUE rb_Integer(VALUE);
VALUE rb_to_float(VALUE);
VALUE rb_Float(VALUE);
VALUE rb_String(VALUE);
VALUE rb_Array(VALUE);
double rb_cstr_to_dbl(char*, int);
double rb_str_to_dbl(VALUE, int);
/* parse.y */
extern int   ruby_sourceline;
extern char *ruby_sourcefile;
ID rb_id_attrset(ID);
void rb_gc_mark_parser();
int rb_is_const_id(ID);
int rb_is_instance_id(ID);
int rb_is_class_id(ID);
int rb_is_local_id(ID);
int rb_is_junk_id(ID);
int rb_symname_p(char*);
int rb_sym_interned_p(VALUE);
void rb_gc_mark_symbols();
VALUE rb_backref_get();
void rb_backref_set(VALUE);
VALUE rb_lastline_get();
void rb_lastline_set(VALUE);
VALUE rb_sym_all_symbols();
/* process.c */
void rb_last_status_set(int status, rb_pid_t pid);
VALUE rb_last_status_get();
struct rb_exec_arg {
    int argc;
    VALUE *argv;
    char *prog;
    VALUE options;
    VALUE redirect_fds;
}
int rb_proc_exec_n(int, VALUE*, char*);
int rb_proc_exec(char*);
VALUE rb_exec_arg_init(int argc, VALUE *argv, int accept_shell, rb_exec_arg *e);
int rb_exec_arg_addopt(rb_exec_arg *e, VALUE key, VALUE val);
void rb_exec_arg_fixup(rb_exec_arg *e);
int rb_run_exec_options(rb_exec_arg *e, rb_exec_arg *s);
int rb_run_exec_options_err(rb_exec_arg *e, rb_exec_arg *s, char*, size_t);
int rb_exec(rb_exec_arg*);
int rb_exec_err(rb_exec_arg*, char*, size_t);
rb_pid_t rb_fork(int*, int (*)(void*), void*, VALUE);
rb_pid_t rb_fork_err(int*, int (*)(void*, char*, size_t), void*, VALUE, char*, size_t);
VALUE rb_f_exec(int,VALUE*);
rb_pid_t rb_waitpid(rb_pid_t pid, int *status, int flags);
void rb_syswait(rb_pid_t pid);
rb_pid_t rb_spawn(int, VALUE*);
rb_pid_t rb_spawn_err(int, VALUE*, char*, size_t);
VALUE rb_proc_times(VALUE);
VALUE rb_detach_process(rb_pid_t pid);
/* range.c */
VALUE rb_range_new(VALUE, VALUE, int);
VALUE rb_range_beg_len(VALUE, long*, long*, long, int);
int rb_range_values(VALUE range, VALUE *begp, VALUE *endp, int *exclp);
/* random.c */
uint rb_genrand_int32();
double rb_genrand_real();
void rb_reset_random_seed();
VALUE rb_random_bytes(VALUE rnd, Clong_t n);
VALUE rb_random_int(VALUE rnd, VALUE max);
uint rb_random_int32(VALUE rnd);
double rb_random_real(VALUE rnd);
/* re.c */
int rb_memcicmp(void*,void*,Clong_t);
void rb_match_busy(VALUE);
VALUE rb_reg_nth_defined(int, VALUE);
VALUE rb_reg_nth_match(int, VALUE);
int rb_reg_backref_number(VALUE match, VALUE backref);
VALUE rb_reg_last_match(VALUE);
VALUE rb_reg_match_pre(VALUE);
VALUE rb_reg_match_post(VALUE);
VALUE rb_reg_match_last(VALUE);
const auto HAVE_RB_REG_NEW_STR = 1;
VALUE rb_reg_new_str(VALUE, int);
VALUE rb_reg_new(char *, long, int);
VALUE rb_reg_alloc();
VALUE rb_reg_init_str(VALUE re, VALUE s, int options);
VALUE rb_reg_match(VALUE, VALUE);
VALUE rb_reg_match2(VALUE);
int rb_reg_options(VALUE);
/* ruby.c */
extern VALUE rb_argv0;
VALUE rb_get_argv();
void *rb_load_file(char*);
void ruby_script(char*);
void ruby_prog_init();
void ruby_set_argv(int, char**);
void *ruby_process_options(int, char**);
void ruby_init_loadpath();
void ruby_incpush(char*);
/* signal.c */
VALUE rb_f_kill(int, VALUE*);
void rb_gc_mark_trap_list();
void ruby_sig_finalize();
void rb_trap_exit();
void rb_trap_exec();
char *ruby_signal_name(int);
void ruby_default_signal(int);
/* sprintf.c */
VALUE rb_f_sprintf(int, VALUE*);
VALUE rb_sprintf(char*, ...);
VALUE rb_vsprintf(char*, Cva_list);
VALUE rb_str_catf(VALUE, char*, ...);
VALUE rb_str_vcatf(VALUE, char*, Cva_list);
VALUE rb_str_format(int, VALUE *, VALUE);
/* string.c */
VALUE rb_str_new(char*, Clong_t);
VALUE rb_str_new_cstr(char*);
VALUE rb_str_new2(char*);
VALUE rb_str_new_shared(VALUE);
VALUE rb_str_new3(VALUE);
VALUE rb_str_new_frozen(VALUE);
VALUE rb_str_new4(VALUE);
VALUE rb_str_new_with_class(VALUE, char*, Clong_t);
VALUE rb_str_new5(VALUE, char*, Clong_t);
VALUE rb_tainted_str_new_cstr(char*);
VALUE rb_tainted_str_new(char*, Clong_t);
VALUE rb_tainted_str_new2(char*);
VALUE rb_external_str_new(char*, Clong_t);
VALUE rb_external_str_new_cstr(char*);
VALUE rb_locale_str_new(char*, Clong_t);
VALUE rb_locale_str_new_cstr(char*);
VALUE rb_filesystem_str_new(char*, Clong_t);
VALUE rb_filesystem_str_new_cstr(char*);
VALUE rb_str_buf_new(Clong_t);
VALUE rb_str_buf_new_cstr(char*);
VALUE rb_str_buf_new2(char*);
VALUE rb_str_tmp_new(Clong_t);
VALUE rb_usascii_str_new(char*, Clong_t);
VALUE rb_usascii_str_new_cstr(char*);
VALUE rb_usascii_str_new2(char*);
void rb_str_free(VALUE);
void rb_str_shared_replace(VALUE, VALUE);
VALUE rb_str_buf_append(VALUE, VALUE);
VALUE rb_str_buf_cat(VALUE, char*, Clong_t);
VALUE rb_str_buf_cat2(VALUE, char*);
VALUE rb_str_buf_cat_ascii(VALUE, char*);
VALUE rb_obj_as_string(VALUE);
VALUE rb_check_string_type(VALUE);
VALUE rb_str_dup(VALUE);
VALUE rb_str_locktmp(VALUE);
VALUE rb_str_unlocktmp(VALUE);
VALUE rb_str_dup_frozen(VALUE);
VALUE rb_str_plus(VALUE, VALUE);
VALUE rb_str_times(VALUE, VALUE);
Clong_t rb_str_sublen(VALUE, Clong_t);
VALUE rb_str_substr(VALUE, long, Clong_t);
VALUE rb_str_subseq(VALUE, long, Clong_t);
void rb_str_modify(VALUE);
VALUE rb_str_freeze(VALUE);
void rb_str_set_len(VALUE, Clong_t);
VALUE rb_str_resize(VALUE, Clong_t);
VALUE rb_str_cat(VALUE, char*, Clong_t);
VALUE rb_str_cat2(VALUE, char*);
VALUE rb_str_append(VALUE, VALUE);
VALUE rb_str_concat(VALUE, VALUE);
st_index_t rb_memhash(void *ptr, Clong_t len);
st_index_t rb_hash_start(st_index_t);
st_index_t rb_hash_uint32(st_index_t, uint);
st_index_t rb_hash_uint(st_index_t, st_index_t);
st_index_t rb_hash_end(st_index_t);
st_index_t rb_str_hash(VALUE);
int rb_str_hash_cmp(VALUE,VALUE);
int rb_str_comparable(VALUE, VALUE);
int rb_str_cmp(VALUE, VALUE);
VALUE rb_str_equal(VALUE str1, VALUE str2);
VALUE rb_str_drop_bytes(VALUE, Clong_t);
void rb_str_update(VALUE, long, long, VALUE);
VALUE rb_str_replace(VALUE, VALUE);
VALUE rb_str_inspect(VALUE);
VALUE rb_str_dump(VALUE);
VALUE rb_str_split(VALUE, char*);
void rb_str_associate(VALUE, VALUE);
VALUE rb_str_associated(VALUE);
void rb_str_setter(VALUE, ID, VALUE*);
VALUE rb_str_intern(VALUE);
VALUE rb_sym_to_s(VALUE);
Clong_t rb_str_strlen(VALUE);
VALUE rb_str_length(VALUE);
Clong_t rb_str_offset(VALUE, Clong_t);
size_t rb_str_capacity(VALUE);
/* struct.c */
VALUE rb_struct_new(VALUE, ...);
VALUE rb_struct_define(char*, ...);
VALUE rb_struct_alloc(VALUE, VALUE);
VALUE rb_struct_initialize(VALUE, VALUE);
VALUE rb_struct_aref(VALUE, VALUE);
VALUE rb_struct_aset(VALUE, VALUE, VALUE);
VALUE rb_struct_getmember(VALUE, ID);
VALUE rb_struct_s_members(VALUE);
VALUE rb_struct_members(VALUE);
VALUE rb_struct_alloc_noinit(VALUE);
VALUE rb_struct_define_without_accessor(char *, VALUE, rb_alloc_func_t, ...);
/* thread.c */
alias void function(void*) rb_unblock_function_t;
alias VALUE function(void*) rb_blocking_function_t;

void rb_thread_check_ints();
int rb_thread_interrupted(VALUE thval);
VALUE rb_thread_blocking_region(rb_blocking_function_t *func, void *data1,
				rb_unblock_function_t *ubf, void *data2);
VALUE rb_mutex_new();
VALUE rb_mutex_locked_p(VALUE mutex);
VALUE rb_mutex_try_lock(VALUE mutex);
VALUE rb_mutex_lock(VALUE mutex);
VALUE rb_mutex_unlock(VALUE mutex);
VALUE rb_mutex_sleep(VALUE self, VALUE timeout);
VALUE rb_mutex_synchronize(VALUE mutex, VALUE (*func)(VALUE arg), VALUE arg);
VALUE rb_barrier_new();
VALUE rb_barrier_wait(VALUE self);
VALUE rb_barrier_release(VALUE self);
VALUE rb_barrier_destroy(VALUE self);
/* time.c */
VALUE rb_time_new(time_t, Clong_t);
VALUE rb_time_nano_new(time_t, Clong_t);
VALUE rb_time_num_new(VALUE, VALUE);
/* variable.c */
VALUE rb_mod_name(VALUE);
VALUE rb_class_path(VALUE);
void rb_set_class_path(VALUE, VALUE, char*);
void rb_set_class_path_string(VALUE, VALUE, VALUE);
VALUE rb_path_to_class(VALUE);
VALUE rb_path2class(char*);
void rb_name_class(VALUE, ID);
VALUE rb_class_name(VALUE);
void rb_autoload(VALUE, ID, char*);
VALUE rb_autoload_load(VALUE, ID);
VALUE rb_autoload_p(VALUE, ID);
void rb_gc_mark_global_tbl();
VALUE rb_f_trace_var(int, VALUE*);
VALUE rb_f_untrace_var(int, VALUE*);
VALUE rb_f_global_variables();
void rb_alias_variable(ID, ID);
st_table* rb_generic_ivar_table(VALUE);
void rb_copy_generic_ivar(VALUE,VALUE);
void rb_mark_generic_ivar(VALUE);
void rb_mark_generic_ivar_tbl();
void rb_free_generic_ivar(VALUE);
VALUE rb_ivar_get(VALUE, ID);
VALUE rb_ivar_set(VALUE, ID, VALUE);
VALUE rb_ivar_defined(VALUE, ID);
void rb_ivar_foreach(VALUE, int function(), st_data_t);
st_index_t rb_ivar_count(VALUE);
VALUE rb_iv_set(VALUE, char*, VALUE);
VALUE rb_iv_get(VALUE, char*);
VALUE rb_attr_get(VALUE, ID);
VALUE rb_obj_instance_variables(VALUE);
VALUE rb_obj_remove_instance_variable(VALUE, VALUE);
void *rb_mod_const_at(VALUE, void*);
void *rb_mod_const_of(VALUE, void*);
VALUE rb_const_list(void*);
VALUE rb_mod_constants(int, VALUE *, VALUE);
VALUE rb_mod_remove_const(VALUE, VALUE);
int rb_const_defined(VALUE, ID);
int rb_const_defined_at(VALUE, ID);
int rb_const_defined_from(VALUE, ID);
VALUE rb_const_get(VALUE, ID);
VALUE rb_const_get_at(VALUE, ID);
VALUE rb_const_get_from(VALUE, ID);
void rb_const_set(VALUE, ID, VALUE);
VALUE rb_const_remove(VALUE, ID);
VALUE rb_mod_const_missing(VALUE,VALUE);
VALUE rb_cvar_defined(VALUE, ID);
void rb_cvar_set(VALUE, ID, VALUE);
VALUE rb_cvar_get(VALUE, ID);
void rb_cv_set(VALUE, char*, VALUE);
VALUE rb_cv_get(VALUE, char*);
void rb_define_class_variable(VALUE, char*, VALUE);
VALUE rb_mod_class_variables(VALUE);
VALUE rb_mod_remove_cvar(VALUE, VALUE);
/* version.c */
void ruby_show_version();
void ruby_show_copyright();

ID rb_frame_callee();
VALUE rb_str_succ(VALUE);
VALUE rb_time_succ(VALUE);
void rb_frame_pop();
int rb_frame_method_id_and_class(ID *idp, VALUE *klassp);
