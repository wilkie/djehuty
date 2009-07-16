module io.wavelet;

import core.stream;
import core.string;
import core.literals;
import core.definitions;
import core.time;

import io.audio;
import io.console;

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
	AudioFormat getAudioFormat() {
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
		if (start > time() || start == Time.init) {
			// error
			Console.put("error");
			return;
		}

		Time len = time() - start;

		int newLength;
		int newStartPos;

		ubyte olddata[] = _data;


		newLength = cast(int)((_fmt.averageBytesPerSecond / 1000) * (len.micros / 1000));
		newStartPos = cast(int)((_fmt.averageBytesPerSecond / 1000) * (start.micros / 1000));

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


		newLength = cast(int)((_fmt.averageBytesPerSecond / 1000) * (len.micros / 1000));
		newStartPos = cast(int)((_fmt.averageBytesPerSecond / 1000) * (start.micros / 1000));

		_data = new ubyte[newLength];
		_data[0..$] = olddata[newStartPos..(newStartPos + newLength)];

		_length = newLength;
		_capacity = newLength;

	}

	// Description: This function will return the amount of time this block represents
	Time time() {
		Time tme;

		// the amount of bytes / amount of bytes per second = seconds
		if (_fmt.averageBytesPerSecond == 0) {
			return tme;
		}

		float amtSeconds = (cast(float)length() / cast(float)_fmt.averageBytesPerSecond);

		tme.fromMicroseconds(cast(long)(amtSeconds * 1000000));

		return tme;
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
