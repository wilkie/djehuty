/*
 * ti_array_byte.d
 *
 * This module implements the TypeInfo for a byte[]
 *
 */

module runtime.typeinfo.ti_array_byte;

import runtime.typeinfo.ti_array;

class TypeInfo_Ag : ArrayInfo!("byte") { }
