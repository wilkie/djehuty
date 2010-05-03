import cui.application;

import win;

class SnakeApp : CuiApplication {
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

