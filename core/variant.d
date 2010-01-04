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

import tango.io.Stdout;

// Imposed variadic
version(LDC) {
	public import ldc.vararg;
	public import C = ldc.cstdarg;
}
else {
	public import std.stdarg;
	public import C = std.c.stdarg;
}

//import std.stdio;

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
	Pointer,
}

struct Variant {

	Type type() {
		return _type;
	}

	bool isArray() {
		return _isArray;
	}

	bool isAssociative() {
		return _isHash;
	}

	VariantData data() {
		return _data;
	}

	template to(T) {
		T to() {
			static if (is(T == struct) || is(T == union)) {
				T* s = cast(T*)_data.blob.ptr;
				return *s;
			}
			else static if (is(T == class)) {
				Object o = _data.reference;
				T* c = cast(T*)&o;
				return *c;
			}
			else {
				if (_type == Type.Float) {
					return cast(T)_data.f;
				}
				else if (_type == Type.Double) {
					return cast(T)_data.d;
				}
				else if (_type == Type.Real) {
					return cast(T)_data.r;
				}
				else if (_type == Type.Cfloat) {
					return cast(T)_data.fc;
				}
				else if (_type == Type.Cdouble) {
					return cast(T)_data.dc;
				}
				else if (_type == Type.Creal) {
					return cast(T)_data.rc;
				}
				else if (_type == Type.Int) {
					return cast(T)_data.i;
				}
				else if (_type == Type.Uint) {
					return cast(T)_data.ui;
				}
				else if (_type == Type.Ifloat || _type == Type.Idouble || _type == Type.Ireal) {
					return 0.0; // It is 0.0 for the real part
				}
				else {
					return *(cast(T*)&_data.b);
				}
			}
		}
	}

	string toString() {
		if (_isArray) {
			if (_type == Type.Char) {
				// string
				return _data.cs;
			}
			else if (_type == Type.Wchar) {
				// string
				return Unicode.toUtf8(_data.ws);
			}
			else if (_type == Type.Dchar) {
				// string
				return Unicode.toUtf8(_data.ds);
			}
			else if (_data.array !is null) {
				string ret = "[";
				foreach(int i, item; _data.array) {
					ret ~= item.toString();
					if (i < _data.array.length-1) {
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

		switch (_type) {
			case Type.Class:
				if (_data.reference is null) {
					return "null";
				}
				return _data.reference.toString();
			case Type.Struct:
				if (_data.blob is null) {
					return "null";
				}
				else {
					TypeInfo_Struct tis = cast(TypeInfo_Struct)_ti;
					if (tis.xtoString !is null) {
						string delegate() XToStringFunc;
						XToStringFunc.ptr = _data.blob.ptr;
						XToStringFunc.funcptr = cast(string function())tis.xtoString;
						return XToStringFunc();
					}
				}
				break;
			case Type.Char:
				return [_data.cc];
			case Type.Wchar:
				return Unicode.toUtf8([_data.cw]);
			case Type.Dchar:
				return Unicode.toUtf8([_data.cd]);
			case Type.Byte:
				return toStr(_data.b);
			case Type.Ubyte:
				return toStr(_data.ub);
			case Type.Short:
				return toStr(_data.s);
			case Type.Ushort:
				return toStr(_data.us);
			case Type.Int:
				return toStr(_data.i);
			case Type.Uint:
				return toStr(_data.ui);
			case Type.Long:
				return toStr(_data.l);
			case Type.Ulong:
				return toStr(_data.ul);
			case Type.Bool:
				if (_data.truth) {
					return "true";
				}
				return "false";
			case Type.Float:
				return toStr(_data.f);
			case Type.Double:
				return toStr(_data.d);
			case Type.Real:
				return toStr(_data.r);
			case Type.Pointer:
				return toStr(_data.pointer.address);
			default:
				break;
		}
		return "foo";
	}

private:
	Type _type;

	bool _isArray;
	uint _depth;

	bool _isHash;
	size_t _size;

	TypeInfo _tiRoot;
	TypeInfo _ti;

	VariantData _data;

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

	struct VariantPointerData {
		void* address;
		Variant* next;
	}
	VariantPointerData pointer;
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

		// get _size
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

	int opApply(int delegate(ref size_t, ref Variant) loopFunc) {
		int ret;

		_ptr = _originalPtr;
		foreach(size_t i, arg; _args) {
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

	size_t argPtrSize(TypeInfo _ti) {
		return (_ti.tsize() + size_t.sizeof - 1) & ~(size_t.sizeof - 1);
	}

	Variant _variantForTypeInfo(TypeInfo _ti, void* ptr) {
		Variant ret;
		void[] arr;

		ret._tiRoot = _ti;

		ret._size = _ti.tsize();

		string cmp = _ti.classinfo.name[9..$];

		/*while (cmp == "Array") {
			Console.putln("Array TI Size: ", _ti.tsize());
			ret._depth++;
			TypeInfo_Array tia = cast(TypeInfo_Array)_ti;
			_ti = tia.value;
			cmp = _ti.classinfo.name[9..$];
		}*/

		// check for array
		if (cmp[0] == 'A' && cmp != "Array") {
			ret._depth++;
			ret._isArray = true;

			if (ptr !is null) {
				arr = va_arg!(void[])(ptr);
			}
			ret._data.array = new Variant[arr.length];

			cmp = cmp[1..$];
		}

		// get base _type
		switch (cmp) {
			case "Array":
				arr = va_arg!(void[])(ptr);

				ret._isArray = true;
				ret._depth = 1;

				ret._data.array = new Variant[arr.length];

				TypeInfo_Array tia = cast(TypeInfo_Array)_ti;

				void* arrPtr = cast(void*)arr.ptr;
				Variant sub;
				for (uint i; i < arr.length; i++) {
					sub = _variantForTypeInfo(tia.value, arrPtr);
					if (arrPtr !is null) {
						va_arg!(void[])(arrPtr);
					}
					ret._data.array[i] = sub;
				}

				if (sub._isArray) {
					ret._depth += sub._depth;
				}
				ret._type = sub._type;
				break;
			case "Class":
				ret._type = Type.Class;
				if (ptr !is null) {
					ret._data.reference = va_arg!(Object)(ptr);
				}
				break;
			case "Struct":
				ret._type = Type.Struct;

				if (ptr !is null) {
					ubyte[] foo = new ubyte[ret._size];
					foo[0..$] = (cast(ubyte*)ptr)[0..ret._size];
					ret._data.blob = foo;
				}

				ret._ti = cast(TypeInfo_Struct)_ti;
				break;
			case "g":	// byte
				ret._type = Type.Byte;
				if (!ret._isArray) {
					if (ptr !is null) {
						ret._data.b = va_arg!(byte)(ptr);
					}
				}
				else {
					byte* arrPtr = cast(byte*)arr.ptr;

					for (uint i; i < arr.length; i++) {
						Variant val;
						val._type = Type.Byte;
						if (ptr !is null) {
							val._data.b = *arrPtr;
							arrPtr++;
						}
						ret._data.array[i] = val;
					}
				}
				break;
			case "h":	// ubyte
				ret._type = Type.Ubyte;
				if (!ret._isArray) {
					if (ptr !is null) {
						ret._data.ub = va_arg!(ubyte)(ptr);
					}
				}
				else {
					ubyte* arrPtr = cast(ubyte*)arr.ptr;

					for (uint i; i < arr.length; i++) {
						Variant val;
						val._type = Type.Ubyte;
						if (ptr !is null) {
							val._data.ub = *arrPtr;
							arrPtr++;
						}
						ret._data.array[i] = val;
					}
				}
				break;
			case "s":	// short
				ret._type = Type.Short;
				if (!ret._isArray) {
					if (ptr !is null) {
						ret._data.s = va_arg!(short)(ptr);
					}
				}
				else {
					short* arrPtr = cast(short*)arr.ptr;

					for (uint i; i < arr.length; i++) {
						Variant val;
						val._type = Type.Short;
						if (ptr !is null) {
							val._data.s = *arrPtr;
							arrPtr++;
						}
						ret._data.array[i] = val;
					}
				}
				break;
			case "t":	// ushort
				ret._type = Type.Ushort;
				if (!ret._isArray) {
					if (ptr !is null) {
						ret._data.us = va_arg!(ushort)(ptr);
					}
				}
				else {
					ushort* arrPtr = cast(ushort*)arr.ptr;

					for (uint i; i < arr.length; i++) {
						Variant val;
						val._type = Type.Ushort;
						if (ptr !is null) {
							val._data.us = *arrPtr;
							arrPtr++;
						}
						ret._data.array[i] = val;
					}
				}
				break;
			case "i":	// int
				ret._type = Type.Int;
				if (!ret._isArray) {
					if (ptr !is null) {
						ret._data.i = va_arg!(int)(ptr);
					}
				}
				else {
					int* arrPtr = cast(int*)arr.ptr;

					for (uint i; i < arr.length; i++) {
						Variant val;
						val._type = Type.Int;
						if (ptr !is null) {
							val._data.i = *arrPtr;
							arrPtr++;
						}
						ret._data.array[i] = val;
					}
				}
				break;
			case "k":	// uint
				ret._type = Type.Uint;
				if (!ret._isArray) {
					if (ptr !is null) {
						ret._data.ui = va_arg!(uint)(ptr);
					}
				}
				else {
					uint* arrPtr = cast(uint*)arr.ptr;

					for (uint i; i < arr.length; i++) {
						Variant val;
						val._type = Type.Uint;
						if (ptr !is null) {
							val._data.ui = *arrPtr;
							arrPtr++;
						}
						ret._data.array[i] = val;
					}
				}
				break;
			case "l":	// long
				ret._type = Type.Long;
				if (!ret._isArray) {
					if (ptr !is null) {
						ret._data.l = va_arg!(long)(ptr);
					}
				}
				else {
					long* arrPtr = cast(long*)arr.ptr;

					for (uint i; i < arr.length; i++) {
						Variant val;
						val._type = Type.Long;
						if (ptr !is null) {
							val._data.l = *arrPtr;
							arrPtr++;
						}
						ret._data.array[i] = val;
					}
				}
				break;
			case "m":	// ulong
				ret._type = Type.Ulong;
				if (!ret._isArray) {
					if (ptr !is null) {
						ret._data.ul = va_arg!(ulong)(ptr);
					}
				}
				else {
					ulong* arrPtr = cast(ulong*)arr.ptr;

					for (uint i; i < arr.length; i++) {
						Variant val;
						val._type = Type.Ulong;
						if (ptr !is null) {
							val._data.ul = *arrPtr;
							arrPtr++;
						}
						ret._data.array[i] = val;
					}
				}
				break;
			case "f":	// float
				ret._type = Type.Float;
				if (!ret._isArray) {
					if (ptr !is null) {
						ret._data.f = va_arg!(float)(ptr);
					}
				}
				else {
					void* arrPtr = cast(void*)arr.ptr;

					for (uint i; i < arr.length; i++) {
						Variant val;
						val._type = Type.Float;
						if (ptr !is null) {
							val._data.f = va_arg!(float)(arrPtr);
						}
						ret._data.array[i] = val;
					}
				}
				break;
			case "d":	// double
				ret._type = Type.Double;
				if (!ret._isArray) {
					if (ptr !is null) {
						ret._data.d = va_arg!(double)(ptr);
					}
				}
				else {
					void* arrPtr = cast(void*)arr.ptr;

					for (uint i; i < arr.length; i++) {
						Variant val;
						val._type = Type.Double;
						if (ptr !is null) {
							val._data.d = va_arg!(double)(arrPtr);
						}
						ret._data.array[i] = val;
					}
				}
				break;
			case "e":	// real
				ret._type = Type.Real;
				if (!ret._isArray) {
					if (ptr !is null) {
						ret._data.r = va_arg!(real)(ptr);
					}
				}
				else {
					void* arrPtr = cast(void*)arr.ptr;

					for (uint i; i < arr.length; i++) {
						Variant val;
						val._type = Type.Real;
						if (ptr !is null) {
							val._data.r = va_arg!(real)(arrPtr);
						}
						ret._data.array[i] = val;
					}
				}
				break;
			case "o":	// ifloat
				ret._type = Type.Ifloat;
				if (!ret._isArray) {
					if (ptr !is null) {
						ret._data.fi = va_arg!(ifloat)(ptr);
					}
				}
				else {
					void* arrPtr = cast(void*)arr.ptr;

					for (uint i; i < arr.length; i++) {
						Variant val;
						val._type = Type.Ifloat;
						if (ptr !is null) {
							val._data.fi = va_arg!(ifloat)(arrPtr);
						}
						ret._data.array[i] = val;
					}
				}
				break;
			case "p":	// idouble
				ret._type = Type.Idouble;
				if (!ret._isArray) {
					if (ptr !is null) {
						ret._data.di = va_arg!(idouble)(ptr);
					}
				}
				else {
					void* arrPtr = cast(void*)arr.ptr;

					for (uint i; i < arr.length; i++) {
						Variant val;
						val._type = Type.Idouble;
						if (ptr !is null) {
							val._data.di = va_arg!(idouble)(arrPtr);
						}
						ret._data.array[i] = val;
					}
				}
				break;
			case "j":	// ireal
				ret._type = Type.Ireal;
				if (!ret._isArray) {
					if (ptr !is null) {
						ret._data.ri = va_arg!(ireal)(ptr);
					}
				}
				else {
					void* arrPtr = cast(void*)arr.ptr;

					for (uint i; i < arr.length; i++) {
						Variant val;
						val._type = Type.Ireal;
						if (ptr !is null) {
							val._data.ri = va_arg!(ireal)(arrPtr);
						}
						ret._data.array[i] = val;
					}
				}
				break;
			case "a":	// char
				ret._type = Type.Char;
				if (!ret._isArray) {
					if (ptr !is null) {
						ret._data.cc = va_arg!(char)(ptr);
					}
				}
				else {
					// string
					if (ptr !is null) {
						ret._data.cs = (cast(char*)arr.ptr)[0..arr.length];
					}
				}
				break;
			case "u":	// wchar
				ret._type = Type.Wchar;
				if (!ret._isArray) {
					if (ptr !is null) {
						ret._data.cw = va_arg!(wchar)(ptr);
					}
				}
				else {
					// string
					if (ptr !is null) {
						ret._data.ws = (cast(wchar*)arr.ptr)[0..arr.length];
					}
				}
				break;
			case "w":	// wchar
				ret._type = Type.Dchar;
				if (!ret._isArray) {
					if (ptr !is null) {
						ret._data.cd = va_arg!(dchar)(ptr);
					}
				}
				else {
					// string
					if (ptr !is null) {
						ret._data.ds = (cast(dchar*)arr.ptr)[0..arr.length];
					}
				}
				break;
			case "b":	// bool
				ret._type = Type.Bool;
				if (!ret._isArray) {
					if (ptr !is null) {
						ret._data.truth = va_arg!(bool)(ptr);
					}
				}
				else {
					bool* arrPtr = cast(bool*)arr.ptr;

					for (size_t i; i < arr.length; i++) {
						Variant val;
						val._type = Type.Bool;
						if (ptr !is null) {
							val._data.truth = *arrPtr;
							arrPtr++;
						}
						ret._data.array[i] = val;
					}
				}
				break;
			case "q":	// cfloat
				ret._type = Type.Cfloat;
				if (!ret._isArray) {
					if (ptr !is null) {
						ret._data.fc = va_arg!(cfloat)(ptr);
					}
				}
				else {
					void* arrPtr = cast(void*)arr.ptr;

					for (uint i; i < arr.length; i++) {
						Variant val;
						val._type = Type.Cfloat;
						if (ptr !is null) {
							val._data.fc = va_arg!(cfloat)(arrPtr);
						}
						ret._data.array[i] = val;
					}
				}
				break;
			case "r":	// cdouble
				ret._type = Type.Cdouble;
				if (!ret._isArray) {
					if (ptr !is null) {
						ret._data.dc = va_arg!(cdouble)(ptr);
					}
				}
				else {
					void* arrPtr = cast(void*)arr.ptr;

					for (uint i; i < arr.length; i++) {
						Variant val;
						val._type = Type.Cdouble;
						if (ptr !is null) {
							val._data.dc = va_arg!(cdouble)(arrPtr);
						}
						ret._data.array[i] = val;
					}
				}
				break;
			case "c":	// creal
				ret._type = Type.Creal;
				if (!ret._isArray) {
					if (ptr !is null) {
						ret._data.rc = va_arg!(creal)(ptr);
					}
				}
				else {
					void* arrPtr = cast(void*)arr.ptr;

					for (uint i; i < arr.length; i++) {
						Variant val;
						val._type = Type.Creal;
						if (ptr !is null) {
							val._data.rc = va_arg!(creal)(arrPtr);
						}
						ret._data.array[i] = val;
					}
				}
				break;
			case "Pointer":
				ret._type = Type.Pointer;
				if (ptr !is null) {
					ret._data.pointer.address = va_arg!(void*)(ptr);
				}
				Variant foo;
				TypeInfo_Pointer tip = cast(TypeInfo_Pointer)_ti;
				foo = _variantForTypeInfo(tip.next, null);
				ret._data.pointer.next = &foo;
				break;
			default:
				break;
		}
		//Console.putln(cmp, " : ", ret._size);
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
