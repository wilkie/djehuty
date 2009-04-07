module controls.container;

import interfaces.container;
import bases.windowedcontrol;

import core.window;
import core.control;
import core.color;
import core.definitions;
import core.string;
import core.graphics;

// Section: Controls

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
				c =	ControlGetPrevious(c);

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
		Window wnd = getParent();
		ControlAdd(control, wnd, _view, this);
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

				ctrl = ControlGetNext(ctrl);
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

