/*
 * file.d
 *
 * This file implements the Scaffold for platform specific File for Windows.
 *
 * Author: Dave Wilkinson
 *
 */

module platform.win.scaffolds.file;

import interfaces.stream;

import platform.win.vars;
import platform.win.common;
import platform.win.main;

import core.view;
import core.graphics;
import core.window;
import core.string;
import core.file;
import core.main;
import core.definitions;
import core.directory;

import console.main;

// OPERATIONS //

bool FileMove(ref FilePlatformVars fileVars, String oldFullPath, String newFullPath)
{
	String oldPath = new String(oldFullPath);
	oldPath.appendChar('\0');

	String newPath = new String(newFullPath);
	newPath.appendChar('\0');

	MoveFileW(oldPath.ptr, newPath.ptr);
	return true;
}

bool FileCopy(ref FilePlatformVars fileVars, String oldFullPath, String newFullPath)
{
	String oldPath = new String(oldFullPath);
	oldPath.appendChar('\0');

	String newPath = new String(newFullPath);
	newPath.appendChar('\0');

	CopyFileW(oldPath.ptr, newPath.ptr, 0);
	return true;
}

bool FileRename(ref FilePlatformVars fileVars, ref String path, ref String newName)
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

	MoveFileW(old.ptr, str.ptr);
	return true;
}

bool FileMove(ref String from, ref Directory to)
{
	String old = new String(from);
	old.appendChar('\0');

	String fn;

	foreach_reverse(int i, chr; from)
	{
		if (chr == '/')
		{
			// truncate (include the slash)
			fn = new String(from[i..from.length]);
			break;
		}
	}

	if (fn is null) { return false; }

	String str = new String(to.getPath());
	str.append(fn);
	str.appendChar('\0');

	MoveFileW(old.ptr, str.ptr);
	return true;
}

// FILE //

bool FileOpen(ref FilePlatformVars fileVars, ref String filename)
{
	String newString = new String(filename);
	newString.appendChar('\0');
	fileVars.f = CreateFileW( newString.ptr, GENERIC_READ | GENERIC_WRITE, FILE_SHARE_READ | FILE_SHARE_WRITE, null,OPEN_ALWAYS,0,null);

	return (fileVars.f !is null);
}

void FileClose(ref FilePlatformVars fileVars)
{
	CloseHandle(fileVars.f);
}

void FileGetSize(ref FilePlatformVars fileVars, ref ulong length)
{
	GetFileSizeEx(fileVars.f, cast(PLARGE_INTEGER)&length);
}

void FileRewindAll(ref FilePlatformVars fileVars)
{
	SetFilePointer(fileVars.f, 0, null, FILE_BEGIN);
}

void FileRewind(ref FilePlatformVars fileVars, ulong amount)
{
	long theamount = cast(long)amount;
	theamount = -theamount;

	int low_word = cast(int)(theamount & 0xFFFFFFFF);
	int high_word = cast(int)(theamount >> 32);

	SetFilePointer(fileVars.f, low_word, &high_word, FILE_CURRENT);
}

void FileSkipAll(ref FilePlatformVars fileVars)
{
	SetFilePointer(fileVars.f, 0, null, FILE_END);
}

void FileSkip(ref FilePlatformVars fileVars, ulong amount)
{
	long theamount = cast(long)amount;

	int low_word = cast(int)(theamount & 0xFFFFFFFF);
	int high_word = cast(int)(theamount >> 32);

	SetFilePointer(fileVars.f, low_word, &high_word, FILE_CURRENT);
}

void FileRead(ref FilePlatformVars fileVars, ubyte* buffer, ulong len)
{
	DWORD ret;
	ulong total_bytes = 0;

	ubyte* curbuffer = buffer;

	while (len > 0xFFFFFFFF)
	{
		ReadFile(fileVars.f, curbuffer, 0xFFFFFFFF, &ret, null);

		total_bytes += ret;
		len -= 0xFFFFFFFF;
		curbuffer += 0xFFFFFFFF;
	}

	ReadFile(fileVars.f, curbuffer, cast(uint)len, &ret, null);
	total_bytes += ret;
}

void FileWrite(ref FilePlatformVars fileVars, ubyte* buffer, ulong len)
{
	DWORD ret;
	ulong total_bytes = 0;

	ubyte* curbuffer = buffer;

	// we are given a long for length, windows only has an int function
	while (len > 0xFFFFFFFF)
	{
		WriteFile(fileVars.f, curbuffer, 0xFFFFFFFF, &ret, null);

		total_bytes += ret;
		len -= 0xFFFFFFFF;
		curbuffer += 0xFFFFFFFF;
	}

	WriteFile(fileVars.f, curbuffer, cast(uint)len, &ret, null);
	total_bytes += ret;
}

void FileAppend(ref FilePlatformVars fileVars, ubyte* buffer, ulong len)
{
/*	Console.putln("append");
	ulong pos = file.getPosition();

	file.skip();

	DWORD ret;
	ulong total_bytes = 0;

	ubyte* curbuffer = buffer;

	// we are given a long for length, windows only has an int function
	while (len > 0xFFFFFFFF)
	{
		WriteFile(fileVars.f, curbuffer, 0xFFFFFFFF, &ret, null);

		total_bytes += ret;
		len -= 0xFFFFFFFF;
		curbuffer += 0xFFFFFFFF;
	}

	WriteFile(fileVars.f, curbuffer, cast(uint)len, &ret, null);
	total_bytes += ret;

	file.rewind();
	file.skip(pos);*/
}

