/*
 * defines.d
 *
 * This file holds bindings to ruby. The original copyrights
 * are displayed below, but do not pertain to this file.
 *
 */

module binding.ruby.defines;

import binding.c;

extern (C):

/************************************************

  defines.h -

  $Author: naruse $
  created at: Wed May 18 00:21:44 JST 1994

************************************************/

const auto RUBY = 1;

void *xmalloc(size_t);
void *xmalloc2(size_t,size_t);
void *xcalloc(size_t,size_t);
void *xrealloc(void*,size_t);
void *xrealloc2(void*,size_t,size_t);
void xfree(void*);

alias xmalloc ruby_xmalloc;
alias xmalloc2 ruby_xmalloc2;
alias xcalloc ruby_xcalloc;
alias xrealloc ruby_xrealloc;
alias xrealloc2 ruby_xrealloc2;
alias xfree ruby_xfree;

alias long LONG_LONG;
const auto HAVE_LONG_LONG = 1;

alias uint BDIGIT;
const auto SIZEOF_BDIGITS = BDIGIT.sizeof;
alias ulong BDIGIT_DBL;
alias long BDIGIT_DBL_SIGNED;
