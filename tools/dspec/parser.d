module parser;

import djehuty;

import io.console;

import filelist;
import output;

import feeder;
import parseunit;
import ast;

class Parser {
	bool parseFiles(string outputPath, FileList files) {
		output = new Output(outputPath ~ "test.d");

		foreach(f; files) {
			if (!(parseFile(f))) {
				return false;
			}
		}

		output.finalizeOutput();

		return true;
	}

protected:

	Output output;

	bool parseFile(string path) {
		Feeder feeder = new Feeder(path);

		// write out intentions
		//Console.putln("Parsing ... ", path.array);

		parseUnit = new ParseDSpec();

		parseUnit.attachFeeder(feeder);

		//Console.putln("Begin Parsing ... ", path.array);

		AST finished = parseUnit.parse();

		//Console.putln("Done Parsing");

		output.work(finished, path);

		return true;
	}

	// parsing

	ParseUnit parseUnit;
}

bool isDelimiter(string s) {
	if (s.length > 1 || s.length == 0) {
		return false;
	}

	foreach(cmp; delims) {
		if (cmp == s[0]) {
			return true;
		}
	}

	return false;
}

class ParseDSpec : ParseUnit {
	this() {
		// hook for describe section
		registerToken("describe", &parseDescribe);
		registerToken("import", &parseImport);

		// hook for comments
		//registerToken(...)
	}

	void parseDescribe() {
		AST ast = newParseUnit(new ParseDescribe());
		progressTree(ast);
	}

	void parseImport() {
		AST ast = newParseUnit(new ParseImport());
		progressTree(ast);
	}
}

class ParseImport : ParseUnit {
	string mod;

	this() {
		registerToken(";", &parseSemicolon);
		mod = "";
	}

	void parseSemicolon() {
		AST ast = new AST(null, null);
		ast.value = mod;
		progressTree(ast);

		done();
	}

	void parseDefault() {
		if (currentToken != "import") {
			mod ~= currentToken;
		}
	}
}

class ParseDescribe : ParseUnit {
	this() {
		working = "";

		registerToken("describe", &parseDescribe);
		registerToken("it", &parseIt);
		registerToken("done", &parseDone);

		registerToken("{", &parseLeft);
		registerToken("}", &parseRight);
	}

protected:

	bool foundDescribe = false;
	bool foundName = false;
	int foundLeft = 0;

	string name;

	string working;

	void parseDescribe() {
		if (foundDescribe) {
			if (working.length > 0) {
				AST ast = new AST(null, null);
				ast.value = working;
				progressTree(ast);

				working = "";
			}
			AST section;
			section = newParseUnit(new ParseDescribeSection());

			progressTree(section);
		}
		else {
			foundDescribe = true;
		}
	}

	void parseIt() {
		if (working.length > 0) {
			AST ast = new AST(null, null);
			ast.value = working;
			progressTree(ast);

			working = "";
		}

		AST section;
		section = newParseUnit(new ParseIt());

		progressTree(section);
	}

	void parseDone() {
		if (working.length > 0) {
			AST ast = new AST(null, null);
			ast.value = working;
			progressTree(ast);

			working = "";
		}

		AST section;
		section = newParseUnit(new ParseDone());

		progressTree(section);
	}

	void parseLeft() {
		foundLeft++;
		if (foundLeft > 1) {
			working ~= currentToken;
		}
	}

	void parseRight() {
		foundLeft--;
		if (foundLeft == 0) {
			// done
			if (working.length > 0) {
				AST ast = new AST(null, null);
				ast.value = working;
				progressTree(ast);

				working = "";
			}
			done();
		}
		else {
			working ~= currentToken;
		}
	}

	void parseDefault() {
		if (foundDescribe && !foundName && !foundLeft && !isDelimiter(currentToken)) {
			foundName = true;
			name = currentToken;
			//Console.putln("Section: ", name.array);

			AST meta = new AST(null, new AST(null, null));
			meta.name = "Identifier";
			meta.right.value = name;
			progressTree(meta);
		}
		if (foundDescribe && foundName && foundLeft) {
			working ~= currentToken;
		}
	}
}

class ParseDescribeSection : ParseUnit
{
	this() {
		working = "";

		registerToken("describe", &parseDescribe);
		registerToken("it", &parseIt);
		registerToken("done", &parseDone);

		registerToken("{", &parseLeft);
		registerToken("}", &parseRight);
	}

protected:

	bool foundDescribe = false;
	bool foundName = false;
	int foundLeft = 0;

	string name;

	string working;

	void parseDescribe() {
		if (foundDescribe) {
			// error
		}
		else {
			foundDescribe = true;
		}
	}

	void parseIt() {
		if (working.length > 0) {
			AST ast = new AST(null, null);
			ast.value = working;
			progressTree(ast);

			working = "";
		}

		AST section;
		section = newParseUnit(new ParseIt());

		progressTree(section);
	}

	void parseLeft() {
		foundLeft++;
		if (foundLeft > 1) {
			working ~= currentToken;
		}
	}

	void parseRight() {
		foundLeft--;
		if (foundLeft == 0) {
			// done
			if (working.length > 0) {
				AST ast = new AST(null, null);
				ast.value = working;
				progressTree(ast);

				working = "";
			}
			done();
		}
		else {
			working ~= currentToken;
		}
	}

	void parseDone() {
		if (working.length > 0) {
			AST ast = new AST(null, null);
			ast.value = working;
			progressTree(ast);

			working = "";
		}

		AST section;
		section = newParseUnit(new ParseDone());

		progressTree(section);
	}

	void parseDefault() {
		if (foundDescribe && !foundName && !foundLeft && !isDelimiter(currentToken)) {
			foundName = true;
			name = currentToken;
			//Console.putln("Class: ", name.array);

			AST meta = new AST(null, new AST(null, null));
			meta.name = "Identifier";
			meta.right.value = name;
			progressTree(meta);
		}
		if (foundDescribe && foundName && foundLeft) {
			working ~= currentToken;
		}
	}

	// Parses:

	// describe section {
	//
	//     it should {
	//     }
	//
	// }

	// Passes off control:

	// ParseIt()
	// ParseDescribe()

}

class ParseIt : ParseUnit {
	this() {
		working = "";

		registerToken("{", &parseLeft);
		registerToken("}", &parseRight);

		registerToken("it", &parseIt);

		registerToken("should", &parseShould);
		registerToken("shouldNot", &parseShould);
		registerToken("shouldThrow", &parseShould);
	}

	bool foundIt = false;
	bool foundName = false;
	int foundLeft = 0;

	string name;

	string working;

	void parseShould() {
		if(!foundIt) {
			// error
		}
		else {
			if (working.length > 0) {
				AST ast = new AST(null, null);
				ast.value = working;
				progressTree(ast);

				working = "";
			}

			AST section;
			if (currentToken == "should") {
				section = newParseUnit(new ParseShould());
			}
			else if (currentToken == "shouldThrow") {
				section = newParseUnit(new ParseShouldThrow());
			}
			else {
				section = newParseUnit(new ParseShouldNot());
			}

			progressTree(section);
		}
	}

	void parseIt() {
		if (!foundIt) {
			foundIt = true;
		}
	}

	void parseLeft() {
		foundLeft++;
		if (foundLeft > 1) {
			working ~= currentToken;
		}
	}

	void parseRight() {
		foundLeft--;
		if (foundLeft == 0) {
			// done
			if (working.length > 0) {
				AST ast = new AST(null, null);
				ast.value = working;
				progressTree(ast);

				working = "";
			}
			done();
		}
		else {
			working ~= currentToken;
		}
	}

	void parseDefault() {
		if (foundIt && !foundName && !foundLeft && !isDelimiter(currentToken)) {
			foundName = true;
			name = currentToken;
			//Console.putln("It: ", name.array, " @ ", feeder.getLineNumber());

			AST meta = new AST(null, new AST(null, null));
			meta.name = "Identifier";
			meta.right.value = name;
			progressTree(meta);

			ulong lnum = feeder.getLineNumber();
			meta = new AST(null, new AST(null, null));
			meta.name = "LineNumber";
			meta.right.value = lnum;
			progressTree(meta);
		}
		if (foundIt && foundName && foundLeft) {
			working ~= currentToken;
		}
	}
}

class ParseShould : ParseUnit {
	this() {
		working = "";

		registerToken("(", &parseLeft);
		registerToken(")", &parseRight);
	}

	bool foundShould;

	uint parens = 0;

	string working;

	void parseLeft() {
		if (parens != 0) {
			working ~= currentToken;
		}
		parens++;
	}

	void parseRight() {
		parens--;
		if (parens == 0) {
			// done
			if (working.length > 0) {
				AST ast = new AST(null, null);
				ast.value = working;
				progressTree(ast);

				working = "";
			}
			done();
		}
		else {
			working ~= currentToken;
		}
	}

	void parseDefault() {
		if (currentToken == "should" && !foundShould) {
			foundShould = true;
		}
		else if (currentToken == "shouldNot" && !foundShould) {
			foundShould = true;
		}
		else if (currentToken == "shouldThrow" && !foundShould) {
			foundShould = true;
		}
		else {
			working ~= currentToken;
		}
	}
}

class ParseShouldNot : ParseShould {
}

class ParseShouldThrow : ParseShould {
}

class ParseDone : ParseUnit
{
	this()
	{		
		registerToken("done", &parseDone);
		registerToken("before", &parseBefore);
		
		registerToken("{", &parseLeft);
		registerToken("}", &parseRight);
	}
	
	int foundLeft = 0;
	bool foundDone = false;
	bool foundBefore = false;
	
	string working;
	
	void parseDone() {
		if (foundDone) {
			// error
		}
		else {
			foundDone = true;
		}
	}

	void parseLeft() {
		foundLeft++;
		if (foundLeft > 1) {
			working ~= currentToken;
		}
	}

	void parseRight() {
		foundLeft--;
		if (foundLeft == 0) {
			// done
			if (working.length > 0) {
				AST ast = new AST(null, null);
				ast.value = working;
				progressTree(ast);

				working = "";
			}
			done();
		}
		else {
			working ~= currentToken;
		}
	}

	void parseBefore() {
		if (foundDone && !foundBefore && !foundLeft) {
			foundBefore = true;
		}
		else {
			 // error
		}
	}

	void parseDefault() {
		if (foundDone && foundBefore && foundLeft) {
			working ~= currentToken;
		}
	}
}
