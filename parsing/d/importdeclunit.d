/*
 * importdeclunit.d
 *
 * This module parses out the package and module name foo
 * out of an import declaration.
 *
 */

module parsing.d.importdeclunit;

import parsing.parseunit;
import parsing.token;

import parsing.d.tokens;
import parsing.d.nodes;

import parsing.d.trees;

import io.console;

import djehuty;

class ImportDeclUnit : ParseUnit {
	override bool tokenFound(Token current) {
		switch (current.type) {
			case DToken.Dot:
				if (cur_string.length > 0 && cur_string[$-1] == '.') {

					// Error: We found two dots, probably left behind after an edit.
					error(_common_error_msg,
							"There are a few too many dots in a row. Did you mean to have only one?",
							_common_error_usages);

				}
				else {
					cur_string ~= ".";
				}
				break;

			case DToken.Semicolon:
				// End of declaration
				this.root = new Import(cur_string);
				return false;

			case DToken.Identifier:
				if (cur_string.length > 0 && cur_string[$-1] != '.') {

					// Error: Found an identifier and then another identifier. Probably
					// due to an editing mistake.
					error(_common_error_msg,
							"Did you mean to place a '.' between the two names?",
							_common_error_usages);

				}
				else {
					// Add the package or module name to the overall value.
					cur_string ~= toStr(current.value);
				}

				break;
			case DToken.Slice:
				// Error: Found .. when we expected just one dot.
				error(_common_error_msg,
					"You placed two dots, did you mean to only have one?",
					_common_error_usages);
				break;

			case DToken.Variadic:
				// Error: Found ... when we expected just one dot.
				error(_common_error_msg,
					"You placed three dots, did you mean to only have one?",
					_common_error_usages);
				break;
			default:

				// Error: Found some illegal token. Probably due to lack of semicolon.
				errorAtPrevious(_common_error_msg,
					"You probably forgot a semicolon.",
					_common_error_usages);
				break;
		}
		return true;
	}

protected:
	string cur_string = "";

	static const string _common_error_msg = "The import declaration is not formed correctly.";
	static const string[] _common_error_usages = [
		"import package.file;",
		"import MyAlias = package.file;",
		"import MyFoo = package.file : Foo;"
	];
}
