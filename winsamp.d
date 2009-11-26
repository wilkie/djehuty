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
import tui.tabbox;
import tui.container;

import networking.irc;

import io.console;

import hashes.md5;

import specs.test;

import gui.osbutton;

import parsing.options;

import io.file;

import utils.heap;
import utils.fibonacci;

class MyOptions : OptionParser {

	mixin Options!(
		"option", "will perform this option",
		string, "gives the number of runs",
		char, "gives the op to do",

		"x", "foo",
		int, "yeah",

		"y", "asdf",

		"-file, f", "The file to use",
		string, "The filename",

		"-help", "view help"
	);

	void onOption(string str, char foo) {
		Console.putln("option flag ", str, foo);
	}

	void onX(int foo) {
		Console.putln("x flag ", foo);
	}

	void onY() {
		Console.putln("y flag");
	}

	void onFile(string filename) {
		Console.putln("file flag ", filename);
	}

	void onHelp() {
		showUsage();
		Djehuty.end(0);
	}

}

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
		//push(status = new TuiLabel(0, this.height-1, this.width, " xQ - Quits", fgColor.Black, bgColor.White));

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

		push(tabbox = new TuiTabBox(0,0,this.width, this.height-1));
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

		

//		push(new TuiCodeBox(0,0,this.width, this.height-1));

		//push(filebox = new TuiFileBox(5,5,60,20));
		//filebox.forecolor = fgColor.Red;
		//filebox.backcolor = bgColor.Black;
		//filebox.selectedBackcolor = bgColor.Green;
		//filebox.selectedForecolor = fgColor.White;
		//push(tuibox = new TuiTextBox(0,0,this.width,this.height-2));
	
		Menu foo = new Menu("root", [new Menu("&File", [new Menu("&Save"), new Menu("&Open", [new Menu("From File"), new Menu("From URL")]), new Menu(""), new Menu("E&xit")]), new Menu("&Edit", [new Menu("F&oo"), new Menu("F&oo")]), new Menu("&Options")]);


		menu = foo;
		text = "unsaved";
		tuibox.lineNumbers = true;
//		push(new TuiLabel(0, 2, 10, "foobarfoo!"));
	}

	override void onMenu(Menu mnu) {
		if (mnu.displayText == "Exit") {
			application.exit(0);
		}
	}

	override void onResize() {
	/*	if (tuibox !is null) {
			tuibox.resize(this.width, this.height-2);
		}
		if (status !is null) {
			status.move(0, this.height-2);
			status.resize(this.width, 1);
		}

		redraw();*/
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

		tuiwnd.tuibox.refresh();
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
import math.integer;

class MyConsoleApp : Application {
	static this() { new MyConsoleApp(); }
	override void onApplicationStart() {

/*		list = new List!(String);

		list.addItem(new String("blah"));
		list.addItem(new String("bloo"));

		int index = list.indexOf(new String("blod"));

		Console.putln(index);
*/
		new MyOptions();
		Console.putln("foobar");

/*		String exp = new String(`a*(abc)*a(bc)*b`);
		String find = new String("aaaaabcab");
		Regex regex = new Regex(exp);
		String work = regex.eval(find);

		if (work !is null) {
			Console.putln("DFA: ", work);
		}
		else {
			Console.putln("DFA: {null}");
		}

		work = Regex.eval(find, exp);

		if (work !is null) {
			Console.putln("BT:  ", work);
		}
		else {
			Console.putln("BT:  {null}");
		}

		List!(int) foo = new List!(int);
		foo.add(0);
		foo.add(1);
		foo.add(3);
		foo.addAt(2,2);
		foo.addAt(-1,0);
		foo.addAt(4,9);
		foreach(item; foo) {
			Console.putln(item);
		}*/

	//	File foo = new File("temp.txt"); //File.create("temp.txt");
	//	foo.write("foo bar"c);
	//	foo.close();

	//	foo = File.open("temp.txt");
	//	ubyte f;
	//	foo.read(f);
	//	char d = cast(char)f;
	//	Console.putln(d);

//		auto queue = new PriorityQueue!(int, MaxHeap);

//		queue.add(10);
//		queue.add(4);
//		queue.add(15);


//		Console.putln(queue.remove);
//		Console.putln(queue.remove);
//:q			Console.putln(queue.remove);
/*
		auto fibheap = new FibonacciHeap!(int, MaxHeap);
		fibheap.add(10);
		fibheap.add(4);
		fibheap.add(15);

		Console.putln(fibheap.remove());
		Console.putln(fibheap.remove());
		Console.putln(fibheap.remove());

		auto queue = new FibonacciHeap!(int, MinHeap);
		int min;
		int val;

		Random r = new Random();
		val = cast(int)r.next();
//		queue.add(val);
		min = val;

		for(int i; i < 2; i++) {
			val = cast(int)r.next();
//			queue.add(val);
			if (val < min) {
				min = val;
			}
		}

		queue.add(1);
		queue.add(3);
		queue.add(2);
//		queue.add(3);
		int foo;
		int last = queue.peek();

		while (!queue.empty()) {
			foo = queue.remove();
			Console.putln(foo);
			last = foo;
		}
*/

		File unfinished = File.open("binding/win32/winbaseold.d");
		File finished = File.create("binding/win32/winbasenew.d");

		bool inUnicodeBlock = false;
		bool inStruct = false;
		String structStr;
		char[] structName;
		uint leftsFound;
		bool firstFound = false;
		uint lineNumber = 0;
		foreach(String line; unfinished) {
			lineNumber++;

			// handle typedef struct
			if (line.length > 13 && line[0..14] == "typedef struct" && line.find(";") == -1) {
				Console.putln("struct:", lineNumber);
				inStruct = true;
				int bracketPos = line.find("{");
				if (bracketPos == -1) {
					leftsFound = 0;
					firstFound = false;
					line = new String("");
					structStr = new String("");
				}
				else {
					leftsFound = 1;
					firstFound = true;
					line = line.subString(bracketPos+1);
					structStr = new String("{");
				}
			}

			if (inStruct) {
				// find content of struct
				foreach(int i, c; line) {
					if (c == '{') {
						if (!firstFound) {
							firstFound = true;
							structStr = new String("{");
							line = line.subString(i+1);
						}
						leftsFound++;
					}
					else if (c == '}') {
						leftsFound--;
						if (leftsFound == 0) {
							structStr.append(line.subString(0, i+1));
							structStr.append("\n\n");
							line = line.subString(i+1);
							break;
						}
					}
				}

				if (leftsFound == 0 && firstFound) {
					// parse typedef foo
					line = line.trim;

					if (line.length > 0 && line[line.length-1] == ';') {
						inStruct = false;
					}

					int pos = 0;

					String structName;
					Console.putln("done:", lineNumber,":", line );
					while(pos < line.length) {
						Console.putln("-->", line, "<--");
						int newpos = line.find(",", pos);
						Console.putln("inner");

						if (newpos == -1) {
							newpos = line.length;
						}

						String section = line.subString(pos, newpos-pos);
						section = section.trim;

						if (section.length > 0 && section[section.length-1] == ';') {
							section = section.subString(0, section.length-1);
						}

						if (structName is null && section[0] != '*') {
							structName = section;
						}
						else {
							if (section[0] == '*') {
								structStr.append("typedef ");
								structStr.append(structName);
								structStr.append("* ");
								structStr.append(section[1..section.length]);
								structStr.append(";\n");
							}
							else {
								structStr.append("typedef ");
								structStr.append(structName);
								structStr.append(" ");
								structStr.append(section);
								structStr.append(";\n");
							}
						}

						Console.putln(section);

						pos = newpos+1;
					}

					finished.write("struct "c);
					finished.write(structName.toUtf8);
					finished.write(" "c);
					finished.write(structStr.toUtf8);
					Console.putln("done!");
				}
				else {
					structStr.append(line);
					structStr.append("\n");
				}
			}
			else {
				// handle #defines
				if (line.length > 7 && line[0..8] == "#define ") {
					bool spaceFound = false;
					foreach(int i, c; line[8..line.length]) {
						if (c == ' ' || c == '\t') {
							spaceFound = true;
						}
						else if (spaceFound) {
							int commentPos = line.find("//");
							if (commentPos != -1) {
								line = new String("const auto ") ~ line[8..i+8] ~ " = " ~ line[i+8..commentPos] ~ "; " ~ line[commentPos..line.length];
							}
							else {
								line = new String("const auto ") ~ line[8..i+8] ~ " = " ~ line[i+8..line.length] ~ ";";
							}
							break;
						}
					}
				}

				// handle version blocks
				if (line == "#ifdef UNICODE" || line == "#ifdef (UNICODE)" || line == "#ifdef(UNICODE)") {
					inUnicodeBlock = true;
					line = new String("\nversion(UNICODE) {");
				}
				else if (line.length > 5 && line[0..6] == "#endif" && inUnicodeBlock) {
					line = new String("}");
					inUnicodeBlock = false;
				}
				else if (line == "#else" && inUnicodeBlock) {
					line = new String("}\nelse {");
				}
				else if (inUnicodeBlock) {
					// could be formatted to a 'const auto ITEM = ITEMB;'
					if (line.length > 10 && line[0..10] == "const auto") {
						line = line.subString(10);
						int equalPos = line.find("=");
						if (equalPos != -1) {
							String item = line.subString(0, equalPos);
							String itemB = line.subString(equalPos+1);
							item = item.trim;
							itemB = itemB.trim;
							if (itemB[itemB.length-1] == ';') {
								itemB = itemB.subString(0, itemB.length-1);
							}
							line = new String("alias ") ~ itemB ~ " " ~ item ~ ";";
						}
					}
					line = new String("\t") ~ line;
				}

				if (line != "WINUSERAPI" && line != "WINAPI" && line != "WINBASEAPI") {
					finished.write(line.toUtf8);
					finished.write("\n"c);
				}
			}
		}
	}

protected:
	List!(String) list;
}

class MyApp : GuiApplication {
	// Start an application instance
	static this() { new MyApp(); }

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
