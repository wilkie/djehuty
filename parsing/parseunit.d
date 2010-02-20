module parseunit;

import parsing.ast;
import parsing.lexer;
import parsing.token;

import core.string;
import core.variant;
import core.definitions;

import io.console;

class ParseUnit {
	this() {
	}

	this(Lexer lexer) {
		_lexer = lexer;
	}

	final AbstractSyntaxTree parse() {
		// get class name
		ClassInfo ci = this.classinfo;
		string className = ci.name.dup;

		// Do not have a lexer installed...
		if (_lexer is null) {
			return _tree;
		}

		// Go through every token...
		while((current = _lexer.pop()).type != 0) {
			if (!tokenFound(current)) {
				break;
			}
			if (_error) {
				break;
			}
		}

		// Return resulting parse tree...
		return _root;
	}

	final void makeNode(uint type, ParseUnit unit, ...) {
		Variadic v = new Variadic(_arguments, _argptr);
		AbstractSyntaxTree ast = null;
		if (unit !is null) {
			unit._lexer = _lexer;
			ast = unit.parse();
		}
		_makeNodev(type, ast, v);	
	}

	final void makeNode(ParseUnit unit) {
		if (unit !is null) {
			unit._lexer = _lexer;
			unit.parse();
			if (_tree is null) {
				_tree = unit._root;
			}
			else {
				_tree.left = unit._root;
				_tree = _tree.left;
			}
			if (_root is null) {
				_root = _tree;
			}
		}
	}

protected:

	final void error(string msg) {
		Console.putln("Syntax Error: file.d @ ", current.line, ":", current.column, " - ", msg);
		_error = true;
	}

	final void _makeNodev(uint type, AbstractSyntaxTree ast, Variadic vars) {
		if (vars.length == 0) {
			if (_tree is null) {
				_tree = new AbstractSyntaxTree(type, null, ast);
			}
			else {
				_tree.left = new AbstractSyntaxTree(type, null, ast);
				_tree = _tree.left;
			}
		}
		else {
			Variant value = vars[0];
			if (_tree is null) {
				_tree = new AbstractSyntaxTree(type, null, ast, value);
			}
			else {
				_tree.left = new AbstractSyntaxTree(type, null, ast, value);
				_tree = _tree.left;
			}
		}
		if (_root is null) {
			_root = _tree;
		}
	}

	bool tokenFound(Token token) {
		return true;
	}

	Lexer _lexer;
	AbstractSyntaxTree _tree;
	AbstractSyntaxTree _root;
	static bool _error;
	Token current;
}
