/*
 * expressionunit.d
 *
 * This module parses expressions.
 *
 */

module parsing.d.logicalandexprunit;

import parsing.parseunit;
import parsing.token;

import parsing.d.tokens;
import parsing.d.nodes;

import parsing.d.orexprunit;

import io.console;

import djehuty;

class LogicalAndExprUnit : ParseUnit {
	override bool tokenFound(Token current) {
		switch (current.type) {
			default:
				lexer.push(current);
				auto tree = expand!(OrExprUnit)();
				break;
		}
		return true;
	}

protected:
	string cur_string = "";

	static const string _common_error_msg = "";
	static const string[] _common_error_usages = null;
}
