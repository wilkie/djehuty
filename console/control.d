module console.control;

import platform.imports;
mixin(PlatformGenericImport!("console"));

import core.string;
import core.main;
import core.definitions;

import console.main;
import console.window;

// Section: Console

// Description: This class abstracts part of the console's screen.  When attached to a window, this class will receive input through the events.  Keyboard events will be passed only when the control is activated.  A control can decide not to be activatable by setting it's _isTabStop to false.
class ConsoleControl
{


	// Events


	void OnInit()
	{
	}

	void OnAdd()
	{
	}

	void OnRemove()
	{
	}



	void OnGotFocus()
	{
	}

	void OnLostFocus()
	{
	}



	void OnResize()
	{
	}



	void OnKeyDown(uint keyCode)
	{
	}

	void OnKeyChar(dchar keyChar)
	{
	}

	void OnKeyUp(uint keyCode)
	{
	}



	void OnPrimaryMouseDown()
	{
	}

	void OnPrimaryMouseUp()
	{
	}

	void OnSecondaryMouseDown()
	{
	}

	void OnSecondaryMouseUp()
	{
	}

	void OnTertiaryMouseDown()
	{
	}

	void OnTertiaryMouseUp()
	{
	}

	void OnMouseWheelY(int amount)
	{
	}

	void OnMouseWheelX(int amount)
	{
	}

	void OnMouseMove()
	{
	}

protected:
	// control list
	ConsoleControl _nextControl;
	ConsoleControl _prevControl;

	ConsoleWindow _window;

	bool _isTabStop = false;
}

void ControlAdd(ref ConsoleControl ctrl, ref ConsoleWindow wind)
{
	ctrl._window = wind;
}

void ControlUpdateList(ref ConsoleControl ctrl, ref ConsoleControl next, ref ConsoleControl prev)
{
	ctrl._nextControl = next;
	ctrl._prevControl = prev;
}

void ControlSetPrevious(ref ConsoleControl ctrl, ref ConsoleControl prev)
{
	ctrl._prevControl = prev;
}

bool ControlIsTabStop(ref ConsoleControl ctrl)
{
	return ctrl._isTabStop;
}


void ControlSetNext(ref ConsoleControl ctrl, ref ConsoleControl next)
{
	ctrl._nextControl = next;
}

ConsoleControl ControlGetPrevious(ref ConsoleControl ctrl)
{
	return ctrl._prevControl;
}
ConsoleControl ControlGetNext(ref ConsoleControl ctrl)
{
	return ctrl._nextControl;
}


//DJEHUTYDOC

//CONSOLE:ConsoleControl
//EXTENDS:Object
//DESC:

//EVENTS


//NAME:OnKeyDown(uint keyCode)
//DESC:Called when the control is focused during a key press.
//PARAM:keyCode
//DESC:The ID of the code.
//RETURNS:bool
//DESC:Return true when the control should be redrawn.

//NAME:OnKeyUp(uint keyCode)
//DESC:Called when the control is focused during a key release.
//PARAM:keyCode
//DESC:The ID of the code.
//RETURNS:bool
//DESC:Return true when the control should be redrawn.

//NAME:OnKeyChar(dchar keyChar)
//DESC:Called when the control is focused during a key press that results in a printable character.
//PARAM:keyChar
//DESC:The character in standard UTF-32.
//RETURNS:bool
//DESC:Return true when the control should be redrawn.



//ENDDJEHUTYDOC
