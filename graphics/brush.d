module graphics.brush;

import platform.vars.brush;

import Scaffold = scaffold.graphics;

import core.color;

import resource.image;

import graphics.gradient;
import graphics.bitmap;

class Brush {
private:
	BrushPlatformVars _pfvars;
public:

	this() {
		this(Color.White);
	}

	// Constructor
	this(Color clr) {
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

// Convenience

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

	BrushPlatformVars* platformVariables() {
		return &_pfvars;
	}
}
