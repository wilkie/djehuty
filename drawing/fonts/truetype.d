/*
 * truetype.d
 *
 * This module implements a truetype font interpreter.
 *
 */

module drawing.fonts.truetype;

import djehuty;

import drawing.fonts.truetypetables;

import io.console;

class TrueTypeFont {
private:
	bool _inited;

	OffsetTable _offsetTable;

public:
	this(Stream input) {
		input.read(&_offsetTable, _offsetTable.sizeof);
		fromBigEndian(_offsetTable);

		putln("Version: {d}, {d}".format(_offsetTable.versionMajor, _offsetTable.versionMinor));
	}
}