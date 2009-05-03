module parser;

import core.string;
import console.main;

import filelist;
import output;

import feeder;
import parseunit;
import ast;

class Parser
{
	bool parseFiles(String outputPath, FileList files)
	{
		output = new Output(outputPath ~ "test.d");

		foreach(f; files)
		{
			if (!(parseFile(f)))
			{
				return false;
			}
		}
		
		output.finalizeOutput();

		return true;
	}

protected:

	Output output;

	bool parseFile(String path)
	{		
		Feeder feeder = new Feeder(path);

		// write out intentions
		Console.putln("Parsing ... ", path.array);

		parseUnit = new ParseDSpec();

		parseUnit.attachFeeder(feeder);

		Console.putln("Begin Parsing ... ", path.array);

		AST finished = parseUnit.parse();
		
		Console.putln("Done Parsing");

		output.work(finished);

		return true;
	}

	// parsing
	
	ParseUnit parseUnit;
}

bool isDelimiter(String s)
{
	if (s.length > 1 || s.length == 0)
	{
		return false;
	}
	
	foreach(cmp; delims)
	{
		if (cmp == s[0])
		{
			return true;
		}
	}
	
	return false;
}

class ParseDSpec : ParseUnit
{
	this()
	{
		// hook for describe section
		registerToken("describe", &parseDescribe);
		registerToken("import", &parseImport);
		
		// hook for comments
		//registerToken(...)
	}
	
	void parseDescribe()
	{
		AST ast = newParseUnit(new ParseDescribe());
		progressTree(ast);
	}
	
	void parseImport()
	{
		AST ast = newParseUnit(new ParseImport());
		progressTree(ast);		
	}
}

class ParseImport : ParseUnit
{
	String mod;

	this()
	{
		registerToken(";", &parseSemicolon);
		mod = new String("");
	}

	void parseSemicolon()
	{
		AST ast = new AST(null, null);
		ast.value = mod;
		progressTree(ast);
		
		done();
	}
	
	void parseDefault()
	{
		if (currentToken != "import")
		{
			mod ~= currentToken;
		}
	}
}

class ParseDescribe : ParseUnit
{
	this()
	{
		working = new String("");

		registerToken("describe", &parseDescribe);
		registerToken("it", &parseIt);
		registerToken("done", &parseDone);
		
		registerToken("{", &parseLeft);
		registerToken("}", &parseRight);
	}
	
protected:

	bool foundDescribe = false;
	bool foundName = false;
	bool foundLeft = false;
	
	String name;
	
	String working;

	void parseDescribe()
	{
		if (foundDescribe)
		{
			if (working.length > 0)
			{
				AST ast = new AST(null, null);
				ast.value = working;
				progressTree(ast);
			
				working = new String("");
			}
			AST section;
			section = newParseUnit(new ParseDescribeSection());
			
			progressTree(section);
		}
		else
		{
			foundDescribe = true;
		}
	}
	
	void parseIt()
	{
		if (working.length > 0)
		{
			AST ast = new AST(null, null);
			ast.value = working;
			progressTree(ast);

			working = new String("");
		}
			
		AST section;
		section = newParseUnit(new ParseIt());
			
		progressTree(section);
	}
	
	void parseDone()
	{
		if (working.length > 0)
		{
			AST ast = new AST(null, null);
			ast.value = working;
			progressTree(ast);

			working = new String("");
		}
			
		AST section;
		section = newParseUnit(new ParseDone());
		
		progressTree(section);
	}

	void parseLeft()
	{
		if (foundLeft)
		{
			// error
		}
		else
		{
			foundLeft = true;
		}
	}
	
	void parseRight()
	{
		if (!foundLeft)
		{
			// error
		}
		else
		{
			// done	
			if (working.length > 0)
			{
				AST ast = new AST(null, null);
				ast.value = working;
				progressTree(ast);

				working = new String("");
			}			
			done();
		}
	}
	
	void parseDefault()
	{
		if (foundDescribe && !foundName && !foundLeft && !isDelimiter(currentToken))
		{
			foundName = true;
			name = currentToken;
			Console.putln("Section: ", name.array);

			AST meta = new AST(null, new AST(null, null));
			meta.name = new String("Identifier");
			meta.right.value = name;
			progressTree(meta);
		}
		if (foundDescribe && foundName && foundLeft)
		{
			working ~= currentToken;
		}
	}	
}

class ParseDescribeSection : ParseUnit
{
	this()
	{
		working = new String("");

		registerToken("describe", &parseDescribe);
		registerToken("it", &parseIt);
		registerToken("done", &parseDone);
		
		registerToken("{", &parseLeft);
		registerToken("}", &parseRight);
	}
	
protected:
	
	bool foundDescribe = false;
	bool foundName = false;
	bool foundLeft = false;
	
	String name;

	String working;
	
	void parseDescribe()
	{
		if (foundDescribe)
		{
			// error
		}
		else
		{
			foundDescribe = true;
		}
	}
	
	void parseIt()
	{
		if (working.length > 0)
		{
			AST ast = new AST(null, null);
			ast.value = working;
			progressTree(ast);

			working = new String("");
		}
		
		AST section;
		section = newParseUnit(new ParseIt());
		
		progressTree(section);
	}
	
	void parseLeft()
	{
		if (foundLeft)
		{
			// error
		}
		else
		{
			foundLeft = true;
		}
	}
	
	void parseRight()
	{
		if (!foundLeft)
		{
			// error
		}
		else
		{
			// done
			if (working.length > 0)
			{
				AST ast = new AST(null, null);
				ast.value = working;
				progressTree(ast);

				working = new String("");
			}
			done();
		}
	}
	
	void parseDone()
	{
		if (working.length > 0)
		{
			AST ast = new AST(null, null);
			ast.value = working;
			progressTree(ast);

			working = new String("");
		}

		AST section;
		section = newParseUnit(new ParseDone());
		
		progressTree(section);
	}
	
	void parseDefault()
	{
		if (foundDescribe && !foundName && !foundLeft && !isDelimiter(currentToken))
		{
			foundName = true;
			name = currentToken;
			Console.putln("Class: ", name.array);
			
			AST meta = new AST(null, new AST(null, null));
			meta.name = new String("Identifier");
			meta.right.value = name;
			progressTree(meta);
		}
		if (foundDescribe && foundName && foundLeft)
		{
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

class ParseIt : ParseUnit
{
	this()
	{		
		working = new String("");

		registerToken("{", &parseLeft);
		registerToken("}", &parseRight);

		registerToken("it", &parseIt);

		registerToken("should", &parseShould);
		registerToken("shouldNot", &parseShould);
		registerToken("shouldThrow", &parseShould);
	}

	bool foundIt = false;
	bool foundName = false;
	bool foundLeft = false;

	String name;

	String working;

	void parseShould()
	{
		if(!foundIt)
		{
			// error
		}
		else
		{
			if (working.length > 0)
			{
				AST ast = new AST(null, null);
				ast.value = working;
				progressTree(ast);

				working = new String("");
			}

			AST section;
			if (currentToken == "should")
			{
				section = newParseUnit(new ParseShould());
			}
			else if (currentToken == "shouldThrow")
			{
				section = newParseUnit(new ParseShouldThrow());
			}
			else
			{
				section = newParseUnit(new ParseShouldNot());
			}

			progressTree(section);
		}
	}
	
	void parseIt()
	{
		if (!foundIt)
		{
			foundIt = true;
		}
	}
	
	void parseLeft()
	{
		if (foundLeft)
		{
			// error
		}
		else
		{
			foundLeft = true;
		}
	}
	
	void parseRight()
	{
		if (!foundLeft)
		{
			// error
		}
		else
		{
			// done
			if (working.length > 0)
			{
				AST ast = new AST(null, null);
				ast.value = working;
				progressTree(ast);

				working = new String("");
			}
			done();
		}
	}
	
	void parseDefault()
	{
		if (foundIt && !foundName && !foundLeft && !isDelimiter(currentToken))
		{
			foundName = true;
			name = currentToken;
			Console.putln("It: ", name.array);
			
			AST meta = new AST(null, new AST(null, null));
			meta.name = new String("Identifier");
			meta.right.value = name;
			progressTree(meta);

			ulong lnum = feeder.getLineNumber();
			meta = new AST(null, new AST(null, null));
			meta.name = new String("LineNumber");
			meta.right.value = lnum;
			progressTree(meta);
		}
		if (foundIt && foundName && foundLeft)
		{
			working ~= currentToken;
		}
	}
}

class ParseShould : ParseUnit
{
	this()
	{
		working = new String("");

		registerToken("(", &parseLeft);
		registerToken(")", &parseRight);
	}
	
	bool foundShould;
	
	uint parens = 0;
	
	String working;
	
	void parseLeft()
	{
		if (parens != 0)
		{
			working ~= currentToken;
		}
		parens++;
	}
	
	void parseRight()
	{
		parens--;
		if (parens == 0)
		{
			// done
			if (working.length > 0)
			{
				AST ast = new AST(null, null);
				ast.value = working;
				progressTree(ast);

				working = new String("");
			}
			done();
		}
		else
		{
			working ~= currentToken;
		}
	}
	
	void parseDefault()
	{
		if (currentToken == "should" && !foundShould)
		{
			foundShould = true;
		}
		else if (currentToken == "shouldNot" && !foundShould)
		{
			foundShould = true;
		}
		else if (currentToken == "shouldThrow" && !foundShould)
		{
			foundShould = true;
		}
		else
		{
			working ~= currentToken;
		}
	}
}

class ParseShouldNot : ParseShould
{
}

class ParseShouldThrow : ParseShould
{
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
	
	bool foundLeft = false;
	bool foundDone = false;
	bool foundBefore = false;
	
	String working;
	
	void parseDone()
	{
		if (foundDone)
		{
			// error
		}
		else
		{
			foundDone = true;
		}
	}
	
	void parseLeft()
	{
		if (foundLeft)
		{
			// error
		}
		else
		{
			foundLeft = true;
		}
	}
	
	void parseRight()
	{
		if (!foundLeft)
		{
			// error
		}
		else
		{
			// done
			if (working.length > 0)
			{
				AST ast = new AST(null, null);
				ast.value = working;
				progressTree(ast);

				working = new String("");
			}
			done();
		}
	}
	
	void parseBefore()
	{
		if (foundDone && !foundBefore && !foundLeft)
		{
			foundBefore = true;
		}
		else
		{
			 // error
		}
	}
	
	void parseDefault()
	{
		if (foundDone && foundBefore && foundLeft)
		{
			working ~= currentToken;
		}
	}
}