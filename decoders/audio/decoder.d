/*
 * codec.d
 *
 * This file implements the abstraction for an audio codec.
 *
 * Author: Dave Wilkinson
 *
 */

module decoders.audio.decoder;

import decoders.decoder;

import core.string;
import core.time;
import core.stream;

import io.audio;
import io.wavelet;
import io.console;

// Section: Interfaces

// Description: The interface to an audio codec.
abstract class AudioDecoder : Decoder {
public:

	this() {
		curTime = new Time();
	}

	StreamData decode(Stream stream, Wavelet toBuffer, ref AudioInfo wf) {
		return StreamData.Invalid;
	}

	StreamData seek(Stream stream, AudioFormat wf, AudioInfo wi, ref Time amount) {
		return StreamData.Invalid;
	}

	override String name() {
		return new String("Unknown Audio Codec");
	}

	Time getCurrentTime() {
		return curTime;
	}

protected:


	// For some decoders to aid in seeks
	// through the stream
	struct SeekPointer {
		Time time;
		ulong streamPosition;

		void* metaData; // maybe a place for metadata
	}
	SeekPointer seekLUT[];

	// current time frame
	Time curTime;
	Time toSeek;
	bool isSeek;
	bool isSeekBack; // whether we are seeking backward
}
