/*
 * gif.d
 *
 * This module implements the GIF 89a standard.
 *
 * Author: Dave Wilkinson
 *
 */

module decoders.image.gif;

import graphics.bitmap;

import core.string;
import core.stream;

import decoders.image.decoder;
import decoders.decoder;

// For debugging
import io.console;

// The structures define structures found in the standard and utilized
// when reading the file or stream.
private {
	align(1) struct _djehuty_image_gif_header {
		ubyte gifSignature[3];
		ubyte gifVersion[3];
	}

	align(1) struct _djehuty_image_gif_logical_screen {
		ushort gifLogicalScreenWidth;
		ushort gifLogicalScreenHeight;
		ubyte gifPackedFields;
		ubyte gifBackgroundColorIndex;
		ubyte gifPixelAspectRatio;
	}

	align(1) struct _djehuty_image_gif_color {
		ubyte red;
		ubyte green;
		ubyte blue;
	}

	align(1) struct _djehuty_image_gif_image_descriptor {
		ushort gifImageLeftPos;
		ushort gifImageTopPos;
		ushort gifImageWidth;
		ushort gifImageHeight;
		ubyte gifPackedFields;
	}

	align(1) struct _djehuty_image_gif_graphics_extension {
		ubyte gifBlockSize;

		ubyte gifPackedFields;
		ushort gifDelayTime;
		ubyte gifTransparentColorIndex;

		ubyte gifBlockTerminator;
	}

	struct _djehuty_image_gif_lzw_dictionary_entry {
		short code;
		short hops;
		short output;
	}

	const ubyte gifMasks[] =
	[

	/* STARTBYTE, INTERMEDIATE BYTE, LAST BYTE */
	/* 8 STEPS PER BIT COUNT */

	 /* 2 masks */
	0x3, 0x0, 0x0, 0x6, 0x0, 0x0, 0xC, 0x0, 0x0, 0x18, 0x0, 0x0, 0x30, 0x0, 0x0, 0x60, 0x0, 0x0, 0xC0, 0x0, 0x0, 0x80, 0x1, 0x0,
	 /* 3 masks */
	0x7, 0x0, 0x0, 0xE, 0x0, 0x0, 0x1C, 0x0, 0x0, 0x38, 0x0, 0x0, 0x70, 0x0, 0x0, 0xE0, 0x0, 0x0, 0xC0, 0x1, 0x0, 0x80, 0x3, 0x0,
	 /* 4 masks */
	0xF, 0x0, 0x0, 0x1E, 0x0, 0x0, 0x3C, 0x0, 0x0, 0x78, 0x0, 0x0, 0xF0, 0x0, 0x0, 0xE0, 0x1, 0x0, 0xC0, 0x3, 0x0, 0x80, 0x7, 0x0,
	 /* 5 masks */
	0x1F, 0x0, 0x0, 0x3E, 0x0, 0x0, 0x7C, 0x0, 0x0, 0xF8, 0x0, 0x0, 0xF0, 0x1, 0x0, 0xE0, 0x3, 0x0, 0xC0, 0x7, 0x0, 0x80, 0xF, 0x0,
	 /* 6 masks */
	0x3F, 0x0, 0x0, 0x7E, 0x0, 0x0, 0xFC, 0x0, 0x0, 0xF8, 0x1, 0x0, 0xF0, 0x3, 0x0, 0xE0, 0x7, 0x0, 0xC0, 0xF, 0x0, 0x80, 0x1F, 0x0,
	 /* 7 masks */
	0x7F, 0x0, 0x0, 0xFE, 0x0, 0x0, 0xFC, 0x1, 0x0, 0xF8, 0x3, 0x0, 0xF0, 0x7, 0x0, 0xE0, 0xF, 0x0, 0xC0, 0x1F, 0x0, 0x80, 0x3F, 0x0,
	 /* 8 masks */
	0xFF, 0x0, 0x0, 0xFE, 0x1, 0x0, 0xFC, 0x3, 0x0, 0xF8, 0x7, 0x0, 0xF0, 0xF, 0x0, 0xE0, 0x1F, 0x0, 0xC0, 0x3F, 0x0, 0x80, 0x7F, 0x0,
	 /* 9 masks */
	0xFF, 0x1, 0x0, 0xFE, 0x3, 0x0, 0xFC, 0x7, 0x0, 0xF8, 0xF, 0x0, 0xF0, 0x1F, 0x0, 0xE0, 0x3F, 0x0, 0xC0, 0x7F, 0x0, 0x80, 0xFF, 0x0,
	 /* 10 masks */
	0xFF, 0x3, 0x0, 0xFE, 0x7, 0x0, 0xFC, 0xF, 0x0, 0xF8, 0x1F, 0x0, 0xF0, 0x3F, 0x0, 0xE0, 0x7F, 0x0, 0xC0, 0xFF, 0x0, 0x80, 0xFF, 0x1,
	 /* 11 masks */
	0xFF, 0x7, 0x0, 0xFE, 0xF, 0x0, 0xFC, 0x1F, 0x0, 0xF8, 0x3F, 0x0, 0xF0, 0x7F, 0x0, 0xE0, 0xFF, 0x0, 0xC0, 0xFF, 0x1, 0x80, 0xFF, 0x3,
	 /* 12 masks */
	0xFF, 0xF, 0x0, 0xFE, 0x1F, 0x0, 0xFC, 0x3F, 0x0, 0xF8, 0x7F, 0x0, 0xF0, 0xFF, 0x0, 0xE0, 0xFF, 0x1, 0xC0, 0xFF, 0x3, 0x80, 0xFF, 0x7

	];

	//global constants
	const int _djehuty_image_gif_size_of_global_color_table_ref[] = [2,4,8,16,32,64,128,256];

	// Decoder States
	const auto GIF_STATE_INIT						= 0;

	const auto GIF_STATE_READ_HEADERS				= 1;
	const auto GIF_STATE_READ_GRAPHIC_CONTROL		= 2;

	const auto GIF_STATE_DECODE_IMAGE				= 3;
	const auto GIF_STATE_READ_LOCAL_COLOR_TABLE		= 4;

	const auto GIF_STATE_INIT_DECODER				= 5;
	const auto GIF_STATE_READ_LZW_CODESIZE			= 6;

	const auto GIF_STATE_DECODE						= 7;
}

// Description: The GIF Codec
class GIFDecoder : ImageDecoder {
	override String name() {
		return new String("Graphics Interchange Format");
	}

	StreamData decode(Stream stream, ref Bitmap view) {
		ImageFrameDescription imageDesc;
		bool hasMultipleFrames;

		// will read headers and such

		StreamData ret = StreamData.Accepted;

		while (ret == StreamData.Accepted) {

			ret = Decoder(stream, view, imageDesc);

			if (ret == StreamData.Accepted) {
				// the image frame will be next
				if (!gifIsFirst) {
					// stop, since we got what we needed
					// which is the first frame

					// but this signals that we have more than one frame
					hasMultipleFrames = 1;
					return StreamData.Complete;
				}
				else {
					gifIsFirst = 0;
				}
			}
		}

		hasMultipleFrames = 0;
		return ret;
	}

	StreamData DecodeFrame(Stream stream, ref Bitmap view) {
		ImageFrameDescription imageDesc;
		bool hasMultipleFrames;

		// will read headers and such

		int ret;

		ret = Decoder(stream, view, imageDesc);

		if (ret == 2) {
			// another frame will occur
			return StreamData.Accepted;
		}
		else if (ret == 1) {
			// we are done
			imageDesc.clearFirst = gifFirstClear;
			imageDesc.clearColor = gifFirstClearColor;
			imageDesc.time = gifFirstTime;

			return StreamData.Complete;
		}

		return StreamData.Required;
	}

	StreamData Decoder(ref Stream stream, ref Bitmap view, ref ImageFrameDescription imageDesc) {
		uint q;

		ushort gifCode;
		ushort gifCodeTemp;

		ulong ptr_len;

		for (;;) {
			// READ HEADERS
			switch(decoderState) {

				// READ HEADERS //

			case GIF_STATE_INIT:

				gifGraphicControl.gifBlockSize = 0;

				gifIsFirst = 1;

				decoderSubState = 0;
				decoderState = GIF_STATE_READ_HEADERS;

			case GIF_STATE_READ_HEADERS:
				// READ FILE HEADER

				switch(decoderSubState) {

				// READ GIF HEADER
				case 0:

					if (!stream.read(&gifHeader, _djehuty_image_gif_header.sizeof)) {
						return StreamData.Required;
					}

					if (!(gifHeader.gifSignature[0] == 'G' &&
						gifHeader.gifSignature[1] == 'I' &&
						gifHeader.gifSignature[2] == 'F')) {
						return StreamData.Invalid;
					}

					if (!(gifHeader.gifVersion[0] == '8' &&
						gifHeader.gifVersion[1] == '9' &&
						gifHeader.gifVersion[2] == 'a')) {
						return StreamData.Invalid;
					}

					gifVersion = 1; // 89a

					decoderSubState = 1;

				// READ LOGICAL SCREEN DESCRIPTOR
				case 1:

					if(!(stream.read(&gifScreen, _djehuty_image_gif_logical_screen.sizeof))) {
						return StreamData.Required;
					}

					// DETERMINE WHETHER OR NOT WE GET A GLOBAL COLOR TABLE
					if (gifScreen.gifPackedFields & 128) {
						// global color table present

						gifGlobalColorTableSize = _djehuty_image_gif_size_of_global_color_table_ref[ gifScreen.gifPackedFields & 0x7 ];

						decoderSubState = 2;
					}
					else {
						// global color table not present

						gifGlobalColorTableSize = 0;

						decoderSubState = 0;

						gifGraphicControl.gifBlockSize = 0;

						decoderState = GIF_STATE_READ_GRAPHIC_CONTROL;

						break;
					}

				// READ IN GLOBAL COLOR TABLE WHEN PRESENT
				case 2:
					//Global Color Table is present; load it
					if(!(stream.read(gifGlobalColorTable.ptr, 3 * gifGlobalColorTableSize))) {
						return StreamData.Required;
					}

					// Compute a 32bit argb color
					for (q=0; q<gifGlobalColorTableSize; q++) {
						gifGlobalColorTableComputed[q] = 0xFF000000 | (gifGlobalColorTable[q].red << 16) | ((gifGlobalColorTable[q].green << 8) | (gifGlobalColorTable[q].blue));
					}

					gifGlobalColorTableSize = 0;

					decoderSubState = 0;

					gifGraphicControl.gifBlockSize = 0;

					decoderState = GIF_STATE_READ_GRAPHIC_CONTROL;

					break;

				default: break;
				}

				continue;

			// READS IN ALL EXTENSIONS
			case GIF_STATE_READ_GRAPHIC_CONTROL:

				switch(decoderSubState) {
				//READ EXTENSION INTRODUCER
				case 0:
					if(!(stream.read(&gifExtensionIntroducer, 1))) {
						return StreamData.Required;
					}

					if (gifExtensionIntroducer == 0x3B) {
						// no more blocks
						return StreamData.Complete;
					}
					else if (gifExtensionIntroducer == 0x21) {
						//this is an extension
						decoderSubState = 1;
					}
					else if (gifExtensionIntroducer == 0x2C) {
						// the image is next
						decoderState = GIF_STATE_DECODE_IMAGE;

						if (gifGraphicControl.gifBlockSize == 4) {
							if (gifIsFirst) {

								gifFirstTime = (gifGraphicControl.gifDelayTime * 10);

								if ((gifGraphicControl.gifPackedFields & 0x1C) == 0x08) {
									gifFirstClear = 1;
								}
								else {
									gifFirstClear = 0;
								}

								if (gifScreen.gifBackgroundColorIndex >= gifGlobalColorTableSize) {
									gifFirstClearColor = 0;
								}
								else {
									// if TRANSPARENT is set, clear color is transparent
									if ((gifGraphicControl.gifBlockSize == 4) && (gifGraphicControl.gifPackedFields & 1) ) {
										gifFirstClearColor = 0;
									}
									else {
										gifFirstClearColor = gifGlobalColorTableComputed[gifScreen.gifBackgroundColorIndex];
									}
								}
							}
							else {
								imageDesc.time = (gifGraphicControl.gifDelayTime * 10);

								if ((gifGraphicControl.gifPackedFields & 0x1C) == 0x08) {
									imageDesc.clearFirst = 1;
								}
								else {
									imageDesc.clearFirst = 0;
								}

								if (gifScreen.gifBackgroundColorIndex >= gifGlobalColorTableSize) {
									imageDesc.clearColor = 0;
								}
								else {
									// iF TRANSPARENT is set, clear color is transparent
									if ((gifGraphicControl.gifBlockSize == 4) && (gifGraphicControl.gifPackedFields & 1) ) {
										imageDesc.clearColor = 0;
									}
									else {
										imageDesc.clearColor = gifGlobalColorTableComputed[gifScreen.gifBackgroundColorIndex];
									}
								}
							}
						}
						else {
							if (gifIsFirst) {
								gifFirstClear = 0;
							}
							else {
								imageDesc.clearFirst = 0;
							}
						}

						// image data is next, there is another frame
						return StreamData.Accepted; // indicate frame is next
					}

					break;

				//READ EXTENSION LABEL
				case 1:

					//otherwise, it is the table's lzw minimum code size
					if(!(stream.read(&gifExtensionLabel, 1))) {
						return StreamData.Required;
					}

					if (gifExtensionLabel == 0xF9) {
						// IS A GRAPHIC CONTROL EXTENSION
						decoderSubState = 2;
					}
					else {
						// READ THE BLOCK SIZE
						// SKIP THAT MANY BYTES
						decoderSubState = 3;
					}
					break;

				//READ IN GRAPHIC CONTROL EXTENSION
				case 2:

					if(!(stream.read(&gifGraphicControl, _djehuty_image_gif_graphics_extension.sizeof))) {
						return StreamData.Required;
					}

					// IT SHOULD BE 4, BUT WE WILL SET IT AS SUCH ANYWAY
					// THIS WILL BE OUR CHECK FOR WHEN THE STRUCTURE IS FILLED
					gifGraphicControl.gifBlockSize = 4;

					decoderSubState = 0;

					break;


				//SKIP IRREVALVENT EXTENSION DATA

				//FIND EXTENSION SIZE
				case 3:
					if (!(stream.read(&gifExtensionLabel, 1))) {
						return StreamData.Required;
					}

					decoderSubState = 4;

				//SKIP EXTENSION LABEL
				case 4:
					if(!(stream.skip(gifExtensionLabel))) {
						return StreamData.Required;
					}

					decoderSubState = 5;

				//SKIP EXTENSION DATA BLOCKS
				//READ IN SIZE OF DATA BLOCK
				case 5:
					// NOW READ IN ALL SUB-DATA BLOCKS
					// AND SKIP THEM
					if (!(stream.read(&gifExtensionLabel, 1))) {
						return StreamData.Required;
					}

					decoderSubState = 6;

				case 6:

					if (gifExtensionLabel > 0) {
						stream.skip(gifExtensionLabel);
						decoderSubState = 5;
					}
					else {
						decoderSubState = 0;
					}

				default: break;
				}

				continue;

			// READ IN IMAGE DESCRIPTOR
			case GIF_STATE_DECODE_IMAGE:
				//DecodeImage(stream, view, imageDesc, idp);
				//return StreamData.Required;

				// READ IN IMAGE DESCRIPTOR

				if(!(stream.read(&gifImage, _djehuty_image_gif_image_descriptor.sizeof))) {
					return StreamData.Required;
				}

				if (gifImage.gifPackedFields & 128) {
					// local color table present

					gifLocalColorTableSize = _djehuty_image_gif_size_of_global_color_table_ref[ gifImage.gifPackedFields & 0x7 ];
					decoderState = GIF_STATE_READ_LOCAL_COLOR_TABLE;

					// ... note we will drop through ... //
				}
				else {
					decoderState = GIF_STATE_INIT_DECODER;

					// local color table is not present

					gifLocalColorTableSize = 0;
					gifCurColorTable = gifGlobalColorTableComputed.ptr;

					continue;
				}

				// ... drop through WHEN there is a local color table ... //

			// READ IN LOCAL COLOR TABLE WHEN PRESENT
			case GIF_STATE_READ_LOCAL_COLOR_TABLE:
				//local Color Table is present

				if(!(stream.read(gifLocalColorTable.ptr, 3 * gifLocalColorTableSize))) {
					return StreamData.Required;
				}

				//compute values
				uint i;

				for (i=0; i<gifLocalColorTableSize; i++) {
					gifLocalColorTableComputed[i] = 0xFF000000 | (gifLocalColorTable[i].red << 16) | ((gifLocalColorTable[i].green << 8) | (gifLocalColorTable[i].blue));
				}

				gifCurColorTable = gifLocalColorTableComputed.ptr;

				decoderState = GIF_STATE_INIT_DECODER;

			case GIF_STATE_INIT_DECODER:
				// UPDATE Transparent Color INDEX IN THE COLOR TABLE (if present)
				if ((gifGraphicControl.gifBlockSize == 4) && (gifGraphicControl.gifPackedFields & 1)) {
					gifCurColorTable[gifGraphicControl.gifTransparentColorIndex] = 0;
				}

				// UPDATE FRAME DESCRIPTION
				imageDesc.xoffset = gifImage.gifImageLeftPos;
				imageDesc.yoffset = gifImage.gifImageTopPos;

				// CHECK TO SEE IF IMAGE IS INTERLACED
				gifIsInterlaced = (gifImage.gifPackedFields & 64);

				decoderState = GIF_STATE_READ_LZW_CODESIZE;

			case GIF_STATE_READ_LZW_CODESIZE:

				// READ IN THE LZW MINIMUM CODE SIZE

				if (!(stream.read(&gifExtensionIntroducer, 1))) {
					return StreamData.Required;
				}

				if (gifExtensionIntroducer < 2)
				{
					// incorrect lzw min size
					return StreamData.Invalid;
				}

				// we start from code size + 1 when reading in data
				// so we increment the code size
				gifExtensionIntroducer++;

				// set the default dictionary size
				gifDictionarySize = _djehuty_image_gif_size_of_global_color_table_ref[gifExtensionIntroducer-2];

				// BUILD INITIAL LZW DICTIONARY

				//i will iterate through the dictionary
				for (short i=0; i<gifDictionarySize+2; i++)
				{
					gifDictionary[i].code = 0;
					gifDictionary[i].hops = 0;
					gifDictionary[i].output = i;
				}

				gifClearCode = cast(ushort)gifDictionarySize;
				gifEOICode = cast(ushort)(gifDictionarySize + 1);

				// N WILL BE THE NEXT CODE
				lzw_nextEntry = cast(ushort)(gifClearCode + 2);

				// bound the next entry to gifDictionarySize * 2
				gifDictionarySize *= 2;

				gifCodeSize = gifExtensionIntroducer;
				gifStartCodeSize = gifCodeSize;

				// ESTABLISH MASKS
				gifCurMaskArray = cast(ubyte*)&gifMasks[(gifCodeSize - 2) * 24];
				gifCurMaskIndex = 0;
				gifCurMaskIndexComp = 0;

				gifMaskStart = gifCurMaskArray[0];
				gifMaskIntermediate = gifCurMaskArray[1];
				gifMaskEnd = gifCurMaskArray[2];

				lzw_isFirstEntry = 0;

				gifInterlaceState = 0; //the state of the interlacing

				ptrPos = 0;
				ptrLine = 0;

				gifBlockSize = 0;
				gifBlockCounter = 0;

				view.create(gifImage.gifImageWidth, gifImage.gifImageHeight);

				decoderState = GIF_STATE_DECODE;
				decoderSubState = 0;

				// ... drop through ... //

			case GIF_STATE_DECODE:
				// start decoding

				view.lockBuffer(cast(void**)&ptr_start, ptr_len);

				ptr = ptr_start;

				ptr += (gifImage.gifImageWidth * ptrLine);
				ptr_max_line = ptr + gifImage.gifImageWidth;

				ptr_max_page = ptr_start + (ptr_len / 4);

				ptr += ptrPos;

				while(decoderState == GIF_STATE_DECODE) {

					switch(decoderSubState) {

					//READ IN BLOCK SIZE
					case 0:

						gifLastBlockSize = gifBlockSize;
						gifBlockSize=0;

						decoderSubState = 1;

					case 1:

						if (!(stream.read(&gifBlockSize, 1))) {
							view.unlockBuffer();
							return StreamData.Required;
						}

						if (gifBlockSize == 0) {
							// block terminator found (end of blocks)

							// PERHAPS THERE WILL BE ANOTHER FRAME
							decoderState = GIF_STATE_READ_GRAPHIC_CONTROL;
							decoderSubState = 0;

							view.unlockBuffer();

							break;
						}
						else
						{
							decoderSubState = 2;

							// ... drop through ... //
						}

					// READ IN IMAGE DATA BLOCK
					// APPEND, IF NEEDED, TO OLD BLOCK
					case 2:

						// decode this image block

						if ((gifBlockCounter==gifLastBlockSize-1)) {
							gifImageData[0] = gifImageData[gifBlockCounter];
							if(!(stream.read(&gifImageData[1], gifBlockSize))) {
								view.unlockBuffer();
								return StreamData.Required;
							}
							gifBlockSize++;
						}
						else if ((gifBlockCounter==gifLastBlockSize-2)) {
							gifImageData[0] = gifImageData[gifBlockCounter];
							gifImageData[1] = gifImageData[gifBlockCounter+1];
							if (!(stream.read(&gifImageData[2], gifBlockSize))) {
								view.unlockBuffer();
								return StreamData.Required;
							}
							gifBlockSize+=2;
						}
						else {
							if (!(stream.read(gifImageData.ptr, gifBlockSize))) {
								view.unlockBuffer();
								return StreamData.Required;
							}
						}

						gifBlockCounter = 0;

						gifCode = 0;
						gifCodeTemp = 0;

						//get a code
						decoderSubState = 3;

						if (gifIsInterlaced) {
							decoderNextSubState = 5;
						}
						else {
							//DECODER FOR NON INTERLACED IMAGES
							decoderNextSubState = 4;
						}


					// READ IN CODE
					case 3:

						// get next code
						uint old_blockcounter = gifBlockCounter;

						gifCode = cast(ushort)(gifImageData[gifBlockCounter] & gifMaskStart);

						// reading in a code

						if (gifCurMaskIndex) {
							gifCode >>= gifCurMaskIndex;
						}

						if (gifMaskIntermediate) {
							// go to next byte
							gifBlockCounter++;
							if (gifBlockCounter>=gifBlockSize) {
								gifBlockCounter = old_blockcounter;

								decoderSubState = 0;
								break;
							}

							gifCodeTemp = cast(ushort)(gifImageData[gifBlockCounter] & gifMaskIntermediate);

							if (8 - gifCurMaskIndex) {
								gifCodeTemp <<= (8 - gifCurMaskIndex);
							}

							gifCode |= gifCodeTemp;
						}
						else {
							//goto next byte when gifMaskStart's first bit is 1
							if (gifMaskStart & 128) {
								//goto next byte
								gifBlockCounter++;
								if (gifBlockCounter>=gifBlockSize) {
									gifBlockCounter=old_blockcounter;

									decoderSubState = 0;
									break;
								}
							}
						}

						if (gifMaskEnd) {
							// go to ultimate byte
							gifBlockCounter++;
							if (gifBlockCounter>=gifBlockSize) {
								gifBlockCounter=old_blockcounter;

								decoderSubState = 0;
								break;
							}

							gifCodeTemp = cast(ushort)(gifImageData[gifBlockCounter] & gifMaskEnd);

							if (8-gifCurMaskIndex) {
								gifCodeTemp <<= (8-gifCurMaskIndex);
							}

							gifCodeTemp <<= 8;

							gifCode |= gifCodeTemp;
						}
						else {
							//goto next byte when gifMaskIntermediate's first bit is 1
							if (gifMaskIntermediate & 128) {
								//goto next byte
								gifBlockCounter++;
								if (gifBlockCounter>=gifBlockSize) {
									gifBlockCounter=old_blockcounter;

									decoderSubState = 0;
									break;
								}
							}
						}

						// set next mask index
						gifCurMaskIndex = (gifCurMaskIndex + gifCodeSize) % 8;
						gifCurMaskIndexComp = gifCurMaskIndex * 3;

						gifMaskStart = gifCurMaskArray[gifCurMaskIndexComp];
						gifMaskIntermediate = gifCurMaskArray[gifCurMaskIndexComp+1];
						gifMaskEnd = gifCurMaskArray[gifCurMaskIndexComp+2];

						// GOTO LZW DECODER
						decoderSubState = decoderNextSubState;

						break;

					// DECODER (non-interlaced)
					case 4:

						decoderSubState = 3;

						// THIS IS THE LZW DECOMPRESSOR FOR UNINTERLACED IMAGES

						// INTERPRET gifCode

						if (gifCode == gifEOICode) {
							// stop decoding (End Of Image)

							decoderNextState = 0;

							break;
						}

						if (lzw_isFirstEntry==0) {
							//init LZW decompressor	(first entry)

							lzw_isFirstEntry=1;

							lzw_curEntry = gifCode;

							// INTERPRET CODE AS PIXEL

							if (gifCode < gifClearCode) {
								ptr[0] = gifCurColorTable[gifCode];

								ptr++;
								ptrPos++;

								// READ CODE
								break;
							}
						}

						if (gifCode == gifClearCode) {
							//CLEAR CODE (reset dictionary)
							lzw_nextEntry = cast(ushort)(gifClearCode + 2);

							gifDictionarySize = gifClearCode * 2;

							gifCodeSize = gifStartCodeSize;

							//update mask array
							gifCurMaskArray = cast(ubyte*)&gifMasks[(gifCodeSize - 2) * 24];

							gifMaskStart = gifCurMaskArray[gifCurMaskIndexComp];
							gifMaskIntermediate = gifCurMaskArray[gifCurMaskIndexComp+1];
							gifMaskEnd = gifCurMaskArray[gifCurMaskIndexComp+2];

							lzw_isFirstEntry = 0;

							// READ CODE
							break;
						}

						if (gifCode >= lzw_nextEntry) {
							// PRINT OUT LAST CODE FROM DICTIONARY
							gifCodeTemp = lzw_curEntry;
							q = gifDictionary[gifCodeTemp].hops;

							for (;;) {
								ptr[q] = gifCurColorTable[gifDictionary[gifCodeTemp].output];

								if (gifCodeTemp < gifClearCode) { break; }

								gifCodeTemp = cast(ushort)gifDictionary[gifCodeTemp].code;
								q--;
							}
							ptr += gifDictionary[lzw_curEntry].hops + 1;

							ptr[0] = gifCurColorTable[gifDictionary[gifCodeTemp].output];
							ptr++;

							ptrPos += gifDictionary[lzw_curEntry].hops + 2;
						}
						else {
							// print code from dictionary
							gifCodeTemp = gifCode;
							q = gifDictionary[gifCodeTemp].hops;

							for (;;) {
								ptr[q] = gifCurColorTable[gifDictionary[gifCodeTemp].output];

								if (gifCodeTemp < gifClearCode) { break; }

								gifCodeTemp = cast(ushort)gifDictionary[gifCodeTemp].code;
								q--;
							}

							ptr += gifDictionary[gifCode].hops+1;
							ptrPos += gifDictionary[gifCode].hops+1;
						}

						if (lzw_nextEntry < 4096) {
							// add this entry to the dictionary
							gifDictionary[lzw_nextEntry].code = cast(short)lzw_curEntry;
							gifDictionary[lzw_nextEntry].output = cast(short)gifDictionary[gifCodeTemp].output;
							gifDictionary[lzw_nextEntry].hops = cast(short)(gifDictionary[lzw_curEntry].hops + 1);

							lzw_nextEntry++;

							lzw_curEntry = gifCode;

							if (lzw_nextEntry != 4096) {
								if (lzw_nextEntry >= gifDictionarySize) {
									gifDictionarySize *= 2;
									gifCodeSize++;

									//update mask array
									gifCurMaskArray = cast(ubyte*)&gifMasks[(gifCodeSize - 2) * 24];

									gifMaskStart = gifCurMaskArray[gifCurMaskIndexComp];
									gifMaskIntermediate = gifCurMaskArray[gifCurMaskIndexComp+1];
									gifMaskEnd = gifCurMaskArray[gifCurMaskIndexComp+2];
								}
							}
						}

						// READ CODE

						break;





					// DECODER (interlaced)
					case 5:

						decoderSubState = 3;

						// THIS IS THE LZW DECOMPRESSOR FOR UNINTERLACED IMAGES

						// INTERPRET gifCode

						if (gifCode == gifEOICode) {
							// stop decoding (End Of Image)

							decoderNextState = 0;

							break;
						}

						if (lzw_isFirstEntry==0) {
							//init LZW decompressor	(first entry)

							lzw_isFirstEntry=1;

							lzw_curEntry = gifCode;

							// INTERPRET CODE AS PIXEL

							if (gifCode < gifClearCode) {
								ptr[0] = gifCurColorTable[gifCode];

								// draw surrounding pixels?
								if (gifInterlaceState < 3) {
									uint* ptrInterlaced = ptr + gifImage.gifImageWidth;

									uint* ptrLast = void;

									switch (gifInterlaceState) {
										case 0:
											ptrLast = ptrInterlaced + (gifImage.gifImageWidth * 7);
											break;
										case 1:
											ptrLast = ptrInterlaced + (gifImage.gifImageWidth * 3);
											break;
										case 2:
										default:
											ptrLast = ptrInterlaced + (gifImage.gifImageWidth * 1);
											break;
									}

									if (ptr_max_page < ptrLast) { ptrLast = ptr_max_page; }

									for ( ; ptrInterlaced < ptrLast ; ptrInterlaced += gifImage.gifImageWidth) {
										ptrInterlaced[0] = gifCurColorTable[gifDictionary[gifCodeTemp].output];
									}
								}

								ptr++;
								ptrPos++;

								if (ptr == ptr_max_line) {
									//change the line
									ptrPos=0;
									ptrLine++;
									InterlaceIncrement();
								}

								// READ CODE
								break;
							}
						}

						if (gifCode == gifClearCode) {
							//CLEAR CODE
							lzw_nextEntry = cast(ushort)(gifClearCode + 2);

							gifDictionarySize = gifClearCode * 2;

							gifCodeSize = gifStartCodeSize;

							//update mask array
							gifCurMaskArray = cast(ubyte*)&gifMasks[(gifCodeSize - 2) * 24];

							gifMaskStart = gifCurMaskArray[gifCurMaskIndexComp];
							gifMaskIntermediate = gifCurMaskArray[gifCurMaskIndexComp+1];
							gifMaskEnd = gifCurMaskArray[gifCurMaskIndexComp+2];

							lzw_isFirstEntry = 0;

							// READ CODE
							break;
						}

						if (gifCode >= lzw_nextEntry) {
							// PRINT OUT LAST CODE FROM DICTIONARY
							gifCodeTemp = lzw_curEntry;
							q = gifDictionary[gifCodeTemp].hops;

							for (;;) {
								gifUncompressed[q] = gifCurColorTable[gifDictionary[gifCodeTemp].output];

								if (gifCodeTemp < gifClearCode) { break; }

								gifCodeTemp = cast(ushort)gifDictionary[gifCodeTemp].code;
								q--;
							}

							ptr[0] = gifCurColorTable[gifDictionary[gifCodeTemp].output];

							// draw surrounding pixels?
							if (gifInterlaceState < 3) {
								uint* ptrInterlaced = ptr + gifImage.gifImageWidth;

								uint* ptrLast = void;

								switch (gifInterlaceState) {
									case 0:
										ptrLast = ptrInterlaced + (gifImage.gifImageWidth * 7);
										break;
									case 1:
										ptrLast = ptrInterlaced + (gifImage.gifImageWidth * 3);
										break;
									case 2:
									default:
										ptrLast = ptrInterlaced + (gifImage.gifImageWidth * 1);
										break;
								}

								if (ptr_max_page < ptrLast) { ptrLast = ptr_max_page; }

								for ( ; ptrInterlaced < ptrLast ; ptrInterlaced += gifImage.gifImageWidth) {
									ptrInterlaced[0] = gifCurColorTable[gifDictionary[gifCodeTemp].output];
								}
							}

							ptr++;
							ptrPos++;

							if (ptr == ptr_max_line) {
								//change the line
								ptrPos=0;

								// draw surrounding pixels?
								if (gifInterlaceState < 3) {
									uint* ptrInterlaced = ptr + gifImage.gifImageWidth;

									uint* ptrLast = void;

									switch (gifInterlaceState) {
										case 0:
											ptrLast = ptrInterlaced + (gifImage.gifImageWidth * 7);
											break;
										case 1:
											ptrLast = ptrInterlaced + (gifImage.gifImageWidth * 3);
											break;
										case 2:
										default:
											ptrLast = ptrInterlaced + (gifImage.gifImageWidth * 1);
											break;
									}

									if (ptr_max_page < ptrLast) { ptrLast = ptr_max_page; }

									for ( ; ptrInterlaced < ptrLast ; ptrInterlaced += gifImage.gifImageWidth) {
										ptrInterlaced[0] = gifCurColorTable[gifDictionary[gifCodeTemp].output];
									}
								}

								ptrLine++;
								InterlaceIncrement();
							}

							for (q=0; q<=gifDictionary[lzw_curEntry].hops; q++) {
								ptr[0] = gifUncompressed[q];

								// draw surrounding pixels?
								if (gifInterlaceState < 3) {
									uint* ptrInterlaced = ptr + gifImage.gifImageWidth;

									uint* ptrLast = void;

									switch (gifInterlaceState) {
										case 0:
											ptrLast = ptrInterlaced + (gifImage.gifImageWidth * 7);
											break;
										case 1:
											ptrLast = ptrInterlaced + (gifImage.gifImageWidth * 3);
											break;
										case 2:
										default:
											ptrLast = ptrInterlaced + (gifImage.gifImageWidth * 1);
											break;
									}

									if (ptr_max_page < ptrLast) { ptrLast = ptr_max_page; }

									for ( ; ptrInterlaced < ptrLast ; ptrInterlaced += gifImage.gifImageWidth) {
										ptrInterlaced[0] = gifCurColorTable[gifDictionary[gifCodeTemp].output];
									}
								}

								ptr++;
								ptrPos++;

								if (ptr == ptr_max_line) {
									//change the line
									ptrPos=0;
									ptrLine++;
									InterlaceIncrement();
								}
							}
						}
						else
						{
							// PRINT OUT CODE FROM DICTIONARY
							gifCodeTemp = gifCode;
							q = gifDictionary[gifCodeTemp].hops;

							for (;;) {
								gifUncompressed[q] = gifCurColorTable[gifDictionary[gifCodeTemp].output];

								if (gifCodeTemp < gifClearCode) { break; }

								gifCodeTemp = cast(ushort)gifDictionary[gifCodeTemp].code;
								q--;
							}

							for (q=0; q<=gifDictionary[gifCode].hops; q++) {
								ptr[0] = gifUncompressed[q];

								// draw surrounding pixels?
								if (gifInterlaceState < 3) {
									uint* ptrInterlaced = ptr + gifImage.gifImageWidth;

									uint* ptrLast = void;

									switch (gifInterlaceState) {
										case 0:
											ptrLast = ptrInterlaced + (gifImage.gifImageWidth * 7);
											break;
										case 1:
											ptrLast = ptrInterlaced + (gifImage.gifImageWidth * 3);
											break;
										case 2:
										default:
											ptrLast = ptrInterlaced + (gifImage.gifImageWidth * 1);
											break;
									}

									if (ptr_max_page < ptrLast) { ptrLast = ptr_max_page; }

									for ( ; ptrInterlaced < ptrLast ; ptrInterlaced += gifImage.gifImageWidth) {
										ptrInterlaced[0] = gifCurColorTable[gifDictionary[gifCodeTemp].output];
									}
								}

								ptr++;
								ptrPos++;

								if (ptr == ptr_max_line) {
									//change the line
									ptrPos = 0;
									ptrLine++;
									InterlaceIncrement();
								}
							}
						}

						if (lzw_nextEntry < 4096) {
							// add this entry to the dictionary
							gifDictionary[lzw_nextEntry].code = cast(short)lzw_curEntry;
							gifDictionary[lzw_nextEntry].output = gifDictionary[gifCodeTemp].output;
							gifDictionary[lzw_nextEntry].hops = cast(short)(gifDictionary[lzw_curEntry].hops + 1);

							lzw_nextEntry++;

							lzw_curEntry = gifCode;

							if (lzw_nextEntry != 4096) {
								if (lzw_nextEntry >= gifDictionarySize) {
									gifDictionarySize *= 2;
									gifCodeSize++;

									//update mask array
									gifCurMaskArray = cast(ubyte*)&gifMasks[(gifCodeSize - 2) * 24];

									gifMaskStart = gifCurMaskArray[gifCurMaskIndexComp];
									gifMaskIntermediate = gifCurMaskArray[gifCurMaskIndexComp+1];
									gifMaskEnd = gifCurMaskArray[gifCurMaskIndexComp+2];
								}
							}
						}

						// READ CODE

						break;

					default: break;
					}
				}

				continue;

			default:
				break;
			}
			break;
		}
		return StreamData.Invalid;
	}

protected:


	void InterlaceIncrement() {
		//ptr will be at the end of the current row
		//essentially in the beginning of the next row

		//if it had gone through row 0, it will now be
		//in row 1, and as such, will only have to
		//increment n-1 rows, where n is the number of
		//rows that the current state is interlaced

		switch (gifInterlaceState) {
		case 0:
		case 1:
			//increase 8 lines
			ptrLine += 7;
			ptr += (7 * gifImage.gifImageWidth);
			break;
		case 2:
			//increase 4 lines
			ptrLine += 3;
			ptr += (3 * gifImage.gifImageWidth);
			break;
		case 3:
			//increase 2 lines
			ptrLine ++;
			ptr += (gifImage.gifImageWidth);
			break;
		default:
			//eh?
			break;
		}

		if (ptr >= ptr_max_page) {
			//we start over again
			gifInterlaceState++;

			switch(gifInterlaceState) {
			case 1:
				//start at row 4
				ptrLine = 4;
				ptr = ptr_start + (gifImage.gifImageWidth * 4);
				break;
			case 2:
				//start at row 2
				ptrLine = 2;
				ptr = ptr_start + (gifImage.gifImageWidth * 2);
				break;
			case 3:
				//start at row 1
				ptrLine = 1;
				ptr = ptr_start + (gifImage.gifImageWidth);
				break;
			default:
				//eh?
				break;
			}
		}
		ptr_max_line = ptr + gifImage.gifImageWidth;
	}

	uint gifIsFirst;

	uint gifFirstTime;
	uint gifFirstClear;
	uint gifFirstClearColor;

	uint gifHeadersLoaded;

	ubyte gifMaskStart;
	ubyte gifMaskIntermediate;
	ubyte gifMaskEnd;

	// starting index into the array
	ubyte* gifCurMaskArray;
	// current index within subsection
	uint gifCurMaskIndex;
	uint gifCurMaskIndexComp;

	//the pointer to the current color table in use
	uint* gifCurColorTable;

	uint gifUncompressed[4096];

	uint gifCodeSize;
	uint gifStartCodeSize;

	_djehuty_image_gif_header gifHeader;
	_djehuty_image_gif_logical_screen gifScreen;
	_djehuty_image_gif_image_descriptor gifImage;

	_djehuty_image_gif_color gifGlobalColorTable[256];
	uint gifGlobalColorTableComputed[256];
	uint gifGlobalColorTableSize;

	_djehuty_image_gif_color gifLocalColorTable[256];
	uint gifLocalColorTableComputed[256];
	uint gifLocalColorTableSize;

	_djehuty_image_gif_graphics_extension gifGraphicControl;

	_djehuty_image_gif_lzw_dictionary_entry gifDictionary[4096];
	uint gifDictionarySize;

	uint gifVersion;

	uint gifIsInterlaced;

	uint gifBlockSize;
	uint gifLastBlockSize;

	uint gifBlockCounter;

	ushort gifCurCode;
	ushort gifClearCode;
	ushort gifEOICode;

	ubyte gifImageData[259]; //256 of block, 3 more for extra padding
	ubyte gifImageLeftOver;
	uint gifBlockCount;

	ubyte gifExtensionIntroducer;
	ubyte gifExtensionLabel;

	int gifInterlaceState;

	ushort lzw_nextEntry;
	ushort lzw_curEntry;
	ushort lzw_isFirstEntry;

	uint* ptr_start;		//ptr of the first pixel

	uint* ptr;			//current ptr in image data
	uint* ptr_max_line;	//ptr of the next line
	uint* ptr_max_page;	//ptr outside of image bounds

	uint ptrLine;		//the current scan line of the image (y)
	uint ptrPos;		//the current pixel of the line (x)
}
