/*
** $Id: lua.h,v 1.218.1.7 2012/01/13 20:36:20 roberto Exp $
** Lua - An Extensible Extension Language
** Lua.org, PUC-Rio, Brazil (http://www.lua.org)
** See Copyright Notice at the end of this file
*/

module liblua51.lua;

import std.c.stdarg;
import std.c.stddef;
import std.string;

import liblua51.luaconf;

enum LUA_VERSION =     "Lua 5.1";
enum LUA_RELEASE =     "Lua 5.1.5";
enum LUA_VERSION_NUM = 501;
enum LUA_COPYRIGHT =   "Copyright (C) 1994-2012 Lua.org, PUC-Rio";
enum LUA_AUTHORS =     "R. Ierusalimschy, L. H. de Figueiredo & W. Celes";

/* mark for precompiled code (`<esc>Lua') */
enum LUA_SIGNATURE = "\033Lua";

/* option for multiple returns in `lua_pcall' and `lua_call' */
enum LUA_MULTRET = -1;

/*
** pseudo-indices
*/
enum LUA_REGISTRYINDEX =   -10000;
enum LUA_ENVIRONINDEX =    -10001;
enum LUA_GLOBALSINDEX =    -10002;
int lua_upvalueindex(int i) { return LUA_GLOBALSINDEX - i; }

/* thread status; 0 is OK */
enum LUA_YIELD = 1;
enum LUA_ERRRUN = 2;
enum LUA_ERRSYNTAX = 3;
enum LUA_ERRMEM = 4;
enum LUA_ERRERR = 5;

struct lua_State;

alias int function(lua_State *L) lua_CFunction;

/*
** functions that read/write blocks when loading/dumping Lua chunks
*/
alias const char * function(lua_State *L, void *ud, size_t *sz) lua_Reader;

alias int function(lua_State *L, const void *p, size_t sz, void *ud) lua_Writer;

/*
** prototype for memory-allocation functions
*/
alias void * function(void *ud, void *ptr, size_t osize, size_t nsize) lua_Alloc;

/*
** basic types
*/
enum LUA_TNONE =         -1;

enum LUA_TNIL =           0;
enum LUA_TBOOLEAN =       1;
enum LUA_TLIGHTUSERDATA = 2;
enum LUA_TNUMBER =        3;
enum LUA_TSTRING =        4;
enum LUA_TTABLE =         5;
enum LUA_TFUNCTION =      6;
enum LUA_TUSERDATA =      7;
enum LUA_TTHREAD =        8;

/* minimum Lua stack available to a C function */
enum LUA_MINSTACK = 20;

/*
** generic extra include file
*/
// #if defined(LUA_USER_H)
// #include LUA_USER_H
// #endif

/* type of numbers in Lua */
alias LUA_NUMBER lua_Number;

/* type for integer functions */
alias LUA_INTEGER lua_Integer;

/*
** state manipulation
*/
extern(C) lua_State *lua_newstate(lua_Alloc f, void *ud);
extern(C) void lua_close(lua_State *L);
extern(C) lua_State *lua_newthread(lua_State *L);

extern(C) lua_CFunction lua_atpanic(lua_State *L, lua_CFunction panicf);

/*
** basic stack manipulation
*/
extern(C) int   lua_gettop(lua_State *L);
extern(C) void  lua_settop(lua_State *L, int idx);
extern(C) void  lua_pushvalue(lua_State *L, int idx);
extern(C) void  lua_remove(lua_State *L, int idx);
extern(C) void  lua_insert(lua_State *L, int idx);
extern(C) void  lua_replace(lua_State *L, int idx);
extern(C) int   lua_checkstack(lua_State *L, int sz);

extern(C) void lua_xmove(lua_State *from, lua_State *to, int n);

/*
** access functions (stack -> C)
*/

extern(C) int             lua_isnumber(lua_State *L, int idx);
extern(C) int             lua_isstring(lua_State *L, int idx);
extern(C) int             lua_iscfunction(lua_State *L, int idx);
extern(C) int             lua_isuserdata(lua_State *L, int idx);
extern(C) int             lua_type(lua_State *L, int idx);
extern(C) const char     *lua_typename(lua_State *L, int tp);

extern(C) int            lua_equal(lua_State *L, int idx1, int idx2);
extern(C) int            lua_rawequal(lua_State *L, int idx1, int idx2);
extern(C) int            lua_lessthan(lua_State *L, int idx1, int idx2);

extern(C) lua_Number      lua_tonumber(lua_State *L, int idx);
extern(C) lua_Integer     lua_tointeger(lua_State *L, int idx);
extern(C) int             lua_toboolean(lua_State *L, int idx);
extern(C) const char     *lua_tolstring(lua_State *L, int idx, size_t *len);
extern(C) size_t          lua_objlen(lua_State *L, int idx);
extern(C) lua_CFunction   lua_tocfunction(lua_State *L, int idx);
extern(C) void           *lua_touserdata(lua_State *L, int idx);
extern(C) lua_State      *lua_tothread(lua_State *L, int idx);
extern(C) const void     *lua_topointer(lua_State *L, int idx);

/*
** push functions (C -> stack)
*/
extern(C) void  lua_pushnil(lua_State *L);
extern(C) void  lua_pushnumber(lua_State *L, lua_Number n);
extern(C) void  lua_pushinteger(lua_State *L, lua_Integer n);
extern(C) void  lua_pushlstring(lua_State *L, const char *s, size_t l);
extern(C) void  lua_pushstring(lua_State *L, const char *s);
extern(C) const char *lua_pushvfstring(lua_State *L, const char *fmt,
                                                      va_list argp);
extern(C) const char *lua_pushfstring(lua_State *L, const char *fmt, ...);
extern(C) void  lua_pushcclosure(lua_State *L, lua_CFunction fn, int n);
extern(C) void  lua_pushboolean(lua_State *L, int b);
extern(C) void  lua_pushlightuserdata(lua_State *L, void *p);
extern(C) int   lua_pushthread(lua_State *L);

/*
** get functions (Lua -> stack)
*/
extern(C) void  lua_gettable(lua_State *L, int idx);
extern(C) void  lua_getfield(lua_State *L, int idx, const char *k);
extern(C) void  lua_rawget(lua_State *L, int idx);
extern(C) void  lua_rawgeti(lua_State *L, int idx, int n);
extern(C) void  lua_createtable(lua_State *L, int narr, int nrec);
extern(C) void *lua_newuserdata(lua_State *L, size_t sz);
extern(C) int   lua_getmetatable(lua_State *L, int objindex);
extern(C) void  lua_getfenv(lua_State *L, int idx);

/*
** set functions (stack -> Lua)
*/
extern(C) void  lua_settable(lua_State *L, int idx);
extern(C) void  lua_setfield(lua_State *L, int idx, const char *k);
extern(C) void  lua_rawset(lua_State *L, int idx);
extern(C) void  lua_rawseti(lua_State *L, int idx, int n);
extern(C) int   lua_setmetatable(lua_State *L, int objindex);
extern(C) int   lua_setfenv(lua_State *L, int idx);

/*
** `load' and `call' functions (load and run Lua code)
*/
extern(C) void  lua_call(lua_State *L, int nargs, int nresults);
extern(C) int   lua_pcall(lua_State *L, int nargs, int nresults, int errfunc);
extern(C) int   lua_cpcall(lua_State *L, lua_CFunction func, void *ud);
extern(C) int   lua_load(lua_State *L, lua_Reader reader, void *dt, const char *chunkname);

extern(C) int lua_dump(lua_State *L, lua_Writer writer, void *data);

/*
** coroutine functions
*/
extern(C) int  lua_yield(lua_State *L, int nresults);
extern(C) int  lua_resume(lua_State *L, int narg);
extern(C) int  lua_status(lua_State *L);

/*
** garbage-collection function and options
*/

enum LUA_GCSTOP =       0;
enum LUA_GCRESTART =    1;
enum LUA_GCCOLLECT =    2;
enum LUA_GCCOUNT =      3;
enum LUA_GCCOUNTB =     4;
enum LUA_GCSTEP =       5;
enum LUA_GCSETPAUSE =   6;
enum LUA_GCSETSTEPMUL = 7;

extern(C) int lua_gc(lua_State *L, int what, int data);

/*
** miscellaneous functions
*/

extern(C) int   lua_error(lua_State *L);

extern(C) int   lua_next(lua_State *L, int idx);

extern(C) void  lua_concat(lua_State *L, int n);

extern(C) lua_Alloc lua_getallocf(lua_State *L, void **ud);
extern(C) void lua_setallocf(lua_State *L, lua_Alloc f, void *ud);

/* 
** ===============================================================
** some useful macros
** ===============================================================
*/



void lua_pop(lua_State *L, int n) { lua_settop(L, -n-1); }

void lua_newtable(lua_State *L) { lua_createtable(L, 0, 0); }

void lua_register(lua_State *L, const char *n, lua_CFunction f) {
	lua_pushcfunction(L, f);
	lua_setglobal(L, n);
}

void lua_pushcfunction(lua_State *L, lua_CFunction f) {
	lua_pushcclosure(L, f, 0);
}

alias lua_strlen = lua_objlen;

bool lua_isfunction(lua_State *L, int n) {
	return lua_type(L, n) == LUA_TFUNCTION;
}
bool lua_istable(lua_State *L, int n) {
	return lua_type(L, n) == LUA_TTABLE;
}
bool lua_islightuserdata(lua_State *L, int n) {
	return lua_type(L, n) == LUA_TLIGHTUSERDATA;
}
bool lua_isnil(lua_State *L, int n) {
	return lua_type(L, n) == LUA_TNIL;
}
bool lua_isboolean(lua_State *L, int n) {
	return lua_type(L, n) == LUA_TBOOLEAN;
}
bool lua_isthread(lua_State *L, int n) {
	return lua_type(L, n) == LUA_TTHREAD;
}
bool lua_isnone(lua_State *L, int n) {
	return lua_type(L, n) == LUA_TNONE;
}
bool lua_isnoneornil(lua_State *L, int n) {
	return lua_type(L, n) <= 0;
}

void lua_pushliteral(lua_State *L, string s) {
	lua_pushlstring(L, toStringz(s), s.length);
}

void lua_setglobal(lua_State *L, const char *s) {
	return lua_setfield(L, LUA_GLOBALSINDEX, s);
}
void lua_getglobal(lua_State *L, const char *s) {
	return lua_getfield(L, LUA_GLOBALSINDEX, s);
}

const char *lua_tostring(lua_State *L, int i) {
	return lua_tolstring(L, i, null);
}

/*
** compatibility macros and functions
*/

// alias lua_open = luaL_newstate;

void lua_getregistry(lua_State *L) { lua_pushvalue(L, LUA_REGISTRYINDEX); }

int lua_getgccount(lua_State *L) { return lua_gc(L, LUA_GCCOUNT, 0); }

alias lua_Chunkreader = lua_Reader;
alias lua_Chunkwriter = lua_Writer;


/* hack */
extern(C) void lua_setlevel(lua_State *from, lua_State *to);

/*
** {======================================================================
** Debug API
** =======================================================================
*/

/*
** Event codes
*/
enum LUA_HOOKCALL =    0;
enum LUA_HOOKRET =     1;
enum LUA_HOOKLINE =    2;
enum LUA_HOOKCOUNT =   3;
enum LUA_HOOKTAILRET = 4;

/*
** Event masks
*/
enum LUA_MASKCALL =  (1 << LUA_HOOKCALL);
enum LUA_MASKRET =   (1 << LUA_HOOKRET);
enum LUA_MASKLINE =  (1 << LUA_HOOKLINE);
enum LUA_MASKCOUNT = (1 << LUA_HOOKCOUNT);

/* Functions to be called by the debuger in specific events */
alias void function(lua_State *L, lua_Debug *ar) lua_Hook;

extern(C) int lua_getstack(lua_State *L, int level, lua_Debug *ar);
extern(C) int lua_getinfo(lua_State *L, const char *what, lua_Debug *ar);
extern(C) const char *lua_getlocal(lua_State *L, const lua_Debug *ar, int n);
extern(C) const char *lua_setlocal(lua_State *L, const lua_Debug *ar, int n);
extern(C) const char *lua_getupvalue(lua_State *L, int funcindex, int n);
extern(C) const char *lua_setupvalue(lua_State *L, int funcindex, int n);

extern(C) int lua_sethook(lua_State *L, lua_Hook func, int mask, int count);
extern(C) lua_Hook lua_gethook(lua_State *L);
extern(C) int lua_gethookmask(lua_State *L);
extern(C) int lua_gethookcount(lua_State *L);

struct lua_Debug {
  int event;
  const char *name;	/* (n) */
  const char *namewhat;	/* (n) `global', `local', `field', `method' */
  const char *what;	/* (S) `Lua', `C', `main', `tail' */
  const char *source;	/* (S) */
  int currentline;	/* (l) */
  int nups;		/* (u) number of upvalues */
  int linedefined;	/* (S) */
  int lastlinedefined;	/* (S) */
  char short_src[LUA_IDSIZE]; /* (S) */
  /* private part */
  int i_ci;  /* active function */
};

/* }====================================================================== */

/******************************************************************************
* Copyright (C) 1994-2012 Lua.org, PUC-Rio.  All rights reserved.
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
