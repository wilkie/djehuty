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

import math.common;

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
				
					samplesLeft = 1728 * NUM_BLOCKS;
					bufferSize = samplesLeft;

					decoderState = MP3_READ_HEADER;

					// *** fall through *** //

				case MP3_READ_HEADER:
					//Console.putln("pos: ", new String("%x", stream.position));

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

							//Console.putln("id3 length: ", new String("%x", id3length));
						}

						if (!stream.skip(id3length)) {
							return StreamData.Required;
						}

						decoderState = MP3_READ_HEADER;
						continue;
					}

//					Console.putln("mpeg_header ", new String("%x", mpeg_header)	);

					if ((mpeg_header & MPEG_SYNC_BITS) == MPEG_SYNC_BITS) {
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

						/*Console.putln("Header: ", mpeg_header & MPEG_SYNC_BITS, "\n",
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
								"Emphasis: ", header.Emphasis); //*/

						// Calculate the length of the Audio Data

						bufferLength = cast(uint)(144 * (cast(double)bitRates[header.BitrateIndex] / cast(double)samplingFrequencies[header.SamplingFrequency]));
						if (header.Padding) {
							bufferLength++;
						}

						// subtract the size of the header
						bufferLength -= 4;

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
						
						if (!accepted) {
							if (toBuffer !is null) {
								if (toBuffer.length() != bufferSize) {
									Console.putln("resize ", bufferSize, " from ", toBuffer.length());
									toBuffer.resize(bufferSize);
								}
								toBuffer.rewind();
							}

							if (toBuffer is null && isSeek == false) {
								return StreamData.Accepted;
							}
						}
						
						accepted = true;

						continue;
					}
					else
					{
						//Console.putln("cur test ", mpeg_header & MPEG_SYNC_BITS, " @ ", stream.position - 4);
						ubyte curByte;

						// test 5K worth
						syncAmount++;
						
						if (syncAmount == 1024*15) {
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
					//Console.putln("pos: ", new String("%x", stream.position));
					
					// curByte is currently at the end of the last frame (supposedly)
					// main_data_end depicts the end of the data frame

					curByte = audioData.length - bufferLength;
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
							channels = 2;
							decoderState = MP3_READ_AUDIO_DATA_SINGLE_CHANNEL;
							break;

						default: // impossible!
							return StreamData.Invalid;
					}

					continue;

				case MP3_READ_AUDIO_DATA_SINGLE_CHANNEL:

					// Read in enough data for decoding a buffer
					audioHeaderLength = 32;

					if (channels == 1) { audioHeaderLength = 17; }

					//Console.putln("reading ", audioHeaderLength, " info header buffer");

					// read in the side info
					if (!stream.read(audioHeader.ptr, audioHeaderLength)) {
						return StreamData.Required;
					}
					
					// reset bit stream
					audioRef = audioHeader;
					audioRefLength = audioHeader.length;
					curByte = 0;
					curPos = 0;

					//Console.putln(audioRefLength, " <--- header length");

					// The reading of side info

					main_data_begin = readBits(9);	// actually main_data_end in the spec,
													// but that makes no sense in this context

					if (channels == 1) {
						readBits(5); // ignore private_bits
					}
					else {
						readBits(3); // ignore private_bits
					}

					for(uint ch = 0; ch < channels; ch++) {
						for(uint scfsi_band = 0; scfsi_band < 4; scfsi_band++) {
							scfsi[scfsi_band][ch] = readBits(1);
						}
					}

					// 18 or 16 bits read

					for(uint gr=0; gr < 2; gr++) {
						for(uint ch = 0; ch < channels; ch++) {

							part2_3_length[gr][ch] = readBits(12);
							big_values[gr][ch] = readBits(9);
							global_gain[gr][ch] = readBits(8);
							scalefac_compress[gr][ch] = readBits(4);
							blocksplit_flag[gr][ch] = readBits(1);

							slen1[gr][ch] = slen1_interpret[scalefac_compress[gr][ch]];
							slen2[gr][ch] = slen2_interpret[scalefac_compress[gr][ch]];

							if (blocksplit_flag[gr][ch]) {
								block_type[gr][ch] = readBits(2);
								switch_point[gr][ch] = readBits(1);
								for (uint region = 0; region < 2; region++) {
									table_select[region][gr][ch] = readBits(5);
								}

								// window -- Number of actual time slot in case of
								// block_type == 2, 0 = window = 2.

								for (uint window = 0; window < 3; window++) {
									subblock_gain[window][gr][ch] = readBits(3);
								}

								if (block_type[gr][ch] == 2 && switch_point[gr][ch] == 0) {
									region_address1[gr][ch] = 8;
								}
								else {
									region_address1[gr][ch] = 7;
								}

								region_address2[gr][ch] = 20 - region_address1[gr][ch];

								if (switch_point[gr][ch] == 1) {
									switch_point_l[gr][ch] = 8;
									switch_point_s[gr][ch] = 3;
								}
								else {
									switch_point_l[gr][ch] = 0;
									switch_point_s[gr][ch] = 0;
								}
							}
							else {
								block_type[gr][ch] = 0;

								for (uint region = 0; region < 3; region++) {
									table_select[region][gr][ch] = readBits(5);
								}

								region_address1[gr][ch] = readBits(4);
								region_address2[gr][ch] = readBits(3);

								switch_point[gr][ch] = 0;
								switch_point_l[gr][ch] = 0;
								switch_point_s[gr][ch] = 0;
							}

							preflag[gr][ch] = readBits(1);
							scalefac_scale[gr][ch] = readBits(1);
							count1table_select[gr][ch] = readBits(1);
						}
					}

					bufferLength -= audioHeaderLength;

					//Console.putln("Audio Data Length: ", bufferLength);

					// append the buffer
					audioData ~= new ubyte[bufferLength];

					/* followed by main data (at main_data_end... not immediately following) */

					decoderState = MP3_READ_AUDIO_DATA_SCALE_FACTORS;

				case MP3_READ_AUDIO_DATA_SCALE_FACTORS:

					//Console.putln("reading ", bufferLength, " info decode buffer");

					// read in the data
					if (!stream.read(&audioData[$ - bufferLength], bufferLength)) {
						return StreamData.Required;
					}

					// reset bit stream
					curByte = audioData.length;
					curByte -= bufferLength;
					curByte -= main_data_begin;

					main_data_begin = curByte;

					//Console.putln(curByte, " start of read");

					audioRefLength = audioData.length;
					audioRef = audioData;

					curPos = 0;
					
					bool output = false;

					for (uint gr = 0; gr < 2; gr++) {
						for (uint ch = 0; ch < channels; ch++) {

							part2_length = (curByte * 8) + curPos;

							// Read the scalefactors for this granule
							readScalefactors(gr, ch);

							part2_length = ((curByte * 8) + curPos) - part2_length;

							// Decode the current huffman data
							decodeHuffman(gr, ch);

							// Requantize
							requantizeSample(gr, ch);
<<<<<<< HEAD:codecs/audio/mp3.d
=======
							// ro[ch] == quantizedData[ch]
							for (uint sb = 0; sb < SBLIMIT; sb++) {
								for (uint ss = 0; ss < SSLIMIT; ss++) {
									//printf("%f\n", quantizedData[ch][sb][ss]);
								}
							}
>>>>>>> 527f80074843e17abec90f465262e2cecf2aa803:codecs/audio/mp3.d
						}

						// Account for a mode switch from intensity stereo to MS_stereo
						normalizeStereo(gr);
<<<<<<< HEAD:codecs/audio/mp3.d
=======
						for (uint ch = 0; ch < channels; ch++) {
							for (uint sb = 0; sb < SBLIMIT; sb++) {
								for (uint ss = 0; ss < SSLIMIT; ss++) {
									//if (normalizedData[ch][sb][ss] > 0.0) {
									//	printf("%f\n", normalizedData[ch][sb][ss]);
									//}
								}
							}
						}
>>>>>>> 527f80074843e17abec90f465262e2cecf2aa803:codecs/audio/mp3.d

						for (uint ch = 0; ch < channels; ch++) {
							// Reorder the short blocks
							reorder(gr, ch);
<<<<<<< HEAD:codecs/audio/mp3.d
							
							// Perform anti-alias pass on subband butterflies
							antialias(gr, ch);
=======
							for (uint sb = 0; sb < SBLIMIT; sb++) {
								for (uint ss = 0; ss < SSLIMIT; ss++) {
									//if (reorderedData[sb][ss] > 0.0) {
										//printf("%f\n", reorderedData[sb][ss]);
									//}
								}
							}

							// Perform anti-alias pass on subband butterflies
							antialias(gr, ch);
							for (uint sb = 0; sb < SBLIMIT; sb++) {
								for (uint ss = 0; ss < SSLIMIT; ss++) {
								//	if (hybridData[sb][ss] > 0.0) {
										//printf("%f\n", hybridData[sb][ss]);
								//	}
								}
							}

							// Perform hybrid synthesis pass
							for (uint sb; sb < SBLIMIT; sb++) {
								hybridSynthesis(gr, ch, sb);
							}
							
							// Multiply every second subband's every second input by -1
							// To correct for frequency inversion of the polyphase filterbank
							for (uint sb; sb < SBLIMIT; sb++) {
								for (uint ss; ss < SSLIMIT; ss++) {
									if (((ss % 2) == 1) && ((sb % 2) == 1)) {
										polysynthData[ch][sb][ss] = -polysynthData[ch][sb][ss];
									}
								}
							}

							for (uint sb = 0; sb < SBLIMIT; sb++) {
								for (uint ss = 0; ss < SSLIMIT; ss++) {
									//if (polysynthData[ch][sb][ss] > 0.0) {
									//	printf("%f\n", polysynthData[ch][sb][ss]);
									//}
								}
							}
						}
							
						// Polyphase Synthesis
						for (uint ss; ss < 18; ss++) {
							polyphaseSynthesis(gr, ss, toBuffer);
>>>>>>> 527f80074843e17abec90f465262e2cecf2aa803:codecs/audio/mp3.d
						}
					}

					samplesLeft -= (3*18*32*channels);

					if (samplesLeft <= 0)
					{
						decoderState = MP3_BUFFER_AUDIO;
						curTime += bufferTime;
							//curTime.toString();
						return StreamData.Accepted; /*
					toBuffer.rewind();
						continue; //*/
					}

					//Console.putln(curByte, " end of read");
					//Console.putln(curByte - main_data_begin, " read");

					main_data_end = curByte+1;

					/* followed by huffman encoded data */

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

	void readScalefactors(uint gr, uint ch) {
		if (blocksplit_flag[gr][ch] == 1 && block_type[gr][ch] == 2) {
			if (switch_point[gr][ch] == 0) {

				// Decoding scalefactors for a short window.

            	for (uint cb = 0; cb < 6; cb++) {
            		for (uint window = 0; window < 3; window++) {
						scalefac[gr][ch].short_window[cb][window] = readBits(slen1[gr][ch]);
            		}
            	}

            	for (uint cb = 6; cb < cb_limit_short; cb++) {
            		for (uint window = 0; window < 3; window++) {
						scalefac[gr][ch].short_window[cb][window] = readBits(slen2[gr][ch]);
            		}
            	}

            	for (uint window = 0; window < 3; window++) {
            		scalefac[gr][ch].short_window[12][window] = 0;
            	}
			}
			else {

				// Decoding scalefactors for a long window with a switch point to short.

				for (uint cb = 0; cb < 8; cb++) {
					if ((scfsi[cb][ch] == 0) || (gr == 0)) {
						scalefac[gr][ch].long_window[cb] = readBits(slen1[gr][ch]);
					}
				}

				for (uint cb = 3; cb < 6; cb++) {
					for (uint window = 0; window < 3; window++) {
						if ((scfsi[cb][ch] == 0) || (gr == 0)) {
							scalefac[gr][ch].short_window[cb][window] = readBits(slen1[gr][ch]);
						}
					}
				}

				for (uint cb = 6; cb < cb_limit_short; cb++) {
					for (uint window = 0; window < 3; window++) {
						if ((scfsi[cb][ch] == 0) || (gr == 0)) {
							scalefac[gr][ch].short_window[cb][window] = readBits(slen2[gr][ch]);
						}
					}
				}

				for (uint window = 0; window < 3; window++) {
					if ((scfsi[cb_limit_short][ch] == 0) || (gr == 0)) {
						scalefac[gr][ch].short_window[cb_limit_short][window] = 0;
					}
				}
			}
		}
		else {

			// The block_type cannot be 2 in this block (so, it must be block 0, 1, or 3).

			// Decoding the scalefactors for a long window

			if ((scfsi[0][ch] == 0) || (gr == 0)) {
        		for (uint cb = 0; cb < 6; cb++) {
					scalefac[gr][ch].long_window[cb] = readBits(slen1[gr][ch]);
        		}
			}

			if ((scfsi[1][ch] == 0) || (gr == 0)) {
        		for (uint cb = 6; cb < 11; cb++) {
					scalefac[gr][ch].long_window[cb] = readBits(slen1[gr][ch]);
        		}
			}

			if ((scfsi[2][ch] == 0) || (gr == 0)) {
        		for (uint cb = 11; cb < 16; cb++) {
					scalefac[gr][ch].long_window[cb] = readBits(slen2[gr][ch]);
        		}
			}

			if ((scfsi[3][ch] == 0) || (gr == 0)) {
        		for (uint cb = 16; cb < 21; cb++) {
					scalefac[gr][ch].long_window[cb] = readBits(slen2[gr][ch]);
        		}
			}

<<<<<<< HEAD:codecs/audio/mp3.d
			scalefac[gr][ch].long_window[22] = 0;
		}
	}
	
=======
			// (The reference implementation does nothing with subband 21)

			// We fill it with a high negative integer:
			scalefac[gr][ch].long_window[21] = -858993460;

			scalefac[gr][ch].long_window[22] = 0;
		}
	}

>>>>>>> 527f80074843e17abec90f465262e2cecf2aa803:codecs/audio/mp3.d
	const auto SBLIMIT = 32;
	const auto SSLIMIT = 18;

	// Decoded Huffman Data -- is(i) in the spec
<<<<<<< HEAD:codecs/audio/mp3.d
	long[SSLIMIT][SBLIMIT] codedData;
	
	// Requantizated Data -- xr(i) in the spec
	double[SSLIMIT][SBLIMIT][2] quantizedData;
	
	// Normalized Data -- lr(i)
	double[SSLIMIT][SBLIMIT][2] normalizedData;
	
	// reordered data -- re(i)
	double[SSLIMIT][SBLIMIT] reorderedData;

	// anti-aliased hybrid synthesis data -- hybrid(i)
	double[SSLIMIT][SBLIMIT] hybridData;

=======
	int[SSLIMIT][SBLIMIT] codedData;

	// Requantizated Data -- xr(i) in the spec
	double[SSLIMIT][SBLIMIT][2] quantizedData;

	// Normalized Data -- lr(i)
	double[SSLIMIT][SBLIMIT][2] normalizedData;

	// reordered data -- re(i)
	double[SSLIMIT][SBLIMIT] reorderedData;

	// anti-aliased hybrid synthesis data -- hybridIn
	double[SSLIMIT][SBLIMIT] hybridData;

	// data for the polysynth phase -- hybridOut
	double[SSLIMIT][SBLIMIT][2] polysynthData;

>>>>>>> 527f80074843e17abec90f465262e2cecf2aa803:codecs/audio/mp3.d
	void decodeHuffman(uint gr, uint ch) {
		// part2_3_length is the length of all of the data
		// (huffman + scalefactors). part2_length is just
		// the scalefactors by themselves.
		
		// Note: SSLIMIT * SBLIMIT = 32 * 18 = 576

		Console.putln("-=-=-=-");

		static const auto max_table_entry = 15;

		uint region1Start;
		uint region2Start;

		if (blocksplit_flag[gr][ch] == 1 && block_type[gr][ch] == 2) {
			// Short Blocks
			region1Start = 36;
			region2Start = 576; // There isn't a region 2 for short blocks
		}
		else {
			// Long Blocks
			region1Start = sfindex_long[header.SamplingFrequency][region_address1[gr][ch] + 1];
			region2Start = sfindex_long[header.SamplingFrequency][region_address1[gr][ch] + region_address2[gr][ch] + 2];
		}
		
		uint maxBand = big_values[gr][ch] * 2;

		Console.putln(region1Start, " to ", region2Start);

		if (region1Start > maxBand) { region1Start = maxBand; }
		if (region2Start > maxBand) { region2Start = maxBand; }

		uint freqIndex;

		uint pos = curByte;
		uint posbit = curPos;

		// The number of bits used for the huffman data
 		uint huffmanLength = (part2_3_length[gr][ch] - part2_length);

 		// The bit position in the stream to stop.
 		uint maxBit = huffmanLength + curPos + (curByte * 8);

		// Region 0
		if (freqIndex < region1Start) {
			Console.putln("region 0 -=-=-");
			initializeHuffman(0,gr,ch);
		}

		for (; freqIndex < region1Start; freqIndex+=2) {
			int[] code = readCode();
			codedData[freqIndex/SSLIMIT][freqIndex%SSLIMIT] = code[0];
			codedData[(freqIndex+1)/SSLIMIT][(freqIndex+1)%SSLIMIT] = code[1];
		}

		// Region 1
		if (freqIndex < region2Start) {
			Console.putln("region 1 -=-=-");
			initializeHuffman(1,gr,ch);
		}

		for (; freqIndex < region2Start; freqIndex+=2) {
			int[] code = readCode();
			codedData[freqIndex/SSLIMIT][freqIndex%SSLIMIT] = code[0];
			codedData[(freqIndex+1)/SSLIMIT][(freqIndex+1)%SSLIMIT] = code[1];
		}

		// Region 2
		if (freqIndex < maxBand) {
			Console.putln("region 2 -=-=-");
			initializeHuffman(2,gr,ch);
		}

		for (; freqIndex < maxBand; freqIndex+=2) {
			int[] code = readCode();
			codedData[freqIndex/SSLIMIT][freqIndex%SSLIMIT] = code[0];
			codedData[(freqIndex+1)/SSLIMIT][(freqIndex+1)%SSLIMIT] = code[1];
		}

		Console.putln("big values decoded -=-=-");

		// Read in Count1 Area
		initializeQuantizationHuffman(gr,ch);

		for (; (curPos + (curByte * 8)) < maxBit && freqIndex < 576; freqIndex += 4) {
			int[] code = readQuantizationCode();
			codedData[freqIndex/SSLIMIT][freqIndex%SSLIMIT] = code[0];
			codedData[(freqIndex+1)/SSLIMIT][(freqIndex+1)%SSLIMIT] = code[1];
			codedData[(freqIndex+2)/SSLIMIT][(freqIndex+2)%SSLIMIT] = code[2];
			codedData[(freqIndex+3)/SSLIMIT][(freqIndex+3)%SSLIMIT] = code[3];
		}

		// Zero rest
		for (; freqIndex < 576; freqIndex++) {
			codedData[freqIndex/SSLIMIT][freqIndex%SSLIMIT] = 0;
		}

		// Resync to the correct position
		// (where we started + the number of bits that would have been used)
		curByte = maxBit / 8;
		curPos = maxBit % 8;
	}
	
	void requantizeSample(uint gr, uint ch) {
		uint criticalBandBegin;
		uint criticalBandWidth;
		uint criticalBandBoundary;
		uint criticalBandIndex;

		const int[22] pretab = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 2, 2, 3, 3, 3, 2, 0];

		// Initialize the critical boundary information
		if ((blocksplit_flag[gr][ch] == 1) && (block_type[gr][ch] == 2)) {
			if (switch_point[gr][ch] == 0) {
				// Short blocks
				criticalBandBoundary = sfindex_short[header.SamplingFrequency][1] * 3;
				criticalBandWidth = sfindex_short[header.SamplingFrequency][1];
				criticalBandBegin = 0;
			}
			else {
				// Long blocks come first for switched windows
				criticalBandBoundary = sfindex_long[header.SamplingFrequency][1];
			}
		}
		else {
			// Long windows
			criticalBandBoundary = sfindex_long[header.SamplingFrequency][1];
		}

		for (uint sb; sb < SBLIMIT; sb++) {
			for (uint ss; ss < SSLIMIT; ss++) {

				// Get the critical band boundary
				if ((sb * 18) + ss == criticalBandBoundary) {
					if (blocksplit_flag[gr][ch] == 1 && block_type[gr][ch] == 2) {
						if (switch_point[gr][ch] == 0) {
							// Requantizing the samples for a short window.
							criticalBandIndex++;
							criticalBandBoundary = sfindex_short[header.SamplingFrequency][criticalBandIndex+1]*3;
							criticalBandWidth = sfindex_short[header.SamplingFrequency][criticalBandIndex + 1] - sfindex_short[header.SamplingFrequency][criticalBandIndex];
							criticalBandBegin = sfindex_short[header.SamplingFrequency][criticalBandIndex] * 3;
						}
						else {
							// Requantizing the samples for a long window that switches to short.

							// The first two are long windows and the last two are short windows
							if (((sb * 18) + ss) == sfindex_long[header.SamplingFrequency][8]) {
								criticalBandBoundary = sfindex_short[header.SamplingFrequency][4] * 3;
								criticalBandIndex = 3;
								criticalBandWidth = sfindex_short[header.SamplingFrequency][criticalBandIndex + 1] - sfindex_short[header.SamplingFrequency][criticalBandIndex];
								criticalBandBegin = sfindex_short[header.SamplingFrequency][criticalBandIndex] * 3;
							}
							else if (((sb * 18) + ss) < sfindex_long[header.SamplingFrequency][8]) {
								criticalBandIndex++;
								criticalBandBoundary = sfindex_long[header.SamplingFrequency][criticalBandIndex+1];
							}
							else {
								criticalBandIndex++;
								criticalBandBoundary = sfindex_short[header.SamplingFrequency][criticalBandIndex + 1] * 3;
								criticalBandWidth = sfindex_short[header.SamplingFrequency][criticalBandIndex + 1] - sfindex_short[header.SamplingFrequency][criticalBandIndex];
								criticalBandBegin = sfindex_short[header.SamplingFrequency][criticalBandIndex] * 3;
							}
						}
					}
					else {
						// The block_type cannot be 2 in this block (so, it must be block 0, 1, or 3).

<<<<<<< HEAD:codecs/audio/mp3.d
=======
		// Note: SSLIMIT * SBLIMIT = 32 * 18 = 576

//		Console.putln("-=-=-=-");

		static const auto max_table_entry = 15;

		uint region1Start;
		uint region2Start;

		if (blocksplit_flag[gr][ch] == 1 && block_type[gr][ch] == 2) {
			// Short Blocks
			region1Start = 36;
			region2Start = 576; // There isn't a region 2 for short blocks
		}
		else {
			// Long Blocks
			region1Start = sfindex_long[header.SamplingFrequency][region_address1[gr][ch] + 1];
			region2Start = sfindex_long[header.SamplingFrequency][region_address1[gr][ch] + region_address2[gr][ch] + 2];
		}
		
		uint maxBand = big_values[gr][ch] * 2;

//		Console.putln(region1Start, " to ", region2Start);

		if (region1Start > maxBand) { region1Start = maxBand; }
		if (region2Start > maxBand) { region2Start = maxBand; }

		uint freqIndex;

		uint pos = curByte;
		uint posbit = curPos;

		// The number of bits used for the huffman data
 		uint huffmanLength = (part2_3_length[gr][ch] - part2_length);

 		// The bit position in the stream to stop.
 		uint maxBit = huffmanLength + curPos + (curByte * 8);

		// Region 0
		if (freqIndex < region1Start) {
			//Console.putln("region 0 -=-=-");
			initializeHuffman(0,gr,ch);
		}

		for (; freqIndex < region1Start; freqIndex+=2) {
			int[] code = readCode();
			codedData[freqIndex/SSLIMIT][freqIndex%SSLIMIT] = code[0];
			codedData[(freqIndex+1)/SSLIMIT][(freqIndex+1)%SSLIMIT] = code[1];
		}

		// Region 1
		if (freqIndex < region2Start) {
		//	Console.putln("region 1 -=-=-");
			initializeHuffman(1,gr,ch);
		}

		for (; freqIndex < region2Start; freqIndex+=2) {
			int[] code = readCode();
			codedData[freqIndex/SSLIMIT][freqIndex%SSLIMIT] = code[0];
			codedData[(freqIndex+1)/SSLIMIT][(freqIndex+1)%SSLIMIT] = code[1];
		}

		// Region 2
		if (freqIndex < maxBand) {
	//		Console.putln("region 2 -=-=-");
			initializeHuffman(2,gr,ch);
		}

		for (; freqIndex < maxBand; freqIndex+=2) {
			int[] code = readCode();
			codedData[freqIndex/SSLIMIT][freqIndex%SSLIMIT] = code[0];
			codedData[(freqIndex+1)/SSLIMIT][(freqIndex+1)%SSLIMIT] = code[1];
		}

//		Console.putln("big values decoded -=-=-");

		// Read in Count1 Area
		initializeQuantizationHuffman(gr,ch);

		for (; (curPos + (curByte * 8)) < maxBit && freqIndex < 574; freqIndex += 4) {
			int[4] code = readQuantizationCode();
			codedData[freqIndex/SSLIMIT][freqIndex%SSLIMIT] = code[0];
			codedData[(freqIndex+1)/SSLIMIT][(freqIndex+1)%SSLIMIT] = code[1];
			codedData[(freqIndex+2)/SSLIMIT][(freqIndex+2)%SSLIMIT] = code[2];
			codedData[(freqIndex+3)/SSLIMIT][(freqIndex+3)%SSLIMIT] = code[3];
		}

		// Zero rest
		for (; freqIndex < 576; freqIndex++) {
			codedData[freqIndex/SSLIMIT][freqIndex%SSLIMIT] = 0;
		}

		// Resync to the correct position
		// (where we started + the number of bits that would have been used)
		curByte = maxBit / 8;
		curPos = maxBit % 8;
	}
	
	void requantizeSample(uint gr, uint ch) {
		uint criticalBandBegin;
		uint criticalBandWidth;
		uint criticalBandBoundary;
		uint criticalBandIndex;

		const int[22] pretab = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 2, 2, 3, 3, 3, 2, 0];

		// Initialize the critical boundary information
		if ((blocksplit_flag[gr][ch] == 1) && (block_type[gr][ch] == 2)) {
			if (switch_point[gr][ch] == 0) {
				// Short blocks
				criticalBandBoundary = sfindex_short[header.SamplingFrequency][1] * 3;
				criticalBandWidth = sfindex_short[header.SamplingFrequency][1];
				criticalBandBegin = 0;
			}
			else {
				// Long blocks come first for switched windows
				criticalBandBoundary = sfindex_long[header.SamplingFrequency][1];
			}
		}
		else {
			// Long windows
			criticalBandBoundary = sfindex_long[header.SamplingFrequency][1];
		}

		for (uint sb; sb < SBLIMIT; sb++) {
			for (uint ss; ss < SSLIMIT; ss++) {

				// Get the critical band boundary
				if ((sb * 18) + ss == criticalBandBoundary) {
					if (blocksplit_flag[gr][ch] == 1 && block_type[gr][ch] == 2) {
						if (switch_point[gr][ch] == 0) {
							// Requantizing the samples for a short window.
							criticalBandIndex++;
							criticalBandBoundary = sfindex_short[header.SamplingFrequency][criticalBandIndex+1]*3;
							criticalBandWidth = sfindex_short[header.SamplingFrequency][criticalBandIndex + 1] - sfindex_short[header.SamplingFrequency][criticalBandIndex];
							criticalBandBegin = sfindex_short[header.SamplingFrequency][criticalBandIndex] * 3;
						}
						else {
							// Requantizing the samples for a long window that switches to short.

							// The first two are long windows and the last two are short windows
							if (((sb * 18) + ss) == sfindex_long[header.SamplingFrequency][8]) {
								criticalBandBoundary = sfindex_short[header.SamplingFrequency][4] * 3;
								criticalBandIndex = 3;
								criticalBandWidth = sfindex_short[header.SamplingFrequency][criticalBandIndex + 1] - sfindex_short[header.SamplingFrequency][criticalBandIndex];
								criticalBandBegin = sfindex_short[header.SamplingFrequency][criticalBandIndex] * 3;
							}
							else if (((sb * 18) + ss) < sfindex_long[header.SamplingFrequency][8]) {
								criticalBandIndex++;
								criticalBandBoundary = sfindex_long[header.SamplingFrequency][criticalBandIndex+1];
							}
							else {
								criticalBandIndex++;
								criticalBandBoundary = sfindex_short[header.SamplingFrequency][criticalBandIndex + 1] * 3;
								criticalBandWidth = sfindex_short[header.SamplingFrequency][criticalBandIndex + 1] - sfindex_short[header.SamplingFrequency][criticalBandIndex];
								criticalBandBegin = sfindex_short[header.SamplingFrequency][criticalBandIndex] * 3;
							}
						}
					}
					else {
						// The block_type cannot be 2 in this block (so, it must be block 0, 1, or 3).

>>>>>>> 527f80074843e17abec90f465262e2cecf2aa803:codecs/audio/mp3.d
						// Requantizing the samples for a long window
						criticalBandIndex++;
						criticalBandBoundary = sfindex_long[header.SamplingFrequency][criticalBandIndex+1];
					}
				}

				// Global gain
<<<<<<< HEAD:codecs/audio/mp3.d
				quantizedData[ch][sb][ss] = pow(2.0, (0.25 * (global_gain[gr][ch] - 210.0)));

=======
				quantizedData[ch][sb][ss] = pow(2.0, (0.25 * (cast(double)global_gain[gr][ch] - 210.0)));
         //printf("g : %d %d: %f\n", sb,ss,quantizedData[ch][sb][ss]);
static bool output = false;
>>>>>>> 527f80074843e17abec90f465262e2cecf2aa803:codecs/audio/mp3.d
				// Perform the scaling that depends on the type of window
				if (blocksplit_flag[gr][ch] == 1
					&& (((block_type[gr][ch] == 2) && (switch_point[gr][ch] == 0))
					|| ((block_type[gr][ch] == 2) && (switch_point[gr][ch] == 1) && (sb >= 2)))) {

					// Short blocks (either via block_type 2 or the last 2 bands for switched windows)
<<<<<<< HEAD:codecs/audio/mp3.d
					
					uint sbgainIndex = (((sb * 18) + ss) - criticalBandBegin) / criticalBandWidth;

=======

					uint sbgainIndex = (((sb * 18) + ss) - criticalBandBegin) / criticalBandWidth;

					// if (output) printf("%d %d\n", sbgainIndex, criticalBandIndex);
>>>>>>> 527f80074843e17abec90f465262e2cecf2aa803:codecs/audio/mp3.d
					quantizedData[ch][sb][ss] *= pow(2.0, 0.25 * -8.0
						* subblock_gain[sbgainIndex][gr][ch]);
					quantizedData[ch][sb][ss] *= pow(2.0, 0.25 * -2.0 * (1.0 + scalefac_scale[gr][ch])
						* scalefac[gr][ch].short_window[criticalBandIndex][sbgainIndex]);
				}
				else {
					// Long blocks (either via block_type 0, 1, or 3, or the 1st 2 bands
<<<<<<< HEAD:codecs/audio/mp3.d
					quantizedData[ch][sb][ss] *= pow(2.0, -0.5 * (1.0 + scalefac_scale[gr][ch])
						* scalefac[gr][ch].long_window[criticalBandIndex]
						* preflag[gr][ch] * pretab[criticalBandIndex]);
				}

				// Scale values
				bool sign = quantizedData[ch][sb][ss] < 0;
				quantizedData[ch][sb][ss] *= pow(abs(quantizedData[ch][sb][ss]), 4.0/3.0);
				if (sign) {
					quantizedData[ch][sb][ss] = -quantizedData[ch][sb][ss];
				}
			}
		}
	}
	
	void normalizeStereo(uint gr) {
	
=======
					double powExp = -0.5 * (1.0 + cast(double)scalefac_scale[gr][ch])
						* (cast(double)scalefac[gr][ch].long_window[criticalBandIndex]
						+ (cast(double)preflag[gr][ch] * cast(double)pretab[criticalBandIndex]));
					double powResult = pow(2.0, powExp);
						//if (powResult > 0.0) {
							//printf("r : %f\nfrom : %f\n", powResult, powExp);
							//printf("with : %f %d [%d, %d, %d] %f %f\n", cast(double)scalefac_scale[gr][ch], scalefac[gr][ch].long_window[criticalBandIndex], gr, ch, criticalBandIndex,
						//	cast(double)preflag[gr][ch], cast(double)pretab[criticalBandIndex]);
						//}
					quantizedData[ch][sb][ss] *= powResult;
				}

				// Scale values

				double powResult = pow(cast(double)abs(codedData[sb][ss]), 4.0/3.0);
			//	printf("%f\n", powResult);

				quantizedData[ch][sb][ss] *= powResult;
				if (codedData[sb][ss] < 0) {
					quantizedData[ch][sb][ss] = -quantizedData[ch][sb][ss];
				}
//printf("%d %d: [%d] %.21f\n", sb,ss, codedData[sb][ss], quantizedData[ch][sb][ss]);
			}
		}
	}

	void normalizeStereo(uint gr) {

>>>>>>> 527f80074843e17abec90f465262e2cecf2aa803:codecs/audio/mp3.d
		double io;

		if ((scalefac_compress[gr][0] % 2) == 1) {
			io = 0.707106781188;
		}
		else {
			io = 0.840896415256;
		}

		short[576] decodedPos;
		double[576] decodedRatio;
		double[576][2] k;

		int i;
		int sb;
		int ss;
		int ch;
		
		int scalefactorBand;

  		// Initialize
  		decodedPos[0..$] = 7;

  		bool intensityStereo = (header.Mode == MPEG_MODE_JOINT_STEREO) && (header.ModeExtension & 0x1);
  		bool msStereo = (header.Mode == MPEG_MODE_JOINT_STEREO) && (header.ModeExtension & 0x2);
  		
  		if ((channels == 2) && intensityStereo) {
			if ((blocksplit_flag[gr][ch] == 1) && (block_type[gr][ch] == 2)) {
				if (switch_point[gr][ch] == 0) {
					for (uint j = 0; j < 3; j++) {
						int scalefactorCount = -1;
						
						for (scalefactorBand = 12; scalefactorBand >= 0; scalefactorBand--) {
							int lines = sfindex_short[header.SamplingFrequency][scalefactorBand + 1]
								- sfindex_short[header.SamplingFrequency][scalefactorBand];

							i = 3 * sfindex_short[header.SamplingFrequency][scalefactorBand]
								+ ((j + 1) * lines) - 1;
							
							for (; lines > 0; lines--) {
								if (quantizedData[1][i/SSLIMIT][i%SSLIMIT] != 0.0) {
									scalefactorCount = scalefactorBand;
									scalefactorBand = -10;
									lines = -10;
								}
								i--;
							}
						}
<<<<<<< HEAD:codecs/audio/mp3.d
						
=======

>>>>>>> 527f80074843e17abec90f465262e2cecf2aa803:codecs/audio/mp3.d
						scalefactorBand = scalefactorCount + 1;
						
						for (; scalefactorBand < 12; scalefactorBand++) {
							sb = sfindex_short[header.SamplingFrequency][scalefactorBand+1]
								- sfindex_short[header.SamplingFrequency][scalefactorBand];

							i = 3 * sfindex_short[header.SamplingFrequency][scalefactorBand] + (j * sb);

							for ( ; sb > 0; sb--) {
								decodedPos[i] = cast(short)scalefac[gr][1].short_window[scalefactorBand][j];
								if (decodedPos[i] != 7) {
									// IF (MPEG2) { ... }
									// ELSE {
										decodedRatio[i] = tan(cast(double)decodedPos[i] * (PI / 12));
									// }
								}
								i++;
							}
						}

						sb = sfindex_short[header.SamplingFrequency][12] - sfindex_short[header.SamplingFrequency][11];
						scalefactorBand = (3 * sfindex_short[header.SamplingFrequency][11]) + (j * sb);
						sb = sfindex_short[header.SamplingFrequency][13] - sfindex_short[header.SamplingFrequency][12];

						i = (3 * sfindex_short[header.SamplingFrequency][11]) + (j * sb);

						for (; sb > 0; sb--) {
							decodedPos[i] = decodedPos[scalefactorBand];
							decodedRatio[i] = decodedRatio[scalefactorBand];
							k[0][i] = k[0][scalefactorBand];
							k[1][i] = k[1][scalefactorBand];
							i++;
						}
					}
				}
				else {
					int maxScalefactorBand;

					for (uint j; j<3; j++) {
						int scalefactorCount = 2;
						for (scalefactorBand = 12; scalefactorBand >= 3; scalefactorBand--) {
							int lines = sfindex_short[header.SamplingFrequency][scalefactorBand+1]
								- sfindex_short[header.SamplingFrequency][scalefactorBand];

							i = 3 * sfindex_short[header.SamplingFrequency][scalefactorBand]
								+ ((j + 1) * lines) - 1;
							
							for (; lines > 0; lines--) {
								if (quantizedData[1][i/SSLIMIT][i%SSLIMIT] != 0.0) {
									scalefactorCount = scalefactorBand;
									scalefactorBand = -10;
									lines = -10;
								}
								i--;
							}
						}

						scalefactorBand = scalefactorCount + 1;
<<<<<<< HEAD:codecs/audio/mp3.d
						
=======

>>>>>>> 527f80074843e17abec90f465262e2cecf2aa803:codecs/audio/mp3.d
						if (scalefactorBand > maxScalefactorBand) {
							maxScalefactorBand = scalefactorBand;
						}
						
						for (; scalefactorBand < 12; scalefactorBand++) {
							sb = sfindex_short[header.SamplingFrequency][scalefactorBand+1]
								- sfindex_short[header.SamplingFrequency][scalefactorBand];

							i = 3 * sfindex_short[header.SamplingFrequency][scalefactorBand]
								+ (j * sb);

							for (; sb > 0; sb--) {
								decodedPos[i] = cast(short)scalefac[gr][1].short_window[scalefactorBand][j];
								if (decodedPos[i] != 7) {
									// IF (MPEG2) { ... }
									// ELSE {
									decodedRatio[i] = tan(cast(double)decodedPos[i] * (PI / 12.0));
									// }
								}
								i++;
							}
						}

						sb = sfindex_short[header.SamplingFrequency][12]
								- sfindex_short[header.SamplingFrequency][11];
						scalefactorBand = 3 * sfindex_short[header.SamplingFrequency][11]
								+ j * sb;
						sb = sfindex_short[header.SamplingFrequency][13]
								- sfindex_short[header.SamplingFrequency][12];

						i = 3 * sfindex_short[header.SamplingFrequency][11] + j * sb;
						for (; sb > 0; sb--) {
							decodedPos[i] = decodedPos[scalefactorBand];
							decodedRatio[i] = decodedRatio[scalefactorBand];
							k[0][i] = k[0][scalefactorBand];
							k[1][i] = k[1][scalefactorBand];
							i++;
						}
					}
					
					if (maxScalefactorBand <= 3) {
						i = 2;
						ss = 17;
						sb = -1;
						while (i >= 0) {
							if (quantizedData[1][i][ss] != 0.0) {
								sb = (i * 18) + ss;
								i = -1;
							}
							else {
								ss--;
								if (ss < 0) {
									i--;
									ss = 17;
								}
							}
						}

						i = 0;

						while (sfindex_long[header.SamplingFrequency][i] <= sb) {
							i++;
						}
						
						scalefactorBand = i;
						i = sfindex_long[header.SamplingFrequency][i];
<<<<<<< HEAD:codecs/audio/mp3.d
						
=======

>>>>>>> 527f80074843e17abec90f465262e2cecf2aa803:codecs/audio/mp3.d
						for (; scalefactorBand < 8; scalefactorBand++) {
							sb = sfindex_long[header.SamplingFrequency][scalefactorBand+1]
									- sfindex_long[header.SamplingFrequency][scalefactorBand];
							for (; sb > 0; sb--) {
								decodedPos[i] = cast(short)scalefac[gr][1].long_window[scalefactorBand];
								if (decodedPos[i] != 7) {
									// IF (MPEG2) { ... }
									// ELSE {
										decodedRatio[i] = tan(cast(double)decodedPos[i] * (PI / 12.0));
									// }
								}
								i++;
							}
						}
					}
				}
			}
			else {
				i = 31;
				ss = 17;
				sb = 0;
				
				while (i >= 0) {
					if (quantizedData[1][i][ss] != 0.0) {
						sb = (i * 18) + ss;
						i = -1;
					}
					else {
						ss--;
						if (ss < 0) {
							i--;
							ss = 17;
						}
					}
				}
				i = 0;
				
				while (sfindex_long[header.SamplingFrequency][i] <= sb) {
					i++;
				}

				scalefactorBand = i;
				i = sfindex_long[header.SamplingFrequency][i];

				for (; scalefactorBand < 21; scalefactorBand++) {
					sb = sfindex_long[header.SamplingFrequency][scalefactorBand+1]
						- sfindex_long[header.SamplingFrequency][scalefactorBand];
					
					for (; sb > 0; sb--) {
						decodedPos[i] = cast(short)scalefac[gr][1].long_window[scalefactorBand];
						if (decodedPos[i] != 7) {
							// IF (MPEG2) { ... }
							// ELSE {
							decodedRatio[i] = tan(cast(double)decodedPos[i] * (PI / 12.0));
							// }
						}
						i++;
					}
				}
				
				scalefactorBand = sfindex_long[header.SamplingFrequency][20];

				for (sb = 576 - sfindex_long[header.SamplingFrequency][21]; sb > 0; sb--) {
					decodedPos[i] = decodedPos[scalefactorBand];
					decodedRatio[i] = decodedRatio[scalefactorBand];
					k[0][i] = k[0][scalefactorBand];
					k[1][i] = k[1][scalefactorBand];
					i++;
				}
			}
  		}

		for (ch = 0; ch < 2; ch++) {
			for (sb = 0; sb < SBLIMIT; sb++) {
				for (ss = 0; ss < SSLIMIT; ss++) {
					normalizedData[ch][sb][ss] = 0;
				}
			}
		}

        if (channels == 2) {
        	for (sb = 0; sb < SBLIMIT; sb++) {
        		for (ss = 0; ss < SSLIMIT; ss++) {
        			i = (sb * 18) + ss;
        			if (decodedPos[i] == 7) {
        				if (msStereo) {
        					normalizedData[0][sb][ss] = (quantizedData[0][sb][ss] + quantizedData[1][sb][ss])
        						/ 1.41421356;
        					normalizedData[1][sb][ss] = (quantizedData[0][sb][ss] - quantizedData[1][sb][ss])
        						/ 1.41421356;
        				}
        				else {
        					normalizedData[0][sb][ss] = quantizedData[0][sb][ss];
        					normalizedData[1][sb][ss] = quantizedData[1][sb][ss];
        				}
        			}
        			else if (intensityStereo) {
        				// IF (MPEG2) {
        				// normalizedData[0][sb][ss] = quantizedData[0][sb][ss] * k[0][i];
        				// normalizedData[1][sb][ss] = quantizedData[0][sb][ss] * k[1][i];
        				// }
        				// ELSE {
        				normalizedData[0][sb][ss] = quantizedData[0][sb][ss] * (decodedRatio[i] / (1 + decodedRatio[i]));
<<<<<<< HEAD:codecs/audio/mp3.d
        				normalizedData[0][sb][ss] = quantizedData[0][sb][ss] * (1 / (1 + decodedRatio[i]));
=======
        				normalizedData[1][sb][ss] = quantizedData[0][sb][ss] * (1 / (1 + decodedRatio[i]));
>>>>>>> 527f80074843e17abec90f465262e2cecf2aa803:codecs/audio/mp3.d
        				// }
        			}
        			else {
        				// Error ...
        			}
        		}
        	}
        }
        else { // Mono
        	for (sb = 0; sb < SBLIMIT; sb++) {
        		for (ss = 0; ss < SSLIMIT; ss++) {
        			normalizedData[0][sb][ss] = quantizedData[0][sb][ss];
        		}
        	}
        }
	}

	void reorder(uint gr, uint ch) {
		int sfreq = header.SamplingFrequency;

		for (uint sb; sb < SBLIMIT; sb++) {
			for (uint ss; ss < SSLIMIT; ss++) {
				reorderedData[sb][ss] = 0;
			}
		}

		if ((blocksplit_flag[gr][ch] == 1) && (block_type[gr][ch] == 2)) {
			if (switch_point[gr][ch] == 0) {
				// Recoder the short blocks
<<<<<<< HEAD:codecs/audio/mp3.d
				uint scalefactorStart = 0;
				uint scalefactorLines = sfindex_short[sfreq][1];

				for (uint scalefactorBand = 3; scalefactorBand < 13; scalefactorBand++) {
=======
				uint scalefactorStart;
				uint scalefactorLines;

				for (uint scalefactorBand; scalefactorBand < 13; scalefactorBand++) {
					scalefactorStart = sfindex_short[sfreq][scalefactorBand];
					scalefactorLines = sfindex_short[sfreq][scalefactorBand + 1] - scalefactorStart;

>>>>>>> 527f80074843e17abec90f465262e2cecf2aa803:codecs/audio/mp3.d
					for (uint window; window < 3; window++) {
						for (uint freq; freq < scalefactorLines; freq++) {
							uint srcLine = (scalefactorStart * 3) + (window * scalefactorLines) + freq;
							uint destLine = (scalefactorStart * 3) + window + (freq * 3);
							reorderedData[destLine / SSLIMIT][destLine % SSLIMIT] =
<<<<<<< HEAD:codecs/audio/mp3.d
								quantizedData[ch][srcLine / SSLIMIT][srcLine % SSLIMIT];
						}
					}
					scalefactorStart = sfindex_short[sfreq][scalefactorBand];
					scalefactorLines = sfindex_short[sfreq][scalefactorBand + 1] - scalefactorStart;
=======
								normalizedData[ch][srcLine / SSLIMIT][srcLine % SSLIMIT];
                                 //   printf("::%d %d %f\n", srcLine, destLine, reorderedData[destLine / SSLIMIT][destLine % SSLIMIT]);
						}
					}
>>>>>>> 527f80074843e17abec90f465262e2cecf2aa803:codecs/audio/mp3.d
				}
			}
			else {
				// We do not reorder the long blocks
				for (uint sb; sb < 2; sb++) {
					for (uint ss; ss < SSLIMIT; ss++) {
<<<<<<< HEAD:codecs/audio/mp3.d
						reorderedData[sb][ss] = quantizedData[ch][sb][ss];
=======
						reorderedData[sb][ss] = normalizedData[ch][sb][ss];
>>>>>>> 527f80074843e17abec90f465262e2cecf2aa803:codecs/audio/mp3.d
					}
				}

				// We reorder the short blocks
<<<<<<< HEAD:codecs/audio/mp3.d
				uint scalefactorStart = sfindex_short[sfreq][3];
				uint scalefactorLines = sfindex_short[sfreq][4] - scalefactorStart;

				for (uint scalefactorBand = 3; scalefactorBand < 13; scalefactorBand++) {
=======
				uint scalefactorStart;
				uint scalefactorLines;

				for (uint scalefactorBand = 3; scalefactorBand < 13; scalefactorBand++) {
					scalefactorStart = sfindex_short[sfreq][scalefactorBand];
					scalefactorLines = sfindex_short[sfreq][scalefactorBand + 1] - scalefactorStart;

>>>>>>> 527f80074843e17abec90f465262e2cecf2aa803:codecs/audio/mp3.d
					for (uint window; window < 3; window++) {
						for (uint freq; freq < scalefactorLines; freq++) {
							uint srcLine = (scalefactorStart * 3) + (window * scalefactorLines) + freq;
							uint destLine = (scalefactorStart * 3) + window + (freq * 3);
							reorderedData[destLine / SSLIMIT][destLine % SSLIMIT] =
<<<<<<< HEAD:codecs/audio/mp3.d
								quantizedData[ch][srcLine / SSLIMIT][srcLine % SSLIMIT];
						}
					}

					scalefactorStart = sfindex_short[sfreq][scalefactorBand];
					scalefactorLines = sfindex_short[sfreq][scalefactorBand+1] - scalefactorStart;
=======
								normalizedData[ch][srcLine / SSLIMIT][srcLine % SSLIMIT];
						}
					}
>>>>>>> 527f80074843e17abec90f465262e2cecf2aa803:codecs/audio/mp3.d
				}
			}
		}
		else {
			// We do not reorder long blocks
			for (uint sb; sb < SBLIMIT; sb++) {
				for (uint ss; ss < SSLIMIT; ss++) {
<<<<<<< HEAD:codecs/audio/mp3.d
					reorderedData[sb][ss] = quantizedData[ch][sb][ss];
=======
					reorderedData[sb][ss] = normalizedData[ch][sb][ss];
>>>>>>> 527f80074843e17abec90f465262e2cecf2aa803:codecs/audio/mp3.d
				}
			}
		}
	}

	// Butterfly anti-alias
	void antialias(uint gr, uint ch) {
		uint subbandLimit = SBLIMIT - 1;
		
		// Ci[i] = [-0.6,-0.535,-0.33,-0.185,-0.095,-0.041,-0.0142,-0.0037];
		// cs[i] = 1.0 / (sqrt(1.0 + (Ci[i] * Ci[i])));
		// ca[i] = ca[i] * Ci[i];

		const double cs[8] = [
			0.85749292571254418689325777610964,
			0.88174199731770518177557399759066,
			0.94962864910273289204833276115398,
			0.98331459249179014599030200066392,
			0.99551781606758576429088040422867,
			0.99916055817814750452934664352117,
			0.99989919524444704626703489425565,
			0.99999315507028023572010150517204
		];

		const double ca[8] = [
			-0.5144957554275265121359546656654,
			-0.47173196856497227224993208871065,
			-0.31337745420390185437594981118049,
			-0.18191319961098117700820587012266,
			-0.09457419252642064760763363840166,
			-0.040965582885304047685703212384361,
			-0.014198568572471148056991895498421,
			-0.0036999746737600368721643755691364
		];

		// Init our working array with quantized data
		for (uint sb; sb < SBLIMIT; sb++) {
			for (uint ss; ss < SSLIMIT; ss++) {
<<<<<<< HEAD:codecs/audio/mp3.d
				hybridData[sb][ss] = quantizedData[ch][sb][ss];
=======
				hybridData[sb][ss] = reorderedData[sb][ss];
>>>>>>> 527f80074843e17abec90f465262e2cecf2aa803:codecs/audio/mp3.d
			}
		}

		if ((blocksplit_flag[gr][ch] == 1) && (block_type[gr][ch] == 2) && (switch_point[gr][ch] == 0)) {
			return;
		}

		if ((blocksplit_flag[gr][ch] == 1) && (block_type[gr][ch] == 2) && (switch_point[gr][ch] == 1)) {
			subbandLimit = 1;
		}

		// 8 butterflies for each pair of subbands
		for (uint sb; sb < subbandLimit; sb++) {
			for (uint ss; ss < 8; ss++) {
<<<<<<< HEAD:codecs/audio/mp3.d
				double bu = quantizedData[ch][sb][17 - ss];
				double bd = quantizedData[ch][sb + 1][ss];
				hybridData[sb][17 - ss] = (bu * cs[ss]) + (bd * ca[ss]);
				hybridData[sb + 1][ss] = (bd * cs[ss]) + (bu * ca[ss]);
			}
		}
=======
				double bu = reorderedData[sb][17 - ss];
				double bd = reorderedData[sb + 1][ss];
				hybridData[sb][17 - ss] = (bu * cs[ss]) - (bd * ca[ss]);
				hybridData[sb + 1][ss] = (bd * cs[ss]) + (bu * ca[ss]);
			}
		}
	}
	// zerodouble initializes to 0.0 instead of nil
	zerodouble[SSLIMIT][SBLIMIT][2] previousBlock;

	void hybridSynthesis(uint gr, uint ch, uint sb) {

		int blockType = block_type[gr][ch];

		if ((blocksplit_flag[gr][ch] == 1) && (switch_point[gr][ch] == 1) && (sb < 2)) {
			blockType = 0;
		}

		double[36] output = inverseMDCT(hybridData[sb], blockType);

		// Overlapping and Adding with Previous Block:
		// The last half gets reserved for the next block, and used in this block
		for (uint ss; ss < SSLIMIT; ss++) {
			polysynthData[ch][sb][ss] = output[ss] + previousBlock[ch][sb][ss];
			previousBlock[ch][sb][ss] = cast(zerodouble)output[ss+18];
		}
	}

	double[] inverseMDCT(double[18] working, int blockType) {
		double[] ret = new double[36];

		// The Constant Parts of the Windowing equations

		const double[36][4] win = [
			// Block Type 0
			// win[i] = sin( (PI / 36) * ( i + 0.5 ) ) ; i = 0 to 35
			[
				0.043619387365336000084, 0.130526192220051573400, 0.216439613938102876070,
				0.300705799504273119100, 0.382683432365089781770, 0.461748613235033911190,
				0.537299608346823887030, 0.608761429008720655880, 0.675590207615660132130,
				0.737277336810123973260, 0.793353340291235165080, 0.843391445812885720550,
				0.887010833178221602670, 0.923879532511286738480, 0.953716950748226821580,
				0.976296007119933362260, 0.991444861373810382150, 0.999048221581857798230,
				0.999048221581857798230, 0.991444861373810382150, 0.976296007119933362260,
				0.953716950748226932610, 0.923879532511286738480, 0.887010833178221824720,
				0.843391445812885831570, 0.793353340291235165080, 0.737277336810124084280,
				0.675590207615660354170, 0.608761429008720877930, 0.537299608346824109080,
				0.461748613235033911190, 0.382683432365089892800, 0.300705799504273341140,
				0.216439613938103181380, 0.130526192220051573400, 0.043619387365336069473
			],
			// Block Type 1
			// win[i] = sin( (PI / 36) * ( i + 0.5 ) ) ; i = 0 to 17
			// win[i] = 1 ; i = 18 to 23
			// win[i] = sin( (PI / 12) * ( i - 18 + 0.5 ) ) ; i = 24 to 29
			// win[i] = 0 ; i = 30 to 35
			[
				0.043619387365336000084, 0.130526192220051573400, 0.216439613938102876070,
				0.300705799504273119100, 0.382683432365089781770, 0.461748613235033911190,
				0.537299608346823887030, 0.608761429008720655880, 0.675590207615660132130,
				0.737277336810123973260, 0.793353340291235165080, 0.843391445812885720550,
				0.887010833178221602670, 0.923879532511286738480, 0.953716950748226821580,
				0.976296007119933362260, 0.991444861373810382150, 0.999048221581857798230,
				1.000000000000000000000, 1.000000000000000000000, 1.000000000000000000000,
				1.000000000000000000000, 1.000000000000000000000, 1.000000000000000000000,
				0.991444861373810382150, 0.923879532511286738480, 0.793353340291235165080,
				0.608761429008720433840, 0.382683432365089448710, 0.130526192220051129310,
				0.000000000000000000000, 0.000000000000000000000, 0.000000000000000000000,
				0.000000000000000000000, 0.000000000000000000000, 0.000000000000000000000
			],
			// Block Type 2
			// win[i] = sin( (PI / 12.0) * (i + 0.5) ) ; i = 0 to 11
			// win[i] = 0.0 ; i = 12 to 35
			[
				0.130526192220051601150, 0.382683432365089781770, 0.608761429008720766900,
				0.793353340291235165080, 0.923879532511286849500, 0.991444861373810382150,
				0.991444861373810382150, 0.923879532511286738480, 0.793353340291235165080,
				0.608761429008720433840, 0.382683432365089448710, 0.130526192220051129310,
				0.000000000000000000000, 0.000000000000000000000, 0.000000000000000000000,
				0.000000000000000000000, 0.000000000000000000000, 0.000000000000000000000,
				0.000000000000000000000, 0.000000000000000000000, 0.000000000000000000000,
				0.000000000000000000000, 0.000000000000000000000, 0.000000000000000000000,
				0.000000000000000000000, 0.000000000000000000000, 0.000000000000000000000,
				0.000000000000000000000, 0.000000000000000000000, 0.000000000000000000000,
				0.000000000000000000000, 0.000000000000000000000, 0.000000000000000000000,
				0.000000000000000000000, 0.000000000000000000000, 0.000000000000000000000
			],
			// Block Type 3
			// win[i] = 0 ; i = 0 to 5
			// win[i] = sin( (PI / 12) * ( i - 6 + 0.5 ) ) ; i = 6 to 11
			// win[i] = 1 ; i = 12 to 17
			// win[i] = sin( (PI / 36) * ( i + 0.5 ) ) ; i = 18 to 35
			[
				0.000000000000000000000, 0.000000000000000000000, 0.000000000000000000000,
				0.000000000000000000000, 0.000000000000000000000, 0.000000000000000000000,
				0.130526192220051601150, 0.382683432365089781770, 0.608761429008720766900,
				0.793353340291235165080, 0.923879532511286849500, 0.991444861373810382150,
				1.000000000000000000000, 1.000000000000000000000, 1.000000000000000000000,
				1.000000000000000000000, 1.000000000000000000000, 1.000000000000000000000,
				0.999048221581857798230, 0.991444861373810382150, 0.976296007119933362260,
				0.953716950748226932610, 0.923879532511286738480, 0.887010833178221824720,
				0.843391445812885831570, 0.793353340291235165080, 0.737277336810124084280,
				0.675590207615660354170, 0.608761429008720877930, 0.537299608346824109080,
				0.461748613235033911190, 0.382683432365089892800, 0.300705799504273341140,
				0.216439613938103181380, 0.130526192220051573400, 0.043619387365336069473
		    ]
		];

		double[4*36] cosLookup = [
			1.000000000000000000000, 0.999048221581857798230, 0.996194698091745545190, 0.991444861373810382150,
			0.984807753012208020310, 0.976296007119933362260, 0.965925826289068312210, 0.953716950748226932610,
			0.939692620785908427900, 0.923879532511286738480, 0.906307787036649936670, 0.887010833178221713700,
			0.866025403784438707610, 0.843391445812885720550, 0.819152044288991798550, 0.793353340291235165080,
			0.766044443118978013450, 0.737277336810124084280, 0.707106781186547572730, 0.675590207615660354170,
			0.642787609686539362910, 0.608761429008720655880, 0.573576436351046159420, 0.537299608346823887030,
			0.500000000000000111020, 0.461748613235034077720, 0.422618261740699441280, 0.382683432365089837290,
			0.342020143325668823930, 0.300705799504273285630, 0.258819045102520739470, 0.216439613938102903830,
			0.173648177666930414450, 0.130526192220051712170, 0.087155742747658360158, 0.043619387365336007023,
			0.000000000000000061230, -0.043619387365335889061, -0.087155742747658013214, -0.130526192220051601150,
			-0.173648177666930303430, -0.216439613938102792810, -0.258819045102520628450, -0.300705799504272952570,
			-0.342020143325668712900, -0.382683432365089726260, -0.422618261740699330260, -0.461748613235033744660,
			-0.499999999999999777950, -0.537299608346823553970, -0.573576436351045826350, -0.608761429008720655880,
			-0.642787609686539362910, -0.675590207615660243150, -0.707106781186547461710, -0.737277336810123973260,
			-0.766044443118977902420, -0.793353340291235054060, -0.819152044288991576510, -0.843391445812885498510,
			-0.866025403784438707610, -0.887010833178221713700, -0.906307787036649936670, -0.923879532511286738480,
			-0.939692620785908316880, -0.953716950748226821580, -0.965925826289068201190, -0.976296007119933251230,
			-0.984807753012208020310, -0.991444861373810382150, -0.996194698091745545190, -0.999048221581857798230,
			-1.000000000000000000000, -0.999048221581857798230, -0.996194698091745545190, -0.991444861373810493170,
			-0.984807753012208131330, -0.976296007119933473280, -0.965925826289068312210, -0.953716950748226932610,
			-0.939692620785908427900, -0.923879532511286849500, -0.906307787036650047690, -0.887010833178221824720,
			-0.866025403784438818630, -0.843391445812885831570, -0.819152044288992020600, -0.793353340291235165080,
			-0.766044443118978013450, -0.737277336810124084280, -0.707106781186547683750, -0.675590207615660354170,
			-0.642787609686539473940, -0.608761429008720877930, -0.573576436351046381460, -0.537299608346824220100,
			-0.500000000000000444080, -0.461748613235034410790, -0.422618261740699940880, -0.382683432365090336890,
			-0.342020143325669379040, -0.300705799504272952570, -0.258819045102520628450, -0.216439613938102820560,
			-0.173648177666930331180, -0.130526192220051628910, -0.087155742747658249136, -0.043619387365336131923,
			-0.000000000000000183690, 0.043619387365335764161, 0.087155742747657888314, 0.130526192220051268080,
			0.173648177666929970360, 0.216439613938102459740, 0.258819045102520295380, 0.300705799504272619500,
			0.342020143325668157790, 0.382683432365089171150, 0.422618261740698830660, 0.461748613235034077720,
			0.500000000000000111020, 0.537299608346823887030, 0.573576436351046048400, 0.608761429008720544860,
			0.642787609686539251890, 0.675590207615660132130, 0.707106781186547350690, 0.737277336810123862240,
			0.766044443118977791400, 0.793353340291234943030, 0.819152044288991576510, 0.843391445812885498510,
			0.866025403784438374540, 0.887010833178221491650, 0.906307787036649714620, 0.923879532511286516430,
			0.939692620785908094830, 0.953716950748226710560, 0.965925826289068312210, 0.976296007119933362260,
			0.984807753012208020310, 0.991444861373810382150, 0.996194698091745545190, 0.999048221581857798230,
		];
		
		// Zero to initialize
		ret[0..$] = 0.0;

		if (blockType == 2) {
			uint N = 12;
			for (uint i; i < 3; i++) {
				double[12] tmp;

				for (uint p; p < N; p++) {
					double sum = 0.0;
					for (uint m; m < (N / 2); m++) {
						sum += working[i + (3 * m)] * cos((PI / cast(double)(2 * N)) * cast(double)((2 * p) + 1 + (N / 2)) * ((2 * m) + 1));
//						if (sum > 0.0) printf("sa:%f\n", sum);
					}
					tmp[p] = sum * win[2][p];
				}
				for (uint p; p < N; p++) {
					ret[(6 * i) + p + 6] += tmp[p];
				}
			}
		}
		else {
			uint N = 36;
			for (uint p; p < 36; p++) {
				double sum = 0.0;
				for (uint m; m < 18; m++) {
					sum += working[m] * cosLookup[(((2 * p) + 1 + 18) * ((2 * m) + 1)) % (4 * 36)];
				}
				ret[p] = sum * win[blockType][p];
			}
		}

		return ret;
	}

	void polyphaseSynthesis(uint gr, uint ss, ref Wavelet toBuffer) {
		double sum;

		uint i;
		uint k;
		uint j;

		long foo;

		double* bufOffsetPtr;
		double* bufOffsetPtr2;

		if (channels == 1) {
			uint channel = 0;

		    bufOffset[channel] = (bufOffset[channel] - 64) & 0x3ff;
		    bufOffsetPtr = cast(double*)&BB[channel][bufOffset[channel]];

			for (i=0; i<64; i++) {
				sum = 0;
				for (k=0; k<32; k++) {
					sum += polysynthData[channel][k][ss] * nCoefficients[i][k];
				}
				bufOffsetPtr[i] = sum;
			}

			for (j=0; j<32; j++) {
				sum = 0;
				for (i=0; i<16; i++) {
					k = j + (i << 5);

					sum += windowCoefficients[k] * BB[channel][((k + (((i + 1) >> 1) << 6)) + bufOffset[channel]) & 0x3ff];
				}

		        if(sum > 0) {
					foo = cast(long)(sum * cast(double)32768 + cast(double)0.5);
		        }
		        else {
					foo = cast(long)(sum * cast(double)32768 - cast(double)0.5);
		        }

				if (foo >= cast(long)32768) {
					toBuffer.write(cast(short)(32768-1));
					//++clip;
				}
				else if (foo < cast(long)-32768) {
					toBuffer.write(cast(short)(-32768));
					//++clip;
				}
				else {
					toBuffer.write(cast(short)foo);
				}

				//printf("%d\n", foo);
			}
		}
		else {
			// INTERLEAVE CHANNELS!

		    bufOffset[0] = (bufOffset[0] - 64) & 0x3ff;
		    bufOffsetPtr = cast(double*)&BB[0][bufOffset[0]];

		    bufOffset[1] = (bufOffset[1] - 64) & 0x3ff;
		    bufOffsetPtr2 = cast(double*)&BB[1][bufOffset[1]];

		    double sum2;

			for (i=0; i<64; i++) {
				sum = 0;
				sum2 = 0;
				for (k=0; k<32; k++) {
					sum += polysynthData[0][k][ss] * nCoefficients[i][k];
					sum2 += polysynthData[1][k][ss] * nCoefficients[i][k];
				}
				bufOffsetPtr[i] = sum;
				bufOffsetPtr2[i] = sum2;
			}

			long[32] ch1;
			long[32] ch2;

			for (j=0; j<32; j++) {
				sum = 0;
				sum2 = 0;
				for (i=0; i<16; i++) {
					k = j + (i << 5);

					sum += windowCoefficients[k] * BB[0][( (k + ( ((i+1)>>1) << 6) ) + bufOffset[0]) & 0x3ff];
					sum2 += windowCoefficients[k] * BB[1][( (k + ( ((i+1)>>1) << 6) ) + bufOffset[1]) & 0x3ff];
				}

		        if(sum > 0) {
					foo = cast(long)(sum * cast(double)32768 + cast(double)0.5);
		        }
		        else {
					foo = cast(long)(sum * cast(double)32768 - cast(double)0.5);
		        }

				if (foo >= cast(long)32768) {
					toBuffer.write(cast(short)(32768-1));
					//++clip;
					ch1[j] = 32768;
				}
				else if (foo < cast(long)-32768) {
					toBuffer.write(cast(short)(-32768));
					//++clip;
					ch1[j] = -32768;
				}
				else {
					toBuffer.write(cast(short)foo);
					ch1[j] = foo;
				}

		        if(sum2 > 0) {
					foo = cast(long)(sum2 * cast(double)32768 + cast(double)0.5);
		        }
		        else {
					foo = cast(long)(sum2 * cast(double)32768 - cast(double)0.5);
		        }

				if (foo >= cast(long)32768) {
					toBuffer.write(cast(short)(32768-1));
					//++clip;
					ch2[j] = 32768;
				}
				else if (foo < cast(long)-32768) {
					toBuffer.write(cast(short)(-32768));
					//++clip;
					ch2[j] = -32768;
				}
				else {
					toBuffer.write(cast(short)foo);
					ch2[j] = foo;
				}

			//	printf("%d\n", ch1[j]);
			}
			
			for (j=0; j < 32; j++) {
//				printf("%d\n", ch2[j]);
			}
		}
>>>>>>> 527f80074843e17abec90f465262e2cecf2aa803:codecs/audio/mp3.d
	}

	uint readBits(uint bits) {
		// read a byte, read bits, whatever necessary to get the value
		//writeln("reading, # bits:", bits, " curbyte:", *curByte);

		uint curvalue;
		uint value = 0;

		uint mask;
		uint maskbits;

		int shift;

		if (curByte >= audioRefLength) {
			// We have consumed everything in our buffer
			return 5;
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

			curvalue = (audioRef[curByte] & (byteMasks[maskbits][curPos]));

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

				if (curByte >= audioRefLength) {
					// We have consumed everything in our buffer
					return value;
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
	uint curByte;
	uint curPos;
		
	uint bufferLength;
	uint audioHeaderLength;

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
	
	ubyte[] audioRef;
	uint audioRefLength;

	ubyte[] audioData;
	ubyte[32] audioHeader;

	uint frame_start;
	uint frame_end;

	uint syncAmount;
	
	uint id3length;
	
	// the main data end pointer
	uint main_data_end;
	uint main_data_begin;

	// the current pointer (of last frame)
	uint cur_data_ptr;

	// cb_limit -- Number of scalefactor bands for long blocks
	// (block_type != 2). This is a constant, 21, for Layer III
	// in all modes and at all sampling frequencies.

	const uint cb_limit = 21;

	// cb_limit_short -- Number of scalefactor bands for long
	// blocks (block_type == 2). This is a constant, 12, for
	// Layer III in all modes and at all sampling frequencies.

	const uint cb_limit_short = 12;

	// scfsi[scfsi_band] -- In Layer III, the scalefactor
	// selection information works similarly to Layers I and
	// II. The main difference is the use of variable
	// scfsi_band to apply scfsi to groups of scalefactors
	// instead of single scalefactors. scfsi controls the
	// use of scalefactors to the granules.

	uint[2][cb_limit] scfsi;

	// part2_3_length[gr] -- This value contains the number of
	// main_data bits used for scalefactors and Huffman code
	// data. Because the length of the side information is
	// always the same, this value can be used to calculate
	// the beginning of the main information for each granule
	// and the position of ancillary information (if used).

	uint[2][2] part2_3_length;
	
	// part2_length -- This value contains the number of
	// main_data bits used for scalefactors and Huffman code
	// data. Because the length of the side information is
	// always the same, this value can be used to calculate
	// the beginning of the main information for each granule
	// and the position of ancillary information (if used).

	uint part2_length;

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

	uint[2][2] big_values;

	// global_gain[gr] -- The quantizer step size information is
	// transmitted in the side information variable global_gain.
	// It is logarithmically quantized. For the application of
	// global_gain, refer to the formula in 2.4.3.4 (ISO 11172-3)

	uint[2][2] global_gain;

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

	uint[2][2] scalefac_compress;
	
	uint[2][2] slen1;
	uint[2][2] slen2;

	const int[16] slen1_interpret = [0, 0, 0, 0, 3, 1, 1, 1, 2, 2, 2, 3, 3, 3, 4, 4];
	const int[16] slen2_interpret = [0, 1, 2, 3, 0, 1, 2, 3, 1, 2, 3, 1, 2, 3, 2, 3];

	// blocksplit_flag[gr] -- signals that the block uses an other
	// than normal (type 0) window. If blocksplit_flag is set,
	// several other variables are set by default:

	// region_address1 = 8 (in case of block_type == 1 or 3)
	// region_address1 = 9 (in case of block_type == 2)
	// region_address2 = 0 and the length of region 2 is zero

	// If it is not set, the value of block_type is zero

	uint[2][2] blocksplit_flag;

	// block_type[gr] -- indicates the window type for the actual
	// granule (see the description of filterbank)

	// type 0 - reserved
	// type 1 - start block
	// type 2 - 3 short windows
	// type 3 - end block

	uint[2][2] block_type;

	// switch_point[gr] -- signals the split point of short/long
	// transforms. The following table shows the number of the
	// scalefactor band above which window switching (i.e.
	// block_type different from 0) is used.

	// switch_point switch_point_l switch_point_s
	//                (num of sb)    (num of sb)
	// --------------------------------------------
	//       0             0              0
	//       1             8              3

	uint[2][2] switch_point;

	// switch_point_l -- Number of the scalefactor band (long
	// block scalefactor band) from which point on window
	// switching is used.

	uint[2][2] switch_point_l;

	// switch_point_s -- Number of the scalefactor band (short
	// block scalefactor band) from which point on window
	// switching is used.

	uint[2][2] switch_point_s;

	// table_select[region][gr] -- different Huffman code tables
	// are used depending on the maximum quantized value and the
	// local statistics of the signal. There are a total of 32
	// possible tables given in 3-Annex-B Table 3-B.7 (ISO 11172-3)

	uint[2][2][3] table_select;

	// subblock_gain[window][gr] -- indicates the gain offset
	// (quantization: factor 4) from the global gain for one
	// subblock. Used only with block type 2 (short windows).
	// The values of the subblock have to be divided by 4.

	uint[2][2][3] subblock_gain;

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

	uint[2][2] region_address1;

	// region_address2[gr] -- counts the number of scalefactor bands
	// which are partially or totally in region 3. Again, if
	// block_type == 2, then the scalefactor bands representing
	// different time slots are counted separately.

	uint[2][2] region_address2;

	// preflag[gr] -- This is a shortcut for additional high
	// frequency amplification of the quantized values. If preflag
	// is set, the values of a table are added to the scalefactors
	// (see 3-Annex B, Table 3-B.6 ISO 11172-3). This is equivalent
	// to multiplication of the requantized scalefactors with table
	// values. preflag is never used if block_type == 2 (short blocks)

	uint[2][2] preflag;

	// scalefac_scale[gr] -- The scalefactors are logarithmically
	// quantized with a step size of 2 or sqrt(2) depending on
	// the value of scalefac_scale:

	// scalefac_scale = 0 ... stepsize = sqrt(2)
	// scalefac_scale = 1 ... stepsize = 2

	uint[2][2] scalefac_scale;

	// count1table_select[gr] -- This flag selects one of two
	// possible Huffman code tables for the region of
	// quadruples of quantized values with magnitude not
	// exceeding 1. (ref to ISO 11172-3)

	// count1table_select = 0 .. Table A of 3-Annex B.7
	// count1table_select = 1 .. Table B of 3-Annex B.7

	uint[2][2] count1table_select;
	
	// scalefac[cb][gr] -- The scalefactors are used to color
	// the quantization noise. If the quantization noise is
	// colored with the right shape, it is masked completely.
	// Unlike Layers I and II, the Layer III scalefactors say
	// nothing about the local maximum of the quantized signal.
	// In Layer III, the blocks stretch over several frequency
	// lines. These blocks are called scalefactor bands and are
	// selected to resemble critical bands as closely as possible.
	
	// The scalefac_compress table shows that scalefactors 0-10
	// have a range of 0 to 15 (maximum length 4 bits) and the
	// scalefactors 11-21 have a range of 0 to 7 (3 bits).

	// If intensity_stereo is enabled (modebit_extension) the
	// scalefactors of the "zero_part" of the difference (right)
	// channel are used as intensity_stereo positions
	
	// The subdivision of the spectrum into scalefactor bands is
	// fixed for every block length and sampling frequency and
	// stored in tables in the coder and decoder. (3-Annex 3-B.8)
	
	// The scalefactors are logarithmically quantized. The
	// quantization step is set with scalefac_scale.

	// scalefac[cb][window][gr] -- same as scalefac[cb][gr] but for
	// different windows when block_type == 2.

	struct ScaleFactor {
		uint[3][13] short_window;
		uint[23] long_window;
	}

	ScaleFactor[2][2] scalefac;

private:

	enum : uint {
		MP3_STATE_INIT,
		MP3_BUFFER_AUDIO,
		MP3_READ_HEADER,
		MP3_AMBIGUOUS_SYNC,
		MP3_READ_CRC,
		MP3_READ_AUDIO_DATA,
		MP3_READ_AUDIO_DATA_SINGLE_CHANNEL,
		MP3_READ_AUDIO_DATA_SCALE_FACTORS,
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

	// Scalefactor Band Indices
	const uint[23][3] sfindex_long = [
		// 44.1
		[0, 4, 8, 12, 16, 20, 24, 30, 36, 44, 52, 62, 74, 90, 110, 134, 162, 196, 238, 288, 342, 418, 576],
		// 48.0
		[0, 4, 8, 12, 16, 20, 24, 30, 36, 42, 50, 60, 72, 88, 106, 128, 156, 190, 230, 276, 330, 384, 576],
		// 32.0
		[0, 4, 8, 12, 16, 20, 24, 30, 36, 44, 54, 66, 82, 102, 126, 156, 194, 240, 296, 364, 448, 550, 576]
	];

	const uint[14][3] sfindex_short = [
		// 44.1
		[0, 4, 8, 12, 16, 22, 30, 40, 52, 66, 84, 106, 136, 192],
		// 48.0
		[0, 4, 8, 12, 16, 22, 28, 38, 50, 64, 80, 100, 126, 192],
		// 32.0
		[0, 4, 8, 12, 16, 22, 30, 42, 58, 78, 104, 138, 180, 192]
	];
<<<<<<< HEAD:codecs/audio/mp3.d
=======
	
	// Synthesis Filter Working Area:
	int bufOffset[2] = [64,64];
	zerodouble BB[2][2*512];
>>>>>>> 527f80074843e17abec90f465262e2cecf2aa803:codecs/audio/mp3.d

	// Static Huffman tables

	// Imports huffmanTables[][][] and huffmanValues[][]
	// These are in an array from 0 - 16 and then table 24 being 17
	// Index as: huffmanTables[tableIndex][bitlength][value]
	//           huffmanValues[tableIndex][value]
	// Both tables correspond in their order.
	import codecs.audio.mp3Huffman;

	uint[][] curTable;
	uint[] curValues;
	uint linbits;

	// Select the table to use for decoding and reset state.
	void initializeHuffman(uint region, uint gr, uint ch) {
		uint tableIndex = table_select[region][gr][ch];
		
		switch (tableIndex) {

			case 16:
				linbits = 1;
				break;

			case 17:
				linbits = 2;
				break;

			case 18:
				linbits = 3;
				break;

			case 24:
			case 19:
				linbits = 4;
				break;
				
			case 25:
				linbits = 5;
				break;

			case 26:
			case 20:
				linbits = 6;
				break;

			case 27:
				linbits = 7;
				break;

			case 28:
			case 21:
				linbits = 8;
				break;

			case 29:
				linbits = 9;
				break;

			case 22:
				linbits = 10;
				break;

			case 30:
				linbits = 11;
				break;

			case 31:
			case 23:
				linbits = 13;
				break;

			default:
				linbits = 0;
				break;
		}

		if (tableIndex >= 24) {
			tableIndex = 17;
		}
		else if (tableIndex >= 16) {
			tableIndex = 16;
		}

<<<<<<< HEAD:codecs/audio/mp3.d
		curTable = huffmanTables[tableIndex];
=======
		// XXX: This silliness is due to a compiler bug in DMD 1.046
		if (tableIndex == 17) {
			curTable = huffmanTable24;
		}
		else {
			curTable = huffmanTables[tableIndex];
		}
>>>>>>> 527f80074843e17abec90f465262e2cecf2aa803:codecs/audio/mp3.d
		curValues = huffmanValues[tableIndex];
	}

	int[] readCode() {
		uint code;
		uint bitlength;
		uint valoffset;

		for(;;) {
			code <<= 1;
			code |= readBits(1);
<<<<<<< HEAD:codecs/audio/mp3.d
=======
			
			if (bitlength > curTable.length) {
				break;
			}
>>>>>>> 527f80074843e17abec90f465262e2cecf2aa803:codecs/audio/mp3.d

			foreach(uint i, foo; curTable[bitlength]) {
				if (foo == code) {
					// found code

					// get value offset
					valoffset += i;
					valoffset *= 2;

     				int[] values = [curValues[valoffset], curValues[valoffset+1]];
<<<<<<< HEAD:codecs/audio/mp3.d
     				Console.putln("b:", values[0], " ", values[1]);
=======
     			//	Console.putln("b:", values[0], " ", values[1]);
>>>>>>> 527f80074843e17abec90f465262e2cecf2aa803:codecs/audio/mp3.d

					// read linbits (x)
					if (linbits > 0 && values[0] == 15) {
						values[0] += readBits(linbits);
					}

					if (values[0] > 0) {
						if (readBits(1) == 1) {
							values[0] = -values[0];
						}
					}

					if (linbits > 0 && values[1] == 15) {
						values[1] += readBits(linbits);
					}

					if (values[1] > 0) {
						if (readBits(1) == 1) {
							values[1] = -values[1];
						}
					}

<<<<<<< HEAD:codecs/audio/mp3.d
     				Console.putln("a:", values[0], " ", values[1]);
					return [curValues[valoffset], curValues[valoffset+1]];
=======
     				//Console.putln("a:", values[0], " ", values[1]);
					return values;
>>>>>>> 527f80074843e17abec90f465262e2cecf2aa803:codecs/audio/mp3.d
				}
			}

			valoffset += curTable[bitlength].length;
			bitlength++;
			if (bitlength >= curTable.length) {
				return [128, 128];
			}
		}

		return [128, 128];
	}

	uint curCountTable;

	void initializeQuantizationHuffman(uint gr, uint ch) {
		curCountTable = count1table_select[gr][ch];
	}

	int[] readQuantizationCode() {
		uint code = decodeQuantization();

		int v = ((code >> 3) & 1);
		int w = ((code >> 2) & 1);
		int x = ((code >> 1) & 1);
		int y = (code & 1);

		// Get Sign Bits (for non-zero values)

		if (v > 0 && readBits(1) == 1) {
			v = -v;
		}

		if (w > 0 && readBits(1) == 1) {
			w = -w;
		}

		if (x > 0 && readBits(1) == 1) {
			x = -x;
		}

		if (y > 0 && readBits(1) == 1) {
			y = -y;
		}

<<<<<<< HEAD:codecs/audio/mp3.d
     	Console.putln("q:", v, " ", w, " ", x, " ", y);
=======
	//	Console.putln("v: ", v, " w: ", w, " x: ", x , " y: ",y );
>>>>>>> 527f80074843e17abec90f465262e2cecf2aa803:codecs/audio/mp3.d

		return [v,w,x,y];
	}

	uint decodeQuantization() {
		uint code;

		if (curCountTable == 1) {
			// Quantization Huffman Table B is trivial...
			// It is simply the bitwise negation of 4 bits from the stream.
			// code = ~readBits(4);
			code = readBits(4);
			code = ~code;
		}
		else {
			// Quantization Huffman Table A is the only case,
			// so it is written here by hand:

			// state 1
			code = readBits(1);

			if (code == 0b1) {
				return 0b0000;
			}

			// state 2
			code = readBits(3);

			if (code >= 0b0100 && code <= 0b0111) {
				uint idx = code - 0b0100;
				const uint[] stage2_values = [0b0010, 0b0101, 0b0110, 0b0111];
				return stage2_values[idx];
			}

			// state 3
			code <<= 1;
			code |= readBits(1);

			if (code >= 0b00011 && code <= 0b00111) {
				uint idx = code - 0b00011;
				const uint[] stage3_values = [0b1001, 0b0110, 0b0011, 0b1010, 0b1100];
				return stage3_values[idx];
			}

			// state 4
			code <<= 1;
			code |= readBits(1);

			if (code <= 0b000101) {
				const uint[] stage4_values = [0b1011, 0b1111, 0b1101, 0b1110, 0b0111, 0b0101];
				return stage4_values[code];
			}

			// invalid code;
			code = 0;
		}

		return code;
	}

<<<<<<< HEAD:codecs/audio/mp3.d
	// Quadruples (A)

	// Note: Quadruples (B) is trivial, and is considered a special case
	//     : It is simply ~readBits(4);
=======
	import codecs.audio.mpegCommon;

	bool accepted = false;

	// number of blocks (of 1728 samples) to buffer
	const auto NUM_BLOCKS = 40;
>>>>>>> 527f80074843e17abec90f465262e2cecf2aa803:codecs/audio/mp3.d
}