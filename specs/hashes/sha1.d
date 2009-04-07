module specs.hashes.sha1;

import testing.support;

import hashes.sha1;

describe SHA1()
{
	describe hash()
	{
		it should_hash_as_expected_for_String_objects()
		{
			String s = HashSHA1.hash(new String("The quick brown fox jumps over the lazy dog")).getString();
			should(s == "2fd4e1c67a2d28fced849ee1bb76e7391b93eb12");
		}

		it should_hash_as_expected_for_string_literals()
		{
			String s = HashSHA1.hash("a").getString();
			should(s == "86f7e437faa5a7fce15d1ddcb9eaeaea377667b8");
		}

		it should_hash_the_empty_string()
		{
			String s = HashSHA1.hash(new String("")).getString();
			should(s == "da39a3ee5e6b4b0d3255bfef95601890afd80709");
		}
	}
}
