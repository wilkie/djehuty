module gui.core;

import platform.imports;
mixin(PlatformGenericImport!("vars"));
mixin(PlatformScaffoldImport!());

import core.definitions;

import interfaces.container;

import core.main;
import core.view;
import core.string;
import core.menu;
import core.graphics;
import core.color;
import core.event;
import core.windowedcontrol;
import core.application;

import core.literals;

import console.main;

void UninitializeWindow(Window w)
{
	if (w._nextWindow is null) { return; }

	w.OnRemove();

	WindowRemoveAllControls(w);

	w._prevWindow._nextWindow = w._nextWindow;
	w._nextWindow._prevWindow = w._prevWindow;

	// destroy the window's view object
	w.OnUninitialize();
	
	GuiApplication app = cast(GuiApplication)w.responder;
	
	if (app._windowListHead is w && app._windowListTail is w) {
		app._windowListHead = null;
		app._windowListTail = null;
	}
	else {
		if (app._windowListHead is w) {
			app._windowListHead = app._windowListHead._nextWindow;
		}

		if (app._windowListTail is w) {
			app._windowListTail = app._windowListHead._prevWindow;
		}
	}

	w._nextWindow = null;
	w._prevWindow = null;

	// Decrement Window length
	app._windowCount--;

	// Check to see if this was invisible
	if (w._visible)
	{
		// Decrement Window Visible length
		app._windowVisibleCount--;

		// If there are no visible windows, quit (for now)
		if (app.isZombie() == 0)
		{
			// just kill the app
			app.destroyAllWindows();
			DjehutyEnd();
		}
	}

	// is it a parent window of some kind?
	// destroy and uninitialize all children
	if (w._firstChild !is null)
	{
		Window child = w._firstChild;

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
		Window p = w._parent;

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

class GuiApplication : Application {
public:
	
	override void push(Dispatcher dsp) {
		if (cast(Window)dsp !is null) {
			addWindow(cast(Window)dsp);
		}

		super.push(dsp);
	}

	int getWindowCount() {
		return _windowCount;
	}

	int getVisibleWindowCount() {
		return _windowVisibleCount;
	}

	override bool isZombie() {
		return _windowVisibleCount == 0;
	}

protected:
	Window _windowListHead = null;
	Window _windowListTail = null;

	int _windowCount;
	int _windowVisibleCount;

private:
	// Description: Will add and create the window (as long as it hasn't been already) and add it to the root window hierarchy.
	// window: An instance of a Window class, or any the inherit from Window.
	void addWindow(Window window) {
		WindowPlatformVars* wpv = WindowGetPlatformVars(window);

		synchronized {
			// update the window linked list
			updateWindowList(window);

			// increase global window count
			_windowCount++;

			// create the window through platform calls
			Scaffold.WindowCreate(window, wpv);
		}

		if (window.getVisibility()) {
			Scaffold.WindowSetVisible(window, wpv, true);
		}
	}
	
	void updateWindowList(Window window) {
		window._inited = true;
	
		if (_windowListHead is null)
		{
			_windowListHead = window;
			_windowListTail = window;

			window._nextWindow = window;
			window._prevWindow = window;
		}
		else
		{
			window._nextWindow = _windowListHead;
			window._prevWindow = _windowListTail;

			_windowListHead._prevWindow = window;
			_windowListTail._nextWindow = window;
			
			_windowListHead = window;
		}

		if (window._visible)
		{
			_windowVisibleCount++;
		}
	}

	void destroyAllWindows()
	{
		Window w = _windowListHead;

		if (w is null) { return; }

		Window tmp = w;

		_windowListHead = null;
		_windowListTail = null;

		do
		{
			w.remove();

			w = w._nextWindow;

		} while (w !is tmp)
		
		_windowCount = 0;
		_windowVisibleCount = 0;
	}
}

// Description: This class implements and abstracts a common window.  This window is a control container and a view canvas.
class Window : Responder, AbstractContainer
{

public:

	// Description: Will create the window with certain default parameters
	// windowTitle: The initial title for the window.
	// windowStyle: The initial style for the window.
	// color: The initial color for the window.
	// x: The initial x position of the window.
	// y: The initial y position of the window.
	// width: The initial width of the client area of the window.
	// height: The initial height of the client area of the window.
	this(StringLiteral windowTitle, WindowStyle windowStyle, Color color, int x, int y, int width, int height)
	{
		_color = color;
		_window_title = new String(windowTitle);
		_width = width;
		_height = height;
		_x = x;
		_y = y;
		_style = windowStyle;
	}

	// Description: Will create the window with certain default parameters
	// windowTitle: The initial title for the window.
	// windowStyle: The initial style for the window.
	// color: The initial color for the window.
	// x: The initial x position of the window.
	// y: The initial y position of the window.
	// width: The initial width of the client area of the window.
	// height: The initial height of the client area of the window.
	this(String windowTitle, WindowStyle windowStyle, Color color, int x, int y, int width, int height)
	{
		_color = color;
		_window_title = new String(windowTitle);
		_width = width;
		_height = height;
		_x = x;
		_y = y;
		_style = windowStyle;
	}

	// Description: Will create the window with certain default parameters
	// windowTitle: The initial title for the window.
	// windowStyle: The initial style for the window.
	// sysColor: The initial color for the window which is taken from a platform color setting.
	// x: The initial x position of the window.
	// y: The initial y position of the window.
	// width: The initial width of the client area of the window.
	// height: The initial height of the client area of the window.
	this(StringLiteral windowTitle, WindowStyle windowStyle, SystemColor sysColor, int x, int y, int width, int height)
	{
		Scaffold.ColorGetSystemColor(_color, sysColor);
		_window_title = new String(windowTitle);
		_width = width;
		_height = height;
		_x = x;
		_y = y;
		_style = windowStyle;
	}

	// Description: Will create the window with certain default parameters
	// windowTitle: The initial title for the window.
	// windowStyle: The initial style for the window.
	// sysColor: The initial color for the window which is taken from a platform color setting.
	// x: The initial x position of the window.
	// y: The initial y position of the window.
	// width: The initial width of the client area of the window.
	// height: The initial height of the client area of the window.
	this(String windowTitle, WindowStyle windowStyle, SystemColor sysColor, int x, int y, int width, int height)
	{
		Scaffold.ColorGetSystemColor(_color, sysColor);
		_window_title = new String(windowTitle);
		_width = width;
		_height = height;
		_x = x;
		_y = y;
		_style = windowStyle;
	}

	~this()
	{
		UninitializeWindow(this);
		remove();
	}

	// Control Container Margins

	int getBaseX()
	{
		return 0;
	}

	int getBaseY()
	{
		return 0;
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
			GuiApplication app = cast(GuiApplication)responder;
			if (!_visible)
			{
				app._windowVisibleCount--;
			}
			else
			{
				app._windowVisibleCount++;
			}

			Scaffold.WindowSetVisible(this, &this._pfvars,bShow);

			// safe guard:
			// fights off infection from ZOMBIE PROCESSES!!!
			if (app.isZombie())
			{
				app.destroyAllWindows();
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

	bool IsDescendantOf(Window window)
	{
		if (_inited == false) { return false; }

		Window p = _parent;

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

	Window getParent()
	{
		return _parent;
	}

	uint GetNumChildren()
	{
		return _numChildren;
	}

	// add a child window to this window

	void addWindow(Window window)
	{/*
		if (_inited == false) { return; }

		// add the window to the root window list
		UpdateWindowList(window);

		// mark the parent
		window._parent = this;

		UpdateChildWindowList(window);

		// add one to the window count
		ApplicationPlusWindow(cast(GuiApplication)Djehuty.app);

		// add one to the child window count
		_numChildren++;

		// create the window via platform calls
		Scaffold.WindowCreate(this, &this._pfvars, window, window._pfvars);

		// create the window's view object
		window.OnInitialize();

		// call the OnAdd event of the new window
		window.OnAdd();*/

		//PrintChildWindowList(this);
	}

	// Events //

	// Description: This event will be called when the window is added to the window hierarchy.
	void OnAdd()
	{
	}

	// Description: This event will be called when the window is removed from the window hierarchy.
	void OnRemove()
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

	// Description: This event is called when the window is moved, either from the OS or the move() function.
	void OnMove()
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

	// Description: This event is called when a menu item belonging to the window is activated.
	// mnu: A reference to the menu that was activated.
	void OnMenu(Menu mnu)
	{
	}

	void OnInitialize()
	{
		_view = new View;

		ViewCreateForWindow(_view, this);
	}

	void OnUninitialize()
	{
		_view.destroy();
		_view = null;
	}

	void OnDraw()
	{
		if (_view !is null)
		{
			ViewPlatformVars* viewVars = ViewGetPlatformVars(_view);

			Graphics g = _view.lockDisplay();

			Scaffold.WindowStartDraw(this, &_pfvars, _view, *viewVars);

			Control c = _firstControl;

			if (c !is null)
			{
				do
				{
					c =	c._prevControl;

					c.OnDraw(g);
				} while (c !is _firstControl)
			}

			Scaffold.WindowEndDraw(this, &_pfvars, _view, *viewVars);

			_view.unlockDisplay();
		}
	}

	void OnKeyChar(dchar keyChar)
	{
		// dispatch to focused control
		if (_focused_control !is null)
		{
			if (_focused_control.OnKeyChar(keyChar))
			{
				OnDraw();
			}
		}
	}

	void OnKeyDown(uint keyCode)
	{
		// dispatch to focused control
		if (_focused_control !is null)
		{
			if (_focused_control.OnKeyDown(keyCode))
			{
				OnDraw();
			}
		}
	}

	void OnKeyUp(uint keyCode)
	{
		// dispatch to focused control
		if (_focused_control !is null)
		{
			if (_focused_control.OnKeyUp(keyCode))
			{
				OnDraw();
			}
		}
	}

	void OnMouseLeave()
	{
		if (_last_control !is null)
		{
			_last_control._hovered = false;
			if(_last_control.OnMouseLeave())
			{
				OnDraw();
			}
			_last_control = null;
		}
	}

	void OnMouseMove()
	{
		//select the control to send the message to
		Control control;

		if (_captured_control !is null)
		{
			control = _captured_control;

			if (control.containsPoint(mouseProps.x, mouseProps.y) && control.getVisibility())
			{
				//within bounds of control
				if (!control._hovered)
				{
					//currently, hover state says control is outside
					control._hovered = true;
					if (control.OnMouseEnter() | control.OnMouseMove(mouseProps))
					{
						OnDraw();
					}
				}
				else if (control.OnMouseMove(mouseProps))
				{
					OnDraw();
				}
			}
			else
			{
				//outside bounds of control
				if (control._hovered)
				{
					//currently, hover state says control is inside
					control._hovered = false;
					if (control.OnMouseLeave() | control.OnMouseMove(mouseProps))
					{
						OnDraw();
					}
				}
				else if (control.OnMouseMove(mouseProps))
				{
					OnDraw();
				}
			}

			//change the cursor to reflect the new control
			//Scaffold.ChangeCursor(window->captured_control->ctrl_info.ctrl_cursor);


		}	// no control that has captured the mouse input
		else if ((control = controlAtPoint(mouseProps.x, mouseProps.y)) !is null)
		{
			//when there is a control to pass a MouseLeave to...
			if (_last_control !is control && _last_control !is null)
			{
				control._hovered = true;
				_last_control._hovered = false;

				if(_last_control.OnMouseLeave() |
					control.OnMouseEnter() | control.OnMouseMove(mouseProps))
				{
					OnDraw();
				}
			} //otherwise, there is just one control to worry about
			else
			{
				if(!control._hovered)
				{	//wasn't hovered over before
					control._hovered = true;
					if(control.OnMouseEnter() | control.OnMouseMove(mouseProps))
					{
						OnDraw();
					}
				}
				else if(control.OnMouseMove(mouseProps))
				{
					OnDraw();
				}
			}

			//change the cursor to reflect the new control
			//Scaffold.ChangeCursor(index->ctrl_cursor);

			_last_control = control;

		}
		else
		{

			//mouse is on window, not control

			if (_last_control !is null)
			{
				_last_control._hovered = false;
				if(_last_control.OnMouseLeave())
				{
					OnDraw();
				}
				_last_control = null;
			}
		}
	}

	template WindowOnMouse(StringLiteral8 type, StringLiteral8 otherDecl, StringLiteral8 otherName)
	{

		const char[] WindowOnMouse =

		`void On` ~ type ~ `(` ~ otherDecl ~ `)
		{
			Control control;

			if (_captured_control !is null)
			{
				if (_captured_control.On` ~ type ~ `(mouseProps` ~ otherName ~ `))
				{
					OnDraw();
				}
			}
			else if ((control = controlAtPoint(mouseProps.x, mouseProps.y)) !is null)
			{
				bool ret = false;

				//consider the focus of the control
				if(_focused_control !is control)
				{
					if (_focused_control !is null)
					{
						//the current focused control gets unfocused
						_focused_control._focused = false;
						ret = _focused_control.OnLostFocus(false);
					}

					//focus this control
					_focused_control = control;
					_focused_control._focused = true;

					ret |= _focused_control.OnGotFocus(false);
				}

				if(ret | control.On` ~ type ~ `(mouseProps` ~ otherName ~ `))
				{
					OnDraw();
				}

				//change the cursor to reflect the new control
				//Scaffold.ChangeCursor(index->ctrl_cursor);
			}
		}`;
	}

	// Description: Called when the primary mouse button (usually the left button) is pressed.
	void OnPrimaryMouseDown() {
		Control target;
		if(mouseEventCommon(target) | target.OnPrimaryMouseDown(mouseProps)) {
			OnDraw();
		}
	}

	// Description: Called when the primary mouse button (usually the left button) is released.
	void OnPrimaryMouseUp() {
		Control target;
		if(mouseEventCommon(target) | target.OnPrimaryMouseUp(mouseProps)) {
			OnDraw();
		}
	}

	// Description: Called when the secondary mouse button (usually the right button) is pressed.
	void OnSecondaryMouseDown() {
		Control target;
		if(mouseEventCommon(target) | target.OnSecondaryMouseDown(mouseProps)) {
			OnDraw();
		}
	}

	// Description: Called when the secondary mouse button (usually the right button) is released.
	void OnSecondaryMouseUp() {
		Control target;
		if(mouseEventCommon(target) | target.OnSecondaryMouseUp(mouseProps)) {
			OnDraw();
		}
	}

	// Description: Called when the tertiary mouse button (usually the middle button) is pressed.
	void OnTertiaryMouseDown() {
		Control target;
		if(mouseEventCommon(target) | target.OnTertiaryMouseDown(mouseProps)) {
			OnDraw();
		}
	}

	// Description: Called when the tertiary mouse button (usually the middle button) is released.
	void OnTertiaryMouseUp() {
		Control target;
		if(mouseEventCommon(target) | target.OnTertiaryMouseUp(mouseProps)) {
			OnDraw();
		}
	}

	// Description: This event is called when another uncommon mouse button is pressed down over the window.
	// button: The identifier of this button.
	void OnOtherMouseDown(uint button) {
		Control target;
		if(mouseEventCommon(target) | target.OnOtherMouseDown(mouseProps, button)) {
			OnDraw();
		}
	}

	// Description: This event is called when another uncommon mouse button is released over the window.
	// button: The identifier of this button.
	void OnOtherMouseUp(uint button) {
		Control target;
		if(mouseEventCommon(target) | target.OnOtherMouseUp(mouseProps, button)) {
			OnDraw();
		}
	}

	void OnResize() {
		ViewResizeForWindow(_view, this);

		OnDraw();
	}

	void OnLostFocus() {
		//currently focused control will lose focus
		if (_focused_control !is null) {
			_focused_control._focused = false;
			if (_focused_control.OnLostFocus(true)) {
				OnDraw();
			}
		}
	}

	void OnGotFocus() {
		//currently focused control will regain focus
		if (_focused_control !is null) {
			_focused_control._focused = true;
			if (_focused_control.OnGotFocus(true)) {
				OnDraw();
			}
		}
	}

	// Methods //


	// Description: This will retreive the current window color.
	// Returns: The color currently associated with the window.
	Color getColor() {
		return _color;
	}

	// Description: This will set the current window color.
	// color: The color to associate with the window.
	void setColor(ref Color color)
	{
		_color = color;
	}

	// Description: This will set the current window color to a specific platform color.
	// sysColor: The system color index to associate with the window.
	void setColor(SystemColor color)
	{
		Scaffold.ColorGetSystemColor(_color, color);
	}

	// Description: This will force a redraw of the entire window.
	void redraw()
	{
		OnDraw();
	}

	// Control Maintenance //

	// Description: This function will return the visible control at the point given.
	// x: The x coordinate to start the search.
	// y: The y coordinate to start the search.
	// Returns: The top-most visible control at the point (x,y) or null.
	Control controlAtPoint(int x, int y)
	{
		Control ctrl = _firstControl;

		if (ctrl !is null)
		{
			do
			{
				if (ctrl.containsPoint(x,y) && ctrl.getVisibility())
				{
					if (ctrl.isContainer())
					{
						Control innerCtrl = (cast(AbstractContainer)ctrl).controlAtPoint(x,y);
						if (innerCtrl !is null) { return innerCtrl; }
					}
					else
					{
						return ctrl;
					}
				}
				ctrl = ctrl._nextControl;
			} while (ctrl !is _firstControl)
		}

		return null;
	}
	
	override void push(Dispatcher dsp) {
		if (cast(Control)dsp !is null) {
			Control control = cast(Control)dsp;

			// do not add a control that is already part of another window
			if (control.getParent() !is null) { return; }
	
			// add to the control linked list
			if (_firstControl is null && _lastControl is null) {
				// first control

				_firstControl = control;
				_lastControl = control;
				
				control._nextControl = control;
				control._prevControl = control;
			}
			else {
				// next control
				control._nextControl = _firstControl;
				control._prevControl = _lastControl;
				
				_firstControl._prevControl = control;
				_lastControl._nextControl = control;

				_firstControl = control;
			}

			// increase the number of controls
			_numControls++;

			// set the control's parent
			control._view = _view;
			control._container = this;
			
			super.push(control);

			// call the control's event
			control.OnAdd();

			return;
		}

		super.push(dsp);
	}

	// Description: Removes the control as long as this control is a part of the current window.
	// control: A reference to the control that should be removed from the window.
	void removeControl(Control control)
	{
		if (control.isOfWindow(this))
		{
			if (_firstControl is null && _lastControl is null)
			{
				// it is the last control
				_firstControl = null;
				_lastControl = null;
			}
			else
			{
				// is it not the last control

				if (_firstControl is control)
				{
					_firstControl = _firstControl._nextControl;
				}

				if (_lastControl is control)
				{
					_lastControl = _lastControl._prevControl;
				}

				control.removeControl;
			}

			_numControls--;
		}
	}



	// Menus //


	// Description: Sets the menu for the window.  This menu's subitems will be displayed typically as a menu bar.
	// mnuMain: A Menu object representing the main menu for the window.  Pass null to have no menu.
	void setMenu(Menu mnuMain)
	{
		_mainMenu = mnuMain;

		if (mnuMain is null)
		{
			// remove the menu
		}
		else
		{
			// Switch out and apply the menu

			// platform specific
			MenuPlatformVars mnuVars = MenuGetPlatformVars(mnuMain);
			Scaffold.WindowSetMenu(mnuMain, mnuVars, this, _pfvars);
		}
	}

	// Description: Gets the current menu for the window.  It will return null when no menu is available.
	// Returns: The Menu object representing the main menu for the window.
	Menu getMenu()
	{
		return _mainMenu;
	}

	// public properties

	Mouse mouseProps;

protected:

	bool mouseEventCommon(out Control target) {
		if (_captured_control !is null)
		{
			target = _captured_control;
		}
		else if ((target = controlAtPoint(mouseProps.x, mouseProps.y)) !is null)
		{
			bool ret = false;

			//consider the focus of the control
			if(_focused_control !is target)
			{
				if (_focused_control !is null)
				{
					//the current focused control gets unfocused
					_focused_control._focused = false;
					ret = _focused_control.OnLostFocus(false);
				}

				//focus this control
				_focused_control = target;
				_focused_control._focused = true;

				ret |= _focused_control.OnGotFocus(false);
			}

			return ret;

			//change the cursor to reflect the new control
			//Scaffold.ChangeCursor(index->ctrl_cursor);
		}

		return false;
	}

	View _view = null;

	Color _color;

	// imposes left and top margins on the window, when set
	long _constraint_x = 0;
	long _constraint_y = 0;

	String _window_title;
	uint _width, _height;
	uint _x, _y;

	WindowStyle _style;
	WindowState _state;

	WindowPlatformVars _pfvars;

private:

	// head and tail of the control linked list
	Control _firstControl = null;	//head
	Control _lastControl = null;	//tail
	int _numControls = 0;

	Control _captured_control = null;
	Control _last_control = null;
	Control _focused_control = null;

	Menu _mainMenu = null;

	// linked list implementation
	// to keep track of all windows
	Window _nextWindow = null;
	Window _prevWindow = null;

	// children windows will follow suit:
	Window _firstChild = null;	//head
	Window _lastChild = null;	//tail

	uint _numChildren = 0; // child count

	// parent is null when it is a root window
	Window _parent = null;

	// these may be null when it is an only child
	Window _nextSibling = null;
	Window _prevSibling = null;

	bool _visible = false;
	bool _fullscreen = false;

	bool _inited = false;
}

// this mixin of this template within an inherited control implementation will
// provide an event delegate structure
template ControlAddDelegateSupport(StringLiteral8 ControlClass, StringLiteral8 ControlEventEnum)
{
	static if (ControlClass[0] == 'B' && ControlClass[1] == 'a' && ControlClass[2] == 's' && ControlClass[3] == 'e')
	{
		const char[] ControlAddDelegateSupport =

		`
		alias void delegate (` ~ ControlClass ~ `, ` ~ ControlEventEnum ~`) ControlBaseCallback;

		public void setBaseDelegate(ControlBaseCallback callback) {

			_internal_callback_Base = callback;

		}

		public void FireEvent(` ~ ControlEventEnum ~ ` event) {

			if (_internal_callback_Base !is null) {

				_internal_callback_Base(this, event);

			}

		 }

		protected ControlBaseCallback _internal_callback_Base = null;`;
	}
	else
	{
		const char[] ControlAddDelegateSupport =

		`
		alias void delegate (` ~ ControlClass ~ `, ` ~ ControlEventEnum ~`) ControlCallback;

		public void setDelegate(ControlCallback callback) {

			_internal_callback_` ~ ControlClass ~ ` = callback;

		}

		public void FireEvent(` ~ ControlEventEnum ~ ` event) {

			if (_internal_callback_` ~ ControlClass ~ ` !is null) {

				_internal_callback_` ~ ControlClass ~ `(this, event);

			}

		 }

		protected ControlCallback _internal_callback_` ~ ControlClass ~ ` = null;`;
	}
}

// Description: This class implements and abstracts a control, which is a special container that can be drawn and added to a Window.  The control receives many events for different tasks, and allows reusable components within the static version of an application.
class Control : Responder
{
	// Deconstructor //

	~this() {
		remove();
	}

	// Events //

	// Description: Called when the control is added to a Window.
	void OnAdd() {
	}

	// Description: Called when the control is removed from its parent window.
	void OnRemove() {
	}

	// Description: Called when the control should be redrawn.
	// g: The graphics object that has already been locked.  Use this to draw primitives to the window.
	void OnDraw(ref Graphics g) {
	}

	// Description: Called when the primary mouse button (usually the left button) is pressed.
	// mouseProps: A convenient reference to the window's Mouse structure, describing the mouse state.
	// Returns: The user should return true when the control should be redrawn.
	bool OnPrimaryMouseDown(ref Mouse mouseProps) {
		return false;
	}

	// Description: Called when the primary mouse button (usually the left button) is released.
	// mouseProps: A convenient reference to the window's Mouse structure, describing the mouse state.
	// Returns: The user should return true when the control should be redrawn.
	bool OnPrimaryMouseUp(ref Mouse mouseProps) {
		return false;
	}

	// Description: Called when the secondary mouse button (usually the right button) is pressed.
	// mouseProps: A convenient reference to the window's Mouse structure, describing the mouse state.
	// Returns: The user should return true when the control should be redrawn.
	bool OnSecondaryMouseDown(ref Mouse mouseProps) {
		return false;
	}

	// Description: Called when the secondary mouse button (usually the right button) is released.
	// mouseProps: A convenient reference to the window's Mouse structure, describing the mouse state.
	// Returns: The user should return true when the control should be redrawn.
	bool OnSecondaryMouseUp(ref Mouse mouseProps) {
		return false;
	}

	// Description: Called when the tertiary mouse button (usually the middle button) is pressed.
	// mouseProps: A convenient reference to the window's Mouse structure, describing the mouse state.
	// Returns: The user should return true when the control should be redrawn.
	bool OnTertiaryMouseDown(ref Mouse mouseProps) {
		return false;
	}

	// Description: Called when the tertiary mouse button (usually the middle button) is released.
	// mouseProps: A convenient reference to the window's Mouse structure, describing the mouse state.
	// Returns: The user should return true when the control should be redrawn.
	bool OnTertiaryMouseUp(ref Mouse mouseProps) {
		return false;
	}

	// Description: Called when some other atypical mouse button is pressed.
	// mouseProps: A convenient reference to the window's Mouse structure, describing the mouse state.
	// button: An index of the alternate button.
	// Returns: The user should return true when the control should be redrawn.
	bool OnOtherMouseDown(ref Mouse mouseProps, uint button) {
		return false;
	}

	// Description: Called when some other atypical mouse button is released.
	// mouseProps: A convenient reference to the window's Mouse structure, describing the mouse state.
	// button: An index of the alternate button.
	// Returns: The user should return true when the control should be redrawn.
	bool OnOtherMouseUp(ref Mouse mouseProps, uint button) {
		return false;
	}

	// Description: Called when the mouse cursor enters within the bounds of the control.
	// Returns: The user should return true when the control should be redrawn.
	bool OnMouseEnter() {
		return false;
	}

	// Description: Called when the mouse cursor leaves the bounds of the control.
	// Returns: The user should return true when the control should be redrawn.
	bool OnMouseLeave() {
		return false;
	}

	// Description: Called when the mouse moves within the bounds of the control.
	// mouseProps: A convenient reference to the window's Mouse structure, describing the mouse state.
	// Returns: The user should return true when the control should be redrawn.
	bool OnMouseMove(ref Mouse mouseProps) {
		return false;
	}

	// Description: Called when the control receives focus.
	// bWasWindow: When true, the window received focus as well.
	// Returns: The user should return true when the control should be redrawn.
	bool OnGotFocus(bool bWasWindow) {
		return false;
	}

	// Description: Called when the control loses focus.
	// bWasWindow: When true, the window lost focus as well.
	// Returns: The user should return true when the control should be redrawn.
	bool OnLostFocus(bool bWasWindow) {
		return false;
	}

	// Description: Called when the control is focused during a key press.
	// keyCode: The ID of the code.
	// Returns: The user should return true when the control should be redrawn.
	bool OnKeyDown(uint keyCode) {
		return false;
	}

	// Description: Called when the control is focused during a key release.
	// keyCode: The ID of the code.
	// Returns: The user should return true when the control should be redrawn.
	bool OnKeyUp(uint keyCode) {
		return false;
	}

	// Description: Called when the control is focused during a key press that results in a printable character.
	// keyChar: The character in standard UTF-32.
	// Returns: The user should return true when the control should be redrawn.
	bool OnKeyChar(dchar keyChar) {
		return false;
	}

	// Methods

	// Description: Will return a boolean indictating whether or not the window given is the parent window.
	// window: The window to determine if it is the parent.
	// Returns: Will return true if the owning window is the same as the one passed by the parameter.
	bool isOfWindow(ref Window window) {
		if (_window is window) {
			return true;
		}

		return false;
	}

	// Description: Will return a boolean indictating whether or not the container given is the parent container.
	// container: The container to determine if it is the parent.
	// Returns: Will return true if the owning container is the same as the one passed by the parameter.
	bool isOfContainer(AbstractContainer container) {
		if (_container is container) {
			return true;
		}

		return false;
	}

	// Description: Will return a reference to the parent window that owns this control.
	// Returns: The reference to the current window object that owns this control instance.
	Window getParent() {
		return _window;
	}

	// Description: Will remove this control to whatever it has been added to.
	void remove() {
		if (_window is null) { return; }
		if (_nextControl is null) { return; }

		_window.removeControl(this);
	}

	// Description: Will return a boolean value describing whether the point is within the region occupied by the control.
	// Returns: Will return true when the point is within the region.
	bool containsPoint(int x, int y) {
		if (_x < x && _y < y &&
			_b > y && _r > x) {
			return true;
		}

		return false;
	}

	// Description: Will return the flag that determines whether or not the control is visible (ie. drawn).
	// Returns: If true, the control is currently visible.  If false, the control is currently hidden.
	bool getVisibility() {
		return _visible;
	}

	// Description: Will set the flag to mark the control either visible or hidden.
	// bVisible: Passing true would mark this control to be drawn, passing false will mark this control as hidden and not drawn.
	void setVisibility(bool bVisible) {
		_visible = bVisible;
	}

	// Control type information

	bool isContainer() {
		return false;
	}

	bool isWindowed() {
		return false;
	}
	
	bool isHovered() {
		return _hovered;
	}

	bool isFocused() {
		return _focused;
	}

protected:

	Window _window = null;
	Control _parent = null;
	AbstractContainer _container = null;

	View _view = null;

	bool _visible = true;

	bool _enabled = true;
	bool _focused = false;
	bool _hovered = false;

	bool _needs_redraw = false;

	int _x = -1; //x (for window)
	int _y = -1; //y
	int _r = -1; //right
	int _b = -1; //bottom
	int _subX = -1; // x within container
	int _subY = -1; // y within container

	int _width = -1;   //width
	int _height = -1;  //height

	// - will post an event to this control
	//void PostEvent(Int32 theEvent, Int32 p1, Int32 p2);

	void requestCapture()
	{
		if (_window !is null)
		{
			WindowCaptureMouse(_window, this);
		}
	}

	void requestRelease()
	{
		if (_window !is null)
		{
			WindowReleaseMouse(_window, this);
		}
	}

private:

	void removeControl() {
		OnRemove();

		_view = null;
		_window = null;

		_nextControl = null;
		_prevControl = null;
	}

	// control list
	Control _nextControl;
	Control _prevControl;
}

// Description: This control will provide a simple push button.
class Container : WindowedControl, AbstractContainer
{
	// Description: This will create a button with the specified dimensions and text.
	this(int x, int y, int width, int height)
	{
		super(x,y,width,height);
	}

	override void OnAdd()
	{
	}

	override void OnDraw(ref Graphics g)
	{
		g.clipSave();

		g.clipRect(_x,_y,_r,_b);

		Control c = _firstControl;

		if (c !is null)
		{
			do
			{
				c =	c._prevControl;

				c.OnDraw(g);
			} while (c !is _firstControl)
		}

		g.clipRestore();
	}

	override bool isContainer()
	{
		return true;
	}

	void addControl(Control control)
	{
		// do not add a control that is already part of another window
		if (control.getParent() !is null) { return; }

		// add to the control linked list
		if (_firstControl is null && _lastControl is null)
		{
			// first control

			_firstControl = control;
			_lastControl = control;

			control._nextControl = control;
			control._prevControl = control;
		}
		else
		{
			// next control
			control._nextControl = _firstControl;
			control._prevControl = _lastControl;
			
			_firstControl._prevControl = control;
			_lastControl._nextControl = control;

			_firstControl = control;
		}

		// increase the number of controls
		_numControls++;

		// call a function initializing a control on the control's end
		Window wnd = getParent();

		control._window = wnd;
		control._view = _view;
		control._container = this;

		control.OnAdd();

		if (control.isWindowed())
		{
			WindowedControl wctrl = cast(WindowedControl)control;
			wctrl.move(wctrl.getX(), wctrl.getY());
		}
	}

	void removeControl(Control control)
	{
		if (control.isOfContainer(this))
		{
			if (_firstControl is null && _lastControl is null)
			{
				// it is the last control
				_firstControl = null;
				_lastControl = null;
			}
			else
			{
				// is it not the last control

				if (_firstControl is control)
				{
					_firstControl = _firstControl._nextControl;
				}

				if (_lastControl is control)
				{
					_lastControl = _lastControl._prevControl;
				}

				control.removeControl();
			}

			_numControls--;
		}
	}

	Control controlAtPoint(int x, int y)
	{
		Control ctrl = _firstControl;

		if (ctrl !is null)
		{
			do
			{
				if (ctrl.containsPoint(x,y) && ctrl.getVisibility())
				{
					if (ctrl.isContainer())
					{
						Control innerCtrl = (cast(AbstractContainer)ctrl).controlAtPoint(x,y);
						if (innerCtrl !is null) { return innerCtrl; }
					}
					else
					{
						return ctrl;
					}
				}
				ctrl = ctrl._nextControl;
			} while (ctrl !is _firstControl)
		}

		return null;
	}

	override void move(int x, int y)
	{
		super.move(x,y);

		Control ctrl = _firstControl;

		if (ctrl !is null)
		{
			do
			{
				if (ctrl.isWindowed())
				{
					WindowedControl wctrl = cast(WindowedControl)ctrl;
					wctrl.move(wctrl.getX(), wctrl.getY());
				}

				ctrl = ctrl._nextControl;
			} while (ctrl !is _firstControl)
		}
	}

	int getBaseX()
	{
		return _x;
	}

	int getBaseY()
	{
		return _y;
	}

protected:

	// head and tail of the control linked list
	Control _firstControl = null;	//head
	Control _lastControl = null;	//tail
	int _numControls = 0;

	Control _captured_control = null;
	Control _last_control = null;
	Control _focused_control = null;
}

void WindowRemoveAllControls(ref Window window)
{
	// will go through and remove all of the controls

	Control c = window._firstControl;
	Control tmp;

	if (c is null) { return; }

	do
	{
		tmp = c._nextControl;
		
		c.removeControl();

		c = tmp;
	} while (c !is window._firstControl);

	window._firstControl = null;
	window._lastControl = null;
}

void WindowSetConstraintX(ref Window window, long constraint_x)
{
	window._constraint_x = constraint_x;
}

void WindowSetConstraintY(ref Window window, long constraint_y)
{
	window._constraint_y = constraint_y;
}

long WindowGetConstraintX(ref Window window)
{
	return window._constraint_x;
}

long WindowGetConstraintY(ref Window window)
{
	return window._constraint_y;
}

void WindowCaptureMouse(ref Window window, ref Control control)
{
	window._captured_control = control;

	Scaffold.WindowCaptureMouse(window, &window._pfvars);
}

void WindowReleaseMouse(ref Window window, ref Control control)
{
	if (window._captured_control is control)
	{
		window._captured_control = null;

		Scaffold.WindowReleaseMouse(window, &window._pfvars);
	}
}

View* WindowGetView(ref Window window)
{
	return &window._view;
}

WindowPlatformVars* WindowGetPlatformVars(ref Window window)
{
	return &window._pfvars;
}


void SetWindowXY(ref Window w, int x, int y)
{
	w._x = x;
	w._y = y;
}

void SetWindowX(ref Window w, int x)
{
	w._x = x;
}

void SetWindowY(ref Window w, int y)
{
	w._y = y;
}



void SetWindowSize(ref Window w, uint width, uint height)
{
	w._width = width;
	w._height = height;
}

void SetWindowWidth(ref Window w, uint width)
{
	w._width = width;
}

void SetWindowHeight(ref Window w, uint height)
{
	w._height = height;
}

void CallStateChange(ref Window w, WindowState newState)
{
	w._state = newState;
	w.OnStateChange();
}