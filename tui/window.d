module tui.window;

import tui.application;
import tui.widget;

import core.event;
import core.string;
import core.definitions;

import resource.menu;

import io.console;

// Description: This class abstacts the console window and allows for high level console operations which are abstracted away as controls.  It is the Window class for the console world.
class TuiWindow : Responder {
	// Constructor

	this() {
	}

	this(bgColor bgClr) {
		_bgClr = bgClr;
	}

	// Events

	void onInitialize() {
		// go through control list, init

		Console.setColor(_bgClr);
		Console.clear();

		TuiWidget c = _firstControl;

		if (c !is null) {
			do {
				c =	c._prevControl;

				c.onInit();
				c.onDraw();
			} while (c !is _firstControl)

		}

		_drawMenu();

		if (c !is null) {
			_focused_control = c;

			do {
				_focused_control = _focused_control._prevControl;
				if (_focused_control.isTabStop()) {
					_focused_control.onGotFocus();
					break;
				}
			} while (_focused_control !is c);
		}
	}

	void onUninitialize() {
	}

	void onResize() {
	}

	void redraw() {
		bool showCaret;
		if (Console.caretVisible) {
			Console.hideCaret();
			showCaret = true;
		}

		TuiWidget c = _firstControl;

		if (c !is null) {
			do {
				c =	c._prevControl;

				c.onDraw();
			} while (c !is _firstControl)
		}

		_drawMenu();
		
		if (showCaret) {
			Console.showCaret();
		}
	}

	void onKeyDown(Key key) {
		if (_focusedMenu !is null) {
			if (_focusedMenu == _selectedMenu) {
				// on the menu bar

				if (key.code == Key.Down) {
					// expand menu
					if (_focusedMenu.length > 0) {
						_selectMenu(_focusedMenu);
					}
				}
				else if (key.code == Key.Up) {
					// leave menu
					_focusedMenu = null;
					_selectedMenu = null;
					_drawMenu();

					// Focus on the current widget
					_focused_control.onGotFocus();
				}
				else if (key.code == Key.Left) {
					if (_focusedMenuIndex != 0) {
						_focusedMenuIndex--;
						_selectedMenu = _menu[_focusedMenuIndex];
						_focusedMenu = _selectedMenu;
						_drawMenu();
					}
					else {
						// leave menu
						_focusedMenu = null;
						_selectedMenu = null;
						_drawMenu();

						// Focus on the current widget
						_focused_control.onGotFocus();
					}
				}
				else if (key.code == Key.Right) {
					if ((_focusedMenuIndex + 1) < _menu.length) {
						_focusedMenuIndex++;
						_selectedMenu = _menu[_focusedMenuIndex];
						_focusedMenu = _selectedMenu;
						_drawMenu();
					}
				}
				else if (key.code == Key.Return || key.code == Key.Space) {
					// apply
					if (_selectedMenu.length > 0) {
						// it is a submenu
						_selectMenu(_selectedMenu);
					}
					else {
						// select the item
						_cancelNextChar = true;
						_focusedMenu = null;
						_selectedMenu = null;
						_drawMenu();

						onMenu(_selectedMenu);

						// Focus on the current widget
						_focused_control.onGotFocus();
					}
				}
			}
			else {
				// within a submenu

				if (key.code == Key.Down) {
					_selectedMenuIndex++;
					if (_selectedMenuIndex < _focusedMenu.length) {
						_selectedMenu = _focusedMenu[_selectedMenuIndex];
						_drawSubmenu();
					}
					else {
						_selectedMenuIndex = _focusedMenu.length - 1;
					}
				}
				else if (key.code == Key.Up) {
					if (_selectedMenuIndex > 0) {
						_selectedMenuIndex--;
						_selectedMenu = _focusedMenu[_selectedMenuIndex];
						_drawSubmenu();
					}
				}
				else if (key.code == Key.Left) {
					// remove submenu
					if (_selectedMenu is null) {
					}
					else {
						_removeMenuContext();
					}
				}
				else if (key.code == Key.Right) {
					// add submenu
					if (_selectedMenu.length > 0) {
						_addSubmenu();
						_drawSubmenu();
					}
				}
				else if (key.code == Key.Return || key.code == Key.Space) {
					// apply
					if (_selectedMenu.length > 0) {
						// it is a submenu
						_addSubmenu();
						_drawSubmenu();
					}
					else {
						// select the item
						_cancelNextChar = true;
						_focusedMenu = null;
						_selectedMenu = null;
						redraw();

						onMenu(_selectedMenu);

						// Focus on the current widget
						_focused_control.onGotFocus();
					}
				}
				else if (key.code >= Key.A && key.code <= Key.Z) {
					uint chr = key.code - Key.A;
					// Look for a hint
					foreach(mnuItem; _focusedMenu) {
						// Does the menu item have a hint?
						if (mnuItem.hintPosition == -1) {
							continue;
						}

						auto hint = mnuItem.displayText.toLowercase[mnuItem.hintPosition];
						uint chr2 = cast(uint)(hint - 'a');

						if (chr == chr2) {
							// This menu item is selected
							_selectMenu(mnuItem);
						}
					}
				}
			}

			// Do not pass the key off to a widget
			return;
		}
		else if (_menu !is null) {
			if (key.alt) {
				uint chr = key.code - Key.A;
				if (chr <= Key.Z) {
					// compare to menu hints
					foreach(mnuItem; _menu) {
						// Does the menu item have a hint?
						if (mnuItem.hintPosition == -1) {
							continue;
						}

						auto hint = mnuItem.displayText.toLowercase[mnuItem.hintPosition];
						uint chr2 = cast(uint)(hint - 'a');

						if (chr == chr2) {
							// This menu item is selected
							_selectMenu(mnuItem);

							// Do not pass the key off to a widget
							return;
						}
					}
				}
			}
		}

		if (_focused_control !is null) {
			_focused_control.onKeyDown(key);
		}
	}

	void onMenu(Menu mnu) {
	}

	void onKeyChar(dchar keyChar) {
		if (_focusedMenu !is null || _cancelNextChar) {
			_cancelNextChar = false;
			return;
		}
		if (_focused_control !is null) {
			_focused_control.onKeyChar(keyChar);
		}
	}

	void onPrimaryMouseDown() {
		if (_focused_control !is null) {
			_focused_control.onPrimaryMouseDown();
		}
	}

	void onPrimaryMouseUp() {
		if (_focused_control !is null) {
			_focused_control.onPrimaryMouseUp();
		}
	}

	void onSecondaryMouseDown() {
		if (_focused_control !is null) {
			_focused_control.onSecondaryMouseDown();
		}
	}

	void onSecondaryMouseUp() {
		if (_focused_control !is null) {
			_focused_control.onSecondaryMouseUp();
		}
	}

	void onTertiaryMouseDown() {
		if (_focused_control !is null) {
			_focused_control.onTertiaryMouseDown();
		}
	}

	void onTertiaryMouseUp() {
		if (_focused_control !is null) {
			_focused_control.onTertiaryMouseUp();
		}
	}

	void onOtherMouseDown(uint button) {
		if (_focused_control !is null) {
		}
	}

	void onOtherMouseUp(uint button) {
		if (_focused_control !is null) {
		}
	}

	void onMouseWheelY(uint amount) {
		if (_focused_control !is null) {
			_focused_control.onMouseWheelY(amount);
		}
	}

	void onMouseWheelX(uint amount) {
		if (_focused_control !is null) {
			_focused_control.onMouseWheelX(amount);
		}
	}

	void onMouseMove() {
		if (_focused_control !is null) {
			_focused_control.onMouseMove();
		}
	}

	void text(string value) {
		_value = new String(value);
	}

	void text(String value) {
		_value = new String(value);
	}

	String text() {
		return _value;
	}

	uint width() {
		return Console.width();
	}

	uint height() {
		return Console.height();
	}

	// Methods

	override void push(Dispatcher dsp) {
		if (cast(TuiWidget)dsp !is null) {
			// do not add a control that is already part of another window
			TuiWidget control = cast(TuiWidget)dsp;

			if (control._nextControl !is null) { return; }

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

			super.push(control);
		}
		else {
			super.push(dsp);
		}
	}

	bgColor backcolor() {
		return _bgClr;
	}

	void tabForward() {
		// activate the next control
		TuiWidget curFocus = _focused_control;

		_focused_control.onLostFocus();

		do {
			_focused_control = _focused_control._prevControl;
			if (_focused_control.isTabStop()) {
				_focused_control.onGotFocus();
				break;
			}
		} while (_focused_control !is curFocus);
	}

	void tabBackward() {
		// activate the previous control
		TuiWidget curFocus = _focused_control;

		_focused_control.onLostFocus();

		do {
			_focused_control = _focused_control._nextControl;
			if (_focused_control.isTabStop()) {
				_focused_control.onGotFocus();
				break;
			}
		} while (_focused_control !is curFocus);
	}

	TuiApplication application() {
		return cast(TuiApplication)this.responder;
	}

	bool isActive() {
		return (application() !is null && application.window is this);
	}

	void menu(Menu mnu) {
		_menu = mnu;
		if (isActive) {
			_drawMenu();
		}
	}

	Mouse mouseProps;

private:

	void _drawSubmenu() {
		MenuContext context = _menus[$-1];

		Menu mnu = context.submenu;
		uint x = context.region.left;
		uint y = context.region.top;

		uint maxLength = context.region.right - context.region.left;

		foreach(subItem; mnu) {
			Console.setPosition(x, y);
			if (subItem is _selectedMenu) {
				Console.setColor(fgColor.BrightWhite, bgColor.Blue);
			}
			else {
				Console.setColor(fgColor.Black, bgColor.White);
			}
			Console.put(" ");
			int padding = maxLength - subItem.displayText.length;
			if (padding < 0) {
				Console.putln("AFSDF", maxLength, " : ", subItem.displayText.length, " : ", subItem.displayText);
				for (;;) {}
			}
			_drawMenuItem(subItem, false, maxLength - subItem.displayText.length);
			if (subItem is _selectedMenu) {
				Console.setColor(fgColor.BrightWhite, bgColor.Blue);
			}
			else {
				Console.setColor(fgColor.Black, bgColor.White);
			}
			Console.put(" ");
			y++;
		}
	}

	void _drawMenuItem(Menu mnuItem, bool drawHints = false, uint padding = 0) {
		if (mnuItem is _selectedMenu) {
			Console.setColor(fgColor.BrightWhite, bgColor.Blue);
		}
		else {
			Console.setColor(fgColor.Black, bgColor.White);
		}

		if (mnuItem.hintPosition >= 0) {
			if (mnuItem.hintPosition > 0) {
				Console.put(mnuItem.displayText[0..mnuItem.hintPosition]);
			}

			if (mnuItem !is _selectedMenu) {
				if (drawHints) {
					Console.setColor(fgColor.BrightBlue);
				}
				else {
					Console.setColor(fgColor.Blue);
				}
			}

			Console.put(mnuItem.displayText[mnuItem.hintPosition]);

			if (mnuItem !is _selectedMenu) {
				Console.setColor(fgColor.Black, bgColor.White);
			}
			if (mnuItem.hintPosition < mnuItem.displayText.length) {
				Console.put(mnuItem.displayText[mnuItem.hintPosition + 1..mnuItem.displayText.length]);
			}
		}
		else {
			Console.put(mnuItem.displayText);
		}

		// Padding
		for (uint i; i < padding; i++) {
			Console.put(" ");
		}

		if (mnuItem is _selectedMenu) {
			Console.setColor(fgColor.Black, bgColor.White);
		}
	}

	void _drawMenu(bool drawHints = false) {
		if (_menu is null) {
			return;
		}

		uint curWidth = this.width;

		Console.setPosition(0,0);
		Console.setColor(fgColor.Black, bgColor.White);

		if (_menu.length > 0 && (_menu[0] is _selectedMenu)) {
			Console.setColor(fgColor.BrightWhite, bgColor.Blue);
		}
		else {
			Console.setColor(fgColor.Black, bgColor.White);
		}
		Console.put(" ");
		curWidth--;

		foreach(i, mnuItem; _menu) {
			if (curWidth > mnuItem.displayText.length) {
				_drawMenuItem(mnuItem, drawHints, 0);
				if (mnuItem is _selectedMenu || (((i + 1) < _menu.length) && _menu[i+1] is _selectedMenu)) {
					Console.setColor(fgColor.BrightWhite, bgColor.Blue);
					Console.put(" ");
					Console.setColor(fgColor.Black, bgColor.White);
				}
				else {
					Console.put(" ");
				}
				curWidth -= (mnuItem.displayText.length + 1);
			}
		}

		bool drawCaption = false;
		if (_value !is null && curWidth >= (_value.length + 1)) {
			curWidth -= _value.length + 1;
			drawCaption = true;
		}

		if (curWidth > 0) {
			for (; curWidth != 0; curWidth--) {
				Console.put(" ");
			}
		}

		if (drawCaption) {
			Console.put(_value, " ");
		}
	}

	void _selectMenu(Menu mnu) {
	
		// Switching focus to window
		_focused_control.onLostFocus();

		// Do not show the cursor within a menu
		Console.hideCaret();

		// draw menu
		if (_menu is null) {
			return;
		}

		if (mnu.isChildOf(_menu)) {
			// Find this menu is the root menu
			_selectedMenu = mnu;
			_selectedMenuIndex = 0;
			_drawMenu();

			if (mnu.length == 0) {
				onMenu(mnu);
				_selectedMenu = null;
				_selectedMenuIndex = 0;
				_drawMenu();
				return;
			}
			else {
				uint curPos = 1;

				uint focusedIdx;

				foreach(uint idx, mnuItem; _menu) {
					if (mnuItem is mnu) {
						focusedIdx = idx;
						break;
					}

					curPos += mnuItem.displayText.length;
					curPos ++;
				}

				_focusedMenuIndex = focusedIdx;
				_focusedMenu = mnu;
				_addSubmenuContext(curPos, 1, mnu);

				if (mnu.length >  0) {
					_selectedMenu = mnu[0];
					_selectedMenuIndex = 0;
				}
				else {
					_selectedMenu = null;
				}

				_drawSubmenu();
			}
		}
	}
	
	void _addSubmenu() {
		uint x;
		uint y;

		if (_menus.length == 0) {
			return;
		}

		// This menu starts at the right of the current one + 2 (for the padding to either side)
		x = _menus[$-1].region.right + 2;
		y = _menus[$-1].region.top + _selectedMenuIndex;

		_addSubmenuContext(x, y, _selectedMenu);
		_focusedMenuIndex = _selectedMenuIndex;
		_focusedMenu = _selectedMenu;

		if (_focusedMenu.length >  0) {
			_selectedMenu = _focusedMenu[0];
			_selectedMenuIndex = 0;
		}
		else {
			_selectedMenu = null;
		}
	}
	
	void _addSubmenuContext(uint x, uint y, Menu mnu) {
		// get width of submenu
		uint maxLength;
		foreach(subItem; mnu) {
			if (subItem.displayText.length > maxLength) {
				maxLength = subItem.displayText.length;
			}
		}

		MenuContext mnuContext;

		mnuContext.submenu = mnu;

		mnuContext.region.left = x;
		mnuContext.region.right = x + maxLength;
		mnuContext.region.top = y;
		mnuContext.region.bottom = y + mnu.length;

		mnuContext.oldSelectedMenu = _selectedMenu;
		mnuContext.oldSelectedIndex = _selectedMenuIndex;
		mnuContext.oldFocusedMenu = _focusedMenu;
		mnuContext.oldFocusedIndex = _focusedMenuIndex;
		
		_menus ~= mnuContext;
	}

	void _removeMenuContext() {
		if (_menus.length == 0) {
			return;
		}

		MenuContext removed = _menus[$-1];
		removed.region.right += 2;
		_menus = _menus[0..$-1];

		_selectedMenu = removed.oldSelectedMenu;
		_selectedMenuIndex = removed.oldSelectedIndex;
		_focusedMenu = removed.oldFocusedMenu;
		_focusedMenuIndex = removed.oldFocusedIndex;

		Console.clipClear();
		Console.clipRect(removed.region);
		redraw();
		Console.clipClear();
	}

	bgColor _bgClr = bgColor.Black;

	// head and tail of the control linked list
	TuiWidget _firstControl;	//head
	TuiWidget _lastControl;	//tail

	int _numControls = 0;

	TuiWidget _captured_control;
	TuiWidget _last_control;
	TuiWidget _focused_control;

	// Current Menu
	Menu _menu;

	// In a menu?
	Menu _focusedMenu;
	uint _focusedMenuIndex;

	struct MenuContext {
		Menu submenu;
		Menu oldSelectedMenu;
		uint oldSelectedIndex;
		Menu oldFocusedMenu;
		uint oldFocusedIndex;
		Rect region;
	}
	
	Menu _selectedMenu;
	uint _selectedMenuIndex;

	MenuContext[] _menus;
	
	bool _cancelNextChar;

	String _value;
}
