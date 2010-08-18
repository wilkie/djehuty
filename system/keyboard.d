/*
 * keyboard.d
 *
 * This module implements keyboard translations.
 *
 */

module system.keyboard;

import core.definitions;

import system.layout.keytranslator;

import system.layout.canadianmultilingual;
import system.layout.czechprogrammers;
import system.layout.colemak;
import system.layout.dvorak;
import system.layout.french;
import system.layout.polishprogrammers;
import system.layout.quebec;
import system.layout.russian;
import system.layout.unitedstates;
import system.layout.unitedstatesinternational;

enum KeyboardLayout {
	CanadianMultilingualStandard,
	CzechProgrammers,
	Colemak,
	Dvorak,
	French,
	PolishProgrammers,
	Quebec,
	Russian,
	UnitedStates,
	UnitedStatesInternational,
}

class Keyboard {
static:
private:
	KeyboardLayout _layout = KeyboardLayout.French;
	KeyTranslator _translator;

public:
	KeyboardLayout layout() {
		return _layout;
	}

	void layout(KeyboardLayout value) {
		_layout = value;
		switch(_layout) {
			case KeyboardLayout.CanadianMultilingualStandard:
				_translator = new CanadianMultilingualKeyboard();
				break;

			case KeyboardLayout.Colemak:
				_translator = new ColemakKeyboard();
				break;

			case KeyboardLayout.CzechProgrammers:
				_translator = new CzechProgrammersKeyboard();
				break;

			case KeyboardLayout.Dvorak:
				_translator = new DvorakKeyboard();
				break;

			case KeyboardLayout.French:
				_translator = new FrenchKeyboard();
				break;

			case KeyboardLayout.PolishProgrammers:
				_translator = new PolishProgrammersKeyboard();
				break;

			case KeyboardLayout.Quebec:
				_translator = new QuebecKeyboard();
				break;

			case KeyboardLayout.Russian:
				_translator = new RussianKeyboard();
				break;

			case KeyboardLayout.UnitedStates:
			default:
				_translator = new UnitedStatesKeyboard();
				break;

			case KeyboardLayout.UnitedStatesInternational:
				_translator = new UnitedStatesInternationalKeyboard();
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
