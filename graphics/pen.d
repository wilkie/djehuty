module graphics.pen;

import platform.vars.pen;

import Scaffold = scaffold.graphics;

import core.color;

import graphics.brush;

class Pen {
public:
	enum Type {
		Color,
		Brush
	}

private:
	PenPlatformVars _pfvars;
	double _width;
	Type _type;
	Color _color;

public:
	// Constructor
	this(Color clr, double width = 1.0) {
		_width = width;
		_type = Pen.Type.Color;
		_color = clr;
		Scaffold.createPen(&_pfvars, clr, width);
	}

	this(Brush brush, double width = 1.0) {
		_width = width;
		_type = Pen.Type.Brush;
//		Scaffold.createPenWithBrush(&_pfvars, brush._pfvars, width);
	}

	// Destructor
	~this() {
		Scaffold.destroyPen(&_pfvars);
	}

	PenPlatformVars* platformVariables() {
		return &_pfvars;
	}

	// Properties

	Type type() {
		return _type;
	}

	Color color() {
		return _color;
	}

	double width() {
		return _width;
	}
}
