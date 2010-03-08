/*
 * ti_array_dchar.d
 *
 * This module implements the TypeInfo for dchar[]
 *
 */

module runtime.typeinfo.ti_array_dchar;

import runtime.typeinfo.ti_array;

class TypeInfo_Aw : ArrayInfo!("dchar") { }
