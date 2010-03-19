/*
 * expressionunit.d
 *
 * This module parses expressions.
 *
 */

module parsing.d.foreachstmtunit;

import parsing.parseunit;
import parsing.token;

import parsing.d.tokens;
import parsing.d.nodes;

import parsing.d.expressionunit;
import parsing.d.scopedstmtunit;
import parsing.d.typeunit;

import io.console;

import djehuty;

class ForeachStmtUnit : ParseUnit {
	override bool tokenFound(Token current) {
		switch (current.type) {
			case DToken.LeftParen:
				if (this.state > 0) {
					// Error: Already found left parenthesis.
					// TODO:
				}
				this.state = 1;
				break;
			case DToken.RightParen:
				if (this.state != 5) {
				}
				auto tree = expand!(ScopedStmtUnit)();
				return false;
			case DToken.Ref:
				if (this.state == 0) {
				}
				else if (this.state >= 2) {
				}
				this.state = 2;
				break;
			case DToken.Identifier:
				if (this.state == 0) {
				}
				if (this.state > 3) {
				}
				if (this.state == 3) {
					this.state = 4;
				}
				else {
					// This needs lookahead to know it isn't a type
					Token foo = lexer.pop();
					lexer.push(foo);
					if (foo.type == DToken.Comma || foo.type == DToken.Semicolon) {
						this.state = 4;
					}
					else {
						lexer.push(current);
	
						// Getting type of identifier
						auto tree = expand!(TypeUnit)();
	
						this.state = 3;
					}
				}

				if (this.state == 4) {
					Console.putln("Foreach: identifier: ", current.value);
				}
				break;
			case DToken.Semicolon:
				if (this.state < 4) {
				}
				auto tree = expand!(ExpressionUnit)();
				this.state = 5;
				break;
			case DToken.Comma:
				if (this.state != 4) {
				}
				this.state = 1;
				break;
			default:
				break;
		}
		return true;
	}

protected:
	string cur_string = "";

	static const string _common_error_msg = "";
	static const string[] _common_error_usages = null;
}
