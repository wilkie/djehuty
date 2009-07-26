/*
 * file.d
 *
 * This Scaffold holds the File implementations for the Linux platform
 *
 * Author: Dave Wilkinson
 *
 */

module scaffold.file;

import platform.unix.common;

import platform.vars.file;

import core.string;
import core.main;

import io.file;

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

bool FileMove(ref FilePlatformVars fileVars, String oldFullPath, String newFullPath)
{
	String exec = new String("mv ") ~ oldFullPath ~ " " ~ newFullPath ~ "\0";

	system(exec.ptr);
	return true;
}

bool FileCopy(ref FilePlatformVars fileVars, String oldFullPath, String newFullPath)
{
	String exec = new String("cp ") ~ oldFullPath ~ " " ~ newFullPath ~ "\0";

	system(exec.ptr);
	return true;
}

void FileRename(ref FilePlatformVars fileVars, ref String path, ref String newName)
{
	String old = new String(path);
	old.appendChar('\0');

	String str;

	foreach_reverse(int i, chr; path)
	{
		if (chr == '/')
		{
			// truncate
			str = new String(path[0..i]);
			break;
		}
	}

	if (str is null) { return false; }

	str.append(newName);
	str.appendChar('\0');

	rename(old.ptr, str.ptr);
	return true;
}

void FileRemove(ref FilePlatformVars fileVars, String fullPath)
{
	String fn = new String(fullPath);
	fn.appendChar('\0');

	remove(fn.ptr);
}
