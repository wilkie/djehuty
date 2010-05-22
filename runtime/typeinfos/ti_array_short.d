/*
 * ti_array_short.d
 *
 * This module implements the TypeInfo for short[]
 *
 */

module runtime.typeinfos.ti_array_short;

import runtime.typeinfos.ti_array;

class TypeInfo_As : ArrayInfo!("short") { }
