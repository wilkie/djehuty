import core.definitions;
import core.color;
import core.event;

import gui.application;
import gui.window;
import gui.button;
import gui.widget;

import core.graphics;
import core.image;

import tui.application;
import tui.window;

import networking.irc;

import platform.win.controls.osbutton;

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

		irc = new IRC.Client();
	}

	IRC.Client irc;

	override void OnAdd() {
		push(button = new Button(0,0,100,50,"OK"));
		push(new MyControl());
		push(closeButton = new OSButton(100,0,100,50,"Close"));
		push(button = new Button(50,25,100,50,"OK"));
	}

	override bool OnSignal(Dispatcher source, uint signal) {
		if (source is closeButton) {
			if (signal == Button.Signal.Selected) {
				remove();
				return true;
			}
		}
		else if (source is button) {
			if (signal == Button.Signal.Selected) {
				setText("oh bugger");
				/*irc.connect("irc.freenode.net");
				irc.authenticate("djehuty", "Djehuty");
				irc.join("#d.djehuty");*/

				return true;
			}
		}
		return false;
	}

private:

	Button closeButton;
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
