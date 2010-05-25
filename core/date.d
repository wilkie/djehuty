/*
 * date.d
 *
 * This module implements Date related functions.
 *
 */

module core.date;

import scaffold.time;

import core.string;
import core.time;
import core.timezone;
import core.definitions;
import core.locale;

import core.timezone;

class Date {

	this() {
		DateGet(_month, _day, _year);
	}

	this(Month month, uint day, uint year) {
		_month = month;
		_day = day;
		_year = year;
	}

	bool isLeapYear() {
		if (_year % 400 == 0) {
			return true;
		}
		else if (_year % 100 == 0) {
			return false;
		}
		else if (_year % 4 == 0) {
			return true;
		}
		return false;
	}

	Day dayOfWeek() {
		// magicNum is a number manipulated in order to determine the day of the week as part of the Gregorian calendar algorithm
		int yearNum = -1;
		
		// there's gotta be a better way to do this.
		if( (_year >= 1700 && _year <= 1799) || (_year >= 2100 && _year <= 2199) || (_year >= 2500 && _year <= 2599) ) {
			yearNum = 4;
		}
		else if( (_year >= 1800 && _year <= 1899) || (_year >= 2200 && _year <= 2299) || (_year >= 2600 && _year <= 2699) ) {
			yearNum = 2;
		}
		else if( (_year >= 1900 && _year <= 1999) || (_year >= 2300 && _year <= 2399) ){
			yearNum = 0;
		}
		else if( (_year >= 2000 && _year <= 2099) || (_year >= 2400 && _year <= 2499) ){
			yearNum = 6;
		}
		else {
			// year with unknown value
		}
		
		int yearDigitNum = (_year%100);
		int leapYearNum = yearDigitNum/4;
		int monthNum = -1;
		
		switch(_month){
			case Month.January:
			case Month.October:
			 	monthNum = 0;
				break;
			case Month.February:
			case Month.March:
			case Month.November:
				monthNum = 3;
				break;
			case Month.April:
			case Month.July:
				monthNum = 6;
				break;
			case Month.May:
				monthNum = 1;
				break;
			case Month.June:
				monthNum = 4;
				break;
			case Month.August:
				monthNum = 2;
				break;
			case Month.September:
			case Month.December:
				monthNum = 5;
				break;
			default: 
				break;
		}

		int dayNum = (yearNum + yearDigitNum + leapYearNum + monthNum + _day)%7;

		switch(dayNum){
			case 0:
				return Day.Sunday;
			case 1:
				return Day.Monday;
			case 2:
				return Day.Tuesday;
			case 3:
				return Day.Wednesday;
			case 4:
				return Day.Thursday;
			case 5:
				return Day.Friday;
			case 6:
				return Day.Saturday;
			default:
				break;
		}

		assert(0, "Error: Unable to determine the day of week");
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

	static Date Local(TimeZone localTZ = null) {
		Date ret = new Date();

		if (localTZ is null) {
			localTZ = new TimeZone();
		}

		Time time = Time.Now();
		long micros = time.microseconds;
		micros += localTZ.utcOffset;
		if (micros < 0) {
			// subtract a day
			if (ret._day == 1) {
				if (ret._month == Month.January) {
					ret._year--;
					ret._month = Month.December;
				}
				else {
					ret._month--;
				}
				switch (ret._month) {
					case Month.January:
					case Month.March:
					case Month.May:
					case Month.July:
					case Month.August:
					case Month.October:
					case Month.December:
						ret._day = 31;
						break;
					case Month.February:
						if (ret.isLeapYear) {
							ret._day = 29;
						}
						else {
							ret._day = 28;
						}
						break;
					default:
						ret._day = 30;
						break;
				}
			}
			else {
				ret._day--;
			}
		}
		return ret;
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
