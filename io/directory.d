/*
 * directory.d
 *
 * This file contains the logic for the Directory class, which allows
 * traversal of the filesystem.
 *
 * Author: Dave Wilkinson
 *
 */

module io.directory;

import core.string;
import core.system;
import core.definitions;
import core.exception;

import io.file;
import io.console;

import platform.vars.directory;

import scaffold.directory;

// Section: Core

// Description: This class represents a file system directory.
class Directory {
	// Description: This constructor will create a Directory object that represents the root.
	this() {
		_isRoot = true;
		_path = "";
	}

	// Description: This constructor will create a Directory at the specified path.
	// path: A valid universal path.
	this(string path) {
		// XXX: todo
		throw new Exception("Not Done Yet");
	}

	static Directory open(string path) {
		Directory ret = new Directory;
		ret._isRoot = false;
		if (path.length > 0 && path[0] == '/') {
			// absolute path
			ret._path = path.dup;
		}
		else {
			// relative path

			// get the working directory
			Directory cur = System.FileSystem.currentDir;

			// create an absolute path
			ret._path = cur.path ~ "/" ~ path;
		}

		// retrieve _name
		foreach_reverse(int i, chr; ret._path) {
			if (chr == '/' && i < ret._path.length - 1) {
				ret._name = ret._path[i+1..ret._path.length].dup;
				break;
			}
		}
		if (!DirectoryFileIsDir(ret._path)) {
			return null;
		}
		return ret;
	}

	static Directory create(string path) {
		return new Directory(path);
	}

	bool isDir(string _name) {
		return DirectoryFileIsDir(_path ~ "/" ~ _name);
	}

	void move(Directory to) {
		move(to.path());
	}

	void move(string path) {
		if (DirectoryMove(_path, path ~ "/" ~ _name)) {
			_parent = Directory.open(path);
			_path = path ~ "/" ~ _name;
		}
	}

	void copy(string path) {
		if (DirectoryCopy(_path, path)) {
			_parent = null;
			_path = path;

			// retrieve _name
			foreach_reverse(int i, chr; _path) {
				if (chr == '/' && i < _path.length - 1) {
					_name = _path[i+1.._path.length].dup;
					break;
				}
			}
		}
	}

	void copy(Directory to, string newName = null) {
		if (newName is null) { newName = _name; }

		copy(to.path() ~ "/" ~ newName);
	}

	// Description: This function will return a String representing the _name of the directory.
	// Returns: The _name of the directory.
	string name() {
		return _name.dup;
	}

	// Description: This function will return a String representing the path of this directory.
	// Returns: The path of the directory.
	string path() {
		return _path.dup;
	}

	// Description: This function will rename the directory, if possible.
	// newName: The new _name for the directory.
	void name(string newName) {
		// Rename directory

		if (isRoot) {
			// XXX: Exception
		}
		else {
			// Change the _name of the directory (if possible)
			DirectoryRename(_path, newName);
			_path = this.parent.path ~ "/" ~ newName;
			_name = newName;
		}
	}

	// Description: This function will open the file specified by the parameter if it exists within the directory.
	// filename: The _name of the file to open.
	// Returns: Will return null if the file cannot be opened or found, will return a valid File otherwise.
	File openFile(string filename) {
		return File.open(this.path ~ "/" ~ filename);
	}

	// Description: This function will create a new file in this directory.
	// filename: The _name of the file to create.
	// Returns: Will return null if the file cannot be created, will return a valid File otherwise.
	File createFile(string filename) {
		return File.create(this.path ~ "/" ~ filename);
	}

	// Description: This function will return the _parent directory of the current path.
	// Returns: The Directory object representing the _parent directory and null if the current directory is the root.
	Directory parent() {
		if (isRoot) { return null; }

		if (_parent is null) {
			Console.putln(_path);

			foreach_reverse(int i, chr; _path) {
				if (chr == '/')	{
					// truncate
					Console.putln(_path[0..i]);
					_parent = Directory.open(_path[0..i]);
					return _parent;
				}
			}
		}

		return _parent;
	}

	// Description: This function will return the Directory representing the directory specified within the current path.
	// directoryName: The _name of the directory.
	// Returns: The child directory specified.
	Directory traverse(string directoryName) {
		if (isDir(directoryName)) {
			Directory ret = Directory.open(_path ~ "/" ~ directoryName);

			ret._parent = this;

			return ret;
		}
		throw new DirectoryNotFound(_path ~ "/" ~ directoryName);
	}

	// Description: This function will return whether or not the object represents the root.
	// Returns: Will return true when the Directory is root and false otherwise.
	bool isRoot() {
		return _isRoot;
	}

	// Description: This function will return an array of filenames that are found within this directory.
	// Returns: An array of filenames.
	string[] list() {
		return DirectoryList(_pfVars, _path);
	}

	bool opEquals(Directory d) {
		return _path == d._path;
	}

	bool opEquals(String d) {
		return _path == d;
	}

	bool opEquals(string d) {
		return _path == d;
	}

	// this should work:
	alias Object.opEquals opEquals;

	override char[] toString() {
		return this.path.dup;
	}

protected:

	string _name;
	string _path;
	Directory _parent;

	bool _isRoot;

	DirectoryPlatformVars _pfVars;
}
