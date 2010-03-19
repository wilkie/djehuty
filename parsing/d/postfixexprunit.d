/*
 * expressionunit.d
 *
 * This module parses expressions.
 *
 */

module parsing.d.postfixexprunit;

import parsing.parseunit;
import parsing.token;

import parsing.d.tokens;
import parsing.d.nodes;

import parsing.d.postfixexprlistunit;

import io.console;

import djehuty;

class PostFixExprUnit : ParseUnit {
	override bool tokenFound(Token current) {
		switch (current.type) {
			case DToken.Null:
			case DToken.True:
			case DToken.False:
			case DToken.IntegerLiteral:
			case DToken.Dollar:
			case DToken.FloatingPointLiteral:
				Console.putln("Expression: ", current.value);
				return false;	
			case DToken.Mixin:
				// TODO: MixinExprUnit
//				auto tree = expand!(MixinExprUnit)();
				break;
			case DToken.Assert:
				// TODO: AssertExprUnit
//				auto tree = expand!(AssertExprUnit)();
				break;
			case DToken.Is:
				// TODO: IsExprUnit
//				auto tree = expand!(IsExprUnit)();
				break;
			default:
				lexer.push(current);
				auto tree = expand!(PostFixExprListUnit)();
				return false;
		}
		return true;
	}

protected:
	string cur_string = "";

	static const string _common_error_msg = "";
	static const string[] _common_error_usages = null;
}
