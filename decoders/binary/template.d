/*
 * template.d
 *
 * Author:
 * Originated:
 * References: 
 *
 */

module decoders.binary.foo;

import core.stream;

import decoders.binary.codec;

private {

	// States
	enum {
		FOO_STATE_INIT,
	}
}

// Section: Codecs/Binary

// Description: This represents the Par2 Codec.
class FooDecoder : BinaryDecoder {

	StreamData decode(Stream stream, Stream toStream) {

		for (;;) {
			switch (decoderState) {
				default: return StreamData.Invalid;
			}
		}

		return StreamData.Invalid;
	}
}
