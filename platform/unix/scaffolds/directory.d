module platform.unix.scaffolds.directory;

import platform.unix.vars;
import platform.unix.common;

import core.string;
import core.file;
import core.main;

import utils.arraylist;

bool DirectoryOpen(ref DirectoryPlatformVars dirVars, ref String path)
{
	String pn;
	if (path == "")
	{
		pn = new String("/");
	}
	else
	{
		pn = new String(path);
	}

	pn.appendChar('\0');

	dirVars.dir = opendir(pn.ptr);
	return (dirVars.dir !is null);
}

bool DirectoryClose(ref DirectoryPlatformVars dirVars)
{
	closedir(dirVars.dir);
	return true;
}

String DirectoryGetBinary()
{
	return new String("/usr/bin");
}

String DirectoryGetAppData()
{
	return new String("/usr/share/") ~ Djehuty.getApplicationName();
}

String DirectoryGetTempData()
{
	return new String("/tmp/djp") ~ getpid();
}

String DirectoryGetUserData()
{
	static String cached;

	// user data: $HOME/.{appname}

	if (cached is null)
	{
		char* result;
		result = getenv("HOME\0"c.ptr);

		char[] homePath;

		char* cur = result;

		for(int i = 0; *cur != '\0'; cur++, i++) {}

		if (i != 0)
		{
			homePath = result[0..i];
			cached = new String(homePath) ~ "/." ~ Djehuty.getApplicationName();
		}
		else
		{
			cached = new String("");
		}
	}

	return cached;
}

String DirectoryGetApp()
{
	// Store result
	static String cached = null;

	if (cached is null)
	{
		String procPath = new String("/proc/") ~ getpid() ~ "/exe\0";

		size_t ret = -1;
		int len = 256;
		char[] path;

		while (ret == -1)
		{
			path = new char[len];
			ret = readlink(procPath.ptr, path.ptr, len-1);
			len <<= 1;
			if (ret == -1 && len > 32000)
			{
				// Error, path is too long
				cached = new String("");
				return cached;
			}
		}

		cached = new String(path[0..ret]);
	}

	return cached;
}

String DirectoryGetCWD()
{
	uint len = 512;
	char[] chrs;

	char* ptr;

	do
	{
		chrs = new char[len+1];
		ptr = getcwd(chrs.ptr, len);
		len <<= 1;
	} while (ptr is null);

	foreach (int i, chr; chrs)
	{
		if (chr == '\0')
		{
			chrs = chrs[0..i];
			break;
		}
	}

	return new String(chrs);
}

bool DirectoryFileIsDir(String path)
{
	String newPath = new String(path);
	newPath.appendChar('\0');

	struct_stat inode;

	if (stat(newPath.ptr, &inode) != -1)
	{
		if (S_ISDIR(inode.st_mode))
		{
			return true;
		}
	}

	return false;
}

bool DirectoryMove(ref String path, String newPath)
{
	String exec = new String("mv ") ~ path ~ " " ~ newPath ~ "\0";

	system(exec.ptr);
	return true;
}

bool DirectoryCopy(ref String path, String newPath)
{
	String exec = new String("cp -r ") ~ path ~ " " ~ newPath ~ "\0";

	system(exec.ptr);
	return true;
}

bool DirectoryRename(ref String path, ref String newName)
{
	String npath = new String(path);
	npath.appendChar('\0');

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

	rename(npath.ptr, str.ptr);
	return true;
}

String[] DirectoryList(ref DirectoryPlatformVars dirVars, ref String path)
{
	if (!DirectoryOpen(dirVars, path)) { return null; }

	dirent* dir;
	String[] list;

	// Retrieve first directory
	dir = readdir(dirVars.dir);

	while(dir !is null)
	{
		// Caculate Length of d_name
		int len;

		foreach(chr; dir.d_name)
		{
			if (chr == '\0')
			{
				break;
			}
			len++;
		}

		// Add to list
		if (dir.d_name[0..len] != "." && dir.d_name[0..len] != "..")
		{
			list ~= new String(dir.d_name[0..len]);
		}

		// Retrieve next item in the directory
		dir = readdir(dirVars.dir);
	}

	DirectoryClose(dirVars);

	return list;
}
