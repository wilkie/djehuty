module controls.togglefield;

import core.control;
import core.color;
import core.definitions;
import core.string;
import core.graphics;

import core.windowedcontrol;

template ControlPrintCSTRList()
{
	const char[] ControlPrintCSTRList = `
	this(int x, int y, int width, int height, String value)
	{
		super(x,y,width,height);

		_value = new String(value);
	}
	this(int x, int y, int width, int height, StringLiteral value)
	{
		super(x,y,width,height);

		_value = new String(value);
	}
`;
}

enum ToggleFieldEvent : uint
{
	Selected,
	Unselected,
}

// Description: This control provides a standard toggle field.  When grouped, these will act as a exclusive list of options, essentially a 'radio' or 'option' field.  Otherwise they are 'check' fields.
class ToggleField : WindowedControl
{
	this(int x, int y, int width, int height, String value)
	{
		super(x,y,width,height);

		_value = new String(value);
	}

	this(int x, int y, int width, int height, StringLiteral value)
	{
		super(x,y,width,height);

		_value = new String(value);
	}

	// support Events
	mixin(ControlAddDelegateSupport!("ToggleField", "ToggleFieldEvent"));

	void unselect()
	{
		_btnstate = 0;
	}

	void select()
	{
		_btnstate = 1;
	}
	
	void setText(String newTitle)
	{
		_value = new String(newTitle);
	}

	void setText(StringLiteral newTitle)
	{
		_value = new String(newTitle);
	}

	String getText()
	{
		return _value;
	}

	// handle events
	override void OnAdd()
	{
		_brsh = new Brush(Color.White);

		_clroutline.setRGB(0x80, 0x80, 0x80);
		_clrhighlight.setRGB(0xdd,0xdd,0xdd);
		_clrnormal.setRGB(0xaa,0xaa,0xaa);
		_clrforeground.setRGB(0,0,0);
		_clrbackground.setRGB(0xff,0xff,0xff);

		Graphics grp = _view.lockDisplay();

		_font = new Font(FontSans, 8, 400, false, false, false);

		grp.setFont(_font);
		grp.measureText(_value,_value_bounds);

		_view.unlockDisplay();

		//FIRE_EVENT(id,EventCreated,0,0);
	}

	override void OnDraw(ref Graphics g)
	{
		//Draw Background of Button
		Brush brush;
		Pen pen;

		Rect chkRect;

		chkRect.left = _x + 2;
		chkRect.top = _y + 2;
		chkRect.right = (chkRect.left + _height) - 4;
		chkRect.bottom = _b - 2;

		if (_is_grouped)
		{
			if (chkRect.right > _r)
			{
				chkRect.right = _r;
				chkRect.top += (_height - _width) / 2;
				chkRect.bottom = chkRect.top + _width;
			}

			brush = new Brush(_clrbackground);
			pen = new Pen(_clroutline);

			g.setBrush(brush);
			g.setPen(pen);

			g.drawRect(chkRect.left, chkRect.top, chkRect.right, chkRect.bottom);

			pen.setColor(_clrhighlight);

			g.drawLine(chkRect.left+1, chkRect.top+1, chkRect.right - 1, chkRect.top+1);
			g.drawLine(chkRect.left+1, chkRect.top+2, chkRect.left + 1, chkRect.bottom-1);

			//Draw Check

			if (_mouseholdstate == 1)
			{
				pen.setColor(_clrnormal);

				brush.setColor(_clrbackground);

				g.drawOval(chkRect.left + 3, chkRect.top + 3, chkRect.right - 3, chkRect.bottom-3);
			}
			else if (_btnstate == 1)
			{
				brush.setColor(_clrnormal);

				pen.setColor(_clrnormal);

				g.drawOval(chkRect.left + 3, chkRect.top + 3, chkRect.right - 3, chkRect.bottom - 3);

				if (_hovered)
				{
					pen.setColor(_clrhighlight);

					g.drawOval(chkRect.left + 4, chkRect.top + 4, chkRect.right - 4, chkRect.bottom-4);
				}

			}
			else if (_hovered)
			{
				pen.setColor(_clrhighlight);
				brush.setColor(_clrbackground);

				g.drawOval(chkRect.left + 3, chkRect.top + 3, chkRect.right - 3, chkRect.bottom-3);
			}
		}
		else
		{
			//Draw Background of Button

			chkRect.left = _x + 2;
			chkRect.top = _y + 2;
			chkRect.right = (chkRect.left + _height) - 4;
			chkRect.bottom = _b - 2;

			if (chkRect.right > _r)
			{
				chkRect.right = _r;
				chkRect.top += (_height - _width) / 2;
				chkRect.bottom = chkRect.top + _width;
			}

			pen = new Pen(_clroutline);
			brush = new Brush(_clrbackground);

			g.setBrush(brush);
			g.setPen(pen);

			g.drawRect(chkRect.left, chkRect.top, chkRect.right, chkRect.bottom);

			pen.setColor(_clrhighlight);

			g.drawLine(chkRect.left+1, chkRect.top+1, chkRect.right - 1, chkRect.top+1);
			g.drawLine(chkRect.left+1, chkRect.top+2, chkRect.left + 1, chkRect.bottom-1);

			//Draw Check

			if (_mouseholdstate == 1)
			{
				pen.setColor(_clrnormal);
				brush.setColor(_clrbackground);

				g.drawRect(chkRect.left + 3, chkRect.top + 3, chkRect.right - 3, chkRect.bottom-3);
			}
			else if (_btnstate == 1)
			{
				brush.setColor(_clrnormal);
				pen.setColor(_clrnormal);

				g.drawRect(chkRect.left + 3, chkRect.top + 3, chkRect.right - 3, chkRect.bottom - 3);

				if (_hovered)
				{
					pen.setColor(_clrhighlight);

					g.drawRect(chkRect.left + 4, chkRect.top + 4, chkRect.right - 4, chkRect.bottom-4);
				}

			}
			else if (_hovered)
			{
				pen.setColor(_clrhighlight);
				brush.setColor(_clrbackground);

				g.drawRect(chkRect.left + 3, chkRect.top + 3, chkRect.right - 3, chkRect.bottom-3);
			}
		}

		//Draw the text
		g.setTextColor(_clrforeground);
		g.setTextModeTransparent();
		g.setFont(_font);
		Rect ctrlrt;
		ctrlrt.left = chkRect.right;
		ctrlrt.right = _r;
		ctrlrt.top = _y;
		ctrlrt.bottom = _b;
		g.drawClippedText(chkRect.right + 4, (_b + _y-_value_bounds.y)/2, ctrlrt, _value);
	}

	override bool OnPrimaryMouseDown(ref Mouse mouseProps)
	{
		if (!_enabled) { return false; }

		_mouseholdstate = 1;

		RequestCapture();
		return true;
	}

	override bool OnPrimaryMouseUp(ref Mouse mouseProps)
	{
		if (!_enabled) { return false; }

		RequestRelease();

		_mouseholdstate = 0;

		if (_hovered)
		{
			if (!(_is_grouped && _btnstate))
			{
				_btnstate = !_btnstate;
				FireEvent(ToggleFieldEvent.Selected);
			}
		}

		return true;
	}

	override bool OnMouseEnter()
	{
		Graphics g = _view.lockDisplay();

		_brsh.setColor(Color.White);

		_view.unlockDisplay();

		return true;
	}

	override bool OnMouseLeave()
	{
		Graphics g = _view.lockDisplay();

		Color c;
		c.setRGB(0xc8, 0xc8, 0xc8);

		_brsh.setColor(c);

		_view.unlockDisplay();

		return true;
	}

	override bool OnKeyDown(uint keyCode)
	{
		return false;
	}

protected:
	String _value;

	bool _is_grouped = false;

private:

	Brush _brsh;
	Pen _pen;

	Font _font;

	Color _clroutline;
	Color _clrhighlight;
	Color _clrnormal;
	Color _clrforeground;
	Color _clrbackground;

	int _btnstate = 0;
	int _mouseholdstate = 0;

	Size _value_bounds;
}

void ToggleFieldSetGrouped(ref ToggleField ctrl, bool grouped)
{
  ctrl._is_grouped = grouped;
}