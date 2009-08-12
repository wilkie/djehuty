module specs.hashes.sha256;

import testing.support;

import hashes.sha256;

describe SHA256() {
	describe hash() {
		it should_hash_as_expected_for_String_objects() {
			String s = HashSHA256.hash(new String("The quick brown fox jumps over the lazy dog")).getString();
			should(s == "d7a8fbb307d7809469ca9abcb0082e4f8d5651e46d3cdb762d02d0bf37c9e592");
		}

		it should_hash_as_expected_for_string_literals() {
			String s = HashSHA256.hash("a").getString();
			should(s == "ca978112ca1bbdcafac231b39a23dc4da786eff8147c4e72b9807785afee48bb");
		}

		it should_hash_the_empty_string() {
			String s = HashSHA256.hash(new String("")).getString();
			should(s == "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855");
		}
	}
}
