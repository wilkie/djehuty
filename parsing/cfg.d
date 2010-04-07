module parsing.cfg;

import core.string;
import core.definitions;

import io.console;

class GrammarPhrase {
	this(string rule) {
		Console.putln(rule);

		_rule = rule;
	}

protected:

	string _rule;
}




class GrammarRule {
	this(string rule) {
		Console.putln(rule);

		// parse the rule string
		// get the left hand side and right hand side
		// the string "->" delimits

		int divider = rule.find("->");

		_left = new GrammarPhrase(rule.substring(0, divider).trim());
		_right = new GrammarPhrase(rule.substring(divider+2).trim());
	}

protected:

	GrammarPhrase _left;
	GrammarPhrase _right;
}





class Grammar {
	this() {
	}

	void addRule(string rule) {
		GrammarRule newRule = new GrammarRule(rule);

		_rules ~= newRule;
	}

	GrammarRule[] _rules;
}
