module parsing.cfg;

import core.string;
import core.definitions;

import io.console;

class GrammarPhrase
{
	this(String rule)
	{
		Console.putln(rule.array);

		_rule = rule;
	}

	this(string rule)
	{
		this(new String(rule));
	}



protected:

	String _rule;
}




class GrammarRule
{
	this(String rule)
	{
		Console.putln(rule.array);

		// parse the rule string
		// get the left hand side and right hand side
		// the string "->" delimits

		int divider = rule.find(new String("->"));

		_left = new GrammarPhrase(rule.subString(0, divider).trim);
		_right = new GrammarPhrase(rule.subString(divider+2).trim);
	}

	this(string rule)
	{
		this(new String(rule));
	}

protected:

	GrammarPhrase _left;
	GrammarPhrase _right;
}





class Grammar
{
	this()
	{
	}

	void addRule(string rule)
	{
		GrammarRule newRule = new GrammarRule(rule);

		_rules ~= newRule;
	}

	void addRule(String rule)
	{
		GrammarRule newRule = new GrammarRule(rule);

		_rules ~= newRule;
	}

protected:

	GrammarRule[] _rules;
}
