import djehuty;

import data.list;
import hashes.digest;

import resource.menu;

import graphics.graphics;

import resource.image;
import resource.sound;

import cui.application;
import cui.window;
import cui.label;
import cui.textfield;

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

	ulong fudge;
	ulong freak;
	Queue2!(string) q;
}

import binding.c;

class A {
	this(int foo = 5) {
		_foo = foo;
		printf("class constructor %d\n", foo);
	}

	int foobar() {
		return _foo;
	}
private:
	int _foo;
}


import spec.modulespecification;

import data.queue;

class MyWindow : CuiDialog {
	this() {
		super("hello world", WindowStyle.Fixed, Color.DarkMagenta, WindowPosition.Center, 13, 10);
		visible = true;
//		tmr = new Timer;
//		tmr.interval = 200;
//		push(tmr);
		push(lbl = new CuiLabel(0, 0, 10, "HELLO"));
		lbl.visible = true;
//		tmr.start;

//		tmr = new Timer;
//		tmr.interval = 200;
//		push(tmr);
//		tmr.start;

//		tmr = new Timer;
//		tmr.interval = 200;
//		push(tmr);
//		tmr.start;
	
//		tmr = new Timer;
//		tmr.interval = 200;
//		push(tmr);
//		tmr.start;
		field = new CuiTextField(0,1,10,"HELLO");
		field.visible = true;
		push(field);
	}

	override bool onSignal(Dispatcher dsp, uint signal) {
		static int i = 0;
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
		lbl.text = toStr(i);
		return true;
	}

	override void onKeyDown(Key key) {
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

	Timer tmr;
	CuiLabel lbl;
	CuiTextField field;
}

class MyApp : CuiApplication {
	override void onApplicationStart() {
		push(new MyWindow);
		push(new MyWindow);
		push(new MyWindow);
		push(new MyWindow);
		auto w = new MyWindow();
		push(w);
		w.reorder(WindowOrder.BottomMost);
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
	putln(sort([1,3,-2,5,3,42]));
	putln(sort(foob));
	auto app = new MyApp;
	app.run();
	return 0;
}
