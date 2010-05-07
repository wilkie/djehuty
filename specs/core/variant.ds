module specs.core.variant;

import testing.support;

import core.variant;

describe variant() {
	describe initial_state() {
		it should_be_null() {
			Variant var;
			should(var.type == Type.Reference);
			should(var.to!(Object) is null);
		}
	}

	describe assignment() {
		it should_handle_integer_literals() {
			Variant var = 2;
			should(var == 2);
			should(var.to!(int) == 2);
		}

		it should_handle_reassignment() {
			Variant var = 2;
			var = 3;
			should(var == 3);
			var = "foo";
			should(var == "foo");
		}

		it should_handle_object_references() {
			Object foo = new Object();
			Variant var = foo;
			should(var == foo);
		}

		it should_handle_float_literals() {
			Variant var = 0.5;
			should(var == 0.5);
			should(var.to!(float) == 0.5);
		}
	}

	describe comparison() {
		it should_handle_int() {
			int a = 2;
			Variant var = a;
			should(var == a);
			should(var == 2);
		}

		it should_handle_float() {
			float a = 1.23;
			Variant var = a;
			should(var == a);
		}

		it should_handle_string() {
			string a = "hello";
			Variant var = a;
			should(var == a);
			should(var == "hello");
		}
	}
}
