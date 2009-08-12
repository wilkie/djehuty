module specs.hashes.md5;

import testing.support;

import hashes.md5;

describe MD5() {
	describe hash() {
		it should_hash_as_expected_for_String_objects() {
			String s = HashMD5.hash(new String("String you wish to hash")).getString();
			should(s == "b262eb2435f39440672348388746115f");
		}

		it should_hash_as_expected_for_string_literals() {
			String s = HashMD5.hash("Hashing Hashing Hashing").getString();
			should(s == "7ba85cd90a910d790172b15e895f8e56");
		}

		it should_respect_leading_zeroes() {
			// Testing: leading 0s on parts, note that there is a 0 on the 9th value from the left
			String s = HashMD5.hash("d").getString();
			should(s == "8277e0910d750195b448797616e091ad");
		}

		it should_work_on_byte_arrays() {
			// Testing a classic MD5 Collision
			ubyte[] filea = cast(ubyte[])import("testmd5a.bin");
			ubyte[] fileb = cast(ubyte[])import("testmd5b.bin");

			String a = HashMD5.hash(filea).getString();
			String b = HashMD5.hash(fileb).getString();

			should(a == b);
			should(a == "da5c61e1edc0f18337e46418e48c1290");
		}
	}
}
