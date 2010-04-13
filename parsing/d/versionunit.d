/*
 * expressionunit.d
 *
 * This module parses expressions.
 *
 */

module parsing.d.versionunit;

import parsing.parseunit;
import parsing.token;

import parsing.d.tokens;
import parsing.d.nodes;

import parsing.d.assignexprunit;
import parsing.d.declarationunit;

import io.console;

import djehuty;

class VersionUnit : ParseUnit {
	override bool tokenFound(Token current) {
		if (this.state == 4) {
			// We are looking for declarations
			if (current.type == DToken.RightCurly) {
				// Done.
				return false;
			}
			else {
				lexer.push(current);
				auto tree = expand!(DeclarationUnit)();
			}
			return true;
		}

		// Else, we are looking for the condition

		switch (current.type) {
			// We could be declaring a version
			// version = Release; etc
			case DToken.Assign:
				if (this.state == 1) {
					// Error: Already started to use an identifier
					// TODO:
				}
				else if (this.state == 2) {
					// Error: Already named an identifier.
					// TODO:
				}
				else if (this.state == 3) {
					// Error: Found right paren.
					// TODO:
				}

				// We need to find the identifier or integer to enable.
				this.state = 5;
				break;

			// Look for a left paren first. It must exist.
			case DToken.LeftParen:
				if (this.state == 1) {
					// Error: Too many left parentheses.
					// TODO:
				}
				else if (this.state == 2) {
					// Error: Found an identifier.
					// TODO: Probably mistook left for right parenthesis.
				}
				else if (this.state == 3) {
					// Error: We already found a right paren... Expected colon or brace
					// TODO:
				}
				this.state = 1;
				break;

			// For version assignment, we are looking for a semicolon to end it.
			case DToken.Semicolon:
				if (this.state == 5) {
					// Error: No identifier given.
					// TODO:
				}
				else if (this.state == 0) {
					// Error: Need '=' first.
					// TODO:
				}
				else if (this.state == 1) {
					// Error: Have left paren.
					// TODO:
				}
				else if (this.state == 2) {
					// Error: Have Identifier for normal foo.
					// TODO:
				}
				else if (this.state == 3) {
					// Error: Have right paren.
					// TODO:
				}

				// else this.state == 6

				// Done.
				return false;

			// Looking for some literal or identifier to use as the version
			case DToken.Identifier:
			case DToken.IntegerLiteral:
				if (this.state == 5) {
					// We are assigning a version
					cur_string = current.value.toString();
					Console.putln("Version enabled: ", current.value);
					this.state = 6;
				}
				else if (this.state == 6) {
					// Error: Too many identifiers in a row on a version assign.
					// TODO:
				}
				else if (this.state == 0) {
					// Error: No left parenthesis.
					// TODO: Probably forgot it!
				}
				else if (this.state == 2) {
					// Error: Too many identifiers in a row!
					// TODO: Probably put a space or something in.
				}
				else if (this.state == 3) {
					// Error: Found right parenthesis.
					// TODO: Probably forgot a curly brace.
				}
				else {
					Console.putln("Version: ", current.value);
					cur_string = current.value.toString();
					this.state = 2;
				}
				break;

			case DToken.RightParen:
				if (this.state == 0) {
					// Error: Do not have a left paren.
					// TODO: Probably forgot a left parenthesis.
				}
				else if (this.state == 3) {
					// Error: Too many right parens
					// TODO:
				}

				// Now we can look for a : or a curly brace for a declaration block
				this.state = 3;
				break;

			// For declaring the rest of the file under this conditional block
			// static if (foo):
			case DToken.Colon:
				if (this.state == 0) {
					// Error: Do not have a condition!
					// TODO:
				}
				else if (this.state == 1) {
					// Error: Do not have an identifier.
					// TODO:
				}
				else if (this.state == 2) {
					// Error: Do not have a right paren.
					// TODO:
				}
				else if (this.state == 4) {
					// Error: After a left curly brace. We are within the block.
					// TODO:
				}

				// Done.
				return false;

			// For specifying a declaration block for this condition
			case DToken.LeftCurly:
				if (this.state == 0) {
					// Error: Do not have a condition!
					// TODO:
				}
				else if (this.state == 1) {
					// Error: Do not have an identifier.
					// TODO:
				}
				else if (this.state == 2) {
					// Error: Do not have a right paren.
					// TODO:
				}

				// Now we look for declarations.
				this.state = 4;
				break;

			// Errors for any unknown tokens.
			default:
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
