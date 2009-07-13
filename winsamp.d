import core.definitions;
import core.color;
import core.event;

import gui . application;
import gui.window;
import gui.button;
import gui.widget;

import core.graphics;
import core.image;
import core.regex;
import core.string;

import tui.application;
import tui.window;
import tui.textfield;

import networking.irc;

import platform.win.controls.osbutton;

import console.main;

import hashes.md5;

import specs.test;

/*class MyControl : Widget {

	this() {
		super(0,50,100,100);

		img = new Image("tiles.png");
	}

	override void OnDraw(ref Graphics g) {
		g.drawImage(_x,_y,img);
	}

protected:
	Image img;
}*/

/*class MyWindow : Window {
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
		}
			if (signal == Button.Signal.Selected) {

				Tests.testAll();

				Console.putln(Regex.eval(`a#line 43 "foo\bar"`, `#line\s+(0x[0-9a-fA-F_]+|0b[01_]+|0[_0-7]+|(?:[1-9][_0-9]*|0))(?:\s+("[^"]*"))?`));
//				Console.putln(Regex.eval("abcdefeggfoo", `abc(egg|foo)?def(egg|foo)?(egg|foo)?`));
				Console.putln(_1, " ... ", _2, " ... ", _3, " ... ", _4);

				return true;
			}
		return false;
	}

private:

	Button closeButton;
	Button button;
}*/

import tui.textfield;
import core.application;
class MyTApp :TuiApplication {
	static this() { new MyTApp(); }

	override void OnApplicationStart() {
			 tuiwnd = new MyTWindow();
			 push(tuiwnd);
	}

	override void OnApplicationEnd() {
		Console.setColor(fgColor.BrightWhite, bgColor.Black);
		Console.clear();
		Console.putln("Your app has been ended.");
		//Console.putln("Go away");
	}

private:
		MyTWindow tuiwnd;
}

class MyTWindow : TuiWindow {

	this(){
		super();

		push(tuitext = new TuiTextField(0,Console.getHeight(),Console.getWidth(), "boo"));

		tuitext.basecolor = fgColor.White;
		tuitext.forecolor = fgColor.BrightYellow;
		tuitext.backcolor = bgColor.Green;

		string foo = tuitext.text;
		tuitext.text = "hahaha" ~ foo;
	}

	override void OnKeyDown(uint keyCode)
	{
		if(keyCode == KeyEnd)
		{
			//quit
			getApplication.exit(0);
		}
		else if (keyCode == KeyPageUp) {
			// meh
			tuitext.forecolor = fgColor.Red;
		}
		else
		{
			super.OnKeyDown(keyCode);
		}
	}

private:
	TuiTextField tuitext;
}

/*class MyApp : GuiApplication {
	// Start an application instance
	//static this() { new MyApp(); }

	override void OnApplicationStart() {
		wnd = new MyWindow();
		wnd.setVisibility(true);
		push(wnd);
	}

	override void OnApplicationEnd() {
	}

private:
	MyWindow wnd;
}*/
