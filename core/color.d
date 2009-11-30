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
static if (Colorbpp == Parameter_Colorbpp.Color8bpp) {
	static ubyte _8toNativebpp(ubyte comp) {
		return comp;
	}
}
else { //static if (Colorbpp == Parameter_Colorbpp.Color16bpp)
	static ushort _8toNativebpp(ubyte comp) {
		return cast(ushort)(comp * (0x101 * Colorbpp));
	}
}
// Section: Types

// Description: This abstracts a color type.  Internally, the structure is different for each platform depending on the native component ordering and the bits per pixel for the platform.
union Color {
public:

	// -- Predefined values

	// Description: Black!
	static Color Black 		= { _internal: { components: {r: eval!(_8toNativebpp(0x00)), g: eval!(_8toNativebpp(0x00)), b: eval!(_8toNativebpp(0x00)), a: eval!(_8toNativebpp(0xFF)) } } };

	static Color Green		= { _internal: { components: {r: eval!(_8toNativebpp(0x00)), g: eval!(_8toNativebpp(0xFF)), b: eval!(_8toNativebpp(0x00)), a: eval!(_8toNativebpp(0xFF)) } } };
	static Color Red		= { _internal: { components: {r: eval!(_8toNativebpp(0xFF)), g: eval!(_8toNativebpp(0x00)), b: eval!(_8toNativebpp(0x00)), a: eval!(_8toNativebpp(0xFF)) } } };
	static Color Blue 		= { _internal: { components: {r: eval!(_8toNativebpp(0x00)), g: eval!(_8toNativebpp(0x00)), b: eval!(_8toNativebpp(0xFF)), a: eval!(_8toNativebpp(0xFF)) } } };

	static Color Magenta 	= { _internal: { components: {r: eval!(_8toNativebpp(0xFF)), g: eval!(_8toNativebpp(0x00)), b: eval!(_8toNativebpp(0xFF)), a: eval!(_8toNativebpp(0xFF)) } } };
	static Color Yellow 	= { _internal: { components: {r: eval!(_8toNativebpp(0xFF)), g: eval!(_8toNativebpp(0xFF)), b: eval!(_8toNativebpp(0x00)), a: eval!(_8toNativebpp(0xFF)) } } };
	static Color Cyan 		= { _internal: { components: {r: eval!(_8toNativebpp(0x00)), g: eval!(_8toNativebpp(0xFF)), b: eval!(_8toNativebpp(0xFF)), a: eval!(_8toNativebpp(0xFF)) } } };

	static Color DarkGray	= { _internal: { components: {r: eval!(_8toNativebpp(0x80)), g: eval!(_8toNativebpp(0x80)), b: eval!(_8toNativebpp(0x80)), a: eval!(_8toNativebpp(0xFF)) } } };
	static Color Gray 		= { _internal: { components: {r: eval!(_8toNativebpp(0xC0)), g: eval!(_8toNativebpp(0xC0)), b: eval!(_8toNativebpp(0xC0)), a: eval!(_8toNativebpp(0xFF)) } } };

	static Color White 		= { _internal: { components: {r: eval!(_8toNativebpp(0xFF)), g: eval!(_8toNativebpp(0xFF)), b: eval!(_8toNativebpp(0xFF)), a: eval!(_8toNativebpp(0xFF)) } } };

	// --

	// Description: This function will set the color given the 8-bit red, green, blue, and alpha components.
	static Color fromRGBA(ubyte r, ubyte g, ubyte b, ubyte a) {
		Color ret;
		static if (Colorbpp == Parameter_Colorbpp.Color8bpp) {
			ret._internal.components.r = r;
			ret._internal.components.g = g;
			ret._internal.components.b = b;
			ret._internal.components.a = a;
		}
		else static if (Colorbpp == Parameter_Colorbpp.Color16bpp) {
			ret._internal.components.r = (cast(double)r / cast(double)0xFF) * 0xFFFF;
			ret._internal.components.g = (cast(double)g / cast(double)0xFF) * 0xFFFF;
			ret._internal.components.b = (cast(double)b / cast(double)0xFF) * 0xFFFF;
			ret._internal.components.a = (cast(double)a / cast(double)0xFF) * 0xFFFF;
		}
		return ret;
	}

	// Description: This function will set the color given the 8-bit red, green, and blue components.
	static Color fromRGB(ubyte r, ubyte g, ubyte b) {
		Color ret;
		static if (Colorbpp == Parameter_Colorbpp.Color8bpp) {
			ret._internal.components.r = r;
			ret._internal.components.g = g;
			ret._internal.components.b = b;
			ret._internal.components.a = 0xFF;
		}
		else static if (Colorbpp == Parameter_Colorbpp.Color16bpp) {
			ret._internal.components.r = (cast(double)r / cast(double)0xFF) * 0xFFFF;
			ret._internal.components.g = (cast(double)g / cast(double)0xFF) * 0xFFFF;
			ret._internal.components.b = (cast(double)b / cast(double)0xFF) * 0xFFFF;
			ret._internal.components.a = 0xFFFF;
		}
		return ret;
	}

	ubyte blue() {
		static if (Colorbpp == Parameter_Colorbpp.Color8bpp) {
			return _internal.components.b;
		}
		else {
			return (cast(double)_internal.components.b / cast(double)0xFFFF) * 0xFF;
		}
	}

	void blue(ubyte val) {
		static if (Colorbpp == Parameter_Colorbpp.Color8bpp) {
			_internal.components.b = val;
		}
		else {
			_internal.components.b = (cast(double)val / cast(double)0xFF) * 0xFFFF;
		}
	}

	ubyte green() {
		static if (Colorbpp == Parameter_Colorbpp.Color8bpp) {
			return _internal.components.g;
		}
		else {
			return (cast(double)_internal.components.g / cast(double)0xFFFF) * 0xFF;
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

	ubyte red() {
		static if (Colorbpp == Parameter_Colorbpp.Color8bpp) {
			return _internal.components.r;
		}
		else {
			return (cast(double)_internal.components.r / cast(double)0xFFFF) * 0xFF;
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
	
	ColorValue value() {
		return _internal.clr;
	}

private:

	union internal {
		_comps components;

		ColorValue clr;
	}

	internal _internal;
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
