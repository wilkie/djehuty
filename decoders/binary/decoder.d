/*
 * decoder.d
 *
 * This file implements the abstraction for an binary decoder.
 *
 * Author: Dave Wilkinson
 *
 */

module decoders.binary.decoder;

import decoders.decoder;

import core.string;
import core.stream;
import core.definitions;

// Section: Interfaces

// Description: The interface to a binary codec.
class BinaryDecoder : Decoder {
	StreamData decode(Stream stream, Stream toStream) {
		return StreamData.Invalid;
	}

	override string name() {
		return "Unknown Binary Decoder";
	}
}
