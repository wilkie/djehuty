/*
 * canvas.d
 *
 * This module implements a 2d drawing canvas.
 *
 */

module graphics.canvas;

import graphics.brush;
import graphics.pen;

import scaffold.canvas;

import platform.vars.canvas;

import GraphicsScaffold = scaffold.graphics;

class Canvas {
private:
	int _width;
	int _height;

	CanvasPlatformVars _pfvars;

public:

	this(int width, int height) {
		_width = width;
		_height = height;

		CanvasCreate(this, &_pfvars);
	}

	~this() {
		CanvasDestroy(this, &_pfvars);
	}

	int width() {
		return _width;
	}

	int height() {
		return _height;
	}

	void drawRectangle(double x, double y, double width, double height) {
		GraphicsScaffold.drawRect(&_pfvars, x, y, width, height);
	}

	void strokeRectangle(double x, double y, double width, double height) {
		GraphicsScaffold.strokeRect(&_pfvars, x, y, width, height);
	}

	void fillRectangle(double x, double y, double width, double height) {
		GraphicsScaffold.fillRect(&_pfvars, x, y, width, height);
	}

	void brush(Brush value) {
		GraphicsScaffold.setBrush(&_pfvars, value.platformVariables);
	}

	void pen(Pen value) {
		GraphicsScaffold.setPen(&_pfvars, value.platformVariables);
	}

	CanvasPlatformVars* platformVariables() {
		return &_pfvars;
	}
}