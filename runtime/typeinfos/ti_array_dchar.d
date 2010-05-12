/*
 * ti_array_dchar.d
 *
 * This module implements the TypeInfo for dchar[]
 *
 */

module runtime.typeinfos.ti_array_dchar;

import runtime.typeinfos.ti_array;

class TypeInfo_Aw : ArrayInfo!("dchar") { }
