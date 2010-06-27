import djehuty;

import data.list;
import hashes.digest;

import resource.menu;

import graphics.graphics;

import resource.image;
import resource.sound;

import cui.application;
import cui.tabbox;
import cui.window;
import cui.label;
import cui.textfield;
import cui.textbox;

import synch.timer;
import synch.thread;
import synch.atomic;

import networking.irc;

import io.console;

import hashes.md5;

import spec.test;

import parsing.options;

import io.file;

import math.vector;

import core.date;

import core.application;

import cui.dialog;

import math.fixed;
import math.currency;
import math.common;
import math.integer;
import parsing.d.parser;

import networking.ftp;

import spec.specification;

import data.queue2;

class MyConsoleApp : Application {

	ulong fudge;
	ulong freak;
	Queue2!(string) q;

	void foo(bool bar) {
		Atomic.increment(fudge);
		while(fudge < 9) {
		}
		q.add("foobara");
		q.add("foobarb");
		q.remove();
		q.add("foobarc");
		q.add("foobard");
		q.remove();
		Atomic.increment(freak);
	}
}

import binding.c;

class A {
	int _foo;
	this(int foo = 5) {
		_foo = foo;
		printf("class constructor %d\n", foo);
	}

	int foobar() {
		return _foo;
	}
}


import spec.modulespecification;

import data.queue;

class MyWindow : CuiDialog {
	Timer tmr;
	CuiLabel lbl;
	CuiTextField field;
	CuiTextBox box;
	CuiTabBox tabbox;

	this() {
		static int i = 0;
		Color toPick;
		switch(i%5) {
			case 0:
				toPick = Color.DarkMagenta;
				break;
			case 1:
				toPick = Color.DarkGreen;
				break;
			case 2:
				toPick = Color.DarkBlue;
				break;
			case 3:
				toPick = Color.Black;
				break;
			case 4:
				toPick = Color.DarkRed;
			default:
				break;
		}
		i++;
		super("untitled", WindowStyle.Fixed, toPick, WindowPosition.Center, 30, 15);
		visible = true;

	/*	tabbox = new CuiTabBox(0,0,this.clientWidth(),this.clientHeight());
		tabbox.add("foo");
		tabbox.add("bar");
		tabbox.visible = true;

		box = new CuiTextBox(0,0,tabbox.clientWidth(), tabbox.clientHeight());
		box.lineNumbers = true;
		box.visible = true;
		box.backcolor = toPick;
		box.backcolorNum = toPick;

	*/

//		tabbox.push(box);

	//	push(tabbox);

		lbl = new CuiLabel(0, 0, 10, "Hello", Color.Red, Color.Black);
		lbl.visible = true;
		push(lbl);
		
		field = new CuiTextField(0, 1, 10, "Hello");
		field.visible = true;
		push(field);
	}

	override void onResize() {
//		box.reposition(0,0,this.clientWidth,this.clientHeight);
		//tabbox.reposition(0, 0, this.clientWidth, this.clientHeight);
		//box.reposition(0, 0, tabbox.clientWidth(), tabbox.clientHeight());
	}

	override bool onSignal(Dispatcher dsp, uint signal) {
		/*static int i = 0;
		i++;
		int a = i % 5;
		switch(a) {
			case 0:
				lbl.forecolor = Color.Red;
				break;
			case 1:
				lbl.forecolor = Color.Yellow;
				break;
			case 2:
				lbl.forecolor = Color.Green;
				break;
			case 3:
				lbl.forecolor = Color.Magenta;
				break;
			case 4:
			default:
				lbl.forecolor = Color.Blue;
				break;
		}
		lbl.text = toStr(i);*/
		return true;
	}

	override void onKeyDown(Key key) {
		redraw();
		if (key.ctrl && key.code == Key.Q) {
			Djehuty.app.exit(0);
		}
		else if (key.alt && key.code == Key.Tab) {
			Djehuty.app.exit(0);
		}
		else {
			super.onKeyDown(key);
		}
	}
}

class MyApp : CuiApplication {
	override void onApplicationStart() {
		push(new MyWindow);
		push(new MyWindow);
		push(new MyWindow);
		auto w = new MyWindow();
		push(w);
		w.reorder(WindowOrder.BottomMost);
		w.text = "bottommost";
		w = new MyWindow();
		push(w);
		w.text = "topmost";
		w.reorder(WindowOrder.TopMost);
	}
}

void foo(bool stop) {
	Console.putln("hello");
	Console.putln("what is up?");
}

import math.random;
static const int REPEATS = 10000;
int main(string[] args) {
	Console.putln("he\u0364llo \u258c");
	Console.putln("he\u0364llo \u258c");
	Console.putln("he\u0364llo \u258c");
	Console.putln("he\u0364llo \u258c");
	List!(int) foob = new List!(int)([1,3,-2,5,3,42]);
	int[] foo = [1,3,-2,5,3,42];
	foo ~= [3,4];
	foo ~= 5;
	foo = foo ~ [-1,-3] ~ [100] ~ [652, 23, 552,9];
	putln(foo.sort);
	putln(sort([1,3,-2,5,3,42]));
	putln(sort(foob));

	auto app = new MyApp;

//	putln(Console.width, "x", Console.height);
	app.run();

/*	bool i = false;
	Console.putln(i);

	Atomic.compareExchange(i, cast(typeof(i))false, cast(typeof(i))true);
	Console.putln(i);*/

	return 0;
}
