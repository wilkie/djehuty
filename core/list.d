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

module core.list;

import core.definitions;
import core.util;
import core.tostring;

interface ListInterface(T) {
	template add(R) {
		void add(R item);
	}

	template addAt(R) {
		void addAt(R item, size_t idx);
	}

	T remove();
	T removeAt(size_t idx);

	T peek();
	T peekAt(size_t idx);

	template set(R) {
		void set(R value);
	}		

	template setAt(R) {
		void setAt(size_t idx, R value);
	}

	template apply(R, S) {
		void apply(R delegate(S) func);
	}

	template contains(R) {
		bool contains(R value);
	}

	bool empty();
	void clear();
	T[] array();
	List!(T) dup();
	List!(T) slice(size_t start, size_t end);
	List!(T) reverse();
	size_t length();
	
	T opIndex(size_t i1);
	
	template opIndexAssign(R) {
		size_t opIndexAssign(R value, size_t i1);
	}
	
	int opApply(int delegate(ref T) loopFunc);

	int opApply(int delegate(ref int, ref T) loopFunc);
}

class List(T) : ListInterface!(T) {
	this() {
		_capacity = 10;
		_data = new T[_capacity];
		_count = 0;
	}

	this(int size) {
		_capacity = size;
		_data = new T[_capacity];
		_count = 0;
	}

	this(T[] list) {
	}

	this(List!(T) list) {
	}

	template add(R) {
		void add(R item) {
			synchronized(this) {
				if (_count >= _capacity) {
					_resize();
				}
				static if (IsArray!(R)) {
					_data[_count] = item.dup;
				}
				else {
					_data[_count] = cast(T)item;
				}
				_count++;
			}
		}
	}

	template addAt(R) {
		void addAt(R item, size_t idx) {
			synchronized(this) {
				if (_count >= _capacity) {
					_resize();
				}
				
				if (idx > _count) {
					idx = _count;
				}
				
				if (_count == 0) {
					idx = 0;
				}
				else if (_count != idx) {
					_data = _data[0..idx] ~ _data[idx] ~ _data[idx.._capacity];
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

	T removeAt(size_t index) {
		synchronized(this) {
			if (index >= _count) {
				return _nullValue();
			}
		
			_count--;
			scope(exit) _data = _data[0..index] ~ _data[index+1..$];
			return _data[index];
		}
	}

	T peek() {			
		synchronized(this) {
			if (this.empty()) {
				return _nullValue();
			}
			
			return _data[_count-1];
		}
	}

	T peekAt(size_t index) {		
		synchronized(this) {
			if (index >= _count) {
				return _nullValue();
			}
			return _data[index];
		}
	}

	template set(R) {
		void set(R value) {		
			synchronized(this) {
				if (_count > 0) {
					_data[_count-1] = cast(T)value;
				}
			}
		}
	}

	template setAt(R) {
		void setAt(size_t index, R value) {
			synchronized(this) {
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
			_data = new T[_capacity];
			_count = 0;
		}
	}

	// Properties

	T[] array() {
		return _data.dup;
	}

	List!(T) dup() {
		synchronized(this) {
			List!(T) ret = new List!(T);
			ret._data = _data[0.._count].dup;
			ret._capacity = ret._data.length;
			ret._count = ret._data.length;
	
			return ret;
		}
	}

	List!(T) slice(size_t start, size_t end) {
		synchronized(this) {
			List!(T) ret = new List!(T);
			ret._data = _data[start..end].dup;
			ret._capacity = ret._data.length;
			ret._count = ret._data.length;
	
			return ret;
		}
	}

	List!(T) reverse() {
		synchronized(this) {
			List!(T) ret = new List!(T);
	
			ret._data = _data[0.._count].reverse;
			ret._capacity = ret._data.length;
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
		int ret;

		for(int i = 0; i < _count; i++) {
			ret = loopFunc(_data[i]);
			if (ret) { break; }
		}

		return ret;
	}

	int opApply(int delegate(ref int, ref T) loopFunc) {
		int ret;

		for(int i = 0; i < _count; i++) {
			ret = loopFunc(i,_data[i]);
			if (ret) { break; }
		}

		return ret;
	}

	override string toString() {
		string ret = "[";

		synchronized(this) {
			foreach(int i, item; this) {
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
		static if (IsArray!(T) || IsClass!(T)) {
			return null;
		}
		else static if (IsStruct!(T)) {
			return *(new T);
		}
		else {
			return 0;
		}
	}

	void _resize() {
		_capacity *= 2;
		T[] temp = _data;
		_data = new T[_capacity];
		_data[0..temp.length] = temp[0..$];
	}

	T[] _data;
	size_t _capacity;
	size_t _count;
}

int[] range(int start, int end) {
	int[] ret = new int[end-start];
	for (int i = start, o; i < end; i++, o++) {
		ret[o] = i;
	}
	return ret;
}

template filter(T, S) {
	T[] filter(bool delegate(S) pred, T[] list) {
		T[] ret;
		foreach(item; list) {
			if (pred(item)) {
				ret ~= item;
			}
		}
		return ret.dup;
	}
}

template filter(T, S) {
    T[] filter(bool function(S) pred, T[] list) {
        T[] ret;
        foreach(item; list) {
            if (pred(item)) {
                ret ~= item;
            }
        }
        return ret.dup;
    }
}

template count(T, S) {
	size_t count(bool delegate(S) pred, T[] list) {
		size_t acc = 0;
        foreach(item; list) {
            if (pred(item)) {
            	acc++;
            }
        }
        return acc;
	}
}

template count(T, S) {
	size_t count(bool function(S) pred, T[] list) {
		size_t acc = 0;
        foreach(item; list) {
            if (pred(item)) {
            	acc++;
            }
        }
        return acc;
	}
}

template filterNot(T, S) {
	T[] filterNot(bool delegate(S) pred, T[] list) {
		T[] ret;
		foreach(item; list) {
			if (!pred(item)) {
				ret ~= item;
			}
		}
		return ret.dup;
	}
}

template filterNot(T, S) {
    T[] filterNot(bool function(S) pred, T[] list) {
        T[] ret;
        foreach(item; list) {
            if (!pred(item)) {
                ret ~= item;
            }
        }
        return ret.dup;
    }
}

template map(T, S) {
    S[] map(T function(S) func, T[] list) {
    	S[] ret = new S[list.length];
        foreach(uint i, item; list) {
        	ret[i] = func(item);
        }
        return ret;
    }
}

template map(T, S) {
    S[] map(T delegate(S) func, T[] list) {
    	S[] ret = new S[list.length];
        foreach(uint i, item; list) {
        	ret[i] = func(item);
        }
        return ret;
    }
}

template foldl(T, R, S) {
	S foldl(S delegate(R, R) func, T[] list) {
		if (list.length == 1) {
			return cast(S)list[0];
		}
		S acc = func(list[0], list[1]);
		foreach(item; list[2..$]) {
			acc = func(acc, item);
		}
		return acc;
	}
}

template foldl(T, R, S) {
	S foldl(S function(R, R) func, T[] list) {
		if (list.length == 1) {
			return cast(S)list[0];
		}
		S acc = func(list[0], list[1]);
		foreach(item; list[2..$]) {
			acc = func(acc, item);
		}
		return acc;
	}
}

template foldr(T, R, S) {
	S foldr(S delegate(R, R) func, T[] list) {
		if (list.length == 1) {
			return cast(S)list[0];
		}
		S acc = func(list[0], list[1]);
		foreach(item; list[2..$]) {
			acc = func(acc, item);
		}
		return acc;
	}
}

template foldr(T, R, S) {
	S foldr(S function(R, R) func, T[] list) {
		if (list.length == 1) {
			return cast(S)list[0];
		}
		S acc = func(list[$-2], list[$-1]);
		foreach_reverse(item; list[0..$-2]) {
			acc = func(item, acc);
		}
		return acc;
	}
}

template member(T, S) {
	T[] member(S value, T[] list) {
		foreach(uint i, item; list) {
			if (value == item) {
				return list[i..$];
			}
		}
		return null;
	}
}

template remove(T, S) {
	T[] remove(S value, T[] list) {
		foreach(uint i, item; list) {
			if (value == item) {
				return list[0..i] ~ list[i+1..$];
			}
		}
		return list;
	}
}

template remove(T, S, R, Q) {
	T[] remove(S value, T[] list, bool delegate(R, Q) equalFunc) {
		foreach(uint i, item; list) {
			if (equalFunc(value, item)) {
				return list[0..i] ~ list[i+1..$];
			}
		}
		return list;
	}
}

template car(T) {
	T car(T[] list) {
		return list[0];
	}
}

template cdr(T) {
	T[] cdr(T[] list) {
		return list[1..$];
	}
}

template cadr(T) {
	T cadr(T[] list) {
		return car(cdr(list));
	}
}

template caar(T) {
	T caar(T[][] list) {
		return car(car(list));
	}
}

template first(T) {
	T first(T[] list) {
		return list[0];
	}
}

template second(T) {
	T second(T[] list) {
		return list[1];
	}
}

template third(T) {
	T third(T[] list) {
		return list[2];
	}
}

template fourth(T) {
	T fourth(T[] list) {
		return list[3];
	}
}

template fifth(T) {
	T fifth(T[] list) {
		return list[4];
	}
}

template sixth(T) {
	T sixth(T[] list) {
		return list[5];
	}
}

template seventh(T) {
	T seventh(T[] list) {
		return list[6];
	}
}

template eighth(T) {
	T eighth(T[] list) {
		return list[7];
	}
}

template ninth(T) {
	T ninth(T[] list) {
		return list[8];
	}
}

template tenth(T) {
	T tenth(T[] list) {
		return list[9];
	}
}

template last(T) {
	T last(T[] list) {
		return list[$-1];
	}
}

template rest(T) {
	T[] rest(T[] list) {
		return list[1..$];
	}
}

template drop(T) {
	T[] drop(T[] list, uint num) {
		return list[num..$];
	}
}

template dropRight(T) {
	T[] dropRight(T[] list, uint num) {
		return list[0..$-num];
	}
}

template take(T) {
	T[] take(T[] list, uint num) {
		return list[0..num];
	}
}

template takeRight(T) {
	T[] takeRight(T[] list, uint num) {
		return list[$-num..$];
	}
}

template flatten(T) {
	BaseType!(T)[] flatten(T[] list) {
		static if (IsType!(T)) {
			// base case
			BaseType!(T)[] ret;
			foreach(item; list) {
				ret ~= item;
			}
			return ret;
		}
		else {
			// recursive
			BaseType!(T)[] ret;
			foreach(sublist; list) {
				ret ~= flatten(sublist);
			}
			return ret;
		}
	}
}

template argmin(T, R, S) {
	T argmin(S delegate(R) func, T[] list) {
		T min;
		uint idx = uint.max;
		foreach(uint i, item; list) {
			S cur = func(item);
			if (idx == uint.max || cur < min) {
				min = item;
			}
		}
		return min;
	}
}

template argmin(T, R, S) {
	T argmin(S function(R) func, T[] list) {
		T min;
		uint idx = uint.max;
		foreach(uint i, item; list) {
			S cur = func(item);
			if (idx == uint.max || cur < min) {
				min = item;
			}
		}
		return min;
	}
}

template argmax(T, R, S) {
	T argmax(S delegate(R) func, T[] list) {
		T max;
		uint idx = uint.max;
		foreach(uint i, item; list) {
			S cur = func(item);
			if (idx == uint.max || cur > max) {
				max = item;
			}
		}
		return max;
	}
}

template argmax(T, R, S) {
	T argmax(S function(R) func, T[] list) {
		T max;
		uint idx = uint.max;
		foreach(uint i, item; list) {
			S cur = func(item);
			if (idx == uint.max || cur > max) {
				max = item;
			}
		}
		return max;
	}
}

template makeList(T) {
	T[] makeList(uint amt, T item) {
		T[] ret = new T[amt];
		ret[] = item;
		return ret;
	}
}

template addBetween(T) {
	T[] addBetween(T[] list, T val) {
		T[] ret;
		for (uint i; i < list.length - 1; i++) {
			ret ~= list[i];
			ret ~= val;
		}
		ret ~= list[$-1];

		return ret;
	}
}
