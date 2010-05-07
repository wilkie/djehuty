import cui.application;

import djehuty;

import io.console;

import gamewindow;

import binding.c;

class TermTetris : CuiApplication {

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
		Console.forecolor = Color.White;
		Console.put("Your Score was: ");
		Console.forecolor = Color.Yellow;
		Console.putln(gameWindow.getScore());

		Console.putln("");
		Console.forecolor = Color.Gray;
		Console.putln("Thank you for playing!");
	}

protected:
	GameWindow gameWindow;
}
