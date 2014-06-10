/*
** $Id: lauxlib.h,v 1.88.1.1 2007/12/27 13:02:25 roberto Exp $
** Auxiliary functions for building Lua libraries
** See Copyright Notice in lua.h
*/

module liblua51.lauxlib;

import std.c.stddef;
import std.c.stdio;

import liblua51.lua;
import liblua51.luaconf;

version (LUA_COMPAT_GETN) {
	extern(C) int luaL_getn(lua_State *L, int t);
	extern(C) void luaL_setn(lua_State *L, int t, int n);
} else {
	int luaL_getn(lua_State *L, int t) { return cast(int)(lua_objlen(L, t)); }
	void luaL_setn(lua_State *L, int t, int n) { return; }
} // LUA_COMPAT_GETN

version (LUA_COMPAT_OPENLIB) {
	alias luaI_openlib = luaL_openlib;
} // LUA_COMPAT_OPENLIB

/* extra error code for `luaL_load' */
enum LUA_ERRFILE =     (LUA_ERRERR+1);

struct luaL_Reg {
  const char *name;
  lua_CFunction func;
};

extern(C) void luaI_openlib(lua_State *L,
		const char *libname,
		const luaL_Reg *l,
		int nup);
extern(C) void luaL_register(lua_State *L,
		const char *libname,
		const luaL_Reg *l);
extern(C) int luaL_getmetafield(lua_State *L, int obj, const char *e);
extern(C) int luaL_callmeta(lua_State *L, int obj, const char *e);
extern(C) int luaL_typerror(lua_State *L, int narg, const char *tname);
extern(C) int luaL_argerror(lua_State *L, int numarg, const char *extramsg);
extern(C) const char *luaL_checklstring(lua_State *L, int numArg, size_t *l);
extern(C) const char *luaL_optlstring(lua_State *L,
		int numArg,
		const char *def,
		size_t *l);
extern(C) lua_Number luaL_checknumber(lua_State *L, int numArg);
extern(C) lua_Number luaL_optnumber(lua_State *L, int nArg, lua_Number def);

extern(C) lua_Integer luaL_checkinteger(lua_State *L, int numArg);
extern(C) lua_Integer luaL_optinteger(lua_State *L, int nArg, lua_Integer def);

extern(C) void luaL_checkstack(lua_State *L, int sz, const char *msg);
extern(C) void luaL_checktype(lua_State *L, int narg, int t);
extern(C) void luaL_checkany(lua_State *L, int narg);

extern(C) int   luaL_newmetatable(lua_State *L, const char *tname);
extern(C) void *luaL_checkudata(lua_State *L, int ud, const char *tname);

extern(C) void luaL_where(lua_State *L, int lvl);
extern(C) int luaL_error(lua_State *L, const char *fmt, ...);

extern(C) int luaL_checkoption(lua_State *L,
		int narg,
		const char *def,
		const char **lst);

extern(C) int luaL_ref(lua_State *L, int t);
extern(C) void luaL_unref(lua_State *L, int t, int r);

extern(C) int luaL_loadfile(lua_State *L, const char *filename);
extern(C) int luaL_loadbuffer(lua_State *L,
		const char *buff,
		size_t sz,
		const char *name);
extern(C) int luaL_loadstring(lua_State *L, const char *s);

extern(C) lua_State *luaL_newstate();


extern(C) const char *luaL_gsub(lua_State *L,
		const char *s,
		const char *p,
		const char *r);

extern(C) const char *luaL_findtable(lua_State *L,
		int idx,
		const char *fname,
		int szhint);

/*
** ===============================================================
** some useful macros
** ===============================================================
*/

bool luaL_argcheck(lua_State *L, bool cond, int numarg, const char *extramsg) {
	return cond || luaL_argerror(L, numarg, extramsg);
}

const char *luaL_checkstring(lua_State *L, int n) {
	return luaL_checklstring(L, n, null);
}

const char *luaL_optstring(lua_State *L, int n, const char *d) {
	return luaL_optlstring(L, n, d, null);
}

int luaL_checkint(lua_State *L, int n) {
	return cast(int)(luaL_checkinteger(L, n));
}

int luaL_optint(lua_State *L, int n, lua_Integer d) {
	return cast(int)(luaL_optinteger(L, n, d));
}

long luaL_checklong(lua_State *L, int n) {
	return cast(long)(luaL_checkinteger(L, n));
}

long luaL_optlong(lua_State *L, int n, lua_Integer d) {
	return cast(long)(luaL_optinteger(L, n, d));
}

const char *luaL_typename(lua_State *L, int i) {
	return lua_typename(L, lua_type(L, i));
}

bool luaL_dofile(lua_State *L, const char *fn) {
	return luaL_loadfile(L, fn) || lua_pcall(L, 0, LUA_MULTRET, 0);
}

bool luaL_dostring(lua_State *L, const char *s) {
	return luaL_loadstring(L, s) || lua_pcall(L, 0, LUA_MULTRET, 0);
}

void luaL_getmetatable(lua_State *L, const char *n) {
	return lua_getfield(L, LUA_REGISTRYINDEX, n);
}

T luaL_opt(T)(lua_State *L, T function(lua_State *L, int n) f, int n, T d) {
	lua_isnoneornil(L, n) ? d : f(L, n);
}

/*
** {======================================================
** Generic Buffer manipulation
** =======================================================
*/

struct luaL_Buffer {
  char *p;			/* current position in buffer */
  int lvl;  /* number of strings in the stack (level) */
  lua_State *L;
  char buffer[LUAL_BUFFERSIZE];
};

void luaL_addchar(luaL_Buffer *B, char c) {
	(B.p < &B.buffer[0] + LUAL_BUFFERSIZE) || luaL_prepbuffer(B);
	*(B.p++) = c;
}

/* compatibility only */
alias luaL_putchar = luaL_addchar;

void luaL_addsize(luaL_Buffer *B, int n) { B.p += n; }

extern(C) void luaL_buffinit(lua_State *L, luaL_Buffer *B);
extern(C) char *luaL_prepbuffer(luaL_Buffer *B);
extern(C) void luaL_addlstring(luaL_Buffer *B, const char *s, size_t l);
extern(C) void luaL_addstring(luaL_Buffer *B, const char *s);
extern(C) void luaL_addvalue(luaL_Buffer *B);
extern(C) void luaL_pushresult(luaL_Buffer *B);

/* }====================================================== */

/* compatibility with ref system */

/* pre-defined references */
enum LUA_NOREF =     -2;
enum LUA_REFNIL =    -1;

int lua_ref(T)(lua_State *L, T lock) {
	if (lock != 0) {
		return luaL_ref(L, LUA_REGISTRYINDEX);
	}

	lua_pushstring(L, "unlocked references are obsolete");
	lua_error(L);
	return 0;
}

void lua_unref(lua_State *L, int r) { luaL_unref(L, LUA_REGISTRYINDEX, r); }
void lua_getref(lua_State *L, int r) { lua_rawgeti(L, LUA_REGISTRYINDEX, r); }

alias luaL_reg = luaL_Reg;
