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

		putln("Version: ", _offsetTable.versionMajor, ".", _offsetTable.versionMinor);
		putln("Number of tables: ", _offsetTable.numTables);
		putln("Search Range: ", _offsetTable.searchRange);
		putln("Entry Selector: ", _offsetTable.entrySelector);
		putln("Range Shift: ", _offsetTable.rangeShift);
	}
}