module graphics.brush;

import platform.vars.brush;

import Scaffold = scaffold.graphics;

import core.color;

import graphics.view;

class Brush {

	// Constructor
	this(Color clr) {
		Scaffold.createBrush(&_pfvars, clr);
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
