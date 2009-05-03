
/*
 * test.d
 *
 * Tests the specifications defined and parsed by dspec
 *
 */

module specs.test;

import testing.logic;

import core.string;

class StringTester
{
	
		it creation_should_handle_literals()
	{before_creation();
try
{
			String str = new String("new string");
			if(!(str == "new string"))
	{
		return it.doesnt;
	}

		}catch(Exception _exception_)
{
	return it.doesnt;
}
	return it.does;
	}
		it creation_should_handle_integers()
	{before_creation();
try
{
			String str = new String(123);
			if(!(str == "123"))
	{
		return it.doesnt;
	}

		}catch(Exception _exception_)
{
	return it.doesnt;
}
	return it.does;
	}
		it creation_should_handle_formatting()
	{before_creation();
try
{
			String str = new String("%x%d!!!", 0xdead, 1234);
			if(!(str == "dead1234!!!"))
	{
		return it.doesnt;
	}

		}catch(Exception _exception_)
{
	return it.doesnt;
}
	return it.does;
	}
		it creation_should_handle_string_objects()
	{before_creation();
try
{
			String str = new String("hello");
			String str2 = new String(str);
			if(!(str == "hello"))
	{
		return it.doesnt;
	}

		}catch(Exception _exception_)
{
	return it.doesnt;
}
	return it.does;
	}	done before_creation() { }

	
		it trim_should_trim_off_whitespace()
	{before_trim();
try
{
			String str = new String("    \t\t bah \n\n\r\t");
			str = str.trim();
			if(!(str == "bah"))
	{
		return it.doesnt;
	}

		}catch(Exception _exception_)
{
	return it.doesnt;
}
	return it.does;
	}	done before_trim() { }

	
		it length_should_account_for_combining_marks()
	{before_length();
try
{
			String str = new String("hello\u0364world");
			if(!(str.length == 10))
	{
		return it.doesnt;
	}

		}catch(Exception _exception_)
{
	return it.doesnt;
}
	return it.does;
	}
		it length_should_return_the_number_of_characters()
	{before_length();
try
{
			String str = new String("hello world");
			if(!(str.length == 11))
	{
		return it.doesnt;
	}

		}catch(Exception _exception_)
{
	return it.doesnt;
}
	return it.does;
	}
		it length_should_not_fail_on_an_empty_string()
	{before_length();
try
{
			String str = new String("");
			if(!(str.length == 0))
	{
		return it.doesnt;
	}

		}catch(Exception _exception_)
{
	return it.doesnt;
}
	return it.does;
	}	done before_length() { }

	
		it append_should_concatenate_a_string_object()
	{before_append();
try
{
			String str = new String("hello ");
			String str2 = new String("world");

			str.append(str2);

			if(!(str == "hello world"))
	{
		return it.doesnt;
	}

		}catch(Exception _exception_)
{
	return it.doesnt;
}
	return it.does;
	}
		it append_should_concatenate_a_string_literal()
	{before_append();
try
{
			String str = new String("hello ");
			str.append("world");

			if(!(str == "hello world"))
	{
		return it.doesnt;
	}

		}catch(Exception _exception_)
{
	return it.doesnt;
}
	return it.does;
	}
		it append_should_concatenate_a_formatted_string_literal()
	{before_append();
try
{
			String str = new String("hello ");
			str.append("%x%d!!!", 0xdead, 1234);

			if(!(str == "hello dead1234!!!"))
	{
		return it.doesnt;
	}

		}catch(Exception _exception_)
{
	return it.doesnt;
}
	return it.does;
	}
		it append_should_not_fail_on_an_empty_string_object()
	{before_append();
try
{
			String str = new String("hello ");
			String str2 = new String("");
			str.append(str2);

			if(!(str == "hello "))
	{
		return it.doesnt;
	}

		}catch(Exception _exception_)
{
	return it.doesnt;
}
	return it.does;
	}
		it append_should_not_fail_on_an_empty_string_literal()
	{before_append();
try
{
			String str = new String("hello ");
			str.append("");

			if(!(str == "hello "))
	{
		return it.doesnt;
	}

		}catch(Exception _exception_)
{
	return it.doesnt;
}
	return it.does;
	}
		it append_should_throw_an_exception_for_null_string_object()
	{before_append();
try
{
			

			String str = new String("hello ");
			String str2;

			str.append(str2);
		}catch(Exception _exception_)
{
	if (_exception_.msg != "Access Violation") { return it.doesnt; } return it.does;
}
	return it.does;
	}	done before_append() { }

	
		it toLowercase_should_work_as_expected()
	{before_toLowercase();
try
{
			String str = new String("HelLo WoRLD");
			str = str.toLowercase();

			if(!(str == "hello world"))
	{
		return it.doesnt;
	}

		}catch(Exception _exception_)
{
	if (_exception_.msg != "Access Violation") { return it.doesnt; } return it.does;
}
	return it.does;
	}
		it toLowercase_should_not_fail_on_an_empty_string()
	{before_toLowercase();
try
{
			String str = new String("");
			str = str.toLowercase();

			if(!(str == ""))
	{
		return it.doesnt;
	}

		}catch(Exception _exception_)
{
	if (_exception_.msg != "Access Violation") { return it.doesnt; } return it.does;
}
	return it.does;
	}	done before_toLowercase() { }

	
		it toUppercase_should_work_as_expected()
	{before_toUppercase();
try
{
			String str = new String("HelLo WoRLD");
			str = str.toUppercase();

			if(!(str == "HELLO WORLD"))
	{
		return it.doesnt;
	}

		}catch(Exception _exception_)
{
	if (_exception_.msg != "Access Violation") { return it.doesnt; } return it.does;
}
	return it.does;
	}
		it toUppercase_should_not_fail_on_an_empty_string()
	{before_toUppercase();
try
{
			String str = new String("");
			str = str.toUppercase();

			if(!(str == ""))
	{
		return it.doesnt;
	}

		}catch(Exception _exception_)
{
	if (_exception_.msg != "Access Violation") { return it.doesnt; } return it.does;
}
	return it.does;
	}	done before_toUppercase() { }
done before() { }

this() { before(); }


	static void test()
	{
		StringTester tester = new StringTester();

		Test test = new Test("String");

		it result;

		test.logSubset("creation");

		tester = new StringTester();

		result = tester.creation_should_handle_literals();
		test.logResult(result, "creation should handle literals", "11");

		tester = new StringTester();

		result = tester.creation_should_handle_integers();
		test.logResult(result, "creation should handle integers", "17");

		tester = new StringTester();

		result = tester.creation_should_handle_formatting();
		test.logResult(result, "creation should handle formatting", "23");

		tester = new StringTester();

		result = tester.creation_should_handle_string_objects();
		test.logResult(result, "creation should handle string objects", "29");

		test.logSubset("trim");

		tester = new StringTester();

		result = tester.trim_should_trim_off_whitespace();
		test.logResult(result, "trim should trim off whitespace", "39");

		test.logSubset("length");

		tester = new StringTester();

		result = tester.length_should_account_for_combining_marks();
		test.logResult(result, "length should account for combining marks", "49");

		tester = new StringTester();

		result = tester.length_should_return_the_number_of_characters();
		test.logResult(result, "length should return the number of characters", "55");

		tester = new StringTester();

		result = tester.length_should_not_fail_on_an_empty_string();
		test.logResult(result, "length should not fail on an empty string", "61");

		test.logSubset("append");

		tester = new StringTester();

		result = tester.append_should_concatenate_a_string_object();
		test.logResult(result, "append should concatenate a string object", "70");

		tester = new StringTester();

		result = tester.append_should_concatenate_a_string_literal();
		test.logResult(result, "append should concatenate a string literal", "80");

		tester = new StringTester();

		result = tester.append_should_concatenate_a_formatted_string_literal();
		test.logResult(result, "append should concatenate a formatted string literal", "88");

		tester = new StringTester();

		result = tester.append_should_not_fail_on_an_empty_string_object();
		test.logResult(result, "append should not fail on an empty string object", "96");

		tester = new StringTester();

		result = tester.append_should_not_fail_on_an_empty_string_literal();
		test.logResult(result, "append should not fail on an empty string literal", "105");

		tester = new StringTester();

		result = tester.append_should_throw_an_exception_for_null_string_object();
		test.logResult(result, "append should throw an exception for null string object", "113");

		test.logSubset("toLowercase");

		tester = new StringTester();

		result = tester.toLowercase_should_work_as_expected();
		test.logResult(result, "toLowercase should work as expected", "126");

		tester = new StringTester();

		result = tester.toLowercase_should_not_fail_on_an_empty_string();
		test.logResult(result, "toLowercase should not fail on an empty string", "134");

		test.logSubset("toUppercase");

		tester = new StringTester();

		result = tester.toUppercase_should_work_as_expected();
		test.logResult(result, "toUppercase should work as expected", "145");

		tester = new StringTester();

		result = tester.toUppercase_should_not_fail_on_an_empty_string();
		test.logResult(result, "toUppercase should not fail on an empty string", "153");

	
	}
}import core.unicode;

import core.string;

class UnicodeTester
{
	StringLiteral32 utf32 = "hello\u015Bworld";
	StringLiteral16 utf16 = "hello\u015Bworld";
	StringLiteral8 utf8 = "hello\u015Bworld";

	StringLiteral32 utf32marks = "hello\u0364world";
	StringLiteral16 utf16marks = "hello\u0364world";
	StringLiteral8 utf8marks = "hello\u0364world";

	StringLiteral32 empty32 = "";
	StringLiteral16 empty16 = "";
	StringLiteral8 empty8 = "";

	
		it utflen_should_be_the_same_for_utf8_as_utf32()
	{before_utflen();
try
{
			uint length = Unicode.utflen(utf8);
			uint compare = Unicode.utflen(utf32);
			if(!(length == compare))
	{
		return it.doesnt;
	}

		}catch(Exception _exception_)
{
	if (_exception_.msg != "Access Violation") { return it.doesnt; } return it.does;
}
	return it.does;
	}
		it utflen_should_be_the_same_for_utf16_as_utf32()
	{before_utflen();
try
{
			uint length = Unicode.utflen(utf16);
			uint compare = Unicode.utflen(utf32);
			if(!(length == compare))
	{
		return it.doesnt;
	}

		}catch(Exception _exception_)
{
	if (_exception_.msg != "Access Violation") { return it.doesnt; } return it.does;
}
	return it.does;
	}
		it utflen_should_account_for_combining_marks_for_utf8()
	{before_utflen();
try
{
			uint length = Unicode.utflen(utf8marks);
			if(!(length == 10))
	{
		return it.doesnt;
	}

		}catch(Exception _exception_)
{
	if (_exception_.msg != "Access Violation") { return it.doesnt; } return it.does;
}
	return it.does;
	}
		it utflen_should_account_for_combining_marks_for_utf16()
	{before_utflen();
try
{
			uint length = Unicode.utflen(utf16marks);
			if(!(length == 10))
	{
		return it.doesnt;
	}

		}catch(Exception _exception_)
{
	if (_exception_.msg != "Access Violation") { return it.doesnt; } return it.does;
}
	return it.does;
	}
		it utflen_should_account_for_combining_marks_for_utf32()
	{before_utflen();
try
{
			uint length = Unicode.utflen(utf32marks);
			if(!(length == 10))
	{
		return it.doesnt;
	}

		}catch(Exception _exception_)
{
	if (_exception_.msg != "Access Violation") { return it.doesnt; } return it.does;
}
	return it.does;
	}
		it utflen_should_account_for_empty_strings_for_utf8()
	{before_utflen();
try
{
			uint length = Unicode.utflen(empty32);
			if(!(length == 0))
	{
		return it.doesnt;
	}

		}catch(Exception _exception_)
{
	if (_exception_.msg != "Access Violation") { return it.doesnt; } return it.does;
}
	return it.does;
	}
		it utflen_should_account_for_empty_strings_for_utf16()
	{before_utflen();
try
{
			uint length = Unicode.utflen(empty16);
			if(!(length == 0))
	{
		return it.doesnt;
	}

		}catch(Exception _exception_)
{
	if (_exception_.msg != "Access Violation") { return it.doesnt; } return it.does;
}
	return it.does;
	}
		it utflen_should_account_for_empty_strings_for_utf32()
	{before_utflen();
try
{
			uint length = Unicode.utflen(empty8);
			if(!(length == 0))
	{
		return it.doesnt;
	}

		}catch(Exception _exception_)
{
	if (_exception_.msg != "Access Violation") { return it.doesnt; } return it.does;
}
	return it.does;
	}	done before_utflen() { }

	
		it toUtfChars_should_work_as_expected_for_single_characters_for_utf32()
	{before_toUtfChars();
try
{
			dchar chrs[] = Unicode.toUtf32Chars(utf32marks);
			if(!(chrs.length == 1))
	{
		return it.doesnt;
	}

		}catch(Exception _exception_)
{
	if (_exception_.msg != "Access Violation") { return it.doesnt; } return it.does;
}
	return it.does;
	}
		it toUtfChars_should_work_as_expected_for_single_characters_for_utf16()
	{before_toUtfChars();
try
{
			dchar chrs[] = Unicode.toUtf32Chars(utf16marks);
			if(!(chrs.length == 1))
	{
		return it.doesnt;
	}

		}catch(Exception _exception_)
{
	if (_exception_.msg != "Access Violation") { return it.doesnt; } return it.does;
}
	return it.does;
	}
		it toUtfChars_should_work_as_expected_for_single_characters_for_utf8()
	{before_toUtfChars();
try
{
			dchar chrs[] = Unicode.toUtf32Chars(utf8marks);
			if(!(chrs.length == 1))
	{
		return it.doesnt;
	}

		}catch(Exception _exception_)
{
	if (_exception_.msg != "Access Violation") { return it.doesnt; } return it.does;
}
	return it.does;
	}
		it toUtfChars_should_account_for_combining_marks_for_utf32()
	{before_toUtfChars();
try
{
			dchar chrs[] = Unicode.toUtf32Chars(utf32marks[4..$]);
			if(!(chrs.length == 2))
	{
		return it.doesnt;
	}

		}catch(Exception _exception_)
{
	if (_exception_.msg != "Access Violation") { return it.doesnt; } return it.does;
}
	return it.does;
	}
		it toUtfChars_should_account_for_combining_marks_for_utf16()
	{before_toUtfChars();
try
{
			dchar chrs[] = Unicode.toUtf32Chars(utf16marks[4..$]);
			if(!(chrs.length == 2))
	{
		return it.doesnt;
	}

		}catch(Exception _exception_)
{
	if (_exception_.msg != "Access Violation") { return it.doesnt; } return it.does;
}
	return it.does;
	}
		it toUtfChars_should_account_for_combining_marks_for_utf8()
	{before_toUtfChars();
try
{
			dchar chrs[] = Unicode.toUtf32Chars(utf8marks[4..$]);
			if(!(chrs.length == 2))
	{
		return it.doesnt;
	}

		}catch(Exception _exception_)
{
	if (_exception_.msg != "Access Violation") { return it.doesnt; } return it.does;
}
	return it.does;
	}	done before_toUtfChars() { }
done before() { }

this() { before(); }


	static void test()
	{
		UnicodeTester tester = new UnicodeTester();

		Test test = new Test("Unicode");

		it result;

		test.logSubset("utflen");

		tester = new UnicodeTester();

		result = tester.utflen_should_be_the_same_for_utf8_as_utf32();
		test.logResult(result, "utflen should be the same for utf8 as utf32", "11");

		tester = new UnicodeTester();

		result = tester.utflen_should_be_the_same_for_utf16_as_utf32();
		test.logResult(result, "utflen should be the same for utf16 as utf32", "17");

		tester = new UnicodeTester();

		result = tester.utflen_should_account_for_combining_marks_for_utf8();
		test.logResult(result, "utflen should account for combining marks for utf8", "23");

		tester = new UnicodeTester();

		result = tester.utflen_should_account_for_combining_marks_for_utf16();
		test.logResult(result, "utflen should account for combining marks for utf16", "29");

		tester = new UnicodeTester();

		result = tester.utflen_should_account_for_combining_marks_for_utf32();
		test.logResult(result, "utflen should account for combining marks for utf32", "39");

		tester = new UnicodeTester();

		result = tester.utflen_should_account_for_empty_strings_for_utf8();
		test.logResult(result, "utflen should account for empty strings for utf8", "49");

		tester = new UnicodeTester();

		result = tester.utflen_should_account_for_empty_strings_for_utf16();
		test.logResult(result, "utflen should account for empty strings for utf16", "55");

		tester = new UnicodeTester();

		result = tester.utflen_should_account_for_empty_strings_for_utf32();
		test.logResult(result, "utflen should account for empty strings for utf32", "61");

		test.logSubset("toUtfChars");

		tester = new UnicodeTester();

		result = tester.toUtfChars_should_work_as_expected_for_single_characters_for_utf32();
		test.logResult(result, "toUtfChars should work as expected for single characters for utf32", "70");

		tester = new UnicodeTester();

		result = tester.toUtfChars_should_work_as_expected_for_single_characters_for_utf16();
		test.logResult(result, "toUtfChars should work as expected for single characters for utf16", "80");

		tester = new UnicodeTester();

		result = tester.toUtfChars_should_work_as_expected_for_single_characters_for_utf8();
		test.logResult(result, "toUtfChars should work as expected for single characters for utf8", "88");

		tester = new UnicodeTester();

		result = tester.toUtfChars_should_account_for_combining_marks_for_utf32();
		test.logResult(result, "toUtfChars should account for combining marks for utf32", "96");

		tester = new UnicodeTester();

		result = tester.toUtfChars_should_account_for_combining_marks_for_utf16();
		test.logResult(result, "toUtfChars should account for combining marks for utf16", "105");

		tester = new UnicodeTester();

		result = tester.toUtfChars_should_account_for_combining_marks_for_utf8();
		test.logResult(result, "toUtfChars should account for combining marks for utf8", "113");

	
	}
}import hashes.digest;

class DigestTester
{
	
		it creation_should_allow_for_64_bits()
	{before_creation();
try
{
			Digest d = new Digest(0xDEADBEEF, 0x01234567);
			String s = d.getString();

			if(!(s == "deadbeef01234567"))
	{
		return it.doesnt;
	}

		}catch(Exception _exception_)
{
	if (_exception_.msg != "Access Violation") { return it.doesnt; } return it.does;
}
	return it.does;
	}
		it creation_should_allow_for_128_bits()
	{before_creation();
try
{
			Digest d = new Digest(0xDEADBEEF, 0x01234567, 0xDEADBEEF, 0x01234567);
			String s = d.getString();

			if(!(s == "deadbeef01234567deadbeef01234567"))
	{
		return it.doesnt;
	}

		}catch(Exception _exception_)
{
	if (_exception_.msg != "Access Violation") { return it.doesnt; } return it.does;
}
	return it.does;
	}
		it creation_should_allow_for_160_bits()
	{before_creation();
try
{
			Digest d = new Digest(0xDEADBEEF, 0x01234567, 0xDEADBEEF, 0x01234567, 0xDEADBEEF);
			String s = d.getString();

			if(!(s == "deadbeef01234567deadbeef01234567deadbeef"))
	{
		return it.doesnt;
	}

		}catch(Exception _exception_)
{
	if (_exception_.msg != "Access Violation") { return it.doesnt; } return it.does;
}
	return it.does;
	}
		it creation_should_allow_for_192_bits()
	{before_creation();
try
{
			Digest d = new Digest(0xDEADBEEF, 0x01234567, 0xDEADBEEF, 0x01234567, 0xDEADBEEF, 0x01234567);
			String s = d.getString();

			if(!(s == "deadbeef01234567deadbeef01234567deadbeef01234567"))
	{
		return it.doesnt;
	}

		}catch(Exception _exception_)
{
	if (_exception_.msg != "Access Violation") { return it.doesnt; } return it.does;
}
	return it.does;
	}	done before_creation() { }

	
		it comparison_should_work_for_equals_overload()
	{before_comparison();
try
{
			Digest d1 = new Digest(0xDEADBEEF);
			Digest d2 = new Digest(0x01234567);
			Digest d3 = new Digest(0xDEADBEEF);

			if(!(d1 == d3))
	{
		return it.doesnt;
	}

			if(d1 == d2)
{ return it.doesnt; }

		}catch(Exception _exception_)
{
	if (_exception_.msg != "Access Violation") { return it.doesnt; } return it.does;
}
	return it.does;
	}
		it comparison_should_work_for_equals_function()
	{before_comparison();
try
{
			Digest d1 = new Digest(0xDEADBEEF);
			Digest d2 = new Digest(0x01234567);
			Digest d3 = new Digest(0xDEADBEEF);

			if(!(d1.equals(d3)))
	{
		return it.doesnt;
	}

			if(d1.equals(d2))
{ return it.doesnt; }

		}catch(Exception _exception_)
{
	if (_exception_.msg != "Access Violation") { return it.doesnt; } return it.does;
}
	return it.does;
	}	done before_comparison() { }
done before() { }

this() { before(); }


	static void test()
	{
		DigestTester tester = new DigestTester();

		Test test = new Test("Digest");

		it result;

		test.logSubset("creation");

		tester = new DigestTester();

		result = tester.creation_should_allow_for_64_bits();
		test.logResult(result, "creation should allow for 64 bits", "11");

		tester = new DigestTester();

		result = tester.creation_should_allow_for_128_bits();
		test.logResult(result, "creation should allow for 128 bits", "17");

		tester = new DigestTester();

		result = tester.creation_should_allow_for_160_bits();
		test.logResult(result, "creation should allow for 160 bits", "23");

		tester = new DigestTester();

		result = tester.creation_should_allow_for_192_bits();
		test.logResult(result, "creation should allow for 192 bits", "29");

		test.logSubset("comparison");

		tester = new DigestTester();

		result = tester.comparison_should_work_for_equals_overload();
		test.logResult(result, "comparison should work for equals overload", "39");

		tester = new DigestTester();

		result = tester.comparison_should_work_for_equals_function();
		test.logResult(result, "comparison should work for equals function", "49");

	
	}
}import hashes.md5;

class MD5Tester
{
	
		it hash_should_hash_as_expected_for_String_objects()
	{before_hash();
try
{
			String s = HashMD5.hash(new String("String you wish to hash")).getString();
			if(!(s == "b262eb2435f39440672348388746115f"))
	{
		return it.doesnt;
	}

		}catch(Exception _exception_)
{
	if (_exception_.msg != "Access Violation") { return it.doesnt; } return it.does;
}
	return it.does;
	}
		it hash_should_hash_as_expected_for_string_literals()
	{before_hash();
try
{
			String s = HashMD5.hash("Hashing Hashing Hashing").getString();
			if(!(s == "7ba85cd90a910d790172b15e895f8e56"))
	{
		return it.doesnt;
	}

		}catch(Exception _exception_)
{
	if (_exception_.msg != "Access Violation") { return it.doesnt; } return it.does;
}
	return it.does;
	}
		it hash_should_respect_leading_zeroes()
	{before_hash();
try
{
			// Testing: leading 0s on parts, note that there is a 0 on the 9th value from the 
			String s = HashMD5.hash("d").getString();
			if(!(s == "8277e0910d750195b448797616e091ad"))
	{
		return it.doesnt;
	}

		}catch(Exception _exception_)
{
	if (_exception_.msg != "Access Violation") { return it.doesnt; } return it.does;
}
	return it.does;
	}
		it hash_should_work_on_byte_arrays()
	{before_hash();
try
{
			// Testing a classic MD5 
			ubyte[] filea = cast(ubyte[])import("testmd5a.bin");
			ubyte[] fileb = cast(ubyte[])import("testmd5b.bin");

			String a = HashMD5.hash(filea).getString();
			String b = HashMD5.hash(fileb).getString();

			if(!(a == b))
	{
		return it.doesnt;
	}

			if(!(a == "da5c61e1edc0f18337e46418e48c1290"))
	{
		return it.doesnt;
	}

		}catch(Exception _exception_)
{
	if (_exception_.msg != "Access Violation") { return it.doesnt; } return it.does;
}
	return it.does;
	}	done before_hash() { }
done before() { }

this() { before(); }


	static void test()
	{
		MD5Tester tester = new MD5Tester();

		Test test = new Test("MD5");

		it result;

		test.logSubset("hash");

		tester = new MD5Tester();

		result = tester.hash_should_hash_as_expected_for_String_objects();
		test.logResult(result, "hash should hash as expected for String objects", "11");

		tester = new MD5Tester();

		result = tester.hash_should_hash_as_expected_for_string_literals();
		test.logResult(result, "hash should hash as expected for string literals", "17");

		tester = new MD5Tester();

		result = tester.hash_should_respect_leading_zeroes();
		test.logResult(result, "hash should respect leading zeroes", "23");

		tester = new MD5Tester();

		result = tester.hash_should_work_on_byte_arrays();
		test.logResult(result, "hash should work on byte arrays", "29");

	
	}
}import hashes.sha1;

class SHA1Tester
{
	
		it hash_should_hash_as_expected_for_String_objects()
	{before_hash();
try
{
			String s = HashSHA1.hash(new String("The quick brown fox jumps over the lazy dog")).getString();
			if(!(s == "2fd4e1c67a2d28fced849ee1bb76e7391b93eb12"))
	{
		return it.doesnt;
	}

		}catch(Exception _exception_)
{
	if (_exception_.msg != "Access Violation") { return it.doesnt; } return it.does;
}
	return it.does;
	}
		it hash_should_hash_as_expected_for_string_literals()
	{before_hash();
try
{
			String s = HashSHA1.hash("a").getString();
			if(!(s == "86f7e437faa5a7fce15d1ddcb9eaeaea377667b8"))
	{
		return it.doesnt;
	}

		}catch(Exception _exception_)
{
	if (_exception_.msg != "Access Violation") { return it.doesnt; } return it.does;
}
	return it.does;
	}
		it hash_should_hash_the_empty_string()
	{before_hash();
try
{
			String s = HashSHA1.hash(new String("")).getString();
			if(!(s == "da39a3ee5e6b4b0d3255bfef95601890afd80709"))
	{
		return it.doesnt;
	}

		}catch(Exception _exception_)
{
	if (_exception_.msg != "Access Violation") { return it.doesnt; } return it.does;
}
	return it.does;
	}	done before_hash() { }
done before() { }

this() { before(); }


	static void test()
	{
		SHA1Tester tester = new SHA1Tester();

		Test test = new Test("SHA1");

		it result;

		test.logSubset("hash");

		tester = new SHA1Tester();

		result = tester.hash_should_hash_as_expected_for_String_objects();
		test.logResult(result, "hash should hash as expected for String objects", "11");

		tester = new SHA1Tester();

		result = tester.hash_should_hash_as_expected_for_string_literals();
		test.logResult(result, "hash should hash as expected for string literals", "17");

		tester = new SHA1Tester();

		result = tester.hash_should_hash_the_empty_string();
		test.logResult(result, "hash should hash the empty string", "23");

	
	}
}import hashes.sha224;

class SHA224Tester
{
	
		it hash_should_hash_as_expected_for_String_objects()
	{before_hash();
try
{
			String s = HashSHA224.hash(new String("The quick brown fox jumps over the lazy dog")).getString();
			if(!(s == "730e109bd7a8a32b1cb9d9a09aa2325d2430587ddbc0c38bad911525"))
	{
		return it.doesnt;
	}

		}catch(Exception _exception_)
{
	if (_exception_.msg != "Access Violation") { return it.doesnt; } return it.does;
}
	return it.does;
	}
		it hash_should_hash_as_expected_for_string_literals()
	{before_hash();
try
{
			String s = HashSHA224.hash("a").getString();
			if(!(s == "abd37534c7d9a2efb9465de931cd7055ffdb8879563ae98078d6d6d5"))
	{
		return it.doesnt;
	}

		}catch(Exception _exception_)
{
	if (_exception_.msg != "Access Violation") { return it.doesnt; } return it.does;
}
	return it.does;
	}
		it hash_should_hash_the_empty_string()
	{before_hash();
try
{
			String s = HashSHA224.hash(new String("")).getString();
			if(!(s == "d14a028c2a3a2bc9476102bb288234c415a2b01f828ea62ac5b3e42f"))
	{
		return it.doesnt;
	}

		}catch(Exception _exception_)
{
	if (_exception_.msg != "Access Violation") { return it.doesnt; } return it.does;
}
	return it.does;
	}	done before_hash() { }
done before() { }

this() { before(); }


	static void test()
	{
		SHA224Tester tester = new SHA224Tester();

		Test test = new Test("SHA224");

		it result;

		test.logSubset("hash");

		tester = new SHA224Tester();

		result = tester.hash_should_hash_as_expected_for_String_objects();
		test.logResult(result, "hash should hash as expected for String objects", "11");

		tester = new SHA224Tester();

		result = tester.hash_should_hash_as_expected_for_string_literals();
		test.logResult(result, "hash should hash as expected for string literals", "17");

		tester = new SHA224Tester();

		result = tester.hash_should_hash_the_empty_string();
		test.logResult(result, "hash should hash the empty string", "23");

	
	}
}import hashes.sha256;

class SHA256Tester
{
	
		it hash_should_hash_as_expected_for_String_objects()
	{before_hash();
try
{
			String s = HashSHA256.hash(new String("The quick brown fox jumps over the lazy dog")).getString();
			if(!(s == "d7a8fbb307d7809469ca9abcb0082e4f8d5651e46d3cdb762d02d0bf37c9e592"))
	{
		return it.doesnt;
	}

		}catch(Exception _exception_)
{
	if (_exception_.msg != "Access Violation") { return it.doesnt; } return it.does;
}
	return it.does;
	}
		it hash_should_hash_as_expected_for_string_literals()
	{before_hash();
try
{
			String s = HashSHA256.hash("a").getString();
			if(!(s == "ca978112ca1bbdcafac231b39a23dc4da786eff8147c4e72b9807785afee48bb"))
	{
		return it.doesnt;
	}

		}catch(Exception _exception_)
{
	if (_exception_.msg != "Access Violation") { return it.doesnt; } return it.does;
}
	return it.does;
	}
		it hash_should_hash_the_empty_string()
	{before_hash();
try
{
			String s = HashSHA256.hash(new String("")).getString();
			if(!(s == "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855"))
	{
		return it.doesnt;
	}

		}catch(Exception _exception_)
{
	if (_exception_.msg != "Access Violation") { return it.doesnt; } return it.does;
}
	return it.does;
	}	done before_hash() { }
done before() { }

this() { before(); }


	static void test()
	{
		SHA256Tester tester = new SHA256Tester();

		Test test = new Test("SHA256");

		it result;

		test.logSubset("hash");

		tester = new SHA256Tester();

		result = tester.hash_should_hash_as_expected_for_String_objects();
		test.logResult(result, "hash should hash as expected for String objects", "11");

		tester = new SHA256Tester();

		result = tester.hash_should_hash_as_expected_for_string_literals();
		test.logResult(result, "hash should hash as expected for string literals", "17");

		tester = new SHA256Tester();

		result = tester.hash_should_hash_the_empty_string();
		test.logResult(result, "hash should hash the empty string", "23");

	
	}
}
class Tests
{
	static void testString()
	{
		StringTester.test();
	}

	static void testUnicode()
	{
		UnicodeTester.test();
	}

	static void testDigest()
	{
		DigestTester.test();
	}

	static void testMD5()
	{
		MD5Tester.test();
	}

	static void testSHA1()
	{
		SHA1Tester.test();
	}

	static void testSHA224()
	{
		SHA224Tester.test();
	}

	static void testSHA256()
	{
		SHA256Tester.test();
	}

	static void testAll()
	{
		testString();
		testUnicode();
		testDigest();
		testMD5();
		testSHA1();
		testSHA224();
		testSHA256();
	}
}

