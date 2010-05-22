module graphics.view;

import graphics.graphics;

import synch.semaphore;

import gui.window;

import graphics.brush;
import graphics.pen;
import graphics.font;
import graphics.region;

import platform.vars.view;

import scaffold.view;

// Section: Core

// Description: This class implements and abstracts a view, which is a drawing canvas.  With this class, one can create off-screen buffers.
class View {
	// Description: This will instantiate an uninitialized view.  It will need to be created with the create() function in order to fully use.
	this() {
		_mutex = new Semaphore(1);

		_inited = false;

		_graphics = new Graphics();

		_graphics._view = this;
		_graphics._viewVars = &_pfvars;
	}

	~this() {
		_destroy();
	}

	// Methods //


	// Description: Creates a new drawing canvas offscreen to the dimensions given.
	// width: The width of the new drawing context.
	// height: The height of the new drawing context.
	void create(int width, int height) {
		if (_inited) { destroy(); }

		_mutex.down();

		_width = width;
		_height = height;

		_platformCreate();

		_inited = true;

		_mutex.up();
	}

	// Description: Resizes a previously created drawing context.  All content of the view WILL be lost.
	// width: The new width of the new drawing context.
	// height: The new height of the new drawing context.
	void resize(int width, int height) {
		_mutex.down();

		_width = width;
		_height = height;

		if (_inited) {
			ViewResize(this, &_pfvars);
		}

		_mutex.up();
	}

	// Description: Destroys and deallocates the drawing canvas created through the create() function.
	void destroy() {
		_mutex.down();

		if (!_inited) {
			_mutex.up();
			return;
		}

		_destroy();

		_mutex.up();
	}

	// Description: Will return the width of the drawing canvas.
	// Returns: The width of the canvas.
	int width() {
		return _width;
	}

	// Description: Will return the height of the drawing canvas.
	// Returns: The height of the canvas.
	int height() {
		return _height;
	}

	// Thread Interaction

	// Description: Will lock the canvas for drawing.
	// Returns: A Graphics object that will draw to the current view.
	Graphics lock() {
		_mutex.down();

		_locked = true;
		return _graphics;
	}

	// Description: Will unlock a locked canvas.
	void unlock() {
		_locked = false;

		if (_brush !is null) {
			// Unattach the Brush
			_brush._view = null;
		}
		_brush = null;

		if (_pen !is null) {
			// Unattach the Pen
			_pen._view = null;
		}
		_pen = null;
		_mutex.up();
	}

	uint rgbaTouint(uint r, uint g, uint b, uint a) {
		return ViewRGBAToInt32(_forcenopremultiply,&_pfvars,r,g,b,a);
	}

	uint rgbTouint(uint r, uint g, uint b) {
		return ViewRGBAToInt32(&_pfvars,r,g,b);
	}

protected:

	package ViewPlatformVars _pfvars;

	bool _inited = false;

	package bool _locked = false;

	int _width = 0;
	int _height = 0;

	bool _hasAlpha = false;

	bool _forcenopremultiply = false;

	package Graphics _graphics = null;

	Semaphore _mutex;

	void _destroy() {
		ViewDestroy(this, &_pfvars);

		_inited = false;

		_width = 0;
		_height = 0;
	}

	void _platformCreate() {
		ViewCreate(this, &_pfvars);
	}

	// Retained Objects

	// (null : no object)

	package Brush _brush;
	package Pen _pen;
}
