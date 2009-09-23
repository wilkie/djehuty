/*
 * currency.d
 *
 * This module implements a data type for storing an amount of currency.
 *
 * Author: Dave Wilkinson
 * Originated: September 20th, 2009
 *
 */

module math.currency;

import core.locale;
import core.string;
import core.definitions;

import math.fixed;

class Currency : Fixed {
	this(long whole, long scale) {
		super(whole, scale);
	}

	// This function will provide a string for the currency value rounded to 2 decimal points
	override string toString() {
		return Locale.formatCurrency(_whole, _scale);
	}
}