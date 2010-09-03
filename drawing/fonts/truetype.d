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

import data.iterable;

// True-type fonts are specified jointly by Microsoft and Apple. Apple originated
// the specification, but neither company truly complies with it.

// The fonts are turing-complete machines since they provide a fully
// turing-complete ISA. The virtual machine requirement in the specification
// is really only for controlling finer aspects of the rasterization when it
// comes to controlling pixel blotting. Since at smaller resolutions, the fonts
// might be too small to be drawn correctly, the machines give finer control in
// order to move pixels and curves in such a way as ensure lines are drawn and
// glyphs are visible.

// Of course, since sub-pixel rendering of curves is possible with today's
// technology (and presumedly tomorrow's) even on small embedded devices,
// the need for such instruction decoding and virtual machines is naught.

// Modern fonts will use a Unicode encoding, but many ancient code
// pages are also available to be used as character encodings in the mapping
// between these codes and glyphs. These tables are 'cmap' tables, but an
// implementation would see it beneficial to convert the code pages to
// unicode first, and always map unicode (the default encoding of the
// system) to glyphs.

class TrueTypeFont {
private:
	bool _inited;

	OffsetTable _offsetTable;
	TableRecord[] _tableRecords;
	CharacterToGlyphIndexMappingTable _characterGlyphIndexMappingTable;
	EncodingTable _encodingTables;

	void readHighByteMappingThroughTable(ref HighByteMappingThroughTable table, Stream input) {
		// Getting the subheaders means figuring out how
		// many there are. That is not easy. One assessment
		// is the maximum index from within subHeaderKeys

		// The thing is... I have no idea how to get the
		// number of subheaders... the docs do not say!
		auto maxSubHeaderKey = max(table.subHeaderKeys);

		// the keys are a byteoffset technically... so divide by
		// the size of a SubHeader structure
		maxSubHeaderKey /= SubHeader.sizeof;

		// the keys are an index, I want a count, so increment
		maxSubHeaderKey++;

		// With this, we can read in at least as many tables as
		// to read this maxSubHeaderKey... then the rest are
		// glyph indices.
		table.subHeaders = new SubHeader[maxSubHeaderKey];

		// Now read it in
		input.read(table.subHeaders.ptr, maxSubHeaderKey * SubHeader.sizeof);

		// Get glyphIndexArray length from the length of the subtable
		int entireLength = table.length;
		entireLength -= HighByteMappingThroughTable.MAIN_TABLE_SIZE;
		entireLength -= maxSubHeaderKey * SubHeader.sizeof;

		int numGlyphIndices = entireLength / short.sizeof;

		// Read in glyph index array
		table.glyphIndexArray = new ushort[numGlyphIndices];
		input.read(table.glyphIndexArray.ptr, numGlyphIndices * short.sizeof);
	}

	void readSegmentMappingToDeltaValuesTable(SegmentMappingToDeltaValuesTable table, Stream input) {
		// get the number of segments

		int segCount = table.segCountX2 / 2;
		putln("Segments: ", segCount);

		table.endCode = new ushort[segCount];
		table.startCode = new ushort[segCount];
		table.idDelta = new ushort[segCount];
		table.idRangeOffset = new ushort[segCount];

		// Get the number of glyphs
		int glyphIndexCount = table.length - SegmentMappingToDeltaValuesTable.MAIN_TABLE_SIZE;

		// handle the segCount arrays
		glyphIndexCount -= segCount * 2 * 4;

		// handle silly reserved ushort
		glyphIndexCount -= 2;

		if (glyphIndexCount < 0) {
			glyphIndexCount = 0;
		}

		table.glyphIndexArray = new
			ushort[glyphIndexCount];

		// Read input
		input.read(table.endCode.ptr, segCount * ushort.sizeof);
		input.skip(ushort.sizeof);
		input.read(table.startCode.ptr, segCount * ushort.sizeof);
		input.read(table.idDelta.ptr, segCount * ushort.sizeof);
		input.read(table.idRangeOffset.ptr, segCount * ushort.sizeof);
		input.read(table.glyphIndexArray.ptr, glyphIndexCount * ushort.sizeof);
	}

	void readTrimmedTableMappingTable(TrimmedTableMappingTable table, Stream input) {
		table.glyphIDArray = new ushort[table.entryCount];
		input.read(table.glyphIDArray.ptr, table.entryCount * ushort.sizeof);
	}

	void readCharacterToGlyphMappingTable(Stream input, int offset) {
		input.rewind();
		input.position = offset;

		input.read(&_characterGlyphIndexMappingTable,
		  _characterGlyphIndexMappingTable.MAIN_TABLE_SIZE);
		fromBigEndian(_characterGlyphIndexMappingTable);

		with(_characterGlyphIndexMappingTable) {
			putln("CMAP: version ", tableVersion);
			putln("numEncodingTables: ", numEncodingTables);

			encodingTables = new EncodingTable[](numEncodingTables);

			for(int i = 0; i < numEncodingTables; i++) {
				input.read(&encodingTables[i], EncodingTable.MAIN_TABLE_SIZE);
			}

			foreach(ref tbl; encodingTables) {
				fromBigEndian(tbl);

				putln(tbl.platformID);
				putln(tbl.platformEncodingID);
				putln(tbl.offsetToSubtable);

				input.position = offset;
				input.skip(tbl.offsetToSubtable);

				ushort format;
				input.read(format);
				fromBigEndian(format);
				input.rewind(short.sizeof);

				uint size = 0;
				switch(format) {
					case 0:
						size = ByteEncodingTable.sizeof;
						break;
					case 2:
						size = HighByteMappingThroughTable.MAIN_TABLE_SIZE;
						break;
					case 4:
						size = SegmentMappingToDeltaValuesTable.MAIN_TABLE_SIZE;
						break;
					case 6:
						size = TrimmedTableMappingTable.MAIN_TABLE_SIZE;
						break;
						
						// XXX: 8
						// XXX: 10
						// XXX: 12
						// XXX: 14
					default:
						break;
				}

				if (size != 0) {
					// read subtable
					input.read(&tbl.subtable, size);
				}

				putln("Format: ", format);

				switch(format) {
					case 0:
						fromBigEndian(tbl.subtable.byteEncodingTable);

						// format 0 requires no additional logic to read the
						// rest of the table.
						break;

					case 2: // High-byte Mapping Through Table
						fromBigEndian(tbl.subtable.highByteMappingThroughTable);
						readHighByteMappingThroughTable(tbl.subtable.highByteMappingThroughTable, input);
						break;

					case 4: // Segment Mapping To Delta Values Table
						fromBigEndian(tbl.subtable.segmentMappingToDeltaValuesTable);
						readSegmentMappingToDeltaValuesTable(tbl.subtable.segmentMappingToDeltaValuesTable, input);
						break;

					case 6: // Trimmed Table Mapping Table
						fromBigEndian(tbl.subtable.trimmedTableMappingTable);
						readTrimmedTableMappingTable(tbl.subtable.trimmedTableMappingTable, input);
						break;

					default:
						break;
				}
			}
		}
	}

public:
	this(Stream input) {
		input.read(&_offsetTable, _offsetTable.sizeof);
		fromBigEndian(_offsetTable);

		putln("Version: ", _offsetTable.versionMajor, ".", _offsetTable.versionMinor);
		putln("Number of tables: ", _offsetTable.numTables);
		putln("Search Range: ", _offsetTable.searchRange);
		putln("Entry Selector: ", _offsetTable.entrySelector);
		putln("Range Shift: ", _offsetTable.rangeShift);

		_tableRecords = new TableRecord[](_offsetTable.numTables);
		input.read(_tableRecords.ptr, TableRecord.sizeof * _offsetTable.numTables);
		foreach(ref tbl; _tableRecords) {
			fromBigEndian(tbl);
		}

		foreach(ref tbl; _tableRecords) {
			putln("Table (", (cast(char*)(&tbl.tag))[0..4], ")");
			putln("Checksum: ", tbl.checksum);
			putln("Offset: ", tbl.offset);
			putln("Length: ", tbl.length);
		}

		foreach(ref tbl; _tableRecords) {
			switch(tbl.tag) {
				case Tag.CharacterToGlyphMapping:
					readCharacterToGlyphMappingTable(input, tbl.offset);
					break;
				default:
					// skip table
					break;
			}
		}
	}
}