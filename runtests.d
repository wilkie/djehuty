import djehuty;

import io.console;

import specs.test;

class DjehutyTester : Application {
	static this() { new DjehutyTester(); }

	void onApplicationStart() {
		Console.putln();

		uint result = Tests.testAll();
		if (result > 0) {
			exit(1);
		}
	}
}
