module specs.hashes.sha256;

import testing.support;

import hashes.sha256;

describe SHA256() {
	describe hash() {
		it should_hash_as_expected_for_string_literals() {
			string s = HashSHA256.hash("a").toString();
			should(s == "ca978112ca1bbdcafac231b39a23dc4da786eff8147c4e72b9807785afee48bb");
		}

		it should_hash_the_empty_string() {
			string s = HashSHA256.hash("").toString();
			should(s == "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855");
		}
	}
}
