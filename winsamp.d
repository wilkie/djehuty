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
import cui.canvas;
import cui.progressbar;
import cui.scrollbar;
import cui.listbox;

import synch.timer;
import synch.thread;
import synch.atomic;

import net.irc;
import net.ftp;

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
	bool buttonHandler(Dispatcher dsp, uint signal) {
		auto button = cast(CuiButton)dsp;
		button.text = "Hello!";
		return true;
	}
}

dchar[][] world;

import math.random;

class Rogue : CuiWindow {
	int worldX, worldY;
	int playerX, playerY;

	class Enemy {
		int hp;

		int x;
		int y;

		bool stunned;
		Color color;
		dchar image;
	}

	static int _w = 250;
	static int _h = 250;
	
	static int playerHP = 10;

	List!(Enemy) enemies;
	Random rnd;

	CuiLabel hp;
	CuiProgressBar bar;

	this() {
		enemies = new List!(Enemy)();

		rnd = new Random();
		world = new dchar[][](_w,_h);
		for(int x = 0; x < _w; x++) {
			for(int y = 0; y < _h; y++) {
				int foo = rnd.next(5);
				if (foo < 4) {
					world[x][y] = '.';
				}
				else {
					world[x][y] = '|';
				}
			}
		}
		playerX = Console.width / 2;
		playerY = Console.height / 2;
		super(0,0,Console.width, Console.height);

		for(int i = 0; i < 100; i++) {
			addEnemy(10);
		}

		push(hp = new CuiLabel(0,0,10,"HP: " ~ toStr(playerHP), Color.Yellow));
		push(bar = new CuiProgressBar(10, 0, Console.width - 10, 1));
		bar.value = 1.0;
	}

	void hitPlayer(int hp) {
		playerHP -= hp;
		if (playerHP < 0) {
			playerHP = 0;
		}
		this.bar.value = cast(double)playerHP / 10.0;
		this.hp.text = "HP: " ~ toStr(playerHP);
	}

	override void onDraw(CuiCanvas canvas) {
		// Draw view of the world
		canvas.forecolor = Color.White;
		canvas.backcolor = Color.Black;
		canvas.position(0,0);
		for(int y = worldY; y < worldY + this.height && y < _h; y++) {
			if (y < 0) {
				continue;
			}
			canvas.position(0,y-worldY);
			string str = "";
			for(int x = worldX; x < worldX + this.width && x < _w; x++) {
				if (x == playerX && y == playerY) {
					str ~= "@";
				}
				else if (x < 0) {
					str ~= " ";
				}
				else {
					str ~= world[x][y];
				}
			}
			canvas.write(str);
		}

		canvas.forecolor = Color.Red;
		foreach(size_t index, Enemy enemy; enemies) {
			if (enemy.x >= worldX && enemy.x < worldX + Console.width) {
				if (enemy.y >= worldY && enemy.y < worldY + Console.height) {
					int rx, ry;
					rx = enemy.x - worldX;
					ry = enemy.y - worldY;

					canvas.forecolor = enemy.color;
					canvas.position(rx, ry);
					canvas.write(enemy.image);
				}
			}
		}
	}

	override void onKeyDown(Key key) {
		if (key.ctrl && key.code == Key.Q) {
			Djehuty.app.exit(0);
		}
		else if (key.code == Key.Left) {
			movePlayer(-1, 0);
		}
		else if (key.code == Key.Right) {
			movePlayer(1, 0);
		}
		else if (key.code == Key.Up) {
			movePlayer(0, -1);
		}
		else if (key.code == Key.Down) {
			movePlayer(0, 1);
		}
		else {
			super.onKeyDown(key);
		}
		update();
	}

	void movePlayer(int rx, int ry) {
		playerX += rx;
		playerY += ry;

		if (playerY < 0) { playerY = 0; }
		if (playerX < 0) { playerX = 0; }
		if (playerY >= _w) { playerY = _w-1; }
		if (playerX >= _h) { playerX = _h-1; }

		if (world[playerX][playerY] == '|') {
			playerY -= ry;
			playerX -= rx;
		}
		else {
			// Enemy
			foreach(size_t i, Enemy enemy; enemies) {
				if (enemy.x == playerX && enemy.y == playerY) {
					enemy.stunned = true;
					enemy.hp--;
					if (enemy.hp <= 0) {
						enemies.remove(enemy);
					}
					playerY -= ry;
					playerX -= rx;
					break;
				}
			}
		}

		worldY = playerY - (Console.height/2);
		worldX = playerX - (Console.width/2);

		if (worldX < 0) { worldX = 0; }
		if (worldY < 0) { worldY = 0; }
		if (worldX > _w - Console.width) { worldX = _w - Console.width; }
		if (worldY > _h - Console.height) { worldY = _h - Console.height; }

		redraw();
	}

	void moveEnemy(Enemy e, int rx, int ry) {
		e.x += rx;
		e.y += ry;

		if (e.y < 0) { e.y = 0; }
		if (e.x < 0) { e.x = 0; }
		if (e.y >= _h) { e.y = _h-1; }
		if (e.x >= _w) { e.x = _w-1; }

		if (world[e.x][e.y] == '|') {
			e.y -= ry;
			e.x -= rx;
		}
		else if (e.x == playerX && e.y == playerY) {
			// Hit the player
			hitPlayer(1);
			e.y -= ry;
			e.x -= rx;
		}
	}

	void addEnemy(int hp) {
		Enemy e = new Enemy();
		e.x = rnd.next(_w);
		e.y = rnd.next(_h);

		e.hp = hp;
		e.color.red = rnd.nextDouble() % 1.0;
		e.color.green = rnd.nextDouble() % 1.0;
		e.color.blue = rnd.nextDouble() % 1.0;
		e.color.alpha = 1.0;

		e.image = 'a' + rnd.next(26);

		enemies.add(e);
	}

	void update() {
		foreach(enemy; enemies) {
			if (enemy.stunned) {
				enemy.stunned = false;
				continue;
			}
			int dir = rnd.next(4);
			switch(dir) {
				case 0:
					moveEnemy(enemy, -1, 0);
					break;
				case 1:
					moveEnemy(enemy, 1, 0);
					break;
				case 2:
					moveEnemy(enemy, 0, -1);
					break;
				case 3:
					moveEnemy(enemy, 0, 1);
				default:
					break;
			}
		}
	}
}

class C {
	bool timerProc(Dispatcher dsp, uint signal) {
		Console.putln("asdf");
		return false;
	}
}

void foobarfunc(bool f) {
}

int main(string[] args) {
//  	auto app = new Application("MyApp");
// 	Timer tmr = new Timer();
// 	tmr.interval = 250;
// 	C a = new C();
// 	app.push(tmr, &a.timerProc);
// 	tmr.stop();
// 	tmr.start();
// 	Thread.sleep(1000);
	//*/
	auto app = new CuiApplication("MyApp");
	app.push(new Rogue());
	app.push(new CuiScrollBar(0,0,25,1,Orientation.Horizontal));
	app.push(new CuiScrollBar(0,5,1,25,Orientation.Vertical));
	auto lb = new CuiListBox(10, 10, 20, 20);
	app.push(lb);
	lb.add("hello");
	lb.add("foo");
	lb.add("bar");
	lb.add("meh");
	for(int i = 0; i < 34; i++) {
		lb.add("item " ~ toStr(i));
	}
	app.run();//*/
	return 0;
}