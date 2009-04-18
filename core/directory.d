module core.directory;

import core.string;
import core.file;

import platform.imports;
mixin(PlatformGenericImport!("vars"));
mixin(PlatformGenericImport!("definitions"));
mixin(PlatformScaffoldImport!());

class Directory
{
	// Description: This constructor will create a Directory object that represents the root.
	this()
	{
		_isRoot = true;
	}

	// Description: This constructor will create a Directory object that represents the path, if valid.
	// path: A valid universal path.
	this(String path)
	{
		_isRoot = false;
		name = new String(path);
	}

	this(StringLiteral path)
	{
		this(new String(path));
	}

	~this()
	{
	}

	// Description: This function will return a String representing the name of the directory.
	// Returns: The name of the directory.
	String getName()
	{
		return new String(name);
	}

	// Description: This function will rename the directory, if possible.
	// newName: The new name for the directory.
	void setName(String newName)
	{
		name = new String(newName);

		// Rename directory

		// XXX: Do it.
		if (isRoot)
		{
			// XXX: Exception
		}
		else
		{
			// Change the name of the directory (if possible)
		}
	}

	// Description: This function will open the file specified by the parameter if it exists within the directory.
	// filename: The name of the file to open.
	// Returns: Will return null if the file cannot be opened or found, will return a valid File otherwise.
	File openFile(String filename)
	{
		return null;
	}

	// Description: This function will create a new file in this directory.
	// filename: The name of the file to create.
	// Returns: Will return null if the file cannot be created, will return a valid File otherwise.
	File saveFile(String filename)
	{
		return null;
	}

	File saveFile(StringLiteral filename)
	{
		return null;
	}

	// Description: This function will return the parent directory of the current path.
	// Returns: The Directory object representing the parent directory and null if the current directory is the root.
	Directory getParent()
	{
		if (isRoot) { return null; }

		return parent;
	}

	// Description: This function will return the Directory representing the directory specified within the current path.
	// directoryName: The name of the directory.
	// Returns: The child directory specified.
	Directory traverse(String directoryName)
	{
		return null;
	}

	// Description: This function will return whether or not the object represents the root.
	// Returns: Will return true when the Directory is root and false otherwise.
	bool isRoot()
	{
		return _isRoot;
	}

	// Description: This function will return an array of filenames that are found within this directory.
	// Returns: An array of filenames.
	String[] list()
	{
		return Scaffold.DirectoryList(_pfVars, name);
	}

protected:

	String name;
	Directory parent;

//	String[] files;
//	Directory[] subDirectories;

	bool _isRoot;

	DirectoryPlatformVars _pfVars;
}
