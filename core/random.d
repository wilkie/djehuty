/*
 * random.d
 *
 * This module implements a random number generator.
 *
 * It is based upon the implementation by Steve Park and Dave Geyer. That is,
 * it is based upon a Lehmer random number generator. It returns a random
 * number distributed uniformly between 0.0 and 1.0.
 *
 * Author: Dave Wilkinson
 * Reference: Steve Park, Dave Geyer
 * Originated: May 18, 2009
 *
 */

module core.random;

import core.definitions;
import core.list;
import core.system;

// Description: This class represents a Random number generator.
class Random {

	// Description: This will set up a new random number generator and will seed
	//   with the system time.
	this() {
		this.seed();
	}

	// Description: This will set up a new random number generator and will seed it with the given seed.
	// seed: The seed to use with the generator.
	this(int seed) {
		this.seed(seed);
	}

	// Description: This will reseed the random number generator.
	// seed: The seed to use with the generator.
	void seed(int value) {
		_state = cast(uint)value;
	}

	// Description: This will retrieve the current state of the generator.
	// Returns: The state of the generator. (Reseed with this value to continue from the same position)
	int seed() {
		return _state;
	}

	uint next() {
		mutateState();
		return _state;
	}

	uint next(uint max) {
		return next() % max;
	}

	int next(int min, int max) {
		if (min >= max) { return min; }

		return (next() % (max - min)) + min;
	}

	ulong nextLong() {
		return (cast(uint)next() << 32) + cast(uint)next();
	}

	ulong nextLong(ulong max) {
		return nextLong() % max;
	}

	long nextLong(long min, long max) {
		if (min >= max) { return min; }

		return (nextLong() % (max - min)) + min;
	}

	bool nextBoolean() {
		return (next() % 1) != 0;
	}

	double nextDouble() {
		long foo = (cast(long)(next() >> (32-26)) << 27) + cast(long)(next() >> (32-27));
		return cast(double)foo / cast(double)(1L << 53);
	}

	float nextFloat() {
		return cast(float)(next() >> (32-24)) / cast(float)(1 << 24);
	}

	template choose(T) {
		static assert(IsIterable!(T), "Random.choose: " ~ T.stringof ~ " is not iterable.");
		IterableType!(T) choose(T list) {
			return list[cast(size_t)next(list.length)];
		}
	}

protected:
	const auto MODULUS		= 2147483647;
	const auto MULTIPLIER	= 48271;
	const auto CHECK		= 399268537;
	const auto A256			= 22925;
	const auto DEFAULT		= 123456789;

	uint _state = DEFAULT;

	void mutateState() {
		const uint Q = MODULUS / MULTIPLIER;
		const uint R = MODULUS % MULTIPLIER;
		uint t;

		t = MULTIPLIER * (_state % Q) - R * (_state / Q);
		if (t > 0) {
			_state = t;
		}
		else {
			_state = t + MODULUS;
		}
	}
}
