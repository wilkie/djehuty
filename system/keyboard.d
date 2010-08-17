/*
 * keyboard.d
 *
 * This module implements keyboard translations.
 *
 */

module system.keyboard;

import core.definitions;

import system.keyboardtranslator.qwertyus;
import system.keyboardtranslator.keyboardtranslator;

enum KeyboardLayout {
	QwertyUS
}

class Keyboard {
static:
private:
	KeyboardLayout _layout = KeyboardLayout.QwertyUS;
	KeyboardTranslator _translator;

public:
	KeyboardLayout layout() {
		return _layout;
	}

	void layout(KeyboardLayout value) {
		_layout = value;
		switch(_layout) {
			case KeyboardLayout.QwertyUS:
			default:
				_translator = new QwertyUSTranslator();
				break;
		}
	}

	Key translate(Key key) {
		if (_translator is null) {
			this.layout = _layout;
		}
		return _translator.translate(key);
	}
}
