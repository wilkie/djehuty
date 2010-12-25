module decoders.image.png;

import graphics.bitmap;

import core.stream;
import core.string;
import core.endian;
import core.definitions;

import decoders.image.decoder;
import decoders.decoder;
import decoders.binary.zlib;

import io.console;

// Section: Codecs/Image

// Description: The PNG Codec
class PNGDecoder : ImageDecoder {
private:

	align (1) struct _djehuty_image_png_chunk_header {
		uint pngChunkLength;
		uint pngChunkType;
	}

	align (1) struct _djehuty_image_png_ihdr {
		uint pngWidth;
		uint pngHeight;
		ubyte pngBitDepth;
		ubyte pngColorType;
		ubyte pngCompressionMethod;
		ubyte pngFilterMethod;
		ubyte pngInterlaceMethod;
	}

	align (1) struct _djehuty_image_png_color {
		ubyte red;
		ubyte green;
		ubyte blue;
	}

	ubyte[8] pngHeader;

	_djehuty_image_png_chunk_header pngChunkHeader;
	uint pngChunkCRC;
	ubyte* pngChunkData;

	uint pngRunningCRC;

	int pngCounter;

	//palette (PLTE)
	uint pngPaletteCount;
	_djehuty_image_png_color[256] pngPalette;
	uint[256] pngPaletteRealized;	// palette with system calculated colors

	//chunks
	_djehuty_image_png_ihdr pngIHDR; //IHDR

	//IDAT
	//ZLIB, et al
	Stream pngUncompressedData = null;
	ZLIBDecoder zlibDecompressor = null;

	// FOR UNFILTERING
	ubyte pngFilterType;
	uint pngImageType;
	ubyte pngNumSamples;		//samples per pixel ( at least one byte ) (maximum = 8)
	uint pngCurSample;			//current sample we are filtering

	int pngExpectedBytes;

	// arrays for such things
	ubyte[][8] pngBytes = [null, null, null, null, null, null, null, null];		// array for holding the prior scanline's decoded bytes
	ubyte[8] pngPriorScannedByte;
	ubyte[8] pngPriorPixel;
	uint[8] pngCurComponent;

	ubyte pngPriorScannedComp;

	// Paeth Filtering
	ubyte pngPaethPredictor;

	// image position
	uint ptrLine;
	uint ptrPos;

	// for interlacing
	uint[7] pngInterlaceWidths;		//width of subimage
	uint[7] pngInterlaceHeights;		//height of subimage
	uint pngInterlacePass;			//the current interlace pass
	uint pngInterlaceCurLine;			//the current scanline of the current pass

	// for the decoder state
	uint pngFilterState;				//the filter state
	uint pngRenderState;				//the render state per image type

	// States

	const auto PNG_STATE_INIT_PROGRESS				= 0;
	const auto PNG_STATE_INIT						= 1;
	const auto PNG_STATE_READ_CHUNK_HEADER			= 2;
	const auto PNG_STATE_READ_CHUNK_CRC				= 3;
	const auto PNG_STATE_SKIP_CHUNK					= 4;

	const auto PNG_STATE_READ_IHDR					= 5;
	const auto PNG_STATE_READ_PLTE					= 6;
	const auto PNG_STATE_READ_IDAT					= 7;
	const auto PNG_STATE_READ_IEND					= 8;

	const auto PNG_STATE_READ_PLTE_ENTRIES			= 9;

	const auto PNG_STATE_INTERPRET_IDAT				= 10;
	const auto PNG_STATE_FILL_IDAT					= 11;
	const auto PNG_STATE_DONE_IDAT					= 12;

	const auto PNG_STATE_DECODE_READ_FILTER_TYPE	= 13;

		// FILTER STATES //

	const auto PNG_STATE_UNFILTER_NONE				= 14;
	const auto PNG_STATE_UNFILTER_SUB				= 15;
	const auto PNG_STATE_UNFILTER_UP				= 16;
	const auto PNG_STATE_UNFILTER_AVERAGE			= 17;
	const auto PNG_STATE_UNFILTER_PAETH				= 18;

		// RENDER STATES //

	const auto PNG_STATE_RENDER_STATE_BASE			= 32; // defines 32...32 + PNG_TRUECOLOUR_ALPHA_16BPP for the byte renderers

	// Chunk Type Definitions //

	const auto PNG_CHUNK_IHDR						= 0x52444849;
	const auto PNG_CHUNK_PLTE						= 0x45544C50;
	const auto PNG_CHUNK_IDAT						= 0x54414449;
	const auto PNG_CHUNK_IEND						= 0x444E4549;

	// Image Types //

	const auto PNG_GREYSCALE_1BPP					= ((1 << 16) + 1);
	const auto PNG_GREYSCALE_2BPP					= ((1 << 16) + 2);
	const auto PNG_GREYSCALE_4BPP					= ((1 << 16) + 4);
	const auto PNG_GREYSCALE_8BPP					= ((1 << 16) + 8);
	const auto PNG_GREYSCALE_16BPP					= ((1 << 16) + 16);

	const auto PNG_TRUECOLOUR_8BPP					= ((3 << 16) + 8);
	const auto PNG_TRUECOLOUR_16BPP					= ((3 << 16) + 16);

	const auto PNG_INDEXED_COLOUR_1BPP				= ((4 << 16) + 1);
	const auto PNG_INDEXED_COLOUR_2BPP				= ((4 << 16) + 2);
	const auto PNG_INDEXED_COLOUR_4BPP				= ((4 << 16) + 4);
	const auto PNG_INDEXED_COLOUR_8BPP				= ((4 << 16) + 8);

	const auto PNG_GREYSCALE_ALPHA_8BPP				= ((5 << 16) + 8);
	const auto PNG_GREYSCALE_ALPHA_16BPP			= ((5 << 16) + 16);

	const auto PNG_TRUECOLOUR_ALPHA_8BPP			= ((7 << 16) + 8);
	const auto PNG_TRUECOLOUR_ALPHA_16BPP			= ((7 << 16) + 16);

			// defines the rest of the states for interlaced rendering
	const auto PNG_STATE_RENDER_INTERLACED_STATE_BASE = (PNG_STATE_RENDER_STATE_BASE + PNG_TRUECOLOUR_ALPHA_16BPP);

	//GLOBAL STATIC CONSTANTS
	//------------------------

	static const uint pngInterlaceIncrementsX[7] = (8, 8, 4, 4, 2, 2, 1);
	static const uint pngInterlaceIncrementsY[7] = (8, 8, 8, 4, 4, 2, 2);
	static const uint pngInterlaceStartsX[7] = (0, 4, 0, 2, 0, 1, 0);
	static const uint pngInterlaceStartsY[7] = (0, 0, 4, 0, 2, 0, 1);

	// for low bpp color conversion
	static const ubyte	png1BPP[2] = (0, 255);
	static const ubyte	png2BPP[4] = (0, 85, 170, 255);
	static const ubyte	png4BPP[16] = (0, 17, 34, 51, 68, 85, 102, 119, 136, 153, 170, 187, 204, 221, 238, 255);

public:
	override string name() {
		return "Portable Network Graphics";
	}

	StreamData decode(Stream stream, ref Bitmap view) {
		ImageFrameDescription imageDesc;
		bool hasMultipleFrames;

		Stream streamToDecode;

		streamToDecode = new Stream();

		uint* ptr_start;		//ptr of the first pixel

		uint* ptr;			//current ptr in image data
		uint* ptr_max_line;	//ptr of the next line
		uint* ptr_max_page;	//ptr outside of image bounds

		ulong ptr_len;

		uint psamp;
		uint nsamp;

		ubyte curByte, recon;

		uint palIndex;

		int p;
		int pa;
		int pb;
		int pc;

		float a;

		for (;;) {
			switch(decoderState) {
			case PNG_STATE_INIT_PROGRESS:
				ptrPos = 0;
				ptrLine = 0;

				pngUncompressedData = new Stream();

				decoderNextState = PNG_STATE_DECODE_READ_FILTER_TYPE;

				// READ HEADERS //
			case PNG_STATE_INIT:

				if(!(stream.read(&pngHeader, 8))) {
					return StreamData.Required;
				}

				// DETERMINE VALIDITY OF FILE //

				if (!(pngHeader[0] == 0x89 &&
					pngHeader[1] == 0x50 &&
					pngHeader[2] == 0x4E &&
					pngHeader[3] == 0x47 &&
					pngHeader[4] == 0x0D &&
					pngHeader[5] == 0x0A &&
					pngHeader[6] == 0x1A &&
					pngHeader[7] == 0x0a)) {
					//Header is corrupt
	//				Console.putln("header corrupt");
	//				Console.putln("png - header corrupt\n");
					return StreamData.Invalid;
				}

				pngPaletteCount = 0;

				decoderState = PNG_STATE_READ_CHUNK_HEADER;






				// READ CHUNK HEADER //

			case PNG_STATE_READ_CHUNK_HEADER:

				//Console.putln("png - reading chunk\n");

				if(!(stream.read(&pngChunkHeader, _djehuty_image_png_chunk_header.sizeof))) {
					return StreamData.Required;
				}

				fromBigEndian(pngChunkHeader.pngChunkLength);
	//			Console.putln(toString(pngChunkHeader.pngChunkLength) ~ "\n");

				switch(pngChunkHeader.pngChunkType) {
				case PNG_CHUNK_IHDR:

					//////////Console.putln("png - IHDR\n");

					decoderState = PNG_STATE_READ_IHDR;
					continue;

				case PNG_CHUNK_PLTE:

					//////////Console.putln("png - PLTE\n");

					decoderState = PNG_STATE_READ_PLTE;
					continue;

				case PNG_CHUNK_IDAT:

					//Console.putln("png - IDAT\n");

					decoderState = PNG_STATE_READ_IDAT;
					continue;

				case PNG_CHUNK_IEND:
					//Console.putln("png - IEND\n");
	//			Console.putln("IEND"); //, streamToDecode);

					streamToDecode.rewind();
				//Console.putln("rewound");

					if (zlibDecompressor is null) {
						zlibDecompressor = new ZLIBDecoder();
					}

					if (zlibDecompressor.decode(streamToDecode, pngUncompressedData) == StreamData.Complete) {
						//Console.putln("zlib");

						//while (pngUncompressedData.getRemaining())
						//{
						//	pngUncompressedData.Readubyte(curByte);
							////////////Console.putln((":") + toString(curByte) + ("\n"));
						//}

						//pngUncompressedData.rewind();

						view.lockBuffer(cast(void**)&ptr_start, ptr_len);

						ptr = ptr_start;

						ptr += (pngIHDR.pngWidth * ptrLine);
						ptr_max_line = ptr + pngIHDR.pngWidth;

						ptr_max_page = ptr_start + (ptr_len / 4);

						ptr += ptrPos;

						//Console.putln("png - reading filter type!!!\n");

						decoderState = PNG_STATE_DECODE_READ_FILTER_TYPE;

					}
					else {
						//Console.putln("zlib");

						return StreamData.Complete;

					}

					continue;

				default:

	//				Console.putln("png - unknown chunk\n");
					decoderState = PNG_STATE_SKIP_CHUNK;
				}

				continue;

				// SKIPS CHUNK AND CRC INFO
			case PNG_STATE_SKIP_CHUNK:

				//////////Console.putln(("png - skipping chunk of length: ") + toString(pngChunkHeader.pngChunkLength) + ("\n"));

				if(!(stream.skip(pngChunkHeader.pngChunkLength + 4))) {
					return StreamData.Required;
				}

				decoderState = PNG_STATE_READ_CHUNK_HEADER;

				continue;

			case PNG_STATE_READ_CHUNK_CRC:

				//////////Console.putln("png - checking CRC\n");

				if(!(stream.read(&pngChunkCRC, 4))) {
					return StreamData.Required;
				}

				// CHECK CRC

				// READ ANOTHER CHUNK
				decoderState = PNG_STATE_READ_CHUNK_HEADER;
				continue;

			case PNG_STATE_READ_IHDR:
				if(!(stream.read(&pngIHDR, _djehuty_image_png_ihdr.sizeof))) {
					return StreamData.Required;
				}

				fromBigEndian(pngIHDR.pngWidth);
				fromBigEndian(pngIHDR.pngHeight);

				pngPaletteCount = 0;

				// determine whether png is valid by this header

				switch(pngIHDR.pngColorType) {
					//Greyscale
				case 0:
					switch (pngIHDR.pngBitDepth) {
					case 1:
					case 2:
					case 4:
					case 8:
					case 16:
	//					Console.putln(("png - greyscale - ") ~ toString(pngIHDR.pngBitDepth) ~ (" bpp\n"));
						break;

					default:
	//					Console.putln("png - invalid color, bit depth combination\n");
						break;
					}
					break;

					//Truecolour
				case 2:
					switch (pngIHDR.pngBitDepth)
					{
					case 8:
					case 16:
	//					Console.putln(("png - truecolour - ") ~ toString(pngIHDR.pngBitDepth) ~ (" bpp\n"));
						break;

					default:
	//					Console.putln("png - invalid color, bit depth combination\n");
						break;
					}
					break;

					//Indexed-colour
				case 3:
					switch (pngIHDR.pngBitDepth) {
					case 1:
					case 2:
					case 4:
					case 8:
	//					Console.putln(("png - Indexed-colour - ") ~ toString(pngIHDR.pngBitDepth) ~ (" bpp\n"));
						break;

					default:
	//					Console.putln("png - invalid color, bit depth combination\n");
						break;
					}
					break;

					//Greyscale with alpha
				case 4:
					switch (pngIHDR.pngBitDepth) {
					case 8:
					case 16:
	//					Console.putln(("png - greyscale with alpha - ") ~ toString(pngIHDR.pngBitDepth) ~ (" bpp\n"));
						break;

					default:
	//					Console.putln("png - invalid color, bit depth combination\n");
						break;
					}
					break;

					//Truecolour with alpha
				case 6:
					switch (pngIHDR.pngBitDepth) {
					case 8:
					case 16:
	//					Console.putln(("png - truecolour with alpha - ") ~ toString(pngIHDR.pngBitDepth) ~ (" bpp\n"));
						break;

					default:
	//					Console.putln("png - invalid color, bit depth combination\n");
						break;
					}
					break;

				default:
	//				Console.putln("png - invalid color type\n");
					return StreamData.Invalid;

				}

				if (pngIHDR.pngFilterMethod != 0) {
					//////Console.putln("png - unsupported filter method\n");
					return StreamData.Invalid;
				}

				if (pngIHDR.pngCompressionMethod != 0) {
					//////Console.putln("png - unsupported compression method\n");
					return StreamData.Invalid;
				}

				if (pngIHDR.pngInterlaceMethod) {
					////Console.putln("png - Adam7 interlacing\n");

					// SET UP INTERLACE PASS DIMENSIONS

					// THAT IS, HOW MUCH DATA WILL BE IN EACH PASS, HOW MUCH
					// WILL BE IN EACH SCANLINE FOR EACH PASS

					pngInterlacePass = 0;
					pngInterlaceCurLine = 0;

					// EQUATION FOR INTERLACE WIDTH: (width, height refer to dimensions of final image)

					// 1st pass: ceiling(width / 8)
					// 2nd pass: ceiling((width - 4) / 8)
					// 3rd pass: ceiling(width / 4)
					// 4th pass: ceiling((width - 2) / 4)
					// 5th pass: ceiling(width / 2)
					// 6th pass: ceiling((width - 1) / 2)
					// 7th pass: width

					// EQUATION FOR INTERLACE HEIGHT:

					// 1st, 2nd pass: ceiling(height / 8)
					// 3rd pass: ceiling((height - 4) / 8)
					// 4th pass: ceiling(height / 4)
					// 5th pass: ceiling((height - 2) / 4)
					// 6th pass: ceiling(height / 2)
					// 7th pass: ceiling((height - 1) / 2)

					pngInterlaceWidths[0] = cast(uint)(cast(float)pngIHDR.pngWidth / 8);
					if (pngIHDR.pngWidth % 8) {
						pngInterlaceWidths[0]++;
					}

					if (pngIHDR.pngWidth <= 4) {
						pngInterlaceWidths[1] = 0;
					}
					else {
						pngInterlaceWidths[1] = cast(uint)((cast(float)pngIHDR.pngWidth - 4) / 8);
						if ((pngIHDR.pngWidth - 4) % 8) {
							pngInterlaceWidths[1]++;
						}
					}

					pngInterlaceWidths[2] = cast(uint)(cast(float)pngIHDR.pngWidth / 4);
					if (pngIHDR.pngWidth % 4) {
						pngInterlaceWidths[2]++;
					}

					if (pngIHDR.pngWidth <= 2) {
						pngInterlaceWidths[3] = 0;
					}
					else {
						pngInterlaceWidths[3] = cast(uint)((cast(float)pngIHDR.pngWidth - 2) / 4);
						if ((pngIHDR.pngWidth - 2) % 4) {
							pngInterlaceWidths[3]++;
						}
					}

					pngInterlaceWidths[4] = cast(uint)(cast(float)pngIHDR.pngWidth / 2);
					if (pngIHDR.pngWidth % 2) {
						pngInterlaceWidths[4]++;
					}

					if (pngIHDR.pngWidth <= 1) {
						pngInterlaceWidths[5] = 0;
					}
					else {
						pngInterlaceWidths[5] = cast(uint)((cast(float)pngIHDR.pngWidth - 1) / 2);
						if ((pngIHDR.pngWidth - 1) % 2) {
							pngInterlaceWidths[5]++;
						}
					}

					pngInterlaceWidths[6] = pngIHDR.pngWidth;

					pngInterlaceHeights[0] = cast(uint)(cast(float)pngIHDR.pngHeight / 8);
					if (pngIHDR.pngHeight % 8) {
						pngInterlaceHeights[0]++;
					}
					pngInterlaceHeights[1] = pngInterlaceHeights[0];

					if (pngIHDR.pngHeight <= 4) {
						pngInterlaceWidths[2] = 0;
						pngInterlaceHeights[2] = 0;
					}
					else {
						pngInterlaceHeights[2] = cast(uint)((cast(float)pngIHDR.pngHeight - 4) / 8);
						if ((pngIHDR.pngHeight - 4) % 8) {
							pngInterlaceHeights[2]++;
						}
					}

					pngInterlaceHeights[3] = cast(uint)(cast(float)pngIHDR.pngHeight / 4);
					if (pngIHDR.pngHeight % 4) {
						pngInterlaceHeights[3]++;
					}

					if (pngIHDR.pngHeight <= 2) {
						pngInterlaceWidths[4] = 0;
						pngInterlaceHeights[4] = 0;
					}
					else {
						pngInterlaceHeights[4] = cast(uint)((cast(float)pngIHDR.pngHeight - 2) / 4);
						if ((pngIHDR.pngHeight - 2) % 4) {
							pngInterlaceHeights[4]++;
						}
					}

					pngInterlaceHeights[5] = cast(uint)(cast(float)pngIHDR.pngHeight / 2);
					if (pngIHDR.pngHeight % 2) {
						pngInterlaceHeights[5]++;
					}

					if (pngIHDR.pngHeight <= 1) {
						pngInterlaceWidths[6] = 0;
						pngInterlaceHeights[6] = 0;
					}
					else {
						pngInterlaceHeights[6] = cast(uint)((cast(float)pngIHDR.pngHeight - 1) / 2);
						if ((pngIHDR.pngHeight - 1) % 2) {
							pngInterlaceHeights[6]++;
						}
					}

					for (p=0; p < 7; p++) {
	//					Console.putln(toString(p) + (": ") + toString(pngInterlaceWidths[p]) + (" x ") + toString(pngInterlaceHeights[p]) + ("\n"));
					}

				}
				else {
	//				Console.putln("png - no interlacing\n");
				}

				// calculate quick reference 'image type' //
				pngImageType = (((pngIHDR.pngColorType + 1) << 16) + pngIHDR.pngBitDepth);

				// set the image renderer state in the decoder process //
				if (pngIHDR.pngInterlaceMethod) {
					pngRenderState = PNG_STATE_RENDER_INTERLACED_STATE_BASE + pngImageType;
				}
				else {
					pngRenderState = PNG_STATE_RENDER_STATE_BASE + pngImageType;

	//			Console.putln("eh!", pngRenderState, PNG_STATE_RENDER_STATE_BASE + PNG_TRUECOLOUR_ALPHA_8BPP);
				}

//	printf("type: %d\n", pngIHDR.pngWidth);
				view.resize(pngIHDR.pngWidth, pngIHDR.pngHeight);

				// CALCULATE THE NUMBER OF BYTES WE WILL BE READING
				switch(pngIHDR.pngColorType) {
				case 3: // INDEXED_COLOUR (also 1 sample per pixel, samples are indices)
				case 0: // GREYSCALE (1 sample per pixel)
					switch(pngIHDR.pngBitDepth) {
						case 1:
							pngExpectedBytes = 1 + cast(uint)((cast(float)pngIHDR.pngWidth / 8) + 0.5);
							pngNumSamples = 1;
							break;
						case 2:
							pngExpectedBytes = 1 + cast(uint)((cast(float)pngIHDR.pngWidth / 4) + 0.5);
							pngNumSamples = 1;
							break;
						case 4:
							pngExpectedBytes = 1 + cast(uint)((cast(float)pngIHDR.pngWidth / 2) + 0.5);
							pngNumSamples = 1;
							break;
						case 8:
							pngExpectedBytes = pngIHDR.pngWidth;
							pngNumSamples = 1;
							break;
						case 16:
							pngExpectedBytes = pngIHDR.pngWidth * 2;
							pngNumSamples = 2;
							break;
						default: break;
					}

					break;

				case 2: // TRUE_COLOUR

					switch(pngIHDR.pngBitDepth) {
						case 8:
							pngExpectedBytes = pngIHDR.pngWidth * 3;
							pngNumSamples = 3;
							break;
						case 16:
							pngExpectedBytes = pngIHDR.pngWidth * (3 * 2);
							pngNumSamples = 6;
							break;
						default: break;
					}
					break;
				case 4: // GREYSCALE_ALPHA
					switch(pngIHDR.pngBitDepth) {
						case 8:
							pngExpectedBytes = pngIHDR.pngWidth * 2;
							pngNumSamples = 2;
							break;
						case 16:
							pngExpectedBytes = pngIHDR.pngWidth * (2 * 2);
							pngNumSamples = 4;
							break;
						default: break;
					}
					break;
				case 6: // TRUE_COLOUR_ALPHA

					switch(pngIHDR.pngBitDepth) {
						case 8:
							pngExpectedBytes = pngIHDR.pngWidth * 4;
							pngNumSamples = 4;
							break;
						case 16:
							pngExpectedBytes = pngIHDR.pngWidth * (4 * 2);
							pngNumSamples = 8;
							break;
						default: break;
					}
					break;


					default: break;
				}

				// INIT DECODER DATA

				for ( pngCounter = 0; pngCounter < 8; pngCounter++) {
					////Console.putln(("png - ") + toString(pngIHDR.pngWidth) + (" x ") + toString(pngIHDR.pngHeight) + ("\n"));
					pngBytes[pngCounter] = new ubyte[pngExpectedBytes];
					pngBytes[pngCounter][0..pngExpectedBytes] = 0;
				}

				nsamp = 0;
				psamp = 0;

				pngCounter = -1;

				decoderState = PNG_STATE_READ_CHUNK_CRC;

				continue;

			case PNG_STATE_READ_PLTE:

				// GET NUMBER OF PALETTE ENTRIES

				// LOOK AT CHUNK DATA LENGTH, DIVIDE BY THREE
				// IF THERE IS A REMAINDER, THIS PNG IS INVALID

				pngPaletteCount = (pngChunkHeader.pngChunkLength % 3);

				if (pngPaletteCount) {
					//////////Console.putln("png - PLTE - invalid palette chunk\n");
				}

				pngPaletteCount = pngChunkHeader.pngChunkLength / 3;

				if (pngPaletteCount > 256) {
					//////////Console.putln("png - PLTE - too many entries in palette\n");
					return StreamData.Invalid;
				}

				if (pngPaletteCount == 0) {
					//////////Console.putln("png - PLTE - empty palette, proceeding anyway\n");
					decoderState = PNG_STATE_READ_CHUNK_CRC;
					continue;
				}

			case PNG_STATE_READ_PLTE_ENTRIES:

				if(!(stream.read(&pngPalette, pngPaletteCount*3))) {
					return StreamData.Required;
				}

				// build pngPaletteRealized //
				for (palIndex = 0; palIndex < pngPaletteCount; palIndex++) {
					pngPaletteRealized[palIndex] = (0xFF000000) | (pngPalette[palIndex].blue) | (pngPalette[palIndex].green << 8) | (pngPalette[palIndex].red << 16);
				}

				for ( ; palIndex < 256; palIndex++) {
					pngPaletteRealized[palIndex] = 0;
				}

				decoderState = PNG_STATE_READ_CHUNK_CRC;
				continue;

			case PNG_STATE_READ_IDAT:

				// GET THE CONTENTS OF THE CHUNK DATA

				//////////Console.putln(toString(pngChunkHeader.pngChunkLength) + ("chunk header\n"));

				//streamToDecode.clear();

				decoderState = PNG_STATE_FILL_IDAT;

			case PNG_STATE_FILL_IDAT:
	//				Console.putln("fill idat");

	//			if(!(stream.read(streamToDecode, pngChunkHeader.pngChunkLength)))
				if(!(streamToDecode.append(stream, pngChunkHeader.pngChunkLength))) {
					return StreamData.Required;
				}
	//				Console.putln("fill idat");

				ubyte b;


				//Console.putln("pos: ", streamToDecode.getPosition());

				//////////Console.putln(toString(streamToDecode.getLength()) + ("\n"));

				//streamToDecode.rewind();

				//////////Console.putln(toString(byte) + ("oo\n"));

				//if (stream.PushRestriction(stream.getPosition(), pngChunkHeader.pngChunkLength))
				//{
				//////////Console.putln(toString(stream.getLength()) + ("!!!!\n"));
				//}
				//////////Console.putln(toString(stream.getLength()) + ("oo\n"));

				/*
				if (zlibCodec.decode(streamToDecode, pngUncompressedData, pngCompressionProgress) == StreamData.Complete)
				{

					//while (pngUncompressedData.getRemaining())
					//{
					//	pngUncompressedData.Readubyte(curByte);
						////////////Console.putln((":") + toString(curByte) + ("\n"));
					//}

					//pngUncompressedData.rewind();

					view.lockBuffer((void**)&ptr_start, ptr_len);

					ptr = ptr_start;

					ptr += (pngIHDR.pngWidth * ptrLine);
					ptr_max_line = ptr + pngIHDR.pngWidth;

					ptr_max_page = ptr_start + (ptr_len / 4);

					ptr += ptrPos;

					//if (decoderNextState == PNG_STATE_DECODE_READ_FILTER_TYPE)
					//{
						//////////Console.putln("png - reading filter type\n");
					//}
					//else
					//{
						//////////Console.putln("png - returning to scanline render\n");
					//}

					decoderState = decoderNextState;
				}
				else
				{
					decoderState = PNG_STATE_READ_CHUNK_CRC;
				}//*/ decoderState = PNG_STATE_READ_CHUNK_CRC;


				//stream.PopRestriction();

				//////////Console.putln(toString(stream.getLength()) + ("xx\n"));

				//////////Console.putln(toString(pngUncompressedData.getRemaining()) + ("\n") + toString(pngChunkHeader.pngChunkLength) + ("\n"));

				//stream.skip(pngChunkHeader.pngChunkLength);

				continue;

			case PNG_STATE_DECODE_READ_FILTER_TYPE:

				//Console.putln("read filter type");

	//			pngUncompressedData.rewind();

				if (!(pngUncompressedData.read(&pngFilterType, 1))) {
					// need more compress data from IDAT blocks
					//////////Console.putln("IDAT empty\n");
					decoderState = PNG_STATE_READ_CHUNK_HEADER;
					continue;
				}

				//Console.putln("done filter type");

				switch (pngFilterType) {
				case 0:
	//				Console.putln("\npng - filter type - none\n");
					decoderState = PNG_STATE_UNFILTER_NONE;
					decoderSubState = PNG_STATE_UNFILTER_NONE;
					break;
				case 1:
	//				Console.putln("\npng - filter type - Sub\n");
					decoderState = PNG_STATE_UNFILTER_SUB;
					decoderSubState = PNG_STATE_UNFILTER_SUB;
					break;
				case 2:
	//				Console.putln("\npng - filter type - Up\n");
					decoderState = PNG_STATE_UNFILTER_UP;
					decoderSubState = PNG_STATE_UNFILTER_UP;
					break;
				case 3:
	//				Console.putln("\npng - filter type - Average\n");
					decoderState = PNG_STATE_UNFILTER_AVERAGE;
					decoderSubState = PNG_STATE_UNFILTER_AVERAGE;
					break;
				case 4:
	//				Console.putln("\npng - filter type - Paeth\n");
					decoderState = PNG_STATE_UNFILTER_PAETH;
					decoderSubState = PNG_STATE_UNFILTER_PAETH;
					break;
				default:
	//				Console.putln(("\npng - invalid filter type") ~ toString(pngFilterType) ~ ("\n"));
					view.unlockBuffer();
					return StreamData.Invalid;
				}

				// set the filter state in the decoder process, should we be interrupted
				pngFilterState = decoderState;

				for (p = 0; p < pngNumSamples; p++) {
					pngPriorPixel[p] = 0;
					pngPriorScannedByte[p] = 0;
				}

				nsamp = 0;
				psamp = 0;

				pngCounter = -1;

				continue;








			// FILTER STATES //



			case PNG_STATE_UNFILTER_NONE:

				// check for decoder termination for the current scanline //

				if (ptrPos >= pngIHDR.pngWidth) {
					// WE ARE DONE

					if (pngIHDR.pngInterlaceMethod) {
						pngInterlaceCurLine++;

						if (pngInterlaceCurLine == pngInterlaceHeights[pngInterlacePass]) {
							pngInterlaceCurLine = 0;

							// we are entering a new interlace pass
							//////Console.putln("png - interlaced - entering new interlace pass\n");

							// reset the prior scanline array
							for ( pngCounter = 0; pngCounter < 8; pngCounter++) {
								pngBytes[pngCounter][0..pngExpectedBytes] = 0;
							}

							do {
								pngInterlacePass++;
							} while ((pngInterlacePass < 7) && (pngInterlaceWidths[pngInterlacePass] == 0));


							if (pngInterlacePass >= 7) {
								// We are done decoding

								view.unlockBuffer();

								return StreamData.Complete;
							}

							ptrLine = pngInterlaceStartsY[pngInterlacePass];
						}
						else {
							ptrLine+=pngInterlaceIncrementsY[pngInterlacePass];
						}

						ptrPos = pngInterlaceStartsX[pngInterlacePass];

						ptr = ptr_start + ((pngIHDR.pngWidth * ptrLine) + ptrPos);
					}
					else {
						ptrPos = 0;
						ptrLine++;
					}

					pngCounter = -1;

					decoderState = PNG_STATE_DECODE_READ_FILTER_TYPE;

					if (ptrLine >= pngIHDR.pngHeight) {
	//					Console.putln("done?\n");

						view.unlockBuffer();

	//					Console.putln("done!\n");

						return StreamData.Complete;

					}

					continue;
				}

				// READ IN DECODED BYTE

				if (!(pngUncompressedData.read(&curByte, 1))) {
					decoderNextState = decoderState;
					//////////Console.putln("png - requiring more data in IDAT\n");
					view.unlockBuffer();
					decoderState = PNG_STATE_READ_CHUNK_CRC;
					continue;
				}

				// UNFILTER

				pngCounter++;

				pngCurComponent[psamp] = curByte;
				pngBytes[psamp][nsamp] = curByte;

			//	Console.put(pngCurComponent[psamp], " ");


				psamp++;
				if (psamp == pngNumSamples) {
					nsamp++;
					psamp = 0;
	//				Console.putln("renderstate");
					decoderState = pngRenderState;
				}

				// go to the next state
				continue;




				// SUB FILTER //

			case PNG_STATE_UNFILTER_SUB:

				// check for decoder termination for the current scanline //

				if (ptrPos >= pngIHDR.pngWidth) {
					// WE ARE DONE

					if (pngIHDR.pngInterlaceMethod) {
						pngInterlaceCurLine++;

						if (pngInterlaceCurLine == pngInterlaceHeights[pngInterlacePass]) {
							pngInterlaceCurLine = 0;

							// we are entering a new interlace pass
							//////Console.putln("png - interlaced - entering new interlace pass\n");

							// reset the prior scanline array
							for ( pngCounter = 0; pngCounter < 8; pngCounter++) {
								pngBytes[pngCounter][0..pngExpectedBytes] = 0;
							}

							pngInterlacePass++;

							if (pngInterlacePass == 7) {
								// We are done decoding

								view.unlockBuffer();

								return StreamData.Complete;
							}

							ptrLine = pngInterlaceStartsY[pngInterlacePass];
						}
						else {
							ptrLine+=pngInterlaceIncrementsY[pngInterlacePass];
						}

						ptrPos = pngInterlaceStartsX[pngInterlacePass];

						ptr = ptr_start + ((pngIHDR.pngWidth * ptrLine) + ptrPos);
					}
					else {
						ptrPos = 0;
						ptrLine++;
					}

					pngCounter = -1;

					decoderState = PNG_STATE_DECODE_READ_FILTER_TYPE;

					if (ptrLine >= pngIHDR.pngHeight) {
						view.unlockBuffer();

						return StreamData.Complete;

					}

					continue;
				}

				// decode a scanline using SUB filter

				if (!(pngUncompressedData.read(&curByte, 1))) {
					decoderNextState = decoderState;
					//////////Console.putln("png - requiring more data in IDAT\n");
					view.unlockBuffer();
					decoderState = PNG_STATE_READ_CHUNK_CRC;
					continue;
				}

				pngCounter++;

				pngPriorPixel[psamp] += curByte;
				pngCurComponent[psamp] = pngPriorPixel[psamp];
				pngBytes[psamp][nsamp] = cast(ubyte)pngCurComponent[psamp];

			//	Console.put(pngCurComponent[psamp], " ");

				psamp++;
				if (psamp == pngNumSamples) {
					nsamp++;
					psamp = 0;
	//				Console.putln("renderstate");
					decoderState = pngRenderState;
				}


				// go to the next state
				continue;

			case PNG_STATE_UNFILTER_UP:

				// check for decoder termination for the current scanline //

				if (ptrPos >= pngIHDR.pngWidth) {
					// WE ARE DONE

					if (pngIHDR.pngInterlaceMethod) {
						pngInterlaceCurLine++;

						if (pngInterlaceCurLine == pngInterlaceHeights[pngInterlacePass]) {
							pngInterlaceCurLine = 0;

							// we are entering a new interlace pass
							//////Console.putln("png - interlaced - entering new interlace pass\n");

							// reset the prior scanline array
							for ( pngCounter = 0; pngCounter < 8; pngCounter++) {
								pngBytes[pngCounter][0..pngExpectedBytes] = 0;
							}

							pngInterlacePass++;

							if (pngInterlacePass == 7) {
								// We are done decoding

								view.unlockBuffer();

								return StreamData.Complete;
							}

							ptrLine = pngInterlaceStartsY[pngInterlacePass];
						}
						else {
							ptrLine+=pngInterlaceIncrementsY[pngInterlacePass];
						}

						ptrPos = pngInterlaceStartsX[pngInterlacePass];

						ptr = ptr_start + ((pngIHDR.pngWidth * ptrLine) + ptrPos);
					}
					else {
						ptrPos = 0;
						ptrLine++;
					}

					pngCounter = -1;

					decoderState = PNG_STATE_DECODE_READ_FILTER_TYPE;

					if (ptrLine >= pngIHDR.pngHeight) {

						view.unlockBuffer();

						return StreamData.Complete;

					}

					continue;
				}

				// decode a scanline using UP filter

				if (!(pngUncompressedData.read(&curByte, 1))) {
					decoderNextState = decoderState;
					//////////Console.putln("png - requiring more data in IDAT\n");
					view.unlockBuffer();
					decoderState = PNG_STATE_READ_CHUNK_CRC;
					continue;
				}

				pngCounter++;



			//	Console.put(pngBytes[psamp][nsamp], "+", curByte, "=");

				pngBytes[psamp][nsamp] += curByte;

			//	Console.put(pngBytes[psamp][nsamp], " ");

				pngCurComponent[psamp] = pngBytes[psamp][nsamp];

				psamp++;
				if (psamp == pngNumSamples) {
					nsamp++;
					psamp = 0;
	//				Console.putln("renderstate");
					decoderState = pngRenderState;
				}

				// go to the next state
				continue;

			case PNG_STATE_UNFILTER_AVERAGE:
				// check for decoder termination for the current scanline //

				if (ptrPos >= pngIHDR.pngWidth) {
					// WE ARE DONE

					if (pngIHDR.pngInterlaceMethod) {

						pngInterlaceCurLine++;

						if (pngInterlaceCurLine == pngInterlaceHeights[pngInterlacePass]) {
							pngInterlaceCurLine = 0;

							// we are entering a new interlace pass
							//////Console.putln("png - interlaced - entering new interlace pass\n");

							// reset the prior scanline array
							for ( pngCounter = 0; pngCounter < 8; pngCounter++) {
								pngBytes[pngCounter][0..pngExpectedBytes] = 0;
							}

							pngInterlacePass++;

							if (pngInterlacePass == 7) {
								// We are done decoding

								view.unlockBuffer();

								return StreamData.Complete;
							}

							ptrLine = pngInterlaceStartsY[pngInterlacePass];
						}
						else {
							ptrLine+=pngInterlaceIncrementsY[pngInterlacePass];
						}

						ptrPos = pngInterlaceStartsX[pngInterlacePass];

						ptr = ptr_start + ((pngIHDR.pngWidth * ptrLine) + ptrPos);
					}
					else {
						ptrPos = 0;
						ptrLine++;
					}

					pngCounter = -1;

					decoderState = PNG_STATE_DECODE_READ_FILTER_TYPE;

					if (ptrLine >= pngIHDR.pngHeight) {

						view.unlockBuffer();

						return StreamData.Complete;

					}

					continue;
				}

				// decode a scanline using AVERAGE filter

				if (!(pngUncompressedData.read(&curByte, 1))) {
					decoderNextState = decoderState;
					//////////Console.putln("png - requiring more data in IDAT\n");
					view.unlockBuffer();
					decoderState = PNG_STATE_READ_CHUNK_CRC;
					continue;
				}

				pngCounter++;

				pngCurComponent[psamp] = ((cast(uint)pngPriorPixel[psamp] + cast(uint)pngBytes[psamp][nsamp]) / 2);
				pngCurComponent[psamp] += curByte;
				pngBytes[psamp][nsamp] = cast(ubyte)pngCurComponent[psamp];
				pngCurComponent[psamp] = pngBytes[psamp][nsamp];

				pngPriorPixel[psamp] = cast(ubyte)pngCurComponent[psamp];

			//	Console.put(pngCurComponent[psamp], " ");

				psamp++;
				if (psamp == pngNumSamples) {
					nsamp++;
					psamp = 0;
	//				Console.putln("renderstate");
					decoderState = pngRenderState;
				}

				// go to the next state
				continue;

			case PNG_STATE_UNFILTER_PAETH:

				// UNFILTER A SCANLINE

				// READ IN DECODED BYTE

				if (ptrPos >= pngIHDR.pngWidth) {
					// WE ARE DONE

					if (pngIHDR.pngInterlaceMethod) {

						pngInterlaceCurLine++;

						if (pngInterlaceCurLine == pngInterlaceHeights[pngInterlacePass]) {
							// we are entering a new interlace pass
							pngInterlaceCurLine = 0;

							// reset the prior scanline array
							for ( pngCounter = 0; pngCounter < 8; pngCounter++) {
								pngBytes[pngCounter][0..pngExpectedBytes] = 0;
							}

							pngInterlacePass++;

							if (pngInterlacePass == 7) {
								// We are done decoding

								view.unlockBuffer();

								return StreamData.Complete;
							}

							ptrLine = pngInterlaceStartsY[pngInterlacePass];
						}
						else {
							ptrLine+=pngInterlaceIncrementsY[pngInterlacePass];
						}

						ptrPos = pngInterlaceStartsX[pngInterlacePass];

						ptr = ptr_start + ((pngIHDR.pngWidth * ptrLine) + ptrPos);
					}
					else {
						ptrPos = 0;
						ptrLine++;
					}

					pngCounter = -1;

					decoderState = PNG_STATE_DECODE_READ_FILTER_TYPE;

					if (ptrLine >= pngIHDR.pngHeight) {

						view.unlockBuffer();

						return StreamData.Complete;

					}

					continue;
				}

				if (!(pngUncompressedData.read(&curByte, 1))) {
					decoderNextState = decoderState;
					//////////Console.putln("png - requiring more data in IDAT\n");
					view.unlockBuffer();
					decoderState = PNG_STATE_READ_CHUNK_CRC;
					continue;
				}

				// UNFILTER
				pngCounter++;

				pngPriorScannedComp = pngPriorScannedByte[psamp];
				pngPriorScannedByte[psamp] = pngBytes[psamp][nsamp];

				p = cast(int)pngPriorPixel[psamp] + cast(int)pngPriorScannedByte[psamp] - cast(int)pngPriorScannedComp;

				if (p > cast(int)pngPriorPixel[psamp]) {
					pa = p - cast(int)pngPriorPixel[psamp];
				}
				else {
					pa = cast(int)pngPriorPixel[psamp] - p;
				}

				if (p > cast(int)pngPriorScannedByte[psamp]) {
					pb = p - cast(int)pngPriorScannedByte[psamp];
				}
				else {
					pb = cast(int)pngPriorScannedByte[psamp] - p;
				}

				if (p > cast(int)pngPriorScannedComp) {
					pc = p - cast(int)pngPriorScannedComp;
				}
				else {
					pc = cast(int)pngPriorScannedComp - p;
				}

				if (pa <= pb && pa <= pc) {
					pngPaethPredictor = pngPriorPixel[psamp];
				}
				else if (pb <= pc) {
					pngPaethPredictor = pngPriorScannedByte[psamp];
				}
				else {
					pngPaethPredictor = pngPriorScannedComp;
				}

				recon = cast(ubyte)(curByte + pngPaethPredictor);

				////////////Console.putln(("pr: ") + toString(pngPaethPredictor) + (" f(x): ") + toString(recon) + ("\n"));

				pngPriorPixel[psamp] = recon;
				pngCurComponent[psamp] = recon;

				pngBytes[psamp][nsamp] = cast(ubyte)pngCurComponent[psamp];

		//		Console.put(pngCurComponent[psamp], " ");

				////////////Console.putln(toString(curByte) + (" --> "));
				////////////Console.putln(toString(pngCurComponent[psamp]) + (" a:") + toString(a) + (" b:") + toString(b) + (" c:") + toString(c) + (" pa:") + toString(pa) + (" pb:") + toString(pb) + (" pc:") + toString(pc) + (" p:") + toString(pngPaethPredictor) + ("\n"));

				////////////Console.putln(("result->") + toString(pngCurComponent[psamp]) + ("\n"));

				psamp++;
				if (psamp == pngNumSamples)
				{
					nsamp++;
					psamp = 0;
	//				Console.putln("renderstate");
					decoderState = pngRenderState;
				}

				// go to the next state
				continue;

				// RENDER STATES //

			case PNG_STATE_RENDER_STATE_BASE + PNG_GREYSCALE_1BPP:

				// GO BACK TO FILTER ANOTHER PIECE OF THE DATA

				decoderState = pngFilterState;

				// WE WILL ADD 8 PIXELS, IF WE CAN

				pngCurSample = png1BPP[pngCurComponent[0] >> 7];

				ptr[0] = view.rgbTouint(pngCurSample, pngCurSample, pngCurSample);

				ptr++;
				ptrPos++;

				if (ptrPos == pngIHDR.pngWidth) {
					continue;
				}

				pngCurSample = png1BPP[(pngCurComponent[0] >> 6) & 1];

				ptr[0] = view.rgbTouint(pngCurSample, pngCurSample, pngCurSample);

				ptr++;
				ptrPos++;

				if (ptrPos == pngIHDR.pngWidth) {
					continue;
				}

				pngCurSample = png1BPP[(pngCurComponent[0] >> 5) & 1];

				ptr[0] = view.rgbTouint(pngCurSample, pngCurSample, pngCurSample);

				ptr++;
				ptrPos++;

				if (ptrPos == pngIHDR.pngWidth) {
					continue;
				}

				pngCurSample= png1BPP[(pngCurComponent[0] >> 4) & 1];

				ptr[0] = view.rgbTouint(pngCurSample, pngCurSample, pngCurSample);

				ptr++;
				ptrPos++;

				if (ptrPos == pngIHDR.pngWidth) {
					continue;
				}

				pngCurSample = png1BPP[(pngCurComponent[0] >> 3) & 1];

				ptr[0] = view.rgbTouint(pngCurSample, pngCurSample, pngCurSample);

				ptr++;
				ptrPos++;

				if (ptrPos == pngIHDR.pngWidth) {
					continue;
				}

				pngCurSample = png1BPP[(pngCurComponent[0] >> 2) & 1];

				ptr[0] = view.rgbTouint(pngCurSample, pngCurSample, pngCurSample);

				ptr++;
				ptrPos++;

				if (ptrPos == pngIHDR.pngWidth) {
					continue;
				}

				pngCurSample = png1BPP[(pngCurComponent[0] >> 1) & 1];

				ptr[0] = view.rgbTouint(pngCurSample, pngCurSample, pngCurSample);

				ptr++;
				ptrPos++;

				if (ptrPos == pngIHDR.pngWidth) {
					continue;
				}

				pngCurSample = png1BPP[pngCurComponent[0] & 1];

				ptr[0] = view.rgbTouint(pngCurSample, pngCurSample, pngCurSample);

				ptr++;
				ptrPos++;

				continue;

			case PNG_STATE_RENDER_STATE_BASE + PNG_GREYSCALE_2BPP:

				// GO BACK TO FILTER ANOTHER PIECE OF THE DATA

				decoderState = pngFilterState;

				// WE WILL ADD 4 PIXELS, IF WE CAN

				pngCurSample = png2BPP[pngCurComponent[0] >> 6];

				ptr[0] = view.rgbTouint(pngCurSample, pngCurSample, pngCurSample);

				ptr++;
				ptrPos++;

				if (ptrPos == pngIHDR.pngWidth) {
					continue;
				}

				pngCurSample = png2BPP[(pngCurComponent[0] >> 4) & 0x3];

				ptr[0] = view.rgbTouint(pngCurSample, pngCurSample, pngCurSample);

				ptr++;
				ptrPos++;

				if (ptrPos == pngIHDR.pngWidth) {
					continue;
				}

				pngCurSample = png2BPP[(pngCurComponent[0] >> 2) & 0x3];

				ptr[0] = view.rgbTouint(pngCurSample, pngCurSample, pngCurSample);

				ptr++;
				ptrPos++;

				if (ptrPos == pngIHDR.pngWidth) {
					continue;
				}

				pngCurSample = png2BPP[pngCurComponent[0] & 0x3];

				ptr[0] = view.rgbTouint(pngCurSample, pngCurSample, pngCurSample);

				ptr++;
				ptrPos++;

				continue;

			case PNG_STATE_RENDER_STATE_BASE + PNG_GREYSCALE_4BPP:

				// GO BACK TO FILTER ANOTHER PIECE OF THE DATA

				decoderState = pngFilterState;

				// WE WILL ADD 2 PIXELS, IF WE CAN

				pngCurSample = png4BPP[pngCurComponent[0] >> 4];

				ptr[0] = 0xFF000000 | (pngCurSample) | (pngCurSample << 8) | (pngCurSample << 16);
				ptr++;
				ptrPos++;

				if (ptrPos == pngIHDR.pngWidth) {
					continue;
				}

				pngCurSample = png4BPP[pngCurComponent[0] & 0xF];

				ptr[0] = 0xFF000000 | (pngCurSample) | (pngCurSample << 8) | (pngCurSample << 16);
				ptr++;
				ptrPos++;

				continue;

			case PNG_STATE_RENDER_STATE_BASE + PNG_GREYSCALE_8BPP:

				// GO BACK TO FILTER ANOTHER PIECE OF THE DATA

				decoderState = pngFilterState;

				// JUST ADD THE PIXEL

				ptr[0] = view.rgbTouint(pngCurComponent[0], pngCurComponent[0], pngCurComponent[0]);

				ptr++;
				ptrPos++;

				continue;

			case PNG_STATE_RENDER_STATE_BASE + PNG_GREYSCALE_16BPP:

				// GO BACK TO FILTER ANOTHER PIECE OF THE DATA

				decoderState = pngFilterState;

				// JUST ADD THE PIXEL

				pngCurComponent[0] = cast(ubyte)(((cast(float)((pngCurComponent[0] << 8) | pngCurComponent[1]) / cast(float)0xFFFF) * cast(float)0xFF) + 0.5);

				ptr[0] = view.rgbTouint(pngCurComponent[0], pngCurComponent[0], pngCurComponent[0]);

				ptr++;
				ptrPos++;

				continue;



			case PNG_STATE_RENDER_STATE_BASE + PNG_TRUECOLOUR_8BPP:

				// GO BACK TO FILTER ANOTHER PIECE OF THE DATA

				decoderState = pngFilterState;

				// JUST ADD THE PIXEL

				ptr[0] = view.rgbTouint(pngCurComponent[0], pngCurComponent[1], pngCurComponent[2]);

				ptr++;
				ptrPos++;

				continue;

			case PNG_STATE_RENDER_STATE_BASE + PNG_TRUECOLOUR_16BPP:

				// GO BACK TO FILTER ANOTHER PIECE OF THE DATA

				decoderState = pngFilterState;


				pngCurComponent[0] = cast(ubyte)(((cast(float)((pngCurComponent[0] << 8) | pngCurComponent[1]) / cast(float)0xFFFF) * cast(float)0xFF) + 0.5);
				pngCurComponent[1] = cast(ubyte)(((cast(float)((pngCurComponent[2] << 8) | pngCurComponent[3]) / cast(float)0xFFFF) * cast(float)0xFF) + 0.5);
				pngCurComponent[2] = cast(ubyte)(((cast(float)((pngCurComponent[4] << 8) | pngCurComponent[5]) / cast(float)0xFFFF) * cast(float)0xFF) + 0.5);


				ptr[0] = view.rgbTouint(pngCurComponent[0], pngCurComponent[1], pngCurComponent[2]);

				ptr++;
				ptrPos++;

				continue;

			case PNG_STATE_RENDER_STATE_BASE + PNG_INDEXED_COLOUR_1BPP:

				// GO BACK TO FILTER ANOTHER PIECE OF THE DATA

	//			Console.putln("index?\n");

				decoderState = pngFilterState;

				// WE WILL ADD 8 PIXELS, IF WE CAN

				pngCurSample = pngCurComponent[0] >> 7;

				if (pngCurSample >= pngPaletteCount) {
					pngCurSample = 0;
				}

				ptr[0] = pngPaletteRealized[pngCurSample];
				ptr++;
				ptrPos++;

				if (ptrPos == pngIHDR.pngWidth) {
					continue;
				}

				pngCurSample = (pngCurComponent[0] >> 6) & 1;

				if (pngCurSample >= pngPaletteCount) {
					pngCurSample = 0;
				}

				ptr[0] = pngPaletteRealized[pngCurSample];
				ptr++;
				ptrPos++;

				if (ptrPos == pngIHDR.pngWidth) {
					continue;
				}

				pngCurSample = (pngCurComponent[0] >> 5) & 1;

				if (pngCurSample >= pngPaletteCount) {
					pngCurSample = 0;
				}

				ptr[0] = pngPaletteRealized[pngCurSample];
				ptr++;
				ptrPos++;

				if (ptrPos == pngIHDR.pngWidth) {
					continue;
				}

				pngCurSample = (pngCurComponent[0] >> 4) & 1;

				if (pngCurSample >= pngPaletteCount) {
					pngCurSample = 0;
				}

				ptr[0] = pngPaletteRealized[pngCurSample];
				ptr++;
				ptrPos++;

				if (ptrPos == pngIHDR.pngWidth) {
					continue;
				}

				pngCurSample = (pngCurComponent[0] >> 3) & 1;

				if (pngCurSample >= pngPaletteCount) {
					pngCurSample = 0;
				}

				ptr[0] = pngPaletteRealized[pngCurSample];
				ptr++;
				ptrPos++;

				if (ptrPos == pngIHDR.pngWidth) {
					continue;
				}

				pngCurSample = (pngCurComponent[0] >> 2) & 1;

				if (pngCurSample >= pngPaletteCount) {
					pngCurSample = 0;
				}

				ptr[0] = pngPaletteRealized[pngCurSample];
				ptr++;
				ptrPos++;

				if (ptrPos == pngIHDR.pngWidth) {
					continue;
				}

				pngCurSample = (pngCurComponent[0] >> 1) & 1;

				if (pngCurSample >= pngPaletteCount) {
					pngCurSample = 0;
				}

				ptr[0] = pngPaletteRealized[pngCurSample];
				ptr++;
				ptrPos++;

				if (ptrPos == pngIHDR.pngWidth) {
					continue;
				}

				pngCurSample = pngCurComponent[0] & 1;

				if (pngCurSample >= pngPaletteCount) {
					pngCurSample = 0;
				}

				ptr[0] = pngPaletteRealized[pngCurSample];
				ptr++;
				ptrPos++;

				continue;

			case PNG_STATE_RENDER_STATE_BASE + PNG_INDEXED_COLOUR_2BPP:

	//			Console.putln("hey!\n");

				// GO BACK TO FILTER ANOTHER PIECE OF THE DATA

				decoderState = pngFilterState;

				// WE WILL ADD 4 PIXELS, IF WE CAN

				pngCurSample = pngCurComponent[0] >> 6;

				if (pngCurSample >= pngPaletteCount) {
					pngCurSample = 0;
				}
	//			Console.putln("1st pixel...\n");

				ptr[0] = pngPaletteRealized[pngCurSample];
				ptr++;
				ptrPos++;

	//			Console.putln("1st pixel!\n");

				if (ptrPos >= pngIHDR.pngWidth) {
					continue;
				}

				pngCurSample = (pngCurComponent[0] >> 4) & 0x3;

				if (pngCurSample >= pngPaletteCount) {
					pngCurSample = 0;
				}

	//			Console.putln("2nd pixel...\n");

				ptr[0] = pngPaletteRealized[pngCurSample];
				ptr++;
				ptrPos++;

	//			Console.putln("2nd pixel!\n");

				if (ptrPos >= pngIHDR.pngWidth) {
					continue;
				}

				pngCurSample = (pngCurComponent[0] >> 2) & 0x3;

				if (pngCurSample >= pngPaletteCount) {
					pngCurSample = 0;
				}

	//			Console.putln("3rd pixel...\n");

				ptr[0] = pngPaletteRealized[pngCurSample];
				ptr++;
				ptrPos++;

	//			Console.putln("3rd pixel!\n");

				if (ptrPos >= pngIHDR.pngWidth) {
					continue;
				}

				pngCurSample = pngCurComponent[0] & 0x3;

				if (pngCurSample >= pngPaletteCount) {
					pngCurSample = 0;
				}

	//			Console.putln("4th pixel...\n");

				ptr[0] = pngPaletteRealized[pngCurSample];
				ptr++;
				ptrPos++;

	//			Console.putln("4th pixel!\n");

				continue;

			case PNG_STATE_RENDER_STATE_BASE + PNG_INDEXED_COLOUR_4BPP:

				// GO BACK TO FILTER ANOTHER PIECE OF THE DATA

				decoderState = pngFilterState;

				// WE WILL ADD 2 PIXELS, IF WE CAN

				pngCurSample = pngCurComponent[0] >> 4;

				if (pngCurSample >= pngPaletteCount) {
					pngCurSample = 0;
				}

				ptr[0] = pngPaletteRealized[pngCurSample];
				ptr++;
				ptrPos++;

				if (ptrPos == pngIHDR.pngWidth) {
					continue;
				}

				pngCurSample = pngCurComponent[0] & 0xF;

				if (pngCurSample >= pngPaletteCount) {
					pngCurSample = 0;
				}

				ptr[0] = pngPaletteRealized[pngCurSample];
				ptr++;
				ptrPos++;

				continue;

			case PNG_STATE_RENDER_STATE_BASE + PNG_INDEXED_COLOUR_8BPP:

				// GO BACK TO FILTER ANOTHER PIECE OF THE DATA

				decoderState = pngFilterState;

				if (pngCurComponent[0] >= pngPaletteCount) {
					pngCurComponent[0] = 0;
				}

				ptr[0] = pngPaletteRealized[pngCurComponent[0]];
				ptr++;
				ptrPos++;

				continue;



			case PNG_STATE_RENDER_STATE_BASE + PNG_GREYSCALE_ALPHA_8BPP:

				// GO BACK TO FILTER ANOTHER PIECE OF THE DATA

				decoderState = pngFilterState;

				// JUST ADD THE PIXEL

				// PRE MULTIPLY ALPHA WITH R, G, B
				a = cast(float)pngCurComponent[1];
				a /= cast(float)0xFF;

				a *= pngCurComponent[0];

				pngCurComponent[0] = cast(ubyte)a;
				pngCurComponent[0] %= 256;


				ptr[0] = view.rgbaTouint(pngCurComponent[0], pngCurComponent[0], pngCurComponent[0], pngCurComponent[1]);

				ptr++;
				ptrPos++;

				continue;

			case PNG_STATE_RENDER_STATE_BASE + PNG_GREYSCALE_ALPHA_16BPP:

				// GO BACK TO FILTER ANOTHER PIECE OF THE DATA

				decoderState = pngFilterState;

				pngCurComponent[0] = cast(ubyte)(((cast(float)((pngCurComponent[0] << 8) | pngCurComponent[1]) / cast(float)0xFFFF) * cast(float)0xFF) + 0.5);
				pngCurComponent[1] = cast(ubyte)(((cast(float)((pngCurComponent[2] << 8) | pngCurComponent[3]) / cast(float)0xFFFF) * cast(float)0xFF) + 0.5);

				// JUST ADD THE PIXEL

				// PRE MULTIPLY ALPHA WITH R, G, B
				a = cast(float)pngCurComponent[1];
				a /= cast(float)0xFF;

				a *= pngCurComponent[0];

				pngCurComponent[0] = cast(ubyte)a;
				pngCurComponent[0] %= 256;


				ptr[0] = view.rgbaTouint(pngCurComponent[0], pngCurComponent[0], pngCurComponent[0], pngCurComponent[1]);

				ptr++;
				ptrPos++;

				continue;



			case PNG_STATE_RENDER_STATE_BASE + PNG_TRUECOLOUR_ALPHA_8BPP:

				// GO BACK TO FILTER ANOTHER PIECE OF THE DATA

				decoderState = pngFilterState;

				// PRE MULTIPLY ALPHA WITH R, G, B

				ptr[0] = view.rgbaTouint(pngCurComponent[0], pngCurComponent[1], pngCurComponent[2], pngCurComponent[3]);

				ptr++;
				ptrPos++;

				continue;

			case PNG_STATE_RENDER_STATE_BASE + PNG_TRUECOLOUR_ALPHA_16BPP:

				// GO BACK TO FILTER ANOTHER PIECE OF THE DATA

				decoderState = pngFilterState;

				// combine the components and place them in 0, 1, 2, and 3 only
				// that is, truncate every two bytes into 4 bytes

				pngCurComponent[0] = cast(ubyte)(((cast(float)((pngCurComponent[0] << 8) | pngCurComponent[1]) / cast(float)0xFFFF) * cast(float)0xFF) + 0.5);
				pngCurComponent[1] = cast(ubyte)(((cast(float)((pngCurComponent[2] << 8) | pngCurComponent[3]) / cast(float)0xFFFF) * cast(float)0xFF) + 0.5);
				pngCurComponent[2] = cast(ubyte)(((cast(float)((pngCurComponent[4] << 8) | pngCurComponent[5]) / cast(float)0xFFFF) * cast(float)0xFF) + 0.5);
				pngCurComponent[3] = cast(ubyte)(((cast(float)((pngCurComponent[6] << 8) | pngCurComponent[7]) / cast(float)0xFFFF) * cast(float)0xFF) + 0.5);

				ptr[0] = view.rgbaTouint(pngCurComponent[0], pngCurComponent[1], pngCurComponent[2], pngCurComponent[3]);

				ptr++;
				ptrPos++;

				continue;

				// INTERLACED RENDERING ... THESE ARE SEPARATE STATES //

			case PNG_STATE_RENDER_INTERLACED_STATE_BASE + PNG_GREYSCALE_1BPP:

				// GO BACK TO FILTER ANOTHER PIECE OF THE DATA

				decoderState = pngFilterState;

				// WE WILL ADD 8 PIXELS, IF WE CAN

				pngCurSample = png1BPP[pngCurComponent[0] >> 7];

				ptr[0] = view.rgbTouint(pngCurSample, pngCurSample, pngCurSample);

				// INCREMENT WITH RESPECT TO INTERLACING

				ptr += pngInterlaceIncrementsX[pngInterlacePass];
				ptrPos += pngInterlaceIncrementsX[pngInterlacePass];

				if (ptrPos == pngIHDR.pngWidth) {
					continue;
				}

				pngCurSample = png1BPP[(pngCurComponent[0] >> 6) & 1];

				ptr[0] = view.rgbTouint(pngCurSample, pngCurSample, pngCurSample);

				// INCREMENT WITH RESPECT TO INTERLACING

				ptr += pngInterlaceIncrementsX[pngInterlacePass];
				ptrPos += pngInterlaceIncrementsX[pngInterlacePass];

				if (ptrPos == pngIHDR.pngWidth) {
					continue;
				}

				pngCurSample = png1BPP[(pngCurComponent[0] >> 5) & 1];

				ptr[0] = view.rgbTouint(pngCurSample, pngCurSample, pngCurSample);

				// INCREMENT WITH RESPECT TO INTERLACING

				ptr += pngInterlaceIncrementsX[pngInterlacePass];
				ptrPos += pngInterlaceIncrementsX[pngInterlacePass];

				if (ptrPos == pngIHDR.pngWidth) {
					continue;
				}

				pngCurSample= png1BPP[(pngCurComponent[0] >> 4) & 1];

				ptr[0] = view.rgbTouint(pngCurSample, pngCurSample, pngCurSample);

				// INCREMENT WITH RESPECT TO INTERLACING

				ptr += pngInterlaceIncrementsX[pngInterlacePass];
				ptrPos += pngInterlaceIncrementsX[pngInterlacePass];

				if (ptrPos == pngIHDR.pngWidth) {
					continue;
				}

				pngCurSample = png1BPP[(pngCurComponent[0] >> 3) & 1];

				ptr[0] = view.rgbTouint(pngCurSample, pngCurSample, pngCurSample);

				// INCREMENT WITH RESPECT TO INTERLACING

				ptr += pngInterlaceIncrementsX[pngInterlacePass];
				ptrPos += pngInterlaceIncrementsX[pngInterlacePass];

				if (ptrPos == pngIHDR.pngWidth) {
					continue;
				}

				pngCurSample = png1BPP[(pngCurComponent[0] >> 2) & 1];

				ptr[0] = view.rgbTouint(pngCurSample, pngCurSample, pngCurSample);

				// INCREMENT WITH RESPECT TO INTERLACING

				ptr += pngInterlaceIncrementsX[pngInterlacePass];
				ptrPos += pngInterlaceIncrementsX[pngInterlacePass];

				if (ptrPos == pngIHDR.pngWidth) {
					continue;
				}

				pngCurSample = png1BPP[(pngCurComponent[0] >> 1) & 1];

				ptr[0] = view.rgbTouint(pngCurSample, pngCurSample, pngCurSample);

				// INCREMENT WITH RESPECT TO INTERLACING

				ptr += pngInterlaceIncrementsX[pngInterlacePass];
				ptrPos += pngInterlaceIncrementsX[pngInterlacePass];

				if (ptrPos == pngIHDR.pngWidth) {
					continue;
				}

				pngCurSample = png1BPP[pngCurComponent[0] & 1];

				ptr[0] = view.rgbTouint(pngCurSample, pngCurSample, pngCurSample);

				// INCREMENT WITH RESPECT TO INTERLACING

				ptr += pngInterlaceIncrementsX[pngInterlacePass];
				ptrPos += pngInterlaceIncrementsX[pngInterlacePass];




				continue;

			case PNG_STATE_RENDER_INTERLACED_STATE_BASE + PNG_GREYSCALE_2BPP:

				// GO BACK TO FILTER ANOTHER PIECE OF THE DATA

				decoderState = pngFilterState;

				// WE WILL ADD 4 PIXELS, IF WE CAN

				pngCurSample = png2BPP[pngCurComponent[0] >> 6];

				ptr[0] = view.rgbTouint(pngCurSample, pngCurSample, pngCurSample);

				// INCREMENT WITH RESPECT TO INTERLACING

				ptr += pngInterlaceIncrementsX[pngInterlacePass];
				ptrPos += pngInterlaceIncrementsX[pngInterlacePass];

				if (ptrPos == pngIHDR.pngWidth) {
					continue;
				}

				pngCurSample = png2BPP[(pngCurComponent[0] >> 4) & 0x3];

				ptr[0] = view.rgbTouint(pngCurSample, pngCurSample, pngCurSample);

				// INCREMENT WITH RESPECT TO INTERLACING

				ptr += pngInterlaceIncrementsX[pngInterlacePass];
				ptrPos += pngInterlaceIncrementsX[pngInterlacePass];

				if (ptrPos == pngIHDR.pngWidth) {
					continue;
				}

				pngCurSample = png2BPP[(pngCurComponent[0] >> 2) & 0x3];

				ptr[0] = view.rgbTouint(pngCurSample, pngCurSample, pngCurSample);

				// INCREMENT WITH RESPECT TO INTERLACING

				ptr += pngInterlaceIncrementsX[pngInterlacePass];
				ptrPos += pngInterlaceIncrementsX[pngInterlacePass];

				if (ptrPos == pngIHDR.pngWidth) {
					continue;
				}

				pngCurSample = png2BPP[pngCurComponent[0] & 0x3];

				ptr[0] = view.rgbTouint(pngCurSample, pngCurSample, pngCurSample);

				// INCREMENT WITH RESPECT TO INTERLACING

				ptr += pngInterlaceIncrementsX[pngInterlacePass];
				ptrPos += pngInterlaceIncrementsX[pngInterlacePass];

				continue;

			case PNG_STATE_RENDER_INTERLACED_STATE_BASE + PNG_GREYSCALE_4BPP:

				// GO BACK TO FILTER ANOTHER PIECE OF THE DATA

				decoderState = pngFilterState;

				// WE WILL ADD 2 PIXELS, IF WE CAN

				pngCurSample = png4BPP[pngCurComponent[0] >> 4];

				ptr[0] = view.rgbTouint(pngCurSample, pngCurSample, pngCurSample);

				// INCREMENT WITH RESPECT TO INTERLACING

				ptr += pngInterlaceIncrementsX[pngInterlacePass];
				ptrPos += pngInterlaceIncrementsX[pngInterlacePass];

				if (ptrPos == pngIHDR.pngWidth) {
					continue;
				}

				pngCurSample = png4BPP[pngCurComponent[0] & 0xF];

				ptr[0] = view.rgbTouint(pngCurSample, pngCurSample, pngCurSample);

				// INCREMENT WITH RESPECT TO INTERLACING

				ptr += pngInterlaceIncrementsX[pngInterlacePass];
				ptrPos += pngInterlaceIncrementsX[pngInterlacePass];

				continue;

			case PNG_STATE_RENDER_INTERLACED_STATE_BASE + PNG_GREYSCALE_8BPP:

				// GO BACK TO FILTER ANOTHER PIECE OF THE DATA

				decoderState = pngFilterState;

				// JUST ADD THE PIXEL

				ptr[0] = view.rgbTouint(pngCurComponent[0], pngCurComponent[0], pngCurComponent[0]);

				// INCREMENT WITH RESPECT TO INTERLACING

				ptr += pngInterlaceIncrementsX[pngInterlacePass];
				ptrPos += pngInterlaceIncrementsX[pngInterlacePass];

				continue;

			case PNG_STATE_RENDER_INTERLACED_STATE_BASE + PNG_GREYSCALE_16BPP:

				// GO BACK TO FILTER ANOTHER PIECE OF THE DATA

				decoderState = pngFilterState;

				// JUST OUTPUT THE PIXEL

				pngCurComponent[0] = cast(ubyte)(((cast(float)((pngCurComponent[0] << 8) | pngCurComponent[1]) / cast(float)0xFFFF) * cast(float)0xFF) + 0.5);

				ptr[0] = view.rgbTouint(pngCurComponent[0], pngCurComponent[0], pngCurComponent[0]);

				// INCREMENT WITH RESPECT TO INTERLACING

				ptr += pngInterlaceIncrementsX[pngInterlacePass];
				ptrPos += pngInterlaceIncrementsX[pngInterlacePass];

				continue;



			case PNG_STATE_RENDER_INTERLACED_STATE_BASE + PNG_TRUECOLOUR_8BPP:

				// GO BACK TO FILTER ANOTHER PIECE OF THE DATA

				decoderState = pngFilterState;

				// JUST OUTPUT THE PIXEL

				ptr[0] = view.rgbTouint(pngCurComponent[0], pngCurComponent[1], pngCurComponent[2]);

				// INCREMENT WITH RESPECT TO INTERLACING

				ptr += pngInterlaceIncrementsX[pngInterlacePass];
				ptrPos += pngInterlaceIncrementsX[pngInterlacePass];

				continue;

			case PNG_STATE_RENDER_INTERLACED_STATE_BASE + PNG_TRUECOLOUR_16BPP:

				// GO BACK TO FILTER ANOTHER PIECE OF THE DATA

				decoderState = pngFilterState;

				// JUST OUTPUT THE PIXEL

				pngCurComponent[0] = cast(ubyte)(((cast(float)((pngCurComponent[0] << 8) | pngCurComponent[1]) / cast(float)0xFFFF) * cast(float)0xFF) + 0.5);
				pngCurComponent[1] = cast(ubyte)(((cast(float)((pngCurComponent[2] << 8) | pngCurComponent[3]) / cast(float)0xFFFF) * cast(float)0xFF) + 0.5);
				pngCurComponent[2] = cast(ubyte)(((cast(float)((pngCurComponent[4] << 8) | pngCurComponent[5]) / cast(float)0xFFFF) * cast(float)0xFF) + 0.5);

				ptr[0] = view.rgbTouint(pngCurComponent[0], pngCurComponent[1], pngCurComponent[2]);

				// INCREMENT WITH RESPECT TO INTERLACING

				ptr += pngInterlaceIncrementsX[pngInterlacePass];
				ptrPos += pngInterlaceIncrementsX[pngInterlacePass];

				continue;

			case PNG_STATE_RENDER_INTERLACED_STATE_BASE + PNG_INDEXED_COLOUR_1BPP:

				// GO BACK TO FILTER ANOTHER PIECE OF THE DATA

				decoderState = pngFilterState;

				// WE WILL ADD 8 PIXELS, IF WE CAN

				pngCurSample = pngCurComponent[0] >> 7;

				if (pngCurSample >= pngPaletteCount) {
					pngCurSample = 0;
				}

				ptr[0] = pngPaletteRealized[pngCurSample];

				// INCREMENT WITH RESPECT TO INTERLACING

				ptr += pngInterlaceIncrementsX[pngInterlacePass];
				ptrPos += pngInterlaceIncrementsX[pngInterlacePass];

				if (ptrPos == pngIHDR.pngWidth) {
					continue;
				}

				pngCurSample = (pngCurComponent[0] >> 6) & 1;

				if (pngCurSample >= pngPaletteCount) {
					pngCurSample = 0;
				}

				ptr[0] = pngPaletteRealized[pngCurSample];

				// INCREMENT WITH RESPECT TO INTERLACING

				ptr += pngInterlaceIncrementsX[pngInterlacePass];
				ptrPos += pngInterlaceIncrementsX[pngInterlacePass];

				if (ptrPos == pngIHDR.pngWidth) {
					continue;
				}

				pngCurSample = (pngCurComponent[0] >> 5) & 1;

				if (pngCurSample >= pngPaletteCount) {
					pngCurSample = 0;
				}

				ptr[0] = pngPaletteRealized[pngCurSample];

				// INCREMENT WITH RESPECT TO INTERLACING

				ptr += pngInterlaceIncrementsX[pngInterlacePass];
				ptrPos += pngInterlaceIncrementsX[pngInterlacePass];

				if (ptrPos == pngIHDR.pngWidth) {
					continue;
				}

				pngCurSample = (pngCurComponent[0] >> 4) & 1;

				if (pngCurSample >= pngPaletteCount) {
					pngCurSample = 0;
				}

				ptr[0] = pngPaletteRealized[pngCurSample];

				// INCREMENT WITH RESPECT TO INTERLACING

				ptr += pngInterlaceIncrementsX[pngInterlacePass];
				ptrPos += pngInterlaceIncrementsX[pngInterlacePass];

				if (ptrPos == pngIHDR.pngWidth) {
					continue;
				}

				pngCurSample = (pngCurComponent[0] >> 3) & 1;

				if (pngCurSample >= pngPaletteCount) {
					pngCurSample = 0;
				}

				ptr[0] = pngPaletteRealized[pngCurSample];

				// INCREMENT WITH RESPECT TO INTERLACING

				ptr += pngInterlaceIncrementsX[pngInterlacePass];
				ptrPos += pngInterlaceIncrementsX[pngInterlacePass];

				if (ptrPos == pngIHDR.pngWidth) {
					continue;
				}

				pngCurSample = (pngCurComponent[0] >> 2) & 1;

				if (pngCurSample >= pngPaletteCount) {
					pngCurSample = 0;
				}

				ptr[0] = pngPaletteRealized[pngCurSample];

				// INCREMENT WITH RESPECT TO INTERLACING

				ptr += pngInterlaceIncrementsX[pngInterlacePass];
				ptrPos += pngInterlaceIncrementsX[pngInterlacePass];

				if (ptrPos == pngIHDR.pngWidth) {
					continue;
				}

				pngCurSample = (pngCurComponent[0] >> 1) & 1;

				if (pngCurSample >= pngPaletteCount) {
					pngCurSample = 0;
				}

				ptr[0] = pngPaletteRealized[pngCurSample];

				// INCREMENT WITH RESPECT TO INTERLACING

				ptr += pngInterlaceIncrementsX[pngInterlacePass];
				ptrPos += pngInterlaceIncrementsX[pngInterlacePass];

				if (ptrPos == pngIHDR.pngWidth) {
					continue;
				}

				pngCurSample = pngCurComponent[0] & 1;

				if (pngCurSample >= pngPaletteCount) {
					pngCurSample = 0;
				}

				ptr[0] = pngPaletteRealized[pngCurSample];

				// INCREMENT WITH RESPECT TO INTERLACING

				ptr += pngInterlaceIncrementsX[pngInterlacePass];
				ptrPos += pngInterlaceIncrementsX[pngInterlacePass];

				continue;

			case PNG_STATE_RENDER_INTERLACED_STATE_BASE + PNG_INDEXED_COLOUR_2BPP:

				// GO BACK TO FILTER ANOTHER PIECE OF THE DATA

				decoderState = pngFilterState;

				// WE WILL ADD 4 PIXELS, IF WE CAN

				pngCurSample = pngCurComponent[0] >> 6;

				if (pngCurSample >= pngPaletteCount) {
					pngCurSample = 0;
				}

				ptr[0] = pngPaletteRealized[pngCurSample];

				// INCREMENT WITH RESPECT TO INTERLACING

				ptr += pngInterlaceIncrementsX[pngInterlacePass];
				ptrPos += pngInterlaceIncrementsX[pngInterlacePass];

				if (ptrPos == pngIHDR.pngWidth) {
					continue;
				}

				pngCurSample = (pngCurComponent[0] >> 4) & 0x3;

				if (pngCurSample >= pngPaletteCount) {
					pngCurSample = 0;
				}

				ptr[0] = pngPaletteRealized[pngCurSample];

				// INCREMENT WITH RESPECT TO INTERLACING

				ptr += pngInterlaceIncrementsX[pngInterlacePass];
				ptrPos += pngInterlaceIncrementsX[pngInterlacePass];

				if (ptrPos == pngIHDR.pngWidth) {
					continue;
				}

				pngCurSample = (pngCurComponent[0] >> 2) & 0x3;

				if (pngCurSample >= pngPaletteCount) {
					pngCurSample = 0;
				}

				ptr[0] = pngPaletteRealized[pngCurSample];

				// INCREMENT WITH RESPECT TO INTERLACING

				ptr += pngInterlaceIncrementsX[pngInterlacePass];
				ptrPos += pngInterlaceIncrementsX[pngInterlacePass];

				if (ptrPos == pngIHDR.pngWidth) {
					continue;
				}

				pngCurSample = pngCurComponent[0] & 0x3;

				if (pngCurSample >= pngPaletteCount) {
					pngCurSample = 0;
				}

				ptr[0] = pngPaletteRealized[pngCurSample];

				// INCREMENT WITH RESPECT TO INTERLACING

				ptr += pngInterlaceIncrementsX[pngInterlacePass];
				ptrPos += pngInterlaceIncrementsX[pngInterlacePass];

				continue;

			case PNG_STATE_RENDER_INTERLACED_STATE_BASE + PNG_INDEXED_COLOUR_4BPP:

				// GO BACK TO FILTER ANOTHER PIECE OF THE DATA

				decoderState = pngFilterState;

				// WE WILL ADD 2 PIXELS, IF WE CAN

				pngCurSample = pngCurComponent[0] >> 4;

				if (pngCurSample >= pngPaletteCount) {
					pngCurSample = 0;
				}

				ptr[0] = pngPaletteRealized[pngCurSample];

				// INCREMENT WITH RESPECT TO INTERLACING

				ptr += pngInterlaceIncrementsX[pngInterlacePass];
				ptrPos += pngInterlaceIncrementsX[pngInterlacePass];

				if (ptrPos == pngIHDR.pngWidth) {
					continue;
				}

				pngCurSample = pngCurComponent[0] & 0xF;

				if (pngCurSample >= pngPaletteCount) {
					pngCurSample = 0;
				}

				ptr[0] = pngPaletteRealized[pngCurSample];

				// INCREMENT WITH RESPECT TO INTERLACING

				ptr += pngInterlaceIncrementsX[pngInterlacePass];
				ptrPos += pngInterlaceIncrementsX[pngInterlacePass];

				continue;

			case PNG_STATE_RENDER_INTERLACED_STATE_BASE + PNG_INDEXED_COLOUR_8BPP:

				// GO BACK TO FILTER ANOTHER PIECE OF THE DATA

				decoderState = pngFilterState;

				if (pngCurComponent[0] >= pngPaletteCount) {
					pngCurComponent[0] = 0;
				}

				ptr[0] = pngPaletteRealized[pngCurComponent[0]];

				// INCREMENT WITH RESPECT TO INTERLACING

				ptr += pngInterlaceIncrementsX[pngInterlacePass];
				ptrPos += pngInterlaceIncrementsX[pngInterlacePass];

				continue;



			case PNG_STATE_RENDER_INTERLACED_STATE_BASE + PNG_GREYSCALE_ALPHA_8BPP:

				// GO BACK TO FILTER ANOTHER PIECE OF THE DATA

				decoderState = pngFilterState;

				// JUST ADD THE PIXEL

				// PRE MULTIPLY ALPHA WITH R, G, B
				a = cast(float)pngCurComponent[1];
				a /= cast(float)0xFF;

				a *= pngCurComponent[0];

				pngCurComponent[0] = cast(ubyte)a;
				pngCurComponent[0] %= 256;

				ptr[0] = (pngCurComponent[0]) | (pngCurComponent[0] << 8) | (pngCurComponent[0] << 16) | (pngCurComponent[1] << 24);

				// INCREMENT WITH RESPECT TO INTERLACING

				ptr += pngInterlaceIncrementsX[pngInterlacePass];
				ptrPos += pngInterlaceIncrementsX[pngInterlacePass];

				continue;

			case PNG_STATE_RENDER_INTERLACED_STATE_BASE + PNG_GREYSCALE_ALPHA_16BPP:

				// GO BACK TO FILTER ANOTHER PIECE OF THE DATA

				decoderState = pngFilterState;

				pngCurComponent[0] = cast(ubyte)(((cast(float)((pngCurComponent[0] << 8) | pngCurComponent[1]) / cast(float)0xFFFF) * cast(float)0xFF) + 0.5);
				pngCurComponent[1] = cast(ubyte)(((cast(float)((pngCurComponent[2] << 8) | pngCurComponent[3]) / cast(float)0xFFFF) * cast(float)0xFF) + 0.5);

				// JUST ADD THE PIXEL

				// PRE MULTIPLY ALPHA WITH R, G, B
				a = cast(float)pngCurComponent[1];
				a /= cast(float)0xFF;

				a *= pngCurComponent[0];

				pngCurComponent[0] = cast(ubyte)a;
				pngCurComponent[0] %= 256;

				ptr[0] = view.rgbaTouint(pngCurComponent[0], pngCurComponent[0], pngCurComponent[0], pngCurComponent[1]);

				// INCREMENT WITH RESPECT TO INTERLACING

				ptr += pngInterlaceIncrementsX[pngInterlacePass];
				ptrPos += pngInterlaceIncrementsX[pngInterlacePass];

				continue;



			case PNG_STATE_RENDER_INTERLACED_STATE_BASE + PNG_TRUECOLOUR_ALPHA_8BPP:

				// GO BACK TO FILTER ANOTHER PIECE OF THE DATA

				decoderState = pngFilterState;

				// PRE MULTIPLY ALPHA WITH R, G, B
				a = cast(float)pngCurComponent[3];
				a /= cast(float)0xFF;

				pngCurComponent[0] = cast(ubyte)(a * cast(float)pngCurComponent[0]);
				pngCurComponent[1] = cast(ubyte)(a * cast(float)pngCurComponent[1]);
				pngCurComponent[2] = cast(ubyte)(a * cast(float)pngCurComponent[2]);

				ptr[0] = view.rgbaTouint(pngCurComponent[0], pngCurComponent[0], pngCurComponent[0], pngCurComponent[1]);

				// INCREMENT WITH RESPECT TO INTERLACING

				ptr += pngInterlaceIncrementsX[pngInterlacePass];
				ptrPos += pngInterlaceIncrementsX[pngInterlacePass];

				continue;

			case PNG_STATE_RENDER_INTERLACED_STATE_BASE + PNG_TRUECOLOUR_ALPHA_16BPP:

				// GO BACK TO FILTER ANOTHER PIECE OF THE DATA

				decoderState = pngFilterState;

				// combine the components and place them in 0, 1, 2, and 3 only
				// that is, truncate every two bytes into 4 bytes

				pngCurComponent[0] = cast(ubyte)(((cast(float)((pngCurComponent[0] << 8) | pngCurComponent[1]) / cast(float)0xFFFF) * cast(float)0xFF) + 0.5);
				pngCurComponent[1] = cast(ubyte)(((cast(float)((pngCurComponent[2] << 8) | pngCurComponent[3]) / cast(float)0xFFFF) * cast(float)0xFF) + 0.5);
				pngCurComponent[2] = cast(ubyte)(((cast(float)((pngCurComponent[4] << 8) | pngCurComponent[5]) / cast(float)0xFFFF) * cast(float)0xFF) + 0.5);
				pngCurComponent[3] = cast(ubyte)(((cast(float)((pngCurComponent[6] << 8) | pngCurComponent[7]) / cast(float)0xFFFF) * cast(float)0xFF) + 0.5);

				//view.unlockBuffer();
				//return StreamData.Complete;

				// PRE MULTIPLY ALPHA WITH R, G, B

				ptr[0] = view.rgbaTouint(pngCurComponent[0], pngCurComponent[1], pngCurComponent[2], pngCurComponent[3]);

				/*a = pngCurComponent[3];
				a /= (float)0xFF;

				pngCurComponent[0] = (ubyte)(a * (float)pngCurComponent[0]);
				pngCurComponent[1] = (ubyte)(a * (float)pngCurComponent[1]);
				pngCurComponent[2] = (ubyte)(a * (float)pngCurComponent[2]);

				ptr[0] = (pngCurComponent[2]) | (pngCurComponent[1] << 8) | (pngCurComponent[0] << 16) | (pngCurComponent[3] << 24);*/

				// INCREMENT WITH RESPECT TO INTERLACING

				ptr += pngInterlaceIncrementsX[pngInterlacePass];
				ptrPos += pngInterlaceIncrementsX[pngInterlacePass];

				continue;

				// DECODE //

			case PNG_STATE_INTERPRET_IDAT:

				continue;

				// FINISH //

			case PNG_STATE_DONE_IDAT:

				decoderState = PNG_STATE_READ_CHUNK_CRC;
				continue;

			default:
				break;
			}
			break;
		}
		return StreamData.Invalid;
	}
}


