/*
 * mp3.d
 *
 * This file implements the MP3 audio standard.
 *
 * Author: Dave Wilkinson
 *
 */

module codecs.audio.mp3;

import codecs.audio.codec;
import codecs.codec;

import core.stream;
import core.time;
import core.string;

import io.wavelet;
import io.audio;
import io.console;

// initialize the array to zero
typedef double zerodouble = 0.0;

template FromBigEndian(uint input)
{
	version (LittleEndian)
	{
		const auto FromBigEndian = (input >> 24) | ((input >> 8) & 0x0000FF00) | ((input << 8) & 0x00FF0000) | ((input << 24) & 0xFF000000);
	}
	else
	{
		const auto FromBigEndian = input;
	}
}

template FromBigEndianBitIndex32(uint index)
{
	version (LittleEndian)
	{
		const auto FromBigEndianBitIndex32 = ((3 - cast(uint)(index/8)) * 8) + (index % 8);
	}
	else
	{
		const auto FromBigEndianBitIndex32 = index;
	}
}

class MP3Codec : AudioCodec {

	String name() {
		return new String("MPEG Layer 3");
	}
	
	StreamData decode(Stream stream, Wavelet toBuffer, ref AudioInfo wi) {
		for(;;) {
			switch (decoderState) {
				case MP3_STATE_INIT:

					decoderState = MP3_BUFFER_AUDIO;
					
					/* follow through */

					// attempts to find the 12-16 sync bits
					// if it is unsure of the filetype, it will
					// look for only 12 bits (b 1111 1111 1111)
					// if it knows its layer it will search for
					// the sync bits plus that part of the header
				case MP3_BUFFER_AUDIO:

					decoderState = MP3_READ_HEADER;

					// *** fall through *** //

				case MP3_READ_HEADER:
					Console.putln("pos: ", new String("%x", stream.position));

					if (!stream.read(mpeg_header))
					{
						return StreamData.Accepted;
					}

					decoderState = MP3_AMBIGUOUS_SYNC;


					// *** fall through *** //

					// look at the sync bits of the header
					// if they are not correct, shift the header
					// 8 bits and read another byte until the
					// sync bits match

				case MP3_AMBIGUOUS_SYNC:

     				if ((mpeg_header & FromBigEndian!(0xFFFFFF00)) == FromBigEndian!(0x49443300)) {

     					if (id3.signature[0] != 0x49) {
							if (!stream.read((cast(ubyte*)&id3) + 4, id3.sizeof - 4)) {
								return StreamData.Required;
							}

							id3.signature[0] = 0x49;

							id3.ver[0] = cast(ubyte)(mpeg_header & 0xFF);

							// skip the ID3 section
							foreach(b; id3.len) {
								id3length <<= 7;
								b &= 0x7f;
								id3length |= b;
							}

							Console.putln("id3 length: ", new String("%x", id3length));
						}

						if (!stream.skip(id3length)) {
							return StreamData.Required;
						}

						decoderState = MP3_READ_HEADER;
						continue;
					}

					Console.putln("mpeg_header ", new String("%x", mpeg_header)	);

					if ((mpeg_header & MPEG_SYNC_BITS) == MPEG_SYNC_BITS) {
						Console.putln("sync");
						// sync bits found
						//writeln("sync bits found ", stream.getPosition() - 4);

						// pull apart header

						// the header looks like this:

						// SYNCWORD			12 bits
						// ID				1 bit
						// LAYER			2 bits
						// PROTECTION BIT	1 bit
						// BITRATE INDEX	4 bits
						// SAMPLING FREQ	2 bits
						// PADDING BIT		1 bit
						// PRIVATE BIT		1 bit
						// MODE				2 bits
						// MODE EXTENSION	2 bits
						// COPYRIGHT		1 bit
						// ORIGINAL/HOME	1 bit
						// EMPHASIS			2 bits

						header.ID = (mpeg_header & MPEG_ID_BIT ? 1 : 0);
						header.Layer = (mpeg_header & MPEG_LAYER) >> MPEG_LAYER_SHIFT;

						if (header.Layer != 1) {
							return StreamData.Invalid;
						}

						header.Protected = (mpeg_header & MPEG_PROTECTION_BIT ? 1 : 0);
						header.BitrateIndex = (mpeg_header & MPEG_BITRATE_INDEX) >> MPEG_BITRATE_INDEX_SHIFT;
						header.SamplingFrequency = (mpeg_header & MPEG_SAMPLING_FREQ) >> MPEG_SAMPLING_FREQ_SHIFT;
						header.Padding = (mpeg_header & MPEG_PADDING_BIT ? 1 : 0);
						header.Private = (mpeg_header & MPEG_PRIVATE_BIT ? 1 : 0);
						header.Mode = (mpeg_header & MPEG_MODE) >> MPEG_MODE_SHIFT;
						header.ModeExtension = (mpeg_header & MPEG_MODE_EXTENSION) >> MPEG_MODE_EXTENSION_SHIFT;
						header.Copyright = (mpeg_header & MPEG_COPYRIGHT ? 1 : 0);
						header.Original = (mpeg_header & MPEG_ORIGINAL ? 1 : 0);
						header.Emphasis = (mpeg_header & MPEG_EMPHASIS) >> MPEG_EMPHASIS_SHIFT;

						Console.putln("Header: ", mpeg_header & MPEG_SYNC_BITS, "\n",
								"ID: ", header.ID, "\n",
								"Layer: ", header.Layer, "\n",
								"Protected: ", header.Protected, "\n",
								"BitrateIndex: ", header.BitrateIndex, "\n",
								"SamplingFrequency: ", header.SamplingFrequency, "\n",
								"Padding: ", header.Padding, "\n",
								"Private: ", header.Private, "\n",
								"Mode: ", header.Mode, "\n",
								"ModeExtension: ", header.ModeExtension, "\n",
								"Copyright: ", header.Copyright, "\n",
								"Original: ", header.Original, "\n",
								"Emphasis: ", header.Emphasis);

						// Calculate the length of the Audio Data
						audioDataLength = cast(uint)(144 * (cast(double)bitRates[header.BitrateIndex] / cast(double)samplingFrequencies[header.SamplingFrequency]));
						audioDataLength = 0x33f;
						if (header.Padding) {
							audioDataLength++;
						}

						// subtract the size of the header
						//audioDataLength -= 4;

						// allocate the buffer
						audioData = new ubyte[audioDataLength];

						Console.putln("Audio Data Length: ", audioDataLength);
						Console.putln("curByte: ", cast(ulong)audioData.ptr);

						// set the format of the wave buffer

						if (header.SamplingFrequency == 0) {
							// 44.1 kHz
							wf.samplesPerSecond = 44100;
						}
						else if (header.SamplingFrequency == 1) {
							// 48 kHz
							wf.samplesPerSecond = 48000;
						}
						else {
							// 32 kHz
							wf.samplesPerSecond = 32000;
						}

						wf.compressionType = 1;

						switch(header.Mode) {
							case MPEG_MODE_STEREO:
							case MPEG_MODE_DUAL_CHANNEL:
								wf.numChannels = 2;
								break;

							case MPEG_MODE_SINGLE_CHANNEL:
								wf.numChannels = 1;
								break;

							case MPEG_MODE_JOINT_STEREO:
								wf.numChannels = 2;
								break;

							default: // impossible!
								return StreamData.Invalid;
						}


						wf.averageBytesPerSecond = wf.samplesPerSecond * 2 * wf.numChannels;
						wf.blockAlign = 2 * wf.numChannels;
						wf.bitsPerSample = 16;

						// set the wavelet's audio format
						if (toBuffer !is null) {
							toBuffer.setAudioFormat(wf);
							bufferTime = toBuffer.time;
						}

						if (header.Protected == 0) {
							decoderState = MP3_READ_CRC;
						}
						else {
							decoderState = MP3_READ_AUDIO_DATA;
						}

						continue;
					}
					else
					{
						//Console.putln("cur test ", mpeg_header & MPEG_SYNC_BITS, " @ ", stream.position - 4);
						ubyte curByte;

						// test 5K worth
						syncAmount++;
						
						if (syncAmount == 1024*5) {
							return StreamData.Invalid;
						}

						if (!stream.read(curByte))
						{
							return StreamData.Required;
						}

						mpeg_header <<= 8;
						mpeg_header |= (cast(uint)curByte);
					}

					continue;

				case MP3_READ_CRC:

					if (!stream.read(crc)) {
						return StreamData.Required;
					}

					decoderState = MP3_READ_AUDIO_DATA;

					continue;
					
				case MP3_READ_AUDIO_DATA:
					Console.putln("pos: ", new String("%x", stream.position));

					// Read in enough data for decoding a buffer
					if (!stream.read(audioData)) {
						return StreamData.Required;
					}

					curByte = audioData.ptr;
					curPos = 0;

					switch(header.Mode) {
						case MPEG_MODE_STEREO:
						case MPEG_MODE_DUAL_CHANNEL:
							channels = 2;
							decoderState = MP3_READ_AUDIO_DATA_SINGLE_CHANNEL;
							break;

						case MPEG_MODE_SINGLE_CHANNEL:
							channels = 1;
							decoderState = MP3_READ_AUDIO_DATA_SINGLE_CHANNEL;
							break;

						case MPEG_MODE_JOINT_STEREO:
							decoderState = MP3_READ_AUDIO_DATA_JOINT_STEREO;
							break;

						default: // impossible!
							return StreamData.Invalid;
					}

					continue;

				case MP3_READ_AUDIO_DATA_SINGLE_CHANNEL:

					// read in allocation bits

					// Determine which allocation table to use
					//   depending on the sample frequency and bitrate

					// Table A:
					//    48 kHz 	: 56, 64, 80, 96, 112, 128, 160, 192 kbits/s
					//    44.1		: 56, 64, 80
					//    32		: 56, 64, 80

					// Table B:
					//    48		: N/A
					//    44.1		: 96, 112, 128, 160, 192
					//    32		: 96, 112, 128, 160, 192

					// Table C:
					//    48		: 32, 48
					//    44.1		: 32, 48
					//    32		: N/A

					// Table D:
					//    48		: N/A
					//    44.1		: N/A
					//    32		: 32, 48

					// scfsi[scfsi_band] -- In Layer III, the scalefactor
					// selection information works similarly to Layers I and
					// II. The main difference is the use of variable
					// scfsi_band to apply scfsi to groups of scalefactors
					// instead of single scalefactors. scfsi controls the
					// use of scalefactors to the granules.

					uint scfsi[4][2];

					// part2_3_length[gr] -- This value contains the number of
					// main_data bits used for scalefactors and Huffman code
					// data. Because the length of the side information is
					// always the same, this value can be used to calculate
					// the beginning of the main information for each granule
					// and the position of ancillary information (if used).

					uint part2_3_length[2][2];
					
					// big_values[gr] -- The spectral values of each granule
					// are coded with different Huffman code tables. The full
					// frequency range from zero to the Nyquist frequency is
					// divided into several regions, which then are coded using
					// different table. Partitioning is done according to the
					// maximum quantized values. This is done with the
					// assumption the values at higher frequencies are expected
					// to have lower amplitudes or don't need to be coded at all.
					// Starting at high frequencies, the pairs of quantized values
					// with absolute value not exceeding 1 (i.e. only 3 possible
					// quantization levels) are counted. This number is named
					// "count1". Again, an even number of values remains. Finally,
					// the number of pairs of values in the region of the spectrum
					// which extends down to zero is named "big_values". The
					// maximum absolute value in this range is constrained to 8191.
					
					// The figure shows the partitioning:
					// xxxxxxxxxxxxx------------------00000000000000000000000000000
					// |           |                 |                            |
					// 1      bigvalues*2    bigvalues*2+count1*4             iblen
					//
					// The values 000 are all zero
					// The values --- are -1, 0, or +1. Their number is a multiple of 4
					// The values xxx are not bound
					// iblen = 576

					uint big_values[2][2];

					// global_gain[gr] -- The quantizer step size information is
					// transmitted in the side information variable global_gain.
					// It is logarithmically quantized. For the application of
					// global_gain, refer to the formula in 2.4.3.4 (ISO 11172-3)

					uint global_gain[2][2];

					// scalefac_compress[gr] -- selects the number of bits used
					// for the transmission of the scalefactors according to the
					// following table:

					// if block_type is 0, 1, or 3:
					// slen1: length of scalefactors for scalefactor bands 0 to 10
					// slen2: length of scalefactors for scalefactor bands 11 to 20

					// if block_type is 2 and switch_point is 0:
					// slen1: length of scalefactors for scalefactor bands 0 to 5
					// slen2: length of scalefactors for scalefactor bands 6 to 11

					// if block_type is 2 and switch_point is 1:
					// slen1: length of scalefactors for scalefactor bands 0 to 7
					//		(long window scalefactor band) and 4 to 5 (short window
					//		scalefactor band)
					// slen2: length of scalefactors for scalefactor bands 6 to 11

					// scalefactor_compress slen1 slen2
					//                    0     0     0
					//                    1     0     1
					//                    2     0     2
					//                    3     0     3
					//                    4     3     0
					//                    5     1     1
					//                    6     1     2
					//                    7     1     3
					//                    8     2     1
					//                    9     2     2
					//                   10     2     3
					//                   11     3     1
					//                   12     3     2
					//                   13     3     3
					//                   14     4     2
					//                   15     4     3

					uint scalefac_compress[2][2];

					// blocksplit_flag[gr] -- signals that the block uses an other
					// than normal (type 0) window. If blocksplit_flag is set,
					// several other variables are set by default:

					// region_address1 = 8 (in case of block_type == 1 or 3)
					// region_address1 = 9 (in case of block_type == 2)
					// region_address2 = 0 and the length of region 2 is zero

					// If it is not set, the value of block_type is zero

					uint blocksplit_flag[2][2];

					// block_type[gr] -- indicates the window type for the actual
					// granule (see the description of filterbank)

					// type 0 - reserved
					// type 1 - start block
					// type 2 - 3 short windows
					// type 3 - end block

					uint block_type[2][2];

					// switch_point[gr] -- signals the split point of short/long
					// transforms. The following table shows the number of the
					// scalefactor band above which window switching (i.e.
					// block_type different from 0) is used.

					// switch_point switch_point_l switch_point_s
					//                (num of sb)    (num of sb)
					// --------------------------------------------
					//       0             0              0
					//       1             8              3

					uint switch_point[2][2];

					// switch_point_l -- Number of the scalefactor band (long
					// block scalefactor band) from which point on window
					// switching is used.

					uint switch_point_l;

					// switch_point_s -- Number of the scalefactor band (short
					// block scalefactor band) from which point on window
					// switching is used.

					uint switch_point_s;

					// cb_limit -- Number of scalefactor bands for long blocks
					// (block_type != 2). This is a constant, 21, for Layer III
					// in all modes and at all sampling frequencies.

					const uint cb_limit = 21;

					// cb_limit_short -- Number of scalefactor bands for long
					// blocks (block_type == 2). This is a constant, 12, for
					// Layer III in all modes and at all sampling frequencies.

					const uint cb_limit_short = 12;

					// table_select[region][gr] -- different Huffman code tables
					// are used depending on the maximum quantized value and the
					// local statistics of the signal. There are a total of 32
					// possible tables given in 3-Annex-B Table 3-B.7 (ISO 11172-3)

					uint table_select[3][2][2];

					// subblock_gain[window][gr] -- indicates the gain offset
					// (quantization: factor 4) from the global gain for one
					// subblock. Used only with block type 2 (short windows).
					// The values of the subblock have to be divided by 4.

					uint subblock_gain[3][2][2];

					// region_address1[gr] -- A further partitioning of the
					// spectrum is used to enhance the performance of the Huffman
					// coder. It is a subdivision of the region which is described
					// by big_values. The purpose of this subdivision is to get
					// better error robustness and better coding efficiency. Three
					// regions are used. Each region is coded using a different
					// Huffman code table depending on the maximum quantized value
					// and the local statistics.

					// The values region_address[1,2] are used to point to the
					// boundaries of the regions. The region boundaries are
					// aligned with the partitioning of the spectrum into critical
					// bands.

					// In the case of block_type == 2 (short blocks) the scalefactor
					// bands representing the different time slots are counted
					// separately. If switch_point == 0, the total amount of scalefactor
					// bands for the granule in this case is 12*3=36. If block_type == 2
					// and switch_point == 1, the amount of scalefactor bands is
					// 8+9*3=35. region_address1 counts the number of scalefactor bands
					// until the upper edge of the first region:

					// region_address1   upper_edge of region is upper edge
					//                      of scalefactor band number:
					//               0   0 (no first region)
					//               1   1
					//               2   2
					//             ...   ...
					//              15   15

					uint region_address1[2][2];

					// region_address2[gr] -- counts the number of scalefactor bands
					// which are partially or totally in region 3. Again, if
					// block_type == 2, then the scalefactor bands representing
					// different time slots are counted separately.

					uint region_address2[2][2];

					// preflag[gr] -- This is a shortcut for additional high
					// frequency amplification of the quantized values. If preflag
					// is set, the values of a table are added to the scalefactors
					// (see 3-Annex B, Table 3-B.6 ISO 11172-3). This is equivalent
					// to multiplication of the requantized scalefactors with table
					// values. preflag is never used if block_type == 2 (short blocks)

					uint preflag[2][2];

					// scalefac_scale[gr] -- The scalefactors are logarithmically
					// quantized with a step size of 2 or sqrt(2) depending on
					// the value of scalefac_scale:

					// scalefac_scale = 0 ... stepsize = sqrt(2)
					// scalefac_scale = 1 ... stepsize = 2

					uint scalefac_scale[2][2];

					// count1table_select[gr] -- This flag selects one of two
					// possible Huffman code tables for the region of
					// quadruples of quantized values with magnitude not
					// exceeding 1. (ref to ISO 11172-3)

					// count1table_select = 0 .. Table A of 3-Annex B.7
					// count1table_select = 1 .. Table B of 3-Annex B.7

					uint count1table_select[2][2];

					main_data_end = readBits(9);
					
					if (channels == 1) {
						readBits(5); // ignore private_bits
					}
					else {
						readBits(3); // ignore private_bits
					}

					for(uint ch = 0; ch < channels; ch++) {
						for(uint scfsi_band = 0; scfsi_band < 4; scfsi_band++) {
							scfsi[scfsi_band][ch] = readBits(1);
							Console.putln(scfsi[scfsi_band][ch], "scfsi[", scfsi_band, "]");
						}
					}

					for(uint gr=0; gr < 2; gr++) {
						for(uint ch = 0; ch < channels; ch++) {

							part2_3_length[gr][ch] = readBits(12);
							Console.putln(part2_3_length[gr][ch], "part2_3_length");
							big_values[gr][ch] = readBits(9);
							Console.putln(big_values[gr][ch], "big_values");
							global_gain[gr][ch] = readBits(8);
							Console.putln(global_gain[gr][ch], "global_gain");
							scalefac_compress[gr][ch] = readBits(4);
							Console.putln(scalefac_compress[gr][ch], "scalefac_compress");
							blocksplit_flag[gr][ch] = readBits(1);
							Console.putln(blocksplit_flag[gr][ch], "blocksplit_flag");

							if (blocksplit_flag[gr][ch]) {
								block_type[gr][ch] = readBits(2);
							Console.putln(block_type[gr][ch], "block_type");
								switch_point[gr][ch] = readBits(1);
							Console.putln(switch_point[gr][ch], "switch_point");
								for (uint region = 0; region < 2; region++) {
									table_select[region][gr][ch] = readBits(5);
							Console.putln(table_select[region][gr][ch], "table_select[", region, "]");
								}

								// window -- Number of actual time slot in case of
								// block_type == 2, 0 = window = 2.

								for (uint window = 0; window < 3; window++) {
									subblock_gain[window][gr][ch] = readBits(3);
									Console.putln(subblock_gain[window][gr][ch], "subblock_gain[", window, "]");
								}

								if (block_type[gr][ch] == 2 && switch_point[gr][ch] == 0) {
									region_address1[gr][ch] = 8;
								}
								else {
									region_address1[gr][ch] = 7;
								}
								Console.putln(region_address1[gr][ch], "region_address1");

								region_address2[gr][ch] = 20 - region_address1[gr][ch];
							Console.putln(region_address2[gr][ch], "region_address2");
							}
							else {
								for (uint region = 0; region < 3; region++) {
									table_select[region][gr][ch] = readBits(5);
							Console.putln(table_select[region][gr][ch], "table_select[", region, "]");
								}

								region_address1[gr][ch] = readBits(4);
							Console.putln(region_address1[gr][ch], "region_address1");
								region_address2[gr][ch] = readBits(3);
							Console.putln(region_address2[gr][ch], "region_address2");
							}

							preflag[gr][ch] = readBits(1);
							Console.putln(preflag[gr][ch], "preflag");
							scalefac_scale[gr][ch] = readBits(1);
							Console.putln(scalefac_scale[gr][ch], "scalefac_scale");
							count1table_select[gr][ch] = readBits(1);
							Console.putln(count1table_select[gr][ch], "count1table_select");
						}
					}

					// followed by main data (at main_data_end... not immediately following)
					
					decoderState = MP3_READ_AUDIO_DATA_FRAME;

				case MP3_READ_AUDIO_DATA_FRAME:


					decoderState = MP3_READ_HEADER;
					continue;

				case MP3_READ_AUDIO_DATA_JOINT_STEREO:
					continue;

				default:
					break;
			}
			break;
		}
		return StreamData.Invalid;
	}

protected:

	uint readBits(uint bits) {
		// read a byte, read bits, whatever necessary to get the value
		//writeln("reading, # bits:", bits, " curbyte:", *curByte);

		uint curvalue;
		uint value = 0;

		uint mask;
		uint maskbits;

		int shift;

		if (curByte >= audioData.ptr + audioData.length) {
			// We have consumed everything in our buffer
			return 0;
		}

		for (;;) {
			if (bits == 0) { return value; }

			if (bits > 8) {
				maskbits = 8;
			}
			else {
				maskbits = bits;
			}
			//Console.putln("curpos:", curPos, " for bits:", bits, " maskbits:", maskbits);

			curvalue = ((*curByte) & (byteMasks[maskbits][curPos]));

			shift = ((8-cast(int)curPos) - cast(int)bits);

			if (shift > 0) {
				curvalue >>= shift;
			}
			else if (shift < 0) {
				curvalue <<= -shift;
			}

			//writeln("has curvalue:", curvalue);

			value |= curvalue;

			//writeln("has value:", value);

			curPos += maskbits;

			if (curPos >= 8) {
				bits -= (8 - curPos + maskbits);
				curPos = 0;
				curByte++;

				if (curByte >= audioData.ptr + audioData.length) {
					// We have consumed everything in our buffer
					return 0;
				}
			}
			else {
				break;
			}
		}
		return value;
	}

	// header for the frame
	uint mpeg_header;

	// bit building
	ubyte* curByte;
	uint curPos;

	// header information for the frame
	MP3HeaderInformation header;

	ID3HeaderInformation id3;

	// the number of channels present
	uint channels;

	ushort crc;

	// the number of samples left to decode
	uint samplesLeft;

	// the buffer size and information
	uint bufferSize;
	Time bufferTime;
	AudioFormat wf;

	uint audioDataLength;

	ubyte audioData[];

	uint syncAmount;
	
	uint id3length;
	
	// the main data end pointer
	uint main_data_end;

	// the current pointer (of last frame)
	uint cur_data_ptr;

private:

	enum : uint {
		MP3_STATE_INIT,
		MP3_BUFFER_AUDIO,
		MP3_READ_HEADER,
		MP3_AMBIGUOUS_SYNC,
		MP3_READ_CRC,
		MP3_READ_AUDIO_DATA,
		MP3_READ_AUDIO_DATA_SINGLE_CHANNEL,
		MP3_READ_AUDIO_DATA_FRAME,
		MP3_READ_AUDIO_DATA_JOINT_STEREO,
	}

	align(1) struct MP3HeaderInformation {
		uint ID;
		uint Layer;
		uint Protected;
		uint BitrateIndex;
		uint SamplingFrequency;
		uint Padding;
		uint Private;
		uint Mode;
		uint ModeExtension;
		uint Copyright;
		uint Original;
		uint Emphasis;
	}

	align(1) struct ID3HeaderInformation {
		ubyte[3] signature;
		ubyte[2] ver;
		ubyte flags;
		ubyte[4] len;
	}

	const auto MPEG_SYNC_BITS 		= FromBigEndian!(0xFFF00000);
	const auto MPEG_ID_BIT    		= FromBigEndian!(0x00080000);
	const auto MPEG_LAYER			= FromBigEndian!(0x00060000);
	const auto MPEG_LAYER_SHIFT				= FromBigEndianBitIndex32!(17);
	const auto MPEG_PROTECTION_BIT	= FromBigEndian!(0x00010000);
	const auto MPEG_BITRATE_INDEX	= FromBigEndian!(0x0000F000);
	const auto MPEG_BITRATE_INDEX_SHIFT 	= FromBigEndianBitIndex32!(12);
	const auto MPEG_SAMPLING_FREQ	= FromBigEndian!(0x00000C00);
	const auto MPEG_SAMPLING_FREQ_SHIFT 	= FromBigEndianBitIndex32!(10);
	const auto MPEG_PADDING_BIT		= FromBigEndian!(0x00000200);
	const auto MPEG_PRIVATE_BIT		= FromBigEndian!(0x00000100);
	const auto MPEG_MODE			= FromBigEndian!(0x000000C0);
	const auto MPEG_MODE_SHIFT				= FromBigEndianBitIndex32!(6);
	const auto MPEG_MODE_EXTENSION	= FromBigEndian!(0x00000030);
	const auto MPEG_MODE_EXTENSION_SHIFT 	= FromBigEndianBitIndex32!(4);
	const auto MPEG_COPYRIGHT		= FromBigEndian!(0x00000008);
	const auto MPEG_ORIGINAL		= FromBigEndian!(0x00000004);
	const auto MPEG_EMPHASIS		= FromBigEndian!(0x00000003);
	const auto MPEG_EMPHASIS_SHIFT = 0;

	// modes

	const auto MPEG_MODE_STEREO			= 0;
	const auto MPEG_MODE_JOINT_STEREO	= 1;
	const auto MPEG_MODE_DUAL_CHANNEL	= 2;
	const auto MPEG_MODE_SINGLE_CHANNEL = 3;

	const uint byteMasks[9][] = [
		[0x00, 0x00, 0x00, 0x00, 0x0, 0x0, 0x0, 0x0],		// 0 bit
		[0x80, 0x40, 0x20, 0x10, 0x8, 0x4, 0x2, 0x1],		// 1 bit
		[0xC0, 0x60, 0x30, 0x18, 0xC, 0x6, 0x3, 0x1],		// 2 bits
		[0xE0, 0x70, 0x38, 0x1C, 0xE, 0x7, 0x3, 0x1],		// 3 bits
		[0xF0, 0x78, 0x3C, 0x1E, 0xF, 0x7, 0x3, 0x1],		// 4 bits
		[0xF8, 0x7C, 0x3E, 0x1F, 0xF, 0x7, 0x3, 0x1],		// 5 bits
		[0xFC, 0x7E, 0x3F, 0x1F, 0xF, 0x7, 0x3, 0x1],		// 6 bits
		[0xFE, 0x7F, 0x3F, 0x1F, 0xF, 0x7, 0x3, 0x1],		// 7 bits
		[0xFF, 0x7F, 0x3F, 0x1F, 0xF, 0x7, 0x3, 0x1]		// 8 bits
	];

	// layer 3 bit rates (MPEG-1)
	const uint[] bitRates = [ 0, 32, 40, 48, 56, 64, 80, 96, 112, 128, 160, 192, 224, 256, 320 ]; // the first entry is the 'free' bitrate
	const double[] samplingFrequencies = [ 44.1, 48.0, 32.0, 1.0 ]; // the final entry is reserved, but set to 1.0 due to being used in division
}