module specs.hashes.sha224;

import testing.support;

import hashes.sha224;

describe SHA224()
{
	describe hash()
	{
		it should_hash_as_expected_for_String_objects()
		{
			String s = HashSHA224.hash(new String("The quick brown fox jumps over the lazy dog")).getString();
			should(s == "730e109bd7a8a32b1cb9d9a09aa2325d2430587ddbc0c38bad911525");
		}

		it should_hash_as_expected_for_string_literals()
		{
			String s = HashSHA224.hash("a").getString();
			should(s == "abd37534c7d9a2efb9465de931cd7055ffdb8879563ae98078d6d6d5");
		}

		it should_hash_the_empty_string()
		{
			String s = HashSHA224.hash(new String("")).getString();
			should(s == "d14a028c2a3a2bc9476102bb288234c415a2b01f828ea62ac5b3e42f");
		}
	}
}
