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
		strValue = actualValue;
		if (strValue is null) {
			strValue = new String("");
		}
	}

	this(int tokenId, ulong actualValue) {
		id = tokenId;
		intValue = actualValue;
	}

	int getId() {
		return id;
	}

	String getString() {
		return strValue;
	}

	ulong getInteger() {
		return intValue;
	}

protected:

	int id;
	String strValue;
	ulong intValue;
}

// Description: This class will take a lexicon and produce a series of Tokens from the input stream.
class Lexer : Responder
{
	this() {
		rules ~= new ArrayList!(Rule)();
	}

	void addRule(uint tokenId, String regex) {
		Rule newRule;

		newRule.regex = new String("^(?:") ~ regex ~ ")";
		newRule.id = tokenId;

		rules[stateId].addItem(newRule);
	}

	void addRule(uint tokenId, string regex) {
		Rule newRule;

		newRule.regex = new String("^(?:") ~ regex ~ ")";
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

	Token[] work() {
		while(pull()) {
			if (token !is null) {
			}
		}

		return null;
	}

	bool pull() {
		static String workString;

		if (workString is null) { workString = new String(
		`
// comment
import std.stdio;

int utfLength(string str) {
	return 5;
}

int utfLength(int[] foo) {
	return 3;
}

void main() {
	string bleh = "asdfsdf";
	writefln("foo".utfLength());

	int[] b = [0,1,2];
	writefln(b.utfLength());

	float f = 077.10e10;
	writefln(f);
	float d = 3L;

	int asd = 0x_1111p3;
}
		`c ~ " `wysiwyg string`"c); }

		String s;

		foreach(int i, rule; rules[stateId]) {
			s = Regex.eval(workString, rule.regex);
			if (s !is null && s != "") {
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

	struct Rule {
		String regex;
		uint id;
	}

	Token token;

	// rules (lexicon)
	ArrayList!(Rule)[] rules;
}