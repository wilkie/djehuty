module options;

import djehuty;

import parsing.options;

class Opts : OptionParser {

	mixin Options!(
		"-file", "Specify the name of the executable to build",
		string, "the name of the executable to build",
		"-build", "Specify the module to build",
		string, "the module to build"
	);

	void onFile(string path) {
		_file = path;
	}

	void onBuild(string path) {
		_path = path;
	}

	string path() {
		return _path;
	}

	string file() {
		return _file;
	}

private:
	string _file;
	string _path;
}
