import tui.window;
import tui.label;

import io.console;

import djehuty;

import gamecontrol;

class GameWindow : TuiWindow {
	this() {
		scoreLabel = new TuiLabel(4, 5, 10, "0");
		game = new GameControl();

		push(scoreLabel);
		push(new TuiLabel(2, 3, 10, "Score", fgColor.BrightYellow));
		push(game);
	}

	override bool onSignal(Dispatcher source, uint signal) {
		if (source is game) {
			if(signal == GameControl.Event.ScoreUpdated) {
				scoreLabel.text = new String(game.getScore());
				return true;
			}
		}

		return false;
	}

	override void onKeyDown(Key key) {
		if (key.ctrl && key.code == Key.Q) {
			application.exit(0);
			return;
		}
		super.onKeyDown(key);
	}

	int getScore() {
		return game.getScore();
	}

protected:
	TuiLabel scoreLabel;
	GameControl game;
}
