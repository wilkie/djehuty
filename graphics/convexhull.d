/*
 * convexhull.d
 *
 * This module implements a convex hull primitive.
 *
 * Author: Dave Wilkinson
 * Originated: June 6th, 2009
 *
 */

module graphics.convexhull;

import graphics.region;

import core.definitions;

import io.console;

// Description: This class represents a region that is convex.
class ConvexHull : Region {

	// Description: This will construct an empty ConvexHull.
	this() {
	}

	// Description: This will construct a ConvexHull for the given Region.
	// region: The class representing the region to use.
	this(Region region) {
		quickHull(region[]);
	}

	this(Coord[] points) {
		quickHull(points);
	}

protected:

	// Description: This function will build the internal array of points using the given array of points
	void quickHull(Coord[] pts) {
		
		// Initialize the hull with the furthest left and right points

		uint min = 0;
		uint max = 0;

		foreach(i, pt; pts) {
			if (pt.x > pts[max].x) { max = i; }
			if (pt.x < pts[min].x) { min = i; }
		}

		// Now, with this hull, keep adding the farthest point
		points = pts[min] ~ quickHullCompute(pts[min], pts[max], pts) 
						  ~ pts[max]
						  ~ quickHullCompute(pts[max], pts[min], pts);
	}

	Coord[] quickHullCompute(Coord start, Coord end, Coord[] pts) {
		// compute useful distance information
		int distX = end.x - start.x;
		int distY = end.y - start.y;

		int maxDistance = 0;
		int maxPoint = -1;

		Coord[] outerPoints;

		// find most distant point
		foreach(i, pt; pts) {
			int distance = distX * (start.y - pt.y) - distY * (start.x - pt.x);

			if (distance <= 0) {
				continue;
			}

			if (distance > maxDistance) {
				if (maxPoint != -1) {
					outerPoints ~= pts[maxPoint];
				}

				maxDistance = distance;
				maxPoint = i;
			}
			else {
				outerPoints ~= pt;
			}
		}
		
		Coord[] ret = null;

		if (maxPoint != -1) {
			// We can continue
			ret = quickHullCompute(start, pts[maxPoint], outerPoints);
			ret ~= pts[maxPoint];
			ret ~= quickHullCompute(pts[maxPoint], end, outerPoints);
		}

		return ret;
	}

	Coord center;
}