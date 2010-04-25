module specs.core.string;

import testing.support;

import core.string;

describe string {
	describe trim {
		it should_handle_empty_string() {
			should("".trim() == "");
		}

		it should_handle_whitespace_on_left() {
			should(" \t\nhello".trim() == "hello");
			should(" hello".trim() == "hello");
			should("\t\t\thello".trim() == "hello");
			should("\n\n\nhello".trim() == "hello");
		}

		it should_handle_whitespace_on_right() {
			should("hello \t\n".trim() == "hello");
			should("hello\t\t".trim() == "hello");
			should("hello\n\n".trim() == "hello");
			should("hello   ".trim() == "hello");
		}

		it should_handle_whitespace_on_both_sides() {
			should(" \t\nhello \t\n".trim() == "hello");
			should("\t\t\thello\n".trim() == "hello");
			should("\n\n\t\thello    \n".trim() == "hello");
			should("     \t   hello \t\t\t\n\n\t ".trim() == "hello");
		}
	}

	describe split {
		it should_work_on_empty_strings {
			string[] foo1 = "".split('a');
			string[] foo2 = "".split("a");
			should(foo1[0] == "");
			should(foo2[0] == "");
		}

		it should_work_on_characters {
			string[] foo = "work.on.characters".split('.');
			should(foo.length == 3);
			should(foo[0] == "work");
			should(foo[1] == "on");
			should(foo[2] == "characters");
		}

		it should_work_on_characters_with_delimiter_at_beginning {
			string[] foo = ".work.a.b".split('.');
			should(foo.length == 4);
			should(foo[0] == "");
			should(foo[1] == "work");
			should(foo[2] == "a");
			should(foo[3] == "b");
		}

		it should_work_on_characters_with_delimiter_at_end {
			string[] foo = "work.a.b.".split('.');
			should(foo.length == 4);
			should(foo[0] == "work");
			should(foo[1] == "a");
			should(foo[2] == "b");
			should(foo[3] == "");
		}

		it should_work_on_strings {
			string[] foo = "work(on strings.foo)".split("( .)");
			should(foo.length == 5);
			should(foo[0] == "work");
			should(foo[1] == "on");
			should(foo[2] == "strings");
			should(foo[3] == "foo");
			should(foo[4] == "");
		}
	}

	describe nextInt {
		it should_work_on_empty_strings {
			int foo;
			should("".nextInt(foo) == false);
		}

		it should_return_the_next_int {
			int foo;
			bool returnVal = "123foo".nextInt(foo);
			should(foo == 123);
			should(returnVal == true);
		}

		it should_fail_when_there_is_not_a_next_int {
			int foo;
			bool returnVal = "foo123".nextInt(foo);
			should(returnVal == false);
			should(foo == 0);
		}
	}

	describe substring {
		it should_work_on_empty_strings {
			string foo = "";
			foo = foo.substring(0);
			should(foo == "");
		}

		it should_work_for_start_larger_than_length {
			string foo = "abc";
			foo = foo.substring(4);
			should(foo == "");
			foo = "abc".substring(3);
			should(foo == "");
		}

		it should_work_for_start_at_zero_and_length_omitted {
			string foo = "abc";
			foo = foo.substring(0);
			should(foo == "abc");
		}

		it should_work_for_start_at_zero_and_length_longer_than_string {
			string foo = "abc";
			foo = foo.substring(0, 4);
			should(foo == "abc");
		}

		it should_work_for_start_at_zero_and_length_at_zero {
			string foo = "abc";
			foo = foo.substring(0,0);
			should(foo == "");
		}

		it should_work_for_start_at_zero_and_length_within_string {
			string foo1 = "abc".substring(0, 1);
			string foo2 = "abc".substring(0, 2);
			should(foo1 == "a");
			should(foo2 == "ab");
		}

		it should_work_for_start_within_string_and_length_omitted {
			string foo1 = "abc".substring(1);
			string foo2 = "abc".substring(2);
			should(foo1 == "bc");
			should(foo2 == "c");
		}

		it should_work_for_start_within_string_and_length_longer_than_string {
			string foo1 = "abc".substring(1, 4);
			string foo2 = "abc".substring(2, 4);
			string foo3 = "abc".substring(3, 4);
			should(foo1 == "bc");
			should(foo2 == "c");
			should(foo3 == "");
		}

		it should_work_for_start_within_string_and_length_at_zero {
			string foo1 = "abc".substring(1,0);
			string foo2 = "abc".substring(2,0);
			string foo3 = "abc".substring(3,0);
			should(foo1 == "");
			should(foo2 == "");
			should(foo3 == "");
		}
	}

	describe replace {
		it should_work_on_empty_strings {
			string foo = "".replace('a', 'b');
			should(foo == "");
		}

		it should_work_as_expected {
			string foo = "abcaefahi".replace('a', 'x');
			should(foo == "xbcxefxhi");
		}
	}

	describe find {
		it should_work_on_empty_strings {
			int foo = "".find("foo", 0);
			should(foo == -1);
		}

		it should_fail_on_finding_empty_strings {
			int foo1 = "".find("", 0);
			int foo2 = "abc".find("", 0);

			should(foo1 == -1);
			should(foo2 == -1);
		}

		it should_work_when_start_is_omitted {
			int foo1 = "abcdebc".find("bc");
			int foo2 = "abcdebc".find("ce");
			should(foo1 == 1);
			should(foo2 == -1);
		}

		it should_work_when_search_string_is_at_beginning {
			int foo = "abcd".find("ab");
			should(foo == 0);
		}

		it should_work_when_search_string_is_at_end {
			int foo = "abcd".find("cd");
			should(foo == 2);
		}

		it should_work_when_search_string_is_within_string {
			int foo = "abcd".find("bc");
			should(foo == 1);
		}

		it should_work_when_start_is_given {
			int foo1 = "abcdab".find("ab", 0);
			int foo2 = "abcdab".find("ab", 1);

			should(foo1 == 0);
			should(foo2 == 4);
		}
	}

	describe findReverse {
		it should_work_on_empty_strings {
			int foo = "".findReverse("foo", 0);
			should(foo == -1);
		}

		it should_fail_on_finding_empty_strings {
			int foo1 = "".findReverse("", 0);
			int foo2 = "abc".findReverse("", 0);

			should(foo1 == -1);
			should(foo2 == -1);
		}

		it should_work_when_start_is_omitted {
			int foo1 = "abcdebc".findReverse("bc");
			int foo2 = "abcdebc".findReverse("ce");
			should(foo1 == 5);
			should(foo2 == -1);
		}

		it should_work_when_search_string_is_at_beginning {
			int foo = "abcd".findReverse("ab");
			should(foo == 0);
		}

		it should_work_when_search_string_is_at_end {
			int foo = "abcd".findReverse("cd");
			should(foo == 2);
		}

		it should_work_when_search_string_is_within_string {
			int foo = "abcd".findReverse("bc");
			should(foo == 1);
		}

		it should_work_when_start_is_given {
			int foo1 = "abcdabcd".findReverse("ab", 0);
			int foo2 = "abcdabcd".findReverse("ab", 2);
			int foo3 = "abcdabcd".findReverse("ab", 6);

			should(foo1 == -1);
			should(foo2 == 0);
			should(foo3 == 4);
		}
	}

	describe times {
		it should_work_on_empty_strings {
			should("".times(4) == "");
		}

		it should_return_empty_string_with_amount_being_zero {
			should("abc".times(0) == "");
		}

		it should_work_with_identity {
			should("abc".times(1) == "abc");
		}

		it should_work_as_expected {
			should("abc".times(3) == "abcabcabc");
		}
	}

	describe format {
		it should_work_on_empty_strings {
			should("".format() == "");
		}

		it should_work_on_d_specifier {
			should("a{d}b".format(4) == "a4b");
			should("a{D}b".format(4) == "a4b");
		}

		it should_work_on_x_specifier {
			should("a{x}b".format(10) == "aab");
		}

		it should_work_with_d_specifier_with_width {
			should("a{8d}b".format(4) == "a00000004b");
		}

		it should_work_with_x_specifier_with_width {
			should("a{8x}b".format(10) == "a0000000ab");
		}

		it should_work_on_X_specifier {
			should("a{8X}b".format(10) == "a0000000Ab");
		}
		
		it should_work_when_specifier_is_at_beginning {
			should("{d}xxx".format(4) == "4xxx");
			should("{x}xxx".format(10) == "axxx");
			should("{X}xxx".format(10) == "Axxx");
		}
		
		it should_work_when_specifier_is_at_end {
			should("xxx{d}".format(4) == "xxx4");
			should("xxx{x}".format(10) == "xxxa");
			should("xxx{X}".format(10) == "xxxA");
		}

		it should_work_when_specifier_is_alone {
			should("{d}".format(4) == "4");
			should("{x}".format(10) == "a");
			should("{X}".format(10) == "A");
		}

		it should_work_with_two_specifiers_in_a_row {
			should("{d}{d}".format(4,5) == "45");
			should("{8x}{8x}".format(10,11) == "0000000a0000000b");
			should("{8x}{8X}".format(10,11) == "0000000a0000000B");
			should("{x}{d}".format(10,4) == "a4");
			should("{X}{d}".format(10,4) == "A4");
		}

		it should_work_with_empty_specifier {
			should("{}".format("hello") == "hello");
			should("aaa{}bbb{}ccc".format(1,"f") == "aaa1bbbfccc");
		}
	}

	describe uppercase {
		it should_work_on_empty_strings {
			should("".uppercase() == "");
		}

		it should_work_as_expected {
			string foo = "abc123dEFg";
			should(foo.uppercase() == "ABC123DEFG");
			should(foo == "abc123dEFg");
			should("123".uppercase() == "123");
		}
	}

	describe lowercase {
		it should_work_on_empty_strings {
			should("".lowercase() == "");
		}

		it should_work_as_expected {
			string foo = "aBC123dEFg";
			should(foo.lowercase() == "abc123defg");
			should(foo == "aBC123dEFg");
			should("123".uppercase() == "123");
		}
	}

	describe charAt {
		it should_fail_on_empty_strings {
			string foo = "".charAt(0);
			should(foo is null);
		}

		it should_work_for_normal_strings {
			string foo = "abc";
			should(foo.charAt(0) == "a");
			should(foo.charAt(1) == "b");
			should(foo.charAt(2) == "c");
			should(foo.charAt(3) is null);
		}

		it should_account_for_combining_marks {
			string foo = "he\u0364llo";
			should(foo.charAt(0) == "h");
			should(foo.charAt(1) == "e\u0364");
			should(foo.charAt(2) == "l");
			should(foo.charAt(3) == "l");
			should(foo.charAt(4) == "o");
			should(foo.charAt(5) is null);
		}
	}

	describe insertAt {
		it should_work_on_empty_strings {
			string foo = "";
			string f2 = foo.insertAt("abc", 0);
			should(foo == "");
			should(f2 == "abc");
		}

		it should_fail_when_index_is_out_of_bounds {
			string foo = "abc";
			string f2 = foo.insertAt("def", 4);
			should(foo == "abc");
			should(f2 is null);
		}

		it should_work_when_index_is_zero {
			string foo = "abc";
			string f2 = foo.insertAt("def", 0);
			should(foo == "abc");
			should(f2 == "defabc");
		}

		it should_work_when_index_is_utflen {
			string foo = "abc";
			string f2 = foo.insertAt("def", foo.utflen());
			should(foo == "abc");
			should(f2 == "abcdef");
		}

		it should_work_when_index_is_within_string {
			string foo = "abc";
			string f2 = foo.insertAt("def", 1);
			string f3 = foo.insertAt("def", 2);
			should(foo == "abc");
			should(f2 == "adefbc");
			should(f3 == "abdefc");
		}

		it should_account_for_combining_marks {
			string foo = "he\u0364llo";
			string f1 = foo.insertAt("def", 0);
			string f2 = foo.insertAt("def", 1);
			string f3 = foo.insertAt("def", 2);
			string f4 = foo.insertAt("def", 3);
			string f5 = foo.insertAt("def", 4);
			string f6 = foo.insertAt("def", 5);
			string f7 = foo.insertAt("def", 6);

			should(foo == "he\u0364llo");
			should(f1 == "defhe\u0364llo");
			should(f2 == "hdefe\u0364llo");
			should(f3 == "he\u0364defllo");
			should(f4 == "he\u0364ldeflo");
			should(f5 == "he\u0364lldefo");
			should(f6 == "he\u0364llodef");
			should(f7 is null);
		}
	}

	describe utflen {
		it should_work_on_empty_strings {
			should("".utflen() == 0);
		}

		it should_work_on_normal_strings {
			should("abc".utflen() == 3);
		}

		it should_account_for_combining_marks {
			string foo = "hello\u0364world";
			should(foo.utflen() == 10);
		}
	}
}
