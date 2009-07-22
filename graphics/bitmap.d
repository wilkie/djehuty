/*
 * bitmap.d
 *
 * This module implements a bitmap view, or more specifically, a
 * device-independent-bitmap.
 *
 * Author: Dave Wilkinson
 * Originated: July 20th 2009
 *
 */

module graphics.bitmap;

import graphics.view;
import graphics.graphics;

import synch.semaphore;

import scaffold.view;

import io.console;

class Bitmap : View {
	this() {
		super();

		_buffer_mutex = new Semaphore;
		_buffer_mutex.init(1);
	}

	void create(int width, int height) {
		if (_inited) { destroy(); }

		_mutex.down();

		_width = width;
		_height = height;
		
		_hasAlpha = false;

		ViewCreateDIB(this, _pfvars);

		_inited = true;

		_mutex.up();
	}

	void* getBufferUnsafe() {
		return ViewGetBytes(_pfvars);
	}

	void lockBuffer(void** bufferPtr, ref ulong length) {
		_buffer_mutex.down();
		bufferPtr[0] = ViewGetBytes(_pfvars, length);
	}

	void unlockBuffer() {
		_buffer_mutex.up();
	}

private:

	Semaphore _buffer_mutex;
}