/*
 * precision.d
 *
 * This file implements a multiprecision divide function for non 64-bit
 * systems. This original license for the file used as reference is below.
 * The file originally was located:
 *		http://fxr.watson.org/fxr/source/libkern/qdivrem.c
 * It has been updated for the D programming language and for usage
 * within the XOmB kernel and XOmB Bare Bones packages.
 *
 * Author: Dave Wilkinson, The Regents of the University of California.
 *
 */

module mindrt.precision;

/*-
 * Copyright (c) 1992, 1993
 *      The Regents of the University of California.  All rights reserved.
 *
 * This software was developed by the Computer Systems Engineering group
 * at Lawrence Berkeley Laboratory under DARPA contract BG 91-66 and
 * contributed to Berkeley.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 * 3. All advertising materials mentioning features or use of this software
 *    must display the following acknowledgement:
 *      This product includes software developed by the University of
 *      California, Berkeley and its contributors.
 * 4. Neither the name of the University nor the names of its contributors
 *    may be used to endorse or promote products derived from this software
 *    without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS ``AS IS'' AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED.  IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS BE LIABLE
 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 * SUCH DAMAGE.
 *
 * $FreeBSD: src/sys/libkern/qdivrem.c,v 1.8 1999/08/28 00:46:35 peter Exp $
 * $DragonFly: src/sys/libkern/qdivrem.c,v 1.4 2004/01/26 11:09:44 joerg Exp $
 */

/*
 * Multiprecision divide.  This algorithm is from Knuth vol. 2 (2nd ed),
 * section 4.3.1, pp. 257--259.
 */

//-------------

/*
 * Depending on the desired operation, we view a 64 bit integer (a long)
 * in these particular ways.
 */
union uu {
	long	l;
	ulong	ul;
	int		si[2];
	uint	ui[2];
}

// These are architecture specific, and should be defined in the
// architecture import as a definition sheet.

const size_t LONG_HIGHWORD = 1;
const size_t LONG_LOWWORD = 0;

const size_t BYTE_BITS = 8;

/*
 * Define high and low longwords. (endian-ness)
 */
alias LONG_HIGHWORD H;
alias LONG_LOWWORD L;

/*
 * Total number of bits in a quad_t and in the pieces that make it up.
 * These are used for shifting, and also below for halfword extraction
 * and assembly.
 */
const uint QUAD_BITS	= (8 * BYTE_BITS);
const uint LONG_BITS	= (4 * BYTE_BITS);
const uint HALF_BITS	= (4 * BYTE_BITS / 2);

/*
 * Extract high and low shortwords from longword, and move low shortword of
 * longword to upper half of long, i.e., produce the upper longword of
 * ((quad_t)(x) << (number_of_bits_in_long/2)).  (`x' must actually be u_long.)
 *
 * These are used in the multiply code, to split a longword into upper
 * and lower halves, and to reassemble a product as a quad_t, shifted left
 * (sizeof(long)*CHAR_BIT/2).
 */
uint HHALF(uint x) {
	return x >> HALF_BITS;
}

int LHALF(uint x) {
	return x & ((1 << HALF_BITS) - 1);
}

uint LHUP(uint x) {
	return x << HALF_BITS;
}

typedef uint qshift_t;

/*
quad_t          __ashldi3(quad_t, qshift_t);
quad_t          __ashrdi3(quad_t, qshift_t);
int             __cmpdi2(quad_t a, quad_t b);
quad_t          __divdi3(quad_t a, quad_t b);
quad_t          __lshrdi3(quad_t, qshift_t);
quad_t          __moddi3(quad_t a, quad_t b);
u_quad_t        __qdivrem(u_quad_t u, u_quad_t v, u_quad_t *rem);
u_quad_t        __udivdi3(u_quad_t a, u_quad_t b);
u_quad_t        __umoddi3(u_quad_t a, u_quad_t b);
int             __ucmpdi2(u_quad_t a, u_quad_t b);
*/

// ------------------

// digit base
const uint B = (1 << HALF_BITS);

/* Combine two `digits' to make a single two-digit number. */
uint COMBINE(uint a, uint b) {
	return (a << HALF_BITS) | b;
}

alias uint digit;

/*
 * Shift p[0]..p[len] left `sh' bits, ignoring any bits that
 * `fall out' the left (there never will be any such anyway).
 * We may assume len >= 0.  NOTE THAT THIS WRITES len+1 DIGITS.
 */
void shl(digit* p, int len, int sh) {
	int i;

	for (i = 0; i < len; i++) {
		p[i] = LHALF(p[i] << sh) | (p[i + 1] >> (HALF_BITS - sh));
	}

	p[i] = LHALF(p[i] << sh);
}

/*
 * qdivrem(u, v, rem) returns u/v and, optionally, sets *rem to u%v.
 *
 * We do this in base 2-sup-HALF_BITS, so that all intermediate products
 * fit within u_long.  As a consequence, the maximum length dividend and
 * divisor are 4 `digits' in this base (they are shorter if they have
 * leading zeros).
 */
ulong qdivrem(ulong uq, ulong vq, ulong* arq) {
	uu tmp;

	digit* u;
	digit* v;
	digit* q;

	digit v1, v2;

	uint qhat, rhat, t;

	int m, n, d, j, i;
	digit[5] uspace;
	digit[5] vspace;
	digit[5] qspace;

	/*
	 * Take care of special cases: divide by zero, and u < v.
	 */
	if (vq == 0) {
		/* divide by zero. */
		volatile uint zero;

		tmp.ui[H] = tmp.ui[L] = 1 / zero;
		if (arq)
		{
			*arq = uq;
		}
		return (tmp.l);
	}
	if (uq < vq) {
		if (arq) {
			*arq = uq;
		}
		return (0);
	}
	u = &uspace[0];
	v = &vspace[0];
	q = &qspace[0];

	/*
	 * Break dividend and divisor into digits in base B, then
	 * count leading zeros to determine m and n.  When done, we
	 * will have:
	 *      u = (u[1]u[2]...u[m+n]) sub B
	 *      v = (v[1]v[2]...v[n]) sub B
	 *      v[1] != 0
	 *      1 < n <= 4 (if n = 1, we use a different division algorithm)
	 *      m >= 0 (otherwise u < v, which we already checked)
	 *      m + n = 4
	 * and thus
	 *      m = 4 - n <= 2
	 */
	tmp.ul = uq;
	u[0] = 0;
	u[1] = HHALF(tmp.ui[H]);
	u[2] = LHALF(tmp.ui[H]);
	u[3] = HHALF(tmp.ui[L]);
	u[4] = LHALF(tmp.ui[L]);
	tmp.ul = vq;
	v[1] = HHALF(tmp.ui[H]);
	v[2] = LHALF(tmp.ui[H]);
	v[3] = HHALF(tmp.ui[L]);
	v[4] = LHALF(tmp.ui[L]);
	for (n = 4; v[1] == 0; v++) {
		if (--n == 1) {
			uint rbj;     /* r*B+u[j] (not root boy jim) */
			digit q1, q2, q3, q4;

			/*
			 * Change of plan, per exercise 16.
			 *      r = 0;
			 *      for j = 1..4:
			 *              q[j] = floor((r*B + u[j]) / v),
			 *              r = (r*B + u[j]) % v;
			 * We unroll this completely here.
			 */
			t = v[2];       /* nonzero, by definition */
			q1 = u[1] / t;
			rbj = COMBINE(u[1] % t, u[2]);
			q2 = rbj / t;
			rbj = COMBINE(rbj % t, u[3]);
			q3 = rbj / t;
			rbj = COMBINE(rbj % t, u[4]);
			q4 = rbj / t;
			if (arq)
			        *arq = rbj % t;
			tmp.ui[H] = COMBINE(q1, q2);
			tmp.ui[L] = COMBINE(q3, q4);
			return (tmp.l);
		}
	}

	/*
	 * By adjusting q once we determine m, we can guarantee that
	 * there is a complete four-digit quotient at &qspace[1] when
	 * we finally stop.
	 */
	for (m = 4 - n; u[1] == 0; u++) {
		m--;
	}

	for (i = 4 - m; --i >= 0;) {
		q[i] = 0;
	}

	q += 4 - m;

	/*
	 * Here we run Program D, translated from MIX to C and acquiring
	 * a few minor changes.
	 *
	 * D1: choose multiplier 1 << d to ensure v[1] >= B/2.
	 */

	d = 0;

	for (t = v[1]; t < B / 2; t <<= 1) {
		d++;
	}

	if (d > 0) {
		shl(&u[0], m + n, d);           /* u <<= d */
		shl(&v[1], n - 1, d);           /* v <<= d */
	}

	/*
	 * D2: j = 0.
	 */

	j = 0;
	v1 = v[1];      /* for D3 -- note that v[1..n] are constant */
	v2 = v[2];      /* for D3 */
	do {
		digit uj0, uj1, uj2;

		/*
		 * D3: Calculate qhat (\^q, in TeX notation).
		 * Let qhat = min((u[j]*B + u[j+1])/v[1], B-1), and
		 * let rhat = (u[j]*B + u[j+1]) mod v[1].
		 * While rhat < B and v[2]*qhat > rhat*B+u[j+2],
		 * decrement qhat and increase rhat correspondingly.
		 * Note that if rhat >= B, v[2]*qhat < rhat*B.
		 */
		uj0 = u[j + 0]; /* for D3 only -- note that u[j+...] change */
		uj1 = u[j + 1]; /* for D3 only */
		uj2 = u[j + 2]; /* for D3 only */

		if (uj0 == v1) {
	        qhat = B;
	        rhat = uj1;
	        goto qhat_too_big;
		} else {
			uint nn = COMBINE(uj0, uj1);
			qhat = nn / v1;
			rhat = nn % v1;
		}

		while (v2 * qhat > COMBINE(rhat, uj2)) {

qhat_too_big:

			qhat--;
			if ((rhat += v1) >= B) {
				break;
			}
		}

		/*
		 * D4: Multiply and subtract.
		 * The variable `t' holds any borrows across the loop.
		 * We split this up so that we do not require v[0] = 0,
		 * and to eliminate a final special case.
		 */

		for (t = 0, i = n; i > 0; i--) {
			t = u[i + j] - v[i] * qhat - t;
			u[i + j] = LHALF(t);
			t = (B - HHALF(t)) & (B - 1);
		}
		t = u[j] - t;
		u[j] = LHALF(t);
		/*
		 * D5: test remainder.
		 * There is a borrow if and only if HHALF(t) is nonzero;
		 * in that (rare) case, qhat was too large (by exactly 1).
		 * Fix it by adding v[1..n] to u[j..j+n].
		 */
		if (HHALF(t)) {
			qhat--;
			for (t = 0, i = n; i > 0; i--) { /* D6: add back. */
			        t += u[i + j] + v[i];
			        u[i + j] = LHALF(t);
			        t = HHALF(t);
			}
			u[j] = LHALF(u[j] + t);
		}
		q[j] = qhat;
	} while (++j <= m);             /* D7: loop on j. */

	/*
	 * If caller wants the remainder, we have to calculate it as
	 * u[m..m+n] >> d (this is at most n digits and thus fits in
	 * u[m+1..m+n], but we may need more source digits).
	 */
	if (arq) {
		if (d) {
			for (i = m + n; i > m; --i) {
				u[i] = (u[i] >> d) | LHALF(u[i - 1] << (HALF_BITS - d));
			}
			u[i] = 0;
		}

		tmp.ui[H] = COMBINE(uspace[1], uspace[2]);
		tmp.ui[L] = COMBINE(uspace[3], uspace[4]);
		*arq = tmp.l;
	}

	tmp.ui[H] = COMBINE(qspace[1], qspace[2]);
	tmp.ui[L] = COMBINE(qspace[3], qspace[4]);
	return (tmp.l);
}

// Return 0, 1, or 2 as a <, =, > b respectively.
// Neither a nor b are considered signed.
int ucmpdi2(ulong a, ulong b) {
	uu aa, bb;

	aa.ul = a;
	bb.ul = b;
	return (aa.ui[H] < bb.ui[H] ? 0 : aa.ui[H] > bb.ui[H] ? 2 :
			aa.ui[L] < bb.ui[L] ? 0 : aa.ui[L] > bb.ui[L] ? 2 : 1);
}

extern(C) int __ucmpdi2(ulong a, ulong b) {
	return ucmpdi2(a,b);
}

// Divide two unsigned longs
ulong udivdi3(ulong a, ulong b) {
	return qdivrem(a, b, null);
}

extern(C) ulong __udivdi3(ulong a, ulong b) {
	return udivdi3(a,b);
}

// Modulus two unsigned longs
ulong umoddi3(ulong a, ulong b) {
	ulong r;
	qdivrem(a, b, &r);
	return r;
}

extern(C) ulong __umoddi3(ulong a, ulong b) {
	return umoddi3(a,b);
}

// Logical shift right of an unsigned long
long lshrdi3(long a, qshift_t shift) {
	uu aa;

	aa.l = a;
	if (shift >= LONG_BITS) {
		aa.ui[L] = shift >= QUAD_BITS ? 0 :
			aa.ui[H] >> (shift - LONG_BITS);
		aa.ui[H] = 0;
	}
	else if (shift > 0) {
		aa.ui[L] = (aa.ui[L] >> shift) |
			(aa.ui[H] << (LONG_BITS - shift));
		aa.ui[H] >>= shift;
	}

	return aa.l;
}

extern(C) long __lshrdi3(long a, qshift_t shift) {
	return lshrdi3(a, shift);
}

// Arithmetic Shift Left of a signed long
// A.K.A. Logical Shift Left
long ashldi3(long a, qshift_t shift) {
	uu aa;

	aa.l = a;
	if (shift >= LONG_BITS) {
		aa.ui[H] = shift >= QUAD_BITS ? 0 :
			aa.ui[L] << (shift - LONG_BITS);
		aa.ui[L] = 0;
	}
	else if (shift > 0) {
		aa.ui[H] = (aa.ui[H] << shift) |
			(aa.ui[L] >> (LONG_BITS - shift));
		aa.ui[L] <<= shift;
	}

	return aa.l;
}

extern(C) long __ashldi3(long a, qshift_t shift) {
	return ashldi3(a, shift);
}

// Arithmetic Shift Right of a signed long
long ashrdi3(long a, qshift_t shift) {
	uu aa;

	aa.l = a;
	if (shift >= LONG_BITS) {
		int s;

		/* Smear bits rightward using the machine's right-shift method,
		   whether that is sign extension or zero fill, to get the
		   'sign word' s. Note that shifting by LONG_BITS is
		   undefined, so we shift (LONG_BITS-1), then 1 more, to get
		   our answer */

		s = (aa.si[H] >> (LONG_BITS - 1)) >> 1;
		aa.ui[L] = shift >= QUAD_BITS ? s :
			aa.si[H] >> (shift - LONG_BITS);
		aa.ui[H] = s;
	} else if (shift > 0) {
		aa.ui[L] = (aa.ui[L] >> shift) |
			(aa.ui[H] << (LONG_BITS - shift));
		aa.si[H] >>= shift;
	}

	return aa.l;
}

extern(C) long __ashrdi3(long a, qshift_t shift) {
	return ashrdi3(a,shift);
}

// Return 0, 1, or 2 as a <, =, > b respectively.
// Both a and b are considered signed -- which means only
// the high word is signed.
int cmpdi2(long a, long b) {
	uu aa, bb;

	aa.l = a;
	bb.l = b;

	return (aa.si[H] < bb.si[H] ? 0 : aa.si[H] > bb.si[H] ? 2 :
			aa.ui[L] < bb.ui[L] ? 0 : aa.ui[L] > bb.ui[L] ? 2 : 1);
}

extern(C) int __cmpdi2(long a, long b) {
	return cmpdi2(a,b);
}

// Divide two signed longs
long divdi3(long a, long b) {
	ulong ua, ub, ul;
	int neg;

	if (a < 0) {
		ua = -cast(ulong)a;
		neg = 1;
	}
	else {
		ua = a;
		neg = 0;
	}

	if (b < 0) {
		ub = -cast(ulong)b;
		neg ^= 1;
	}
	else {
		ub = b;
	}

	ul = qdivrem(ua, ub, null);
	return (neg ? -ul : ul);
}

extern(C) long __divdi3(long a, long b) {
	return divdi3(a,b);
}

// Modulus two signed longs
long moddi3(long a, long b) {
	ulong ua, ub, ur;
	int neg;

	if (a < 0) {
		ua = -cast(ulong)a;
		neg = 1;
	}
	else {
		ua = a;
		neg = 0;
	}

	if (b < 0) {
		ub = -cast(ulong)b;
	}
	else {
		ub = b;
	}

	qdivrem(ua, ub, &ur);
	return (neg ? -ur : ur);
}

extern(C) long __moddi3(long a, long b) {
	return moddi3(a,b);
}
