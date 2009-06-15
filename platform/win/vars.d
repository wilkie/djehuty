/*
 * vars.d
 *
 * This file holds implementations for the Platform Variables for Windows.
 *
 * Author: Dave Wilkinson
 *
 */

module platform.win.vars;

import platform.win.common;
import platform.win.scaffolds.opengl;
import platform.win.main;

import core.definitions;
import core.thread;
import core.semaphore;
import core.audio;
import core.stream;
import core.main;
import core.string;
import core.basewindow;

import console.main;

import opengl.window;
import opengl.gl;

import utils.linkedlist;

// platform vars

struct WindowPlatformVars
{
	// required parameters:

	bool _hasGL;		// is a GLWindow
	bool _hasView;		// is a Window

	// -----

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

	String oldTitle;

	BaseWindow windowClass;

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
	void msgLoop(bool pleaseStop)
	{
		if (pleaseStop)
		{
			return;
		}

		oldTitle.appendChar('\0');
		hWnd = CreateWindowExW(iexstyle, djehutyClassName.ptr,oldTitle.ptr, istyle | WS_CLIPCHILDREN | WS_CLIPSIBLINGS,
			oldX, oldY, oldWidth, oldHeight, null,
			cast(HMENU) null, null, cast(void*)userData);

		assert(hWnd);

		// create the window's view object
		windowClass.OnInitialize();

		// call the OnAdd() event
		windowClass.OnAdd();

		MSG msg;
		while (GetMessageW(&msg, cast(HWND) hWnd, 0, 0))
		{
			TranslateMessage(&msg);
			if (msg.message == WM_DESTROY || msg.message == 0)
			{
				break;
			}
			DispatchMessageW(&msg);
		}
	}



	void gameLoopCallResize()
	{
		GLWindow glWindow = cast(GLWindow)windowClass;

		glWindow.OnDraw(getDeltaTime());

		// Now, we can swap the buffers
		SwapBuffers(windhDC);
	}



	void initTime()
	{

		long perfFreq;

		// initialize query performance timer
		QueryPerformanceFrequency(&perfFreq);
		tmInfo.timeFactor = cast(double)1.0 / cast(double)perfFreq;
		QueryPerformanceCounter(&tmInfo.timeLast);

		// initialize tick counter
		tmInfo.timeLast_tick = GetTickCount();
	}

	double getDeltaTime()
	{

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

		oldTitle.appendChar('\0');
		hWnd = CreateWindowExW(0, djehutyClassName.ptr,oldTitle.ptr, istyle ,
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
		windowClass.OnInitialize();

		// call the OnAdd() event
		windowClass.OnAdd();

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

				glWindow.OnDraw(getDeltaTime());

				// Now, we can swap the buffers
				SwapBuffers(windhDC);
			}
		}
	}
}

struct ViewPlatformVars
{
	RECT bounds;
	HDC dc;

	void* bits;
	int length;
	
	int penClr;

	_clipList clipRegions;
}

struct DirectoryPlatformVars
{
}

struct FilePlatformVars
{
    HANDLE f;
}

struct ThreadPlatformVars
{
	HANDLE thread = null;
	DWORD thread_id = 0;
}

struct SemaphorePlatformVars
{
	HANDLE _semaphore;
}

struct MutexPlatformVars
{
	CRITICAL_SECTION* _mutex;
}

struct SocketPlatformVars
{
	SOCKET m_skt;
	SOCKET m_bind_skt;
	DWORD m_thread_id;
	ubyte m_recvbuff[2048];

	static bool inited = false;
	static int init_ref = 0;
}

struct MenuPlatformVars
{
	HMENU hMenu;
}

struct WavePlatformVars
{
	// Handle to the device
	HWAVEOUT waveOut;
	WAVEFORMATEX wfx;

	struct BufferNode
	{
		Stream waveBuffer;
		WAVEHDR waveHeader;

		bool inUse;
		bool isLast;
	}

	BufferNode buffers[3];

	// Semaphore to keep the queue clean
	HANDLE queueLock;
	HANDLE closeLock;
	HANDLE opLock;

	bool isClosed;
	bool inited;

	DWORD threadID;
	HANDLE thread;

	BufferNode* curQueueNode;

	Audio wave;

	HANDLE event;
	HANDLE resumeEvent;
	//_WaveThread waveThread;
}

struct BrushPlatformVars
{
	HBRUSH brushHandle;
}

struct PenPlatformVars
{
	HPEN penHandle;
	int clr;
}

struct FontPlatformVars
{
	HFONT fontHandle;
}

struct RegionPlatformVars {
	HRGN regionHandle;
}



// --- //

class _clipList
{
	this()
	{
	}

	// make sure to delete the regions from the list
	~this()
	{
		HANDLE rgn;
		while(remove(rgn))
		{
			DeleteObject(rgn);
		}
	}

	// add to the head

	// Description: Will add the data to the head of the list.
	// data: The information you wish to store.  It must correspond to the type of data you specified in the declaration of the class.
	void addItem(HANDLE data)
	{
		LinkedListNode* newNode = new LinkedListNode;
		newNode.data = data;

		if (head is null)
		{
			head = newNode;
			tail = newNode;

			newNode.next = newNode;
			newNode.prev = newNode;
		}
		else
		{
			newNode.next = head;
			newNode.prev = tail;

			head.prev = newNode;
			tail.next = newNode;

			head = newNode;
		}

		_count++;
	}

	// remove the tail

	// Description: Will remove an item from the tail of the list, which would remove in a first-in-first-out ordering (FIFO).
	// data: Will be set to the data retreived.
	bool remove(out HANDLE data)
	{
		if (tail == null) {
			return false;
		}

		data = tail.data;

		//tail.next = null;
		//tail.prev = null;

		if (head is tail)
		{
			// unlink all
			head = null;
			tail = null;
		}
		else
		{
			tail = tail.prev;
		}

		_count--;

		return true;
	}

	bool remove()
	{
		if (tail == null) {
			return false;
		}

		//tail.next = null;
		//tail.prev = null;

		if (head is tail)
		{
			// unlink all
			head = null;
			tail = null;
		}
		else
		{
			tail = tail.prev;
		}

		_count--;

		return true;
	}

	uint length()
	{
	   return _count;
	}

protected:

	// the contents of a node
	struct LinkedListNode
	{
		LinkedListNode* next;
		LinkedListNode* prev;
		HANDLE data;
	}

	// the head and tail of the list
	LinkedListNode* head = null;
	LinkedListNode* tail = null;

	// the last accessed node is cached
	LinkedListNode* last = null;
	uint lastIndex = 0;

	// the number of items in the list
	uint _count;
}

struct LibraryPlatformVars
{
	HMODULE hmodule;
}