import djehuty;

import io.console;

import spec.specification;
import spec.itemspecification;
import spec.packagespecification;
import spec.modulespecification;
import spec.test;

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
	void onApplicationStart() {
		options = new Opts();

		if (options.modules is null) {
			Console.putln();

			// Go through every package
			foreach(pack; Specification) {
				_testPackage(pack);
			}
		}
	}

private:

	void _testPackage(PackageSpecification ps, string prior = "") {
		foreach(PackageSpecification pack; ps) {
			_testPackage(pack, prior ~ ps.name ~ ".");
		}

		foreach(ModuleSpecification mod; ps) {
			_testModule(mod, prior ~ ps.name);
		}
	}

	void _testModule(ModuleSpecification ms, string packName = "") {
		Console.put(packName ~ "." ~ ms.name, " : ");

		// Keep track of success over the module
		int numFailures;
		int numSuccesses;
		foreach(item; ms) {
			foreach(feature; item) {
				auto tester = new Test(item, feature);
				Console.putln("Testing", " : ", item.name, " ", feature);
				tester.run();
				if (tester.failures > 0) {
					Console.forecolor = Color.Red;
					if (numFailures == 0) {
						Console.putln("FAILED ");
					}
					Console.putln(" ".times((packName ~ "." ~ ms.name).length), " : ", item.name, " ", feature);
				}
				else {
				}
				numFailures += tester.failures;
				numSuccesses += tester.successes;
			}
		}
		if (numFailures > 0) {
			Console.forecolor = Color.Gray;
			Console.put(packName ~ "." ~ ms.name, " : ");
			Console.forecolor = Color.Red;
			Console.put("FAILED ");
			
			Console.forecolor = Color.Gray;
			Console.putln(numSuccesses, " / ", numSuccesses+numFailures);
		}
		else {
			Console.forecolor = Color.Green;
			Console.put("PASSED ");

			Console.forecolor = Color.Gray;
			Console.putln("all ", numSuccesses, " tests");
		}
	}

	Opts options;
}

int main() {
	auto app = new DjehutyTester();
	app.run();
	return 0;
}
