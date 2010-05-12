/*
 * ti_array_char.d
 *
 * This module implements the TypeInfo for a char[]
 *
 */

module runtime.typeinfos.ti_array_char;

import runtime.typeinfos.ti_array;

class TypeInfo_Aa : ArrayInfo!("char") { }
