/*
 * This module holds the implementation of special vararg templates for D style var args.
 *
 * Provides the functions tango.core.Vararg expects to be present!
 */

module ldc.vararg;

// Check for the right compiler
version(LDC) {
    // OK
}
else {
    static assert(false, "This module is only valid for LDC");
}

alias void* va_list;

T va_arg(T)(ref va_list vp) {
    T* arg = cast(T*) vp;
    // ldc always aligns to size_t.sizeof in vararg lists
    vp = cast(va_list) ( cast(void*) vp + ( ( T.sizeof + size_t.sizeof - 1 ) & ~( size_t.sizeof - 1 ) ) );
    return *arg;
}
