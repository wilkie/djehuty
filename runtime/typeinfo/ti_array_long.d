/*
 * ti_array_long.d
 *
 * This module implements the TypeInfo for long[]
 *
 */

module runtime.typeinfo.ti_array_long;

import runtime.typeinfo.ti_array;

class TypeInfo_Al : ArrayInfo!("long") { }
