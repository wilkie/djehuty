/*
 * variant.d
 *
 * This module contains code for use with a variant type and variadics.
 *
 * Author: Dave Wilkinson
 * Originated: September 10th, 2009
 *
 */

module core.variant;

import core.tostring;
import core.definitions;
import core.unicode;

// Imposed variadic
version(LDC) {
	public import ldc.vararg;
	public import C = ldc.cstdarg;
}
else {
	public import std.stdarg;
	public import C = std.c.stdarg;
}

enum Type {

	// Integer Types
	Byte,
	Short,
	Int,
	Long,
	Ubyte,
	Ushort,
	Uint,
	Ulong,

	// Floating Point
	Real,
	Double,
	Float,
	Ireal,
	Idouble,
	Ifloat,
	Creal,
	Cdouble,
	Cfloat,

	// Char
	Char,
	Wchar,
	Dchar,
	
	// Boolean
	Bool,

	// Abstract Data Types
	Struct,
	Class,
}

struct Variant {
	Type type;

	bool isArray;
	uint depth;

	bool isHash;
	size_t size;

	TypeInfo tiRoot;
	TypeInfo ti;

	VariantData data;

	string toString() {
		if (isArray) {
			if (type == Type.Char) {
				// string
				return data.cs;
			}
			else if (type == Type.Wchar) {
				// string
				return Unicode.toUtf8(data.ws);
			}
			else if (type == Type.Dchar) {
				// string
				return Unicode.toUtf8(data.ds);
			}
			else if (data.array !is null) {
				string ret = "[";
				foreach(int i, item; data.array) {
					ret ~= item.toString();
					if (i < data.array.length-1) {
						ret ~= ",";
					}
				}
				ret ~= "]";
				return ret;
			}
			else {
				return "[]";
			}
		}

		switch (type) {
			case Type.Class:
				if (data.reference is null) {
					return "null";
				}
				else {
					return data.reference.toString();
				}
			case Type.Struct:
				if (data.blob is null) {
					return "null";
				}
				else {
					TypeInfo_Struct tis = cast(TypeInfo_Struct)ti;
					if (tis.xtoString !is null) {
						version(Tango) {
							return tis.xtoString();
						}
						else {
							return tis.xtoString(data.blob.ptr);
						}
					}
				}
				break;
			case Type.Char:
				return [data.cc];
			case Type.Wchar:
				return Unicode.toUtf8([data.cw]);
			case Type.Dchar:
				return Unicode.toUtf8([data.cd]);
			case Type.Byte:
				return toStr(data.b);
			case Type.Ubyte:
				return toStr(data.ub);
			case Type.Short:
				return toStr(data.s);
			case Type.Ushort:
				return toStr(data.us);
			case Type.Int:
				return toStr(data.i);
			case Type.Uint:
				return toStr(data.ui);
			case Type.Long:
				return toStr(data.l);
			case Type.Ulong:
				return toStr(data.ul);
			case Type.Bool:
				if (data.truth) {
					return "true";
				}
				return "false";
			case Type.Float:
				return toStr(data.f);
			case Type.Double:
				return toStr(data.d);
			case Type.Real:
				return toStr(data.r);
			default:
				break;
		}
		return "foo";
	}

}

union VariantData {
	byte b;
	ubyte ub;
	int i;
	uint ui;
	short s;
	ushort us;
	long l;
	ulong ul;

	float f;
	double d;
	real r;

	ifloat fi;
	idouble di;
	ireal ri;

	cfloat fc;
	cdouble dc;
	creal rc;

	char cc;
	wchar cw;
	dchar cd;

	string cs;
	wstring ws;
	dstring ds;

	Object reference;
	ubyte[] blob;
	
	bool truth;

	Variant[] array;
}

class Variadic {
	this(TypeInfo[] args, void* ptr) {
		_args = args;
		_ptr = ptr;
		_originalPtr = _ptr;
	}

	Variant next() {
		Variant ret = _variantForTypeInfo(_args[_idx], _ptr);
		_ptr += argPtrSize(_args[_idx]);
		_idx++;
		return ret;
	}

	Variant[] rest() {
		Variant[] ret;
		foreach(arg; _args[_idx..$]) {
			Variant var = _variantForTypeInfo(arg, _ptr);
			_ptr += argPtrSize(arg);
			ret ~= var;
		}
		return ret;
	}

	Variant peek() {
		Variant ret = _variantForTypeInfo(_args[_idx], _ptr);
		return ret;
	}

	Variant peekAt(size_t index) {
		Variant ret;
		void* ptr = _originalPtr;
		uint startIndex = 0;
		if (index > _idx) {
			startIndex = _idx;
			ptr = _ptr;
		}
		for ( ; startIndex < index; startIndex++) {
			ptr += argPtrSize(_args[index]);
		}
		ret = _variantForTypeInfo(_args[index], ptr);
		return ret;
	}

	Variant[] array() {
		Variant[] ret;
		void* ptr = _originalPtr;
		foreach(arg; _args) {
			Variant var = _variantForTypeInfo(arg, ptr);
			ptr += argPtrSize(arg);
			ret ~= var;
		}
		return ret;
	}

	size_t length() {
		return _args.length;
	}

	void retain() {
		if (_data !is null) {
			return;
		}

		_args = _args.dup;

		// get size
		foreach(arg; _args) {
			_size += arg.tsize();
		}

		// copy
		ubyte* dataptr = cast(ubyte*)_originalPtr;
		_data = new ubyte[_size];
		_data[0.._size] = dataptr[0.._size];
		_ptr = _data.ptr;
		_originalPtr = _ptr;
	}

	int opApply(int delegate(ref Variant) loopFunc) {
		int ret;

		_ptr = _originalPtr;
		foreach(i, arg; _args) {
			Variant var = _variantForTypeInfo(arg, _ptr);
			ret = loopFunc(var);
			_ptr += argPtrSize(arg);
			if (ret) { break; }
		}

		return ret;
	}

	int opApply(int delegate(ref int, ref Variant) loopFunc) {
		int ret;

		_ptr = _originalPtr;
		foreach(int i, arg; _args) {
			Variant var = _variantForTypeInfo(arg, _ptr);
			ret = loopFunc(i,var);
			_ptr += argPtrSize(arg);
			if (ret) { break; }
		}

		return ret;
	}

	Variant opIndex(size_t i1) {
		return peekAt(i1);
	}

protected:

	TypeInfo[] _args;
	void* _ptr;
	void* _originalPtr;
	ubyte[] _data;
	size_t _size;

	size_t _idx;

	size_t argPtrSize(TypeInfo ti) {
		return (ti.tsize() + size_t.sizeof - 1) & ~(size_t.sizeof - 1);
	}

	Variant _variantForTypeInfo(TypeInfo ti, void* ptr) {
		Variant ret;
		void[] arr;

		ret.tiRoot = ti;

		ret.size = ti.tsize();

		string cmp = ti.classinfo.name[9..$];

		/*while (cmp == "Array") {
			Console.putln("Array TI Size: ", ti.tsize());
			ret.depth++;
			TypeInfo_Array tia = cast(TypeInfo_Array)ti;
			ti = tia.value;
			cmp = ti.classinfo.name[9..$];
		}*/

		// check for array
		if (cmp[0] == 'A' && cmp != "Array") {
			ret.depth++;
			ret.isArray = true;

			arr = va_arg!(void[])(ptr);
			ret.data.array = new Variant[arr.length];

			cmp = cmp[1..$];
		}

		// get base type
		switch (cmp) {
			case "Array":
				arr = va_arg!(void[])(ptr);

				ret.isArray = true;
				ret.depth = 1;

				ret.data.array = new Variant[arr.length];

				TypeInfo_Array tia = cast(TypeInfo_Array)ti;

				void* arrPtr = cast(void*)arr.ptr;
				Variant sub;
				for (uint i; i < arr.length; i++) {
					sub = _variantForTypeInfo(tia.value, arrPtr);
					va_arg!(void[])(arrPtr);
					ret.data.array[i] = sub;
				}

				if (sub.isArray) {
					ret.depth += sub.depth;
				}
				ret.type = sub.type;
				break;
			case "Class":
				ret.type = Type.Class;
				ret.data.reference = va_arg!(Object)(ptr);
				break;
			case "Struct":
				ret.type = Type.Struct;
				ret.data.blob = (cast(ubyte*)ptr)[0..ret.size].dup;

				ret.ti = cast(TypeInfo_Struct)ti;
				break;
			case "g":	// byte
				ret.type = Type.Byte;
				if (!ret.isArray) {
					ret.data.b = va_arg!(byte)(ptr);
				}
				else {
					byte* arrPtr = cast(byte*)arr.ptr;

					for (uint i; i < arr.length; i++) {
						Variant val;
						val.type = Type.Byte;
						val.data.b = *arrPtr;
						arrPtr++;
						ret.data.array[i] = val;
					}
				}
				break;
			case "h":	// ubyte
				ret.type = Type.Ubyte;
				if (!ret.isArray) {
					ret.data.ub = va_arg!(ubyte)(ptr);
				}
				else {
					ubyte* arrPtr = cast(ubyte*)arr.ptr;

					for (uint i; i < arr.length; i++) {
						Variant val;
						val.type = Type.Ubyte;
						val.data.ub = *arrPtr;
						arrPtr++;
						ret.data.array[i] = val;
					}
				}
				break;
			case "s":	// short
				ret.type = Type.Short;
				if (!ret.isArray) {
					ret.data.s = va_arg!(short)(ptr);
				}
				else {
					short* arrPtr = cast(short*)arr.ptr;

					for (uint i; i < arr.length; i++) {
						Variant val;
						val.type = Type.Short;
						val.data.s = *arrPtr;
						arrPtr++;
						ret.data.array[i] = val;
					}
				}
				break;
			case "t":	// ushort
				ret.type = Type.Ushort;
				if (!ret.isArray) {
					ret.data.us = va_arg!(ushort)(ptr);
				}
				else {
					ushort* arrPtr = cast(ushort*)arr.ptr;

					for (uint i; i < arr.length; i++) {
						Variant val;
						val.type = Type.Ushort;
						val.data.us = *arrPtr;
						arrPtr++;
						ret.data.array[i] = val;
					}
				}
				break;
			case "i":	// int
				ret.type = Type.Int;
				if (!ret.isArray) {
					ret.data.i = va_arg!(int)(ptr);
				}
				else {
					int* arrPtr = cast(int*)arr.ptr;

					for (uint i; i < arr.length; i++) {
						Variant val;
						val.type = Type.Int;
						val.data.i = *arrPtr;
						arrPtr++;
						ret.data.array[i] = val;
					}
				}
				break;
			case "k":	// uint
				ret.type = Type.Uint;
				if (!ret.isArray) {
					ret.data.ui = va_arg!(uint)(ptr);
				}
				else {
					uint* arrPtr = cast(uint*)arr.ptr;

					for (uint i; i < arr.length; i++) {
						Variant val;
						val.type = Type.Uint;
						val.data.ui = *arrPtr;
						arrPtr++;
						ret.data.array[i] = val;
					}
				}
				break;
			case "l":	// long
				ret.type = Type.Long;
				if (!ret.isArray) {
					ret.data.l = va_arg!(long)(ptr);
				}
				else {
					long* arrPtr = cast(long*)arr.ptr;

					for (uint i; i < arr.length; i++) {
						Variant val;
						val.type = Type.Long;
						val.data.l = *arrPtr;
						arrPtr++;
						ret.data.array[i] = val;
					}
				}
				break;
			case "m":	// ulong
				ret.type = Type.Ulong;
				if (!ret.isArray) {
					ret.data.ul = va_arg!(ulong)(ptr);
				}
				else {
					ulong* arrPtr = cast(ulong*)arr.ptr;

					for (uint i; i < arr.length; i++) {
						Variant val;
						val.type = Type.Ulong;
						val.data.ul = *arrPtr;
						arrPtr++;
						ret.data.array[i] = val;
					}
				}
				break;
			case "f":	// float
				ret.type = Type.Float;
				if (!ret.isArray) {
					ret.data.f = va_arg!(float)(ptr);
				}
				else {
					void* arrPtr = cast(void*)arr.ptr;

					for (uint i; i < arr.length; i++) {
						Variant val;
						val.type = Type.Float;
						val.data.f = va_arg!(float)(arrPtr);
						ret.data.array[i] = val;
					}
				}
				break;
			case "d":	// double
				ret.type = Type.Double;
				if (!ret.isArray) {
					ret.data.d = va_arg!(double)(ptr);
				}
				else {
					void* arrPtr = cast(void*)arr.ptr;

					for (uint i; i < arr.length; i++) {
						Variant val;
						val.type = Type.Double;
						val.data.d = va_arg!(double)(arrPtr);
						ret.data.array[i] = val;
					}
				}
				break;
			case "e":	// real
				ret.type = Type.Real;
				if (!ret.isArray) {
					ret.data.r = va_arg!(real)(ptr);
				}
				else {
					void* arrPtr = cast(void*)arr.ptr;

					for (uint i; i < arr.length; i++) {
						Variant val;
						val.type = Type.Real;
						val.data.r = va_arg!(real)(arrPtr);
						ret.data.array[i] = val;
					}
				}
				break;
			case "o":	// ifloat
				ret.type = Type.Ifloat;
				if (!ret.isArray) {
					ret.data.fi = va_arg!(ifloat)(ptr);
				}
				else {
					void* arrPtr = cast(void*)arr.ptr;

					for (uint i; i < arr.length; i++) {
						Variant val;
						val.type = Type.Ifloat;
						val.data.fi = va_arg!(ifloat)(arrPtr);
						ret.data.array[i] = val;
					}
				}
				break;
			case "p":	// idouble
				ret.type = Type.Idouble;
				if (!ret.isArray) {
					ret.data.di = va_arg!(idouble)(ptr);
				}
				else {
					void* arrPtr = cast(void*)arr.ptr;

					for (uint i; i < arr.length; i++) {
						Variant val;
						val.type = Type.Idouble;
						val.data.di = va_arg!(idouble)(arrPtr);
						ret.data.array[i] = val;
					}
				}
				break;
			case "j":	// ireal
				ret.type = Type.Ireal;
				if (!ret.isArray) {
					ret.data.ri = va_arg!(ireal)(ptr);
				}
				else {
					void* arrPtr = cast(void*)arr.ptr;

					for (uint i; i < arr.length; i++) {
						Variant val;
						val.type = Type.Ireal;
						val.data.ri = va_arg!(ireal)(arrPtr);
						ret.data.array[i] = val;
					}
				}
				break;
			case "a":	// char
				ret.type = Type.Char;
				if (!ret.isArray) {
					ret.data.cc = va_arg!(char)(ptr);
				}
				else {
					// string
					ret.data.cs = (cast(char*)arr.ptr)[0..arr.length];
				}
				break;
			case "u":	// wchar
				ret.type = Type.Wchar;
				if (!ret.isArray) {
					ret.data.cw = va_arg!(wchar)(ptr);
				}
				else {
					// string
					ret.data.ws = (cast(wchar*)arr.ptr)[0..arr.length];
				}
				break;
			case "w":	// wchar
				ret.type = Type.Dchar;
				if (!ret.isArray) {
					ret.data.cd = va_arg!(dchar)(ptr);
				}
				else {
					// string
					ret.data.ds = (cast(dchar*)arr.ptr)[0..arr.length];
				}
				break;
			case "b":	// bool
				ret.type = Type.Bool;
				if (!ret.isArray) {
					ret.data.truth = va_arg!(bool)(ptr);
				}
				else {
					bool* arrPtr = cast(bool*)arr.ptr;

					for (size_t i; i < arr.length; i++) {
						Variant val;
						val.type = Type.Bool;
						val.data.truth = *arrPtr;
						arrPtr++;
						ret.data.array[i] = val;
					}
				}
				break;
			case "q":	// cfloat
				ret.type = Type.Cfloat;
				break;
			case "r":	// cdouble
				ret.type = Type.Cdouble;
				break;
			case "c":	// creal
				ret.type = Type.Creal;
				break;
			default:
				break;
		}
		//Console.putln(cmp, " : ", ret.size);
		return ret;
	}
}

Variadic foobar;

void foo(...) {
	Variadic vars = new Variadic(_arguments, _argptr);
	vars.retain();
	foov(vars);
	foobar = vars;
}

void foov(Variadic v) {
	foreach(var; v) {
//		Console.putln(var.toString());
	}
}
