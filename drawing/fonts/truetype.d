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

	FontHeaderTable _fontHeader;
	HorizontalHeaderTable _horizontalHeader;
	MaximumProfile _profile;
	IndexToLocationLongTable _locations;

	GlyphDataTable _glyphData;

	CharacterToGlyphIndexMappingTable _characterGlyphIndexMappingTable;
	EncodingTable _encodingTables;

	Glyph[] _glyphs;

	void readFontHeaderTable(Stream input, ref TableRecord tbl) {
		input.position = tbl.offset;

		input.read(&_fontHeader, FontHeaderTable.sizeof);
		fromBigEndian(_fontHeader);
	}

	void readHorizontalHeaderTable(Stream input, ref TableRecord tbl) {
		input.position = tbl.offset;

		input.read(&_horizontalHeader, HorizontalHeaderTable.sizeof);
		fromBigEndian(_horizontalHeader);
	}

	void readMaximumProfile(Stream input, ref TableRecord tbl) {
		input.position = tbl.offset;

		input.read(&_profile, MaximumProfile.sizeof);
		fromBigEndian(_profile);

		putln("Number of Glyphs: ", _profile.numGlyphs);
	}

	void readIndexToLocationTable(Stream input, ref TableRecord tbl) {
		input.position = tbl.offset;

		_locations.offsets = new uint[](_profile.numGlyphs + 1);
		if (_fontHeader.indexToLocFormat != 0) {
			putln("Loca table indicates number of glyphs: ", (tbl.length / 4) - 1);
			input.read(_locations.offsets.ptr, uint.sizeof * _locations.offsets.length);
			fromBigEndian(_locations.offsets);
		}
		else {
			putln("Loca table indicates number of glyphs: ", (tbl.length / 2) - 1);
			// Note the <= here since the number of locations is one more than the number of glyphs
			ushort offset;
			for (int i = 0; i <= _profile.numGlyphs; i++) {
				input.read(&offset, ushort.sizeof);
				fromBigEndian(offset);

				_locations.offsets[i] = offset;
				_locations.offsets[i] *= 2;
			}
		}
	}

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

	void readMixed16BitAnd32BitCoverageTable(Mixed16BitAnd32BitCoverageTable table, Stream input) {
		table.groups = new MixedGroup[](table.nGroups);
		input.read(table.groups.ptr, MixedGroup.sizeof * table.nGroups);
	}

	void readTrimmedArrayTable(TrimmedArrayTable table, Stream input) {
		table.glyphs = new ushort[](table.numChars);
		input.read(table.glyphs.ptr, ushort.sizeof * table.numChars);
	}

	void readSegmentedCoverageTable(SegmentedCoverageTable table, Stream input) {
		table.groups = new MixedGroup[](table.nGroups);
		input.read(table.groups.ptr, MixedGroup.sizeof * table.nGroups);
	}

	void readCharacterToGlyphMappingTable(Stream input, int offset) {
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

					case 8:
						size = Mixed16BitAnd32BitCoverageTable.MAIN_TABLE_SIZE;
						break;

					case 10:
						size = TrimmedArrayTable.MAIN_TABLE_SIZE;
						break;

					case 12:
						size = SegmentedCoverageTable.MAIN_TABLE_SIZE;
						break;

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

					case 8: // Mixed 16-bit and 32-bit Coverage
						fromBigEndian(tbl.subtable.mixed16BitAnd32BitCoverageTable);
						readMixed16BitAnd32BitCoverageTable(tbl.subtable.mixed16BitAnd32BitCoverageTable, input);

					case 10: // Trimmed Array Table
						fromBigEndian(tbl.subtable.trimmedArrayTable);
						readTrimmedArrayTable(tbl.subtable.trimmedArrayTable, input);

					case 12: // Segmented Coverage Table
					case 13: // Last Resort Font Table (it has the same structure)
						fromBigEndian(tbl.subtable.segmentedCoverageTable);
						readSegmentedCoverageTable(tbl.subtable.segmentedCoverageTable, input);

					default:
						break;
				}
			}
		}
	}

	// This function reads in the coordinate arrays
	void readCoordinateArray(bool isX)(Stream input, ref short[] array, ref ubyte[] flags) {
		static if (isX) {
			static const IS_NOT_SHORT = (1 << 1);
			static const SAME_FLAG = (1 << 4);
		}
		else {
			static const IS_NOT_SHORT = (1 << 2);
			static const SAME_FLAG = (1 << 5);
		}

		short last = 0;
		foreach(size_t idx, ref coord; array) {
			// When bit 1 is set, the point is a ubyte,
			// otherwise, it is a short
			if (flags[idx] & IS_NOT_SHORT) {
				ubyte smallCoord;
				input.read(&smallCoord, ubyte.sizeof);
				coord = smallCoord;
				// When bit 4 is set, in this case, it denotes
				// that this value is positive
				// Otherwise, it is negative
				if (!(flags[idx] & SAME_FLAG)) {
					coord = -coord;
				}

				if (idx > 0) {
					// Convert to absolute coordinates
					coord += last;
				}
			}
			else {
				// The value is stored as a short

				// When bit 4 is set, it denotes that this coord
				// is the same as the last coord...
				if (flags[idx] & SAME_FLAG) {
					if (idx > 0) {
						coord = last;
					}
				}
				else {
					// The value is then a 16-bit delta vector
					input.read(&coord, short.sizeof);
					fromBigEndian(coord);
					if (idx > 0) {
						// Convert to absolute coordinates
						coord += last;
					}
				}
			}
			last = coord;
		}
	}

	void readSimpleGlyph(Stream input, ref Glyph g, int numberOfContours) {
		// First thing is an array of points (endPtsOfContours) of
		// length numberOfContours
		g.endPtsOfContours = new ushort[](numberOfContours);
		putln("Pos: ", input.position);
		input.read(g.endPtsOfContours.ptr, ushort.sizeof * numberOfContours);
		putln("Pos: ", input.position);
		fromBigEndian(g.endPtsOfContours);

		ushort instLength;
		input.read(&instLength, ushort.sizeof);
		fromBigEndian(instLength);

		putln("Instruction Count: ", instLength);

		g.instructions = new ubyte[](instLength);
		input.read(g.instructions.ptr, ubyte.sizeof * instLength);

		// set up glyph arrays that are set via flags
		g.isOnCurve = new bool[](numberOfContours);

		// flags...
		int numberOfPoints = 0;

		if (numberOfContours > 0) {
			numberOfPoints = g.endPtsOfContours[$-1] + 1;
		}

		putln("Number of points: ", numberOfPoints);
		ubyte[] flags = new ubyte[](numberOfPoints);

		// flags may be applied to more than one point,
		// so we should keep track of how many times this flag
		// should be repeated
		ubyte repeat = 0;

		for(int i = 0; i < numberOfPoints; i++) {
			if (repeat == 0) {
				// read in the flags
				input.read(&flags[i], ubyte.sizeof);

				if (flags[i] & (1 << 3)) { // Repeat flag
					// read in the repeat byte
					input.read(&repeat, ubyte.sizeof);

					// set all flags that are repeated to this current flag value
					flags[i+1..i+repeat+1] = flags[i];
				}
			}
			else {
				repeat--;
			}

			// interpret flags
			if (flags[i] & 0x01) { // On Curve flag
				g.isOnCurve[i] = 1;
			}
		}

		// xCoordinate array
		g.xCoordinates = new short[](numberOfPoints);
		readCoordinateArray!(true)(input, g.xCoordinates, flags);

		g.yCoordinates = new short[](numberOfPoints);
		readCoordinateArray!(false)(input, g.yCoordinates, flags);
	}

	void readCompositeGlyph(Stream input, ref Glyph g) {
	}

	void readGlyphData(Stream input, ref TableRecord record) {
		putln("Length: ", record.length);

		_glyphs = new Glyph[](_profile.numGlyphs);

		for (int i = 0; i < _profile.numGlyphs; i++) {
			if (_locations.offsets[i] == _locations.offsets[i+1]) {
				// empty glyph
				putln("continuing...");
				continue;
			}

			input.position = record.offset + _locations.offsets[i];
			putln("Offset: ", _locations.offsets[i]);

			short numberOfContours;
			input.read(&numberOfContours, short.sizeof);
			fromBigEndian(numberOfContours);

			putln("Glyph: numContours: ", numberOfContours);

			input.read(&_glyphs[i].xMin, short.sizeof);
			fromBigEndian(_glyphs[i].xMin);
			input.read(&_glyphs[i].yMin, short.sizeof);
			fromBigEndian(_glyphs[i].yMin);
			input.read(&_glyphs[i].xMax, short.sizeof);
			fromBigEndian(_glyphs[i].xMax);
			input.read(&_glyphs[i].yMax, short.sizeof);
			fromBigEndian(_glyphs[i].yMax);

			if (numberOfContours >= 0) {
				// Simple Glyph
				readSimpleGlyph(input, _glyphs[i], numberOfContours);
			}
			else {
				// Composite Glyph
				readCompositeGlyph(input, _glyphs[i]);
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

		int hheaIndex = int.min;
		int headIndex = int.min;
		int maxpIndex = int.min;
		int locaIndex = int.min;
		int glyfIndex = int.min;
		int cmapIndex = int.min;

		foreach(size_t idx, ref tbl; _tableRecords) {
			fromBigEndian(tbl);
			if (tbl.tag == Tag.FontHeader) {
				headIndex = idx;
			}
			else if (tbl.tag == Tag.CharacterToGlyphMapping) {
				cmapIndex = idx;
			}
			else if (tbl.tag == Tag.GlyphData) {
				glyfIndex = idx;
			}
			else if (tbl.tag == Tag.MaximumProfile) {
				maxpIndex = idx;
			}
			else if (tbl.tag == Tag.IndexToLocation) {
				locaIndex = idx;
			}
			else if (tbl.tag == Tag.HorizontalHeader) {
				hheaIndex = idx;
			}
		}

		foreach(ref tbl; _tableRecords) {
			putln("Table (", (cast(char*)(&tbl.tag))[0..4], ")");
			putln("Checksum: ", tbl.checksum);
			putln("Offset: ", tbl.offset);
			putln("Length: ", tbl.length);
		}

		if (headIndex == int.min) {
			// error
		}

		readFontHeaderTable(input, _tableRecords[headIndex]);

		if (hheaIndex == int.min) {
			// error
		}

		readHorizontalHeaderTable(input, _tableRecords[hheaIndex]);

		if (maxpIndex == int.min) {
			// error
		}

		readMaximumProfile(input, _tableRecords[maxpIndex]);

		if (locaIndex == int.min) {
			// error
		}

		readIndexToLocationTable(input, _tableRecords[locaIndex]);

		if (cmapIndex == int.min) {
			// error
		}

		readCharacterToGlyphMappingTable(input, _tableRecords[cmapIndex].offset);

		if (glyfIndex == int.min) {
			// error
		}

		readGlyphData(input, _tableRecords[glyfIndex]);
	}
}