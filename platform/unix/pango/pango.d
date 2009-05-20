/*
 * pango.d
 *
 * This file holds bindings to pango. It will import all of the pango
 * packages available.
 *
 * Author: Dave Wilkinson
 *
 */

module platform.unix.pango.pango;

public import platform.unix.pango.font;
public import platform.unix.pango.types;
public import platform.unix.pango.context;
public import platform.unix.pango.pbreak;
public import platform.unix.pango.engine;
public import platform.unix.pango.fontmap;
public import platform.unix.pango.fontset;
public import platform.unix.pango.coverage;
public import platform.unix.pango.item;
public import platform.unix.pango.glyph;
public import platform.unix.pango.matrix;
public import platform.unix.pango.script;
public import platform.unix.pango.attributes;

public import platform.unix.pango.layout;

public import platform.unix.pango.cairo;