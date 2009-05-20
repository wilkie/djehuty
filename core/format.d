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
