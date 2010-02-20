/*
 * decoder.d
 *
 * This file implements the base class for all decoders.
 *
 * Author: Dave Wilkinson
 *
 */

module decoders.decoder;

import core.time;
import core.string;
import core.definitions;

// Description: Base class for all codecs
class Decoder {
	string name() {
		return "Unknown Codec";
	}

protected:

	int decoderState = 0;
	int decoderNextState = 0;

	int decoderSubState = 0;
	int decoderNextSubState = 0;

	int decoderFrameState = 0;
}
