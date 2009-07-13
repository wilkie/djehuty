import tui.window;
import tui.label;
import console.main;

import djehuty;

import gamecontrol;

class GameWindow : TuiWindow {
	this() {
		Console.putln("boo");
		scoreLabel = new TuiLabel(4, 5, 10, "0");
		Console.putln("boo b");
		game = new GameControl();
		Console.putln("boo c");

		push(scoreLabel);
		push(new TuiLabel(2, 3, 10, "Score", fgColor.BrightYellow));
		push(game);
	}

	override bool OnSignal(Dispatcher source, uint signal) {
		if (source is game) {
			if(signal == GameControl.Event.ScoreUpdated) {
				scoreLabel.text = new String(game.getScore());
				return true;
			}
		}

		return false;
	}

	int getScore() {
		return game.getScore();
	}

protected:
	TuiLabel scoreLabel;
	GameControl game;
}