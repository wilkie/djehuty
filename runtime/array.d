/*
 * array.d
 *
 * This module implements the runtime functions related
 * to arrays.
 *
 */

module runtime.array;

extern(C):

Array _adReverseChar(char[] a) {
	if(a.length > 1) {
		char[6] tmp;
		char[6] tmplo;
		char* lo = a.ptr;
		char* hi = &a[length - 1];

		while (lo < hi) {
			auto clo = *lo;
			auto chi = *hi;

			if (clo <= 0x7F && chi <= 0x7F) {
				*lo = chi;
				*hi = clo;
				lo++;
				hi--;
				continue;
			}

			uint stridelo = UTF8stride[clo];

			uint stridehi = 1;
			while ((chi & 0xC0) == 0x80) {
				chi = *--hi;
				stridehi++;
				assert(hi >= lo);
			}
			if (lo == hi)
				break;

			if (stridelo == stridehi) {
				memcpy(tmp.ptr, lo, stridelo);
				memcpy(lo, hi, stridelo);
				memcpy(hi, tmp.ptr, stridelo);
				lo += stridelo;
				hi--;
				continue;
			}

			/* Shift the whole array. This is woefully inefficient
			 */
			memcpy(tmp.ptr, hi, stridehi);
			memcpy(tmplo.ptr, lo, stridelo);
			memmove(lo + stridehi, lo + stridelo , (hi - lo) - stridelo);
			memcpy(lo, tmp.ptr, stridehi);
			memcpy(hi + cast(int) stridehi - cast(int) stridelo, tmplo.ptr, stridelo);

			lo += stridehi;
			hi = hi - 1 + (cast(int) stridehi - cast(int) stridelo);
		}
	}

	Array aaa = *cast(Array*)(&a);
	return aaa;
}

Array _adReverseWchar(wchar[] a) {
	if (a.length > 1) {
		wchar[2] tmp;
		wchar* lo = a.ptr;
		wchar* hi = &a[length - 1];

		while (lo < hi) {
			auto clo = *lo;
			auto chi = *hi;

			if ((clo < 0xD800 || clo > 0xDFFF) &&
			  (chi < 0xD800 || chi > 0xDFFF)) {
				*lo = chi;
				*hi = clo;
				lo++;
				hi--;
				continue;
			}

			int stridelo = 1 + (clo >= 0xD800 && clo <= 0xDBFF);

			int stridehi = 1;
			if (chi >= 0xDC00 && chi <= 0xDFFF) {
				chi = *--hi;
				stridehi++;
				assert(hi >= lo);
			}
			if (lo == hi)
				break;

			if (stridelo == stridehi) {
				int stmp;

				assert(stridelo == 2);
				assert(stmp.sizeof == 2 * (*lo).sizeof);
				stmp = *cast(int*)lo;
				*cast(int*)lo = *cast(int*)hi;
				*cast(int*)hi = stmp;
				lo += stridelo;
				hi--;
				continue;
			}

			/* Shift the whole array. This is woefully inefficient
			 */
			memcpy(tmp.ptr, hi, stridehi * wchar.sizeof);
			memcpy(hi + cast(int) stridehi - cast(int) stridelo, lo, stridelo * wchar.sizeof);
			memmove(lo + stridehi, lo + stridelo , (hi - (lo + stridelo)) * wchar.sizeof);
			memcpy(lo, tmp.ptr, stridehi * wchar.sizeof);

			lo += stridehi;
			hi = hi - 1 + (cast(int) stridehi - cast(int) stridelo);
		}
	}

	Array aaa = *cast(Array*)(&a);
	return aaa;
}

int _adCmpChar(Array a1, Array a2) {
	version (Asm86) {
		asm {
			naked					;

			push	EDI 			;
			push	ESI 			;

			mov    ESI,a1+4[4+ESP]	;
			mov    EDI,a2+4[4+ESP]	;

			mov    ECX,a1[4+ESP]	;
			mov    EDX,a2[4+ESP]	;

			cmp 	ECX,EDX 		;
			jb		GotLength		;

			mov 	ECX,EDX 		;

	GotLength:
			cmp    ECX,4			;
			jb	  DoBytes			;

			// Do alignment if neither is dword aligned
			test	ESI,3			;
			jz	  Aligned			;

			test	EDI,3			;
			jz	  Aligned			;
	DoAlign:
			mov    AL,[ESI] 		; //align ESI to dword bounds
			mov    DL,[EDI] 		;

			cmp    AL,DL			;
			jnz    Unequal			;

			inc    ESI				;
			inc    EDI				;

			test	ESI,3			;

			lea    ECX,[ECX-1]		;
			jnz    DoAlign			;
	Aligned:
			mov    EAX,ECX			;

			// do multiple of 4 bytes at a time

			shr    ECX,2			;
			jz	  TryOdd			;

			repe					;
			cmpsd					;

			jnz    UnequalQuad		;

	TryOdd:
			mov    ECX,EAX			;
	DoBytes:
			// if still equal and not end of string, do up to 3 bytes slightly
			// slower.

			and    ECX,3			;
			jz	  Equal 			;

			repe					;
			cmpsb					;

			jnz    Unequal			;
	Equal:
			mov    EAX,a1[4+ESP]	;
			mov    EDX,a2[4+ESP]	;

			sub    EAX,EDX			;
			pop    ESI				;

			pop    EDI				;
			ret 					;

	UnequalQuad:
			mov    EDX,[EDI-4]		;
			mov    EAX,[ESI-4]		;

			cmp    AL,DL			;
			jnz    Unequal			;

			cmp    AH,DH			;
			jnz    Unequal			;

			shr    EAX,16			;

			shr    EDX,16			;

			cmp    AL,DL			;
			jnz    Unequal			;

			cmp    AH,DH			;
	Unequal:
			sbb    EAX,EAX			;
			pop    ESI				;

			or	   EAX,1			;
			pop    EDI				;

			ret 					;
		}
	}
	else {
		int len;
		int c;

		len = a1.length;
		if (a2.length < len)
			len = a2.length;
		c = memcmp(cast(char *)a1.data, cast(char *)a2.data, len);
		if (!c)
			c = cast(int)a1.length - cast(int)a2.length;
		return c;
	}
}

Array _adReverse(Array a, size_t szelem) {
	if (a.length >= 2) {
		byte*	 tmp;
		byte[16] buffer;

		void* lo = a.data;
		void* hi = a.data + (a.length - 1) * szelem;

		tmp = buffer.ptr;
		if (szelem > 16) {
			version(GNU) {
				tmp = cast(byte*)alloca(szelem);
			}
		}

		for (; lo < hi; lo += szelem, hi -= szelem) {
			memcpy(tmp, lo,  szelem);
			memcpy(lo,	hi,  szelem);
			memcpy(hi,	tmp, szelem);
		}
	}
	return a;
}

int _adEq(Array a1, Array a2, TypeInfo ti) {
	if(a1.length != a2.length)
		return 0;				// not equal

	auto sz = ti.tsize();
	auto p1 = a1.data;
	auto p2 = a2.data;

	if(sz == 1)
		// We should really have a ti.isPOD() check for this
		return (memcmp(p1, p2, a1.length) == 0);

	for(size_t i = 0; i < a1.length; i++) {
		if(!ti.equals(p1 + i * sz, p2 + i * sz))
			return 0;			// not equal
	}

	return 1;					// equal
}

int _adCmp(Array a1, Array a2, TypeInfo ti) {
	//printf("adCmp()\n");
	auto len = a1.length;
	if (a2.length < len)
		len = a2.length;
	auto sz = ti.tsize();
	void *p1 = a1.data;
	void *p2 = a2.data;

	if (sz == 1) {
		// We should really have a ti.isPOD() check for this
		auto c = memcmp(p1, p2, len);
		if (c)
			return c;
	}
	else {
		for (size_t i = 0; i < len; i++) {
			auto c = ti.compare(p1 + i * sz, p2 + i * sz);
			if (c)
				return c;
		}
	}
	if (a1.length == a2.length)
		return 0;
	return (a1.length > a2.length) ? 1 : -1;
}

Array _adSort(Array a, TypeInfo ti) {
	static const uint Qsort_Threshold = 7;

	struct StackEntry {
		byte *l;
		byte *r;
	}

	size_t elem_size = ti.tsize();
	size_t qsort_limit = elem_size * Qsort_Threshold;

	static assert(ubyte.sizeof == 1);
	static assert(ubyte.max == 255);

	StackEntry[size_t.sizeof * 8] stack; // log2( size_t.max )
	StackEntry * sp = stack.ptr;
	byte* lbound = cast(byte *) a.data;
	byte* rbound = cast(byte *) a.data + a.length * elem_size;
	byte* li = void;
	byte* ri = void;

	while (1) {
		if (rbound - lbound > qsort_limit) {
			ti.swap(lbound,
				lbound + (
						  ((rbound - lbound) >>> 1) -
						  (((rbound - lbound) >>> 1) % elem_size)
						  ));

			li = lbound + elem_size;
			ri = rbound - elem_size;

			if (ti.compare(li, ri) > 0)
				ti.swap(li, ri);
			if (ti.compare(lbound, ri) > 0)
				ti.swap(lbound, ri);
			if (ti.compare(li, lbound) > 0)
				ti.swap(li, lbound);

			while (1) {
				do
					li += elem_size;
				while (ti.compare(li, lbound) < 0);
				do
					ri -= elem_size;
				while (ti.compare(ri, lbound) > 0);
if (li > ri)
					break;
				ti.swap(li, ri);
			}
			ti.swap(lbound, ri);
			if (ri - lbound > rbound - li) {
				sp.l = lbound;
				sp.r = ri;
				lbound = li;
			}
			else {
				sp.l = li;
				sp.r = rbound;
				rbound = ri;
			}
			++sp;
		}
		else {
			// Use insertion sort
			for (ri = lbound, li = lbound + elem_size;
				 li < rbound;
				 ri = li, li += elem_size) {
				for ( ; ti.compare(ri, ri + elem_size) > 0;
					  ri -= elem_size) {
					ti.swap(ri, ri + elem_size);
					if (ri == lbound)
						break;
				}
			}
			if (sp != stack.ptr) {
				--sp;
				lbound = sp.l;
				rbound = sp.r;
			}
			else
				return a;
		}
	}
}

