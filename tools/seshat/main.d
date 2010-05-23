import djehuty;

import io.console;

import seshat.options;
import seshat.dependencylist;

import data.list;
import io.file;

class Seshat : Application {
	override void onApplicationStart() {
		// Parse options
		_options = new Opts();

		if (_options.path is null) {
			return;
		}

		// 0. Get dependencies
		_list = new DependencyList(_options.path);

		// 1. Build Dependencies
		auto linkingList = new List!(string);

		foreach(mod; _list) {
			// Compile each module in the list if necessary
			if (mod.length > "binding/".length) {
				if (mod[0..8] == "binding/") {
					string bindpath = mod[8..$-2];
					int pos = bindpath.find("/");
					if (pos == -1) {
						if (!linkingList.contains(bindpath)) {
							linkingList.add(bindpath);
						}
					}
					else {
						bindpath = bindpath[0..pos];
						auto f = File.open("binding/" ~ bindpath ~ "/link.txt");
						if (f is null) {
							if (!linkingList.contains(bindpath)) {
								linkingList.add(bindpath);
							}
						}
						else {
							foreach(line; f) {
								if (!linkingList.contains(line)) {
									linkingList.add(line);
								}
							}
						}
					}
				}
			}
		}

		// 2. Verification (Link modules that have tests with front end)

		// 2a. Build Sobek component and run

		// 3. Link
		string moduleObject;
		string moduleExecutable;
		version(LDC) {
			moduleObject = _options.path[0..$-2] ~ ".o";
			moduleExecutable = _options.path[0..$-2];
			string ldcCommand = "ldc -of" ~ moduleExecutable ~ " " ~ moduleObject;
			foreach(mod; _list) {
				ldcCommand ~= " " ~ mod[0..$-2] ~ ".o";
			}
			foreach(link; linkingList) {
				ldcCommand ~= " -L-l" ~ link;
			}
			ldcCommand ~= " -L-lpthread -L-lrt";
			putln(ldcCommand);
			System.execute(ldcCommand);
		}

		foreach(link; linkingList) {
			putln(link);
		}
	}

private:
	Opts _options;
	DependencyList _list;
}

int main(string[] args) {
	auto app = new Seshat();
	app.run();
	return 0;
}
