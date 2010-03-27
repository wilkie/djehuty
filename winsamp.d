import djehuty;

import gui.application;
import gui.window;
import gui.button;
import gui.widget;
import gui.listbox;

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

import networking.irc;

import io.console;

import hashes.md5;

import specs.test;

import gui.osbutton;

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

string from(string str, int i) {
	string ret = "";
	switch (str) {
		default:
		case "d":
			ret = itoa(i, 10);
			break;
		case "x":
			ret = itoa(i, 16);
			break;
	}
	return ret;
}

class MyConsoleApp : Application {
	static this() { new MyConsoleApp(); }
	override void onApplicationStart() {

		putln("integers: ", 2, ":", "".from(2), ":", "x".from(128));
		putln(["dave", "is", "awesome"]);
		putln("dave.is.awesome".split('.'));
		putln([1,2,3]);
		putln([]);

		ftp = new FtpClient();

		push(ftp);

		string test = "";
		ftp.connect(test,21,"","");
		

		string foo = ftp.list_directory(".");
		putln(foo);
//		ftp.send_file("/home/bkuhlman/public_html/files","README","./");


		bool check =ftp.close();

	}

	/*	override bool onSignal(Dispatcher dsp, uint signal) {
		if (dsp is ftp) {
		switch(signal) {
		case FtpClient.Signal.Authenticated:
		Console.putln("Authenticated");
		ftp.switch_to_passive();
		break;
		case FtpClient.Signal.PassiveMode:
		ftp.send_Command("TYPE A");
	//	ftp.list_files();
	break;
	case FtpClient.Signal.OK:
	ftp.send_Command("CWD /home/bkuhlman/public_html/files");

	break;
	case FtpClient.Signal.LoginIncorrect:
	//exit incorrect login
	//		ftp.close();
	break;
	case FtpClient.Signal.CurDirSuc:
	//ftp.send_Command("STOR Project_3.doc");
	ftp.send_Command("RETR life.c");
	break;
	default:
	// Dunno
	break;
	}
	}
	return true;
	}*/

	private:
	FtpClient ftp;
}

