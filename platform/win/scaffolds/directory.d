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
	int size = 512;
	int ret = 0;

	wchar[] dir;

	do
	{
		dir = new wchar[size];
		ret = GetModuleFileNameW(null, dir.ptr, size);
		size <<= 2;
	} while (size == ret)

	if (dir.length > 0)
	{
		dir = dir[0..$-1];
	}

	dir = _SanitizeWindowsPath(dir);
	dir = _TruncateFileName(dir);

	return new String(dir);
}

String DirectoryGetCWD()
{
	int size = GetCurrentDirectoryW(0, null);
	wchar[] cwd = new wchar[size];
	GetCurrentDirectoryW(size, cwd.ptr);
	cwd = cwd[0..$-1];
	
	cwd = _SanitizeWindowsPath(cwd);

	wchar[] poop = _SanitizeWindowsPath("\\\\DAVE-PC\\Public\\Favorites");
	Console.putln(poop);
	poop = _ConvertFrameworkPath(poop);
	Console.putln(poop);

	return new String(cwd);
}

wchar[] _SanitizeWindowsPath(wchar[] tmp)
{
	if (tmp.length == 0) { return tmp; }
	
	// Handle networks

	if (tmp.length > 1 && tmp[0..2] == "\\\\")
	{
		tmp = "/network" ~ tmp[1..$];
	}

	// Change C: to /c

	if (tmp.length > 1 && tmp[0] != '/')
	{
		tmp[1] = tmp[0];
		tmp[0] = '/';
	}

	// Convert slashes

	foreach(int i, chr; tmp)
	{
     	if(chr == '\\')
		{
         	tmp[i] = '/';
		}
	}

	return tmp;
}

wchar[] _TruncateFileName(wchar[] tmp)
{
	if (tmp.length == 0) { return tmp; }

	foreach_reverse(int i, chr; tmp)
	{
     	if(chr == '/')
		{
			return tmp[0..i];
		}
	}
	
	return tmp;
}

wchar[] _ConvertFrameworkPath(wchar[] tmp)
{
	if (tmp.length == 0) { return tmp; }
	
	// Handle networks

	if (tmp.length > 9 && tmp[0..9] == "/network/")
	{
		tmp = "\\\\" ~ tmp[9..$];
	}

	// Change /c to C:

	if (tmp.length > 1 && tmp[0] == '/')
	{
		tmp[0] = tmp[1];
		tmp[1] = ':';
	}

	// No need to convert slashes, windows api accepts POSIX paths
	
	return tmp;
}

String[] DirectoryList(ref DirectoryPlatformVars dirVars, ref String path)
{
	path = new String(_ConvertFrameworkPath(path.array));
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
