module graphics.brush;

import platform.vars.brush;

import Scaffold = scaffold.graphics;

import core.color;

import resource.image;

import graphics.gradient;
import graphics.bitmap;
import graphics.view;

class Brush {
	this() {
		this(Color.White);
	}

	// Constructor
	this(Color clr) {
		Scaffold.createBrush(&_pfvars, clr);
	}

	this(Image image) {
		this(image.view);
	}

	this(Bitmap bitmap) {
		if (bitmap is null) {
			Scaffold.createBrush(&_pfvars, Color.Black);
		}
		else {
			Scaffold.createBitmapBrush(&_pfvars, bitmap._pfvars);
		}
	}

	this(Gradient gradient) {
		Scaffold.createGradientBrush(&_pfvars, gradient._origx, gradient._origy, gradient._points, gradient._clrs, gradient._angle, gradient._width);
	}

	// Destructor
	~this() {
		Scaffold.destroyBrush(&_pfvars);
	}

	// Sets color of a solid brush
	void setColor(Color clr) {
	}

	void color(Color clr) {
		Scaffold.destroyBrush(&_pfvars);
		Scaffold.createBrush(&_pfvars, clr);

		// when tied to a locked view, update the brush being used
		if (_view !is null) {
			if (_view._locked)
			{
				_view._graphics.brush = _view._brush;
			}
		}
	}

// Convenient

	static Brush White() {
		return new Brush(Color.White);
	}

	static Brush Red() {
		return new Brush(Color.Red);
	}

	static Brush Green() {
		return new Brush(Color.Green);
	}

	static Brush Blue() {
		return new Brush(Color.Blue);
	}

private:

	package BrushPlatformVars _pfvars;

	// tied to a view?
	package View _view; // will be null if no view is tied with it

}
