/*
 * window.d
 *
 * This module implements a GUI Window class. Widgets can be pushed to this window.
 *
 * Author: Dave Wilkinson
 * Originated: June 24th, 2009
 *
 */

module gui.window;

import gui.widget;
import gui.application;
import gui.menu;

import platform.imports;
mixin(PlatformGenericImport!("vars"));
mixin(PlatformScaffoldImport!());

import graphics.view;
import graphics.graphics;

import core.definitions;
import core.color;
import core.string;
import core.event;
import core.main;
import core.system;

import interfaces.container;

// Description: This class implements and abstracts a common window.  This window is a control container and a view canvas.
class Window : Responder, AbstractContainer
{

public:

	// Constructors

	// Description: Will create the window with certain default parameters
	// windowTitle: The initial title for the window.
	// windowStyle: The initial style for the window.
	// color: The initial color for the window.
	// x: The initial x position of the window.
	// y: The initial y position of the window.
	// width: The initial width of the client area of the window.
	// height: The initial height of the client area of the window.
	this(string windowTitle, WindowStyle windowStyle, Color color, int x, int y, int width, int height)
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
	this(string windowTitle, WindowStyle windowStyle, SystemColor sysColor, int x, int y, int width, int height)
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
		uninitialize();
		remove();
	}

	// Properties

	// Widget Container Margins

	int baseLeft()
	{
		return 0;
	}

	int baseTop()
	{
		return 0;
	}


	// Methods //

	// Description: Will get the title of the window.
	// Returns: The String representing the title.
	String text()
	{
		return new String(_window_title);
	}

	// Description: Will set the title of the window.
	// str: The new title.
	void text(String str)
	{
		_window_title = new String(str);

		if (!_inited) { return; }
		Scaffold.WindowSetTitle(this, &_pfvars);
	}

	// Description: Will set the title of the window.
	// str: The new title.
	void text(string str)
	{
		_window_title = new String(str);

		if (!_inited) { return; }
		Scaffold.WindowSetTitle(this, &_pfvars);
	}

	Window nextWindow() {
		return _nextWindow;
	}

	// Description: Sets the flag to make the window hidden or visible.
	// bShow: Pass true to show the window and false to hide it.
	void visible(bool bShow)
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

			Scaffold.WindowSetVisible(this, &_pfvars, bShow);

			// safe guard:
			// fights off infection from ZOMBIE PROCESSES!!!
			if (app.isZombie())
			{
				app.destroyAllWindows();
				Djehuty.end(0);
			}
		}

		onVisibilityChange();
	}

	// Description: Will return whether or not the window is flagged as hidden or visible.  The window may not actually be visible due to it not being created or added.
	// Returns: It will return true when the window is flagged to be visible and false otherwise.
	bool visible()
	{
		return _visible;
	}

	// Description: Will set the window to take a different state: WindowState.Minimized, WindowState.Maximized, WindowState.Fullscreen, WindowState.Normal
	// state: A WindowState value representing the new state.
	void state(WindowState state)
	{
		if (_state == state) { return; }

		_state = state;

		if (_nextWindow !is null)
		{
			Scaffold.WindowSetState(this, &_pfvars);
		}

		onStateChange();
	}

	// Description: Will return the current state of the window.
	// Returns: The current WindowState value for the window.
	WindowState state()
	{
		return _state;
	}

	// Description: Will set the window to take a different style: WindowStyle.Fixed (non-sizable), WindowStyle.Sizable (resizable window), WindowStyle.Popup (borderless).
	// style: A WindowStyle value representing the new style.
	void style(WindowStyle style)
	{
		if (this.state == WindowState.Fullscreen)
			{ return; }

		_style = style;

		if (_nextWindow !is null)
		{
			Scaffold.WindowSetStyle(this, &_pfvars);
		}
	}

	// Description: Will return the current style of the window.
	// Returns: The current WindowStyle value for the window.
	WindowStyle style()
	{
		return _style;
	}

	// Description: Will return the width of the client area of the window.
	// Returns: The width of the client area of the window.
	uint width()
	{
		if (_state == WindowState.Fullscreen) {
			return System.Display.width;
		}
		return _width;
	}

	// Description: Will return the height of the client area of the window.
	// Returns: The height of the client area of the window.
	uint height()
	{
		if (_state == WindowState.Fullscreen) {
			return System.Display.height;
		}
		return _height;
	}

	// Description: Will return the x coordinate of the window's position in screen coordinates.  Note that this is not the client area, but rather the whole window.
	// Returns: The x position of the top-left corner of the window.
	uint x()
	{
		if (_state == WindowState.Fullscreen) {
			return 0;
		}
		return _x;
	}

	// Description: Will return the y coordinate of the window's position in screen coordinates.  Note that this is not the client area, but rather the whole window.
	// Returns: The y position of the top-left corner of the window.
	uint y()
	{
		if (_state == WindowState.Fullscreen) {
			return 0;
		}
		return _y;
	}

	// Methods

	// Description: Will attempt to destroy the window and its children.  It will be removed from the hierarchy.
	void remove()
	{
		if (!_inited) { return; }

		// the window was added
		// destroy

		// TODO: Fire the event, and allow confirmation
		// TODO: Add a FORCE DESTROY function method

		_inited = false;

		Scaffold.WindowDestroy(this, &_pfvars);
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
			Scaffold.WindowRebound(this, &_pfvars);
		}

		onResize();
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
			Scaffold.WindowReposition(this, &_pfvars);
		}

		onMove();
	}

	void ClientToScreen(ref int x, ref int y)
	{
		if (_inited == false) { return; }
		Scaffold.WindowClientToScreen(this, &_pfvars, x, y);
	}

	void ClientToScreen(ref Coord pt)
	{
		if (_inited == false) { return; }
		Scaffold.WindowClientToScreen(this, &_pfvars, pt);
	}

	void ClientToScreen(ref Rect rt)
	{
		if (_inited == false) { return; }
		Scaffold.WindowClientToScreen(this, &_pfvars, rt);
	}

	Window parent()
	{
		return _parent;
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
		window.onInitialize();

		// call the onAdd event of the new window
		window.onAdd();*/

		//PrintChildWindowList(this);
	}

	// Events //

	// Description: This event will be called when the window is added to the window hierarchy.
	void onAdd()
	{
	}

	// Description: This event will be called when the window is removed from the window hierarchy.
	void onRemove()
	{
	}

	// Description: This event is called when the mouse wheel is scrolled vertically (the common scroll method).
	// amount: the number of standard 'ticks' that the scroll wheel makes
	void onMouseWheelY(uint amount)
	{
	}

	// Description: This event is called when the mouse wheel is scrolled horizontally.
	// amount: the number of standard 'ticks' that the scroll wheel makes
	void onMouseWheelX(uint amount)
	{
	}

	// Description: This event is called when the mouse enters the client area of the window
	void onMouseEnter()
	{
	}

	// Description: This event is called when the window is moved, either from the OS or the move() function.
	void onMove()
	{
	}

	// Description: This event is called when the window is hidden or shown.
	void onVisibilityChange()
	{
	}

	// Description: This event is called when the window is maximized, minimized, put into fullscreen, or restored.
	void onStateChange()
	{
	}

	// Description: This event is called when a menu item belonging to the window is activated.
	// mnu: A reference to the menu that was activated.
	void onMenu(Menu mnu)
	{
	}

	void onInitialize()
	{
		_view = new WindowView;
		_viewVars = _view.createForWindow(this, &_pfvars);
	}

	void onUninitialize()
	{
		_view.destroy();
		_view = null;
	}

	void onDraw()
	{
		if (_view !is null)
		{
			Graphics g = _view.lockDisplay();

			Scaffold.WindowStartDraw(this, &_pfvars, _view, *_viewVars);

			Widget c = _firstControl;

			if (c !is null)
			{
				do
				{
					c =	c._prevControl;

					c.onDraw(g);
				} while (c !is _firstControl)
			}

			Scaffold.WindowEndDraw(this, &_pfvars, _view, *_viewVars);

			_view.unlockDisplay();
		}
	}

	void onKeyChar(dchar keyChar)
	{
		// dispatch to focused control
		if (_focused_control !is null)
		{
			if (_focused_control.onKeyChar(keyChar))
			{
				onDraw();
			}
		}
	}

	void onKeyDown(uint keyCode)
	{
		// dispatch to focused control
		if (_focused_control !is null)
		{
			if (_focused_control.onKeyDown(keyCode))
			{
				onDraw();
			}
		}
	}

	void onKeyUp(uint keyCode)
	{
		// dispatch to focused control
		if (_focused_control !is null)
		{
			if (_focused_control.onKeyUp(keyCode))
			{
				onDraw();
			}
		}
	}

	void onMouseLeave()
	{
		if (_last_control !is null)
		{
			_last_control._hovered = false;
			if(_last_control.onMouseLeave())
			{
				onDraw();
			}
			_last_control = null;
		}
	}

	void onMouseMove()
	{
		//select the control to send the message to
		Widget control;

		if (_captured_control !is null)
		{
			control = _captured_control;

			if (controlAtPoint(mouseProps.x, mouseProps.y) is control && control.visible) {
				//within bounds of control
				if (!control._hovered) {
					//currently, hover state says control is outside
					control._hovered = true;
					if (control.onMouseEnter() | control.onMouseMove(mouseProps)) {
						onDraw();
					}
				}
				else if (control.onMouseMove(mouseProps)) {
					onDraw();
				}
			}
			else {
				//outside bounds of control
				if (control._hovered) {
					//currently, hover state says control is inside
					control._hovered = false;
					if (control.onMouseLeave() | control.onMouseMove(mouseProps)) {
						onDraw();
					}
				}
				else if (control.onMouseMove(mouseProps)) {
					onDraw();
				}
			}

			//change the cursor to reflect the new control
			//Scaffold.ChangeCursor(window->captured_control->ctrl_info.ctrl_cursor);


		}	// no control that has captured the mouse input
		else if ((control = controlAtPoint(mouseProps.x, mouseProps.y)) !is null) {
			//when there is a control to pass a MouseLeave to...
			if (_last_control !is control && _last_control !is null) {
				control._hovered = true;
				_last_control._hovered = false;

				if(_last_control.onMouseLeave() |
					control.onMouseEnter() | control.onMouseMove(mouseProps)) {
					onDraw();
				}
			} //otherwise, there is just one control to worry about
			else {
				if(!control._hovered) {
					//wasn't hovered over before
					control._hovered = true;
					if(control.onMouseEnter() | control.onMouseMove(mouseProps)) {
						onDraw();
					}
				}
				else if(control.onMouseMove(mouseProps)) {
					onDraw();
				}
			}

			//change the cursor to reflect the new control
			//Scaffold.ChangeCursor(index->ctrl_cursor);

			_last_control = control;

		}
		else {
			//mouse is on window, not control

			if (_last_control !is null) {
				_last_control._hovered = false;
				if(_last_control.onMouseLeave()) {
					onDraw();
				}
				_last_control = null;
			}
		}
	}

	// Description: Called when the primary mouse button (usually the left button) is pressed.
	void onPrimaryMouseDown() {
		Widget target;
		bool ret = mouseEventCommon(target);

		_captured_control = target;

		if((target !is null) && (ret | target.onPrimaryMouseDown(mouseProps))) {
			onDraw();
		}
	}

	// Description: Called when the primary mouse button (usually the left button) is released.
	void onPrimaryMouseUp() {
		Widget target;
		bool ret = mouseEventCommon(target);

		_captured_control = null;

		if((target !is null) && (ret | target.onPrimaryMouseUp(mouseProps))) {
			onDraw();
		}
	}

	// Description: Called when the secondary mouse button (usually the right button) is pressed.
	void onSecondaryMouseDown() {
		Widget target;
		bool ret = mouseEventCommon(target);

		_captured_control = target;

		if((target !is null) && (ret | target.onSecondaryMouseDown(mouseProps))) {
			onDraw();
		}
	}

	// Description: Called when the secondary mouse button (usually the right button) is released.
	void onSecondaryMouseUp() {
		Widget target;
		bool ret = mouseEventCommon(target);

		_captured_control = null;

		if((target !is null) && (ret | target.onSecondaryMouseUp(mouseProps))) {
			onDraw();
		}
	}

	// Description: Called when the tertiary mouse button (usually the middle button) is pressed.
	void onTertiaryMouseDown() {
		Widget target;
		bool ret = mouseEventCommon(target);

		_captured_control = target;

		if((target !is null) && (ret | target.onTertiaryMouseDown(mouseProps))) {
			onDraw();
		}
	}

	// Description: Called when the tertiary mouse button (usually the middle button) is released.
	void onTertiaryMouseUp() {
		Widget target;
		bool ret = mouseEventCommon(target);

		_captured_control = null;

		if((target !is null) && (ret | target.onTertiaryMouseUp(mouseProps))) {
			onDraw();
		}
	}

	// Description: This event is called when another uncommon mouse button is pressed down over the window.
	// button: The identifier of this button.
	void onOtherMouseDown(uint button) {
		Widget target;
		bool ret = mouseEventCommon(target);

		_captured_control = target;

		if((target !is null) && (ret | target.onOtherMouseDown(mouseProps, button))) {
			onDraw();
		}
	}

	// Description: This event is called when another uncommon mouse button is released over the window.
	// button: The identifier of this button.
	void onOtherMouseUp(uint button) {
		Widget target;
		bool ret = mouseEventCommon(target);

		_captured_control = null;

		if((target !is null) && (ret | target.onOtherMouseUp(mouseProps, button))) {
			onDraw();
		}
	}

	void onResize() {
		Scaffold.ViewResizeForWindow(_view, *_viewVars, this, &_pfvars);

		onDraw();
	}

	void onLostFocus() {
		//currently focused control will lose focus
		if (_focused_control !is null) {
			_focused_control._focused = false;
			if (_focused_control.onLostFocus(true)) {
				onDraw();
			}
		}
	}

	void onGotFocus() {
		//currently focused control will regain focus
		if (_focused_control !is null) {
			_focused_control._focused = true;
			if (_focused_control.onGotFocus(true)) {
				onDraw();
			}
		}
	}

	// Methods //

	// Description: This will retreive the current window color.
	// Returns: The color currently associated with the window.
	Color color() {
		return _color;
	}

	// Description: This will set the current window color.
	// color: The color to associate with the window.
	void color(ref Color clr) {
		_color = clr;
	}

	// Description: This will set the current window color to a specific platform color.
	// sysColor: The system color index to associate with the window.
	void color(SystemColor clr) {
		Scaffold.ColorGetSystemColor(_color, clr);
	}

	// Description: This will force a redraw of the entire window.
	void redraw() {
		onDraw();
	}

	// Widget Maintenance //

	// Description: This function will return the visible control at the point given.
	// x: The x coordinate to start the search.
	// y: The y coordinate to start the search.
	// Returns: The top-most visible control at the point (x,y) or null.
	Widget controlAtPoint(int x, int y) {
		Widget ctrl = _firstControl;

		if (ctrl !is null) {
			do {
				if (ctrl.containsPoint(x,y) && ctrl.visible) {
					if (ctrl.isContainer()) {
						Widget innerCtrl = (cast(AbstractContainer)ctrl).controlAtPoint(x,y);
						if (innerCtrl !is null) { return innerCtrl; }
					}
					else {
						return ctrl;
					}
				}
				ctrl = ctrl._nextControl;
			} while (ctrl !is _firstControl)
		}

		return null;
	}

	override void push(Dispatcher dsp) {
		if (cast(Widget)dsp !is null) {
			Widget control = cast(Widget)dsp;

			// do not add a control that is already part of another window
			if (control.parent !is null) { return; }

			// Set the window it belongs to
			control._window = this;

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
			control.onAdd();

			return;
		}

		super.push(dsp);
	}

	// Description: Removes the control as long as this control is a part of the current window.
	// control: A reference to the control that should be removed from the window.
	void removeControl(Widget control) {
		if (control.isOfWindow(this)) {
			if (_firstControl is null && _lastControl is null) {
				// it is the last control
				_firstControl = null;
				_lastControl = null;
			}
			else {
				// is it not the last control

				if (_firstControl is control) {
					_firstControl = _firstControl._nextControl;
				}

				if (_lastControl is control) {
					_lastControl = _lastControl._prevControl;
				}

				control.removeControl;
			}

			_numControls--;
		}
	}

	void removeAll() {
		// will go through and remove all of the controls

		Widget c = _firstControl;
		Widget tmp;

		if (c is null) { return; }

		do {
			tmp = c._nextControl;

			c.removeControl();

			c = tmp;
		} while (c !is _firstControl);

		_firstControl = null;
		_lastControl = null;
	}

	// Menus //

	// Description: Sets the menu for the window.  This menu's subitems will be displayed typically as a menu bar.
	// mnuMain: A Menu object representing the main menu for the window.  Pass null to have no menu.
	void menu(Menu mnuMain) {
		_mainMenu = mnuMain;

		if (mnuMain is null) {
			// remove the menu
		}
		else {
			// Switch out and apply the menu

			// platform specific
			MenuPlatformVars mnuVars = MenuGetPlatformVars(mnuMain);
			Scaffold.WindowSetMenu(mnuMain, mnuVars, this, &_pfvars);
		}
	}

	// Description: Gets the current menu for the window.  It will return null when no menu is available.
	// Returns: The Menu object representing the main menu for the window.
	Menu menu() {
		return _mainMenu;
	}

	// public properties

	Mouse mouseProps;

protected:

	final bool mouseEventCommon(out Widget target) {
		if (_captured_control !is null) {
			target = _captured_control;
		}
		else if ((target = controlAtPoint(mouseProps.x, mouseProps.y)) !is null) {
			bool ret = false;

			//consider the focus of the control
			if(_focused_control !is target) {
				if (_focused_control !is null) {
					//the current focused control gets unfocused
					_focused_control._focused = false;
					ret = _focused_control.onLostFocus(false);
				}

				//focus this control
				_focused_control = target;
				_focused_control._focused = true;

				ret |= _focused_control.onGotFocus(false);
			}

			return ret;

			//change the cursor to reflect the new control
			//Scaffold.ChangeCursor(index->ctrl_cursor);
		}

		return false;
	}

	package final void uninitialize() {
		if (_nextWindow is null) { return; }

		onRemove();

		removeAll();

		_prevWindow._nextWindow = _nextWindow;
		_nextWindow._prevWindow = _prevWindow;

		// destroy the window's view object
		onUninitialize();

		GuiApplication app = cast(GuiApplication)responder;

		if (app._windowListHead is this && app._windowListTail is this) {
			app._windowListHead = null;
			app._windowListTail = null;
		}
		else {
			if (app._windowListHead is this) {
				app._windowListHead = app._windowListHead._nextWindow;
			}

			if (app._windowListTail is this) {
				app._windowListTail = app._windowListHead._prevWindow;
			}
		}

		_nextWindow = null;
		_prevWindow = null;

		// Decrement Window length
		app._windowCount--;

		// Check to see if this was invisible
		if (_visible) {
			// Decrement Window Visible length
			app._windowVisibleCount--;

			// If there are no visible windows, quit (for now)
			if (app.isZombie()) {
				// just kill the app
				app.destroyAllWindows();
				Djehuty.end(0);
			}
		}

		// is it a parent window of some kind?
		// destroy and uninitialize all children
		if (_firstChild !is null) {
			Window child = _firstChild;

			do {
				child.remove();
				child = child._nextSibling;
			} while (child !is _firstChild)
		}

		// is it a child window of some kind?
		// unlink it within the sibling list
		if (_parent !is null) {
			Window p = _parent;

			p._numChildren--;

			_prevSibling._nextSibling = _nextSibling;
			_nextSibling._prevSibling = _prevSibling;

			if (p._firstChild is this && p._lastChild is this) {
				// unreference this, the last child
				// the parent now has no children
				p._firstChild = null;
				p._lastChild = null;
			}
			else {
				if (p._firstChild is this) {
					p._firstChild = p._firstChild._nextSibling;
				}

				if (p._lastChild is this) {
					p._lastChild = p._lastChild._prevSibling;
				}
			}
		}

		_parent = null;
		_nextSibling = null;
		_prevSibling = null;
		_firstChild = null;
		_lastChild = null;
	}

	package WindowView _view = null;
	package ViewPlatformVars* _viewVars;

	Color _color;

	// imposes left and top margins on the window, when set
	long _constraint_x = 0;
	long _constraint_y = 0;

	String _window_title;
	package uint _width, _height;
	package uint _x, _y;

	package WindowStyle _style;
	package WindowState _state;

private:

	// head and tail of the control linked list
	Widget _firstControl = null;	//head
	Widget _lastControl = null;	//tail
	int _numControls = 0;

	Widget _captured_control = null;
	Widget _last_control = null;
	Widget _focused_control = null;

	Menu _mainMenu = null;

	// linked list implementation
	// to keep track of all windows
	package Window _nextWindow = null;
	package Window _prevWindow = null;

	// children windows will follow suit:
	Window _firstChild = null;	//head
	Window _lastChild = null;	//tail

	uint _numChildren = 0; // child count

	// parent is null when it is a root window
	Window _parent = null;

	// these may be null when it is an only child
	Window _nextSibling = null;
	Window _prevSibling = null;

	package bool _visible = false;
	bool _fullscreen = false;

	package bool _inited = false;

	package WindowPlatformVars _pfvars;
}

// Definition: This is a View that defines the graphical client area of a Window.
class WindowView : View {

	this() {
		super();
	}

	override void create(int width, int height) {
	}

	override void CreateDIB(int width, int height) {
	}

protected:

	override void _platformCreate() {
		Scaffold.ViewCreateForWindow(this, _pfvars, _window, _windowVars);
	}

private:

	ViewPlatformVars* createForWindow(Window window, WindowPlatformVars* windowVars) {
		_window = window;
		_windowVars = windowVars;
		View.create(window.width, window.height);
		
		return &_pfvars;
	}

	Window _window;
	WindowPlatformVars* _windowVars;
}