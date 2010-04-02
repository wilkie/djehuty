module parsing.ast;

import core.string;
import core.definitions;
import core.variant;
import core.list;
import core.tostring;

import io.console;

class AbstractSyntaxTree : List!(AbstractSyntaxTree) {
	this() {
	}

	this(uint type, AbstractSyntaxTree[] nodes ...) {
		addList(nodes);
		_type = type;
	}

	void type(uint value) {
		_type = type;
	}

	uint type() {
		return _type;
	}

	AbstractSyntaxTree next() {
		return _next;
	}

	AbstractSyntaxTree parent() {
		return _parent;
	}

protected:
	AbstractSyntaxTree _next;
	AbstractSyntaxTree _parent;

	uint _type;
	Variant _value;
}
