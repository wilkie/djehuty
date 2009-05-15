/*
 * lua.d
 *
 * This module implements a helper class and routines to allow
 * utilization of the Lua scripting language in a D application.
 *
 * Author: Dave Wilkinson
 * Originated: May 15, 2009
 *
 */

module scripting.lua;

// import bindings
import scripting.bindings.lua;

// common
import core.string;
import core.unicode;

// A Helper class
class LuaScript {

	this() {
		L = luaL_newstate();

	    luaopen_io(L); // provides io.*
	    luaopen_base(L);
	    luaopen_table(L);
	    luaopen_string(L);
	    luaopen_math(L);
	    luaopen_package(L);
	    luaL_openlibs(L);
	}

	void eval(String code) {
	}

	void eval(StringLiteral code) {
		eval(new String(code));
	}

	void evalFile(String filename) {
		char[] chrs = Unicode.toUtf8(filename.array) ~ "\0";

		int s = luaL_loadfile(L, chrs.ptr);

		if (s==0) {
			// execute Lua program
			s = lua_pcall(L, 0, LUA_MULTRET, 0);
		}

		if (s > 0) {
			// errors!
			String error = luaToString(-1);
		    lua_pop(L, 1); // remove error message
		}
	}

	void evalFile(StringLiteral filename) {
		evalFile(new String(filename));
	}

protected:
	lua_State* L;

	String luaToString(int numArg) {
		char* str = lua_tostring(L, numArg);

		int len;
		char* ptr = str;

		while (*ptr != '\0') {
			ptr++;
			len++;
		}

		char[] DStr = str[0..len];

		return new String(Unicode.toNative(DStr));
	}
}
