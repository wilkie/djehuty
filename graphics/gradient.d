/*
 * gradient.d
 *
 * This module implements an object that defines a gradient.
 *
 * Author: Dave Wilkinson
 * Originated: December 19th, 2009
 *
 */

module graphics.gradient;

import core.definitions;
import core.color;

class Gradient {
	this() {
	}

	void add(Coord pt, Color clr) {
		_points ~= pt;
		_clrs ~= clr;
	}

	void add(int x, int y, Color clr) {
		add(Coord(x,y), clr);
	}

	void scale(int sx, int sy) {
	}

	Color[] colors() {
		return _clrs.dup;
	}

	Coord[] points() {
		return _points.dup;
	}

package:

	Coord[] _points;
	Color[] _clrs;
}