/*
 * graphics.d
 *
 * This file contains the logic behind functions that draw to a View.
 *
 * Author: Dave Wilkinson
 *
 */

module graphics.graphics;

import graphics.view;

import resource.image;

import core.definitions;
import core.string;
import core.color;

public import graphics.brush;
public import graphics.pen;
public import graphics.font;
public import graphics.region;
public import graphics.gradient;

import platform.vars.view;
import platform.vars.brush;
import platform.vars.font;
import platform.vars.pen;
import platform.vars.region;

import Scaffold = scaffold.graphics;

// Section: Core

// Description: This class encapsulates drawing functions for a view class.  It will draw primitives to a view canvas.
class Graphics {
protected:

	bool _antialias = false;

	// a backward reference to the view object
	package View _view;
	package ViewPlatformVars* _viewVars;

public:
// Primitives

	// Description: Draws a line from (x,y) to (x2,y2).
	// x: The first coordinate's x value.
	// y: The first coordinate's y value.
	// x2: The second coordinate's x value.
	// y2: The second coordinate's y value.
	void drawLine(int x, int y, int x2, int y2) {
		Scaffold.drawLine(_viewVars, x,y,x2,y2);
	}

	// Description: Draws a rectangle defined by the top-left point: (x,y) and some size.
	// x: The top-left coordinate's x value.
	// y: The top-left coordinate's y value.
	// width: The width of the rectangle to draw.
	// height: The height of the rectangle to draw.
	void drawRect(int x, int y, int width, int height) {
//		Scaffold.drawRect(_viewVars, x,y,width,height);
	}

	// Description: Fills a rectangle defined by the top-left point: (x,y) and some size.
	// x: The top-left coordinate's x value.
	// y: The top-left coordinate's y value.
	// width: The width of the rectangle to draw.
	// height: The height of the rectangle to draw.
	void fillRect(int x, int y, int width, int height) {
//		Scaffold.fillRect(_viewVars, x, y, width, height);
	}

	// Description: Outlines a rectangle defined by the top-left point: (x,y) and some size.
	// x: The top-left coordinate's x value.
	// y: The top-left coordinate's y value.
	// width: The width of the rectangle to draw.
	// height: The height of the rectangle to draw.
	void strokeRect(int x, int y, int width, int height) {
//		Scaffold.strokeRect(_viewVars, x, y, width, height);
	}

	// Description: Draws an ellipse inscribed by the rectangle defined by the top-left point: (x,y) and some size.
	// x: The top-left coordinate's x value.
	// y: The top-left coordinate's y value.
	// width: The width of the rectangle to use to inscribe.
	// height: The height of the rectangle to use to inscribe.
	void drawOval(int x, int y, int width, int height) {
//		Scaffold.drawOval(_viewVars, x,y,width,height);
	}

	// Description: Fills an ellipse inscribed by the rectangle defined by the top-left point: (x,y) and some size.
	// x: The top-left coordinate's x value.
	// y: The top-left coordinate's y value.
	// width: The width of the rectangle to use to inscribe.
	// height: The height of the rectangle to use to inscribe.
	void fillOval(int x, int y, int width, int height) {
//		Scaffold.fillOval(_viewVars, x,y,width,height);
	}

	// Description: Outlines an ellipse inscribed by the rectangle defined by the top-left point: (x,y) and some size.
	// x: The top-left coordinate's x value.
	// y: The top-left coordinate's y value.
	// width: The width of the rectangle to use to inscribe.
	// height: The height of the rectangle to use to inscribe.
	void strokeOval(int x, int y, int width, int height) {
//		Scaffold.strokeOval(_viewVars, x,y,width,height);
	}

	// Description: Draws the region given.
	// x: The amount to translate the region in the x direction.
	// y: The amount to translate the region in the y direction.
	// rgn: The region to draw.
	void drawRegion(int x, int y, Region rgn) {
		rgn.platformDirty = false;
		Scaffold.drawRegion(_viewVars, &rgn._pfvars, rgn.platformDirty, rgn, x, y);
	}

	// Description: Fills the region given.
	// x: The amount to translate the region in the x direction.
	// y: The amount to translate the region in the y direction.
	// rgn: The region to fill.
	void fillRegion(int x, int y, Region rgn) {
		rgn.platformDirty = false;
		Scaffold.fillRegion(_viewVars, &rgn._pfvars, rgn.platformDirty, rgn, x, y);
	}

	// Description: Outlines the region given.
	// x: The amount to translate the region in the x direction.
	// y: The amount to translate the region in the y direction.
	// rgn: The region to stroke.
	void strokeRegion(int x, int y, Region rgn) {
		rgn.platformDirty = false;
		Scaffold.strokeRegion(_viewVars, &rgn._pfvars, rgn.platformDirty, rgn, x, y);
	}

	// Description: Draws a pie wedge within the rectangular region given with the top-left point of the pie at the point (x,y). The wedge will be from the startAngle and have an arc length of the sweepAngle.
	// x: The top-left coordinate's x value.
	// y: The top-left coordinate's y value.
	// width: The width of the rectangle to use to inscribe.
	// height: The height of the rectangle to use to inscribe.
	// startAngle: The angle to start the pie wedge.
	// sweepAngle: The length of the arc to draw.
	void drawPie(int x, int y, int width, int height, double startAngle, double sweepAngle) {
		Scaffold.drawPie(_viewVars, x, y, width, height, startAngle, sweepAngle);
	}

	// Description: Outlines a pie wedge within the rectangular region given with the top-left point of the pie at the point (x,y). The wedge will be from the startAngle and have an arc length of the sweepAngle.
	// x: The top-left coordinate's x value.
	// y: The top-left coordinate's y value.
	// width: The width of the rectangle to use to inscribe.
	// height: The height of the rectangle to use to inscribe.
	// startAngle: The angle to start the pie wedge.
	// sweepAngle: The length of the arc to draw.
	void strokePie(int x, int y, int width, int height, double startAngle, double sweepAngle) {
		Scaffold.strokePie(_viewVars, x, y, width, height, startAngle, sweepAngle);
	}

	// Description: Fills a pie wedge within the rectangular region given with the top-left point of the pie at the point (x,y). The wedge will be from the startAngle and have an arc length of the sweepAngle.
	// x: The top-left coordinate's x value.
	// y: The top-left coordinate's y value.
	// width: The width of the rectangle to use to inscribe.
	// height: The height of the rectangle to use to inscribe.
	// startAngle: The angle to start the pie wedge.
	// sweepAngle: The length of the arc to draw.
	void fillPie(int x, int y, int width, int height, double startAngle, double sweepAngle) {
		Scaffold.fillPie(_viewVars, x, y, width, height, startAngle, sweepAngle);
	}

// Text

	// Description: Draws the string starting with the top-left point of the text at the point (x,y).
	// x: The x coordinate to start rendering the text.
	// y: The y coordinate to start rendering the text.
	// str: The string to render.
	void drawText(int x, int y, string str) {
		Scaffold.drawText(_viewVars, x,y,str);
	}

	// Description: Draws the string starting with the top-left point of the text at the point (x,y) and only up to the number of characters specified by length.
	// x: The x coordinate to start rendering the text.
	// y: The y coordinate to start rendering the text.
	// str: The string to render.
	// length: the length of the string.
	void drawText(int x, int y, string str, uint length) {
		Scaffold.drawText(_viewVars, x,y,str,length);
	}

// Clipped Text

	// Description: Draws the string starting with the top-left point of the text at the point (x,y) and clips it within a rectangular region.
	// x: The x coordinate to start rendering the text.
	// y: The y coordinate to start rendering the text.
	// region: The Rect object that defines the rectangular clipping region.
	// str: The string to render.
	void drawClippedText(int x, int y, Rect region, string str) {
		Scaffold.drawClippedText(_viewVars, x,y,region,str);
	}

	// Description: Draws the string starting with the top-left point of the text at the point (x,y) up to the specified number of characters and clips it within a rectangular region.
	// x: The x coordinate to start rendering the text.
	// y: The y coordinate to start rendering the text.
	// region: The Rect object that defines the rectangular clipping region.
	// str: The string to render.
	// length: the length of the string.
	void drawClippedText(int x, int y, Rect region, string str, uint length) {
		Scaffold.drawClippedText(_viewVars, x,y,region,str,length);
	}

// Text Measurement

	// Description: Will update the Size variable with the width and height of the text as it would be rendered.
	// str: The string to measure.
	// sz: The Size struct to update.
	void measureText(string str, out Size sz) {
		Scaffold.measureText(_viewVars, str, sz);
	}

	// Description: Will update the Size variable with the width and height of the text as it would be rendered.
	// str: The string to measure.
	// length: The length of the string to consider.
	// sz: The Size struct to update.
	void measureText(string str, uint length, out Size sz) {
		Scaffold.measureText(_viewVars, str, length, sz);
	}

// Text Colors

	// Description: Will set the text background color, sometimes refered to as the highlight color.
	// textColor: The Color structure to be used as the background color.
	void backcolor(in Color textColor) {
		//Scaffold.setTextBackgroundColor(_viewVars, textColor);
	}

	// Description: Will set the text foreground color.
	// textColor: The Color structure to be used as the background color.
	void forecolor(in Color textColor) {
		Scaffold.setTextColor(_viewVars, textColor);
	}

// Text States

	// Description: Will set the text mode to not draw the background behind the rendered text.
	void setTextModeTransparent() {
		Scaffold.setTextModeTransparent(_viewVars);
	}

	// Description: Will set the text mode so that it draws the background behind the rendered text using the color given by setTextBackgroundColor.
	void setTextModeOpaque() {
		Scaffold.setTextModeOpaque(_viewVars);
	}

// Graphics States

	bool antialias() {
		return _antialias;
	}

	void antialias(bool value) {
		Scaffold.setAntialias(_viewVars, value);
		_antialias = value;
	}

// Fonts

	void font(ref Font font) {
		Scaffold.setFont(_viewVars, &font._pfvars);
	}

// Brushes

	// Description: Will set the fill type to that specified by the Brush object.
	// brush: The Brush to use.
	void brush(Brush brush) {
	/*	Scaffold.setBrush(_viewVars, &brush._pfvars);

		if (_view._brush !is null)
		{
			// unattach current brush
			_view._brush._view = null;
		}
		_view._brush = brush;

		// set the Brush's view
		brush._view = _view;*/
	}

// Pens

	// Description: Will set the stroke type to that specified by the Pen object.
	// pen: The Pen to use.
	void pen(Pen pen) {
//		Scaffold.setPen(_viewVars, &pen._pfvars);

		// set the pen in the view
/*		if (_view._pen !is null) {
			// unattach current pen
			_view._pen._view = null;
		}
		_view._pen = pen;

		// set the Pen's view
		pen._view = _view;*/
	}

// View Interfacing

	// Description: Will draw the image stored by the view object onto the current view object at the coordinate (x,y).
	// x: The x coordinate to place the top-left corner of the image.
	// y: The y coordinate to place the top-left corner of the image.
	// view: The view in which to draw.
	void drawView(int x, int y, View view) {
		if (view is _view) {
			// Holy recursion, Batman!
			// XXX: Exception
			return;
		}

		view.lock();

		ViewPlatformVars* viewVarsSrc = &view._pfvars;

//		Scaffold.drawView(_viewVars, _view, x, y, viewVarsSrc, view);

		view.unlock();
	}

	// Description: Will draw the cropped image stored by the view object onto the current view object at the coordinate (x,y).
	// x: The x coordinate to place the top-left corner of the image.
	// y: The y coordinate to place the top-left corner of the image.
	// view: The view in which to draw.
	// viewX: The x coordinate to crop the image.  Everything from this X to X + viewWidth of the view will be drawn.
	// viewY: The y coordinate to crop the image.  Everything from this Y to Y + viewHeight of the view will be drawn.
	void drawView(int x, int y, View view, int viewX, int viewY) {
		if (view is _view) {
			// Holy recursion, Batman!
			// XXX: Exception
			return;
		}
		view.lock();

		ViewPlatformVars* viewVarsSrc = &view._pfvars;

//		Scaffold.drawView(_viewVars, _view, x, y, viewVarsSrc, view, viewX, viewY);

		view.unlock();
	}

	// Description: Will draw the cropped image stored by the view object onto the current view object at the coordinate (x,y).
	// x: The x coordinate to place the top-left corner of the image.
	// y: The y coordinate to place the top-left corner of the image.
	// view: The view in which to draw.
	// viewX: The x coordinate to crop the image.  Everything from this X to X + viewWidth of the view will be drawn.
	// viewY: The y coordinate to crop the image.  Everything from this Y to Y + viewHeight of the view will be drawn.
	// viewWidth: The width of the region to crop from the source image.
	// viewHeight: The height of the region to crop from the source image.
	void drawView(int x, int y, View view, int viewX, int viewY, int viewWidth, int viewHeight) {
		if (view is _view) {
			// Holy recursion, Batman!
			// XXX: Exception
			return;
		}
		view.lock();

		ViewPlatformVars* viewVarsSrc = &view._pfvars;

		//Scaffold.drawView(_viewVars, _view, x, y, viewVarsSrc, view, viewX, viewY, viewWidth, viewHeight);

		view.unlock();
	}

	// Description: Will draw the image stored by the view object onto the current view object at the coordinate (x,y) at an opacity of the fraction given.
	// x: The x coordinate to place the top-left corner of the image.
	// y: The y coordinate to place the top-left corner of the image.
	// view: The view in which to draw.
	// opacity: The opacity.  1.0 is full opacity.  0.0 will result in no image, as this is full transparency.
	void drawView(int x, int y, View view, double opacity) {
		if (view is _view) {
			// Holy recursion, Batman!
			// XXX: Exception
			return;
		}
		view.lock();

		ViewPlatformVars* viewVarsSrc = &view._pfvars;

//		Scaffold.drawView(_viewVars, _view, x, y, viewVarsSrc, view, opacity);

		view.unlock();
	}

	// Description: Will draw the cropped image stored by the view object onto the current view object at the coordinate (x,y) at an opacity of the fraction given.
	// x: The x coordinate to place the top-left corner of the image.
	// y: The y coordinate to place the top-left corner of the image.
	// view: The view in which to draw.
	// viewX: The x coordinate to crop the image.  Everything from this X to X + viewWidth of the view will be drawn.
	// viewY: The y coordinate to crop the image.  Everything from this Y to Y + viewHeight of the view will be drawn.
	// opacity: The opacity.  1.0 is full opacity.  0.0 will result in no image, as this is full transparency.
	void drawView(int x, int y, View view, int viewX, int viewY, double opacity) {
		if (view is _view) {
			// Holy recursion, Batman!
			// XXX: Exception
			return;
		}
		view.lock();

		ViewPlatformVars* viewVarsSrc = &view._pfvars;

//		Scaffold.drawView(_viewVars, _view, x, y, viewVarsSrc, view, viewX, viewY, opacity);

		view.unlock();
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
	void drawView(int x, int y, View view, int viewX, int viewY, int viewWidth, int viewHeight, double opacity) {
		if (view is _view) {
			// Holy recursion, Batman!
			// XXX: Exception
			return;
		}
		view.lock();

		ViewPlatformVars* viewVarsSrc = &view._pfvars;

//		Scaffold.drawView(_viewVars, _view, x, y, viewVarsSrc, view, viewX, viewY, viewWidth, viewHeight, opacity);

		view.unlock();
	}

// Image Interfacing

	// Description: Will draw the image to the current view object at the coordinate (x,y).
	// x: The x coordinate to place the top-left corner of the image.
	// y: The y coordinate to place the top-left corner of the image.
	// image: The image to draw.
	void drawImage(int x, int y, Image image) {
//		ImageLock(image);
//		View v = image.view;
//		if (v !is null) {
//			drawView(x, y, v);
//		}
//		ImageUnlock(image);
	}

	// Description: Will draw the image to the current view object at the coordinate (x,y) while cropping the image at the coordinate (srcX, srcY).
	// x: The x coordinate to place the top-left corner of the image.
	// y: The y coordinate to place the top-left corner of the image.
	// image: The image to draw.
	// srcX: The x coordinate to crop the image.  The top-left corner of the render will correspond to the top-left corner of this cropped region.
	// srcY: The y coordinate to crop the image.  The top-left corner of the render will correspond to the top-left corner of this cropped region.
	void drawImage(int x, int y, Image image, int srcX, int srcY) {
//		ImageLock(image);
//		View v = image.view;
//		if (v !is null) {
//			drawView(x, y, v, srcX, srcY);
//		}
//		ImageUnlock(image);
	}

	// Description: Will draw the image to the current view object at the coordinate (x,y) while cropping the image at the coordinate (srcX, srcY) with the region sized by srcW and srcH.
	// x: The x coordinate to place the top-left corner of the image.
	// y: The y coordinate to place the top-left corner of the image.
	// image: The image to draw.
	// srcX: The x coordinate to crop the image.  The top-left corner of the render will correspond to the top-left corner of this cropped region.
	// srcY: The y coordinate to crop the image.  The top-left corner of the render will correspond to the top-left corner of this cropped region.
	// srcW: The width of the cropped region.
	// srcH: The height of the cropped region.
	void drawImage(int x, int y, Image image, int srcX, int srcY, int srcW, int srcH) {
//		ImageLock(image);
//		View v = image.view;
//		if (v !is null) {
//			drawView(x, y, v, srcX, srcY, srcW, srcH);
//		}
//		ImageUnlock(image);
	}

	// Description: Will draw the image to the current view object at the coordinate (x,y) at an opacity of the fraction given.
	// x: The x coordinate to place the top-left corner of the image.
	// y: The y coordinate to place the top-left corner of the image.
	// image: The image to draw.
	// opacity: The opacity.  1.0 is full opacity.  0.0 will result in no image, as this is full transparency.
	void drawImage(int x, int y, Image image, double opacity) {
//		ImageLock(image);
//		View v = image.view;
//		if (v !is null) {
//			drawView(x, y, v, opacity);
//		}
//		ImageUnlock(image);
	}

	// Description: Will draw the image to the current view object at the coordinate (x,y) while cropping the image at the coordinate (srcX, srcY) at an opacity of the fraction given.
	// x: The x coordinate to place the top-left corner of the image.
	// y: The y coordinate to place the top-left corner of the image.
	// image: The image to draw.
	// srcX: The x coordinate to crop the image.  The top-left corner of the render will correspond to the top-left corner of this cropped region.
	// srcY: The y coordinate to crop the image.  The top-left corner of the render will correspond to the top-left corner of this cropped region.
	// opacity: The opacity.  1.0 is full opacity.  0.0 will result in no image, as this is full transparency.
	void drawImage(int x, int y, Image image, int srcX, int srcY, double opacity) {
//		ImageLock(image);
//		View v = image.view;
//		if (v !is null) {
//			drawView(x, y, v, srcX, srcY, opacity);
//		}
//		ImageUnlock(image);
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
	void drawImage(int x, int y, Image image, int srcX, int srcY, int srcW, int srcH, double opacity) {
//		ImageLock(image);
//		View v = image.view;
//		if (v !is null) {
//			drawView(x, y, v, srcX, srcY, srcW, srcH, opacity);
//		}
//		ImageUnlock(image);
	}

// Clipping

	// Description: Will push the clip region to a stack preserving its state.
	void clipSave() {
//		Scaffold.clipSave(_viewVars);
	}

	// Description: If possible, will restore the clip state most recently saved via clipSave().
	void clipRestore() {
//		Scaffold.clipRestore(_viewVars);
	}

	// Description: Unions the current clip region with a rectangle region defined by the top-left point: (x,y) and some size.
	// x: The top-left coordinate's x value.
	// y: The top-left coordinate's y value.
	// width: The width of the rectangular region to clip.
	// height: The height of the rectangular region to clip.
	void clipRect(int x, int y, int width, int height) {
//		Scaffold.clipRect(_viewVars, x,y,width,height);
	}

	// Description: Unions the current clip region with the region given.
	// rgn: The region to clip.
	void clipRegion(Region rgn) {
//		Scaffold.clipRegion(_viewVars, rgn);
	}
}
