module math.log;

class Log {
static:
private:

	static const double zero = 0.0;

	/* 3fe62e42 fee00000 */
	static const double ln2_hi =  6.93147180369123816490e-01;

	/* 3dea39ef 35793c76 */
	static const double ln2_lo =  1.90821492927058770002e-10;  

	/* 43500000 00000000 */
	static const double two54  =  1.80143985094819840000e+16;  

	/* 3FE55555 55555593 */
	static const double Lg1    = 6.666666666666735130e-01;  

	/* 3FD99999 9997FA04 */
	static const double Lg2    = 3.999999999940941908e-01;  

	/* 3FD24924 94229359 */
	static const double Lg3    = 2.857142874366239149e-01;  

	/* 3FCC71C5 1D8E78AF */
	static const double Lg4    = 2.222219843214978396e-01;  

	/* 3FC74664 96CB03DE */
	static const double Lg5    = 1.818357216161805012e-01;  

	/* 3FC39A09 D078C69F */
	static const double Lg6    = 1.531383769920937332e-01;  

	/* 3FC2F112 DF3E5244 */
	static const double Lg7    = 1.479819860511658591e-01;  

	/* 0x3FDBCB7B, 0x1526E50E */
	static const double ivln10     =  4.34294481903251816668e-01; 

	/* 0x3FD34413, 0x509F6000 */
	static const double log10_2hi  =  3.01029995663611771306e-01; 

	/* 0x3D59FEF3, 0x11F12B36 */
	static const double log10_2lo  =  3.69423907715893078616e-13; 
 
	version (BigEndian) {
		static const int highWord = 0;
		static const int lowWord = 1;
	}
	else {
		static const int highWord = 1;
		static const int lowWord = 0;
	}

public:

	double base10(double x) {
		double y,z;
		int i,k,hx;
		uint lx;

		uint* ptr = cast(uint*)&x;
		hx = cast(int)ptr[highWord];
		lx = ptr[lowWord];

		k = 0;
		if (hx < 0x00100000) {                  /* x < 2**-1022  */
			if (((hx & 0x7fffffff) | lx) == 0) {
				return -two54/zero;             /* log(+-0)=-inf */
			}

			if (hx < 0) {
				return (x - x) / zero;        /* log(-#) = NaN */
			}

			k -= 54;
			x *= two54; /* subnormal number, scale up x */

			hx = cast(int)ptr[highWord];
		}

		if (hx >= 0x7ff00000) {
			return x + x;
		}

		k += (hx >> 20) - 1023;
		i = (cast(uint)k & 0x80000000) >> 31;
		hx = (hx & 0x000fffff) | ((0x3ff - i) << 20);
		y = cast(double)(k + i);

		ptr[highWord] = hx;

		z = y * log10_2lo + ivln10 * baseE(x);
		return z + y * log10_2hi;
	}

	double base2(double x) {
		return base10(x) / base10(2);
	}

	double baseX(double base, double x) {
		if (base == 10) {
			return base10(x);
		}
		return base10(x) / base10(base);
	}

	double baseE(double x) {
		double hfsq,f,s,z,R,w,t1,t2,dk;
		int k,hx,i,j;
		uint lx;

		uint* ptr = cast(uint*)&x;
		hx = cast(int)ptr[highWord];
		lx = ptr[lowWord];

		k=0;
		if (hx < 0x00100000) {          /* x < 2**-1022  */
			if (((hx&0x7fffffff) | lx) == 0) {
				return -two54 / zero;     /* log(+-0)=-inf */
			}

			if (hx<0) {
				return (x - x) / zero;    /* log(-#) = NaN */
			}

			k -= 54; x *= two54; /* subnormal number, scale up x */

			hx = cast(int)ptr[highWord];
		}

		if (hx >= 0x7ff00000) {
			return x + x;
		}

		k += (hx >> 20) - 1023;
		hx &= 0x000fffff;
		i = (hx + 0x95f64) & 0x100000;

		ptr[highWord] = (hx | (i ^ 0x3ff00000));

		k += (i >> 20);
		f = x - 1.0;

		if ((0x000fffff & (2 + hx)) < 3) { /* |f| < 2**-20 */
			if (f == zero) {
				if (k == 0) {
					return zero;
				}
				else {
					dk = cast(double)k;
					return dk * ln2_hi + dk * ln2_lo;
				}
			}
			R = f * f * (0.5 - 0.33333333333333333 * f);
			if (k == 0) {
				return f - R;
			}
			else {
				dk = cast(double)k;
				return dk * ln2_hi - ((R - dk * ln2_lo) - f);
			}
		}

		s = f / (2.0 + f);
		dk = cast(double)k;
		z = s * s;
		i = hx - 0x6147a;
		w = z * z;
		j = 0x6b851 - hx;
		t1 = w * (Lg2 + w * (Lg4 + w * Lg6));
		t2 = z * (Lg1 + w * (Lg3 + w * (Lg5 + w * Lg7)));
		i |= j;
		R = t2 + t1;
		if (i > 0) {
			hfsq = 0.5 * f * f;
			if(k==0) {
				return f - (hfsq - s * (hfsq + R));
			}
			else {
				return dk * ln2_hi - ((hfsq - (s * (hfsq + R) + dk * ln2_lo)) - f);
			}
		}
		else {
			if (k == 0) {
				return f - s * (f - R);
			}
			else {
				return dk * ln2_hi - ((s * (f - R) - dk * ln2_lo) - f);
			}
		}
    }

	int base2Star(double x) {
		int i = 0;

		for (i = 0; x > 1; i++) {
			x = base2(x);
		}

		return i;
	}

	int baseEStar(double x) {
		int i = 0;

		for (i = 0; x > 1; i++) {
			x = baseE(x);
		}

		return i;
	}

	int baseXStar(double base, double x) {
		int i = 0;

		for (i = 0; x > 1; i++) {
			x = baseX(base, x);
		}

		return i;
	}

	int base10Star(double x) {
		int i = 0;

		for (i = 0; x > 1; i++) {
			x = base10(x);
		}

		return i;
	}
}
