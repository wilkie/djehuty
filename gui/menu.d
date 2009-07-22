module gui.menu;

import core.string;
import core.definitions;

import io.console;

import platform.imports;
mixin(PlatformGenericImport!("definitions"));
mixin(PlatformGenericImport!("vars"));

import scaffold.menu;
import scaffold.window;

// Section: Core/Resources

// Description: This class provides an abstract to a dropdown menu.  The Window class uses this to provide a menubar for a window.
class Menu {

	// -- constructors -- //

	this(string text, Menu[] submenus = null) {
		_value = new String(text);

		if (submenus is null || submenus.length == 0) {
			_subitems = null;
		}
		else {
			_subitems = new Menu[submenus.length];
			_subitems[0..$] = submenus[0..$];
		}

		MenuCreate(this, _pfvars);

		foreach(mnu ; _subitems) {
			mnu._addParent(this);
			MenuAppend(this, mnu, _pfvars, mnu._pfvars);
		}
	}

	this(String text, Menu[] submenus = null) {
		_value = new String(text);

		if (submenus is null || submenus.length == 0) {
			_subitems = null;
		}
		else {
			_subitems = new Menu[submenus.length];
			_subitems[0..$] = submenus[0..$];
		}

		MenuCreate(this, _pfvars);

		foreach(mnu ; _subitems) {
			mnu._addParent(this);
			MenuAppend(this, mnu, _pfvars, mnu._pfvars);
		}
	}

	// -- destructor -- //

	~this() {
		// remove all descendants
		_subitems = null;

		// platform specific destroy
		MenuDestroy(this, _pfvars);
	}

	// -- Methods -- //

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

		MenuAppend(this, inMenu, _pfvars, inMenu._pfvars);
	}


protected:

	String _value;
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
				MenuUpdate(pos, this, child, _pfvars, child._pfvars);
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

	void _updateItem() {
		// for each parent, update their lists as well

		foreach(ent; _parents) {
			ent._updateChild(this);
		}
	}
}

MenuPlatformVars MenuGetPlatformVars(ref Menu mnu) {
	return mnu._pfvars;
}
