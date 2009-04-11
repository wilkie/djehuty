
module core.graphics;

import core.view;
import core.image;
import core.definitions;
import core.string;
import core.color;

public import graphics.brush;
public import graphics.pen;
public import graphics.font;
public import graphics.region;

import platform.imports;
mixin(PlatformGenericImport!("vars"));
mixin(PlatformScaffoldImport!());

// Section: Core

// Description: This class encapsulates drawing functions for a view class.  It will draw primitives to a view canvas.
class Graphics
{

// Primitives

	// Description: Draws a line from (x,y) to (x2,y2).
	// x: The first coordinate's x value.
	// y: The first coordinate's y value.
	// x2: The second coordinate's x value.
	// y2: The second coordinate's y value.
	void drawLine(int x, int y, int x2, int y2)
	{
		Scaffold.drawLine(_viewVars, x,y,x2,y2);
	}

	// Description: Draws a rectangle defined by the top-left point: (x,y) and the bottom-right point: (x2,y2).
	// x: The first coordinate's x value.
	// y: The first coordinate's y value.
	// x2: The second coordinate's x value.
	// y2: The second coordinate's y value.
	void drawRect(int x, int y, int x2, int y2)
	{
		Scaffold.drawRect(_viewVars, x,y,x2,y2);
	}

	// Description: Draws a ellipse inscribed by the rectangle defined by the top-left point: (x,y) and the bottom-right point: (x2,y2).
	// x: The first coordinate's x value.
	// y: The first coordinate's y value.
	// x2: The second coordinate's x value.
	// y2: The second coordinate's y value.
	void drawOval(int x, int y, int x2, int y2)
	{
		Scaffold.drawOval(_viewVars, x,y,x2,y2);
	}

	// Description: Draws the region given.
	// rgn: The region to draw.
	void drawRegion(Region rgn)
	{
	}

// Text


	// Description: Draws the string starting with the top-left point of the text at the point (x,y).
	// x: The x coordinate to start rendering the text.
	// y: The y coordinate to start rendering the text.
	// str: The string to render.
	void drawText(int x, int y, String str)
	{
		Scaffold.drawText(_viewVars, x,y,str);
	}

	// Description: Draws the string starting with the top-left point of the text at the point (x,y).
	// x: The x coordinate to start rendering the text.
	// y: The y coordinate to start rendering the text.
	// str: The string to render.
	void drawText(int x, int y, StringLiteral str)
	{
		Scaffold.drawText(_viewVars, x,y,str);
	}

	// Description: Draws the string starting with the top-left point of the text at the point (x,y) and only up to the number of characters specified by length.
	// x: The x coordinate to start rendering the text.
	// y: The y coordinate to start rendering the text.
	// str: The string to render.
	void drawText(int x, int y, String str, uint length)
	{
		Scaffold.drawText(_viewVars, x,y,str,length);
	}

	// Description: Draws the string starting with the top-left point of the text at the point (x,y) and only up to the number of characters specified by length.
	// x: The x coordinate to start rendering the text.
	// y: The y coordinate to start rendering the text.
	// str: The string to render.
	// length: the length of the string.
	void drawText(int x, int y, StringLiteral str, uint length)
	{
		Scaffold.drawText(_viewVars, x,y,str,length);
	}

// Clipped Text

	// Description: Draws the string starting with the top-left point of the text at the point (x,y) and clips it within a rectangular region.
	// x: The x coordinate to start rendering the text.
	// y: The y coordinate to start rendering the text.
	// region: The Rect object that defines the rectangular clipping region.
	// str: The string to render.
	void drawClippedText(int x, int y, Rect region, String str)
	{
		Scaffold.drawClippedText(_viewVars, x,y,region,str);
	}

	// Description: Draws the string starting with the top-left point of the text at the point (x,y) and clips it within a rectangular region.
	// x: The x coordinate to start rendering the text.
	// y: The y coordinate to start rendering the text.
	// region: The Rect object that defines the rectangular clipping region.
	// str: The string to render.
	void drawClippedText(int x, int y, Rect region, StringLiteral str)
	{
		Scaffold.drawClippedText(_viewVars, x,y,region,str);
	}

	// Description: Draws the string starting with the top-left point of the text at the point (x,y) up to the specified number of characters and clips it within a rectangular region.
	// x: The x coordinate to start rendering the text.
	// y: The y coordinate to start rendering the text.
	// region: The Rect object that defines the rectangular clipping region.
	// str: The string to render.
	// length: the length of the string.
	void drawClippedText(int x, int y, Rect region, String str, uint length)
	{
		Scaffold.drawClippedText(_viewVars, x,y,region,str,length);
	}

	// Description: Draws the string starting with the top-left point of the text at the point (x,y) up to the specified number of characters and clips it within a rectangular region.
	// x: The x coordinate to start rendering the text.
	// y: The y coordinate to start rendering the text.
	// region: The Rect object that defines the rectangular clipping region.
	// str: The string to render.
	// length: the length of the string.
	void drawClippedText(int x, int y, Rect region, StringLiteral str, uint length)
	{
		Scaffold.drawClippedText(_viewVars, x,y,region,str,length);
	}

// Text Measurement

	// Description: Will update the Size variable with the width and height of the text as it would be rendered.
	// str: The string to measure.
	// sz: The Size struct to update.
	void measureText(String str, out Size sz)
	{
		Scaffold.measureText(_viewVars, str, sz);
	}

	// Description: Will update the Size variable with the width and height of the text as it would be rendered.
	// str: The string to measure.
	// length: The length of the string to consider.
	// sz: The Size struct to update.
	void measureText(String str, uint length, out Size sz)
	{
		Scaffold.measureText(_viewVars, str, length, sz);
	}

	// Description: Will update the Size variable with the width and height of the text as it would be rendered.
	// str: The string to measure.
	// sz: The Size struct to update.
	void measureText(StringLiteral str, out Size sz)
	{
		Scaffold.measureText(_viewVars, str, sz);
	}

	// Description: Will update the Size variable with the width and height of the text as it would be rendered.
	// str: The string to measure.
	// length: The length of the string to consider.
	// sz: The Size struct to update.
	void measureText(StringLiteral str, uint length, out Size sz)
	{
		Scaffold.measureText(_viewVars, str, length, sz);
	}

// Text Colors

	// Description: Will set the text background color, sometimes refered to as the highlight color.
	// textColor: The Color structure to be used as the background color.
	void setTextBackgroundColor(ref Color textColor)
	{
		Scaffold.setTextBackgroundColor(_viewVars, textColor);
	}

	// Description: Will set the text foreground color.
	// textColor: The Color structure to be used as the background color.
	void setTextColor(ref Color textColor)
	{
		Scaffold.setTextColor(_viewVars, textColor);
	}

// Text States

	// Description: Will set the text mode to not draw the background behind the rendered text.
	void setTextModeTransparent()
	{
		Scaffold.setTextModeTransparent(_viewVars);
	}

	// Description: Will set the text mode so that it draws the background behind the rendered text using the color given by setTextBackgroundColor.
	void setTextModeOpaque()
	{
		Scaffold.setTextModeOpaque(_viewVars);
	}

// Fonts

	void setFont(ref Font font)
	{
		Scaffold.setFont(_viewVars, FontGetPlatformVars(font));
	}

// Brushes

	// Description: Will set the fill type to that specified by the Brush object.
	// brush: The Brush to use.
	void setBrush(ref Brush brush)
	{
		Scaffold.setBrush(_viewVars, BrushGetPlatformVars(brush));
		ViewSetBrush(_view, brush);
	}

// Pens

	// Description: Will set the stroke type to that specified by the Pen object.
	// pen: The Pen to use.
	void setPen(ref Pen pen)
	{
		Scaffold.setPen(_viewVars, PenGetPlatformVars(pen));
		ViewSetPen(_view, pen);
	}

// View Interfacing

	// Description: Will draw the image stored by the view object onto the current view object at the coordinate (x,y).
	// x: The x coordinate to place the top-left corner of the image.
	// y: The y coordinate to place the top-left corner of the image.
	// view: The view in which to draw.
	void drawView(int x, int y, ref View view)
	{
		view.lockDisplay();

		ViewPlatformVars* viewVarsSrc = ViewGetPlatformVars(view);

		Scaffold.drawView(_viewVars, _view, x, y, viewVarsSrc, view);

		view.unlockDisplay();
	}

	// Description: Will draw the cropped image stored by the view object onto the current view object at the coordinate (x,y).
	// x: The x coordinate to place the top-left corner of the image.
	// y: The y coordinate to place the top-left corner of the image.
	// view: The view in which to draw.
	// viewX: The x coordinate to crop the image.  Everything from this X to X + viewWidth of the view will be drawn.
	// viewY: The y coordinate to crop the image.  Everything from this Y to Y + viewHeight of the view will be drawn.
	void drawView(int x, int y, ref View view, int viewX, int viewY)
	{
		view.lockDisplay();

		ViewPlatformVars* viewVarsSrc = ViewGetPlatformVars(view);

		Scaffold.drawView(_viewVars, _view, x, y, viewVarsSrc, view, viewX, viewY);

		view.unlockDisplay();
	}

	// Description: Will draw the cropped image stored by the view object onto the current view object at the coordinate (x,y).
	// x: The x coordinate to place the top-left corner of the image.
	// y: The y coordinate to place the top-left corner of the image.
	// view: The view in which to draw.
	// viewX: The x coordinate to crop the image.  Everything from this X to X + viewWidth of the view will be drawn.
	// viewY: The y coordinate to crop the image.  Everything from this Y to Y + viewHeight of the view will be drawn.
	// viewWidth: The width of the region to crop from the source image.
	// viewHeight: The height of the region to crop from the source image.
	void drawView(int x, int y, ref View view, int viewX, int viewY, int viewWidth, int viewHeight)
	{
		view.lockDisplay();

		ViewPlatformVars* viewVarsSrc = ViewGetPlatformVars(view);

		Scaffold.drawView(_viewVars, _view, x, y, viewVarsSrc, view, viewX, viewY, viewWidth, viewHeight);

		view.unlockDisplay();
	}

	// Description: Will draw the image stored by the view object onto the current view object at the coordinate (x,y) at an opacity of the fraction given.
	// x: The x coordinate to place the top-left corner of the image.
	// y: The y coordinate to place the top-left corner of the image.
	// view: The view in which to draw.
	// opacity: The opacity.  1.0 is full opacity.  0.0 will result in no image, as this is full transparency.
	void drawView(int x, int y, ref View view, double opacity)
	{
		view.lockDisplay();

		ViewPlatformVars* viewVarsSrc = ViewGetPlatformVars(view);

		Scaffold.drawView(_viewVars, _view, x, y, viewVarsSrc, view, opacity);

		view.unlockDisplay();
	}

	// Description: Will draw the cropped image stored by the view object onto the current view object at the coordinate (x,y) at an opacity of the fraction given.
	// x: The x coordinate to place the top-left corner of the image.
	// y: The y coordinate to place the top-left corner of the image.
	// view: The view in which to draw.
	// viewX: The x coordinate to crop the image.  Everything from this X to X + viewWidth of the view will be drawn.
	// viewY: The y coordinate to crop the image.  Everything from this Y to Y + viewHeight of the view will be drawn.
	// opacity: The opacity.  1.0 is full opacity.  0.0 will result in no image, as this is full transparency.
	void drawView(int x, int y, ref View view, int viewX, int viewY, double opacity)
	{
		view.lockDisplay();

		ViewPlatformVars* viewVarsSrc = ViewGetPlatformVars(view);

		Scaffold.drawView(_viewVars, _view, x, y, viewVarsSrc, view, viewX, viewY, opacity);

		view.unlockDisplay();
	}

	// Description: Will draw the cropped image stored by the view object onto the current view object at the coordinate (x,y) at an opacity of the fraction given.
	// x: The x coordinate to place the top-left corner of the image.
	// y: The y coordinate to place the top-left corner of the image.
	// view: The view in which to draw.
	// viewX: The x coordinate to crop the image.  Everything from this X to X + viewWidth of the view will be drawn.
	// viewY: The y coordinate to crop the image.  Everything from this Y to Y + viewHeight of the view will be drawn.
	// viewWidth: The width of the region to crop from the source image.
	// viewHeight: The height of the region to crop from the source image.
	// opacity: The opacity.  1.0 is full opacity.  0.0 will result in no image, as this is full transparency.
	void drawView(int x, int y, ref View view, int viewX, int viewY, int viewWidth, int viewHeight, double opacity)
	{
		view.lockDisplay();

		ViewPlatformVars* viewVarsSrc = ViewGetPlatformVars(view);

		Scaffold.drawView(_viewVars, _view, x, y, viewVarsSrc, view, viewX, viewY, viewWidth, viewHeight, opacity);

		view.unlockDisplay();
	}

// Image Interfacing

	// Description: Will draw the image to the current view object at the coordinate (x,y).
	// x: The x coordinate to place the top-left corner of the image.
	// y: The y coordinate to place the top-left corner of the image.
	// image: The image to draw.
	void drawImage(int x, int y, ref Image image)
	{
		ImageLock(image);
		View v = image.getView();
		if (v !is null)
		{
			drawView(x, y, v);
		}
		ImageUnlock(image);
	}

	// Description: Will draw the image to the current view object at the coordinate (x,y) while cropping the image at the coordinate (srcX, srcY).
	// x: The x coordinate to place the top-left corner of the image.
	// y: The y coordinate to place the top-left corner of the image.
	// image: The image to draw.
	// srcX: The x coordinate to crop the image.  The top-left corner of the render will correspond to the top-left corner of this cropped region.
	// srcY: The y coordinate to crop the image.  The top-left corner of the render will correspond to the top-left corner of this cropped region.
	void drawImage(int x, int y, ref Image image, int srcX, int srcY)
	{
		ImageLock(image);
		View v = image.getView();
		if (v !is null)
		{
			drawView(x, y, v, srcX, srcY);
		}
		ImageUnlock(image);
	}

	// Description: Will draw the image to the current view object at the coordinate (x,y) while cropping the image at the coordinate (srcX, srcY) with the region sized by srcW and srcH.
	// x: The x coordinate to place the top-left corner of the image.
	// y: The y coordinate to place the top-left corner of the image.
	// image: The image to draw.
	// srcX: The x coordinate to crop the image.  The top-left corner of the render will correspond to the top-left corner of this cropped region.
	// srcY: The y coordinate to crop the image.  The top-left corner of the render will correspond to the top-left corner of this cropped region.
	// srcW: The width of the cropped region.
	// srcH: The height of the cropped region.
	void drawImage(int x, int y, ref Image image, int srcX, int srcY, int srcW, int srcH)
	{
		ImageLock(image);
		View v = image.getView();
		if (v !is null)
		{
			drawView(x, y, v, srcX, srcY, srcW, srcH);
		}
		ImageUnlock(image);
	}

	// Description: Will draw the image to the current view object at the coordinate (x,y) at an opacity of the fraction given.
	// x: The x coordinate to place the top-left corner of the image.
	// y: The y coordinate to place the top-left corner of the image.
	// image: The image to draw.
	// opacity: The opacity.  1.0 is full opacity.  0.0 will result in no image, as this is full transparency.
	void drawImage(int x, int y, ref Image image, double opacity)
	{
		ImageLock(image);
		View v = image.getView();
		if (v !is null)
		{
			drawView(x, y, v, opacity);
		}
		ImageUnlock(image);
	}

	// Description: Will draw the image to the current view object at the coordinate (x,y) while cropping the image at the coordinate (srcX, srcY) at an opacity of the fraction given.
	// x: The x coordinate to place the top-left corner of the image.
	// y: The y coordinate to place the top-left corner of the image.
	// image: The image to draw.
	// srcX: The x coordinate to crop the image.  The top-left corner of the render will correspond to the top-left corner of this cropped region.
	// srcY: The y coordinate to crop the image.  The top-left corner of the render will correspond to the top-left corner of this cropped region.
	// opacity: The opacity.  1.0 is full opacity.  0.0 will result in no image, as this is full transparency.
	void drawImage(int x, int y, ref Image image, int srcX, int srcY, double opacity)
	{
		ImageLock(image);
		View v = image.getView();
		if (v !is null)
		{
			drawView(x, y, v, srcX, srcY, opacity);
		}
		ImageUnlock(image);
	}

	// Description: Will draw the image to the current view object at the coordinate (x,y) while cropping the image at the coordinate (srcX, srcY) with the region sized by srcW and srcH at an opacity of the fraction given.
	// x: The x coordinate to place the top-left corner of the image.
	// y: The y coordinate to place the top-left corner of the image.
	// image: The image to draw.
	// srcX: The x coordinate to crop the image.  The top-left corner of the render will correspond to the top-left corner of this cropped region.
	// srcY: The y coordinate to crop the image.  The top-left corner of the render will correspond to the top-left corner of this cropped region.
	// srcW: The width of the cropped region.
	// srcH: The height of the cropped region.
	// opacity: The opacity.  1.0 is full opacity.  0.0 will result in no image, as this is full transparency.
	void drawImage(int x, int y, ref Image image, int srcX, int srcY, int srcW, int srcH, double opacity)
	{
		ImageLock(image);
		View v = image.getView();
		if (v !is null)
		{
			drawView(x, y, v, srcX, srcY, srcW, srcH, opacity);
		}
		ImageUnlock(image);
	}

// Clipping

	// Description: Will push the clip region to a stack preserving its state.
	void clipSave()
	{
		Scaffold.clipSave(_viewVars);
	}

	// Description: If possible, will restore the clip state most recently saved via clipSave().
	void clipRestore()
	{
		Scaffold.clipRestore(_viewVars);
	}

	// Description: Unions the current clip region with a rectangle region defined by the top-left point: (x,y) and the bottom-right point: (x2,y2).
	// x: The first coordinate's x value.
	// y: The first coordinate's y value.
	// x2: The second coordinate's x value.
	// y2: The second coordinate's y value.
	void clipRect(int x, int y, int x2, int y2)
	{
		Scaffold.clipRect(_viewVars, x,y,x2,y2);
	}

	// Description: Unions the current clip region with the region given.
	// rgn: The region to clip.
	void clipRegion(Region rgn)
	{
		Scaffold.clipRegion(_viewVars, rgn);
	}

protected:

	// a backward reference to the view object
	View _view;
	ViewPlatformVars* _viewVars;
}


void GraphicsSetViewVars(Graphics g, ref View view, ref ViewPlatformVars vars)
{
	g._viewVars = &vars;
	g._view = view;
}

