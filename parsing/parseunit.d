module parsing.parseunit;

import parsing.ast;
import parsing.lexer;
import parsing.token;

import djehuty;

import io.console;

class ParseUnit {
private:
	uint _firstLine;
	uint _firstColumn;

	uint _lastLine;
	uint _lastColumn;

	uint _state;

	Lexer _lexer;
	AbstractSyntaxTree _tree;
	AbstractSyntaxTree _root;
	static bool _error;
	Token current;

	void _printerror(string msg, string desc, string[] usages, uint line, uint column) {
		Console.putln("Syntax Error: file.d");
		Console.putln("   Line: ", line, ": ", _lexer.line(line));
		uint position = column;
		position = position + toStr(line).length + 10;
		for (uint i; i < position; i++) {
			Console.put(" ");
		}
		Console.putln("^");
		Console.forecolor = Color.Gray;
		Console.putln(" Reason: ", msg);
		if (desc !is null) {
			Console.putln("   Hint: ", desc);
		}
		if (usages !is null) {
			Console.putln("  Usage: ", usages[0]);
			foreach(usage; usages[1..$]) {
				Console.putln("         ", usage);
			}
		}
		_error = true;
	}

protected:

	uint state() {
		return _state;
	}

	void state(uint value) {
		_state = value;
	}

	void root(AbstractSyntaxTree ast) {
		_root = ast;
	}

	AbstractSyntaxTree root() {
		return _root;
	}

	final void errorAtStart(string msg, string desc = null, string[] usages = null) {
		_printerror(msg, desc, usages, _firstLine, _firstColumn);
	}

	final void errorAtPrevious(string msg, string desc = null, string[] usages = null) {
		_printerror(msg, desc, usages, _lastLine, _lastColumn);
	}

	final void error(string msg, string desc = null, string[] usages = null) {
		_printerror(msg, desc, usages, current.line, current.column);
	}

	bool tokenFound(Token token) {
		return true;
	}

public:
	final AbstractSyntaxTree parse() {
		// get class name
		ClassInfo ci = this.classinfo;
		string className = ci.name.dup;

		// Do not have a lexer installed...
		if (_lexer is null) {
			return _tree;
		}

		// Go through every token...

		// Starting with the first
		current = _lexer.pop();

		if (current.type == 0) {
			return _root;
		}

		// get position in lexer
		_firstLine = current.line;
		_firstColumn = current.column;

		do {
//			Console.putln("T: ", current.type, " ", current.value);
			if (!tokenFound(current)) {
				break;
			}
			if (_error) {
				break;
			}

			_lastLine = current.lineEnd;
			_lastColumn = current.columnEnd;
		} while((current = _lexer.pop()).type != 0);

		// Return resulting parse tree...
		return _root;
	}

	template expand(T) {
		AbstractSyntaxTree expand() {
			auto machine = new T();
			machine.lexer = _lexer;
			return machine.parse();
		}
	}

	Lexer lexer() {
		return _lexer;
	}

	void lexer(Lexer val) {
		_lexer = val;
	}
}
