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
	static this() { new MyConsoleApp(); }

	override void onApplicationStart() {
		Console.putln(sin(0));
		Console.putln(cos(3.1415296));
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
int main(string[] args) {
	string foobar = "abc";
	foobar ~= 'd';
	Console.putln(3);
	int[] foo;
	foo ~= 3;
	Console.putln(foo);
	int[] foo2 = null;
	foo2 ~= [2,4];
	Console.putln(foo2);
	Console.putln(foo2.length);
	synchronized {
	}


	Console.putln("lists test\n");
	int[3] arr = 1;
	Queue!(int) list = new Queue!(int)();

	list.add(arr);

	Console.putln(list.length == 3);
	Console.putln(list.peek() == arr[2]);

	return 0;
}
