/*
 * assocarray.d
 *
 * This module implements the D runtime functions that involve
 * associative arrays.
 *
 */

module runtime.assocarray;

import runtime.gc;

import synch.atomic;

import binding.c;
import io.console;

extern(C):

struct Entry {
	hash_t hash;
	ubyte[] key;
	ubyte[] value;
}

struct Bucket {
	Entry[5] entries;
	ulong usedCount;
}

struct AssocArray {
	Bucket[] buckets;
	size_t valuesize;
	size_t range;
	size_t items;
	TypeInfo keyTypeInfo;
}

// Description: This runtime function will determine the number of entries in
//   an associative array.
// Returns: The number of entries in the array.
size_t _aaLen(ref AssocArray aa) {
	return aa.items;
}

template _aaAccess(bool addKey, bool deleteKey) {
	ubyte* _aaAccess(ref AssocArray* aa, TypeInfo keyti, size_t valuesize, ubyte* pkey) {
					
		// If we can update the array to add the key, 
		// and the array does not exist, then create it!
		static if (addKey) {
			if (aa is null) {
				// Create a new associative array
				aa = new AssocArray();

				// Assign the associative array the TypeInfo of the keys
				aa.keyTypeInfo = keyti;

				// Set up the default buckets
				static const int startingSize = 3000;
				aa.buckets = new Bucket[startingSize];
				aa.range = startingSize;
			}
		}
		else {
			// If the array does not exist, the item can't... 
			// so just return null
			if (aa is null) {
				return null;
			}
		}

		// Get the hash
		hash_t hash = aa.keyTypeInfo.getHash(pkey);

		// Find the bucket
		size_t bucketIndex = hash % aa.range;

		// If the bucket is in the lower half, it may have been rehashed to the upper half
		if (bucketIndex < aa.buckets.length - aa.range) {
			bucketIndex = hash % (2 * aa.range);
		}

		// Search for the value
		foreach(size_t idx, entry; aa.buckets[bucketIndex].entries) {
			if (entry.key !is null) {
				// compare the bucket with the hash
				int cmp = keyti.compare(pkey, entry.key.ptr);
				if (cmp == 0) {
					// Good, we found the item

					// Delete the key here
					static if (deleteKey) {
						entry.key = null;
						entry.value = null;
						Atomic.decrement(aa.buckets[bucketIndex].usedCount);
						Atomic.decrement(aa.items);
					}

					// Return a reference to the value
					return entry.value.ptr;
				}
			}
		}

		static if (addKey) {
			// Add the value (rehashing if necessary)

			while(aa.buckets[bucketIndex].usedCount == aa.buckets[bucketIndex].entries.length) {
				// Hmm, no free buckets... Rehash
				_aaRehash(aa, keyti);

				// Find the bucket (if it has changed)
				bucketIndex = hash % aa.range;

				// If the bucket is in the lower half, it may have been rehashed to the upper half
				if (bucketIndex < aa.buckets.length - aa.range) {
					bucketIndex = hash % (2 * aa.range);
				}
			}

			// Scan for the empty item
			Atomic.increment(aa.buckets[bucketIndex].usedCount);
			Atomic.increment(aa.items);
			foreach(ref entry; aa.buckets[bucketIndex].entries) {
				if (entry.key is null) {
					// Add item here by allocating memory for the key and value
					entry.hash = hash;
					entry.key = GarbageCollector.malloc(keyti.tsize()); 
					entry.value = GarbageCollector.malloc(valuesize);
					
					// Insert the key into the table
					entry.key[0..keyti.tsize()] = pkey[0..keyti.tsize()];

					// Return a pointer to the value
					return entry.value.ptr;
				}
			}
			assert(false, "Associative Array Add Item Failure");
		}

		// Did not find the item
		return null;
	}
}

// Description: This runtime function will return a pointer to the value
//   in an associative array at a particular key and add the entry if
//   it does not exist.
// Returns: A pointer to the value associated with the given key.
ubyte* _aaGet(ref AssocArray* aa, TypeInfo keyti, size_t valuesize, ubyte* pkey) {
	return _aaAccess!(true, false)(aa, keyti, valuesize, pkey);
}

// Description: This runtime function will get a pointer to a value in an
//   associative array indexed by a key. Invoked via "aa[key]" and "key in aa".
// Returns: null when the value is not in aa, the pointer to the value
//   otherwise.
ubyte* _aaIn(ref AssocArray aa, TypeInfo keyti, ubyte* pkey) {
	AssocArray* arrayPointer = &aa;
	return _aaAccess!(false, false)(arrayPointer, keyti, 0, pkey);
}

// Description: This runtime function will delete a value with the given key.
//   It will do nothing if the value does not exist.
void _aaDel(ref AssocArray aa, TypeInfo keyti, ubyte* pkey) {
	AssocArray* arrayPointer = &aa;
	_aaAccess!(false, true)(arrayPointer, keyti, 0, pkey);
}

// Description: This runtime function will produce an array of keys of an
//   associative array.
// Returns: An array of keys.
ubyte[] _aaKeys(ref AssocArray aa, size_t keysize) {
	// Sweep through every bucket, appending each key
	if (&aa is null) {
		return null;
	}

	ubyte[] ret;
	foreach(bucket; aa.buckets) {
		if (bucket.usedCount == 0) {
			continue;	
		}

		foreach(entry; bucket.entries) {
			if (entry.key !is null) {
				ret ~= entry.key;
			}
		}
	}
	return ret[0..aa.items];
}

// Description: This runtime function will produce an array of values for
//   an associative array.
// Returns: An array of values.
ubyte[] _aaValues(ref AssocArray aa, size_t keysize, size_t valuesize) {
	// Sweep through every bucket, appending each key
	if (&aa is null) {
		return null;
	}

	ubyte[] ret;
	foreach(bucket; aa.buckets) {
		if (bucket.usedCount == 0) {
			continue;	
		}
		foreach(entry; bucket.entries) {
			if (entry.key !is null) {
				ret ~= entry.value;
			}
		}
	}
	return ret[0..aa.items];
}

// Description: This runtime function will rehash an associative array.
AssocArray* _aaRehash(ref AssocArray* aa, TypeInfo keyti) {
	// In this implementation, we will add buckets and rehash when necessary
	// This will increase the space. If done prematurely, it may only help
	// if we know we are going to do a lot of additional items in a time
	// sensitive application.

	size_t rehashBucketIndex = aa.buckets.length - aa.range;

	// Increase the number of buckets
	aa.buckets.length = aa.buckets.length + 1;

	// Rehash a bucket
	foreach(ref element; aa.buckets[rehashBucketIndex].entries) {
		if (element.key !is null) {
			// Rehash
			size_t newBucketIndex;

			newBucketIndex = element.hash % (2 * aa.range);
			if (newBucketIndex != rehashBucketIndex) {

				// Move (TODO: lockfree atomic exchange?)
				foreach(ref newElement; aa.buckets[newBucketIndex].entries) {
					if (newElement.key is null) {
						newElement = element;
						
						// We found one, break
						// Otherwise, we end up moving element twice :P
						break;
					}
				}

				// Remove old references
				element.key = null;
				element.value = null;

				Atomic.decrement(aa.buckets[rehashBucketIndex].usedCount);
				Atomic.increment(aa.buckets[newBucketIndex].usedCount);
			}
		}
	}

	// Update range if possible
	if (aa.buckets.length == (2 * aa.range)) {
		aa.range *= 2;
	}

	return aa;
}

// Description: This runtime function will handle a foreach for an associative
//   array invoked as foreach(foo; aa).
extern (D) typedef int delegate(void *) dg_t;
int _aaApply(ref AssocArray aa, size_t keysize, dg_t dg) {
	return 0;
}

// Description: This runtime function will handle a foreach_reverse for an
// associative array invoked as foreach_reverse(foo; aa).
extern (D) typedef int delegate(void *, void *) dg2_t;
int _aaApply2(ref AssocArray aa, size_t keysize, dg2_t dg) {
	return 0;
}

