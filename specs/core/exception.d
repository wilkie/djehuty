module specs.core.exception;

import testing.support;

import core.exception;

describe exception() {
	describe FileNotFound() {
		it should_work_with_no_explanation() {
			shouldThrow("File Not Found");
			throw new FileNotFound();
		}

		it should_work_with_string_object() {
			shouldThrow("File Not Found: some_file");
			throw new FileNotFound(new String("some_file"));
		}

		it should_work_with_plain_string() {
			shouldThrow("File Not Found: some_file");
			throw new FileNotFound("some_file");
		}
	}

	describe DirectoryNotFound() {
		it should_work_with_no_explanation() {
			shouldThrow("Directory Not Found");
			throw new DirectoryNotFound();
		}

		it should_work_with_string_object() {
			shouldThrow("Directory Not Found: some_dir");
			throw new DirectoryNotFound(new String("some_dir"));
		}

		it should_work_with_plain_string() {
			shouldThrow("Directory Not Found: some_dir");
			throw new DirectoryNotFound("some_dir");
		}
	}

	describe OutOfElements() {
		it should_work_with_no_explanation() {
			shouldThrow("Out of Elements");
			throw new OutOfElements();
		}

		it should_work_with_string_object() {
			shouldThrow("Out of Elements in SomeClass");
			throw new OutOfElements(new String("SomeClass"));
		}

		it should_work_with_plain_string() {
			shouldThrow("Out of Elements in SomeClass");
			throw new OutOfElements("SomeClass");
		}
	}

	describe OutOfBounds() {
		it should_work_with_no_explanation() {
			shouldThrow("Out of Bounds");
			throw new OutOfBounds();
		}

		it should_work_with_string_object() {
			shouldThrow("Out of Bounds in SomeClass");
			throw new OutOfBounds(new String("SomeClass"));
		}

		it should_work_with_plain_string() {
			shouldThrow("Out of Bounds in SomeClass");
			throw new OutOfBounds("SomeClass");
		}
	}

	describe ElementNotFound() {
		it should_work_with_no_explanation() {
			shouldThrow("Element Not Found");
			throw new ElementNotFound();
		}

		it should_work_with_string_object() {
			shouldThrow("Element Not Found in SomeClass");
			throw new ElementNotFound(new String("SomeClass"));
		}

		it should_work_with_plain_string() {
			shouldThrow("Element Not Found in SomeClass");
			throw new ElementNotFound("SomeClass");
		}
	}

}

