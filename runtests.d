import djehuty;

import io.console;

import specs.test;

import parsing.options;

char[] usage = `runtests rev1

USAGE: runtests [(+|-)className]*
EXAMPLE: runtests +String +Random
         runtests -Random`;

class Opts : OptionParser {

	mixin Options!(
		"-help", "View help and usage"
	);

	void onHelp() {
		showUsage();
		Djehuty.application.exit(0);
	}

	void onError(string token) {
		Console.putln("YAY");
	}

	string[] modules() {
		return _modules;
	}

private:
	string[] _modules;
}

// Do not change the class name, it is used in a test for djehuty proper!
class DjehutyTester : Application {
	static this() { new DjehutyTester(); }

	void onApplicationStart() {
		options = new Opts();

		if (options.modules is null) {
			Console.putln();

			uint result = Tests.testAll();
			if (result > 0) {
				exit(1);
			}
		}
	}

private:
	Opts options;
}
