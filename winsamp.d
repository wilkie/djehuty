import core.definitions;
import core.color;
import core.event;

import gui.core;
import gui.button;
import gui.oscontrol;

import tui.core;

import console.main;

import hashes.md5;

class MyWindow : Window {
	this() {
		super("Hello", WindowStyle.Fixed, Color.Red, 100,100,300,300);
	}

	override void OnAdd() {
	}

	override bool OnSignal(Dispatcher source, uint signal) {
		if (source is button) {
			if (signal == Button.Signal.Selected) {
				setText(HashMD5("Button Pressed").toString());
				return true;
			}
		}
		return false;
	}

private:

	Button button;
}

class MyTApp : TuiApplication {
	static this() { new MyTApp(); }

	override void OnApplicationStart() {
		push(new TuiWindow());
	}

	override void OnApplicationEnd() {
		Console.clear();
		Console.putln("Your app has been ended.");
		Console.putln("Go away");
	}
}

class MyApp : GuiApplication {
	// Start an application instance
	//static this() { new MyApp(); }

	override void OnApplicationStart() {
		wnd = new MyWindow();
		wnd.setVisibility(true);
	}

	override void OnApplicationEnd() {
	}

private:
	MyWindow wnd;
}
