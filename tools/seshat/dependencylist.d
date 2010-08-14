module dependencylist;

import djehuty;

import io.file;
import io.console;

import data.list;

const string location = "/home/wilkie/djehuty";

class DependencyList : List!(string) {
	this(string path) {
		super();

		// Add runtime modules
		add(location ~ "/runtime/apply.d");
		add(location ~ "/runtime/array.d");
		add(location ~ "/runtime/assocarray.d");
		add(location ~ "/runtime/classinvariant.d");
		add(location ~ "/runtime/common.d");
		add(location ~ "/runtime/dstatic.d");
		add(location ~ "/runtime/error.d");
		add(location ~ "/runtime/exception.d");
		add(location ~ "/runtime/gc.d");
		add(location ~ "/runtime/lifetime.d");
		add(location ~ "/runtime/main.d");
		add(location ~ "/runtime/moduleinfo.d");
		add(location ~ "/runtime/monitor.d");
		add(location ~ "/runtime/switchstmt.d");

		// Add things the runtime depends on
		// (should make a .dep file or something per module
		add(location ~ "/synch/atomic.d");
		add(location ~ "/synch/semaphore.d");

		// Add itself
		add(path);

		// Generate dependency list and compile main module
		version(LDC) {
			string cmd = "ldc -deps=" ~ path[0..$-2] ~ ".dep " ~ path ~ " -d-version=PlatformLinux -I" ~ location ~ "/platform/unix -I" ~ location ~ "/compiler -c -o-";
			putln(cmd);
			long ret = System.execute(cmd);
			if (ret != 0) {
				// Error
				throw new Exception("LDC Error");
			}

			auto f = File.open(path[0..$-2] ~ ".dep");

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
