/*
 * expressionunit.d
 *
 * This module parses expressions.
 *
 */

module parsing.d.declaratorunit;

import parsing.parseunit;
import parsing.token;

import parsing.d.tokens;
import parsing.d.nodes;

import parsing.d.declaratorsuffixunit;
import parsing.d.declaratortypeunit;

import io.console;

import djehuty;

class DeclaratorUnit : ParseUnit {
	override bool tokenFound(Token current) {
		switch (state) {
			case 0:
				switch (current.type) {

					// Name
					case DToken.Identifier:
						Console.putln("TypeDecl: Name: ", current.value);
						this.state = 1;
						break;

					// Nested Declarators
					case DToken.LeftParen:
						auto tree = expand!(DeclaratorUnit)();
						this.state = 3;
						break;
	
					// More complicated Declarator, push off to DeclaratorType
					default:
						lexer.push(current);
						auto tree = expand!(DeclaratorTypeUnit)();
						this.state = 2;
						break;
				}
				break;
			case 1:
				lexer.push(current);
				switch (current.type) {
					// This hints to the next part being a DeclaratorSuffix
					case DToken.LeftBracket:
					case DToken.LeftParen:
						auto tree = expand!(DeclaratorSuffixUnit)();
						break;
					default:
						// Done
						return false;
				}
				break;

			// After DeclaratorTypeUnit, look for the signs of another Declarator
			case 2:
				lexer.push(current);
				switch(current.type) {
					// We have another declarator
					case DToken.Identifier:
					case DToken.LeftParen:
						auto tree = expand!(DeclaratorUnit)();
						break;

					default:
						// done
						break;
				}
				return false;

			// We have a nested declarator in play... look for a right
			// parenthesis.
			case 3:
				switch(current.type) {
					case DToken.RightParen:
						// Good
						this.state = 1;
						break;

					default:
						// Bad
						break;
				}
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
