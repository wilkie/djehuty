/*
 * array.d
 *
 * This module implements the runtime functions related
 * to arrays.
 *
 */

module runtime.array;

import core.unicode;

import runtime.common;

import core.util;

private {
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


// This is here due to a compiler bug...
// eventually, remove this and uncomment the following line
// import data.iterable : rotate;
private template rotate(T) {
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

		if ((amount % list.length) == 0) {
			// Will require multiple passes
		}
		else {
			size_t swapWith;
			size_t swapIndex = 0;
			tmp = list[0];
			for (size_t i = 0; i < list.length-1; i++) {
				swapWith = (swapIndex + amount) % list.length;
				list[swapIndex] = list[swapWith];
				swapIndex = swapWith;
			}
			list[swapIndex] = tmp;
		}

		return list;
	}
}

}
extern(C):

// Description: This runtime function reverses a char array in place and is invoked with
//   the reverse property: array.reverse
char[] _adReverseChar(char[] a) {
	// for all elements in 'a'
	// A: Identify two substrings to swap
	// B: Swap

	size_t frontIndex = 0;
	size_t frontLength = 0;

	size_t endIndex = a.length-1;
	size_t endLength = 0;

	size_t swapLength = 0;

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

	while(frontIndex < endIndex) {
		// Find length of next substring to swap
		if (frontLength == 0) {
			frontLength = 1;
			while(!Unicode.isStartChar(a[frontIndex+frontLength]) 
			  || Unicode.isDeadChar(a[frontIndex+frontLength..$])) {
				frontLength++;
			}
		}

		// Find length of next substring from end to swap with
		if (endLength == 0) {
			while(!Unicode.isStartChar(a[endIndex]) 
					|| Unicode.isDeadChar(a[endIndex..$])) {
				endIndex--;
				endLength++;
			}
			endLength++;
		}

		if (frontIndex + frontLength >= endIndex) {
			// We do not have to move the middle substring
			break;
		}

		// Figure out the number to swap (lowest length)
		if (frontLength < endLength) {
			swapLength = frontLength;

			// Shift end
			a[endIndex..endIndex+endLength].rotate(swapLength);
		}
		else {
			swapLength = endLength;

			// Shift front
			a[frontIndex..frontIndex+frontLength].rotate(swapLength);
		}

		// xor swap front and end
		while(swapLength != 0) {
			swapLength--;
			size_t index1 = frontIndex + swapLength;
			size_t index2 = endIndex + swapLength;
			a[index1] ^= a[index2];
			a[index2] ^= a[index1];
			a[index1] ^= a[index2];
		}

		// Move to next position in string
		frontIndex += frontLength;
		endIndex--;

		frontLength -= swapLength;
		endLength -= swapLength;
	}

	return a;
}

// Description: This runtime function reverses a wchar array in place and is invoked with
//   the reverse property: array.reverse
wchar[] _adReverseWchar(wchar[] a) {
	return null;
}

// Description: This runtime function reverses an array in place and
//   is invoked with the reverse property: array.reverse
// array: The generic array struct that contains the array items.
// elementSize: The size of an individual element.
void[] _adReverse(void[] array, size_t elementSize) {
	return array;
}

// Description: This runtime function will compare two arrays.
// Returns: 0 when equal, positive when first array is larger, negative otherwise.
int _adCmp(void[] a1, void[] a2, TypeInfo ti) {
	return ti.compare(&a1, &a2);
}

int _adCmpChar(void[] a1, void[] a2) {
	return _adCmp(a1, a2, typeid(char));
}

// Description: This runtime function will compare two arrays for equality.
// Returns: 1 when equal, 0 otherwise
int _adEq(void[] a1, void[] a2, TypeInfo ti) {
	return ti.equals(&a1, &a2);
}

// Description: This runtime function sorts an array and is invoked with
// the sort property: array.sort
Array _adSort(Array a, TypeInfo ti) {
	return a;
}

// Description: This runtime function sorts a char array and is invoked with
// the sort property: array.sort
char[] _adSortChar(char[] a) {
	return null;
}

// Description: This runtime function sorts a wchar array and is invoked with
// the sort property: array.sort
wchar[] _adSortWchar(wchar[] a) {
	return null;
}
