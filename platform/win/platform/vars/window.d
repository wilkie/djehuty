/*
 * window.d
 *
 * This module has the structure that is kept with a Window class.
 *
 * Author: Dave Wilkinson
 * Originated: July 22th, 2009
 *
 */

module platform.vars.window;

import binding.win32.windef;
import binding.win32.winnt;
import binding.win32.winbase;
import binding.win32.wingdi;
import binding.win32.winuser;

import core.definitions;
import core.string;
import core.unicode;

import gui.window;

import binding.opengl.gl;
import binding.opengl.glu;

import opengl.window;

import synch.thread;

import scaffold.opengl;

struct WindowPlatformVars {
	HWND hWnd;
	HDC windhDC;

	int hoverTimerSet;

	int doubleClickTimerSet;
	int doubleClickAmount;
	int doubleClickX;
	int doubleClickY;

	HBRUSH brsh;
	HPEN pen;

	HFONT fnt;

	uint oldX;
	uint oldY;

	int oldWidth;
	int oldHeight;

	ulong oldStyle;
	ulong oldExStyle;
	WindowState oldState;

	bool infullscreen;

	bool supress_WM_SIZE;
	bool supress_WM_SIZE_state;
	bool supress_WM_MOVE;

	Thread msgThread;

	uint istyle;
	uint iexstyle;

	HWND parenthWnd;
	void* userData;

	string oldTitle;

	Window windowClass;

	// ----

	// resolution of the timer

	// reset the game timer

	struct _TimeInfo
	{
		long timeLast=0;
		long timeCur=0;

		double timeFactor = 0.0;
		double timeAverages[25] = [0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0];

		int timeAvgCount = 0;
		int timeAvgIndex = 0;

		int timeLast_tick = 0;
	}

	// pointer to the info structure (in the stack space of the thread... SIGH)
	_TimeInfo* tmInfo;


	// ----

	// Deeply routed logic for windows in a file that doesn't need it
	void msgLoop(bool pleaseStop) {
		if (pleaseStop) {
			return;
		}
		
		wstring oldTitleW = Unicode.toUtf16(oldTitle.dup);
		oldTitleW ~='\0';

		while(hWnd is null) {
			hWnd = CreateWindowExW(iexstyle, "djehutyApp\0"w.ptr,oldTitleW.ptr, cast(DWORD)(istyle | WS_CLIPSIBLINGS),
				oldX, oldY, oldWidth, oldHeight, null,
				cast(HMENU) null, null, cast(void*)userData);
		}

		// create the window's view object
		windowClass.onInitialize();

		// call the onAdd() event
		windowClass.onAdd();

		MSG msg;
		while (GetMessageW(&msg, cast(HWND) hWnd, 0, 0)) {
			TranslateMessage(&msg);
			if (msg.message == WM_DESTROY || msg.message == 0) {
				break;
			}
			DispatchMessageW(&msg);
		}
	}



	void gameLoopCallResize() {
		GLWindow glWindow = cast(GLWindow)windowClass;

		glWindow.onDraw(getDeltaTime());

		// Now, we can swap the buffers
		SwapBuffers(windhDC);
	}



	void initTime() {
		long perfFreq;

		// initialize query performance timer
		QueryPerformanceFrequency(&perfFreq);
		tmInfo.timeFactor = cast(double)1.0 / cast(double)perfFreq;
		QueryPerformanceCounter(&tmInfo.timeLast);

		// initialize tick counter
		tmInfo.timeLast_tick = GetTickCount();
	}

	double getDeltaTime() {
		QueryPerformanceCounter(&tmInfo.timeCur);

		double timeSpan = cast(double)(tmInfo.timeCur - tmInfo.timeLast) * tmInfo.timeFactor;

		tmInfo.timeLast = tmInfo.timeCur;

		tmInfo.timeAverages[tmInfo.timeAvgIndex] = timeSpan;

		tmInfo.timeAvgIndex++;

		if (tmInfo.timeAvgCount != 25)
		{
			tmInfo.timeAvgCount++;
		}

		if (tmInfo.timeAvgIndex == tmInfo.timeAvgCount)
		{
			tmInfo.timeAvgIndex = 0;
		}

		timeSpan = tmInfo.timeAverages[0];

		int i;

		for (i=1; i<tmInfo.timeAvgCount; i++)
		{
			timeSpan += tmInfo.timeAverages[i];
		}
		timeSpan /= tmInfo.timeAvgCount;
		//*/
		return timeSpan;

	}


	void gameLoop(bool pleaseStop)
	{
		if (pleaseStop)
		{
			return;
		}

		wstring oldTitleW = Unicode.toUtf16(oldTitle.dup);
		oldTitleW ~='\0';
		
		hWnd = CreateWindowExW(0, "djehutyApp\0"w.ptr,oldTitleW.ptr, istyle ,
			oldX, oldY, oldWidth, oldHeight, null,
			cast(HMENU) null, null, cast(void*)userData);

		assert(hWnd);

		// Create GL context

		HGLRC hRC;

		GLuint PixelFormat;

		if ((windhDC=GetDC(hWnd)) == null)                         // Did We Get A Device Context?
		{
			MessageBoxW(null,"Can't Create A GL Device Context.\0"w.ptr,"ERROR\0"w.ptr,MB_OK|MB_ICONEXCLAMATION);
			return ;                                // Return FALSE
		}

		if ((PixelFormat=ChoosePixelFormat(windhDC,&pfd)) == 0) // Did Windows Find A Matching Pixel Format?
		{
			MessageBoxW(null,"Can't Find A Suitable PixelFormat.\0"w.ptr,"ERROR\0"w.ptr,MB_OK|MB_ICONEXCLAMATION);
			return ;                                // Return FALSE
		}

		if(SetPixelFormat(windhDC,PixelFormat,&pfd) == 0)       // Are We Able To Set The Pixel Format?
		{
			MessageBoxW(null,"Can't Set The PixelFormat.\0"w.ptr,"ERROR\0"w.ptr,MB_OK|MB_ICONEXCLAMATION);
			return ;                                // Return FALSE
		}

		if ((hRC=wglCreateContext(windhDC)) == null)               // Are We Able To Get A Rendering Context?
		{
			MessageBoxW(null,"Can't Create A GL Rendering Context.\0"w.ptr,"ERROR\0"w.ptr,MB_OK|MB_ICONEXCLAMATION);
			return ;                                // Return FALSE
		}

		if(wglMakeCurrent(windhDC,hRC) == 0)                    // Try To Activate The Rendering Context
		{
			MessageBoxW(null,"Can't Activate The GL Rendering Context.\0"w.ptr,"ERROR\0"w.ptr,MB_OK|MB_ICONEXCLAMATION);
			return ;                                // Return FALSE
		}

		// create the window's view object
		windowClass.onInitialize();

		// call the onAdd() event
		windowClass.onAdd();

		_TimeInfo tInfo;

		// O M G... I hate doing this:
		// pointer to the stack allocated array for doing thread stuffs without screwing the pooch somewhere else
		// if I don't have this, I cannot destroy the thread cleanly? I don't know why.
		tmInfo = &tInfo;

		initTime();

		GLWindow glWindow = cast(GLWindow)windowClass;

		MSG msg;
		for (;;)
		{
			if ( PeekMessageW(&msg, cast(HWND)hWnd,0,0,PM_REMOVE) != 0 )
			{
				if (msg.message==WM_QUIT)
				{
					//WM_QUIT
					break;
				}

				TranslateMessage(&msg);
				DispatchMessageW(&msg);
			}
			else
			{
				// Calculate the delta time for this window
				// It is based upon typical game timer techniques

				// This will need work to support multiple GL windows
				// For now, one is supported

				glWindow.onDraw(getDeltaTime());

				// Now, we can swap the buffers
				SwapBuffers(windhDC);
			}
		}
	}
}