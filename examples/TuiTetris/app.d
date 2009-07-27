import tui.application;

import io.console;

import gamewindow;

class TermTetris : TuiApplication {

	// Start an application instance
	static this() { new TermTetris(); }

	override void onApplicationStart() {
		Console.hideCaret();

		gameWindow = new GameWindow();

		push(gameWindow);
	}

	override void onApplicationEnd() {
		Console.clear();
		Console.setColor(fgColor.White);
		Console.put("Your Score was: ");
		Console.setColor(fgColor.BrightYellow);
		Console.putln(gameWindow.getScore());

		Console.putln("");
		Console.setColor(fgColor.White);
		Console.putln("Thank you for playing!");
	}

protected:
	GameWindow gameWindow;
}
