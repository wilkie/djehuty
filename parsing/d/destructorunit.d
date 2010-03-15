/*
 * expressionunit.d
 *
 * This module parses expressions.
 *
 */

module parsing.d.destructorunit;

import parsing.parseunit;
import parsing.token;

import parsing.d.tokens;
import parsing.d.nodes;

import parsing.d.parameterlistunit;
import parsing.d.functionbodyunit;

import io.console;

import djehuty;

class DestructorUnit : ParseUnit {
	override bool tokenFound(Token current) {
		switch (current.type) {


			// First, we look for the left paren of the parameter list
			case DToken.LeftParen:
				if (!thisFound) {
					// Error: Need this after ~
					error(_common_error_msg,
							"Did you intend on having a destructor here? You are missing 'this'.",
							_common_error_usages);
				}
				else if (this.state != 0) {
					// It should be the first thing!
					// Error: Too many left parentheses!
					error(_common_error_msg,
							"You accidentally placed too many left parentheses here.",
							_common_error_usages);
				}
				this.state = 1;
				break;

				// After finding a left paren, look for a right one
			case DToken.RightParen:
				if (!thisFound) {
					// Error: Need this after ~
					error(_common_error_msg,
							null,
							_common_error_usages);
				}
				else if (this.state == 0) {
					// Error: No left paren found before this right one!
					error(_common_error_msg,
							"You are missing a left parenthesis.",
							_common_error_usages);
				}
				else if (this.state != 1) {
					// Error: Already parsed a right paren! We have too many right parens!
					error(_common_error_msg,
							"You have placed too many right parentheses.",
							_common_error_usages);
				}
				this.state = 2;
				break;

				// Look for the end of a bodyless declaration
			case DToken.Semicolon:
				if (!thisFound) {
					// Error: Need this after ~
					error(_common_error_msg,
							"A '~' does nothing on its own.",
							_common_error_usages);
				}
				else if (this.state == 0) {
					// Error: Have not found a left paren!
					error(_common_error_msg,
							"You must have a empty parameter list for your destructor.",
							_common_error_usages);
				}
				else if (this.state != 2) {
					// Error: Have not found a right paren!
					error(_common_error_msg,
							"You accidentally left out a right parenthesis.",
							_common_error_usages);
				}
				// Done.
				return false;

				// Function body
			case DToken.In:
			case DToken.Out:
			case DToken.Body:
			case DToken.LeftCurly:
				// Have we found a parameter list?
				if (!thisFound) {
					// Error: Need this after ~
					error(_common_error_msg,
							null,
							_common_error_usages);
				}
				else if (this.state == 0 ) {
					// Error: No parameter list given at all
					error(_common_error_msg,
							"You must have an empty parameter list for a destructor.",
							_common_error_usages);
				}
				else if (this.state == 1) {
					// Error: We have a left parenthesis... but no right one
					error(_common_error_msg,
							"You have accidentally left out a right parenthesis.",
							_common_error_usages);
				}

				// Function body!
				auto tree = expand!(FunctionBodyUnit)();

				Console.putln("Destructor");
				// Done.
				return false;

				// We are only given that the first token, ~, is found...
				// So, we must ensure that the This keyword is the first item
			case DToken.This:
				if (this.state == 0 && !thisFound) {
					thisFound = true;
				}
				else if (this.state == 0 && thisFound) {
					// Error: this this <- listed twice in a row
					error(_common_error_msg,
							"You accidentally placed two 'this' in a row.",
							_common_error_usages);
				}
				else if (this.state == 1) {
					// Error: Expected right paren, got this.
					error(_common_error_msg,
							"The parameter list should be empty for a destructor.",
							_common_error_usages);
				}
				else { 
					// Error: Got this, expected function body or ;
					error(_common_error_msg,
							"You probably forgot a semicolon.",
							_common_error_usages);
				}
				break;

				// All other tokens are errors.
			default:
				if (!thisFound) {
					// Error: Need this after ~
					error(_common_error_msg,
							"A '~' character is unexpected here.",
							_common_error_usages);
				}
				else if (this.state == 0) {
					// Error this BLEH...Need ()
					error(_common_error_msg,
							"The destructor must have an empty parameter list: ~this ()",
							_common_error_usages);
				}
				else if (this.state == 1) {
					// Error: Expected right paren
					error(_common_error_msg,
							"The destructor must have an empty parameter list: ~this ()",
							_common_error_usages);
				}
				else if (this.state == 2) {
					// Error: this(...) BLEH... Need function body or semicolon!
					error(_common_error_msg,
							"You are probably missing a curly brace or a semicolon.",
							_common_error_usages);
				}				
				break;
		}
		return true;
	}

	protected:
	bool thisFound = false;
	string cur_string = "";

	static const string _common_error_msg = "Destructor declaration invalid.";
	static const string[] _common_error_usages = [
		"~this() { }",
		"~this();"
			];
}
