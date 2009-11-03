module specs.core.string;

import testing.support;

import core.string;

describe string() {
	describe creation() {
		it should_handle_literals() {
			String str = new String("new string");
			should(str == "new string");
		}

		it should_handle_integers() {
			String str = new String(123);
			should(str == "123");
		}

		it should_handle_formatting() {
			String str = new String("%x%d!!!", 0xdead, 1234);
			should(str == "dead1234!!!");
		}

		it should_handle_string_objects() {
			String str = new String("hello");
			String str2 = new String(str);
			should(str == "hello");
		}
	}

	describe trim() {
		it should_trim_off_whitespace() {
			String str = new String("    \t\t bah \n\n\r\t");
			str = str.trim();
			should(str == "bah");
		}
	}

	describe length() {
		it should_account_for_combining_marks() {
			String str = new String("hello\u0364world");
			should(str.length == 10);
		}

		it should_return_the_number_of_characters() {
			String str = new String("hello world");
			should(str.length == 11);
		}

		it should_not_fail_on_an_empty_string() {
			String str = new String("");
			should(str.length == 0);
		}
	}

	describe append() {
		it should_concatenate_a_string_object() {
			String str = new String("hello ");
			String str2 = new String("world");

			str.append(str2);

			should(str == "hello world");
		}

		it should_concatenate_a_string_literal() {
			String str = new String("hello ");
			str.append("world");

			should(str == "hello world");
		}

		it should_concatenate_a_formatted_string_literal() {
			String str = new String("hello ");
			str.append("%x%d!!!", 0xdead, 1234);

			should(str == "hello dead1234!!!");
		}

		it should_not_fail_on_an_empty_string_object() {
			String str = new String("hello ");
			String str2 = new String("");
			str.append(str2);

			should(str == "hello ");
		}

		it should_not_fail_on_an_empty_string_literal() {
			String str = new String("hello ");
			str.append("");

			should(str == "hello ");
		}

		it should_throw_an_exception_for_null_string_object() {
			shouldThrow("Access Violation");

			String str = new String("hello ");
			String str2;

			str.append(str2);
		}
	}

	describe toLowercase() {
		it should_work_as_expected() {
			String str = new String("HelLo WoRLD");
			str = str.toLowercase();

			should(str == "hello world");
		}

		it should_not_fail_on_an_empty_string() {
			String str = new String("");
			str = str.toLowercase();

			should(str == "");
		}
	}

	describe toUppercase() {
		it should_work_as_expected() {
			String str = new String("HelLo WoRLD");
			str = str.toUppercase();

			should(str == "HELLO WORLD");
		}

		it should_not_fail_on_an_empty_string() {
			String str = new String("");
			str = str.toUppercase();

			should(str == "");
		}
	}

	describe find() {
		it should_work_as_expected() {
			String str = new String("foobar");
			String toFind = new String("oob");
			int pos = str.find(toFind);

			should(pos == 1);
		}

		it should_fail_as_expected() {
			String str = new String("foobar");
			String toFind = new String("boo");
			int pos = str.find(toFind);

			should(pos == -1);
		}

		it should_work_at_the_beginning_of_the_string() {
			String str = new String("foobar");
			String toFind = new String("foo");
			int pos = str.find(toFind);

			should(pos == 0);
		}

		it should_work_at_the_end_of_the_string() {
			String str = new String("foobar");
			String toFind = new String("bar");
			int pos = str.find(toFind);

			should(pos == 3);
		}
	}

	describe insertAt() {
		it should_insert_a_string_object() {
			String str = new String("foobaz");
			String str2 = new String("bar");
			str = str.insertAt(str2, 3);
			should(str == "foobarbaz");
		}

		it should_insert_a_simple_string() {
			String str = new String("foobaz");
			str = str.insertAt("bar", 3);
			should(str == "foobarbaz");
		}

		it should_not_fail_on_position_zero() {
			String str = new String("barbaz");
			str = str.insertAt("foo", 0);
			should(str == "foobarbaz");
		}

		it should_not_fail_on_an_empty_string() {
			String str = new String("foobar");
			str = str.insertAt("", 0);
			should(str == "foobar");
		}

		it should_not_fail_on_position_outside_string() {
			String str = new String("foobar");
			str = str.insertAt("baz", str.length() + 1);
			should(str == "foobar");
		}
	}

	describe repeat() {
		it should_repeat_a_string_object() {
			String str = new String("foo");
			String str2 = String.repeat(str, 3);
			should(str2 == "foofoofoo")
		}

		it should_repeat_a_simple_string() {
			String str = String.repeat("foo", 3);
			should(str == "foofoofoo")
		}

		it should_not_fail_on_an_empty_string() {
			String str = String.repeat("", 3);
			should(str == "")
		}

		it should_not_fail_on_zero_iterations() {
			String str = String.repeat("foo", 0);
			should(str == "")
		}
	}
}
