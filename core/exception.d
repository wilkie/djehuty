/*
 * exception.d
 *
 * This module defines common exceptions.
 *
 * Author: Dave Wilkinson
 * Originated: August 20th, 2009
 *
 */

module core.exception;

import core.string;

class FileNotFound : Exception {
	this() {
		super("File Not Found");
	}

	this(String path) {
		super("File Not Found: " ~ path.toString());
	}

	this(string path) {
		super("File Not Found: " ~ path);
	}
}

class DirectoryNotFound : Exception {
	this() {
		super("Directory Not Found");
	}

	this(String path) {
		super("Directory Not Found: " ~ path.toString());
	}

	this(string path) {
		super("Directory Not Found: " ~ path);
	}
}