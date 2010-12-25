module math.sign;

class Sign {
static:
public:

	double abs(double x) {
		ulong intRepresentation = *cast(ulong*)&x;
		intRepresentation &= 0x7fff_ffff_ffff_ffff;
		return *cast(double*)&intRepresentation;
	}

	float abs(float x) {
		uint intRepresentation = *cast(uint*)&x;
		intRepresentation &= 0x7fff_ffff;
		return *cast(float*)&intRepresentation;
	}

	long abs(long x) {
		if (x < 0) {
			return -x;
		}
		return x;
	}
}
