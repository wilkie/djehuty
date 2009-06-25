import tui.window;
import tui.label;
import console.main;

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

	override bool OnSignal(Dispatcher source, uint signal) {
		if (source is game) {
			if(signal == GameControl.Event.ScoreUpdated) {
				scoreLabel.setText(new String(game.getScore()));
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