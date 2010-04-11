module core.arguments;

import core.definitions;
import core.util;

import core.string;
import core.list;

// Description: This class holds the command line arguments that were passed into the app and will aid in parsing them.
class Arguments : List!(string) {
public:

	this() {
	}

	static Arguments instance() {
		if (appInstance is null) {
			appInstance = new Arguments();
		}

		return appInstance;
	}

protected:

	static Arguments appInstance;
}
