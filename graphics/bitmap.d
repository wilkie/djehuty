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

class Bitmap : View {
	this() {
		super();
	}

	void create(int width, int height) {
		if (_inited) { destroy(); }

		_mutex.down();

		_width = width;
		_height = height;

		Scaffold.ViewCreateDIB(this, _pfvars);

		_inited = true;

		_mutex.up();
	}
}