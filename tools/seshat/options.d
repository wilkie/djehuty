module options;

import djehuty;

import parsing.options;

class Opts : OptionParser {

	mixin Options!(
		"-build", "Specify the module to build",
		string, "the module to build"
	);

	void onBuild(string path) {
		_path = path;
	}

	string path() {
		return _path;
	}

private:
	string _path;
}
