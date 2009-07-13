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
import binding.lua;

// common
import core.string;
import core.unicode;

// print
import console.main;

// A Helper class
class LuaScript {

	alias lua_CFunction Callback;

	this() {
		initialize();
	}

	~this() {
		uninitialize();
	}

	void initialize() {
		uninitialize();

		L = luaL_newstate();
		luaL_openlibs(L);
	}

	void uninitialize() {
		if (L !is null) {
			lua_close(L);
			L = null;
		}
	}

	void eval(String code) {
	}

	void eval(string code) {
		eval(new String(code));
	}

	// Description: This function will map a function of the type int(LuaBindings.lua_State) to be called whenever the function specified by the second parameter is called within a Lua script.
	// func: The callback function to execute.
	// functionName: The name of the function within the Lua script to map.
	void registerFunction(Callback func, String functionName) {
		char[] funcStr = functionName.toUtf8() ~ "\0";
		//lua_pushcfunction(L, func);
		//lua_setglobal(L, funcStr.ptr);
	}

	// Description: This function will map a function of the type int(LuaBindings.lua_State) to be called whenever the function specified by the second parameter is called within a Lua script.
	// func: The callback function to execute.
	// functionName: The name of the function within the Lua script to map.
	void registerFunction(Callback func, string functionName) {
		registerFunction(func, new String(functionName));
	}

	// Description: This function will evaluate the Lua script located at the path provided.
	// filename: A Lua script to evaluate.
	void evalFile(String filename) {

		char[] chrs = Unicode.toUtf8(filename.array) ~ "\0";

		int s = luaL_loadfile(L, chrs.ptr);

		if (s == 0) {
			// execute Lua program
			s = lua_pcall(L, 0, LUA_MULTRET, 0);
		}

		if (s > 0) {
			// errors!
			String error = luaToString(-1);
			Console.setColor(fgColor.BrightRed);
			Console.putln(error.array);
			Console.setColor(fgColor.White);
			lua_settop(L, 0); // remove error message
		}
	}

	// Description: This function will evaluate the Lua script located at the path provided.
	// filename: A Lua script to evaluate.
	void evalFile(string filename) {
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

		return new String(DStr);
	}
}
