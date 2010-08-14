/*
 * file.d
 *
 * This file implements the Scaffold for platform specific File for Windows.
 *
 * Author: Dave Wilkinson
 *
 */

module scaffold.file;

import binding.win32.windef;
import binding.win32.winbase;
import binding.win32.winnt;

import platform.win.main;

import platform.vars.file;

import scaffold.directory;

import djehuty;

import io.console;
import io.directory;
import io.file;

// OPERATIONS //

bool FileMove(ref FilePlatformVars fileVars, string oldFullPath, string newFullPath) {
	wstring oldPath = Unicode.toUtf16(oldFullPath);
	oldPath ~= '\0';

	wstring newPath = Unicode.toUtf16(newFullPath);
	newPath ~= '\0';

	MoveFileW(oldPath.ptr, newPath.ptr);
	return true;
}

bool FileCopy(ref FilePlatformVars fileVars, string oldFullPath, string newFullPath) {
	wstring oldPath = Unicode.toUtf16(oldFullPath);
	oldPath ~= '\0';

	wstring newPath = Unicode.toUtf16(newFullPath);
	newPath ~= '\0';

	CopyFileW(oldPath.ptr, newPath.ptr, 0);
	return true;
}

bool FileRename(ref FilePlatformVars fileVars, ref string path, ref string newName) {
	wstring old = Unicode.toUtf16(path);
	old ~= '\0';

	string str;

	foreach_reverse(int i, chr; path)
	{
		if (chr == '/')
		{
			// truncate
			str = path[0..i];
			break;
		}
	}

	if (str is null) { return false; }

	str ~= newName;
	str ~= '\0';
	
	wstring strw = Unicode.toUtf16(str);

	MoveFileW(old.ptr, strw.ptr);
	return true;
}

bool FileMove(ref string from, ref Directory to) {
	wstring old = Unicode.toUtf16(from);
	old ~= '\0';

	string fn;

	foreach_reverse(int i, chr; from)
	{
		if (chr == '/')
		{
			// truncate (include the slash)
			fn = from[i..from.length];
			break;
		}
	}

	if (fn is null) { return false; }

	wstring str = Unicode.toUtf16(to.path);
	str ~= Unicode.toUtf16(fn);
	str ~= '\0';

	MoveFileW(old.ptr, str.ptr);
	return true;
}

// FILE //

bool FileOpen(ref FilePlatformVars fileVars, ref string filename) {
	wstring newString = Unicode.toUtf16(filename);
	newString ~= '\0';
	wchar[] foo = _ConvertFrameworkPath(newString);
	fileVars.f = CreateFileW( foo.ptr, GENERIC_READ | GENERIC_WRITE, FILE_SHARE_READ | FILE_SHARE_WRITE, null,OPEN_ALWAYS,0,null);

	return (fileVars.f !is null);
}

bool FileCreate(ref FilePlatformVars fileVars, ref string filename) {
	wstring newString = Unicode.toUtf16(filename);
	newString ~= '\0';
	wchar[] foo = _ConvertFrameworkPath(newString);
	fileVars.f = CreateFileW( foo.ptr, GENERIC_READ | GENERIC_WRITE, FILE_SHARE_READ | FILE_SHARE_WRITE, null,CREATE_ALWAYS,0,null);

	return (fileVars.f !is null);
}

void FileClose(ref FilePlatformVars fileVars) {
	CloseHandle(fileVars.f);
}

void FileGetSize(ref FilePlatformVars fileVars, ref ulong length) {
	GetFileSizeEx(fileVars.f, cast(PLARGE_INTEGER)&length);
}

void FileRewindAll(ref FilePlatformVars fileVars) {
	SetFilePointer(fileVars.f, 0, null, FILE_BEGIN);
}

void FileRewind(ref FilePlatformVars fileVars, ulong amount) {
	long theamount = cast(long)amount;
	theamount = -theamount;

	int low_word = cast(int)(theamount & 0xFFFFFFFF);
	int high_word = cast(int)(theamount >> 32);

	SetFilePointer(fileVars.f, low_word, &high_word, FILE_CURRENT);
}

void FileSkipAll(ref FilePlatformVars fileVars) {
	SetFilePointer(fileVars.f, 0, null, FILE_END);
}

void FileSkip(ref FilePlatformVars fileVars, ulong amount) {
	long theamount = cast(long)amount;

	int low_word = cast(int)(theamount & 0xFFFFFFFF);
	int high_word = cast(int)(theamount >> 32);

	SetFilePointer(fileVars.f, low_word, &high_word, FILE_CURRENT);
}

void FileRead(ref FilePlatformVars fileVars, ubyte* buffer, ulong len) {
	DWORD ret;
	ulong total_bytes = 0;

	ubyte* curbuffer = buffer;

	while (len > 0xFFFFFFFF) {
		ReadFile(fileVars.f, curbuffer, 0xFFFFFFFF, &ret, null);

		total_bytes += ret;
		len -= 0xFFFFFFFF;
		curbuffer += 0xFFFFFFFF;
	}

	ReadFile(fileVars.f, curbuffer, cast(uint)len, &ret, null);
	total_bytes += ret;
}

void FileWrite(ref FilePlatformVars fileVars, ubyte* buffer, ulong len) {
	DWORD ret;
	ulong total_bytes = 0;

	ubyte* curbuffer = buffer;

	// we are given a long for length, windows only has an int function
	while (len > 0xFFFFFFFF) {
		WriteFile(fileVars.f, curbuffer, 0xFFFFFFFF, &ret, null);

		total_bytes += ret;
		len -= 0xFFFFFFFF;
		curbuffer += 0xFFFFFFFF;
	}

	WriteFile(fileVars.f, curbuffer, cast(uint)len, &ret, null);
	total_bytes += ret;
}

void FileAppend(ref FilePlatformVars fileVars, ubyte* buffer, ulong len) {
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

Time FileTime(string path) {
	Time t = new Time();
	return t;
}