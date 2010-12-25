/*
 * path.d
 *
 * This module implements a path object.
 *
 */

module graphics.path;

import djehuty;

import platform.vars.path;

import GraphicsScaffold = scaffold.graphics;

class Path {
private:
	Curve[] _points;

public:
	this() {
	}

	// Properties

	Curve[] curves() {
		return _points;
	}

	void curves(Curve[] value) {
		_points = value;
	}

	// Methods

	void addCurve(double x1, double y1, double x2, double y2, double xc, double yc) {
		Curve curve;
		curve.start.x = x1;
		curve.start.y = y1;
		curve.end.x = x2;
		curve.end.y = y2;
		curve.controls = new Coord[1];
		curve.controls[0].x = xc;
		curve.controls[0].y = yc;

		_points ~= curve;
	}

	void addArc(double left, double top, double width, double height, double direction, double sweep) {
	}

	void addArc(Rect bounds, double direction, double sweep) {
	}

	void addRectangle(double left, double top, double width, double height) {
	}

	void addRectangle(Rect rect) {
	}

	void addRoundedRectangle(double x, double y, double width, double height, double cornerWidth, double cornerHeight, double sweep) {
		// top-left
		addLine(x+0, y+height-cornerHeight-1, x+0, y+cornerHeight-1);
		addArc(x+0, y+0, x+cornerWidth, y+cornerHeight, 180, sweep);

		// top-right
		addLine(x+cornerWidth, y+0, x+width-cornerWidth-1, y+0);
		addArc(x+width-cornerWidth, y+0, x+cornerWidth, y+cornerHeight, 270, sweep);

		// bottom-right
		addLine(x+width-1, y+cornerHeight, x+width-1, y+height-cornerHeight-1);
		addArc(x+width-cornerWidth, y+height-cornerHeight, x+cornerWidth, y+cornerHeight, 0, sweep);

		// bottom-left
		addLine(x+width-cornerWidth-1, y+height-1, x+cornerWidth-1, y+height-1);
		addArc(x+0, y+height-cornerHeight, x+cornerWidth, y+cornerHeight, 90, sweep);

		close();
	}

	void addLine(double x1, double y1, double x2, double y2) {
	}

	void close() {
	}

	// Platform bullshits

	PathPlatformVars* platformVariables() {
		return null;
	}
}
