/*
 * ti_array_ushort.d
 *
 * This module implements the TypeInfo for ushort[]
 *
 */

module runtime.typeinfo.ti_array_ushort;

import runtime.typeinfo.ti_array;

class TypeInfo_At : ArrayInfo!("ushort") { }
