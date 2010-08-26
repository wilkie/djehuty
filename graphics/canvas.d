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
	static HDC _hDC;

	static void _init() {
		if (_glInited) {
			return;
		}

		// Initialize OpenGL
		_glInited = true;

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
			8,                                          // No Stencil Buffer
			0,                                          // No Auxiliary Buffer
			PFD_MAIN_PLANE,                             // Main Drawing Layer
			0,                                          // Reserved
			0, 0, 0                                     // Layer Masks Ignored
		};

		putln("pixel format");

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
		auto hWnd = CreateWindowExW(0,
		className.ptr, "\0"w.ptr,
		WS_OVERLAPPED,
		0, 0, cast(int)0, cast(int)0,
		null, null, null, null);

		// Get a dummy device context
		_hDC = GetDC(hWnd);

		putln("choosepixel");
		// Set up the pixel format
		if ((PixelFormat=ChoosePixelFormat(_hDC,&pfd)) == 0) { // Did Windows Find A Matching Pixel Format?
			putln("Can't Find A Suitable PixelFormat.");
			return ; // Return FALSE
		}

		putln("setpixel");
		if(SetPixelFormat(_hDC,PixelFormat,&pfd) == 0) { // Are We Able To Set The Pixel Format?
			putln("Can't Set The PixelFormat.");
			return ; // Return FALSE
		}

		putln("createcontext");
		// Create a faux-GL context
		if ((_hRC=wglCreateContext(_hDC)) == null) { // Are We Able To Get A Rendering Context?
			putln("Can't Create A GL Rendering Context.");
			return ; // Return FALSE
		}

		putln("makecurrent");
		// Make this the current GL context
		if(wglMakeCurrent(_hDC,_hRC) == 0) { // Try To Activate The Rendering Context
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

		alias void (PFNGLRENDERBUFFERSTORAGEMULTISAMPLEEXTPROC) (GLenum target, GLsizei samples, GLenum internalformat, GLsizei width, GLsizei height);
	}

public:

	this(int width, int height) {
		putln("initing");
		_init();
		putln("init done");

		_width = width;
		_height = height;

		if (width != 500 || height != 500) {
			return;
		}

		putln("create context");
		// Create a faux-GL context
		if ((_hRC=wglCreateContext(_hDC)) == null) { // Are We Able To Get A Rendering Context?
			putln("Can't Create A GL Rendering Context.");
			return ; // Return FALSE
		}

		putln("make current");
		// Make this the current GL context
		if(wglMakeCurrent(_hDC,_hRC) == 0) { // Try To Activate The Rendering Context
			putln("Can't Activate The GL Rendering Context.");
			//return ; // Return FALSE
		}

		putln("setup");

		auto ext = cast(char*)glGetString(GL_EXTENSIONS);
		if (ext !is null) {
			auto extstr = ext[0..strlen(ext)];
			putln("extensions: ", extstr);
		}

		GLuint fb, color_rb, depth_rb;

		// RGBA8 RenderBuffer
		glGenFramebuffersEXTPtr(1, &fb);
		glBindFramebufferEXTPtr(GL_FRAMEBUFFER_EXT, fb);
		// Create and attach a color buffer
		glGenRenderbuffersEXTPtr(1, &color_rb);
		// We must bind color_rb before we call glRenderbufferStorageEXT
		glBindRenderbufferEXTPtr(GL_RENDERBUFFER_EXT, color_rb);
		// The storage format is RGBA8
		glRenderbufferStorageEXTPtr(GL_RENDERBUFFER_EXT, GL_RGBA8, width, height);
//		glRenderbufferStorageMultisampleEXTPtr(GL_RENDERBUFFER_EXT, 4, GL_RGBA8, width, height);
		// Attach color buffer to FBO
		glFramebufferRenderbufferEXTPtr(GL_FRAMEBUFFER_EXT, GL_COLOR_ATTACHMENT0_EXT,
			GL_RENDERBUFFER_EXT, color_rb);
		// -------------------------
	//	glGenRenderbuffersEXTPtr(1, &depth_rb);
	//	glBindRenderbufferEXTPtr(GL_RENDERBUFFER_EXT, depth_rb);
	//	glRenderbufferStorageEXTPtr(GL_RENDERBUFFER_EXT, GL_DEPTH_COMPONENT24,
	//		width, height);
		// -------------------------
		// Attach depth buffer to FBO
//		glFramebufferRenderbufferEXTPtr(GL_FRAMEBUFFER_EXT, GL_DEPTH_ATTACHMENT_EXT,
	//		GL_RENDERBUFFER_EXT, depth_rb);
		// -------------------------
		// Does the GPU support current FBO configuration?
		GLenum status;
status=glCheckFramebufferStatusEXTPtr(GL_FRAMEBUFFER_EXT);
		switch(status)
  {
  case GL_FRAMEBUFFER_COMPLETE_EXT:
  putln("complete");
  break;
  case GL_FRAMEBUFFER_UNSUPPORTED_EXT:
  //Choose different formats
  putln("Framebuffer object format is unsupported by the video hardware. (GL_FRAMEBUFFER_UNSUPPORTED_EXT)(FBO - 820)");
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

		// -------------------------
		// and now you can render to the FBO (also called RenderBuffer)
		glBindFramebufferEXTPtr(GL_FRAMEBUFFER_EXT, fb);
				putln("good. i");

		glEnable(GL_ALPHA);
		glEnable(GL_BLEND);
		glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
//		glBlendFunc(GL_SRC_COLOR, GL_ONE);
		//glBlendFunc(GL_SRC_ALPHA_SATURATE, GL_ONE);

		glDisable(GL_DEPTH_TEST);
		glDisable(GL_LIGHTING);

//		glDepthFunc(GL_EQUAL);
//		glDepthMask(GL_TRUE);

//		glShadeModel(GL_SMOOTH); // Enable smooth shading
		glViewport(0, 0, width, height);

//		glHint(GL_PERSPECTIVE_CORRECTION_HINT, GL_NICEST);
		glHint(GL_LINE_SMOOTH_HINT, GL_NICEST);
		glHint(GL_POLYGON_SMOOTH_HINT, GL_NICEST);

		// Reset the current viewport
		glMatrixMode(GL_PROJECTION); // Select the projection matrix
		glLoadIdentity(); // Reset the projection matrix

		// Calculate the aspect ratio of the window
		glOrtho(0, width, height, 0, -1, 1);

		glMatrixMode(GL_MODELVIEW); // Select the modelview matrix
		glLoadIdentity(); // Reset the modelview matrix

		this.clear();
		// Clear screen and depth buffer
		glLoadIdentity(); // Reset the current modelview matrix

		// RENDER
		glLineWidth(1.0);
//		this.antialias = true;
		this.brush = new Brush(Color.fromRGBA(0, 1, 0, 1.0));
		this.pen = new Pen(Color.fromRGBA(1, 0, 0, 1.0), 3);
		this.drawRectangle(0, 0, 100, 100);
		this.drawRectangle(200, 200, 100, 100);
		this.strokeRectangle(300,300,100,100);

		this.brush = new Brush(Color.fromRGBA(1.0, 1.0, 1.0, 0.9));
		this.fillEllipse(120, 20, 100, 200);
		this.drawEllipse(300, 200, 100, 200);
		this.strokeEllipse(400, 300, 100, 200);

//		this.antialias = true;
		this.pen = new Pen(Color.fromRGBA(1, 0, 1, 1), 5);
		this.drawLine(0,0,499,499);

//		this.antialias = false;
		this.brush = new Brush(Color.fromRGBA(1.0, 1.0, 1.0, 0.2));
		this.pen = new Pen(Color.fromRGBA(0, 0, 0, 1), 5);
		this.drawRectangle(0, 0, 500, 500);

		// Capture
		ubyte[] pPixelData = new ubyte[](width * height * 4);
		glReadPixels(0, 0, width, height, GL_BGRA, GL_UNSIGNED_BYTE,
			pPixelData.ptr);

		auto windhDC = GetDC(null);
		auto hBMP = CreateCompatibleBitmap(windhDC, width, height);
		auto hDC = CreateCompatibleDC(windhDC);
		BITMAPINFO bmpInfo;
		bmpInfo.bmiHeader.biSize = BITMAPINFOHEADER.sizeof;
		bmpInfo.bmiHeader.biWidth = width;
		bmpInfo.bmiHeader.biHeight = height;
		bmpInfo.bmiHeader.biPlanes = 1;
		bmpInfo.bmiHeader.biBitCount = 32;
		bmpInfo.bmiHeader.biCompression = BI_RGB;
		SetDIBits(hDC, hBMP, 0, height, pPixelData.ptr, &bmpInfo, DIB_RGB_COLORS);
		SelectObject(hDC, hBMP);
		DeleteObject(hBMP);
		ReleaseDC(null, windhDC);

		_pfvars.testDC = hDC;
		putln("dah. ", _pfvars.testDC, " at ", width, " x ", height);
	}

	~this() {
	}

	void resize(int width, int height) {
		_width = width;
		_height = height;
	}

	void clear() {
		glClearColor(0, 0, 0, 0);
		glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
	}

	int width() {
		return _width;
	}

	int height() {
		return _height;
	}

	// Lines

	void drawLine(double x1, double y1, double x2, double y2) {
		glBegin(GL_LINES);
		glColor4f(_strokeColor.red, _strokeColor.green, _strokeColor.blue, _strokeColor.alpha);
		glVertex3f(x1, y1, 0);
		glVertex3f(x2, y2, 0);
		glEnd();
	}

	// Rectangles

	void drawRectangle(double x, double y, double width, double height) {
		fillRectangle(x, y, width, height);
		strokeRectangle(x, y, width, height);
	}

	void strokeRectangle(double x, double y, double width, double height) {
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
	}

	void fillRectangle(double x, double y, double width, double height) {
		x+=0.5;
		y+=0.5;

		glBegin(GL_QUADS);
		glColor4f(_fillColor.red, _fillColor.green, _fillColor.blue, _fillColor.alpha);
		glVertex3f(x, y, 0);
		glVertex3f(x+width-1, y, 0);
		glVertex3f(x+width-1, y+height-1, 0);
		glVertex3f(x, y+height-1, 0);
		glEnd();
	}

	// Rounded Rectangles

	void drawRoundedRectangle(double x, double y, double width, double height, double cornerWidth, double cornerHeight, double sweep) {
		Path tempPath = new Path();
		tempPath.addRoundedRectangle(x, y, width, height, cornerWidth, cornerHeight, sweep);

//		drawPath(tempPath);
	}

	void strokeRoundedRectangle(double x, double y, double width, double height, double cornerWidth, double cornerHeight, double sweep) {
		Path tempPath = new Path();
		tempPath.addRoundedRectangle(x, y, width, height, cornerWidth, cornerHeight, sweep);

//		strokePath(tempPath);
	}

	void fillRoundedRectangle(double x, double y, double width, double height, double cornerWidth, double cornerHeight, double sweep) {
		Path tempPath = new Path();
		tempPath.addRoundedRectangle(x, y, width, height, cornerWidth, cornerHeight, sweep);

//		fillPath(tempPath);
	}

	// Paths

	void drawPath(Path path) {
//		GraphicsScaffold.drawPath(&_pfvars, path.platformVariables);
	}

	void strokePath(Path path) {
//		GraphicsScaffold.strokePath(&_pfvars, path.platformVariables);
	}

	void fillPath(Path path) {
//		GraphicsScaffold.fillPath(&_pfvars, path.platformVariables);
	}

	// Ellipses

	void drawEllipse(double x, double y, double width, double height) {
		fillEllipse(x, y, width, height);
		strokeEllipse(x, y, width, height);
	}

	void strokeEllipse(double x, double y, double width, double height) {
		x+=0.5;
		y+=0.5;

		glBegin(GL_LINE_LOOP);
		glColor4f(_strokeColor.red, _strokeColor.green, _strokeColor.blue, _strokeColor.alpha);
		static const double n = 100.0;
		width--;
		height--;
		x--;
		y--;
		width /= 2;
		height /= 2;
		x += width;
		y += height;
		for(double t = 0; t <= TWOPI; t += TWOPI/n) {
			glVertex3f(x + (width * cos(t)), y + (height * sin(t)),0);
		}
		glEnd();
	}

	void fillEllipse(double x, double y, double width, double height) {
		x+=0.5;
		y+=0.5;

		glBegin(GL_POLYGON);
		glColor4f(_fillColor.red, _fillColor.green, _fillColor.blue, _fillColor.alpha);
		static const double n = 100.0;
		width--;
		height--;
		x--;
		y--;
		width /= 2;
		height /= 2;
		x += width;
		y += height;
		for(double t = 0; t <= TWOPI; t += TWOPI/n) {
			glVertex3f(x + (width * cos(t)), y + (height * sin(t)),0);
		}
		glEnd();
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

	long save() {
		long ret;
//		GraphicsScaffold.save(&_pfvars, &ret);
		return ret;
	}

	void restore(long state) {
//		GraphicsScaffold.restore(&_pfvars, state);
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
//		GraphicsScaffold.resetWorld(&_pfvars);
	}

	void transformTranslate(double x, double y) {
//		GraphicsScaffold.translateWorld(&_pfvars, x, y);
	}

	void transformScale(double x, double y) {
//		GraphicsScaffold.scaleWorld(&_pfvars, x, y);
	}

	void transformRotate(double angle) {
//		GraphicsScaffold.rotateWorld(&_pfvars, angle);
	}

	// Properties

	void antialias(bool value) {
		_antialias = value;
		if (_antialias) {
			glEnable(GL_LINE_SMOOTH);
			glEnable(GL_POLYGON_SMOOTH);
			glHint(GL_LINE_SMOOTH_HINT, GL_NICEST);
			glHint(GL_POLYGON_SMOOTH_HINT, GL_NICEST);
		}
		else {
			glDisable(GL_LINE_SMOOTH);
			glDisable(GL_POLYGON_SMOOTH);
		}
//		GraphicsScaffold.setAntialias(&_pfvars, value);
	}

	bool antialias() {
		return _antialias;
	}

	void brush(Brush value) {
		_brush = value;
		_fillColor = value.color();
//		GraphicsScaffold.setBrush(&_pfvars, value.platformVariables);
	}

	Brush brush() {
		return _brush;
	}

	void pen(Pen value) {
		_pen = value;
		_strokeColor = value.color;
//		GraphicsScaffold.setPen(&_pfvars, value.platformVariables);
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