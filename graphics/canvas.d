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

	static PFNGLBLENDFUNCSEPARATEPROC glBlendFuncSeparatePtr;
	static PFNGLBLENDEQUATIONSEPARATEPROC glBlendEquationSeparatePtr;

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

		ReleaseDC(_hWnd, dummyhDC);
	}

	static bool _inited[Thread];
	static void _threadInit() {
//		if (Thread.current in _inited) {
	//		return;
		//}
	}

	void _initMask() {
		glEnable(GL_STENCIL_TEST);
		glStencilMask(0x01);
		glStencilOp(GL_KEEP, GL_KEEP, GL_INVERT);
		glStencilFunc(GL_ALWAYS, 0, ~0);
		glColorMask(GL_FALSE, GL_FALSE, GL_FALSE, GL_FALSE);
	}

	void _uninitMask() {
		glDisable (GL_STENCIL_TEST);
	}

	void _useMask() {
		glColorMask (GL_TRUE, GL_TRUE, GL_TRUE, GL_TRUE);

		glStencilFunc (GL_EQUAL, 0x00, 0x01);
		glStencilOp (GL_KEEP, GL_KEEP, GL_KEEP);
	}

	void _revertMask() {
		glStencilFunc (GL_EQUAL, 0x01, 0x01);

		// Interestingly, we can clear the stencil at the same time
		// We might as well.
		glStencilOp (GL_ZERO, GL_ZERO, GL_ZERO);
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

		auto dummyhDC = GetDC(_hWnd);
		// Create a faux-GL context
		if ((_hRC=wglCreateContext(dummyhDC)) == null) { // Are We Able To Get A Rendering Context?
			putln("Can't Create A GL Rendering Context. (constructor)");
			return ; // Return FALSE
		}
		ReleaseDC(_hWnd, dummyhDC);

		setContext();

		putln("setup ", width, " x ", height);

		auto ext = cast(char*)glGetString(GL_EXTENSIONS);
		if (ext !is null) {
			auto extstr = ext[0..strlen(ext)];
			putln("extensions: ", extstr);
		}

		// This identifies the framebuffer object.
		GLuint fb;

		// Yay for the many render buffers that we need.
		GLuint color_rb, depth_rb, stencil_rb, packed_rb;

		// RGBA8 RenderBuffer
		glGenFramebuffersEXTPtr(1, &fb);
		glBindFramebufferEXTPtr(GL_FRAMEBUFFER_EXT, fb);

		// Create and attach a color buffer
		glGenRenderbuffersEXTPtr(1, &color_rb);

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

		// Some video cards need a depth buffer with a stencil buffer.
		// Otherwise, a stencil buffer can just be produced with a simple
		//   GL_STENCIL_INDEX_8 renderbuffer.
		// XXX: should probably check for this extension before I use it.
		glGenRenderbuffersEXTPtr(1, &packed_rb);
		glBindRenderbufferEXTPtr(GL_RENDERBUFFER_EXT, packed_rb);
		glRenderbufferStorageEXTPtr(GL_RENDERBUFFER_EXT, GL_DEPTH_STENCIL_EXT, _width, _height);
		glFramebufferRenderbufferEXTPtr(GL_FRAMEBUFFER_EXT,GL_DEPTH_ATTACHMENT_EXT, GL_RENDERBUFFER_EXT, packed_rb);
		glFramebufferRenderbufferEXTPtr(GL_FRAMEBUFFER_EXT, GL_STENCIL_ATTACHMENT_EXT, GL_RENDERBUFFER_EXT, packed_rb);

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
			break;
		}

		// and now you can render to the FBO (also called RenderBuffer)
		glBindFramebufferEXTPtr(GL_FRAMEBUFFER_EXT, fb);

		glEnable(GL_BLEND);

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

		_unsetContext();

		// Clear the screen.
		this.clear();

		// RENDER

		this.brush = new Brush(Color.fromRGBA(0.0, 1.0, 0.0, 0.5));
		this.pen = new Pen(Color.fromRGBA(0, 0, 0, 1), 1);
		this.drawRectangle(100, 100, 400, 400);
		this.brush = new Brush(Color.fromRGBA(0.0, 0.0, 1.0, 0.5));
		this.drawRectangle(0, 0, 200, 200);

//		this.antialias = true;
		this.brush = new Brush(Color.fromRGBA(0, 1, 0, 1.0));
		this.pen = new Pen(Color.fromRGBA(1, 0, 0, 0.75), 10);
//		this.drawRectangle(1, 1, 100, 100);
	//	this.drawRectangle(200, 200, 100, 100);
		//this.strokeRectangle(300,300,100,100);

		this.brush = new Brush(Color.fromRGBA(1.0, 1.0, 1.0, 0.9));
		this.antialias = false;
//		this.fillEllipse(220, 20, 100, 200);
		this.antialias = true;
		this.fillEllipse(120, 20, 100, 200);
		this.drawEllipse(300, 200, 200, 200);
		this.strokeEllipse(400, 300, 100, 200);

//		this.antialias = true;
		this.pen = new Pen(Color.fromRGBA(1, 0, 1, 1), 5);
		this.drawLine(0,0,499,499);

		this.antialias = true;
		this.pen = new Pen(Color.fromRGBA(1, 0, 1, 1), 5);
		this.drawLine(499,0,0,499);

		// The following gets moved eventually...

		setContext();
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
		if (width == 0 || height == 0) {
			return;
		}

		auto dummyhDC = GetDC(_hWnd);
		while(wglMakeCurrent(dummyhDC,_hRC) == 0) { // Try To Activate The Rendering Context
			Thread.sleep(5);
		}

		ReleaseDC(_hWnd, dummyhDC);
	}

	void clear() {
		setContext();
		glClearColor(0, 0, 0, 0);
		glClear(GL_COLOR_BUFFER_BIT);
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
			glBegin (GL_QUADS);
			glVertex3f(x-1, y-1, 0.0);
			glVertex3f(x+width+2, y-1, 0.0);
			glVertex3f(x+width+2, y+_height+2, 0.0);
			glVertex3f(x-1, y+height+2, 0.0);
			glEnd ();

			_uninitMask();
		}
		else {
			glColor4f(_fillColor.red, _fillColor.green, _fillColor.blue, _fillColor.alpha);
			_drawRectangle(GL_QUADS, x, y, width, height);
		}

		_unsetContext();
	}

	// Rounded Rectangles

	void drawRoundedRectangle(double x, double y, double width, double height, double cornerWidth, double cornerHeight, double sweep) {
		setContext();
		Path tempPath = new Path();
		tempPath.addRoundedRectangle(x, y, width, height, cornerWidth, cornerHeight, sweep);

//		drawPath(tempPath);
		_unsetContext();
	}

	void strokeRoundedRectangle(double x, double y, double width, double height, double cornerWidth, double cornerHeight, double sweep) {
		setContext();
		Path tempPath = new Path();
		tempPath.addRoundedRectangle(x, y, width, height, cornerWidth, cornerHeight, sweep);

//		strokePath(tempPath);
		_unsetContext();
	}

	void fillRoundedRectangle(double x, double y, double width, double height, double cornerWidth, double cornerHeight, double sweep) {
		setContext();
		Path tempPath = new Path();
		tempPath.addRoundedRectangle(x, y, width, height, cornerWidth, cornerHeight, sweep);

//		fillPath(tempPath);
		_unsetContext();
	}

	// Paths

	void drawPath(Path path) {
		setContext();
//		GraphicsScaffold.drawPath(&_pfvars, path.platformVariables);
		_unsetContext();
	}

	void strokePath(Path path) {
		setContext();
//		GraphicsScaffold.strokePath(&_pfvars, path.platformVariables);
		_unsetContext();
	}

	void fillPath(Path path) {
		setContext();
//		GraphicsScaffold.fillPath(&_pfvars, path.platformVariables);
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
//		GraphicsScaffold.drawCanvas(&_pfvars, this, x, y, canvas.platformVariables, canvas);
	}

	// Clipping

	void clipRectangle(Rect rect) {
//		clipRectangle(rect.left, rect.top, rect.right - rect.left, rect.bottom - rect.top);
	}

	void clipRectangle(double x, double y, double width, double height) {
//		GraphicsScaffold.clipRect(&_pfvars, x, y, width, height);
	}

	void clipPath(Path path) {
//		GraphicsScaffold.clipPath(&_pfvars, path.platformVariables);
	}

	void clipReset() {
//		GraphicsScaffold.clipClear(&_pfvars);
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
