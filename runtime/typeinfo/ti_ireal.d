/*
 * ti_ireal.d
 *
 * This module implements the TypeInfo for the ireal type.
 *
 */

module mindrt.typeinfo.ti_ireal;

import mindrt.typeinfo.ti_real;

class TypeInfo_j : TypeInfo_e {
    char[] toString() {
		return "ireal";
	}
}

