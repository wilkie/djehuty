/*
 * directory.d
 *
 * This module implements the platform specifics for the Directory class.
 *
 * Author: Dave Wilkinson
 * Originated: July 25th, 2009
 *
 */

module platform.vars.directory;

import platform.unix.common;

struct DirectoryPlatformVars {
	DIR* dir;
}
