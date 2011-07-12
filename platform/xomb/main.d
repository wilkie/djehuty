/*
 * main.d
 *
 * This file implements the main routines for the Linux system.
 * This file is the entry point for a Linux application.
 *
 * Author: Dave Wilkinson
 *
 */

module platform.xomb.main;

struct DjehutyPlatformVars {
	int argc;
	char** argv;
}

DjehutyPlatformVars* _pfvars() {
	static DjehutyPlatformVars pfvars;

	return &pfvars;
}

void AppInit() {
}
