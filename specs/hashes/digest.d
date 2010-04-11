module specs.hashes.digest;

import testing.support;

import hashes.digest;

describe digest() {
	describe creation() {
		it should_allow_for_64_bits() {
			Digest d = new Digest(0xDEADBEEF, 0x01234567);
			string s = d.toString();

			should(s == "deadbeef01234567");
		}

		it should_allow_for_128_bits() {
			Digest d = new Digest(0xDEADBEEF, 0x01234567, 0xDEADBEEF, 0x01234567);
			string s = d.toString();

			should(s == "deadbeef01234567deadbeef01234567");
		}

		it should_allow_for_160_bits() {
			Digest d = new Digest(0xDEADBEEF, 0x01234567, 0xDEADBEEF, 0x01234567, 0xDEADBEEF);
			string s = d.toString();

			should(s == "deadbeef01234567deadbeef01234567deadbeef");
		}

		it should_allow_for_192_bits() {
			Digest d = new Digest(0xDEADBEEF, 0x01234567, 0xDEADBEEF, 0x01234567, 0xDEADBEEF, 0x01234567);
			string s = d.toString();

			should(s == "deadbeef01234567deadbeef01234567deadbeef01234567");
		}
	}

	describe comparison() {
		it should_work_for_equals_overload() {
			Digest d1 = new Digest(0xDEADBEEF);
			Digest d2 = new Digest(0x01234567);
			Digest d3 = new Digest(0xDEADBEEF);

			should(d1 == d3);
			shouldNot(d1 == d2);
		}

		it should_work_for_equals_function() {
			Digest d1 = new Digest(0xDEADBEEF);
			Digest d2 = new Digest(0x01234567);
			Digest d3 = new Digest(0xDEADBEEF);

			should(d1.equals(d3));
			shouldNot(d1.equals(d2));
		}
	}
}
