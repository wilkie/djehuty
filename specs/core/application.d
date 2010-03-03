module specs.core.application;

import testing.support;
import core.application;

describe application() {
	describe creation() {
		 it should_not_create_inside_another_application {
			class MyApplication : Application {}
			shouldThrow();
			MyApplication app = new MyApplication();
		 }
	}

	describe name() {
		it should_get_the_name {
			should(Djehuty.application().name() == "DjehutyTester");
		}
	}
}
