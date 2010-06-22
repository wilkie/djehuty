/*
 * deflate.d
 *
 * This file implements the DEFLATE compression algorithm.
 *
 * Author: Dave Wilkinson
 *
 */

module decoders.binary.deflate;

import core.endian;
import core.stream;
import core.definitions;

import decoders.binary.decoder;

private {

	const auto DEFLATE_STATE_INIT							= 0;

	const auto DEFLATE_STATE_READ_BYTE						= 1;

	const auto DEFLATE_STATE_READ_BITS						= 2;
	const auto DEFLATE_STATE_READ_BIT						= 3;

	const auto DEFLATE_STATE_READ_BITS_REV					= 4;
	const auto DEFLATE_STATE_READ_BIT_REV					= 5;

	const auto DEFLATE_STATE_READ_BFINAL					= 6;
	const auto DEFLATE_STATE_READ_BTYPE						= 7;

	const auto DEFLATE_STATE_DEFLATE_NO_COMPRESSION			= 8;
	const auto DEFLATE_STATE_DEFLATE_NO_COMPRESSION_SKIP	= 9;
	const auto DEFLATE_STATE_DEFLATE_NO_COMPRESSION_COPY	= 10;

	const auto DEFLATE_STATE_DEFLATE_FIXED_CHECK_CODE		= 12;
	const auto DEFLATE_STATE_DEFLATE_FIXED_GET_LENGTH		= 13;
	const auto DEFLATE_STATE_DEFLATE_FIXED_GET_DISTANCE		= 14;
	const auto DEFLATE_STATE_DEFLATE_FIXED_GET_DISTANCE_EX	= 15;

	const auto DEFLATE_STATE_DEFLATE_DYNAMIC_COMPRESSION	= 16;
	const auto	DEFLATE_STATE_DEFLATE_DYNAMIC_HDIST			= 17;
	const auto DEFLATE_STATE_DEFLATE_DYNAMIC_HCLEN			= 18;
	const auto DEFLATE_STATE_DEFLATE_DYNAMIC_GET_CODE_LEN	= 19;
	const auto DEFLATE_STATE_DEFLATE_DYNAMIC_DECODE_LENS	= 20;

	const auto DEFLATE_STATE_DEFLATE_DYNAMIC_DECODE_LEN16	= 21;
	const auto DEFLATE_STATE_DEFLATE_DYNAMIC_DECODE_LEN17	= 22;
	const auto DEFLATE_STATE_DEFLATE_DYNAMIC_DECODE_LEN18	= 23;

	const auto DEFLATE_STATE_DEFLATE_DYNAMIC_DECODE_DIST	= 24;

	const auto DEFLATE_STATE_DEFLATE_DYNAMIC_BUILD_TREE		= 25;

	const auto DEFLATE_STATE_DEFLATE_DYNAMIC_DECODER		= 26;
	const auto DEFLATE_STATE_DEFLATE_DYNAMIC_GET_LENGTH		= 27;
	const auto DEFLATE_STATE_DEFLATE_DYNAMIC_GET_DISTANCE	= 28;
	const auto DEFLATE_STATE_DEFLATE_DYNAMIC_GET_DIST_EX	= 29;


	const auto DEFLATE_STATE_HANDLE_LENGTH_DISTANCE			= 30;


	// compression flags //

	const auto DEFLATE_COMPRESSION_NO_COMPRESSION			= 0;
	const auto DEFLATE_COMPRESSION_FIXED_HUFFMAN			= 1;
	const auto DEFLATE_COMPRESSION_DYNAMIC_HUFFMAN			= 2;
	// -- 3 is reserved




	struct _huffman_range {
		ushort _huffman_base;			// base

		ushort huffmanMinorCode;		// minimum code can be
		ushort huffmanMajorCode;		// maximum code can be
	}

	struct _huffman_entry {
		ushort huffmanRangesCount;		// number of ranges

		_huffman_range huffmanRanges[144];	// ranges
	}

	struct _huffman_table {
		// tables listed by bit length (1 -- 16 bits)
		_huffman_entry huffman_entries[16];
	}


	struct _deflate_block_info {
		int deflateIsLastBlock;
		int deflateBlockType;
	}

	struct _deflate_length_entry {
		ubyte deflateLengthExtraBits;
		ushort deflateLengthBase;
	}

	static const _huffman_table deflateFixedHuffmanTable  = { [

				{ 0, [{0}] },													//  1 bit
				{ 0, [{0}] },													//  2 bits
				{ 0, [{0}] },													//  3 bits
				{ 0, [{0}] },													//  4 bits
				{ 0, [{0}] },													//  5 bits
				{ 0, [{0}] },													//  6 bits
				{ 1, [ { 256, 0x00, 0x17 } ] },							//  7 bits
				{ 2, [ { 0, 0x30, 0xBF }, { 280, 0xC0, 0xC7 } ] },		//  8 bits
				{ 1, [ { 144, 0x190, 0x1FF } ] },						//  9 bits

				// { 0 } ...											// 10 - 16 bits

			] };

	static const _deflate_length_entry deflateLengthTable[29] =
			[	{ 0, 3 },
				{ 0, 4 },
				{ 0, 5 },
				{ 0, 6 },
				{ 0, 7 },
				{ 0, 8 },
				{ 0, 9 },
				{ 0, 10 },
				{ 1, 11 },
				{ 1, 13 },
				{ 1, 15 },
				{ 1, 17 },
				{ 2, 19 },
				{ 2, 23 },
				{ 2, 27 },
				{ 2, 31 },
				{ 3, 35 },
				{ 3, 43 },
				{ 3, 51 },
				{ 3, 59 },
				{ 4, 67 },
				{ 4, 83 },
				{ 4, 99 },
				{ 4, 115 },
				{ 5, 131 },
				{ 5, 163 },
				{ 5, 195 },
				{ 5, 227 },
				{ 0, 258 } 	];

	static const _deflate_length_entry globalDeflateDistanceTable[30] =
			[
				{ 0, 1 },
				{ 0, 2 },
				{ 0, 3 },
				{ 0, 4 },
				{ 1, 5 },
				{ 1, 7 },
				{ 2, 9 },
				{ 2, 13 },
				{ 3, 17 },
				{ 3, 25 },
				{ 4, 33 },
				{ 4, 49 },
				{ 5, 65 },
				{ 5, 97 },
				{ 6, 129 },
				{ 6, 193 },
				{ 7, 257 },
				{ 7, 385 },
				{ 8, 513 },
				{ 8, 769 },
				{ 9, 1025 },
				{ 9, 1537 },
				{ 10, 2049 },
				{ 10, 3073 },
				{ 11, 4097 },
				{ 11, 6145 },
				{ 12, 8193 },
				{ 12, 12289 },
				{ 13, 16385 },
				{ 13, 24577 }
			];

	// IS USED TO REFER TO THE CORRECT SPOT IN THE CODE LENGTHS ARRAY
	// FOR COMPUTING HUFFMAN TABLES FOR DYNAMIC COMPRESSION
	// CODE LENGTHS OCCUR IN THIS ORDER:
	//   16, 17, 18, 0, 8, 7, 9, 6, 10, 5, 11, 4, 12, 3, 13, 2, 14, 1, 15
	// WORKS UNDER THE ASSUMPTION THAT THE LATER CODE LENGTHS WILL BE 0 AND
	//  THUS NOT NECESSARY TO INCLUDE, PLUS THAT 16, 17, 18, 0 ARE
	// NECESSARY (THUS HCLEN + 4 IS THE NUMBER OF CODES TO RETRIEVE)
	static const ubyte deflateCodeLengthsReference[19] =
			[
				16, 17, 18, 0, 8, 7, 9, 6, 10, 5, 11, 4, 12, 3, 13, 2, 14, 1, 15
			];


}

// Section: Codecs/Binary

// Description: This represents the DEFLATE Codec.
class DEFLATEDecoder : BinaryDecoder {
protected:

	// the bit mask to get the bit
	ubyte deflateCurMask;
	ubyte deflateCurBit;
	ubyte deflateCurByte;

	// FOR READ_BITS
	uint deflateBitsLeft;
	uint deflateCurValue;
	ubyte deflateCurValueBit;

	uint deflateLastState;

	uint deflateCurCode;

	// BLOCK HEADER
	_deflate_block_info deflateCurBlock;



	// FOR 'NO COMPRESSION' TYPE
	ushort deflateDataLength;


	// FOR HUFFMAN COMPRESSION TYPES

	// CURRENT HUFFMAN TABLES
	_huffman_table deflateInternalHuffmanTable;
	_huffman_table deflateInternalDistanceTable;

	// FOR REGULAR HUFFMAN DECODER //
	uint deflateCurHuffmanBitLength;
	_huffman_table* deflateCurHuffmanTable;
	_huffman_entry* deflateCurHuffmanEntry;

	// FOR DISTANCE TREE DECODER //
	_huffman_entry* deflateCurDistanceEntry;
	uint deflateCurDistanceBitLength;

	// TRACK LENGTH, DISTANCE
	ushort deflateLength;
	ushort deflateDistance;

	// COUNTER
	uint deflateCounter;
	uint deflateCounterMax;

	// DYNAMIC HUFFMAN TREE BUILDING
	ushort deflateHLIT;
	ushort deflateHDIST;
	ushort deflateHCLEN;

	// HOLDS THE BIT LENGTH OF THE CODE
	ubyte deflateCodeLengths[19];

	// COUNTS HOW MANY OF EACH LENGTH HAVE BEEN FOUND
	ubyte deflateCodeLengthCount[7];

	// THE HUFFMAN TABLE FOR CODE LENGTHS //
	_huffman_table deflateCodeLengthTable;

	// THE MINIMUM CODE SIZE FOR A CODE LENGTH CODE //
	ushort deflateCodeLengthCodeSize = 1;
	ushort deflateDistanceCodeLengthCodeSize = 1;

	// FOR HUFFMAN TABLE FOR ACTUAL CODES //
	ubyte deflateHuffmanLengths[288];
	ubyte deflateDistanceLengths[32];

	ushort deflateHuffmanLengthCounts[16];
	ushort deflateDistanceLengthCounts[16];

	ushort* deflateCurLengthCountArray;
	ubyte* deflateCurLengthArray;



	ushort deflateHuffmanTable[578];
	ushort deflateDistanceTable[68];

	ushort deflateHuffmanNextCodes[16]; //nextcode
	//ushort v[16]; //blcount

	ushort deflateTreePosition;

public:
	StreamData decode(Stream stream, Stream toStream) {
		uint counter;

		for (;;) {
			switch (decoderState) {

				// INIT DECODER //
			case DEFLATE_STATE_INIT:

				//writeln("deflate start");

				//////OutputDebugStringA("initing structure\n");


				// READ THE FIRST BYTE OF THE STREAM

				deflateCurValue = 0;
				deflateCurValueBit = 0;
				deflateLastState = DEFLATE_STATE_READ_BFINAL;

				decoderState = DEFLATE_STATE_READ_BYTE;
				decoderNextState = DEFLATE_STATE_READ_BIT;

				//////OutputDebugString(String(stream.getRemaining()) + S("\n"));




				// READS A BYTE FROM THE STREAM //

			case DEFLATE_STATE_READ_BYTE:

				//writeln("read byte", stream.length());

				if (!(stream.read(deflateCurByte))) {
					return StreamData.Required;
				}
				//writeln("read byte teres");

				//////OutputDebugString(StringUtil::GetHexFromInt(deflateCurByte));

				deflateCurMask = 1; // 10000000
				deflateCurBit = 0;

				decoderState = decoderNextState;
				///writeln("read byte done");

				continue;


				// READS A SEQUENCE OF BITS FROM THE STREAM //

			case DEFLATE_STATE_READ_BITS:

				if (deflateCurMask == 0) {
					// get the next byte from the stream
					decoderState = DEFLATE_STATE_READ_BYTE;
					decoderNextState = DEFLATE_STATE_READ_BITS;
					continue;
				}

				if (deflateCurByte & deflateCurMask) {
					//////OutputDebugString(String(deflateCurValue) + S("\n"));
					//////OutputDebugString(String(deflateCurBit) + S(" - ") + String(deflateCurValueBit) + S("\n"));
					if (deflateCurBit > deflateCurValueBit) {
						deflateCurValue |= ((deflateCurByte & deflateCurMask) >> (deflateCurBit - deflateCurValueBit));
					}
					else if (deflateCurBit == deflateCurValueBit) {
						deflateCurValue |= (deflateCurByte & deflateCurMask);
					}
					else {
						deflateCurValue |= ((deflateCurByte & deflateCurMask) << (deflateCurValueBit - deflateCurBit));
					}

					//////OutputDebugStringA("deflate - read bit: 1\n");
					//////OutputDebugString(String(deflateCurValue) + S("\n"));
				}
				else {
					//////OutputDebugStringA("deflate - read bit: 0\n");
				}

				deflateCurMask <<= 1;

				deflateBitsLeft--;
				deflateCurBit++;
				deflateCurValueBit++;

				if (deflateBitsLeft == 0) {
					decoderState = deflateLastState;
				}

				continue;

			case DEFLATE_STATE_READ_BIT:

				//writeln("read bit");
				if (deflateCurMask == 0) {
					// get the next byte from the stream
					decoderState = DEFLATE_STATE_READ_BYTE;
					decoderNextState = DEFLATE_STATE_READ_BIT;
				//writeln("read bit (break)");
					continue;
				}

				if (deflateCurByte & deflateCurMask) {
					if (deflateCurBit > deflateCurValueBit) {
						deflateCurValue |= ((deflateCurByte & deflateCurMask) >> (deflateCurBit - deflateCurValueBit));
					}
					else if (deflateCurBit == deflateCurValueBit) {
						deflateCurValue |= (deflateCurByte & deflateCurMask);
					}
					else {
						deflateCurValue |= ((deflateCurByte & deflateCurMask) << (deflateCurValueBit - deflateCurBit));
					}

					//////OutputDebugStringA("deflate - read bit: 1\n");
				}
				else {
					//////OutputDebugStringA("deflate - read bit: 0\n");
				}

				deflateCurMask <<= 1;
				deflateCurBit++;
				deflateCurValueBit++;

				decoderState = deflateLastState;
				//writeln("read bit done");

				continue;













				// READS A SEQUENCE OF BITS FROM THE STREAM //
				// READS FROM MSB //

			case DEFLATE_STATE_READ_BITS_REV:

				if (deflateCurMask == 0) {
					// get the next byte from the stream
					decoderState = DEFLATE_STATE_READ_BYTE;
					decoderNextState = DEFLATE_STATE_READ_BITS_REV;
					continue;
				}

				deflateCurValue <<= 1;

				if (deflateCurByte & deflateCurMask) {
					deflateCurValue++;
					//////OutputDebugStringA("deflate - read bit: 1\n");
					//////OutputDebugString(String(deflateCurValue) + S("\n"));
				}
				else {
					//////OutputDebugStringA("deflate - read bit: 0\n");
				}

				deflateCurMask <<= 1;
				deflateCurBit++;

				deflateBitsLeft--;

				if (deflateBitsLeft == 0) {
					decoderState = deflateLastState;
				}

				continue;

			case DEFLATE_STATE_READ_BIT_REV:

				if (deflateCurMask == 0) {
					// get the next byte from the stream
					decoderState = DEFLATE_STATE_READ_BYTE;
					decoderNextState = DEFLATE_STATE_READ_BIT_REV;
					continue;
				}

				deflateCurValue <<= 1;

				if (deflateCurByte & deflateCurMask) {
					deflateCurValue++;
					//////OutputDebugStringA("deflate - read bit: 1\n");
					//////OutputDebugString(String(deflateCurValue) + S("\n"));
				}
				else {
					//////OutputDebugStringA("deflate - read bit: 0\n");
				}
				//////OutputDebugString(String(deflateCurValue) + S(": code\n"));

				deflateCurMask <<= 1;
				deflateCurBit++;

				deflateBitsLeft--;

				decoderState = deflateLastState;

				continue;












				// READ THE BLOCK'S BFINAL //

				// THE BFINAL DENOTES WHETHER THIS IS THE LAST BLOCK //

				// THIS VALUE IS IN CURVALUE //

			case DEFLATE_STATE_READ_BFINAL:

				deflateCurBlock.deflateIsLastBlock = deflateCurValue;

				if (deflateCurBlock.deflateIsLastBlock) {
					//////OutputDebugStringA("deflate - this is final block\n");
				}
				else {
					//////OutputDebugStringA("deflate - this is not the final block\n");
				}

				decoderState = DEFLATE_STATE_READ_BITS;

				deflateLastState = DEFLATE_STATE_READ_BTYPE;

				deflateCurValue = 0;
				deflateCurValueBit = 0;

				deflateBitsLeft = 2;

				continue;


				// READ THE BLOCK'S BTYPE //
				// BTYPE - DENOTES THE TYPE OF COMPRESSION //
			case DEFLATE_STATE_READ_BTYPE:

				//////OutputDebugStringA("deflate - read BTYPE\n");

				deflateCurBlock.deflateBlockType = deflateCurValue;

				// RESET CUR VALUE, WE USE THIS
				deflateCurValue = 0;
				deflateCurValueBit = 0;

				switch (deflateCurBlock.deflateBlockType) {

					// NO COMPRESSION INIT //
				case DEFLATE_COMPRESSION_NO_COMPRESSION:
					//write("deflate - block compression: NONE\n");

					// WILL REALIGN TO BYTE BOUNDARY AND THEN DECODE //
					decoderState = DEFLATE_STATE_DEFLATE_NO_COMPRESSION;

					break;



					// FIXED-HUFFMAN INIT //
				case DEFLATE_COMPRESSION_FIXED_HUFFMAN:
					//write("deflate - block compression: Fixed-Huffman\n");

					deflateCurHuffmanTable = cast(_huffman_table*)&deflateFixedHuffmanTable;

					// READ IN 7 BITS, THE MINIMUM CODE SIZE FOR FIXED-HUFFMAN TABLE
					deflateCurValue = 0;
					deflateCurValueBit = 0;
					deflateCurHuffmanBitLength = 6;
					deflateCurHuffmanEntry = &deflateCurHuffmanTable.huffman_entries[deflateCurHuffmanBitLength];

					deflateBitsLeft = 7;
					decoderState = DEFLATE_STATE_READ_BITS_REV;
					deflateLastState = DEFLATE_STATE_DEFLATE_FIXED_CHECK_CODE;
					break;



				case DEFLATE_COMPRESSION_DYNAMIC_HUFFMAN:
					//write("deflate - block compression: Dynamic Huffman\n");

					deflateLastState = DEFLATE_STATE_DEFLATE_DYNAMIC_COMPRESSION;
					deflateBitsLeft = 5;
					decoderState = DEFLATE_STATE_READ_BITS;
					break;



				default:
					return StreamData.Invalid;
				}

				continue;

				// DECODER FOR 'NO COMPRESSION' TYPE (BTYPE == 0) //

				// GET LEN
				// LEN - NUMBER OF DATA BYTES IN THE BLOCK

			case DEFLATE_STATE_DEFLATE_NO_COMPRESSION:
				////OutputDebugStringA("deflate - decoding (no compression)\n");

				// GET THE DATA LENGTH
				if (!(stream.read(&deflateDataLength, 2))) {
					return StreamData.Required;
				}

				deflateDataLength = FromLittleEndian16(deflateDataLength);

				decoderState = DEFLATE_STATE_DEFLATE_NO_COMPRESSION_SKIP;

				// SKIP NLEN //
			case DEFLATE_STATE_DEFLATE_NO_COMPRESSION_SKIP:

				if (!(stream.skip(2))) {
					return StreamData.Required;
				}

				////OutputDebugStringA("deflate - copying data\n");

				decoderState = DEFLATE_STATE_DEFLATE_NO_COMPRESSION_COPY;

			case DEFLATE_STATE_DEFLATE_NO_COMPRESSION_COPY:

				if (!(toStream.append(stream, deflateDataLength))) {
					return StreamData.Required;
				}

				////OutputDebugStringA("deflate - block decompression done\n");

				if (deflateCurBlock.deflateIsLastBlock) {
					////OutputDebugStringA("deflate - decompression done\n");
	//				writeln("deflate - copy - done");
					return StreamData.Complete;
				}

				// READ ANOTHER BLOCK HEADER

				deflateCurValue = 0;
				deflateCurValueBit = 0;
				deflateLastState = DEFLATE_STATE_READ_BFINAL;

				decoderState = DEFLATE_STATE_READ_BIT;



				continue;










				// DECODER FOR 'FIXED-HUFFMAN' COMPRESSION TYPE //

				// DETERMINE IF CODE IS WITHIN HUFFMAN TABLES
				// OTHERWISE, ADD A BIT
				// UNLESS CURRENT BIT IS THE 7th BIT
			case DEFLATE_STATE_DEFLATE_FIXED_CHECK_CODE:

				for (deflateCounter = 0; deflateCounter < deflateCurHuffmanEntry.huffmanRangesCount; deflateCounter++) {
					if ( (deflateCurValue >= deflateCurHuffmanEntry.huffmanRanges[deflateCounter].huffmanMinorCode) &&
						 (deflateCurValue <= deflateCurHuffmanEntry.huffmanRanges[deflateCounter].huffmanMajorCode) ) {
						// THIS IS A VALID CODE
						// GET THE DECODED LITERAL VALUE

						deflateCurCode = deflateCurValue - deflateCurHuffmanEntry.huffmanRanges[deflateCounter].huffmanMinorCode;
						deflateCurCode += deflateCurHuffmanEntry.huffmanRanges[deflateCounter]._huffman_base;

						if (deflateCurCode < 256) {
							// IT IS A LITERAL CODE

							// ADD CODE TO OUTPUT STREAM
							toStream.append(cast(ubyte)deflateCurCode);
							//////OutputDebugString(S("output: ") + String(deflateCurCode) + S("\n"));

							// RETURN TO GATHER ANOTHER CODE
							deflateCurValue = 0;
							deflateCurValueBit = 0;
							deflateCurHuffmanBitLength = 6;
							deflateCurHuffmanEntry = &deflateCurHuffmanTable.huffman_entries[deflateCurHuffmanBitLength];

							deflateBitsLeft = 7;
							decoderState = DEFLATE_STATE_READ_BITS_REV;
							deflateLastState = DEFLATE_STATE_DEFLATE_FIXED_CHECK_CODE;

							//////OutputDebugString(S("deflate - code found: ") + String(deflateCurCode) + S("\n"));

						}
						else if (deflateCurCode == 256) {
							// END OF BLOCK CODE

							// RETURN TO GATHERING BLOCKS
							// IF THIS IS NOT THE LAST BLOCK

							////OutputDebugString(S("deflate - end of code found: ") + String(deflateCurCode) + S("\n"));

							if (deflateCurBlock.deflateIsLastBlock) {
	//							writeln("deflate - fixed - done");
								return StreamData.Complete;
							}

							// READ ANOTHER BLOCK HEADER

							deflateCurValue = 0;
							deflateCurValueBit = 0;
							deflateLastState = DEFLATE_STATE_READ_BFINAL;

							decoderState = DEFLATE_STATE_READ_BIT;
						}
						else {
							// LENGTH CODE

							// CALCULATE THE TRUE LENGTH

							//////OutputDebugString(S("deflate - length code found: ") + String(deflateCurCode) + S("\n"));

							deflateLength = deflateLengthTable[deflateCurCode - 257].deflateLengthBase;


							deflateCurValue = 0;
							deflateCurValueBit = 0;

							if (deflateLengthTable[deflateCurCode - 257].deflateLengthExtraBits > 0) {
								decoderState = DEFLATE_STATE_READ_BITS;
								deflateBitsLeft = deflateLengthTable[deflateCurCode - 257].deflateLengthExtraBits;
								deflateLastState = DEFLATE_STATE_DEFLATE_FIXED_GET_LENGTH;
							}
							else {
								// WE HAVE THE LENGTH, FIND THE DISTANCE

								// IN FIXED-HUFFMAN, THE DISTANCE IS A FIXED 5 BIT VALUE, PLUS ANY EXTRA BITS
								// GIVEN IN THE TABLE FOR DISTANCE CODES
								decoderState = DEFLATE_STATE_READ_BITS_REV;
								deflateBitsLeft = 5;
								deflateLastState = DEFLATE_STATE_DEFLATE_FIXED_GET_DISTANCE;
							}
						}

						break;
					}
				}
				if (decoderState == DEFLATE_STATE_DEFLATE_FIXED_CHECK_CODE) {
					//////OutputDebugStringA("deflate - Huffman code not found, reading another bit\n");
					// READ IN ANOTHER BIT
					// INCREMENT HUFFMAN ENTRY COUNTER
					deflateCurHuffmanEntry++;
					deflateCurHuffmanBitLength++;

					decoderState = DEFLATE_STATE_READ_BIT_REV;

					if (deflateCurHuffmanBitLength == 16) {
						//////OutputDebugStringA("deflate - Huffman maximum code length exceeded\n");
						return StreamData.Invalid;
					}
				}

				continue;








				// INTERPRET THE RESULT OF THE EXTRA BITS //
				// CALCULATE THE TRUE LENGTH //
			case DEFLATE_STATE_DEFLATE_FIXED_GET_LENGTH:

				deflateLength += deflateCurValue;

				//////OutputDebugString(S("deflate - calculated length: ") + String(deflateLength) + S("\n"));

				// FIND DISTANCE

				// IN FIXED-HUFFMAN, THE DISTANCE IS A FIXED 5 BIT VALUE, PLUS ANY EXTRA BITS
				// GIVEN IN THE TABLE FOR DISTANCE CODES
				deflateBitsLeft = 5;

				deflateCurValue = 0;
				deflateCurValueBit = 0;

				decoderState = DEFLATE_STATE_READ_BITS_REV;
				deflateLastState = DEFLATE_STATE_DEFLATE_FIXED_GET_DISTANCE;

				continue;

				// CALCULATE DISTANCE //

				// CURVALUE IS THE ROOT DISTANCE //
			case DEFLATE_STATE_DEFLATE_FIXED_GET_DISTANCE:

				deflateDistance = globalDeflateDistanceTable[deflateCurValue].deflateLengthBase;
				//////OutputDebugString(S("deflate - distance base: ") + String(deflateDistance) + S("\n"));

				if (globalDeflateDistanceTable[deflateCurValue].deflateLengthExtraBits > 0) {
					decoderState = DEFLATE_STATE_READ_BITS;

					deflateBitsLeft = globalDeflateDistanceTable[deflateCurValue].deflateLengthExtraBits;
					deflateLastState = DEFLATE_STATE_DEFLATE_FIXED_GET_DISTANCE_EX;

					deflateCurValue = 0;
					deflateCurValueBit = 0;
				}
				else {
					// THE DISTANCE REQUIRES NO OTHER INPUT

					// ADD TO THE DATA STREAM BY USING INTERPRET STATE

					// RETURN TO GATHER ANOTHER CODE
					deflateCurValue = 0;
					deflateCurValueBit = 0;
					deflateCurHuffmanBitLength = 6;
					deflateCurHuffmanEntry = &deflateCurHuffmanTable.huffman_entries[deflateCurHuffmanBitLength];

					deflateBitsLeft = 7;
					decoderState = DEFLATE_STATE_READ_BITS_REV;
					deflateLastState = DEFLATE_STATE_DEFLATE_FIXED_CHECK_CODE;

					//////OutputDebugString(S("deflate - code found: <len ") + String(deflateLength) + S(", dis ") + String(deflateDistance) + S(">\n"));

					if (!toStream.duplicateFromEnd(deflateDistance, deflateLength)) {
						//////OutputDebugStringA("deflate - corrupt data - distance, length forced decoder out of range\n");
						return StreamData.Invalid;
					}
				}

				continue;


				// CURVALUE IS THE EXTRA BITS FOR DISTANCE
			case DEFLATE_STATE_DEFLATE_FIXED_GET_DISTANCE_EX:

				deflateDistance += deflateCurValue;

				// ADD TO THE DATA STREAM BY USING INTERPRET STATE

				// RETURN TO GATHER ANOTHER CODE
				deflateCurValue = 0;
				deflateCurValueBit = 0;
				deflateCurHuffmanBitLength = 6;
				deflateCurHuffmanEntry = &deflateCurHuffmanTable.huffman_entries[deflateCurHuffmanBitLength];

				deflateBitsLeft = 7;
				decoderState = DEFLATE_STATE_READ_BITS_REV;
				deflateLastState = DEFLATE_STATE_DEFLATE_FIXED_CHECK_CODE;

				//////OutputDebugString(S("deflate - code found: <len ") + String(deflateLength) + S(", dis ") + String(deflateDistance) + S(">\n"));

				if (!toStream.duplicateFromEnd(deflateDistance, deflateLength)) {
					//////OutputDebugStringA("deflate - corrupt data - distance, length forced decoder out of range\n");
					return StreamData.Invalid;
				}

				//////OutputDebugString(S("deflate - code found: <len ") + String(deflateLength) + S(", dis ") + String(deflateDistance) + S(">\n"));

				continue;











				// CURVALUE HAS HLIT //
			case DEFLATE_STATE_DEFLATE_DYNAMIC_COMPRESSION:

				//----writeln("deflate dynamic");

				deflateHLIT = cast(ushort)deflateCurValue;

				////OutputDebugString(S("HLIT: ") + String(deflateHLIT) + S("\n"));

				// INITIALIZE CODE LENGTH HUFFMAN TABLE
				for (deflateCounter=0; deflateCounter < 16; deflateCounter++) {
					deflateCodeLengthTable.huffman_entries[deflateCounter].huffmanRangesCount = 0;
				}

				// INITIALIZE THE CODE LENGTH COUNT
				for (deflateCounter=0; deflateCounter < 7; deflateCounter++) {
					deflateCodeLengthCount[deflateCounter] = 0;
				}

				for (deflateCounter=0; deflateCounter < 8; deflateCounter++) {
					deflateHuffmanLengthCounts[deflateCounter] = 0;
				}

				deflateBitsLeft = 5;
				decoderState = DEFLATE_STATE_READ_BITS;
				deflateLastState = DEFLATE_STATE_DEFLATE_DYNAMIC_HDIST;
				deflateCurValue = 0;
				deflateCurValueBit = 0;

				continue;

			case DEFLATE_STATE_DEFLATE_DYNAMIC_HDIST:
				//----writeln("deflate dynamic hdist");

				deflateHDIST = cast(ushort)deflateCurValue;

				//////OutputDebugString(S("HDIST: ") + String(deflateHDIST));

				deflateBitsLeft = 4;
				decoderState = DEFLATE_STATE_READ_BITS;
				deflateLastState = DEFLATE_STATE_DEFLATE_DYNAMIC_HCLEN;
				deflateCurValue = 0;
				deflateCurValueBit = 0;

				continue;

			case DEFLATE_STATE_DEFLATE_DYNAMIC_HCLEN:
				//----writeln("deflate dynamic hclen");

				deflateHCLEN = cast(ushort)deflateCurValue;

				////OutputDebugString(S("HCLEN: ") + String(deflateHCLEN) + S("\n"));

				////OutputDebugString(String(deflateHLIT) + S(", ") + String(deflateHDIST) + S(", ") + String(deflateHCLEN) + S("\n"));

				// get (HCLEN + 4) number of 3 bit values: these correspond to the code lengths for the code length alphabet
				// holy freaking confusing!
				deflateCounterMax = deflateHCLEN + 4;
				deflateCounter = 0;

				deflateBitsLeft = 3;
				decoderState = DEFLATE_STATE_READ_BITS;
				deflateLastState = DEFLATE_STATE_DEFLATE_DYNAMIC_GET_CODE_LEN;
				deflateCurValue = 0;
				deflateCurValueBit = 0;

				continue;

				// CURVALUE HOLDS THE NEXT CODE LENGTH //
			case DEFLATE_STATE_DEFLATE_DYNAMIC_GET_CODE_LEN:
				//----writeln("deflate dynamic get code len");

				deflateCodeLengths[deflateCodeLengthsReference[deflateCounter]] = cast(ubyte)deflateCurValue;

				if (deflateCurValue != 0) {
					deflateCodeLengthCount[deflateCurValue-1]++;
				}

				//////OutputDebugString(String(deflateCurValue) + S(" !!! \n"));
				deflateHuffmanLengthCounts[deflateCurValue]++;

				//////OutputDebugString(S("deflate - first tree - code length: ") + String(deflateCurValue) + S("\n"));

				deflateCurValue = 0;
				deflateCurValueBit = 0;

				deflateCounter++;

				if (deflateCounter != deflateCounterMax) {
					// READ 3 MORE BITS
					deflateBitsLeft = 3;
					decoderState = DEFLATE_STATE_READ_BITS;
				}
				else {
					for ( ; deflateCounter < 19; deflateCounter++) {
						deflateCodeLengths[deflateCodeLengthsReference[deflateCounter]] = 0;
						deflateHuffmanLengthCounts[0]++;
					}

					for (deflateCounter = 0; deflateCounter < 578; deflateCounter++) {
						deflateHuffmanTable[deflateCounter] = 0xFFFF;
					}



					// BUILD CODE LENGTH TREE
					//////OutputDebugString(S("1: ") + String(deflateCodeLengthCount[0]) + S("\n"));




					uint pos, pos_exp, filled;
					ubyte bit;

					deflateCounter = 0;

					deflateHuffmanNextCodes[0] = 0;
					//////OutputDebugString(String(deflateHuffmanLengthCounts[0]) + S(" <-- len\n"));
					//////OutputDebugString(String(deflateHuffmanNextCodes[0]) + S("\n"));

					uint p,o,curentry;

					for ( p=1; p < 16; p++) {
						//////OutputDebugString(String(deflateHuffmanLengthCounts[p]) + S(" <-- len\n"));
						deflateHuffmanNextCodes[p] = cast(ushort)((deflateHuffmanNextCodes[p-1] + deflateHuffmanLengthCounts[p-1]) * 2);
						//////OutputDebugString(String(deflateHuffmanNextCodes[p]) + S(" <-- next code\n"));
					}

					pos = 0;
					filled = 0;

					for ( ; deflateCounter < 19; deflateCounter++) {
						//////OutputDebugString(String(deflateCounter) + S(": (") + String(deflateCodeLengths[deflateCounter]) + S(") ") + String(deflateHuffmanNextCodes[deflateCodeLengths[deflateCounter]]) + S("\n"));
						curentry = deflateHuffmanNextCodes[deflateCodeLengths[deflateCounter]]++;


						//////OutputDebugString(S("start - ") + String(pos) + S(",,, ") + String(deflateCodeLengths[deflateCounter]) + S("\n"));

						// GO THROUGH EVERY BIT
						for (o=0; o < deflateCodeLengths[deflateCounter]; o++) {
							bit = cast(ubyte)((curentry >> (deflateCodeLengths[deflateCounter] - o - 1)) & 1);

							pos_exp = (2 * pos) + bit;
						//////OutputDebugString(S("pos_exp - ") + String(pos_exp) + S("\n"));


							if ((o + 1) > (19 - 2)) {
								//////OutputDebugStringA("error - tree is mishaped\n");
							}
							else if (deflateHuffmanTable[pos_exp] == 0xFFFF) {
								//////OutputDebugStringA("not in tree\n");
								// IS THIS THE LAST BIT?
								if (o + 1 == deflateCodeLengths[deflateCounter]) {
									// JUST OUTPUT THE CODE
									//////OutputDebugString(S(":") + String(pos_exp) + S(": ") + String(deflateCounter) + S(" (code)\n"));

									deflateHuffmanTable[pos_exp] = cast(ushort)deflateCounter;

									pos = 0;
								}
								else {
									filled++;
									//////OutputDebugString(S(":") + String(pos_exp) + S(": ") + String(filled + 19) + S(" (address)\n"));
									deflateHuffmanTable[pos_exp] = cast(ushort)(filled + 19);
									pos = filled;
								}
							}
							else {
								//////OutputDebugStringA("is in tree\n");
								pos = deflateHuffmanTable[pos_exp] - 19;
								//////OutputDebugString(S("now - ") + String(pos) + S("\n"));
							}
						}
					}

					p=0;

					// table is built

					// decode code lengths

					deflateCounter = 0;
					deflateCounterMax = deflateHLIT + 257;

					for (counter=0; counter<16; counter++) {
						deflateHuffmanLengthCounts[counter] = 0;
						deflateDistanceLengthCounts[counter] = 0;
					}

					deflateLastState = DEFLATE_STATE_DEFLATE_DYNAMIC_DECODE_LENS;

					//////OutputDebugString(S("deflate - minimum code length: ") + String(deflateCodeLengthCodeSize) + S("\n"));

					//----writeln(deflateCodeLengthCodeSize-1);

					deflateCurHuffmanTable = &deflateCodeLengthTable;
					deflateCurHuffmanEntry = &deflateCodeLengthTable.huffman_entries[deflateCodeLengthCodeSize-1];

					deflateBitsLeft = deflateCodeLengthCodeSize;
					deflateCurHuffmanBitLength = deflateCodeLengthCodeSize;

					deflateCurLengthArray = deflateHuffmanLengths.ptr;
					deflateCurLengthCountArray = deflateHuffmanLengthCounts.ptr;

					decoderState = DEFLATE_STATE_DEFLATE_DYNAMIC_DECODE_LENS;

					////OutputDebugStringA("deflate - length tree built\n");

					deflateCurValue = 0;
					deflateCurValueBit = 0;

					deflateTreePosition = 0;
				}

				continue;




				// USE THE CODE LENGTH TABLE TO DECODE THE LENGTH DATA FOR THE REGULAR CODE TREE //

				// CURVALUE IS THE CURRENT CODE //
			case DEFLATE_STATE_DEFLATE_DYNAMIC_DECODE_LENS:
				//----writeln("deflate dynamic decode lens");

				// GET BIT

				//////OutputDebugStringA("deflate - decoding lengths\n");

				if (deflateCurMask == 0) {
					// get the next byte from the stream
					decoderState = DEFLATE_STATE_READ_BYTE;
					decoderNextState = DEFLATE_STATE_DEFLATE_DYNAMIC_DECODE_LENS;
					continue;
				}

				if (deflateCurByte & deflateCurMask) {
					deflateCurValue = 1;
					//////OutputDebugStringA("deflate - read bit: 1\n");
				}
				else {
					deflateCurValue = 0;
					//////OutputDebugStringA("deflate - read bit: 0\n");
				}

				deflateCurMask <<= 1;
				deflateCurBit++;

				// CHECK IN TREE
				if(deflateTreePosition >= 19) {
					////OutputDebugStringA("deflate - corrupt data\n");
					return StreamData.Invalid;
				}

				deflateCurCode = deflateHuffmanTable[(2 * deflateTreePosition) + deflateCurValue];

				if (deflateCurCode < 19) {
					deflateTreePosition = 0;
				}
				else {
					deflateTreePosition = cast(ushort)(deflateCurCode - 19);
				}

				if (deflateTreePosition == 0) {
					//////OutputDebugStringA("deflate - found length code: ");
					//////OutputDebugString(String(deflateCurCode) + S("\n"));

					// INTERPRET CODE

					if (deflateCurCode < 16) {
						// 0...15 - LITERAL LENGTHS //

						// JUST INSERT INTO ARRAY
						deflateCurLengthArray[deflateCounter] = cast(ubyte)deflateCurCode;

						deflateCurLengthCountArray[deflateCurCode]++;

						deflateCounter++;

						if (deflateCounter == deflateCounterMax)
						{
							// WE HAVE GOTTEN THE MAXIMUM CODES WE WERE SUPPOSED TO FIND //

							// WE HAVE TO DECODE THE DISTANCE ARRAY, OR THE TREE NOW
							decoderState = DEFLATE_STATE_DEFLATE_DYNAMIC_DECODE_DIST;
							continue;
						}

						// READ ANOTHER CODE
						deflateCurValue = 0;
						deflateCurValueBit = 0;

						deflateCurHuffmanTable = &deflateCodeLengthTable;
						deflateCurHuffmanEntry = &deflateCodeLengthTable.huffman_entries[0];

						deflateBitsLeft = 1;//deflateCodeLengthCodeSize;
						deflateCurHuffmanBitLength = 1;//deflateCodeLengthCodeSize;

						//decoderState = DEFLATE_STATE_READ_BITS_REV;
					}
					else if (deflateCurCode == 16) {

						// COPY PREVIOUS LENGTH 3 - 6 TIMES //
						// NEXT TWO [2] BITS DETERMINE LENGTH ( bits[2] + 3 ) //

						deflateCurValue = 0;
						deflateCurValueBit = 0;

						deflateBitsLeft = 2;
						decoderState = DEFLATE_STATE_READ_BITS;
						deflateLastState = DEFLATE_STATE_DEFLATE_DYNAMIC_DECODE_LEN16;
						continue;
					}
					else if (deflateCurCode == 17) {
						// REPEAT CODE LENGTH OF 0 FOR 3 - 10 TIMES
						// NEXT THREE [3] BITS DETERMINE LENGTH //

						deflateCurValue = 0;
						deflateCurValueBit = 0;

						deflateBitsLeft = 3;
						decoderState = DEFLATE_STATE_READ_BITS;
						deflateLastState = DEFLATE_STATE_DEFLATE_DYNAMIC_DECODE_LEN17;
						continue;
					}
					else if (deflateCurCode == 18) {
						// REPEAT CODE LENGTH OF 0 FOR 11 - 138 TIMES
						// NEXT SEVEN [7] BITS DETERMINE LENGTH //

						deflateCurValue = 0;
						deflateCurValueBit = 0;

						deflateBitsLeft = 7;
						decoderState = DEFLATE_STATE_READ_BITS;
						deflateLastState = DEFLATE_STATE_DEFLATE_DYNAMIC_DECODE_LEN18;
						continue;
					}
				}

				continue;

				// INTERPRET LENGTH CODE 16
			case DEFLATE_STATE_DEFLATE_DYNAMIC_DECODE_LEN16:
				//----writeln("deflate dynamic decode len16");

				// TAKE LAST CODE AND REPEAT 'CURVALUE' + 3 TIMES

				deflateCurValue += 3;

				//////OutputDebugString(String(deflateCurValue) + S("\n"));

				if (deflateCounter != 0) {
					deflateCurCode = deflateCurLengthArray[deflateCounter-1];
				}
				else {
					////OutputDebugStringA("deflate - corrupt data\n");
					return StreamData.Invalid;
				}

				deflateLastState = DEFLATE_STATE_DEFLATE_DYNAMIC_DECODE_LENS;

				deflateCurHuffmanTable = &deflateCodeLengthTable;
				deflateCurHuffmanEntry = &deflateCodeLengthTable.huffman_entries[0];

				deflateBitsLeft = 1;//deflateCodeLengthCodeSize;
				deflateCurHuffmanBitLength = 1;//deflateCodeLengthCodeSize;

				decoderState = DEFLATE_STATE_DEFLATE_DYNAMIC_DECODE_LENS;

				for (counter=0 ; counter<deflateCurValue; counter++) {
					deflateCurLengthArray[deflateCounter] = cast(ubyte)deflateCurCode;
					deflateCurLengthCountArray[deflateCurCode]++;

					deflateCounter++;

					if (deflateCounter == deflateCounterMax) {
						// WE CANNOT REPEAT THE VALUE

						decoderState = DEFLATE_STATE_DEFLATE_DYNAMIC_DECODE_DIST;
						break;
					}
				}

				deflateCurValue = 0;
				deflateCurValueBit = 0;

				continue;

				// INTERPRET LENGTH CODE 17, 18
			case DEFLATE_STATE_DEFLATE_DYNAMIC_DECODE_LEN18:
				//----writeln("deflate dynamic decode len18");

				deflateCurValue += 8;

			case DEFLATE_STATE_DEFLATE_DYNAMIC_DECODE_LEN17:
				//----writeln("deflate dynamic decode len17");

				deflateCurValue += 3;

				//////OutputDebugString(String(deflateCurValue) + S("\n"));

				// TAKE 0 AND REPEAT 'CURVALUE' TIMES

				deflateLastState = DEFLATE_STATE_DEFLATE_DYNAMIC_DECODE_LENS;

				deflateCurHuffmanTable = &deflateCodeLengthTable;
				deflateCurHuffmanEntry = &deflateCodeLengthTable.huffman_entries[0];

				deflateBitsLeft = 1;//deflateCodeLengthCodeSize;
				deflateCurHuffmanBitLength = 1;//deflateCodeLengthCodeSize;

				decoderState = DEFLATE_STATE_DEFLATE_DYNAMIC_DECODE_LENS;

				for (counter=0 ; counter<deflateCurValue; counter++) {
					deflateCurLengthArray[deflateCounter] = 0;
					deflateCurLengthCountArray[0]++;

					deflateCounter++;

					if (deflateCounter == deflateCounterMax) {
						// WE CANNOT REPEAT THE VALUE
						// JUST STOP
						//////OutputDebugStringA("deflate - attempted to write a code out of bounds, continuing anyway\n");

						decoderState = DEFLATE_STATE_DEFLATE_DYNAMIC_DECODE_DIST;
						break;
					}
				}

				deflateCurValue = 0;
				deflateCurValueBit = 0;

				continue;

			case DEFLATE_STATE_DEFLATE_DYNAMIC_DECODE_DIST:
				//----writeln("deflate dynamic decode dist");

				if (deflateCurLengthArray == deflateDistanceLengths.ptr) {
					// FINISH INITIALIZING THE REST OF THE DISTANCE CODE LENGTH ARRAY //

					//write out rest of entries to 0
					for (; deflateCounter < 32; deflateCounter++) {
						deflateDistanceLengths[deflateCounter] = 0;
						deflateDistanceLengthCounts[0]++;
					}

					//for (counter = 0; counter < 32; counter++)
					//{
					//	//////OutputDebugString(S("distance: ") + String(counter+1) + S(": ") + String(deflateDistanceLengths[counter]) + S("\n"));
					//}

					decoderState = DEFLATE_STATE_DEFLATE_DYNAMIC_BUILD_TREE;
					continue;
				}

				// FINISH INITIALIZING THE REST OF THE HUFFMAN CODE LENGTH ARRAY //

				//write out rest of entries to 0
				for (; deflateCounter < 288; deflateCounter++) {
					deflateHuffmanLengths[deflateCounter] = 0;
					deflateHuffmanLengthCounts[0]++;
				}

				//for (counter = 0; counter < 287; counter++)
				//{
				//	//////OutputDebugString(String(counter) + S(": ") + String(deflateHuffmanLengths[counter]) + S("\n"));
				//}

				// NOW INIT THE LENGTH DECODER TO BUILD THE DISTANCE ARRAY
				deflateCounter = 0;
				deflateCounterMax = deflateHDIST + 1;

				deflateLastState = DEFLATE_STATE_DEFLATE_DYNAMIC_DECODE_LENS;

				//////OutputDebugString(S("deflate - minimum code length: ") + String(deflateCodeLengthCodeSize) + S("\n"));

				deflateCurHuffmanTable = &deflateCodeLengthTable;
				deflateCurHuffmanEntry = &deflateCodeLengthTable.huffman_entries[deflateCodeLengthCodeSize-1];

				deflateBitsLeft = deflateCodeLengthCodeSize;
				deflateCurHuffmanBitLength = deflateCodeLengthCodeSize;

				deflateCurLengthArray = deflateDistanceLengths.ptr;
				deflateCurLengthCountArray = deflateDistanceLengthCounts.ptr;

				decoderState = DEFLATE_STATE_DEFLATE_DYNAMIC_DECODE_LENS;

				deflateCurValue = 0;
				deflateCurValueBit = 0;

				continue;

				// BUILD BOTH LENGTH AND DISTANCE CODE TREES
			case DEFLATE_STATE_DEFLATE_DYNAMIC_BUILD_TREE:
				//----writeln("deflate dynamic build tree");

				for (deflateCounter = 0; deflateCounter < 578; deflateCounter++) {
					deflateHuffmanTable[deflateCounter] = 0xFFFF;
				}

				for (deflateCounter = 0; deflateCounter < 68; deflateCounter++) {
					deflateDistanceTable[deflateCounter] = 0xFFFF;
				}



				// BUILD CODE LENGTH TREE
				//////OutputDebugString(S("1: ") + String(deflateCodeLengthCount[0]) + S("\n"));




				uint pos, pos_exp, filled;
				ubyte bit;

				uint p,o,curentry;

				deflateHuffmanNextCodes[0] = 0;
				//////OutputDebugString(String(deflateHuffmanLengthCounts[0]) + S(" <-- len\n"));
				//////OutputDebugString(String(deflateHuffmanNextCodes[0]) + S("\n"));

				for ( p=1; p < 16; p++) {
					//////OutputDebugString(String(deflateHuffmanLengthCounts[p]) + S(" <-- len\n"));
					deflateHuffmanNextCodes[p] = cast(ushort)((deflateHuffmanNextCodes[p-1] + deflateHuffmanLengthCounts[p-1]) * 2);
					//////OutputDebugString(String(deflateHuffmanNextCodes[p]) + S(" <-- next code\n"));
				}

				pos = 0;
				filled = 0;

				deflateCounter = 0;

				for ( ; deflateCounter < 288; deflateCounter++) {
					//////OutputDebugString(String(deflateCounter) + S(": (") + String(deflateHuffmanLengths[deflateCounter]) + S(") ") + String(deflateHuffmanNextCodes[deflateHuffmanLengths[deflateCounter]]) + S("\n"));
					curentry = deflateHuffmanNextCodes[deflateHuffmanLengths[deflateCounter]]++;

					//////OutputDebugStringA("deflate - curentry read\n");

					// GO THROUGH EVERY BIT
					for (o=0; o < deflateHuffmanLengths[deflateCounter]; o++) {
						bit = cast(ubyte)((curentry >> (deflateHuffmanLengths[deflateCounter] - o - 1)) & 1);

						pos_exp = (2 * pos) + bit;

						if ((o + 1) > (288 - 2)) {
							//////OutputDebugStringA("error - tree is mishaped\n");
						}
						else if (deflateHuffmanTable[pos_exp] == 0xFFFF) {
							//////OutputDebugStringA("not in tree\n");
							// IS THIS THE LAST BIT?
							if (o + 1 == deflateHuffmanLengths[deflateCounter]) {
								// JUST OUTPUT THE CODE
								//////OutputDebugString(S(":") + String(pos_exp) + S(": ") + String(deflateCounter) + S(" (code)\n"));

								deflateHuffmanTable[pos_exp] = cast(ushort)deflateCounter;

								pos = 0;
							}
							else {
								filled++;
								//////OutputDebugString(S(":") + String(pos_exp) + S(": ") + String(filled + 288) + S(" (address)\n"));
								deflateHuffmanTable[pos_exp] = cast(ushort)(filled + 288);
								pos = filled;
							}
						}
						else {
							//////OutputDebugStringA("is in tree\n");
							pos = deflateHuffmanTable[pos_exp] - 288;
						}
					}
				}





				deflateHuffmanNextCodes[0] = 0;
				//////OutputDebugString(String(deflateDistanceLengthCounts[0]) + S(" <-- len\n"));
				//////OutputDebugString(String(deflateHuffmanNextCodes[0]) + S("\n"));

				for ( p=1; p < 16; p++) {
					//////OutputDebugString(String(deflateDistanceLengthCounts[p]) + S(" <-- len\n"));
					deflateHuffmanNextCodes[p] = cast(ushort)((deflateHuffmanNextCodes[p-1] + deflateDistanceLengthCounts[p-1]) * 2);
					//////OutputDebugString(String(deflateHuffmanNextCodes[p]) + S(" <-- next code\n"));
				}

				pos = 0;
				filled = 0;

				deflateCounter = 0;

				for ( ; deflateCounter < 32; deflateCounter++) {
					//////OutputDebugString(String(deflateCounter) + S(": (") + String(deflateDistanceLengths[deflateCounter]) + S(") ") + String(deflateHuffmanNextCodes[deflateDistanceLengths[deflateCounter]]) + S("\n"));
					curentry = deflateHuffmanNextCodes[deflateDistanceLengths[deflateCounter]]++;

					//////OutputDebugStringA("deflate - curentry read\n");

					// GO THROUGH EVERY BIT
					for (o=0; o < deflateDistanceLengths[deflateCounter]; o++) {
						bit = cast(ubyte)((curentry >> (deflateDistanceLengths[deflateCounter] - o - 1)) & 1);

						pos_exp = (2 * pos) + bit;

						if ((o + 1) > (32 - 2)) {
							//////OutputDebugStringA("error - tree is mishaped\n");
						}
						else if (deflateDistanceTable[pos_exp] == 0xFFFF) {
							//////OutputDebugStringA("not in tree\n");
							// IS THIS THE LAST BIT?
							if (o + 1 == deflateDistanceLengths[deflateCounter]) {
								// JUST OUTPUT THE CODE
								//////OutputDebugString(S(":") + String(pos_exp) + S(": ") + String(deflateCounter) + S(" (code)\n"));

								deflateDistanceTable[pos_exp] = cast(ushort)deflateCounter;

								pos = 0;
							}
							else {
								filled++;
								//////OutputDebugString(S(":") + String(pos_exp) + S(": ") + String(filled + 32) + S(" (address)\n"));
								deflateDistanceTable[pos_exp] = cast(ushort)(filled + 32);
								pos = filled;
							}
						}
						else {
							//////OutputDebugStringA("is in tree\n");
							pos = deflateDistanceTable[pos_exp] - 32;
						}
					}
				}

				//OutputDebugStringA("deflate - trees built\n");

				//////OutputDebugStringA("deflate - building code trees\n");

				for (counter = 0; counter < 16; counter++) {
					//////OutputDebugString(String(counter+1) + S(" (length): ") + String(deflateHuffmanLengthCounts[counter]) + S("\n"));
				}

				for (counter = 0; counter < 16; counter++) {
					//////OutputDebugString(String(counter+1) + S(" (distance): ") + String(deflateDistanceLengthCounts[counter]) + S("\n"));
				}

				// BUILD CODE LENGTH TREE

				// DECODE

				// INIT HUFFMAN TO MINIUM CODE LENGTH

				//deflateCurValue = 0;
				//deflateCurValueBit = 0;
				//deflateCurHuffmanBitLength = deflateCodeLengthCodeSize-1;
				//deflateCurHuffmanTable = &deflateInternalHuffmanTable;
				//deflateCurHuffmanEntry = &deflateCurHuffmanTable.huffman_entries[deflateCurHuffmanBitLength];

				//deflateBitsLeft = deflateCodeLengthCodeSize;
				decoderState = DEFLATE_STATE_DEFLATE_DYNAMIC_DECODER;
				//deflateLastState = DEFLATE_STATE_DEFLATE_DYNAMIC_DECODER;

				deflateTreePosition = 0;
				//////OutputDebugString(S("1: ") + String(deflateHuffmanLengthCounts[0]) + S("\n"));

				continue;

			case DEFLATE_STATE_DEFLATE_DYNAMIC_DECODER:
				//writeln("deflate dynamic decoder");
				//----writeln("a");
				//////OutputDebugString(S("1: ") + String(deflateHuffmanLengthCounts[0]) + S("\n"));
				// GET BIT

				if (deflateCurMask == 0) {
					// get the next byte from the stream
					decoderState = DEFLATE_STATE_READ_BYTE;
					decoderNextState = DEFLATE_STATE_DEFLATE_DYNAMIC_DECODER;
				//writeln("deflate dynamic decoder done (break)");
					continue;
				}

				if (deflateCurByte & deflateCurMask) {
					deflateCurValue = 1;
					//////OutputDebugStringA("deflate - read bit: 1\n");
				}
				else {
					deflateCurValue = 0;
					//////OutputDebugStringA("deflate - read bit: 0\n");
				}


				deflateCurMask <<= 1;
				deflateCurBit++;

				// CHECK IN TREE
				//if(deflateTreePosition >= numcodes) return 11; //error: you appeared outside the codetree

				deflateCurCode = deflateHuffmanTable[(2 * deflateTreePosition) + deflateCurValue];

				if (deflateCurCode < 288) {
					deflateTreePosition = 0;
				}
				else {
					deflateTreePosition = cast(ushort)(deflateCurCode - 288);
				}


				if (deflateTreePosition == 0) {
					//////OutputDebugStringA("deflate - found code: ");
					//////OutputDebugString(String(deflateCurCode) + S("\n"));

					// INTERPRET CODE

					if (deflateCurCode < 256) {
						// IT IS A LITERAL CODE

						// ADD CODE TO OUTPUT STREAM
						toStream.append(cast(ubyte)deflateCurCode);

						// RETURN TO GATHER ANOTHER CODE

						deflateCurValue = 0;
						deflateCurValueBit = 0;
						deflateCurHuffmanBitLength = deflateCodeLengthCodeSize-1;
						deflateCurHuffmanTable = &deflateInternalHuffmanTable;
						deflateCurHuffmanEntry = &deflateCurHuffmanTable.huffman_entries[deflateCurHuffmanBitLength];

						deflateBitsLeft = deflateCodeLengthCodeSize;
						decoderState = DEFLATE_STATE_DEFLATE_DYNAMIC_DECODER;
						deflateLastState = DEFLATE_STATE_DEFLATE_DYNAMIC_DECODER;

						//////OutputDebugString(S("output: ") + String(deflateCurCode) + S("\n"));

					}
					else if (deflateCurCode == 256) {
						// END OF BLOCK CODE

						// RETURN TO GATHERING BLOCKS
						// IF THIS IS NOT THE LAST BLOCK

						////OutputDebugString(S("deflate - end of code found: ") + String(deflateCurCode) + S("\n"));

						if (deflateCurBlock.deflateIsLastBlock) {
							//////OutputDebugStringA("deflate - done\n");
	//						writeln("deflate - dynamic - done");
				//writeln("deflate dynamic decoder done (return)");
							return StreamData.Complete;
						}

						// READ ANOTHER BLOCK HEADER

						deflateCurValue = 0;
						deflateCurValueBit = 0;
						deflateLastState = DEFLATE_STATE_READ_BFINAL;

						decoderState = DEFLATE_STATE_READ_BIT;
				//writeln("deflate dynamic decoder done (break2)");
						continue;
					}
					else {
						// LENGTH CODE

						// CALCULATE THE TRUE LENGTH

						//////OutputDebugString(S("deflate - length code found: ") + String(deflateCurCode - 257) + S("\n"));

						deflateLength = deflateLengthTable[deflateCurCode - 257].deflateLengthBase;

						deflateCurValue = 0;
						deflateCurValueBit = 0;

						//----writeln("b2");
						if (deflateLengthTable[deflateCurCode - 257].deflateLengthExtraBits > 0) {
							//----writeln("c1");
							//////OutputDebugString(S("deflate - length code reading extra bits: ") + String(deflateLengthTable[deflateCurCode - 257].deflateLengthExtraBits) + S("\n"));
							decoderState = DEFLATE_STATE_READ_BITS;
							deflateBitsLeft = deflateLengthTable[deflateCurCode - 257].deflateLengthExtraBits;
							deflateLastState = DEFLATE_STATE_DEFLATE_DYNAMIC_GET_LENGTH;
						}
						else {
							// WE ALREADY HAVE THE LENGTH, FIND THE DISTANCE
							//////OutputDebugString(S("deflate - length: ") + String(deflateLength) + S("\n"));

							// IN DYNAMIC-HUFFMAN, DISTANCE IS REPRESENTED BY A DIFFERENT HUFFMAN TREE
							decoderState = DEFLATE_STATE_DEFLATE_DYNAMIC_GET_DISTANCE;

							//deflateBitsLeft = deflateDistanceCodeLengthCodeSize;
							//deflateLastState = DEFLATE_STATE_DEFLATE_DYNAMIC_GET_DISTANCE;

							//deflateCurDistanceBitLength = deflateDistanceCodeLengthCodeSize-1;
							//deflateCurDistanceEntry = &deflateInternalDistanceTable.huffman_entries[deflateCurDistanceBitLength];
						}
					}
				}
				//writeln("deflate dynamic decoder done");

				continue;



				// CURVALUE IS THE TOTAL OF THE EXTRA BITS //
			case DEFLATE_STATE_DEFLATE_DYNAMIC_GET_LENGTH:
				//----writeln("deflate dynamic get length");

				deflateLength += deflateCurValue;

				// READ IN DISTANCE CODE
				decoderState = DEFLATE_STATE_DEFLATE_DYNAMIC_GET_DISTANCE;

				deflateCurValue = 0;
				deflateCurValueBit = 0;
				deflateBitsLeft = deflateDistanceCodeLengthCodeSize;
				deflateLastState = DEFLATE_STATE_DEFLATE_DYNAMIC_GET_DISTANCE;

				//deflateCurDistanceBitLength = deflateDistanceCodeLengthCodeSize-1;
				//deflateCurDistanceEntry = &deflateInternalDistanceTable.huffman_entries[deflateCurDistanceBitLength];


				continue;



				// CURVALUE IS THE RESULTING CODE //
				// ENSURE IT IS IN THE HUFFMAN TREE //
				// THEN WE CAN READ THE EXTRA BITS //
				// IF NOT, WE CAN READ ANOTHER BIT //
			case DEFLATE_STATE_DEFLATE_DYNAMIC_GET_DISTANCE:
				//----writeln("deflate dynamic get distance");
				//////OutputDebugStringA("deflate - (distance) input code: ");
				//////OutputDebugString(String(deflateCurValue) + S("\n"));
				// GET BIT

				if (deflateCurMask == 0) {
					// get the next byte from the stream
					decoderState = DEFLATE_STATE_READ_BYTE;
					decoderNextState = DEFLATE_STATE_DEFLATE_DYNAMIC_GET_DISTANCE;
					continue;
				}

				if (deflateCurByte & deflateCurMask) {
					deflateCurValue = 1;
					//////OutputDebugStringA("deflate - read bit: 1\n");
				}
				else {
					deflateCurValue = 0;
					//////OutputDebugStringA("deflate - read bit: 0\n");
				}

				deflateCurMask <<= 1;
				deflateCurBit++;

				// CHECK IN TREE
				//if(deflateTreePosition >= numcodes) return 11; //error: you appeared outside the codetree

				deflateCurCode = deflateDistanceTable[(2 * deflateTreePosition) + deflateCurValue];

				if (deflateCurCode < 32) {
					deflateTreePosition = 0;
				}
				else {
					deflateTreePosition = cast(ushort)(deflateCurCode - 32);
				}

				if (deflateTreePosition == 0) {
					//////OutputDebugStringA("deflate - found distance code: ");
					//////OutputDebugString(String(deflateCurCode) + S("\n"));

					// INTERPRET CODE

					deflateDistance = globalDeflateDistanceTable[deflateCurCode].deflateLengthBase;
					//////OutputDebugString(S("deflate - distance base: ") + String(deflateDistance) + S("\n"));

					if (globalDeflateDistanceTable[deflateCurCode].deflateLengthExtraBits > 0) {
						decoderState = DEFLATE_STATE_READ_BITS;

						deflateBitsLeft = globalDeflateDistanceTable[deflateCurCode].deflateLengthExtraBits;
						deflateLastState = DEFLATE_STATE_DEFLATE_DYNAMIC_GET_DIST_EX;

						deflateCurValue = 0;
						deflateCurValueBit = 0;
					}
					else {
						// THE DISTANCE REQUIRES NO OTHER INPUT

						// ADD TO THE DATA STREAM

						// RETURN TO GET ANOTHER CODE
						//deflateCurValue = 0;
						//deflateCurValueBit = 0;
						//deflateCurHuffmanBitLength = deflateCodeLengthCodeSize-1;
						//deflateCurHuffmanTable = &deflateInternalHuffmanTable;
						//deflateCurHuffmanEntry = &deflateInternalHuffmanTable.huffman_entries[deflateCurHuffmanBitLength];

						//deflateBitsLeft = deflateCodeLengthCodeSize;

						if (!toStream.duplicateFromEnd(deflateDistance, deflateLength)) {
							//////OutputDebugStringA("deflate - corrupt data - distance, length forced decoder out of range\n");
							return StreamData.Invalid;
						}

						decoderState = DEFLATE_STATE_DEFLATE_DYNAMIC_DECODER;

						//////OutputDebugString(S("deflate - code found: len:") + String(deflateLength) + S(" dist: ") + String(deflateDistance) + S("\n"));

						//////OutputDebugString(S("<len ") + String(deflateLength));
						//////OutputDebugString(S(", dis ") + String(deflateDistance) + S(">\n"));

					}
				}

				continue;

				// CURVALUE IS THE RESULT OF THE EXTRA BITS //
			case DEFLATE_STATE_DEFLATE_DYNAMIC_GET_DIST_EX:
				//----writeln("deflate dynamic get dist ex");

				deflateDistance += deflateCurValue;

				deflateCurValue = 0;
				deflateCurValueBit = 0;
				//deflateCurHuffmanBitLength = deflateCodeLengthCodeSize-1;
				//deflateCurHuffmanTable = &deflateInternalHuffmanTable;
				//deflateCurHuffmanEntry = &deflateInternalHuffmanTable.huffman_entries[deflateCurHuffmanBitLength];

				deflateBitsLeft = deflateCodeLengthCodeSize;

				if (!toStream.duplicateFromEnd(deflateDistance, deflateLength)) {
					//////OutputDebugStringA("deflate - corrupt data - distance, length forced decoder out of range\n");
					return StreamData.Invalid;
				}

				decoderState = DEFLATE_STATE_DEFLATE_DYNAMIC_DECODER;

				continue;

			default:
				break;
			}
			break;
		}
		return StreamData.Invalid;
	}

}
