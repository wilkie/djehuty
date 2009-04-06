module codecs.binary.base64;

import core.endian;
import interfaces.stream;

import codecs.binary.codec;
import codecs.codec;


static const ubyte _base64_encoding_table[] = [
	'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L',
	'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X',
	'Y', 'Z', 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j',
	'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v',
	'w', 'x', 'y', 'z', '0', '1', '2', '3', '4', '5', '6', '7',
	'8', '9', '+', '/', '='
];

static const ubyte _base64_decoding_table[] = [
	255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 254, 255, 255, 254, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255,
	255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255,  62, 255, 255, 255,  63,  52,  53,
	54,  55,  56,  57,  58,  59,  60,  61, 255, 255, 255,  255, 255, 255, 255,  0,  1,  2,  3,  4,  5,  6,  7,  8,  9,
	10,  11,  12,  13,  14,  15,  16,  17,  18,  19,  20,  21,  22,  23,  24,  25, 255, 255, 255, 255, 255, 255,  26,  27,  28,
	29,  30,  31,  32,  33,  34,  35,  36,  37,  38,  39,  40,  41,  42,  43,  44,  45,  46,  47,  48,  49,  50,  51, 255, 255,
	255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255,
	255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255,
	255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255,
	255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255,
	255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255,
	255, 255, 255, 255, 255, 0
];

// Section: Codecs/Binary

// Description: This represents the Base64 Codec.
class Base64Codec : BinaryCodec
{

	StreamData decode(AbstractStream stream, AbstractStream toStream)
	{
		ubyte chunk;

		for (;;)
		{
			if (!stream.read(chunk))
			{
				return StreamData.Required;
			}

			// decode character
			// add to stream, where last character left off

			chunk = _base64_decoding_table[chunk];

			// should we quit or ignore?
			if (chunk == 255) {
				return StreamData.Complete;
			}
			else if (chunk == 254) {
				continue;
			}

			if (decoderFrameState == 0)
			{
				// just set the byte, do not increment

				chunk <<= 2;

				decoderSubState = chunk;

				decoderFrameState = 6;
			}
			else if (decoderFrameState == 2)
			{
				// just finish the current byte of out stream

				// just append it out

				chunk |= decoderSubState;

				toStream.write(&chunk, 1);

				decoderFrameState = 0;
			}
			else if (decoderFrameState == 4)
			{
				// spans two bytes

				decoderNextState = chunk;
				chunk >>= 2;
				chunk |= decoderSubState;
				toStream.write(&chunk, 1);

				decoderSubState = (decoderNextState & 0x3) << 6;



				decoderFrameState = 2;
			}
			else if (decoderFrameState == 6)
			{
				// needs to span two bytes in out stream

				// finish current byte

				decoderNextState = chunk;
				chunk >>= 4;
				chunk |= decoderSubState;
				toStream.write(&chunk, 1);

				// go to next byte, just set


				decoderSubState = (decoderNextState & 0xF) << 4;

				decoderFrameState = 4;
			}

			decoderFrameState = decoderFrameState;
		}

		return StreamData.Invalid;
	}
}

//documentation interests

//DJEHUTYDOC

//CODEC:Base64
//DESC:This codec will decode and encode using the base64 algorithm.

//METHODS

//NAME:decode(Stream stream, Stream toStream, CodecState decoder)
//DESC:Decodes the stream given by 'stream' and writes it to the stream given by 'toStream'.  A CodecState is given to store information in case of partial decoding.  As such, use this function to decode from a partial stream.
//RETURNS:StreamData
//DESC:Will return the state of the stream and whether it is accepted successfully.

//NAME:decode(Stream stream, Stream toStream)
//DESC:Decodes the stream given by 'stream' and writes it to the stream given by 'toStream'.  Use this function to decode from what you expect to be a complete stream.
//RETURNS:StreamData
//DESC:Will return the state of the stream and whether it is accepted successfully.



//DJEHUTYDOCEND
