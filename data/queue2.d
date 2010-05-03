module data.queue2;

import data.iterable;

class Queue2(T) : Iterable!(T) {
	template add(R) {
		void add(R item) {
		}
	}

	template addAt(R) {
		void addAt(R item) {
		}
	}

	T remove() {
		T ret;
		return ret;
	}

	T removeAt(size_t idx) {
		T ret;
		return ret;
	}

	T peek() {
		T ret;
		return ret;
	}

	T peekAt(size_t idx) {
		T ret;
		return ret;
	}

	template set(R) {
		void set(R value) {
		}
	}

	template setAt(R) {
		void setAt(R value, size_t idx) {
		}
	}

	template apply(R, S) {
		void apply(R delegate(S) func) {
		}
	}

	template contains(R) {
		bool contains(R value) {
			return false;
		}
	}

	bool empty() {
		return true;
	}

	void clear() {
	}

	T[] array() {
		return null;
	}

	Iterable!(T) dup() {
		return null;
	}

	Iterable!(T) slice(size_t start, size_t end) {
		return null;
	}

	Iterable!(T) reverse() {
		return null;
	}

	size_t length() {
		return 0;
	}

	T opIndex(size_t i1) {
		T ret;
		return ret;
	}

	template opIndexAssign(R) {
		size_t opIndexAssign(R value, size_t i1) {
			return 0;
		}
	}

	int opApply(int delegate(ref T) loopFunc) {
		return 0;
	}

	int opApply(int delegate(ref size_t, ref T) loopFunc) {
		return 0;
	}

	int opApplyReverse(int delegate(ref T) loopFunc) {
		return 0;
	}

	int opApplyReverse(int delegate(ref size_t, ref T) loopFunc) {
		return 0;
	}

	Iterable!(T) opCat(T[] list) {
		return null;
	}

	Iterable!(T) opCat(Iterable!(T) list) {
		return null;
	}

	Iterable!(T) opCat(T item) {
		return null;
	}

	void opCatAssign(T[] list) {
	}

	void opCatAssign(Iterable!(T) list) {
	}

	void opCatAssign(T item) {
	}
}
