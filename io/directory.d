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
import core.filesystem;

import io.file;
import io.console;

import platform.imports;
mixin(PlatformGenericImport!("vars"));
mixin(PlatformGenericImport!("definitions"));
mixin(PlatformScaffoldImport!());

// Section: Core

// Description: This class represents a file system directory.
class Directory
{
	// Description: This constructor will create a Directory object that represents the root.
	this() {
		_isRoot = true;
		_path = new String("");
	}

	// Description: This constructor will create a Directory object that represents the path, if valid.
	// path: A valid universal path.
	this(String path) {
		_isRoot = false;
		if (path.length > 0 && path[0] == '/') {
			// absolute path
			_path = new String(path);
		}
		else {
			// relative path

			// get the working directory
			Directory cur = FileSystem.getCurrentDir();

			// create an absolute path
			_path = cur.path ~ "/" ~ path;
		}

		// retrieve _name
		foreach_reverse(int i, chr; _path) {
			if (chr == '/') {
				_name = new String(_path[i+1.._path.length]);
				break;
			}
		}
	}

	// Description: This constructor will create a Directory object that represents the path, if valid.
	// path: A valid universal path.
	this(string path) {
		this(new String(path));
	}

	bool isDir(String _name) {
		return Scaffold.DirectoryFileIsDir(_path ~ "/" ~ _name);
	}

	bool isDir(string _name) {
		return isDir(new String(_name));
	}

	void move(String path) {
		if (Scaffold.DirectoryMove(_path, path ~ "/" ~ _name)) {
			_parent = new Directory(path);
			_path = path ~ "/" ~ _name;
		}
	}

	void move(Directory to) {
		move(to.path());
	}

	void move(string path) {
		move(new String(path));
	}

	void copy(String path) {
		if (Scaffold.DirectoryCopy(_path, path)) {
			_parent = null;
			_path = path;

			// retrieve _name
			foreach_reverse(int i, chr; _path) {
				if (chr == '/') {
					_name = new String(_path[i+1.._path.length]);
					break;
				}
			}
		}
	}

	void copy(string path) {
		copy(new String(path));
	}

	void copy(Directory to, String newName = null) {
		if (newName is null) { newName = _name; }

		copy(to.path() ~ "/" ~ newName);
	}

	void copy(Directory to, string newName = null) {
		String nname;
		if (newName is null) { nname = _name; } else { nname = new String(newName); }

		copy(to.path() ~ "/" ~ nname);
	}

	// Description: This function will return a String representing the _name of the directory.
	// Returns: The _name of the directory.
	String name() {
		return new String(_name);
	}

	// Description: This function will return a String representing the path of this directory.
	// Returns: The path of the directory.
	String path() {
		return new String(_path);
	}

	// Description: This function will rename the directory, if possible.
	// newName: The new _name for the directory.
	void name(String newName) {
		// Rename directory

		// XXX: Do it.
		if (isRoot) {
			// XXX: Exception
		}
		else {
			// Change the _name of the directory (if possible)
			Scaffold.DirectoryRename(_path, newName);
			_path = this.parent.path ~ "/" ~ newName;
			_name = new String(newName);
		}
	}

	// Description: This function will rename the directory, if possible.
	// newName: The new _name for the directory.
	void name(string newName) {
		name(new String(newName));
	}

	// Description: This function will open the file specified by the parameter if it exists within the directory.
	// filename: The _name of the file to open.
	// Returns: Will return null if the file cannot be opened or found, will return a valid File otherwise.
	File openFile(String filename) {
		return null;
	}

	// Description: This function will create a new file in this directory.
	// filename: The _name of the file to create.
	// Returns: Will return null if the file cannot be created, will return a valid File otherwise.
	File saveFile(String filename) {
		return null;
	}

	File saveFile(string filename) {
		return null;
	}

	// Description: This function will return the _parent directory of the current path.
	// Returns: The Directory object representing the _parent directory and null if the current directory is the root.
	Directory parent() {
		if (isRoot) { return null; }

		if (_parent is null) {
			Console.putln(_path.array);

			foreach_reverse(int i, chr; _path) {
				if (chr == '/')	{
					// truncate
					Console.putln(_path[0..i]);
					_parent = new Directory(_path[0..i]);
					return _parent;
				}
			}
		}

		return _parent;
	}

	// Description: This function will return the Directory representing the directory specified within the current path.
	// directoryName: The _name of the directory.
	// Returns: The child directory specified.
	Directory traverse(String directoryName) {
		Directory ret = new Directory(_path ~ "/" ~ directoryName);

		ret._parent = this;

		return ret;
	}

	// Description: This function will return the Directory representing the directory specified within the current path.
	// directoryName: The _name of the directory.
	// Returns: The child directory specified.
	Directory traverse(string directoryName) {
		return new Directory(_path ~ "/" ~ directoryName);
	}

	// Description: This function will return whether or not the object represents the root.
	// Returns: Will return true when the Directory is root and false otherwise.
	bool isRoot() {
		return _isRoot;
	}

	// Description: This function will return an array of filenames that are found within this directory.
	// Returns: An array of filenames.
	String[] list() {
		return Scaffold.DirectoryList(_pfVars, _path);
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
		return this.path.toString();
	}

protected:

	String _name;
	String _path;
	Directory _parent;

	bool _isRoot;

	DirectoryPlatformVars _pfVars;
}
