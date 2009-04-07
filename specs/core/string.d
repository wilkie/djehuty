module specs.core.string;

import testing.support;

import core.string;

describe string()
{
	describe creation()
	{
		it should_handle_literals()
		{
			String str = new String("new string");
			should(str == "new string");
		}

		it should_handle_integers()
		{
			String str = new String(123);
			should(str == "123");
		}

		it should_handle_formatting()
		{
			String str = new String("%x%d!!!", 0xdead, 1234);
			should(str == "dead1234!!!");
		}

		it should_handle_string_objects()
		{
			String str = new String("hello");
			String str2 = new String(str);
			should(str == "hello");
		}
	}

	describe trim()
	{
		it should_trim_off_whitespace()
		{
			String str = new String("    \t\t bah \n\n\r\t");
			str = str.trim();
			should(str == "bah");
		}
	}

	describe length()
	{
		it should_account_for_combining_marks()
		{
			String str = new String("hello\u0364world");
			should(str.length == 10);
		}

		it should_return_the_number_of_characters()
		{
			String str = new String("hello world");
			should(str.length == 11);
		}

		it should_not_fail_on_an_empty_string()
		{
			String str = new String("");
			should(str.length == 0);
		}
	}

	describe append()
	{
		it should_concatenate_a_string_object()
		{
			String str = new String("hello ");
			String str2 = new String("world");

			str.append(str2);

			should(str == "hello world");
		}

		it should_concatenate_a_string_literal()
		{
			String str = new String("hello ");
			str.append("world");

			should(str == "hello world");
		}

		it should_concatenate_a_formatted_string_literal()
		{
			String str = new String("hello ");
			str.append("%x%d!!!", 0xdead, 1234);

			should(str == "hello dead1234!!!");
		}

		it should_not_fail_on_an_empty_string_object()
		{
			String str = new String("hello ");
			String str2 = new String("");
			str.append(str2);

			should(str == "hello ");
		}

		it should_not_fail_on_an_empty_string_literal()
		{
			String str = new String("hello ");
			str.append("");

			should(str == "hello ");
		}

		it should_throw_an_exception_for_null_string_object()
		{
			shouldThrow("Access Violation");

			String str = new String("hello ");
			String str2;

			str.append(str2);
		}
	}

	describe toLowercase()
	{
		it should_work_as_expected()
		{
			String str = new String("HelLo WoRLD");
			str = str.toLowercase();

			should(str == "hello world");
		}

		it should_not_fail_on_an_empty_string()
		{
			String str = new String("");
			str = str.toLowercase();

			should(str == "");
		}
	}

	describe toUppercase()
	{
		it should_work_as_expected()
		{
			String str = new String("HelLo WoRLD");
			str = str.toUppercase();

			should(str == "HELLO WORLD");
		}

		it should_not_fail_on_an_empty_string()
		{
			String str = new String("");
			str = str.toUppercase();

			should(str == "");
		}
	}
}
