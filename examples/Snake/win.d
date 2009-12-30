import djehuty;

import io.console;

import synch.timer;

import tui.window;

import app;
import constants;
import game;
import posn;
import snake;

class SnakeWindow : TuiWindow {
	this() {
		_frame_wait = FrameWait.Init;

		_cod = DeathBy.NotDead;

		_timer = new Timer();
		setSpeed();
		push(_timer);

		_game = new SnakeGame(this);
	}

	void setSpeed() {
		uint dirCoef = 1;

		if (_game !is null) {
			Snake s = _game.snake;
			if (s !is null)
				dirCoef = s.isVertical ? SpeedCoef.V : SpeedCoef.H;
		}

		_timer.setInterval(_frame_wait * dirCoef / FrameWait.Multiplier);
	}

	void gameOver(DeathBy d) {
		_cod = d;

		_end_time = Time.Now();

		_timer.stop();

		Console.setColor(fgColor.BrightRed);
		Console.putln("DEAD!");
	}


	override void onInitialize() {
		super.onInitialize();

		Console.setColor(fgColor.White, bgColor.Black);

		string[] instructions = ["move: arrows/wasd", "stop: q or die", "quit: any key"];
		foreach (uint y, string s; instructions) {
			Console.position(0, y);
			Console.put(s);
		}
		_timer.start();

		_start_time = Time.Now();
	}

	override void onKeyDown(Key k) {
		if (_cod != DeathBy.NotDead)
			finishUp();
		switch(k.code) {
			case Key.Up:
			case Key.W:
				_game.turn(Dir.Up);
				speedUp();
				break;
			case Key.Down:
			case Key.S:
				_game.turn(Dir.Down);
				speedUp();
				break;
			case Key.Left:
			case Key.A:
				_game.turn(Dir.Left);
				speedUp();
				break;
			case Key.Right:
			case Key.D:
				_game.turn(Dir.Right);
				speedUp();
				break;
			case Key.Escape:
			case Key.Q:
				if (_cod == DeathBy.NotDead) {
					gameOver(DeathBy.Quit);
					finishUp();
				}
				break;
			default:
				break;
		}
		super.onKeyDown(k);
	}

	bool onSignal(Dispatcher dsp, uint signal) {
		if (dsp is _timer) {
			if (_game !is null)
				_game.frame();
		}
		return true;
	}

private:
	void speedUp() {
		_frame_wait -= FrameWait.Step;
		if (_frame_wait < FrameWait.Min)
			_frame_wait = FrameWait.Min;
	}

	void finishUp() {
		(cast(SnakeApp)(this.application)).shutdown();
		Console.clear();

		String msg;

		uint time = (_end_time - _start_time).second();
		uint fps = cast(uint)(1000.0 / _frame_wait * FrameWait.Multiplier * 2 / (SpeedCoef.H + SpeedCoef.V));

		if (time > 0 && this.width > 0 && this.height > 0 && _game !is null) {
			string cod_msg;
			switch (_cod) {
				case DeathBy.CollisionSelf:
					cod_msg = "hit yourself";
					break;
				case DeathBy.CollisionPortal:
					cod_msg = "crashed into a portal";
					break;
				case DeathBy.CollisionReverse:
					cod_msg = "reversed into yourself";
					break;
				case DeathBy.Quit:
					cod_msg = "quit";
					break;
				default:
					cod_msg = "died mysteriously";
					break;
			}

			Snake s = _game.snake;

			uint len = 0;
			if (s !is null)
				len = s.length;

			msg = new String(cod_msg ~ " with %d segments in %d seconds on %d lines and %d columns at %d frames per second", len, time, this.height, this.width, fps);
		} else {
			msg = new String("You didn't even play!");
		}

		Console.putln(msg);

		(cast(SnakeApp)(this.application)).end(0);
	}

	uint _frame_wait;

	DeathBy _cod;

	Time _start_time, _end_time;

	Timer _timer;
	SnakeGame _game;
}

