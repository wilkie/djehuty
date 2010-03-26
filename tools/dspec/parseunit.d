module parseunit;

import feeder;
import ast;

import core.string;
import core.unicode;
import core.definitions;

import io.console;

class ParseUnit {
	final void attachFeeder(Feeder feed) {
		feeder = feed;
	}

	final AST parse() {
		// get class name
		ClassInfo ci = this.classinfo;
		string className = ci.name.dup;

		//Console.putln("CLASS: ", className.array);

		original = new AST(null,null);
		parseTree = original;

		string[] foo = className.split('.');
		className = foo[$-1];
		//Console.putln("CLASS: ", className.array);

		parseTree.name = className;

		for(;;) {
			if (tokens is null) {
				tokens = feeder.feed();
				idx = 0;

				if (tokens is null) {
					break;
				}
			}

			for( ; idx < tokens.length ; idx++) {
				currentToken = tokens[idx];
				if (currentToken in parseFunctions) {
					parseFunctions[currentToken]();
				}
				else {
					parseDefault();
				}

				// Finished?
				if (iAmDone) { idx++; return original; }
			}

			// get more
			tokens = feeder.feed();
			idx=0;
		}

		return original;
	}
	
	void progressTree(AST right) {
		if (parseTree.right !is null && parseTree.left is null) {
			parseTree.left = new AST(null, null);
			parseTree = parseTree.left;
		}
				
		parseTree.right = right;

		if (parseTree !is original && right !is null && right.valueType == AST.ValueType.Name) {
			string val;
			right.getValue(val);
			parseTree.hint = val;
		}
	}
	
protected:

	// feed state
	static string[] tokens;
	static uint idx;

	static Feeder feeder;

	alias void delegate() ParseFunction;

	ParseFunction[string] parseFunctions;

	ParseUnit parseUnit;
	
	AST parseTree;
	AST original;

	bool iAmDone;
	
	string currentToken;
	
	AST newParseUnit(ParseUnit newUnit) {
		parseUnit = newUnit;
		return parseUnit.parse();
	}
	
	void done() {
		iAmDone = true;
	}
	
	void registerToken(string token, ParseFunction func) {
		parseFunctions[token] = func;
	}
	
	void parseDefault() {
		return;
	}
}
