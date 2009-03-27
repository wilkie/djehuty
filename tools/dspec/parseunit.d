module parseunit;

import feeder;
import ast;

import std.stdio;
import std.file;
import std.string;

class ParseUnit
{	
	final void attachFeeder(Feeder feed)
	{
		feeder = feed;
	}
	
	final AST parse()
	{	
		// get class name
		ClassInfo ci = this.classinfo;
		char[] className = ci.name;
	
		original = new AST(null,null);
		parseTree = original;
		
		int pos = rfind(className, '.');
		if (pos > 0)
		{
			className = className[pos+1..$];
		}
		
		parseTree.name = className;
		
		for(;;)
		{
			if (tokens is null)
			{
				tokens = feeder.feed();
				idx = 0;

				if (tokens is null) { return original; }
			}
			
			for( ; idx < tokens.length ; idx++)
			{
				currentToken = tokens[idx];
				if (currentToken in parseFunctions)
				{
					parseFunctions[currentToken]();
				}
				else
				{
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
	
	void progressTree(AST right)
	{
		if (parseTree.right !is null && parseTree.left is null)
		{
			parseTree.left = new AST(null, null);
			parseTree = parseTree.left;
		}
				
		parseTree.right = right;
		
		if (parseTree !is original && right !is null && right.valueType == AST.ValueType.Name)
		{
			char [] val;
			right.getValue(val);
			parseTree.hint = val;
		}
	}
	
protected:

	// feed state
	static char[][] tokens;
	static uint idx;
	
	static Feeder feeder;

	alias void delegate() ParseFunction;
	
	ParseFunction[char[]] parseFunctions;
	
	ParseUnit parseUnit;
	
	AST parseTree;
	AST original;
		
	bool iAmDone;
	
	char[] currentToken;
	
	AST newParseUnit(ParseUnit newUnit)
	{
		parseUnit = newUnit;
		return parseUnit.parse();
	}
	
	void done()
	{
		iAmDone = true;
	}
	
	void registerToken(char[] token, ParseFunction func)
	{
		parseFunctions[token] = func;
	}
	
	void parseDefault()
	{
		return false;
	}
}