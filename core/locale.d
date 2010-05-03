/*
 * locale.d
 *
 * This module handles locale and internationalization.
 *
 * Author: Dave Wilkinson
 * Originated: September 15th, 2009
 *
 */

module core.locale;

import core.time;
import core.date;
import core.string;
import core.definitions;

// Supported Locales
import locales.all;

enum LocaleId : uint {
	English_US,
	English_GB,
	French_FR,
}

class Locale {
static:

	LocaleId id() {
		return _localeId;
	}

	void id(LocaleId value) {
		_localeId = value;
		switch(_localeId) {
			default:
			case LocaleId.English_US:
				_localeEngine = new LocaleEnglish_US();
				break;
			case LocaleId.French_FR:
				_localeEngine = new LocaleFrench_FR();
				break;
		}
	}

	string formatNumber(double value) {
		return _localeEngine.formatNumber(value);
	}

	string formatCurrency(long fixed, long scale) {
		return _localeEngine.formatCurrency(fixed, scale);
	}

	string formatCurrency(double amount) {
		return _localeEngine.formatCurrency(amount);
	}

	string formatTime(Time time) {
		return _localeEngine.formatTime(time);
	}

	string formatDate(Date date) {
		return _localeEngine.formatDate(date);
	}

private:

	LocaleId _localeId = LocaleId.English_US;
	LocaleInterface _localeEngine;
}

interface LocaleInterface {
	string formatTime(Time time);
	string formatDate(Date date);
	string formatNumber(double value);
	string formatNumber(long fixed, long scale, long round);
	string formatCurrency(double amount);
	string formatCurrency(long fixed, long scale);
}
