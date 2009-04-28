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

	Directory getCurrentDirectory()
	{
		return new Directory(Scaffold.DirectoryGetCWD());
	}

	Directory getApplicationDirectory()
	{
		return new Directory(Scaffold.DirectoryGetApp());
	}
}
