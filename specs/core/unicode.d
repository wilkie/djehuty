module specs.core.unicode;

import testing.support;

import core.unicode;
import core.string;

describe unicode()
{
	dstring utf32 = "hello\u015Bworld";
	wstring utf16 = "hello\u015Bworld";
	string utf8 = "hello\u015Bworld";

	dstring utf32marks = "hello\u0364world";
	wstring utf16marks = "hello\u0364world";
	string utf8marks = "hello\u0364world";

	dstring empty32 = "";
	wstring empty16 = "";
	string empty8 = "";

	describe utflen()
	{
		it should_be_the_same_for_utf8_as_utf32()
		{
			uint length = Unicode.utflen(utf8);
			uint compare = Unicode.utflen(utf32);
			should(length == compare);
		}

		it should_be_the_same_for_utf16_as_utf32()
		{
			uint length = Unicode.utflen(utf16);
			uint compare = Unicode.utflen(utf32);
			should(length == compare);
		}

		it should_account_for_combining_marks_for_utf8()
		{
			uint length = Unicode.utflen(utf8marks);
			should(length == 10);
		}

		it should_account_for_combining_marks_for_utf16()
		{
			uint length = Unicode.utflen(utf16marks);
			should(length == 10);
		}

		it should_account_for_combining_marks_for_utf32()
		{
			uint length = Unicode.utflen(utf32marks);
			should(length == 10);
		}

		it should_account_for_empty_strings_for_utf8()
		{
			uint length = Unicode.utflen(empty32);
			should(length == 0);
		}

		it should_account_for_empty_strings_for_utf16()
		{
			uint length = Unicode.utflen(empty16);
			should(length == 0);
		}

		it should_account_for_empty_strings_for_utf32()
		{
			uint length = Unicode.utflen(empty8);
			should(length == 0);
		}
	}

	describe toUtfChars()
	{
		it should_work_as_expected_for_single_characters_for_utf32()
		{
			dchar chrs[] = Unicode.toUtf32Chars(utf32marks);
			should(chrs.length == 1);
		}

		it should_work_as_expected_for_single_characters_for_utf16()
		{
			dchar chrs[] = Unicode.toUtf32Chars(utf16marks);
			should(chrs.length == 1);
		}

		it should_work_as_expected_for_single_characters_for_utf8()
		{
			dchar chrs[] = Unicode.toUtf32Chars(utf8marks);
			should(chrs.length == 1);
		}

		it should_account_for_combining_marks_for_utf32()
		{
			dchar chrs[] = Unicode.toUtf32Chars(utf32marks[4..$]);
			should(chrs.length == 2);
		}

		it should_account_for_combining_marks_for_utf16()
		{
			dchar chrs[] = Unicode.toUtf32Chars(utf16marks[4..$]);
			should(chrs.length == 2);
		}

		it should_account_for_combining_marks_for_utf8()
		{
			dchar chrs[] = Unicode.toUtf32Chars(utf8marks[4..$]);
			should(chrs.length == 2);
		}
	}
}
