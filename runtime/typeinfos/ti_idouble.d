/*
 * ti_idouble.d
 *
 * This module implements the TypeInfo for the idouble type.
 *
 */

module runtime.typeinfos.ti_idouble;

import runtime.typeinfos.ti_double;

class TypeInfo_p : TypeInfo_d {
    char[] toString() {
		return "idouble";
	}
}
