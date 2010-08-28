/*
 * bitmap.d
 *
 * This module implements a bitmap view, or more specifically, a
 * device-independent-bitmap.
 *
 */

module graphics.bitmap;

import graphics.canvas;
import graphics.graphics;

import synch.semaphore;

import scaffold.canvas;

class Bitmap : Canvas {
private:
	bool _inited;
	Semaphore _buffer_mutex;

	bool _hasAlpha;

public:

	this(int width, int height) {
		_buffer_mutex = new Semaphore(1);
		super(width, height);
	}

	void* getBufferUnsafe() {
		return CanvasGetBytes(this.platformVariables);
	}

	void lockBuffer(void** bufferPtr, ref ulong length) {
		_buffer_mutex.down();
		bufferPtr[0] = CanvasGetBytes(this.platformVariables, length);
	}

	void unlockBuffer() {
		CanvasUnlockBytes(this.platformVariables);
		_buffer_mutex.up();
	}
}