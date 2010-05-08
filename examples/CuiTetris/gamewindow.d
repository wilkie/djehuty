import cui.window;
import cui.label;

import io.console;

import djehuty;

import gamecontrol;

class GameWindow : CuiWindow {
	this() {
		scoreLabel = new CuiLabel(4, 5, 10, "0");
		game = new GameControl();

		push(scoreLabel);
		push(new CuiLabel(2, 3, 10, "Score", Color.Yellow));
		push(game);
	}

	override bool onSignal(Dispatcher source, uint signal) {
		if (source is game) {
			if(signal == GameControl.Event.ScoreUpdated) {
				scoreLabel.text = toStr(game.getScore());
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
	CuiLabel scoreLabel;
	GameControl game;
}
