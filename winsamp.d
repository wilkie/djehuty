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

int main(string[] args) {
	printf("hello world\n");
	printf("---------------\n");
	int[] foobar = new int[10];
	foreach(size_t i, ref element; foobar) {
		element = i;
	}
	foreach(ref element; foobar) {
		printf("%d\n", element);
	}
	printf("%d\n", foobar.length);
	printf("---------------\n");
	foobar ~= 42;
	foreach(ref element; foobar) {
		printf("%d\n", element);
	}
	printf("%d\n", foobar.length);
	printf("---------------\n");
	int[] eff = new int[5];
	foreach(size_t i, ref element; eff) {
		element = i + foobar.length;
	}
	foreach(element;eff) {
		printf("%d\n", element);
	}
	printf("%d\n", eff.length);
	printf("---------------\n");
	int[] result = foobar ~ eff;
	foreach(element; result) {
		printf("%d\n", element);
	}
	printf("%d\n", result.length);
	printf("---------------\n");
	foreach(ref element; foobar) {
		printf("%d\n", element);
	}
	printf("%d\n", foobar.length);
	printf("---------------\n");
	foreach(element;eff) {
		printf("%d\n", element);
	}
	printf("%d\n", eff.length);
	printf("---------------\n");

	eff.length = eff.length + 5;

	foreach(element;eff) {
		printf("%d\n", element);
	}
	printf("%d\n", eff.length);
	printf("---------------\n");

	int[] duplicate = result.dup;
	foreach(element; duplicate) {
		printf("%d\n", element);
	}
	printf("%d\n", duplicate.length);
	printf("---------------\n");

	duplicate ~= result;
	foreach(element; duplicate) {
		printf("%d\n", element);
	}
	printf("%d\n", duplicate.length);
	printf("---------------\n");


	A a = new A(15);
	int ret = a.foobar();
	printf("%d\n", ret);

	return 0;
}
