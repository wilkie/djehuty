module io.wavelet;

import core.stream;
import core.string;
import core.definitions;
import core.time;

import io.audio;
import io.console;

import math.common;
import math.vector;

enum Interpolate {
	Zeroth,
	Linear,
}

// Section: Core/Streams

// Description: This class represents an audio buffer.  You can do simple transforms on the audio data using the provided methods.  It is essentially a Stream, and you can read and write to the buffer in the same fashion.
class Wavelet : Stream {
	// Constructors //

	// Description: Will create a small buffer.  This will presumedly be resized.
	this() {
		super(1);
	}

	// -- Methods -- //

	// Description: Will get the format of the audio information.
	// Returns: An AudioFormat struct containing useful information such as sample rate and average bytes per second.
	AudioFormat audioFormat() {
		return _fmt;
	}

	// Description: Will set the audio format of the buffer.  Audio Codecs will set this automatically, but if the buffer format is otherwise unknown, it can be set using this function.
	// audFormat: An AudioFormat struct describing the contents of the buffer.
	void setAudioFormat(AudioFormat audFormat) {
		_fmt = audFormat;
	}



	// -- Computations -- //

	void upSample(Interpolate interpType) {
	}

	void downSample(Interpolate interpType) {
	}

	void pitchBend() {
	}

	void pitchShift() {
	}

	// Description: This function will shorten the wavelet to a specified region.
	void crop(Time start) {
		// is this necessary?
		if (start > time() || start is null) {
			// error
			Console.put("error");
			return;
		}

		Time len = time() - start;

		int newLength;
		int newStartPos;

		ubyte olddata[] = _data;


		newLength = cast(int)((_fmt.averageBytesPerSecond / 1000) * (len.toMicroseconds / 1000));
		newStartPos = cast(int)((_fmt.averageBytesPerSecond / 1000) * (start.toMicroseconds / 1000));

		_data = new ubyte[newLength];
		_data[0..$] = olddata[newStartPos..(newStartPos + newLength)];

		_length = newLength;
		_capacity = newLength;

	}

	// Description: This function will shorten the wavelet to a specified region.
	void crop(Time start, Time len) {
		// is this necessary?
		if (start > time()) {
			// error
			Console.put("error");
			return;
		}

		if (len + start > time()) {
			// error
			Console.put("error");
			return;
		}

		int newLength;
		int newStartPos;

		ubyte olddata[] = _data;


		newLength = cast(int)((_fmt.averageBytesPerSecond / 1000) * (len.toMicroseconds / 1000));
		newStartPos = cast(int)((_fmt.averageBytesPerSecond / 1000) * (start.toMicroseconds / 1000));

		_data = new ubyte[newLength];
		_data[0..$] = olddata[newStartPos..(newStartPos + newLength)];

		_length = newLength;
		_capacity = newLength;

	}

	// Description: This function will return the amount of time this block represents
	Time time() {
		Time tme = new Time();

		// the amount of bytes / amount of bytes per second = seconds
		if (_fmt.averageBytesPerSecond == 0) {
			return tme;
		}

		float amtSeconds = (cast(float)length() / cast(float)_fmt.averageBytesPerSecond);

		tme.fromMicroseconds(cast(long)(amtSeconds * 1000000));

		return tme;
	}

	cdouble[] fourier(int samples = 512, uint skipSamples = 0) {
		if ((samples + skipSamples) * _fmt.numChannels > (this.length / 2)) {
			samples = cast(int)((this.length / 2 / _fmt.numChannels) - skipSamples);
		}
		if (samples < 0) {
			return [];
		}

		uint rem = 1;

		// floor samples to nearest power of 2
		while(samples > 0) {
			samples >>= 1;
			rem <<= 1;
		}
		rem >>= 1;

		cdouble[] ret = new cdouble[rem];

		// I'll just average the channels, if possible
		short* ptr = cast(short*)&_data[0];

		size_t idx = skipSamples * _fmt.numChannels;
		for(size_t sample = 0; sample < rem; sample++, idx += _fmt.numChannels) {
			cdouble data = 0.0 + 0.0i;
			for(size_t channel = 0; channel < _fmt.numChannels; channel++) {
				data += (cast(cdouble)ptr[idx + channel] / cast(cdouble)short.max);
			}
			ret[sample] = data / _fmt.numChannels;
		}

		return ret.fft();
	}

private:

	// Reference to the Audio Format
	// of this collection of samples

	// This is used for playback and is
	// also used for calculations and
	// transformations

	AudioFormat _fmt;
}

//alias WaveletImpl!(StreamAccess.AllAccess) Wavelet;
