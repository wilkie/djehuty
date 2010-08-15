/*
 * canvas.d
 *
 * This module implements a 2d drawing canvas.
 *
 */

module graphics.canvas;

import djehuty;

import graphics.brush;
import graphics.pen;

import scaffold.canvas;

import platform.vars.canvas;

import GraphicsScaffold = scaffold.graphics;

class Canvas {
private:
	int _width;
	int _height;

	Brush _brush;
	Pen _pen;

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

	// Rectangles

	void drawRectangle(double x, double y, double width, double height) {
		GraphicsScaffold.drawRect(&_pfvars, x, y, width, height);
	}

	void strokeRectangle(double x, double y, double width, double height) {
		GraphicsScaffold.strokeRect(&_pfvars, x, y, width, height);
	}

	void fillRectangle(double x, double y, double width, double height) {
		GraphicsScaffold.fillRect(&_pfvars, x, y, width, height);
	}

	// Clipping

	void clipRectangle(Rect rect) {
		clipRectangle(rect.left, rect.top, rect.right - rect.left, rect.bottom - rect.top);
	}

	void clipRectangle(double x, double y, double width, double height) {
		GraphicsScaffold.clipRect(&_pfvars, x, y, width, height);
	}

	void clipSave() {
		GraphicsScaffold.clipSave(&_pfvars);
	}

	void clipRestore() {
		GraphicsScaffold.clipRestore(&_pfvars);
	}

	void clipClear() {
		GraphicsScaffold.clipClear(&_pfvars);
	}

	// Properties

	void brush(Brush value) {
		_brush = value;
		GraphicsScaffold.setBrush(&_pfvars, value.platformVariables);
	}

	Brush brush() {
		return _brush;
	}

	void pen(Pen value) {
		_pen = pen;
		GraphicsScaffold.setPen(&_pfvars, value.platformVariables);
	}

	Pen pen() {
		return _pen;
	}

	// Platform Bullshits

	CanvasPlatformVars* platformVariables() {
		return &_pfvars;
	}
}