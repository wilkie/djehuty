module lexer;

import core.string;
import console.main;

// Description: This class represents a token that has been run through a lexical analyzer, specifically a Lexer.
class Token
{
	// Description: This contructor will generate a Token based upon the specified unique identifier and the given actual value as seen in the stream.
	// tokenId: The unique identifier for this type of Token.
	// actualValue: The value as seen in the stream that identifies with this type of Token.
	this(int tokenId, String actualValue)
	{
		id = tokenId;
		actualValue = value;
	}

	int getId()
	{
		return id;
	}

	String getValue()
	{
		return value;
	}

protected:

	int id;
	String value;
}

// Description: This class will take a lexicon and produce a series of Tokens from the input stream.
class Lexer
{
	this()
	{
	}

	Token[] work()
	{
		Token ret;
		
		return ret;
	}

protected:

	// rules (lexicon)
}