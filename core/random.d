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

import platform.imports;
mixin(PlatformGenericImport!("definitions"));
mixin(PlatformScaffoldImport!());

// Description: This class represents a Random number generator.
class Random {

	// Description: This will set up a new random number generator and will seed it with the given seed.
	// seed: The seed to use with the generator.
	this(long seed = -1) {
		setSeed(seed);
	}

	// Description: This will reseed the random number generator.
	// seed: The seem to use with the generator.
	void setSeed(long seed) {
		if (seed < 0) {
			seed = Scaffold.TimeGet();
		}
		state = seed;
	}

	// Description: This will retrieve the current state of the generator.
	// Returns: The state of the generator. (Reseed with this value to continue from the same position)
	long getSeed() {
		return state;
	}

	double nextDouble() {
		mutateState();
		return cast(double)state / cast(double)MODULUS;
	}

	long next() {
		mutateState();
		return state;
	}

	long next(long max) {
		if (max < 0) { return 0; }
		return next() % max;
	}

	long next(long min, long max) {
		if (max < 0) { return 0; }
		if (min < 0) { return 0; }
		if (min > max) { max = min; }

		return (next() % (max - min)) + min;
	}

protected:
	const auto MODULUS		= 2147483647;
	const auto MULTIPLIER	= 48271;
	const auto CHECK		= 399268537;
	const auto A256			= 22925;
	const auto DEFAULT		= 123456789;

	long state = DEFAULT;

	void mutateState() {
		const long Q = MODULUS / MULTIPLIER;
		const long R = MODULUS % MULTIPLIER;
		long t;

		t = MULTIPLIER * (state % Q) - R * (state / Q);
		if (t > 0) {
			state = t;
		}
		else {
			state = t + MODULUS;
		}
	}
}