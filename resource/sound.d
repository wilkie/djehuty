/*
 * sound.d
 *
 * This file implements the Sound class. This class is a high-level accessor
 * of the audio device. It will play audio files.
 *
 * Author: Dave Wilkinson
 *
 */

module resource.sound;

import core.time;
import core.string;
import core.event;
import core.definitions;
import core.stream;

import synch.thread;
import synch.timer;

import io.wavelet;
import io.audio;
import io.file;
import io.console;

import decoders.audio.decoder;
import decoders.audio.all;

import math.sqrt;

// Section: Enums

// Section: Core/Resources

// Description: The state of a Sound object indicates the state of the audio it is in charge of playing.
enum State {
	// Description: Indicates that the Sound object is currently paused.
	Paused,
	// Description: Indicates that the Sound object is currently stopped.
	Stopped,
	// Description: Indicates that the Sound object is currently playing.
	Playing,
}

// Description: This class will abstract away the low-level Audio class.  It can load an audio file and control its playback with simple and common interactions.
class Sound : Responder {
private:

	Wavelet buffers[2];
	uint bufferIndex;

	ulong curPos;

	AudioDecoder _curCodec;
	Stream inStream;

	Audio wavDevice;
	AudioFormat wavFormat;
	AudioInfo wavInfo;

	State _state;

	string _name;

	// the time that the audio device has is the amount of data
	// that has been fed to the audio device

	// this may be different to our perception of how much of a
	// particular file or stream has been played
	Time _synch;

	bool _doneBuffering;

	int curDecoder;

	Thread _audioLoader;

	void _bufferCallback() {
		//	Console.putln("Callback");
		if (_state == State.Stopped) { return; }
		if (_doneBuffering) {
			//Console.putln("Done");
			_state = State.Stopped;
			raiseSignal(Signal.StateChanged);
			return;
		}

		buffers[bufferIndex].rewind();
		buffers[bufferIndex].resize(1728 * 40);
		StreamData ret = _curCodec.decode(inStream, buffers[bufferIndex], wavInfo);

		// send the next buffer
		if (ret == StreamData.Complete) {
			//Console.putln("Sound : Decoded Last Buffer");
			wavDevice.sendBuffer(buffers[bufferIndex], true);

			_doneBuffering = true;
		}
		else {
		//	Console.putln("Sound : Decoded Buffer");
			wavDevice.sendBuffer(buffers[bufferIndex]);
		}


		if (bufferIndex == 0) {
			bufferIndex = 1;
		}
		else {
			bufferIndex = 0;
		}
	}

public:
	enum Signal {
		StateChanged,
	}

	// Only temporary.. the user will be expected to do this themselves.
	Timer tmr;

	void timerProc() {
		//getPositionString();
	}

	// Description: This constructor will create the object and load the file using the filename passed.
	// filename: The string containing the filename of the audio file to load.
	this(string filename) {
		attach(wavDevice = new Audio);

		tmr = new Timer();
		tmr.interval = 250;

		attach(tmr);

		load(filename);
	}

	~this() {
		tmr.stop();
	}

	override bool onSignal(Dispatcher dsp, uint signal) {
		if (dsp is wavDevice && signal == Audio.Signal.BufferPlayed) {
			_bufferCallback();
		}
		else if (dsp is tmr) {
			timerProc();
		}
		return true;
	}

	// Description: This function will load the file using the filename passed, stopping and unloading any current audio playback.
	// filename: The string containing the filename of the audio file to load.
	bool load(string filename) {
		_name = filename.dup;
		load(File.open(filename));

		return false;
	}

	// Description: This function will stream the audio using the stream given, stopping and unloading any current audio playback.
	// stream: The Stream containing the audio information to decode.
	StreamData load(Stream stream) {
		_doneBuffering = false;
		_state = State.Paused;

		buffers[0] = new Wavelet();
		buffers[1] = new Wavelet();

		inStream = stream;

		StreamData ret = StreamData.Invalid;

		if (_name !is null) {
			// get extension
			string name =_name.dup;
			int pos = name.findReverse(".");
			string extension = name.substring(pos+1);
			_curCodec = findBestCodec(extension);
			if (_curCodec !is null) {
				ret = _curCodec.decode(inStream, cast(Wavelet)null, wavInfo);
			}
		}

		// Find the correct audio codec for this audio stream
		if (ret == StreamData.Invalid) {
			ret = runAllCodecs(_curCodec, inStream, cast(Wavelet)null, wavInfo);
		}

		if (ret == StreamData.Invalid || ret == StreamData.Required) { return ret; }
//		Console.putln("Sound: Codec name: ", _curCodec.name);

//		Console.putln("Sound: Audio File Loaded : Length: ", wavInfo.totalTime);
		//getTotalTimeString();

		buffers[0].resize(1728 * 22);
//		Console.putln("Size: ", buffers[0].length);
		ret = _curCodec.decode(inStream, buffers[0], wavInfo);

//		Console.putln("Sound : Creating Device");
//		Console.putln("Sound : Opening");
		wavDevice.openDevice(buffers[0].audioFormat());
		wavDevice.pause();
//		Console.putln("Sound : Opened");

		_state = State.Paused;

		if (ret == StreamData.Complete) {
			//Console.putln("Sound : Decoded Last Buffer");
			wavDevice.sendBuffer(buffers[0], true);

			_doneBuffering = true;

			return ret;
		}
		else {
			//Console.putln("Sound : Sending Buffer");
			wavDevice.sendBuffer(buffers[0]);
		}

		bufferIndex = 1;
		/*
		_audioLoader = new Thread();
		_audioLoader.setDelegate(&_bufferCallback);
		_audioLoader.start(); */

		return ret;
	}

	// Description: Will start or resume the playback of the currently loaded audio stream.
	void play() {
		if (_state == State.Stopped || _state == State.Playing) {
			Console.put(" SSSStoopeeedd?!?!");
			stop();

			inStream.rewind();

			load(inStream);
		}

		wavDevice.resume();
		_bufferCallback();
		tmr.start();

		_state = State.Playing;
		raiseSignal(Signal.StateChanged);
	}

	// Description: Will pause the currently playing audio stream.
	void pause() {
		if (_state == State.Playing) {
			_state = State.Paused;
			wavDevice.pause();
			//tmr.stop();
		}
	}

	// Description: Will stop the currently playing audio stream and reset the device.
	void stop() {
		if (_state != State.Stopped) {
			_state = State.Stopped;
			wavDevice.closeDevice();
			raiseSignal(Signal.StateChanged);
		}

		// the audio device will close
		// and therefore reset its clock
		_synch = Time.init;
	//	tmr.stop();
	}

	// Description: Will return the total length of the audio stream.
	// Returns: The total length of the loaded audio.
	Time totalTime() {
		Time tme;
		if (inStream !is null) {
			tme.milliseconds = wavInfo.totalTime;
		}

		return tme;
	}

	// Description: Will return the current position of the audio playback.
	// Returns: The current position of playback.
	Time position() {
		if (inStream !is null) {
			return wavDevice.position + _synch;
		}

		Time retTime;

		return retTime;
	}

	// Description: Will change the position of playback.
	// toPosition: The microseconds from the beginning to set the audio playback.
	void position(ulong toPosition) {
		stop();

		_doneBuffering = false;

		wavDevice.openDevice(buffers[0].audioFormat());
		wavDevice.pause();
		_state = State.Paused;

		Time tme;
		tme.microseconds = cast(long)toPosition;
		_curCodec.seek(inStream, buffers[0].audioFormat(), wavInfo, tme);

		_curCodec.decode(inStream, buffers[0], wavInfo);

		_synch.microseconds = cast(long)toPosition;

		buffers[0].crop(tme);

		wavDevice.sendBuffer(buffers[0]);

		bufferIndex = 1;

		_bufferCallback();
		play();
	}

	// Description: Will get the current state of playback.
	// Returns: The current state of the device.
	State state() {
		return _state;
	}

	double[] spectrum() {
		static uint samples = 0;
		static int lastIndex = -1;
		static Time last;
		if (lastIndex == -1) {
			lastIndex = 0;
			last = Time.Now();
		}
		else if (bufferIndex == lastIndex) {
			lastIndex = !bufferIndex;
			samples = 0;
			last = Time.Now();
		}
		else { // bufferIndex != lastIndex
			Time cur = Time.Now();
			Time diff = cur - last;
			last = cur;
		}

		uint inc = buffers[lastIndex].audioFormat.samplesPerSecond / 20;
		cdouble[] samps = buffers[lastIndex].fourier(2048, samples);
		samples += inc;

		double[] ret = new double[samps.length];

		foreach(size_t i, sample; samps) {
			double re = sample.re * 0.6;
			double im = sample.im * 0.6;
			
			ret[i] = sqrt((re * re) + (im * im));
		}

		return ret;
	}
}
