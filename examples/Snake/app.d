import tui.application;

import win;

class SnakeApp : TuiApplication {
	static this() {
		new SnakeApp();
	}

	override void onApplicationStart() {
		push(new SnakeWindow());
	}

	override void shutdown() {
		super.shutdown();
	}

	override void end(uint exitCode) {
		super.end(exitCode);
	}
}

