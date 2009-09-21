import djehuty;

import gui.application;
import gui.window;
import gui.button;
import gui.widget;

import resource.menu;

import graphics.graphics;

import resource.image;
import resource.sound;

import tui.application;
import tui.window;
import tui.label;
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

import tui.dialog;
import tui.filebox;
import tui.listbox;

class MyTWindow : TuiWindow {

	this() {
		super();
/*
		push(tuitext = new TuiTextField(0,Console.height,Console.width, "boo"));

		tuitext.basecolor = fgColor.White;
		tuitext.forecolor = fgColor.BrightYellow;
		tuitext.backcolor = bgColor.Green;

		string foo = tuitext.text;
		tuitext.text = "hahaha" ~ foo;*/
		push(status = new TuiLabel(0, this.height-1, this.width, " xQ - Quits", fgColor.Black, bgColor.White));

		//push(new TuiOpenDialog(5,5));
		/*push(filebox = new TuiFileBox(5,5,60,20));
		filebox.forecolor = fgColor.Red;
		filebox.backcolor = bgColor.Black;
		filebox.selectedBackcolor = bgColor.Green;
		filebox.selectedForecolor = fgColor.White;*/
		//push(listbox = new TuiListBox(5,5,60,10));

		// add 20 things to the listbox
//		for(int i; i<20; i++) {
	//		listbox.addItem("list item " ~ toStr(i));
		//}


		//push(filebox = new TuiFileBox(5,5,60,20));
		//filebox.forecolor = fgColor.Red;
		//filebox.backcolor = bgColor.Black;
		//filebox.selectedBackcolor = bgColor.Green;
		//filebox.selectedForecolor = fgColor.White;
		push(tuibox = new TuiTextBox(0,0,this.width,this.height-2));
		Menu foo = new Menu("root", [new Menu("&File", [new Menu("&Save"), new Menu("&Open", [new Menu("From File"), new Menu("From URL")]), new Menu(""), new Menu("E&xit")]), new Menu("&Edit", [new Menu("F&oo"), new Menu("F&oo")]), new Menu("&Options")]);

		menu = foo;
		text = "unsaved";
		tuibox.lineNumbers = true;
//		push(new TuiLabel(0, 2, 10, "foobarfoo!"));

	}

	override void onResize() {
		tuibox.resize(this.width, this.height-2);
		status.move(0, this.height-2);
		status.resize(this.width, 1);
		redraw();
	}

	override void onKeyDown(Key key) {
		if (key.code == Key.Q && key.ctrl) {
			// Exit
			application.exit(0);
			return;
		}
		super.onKeyDown(key);
	}

private:
	TuiTextField tuitext;
	TuiTextBox tuibox;
	TuiLabel status;
	TuiFileBox filebox;
	TuiListBox listbox;
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
		Menu foo = new Menu("root", [new Menu("&File", [new Menu("&Save"), new Menu("&Open")]), new Menu("&Edit"), new Menu("&Options")]);
		menu = foo;
		push(new OSButton(0,0,100,50,"yo"));
		push(new MyControl());
	}
}

class MyTApp :TuiApplication {
	//static this() { new MyTApp(); }

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

version(Tango) {
}
else {
	import std.stdio;
}

import math.fixed;
import math.currency;

class MyConsoleApp : Application {
	static this() { new MyConsoleApp(); }

	override void onApplicationStart() {


		real[] bleh = [0,1,1,2,3,4,56];
		short[][] GOOOD = [[128,2,4],[2,4,1],[3,4,5,7]];

		struct asdfasdf {
			ulong dd;
			ulong dd2;
			ulong dd3;
			ulong dd4;
			ulong dd5;
			string toString() {
				return "ADSFS";
			}
		}
		asdfasdf aaaa;
		String asdf = new String("sfadf");
		real asd;
		Object meh = new Object();

		foo(asdf, GOOOD, 2,aaaa, 3,4, meh, 3, "dave"d);

	/*	Regex r = new Regex("((ab)*)*c");
		String work = r.eval("ababababab");
		if (work) {
			Console.putln(work);
		}*/
		List!(int) lst = new List!(int);
		lst.add(2);
		lst.add(1);
		lst.add(3);
		lst.add(4);
		lst.apply((int a){ return a*a; });

		filter( (int a){ return a > 2; } , range(1,11) );

		Console.putln(lst);

		Console.putln("asdf", aaaa, GOOOD, 2, 5, 2, 6, 6);
		foov(foobar);

		String str = new String("dave wilkinson");
		string fff = str[0..4];
		String ffff = str.subString(5);
		Console.putln(fff);
		Console.putln(ffff);

		Date date = new Date();
		Console.putln(date);

		Date testDate = new Date(Month.August, 20, 1987);
		Time testTime = new Time(14, 45, 35);

		Console.putln(Locale.formatDate(testDate));
		Console.putln(Locale.formatTime(testTime));
		Console.putln(Locale.formatNumber(1123431241324));
		Console.putln(Locale.formatCurrency(1123431241324));
		Locale.id = LocaleId.French_FR;
		Console.putln(Locale.formatDate(testDate));
		Console.putln(Locale.formatTime(testTime));
		Console.putln(Locale.formatNumber(1123431241324));
		Console.putln(Locale.formatCurrency(1123431241324));

		real f = -3.4123999999;
		Console.putln(ftoa(f));
		//printf("%f\n", f);
		//writefln(f);
		Fixed f1 = new Fixed(132, 2);
		Fixed f2 = new Fixed(121, 1);
		f1 -= f2;

		Console.putln(f1);
		
		f1 = new Fixed(1456, 3);
		f2 = new Fixed(327, 1);
		f1 *= f2;

		Console.putln(f1);
		
		f1 = new Fixed(11, 1);
		f2 = new Fixed(112, 2);
		f1 /= f2;
		
		Console.putln(f1);
		
		Currency c1 = new Currency(11, 1);
		Currency c2 = new Currency(112, 2);
		c1 /= c2;
		
		Console.putln(c1);
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
