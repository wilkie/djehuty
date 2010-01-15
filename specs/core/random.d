module specs.core.random;

import testing.support;

import core.random;

describe random() {
	const uint SEED = 12345678;
	const uint REPEATS = 10000000;

	describe creation() {
		it should_have_sane_defaults() {
			auto r = new Random();
			should(r.seed >= 0);
		}

		it should_not_reuse_a_seed() {
			auto a = new Random();
			auto b = new Random();
			shouldNot(a.seed == b.seed);
		}

		it should_use_the_given_seed() {
			auto r = new Random(SEED);
			should(r.seed == SEED);
		}
	}

	describe state() {
		it should_be_reproducible() {
			auto a = new Random(SEED);
			auto b = new Random(SEED);
			should(a.next() == b.next());
		}
	}

	describe seed() {
		it should_set_and_get_the_seed() {
			auto r = new Random();
			r.seed = SEED;
			should(r.seed == SEED);
		}
	}

	// TODO: Statistical tests should be implemented for all the "next" methods.

	describe next() {
		it should_not_be_stuck() {
			auto r = new Random();
			shouldNot(r.next() == r.next());
		}

		it should_return_zero_if_upper_bound_is_zero() {
			auto r = new Random();
			should(r.next(0) == 0);
		}

		it should_return_a_nonnegative_value_less_than_upper_bound() {
			auto r = new Random();
			uint v;
			uint upper = 1;
			for (uint i = 0; i < REPEATS; i++) {
				v = r.next(upper);
				should(v >= 0);
				should(v < upper);
				upper += i;
			}
		}

		it should_return_greatest_bound_if_bounds_overlap() {
			auto r = new Random();
			should(r.next(0, 0) == 0);
			should(r.next(123, 123) == 123);
			should(r.next(-123, -123) == -123);
			should(r.next(123, -123) == 123);
		}

		it should_return_a_value_within_bounds() {
			auto r = new Random();
			int v;
			int lower = 0;
			int upper = 1;
			for (uint i = 0; i < REPEATS; i++) {
				v = r.next(lower, upper);
				should(v >= lower);
				should(v < upper);
				lower -= 12;
				upper += 3;
			}
		}
	}

	describe nextLong() {
		it should_not_be_stuck() {
			auto r = new Random();
			shouldNot(r.nextLong() == r.nextLong());
		}

		it should_return_zero_if_upper_bound_is_zero() {
			auto r = new Random();
			should(r.nextLong(0) == 0);
		}

		it should_return_a_nonnegative_value_less_than_upper_bound() {
			auto r = new Random();
			ulong v;
			ulong upper = 1;
			for (uint i = 0; i < REPEATS; i++) {
				v = r.nextLong(upper);
				should(v >= 0);
				should(v < upper);
				upper += i;
			}
		}

		it should_return_greatest_bound_if_bounds_overlap() {
			auto r = new Random();
			should(r.nextLong(0, 0) == 0);
			should(r.nextLong(123, 123) == 123);
			should(r.nextLong(-123, -123) == -123);
			should(r.nextLong(123, -123) == 123);
		}

		it should_return_a_value_within_bounds() {
			auto r = new Random();
			long v;
			long lower = 0;
			long upper = 1;
			for (uint i = 0; i < REPEATS; i++) {
				v = r.nextLong(lower, upper);
				should(v >= lower);
				should(v < upper);
				lower -= i;
				upper += 2*i;
			}
		}
	}

	describe nextBoolean() {
		it should_return_a_boolean() {
			auto r = new Random();
			bool to_be = r.nextBoolean();
			should(to_be || !to_be);
		}
	}

	describe nextDouble() {
		it should_return_a_value_between_0_and_1() {
			auto r = new Random();
			double v;
			for (uint i = 0; i < REPEATS; i++) {
				v = r.nextDouble();
				should(v >= 0.0);
				should(v <= 1.0);
			}
		}
	}

	describe nextFloat() {
		it should_return_a_value_between_0_and_1() {
			auto r = new Random();
			double v;
			for (uint i = 0; i < REPEATS; i++) {
				v = r.nextFloat();
				should(v >= 0.0);
				should(v <= 1.0);
			}
		}
	}

	describe choose() {
		// TODO: Test needed for choosing from something not iterable.
		// TODO: Test needed for choosing from an empty list.

		it should_return_the_item_given_one() {
			auto r = new Random();
			uint[] arr = [1234];
			should(r.choose(arr) == 1234);
		}

		it should_work_for_arrays() {
			auto r = new Random();
			uint[] arr = [2, 5, 6, 9, 10, 13];
			uint v;
			for (uint i = 0; i < REPEATS; i++) {
				v = r.choose(arr);
				shouldNot(member(v, arr) is null);
			}
		}

		it should_work_for_lists() {
			auto r = new Random();
			List!(char) lst = new List!(char)(['a', 'e', 'i', 'o', 'u']);
			char v;
			for (uint i = 0; i < REPEATS; i++) {
				v = r.choose(lst);
				shouldNot(member(v, lst) is null);
			}
		}
	}
}

