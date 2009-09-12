module utils.stack;

import utils.arraylist;

import io.console;

class Stack(T) : ArrayList!(T) {
	this() {
		super();
	}

	this(uint size) {
		super(size);
	}

	this(T[] withList) {
		_list = withList.dup;
		_capacity = _list.length;
		_count = _list.length;
	}

	Stack!(T) dup() {
		return new Stack!(T)(_list[0.._count]);
	}

	T pop() {
		T ret;
		remove(ret);

		return ret;
	}

	void push(T item) {
		addItem(item);
	}

	T peek() {
		T ret;
		getItem(ret, length-1);
		return ret;
	}
}
