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
	PathPlatformVars _pfvars;

public:
	this() {
		GraphicsScaffold.createPath(&_pfvars);
	}

	~this() {
		GraphicsScaffold.destroyPath(&_pfvars);
	}

	// Methods

	void addArc(double left, double top, double width, double height, double direction, double sweep) {
		GraphicsScaffold.pathAddArc(&_pfvars, left, top, width, height, direction, sweep);
	}

	void addArc(Rect bounds, double direction, double sweep) {
		addArc(bounds.left, bounds.top, bounds.right - bounds.left, bounds.bottom - bounds.top, direction, sweep);
	}

	void addRectangle(double left, double top, double width, double height) {
		GraphicsScaffold.pathAddRectangle(&_pfvars, left, top, width, height);
	}

	void addRectangle(Rect rect) {
		addRectangle(rect.left, rect.top, rect.right - rect.left, rect.bottom - rect.top);
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
		GraphicsScaffold.pathAddLine(&_pfvars, x1, y1, x2, y2);
	}

	void close() {
		GraphicsScaffold.pathClose(&_pfvars);
	}

	// Platform bullshits

	PathPlatformVars* platformVariables() {
		return &_pfvars;
	}
}