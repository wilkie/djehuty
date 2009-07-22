/*
 * wave.d
 *
 * This module has the structure that is kept with an Audio class for Windows.
 *
 * Author: Dave Wilkinson
 * Originated: July 22th, 2009
 *
 */

module platform.vars.wave;

import platform.win.common;

import core.stream;

import io.audio;

struct WavePlatformVars {
	// Handle to the device
	HWAVEOUT waveOut;
	WAVEFORMATEX wfx;

	struct BufferNode {
		Stream waveBuffer;
		WAVEHDR waveHeader;

		bool inUse;
		bool isLast;
	}

	BufferNode buffers[3];

	// Semaphore to keep the queue clean
	HANDLE queueLock;
	HANDLE closeLock;
	HANDLE opLock;

	bool isClosed;
	bool inited;

	DWORD threadID;
	HANDLE thread;

	BufferNode* curQueueNode;

	Audio wave;

	HANDLE event;
	HANDLE resumeEvent;
	//_WaveThread waveThread;
}