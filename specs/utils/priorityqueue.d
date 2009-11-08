module specs.utils.priorityqueue;

import utils.priorityqueue;

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

	describe remove() {
		it should_remove_the_first_item_in_min_heap() {
			auto queue = new PriorityQueue!(int, MinHeap);
			queue.add(10);
			queue.add(4);
			queue.add(15);
			should(queue.length == 3);
			should(queue.peek() == 4);
		}

		it should_remove_the_first_item_in_max_heap() {
			auto queue = new PriorityQueue!(int, MaxHeap);
			queue.add(10);
			queue.add(4);
			queue.add(15);
			should(queue.length == 3);
			should(queue.peek() == 15);
		}
	}

	describe length() {
		it should_be_zero_for_an_empty_list() {
			auto queue = new PriorityQueue!(int);
			should(queue.empty);
			should(queue.length == 0);
		}
	}
}
