/*
** $Id: lualib.h,v 1.36.1.1 2007/12/27 13:02:25 roberto Exp $
** Lua standard libraries
** See Copyright Notice in lua.h
*/

module liblua51.lualib;

import liblua51.lua;

/* Key to file-handle type */
enum LUA_FILEHANDLE = "FILE*";

enum LUA_COLIBNAME = "coroutine";
extern(C) int luaopen_base(lua_State *L);

enum LUA_TABLIBNAME = "table";
extern(C) int luaopen_table(lua_State *L);

enum LUA_IOLIBNAME = "io";
extern(C) int luaopen_io(lua_State *L);

enum LUA_OSLIBNAME = "os";
extern(C) int luaopen_os(lua_State *L);

enum LUA_STRLIBNAME = "string";
extern(C) int luaopen_string(lua_State *L);

enum LUA_MATHLIBNAME = "math";
extern(C) int luaopen_math(lua_State *L);

enum LUA_DBLIBNAME = "debug";
extern(C) int luaopen_debug(lua_State *L);

enum LUA_LOADLIBNAME = "package";
extern(C) int luaopen_package(lua_State *L);

/* open all previous libraries */
extern(C) void luaL_openlibs(lua_State *L); 
