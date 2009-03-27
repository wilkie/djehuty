module filelist;

import std.file;
import std.string;

class FileList
{
	bool fetch(inout char[] path)
	{
		sanitizePath(path);
	
		if (path.length == 0) { return false; }
	
		lookForFiles(path);
		
		return true;
	}
	
	char[][] opApply()
	{
		return files;
	}    
	
	int opApply(int delegate(ref char[]) dg)
    {   
    	int result = 0;

		for (int i = 0; i < files.length; i++)
		{
			result = dg(files[i]);
			if (result)
			break;
		}
		return result;
    }

	
protected:

	char[][] files;

	void sanitizePath(inout char[] path)
	{
		if (path.length == 0)
		{
			return;
		}

		if (path[length-1] == '.')
		{
			path = path[0..$-1];
		}

		if (path.length == 0)
		{
			return;
		}

		if (path[length-1] != '/')
		{
			path ~= '/';
		}
	}

	void lookForFiles(char[] path)
	{
		sanitizePath(path);

		auto dirs = std.file.listdir(path);

		char[] ext;

		foreach (d; dirs)
		{
			int pos = find(d, '.');

			if (isdir(path ~ d))
			{
				lookForFiles(path ~ d);
			}

			if (pos > 0)
			{
				ext = d[pos..$];
			}
			else ext = null;

			switch (ext)
			{
				case ".d":
					files ~= path ~ d;
					break;
				default:
					break;
			}
		}
	}
}