module parsing.ast;

import core.string;
import core.definitions;
import core.variant;
import core.tostring;

import io.console;

class AbstractSyntaxTree {
	this(uint type, AbstractSyntaxTree left, AbstractSyntaxTree right) {
		_children[0] = left;
		_children[1] = right;
	}

	this(uint type, AbstractSyntaxTree left, AbstractSyntaxTree right, Variant value) {
		this(type, left, right);
		_value = value;
	}

	void type(uint value) {
		_type = type;
	}

	uint type() {
		return _type;
	}

	void value(Variant val) {
		_value = value;
	}

	Variant value() {
		return value;
	}

	void left(AbstractSyntaxTree ast) {
		_children[0] = ast;
	}

	AbstractSyntaxTree left() {
		return _children[0];
	}

	void right(AbstractSyntaxTree ast) {
		_children[1] = ast;
	}

	AbstractSyntaxTree right() {
		return _children[1];
	}

	string toString() {
		string ret = "";
		int depth = 0;
		_innerToString(depth, ret);
		return ret;
	}

protected:
	AbstractSyntaxTree[2] _children;
	uint _type;
	Variant _value;

private:
	void _innerToString(ref int depth, ref string foo) {
		string add = "[" ~ toStr(_type) ~ "]=" ~ toStr(_value) ~ "->";
		foo ~= add;
		depth += add.length;
		if (_children[0] is null) {
			foo ~= "{null}";
		}
		else {
			_children[0]._innerToString(depth, foo);
		}
		foo ~= "\n";
		for(size_t i; i < depth-2; i++) {
			foo ~= " ";
		}
		foo ~= "->";
		if (_children[1] is null) {
			foo ~= "{null}";
		}
		else {
			_children[1]._innerToString(depth, foo);
		}
		depth -= add.length;
	}
}
