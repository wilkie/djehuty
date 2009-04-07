module platform.win.scaffolds.opengl;

import opengl.gl;
import opengl.window;

import platform.win.common;
import platform.win.vars;

// some extra GDI imports

/* pixel types */
const auto PFD_TYPE_RGBA			= 0;
const auto PFD_TYPE_COLORINDEX		= 1;

/* layer types */
const auto PFD_MAIN_PLANE			= 0;
const auto PFD_OVERLAY_PLANE		= 1;
const auto PFD_UNDERLAY_PLANE		= (-1);

/* PIXELFORMATDESCRIPTOR flags */
const auto PFD_DOUBLEBUFFER				= 0x00000001;
const auto PFD_STEREO					= 0x00000002;
const auto PFD_DRAW_TO_WINDOW			= 0x00000004;
const auto PFD_DRAW_TO_BITMAP			= 0x00000008;
const auto PFD_SUPPORT_GDI				= 0x00000010;
const auto PFD_SUPPORT_OPENGL			= 0x00000020;
const auto PFD_GENERIC_FORMAT			= 0x00000040;
const auto PFD_NEED_PALETTE				= 0x00000080;
const auto PFD_NEED_SYSTEM_PALETTE		= 0x00000100;
const auto PFD_SWAP_EXCHANGE			= 0x00000200;
const auto PFD_SWAP_COPY				= 0x00000400;
const auto PFD_SWAP_LAYER_BUFFERS		= 0x00000800;
const auto PFD_GENERIC_ACCELERATED		= 0x00001000;
const auto PFD_SUPPORT_DIRECTDRAW		= 0x00002000;

/* PIXELFORMATDESCRIPTOR flags for use in ChoosePixelFormat only */
const auto PFD_DEPTH_DONTCARE			= 0x20000000;
const auto PFD_DOUBLEBUFFER_DONTCARE	= 0x40000000;
const auto PFD_STEREO_DONTCARE			= 0x80000000;

// the necessary windows GL calls

extern (Windows) {

	HGLRC wglCreateContext(HDC hdc);
	BOOL wglMakeCurrent(HDC hdc, HGLRC hglrc);

}

PIXELFORMATDESCRIPTOR pfd =              // pfd Tells Windows How We Want Things To Be
{
	PIXELFORMATDESCRIPTOR.sizeof,              // Size Of This Pixel Format Descriptor
	1,                                          // Version Number
	PFD_DRAW_TO_WINDOW |                        // Format Must Support Window
	PFD_SUPPORT_OPENGL |                        // Format Must Support OpenGL
	PFD_DOUBLEBUFFER,                           // Must Support Double Buffering
	PFD_TYPE_RGBA,                              // Request An RGBA Format
	32,                                       // Select Our Color Depth
	0, 0, 0, 0, 0, 0,                           // Color Bits Ignored
	0,                                          // No Alpha Buffer
	0,                                          // Shift Bit Ignored
	0,                                          // No Accumulation Buffer
	0, 0, 0, 0,                                 // Accumulation Bits Ignored
	16,                                         // 16Bit Z-Buffer (Depth Buffer)
	0,                                          // No Stencil Buffer
	0,                                          // No Auxiliary Buffer
	PFD_MAIN_PLANE,                             // Main Drawing Layer
	0,                                          // Reserved
	0, 0, 0                                     // Layer Masks Ignored
};

void OpenGLWindowInitialize(ref GLWindow glWindow, WindowPlatformVars* windowVars)
{/*
	HGLRC hRC;

	GLuint PixelFormat;

	if ((windowVars.windhDC=GetDC(windowVars.hWnd)) == null)                         // Did We Get A Device Context?
	{
		MessageBoxW(null,"Can't Create A GL Device Context.\0"w.ptr,"ERROR\0"w.ptr,MB_OK|MB_ICONEXCLAMATION);
		return ;                                // Return FALSE
	}

	if ((PixelFormat=ChoosePixelFormat(windowVars.windhDC,&pfd)) == 0) // Did Windows Find A Matching Pixel Format?
	{
		MessageBoxW(null,"Can't Find A Suitable PixelFormat.\0"w.ptr,"ERROR\0"w.ptr,MB_OK|MB_ICONEXCLAMATION);
		return ;                                // Return FALSE
	}

	if(SetPixelFormat(windowVars.windhDC,PixelFormat,&pfd) == 0)       // Are We Able To Set The Pixel Format?
	{
		MessageBoxW(null,"Can't Set The PixelFormat.\0"w.ptr,"ERROR\0"w.ptr,MB_OK|MB_ICONEXCLAMATION);
		return ;                                // Return FALSE
	}

	if ((hRC=wglCreateContext(windowVars.windhDC)) == null)               // Are We Able To Get A Rendering Context?
	{
		MessageBoxW(null,"Can't Create A GL Rendering Context.\0"w.ptr,"ERROR\0"w.ptr,MB_OK|MB_ICONEXCLAMATION);
		return ;                                // Return FALSE
	}

	if(wglMakeCurrent(windowVars.windhDC,hRC) == 0)                    // Try To Activate The Rendering Context
	{
		MessageBoxW(null,"Can't Activate The GL Rendering Context.\0"w.ptr,"ERROR\0"w.ptr,MB_OK|MB_ICONEXCLAMATION);
		return ;                                // Return FALSE
	}*/
}
