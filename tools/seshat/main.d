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
			Console.forecolor = Color.Red;
			Console.putln("USAGE: seshat --build file.d");
			return;
		}

		Console.forecolor = Color.Green;
		Console.putln(" -- Dependency Crawl --");
		Console.putln(" : " ~ _options.path);

		// 0. Get dependencies
		_list = new DependencyList(_options.path);

		// 1. Build Dependencies
		auto linkingList = new List!(string);

		auto builtList = new List!(string);

		Console.forecolor = Color.Blue;
		Console.putln();
		Console.putln(" -- Building --");
		double done = 0.0;
		foreach(ref size_t idx, string mod; _list) {
			done = cast(double)idx / cast(double)(_list.length-1);
			done *= 100;

			int percent = cast(int)done;

			string pc = "{d}%".format(percent);
			if (pc.length < 3) {
				pc = "  " ~ pc;
			}
			else if (pc.length < 4) {
				pc = " " ~ pc;
			}

			Console.putln(" : " ~ pc ~ " " ~ mod.replace('/', '.'));

			// Compile each module in the list if necessary
			string object = mod[0..$-2] ~ ".o";

			// Check the file time of the object against the source.

			// if (File.time(mod) > File.time(object)) {
			//   builtList.add(mod);
			//   compile
			// }

			// Decide if this implies a library to link
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

//		Console.forecolor = Color.Cyan;
//		putln(" : Verifying " ~ moduleExecutable);

		// 2a. Build Sobek component and run

		// 3. Link
		string moduleObject;
		string moduleExecutable;
		moduleExecutable = _options.path[0..$-2];
		Console.forecolor = Color.Magenta;
		Console.putln();
		Console.putln(" -- Linking --");
		putln(" : Linking " ~ moduleExecutable);
		version(LDC) {
			moduleObject = _options.path[0..$-2] ~ ".o";
			string ldcCommand = "ldc -of" ~ moduleExecutable ~ " " ~ moduleObject;
			foreach(mod; _list) {
				ldcCommand ~= " " ~ mod[0..$-2] ~ ".o";
			}
			foreach(link; linkingList) {
				ldcCommand ~= " -L-l" ~ link;
			}
			ldcCommand ~= " -L-lpthread -L-lrt";
			//putln(ldcCommand);
			System.execute(ldcCommand);
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
