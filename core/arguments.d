module core.arguments;

import core.definitions;
import core.string;
import core.util;
import core.list;

import utils.arraylist;

// Description: This class holds the command line arguments that were passed into the app and will aid in parsing them.
class Arguments : List!(String) {
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