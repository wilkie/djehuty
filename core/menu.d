module core.menu;

import core.string;

import console.main;

import platform.imports;
mixin(PlatformGenericImport!("definitions"));
mixin(PlatformGenericImport!("vars"));
mixin(PlatformScaffoldImport!());

// Section: Core/Resources

// Description: This class provides an abstract to a dropdown menu.  The Window class uses this to provide a menubar for a window.
class Menu
{

	// -- constructors -- //

	this(StringLiteral text, Menu[] submenus = null)
	{
		_value = new String(text);

		if (submenus is null || submenus.length == 0)
		{
			_subitems = null;
		}
		else
		{
			_subitems = new Menu[submenus.length];
			_subitems[0..$] = submenus[0..$];
		}

		Scaffold.MenuCreate(this, _pfvars);

		foreach(mnu ; _subitems)
		{
			mnu._addParent(this);
			Scaffold.MenuAppend(this, mnu, _pfvars, mnu._pfvars);
		}
	}

	this(String text, Menu[] submenus = null)
	{
		_value = new String(text);

		if (submenus is null || submenus.length == 0)
		{
			_subitems = null;
		}
		else
		{
			_subitems = new Menu[submenus.length];
			_subitems[0..$] = submenus[0..$];
		}

		Scaffold.MenuCreate(this, _pfvars);

		foreach(mnu ; _subitems)
		{
			mnu._addParent(this);
			Scaffold.MenuAppend(this, mnu, _pfvars, mnu._pfvars);
		}
	}

	// -- destructor -- //

	~this()
	{
		// remove all descendants
		_subitems = null;

		// platform specific destroy
		Scaffold.MenuDestroy(this, _pfvars);
	}

	// -- Methods -- //

	void SetText(String newValue)
	{
		_value = new String(newValue);

		_updateItem();
	}

	void SetText(StringLiteral newValue)
	{
		_value = new String(newValue);

		_updateItem();
	}

	String getText()
	{
		return _value;
	}

	uint GetSubMenuCount()
	{
		if (_subitems is null) { return 0; }

		return _subitems.length;
	}

	void AppendMenu(Menu inMenu)
	{
		if (inMenu._checkForRecursive(this)) { return; }

		_subitems ~= inMenu;

		Console.put(_parents);
		inMenu._addParent(this);

		// for each parent, update their lists as well

		_updateItem();

		Scaffold.MenuAppend(this, inMenu, _pfvars, inMenu._pfvars);
	}


protected:

	String _value;
	Menu[] _subitems;
	Menu[] _parents;

	uint _flags;

	MenuPlatformVars _pfvars;

	void _addParent(ref Menu parent)
	{
		foreach(ent; _parents)
		{
			if (ent is parent)
			{
				return;
			}
		}

		_parents ~= parent;
	}

	void _updateChild(ref Menu child)
	{
		uint pos = 0;
		foreach(sitm; _subitems)
		{
			if (sitm is child)
			{
				Scaffold.MenuUpdate(pos, this, child, _pfvars, child._pfvars);
			}
			pos++;
		}
	}

	// check to ensure that we will not create a recursive menu structure
	bool _checkForRecursive(ref Menu inMenu)
	{
		foreach(sitm; _subitems)
		{
			if (sitm is inMenu)
			{
				return true;
			}
			else
			{
				if (sitm._checkForRecursive(inMenu))
				{
					return true;
				}
			}
		}
		return false;
	}

	void _updateItem()
	{
		// for each parent, update their lists as well

		foreach(ent; _parents)
		{
			ent._updateChild(this);
		}
	}
}

MenuPlatformVars MenuGetPlatformVars(ref Menu mnu)
{
	return mnu._pfvars;
}

//documentation interests:

//DJEHUTYDOC

//
//CLASS:Menu
//EXTENDS:Object
//DESC:This base provides an abstraction for a menu.  It can either be a standalone menu item or a submenu containing many menu items within a tree.  As a restriction, you cannot have a recursive menu.

//CONSTRUCTORS

//NAME:(StringLiteral text, Menu[] submenus = null)
//DESC:Creates the menu with the initial caption 'text' with the initial subitems given as an array of Menu objects.  If none are specified, or null is passed, then the menu initially does not have subitems.
//PARAM:text
//DESC:The initial caption.
//PARAM:submenus
//DESC:An array of previously created Menu objects which serve as subitems for the menu.  Pass null for having no initial subitems.

//NAME:(String text, Menu[] submenus = null)
//DESC:Creates the menu with the initial caption 'text' with the initial subitems given as an array of Menu objects.  If none are specified, or null is passed, then the menu initially does not have subitems.
//PARAM:text
//DESC:The initial caption.
//PARAM:submenus
//DESC:An array of previously created Menu objects which serve as subitems for the menu.  Pass null for having no initial subitems.

//METHODS

//NAME:SetText(String newValue)
//DESC:Sets the text for the menu item.
//PARAM:newValue
//DESC:The text for the menu item.

//NAME:SetText(StringLiteral newValue)
//DESC:Sets the text for the menu item.
//PARAM:newValue
//DESC:The text for the menu item.

//NAME:getText()
//DESC:Sets the text for the menu item.
//RETURNS:String
//DESC:The current label for the menu item.

//NAME:AppendMenu(Menu inMenu)
//DESC:Appends the menu given by inMenu to the end of the menu's subitem list.  It cannot be in such a way as to produce a recursive list.  That is you cannot add the menu's parent as a submenu.
//PARAM:inMenu
//DESC:The menu to append.

//NAME:GetSubMenuCount()
//DESC:Returns the number of subitems directly within this menu.  This does not count subitems of subitems.
//RETURNS:uint
//DESC:The number of subitems.

//DJEHUTYDOCEND
