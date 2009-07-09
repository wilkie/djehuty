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
import core.definitions;
import core.regex;
import core.event;

import utils.arraylist;

import console.main;

// Description: This class represents a token that has been run through a lexical analyzer, specifically a Lexer.
class Token
{
	// Description: This contructor will generate a Token based upon the specified unique identifier and the given actual value as seen in the stream.
	// tokenId: The unique identifier for this type of Token.
	// actualValue: The value as seen in the stream that identifies with this type of Token.
	this(int tokenId, String actualValue = null) {
		id = tokenId;
		value = actualValue;
		if (value is null) {
			value = new String("");
		}
	}

	int getId() {
		return id;
	}

	String getValue() {
		return value;
	}

protected:

	int id;
	String value;
}

// Description: This class will take a lexicon and produce a series of Tokens from the input stream.
class Lexer : Responder
{
	this()
	{
		rules ~= new ArrayList!(Rule)();
	}

	void addRule(uint tokenId, String regex)
	{
		Rule newRule;

		newRule.regex = new String("^") ~ regex;
		newRule.id = tokenId;

		rules[stateId].addItem(newRule);
	}

	void addRule(uint tokenId, StringLiteral regex)
	{
		Rule newRule;

		newRule.regex = new String("^") ~ regex;
		newRule.id = tokenId;

		rules[stateId].addItem(newRule);
	}

	uint newState() {
		rules ~= new ArrayList!(Rule)();
		stateId = rules.length - 1;

		return stateId;
	}

	void setState(uint id) {
		stateId = id;
	}

	uint getState() {
		return stateId;
	}

	Token[] work()
	{
		while(pull())
		{
			if (token !is null)
			{
			}
		}

		return null;
	}

	bool pull()
	{
		static String workString;

		if (workString is null) { workString = new String(
		`if else "bo\"ooo" r"asdfasdf"
		/+ asfasdf dfasdfsdf
		asfdasdfasdf asfdasdf +/
		// asdfads
		if auto else synchronized 01
		// comment line asdfasdfasdf
		asdfasdf if auto 123
		if __FILE__ __TIME__
		#line 43 "foo\bar"
		`); }

		String s;

		foreach(int i, rule; rules[stateId])
			{
			s = Regex.eval(workString, rule.regex);
			if (s !is null)
			{
				if (s == "")
				{
					continue;
				}

				workString = workString.subString(s.length);

				token = new Token(rule.id, s);
				raiseSignal(rule.id);

				return true;
			}
		}

		return false;
	}

protected:

	int ruleId;
	int stateId;

	struct Rule
	{
		String regex;
		uint id;
	}

	Token token;

	// rules (lexicon)
	ArrayList!(Rule)[] rules;
}