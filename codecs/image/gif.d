module codecs.image.gif;

import interfaces.stream;
import core.view;
import core.string;

import codecs.image.codec;
import codecs.codec;

private
{
	align(1) struct _djehuty_image_gif_header
	{
		ubyte gifSignature[3];
		ubyte gifVersion[3];
	}

	align(1) struct _djehuty_image_gif_logical_screen
	{
		ushort gifLogicalScreenWidth;
		ushort gifLogicalScreenHeight;
		ubyte gifPackedFields;
		ubyte gifBackgroundColorIndex;
		ubyte gifPixelAspectRatio;
	}

	align(1) struct _djehuty_image_gif_color
	{
		ubyte red;
		ubyte green;
		ubyte blue;
	}

	align(1) struct _djehuty_image_gif_image_descriptor
	{
		ushort gifImageLeftPos;
		ushort gifImageTopPos;
		ushort gifImageWidth;
		ushort gifImageHeight;
		ubyte gifPackedFields;
	}

	align(1) struct _djehuty_image_gif_graphics_extension
	{
		ubyte gifBlockSize;

		ubyte gifPackedFields;
		ushort gifDelayTime;
		ubyte gifTransparentColorIndex;

		ubyte gifBlockTerminator;
	}

	struct _djehuty_image_gif_lzw_dictionary_entry
	{
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


	const auto GIF_STATE_INIT						= 0;

	const auto GIF_STATE_READ_HEADERS				= 1;
	const auto GIF_STATE_READ_GRAPHIC_CONTROL		= 2;

	const auto GIF_STATE_DECODE_IMAGE				= 3;
	const auto GIF_STATE_READ_LOCAL_COLOR_TABLE		= 4;

	const auto GIF_STATE_INIT_DECODER				= 5;
	const auto GIF_STATE_READ_LZW_CODESIZE			= 6;

	const auto GIF_STATE_DECODE						= 7;


}

import console.main;

// Section: Codecs/Image

// Description: The GIF Codec
class GIFCodec : ImageCodec
{
	override String getName()
	{
		return new String("Graphics Interchange Format");
	}

	StreamData decode(AbstractStream stream, ref View view)
	{
		ImageFrameDescription imageDesc;
		bool hasMultipleFrames;

		view.setAlphaFlag(true);

		// will read headers and such

		StreamData ret=StreamData.Accepted;

		while (ret==StreamData.Accepted)
		{
			////////OutputDebugStringA("in decoder\n");
			ret = Decoder(stream, view, imageDesc);

			////////OutputDebugString(String(ret) + S(" - ret\n"));
			if (ret == StreamData.Accepted)
			{
			//////OutputDebugStringA("new image found\n");
				// the image frame will be next
				if (!gifIsFirst)
				{
					// stop, since we got what we needed
					// which is the first frame

					// but this signals that we have more than one frame
					hasMultipleFrames = 1;
					return StreamData.Complete;
				}
				else
				{
					gifIsFirst = 0;
				}
			}
		}

		hasMultipleFrames = 0;
		return ret;
	}



	StreamData DecodeFrame(AbstractStream stream, ref View view)
	{
		ImageFrameDescription imageDesc;
		bool hasMultipleFrames;

		// will read headers and such

		int ret;

		ret = Decoder(stream, view, imageDesc);

		if (ret == 2)
		{

			view.setAlphaFlag(true);

			// another frame will occur
			return StreamData.Accepted;
		}
		else if (ret == 1)
		{
			// we are done
			imageDesc.clearFirst = gifFirstClear;
			imageDesc.clearColor = gifFirstClearColor;
			imageDesc.time = gifFirstTime;

			view.setAlphaFlag(true);

			return StreamData.Complete;
		}

		return StreamData.Required;
	}




	StreamData Decoder(ref AbstractStream stream, ref View view, ref ImageFrameDescription imageDesc)
	{
		uint q;

		ushort gifCode;
		ushort gifCodeTemp;

		ulong ptr_len;

		for (;;)
		{
			// READ HEADERS
			switch(decoderState)
			{

				// READ HEADERS //

			case GIF_STATE_INIT:

				gifGraphicControl.gifBlockSize = 0;

				gifIsFirst = 1;

				decoderSubState = 0;
				decoderState = GIF_STATE_READ_HEADERS;

			case GIF_STATE_READ_HEADERS:
				// READ FILE HEADER

				switch(decoderSubState)
				{

				// READ GIF HEADER
				case 0:

					if (!stream.read(&gifHeader, _djehuty_image_gif_header.sizeof))
					{
						return StreamData.Required;
					}

					if (!(gifHeader.gifSignature[0] == 'G' &&
						gifHeader.gifSignature[1] == 'I' &&
						gifHeader.gifSignature[2] == 'F'))
					{
						//bad
						//////OutputDebugStringA("gif - header corrupt, probably not gif file\n");
						return StreamData.Invalid;
					}

					if (!(gifHeader.gifVersion[0] == '8' &&
						gifHeader.gifVersion[1] == '9' &&
						gifHeader.gifVersion[2] == 'a'))
					{
						//bad
						//////OutputDebugStringA("gif - version not supported\n");
						return StreamData.Invalid;
					}

					gifVersion = 1; // 89a

					decoderSubState = 1;

				// READ LOGICAL SCREEN DESCRIPTOR
				case 1:

					if(!(stream.read(&gifScreen, _djehuty_image_gif_logical_screen.sizeof)))
					{
						return StreamData.Required;
					}

					//////OutputDebugStringA("gif - logical screen descriptor loaded\n");

					// DETERMINE WHETHER OR NOT WE GET A GLOBAL COLOR TABLE
					if (gifScreen.gifPackedFields & 128)
					{
						//////OutputDebugStringA("gif - global color table present\n");

						gifGlobalColorTableSize = _djehuty_image_gif_size_of_global_color_table_ref[ gifScreen.gifPackedFields & 0x7 ];
						//gifGlobalColorTable = new _djehuty_image_gif_color[gifGlobalColorTableSize];

						//////OutputDebugString(S("gif - global color table size: ") + String(gifGlobalColorTableSize) + S("\n"));

						decoderSubState = 2;
					}
					else
					{
						//////OutputDebugStringA("gif - global color table not present\n");

						gifGlobalColorTableSize = 0;

						decoderSubState = 0;

						gifGraphicControl.gifBlockSize = 0;

						decoderState = GIF_STATE_READ_GRAPHIC_CONTROL;

						break;
					}

				// READ IN GLOBAL COLOR TABLE WHEN PRESENT
				case 2:
					//Global Color Table is present
					//load it

					if(!(stream.read(gifGlobalColorTable.ptr, 3 * gifGlobalColorTableSize)))
					{
						return StreamData.Required;
					}

					//////OutputDebugStringA("gif - color table loaded\n");

					for (q=0; q<gifGlobalColorTableSize; q++)
					{
						gifGlobalColorTableComputed[q] = 0xFF000000 | (gifGlobalColorTable[q].red << 16) | ((gifGlobalColorTable[q].green << 8) | (gifGlobalColorTable[q].blue));
					}

					gifGlobalColorTableSize = 0;

					decoderSubState = 0;

					gifGraphicControl.gifBlockSize = 0;

					decoderState = GIF_STATE_READ_GRAPHIC_CONTROL;

					break;

				default: break;
				}

				break;

			// READS IN ALL EXTENSIONS
			case GIF_STATE_READ_GRAPHIC_CONTROL:

				switch(decoderSubState)
				{
				//READ EXTENSION INTRODUCER
				case 0:

					//////OutputDebugStringA("gif - reading extension introducer\n");

					if(!(stream.read(&gifExtensionIntroducer, 1)))
					{
						return StreamData.Required;
					}

					if (gifExtensionIntroducer == 0x3B)
					{
						//////OutputDebugStringA("gif - trailer\n");
						// no more blocks
						return StreamData.Complete;
					}
					else if (gifExtensionIntroducer == 0x21)
					{
						//////OutputDebugStringA("gif - image is next\n");
						//this is an extension
						decoderSubState = 1;
					}
					else if (gifExtensionIntroducer == 0x2C)
					{
						//////OutputDebugStringA("gif - image is next\n");
						decoderState = GIF_STATE_DECODE_IMAGE;

						if (gifGraphicControl.gifBlockSize == 4)
						{
							if (gifIsFirst)
							{
								gifFirstTime = (gifGraphicControl.gifDelayTime * 10);

								if ((gifGraphicControl.gifPackedFields & 0x1C) == 0x08)
								{
									gifFirstClear = 1;
								}
								else
								{
									gifFirstClear = 0;
								}

								if (gifScreen.gifBackgroundColorIndex >= gifGlobalColorTableSize)
								{
									gifFirstClearColor = 0;
								}
								else
								{
									// IF TRANSPARENT is set, clear color is transparent
									if ((gifGraphicControl.gifBlockSize == 4) && (gifGraphicControl.gifPackedFields & 1) )
									{
										gifFirstClearColor = 0;
									}
									else
									{
										gifFirstClearColor = gifGlobalColorTableComputed[gifScreen.gifBackgroundColorIndex];
									}
								}
							}
							else
							{
								imageDesc.time = (gifGraphicControl.gifDelayTime * 10);

								if ((gifGraphicControl.gifPackedFields & 0x1C) == 0x08)
								{
									imageDesc.clearFirst = 1;
								}
								else
								{
									imageDesc.clearFirst = 0;
								}

								if (gifScreen.gifBackgroundColorIndex >= gifGlobalColorTableSize)
								{
									imageDesc.clearColor = 0;
								}
								else
								{
									// IF TRANSPARENT is set, clear color is transparent
									if ((gifGraphicControl.gifBlockSize == 4) && (gifGraphicControl.gifPackedFields & 1) )
									{
										imageDesc.clearColor = 0;
									}
									else
									{
										imageDesc.clearColor = gifGlobalColorTableComputed[gifScreen.gifBackgroundColorIndex];
									}
								}
							}
						}
						else
						{
							if (gifIsFirst)
							{
								gifFirstClear = 0;
							}
							else
							{
								imageDesc.clearFirst = 0;
							}
						}
	//////OutputDebugStringA("image is next, new frame\n");
						return StreamData.Accepted; // indicate frame is next
					}

					break;

				//READ EXTENSION LABEL
				case 1:

					//////OutputDebugStringA("gif - reading extension label\n");

					//otherwise, it is the table's lzw minimum code size
					if(!(stream.read(&gifExtensionLabel, 1)))
					{
						return StreamData.Required;
					}

					if (gifExtensionLabel == 0xF9)
					{
						// IS A GRAPHIC CONTROL EXTENSION
						decoderSubState = 2;
					}
					else
					{
						// READ THE BLOCK SIZE
						// SKIP THAT MANY BYTES
						decoderSubState = 3;
					}
					break;

				//READ IN GRAPHIC CONTROL EXTENSION
				case 2:

					//////OutputDebugStringA("gif - reading graphic control extension\n");

					if(!(stream.read(&gifGraphicControl, _djehuty_image_gif_graphics_extension.sizeof)))
					{
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
					if (!(stream.read(&gifExtensionLabel, 1)))
					{
						return StreamData.Required;
					}

					decoderSubState = 4;

				//SKIP EXTENSION LABEL
				case 4:
					if(!(stream.skip(gifExtensionLabel)))
					{
						return StreamData.Required;
					}

					decoderSubState = 5;

				//SKIP EXTENSION DATA BLOCKS
				//READ IN SIZE OF DATA BLOCK
				case 5:
					// NOW READ IN ALL SUB-DATA BLOCKS
					// AND SKIP THEM
					if (!(stream.read(&gifExtensionLabel, 1)))
					{
						return StreamData.Required;
					}

					decoderSubState = 6;

				case 6:

					if (gifExtensionLabel > 0)
					{
						stream.skip(gifExtensionLabel);
						decoderSubState = 5;
					}
					else
					{
						decoderSubState = 0;
					}

				default: break;
				}

				break;















			// READ IN IMAGE DESCRIPTOR
			case GIF_STATE_DECODE_IMAGE:



				//DecodeImage(stream, view, imageDesc, idp);

				//return StreamData.Required;


				//////OutputDebugString(S("gif - ") + String(gifScreen.gifLogicalScreenWidth) + S(" x ") + String(gifScreen.gifLogicalScreenHeight) + S("\n"));

				// READ IN IMAGE DESCRIPTOR

				if(!(stream.read(&gifImage, _djehuty_image_gif_image_descriptor.sizeof)))
				{
					return StreamData.Required;
				}

				if (gifImage.gifPackedFields & 128)
				{
					//////OutputDebugStringA("gif - local color table present\n");

					gifLocalColorTableSize = _djehuty_image_gif_size_of_global_color_table_ref[ gifImage.gifPackedFields & 0x7 ];
					decoderState = GIF_STATE_READ_LOCAL_COLOR_TABLE;
					//////OutputDebugString(S("gif - local color table size: ") + String(gifLocalColorTableSize) + S("\n"));
				}
				else
				{
					decoderState = GIF_STATE_INIT_DECODER;

					//////OutputDebugStringA("gif - local color table not present\n");
					gifLocalColorTableSize = 0;

					gifCurColorTable = gifGlobalColorTableComputed.ptr;

					break;
				}

			// READ IN LOCAL COLOR TABLE WHEN PRESENT
			case GIF_STATE_READ_LOCAL_COLOR_TABLE:
				//local Color Table is present

				if(!(stream.read(gifLocalColorTable.ptr, 3 * gifLocalColorTableSize)))
				{
					return StreamData.Required;
				}

				//compute values
				uint i;

				for (i=0; i<gifLocalColorTableSize; i++)
				{
					gifLocalColorTableComputed[i] = 0xFF000000 | (gifLocalColorTable[i].red << 16) | ((gifLocalColorTable[i].green << 8) | (gifLocalColorTable[i].blue));
				}

				gifCurColorTable = gifLocalColorTableComputed.ptr;

				decoderState = GIF_STATE_INIT_DECODER;



			case GIF_STATE_INIT_DECODER:
				// UPDATE Transparent Color INDEX IN THE COLOR TABLE (if present)
					//////OutputDebugStringA("WE WANT TO SET ZE TRANS COLOR\n");
				if ((gifGraphicControl.gifBlockSize == 4) && (gifGraphicControl.gifPackedFields & 1))
				{
					//////OutputDebugStringA("WE SET ZE TRANS COLOR\n");
					gifCurColorTable[gifGraphicControl.gifTransparentColorIndex] = 0;
				}

				// UPDATE FRAME DESCRIPTION
				imageDesc.xoffset = gifImage.gifImageLeftPos;
				imageDesc.yoffset = gifImage.gifImageTopPos;

				// CHECK TO SEE IF IMAGE IS INTERLACED

				gifIsInterlaced = (gifImage.gifPackedFields & 64);

				if (gifIsInterlaced)
				{
					//////OutputDebugStringA("gif - is interlaced\n");
				}
				else
				{
					//////OutputDebugStringA("gif - is not interlaced\n");
				}

				decoderState = GIF_STATE_READ_LZW_CODESIZE;




			case GIF_STATE_READ_LZW_CODESIZE:

				// READ IN THE LZW MINIMUM CODE SIZE

				if (!(stream.read(&gifExtensionIntroducer, 1)))
				{
					return StreamData.Required;
				}

				//////OutputDebugStringA("gif - lzw min code size: ");
				//////OutputDebugString(String(gifExtensionIntroducer) + S("\n"));

				if (gifExtensionIntroducer < 2)
				{
					//////OutputDebugStringA("gif - lzw min size incorrect\n");
					return StreamData.Invalid;
				}

				// we start from code size + 1 when reading in data
				gifExtensionIntroducer++;
				// so we increment the code size

				gifDictionarySize = _djehuty_image_gif_size_of_global_color_table_ref[gifExtensionIntroducer-2];
				//////OutputDebugString(S("gif - dictionary start size: ") + String(gifDictionarySize) + S("\n"));

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

				////////OutputDebugString(String((gifCodeSize - 2) * 24));

				lzw_isFirstEntry = 0;

				gifInterlaceState = 0; //the state of the interlacing

				ptrPos = 0;
				ptrLine = 0;

				gifBlockSize = 0;
				gifBlockCounter = 0;

				view.CreateDIB(gifImage.gifImageWidth, gifImage.gifImageHeight);

				decoderState = GIF_STATE_DECODE;
				decoderSubState = 0;






			case GIF_STATE_DECODE:

				////////OutputDebugStringA("gif - decoding\n");
				view.lockBuffer(cast(void**)&ptr_start, ptr_len);

				ptr = ptr_start;

				ptr += (gifImage.gifImageWidth * ptrLine);
				ptr_max_line = ptr + gifImage.gifImageWidth;

				ptr_max_page = ptr_start + (ptr_len / 4);

				ptr += ptrPos;

				while(decoderState == GIF_STATE_DECODE)
				{

					switch(decoderSubState)
					{

					//READ IN BLOCK SIZE
					case 0:

						gifLastBlockSize = gifBlockSize;
						gifBlockSize=0;

						decoderSubState = 1;

					case 1:

						if (!(stream.read(&gifBlockSize, 1)))
						{
							view.unlockBuffer();
							return StreamData.Required;
						}

						if (gifBlockSize == 0)
						{
							// block terminator found

							//////OutputDebugStringA("gif - end of blocks\n");

							// PERHAPS THERE WILL BE ANOTHER FRAME
							decoderState = GIF_STATE_READ_GRAPHIC_CONTROL;
							decoderSubState = 0;

							view.unlockBuffer();

							//////OutputDebugStringA("gif - proceeding\n");

							break;
						}
						else
						{
							decoderSubState = 2;
						}

					// READ IN IMAGE DATA BLOCK
					// APPEND, IF NEEDED, TO OLD BLOCK
					case 2:

						////////OutputDebugStringA("gif - image data block found\n");

						////////OutputDebugString(String(gifBlockSize) + S(" - ") + String(gifLastBlockSize) + S("\n"));

						if ((gifBlockCounter==gifLastBlockSize-1))
						{
							gifImageData[0] = gifImageData[gifBlockCounter];
							if(!(stream.read(&gifImageData[1], gifBlockSize)))
							{
								view.unlockBuffer();
								return StreamData.Required;
							}
							gifBlockSize++;
							////////OutputDebugStringA("read, 1 save\n");
						}
						else if ((gifBlockCounter==gifLastBlockSize-2))
						{
							gifImageData[0] = gifImageData[gifBlockCounter];
							gifImageData[1] = gifImageData[gifBlockCounter+1];
							if (!(stream.read(&gifImageData[2], gifBlockSize)))
							{
								view.unlockBuffer();
								return StreamData.Required;
							}
							gifBlockSize+=2;
							////////OutputDebugStringA("read, 2 saves\n");
						}
						else
						{
							if (!(stream.read(gifImageData.ptr, gifBlockSize)))
							{
								view.unlockBuffer();
								return StreamData.Required;
							}
							////////OutputDebugStringA("read, 0 saves\n");
						}

						////////OutputDebugStringA("block read\n");

						gifBlockCounter = 0;

						gifCode = 0;
						gifCodeTemp = 0;

						//get a code
						decoderSubState = 3;

						if (gifIsInterlaced)
						{
							decoderNextSubState = 5;
						}
						else
						{
							//DECODER FOR NON INTERLACED IMAGES
							decoderNextSubState = 4;
						}


					// READ IN CODE
					case 3:


						////////OutputDebugStringA("gif - read code\n");

						// get next code
						uint old_blockcounter;

						old_blockcounter = gifBlockCounter;

						////////OutputDebugString(String(gifMaskStart) + S(", ") + String(gifMaskIntermediate) + S(", ") + String(gifMaskEnd) + S("\n"));

						gifCode = cast(ushort)(gifImageData[gifBlockCounter] & gifMaskStart);

						////////OutputDebugString(String(gifMaskStart));

						////////OutputDebugStringA("gif - reading code...\n");

						if (gifCurMaskIndex)
						{
							gifCode >>= gifCurMaskIndex;
						}

						////////OutputDebugString(String(gifCurMaskIndex) + S("...\n"));

						////////OutputDebugString(String(gifCode) + S(" x ") + String(gifCodeTemp) + S("!!\n"));

						if (gifMaskIntermediate)
						{
							// go to next byte
							gifBlockCounter++;
							if (gifBlockCounter>=gifBlockSize)
							{
								gifBlockCounter = old_blockcounter;

								decoderSubState = 0;
								break;
							}

							gifCodeTemp = cast(ushort)(gifImageData[gifBlockCounter] & gifMaskIntermediate);

							if (8 - gifCurMaskIndex)
							{
								gifCodeTemp <<= (8 - gifCurMaskIndex);
							}

							gifCode |= gifCodeTemp;
						}
						else
						{
							//goto next byte when gifMaskStart's first bit is 1
							if (gifMaskStart & 128)
							{
								//goto next byte
								gifBlockCounter++;
								if (gifBlockCounter>=gifBlockSize)
								{
									gifBlockCounter=old_blockcounter;

									decoderSubState = 0;
									break;
								}
							}
						}

						////////OutputDebugString(String(gifCode) + S(" x ") + String(gifCodeTemp) + S("!!\n"));

						if (gifMaskEnd)
						{

							// go to ultimate byte
							////////OutputDebugStringA("using mask end\n");
							gifBlockCounter++;
							if (gifBlockCounter>=gifBlockSize)
							{
								gifBlockCounter=old_blockcounter;

								decoderSubState = 0;
								break;
							}

							gifCodeTemp = cast(ushort)(gifImageData[gifBlockCounter] & gifMaskEnd);

							if (8-gifCurMaskIndex)
							{
								gifCodeTemp <<= (8-gifCurMaskIndex);
							}

							gifCodeTemp <<= 8;

							gifCode |= gifCodeTemp;
						}
						else
						{
							//goto next byte when gifMaskIntermediate's first bit is 1
							if (gifMaskIntermediate & 128)
							{
								//goto next byte
								gifBlockCounter++;
								if (gifBlockCounter>=gifBlockSize)
								{
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

						////////OutputDebugString(String(gifCode) + S(" x ") + String(gifCodeTemp) + S("!!\n"));

						// GOTO LZW DECODER
						decoderSubState = decoderNextSubState;

						break;







					// DECODER (non-interlaced)
					case 4:

						decoderSubState = 3;

						////////OutputDebugStringA("gif - interpreting code\n");

						// THIS IS THE LZW DECOMPRESSOR FOR UNINTERLACED IMAGES

						// INTERPRET gifCode

						if (gifCode == gifEOICode)
						{
							// stop decoding
							//////OutputDebugStringA("gif - eoi code\n");

							decoderNextState = 0;

							break;
						}

						if (lzw_isFirstEntry==0)
						{
							////////OutputDebugStringA("gif - first entry\n");
							//init LZW decompressor	(first entry)

							lzw_isFirstEntry=1;

							////////OutputDebugString(String(gifImageDataLen) + S(" - image data len\n"));

							lzw_curEntry = gifCode;

							// INTERPRET CODE AS PIXEL

							if (gifCode < gifClearCode)
							{
								////////OutputDebugStringA("gif - printing first pixel\n");

								ptr[0] = gifCurColorTable[gifCode];

								ptr++;
								ptrPos++;

								// READ CODE
								break;
							}
						}

						if (gifCode == gifClearCode)
						{
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

						if (gifCode >= lzw_nextEntry)
						{
							// PRINT OUT LAST CODE FROM DICTIONARY
							gifCodeTemp = lzw_curEntry;
							q = gifDictionary[gifCodeTemp].hops;

							for (;;)
							{
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
						else
						{
							// PRINT OUT CODE FROM DICTIONARY
							gifCodeTemp = gifCode;
							q = gifDictionary[gifCodeTemp].hops;

							for (;;)
							{
								ptr[q] = gifCurColorTable[gifDictionary[gifCodeTemp].output];

								if (gifCodeTemp < gifClearCode) { break; }

								gifCodeTemp = cast(ushort)gifDictionary[gifCodeTemp].code;
								q--;
							}

							ptr += gifDictionary[gifCode].hops+1;
							ptrPos += gifDictionary[gifCode].hops+1;

								////////OutputDebugString(S("x") + String(ptr_max_page - ptr) + S("\n"));
						}

						if (lzw_nextEntry < 4096)
						{
							////////OutputDebugString(String(lzw_nextEntry) + S(" = {") + String(lzw_curEntry) + S(", ") + String(gifDictionary[gifCodeTemp].output) + S(", ") + String(gifDictionary[lzw_curEntry].hops + 1) + S(" - gif adding to dictionary\n"));

							gifDictionary[lzw_nextEntry].code = cast(short)lzw_curEntry;
							gifDictionary[lzw_nextEntry].output = cast(short)gifDictionary[gifCodeTemp].output;
							gifDictionary[lzw_nextEntry].hops = cast(short)(gifDictionary[lzw_curEntry].hops + 1);

							lzw_nextEntry++;

							lzw_curEntry = gifCode;

							if (lzw_nextEntry != 4096)
							{
								if (lzw_nextEntry >= gifDictionarySize)
								{
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

						////////OutputDebugStringA("gif - interpreting code\n");

						// THIS IS THE LZW DECOMPRESSOR FOR UNINTERLACED IMAGES

						// INTERPRET gifCode

						if (gifCode == gifEOICode)
						{
							// stop decoding
							//////OutputDebugStringA("gif - eoi code\n");

							decoderNextState = 0;

							break;
						}

						if (lzw_isFirstEntry==0)
						{
							////////OutputDebugStringA("gif - first entry\n");
							//init LZW decompressor	(first entry)

							lzw_isFirstEntry=1;

							////////OutputDebugString(String(gifImageDataLen) + S(" - image data len\n"));

							lzw_curEntry = gifCode;

							// INTERPRET CODE AS PIXEL

							if (gifCode < gifClearCode)
							{
								////////OutputDebugStringA("gif - printing first pixel\n");
								//ptr[0] = 0x883333ff;
								ptr[0] = gifCurColorTable[gifCode];

								// draw surrounding pixels?
								if (gifInterlaceState < 3)
								{
									uint* ptrInterlaced = ptr + gifImage.gifImageWidth;

									uint* ptrLast = void;

									switch (gifInterlaceState)
									{
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

									for ( ; ptrInterlaced < ptrLast ; ptrInterlaced += gifImage.gifImageWidth)
									{
										ptrInterlaced[0] = gifCurColorTable[gifDictionary[gifCodeTemp].output];
									}
								}

								ptr++;
								ptrPos++;

								if (ptr == ptr_max_line)
								{
									//change the line
									ptrPos=0;
									ptrLine++;
									InterlaceIncrement();
								}

								// READ CODE
								break;
							}
						}

						if (gifCode == gifClearCode)
						{
							//CLEAR CODE
							////////OutputDebugStringA("gif - clear code found\n");

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

						if (gifCode >= lzw_nextEntry)
						{
							// PRINT OUT LAST CODE FROM DICTIONARY
							gifCodeTemp = lzw_curEntry;
							q = gifDictionary[gifCodeTemp].hops;

							for (;;)
							{
								gifUncompressed[q] = gifCurColorTable[gifDictionary[gifCodeTemp].output];

								if (gifCodeTemp < gifClearCode) { break; }

								gifCodeTemp = cast(ushort)gifDictionary[gifCodeTemp].code;
								q--;
							}

							ptr[0] = gifCurColorTable[gifDictionary[gifCodeTemp].output];

							// draw surrounding pixels?
							if (gifInterlaceState < 3)
							{
								uint* ptrInterlaced = ptr + gifImage.gifImageWidth;

								uint* ptrLast = void;

								switch (gifInterlaceState)
								{
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

								for ( ; ptrInterlaced < ptrLast ; ptrInterlaced += gifImage.gifImageWidth)
								{
									ptrInterlaced[0] = gifCurColorTable[gifDictionary[gifCodeTemp].output];
								}
							}

							ptr++;
							ptrPos++;

							if (ptr == ptr_max_line)
							{
								//change the line
								ptrPos=0;

								// draw surrounding pixels?
								if (gifInterlaceState < 3)
								{
									uint* ptrInterlaced = ptr + gifImage.gifImageWidth;

									uint* ptrLast = void;

									switch (gifInterlaceState)
									{
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

									for ( ; ptrInterlaced < ptrLast ; ptrInterlaced += gifImage.gifImageWidth)
									{
										ptrInterlaced[0] = gifCurColorTable[gifDictionary[gifCodeTemp].output];
									}
								}

								ptrLine++;
								InterlaceIncrement();
							}

							for (q=0; q<=gifDictionary[lzw_curEntry].hops; q++)
							{
								ptr[0] = gifUncompressed[q];

								// draw surrounding pixels?
								if (gifInterlaceState < 3)
								{
									uint* ptrInterlaced = ptr + gifImage.gifImageWidth;

									uint* ptrLast = void;

									switch (gifInterlaceState)
									{
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

									for ( ; ptrInterlaced < ptrLast ; ptrInterlaced += gifImage.gifImageWidth)
									{
										ptrInterlaced[0] = gifCurColorTable[gifDictionary[gifCodeTemp].output];
									}
								}

								ptr++;
								ptrPos++;

								if (ptr == ptr_max_line)
								{
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

							for (;;)
							{
								gifUncompressed[q] = gifCurColorTable[gifDictionary[gifCodeTemp].output];

								if (gifCodeTemp < gifClearCode) { break; }

								gifCodeTemp = cast(ushort)gifDictionary[gifCodeTemp].code;
								q--;
							}

							for (q=0; q<=gifDictionary[gifCode].hops; q++)
							{
								ptr[0] = gifUncompressed[q];

								// draw surrounding pixels?
								if (gifInterlaceState < 3)
								{
									uint* ptrInterlaced = ptr + gifImage.gifImageWidth;

									uint* ptrLast = void;

									switch (gifInterlaceState)
									{
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

									for ( ; ptrInterlaced < ptrLast ; ptrInterlaced += gifImage.gifImageWidth)
									{
										ptrInterlaced[0] = gifCurColorTable[gifDictionary[gifCodeTemp].output];
									}
								}

								ptr++;
								ptrPos++;

								if (ptr == ptr_max_line)
								{
									//change the line
									ptrPos = 0;
									ptrLine++;
									InterlaceIncrement();
								}
							}

								////////OutputDebugString(S("x") + String(ptr_max_page - ptr) + S("\n"));
						}

						if (lzw_nextEntry < 4096)
						{
							////////OutputDebugString(String(lzw_nextEntry) + S(" = {") + String(lzw_curEntry) + S(", ") + String(gifDictionary[gifCodeTemp].output) + S(", ") + String(gifDictionary[lzw_curEntry].hops + 1) + S(" - gif adding to dictionary\n"));

							gifDictionary[lzw_nextEntry].code = cast(short)lzw_curEntry;
							gifDictionary[lzw_nextEntry].output = gifDictionary[gifCodeTemp].output;
							gifDictionary[lzw_nextEntry].hops = cast(short)(gifDictionary[lzw_curEntry].hops + 1);

							lzw_nextEntry++;

							lzw_curEntry = gifCode;

							if (lzw_nextEntry != 4096)
							{
								if (lzw_nextEntry >= gifDictionarySize)
								{
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

				break;

			default: break;
			}
		}

		return StreamData.Invalid;
	}

protected:


	void InterlaceIncrement()
	{
		//ptr will be at the end of the current row
		//essentially in the beginning of the next row

		//if it had gone through row 0, it will now be
		//in row 1, and as such, will only have to
		//increment n-1 rows, where n is the number of
		//rows that the current state is interlaced

		switch (gifInterlaceState)
		{
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

		if (ptr >= ptr_max_page)
		{
			//we start over again
			gifInterlaceState++;

			switch(gifInterlaceState)
			{
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
