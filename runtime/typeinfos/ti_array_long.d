/*
 * ti_array_long.d
 *
 * This module implements the TypeInfo for long[]
 *
 */

module runtime.typeinfos.ti_array_long;

import runtime.typeinfos.ti_array;

class TypeInfo_Al : ArrayInfo!("long") { }
