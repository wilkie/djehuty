/*
 * lua.d
 *
 * This module implements the bindings and routines to allow
 * utilization of the Lua scripting language in a D application.
 *
 * Author: Dave Wilkinson
 * Originated: May 15, 2009
 *
 */

 // lib: liblua5.1
 
 // Copyright for original set of files is reproduced wholely as follows:

 /******************************************************************************
 * Copyright (C) 1994-2008 Lua.org, PUC-Rio.  All rights reserved.
 *
 * Permission is hereby granted, free of charge, to any person obtaining
 * a copy of this software and associated documentation files (the
 * "Software"), to deal in the Software without restriction, including
 * without limitation the rights to use, copy, modify, merge, publish,
 * distribute, sublicense, and/or sell copies of the Software, and to
 * permit persons to whom the Software is furnished to do so, subject to
 * the following conditions:
 *
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
 * IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
 * CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
 * TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
 * SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 ******************************************************************************/

module scripting.lua;

// variadic
import core.format;

// The library's functions and definitions, offered by lua.h
struct LuaBindings {

	// configuration (luaconf.h)

	const char[] LUA_PATH	= "LUA_PATH";
	const char[] LUA_CPATH	= "LUA_CPATH";
	const char[] LUA_INIT	= "LUA_INIT";

	alias ptrdiff_t LUA_INTEGER;
	alias double LUA_NUMBER;

	// ---

	const char[] LUA_VERSION = "Lua 5.1";
	const char[] LUA_RELEASE = "Lua 5.1.4";
	const auto LUA_VERSION_NUM = 501;
	const char[] LUA_COPYRIGHT = "Copyright (C) 1994-2008 Lua.org, PUC-Rio";
	const char[] LUA_AUTHORS = "R. Ierusalimschy, L. H. de Figueiredo & W. Celes";

	// mark for precompiled code (`<esc>Lua')
	const char[] LUA_SIGNATURE = "\033Lua";

	// option for multiple returns in `lua_pcall' and `lua_call'
	const auto LUA_MULTRET = (-1);
	
	// pseudo-indices
	const auto LUA_REGISTRYINDEX	= (-10000);
	const auto LUA_ENVIRONINDEX		= (-10001);
	const auto LUA_GLOBALSINDEX		= (-10002);
	int lua_upvalueindex(int i) {
		return LUA_GLOBALSINDEX-(i);
	}

	// thread status; 0 is OK
	const auto LUA_YIELD		= 1;
	const auto LUA_ERRRUN		= 2;
	const auto LUA_ERRSYNTAX	= 3;
	const auto LUA_ERRMEM		= 4;
	const auto LUA_ERRERR		= 5;
	
	alias void* lua_State;

	typedef int function(lua_State *L) lua_CFunction;
	
	// functions that read/write blocks when loading/dumping Lua chunks
	typedef char* function(lua_State *L, void *ud, size_t *sz) lua_Reader;
	typedef int function(lua_State *L, void* p, size_t sz, void* ud) lua_Writer;
	
	// prototype for memory-allocation functions
	typedef void* function(void* ud, void* ptr, size_t osize, size_t nsize) lua_Alloc;

	// basic types
	enum : int {
		LUA_TNONE = -1,
		LUA_TNIL,
		LUA_TBOOLEAN,
		LUA_TLIGHTUSERDATA,
		LUA_TNUMBER,
		LUA_TSTRING,
		LUA_TTABLE,
		LUA_TFUNCTION,
		LUA_TUSERDATA,
		LUA_TTHREAD
	}
	
	// garbage collection options
	enum : int {
		LUA_GCSTOP,
		LUA_GCRESTART,
		LUA_GCCOLLECT,
		LUA_GCCOUNT,
		LUA_GCCOUNTB,
		LUA_GCSTEP,
		LUA_GCSETPAUSE,
		LUA_GCSETSTEPMUL
	}

	// minimum Lua stack available to a C function
	const auto LUA_MINSTACK	= 20;

	// type of numbers in Lua
	alias LUA_NUMBER lua_Number;

	// type for integer functions
	alias LUA_INTEGER lua_Integer;

	extern (C) {
		// state manipulation
		lua_State*		lua_newstate(lua_Alloc f, void* ud);
		void			lua_close(lua_State* L);
		lua_State*		lua_newthread(lua_State* L);

		lua_CFunction	lua_atpanic(lua_State* L, lua_CFunction panicf);

		// basic stack manipulation
		int				lua_gettop(lua_State* L);
		void			lua_settop(lua_State* L, int idx);
		void			lua_pushvalue(lua_State* L, int idx);
		void			lua_remove(lua_State* L, int idx);
		void			lua_insert(lua_State* L, int idx);
		void			lua_replace(lua_State* L, int idx);
		int				lua_checkstack(lua_State* L, int sz);

		void			lua_xmove(lua_State* from, lua_State* to, int n);

		// access functions (stack -> C)
		int				lua_isnumber(lua_State* L, int idx);
		int				lua_isstring(lua_State* L, int idx);
		int				lua_iscfunction(lua_State* L, int idx);
		int				lua_isuserdata(lua_State* L, int idx);
		int				lua_type(lua_State* L, int idx);
		char*			lua_typename(lua_State* L, int tp);

		int				lua_equal(lua_State* L, int idx1, int idx2);
		int				lua_rawequal(lua_State* L, int idx1, int idx2);
		int				lua_lessthan(lua_State* L, int idx1, int idx2);

		lua_Number		lua_tonumber(lua_State* L, int idx);
		lua_Integer		lua_tointeger(lua_State* L, int idx);
		int				lua_toboolean(lua_State* L, int idx);
		char*			lua_tolstring(lua_State* L, int idx, size_t *len);
		size_t			lua_objlen(lua_State* L, int idx);
		lua_CFunction	lua_tocfunction(lua_State* L, int idx);
		void*			lua_touserdata(lua_State* L, int idx);
		lua_State*		lua_tothread(lua_State* L, int idx);
		void*			lua_topointer(lua_State* L, int idx);

		// push functions (C -> stack)
		void			lua_pushnil(lua_State* L);
		void			lua_pushnumber(lua_State* L, lua_Number n);
		void			lua_pushinteger(lua_State* L, lua_Integer n);
		void			lua_pushlstring(lua_State* L, char* s, size_t l);
		void			lua_pushstring(lua_State* L, char* s);
		char*			lua_pushvfstring(lua_State* L, char* fmt, C.va_list argp);
		char*			lua_pushfstring(lua_State* L, char* fmt, ...);
		void			lua_pushcclosure(lua_State* L, lua_CFunction fn, int n);
		void			lua_pushboolean(lua_State* L, int b);
		void			lua_pushlightuserdata(lua_State* L, void* p);
		int				lua_pushthread(lua_State *L);

		// get functions (Lua -> stack)
		void			lua_gettable(lua_State *L, int idx);
		void			lua_getfield(lua_State *L, int idx, char* k);
		void			lua_rawget(lua_State *L, int idx);
		void			lua_rawgeti(lua_State *L, int idx, int n);
		void			lua_createtable(lua_State *L, int narr, int nrec);
		void*			lua_newuserdata(lua_State *L, size_t sz);
		int				lua_getmetatable(lua_State *L, int objindex);
		void			lua_getfenv(lua_State *L, int idx);

		// set funcctions (stack -> Lua)
		void			lua_settable(lua_State *L, int idx);
		void			lua_setfield(lua_State *L, int idx, char* k);
		void			lua_rawset(lua_State *L, int idx);
		void			lua_rawseti(lua_State *L, int idx, int n);
		int				lua_setmetatable(lua_State *L, int objindex);
		int				lua_setfenv(lua_State *L, int idx);

		// `load' and `call' functions (load and run Lua code)
		void			lua_call(lua_State *L, int nargs, int nresults);
		int				lua_pcall(lua_State *L, int nargs, int nresults, int errfunc);
		int				lua_cpcall(lua_State *L, lua_CFunction func, void* ud);
		int				lua_load(lua_State *L, lua_Reader reader, void* dt, char* chunkname);

		int				lua_dump(lua_State *L, lua_Writer writer, void* data);

		// coroutine functions
		int				lua_yield(lua_State *L, int nresults);
		int				lua_resume(lua_State *L, int narg);
		int				lua_status(lua_State *L);

		// garbage-collection function and options
		int				lua_gc(lua_State* L, int what, int data);

		// miscellaneous functions
		int				lua_error(lua_State *L);
		int				lua_next(lua_State *L, int idx);

		void			lua_concat(lua_State *L, int n);

		lua_Alloc		lua_getallocf(lua_State *L, void** ud);
		void			lua_setallocf(lua_State *L, lua_Alloc f, void* ud);

		// hack
		void			lua_setlevel(lua_State* from, lua_State* to);
	}

	// -- DEBUG API -- //
	const auto LUA_IDSIZE = 60;

	struct lua_Debug {
		int event;
		char *name;						/* (n) */
		char *namewhat;					/* (n) `global', `local', `field', `method' */
		char *what;						/* (S) `Lua', `C', `main', `tail' */
		char *source;					/* (S) */
		int currentline;				/* (l) */
		int nups;						/* (u) number of upvalues */
		int linedefined;				/* (S) */
		int lastlinedefined;			/* (S) */
		char short_src[LUA_IDSIZE];		/* (S) */

		/* private part */
		int i_ci;						/* active function */
	}
	
	// Event codes
	enum : int {
		LUA_HOOKCALL,
		LUA_HOOKRET,
		LUA_HOOKLINE,
		LUA_HOOKCOUNT,
		LUA_HOOKTAILRET
	}
	
	// Event masks
	enum : int {
		LUA_MASKCALL	= (1 << LUA_HOOKCALL),
		LUA_MASKRET		= (1 << LUA_HOOKRET),
		LUA_MASKLINE	= (1 << LUA_HOOKLINE),
		LUA_MASKCOUNT	= (1 << LUA_HOOKCOUNT)
	}

	// Functions to be called by the debuger in specific events
	typedef void function(lua_State* L, lua_Debug* ar) lua_Hook;

	extern (C) {
		int				lua_getstack(lua_State *L, int level, lua_Debug *ar);
		int				lua_getinfo(lua_State *L, char *what, lua_Debug *ar);
		char*			lua_getlocal(lua_State *L, lua_Debug *ar, int n);
		char*			lua_setlocal(lua_State *L, lua_Debug *ar, int n);
		char*			lua_getupvalue(lua_State *L, int funcindex, int n);
		char*			lua_setupvalue(lua_State *L, int funcindex, int n);

		int				lua_sethook(lua_State *L, lua_Hook func, int mask, int count);
		lua_Hook		lua_gethook(lua_State *L);
		int				lua_gethookmask(lua_State *L);
		int				lua_gethookcount(lua_State *L);
	}

	// -- USEFUL MACROS -- //

	void lua_newtable(lua_State* L) {
		lua_createtable(L, 0, 0);
	}

	/*void lua_register(lua_State* L, idx n, idx f) {
		lua_pushcfunction(L, f);
		lua_setglobal(L, (n));
	}*/

	//#define lua_register(L,n,f) (lua_pushcfunction(L, (f)), lua_setglobal(L, (n)))

	void lua_pushcfunction(lua_State* L, lua_CFunction f) {
		lua_pushcclosure(L, f, 0);
	}
	
	size_t lua_strlen(lua_State* L, int idx) {
		return lua_objlen(L, idx);
	}

	void lua_pop(lua_State* L, int idx) {
		lua_settop(L, -(idx)-1);
	}
	
	bool lua_isfunction(lua_State* L, int idx) {
		return lua_type(L, idx) == LUA_TFUNCTION;
	}

	bool lua_istable(lua_State* L, int idx) {
		return lua_type(L, idx) == LUA_TTABLE;
	}

	bool lua_islightuserdata(lua_State* L, int idx) {
		return lua_type(L, idx) == LUA_TLIGHTUSERDATA;
	}

	bool lua_isnil(lua_State* L, int idx) {
		return lua_type(L, idx) == LUA_TNIL;
	}

	bool lua_isboolean(lua_State* L, int idx) {
		return lua_type(L, idx) == LUA_TBOOLEAN;
	}

	bool lua_isthread(lua_State* L, int idx) {
		return lua_type(L, idx) == LUA_TTHREAD;
	}

	bool lua_isnone(lua_State* L, int idx) {
		return lua_type(L, idx) == LUA_TNONE;
	}

	bool lua_isnoneornil(lua_State* L, int idx) {
		return lua_type(L, idx) <= 0;
	}

	void lua_pushliteral(lua_State* L, char* s) {
		int len;
		char* ptr = s;
		while(*ptr != '\0') {
			len++;
			ptr++;
		}
		lua_pushlstring(L, s, len);
	}

	void lua_setglobal(lua_State* L, char* s)
	{
		lua_setfield(L, LUA_GLOBALSINDEX, s);
	}
	void lua_getglobal(lua_State* L, char* s)
	{
		lua_setfield(L, LUA_GLOBALSINDEX, s);
	}

	char* lua_tostring(lua_State* L, int idx)
	{
		return lua_tolstring(L, idx, null);
	}
}

// A Helper class
class LuaScript {
}