/*
 * canvas.d
 *
 * This module implements a 2d drawing canvas.
 *
 */

module graphics.canvas;

import djehuty;

import graphics.brush;
import graphics.pen;
import graphics.font;
import graphics.path;
import graphics.contour;
import graphics.region;

import resource.image;

import scaffold.canvas;

import synch.thread;

import binding.opengl.gl;
import binding.opengl.glu;
import binding.opengl.glext;
import binding.win32.wingdi;
import binding.win32.windef;
import binding.win32.winuser;

import platform.vars.canvas;

import io.console;

import math.common;
import math.cos;
import math.sin;

class Canvas {
private:
	//The GL extension functions
	static PFNGLISRENDERBUFFEREXTPROC glIsRenderbufferEXTPtr;
	static PFNGLBINDRENDERBUFFEREXTPROC glBindRenderbufferEXTPtr;
	static PFNGLDELETERENDERBUFFERSEXTPROC glDeleteRenderbuffersEXTPtr;
	static PFNGLGENRENDERBUFFERSEXTPROC glGenRenderbuffersEXTPtr;
	static PFNGLRENDERBUFFERSTORAGEEXTPROC glRenderbufferStorageEXTPtr;
	static PFNGLGETRENDERBUFFERPARAMETERIVEXTPROC glGetRenderbufferParameterivEXTPtr;
	static PFNGLISFRAMEBUFFEREXTPROC glIsFramebufferEXTPtr;
	static PFNGLBINDFRAMEBUFFEREXTPROC glBindFramebufferEXTPtr;
	static PFNGLDELETEFRAMEBUFFERSEXTPROC glDeleteFramebuffersEXTPtr;
	static PFNGLGENFRAMEBUFFERSEXTPROC glGenFramebuffersEXTPtr;
	static PFNGLCHECKFRAMEBUFFERSTATUSEXTPROC glCheckFramebufferStatusEXTPtr;
	static PFNGLFRAMEBUFFERTEXTURE1DEXTPROC glFramebufferTexture1DEXTPtr;
	static PFNGLFRAMEBUFFERTEXTURE2DEXTPROC glFramebufferTexture2DEXTPtr;
	static PFNGLFRAMEBUFFERTEXTURE3DEXTPROC glFramebufferTexture3DEXTPtr;
	static PFNGLFRAMEBUFFERRENDERBUFFEREXTPROC glFramebufferRenderbufferEXTPtr;
	static PFNGLGETFRAMEBUFFERATTACHMENTPARAMETERIVEXTPROC glGetFramebufferAttachmentParameterivEXTPtr;
	static PFNGLGENERATEMIPMAPEXTPROC glGenerateMipmapEXTPtr;
	static PFNGLRENDERBUFFERSTORAGEMULTISAMPLEEXTPROC glRenderbufferStorageMultisampleEXTPtr;

	static PFNGLBINDPROGRAMARBPROC glBindProgramARBPtr;
	static PFNGLGENPROGRAMSARBPROC glGenProgramsARBPtr;
	static PFNGLPROGRAMSTRINGARBPROC glProgramStringARBPtr;

	static PFNGLMULTITEXCOORD1FPROC glMultiTexCoord1fPtr;
	static PFNGLMULTITEXCOORD2FPROC glMultiTexCoord2fPtr;

	static PFNGLBLENDFUNCSEPARATEPROC glBlendFuncSeparatePtr;
	static PFNGLBLENDEQUATIONSEPARATEPROC glBlendEquationSeparatePtr;

/*	static const string QUADRATIC_SHADER = `!!ARBfp1.0
TEMP color;
MUL color, fragment.texcoord[1].y, 2.0;
ADD color, 1.0, -color;
ABS color, color;
ADD result.color, 1.0, -color;
MOV result.color.a, 0.5;
END`;//*/

	// Some fragment shaders that will rasterize a curve
	// Reference: http://www.mdk.org.pl/2007/10/27/curvy-blues
	// Modified from the work of Michael Dominic K.

	// However, these are not good enough, because they do not
	// provide anti-aliasing. They will need to be modified
	// to do this. The easiest method is to have the alpha be
	// a piecewise function to the distance to the curve.

	// This requires the use of gradient functions, which are
	// not standard to the ARB shader specification, but are
	// available in GLSL 2 and NVidia proprietary extensions.

	// I think it is fine to use *all* of the strategies and
	// fallback to CPU tesselation when they are not available.
	// Order the affinity to provide best performance.
	static const string QUADRATIC_SHADER = `!!ARBfp1.0
PARAM c[1] = { { 1, 0 } };
TEMP R0;
MUL R0.x, fragment.texcoord[0], fragment.texcoord[0];
SLT R0.x, R0, fragment.texcoord[0].y;
ABS R0.x, R0;
CMP R0.x, -R0, c[0].y, c[0];
CMP result.color, -R0.x, c[0].y, fragment.color.primary;
END`; 

	static GLuint _quadraticShader;

	static const string CUBIC_SHADER = `!!ARBfp1.0
PARAM c[1] = { { 1, 0, 1e-06 } };
TEMP R0;
MUL R0.x, fragment.texcoord[0], fragment.texcoord[0];
MUL R0.x, fragment.texcoord[0], R0;
MAD R0.y, fragment.texcoord[0], fragment.texcoord[0].z, c[0].z;
SLT R0.x, R0.y, R0;
ABS R0.x, R0;
CMP R0.x, -R0, c[0].y, c[0];
CMP result.color, -R0.x, c[0].y, fragment.color.primary;
END`;

	static GLuint _cubicShader;

	int _width;
	int _height;

	Brush _brush;

	Color _fillColor;
	Color _strokeColor;

	Pen _pen;
	Font _font;

	CanvasPlatformVars _pfvars;

	bool _forcenopremultiply = false;
	bool _antialias;

	static bool _glInited = false;
	static HGLRC _hRC;
//	static HDC _hDC;
	static HWND _hWnd;

	static void _init() {
		if (_glInited) {
			return;
		}

		// Initialize OpenGL
		_glInited = true;

		// Create a dummy class
		WNDCLASSW wc;
		wstring className = "DummyWindow\0"w;
		wc.lpszClassName = className.ptr;

		wc.style = CS_OWNDC;

		wc.lpfnWndProc = &DefWindowProc;

		wc.hInstance = null;

		wc.hIcon = LoadIconA(cast(HINSTANCE) null, IDI_APPLICATION);
		wc.hCursor = LoadCursorA(cast(HINSTANCE) null, IDC_ARROW);

		wc.hbrBackground = cast(HBRUSH) (COLOR_WINDOW + 1);
		wc.lpszMenuName = null;
		wc.cbClsExtra = wc.cbWndExtra = 0;

		RegisterClassW(&wc);

		// Create a dummy window
		_hWnd = CreateWindowExW(0,
		className.ptr, "\0"w.ptr,
		WS_OVERLAPPED,
		0, 0, cast(int)0, cast(int)0,
		null, null, null, null);

		// Get a dummy device context
		auto dummyhDC = GetDC(_hWnd);

//		putln("threadInit? ", Thread.current.id);
//		_inited[Thread.current] = true;

//		putln("threadInit...");
		GLuint PixelFormat;

		static PIXELFORMATDESCRIPTOR pfd = {
			PIXELFORMATDESCRIPTOR.sizeof,
			1,                                          // Version Number
			PFD_DRAW_TO_WINDOW |                        // Format Must Support Window
			PFD_SUPPORT_OPENGL |                        // Format Must Support OpenGL
			PFD_DOUBLEBUFFER,                           // Must Support Double Buffering
			PFD_TYPE_RGBA,                              // Request An RGBA Format
			32,                                         // Select Our Color Depth
			0, 0, 0, 0, 0, 0,                           // Color Bits Ignored
			0,                                          // No Alpha Buffer
			0,                                          // Shift Bit Ignored
			0,                                          // No Accumulation Buffer
			0, 0, 0, 0,                                 // Accumulation Bits Ignored
			24,                                         // 16Bit Z-Buffer (Depth Buffer)
			8,                                          // Some Stencil Buffer
			0,                                          // No Auxiliary Buffer
			PFD_MAIN_PLANE,                             // Main Drawing Layer
			0,                                          // Reserved
			0, 0, 0                                     // Layer Masks Ignored
		};

		putln("pixel format");

		putln("choosepixel");

		// Set up the pixel format
		if ((PixelFormat=ChoosePixelFormat(dummyhDC,&pfd)) == 0) { // Did Windows Find A Matching Pixel Format?
			putln("Can't Find A Suitable PixelFormat.");
			return ; // Return FALSE
		}

		putln("setpixel");
		if(SetPixelFormat(dummyhDC,PixelFormat,&pfd) == 0) { // Are We Able To Set The Pixel Format?
			putln("Can't Set The PixelFormat.");
			return ; // Return FALSE
		}

		_threadInit();

		/*
		putln("createcontext");
		// Create a faux-GL context
		if ((_hRC=wglCreateContext(dummyhDC)) == null) { // Are We Able To Get A Rendering Context?
			putln("Can't Create A GL Rendering Context. (ti)");
			return ; // Return FALSE
		}

		putln("makecurrent");
		// Make this the current GL context
		if(wglMakeCurrent(dummyhDC,_hRC) == 0) { // Try To Activate The Rendering Context
			putln("Can't Activate The GL Rendering Context.");
			//return ; // Return FALSE
		}
*/
		putln("glgetproc");
		// Retrieve GL extension functions
		glIsRenderbufferEXTPtr = cast(PFNGLISRENDERBUFFEREXTPROC)wglGetProcAddress("glIsRenderbufferEXT\0"c.ptr);
		if (glIsRenderbufferEXTPtr is null) { putln("glIsRenderbufferEXT not found"); }
		glBindRenderbufferEXTPtr = cast(PFNGLBINDRENDERBUFFEREXTPROC)wglGetProcAddress("glBindRenderbufferEXT\0"c.ptr);
		if (glBindRenderbufferEXTPtr is null) { putln("glBindRenderbufferEXT not found"); }
		glDeleteRenderbuffersEXTPtr = cast(PFNGLDELETERENDERBUFFERSEXTPROC)wglGetProcAddress("glDeleteRenderbuffersEXT\0"c.ptr);
		if (glDeleteRenderbuffersEXTPtr is null) { putln("glDeleteRenderbuffersEXT not found"); }
		glGenRenderbuffersEXTPtr = cast(PFNGLGENRENDERBUFFERSEXTPROC)wglGetProcAddress("glGenRenderbuffersEXT\0"c.ptr);
		if (glGenRenderbuffersEXTPtr is null) { putln("glGenRenderbuffersEXT not found"); }
		glRenderbufferStorageEXTPtr = cast(PFNGLRENDERBUFFERSTORAGEEXTPROC)wglGetProcAddress("glRenderbufferStorageEXT\0"c.ptr);
		if (glRenderbufferStorageEXTPtr is null) { putln("glRenderbufferStorageEXT not found"); }
		glGetRenderbufferParameterivEXTPtr = cast(PFNGLGETRENDERBUFFERPARAMETERIVEXTPROC)wglGetProcAddress("glGetRenderbufferParameterivEXT\0"c.ptr);
		if (glGetRenderbufferParameterivEXTPtr is null) { putln("glGetRenderbufferParameterivEXT not found"); }
		glIsFramebufferEXTPtr = cast(PFNGLISFRAMEBUFFEREXTPROC)wglGetProcAddress("glIsFramebufferEXT\0"c.ptr);
		if (glIsFramebufferEXTPtr is null) { putln("glIsFramebufferEXT not found"); }
		glBindFramebufferEXTPtr = cast(PFNGLBINDFRAMEBUFFEREXTPROC)wglGetProcAddress("glBindFramebufferEXT\0"c.ptr);
		if (glBindFramebufferEXTPtr is null) { putln("glBindFramebufferEXT not found"); }
		glDeleteFramebuffersEXTPtr = cast(PFNGLDELETEFRAMEBUFFERSEXTPROC)wglGetProcAddress("glDeleteFramebuffersEXT\0"c.ptr);
		if (glDeleteFramebuffersEXTPtr is null) { putln("glDeleteFramebuffersEXT not found"); }
		glGenFramebuffersEXTPtr = cast(PFNGLGENFRAMEBUFFERSEXTPROC)wglGetProcAddress("glGenFramebuffersEXT\0"c.ptr);
		if (glGenFramebuffersEXTPtr is null) { putln("glGenFramebuffersEXT not found"); }
		glCheckFramebufferStatusEXTPtr = cast(PFNGLCHECKFRAMEBUFFERSTATUSEXTPROC)wglGetProcAddress("glCheckFramebufferStatusEXT\0"c.ptr);
		if (glCheckFramebufferStatusEXTPtr is null) { putln("glCheckFramebufferStatusEXT not found"); }
		glFramebufferTexture1DEXTPtr = cast(PFNGLFRAMEBUFFERTEXTURE1DEXTPROC)wglGetProcAddress("glFramebufferTexture1DEXT\0"c.ptr);
		if (glFramebufferTexture1DEXTPtr is null) { putln("glFramebufferTexture1DEXT not found"); }
		glFramebufferTexture2DEXTPtr = cast(PFNGLFRAMEBUFFERTEXTURE2DEXTPROC)wglGetProcAddress("glFramebufferTexture2DEXT\0"c.ptr);
		if (glFramebufferTexture2DEXTPtr is null) { putln("glFramebufferTexture2DEXT not found"); }
		glFramebufferTexture3DEXTPtr = cast(PFNGLFRAMEBUFFERTEXTURE3DEXTPROC)wglGetProcAddress("glFramebufferTexture3DEXT\0"c.ptr);
		if (glFramebufferTexture3DEXTPtr is null) { putln("glFramebufferTexture3DEXT not found"); }
		glFramebufferRenderbufferEXTPtr = cast(PFNGLFRAMEBUFFERRENDERBUFFEREXTPROC)wglGetProcAddress("glFramebufferRenderbufferEXT\0"c.ptr);
		if (glFramebufferRenderbufferEXTPtr is null) { putln("glFramebufferRenderbufferEXT not found"); }
		glGetFramebufferAttachmentParameterivEXTPtr = cast(PFNGLGETFRAMEBUFFERATTACHMENTPARAMETERIVEXTPROC)wglGetProcAddress("glGetFramebufferAttachmentParameterivEXT\0"c.ptr);
		if (glGetFramebufferAttachmentParameterivEXTPtr is null) { putln("glGetFramebufferAttachmentParameterivEXT not found"); }
		glGenerateMipmapEXTPtr = cast(PFNGLGENERATEMIPMAPEXTPROC)wglGetProcAddress("glGenerateMipmapEXT\0"c.ptr);
		if (glGenerateMipmapEXTPtr is null) { putln("glGenerateMipmapEXT not found"); }
		glRenderbufferStorageMultisampleEXTPtr = cast(PFNGLRENDERBUFFERSTORAGEMULTISAMPLEEXTPROC)wglGetProcAddress("glRenderbufferStorageMultisampleEXT\0"c.ptr);
		if (glRenderbufferStorageMultisampleEXTPtr is null) { putln("glRenderbufferStorageMultisampleEXT not found"); }
		glBlendFuncSeparatePtr = cast(PFNGLBLENDFUNCSEPARATEPROC)wglGetProcAddress("glBlendFuncSeparate\0"c.ptr);
		if (glBlendFuncSeparatePtr is null) { putln("glBlendFuncSeparate not found"); }
		glBlendEquationSeparatePtr = cast(PFNGLBLENDEQUATIONSEPARATEPROC)wglGetProcAddress("glBlendEquationSeparate\0"c.ptr);
		if (glBlendEquationSeparatePtr is null) { putln("glBlendEquationSeparate not found"); }

		glBindProgramARBPtr = cast(PFNGLBINDPROGRAMARBPROC)wglGetProcAddress("glBindProgramARB\0"c.ptr);
		if (glBindProgramARBPtr is null) { putln("glBindProgramARB not found"); }
		glGenProgramsARBPtr = cast(PFNGLGENPROGRAMSARBPROC)wglGetProcAddress("glGenProgramsARB\0"c.ptr);
		if (glGenProgramsARBPtr is null) { putln("glGenProgramsARB not found"); }
		glProgramStringARBPtr = cast(PFNGLPROGRAMSTRINGARBPROC)wglGetProcAddress("glProgramStringARB\0"c.ptr);
		if (glProgramStringARBPtr is null) { putln("glProgramStringARB not found"); }

		glMultiTexCoord1fPtr = cast(PFNGLMULTITEXCOORD1FPROC)wglGetProcAddress("glMultiTexCoord1f\0"c.ptr);
		if (glMultiTexCoord1fPtr is null) { putln("glMultiTexCoord1f not found"); }
		glMultiTexCoord2fPtr = cast(PFNGLMULTITEXCOORD2FPROC)wglGetProcAddress("glMultiTexCoord2f\0"c.ptr);
		if (glMultiTexCoord2fPtr is null) { putln("glMultiTexCoord2f not found"); }

		ReleaseDC(_hWnd, dummyhDC);
	}

	static HGLRC _RC[Thread];
	static void _threadInit() {
		auto dummyhDC = GetDC(_hWnd);
		if (!(Thread.current in _RC)) {
			// Get a dummy device context

			putln("createcontext");
			// Create a faux-GL context
			if ((_RC[Thread.current]=wglCreateContext(dummyhDC)) == null) { // Are We Able To Get A Rendering Context?
				putln("Can't Create A GL Rendering Context. (ti)");
				ReleaseDC(_hWnd, dummyhDC);
				return ; // Return FALSE
			}
			if (_hRC is null) {
				_hRC = _RC[Thread.current];
			}
			else {
				wglShareLists(_hRC, _RC[Thread.current]);
			}
		}

//		putln("makecurrent");
		// Make this the current GL context
		wglMakeCurrent(null, null);
		if(wglMakeCurrent(dummyhDC,_RC[Thread.current]) == 0) { // Try To Activate The Rendering Context
			putln("Can't Activate The GL Rendering Context.");
			//return ; // Return FALSE
		}

		ReleaseDC(_hWnd, dummyhDC);

		//*/
	}

	void _initMask() {
		// Mask for our antialias bit (0x1, defined by us)

		// Update the mask by setting the first bit in the mask
		glStencilFunc(GL_NOTEQUAL, 0x10, 0x11);
		glStencilOp (GL_KEEP, GL_INCR, GL_INCR);

		// Turn off rendering
		glColorMask(GL_FALSE, GL_FALSE, GL_FALSE, GL_FALSE);
	}

	void _uninitMask() {
		glStencilFunc (GL_EQUAL, 0x00, 0x11);
		glStencilOp (GL_KEEP, GL_KEEP, GL_KEEP);
	}

	void _useMask() {
		// Allow rendering
		glColorMask (GL_TRUE, GL_TRUE, GL_TRUE, GL_TRUE);

		// Only allow rendering where none of the bits are set in the stencil
		glStencilFunc (GL_EQUAL, 0x00, 0x11);

		// Do not update the mask
		glStencilOp (GL_KEEP, GL_KEEP, GL_KEEP);
	}

	void _revertMask() {
		glStencilFunc (GL_EQUAL, 0x01, 0x11);

		// Interestingly, we can clear the stencil at the same time
		// We might as well. Every time we see the first bit set
		glStencilOp (GL_KEEP, GL_ZERO, GL_ZERO);
	}

	void _drawRing(uint type, double x, double y, double width, double height, double ringWidth) {
		static const double n = 100.0;

		if (type == GL_TRIANGLE_STRIP) {
			glBegin(GL_TRIANGLE_STRIP);
			double resultX, resultY;
			for(double t = 0; t <= TWOPI; t += TWOPI/n) {
				resultX = x + (width * cos(t));
				resultY = y + (height * sin(t));
				glVertex3f(resultX, resultY, 0);

				// For the ring part
				resultX = x + ((width-(ringWidth)) * cos(t));
				resultY = y + ((height-(ringWidth)) * sin(t));
				glVertex3f(resultX, resultY, 0);
			}
			glEnd();
		}
		else {
			glBegin(GL_LINE_LOOP);
			double resultX, resultY;
			for(double t = 0; t <= TWOPI; t += TWOPI/n) {
				resultX = x + (width * cos(t));
				resultY = y + (height * sin(t));
				glVertex3f(resultX, resultY, 0);
			}
			glEnd();
			glBegin(GL_LINE_LOOP);
			for(double t = 0; t <= TWOPI; t += TWOPI/n) {
				// For the ring part
				resultX = x + ((width-(ringWidth)) * cos(t));
				resultY = y + ((height-(ringWidth)) * sin(t));
				glVertex3f(resultX, resultY, 0);
			}
			glEnd();
		}
	}

	void _drawEllipse(uint type, double x, double y, double width, double height) {
		static const double n = 100.0;

		glBegin(type);
		for(double t = 0; t <= TWOPI; t += TWOPI/n) {
			glVertex3f(x + (width * cos(t)), y + (height * sin(t)),0);
		}
		glEnd();
	}

	void _unsetContext() {
		wglMakeCurrent(null, null);
	}

	// Yay for the many render buffers that we need.
	GLuint color_rb, depth_rb, stencil_rb, packed_rb, tex;

	// This identifies the framebuffer object.
	GLuint fb;

public:

	this(int width, int height) {
		putln("initing");
		_init();
		_threadInit();
		putln("init done");

		putln("setup ", width, " x ", height);

		_width = width;
		_height = height;

		if (width == 0 || height == 0) {
			return;
		}

/*		auto dummyhDC = GetDC(_hWnd);
		// Create a faux-GL context
		if ((_hRC=wglCreateContext(dummyhDC)) == null) { // Are We Able To Get A Rendering Context?
			putln("Can't Create A GL Rendering Context. (constructor)");
			return ; // Return FALSE
		}
		ReleaseDC(_hWnd, dummyhDC);*/

		setContext();

		putln("setup ", width, " x ", height);

		auto ext = cast(char*)glGetString(GL_EXTENSIONS);
		if (ext !is null) {
			auto extstr = ext[0..strlen(ext)];
			putln("extensions: ", extstr);
		}

		glEnable(GL_TEXTURE_2D);
		
		glGenTextures(1, &tex);
		glBindTexture(GL_TEXTURE_2D, tex);

		glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,GL_NEAREST);
		glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER,GL_NEAREST);

		glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA8, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, null);

		// RGBA8 RenderBuffer
		glGenFramebuffersEXTPtr(1, &fb);
		glBindFramebufferEXTPtr(GL_FRAMEBUFFER_EXT, fb);

		// Create and attach a color buffer
		/*glGenRenderbuffersEXTPtr(1, &color_rb);

		// We must bind color_rb before we call glRenderbufferStorageEXT
		glBindRenderbufferEXTPtr(GL_RENDERBUFFER_EXT, color_rb);

		// The storage format is RGBA8
		glRenderbufferStorageEXTPtr(GL_RENDERBUFFER_EXT, GL_RGBA8, width, height);

		// The following is for a multisample FBO.
		// This is not strictly necessary ever. But illustrated here for posterity:
		// glRenderbufferStorageMultisampleEXTPtr(GL_RENDERBUFFER_EXT, 4, GL_RGBA8, width, height);

		// Attach color buffer to FBO
		glFramebufferRenderbufferEXTPtr(GL_FRAMEBUFFER_EXT, GL_COLOR_ATTACHMENT0_EXT,
			GL_RENDERBUFFER_EXT, color_rb);
*/
		glFramebufferTexture2DEXTPtr(GL_FRAMEBUFFER_EXT, GL_COLOR_ATTACHMENT0_EXT, GL_TEXTURE_2D, tex, 0);

		// Some video cards need a depth buffer with a stencil buffer.
		// Otherwise, a stencil buffer can just be produced with a simple
		//   GL_STENCIL_INDEX_8 renderbuffer.
		// XXX: should probably check for this extension before I use it.
		glGenRenderbuffersEXTPtr(1, &packed_rb);
		glBindRenderbufferEXTPtr(GL_RENDERBUFFER_EXT, packed_rb);
		glRenderbufferStorageEXTPtr(GL_RENDERBUFFER_EXT, GL_DEPTH_STENCIL_EXT, _width, _height);
		glFramebufferRenderbufferEXTPtr(GL_FRAMEBUFFER_EXT,GL_DEPTH_ATTACHMENT_EXT, GL_RENDERBUFFER_EXT, packed_rb);
		glFramebufferRenderbufferEXTPtr(GL_FRAMEBUFFER_EXT, GL_STENCIL_ATTACHMENT_EXT, GL_RENDERBUFFER_EXT, packed_rb);

		glDisable(GL_TEXTURE_2D);
		// We should check to see if the FBO is supported... now, for some reason.
		GLenum status = glCheckFramebufferStatusEXTPtr(GL_FRAMEBUFFER_EXT);
		switch(status) {
			case GL_FRAMEBUFFER_COMPLETE_EXT:
			putln("complete");
			break;
		case GL_FRAMEBUFFER_UNSUPPORTED_EXT:
			putln("Framebuffer object format is unsupported by the video hardware. (GL_FRAMEBUFFER_UNSUPPORTED_EXT)(FBO - 820)");

			// Damn.
			// XXX: Use some hideous older technology
			break;
		case GL_FRAMEBUFFER_INCOMPLETE_ATTACHMENT_EXT:
			putln("Incomplete attachment. (GL_FRAMEBUFFER_INCOMPLETE_ATTACHMENT_EXT)(FBO - 820)");
			break;
		case GL_FRAMEBUFFER_INCOMPLETE_MISSING_ATTACHMENT_EXT:
			putln("Incomplete missing attachment. (GL_FRAMEBUFFER_INCOMPLETE_MISSING_ATTACHMENT_EXT)(FBO - 820)");
			break;
		case GL_FRAMEBUFFER_INCOMPLETE_DIMENSIONS_EXT:
			putln("Incomplete dimensions. (GL_FRAMEBUFFER_INCOMPLETE_DIMENSIONS_EXT)(FBO - 820)");
			break;
		case GL_FRAMEBUFFER_INCOMPLETE_FORMATS_EXT:
			putln("Incomplete formats. (GL_FRAMEBUFFER_INCOMPLETE_FORMATS_EXT)(FBO - 820)");
			break;
		case GL_FRAMEBUFFER_INCOMPLETE_DRAW_BUFFER_EXT:
			putln("Incomplete draw buffer. (GL_FRAMEBUFFER_INCOMPLETE_DRAW_BUFFER_EXT)(FBO - 820)");
			break;
		case GL_FRAMEBUFFER_INCOMPLETE_READ_BUFFER_EXT:
			putln("Incomplete read buffer. (GL_FRAMEBUFFER_INCOMPLETE_READ_BUFFER_EXT)(FBO - 820)");
			break;
		case GL_FRAMEBUFFER_INCOMPLETE_MULTISAMPLE_EXT:
			putln("Incomplete multisample buffer. (GL_FRAMEBUFFER_INCOMPLETE_MULTISAMPLE_EXT)(FBO - 820)");
			break;
		default:
			//Programming error; will fail on all hardware
			putln("Some video driver error or programming error occured. Framebuffer object status is invalid. (FBO - 823)");
		}

		// and now you can render to the FBO (also called RenderBuffer)
		glBindFramebufferEXTPtr(GL_FRAMEBUFFER_EXT, fb);

		glEnable(GL_BLEND);
/*
		glEnable(GL_FRAGMENT_PROGRAM_ARB);

		// Generate the shader for the quadratic curve rasterizer
		glGenProgramsARBPtr(1, &_quadraticShader);
		glBindProgramARBPtr(GL_FRAGMENT_PROGRAM_ARB, _quadraticShader);

		// Load the quadratic curve rasterizer
		glProgramStringARBPtr(GL_FRAGMENT_PROGRAM_ARB, GL_PROGRAM_FORMAT_ASCII_ARB, QUADRATIC_SHADER.length, QUADRATIC_SHADER.ptr);
		char* retstr = cast(char*)glGetString(GL_PROGRAM_ERROR_STRING_ARB);
		putln("shader");
//		putln(retstr[0..strlen(retstr)]);

		// Generate the shader for the cubic curve rasterizer
		glGenProgramsARBPtr(1, &_cubicShader);
		glBindProgramARBPtr(GL_FRAGMENT_PROGRAM_ARB, _cubicShader);

		// Load the cubic curve rasterizer
		glProgramStringARBPtr(GL_FRAGMENT_PROGRAM_ARB, GL_PROGRAM_FORMAT_ASCII_ARB, CUBIC_SHADER.length, CUBIC_SHADER.ptr);

		glDisable(GL_FRAGMENT_PROGRAM_ARB);
*/
		// The traditional blending function fails since the background
		// of any canvas object we use is technically transparent.

		// With this blending function below, it blends the colors with
		// rgba(0, 0, 0, 0) as though it were actually black. The problem
		// is _not_ with the RGB blending since it is using premultiplied
		// alpha. The problem is that it should not be blending the alpha
		// with the destination alpha the same way it blends colors.
		// glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

		// Therefore, the solution is simple. Impose a different blending
		// equation for the alpha channel. This one will not do anything to
		// the destination alpha channel before blending it with the source.
		// XXX: What to do when these extension are not available? (GL 1.4+)
		glBlendEquationSeparatePtr(GL_ADD, GL_ADD);
		glBlendFuncSeparatePtr(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA, GL_ONE, GL_ONE_MINUS_SRC_ALPHA);

		// Disable things just to be sure
		glDisable(GL_DEPTH_TEST);
		glDisable(GL_LIGHTING);

		// Set up the viewport
		glViewport(0, 0, width, height);

		// Reset the current viewport
		glMatrixMode(GL_PROJECTION);
		glLoadIdentity();

		// Set up an orthographic view
		glOrtho(0, width, height, 0, -1, 1);

		// And then switch over to the model matrix
		glMatrixMode(GL_MODELVIEW);
		glLoadIdentity();

		glLineWidth(1);

		this.pen = new Pen(Color.Black);
		this.brush = new Brush(Color.White);

		_unsetContext();

		this.clear();

		// Clear the screen.

		// RENDER
		// The following gets moved eventually...

		setContext();
		glEnable(GL_STENCIL_TEST);
		glStencilMask(0x11);
		glStencilFunc(GL_EQUAL, 0x00, 0x11);
		glStencilOp(GL_KEEP, GL_KEEP, GL_KEEP);
		glColorMask(GL_TRUE, GL_TRUE, GL_TRUE, GL_TRUE);
	}

	~this() {
	}

	void resize(int width, int height) {
		_width = width;
		_height = height;
	}

	void setContext() {
		_threadInit();

		// Make this the current GL context
/*		if (width == 0 || height == 0) {
			return;
		}*/
/*
		if (wglGetCurrentContext() == _hRC) {
			return;
		}
		
		auto dummyhDC = GetDC(_hWnd);
		while(wglMakeCurrent(dummyhDC,_hRC) == 0) { // Try To Activate The Rendering Context
			putln("sleep?!?!", dummyhDC, " ", _hRC);
			putln(wglGetCurrentContext());
			Thread.sleep(5);
		}

		ReleaseDC(_hWnd, dummyhDC);//*/

		// and now you can render to the FBO (also called RenderBuffer)
		glBindFramebufferEXTPtr(GL_FRAMEBUFFER_EXT, fb);
		glBindTexture(GL_TEXTURE_2D, tex);
	}

	void clear() {
		setContext();
		glClearColor(0, 0, 0, 0);
		glClearStencil(0);
		glClear(GL_COLOR_BUFFER_BIT|GL_STENCIL_BUFFER_BIT);
		_unsetContext();
	}

	int width() {
		return _width;
	}

	int height() {
		return _height;
	}

	// Lines

	void drawLine(double x1, double y1, double x2, double y2) {
		setContext();
		x1 += 0.5;
		y1 += 0.5;
		x2 += 0.5;
		y1 += 0.5;

		if (_antialias) {
			glEnable(GL_LINE_SMOOTH);
			glHint(GL_LINE_SMOOTH_HINT, GL_NICEST);
		}

		glBegin(GL_LINES);
		glColor4f(_strokeColor.red, _strokeColor.green, _strokeColor.blue, _strokeColor.alpha);
		glVertex3f(x1, y1, 0);
		glVertex3f(x2, y2, 0);
		glEnd();

		if (_antialias) {
			glDisable(GL_LINE_SMOOTH);
		}
		_unsetContext();
	}

	// Rectangles

	void drawRectangle(double x, double y, double width, double height) {
		setContext();
		fillRectangle(x, y, width, height);
		strokeRectangle(x, y, width, height);
		_unsetContext();
	}

	void strokeRectangle(double x, double y, double width, double height) {
		setContext();

		x+=0.5;
		y+=0.5;

		glBegin(GL_LINE_LOOP);
		glColor4f(_strokeColor.red, _strokeColor.green, _strokeColor.blue, _strokeColor.alpha);
		glLineWidth(_pen.width);
		glVertex3f(x, y, 0);
		glVertex3f(x+width-1, y, 0);
		glVertex3f(x+width-1, y+height-1, 0);
		glVertex3f(x, y+height-1, 0);
		glEnd();
		_unsetContext();
	}

	private void _drawRectangle(uint type, double x, double y, double width, double height) {
		glBegin(type);
		glVertex3f(x, y, 0);
		glVertex3f(x+width-1, y, 0);
		glVertex3f(x+width-1, y+height-1, 0);
		glVertex3f(x, y+height-1, 0);
		glEnd();
	}

	void fillRectangle(double x, double y, double width, double height) {
		setContext();
		x+=0.5;
		y+=0.5;

		if (_antialias) {
			_initMask();

			// Draw to the stencil mask
			_drawRectangle(GL_QUADS, x, y, width, height);

			_useMask();
			glEnable(GL_LINE_SMOOTH);
			glHint(GL_LINE_SMOOTH_HINT, GL_NICEST);

			glColor4f(_fillColor.red, _fillColor.green, _fillColor.blue, _fillColor.alpha);
			_drawRectangle(GL_LINE_LOOP, x, y, width, height);

			glDisable(GL_LINE_SMOOTH);

			_revertMask();

			// Fill in the rest
			// A single quad to cover the entire area
			glBegin(GL_QUADS);
			glVertex3f(x-1, y-1, 0.0);
			glVertex3f(x+width+2, y-1, 0.0);
			glVertex3f(x+width+2, y+_height+2, 0.0);
			glVertex3f(x-1, y+height+2, 0.0);
			glEnd();

			_uninitMask();
		}
		else {
			glColor4f(_fillColor.red, _fillColor.green, _fillColor.blue, _fillColor.alpha);
			_drawRectangle(GL_QUADS, x, y, width, height);
		}

		_unsetContext();
	}

	private void _drawQuadraticShader(GLenum type, double x1, double y1, double x2, double y2, double x3, double y3) {
		glEnable(GL_FRAGMENT_PROGRAM_ARB);
		glBindProgramARBPtr(GL_FRAGMENT_PROGRAM_ARB, _quadraticShader);

		glColor4f(_fillColor.red, _fillColor.green, _fillColor.blue, _fillColor.alpha);

		double minX = x1;
		if (x2 < minX) { minX = x2; }
		if (x3 < minX) { minX = x3; }

		double minY = y1;
		if (y2 < minY) { minY = y2; }
		if (y3 < minY) { minY = y3; }

		double maxX = x1;
		if (x2 > maxX) { maxX = x2; }
		if (x3 > maxX) { maxX = x3; }

		double maxY = y1;
		if (y2 > maxY) { maxY = y2; }
		if (y3 > maxY) { maxY = y3; }

		double w = maxX - minX;
		double h = maxY - minY;

		glBegin(type);
		glTexCoord2f(0, 0);
		glVertex3f(x1, y1, 0);
		glTexCoord2f(1, 1);
		glVertex3f(x2, y2, 0);
		glTexCoord2f(0.5, 0);
		glVertex3f(x3, y3, 0);
		glEnd();

		glDisable(GL_FRAGMENT_PROGRAM_ARB);
	}

	private void _drawQuadratic(uint type, double x1, double y1, double x2, double y2, double x3, double y3) {
		static const int MAX_TESSELATIONS = 30;

//		glBegin(type);

		double t;
		double t_inv;

		double qx_1, qx_2, qy_1, qy_2;
		double bx, by;

		for(int k = 0; k < MAX_TESSELATIONS; k++) {
			t = cast(double)k / cast(double)(MAX_TESSELATIONS-1);
			t_inv = 1 - t;

			qx_1 = ((x3 - x1) * t) + x1;
			qy_1 = ((y3 - y1) * t) + y1;

			qx_2 = ((x3 - x2) * t_inv) + x2;
			qy_2 = ((y3 - y2) * t_inv) + y2;

			bx = ((qx_2 - qx_1) * t) + qx_1;
			by = ((qy_2 - qy_1) * t) + qy_1;

			drawEllipse(bx-5, by-5, 10, 10);
//			glVertex3f(bx, by, 0);
		}
//		glEnd();
	}

	void drawQuadratic(double x1, double y1, double x2, double y2, double x3, double y3) {
		setContext();

		x1+=0.5;
		y1+=0.5;
		x2+=0.5;
		y2+=0.5;
		x3+=0.5;
		y3+=0.5;

		// SHADERS
		static const bool DJEHUTY_USE_SHADERS = false;
		static if (DJEHUTY_USE_SHADERS) {
			_drawQuadraticShader(x1,y1,x2,y2,x3,y3);
		}
		else {
			// No shaders... use tesselation

			if (_antialias) {
				_initMask();

				// Draw to the stencil mask
				_drawQuadratic(GL_POLYGON, x1, y1, x2, y2, x3, y3);

				_useMask();
				glEnable(GL_LINE_SMOOTH);
				glHint(GL_LINE_SMOOTH_HINT, GL_NICEST);

				glColor4f(_fillColor.red, _fillColor.green, _fillColor.blue, _fillColor.alpha);
				_drawQuadratic(GL_LINE_LOOP, x1, y1, x2, y2, x3, y3);

				glDisable(GL_LINE_SMOOTH);

				_revertMask();

				// Fill in the rest
				// A single triangle to cover the entire area
				glBegin(GL_TRIANGLES);
				glVertex3f(x1, y1, 0.0);
				glVertex3f(x2, y2, 0.0);
				glVertex3f(x3, y3, 0.0);
				glEnd();

				_uninitMask();
			}
			else {
				glColor4f(_fillColor.red, _fillColor.green, _fillColor.blue, _fillColor.alpha);
				_drawQuadratic(GL_POLYGON, x1, y1, x2, y2, x3, y3);
			}

			glColor4f(_fillColor.red, _fillColor.green, _fillColor.blue, _fillColor.alpha);

		}
		_unsetContext();
	}

	// Rounded Rectangles

	void drawRoundedRectangle(double x, double y, double width, double height, double cornerWidth, double cornerHeight, double sweep) {
		setContext();
		Path tempPath = new Path();
		tempPath.addRoundedRectangle(x, y, width, height, cornerWidth, cornerHeight, sweep);

		drawPath(tempPath);
		_unsetContext();
	}

	void strokeRoundedRectangle(double x, double y, double width, double height, double cornerWidth, double cornerHeight, double sweep) {
		setContext();
		Path tempPath = new Path();
		tempPath.addRoundedRectangle(x, y, width, height, cornerWidth, cornerHeight, sweep);

		strokePath(tempPath);
		_unsetContext();
	}

	void fillRoundedRectangle(double x, double y, double width, double height, double cornerWidth, double cornerHeight, double sweep) {
		setContext();
		Path tempPath = new Path();
		tempPath.addRoundedRectangle(x, y, width, height, cornerWidth, cornerHeight, sweep);

		fillPath(tempPath);
		_unsetContext();
	}

	// Contours

	private void _drawContour(GLuint type, Coord[] vertices) {
		glBegin(type);
		foreach(vertex; vertices) {
			glVertex3f(vertex.x, vertex.y, 0);
		}
		glEnd();
	}

	void drawContour(Contour contour) {
		setContext();

		Triangle[] triangles = contour.tessellate();
		Coord[] vertices = contour.compose();
		Coord last;
		bool first = true;

		/*
		foreach(vertex; vertices) {
			drawEllipse(vertex.x-1.25, vertex.y-1.25, 2.5, 2.5);
			if (!first) {
				drawLine(vertex.x, vertex.y, last.x, last.y);
			}
			first = false;
			last = vertex;
		}
		if (vertices.length > 0) {
			drawLine(last.x, last.y, vertices[0].x, vertices[0].y);
		}*/

		setContext();
		if (_antialias) {
			_initMask();

			// Draw to the stencil mask
			_drawContour(GL_POLYGON, vertices);

			_useMask();
			glEnable(GL_LINE_SMOOTH);
			glHint(GL_LINE_SMOOTH_HINT, GL_NICEST);

			glColor4f(_fillColor.red, _fillColor.green, _fillColor.blue, _fillColor.alpha);
			_drawContour(GL_LINE_LOOP, vertices);

			glDisable(GL_LINE_SMOOTH);

			_revertMask();

			// Fill in the rest
			// A single quad to cover the entire area
			glBegin(GL_QUADS);
			glVertex3f(0, 0, 0.0);
			glVertex3f(width, 0, 0.0);
			glVertex3f(width, height, 0.0);
			glVertex3f(0, height, 0.0);
			glEnd();

			_uninitMask();
		}
		else {
			glColor4f(_fillColor.red, _fillColor.green, _fillColor.blue, _fillColor.alpha);
			_drawContour(GL_TRIANGLES, vertices);
		}
/*
		glColor4f(1,1,0,1);
		glBegin(GL_TRIANGLES);
		foreach(triangle; triangles) {
			foreach(point; triangle.points) {
				glVertex3f(point.x, point.y, 0);
			}
		}
		glEnd();
		*/

/*		foreach(triangle; triangles) {
			drawLine(triangle.points[0].x, triangle.points[0].y,
					triangle.points[1].x, triangle.points[1].y);
			drawLine(triangle.points[0].x, triangle.points[0].y,
					triangle.points[2].x, triangle.points[2].y);
			drawLine(triangle.points[1].x, triangle.points[1].y,
					triangle.points[2].x, triangle.points[2].y);
		}*/

		_unsetContext();
	}

	// Glyphs

	void _drawRegion(Triangle[] triangles) {
		glBegin(GL_TRIANGLES);
		foreach(triangle; triangles) {
			foreach(pt; triangle.points) {
				glVertex3f(pt.x, pt.y, 0);
			}
		}
		glEnd();
	}

	void _strokeRegion(Contour[] contours) {
		foreach(contour; contours) {
			glBegin(GL_LINE_LOOP);
			foreach(vertex; contour.compose()) {
				glVertex3f(vertex.x, vertex.y, 0);
			}
			glEnd();
		}
	}

	void strokeRegion(Region region) {
		setContext();
		glColor4f(_strokeColor.red, _strokeColor.green, _strokeColor.blue, _strokeColor.alpha);
		_strokeRegion(region.contours);
		_unsetContext();
	}

	void drawRegion(Region region) {
		setContext();

		// Tessellate
		Triangle[] triangles = region.tessellate();

		// Draw
		if (_antialias) {
			_initMask();

			// Draw to the stencil mask
			_drawRegion(triangles);

			_useMask();
			glEnable(GL_LINE_SMOOTH);
			glHint(GL_LINE_SMOOTH_HINT, GL_NICEST);

			glColor4f(_fillColor.red, _fillColor.green, _fillColor.blue, _fillColor.alpha);
			_strokeRegion(region.contours);

			glDisable(GL_LINE_SMOOTH);

			_revertMask();

			// Fill in the rest
			// A single quad to cover the entire area
			glBegin(GL_QUADS);
			glVertex3f(0, 0, 0.0);
			glVertex3f(width, 0, 0.0);
			glVertex3f(width, height, 0.0);
			glVertex3f(0, height, 0.0);
			glEnd();

			_uninitMask();
		}
		else {
			glColor4f(_fillColor.red, _fillColor.green, _fillColor.blue, _fillColor.alpha);
			_drawRegion(triangles);
		}

/*
		foreach(triangle; triangles) {
			drawLine(triangle.points[0].x, triangle.points[0].y,
					triangle.points[1].x, triangle.points[1].y);
			drawLine(triangle.points[0].x, triangle.points[0].y,
					triangle.points[2].x, triangle.points[2].y);
			drawLine(triangle.points[1].x, triangle.points[1].y,
					triangle.points[2].x, triangle.points[2].y);
		}

		foreach(triangle; triangles) {
			foreach(point; triangle.points) {
				drawEllipse(point.x - 3, point.y - 3, 6, 6);
			}
		}*/

		glColor4f(_strokeColor.red, _strokeColor.green, _strokeColor.blue, _strokeColor.alpha);
		_strokeRegion(region.contours);

		_unsetContext();
	}

	// Paths

	void drawPath(Path path) {
		setContext();

		Curve[] curves = path.curves;

		foreach(curve; curves) {
			if (curve.controls.length == 1) {
				drawQuadratic(
				  curve.start.x, curve.start.y,
				  curve.end.x, curve.end.y,
				  curve.controls[0].x, curve.controls[0].y
				);
			}
			else if (curve.controls.length == 2) {
				/*drawCubic(
				  curve.start.x, curve.start.y,
				  curve.end.x, curve.end.y,
				  curve.controls[0].x, curve.controls[0].y,
				  curve.controls[1].x, curve.controls[1].y
				);*/
			}
			else {
				drawLine(
				  curve.start.x, curve.start.y,
				  curve.end.x, curve.end.y
				);
			}
		}

		_unsetContext();
	}

	void strokePath(Path path) {
		setContext();
		_unsetContext();
	}

	void fillPath(Path path) {
		setContext();
		_unsetContext();
	}

	// Ellipses

	void drawEllipse(double x, double y, double width, double height) {
		setContext();
		fillEllipse(x+(_pen.width/2), y+(_pen.width/2), width-_pen.width, height-_pen.width);
		strokeEllipse(x, y, width, height);
		_unsetContext();
	}

	void strokeEllipse(double x, double y, double width, double height) {
		setContext();
		x+=0.5;
		y+=0.5;

		width--;
		height--;
		x--;
		y--;
		width /= 2;
		height /= 2;
		x += width;
		y += height;

		// The stroke path should be centered on the edge of the filled path
		width+=_pen.width/2.0;
		height+=_pen.width/2.0;

		if (_antialias) {
			_initMask();

			// Draw to the stencil mask
			_drawRing(GL_TRIANGLE_STRIP, x, y, width, height, _pen.width());

			_useMask();

			glEnable(GL_LINE_SMOOTH);
			glHint(GL_LINE_SMOOTH_HINT, GL_NICEST);

			glColor4f(_strokeColor.red, _strokeColor.green, _strokeColor.blue, _strokeColor.alpha);
			_drawRing(GL_LINE_LOOP, x, y, width, height, _pen.width());

			glDisable(GL_LINE_SMOOTH);

			_revertMask();

			glBegin (GL_QUADS);
			glVertex3f(0, 0, 0.0);
			glVertex3f(_width, 0, 0.0);
			glVertex3f(_width, _height, 0.0);
			glVertex3f(0, _height, 0.0);
			glEnd ();

			_uninitMask();
		}
		else {
			glColor4f(_strokeColor.red, _strokeColor.green, _strokeColor.blue, _strokeColor.alpha);
			_drawRing(GL_TRIANGLE_STRIP, x, y, width, height, _pen.width());
		}
		_unsetContext();
	}

	void fillEllipse(double x, double y, double width, double height) {
		x+=0.5;
		y+=0.5;

		width--;
		height--;
		x--;
		y--;
		width /= 2;
		height /= 2;
		x += width;
		y += height;

		if (_antialias) {
			_initMask();

			// Draw to the stencil mask
			_drawEllipse(GL_POLYGON, x, y, width, height);

			_useMask();

			glEnable(GL_LINE_SMOOTH);
			glHint(GL_LINE_SMOOTH_HINT, GL_NICEST);

			glColor4f(_fillColor.red, _fillColor.green, _fillColor.blue, _fillColor.alpha);
			_drawEllipse(GL_LINE_LOOP, x, y, width, height);

			glDisable(GL_LINE_SMOOTH);

			_revertMask();

			glBegin (GL_QUADS);
			glVertex3f(0, 0, 0.0);
			glVertex3f(_width, 0, 0.0);
			glVertex3f(_width, _height, 0.0);
			glVertex3f(0, _height, 0.0);
			glEnd ();

			_uninitMask();
		}
		else {
			glColor4f(_fillColor.red, _fillColor.green, _fillColor.blue, _fillColor.alpha);
			_drawEllipse(GL_POLYGON, x, y, width, height);
		}
		_unsetContext();
	}

	// Text

	void drawString(string text, double x, double y) {
		//		GraphicsScaffold.drawText(&_pfvars, x, y, text);
	}

	void strokeString(string text, double x, double y) {
		//		GraphicsScaffold.strokeText(&_pfvars, x, y, text);
	}

	void fillString(string text, double x, double y) {
		//		GraphicsScaffold.fillText(&_pfvars, x, y, text);
	}

	// State

	private long _stackCount = 0;

	long save() {
		setContext();
		glMatrixMode(GL_MODELVIEW);
		glPushMatrix();
		_stackCount++;
		_unsetContext();
		return _stackCount;
	}

	void restore(long state) {
		// Inspect _stackCount and state
		setContext();
		glMatrixMode(GL_MODELVIEW);
		while(_stackCount != state && _stackCount > 0) {
			glPopMatrix();
			_stackCount--;
		}
		_unsetContext();
	}

	// Image

	void drawCanvas(Canvas canvas, double x, double y) {
		setContext();

		x += 0.5;
		y += 0.5;

		
		glEnable(GL_TEXTURE_2D);

		glBindTexture(GL_TEXTURE_2D, canvas.tex);

		glColor4f(1.0, 1.0, 1.0, 1.0);

		glBegin(GL_QUADS);
		glTexCoord2f(0, 0);
		glVertex3f(x, y+canvas.height-1, 0);
		glTexCoord2f(1, 0);
		glVertex3f(x+canvas.width-1, y+canvas.height-1, 0);
		glTexCoord2f(1, 1);
		glVertex3f(x+canvas.width-1, y, 0);
		glTexCoord2f(0, 1);
		glVertex3f(x, y, 0);
		glEnd();

		glBindTexture(GL_TEXTURE_2D, 0);

		glDisable(GL_TEXTURE_2D);
		// */

		//		GraphicsScaffold.drawCanvas(&_pfvars, this, x, y, canvas.platformVariables, canvas);
	}

	// Clipping

	void clipRectangle(Rect rect) {
		clipRectangle(rect.left, rect.top, rect.right - rect.left, rect.bottom - rect.top);
	}

	void clipRectangle(double x, double y, double width, double height) {
		setContext();

		x+=0.5;
		y+=0.5;

		glStencilFunc(GL_EQUAL, 0x10, 0x11);
		glStencilOp(GL_REPLACE, GL_KEEP, GL_KEEP);
		glColorMask(GL_FALSE, GL_FALSE, GL_FALSE, GL_FALSE);

		_drawRectangle(GL_QUADS, 0.5, 0.5, x, _height+0.5);
		_drawRectangle(GL_QUADS, x, 0.5, _width+0.5, y);
		_drawRectangle(GL_QUADS, x+width, y, _width+0.5, _height+0.5);
		_drawRectangle(GL_QUADS, x, y+height, x+width, _height+0.5);

		glStencilFunc(GL_EQUAL, 0x00, 0x11);
		glStencilOp(GL_KEEP, GL_KEEP, GL_KEEP);
		glColorMask(GL_TRUE, GL_TRUE, GL_TRUE, GL_TRUE);

		_unsetContext();//*/
	}

	void clipPath(Path path) {
		//		GraphicsScaffold.clipPath(&_pfvars, path.platformVariables);
	}

	void clipReset() {
		setContext();
		glClearStencil(0);
		glClear(GL_STENCIL_BUFFER_BIT);
		_unsetContext();
	}

	// Transforms

	void transformReset() {
		setContext();
		glMatrixMode(GL_MODELVIEW);
		glLoadIdentity();
		_unsetContext();
	}

	void transformTranslate(double x, double y) {
		setContext();
		glMatrixMode(GL_MODELVIEW);
		glTranslated(x, y, 0.0);
		_unsetContext();
	}

	void transformScale(double x, double y) {
		setContext();
		glMatrixMode(GL_MODELVIEW);
		glScaled(x, y, 1.0);
		_unsetContext();
	}

	void transformRotate(double angle) {
		setContext();
		glMatrixMode(GL_MODELVIEW);
		glRotated(angle*180.0/3.141529, 0, 0, 1);
		_unsetContext();
	}

	// Properties

	void antialias(bool value) {
		_antialias = value;
	}

	bool antialias() {
		return _antialias;
	}

	void brush(Brush value) {
		_brush = value;
		_fillColor = value.color;
	}

	Brush brush() {
		return _brush;
	}

	void pen(Pen value) {
		_pen = value;
		_strokeColor = value.color;
	}

	Pen pen() {
		return _pen;
	}

	void font(Font value) {
		_font = value;
		//		GraphicsScaffold.setFont(&_pfvars, value.platformVariables);
	}

	Font font() {
		return _font;
	}

	// Platform Bullshits

	CanvasPlatformVars* platformVariables() {
		return &_pfvars;
	}

	uint rgbaTouint(uint r, uint g, uint b, uint a) {
		return CanvasRGBAToInt32(_forcenopremultiply,&_pfvars,r,g,b,a);
	}

	uint rgbTouint(uint r, uint g, uint b) {
		return CanvasRGBAToInt32(&_pfvars,r,g,b);
	}
}
