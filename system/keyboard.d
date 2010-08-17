/*
 * keyboard.d
 *
 * This module implements keyboard translations.
 *
 */

module system.keyboard;

import core.definitions;

import system.layout.keytranslator;

import system.layout.unitedstates;
import system.layout.quebec;
import system.layout.canadianmultilingual;
import system.layout.polishprogrammers;
import system.layout.dvorak;
import system.layout.colemak;

enum KeyboardLayout {
	CanadianMultilingualStandard,
	Colemak,
	Dvorak,
	PolishProgrammers,
	Quebec,
	UnitedStates,
}

class Keyboard {
static:
private:
	KeyboardLayout _layout = KeyboardLayout.PolishProgrammers;
	KeyTranslator _translator;

public:
	KeyboardLayout layout() {
		return _layout;
	}

	void layout(KeyboardLayout value) {
		_layout = value;
		switch(_layout) {
			case KeyboardLayout.UnitedStates:
			default:
				_translator = new UnitedStatesKeyboard();
				break;

			case KeyboardLayout.Quebec:
				_translator = new QuebecKeyboard();
				break;

			case KeyboardLayout.Dvorak:
				_translator = new DvorakKeyboard();
				break;

			case KeyboardLayout.PolishProgrammers:
				_translator = new PolishProgrammersKeyboard();
				break;

			case KeyboardLayout.Colemak:
				_translator = new ColemakKeyboard();
				break;

			case KeyboardLayout.CanadianMultilingualStandard:
				_translator = new CanadianMultilingualKeyboard();
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
