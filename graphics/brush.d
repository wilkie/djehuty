module graphics.brush;

import platform.vars.brush;

import Scaffold = scaffold.graphics;

import core.color;

import resource.image;

import graphics.gradient;
import graphics.bitmap;

class Brush {
public:
	enum Type {
		Color,
		Brush,
		Gradient
	}

private:
	BrushPlatformVars _pfvars;
	Color _color;
	Type _type;

public:

	this() {
		this(Color.White);
	}

	// Constructor
	this(Color clr) {
		_color = clr;
		Scaffold.createBrush(&_pfvars, clr);
	}

	this(Image image) {
//		this(image.view);
	}

	this(Gradient gradient) {
		Scaffold.createGradientBrush(&_pfvars, gradient.originX, gradient.originY, gradient.points, gradient.colors, gradient.angle, gradient.width);
	}

	// Destructor
	~this() {
		Scaffold.destroyBrush(&_pfvars);
	}

	// Properties

	Color color() {
		return _color;
	}

	Type type() {
		return _type;
	}

	// Convenience

	static Brush White() {
		return new Brush(Color.White);
	}

	static Brush Black() {
		return new Brush(Color.Black);
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

	BrushPlatformVars* platformVariables() {
		return &_pfvars;
	}
}
