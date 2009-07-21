module graphics.view;

import graphics.graphics;

import synch.semaphore;

import gui.window;

import graphics.brush;
import graphics.pen;
import graphics.font;
import graphics.region;

import platform.imports;
mixin(PlatformGenericImport!("vars"));
mixin(PlatformScaffoldImport!());

// Section: Core

// Description: This class implements and abstracts a view, which is a drawing canvas.  With this class, one can create off-screen buffers.
class View {
public:
	// Description: This will instantiate an uninitialized view.  It will need to be created with the create() function in order to fully use.
	this() {
		_mutex = new Semaphore;
		_buffer_mutex = new Semaphore;

		_inited = false;
		_mutex.init(1);
		_buffer_mutex.init(1);

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
			Scaffold.ViewResize(this, _pfvars);
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
	int getWidth() {
		return _width;
	}

	// Description: Will return the height of the drawing canvas.
	// Returns: The height of the canvas.
	int getHeight() {
		return _height;
	}

	// Thread Interaction

	// Description: Will lock the canvas for drawing.
	// Returns: A Graphics object that will draw to the current view.
	Graphics lockDisplay() {
		_mutex.down();

		_locked = true;
		return _graphics;
	}

	// Description: Will unlock a locked canvas.
	void unlockDisplay() {
		_locked = false;

		if (_brush !is null)
		{
			// Unattach the Brush
			_brush._view = null;
		}
		_brush = null;

		if (_pen !is null)
		{
			// Unattach the Pen
			_pen._view = null;
		}
		_pen = null;
		_mutex.up();
	}

	// Description: Will allow an alpha channel to display on a canvas.
	// isAlpha: Whether or not the canvas should be considered to have an alpha channel.
	void setAlphaFlag(bool isAlpha) {
		_hasAlpha = isAlpha;
	}

	// Description: Will return the status of the view and whether it has a working alpha channel.
	// Returns: The flag that is marked in order to use an alpha channel.
	bool getAlphaFlag() {
		return _hasAlpha;
	}

	void* getBufferUnsafe() {
		return Scaffold.ViewGetBytes(_pfvars);
	}

	void lockBuffer(void** bufferPtr, ref ulong length) {
		_buffer_mutex.down();
		bufferPtr[0] = Scaffold.ViewGetBytes(_pfvars, length);
	}

	void unlockBuffer() {
		_buffer_mutex.up();
	}

	uint rgbaTouint(uint r, uint g, uint b, uint a) {
		return Scaffold.ViewRGBAToInt32(_forcenopremultiply,_pfvars,r,g,b,a);
	}

	uint rgbTouint(uint r, uint g, uint b) {
		return Scaffold.ViewRGBAToInt32(_pfvars,r,g,b);
	}

	/*

	// DIB Specific
	void DIBClear(UInt32 clr);
	void DIBClear(UInt8 r, UInt8 g, UInt8 b, UInt8 a);
	void DIBBlit(Int32 x, Int32 y, View &view);

	*/

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
	Semaphore _buffer_mutex;

	void _destroy() {
		Scaffold.ViewDestroy(this, _pfvars);

		_inited = false;

		_width = 0;
		_height = 0;
	}

	void _platformCreate() {
		Scaffold.ViewCreate(this, _pfvars);
	}

	// Retained Objects

	// (null : no object)

	package Brush _brush;
	package Pen _pen;
}