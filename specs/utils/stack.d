module specs.utils.stack;

import utils.stack;

describe stack() {
	describe creation() {
		it should_create_with_no_size() {
			Stack!(int) stack = new Stack!(int)();
			shouldNot(stack is null);
			should(stack.length == 0);
		}

		it should_create_with_size() {
			Stack!(int) stack = new Stack!(int)(10);
			shouldNot(stack is null);
			should(stack.length == 0);
		}

		it should_create_with_array() {
			int[3] arr = 1;
			Stack!(int) stack = new Stack!(int)(arr);
			shouldNot(stack is null);
			should(stack.length == 3);
		}
	}

	describe duplicate() {
		it should_work_as_expected() {
			Stack!(int) stack = new Stack!(int)();
			int item1 = 1;
			int item2 = 2; 
			int item3 = 3; 

			stack.push(item1);
			stack.push(item2);
			stack.push(item3);

			Stack!(int) dupStack = stack.dup();

			should(dupStack.length == 3);
		}
	}

	describe pop() {
		it should_pop_items_in_correct_order() {
			Stack!(int) stack = new Stack!(int)();
			int item1 = 1;
			int item2 = 2;
			int item3 = 3;

			stack.push(item1);
			stack.push(item2);
			stack.push(item3);
			
			should(stack.length == 3);
			should(stack.pop == item3);
			should(stack.length == 2);
			should(stack.pop == item2);
			should(stack.length == 1);
			should(stack.pop == item1);
			should(stack.length == 0);
		}
	}

	describe push() {
		it should_push_an_item_onto_empty_stack() {
			Stack!(int) stack = new Stack!(int)();
			int item = 69;
			stack.push(item);
			should(stack.length == 1);
			should(stack.pop == item);
		}
	}
}
