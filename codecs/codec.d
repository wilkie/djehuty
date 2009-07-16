/*
 * codec.d
 *
 * This file implements the base class for all codecs.
 *
 * Author: Dave Wilkinson
 *
 */

module codecs.codec;

import core.time;
import core.string;

// Description: Base class for all codecs
class Codec
{
public:

	String name()
	{
		return new String("Unknown Codec");
	}

protected:

	int decoderState = 0;
	int decoderNextState = 0;

	int decoderSubState = 0;
	int decoderNextSubState = 0;

	int decoderFrameState = 0;
}
