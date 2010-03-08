/*
 * ti_array_idouble.d
 *
 * This module implements the TypeInfo for a idouble[]
 *
 */

module mindrt.typeinfo.ti_array_idouble;

import mindrt.typeinfo.ti_array_double;

class TypeInfo_Ap : TypeInfo_Ad {
	char[] toString() {
		return "idouble[]";
	}

	TypeInfo next() {
		return typeid(idouble);
	}
}
