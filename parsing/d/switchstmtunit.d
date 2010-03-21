/*
 * expressionunit.d
 *
 * This module parses expressions.
 *
 */

module parsing.d.switchstmtunit;

import parsing.parseunit;
import parsing.token;

import parsing.d.tokens;
import parsing.d.nodes;

import parsing.d.expressionunit;
import parsing.d.blockstmtunit;

import io.console;

import djehuty;

class SwitchStmtUnit : ParseUnit {
	override bool tokenFound(Token current) {
		switch (current.type) {
			case DToken.LeftParen:
				if (this.state != 0) {
				}

				Console.putln("Switch:");
				auto tree = expand!(ExpressionUnit)();
				this.state = 1;
				break;
			case DToken.RightParen:
				if (this.state != 1) {
				}
				this.state = 2;
				break;
			case DToken.LeftCurly:
				if (this.state == 0) {
				}
				if (this.state == 1) {
				}

				auto tree = expand!(BlockStmtUnit)();
				// Done.
				return false;
			default:
				// Error
				// TODO:
				break;
		}
		return true;
	}

protected:
	string cur_string = "";

	static const string _common_error_msg = "";
	static const string[] _common_error_usages = null;
}
