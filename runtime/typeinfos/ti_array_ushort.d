/*
 * ti_array_ushort.d
 *
 * This module implements the TypeInfo for ushort[]
 *
 */

module runtime.typeinfos.ti_array_ushort;

import runtime.typeinfos.ti_array;

class TypeInfo_At : ArrayInfo!("ushort") { }
