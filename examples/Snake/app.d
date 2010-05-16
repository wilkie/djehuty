import cui.application;

import win;

int main(string[] args) {
	auto app = new SnakeApp();
	app.run();
	return 0;
}

class SnakeApp : CuiApplication {
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

