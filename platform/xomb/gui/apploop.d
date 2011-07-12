/*
 * apploop.d
 *
 * This is the Gui Application entry point for Linux.
 *
 * Author: Dave Wilkinson
 * Originated: July 25th, 2009
 *
 */

module gui.apploop;

class GuiApplicationController {
private:

	void mainloop() {
	}

public:
	// The initial entry for the gui application
	this() {
	}

	void start() {
		mainloop();
	}

	void end(uint code) {
	}
}
