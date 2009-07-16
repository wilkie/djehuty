/*
 * codec.d
 *
 * This file implements the abstraction for an binary codec.
 *
 * Author: Dave Wilkinson
 *
 */

module codecs.binary.codec;

import codecs.codec;

import core.string;
import core.stream;

// Section: Interfaces

// Description: The interface to a binary codec.
class BinaryCodec : Codec {
public:

	StreamData decode(Stream stream, Stream toStream) {
		return StreamData.Invalid;
	}

	override String name() {
		return new String("Unknown Binary Codec");
	}
}
