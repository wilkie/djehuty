/*
 * error.d
 *
 * This module implements the Error objects useable by the system.
 * This objects are for irrecoverable failures.
 *
 * Originated: May 8th, 2010
 *
 */

module core.error;

import core.exception;

// Description: This is for non irrecoverable failure.
class Error : Exception {
	this(string msg, string file = "", ulong line = 0) {
		super(msg, file, line);
	}
}

abstract class RuntimeError : Error {
	this(string msg, string file, ulong line){
		super(msg,file,line);
	}

static:

	// Description: This Error is thrown when assertions fail.
	class Assert : RuntimeError {
		this(string msg, string file, ulong line) {
			super("Assertion `" ~ msg ~ "` failed", file, line);
		}

		this(string file, ulong line) {
			super("Assertion failed",file,line);
		}
	}

	class CyclicDependency : RuntimeError {
		this(string moduleNameA, string moduleNameB) {
			super("Cyclic Dependency detected between " ~ moduleNameA ~ " and " ~ moduleNameB, "", 0);
		}
	}

	// Description: This Error is thrown when a switch statement does not have a default and there is no case available.
	class NoDefaultCase : RuntimeError {
		this(string file, ulong line) {
			super("Switch has no default",file,line);
		}
	}

	class NoCompare : RuntimeError {
		this(string className) {
			super("Class " ~ className ~ " needs an opCmp.", "", 0);
		}	
	}
}
