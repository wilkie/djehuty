module specs.core.date;

import core.date;

describe date() {
	describe creation() {
		it should_create_with_no_date_given() {
			Date d = new Date();
			shouldNot(d is null);
			should(d.year == 2010);
		}
		it should_create_given_date() {
			Date d = new Date(Month.January, 1, 2010);
			shouldNot(d is null);
			should(d.Month == Month.January);
			should(d.year == 2010);
			should(d.day == 1);
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
			should(d.month == Month.January);
		}

		it should_set_the_month_value() {
			Date d = new Date(Month.January, 1, 2010);
			d.month = Month.March;
			should(d.month == Month.March);
		}
	}
}
