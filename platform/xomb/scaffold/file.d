/*
 * file.d
 *
 * This Scaffold holds the File implementations for the Linux platform
 *
 * Author: Dave Wilkinson
 *
 */

module scaffold.file;

import platform.vars.file;

import djehuty;

import io.file;
import io.console;

// FILE //

bool FileOpen(ref FilePlatformVars fileVars, ref string filename) {
	return false;
}

bool FileCreate(ref FilePlatformVars fileVars, ref string filename) {
	return false;
}

void FileClose(ref FilePlatformVars fileVars) {
}

void FileGetSize(ref FilePlatformVars fileVars, ref ulong length) {
}

void FileRewindAll(ref FilePlatformVars fileVars) {
}

void FileRewind(ref FilePlatformVars fileVars, ulong amount) {
}

void FileSkipAll(ref FilePlatformVars fileVars) {
}

void FileSkip(ref FilePlatformVars fileVars, ulong amount) {
}

void FileRead(ref FilePlatformVars fileVars, ubyte* buffer, ulong len) {
}

void FileWrite(ref FilePlatformVars fileVars, ubyte* buffer, ulong len) {
}

void FileAppend(ref FilePlatformVars fileVars, ubyte* buffer, ulong len) {
}

bool FileMove(ref FilePlatformVars fileVars, string oldFullPath, string newFullPath) {
	return true;
}

bool FileCopy(ref FilePlatformVars fileVars, string oldFullPath, string newFullPath) {
	return true;
}

bool FileRename(ref FilePlatformVars fileVars, ref string path, ref string newName) {
	return true;
}

void FileRemove(ref FilePlatformVars fileVars, string fullPath) {
}

Time FileTime(string path) {
	return new Time(0);
}
