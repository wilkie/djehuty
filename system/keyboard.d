/*
 * keyboard.d
 *
 * This module implements keyboard translations.
 *
 */

module system.keyboard;

import core.definitions;

import system.layout.keyboardtranslator;

import system.layout.qwertyus;
import system.layout.qwertycanfr;
import system.layout.dvorak;
import system.layout.colemak;

enum KeyboardLayout {
	QwertyUS,
	QwertyCanFr,
	QwertyCanMultilingual,
	Dvorak,
	Colemak
}

class Keyboard {
static:
private:
	KeyboardLayout _layout = KeyboardLayout.QwertyCanFr;
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

			case KeyboardLayout.QwertyCanFr:
				_translator = new QwertyCanFrTranslator();
				break;

			case KeyboardLayout.Dvorak:
				_translator = new DvorakTranslator();
				break;

			case KeyboardLayout.Colemak:
				_translator = new ColemakTranslator();
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
