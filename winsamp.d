import core.definitions;
import core.color;
import core.event;

import gui.application;
import gui.window;
import gui.button;
import gui.widget;

import graphics.graphics;

import core.regex;
import core.string;

import resource.image;
import resource.sound;

import tui.application;
import tui.window;
import tui.textfield;

import networking.irc;

import io.console;

import hashes.md5;

import specs.test;

import gui.osbutton;

/*class MyControl : Widget {

	this() {
		super(0,50,100,100);

		img = new Image("tiles.png");
	}

	override void onDraw(ref Graphics g) {
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

	override void onAdd() {
		push(button = new Button(0,0,100,50,"OK"));
		push(new MyControl());
		push(closeButton = new OSButton(100,0,100,50,"Close"));
		push(button = new Button(50,25,100,50,"OK"));
	}

	override bool onSignal(Dispatcher source, uint signal) {
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

import tui.textbox;
import tui.codebox;

class MyTApp :TuiApplication {
	static this() { new MyTApp(); }

	override void onApplicationStart() {
		tuiwnd = new MyTWindow();
		push(tuiwnd);

		//snd = new Sound("tests/begin.mp2");
		//snd.play();
	}

	override void onApplicationEnd() {
		Console.setColor(fgColor.BrightWhite, bgColor.Black);
		Console.clear();
		Console.putln("Your app has been ended.");
		//Console.putln("Go away");
	}

private:
	MyTWindow tuiwnd;

	Sound snd;
}

class MyTWindow : TuiWindow {

	this() {
		super();

/*		push(tuitext = new TuiTextField(0,Console.height,Console.width, "boo"));

		tuitext.basecolor = fgColor.White;
		tuitext.forecolor = fgColor.BrightYellow;
		tuitext.backcolor = bgColor.Green;

		string foo = tuitext.text;
		tuitext.text = "hahaha" ~ foo;*/
		push(tuibox = new TuiCodeBox(0,0,this.width,this.height));
	}

private:
	TuiTextField tuitext;
	TuiTextBox tuibox;
}

class MyControl : Widget {
	this() {
		super(200,200,100,100);
	}

	override void onAdd() {
		imgPNG = new Image("tests/test.png");
		imgJPEG = new Image("tests/tiles.png"); // jpeg written as png

		//snd = new Sound("tests/begin.mp2");
		//snd = new Sound("tests/01 Block Shaped Heart.mp3");
		snd = new Sound("tests/fazed.dreamer.mp3");
	}

	override void onDraw(ref Graphics g) {
		g.drawImage(this.left,this.top,imgPNG);
		g.drawImage(this.left,this.top,imgJPEG);
	}

	override bool onPrimaryMouseDown(ref Mouse mp) {
		snd.play();
		return false;
	}

	Image imgPNG;
	Image imgJPEG;

	Sound snd;
}

class MyWindow : Window {
	this() {
		super("hey",WindowStyle.Fixed,Color.Red,0,0,300,300);
	}

	override void onAdd() {
		push(new OSButton(0,0,100,50,"yo"));
		push(new MyControl());
	}
}

class MyApp : GuiApplication {
	// Start an application instance
	//static this() { new MyApp(); }

	override void onApplicationStart() {
		wnd = new MyWindow();
		wnd.visible = true;

		push(wnd);
	}

	override void onApplicationEnd() {
	}

private:
	MyWindow wnd;
}
