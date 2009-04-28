module platform.win.scaffolds.directory;

import platform.win.vars;
import platform.win.common;

import core.string;
import core.file;
import core.main;
import core.unicode;

import console.main;

bool DirectoryOpen(ref DirectoryPlatformVars dirVars, ref String path)
{
	return false;
}

bool DirectoryClose(ref DirectoryPlatformVars dirVars)
{
	return false;
}

String DirectoryGetApp()
{
	int size = GetModuleFileNameW(null, null, 0);
	wchar[] dir = new wchar[size];
	GetModuleFileNameW(null, dir.ptr, size);

	if(size > 1)
	{
		dir[1] = dir[0];
		dir[0] = '/';
	}

	int pos;

	foreach(int i, chr; dir)
	{
     	if(chr == '\\')
		{
         	dir[i] = '/';
			pos = i;
		}
	}

	dir = dir[0..pos];

	return new String(dir);
}

String DirectoryGetCWD()
{
	int size = GetCurrentDirectoryW(0, null);
	wchar[] cwd = new wchar[size];
	GetCurrentDirectoryW(size, cwd.ptr);

	if(size > 1)
	{
		cwd[1] = cwd[0];
		cwd[0] = '/';
	}

	foreach(int i, chr; cwd)
	{
     	if(chr == '\\')
		{
         	cwd[i] = '/';
		}
	}

	return new String(cwd);
}

String[] DirectoryList(ref DirectoryPlatformVars dirVars, ref String path)
{
	DirectoryOpen(dirVars, path);

	WIN32_FIND_DATAW ffd;

	String pn = new String(path);
	pn.append("/*");
	pn.appendChar('\0');

	String[] list;

	HANDLE h = FindFirstFileW(pn.ptr, &ffd);
	bool cont = true;

	while(cont)
	{
		// Caculate Length of d_name
		int len;

		foreach(chr; ffd.cFileName)
		{
			if (chr == '\0')
			{
				break;
			}
			len++;
		}

		// Add to list
		if (ffd.cFileName[0..len] != "." && ffd.cFileName[0..len] != "..")
		{
			list ~= new String(ffd.cFileName[0..len]);
		}

		// Retrieve next item in the directory
		cont = FindNextFileW(h, &ffd) > 0;
	}

	DirectoryClose(dirVars);

	return list;
}
