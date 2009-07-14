module core.view;

import core.graphics;

import synch.semaphore;

import gui.window;

import console.main;

import graphics.brush;
import graphics.pen;
import graphics.font;
import graphics.region;

import platform.imports;
mixin(PlatformGenericImport!("vars"));
mixin(PlatformScaffoldImport!());

// Section: Core

// Description: This class implements and abstracts a view, which is a drawing canvas.  With this class, one can create off-screen buffers.
class View
{
public:


	// Description: This will instantiate an uninitialized view.  It will need to be created with the create() function in order to fully use.
	this()
	{
		_mutex = new Semaphore;
		_buffer_mutex = new Semaphore;

		_inited = false;
		_mutex.init(1);
		_buffer_mutex.init(1);
	}

	~this()
	{
		_destroy();
	}

	// Methods //


	// Description: Creates a new drawing canvas offscreen to the dimensions given.
	// width: The width of the new drawing context.
	// height: The height of the new drawing context.
	void create(int width, int height)
	{
		if (_inited) { destroy(); }

		_mutex.down();

		_graphics = new Graphics();

		GraphicsSetViewVars(_graphics, this, _pfvars);

		_isDIB = false;

		_width = width;
		_height = height;

		if (_fromWindow)
		{
			Scaffold.ViewCreateForWindow(this, _pfvars, _window);
		}
		else
		{
			Scaffold.ViewCreate(this, _pfvars);
		}

		_fromWindow = false;

		_inited = true;

		_mutex.up();
	}

	void CreateDIB(int width, int height)
	{
		if (_inited) { destroy(); }

		_mutex.down();

		_graphics = new Graphics();

		GraphicsSetViewVars(_graphics, this, _pfvars);

		_isDIB = true;

		_width = width;
		_height = height;

		if (_fromWindow)
		{
			Scaffold.ViewCreateForWindow(this, _pfvars, _window);
		}
		else
		{
			Scaffold.ViewCreateDIB(this, _pfvars);
		}

		_fromWindow = false;

		_inited = true;

		_mutex.up();
	}

	// Description: Resizes a previously created drawing context.  All content of the view WILL be lost.
	// width: The new width of the new drawing context.
	// height: The new height of the new drawing context.
	void resize(int width, int height)
	{
		_mutex.down();

		_width = width;
		_height = height;

		if (_inited)
		{

			Scaffold.ViewResize(this, _pfvars);

		}

		_mutex.up();
	}

	// Description: Destroys and deallocates the drawing canvas created through the create() function.
	void destroy()
	{
		_mutex.down();

		if (!_inited)
		{
			_mutex.up();
			return;
		}

		_destroy();

		_mutex.up();
	}



	// Description: Will return the width of the drawing canvas.
	// Returns: The width of the canvas.
	int getWidth()
	{
		return _width;
	}

	// Description: Will return the height of the drawing canvas.
	// Returns: The height of the canvas.
	int getHeight()
	{
		return _height;
	}





	// Thread Interaction

	// Description: Will lock the canvas for drawing.
	// Returns: A Graphics object that will draw to the current view.
	Graphics lockDisplay()
	{
		_mutex.down();

		_locked = true;
		return _graphics;
	}

	// Description: Will unlock a locked canvas.
	void unlockDisplay()
	{
		_locked = false;

		if (_brush !is null)
		{
			BrushNullView(_brush);
		}
		_brush = null;

		if (_pen !is null)
		{
			PenNullView(_pen);
		}
		_pen = null;
		_mutex.up();
	}

	// Description: Will allow an alpha channel to display on a canvas.
	// isAlpha: Whether or not the canvas should be considered to have an alpha channel.
	void setAlphaFlag(bool isAlpha)
	{
		_hasAlpha = isAlpha;
	}

	// Description: Will return the status of the view and whether it has a working alpha channel.
	// Returns: The flag that is marked in order to use an alpha channel.
	bool getAlphaFlag()
	{
		return _hasAlpha;
	}

	void* getBufferUnsafe()
	{
		return Scaffold.ViewGetBytes(_pfvars);
	}

	void lockBuffer(void** bufferPtr, ref ulong length)
	{
		_buffer_mutex.down();
		bufferPtr[0] = Scaffold.ViewGetBytes(_pfvars, length);
	}

	void unlockBuffer()
	{
		_buffer_mutex.up();
	}

	uint rgbaTouint(uint r, uint g, uint b, uint a)
	{
		return Scaffold.ViewRGBAToInt32(_forcenopremultiply,_pfvars,r,g,b,a);
	}

	uint rgbTouint(uint r, uint g, uint b)
	{
		return Scaffold.ViewRGBAToInt32(_pfvars,r,g,b);
	}

	/*

	// DIB Specific
	void DIBClear(UInt32 clr);
	void DIBClear(UInt8 r, UInt8 g, UInt8 b, UInt8 a);
	void DIBBlit(Int32 x, Int32 y, View &view);

	*/

protected:

	ViewPlatformVars _pfvars;

	bool _fromWindow = false;
	Window _window;

	bool _inited = false;

	bool _locked = false;

	int _width = 0;
	int _height = 0;

	bool _hasAlpha = false;

	bool _isDIB = false;
	bool _forcenopremultiply = false;

	Graphics _graphics = null;

	Semaphore _mutex;
	Semaphore _buffer_mutex;

	void _destroy()
	{
		Scaffold.ViewDestroy(this, _pfvars);

		_inited = false;

		_isDIB = false;

		_width = 0;
		_height = 0;
	}

	// Retained Objects

	// (null : no object)

	Brush _brush;
	Pen _pen;
}

ViewPlatformVars* ViewGetPlatformVars(ref View view)
{
	return &view._pfvars;
}

void ViewCreateForWindow(ref View view, ref Window window)
{
	view._fromWindow = true;

	view.create(window.width, window.height);

	view._fromWindow = true;
}

void ViewResizeForWindow(ref View view, ref Window window)
{
	if (view !is null && view._fromWindow)
	{
		view.resize(window.width, window.height);
	}
}

bool ViewIsDIB(ref View view)
{
    return view._isDIB;
}

bool ViewIsFromWindow(ref View view)
{
	return view._fromWindow;
}

void ViewSetBrush(ref View view, ref Brush brsh)
{
	if (view._brush !is null)
	{
		BrushNullView(view._brush);
	}
	view._brush = brsh;
	BrushSetView(brsh, view);
}

void ViewUpdateBrush(ref View view)
{
	if (view._locked)
	{
		view._graphics.setBrush(view._brush);
	}
}

void ViewSetPen(ref View view, ref Pen pen)
{
	if (view._pen !is null)
	{
		PenNullView(view._pen);
	}
	view._pen = pen;
	PenSetView(pen, view);
}

void ViewUpdatePen(ref View view)
{
	if (view._locked)
	{
		view._graphics.setPen(view._pen);
	}
}

//void ViewSetPen(ref View view, ref Pen pen)
//{
//}
