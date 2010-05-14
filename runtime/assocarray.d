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

extern(C):

struct Entry {
	hash_t hash;
	ubyte[] key;
	ubyte[] value;
}

struct Bucket {
	Entry[3] entries;
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

template _aaAccess(bool addKey) {
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
				aa.buckets = new Bucket[8];
				aa.range = 8;
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

		printf("bucket index: %d\n", bucketIndex);

		// Search for the value
		foreach(size_t idx, bucket; aa.buckets[bucketIndex].entries) {
			printf("checking bucket %d @ %p\n", idx, bucket.key.ptr);
			if (bucket.key.ptr !is null) {
				// compare the bucket with the hash
				printf("comparing...\n");
				int cmp = keyti.compare(pkey, bucket.key.ptr);
				printf("cmp: %d\n", cmp);
				if (cmp == 0) {
					// Good, we found the item
					printf("item found!\n");
					return bucket.value.ptr;
				}
			}
		}

		printf("hmm, item not found\n");
		static if (addKey) {
			// Add the value (rehashing if necessary)

			while(aa.buckets[bucketIndex].usedCount == aa.buckets[bucketIndex].entries.length) {
				// Hmm, no free buckets... Rehash
				printf("rehashing!\n");
				_aaRehash(aa, keyti);

			}

			// Scan for the empty item
			Atomic.increment(aa.buckets[bucketIndex].usedCount);
			Atomic.increment(aa.items);
			foreach(ref bucket; aa.buckets[bucketIndex].entries) {
				if (bucket.key.ptr is null) {
					// Add item here by allocating memory for the key and value
					bucket.hash = hash;
					bucket.key = GarbageCollector.malloc(keyti.tsize()); 
					bucket.value = GarbageCollector.malloc(valuesize);
					
					// Insert the key into the table
					bucket.key[0..keyti.tsize()] = pkey[0..keyti.tsize()];

					// Return a pointer to the value
					return bucket.value.ptr;
				}
			}
		}

		return null;
	}
}

// Description: This runtime function will return a pointer to the value
//   in an associative array at a particular key and add the entry if
//   it does not exist.
// Returns: A pointer to the value associated with the given key.
ubyte* _aaGet(ref AssocArray* aa, TypeInfo keyti, size_t valuesize, ubyte* pkey) {
	return _aaAccess!(true)(aa, keyti, valuesize, pkey);
}

// Description: This runtime function will get a pointer to a value in an
//   associative array indexed by a key. Invoked via "aa[key]" and "key in aa".
// Returns: null when the value is not in aa, the pointer to the value
//   otherwise.
ubyte* _aaIn(ref AssocArray aa, TypeInfo keyti, ubyte* pkey) {
	AssocArray* arrayPointer = &aa;
	return _aaAccess!(false)(arrayPointer, keyti, 0, pkey);
}

// Description: This runtime function will delete a value with the given key.
//   It will do nothing if the value does not exist.
void _aaDel(ref AssocArray aa, TypeInfo keyti, void* pkey) {
}

// Description: This runtime function will produce an array of keys of an
//   associative array.
// Returns: An array of keys.
ubyte[] _aaKeys(ref AssocArray aa, size_t keysize) {
	// Sweep through every bucket, appending each key
	ubyte[] ret;
	foreach(bucket; aa.buckets) {
		foreach(entry; bucket.entries) {
			if (entry.key.ptr !is null) {
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
	ubyte[] ret;
	foreach(bucket; aa.buckets) {
		foreach(entry; bucket.entries) {
			if (entry.key.ptr !is null) {
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
		if (element.key.ptr !is null) {
			// Rehash
			size_t newBucketIndex;

			newBucketIndex = element.hash % (2 * aa.range);
			if (newBucketIndex != rehashBucketIndex) {

				// Move (TODO: lockfree atomic exchange?)
				foreach(ref newElement; aa.buckets[newBucketIndex].entries) {
					if (newElement.key.ptr is null) {
						newElement = element;
					}
				}

				// Remove old references
				element.key = null;
				element.value = null;
				aa.buckets[rehashBucketIndex].usedCount--;
				aa.buckets[newBucketIndex].usedCount++;
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

