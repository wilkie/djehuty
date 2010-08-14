module graphics.pen;

import platform.vars.pen;

import Scaffold = scaffold.graphics;

import core.color;

import graphics.view;
import graphics.brush;

class Pen {
private:

	double _width;

	package PenPlatformVars _pfvars;

	// tied to a view?
	package View _view; // will be null if no view is tied with it


public:

	// Constructor
	this(Color clr, double width = 1.0) {
		_width = width;
		Scaffold.createPen(&_pfvars, clr, width);
	}

	this(Brush brush, double width = 1.0) {
		_width = width;
		Scaffold.createPenWithBrush(&_pfvars, brush._pfvars, width);
	}

	// Destructor
	~this() {
		Scaffold.destroyPen(&_pfvars);
	}

	// Sets color of a solid brush
	void setColor(Color clr) {
		Scaffold.destroyPen(&_pfvars);
		Scaffold.createPen(&_pfvars, clr, _width);

		// when tied to a locked view, update the brush being used
		if (_view !is null) {
			if (_view._locked) {
				_view._graphics.pen = _view._pen;
			}
		}
	}
}
