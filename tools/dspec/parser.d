module parser;

import filelist;
import output;

import std.stdio;
import std.string;

import feeder;
import parseunit;
import ast;

class Parser
{
	bool parseFiles(char[] outputPath, FileList files)
	{			
		output = new Output(outputPath ~ "test.d");
		
		foreach(f; files)
		{
			if (!(parseFile(f)))
			{
				return false;
			}
		}
		
		return true;
	}

protected:

	Output output;

	bool parseFile(char[] path)
	{
		
		Feeder feeder = new Feeder(path);
		// write out intentions
		writefln("Parsing ... ", path);
		
		parseUnit = new ParseDSpec();
		
		parseUnit.attachFeeder(feeder);
		
		AST finished = parseUnit.parse();
						
		output.work(finished);
		
		return true;
	}
	
	// parsing
	
	ParseUnit parseUnit;
}

bool isDelimiter(char[] s)
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
	this()
	{
		registerToken(";", &parseSemicolon);
	}
	
	char[] mod = "";
	
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
	
	char[] name;
	
	char[] working = "";
	
	void parseDescribe()
	{
		if (foundDescribe)
		{
			if (working.length > 0)
			{
				AST ast = new AST(null, null);
				ast.value = working;
				progressTree(ast);
			
				working = "";
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

			working = "";
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

			working = "";
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
			
				working = "";
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
			writefln("Section: ", name);
			
			AST meta = new AST(null, new AST(null, null));
			meta.name = "Identifier";
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
	
	char[] name;
	
	char[] working = "";
	
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

			working = "";
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
			
				working = "";
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

			working = "";
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
			writefln("Class: ", name);
			
			AST meta = new AST(null, new AST(null, null));
			meta.name = "Identifier";
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
	
	char[] name;
	
	char[] working = "";
	
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

				working = "";
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

				working = "";
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
			writefln("It: ", name);
			
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
		registerToken("(", &parseLeft);
		registerToken(")", &parseRight);
	}
	
	bool foundShould;
	
	uint parens = 0;
	
	char[] working;
	
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

				working = "";
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
	
	char[] working;
	
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

				working = "";
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