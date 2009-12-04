module codecs.image.bmp;

import graphics.bitmap;

import core.stream;

import codecs.image.codec;
import codecs.codec;

import core.string;

// Section: Codecs/Image

// Description: The BMP Codec
class BMPCodec : ImageCodec
{
	override String name() {
		return new String("Bitmap");
	}

	StreamData decode(Stream stream, ref Bitmap view) {
		ImageFrameDescription imageDesc;
		bool hasMultipleFrames;

		uint* ptr;
		uint* ptr_max_line;
		uint* ptr_max;
		ulong ptr_len;


		for (;;) {
			switch (decoderState) {
			case BMP_STATE_INIT:
				//initial stuff

				hasMultipleFrames = 0;

				decoderState = BMP_STATE_READ_HEADERS;

			case BMP_STATE_READ_HEADERS:

				//reading the header
				if (!stream.read(&bf, 14)) { return StreamData.Required; }

				// Check for 'BM' signature
				if (bf.bfType != 0x4D42) {

					// Header is corrupt
					return StreamData.Invalid;
				}

				decoderState = BMP_STATE_READ_BITMAP_SIZE;
				continue;

			case BMP_STATE_READ_BITMAP_SIZE:
				//reading the bitmap size

				if (!stream.read(&biSize, 4)) { return StreamData.Required; }

				switch (biSize) {
				case 0x0C: // osx 1.0
					decoderState = BMP_STATE_READ_OSX_1;
					continue;
				case 0xF0: // osx 2.0
					decoderState = BMP_STATE_READ_OSX_2;
					continue;
				case 0x28: // windows
					decoderState = BMP_STATE_READ_WIN;
					continue;
				default:
					// Bitmap Version not supported
					return StreamData.Invalid;
				}

			case BMP_STATE_READ_OSX_1:
				return StreamData.Complete;

			case BMP_STATE_READ_OSX_2:
				return StreamData.Complete;

	// WINDOWS BITMAP DECODING //

			case BMP_STATE_READ_WIN:

				//get the bitmap info header
				if (!stream.read(&bi, 36)) { return StreamData.Required; }

				//get the windows color table

				switch(bi.biBitCount) {
				case 1:
					decoderState = BMP_STATE_READ_WIN_PALETTE;
					decoderNextState = BMP_STATE_DECODE_WIN_1BPP;
					paletteNumColors = 2;
					break;
				case 2:
					decoderState = BMP_STATE_READ_WIN_PALETTE;
					decoderNextState = BMP_STATE_DECODE_WIN_2BPP;
					paletteNumColors = 4;
					break;
				case 4:
					decoderState = BMP_STATE_READ_WIN_PALETTE;
					decoderNextState = BMP_STATE_DECODE_WIN_4BPP;
					paletteNumColors = 16;
					break;
				case 8:
					decoderState = BMP_STATE_READ_WIN_PALETTE;
					decoderNextState = BMP_STATE_DECODE_WIN_8BPP;
					paletteNumColors = 256;
					break;
				case 16:
					decoderState = BMP_STATE_DECODE_WIN_16BPP;
					paletteNumColors = 0;
					break;
				case 24:
					decoderState = BMP_STATE_DECODE_WIN_24BPP;
					paletteNumColors = 0;
					break;
				case 32:
					decoderState = BMP_STATE_DECODE_WIN_32BPP;
					paletteNumColors = 0;
					break;
				default:

					// invalid format

					return StreamData.Invalid;

				}

				continue;








			case BMP_STATE_READ_WIN_PALETTE:

				// get the amount we need

				//read from the file the palette information
				if (bi.biClrUsed == 0) {
					bi.biClrUsed = paletteNumColors;
				}

				//read from the file the palette information
				if(!stream.read(&palette, (bi.biClrUsed * 4))) { return StreamData.Required; }

				for (uint i=0; i<paletteNumColors; i++) {
					palette[i] |= 0xFF000000;
				}

				decoderState = decoderNextState;


				continue;






	// WINDOWS 1BPP BITMAPS //


			case BMP_STATE_DECODE_WIN_1BPP:
				//////OutputDebugStringA("bmp - windows - 1 bpp - 2 colors\n");

				//skip further padding, skip to image data, according to header
				if (bf.bfOffBits - (54 + (bi.biClrUsed * 4)) > 0) {
					if(!stream.skip(bf.bfOffBits - (54 + (bi.biClrUsed * 4)) ) ) { return StreamData.Required; }
				}

				//Calculate the bytes each row will take
				//within the file's bitmap data
				bytesPerRow = cast(uint)((cast(float)bi.biWidth / 8) + 0.5);
				bytesForPadding = 0;
				if (bytesPerRow & 0x3) {
					//pad bytes per row
					bytesForPadding = (4 - (bytesPerRow & 0x3));
					bytesPerRow += bytesForPadding;
				}

				if (bi.biCompression == 0) { // rgb
					//calculate the getLength of the bitmap data
					bitmapDataLen = bytesPerRow * bi.biHeight;
				}
				else {
					////OutputDebugStringA("bmp - invalid compression format\n");
					return StreamData.Invalid;
				}

				//create the bitmap's buffer
				view.create(bi.biWidth, bi.biHeight);

				ptrLine = 0;
				ptrPos = 0;
				fileDataToSkip = 0;

				decoderState = BMP_STATE_RENDER_WIN_1BPP;


			case BMP_STATE_RENDER_WIN_1BPP:
				//////OutputDebugStringA("bmp - rendering stream input - 1bpp\n");

				// TAKE ALL BYTES FROM STREAM
				// IF WE FINISH, WE CAN return StreamData.Complete

				view.lockBuffer(cast(void**)&ptr_max, ptr_len);

				ptr = ptr_max + (ptr_len / 4);

				ptr -= (bi.biWidth * (ptrLine + 1));
				ptr_max_line = ptr + bi.biWidth;

				ptr_max += bi.biWidth;

				ptr += ptrPos;

				// LOAD FILEDATA WITH PART OF THE STREAM
				// CHUNKS AT A TIME
				for (;;) {
					if (stream.remaining == 0) {
						view.unlockBuffer();
						return StreamData.Required;
					}

					fileData = new ubyte[cast(uint)stream.remaining];
					fileDataCurPtr = fileDataPtr = fileData.ptr;
					fileDataEndPtr = fileDataCurPtr + stream.readAny(fileData.ptr, cast(uint)stream.remaining);

					if (fileDataCurPtr + fileDataToSkip >= fileDataEndPtr) {
						//////OutputDebugStringA("bmp - rendering error - not enough information\n");
						//////OutputDebugStringA("bmp - skipping data across page\n");
						fileDataToSkip -= (fileDataEndPtr - fileDataCurPtr);
						view.unlockBuffer();
						delete fileData;
						return StreamData.Complete;
					}
					else if (fileDataToSkip > 0) {
						fileDataCurPtr += fileDataToSkip;
						fileDataToSkip = 0;
					}

					// we start from the bottom of the bitmap and work our way up
					// ptr_max == ORIGINAL POINTER GIVEN BY LOCK BUFFER
					// ptr == WORKS ITS WAY FROM END OF BITMAP TO FRONT

					// GO THROUGH AND RENDER TO THE BITMAP
					// AS MUCH AS POSSIBLE
					for (;fileDataCurPtr < fileDataEndPtr;) {
						for (;;) {
							// FIRST PIXEL
							ptr[0] = palette[fileDataCurPtr[0] >> 7];

							ptr++;
							ptrPos++;

							if (ptr == ptr_max_line) { break; }

							// SECOND PIXEL
							ptr[0] = palette[(fileDataCurPtr[0] >> 6) & 0x1];

							ptr++;
							ptrPos++;

							if (ptr == ptr_max_line) { break; }

							// THIRD PIXEL
							ptr[0] = palette[(fileDataCurPtr[0] >> 5) & 0x1];

							ptr++;
							ptrPos++;

							if (ptr == ptr_max_line) { break; }

							// FOURTH PIXEL
							ptr[0] = palette[(fileDataCurPtr[0] >> 4) & 0x1];

							ptr++;
							ptrPos++;

							if (ptr == ptr_max_line) { break; }

							// FIFTH PIXEL
							ptr[0] = palette[(fileDataCurPtr[0] >> 3) & 0x1];

							ptr++;
							ptrPos++;

							if (ptr == ptr_max_line) { break; }

							// SIXTH PIXEL
							ptr[0] = palette[(fileDataCurPtr[0] >> 2) & 0x1];

							ptr++;
							ptrPos++;

							if (ptr == ptr_max_line) { break; }

							// SEVENTH PIXEL
							ptr[0] = palette[(fileDataCurPtr[0] >> 1) & 0x1];

							ptr++;
							ptrPos++;

							if (ptr == ptr_max_line) { break; }

							// EIGHTH PIXEL
							ptr[0] = palette[fileDataCurPtr[0] & 0x1];

							ptr++;
							ptrPos++;

							if (ptr == ptr_max_line) { break; }

							// MOVE BUFFER POINTER

							fileDataCurPtr++;

							if (fileDataCurPtr == fileDataEndPtr) {
								break;
							}
						}

						if (ptr == ptr_max_line) {
							if (ptr == ptr_max) {
								view.unlockBuffer();
								delete fileData;
								return StreamData.Complete;
							}

							ptrLine++;
							ptrPos = 0;

							ptr -= (bi.biWidth * 2);
							ptr_max_line -= (bi.biWidth);

							fileDataCurPtr++;

							fileDataToSkip = bytesForPadding;

							if (fileDataCurPtr == fileDataEndPtr) {
								break;
							}

							if (fileDataCurPtr + fileDataToSkip >= fileDataEndPtr) {
								fileDataToSkip -= (fileDataEndPtr - fileDataCurPtr);
								break;
							}
							else {
								fileDataCurPtr += fileDataToSkip;
								fileDataToSkip = 0;
							}
						}

						if (fileDataCurPtr == fileDataEndPtr) {
							break;
						}

					}
				}

	// WINDOWS 2BPP BITMAPS //

			case BMP_STATE_DECODE_WIN_2BPP:
				////OutputDebugStringA("bmp - windows - 2 bpp - 4 colors\n");

				//skip further padding, skip to image data, according to header
				if (bf.bfOffBits - (54 + (bi.biClrUsed * 4)) > 0) {
					if(!stream.skip(bf.bfOffBits - (54 + (bi.biClrUsed * 4)) ) ) { return StreamData.Required; }
				}

				//Calculate the bytes each row will take
				//within the file's bitmap data
				bytesPerRow = cast(uint)((cast(float)bi.biWidth / 4) + 0.5);
				bytesForPadding = 0;
				if (bytesPerRow & 0x3) {
					//pad bytes per row
					bytesForPadding = (4 - (bytesPerRow & 0x3));
					bytesPerRow += bytesForPadding;
				}

				if (bi.biCompression == 0) { // rgb
					//calculate the getLength of the bitmap data
					bitmapDataLen = bytesPerRow * bi.biHeight;
				}
				else {
					////OutputDebugStringA("bmp - invalid compression format\n");
					return StreamData.Invalid;
				}

				//create the bitmap's buffer
				view.create(bi.biWidth, bi.biHeight);

				ptrLine = 0;
				ptrPos = 0;
				fileDataToSkip = 0;

				decoderState = BMP_STATE_RENDER_WIN_2BPP;

			case BMP_STATE_RENDER_WIN_2BPP:
				////OutputDebugStringA("bmp - rendering stream input - 2bpp\n");

				// TAKE ALL BYTES FROM STREAM
				// IF WE FINISH, WE CAN return StreamData.Complete

				view.lockBuffer(cast(void**)&ptr_max, ptr_len);

				ptr = ptr_max + (ptr_len / 4);

				ptr -= (bi.biWidth * (ptrLine + 1));
				ptr_max_line = ptr + bi.biWidth;

				ptr_max += bi.biWidth;

				ptr += ptrPos;

				// LOAD FILEDATA WITH PART OF THE STREAM
				// CHUNKS AT A TIME
				for (;;) {
					if (stream.remaining() == 0) {
						view.unlockBuffer();
						return StreamData.Required;
					}

					fileData = new ubyte[cast(uint)stream.remaining];
					fileDataCurPtr = fileDataPtr = fileData.ptr;
					fileDataEndPtr = fileDataCurPtr + stream.readAny(fileData.ptr, cast(uint)stream.remaining);

					if (fileDataCurPtr + fileDataToSkip >= fileDataEndPtr) {
						//////OutputDebugStringA("bmp - rendering error - not enough information\n");
						//////OutputDebugStringA("bmp - skipping data across page\n");
						fileDataToSkip -= (fileDataEndPtr - fileDataCurPtr);
						view.unlockBuffer();
						delete fileData;
						return StreamData.Complete;
					}
					else if (fileDataToSkip > 0) {
						fileDataCurPtr += fileDataToSkip;
						fileDataToSkip = 0;
					}

					// we start from the bottom of the bitmap and work our way up
					// ptr_max == ORIGINAL POINTER GIVEN BY LOCK BUFFER
					// ptr == WORKS ITS WAY FROM END OF BITMAP TO FRONT

					// GO THROUGH AND RENDER TO THE BITMAP
					// AS MUCH AS POSSIBLE
					for (;fileDataCurPtr < fileDataEndPtr;) {
						for (;;) {
							// FIRST PIXEL
							ptr[0] = palette[fileDataCurPtr[0] >> 6];

							ptr++;
							ptrPos++;

							if (ptr == ptr_max_line) { break; }

							// SECOND PIXEL
							ptr[0] = palette[(fileDataCurPtr[0] >> 4) & 0x7];

							ptr++;
							ptrPos++;

							if (ptr == ptr_max_line) { break; }

							// THIRD PIXEL
							ptr[0] = palette[(fileDataCurPtr[0] >> 2) & 0x7];

							ptr++;
							ptrPos++;

							if (ptr == ptr_max_line) { break; }

							// FOURTH PIXEL
							ptr[0] = palette[fileDataCurPtr[0] & 0x7];

							ptr++;
							ptrPos++;

							if (ptr == ptr_max_line) { break; }

							// MOVE BUFFER POINTER

							fileDataCurPtr++;

							if (fileDataCurPtr == fileDataEndPtr) {
								break;
							}
						}

						if (ptr == ptr_max_line) {
							//////OutputDebugStringA("bmp - rendered line\n");
							if (ptr == ptr_max) {
								//////OutputDebugStringA("bmp - rendering complete\n");
								view.unlockBuffer();
								delete fileData;
								return StreamData.Complete;
							}

							ptrLine++;
							ptrPos = 0;

							ptr -= (bi.biWidth * 2);
							ptr_max_line -= (bi.biWidth);

							fileDataCurPtr++;

							fileDataToSkip = bytesForPadding;

							if (fileDataCurPtr == fileDataEndPtr) {
								break;
							}

							//////OutputDebugString(String(fileDataToSkip) + S("\n"));

							if (fileDataCurPtr + fileDataToSkip >= fileDataEndPtr) {
								fileDataToSkip -= (fileDataEndPtr - fileDataCurPtr);
								break;
							}
							else {
								fileDataCurPtr += fileDataToSkip;
								fileDataToSkip = 0;
							}
						}

						if (fileDataCurPtr == fileDataEndPtr) {
							break;
						}
					}
				}

	// WINDOWS 4BPP BITMAPS, RGB AND RLE COMPRESSED //

			case BMP_STATE_DECODE_WIN_4BPP:
				////OutputDebugStringA("bmp - windows - 4 bpp - 16 colors\n");

				//skip further padding, skip to image data, according to header
				if (bf.bfOffBits - (54 + (bi.biClrUsed * 4)) > 0) {
					if(!stream.skip(bf.bfOffBits - (54 + (bi.biClrUsed * 4)) ) ) { return StreamData.Required; }
				}

				//Calculate the bytes each row will take
				//within the file's bitmap data
				bytesPerRow = cast(uint)((cast(float)bi.biWidth / 2) + 0.5);
				bytesForPadding = 0;
				if (bytesPerRow & 0x3) {
					//pad bytes per row
					bytesForPadding = (4 - (bytesPerRow & 0x3));
					bytesPerRow += bytesForPadding;
				}

				if (bi.biCompression == 2) { // rle-4
					//calculate the getLength of the bitmap data
					bitmapDataLen = bi.biSizeImage;

					decoderSubState = 0;
				}
				else if (bi.biCompression == 0) { // rgb
					//calculate the getLength of the bitmap data
					bitmapDataLen = bytesPerRow * bi.biHeight;
				}
				else {
					////OutputDebugStringA("bmp - invalid compression format\n");
				}

				//create the bitmap's buffer
				view.create(bi.biWidth, bi.biHeight);

				ptrLine = 0;
				ptrPos = 0;
				fileDataToSkip = 0;

				decoderState = BMP_STATE_RENDER_WIN_4BPP;

			case BMP_STATE_RENDER_WIN_4BPP:
				//////OutputDebugStringA("bmp - rendering stream input - 4bpp\n");

				// TAKE ALL BYTES FROM STREAM
				// IF WE FINISH, WE CAN return StreamData.Complete

				view.lockBuffer(cast(void**)&ptr_max, ptr_len);

				ptr = ptr_max + (ptr_len / 4);

				ptr -= (bi.biWidth * (ptrLine + 1));
				ptr_max_line = ptr + bi.biWidth;

				ptr_max += bi.biWidth;

				ptr += ptrPos;

				// LOAD FILEDATA WITH PART OF THE STREAM
				// CHUNKS AT A TIME
				for (;;) {
					if (stream.remaining == 0) {
						view.unlockBuffer();
						return StreamData.Required;
					}

					fileData = new ubyte[cast(uint)stream.remaining];
					fileDataCurPtr = fileDataPtr = fileData.ptr;
					fileDataEndPtr = fileDataCurPtr + stream.readAny(fileData.ptr, cast(uint)stream.remaining);

					if (fileDataCurPtr + fileDataToSkip >= fileDataEndPtr) {
						//////OutputDebugStringA("bmp - rendering error - not enough information\n");
						//////OutputDebugStringA("bmp - skipping data across page\n");
						fileDataToSkip -= (fileDataEndPtr - fileDataCurPtr);
						view.unlockBuffer();
						delete fileData;
						return StreamData.Complete;
					}
					else if (fileDataToSkip > 0) {
						fileDataCurPtr += fileDataToSkip;
						fileDataToSkip = 0;
					}

					// we start from the bottom of the bitmap and work our way up
					// ptr_max == ORIGINAL POINTER GIVEN BY LOCK BUFFER
					// ptr == WORKS ITS WAY FROM END OF BITMAP TO FRONT

					if (bi.biCompression == 0) {
						// GO THROUGH AND RENDER TO THE BITMAP
						// AS MUCH AS POSSIBLE
						for (;fileDataCurPtr < fileDataEndPtr;) {
							for (;;) {
								// FIRST PIXEL
								ptr[0] = palette[fileDataCurPtr[0] >> 4];

								ptr++;
								ptrPos++;

								if (ptr == ptr_max_line) { break; }

								// SECOND PIXEL
								ptr[0] = palette[fileDataCurPtr[0] & 0xF];

								ptr++;
								ptrPos++;

								if (ptr == ptr_max_line) { break; }

								// MOVE BUFFER POINTER

								fileDataCurPtr++;

								if (fileDataCurPtr == fileDataEndPtr) {
									break;
								}
							}

							if (ptr == ptr_max_line) {
								//////OutputDebugStringA("bmp - rendered line\n");
								if (ptr == ptr_max) {
									//////OutputDebugStringA("bmp - rendering complete\n");
									view.unlockBuffer();
									delete fileData;
									return StreamData.Complete;
								}

								ptrLine++;
								ptrPos = 0;

								ptr -= (bi.biWidth * 2);
								ptr_max_line -= (bi.biWidth);

								fileDataCurPtr++;

								fileDataToSkip = bytesForPadding;

								if (fileDataCurPtr == fileDataEndPtr) {
									break;
								}

								//////OutputDebugString(String(fileDataToSkip) + S("\n"));

								if (fileDataCurPtr + fileDataToSkip >= fileDataEndPtr) {
									fileDataToSkip -= (fileDataEndPtr - fileDataCurPtr);
									break;
								}
								else {
									fileDataCurPtr += fileDataToSkip;
									fileDataToSkip = 0;
								}
							}

							if (fileDataCurPtr == fileDataEndPtr) {
								break;
							}

						}

					}
					else // rle - 4
					{
						//calculate pointers

						// LOOP
						// {
						//    STATE 0:
						//        GET FIRST CODE
						//    STATE 1: RLE NORMAL
						//        GET CODE
						//        RENDER
						//    STATE 2: ESCAPE
						//        GET CODE
						//          FILL IN LINE  (EOL)
						//          FILL IN IMAGE (EOB)
						//          SWITCH TO DELTA
						//          SWITCH TO ABSOLUTE
						//    STATE 3: DELTA
						//        GET CODES
						//        REPOSITION
						//    STATE 4: ABSOLUTE
						//        RENDER
						// }

					}
				}

				//view.unlockBuffer();

				//if (bi.biCompression == 0)
				//{
					//Bitmaps store data from bottom to top...
					//The bitmap buffer, however, stores from
					//top to bottom...take that into
					//consideration when Reading this code
					//for (; ((ptr + bi.biWidth) <= ptrmax); )
					//{
					//	for (;;)
					//	{
					//		if (i >= width) { break; }
					//		ptr[i] = palette[fileDataCurPtr[a] >> 4];
					//		i++;
					//		if (i >= width) { break; }
					//		ptr[i] = palette[fileDataCurPtr[a] & 0xF];
					//		i++;
					//		a++;
					//	}

						//progress a line
					//	ptr += width;

						//digress a line
					//	fileDataEndPtr -= bytesPerRow;
					//	fileDataCurPtr = fileDataEndPtr;
					//}
				//}

				//find expected minimum file size - bitmapDataLen + headers + color tables
				//fileSize = bitmapDataLen;

				//if (stream.getLength() < fileSize)
				//{
					//do not continue
				//	////OutputDebugStringA("bmp - unexpected size\n");
					//return StreamData.Invalid;
				//}

				//if there is a corrupt header, do not continue
				//if (bf.bfOffBits <= 54)
				//{
				//	////OutputDebugStringA("bmp - corrupt header\n");
				//	return StreamData.Invalid;
				//}

				//skip further padding
				//if (stream.getLength() - (bitmapDataLen + 54 + (bi.biClrUsed * 4)) > 0)
				//{
				//	stream.skip(stream.getLength() - (bitmapDataLen + 54 + (bi.biClrUsed * 4)));
				//}

				//allocate the bitmap data
				//fileDataPtr = new UInt8[bitmapDataLen];

				//read from the file the bitmap data
				//stream.read(fileDataPtr, bitmapDataLen);

				//calculate pointers
				/*fileDataEndPtr = fileDataPtr + bitmapDataLen - bytesPerRow;
				fileDataCurPtr = fileDataEndPtr;

				//retrieve a pointer to a bitmap buffer
				view.lockBuffer((void**)&ptr, ptrlen);

				//calculate the buffer's bound
				ptrmax = (ptr + (ptrlen/4));

				//This loop will paint to the buffer
				//using information from the file

				if (bi.biCompression == 2) //BI_RLE4
				{
					//calculate pointers
					fileDataEndPtr = fileDataPtr + bitmapDataLen;
					fileDataCurPtr = fileDataPtr;

					ptrmax -= width;
					UInt32* ptr_cur = ptrmax;
					for (; ptr_cur >= ptr; )
					{
						UInt8 lenByte;
						//goes through a row
						for (i=0; i < width; )
						{
							//get getLength byte
							lenByte = fileDataCurPtr[0];

							fileDataCurPtr++;
							if (fileDataCurPtr == fileDataEndPtr) { break; }

							if (lenByte == 0)
							{
								//escape sequence or absolute mode

								lenByte = fileDataCurPtr[0];

								fileDataCurPtr++;
								if (fileDataCurPtr == fileDataEndPtr) { break; }

								if (lenByte < 3)
								{
									//encoded mode
									if (lenByte == 0)
									{
										//end of line
										//paint black pixels
										//to the rest of the line and continue
										if (i!=0)
										{
											for ( ; i < width; i++)
											{
												ptr_cur[i] = 0;
											}
											break;
										}
									}
									else if (lenByte == 1)
									{
										//end of bitmap
										//paint black pixels
										//to the rest of the bitmap and exit
										for (; ptr_cur >= ptr; )
										{
											for ( ; i < width; i++)
											{
												ptr_cur[i] = 0;
											}

											//digress a line
											ptrmax-=width;
											ptr_cur=ptrmax;

											i = 0;
										}
										break;
									}
									else
									{
										//delta
										//next two bytes are horiz and vert offsets to new pixel

										lenByte = fileDataCurPtr[0];

										fileDataCurPtr++;
										if (fileDataCurPtr == fileDataEndPtr) { break; }

										a = fileDataCurPtr[0];

										fileDataCurPtr++;
										if (fileDataCurPtr == fileDataEndPtr) { break; }

										//lenByte is the horizontal offset
										//a is the vertical offset

										//for vertical offsets, we decrease or increase
										//the ptr_cur;
										ptr_cur += (width * (UInt8)(a));
										ptr_cur += (lenByte);
									}
								}
								else
								{
									//absolute mode
									//lenByte is the number of colors that follow is normal format
									//this must be padded to multiple of four

									a = lenByte;

									//decode
									for ( ; ; )
									{
										ptr_cur[i] = palette[fileDataCurPtr[0] >> 4];

										i++;
										if (i>=width) { break; }

										a--;
										if (a <= 0) { break; }

										ptr_cur[i] = palette[fileDataCurPtr[0] & 0xF];

										i++;
										if (i>=width) { break; }

										a--;
										if (a <= 0) { break; }

										fileDataCurPtr++;
										if (fileDataCurPtr >= fileDataEndPtr) { break; }
									}

									fileDataCurPtr++;
									if (fileDataCurPtr >= fileDataEndPtr) { break; }

									//realign to a word boundary
									if ((lenByte/2) & 0x01)
									{
										fileDataCurPtr++ ;
										if (fileDataCurPtr >= fileDataEndPtr) { break; }
									}
								}
							}
							else
							{
								//run the getLength of lenByte, and paint the pixel
								//of the index that many times onto the buffer
								for ( ; ; )
								{
									ptr_cur[i] = palette[fileDataCurPtr[0] >> 4];

									i++;
									if (i>=width) { break; }

									lenByte--;
									if (lenByte <= 0) { break; }

									ptr_cur[i] = palette[fileDataCurPtr[0] & 0xF];

									i++;
									if (i>=width) { break; }

									lenByte--;
									if (lenByte <= 0) { break; }
								}

								fileDataCurPtr++;
								if (fileDataCurPtr >= fileDataEndPtr) { break; }
							}
						}

						//digress a line
						ptrmax-=width;
						ptr_cur=ptrmax;
					}
				}
				else
				{
					//Bitmaps store data from bottom to top...
					//The bitmap buffer, however, stores from
					//top to bottom...take that into
					//consideration when Reading this code
					for (; ((ptr + width) <= ptrmax); )
					{
						//goes through a row
						i = 0;
						a = 0;

						for (;;)
						{
							if (i >= width) { break; }
							ptr[i] = palette[fileDataCurPtr[a] >> 4];
							i++;
							if (i >= width) { break; }
							ptr[i] = palette[fileDataCurPtr[a] & 0xF];
							i++;

							a++;
						}

						//progress a line
						ptr += width;

						//digress a line
						fileDataEndPtr -= bytesPerRow;
						fileDataCurPtr = fileDataEndPtr;
					}
				}

				//unlock the buffer, so the view can refresh
				view.unlockBuffer();

				*/

//				return StreamData.Complete;

	// WINDOWS 8BPP BITMAPS, RGB AND RLE COMPRESSED //

			case BMP_STATE_DECODE_WIN_8BPP:
				////OutputDebugStringA("bmp - windows - 8 bpp - 256 colors\n");

				//skip further padding, skip to image data, according to header
				if (bf.bfOffBits - (54 + (bi.biClrUsed * 4)) > 0) {
					if(!stream.skip(bf.bfOffBits - (54 + (bi.biClrUsed * 4)) ) ) { return StreamData.Required; }
				}

				//Calculate the bytes each row will take
				//within the file's bitmap data
				bytesPerRow = bi.biWidth;
				if (bytesPerRow & 0x3) {
					//pad bytes per row
					bytesPerRow += (4 - (bytesPerRow & 0x3));
				}

				if (bi.biCompression == 1) { // rle-8
					//calculate the getLength of the bitmap data
					bitmapDataLen = bi.biSizeImage;

					decoderSubState = 0;
				}
				else if (bi.biCompression == 0) { // rgb
					//calculate the getLength of the bitmap data
					bitmapDataLen = bytesPerRow * bi.biHeight;
				}
				else {
					////OutputDebugStringA("bmp - invalid compression format\n");
				}

				//create the bitmap's buffer
				view.create(bi.biWidth, bi.biHeight);

				ptrLine = 0;
				ptrPos = 0;
				fileDataToSkip = 0;

				decoderState = BMP_STATE_RENDER_WIN_8BPP;

			case BMP_STATE_RENDER_WIN_8BPP:

				//////OutputDebugStringA("bmp - rendering stream input - 8bpp\n");

				// TAKE ALL BYTES FROM STREAM
				// IF WE FINISH, WE CAN return StreamData.Complete

				// GET THE BITMAP DATA AND GO TO THE NEXT POSITION
				// TO RENDER TO
				view.lockBuffer(cast(void**)&ptr_max, ptr_len);

				ptr = ptr_max + (ptr_len / 4);

				ptr -= (bi.biWidth * (ptrLine + 1));
				ptr_max_line = ptr + bi.biWidth;

				ptr_max += bi.biWidth;

				ptr += ptrPos;

				// LOAD FILEDATA WITH PART OF THE STREAM
				// CHUNKS AT A TIME
				for (;;) {
					if (stream.remaining == 0) {
						view.unlockBuffer();
						return StreamData.Required;
					}

					fileData = new ubyte[cast(uint)stream.remaining];
					fileDataCurPtr = fileDataPtr = fileData.ptr;
					fileDataEndPtr = fileDataCurPtr + stream.readAny(fileData.ptr, cast(uint)stream.remaining);

					if (fileDataCurPtr + fileDataToSkip >= fileDataEndPtr) {
						//////OutputDebugStringA("bmp - rendering error - not enough information\n");
						//////OutputDebugStringA("bmp - skipping data across page\n");
						fileDataToSkip -= (fileDataEndPtr - fileDataCurPtr);
						view.unlockBuffer();
						delete fileData;
						return StreamData.Complete;
					}
					else if (fileDataToSkip > 0) {
						fileDataCurPtr += fileDataToSkip;
						fileDataToSkip = 0;
					}

					// we start from the bottom of the bitmap and work our way up
					// ptr_max == ORIGINAL POINTER GIVEN BY LOCK BUFFER
					// ptr == WORKS ITS WAY FROM END OF BITMAP TO FRONT

					if (bi.biCompression == 0) {
						// GO THROUGH AND RENDER TO THE BITMAP
						// AS MUCH AS POSSIBLE
						for (;;) {
							ptr[0] = palette[fileDataCurPtr[0]];

							ptr++;
							ptrPos++;
							fileDataCurPtr++;

							if (ptr == ptr_max_line) {
								//////OutputDebugStringA("bmp - rendered line\n");
								if (ptr == ptr_max) {
									////OutputDebugStringA("bmp - rendering complete\n");
									view.unlockBuffer();
									delete fileData;
									return StreamData.Complete;
								}

								ptrLine++;
								ptrPos = 0;

								ptr -= (bi.biWidth * 2);
								ptr_max_line -= (bi.biWidth);

								fileDataToSkip = bytesPerRow - bi.biWidth;

								if (fileDataCurPtr + fileDataToSkip >= fileDataEndPtr) {
									fileDataToSkip -= (fileDataEndPtr - fileDataCurPtr);
									break;
								}
								else {
									fileDataCurPtr += fileDataToSkip;
									fileDataToSkip = 0;
								}
							}

							if (fileDataCurPtr == fileDataEndPtr) {
								break;
							}
						}
					}
					else { // rle - 8
						//calculate pointers

						// LOOP
						// {
						//    STATE 0:
						//        GET FIRST CODE
						//    STATE 1: RLE NORMAL
						//        GET CODE
						//        RENDER
						//    STATE 2: ESCAPE
						//        GET CODE
						//          FILL IN LINE  (EOL)
						//          FILL IN IMAGE (EOB)
						//          SWITCH TO DELTA
						//          SWITCH TO ABSOLUTE
						//    STATE 3: DELTA
						//        GET CODES
						//        REPOSITION
						//    STATE 4: ABSOLUTE
						//        RENDER
						// }
						for (;fileDataCurPtr < fileDataEndPtr;) {
							switch(decoderSubState) {
							case 0:

								// GET CODE

								byteData = fileDataCurPtr[0];

								if (byteData == 0) {
									// ESCAPE SEQUENCE
									decoderSubState = 2;
								}
								else {
									// JUST RENDER DATA OUT
									decoderSubState = 1;
								}

								fileDataCurPtr++;
								if (fileDataCurPtr == fileDataEndPtr) { break; }

								break;
							case 1:

								//////OutputDebugStringA("bmp - rle - state: RENDER\n");

								// RENDER RLE DATA

								//run the getLength of lenByte, and paint the pixel
								//of the index that many times onto the buffer
								for ( ; (byteData > 0); ) {
									ptr[0] = palette[fileDataCurPtr[0]];
									ptr++;
									ptrPos++;
									byteData--;

									if (ptr == ptr_max_line) {
										if (ptr == ptr_max) {
											////OutputDebugStringA("bmp - from render - rendering complete\n");
											view.unlockBuffer();
											delete fileData;
											return StreamData.Complete;
										}

										ptrLine++;
										ptrPos = 0;

										ptr -= (bi.biWidth * 2);
										ptr_max_line -= (bi.biWidth);
									}
								}

								// GO BACK TO RETRIEVAL OF CODE
								decoderSubState = 0;

								fileDataCurPtr++;
								if (fileDataCurPtr >= fileDataEndPtr) { break; }

								break;
							case 2:

								// HANDLE ESCAPE SEQUENCES
								byteData = fileDataCurPtr[0];

								if (byteData < 3) {
									if (byteData == 0) {
										// END OF LINE ENCODING
										if (ptrPos!=0) {
											for ( ; ; ) {
												ptr[0] = 0;
												ptr++;
												ptrPos++;

												if (ptr == ptr_max_line) {
													//////OutputDebugStringA("bmp - rendered line\n");
													if (ptr == ptr_max) {
														////OutputDebugStringA("bmp - rendering complete\n");
														view.unlockBuffer();
														delete fileData;
														return StreamData.Complete;
													}

													ptrLine++;
													ptrPos = 0;

													ptr -= (bi.biWidth * 2);
													ptr_max_line -= (bi.biWidth);

													break;
												}
											}
										}

										// BACK TO GETTING A CODE
										decoderSubState = 0;
									}
									else if (byteData == 1) {
										// END OF BITMAP ENCODING
										//end of bitmap
										//paint black pixels
										//to the rest of the bitmap and exit
										for (;;) {
											for ( ; ; ) {
												ptr[0] = 0;
												ptr++;
												ptrPos++;

												if (ptr == ptr_max_line) {
													//////OutputDebugStringA("bmp - rendered line\n");
													if (ptr == ptr_max) {
														////OutputDebugStringA("bmp - rendering complete\n");
														view.unlockBuffer();
														delete fileData;
														return StreamData.Complete;
													}

													ptrLine++;
													ptrPos = 0;

													ptr -= (bi.biWidth * 2);
													ptr_max_line -= (bi.biWidth);
												}
											}
										}

										// BACK TO GETTING A CODE
										//decoderSubState = 0;
									}
									else { //if (byteData == 2)
										// DELTA ENCODING
										decoderSubState = 7;
									}
								}
								else {
									//ABSOLUTE MODE
									byteCounter = byteData;
									decoderSubState = 3;
								}

								fileDataCurPtr++;
								if (fileDataCurPtr >= fileDataEndPtr) { break; }

								break;
							case 3:

								// ABSOLUTE MODE

								// BYTE DATA IS THE AMOUNT OF BYTES TO READ

								//decode
								for ( ; (byteCounter>0) && (ptr < ptr_max_line);  ) {
									ptr[0] = palette[fileDataCurPtr[0]];
									ptrPos++;
									ptr++;
									byteCounter--;

									if (ptr == ptr_max_line) {
										//////OutputDebugStringA("bmp - rendered line\n");
										if (ptr == ptr_max) {
											view.unlockBuffer();
											return StreamData.Complete;
										}

										ptrLine++;
										ptrPos = 0;

										ptr -= (bi.biWidth * 2);
										ptr_max_line -= (bi.biWidth);
									}

									fileDataCurPtr++;
									if (fileDataCurPtr >= fileDataEndPtr) { break; }
								}

								if (byteCounter == 0) {
									// BACK TO GETTING A CODE
									decoderSubState = 0;

									//realign to a word boundary
									fileDataToSkip = (byteData & 0x01);

									if (fileDataCurPtr + fileDataToSkip >= fileDataEndPtr) {
										fileDataToSkip -= (fileDataEndPtr - fileDataCurPtr);

										//ensure we drop out of loop
										fileDataCurPtr = fileDataEndPtr;
										break;
									}
									else {
										fileDataCurPtr += fileDataToSkip;
										fileDataToSkip = 0;
									}
								}

								break;
							case 7:

								////OutputDebugStringA("bmp - rle - state: DELTA\n");
								// DELTA MODE

								// BACK TO GETTING A CODE
								decoderSubState = 0;

								break;
							case 5:
								break;
							case 6:
								break;
							default: break;
							}
						}
					}
				}

				//view.unlockBuffer();
				//break;


	// WINDOWS 16BPP BITMAPS, 5-6-5 AND 5-5-5 AND others //

			case BMP_STATE_DECODE_WIN_16BPP:
				////OutputDebugStringA("bmp - windows - 16 bpp\n");
				return StreamData.Complete;

	// WINDOWS 24BPP BITMAPS //

			case BMP_STATE_DECODE_WIN_24BPP:
				////OutputDebugStringA("bmp - windows - 24 bpp - true color\n");

				//skip further padding, skip to image data, according to header
				if (bf.bfOffBits - (54) > 0) {
					if(!stream.skip(bf.bfOffBits - (54) ) ) { return StreamData.Required; }
				}

				//Calculate the bytes each row will take
				//within the file's bitmap data
				bytesForPadding=0;
				bytesPerRow = bi.biWidth*3;
				if (bytesPerRow & 0x3) {
					//pad bytes per row
					bytesForPadding = (4 - (bytesPerRow & 0x3));
					bytesPerRow += bytesForPadding;
				}

				if (bi.biCompression == 0) { // rgb
					//calculate the getLength of the bitmap data
					bitmapDataLen = bytesPerRow * bi.biHeight;
				}
				else {
					////OutputDebugStringA("bmp - invalid compression format\n");
					return StreamData.Invalid;
				}

				//create the bitmap's buffer
				view.create(bi.biWidth, bi.biHeight);

				ptrLine = 0;
				ptrPos = 0;
				fileDataToSkip = 0;

				byteCounter = 0;

				decoderState = BMP_STATE_RENDER_WIN_24BPP;

			case BMP_STATE_RENDER_WIN_24BPP:

				//////OutputDebugStringA("bmp - rendering stream input - 24bpp\n");

				// TAKE ALL BYTES FROM STREAM
				// IF WE FINISH, WE CAN return StreamData.Complete

				// GET THE BITMAP DATA AND GO TO THE NEXT POSITION
				// TO RENDER TO

				view.lockBuffer(cast(void**)&ptr_max, ptr_len);

				ptr = ptr_max + (ptr_len / 4);

				ptr -= (bi.biWidth * (ptrLine + 1));
				ptr_max_line = ptr + bi.biWidth;

				ptr_max += bi.biWidth;

				ptr += ptrPos;

				// LOAD FILEDATA WITH PART OF THE STREAM
				// CHUNKS AT A TIME
				for (;;) {
					if (stream.remaining == 0) {
						view.unlockBuffer();
						return StreamData.Required;
					}

					fileData = new ubyte[cast(uint)bitmapDataLen];
					fileDataCurPtr = fileDataPtr = fileData.ptr;
					fileDataEndPtr = fileDataCurPtr + stream.readAny(fileData.ptr, cast(uint)bitmapDataLen);

					if (fileDataCurPtr + fileDataToSkip >= fileDataEndPtr) {
						//////OutputDebugStringA("bmp - rendering error - not enough information\n");
						//////OutputDebugStringA("bmp - skipping data across page\n");
						fileDataToSkip -= (fileDataEndPtr - fileDataCurPtr);
						view.unlockBuffer();
						delete fileData;
						return StreamData.Complete;
					}
					else if (fileDataToSkip > 0) {
						fileDataCurPtr += fileDataToSkip;
						fileDataToSkip = 0;
					}

					// we start from the bottom of the bitmap and work our way up
					// ptr_max == ORIGINAL POINTER GIVEN BY LOCK BUFFER
					// ptr == WORKS ITS WAY FROM END OF BITMAP TO FRONT


					// GO THROUGH AND RENDER TO THE BITMAP
					// AS MUCH AS POSSIBLE
					for (;fileDataCurPtr < fileDataEndPtr;) {
						if (((fileDataEndPtr - fileDataCurPtr) > 3) && byteCounter == 0) {
							ptr[0] = 0xFF000000 | ((cast(uint*)fileDataCurPtr)[0] & 0xFFFFFF);// | (fileDataCurPtr[1] << 8) | (fileDataCurPtr[2] << 16);
							fileDataCurPtr+=3;

							ptr++;
							ptrPos++;

							if (ptr == ptr_max_line) {
								if (ptr == ptr_max) {
									////OutputDebugStringA("bmp - rendering complete\n");
									view.unlockBuffer();
									delete fileData;
									return StreamData.Complete;
								}

								ptrLine++;
								ptrPos = 0;

								ptr -= (bi.biWidth * 2);
								ptr_max_line -= (bi.biWidth);

								fileDataToSkip = bytesForPadding;

								if (fileDataCurPtr + fileDataToSkip >= fileDataEndPtr) {
									fileDataToSkip -= (fileDataEndPtr - fileDataCurPtr);
									break;
								}
								else {
									fileDataCurPtr += fileDataToSkip;
									fileDataToSkip = 0;
								}
							}
						}
						else if (byteCounter == 0) {
							ptr[0] = 0xFF000000 | (fileDataCurPtr[0]);
							byteCounter++;

							fileDataCurPtr++;
						}
						else if (byteCounter == 1) {
							ptr[0] |= (fileDataCurPtr[0] << 8);
							byteCounter++;

							fileDataCurPtr++;
						}
						else {
							ptr[0] |= (fileDataCurPtr[0] << 16) ;
							byteCounter = 0;

							ptr++;
							ptrPos++;
							fileDataCurPtr++;

							if (ptr == ptr_max_line) {
								if (ptr == ptr_max) {
									////OutputDebugStringA("bmp - rendering complete\n");
									view.unlockBuffer();
									delete fileData;
									return StreamData.Complete;
								}

								ptrLine++;
								ptrPos = 0;

								ptr -= (bi.biWidth * 2);
								ptr_max_line -= (bi.biWidth);

								fileDataToSkip = bytesForPadding;

								if (fileDataCurPtr + fileDataToSkip >= fileDataEndPtr) {
									fileDataToSkip -= (fileDataEndPtr - fileDataCurPtr);
									break;
								}
								else {
									fileDataCurPtr += fileDataToSkip;
									fileDataToSkip = 0;
								}
							}
						}
					}
				}

	// WINDOWS 32BPP BITMAPS //

			case BMP_STATE_DECODE_WIN_32BPP:
				////OutputDebugStringA("bmp - windows - 32 bpp - true color\n");

				//skip further padding, skip to image data, according to header
				if (bf.bfOffBits - (54) > 0) {
					if(!stream.skip(bf.bfOffBits - (54) ) ) { return StreamData.Required; }
				}

				//Calculate the bytes each row will take
				//within the file's bitmap data
				bytesPerRow = bi.biWidth*4;
				bytesForPadding = 0;

				if (bi.biCompression == 0 || bi.biCompression == 3) { // rgb
					//calculate the getLength of the bitmap data
					bitmapDataLen = bytesPerRow * bi.biHeight;
				}
				else {
					////OutputDebugStringA("bmp - invalid compression format\n");
					return StreamData.Invalid;
				}

				//create the bitmap's buffer
				view.create(bi.biWidth, bi.biHeight);

				ptrLine = 0;
				ptrPos = 0;
				fileDataToSkip = 0;

				byteCounter = 0;

				decoderState = BMP_STATE_RENDER_WIN_32BPP;

			case BMP_STATE_RENDER_WIN_32BPP:

				//////OutputDebugStringA("bmp - rendering stream input - 32bpp\n");

				// TAKE ALL BYTES FROM STREAM
				// IF WE FINISH, WE CAN return StreamData.Complete

				// GET THE BITMAP DATA AND GO TO THE NEXT POSITION
				// TO RENDER TO
				view.lockBuffer(cast(void**)&ptr_max, ptr_len);

				ptr = ptr_max + (ptr_len / 4);

				ptr -= (bi.biWidth * (ptrLine + 1));
				ptr_max_line = ptr + bi.biWidth;

				ptr_max += bi.biWidth;

				ptr += ptrPos;

				// LOAD FILEDATA WITH PART OF THE STREAM
				// CHUNKS AT A TIME
				for (;;) {
					if (stream.remaining == 0) {
						view.unlockBuffer();
						return StreamData.Required;
					}

					fileData = new ubyte[cast(uint)stream.remaining];
					fileDataCurPtr = fileDataPtr = fileData.ptr;
					fileDataEndPtr = fileDataCurPtr + stream.readAny(fileData.ptr, cast(uint)stream.remaining);

					// we start from the bottom of the bitmap and work our way up
					// ptr_max == ORIGINAL POINTER GIVEN BY LOCK BUFFER
					// ptr == WORKS ITS WAY FROM END OF BITMAP TO FRONT


					// GO THROUGH AND RENDER TO THE BITMAP
					// AS MUCH AS POSSIBLE
					for (;fileDataCurPtr < fileDataEndPtr;) {
						if (((fileDataEndPtr - fileDataCurPtr) > 3) && byteCounter == 0) {
							ptr[0] = 0xFF000000 | ((cast(uint*)fileDataCurPtr)[0] & 0xFFFFFF);// | (fileDataCurPtr[1] << 8) | (fileDataCurPtr[2] << 16);
							fileDataCurPtr+=4;

							ptr++;
							ptrPos++;

							if (ptr == ptr_max_line) {
								if (ptr == ptr_max) {
									////OutputDebugStringA("bmp - rendering complete\n");
									view.unlockBuffer();
									delete fileData;

									return StreamData.Complete;
								}

								ptrLine++;
								ptrPos = 0;

								ptr -= (bi.biWidth * 2);
								ptr_max_line -= (bi.biWidth);

								fileDataToSkip = bytesForPadding;

								if (fileDataCurPtr + fileDataToSkip >= fileDataEndPtr) {
									fileDataToSkip -= (fileDataEndPtr - fileDataCurPtr);
									break;
								}
								else {
									fileDataCurPtr += fileDataToSkip;
									fileDataToSkip = 0;
								}
							}
						}
						else if (byteCounter == 0) {
							ptr[0] = 0xFF000000 | (fileDataCurPtr[0]);
							byteCounter++;

							fileDataCurPtr++;
						}
						else if (byteCounter == 1) {
							ptr[0] |= (fileDataCurPtr[0] << 8);
							byteCounter++;

							fileDataCurPtr++;
						}
						else if (byteCounter == 2) {
							ptr[0] |= (fileDataCurPtr[0] << 16);
							byteCounter++;

							fileDataCurPtr++;
						}
						else {
							//ptr[0] |= (fileDataCurPtr[0] << 16) ;
							byteCounter = 0;

							ptr++;
							ptrPos++;
							fileDataCurPtr++;

							if (ptr == ptr_max_line) {
								//////OutputDebugStringA("bmp - rendered line\n");
								if (ptr == ptr_max) {
									////OutputDebugStringA("bmp - rendering complete\n");
									view.unlockBuffer();
									delete fileData;
									return StreamData.Complete;
								}

								ptrLine++;
								ptrPos = 0;

								ptr -= (bi.biWidth * 2);
								ptr_max_line -= (bi.biWidth);
							}
						}
					}
				}

				default:
					break;
			}
			break;
		}

		return StreamData.Invalid;
	}

protected:

	_djehuty_image_bitmap_file_header bf;
	_djehuty_image_bitmap_info_header bi;
	_djehuty_image_os2_1_bitmap_info_header os2_1_bi;
	_djehuty_image_os2_2_bitmap_info_header os2_2_bi;

	uint biSize;

	uint paletteNumColors;
	uint palette[256];

	int bytesPerRow;
	int bytesForPadding;

	ubyte fileData[];
	ubyte* fileDataPtr;
	ubyte* fileDataEndPtr;
	ubyte* fileDataCurPtr;
	int fileDataToSkip;

	uint ptrLine;		//the current scan line of the image (y)
	uint ptrPos;		//the current pixel of the line (x)

	uint byteData;
	uint byteCounter;

	ulong bitmapDataLen;

	ulong fileSize;

private:

	align(2) struct _djehuty_image_bitmap_file_header {
		ushort bfType;
		uint bfSize;
		ushort bfReserved1;
		ushort bfReserved2;
		uint bfOffBits;
	}

	align(2) struct _djehuty_image_bitmap_info_header {
		uint  biWidth;
		int  biHeight;
		ushort biPlanes;
		ushort biBitCount;
		uint biCompression;
		uint biSizeImage;
		int  biXPelsPerMeter;
		int  biYPelsPerMeter;
		uint biClrUsed;
		uint biClrImportant;
	}

	align(2) struct _djehuty_image_os2_1_bitmap_info_header {
		ushort  biWidth;
		ushort  biHeight;
		ushort  biPlanes;
		ushort  biBitCount;
	}

	align(2) struct _djehuty_image_os2_2_bitmap_info_header {
		uint  biWidth;
		uint  biHeight;
		ushort  biPlanes;
		ushort  biBitCount;
		uint  biCompression;
		uint  biSizeImage;
		uint  biXPelsPerMeter;
		uint  biYPelsPerMeter;
		uint  biClrUsed;
		uint  biClrImportant;

		/* extended os2 2.x stuff */

		ushort  usUnits;
		ushort  usReserved;
		ushort  usRecording;
		ushort  usRendering;
		uint   cSize1;
		uint   cSize2;
		uint   ulColorEncoding;
		uint   ulIdentifier;
	}

	static const auto BMP_STATE_INIT						= 0;

	static const auto BMP_STATE_READ_HEADERS				= 1;
	static const auto BMP_STATE_READ_BITMAP_SIZE			= 2;

	static const auto BMP_STATE_READ_OSX_1					= 3;
	static const auto BMP_STATE_READ_OSX_2					= 4;
	static const auto BMP_STATE_READ_WIN					= 5;

	static const auto BMP_STATE_READ_WIN_PALETTE			= 6;
	static const auto BMP_STATE_READ_OSX_1_PALETTE			= 7;
	static const auto BMP_STATE_READ_OSX_2_PALETTE			= 8;

	static const auto BMP_STATE_DECODE_WIN_1BPP			= 9;
	static const auto BMP_STATE_DECODE_WIN_2BPP			= 10;
	static const auto BMP_STATE_DECODE_WIN_4BPP			= 11;
	static const auto BMP_STATE_DECODE_WIN_8BPP			= 12;
	static const auto BMP_STATE_DECODE_WIN_16BPP			= 13;
	static const auto BMP_STATE_DECODE_WIN_24BPP			= 14;
	static const auto BMP_STATE_DECODE_WIN_32BPP			= 15;

	static const auto BMP_STATE_RENDER_WIN_1BPP			= 16;
	static const auto BMP_STATE_RENDER_WIN_2BPP			= 17;
	static const auto BMP_STATE_RENDER_WIN_4BPP			= 18;
	static const auto BMP_STATE_RENDER_WIN_8BPP			= 19;
	static const auto BMP_STATE_RENDER_WIN_16BPP			= 20;
	static const auto BMP_STATE_RENDER_WIN_24BPP			= 21;
	static const auto BMP_STATE_RENDER_WIN_32BPP			= 22;

	static const auto BMP_STATE_DECODE_OS2_1_1BPP			= 40;

	static const auto BMP_STATE_DECODE_OS2_2_1BPP			= 80;




	static const ubyte _djehuty_convert_16_of_6_to_32[64] = (0, 4, 8, 12, 16, 20, 24, 28, 32, 36, 40, 45, 49, 53, 57, 61,
														65, 69, 73, 77, 81, 85, 89, 93, 97, 101, 105, 109, 113, 117, 121, 125,
														130, 134, 138, 142, 146, 150, 154, 158, 162, 166, 170, 174, 178, 182, 186,
														190, 194, 198, 202, 206, 210, 215, 219, 223, 227, 231, 235, 239, 243, 247, 251, 255);

	static const ubyte _djehuty_convert_16_of_5_to_32[32] = (0, 8, 16, 25, 33, 41, 49, 58, 66, 74, 82, 90, 99, 107, 115, 123,
														132, 140, 148, 156, 165, 173, 181, 189, 197, 206, 214, 222, 230, 239, 247, 255);

}
