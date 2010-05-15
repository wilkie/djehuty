/*
 * classinvariant.d
 *
 * This module implements the runtime calls that will execute invariant blocks
 * (contracts) within class definitions.
 *
 */

module runtime.classinvariant;

extern(C):

void _d_invariant(Object o) {
	// Make sure o is defined.
	assert(o !is null);

	// Get the main ClassInfo for o
	ClassInfo c = o.classinfo;

	do {
		// If the class has an invariant defined, execute it
		if(c.classInvariant !is null) {
			void delegate() inv;
			inv.ptr = cast(void*) o;
			inv.funcptr =  cast(void function()) c.classInvariant;
			inv();
		}

		// Go up class hierarchy, return the next ClassInfo
		c = c.base;
	} while(c !is null)
}
