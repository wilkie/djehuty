/*
 * directory.d
 *
 * This file contains the logic for the Directory class, which allows
 * traversal of the filesystem.
 *
 * Author: Dave Wilkinson
 *
 */

module core.directory;

import core.string;
import core.file;
import core.filesystem;

import platform.imports;
mixin(PlatformGenericImport!("vars"));
mixin(PlatformGenericImport!("definitions"));
mixin(PlatformScaffoldImport!());

import console.main;

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
			_path = cur.getPath ~ "/" ~ path;
		}

		// retrieve name
		foreach_reverse(int i, chr; _path) {
			if (chr == '/') {
				name = new String(_path[i+1.._path.length]);
				break;
			}
		}
	}

	// Description: This constructor will create a Directory object that represents the path, if valid.
	// path: A valid universal path.
	this(StringLiteral path) {
		this(new String(path));
	}

	bool isDir(String name) {
		return Scaffold.DirectoryFileIsDir(_path ~ "/" ~ name);
	}

	bool isDir(StringLiteral name) {
		return isDir(new String(name));
	}

	void move(String path) {
		if (Scaffold.DirectoryMove(_path, path ~ "/" ~ name)) {
			parent = new Directory(path);
			_path = path ~ "/" ~ name;
		}
	}

	void move(Directory to) {
		move(to.getPath());
	}

	void move(StringLiteral path) {
		move(new String(path));
	}

	void copy(String path) {
		if (Scaffold.DirectoryCopy(_path, path)) {
			parent = null;
			_path = path;

			// retrieve name
			foreach_reverse(int i, chr; _path) {
				if (chr == '/') {
					name = new String(_path[i+1.._path.length]);
					break;
				}
			}
		}
	}

	void copy(StringLiteral path) {
		copy(new String(path));
	}

	void copy(Directory to, String newName = null) {
		if (newName is null) { newName = name; }

		copy(to.getPath() ~ "/" ~ newName);
	}

	void copy(Directory to, StringLiteral newName = null) {
		String nname;
		if (newName is null) { nname = name; } else { nname = new String(newName); }

		copy(to.getPath() ~ "/" ~ nname);
	}

	// Description: This function will return a String representing the name of the directory.
	// Returns: The name of the directory.
	String getName() {
		return new String(name);
	}

	// Description: This function will return a String representing the path of this directory.
	// Returns: The path of the directory.
	String getPath() {
		return new String(_path);
	}

	// Description: This function will rename the directory, if possible.
	// newName: The new name for the directory.
	void setName(String newName) {
		// Rename directory

		// XXX: Do it.
		if (isRoot) {
			// XXX: Exception
		}
		else {
			// Change the name of the directory (if possible)
			Scaffold.DirectoryRename(_path, newName);
			_path = getParent().getPath() ~ "/" ~ newName;
			name = new String(newName);
		}
	}

	// Description: This function will rename the directory, if possible.
	// newName: The new name for the directory.
	void setName(StringLiteral newName) {
		setName(new String(newName));
	}

	// Description: This function will open the file specified by the parameter if it exists within the directory.
	// filename: The name of the file to open.
	// Returns: Will return null if the file cannot be opened or found, will return a valid File otherwise.
	File openFile(String filename) {
		return null;
	}

	// Description: This function will create a new file in this directory.
	// filename: The name of the file to create.
	// Returns: Will return null if the file cannot be created, will return a valid File otherwise.
	File saveFile(String filename) {
		return null;
	}

	File saveFile(StringLiteral filename) {
		return null;
	}

	// Description: This function will return the parent directory of the current path.
	// Returns: The Directory object representing the parent directory and null if the current directory is the root.
	Directory getParent() {
		if (isRoot) { return null; }

		if (parent is null) {
			Console.putln(_path.array);

			foreach_reverse(int i, chr; _path) {
				if (chr == '/')	{
					// truncate
					Console.putln(_path[0..i]);
					parent = new Directory(_path[0..i]);
					return parent;
				}
			}
		}

		return parent;
	}

	// Description: This function will return the Directory representing the directory specified within the current path.
	// directoryName: The name of the directory.
	// Returns: The child directory specified.
	Directory traverse(String directoryName) {
		Directory ret = new Directory(_path ~ "/" ~ directoryName);

		ret.parent = this;

		return ret;
	}

	// Description: This function will return the Directory representing the directory specified within the current path.
	// directoryName: The name of the directory.
	// Returns: The child directory specified.
	Directory traverse(StringLiteral directoryName) {
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

	bool opEquals(StringLiteral d) {
		return _path == d;
	}

	// this should work:
	alias Object.opEquals opEquals;

protected:

	String name;
	String _path;
	Directory parent;

	bool _isRoot;

	DirectoryPlatformVars _pfVars;
}
