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

template formatToString() {
	const char[] formatToString = `

	String toParse = new String("");

	for(int curArg = 0; curArg < _arguments.length; curArg++) {
		if (_arguments[curArg] is typeid(String)) {
			toParse ~= va_arg!(String)(_argptr);
		}
		else if (_arguments[curArg] is typeid(bool)) {
			bool argval = cast(bool)va_arg!(bool)(_argptr);
			if (argval) {
				toParse ~= "true";
			}
			else {
				toParse ~= "false";
			}
		}
		else if (_arguments[curArg] is typeid(long)) {
			long argval = cast(long)va_arg!(long)(_argptr);
			toParse ~= new String(argval);
		}
		else if (_arguments[curArg] is typeid(ulong)) {
			ulong argval = va_arg!(ulong)(_argptr);
			toParse ~= new String("%d", argval);
		}
		else if (_arguments[curArg] is typeid(int)) {
			int argval = cast(int)va_arg!(int)(_argptr);
			toParse ~= new String(argval);
		}
		else if (_arguments[curArg] is typeid(uint)) {
			uint argval = cast(uint)va_arg!(uint)(_argptr);
			toParse ~= new String(argval);
		}
		else if (_arguments[curArg] is typeid(short)) {
			short argval = cast(short)va_arg!(short)(_argptr);
			toParse ~= new String(argval);
		}
		else if (_arguments[curArg] is typeid(ushort)) {
			ushort argval = cast(ushort)va_arg!(ushort)(_argptr);
			toParse ~= new String(argval);
		}
		else if (_arguments[curArg] is typeid(byte)) {
			byte argval = cast(byte)va_arg!(byte)(_argptr);
			toParse ~= new String(argval);
		}
		else if (_arguments[curArg] is typeid(ubyte)) {
			ubyte argval = cast(ubyte)va_arg!(ubyte)(_argptr);
			toParse ~= new String(argval);
		}
		else if (_arguments[curArg] is typeid(char[])) {
			char[] chrs = va_arg!(char[])(_argptr);
			toParse ~= chrs;
		}
		else if (_arguments[curArg] is typeid(wchar[])) {
			wchar[] chrs = va_arg!(wchar[])(_argptr);
			toParse ~= cast(char[])chrs;
		}
		else if (_arguments[curArg] is typeid(dchar[])) {
			dchar[] chrs = va_arg!(dchar[])(_argptr);
			toParse ~= cast(char[])chrs;
		}
		else if (_arguments[curArg] is typeid(dchar)) {
			dchar chr = va_arg!(dchar)(_argptr);
			toParse.appendChar(chr);
		}
		else if (_arguments[curArg] is typeid(wchar)) {
			dchar chr = cast(dchar)va_arg!(wchar)(_argptr);
			toParse.appendChar(chr);
		}
		else if (_arguments[curArg] is typeid(char)) {
			dchar chr = cast(dchar)va_arg!(char)(_argptr);
			toParse.appendChar(chr);
		}
		else {
			Object obj = va_arg!(Object)(_argptr);
			toParse ~= obj.toString();
		}
	}
	`;
}