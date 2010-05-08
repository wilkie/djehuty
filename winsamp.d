import djehuty;
import runtime.lifetime;

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
import math.integer;
import parsing.d.parser;

import networking.ftp;

private template _switch_string(T) {
	int _switch_string(T[][] table, T[] compare) {
		if (table.length == 0) {
			return -1;
		}

		TypeInfo ti = typeid(T[]);
		// Binary search the table
		size_t min = 0;
		size_t max = table.length;

		// Current comparing position
		size_t cur;

		// Temp for compare value
		int cmp;

		while(max > min) {
			cur = (max + min) / 2;
			cmp = ti.compare(&table[cur], &compare);

			if (cmp == 0) {
				return cur;
			}
			else if (cmp > 0) {
				max = cur;
			}		
			else {
				min = cur + 1;
			}
		}

		return -1;
	}
}


import spec.specification;

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

		Console.putln([1,2,3,4].rotate(2));
		Console.putln("hello"c.dup.reverse);
		Console.putln("he\u0364llo"c.dup.reverse);
		Console.putln("hlle\u0364o"c.dup.reverse);
		Console.putln("he\u0364po"c.dup.reverse);
		Console.putln("he\u0364llo"w.dup.reverse);
		Console.putln("he\u0364llo"d.dup.reverse);
		Console.putln("he\u0364llo"d.dup.reverse());
		Console.putln([1,2,3,4,5,6,7,8].dup.reverse());
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
		Console.forecolor = Color.White;
		Console.putln("White");
		Console.forecolor = Color.Red;
		Console.putln("Red");
		Console.forecolor = Color.Green;
		Console.putln("Green");
		Console.forecolor = Color.Blue;
		Console.putln("Blue");
		Console.forecolor = Color.Yellow;
		Console.putln("Yellow");
		Console.forecolor = Color.Magenta;
		Console.putln("Magenta");
		Console.forecolor = Color.Cyan;
		Console.putln("Cyan");
		Console.forecolor = Color.Gray;
		Console.putln("Gray");
		Console.forecolor = Color.DarkGray;
		Console.putln("DarkGray");
		Console.forecolor = Color.DarkRed;
		Console.putln("DarkRed");
		Console.forecolor = Color.DarkGreen;
		Console.putln("DarkGreen");
		Console.forecolor = Color.DarkBlue;
		Console.putln("DarkBlue");
		Console.forecolor = Color.DarkYellow;
		Console.putln("DarkYellow");
		Console.forecolor = Color.DarkMagenta;
		Console.putln("DarkMagenta");
		Console.forecolor = Color.DarkCyan;
		Console.putln("DarkCyan");
		Console.forecolor = Color.Black;
		Console.putln("Black");
		Console.forecolor = Color.Gray;
		ulong foo = 45;
		Console.putln(foo);
		Atomic.add(foo, 45);
		Console.putln(foo);
		Console.putln(q);
		
		Console.putln([1,2,3,4].rotate(-1));

		foreach_reverse(dchar d; "he\u0364llo"c) {
			Console.putln(d);
		}

		Console.putln([3,2,1].sort);	
		Console.putln([[1,2],[2,3],[3],[1],[0]].sort);

		int[] fooint = (cast(int*)_d_newarrayiT(typeid(int[]), 10))[0..10];
		Console.putln(fooint);

		dstring[] fuzz = [
			"abc",
			"zzt"
			"hello",
		];

		string foobe = "hello";

		switch(foobe) {
			case "abc":
			case "zzt":
				break;
			case "hello":
				Console.putln("yay");
				break;
			default:
				break;
		}

		Console.putln(_switch_string(fuzz, "hello"d));

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
