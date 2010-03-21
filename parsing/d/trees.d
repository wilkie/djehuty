module parsing.d.trees;

import parsing.ast;

import io.console;

class Import : AbstractSyntaxTree {
	this(string packageName) {
		Console.putln("Import: ", packageName);
		_packageName = packageName;
	}

	string packageName() {
		return _packageName;
	}

protected:
	string _packageName;
}