
// defines a window that acts as a control container
module core.window;

import platform.imports;
mixin(PlatformGenericImport!("vars"));
mixin(PlatformScaffoldImport!());

import core.definitions;

import interfaces.container;

import bases.window;

import core.control;
import core.view;
import core.string;
import core.menu;
import core.graphics;
import core.color;

import core.literals;

import console.main;

// Section: Core

// Description: This class implements and abstracts a common window.  This window is a control container and a view canvas.
class Window : BaseWindow, AbstractContainer
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
		super(windowTitle, windowStyle, x, y, width, height);

		_pfvars._hasView = true;
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
		super(windowTitle, windowStyle, x, y, width, height);

		_pfvars._hasView = true;
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
		super(windowTitle, windowStyle, x, y, width, height);

		_pfvars._hasView = true;
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
		super(windowTitle, windowStyle, x, y, width, height);

		_pfvars._hasView = true;
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


	// Events //


	// Description: This event is called when a menu item belonging to the window is activated.
	// mnu: A reference to the menu that was activated.
	void OnMenu(Menu mnu)
	{
	}

	// Overriden events //

	override void OnInitialize()
	{
		_view = new View;

		ViewCreateForWindow(_view, this);
	}

	override void OnUninitialize()
	{
		_view.destroy();
		_view = null;
	}

	override void OnDraw()
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
					c =	ControlGetPrevious(c);

					c.OnDraw(g);
				} while (c !is _firstControl)
			}

			Scaffold.WindowEndDraw(this, &_pfvars, _view, *viewVars);

			_view.unlockDisplay();
		}
	}

	override void OnKeyChar(dchar keyChar)
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

	override void OnKeyDown(uint keyCode)
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

	override void OnKeyUp(uint keyCode)
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

	override void OnMouseLeave()
	{
		if (_last_control !is null)
		{
			ControlSetHovered(_last_control, false);
			if(_last_control.OnMouseLeave())
			{
				OnDraw();
			}
			_last_control = null;
		}
	}

	override void OnMouseMove()
	{
		//select the control to send the message to
		Control control;

		if (_captured_control !is null)
		{
			control = _captured_control;

			if (control.containsPoint(mouseProps.x, mouseProps.y) && control.getVisibility())
			{
				//within bounds of control
				if (!ControlGetHovered(control))
				{
					//currently, hover state says control is outside
					ControlSetHovered(control, true);
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
				if (ControlGetHovered(control))
				{
					//currently, hover state says control is inside
					ControlSetHovered(control, false);
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
				ControlSetHovered(control, true);
				ControlSetHovered(_last_control, false);

				if(_last_control.OnMouseLeave() |
					control.OnMouseEnter() | control.OnMouseMove(mouseProps))
				{
					OnDraw();
				}
			} //otherwise, there is just one control to worry about
			else
			{
				if(!ControlGetHovered(control))
				{	//wasn't hovered over before
					ControlSetHovered(control, true);
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
				ControlSetHovered(_last_control, false);
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

		`override void On` ~ type ~ `(` ~ otherDecl ~ `)
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
						ControlSetFocus(_focused_control, false);
						ret = _focused_control.OnLostFocus(false);
					}

					//focus this control
					_focused_control = control;
					ControlSetFocus(_focused_control, true);

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

	mixin(WindowOnMouse!("PrimaryMouseDown","", ""));
	mixin(WindowOnMouse!("SecondaryMouseDown","", ""));
	mixin(WindowOnMouse!("TertiaryMouseDown","", ""));
	mixin(WindowOnMouse!("PrimaryMouseUp","", ""));
	mixin(WindowOnMouse!("SecondaryMouseUp","", ""));
	mixin(WindowOnMouse!("TertiaryMouseUp","", ""));
	mixin(WindowOnMouse!("OtherMouseDown","uint button", ", button"));
	mixin(WindowOnMouse!("OtherMouseUp","uint button", ", button"));

	override void OnResize()
	{
		ViewResizeForWindow(_view, this);

		OnDraw();
	}

	override void OnLostFocus()
	{
		//currently focused control will lose focus
		if (_focused_control !is null)
		{
			ControlSetFocus(_focused_control, false);
			if (_focused_control.OnLostFocus(true))
			{
				OnDraw();
			}
		}
	}

	override void OnGotFocus()
	{
		//currently focused control will regain focus
		if (_focused_control !is null)
		{
			ControlSetFocus(_focused_control, true);
			if (_focused_control.OnGotFocus(true))
			{
				OnDraw();
			}
		}
	}

	// Methods //


	// Description: This will retreive the current window color.
	// Returns: The color currently associated with the window.
	Color getColor()
	{
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
				ctrl = ControlGetNext(ctrl);
			} while (ctrl !is _firstControl)
		}

		return null;
	}

	// Description: Adds the control (that has not been added elsewhere) to the window.  Calls the OnAdd() event of the control.
	// control: A reference to the control to be added to the window.
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

			ControlUpdateList(control, control, control);
		}
		else
		{
			// next control

			ControlUpdateList(control, _firstControl, _lastControl);

			ControlSetPrevious(_firstControl, control);
			ControlSetNext(_lastControl, control);

			_firstControl = control;
		}

		//ControlPrintList(_firstControl);

		// increase the number of controls
		_numControls++;

		// call a function initializing a control on the control's end
		ControlAdd(control, this, _view);
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
					_firstControl = ControlGetNext(_firstControl);
				}

				if (_lastControl is control)
				{
					_lastControl = ControlGetPrevious(_lastControl);
				}

				ControlCallRemove(control);
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

protected:

	View _view = null;

	Color _color;

	// imposes left and top margins on the window, when set
	long _constraint_x = 0;
	long _constraint_y = 0;

private:

	// head and tail of the control linked list
	Control _firstControl = null;	//head
	Control _lastControl = null;	//tail
	int _numControls = 0;

	Control _captured_control = null;
	Control _last_control = null;
	Control _focused_control = null;

	Menu _mainMenu = null;
}





















void WindowRemoveAllControls(ref Window window)
{
	// will go through and remove all of the controls

	Control c = window._firstControl;
	Control tmp;

	if (c is null) { return; }

	do
	{
		tmp = ControlGetNext(c);
		ControlCallRemove(c);
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
