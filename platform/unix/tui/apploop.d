/*
 * apploop.d
 *
 * This is the Gui Application entry point for Linux.
 *
 * Author: Dave Wilkinson
 * Originated: July 25th, 2009
 *
 */

module tui.apploop;

import scaffold.console;

import tui.application;
import tui.window;

import core.main;
import core.definitions;

class TuiApplicationController {

	// The initial entry for a tui application
	this() {
	}

	void start() {
		consoleLoop();
	}

	void end(uint code) {
	}

private:
	void consoleLoop()
	{
		for (;;)
		{
			//become IO bound

			ulong ky; uint tky;
			ky = consoleGetKey();
			TuiApplication app = cast(TuiApplication)Djehuty.app;
			TuiWindow window = app.window;
			tky = consoleTranslateKey(ky);

			if (ky < 0xfffffff) {
				Key key;
				key.code = tky;
				window.onKeyDown(key);

				if (tky != KeyBackspace && tky != KeyArrowLeft && tky != KeyArrowRight
						&& tky != KeyArrowUp && tky != KeyArrowDown)
				{
					window.onKeyChar(cast(uint)ky);
				}
			}

			/* if (m_exit)
			   {
			   fireEvent(EventUninitState, 0);
			   break;
			   } */
		}
	}
}
