/*
 * expressionunit.d
 *
 * This module parses expressions.
 *
 */

module parsing.d.casestmtunit;

import parsing.parseunit;
import parsing.token;

import parsing.d.tokens;
import parsing.d.nodes;

import parsing.d.expressionunit;

import io.console;

import djehuty;

class CaseStmtUnit : ParseUnit {
	override bool tokenFound(Token current) {
		switch (current.type) {
			case DToken.Colon:
				if (this.state == 0) {
					// Error:
					// we have 'case: '
					// TODO:
				}

				// Done.
				return false;
			default:
				lexer.push(current);
				if (this.state == 1) {
					// Error: Multiple expressions
					// TODO:
				}
				Console.putln("Case: ");
				auto tree = expand!(ExpressionUnit)();
				this.state = 1;
				break;
		}
		return true;
	}

protected:
	string cur_string = "";

	static const string _common_error_msg = "";
	static const string[] _common_error_usages = null;
}
