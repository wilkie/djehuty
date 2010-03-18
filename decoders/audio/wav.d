/*
 * wav.d
 *
 * This file implements the WAV audio standard. A "wave" is a chunked format
 * and a container format. It contains audio data in a myriad of different
 * encodings.
 *
 * Author: Dave Wilkinson
 *
 */

module decoders.audio.wav;

import decoders.audio.decoder;
import decoders.audio.mp2 : MP2Decoder;

import decoders.decoder;

import core.stream;
import core.time;
import core.string;
import core.definitions;

import io.wavelet;
import io.audio;
import io.console;

// Section: Codecs/Audio

// Description: This is the Microsoft Wave file codec.
class WAVDecoder : AudioDecoder {

	override string name() {
		return "Microsoft Wave";
	}

	override string extension() {
		return "wav;wave";
	}

	StreamData decode(Stream stream, Wavelet toBuffer, ref AudioInfo wi) {
		for (;;) {
			switch (decoderState) {
				case WAVE_STATE_INIT:
					//initial stuff

					decoderState = WAVE_STATE_READ_RIFF;

					// *** fall through *** //
				case WAVE_STATE_READ_RIFF:

					// read in the RIFF header
					// and check the validity

					//reading the header
					if (!stream.read(&RIFFHeader, RIFFHeader.sizeof)) {
						return StreamData.Required;
					}

					if (RIFFHeader.magic != *(cast(uint*)"RIFF"c.ptr)) {
						// RIFF header is wrong
						Console.putln("WAVE: Invalid RIFF Header");
						return StreamData.Invalid;
					}

					decoderState = WAVE_STATE_READ_CHUNK;

					// *** fall through *** //
				case WAVE_STATE_READ_CHUNK:

					// read in a chunk header
					if (!stream.read(&curChunk, curChunk.sizeof)) {
						return StreamData.Required;
					}

					char arr[4] = (cast(char*)&curChunk.chunkID)[0..4];

					// figure out what the chunk means
					if (curChunk.chunkID == *(cast(uint*)"data"c.ptr)) {
						// DATA Chunk
						decoderState = WAVE_STATE_CHUNK_DATA;

						// Get Audio Length
						//Console.putln(curChunk.chunkSize, " , ", FMTHeader.avgBytesPerSecond, " = ", (cast(float)curChunk.chunkSize / cast(float)FMTHeader.avgBytesPerSecond));
						wi.totalTime = cast(long)((cast(float)curChunk.chunkSize / cast(float)FMTHeader.avgBytesPerSecond) * 1000.0);

						dataToRead = curChunk.chunkSize;
						continue;
					}
					else if (curChunk.chunkID == *(cast(uint*)"fmt "c.ptr)) {
						// FMT Chunk
						decoderState = WAVE_STATE_CHUNK_FMT;
						continue;
					}
					else {
						// Unknown Chunk
						// Just skip it
						decoderState = WAVE_STATE_SKIP_CHUNK;
					}

					// *** fall through on an unknown chunk *** //
				case WAVE_STATE_SKIP_CHUNK:
					if (!stream.skip(curChunk.chunkSize)) {
						return StreamData.Required;
					}
					decoderState = WAVE_STATE_READ_CHUNK;
					continue;

					// -- Process a Chunk -- //

				case WAVE_STATE_CHUNK_DATA:

					// if the buffer is null, this is acceptable
					// in this case, the decoder will wait

					/*	Console.putln("to seek");
						toSeek.toString();
						Console.putln("cur");
						bufferTime.toString();*/

					uint bufferSize = FMTHeader.avgBytesPerSecond << 1 ;

					if (isSeek && !isSeekBack && (toSeek < (curTime + bufferTime))) {
						// seeking
						Console.putln("seek no more");
						isSeek = false;
						return StreamData.Accepted;
					}
					else if (isSeek && isSeekBack && (toSeek >= curTime)) {
						// seeking
						Console.putln("seek no more");
						isSeek = false;
						return StreamData.Accepted;
					}
					else if (toBuffer is null && isSeek == false) {
						return StreamData.Accepted;
					}

					if (isSeek && isSeekBack) {
						// go backwards

						if (dataToRead == 0 && (curChunk.chunkSize % bufferSize) != 0) {
							if (!stream.rewind(curChunk.chunkSize % bufferSize)) {
								Console.putln("Audio Codec : Data Required");
								return StreamData.Required;
							}

							dataToRead = curChunk.chunkSize % bufferSize;

							curTime -= bufferTime;

						}
						else {

							if (!stream.rewind(FMTHeader.avgBytesPerSecond << 1)) {
								Console.putln("Audio Codec : Data Required");
								return StreamData.Required;
							}

							curTime -= bufferTime;

							dataToRead += FMTHeader.avgBytesPerSecond << 1;
						}
						continue;
					}
					//writeln("Audio Codec : Decoding Data Chunk");

					if (dataToRead == 0) {
						return StreamData.Complete;
					}

					// we should have a format header
					if (!formatHeaderFound) {
						// no format header, yet...
						// this file is invalid
						return StreamData.Invalid;
					}

					if (FMTHeader.compressionCode == 0x50) {
						if (embeddedCodec is null) {
							embeddedCodec = new MP2Decoder();
						}
						return embeddedCodec.decode(stream, toBuffer, wi);
					}
					else if (FMTHeader.compressionCode == 1 || FMTHeader.compressionCode == 3) {
						// are we getting the last piece?
						if (dataToRead < bufferSize) {
							//writeln("Audio Codec : Allocating ", dataToRead, " bytes (last chunk)");
							// allocate a whole buffer

							if (toBuffer !is null) {
								toBuffer.setAudioFormat(wf);

								if (toBuffer.length() != dataToRead) {
									// allocate
									//  (this may look redundant, but this may occur
									//   when there is only one chunk in the file)
//									Console.putln("Audio Codec : Resizing : " , toBuffer.length(), " : ", dataToRead);
//									toBuffer.resize(dataToRead);
								}
								toBuffer.rewind();

								//writeln("Audio Codec : Appending ", dataToRead, " bytes (last chunk)");

								// this is the last chunk of data
								if (!toBuffer.write(stream, dataToRead)) {
									Console.putln("Audio Codec : Data Required");
									return StreamData.Required;
								}
							}
							else {
								if (!stream.skip(dataToRead)) {
									//writeln("Audio Codec : Data Required");
									return StreamData.Required;
								}
							}

							dataToRead = 0;
							curTime += bufferTime;

							// go back to reading chunks
							//decoderState = WAVE_STATE_READ_CHUNK;

							return StreamData.Complete;
						}
						else {
							//writeln("Audio Codec : Allocating ", bufferSize, " bytes");
							// allocate a whole buffer

							if (toBuffer !is null) {
								toBuffer.setAudioFormat(wf);
								if (toBuffer.length() != bufferSize) {
									// allocate
//									Console.putln("Audio Codec : Resizing : " , toBuffer.length(), " : ", bufferSize);
//									toBuffer.resize(bufferSize);
								}
								toBuffer.rewind();
								//writeln("Audio Codec : Appending ", bufferSize, " bytes");

								// Read in a second worth of information
								if (!toBuffer.write(stream, bufferSize)) {
									//writeln("Audio Codec : Data Required");
									return StreamData.Required;
								}
								curTime += bufferTime;
								curTime.toString();

								dataToRead -= bufferSize;
								return StreamData.Accepted;
							}
							else {
								if (!stream.skip(bufferSize)) {
									//writeln("Audio Codec : Data Required");
									return StreamData.Required;
								}

								dataToRead -= bufferSize;
								curTime += bufferTime;
							}


							// add the amount of time to decoder's time counter
							// this is the time stamp of the next data block
						}
					}

					continue;

				case WAVE_STATE_CHUNK_FMT:

					// Read in the format information

					if (!stream.read(&FMTHeader, FMTHeader.sizeof)) {
						return StreamData.Required;
					}

					// TODO: just have a state selector (can use nextState or subState within CodecState decoder!)

					if (FMTHeader.compressionCode != 0x01 &&
						FMTHeader.compressionCode != 0x03 &&
						FMTHeader.compressionCode != 0x50) {

						Console.putln("WAVE: Unsupported Compression Type");
						return StreamData.Invalid;
					}

					if (FMTHeader.compressionCode == 1 || FMTHeader.compressionCode == 3) {
						wf.compressionType = FMTHeader.compressionCode;

						wf.numChannels = FMTHeader.numChannels;
						wf.samplesPerSecond = FMTHeader.sampleRate;
						wf.averageBytesPerSecond =
							//FMTHeader.sampleRate * (FMTHeader.significantBitsPerSample / 8) * FMTHeader.numChannels;
							FMTHeader.avgBytesPerSecond;
						wf.blockAlign = FMTHeader.blockAlign;
						wf.bitsPerSample = FMTHeader.significantBitsPerSample;

						// Output for sanity check

						/*
						Console.putln("  Comression Code: ", wf.compressionType);
						Console.putln("  Sample Frequency: ", wf.samplesPerSecond);
						Console.putln("  Average Bytes Per Second: ", wf.averageBytesPerSecond);
						Console.putln("  Number of Channels: ", wf.numChannels);
						Console.putln("  Bits per Sample: ", wf.bitsPerSample);
						Console.putln("  Block Align: ", wf.blockAlign );

						Console.putln("");
						*/

						bufferTime = new Time(2000000);

					}
					else {
						Console.putln("WAVE: Alternate Codec Requested Via Compression Code");
						embeddedCodec = null;
					}

					formatHeaderFound = true;

					stream.rewind(FMTHeader.sizeof);

					decoderState = WAVE_STATE_SKIP_CHUNK;
					continue;

				default:
					// -- Default for corrupt files -- //
					break;
			}
			break;
		}
		return StreamData.Invalid;
	}

	// Description: This function will advance the stream to the beginning of the buffer that contains the time requested.
	StreamData seek(Stream stream, AudioFormat wf, AudioInfo wi, ref Time amount) {
		if (decoderState == 0) {
			// not inited?
			return StreamData.Invalid;
		}

		if (FMTHeader.compressionCode == 0x50 && embeddedCodec !is null) {
			StreamData ret = embeddedCodec.seek(stream, wf, wi, amount);
			amount -= embeddedCodec.getCurrentTime();
			return ret;
		}
		else if (!(FMTHeader.compressionCode == 1 || FMTHeader.compressionCode == 3)) {
			return StreamData.Invalid;
		}

		if (amount == curTime) {
			Console.putln("ON TIME");
			return StreamData.Accepted;
		}

		if (amount > curTime) {
			Console.putln("WE NEED TO GO AHEAD");
			// good!
			// simply find the section we need to be
			// we are buffering 2 seconds...
			toSeek = amount;
			isSeekBack = false;
			isSeek = true;
			StreamData ret = decode(stream, null, wi);
			amount -= curTime;
			return ret;
		}
		else {
			Console.putln("WE NEED TO FALL BEHIND");
			// for wave files, this is not altogether a bad thing
			// for other types of files, it might be
			// mp3 can be variable, and would require a seek from the
			// beginning or maintaining a cache of some sort.
			toSeek = amount;
			isSeekBack = true;
			isSeek = true;
			StreamData ret =  decode(stream, null, wi);
			amount -= curTime;
			return ret;
		}
	}

	Time length(Stream stream, ref AudioFormat wf, ref AudioInfo wi) {
		Time tme = Time.init;
		return tme;
	}

	Time lengthQuick(Stream stream, ref AudioFormat wf, ref AudioInfo wi) {
		Time tme = Time.init;
		return tme;
	}

private:

	align(2) struct _djehuty_wave_riff_header {
		uint magic;
		uint filesize;
		uint rifftype;
	}

	align(2) struct _djehuty_wave_chunk_header {
		uint chunkID;
		uint chunkSize;
	}

	struct _djehuty_wave_format_chunk {
		ushort compressionCode;
		ushort numChannels;
		uint sampleRate;
		uint avgBytesPerSecond;
		ushort blockAlign;
		ushort significantBitsPerSample;
		ushort extraBytes;
	}

	const auto WAVE_STATE_INIT 			= 0;
	const auto WAVE_STATE_READ_RIFF		= 1;
	const auto WAVE_STATE_READ_CHUNK	= 2;
	const auto WAVE_STATE_SKIP_CHUNK	= 3;

	const auto WAVE_STATE_CHUNK_FMT		= 4;
	const auto WAVE_STATE_CHUNK_DATA	= 5;

protected:

	_djehuty_wave_riff_header RIFFHeader;
	_djehuty_wave_format_chunk FMTHeader;


	_djehuty_wave_chunk_header curChunk;

	bool formatHeaderFound = false;
	uint dataToRead = 0;

	AudioDecoder embeddedCodec;

	AudioFormat wf;
	Time bufferTime;
}
