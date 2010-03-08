/*
 * ti_array_ulong.d
 *
 * This module implements the TypeInfo for ulong[]
 *
 */

module runtime.typeinfo.ti_array_ulong;

import runtime.typeinfo.ti_array;

class TypeInfo_Am : ArrayInfo!("ulong") { }
