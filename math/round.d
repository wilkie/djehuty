module math.round;

class Round {
static:
private:

	static const double huge = 1.0e300;

	version (BigEndian) {
		static const int highWord = 0;
		static const int lowWord = 1;
	}
	else {
		static const int highWord = 1;
		static const int lowWord = 0;
	}

public:

	int nearest(int x) {
		return x;
	}

	double nearest(double x) {
		return floor(x + 0.5);
	}

	int ceiling(int x) {
		return x;
	}

	double ceiling(double x) {
		int i0,i1,j0;
		uint i,j;

		uint * xptr = cast(uint *) & x;
		i0 = xptr[highWord];
		i1 = xptr[lowWord];

		j0 = ((i0 >> 20) & 0x7ff) - 0x3ff;
		if (j0 < 20) {
			if (j0 < 0) {  
				// Raise inexact if x != 0 
				if (huge + x > 0.0) { 
					// Return 0 * sign(x) if |x| < 1 
					if (i0 < 0) {
						i0 = 0x80000000;
						i1 = 0;
					}
					else if ((i0 | i1) != 0) { 
						i0 = 0x3ff00000;
						i1 = 0;
					}
				}
			} 
			else {
				i = (0x000fffff) >> j0;

				if (((i0 & i) | i1) == 0) {
					// x is integral
					return x; 
				}

				if (huge + x > 0.0) {
					// raise inexact flag 

					if (i0 > 0) {
						i0 += (0x00100000) >> j0;
					}

					i0 &= ~i; 
					i1 = 0;
				}
			}
		} 
		else if (j0 > 51) {
			if (j0 == 0x400) {
				// inf or NaN
				return x + x;   
			}
			else {
				// x is integral
				return x;      
			}
		} 
		else {
			i = (cast(uint)(0xffffffff)) >> (j0 - 20);

			if ((i1 & i) == 0) {
				// x is integral
				return x; 
			}

			if (huge + x > 0.0) {        
				// Raise inexact flag

				if (i0 > 0) {
					if (j0 == 20) {
						i0 += 1;
					}
					else {
						j = i1 + (1 << (52 - j0));

						if (j < i1) {
							// got a carry
							i0 += 1; 
						}

						i1 = j;
					}
				}

				i1 &= ~i;
			}
		}

		xptr[highWord] = i0;
		xptr[lowWord] = i1;

		return x;
	}

	int floor(int x) {
		return x;
	}

	double floor(double x) {
		int i0,i1,j0;
		uint i,j;

		uint * xptr = cast(uint *) & x;
		i0 = xptr[highWord];
		i1 = xptr[lowWord];

		j0 = ((i0 >> 20) & 0x7ff) - 0x3ff;
		if (j0 < 20) {
			if (j0 < 0) {  
				 // Raise inexact if x ! = 0 
				if (huge + x > 0.0) { 
					 // Return 0 * sign(x) if | x | < 1
					if (i0 >= 0) {
						i0 = i1 = 0;
					}
					else if (((i0 & 0x7fffffff) | i1) != 0) {
						i0 = 0xbff00000;
						i1 = 0;
					}
				}
			} 
			else {
				i = (0x000fffff) >> j0;

				if (((i0 & i) | i1) == 0) {
					 // x is integral
					return x; 
				}


				if (huge + x > 0.0) {    
					 // Raise inexact flag
					if (i0 < 0) {
						i0 += (0x00100000) >> j0;
					}

					i0 &= ~i;
					i1 = 0;
				}
			}
		} 
		else if (j0 > 51) {
			if (j0 == 0x400) {
				return x + x;   /* inf or NaN */
			}
			else {
				return x;      /* x is integral */
			}
		} 
		else {
			i = (cast(uint)(0xffffffff)) >> (j0 - 20);

			if ((i1 & i) == 0) {
				return x; // x is integral 
			}

			if (huge + x > 0.0) {        
				 // Raise inexact flag 
				if (i0 < 0) {
					if (j0 == 20) {
						i0 += 1;
					}
					else {
						j = i1 + (1 << (52 - j0));

						if (j < i1) {
							 // Got a carry 
							i0 += 1 ;   
						}

						i1 = j;
					}
				}

				i1 &= ~i;
			}
		}

		xptr[highWord] = i0;
		xptr[lowWord] = i1;

		return x;
	}
}
