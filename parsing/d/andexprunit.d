/*
 * expressionunit.d
 *
 * This module parses expressions.
 *
 */

module parsing.d.andexprunit;

import parsing.parseunit;
import parsing.token;

import parsing.d.tokens;
import parsing.d.nodes;

import parsing.d.cmpexprunit;

import io.console;

import djehuty;

class AndExprUnit : ParseUnit {
	override bool tokenFound(Token current) {
		switch (current.type) {
			default:
				lexer.push(current);
				auto tree = expand!(CmpExprUnit)();
				break;
		}
		return true;
	}

protected:
	string cur_string = "";

	static const string _common_error_msg = "";
	static const string[] _common_error_usages = null;
}
