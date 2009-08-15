module resource.menu;

import core.string;
import core.definitions;

import io.console;

import platform.vars.menu;

import scaffold.menu;
import scaffold.window;

// Section: Core/Resources

// Description: This class provides an abstract to a dropdown menu.  The Window class uses this to provide a menubar for a window.
class Menu {

	// -- constructors -- //

	this(string text, Menu[] submenus = null) {
		_value = new String(text);

		// Get the working text
		_updateDisplay();

		if (submenus is null || submenus.length == 0) {
			_subitems = null;
		}
		else {
			_subitems = new Menu[submenus.length];
			_subitems[0..$] = submenus[0..$];
		}

		MenuCreate(&_pfvars);

		foreach(mnu ; _subitems) {
			mnu._addParent(this);
			MenuAppend(cast(void*)this, &_pfvars, &mnu._pfvars, mnu.text, (mnu.length > 0));
		}
	}

	this(String text, Menu[] submenus = null) {
		_value = new String(text);

		// Get the working text
		_updateDisplay();

		if (submenus is null || submenus.length == 0) {
			_subitems = null;
		}
		else {
			_subitems = new Menu[submenus.length];
			_subitems[0..$] = submenus[0..$];
		}

		MenuCreate(&_pfvars);

		foreach(mnu ; _subitems) {
			mnu._addParent(this);
			MenuAppend(cast(void*)this, &_pfvars, &mnu._pfvars, mnu.text, (mnu.length > 0));
		}
	}

	// -- destructor -- //

	~this() {
		// remove all descendants
		_subitems = null;

		// platform specific destroy
		MenuDestroy(&_pfvars);
	}
	
	bool isChildOf(Menu mnu) {
		foreach (parent; _parents) {
			if (mnu is parent) {
				return true;
			}
		}
		return false;
	}

	// -- Properties -- //

	void text(String newValue) {
		_value = new String(newValue);

		_updateItem();
	}

	void text(string newValue) {
		_value = new String(newValue);

		_updateItem();
	}

	String text() {
		return _value;
	}
	
	String displayText() {
		return _displayValue;
	}
	
	int hintPosition() {
		return _hintPosition;
	}

	uint length() {
		if (_subitems is null) { return 0; }

		return _subitems.length;
	}

	void append(Menu inMenu) {
		if (inMenu._checkForRecursive(this)) { return; }

		_subitems ~= inMenu;

		Console.put(_parents);
		inMenu._addParent(this);

		// for each parent, update their lists as well

		_updateItem();

		MenuAppend(cast(void*)this, &_pfvars, &inMenu._pfvars, inMenu.text, (inMenu.length > 0));
	}
	
	Menu opIndex(size_t idx) {
		return _subitems[idx];
	}
	
	int opApply(int delegate(inout Menu) loopFunc) {
		int ret;
		
		for (int i = 0; i < length; i++) {
			ret = loopFunc(_subitems[i]);
			if (ret) { break; }
		}
		
		return ret;
	}
	
	int opApply(int delegate(ref uint, ref Menu) loopFunc) {
		int ret;

		for (uint i = 0; i < length; i++) {
			ret = loopFunc(i, _subitems[i]);
			if (ret) { break; }
		}
		
		return ret;
	}

protected:

	String _value;
	String _displayValue;
	int _hintPosition;
	Menu[] _subitems;
	Menu[] _parents;

	uint _flags;

	MenuPlatformVars _pfvars;

	void _addParent(ref Menu parent) {
		foreach(ent; _parents) {
			if (ent is parent) {
				return;
			}
		}

		_parents ~= parent;
	}

	void _updateChild(ref Menu child) {
		uint pos = 0;
		foreach(sitm; _subitems) {
			if (sitm is child) {
				MenuUpdate(cast(void*)this, &_pfvars, &child._pfvars, child.text, pos, (child.length > 0));
			}
			pos++;
		}
	}

	// check to ensure that we will not create a recursive menu structure
	bool _checkForRecursive(ref Menu inMenu) {
		foreach(sitm; _subitems) {
			if (sitm is inMenu) {
				return true;
			}
			else {
				if (sitm._checkForRecursive(inMenu)) {
					return true;
				}
			}
		}
		return false;
	}

	void _updateDisplay() {
		// get the value
		int curPos = 0;
		int ampPos = int.max;

		String itemText = new String("");
		
		_hintPosition = -1;

		while(ampPos != -1) {
			ampPos = _value.find("&", curPos);

			if (ampPos == -1) {
				itemText ~= _value.subString(curPos);
			}
			else {
				itemText ~= _value.subString(curPos, ampPos - curPos);
				if ((ampPos < _value.length) && (_value[ampPos+1] == '&')) {
					// This is an actual amp
					itemText ~= "&";
					ampPos++;
				}
				else {
					// The next letter is the hint
					if (ampPos < _value.length) {
						_hintPosition = itemText.length;
					}
				}
			}
			curPos = ampPos + 1;
		}
		
		_displayValue = itemText;
	}

	void _updateItem() {
		// Get the working text
		_updateDisplay();

		// for each parent, update their lists as well
		foreach(ent; _parents) {
			ent._updateChild(this);
		}
	}
}

MenuPlatformVars* MenuGetPlatformVars(ref Menu mnu) {
	return &mnu._pfvars;
}