/*
 * directory.d
 *
 * This Scaffold holds the Directory implementations for the Linux platform
 *
 * Author: Dave Wilkinson
 *
 */

module scaffold.directory;

import platform.unix.common;
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
	string pn;
	if (path == "") {
		pn = "/";
	}
	else {
		pn = path.dup;
	}

	pn ~= '\0';

	dirVars.dir = opendir(pn.ptr);
	return (dirVars.dir !is null);
}

bool DirectoryCreate(ref DirectoryPlatformVars dirVars, ref string path) {
	if (DirectoryFileIsDir(path)) {
		return false;
	}

	string makedir = "mkdir " ~ path ~ "\0";

	system(makedir.ptr);

	return DirectoryOpen(dirVars,path);

}
bool DirectoryClose(ref DirectoryPlatformVars dirVars) {
	closedir(dirVars.dir);
	return true;
}

string DirectoryGetBinary() {
	return "/usr/bin";
}

string DirectoryGetAppData() {
	return "/usr/share/" ~ Djehuty.app.name;
}

string DirectoryGetTempData() {
	return "/tmp/djp" ~ toStr(getpid());
}

string DirectoryGetUserData() {
	static string cached;

	// user data: $HOME/.{appname}

	if (cached is null) {
		char* result;
		result = getenv("HOME\0"c.ptr);

		char[] homePath;

		char* cur = result;

		int i;
		for(i = 0; *cur != '\0'; cur++, i++) {}

		if (i != 0) {
			homePath = result[0..i];
			cached = homePath ~ "/." ~ Djehuty.app.name;
		}
		else {
			cached = "";
		}
	}

	return cached;
}

string DirectoryGetApp() {
	// Store result
	static string cached = null;

	if (cached is null) {
		string procPath = "/proc/" ~ toStr(getpid()) ~ "/exe\0";

		size_t ret = -1;
		int len = 256;
		char[] path;

		while (ret == -1) {
			path = new char[len];
			ret = readlink(procPath.ptr, path.ptr, len-1);
			len <<= 1;
			if (ret == -1 && len > 32000) {
				// Error, path is too long
				cached = "";
				return cached.dup;
			}
		}

		cached = path[0..ret].dup;
	}

	return cached.dup;
}

string DirectoryGetCWD() {
	uint len = 512;
	char[] chrs;

	char* ptr;

	do {
		chrs = new char[len+1];
		ptr = getcwd(chrs.ptr, len);
		len <<= 1;
	} while (ptr is null);

	foreach (int i, chr; chrs) {
		if (chr == '\0') {
			chrs = chrs[0..i];
			break;
		}
	}

	return chrs.dup;
}

bool DirectoryFileIsDir(string path) {
	string newPath = path.dup;
	newPath ~= '\0';

	struct_stat inode;

	if (stat(newPath.ptr, &inode) != -1) {
		if (S_ISDIR(inode.st_mode)) {
			return true;
		}
	}

	return false;
}
bool DirectoryMove(ref string path, string newPath) {
	string exec = "mv " ~ path ~ " " ~ newPath ~ "\0";

	system(exec.ptr);
	return true;
}

bool DirectoryCopy(ref string path, string newPath) {
	string exec = "cp -r " ~ path ~ " " ~ newPath ~ "\0";

	system(exec.ptr);
	return true;
}

bool DirectoryRename(ref string path, ref string newName) {
	string npath = path.dup;
	npath ~= '\0';

	string str;

	foreach_reverse(int i, chr; path) {
		if (chr == '/') {
			// truncate
			str = path[0..(i+1)].dup;
			break;
		}
	}

	if (str is null) { return false; }

	str ~= newName;
	str ~= '\0';
	
	rename(npath.ptr, str.ptr);
	return true;
}

string[] DirectoryList(ref DirectoryPlatformVars dirVars, ref string path) {
	if (!DirectoryOpen(dirVars, path)) { return null; } 

	dirent* dir;
	string[] list;

	// Retrieve first directory
	dir = readdir(dirVars.dir);

	while(dir !is null) {
		// Caculate Length of d_name
		int len;

		foreach(chr; dir.d_name) {
			if (chr == '\0') {
				break;
			}
			len++;
		}

		// Add to list
		if (dir.d_name[0..len] != "." && dir.d_name[0..len] != "..") {
			list ~= dir.d_name[0..len].dup;
		}

		// Retrieve next item in the directory
		dir = readdir(dirVars.dir);
	}

	DirectoryClose(dirVars);

	return list;
}
