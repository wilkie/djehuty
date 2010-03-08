/*
 * ti_ifloat.d
 *
 * This module implements the TypeInfo for the ifloat type.
 *
 */

module mindrt.typeinfo.ti_ifloat;

import mindrt.typeinfo.ti_float;

class TypeInfo_o : TypeInfo_f {
    char[] toString() {
		return "ifloat";
	}
}
