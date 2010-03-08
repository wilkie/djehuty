/*
 * object.d
 *
 * This module implements the Object class.
 *
 */

module object;

// Imports necessary routines used by the runtime
import mindrt.util;
import mindrt.dstatic;
import mindrt.dstubs;
import mindrt.exception;
import mindrt.error;

//import std.moduleinit;

// Based in part on object.d provided with Phobos. The original copyright is as follows:

/*
 *	Copyright (C) 2004-2007 by Digital Mars, www.digitalmars.com
 *	Written by Walter Bright
 *
 *	This software is provided 'as-is', without any express or implied
 *	warranty. In no event will the authors be held liable for any damages
 *	arising from the use of this software.
 *
 *	Permission is granted to anyone to use this software for any purpose,
 *	including commercial applications, and to alter it and redistribute it
 *	freely, in both source and binary form, subject to the following
 *	restrictions:
 *
 *	o  The origin of this software must not be misrepresented; you must not
 *	   claim that you wrote the original software. If you use this software
 *	   in a product, an acknowledgment in the product documentation would be
 *	   appreciated but is not required.
 *	o  Altered source versions must be plainly marked as such, and must not
 *	   be misrepresented as being the original software.
 *	o  This notice may not be removed or altered from any source
 *	   distribution.
 */

// Figure out the size of a pointer
static if ((ubyte*).sizeof == 8) {
	version = Arch64;
}
else static if ((ubyte*).sizeof == 4) {
	version = Arch32;
}

version(Arch32) {
	alias uint size_t;
	alias int ptrdiff_t;
	alias uint hash_t;
}
else {
	alias ulong size_t;
	alias long ptrdiff_t;
	alias ulong hash_t;
}

// Description: This is an internal structure hidden in the object.
struct Monitor {
	void delegate(Object)[] delegates;

	/* More stuff goes here defined by internal/monitor.c */
}

// Description: The base class inherited by all classes.
class Object {

	// Description: Returns a string representing this object.
	char[] toString() {
		return this.classinfo.name;
	}

	// Description: Computes a hash representing this object
	hash_t toHash() {
		// BUG: this prevents a compacting GC from working, needs to be fixed
		return cast(uint)cast(void *)this;
	}

	// Will compare two Object classes
	// Returns: 0 if equal, -1 if o is greater, 1 if o is smaller.
	int opCmp(Object o) {
		// BUG: this prevents a compacting GC from working, needs to be fixed
		//return cast(int)cast(void *)this - cast(int)cast(void *)o;

		throw new Error("need opCmp for class " ~ this.classinfo.name);
	}

	// Will compare two Object classes for equality.
	// Returns: 0 if not equal.
	int opEquals(Object o) {
		return cast(int)(this is o);
	}
}

// Description: This is the information stored for an interface.
struct Interface {
	ClassInfo classinfo;		// .classinfo for this interface (not for containing class)
	void *[] vtbl;
	int offset; 				// offset to Interface 'this' from Object 'this'
}

// Description: The information stored for a class. Retrieved via the .classinfo property.
//  It is stored as the first entry in the class' vtbl[].
class ClassInfo : Object {
	byte[] init;				/** class static initializer
								 * (init.length gives size in bytes of class)
								 */
	char[] name;				/// class name

	void *[] vtbl;				/// virtual function pointer table

	Interface[] interfaces; 	/// interfaces this class implements

	ClassInfo base; 			/// base class

	void *destructor;

	void function(Object) classInvariant;

	uint flags;
	//	1:						// IUnknown
	//	2:						// has no possible pointers into GC memory
	//	4:						// has offTi[] member
	//	8:						// has constructors

	void *deallocator;

	OffsetTypeInfo[] offTi;

	void* defaultConstructor;	// default Constructor

	TypeInfo typeinfo;

	/*************
	 * Search all modules for ClassInfo corresponding to classname.
	 * Returns: null if not found
	 */
	static ClassInfo find(char[] classname) {
		/*foreach (m; ModuleInfo)
		{
			//writefln("module %s, %d", m.name, m.localClasses.length);
			foreach (c; m.localClasses)
			{
				//writefln("\tclass %s", c.name);
				if (c.name == classname)
					return c;
			}
		}*/
		return null;
	}

	// Description: Creates an instance of the class represented by the current class.
	Object create() {
		/*
		if (flags & 8 && !defaultConstructor)
			return null;
		Object o = _d_newclass(this);
		if (flags & 8 && defaultConstructor)
		{
			defaultConstructor(o);
		}
		return o;*/
        if (flags & 8 && !defaultConstructor)
            return null;

        Object o = _d_allocclass(this);
        // initialize it
        (cast(byte*) o)[0 .. init.length] = init[];

        if (flags & 8 && defaultConstructor)
        {
            auto ctor = cast(Object function(Object))defaultConstructor;
            return ctor(o);
        }
        return o;
	}
}

class ModuleInfo : Object {
    char[] name;
    ModuleInfo[] importedModules;
    ClassInfo[] localClasses;

    uint flags;     // initialization state

    void function() ctor;
    void function() dtor;
    void function() unitTest;
    void* xgetMembers;
    void function() ictor;

    // Return collection of all modules in the program.
    static int opApply(int delegate(ref ModuleInfo));
}

/**
 * Array of pairs giving the offset and type information for each
 * member in an aggregate.
 */
struct OffsetTypeInfo {
	size_t offset;		/// Offset of member from start of object
	TypeInfo ti;		/// TypeInfo for this member
}

// Description: This stores information about a type. Retrieved with the typeid expression.
class TypeInfo {
	hash_t toHash() {
		hash_t hash;

		foreach (char c; this.toString())
			hash = hash * 9 + c;
		return hash;
	}

	int opCmp(Object o) {
		if (this is o)
			return 0;
		TypeInfo ti = cast(TypeInfo)o;
		if (ti is null)
			return 1;

		char[] t = this.toString();
		char[] other = this.toString();

		typeid(typeof(this.toString())).compare(&t, &other);
	}

	int opEquals(Object o) {
		/* TypeInfo instances are singletons, but duplicates can exist
		 * across DLL's. Therefore, comparing for a name match is
		 * sufficient.
		 */
		if (this is o)
			return 1;
		TypeInfo ti = cast(TypeInfo)o;
		return cast(int)(ti && this.toString() == ti.toString());
	}

	/// Returns a hash of the instance of a type.
	hash_t getHash(void *p) { return cast(uint)p; }

	/// Compares two instances for equality.
	int equals(void *p1, void *p2) { return cast(int)(p1 == p2); }

	/// Compares two instances for &lt;, ==, or &gt;.
	int compare(void *p1, void *p2) { return 0; }

	/// Returns size of the type.
	size_t tsize() { return 0; }

	/// Swaps two instances of the type.
	void swap(void *p1, void *p2) {
		size_t n = tsize();
		for (size_t i = 0; i < n; i++) {
			byte t;

			t = (cast(byte *)p1)[i];
			(cast(byte *)p1)[i] = (cast(byte *)p2)[i];
			(cast(byte *)p2)[i] = t;
		}
	}

	/// Get TypeInfo for 'next' type, as defined by what kind of type this is,
	/// null if none.
	TypeInfo next() { return null; }

	/// Return default initializer, null if default initialize to 0
	void[] init() { return null; }

	/// Get flags for type: 1 means GC should scan for pointers
	uint flags() { return 0; }

	/// Get type information on the contents of the type; null if not available
	OffsetTypeInfo[] offTi() { return null; }
}

class TypeInfo_Typedef : TypeInfo {
	char[] toString() { return name; }

	int opEquals(Object o) {
		TypeInfo_Typedef c;

		return cast(int)
				(this is o ||
				((c = cast(TypeInfo_Typedef)o) !is null &&
				 this.name == c.name &&
				 this.base == c.base));
	}

	hash_t getHash(void *p) { return base.getHash(p); }
	int equals(void *p1, void *p2) { return base.equals(p1, p2); }
	int compare(void *p1, void *p2) { return base.compare(p1, p2); }
	size_t tsize() { return base.tsize(); }
	void swap(void *p1, void *p2) { return base.swap(p1, p2); }

	TypeInfo next() { return base.next(); }
	uint flags() { return base.flags(); }
	void[] init() { return m_init.length ? m_init : base.init(); }

	TypeInfo base;
	char[] name;
	void[] m_init;
}

class TypeInfo_Enum : TypeInfo_Typedef {
}

class TypeInfo_Pointer : TypeInfo {
	char[] toString() { return m_next.toString() ~ "*"; }

	int opEquals(Object o) {
		TypeInfo_Pointer c;

		return this is o ||
				((c = cast(TypeInfo_Pointer)o) !is null &&
				 this.m_next == c.m_next);
	}

	hash_t getHash(void *p) {
		return cast(uint)*cast(void* *)p;
	}

	int equals(void *p1, void *p2) {
		return cast(int)(*cast(void* *)p1 == *cast(void* *)p2);
	}

	int compare(void *p1, void *p2) {
		if (*cast(void* *)p1 < *cast(void* *)p2)
			return -1;
		else if (*cast(void* *)p1 > *cast(void* *)p2)
			return 1;
		else
			return 0;
	}

	size_t tsize() {
		return (void*).sizeof;
	}

	void swap(void *p1, void *p2) {
		void* tmp;
		tmp = *cast(void**)p1;
		*cast(void**)p1 = *cast(void**)p2;
		*cast(void**)p2 = tmp;
	}

	TypeInfo next() { return m_next; }
	uint flags() { return 1; }

	TypeInfo m_next;
}

class TypeInfo_Array : TypeInfo {
	char[] toString() { return value.toString() ~ "[]"; }

	int opEquals(Object o) {
		TypeInfo_Array c;

		return cast(int)
			   (this is o ||
				((c = cast(TypeInfo_Array)o) !is null &&
				 this.value == c.value));
	}

	hash_t getHash(void *p) {
		size_t sz = value.tsize();
		hash_t hash = 0;
		void[] a = *cast(void[]*)p;
		for (size_t i = 0; i < a.length; i++)
			hash += value.getHash(a.ptr + i * sz);
		return hash;
	}

	int equals(void *p1, void *p2) {
		void[] a1 = *cast(void[]*)p1;
		void[] a2 = *cast(void[]*)p2;
		if (a1.length != a2.length)
			return 0;
		size_t sz = value.tsize();
		for (size_t i = 0; i < a1.length; i++) {
			if (!value.equals(a1.ptr + i * sz, a2.ptr + i * sz))
				return 0;
		}
		return 1;
	}

	int compare(void *p1, void *p2) {
		void[] a1 = *cast(void[]*)p1;
		void[] a2 = *cast(void[]*)p2;
		size_t sz = value.tsize();
		size_t len = a1.length;

		if (a2.length < len)
			len = a2.length;
		for (size_t u = 0; u < len; u++) {
			int result = value.compare(a1.ptr + u * sz, a2.ptr + u * sz);
			if (result)
				return result;
		}
		return cast(int)a1.length - cast(int)a2.length;
	}

	size_t tsize() {
		return (void[]).sizeof;
	}

	void swap(void *p1, void *p2) {
		void[] tmp;
		tmp = *cast(void[]*)p1;
		*cast(void[]*)p1 = *cast(void[]*)p2;
		*cast(void[]*)p2 = tmp;
	}

	TypeInfo value;

	TypeInfo next() {
		return value;
	}

	uint flags() { return 1; }
}

class TypeInfo_StaticArray : TypeInfo {
	char[] toString() {
		char[20] buf;
		return value.toString() ~ "[" ~ itoa(buf, 'd', len) ~ "]";
	}

	int opEquals(Object o) {
		TypeInfo_StaticArray c;

		return cast(int)
			   (this is o ||
				((c = cast(TypeInfo_StaticArray)o) !is null &&
				 this.len == c.len &&
				 this.value == c.value));
	}

	hash_t getHash(void *p) {	
		size_t sz = value.tsize();
		hash_t hash = 0;
		for (size_t i = 0; i < len; i++)
			hash += value.getHash(p + i * sz);
		return hash;
	}

	int equals(void *p1, void *p2) {
		size_t sz = value.tsize();

		for (size_t u = 0; u < len; u++) {
			if (!value.equals(p1 + u * sz, p2 + u * sz))
				return 0;
		}
		return 1;
	}

	int compare(void *p1, void *p2) {
		size_t sz = value.tsize();

		for (size_t u = 0; u < len; u++) {
			int result = value.compare(p1 + u * sz, p2 + u * sz);
			if (result)
				return result;
		}
		return 0;
	}

	size_t tsize() {
		return len * value.tsize();
	}

	void swap(void *p1, void *p2) {
		void* tmp;
		size_t sz = value.tsize();
		ubyte[16] buffer;
		void* pbuffer;

		if (sz < buffer.sizeof)
			tmp = buffer.ptr;
		else
			tmp = pbuffer = (new void[sz]).ptr;

		for (size_t u = 0; u < len; u += sz) {
			size_t o = u * sz;
			tmp[0 .. sz] = (p1 + o)[0 .. sz];
			(p1 + o)[0 .. sz] = (p2 + o)[0 .. sz];
			(p2 + o)[0 .. sz] = tmp[0 .. sz];
		}
		if (pbuffer)
			delete pbuffer;
	}

	void[] init() {
		return value.init();
	}

	TypeInfo next() {
		return value;
	}

	uint flags() {
		return value.flags(); 
	}

	TypeInfo value;
	size_t len;
}

class TypeInfo_AssociativeArray : TypeInfo {
	char[] toString() {
		return value.toString() ~ "[" ~ key.toString() ~ "]";
	}

	int opEquals(Object o) {
		TypeInfo_AssociativeArray c;

		return this is o ||
				((c = cast(TypeInfo_AssociativeArray)o) !is null &&
				 this.key == c.key &&
				 this.value == c.value);
	}

	// BUG: need to add the rest of the functions

	size_t tsize() {
		return (char[int]).sizeof;
	}

	TypeInfo next() {
		return value;
	}

	uint flags() {
		return 1;
	}

	TypeInfo value;
	TypeInfo key;
}

class TypeInfo_Function : TypeInfo {
	char[] toString() {
		return next.toString() ~ "()";
	}

	int opEquals(Object o) {
		TypeInfo_Function c;

		return this is o ||
				((c = cast(TypeInfo_Function)o) !is null &&
				 this.next == c.next);
	}

	// BUG: need to add the rest of the functions

	size_t tsize() {
		return 0;		// no size for functions
	}

	TypeInfo next;
}

class TypeInfo_Delegate : TypeInfo {
	char[] toString() {
		return next.toString() ~ " delegate()";
	}

	int opEquals(Object o) {
		TypeInfo_Delegate c;

		return this is o ||
				((c = cast(TypeInfo_Delegate)o) !is null &&
				 this.next == c.next);
	}

	// BUG: need to add the rest of the functions

	size_t tsize() {
		alias int delegate() dg;
		return dg.sizeof;
	}

	uint flags() {
		return 1;
	}

	TypeInfo next;
}

class TypeInfo_Class : TypeInfo {
	char[] toString() {
		return info.name;
	}

	int opEquals(Object o) {
		TypeInfo_Class c;

		return this is o ||
				((c = cast(TypeInfo_Class)o) !is null &&
				 this.info.name == c.classinfo.name);
	}

	hash_t getHash(void *p) {
		Object o = *cast(Object*)p;
		assert(o);
		return o.toHash();
	}

	int equals(void *p1, void *p2) {
		Object o1 = *cast(Object*)p1;
		Object o2 = *cast(Object*)p2;

		return (o1 is o2) || (o1 && o1.opEquals(o2));
	}

	int compare(void *p1, void *p2) {
		Object o1 = *cast(Object*)p1;
		Object o2 = *cast(Object*)p2;
		int c = 0;

		// Regard null references as always being "less than"
		if (o1 !is o2) {
			if (o1) {
				if (!o2)
					c = 1;
				else
					c = o1.opCmp(o2);
			}
			else
				c = -1;
		}
		return c;
	}

	size_t tsize() {
		return Object.sizeof;
	}

	uint flags() {
		return 1;
	}

	OffsetTypeInfo[] offTi() {
		return (info.flags & 4) ? info.offTi : null;
	}

	ClassInfo info;
}

class TypeInfo_Interface : TypeInfo {
	char[] toString() {
		return info.name;
	}

	int opEquals(Object o) {
		TypeInfo_Interface c;

		return this is o ||
				((c = cast(TypeInfo_Interface)o) !is null &&
				 this.info.name == c.classinfo.name);
	}

	hash_t getHash(void *p) {
		Interface* pi = **cast(Interface ***)*cast(void**)p;
		Object o = cast(Object)(*cast(void**)p - pi.offset);
		assert(o);
		return o.toHash();
	}

	int equals(void *p1, void *p2) {
		Interface* pi = **cast(Interface ***)*cast(void**)p1;
		Object o1 = cast(Object)(*cast(void**)p1 - pi.offset);
		pi = **cast(Interface ***)*cast(void**)p2;
		Object o2 = cast(Object)(*cast(void**)p2 - pi.offset);

		return o1 == o2 || (o1 && o1.opCmp(o2) == 0);
	}

	int compare(void *p1, void *p2) {
		Interface* pi = **cast(Interface ***)*cast(void**)p1;
		Object o1 = cast(Object)(*cast(void**)p1 - pi.offset);
		pi = **cast(Interface ***)*cast(void**)p2;
		Object o2 = cast(Object)(*cast(void**)p2 - pi.offset);
		int c = 0;

		// Regard null references as always being "less than"
		if (o1 != o2) {
			if (o1) {
				if (!o2)
					c = 1;
				else
					c = o1.opCmp(o2);
			}
			else
				c = -1;
		}
		return c;
	}

	size_t tsize() {
		return Object.sizeof;
	}

	uint flags() {
		return 1;
	}

	ClassInfo info;
}

class TypeInfo_Struct : TypeInfo {
	char[] toString() {
		return name;
	}

	int opEquals(Object o) {
		TypeInfo_Struct s;

		return this is o ||
				((s = cast(TypeInfo_Struct)o) !is null &&
				 this.name == s.name &&
				 this.init.length == s.init.length);
	}

	hash_t getHash(void *p) {
		hash_t h;

		assert(p);
		if (xtoHash) {
			h = (*xtoHash)(p);
		}
		else {
			//printf("getHash() using default hash\n");
			// A sorry hash algorithm.
			// Should use the one for strings.
			// BUG: relies on the GC not moving objects
			for (size_t i = 0; i < init.length; i++) {
				h = h * 9 + *cast(ubyte*)p;
				p++;
			}
		}
		return h;
	}

	int equals(void *p2, void *p1) {
		int c;

		if (p1 == p2)
			c = 1;
		else if (!p1 || !p2)
			c = 0;
		else if (xopEquals)
			c = (*xopEquals)(p1, p2);
		else
			// BUG: relies on the GC not moving objects
			c = (memcmp(cast(ubyte*)p1, cast(ubyte*)p2, init.length) == 0);
		return c;
	}

	int compare(void *p2, void *p1) {
		int c = 0;

		// Regard null references as always being "less than"
		if (p1 != p2) {
			if (p1) {
				if (!p2)
					c = 1;
				else if (xopCmp)
					c = (*xopCmp)(p1, p2);
				else
					// BUG: relies on the GC not moving objects
					c = memcmp(cast(ubyte*)p1, cast(ubyte*)p2, init.length);
			}
			else
				c = -1;
		}
		return c;
	}

	size_t tsize() {
		return init.length;
	}

	void[] init() {
		return m_init;
	}

	uint flags() {
		return m_flags;
	}

	char[] name;
	void[] m_init;		// initializer; init.ptr == null if 0 initialize

	hash_t function(void*) xtoHash;
	int function(void*,void*) xopEquals;
	int function(void*,void*) xopCmp;
	char[] function(void*) xtoString;

	uint m_flags;
}

class TypeInfo_Tuple : TypeInfo {
	TypeInfo[] elements;

	char[] toString() {
		char[] s;
		s = "(";
		foreach (i, element; elements) {
			if (i)
				s ~= ',';
			s ~= element.toString();
		}
		s ~= ")";
		return s;
	}

	int opEquals(Object o) {
		if (this is o)
			return 1;

		auto t = cast(TypeInfo_Tuple)o;
		if (t && elements.length == t.elements.length) {
			for (size_t i = 0; i < elements.length; i++) {
				if (elements[i] != t.elements[i])
					return 0;
			}
			return 1;
		}
		return 0;
	}

	hash_t getHash(void *p) {
		assert(0);
	}

	int equals(void *p1, void *p2) {
		assert(0);
	}

	int compare(void *p1, void *p2) {
		assert(0);
	}

	size_t tsize() {
		assert(0);
	}

	void swap(void *p1, void *p2) {
		assert(0);
	}
}

