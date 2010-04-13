import tui.application;

import io.console;

import gamewindow;

import binding.c;

class TermTetris : TuiApplication {

	// Start an application instance
	static this() { printf("HELLO!\n"); new TermTetris(); }

	override void onApplicationStart() {
		Console.putln("foo");
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
