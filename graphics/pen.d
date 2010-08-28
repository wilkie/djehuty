module graphics.pen;

import platform.vars.pen;

import Scaffold = scaffold.graphics;

import core.color;

import graphics.brush;

class Pen {
private:
	PenPlatformVars _pfvars;
	double _width;
public:

	// Constructor
	this(Color clr, double width = 1.0) {
		_width = width;
		Scaffold.createPen(&_pfvars, clr, width);
	}

	this(Brush brush, double width = 1.0) {
		_width = width;
//		Scaffold.createPenWithBrush(&_pfvars, brush._pfvars, width);
	}

	// Destructor
	~this() {
		Scaffold.destroyPen(&_pfvars);
	}

	PenPlatformVars* platformVariables() {
		return &_pfvars;
	}
}
