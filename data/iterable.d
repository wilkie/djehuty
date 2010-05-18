module data.iterable;

import djehuty;
import io.console;

// Description: This template resolves to true when the type T is
//   either an array or a class that inherits from Iterable.
template IsIterableImpl(int idx = 0, Base, T...) {
	static if (idx == T.length) {
		// Go to the base class and start over...
		const bool IsIterableImpl = IsIterable!(Super!(Base));
	}
	else static if (IsInterface!(T[idx])) {
		// Check each interface for whether it is Iterable
		static if (T[idx].stringof == "Iterable") {
			const bool IsIterableImpl = true;
		}
		else {
			const bool IsIterableImpl = IsIterableImpl!(idx+1, Base, T);
		}
	}
	else {
		// Well... this doesn't make sense... give up!
		const bool IsIterableImpl = false;
	}
}

template IsIterable(T) {
	static if (IsArray!(T)) {
		// T is an array, so it is iterable
		const bool IsIterable = true;
	}
	else static if (is(T == Object)) {
		// Cannot be iterable if T is Object
		const bool IsIterable = false;
	}
	else static if (IsInterface!(T)) {
		static if (T.stringof == "Iterable") {
			const bool IsIterable = true;
		}
		else {
			const bool IsIterable = false;
		}
	}
	else static if (IsClass!(T)) {
		// It is some class... we should read its interfaces
		const bool IsIterable = IsIterableImpl!(0, T, Interfaces!(T));
	}
	else {
		// It is some other type...
		const bool IsIterable = false;
	}
}

// Description: Returns Iterable!(T) for any class that inherits Iterable.
template BaseIterable(T) {
	static if (IsClass!(T)) {
		static if (is(T == Object)) {
			alias T BaseIterable;
		}
		else {
			alias BaseIterable!(Super!(T)) BaseIterable;
		}
	}
	static if (IsInterface!(T)) {
		alias T BaseIterable;
	}
	else {
		alias T BaseIterable;
	}
}

// Description: This template resolves to the base type for any class that
//   inherits Iterable or any array. That is int[][] will return int.
//   And List!(List!(int)) will return int.
template BaseIterableType(T) {
	static if (IsIterable!(IterableType!(T))) {
		alias BaseIterableType!(IterableType!(T)) BaseIterableType;
	}
	else {
		alias IterableType!(T) BaseIterableType;
	}
}

// Description: This template resolves to the iterated type for any class that
//   inherits Iterable or any array. That is int[][] will return int[].
//   And List!(List!(int)) will return List!(int). int[] will return int.
template IterableType(T) {
	static if (IsIterable!(T)) {
		static if (IsArray!(T)) {
			alias ArrayType!(T) IterableType;
		}
		else {
			alias T.BaseType IterableType;
		}
	}
	else {
		alias T IterableType;
	}
}

interface Iterable(T) {
	private alias T BaseType;

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
	Iterable!(T) dup();
	Iterable!(T) slice(size_t start, size_t end);
	Iterable!(T) reverse();
	size_t length();

	T opIndex(size_t i1);

	template opIndexAssign(R) {
		size_t opIndexAssign(R value, size_t i1);
	}

	int opApply(int delegate(ref T) loopFunc);
	int opApply(int delegate(ref size_t, ref T) loopFunc);

	int opApplyReverse(int delegate(ref T) loopFunc);
	int opApplyReverse(int delegate(ref size_t, ref T) loopFunc);

	Iterable!(T) opCat(T[] list);
	Iterable!(T) opCat(Iterable!(T) list);
	Iterable!(T) opCat(T item);

	void opCatAssign(T[] list);
	void opCatAssign(Iterable!(T) list);
	void opCatAssign(T item);

}

int[] range(int start, int end) {
	int[] ret = new int[end-start];
	for (int i = start, o; i < end; i++, o++) {
		ret[o] = i;
	}
	return ret;
}

template filter(T, S) {
	static assert(IsIterable!(T), "filter: " ~ T.stringof ~ " is not iterable.");
	T filter(bool delegate(S) pred, T list) {
		T ret;
		static if (!IsArray!(T)) {
			ret = new T;
		}
		foreach(item; list) {
			if (pred(item)) {
				ret ~= item;
			}
		}
		return ret;
	}
}

template filter(T, S) {
	static assert(IsIterable!(T), "filter: " ~ T.stringof ~ " is not iterable.");
    T filter(bool function(S) pred, T list) {
        T ret;
		static if (!IsArray!(T)) {
			ret = new T;
		}
        foreach(item; list) {
            if (pred(item)) {
                ret ~= item;
            }
        }
        return ret;
    }
}

template count(T, S) {
	static assert(IsIterable!(T), "count: " ~ T.stringof ~ " is not iterable.");
	size_t count(bool delegate(S) pred, T list) {
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
	static assert(IsIterable!(T), "count: " ~ T.stringof ~ " is not iterable.");
	size_t count(bool function(S) pred, T list) {
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
	static assert(IsIterable!(T), "filterNot: " ~ T.stringof ~ " is not iterable.");
	T filterNot(bool delegate(S) pred, T list) {
		T ret;
		static if (!IsArray!(T)) {
			ret = new T;
		}
		foreach(item; list) {
			if (!pred(item)) {
				ret ~= item;
			}
		}
		return ret;
	}
}

template filterNot(T, S) {
	static assert(IsIterable!(T), "filterNot: " ~ T.stringof ~ " is not iterable.");
    T filterNot(bool function(S) pred, T list) {
        T ret;
		static if (!IsArray!(T)) {
			ret = new T;
		}
        foreach(item; list) {
            if (!pred(item)) {
                ret ~= item;
            }
        }
        return ret;
    }
}

template map(T, R, S) {
	static assert(IsIterable!(T), "map: " ~ T.stringof ~ " is not iterable.");
    S[] map(S delegate(R) func, T list) {
		S[] ret;
		ret = new S[list.length];

        foreach(size_t i, R item; list) {
			ret[i] = func(item);
        }

        return ret;
    }
}

template map(T, R, S) {
	static assert(IsIterable!(T), "map: " ~ T.stringof ~ " is not iterable.");
    S[] map(S function(R) func, T list) {
		S[] ret;
		ret = new S[list.length];

        foreach(uint i, item; list) {
			ret[i] = func(item);
        }

        return ret;
    }
}

template foldl(T, R, S) {
	static assert(IsIterable!(T), "foldl: " ~ T.stringof ~ " is not iterable.");
	S foldl(S delegate(R, R) func, T list) {
		if (list.length == 1) {
			return cast(S)list[0];
		}
		S acc = func(list[0], list[1]);
		foreach(item; list[2..list.length]) {
			acc = func(acc, item);
		}
		return acc;
	}
}

template foldl(T, R, S) {
	static assert(IsIterable!(T), "foldl: " ~ T.stringof ~ " is not iterable.");
	S foldl(S function(R, R) func, T list) {
		if (list.length == 1) {
			return cast(S)list[0];
		}
		S acc = func(list[0], list[1]);
		foreach(item; list[2..list.length]) {
			acc = func(acc, item);
		}
		return acc;
	}
}

template foldr(T, R, S) {
	static assert(IsIterable!(T), "foldr: " ~ T.stringof ~ " is not iterable.");
	S foldr(S delegate(R, R) func, T list) {
		if (list.length == 1) {
			return cast(S)list[0];
		}
		S acc = func(list[list.length-2], list[list.length-1]);
		foreach_reverse(item; list[0..list.length-2]) {
			acc = func(item, acc);
		}
		return acc;
	}
}

template foldr(T, R, S) {
	static assert(IsIterable!(T), "foldr: " ~ T.stringof ~ " is not iterable.");
	S foldr(S function(R, R) func, T list) {
		if (list.length == 1) {
			return cast(S)list[0];
		}
		S acc = func(list[list.length-2], list[list.length-1]);
		foreach_reverse(item; list[0..list.length-2]) {
			acc = func(item, acc);
		}
		return acc;
	}
}

template member(T, S) {
	static assert(IsIterable!(T), "member: " ~ T.stringof ~ " is not iterable.");
	T member(S value, T list) {
		foreach(size_t i, S item; list) {
			if (value == item) {
				return list[i..list.length];
			}
		}
		return null;
	}
}

template remove(T, S) {
	static assert(IsIterable!(T), "remove: " ~ T.stringof ~ " is not iterable.");
	T remove(S value, T list) {
		foreach(uint i, item; list) {
			if (value == item) {
				return cast(T)(list[0..i] ~ list[i+1..list.length]);
			}
		}
		return list;
	}
}

template remove(T, S, R, Q) {
	static assert(IsIterable!(T), "remove: " ~ T.stringof ~ " is not iterable.");
	T remove(S value, T list, bool delegate(R, Q) equalFunc) {
		foreach(uint i, item; list) {
			if (equalFunc(value, item)) {
				return cast(T)(list[0..i] ~ list[i+1..list.length]);
			}
		}
		return list;
	}
}

template car(T) {
	static assert(IsIterable!(T), "car: " ~ T.stringof ~ " is not iterable.");
	IterableType!(T) car(T list) {
		return list[0];
	}
}

template cdr(T) {
	static assert(IsIterable!(T), "cdr: " ~ T.stringof ~ " is not iterable.");
	T cdr(T list) {
		return list[1..list.length];
	}
}

template cadr(T) {
	static assert(IsIterable!(T), "cadr: " ~ T.stringof ~ " is not iterable.");
	IterableType!(T) cadr(T list) {
		return car(cdr(list));
	}
}

template caar(T) {
	static assert(IsIterable!(T), "caar: " ~ T.stringof ~ " is not iterable.");
	static assert(IsIterable!(IterableType!(T)), "caar: " ~ T.stringof ~ "'s inner type (" ~ IterableType!(T).stringof ~ ") is not iterable.");
	IterableType!(IterableType!(T)) caar(T list) {
		return car(car(list));
	}
}

template first(T) {
	static assert(IsIterable!(T), "first: " ~ T.stringof ~ " is not iterable.");
	IterableType!(T) first(T list) {
		return list[0];
	}
}

template second(T) {
	static assert(IsIterable!(T), "second: " ~ T.stringof ~ " is not iterable.");
	IterableType!(T) second(T list) {
		return list[1];
	}
}

template third(T) {
	static assert(IsIterable!(T), "third: " ~ T.stringof ~ " is not iterable.");
	IterableType!(T) third(T[] list) {
		return list[2];
	}
}

template fourth(T) {
	static assert(IsIterable!(T), "fourth: " ~ T.stringof ~ " is not iterable.");
	IterableType!(T) fourth(T list) {
		return list[3];
	}
}

template fifth(T) {
	static assert(IsIterable!(T), "fifth: " ~ T.stringof ~ " is not iterable.");
	IterableType!(T) fifth(T list) {
		return list[4];
	}
}

template sixth(T) {
	static assert(IsIterable!(T), "sixth: " ~ T.stringof ~ " is not iterable.");
	IterableType!(T) sixth(T list) {
		return list[5];
	}
}

template seventh(T) {
	static assert(IsIterable!(T), "seventh: " ~ T.stringof ~ " is not iterable.");
	IterableType!(T) seventh(T list) {
		return list[6];
	}
}

template eighth(T) {
	static assert(IsIterable!(T), "eighth: " ~ T.stringof ~ " is not iterable.");
	IterableType!(T) eighth(T list) {
		return list[7];
	}
}

template ninth(T) {
	static assert(IsIterable!(T), "ninth: " ~ T.stringof ~ " is not iterable.");
	IterableType!(T) ninth(T list) {
		return list[8];
	}
}

template tenth(T) {
	static assert(IsIterable!(T), "tenth: " ~ T.stringof ~ " is not iterable.");
	IterableType!(T) tenth(T list) {
		return list[9];
	}
}

template last(T) {
	static assert(IsIterable!(T), "last: " ~ T.stringof ~ " is not iterable.");
	IterableType!(T) last(T list) {
		return list[list.length-1];
	}
}

template rest(T) {
	static assert(IsIterable!(T), "rest: " ~ T.stringof ~ " is not iterable.");
	T rest(T list) {
		return list[1..list.length];
	}
}

template drop(T) {
	static assert(IsIterable!(T), "drop: " ~ T.stringof ~ " is not iterable.");
	T drop(T list, uint num) {
		return list[num..list.length];
	}
}

template dropRight(T) {
	static assert(IsIterable!(T), "dropRight: " ~ T.stringof ~ " is not iterable.");
	T dropRight(T list, uint num) {
		return list[0..list.length-num];
	}
}

template take(T) {
	static assert(IsIterable!(T), "take: " ~ T.stringof ~ " is not iterable.");
	T take(T list, uint num) {
		return list[0..num];
	}
}

template takeRight(T) {
	static assert(IsIterable!(T), "takeRight: " ~ T.stringof ~ " is not iterable.");
	T takeRight(T list, uint num) {
		return list[list.length-num..list.length];
	}
}

template flatten(T) {
	static assert(IsIterable!(T), "flatten: " ~ T.stringof ~ " is not iterable.");
	BaseIterableType!(T)[] flatten(T list) {
		static if (IsIterable!(IterableType!(T))) {
			// recursive
			BaseIterableType!(T)[] ret;
			foreach(sublist; list) {
				ret ~= flatten(sublist);
			}
			return ret;
		}
		else {
			// base case
			BaseIterableType!(T)[] ret;
			foreach(item; list) {
				ret ~= item;
			}
			return ret;
		}
	}
}

template argmin(T, R, S) {
	static assert(IsIterable!(T), "argmin: " ~ T.stringof ~ " is not iterable.");
	IterableType!(T) argmin(S delegate(R) func, T list) {
		IterableType!(T) min;
		uint idx = uint.max;
		foreach(uint i, item; list) {
			S cur = func(item);
			if (idx == uint.max || cur < min) {
				idx = i;
				min = item;
			}
		}
		return min;
	}
}

template argmin(T, R, S) {
	static assert(IsIterable!(T), "argmin: " ~ T.stringof ~ " is not iterable.");
	IterableType!(T) argmin(S function(R) func, T list) {
		IterableType!(T) min;
		uint idx = uint.max;
		foreach(uint i, item; list) {
			S cur = func(item);
			if (idx == uint.max || cur < min) {
				idx = i;
				min = item;
			}
		}
		return min;
	}
}

template argmax(T, R, S) {
	static assert(IsIterable!(T), "argmax: " ~ T.stringof ~ " is not iterable.");
	IterableType!(T) argmax(S delegate(R) func, T list) {
		IterableType!(T) max;
		uint idx = uint.max;
		foreach(uint i, item; list) {
			S cur = func(item);
			if (idx == uint.max || cur > max) {
				idx = i;
				max = item;
			}
		}
		return max;
	}
}

template argmax(T, R, S) {
	static assert(IsIterable!(T), "argmax: " ~ T.stringof ~ " is not iterable.");
	IterableType!(T) argmax(S function(R) func, T list) {
		IterableType!(T) max;
		uint idx = uint.max;
		foreach(uint i, item; list) {
			S cur = func(item);
			if (idx == uint.max || cur > max) {
				idx = i;
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

template addBetween(T, S) {
	T addBetween(T list, S val) {
		T ret;
		static if (!IsArray!(T)) {
			ret = new T;
		}
		for (uint i; i < list.length - 1; i++) {
			ret ~= [list[i], val];
		}
		ret ~= [list[list.length-1]];

		return ret;
	}
}

// Description: This function will rotate an array by shifting the contents in place.
// list: An Iterable type.
// amount: The amount to rotate to the left. To rotate to the right, specify a negative value.
// Returns: Simply returns the reference to the input.
template rotate(T) {
	static assert(IsIterable!(T), "rotate: " ~ T.stringof ~ " is not iterable.");
	IterableType!(T)[] rotate(T list, int amount) {
		if (list.length == 0) {
			return list;
		}

		amount %= list.length;
		if (amount == 0) {
			return list;
		}

		IterableType!(T) tmp;

		size_t iterations = 1;
		if ((list.length % amount) == 0) {
			// Will require multiple passes
			iterations = amount;
		}

		// Figure out the number of swaps per iteration
		size_t maxSwaps = list.length / iterations;
		maxSwaps--;		// account for final swap outside of loop

		while(iterations > 0) {
			size_t swapWith;
			size_t swapIndex = iterations-1;
			tmp = list[swapIndex];
			for (size_t i = 0; i < maxSwaps; i++) {
				swapWith = (swapIndex + amount) % list.length;
				list[swapIndex] = list[swapWith];
				swapIndex = swapWith;
			}
			list[swapIndex] = tmp;

			iterations--;
		}

		return list;
	}
}

// Description: This function will reverse the contents of the array in place. It will respect unicode
//   encoding in terms of grouping combining marks for utf encoded strings.
// list: An Iterable type.
// Returns: Simply returns the reference to the input.
template reverse(T) {
	static assert(IsIterable!(T), "reverse: " ~ T.stringof ~ " is not iterable.");
	IterableType!(T)[] reverse(T list) {
		static if (IsCharType!(IterableType!(T))) {
			// We are reversing a unicode string
			return unicode_reverse(list);
		}
		else {
			// Normal reverse
			size_t front, end;

			// Go from front to end, and swap each index

			// Note: Since the array passed has a length measured in a factor
			//   of elementSize, we need to account for that when we treat
			//   it is a byte array.

			if (list.length == 0) {
				return list;
			}

			front = 0;
			end = list.length-1;

			while(front < end) {
				IterableType!(T) tmp = list[front];
				list[front] = list[end];
				list[end] = tmp;

				front++;
				end--;
			}

			return list;
		}
	}
}

// This internal function will reverse a unicode string of any flavor.
private template unicode_reverse(T) {
	T[] unicode_reverse(T[] a) {
		// for all elements in 'a'
		// A: Identify two substrings to swap
		// B: Swap

		size_t frontIndex = 0;
		size_t frontLength = 0;

		size_t endIndex = a.length;
		size_t endLength = 0;

		size_t swapLength = 0;
		int swapRotate = 0;

		// Two sections will swap: 
		// - a[frontIndex..frontIndex+frontLength]
		// - a[endIndex..endIndex+endLength]

		// If the two sections do not completely match up, it passes
		// responsibility to the next iteration to move the remaining elements.

		// Like so:
		// [0][1][ ][ ][ ][ ][2][3][4]
		//  \- frontIndex
		// |----| frontLength
		//                    \- endIndex
		//                   |-------| endLength

		// Will become:
		// [2][3][ ][ ][ ][ ][4][0][1]
		//       |-------------| next iteration
		//                    \- endIndex
		//                   |-| - endLength

		// The next iteration will move the remaining elements to the front during
		// the swap phase. This is done to avoid phase shifting an array and to
		// promote a O(1) space complexity.

		while(frontIndex <= endIndex) {
			// Find length of next substring to swap
			if (frontLength == 0) {
				frontLength = 1;
				while(!Unicode.isStartChar(a[frontIndex+frontLength]) 
						|| Unicode.isDeadChar(a[frontIndex+frontLength..$])) {
					if (frontIndex + frontLength == endIndex) {
						// Do not count it if it is within the endIndex,
						// This would mean the combining marks have been swapped onto another character
						break;
					}
					frontLength++;
				}
			}

			// Find length of next substring from end to swap with
			if (endLength == 0) {
				endIndex--;
				while(!Unicode.isStartChar(a[endIndex]) 
						|| Unicode.isDeadChar(a[endIndex..$])) {
					endIndex--;
					endLength++;
				}
				endLength++;
			}

			if (frontIndex + frontLength > endIndex) {
				// We do not have to move the middle substring
				break;
			}

			// Figure out the number to swap (lowest length)
			if (frontLength < endLength) {
				swapLength = frontLength;
				swapRotate = cast(int)(swapLength);

				// Shift end
				a[endIndex..endIndex+endLength].rotate(swapRotate);
			}
			else {
				swapLength = endLength;
				swapRotate = cast(int)(cast(long)frontLength - cast(long)swapLength);

				// Shift front
				a[frontIndex..frontIndex+frontLength].rotate(swapRotate);
			}

			// xor swap front and end
			for(size_t swapCount = 0; swapCount < swapLength; swapCount++) {
				size_t index1 = frontIndex + swapCount;
				size_t index2 = endIndex + endLength - swapLength + swapCount;
				a[index1] ^= a[index2];
				a[index2] ^= a[index1];
				a[index1] ^= a[index2];
			}

			// Move to next position in string
			frontIndex += swapLength;

			frontLength -= swapLength;
			endLength -= swapLength;
		}

		return a;
	}
}


