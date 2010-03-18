/*
 * ti_array_short.d
 *
 * This module implements the TypeInfo for short[]
 *
 */

module runtime.typeinfo.ti_array_short;

import runtime.typeinfo.ti_array;

class TypeInfo_As : ArrayInfo!("short") { }
