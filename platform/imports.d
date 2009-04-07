module platform.imports;

import core.literals;

// support for further platforms is done here:

// as long as the platform conforms to the directory structure and the internal
// interfaces of the classes, only one line needs to be placed below.

version(PlatformWindows)
{
	public import platform.win.imports;

	version=PlatformSupported;
}

version(PlatformLinux)
{
	public import platform.unix.imports;

	version=PlatformSupported;
}

version(PlatformOSX)
{
	public import platform.osx.imports;

	version=PlatformSupported;
}

version(PlatformXOmB)
{
	public import platform.xomb.imports;

	version=PlatformSupported;
}

version(PlatformSupported)
{
}
else
{
	pragma(msg, "warning: unknown platform");
	public import platform.empty.imports;
}

// generic templates for importing specific platform modules
template PlatformGenericImport(StringLiteral8 file)
{
	const char[] PlatformGenericImport =
	`private import platform.` ~ PlatformTitle ~ `.` ~ file ~ `;`;
}

template PlatformGenericImportClass(StringLiteral8 file, StringLiteral8 classname)
{
	const char[] PlatformGenericImportClass =
	`private import platform.` ~ PlatformTitle ~ `.` ~ file ~ ` : ` ~ classname ~ `;`;
}

template PlatformGenericPublicImport(StringLiteral8 file)
{
	const char[] PlatformGenericPublicImport =
	`public import platform.` ~ PlatformTitle ~ `.` ~ file ~ `;`;
}

template PlatformScaffoldImport()
{
	const char[] PlatformScaffoldImport =
	`private import Scaffold = platform.` ~ PlatformTitle ~ `.scaffold;`;
}

template PlatformControlImport(StringLiteral8 controlfile)
{
	const char[] PlatformControlImport =
	`public import platform.` ~ PlatformTitle ~ `.controls.` ~ controlfile ~ `;`;
}
