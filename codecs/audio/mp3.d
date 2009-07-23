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

					if ((mpeg_header & MPEG_SYNC_BITS) == MPEG_SYNC_BITS)
					{
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
						//audioDataLength = cast(uint)(144 * (cast(double)bitRates[header.BitrateIndex] / cast(double)samplingFrequencies[header.SamplingFrequency]));
						//if (header.Padding) { audioDataLength++; }

						// subtract the size of the header
						//audioDataLength -= 4;

						// allocate the buffer
						//audioData = new ubyte[audioDataLength];

					//	writeln("Audio Data Length: ", audioDataLength);
					//	writeln("curByte: ", audioData.ptr);


						// set the format of the wave buffer

						if (header.SamplingFrequency == 0)
						{
							// 44.1 kHz
							wf.samplesPerSecond = 44100;
						}
						else if (header.SamplingFrequency == 1)
						{
							// 48 kHz
							wf.samplesPerSecond = 48000;
						}
						else
						{
							// 32 kHz
							wf.samplesPerSecond = 32000;
						}

						wf.compressionType = 1;

						switch(header.Mode)
						{
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
						if (toBuffer !is null)
						{
							toBuffer.setAudioFormat(wf);
							bufferTime = toBuffer.time;
						}

						if (header.Protected == 0)
						{
						//	decoderState = MP2_READ_CRC;
						}
						else
						{
						//	decoderState = MP2_READ_AUDIO_DATA;
						}
						break;

//						continue;
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

				default:
					break;
			}
			break;
		}
		return StreamData.Invalid;
	}

protected:

	// header for the frame
	uint mpeg_header;

	// bit building
	ubyte* curByte;
	uint curPos;

	// header information for the frame
	MP3HeaderInformation header;

	// the number of channels present
	uint channels;

	// the number of samples left to decode
	uint samplesLeft;

	// the buffer size and information
	uint bufferSize;
	Time bufferTime;
	AudioFormat wf;

	uint audioDataLength;

	ubyte audioData[];

	uint syncAmount;

private:

	enum : uint {
		MP3_STATE_INIT,
		MP3_BUFFER_AUDIO,
		MP3_READ_HEADER,
		MP3_AMBIGUOUS_SYNC,
	}

	struct MP3HeaderInformation {
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
}