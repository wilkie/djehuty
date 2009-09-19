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
import core.locales.en_us;
import core.locales.fr_fr;

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
	}

	string formatNumber(double value) {
		string ret;
		switch(_localeId) {
			default:
			case LocaleId.English_US:
				ret = LocaleEnglish_US.formatNumber(value);
				break;
			case LocaleId.French_FR:
				ret = LocaleFrench_FR.formatNumber(value);
				break;
		}
		return ret;
	}

	string formatCurrency(double amount) {
		string ret;
		switch(_localeId) {
			default:
			case LocaleId.English_US:
				ret = LocaleEnglish_US.formatCurrency(amount);
				break;
			case LocaleId.French_FR:
				ret = LocaleFrench_FR.formatCurrency(amount);
				break;
		}
		return ret;
	}

	string formatTime(Time time) {
		string ret;
		switch(_localeId) {
			default:
			case LocaleId.English_US:
				ret = LocaleEnglish_US.formatTime(time);
				break;
			case LocaleId.French_FR:
				ret = LocaleFrench_FR.formatTime(time);
				break;
		}
		return ret;
	}

	string formatDate(Date date) {
		string ret;
		switch(_localeId) {
			default:
			case LocaleId.English_US:
				ret = LocaleEnglish_US.formatDate(date);
				break;
			case LocaleId.French_FR:
				ret = LocaleFrench_FR.formatDate(date);
				break;
		}
		return ret;
	}

private:

	LocaleId _localeId = LocaleId.English_US;
}

interface LocaleInterface {
static:
	string formatTime(Time time);
	string formatDate(Date date);
	string formatNumber(double value);
	string formatCurrency(double amount);
}
