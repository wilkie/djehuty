// defines the default behavior of a window
module bases.window;

import core.window;
import core.view;

import core.literals;

import platform.imports;
mixin(PlatformGenericImport!("vars"));
mixin(PlatformScaffoldImport!());

import core.string;
import core.main;
import core.definitions;

import console.main;

// Section: Bases

// Description: This class implements and abstracts a common window and it's operations. The BaseWindow class is not a control container or view canvas. The Window class is what you seek, as it extends this class to provide that functionality.
abstract class BaseWindow
{

public:

	// Description: Will create the window with certain default parameters
	// windowTitle: The initial title for the window.
	// windowStyle: The initial style for the window.
	// x: The initial x position of the window.
	// y: The initial y position of the window.
	// width: The initial width of the client area of the window.
	// height: The initial height of the client area of the window.
	this(StringLiteral window_title, WindowStyle window_style, int x, int y, int width, int height)
	{
		_window_title = new String(window_title);
		_width = width;
		_height = height;
		_x = x;
		_y = y;
		_style = window_style;
	}

	// Description: Will create the window with certain default parameters
	// windowTitle: The initial title for the window.
	// windowStyle: The initial style for the window.
	// x: The initial x position of the window.
	// y: The initial y position of the window.
	// width: The initial width of the client area of the window.
	// height: The initial height of the client area of the window.
	this(String window_title, WindowStyle window_style, int x, int y, int width, int height)
	{
		_window_title = new String(window_title);
		_width = width;
		_height = height;
		_x = x;
		_y = y;
		_style = window_style;
	}

	~this()
	{
		UninitializeWindow(this);
		remove();
	}



	// Events //

	// Description: This event will be called to draw the window
	void OnDraw()
	{
	}

	// Description: This event will be called when the window is initialized upon creation.
	void OnInitialize()
	{
	}

	// Description: This event will be called when the window is added to the window hierarchy.
	void OnAdd()
	{
	}

	// Description: This event will be called when the window is removed from the window hierarchy.
	void OnRemove()
	{
	}

	// Description: This event will be called when the window is uninitialized upon destruction.
	void OnUninitialize()
	{
	}


	// Description: Called when the primary mouse button (usually the left button) is pressed.
	void OnPrimaryMouseDown()
	{
	}

	// Description: Called when the primary mouse button (usually the left button) is released.
	void OnPrimaryMouseUp()
	{
	}

	// Description: Called when the secondary mouse button (usually the right button) is pressed.
	void OnSecondaryMouseDown()
	{
	}

	// Description: Called when the secondary mouse button (usually the right button) is released.
	void OnSecondaryMouseUp()
	{
	}

	// Description: Called when the tertiary mouse button (usually the middle button) is pressed.
	void OnTertiaryMouseDown()
	{
	}

	// Description: Called when the tertiary mouse button (usually the middle button) is released.
	void OnTertiaryMouseUp()
	{
	}

	// Description: This event is called when another uncommon mouse button is pressed down over the window.
	// button: The identifier of this button.
	void OnOtherMouseDown(uint button)
	{
	}

	// Description: This event is called when another uncommon mouse button is released over the window.
	// button: The identifier of this button.
	void OnOtherMouseUp(uint button)
	{
	}

	// Description: This event is called when the mouse wheel is scrolled vertically (the common scroll method).
	// amount: the number of standard 'ticks' that the scroll wheel makes
	void OnMouseWheelY(uint amount)
	{
	}

	// Description: This event is called when the mouse wheel is scrolled horizontally.
	// amount: the number of standard 'ticks' that the scroll wheel makes
	void OnMouseWheelX(uint amount)
	{
	}

	// Description: This event is called when the mouse enters the client area of the window
	void OnMouseEnter()
	{
	}

	// Description: This event is called when the mouse leaves the client area of the window
	void OnMouseLeave()
	{
	}

	// Description: This event is called when the mouse enters the client area of the window
	void OnMouseMove()
	{
	}

	// Description: This event is called when the window receives focus (activation).
	void OnGotFocus()
	{
	}

	// Description: This event is called when the window loses focus (inactivation).
	void OnLostFocus()
	{
	}

	// Description: This event is called when the window is moved, either from the OS or the move() function.
	void OnMove()
	{
	}

	// Description: This event is called when the window is resized, either from the OS or the resize() function.
	void OnResize()
	{
	}

	// Description: This event is called when the window is hidden or shown.
	void OnVisibilityChange()
	{
	}

	// Description: This event is called when the window is maximized, minimized, put into fullscreen, or restored.
	void OnStateChange()
	{
	}

	// Description: This event is called when a key is pressed over the window, when focused.
	// keyCode: The identifier for the key.
	void OnKeyDown(uint keyCode)
	{
	}

	// Description: This event is called when a character is processed by keyboard input over the focused window.
	// keyChar: The UTF-32 representation of the character.
	void OnKeyChar(dchar keyChar)
	{
	}

	// Description: This event is called when a key is released over the window, when focused.
	// keyCode: The identifier for the key.
	void OnKeyUp(uint keyCode)
	{
	}

	// Methods //

	// Description: Will get the title of the window.
	// Returns: The String representing the title.
	String getText()
	{
		return new String(_window_title);
	}

	// Description: Will set the title of the window.
	// str: The new title.
	void setText(ref String str)
	{
		_window_title = new String(str);

		if (!_inited) { return; }
		Scaffold.WindowSetTitle(this, &this._pfvars);
	}

	// Description: Will set the title of the window.
	// str: The new title.
	void setText(StringLiteral str)
	{
		_window_title = new String(str);

		if (!_inited) { return; }
		Scaffold.WindowSetTitle(this, &this._pfvars);
	}

	// Description: Will attempt to destroy the window and its children.  It will be removed from the hierarchy.
	void remove()
	{
		if (!_inited) { return; }

		// the window was added
		// destroy

		// TODO: Fire the event, and allow confirmation
		// TODO: Add a FORCE DESTROY function method

		_inited = false;

		Scaffold.WindowDestroy(this, &this._pfvars);
	}

	// Description: Sets the flag to make the window hidden or visible.
	// bShow: Pass true to show the window and false to hide it.
	void setVisibility(bool bShow)
	{
		if (_visible == bShow) { return; }

		_visible = !_visible;

		if (_inited)
		{
			if (!_visible)
			{
				Djehuty._windowVisibleCount--;
			}
			else
			{
				Djehuty._windowVisibleCount++;
			}

			Scaffold.WindowSetVisible(this, &this._pfvars,bShow);

			// safe guard:
			// fights off infection from ZOMBIE PROCESSES!!!
			if (Djehuty._windowVisibleCount== 0)
			{
				DestroyAllWindows();
				DjehutyEnd();
			}
		}

		OnVisibilityChange();
	}

	// Description: Will return whether or not the window is flagged as hidden or visible.  The window may not actually be visible due to it not being created or added.
	// Returns: It will return true when the window is flagged to be visible and false otherwise.
	bool getVisibility()
	{
		return _visible;
	}

	// Description: Will set the window to take a different state: WindowState.Minimized, WindowState.Maximized, WindowState.Fullscreen, WindowState.Normal
	// state: A WindowState value representing the new state.
	void setState(WindowState state)
	{
		if (_state == state) { return; }

		_state = state;

		if (_nextWindow !is null)
		{
			Scaffold.WindowSetState(this, &this._pfvars);
		}

		OnStateChange();
	}

	// Description: Will return the current state of the window.
	// Returns: The current WindowState value for the window.
	WindowState getState()
	{
		return _state;
	}

	// Description: Will set the window to take a different style: WindowStyle.Fixed (non-sizable), WindowStyle.Sizable (resizable window), WindowStyle.Popup (borderless).
	// style: A WindowStyle value representing the new style.
	void setStyle(WindowStyle style)
	{
		if (getState() == WindowState.Fullscreen)
			{ return; }

		_style = style;

		if (_nextWindow !is null)
		{
			Scaffold.WindowSetStyle(this, &this._pfvars);
		}
	}

	// Description: Will return the current style of the window.
	// Returns: The current WindowStyle value for the window.
	WindowStyle getStyle()
	{
		return _style;
	}



	// Description: This function will Size the window to fit a client area with the dimensions given by width and height.
	// width: The new width of the client area.
	// height: The new height of the client area.
	void resize(uint width, uint height)
	{
		_width = width;
		_height = height;

		if (_inited)
		{
			Scaffold.WindowRebound(this, &this._pfvars);
		}

		OnResize();
	}

	// Description: This function will move the window so that the top-left corner of the window (not client area) is set to the point (x,y).
	// x: The new x coordinate of the top-left corner.
	// y: The new y coordinate of the top-left corner.
	void move(uint x, uint y)
	{
		_x = x;
		_y = y;

		if (_inited)
		{
			Scaffold.WindowReposition(this, &this._pfvars);
		}

		OnMove();
	}


	// Position Polling //


	// Description: Will return the width of the client area of the window.
	// Returns: The width of the client area of the window.
	uint getWidth()
	{
		return _width;
	}

	// Description: Will return the height of the client area of the window.
	// Returns: The height of the client area of the window.
	uint getHeight()
	{
		return _height;
	}

	// Description: Will return the x coordinate of the window's position in screen coordinates.  Note that this is not the client area, but rather the whole window.
	// Returns: The x position of the top-left corner of the window.
	uint getX()
	{
		return _x;
	}

	// Description: Will return the y coordinate of the window's position in screen coordinates.  Note that this is not the client area, but rather the whole window.
	// Returns: The y position of the top-left corner of the window.
	uint getY()
	{
		return _y;
	}

	void ClientToScreen(ref int x, ref int y)
	{
		if (_inited == false) { return; }
		Scaffold.WindowClientToScreen(this, &this._pfvars, x, y);
	}

	void ClientToScreen(ref Coord pt)
	{
		if (_inited == false) { return; }
		Scaffold.WindowClientToScreen(this, &this._pfvars, pt);
	}

	void ClientToScreen(ref Rect rt)
	{
		if (_inited == false) { return; }
		Scaffold.WindowClientToScreen(this, &this._pfvars, rt);
	}




	// CHILD WINDOW METHODS

	bool IsDescendantOf(BaseWindow window)
	{
		if (_inited == false) { return false; }

		BaseWindow p = _parent;

		while(p !is null)
		{
			if (p is window)
			{
				return true;
			}

			p = p._parent;
		}

		return false;
	}

	bool IsAdded()
	{
		return _inited;
	}

	BaseWindow getParent()
	{
		return _parent;
	}

	uint GetNumChildren()
	{
		return _numChildren;
	}

	// add a child window to this window

	void addWindow(BaseWindow window)
	{
		if (_inited == false) { return; }

		// add the window to the root window list
		UpdateWindowList(window);

		// mark the parent
		window._parent = this;

		UpdateChildWindowList(window);

		// add one to the window count
		Djehuty._windowCount++;

		// add one to the child window count
		_numChildren++;

		// create the window via platform calls
		Scaffold.WindowCreate(this, &this._pfvars, window, window._pfvars);

		// create the window's view object
		window.OnInitialize();

		// call the OnAdd event of the new window
		window.OnAdd();

		//PrintChildWindowList(this);
	}


	// public properties

	Mouse mouseProps;

protected:
	String _window_title;
	uint _width, _height;
	uint _x, _y;

	WindowStyle _style;
	WindowState _state;

	WindowPlatformVars _pfvars;

private:

	// linked list implementation
	// to keep track of all windows
	BaseWindow _nextWindow = null;
	BaseWindow _prevWindow = null;

	// children windows will follow suit:
	BaseWindow _firstChild = null;	//head
	BaseWindow _lastChild = null;	//tail

	uint _numChildren = 0; // child count

	// parent is null when it is a root window
	BaseWindow _parent = null;

	// these may be null when it is an only child
	BaseWindow _nextSibling = null;
	BaseWindow _prevSibling = null;

	bool _visible = false;
	bool _fullscreen = false;

	bool _inited = false;


}













// Window Handling

BaseWindow WindowGetNext(ref BaseWindow w)
{
	return w._nextWindow;
}

void UpdateWindowList(ref BaseWindow w)
{
	w._inited = true;
	if (Djehuty._windowListHead is null)
	{
		Djehuty._windowListHead = w;
		Djehuty._windowListTail = w;

		w._nextWindow = w;
		w._prevWindow = w;
	}
	else
	{
		w._nextWindow = Djehuty._windowListHead;
		w._prevWindow = Djehuty._windowListTail;

		Djehuty._windowListHead._prevWindow = w;
		Djehuty._windowListTail._nextWindow = w;

		Djehuty._windowListHead = w;
	}

	if (w._visible)
	{
		Djehuty._windowVisibleCount++;
	}
}

void UpdateChildWindowList(ref BaseWindow w)
{
	// the _parent should be set
	if (w._parent is null) { return; }

	// now, add to the child list of parent
	BaseWindow parent = w._parent;

	// note: the _firstChild is the head of the list,
	//   _lastChild is the tail, and is listed via
	//   the children's _nextSibling and _prevSibling
	//   nodes.

	if (parent._firstChild is null)
	{
		// it had no children
		parent._firstChild = w;
		parent._lastChild = w;

		// the sibling list is also empty,
		// which is represented by it linking circularly
		// to itself, as null could indicate it being root
		w._nextSibling = w;
		w._prevSibling = w;
	}
	else
	{
		// this is not the first child

		// add to sibling list
		w._nextSibling = parent._firstChild;
		w._prevSibling = parent._lastChild;

		parent._firstChild._prevSibling = w;
		parent._lastChild._nextSibling = w;

		parent._firstChild = w;
	}
}


void PrintWindowList()
{
	BaseWindow w = Djehuty._windowListHead;

	if (w is null)
	{
		Console.put("WindowList:null");
		return;
	}

	Console.put("WindowList:");

	do
	{
		Char str[] = (w.getText().ptr)[0 .. w.getText().length];

		Console.put(str);

		w = w._nextWindow;

	} while (w !is Djehuty._windowListHead)

	Console.put("--:");
}

void PrintChildWindowList(ref BaseWindow parent)
{
	BaseWindow w = parent._firstChild;

	Console.put("WindowList:");

	if (w !is null)
	{

		do
		{
			Char str[] = (w.getText().ptr)[0 .. w.getText().length];

			Console.put(str);

			w = w._nextSibling;

		} while (w !is parent._firstChild)
	}

	Console.put("--:");
}

void DestroyAllWindows()
{
	BaseWindow w = Djehuty._windowListHead;

	if (w is null) { return; }

	BaseWindow tmp = w;

	Djehuty._windowListHead = null;
	Djehuty._windowListTail = null;

	do
	{
		w.remove();

		w = w._nextWindow;

	} while (w !is tmp)

	Djehuty._windowCount = 0;
	Djehuty._windowVisibleCount = 0;
}

void UninitializeWindow(ref BaseWindow w)
{
	if (w._nextWindow is null) { return; }

	w.OnRemove();

	// uninitialize controls
	if (w._pfvars._hasView)
	{
		// has a view, has controls

		Window viewW = cast(Window)w;
		WindowRemoveAllControls(viewW);
	}

	w._prevWindow._nextWindow = w._nextWindow;
	w._nextWindow._prevWindow = w._prevWindow;

	// destroy the window's view object
	w.OnUninitialize();

	if (Djehuty._windowListHead is w && Djehuty._windowListTail is w)
	{
		// unlink all
		Djehuty._windowListHead = null;
		Djehuty._windowListTail = null;
	}
	else
	{

		if (Djehuty._windowListHead is w)
		{
			Djehuty._windowListHead = Djehuty._windowListHead._nextWindow;
		}

		if (Djehuty._windowListTail is w)
		{
			Djehuty._windowListTail = Djehuty._windowListTail._prevWindow;
		}
	}

	w._nextWindow = null;
	w._prevWindow = null;

	// Decrement Window length
	Djehuty._windowCount--;

	// Check to see if this was invisible
	if (w._visible)
	{
		// Decrement Window Visible length
		Djehuty._windowVisibleCount--;

		// If there are no visible windows, quit (for now)
		if (Djehuty._windowVisibleCount == 0)
		{
			// just kill the app
			DestroyAllWindows();
			DjehutyEnd();
		}
	}

	// is it a parent window of some kind?
	// destroy and uninitialize all children
	if (w._firstChild !is null)
	{
		BaseWindow child = w._firstChild;

		do
		{
			child.remove();
			child = child._nextSibling;
		} while (child !is w._firstChild)
	}

	// is it a child window of some kind?
	// unlink it within the sibling list
	if (w._parent !is null)
	{
		BaseWindow p = w._parent;

		p._numChildren--;

		w._prevSibling._nextSibling = w._nextSibling;
		w._nextSibling._prevSibling = w._prevSibling;

		if (p._firstChild is w && p._lastChild is w)
		{
			// unreference this, the last child
			// the parent now has no children
			p._firstChild = null;
			p._lastChild = null;
		}
		else
		{
			if (p._firstChild is w)
			{
				p._firstChild = p._firstChild._nextSibling;
			}

			if (p._lastChild is w)
			{
				p._lastChild = p._lastChild._prevSibling;
			}
		}
	}

	w._parent = null;
	w._nextSibling = null;
	w._prevSibling = null;
	w._firstChild = null;
	w._lastChild = null;
}

WindowPlatformVars* WindowGetPlatformVars(ref BaseWindow window)
{
	return &window._pfvars;
}

WindowPlatformVars* WindowGetPlatformVars(ref Window window)
{
	return &window._pfvars;
}

// event procs
void CallStateChange(ref BaseWindow w, WindowState newState)
{
	w._state = newState;
	w.OnStateChange();
}

bool WindowHasView(ref BaseWindow w)
{
	return w._pfvars._hasView;
}

void SetWindowXY(ref BaseWindow w, int x, int y)
{
	w._x = x;
	w._y = y;
}

void SetWindowX(ref BaseWindow w, int x)
{
	w._x = x;
}

void SetWindowY(ref BaseWindow w, int y)
{
	w._y = y;
}

void SetWindowSize(ref BaseWindow w, uint width, uint height)
{
	w._width = width;
	w._height = height;
}

void SetWindowWidth(ref BaseWindow w, uint width)
{
	w._width = width;
}

void SetWindowHeight(ref BaseWindow w, uint height)
{
	w._height = height;
}
