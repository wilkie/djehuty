/*
 * dspec.d
 *
 * This tool will use the parser to parse specifications and produce tests
 *
 */

import io.console;

import core.main;
import core.string;
import core.unicode;
import core.arguments;
import core.application;
import core.definitions;

import filelist;
import parser;

import parsing.options;

char[] usage = `dspec rev1

USAGE: dspec [-I<PATH>]
EXAMPLE: dspec -Ispecs/.`;

class Opts : OptionParser {

	mixin Options!(
		"I", "Specify the path for the specs to be found, recursively",
		string, "the path",

		"-help", "View help and usage"
	);

	void onI(string path) {
		_path = path;
	}

	void onHelp() {
		showUsage();
		Djehuty.application.exit(0);
	}

	string path() {
		return _path;
	}

	string outputPath() {
		return _outputPath;
	}

private:
	string _path = ".";
	string _outputPath = ".specs";
}

class Dspec : Application {
	static this() { new Dspec(); }

	this() {
		super("djehuty-dspec");
	}

	override void onApplicationStart() {

		// Parse Options
		options = new Opts();

		// Interpret arguments

		string path = options.path;
		string outputPath = options.outputPath;

		Console.putln("Starting on path ", path);

		// Get the list of spec files
		FileList files = new FileList();
		if (!(files.fetch(path))) {
			Console.putln("error");
			return;
		}

		Parser parser = new Parser();
		if (!(parser.parseFiles(path, outputPath, files))) {
			Console.putln("error");
			return;
		}

		Console.putln("Test Routines Built: test.d in ", path);
	}

private:

	Opts options;
}
