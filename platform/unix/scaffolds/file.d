module platform.unix.scaffolds.file;

import platform.unix.vars;
import platform.unix.common;

import core.string;
import core.file;
import core.main;

// FILE //

bool FileOpen(ref FilePlatformVars fileVars, ref String filename)
{
	String fn = new String(filename);
	fn.appendChar('\0');

	fileVars.file = fopen(fn.ptr, "rb");

	return (fileVars.file !is null);
}

void FileClose(ref FilePlatformVars fileVars)
{
	fclose(fileVars.file);
}

void FileGetSize(ref FilePlatformVars fileVars, ref ulong length)
{
	fseek(fileVars.file, 0, SEEK_END);

	length = ftell(fileVars.file);


	//writefln(length);

	fseek(fileVars.file, 0, SEEK_SET);
}

void FileRewindAll(ref FilePlatformVars fileVars)
{
	fseek(fileVars.file, 0, SEEK_SET);
}

void FileRewind(ref FilePlatformVars fileVars, ulong amount)
{
	fseek(fileVars.file, -cast(long)amount, SEEK_CUR);
}

void FileSkipAll(ref FilePlatformVars fileVars)
{
	fseek(fileVars.file, 0, SEEK_END);
}

void FileSkip(ref FilePlatformVars fileVars, ulong amount)
{
	fseek(fileVars.file, amount, SEEK_CUR);
}

void FileRead(ref FilePlatformVars fileVars, ubyte* buffer, ulong len)
{
	fread(buffer, 1, len, fileVars.file);
}

void FileWrite(ref FilePlatformVars fileVars, ubyte* buffer, ulong len)
{
	fwrite(buffer, 1, len, fileVars.file);
}

void FileAppend(ref FilePlatformVars fileVars, ubyte* buffer, ulong len)
{
}

void FileRename(ref FilePlatformVars fileVars, String oldFullPath, String newFullPath)
{
	String fn = new String(oldFullPath);
	fn.appendChar('\0');

	String fn2 = new String(newFullPath);
	fn.appendChar('\0');

	rename(fn.ptr, fn2.ptr);
}

void FileRemove(ref FilePlatformVars fileVars, String fullPath)
{
	String fn = new String(fullPath);
	fn.appendChar('\0');

	remove(fn.ptr);
}
