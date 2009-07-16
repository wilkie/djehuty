/*
 * zlib.d
 *
 * This file implements the ZLIB standard. ZLIB is basically a wrapper around
 * the DEFLATE algorithm.
 *
 * Author: Dave Wilkinson
 *
 */

module codecs.binary.zlib;

import codecs.binary.codec;
import codecs.binary.deflate;

import core.stream;

private
{
	const auto ZLIB_STATE_INIT						= 0;

	const auto ZLIB_STATE_READ_HEADER				= 1;
	const auto ZLIB_STATE_STREAM_DEFLATE			= 2;
	const auto ZLIB_STATE_READ_ADLER32				= 3;

	align(1) struct _zlib_cmf_flg_header
	{
		ubyte zlibCMF;
		ubyte zlibFLG;
	};
}

// Section: Codecs/Binary

// Description: This represents the ZLIB Codec.
class ZLIBCodec : BinaryCodec
{
	StreamData decode(Stream stream, Stream toStream)
	{
	//	writeln("zlib start");

		for (;;)
		{
			switch (decoderState)
			{

				// INIT DECODER //
			case ZLIB_STATE_INIT:
	//	writeln("zlib init");


				// SET VARIABLES WITHIN IDP

				// GOTO NEXT STEP

				decoderState = ZLIB_STATE_READ_HEADER;





				// READ STREAM HEADER //
			case ZLIB_STATE_READ_HEADER:

				//OutputDebugStringA("zlib - attempting to read in headers\n");
	//	writeln("zlib read header");

				if (!(stream.read(&zlibStreamHeader,2)))
				{
					return StreamData.Required;
				}
	//	writeln("zlib header read");

				////OutputDebugString(String(zlibStreamHeader.zlibCMF) + S("\n"));
				////OutputDebugString(String(zlibStreamHeader.zlibFLG) + S("\n"));

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

				if (zlibCompressionMethod == 8)
				{
					///write("zlib - using DEFLATE\n");

					if (zlibCompressionInfo > 7)
					{
						//write("zlib - window size is invalid\n");

						return StreamData.Invalid;
					}
					else if (zlibCompressionInfo == 7)
					{
	//					write("zlib - window size of 32K\n");
					}

				}
				else
				{
					//ite("zlib - unsupported compression method\n");
					return StreamData.Invalid;
				}

				if (zlibIsDictionary)
				{
					//write("zlib - has preset dictionary\n");
				}

				switch (zlibCompressionLevel)
				{
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

				if (deflateDecompressor is null)
				{
					deflateDecompressor = new DEFLATECodec();
				}

				if ((ret = deflateDecompressor.decode(stream, toStream)) != StreamData.Required)
				{
					decoderState = ZLIB_STATE_READ_ADLER32;
				}
				else
				{
					////OutputDebugStringA("zlib - returning early\n");
					return ret;
				}

			case ZLIB_STATE_READ_ADLER32:
	//	writeln("zlib read adler32");

				//OutputDebugStringA("zlib - decompression done, reading ALDER32\n");

				if (!(stream.skip(4)))
				{
					//return StreamData.Required;
				}
				//OutputDebugStringA("zlib - returning\n");

				return StreamData.Complete;


			default:
				return StreamData.Invalid;
			}
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
	DEFLATECodec deflateDecompressor;
}
