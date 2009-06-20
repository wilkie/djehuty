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

import synch.semaphore;

import platform.imports;
mixin(PlatformGenericImport!("definitions"));
mixin(PlatformGenericImport!("vars"));
mixin(PlatformScaffoldImport!());

// Section: Types

// Description: This structure contains information about an audio file and its uncompressed format.  The Audio class uses this to know how to send buffers given by the audio codec to the audio device.
struct AudioFormat
{
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

struct AudioInfo
{
	// File Information

	ulong totalTime;

	// ID3 Information?

	// --- //
}

// Section: Core

// Description: This class provides a low-level interface to an audio device.
class Audio
{
	this()
	{
		_mutex = new Semaphore(1);
	}

	~this()
	{
		closeDevice();
	}

	// Description: Opens an audio device with the format given.  The format describes the representation of the audio stream.
	// format: The format of the audio stream that will indicate the representation of any audio buffers passed to the device.
	void openDevice(AudioFormat format)
	{
		if (_opened) { return; }

		_mutex.down();

		_opened = true;
		Scaffold.WaveOpenDevice(this, _pfvars, format);

		_mutex.up();
	}

	// Description: Closes an already opened device, stops playback, and frees any pending buffers.
	void closeDevice()
	{
		_mutex.down();
		if (_opened)
		{
			Scaffold.WaveCloseDevice(this, _pfvars);
			_opened = false;
		}
		_mutex.up();
	}

	// --- //

	// Description: Sets the callback routine for the device.  This gets called when the device has played a buffer.  It will be commonly used to indicate that another buffer should be sent.
	void setDelegate(void delegate() callback)
	{
		_callback = callback;
	}

	// --- //

	// Description: Sends an audio buffer to the device.  These can be queued, and any number may be sent.
	void sendBuffer(Stream waveBuffer, bool isLast = false)
	{
		_mutex.down();
		if (_opened)
		{
			Scaffold.WaveSendBuffer(this, _pfvars, waveBuffer, isLast);
		}
		_mutex.up();
	}

	// Description: Resumes a paused device.
	void resume()
	{
		_mutex.down();
		if (_opened)
		{
			Scaffold.WaveResume(this, _pfvars);
		}
		_mutex.up();
	}

	// Description: Pauses playback of a device.
	void pause()
	{
		_mutex.down();
		if (_opened)
		{
			Scaffold.WavePause(this, _pfvars);
		}
		_mutex.up();
	}



	Time getPosition()
	{
		_mutex.down();
		if (!Scaffold.WaveIsOpen(this, _pfvars))
		{
			Time myTime = Time.init;
			_mutex.up();
			return myTime;
		}
		else
		{
			_mutex.up();
			return Scaffold.WaveGetPosition(this, _pfvars);
		}
	}


protected:

	WavePlatformVars _pfvars;
	void delegate() _callback = null;

	bool _opened;

	Semaphore _mutex;
}


void WaveFireCallback(ref Audio w)
{
	 if (w._callback !is null)
	{
		w._callback();
	}
}
