/*
 * expressionunit.d
 *
 * This module parses expressions.
 *
 */

module parsing.d.aggregatedeclunit;

import parsing.parseunit;
import parsing.token;

import parsing.d.tokens;
import parsing.d.nodes;

import parsing.d.aggregatebodyunit;

import io.console;

import djehuty;

class AggregateDeclUnit : ParseUnit {
	override bool tokenFound(Token current) {
		switch (current.type) {

			// We have found the name
			case DToken.Identifier:
				if (cur_string != "") {
					// Error: Two names?
				}
				Console.putln("Struct: ", current.value);
				cur_string = current.value.toString();
				break;

			// We have found the left brace, so parse the body
			case DToken.LeftCurly:
				auto tree = expand!(AggregateBodyUnit)();
				// Done.
				return false;

			case DToken.Semicolon:
				if (cur_string == "") {
					// Error: No name?
				}
				// Done.
				return false;

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
