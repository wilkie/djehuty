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

	// Description: This function will return the Directory representing the current directory.
	// Returns: The Directory representing the working directory.
	Directory getCurrentDir()
	{
		return new Directory(Scaffold.DirectoryGetCWD());
	}

	// Description: This function will return the Directory representing the directory the executable is located in. It should not be relied on completely, as this information can be incorrect or non-existent.
	// Returns: The Directory representing the executable location.
	Directory getApplicationDir()
	{
		return new Directory(Scaffold.DirectoryGetApp());
	}

	// Description: This function will return the Directory representing the system's temporary files directory. Persistance is not guaranteed.
	// Returns: The Directory representing the temp location.
	Directory getTempDir()
	{
		return new Directory(Scaffold.DirectoryGetTempData());
	}

	// Description: This function will return the Directory representing the system's temporary files directory. Persistance is not guaranteed.
	// Returns: The Directory representing the temp location.
	Directory getAppDataDir()
	{
		return new Directory(Scaffold.DirectoryGetAppData());
	}

	// Description: This function will return the Directory representing the system's temporary files directory. Persistance is not guaranteed.
	// Returns: The Directory representing the temp location.
	Directory getUserDataDir()
	{
		return new Directory(Scaffold.DirectoryGetUserData());
	}

	// Description: This function will return the Directory representing the system's temporary files directory. Persistance is not guaranteed.
	// Returns: The Directory representing the temp location.
	Directory getBinaryDir()
	{
		return new Directory(Scaffold.DirectoryGetBinary());
	}
}
