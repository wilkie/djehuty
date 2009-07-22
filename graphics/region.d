/*
 * region.d
 *
 * This module implements a region primitive.
 *
 * Author: Dave Wilkinson
 *
 */

module graphics.region;

import core.definitions;

import platform.imports;
mixin(PlatformGenericImport!("vars"));
mixin(PlatformGenericImport!("definitions"));

import scaffold.graphics;

class Region {

	this() {
	}

	this(Region rgn) {
		this.points = rgn.points.dup;
	}

	this(Coord[] points) {
		this.points = points.dup;
	}

	// Description: This function will test to see whether or not a point exists within this region.
	// x: The x coordinate of the point to test.
	// y: The y coordinate of the point to test.
	// Returns: Will return true when the point given is inside the region.
	bool containsPoint(int x, int y) {
		return false;
	}

	// Description: This function will test to see whether or not a point exists within this region.
	// pt: The point to test.
	// Returns: Will return true when the point given is inside the region.
	bool containsPoint(Coord pt) {
		return false;
	}

	// Description: This function will return a copy of the array of points in the region.
	// Returns: A duplicate of the array of points.
	Coord[] getPoints() {
		if (points is null) { return null; }
		return points.dup;
	}

	uint numPoints() {
		if (points is null) { return 0; }
		return points.length;
	}

	int opApply(int delegate(inout Coord) loopFunc) {
		int ret;

		for(int i = 0; i < points.length; i++) {
			ret = loopFunc(points[i]);
			if (ret) { break; }
		}

		return ret;
	}

	int opApply(int delegate(inout int, inout Coord) loopFunc) {
		int ret;

		for(int i = 0; i < points.length; i++) {
			ret = loopFunc(i, points[i]);
			if (ret) { break; }
		}

		return ret;
	}

	Coord[] opSlice() {
		return points;
	}

protected:

	// Whether or not the platform's realization of the state of this region
	// is valid
	package bool platformDirty = true;

	// Platform specific denotation of the region
	package RegionPlatformVars _pfvars;

	// The collection of points
	Coord[] points;
}