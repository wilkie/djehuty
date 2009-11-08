
/*
 * test.d
 *
 * Tests the specifications defined and parsed by dspec
 *
 */

module specs.test;

import testing.logic;

import djehuty;

import core.unicode;

import core.string;

class UnicodeTester {

	dstring utf32 = "hello\u015Bworld";
	wstring utf16 = "hello\u015Bworld";
	string utf8 = "hello\u015Bworld";
	dstring utf32marks = "hello\u0364world";
	wstring utf16marks = "hello\u0364world";
	string utf8marks = "hello\u0364world";
	dstring empty32 = "";
	wstring empty16 = "";
	string empty8 = "";

	it utflen_should_be_the_same_for_utf8_as_utf32() {
		before_utflen();
		try {
			uint length = Unicode.utflen(utf8);
			uint compare = Unicode.utflen(utf32);
			if(!(length == compare)) {
				return it.doesnt;
			}
		}
		catch(Exception _exception_) {
			return it.doesnt;
		}
		return it.does;
	}

	it utflen_should_be_the_same_for_utf16_as_utf32() {
		before_utflen();
		try {
			uint length = Unicode.utflen(utf16);
			uint compare = Unicode.utflen(utf32);
			if(!(length == compare)) {
				return it.doesnt;
			}
		}
		catch(Exception _exception_) {
			return it.doesnt;
		}
		return it.does;
	}

	it utflen_should_account_for_combining_marks_for_utf8() {
		before_utflen();
		try {
			uint length = Unicode.utflen(utf8marks);
			if(!(length == 10)) {
				return it.doesnt;
			}
		}
		catch(Exception _exception_) {
			return it.doesnt;
		}
		return it.does;
	}

	it utflen_should_account_for_combining_marks_for_utf16() {
		before_utflen();
		try {
			uint length = Unicode.utflen(utf16marks);
			if(!(length == 10)) {
				return it.doesnt;
			}
		}
		catch(Exception _exception_) {
			return it.doesnt;
		}
		return it.does;
	}

	it utflen_should_account_for_combining_marks_for_utf32() {
		before_utflen();
		try {
			uint length = Unicode.utflen(utf32marks);
			if(!(length == 10)) {
				return it.doesnt;
			}
		}
		catch(Exception _exception_) {
			return it.doesnt;
		}
		return it.does;
	}

	it utflen_should_account_for_empty_strings_for_utf8() {
		before_utflen();
		try {
			uint length = Unicode.utflen(empty32);
			if(!(length == 0)) {
				return it.doesnt;
			}
		}
		catch(Exception _exception_) {
			return it.doesnt;
		}
		return it.does;
	}

	it utflen_should_account_for_empty_strings_for_utf16() {
		before_utflen();
		try {
			uint length = Unicode.utflen(empty16);
			if(!(length == 0)) {
				return it.doesnt;
			}
		}
		catch(Exception _exception_) {
			return it.doesnt;
		}
		return it.does;
	}

	it utflen_should_account_for_empty_strings_for_utf32() {
		before_utflen();
		try {
			uint length = Unicode.utflen(empty8);
			if(!(length == 0)) {
				return it.doesnt;
			}
		}
		catch(Exception _exception_) {
			return it.doesnt;
		}
		return it.does;
	}

	done before_utflen() {
	}

	it toUtfChars_should_work_as_expected_for_single_characters_for_utf32() {
		before_toUtfChars();
		try {
			dchar chrs[] = Unicode.toUtf32Chars(utf32marks);
			if(!(chrs.length == 1)) {
				return it.doesnt;
			}
		}
		catch(Exception _exception_) {
			return it.doesnt;
		}
		return it.does;
	}

	it toUtfChars_should_work_as_expected_for_single_characters_for_utf16() {
		before_toUtfChars();
		try {
			dchar chrs[] = Unicode.toUtf32Chars(utf16marks);
			if(!(chrs.length == 1)) {
				return it.doesnt;
			}
		}
		catch(Exception _exception_) {
			return it.doesnt;
		}
		return it.does;
	}

	it toUtfChars_should_work_as_expected_for_single_characters_for_utf8() {
		before_toUtfChars();
		try {
			dchar chrs[] = Unicode.toUtf32Chars(utf8marks);
			if(!(chrs.length == 1)) {
				return it.doesnt;
			}
		}
		catch(Exception _exception_) {
			return it.doesnt;
		}
		return it.does;
	}

	it toUtfChars_should_account_for_combining_marks_for_utf32() {
		before_toUtfChars();
		try {
			dchar chrs[] = Unicode.toUtf32Chars(utf32marks[4..$]);
			if(!(chrs.length == 2)) {
				return it.doesnt;
			}
		}
		catch(Exception _exception_) {
			return it.doesnt;
		}
		return it.does;
	}

	it toUtfChars_should_account_for_combining_marks_for_utf16() {
		before_toUtfChars();
		try {
			dchar chrs[] = Unicode.toUtf32Chars(utf16marks[4..$]);
			if(!(chrs.length == 2)) {
				return it.doesnt;
			}
		}
		catch(Exception _exception_) {
			return it.doesnt;
		}
		return it.does;
	}

	it toUtfChars_should_account_for_combining_marks_for_utf8() {
		before_toUtfChars();
		try {
			dchar chrs[] = Unicode.toUtf32Chars(utf8marks[4..$]);
			if(!(chrs.length == 2)) {
				return it.doesnt;
			}
		}
		catch(Exception _exception_) {
			return it.doesnt;
		}
		return it.does;
	}

	done before_toUtfChars() {
	}

	done before() {
	}

	this() {
		before();
	}

	static void test() {
		UnicodeTester tester = new UnicodeTester();

		Test test = new Test("Unicode", "specs/core/unicode.d");

		it result;

		test.logSubset("utflen");

		tester = new UnicodeTester();

		result = tester.utflen_should_be_the_same_for_utf8_as_utf32();
		test.logResult(result, "utflen should be the same for utf8 as utf32", "24");

		tester = new UnicodeTester();

		result = tester.utflen_should_be_the_same_for_utf16_as_utf32();
		test.logResult(result, "utflen should be the same for utf16 as utf32", "31");

		tester = new UnicodeTester();

		result = tester.utflen_should_account_for_combining_marks_for_utf8();
		test.logResult(result, "utflen should account for combining marks for utf8", "38");

		tester = new UnicodeTester();

		result = tester.utflen_should_account_for_combining_marks_for_utf16();
		test.logResult(result, "utflen should account for combining marks for utf16", "44");

		tester = new UnicodeTester();

		result = tester.utflen_should_account_for_combining_marks_for_utf32();
		test.logResult(result, "utflen should account for combining marks for utf32", "50");

		tester = new UnicodeTester();

		result = tester.utflen_should_account_for_empty_strings_for_utf8();
		test.logResult(result, "utflen should account for empty strings for utf8", "56");

		tester = new UnicodeTester();

		result = tester.utflen_should_account_for_empty_strings_for_utf16();
		test.logResult(result, "utflen should account for empty strings for utf16", "62");

		tester = new UnicodeTester();

		result = tester.utflen_should_account_for_empty_strings_for_utf32();
		test.logResult(result, "utflen should account for empty strings for utf32", "68");

		test.logSubset("toUtfChars");

		tester = new UnicodeTester();

		result = tester.toUtfChars_should_work_as_expected_for_single_characters_for_utf32();
		test.logResult(result, "toUtfChars should work as expected for single characters for utf32", "77");

		tester = new UnicodeTester();

		result = tester.toUtfChars_should_work_as_expected_for_single_characters_for_utf16();
		test.logResult(result, "toUtfChars should work as expected for single characters for utf16", "83");

		tester = new UnicodeTester();

		result = tester.toUtfChars_should_work_as_expected_for_single_characters_for_utf8();
		test.logResult(result, "toUtfChars should work as expected for single characters for utf8", "89");

		tester = new UnicodeTester();

		result = tester.toUtfChars_should_account_for_combining_marks_for_utf32();
		test.logResult(result, "toUtfChars should account for combining marks for utf32", "95");

		tester = new UnicodeTester();

		result = tester.toUtfChars_should_account_for_combining_marks_for_utf16();
		test.logResult(result, "toUtfChars should account for combining marks for utf16", "101");

		tester = new UnicodeTester();

		result = tester.toUtfChars_should_account_for_combining_marks_for_utf8();
		test.logResult(result, "toUtfChars should account for combining marks for utf8", "107");

		test.finish();
	}
}

import core.string;

import core.regex;

class RegexTester {

	it eval_should_handle_kleene_star() {
		before_eval();
		try {
			String str = Regex.eval("<EM>some text</EM>", `<.*>`);
			if(!(str == "<EM>some text</EM>")) {
				return it.doesnt;
			}
		}
		catch(Exception _exception_) {
			return it.doesnt;
		}
		return it.does;
	}

	it eval_should_handle_lazy_kleene_star() {
		before_eval();
		try {
			String str = Regex.eval("<EM>some text</EM>", `<.*?>`);
			if(!(str == "<EM>")) {
				return it.doesnt;
			}
		}
		catch(Exception _exception_) {
			return it.doesnt;
		}
		return it.does;
	}

	it eval_should_handle_kleene_plus() {
		before_eval();
		try {
			String str = Regex.eval("<>EM>some text</EM>", `<.+>`);
			if(!(str == "<>EM>some text</EM>")) {
				return it.doesnt;
			}
		}
		catch(Exception _exception_) {
			return it.doesnt;
		}
		return it.does;
	}

	it eval_should_handle_lazy_kleene_plus() {
		before_eval();
		try {
			String str = Regex.eval("<>EM>some text</EM>", `<.+?>`);
			if(!(str == "<>EM>")) {
				return it.doesnt;
			}
		}
		catch(Exception _exception_) {
			return it.doesnt;
		}
		return it.does;
	}

	it eval_should_handle_options() {
		before_eval();
		try {
			String str = Regex.eval("abc", `a?abc`);
			if(!(str == "abc")) {
				return it.doesnt;
			}
			str = Regex.eval("aabc", `a?abc`);
			if(!(str == "aabc")) {
				return it.doesnt;
			}
			str = Regex.eval("ababbababababbbc", `(a?b)*c`);
			if(!(str == "ababbababababbbc")) {
				return it.doesnt;
			}
		}
		catch(Exception _exception_) {
			return it.doesnt;
		}
		return it.does;
	}

	it eval_should_handle_optional_groups() {
		before_eval();
		try {
			String str = Regex.eval("abcdefeggfoo", `abc(egg|foo)?def(egg|foo)?(egg|foo)?`);
			if(!(str == "abcdefeggfoo")) {
				return it.doesnt;
			}
		}
		catch(Exception _exception_) {
			return it.doesnt;
		}
		return it.does;
	}

	it eval_should_handle_union_at_base_level() {
		before_eval();
		try {
			String str = Regex.eval("dogbert", `cat|dog`);
			if(!(str == "dog")) {
				return it.doesnt;
			}
		}
		catch(Exception _exception_) {
			return it.doesnt;
		}
		return it.does;
	}

	it eval_should_handle_union_at_group_level() {
		before_eval();
		try {
			String str = Regex.eval("bacd", `(bac|b)acd`);
			if(!(str == "bacd")) {
				return it.doesnt;
			}
		}
		catch(Exception _exception_) {
			return it.doesnt;
		}
		return it.does;
	}

	it eval_should_handle_union_with_kleene_star() {
		before_eval();
		try {
			String str = Regex.eval("catdogdogcatbert", `(cat|dog)*`);
			if(!(str == "catdogdogcat")) {
				return it.doesnt;
			}
		}
		catch(Exception _exception_) {
			return it.doesnt;
		}
		return it.does;
	}

	it eval_should_handle_nested_groups() {
		before_eval();
		try {
			String str = Regex.eval("acatbert", `a(cat(bert))`);
			if(!(str == "acatbert")) {
				return it.doesnt;
			}
			if(!(_1 == "catbert")) {
				return it.doesnt;
			}
			if(!(_2 == "bert")) {
				return it.doesnt;
			}
		}
		catch(Exception _exception_) {
			return it.doesnt;
		}
		return it.does;
	}

	it eval_should_handle_nested_groups_with_union() {
		before_eval();
		try {
			String str = Regex.eval("dogpoo", `(dog(bert|poo))`);
			if(!(str == "dogpoo")) {
				return it.doesnt;
			}
		}
		catch(Exception _exception_) {
			return it.doesnt;
		}
		return it.does;
	}

	it eval_should_handle_character_classes() {
		before_eval();
		try {
			String str = Regex.eval("daccabaaccbg", `d[abc]*g`);
			if(!(str == "daccabaaccbg")) {
				return it.doesnt;
			}
			str = Regex.eval("daccabadaccbg", `d[abc]*g`);
			if(!(str == "daccbg")) {
				return it.doesnt;
			}
			str = Regex.eval("daccabadaccbg", `^d[abc]*g`);
			if(!(str is null)) {
				return it.doesnt;
			}
		}
		catch(Exception _exception_) {
			return it.doesnt;
		}
		return it.does;
	}

	it eval_should_handle_inverse_character_classes() {
		before_eval();
		try {
			String str = Regex.eval("ddeffegggdefeddfeg", `d[^abc]*g`);
			if(!(str == "ddeffegggdefeddfeg")) {
				return it.doesnt;
			}
			str = Regex.eval("ddeffegggdefeddfeg", `d[^abc]*?g`);
			if(!(str == "ddeffeg")) {
				return it.doesnt;
			}
			str = Regex.eval("ddeffeagggdefeddfeg", `d[^abc]*?g`);
			if(!(str == "defeddfeg")) {
				return it.doesnt;
			}
		}
		catch(Exception _exception_) {
			return it.doesnt;
		}
		return it.does;
	}

	it eval_should_handle_dollar_sign() {
		before_eval();
		try {
			String str = Regex.eval("root woot moot foot", `.oot$`);
			if(!(str == "foot")) {
				return it.doesnt;
			}
			str = Regex.eval("root\nwoot\nmoot\nfoot", `.oot$`);
			if(!(str == "root")) {
				return it.doesnt;
			}
		}
		catch(Exception _exception_) {
			return it.doesnt;
		}
		return it.does;
	}

	it eval_should_handle_beginning_of_line_caret() {
		before_eval();
		try {
			String str = Regex.eval("root woot moot foot", `^.oot`);
			if(!(str == "root")) {
				return it.doesnt;
			}
			str = Regex.eval(" root\nwoot\nmoot\nfoot", `^.oot`, "m");
			if(!(str == "woot")) {
				return it.doesnt;
			}
		}
		catch(Exception _exception_) {
			return it.doesnt;
		}
		return it.does;
	}

	it eval_should_handle_group_consumption() {
		before_eval();
		try {
			String str = Regex.eval("dogpoo", `(dog(bert|poo))`);
			if(!(str == "dogpoo")) {
				return it.doesnt;
			}
			if(!(_1 == "dogpoo")) {
				return it.doesnt;
			}
			if(!(_2 == "poo")) {
				return it.doesnt;
			}
		}
		catch(Exception _exception_) {
			return it.doesnt;
		}
		return it.does;
	}

	it eval_should_handle_group_reconsumption() {
		before_eval();
		try {
			String str = Regex.eval("bertpoopoobertpoo", `(bert|poo)+`);
			if(!(str == "bertpoopoobertpoo")) {
				return it.doesnt;
			}
			if(!(_1 == "poo")) {
				return it.doesnt;
			}
		}
		catch(Exception _exception_) {
			return it.doesnt;
		}
		return it.does;
	}

	it eval_should_handle_backreferences() {
		before_eval();
		try {
			String str = Regex.eval("dogpoo=dogpoo", `(dogpoo)=\1`);
			if(!(str == "dogpoo=dogpoo")) {
				return it.doesnt;
			}
			if(!(_1 == "dogpoo")) {
				return it.doesnt;
			}
		}
		catch(Exception _exception_) {
			return it.doesnt;
		}
		return it.does;
	}

	it eval_should_handle_forwardreferences() {
		before_eval();
		try {
			String str = Regex.eval("oneonetwo", `(\2two|(one))+`);
			if(!(str == "oneonetwo")) {
				return it.doesnt;
			}
			if(!(_1 == "onetwo")) {
				return it.doesnt;
			}
			if(!(_2 == "one")) {
				return it.doesnt;
			}
		}
		catch(Exception _exception_) {
			return it.doesnt;
		}
		return it.does;
	}

	it eval_should_handle_comments() {
		before_eval();
		try {
			String str = Regex.eval("bleh", `bl(?#comment here)eh`);
			if(!(str == "bleh")) {
				return it.doesnt;
			}
		}
		catch(Exception _exception_) {
			return it.doesnt;
		}
		return it.does;
	}

	it eval_should_handle_complicated_constructions() {
		before_eval();
		try {
			String str = Regex.eval(`a#line 43 "foo\bar"`, `#line\s+(0x[0-9a-fA-F_]+|0b[01_]+|0[_0-7]+|(?:[1-9][_0-9]*|0))(?:\s+("[^"]*"))?`);
			if(!(str == `#line 43 "foo\bar"`)) {
				return it.doesnt;
			}
			if(!(_1 == "43")) {
				return it.doesnt;
			}
			if(!(_2 == `"foo\bar"`)) {
				return it.doesnt;
			}
		}
		catch(Exception _exception_) {
			return it.doesnt;
		}
		return it.does;
	}

	done before_eval() {
	}

	done before() {
	}

	this() {
		before();
	}

	static void test() {
		RegexTester tester = new RegexTester();

		Test test = new Test("Regex", "specs/core/regex.d");

		it result;

		test.logSubset("eval");

		tester = new RegexTester();

		result = tester.eval_should_handle_kleene_star();
		test.logResult(result, "eval should handle kleene star", "12");

		tester = new RegexTester();

		result = tester.eval_should_handle_lazy_kleene_star();
		test.logResult(result, "eval should handle lazy kleene star", "18");

		tester = new RegexTester();

		result = tester.eval_should_handle_kleene_plus();
		test.logResult(result, "eval should handle kleene plus", "24");

		tester = new RegexTester();

		result = tester.eval_should_handle_lazy_kleene_plus();
		test.logResult(result, "eval should handle lazy kleene plus", "30");

		tester = new RegexTester();

		result = tester.eval_should_handle_options();
		test.logResult(result, "eval should handle options", "36");

		tester = new RegexTester();

		result = tester.eval_should_handle_optional_groups();
		test.logResult(result, "eval should handle optional groups", "48");

		tester = new RegexTester();

		result = tester.eval_should_handle_union_at_base_level();
		test.logResult(result, "eval should handle union at base level", "54");

		tester = new RegexTester();

		result = tester.eval_should_handle_union_at_group_level();
		test.logResult(result, "eval should handle union at group level", "60");

		tester = new RegexTester();

		result = tester.eval_should_handle_union_with_kleene_star();
		test.logResult(result, "eval should handle union with kleene star", "66");

		tester = new RegexTester();

		result = tester.eval_should_handle_nested_groups();
		test.logResult(result, "eval should handle nested groups", "72");

		tester = new RegexTester();

		result = tester.eval_should_handle_nested_groups_with_union();
		test.logResult(result, "eval should handle nested groups with union", "80");

		tester = new RegexTester();

		result = tester.eval_should_handle_character_classes();
		test.logResult(result, "eval should handle character classes", "86");

		tester = new RegexTester();

		result = tester.eval_should_handle_inverse_character_classes();
		test.logResult(result, "eval should handle inverse character classes", "98");

		tester = new RegexTester();

		result = tester.eval_should_handle_dollar_sign();
		test.logResult(result, "eval should handle dollar sign", "109");

		tester = new RegexTester();

		result = tester.eval_should_handle_beginning_of_line_caret();
		test.logResult(result, "eval should handle beginning of line caret", "117");

		tester = new RegexTester();

		result = tester.eval_should_handle_group_consumption();
		test.logResult(result, "eval should handle group consumption", "125");

		tester = new RegexTester();

		result = tester.eval_should_handle_group_reconsumption();
		test.logResult(result, "eval should handle group reconsumption", "133");

		tester = new RegexTester();

		result = tester.eval_should_handle_backreferences();
		test.logResult(result, "eval should handle backreferences", "140");

		tester = new RegexTester();

		result = tester.eval_should_handle_forwardreferences();
		test.logResult(result, "eval should handle forwardreferences", "146");

		tester = new RegexTester();

		result = tester.eval_should_handle_comments();
		test.logResult(result, "eval should handle comments", "154");

		tester = new RegexTester();

		result = tester.eval_should_handle_complicated_constructions();
		test.logResult(result, "eval should handle complicated constructions", "159");

		test.finish();
	}
}

import core.string;

class StringTester {

	it creation_should_handle_literals() {
		before_creation();
		try {
			String str = new String("new string");
			if(!(str == "new string")) {
				return it.doesnt;
			}
		}
		catch(Exception _exception_) {
			return it.doesnt;
		}
		return it.does;
	}

	it creation_should_handle_integers() {
		before_creation();
		try {
			String str = new String(123);
			if(!(str == "123")) {
				return it.doesnt;
			}
		}
		catch(Exception _exception_) {
			return it.doesnt;
		}
		return it.does;
	}

	it creation_should_handle_formatting() {
		before_creation();
		try {
			String str = new String("%x%d!!!", 0xdead, 1234);
			if(!(str == "dead1234!!!")) {
				return it.doesnt;
			}
		}
		catch(Exception _exception_) {
			return it.doesnt;
		}
		return it.does;
	}

	it creation_should_handle_string_objects() {
		before_creation();
		try {
			String str = new String("hello");
			String str2 = new String(str);
			if(!(str == "hello")) {
				return it.doesnt;
			}
		}
		catch(Exception _exception_) {
			return it.doesnt;
		}
		return it.does;
	}

	done before_creation() {
	}

	it trim_should_trim_off_whitespace() {
		before_trim();
		try {
			String str = new String("    \t\t bah \n\n\r\t");
			str = str.trim();
			if(!(str == "bah")) {
				return it.doesnt;
			}
		}
		catch(Exception _exception_) {
			return it.doesnt;
		}
		return it.does;
	}

	done before_trim() {
	}

	it length_should_account_for_combining_marks() {
		before_length();
		try {
			String str = new String("hello\u0364world");
			if(!(str.length == 10)) {
				return it.doesnt;
			}
		}
		catch(Exception _exception_) {
			return it.doesnt;
		}
		return it.does;
	}

	it length_should_return_the_number_of_characters() {
		before_length();
		try {
			String str = new String("hello world");
			if(!(str.length == 11)) {
				return it.doesnt;
			}
		}
		catch(Exception _exception_) {
			return it.doesnt;
		}
		return it.does;
	}

	it length_should_not_fail_on_an_empty_string() {
		before_length();
		try {
			String str = new String("");
			if(!(str.length == 0)) {
				return it.doesnt;
			}
		}
		catch(Exception _exception_) {
			return it.doesnt;
		}
		return it.does;
	}

	done before_length() {
	}

	it append_should_concatenate_a_string_object() {
		before_append();
		try {
			String str = new String("hello ");
			String str2 = new String("world");
			str.append(str2);
			if(!(str == "hello world")) {
				return it.doesnt;
			}
		}
		catch(Exception _exception_) {
			return it.doesnt;
		}
		return it.does;
	}

	it append_should_concatenate_a_string_literal() {
		before_append();
		try {
			String str = new String("hello ");
			str.append("world");
			if(!(str == "hello world")) {
				return it.doesnt;
			}
		}
		catch(Exception _exception_) {
			return it.doesnt;
		}
		return it.does;
	}

	it append_should_concatenate_a_formatted_string_literal() {
		before_append();
		try {
			String str = new String("hello ");
			str.append("%x%d!!!", 0xdead, 1234);
			if(!(str == "hello dead1234!!!")) {
				return it.doesnt;
			}
		}
		catch(Exception _exception_) {
			return it.doesnt;
		}
		return it.does;
	}

	it append_should_not_fail_on_an_empty_string_object() {
		before_append();
		try {
			String str = new String("hello ");
			String str2 = new String("");
			str.append(str2);
			if(!(str == "hello ")) {
				return it.doesnt;
			}
		}
		catch(Exception _exception_) {
			return it.doesnt;
		}
		return it.does;
	}

	it append_should_not_fail_on_an_empty_string_literal() {
		before_append();
		try {
			String str = new String("hello ");
			str.append("");
			if(!(str == "hello ")) {
				return it.doesnt;
			}
		}
		catch(Exception _exception_) {
			return it.doesnt;
		}
		return it.does;
	}

	it append_should_throw_an_exception_for_null_string_object() {
		before_append();
		try {
			String str = new String("hello ");
			String str2;
			str.append(str2);
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Access Violation") { return it.doesnt; }
			return it.does;
		}
		return it.does;
	}

	done before_append() {
	}

	it toLowercase_should_work_as_expected() {
		before_toLowercase();
		try {
			String str = new String("HelLo WoRLD");
			str = str.toLowercase();
			if(!(str == "hello world")) {
				return it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Access Violation") { return it.doesnt; }
			return it.does;
		}
		return it.does;
	}

	it toLowercase_should_not_fail_on_an_empty_string() {
		before_toLowercase();
		try {
			String str = new String("");
			str = str.toLowercase();
			if(!(str == "")) {
				return it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Access Violation") { return it.doesnt; }
			return it.does;
		}
		return it.does;
	}

	done before_toLowercase() {
	}

	it toUppercase_should_work_as_expected() {
		before_toUppercase();
		try {
			String str = new String("HelLo WoRLD");
			str = str.toUppercase();
			if(!(str == "HELLO WORLD")) {
				return it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Access Violation") { return it.doesnt; }
			return it.does;
		}
		return it.does;
	}

	it toUppercase_should_not_fail_on_an_empty_string() {
		before_toUppercase();
		try {
			String str = new String("");
			str = str.toUppercase();
			if(!(str == "")) {
				return it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Access Violation") { return it.doesnt; }
			return it.does;
		}
		return it.does;
	}

	done before_toUppercase() {
	}

	it find_should_work_as_expected() {
		before_find();
		try {
			String str = new String("foobar");
			String toFind = new String("oob");
			int pos = str.find(toFind);
			if(!(pos == 1)) {
				return it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Access Violation") { return it.doesnt; }
			return it.does;
		}
		return it.does;
	}

	it find_should_fail_as_expected() {
		before_find();
		try {
			String str = new String("foobar");
			String toFind = new String("boo");
			int pos = str.find(toFind);
			if(!(pos == -1)) {
				return it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Access Violation") { return it.doesnt; }
			return it.does;
		}
		return it.does;
	}

	it find_should_work_at_the_beginning_of_the_string() {
		before_find();
		try {
			String str = new String("foobar");
			String toFind = new String("foo");
			int pos = str.find(toFind);
			if(!(pos == 0)) {
				return it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Access Violation") { return it.doesnt; }
			return it.does;
		}
		return it.does;
	}

	it find_should_work_at_the_end_of_the_string() {
		before_find();
		try {
			String str = new String("foobar");
			String toFind = new String("bar");
			int pos = str.find(toFind);
			if(!(pos == 3)) {
				return it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Access Violation") { return it.doesnt; }
			return it.does;
		}
		return it.does;
	}

	done before_find() {
	}

	it insertAt_should_insert_a_string_object() {
		before_insertAt();
		try {
			String str = new String("foobaz");
			String str2 = new String("bar");
			str = str.insertAt(str2, 3);
			if(!(str == "foobarbaz")) {
				return it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Access Violation") { return it.doesnt; }
			return it.does;
		}
		return it.does;
	}

	it insertAt_should_insert_a_simple_string() {
		before_insertAt();
		try {
			String str = new String("foobaz");
			str = str.insertAt("bar", 3);
			if(!(str == "foobarbaz")) {
				return it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Access Violation") { return it.doesnt; }
			return it.does;
		}
		return it.does;
	}

	it insertAt_should_not_fail_on_position_zero() {
		before_insertAt();
		try {
			String str = new String("barbaz");
			str = str.insertAt("foo", 0);
			if(!(str == "foobarbaz")) {
				return it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Access Violation") { return it.doesnt; }
			return it.does;
		}
		return it.does;
	}

	it insertAt_should_not_fail_on_an_empty_string() {
		before_insertAt();
		try {
			String str = new String("foobar");
			str = str.insertAt("", 0);
			if(!(str == "foobar")) {
				return it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Access Violation") { return it.doesnt; }
			return it.does;
		}
		return it.does;
	}

	it insertAt_should_not_fail_on_position_outside_string() {
		before_insertAt();
		try {
			String str = new String("foobar");
			str = str.insertAt("baz", str.length() + 1);
			if(!(str == "foobar")) {
				return it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Access Violation") { return it.doesnt; }
			return it.does;
		}
		return it.does;
	}

	done before_insertAt() {
	}

	it repeat_should_repeat_a_string_object() {
		before_repeat();
		try {
			String str = new String("foo");
			String str2 = String.repeat(str, 3);
			if(!(str2 == "foofoofoo")) {
				return it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Access Violation") { return it.doesnt; }
			return it.does;
		}
		return it.does;
	}

	it repeat_should_repeat_a_simple_string() {
		before_repeat();
		try {
			String str = String.repeat("foo", 3);
			if(!(str == "foofoofoo")) {
				return it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Access Violation") { return it.doesnt; }
			return it.does;
		}
		return it.does;
	}

	it repeat_should_not_fail_on_an_empty_string() {
		before_repeat();
		try {
			String str = String.repeat("", 3);
			if(!(str == "")) {
				return it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Access Violation") { return it.doesnt; }
			return it.does;
		}
		return it.does;
	}

	it repeat_should_not_fail_on_zero_iterations() {
		before_repeat();
		try {
			String str = String.repeat("foo", 0);
			if(!(str == "")) {
				return it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Access Violation") { return it.doesnt; }
			return it.does;
		}
		return it.does;
	}

	done before_repeat() {
	}

	done before() {
	}

	this() {
		before();
	}

	static void test() {
		StringTester tester = new StringTester();

		Test test = new Test("String", "specs/core/string.d");

		it result;

		test.logSubset("creation");

		tester = new StringTester();

		result = tester.creation_should_handle_literals();
		test.logResult(result, "creation should handle literals", "9");

		tester = new StringTester();

		result = tester.creation_should_handle_integers();
		test.logResult(result, "creation should handle integers", "14");

		tester = new StringTester();

		result = tester.creation_should_handle_formatting();
		test.logResult(result, "creation should handle formatting", "19");

		tester = new StringTester();

		result = tester.creation_should_handle_string_objects();
		test.logResult(result, "creation should handle string objects", "24");

		test.logSubset("trim");

		tester = new StringTester();

		result = tester.trim_should_trim_off_whitespace();
		test.logResult(result, "trim should trim off whitespace", "32");

		test.logSubset("length");

		tester = new StringTester();

		result = tester.length_should_account_for_combining_marks();
		test.logResult(result, "length should account for combining marks", "40");

		tester = new StringTester();

		result = tester.length_should_return_the_number_of_characters();
		test.logResult(result, "length should return the number of characters", "45");

		tester = new StringTester();

		result = tester.length_should_not_fail_on_an_empty_string();
		test.logResult(result, "length should not fail on an empty string", "50");

		test.logSubset("append");

		tester = new StringTester();

		result = tester.append_should_concatenate_a_string_object();
		test.logResult(result, "append should concatenate a string object", "57");

		tester = new StringTester();

		result = tester.append_should_concatenate_a_string_literal();
		test.logResult(result, "append should concatenate a string literal", "66");

		tester = new StringTester();

		result = tester.append_should_concatenate_a_formatted_string_literal();
		test.logResult(result, "append should concatenate a formatted string literal", "73");

		tester = new StringTester();

		result = tester.append_should_not_fail_on_an_empty_string_object();
		test.logResult(result, "append should not fail on an empty string object", "80");

		tester = new StringTester();

		result = tester.append_should_not_fail_on_an_empty_string_literal();
		test.logResult(result, "append should not fail on an empty string literal", "88");

		tester = new StringTester();

		result = tester.append_should_throw_an_exception_for_null_string_object();
		test.logResult(result, "append should throw an exception for null string object", "95");

		test.logSubset("toLowercase");

		tester = new StringTester();

		result = tester.toLowercase_should_work_as_expected();
		test.logResult(result, "toLowercase should work as expected", "106");

		tester = new StringTester();

		result = tester.toLowercase_should_not_fail_on_an_empty_string();
		test.logResult(result, "toLowercase should not fail on an empty string", "113");

		test.logSubset("toUppercase");

		tester = new StringTester();

		result = tester.toUppercase_should_work_as_expected();
		test.logResult(result, "toUppercase should work as expected", "122");

		tester = new StringTester();

		result = tester.toUppercase_should_not_fail_on_an_empty_string();
		test.logResult(result, "toUppercase should not fail on an empty string", "129");

		test.logSubset("find");

		tester = new StringTester();

		result = tester.find_should_work_as_expected();
		test.logResult(result, "find should work as expected", "138");

		tester = new StringTester();

		result = tester.find_should_fail_as_expected();
		test.logResult(result, "find should fail as expected", "146");

		tester = new StringTester();

		result = tester.find_should_work_at_the_beginning_of_the_string();
		test.logResult(result, "find should work at the beginning of the string", "154");

		tester = new StringTester();

		result = tester.find_should_work_at_the_end_of_the_string();
		test.logResult(result, "find should work at the end of the string", "162");

		test.logSubset("insertAt");

		tester = new StringTester();

		result = tester.insertAt_should_insert_a_string_object();
		test.logResult(result, "insertAt should insert a string object", "172");

		tester = new StringTester();

		result = tester.insertAt_should_insert_a_simple_string();
		test.logResult(result, "insertAt should insert a simple string", "179");

		tester = new StringTester();

		result = tester.insertAt_should_not_fail_on_position_zero();
		test.logResult(result, "insertAt should not fail on position zero", "185");

		tester = new StringTester();

		result = tester.insertAt_should_not_fail_on_an_empty_string();
		test.logResult(result, "insertAt should not fail on an empty string", "191");

		tester = new StringTester();

		result = tester.insertAt_should_not_fail_on_position_outside_string();
		test.logResult(result, "insertAt should not fail on position outside string", "197");

		test.logSubset("repeat");

		tester = new StringTester();

		result = tester.repeat_should_repeat_a_string_object();
		test.logResult(result, "repeat should repeat a string object", "205");

		tester = new StringTester();

		result = tester.repeat_should_repeat_a_simple_string();
		test.logResult(result, "repeat should repeat a simple string", "211");

		tester = new StringTester();

		result = tester.repeat_should_not_fail_on_an_empty_string();
		test.logResult(result, "repeat should not fail on an empty string", "216");

		tester = new StringTester();

		result = tester.repeat_should_not_fail_on_zero_iterations();
		test.logResult(result, "repeat should not fail on zero iterations", "221");

		test.finish();
	}
}

import hashes.sha224;

class SHA224Tester {

	it hash_should_hash_as_expected_for_String_objects() {
		before_hash();
		try {
			String s = HashSHA224.hash(new String("The quick brown fox jumps over the lazy dog")).getString();
			if(!(s == "730e109bd7a8a32b1cb9d9a09aa2325d2430587ddbc0c38bad911525")) {
				return it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Access Violation") { return it.doesnt; }
			return it.does;
		}
		return it.does;
	}

	it hash_should_hash_as_expected_for_string_literals() {
		before_hash();
		try {
			String s = HashSHA224.hash("a").getString();
			if(!(s == "abd37534c7d9a2efb9465de931cd7055ffdb8879563ae98078d6d6d5")) {
				return it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Access Violation") { return it.doesnt; }
			return it.does;
		}
		return it.does;
	}

	it hash_should_hash_the_empty_string() {
		before_hash();
		try {
			String s = HashSHA224.hash(new String("")).getString();
			if(!(s == "d14a028c2a3a2bc9476102bb288234c415a2b01f828ea62ac5b3e42f")) {
				return it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Access Violation") { return it.doesnt; }
			return it.does;
		}
		return it.does;
	}

	done before_hash() {
	}

	done before() {
	}

	this() {
		before();
	}

	static void test() {
		SHA224Tester tester = new SHA224Tester();

		Test test = new Test("SHA224", "specs/hashes/sha224.d");

		it result;

		test.logSubset("hash");

		tester = new SHA224Tester();

		result = tester.hash_should_hash_as_expected_for_String_objects();
		test.logResult(result, "hash should hash as expected for String objects", "9");

		tester = new SHA224Tester();

		result = tester.hash_should_hash_as_expected_for_string_literals();
		test.logResult(result, "hash should hash as expected for string literals", "14");

		tester = new SHA224Tester();

		result = tester.hash_should_hash_the_empty_string();
		test.logResult(result, "hash should hash the empty string", "19");

		test.finish();
	}
}

import hashes.md5;

class MD5Tester {

	it hash_should_hash_as_expected_for_String_objects() {
		before_hash();
		try {
			String s = HashMD5.hash(new String("String you wish to hash")).getString();
			if(!(s == "b262eb2435f39440672348388746115f")) {
				return it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Access Violation") { return it.doesnt; }
			return it.does;
		}
		return it.does;
	}

	it hash_should_hash_as_expected_for_string_literals() {
		before_hash();
		try {
			String s = HashMD5.hash("Hashing Hashing Hashing").getString();
			if(!(s == "7ba85cd90a910d790172b15e895f8e56")) {
				return it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Access Violation") { return it.doesnt; }
			return it.does;
		}
		return it.does;
	}

	it hash_should_respect_leading_zeroes() {
		before_hash();
		try {
			// Testing: leading 0s on parts, note that there is a 0 on the 9th value from the 
			String s = HashMD5.hash("d").getString();
			if(!(s == "8277e0910d750195b448797616e091ad")) {
				return it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Access Violation") { return it.doesnt; }
			return it.does;
		}
		return it.does;
	}

	it hash_should_work_on_byte_arrays() {
		before_hash();
		try {
			// Testing a classic MD5 
			ubyte[] filea = cast(ubyte[])import("testmd5a.bin");
			ubyte[] fileb = cast(ubyte[])import("testmd5b.bin");
			String a = HashMD5.hash(filea).getString();
			String b = HashMD5.hash(fileb).getString();
			if(!(a == b)) {
				return it.doesnt;
			}
			if(!(a == "da5c61e1edc0f18337e46418e48c1290")) {
				return it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Access Violation") { return it.doesnt; }
			return it.does;
		}
		return it.does;
	}

	done before_hash() {
	}

	done before() {
	}

	this() {
		before();
	}

	static void test() {
		MD5Tester tester = new MD5Tester();

		Test test = new Test("MD5", "specs/hashes/md5.d");

		it result;

		test.logSubset("hash");

		tester = new MD5Tester();

		result = tester.hash_should_hash_as_expected_for_String_objects();
		test.logResult(result, "hash should hash as expected for String objects", "9");

		tester = new MD5Tester();

		result = tester.hash_should_hash_as_expected_for_string_literals();
		test.logResult(result, "hash should hash as expected for string literals", "14");

		tester = new MD5Tester();

		result = tester.hash_should_respect_leading_zeroes();
		test.logResult(result, "hash should respect leading zeroes", "19");

		tester = new MD5Tester();

		result = tester.hash_should_work_on_byte_arrays();
		test.logResult(result, "hash should work on byte arrays", "25");

		test.finish();
	}
}

import hashes.sha1;

class SHA1Tester {

	it hash_should_hash_as_expected_for_String_objects() {
		before_hash();
		try {
			String s = HashSHA1.hash(new String("The quick brown fox jumps over the lazy dog")).getString();
			if(!(s == "2fd4e1c67a2d28fced849ee1bb76e7391b93eb12")) {
				return it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Access Violation") { return it.doesnt; }
			return it.does;
		}
		return it.does;
	}

	it hash_should_hash_as_expected_for_string_literals() {
		before_hash();
		try {
			String s = HashSHA1.hash("a").getString();
			if(!(s == "86f7e437faa5a7fce15d1ddcb9eaeaea377667b8")) {
				return it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Access Violation") { return it.doesnt; }
			return it.does;
		}
		return it.does;
	}

	it hash_should_hash_the_empty_string() {
		before_hash();
		try {
			String s = HashSHA1.hash(new String("")).getString();
			if(!(s == "da39a3ee5e6b4b0d3255bfef95601890afd80709")) {
				return it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Access Violation") { return it.doesnt; }
			return it.does;
		}
		return it.does;
	}

	done before_hash() {
	}

	done before() {
	}

	this() {
		before();
	}

	static void test() {
		SHA1Tester tester = new SHA1Tester();

		Test test = new Test("SHA1", "specs/hashes/sha1.d");

		it result;

		test.logSubset("hash");

		tester = new SHA1Tester();

		result = tester.hash_should_hash_as_expected_for_String_objects();
		test.logResult(result, "hash should hash as expected for String objects", "9");

		tester = new SHA1Tester();

		result = tester.hash_should_hash_as_expected_for_string_literals();
		test.logResult(result, "hash should hash as expected for string literals", "14");

		tester = new SHA1Tester();

		result = tester.hash_should_hash_the_empty_string();
		test.logResult(result, "hash should hash the empty string", "19");

		test.finish();
	}
}

import hashes.digest;

class DigestTester {

	it creation_should_allow_for_64_bits() {
		before_creation();
		try {
			Digest d = new Digest(0xDEADBEEF, 0x01234567);
			String s = d.getString();
			if(!(s == "deadbeef01234567")) {
				return it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Access Violation") { return it.doesnt; }
			return it.does;
		}
		return it.does;
	}

	it creation_should_allow_for_128_bits() {
		before_creation();
		try {
			Digest d = new Digest(0xDEADBEEF, 0x01234567, 0xDEADBEEF, 0x01234567);
			String s = d.getString();
			if(!(s == "deadbeef01234567deadbeef01234567")) {
				return it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Access Violation") { return it.doesnt; }
			return it.does;
		}
		return it.does;
	}

	it creation_should_allow_for_160_bits() {
		before_creation();
		try {
			Digest d = new Digest(0xDEADBEEF, 0x01234567, 0xDEADBEEF, 0x01234567, 0xDEADBEEF);
			String s = d.getString();
			if(!(s == "deadbeef01234567deadbeef01234567deadbeef")) {
				return it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Access Violation") { return it.doesnt; }
			return it.does;
		}
		return it.does;
	}

	it creation_should_allow_for_192_bits() {
		before_creation();
		try {
			Digest d = new Digest(0xDEADBEEF, 0x01234567, 0xDEADBEEF, 0x01234567, 0xDEADBEEF, 0x01234567);
			String s = d.getString();
			if(!(s == "deadbeef01234567deadbeef01234567deadbeef01234567")) {
				return it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Access Violation") { return it.doesnt; }
			return it.does;
		}
		return it.does;
	}

	done before_creation() {
	}

	it comparison_should_work_for_equals_overload() {
		before_comparison();
		try {
			Digest d1 = new Digest(0xDEADBEEF);
			Digest d2 = new Digest(0x01234567);
			Digest d3 = new Digest(0xDEADBEEF);
			if(!(d1 == d3)) {
				return it.doesnt;
			}
			if(d1 == d2) {
				return it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Access Violation") { return it.doesnt; }
			return it.does;
		}
		return it.does;
	}

	it comparison_should_work_for_equals_function() {
		before_comparison();
		try {
			Digest d1 = new Digest(0xDEADBEEF);
			Digest d2 = new Digest(0x01234567);
			Digest d3 = new Digest(0xDEADBEEF);
			if(!(d1.equals(d3))) {
				return it.doesnt;
			}
			if(d1.equals(d2)) {
				return it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Access Violation") { return it.doesnt; }
			return it.does;
		}
		return it.does;
	}

	done before_comparison() {
	}

	done before() {
	}

	this() {
		before();
	}

	static void test() {
		DigestTester tester = new DigestTester();

		Test test = new Test("Digest", "specs/hashes/digest.d");

		it result;

		test.logSubset("creation");

		tester = new DigestTester();

		result = tester.creation_should_allow_for_64_bits();
		test.logResult(result, "creation should allow for 64 bits", "9");

		tester = new DigestTester();

		result = tester.creation_should_allow_for_128_bits();
		test.logResult(result, "creation should allow for 128 bits", "16");

		tester = new DigestTester();

		result = tester.creation_should_allow_for_160_bits();
		test.logResult(result, "creation should allow for 160 bits", "23");

		tester = new DigestTester();

		result = tester.creation_should_allow_for_192_bits();
		test.logResult(result, "creation should allow for 192 bits", "30");

		test.logSubset("comparison");

		tester = new DigestTester();

		result = tester.comparison_should_work_for_equals_overload();
		test.logResult(result, "comparison should work for equals overload", "39");

		tester = new DigestTester();

		result = tester.comparison_should_work_for_equals_function();
		test.logResult(result, "comparison should work for equals function", "48");

		test.finish();
	}
}

import hashes.sha256;

class SHA256Tester {

	it hash_should_hash_as_expected_for_String_objects() {
		before_hash();
		try {
			String s = HashSHA256.hash(new String("The quick brown fox jumps over the lazy dog")).getString();
			if(!(s == "d7a8fbb307d7809469ca9abcb0082e4f8d5651e46d3cdb762d02d0bf37c9e592")) {
				return it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Access Violation") { return it.doesnt; }
			return it.does;
		}
		return it.does;
	}

	it hash_should_hash_as_expected_for_string_literals() {
		before_hash();
		try {
			String s = HashSHA256.hash("a").getString();
			if(!(s == "ca978112ca1bbdcafac231b39a23dc4da786eff8147c4e72b9807785afee48bb")) {
				return it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Access Violation") { return it.doesnt; }
			return it.does;
		}
		return it.does;
	}

	it hash_should_hash_the_empty_string() {
		before_hash();
		try {
			String s = HashSHA256.hash(new String("")).getString();
			if(!(s == "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855")) {
				return it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Access Violation") { return it.doesnt; }
			return it.does;
		}
		return it.does;
	}

	done before_hash() {
	}

	done before() {
	}

	this() {
		before();
	}

	static void test() {
		SHA256Tester tester = new SHA256Tester();

		Test test = new Test("SHA256", "specs/hashes/sha256.d");

		it result;

		test.logSubset("hash");

		tester = new SHA256Tester();

		result = tester.hash_should_hash_as_expected_for_String_objects();
		test.logResult(result, "hash should hash as expected for String objects", "9");

		tester = new SHA256Tester();

		result = tester.hash_should_hash_as_expected_for_string_literals();
		test.logResult(result, "hash should hash as expected for string literals", "14");

		tester = new SHA256Tester();

		result = tester.hash_should_hash_the_empty_string();
		test.logResult(result, "hash should hash the empty string", "19");

		test.finish();
	}
}

import utils.priorityqueue;

class PriorityQueueTester {

	it creation_should_work_as_expected() {
		before_creation();
		try {
			PriorityQueue!(int) queue = new PriorityQueue!(int)();
			if(queue is null) {
				return it.doesnt;
			}
			if(!(queue.length == 0)) {
				return it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Access Violation") { return it.doesnt; }
			return it.does;
		}
		return it.does;
	}

	done before_creation() {
	}

	it add_should_add_an_item_to_an_empty_list() {
		before_add();
		try {
			PriorityQueue!(int) queue = new PriorityQueue!(int)();
			int item = 42;
			queue.add(item);
			if(!(queue.length == 1)) {
				return it.doesnt;
			}
			if(!(queue.peek() == item)) {
				return it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Access Violation") { return it.doesnt; }
			return it.does;
		}
		return it.does;
	}

	done before_add() {
	}

	it peek_should_return_the_first_item_in_min_heap() {
		before_peek();
		try {
			auto queue = new PriorityQueue!(int, MinHeap);
			queue.add(10);
			queue.add(4);
			queue.add(15);
			if(!(queue.length == 3)) {
				return it.doesnt;
			}
			if(!(queue.peek() == 4)) {
				return it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Access Violation") { return it.doesnt; }
			return it.does;
		}
		return it.does;
	}

	it peek_should_return_the_first_item_in_max_heap() {
		before_peek();
		try {
			auto queue = new PriorityQueue!(int, MaxHeap);
			queue.add(10);
			queue.add(4);
			queue.add(15);
			if(!(queue.length == 3)) {
				return it.doesnt;
			}
			if(!(queue.peek() == 15)) {
				return it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Access Violation") { return it.doesnt; }
			return it.does;
		}
		return it.does;
	}

	done before_peek() {
	}

	it remove_should_remove_the_first_item_in_min_heap() {
		before_remove();
		try {
			auto queue = new PriorityQueue!(int, MinHeap);
			queue.add(10);
			queue.add(4);
			queue.add(15);
			if(!(queue.length == 3)) {
				return it.doesnt;
			}
			if(!(queue.remove() == 4)) {
				return it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Access Violation") { return it.doesnt; }
			return it.does;
		}
		return it.does;
	}

	it remove_should_remove_the_first_item_in_max_heap() {
		before_remove();
		try {
			auto queue = new PriorityQueue!(int, MaxHeap);
			queue.add(10);
			queue.add(4);
			queue.add(15);
			if(!(queue.length == 3)) {
				return it.doesnt;
			}
			if(!(queue.remove() == 15)) {
				return it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Access Violation") { return it.doesnt; }
			return it.does;
		}
		return it.does;
	}

	done before_remove() {
	}

	it length_should_be_zero_for_an_empty_list() {
		before_length();
		try {
			auto queue = new PriorityQueue!(int);
			if(!(queue.empty)) {
				return it.doesnt;
			}
			if(!(queue.length == 0)) {
				return it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Access Violation") { return it.doesnt; }
			return it.does;
		}
		return it.does;
	}

	done before_length() {
	}

	it clear_should_result_in_an_empty_list() {
		before_clear();
		try {
			auto queue = new PriorityQueue!(int);
			queue.add(15);
			queue.add(10);
			queue.add(24);
			if(queue.length == 0) {
				return it.doesnt;
			}
			if(queue.empty()) {
				return it.doesnt;
			}
			queue.clear();
			if(!(queue.length == 0)) {
				return it.doesnt;
			}
			if(!(queue.empty())) {
				return it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Access Violation") { return it.doesnt; }
			return it.does;
		}
		return it.does;
	}

	done before_clear() {
	}

	it empty_should_be_true_when_the_list_is_empty() {
		before_empty();
		try {
			auto queue = new PriorityQueue!(int);
			queue.add(10);
			if(queue.empty()) {
				return it.doesnt;
			}
			queue.remove();
			if(!(queue.empty())) {
				return it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Access Violation") { return it.doesnt; }
			return it.does;
		}
		return it.does;
	}

	it empty_should_be_true_for_a_new_list() {
		before_empty();
		try {
			auto queue = new PriorityQueue!(int);
			if(!(queue.empty())) {
				return it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Access Violation") { return it.doesnt; }
			return it.does;
		}
		return it.does;
	}

	done before_empty() {
	}

	done before() {
	}

	this() {
		before();
	}

	static void test() {
		PriorityQueueTester tester = new PriorityQueueTester();

		Test test = new Test("PriorityQueue", "specs/utils/priorityqueue.d");

		it result;

		test.logSubset("creation");

		tester = new PriorityQueueTester();

		result = tester.creation_should_work_as_expected();
		test.logResult(result, "creation should work as expected", "7");

		test.logSubset("add");

		tester = new PriorityQueueTester();

		result = tester.add_should_add_an_item_to_an_empty_list();
		test.logResult(result, "add should add an item to an empty list", "15");

		test.logSubset("peek");

		tester = new PriorityQueueTester();

		result = tester.peek_should_return_the_first_item_in_min_heap();
		test.logResult(result, "peek should return the first item in min heap", "25");

		tester = new PriorityQueueTester();

		result = tester.peek_should_return_the_first_item_in_max_heap();
		test.logResult(result, "peek should return the first item in max heap", "34");

		test.logSubset("remove");

		tester = new PriorityQueueTester();

		result = tester.remove_should_remove_the_first_item_in_min_heap();
		test.logResult(result, "remove should remove the first item in min heap", "45");

		tester = new PriorityQueueTester();

		result = tester.remove_should_remove_the_first_item_in_max_heap();
		test.logResult(result, "remove should remove the first item in max heap", "54");

		test.logSubset("length");

		tester = new PriorityQueueTester();

		result = tester.length_should_be_zero_for_an_empty_list();
		test.logResult(result, "length should be zero for an empty list", "65");

		test.logSubset("clear");

		tester = new PriorityQueueTester();

		result = tester.clear_should_result_in_an_empty_list();
		test.logResult(result, "clear should result in an empty list", "73");

		test.logSubset("empty");

		tester = new PriorityQueueTester();

		result = tester.empty_should_be_true_when_the_list_is_empty();
		test.logResult(result, "empty should be true when the list is empty", "89");

		tester = new PriorityQueueTester();

		result = tester.empty_should_be_true_for_a_new_list();
		test.logResult(result, "empty should be true for a new list", "97");

		test.finish();
	}
}


class Tests {
	static void testUnicode() {
		UnicodeTester.test();
	}

	static void testRegex() {
		RegexTester.test();
	}

	static void testString() {
		StringTester.test();
	}

	static void testSHA224() {
		SHA224Tester.test();
	}

	static void testMD5() {
		MD5Tester.test();
	}

	static void testSHA1() {
		SHA1Tester.test();
	}

	static void testDigest() {
		DigestTester.test();
	}

	static void testSHA256() {
		SHA256Tester.test();
	}

	static void testPriorityQueue() {
		PriorityQueueTester.test();
	}

	static void testAll() {
		testUnicode();
		testRegex();
		testString();
		testSHA224();
		testMD5();
		testSHA1();
		testDigest();
		testSHA256();
		testPriorityQueue();
		Test.done();
	}
}

