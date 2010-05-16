import djehuty;

import data.list;
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

import cui.application;
import cui.window;
import cui.label;
import cui.textfield;
import cui.tabbox;
import cui.container;

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

import cui.textfield;
import core.application;

import cui.textbox;
import cui.codebox;

import cui.dialog;
import cui.filebox;
import cui.listbox;

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

class MyWindow : CuiWindow {
	this() {
		push (label = new CuiLabel(2,3, 10, "hello"));
		tmr = new Timer;
		tmr.interval = 10000;
		push(tmr);
		tmr.start;
	}

	override bool onSignal(Dispatcher dsp, uint signal) {
		if (dsp !is tmr) {
			return false;
		}

		static int i = 0;
		i++;
		if (signal == 1) {
			label.text = "fuck!" ~ toStr(i);
		}
		if (label.text.length > 4) {
		redraw();
			return true;
		}
		label.text = toStr(i);
		redraw();
		return true;
	}

	override void onKeyDown(Key key) {
		if (key.ctrl && key.code == Key.Q) {
			Djehuty.app.exit(0);
		}

		tmr.stop();
		tmr.start();
	}

	Timer tmr;
	CuiLabel label;
}

class MyApp : CuiApplication {
	override void onApplicationStart() {
		push(new MyWindow);
	}
}

void foo(bool stop) {
	Console.putln("hello");
	Console.putln("what is up?");
}

import math.random;
static const int REPEATS = 10000;
int main(string[] args) {
	auto r = new Random();
	List!(char) lst = new List!(char)(['a', 'e', 'i', 'o', 'u']);
	char v;
	for (uint i = 0; i < REPEATS; i++) {
		Console.putln("um");
		v = r.choose(lst);
		Console.putln("chosen: ", v);
		Console.putln(member(v, lst) is null);
	}

	//auto app = new MyApp;
	//app.run();
	return 0;
}
