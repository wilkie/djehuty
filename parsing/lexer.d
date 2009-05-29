/*
 * lexer.d
 *
 * This module contains the Lexer and Token classes, which facilitate the
 * creation of a tokenizer (lexical analyser) for a feed to a parser.
 *
 * Author: Dave Wilkinson
 * Originated: May 12, 2009
 *
 */

module parsing.lexer;

import core.string;
import core.regex;

import utils.arraylist;

import console.main;

// Description: This class represents a token that has been run through a lexical analyzer, specifically a Lexer.
class Token
{
	// Description: This contructor will generate a Token based upon the specified unique identifier and the given actual value as seen in the stream.
	// tokenId: The unique identifier for this type of Token.
	// actualValue: The value as seen in the stream that identifies with this type of Token.
	this(int tokenId, String actualValue = null)
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
		rules = new ArrayList!(Rule)();
	}

	void addRule(String regex, Token delegate() func = null)
	{
		Rule newRule;

		newRule.regex = new String(regex);
		newRule.func = func;

		rules.addItem(newRule);
	}

	void addRule(StringLiteral regex, Token delegate() func = null)
	{
		Rule newRule;

		newRule.regex = new String(regex);
		newRule.func = func;

		rules.addItem(newRule);
	}
	
	void addRules(String[] regexList, Token delegate() func = null)
	{
		foreach(regex; regexList)
		{
			Rule newRule;
	
			newRule.regex = new String(regex);
			newRule.func = func;
	
			rules.addItem(newRule);
		}
	}
	
	void addRules(StringLiteral[] regexList, Token delegate() func = null)
	{
		foreach(regex; regexList)
		{
			Rule newRule;
	
			newRule.regex = new String(regex);
			newRule.func = func;
	
			rules.addItem(newRule);
		}
	}

	Token[] work()
	{
		Token current;
		while(pull(current))
		{
			if (current !is null)
			{
				Console.putln(current.getId);
			}
		}

		return null;
	}

	bool pull(out Token token)
	{
		static String workString;

		if (workString is null) { workString = new String("if 0x121 a023 ( a3234)"); }

		String s;

		foreach(int i, rule; rules)
		{
			s = Regex.eval(workString, rule.regex);
			if (s !is null)
			{
				if (s == "")
				{
					continue;
				}
				ruleId = i;

				workString = workString.subString(s.length);
				if (rule.func is null)
				{
					token = defaultHandler();
				}
				else
				{
					token = rule.func();
				}
				return true;
			}
		}

		Console.putln("$@#!$@#$");
		return false;
	}

	Token defaultHandler()
	{
		return new Token(ruleId);
	}

protected:

	int ruleId;
	
	struct Rule
	{
		String regex;
		Token delegate() func;
	}

	// rules (lexicon)
	ArrayList!(Rule) rules;
}