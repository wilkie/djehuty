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

import math.fixed;
import math.currency;
import math.integer;
import parsing.d.parser;

import networking.ftp;

class MyConsoleApp : Application {
	static this() { new MyConsoleApp(); }
	override void onApplicationStart() {

		Thread t = Thread.getCurrent();

		ulong a, b, c;
		a = 4;
		b = 4;
		c = 5;
		Console.putln("{1}, {0}, {1}, {0:X}, {} {} {X8} {:00.0000}".format(12, 11, 13, 3.4));
		Console.putln(a,b,c);
		Console.putln(Atomic.compareExchange(a,b,c));
		Console.putln(a,b,c);
		Atomic.exchange(a,6);
		Console.putln(a,b,c);
		Timer tmr = new Timer(250);
		push(tmr);
		tmr.start();
		for(;;){}
	}

	override bool onSignal(Dispatcher dsp, uint signal) {
		Console.putln("fire");
		return true;
	}
}
