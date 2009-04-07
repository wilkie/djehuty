module specs.core.unicode;

import testing.support;

import core.unicode;
import core.string;

describe unicode()
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
