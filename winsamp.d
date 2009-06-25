import core.definitions;
import core.color;
import core.event;

import gui.application;
import gui.window;
import gui.button;
import gui.oscontrol;
import gui.widget;

import core.graphics;
import core.image;

import tui.core;

import console.main;

import hashes.md5;

class MyControl : Widget {

	this() {
		super(0,50,100,100);

		img = new Image("tiles.png");
	}

	override void OnDraw(ref Graphics g) {
		g.drawImage(_x,_y,img);
	}

protected:
	Image img;
}

class MyWindow : Window {
	this() {
		super("Hello", WindowStyle.Fixed, Color.Red, 100,100,300,300);
	}

	override void OnAdd() {
		push(button = new Button(0,0,100,50,"OK"));
		push(new MyControl());
	}

	override bool OnSignal(Dispatcher source, uint signal) {
		if (source is button) {
			if (signal == Button.Signal.Selected) {
				setText("bugger");
				return true;
			}
		}
		return false;
	}

private:

	Button button;
}

class MyTApp : TuiApplication {
	//static this() { new MyTApp(); }

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
	static this() { new MyApp(); }

	override void OnApplicationStart() {
		wnd = new MyWindow();
		wnd.setVisibility(true);
		push(wnd);
	}

	override void OnApplicationEnd() {
	}

private:
	MyWindow wnd;
}
