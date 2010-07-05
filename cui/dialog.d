/*
 * dialog.d
 *
 * This module implements a subwindow for Cui applications.
 *
 */

module cui.dialog;

import djehuty;

import cui.window;
import cui.canvas;

import io.console;

class CuiDialog : CuiWindow {
private:

	string _title;

	enum NonClientComponent {
		TitleBar,
		LeftBorder,
		RightBorder,
		BottomBorder,
		BottomLeftCorner,
		BottomRightCorner
	}

	Coord _dragPos;
	NonClientComponent _dragBy;

	CuiWindow _clientArea;

public:
	this() {
		this(null, WindowStyle.Fixed, Color.Black, WindowPosition.Center, Console.width, Console.height);
	}

	this(string windowTitle, WindowStyle windowStyle, Color color, int x, int y, int width, int height) {
		super(x, y, width+2, height+2, color);
		if (windowTitle !is null) {
			_title = windowTitle.dup;
		}
		else {
			_title = "";
		}
		_clientArea = new CuiWindow(1,1,width,height, color);
		_clientArea.visible = true;
		push(_clientArea);
	}

	this(string windowTitle, WindowStyle windowStyle, Color color, WindowPosition pos, int width, int height) {
		super(pos, width+2, height+2, color);
		if (windowTitle !is null) {
			_title = windowTitle.dup;
		}
		else {
			_title = "";
		}
		_clientArea = new CuiWindow(1,1,width,height, color);
		_clientArea.visible = true;
		push(_clientArea);
	}

	string text() {
		return _title.dup;
	}

	void text(string value) {
		_title = value.dup;
		redraw();
	}

	override int clientWidth() {
		return width - 2;
	}

	override void clientWidth(int value) {
		width = (value + 2);
	}

	override int clientHeight() {
		return height - 2;
	}

	override void clientHeight(int value) {
		height = value + 2;
	}

	// Signal

	override void push(Dispatcher dsp, SignalHandler handler = null) {
		CuiWindow window = cast(CuiWindow)dsp;

		if (window !is null && window !is _clientArea) {
			_clientArea.push(dsp, handler);
		}
		else {
			// Pass through so it calls this class
			super.push(dsp, handler);
		}
	}

	// Events

	override void onPrimaryDown(ref Mouse mouse) {
		// Move this window to the foreground
		reorder(WindowOrder.Top);

		_dragPos.x = mouse.x;
		_dragPos.y = mouse.y;
		if (mouse.y == 0) {
			if (mouse.x == this.width - 1) {
				// 'x' Button
			}
			else {
				// Title bar!

				// Move dialog with mouse
				_dragBy = NonClientComponent.TitleBar;
			}
		}
		else if (mouse.x == 0) {
			if (mouse.y == this.height - 1) {
				// Bottom-left corner
				_dragBy = NonClientComponent.BottomLeftCorner;
			}
			else {
				// Left border
				_dragBy = NonClientComponent.LeftBorder;
			}
		}
		else if (mouse.x == this.width - 1) {
			if (mouse.y == this.height - 1) {
				// Bottom-right corner
				_dragBy = NonClientComponent.BottomRightCorner;
			}
			else {
				// Right border
				_dragBy = NonClientComponent.RightBorder;
			}
		}
		else if (mouse.y == this.height - 1) {
			// Bottom border
			_dragBy = NonClientComponent.BottomBorder;
		}
		else {
			super.onPrimaryDown(mouse);
		}
	}

	override void reposition(int left, int top, int width = int.min, int height = int.min) {
		// Resize subwindow
		if (width == int.min) {
			width = this.width;
		}
		if (height == int.min) {
			height = this.height;
		}
		if (width < 2) {
			width = 2;
		}
		if (height < 2) {
			height = 2;
		}
		super.reposition(left,top,width,height);
		_clientArea.reposition(1,1,this.width - 2, this.height - 2);
	}

	override void onDrag(ref Mouse mouse) {
		int xdiff = cast(int)(mouse.x) - cast(int)(_dragPos.x);
		int ydiff = cast(int)(mouse.y) - cast(int)(_dragPos.y);
		bool updateDragPosX = false;
		bool updateDragPosY = false;
		if (xdiff != 0 || ydiff != 0) {
			int w = this.width;
			int h = this.height;
			switch(_dragBy) {
				case NonClientComponent.BottomBorder:
					// Resize window vertically
					reposition(this.left, this.top, this.width, this.height + ydiff);
					xdiff = 0;
					ydiff = 0;

					updateDragPosX = true;
					updateDragPosY = this.height != h;
					break;
				case NonClientComponent.RightBorder:
					reposition(this.left, this.top, this.width + xdiff, this.height);
					xdiff = 0;
					ydiff = 0;
					updateDragPosX = this.width != w;
					updateDragPosY = true;
					break;
				case NonClientComponent.LeftBorder:
					// Resize window horizontally
					reposition(this.left + xdiff, this.top, this.width - xdiff, this.height);
					ydiff = 0;
					updateDragPosX = this.width != w;
					updateDragPosY = true;
					break;
				case NonClientComponent.BottomRightCorner:
					// Resize window in both horizontal and vertical directions
					reposition(this.left, this.top, this.width + xdiff, this.height + ydiff);
					xdiff = 0;
					ydiff = 0;
					updateDragPosX = this.width != w;
					updateDragPosY = this.height != h;
					break;
				case NonClientComponent.BottomLeftCorner:
					reposition(this.left + xdiff, this.top, this.width - xdiff, this.height + ydiff);
					ydiff = 0;
					updateDragPosX = this.width != w;
					updateDragPosY = this.height != h;
					break;
				case NonClientComponent.TitleBar:
				default:
					// Drag the window by moving it
					reposition(this.left + xdiff, this.top + ydiff);
					updateDragPosX = true;
					updateDragPosY = true;
					break;
			}
			if (updateDragPosX) {
				_dragPos.x = mouse.x - xdiff;
			}
			if (updateDragPosY) {
				_dragPos.y = mouse.y - ydiff;
			}
		}
	}

	override void onPrimaryUp(ref Mouse mouse) {
		super.onPrimaryUp(mouse);
	}

	// Drawing the window
	void onDraw(CuiCanvas canvas) {
		canvas.position(0, 0);

		static const string TITLE_BAR_CHAR = "\u2550";
		static const string BORDER_LEFT_CHAR = "\u258c";
		static const string BORDER_RIGHT_CHAR = "\u2590";
		static const string BORDER_BOTTOM_CHAR = "\u2584";
		static const string BORDER_BOTTOM_LEFT_CHAR = "\u2599";
		static const string BORDER_BOTTOM_RIGHT_CHAR = "\u259f";

		// Titlebar
		canvas.forecolor = Color.Black;
		canvas.backcolor = Color.White;
		canvas.write(" ");
		string title = _title;

		if (this.clientWidth < 4) {
			title = "";
		}
		else if (title.utflen() >= this.clientWidth) {
			title = title.substring(0, this.clientWidth - 3);
			title ~= "...";
		}

		canvas.write(title);

		// Draw a space after the title
		if (title.utflen() < this.clientWidth) {
			canvas.write(" ");
		}
		// Draw a section of pretty characters
		for(int i = title.utflen() + 1; i < this.clientWidth-1; i++) {
			canvas.write(TITLE_BAR_CHAR);
		}

		// Draw another space to pad
		if (title.utflen() + 1 < this.clientWidth) {
			canvas.write(" ");
		}
		canvas.position(this.width - 1, 0);
		canvas.write("x");

		// Border
		canvas.forecolor = Color.White;
		canvas.backcolor = this.backcolor;

		// Left
		for(uint i = 0; i < this.clientHeight; i++) {
			canvas.position(0,i+1);
			canvas.write(BORDER_LEFT_CHAR);
		}

		// Right
		for(uint i = 0; i < this.clientHeight; i++) {
			canvas.position(this.clientWidth+1,i+1);
			canvas.write(BORDER_RIGHT_CHAR);
		}

		// Bottom
		canvas.position(0, this.height-1);
		canvas.write(BORDER_BOTTOM_LEFT_CHAR);
		for(uint i = 0; i < this.clientWidth; i++) {
			canvas.write(BORDER_BOTTOM_CHAR);
		}
		canvas.write(BORDER_BOTTOM_RIGHT_CHAR);
	}
}
