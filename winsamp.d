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

	override void onApplicationStart() {
		Timer tmr = new Timer;
		tmr.interval = 500;
		push(tmr);
		tmr.start;
		for(;;){}
	}

	override bool onSignal(Dispatcher dsp, uint signal) {
		Console.putln("fire");
		return true;
	}

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
		push (new CuiLabel(2,3, 10, "hello"));
	}

	override void onKeyDown(Key key) {
		if (key.ctrl && key.code == Key.Q) {
			Djehuty.app.exit(0);
		}
	}
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

int main(string[] args) {
	auto app = new MyConsoleApp;
	app.run();
	return 0;
}
