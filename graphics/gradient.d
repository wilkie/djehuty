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
import core.variant;

import io.console;

// Description: This class represents a linear gradient.
class Gradient {

	// Description: This will create a default linear gradient.
	this() {
		_angle = 3.14159265;
		_width = 50;
		_origx = 0;
		_origy = 0;
	}

	// Description: This will create a linear gradient with a particular width.
	// width: The length of the gradient.
	this(double width) {
		_angle = 3.14159265;
		_width = width;
		_origx = 0;
		_origy = 0;
	}

	// Description: This will create a linear gradient with a particular width at an angle.
	// width: The length of the gradient.
	// angle: The angle at which the gradient is drawn.
	this(double x0, double y0, double width, double angle, ...) {
		_width = width;
		_origx = x0;
		_origy = y0;
		this.angle = angle;

		Variadic vars = new Variadic(_arguments, _argptr);

		float pt;
		foreach(i, item; vars) {
			if (i % 2 == 0) {
				pt = item.to!(double);
			}
			else {
				Color clr = item.to!(Color);
				add(pt, clr);
			}
		}
	}

	// Description: This will add a point to the gradient and attach a color. Colors are
	//   interpolated from 0.0 to 1.0 based upon the values given by this function.
	//   Or it will replace the value if it already exists.
	// point: The placement of the point within the width of the gradient. Possible values
	//   range from 0.0 to 1.0.
	// color: The color that will represent this point. Defaults to black.
	void add(double point, Color color = Color.Black) {
		if (point < 0.0) {
			point = 0.0;
		}

		if (point > 1.0) {
			point = 1.0;
		}

		foreach(size_t i, pt; _points) {
			if (pt == point) {
				_clrs[i] = color;
				return;
			}
		}

		_points ~= point;
		_clrs ~= color;
	}

	void remove(double point) {
		if (point < 0.0) {
			return;
		}

		if (point > 1.0) {
			return;
		}

		foreach(size_t i, pt; _points) {
			if (pt == point) {
				_points = _points[0..i] ~ _points[i+1..$];
				_clrs = _clrs[0..i] ~ _clrs[i+1..$];
				return;
			}
		}
	}

	// Description: This will return the current angle represented by this gradient.
	// Returns: The angle in radians.
	double angle() {
		return _angle;
	}

	// Description: This will set the angle for the gradient.
	// value: The new angle in radians.
	void angle(double value) {
		if (value !<> double.infinity) {
			value = 0.0;
		}
		value %= 2*3.14159265;
		_angle = value;
	}

	// Description: This will return the list of colors.
	// Returns: An array of Color objects the represent this gradient.
	Color[] colors() {
		return _clrs.dup;
	}

	// Description: This will return the list of points.
	// Returns: An array of points where possible values range from 0.0 to 1.0.
	double[] points() {
		return _points.dup;
	}

package:

	double _origx;
	double _origy;

	double _angle;
	double _width;
	double[] _points;
	Color[] _clrs;
}