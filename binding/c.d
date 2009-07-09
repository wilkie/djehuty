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

version(GNU)
{
	import gcc.builtins;

	alias __builtin_Clong Clong_t;
	alias __builtin_Culong Culong_t;
}
else version(X86_64)
{
	alias long Clong_t;
	alias ulong Culong_t;
}
else
{
	alias int Clong_t;
	alias uint Culong_t;
}