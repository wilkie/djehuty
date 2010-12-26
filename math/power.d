module math.power;

class Power {
static:
private:

public:

	int sqrt(int x) {
		float temp;
		float z, y, rr;

		int ret;

		rr = x;
		y = rr * 0.5;
		*cast(uint*)&temp = (0xbe6f0000 - *cast(uint*)&rr) >> 1;
		z = temp;
		z = (1.5 * z) - (z * z) * (z * y);

		// Do another round for extra precision
		if (x > 101123) {
			z = (1.5 * z) - (z * z) * (z * y);
		}

		ret = cast(int)((z * rr) + 0.5);
		ret += (x - (ret * ret)) >> 31;

		return ret;
	}

	double sqrt(double x) {
		double y, z, temp;

		temp = x;
		uint* ptr = (cast(uint*)&temp) + 1;

		// Use an estimate for 1 / sqrt(x)
		*ptr = (0xbfcdd90a - *ptr) >> 1;

		y = temp;

		// Newton Approximation
		z = x * 0.5;	// 1/2

		// 5 iterations are enough for 64 bits
		y = (1.5 * y) - (y*y) * (y*z);
		y = (1.5 * y) - (y*y) * (y*z);
		y = (1.5 * y) - (y*y) * (y*z);
		y = (1.5 * y) - (y*y) * (y*z);
		y = (1.5 * y) - (y*y) * (y*z);

		// Return the result
		return x * y;
	}
}
