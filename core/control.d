/*
 * control.d
 *
 * This file contains the magic behind a Control class.
 *
 * Author: Dave Wilkinson
 *
 */

module core.control;

import core.window;
import core.view;
import core.definitions;
import core.literals;
import core.graphics;

import interfaces.container;

import platform.imports;
mixin(PlatformGenericPublicImport!("vars"));

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

// Section: Core

// Description: This class implements and abstracts a control, which is a special container that can be drawn and added to a Window.  The control receives many events for different tasks, and allows reusable components within the static version of an application.
class Control
{

	// Deconstructor //

	~this()
	{
		remove();
	}




	// Events //



	// Description: Called when the control is added to a Window.
	void OnAdd()
	{
	}


	// Description: Called when the control is removed from its parent window.
	void OnRemove()
	{
	}


	// Description: Called when the control should be redrawn.
	// g: The graphics object that has already been locked.  Use this to draw primitives to the window.
	void OnDraw(ref Graphics g)
	{
	}


	// Description: Called when the primary mouse button (usually the left button) is pressed.
	// mouseProps: A convenient reference to the window's Mouse structure, describing the mouse state.
	// Returns: The user should return true when the control should be redrawn.
	bool OnPrimaryMouseDown(ref Mouse mouseProps)
	{
		return false;
	}


	// Description: Called when the primary mouse button (usually the left button) is released.
	// mouseProps: A convenient reference to the window's Mouse structure, describing the mouse state.
	// Returns: The user should return true when the control should be redrawn.
	bool OnPrimaryMouseUp(ref Mouse mouseProps)
	{
		return false;
	}


	// Description: Called when the secondary mouse button (usually the right button) is pressed.
	// mouseProps: A convenient reference to the window's Mouse structure, describing the mouse state.
	// Returns: The user should return true when the control should be redrawn.
	bool OnSecondaryMouseDown(ref Mouse mouseProps)
	{
		return false;
	}


	// Description: Called when the secondary mouse button (usually the right button) is released.
	// mouseProps: A convenient reference to the window's Mouse structure, describing the mouse state.
	// Returns: The user should return true when the control should be redrawn.
	bool OnSecondaryMouseUp(ref Mouse mouseProps)
	{
		return false;
	}


	// Description: Called when the tertiary mouse button (usually the middle button) is pressed.
	// mouseProps: A convenient reference to the window's Mouse structure, describing the mouse state.
	// Returns: The user should return true when the control should be redrawn.
	bool OnTertiaryMouseDown(ref Mouse mouseProps)
	{
		return false;
	}


	// Description: Called when the tertiary mouse button (usually the middle button) is released.
	// mouseProps: A convenient reference to the window's Mouse structure, describing the mouse state.
	// Returns: The user should return true when the control should be redrawn.
	bool OnTertiaryMouseUp(ref Mouse mouseProps)
	{
		return false;
	}

	// Description: Called when some other atypical mouse button is pressed.
	// mouseProps: A convenient reference to the window's Mouse structure, describing the mouse state.
	// button: An index of the alternate button.
	// Returns: The user should return true when the control should be redrawn.
	bool OnOtherMouseDown(ref Mouse mouseProps, uint button)
	{
		return false;
	}


	// Description: Called when some other atypical mouse button is released.
	// mouseProps: A convenient reference to the window's Mouse structure, describing the mouse state.
	// button: An index of the alternate button.
	// Returns: The user should return true when the control should be redrawn.
	bool OnOtherMouseUp(ref Mouse mouseProps, uint button)
	{
		return false;
	}

	// Description: Called when the mouse cursor enters within the bounds of the control.
	// Returns: The user should return true when the control should be redrawn.
	bool OnMouseEnter()
	{
		return false;
	}

	// Description: Called when the mouse cursor leaves the bounds of the control.
	// Returns: The user should return true when the control should be redrawn.
	bool OnMouseLeave()
	{
		return false;
	}

	// Description: Called when the mouse moves within the bounds of the control.
	// mouseProps: A convenient reference to the window's Mouse structure, describing the mouse state.
	// Returns: The user should return true when the control should be redrawn.
	bool OnMouseMove(ref Mouse mouseProps)
	{
		return false;
	}

	// Description: Called when the control receives focus.
	// bWasWindow: When true, the window received focus as well.
	// Returns: The user should return true when the control should be redrawn.
	bool OnGotFocus(bool bWasWindow)
	{
		return false;
	}

	// Description: Called when the control loses focus.
	// bWasWindow: When true, the window lost focus as well.
	// Returns: The user should return true when the control should be redrawn.
	bool OnLostFocus(bool bWasWindow)
	{
		return false;
	}

	// Description: Called when the control is focused during a key press.
	// keyCode: The ID of the code.
	// Returns: The user should return true when the control should be redrawn.
	bool OnKeyDown(uint keyCode)
	{
		return false;
	}

	// Description: Called when the control is focused during a key release.
	// keyCode: The ID of the code.
	// Returns: The user should return true when the control should be redrawn.
	bool OnKeyUp(uint keyCode)
	{
		return false;
	}

	// Description: Called when the control is focused during a key press that results in a printable character.
	// keyChar: The character in standard UTF-32.
	// Returns: The user should return true when the control should be redrawn.
	bool OnKeyChar(dchar keyChar)
	{
		return false;
	}



	// Methods

	// Description: Will return a boolean indictating whether or not the window given is the parent window.
	// window: The window to determine if it is the parent.
	// Returns: Will return true if the owning window is the same as the one passed by the parameter.
	bool isOfWindow(ref Window window)
	{
		if (_window is window)
		{
			return true;
		}

		return false;
	}

	// Description: Will return a boolean indictating whether or not the container given is the parent container.
	// container: The container to determine if it is the parent.
	// Returns: Will return true if the owning container is the same as the one passed by the parameter.
	bool isOfContainer(AbstractContainer container)
	{
		if (_container is container)
		{
			return true;
		}

		return false;
	}

	// Description: Will return a reference to the parent window that owns this control.
	// Returns: The reference to the current window object that owns this control instance.
	Window getParent()
	{
		return _window;
	}

	// Description: Will remove this control to whatever it has been added to.
	void remove()
	{
		if (_window is null) { return; }
		if (_nextControl is null) { return; }

		_window.removeControl(this);
	}

	// Description: Will return a boolean value describing whether the point is within the region occupied by the control.
	// Returns: Will return true when the point is within the region.
	bool containsPoint(int x, int y)
	{
		if (_x < x && _y < y &&
			_b > y && _r > x)
		{
			return true;
		}

		return false;
	}

	// Description: Will return the flag that determines whether or not the control is visible (ie. drawn).
	// Returns: If true, the control is currently visible.  If false, the control is currently hidden.
	bool getVisibility()
	{
		return _visible;
	}

	// Description: Will set the flag to mark the control either visible or hidden.
	// bVisible: Passing true would mark this control to be drawn, passing false will mark this control as hidden and not drawn.
	void setVisibility(bool bVisible)
	{
		_visible = bVisible;
	}


	// Control type information

	bool isContainer()
	{
		return false;
	}

	bool isWindowed()
	{
		return false;
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

	void RequestCapture()
	{
		if (_window !is null)
		{
			WindowCaptureMouse(_window, this);
		}
	}

	void RequestRelease()
	{
		if (_window !is null)
		{
			WindowReleaseMouse(_window, this);
		}
	}

private:

	// control list
	Control _nextControl;
	Control _prevControl;
}












void ControlAdd(ref Control ctrl, ref Window window, ref View view)
{
	// set the control's parent
	ctrl._window = window;
	ctrl._view = view;
	ctrl._container = window;

	// call the control's event
	ctrl.OnAdd();
}

void ControlAdd(ref Control ctrl, ref Window window, ref View view, AbstractContainer absCont)
{
	// set the control's parent
	ctrl._window = window;
	ctrl._view = view;
	ctrl._container = absCont;

	// call the control's event
	ctrl.OnAdd();
}




void ControlPrintList(ref Control ctrl)
{
	Control c = ctrl;

	//printf("::");

	if (c is null)
	{
	//	printf("null::\n");
		return;
	}

	do
	{
	//	printf("%x ", c);
		c = c._nextControl;
	}
	while (c !is ctrl);

	//printf("::\n");
}

void ControlUpdateList(ref Control ctrl, ref Control next, ref Control prev)
{
	ctrl._nextControl = next;
	ctrl._prevControl = prev;
}

void ControlSetPrevious(ref Control ctrl, ref Control prev)
{
	ctrl._prevControl = prev;
}

void ControlSetNext(ref Control ctrl, ref Control next)
{
	ctrl._nextControl = next;
}

Control ControlGetPrevious(ref Control ctrl)
{
	return ctrl._prevControl;
}

Control ControlGetNext(ref Control ctrl)
{
	return ctrl._nextControl;
}




bool ControlGetHovered(ref Control ctrl)
{
	return ctrl._hovered;
}

void ControlSetHovered(ref Control ctrl, bool bHover)
{
	ctrl._hovered = bHover;
}


void ControlSetFocus(ref Control ctrl, bool bFocus)
{
	ctrl._focused = bFocus;
}


void ControlCallDraw(ref Control ctrl, ref Graphics g)
{
	ctrl.OnDraw(g);
}

void ControlCallRemove(ref Control ctrl)
{
	ctrl.OnRemove();

	ctrl._view = null;
	ctrl._window = null;

	ctrl._nextControl = null;
	ctrl._prevControl = null;
}
