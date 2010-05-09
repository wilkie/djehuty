module scaffold.system;

import platform.vars.library;
import core.definitions;
import core.locale;

extern(C) char* getenv(char*);
extern(C) int strlen(char*);

int SystemGetDisplayWidth(uint screen) {
	return 0;
}

int SystemGetDisplayHeight(uint screen) {
	return 0;
}

uint SystemGetPrimaryDisplay() {
	// The primary display is 0

	return 0;
}

uint SystemGetDisplayCount() {
	return 0;
}

ulong SystemGetTotalMemory() {
	return 0;
}

ulong SystemGetAvailableMemory() {
	return 0;
}

bool SystemLoadLibrary(ref LibraryPlatformVars vars, string libraryPath) {
	char[] path = libraryPath.dup ~ "\0";
	//vars.handle = dlopen(path.ptr,RTLD_LAZY);
	return vars.handle !is null;
}

void SystemFreeLibrary(ref LibraryPlatformVars vars) {
	if (vars.handle is null) { return; }
	//dlclose(vars.handle);
	vars.handle = null;
}

void* SystemLoadLibraryProc(ref LibraryPlatformVars vars, string procName) {
	if (vars.handle is null) {
		return null;
	}

	char[] proc = procName.dup ~ "\0";
	//return cast(void*)dlsym(vars.handle, proc.ptr);
	return null;
}

LocaleId SystemGetLocaleId() {
	char* res = getenv("LANG\0"c.ptr);
	string locale = cast(char[])res[0..strlen(res)];

	if (locale.length > 5) {
		locale = locale[0..5];
	}

	LocaleId ret;

	switch(locale) {
		default:
		case "en_US":
			ret = LocaleId.English_US;
			break;
		case "fr_FR":
			ret = LocaleId.French_FR;
			break;
	}

	return ret;
}

private import binding.c;

ubyte[] malloc(size_t length) {
	ubyte* ret = cast(ubyte*)binding.c.malloc(length);

	// Error, probably out of memory.
	if (ret is null) {
		return null;
	}

	return ret[0..length];
}

ubyte[] realloc(ubyte[] original, size_t length) {
	ubyte* ret = cast(ubyte*)binding.c.realloc(original.ptr, length);

	if (ret is null) {
		return null;
	}

	return ret[0..length];
}

ubyte[] calloc(size_t length) {
	ubyte* ret = cast(ubyte*)binding.c.calloc(length);

	// Error, probably out of memory.
	if (ret is null) {
		return null;
	}

	return ret[0..length];
}

void free(void[] memory) {
	binding.c.free(memory.ptr);
}
