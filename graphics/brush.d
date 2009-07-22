module graphics.brush;

import platform.imports;
mixin(PlatformGenericImport!("vars"));
mixin(PlatformGenericImport!("definitions"));

import Scaffold = scaffold.graphics;

import core.color;

import graphics.view;

class Brush {

public:

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
		Scaffold.destroyBrush(&_pfvars);
		Scaffold.createBrush(&_pfvars, clr);

		// when tied to a locked view, update the brush being used
		if (_view !is null) {
			if (_view._locked)
			{
				_view._graphics.setBrush(_view._brush);
			}
		}
	}

private:

	package BrushPlatformVars _pfvars;

	// tied to a view?
	package View _view; // will be null if no view is tied with it

}