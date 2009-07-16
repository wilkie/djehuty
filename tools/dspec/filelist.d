module filelist;

import core.definitions;
import core.string;

import io.file;
import io.directory;
import io.console;

class FileList
{
	bool fetch(inout String path)
	{
		sanitizePath(path);

		if (path.length == 0) { return false; }

		lookForFiles(path);

		return true;
	}

	String[] opApply()
	{
		return files;
	}

	int opApply(int delegate(ref String) dg)
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

	String[] files;
	//char[][] files;

	void sanitizePath(inout String path)
	{
		if (path.length == 0)
		{
			return;
		}

		if (path[path.length-1] == '.')
		{
			path = new String(path[0..path.length-1]);
		}

		if (path.length == 0)
		{
			return;
		}

		if (path[path.length-1] != '/')
		{
			path ~= '/';
		}
	}

	void lookForFiles(String path)
	{
		Console.putln("filelist created");

		sanitizePath(path);

		Directory dir = new Directory(path);
		auto dirs = dir.list();
		//auto dirs = std.file.listdir(path);

		string ext;
		//char[] ext;

		foreach (d; dirs)
		{
			if (d == "test.d") { continue; }
			int pos = d.find(new String("."));
			//int pos = find(d, '.');

			if (dir.isDir(d))
			//if (isdir(path ~ d))
			{
				lookForFiles(path ~ d);
			}

			if (pos > 0)
			{
				ext = d[pos..d.length];
			}
			else ext = null;

			switch (ext)
			{
				case ".d":
					files ~= new String(path) ~ d;
					//files ~= path ~ d;
					break;
				default:
					break;
			}
		}
	}
}