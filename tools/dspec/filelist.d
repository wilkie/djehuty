module filelist;

import core.definitions;
import core.string;

import io.file;
import io.directory;
import io.console;

class FileList {
	bool fetch(inout string path) {
		sanitizePath(path);
		if (path.length == 0) { return false; }

		lookForFiles(path);

		return true;
	}

	string[] opApply() {
		return files;
	}

	int opApply(int delegate(ref string) dg) {
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

	string[] files;
	//char[][] files;

	void sanitizePath(inout string path) {
		if (path.length == 0) {
			return;
		}

		if (path[path.length-1] == '.') {
			path = path[0..path.length-1].dup;
		}

		if (path.length == 0) {
			return;
		}

		if (path[path.length-1] != '/') {
			path ~= '/';
		}
	}

	void lookForFiles(string path) {
		//Console.putln("filelist created");

		sanitizePath(path);

		Directory dir = new Directory(path);
		auto dirs = dir.list();

		//auto dirs = std.file.listdir(path);

		string ext;
		//char[] ext;

		foreach (d; dirs) {
			//Console.putln(d);
			if (d == "test.d") { continue; }
			int pos = d.find(".");
			//int pos = find(d, '.');

			if (dir.isDir(d)) {
				//Console.putln("is dir1");
				lookForFiles(path ~ d);
			}

			if (pos > 0) {
				ext = d[pos..d.length];
			}
			else ext = null;

			switch (ext) {
				case ".d":
					files ~= path ~ d;
					//files ~= path ~ d;
					break;
				default:
					break;
			}
		}
	}
}
