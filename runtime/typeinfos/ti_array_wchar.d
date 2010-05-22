/*
 * ti_array_wchar.d
 *
 * This module implements the TypeInfo for wchar[]
 *
 */

module runtime.typeinfos.ti_array_wchar;

import runtime.typeinfos.ti_array;

class TypeInfo_Au : ArrayInfo!("wchar") { }
