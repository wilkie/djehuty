/*
 * directory.d
 *
 * This file implements the Scaffold for platform specific Directory
 * traversal in Windows.
 *
 * Author: Dave Wilkinson
 *
 */

module scaffold.directory;

pragma(lib, "netapi32.lib");
pragma(lib, "mpr.lib");

import binding.win32.winnt;
import binding.win32.winuser;
import binding.win32.winbase;
import binding.win32.windef;

import platform.vars.directory;

import core.string;
import core.main;
import core.unicode;

import io.console;
import io.file;

bool DirectoryOpen(ref DirectoryPlatformVars dirVars, ref string path) {
	if (DirectoryFileIsDir(path)) {
		return true;
	}

	return false;
}

bool DirectoryCreate(ref DirectoryPlatformVars dirVars, ref string path) {
	wchar[] strArr = _ConvertFrameworkPath(Unicode.toUtf16(path));
	strArr ~= '\0';
	
	if (DirectoryFileIsDir(path)) {
		return false;
	}

	if(CreateDirectoryW(strArr.ptr,null) != 0){
		return true;
	}
	
	return false;
}

bool DirectoryClose(ref DirectoryPlatformVars dirVars) {
	return false;
}

string DirectoryGetBinary() {
	static string cached;

	// %PROGRAMFILES%

	if (cached is null) {
		wchar[] str;

		int ret = GetEnvironmentVariableW("PROGRAMFILES\0"w.ptr, null, 0);

		str = new wchar[ret];
		ret = GetEnvironmentVariableW("PROGRAMFILES\0"w.ptr, str.ptr, ret);

		str = _SanitizeWindowsPath(str[0..ret]);

		cached = Unicode.toUtf8(str) ~ "/" ~ Djehuty.app.name;
	}

	return cached;
}

string DirectoryGetAppData() {
	static string cached;

	// %PROGRAMFILES%

	if (cached is null) {
		wchar[] str = new wchar[5];

		int ret = GetEnvironmentVariableW("PROGRAMFILES\0"w.ptr, str.ptr, 0);

		str = new wchar[ret];
		ret = GetEnvironmentVariableW("PROGRAMFILES\0"w.ptr, str.ptr, ret);

		str = _SanitizeWindowsPath(str[0..ret]);

		cached = Unicode.toUtf8(str) ~ "/" ~ Djehuty.app.name;
	}

	return cached;
}

string DirectoryGetTempData() {
	static string cached;

	if (cached is null) {
		int ret = GetTempPathW(0, null);
		ret++;

		wchar[] str = new wchar[ret];

		ret = GetTempPathW(ret, str.ptr);
		str = _SanitizeWindowsPath(str[0..ret]);

		cached = Unicode.toUtf8(str) ~ "/dpj" ~ toStr(GetCurrentProcessId());
	}

	return cached;
}

string DirectoryGetUserData() {
	static string cached;

	// %APPDATA%

	if (cached is null) {
		wchar[] str;

		int ret = GetEnvironmentVariableW("APPDATA\0"w.ptr, null, 0);

		str = new wchar[ret];
		ret = GetEnvironmentVariableW("APPDATA\0"w.ptr, str.ptr, ret);

		str = _SanitizeWindowsPath(str[0..ret]);

		cached = Unicode.toUtf8(str) ~ "/" ~ Djehuty.app.name;
	}

	return cached;
}

string DirectoryGetApp() {
	int size = 512;
	int ret = 0;

	wchar[] dir;

	do {
		dir = new wchar[size];
		ret = GetModuleFileNameW(null, dir.ptr, size);
		size <<= 2;
	} while (size == ret)

	if (ret > 0) {
		dir = dir[0..ret-1];
	}

	dir = _SanitizeWindowsPath(dir);
	dir = _TruncateFileName(dir);

	return Unicode.toUtf8(dir);
}

string DirectoryGetCWD() {
	int size = GetCurrentDirectoryW(0, null);
	wchar[] cwd = new wchar[size];
	GetCurrentDirectoryW(size, cwd.ptr);
	cwd = cwd[0..$-1];

	cwd = _SanitizeWindowsPath(cwd);

	return Unicode.toUtf8(cwd);
}

bool DirectoryFileIsDir(string path) {
	wchar[] strArr = _ConvertFrameworkPath(Unicode.toUtf16(path));
	strArr ~= '\0';

	DWORD ret = GetFileAttributesW(strArr.ptr);

	return (ret & FILE_ATTRIBUTE_DIRECTORY) > 0;
}

bool DirectoryRename(ref string path, string newName) {
	string old = path.dup;
	old ~= '\0';

	string str;

	foreach_reverse(int i, chr; path) {
		if (chr == '/') {
			// truncate
			str = path[0..i];
			break;
		}
	}

	if (str is null) {
		return false;
	}

	str ~= '/';
	str ~= newName;
	str ~= '\0';

	wchar[] strArr = _ConvertFrameworkPath(Unicode.toUtf16(str));
	wchar[] oldArr = _ConvertFrameworkPath(Unicode.toUtf16(old));

	MoveFileW(oldArr.ptr, strArr.ptr);
	return true;
}

bool DirectoryMove(ref string path, string newPath) {
	string old = path.dup;
	old ~= '\0';

	string str = newPath.dup;
	str ~= '\0';

	wchar[] strArr = _ConvertFrameworkPath(Unicode.toUtf16(str));
	wchar[] oldArr = _ConvertFrameworkPath(Unicode.toUtf16(old));

	MoveFileW(oldArr.ptr, strArr.ptr);
	return true;
}

bool DirectoryCopy(ref string path, string newPath) {
	string old = path.dup;
	old ~= '\0';

	string str = newPath.dup;
	str ~= '\0';

	wchar[] strArr = _ConvertFrameworkPath(Unicode.toUtf16(str));
	wchar[] oldArr = _ConvertFrameworkPath(Unicode.toUtf16(old));

	CopyFileW(oldArr.ptr, strArr.ptr, 0);
	return true;
}

string[] _ReturnSharedFolders(wchar[] serverName) {
	// Read all drives on this server
	string[] ret;
/*
	SHARE_INFO_0* bufptr;

	DWORD dwEntriesRead;
	DWORD dwTotalEntries;
	DWORD dwResumeHandle;

	uint MAX_PREFERRED_LENGTH = short.max;

	NetShareEnum(serverName.ptr, 0, cast(void**)&bufptr, -1,
		&dwEntriesRead, &dwTotalEntries, &dwResumeHandle);

	NetApiBufferFree(cast(void*)bufptr);

	foreach(shareItem; bufptr[0..dwEntriesRead]) {
		wchar[] pcchrs = shareItem.shi0_netname[0..strlen(shareItem.shi0_netname)];
		if (pcchrs.length > 0 && pcchrs[$-1] != '$') {
			ret ~= new String(Unicode.toUtf8(pcchrs));
		}
	}
*/
	return ret;
}

string[] _ReturnNetworkComputers() {
	string[] ret;
/*
	HANDLE enumWorkgroupHandle;

	DWORD bufferSize = 16284;

	NETRESOURCEW[16284 / NETRESOURCEW.sizeof] networkResource;
	WNetOpenEnumW(RESOURCE_GLOBALNET, RESOURCETYPE_ANY, 0, null, &enumWorkgroupHandle);

	DWORD numEntries = -1;
	WNetEnumResourceW(enumWorkgroupHandle, &numEntries, cast(void*)networkResource.ptr, &bufferSize);

	foreach(item; networkResource[0..numEntries]) {
		HANDLE subWorkgroupHandle;
		WNetOpenEnumW(RESOURCE_GLOBALNET, RESOURCETYPE_ANY, 0, &item, &subWorkgroupHandle);
		DWORD subEntries = -1;
		NETRESOURCEW[16284 / NETRESOURCEW.sizeof] subResource;
		DWORD subSize = 16284;
		WNetEnumResourceW(subWorkgroupHandle, &subEntries, cast(void*)subResource.ptr, &subSize);

		foreach(subitem; subResource[0..subEntries]) {
			if (subitem.lpRemoteName !is null && subitem.dwDisplayType & RESOURCEDISPLAYTYPE_GROUP) {

				// Read all computers on this workgroup

				SERVER_INFO_101* bufptr;

				DWORD dwEntriesRead;
				DWORD dwTotalEntries;
				DWORD dwResumeHandle;

				uint MAX_PREFERRED_LENGTH = short.max;
				NetServerEnum(null, 101, cast(void**)&bufptr, MAX_PREFERRED_LENGTH,
					&dwEntriesRead, &dwTotalEntries, SV_TYPE_ALL, subitem.lpRemoteName, &dwResumeHandle);

				SERVER_INFO_101* tmpptr = bufptr;
				foreach(pcitem; tmpptr[0..dwEntriesRead]) {
					wchar[] pcchrs = pcitem.sv101_name[0..strlen(pcitem.sv101_name)];
					ret ~= new String(Unicode.toUtf8(pcchrs));
				}

				NetApiBufferFree(cast(void*)bufptr);
			}
		}

		WNetCloseEnum(subWorkgroupHandle);
	}

	WNetCloseEnum(enumWorkgroupHandle);

	SERVER_INFO_101* bufptr;

	DWORD dwEntriesRead;
	DWORD dwTotalEntries;
	DWORD dwResumeHandle;

	uint MAX_PREFERRED_LENGTH = short.max;
	NetServerEnum(null, 101, cast(void**)&bufptr, MAX_PREFERRED_LENGTH,
		&dwEntriesRead, &dwTotalEntries, SV_TYPE_ALL, null, &dwResumeHandle);

	SERVER_INFO_101* tmpptr = bufptr;
	foreach(pcitem; tmpptr[0..dwEntriesRead]) {
		wchar[] pcchrs = pcitem.sv101_name[0..strlen(pcitem.sv101_name)];
		// do not let in a duplicate
		String thisPC = new String(Unicode.toUtf8(pcchrs));
		bool isThere = false;
		foreach(strFound; ret) {
			if (strFound == thisPC) {
				isThere = true;
				break;
			}
		}
		if (!isThere) {
			ret ~= thisPC;
		}
	}

	NetApiBufferFree(cast(void*)bufptr);
*/
	return ret;
}

wchar[] _SanitizeWindowsPath(wchar[] tmp) {
	if (tmp.length == 0) { return tmp; }

	// Handle networks

	if (tmp.length > 1 && tmp[0..2] == "\\\\") {
		tmp = "/network" ~ tmp[1..$];
	}

	// Change C: to /c

	if (tmp.length > 1 && tmp[0] != '/') {
		tmp[1] = tmp[0];
		tmp[0] = '/';
	}

	// Convert slashes

	foreach(int i, chr; tmp) {
     	if(chr == '\\') {
         	tmp[i] = '/';
		}
	}

	// Remove final slash
	if (tmp[tmp.length-1] == '/') {
		tmp = tmp[0..tmp.length-1];
	}

	return tmp;
}

wchar[] _TruncateFileName(wchar[] tmp) {
	if (tmp.length == 0) { return tmp; }

	foreach_reverse(int i, chr; tmp) {
     	if(chr == '/') {
			return tmp[0..i];
		}
	}

	return tmp;
}

wchar[] _ConvertFrameworkPath(wchar[] tmp) {
	if (tmp.length == 0) { return tmp; }

	// Handle networks

	if (tmp.length > 9 && tmp[0..9] == "/network/") {
		tmp = "\\\\" ~ tmp[9..$];
	}

	// Change /c to C:

	if (tmp.length > 1 && tmp[0] == '/') {
		tmp[0] = tmp[1];
		tmp[1] = ':';
	}

	// No need to convert slashes, windows api accepts POSIX paths

	return tmp;
}

string[] DirectoryList(ref DirectoryPlatformVars dirVars, string path) {

	// trim trailing slash
	if (path.length > 0 && path[path.length - 1] == '/' || path[path.length - 1] == '\\') {
		path = path[0..path.length-1];
	}

	string newpath = path.dup;
	newpath = Unicode.toUtf8(_ConvertFrameworkPath(Unicode.toUtf16(newpath)));

	string[] list;

	if (newpath == "") {
		// root directory listing
		// that is, list the network folder and all drives

		int logicaldrives = GetLogicalDrives();

		string curDrive = ['a'];

		while(logicaldrives != 0) {
			if ((logicaldrives & 1) == 1) {
				list ~= curDrive.dup;
			}

			if (curDrive[0] == 'z') { break; }

			curDrive[0]++;
			logicaldrives >>= 1;
		}

		list ~= "network";
		return list;
	}
	/*else if (path.length >= 8 && path[0..8] == "/network") {
		// Get relative path to /network
		if (path.length == 8) {
			return _ReturnNetworkComputers;
		}
		else {
			String newPath = path.subString(9);
			// find next slash (if there is one)
			int pos = newPath.find("/");
			if (pos == -1) {
				// Just a pcname
				return _ReturnSharedFolders(newPath.toUtf16 ~ "\0"w);
			}
			else {
				// Fall through to normal directory listing
			}
		}
	}*/
	// regular directory listing
	DirectoryOpen(dirVars, newpath);

	WIN32_FIND_DATAW ffd;

	wstring pn = Unicode.toUtf16(newpath);
	pn ~= "/*";
	pn ~= '\0';

	HANDLE h = FindFirstFileW(pn.ptr, &ffd);
	bool cont = true;

	while(cont) {
		// Caculate Length of d_name
		int len;

		foreach(chr; ffd.cFileName) {
			if (chr == '\0') {
				break;
			}
			len++;
		}

		// Add to list
		if (ffd.cFileName[0..len] != "." && ffd.cFileName[0..len] != "..") {
			list ~= Unicode.toUtf8(ffd.cFileName[0..len]);
		}

		// Retrieve next item in the directory
		cont = FindNextFileW(h, &ffd) > 0;
	}

	DirectoryClose(dirVars);
	return list;
}
