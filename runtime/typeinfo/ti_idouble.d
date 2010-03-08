/*
 * ti_idouble.d
 *
 * This module implements the TypeInfo for the idouble type.
 *
 */

module mindrt.typeinfo.ti_idouble;

import mindrt.typeinfo.ti_double;

class TypeInfo_p : TypeInfo_d {
    char[] toString() {
		return "idouble";
	}
}
