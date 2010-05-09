/*
 * file.d
 *
 * This module implements the platform specifics for the File class.
 *
 * Author: Dave Wilkinson
 * Originated: July 25th, 2009
 *
 */

module platform.vars.file;

import platform.unix.common;

import binding.c;

struct FilePlatformVars {
	FILE* file;
}
