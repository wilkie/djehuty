/*
 * list.d
 *
 * This module implements a simple list interface and many useful list
 * operations inspired by functional programming.
 *
 * Author: Dave Wilkinson
 * Originated: September 10th, 2009
 *
 */

module data.list;

import djehuty;

public import data.iterable;

class List(T) : Iterable!(T) {
	this() {
		_data.length = 10;
		_data = new T[_data.length];
		_count = 0;
	}

	this(int size) {
		_data.length = size;
		_data = new T[_data.length];
		_count = 0;
	}

	this(T[] list) {
		_data = list.dup;
		_count = list.length;
	}

	this(Iterable!(T) list) {
		_data = list.array();
		_count = list.length();
	}

	template add(R) {
		void add(R item) {
			synchronized(this) {
				if (_count >= _data.length) {
					_resize();
				}
				static if (IsArray!(R) && IsArray!(T)) {
					_data[_count] = item.dup;
				}
				else {
					_data[_count] = cast(T)item;
				}
				_count++;
			}
		}
	}

	template addList(R) {
		void addList(R list) {
			synchronized(this) {
				while (_count + list.length > _data.length) {
					_resize();
				}
				static if (IsArray!(IterableType!(R)) && IsArray!(IterableType!(T))) {
					foreach(item; list) {
						_data[_count] = item.dup;
						_count++;
					}
				}
				else {
					foreach(item; list) {
						_data[_count] = cast(T)item;
						_count++;
					}
				}
			}
		}
	}

	template addAt(R) {
		void addAt(R item, size_t idx) {
			synchronized(this) {
				if (_count >= _data.length) {
					_resize();
				}

				if (idx == _count) {
					add(item);
					return;
				}

				if (idx > _count) {
					throw new DataException.OutOfBounds(this.classinfo.name);
				}

				if (_count == 0) {
					idx = 0;
				}
				else if (idx == 0) {
					_data = [_data[idx]] ~ _data[idx..$];
				}
				else if (_count != idx) {
					_data = _data[0..idx] ~ [_data[idx]] ~ _data[idx..$];
				}

				static if (IsArray!(R)) {
					_data[idx] = item.dup;
				}
				else {
					_data[idx] = cast(T)item;
				}
				_count++;
			}
		}
	}

	T remove() {
		synchronized(this) {
			if (this.empty()) {
				return _nullValue();
			}
			_count--;
			return _data[_count];
		}
	}

	T remove(T value) {
		synchronized(this) {
			foreach(size_t index, item; _data[0.._count]) {
				if (value == item) {
					scope(exit) _data = _data[0..index] ~ _data[index+1..$];
					return _data[index];
				}
			}
			return _nullValue();
		}
	}

	T removeAt(size_t index) {
		synchronized(this) {
			if (index >= _count) {
				throw new DataException.OutOfBounds(this.classinfo.name);
			}

			if (this.empty()) {
				throw new DataException.OutOfElements(this.classinfo.name);
			}

			_count--;
			scope(exit) _data = _data[0..index] ~ _data[index+1..$];
			return _data[index];
		}
	}

	T peek() {
		synchronized(this) {
			if (this.empty()) {
				throw new DataException.OutOfElements(this.classinfo.name);
			}

			return _data[_count-1];
		}
	}

	T peekAt(size_t index) {
		synchronized(this) {
			if (index >= _count) {
				throw new DataException.OutOfBounds(this.classinfo.name);
			}

			if (this.empty()) {
				throw new DataException.OutOfElements(this.classinfo.name);
			}

			return _data[index];
		}
	}

	template set(R) {
		void set(R value) {
			synchronized(this) {
				if (this.empty()) {
					throw new DataException.OutOfElements(this.classinfo.name);
				}

				if (_count > 0) {
					_data[_count-1] = cast(T)value;
				}
			}
		}
	}

	template setAt(R) {
		void setAt(size_t index, R value) {
			synchronized(this) {
				if (index >= _count) {
					throw new DataException.OutOfBounds(this.classinfo.name);
				}

				if (this.empty()) {
					throw new DataException.OutOfElements(this.classinfo.name);
				}

				_data[index] = cast(T)value;
			}
		}
	}

	template apply(R, S) {
		void apply(R delegate(S) func) {
			foreach(ref item; _data[0.._count]) {
				item = cast(T)func(item);
			}
		}
	}

	template contains(R) {
		bool contains(R value) {
			synchronized(this) {
				foreach(item; _data[0.._count]) {
					if (value == item) {
						return true;
					}
				}
			}
			return false;
		}
	}

	bool empty() {
		return (this.length() == 0);
	}

	void clear() {
		synchronized(this) {
			_data = new T[_data.length];
			_count = 0;
		}
	}

	// Properties

	T[] array() {
		return _data[0.._count].dup;
	}

	List!(T) dup() {
		synchronized(this) {
			List!(T) ret = new List!(T);
			ret._data = _data[0.._count].dup;
			ret._count = ret._data.length;

			return ret;
		}
	}

	List!(T) slice(size_t start, size_t end) {
		synchronized(this) {
			List!(T) ret = new List!(T);
			ret._data = _data[start..end].dup;
			ret._count = ret._data.length;

			return ret;
		}
	}

	List!(T) reverse() {
		synchronized(this) {
			List!(T) ret = new List!(T);

			ret._data = _data[0.._count].reverse;
			ret._count = ret._data.length;

			return ret;
		}
	}

	size_t length() {
		return _count;
	}

	// Operator Overrides (Using Generic Functions)

	T opIndex(size_t i1) {
		return peekAt(i1);
	}

	template opIndexAssign(R) {
		size_t opIndexAssign(R value, size_t i1) {
			setAt(i1, value);
			return i1;
		}
    }

	List!(T) opSlice() {
		return this.dup;
	}

	List!(T) opSlice(size_t start, size_t end) {
		return this.slice(start,end);
	}

	int opApply(int delegate(ref T) loopFunc) {
		synchronized(this) {
			int ret;

			for(int i = 0; i < _count; i++) {
				ret = loopFunc(_data[i]);
				if (ret) { break; }
			}

			return ret;
		}
	}

	int opApply(int delegate(ref size_t, ref T) loopFunc) {
		synchronized(this) {
			int ret;

			for(size_t i = 0; i < _count; i++) {
				ret = loopFunc(i,_data[i]);
				if (ret) { break; }
			}

			return ret;
		}
	}

	int opApplyReverse(int delegate(ref T) loopFunc) {
		synchronized(this) {
			int ret;

			for(size_t i = _count; ; ) {
				if (i == 0) { break; }
				i--;
				ret = loopFunc(_data[i]);
				if (ret) { break; }
			}

			return ret;
		}
	}

	int opApplyReverse(int delegate(ref size_t, ref T) loopFunc) {
		synchronized(this) {
			int ret;

			for(size_t i = _count; ; ) {
				if (i == 0) { break; }
				i--;
				ret = loopFunc(i,_data[i]);
				if (ret) { break; }
			}
			return ret;
		}
	}

	void opCatAssign(T[] list) {
		addList(list);
	}

	void opCatAssign(Iterable!(T) list) {
		addList(list);
	}

	void opCatAssign(T item) {
		add(item);
	}

	Iterable!(T) opCat(T[] list) {
		List!(T) ret = this.dup();
		ret.addList(list);
		return ret;
	}

	Iterable!(T) opCat(Iterable!(T) list) {
		List!(T) ret = this.dup();
		ret.addList(list);
		return ret;
	}

	Iterable!(T) opCat(T item) {
		List!(T) ret = this.dup();
		ret.add(item);
		return ret;
	}

	override string toString() {
		string ret = "[";

		synchronized(this) {
			foreach(i, item; this) {
				ret ~= toStr(item);
				if (i != this.length() - 1) {
					ret ~= ",";
				}
			}
		}

		ret ~= "]";

		return ret;
	}

protected:

	T _nullValue() {
		T val;
		return val;
/*		static if (IsArray!(T) || IsClass!(T)) {
			return null;
		}
		else static if (IsStruct!(T)) {
			return *(new T);
		}
		else {
			return 0;
		}*/
	}

	void _resize() {
		T[] temp = _data;
		if (_data.length == 0) {
			_data = new T[10];
		}
		else {
			_data = new T[_data.length*2];
		}
		_data[0..temp.length] = temp[0..$];
	}

	T[] _data;
	size_t _count;
}
