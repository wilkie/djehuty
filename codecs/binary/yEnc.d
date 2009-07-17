/*
 * yEnc.d
 *
 * This file implements the yEnc algorithm.
 *
 * Author: Dave Wilkinson
 *
 */

module codecs.binary.yEnc;

import core.endian;
import core.literals;
import core.stream;

import codecs.binary.codec;

private {

	const auto YENC_STATE_INIT 				= 0;

	const auto YENC_STATE_READHEADER 		= 1;
	const auto YENC_STATE_READHEADERVALUE 	= 2;
	const auto YENC_STATE_READHEADERNAME 	= 3;

	const auto YENC_STATE_READLINE_START 	= 4;
	const auto YENC_STATE_READLINE 			= 5;

	const auto YENC_STATE_READ_ESCAPE 		= 6;

	const auto YENC_STATE_READFOOTER 		= 7;

}

// Section: Codecs/Binary

// Description: This represents the yEnc Codec.
class yEncCodec : BinaryCodec {

	StreamData decode(Stream stream, Stream toStream) {
		ushort chunk;
		char linestr[257];
		uint line;
		uint size;

		ubyte chr;
		ubyte linepos = 0;

		ubyte headeroption = 0;


		for (;;) {

			switch (decoderState) {

				case YENC_STATE_INIT:

					decoderState = YENC_STATE_READHEADER;

					if(!stream.read(chunk)) {
						return StreamData.Required;
					}

					if (chunk == ('=' | ('y'<<8))) {
						//escape sequence (valid header)

						linepos = 0;
						decoderState = YENC_STATE_READHEADER;
					}
					else {
						return StreamData.Invalid;
					}

					continue;




				case YENC_STATE_READHEADER:

					// read the rest of the line
					if(!stream.read(chr)) {
						return StreamData.Required;
					}

					if ((chr == ' ') || (chr == '=')) {
						// delimiter
						linestr[linepos] = 0;
						linepos = 0;

						// get the token
						if (!(linestr == "line")) {
							decoderState = YENC_STATE_READHEADERVALUE;
							headeroption = 0;
							continue;
						}
						else if (!(linestr == "size")) {
							decoderState = YENC_STATE_READHEADERVALUE;
							headeroption = 1;
							continue;
						}
						else if (!(linestr == "name")) {
							decoderState = YENC_STATE_READHEADERNAME;
							headeroption = 2;
							continue;
						}
					}
					else if (chr == '\r') {
						continue;
					}
					else if (chr == '\n') {
						decoderState = YENC_STATE_READLINE_START;
						continue;
					}
					else {
						linestr[linepos] = chr;
						linepos++;
					}

					continue;

				case YENC_STATE_READHEADERVALUE:

					// ignore whitespace, =, etc until a value is read


					// read the rest of the line
					if(!stream.read(chr)) {
						return StreamData.Required;
					}


					if ((chr == ' ') || (chr == '=') || (chr == '\n') || (chr == '\r')) {
						if (linepos == 0) {
							// ignore this
							continue;
						}

						// delimiter
						linestr[linepos] = 0;

						// get the token
						if (headeroption == 0) {
							// TODO: Int to String Functions
							//line = cast(uint)atoi(cast(StringLiteral8)linestr);
						} else {
							// TODO: Int to String Functions
							//size = cast(uint)atoi(cast(StringLiteral8)linestr);
						}

						if (chr == '\r') {
							continue;
						}
						else if (chr == '\n') {
							decoderState = YENC_STATE_READLINE_START;
							continue;
						}
						else {
							linepos = 0;
							decoderState = YENC_STATE_READHEADER;
						}

						continue;

					}

					linestr[linepos] = chr;
					linepos++;

					continue;

				case YENC_STATE_READHEADERNAME:

					// ignore whitespace, =, etc until a value is read


					// read the rest of the line
					if(!stream.read(chr)) {
						return StreamData.Required;
					}


					if ((chr == ' ') || (chr == '=') || (chr == '\n') || (chr == '\r')) {
						if (linepos == 0) {
							// ignore this
							continue;
						}

						// delimiter
						linestr[linepos] = 0;

						// get the token
						//if (headeroption == 0)
						//{
						//	line = atoi(linestr);
						//} else {
						//	size = atoi(linestr);
						//}

						if (chr == '\r') {
							continue;
						}
						else if (chr == '\n') {
							decoderState = YENC_STATE_READLINE_START;
							continue;
						}
						else {
							linepos = 0;
							decoderState = YENC_STATE_READHEADER;
						}

						continue;

					}

					linestr[linepos] = chr;
					linepos++;

					continue;


				case YENC_STATE_READLINE_START:

					if(!stream.read(chunk)) {
						return StreamData.Required;
					}

					if (chunk == ('=' | ('y'<<8))) {
						//escape sequence (valid footer)

						linepos = 0;
						decoderState = YENC_STATE_READFOOTER;
						continue;
					}
					else {
						// decode these two bytes

						// DECODE!
						chr = cast(ubyte)(chunk & 0xFF);
						if (chr == '=') {
							chr = cast(ubyte)(chunk >> 8);
							chr -= 64;

							toStream.write(&chr, 1);
						}
						else {
							chr -= 42;
							toStream.write(&chr, 1);
							chr = cast(ubyte)(chunk >> 8);

							if (chr == '=')
							{
								decoderState = YENC_STATE_READ_ESCAPE;
								continue;
							}
							else
							{
								chr -= 42;
								toStream.write(&chr, 1);
							}
						}

						decoderState = YENC_STATE_READLINE;
					}

					continue;


				case YENC_STATE_READLINE:

					// pull a byte, decode it!

					if(!stream.read(chr)) {
						return StreamData.Required;
					}

					if (chr == '\r') {
						// ignore carriage returns
						continue;
					}

					if (chr == '\n') {
						// line feeds... goto next line!
						// check for accuracy?

						decoderState = YENC_STATE_READLINE_START;
						continue;
					}

					if (chr == '=') {
						decoderState = YENC_STATE_READ_ESCAPE;
						continue;
					}

					// decode character

					chr -= 42;
					toStream.write(&chr, 1);

					continue;

				case YENC_STATE_READ_ESCAPE:

					if(!stream.read(chr)) {
						return StreamData.Required;
					}

					// decode character

					chr -= 106;
					toStream.write(&chr, 1);

					decoderState = YENC_STATE_READLINE;
					continue;

				case YENC_STATE_READFOOTER:

					return StreamData.Complete;

				default: return StreamData.Invalid;
			}
		}
	}
}