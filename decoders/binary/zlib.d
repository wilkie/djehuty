/*
 * zlib.d
 *
 * This file implements the ZLIB standard. ZLIB is basically a wrapper around
 * the DEFLATE algorithm.
 *
 * Author: Dave Wilkinson
 *
 */

module decoders.binary.zlib;

import decoders.binary.decoder;
import decoders.binary.deflate;

import core.stream;
import core.definitions;

// Section: Codecs/Binary
private {
	align(1) struct _zlib_cmf_flg_header {
		ubyte zlibCMF;
		ubyte zlibFLG;
	}
}

// Description: This represents the ZLIB Codec.
class ZLIBDecoder : BinaryDecoder {
	StreamData decode(Stream stream, Stream toStream) {
		for (;;) {
			switch (decoderState) {
				// INIT DECODER //
			case ZLIB_STATE_INIT:
				// SET VARIABLES WITHIN IDP

				// GOTO NEXT STEP

				decoderState = ZLIB_STATE_READ_HEADER;

				// READ STREAM HEADER //
			case ZLIB_STATE_READ_HEADER:

				if (!(stream.read(&zlibStreamHeader,2))) {
					return StreamData.Required;
				}

				// GET COMPRESSION METHOD, INFO

				// CM:
				zlibCompressionMethod = cast(ubyte)(zlibStreamHeader.zlibCMF & 0xF);

				// CINFO:
				zlibCompressionInfo = cast(ubyte)(zlibStreamHeader.zlibCMF >> 4);

				// GET FLAGS

				// FDICT
				zlibIsDictionary = cast(ubyte)(zlibStreamHeader.zlibFLG & 32);

				// FCHECK
				zlibFCHECK = cast(ubyte)(zlibStreamHeader.zlibFLG & 0xF);

				// FLEVEL
				zlibCompressionLevel = cast(ubyte)(zlibStreamHeader.zlibFLG >> 6);

				if (zlibCompressionMethod == 8) {
					///write("zlib - using DEFLATE\n");

					if (zlibCompressionInfo > 7) {
						//write("zlib - window size is invalid\n");

						return StreamData.Invalid;
					}
					else if (zlibCompressionInfo == 7) {
	//					write("zlib - window size of 32K\n");
					}

				}
				else {
					//ite("zlib - unsupported compression method\n");
					return StreamData.Invalid;
				}

				if (zlibIsDictionary) {
					//write("zlib - has preset dictionary\n");
				}

				switch (zlibCompressionLevel) {
				case 0:
					//write("zlib - compression level: fastest\n");
					break;
				case 1:
					//write("zlib - compression level: fast\n");
					break;
				case 2:
					//write("zlib - compression level: default\n");
					break;
				case 3:
					//write("zlib - compression level: maximum\n");
					break;

				default:
					//write("zlib - compression level odd, continuing anyway\n");
					break;
				}

				decoderState = ZLIB_STATE_STREAM_DEFLATE;

			case ZLIB_STATE_STREAM_DEFLATE:

				StreamData ret;

				//stream.read(decoding, stream.getRemaining() - 4);

				//decoding.rewind();
	//	writeln("zlib deflate");

				if (deflateDecompressor is null) {
					deflateDecompressor = new DEFLATEDecoder();
				}

				if ((ret = deflateDecompressor.decode(stream, toStream)) != StreamData.Required) {
					decoderState = ZLIB_STATE_READ_ADLER32;
				}
				else {
					////OutputDebugStringA("zlib - returning early\n");
					return ret;
				}

			case ZLIB_STATE_READ_ADLER32:
	//	writeln("zlib read adler32");

				//OutputDebugStringA("zlib - decompression done, reading ALDER32\n");

				if (!(stream.skip(4))) {
					//return StreamData.Required;
				}
				//OutputDebugStringA("zlib - returning\n");

				return StreamData.Complete;


			default:
				break;
			}

			break;
		}
		
		return StreamData.Invalid;
	}

protected:

	// CMF, FLG
	_zlib_cmf_flg_header zlibStreamHeader;

	// CM
	ubyte zlibCompressionMethod;

	// CINFO
	ubyte zlibCompressionInfo;

	// FDICT
	ubyte zlibIsDictionary;

	//FLEVEL
	ubyte zlibCompressionLevel;

	//FCHECK
	ubyte zlibFCHECK;


	// USED WHEN STREAMING THE DECODER
	DEFLATEDecoder deflateDecompressor;

private:

	const auto ZLIB_STATE_INIT						= 0;

	const auto ZLIB_STATE_READ_HEADER				= 1;
	const auto ZLIB_STATE_STREAM_DEFLATE			= 2;
	const auto ZLIB_STATE_READ_ADLER32				= 3;

}
