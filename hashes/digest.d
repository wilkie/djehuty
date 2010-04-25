/*
 * digest.d
 *
 * This module houses the Digest class used as a return value for all
 * hashing algorithms.
 *
 * Author: Dave Wilkinson
 *
 */

module hashes.digest;

import djehuty;

// Description: This class holds the computed digest from a hashing algorithm.
class Digest {
	this (uint[] newData...) {
		data = newData.dup;
	}

	uint[] data;

	override string toString() {
		string ret = "";
		for(int i=0; i<data.length; i++) {
			ret ~= "{x8}".format(data[i]);
		}
		return ret;
	}

	// operator overloads

	bool equals(Digest compareTo) {
		if (data == compareTo.data) {
			return true;
		}

		return false;
	}

	// mathematical operator overloads
	override int opEquals(Object o) {
		if (cast(Digest)o !is null) {
			return equals(cast(Digest)o);
		}
		return 0;
	}
}
