import djehuty;

import specs.test;

class DjehutyTester : Application {
	static this() { new DjehutyTester(); }
	
	void onApplicationStart() {
		Tests.testAll();
	}
}