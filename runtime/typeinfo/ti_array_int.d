/*
 * ti_array_int.d
 *
 * This module implements the TypeInfo for int[]
 *
 */

module runtime.typeinfo.ti_array_int;

import runtime.typeinfo.ti_array;

class TypeInfo_Ai : ArrayInfo!("int") { }
