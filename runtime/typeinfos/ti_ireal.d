/*
 * ti_ireal.d
 *
 * This module implements the TypeInfo for the ireal type.
 *
 */

module runtime.typeinfos.ti_ireal;

import runtime.typeinfos.ti_real;

class TypeInfo_j : TypeInfo_e {
    char[] toString() {
		return "ireal";
	}
}

