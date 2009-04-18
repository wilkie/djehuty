module platform.unix.scaffolds.directory;

import platform.unix.vars;
import platform.unix.common;

import core.string;
import core.file;
import core.main;

import utils.arraylist;

bool DirectoryOpen(ref DirectoryPlatformVars dirVars, ref String path)
{
	String pn = new String(path);
	pn.appendChar('\0');

	dirVars.dir = opendir(pn.ptr);
	return (dirVars.dir !is null);
}

bool DirectoryClose(ref DirectoryPlatformVars dirVars)
{
	closedir(dirVars.dir);
	return true;
}

ArrayList!(String) DirectoryList(ref DirectoryPlatformVars dirVars, ref String path)
{
	if (!DirectoryOpen(dirVars, path)) { return null; }

	dirent* dir;
	ArrayList!(String) list = new ArrayList!(String)();

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
			String name = new String(dir.d_name[0..len]);
			list.addItem(name);
		}

		// Retrieve next item in the directory
		dir = readdir(dirVars.dir);
	}

	DirectoryClose(dirVars);

	return list;
}
