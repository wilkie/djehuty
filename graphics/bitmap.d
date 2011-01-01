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
import binding.opengl.glext;

import binding.win32.wingdi;
import binding.win32.windef;
import binding.win32.winuser;


class Bitmap : Canvas {
private:
	bool _inited;

	bool _hasAlpha;
	byte* _buffer;

public:

	this(int width, int height) {
		super(width, height);
	}

	void* getBufferUnsafe() {
		lock();

		_buffer = (new byte[](width * height * 4)).ptr;
		glReadPixels(0, 0, width, height, GL_RGBA, GL_UNSIGNED_BYTE, _buffer);

		unlock();

		return _buffer;
	}

	void lockBuffer(void** bufferPtr, ref ulong length) {
		putln("read?");
		lock();

		_buffer = (new byte[](width * height * 4)).ptr;
		*bufferPtr = _buffer;

		length = width * height * 4;

		glReadPixels(0, 0, width, height, GL_BGRA, GL_UNSIGNED_BYTE, _buffer);
		putln("read");

		unlock();
	}

	void unlockBuffer() {
		putln("draw?");
		lock();

		//glRasterPos2i(0, 0);
		//glDrawPixels(width, height, GL_RGBA, GL_UNSIGNED_BYTE, _buffer);
		glTexSubImage2D(GL_TEXTURE_2D, 0, 0, 0, width, height, GL_BGRA, GL_UNSIGNED_BYTE, _buffer);

		putln("drawn");
		unlock();
	}
}
