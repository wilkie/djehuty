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

String DirectoryGetApp()
{
	return _pfvars.appPath;
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
