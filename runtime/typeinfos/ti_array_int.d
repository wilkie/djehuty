/*
 * ti_array_int.d
 *
 * This module implements the TypeInfo for int[]
 *
 */

module runtime.typeinfos.ti_array_int;

import runtime.typeinfos.ti_array;

class TypeInfo_Ai : ArrayInfo!("int") { }
