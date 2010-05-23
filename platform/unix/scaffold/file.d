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

import binding.c;

import djehuty;

import io.file;
import io.console;

// FILE //

bool FileOpen(ref FilePlatformVars fileVars, ref string filename) {
	string fn = filename.dup;
	fn ~= '\0';

	fileVars.file = fopen(fn.ptr, "r+b");

	return (fileVars.file !is null);
}

bool FileCreate(ref FilePlatformVars fileVars, ref string filename) {
	string fn = filename.dup;
	fn ~= '\0';

	fileVars.file = fopen(fn.ptr, "w+b");

	return (fileVars.file !is null);
}

void FileClose(ref FilePlatformVars fileVars) {
	fclose(fileVars.file);
}

void FileGetSize(ref FilePlatformVars fileVars, ref ulong length) {
	fseek(fileVars.file, 0, SEEK_END);

	length = ftell(fileVars.file);

	//writefln(length);

	fseek(fileVars.file, 0, SEEK_SET);
}

void FileRewindAll(ref FilePlatformVars fileVars) {
	fseek(fileVars.file, 0, SEEK_SET);
}

void FileRewind(ref FilePlatformVars fileVars, ulong amount) {
	fseek(fileVars.file, -cast(long)amount, SEEK_CUR);
}

void FileSkipAll(ref FilePlatformVars fileVars) {
	fseek(fileVars.file, 0, SEEK_END);
}

void FileSkip(ref FilePlatformVars fileVars, ulong amount) {
	fseek(fileVars.file, amount, SEEK_CUR);
}

void FileRead(ref FilePlatformVars fileVars, ubyte* buffer, ulong len) {
	fread(buffer, 1, len, fileVars.file);
}

void FileWrite(ref FilePlatformVars fileVars, ubyte* buffer, ulong len) {
	fwrite(buffer, 1, len, fileVars.file);
}

void FileAppend(ref FilePlatformVars fileVars, ubyte* buffer, ulong len) {
}

bool FileMove(ref FilePlatformVars fileVars, string oldFullPath, string newFullPath) {
	string exec = "mv " ~ oldFullPath ~ " " ~ newFullPath ~ "\0";

	system(exec.ptr);
	return true;
}

bool FileCopy(ref FilePlatformVars fileVars, string oldFullPath, string newFullPath) {
	string exec = "cp " ~ oldFullPath ~ " " ~ newFullPath ~ "\0";

	system(exec.ptr);
	return true;
}

bool FileRename(ref FilePlatformVars fileVars, ref string path, ref string newName) {
	string old = path.dup;
	old ~= '\0';

	string str;

	foreach_reverse(int i, chr; path) {
		if (chr == '/' && i < path.length - 1) {
			// truncate
			str = path[0..i].dup;
			break;
		}
	}

	if (str is null) { return false; }

	str ~= newName ~ "\0";

	rename(old.ptr, str.ptr);
	return true;
}

void FileRemove(ref FilePlatformVars fileVars, string fullPath) {
	string fn = fullPath.dup;
	fn ~= '\0';

	remove(fn.ptr);
}

Time FileTime(string path) {
	string newPath = path.dup;
	newPath ~= '\0';

	struct_stat inode;

	if (stat(newPath.ptr, &inode) == -1) {
		return null;
	}

	tm time_struct;
	gmtime_r(cast(time_t*)&inode.st_mtime, &time_struct);

	// get microseconds
	long micros;
	micros = time_struct.tm_sec + (time_struct.tm_min * 60);
	micros += time_struct.tm_hour * 60 * 60;
	micros *= 1000000;
	return new Time(micros);
}
