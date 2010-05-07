module specs.hashes.sha1;

import testing.support;

import hashes.sha1;

describe SHA1() {
	describe hash() {
		it should_hash_as_expected_for_string_literals() {
			string s = HashSHA1.hash("a").toString();
			should(s == "86f7e437faa5a7fce15d1ddcb9eaeaea377667b8");
		}

		it should_hash_the_empty_string() {
			string s = HashSHA1.hash("").toString();
			should(s == "da39a3ee5e6b4b0d3255bfef95601890afd80709");
		}
	}
}
