/*
 * cui.d
 *
 * This module implements the Cui event loop.
 *
 * Author: Dave Wilkinson
 * Originated: August 17th 2009
 *
 */

module scaffold.cui;

import platform.vars.cui;

import scaffold.console;

import djehuty;

import platform.application;

import cui.application;

void CuiStart(CuiPlatformVars* vars) {
}

void CuiEnd(CuiPlatformVars* vars) {
}

void CuiNextEvent(Event* evt, CuiPlatformVars* vars) {
}

// Will swap to display the backbuffer
void CuiSwapBuffers(CuiPlatformVars* vars) {
}
