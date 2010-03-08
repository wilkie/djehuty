/*
 * ti_array_wchar.d
 *
 * This module implements the TypeInfo for wchar[]
 *
 */

module runtime.typeinfo.ti_array_wchar;

import runtime.typeinfo.ti_array;

class TypeInfo_Au : ArrayInfo!("wchar") { }
