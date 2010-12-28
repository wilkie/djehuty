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

import io.console;

import binding.opengl.gl;
import binding.opengl.glu;

class Bitmap : Canvas {
private:
	bool _inited;
	Semaphore _buffer_mutex;

	bool _hasAlpha;
	byte* _buffer;

public:

	this(int width, int height) {
		_buffer_mutex = new Semaphore(1);
		super(width, height);
	}

	void* getBufferUnsafe() {
		setContext();

		_buffer = (new byte[](width * height * 4)).ptr;
		glReadPixels(0, 0, width, height, GL_RGBA, GL_UNSIGNED_BYTE, _buffer);
		return _buffer;
	}

	void lockBuffer(void** bufferPtr, ref ulong length) {
		_buffer_mutex.down();

		setContext();

		_buffer = (new byte[](width * height * 4)).ptr;
		*bufferPtr = _buffer;

		glReadPixels(0, 0, width, height, GL_RGBA, GL_UNSIGNED_BYTE, _buffer);
	}

	void unlockBuffer() {
		setContext();

		glRasterPos2i(0, 0);
		glDrawPixels(width, height, GL_RGBA, GL_UNSIGNED_BYTE, _buffer);

		_buffer_mutex.up();
	}
}
