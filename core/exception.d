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
import core.definitions;

// Exceptions for file IO

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

// Exceptions for data structures

class OutOfElements : Exception {
	this() {
		super("Out of Elements");
	}

	this(String classname) {
		super("Out of Elements in " ~ classname.toString());
	}

	this(string classname) {
		super("Out of Elements in " ~ classname);
	}
}

class OutOfBounds : Exception {
	this() {
		super("Out of Bounds");
	}

	this(String classname) {
		super("Out of Bounds in " ~ classname.toString());
	}

	this(string classname) {
		super("Out of Bounds in " ~ classname);
	}
}

class ElementNotFound : Exception {
	this() {
		super("Element Not Found");
	}

	this(String classname) {
		super("Element Not Found in " ~ classname.toString());
	}

	this(string classname) {
		super("Element Not Found in " ~ classname);
	}
}
