/*
** $Id: luaconf.h,v 1.82.1.7 2008/02/11 16:25:08 roberto Exp $
** Configuration file for Lua
** See Copyright Notice in lua.h
*/

module liblua51.luaconf;

import std.c.stdio;

/*
@@ LUA_INTEGER is the integral type used by lua_pushinteger/lua_tointeger.
** CHANGE that if ptrdiff_t is not adequate on your machine. (On most
** machines, ptrdiff_t gives a good choice between int or long.)
*/
alias LUA_INTEGER = ptrdiff_t;

/*
@@ LUA_IDSIZE gives the maximum size for the description of the source
@* of a function in debug information.
** CHANGE it if you want a different size.
*/
enum LUA_IDSIZE = 60;

/*
@@ LUAL_BUFFERSIZE is the buffer size used by the lauxlib buffer system.
*/
enum LUAL_BUFFERSIZE = BUFSIZ;

/*
** {==================================================================
@@ LUA_NUMBER is the type of numbers in Lua.
** CHANGE the following definitions only if you want to build Lua
** with a number type different from double. You may also need to
** change lua_number2int & lua_number2integer.
** ===================================================================
*/
version = LUA_NUMBER_DOUBLE;
alias LUA_NUMBER = double;

