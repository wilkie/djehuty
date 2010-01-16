module specs.core.date;

import core.date;

describe date() {
	describe creation() {
		it should_create_with_current_date() {
			Date d = new Date();
			shouldNot(d is null);
			should(d.year == 2010);
		}
		it should_create_given_date() {
			Date d = new Date(Month.January, 1, 2010);
			shouldNot(d is null);
			should(d.month() == Month.January);
			should(d.year() == 2010);
			should(d.day() == 1);
		}
	}
	
	describe dayOfWeek() {
		it should_return_the_day_of_the_week() {
			Date d = new Date(Month.January, 1, 2010);
			should(d.dayOfWeek() == Day.Friday);
		}
	}

	describe monthMethods() {
		it should_return_the_month_value() {
			Date d = new Date(Month.January, 1, 2010);
			should(d.month() == Month.January);
		}

		it should_set_the_month_value() {
			Date d = new Date(Month.January, 1, 2010);
			d.month(Month.March);
			should(d.month() == Month.March);
		}
	}

	describe dayMethods() {
		it should_return_the_day_value() {
			Date d = new Date(Month.January, 1, 2010);
			should(d.day() == 1);
		}

		it should_set_the_day_value() {
			Date d = new Date(Month.January, 1, 2010);
			d.day(21);
			should(d.day() == 21);
		}
	}
	
	describe yearMethods() {
		it should_return_the_year_value() {
			Date d = new Date(Month.January, 1, 2010);
			should(d.year() == 2010);
		}

		it should_set_the_year_value() {
			Date d = new Date(Month.January, 1, 2010);
			d.year(2011);
			should(d.year() == 2011);
		}
	}

}
