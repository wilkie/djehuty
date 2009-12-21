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
import core.parameters;

import core.util;

// Color



static if (Colorbpp == Parameter_Colorbpp.Color8bpp) {
	alias ubyte ColorComponent;
	alias uint ColorValue;
}
else static if (Colorbpp == Parameter_Colorbpp.Color16bpp) {
	alias ushort ColorComponent;
	alias ulong ColorValue;
}
else {
	alias ubyte ColorComponent;
	alias uint ColorValue;
	pragma(msg, "WARNING: Colorbpp parameter is not set!");
}

static if (ColorType == Parameter_ColorType.ColorRGBA) {
	align(1) struct _comps {
		ColorComponent r;
		ColorComponent g;
		ColorComponent b;
		ColorComponent a;
	}
}
else static if (ColorType == Parameter_ColorType.ColorBGRA) {
	align(1) struct _comps{
		ColorComponent b;
		ColorComponent g;
		ColorComponent r;
		ColorComponent a;
	}
}
else static if (ColorType == Parameter_ColorType.ColorABGR) {
	align(1) struct _comps {
		ColorComponent a;
		ColorComponent b;
		ColorComponent g;
		ColorComponent r;
	}
}
else static if (ColorType == Parameter_ColorType.ColorARGB) {
	align(1) struct _comps {
		ColorComponent a;
		ColorComponent r;
		ColorComponent g;
		ColorComponent b;
	}
}
else {
	align(1) struct _comps {
		ColorComponent r;
		ColorComponent g;
		ColorComponent b;
		ColorComponent a;
	}
	pragma(msg, "WARNING: ColorType parameter is not set!");
}


// a small function to convert an 8bpp value into
// the native bits per pixel (which is either 8bpp or 16bpp)
template _8toNativebpp(double comp) {
	const ColorComponent _8toNativebpp = cast(ColorComponent)(comp * cast(double)((1 << (ColorComponent.sizeof*8)) - 1));
}

// Section: Types

// Description: This abstracts a color type.  Internally, the structure is different for each platform depending on the native component ordering and the bits per pixel for the platform.
union Color {
public:

	// -- Predefined values

	// Description: Black!
	static Color Black 		= { _internal: { components: {r: _8toNativebpp!(0.0), g: _8toNativebpp!(0.0), b: _8toNativebpp!(0.0), a: _8toNativebpp!(1.0) } } };

	static Color Green		= { _internal: { components: {r: _8toNativebpp!(0.0), g: _8toNativebpp!(1.0), b: _8toNativebpp!(0.0), a: _8toNativebpp!(1.0) } } };
	static Color Red		= { _internal: { components: {r: _8toNativebpp!(1.0), g: _8toNativebpp!(0.0), b: _8toNativebpp!(0.0), a: _8toNativebpp!(1.0) } } };
	static Color Blue 		= { _internal: { components: {r: _8toNativebpp!(0.0), g: _8toNativebpp!(0.0), b: _8toNativebpp!(1.0), a: _8toNativebpp!(1.0) } } };

	static Color Magenta 	= { _internal: { components: {r: _8toNativebpp!(1.0), g: _8toNativebpp!(0.0), b: _8toNativebpp!(1.0), a: _8toNativebpp!(1.0) } } };
	static Color Yellow 	= { _internal: { components: {r: _8toNativebpp!(1.0), g: _8toNativebpp!(1.0), b: _8toNativebpp!(0.0), a: _8toNativebpp!(1.0) } } };
	static Color Cyan 		= { _internal: { components: {r: _8toNativebpp!(0.0), g: _8toNativebpp!(1.0), b: _8toNativebpp!(1.0), a: _8toNativebpp!(1.0) } } };

	static Color DarkGray	= { _internal: { components: {r: _8toNativebpp!(0.5), g: _8toNativebpp!(0.5), b: _8toNativebpp!(0.5), a: _8toNativebpp!(1.0) } } };
	static Color Gray 		= { _internal: { components: {r: _8toNativebpp!(0.75), g: _8toNativebpp!(0.75), b: _8toNativebpp!(0.75), a: _8toNativebpp!(1.0) } } };

	static Color White 		= { _internal: { components: {r: _8toNativebpp!(1.0), g: _8toNativebpp!(1.0), b: _8toNativebpp!(1.0), a: _8toNativebpp!(1.0) } } };

	// --

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
		static if (Colorbpp == Parameter_Colorbpp.Color8bpp) {
			return cast(double)_internal.components.b / cast(double)0xFF;
		}
		else {
			return cast(double)_internal.components.b / cast(double)0xFFFF;
		}
	}

	void blue(double val) {
		static if (Colorbpp == Parameter_Colorbpp.Color8bpp) {
			_internal.components.b = cast(ubyte)(0xffp0 * val);
		}
		else {
			_internal.components.b = cast(ubyte)(0xffffp0 * val);
		}
	}

	double green() {
		static if (Colorbpp == Parameter_Colorbpp.Color8bpp) {
			return cast(double)_internal.components.g / cast(double)0xFF;
		}
		else {
			return cast(double)_internal.components.g / cast(double)0xFFFF;
		}
	}

	void green(ubyte val) {
		static if (Colorbpp == Parameter_Colorbpp.Color8bpp) {
			_internal.components.g = val;
		}
		else {
			_internal.components.g = (cast(double)val / cast(double)0xFF) * 0xFFFF;
		}
	}

	void green(double val) {
		static if (Colorbpp == Parameter_Colorbpp.Color8bpp) {
			_internal.components.g = cast(ubyte)(0xffp0 * val);
		}
		else {
			_internal.components.g = cast(ubyte)(0xffffp0 * val);
		}
	}

	double red() {
		static if (Colorbpp == Parameter_Colorbpp.Color8bpp) {
			return cast(double)_internal.components.r / cast(double)0xFF;
		}
		else {
			return cast(double)_internal.components.r / cast(double)0xFFFF;
		}
	}

	void red(ubyte val) {
		static if (Colorbpp == Parameter_Colorbpp.Color8bpp) {
			_internal.components.r = val;
		}
		else {
			_internal.components.r = (cast(double)val / cast(double)0xFF) * 0xFFFF;
		}
	}

	void red(double val) {
		static if (Colorbpp == Parameter_Colorbpp.Color8bpp) {
			_internal.components.r = cast(ubyte)(0xffp0 * val);
		}
		else {
			_internal.components.r = cast(ubyte)(0xffffp0 * val);
		}
	}

	double alpha() {
		static if (Colorbpp == Parameter_Colorbpp.Color8bpp) {
			return cast(double)_internal.components.a / cast(double)0xFF;
		}
		else {
			return cast(double)_internal.components.a / cast(double)0xFFFF;
		}
	}

	void alpha(double val) {
		static if (Colorbpp == Parameter_Colorbpp.Color8bpp) {
			_internal.components.a = cast(ubyte)(0xffp0 * val);
		}
		else {
			_internal.components.a = cast(ubyte)(0xffffp0 * val);
		}
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

	ColorValue value() {
		return _internal.clr;
	}

private:

	union internal {
		_comps components;

		ColorValue clr;
	}

	internal _internal;

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
}





// shady platfrom private accessors and mutators
ColorValue ColorGetValue(Color clr)
{
	// For some reason, that union is not working properly
	return clr._internal.clr;
//	return clr.clr;
}

void ColorSetValue(Color clr, ColorValue val)
{
	clr._internal.clr = val;
}

ColorComponent ColorGetR(ref Color clr)
{
	return clr._internal.components.r;
}

ColorComponent ColorGetG(ref Color clr)
{
	return clr._internal.components.g;
}

ColorComponent ColorGetB(ref Color clr)
{
	return clr._internal.components.b;
}

ColorComponent ColorGetA(ref Color clr)
{
	return clr._internal.components.a;
}
