module specs.data.priorityqueue;

import data.fibonacci;
import data.heap;

import math.random;

describe fibonacciHeap() {
	describe creation() {
		it should_work_as_expected() {
			FibonacciHeap!(int) queue = new FibonacciHeap!(int)();
			shouldNot(queue is null);
			should(queue.length == 0);
		}
	}

	describe add() {
		it should_add_an_item_to_an_empty_list() {
			FibonacciHeap!(int) queue = new FibonacciHeap!(int)();
			int item = 42;
			queue.add(item);
			should(queue.length == 1);
			should(queue.peek() == item);
		}
	}

	describe peek() {
		it should_return_the_first_item_in_min_heap() {
			auto queue = new FibonacciHeap!(int, MinHeap);
			queue.add(10);
			queue.add(4);
			queue.add(15);
			should(queue.length == 3);
			should(queue.peek() == 4);
		}

		it should_return_the_first_item_in_max_heap() {
			auto queue = new FibonacciHeap!(int, MaxHeap);
			queue.add(10);
			queue.add(4);
			queue.add(15);
			should(queue.length == 3);
			should(queue.peek() == 15);
		}

		it should_handle_a_heavy_workload() {
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

			should(queue.peek() == min);
			int foo;
			int last = queue.peek();

			while (!queue.empty()) {
				foo = queue.remove();
				should(foo >= last);
				last = foo;
			}

		}
	}

	describe remove() {
		it should_remove_the_first_item_in_min_heap() {
			auto queue = new FibonacciHeap!(int, MinHeap);
			queue.add(10);
			queue.add(4);
			queue.add(15);
			should(queue.length == 3);
			should(queue.remove() == 4);
		}

		it should_remove_the_first_item_in_max_heap() {
			auto queue = new FibonacciHeap!(int, MaxHeap);
			queue.add(10);
			queue.add(4);
			queue.add(15);
			should(queue.length == 3);
			should(queue.remove() == 15);
		}
	}

	describe length() {
		it should_be_zero_for_an_empty_list() {
			auto queue = new FibonacciHeap!(int);
			should(queue.empty);
			should(queue.length == 0);
		}
	}

	describe clear() {
		it should_result_in_an_empty_list() {
			auto queue = new FibonacciHeap!(int);
			queue.add(15);
			queue.add(10);
			queue.add(24);

			shouldNot(queue.length == 0);
			shouldNot(queue.empty());

			queue.clear();
			should(queue.length == 0);
			should(queue.empty());
		}
	}

	describe empty() {
		it should_be_true_when_the_list_is_empty() {
			auto queue = new FibonacciHeap!(int);
			queue.add(10);
			shouldNot(queue.empty());
			queue.remove();
			should(queue.empty());
		}

		it should_be_true_for_a_new_list() {
			auto queue = new FibonacciHeap!(int);
			should(queue.empty());
		}
	}
}
