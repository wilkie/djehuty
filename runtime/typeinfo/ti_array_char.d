/*
 * ti_array_char.d
 *
 * This module implements the TypeInfo for a char[]
 *
 */

module runtime.typeinfo.ti_array_char;

import runtime.typeinfo.ti_array;

class TypeInfo_Aa : ArrayInfo!("char") { }
