module gui.hscrollbar;

import gui.widget;

import core.color;
import core.definitions;
import core.string;
import core.event;

import graphics.graphics;

import synch.timer;

template ControlPrintCSTRList()
{
	const char[] ControlPrintCSTRList = `
	this(int x, int y, int width, int height)
	{
		super(x,y,width,height);
	}
	`;
}


// Description: This control provides a standard horizontal scroll bar.
class HScrollBar : Widget
{
public:

	enum Signal : uint {
		Selected,
		Unselected,
		Scrolled,
	}

	this(int x, int y, int width, int height) {
		super(x,y,width,height);

		m_clroutline = Color.fromRGB(0x80,0x80,0x80);
		m_clrarea = Color.fromRGB(0xe0, 0xe0, 0xe0);
		m_clrbutton = Color.fromRGB(0xc0, 0xc0, 0xc0);
		m_clrhighlight = Color.fromRGB(0xdd, 0xdd, 0xdd);
		m_clrnormal = Color.fromRGB(0,0,0);
		m_clrthumb = Color.fromRGB(0xc0, 0xc0, 0xc0);
		m_clrhover = Color.fromRGB(0xdd, 0xdd, 0xdd);

		_readyTimer = new Timer();
		_clickTimer = new Timer();

		_clickTimer.setInterval(50);
		_readyTimer.setInterval(100);

		push(_readyTimer);
		push(_clickTimer);
	}

	override void onAdd() {
		m_whatishovered = 0;
		m_isclicked=0;
	}

	override bool onSignal(Dispatcher dsp, uint signal) {
		if (dsp is _readyTimer) {
			readyTimerProc();
		}
		else if (dsp is _clickTimer) {
			clickTimerProc();
		}
		return true;
	}

	override void onDraw(ref Graphics g) {
		//a scroll bar is just a few rectangles (4)
		//one rectangle for the min arrow, one for max arrow
		//one more for the body
		//one more for the thumb

		long total_value_space = m_large_change + (m_max - m_min);

		float percent = cast(float)m_large_change / cast(float)total_value_space;

		m_area = (this.width - (this.height*2))+2;

		m_thumb_size = cast(int)(cast(float)m_area * percent);

		if (m_thumb_size < 10) { m_thumb_size = 10; }

		m_area -= m_thumb_size;

		percent = cast(float)(m_value - m_min) / cast(float)(m_max - m_min);
		m_thumb_pos_x = cast(int)(cast(float)m_area * percent) + this.left + this.height-1;
		m_thumb_pos_r = m_thumb_pos_x + m_thumb_size;

		//BODY

		Brush brsh = new Brush(m_clrarea);
		Pen pen = new Pen(m_clroutline);

		g.pen = (pen);
		g.brush = (brsh);

		g.drawRect(this.left, this.top, this.right,this.bottom);

		brsh.setColor(m_clrbutton);

		g.drawRect(this.left, this.top, this.left+this.height, this.bottom);
		g.drawRect(this.right-this.height, this.top, this.right, this.bottom);

		//THUMB

		brsh.setColor(m_clrthumb);

		g.brush = (brsh);

		g.drawRect(m_thumb_pos_x, this.top, m_thumb_pos_r, this.bottom);

		//Draw triangle images...

		//draw UP BUTTON

		brsh.setColor(m_clrnormal);
		pen.setColor(m_clrnormal);

		Pen pen_hlight = new Pen(m_clrhighlight);
		Brush brsh_hlight = new Brush(m_clrhighlight);

		if (m_whatishovered == 1) {
			g.brush = (brsh_hlight);
			g.pen = (pen_hlight);
		}
		else {
			g.brush = (brsh);
			g.pen = (pen);
		}

		int base, height;

		height = (this.height / 4); //height

		//from the 'height' we can draw a perfect triangle

		base = (height*2) - 1; //base

		int xH,yB; //main directional point of triangle:

		xH = this.top + ((this.height - base)/2);
		yB = this.left + ((this.height - height) /2);

		base--;
		height--;

		Coord pnt[3] = [ Coord(yB, xH+(base/2)), Coord(yB+height, xH), Coord(yB+height,xH+base) ];

		if (m_isclicked == 1) {
			pnt[0].x+=1;
			pnt[0].y+=1;
			pnt[1].x+=1;
			pnt[1].y+=1;
			pnt[2].x+=1;
			pnt[2].y+=1;
		}

		//DRAW_TRIANGLE(pnt);

		//draw DOWN BUTTON

		yB = this.right - ((this.height - height + 1)/2);

		Coord pnt2[3] = [ Coord(yB,xH+(base/2)), Coord(yB-height,xH), Coord(yB-height,xH+base) ];

		if (m_whatishovered == 2) {
			g.brush = (brsh_hlight);
			g.pen = (pen_hlight);
		}
		else
		{
			if (m_whatishovered == 1) {
				g.brush = (brsh);
				g.pen = (pen);
			}
		}

		if (m_isclicked == 2) {
			pnt2[0].x+=1;
			pnt2[0].y+=1;
			pnt2[1].x+=1;
			pnt2[1].y+=1;
			pnt2[2].x+=1;
			pnt2[2].y+=1;
		}

		//DRAW_TRIANGLE(pnt2);

		pen.setColor(m_clroutline);

		//THUMB BAR LINE DESIGN

		g.pen = (pen);

		int new_y = this.top + 2;
		int new_b = this.bottom - 2;

		if (m_thumb_size > 80 + base+4) {
			for (height = 10; height < 40; height+=4) {
				g.drawLine(height+m_thumb_pos_x, new_y, height+m_thumb_pos_x, new_b);
			}

			//highlight pen
			g.pen = (pen_hlight);

			for (height = 11; height < 41; height+=4) {
				g.drawLine(height+m_thumb_pos_x, new_y, height+m_thumb_pos_x, new_b);
			}

			//outline pen
			g.pen = (pen);

			for (height = m_thumb_size - 39; height < m_thumb_size - 9; height+=4) {
				g.drawLine(height+m_thumb_pos_x, new_y, height+m_thumb_pos_x, new_b);
			}

			//highlight pen
			g.pen = (pen_hlight);

			for (height = m_thumb_size - 38; height < m_thumb_size - 8; height+=4) {
				g.drawLine(height+m_thumb_pos_x, new_y, height+m_thumb_pos_x, new_b);
			}

			//draw rectangle

			yB = this.left + m_thumb_pos_x + ((m_thumb_size - base) / 2);

			if (m_whatishovered == 3) {
				g.brush = (brsh_hlight);

				g.drawRect(yB, xH, yB+base, xH+base);

				pen.setColor(m_clrnormal);
			}
			else {
				pen.setColor(m_clrnormal);

				g.brush = (brsh);
				g.pen = (pen);

				g.drawRect(yB, xH, yB+base, xH+base);
			}
		}
		else if (m_thumb_size > 25) {
			//find the rectangle's position
			//draw lines outward from that...

			yB = m_thumb_pos_x + ((m_thumb_size - base) / 2);

			//height = 10; height < 40

			//total_value_space is a counter; counts the number of lines that will fit
			for (total_value_space=0, height = yB + base + 2; height < m_thumb_pos_x + m_thumb_size - 9; height+=4, total_value_space++) {
				g.drawLine(height, new_y, height, new_b);
			}
			for (height = yB-3 ; total_value_space > 0; height-=4, total_value_space--) {
				g.drawLine(height, new_y, height, new_b);
			}

			//highlight pen
			g.pen = (pen_hlight);

			for (total_value_space=0, height = yB + base+3; height < m_thumb_pos_x + m_thumb_size - 8; height+=4, total_value_space++) {
				g.drawLine(height, new_y, height, new_b);
			}
			for (height = yB-2; total_value_space > 0; height-=4, total_value_space--) {
				g.drawLine(height, new_y, height, new_b);
			}

			if (m_whatishovered == 3) {
				g.brush = (brsh_hlight);

				g.drawRect(yB, xH, yB+base, xH+base);

				pen.setColor(m_clrnormal);
			}
			else {

				pen.setColor(m_clrnormal);

				g.brush = (brsh);
				g.pen = (pen);

				g.drawRect(yB, xH, yB+base, xH+base);
			}
		}
		else if(m_thumb_size > 15) {
			yB = this.left + m_thumb_pos_x + ((m_thumb_size - base) / 2);

			if (m_whatishovered == 3) {
				g.brush = (brsh_hlight);
				g.pen = (pen_hlight);

				g.drawRect(yB, xH, yB+base, xH+base);

				pen.setColor(m_clrnormal);
			}
			else {
				pen.setColor(m_clrnormal);

				g.brush = (brsh);
				g.pen = (pen);

				g.drawRect(yB, xH, yB+base, xH+base);
			}
		}

		g.brush = (brsh);
		g.pen = (pen_hlight);

		new_y--;
		new_b++;

		//UP BUTTON
		if (m_isclicked == 1) {
			g.pen = (pen);

			g.drawLine(this.left+1, new_y, this.left+1, new_b);
			g.drawLine(this.left+1, new_y, this.left+this.height-1, new_y);

			g.pen = (pen_hlight);
		}
		else {
			g.drawLine(this.left+1, new_y, this.left+1, new_b);
			g.drawLine(this.left+1, new_y, this.left+this.height-1, new_y);
		}

		//DOWN BUTTON
		if (m_isclicked == 2) {
			g.pen = (pen);

			g.drawLine(this.right-this.height+1, new_y, this.right-this.height+1, new_b);
			g.drawLine(this.right-this.height+1, new_y, this.right-1, new_y);

			g.pen = (pen_hlight);
		}
		else {
			g.drawLine(this.right-this.height+1, new_y, this.right-this.height+1, new_b);
			g.drawLine(this.right-this.height+1, new_y, this.right-1, new_y);
		}

		//THUMB BAR
		if (m_isclicked == 3) {
			g.pen = (pen);

			g.drawLine(m_thumb_pos_x+1, new_y, m_thumb_pos_x+1, new_b);
			g.drawLine(m_thumb_pos_x+1, new_y, m_thumb_pos_r-1, new_y);
		}
		else {
			g.drawLine(m_thumb_pos_x+1, new_y, m_thumb_pos_x+1, new_b);
			g.drawLine(m_thumb_pos_x+1, new_y, m_thumb_pos_r-1, new_y);
		}
	}

	override bool onMouseMove(ref Mouse mouseProps) {
		if (m_isclicked == 3) {
			//thumb bar is moving

			//move thumb bar and set value accordingly

			mouseProps.x -= m_thumb_offset;

			//y is now the y position of where the thumb would be now

			if (mouseProps.x < this.left + this.height) {
				mouseProps.x = this.left + this.height;
			}

			if (mouseProps.x > this.left + this.height + m_area) {
				mouseProps.x = this.left + this.height + m_area;
			}

			//compute value

			long old_value = m_value;
			m_value = ( cast(long) ( ( cast(float)(mouseProps.x - this.left - this.height) / cast(float)(m_area) ) * cast(float)(m_max - m_min) ) ) + m_min;

			if (m_value != old_value) {
				raiseSignal(Signal.Scrolled);
				return true;
			}

			return false;
		}

		//check if something is being hovered over
		if (mouseProps.y > this.top && mouseProps.y < this.bottom && mouseProps.x > this.left && mouseProps.x < this.right) {
			if (mouseProps.x - this.left < this.height) {
				//up button
				if (m_isclicked == 0 || m_isclicked == 1) {
					if (m_whatishovered != 1) {
						m_whatishovered = 1;

						return true;
					}
				}

				return false;
			}
			else if (mouseProps.x > this.right - this.height) {
				//down button
				if (m_isclicked == 0 || m_isclicked == 2) {
					if (m_whatishovered != 2) {
						m_whatishovered = 2;

						return true;
					}
				}

				return false;
			}
			else if (mouseProps.x > m_thumb_pos_x && mouseProps.x < m_thumb_pos_r) {
				//thumb bar
				if (m_isclicked == 0 || m_isclicked == 3) {
					if (m_whatishovered != 3) {
						m_whatishovered = 3;
						return true;
					}
				}

				return false;
			}
			else if (mouseProps.x < m_thumb_pos_x) {
				//inner area UP

				m_last_x = mouseProps.x;
				m_last_y = mouseProps.y;

				if (m_isclicked == 0 || m_isclicked == 4) {
					if (m_whatishovered != 4) {
						if (m_whatishovered != 0) {
							m_whatishovered = 4;
							return true;
						}

						m_whatishovered = 4;
					}
				}

				return false;
			}
			else {
				//inner area DOWN

				m_last_x = mouseProps.x;
				m_last_y = mouseProps.y;

				if (m_isclicked == 0 || m_isclicked == 5) {
					if (m_whatishovered != 5) {
						if (m_whatishovered != 0) {
							m_whatishovered = 5;
							return true;
						}
						m_whatishovered = 5;
					}
				}

				return false;
			}
		}

		//nothing
		if (m_whatishovered != 0) {
			m_whatishovered = 0;

			return true;
		}

		return false;
	}

	override bool onMouseLeave() {
		if (m_isclicked == 3) {
			return false;
		}

		if (m_whatishovered != 0) {
			m_whatishovered = 0;
			return true;
		}

		return false;
	}

	override bool onPrimaryMouseDown(ref Mouse mouseProps) {
		if (m_whatishovered != 0) {
			m_isclicked = m_whatishovered;

			requestCapture();

			if (m_isclicked == 3) {
				//thumb bar clicked

				//the number of pixels from the left edge of thumb bar is mouse = m_thumb_offset
				m_thumb_offset = mouseProps.x - m_thumb_pos_x;
			}
			else {
				//buttons / inner area clicked

				//stop timers if running
				_clickTimer.stop();
				_readyTimer.stop();

				_Move();

				_readyTimer.start();
			}

			return true;
		}

		return false;
	}

	override bool onPrimaryMouseUp(ref Mouse mouseProps) {
		if (m_isclicked > 0) {
			if (m_isclicked == 3) {
				m_isclicked = 0;

				onMouseMove(mouseProps);
			}

			requestRelease();

			//stop timers if they are running
			_clickTimer.stop();
			_readyTimer.stop();

			m_isclicked = 0;
			return true;
		}

		return false;
	}

protected:

	void readyTimerProc() {
		//create real timer
		_clickTimer.start();

		_window.redraw();
	}

	void clickTimerProc() {
		_Move();

		_window.redraw();
	}

	void _Move() {
		float percent;

		//look at what is currently being hovered over
		switch (m_whatishovered) {
		case 1: //left button
			m_value -= m_small_change;
			if (m_value<m_min) { m_value = m_min; }

			raiseSignal(Signal.Scrolled);

			break;
		case 2: //right button
			m_value += m_small_change;
			if (m_value>m_max) { m_value = m_max; }

			raiseSignal(Signal.Scrolled);

			break;
		case 4: //inner area UP
			m_value -= m_large_change;
			if (m_value<m_min) { m_value = m_min; }

			//must check to see if we are hovering over the thumb bar

			percent = cast(float)m_large_change / cast(float)(m_large_change + (m_max - m_min));

			m_area = (this.height - (this.width*2))+2;

			m_thumb_size = cast(int)(cast(float)m_area * percent);

			if (m_thumb_size < 10) { m_thumb_size = 10; }

			m_area -= m_thumb_size;

			percent = cast(float)(m_value - m_min) / cast(float)(m_max - m_min);
			m_thumb_pos_x = cast(int)(cast(float)m_area * percent) + this.left + this.height-1;
			m_thumb_pos_r = m_thumb_pos_x + m_thumb_size;

			//compare last mouse coords with this state

			if (m_last_x > m_thumb_pos_x && m_last_x < m_thumb_pos_r) {
				//hmm
				//stop: we are hovering the thumb bar

				m_whatishovered = 3;

				_clickTimer.stop();
			}

			raiseSignal(Signal.Scrolled);

			break;

		case 5: //inner area DOWN
			m_value += m_large_change;
			if (m_value>m_max) { m_value = m_max; }

			//must check to see if we are hovering over the thumb bar

			percent = cast(float)m_large_change / cast(float)(m_large_change + (m_max - m_min));

			m_area = (this.height - (this.width*2))+2;

			m_thumb_size = cast(int)(cast(float)m_area * percent);

			if (m_thumb_size < 10) { m_thumb_size = 10; }

			m_area -= m_thumb_size;

			percent = cast(float)(m_value - m_min) / cast(float)(m_max - m_min);
			m_thumb_pos_x = cast(int)(cast(float)m_area * percent) + this.left + this.height-1;
			m_thumb_pos_r = m_thumb_pos_x + m_thumb_size;

			//compare last mouse coords with this state

			if (m_last_x >= m_thumb_pos_x && m_last_x <= m_thumb_pos_r) {
				//hmm
				//stop: we are hovering the thumb bar

				m_whatishovered = 3;

				_clickTimer.stop();
			}

			raiseSignal(Signal.Scrolled);

			break;

		default:
			break;
		}
	}

	Color m_clroutline;
	Color m_clrarea;
	Color m_clrbutton;
	Color m_clrthumb;
	Color m_clrhighlight;
	Color m_clrhover;
	Color m_clrnormal;

	int m_thumb_pos_x; //x (left) coord
	int m_thumb_pos_r; //r (right) coord
	int m_thumb_size;
	int m_area;

	Timer _clickTimer;
	Timer _readyTimer;

	int m_whatishovered;
	int m_isclicked;

	int m_thumb_offset;

	int m_last_x;
	int m_last_y;

	long m_min=0;
	long m_max=30;
	long m_value=0;

	long m_large_change=5;
	long m_small_change=1;
}

