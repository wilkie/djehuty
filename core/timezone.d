/*
 * timezone.d
 *
 * This module implements the TimeZone class. This class can depict difference
 * timezones and can be used to translate Time into a localized value.
 *
 * Author: Dave Wilkinson
 * Originated: January 1st, 2010
 *
 */

module core.timezone;

import Scaffold = scaffold.time;

import core.definitions;
import core.string;

class TimeZone {
protected:

	string _name = "";
	string _utc = "";
	int _offset_in_minutes;

public:
	// Description: This will construct a TimeZone for the current location.
	this() {
		this(Scaffold.TimeZoneGet());
	}

	// Description: This will construct a specific TimeZone for a specific
	//   timezone name or a string containing a custom timezone.
	// name: A full name, or "GMT+h:mm" or "GMT-h:mm" where h and mm
	//   represent the hour and minutes from GMT respectively.
	this(string name) {
		_name = name;
		if (name[0..3] == "UTC") {
			_utc = name;
			string foo = name[3..$];
			int pos = foo.find(":");
			if (pos < 0) { pos = foo.length; }
			foo = foo[0..pos];
			int diff_hr;
			int diff_min;
			foo.nextInt(diff_hr);
			foo = name[3+pos+1..$];
			foo.nextInt(diff_min);
			_offset_in_minutes = (diff_hr * 60) + diff_min;
		}
		else {
			switch(name) {
				case "Eastern Standard Time":
					_offset_in_minutes = -(5 * 60);
					break;
				case "Pacific Standard Time":
					_offset_in_minutes = -(8 * 60);
					break;
				case "Coordinated Universal Time":
				case "Temps Universel Coordonné":
				case "Greenwich Mean Time":
					_offset_in_minutes = 0;
					break;
				default:
					break;
			}
			int diff_hr = _offset_in_minutes / 60;
			int diff_min = _offset_in_minutes % 60;
			_utc = "UTC" ~ toStr(diff_hr) ~ ":" ~ (diff_min < 10 ? "0" : "") ~ toStr(diff_min);
		}
	}

	string name() {
		return _name;
	}

	string utcName() {
		return _utc;
	}

	string toString() {
		return utcName;
	}

	// Description: This will return the offset from UTC in microseconds.
	long utcOffset() {
		return cast(long)_offset_in_minutes * 60L * 1000000L;
	}
}


