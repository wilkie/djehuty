/*
 * expressionunit.d
 *
 * This module parses expressions.
 *
 */

module parsing.d.logicalorexprunit;

import parsing.parseunit;
import parsing.token;

import parsing.d.tokens;
import parsing.d.nodes;

import parsing.d.logicalandexprunit;

import io.console;

import djehuty;

class LogicalOrExprUnit : ParseUnit {
	override bool tokenFound(Token current) {
		switch (current.type) {
			default:
				lexer.push(current);
				auto tree = expand!(LogicalAndExprUnit)();
				break;
		}
		return true;
	}

protected:
	string cur_string = "";

	static const string _common_error_msg = "";
	static const string[] _common_error_usages = null;
}
