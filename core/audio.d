/*
 * audio.d
 *
 * This file implements the Audio class. This class faciliates low-level access
 * to the audio device. The Sound class, however, is a higher-level accessor.
 *
 * Author: Dave Wilkinson
 *
 */

module core.audio;

import core.stream;
import core.time;
import core.event;

import synch.semaphore;

import platform.imports;
mixin(PlatformGenericImport!("definitions"));
mixin(PlatformGenericImport!("vars"));
mixin(PlatformScaffoldImport!());

// Section: Types

// Description: This structure contains information about an audio file and its uncompressed format.  The Audio class uses this to know how to send buffers given by the audio codec to the audio device.
struct AudioFormat {
	uint compressionType;

	// Description: The number of channels.
	uint numChannels;

	// Description: The number of samples per second.
	uint samplesPerSecond;

	// Description: The average number of bytes per second.
	uint averageBytesPerSecond;

	// Description: The block alignment.
	uint blockAlign;

	// Description: The number of bits per sample.
	uint bitsPerSample;
}

struct AudioInfo {
	// File Information

	ulong totalTime;

	// ID3 Information?

	// --- //
}

// Section: Core

// Description: This class provides a low-level interface to an audio device.
class Audio : Dispatcher {

	enum Signal {
		BufferPlayed,
	}

	this() {
		_mutex = new Semaphore(1);
	}

	~this() {
		closeDevice();
	}

	// Description: Opens an audio device with the format given.  The format describes the representation of the audio stream.
	// format: The format of the audio stream that will indicate the representation of any audio buffers passed to the device.
	void openDevice(AudioFormat format) {
		if (_opened) { return; }

		_mutex.down();
		scope(exit) _mutex.up();

		_opened = true;
		Scaffold.WaveOpenDevice(this, _pfvars, format);
	}

	// Description: Closes an already opened device, stops playback, and frees any pending buffers.
	void closeDevice() {
		_mutex.down();
		scope(exit) _mutex.up();

		if (_opened)
		{
			Scaffold.WaveCloseDevice(this, _pfvars);
			_opened = false;
		}
	}

	// --- //

	// Description: Sends an audio buffer to the device.  These can be queued, and any number may be sent.
	void sendBuffer(Stream waveBuffer, bool isLast = false) {
		_mutex.down();
		scope(exit) _mutex.up();

		if (_opened) {
			Scaffold.WaveSendBuffer(this, _pfvars, waveBuffer, isLast);
		}
	}

	// Description: Resumes a paused device.
	void resume() {
		_mutex.down();
		scope(exit) _mutex.up();

		if (_opened) {
			Scaffold.WaveResume(this, _pfvars);
		}
	}

	// Description: Pauses playback of a device.
	void pause() {
		_mutex.down();
		scope(exit) _mutex.up();

		if (_opened) {
			Scaffold.WavePause(this, _pfvars);
		}
	}

	Time position() {
		_mutex.down();
		scope(exit) _mutex.up();

		if (!Scaffold.WaveIsOpen(this, _pfvars)) {
			Time myTime = Time.init;
			return myTime;
		}

		return Scaffold.WaveGetPosition(this, _pfvars);
	}

protected:

	WavePlatformVars _pfvars;

	bool _opened;

	Semaphore _mutex;
}

void WaveFireCallback(ref Audio w) {
	 if (w.responder !is null) {
		w.raiseSignal(Audio.Signal.BufferPlayed);
	}
}