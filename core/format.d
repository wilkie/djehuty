module core.format;

// Imposed variadic
version(LDC)
{
	public import ldc.vararg;
}
else
{
	public import std.stdarg;
	public import C = std.c.stdarg;
}
