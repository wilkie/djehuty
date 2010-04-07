module specs.hashes.sha224;

import testing.support;

import hashes.sha224;

describe SHA224() {
	describe hash() {
		it should_hash_as_expected_for_string_literals() {
			string s = HashSHA224.hash("a").toString();
			should(s == "abd37534c7d9a2efb9465de931cd7055ffdb8879563ae98078d6d6d5");
		}

		it should_hash_the_empty_string() {
			string s = HashSHA224.hash("").toString();
			should(s == "d14a028c2a3a2bc9476102bb288234c415a2b01f828ea62ac5b3e42f");
		}
	}
}
