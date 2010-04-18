module platform.application;

import binding.c;

class ApplicationController {
	this() {
	}

	void exitCode(uint value) {
		_exitCode = value;
	}

	uint exitCode() {
		return _exitCode;
	}

	void start() {
	}

	void end() {
		exit(_exitCode);
	}

	static ApplicationController instance() {
		if (_app is null) {
			_app = new ApplicationController();
		}
		return _app;
	}

	bool usingCurses() {
		return _usingCurses;
	}

	void usingCurses(bool value) {
		_usingCurses = value;
	}

private:

	bool _usingCurses;
	uint _exitCode;
	static ApplicationController _app;
}
