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
import cui.button;

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

import spec.modulespecification;

import data.queue;

class MyWindow : CuiDialog {
	Timer tmr;
//	CuiLabel lbl;
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
		super("untitled", WindowStyle.Fixed, toPick, 4,4, 30, 15);
		visible = true;

		tabbox = new CuiTabBox(0,0,this.clientWidth(),this.clientHeight());

		tabbox.add("foo");
		tabbox.add("bar");

		tabbox.visible = true;

		box = new CuiTextBox(0,0,tabbox.clientWidth(), tabbox.clientHeight());
		box.lineNumbers = true;
		box.visible = true;
		box.backcolor = toPick;
		box.backcolorNum = toPick;

//	push(box);

		tabbox.push(box);
		push(tabbox);

//		lbl = new CuiLabel(0, 2, 10, "Hello", Color.Red, Color.Black);
//		lbl.visible = true;
//		push(lbl);

		field = new CuiTextField(0, 3, 10, "Hello");
		field.visible = true;
		push(field);
	}

	override void onResize() {
		box.reposition(0,0,this.clientWidth,this.clientHeight);
		tabbox.reposition(0, 0, this.clientWidth, this.clientHeight);
		box.reposition(0, 0, tabbox.clientWidth(), tabbox.clientHeight());
	}

	override bool onSignal(Dispatcher dsp, uint signal) {
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

class A {
	bool onSignal(Dispatcher dsp, uint signal) {
		auto button = cast(CuiButton)dsp;
		button.text = "Hello!";
		return true;
	}
}

int main(string[] args) {
	auto app = new CuiApplication("MyApp");
	app.push(new CuiLabel(0, 3, 10, "Hello", Color.Red, Color.Black));
	app.push(new MyWindow());
	auto a = new A();
	app.push(new CuiButton(5,5, 10, 3, "Button"), &a.onSignal);
	app.run();
	return 0;
}