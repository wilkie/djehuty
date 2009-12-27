module specs.core.time;

import testing.support;

import core.time;

describe time() {
	describe creation() {
		it should_have_sane_defaults() {
			auto t = new Time();
			should(t.micros == 0);
		}

		it should_handle_zero_milliseconds() {
			auto t = new Time(0);
			should(t.micros == 0);
		}

		it should_handle_positive_milliseconds() {
			auto t = new Time(1234);
			should(t.micros == 1234000);
		}

		it should_handle_negative_milliseconds() {
			auto t = new Time(-1234);
			should(t.micros == -1234000);
		}

		it should_handle_hours_minutes_seconds() {
			auto t = new Time(1, 2, 3);
			should(t.micros == 3723000000);
		}

		it should_handle_hours_minutes_seconds_milliseconds() {
			auto t = new Time(1, 2, 3, 4);
			should(t.micros == 3723004000);
		}

		it should_handle_negative_everything() {
			auto t = new Time(-1, -2, -3, -4);
			should(t.micros == -3723004000);
		}
	}

	describe Now() {
		it should_return_a_new_time() {
			auto n = Time.Now();
			shouldNot(cast(Time)n is null);
		}
	}

	describe hour() {
		it should_handle_zero_time() {
			auto t = new Time(0);
			should(t.hour() == 0);
		}

		it should_handle_positive_time() {
			auto t = new Time(12345678);
			should(t.hour() == 3);
		}

		it should_handle_negative_time() {
			auto t = new Time(-12345678);
			should(t.hour() == -3);
		}
	}

	describe minute() {
		it should_handle_zero_time() {
			auto t = new Time(0);
			should(t.minute() == 0);
		}

		it should_handle_positive_time() {
			auto t = new Time(12345678);
			should(t.minute() == 25);
		}

		it should_handle_negative_time() {
			auto t = new Time(-12345678);
			should(t.minute() == -25);
		}
	}

	describe second() {
		it should_handle_zero_time() {
			auto t = new Time(0);
			should(t.second() == 0);
		}

		it should_handle_positive_time() {
			auto t = new Time(12345678);
			should(t.second() == 45);
		}

		it should_handle_negative_time() {
			auto t = new Time(-12345678);
			should(t.second() == -45);
		}
	}

	describe millisecond() {
		it should_handle_zero_time() {
			auto t = new Time(0);
			should(t.millisecond() == 0);
		}

		it should_handle_positive_time() {
			auto t = new Time(12345678);
			should(t.millisecond() == 678);
		}

		it should_handle_negative_time() {
			auto t = new Time(-12345678);
			should(t.millisecond() == -678);
		}
	}

	describe fromMilliseconds() {
		it should_handle_zero_milliseconds() {
			auto t = new Time();
			t.fromMilliseconds(0);
			should(t.micros == 0);
		}

		it should_handle_positive_milliseconds() {
			auto t = new Time();
			t.fromMilliseconds(1234);
			should(t.micros == 1234000);
		}

		it should_handle_negative_milliseconds() {
			auto t = new Time();
			t.fromMilliseconds(-1234);
			should(t.micros == -1234000);
		}
	}

	describe fromMicroseconds() {
		it should_handle_zero_microseconds() {
			auto t = new Time();
			t.fromMicroseconds(0);
			should(t.micros == 0);
		}

		it should_handle_positive_microseconds() {
			auto t = new Time();
			t.fromMicroseconds(1234);
			should(t.micros == 1234);
		}

		it should_handle_negative_microseconds() {
			auto t = new Time();
			t.fromMicroseconds(-1234);
			should(t.micros == -1234);
		}
	}

	describe comparators() {
		it should_handle_equal_times() {
			auto a = new Time(1234);
			auto b = new Time(1234);
			shouldNot(a < b);
			should(a == b);
			shouldNot(a > b);
		}

		it should_handle_unequal_times() {
			auto a = new Time(-1234);
			auto b = new Time(1234);
			should(a < b);
			shouldNot(a == b);
			shouldNot(a > b);
		}
	}

	describe toString() {
		it should_handle_zero_time() {
			auto t = new Time(0);
			should(t.toString() == "00:00:00.000");
		}

		it should_handle_some_microseconds() {
			auto t = new Time();
			t.fromMicroseconds(123456);
			should(t.toString() == "00:00:00.123");
		}

		it should_handle_some_milliseconds() {
			auto t = new Time(123);
			should(t.toString() == "00:00:00.123");
		}

		it should_handle_hours_minutes_seconds() {
			auto t = new Time(10, 2, 30);
			should(t.toString() == "10:02:30.000");
		}

		it should_handle_everything() {
			auto t = new Time(12345678);
			should(t.toString() == "03:25:45.678");
		}

		it should_handle_negative_time() {
			auto t = new Time(-12345678);
			should(t.toString() == "-03:25:45.678");
		}
	}

	describe opAdd() {
		it should_work() {
			auto a = new Time(1000);
			auto b = new Time(234);
			auto c = a + b;
			should(c.micros == 1234000);
		}
	}

	describe opSub() {
		it should_work() {
			auto a = new Time(234);
			auto b = new Time(1234);
			auto c = a - b;
			should(c.micros == -1000000);
		}
	}

	describe opAddAssign() {
		it should_work() {
			auto a = new Time(1000);
			auto b = new Time(234);
			a += b;
			should(a.micros == 1234000);
		}
	}

	describe opSubAssign() {
		it should_work() {
			auto a = new Time(234);
			auto b = new Time(1234);
			a -= b;
			should(a.micros == -1000000);
		}
	}
}

