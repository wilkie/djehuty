/*
 * date.d
 *
 * This module implements Date related functions.
 *
 */

module core.date;

enum Month {
	January,
	February,
	March,
	April,
	May,
	June,
	July,
	August,
	September,
	October,
	November,
	December
}

enum Day {
	Sunday,
	Monday,
	Tuesday,
	Wednesday,
	Thursday,
	Friday,
	Saturday
}

import scaffold.time;

import core.string;
import core.locale;

class Date {

	this() {
		DateGet(_month, _day, _year);
	}

	this(Month month, uint day, uint year) {
		_month = month;
		_day = day;
		_year = year;
	}

	Day dayOfWeek() {
		return Day.Sunday;
	}

	Month month() {
		return _month;
	}

	void month(Month value) {
		_month = value;
	}

	uint day() {
		return _day;
	}

	void day(uint value) {
		_day = value;
	}

	uint year() {
		return _year;
	}

	void year(uint value) {
		_year = value;
	}

	static Date Now() {
		return new Date();
	}

	string toString() {
		return Locale.formatDate(this);
	}

private:

	Month _month;
	uint _day;
	uint _year;

	class _Now : Date {
		this() {
		}
	}

	static _Now _now;
}