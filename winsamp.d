import djehuty;

import gui.application;
import gui.window;
import gui.button;
import gui.widget;
import gui.listbox;

import hashes.digest;

import resource.menu;

import graphics.graphics;

import resource.image;
import resource.sound;

import tui.application;
import tui.window;
import tui.label;
import tui.textfield;
import tui.tabbox;
import tui.container;

import synch.timer;
import synch.thread;

import networking.irc;

import io.console;

import hashes.md5;

import specs.test;

import parsing.options;

import io.file;

import utils.linkedlist;
import utils.heap;
import utils.fibonacci;

import math.vector;

import core.date;

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

		tabbox = new TuiTabBox(0,0,this.width, this.height-1);

		push(tabbox);

		TuiContainer blah = new TuiContainer(0,0,0,0);
		blah.text = "Poop";
		blah.push(tuibox = new TuiTextBox(0,0,this.width,this.height-2));
		TuiContainer bloh = new TuiContainer(0,0,0,0);
		bloh.text = "Pee";

		TuiTextBox tuibox2 = new TuiTextBox(0,0,this.width,this.height-2);
		tuibox2.lineNumbers = true;
		bloh.push(tuibox2);

		tabbox.add(bloh);
		tabbox.add(blah);

		Menu foo = new Menu("root", [new Menu("&File", [new Menu("&Save"), new Menu("&Open", [new Menu("From File"), new Menu("From URL"), new Menu(""), new Menu("Hey")]), new Menu(""), new Menu("E&xit")]), new Menu("&Edit", [new Menu("F&oo"), new Menu("F&oo")]), new Menu("&Options")]);

		menu = foo;
		text = "unsaved";
//		tuibox.lineNumbers = true;

		push(new TuiLabel(1,1,15, "Hello.World.!!!"));
		push(new TuiLabel(3,2,15, "Hello.World.!!!"));
		push(new TuiLabel(2,3,15, "Hello.World.!!!"));

		//push(new TuiTextBox(0,0,this.width, this.height-2));
	}

	override void onMenu(Menu mnu) {
		if (mnu.displayText == "Exit") {
			application.exit(0);
		}
	}

	override void onResize() {
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
	TuiTabBox tabbox;
}

class MyControl : Widget {
	this() {
		tmr = new Timer(50);
		push(tmr);
		super(200,200,100,100);
	}

	override void onAdd() {
		imgPNG = new Image("tests/test.png");
		//imgJPEG = new Image("tests/tiles.png"); // jpeg written as png
		//imgJPEG = new Image("tests/Dog_bounces_trampoline.gif");
		imgJPEG = new Image("tests/Pillow_pins_kitten.gif");

		//snd = new Sound("tests/begin.mp2");
		//snd = new Sound("tests/01 Block Shaped Heart.mp3");
//		snd = new Sound("tests/sine_440.wav");
		//snd = new Sound("tests/sine_220.wav");
	}

	override void onDraw(ref Graphics g) {
		g.drawImage(this.left,this.top,imgPNG);
		g.drawImage(this.left,0,imgJPEG);

		Brush foo = new Brush(Color.fromRGBA(1.0,0,0,0.5));
		g.brush = foo;
		Pen foo2 = new Pen(Color.fromRGBA(0.5,0,0,0.5));
		g.pen = foo2;
		g.brush = new Brush(Color.fromRGBA(0.5,0.5,0.5,0.5));
		g.fillRect(86, 86, 140, 140);
		g.brush = Brush.White;
		g.drawRect(80, 80, 140, 140);
		g.antialias = true;
		g.brush = new Brush(Color.fromRGBA(0.7,0.7,0.7,1.0));
		//g.drawOval(100, 100, 100, 100);
		g.drawPie(100,100,100,100, (215+260)%360, 360-260);
		g.brush = Brush.Blue;
		g.drawPie(100,100,100,100, 215, 260);
		g.antialias = false;

		Brush b = new Brush(imgJPEG.view);
		g.brush = b;

		g.drawRect(30,30,30,30);
		g.drawRect(60,60,30,30);
		g.drawRect(90,90,30,30);

		Pen p = new Pen(b, 10.0);
		//p = new Pen(Color.fromRGBA(0,0,0x80,0x80), 10.0);
		g.pen = p;
		g.antialias = true;
		g.strokeOval(120,120,100,100);
		g.antialias = false;
//*/


		g.pen = new Pen(Color.fromRGBA(0.0, 0.0, 1.0, 0.5), 1.0);

		size_t o;
		foreach(size_t i, freq; foobar) {
			if (i % 8) {
				int bar_height = cast(int)(12000 * freq);
				//Console.putln(freq, " :: ", bar_height);
	//			double curHue;
		//		curHue = cast(double)i / cast(double)foobar.length;
			//	g.pen = new Pen(Color.fromHSLA(curHue,1.0,0.3,0.75),1.0);
				g.drawLine(o, 256-bar_height, o, 256);
				o++;
			}
		}

		b = new Brush(new Gradient(20,0,50, angle, 0.0, Color.Red, 0.5, Color.Green, 1.0, Color.Blue));
		g.brush = b;
		g.drawRect(20,0,100,300);
	}

	override bool onSignal(Dispatcher dsp, uint signal) {
		foobar = snd.spectrum();
		(cast(Window)responder).redraw();
		angle += 0.1;
		imgJPEG.next;
		return true;
	}

	override bool onPrimaryMouseDown(ref Mouse mp) {
		/*
		cdouble[16] test;
		for (size_t i = 0; i < 16; i++) {
			test[i] = i + 0.0i;
			Console.putln(test[i]);
		}
  		Console.putln("-=-=-=-");
  		cdouble[] ret = test.FFT();
  		Console.putln("-=-=-=-");
		for (size_t i = 0; i < 8; i++) {
			Console.putln(ret[i]);
		}*/
		//snd = new Sound("tests/fazed.dreamer.mp3");
		snd = new Sound("tests/sine_440.wav");
		snd.play();
		tmr.start();
		return false;
	}
	double angle = 0.0;
	Timer tmr;
	double[] foobar;
	Image imgPNG;
	Image imgJPEG;

	Sound snd;
}

class MyWindow : Window {
	this() {
		super("hey",WindowStyle.Fixed,Color.Red,0,0,600,380);
	}

	override void onAdd() {
		Menu foo = new Menu("root", [new Menu("&File", [new Menu("&Save"), new Menu("&Open")]), new Menu("&Edit"), new Menu("&Options")]);
		menu = foo;
		push(new Button(0,0,100,50,"yo"));
		ListBox lb;
		//push(lb = new ListBox(0,0,100,100));
		//lb.add("Hello");
		//lb.add("Goodbye");
		push(new MyControl());

		cdouble aah = 1.0 + 0.0i;
		double ah = cast(double)aah;
		//Console.putln(ah);
	}
}

class MyTApp :TuiApplication {
//	static this() { new MyTApp(); }

	override void onApplicationStart() {
		tuiwnd = new MyTWindow();
		push(tuiwnd);

		//snd = new Sound("tests/begin.mp2");
		//snd.play();

		//tuiwnd.tuibox.refresh();
	}

	override void onApplicationEnd() {
		Console.setColor(fgColor.BrightWhite, bgColor.Black);
//		Console.clear();
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
//	import std.stdio;
}

import math.fixed;
import math.currency;
import math.integer;
import parsing.d.parser;

import networking.ftp;

class MyConsoleApp : Application {
	static this() { new MyConsoleApp(); }
	override void onApplicationStart() {

		DParser parser = new DParser(File.open("tests/test.d"));
		auto ast = parser.parse();
		Console.putln();
		Console.putln(ast);
		Thread t = Thread.getCurrent();

		tmr = new Timer(250);
		push(tmr);
		tmr.start();
		for(;;){}
	}

	override bool onSignal(Dispatcher dsp, uint signal) {
		Console.putln("fire");
		return true;
	}

	void foobbb(...) {
		Variadic vars = new Variadic(_arguments, _argptr);
		foreach(arg; vars) {
			Console.putln(arg);
		}
	}

protected:
	List!(string) list;
	Timer tmr;
}

class MyApp : GuiApplication {
	// Start an application instance
	//static this() { new MyApp(); }

	override void onApplicationStart() {
	}

	/*	override bool onSignal(Dispatcher dsp, uint signal) {
		if (dsp is ftp) {
		switch(signal) {
		case FtpClient.Signal.Authenticated:
		Console.putln("Authenticated");
		ftp.switch_to_passive();
		break;
		case FtpClient.Signal.PassiveMode:
		ftp.send_Command("TYPE A");
	//	ftp.list_files();
	break;
	case FtpClient.Signal.OK:
	ftp.send_Command("CWD /home/bkuhlman/public_html/files");

	break;
	case FtpClient.Signal.LoginIncorrect:
	//exit incorrect login
	//		ftp.close();
	break;
	case FtpClient.Signal.CurDirSuc:
	//ftp.send_Command("STOR Project_3.doc");
	ftp.send_Command("RETR life.c");
	break;
	default:
	// Dunno
	break;
	}
	}
	return true;
	}*/

	private:
	FtpClient ftp;
}

