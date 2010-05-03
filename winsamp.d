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
import synch.atomic;

import networking.irc;

import io.console;

import hashes.md5;

import specs.test;

import parsing.options;

import io.file;

import math.vector;

import core.date;

import tui.textfield;
import core.application;

import tui.textbox;
import tui.codebox;

import tui.dialog;
import tui.filebox;
import tui.listbox;

import math.fixed;
import math.currency;
import math.integer;
import parsing.d.parser;

import networking.ftp;

import data.queue2;

class MyConsoleApp : Application {
	static this() { new MyConsoleApp(); }
	override void onApplicationStart() {

		q = new Queue2!(string);
		Thread t = Thread.current;

		ulong a, b, c;
		a = 4;
		b = 0b10011101_10110011_11100011_11011010;
		c = 5;
		Console.putln("{1}, {0}, {1}, {0:X}, {} {} {X8} {00.0000}".format(12, 11, 13, 3.4));
		Console.putln(a,b,c);
		Console.putln(Atomic.compareExchange(a,b,c));
		Console.putln(a,b,c);

		float d,e,f;
		d = 1.0;
		e = 1.1;
		f = 2.234;
		Console.putln(d,e,f);
		Console.putln(Atomic.compareExchange(d,e,f));
		Console.putln(d,e,f);

		void* A=null;
		void* B=cast(void*)0xfe;
		void* C=cast(void*)0xff;

		Console.putln(A,B,C);
		Console.putln(Atomic.compareExchange(A,B,C));
		Console.putln(A,B,C);

		short g,h,i;
		g = 3;
		h = 4;
		i = 4;		
		Console.putln(g,h,i);
		Console.putln(Atomic.compareExchange(g,h,i));
		Console.putln(g,h,i);

		Console.putln(new Fixed(3.5));
		Atomic.exchange(a,6);
		Console.putln(a,b,c);
		Console.putln("{c}".format(1500.42));
		Locale.id = LocaleId.French_FR;
		Console.putln("{c}".format(1500.42));
		Console.putln(new Currency(150042,2));
		t = new Thread(&foo);
		t.start();

		t = new Thread(&foo);
		t.start();
		t = new Thread(&foo);
		t.start();
		t = new Thread(&foo);
		t.start();
		t = new Thread(&foo);
		t.start();
		t = new Thread(&foo);
		t.start();
		t = new Thread(&foo);
		t.start();
		t = new Thread(&foo);
		t.start();
		t = new Thread(&foo);
		t.start();
		Timer tmr = new Timer(250);
		push(tmr);
		tmr.start();
		while(freak < 9) {
		}
		ulong foo = 45;
		Console.putln(foo);
		Atomic.add(foo, 45);
		Console.putln(foo);
		Console.putln(q);
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
