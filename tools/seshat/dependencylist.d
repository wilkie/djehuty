module seshat.dependencylist;

import djehuty;

import io.file;

import data.list;

class DependencyList : List!(string) {
	this(string path) {
		super();

		// Add runtime modules
		add("runtime/apply.d");
		add("runtime/array.d");
		add("runtime/assocarray.d");
		add("runtime/classinvariant.d");
		add("runtime/common.d");
		add("runtime/dstatic.d");
		add("runtime/error.d");
		add("runtime/exception.d");
		add("runtime/gc.d");
		add("runtime/lifetime.d");
		add("runtime/main.d");
		add("runtime/moduleinfo.d");
		add("runtime/monitor.d");
		add("runtime/switchstmt.d");

		// Add things the runtime depends on
		// (should make a .dep file or something per module
		add("synch/atomic.d");
		add("synch/semaphore.d");

		// Generate dependency list and compile main module
		version(LDC) {
			System.execute("ldc -deps=.deps " ~ path ~ " -d-version=PlatformLinux -Iplatform/unix -Icompiler -c -o-");

			auto f = File.open(".deps");

			foreach(line; f) {
				Regex.eval(line, `[^:]*:[^:]*:[^\(]*\(([^\)]*)\)`);
				string mod = _1;
				if (!(contains(mod))) {
					add(mod);
				}
			}
		}
		else {
			// DMD?
		}
	}
}
