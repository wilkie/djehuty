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
import graphics.font;
import graphics.path;

import resource.image;

import scaffold.canvas;

import platform.vars.canvas;

import GraphicsScaffold = scaffold.graphics;

import io.console;

class Canvas {
private:
	int _width;
	int _height;

	Brush _brush;
	Pen _pen;
	Font _font;

	CanvasPlatformVars _pfvars;

	bool _forcenopremultiply = false;
	bool _antialias;

public:

	this(int width, int height) {
		_width = width;
		_height = height;

		CanvasCreate(this, &_pfvars);
	}

	~this() {
		CanvasDestroy(this, &_pfvars);
	}

	void resize(int width, int height) {
		_width = width;
		_height = height;

		CanvasDestroy(this, &_pfvars);
		CanvasCreate(this, &_pfvars);
	}

	void clear() {
		CanvasDestroy(this, &_pfvars);
		CanvasCreate(this, &_pfvars);
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

	// Rounded Rectangles

	void drawRoundedRectangle(double x, double y, double width, double height, double cornerWidth, double cornerHeight, double sweep) {
		Path tempPath = new Path();
		tempPath.addRoundedRectangle(x, y, width, height, cornerWidth, cornerHeight, sweep);

		drawPath(tempPath);
	}

	void strokeRoundedRectangle(double x, double y, double width, double height, double cornerWidth, double cornerHeight, double sweep) {
		Path tempPath = new Path();
		tempPath.addRoundedRectangle(x, y, width, height, cornerWidth, cornerHeight, sweep);

		strokePath(tempPath);
	}

	void fillRoundedRectangle(double x, double y, double width, double height, double cornerWidth, double cornerHeight, double sweep) {
		Path tempPath = new Path();
		tempPath.addRoundedRectangle(x, y, width, height, cornerWidth, cornerHeight, sweep);

		fillPath(tempPath);
	}

	// Paths

	void drawPath(Path path) {
		GraphicsScaffold.drawPath(&_pfvars, path.platformVariables);
	}

	void strokePath(Path path) {
		GraphicsScaffold.strokePath(&_pfvars, path.platformVariables);
	}

	void fillPath(Path path) {
		GraphicsScaffold.fillPath(&_pfvars, path.platformVariables);
	}

	// Ellipses

	void drawEllipse(double x, double y, double width, double height) {
		GraphicsScaffold.drawOval(&_pfvars, x, y, width, height);
	}

	void strokeEllipse(double x, double y, double width, double height) {
		GraphicsScaffold.strokeOval(&_pfvars, x, y, width, height);
	}

	void fillEllipse(double x, double y, double width, double height) {
		GraphicsScaffold.fillOval(&_pfvars, x, y, width, height);
	}

	// Text
	void drawString(string text, double x, double y) {
		GraphicsScaffold.drawText(&_pfvars, x, y, text);
	}

	void strokeString(string text, double x, double y) {
		GraphicsScaffold.strokeText(&_pfvars, x, y, text);
	}

	void fillString(string text, double x, double y) {
		GraphicsScaffold.fillText(&_pfvars, x, y, text);
	}

	// Image

	void drawCanvas(Canvas canvas, double x, double y) {
		GraphicsScaffold.drawCanvas(&_pfvars, this, x, y, canvas.platformVariables, canvas);
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

	void clipPath(Path path) {
		GraphicsScaffold.clipPath(&_pfvars, path.platformVariables);
	}

	void clipRestore() {
		GraphicsScaffold.clipRestore(&_pfvars);
	}

	void clipReset() {
		GraphicsScaffold.clipClear(&_pfvars);
	}

	// Transforms

	void transformReset() {
		GraphicsScaffold.resetWorld(&_pfvars);
	}

	void transformTranslate(double x, double y) {
		GraphicsScaffold.translateWorld(&_pfvars, x, y);
	}

	void transformScale(double x, double y) {
		GraphicsScaffold.scaleWorld(&_pfvars, x, y);
	}

	void transformRotate(double angle) {
		GraphicsScaffold.rotateWorld(&_pfvars, angle);
	}

	void transformSave() {
		GraphicsScaffold.saveWorld(&_pfvars);
	}

	void transformRestore() {
		GraphicsScaffold.restoreWorld(&_pfvars);
	}

	// Properties

	void antialias(bool value) {
		_antialias = value;
		GraphicsScaffold.setAntialias(&_pfvars, value);
	}

	bool antialias() {
		return _antialias;
	}

	void brush(Brush value) {
		_brush = value;
		GraphicsScaffold.setBrush(&_pfvars, value.platformVariables);
	}

	Brush brush() {
		return _brush;
	}

	void pen(Pen value) {
		_pen = value;
		GraphicsScaffold.setPen(&_pfvars, value.platformVariables);
	}

	Pen pen() {
		return _pen;
	}

	void font(Font value) {
		_font = value;
		GraphicsScaffold.setFont(&_pfvars, value.platformVariables);
	}

	Font font() {
		return _font;
	}

	// Platform Bullshits

	CanvasPlatformVars* platformVariables() {
		return &_pfvars;
	}

	uint rgbaTouint(uint r, uint g, uint b, uint a) {
		return CanvasRGBAToInt32(_forcenopremultiply,&_pfvars,r,g,b,a);
	}

	uint rgbTouint(uint r, uint g, uint b) {
		return CanvasRGBAToInt32(&_pfvars,r,g,b);
	}
}