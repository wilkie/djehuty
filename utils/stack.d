module utils.stack;

import core.list;

import io.console;

class Stack(T) : List!(T) {
	this() {
		super();
	}

	this(uint size) {
		super(size);
	}

	this(T[] withList) {
		_data = withList.dup;
		_count = _data.length;
	}

	Stack!(T) dup() {
		return new Stack!(T)(_data[0.._count]);
	}

	T pop() {
		T ret;
		ret = remove();

		return ret;
	}

	void push(T item) {
		add(item);
	}
}
