module graphics.contour;

import djehuty;

import data.iterable;
import io.console;

class Contour {
private:
	Curve[] _curves;

public:
	this() {
	}

	// Properties

	Curve[] curves() {
		return _curves;
	}

	void curves(Curve[] value) {
		_curves = value;
	}

	// Methods

	void addLine(double x1, double y1, double x2, double y2) {
		Curve c;
		c.start.x = x1;
		c.start.y = y1;
		c.end.x = x2;
		c.end.y = y2;

		addCurve(c);
	}

	void addCurve(Curve c) {
		_curves ~= c;
	}

	void addCurve(double x1, double y1, double x2, double y2, double xc, double yc) {
		Curve c;
		c.start.x = x1;
		c.start.y = y1;
		c.end.x = x2;
		c.end.y = y2;
		c.controls = new Coord[1];
		c.controls[0].x = xc;
		c.controls[0].y = yc;

		addCurve(c);
	}

	Coord[] compose() {
		if (_curves.length == 0) {
			return null;
		}

		Coord[] ret;

		Coord last = _curves[0].start;
		last.x--;
		
		foreach(curve; _curves) {
			// Make sure to ignore redundant points
			if (!(curve.start.x == last.x && curve.start.y == last.y)) {
				ret ~= curve.start;
			}

			if (curve.start.x == curve.end.x && curve.start.y == curve.end.y && curve.controls.length == 0) {
				// This curve represents a point
				continue;
			}

			// Tessellate the curve
			static const int MAX_TESSELATIONS = 10;

			if (curve.controls.length == 1) {
				double t;
				double t_inv;

				double qx_1, qx_2, qy_1, qy_2;
				double bx, by;

				for(int k = 1; k < MAX_TESSELATIONS; k++) {
					t = cast(double)k / cast(double)(MAX_TESSELATIONS-1);
					t_inv = 1 - t;

					qx_1 = ((curve.controls[0].x - curve.start.x) * t) + curve.start.x;
					qy_1 = ((curve.controls[0].y - curve.start.y) * t) + curve.start.y;

					qx_2 = ((curve.controls[0].x - curve.end.x) * t_inv) + curve.end.x;
					qy_2 = ((curve.controls[0].y - curve.end.y) * t_inv) + curve.end.y;

					Coord c;
					c.x = ((qx_2 - qx_1) * t) + qx_1;
					c.y = ((qy_2 - qy_1) * t) + qy_1;

					ret ~= c;
				}
			}
			else {
				ret ~= curve.end;
			}

			last = curve.end;
		}
		return ret;
	}

	private bool _isConvex(Coord[] vertices, size_t idx, bool[] verticesTaken) {
		size_t prev = 0;
		size_t next = 0;

		if (idx == 0) {
			prev = vertices.length - 1;
		}
		else {
			prev = idx - 1;
		}

		while(verticesTaken[prev]) {
			if (prev == 0) {
				prev = vertices.length - 1;
			}
			else {
				prev--;
			}
		}

		if (idx == vertices.length - 1) {
			next = 0;
		}
		else {
			next = idx + 1;
		}

		while(verticesTaken[next]) {
			if (next == vertices.length - 1) {
				next = 0;
			}
			else {
				next++;
			}
		}

		double area = vertices[idx].x * (vertices[next].y - vertices[prev].y);
		area += vertices[prev].x * (vertices[idx].y - vertices[next].y);
		area += vertices[next].x * (vertices[prev].y - vertices[idx].y);

		if (area < 0) {
			return true;
		}

		return false;
	}

	private bool _isEar(Triangle t, size_t[] reflexIndices, Coord[] vertices) {
		// Return false if there is a reflex point in this triangle
		foreach(index; reflexIndices) {
			Coord vertex = vertices[index];
			if (vertex.x != t.points[0].x &&
			  vertex.y != t.points[0].y &&
			  vertex.x != t.points[1].x &&
			  vertex.y != t.points[1].y &&
			  vertex.x != t.points[2].x &&
			  vertex.y != t.points[2].y) {
				// check for contains
				if (t.contains(vertex)) {
					return false;
				}
			}
		}
		return true;
	}

	Triangle[] tessellate() {
		Coord[] vertices = compose();
		bool[] verticesTaken = new bool[vertices.length];
		bool[] isConvex = new bool[vertices.length];

		size_t[] convexIndices;
		size_t[] reflexIndices;

		size_t numVertices = vertices.length;

		Triangle[] ret;

		// Divide the vertices into a convex
		// list and a reflex list.

		// The convex list are points that are on
		// the boundary of the convex hull of the
		// contour.

		// Convex points cannot be within a triangle
		// This reduces the search space.
		foreach(size_t idx, vertex; vertices) {
			if (_isConvex(vertices, idx, verticesTaken)) {
				isConvex[idx] = true;
				convexIndices ~= idx;
			}
			else {
				reflexIndices ~= idx;
			}
		}

		// Ear clipping algorithm (no holes)

		while(convexIndices.length > 0) {
			// If all points are on the convex hull, then
			// the contour is convex!
			if (reflexIndices.length == 0) {
				// Convex contours are a special case
				// They can just be built from triangles that
				// share a single point (triangle fan)
				putln("All convex.");
//				break;
			}

			foreach(size_t idx, index; convexIndices) {
				// For each triangle containing a point on the
				// convex hull...
				Triangle t;

				t.points[0] = vertices[index];

				size_t next = index+1;
				if (index == vertices.length - 1) {
					next = 0;
				}

				size_t prev = index-1;
				if (index == 0) {
					prev = vertices.length - 1;
				}

				while(verticesTaken[prev]) {
					if (prev == 0) {
						prev = vertices.length - 1;
					}
					else {
						prev--;
					}
				}

				while(verticesTaken[next]) {
					if (next == vertices.length - 1) {
						next = 0;
					}
					else {
						next++;
					}
				}

				t.points[1] = vertices[next];
				t.points[2] = vertices[prev];

				// ... Check to see that it is an "ear"
				if (_isEar(t, reflexIndices, vertices)) {
					// If so, add that ear as a triangle
					ret ~= t;

					// Remove the vertex from the polygon
					verticesTaken[index] = true;
					convexIndices = convexIndices[0..idx] ~ convexIndices[idx+1..$];

					// Convert reflex points to convex if possible
					if (!isConvex[prev] && _isConvex(vertices, prev, verticesTaken)) {
						isConvex[prev] = true;
						convexIndices ~= prev;
						reflexIndices = reflexIndices.remove(prev);
					}

					if (!isConvex[next] && _isConvex(vertices, next, verticesTaken)) {
						isConvex[next] = true;
						convexIndices ~= next;
						reflexIndices = reflexIndices.remove(prev);
					}

					break;
				}
			}
		}

		return ret;
	}
}
