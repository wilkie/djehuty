
/*
 * test.d
 *
 * Tests the specifications defined and parsed by dspec
 *
 */

module specs.test;

import testing.logic;

import core.application;

class ApplicationTester
{
	
		 it creation_should_not_create_inside_another_application()
	{before_creation();
try
{
			class MyApplication : Application }catch(Exception _exception_)
{
return it.doesnt;
}
	return it.does;
	}			shouldThrow();
			MyApplication app = new MyApplication();
		 done before_creation() { }
	done before() { }

this() { before(); }


	static void test()
	{
	ApplicationTester tester = new ApplicationTester();

	Test test = new Test("Application");

	it result;

	test.logSubset("creation");

	tester = new ApplicationTester();

	result = tester.creation_should_not_create_inside_another_application();
		test.logResult(result, "creation should not create inside another application", "8");


	}
}class NameTester
{
		it should_get_the_name()
	{before();
try
{
			if(!(Djehuty.application().name() == "DjehutyTester"))
	{
		return it.doesnt;
	}

		}catch(Exception _exception_)
{
return it.doesnt;
}
	return it.does;
	}	done before() { }

this() { before(); }


	static void test()
	{
	NameTester tester = new NameTester();

	Test test = new Test("Name");

	it result;

	tester = new NameTester();

	result = tester._should_get_the_name();
		test.logResult(result, " should get the name", "8");


	}
}import core.date;

class DateTester
{
	
		it creation_should_create_with_current_date()
	{before_creation();
try
{
			Date d = new Date();
			if(d is null)
{ return it.doesnt; }

			if(!(d.year == 2010))
	{
		return it.doesnt;
	}

		}catch(Exception _exception_)
{
return it.doesnt;
}
	return it.does;
	}		it creation_should_create_given_date()
	{before_creation();
try
{
			Date d = new Date(Month.January, 1, 2010);
			if(d is null)
{ return it.doesnt; }

			if(!(d.month() == Month.January))
	{
		return it.doesnt;
	}

			if(!(d.year() == 2010))
	{
		return it.doesnt;
	}

			if(!(d.day() == 1))
	{
		return it.doesnt;
	}

		}catch(Exception _exception_)
{
return it.doesnt;
}
	return it.does;
	}	done before_creation() { }
	
	
		it dayOfWeek_should_return_the_day_of_the_week()
	{before_dayOfWeek();
try
{
			Date d = new Date(Month.January, 1, 2010);
			if(!(d.dayOfWeek() == Day.Friday))
	{
		return it.doesnt;
	}

		}catch(Exception _exception_)
{
return it.doesnt;
}
	return it.does;
	}	done before_dayOfWeek() { }

	
		it monthMethods_should_return_the_month_value()
	{before_monthMethods();
try
{
			Date d = new Date(Month.January, 1, 2010);
			if(!(d.month() == Month.January))
	{
		return it.doesnt;
	}

		}catch(Exception _exception_)
{
return it.doesnt;
}
	return it.does;
	}
		it monthMethods_should_set_the_month_value()
	{before_monthMethods();
try
{
			Date d = new Date(Month.January, 1, 2010);
			d.month(Month.March);
			if(!(d.month() == Month.March))
	{
		return it.doesnt;
	}

		}catch(Exception _exception_)
{
return it.doesnt;
}
	return it.does;
	}	done before_monthMethods() { }

	
		it dayMethods_should_return_the_day_value()
	{before_dayMethods();
try
{
			Date d = new Date(Month.January, 1, 2010);
			if(!(d.day() == 1))
	{
		return it.doesnt;
	}

		}catch(Exception _exception_)
{
return it.doesnt;
}
	return it.does;
	}
		it dayMethods_should_set_the_day_value()
	{before_dayMethods();
try
{
			Date d = new Date(Month.January, 1, 2010);
			d.day(21);
			if(!(d.day() == 21))
	{
		return it.doesnt;
	}

		}catch(Exception _exception_)
{
return it.doesnt;
}
	return it.does;
	}	done before_dayMethods() { }
	
	
		it yearMethods_should_return_the_year_value()
	{before_yearMethods();
try
{
			Date d = new Date(Month.January, 1, 2010);
			if(!(d.year() == 2010))
	{
		return it.doesnt;
	}

		}catch(Exception _exception_)
{
return it.doesnt;
}
	return it.does;
	}
		it yearMethods_should_set_the_year_value()
	{before_yearMethods();
try
{
			Date d = new Date(Month.January, 1, 2010);
			d.year(2011);
			if(!(d.year() == 2011))
	{
		return it.doesnt;
	}

		}catch(Exception _exception_)
{
return it.doesnt;
}
	return it.does;
	}	done before_yearMethods() { }

done before() { }

this() { before(); }


	static void test()
	{
	DateTester tester = new DateTester();

	Test test = new Test("Date");

	it result;

	test.logSubset("creation");

	tester = new DateTester();

	result = tester.creation_should_create_with_current_date();
		test.logResult(result, "creation should create with current date", "8");

	tester = new DateTester();

	result = tester.creation_should_create_given_date();
		test.logResult(result, "creation should create given date", "16");

	test.logSubset("dayOfWeek");

	tester = new DateTester();

	result = tester.dayOfWeek_should_return_the_day_of_the_week();
		test.logResult(result, "dayOfWeek should return the day of the week", "7");

	test.logSubset("monthMethods");

	tester = new DateTester();

	result = tester.monthMethods_should_return_the_month_value();
		test.logResult(result, "monthMethods should return the month value", "12");

	tester = new DateTester();

	result = tester.monthMethods_should_set_the_month_value();
		test.logResult(result, "monthMethods should set the month value", "22");

	test.logSubset("dayMethods");

	tester = new DateTester();

	result = tester.dayMethods_should_return_the_day_value();
		test.logResult(result, "dayMethods should return the day value", "29");

	tester = new DateTester();

	result = tester.dayMethods_should_set_the_day_value();
		test.logResult(result, "dayMethods should set the day value", "34");

	test.logSubset("yearMethods");

	tester = new DateTester();

	result = tester.yearMethods_should_return_the_year_value();
		test.logResult(result, "yearMethods should return the year value", "42");

	tester = new DateTester();

	result = tester.yearMethods_should_set_the_year_value();
		test.logResult(result, "yearMethods should set the year value", "47");


	}
}import core.exception;

class ExceptionTester
{
	
		it FileNotFound_should_work_with_no_explanation()
	{before_FileNotFound();
try
{
			
			throw new FileNotFound();
		}catch(Exception _exception_)
{
if (_exception_.msg != "File Not Found") { return it.doesnt; } return it.does;
}
	return it.does;
	}
		it FileNotFound_should_work_with_string_object()
	{before_FileNotFound();
try
{
			
			throw new FileNotFound(new String("some_file"));
		}catch(Exception _exception_)
{
if (_exception_.msg != "File Not Found: some_file") { return it.doesnt; } return it.does;
}
	return it.does;
	}
		it FileNotFound_should_work_with_plain_string()
	{before_FileNotFound();
try
{
			
			throw new FileNotFound("some_file");
		}catch(Exception _exception_)
{
if (_exception_.msg != "File Not Found: some_file") { return it.doesnt; } return it.does;
}
	return it.does;
	}	done before_FileNotFound() { }

	
		it DirectoryNotFound_should_work_with_no_explanation()
	{before_DirectoryNotFound();
try
{
			
			throw new DirectoryNotFound();
		}catch(Exception _exception_)
{
if (_exception_.msg != "Directory Not Found") { return it.doesnt; } return it.does;
}
	return it.does;
	}
		it DirectoryNotFound_should_work_with_string_object()
	{before_DirectoryNotFound();
try
{
			
			throw new DirectoryNotFound(new String("some_dir"));
		}catch(Exception _exception_)
{
if (_exception_.msg != "Directory Not Found: some_dir") { return it.doesnt; } return it.does;
}
	return it.does;
	}
		it DirectoryNotFound_should_work_with_plain_string()
	{before_DirectoryNotFound();
try
{
			
			throw new DirectoryNotFound("some_dir");
		}catch(Exception _exception_)
{
if (_exception_.msg != "Directory Not Found: some_dir") { return it.doesnt; } return it.does;
}
	return it.does;
	}	done before_DirectoryNotFound() { }

	
		it OutOfElements_should_work_with_no_explanation()
	{before_OutOfElements();
try
{
			
			throw new OutOfElements();
		}catch(Exception _exception_)
{
if (_exception_.msg != "Out of Elements") { return it.doesnt; } return it.does;
}
	return it.does;
	}
		it OutOfElements_should_work_with_string_object()
	{before_OutOfElements();
try
{
			
			throw new OutOfElements(new String("SomeClass"));
		}catch(Exception _exception_)
{
if (_exception_.msg != "Out of Elements in SomeClass") { return it.doesnt; } return it.does;
}
	return it.does;
	}
		it OutOfElements_should_work_with_plain_string()
	{before_OutOfElements();
try
{
			
			throw new OutOfElements("SomeClass");
		}catch(Exception _exception_)
{
if (_exception_.msg != "Out of Elements in SomeClass") { return it.doesnt; } return it.does;
}
	return it.does;
	}	done before_OutOfElements() { }

	
		it OutOfBounds_should_work_with_no_explanation()
	{before_OutOfBounds();
try
{
			
			throw new OutOfBounds();
		}catch(Exception _exception_)
{
if (_exception_.msg != "Out of Bounds") { return it.doesnt; } return it.does;
}
	return it.does;
	}
		it OutOfBounds_should_work_with_string_object()
	{before_OutOfBounds();
try
{
			
			throw new OutOfBounds(new String("SomeClass"));
		}catch(Exception _exception_)
{
if (_exception_.msg != "Out of Bounds in SomeClass") { return it.doesnt; } return it.does;
}
	return it.does;
	}
		it OutOfBounds_should_work_with_plain_string()
	{before_OutOfBounds();
try
{
			
			throw new OutOfBounds("SomeClass");
		}catch(Exception _exception_)
{
if (_exception_.msg != "Out of Bounds in SomeClass") { return it.doesnt; } return it.does;
}
	return it.does;
	}	done before_OutOfBounds() { }

	
		it ElementNotFound_should_work_with_no_explanation()
	{before_ElementNotFound();
try
{
			
			throw new ElementNotFound();
		}catch(Exception _exception_)
{
if (_exception_.msg != "Element Not Found") { return it.doesnt; } return it.does;
}
	return it.does;
	}
		it ElementNotFound_should_work_with_string_object()
	{before_ElementNotFound();
try
{
			
			throw new ElementNotFound(new String("SomeClass"));
		}catch(Exception _exception_)
{
if (_exception_.msg != "Element Not Found in SomeClass") { return it.doesnt; } return it.does;
}
	return it.does;
	}
		it ElementNotFound_should_work_with_plain_string()
	{before_ElementNotFound();
try
{
			
			throw new ElementNotFound("SomeClass");
		}catch(Exception _exception_)
{
if (_exception_.msg != "Element Not Found in SomeClass") { return it.doesnt; } return it.does;
}
	return it.does;
	}	done before_ElementNotFound() { }

done before() { }

this() { before(); }


	static void test()
	{
	ExceptionTester tester = new ExceptionTester();

	Test test = new Test("Exception");

	it result;

	test.logSubset("FileNotFound");

	tester = new ExceptionTester();

	result = tester.FileNotFound_should_work_with_no_explanation();
		test.logResult(result, "FileNotFound should work with no explanation", "8");

	tester = new ExceptionTester();

	result = tester.FileNotFound_should_work_with_string_object();
		test.logResult(result, "FileNotFound should work with string object", "16");

	tester = new ExceptionTester();

	result = tester.FileNotFound_should_work_with_plain_string();
		test.logResult(result, "FileNotFound should work with plain string", "7");

	test.logSubset("DirectoryNotFound");

	tester = new ExceptionTester();

	result = tester.DirectoryNotFound_should_work_with_no_explanation();
		test.logResult(result, "DirectoryNotFound should work with no explanation", "12");

	tester = new ExceptionTester();

	result = tester.DirectoryNotFound_should_work_with_string_object();
		test.logResult(result, "DirectoryNotFound should work with string object", "22");

	tester = new ExceptionTester();

	result = tester.DirectoryNotFound_should_work_with_plain_string();
		test.logResult(result, "DirectoryNotFound should work with plain string", "29");

	test.logSubset("OutOfElements");

	tester = new ExceptionTester();

	result = tester.OutOfElements_should_work_with_no_explanation();
		test.logResult(result, "OutOfElements should work with no explanation", "34");

	tester = new ExceptionTester();

	result = tester.OutOfElements_should_work_with_string_object();
		test.logResult(result, "OutOfElements should work with string object", "42");

	tester = new ExceptionTester();

	result = tester.OutOfElements_should_work_with_plain_string();
		test.logResult(result, "OutOfElements should work with plain string", "47");

	test.logSubset("OutOfBounds");

	tester = new ExceptionTester();

	result = tester.OutOfBounds_should_work_with_no_explanation();
		test.logResult(result, "OutOfBounds should work with no explanation", "55");

	tester = new ExceptionTester();

	result = tester.OutOfBounds_should_work_with_string_object();
		test.logResult(result, "OutOfBounds should work with string object", "60");

	tester = new ExceptionTester();

	result = tester.OutOfBounds_should_work_with_plain_string();
		test.logResult(result, "OutOfBounds should work with plain string", "9");

	test.logSubset("ElementNotFound");

	tester = new ExceptionTester();

	result = tester.ElementNotFound_should_work_with_no_explanation();
		test.logResult(result, "ElementNotFound should work with no explanation", "14");

	tester = new ExceptionTester();

	result = tester.ElementNotFound_should_work_with_string_object();
		test.logResult(result, "ElementNotFound should work with string object", "19");

	tester = new ExceptionTester();

	result = tester.ElementNotFound_should_work_with_plain_string();
		test.logResult(result, "ElementNotFound should work with plain string", "26");


	}
}import core.random;

class RandomTester
{
	const uint SEED = 12345678;
	const uint REPEATS = 10000000;

	
		it creation_should_have_sane_defaults()
	{before_creation();
try
{
			auto r = new Random();
			if(!(r.seed >= 0))
	{
		return it.doesnt;
	}

		}catch(Exception _exception_)
{
if (_exception_.msg != "Element Not Found in SomeClass") { return it.doesnt; } return it.does;
}
	return it.does;
	}
		it creation_should_not_reuse_a_seed()
	{before_creation();
try
{
			auto a = new Random();
			auto b = new Random();
			if(a.seed == b.seed)
{ return it.doesnt; }

		}catch(Exception _exception_)
{
if (_exception_.msg != "Element Not Found in SomeClass") { return it.doesnt; } return it.does;
}
	return it.does;
	}
		it creation_should_use_the_given_seed()
	{before_creation();
try
{
			auto r = new Random(SEED);
			if(!(r.seed == SEED))
	{
		return it.doesnt;
	}

		}catch(Exception _exception_)
{
if (_exception_.msg != "Element Not Found in SomeClass") { return it.doesnt; } return it.does;
}
	return it.does;
	}	done before_creation() { }

	
		it state_should_be_reproducible()
	{before_state();
try
{
			auto a = new Random(SEED);
			auto b = new Random(SEED);
			if(!(a.next() == b.next()))
	{
		return it.doesnt;
	}

		}catch(Exception _exception_)
{
if (_exception_.msg != "Element Not Found in SomeClass") { return it.doesnt; } return it.does;
}
	return it.does;
	}	done before_state() { }

	
		it seed_should_set_and_get_the_seed()
	{before_seed();
try
{
			auto r = new Random();
			r.seed = SEED;
			if(!(r.seed == SEED))
	{
		return it.doesnt;
	}

		}catch(Exception _exception_)
{
if (_exception_.msg != "Element Not Found in SomeClass") { return it.doesnt; } return it.does;
}
	return it.does;
	}	done before_seed() { }

	// TODO: Statistical tests should be implemented for all the "next" methods.

	
		it next_should_not_be_stuck()
	{before_next();
try
{
			auto r = new Random();
			if(r.next() == r.next())
{ return it.doesnt; }

		}catch(Exception _exception_)
{
if (_exception_.msg != "Element Not Found in SomeClass") { return it.doesnt; } return it.does;
}
	return it.does;
	}
		it next_should_return_zero_if_upper_bound_is_zero()
	{before_next();
try
{
			auto r = new Random();
			if(!(r.next(0) == 0))
	{
		return it.doesnt;
	}

		}catch(Exception _exception_)
{
if (_exception_.msg != "Element Not Found in SomeClass") { return it.doesnt; } return it.does;
}
	return it.does;
	}
		it next_should_return_a_nonnegative_value_less_than_upper_bound()
	{before_next();
try
{
			auto r = new Random();
			uint v;
			uint upper = 1;
			for (uint i = 0; i < REPEATS; i++) 
				v = r.next(upper);
				if(!(v >= 0))
	{
		return it.doesnt;
	}

				if(!(v < upper))
	{
		return it.doesnt;
	}

				upper += i;
			}catch(Exception _exception_)
{
if (_exception_.msg != "Element Not Found in SomeClass") { return it.doesnt; } return it.does;
}
	return it.does;
	}		done before_next() { }

		it should_return_greatest_bound_if_bounds_overlap()
	{before();
try
{
			auto r = new Random();
			if(!(r.next(0, 0) == 0))
	{
		return it.doesnt;
	}

			if(!(r.next(123, 123) == 123))
	{
		return it.doesnt;
	}

			if(!(r.next(-123, -123) == -123))
	{
		return it.doesnt;
	}

			if(!(r.next(123, -123) == 123))
	{
		return it.doesnt;
	}

		}catch(Exception _exception_)
{
if (_exception_.msg != "Element Not Found in SomeClass") { return it.doesnt; } return it.does;
}
	return it.does;
	}
		it should_return_a_value_within_bounds()
	{before();
try
{
			auto r = new Random();
			int v;
			int lower = 0;
			int upper = 1;
			for (uint i = 0; i < REPEATS; i++) 
				v = r.next(lower, upper);
				if(!(v >= lower))
	{
		return it.doesnt;
	}

				if(!(v < upper))
	{
		return it.doesnt;
	}

				lower -= 12;
				upper += 3;
			}catch(Exception _exception_)
{
if (_exception_.msg != "Element Not Found in SomeClass") { return it.doesnt; } return it.does;
}
	return it.does;
	}		done before() { }

this() { before(); }


	static void test()
	{
	RandomTester tester = new RandomTester();

	Test test = new Test("Random");

	it result;

	test.logSubset("creation");

	tester = new RandomTester();

	result = tester.creation_should_have_sane_defaults();
		test.logResult(result, "creation should have sane defaults", "8");

	tester = new RandomTester();

	result = tester.creation_should_not_reuse_a_seed();
		test.logResult(result, "creation should not reuse a seed", "16");

	tester = new RandomTester();

	result = tester.creation_should_use_the_given_seed();
		test.logResult(result, "creation should use the given seed", "7");

	test.logSubset("state");

	tester = new RandomTester();

	result = tester.state_should_be_reproducible();
		test.logResult(result, "state should be reproducible", "12");

	test.logSubset("seed");

	tester = new RandomTester();

	result = tester.seed_should_set_and_get_the_seed();
		test.logResult(result, "seed should set and get the seed", "22");

	test.logSubset("next");

	tester = new RandomTester();

	result = tester.next_should_not_be_stuck();
		test.logResult(result, "next should not be stuck", "29");

	tester = new RandomTester();

	result = tester.next_should_return_zero_if_upper_bound_is_zero();
		test.logResult(result, "next should return zero if upper bound is zero", "34");

	tester = new RandomTester();

	result = tester.next_should_return_a_nonnegative_value_less_than_upper_bound();
		test.logResult(result, "next should return a nonnegative value less than upper bound", "42");

	test.logSubset("");

	tester = new RandomTester();

	result = tester._should_return_greatest_bound_if_bounds_overlap();
		test.logResult(result, " should return greatest bound if bounds overlap", "47");

	tester = new RandomTester();

	result = tester._should_return_a_value_within_bounds();
		test.logResult(result, " should return a value within bounds", "55");


	}
}class NextLongTester
{
		it should_not_be_stuck()
	{before();
try
{
			auto r = new Random();
			if(r.nextLong() == r.nextLong())
{ return it.doesnt; }

		}catch(Exception _exception_)
{
if (_exception_.msg != "Element Not Found in SomeClass") { return it.doesnt; } return it.does;
}
	return it.does;
	}
		it should_return_zero_if_upper_bound_is_zero()
	{before();
try
{
			auto r = new Random();
			if(!(r.nextLong(0) == 0))
	{
		return it.doesnt;
	}

		}catch(Exception _exception_)
{
if (_exception_.msg != "Element Not Found in SomeClass") { return it.doesnt; } return it.does;
}
	return it.does;
	}
		it should_return_a_nonnegative_value_less_than_upper_bound()
	{before();
try
{
			auto r = new Random();
			ulong v;
			ulong upper = 1;
			for (uint i = 0; i < REPEATS; i++) 
				v = r.nextLong(upper);
				if(!(v >= 0))
	{
		return it.doesnt;
	}

				if(!(v < upper))
	{
		return it.doesnt;
	}

				upper += i;
			}catch(Exception _exception_)
{
if (_exception_.msg != "Element Not Found in SomeClass") { return it.doesnt; } return it.does;
}
	return it.does;
	}		done before() { }

this() { before(); }


	static void test()
	{
	NextLongTester tester = new NextLongTester();

	Test test = new Test("NextLong");

	it result;

	tester = new NextLongTester();

	result = tester._should_not_be_stuck();
		test.logResult(result, " should not be stuck", "8");

	tester = new NextLongTester();

	result = tester._should_return_zero_if_upper_bound_is_zero();
		test.logResult(result, " should return zero if upper bound is zero", "16");

	tester = new NextLongTester();

	result = tester._should_return_a_nonnegative_value_less_than_upper_bound();
		test.logResult(result, " should return a nonnegative value less than upper bound", "7");


	}
}class NextBooleanTester
{
		it should_return_a_boolean()
	{before();
try
{
			auto r = new Random();
			bool to_be = r.nextBoolean();
			if(!(to_be || !to_be))
	{
		return it.doesnt;
	}

		}catch(Exception _exception_)
{
if (_exception_.msg != "Element Not Found in SomeClass") { return it.doesnt; } return it.does;
}
	return it.does;
	}	done before() { }

this() { before(); }


	static void test()
	{
	NextBooleanTester tester = new NextBooleanTester();

	Test test = new Test("NextBoolean");

	it result;

	tester = new NextBooleanTester();

	result = tester._should_return_a_boolean();
		test.logResult(result, " should return a boolean", "8");


	}
}class NextDoubleTester
{
		it should_return_a_value_between_0_and_1()
	{before();
try
{
			auto r = new Random();
			double v;
			for (uint i = 0; i < REPEATS; i++) 
				v = r.nextDouble();
				if(!(v >= 0.0))
	{
		return it.doesnt;
	}

				if(!(v <= 1.0))
	{
		return it.doesnt;
	}

			}catch(Exception _exception_)
{
if (_exception_.msg != "Element Not Found in SomeClass") { return it.doesnt; } return it.does;
}
	return it.does;
	}		done before() { }

this() { before(); }


	static void test()
	{
	NextDoubleTester tester = new NextDoubleTester();

	Test test = new Test("NextDouble");

	it result;

	tester = new NextDoubleTester();

	result = tester._should_return_a_value_between_0_and_1();
		test.logResult(result, " should return a value between 0 and 1", "8");


	}
}class NextFloatTester
{
		it should_return_a_value_between_0_and_1()
	{before();
try
{
			auto r = new Random();
			double v;
			for (uint i = 0; i < REPEATS; i++) 
				v = r.nextFloat();
				if(!(v >= 0.0))
	{
		return it.doesnt;
	}

				if(!(v <= 1.0))
	{
		return it.doesnt;
	}

			}catch(Exception _exception_)
{
if (_exception_.msg != "Element Not Found in SomeClass") { return it.doesnt; } return it.does;
}
	return it.does;
	}		done before() { }

this() { before(); }


	static void test()
	{
	NextFloatTester tester = new NextFloatTester();

	Test test = new Test("NextFloat");

	it result;

	tester = new NextFloatTester();

	result = tester._should_return_a_value_between_0_and_1();
		test.logResult(result, " should return a value between 0 and 1", "8");


	}
}class ChooseTester
{
		it should_fail_on_empty_array()
	{before();
try
{
			auto r = new Random();

			
			r.choose(cast(uint[])[]);
		}catch(Exception _exception_)
{
return it.does;
}
	return it.does;
	}
		it should_fail_on_empty_list()
	{before();
try
{
			auto r = new Random();

			
			r.choose(new List!(uint));
		}catch(Exception _exception_)
{
return it.does;
}
	return it.does;
	}
		it should_return_the_item_given_one()
	{before();
try
{
			auto r = new Random();
			uint[] arr = [1234];
			if(!(r.choose(arr) == 1234))
	{
		return it.doesnt;
	}

		}catch(Exception _exception_)
{
return it.does;
}
	return it.does;
	}
		it should_work_for_arrays()
	{before();
try
{
			auto r = new Random();
			uint[] arr = [2, 5, 6, 9, 10, 13];
			uint v;
			for (uint i = 0; i < REPEATS; i++) 
				v = r.choose(arr);
				if(member(v, arr) is null)
{ return it.doesnt; }

			}catch(Exception _exception_)
{
return it.does;
}
	return it.does;
	}		done before() { }

this() { before(); }


	static void test()
	{
	ChooseTester tester = new ChooseTester();

	Test test = new Test("Choose");

	it result;

	tester = new ChooseTester();

	result = tester._should_fail_on_empty_array();
		test.logResult(result, " should fail on empty array", "8");

	tester = new ChooseTester();

	result = tester._should_fail_on_empty_list();
		test.logResult(result, " should fail on empty list", "16");

	tester = new ChooseTester();

	result = tester._should_return_the_item_given_one();
		test.logResult(result, " should return the item given one", "7");

	tester = new ChooseTester();

	result = tester._should_work_for_arrays();
		test.logResult(result, " should work for arrays", "12");


	}
}import core.string;

import core.regex;

class RegexTester
{
	
		it eval_should_handle_kleene_star()
	{before_eval();
try
{
			String str = Regex.eval("<EM>some text</EM>", `<.*>`);
			if(!(str == "<EM>some text</EM>"))
	{
		return it.doesnt;
	}

		}catch(Exception _exception_)
{
return it.does;
}
	return it.does;
	}
		it eval_should_handle_lazy_kleene_star()
	{before_eval();
try
{
			String str = Regex.eval("<EM>some text</EM>", `<.*?>`);
			if(!(str == "<EM>"))
	{
		return it.doesnt;
	}

		}catch(Exception _exception_)
{
return it.does;
}
	return it.does;
	}
		it eval_should_handle_kleene_plus()
	{before_eval();
try
{
			String str = Regex.eval("<>EM>some text</EM>", `<.+>`);
			if(!(str == "<>EM>some text</EM>"))
	{
		return it.doesnt;
	}

		}catch(Exception _exception_)
{
return it.does;
}
	return it.does;
	}
		it eval_should_handle_lazy_kleene_plus()
	{before_eval();
try
{
			String str = Regex.eval("<>EM>some text</EM>", `<.+?>`);
			if(!(str == "<>EM>"))
	{
		return it.doesnt;
	}

		}catch(Exception _exception_)
{
return it.does;
}
	return it.does;
	}
		it eval_should_handle_options()
	{before_eval();
try
{
			String str = Regex.eval("abc", `a?abc`);
			if(!(str == "abc"))
	{
		return it.doesnt;
	}


			str = Regex.eval("aabc", `a?abc`);
			if(!(str == "aabc"))
	{
		return it.doesnt;
	}


			str = Regex.eval("ababbababababbbc", `(a?b)*c`);
			if(!(str == "ababbababababbbc"))
	{
		return it.doesnt;
	}

		}catch(Exception _exception_)
{
return it.does;
}
	return it.does;
	}
		it eval_should_handle_optional_groups()
	{before_eval();
try
{
			String str = Regex.eval("abcdefeggfoo", `abc(egg|foo)?def(egg|foo)?(egg|foo)?`);
			if(!(str == "abcdefeggfoo"))
	{
		return it.doesnt;
	}

		}catch(Exception _exception_)
{
return it.does;
}
	return it.does;
	}
		it eval_should_handle_union_at_base_level()
	{before_eval();
try
{
			String str = Regex.eval("dogbert", `cat|dog`);
			if(!(str == "dog"))
	{
		return it.doesnt;
	}

		}catch(Exception _exception_)
{
return it.does;
}
	return it.does;
	}
		it eval_should_handle_union_at_group_level()
	{before_eval();
try
{
			String str = Regex.eval("bacd", `(bac|b)acd`);
			if(!(str == "bacd"))
	{
		return it.doesnt;
	}

		}catch(Exception _exception_)
{
return it.does;
}
	return it.does;
	}
		it eval_should_handle_union_with_kleene_star()
	{before_eval();
try
{
			String str = Regex.eval("catdogdogcatbert", `(cat|dog)*`);
			if(!(str == "catdogdogcat"))
	{
		return it.doesnt;
	}

		}catch(Exception _exception_)
{
return it.does;
}
	return it.does;
	}
		it eval_should_handle_nested_groups()
	{before_eval();
try
{
			String str = Regex.eval("acatbert", `a(cat(bert))`);
			if(!(str == "acatbert"))
	{
		return it.doesnt;
	}

			if(!(_1 == "catbert"))
	{
		return it.doesnt;
	}

			if(!(_2 == "bert"))
	{
		return it.doesnt;
	}

		}catch(Exception _exception_)
{
return it.does;
}
	return it.does;
	}
		it eval_should_handle_nested_groups_with_union()
	{before_eval();
try
{
			String str = Regex.eval("dogpoo", `(dog(bert|poo))`);
			if(!(str == "dogpoo"))
	{
		return it.doesnt;
	}

		}catch(Exception _exception_)
{
return it.does;
}
	return it.does;
	}
		it eval_should_handle_character_classes()
	{before_eval();
try
{
			String str = Regex.eval("daccabaaccbg", `d[abc]*g`);
			if(!(str == "daccabaaccbg"))
	{
		return it.doesnt;
	}


			str = Regex.eval("daccabadaccbg", `d[abc]*g`);
			if(!(str == "daccbg"))
	{
		return it.doesnt;
	}


			str = Regex.eval("daccabadaccbg", `^d[abc]*g`);
			if(!(str is null))
	{
		return it.doesnt;
	}

		}catch(Exception _exception_)
{
return it.does;
}
	return it.does;
	}
		it eval_should_handle_inverse_character_classes()
	{before_eval();
try
{
			String str = Regex.eval("ddeffegggdefeddfeg", `d[^abc]*g`);
			if(!(str == "ddeffegggdefeddfeg"))
	{
		return it.doesnt;
	}


			str = Regex.eval("ddeffegggdefeddfeg", `d[^abc]*?g`);
			if(!(str == "ddeffeg"))
	{
		return it.doesnt;
	}


			str = Regex.eval("ddeffeagggdefeddfeg", `d[^abc]*?g`);
			if(!(str == "defeddfeg"))
	{
		return it.doesnt;
	}

		}catch(Exception _exception_)
{
return it.does;
}
	return it.does;
	}
		it eval_should_handle_dollar_sign()
	{before_eval();
try
{
			String str = Regex.eval("root woot moot foot", `.oot$`);
			if(!(str == "foot"))
	{
		return it.doesnt;
	}


			str = Regex.eval("root\nwoot\nmoot\nfoot", `.oot$`);
			if(!(str == "root"))
	{
		return it.doesnt;
	}

		}catch(Exception _exception_)
{
return it.does;
}
	return it.does;
	}
		it eval_should_handle_beginning_of_line_caret()
	{before_eval();
try
{
			String str = Regex.eval("root woot moot foot", `^.oot`);
			if(!(str == "root"))
	{
		return it.doesnt;
	}


			str = Regex.eval(" root\nwoot\nmoot\nfoot", `^.oot`, "m");
			if(!(str == "woot"))
	{
		return it.doesnt;
	}

		}catch(Exception _exception_)
{
return it.does;
}
	return it.does;
	}
		it eval_should_handle_group_consumption()
	{before_eval();
try
{
			String str = Regex.eval("dogpoo", `(dog(bert|poo))`);
			if(!(str == "dogpoo"))
	{
		return it.doesnt;
	}


			if(!(_1 == "dogpoo"))
	{
		return it.doesnt;
	}

			if(!(_2 == "poo"))
	{
		return it.doesnt;
	}

		}catch(Exception _exception_)
{
return it.does;
}
	return it.does;
	}
		it eval_should_handle_group_reconsumption()
	{before_eval();
try
{
			String str = Regex.eval("bertpoopoobertpoo", `(bert|poo)+`);
			if(!(str == "bertpoopoobertpoo"))
	{
		return it.doesnt;
	}


			if(!(_1 == "poo"))
	{
		return it.doesnt;
	}

		}catch(Exception _exception_)
{
return it.does;
}
	return it.does;
	}
		it eval_should_handle_backreferences()
	{before_eval();
try
{
			String str = Regex.eval("dogpoo=dogpoo", `(dogpoo)=\1`);
			if(!(str == "dogpoo=dogpoo"))
	{
		return it.doesnt;
	}

			if(!(_1 == "dogpoo"))
	{
		return it.doesnt;
	}

		}catch(Exception _exception_)
{
return it.does;
}
	return it.does;
	}
		it eval_should_handle_forwardreferences()
	{before_eval();
try
{
			String str = Regex.eval("oneonetwo", `(\2two|(one))+`);
			if(!(str == "oneonetwo"))
	{
		return it.doesnt;
	}


			if(!(_1 == "onetwo"))
	{
		return it.doesnt;
	}

			if(!(_2 == "one"))
	{
		return it.doesnt;
	}

		}catch(Exception _exception_)
{
return it.does;
}
	return it.does;
	}
		it eval_should_handle_comments()
	{before_eval();
try
{
			String str = Regex.eval("bleh", `bl(?#comment here)eh`);
			if(!(str == "bleh"))
	{
		return it.doesnt;
	}

		}catch(Exception _exception_)
{
return it.does;
}
	return it.does;
	}
		it eval_should_handle_complicated_constructions()
	{before_eval();
try
{
			String str = Regex.eval(`a#line 43 "foo\bar"`, `#line\s+(0x[0-9a-fA-F_]+|0b[01_]+|0[_0-7]+|(?:[1-9][_0-9]*|0))(?:\s+("[^"]*"))?`);
			if(!(str == `#line 43 "foo\bar"`))
	{
		return it.doesnt;
	}


			if(!(_1 == "43"))
	{
		return it.doesnt;
	}

			if(!(_2 == `"foo\bar"`))
	{
		return it.doesnt;
	}

		}catch(Exception _exception_)
{
return it.does;
}
	return it.does;
	}	done before_eval() { }
done before() { }

this() { before(); }


	static void test()
	{
	RegexTester tester = new RegexTester();

	Test test = new Test("Regex");

	it result;

	test.logSubset("eval");

	tester = new RegexTester();

	result = tester.eval_should_handle_kleene_star();
		test.logResult(result, "eval should handle kleene star", "8");

	tester = new RegexTester();

	result = tester.eval_should_handle_lazy_kleene_star();
		test.logResult(result, "eval should handle lazy kleene star", "16");

	tester = new RegexTester();

	result = tester.eval_should_handle_kleene_plus();
		test.logResult(result, "eval should handle kleene plus", "7");

	tester = new RegexTester();

	result = tester.eval_should_handle_lazy_kleene_plus();
		test.logResult(result, "eval should handle lazy kleene plus", "12");

	tester = new RegexTester();

	result = tester.eval_should_handle_options();
		test.logResult(result, "eval should handle options", "22");

	tester = new RegexTester();

	result = tester.eval_should_handle_optional_groups();
		test.logResult(result, "eval should handle optional groups", "29");

	tester = new RegexTester();

	result = tester.eval_should_handle_union_at_base_level();
		test.logResult(result, "eval should handle union at base level", "34");

	tester = new RegexTester();

	result = tester.eval_should_handle_union_at_group_level();
		test.logResult(result, "eval should handle union at group level", "42");

	tester = new RegexTester();

	result = tester.eval_should_handle_union_with_kleene_star();
		test.logResult(result, "eval should handle union with kleene star", "47");

	tester = new RegexTester();

	result = tester.eval_should_handle_nested_groups();
		test.logResult(result, "eval should handle nested groups", "55");

	tester = new RegexTester();

	result = tester.eval_should_handle_nested_groups_with_union();
		test.logResult(result, "eval should handle nested groups with union", "60");

	tester = new RegexTester();

	result = tester.eval_should_handle_character_classes();
		test.logResult(result, "eval should handle character classes", "9");

	tester = new RegexTester();

	result = tester.eval_should_handle_inverse_character_classes();
		test.logResult(result, "eval should handle inverse character classes", "14");

	tester = new RegexTester();

	result = tester.eval_should_handle_dollar_sign();
		test.logResult(result, "eval should handle dollar sign", "19");

	tester = new RegexTester();

	result = tester.eval_should_handle_beginning_of_line_caret();
		test.logResult(result, "eval should handle beginning of line caret", "26");

	tester = new RegexTester();

	result = tester.eval_should_handle_group_consumption();
		test.logResult(result, "eval should handle group consumption", "31");

	tester = new RegexTester();

	result = tester.eval_should_handle_group_reconsumption();
		test.logResult(result, "eval should handle group reconsumption", "36");

	tester = new RegexTester();

	result = tester.eval_should_handle_backreferences();
		test.logResult(result, "eval should handle backreferences", "43");

	tester = new RegexTester();

	result = tester.eval_should_handle_forwardreferences();
		test.logResult(result, "eval should handle forwardreferences", "48");

	tester = new RegexTester();

	result = tester.eval_should_handle_comments();
		test.logResult(result, "eval should handle comments", "53");

	tester = new RegexTester();

	result = tester.eval_should_handle_complicated_constructions();
		test.logResult(result, "eval should handle complicated constructions", "60");


	}
}import core.string;

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
return it.does;
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
return it.does;
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
return it.does;
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
return it.does;
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
return it.does;
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
return it.does;
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
return it.does;
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
return it.does;
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
return it.does;
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
return it.does;
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
return it.does;
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
return it.does;
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
return it.does;
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

	
		it find_should_work_as_expected()
	{before_find();
try
{
			String str = new String("foobar");
			String toFind = new String("oob");
			int pos = str.find(toFind);

			if(!(pos == 1))
	{
		return it.doesnt;
	}

		}catch(Exception _exception_)
{
if (_exception_.msg != "Access Violation") { return it.doesnt; } return it.does;
}
	return it.does;
	}
		it find_should_fail_as_expected()
	{before_find();
try
{
			String str = new String("foobar");
			String toFind = new String("boo");
			int pos = str.find(toFind);

			if(!(pos == -1))
	{
		return it.doesnt;
	}

		}catch(Exception _exception_)
{
if (_exception_.msg != "Access Violation") { return it.doesnt; } return it.does;
}
	return it.does;
	}
		it find_should_work_at_the_beginning_of_the_string()
	{before_find();
try
{
			String str = new String("foobar");
			String toFind = new String("foo");
			int pos = str.find(toFind);

			if(!(pos == 0))
	{
		return it.doesnt;
	}

		}catch(Exception _exception_)
{
if (_exception_.msg != "Access Violation") { return it.doesnt; } return it.does;
}
	return it.does;
	}
		it find_should_work_at_the_end_of_the_string()
	{before_find();
try
{
			String str = new String("foobar");
			String toFind = new String("bar");
			int pos = str.find(toFind);

			if(!(pos == 3))
	{
		return it.doesnt;
	}

		}catch(Exception _exception_)
{
if (_exception_.msg != "Access Violation") { return it.doesnt; } return it.does;
}
	return it.does;
	}	done before_find() { }

	
		it insertAt_should_insert_a_string_object()
	{before_insertAt();
try
{
			String str = new String("foobaz");
			String str2 = new String("bar");
			str = str.insertAt(str2, 3);
			if(!(str == "foobarbaz"))
	{
		return it.doesnt;
	}

		}catch(Exception _exception_)
{
if (_exception_.msg != "Access Violation") { return it.doesnt; } return it.does;
}
	return it.does;
	}
		it insertAt_should_insert_a_simple_string()
	{before_insertAt();
try
{
			String str = new String("foobaz");
			str = str.insertAt("bar", 3);
			if(!(str == "foobarbaz"))
	{
		return it.doesnt;
	}

		}catch(Exception _exception_)
{
if (_exception_.msg != "Access Violation") { return it.doesnt; } return it.does;
}
	return it.does;
	}
		it insertAt_should_not_fail_on_position_zero()
	{before_insertAt();
try
{
			String str = new String("barbaz");
			str = str.insertAt("foo", 0);
			if(!(str == "foobarbaz"))
	{
		return it.doesnt;
	}

		}catch(Exception _exception_)
{
if (_exception_.msg != "Access Violation") { return it.doesnt; } return it.does;
}
	return it.does;
	}
		it insertAt_should_not_fail_on_an_empty_string()
	{before_insertAt();
try
{
			String str = new String("foobar");
			str = str.insertAt("", 0);
			if(!(str == "foobar"))
	{
		return it.doesnt;
	}

		}catch(Exception _exception_)
{
if (_exception_.msg != "Access Violation") { return it.doesnt; } return it.does;
}
	return it.does;
	}
		it insertAt_should_not_fail_on_position_outside_string()
	{before_insertAt();
try
{
			String str = new String("foobar");
			str = str.insertAt("baz", str.length() + 1);
			if(!(str == "foobar"))
	{
		return it.doesnt;
	}

		}catch(Exception _exception_)
{
if (_exception_.msg != "Access Violation") { return it.doesnt; } return it.does;
}
	return it.does;
	}	done before_insertAt() { }

	
		it repeat_should_repeat_a_string_object()
	{before_repeat();
try
{
			String str = new String("foo");
			String str2 = String.repeat(str, 3);
			if(!(str2 == "foofoofoo"))
	{
		return it.doesnt;
	}
		}catch(Exception _exception_)
{
if (_exception_.msg != "Access Violation") { return it.doesnt; } return it.does;
}
	return it.does;
	}
		it repeat_should_repeat_a_simple_string()
	{before_repeat();
try
{
			String str = String.repeat("foo", 3);
			if(!(str == "foofoofoo"))
	{
		return it.doesnt;
	}
		}catch(Exception _exception_)
{
if (_exception_.msg != "Access Violation") { return it.doesnt; } return it.does;
}
	return it.does;
	}
		it repeat_should_not_fail_on_an_empty_string()
	{before_repeat();
try
{
			String str = String.repeat("", 3);
			if(!(str == ""))
	{
		return it.doesnt;
	}
		}catch(Exception _exception_)
{
if (_exception_.msg != "Access Violation") { return it.doesnt; } return it.does;
}
	return it.does;
	}
		it repeat_should_not_fail_on_zero_iterations()
	{before_repeat();
try
{
			String str = String.repeat("foo", 0);
			if(!(str == ""))
	{
		return it.doesnt;
	}
		}catch(Exception _exception_)
{
if (_exception_.msg != "Access Violation") { return it.doesnt; } return it.does;
}
	return it.does;
	}	done before_repeat() { }
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
		test.logResult(result, "creation should handle literals", "8");

	tester = new StringTester();

	result = tester.creation_should_handle_integers();
		test.logResult(result, "creation should handle integers", "16");

	tester = new StringTester();

	result = tester.creation_should_handle_formatting();
		test.logResult(result, "creation should handle formatting", "7");

	tester = new StringTester();

	result = tester.creation_should_handle_string_objects();
		test.logResult(result, "creation should handle string objects", "12");

	test.logSubset("trim");

	tester = new StringTester();

	result = tester.trim_should_trim_off_whitespace();
		test.logResult(result, "trim should trim off whitespace", "22");

	test.logSubset("length");

	tester = new StringTester();

	result = tester.length_should_account_for_combining_marks();
		test.logResult(result, "length should account for combining marks", "29");

	tester = new StringTester();

	result = tester.length_should_return_the_number_of_characters();
		test.logResult(result, "length should return the number of characters", "34");

	tester = new StringTester();

	result = tester.length_should_not_fail_on_an_empty_string();
		test.logResult(result, "length should not fail on an empty string", "42");

	test.logSubset("append");

	tester = new StringTester();

	result = tester.append_should_concatenate_a_string_object();
		test.logResult(result, "append should concatenate a string object", "47");

	tester = new StringTester();

	result = tester.append_should_concatenate_a_string_literal();
		test.logResult(result, "append should concatenate a string literal", "55");

	tester = new StringTester();

	result = tester.append_should_concatenate_a_formatted_string_literal();
		test.logResult(result, "append should concatenate a formatted string literal", "60");

	tester = new StringTester();

	result = tester.append_should_not_fail_on_an_empty_string_object();
		test.logResult(result, "append should not fail on an empty string object", "9");

	tester = new StringTester();

	result = tester.append_should_not_fail_on_an_empty_string_literal();
		test.logResult(result, "append should not fail on an empty string literal", "14");

	tester = new StringTester();

	result = tester.append_should_throw_an_exception_for_null_string_object();
		test.logResult(result, "append should throw an exception for null string object", "19");

	test.logSubset("toLowercase");

	tester = new StringTester();

	result = tester.toLowercase_should_work_as_expected();
		test.logResult(result, "toLowercase should work as expected", "26");

	tester = new StringTester();

	result = tester.toLowercase_should_not_fail_on_an_empty_string();
		test.logResult(result, "toLowercase should not fail on an empty string", "31");

	test.logSubset("toUppercase");

	tester = new StringTester();

	result = tester.toUppercase_should_work_as_expected();
		test.logResult(result, "toUppercase should work as expected", "36");

	tester = new StringTester();

	result = tester.toUppercase_should_not_fail_on_an_empty_string();
		test.logResult(result, "toUppercase should not fail on an empty string", "43");

	test.logSubset("find");

	tester = new StringTester();

	result = tester.find_should_work_as_expected();
		test.logResult(result, "find should work as expected", "48");

	tester = new StringTester();

	result = tester.find_should_fail_as_expected();
		test.logResult(result, "find should fail as expected", "53");

	tester = new StringTester();

	result = tester.find_should_work_at_the_beginning_of_the_string();
		test.logResult(result, "find should work at the beginning of the string", "60");

	tester = new StringTester();

	result = tester.find_should_work_at_the_end_of_the_string();
		test.logResult(result, "find should work at the end of the string", "65");

	test.logSubset("insertAt");

	tester = new StringTester();

	result = tester.insertAt_should_insert_a_string_object();
		test.logResult(result, "insertAt should insert a string object", "70");

	tester = new StringTester();

	result = tester.insertAt_should_insert_a_simple_string();
		test.logResult(result, "insertAt should insert a simple string", "77");

	tester = new StringTester();

	result = tester.insertAt_should_not_fail_on_position_zero();
		test.logResult(result, "insertAt should not fail on position zero", "82");

	tester = new StringTester();

	result = tester.insertAt_should_not_fail_on_an_empty_string();
		test.logResult(result, "insertAt should not fail on an empty string", "87");

	tester = new StringTester();

	result = tester.insertAt_should_not_fail_on_position_outside_string();
		test.logResult(result, "insertAt should not fail on position outside string", "12");

	test.logSubset("repeat");

	tester = new StringTester();

	result = tester.repeat_should_repeat_a_string_object();
		test.logResult(result, "repeat should repeat a string object", "17");

	tester = new StringTester();

	result = tester.repeat_should_repeat_a_simple_string();
		test.logResult(result, "repeat should repeat a simple string", "23");

	tester = new StringTester();

	result = tester.repeat_should_not_fail_on_an_empty_string();
		test.logResult(result, "repeat should not fail on an empty string", "30");

	tester = new StringTester();

	result = tester.repeat_should_not_fail_on_zero_iterations();
		test.logResult(result, "repeat should not fail on zero iterations", "38");


	}
}import core.time;

class TimeTester
{
	
		it creation_should_have_sane_defaults()
	{before_creation();
try
{
			auto t = new Time();
			if(!(t.microseconds == 0))
	{
		return it.doesnt;
	}

		}catch(Exception _exception_)
{
if (_exception_.msg != "Access Violation") { return it.doesnt; } return it.does;
}
	return it.does;
	}
		it creation_should_handle_zero_milliseconds()
	{before_creation();
try
{
			auto t = new Time(0);
			if(!(t.microseconds == 0))
	{
		return it.doesnt;
	}

		}catch(Exception _exception_)
{
if (_exception_.msg != "Access Violation") { return it.doesnt; } return it.does;
}
	return it.does;
	}
		it creation_should_handle_positive_microseconds()
	{before_creation();
try
{
			auto t = new Time(1234000);
			if(!(t.microseconds == 1234000))
	{
		return it.doesnt;
	}

		}catch(Exception _exception_)
{
if (_exception_.msg != "Access Violation") { return it.doesnt; } return it.does;
}
	return it.does;
	}
		it creation_should_handle_negative_microseconds()
	{before_creation();
try
{
			auto t = new Time(-1234000);
			if(!(t.microseconds == -1234000))
	{
		return it.doesnt;
	}

		}catch(Exception _exception_)
{
if (_exception_.msg != "Access Violation") { return it.doesnt; } return it.does;
}
	return it.does;
	}
		it creation_should_handle_hours_minutes_seconds()
	{before_creation();
try
{
			auto t = new Time(1, 2, 3);
			if(!(t.microseconds == 3723000000))
	{
		return it.doesnt;
	}

		}catch(Exception _exception_)
{
if (_exception_.msg != "Access Violation") { return it.doesnt; } return it.does;
}
	return it.does;
	}
		it creation_should_handle_hours_minutes_seconds_microseconds()
	{before_creation();
try
{
			auto t = new Time(1, 2, 3, 4);
			if(!(t.microseconds == 3723000004))
	{
		return it.doesnt;
	}

		}catch(Exception _exception_)
{
if (_exception_.msg != "Access Violation") { return it.doesnt; } return it.does;
}
	return it.does;
	}
		it creation_should_handle_negative_everything()
	{before_creation();
try
{
			auto t = new Time(-1, -2, -3, -4);
			if(!(t.microseconds == -3723000004))
	{
		return it.doesnt;
	}

		}catch(Exception _exception_)
{
if (_exception_.msg != "Access Violation") { return it.doesnt; } return it.does;
}
	return it.does;
	}	done before_creation() { }

	
		it Now_should_return_a_new_time()
	{before_Now();
try
{
			auto n = Time.Now();
			if(cast(Time)n is null)
{ return it.doesnt; }

		}catch(Exception _exception_)
{
if (_exception_.msg != "Access Violation") { return it.doesnt; } return it.does;
}
	return it.does;
	}	done before_Now() { }

	
		it hours_should_handle_zero_time()
	{before_hours();
try
{
			auto t = new Time(0);
			if(!(t.hours == 0))
	{
		return it.doesnt;
	}

		}catch(Exception _exception_)
{
if (_exception_.msg != "Access Violation") { return it.doesnt; } return it.does;
}
	return it.does;
	}
		it hours_should_handle_positive_time()
	{before_hours();
try
{
			auto t = new Time(3L * 60L * 60L * 1000000L);
			if(!(t.hours == 3))
	{
		return it.doesnt;
	}

		}catch(Exception _exception_)
{
if (_exception_.msg != "Access Violation") { return it.doesnt; } return it.does;
}
	return it.does;
	}
		it hours_should_handle_negative_time()
	{before_hours();
try
{
			auto t = new Time(-3L * 60L * 60L * 1000000L);
			if(!(t.hours == -3))
	{
		return it.doesnt;
	}

		}catch(Exception _exception_)
{
if (_exception_.msg != "Access Violation") { return it.doesnt; } return it.does;
}
	return it.does;
	}	done before_hours() { }

	
		it minutes_should_handle_zero_time()
	{before_minutes();
try
{
			auto t = new Time(0);
			if(!(t.minutes == 0))
	{
		return it.doesnt;
	}

		}catch(Exception _exception_)
{
if (_exception_.msg != "Access Violation") { return it.doesnt; } return it.does;
}
	return it.does;
	}
		it minutes_should_handle_positive_time()
	{before_minutes();
try
{
			auto t = new Time(25L * 60L * 1000000L);
			if(!(t.minutes == 25))
	{
		return it.doesnt;
	}

		}catch(Exception _exception_)
{
if (_exception_.msg != "Access Violation") { return it.doesnt; } return it.does;
}
	return it.does;
	}
		it minutes_should_handle_negative_time()
	{before_minutes();
try
{
			auto t = new Time(-25L * 60L * 1000000L);
			if(!(t.minutes == -25))
	{
		return it.doesnt;
	}

		}catch(Exception _exception_)
{
if (_exception_.msg != "Access Violation") { return it.doesnt; } return it.does;
}
	return it.does;
	}	done before_minutes() { }

	
		it seconds_should_handle_zero_time()
	{before_seconds();
try
{
			auto t = new Time(0);
			if(!(t.seconds == 0))
	{
		return it.doesnt;
	}

		}catch(Exception _exception_)
{
if (_exception_.msg != "Access Violation") { return it.doesnt; } return it.does;
}
	return it.does;
	}
		it seconds_should_handle_positive_time()
	{before_seconds();
try
{
			auto t = new Time(45L * 1000000L);
			if(!(t.seconds == 45))
	{
		return it.doesnt;
	}

		}catch(Exception _exception_)
{
if (_exception_.msg != "Access Violation") { return it.doesnt; } return it.does;
}
	return it.does;
	}
		it seconds_should_handle_negative_time()
	{before_seconds();
try
{
			auto t = new Time(-45L * 1000000L);
			if(!(t.seconds == -45))
	{
		return it.doesnt;
	}

		}catch(Exception _exception_)
{
if (_exception_.msg != "Access Violation") { return it.doesnt; } return it.does;
}
	return it.does;
	}	done before_seconds() { }

	
		it milliseconds_should_handle_zero_time()
	{before_milliseconds();
try
{
			auto t = new Time(0);
			if(!(t.milliseconds == 0))
	{
		return it.doesnt;
	}

		}catch(Exception _exception_)
{
if (_exception_.msg != "Access Violation") { return it.doesnt; } return it.does;
}
	return it.does;
	}
		it milliseconds_should_handle_positive_time()
	{before_milliseconds();
try
{
			auto t = new Time(678L * 1000L);
			if(!(t.milliseconds == 678))
	{
		return it.doesnt;
	}

		}catch(Exception _exception_)
{
if (_exception_.msg != "Access Violation") { return it.doesnt; } return it.does;
}
	return it.does;
	}
		it milliseconds_should_handle_negative_time()
	{before_milliseconds();
try
{
			auto t = new Time(-678L * 1000L);
			if(!(t.milliseconds == -678))
	{
		return it.doesnt;
	}

		}catch(Exception _exception_)
{
if (_exception_.msg != "Access Violation") { return it.doesnt; } return it.does;
}
	return it.does;
	}
		it milliseconds_should_handle_being_set_to_zero_milliseconds()
	{before_milliseconds();
try
{
			auto t = new Time();
			t.milliseconds = 0;
			if(!(t.microseconds == 0))
	{
		return it.doesnt;
	}

		}catch(Exception _exception_)
{
if (_exception_.msg != "Access Violation") { return it.doesnt; } return it.does;
}
	return it.does;
	}
		it milliseconds_should_handle_being_set_to_positive_milliseconds()
	{before_milliseconds();
try
{
			auto t = new Time();
			t.milliseconds = 1234;
			if(!(t.microseconds == 1234000))
	{
		return it.doesnt;
	}

		}catch(Exception _exception_)
{
if (_exception_.msg != "Access Violation") { return it.doesnt; } return it.does;
}
	return it.does;
	}
		it milliseconds_should_handle_being_set_to_negative_milliseconds()
	{before_milliseconds();
try
{
			auto t = new Time();
			t.milliseconds = -1234;
			if(!(t.microseconds == -1234000))
	{
		return it.doesnt;
	}

		}catch(Exception _exception_)
{
if (_exception_.msg != "Access Violation") { return it.doesnt; } return it.does;
}
	return it.does;
	}	done before_milliseconds() { }

	
		it microseconds_should_handle_being_set_to_zero_microseconds()
	{before_microseconds();
try
{
			auto t = new Time();
			t.microseconds = 0;
			if(!(t.microseconds == 0))
	{
		return it.doesnt;
	}

		}catch(Exception _exception_)
{
if (_exception_.msg != "Access Violation") { return it.doesnt; } return it.does;
}
	return it.does;
	}
		it microseconds_should_handle_being_set_to_positive_microseconds()
	{before_microseconds();
try
{
			auto t = new Time();
			t.microseconds = 1234;
			if(!(t.microseconds == 1234))
	{
		return it.doesnt;
	}

		}catch(Exception _exception_)
{
if (_exception_.msg != "Access Violation") { return it.doesnt; } return it.does;
}
	return it.does;
	}
		it microseconds_should_handle_being_set_to_negative_microseconds()
	{before_microseconds();
try
{
			auto t = new Time();
			t.microseconds(-1234);
			if(!(t.microseconds == -1234))
	{
		return it.doesnt;
	}

		}catch(Exception _exception_)
{
if (_exception_.msg != "Access Violation") { return it.doesnt; } return it.does;
}
	return it.does;
	}	done before_microseconds() { }

	
		it comparators_should_handle_equal_times()
	{before_comparators();
try
{
			auto a = new Time(1234);
			auto b = new Time(1234);
			if(a < b)
{ return it.doesnt; }

			if(!(a == b))
	{
		return it.doesnt;
	}

			if(a > b)
{ return it.doesnt; }

		}catch(Exception _exception_)
{
if (_exception_.msg != "Access Violation") { return it.doesnt; } return it.does;
}
	return it.does;
	}
		it comparators_should_handle_unequal_times()
	{before_comparators();
try
{
			auto a = new Time(-1234);
			auto b = new Time(1234);
			if(!(a < b))
	{
		return it.doesnt;
	}

			if(a == b)
{ return it.doesnt; }

			if(a > b)
{ return it.doesnt; }

		}catch(Exception _exception_)
{
if (_exception_.msg != "Access Violation") { return it.doesnt; } return it.does;
}
	return it.does;
	}	done before_comparators() { }

	
		it toString_should_handle_zero_time()
	{before_toString();
try
{
			auto t = new Time(0);
			if(!(t.toString() == "00:00:00.000"))
	{
		return it.doesnt;
	}

		}catch(Exception _exception_)
{
if (_exception_.msg != "Access Violation") { return it.doesnt; } return it.does;
}
	return it.does;
	}
		it toString_should_handle_some_microseconds()
	{before_toString();
try
{
			auto t = new Time();
			t.microseconds = 123456;
			if(!(t.toString() == "00:00:00.123"))
	{
		return it.doesnt;
	}

		}catch(Exception _exception_)
{
if (_exception_.msg != "Access Violation") { return it.doesnt; } return it.does;
}
	return it.does;
	}
		it toString_should_handle_some_milliseconds()
	{before_toString();
try
{
			auto t = new Time(123000);
			if(!(t.toString() == "00:00:00.123"))
	{
		return it.doesnt;
	}

		}catch(Exception _exception_)
{
if (_exception_.msg != "Access Violation") { return it.doesnt; } return it.does;
}
	return it.does;
	}
		it toString_should_handle_hours_minutes_seconds()
	{before_toString();
try
{
			auto t = new Time(10, 2, 30);
			if(!(t.toString() == "10:02:30.000"))
	{
		return it.doesnt;
	}

		}catch(Exception _exception_)
{
if (_exception_.msg != "Access Violation") { return it.doesnt; } return it.does;
}
	return it.does;
	}
		it toString_should_handle_everything()
	{before_toString();
try
{
			auto t = new Time(12345678000);
			if(!(t.toString() == "03:25:45.678"))
	{
		return it.doesnt;
	}

		}catch(Exception _exception_)
{
if (_exception_.msg != "Access Violation") { return it.doesnt; } return it.does;
}
	return it.does;
	}
		it toString_should_handle_negative_time()
	{before_toString();
try
{
			auto t = new Time(-12345678000);
			if(!(t.toString() == "-03:25:45.678"))
	{
		return it.doesnt;
	}

		}catch(Exception _exception_)
{
if (_exception_.msg != "Access Violation") { return it.doesnt; } return it.does;
}
	return it.does;
	}	done before_toString() { }

	
		it opAdd_should_work()
	{before_opAdd();
try
{
			auto a = new Time(1000000);
			auto b = new Time(234000);
			auto c = a + b;
			if(!(c.microseconds == 1234000))
	{
		return it.doesnt;
	}

		}catch(Exception _exception_)
{
if (_exception_.msg != "Access Violation") { return it.doesnt; } return it.does;
}
	return it.does;
	}	done before_opAdd() { }

	
		it opSub_should_work()
	{before_opSub();
try
{
			auto a = new Time(234000);
			auto b = new Time(1234000);
			auto c = a - b;
			if(!(c.microseconds == -1000000))
	{
		return it.doesnt;
	}

		}catch(Exception _exception_)
{
if (_exception_.msg != "Access Violation") { return it.doesnt; } return it.does;
}
	return it.does;
	}	done before_opSub() { }

	
		it opAddAssign_should_work()
	{before_opAddAssign();
try
{
			auto a = new Time(1000000);
			auto b = new Time(234000);
			a += b;
			if(!(a.microseconds == 1234000))
	{
		return it.doesnt;
	}

		}catch(Exception _exception_)
{
if (_exception_.msg != "Access Violation") { return it.doesnt; } return it.does;
}
	return it.does;
	}	done before_opAddAssign() { }

	
		it opSubAssign_should_work()
	{before_opSubAssign();
try
{
			auto a = new Time(234000);
			auto b = new Time(1234000);
			a -= b;
			if(!(a.microseconds == -1000000))
	{
		return it.doesnt;
	}

		}catch(Exception _exception_)
{
if (_exception_.msg != "Access Violation") { return it.doesnt; } return it.does;
}
	return it.does;
	}	done before_opSubAssign() { }
done before() { }

this() { before(); }


	static void test()
	{
	TimeTester tester = new TimeTester();

	Test test = new Test("Time");

	it result;

	test.logSubset("creation");

	tester = new TimeTester();

	result = tester.creation_should_have_sane_defaults();
		test.logResult(result, "creation should have sane defaults", "8");

	tester = new TimeTester();

	result = tester.creation_should_handle_zero_milliseconds();
		test.logResult(result, "creation should handle zero milliseconds", "16");

	tester = new TimeTester();

	result = tester.creation_should_handle_positive_microseconds();
		test.logResult(result, "creation should handle positive microseconds", "7");

	tester = new TimeTester();

	result = tester.creation_should_handle_negative_microseconds();
		test.logResult(result, "creation should handle negative microseconds", "12");

	tester = new TimeTester();

	result = tester.creation_should_handle_hours_minutes_seconds();
		test.logResult(result, "creation should handle hours minutes seconds", "22");

	tester = new TimeTester();

	result = tester.creation_should_handle_hours_minutes_seconds_microseconds();
		test.logResult(result, "creation should handle hours minutes seconds microseconds", "29");

	tester = new TimeTester();

	result = tester.creation_should_handle_negative_everything();
		test.logResult(result, "creation should handle negative everything", "34");

	test.logSubset("Now");

	tester = new TimeTester();

	result = tester.Now_should_return_a_new_time();
		test.logResult(result, "Now should return a new time", "42");

	test.logSubset("hours");

	tester = new TimeTester();

	result = tester.hours_should_handle_zero_time();
		test.logResult(result, "hours should handle zero time", "47");

	tester = new TimeTester();

	result = tester.hours_should_handle_positive_time();
		test.logResult(result, "hours should handle positive time", "55");

	tester = new TimeTester();

	result = tester.hours_should_handle_negative_time();
		test.logResult(result, "hours should handle negative time", "60");

	test.logSubset("minutes");

	tester = new TimeTester();

	result = tester.minutes_should_handle_zero_time();
		test.logResult(result, "minutes should handle zero time", "9");

	tester = new TimeTester();

	result = tester.minutes_should_handle_positive_time();
		test.logResult(result, "minutes should handle positive time", "14");

	tester = new TimeTester();

	result = tester.minutes_should_handle_negative_time();
		test.logResult(result, "minutes should handle negative time", "19");

	test.logSubset("seconds");

	tester = new TimeTester();

	result = tester.seconds_should_handle_zero_time();
		test.logResult(result, "seconds should handle zero time", "26");

	tester = new TimeTester();

	result = tester.seconds_should_handle_positive_time();
		test.logResult(result, "seconds should handle positive time", "31");

	tester = new TimeTester();

	result = tester.seconds_should_handle_negative_time();
		test.logResult(result, "seconds should handle negative time", "36");

	test.logSubset("milliseconds");

	tester = new TimeTester();

	result = tester.milliseconds_should_handle_zero_time();
		test.logResult(result, "milliseconds should handle zero time", "43");

	tester = new TimeTester();

	result = tester.milliseconds_should_handle_positive_time();
		test.logResult(result, "milliseconds should handle positive time", "48");

	tester = new TimeTester();

	result = tester.milliseconds_should_handle_negative_time();
		test.logResult(result, "milliseconds should handle negative time", "53");

	tester = new TimeTester();

	result = tester.milliseconds_should_handle_being_set_to_zero_milliseconds();
		test.logResult(result, "milliseconds should handle being set to zero milliseconds", "60");

	tester = new TimeTester();

	result = tester.milliseconds_should_handle_being_set_to_positive_milliseconds();
		test.logResult(result, "milliseconds should handle being set to positive milliseconds", "65");

	tester = new TimeTester();

	result = tester.milliseconds_should_handle_being_set_to_negative_milliseconds();
		test.logResult(result, "milliseconds should handle being set to negative milliseconds", "70");

	test.logSubset("microseconds");

	tester = new TimeTester();

	result = tester.microseconds_should_handle_being_set_to_zero_microseconds();
		test.logResult(result, "microseconds should handle being set to zero microseconds", "77");

	tester = new TimeTester();

	result = tester.microseconds_should_handle_being_set_to_positive_microseconds();
		test.logResult(result, "microseconds should handle being set to positive microseconds", "82");

	tester = new TimeTester();

	result = tester.microseconds_should_handle_being_set_to_negative_microseconds();
		test.logResult(result, "microseconds should handle being set to negative microseconds", "87");

	test.logSubset("comparators");

	tester = new TimeTester();

	result = tester.comparators_should_handle_equal_times();
		test.logResult(result, "comparators should handle equal times", "12");

	tester = new TimeTester();

	result = tester.comparators_should_handle_unequal_times();
		test.logResult(result, "comparators should handle unequal times", "17");

	test.logSubset("toString");

	tester = new TimeTester();

	result = tester.toString_should_handle_zero_time();
		test.logResult(result, "toString should handle zero time", "23");

	tester = new TimeTester();

	result = tester.toString_should_handle_some_microseconds();
		test.logResult(result, "toString should handle some microseconds", "30");

	tester = new TimeTester();

	result = tester.toString_should_handle_some_milliseconds();
		test.logResult(result, "toString should handle some milliseconds", "38");

	tester = new TimeTester();

	result = tester.toString_should_handle_hours_minutes_seconds();
		test.logResult(result, "toString should handle hours minutes seconds", "48");

	tester = new TimeTester();

	result = tester.toString_should_handle_everything();
		test.logResult(result, "toString should handle everything", "53");

	tester = new TimeTester();

	result = tester.toString_should_handle_negative_time();
		test.logResult(result, "toString should handle negative time", "58");

	test.logSubset("opAdd");

	tester = new TimeTester();

	result = tester.opAdd_should_work();
		test.logResult(result, "opAdd should work", "70");

	test.logSubset("opSub");

	tester = new TimeTester();

	result = tester.opSub_should_work();
		test.logResult(result, "opSub should work", "78");

	test.logSubset("opAddAssign");

	tester = new TimeTester();

	result = tester.opAddAssign_should_work();
		test.logResult(result, "opAddAssign should work", "94");

	test.logSubset("opSubAssign");

	tester = new TimeTester();

	result = tester.opSubAssign_should_work();
		test.logResult(result, "opSubAssign should work", "99");


	}
}import core.unicode;

import core.string;

class UnicodeTester
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
		test.logResult(result, "utflen should be the same for utf8 as utf32", "8");

	tester = new UnicodeTester();

	result = tester.utflen_should_be_the_same_for_utf16_as_utf32();
		test.logResult(result, "utflen should be the same for utf16 as utf32", "16");

	tester = new UnicodeTester();

	result = tester.utflen_should_account_for_combining_marks_for_utf8();
		test.logResult(result, "utflen should account for combining marks for utf8", "7");

	tester = new UnicodeTester();

	result = tester.utflen_should_account_for_combining_marks_for_utf16();
		test.logResult(result, "utflen should account for combining marks for utf16", "12");

	tester = new UnicodeTester();

	result = tester.utflen_should_account_for_combining_marks_for_utf32();
		test.logResult(result, "utflen should account for combining marks for utf32", "22");

	tester = new UnicodeTester();

	result = tester.utflen_should_account_for_empty_strings_for_utf8();
		test.logResult(result, "utflen should account for empty strings for utf8", "29");

	tester = new UnicodeTester();

	result = tester.utflen_should_account_for_empty_strings_for_utf16();
		test.logResult(result, "utflen should account for empty strings for utf16", "34");

	tester = new UnicodeTester();

	result = tester.utflen_should_account_for_empty_strings_for_utf32();
		test.logResult(result, "utflen should account for empty strings for utf32", "42");

	test.logSubset("toUtfChars");

	tester = new UnicodeTester();

	result = tester.toUtfChars_should_work_as_expected_for_single_characters_for_utf32();
		test.logResult(result, "toUtfChars should work as expected for single characters for utf32", "47");

	tester = new UnicodeTester();

	result = tester.toUtfChars_should_work_as_expected_for_single_characters_for_utf16();
		test.logResult(result, "toUtfChars should work as expected for single characters for utf16", "55");

	tester = new UnicodeTester();

	result = tester.toUtfChars_should_work_as_expected_for_single_characters_for_utf8();
		test.logResult(result, "toUtfChars should work as expected for single characters for utf8", "60");

	tester = new UnicodeTester();

	result = tester.toUtfChars_should_account_for_combining_marks_for_utf32();
		test.logResult(result, "toUtfChars should account for combining marks for utf32", "9");

	tester = new UnicodeTester();

	result = tester.toUtfChars_should_account_for_combining_marks_for_utf16();
		test.logResult(result, "toUtfChars should account for combining marks for utf16", "14");

	tester = new UnicodeTester();

	result = tester.toUtfChars_should_account_for_combining_marks_for_utf8();
		test.logResult(result, "toUtfChars should account for combining marks for utf8", "19");


	}
}import core.util;

import utils.stack;

import core.list;

import interfaces.container;

class UtilTester
{
	
		it typeTemplates_should_determine_if_it_is_a_type()
	{before_typeTemplates();
try
{
			if(!(IsType!(int)))
	{
		return it.doesnt;
	}

			if(IsType!(int[]))
{ return it.doesnt; }

		}catch(Exception _exception_)
{
if (_exception_.msg != "Access Violation") { return it.doesnt; } return it.does;
}
	return it.does;
	}
		it typeTemplates_should_determine_if_it_is_a_class()
	{before_typeTemplates();
try
{
			if(!(IsClass!(Stack!(int))))
	{
		return it.doesnt;
	}

			if(IsClass!(int))
{ return it.doesnt; }

		}catch(Exception _exception_)
{
if (_exception_.msg != "Access Violation") { return it.doesnt; } return it.does;
}
	return it.does;
	}
		it typeTemplates_should_determine_if_it_is_an_iterface()
	{before_typeTemplates();
try
{
			if(!(IsInterface!(AbstractContainer)))
	{
		return it.doesnt;
	}

			if(IsInterface!(int))
{ return it.doesnt; }

		}catch(Exception _exception_)
{
if (_exception_.msg != "Access Violation") { return it.doesnt; } return it.does;
}
	return it.does;
	}
		it typeTemplates_should_determine_if_it_is_an_object()
	{before_typeTemplates();
try
{
			if(IsObject!(int))
{ return it.doesnt; }

			if(!(IsObject!(Stack!(int))))
	{
		return it.doesnt;
	}

			if(!(IsObject!(AbstractContainer)))
	{
		return it.doesnt;
	}

		}catch(Exception _exception_)
{
if (_exception_.msg != "Access Violation") { return it.doesnt; } return it.does;
}
	return it.does;
	}
		it typeTemplates_should_determine_if_it_is_an_int_type()
	{before_typeTemplates();
try
{
			if(!(IsIntType!(int)))
	{
		return it.doesnt;
	}

			if(!(IsIntType!(uint)))
	{
		return it.doesnt;
	}

			if(IsIntType!(int[]))
{ return it.doesnt; }

		}catch(Exception _exception_)
{
if (_exception_.msg != "Access Violation") { return it.doesnt; } return it.does;
}
	return it.does;
	}
		it typeTemplates_should_determine_if_it_is_unsigned()
	{before_typeTemplates();
try
{
			if(!(IsUnsigned!(uint)))
	{
		return it.doesnt;
	}

			if(!(IsUnsigned!(ushort)))
	{
		return it.doesnt;
	}

			if(!(IsUnsigned!(ulong)))
	{
		return it.doesnt;
	}

			if(!(IsUnsigned!(ubyte)))
	{
		return it.doesnt;
	}


			if(IsUnsigned!(int))
{ return it.doesnt; }

			if(IsUnsigned!(short))
{ return it.doesnt; }

			if(IsUnsigned!(long))
{ return it.doesnt; }

			if(IsUnsigned!(byte))
{ return it.doesnt; }

		}catch(Exception _exception_)
{
if (_exception_.msg != "Access Violation") { return it.doesnt; } return it.does;
}
	return it.does;
	}
		it typeTemplates_should_determine_if_it_is_signed()
	{before_typeTemplates();
try
{
			if(!(IsSigned!(int)))
	{
		return it.doesnt;
	}

			if(!(IsSigned!(short)))
	{
		return it.doesnt;
	}

			if(!(IsSigned!(long)))
	{
		return it.doesnt;
	}

			if(!(IsSigned!(byte)))
	{
		return it.doesnt;
	}


			if(IsSigned!(uint))
{ return it.doesnt; }

			if(IsSigned!(ushort))
{ return it.doesnt; }

			if(IsSigned!(ulong))
{ return it.doesnt; }

			if(IsSigned!(ubyte))
{ return it.doesnt; }

		}catch(Exception _exception_)
{
if (_exception_.msg != "Access Violation") { return it.doesnt; } return it.does;
}
	return it.does;
	}
		it typeTemplates_should_determine_if_it_is_float()
	{before_typeTemplates();
try
{
			if(!(IsFloat!(float)))
	{
		return it.doesnt;
	}

			if(!(IsFloat!(double)))
	{
		return it.doesnt;
	}

			if(!(IsFloat!(real)))
	{
		return it.doesnt;
	}


			if(IsFloat!(int))
{ return it.doesnt; }

		}catch(Exception _exception_)
{
if (_exception_.msg != "Access Violation") { return it.doesnt; } return it.does;
}
	return it.does;
	}
		it typeTemplates_should_determine_if_it_is_complex()
	{before_typeTemplates();
try
{
			if(!(IsComplex!(cfloat)))
	{
		return it.doesnt;
	}

			if(!(IsComplex!(cdouble)))
	{
		return it.doesnt;
	}

			if(!(IsComplex!(creal)))
	{
		return it.doesnt;
	}


			if(IsComplex!(float))
{ return it.doesnt; }

		}catch(Exception _exception_)
{
if (_exception_.msg != "Access Violation") { return it.doesnt; } return it.does;
}
	return it.does;
	}
		it typeTemplates_should_determine_if_it_is_imaginary()
	{before_typeTemplates();
try
{
			if(!(IsImaginary!(ifloat)))
	{
		return it.doesnt;
	}

			if(!(IsImaginary!(idouble)))
	{
		return it.doesnt;
	}

			if(!(IsImaginary!(ireal)))
	{
		return it.doesnt;
	}


			if(IsImaginary!(float))
{ return it.doesnt; }

		}catch(Exception _exception_)
{
if (_exception_.msg != "Access Violation") { return it.doesnt; } return it.does;
}
	return it.does;
	}
		it typeTemplates_should_determine_if_it_is_struct()
	{before_typeTemplates();
try
{
			if(IsStruct!(int))
{ return it.doesnt; }

		}catch(Exception _exception_)
{
if (_exception_.msg != "Access Violation") { return it.doesnt; } return it.does;
}
	return it.does;
	}
		it typeTemplates_should_determine_if_it_is_array()
	{before_typeTemplates();
try
{
			if(!(IsArray!(int[])))
	{
		return it.doesnt;
	}

			if(IsArray!(int))
{ return it.doesnt; }

		}catch(Exception _exception_)
{
if (_exception_.msg != "Access Violation") { return it.doesnt; } return it.does;
}
	return it.does;
	}		
		it typeTemplates_should_determine_the_superclass()
	{before_typeTemplates();
try
{
			class A}catch(Exception _exception_)
{
if (_exception_.msg != "Access Violation") { return it.doesnt; } return it.does;
}
	return it.does;
	}			class B : A done before_typeTemplates() { }
			class C : B done before() { }

this() { before(); }


	static void test()
	{
	UtilTester tester = new UtilTester();

	Test test = new Test("Util");

	it result;

	test.logSubset("typeTemplates");

	tester = new UtilTester();

	result = tester.typeTemplates_should_determine_if_it_is_a_type();
		test.logResult(result, "typeTemplates should determine if it is a type", "8");

	tester = new UtilTester();

	result = tester.typeTemplates_should_determine_if_it_is_a_class();
		test.logResult(result, "typeTemplates should determine if it is a class", "16");

	tester = new UtilTester();

	result = tester.typeTemplates_should_determine_if_it_is_an_iterface();
		test.logResult(result, "typeTemplates should determine if it is an iterface", "7");

	tester = new UtilTester();

	result = tester.typeTemplates_should_determine_if_it_is_an_object();
		test.logResult(result, "typeTemplates should determine if it is an object", "12");

	tester = new UtilTester();

	result = tester.typeTemplates_should_determine_if_it_is_an_int_type();
		test.logResult(result, "typeTemplates should determine if it is an int type", "22");

	tester = new UtilTester();

	result = tester.typeTemplates_should_determine_if_it_is_unsigned();
		test.logResult(result, "typeTemplates should determine if it is unsigned", "29");

	tester = new UtilTester();

	result = tester.typeTemplates_should_determine_if_it_is_signed();
		test.logResult(result, "typeTemplates should determine if it is signed", "34");

	tester = new UtilTester();

	result = tester.typeTemplates_should_determine_if_it_is_float();
		test.logResult(result, "typeTemplates should determine if it is float", "42");

	tester = new UtilTester();

	result = tester.typeTemplates_should_determine_if_it_is_complex();
		test.logResult(result, "typeTemplates should determine if it is complex", "47");

	tester = new UtilTester();

	result = tester.typeTemplates_should_determine_if_it_is_imaginary();
		test.logResult(result, "typeTemplates should determine if it is imaginary", "55");

	tester = new UtilTester();

	result = tester.typeTemplates_should_determine_if_it_is_struct();
		test.logResult(result, "typeTemplates should determine if it is struct", "60");

	tester = new UtilTester();

	result = tester.typeTemplates_should_determine_if_it_is_array();
		test.logResult(result, "typeTemplates should determine if it is array", "9");

	tester = new UtilTester();

	result = tester.typeTemplates_should_determine_the_superclass();
		test.logResult(result, "typeTemplates should determine the superclass", "14");


	}
}class StringTemplatesTester
{
		it should_capitalize_a_string()
	{before();
try
{
			if(!(Capitalize!("string") == "String"))
	{
		return it.doesnt;
	}

			if(!(Capitalize!("String") == "String"))
	{
		return it.doesnt;
	}

		}catch(Exception _exception_)
{
if (_exception_.msg != "Access Violation") { return it.doesnt; } return it.does;
}
	return it.does;
	}
		it should_trim_whitespace_from_the_left()
	{before();
try
{
			if(!(TrimL!("string") == "string"))
	{
		return it.doesnt;
	}

			if(!(TrimL!("   string") == "string"))
	{
		return it.doesnt;
	}

			if(!(TrimL!("string   ") == "string   "))
	{
		return it.doesnt;
	}

			if(!(TrimL!("   string   ") == "string   "))
	{
		return it.doesnt;
	}


			if(!(TrimL!("\t\n\rstring") == "string"))
	{
		return it.doesnt;
	}

			if(!(TrimL!("string\t\n\r") == "string\t\n\r"))
	{
		return it.doesnt;
	}

			if(!(TrimL!("\t\n\rstring\t\n\r") == "string\t\n\r"))
	{
		return it.doesnt;
	}

		}catch(Exception _exception_)
{
if (_exception_.msg != "Access Violation") { return it.doesnt; } return it.does;
}
	return it.does;
	}
		it should_trim_whitespace_from_the_right()
	{before();
try
{
			if(!(TrimR!("string") == "string"))
	{
		return it.doesnt;
	}

			if(!(TrimR!("   string") == "   string"))
	{
		return it.doesnt;
	}

			if(!(TrimR!("string   ") == "string"))
	{
		return it.doesnt;
	}

			if(!(TrimR!("   string   ") == "   string"))
	{
		return it.doesnt;
	}


			if(!(TrimR!("\t\n\rstring") == "\t\n\rstring"))
	{
		return it.doesnt;
	}

			if(!(TrimR!("string\t\n\r") == "string"))
	{
		return it.doesnt;
	}

			if(!(TrimR!("\t\n\rstring\t\n\r") == "\t\n\rstring"))
	{
		return it.doesnt;
	}

		}catch(Exception _exception_)
{
if (_exception_.msg != "Access Violation") { return it.doesnt; } return it.does;
}
	return it.does;
	}
		it should_remove_spaces()
	{before();
try
{
			if(!(RemoveSpaces!("string") == "string"))
	{
		return it.doesnt;
	}

			if(!(RemoveSpaces!(" s t r i n g ") == "string"))
	{
		return it.doesnt;
	}

			if(!(RemoveSpaces!("\ts\nt\rr\ti\nn\rg") == "string"))
	{
		return it.doesnt;
	}

		}catch(Exception _exception_)
{
if (_exception_.msg != "Access Violation") { return it.doesnt; } return it.does;
}
	return it.does;
	}	done before() { }

this() { before(); }


	static void test()
	{
	StringTemplatesTester tester = new StringTemplatesTester();

	Test test = new Test("StringTemplates");

	it result;

	tester = new StringTemplatesTester();

	result = tester._should_capitalize_a_string();
		test.logResult(result, " should capitalize a string", "8");

	tester = new StringTemplatesTester();

	result = tester._should_trim_whitespace_from_the_left();
		test.logResult(result, " should trim whitespace from the left", "16");

	tester = new StringTemplatesTester();

	result = tester._should_trim_whitespace_from_the_right();
		test.logResult(result, " should trim whitespace from the right", "7");

	tester = new StringTemplatesTester();

	result = tester._should_remove_spaces();
		test.logResult(result, " should remove spaces", "12");


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
		test.logResult(result, "creation should allow for 64 bits", "8");

	tester = new DigestTester();

	result = tester.creation_should_allow_for_128_bits();
		test.logResult(result, "creation should allow for 128 bits", "16");

	tester = new DigestTester();

	result = tester.creation_should_allow_for_160_bits();
		test.logResult(result, "creation should allow for 160 bits", "7");

	tester = new DigestTester();

	result = tester.creation_should_allow_for_192_bits();
		test.logResult(result, "creation should allow for 192 bits", "12");

	test.logSubset("comparison");

	tester = new DigestTester();

	result = tester.comparison_should_work_for_equals_overload();
		test.logResult(result, "comparison should work for equals overload", "22");

	tester = new DigestTester();

	result = tester.comparison_should_work_for_equals_function();
		test.logResult(result, "comparison should work for equals function", "29");


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
		test.logResult(result, "hash should hash as expected for String objects", "8");

	tester = new MD5Tester();

	result = tester.hash_should_hash_as_expected_for_string_literals();
		test.logResult(result, "hash should hash as expected for string literals", "16");

	tester = new MD5Tester();

	result = tester.hash_should_respect_leading_zeroes();
		test.logResult(result, "hash should respect leading zeroes", "7");

	tester = new MD5Tester();

	result = tester.hash_should_work_on_byte_arrays();
		test.logResult(result, "hash should work on byte arrays", "12");


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
		test.logResult(result, "hash should hash as expected for String objects", "8");

	tester = new SHA1Tester();

	result = tester.hash_should_hash_as_expected_for_string_literals();
		test.logResult(result, "hash should hash as expected for string literals", "16");

	tester = new SHA1Tester();

	result = tester.hash_should_hash_the_empty_string();
		test.logResult(result, "hash should hash the empty string", "7");


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
		test.logResult(result, "hash should hash as expected for String objects", "8");

	tester = new SHA224Tester();

	result = tester.hash_should_hash_as_expected_for_string_literals();
		test.logResult(result, "hash should hash as expected for string literals", "16");

	tester = new SHA224Tester();

	result = tester.hash_should_hash_the_empty_string();
		test.logResult(result, "hash should hash the empty string", "7");


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
		test.logResult(result, "hash should hash as expected for String objects", "8");

	tester = new SHA256Tester();

	result = tester.hash_should_hash_as_expected_for_string_literals();
		test.logResult(result, "hash should hash as expected for string literals", "16");

	tester = new SHA256Tester();

	result = tester.hash_should_hash_the_empty_string();
		test.logResult(result, "hash should hash the empty string", "7");


	}
}import utils.fibonacci;

import utils.heap;

import core.random;

class FibonacciHeapTester
{
	
		it creation_should_work_as_expected()
	{before_creation();
try
{
			FibonacciHeap!(int) queue = new FibonacciHeap!(int)();
			if(queue is null)
{ return it.doesnt; }

			if(!(queue.length == 0))
	{
		return it.doesnt;
	}

		}catch(Exception _exception_)
{
if (_exception_.msg != "Access Violation") { return it.doesnt; } return it.does;
}
	return it.does;
	}	done before_creation() { }

	
		it add_should_add_an_item_to_an_empty_list()
	{before_add();
try
{
			FibonacciHeap!(int) queue = new FibonacciHeap!(int)();
			int item = 42;
			queue.add(item);
			if(!(queue.length == 1))
	{
		return it.doesnt;
	}

			if(!(queue.peek() == item))
	{
		return it.doesnt;
	}

		}catch(Exception _exception_)
{
if (_exception_.msg != "Access Violation") { return it.doesnt; } return it.does;
}
	return it.does;
	}	done before_add() { }

	
		it peek_should_return_the_first_item_in_min_heap()
	{before_peek();
try
{
			auto queue = new FibonacciHeap!(int, MinHeap);
			queue.add(10);
			queue.add(4);
			queue.add(15);
			if(!(queue.length == 3))
	{
		return it.doesnt;
	}

			if(!(queue.peek() == 4))
	{
		return it.doesnt;
	}

		}catch(Exception _exception_)
{
if (_exception_.msg != "Access Violation") { return it.doesnt; } return it.does;
}
	return it.does;
	}
		it peek_should_return_the_first_item_in_max_heap()
	{before_peek();
try
{
			auto queue = new FibonacciHeap!(int, MaxHeap);
			queue.add(10);
			queue.add(4);
			queue.add(15);
			if(!(queue.length == 3))
	{
		return it.doesnt;
	}

			if(!(queue.peek() == 15))
	{
		return it.doesnt;
	}

		}catch(Exception _exception_)
{
if (_exception_.msg != "Access Violation") { return it.doesnt; } return it.does;
}
	return it.does;
	}
		it peek_should_handle_a_heavy_workload()
	{before_peek();
try
{
			auto queue = new FibonacciHeap!(int, MinHeap);
			int min;
			int val;

			Random r = new Random();
			val = cast(int)r.next();
			queue.add(val);
			min = val;

			for(int i; i < 100; i++) 
				val = cast(int)r.next();
				queue.add(val);
				if (val < min) 
					min = val;
				}catch(Exception _exception_)
{
if (_exception_.msg != "Access Violation") { return it.doesnt; } return it.does;
}
	return it.does;
	}			done before_peek() { }
		

			should(queue.peek() == min);
			int foo;
			int last = queue.peek();

			while (!queue.empty()) 
				foo = queue.remove();
				should(foo >= last);
				last = foo;
			done before() { }

this() { before(); }


	static void test()
	{
	FibonacciHeapTester tester = new FibonacciHeapTester();

	Test test = new Test("FibonacciHeap");

	it result;

	test.logSubset("creation");

	tester = new FibonacciHeapTester();

	result = tester.creation_should_work_as_expected();
		test.logResult(result, "creation should work as expected", "8");

	test.logSubset("add");

	tester = new FibonacciHeapTester();

	result = tester.add_should_add_an_item_to_an_empty_list();
		test.logResult(result, "add should add an item to an empty list", "16");

	test.logSubset("peek");

	tester = new FibonacciHeapTester();

	result = tester.peek_should_return_the_first_item_in_min_heap();
		test.logResult(result, "peek should return the first item in min heap", "7");

	tester = new FibonacciHeapTester();

	result = tester.peek_should_return_the_first_item_in_max_heap();
		test.logResult(result, "peek should return the first item in max heap", "12");

	tester = new FibonacciHeapTester();

	result = tester.peek_should_handle_a_heavy_workload();
		test.logResult(result, "peek should handle a heavy workload", "22");


	}
}class RemoveTester
{
		it should_remove_the_first_item_in_min_heap()
	{before();
try
{
			auto queue = new FibonacciHeap!(int, MinHeap);
			queue.add(10);
			queue.add(4);
			queue.add(15);
			if(!(queue.length == 3))
	{
		return it.doesnt;
	}

			if(!(queue.remove() == 4))
	{
		return it.doesnt;
	}

		}catch(Exception _exception_)
{
if (_exception_.msg != "Access Violation") { return it.doesnt; } return it.does;
}
	return it.does;
	}
		it should_remove_the_first_item_in_max_heap()
	{before();
try
{
			auto queue = new FibonacciHeap!(int, MaxHeap);
			queue.add(10);
			queue.add(4);
			queue.add(15);
			if(!(queue.length == 3))
	{
		return it.doesnt;
	}

			if(!(queue.remove() == 15))
	{
		return it.doesnt;
	}

		}catch(Exception _exception_)
{
if (_exception_.msg != "Access Violation") { return it.doesnt; } return it.does;
}
	return it.does;
	}	done before() { }

this() { before(); }


	static void test()
	{
	RemoveTester tester = new RemoveTester();

	Test test = new Test("Remove");

	it result;

	tester = new RemoveTester();

	result = tester._should_remove_the_first_item_in_min_heap();
		test.logResult(result, " should remove the first item in min heap", "8");

	tester = new RemoveTester();

	result = tester._should_remove_the_first_item_in_max_heap();
		test.logResult(result, " should remove the first item in max heap", "16");


	}
}class LengthTester
{
		it should_be_zero_for_an_empty_list()
	{before();
try
{
			auto queue = new FibonacciHeap!(int);
			if(!(queue.empty))
	{
		return it.doesnt;
	}

			if(!(queue.length == 0))
	{
		return it.doesnt;
	}

		}catch(Exception _exception_)
{
if (_exception_.msg != "Access Violation") { return it.doesnt; } return it.does;
}
	return it.does;
	}	done before() { }

this() { before(); }


	static void test()
	{
	LengthTester tester = new LengthTester();

	Test test = new Test("Length");

	it result;

	tester = new LengthTester();

	result = tester._should_be_zero_for_an_empty_list();
		test.logResult(result, " should be zero for an empty list", "8");


	}
}class ClearTester
{
		it should_result_in_an_empty_list()
	{before();
try
{
			auto queue = new FibonacciHeap!(int);
			queue.add(15);
			queue.add(10);
			queue.add(24);

			if(queue.length == 0)
{ return it.doesnt; }

			if(queue.empty())
{ return it.doesnt; }


			queue.clear();
			if(!(queue.length == 0))
	{
		return it.doesnt;
	}

			if(!(queue.empty()))
	{
		return it.doesnt;
	}

		}catch(Exception _exception_)
{
if (_exception_.msg != "Access Violation") { return it.doesnt; } return it.does;
}
	return it.does;
	}	done before() { }

this() { before(); }


	static void test()
	{
	ClearTester tester = new ClearTester();

	Test test = new Test("Clear");

	it result;

	tester = new ClearTester();

	result = tester._should_result_in_an_empty_list();
		test.logResult(result, " should result in an empty list", "8");


	}
}class EmptyTester
{
		it should_be_true_when_the_list_is_empty()
	{before();
try
{
			auto queue = new FibonacciHeap!(int);
			queue.add(10);
			if(queue.empty())
{ return it.doesnt; }

			queue.remove();
			if(!(queue.empty()))
	{
		return it.doesnt;
	}

		}catch(Exception _exception_)
{
if (_exception_.msg != "Access Violation") { return it.doesnt; } return it.does;
}
	return it.does;
	}
		it should_be_true_for_a_new_list()
	{before();
try
{
			auto queue = new FibonacciHeap!(int);
			if(!(queue.empty()))
	{
		return it.doesnt;
	}

		}catch(Exception _exception_)
{
if (_exception_.msg != "Access Violation") { return it.doesnt; } return it.does;
}
	return it.does;
	}	done before() { }

this() { before(); }


	static void test()
	{
	EmptyTester tester = new EmptyTester();

	Test test = new Test("Empty");

	it result;

	tester = new EmptyTester();

	result = tester._should_be_true_when_the_list_is_empty();
		test.logResult(result, " should be true when the list is empty", "8");

	tester = new EmptyTester();

	result = tester._should_be_true_for_a_new_list();
		test.logResult(result, " should be true for a new list", "16");


	}
}import utils.heap;

import core.random;

class PriorityQueueTester
{
	
		it creation_should_work_as_expected()
	{before_creation();
try
{
			PriorityQueue!(int) queue = new PriorityQueue!(int)();
			if(queue is null)
{ return it.doesnt; }

			if(!(queue.length == 0))
	{
		return it.doesnt;
	}

		}catch(Exception _exception_)
{
if (_exception_.msg != "Access Violation") { return it.doesnt; } return it.does;
}
	return it.does;
	}	done before_creation() { }

	
		it add_should_add_an_item_to_an_empty_list()
	{before_add();
try
{
			PriorityQueue!(int) queue = new PriorityQueue!(int)();
			int item = 42;
			queue.add(item);
			if(!(queue.length == 1))
	{
		return it.doesnt;
	}

			if(!(queue.peek() == item))
	{
		return it.doesnt;
	}

		}catch(Exception _exception_)
{
if (_exception_.msg != "Access Violation") { return it.doesnt; } return it.does;
}
	return it.does;
	}	done before_add() { }

	
		it peek_should_return_the_first_item_in_min_heap()
	{before_peek();
try
{
			auto queue = new PriorityQueue!(int, MinHeap);
			queue.add(10);
			queue.add(4);
			queue.add(15);
			if(!(queue.length == 3))
	{
		return it.doesnt;
	}

			if(!(queue.peek() == 4))
	{
		return it.doesnt;
	}

		}catch(Exception _exception_)
{
if (_exception_.msg != "Access Violation") { return it.doesnt; } return it.does;
}
	return it.does;
	}
		it peek_should_return_the_first_item_in_max_heap()
	{before_peek();
try
{
			auto queue = new PriorityQueue!(int, MaxHeap);
			queue.add(10);
			queue.add(4);
			queue.add(15);
			if(!(queue.length == 3))
	{
		return it.doesnt;
	}

			if(!(queue.peek() == 15))
	{
		return it.doesnt;
	}

		}catch(Exception _exception_)
{
if (_exception_.msg != "Access Violation") { return it.doesnt; } return it.does;
}
	return it.does;
	}
		it peek_should_handle_a_heavy_workload()
	{before_peek();
try
{
			auto queue = new PriorityQueue!(int, MinHeap);
			int min;
			int val;

			Random r = new Random();
			val = cast(int)r.next();
			queue.add(val);
			min = val;

			for(int i; i < 10000; i++) 
				val = cast(int)r.next();
				queue.add(val);
				if (val < min) 
					min = val;
				}catch(Exception _exception_)
{
if (_exception_.msg != "Access Violation") { return it.doesnt; } return it.does;
}
	return it.does;
	}			done before_peek() { }
		

			should(queue.peek() == min);

			int foo;
			int last = min;

			while (!queue.empty()) 
				foo = queue.remove();
				should(foo >= last);
				last = foo;
			done before() { }

this() { before(); }


	static void test()
	{
	PriorityQueueTester tester = new PriorityQueueTester();

	Test test = new Test("PriorityQueue");

	it result;

	test.logSubset("creation");

	tester = new PriorityQueueTester();

	result = tester.creation_should_work_as_expected();
		test.logResult(result, "creation should work as expected", "8");

	test.logSubset("add");

	tester = new PriorityQueueTester();

	result = tester.add_should_add_an_item_to_an_empty_list();
		test.logResult(result, "add should add an item to an empty list", "16");

	test.logSubset("peek");

	tester = new PriorityQueueTester();

	result = tester.peek_should_return_the_first_item_in_min_heap();
		test.logResult(result, "peek should return the first item in min heap", "7");

	tester = new PriorityQueueTester();

	result = tester.peek_should_return_the_first_item_in_max_heap();
		test.logResult(result, "peek should return the first item in max heap", "12");

	tester = new PriorityQueueTester();

	result = tester.peek_should_handle_a_heavy_workload();
		test.logResult(result, "peek should handle a heavy workload", "22");


	}
}class RemoveTester
{
		it should_remove_the_first_item_in_min_heap()
	{before();
try
{
			auto queue = new PriorityQueue!(int, MinHeap);
			queue.add(10);
			queue.add(4);
			queue.add(15);
			if(!(queue.length == 3))
	{
		return it.doesnt;
	}

			if(!(queue.remove() == 4))
	{
		return it.doesnt;
	}

		}catch(Exception _exception_)
{
if (_exception_.msg != "Access Violation") { return it.doesnt; } return it.does;
}
	return it.does;
	}
		it should_remove_the_first_item_in_max_heap()
	{before();
try
{
			auto queue = new PriorityQueue!(int, MaxHeap);
			queue.add(10);
			queue.add(4);
			queue.add(15);
			if(!(queue.length == 3))
	{
		return it.doesnt;
	}

			if(!(queue.remove() == 15))
	{
		return it.doesnt;
	}

		}catch(Exception _exception_)
{
if (_exception_.msg != "Access Violation") { return it.doesnt; } return it.does;
}
	return it.does;
	}	done before() { }

this() { before(); }


	static void test()
	{
	RemoveTester tester = new RemoveTester();

	Test test = new Test("Remove");

	it result;

	tester = new RemoveTester();

	result = tester._should_remove_the_first_item_in_min_heap();
		test.logResult(result, " should remove the first item in min heap", "8");

	tester = new RemoveTester();

	result = tester._should_remove_the_first_item_in_max_heap();
		test.logResult(result, " should remove the first item in max heap", "16");


	}
}class LengthTester
{
		it should_be_zero_for_an_empty_list()
	{before();
try
{
			auto queue = new PriorityQueue!(int);
			if(!(queue.empty))
	{
		return it.doesnt;
	}

			if(!(queue.length == 0))
	{
		return it.doesnt;
	}

		}catch(Exception _exception_)
{
if (_exception_.msg != "Access Violation") { return it.doesnt; } return it.does;
}
	return it.does;
	}	done before() { }

this() { before(); }


	static void test()
	{
	LengthTester tester = new LengthTester();

	Test test = new Test("Length");

	it result;

	tester = new LengthTester();

	result = tester._should_be_zero_for_an_empty_list();
		test.logResult(result, " should be zero for an empty list", "8");


	}
}class ClearTester
{
		it should_result_in_an_empty_list()
	{before();
try
{
			auto queue = new PriorityQueue!(int);
			queue.add(15);
			queue.add(10);
			queue.add(24);

			if(queue.length == 0)
{ return it.doesnt; }

			if(queue.empty())
{ return it.doesnt; }


			queue.clear();
			if(!(queue.length == 0))
	{
		return it.doesnt;
	}

			if(!(queue.empty()))
	{
		return it.doesnt;
	}

		}catch(Exception _exception_)
{
if (_exception_.msg != "Access Violation") { return it.doesnt; } return it.does;
}
	return it.does;
	}	done before() { }

this() { before(); }


	static void test()
	{
	ClearTester tester = new ClearTester();

	Test test = new Test("Clear");

	it result;

	tester = new ClearTester();

	result = tester._should_result_in_an_empty_list();
		test.logResult(result, " should result in an empty list", "8");


	}
}class EmptyTester
{
		it should_be_true_when_the_list_is_empty()
	{before();
try
{
			auto queue = new PriorityQueue!(int);
			queue.add(10);
			if(queue.empty())
{ return it.doesnt; }

			queue.remove();
			if(!(queue.empty()))
	{
		return it.doesnt;
	}

		}catch(Exception _exception_)
{
if (_exception_.msg != "Access Violation") { return it.doesnt; } return it.does;
}
	return it.does;
	}
		it should_be_true_for_a_new_list()
	{before();
try
{
			auto queue = new PriorityQueue!(int);
			if(!(queue.empty()))
	{
		return it.doesnt;
	}

		}catch(Exception _exception_)
{
if (_exception_.msg != "Access Violation") { return it.doesnt; } return it.does;
}
	return it.does;
	}	done before() { }

this() { before(); }


	static void test()
	{
	EmptyTester tester = new EmptyTester();

	Test test = new Test("Empty");

	it result;

	tester = new EmptyTester();

	result = tester._should_be_true_when_the_list_is_empty();
		test.logResult(result, " should be true when the list is empty", "8");

	tester = new EmptyTester();

	result = tester._should_be_true_for_a_new_list();
		test.logResult(result, " should be true for a new list", "16");


	}
}import utils.linkedlist;

class LinkedListTester
{
	
		it creation_should_work_as_expected()
	{before_creation();
try
{
			LinkedList!(int) list = new LinkedList!(int)();
			if(list is null)
{ return it.doesnt; }

			if(!(list.length == 0))
	{
		return it.doesnt;
	}

		}catch(Exception _exception_)
{
if (_exception_.msg != "Access Violation") { return it.doesnt; } return it.does;
}
	return it.does;
	}	done before_creation() { }

	
		it add_should_add_item_to_the_head()
	{before_add();
try
{
			LinkedList!(int) list = new LinkedList!(int)();
			int item = 42;
			list.add(item);
			
			if(!(list.length == 1))
	{
		return it.doesnt;
	}

			if(!(list.peek() == item))
	{
		return it.doesnt;
	}

		}catch(Exception _exception_)
{
if (_exception_.msg != "Access Violation") { return it.doesnt; } return it.does;
}
	return it.does;
	}
		it add_should_an_a_list_to_list()
	{before_add();
try
{
			LinkedList!(int) list1 = new LinkedList!(int)();
			LinkedList!(int) list2 = new LinkedList!(int)();
			int item = 33;

			list2.add(item);
			list1.add(list2);
			
			if(!(list1.length == 1))
	{
		return it.doesnt;
	}

			if(!(list1.peek() == item))
	{
		return it.doesnt;
	}


		}catch(Exception _exception_)
{
if (_exception_.msg != "Access Violation") { return it.doesnt; } return it.does;
}
	return it.does;
	}
		it add_should_add_an_array_to_list()
	{before_add();
try
{
			int[3] arr = 1;
			LinkedList!(int) list = new LinkedList!(int)();

			list.add(arr);

			if(!(list.length == 3))
	{
		return it.doesnt;
	}

			if(!(list.peek() == arr[2]))
	{
		return it.doesnt;
	}

		}catch(Exception _exception_)
{
if (_exception_.msg != "Access Violation") { return it.doesnt; } return it.does;
}
	return it.does;
	}	done before_add() { }

	
		it peek_should_return_the_head()
	{before_peek();
try
{
			LinkedList!(int) list = new LinkedList!(int)();
			
			int item1 = 1;
			int item2 = 2;
			int item3 = 3;

			list.add(item1);
			list.add(item2);
			list.add(item3);

			if(!(list.peek() == item3))
	{
		return it.doesnt;
	}

		}catch(Exception _exception_)
{
if (_exception_.msg != "Access Violation") { return it.doesnt; } return it.does;
}
	return it.does;
	}
		it peek_should_return_the_item_at_index()
	{before_peek();
try
{
			LinkedList!(int) list = new LinkedList!(int)();
			
			int item1 = 1;
			int item2 = 2;
			int item3 = 3;

			list.add(item1);
			list.add(item2);
			list.add(item3);

			if(!(list.peekAt(0) == item3))
	{
		return it.doesnt;
	}

			if(!(list.peekAt(1) == item2))
	{
		return it.doesnt;
	}

			if(!(list.peekAt(2) == item1))
	{
		return it.doesnt;
	}

		}catch(Exception _exception_)
{
if (_exception_.msg != "Access Violation") { return it.doesnt; } return it.does;
}
	return it.does;
	}	done before_peek() { }

	
		it remove_should_remove_the_tail()
	{before_remove();
try
{
			LinkedList!(int) list = new LinkedList!(int)();
			int item = 1;
			list.add(item);
			
			if(!(list.remove() == item))
	{
		return it.doesnt;
	}

			if(!(list.length == 0))
	{
		return it.doesnt;
	}

		}catch(Exception _exception_)
{
if (_exception_.msg != "Access Violation") { return it.doesnt; } return it.does;
}
	return it.does;
	}
		it remove_should_remove_by_data()
	{before_remove();
try
{
			LinkedList!(int) list = new LinkedList!(int)();
			int item = 1;
			list.add(item);

			if(!(list.remove(item) == item))
	{
		return it.doesnt;
	}

			if(!(list.length == 0))
	{
		return it.doesnt;
	}

		}catch(Exception _exception_)
{
if (_exception_.msg != "Access Violation") { return it.doesnt; } return it.does;
}
	return it.does;
	}
		it remove_should_remove_at_index()
	{before_remove();
try
{
			LinkedList!(int) list = new LinkedList!(int)();
			
			int item1 = 1;
			int item2 = 2;
			int item3 = 3;

			list.add(item1);
			list.add(item2);
			list.add(item3);

			if(!(list.removeAt(2) == item1))
	{
		return it.doesnt;
	}

			if(!(list.length == 2))
	{
		return it.doesnt;
	}

			if(!(list.removeAt(1) == item2))
	{
		return it.doesnt;
	}

			if(!(list.length == 1))
	{
		return it.doesnt;
	}

			if(!(list.removeAt(0) == item3))
	{
		return it.doesnt;
	}

			if(!(list.length == 0))
	{
		return it.doesnt;
	}

		}catch(Exception _exception_)
{
if (_exception_.msg != "Access Violation") { return it.doesnt; } return it.does;
}
	return it.does;
	}	done before_remove() { }

	
		it clear_should_work_as_expected()
	{before_clear();
try
{
			LinkedList!(int) list = new LinkedList!(int)();

			list.add(1);
			list.add(2);
			list.add(3);

			list.clear();

			if(!(list.length == 0))
	{
		return it.doesnt;
	}

		}catch(Exception _exception_)
{
if (_exception_.msg != "Access Violation") { return it.doesnt; } return it.does;
}
	return it.does;
	}	done before_clear() { }

	
		it empty_should_work_as_expected()
	{before_empty();
try
{
			LinkedList!(int) list = new LinkedList!(int)();

			if(!(list.empty()))
	{
		return it.doesnt;
	}


			list.add(1);

			if(list.empty())
{ return it.doesnt; }


		}catch(Exception _exception_)
{
if (_exception_.msg != "Access Violation") { return it.doesnt; } return it.does;
}
	return it.does;
	}	done before_empty() { }

	
		it operations_should_peek_at_the_index()
	{before_operations();
try
{
			LinkedList!(int) list = new LinkedList!(int)();
			int entry = 1;
			list.add(entry);

			if(!(list[0] == entry))
	{
		return it.doesnt;
	}

		}catch(Exception _exception_)
{
if (_exception_.msg != "Access Violation") { return it.doesnt; } return it.does;
}
	return it.does;
	}	done before_operations() { }

	
		it array_should_return_an_array_of_the_list()
	{before_array();
try
{
			LinkedList!(int) list = new LinkedList!(int)();
			
			int entry1 = 1;
			int entry2 = 2;
			int entry3 = 3;

			list.add(entry1);
			list.add(entry2);
			list.add(entry3);

			int[] listArr = list.array();

			if(listArr is null)
{ return it.doesnt; }

			if(!(listArr[0] == entry1))
	{
		return it.doesnt;
	}

			if(!(listArr[1] == entry2))
	{
		return it.doesnt;
	}

			if(!(listArr[2] == entry3))
	{
		return it.doesnt;
	}

		}catch(Exception _exception_)
{
if (_exception_.msg != "Access Violation") { return it.doesnt; } return it.does;
}
	return it.does;
	}	done before_array() { }

	
		it duplication_should_work_as_expected()
	{before_duplication();
try
{
			LinkedList!(int) list = new LinkedList!(int)();
			int entry = 1;
			list.add(entry);

			LinkedList!(int) dupList = list.dup();

			if(dupList is null)
{ return it.doesnt; }

			if(!(dupList.peek() == entry))
	{
		return it.doesnt;
	}


		}catch(Exception _exception_)
{
if (_exception_.msg != "Access Violation") { return it.doesnt; } return it.does;
}
	return it.does;
	}	done before_duplication() { }

	
		it slicing_should_work_as_expected()
	{before_slicing();
try
{
			LinkedList!(int) list = new LinkedList!(int)();

			int entry1 = 1;
			int entry2 = 2; 
			int entry3 = 3;

			list.add(entry3);
			list.add(entry2);
			list.add(entry1);

			LinkedList!(int) sliceList = list.slice(0,2);

			if(sliceList is null)
{ return it.doesnt; }

			if(!(sliceList.length == 2))
	{
		return it.doesnt;
	}

			if(!(sliceList.remove() == entry3))
	{
		return it.doesnt;
	}

			if(!(sliceList.remove() == entry2))
	{
		return it.doesnt;
	}

		}catch(Exception _exception_)
{
if (_exception_.msg != "Access Violation") { return it.doesnt; } return it.does;
}
	return it.does;
	}	done before_slicing() { }

	
		it reverse_should_work_as_expected()
	{before_reverse();
try
{
			LinkedList!(int) list = new LinkedList!(int)();

			int entry1 = 1;
			int entry2 = 2; 
			int entry3 = 3;

			list.add(entry1);
			list.add(entry2);
			list.add(entry3);

			LinkedList!(int) revList = list.reverse();

			if(revList is null)
{ return it.doesnt; }

			if(!(revList.length == 3))
	{
		return it.doesnt;
	}

			if(!(revList.remove() == entry1))
	{
		return it.doesnt;
	}

			if(!(revList.remove() == entry2))
	{
		return it.doesnt;
	}

			if(!(revList.remove() == entry3))
	{
		return it.doesnt;
	}

		}catch(Exception _exception_)
{
if (_exception_.msg != "Access Violation") { return it.doesnt; } return it.does;
}
	return it.does;
	}	done before_reverse() { }
	
	
		it string_should_work_as_expected()
	{before_string();
try
{
			LinkedList!(int) list = new LinkedList!(int)();
			
			list.add(1);
			list.add(2);
			list.add(3);

			if(!(list.toString() == "[1, 2, 3]"))
	{
		return it.doesnt;
	}

		}catch(Exception _exception_)
{
if (_exception_.msg != "Access Violation") { return it.doesnt; } return it.does;
}
	return it.does;
	}	done before_string() { }
done before() { }

this() { before(); }


	static void test()
	{
	LinkedListTester tester = new LinkedListTester();

	Test test = new Test("LinkedList");

	it result;

	test.logSubset("creation");

	tester = new LinkedListTester();

	result = tester.creation_should_work_as_expected();
		test.logResult(result, "creation should work as expected", "8");

	test.logSubset("add");

	tester = new LinkedListTester();

	result = tester.add_should_add_item_to_the_head();
		test.logResult(result, "add should add item to the head", "16");

	tester = new LinkedListTester();

	result = tester.add_should_an_a_list_to_list();
		test.logResult(result, "add should an a list to list", "7");

	tester = new LinkedListTester();

	result = tester.add_should_add_an_array_to_list();
		test.logResult(result, "add should add an array to list", "12");

	test.logSubset("peek");

	tester = new LinkedListTester();

	result = tester.peek_should_return_the_head();
		test.logResult(result, "peek should return the head", "22");

	tester = new LinkedListTester();

	result = tester.peek_should_return_the_item_at_index();
		test.logResult(result, "peek should return the item at index", "29");

	test.logSubset("remove");

	tester = new LinkedListTester();

	result = tester.remove_should_remove_the_tail();
		test.logResult(result, "remove should remove the tail", "34");

	tester = new LinkedListTester();

	result = tester.remove_should_remove_by_data();
		test.logResult(result, "remove should remove by data", "42");

	tester = new LinkedListTester();

	result = tester.remove_should_remove_at_index();
		test.logResult(result, "remove should remove at index", "47");

	test.logSubset("clear");

	tester = new LinkedListTester();

	result = tester.clear_should_work_as_expected();
		test.logResult(result, "clear should work as expected", "55");

	test.logSubset("empty");

	tester = new LinkedListTester();

	result = tester.empty_should_work_as_expected();
		test.logResult(result, "empty should work as expected", "60");

	test.logSubset("operations");

	tester = new LinkedListTester();

	result = tester.operations_should_peek_at_the_index();
		test.logResult(result, "operations should peek at the index", "9");

	test.logSubset("array");

	tester = new LinkedListTester();

	result = tester.array_should_return_an_array_of_the_list();
		test.logResult(result, "array should return an array of the list", "14");

	test.logSubset("duplication");

	tester = new LinkedListTester();

	result = tester.duplication_should_work_as_expected();
		test.logResult(result, "duplication should work as expected", "19");

	test.logSubset("slicing");

	tester = new LinkedListTester();

	result = tester.slicing_should_work_as_expected();
		test.logResult(result, "slicing should work as expected", "26");

	test.logSubset("reverse");

	tester = new LinkedListTester();

	result = tester.reverse_should_work_as_expected();
		test.logResult(result, "reverse should work as expected", "31");

	test.logSubset("string");

	tester = new LinkedListTester();

	result = tester.string_should_work_as_expected();
		test.logResult(result, "string should work as expected", "36");


	}
}import utils.stack;

class StackTester
{
	
		it creation_should_create_with_no_size()
	{before_creation();
try
{
			Stack!(int) stack = new Stack!(int)();
			if(stack is null)
{ return it.doesnt; }

			if(!(stack.length == 0))
	{
		return it.doesnt;
	}

		}catch(Exception _exception_)
{
if (_exception_.msg != "Access Violation") { return it.doesnt; } return it.does;
}
	return it.does;
	}
		it creation_should_create_with_size()
	{before_creation();
try
{
			Stack!(int) stack = new Stack!(int)(10);
			if(stack is null)
{ return it.doesnt; }

			if(!(stack.length == 0))
	{
		return it.doesnt;
	}

		}catch(Exception _exception_)
{
if (_exception_.msg != "Access Violation") { return it.doesnt; } return it.does;
}
	return it.does;
	}
		it creation_should_create_with_array()
	{before_creation();
try
{
			int[3] arr = 1;
			Stack!(int) stack = new Stack!(int)(arr);
			if(stack is null)
{ return it.doesnt; }

			if(!(stack.length == 3))
	{
		return it.doesnt;
	}

		}catch(Exception _exception_)
{
if (_exception_.msg != "Access Violation") { return it.doesnt; } return it.does;
}
	return it.does;
	}	done before_creation() { }

	
		it duplicate_should_work_as_expected()
	{before_duplicate();
try
{
			Stack!(int) stack = new Stack!(int)();
			int item1 = 1;
			int item2 = 2; 
			int item3 = 3; 

			stack.push(item1);
			stack.push(item2);
			stack.push(item3);

			Stack!(int) dupStack = stack.dup();

			if(!(dupStack.length == 3))
	{
		return it.doesnt;
	}

		}catch(Exception _exception_)
{
if (_exception_.msg != "Access Violation") { return it.doesnt; } return it.does;
}
	return it.does;
	}	done before_duplicate() { }

	
		it pop_should_pop_items_in_correct_order()
	{before_pop();
try
{
			Stack!(int) stack = new Stack!(int)();
			int item1 = 1;
			int item2 = 2;
			int item3 = 3;

			stack.push(item1);
			stack.push(item2);
			stack.push(item3);
			
			if(!(stack.length == 3))
	{
		return it.doesnt;
	}

			if(!(stack.pop == item3))
	{
		return it.doesnt;
	}

			if(!(stack.length == 2))
	{
		return it.doesnt;
	}

			if(!(stack.pop == item2))
	{
		return it.doesnt;
	}

			if(!(stack.length == 1))
	{
		return it.doesnt;
	}

			if(!(stack.pop == item1))
	{
		return it.doesnt;
	}

			if(!(stack.length == 0))
	{
		return it.doesnt;
	}

		}catch(Exception _exception_)
{
if (_exception_.msg != "Access Violation") { return it.doesnt; } return it.does;
}
	return it.does;
	}	done before_pop() { }

	
		it push_should_push_an_item_onto_empty_stack()
	{before_push();
try
{
			Stack!(int) stack = new Stack!(int)();
			int item = 69;
			stack.push(item);
			if(!(stack.length == 1))
	{
		return it.doesnt;
	}

			if(!(stack.pop == item))
	{
		return it.doesnt;
	}

		}catch(Exception _exception_)
{
if (_exception_.msg != "Access Violation") { return it.doesnt; } return it.does;
}
	return it.does;
	}	done before_push() { }
done before() { }

this() { before(); }


	static void test()
	{
	StackTester tester = new StackTester();

	Test test = new Test("Stack");

	it result;

	test.logSubset("creation");

	tester = new StackTester();

	result = tester.creation_should_create_with_no_size();
		test.logResult(result, "creation should create with no size", "8");

	tester = new StackTester();

	result = tester.creation_should_create_with_size();
		test.logResult(result, "creation should create with size", "16");

	tester = new StackTester();

	result = tester.creation_should_create_with_array();
		test.logResult(result, "creation should create with array", "7");

	test.logSubset("duplicate");

	tester = new StackTester();

	result = tester.duplicate_should_work_as_expected();
		test.logResult(result, "duplicate should work as expected", "12");

	test.logSubset("pop");

	tester = new StackTester();

	result = tester.pop_should_pop_items_in_correct_order();
		test.logResult(result, "pop should pop items in correct order", "22");

	test.logSubset("push");

	tester = new StackTester();

	result = tester.push_should_push_an_item_onto_empty_stack();
		test.logResult(result, "push should push an item onto empty stack", "29");


	}
}
class Tests
{
	static void testApplication()
	{
		ApplicationTester.test();
	}

	static void testName()
	{
		NameTester.test();
	}

	static void testDate()
	{
		DateTester.test();
	}

	static void testException()
	{
		ExceptionTester.test();
	}

	static void testRandom()
	{
		RandomTester.test();
	}

	static void testNextLong()
	{
		NextLongTester.test();
	}

	static void testNextBoolean()
	{
		NextBooleanTester.test();
	}

	static void testNextDouble()
	{
		NextDoubleTester.test();
	}

	static void testNextFloat()
	{
		NextFloatTester.test();
	}

	static void testChoose()
	{
		ChooseTester.test();
	}

	static void testRegex()
	{
		RegexTester.test();
	}

	static void testString()
	{
		StringTester.test();
	}

	static void testTime()
	{
		TimeTester.test();
	}

	static void testUnicode()
	{
		UnicodeTester.test();
	}

	static void testUtil()
	{
		UtilTester.test();
	}

	static void testStringTemplates()
	{
		StringTemplatesTester.test();
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

	static void testFibonacciHeap()
	{
		FibonacciHeapTester.test();
	}

	static void testRemove()
	{
		RemoveTester.test();
	}

	static void testLength()
	{
		LengthTester.test();
	}

	static void testClear()
	{
		ClearTester.test();
	}

	static void testEmpty()
	{
		EmptyTester.test();
	}

	static void testPriorityQueue()
	{
		PriorityQueueTester.test();
	}

	static void testRemove()
	{
		RemoveTester.test();
	}

	static void testLength()
	{
		LengthTester.test();
	}

	static void testClear()
	{
		ClearTester.test();
	}

	static void testEmpty()
	{
		EmptyTester.test();
	}

	static void testLinkedList()
	{
		LinkedListTester.test();
	}

	static void testStack()
	{
		StackTester.test();
	}

	static void testAll()
	{
		testApplication();
		testName();
		testDate();
		testException();
		testRandom();
		testNextLong();
		testNextBoolean();
		testNextDouble();
		testNextFloat();
		testChoose();
		testRegex();
		testString();
		testTime();
		testUnicode();
		testUtil();
		testStringTemplates();
		testDigest();
		testMD5();
		testSHA1();
		testSHA224();
		testSHA256();
		testFibonacciHeap();
		testRemove();
		testLength();
		testClear();
		testEmpty();
		testPriorityQueue();
		testRemove();
		testLength();
		testClear();
		testEmpty();
		testLinkedList();
		testStack();
		Test.done();
	}
}



 testApplication() {
		ApplicationTester.test();
	}

	static void testUtil() {
		UtilTester.test();
	}

	static void testRandom() {
		RandomTester.test();
	}

	static void testUnicode() {
		UnicodeTester.test();
	}

	static void testException() {
		ExceptionTester.test();
	}

	static void testDate() {
		DateTester.test();
	}

	static void testLinkedList() {
		LinkedListTester.test();
	}

	static void testPriorityQueue() {
		PriorityQueueTester.test();
	}

	static void testStack() {
		StackTester.test();
	}

	static void testFibonacciHeap() {
		FibonacciHeapTester.test();
	}

	static void testAll() {
		testSHA224();
		testSHA256();
		testDigest();
		testMD5();
		testSHA1();
		testTime();
		testRegex();
		testString();
		testApplication();
		testUtil();
		testRandom();
		testUnicode();
		testException();
		testDate();
		testLinkedList();
		testPriorityQueue();
		testStack();
		testFibonacciHeap();
		Test.done();
	}
}+/

