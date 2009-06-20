import core.definitions;
import core.color;

import gui.core;

class MyApp : GuiApplication {
	// Start an application instance
	static this() { new MyApp(); }
	
	override void OnApplicationStart() {
		Window wnd = new Window("Hello", WindowStyle.Fixed, Color.Red, 100,100,300,300);
		wnd.setVisibility(true);

		push(wnd);
	}

	override void OnApplicationEnd() {
	}
}