module specs.utils.priorityqueue;

import utils.priorityqueue;

import core.random;

describe priorityQueue() {
	describe creation() {
		it should_work_as_expected() {
			PriorityQueue!(int) queue = new PriorityQueue!(int)();
			shouldNot(queue is null);
			should(queue.length == 0);
		}
	}

	describe add() {
		it should_add_an_item_to_an_empty_list() {
			PriorityQueue!(int) queue = new PriorityQueue!(int)();
			int item = 42;
			queue.add(item);
			should(queue.length == 1);
			should(queue.peek() == item);
		}
	}

	describe peek() {
		it should_return_the_first_item_in_min_heap() {
			auto queue = new PriorityQueue!(int, MinHeap);
			queue.add(10);
			queue.add(4);
			queue.add(15);
			should(queue.length == 3);
			should(queue.peek() == 4);
		}

		it should_return_the_first_item_in_max_heap() {
			auto queue = new PriorityQueue!(int, MaxHeap);
			queue.add(10);
			queue.add(4);
			queue.add(15);
			should(queue.length == 3);
			should(queue.peek() == 15);
		}

		it should_handle_a_heavy_workload() {
			auto queue = new PriorityQueue!(int, MinHeap);
			int min;
			int val;

			Random r = new Random();
			val = r.next();
			queue.add(val);
			min = val;

			for(int i; i < 10000; i++) {
				val = r.next();
				queue.add(val);
				if (val < min) {
					min = val;
				}
			}			

			should(queue.peek() == min);
		}
	}

	describe remove() {
		it should_remove_the_first_item_in_min_heap() {
			auto queue = new PriorityQueue!(int, MinHeap);
			queue.add(10);
			queue.add(4);
			queue.add(15);
			should(queue.length == 3);
			should(queue.remove() == 4);
		}

		it should_remove_the_first_item_in_max_heap() {
			auto queue = new PriorityQueue!(int, MaxHeap);
			queue.add(10);
			queue.add(4);
			queue.add(15);
			should(queue.length == 3);
			should(queue.remove() == 15);
		}
	}

	describe length() {
		it should_be_zero_for_an_empty_list() {
			auto queue = new PriorityQueue!(int);
			should(queue.empty);
			should(queue.length == 0);
		}
	}

	describe clear() {
		it should_result_in_an_empty_list() {
			auto queue = new PriorityQueue!(int);
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
			auto queue = new PriorityQueue!(int);
			queue.add(10);
			shouldNot(queue.empty());
			queue.remove();
			should(queue.empty());
		}

		it should_be_true_for_a_new_list() {
			auto queue = new PriorityQueue!(int);
			should(queue.empty());
		}
	}
}
