module core.parameters;

// For Parameters (Internal, Platform Use)

enum Parameter_Colorbpp
{
	Color8bpp,
	Color16bpp		// Needs to be 1 for 16bpp static color definitions
}

enum Parameter_ColorType
{
	ColorRGBA,
	ColorBGRA,
	ColorARGB,
	ColorABGR,
}