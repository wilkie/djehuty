
/*
 * test.d
 *
 * Tests the specifications defined and parsed by dspec
 *
 */

module specs.test;

import testing.logic;

import djehuty;

import core.date;

class DateTester {

	it creation_should_create_with_current_date() {
		before_creation();
		it ret = it.does;
		try {
			Date d = new Date();
			if(d is null) {
				ret = it.doesnt;
			}
			if(!(d.year == 2010)) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			ret = it.doesnt;
		}
		return ret;
	}

	it creation_should_create_given_date() {
		before_creation();
		it ret = it.does;
		try {
			Date d = new Date(Month.January, 1, 2010);
			if(d is null) {
				ret = it.doesnt;
			}
			if(!(d.month() == Month.January)) {
				ret = it.doesnt;
			}
			if(!(d.year() == 2010)) {
				ret = it.doesnt;
			}
			if(!(d.day() == 1)) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			ret = it.doesnt;
		}
		return ret;
	}

	done before_creation() {
	}

	it dayOfWeek_should_return_the_day_of_the_week() {
		before_dayOfWeek();
		it ret = it.does;
		try {
			Date d = new Date(Month.January, 1, 2010);
			if(!(d.dayOfWeek() == Day.Friday)) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			ret = it.doesnt;
		}
		return ret;
	}

	done before_dayOfWeek() {
	}

	it monthMethods_should_return_the_month_value() {
		before_monthMethods();
		it ret = it.does;
		try {
			Date d = new Date(Month.January, 1, 2010);
			if(!(d.month() == Month.January)) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			ret = it.doesnt;
		}
		return ret;
	}

	it monthMethods_should_set_the_month_value() {
		before_monthMethods();
		it ret = it.does;
		try {
			Date d = new Date(Month.January, 1, 2010);
			d.month(Month.March);
			if(!(d.month() == Month.March)) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			ret = it.doesnt;
		}
		return ret;
	}

	done before_monthMethods() {
	}

	it dayMethods_should_return_the_day_value() {
		before_dayMethods();
		it ret = it.does;
		try {
			Date d = new Date(Month.January, 1, 2010);
			if(!(d.day() == 1)) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			ret = it.doesnt;
		}
		return ret;
	}

	it dayMethods_should_set_the_day_value() {
		before_dayMethods();
		it ret = it.does;
		try {
			Date d = new Date(Month.January, 1, 2010);
			d.day(21);
			if(!(d.day() == 21)) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			ret = it.doesnt;
		}
		return ret;
	}

	done before_dayMethods() {
	}

	it yearMethods_should_return_the_year_value() {
		before_yearMethods();
		it ret = it.does;
		try {
			Date d = new Date(Month.January, 1, 2010);
			if(!(d.year() == 2010)) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			ret = it.doesnt;
		}
		return ret;
	}

	it yearMethods_should_set_the_year_value() {
		before_yearMethods();
		it ret = it.does;
		try {
			Date d = new Date(Month.January, 1, 2010);
			d.year(2011);
			if(!(d.year() == 2011)) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			ret = it.doesnt;
		}
		return ret;
	}

	done before_yearMethods() {
	}

	done before() {
	}

	this() {
		before();
	}

	static void test() {
		DateTester tester = new DateTester();

		Test test = new Test("Date", "specs/core/date.d");

		it result;

		test.logSubset("creation");

		tester = new DateTester();

		result = tester.creation_should_create_with_current_date();
		test.logResult(result, "creation should create with current date", "7");

		tester = new DateTester();

		result = tester.creation_should_create_given_date();
		test.logResult(result, "creation should create given date", "12");

		test.logSubset("dayOfWeek");

		tester = new DateTester();

		result = tester.dayOfWeek_should_return_the_day_of_the_week();
		test.logResult(result, "dayOfWeek should return the day of the week", "22");

		test.logSubset("monthMethods");

		tester = new DateTester();

		result = tester.monthMethods_should_return_the_month_value();
		test.logResult(result, "monthMethods should return the month value", "29");

		tester = new DateTester();

		result = tester.monthMethods_should_set_the_month_value();
		test.logResult(result, "monthMethods should set the month value", "34");

		test.logSubset("dayMethods");

		tester = new DateTester();

		result = tester.dayMethods_should_return_the_day_value();
		test.logResult(result, "dayMethods should return the day value", "42");

		tester = new DateTester();

		result = tester.dayMethods_should_set_the_day_value();
		test.logResult(result, "dayMethods should set the day value", "47");

		test.logSubset("yearMethods");

		tester = new DateTester();

		result = tester.yearMethods_should_return_the_year_value();
		test.logResult(result, "yearMethods should return the year value", "55");

		tester = new DateTester();

		result = tester.yearMethods_should_set_the_year_value();
		test.logResult(result, "yearMethods should set the year value", "60");

		test.finish();
	}
}

import core.string;

class StringTester {

	it trim_should_handle_empty_string() {
		before_trim();
		it ret = it.does;
		try {
			if(!("".trim() == "")) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			ret = it.doesnt;
		}
		return ret;
	}

	it trim_should_handle_whitespace_on_left() {
		before_trim();
		it ret = it.does;
		try {
			if(!(" \t\nhello".trim() == "hello")) {
				ret = it.doesnt;
			}
			if(!(" hello".trim() == "hello")) {
				ret = it.doesnt;
			}
			if(!("\t\t\thello".trim() == "hello")) {
				ret = it.doesnt;
			}
			if(!("\n\n\nhello".trim() == "hello")) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			ret = it.doesnt;
		}
		return ret;
	}

	it trim_should_handle_whitespace_on_right() {
		before_trim();
		it ret = it.does;
		try {
			if(!("hello \t\n".trim() == "hello")) {
				ret = it.doesnt;
			}
			if(!("hello\t\t".trim() == "hello")) {
				ret = it.doesnt;
			}
			if(!("hello\n\n".trim() == "hello")) {
				ret = it.doesnt;
			}
			if(!("hello   ".trim() == "hello")) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			ret = it.doesnt;
		}
		return ret;
	}

	it trim_should_handle_whitespace_on_both_sides() {
		before_trim();
		it ret = it.does;
		try {
			if(!(" \t\nhello \t\n".trim() == "hello")) {
				ret = it.doesnt;
			}
			if(!("\t\t\thello\n".trim() == "hello")) {
				ret = it.doesnt;
			}
			if(!("\n\n\t\thello    \n".trim() == "hello")) {
				ret = it.doesnt;
			}
			if(!("     \t   hello \t\t\t\n\n\t ".trim() == "hello")) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			ret = it.doesnt;
		}
		return ret;
	}

	done before_trim() {
	}

	it split_should_work_on_empty_strings() {
		before_split();
		it ret = it.does;
		try {
			string[] foo1 = "".split('a');
			string[] foo2 = "".split("a");
			if(!(foo1[0] == "")) {
				ret = it.doesnt;
			}
			if(!(foo2[0] == "")) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			ret = it.doesnt;
		}
		return ret;
	}

	it split_should_work_on_characters() {
		before_split();
		it ret = it.does;
		try {
			string[] foo = "work.on.characters".split('.');
			if(!(foo.length == 3)) {
				ret = it.doesnt;
			}
			if(!(foo[0] == "work")) {
				ret = it.doesnt;
			}
			if(!(foo[1] == "on")) {
				ret = it.doesnt;
			}
			if(!(foo[2] == "characters")) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			ret = it.doesnt;
		}
		return ret;
	}

	it split_should_work_on_characters_with_delimiter_at_beginning() {
		before_split();
		it ret = it.does;
		try {
			string[] foo = ".work.a.b".split('.');
			if(!(foo.length == 4)) {
				ret = it.doesnt;
			}
			if(!(foo[0] == "")) {
				ret = it.doesnt;
			}
			if(!(foo[1] == "work")) {
				ret = it.doesnt;
			}
			if(!(foo[2] == "a")) {
				ret = it.doesnt;
			}
			if(!(foo[3] == "b")) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			ret = it.doesnt;
		}
		return ret;
	}

	it split_should_work_on_characters_with_delimiter_at_end() {
		before_split();
		it ret = it.does;
		try {
			string[] foo = "work.a.b.".split('.');
			if(!(foo.length == 4)) {
				ret = it.doesnt;
			}
			if(!(foo[0] == "work")) {
				ret = it.doesnt;
			}
			if(!(foo[1] == "a")) {
				ret = it.doesnt;
			}
			if(!(foo[2] == "b")) {
				ret = it.doesnt;
			}
			if(!(foo[3] == "")) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			ret = it.doesnt;
		}
		return ret;
	}

	it split_should_work_on_strings() {
		before_split();
		it ret = it.does;
		try {
			string[] foo = "work(on strings.foo)".split("( .)");
			if(!(foo.length == 5)) {
				ret = it.doesnt;
			}
			if(!(foo[0] == "work")) {
				ret = it.doesnt;
			}
			if(!(foo[1] == "on")) {
				ret = it.doesnt;
			}
			if(!(foo[2] == "strings")) {
				ret = it.doesnt;
			}
			if(!(foo[3] == "foo")) {
				ret = it.doesnt;
			}
			if(!(foo[4] == "")) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			ret = it.doesnt;
		}
		return ret;
	}

	done before_split() {
	}

	it nextInt_should_work_on_empty_strings() {
		before_nextInt();
		it ret = it.does;
		try {
			int foo;
			if(!("".nextInt(foo) == false)) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			ret = it.doesnt;
		}
		return ret;
	}

	it nextInt_should_return_the_next_int() {
		before_nextInt();
		it ret = it.does;
		try {
			int foo;
			bool returnVal = "123foo".nextInt(foo);
			if(!(foo == 123)) {
				ret = it.doesnt;
			}
			if(!(returnVal == true)) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			ret = it.doesnt;
		}
		return ret;
	}

	it nextInt_should_fail_when_there_is_not_a_next_int() {
		before_nextInt();
		it ret = it.does;
		try {
			int foo;
			bool returnVal = "foo123".nextInt(foo);
			if(!(returnVal == false)) {
				ret = it.doesnt;
			}
			if(!(foo == 0)) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			ret = it.doesnt;
		}
		return ret;
	}

	done before_nextInt() {
	}

	it substring_should_work_on_empty_strings() {
		before_substring();
		it ret = it.does;
		try {
			string foo = "";
			foo = foo.substring(0);
			if(!(foo == "")) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			ret = it.doesnt;
		}
		return ret;
	}

	it substring_should_work_for_start_larger_than_length() {
		before_substring();
		it ret = it.does;
		try {
			string foo = "abc";
			foo = foo.substring(4);
			if(!(foo == "")) {
				ret = it.doesnt;
			}
			foo = "abc".substring(3);
			if(!(foo == "")) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			ret = it.doesnt;
		}
		return ret;
	}

	it substring_should_work_for_start_at_zero_and_length_omitted() {
		before_substring();
		it ret = it.does;
		try {
			string foo = "abc";
			foo = foo.substring(0);
			if(!(foo == "abc")) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			ret = it.doesnt;
		}
		return ret;
	}

	it substring_should_work_for_start_at_zero_and_length_longer_than_string() {
		before_substring();
		it ret = it.does;
		try {
			string foo = "abc";
			foo = foo.substring(0, 4);
			if(!(foo == "abc")) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			ret = it.doesnt;
		}
		return ret;
	}

	it substring_should_work_for_start_at_zero_and_length_at_zero() {
		before_substring();
		it ret = it.does;
		try {
			string foo = "abc";
			foo = foo.substring(0,0);
			if(!(foo == "")) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			ret = it.doesnt;
		}
		return ret;
	}

	it substring_should_work_for_start_at_zero_and_length_within_string() {
		before_substring();
		it ret = it.does;
		try {
			string foo1 = "abc".substring(0, 1);
			string foo2 = "abc".substring(0, 2);
			if(!(foo1 == "a")) {
				ret = it.doesnt;
			}
			if(!(foo2 == "ab")) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			ret = it.doesnt;
		}
		return ret;
	}

	it substring_should_work_for_start_within_string_and_length_omitted() {
		before_substring();
		it ret = it.does;
		try {
			string foo1 = "abc".substring(1);
			string foo2 = "abc".substring(2);
			if(!(foo1 == "bc")) {
				ret = it.doesnt;
			}
			if(!(foo2 == "c")) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			ret = it.doesnt;
		}
		return ret;
	}

	it substring_should_work_for_start_within_string_and_length_longer_than_string() {
		before_substring();
		it ret = it.does;
		try {
			string foo1 = "abc".substring(1, 4);
			string foo2 = "abc".substring(2, 4);
			string foo3 = "abc".substring(3, 4);
			if(!(foo1 == "bc")) {
				ret = it.doesnt;
			}
			if(!(foo2 == "c")) {
				ret = it.doesnt;
			}
			if(!(foo3 == "")) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			ret = it.doesnt;
		}
		return ret;
	}

	it substring_should_work_for_start_within_string_and_length_at_zero() {
		before_substring();
		it ret = it.does;
		try {
			string foo1 = "abc".substring(1,0);
			string foo2 = "abc".substring(2,0);
			string foo3 = "abc".substring(3,0);
			if(!(foo1 == "")) {
				ret = it.doesnt;
			}
			if(!(foo2 == "")) {
				ret = it.doesnt;
			}
			if(!(foo3 == "")) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			ret = it.doesnt;
		}
		return ret;
	}

	done before_substring() {
	}

	it replace_should_work_on_empty_strings() {
		before_replace();
		it ret = it.does;
		try {
			string foo = "".replace('a', 'b');
			if(!(foo == "")) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			ret = it.doesnt;
		}
		return ret;
	}

	it replace_should_work_as_expected() {
		before_replace();
		it ret = it.does;
		try {
			string foo = "abcaefahi".replace('a', 'x');
			if(!(foo == "xbcxefxhi")) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			ret = it.doesnt;
		}
		return ret;
	}

	done before_replace() {
	}

	it find_should_work_on_empty_strings() {
		before_find();
		it ret = it.does;
		try {
			int foo = "".find("foo", 0);
			if(!(foo == -1)) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			ret = it.doesnt;
		}
		return ret;
	}

	it find_should_fail_on_finding_empty_strings() {
		before_find();
		it ret = it.does;
		try {
			int foo1 = "".find("", 0);
			int foo2 = "abc".find("", 0);
			if(!(foo1 == -1)) {
				ret = it.doesnt;
			}
			if(!(foo2 == -1)) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			ret = it.doesnt;
		}
		return ret;
	}

	it find_should_work_when_start_is_omitted() {
		before_find();
		it ret = it.does;
		try {
			int foo1 = "abcdebc".find("bc");
			int foo2 = "abcdebc".find("ce");
			if(!(foo1 == 1)) {
				ret = it.doesnt;
			}
			if(!(foo2 == -1)) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			ret = it.doesnt;
		}
		return ret;
	}

	it find_should_work_when_search_string_is_at_beginning() {
		before_find();
		it ret = it.does;
		try {
			int foo = "abcd".find("ab");
			if(!(foo == 0)) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			ret = it.doesnt;
		}
		return ret;
	}

	it find_should_work_when_search_string_is_at_end() {
		before_find();
		it ret = it.does;
		try {
			int foo = "abcd".find("cd");
			if(!(foo == 2)) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			ret = it.doesnt;
		}
		return ret;
	}

	it find_should_work_when_search_string_is_within_string() {
		before_find();
		it ret = it.does;
		try {
			int foo = "abcd".find("bc");
			if(!(foo == 1)) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			ret = it.doesnt;
		}
		return ret;
	}

	it find_should_work_when_start_is_given() {
		before_find();
		it ret = it.does;
		try {
			int foo1 = "abcdab".find("ab", 0);
			int foo2 = "abcdab".find("ab", 1);
			if(!(foo1 == 0)) {
				ret = it.doesnt;
			}
			if(!(foo2 == 4)) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			ret = it.doesnt;
		}
		return ret;
	}

	done before_find() {
	}

	it findReverse_should_work_on_empty_strings() {
		before_findReverse();
		it ret = it.does;
		try {
			int foo = "".findReverse("foo", 0);
			if(!(foo == -1)) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			ret = it.doesnt;
		}
		return ret;
	}

	it findReverse_should_fail_on_finding_empty_strings() {
		before_findReverse();
		it ret = it.does;
		try {
			int foo1 = "".findReverse("", 0);
			int foo2 = "abc".findReverse("", 0);
			if(!(foo1 == -1)) {
				ret = it.doesnt;
			}
			if(!(foo2 == -1)) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			ret = it.doesnt;
		}
		return ret;
	}

	it findReverse_should_work_when_start_is_omitted() {
		before_findReverse();
		it ret = it.does;
		try {
			int foo1 = "abcdebc".findReverse("bc");
			int foo2 = "abcdebc".findReverse("ce");
			if(!(foo1 == 5)) {
				ret = it.doesnt;
			}
			if(!(foo2 == -1)) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			ret = it.doesnt;
		}
		return ret;
	}

	it findReverse_should_work_when_search_string_is_at_beginning() {
		before_findReverse();
		it ret = it.does;
		try {
			int foo = "abcd".findReverse("ab");
			if(!(foo == 0)) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			ret = it.doesnt;
		}
		return ret;
	}

	it findReverse_should_work_when_search_string_is_at_end() {
		before_findReverse();
		it ret = it.does;
		try {
			int foo = "abcd".findReverse("cd");
			if(!(foo == 2)) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			ret = it.doesnt;
		}
		return ret;
	}

	it findReverse_should_work_when_search_string_is_within_string() {
		before_findReverse();
		it ret = it.does;
		try {
			int foo = "abcd".findReverse("bc");
			if(!(foo == 1)) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			ret = it.doesnt;
		}
		return ret;
	}

	it findReverse_should_work_when_start_is_given() {
		before_findReverse();
		it ret = it.does;
		try {
			int foo1 = "abcdabcd".findReverse("ab", 0);
			int foo2 = "abcdabcd".findReverse("ab", 2);
			int foo3 = "abcdabcd".findReverse("ab", 6);
			if(!(foo1 == -1)) {
				ret = it.doesnt;
			}
			if(!(foo2 == 0)) {
				ret = it.doesnt;
			}
			if(!(foo3 == 4)) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			ret = it.doesnt;
		}
		return ret;
	}

	done before_findReverse() {
	}

	it times_should_work_on_empty_strings() {
		before_times();
		it ret = it.does;
		try {
			if(!("".times(4) == "")) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			ret = it.doesnt;
		}
		return ret;
	}

	it times_should_return_empty_string_with_amount_being_zero() {
		before_times();
		it ret = it.does;
		try {
			if(!("abc".times(0) == "")) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			ret = it.doesnt;
		}
		return ret;
	}

	it times_should_work_with_identity() {
		before_times();
		it ret = it.does;
		try {
			if(!("abc".times(1) == "abc")) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			ret = it.doesnt;
		}
		return ret;
	}

	it times_should_work_as_expected() {
		before_times();
		it ret = it.does;
		try {
			if(!("abc".times(3) == "abcabcabc")) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			ret = it.doesnt;
		}
		return ret;
	}

	done before_times() {
	}

	it format_should_work_on_empty_strings() {
		before_format();
		it ret = it.does;
		try {
			if(!("".format() == "")) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			ret = it.doesnt;
		}
		return ret;
	}

	it format_should_work_on_d_specifier() {
		before_format();
		it ret = it.does;
		try {
			if(!("a{d}b".format(4) == "a4b")) {
				ret = it.doesnt;
			}
			if(!("a{D}b".format(4) == "a4b")) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			ret = it.doesnt;
		}
		return ret;
	}

	it format_should_work_on_x_specifier() {
		before_format();
		it ret = it.does;
		try {
			if(!("a{x}b".format(10) == "aab")) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			ret = it.doesnt;
		}
		return ret;
	}

	it format_should_work_with_d_specifier_with_width() {
		before_format();
		it ret = it.does;
		try {
			if(!("a{d8}b".format(4) == "a00000004b")) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			ret = it.doesnt;
		}
		return ret;
	}

	it format_should_work_with_x_specifier_with_width() {
		before_format();
		it ret = it.does;
		try {
			if(!("a{x8}b".format(10) == "a0000000ab")) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			ret = it.doesnt;
		}
		return ret;
	}

	it format_should_work_on_X_specifier() {
		before_format();
		it ret = it.does;
		try {
			if(!("a{X8}b".format(10) == "a0000000Ab")) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			ret = it.doesnt;
		}
		return ret;
	}

	it format_should_work_when_specifier_is_at_beginning() {
		before_format();
		it ret = it.does;
		try {
			if(!("{d}xxx".format(4) == "4xxx")) {
				ret = it.doesnt;
			}
			if(!("{x}xxx".format(10) == "axxx")) {
				ret = it.doesnt;
			}
			if(!("{X}xxx".format(10) == "Axxx")) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			ret = it.doesnt;
		}
		return ret;
	}

	it format_should_work_when_specifier_is_at_end() {
		before_format();
		it ret = it.does;
		try {
			if(!("xxx{d}".format(4) == "xxx4")) {
				ret = it.doesnt;
			}
			if(!("xxx{x}".format(10) == "xxxa")) {
				ret = it.doesnt;
			}
			if(!("xxx{X}".format(10) == "xxxA")) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			ret = it.doesnt;
		}
		return ret;
	}

	it format_should_work_when_specifier_is_alone() {
		before_format();
		it ret = it.does;
		try {
			if(!("{d}".format(4) == "4")) {
				ret = it.doesnt;
			}
			if(!("{x}".format(10) == "a")) {
				ret = it.doesnt;
			}
			if(!("{X}".format(10) == "A")) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			ret = it.doesnt;
		}
		return ret;
	}

	it format_should_work_with_two_specifiers_in_a_row() {
		before_format();
		it ret = it.does;
		try {
			if(!("{d}{d}".format(4,5) == "45")) {
				ret = it.doesnt;
			}
			if(!("{x8}{x8}".format(10,11) == "0000000a0000000b")) {
				ret = it.doesnt;
			}
			if(!("{x8}{X8}".format(10,11) == "0000000a0000000B")) {
				ret = it.doesnt;
			}
			if(!("{x}{d}".format(10,4) == "a4")) {
				ret = it.doesnt;
			}
			if(!("{X}{d}".format(10,4) == "A4")) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			ret = it.doesnt;
		}
		return ret;
	}

	it format_should_work_with_empty_specifier() {
		before_format();
		it ret = it.does;
		try {
			if(!("{}".format("hello") == "hello")) {
				ret = it.doesnt;
			}
			if(!("aaa{}bbb{}ccc".format(1,"f") == "aaa1bbbfccc")) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			ret = it.doesnt;
		}
		return ret;
	}

	it format_should_work_with_position_specifier() {
		before_format();
		it ret = it.does;
		try {
			if(!("{1}{0}".format('a', 'b') == "ba")) {
				ret = it.doesnt;
			}
			if(!("aaa{0}aaa{1}bbb{0}bbb{1}ccc".format('a', 'b') == "aaaaaaabbbbabbbbccc")) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			ret = it.doesnt;
		}
		return ret;
	}

	it format_should_fail_with_position_out_of_bounds() {
		before_format();
		it ret = it.does;
		try {
			format("{0}{1}{2}",1,2);
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Invalid Format String") { ret = it.doesnt; }
			ret = it.does;
		}
		return ret;
	}

	done before_format() {
	}

	it uppercase_should_work_on_empty_strings() {
		before_uppercase();
		it ret = it.does;
		try {
			if(!("".uppercase() == "")) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Invalid Format String") { ret = it.doesnt; }
			ret = it.does;
		}
		return ret;
	}

	it uppercase_should_work_as_expected() {
		before_uppercase();
		it ret = it.does;
		try {
			string foo = "abc123dEFg";
			if(!(foo.uppercase() == "ABC123DEFG")) {
				ret = it.doesnt;
			}
			if(!(foo == "abc123dEFg")) {
				ret = it.doesnt;
			}
			if(!("123".uppercase() == "123")) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Invalid Format String") { ret = it.doesnt; }
			ret = it.does;
		}
		return ret;
	}

	done before_uppercase() {
	}

	it lowercase_should_work_on_empty_strings() {
		before_lowercase();
		it ret = it.does;
		try {
			if(!("".lowercase() == "")) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Invalid Format String") { ret = it.doesnt; }
			ret = it.does;
		}
		return ret;
	}

	it lowercase_should_work_as_expected() {
		before_lowercase();
		it ret = it.does;
		try {
			string foo = "aBC123dEFg";
			if(!(foo.lowercase() == "abc123defg")) {
				ret = it.doesnt;
			}
			if(!(foo == "aBC123dEFg")) {
				ret = it.doesnt;
			}
			if(!("123".uppercase() == "123")) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Invalid Format String") { ret = it.doesnt; }
			ret = it.does;
		}
		return ret;
	}

	done before_lowercase() {
	}

	it charAt_should_fail_on_empty_strings() {
		before_charAt();
		it ret = it.does;
		try {
			string foo = "".charAt(0);
			if(!(foo is null)) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Invalid Format String") { ret = it.doesnt; }
			ret = it.does;
		}
		return ret;
	}

	it charAt_should_work_for_normal_strings() {
		before_charAt();
		it ret = it.does;
		try {
			string foo = "abc";
			if(!(foo.charAt(0) == "a")) {
				ret = it.doesnt;
			}
			if(!(foo.charAt(1) == "b")) {
				ret = it.doesnt;
			}
			if(!(foo.charAt(2) == "c")) {
				ret = it.doesnt;
			}
			if(!(foo.charAt(3) is null)) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Invalid Format String") { ret = it.doesnt; }
			ret = it.does;
		}
		return ret;
	}

	it charAt_should_account_for_combining_marks() {
		before_charAt();
		it ret = it.does;
		try {
			string foo = "he\u0364llo";
			if(!(foo.charAt(0) == "h")) {
				ret = it.doesnt;
			}
			if(!(foo.charAt(1) == "e\u0364")) {
				ret = it.doesnt;
			}
			if(!(foo.charAt(2) == "l")) {
				ret = it.doesnt;
			}
			if(!(foo.charAt(3) == "l")) {
				ret = it.doesnt;
			}
			if(!(foo.charAt(4) == "o")) {
				ret = it.doesnt;
			}
			if(!(foo.charAt(5) is null)) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Invalid Format String") { ret = it.doesnt; }
			ret = it.does;
		}
		return ret;
	}

	done before_charAt() {
	}

	it insertAt_should_work_on_empty_strings() {
		before_insertAt();
		it ret = it.does;
		try {
			string foo = "";
			string f2 = foo.insertAt("abc", 0);
			if(!(foo == "")) {
				ret = it.doesnt;
			}
			if(!(f2 == "abc")) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Invalid Format String") { ret = it.doesnt; }
			ret = it.does;
		}
		return ret;
	}

	it insertAt_should_fail_when_index_is_out_of_bounds() {
		before_insertAt();
		it ret = it.does;
		try {
			string foo = "abc";
			string f2 = foo.insertAt("def", 4);
			if(!(foo == "abc")) {
				ret = it.doesnt;
			}
			if(!(f2 is null)) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Invalid Format String") { ret = it.doesnt; }
			ret = it.does;
		}
		return ret;
	}

	it insertAt_should_work_when_index_is_zero() {
		before_insertAt();
		it ret = it.does;
		try {
			string foo = "abc";
			string f2 = foo.insertAt("def", 0);
			if(!(foo == "abc")) {
				ret = it.doesnt;
			}
			if(!(f2 == "defabc")) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Invalid Format String") { ret = it.doesnt; }
			ret = it.does;
		}
		return ret;
	}

	it insertAt_should_work_when_index_is_utflen() {
		before_insertAt();
		it ret = it.does;
		try {
			string foo = "abc";
			string f2 = foo.insertAt("def", foo.utflen());
			if(!(foo == "abc")) {
				ret = it.doesnt;
			}
			if(!(f2 == "abcdef")) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Invalid Format String") { ret = it.doesnt; }
			ret = it.does;
		}
		return ret;
	}

	it insertAt_should_work_when_index_is_within_string() {
		before_insertAt();
		it ret = it.does;
		try {
			string foo = "abc";
			string f2 = foo.insertAt("def", 1);
			string f3 = foo.insertAt("def", 2);
			if(!(foo == "abc")) {
				ret = it.doesnt;
			}
			if(!(f2 == "adefbc")) {
				ret = it.doesnt;
			}
			if(!(f3 == "abdefc")) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Invalid Format String") { ret = it.doesnt; }
			ret = it.does;
		}
		return ret;
	}

	it insertAt_should_account_for_combining_marks() {
		before_insertAt();
		it ret = it.does;
		try {
			string foo = "he\u0364llo";
			string f1 = foo.insertAt("def", 0);
			string f2 = foo.insertAt("def", 1);
			string f3 = foo.insertAt("def", 2);
			string f4 = foo.insertAt("def", 3);
			string f5 = foo.insertAt("def", 4);
			string f6 = foo.insertAt("def", 5);
			string f7 = foo.insertAt("def", 6);
			if(!(foo == "he\u0364llo")) {
				ret = it.doesnt;
			}
			if(!(f1 == "defhe\u0364llo")) {
				ret = it.doesnt;
			}
			if(!(f2 == "hdefe\u0364llo")) {
				ret = it.doesnt;
			}
			if(!(f3 == "he\u0364defllo")) {
				ret = it.doesnt;
			}
			if(!(f4 == "he\u0364ldeflo")) {
				ret = it.doesnt;
			}
			if(!(f5 == "he\u0364lldefo")) {
				ret = it.doesnt;
			}
			if(!(f6 == "he\u0364llodef")) {
				ret = it.doesnt;
			}
			if(!(f7 is null)) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Invalid Format String") { ret = it.doesnt; }
			ret = it.does;
		}
		return ret;
	}

	done before_insertAt() {
	}

	it utflen_should_work_on_empty_strings() {
		before_utflen();
		it ret = it.does;
		try {
			if(!("".utflen() == 0)) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Invalid Format String") { ret = it.doesnt; }
			ret = it.does;
		}
		return ret;
	}

	it utflen_should_work_on_normal_strings() {
		before_utflen();
		it ret = it.does;
		try {
			if(!("abc".utflen() == 3)) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Invalid Format String") { ret = it.doesnt; }
			ret = it.does;
		}
		return ret;
	}

	it utflen_should_account_for_combining_marks() {
		before_utflen();
		it ret = it.does;
		try {
			string foo = "hello\u0364world";
			if(!(foo.utflen() == 10)) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Invalid Format String") { ret = it.doesnt; }
			ret = it.does;
		}
		return ret;
	}

	done before_utflen() {
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

		test.logSubset("trim");

		tester = new StringTester();

		result = tester.trim_should_handle_empty_string();
		test.logResult(result, "trim should handle empty string", "9");

		tester = new StringTester();

		result = tester.trim_should_handle_whitespace_on_left();
		test.logResult(result, "trim should handle whitespace on left", "13");

		tester = new StringTester();

		result = tester.trim_should_handle_whitespace_on_right();
		test.logResult(result, "trim should handle whitespace on right", "20");

		tester = new StringTester();

		result = tester.trim_should_handle_whitespace_on_both_sides();
		test.logResult(result, "trim should handle whitespace on both sides", "27");

		test.logSubset("split");

		tester = new StringTester();

		result = tester.split_should_work_on_empty_strings();
		test.logResult(result, "split should work on empty strings", "36");

		tester = new StringTester();

		result = tester.split_should_work_on_characters();
		test.logResult(result, "split should work on characters", "43");

		tester = new StringTester();

		result = tester.split_should_work_on_characters_with_delimiter_at_beginning();
		test.logResult(result, "split should work on characters with delimiter at beginning", "51");

		tester = new StringTester();

		result = tester.split_should_work_on_characters_with_delimiter_at_end();
		test.logResult(result, "split should work on characters with delimiter at end", "60");

		tester = new StringTester();

		result = tester.split_should_work_on_strings();
		test.logResult(result, "split should work on strings", "69");

		test.logSubset("nextInt");

		tester = new StringTester();

		result = tester.nextInt_should_work_on_empty_strings();
		test.logResult(result, "nextInt should work on empty strings", "81");

		tester = new StringTester();

		result = tester.nextInt_should_return_the_next_int();
		test.logResult(result, "nextInt should return the next int", "86");

		tester = new StringTester();

		result = tester.nextInt_should_fail_when_there_is_not_a_next_int();
		test.logResult(result, "nextInt should fail when there is not a next int", "93");

		test.logSubset("substring");

		tester = new StringTester();

		result = tester.substring_should_work_on_empty_strings();
		test.logResult(result, "substring should work on empty strings", "102");

		tester = new StringTester();

		result = tester.substring_should_work_for_start_larger_than_length();
		test.logResult(result, "substring should work for start larger than length", "108");

		tester = new StringTester();

		result = tester.substring_should_work_for_start_at_zero_and_length_omitted();
		test.logResult(result, "substring should work for start at zero and length omitted", "116");

		tester = new StringTester();

		result = tester.substring_should_work_for_start_at_zero_and_length_longer_than_string();
		test.logResult(result, "substring should work for start at zero and length longer than string", "122");

		tester = new StringTester();

		result = tester.substring_should_work_for_start_at_zero_and_length_at_zero();
		test.logResult(result, "substring should work for start at zero and length at zero", "128");

		tester = new StringTester();

		result = tester.substring_should_work_for_start_at_zero_and_length_within_string();
		test.logResult(result, "substring should work for start at zero and length within string", "134");

		tester = new StringTester();

		result = tester.substring_should_work_for_start_within_string_and_length_omitted();
		test.logResult(result, "substring should work for start within string and length omitted", "141");

		tester = new StringTester();

		result = tester.substring_should_work_for_start_within_string_and_length_longer_than_string();
		test.logResult(result, "substring should work for start within string and length longer than string", "148");

		tester = new StringTester();

		result = tester.substring_should_work_for_start_within_string_and_length_at_zero();
		test.logResult(result, "substring should work for start within string and length at zero", "157");

		test.logSubset("replace");

		tester = new StringTester();

		result = tester.replace_should_work_on_empty_strings();
		test.logResult(result, "replace should work on empty strings", "168");

		tester = new StringTester();

		result = tester.replace_should_work_as_expected();
		test.logResult(result, "replace should work as expected", "173");

		test.logSubset("find");

		tester = new StringTester();

		result = tester.find_should_work_on_empty_strings();
		test.logResult(result, "find should work on empty strings", "180");

		tester = new StringTester();

		result = tester.find_should_fail_on_finding_empty_strings();
		test.logResult(result, "find should fail on finding empty strings", "185");

		tester = new StringTester();

		result = tester.find_should_work_when_start_is_omitted();
		test.logResult(result, "find should work when start is omitted", "193");

		tester = new StringTester();

		result = tester.find_should_work_when_search_string_is_at_beginning();
		test.logResult(result, "find should work when search string is at beginning", "200");

		tester = new StringTester();

		result = tester.find_should_work_when_search_string_is_at_end();
		test.logResult(result, "find should work when search string is at end", "205");

		tester = new StringTester();

		result = tester.find_should_work_when_search_string_is_within_string();
		test.logResult(result, "find should work when search string is within string", "210");

		tester = new StringTester();

		result = tester.find_should_work_when_start_is_given();
		test.logResult(result, "find should work when start is given", "215");

		test.logSubset("findReverse");

		tester = new StringTester();

		result = tester.findReverse_should_work_on_empty_strings();
		test.logResult(result, "findReverse should work on empty strings", "225");

		tester = new StringTester();

		result = tester.findReverse_should_fail_on_finding_empty_strings();
		test.logResult(result, "findReverse should fail on finding empty strings", "230");

		tester = new StringTester();

		result = tester.findReverse_should_work_when_start_is_omitted();
		test.logResult(result, "findReverse should work when start is omitted", "238");

		tester = new StringTester();

		result = tester.findReverse_should_work_when_search_string_is_at_beginning();
		test.logResult(result, "findReverse should work when search string is at beginning", "245");

		tester = new StringTester();

		result = tester.findReverse_should_work_when_search_string_is_at_end();
		test.logResult(result, "findReverse should work when search string is at end", "250");

		tester = new StringTester();

		result = tester.findReverse_should_work_when_search_string_is_within_string();
		test.logResult(result, "findReverse should work when search string is within string", "255");

		tester = new StringTester();

		result = tester.findReverse_should_work_when_start_is_given();
		test.logResult(result, "findReverse should work when start is given", "260");

		test.logSubset("times");

		tester = new StringTester();

		result = tester.times_should_work_on_empty_strings();
		test.logResult(result, "times should work on empty strings", "272");

		tester = new StringTester();

		result = tester.times_should_return_empty_string_with_amount_being_zero();
		test.logResult(result, "times should return empty string with amount being zero", "276");

		tester = new StringTester();

		result = tester.times_should_work_with_identity();
		test.logResult(result, "times should work with identity", "280");

		tester = new StringTester();

		result = tester.times_should_work_as_expected();
		test.logResult(result, "times should work as expected", "284");

		test.logSubset("format");

		tester = new StringTester();

		result = tester.format_should_work_on_empty_strings();
		test.logResult(result, "format should work on empty strings", "290");

		tester = new StringTester();

		result = tester.format_should_work_on_d_specifier();
		test.logResult(result, "format should work on d specifier", "294");

		tester = new StringTester();

		result = tester.format_should_work_on_x_specifier();
		test.logResult(result, "format should work on x specifier", "299");

		tester = new StringTester();

		result = tester.format_should_work_with_d_specifier_with_width();
		test.logResult(result, "format should work with d specifier with width", "303");

		tester = new StringTester();

		result = tester.format_should_work_with_x_specifier_with_width();
		test.logResult(result, "format should work with x specifier with width", "307");

		tester = new StringTester();

		result = tester.format_should_work_on_X_specifier();
		test.logResult(result, "format should work on X specifier", "311");

		tester = new StringTester();

		result = tester.format_should_work_when_specifier_is_at_beginning();
		test.logResult(result, "format should work when specifier is at beginning", "315");

		tester = new StringTester();

		result = tester.format_should_work_when_specifier_is_at_end();
		test.logResult(result, "format should work when specifier is at end", "321");

		tester = new StringTester();

		result = tester.format_should_work_when_specifier_is_alone();
		test.logResult(result, "format should work when specifier is alone", "327");

		tester = new StringTester();

		result = tester.format_should_work_with_two_specifiers_in_a_row();
		test.logResult(result, "format should work with two specifiers in a row", "333");

		tester = new StringTester();

		result = tester.format_should_work_with_empty_specifier();
		test.logResult(result, "format should work with empty specifier", "341");

		tester = new StringTester();

		result = tester.format_should_work_with_position_specifier();
		test.logResult(result, "format should work with position specifier", "346");

		tester = new StringTester();

		result = tester.format_should_fail_with_position_out_of_bounds();
		test.logResult(result, "format should fail with position out of bounds", "351");

		test.logSubset("uppercase");

		tester = new StringTester();

		result = tester.uppercase_should_work_on_empty_strings();
		test.logResult(result, "uppercase should work on empty strings", "358");

		tester = new StringTester();

		result = tester.uppercase_should_work_as_expected();
		test.logResult(result, "uppercase should work as expected", "362");

		test.logSubset("lowercase");

		tester = new StringTester();

		result = tester.lowercase_should_work_on_empty_strings();
		test.logResult(result, "lowercase should work on empty strings", "371");

		tester = new StringTester();

		result = tester.lowercase_should_work_as_expected();
		test.logResult(result, "lowercase should work as expected", "375");

		test.logSubset("charAt");

		tester = new StringTester();

		result = tester.charAt_should_fail_on_empty_strings();
		test.logResult(result, "charAt should fail on empty strings", "384");

		tester = new StringTester();

		result = tester.charAt_should_work_for_normal_strings();
		test.logResult(result, "charAt should work for normal strings", "389");

		tester = new StringTester();

		result = tester.charAt_should_account_for_combining_marks();
		test.logResult(result, "charAt should account for combining marks", "397");

		test.logSubset("insertAt");

		tester = new StringTester();

		result = tester.insertAt_should_work_on_empty_strings();
		test.logResult(result, "insertAt should work on empty strings", "409");

		tester = new StringTester();

		result = tester.insertAt_should_fail_when_index_is_out_of_bounds();
		test.logResult(result, "insertAt should fail when index is out of bounds", "416");

		tester = new StringTester();

		result = tester.insertAt_should_work_when_index_is_zero();
		test.logResult(result, "insertAt should work when index is zero", "423");

		tester = new StringTester();

		result = tester.insertAt_should_work_when_index_is_utflen();
		test.logResult(result, "insertAt should work when index is utflen", "430");

		tester = new StringTester();

		result = tester.insertAt_should_work_when_index_is_within_string();
		test.logResult(result, "insertAt should work when index is within string", "437");

		tester = new StringTester();

		result = tester.insertAt_should_account_for_combining_marks();
		test.logResult(result, "insertAt should account for combining marks", "446");

		test.logSubset("utflen");

		tester = new StringTester();

		result = tester.utflen_should_work_on_empty_strings();
		test.logResult(result, "utflen should work on empty strings", "468");

		tester = new StringTester();

		result = tester.utflen_should_work_on_normal_strings();
		test.logResult(result, "utflen should work on normal strings", "472");

		tester = new StringTester();

		result = tester.utflen_should_account_for_combining_marks();
		test.logResult(result, "utflen should account for combining marks", "476");

		test.finish();
	}
}

import core.arguments;

class ArgumentsTester {

	it creation_should_work_as_expected() {
		before_creation();
		it ret = it.does;
		try {
			Arguments args = new Arguments();
			if(args is null) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Invalid Format String") { ret = it.doesnt; }
			ret = it.does;
		}
		return ret;
	}

	done before_creation() {
	}

	done before() {
	}

	this() {
		before();
	}

	static void test() {
		ArgumentsTester tester = new ArgumentsTester();

		Test test = new Test("Arguments", "specs/core/arguments.d");

		it result;

		test.logSubset("creation");

		tester = new ArgumentsTester();

		result = tester.creation_should_work_as_expected();
		test.logResult(result, "creation should work as expected", "8");

		test.finish();
	}
}

import core.variant;

class VariantTester {

	it initial_state_should_be_null() {
		before_initial_state();
		it ret = it.does;
		try {
			Variant var;
			if(!(var.type == Type.Reference)) {
				ret = it.doesnt;
			}
			if(!(var.to!(Object) is null)) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Invalid Format String") { ret = it.doesnt; }
			ret = it.does;
		}
		return ret;
	}

	done before_initial_state() {
	}

	it assignment_should_handle_integer_literals() {
		before_assignment();
		it ret = it.does;
		try {
			Variant var = 2;
			if(!(var == 2)) {
				ret = it.doesnt;
			}
			if(!(var.to!(int) == 2)) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Invalid Format String") { ret = it.doesnt; }
			ret = it.does;
		}
		return ret;
	}

	it assignment_should_handle_reassignment() {
		before_assignment();
		it ret = it.does;
		try {
			Variant var = 2;
			var = 3;
			if(!(var == 3)) {
				ret = it.doesnt;
			}
			var = "foo";
			if(!(var == "foo")) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Invalid Format String") { ret = it.doesnt; }
			ret = it.does;
		}
		return ret;
	}

	it assignment_should_handle_object_references() {
		before_assignment();
		it ret = it.does;
		try {
			Object foo = new Object();
			Variant var = foo;
			if(!(var == foo)) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Invalid Format String") { ret = it.doesnt; }
			ret = it.does;
		}
		return ret;
	}

	it assignment_should_handle_float_literals() {
		before_assignment();
		it ret = it.does;
		try {
			Variant var = 0.5;
			if(!(var == 0.5)) {
				ret = it.doesnt;
			}
			if(!(var.to!(float) == 0.5)) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Invalid Format String") { ret = it.doesnt; }
			ret = it.does;
		}
		return ret;
	}

	done before_assignment() {
	}

	it comparison_should_handle_int() {
		before_comparison();
		it ret = it.does;
		try {
			int a = 2;
			Variant var = a;
			if(!(var == a)) {
				ret = it.doesnt;
			}
			if(!(var == 2)) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Invalid Format String") { ret = it.doesnt; }
			ret = it.does;
		}
		return ret;
	}

	it comparison_should_handle_float() {
		before_comparison();
		it ret = it.does;
		try {
			float a = 1.23;
			Variant var = a;
			if(!(var == a)) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Invalid Format String") { ret = it.doesnt; }
			ret = it.does;
		}
		return ret;
	}

	it comparison_should_handle_string() {
		before_comparison();
		it ret = it.does;
		try {
			string a = "hello";
			Variant var = a;
			if(!(var == a)) {
				ret = it.doesnt;
			}
			if(!(var == "hello")) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Invalid Format String") { ret = it.doesnt; }
			ret = it.does;
		}
		return ret;
	}

	done before_comparison() {
	}

	done before() {
	}

	this() {
		before();
	}

	static void test() {
		VariantTester tester = new VariantTester();

		Test test = new Test("Variant", "specs/core/variant.d");

		it result;

		test.logSubset("initial");

		tester = new VariantTester();

		result = tester.initial_state_should_be_null();
		test.logResult(result, "initial state should be null", "9");

		test.logSubset("assignment");

		tester = new VariantTester();

		result = tester.assignment_should_handle_integer_literals();
		test.logResult(result, "assignment should handle integer literals", "17");

		tester = new VariantTester();

		result = tester.assignment_should_handle_reassignment();
		test.logResult(result, "assignment should handle reassignment", "23");

		tester = new VariantTester();

		result = tester.assignment_should_handle_object_references();
		test.logResult(result, "assignment should handle object references", "31");

		tester = new VariantTester();

		result = tester.assignment_should_handle_float_literals();
		test.logResult(result, "assignment should handle float literals", "37");

		test.logSubset("comparison");

		tester = new VariantTester();

		result = tester.comparison_should_handle_int();
		test.logResult(result, "comparison should handle int", "45");

		tester = new VariantTester();

		result = tester.comparison_should_handle_float();
		test.logResult(result, "comparison should handle float", "52");

		tester = new VariantTester();

		result = tester.comparison_should_handle_string();
		test.logResult(result, "comparison should handle string", "58");

		test.finish();
	}
}

import core.string;

import core.regex;

class RegexTester {

	it eval_should_handle_kleene_star() {
		before_eval();
		it ret = it.does;
		try {
			string str = Regex.eval("<EM>some text</EM>", `<.*>`);
			if(!(str == "<EM>some text</EM>")) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Invalid Format String") { ret = it.doesnt; }
			ret = it.does;
		}
		return ret;
	}

	it eval_should_handle_lazy_kleene_star() {
		before_eval();
		it ret = it.does;
		try {
			string str = Regex.eval("<EM>some text</EM>", `<.*?>`);
			if(!(str == "<EM>")) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Invalid Format String") { ret = it.doesnt; }
			ret = it.does;
		}
		return ret;
	}

	it eval_should_handle_kleene_plus() {
		before_eval();
		it ret = it.does;
		try {
			string str = Regex.eval("<>EM>some text</EM>", `<.+>`);
			if(!(str == "<>EM>some text</EM>")) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Invalid Format String") { ret = it.doesnt; }
			ret = it.does;
		}
		return ret;
	}

	it eval_should_handle_lazy_kleene_plus() {
		before_eval();
		it ret = it.does;
		try {
			string str = Regex.eval("<>EM>some text</EM>", `<.+?>`);
			if(!(str == "<>EM>")) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Invalid Format String") { ret = it.doesnt; }
			ret = it.does;
		}
		return ret;
	}

	it eval_should_handle_options() {
		before_eval();
		it ret = it.does;
		try {
			string str = Regex.eval("abc", `a?abc`);
			if(!(str == "abc")) {
				ret = it.doesnt;
			}
			str = Regex.eval("aabc", `a?abc`);
			if(!(str == "aabc")) {
				ret = it.doesnt;
			}
			str = Regex.eval("ababbababababbbc", `(a?b)*c`);
			if(!(str == "ababbababababbbc")) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Invalid Format String") { ret = it.doesnt; }
			ret = it.does;
		}
		return ret;
	}

	it eval_should_handle_optional_groups() {
		before_eval();
		it ret = it.does;
		try {
			string str = Regex.eval("abcdefeggfoo", `abc(egg|foo)?def(egg|foo)?(egg|foo)?`);
			if(!(str == "abcdefeggfoo")) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Invalid Format String") { ret = it.doesnt; }
			ret = it.does;
		}
		return ret;
	}

	it eval_should_handle_union_at_base_level() {
		before_eval();
		it ret = it.does;
		try {
			string str = Regex.eval("dogbert", `cat|dog`);
			if(!(str == "dog")) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Invalid Format String") { ret = it.doesnt; }
			ret = it.does;
		}
		return ret;
	}

	it eval_should_handle_union_at_group_level() {
		before_eval();
		it ret = it.does;
		try {
			string str = Regex.eval("bacd", `(bac|b)acd`);
			if(!(str == "bacd")) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Invalid Format String") { ret = it.doesnt; }
			ret = it.does;
		}
		return ret;
	}

	it eval_should_handle_union_with_kleene_star() {
		before_eval();
		it ret = it.does;
		try {
			string str = Regex.eval("catdogdogcatbert", `(cat|dog)*`);
			if(!(str == "catdogdogcat")) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Invalid Format String") { ret = it.doesnt; }
			ret = it.does;
		}
		return ret;
	}

	it eval_should_handle_nested_groups() {
		before_eval();
		it ret = it.does;
		try {
			string str = Regex.eval("acatbert", `a(cat(bert))`);
			if(!(str == "acatbert")) {
				ret = it.doesnt;
			}
			if(!(_1 == "catbert")) {
				ret = it.doesnt;
			}
			if(!(_2 == "bert")) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Invalid Format String") { ret = it.doesnt; }
			ret = it.does;
		}
		return ret;
	}

	it eval_should_handle_nested_groups_with_union() {
		before_eval();
		it ret = it.does;
		try {
			string str = Regex.eval("dogpoo", `(dog(bert|poo))`);
			if(!(str == "dogpoo")) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Invalid Format String") { ret = it.doesnt; }
			ret = it.does;
		}
		return ret;
	}

	it eval_should_handle_character_classes() {
		before_eval();
		it ret = it.does;
		try {
			string str = Regex.eval("daccabaaccbg", `d[abc]*g`);
			if(!(str == "daccabaaccbg")) {
				ret = it.doesnt;
			}
			str = Regex.eval("daccabadaccbg", `d[abc]*g`);
			if(!(str == "daccbg")) {
				ret = it.doesnt;
			}
			str = Regex.eval("daccabadaccbg", `^d[abc]*g`);
			if(!(str is null)) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Invalid Format String") { ret = it.doesnt; }
			ret = it.does;
		}
		return ret;
	}

	it eval_should_handle_inverse_character_classes() {
		before_eval();
		it ret = it.does;
		try {
			string str = Regex.eval("ddeffegggdefeddfeg", `d[^abc]*g`);
			if(!(str == "ddeffegggdefeddfeg")) {
				ret = it.doesnt;
			}
			str = Regex.eval("ddeffegggdefeddfeg", `d[^abc]*?g`);
			if(!(str == "ddeffeg")) {
				ret = it.doesnt;
			}
			str = Regex.eval("ddeffeagggdefeddfeg", `d[^abc]*?g`);
			if(!(str == "defeddfeg")) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Invalid Format String") { ret = it.doesnt; }
			ret = it.does;
		}
		return ret;
	}

	it eval_should_handle_dollar_sign() {
		before_eval();
		it ret = it.does;
		try {
			string str = Regex.eval("root woot moot foot", `.oot$`);
			if(!(str == "foot")) {
				ret = it.doesnt;
			}
			str = Regex.eval("root\nwoot\nmoot\nfoot", `.oot$`);
			if(!(str == "root")) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Invalid Format String") { ret = it.doesnt; }
			ret = it.does;
		}
		return ret;
	}

	it eval_should_handle_beginning_of_line_caret() {
		before_eval();
		it ret = it.does;
		try {
			string str = Regex.eval("root woot moot foot", `^.oot`);
			if(!(str == "root")) {
				ret = it.doesnt;
			}
			str = Regex.eval(" root\nwoot\nmoot\nfoot", `^.oot`, "m");
			if(!(str == "woot")) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Invalid Format String") { ret = it.doesnt; }
			ret = it.does;
		}
		return ret;
	}

	it eval_should_handle_group_consumption() {
		before_eval();
		it ret = it.does;
		try {
			string str = Regex.eval("dogpoo", `(dog(bert|poo))`);
			if(!(str == "dogpoo")) {
				ret = it.doesnt;
			}
			if(!(_1 == "dogpoo")) {
				ret = it.doesnt;
			}
			if(!(_2 == "poo")) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Invalid Format String") { ret = it.doesnt; }
			ret = it.does;
		}
		return ret;
	}

	it eval_should_handle_group_reconsumption() {
		before_eval();
		it ret = it.does;
		try {
			string str = Regex.eval("bertpoopoobertpoo", `(bert|poo)+`);
			if(!(str == "bertpoopoobertpoo")) {
				ret = it.doesnt;
			}
			if(!(_1 == "poo")) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Invalid Format String") { ret = it.doesnt; }
			ret = it.does;
		}
		return ret;
	}

	it eval_should_handle_backreferences() {
		before_eval();
		it ret = it.does;
		try {
			string str = Regex.eval("dogpoo=dogpoo", `(dogpoo)=\1`);
			if(!(str == "dogpoo=dogpoo")) {
				ret = it.doesnt;
			}
			if(!(_1 == "dogpoo")) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Invalid Format String") { ret = it.doesnt; }
			ret = it.does;
		}
		return ret;
	}

	it eval_should_handle_forwardreferences() {
		before_eval();
		it ret = it.does;
		try {
			string str = Regex.eval("oneonetwo", `(\2two|(one))+`);
			if(!(str == "oneonetwo")) {
				ret = it.doesnt;
			}
			if(!(_1 == "onetwo")) {
				ret = it.doesnt;
			}
			if(!(_2 == "one")) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Invalid Format String") { ret = it.doesnt; }
			ret = it.does;
		}
		return ret;
	}

	it eval_should_handle_comments() {
		before_eval();
		it ret = it.does;
		try {
			string str = Regex.eval("bleh", `bl(?#comment here)eh`);
			if(!(str == "bleh")) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Invalid Format String") { ret = it.doesnt; }
			ret = it.does;
		}
		return ret;
	}

	it eval_should_handle_complicated_constructions() {
		before_eval();
		it ret = it.does;
		try {
			string str = Regex.eval(`a#line 43 "foo\bar"`, `#line\s+(0x[0-9a-fA-F_]+|0b[01_]+|0[_0-7]+|(?:[1-9][_0-9]*|0))(?:\s+("[^"]*"))?`);
			if(!(str == `#line 43 "foo\bar"`)) {
				ret = it.doesnt;
			}
			if(!(_1 == "43")) {
				ret = it.doesnt;
			}
			if(!(_2 == `"foo\bar"`)) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Invalid Format String") { ret = it.doesnt; }
			ret = it.does;
		}
		return ret;
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

import core.util;

import utils.stack;

import core.list;

import interfaces.container;

class UtilTester {

	it typeTemplates_should_determine_if_it_is_a_type() {
		before_typeTemplates();
		it ret = it.does;
		try {
			if(!(IsType!(int))) {
				ret = it.doesnt;
			}
			if(IsType!(int[])) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Invalid Format String") { ret = it.doesnt; }
			ret = it.does;
		}
		return ret;
	}

	it typeTemplates_should_determine_if_it_is_a_class() {
		before_typeTemplates();
		it ret = it.does;
		try {
			if(!(IsClass!(Stack!(int)))) {
				ret = it.doesnt;
			}
			if(IsClass!(int)) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Invalid Format String") { ret = it.doesnt; }
			ret = it.does;
		}
		return ret;
	}

	it typeTemplates_should_determine_if_it_is_an_iterface() {
		before_typeTemplates();
		it ret = it.does;
		try {
			if(!(IsInterface!(AbstractContainer))) {
				ret = it.doesnt;
			}
			if(IsInterface!(int)) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Invalid Format String") { ret = it.doesnt; }
			ret = it.does;
		}
		return ret;
	}

	it typeTemplates_should_determine_if_it_is_an_object() {
		before_typeTemplates();
		it ret = it.does;
		try {
			if(IsObject!(int)) {
				ret = it.doesnt;
			}
			if(!(IsObject!(Stack!(int)))) {
				ret = it.doesnt;
			}
			if(!(IsObject!(AbstractContainer))) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Invalid Format String") { ret = it.doesnt; }
			ret = it.does;
		}
		return ret;
	}

	it typeTemplates_should_determine_if_it_is_an_int_type() {
		before_typeTemplates();
		it ret = it.does;
		try {
			if(!(IsIntType!(int))) {
				ret = it.doesnt;
			}
			if(!(IsIntType!(uint))) {
				ret = it.doesnt;
			}
			if(IsIntType!(int[])) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Invalid Format String") { ret = it.doesnt; }
			ret = it.does;
		}
		return ret;
	}

	it typeTemplates_should_determine_if_it_is_unsigned() {
		before_typeTemplates();
		it ret = it.does;
		try {
			if(!(IsUnsigned!(uint))) {
				ret = it.doesnt;
			}
			if(!(IsUnsigned!(ushort))) {
				ret = it.doesnt;
			}
			if(!(IsUnsigned!(ulong))) {
				ret = it.doesnt;
			}
			if(!(IsUnsigned!(ubyte))) {
				ret = it.doesnt;
			}
			if(IsUnsigned!(int)) {
				ret = it.doesnt;
			}
			if(IsUnsigned!(short)) {
				ret = it.doesnt;
			}
			if(IsUnsigned!(long)) {
				ret = it.doesnt;
			}
			if(IsUnsigned!(byte)) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Invalid Format String") { ret = it.doesnt; }
			ret = it.does;
		}
		return ret;
	}

	it typeTemplates_should_determine_if_it_is_signed() {
		before_typeTemplates();
		it ret = it.does;
		try {
			if(!(IsSigned!(int))) {
				ret = it.doesnt;
			}
			if(!(IsSigned!(short))) {
				ret = it.doesnt;
			}
			if(!(IsSigned!(long))) {
				ret = it.doesnt;
			}
			if(!(IsSigned!(byte))) {
				ret = it.doesnt;
			}
			if(IsSigned!(uint)) {
				ret = it.doesnt;
			}
			if(IsSigned!(ushort)) {
				ret = it.doesnt;
			}
			if(IsSigned!(ulong)) {
				ret = it.doesnt;
			}
			if(IsSigned!(ubyte)) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Invalid Format String") { ret = it.doesnt; }
			ret = it.does;
		}
		return ret;
	}

	it typeTemplates_should_determine_if_it_is_float() {
		before_typeTemplates();
		it ret = it.does;
		try {
			if(!(IsFloat!(float))) {
				ret = it.doesnt;
			}
			if(!(IsFloat!(double))) {
				ret = it.doesnt;
			}
			if(!(IsFloat!(real))) {
				ret = it.doesnt;
			}
			if(IsFloat!(int)) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Invalid Format String") { ret = it.doesnt; }
			ret = it.does;
		}
		return ret;
	}

	it typeTemplates_should_determine_if_it_is_complex() {
		before_typeTemplates();
		it ret = it.does;
		try {
			if(!(IsComplex!(cfloat))) {
				ret = it.doesnt;
			}
			if(!(IsComplex!(cdouble))) {
				ret = it.doesnt;
			}
			if(!(IsComplex!(creal))) {
				ret = it.doesnt;
			}
			if(IsComplex!(float)) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Invalid Format String") { ret = it.doesnt; }
			ret = it.does;
		}
		return ret;
	}

	it typeTemplates_should_determine_if_it_is_imaginary() {
		before_typeTemplates();
		it ret = it.does;
		try {
			if(!(IsImaginary!(ifloat))) {
				ret = it.doesnt;
			}
			if(!(IsImaginary!(idouble))) {
				ret = it.doesnt;
			}
			if(!(IsImaginary!(ireal))) {
				ret = it.doesnt;
			}
			if(IsImaginary!(float)) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Invalid Format String") { ret = it.doesnt; }
			ret = it.does;
		}
		return ret;
	}

	it typeTemplates_should_determine_if_it_is_struct() {
		before_typeTemplates();
		it ret = it.does;
		try {
			if(IsStruct!(int)) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Invalid Format String") { ret = it.doesnt; }
			ret = it.does;
		}
		return ret;
	}

	it typeTemplates_should_determine_if_it_is_array() {
		before_typeTemplates();
		it ret = it.does;
		try {
			if(!(IsArray!(int[]))) {
				ret = it.doesnt;
			}
			if(IsArray!(int)) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Invalid Format String") { ret = it.doesnt; }
			ret = it.does;
		}
		return ret;
	}

	it typeTemplates_should_determine_the_superclass() {
		before_typeTemplates();
		it ret = it.does;
		try {
			class A{}
			class B : A {}
			class C : B {}
			if(!(Super!(B).stringof == "A")) {
				ret = it.doesnt;
			}
			if(!(Super!(C).stringof == "B")) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Invalid Format String") { ret = it.doesnt; }
			ret = it.does;
		}
		return ret;
	}

	it typeTemplates_should_determine_the_interfaces() {
		before_typeTemplates();
		it ret = it.does;
		try {
			class A {}
			interface E {}
			interface F {}
			interface G {}
			class B : A,G {}
			class C : B,E,F {}
			if(!(Interfaces!(C).stringof == "(E, F)")) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Invalid Format String") { ret = it.doesnt; }
			ret = it.does;
		}
		return ret;
	}

	it typeTemplates_should_determine_the_arraytype() {
		before_typeTemplates();
		it ret = it.does;
		try {
			if(!(ArrayType!(int[]).stringof == "int")) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Invalid Format String") { ret = it.doesnt; }
			ret = it.does;
		}
		return ret;
	}

	done before_typeTemplates() {
	}

	it stringTemplates_should_capitalize_a_string() {
		before_stringTemplates();
		it ret = it.does;
		try {
			if(!(Capitalize!("string") == "String")) {
				ret = it.doesnt;
			}
			if(!(Capitalize!("String") == "String")) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Invalid Format String") { ret = it.doesnt; }
			ret = it.does;
		}
		return ret;
	}

	it stringTemplates_should_trim_whitespace_from_the_left() {
		before_stringTemplates();
		it ret = it.does;
		try {
			if(!(TrimL!("string") == "string")) {
				ret = it.doesnt;
			}
			if(!(TrimL!("   string") == "string")) {
				ret = it.doesnt;
			}
			if(!(TrimL!("string   ") == "string   ")) {
				ret = it.doesnt;
			}
			if(!(TrimL!("   string   ") == "string   ")) {
				ret = it.doesnt;
			}
			if(!(TrimL!("\t\n\rstring") == "string")) {
				ret = it.doesnt;
			}
			if(!(TrimL!("string\t\n\r") == "string\t\n\r")) {
				ret = it.doesnt;
			}
			if(!(TrimL!("\t\n\rstring\t\n\r") == "string\t\n\r")) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Invalid Format String") { ret = it.doesnt; }
			ret = it.does;
		}
		return ret;
	}

	it stringTemplates_should_trim_whitespace_from_the_right() {
		before_stringTemplates();
		it ret = it.does;
		try {
			if(!(TrimR!("string") == "string")) {
				ret = it.doesnt;
			}
			if(!(TrimR!("   string") == "   string")) {
				ret = it.doesnt;
			}
			if(!(TrimR!("string   ") == "string")) {
				ret = it.doesnt;
			}
			if(!(TrimR!("   string   ") == "   string")) {
				ret = it.doesnt;
			}
			if(!(TrimR!("\t\n\rstring") == "\t\n\rstring")) {
				ret = it.doesnt;
			}
			if(!(TrimR!("string\t\n\r") == "string")) {
				ret = it.doesnt;
			}
			if(!(TrimR!("\t\n\rstring\t\n\r") == "\t\n\rstring")) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Invalid Format String") { ret = it.doesnt; }
			ret = it.does;
		}
		return ret;
	}

	it stringTemplates_should_remove_spaces() {
		before_stringTemplates();
		it ret = it.does;
		try {
			if(!(RemoveSpaces!("string") == "string")) {
				ret = it.doesnt;
			}
			if(!(RemoveSpaces!(" s t r i n g ") == "string")) {
				ret = it.doesnt;
			}
			if(!(RemoveSpaces!("\ts\nt\rr\ti\nn\rg") == "string")) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Invalid Format String") { ret = it.doesnt; }
			ret = it.does;
		}
		return ret;
	}

	done before_stringTemplates() {
	}

	done before() {
	}

	this() {
		before();
	}

	static void test() {
		UtilTester tester = new UtilTester();

		Test test = new Test("Util", "specs/core/util.d");

		it result;

		test.logSubset("typeTemplates");

		tester = new UtilTester();

		result = tester.typeTemplates_should_determine_if_it_is_a_type();
		test.logResult(result, "typeTemplates should determine if it is a type", "10");

		tester = new UtilTester();

		result = tester.typeTemplates_should_determine_if_it_is_a_class();
		test.logResult(result, "typeTemplates should determine if it is a class", "15");

		tester = new UtilTester();

		result = tester.typeTemplates_should_determine_if_it_is_an_iterface();
		test.logResult(result, "typeTemplates should determine if it is an iterface", "20");

		tester = new UtilTester();

		result = tester.typeTemplates_should_determine_if_it_is_an_object();
		test.logResult(result, "typeTemplates should determine if it is an object", "25");

		tester = new UtilTester();

		result = tester.typeTemplates_should_determine_if_it_is_an_int_type();
		test.logResult(result, "typeTemplates should determine if it is an int type", "31");

		tester = new UtilTester();

		result = tester.typeTemplates_should_determine_if_it_is_unsigned();
		test.logResult(result, "typeTemplates should determine if it is unsigned", "37");

		tester = new UtilTester();

		result = tester.typeTemplates_should_determine_if_it_is_signed();
		test.logResult(result, "typeTemplates should determine if it is signed", "49");

		tester = new UtilTester();

		result = tester.typeTemplates_should_determine_if_it_is_float();
		test.logResult(result, "typeTemplates should determine if it is float", "61");

		tester = new UtilTester();

		result = tester.typeTemplates_should_determine_if_it_is_complex();
		test.logResult(result, "typeTemplates should determine if it is complex", "69");

		tester = new UtilTester();

		result = tester.typeTemplates_should_determine_if_it_is_imaginary();
		test.logResult(result, "typeTemplates should determine if it is imaginary", "77");

		tester = new UtilTester();

		result = tester.typeTemplates_should_determine_if_it_is_struct();
		test.logResult(result, "typeTemplates should determine if it is struct", "85");

		tester = new UtilTester();

		result = tester.typeTemplates_should_determine_if_it_is_array();
		test.logResult(result, "typeTemplates should determine if it is array", "89");

		tester = new UtilTester();

		result = tester.typeTemplates_should_determine_the_superclass();
		test.logResult(result, "typeTemplates should determine the superclass", "94");

		tester = new UtilTester();

		result = tester.typeTemplates_should_determine_the_interfaces();
		test.logResult(result, "typeTemplates should determine the interfaces", "103");

		tester = new UtilTester();

		result = tester.typeTemplates_should_determine_the_arraytype();
		test.logResult(result, "typeTemplates should determine the arraytype", "114");

		test.logSubset("stringTemplates");

		tester = new UtilTester();

		result = tester.stringTemplates_should_capitalize_a_string();
		test.logResult(result, "stringTemplates should capitalize a string", "120");

		tester = new UtilTester();

		result = tester.stringTemplates_should_trim_whitespace_from_the_left();
		test.logResult(result, "stringTemplates should trim whitespace from the left", "125");

		tester = new UtilTester();

		result = tester.stringTemplates_should_trim_whitespace_from_the_right();
		test.logResult(result, "stringTemplates should trim whitespace from the right", "136");

		tester = new UtilTester();

		result = tester.stringTemplates_should_remove_spaces();
		test.logResult(result, "stringTemplates should remove spaces", "147");

		test.finish();
	}
}

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
		it ret = it.does;
		try {
			uint length = Unicode.utflen(utf8);
			uint compare = Unicode.utflen(utf32);
			if(!(length == compare)) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Invalid Format String") { ret = it.doesnt; }
			ret = it.does;
		}
		return ret;
	}

	it utflen_should_be_the_same_for_utf16_as_utf32() {
		before_utflen();
		it ret = it.does;
		try {
			uint length = Unicode.utflen(utf16);
			uint compare = Unicode.utflen(utf32);
			if(!(length == compare)) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Invalid Format String") { ret = it.doesnt; }
			ret = it.does;
		}
		return ret;
	}

	it utflen_should_account_for_combining_marks_for_utf8() {
		before_utflen();
		it ret = it.does;
		try {
			uint length = Unicode.utflen(utf8marks);
			if(!(length == 10)) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Invalid Format String") { ret = it.doesnt; }
			ret = it.does;
		}
		return ret;
	}

	it utflen_should_account_for_combining_marks_for_utf16() {
		before_utflen();
		it ret = it.does;
		try {
			uint length = Unicode.utflen(utf16marks);
			if(!(length == 10)) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Invalid Format String") { ret = it.doesnt; }
			ret = it.does;
		}
		return ret;
	}

	it utflen_should_account_for_combining_marks_for_utf32() {
		before_utflen();
		it ret = it.does;
		try {
			uint length = Unicode.utflen(utf32marks);
			if(!(length == 10)) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Invalid Format String") { ret = it.doesnt; }
			ret = it.does;
		}
		return ret;
	}

	it utflen_should_account_for_empty_strings_for_utf8() {
		before_utflen();
		it ret = it.does;
		try {
			uint length = Unicode.utflen(empty32);
			if(!(length == 0)) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Invalid Format String") { ret = it.doesnt; }
			ret = it.does;
		}
		return ret;
	}

	it utflen_should_account_for_empty_strings_for_utf16() {
		before_utflen();
		it ret = it.does;
		try {
			uint length = Unicode.utflen(empty16);
			if(!(length == 0)) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Invalid Format String") { ret = it.doesnt; }
			ret = it.does;
		}
		return ret;
	}

	it utflen_should_account_for_empty_strings_for_utf32() {
		before_utflen();
		it ret = it.does;
		try {
			uint length = Unicode.utflen(empty8);
			if(!(length == 0)) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Invalid Format String") { ret = it.doesnt; }
			ret = it.does;
		}
		return ret;
	}

	done before_utflen() {
	}

	it toUtfChars_should_work_as_expected_for_single_characters_for_utf32() {
		before_toUtfChars();
		it ret = it.does;
		try {
			dchar chrs[] = Unicode.toUtf32Chars(utf32marks);
			if(!(chrs.length == 1)) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Invalid Format String") { ret = it.doesnt; }
			ret = it.does;
		}
		return ret;
	}

	it toUtfChars_should_work_as_expected_for_single_characters_for_utf16() {
		before_toUtfChars();
		it ret = it.does;
		try {
			dchar chrs[] = Unicode.toUtf32Chars(utf16marks);
			if(!(chrs.length == 1)) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Invalid Format String") { ret = it.doesnt; }
			ret = it.does;
		}
		return ret;
	}

	it toUtfChars_should_work_as_expected_for_single_characters_for_utf8() {
		before_toUtfChars();
		it ret = it.does;
		try {
			dchar chrs[] = Unicode.toUtf32Chars(utf8marks);
			if(!(chrs.length == 1)) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Invalid Format String") { ret = it.doesnt; }
			ret = it.does;
		}
		return ret;
	}

	it toUtfChars_should_account_for_combining_marks_for_utf32() {
		before_toUtfChars();
		it ret = it.does;
		try {
			dchar chrs[] = Unicode.toUtf32Chars(utf32marks[4..$]);
			if(!(chrs.length == 2)) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Invalid Format String") { ret = it.doesnt; }
			ret = it.does;
		}
		return ret;
	}

	it toUtfChars_should_account_for_combining_marks_for_utf16() {
		before_toUtfChars();
		it ret = it.does;
		try {
			dchar chrs[] = Unicode.toUtf32Chars(utf16marks[4..$]);
			if(!(chrs.length == 2)) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Invalid Format String") { ret = it.doesnt; }
			ret = it.does;
		}
		return ret;
	}

	it toUtfChars_should_account_for_combining_marks_for_utf8() {
		before_toUtfChars();
		it ret = it.does;
		try {
			dchar chrs[] = Unicode.toUtf32Chars(utf8marks[4..$]);
			if(!(chrs.length == 2)) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Invalid Format String") { ret = it.doesnt; }
			ret = it.does;
		}
		return ret;
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

import core.random;

class RandomTester {

	const uint SEED = 12345678;
	const uint REPEATS = 10000000;

	it creation_should_have_sane_defaults() {
		before_creation();
		it ret = it.does;
		try {
			auto r = new Random();
			if(!(r.seed >= 0)) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Invalid Format String") { ret = it.doesnt; }
			ret = it.does;
		}
		return ret;
	}

	it creation_should_not_reuse_a_seed() {
		before_creation();
		it ret = it.does;
		try {
			auto a = new Random();
			auto b = new Random();
			if(a.seed == b.seed) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Invalid Format String") { ret = it.doesnt; }
			ret = it.does;
		}
		return ret;
	}

	it creation_should_use_the_given_seed() {
		before_creation();
		it ret = it.does;
		try {
			auto r = new Random(SEED);
			if(!(r.seed == SEED)) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Invalid Format String") { ret = it.doesnt; }
			ret = it.does;
		}
		return ret;
	}

	done before_creation() {
	}

	it state_should_be_reproducible() {
		before_state();
		it ret = it.does;
		try {
			auto a = new Random(SEED);
			auto b = new Random(SEED);
			if(!(a.next() == b.next())) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Invalid Format String") { ret = it.doesnt; }
			ret = it.does;
		}
		return ret;
	}

	done before_state() {
	}

	it seed_should_set_and_get_the_seed() {
		before_seed();
		it ret = it.does;
		try {
			auto r = new Random();
			r.seed = SEED;
			if(!(r.seed == SEED)) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Invalid Format String") { ret = it.doesnt; }
			ret = it.does;
		}
		return ret;
	}

	done before_seed() {
	}

	// TODO: Statistical tests should be implemented for all the "next" methods.

	it next_should_not_be_stuck() {
		before_next();
		it ret = it.does;
		try {
			auto r = new Random();
			if(r.next() == r.next()) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Invalid Format String") { ret = it.doesnt; }
			ret = it.does;
		}
		return ret;
	}

	it next_should_return_zero_if_upper_bound_is_zero() {
		before_next();
		it ret = it.does;
		try {
			auto r = new Random();
			if(!(r.next(0) == 0)) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Invalid Format String") { ret = it.doesnt; }
			ret = it.does;
		}
		return ret;
	}

	it next_should_return_a_nonnegative_value_less_than_upper_bound() {
		before_next();
		it ret = it.does;
		try {
			auto r = new Random();
			uint v;
			uint upper = 1;
			for (uint i = 0; i < REPEATS; i++) {
			v = r.next(upper);
			if(!(v >= 0)) {
				ret = it.doesnt;
			}
			if(!(v < upper)) {
				ret = it.doesnt;
			}
			upper += i;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Invalid Format String") { ret = it.doesnt; }
			ret = it.does;
		}
		return ret;
	}

	it next_should_return_greatest_bound_if_bounds_overlap() {
		before_next();
		it ret = it.does;
		try {
			auto r = new Random();
			if(!(r.next(0, 0) == 0)) {
				ret = it.doesnt;
			}
			if(!(r.next(123, 123) == 123)) {
				ret = it.doesnt;
			}
			if(!(r.next(-123, -123) == -123)) {
				ret = it.doesnt;
			}
			if(!(r.next(123, -123) == 123)) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Invalid Format String") { ret = it.doesnt; }
			ret = it.does;
		}
		return ret;
	}

	it next_should_return_a_value_within_bounds() {
		before_next();
		it ret = it.does;
		try {
			auto r = new Random();
			int v;
			int lower = 0;
			int upper = 1;
			for (uint i = 0; i < REPEATS; i++) {
			v = r.next(lower, upper);
			if(!(v >= lower)) {
				ret = it.doesnt;
			}
			if(!(v < upper)) {
				ret = it.doesnt;
			}
			lower -= 12;
			upper += 3;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Invalid Format String") { ret = it.doesnt; }
			ret = it.does;
		}
		return ret;
	}

	done before_next() {
	}

	it nextLong_should_not_be_stuck() {
		before_nextLong();
		it ret = it.does;
		try {
			auto r = new Random();
			if(r.nextLong() == r.nextLong()) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Invalid Format String") { ret = it.doesnt; }
			ret = it.does;
		}
		return ret;
	}

	it nextLong_should_return_zero_if_upper_bound_is_zero() {
		before_nextLong();
		it ret = it.does;
		try {
			auto r = new Random();
			if(!(r.nextLong(0) == 0)) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Invalid Format String") { ret = it.doesnt; }
			ret = it.does;
		}
		return ret;
	}

	it nextLong_should_return_a_nonnegative_value_less_than_upper_bound() {
		before_nextLong();
		it ret = it.does;
		try {
			auto r = new Random();
			ulong v;
			ulong upper = 1;
			for (uint i = 0; i < REPEATS; i++) {
			v = r.nextLong(upper);
			if(!(v >= 0)) {
				ret = it.doesnt;
			}
			if(!(v < upper)) {
				ret = it.doesnt;
			}
			upper += i;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Invalid Format String") { ret = it.doesnt; }
			ret = it.does;
		}
		return ret;
	}

	it nextLong_should_return_greatest_bound_if_bounds_overlap() {
		before_nextLong();
		it ret = it.does;
		try {
			auto r = new Random();
			if(!(r.nextLong(0, 0) == 0)) {
				ret = it.doesnt;
			}
			if(!(r.nextLong(123, 123) == 123)) {
				ret = it.doesnt;
			}
			if(!(r.nextLong(-123, -123) == -123)) {
				ret = it.doesnt;
			}
			if(!(r.nextLong(123, -123) == 123)) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Invalid Format String") { ret = it.doesnt; }
			ret = it.does;
		}
		return ret;
	}

	it nextLong_should_return_a_value_within_bounds() {
		before_nextLong();
		it ret = it.does;
		try {
			auto r = new Random();
			long v;
			long lower = 0;
			long upper = 1;
			for (uint i = 0; i < REPEATS; i++) {
			v = r.nextLong(lower, upper);
			if(!(v >= lower)) {
				ret = it.doesnt;
			}
			if(!(v < upper)) {
				ret = it.doesnt;
			}
			lower -= i;
			upper += 2*i;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Invalid Format String") { ret = it.doesnt; }
			ret = it.does;
		}
		return ret;
	}

	done before_nextLong() {
	}

	it nextBoolean_should_return_a_boolean() {
		before_nextBoolean();
		it ret = it.does;
		try {
			auto r = new Random();
			bool to_be = r.nextBoolean();
			if(!(to_be || !to_be)) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Invalid Format String") { ret = it.doesnt; }
			ret = it.does;
		}
		return ret;
	}

	done before_nextBoolean() {
	}

	it nextDouble_should_return_a_value_between_0_and_1() {
		before_nextDouble();
		it ret = it.does;
		try {
			auto r = new Random();
			double v;
			for (uint i = 0; i < REPEATS; i++) {
			v = r.nextDouble();
			if(!(v >= 0.0)) {
				ret = it.doesnt;
			}
			if(!(v <= 1.0)) {
				ret = it.doesnt;
			}
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Invalid Format String") { ret = it.doesnt; }
			ret = it.does;
		}
		return ret;
	}

	done before_nextDouble() {
	}

	it nextFloat_should_return_a_value_between_0_and_1() {
		before_nextFloat();
		it ret = it.does;
		try {
			auto r = new Random();
			double v;
			for (uint i = 0; i < REPEATS; i++) {
			v = r.nextFloat();
			if(!(v >= 0.0)) {
				ret = it.doesnt;
			}
			if(!(v <= 1.0)) {
				ret = it.doesnt;
			}
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Invalid Format String") { ret = it.doesnt; }
			ret = it.does;
		}
		return ret;
	}

	done before_nextFloat() {
	}

	it choose_should_fail_on_empty_list() {
		before_choose();
		it ret = it.does;
		try {
			auto r = new Random();
			r.choose(new List!(uint));
		}
		catch(Exception _exception_) {
			ret = it.does;
		}
		return ret;
	}

	it choose_should_return_the_item_given_one() {
		before_choose();
		it ret = it.does;
		try {
			auto r = new Random();
			uint[] arr = [1234];
			if(!(r.choose(arr) == 1234)) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			ret = it.does;
		}
		return ret;
	}

	it choose_should_work_for_arrays() {
		before_choose();
		it ret = it.does;
		try {
			auto r = new Random();
			uint[] arr = [2, 5, 6, 9, 10, 13];
			uint v;
			for (uint i = 0; i < REPEATS; i++) {
			v = r.choose(arr);
			if(member(v, arr) is null) {
				ret = it.doesnt;
			}
			}
		}
		catch(Exception _exception_) {
			ret = it.does;
		}
		return ret;
	}

	it choose_should_work_for_lists() {
		before_choose();
		it ret = it.does;
		try {
			auto r = new Random();
			List!(char) lst = new List!(char)(['a', 'e', 'i', 'o', 'u']);
			char v;
			for (uint i = 0; i < REPEATS; i++) {
			v = r.choose(lst);
			if(member(v, lst) is null) {
				ret = it.doesnt;
			}
			}
		}
		catch(Exception _exception_) {
			ret = it.does;
		}
		return ret;
	}

	done before_choose() {
	}

	done before() {
	}

	this() {
		before();
	}

	static void test() {
		RandomTester tester = new RandomTester();

		Test test = new Test("Random", "specs/core/random.d");

		it result;

		test.logSubset("creation");

		tester = new RandomTester();

		result = tester.creation_should_have_sane_defaults();
		test.logResult(result, "creation should have sane defaults", "12");

		tester = new RandomTester();

		result = tester.creation_should_not_reuse_a_seed();
		test.logResult(result, "creation should not reuse a seed", "17");

		tester = new RandomTester();

		result = tester.creation_should_use_the_given_seed();
		test.logResult(result, "creation should use the given seed", "23");

		test.logSubset("state");

		tester = new RandomTester();

		result = tester.state_should_be_reproducible();
		test.logResult(result, "state should be reproducible", "30");

		test.logSubset("seed");

		tester = new RandomTester();

		result = tester.seed_should_set_and_get_the_seed();
		test.logResult(result, "seed should set and get the seed", "38");

		test.logSubset("next");

		tester = new RandomTester();

		result = tester.next_should_not_be_stuck();
		test.logResult(result, "next should not be stuck", "48");

		tester = new RandomTester();

		result = tester.next_should_return_zero_if_upper_bound_is_zero();
		test.logResult(result, "next should return zero if upper bound is zero", "53");

		tester = new RandomTester();

		result = tester.next_should_return_a_nonnegative_value_less_than_upper_bound();
		test.logResult(result, "next should return a nonnegative value less than upper bound", "58");

		tester = new RandomTester();

		result = tester.next_should_return_greatest_bound_if_bounds_overlap();
		test.logResult(result, "next should return greatest bound if bounds overlap", "70");

		tester = new RandomTester();

		result = tester.next_should_return_a_value_within_bounds();
		test.logResult(result, "next should return a value within bounds", "78");

		test.logSubset("nextLong");

		tester = new RandomTester();

		result = tester.nextLong_should_not_be_stuck();
		test.logResult(result, "nextLong should not be stuck", "94");

		tester = new RandomTester();

		result = tester.nextLong_should_return_zero_if_upper_bound_is_zero();
		test.logResult(result, "nextLong should return zero if upper bound is zero", "99");

		tester = new RandomTester();

		result = tester.nextLong_should_return_a_nonnegative_value_less_than_upper_bound();
		test.logResult(result, "nextLong should return a nonnegative value less than upper bound", "104");

		tester = new RandomTester();

		result = tester.nextLong_should_return_greatest_bound_if_bounds_overlap();
		test.logResult(result, "nextLong should return greatest bound if bounds overlap", "116");

		tester = new RandomTester();

		result = tester.nextLong_should_return_a_value_within_bounds();
		test.logResult(result, "nextLong should return a value within bounds", "124");

		test.logSubset("nextBoolean");

		tester = new RandomTester();

		result = tester.nextBoolean_should_return_a_boolean();
		test.logResult(result, "nextBoolean should return a boolean", "140");

		test.logSubset("nextDouble");

		tester = new RandomTester();

		result = tester.nextDouble_should_return_a_value_between_0_and_1();
		test.logResult(result, "nextDouble should return a value between 0 and 1", "148");

		test.logSubset("nextFloat");

		tester = new RandomTester();

		result = tester.nextFloat_should_return_a_value_between_0_and_1();
		test.logResult(result, "nextFloat should return a value between 0 and 1", "160");

		test.logSubset("choose");

		tester = new RandomTester();

		result = tester.choose_should_fail_on_empty_list();
		test.logResult(result, "choose should fail on empty list", "173");

		tester = new RandomTester();

		result = tester.choose_should_return_the_item_given_one();
		test.logResult(result, "choose should return the item given one", "180");

		tester = new RandomTester();

		result = tester.choose_should_work_for_arrays();
		test.logResult(result, "choose should work for arrays", "186");

		tester = new RandomTester();

		result = tester.choose_should_work_for_lists();
		test.logResult(result, "choose should work for lists", "196");

		test.finish();
	}
}

import core.application;

class ApplicationTester {

	it creation_should_not_create_inside_another_application() {
		before_creation();
		it ret = it.does;
		try {
			class MyApplication : Application {}
			MyApplication app = new MyApplication();
		}
		catch(Exception _exception_) {
			ret = it.does;
		}
		return ret;
	}

	done before_creation() {
	}

	it name_should_get_the_name() {
		before_name();
		it ret = it.does;
		try {
			if(!(Djehuty.application().name() == "DjehutyTester")) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			ret = it.does;
		}
		return ret;
	}

	done before_name() {
	}

	done before() {
	}

	this() {
		before();
	}

	static void test() {
		ApplicationTester tester = new ApplicationTester();

		Test test = new Test("Application", "specs/core/application.d");

		it result;

		test.logSubset("creation");

		tester = new ApplicationTester();

		result = tester.creation_should_not_create_inside_another_application();
		test.logResult(result, "creation should not create inside another application", "8");

		test.logSubset("name");

		tester = new ApplicationTester();

		result = tester.name_should_get_the_name();
		test.logResult(result, "name should get the name", "16");

		test.finish();
	}
}

import core.time;

class TimeTester {

	it creation_should_have_sane_defaults() {
		before_creation();
		it ret = it.does;
		try {
			auto t = new Time();
			if(!(t.microseconds == 0)) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			ret = it.does;
		}
		return ret;
	}

	it creation_should_handle_zero_milliseconds() {
		before_creation();
		it ret = it.does;
		try {
			auto t = new Time(0);
			if(!(t.microseconds == 0)) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			ret = it.does;
		}
		return ret;
	}

	it creation_should_handle_positive_microseconds() {
		before_creation();
		it ret = it.does;
		try {
			auto t = new Time(1234000);
			if(!(t.microseconds == 1234000)) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			ret = it.does;
		}
		return ret;
	}

	it creation_should_handle_negative_microseconds() {
		before_creation();
		it ret = it.does;
		try {
			auto t = new Time(-1234000);
			if(!(t.microseconds == -1234000)) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			ret = it.does;
		}
		return ret;
	}

	it creation_should_handle_hours_minutes_seconds() {
		before_creation();
		it ret = it.does;
		try {
			auto t = new Time(1, 2, 3);
			if(!(t.microseconds == 3723000000)) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			ret = it.does;
		}
		return ret;
	}

	it creation_should_handle_hours_minutes_seconds_microseconds() {
		before_creation();
		it ret = it.does;
		try {
			auto t = new Time(1, 2, 3, 4);
			if(!(t.microseconds == 3723000004)) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			ret = it.does;
		}
		return ret;
	}

	it creation_should_handle_negative_everything() {
		before_creation();
		it ret = it.does;
		try {
			auto t = new Time(-1, -2, -3, -4);
			if(!(t.microseconds == -3723000004)) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			ret = it.does;
		}
		return ret;
	}

	done before_creation() {
	}

	it Now_should_return_a_new_time() {
		before_Now();
		it ret = it.does;
		try {
			auto n = Time.Now();
			if(cast(Time)n is null) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			ret = it.does;
		}
		return ret;
	}

	done before_Now() {
	}

	it hours_should_handle_zero_time() {
		before_hours();
		it ret = it.does;
		try {
			auto t = new Time(0);
			if(!(t.hours == 0)) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			ret = it.does;
		}
		return ret;
	}

	it hours_should_handle_positive_time() {
		before_hours();
		it ret = it.does;
		try {
			auto t = new Time(3L * 60L * 60L * 1000000L);
			if(!(t.hours == 3)) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			ret = it.does;
		}
		return ret;
	}

	it hours_should_handle_negative_time() {
		before_hours();
		it ret = it.does;
		try {
			auto t = new Time(-3L * 60L * 60L * 1000000L);
			if(!(t.hours == -3)) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			ret = it.does;
		}
		return ret;
	}

	done before_hours() {
	}

	it minutes_should_handle_zero_time() {
		before_minutes();
		it ret = it.does;
		try {
			auto t = new Time(0);
			if(!(t.minutes == 0)) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			ret = it.does;
		}
		return ret;
	}

	it minutes_should_handle_positive_time() {
		before_minutes();
		it ret = it.does;
		try {
			auto t = new Time(25L * 60L * 1000000L);
			if(!(t.minutes == 25)) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			ret = it.does;
		}
		return ret;
	}

	it minutes_should_handle_negative_time() {
		before_minutes();
		it ret = it.does;
		try {
			auto t = new Time(-25L * 60L * 1000000L);
			if(!(t.minutes == -25)) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			ret = it.does;
		}
		return ret;
	}

	done before_minutes() {
	}

	it seconds_should_handle_zero_time() {
		before_seconds();
		it ret = it.does;
		try {
			auto t = new Time(0);
			if(!(t.seconds == 0)) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			ret = it.does;
		}
		return ret;
	}

	it seconds_should_handle_positive_time() {
		before_seconds();
		it ret = it.does;
		try {
			auto t = new Time(45L * 1000000L);
			if(!(t.seconds == 45)) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			ret = it.does;
		}
		return ret;
	}

	it seconds_should_handle_negative_time() {
		before_seconds();
		it ret = it.does;
		try {
			auto t = new Time(-45L * 1000000L);
			if(!(t.seconds == -45)) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			ret = it.does;
		}
		return ret;
	}

	done before_seconds() {
	}

	it milliseconds_should_handle_zero_time() {
		before_milliseconds();
		it ret = it.does;
		try {
			auto t = new Time(0);
			if(!(t.milliseconds == 0)) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			ret = it.does;
		}
		return ret;
	}

	it milliseconds_should_handle_positive_time() {
		before_milliseconds();
		it ret = it.does;
		try {
			auto t = new Time(678L * 1000L);
			if(!(t.milliseconds == 678)) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			ret = it.does;
		}
		return ret;
	}

	it milliseconds_should_handle_negative_time() {
		before_milliseconds();
		it ret = it.does;
		try {
			auto t = new Time(-678L * 1000L);
			if(!(t.milliseconds == -678)) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			ret = it.does;
		}
		return ret;
	}

	it milliseconds_should_handle_being_set_to_zero_milliseconds() {
		before_milliseconds();
		it ret = it.does;
		try {
			auto t = new Time();
			t.milliseconds = 0;
			if(!(t.microseconds == 0)) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			ret = it.does;
		}
		return ret;
	}

	it milliseconds_should_handle_being_set_to_positive_milliseconds() {
		before_milliseconds();
		it ret = it.does;
		try {
			auto t = new Time();
			t.milliseconds = 1234;
			if(!(t.microseconds == 1234000)) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			ret = it.does;
		}
		return ret;
	}

	it milliseconds_should_handle_being_set_to_negative_milliseconds() {
		before_milliseconds();
		it ret = it.does;
		try {
			auto t = new Time();
			t.milliseconds = -1234;
			if(!(t.microseconds == -1234000)) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			ret = it.does;
		}
		return ret;
	}

	done before_milliseconds() {
	}

	it microseconds_should_handle_being_set_to_zero_microseconds() {
		before_microseconds();
		it ret = it.does;
		try {
			auto t = new Time();
			t.microseconds = 0;
			if(!(t.microseconds == 0)) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			ret = it.does;
		}
		return ret;
	}

	it microseconds_should_handle_being_set_to_positive_microseconds() {
		before_microseconds();
		it ret = it.does;
		try {
			auto t = new Time();
			t.microseconds = 1234;
			if(!(t.microseconds == 1234)) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			ret = it.does;
		}
		return ret;
	}

	it microseconds_should_handle_being_set_to_negative_microseconds() {
		before_microseconds();
		it ret = it.does;
		try {
			auto t = new Time();
			t.microseconds(-1234);
			if(!(t.microseconds == -1234)) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			ret = it.does;
		}
		return ret;
	}

	done before_microseconds() {
	}

	it comparators_should_handle_equal_times() {
		before_comparators();
		it ret = it.does;
		try {
			auto a = new Time(1234);
			auto b = new Time(1234);
			if(a < b) {
				ret = it.doesnt;
			}
			if(!(a == b)) {
				ret = it.doesnt;
			}
			if(a > b) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			ret = it.does;
		}
		return ret;
	}

	it comparators_should_handle_unequal_times() {
		before_comparators();
		it ret = it.does;
		try {
			auto a = new Time(-1234);
			auto b = new Time(1234);
			if(!(a < b)) {
				ret = it.doesnt;
			}
			if(a == b) {
				ret = it.doesnt;
			}
			if(a > b) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			ret = it.does;
		}
		return ret;
	}

	done before_comparators() {
	}

	it toString_should_handle_zero_time() {
		before_toString();
		it ret = it.does;
		try {
			auto t = new Time(0);
			if(!(t.toString() == "00:00:00.000")) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			ret = it.does;
		}
		return ret;
	}

	it toString_should_handle_some_microseconds() {
		before_toString();
		it ret = it.does;
		try {
			auto t = new Time();
			t.microseconds = 123456;
			if(!(t.toString() == "00:00:00.123")) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			ret = it.does;
		}
		return ret;
	}

	it toString_should_handle_some_milliseconds() {
		before_toString();
		it ret = it.does;
		try {
			auto t = new Time(123000);
			if(!(t.toString() == "00:00:00.123")) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			ret = it.does;
		}
		return ret;
	}

	it toString_should_handle_hours_minutes_seconds() {
		before_toString();
		it ret = it.does;
		try {
			auto t = new Time(10, 2, 30);
			if(!(t.toString() == "10:02:30.000")) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			ret = it.does;
		}
		return ret;
	}

	it toString_should_handle_everything() {
		before_toString();
		it ret = it.does;
		try {
			auto t = new Time(12345678000);
			if(!(t.toString() == "03:25:45.678")) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			ret = it.does;
		}
		return ret;
	}

	it toString_should_handle_negative_time() {
		before_toString();
		it ret = it.does;
		try {
			auto t = new Time(-12345678000);
			if(!(t.toString() == "-03:25:45.678")) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			ret = it.does;
		}
		return ret;
	}

	done before_toString() {
	}

	it opAdd_should_work() {
		before_opAdd();
		it ret = it.does;
		try {
			auto a = new Time(1000000);
			auto b = new Time(234000);
			auto c = a + b;
			if(!(c.microseconds == 1234000)) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			ret = it.does;
		}
		return ret;
	}

	done before_opAdd() {
	}

	it opSub_should_work() {
		before_opSub();
		it ret = it.does;
		try {
			auto a = new Time(234000);
			auto b = new Time(1234000);
			auto c = a - b;
			if(!(c.microseconds == -1000000)) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			ret = it.does;
		}
		return ret;
	}

	done before_opSub() {
	}

	it opAddAssign_should_work() {
		before_opAddAssign();
		it ret = it.does;
		try {
			auto a = new Time(1000000);
			auto b = new Time(234000);
			a += b;
			if(!(a.microseconds == 1234000)) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			ret = it.does;
		}
		return ret;
	}

	done before_opAddAssign() {
	}

	it opSubAssign_should_work() {
		before_opSubAssign();
		it ret = it.does;
		try {
			auto a = new Time(234000);
			auto b = new Time(1234000);
			a -= b;
			if(!(a.microseconds == -1000000)) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			ret = it.does;
		}
		return ret;
	}

	done before_opSubAssign() {
	}

	done before() {
	}

	this() {
		before();
	}

	static void test() {
		TimeTester tester = new TimeTester();

		Test test = new Test("Time", "specs/core/time.d");

		it result;

		test.logSubset("creation");

		tester = new TimeTester();

		result = tester.creation_should_have_sane_defaults();
		test.logResult(result, "creation should have sane defaults", "9");

		tester = new TimeTester();

		result = tester.creation_should_handle_zero_milliseconds();
		test.logResult(result, "creation should handle zero milliseconds", "14");

		tester = new TimeTester();

		result = tester.creation_should_handle_positive_microseconds();
		test.logResult(result, "creation should handle positive microseconds", "19");

		tester = new TimeTester();

		result = tester.creation_should_handle_negative_microseconds();
		test.logResult(result, "creation should handle negative microseconds", "24");

		tester = new TimeTester();

		result = tester.creation_should_handle_hours_minutes_seconds();
		test.logResult(result, "creation should handle hours minutes seconds", "29");

		tester = new TimeTester();

		result = tester.creation_should_handle_hours_minutes_seconds_microseconds();
		test.logResult(result, "creation should handle hours minutes seconds microseconds", "34");

		tester = new TimeTester();

		result = tester.creation_should_handle_negative_everything();
		test.logResult(result, "creation should handle negative everything", "39");

		test.logSubset("Now");

		tester = new TimeTester();

		result = tester.Now_should_return_a_new_time();
		test.logResult(result, "Now should return a new time", "46");

		test.logSubset("hours");

		tester = new TimeTester();

		result = tester.hours_should_handle_zero_time();
		test.logResult(result, "hours should handle zero time", "53");

		tester = new TimeTester();

		result = tester.hours_should_handle_positive_time();
		test.logResult(result, "hours should handle positive time", "58");

		tester = new TimeTester();

		result = tester.hours_should_handle_negative_time();
		test.logResult(result, "hours should handle negative time", "63");

		test.logSubset("minutes");

		tester = new TimeTester();

		result = tester.minutes_should_handle_zero_time();
		test.logResult(result, "minutes should handle zero time", "70");

		tester = new TimeTester();

		result = tester.minutes_should_handle_positive_time();
		test.logResult(result, "minutes should handle positive time", "75");

		tester = new TimeTester();

		result = tester.minutes_should_handle_negative_time();
		test.logResult(result, "minutes should handle negative time", "80");

		test.logSubset("seconds");

		tester = new TimeTester();

		result = tester.seconds_should_handle_zero_time();
		test.logResult(result, "seconds should handle zero time", "87");

		tester = new TimeTester();

		result = tester.seconds_should_handle_positive_time();
		test.logResult(result, "seconds should handle positive time", "92");

		tester = new TimeTester();

		result = tester.seconds_should_handle_negative_time();
		test.logResult(result, "seconds should handle negative time", "97");

		test.logSubset("milliseconds");

		tester = new TimeTester();

		result = tester.milliseconds_should_handle_zero_time();
		test.logResult(result, "milliseconds should handle zero time", "104");

		tester = new TimeTester();

		result = tester.milliseconds_should_handle_positive_time();
		test.logResult(result, "milliseconds should handle positive time", "109");

		tester = new TimeTester();

		result = tester.milliseconds_should_handle_negative_time();
		test.logResult(result, "milliseconds should handle negative time", "114");

		tester = new TimeTester();

		result = tester.milliseconds_should_handle_being_set_to_zero_milliseconds();
		test.logResult(result, "milliseconds should handle being set to zero milliseconds", "119");

		tester = new TimeTester();

		result = tester.milliseconds_should_handle_being_set_to_positive_milliseconds();
		test.logResult(result, "milliseconds should handle being set to positive milliseconds", "125");

		tester = new TimeTester();

		result = tester.milliseconds_should_handle_being_set_to_negative_milliseconds();
		test.logResult(result, "milliseconds should handle being set to negative milliseconds", "131");

		test.logSubset("microseconds");

		tester = new TimeTester();

		result = tester.microseconds_should_handle_being_set_to_zero_microseconds();
		test.logResult(result, "microseconds should handle being set to zero microseconds", "139");

		tester = new TimeTester();

		result = tester.microseconds_should_handle_being_set_to_positive_microseconds();
		test.logResult(result, "microseconds should handle being set to positive microseconds", "145");

		tester = new TimeTester();

		result = tester.microseconds_should_handle_being_set_to_negative_microseconds();
		test.logResult(result, "microseconds should handle being set to negative microseconds", "151");

		test.logSubset("comparators");

		tester = new TimeTester();

		result = tester.comparators_should_handle_equal_times();
		test.logResult(result, "comparators should handle equal times", "159");

		tester = new TimeTester();

		result = tester.comparators_should_handle_unequal_times();
		test.logResult(result, "comparators should handle unequal times", "167");

		test.logSubset("toString");

		tester = new TimeTester();

		result = tester.toString_should_handle_zero_time();
		test.logResult(result, "toString should handle zero time", "177");

		tester = new TimeTester();

		result = tester.toString_should_handle_some_microseconds();
		test.logResult(result, "toString should handle some microseconds", "182");

		tester = new TimeTester();

		result = tester.toString_should_handle_some_milliseconds();
		test.logResult(result, "toString should handle some milliseconds", "188");

		tester = new TimeTester();

		result = tester.toString_should_handle_hours_minutes_seconds();
		test.logResult(result, "toString should handle hours minutes seconds", "193");

		tester = new TimeTester();

		result = tester.toString_should_handle_everything();
		test.logResult(result, "toString should handle everything", "198");

		tester = new TimeTester();

		result = tester.toString_should_handle_negative_time();
		test.logResult(result, "toString should handle negative time", "203");

		test.logSubset("opAdd");

		tester = new TimeTester();

		result = tester.opAdd_should_work();
		test.logResult(result, "opAdd should work", "210");

		test.logSubset("opSub");

		tester = new TimeTester();

		result = tester.opSub_should_work();
		test.logResult(result, "opSub should work", "219");

		test.logSubset("opAddAssign");

		tester = new TimeTester();

		result = tester.opAddAssign_should_work();
		test.logResult(result, "opAddAssign should work", "228");

		test.logSubset("opSubAssign");

		tester = new TimeTester();

		result = tester.opSubAssign_should_work();
		test.logResult(result, "opSubAssign should work", "237");

		test.finish();
	}
}

import core.exception;

class ExceptionTester {

	it FileNotFound_should_work_with_no_explanation() {
		before_FileNotFound();
		it ret = it.does;
		try {
			throw new FileNotFound();
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "File Not Found") { ret = it.doesnt; }
			ret = it.does;
		}
		return ret;
	}

	it FileNotFound_should_work_with_string() {
		before_FileNotFound();
		it ret = it.does;
		try {
			throw new FileNotFound("some_file");
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "File Not Found: some_file") { ret = it.doesnt; }
			ret = it.does;
		}
		return ret;
	}

	done before_FileNotFound() {
	}

	it DirectoryNotFound_should_work_with_no_explanation() {
		before_DirectoryNotFound();
		it ret = it.does;
		try {
			throw new DirectoryNotFound();
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Directory Not Found") { ret = it.doesnt; }
			ret = it.does;
		}
		return ret;
	}

	it DirectoryNotFound_should_work_with_string() {
		before_DirectoryNotFound();
		it ret = it.does;
		try {
			throw new DirectoryNotFound("some_dir");
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Directory Not Found: some_dir") { ret = it.doesnt; }
			ret = it.does;
		}
		return ret;
	}

	done before_DirectoryNotFound() {
	}

	it OutOfElements_should_work_with_no_explanation() {
		before_OutOfElements();
		it ret = it.does;
		try {
			throw new OutOfElements();
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Out of Elements") { ret = it.doesnt; }
			ret = it.does;
		}
		return ret;
	}

	it OutOfElements_should_work_with_string() {
		before_OutOfElements();
		it ret = it.does;
		try {
			throw new OutOfElements("SomeClass");
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Out of Elements in SomeClass") { ret = it.doesnt; }
			ret = it.does;
		}
		return ret;
	}

	done before_OutOfElements() {
	}

	it OutOfBounds_should_work_with_no_explanation() {
		before_OutOfBounds();
		it ret = it.does;
		try {
			throw new OutOfBounds();
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Out of Bounds") { ret = it.doesnt; }
			ret = it.does;
		}
		return ret;
	}

	it OutOfBounds_should_work_with_string() {
		before_OutOfBounds();
		it ret = it.does;
		try {
			throw new OutOfBounds("SomeClass");
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Out of Bounds in SomeClass") { ret = it.doesnt; }
			ret = it.does;
		}
		return ret;
	}

	done before_OutOfBounds() {
	}

	it ElementNotFound_should_work_with_no_explanation() {
		before_ElementNotFound();
		it ret = it.does;
		try {
			throw new ElementNotFound();
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Element Not Found") { ret = it.doesnt; }
			ret = it.does;
		}
		return ret;
	}

	it ElementNotFound_should_work_with_string() {
		before_ElementNotFound();
		it ret = it.does;
		try {
			throw new ElementNotFound("SomeClass");
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Element Not Found in SomeClass") { ret = it.doesnt; }
			ret = it.does;
		}
		return ret;
	}

	done before_ElementNotFound() {
	}

	done before() {
	}

	this() {
		before();
	}

	static void test() {
		ExceptionTester tester = new ExceptionTester();

		Test test = new Test("Exception", "specs/core/exception.d");

		it result;

		test.logSubset("FileNotFound");

		tester = new ExceptionTester();

		result = tester.FileNotFound_should_work_with_no_explanation();
		test.logResult(result, "FileNotFound should work with no explanation", "9");

		tester = new ExceptionTester();

		result = tester.FileNotFound_should_work_with_string();
		test.logResult(result, "FileNotFound should work with string", "14");

		test.logSubset("DirectoryNotFound");

		tester = new ExceptionTester();

		result = tester.DirectoryNotFound_should_work_with_no_explanation();
		test.logResult(result, "DirectoryNotFound should work with no explanation", "21");

		tester = new ExceptionTester();

		result = tester.DirectoryNotFound_should_work_with_string();
		test.logResult(result, "DirectoryNotFound should work with string", "26");

		test.logSubset("OutOfElements");

		tester = new ExceptionTester();

		result = tester.OutOfElements_should_work_with_no_explanation();
		test.logResult(result, "OutOfElements should work with no explanation", "33");

		tester = new ExceptionTester();

		result = tester.OutOfElements_should_work_with_string();
		test.logResult(result, "OutOfElements should work with string", "38");

		test.logSubset("OutOfBounds");

		tester = new ExceptionTester();

		result = tester.OutOfBounds_should_work_with_no_explanation();
		test.logResult(result, "OutOfBounds should work with no explanation", "45");

		tester = new ExceptionTester();

		result = tester.OutOfBounds_should_work_with_string();
		test.logResult(result, "OutOfBounds should work with string", "50");

		test.logSubset("ElementNotFound");

		tester = new ExceptionTester();

		result = tester.ElementNotFound_should_work_with_no_explanation();
		test.logResult(result, "ElementNotFound should work with no explanation", "57");

		tester = new ExceptionTester();

		result = tester.ElementNotFound_should_work_with_string();
		test.logResult(result, "ElementNotFound should work with string", "62");

		test.finish();
	}
}

import hashes.md5;

class MD5Tester {

	it hash_should_hash_as_expected_for_string_literals() {
		before_hash();
		it ret = it.does;
		try {
			string s = HashMD5.hash("Hashing Hashing Hashing").toString();
			if(!(s == "7ba85cd90a910d790172b15e895f8e56")) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Element Not Found in SomeClass") { ret = it.doesnt; }
			ret = it.does;
		}
		return ret;
	}

	it hash_should_respect_leading_zeroes() {
		before_hash();
		it ret = it.does;
		try {
			// Testing: leading 0s on parts, note that there is a 0 on the 9th value from the 
			string s = HashMD5.hash("d").toString();
			if(!(s == "8277e0910d750195b448797616e091ad")) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Element Not Found in SomeClass") { ret = it.doesnt; }
			ret = it.does;
		}
		return ret;
	}

	it hash_should_work_on_byte_arrays() {
		before_hash();
		it ret = it.does;
		try {
			// Testing a classic MD5 
			ubyte[] filea = cast(ubyte[])import("testmd5a.bin");
			ubyte[] fileb = cast(ubyte[])import("testmd5b.bin");
			string a = HashMD5.hash(filea).toString();
			string b = HashMD5.hash(fileb).toString();
			if(!(a == b)) {
				ret = it.doesnt;
			}
			if(!(a == "da5c61e1edc0f18337e46418e48c1290")) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Element Not Found in SomeClass") { ret = it.doesnt; }
			ret = it.does;
		}
		return ret;
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

		result = tester.hash_should_hash_as_expected_for_string_literals();
		test.logResult(result, "hash should hash as expected for string literals", "9");

		tester = new MD5Tester();

		result = tester.hash_should_respect_leading_zeroes();
		test.logResult(result, "hash should respect leading zeroes", "14");

		tester = new MD5Tester();

		result = tester.hash_should_work_on_byte_arrays();
		test.logResult(result, "hash should work on byte arrays", "20");

		test.finish();
	}
}

import hashes.sha256;

class SHA256Tester {

	it hash_should_hash_as_expected_for_string_literals() {
		before_hash();
		it ret = it.does;
		try {
			string s = HashSHA256.hash("a").toString();
			if(!(s == "ca978112ca1bbdcafac231b39a23dc4da786eff8147c4e72b9807785afee48bb")) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Element Not Found in SomeClass") { ret = it.doesnt; }
			ret = it.does;
		}
		return ret;
	}

	it hash_should_hash_the_empty_string() {
		before_hash();
		it ret = it.does;
		try {
			string s = HashSHA256.hash("").toString();
			if(!(s == "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855")) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Element Not Found in SomeClass") { ret = it.doesnt; }
			ret = it.does;
		}
		return ret;
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

		result = tester.hash_should_hash_as_expected_for_string_literals();
		test.logResult(result, "hash should hash as expected for string literals", "9");

		tester = new SHA256Tester();

		result = tester.hash_should_hash_the_empty_string();
		test.logResult(result, "hash should hash the empty string", "14");

		test.finish();
	}
}

import hashes.sha224;

class SHA224Tester {

	it hash_should_hash_as_expected_for_string_literals() {
		before_hash();
		it ret = it.does;
		try {
			string s = HashSHA224.hash("a").toString();
			if(!(s == "abd37534c7d9a2efb9465de931cd7055ffdb8879563ae98078d6d6d5")) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Element Not Found in SomeClass") { ret = it.doesnt; }
			ret = it.does;
		}
		return ret;
	}

	it hash_should_hash_the_empty_string() {
		before_hash();
		it ret = it.does;
		try {
			string s = HashSHA224.hash("").toString();
			if(!(s == "d14a028c2a3a2bc9476102bb288234c415a2b01f828ea62ac5b3e42f")) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Element Not Found in SomeClass") { ret = it.doesnt; }
			ret = it.does;
		}
		return ret;
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

		result = tester.hash_should_hash_as_expected_for_string_literals();
		test.logResult(result, "hash should hash as expected for string literals", "9");

		tester = new SHA224Tester();

		result = tester.hash_should_hash_the_empty_string();
		test.logResult(result, "hash should hash the empty string", "14");

		test.finish();
	}
}

import hashes.digest;

class DigestTester {

	it creation_should_allow_for_64_bits() {
		before_creation();
		it ret = it.does;
		try {
			Digest d = new Digest(0xDEADBEEF, 0x01234567);
			string s = d.toString();
			if(!(s == "deadbeef01234567")) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Element Not Found in SomeClass") { ret = it.doesnt; }
			ret = it.does;
		}
		return ret;
	}

	it creation_should_allow_for_128_bits() {
		before_creation();
		it ret = it.does;
		try {
			Digest d = new Digest(0xDEADBEEF, 0x01234567, 0xDEADBEEF, 0x01234567);
			string s = d.toString();
			if(!(s == "deadbeef01234567deadbeef01234567")) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Element Not Found in SomeClass") { ret = it.doesnt; }
			ret = it.does;
		}
		return ret;
	}

	it creation_should_allow_for_160_bits() {
		before_creation();
		it ret = it.does;
		try {
			Digest d = new Digest(0xDEADBEEF, 0x01234567, 0xDEADBEEF, 0x01234567, 0xDEADBEEF);
			string s = d.toString();
			if(!(s == "deadbeef01234567deadbeef01234567deadbeef")) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Element Not Found in SomeClass") { ret = it.doesnt; }
			ret = it.does;
		}
		return ret;
	}

	it creation_should_allow_for_192_bits() {
		before_creation();
		it ret = it.does;
		try {
			Digest d = new Digest(0xDEADBEEF, 0x01234567, 0xDEADBEEF, 0x01234567, 0xDEADBEEF, 0x01234567);
			string s = d.toString();
			if(!(s == "deadbeef01234567deadbeef01234567deadbeef01234567")) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Element Not Found in SomeClass") { ret = it.doesnt; }
			ret = it.does;
		}
		return ret;
	}

	done before_creation() {
	}

	it comparison_should_work_for_equals_overload() {
		before_comparison();
		it ret = it.does;
		try {
			Digest d1 = new Digest(0xDEADBEEF);
			Digest d2 = new Digest(0x01234567);
			Digest d3 = new Digest(0xDEADBEEF);
			if(!(d1 == d3)) {
				ret = it.doesnt;
			}
			if(d1 == d2) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Element Not Found in SomeClass") { ret = it.doesnt; }
			ret = it.does;
		}
		return ret;
	}

	it comparison_should_work_for_equals_function() {
		before_comparison();
		it ret = it.does;
		try {
			Digest d1 = new Digest(0xDEADBEEF);
			Digest d2 = new Digest(0x01234567);
			Digest d3 = new Digest(0xDEADBEEF);
			if(!(d1.equals(d3))) {
				ret = it.doesnt;
			}
			if(d1.equals(d2)) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Element Not Found in SomeClass") { ret = it.doesnt; }
			ret = it.does;
		}
		return ret;
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

import hashes.sha1;

class SHA1Tester {

	it hash_should_hash_as_expected_for_string_literals() {
		before_hash();
		it ret = it.does;
		try {
			string s = HashSHA1.hash("a").toString();
			if(!(s == "86f7e437faa5a7fce15d1ddcb9eaeaea377667b8")) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Element Not Found in SomeClass") { ret = it.doesnt; }
			ret = it.does;
		}
		return ret;
	}

	it hash_should_hash_the_empty_string() {
		before_hash();
		it ret = it.does;
		try {
			string s = HashSHA1.hash("").toString();
			if(!(s == "da39a3ee5e6b4b0d3255bfef95601890afd80709")) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Element Not Found in SomeClass") { ret = it.doesnt; }
			ret = it.does;
		}
		return ret;
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

		result = tester.hash_should_hash_as_expected_for_string_literals();
		test.logResult(result, "hash should hash as expected for string literals", "9");

		tester = new SHA1Tester();

		result = tester.hash_should_hash_the_empty_string();
		test.logResult(result, "hash should hash the empty string", "14");

		test.finish();
	}
}

import utils.fibonacci;

import utils.heap;

import core.random;

class FibonacciHeapTester {

	it creation_should_work_as_expected() {
		before_creation();
		it ret = it.does;
		try {
			FibonacciHeap!(int) queue = new FibonacciHeap!(int)();
			if(queue is null) {
				ret = it.doesnt;
			}
			if(!(queue.length == 0)) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Element Not Found in SomeClass") { ret = it.doesnt; }
			ret = it.does;
		}
		return ret;
	}

	done before_creation() {
	}

	it add_should_add_an_item_to_an_empty_list() {
		before_add();
		it ret = it.does;
		try {
			FibonacciHeap!(int) queue = new FibonacciHeap!(int)();
			int item = 42;
			queue.add(item);
			if(!(queue.length == 1)) {
				ret = it.doesnt;
			}
			if(!(queue.peek() == item)) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Element Not Found in SomeClass") { ret = it.doesnt; }
			ret = it.does;
		}
		return ret;
	}

	done before_add() {
	}

	it peek_should_return_the_first_item_in_min_heap() {
		before_peek();
		it ret = it.does;
		try {
			auto queue = new FibonacciHeap!(int, MinHeap);
			queue.add(10);
			queue.add(4);
			queue.add(15);
			if(!(queue.length == 3)) {
				ret = it.doesnt;
			}
			if(!(queue.peek() == 4)) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Element Not Found in SomeClass") { ret = it.doesnt; }
			ret = it.does;
		}
		return ret;
	}

	it peek_should_return_the_first_item_in_max_heap() {
		before_peek();
		it ret = it.does;
		try {
			auto queue = new FibonacciHeap!(int, MaxHeap);
			queue.add(10);
			queue.add(4);
			queue.add(15);
			if(!(queue.length == 3)) {
				ret = it.doesnt;
			}
			if(!(queue.peek() == 15)) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Element Not Found in SomeClass") { ret = it.doesnt; }
			ret = it.does;
		}
		return ret;
	}

	it peek_should_handle_a_heavy_workload() {
		before_peek();
		it ret = it.does;
		try {
			auto queue = new FibonacciHeap!(int, MinHeap);
			int min;
			int val;
			Random r = new Random();
			val = cast(int)r.next();
			queue.add(val);
			min = val;
			for(int i; i < 100; i++) {
			val = cast(int)r.next();
			queue.add(val);
			if (val < min) {
			min = val;
			}
			}
			if(!(queue.peek() == min)) {
				ret = it.doesnt;
			}
			int foo;
			int last = queue.peek();
			while (!queue.empty()) {
			foo = queue.remove();
			if(!(foo >= last)) {
				ret = it.doesnt;
			}
			last = foo;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Element Not Found in SomeClass") { ret = it.doesnt; }
			ret = it.does;
		}
		return ret;
	}

	done before_peek() {
	}

	it remove_should_remove_the_first_item_in_min_heap() {
		before_remove();
		it ret = it.does;
		try {
			auto queue = new FibonacciHeap!(int, MinHeap);
			queue.add(10);
			queue.add(4);
			queue.add(15);
			if(!(queue.length == 3)) {
				ret = it.doesnt;
			}
			if(!(queue.remove() == 4)) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Element Not Found in SomeClass") { ret = it.doesnt; }
			ret = it.does;
		}
		return ret;
	}

	it remove_should_remove_the_first_item_in_max_heap() {
		before_remove();
		it ret = it.does;
		try {
			auto queue = new FibonacciHeap!(int, MaxHeap);
			queue.add(10);
			queue.add(4);
			queue.add(15);
			if(!(queue.length == 3)) {
				ret = it.doesnt;
			}
			if(!(queue.remove() == 15)) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Element Not Found in SomeClass") { ret = it.doesnt; }
			ret = it.does;
		}
		return ret;
	}

	done before_remove() {
	}

	it length_should_be_zero_for_an_empty_list() {
		before_length();
		it ret = it.does;
		try {
			auto queue = new FibonacciHeap!(int);
			if(!(queue.empty)) {
				ret = it.doesnt;
			}
			if(!(queue.length == 0)) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Element Not Found in SomeClass") { ret = it.doesnt; }
			ret = it.does;
		}
		return ret;
	}

	done before_length() {
	}

	it clear_should_result_in_an_empty_list() {
		before_clear();
		it ret = it.does;
		try {
			auto queue = new FibonacciHeap!(int);
			queue.add(15);
			queue.add(10);
			queue.add(24);
			if(queue.length == 0) {
				ret = it.doesnt;
			}
			if(queue.empty()) {
				ret = it.doesnt;
			}
			queue.clear();
			if(!(queue.length == 0)) {
				ret = it.doesnt;
			}
			if(!(queue.empty())) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Element Not Found in SomeClass") { ret = it.doesnt; }
			ret = it.does;
		}
		return ret;
	}

	done before_clear() {
	}

	it empty_should_be_true_when_the_list_is_empty() {
		before_empty();
		it ret = it.does;
		try {
			auto queue = new FibonacciHeap!(int);
			queue.add(10);
			if(queue.empty()) {
				ret = it.doesnt;
			}
			queue.remove();
			if(!(queue.empty())) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Element Not Found in SomeClass") { ret = it.doesnt; }
			ret = it.does;
		}
		return ret;
	}

	it empty_should_be_true_for_a_new_list() {
		before_empty();
		it ret = it.does;
		try {
			auto queue = new FibonacciHeap!(int);
			if(!(queue.empty())) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Element Not Found in SomeClass") { ret = it.doesnt; }
			ret = it.does;
		}
		return ret;
	}

	done before_empty() {
	}

	done before() {
	}

	this() {
		before();
	}

	static void test() {
		FibonacciHeapTester tester = new FibonacciHeapTester();

		Test test = new Test("FibonacciHeap", "specs/utils/fibonacci.d");

		it result;

		test.logSubset("creation");

		tester = new FibonacciHeapTester();

		result = tester.creation_should_work_as_expected();
		test.logResult(result, "creation should work as expected", "10");

		test.logSubset("add");

		tester = new FibonacciHeapTester();

		result = tester.add_should_add_an_item_to_an_empty_list();
		test.logResult(result, "add should add an item to an empty list", "18");

		test.logSubset("peek");

		tester = new FibonacciHeapTester();

		result = tester.peek_should_return_the_first_item_in_min_heap();
		test.logResult(result, "peek should return the first item in min heap", "28");

		tester = new FibonacciHeapTester();

		result = tester.peek_should_return_the_first_item_in_max_heap();
		test.logResult(result, "peek should return the first item in max heap", "37");

		tester = new FibonacciHeapTester();

		result = tester.peek_should_handle_a_heavy_workload();
		test.logResult(result, "peek should handle a heavy workload", "46");

		test.logSubset("remove");

		tester = new FibonacciHeapTester();

		result = tester.remove_should_remove_the_first_item_in_min_heap();
		test.logResult(result, "remove should remove the first item in min heap", "78");

		tester = new FibonacciHeapTester();

		result = tester.remove_should_remove_the_first_item_in_max_heap();
		test.logResult(result, "remove should remove the first item in max heap", "87");

		test.logSubset("length");

		tester = new FibonacciHeapTester();

		result = tester.length_should_be_zero_for_an_empty_list();
		test.logResult(result, "length should be zero for an empty list", "98");

		test.logSubset("clear");

		tester = new FibonacciHeapTester();

		result = tester.clear_should_result_in_an_empty_list();
		test.logResult(result, "clear should result in an empty list", "106");

		test.logSubset("empty");

		tester = new FibonacciHeapTester();

		result = tester.empty_should_be_true_when_the_list_is_empty();
		test.logResult(result, "empty should be true when the list is empty", "122");

		tester = new FibonacciHeapTester();

		result = tester.empty_should_be_true_for_a_new_list();
		test.logResult(result, "empty should be true for a new list", "130");

		test.finish();
	}
}

import utils.stack;

class StackTester {

	it creation_should_create_with_no_size() {
		before_creation();
		it ret = it.does;
		try {
			Stack!(int) stack = new Stack!(int)();
			if(stack is null) {
				ret = it.doesnt;
			}
			if(!(stack.length == 0)) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Element Not Found in SomeClass") { ret = it.doesnt; }
			ret = it.does;
		}
		return ret;
	}

	it creation_should_create_with_size() {
		before_creation();
		it ret = it.does;
		try {
			Stack!(int) stack = new Stack!(int)(10);
			if(stack is null) {
				ret = it.doesnt;
			}
			if(!(stack.length == 0)) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Element Not Found in SomeClass") { ret = it.doesnt; }
			ret = it.does;
		}
		return ret;
	}

	it creation_should_create_with_array() {
		before_creation();
		it ret = it.does;
		try {
			int[3] arr = 1;
			Stack!(int) stack = new Stack!(int)(arr);
			if(stack is null) {
				ret = it.doesnt;
			}
			if(!(stack.length == 3)) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Element Not Found in SomeClass") { ret = it.doesnt; }
			ret = it.does;
		}
		return ret;
	}

	done before_creation() {
	}

	it duplicate_should_work_as_expected() {
		before_duplicate();
		it ret = it.does;
		try {
			Stack!(int) stack = new Stack!(int)();
			int item1 = 1;
			int item2 = 2;
			int item3 = 3;
			stack.push(item1);
			stack.push(item2);
			stack.push(item3);
			Stack!(int) dupStack = stack.dup();
			if(!(dupStack.length == 3)) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Element Not Found in SomeClass") { ret = it.doesnt; }
			ret = it.does;
		}
		return ret;
	}

	done before_duplicate() {
	}

	it pop_should_pop_items_in_correct_order() {
		before_pop();
		it ret = it.does;
		try {
			Stack!(int) stack = new Stack!(int)();
			int item1 = 1;
			int item2 = 2;
			int item3 = 3;
			stack.push(item1);
			stack.push(item2);
			stack.push(item3);
			if(!(stack.length == 3)) {
				ret = it.doesnt;
			}
			if(!(stack.pop == item3)) {
				ret = it.doesnt;
			}
			if(!(stack.length == 2)) {
				ret = it.doesnt;
			}
			if(!(stack.pop == item2)) {
				ret = it.doesnt;
			}
			if(!(stack.length == 1)) {
				ret = it.doesnt;
			}
			if(!(stack.pop == item1)) {
				ret = it.doesnt;
			}
			if(!(stack.length == 0)) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Element Not Found in SomeClass") { ret = it.doesnt; }
			ret = it.does;
		}
		return ret;
	}

	done before_pop() {
	}

	it push_should_push_an_item_onto_empty_stack() {
		before_push();
		it ret = it.does;
		try {
			Stack!(int) stack = new Stack!(int)();
			int item = 69;
			stack.push(item);
			if(!(stack.length == 1)) {
				ret = it.doesnt;
			}
			if(!(stack.pop == item)) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Element Not Found in SomeClass") { ret = it.doesnt; }
			ret = it.does;
		}
		return ret;
	}

	done before_push() {
	}

	done before() {
	}

	this() {
		before();
	}

	static void test() {
		StackTester tester = new StackTester();

		Test test = new Test("Stack", "specs/utils/stack.d");

		it result;

		test.logSubset("creation");

		tester = new StackTester();

		result = tester.creation_should_create_with_no_size();
		test.logResult(result, "creation should create with no size", "7");

		tester = new StackTester();

		result = tester.creation_should_create_with_size();
		test.logResult(result, "creation should create with size", "13");

		tester = new StackTester();

		result = tester.creation_should_create_with_array();
		test.logResult(result, "creation should create with array", "19");

		test.logSubset("duplicate");

		tester = new StackTester();

		result = tester.duplicate_should_work_as_expected();
		test.logResult(result, "duplicate should work as expected", "28");

		test.logSubset("pop");

		tester = new StackTester();

		result = tester.pop_should_pop_items_in_correct_order();
		test.logResult(result, "pop should pop items in correct order", "45");

		test.logSubset("push");

		tester = new StackTester();

		result = tester.push_should_push_an_item_onto_empty_stack();
		test.logResult(result, "push should push an item onto empty stack", "66");

		test.finish();
	}
}

import utils.heap;

import core.random;

class PriorityQueueTester {

	it creation_should_work_as_expected() {
		before_creation();
		it ret = it.does;
		try {
			PriorityQueue!(int) queue = new PriorityQueue!(int)();
			if(queue is null) {
				ret = it.doesnt;
			}
			if(!(queue.length == 0)) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Element Not Found in SomeClass") { ret = it.doesnt; }
			ret = it.does;
		}
		return ret;
	}

	done before_creation() {
	}

	it add_should_add_an_item_to_an_empty_list() {
		before_add();
		it ret = it.does;
		try {
			PriorityQueue!(int) queue = new PriorityQueue!(int)();
			int item = 42;
			queue.add(item);
			if(!(queue.length == 1)) {
				ret = it.doesnt;
			}
			if(!(queue.peek() == item)) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Element Not Found in SomeClass") { ret = it.doesnt; }
			ret = it.does;
		}
		return ret;
	}

	done before_add() {
	}

	it peek_should_return_the_first_item_in_min_heap() {
		before_peek();
		it ret = it.does;
		try {
			auto queue = new PriorityQueue!(int, MinHeap);
			queue.add(10);
			queue.add(4);
			queue.add(15);
			if(!(queue.length == 3)) {
				ret = it.doesnt;
			}
			if(!(queue.peek() == 4)) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Element Not Found in SomeClass") { ret = it.doesnt; }
			ret = it.does;
		}
		return ret;
	}

	it peek_should_return_the_first_item_in_max_heap() {
		before_peek();
		it ret = it.does;
		try {
			auto queue = new PriorityQueue!(int, MaxHeap);
			queue.add(10);
			queue.add(4);
			queue.add(15);
			if(!(queue.length == 3)) {
				ret = it.doesnt;
			}
			if(!(queue.peek() == 15)) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Element Not Found in SomeClass") { ret = it.doesnt; }
			ret = it.does;
		}
		return ret;
	}

	it peek_should_handle_a_heavy_workload() {
		before_peek();
		it ret = it.does;
		try {
			auto queue = new PriorityQueue!(int, MinHeap);
			int min;
			int val;
			Random r = new Random();
			val = cast(int)r.next();
			queue.add(val);
			min = val;
			for(int i; i < 10000; i++) {
			val = cast(int)r.next();
			queue.add(val);
			if (val < min) {
			min = val;
			}
			}
			if(!(queue.peek() == min)) {
				ret = it.doesnt;
			}
			int foo;
			int last = min;
			while (!queue.empty()) {
			foo = queue.remove();
			if(!(foo >= last)) {
				ret = it.doesnt;
			}
			last = foo;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Element Not Found in SomeClass") { ret = it.doesnt; }
			ret = it.does;
		}
		return ret;
	}

	done before_peek() {
	}

	it remove_should_remove_the_first_item_in_min_heap() {
		before_remove();
		it ret = it.does;
		try {
			auto queue = new PriorityQueue!(int, MinHeap);
			queue.add(10);
			queue.add(4);
			queue.add(15);
			if(!(queue.length == 3)) {
				ret = it.doesnt;
			}
			if(!(queue.remove() == 4)) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Element Not Found in SomeClass") { ret = it.doesnt; }
			ret = it.does;
		}
		return ret;
	}

	it remove_should_remove_the_first_item_in_max_heap() {
		before_remove();
		it ret = it.does;
		try {
			auto queue = new PriorityQueue!(int, MaxHeap);
			queue.add(10);
			queue.add(4);
			queue.add(15);
			if(!(queue.length == 3)) {
				ret = it.doesnt;
			}
			if(!(queue.remove() == 15)) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Element Not Found in SomeClass") { ret = it.doesnt; }
			ret = it.does;
		}
		return ret;
	}

	done before_remove() {
	}

	it length_should_be_zero_for_an_empty_list() {
		before_length();
		it ret = it.does;
		try {
			auto queue = new PriorityQueue!(int);
			if(!(queue.empty)) {
				ret = it.doesnt;
			}
			if(!(queue.length == 0)) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Element Not Found in SomeClass") { ret = it.doesnt; }
			ret = it.does;
		}
		return ret;
	}

	done before_length() {
	}

	it clear_should_result_in_an_empty_list() {
		before_clear();
		it ret = it.does;
		try {
			auto queue = new PriorityQueue!(int);
			queue.add(15);
			queue.add(10);
			queue.add(24);
			if(queue.length == 0) {
				ret = it.doesnt;
			}
			if(queue.empty()) {
				ret = it.doesnt;
			}
			queue.clear();
			if(!(queue.length == 0)) {
				ret = it.doesnt;
			}
			if(!(queue.empty())) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Element Not Found in SomeClass") { ret = it.doesnt; }
			ret = it.does;
		}
		return ret;
	}

	done before_clear() {
	}

	it empty_should_be_true_when_the_list_is_empty() {
		before_empty();
		it ret = it.does;
		try {
			auto queue = new PriorityQueue!(int);
			queue.add(10);
			if(queue.empty()) {
				ret = it.doesnt;
			}
			queue.remove();
			if(!(queue.empty())) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Element Not Found in SomeClass") { ret = it.doesnt; }
			ret = it.does;
		}
		return ret;
	}

	it empty_should_be_true_for_a_new_list() {
		before_empty();
		it ret = it.does;
		try {
			auto queue = new PriorityQueue!(int);
			if(!(queue.empty())) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Element Not Found in SomeClass") { ret = it.doesnt; }
			ret = it.does;
		}
		return ret;
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

		Test test = new Test("PriorityQueue", "specs/utils/heap.d");

		it result;

		test.logSubset("creation");

		tester = new PriorityQueueTester();

		result = tester.creation_should_work_as_expected();
		test.logResult(result, "creation should work as expected", "9");

		test.logSubset("add");

		tester = new PriorityQueueTester();

		result = tester.add_should_add_an_item_to_an_empty_list();
		test.logResult(result, "add should add an item to an empty list", "17");

		test.logSubset("peek");

		tester = new PriorityQueueTester();

		result = tester.peek_should_return_the_first_item_in_min_heap();
		test.logResult(result, "peek should return the first item in min heap", "27");

		tester = new PriorityQueueTester();

		result = tester.peek_should_return_the_first_item_in_max_heap();
		test.logResult(result, "peek should return the first item in max heap", "36");

		tester = new PriorityQueueTester();

		result = tester.peek_should_handle_a_heavy_workload();
		test.logResult(result, "peek should handle a heavy workload", "45");

		test.logSubset("remove");

		tester = new PriorityQueueTester();

		result = tester.remove_should_remove_the_first_item_in_min_heap();
		test.logResult(result, "remove should remove the first item in min heap", "77");

		tester = new PriorityQueueTester();

		result = tester.remove_should_remove_the_first_item_in_max_heap();
		test.logResult(result, "remove should remove the first item in max heap", "86");

		test.logSubset("length");

		tester = new PriorityQueueTester();

		result = tester.length_should_be_zero_for_an_empty_list();
		test.logResult(result, "length should be zero for an empty list", "97");

		test.logSubset("clear");

		tester = new PriorityQueueTester();

		result = tester.clear_should_result_in_an_empty_list();
		test.logResult(result, "clear should result in an empty list", "105");

		test.logSubset("empty");

		tester = new PriorityQueueTester();

		result = tester.empty_should_be_true_when_the_list_is_empty();
		test.logResult(result, "empty should be true when the list is empty", "121");

		tester = new PriorityQueueTester();

		result = tester.empty_should_be_true_for_a_new_list();
		test.logResult(result, "empty should be true for a new list", "129");

		test.finish();
	}
}

import utils.linkedlist;

class LinkedListTester {

	it creation_should_work_as_expected() {
		before_creation();
		it ret = it.does;
		try {
			LinkedList!(int) list = new LinkedList!(int)();
			if(list is null) {
				ret = it.doesnt;
			}
			if(!(list.length == 0)) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Element Not Found in SomeClass") { ret = it.doesnt; }
			ret = it.does;
		}
		return ret;
	}

	done before_creation() {
	}

	it add_should_add_item_to_the_head() {
		before_add();
		it ret = it.does;
		try {
			LinkedList!(int) list = new LinkedList!(int)();
			int item = 42;
			list.add(item);
			if(!(list.length == 1)) {
				ret = it.doesnt;
			}
			if(!(list.peek() == item)) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Element Not Found in SomeClass") { ret = it.doesnt; }
			ret = it.does;
		}
		return ret;
	}

	it add_should_an_a_list_to_list() {
		before_add();
		it ret = it.does;
		try {
			LinkedList!(int) list1 = new LinkedList!(int)();
			LinkedList!(int) list2 = new LinkedList!(int)();
			int item = 33;
			list2.add(item);
			list1.add(list2);
			if(!(list1.length == 1)) {
				ret = it.doesnt;
			}
			if(!(list1.peek() == item)) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Element Not Found in SomeClass") { ret = it.doesnt; }
			ret = it.does;
		}
		return ret;
	}

	it add_should_add_an_array_to_list() {
		before_add();
		it ret = it.does;
		try {
			int[3] arr = 1;
			LinkedList!(int) list = new LinkedList!(int)();
			list.add(arr);
			if(!(list.length == 3)) {
				ret = it.doesnt;
			}
			if(!(list.peek() == arr[2])) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Element Not Found in SomeClass") { ret = it.doesnt; }
			ret = it.does;
		}
		return ret;
	}

	done before_add() {
	}

	it peek_should_return_the_head() {
		before_peek();
		it ret = it.does;
		try {
			LinkedList!(int) list = new LinkedList!(int)();
			int item1 = 1;
			int item2 = 2;
			int item3 = 3;
			list.add(item1);
			list.add(item2);
			list.add(item3);
			if(!(list.peek() == item3)) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Element Not Found in SomeClass") { ret = it.doesnt; }
			ret = it.does;
		}
		return ret;
	}

	it peek_should_return_the_item_at_index() {
		before_peek();
		it ret = it.does;
		try {
			LinkedList!(int) list = new LinkedList!(int)();
			int item1 = 1;
			int item2 = 2;
			int item3 = 3;
			list.add(item1);
			list.add(item2);
			list.add(item3);
			if(!(list.peekAt(0) == item3)) {
				ret = it.doesnt;
			}
			if(!(list.peekAt(1) == item2)) {
				ret = it.doesnt;
			}
			if(!(list.peekAt(2) == item1)) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Element Not Found in SomeClass") { ret = it.doesnt; }
			ret = it.does;
		}
		return ret;
	}

	done before_peek() {
	}

	it remove_should_remove_the_tail() {
		before_remove();
		it ret = it.does;
		try {
			LinkedList!(int) list = new LinkedList!(int)();
			int item = 1;
			list.add(item);
			if(!(list.remove() == item)) {
				ret = it.doesnt;
			}
			if(!(list.length == 0)) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Element Not Found in SomeClass") { ret = it.doesnt; }
			ret = it.does;
		}
		return ret;
	}

	it remove_should_remove_by_data() {
		before_remove();
		it ret = it.does;
		try {
			LinkedList!(int) list = new LinkedList!(int)();
			int item = 1;
			list.add(item);
			if(!(list.remove(item) == item)) {
				ret = it.doesnt;
			}
			if(!(list.length == 0)) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Element Not Found in SomeClass") { ret = it.doesnt; }
			ret = it.does;
		}
		return ret;
	}

	it remove_should_remove_at_index() {
		before_remove();
		it ret = it.does;
		try {
			LinkedList!(int) list = new LinkedList!(int)();
			int item1 = 1;
			int item2 = 2;
			int item3 = 3;
			list.add(item1);
			list.add(item2);
			list.add(item3);
			if(!(list.removeAt(2) == item1)) {
				ret = it.doesnt;
			}
			if(!(list.length == 2)) {
				ret = it.doesnt;
			}
			if(!(list.removeAt(1) == item2)) {
				ret = it.doesnt;
			}
			if(!(list.length == 1)) {
				ret = it.doesnt;
			}
			if(!(list.removeAt(0) == item3)) {
				ret = it.doesnt;
			}
			if(!(list.length == 0)) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Element Not Found in SomeClass") { ret = it.doesnt; }
			ret = it.does;
		}
		return ret;
	}

	done before_remove() {
	}

	it clear_should_work_as_expected() {
		before_clear();
		it ret = it.does;
		try {
			LinkedList!(int) list = new LinkedList!(int)();
			list.add(1);
			list.add(2);
			list.add(3);
			list.clear();
			if(!(list.length == 0)) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Element Not Found in SomeClass") { ret = it.doesnt; }
			ret = it.does;
		}
		return ret;
	}

	done before_clear() {
	}

	it empty_should_work_as_expected() {
		before_empty();
		it ret = it.does;
		try {
			LinkedList!(int) list = new LinkedList!(int)();
			if(!(list.empty())) {
				ret = it.doesnt;
			}
			list.add(1);
			if(list.empty()) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Element Not Found in SomeClass") { ret = it.doesnt; }
			ret = it.does;
		}
		return ret;
	}

	done before_empty() {
	}

	it operations_should_peek_at_the_index() {
		before_operations();
		it ret = it.does;
		try {
			LinkedList!(int) list = new LinkedList!(int)();
			int entry = 1;
			list.add(entry);
			if(!(list[0] == entry)) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Element Not Found in SomeClass") { ret = it.doesnt; }
			ret = it.does;
		}
		return ret;
	}

	done before_operations() {
	}

	it array_should_return_an_array_of_the_list() {
		before_array();
		it ret = it.does;
		try {
			LinkedList!(int) list = new LinkedList!(int)();
			int entry1 = 1;
			int entry2 = 2;
			int entry3 = 3;
			list.add(entry1);
			list.add(entry2);
			list.add(entry3);
			int[] listArr = list.array();
			if(listArr is null) {
				ret = it.doesnt;
			}
			if(!(listArr[0] == entry1)) {
				ret = it.doesnt;
			}
			if(!(listArr[1] == entry2)) {
				ret = it.doesnt;
			}
			if(!(listArr[2] == entry3)) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Element Not Found in SomeClass") { ret = it.doesnt; }
			ret = it.does;
		}
		return ret;
	}

	done before_array() {
	}

	it duplication_should_work_as_expected() {
		before_duplication();
		it ret = it.does;
		try {
			LinkedList!(int) list = new LinkedList!(int)();
			int entry = 1;
			list.add(entry);
			LinkedList!(int) dupList = list.dup();
			if(dupList is null) {
				ret = it.doesnt;
			}
			if(!(dupList.peek() == entry)) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Element Not Found in SomeClass") { ret = it.doesnt; }
			ret = it.does;
		}
		return ret;
	}

	done before_duplication() {
	}

	it slicing_should_work_as_expected() {
		before_slicing();
		it ret = it.does;
		try {
			LinkedList!(int) list = new LinkedList!(int)();
			int entry1 = 1;
			int entry2 = 2;
			int entry3 = 3;
			list.add(entry3);
			list.add(entry2);
			list.add(entry1);
			LinkedList!(int) sliceList = list.slice(0,2);
			if(sliceList is null) {
				ret = it.doesnt;
			}
			if(!(sliceList.length == 2)) {
				ret = it.doesnt;
			}
			if(!(sliceList.remove() == entry3)) {
				ret = it.doesnt;
			}
			if(!(sliceList.remove() == entry2)) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Element Not Found in SomeClass") { ret = it.doesnt; }
			ret = it.does;
		}
		return ret;
	}

	done before_slicing() {
	}

	it reverse_should_work_as_expected() {
		before_reverse();
		it ret = it.does;
		try {
			LinkedList!(int) list = new LinkedList!(int)();
			int entry1 = 1;
			int entry2 = 2;
			int entry3 = 3;
			list.add(entry1);
			list.add(entry2);
			list.add(entry3);
			LinkedList!(int) revList = list.reverse();
			if(revList is null) {
				ret = it.doesnt;
			}
			if(!(revList.length == 3)) {
				ret = it.doesnt;
			}
			if(!(revList.remove() == entry1)) {
				ret = it.doesnt;
			}
			if(!(revList.remove() == entry2)) {
				ret = it.doesnt;
			}
			if(!(revList.remove() == entry3)) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Element Not Found in SomeClass") { ret = it.doesnt; }
			ret = it.does;
		}
		return ret;
	}

	done before_reverse() {
	}

	it string_should_work_as_expected() {
		before_string();
		it ret = it.does;
		try {
			LinkedList!(int) list = new LinkedList!(int)();
			list.add(1);
			list.add(2);
			list.add(3);
			if(!(list.toString() == "[1, 2, 3]")) {
				ret = it.doesnt;
			}
		}
		catch(Exception _exception_) {
			if (_exception_.msg != "Element Not Found in SomeClass") { ret = it.doesnt; }
			ret = it.does;
		}
		return ret;
	}

	done before_string() {
	}

	done before() {
	}

	this() {
		before();
	}

	static void test() {
		LinkedListTester tester = new LinkedListTester();

		Test test = new Test("LinkedList", "specs/utils/linkedlist.d");

		it result;

		test.logSubset("creation");

		tester = new LinkedListTester();

		result = tester.creation_should_work_as_expected();
		test.logResult(result, "creation should work as expected", "7");

		test.logSubset("add");

		tester = new LinkedListTester();

		result = tester.add_should_add_item_to_the_head();
		test.logResult(result, "add should add item to the head", "15");

		tester = new LinkedListTester();

		result = tester.add_should_an_a_list_to_list();
		test.logResult(result, "add should an a list to list", "24");

		tester = new LinkedListTester();

		result = tester.add_should_add_an_array_to_list();
		test.logResult(result, "add should add an array to list", "37");

		test.logSubset("peek");

		tester = new LinkedListTester();

		result = tester.peek_should_return_the_head();
		test.logResult(result, "peek should return the head", "49");

		tester = new LinkedListTester();

		result = tester.peek_should_return_the_item_at_index();
		test.logResult(result, "peek should return the item at index", "63");

		test.logSubset("remove");

		tester = new LinkedListTester();

		result = tester.remove_should_remove_the_tail();
		test.logResult(result, "remove should remove the tail", "81");

		tester = new LinkedListTester();

		result = tester.remove_should_remove_by_data();
		test.logResult(result, "remove should remove by data", "90");

		tester = new LinkedListTester();

		result = tester.remove_should_remove_at_index();
		test.logResult(result, "remove should remove at index", "99");

		test.logSubset("clear");

		tester = new LinkedListTester();

		result = tester.clear_should_work_as_expected();
		test.logResult(result, "clear should work as expected", "120");

		test.logSubset("empty");

		tester = new LinkedListTester();

		result = tester.empty_should_work_as_expected();
		test.logResult(result, "empty should work as expected", "134");

		test.logSubset("operations");

		tester = new LinkedListTester();

		result = tester.operations_should_peek_at_the_index();
		test.logResult(result, "operations should peek at the index", "147");

		test.logSubset("array");

		tester = new LinkedListTester();

		result = tester.array_should_return_an_array_of_the_list();
		test.logResult(result, "array should return an array of the list", "157");

		test.logSubset("duplication");

		tester = new LinkedListTester();

		result = tester.duplication_should_work_as_expected();
		test.logResult(result, "duplication should work as expected", "178");

		test.logSubset("slicing");

		tester = new LinkedListTester();

		result = tester.slicing_should_work_as_expected();
		test.logResult(result, "slicing should work as expected", "192");

		test.logSubset("reverse");

		tester = new LinkedListTester();

		result = tester.reverse_should_work_as_expected();
		test.logResult(result, "reverse should work as expected", "213");

		test.logSubset("string");

		tester = new LinkedListTester();

		result = tester.string_should_work_as_expected();
		test.logResult(result, "string should work as expected", "235");

		test.finish();
	}
}


class Tests {
	static void testDate() {
		DateTester.test();
	}

	static void testString() {
		StringTester.test();
	}

	static void testArguments() {
		ArgumentsTester.test();
	}

	static void testVariant() {
		VariantTester.test();
	}

	static void testRegex() {
		RegexTester.test();
	}

	static void testUtil() {
		UtilTester.test();
	}

	static void testUnicode() {
		UnicodeTester.test();
	}

	static void testRandom() {
		RandomTester.test();
	}

	static void testApplication() {
		ApplicationTester.test();
	}

	static void testTime() {
		TimeTester.test();
	}

	static void testException() {
		ExceptionTester.test();
	}

	static void testMD5() {
		MD5Tester.test();
	}

	static void testSHA256() {
		SHA256Tester.test();
	}

	static void testSHA224() {
		SHA224Tester.test();
	}

	static void testDigest() {
		DigestTester.test();
	}

	static void testSHA1() {
		SHA1Tester.test();
	}

	static void testFibonacciHeap() {
		FibonacciHeapTester.test();
	}

	static void testStack() {
		StackTester.test();
	}

	static void testPriorityQueue() {
		PriorityQueueTester.test();
	}

	static void testLinkedList() {
		LinkedListTester.test();
	}

	static uint testAll() {
		testDate();
		testString();
		testArguments();
		testVariant();
		testRegex();
		testUtil();
		testUnicode();
		testRandom();
		testApplication();
		testTime();
		testException();
		testMD5();
		testSHA256();
		testSHA224();
		testDigest();
		testSHA1();
		testFibonacciHeap();
		testStack();
		testPriorityQueue();
		testLinkedList();
		Test.done();
		return Test.getFailureCount();
	}
}

