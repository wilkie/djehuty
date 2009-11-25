/*
 * window.d
 *
 * This module implements the platform specifics for the Window class.
 *
 * Author: Dave Wilkinson
 * Originated: July 25th, 2009
 *
 */

module platform.vars.window;

import X = binding.x.Xlib;

struct WindowPlatformVars {
	// required parameters:

	bool _hasGL;		// is a GLWindow
	bool _hasView;		// is a Window

	// -----

	X.Window window;
	X.Window wm_parent;
	int wm_x;
	int wm_y;

	//GLXContext ctx;

	//to handle sync issues
	bool destroy_called = false;		//true, when window is to be destroyed
}
