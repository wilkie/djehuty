module core.filesystem;

import core.directory;
import core.file;

import platform.imports;
mixin(PlatformGenericImport!("vars"));
mixin(PlatformGenericImport!("definitions"));
mixin(PlatformScaffoldImport!());

class FileSystem
{
public:
static:

	// Description: This function will return the String representing the current directory.
	// Returns: The Directory representing the working directory.
	Directory getCurrentDirectory()
	{
		return new Directory(Scaffold.DirectoryGetCWD());
	}

	// Description: This function will return the String representing the directory the executable is located in.
	// Returns: The Directory representing the executable location.
	Directory getApplicationDirectory()
	{
		return new Directory(Scaffold.DirectoryGetApp());
	}
}
