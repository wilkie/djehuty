/*
 * format.d
 *
 * This file imports what is necessary for standard variadic arguments in both
 * C and D.
 *
 * Author: Dave Wilkinson
 *
 */

module core.format;

// Imposed variadic
version(LDC)
{
	public import ldc.vararg;
	public import C = ldc.cstdarg;
}
else
{
	public import std.stdarg;
	public import C = std.c.stdarg;
}
