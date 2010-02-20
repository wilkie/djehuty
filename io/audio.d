/*
 * audio.d
 *
 * This file implements the Audio class. This class faciliates low-level access
 * to the audio device. The Sound class, however, is a higher-level accessor.
 *
 * Author: Dave Wilkinson
 *
 */

module io.audio;

import core.stream;
import core.time;
import core.event;

import synch.semaphore;

import platform.vars.wave;

import scaffold.wave;

import io.console;

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

	long totalTime;

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
	}

	~this() {
		closeDevice();
	}

	// Description: Opens an audio device with the format given.  The format describes the representation of the audio stream.
	// format: The format of the audio stream that will indicate the representation of any audio buffers passed to the device.
	void openDevice(AudioFormat format) {
		if (_opened) {
			// reopen
			synchronized(this) {
				if (_format == format) {
					_format = format;
					WaveOpenDevice(this, _pfvars, format);
				}
			}
			return;
		}

		synchronized(this) {
			_opened = true;
			_format = format;
			WaveOpenDevice(this, _pfvars, format);
		}
	}

	// Description: Closes an already opened device, stops playback, and frees any pending buffers.
	void closeDevice() {
		synchronized(this) {
			if (_opened) {
				WaveCloseDevice(this, _pfvars);
				_opened = false;
			}
		}
	}

	// --- //

	// Description: Sends an audio buffer to the device.  These can be queued, and any number may be sent.
	void sendBuffer(Stream waveBuffer, bool isLast = false) {
		synchronized(this) {
			if (_opened) {
				WaveSendBuffer(this, _pfvars, waveBuffer, isLast);
			}
		}
	}

	// Description: Resumes a paused device.
	void resume() {
		synchronized(this) {
			if (_opened) {
				WaveResume(this, _pfvars);
			}
		}
	}

	// Description: Pauses playback of a device.
	void pause() {
		synchronized(this) {
			if (_opened) {
				WavePause(this, _pfvars);
			}
		}
	}

	Time position() {
		synchronized(this) {
			if (!WaveIsOpen(this, _pfvars)) {
				Time myTime = Time.init;
				return myTime;
			}
		}
		return WaveGetPosition(this, _pfvars);
	}

protected:

	WavePlatformVars _pfvars;
	AudioFormat _format;

	bool _opened;
}

void WaveFireCallback(ref Audio w) {
	if (w.responder !is null) {
		w.raiseSignal(Audio.Signal.BufferPlayed);
	}
}