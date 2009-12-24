module spec.utils.linkedlist;

import utils.linkedlist;

describe linkedList() {
	describe creation() {
		it should_work_as_expected() {
			LinkedList!(int) list = new LinkedList!(int)();
			shouldNot(list is null);
			should(list.length == 0);
		}
	}

	describe add() {
		it should_add_item_to_the_head() {
			LinkedList!(int) list = new LinkedList!(int)();
			int item = 42;
			list.add(item);
			
			should(list.length == 1);
			should(list.peek() == item);
		}

		it should_an_a_list_to_list() {
			LinkedList!(int) list1 = new LinkedList!(int)();
			LinkedList!(int) list2 = new LinkedList!(int)();
			int item = 33;

			list2.add(item);
			list1.add(list2);
			
			should(list1.length == 1);
			should(list1.peek() == item);

		}

		it should_add_an_array_to_list() {
			int[3] arr = 1;
			LinkedList!(int) list = new LinkedList!(int)();

			list.add(arr);

			should(list.length == 3);
			should(list.peek() == arr[2]);
		}
	}

	describe peek() {
		it should_return_the_head() {
			LinkedList!(int) list = new LinkedList!(int)();
			
			int item1 = 1;
			int item2 = 2;
			int item3 = 3;

			list.add(item1);
			list.add(item2);
			list.add(item3);

			should(list.peek() == item3);
		}

		it should_return_the_item_at_index() {
			LinkedList!(int) list = new LinkedList!(int)();
			
			int item1 = 1;
			int item2 = 2;
			int item3 = 3;

			list.add(item1);
			list.add(item2);
			list.add(item3);

			should(list.peekAt(0) == item3);
			should(list.peekAt(1) == item2);
			should(list.peekAt(2) == item1);
		}
	}

	describe remove() {
		it should_remove_the_tail() {
			LinkedList!(int) list = new LinkedList!(int)();
			int item = 1;
			list.add(item);
			
			should(list.remove() == item);
			should(list.length == 0);
		}

		it should_remove_by_data() {
			LinkedList!(int) list = new LinkedList!(int)();
			int item = 1;
			list.add(item);

			should(list.remove(item) == item);
			should(list.length == 0);
		}

		it should_remove_at_index(){
			LinkedList!(int) list = new LinkedList!(int)();
			
			int item1 = 1;
			int item2 = 2;
			int item3 = 3;

			list.add(item1);
			list.add(item2);
			list.add(item3);

			should(list.removeAt(2) == item1);
			should(list.length == 2);
			should(list.removeAt(1) == item2);
			should(list.length == 1);
			should(list.removeAt(0) == item3);
			should(list.length == 0);
		}
	}

	describe clear() {
		it should_work_as_expected() {
			LinkedList!(int) list = new LinkedList!(int)();

			list.add(1);
			list.add(2);
			list.add(3);

			list.clear();

			should(list.length == 0);
		}
	}

	describe empty() {
		it should_work_as_expected() {
			LinkedList!(int) list = new LinkedList!(int)();

			should(list.empty());

			list.add(1);

			should(!list.empty());

		}
	}
}
