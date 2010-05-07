module specs.runtime.array;

import io.console;

import math.random;

describe runtime2() {
	describe _adCmp() {
		it should_handle_empty_arrays() {
			int[] empty = [];
			shouldNot(empty == [1,2,3]);
		}
	}

	describe _adSort {
		it should_sort_simple_int_arrays {
			int[] sorted = [2,1,3].sort;
			should(sorted == [1,2,3]);
		}

		it should_sort_random_arrays {
			int[500] foo;
			auto r = new Random();

			foreach(ref element; foo) {
				element = cast(int)r.next();
			}

			foo.sort;
			int cur = foo[0];
			foreach(element; foo) {
				// Ensure it is ascending
				should(element >= cur);
			}
		}

		it should_sort_simple_double_arrays {
			double[] sorted = [0.0, 0.8, 0.4, 0.2, 0.9].sort;
			should(sorted == [0.0,0.2,0.4,0.8,0.9]);
		}
	}
}
