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
	return new String("");
}

String DirectoryGetCWD()
{
	return new String("");
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
