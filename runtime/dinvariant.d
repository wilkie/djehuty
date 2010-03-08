/*
 * dinvariant.d
 *
 * This module implements the runtime calls that will execute invariant blocks
 * (contracts) within class definitions.
 *
 */

module runtime.dinvariant;

extern(C):

void _d_invariant(Object o) {
	// Make sure o is defined.
	assert(o !is null);

	// Get the main ClassInfo for o
	ClassInfo c = o.classinfo;

	do {
		// If the class has an invariant defined, execute it
		if(c.classInvariant !is null) {
			(*c.classInvariant)(o);
		}

		// Go up class hierarchy, return the next ClassInfo
		c = c.base;
	} while(c)
}
