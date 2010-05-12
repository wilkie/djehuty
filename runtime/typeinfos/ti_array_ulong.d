/*
 * ti_array_ulong.d
 *
 * This module implements the TypeInfo for ulong[]
 *
 */

module runtime.typeinfos.ti_array_ulong;

import runtime.typeinfos.ti_array;

class TypeInfo_Am : ArrayInfo!("ulong") { }
