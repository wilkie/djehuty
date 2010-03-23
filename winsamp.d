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

class MyConsoleApp : Application {
	static this() { new MyConsoleApp(); }
	override void onApplicationStart() {
		ftp = new FtpClient();

		push(ftp);

		string test = "paradox.sis.pitt.edu";
		ftp.connect(test,21,"bkuhlman","4folders4");

		ftp.switch_to_passive();

		ftp.get_file("/home/bkuhlman/public_html/files","webserver.c","./");


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

