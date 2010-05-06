module specs.runtime.array;

import io.console;

describe runtime() {
	describe _adCmp() {
		it should_handle_empty_arrays() {
			int[] empty = [];
			shouldNot(empty == [1,2,3]);
		}
	}
}
