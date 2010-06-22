/*
 * color.d
 *
 * This file has an implementation of a platform neutral Color datatype.
 *
 * Author: Dave Wilkinson
 *
 */

module core.color;

import platform.definitions;

import core.definitions;

import core.util;

// Section: Types

// Description: This abstracts a color type.  Internally, the structure is different for each platform depending on the native component ordering and the bits per pixel for the platform.
struct Color {
private:

	double _red;
	double _green;
	double _blue;
	double _alpha;

	// cache HSL values
	bool _hslValid;
	double _hue;
	double _sat;
	double _lum;

	void _calculateFromHSL() {
		if (_sat == 0) {
			this.red = _lum;
			this.blue = _lum;
			this.green = _lum;
			return;
		}

		double p;
		double q;
		if (_lum < 0.5) {
			q = _lum * (1.0 + _sat);
		}
		else {
			q = _lum + _sat - (_lum * _sat);
		}

		p = (2.0 * _lum) - q;

		double[3] ctmp;

		ctmp[0] = _hue + (1.0/3.0);
		ctmp[1] = _hue;
		ctmp[2] = _hue - (1.0/3.0);

		for(size_t i = 0; i < 3; i++) {
			if (ctmp[i] < 0) {
				ctmp[i] += 1.0;
			}
			else if (ctmp[i] > 1) {
				ctmp[i] -= 1.0;
			}

			if (ctmp[i] < (1.0 / 6.0)) {
				ctmp[i] = p + ((q - p) * 6.0 * ctmp[i]);
			}
			else if (ctmp[i] < 0.5) {
				ctmp[i] = q;
			}
			else if (ctmp[i] < (2.0 / 3.0)) {
				ctmp[i] = p + (q - p) * ((2.0 / 3.0) - ctmp[i]) * 6.0;
			}
			else {
				ctmp[i] = p;
			}
		}

		this.red = ctmp[0];
		this.green = ctmp[1];
		this.blue = ctmp[2];
	}

	void _calculateHSL() {
		// find min and max values

		double min, max;
		double r,g,b;
		r = this.red;
		g = this.green;
		b = this.blue;

		uint maxColor;

		if (r<=g && r<=b) {
			min = r;
			if (g<b) {
				max = b;
				maxColor = 2;
			}
			else {
				max = g;
				maxColor = 1;
			}
		}
		else if (g<=b && g<=r) {
			min = g;
			if (r<b) {
				max = b;
				maxColor = 2;
			}
			else {
				max = r;
				maxColor = 0;
			}
		}
		else {
			min = b;
			if (r<g) {
				max = g;
				maxColor = 1;
			}
			else {
				max = r;
				maxColor = 0;
			}
		}

		// find luminance
		_lum = (max + min) * 0.5;

		if (max == min) {
			_sat = 0;
			_hue = 0;
			_hslValid = true;
			return;
		}

		// find the saturation
		if (_lum < 0.5) {
			_sat = (max - min) / (max + min);
		}
		else {
			_sat = (max - min) / (2.0 - max - min);
		}

		// find hue
		if (maxColor == 0) {
			_hue = (g - b) / (max - min);
		}
		else if (maxColor == 1){
			_hue = 2.0 + (b - r) / (max - min);
		}
		else {
			_hue = 4.0 + (r - g) / (max - min);
		}
		_hue /= 6.0;
		_hslValid = true;
	}

	
public:

	// -- Predefined values

	// Description: Black!
	static const Color Black 		= { _red: 0.0, _green: 0.0, _blue: 0.0, _alpha: 1.0 };

	static const Color Green		= { _red: 0.0, _green: 1.0, _blue: 0.0, _alpha: 1.0 };
	static const Color Red			= { _red: 1.0, _green: 0.0, _blue: 0.0, _alpha: 1.0 };
	static const Color Blue 		= { _red: 0.0, _green: 0.0, _blue: 1.0, _alpha: 1.0 };

	static const Color Magenta 		= { _red: 1.0, _green: 0.0, _blue: 1.0, _alpha: 1.0 };
	static const Color Yellow 		= { _red: 1.0, _green: 1.0, _blue: 0.0, _alpha: 1.0 };
	static const Color Cyan 		= { _red: 0.0, _green: 1.0, _blue: 1.0, _alpha: 1.0 };

	static const Color DarkGreen	= { _red: 0.0, _green: 0.5, _blue: 0.0, _alpha: 1.0 };
	static const Color DarkRed		= { _red: 0.5, _green: 0.0, _blue: 0.0, _alpha: 1.0 };
	static const Color DarkBlue 	= { _red: 0.0, _green: 0.0, _blue: 0.5, _alpha: 1.0 };

	static const Color DarkMagenta 	= { _red: 0.5, _green: 0.0, _blue: 0.5, _alpha: 1.0 };
	static const Color DarkYellow 	= { _red: 0.5, _green: 0.5, _blue: 0.0, _alpha: 1.0 };
	static const Color DarkCyan 	= { _red: 0.0, _green: 0.5, _blue: 0.5, _alpha: 1.0 };

	static const Color DarkGray		= { _red: 0.5, _green: 0.5, _blue: 0.5, _alpha: 1.0 };
	static const Color Gray 		= { _red: 0.8, _green: 0.8, _blue: 0.8, _alpha: 1.0 };

	static const Color White 		= { _red: 1.0, _green: 1.0, _blue: 1.0, _alpha: 1.0 };

	// Description: This function will set the color given the red, green, blue, and alpha components.
	static Color fromRGBA(double r, double g, double b, double a) {
		Color ret;
		ret.red = r;
		ret.green = g;
		ret.blue = b;
		ret.alpha = a;
		return ret;
	}

	// Description: This function will set the color given the red, green, and blue components.
	static Color fromRGB(double r, double g, double b) {
		Color ret;
		ret.red = r;
		ret.green = g;
		ret.blue = b;
		ret.alpha = 1.0;
		return ret;
	}

	// Description: This function will set the color given the hue, saturation, luminance, and alpha components.
	static Color fromHSLA(double h, double s, double l, double a) {
		Color ret;
		ret.hue = h;
		ret.sat = s;
		ret.lum = l;
		ret.alpha = a;
		return ret;
	}

	// Description: This function will set the color given the hue, saturation, and luminance components.
	static Color fromHSL(ubyte h, ubyte s, ubyte l) {
		Color ret;
		ret.hue = h;
		ret.sat = s;
		ret.lum = l;
		ret.alpha = 1.0;
		return ret;
	}

	double blue() {
		return _blue;
	}

	void blue(double val) {
		_blue = val;
	}

	void blue(ubyte val) {
		_blue = cast(double)val/cast(double)ubyte.max;
	}

	double green() {
		return _green;
	}

	void green(ubyte val) {
		_green = cast(double)val / cast(double)ubyte.max;
	}

	void green(double val) {
		_green = val;
	}

	double red() {
		return _red;
	}

	void red(ubyte val) {
		_red = cast(double)val/cast(double)ubyte.max;
	}

	void red(double val) {
		_red = val;
	}

	double alpha() {
		return _alpha;
	}

	void alpha(double val) {
		_alpha = val;
	}

	void alpha(ubyte val) {
		_alpha = cast(double)val / cast(double)ubyte.max;
	}

	void hue(double val) {
		if (!_hslValid) {
			_calculateHSL();
		}
		_hue = val;
		_calculateFromHSL();
	}

	double hue() {
		if (_hslValid) {
			return _hue;
		}
		
		_calculateHSL();
		return _hue;
	}

	void sat(double val) {
		if (!_hslValid) {
			_calculateHSL();
		}
		_sat = val;
		_calculateFromHSL();
	}

	double sat() {
		if (_hslValid) {
			return _sat;
		}

		_calculateHSL();
		return _sat;
	}

	void lum(double val) {
		if (!_hslValid) {
			_calculateHSL();
		}
		_lum = val;
		_calculateFromHSL();
	}

	double lum() {
		if (_hslValid) {
			return _lum;
		}

		_calculateHSL();
		return _lum;
	}
}
