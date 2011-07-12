/*
 * directory.d
 *
 * This Scaffold holds the Directory implementations for the Linux platform
 *
 * Author: Dave Wilkinson
 *
 */

module scaffold.directory;

import binding.c;

import platform.vars.directory;
import platform.vars.file;

import io.file;
import io.console;

import core.definitions;
import core.string;
import core.main;
import data.list;

bool DirectoryOpen(ref DirectoryPlatformVars dirVars, ref string path) {
	return false;
}

bool DirectoryCreate(ref DirectoryPlatformVars dirVars, ref string path) {
	return false;
}

bool DirectoryClose(ref DirectoryPlatformVars dirVars) {
	return true;
}

string DirectoryGetBinary() {
	return "/binaries";
}

string DirectoryGetAppData() {
	return "/share";
}

string DirectoryGetTempData() {
	return "/temp";
}

string DirectoryGetUserData() {
	return "/home";
}

string DirectoryGetApp() {
	return "/app";
}

string DirectoryGetCWD() {
	return "/";
}

bool DirectoryFileIsDir(string path) {
	return false;
}

bool DirectoryMove(ref string path, string newPath) {
	return true;
}

bool DirectoryCopy(ref string path, string newPath) {
	return true;
}

bool DirectoryRename(ref string path, ref string newName) {
	return true;
}

string[] DirectoryList(ref DirectoryPlatformVars dirVars, ref string path) {
	return [];
}
