module drawing.fonts.truetypetables;

align(1) struct OffsetTable {
	// Version
	short versionMajor;
	ushort versionMinor;

	// The number of tables
	ushort numTables;

	// (maximum power of 2 <= numTables) * 16
	ushort searchRange;

	// Log_2(maximum power of 2 <= numTables)
	ushort entrySelector;

	// numTables * 16-searchRange
	ushort rangeShift;
}

template CharacterTagToInteger(string tag) {
	const uint CharacterTagToInteger = (((((tag[0] << 8) | tag[1]) << 8) | tag[2]) << 8) | tag[3];
}

enum Tag : uint {
	// Required
	CharacterToGlyphMapping = CharacterTagToInteger!("cmap"),
	GlyphData = CharacterTagToInteger!("glyf"),
	FontHeader = CharacterTagToInteger!("head"),
	HorizontalHeader = CharacterTagToInteger!("hhea"),
	HorizontalMetrics = CharacterTagToInteger!("hmtx"),
	IndexToLocation = CharacterTagToInteger!("loca"),
	MaximumProfile = CharacterTagToInteger!("maxp"),
	NamingTable = CharacterTagToInteger!("name"),
	PostScriptInformation = CharacterTagToInteger!("post"),
	OS2WindowsSpecific = CharacterTagToInteger!("OS/2"),

	// Optional
	ControlValueTable = CharacterTagToInteger!("cvt "),
	EmbeddedBitmapData = CharacterTagToInteger!("EBDT"),
	EmbeddedBitmapLocationData = CharacterTagToInteger!("EBLC"),
	EmbeddedBitmapScalingData = CharacterTagToInteger!("EBSC"),
	FontProgram = CharacterTagToInteger!("fpgm"),
	GridFittingAndScanConversionProcedure = CharacterTagToInteger!("gasp"),
	HorizontalDeviceMetrics = CharacterTagToInteger!("hdmx"),
	Kerning = CharacterTagToInteger!("kern"),
	LinearThresholdTable = CharacterTagToInteger!("LTSH"),
	CVTProgram = CharacterTagToInteger!("prep"),
	PCLT = CharacterTagToInteger!("PCL5"),
	VerticalDeviceMetricsTable = CharacterTagToInteger!("VDMX"),
	VerticalMetricsHeader = CharacterTagToInteger!("vhea"),
	VerticalMetrics = CharacterTagToInteger!("vmtx")
}

align(1) struct TableRecord {
	// 4-byte identifier
	Tag tag;

	// Checksum for this table
	uint checksum;

	// Offset from beginning of truetype font file
	uint offset;

	// Length of the table
	uint length;
}

// Subtables

// Format 0 (Byte encoding table)
align(1) struct ByteEncodingTable {
	// The format number (set to 0)
	ushort format;

	// The length in bytes of this subtable
	ushort length;

	// Version number (starts at 0)
	ushort subtableVersion;

	// An array that maps character codes to glyph index values
	byte[256] glyphIDArray;
}

// Format 2 (High-byte mapping through table)
align(1) struct HighByteMappingThroughTable {
	static const MAIN_TABLE_SIZE = 6 + (256*2);

	// The format number (set to 2)
	ushort format;

	// Length in bytes
	ushort length;

	// Language field (was a version field)
	ushort language;

	// Array that maps high bytes to subHeaders: value is subHeader index * 8
	ushort[256] subHeaderKeys;

	SubHeader[] subHeaders;
	ushort[] glyphIndexArray;
}

// Format 2
align(1) struct SubHeader {
	// The first valid low byte for this subHeader
	ushort firstCode;

	// The number of valid low bytes for this subheader
	ushort entryCount;

	// How much to add (if not 0) to the value in the subarray to get
	// the glyph index.
	short idDelta;

	// The number of bytes past the actual location of this value where
	// the glyphIndexArray element corresponding to firstCode appears.
	ushort idRangeOffset;
}

// Format 4
align(1) struct SegmentMappingToDeltaValuesTable {
	static const MAIN_TABLE_SIZE = 14;

	// Format number (set to 4)
	ushort format;

	// Length in bytes
	ushort length;

	// Version number (starts at 0)
	ushort subtableVersion;

	// segCount * 2
	ushort segCountX2;

	// 2 * (2^(floor(log_2(segCount))))
	ushort searchRange;

	// log_2(searchRange/2)
	ushort entrySelector;

	// 2 * segCount - searchRange
	ushort rangeShift;

	// afterward, there is a set of variable length fields for each
	// segment specified by segCount

	// ending character code for each segment, last = 0xffff
	// sizeOfArray = segCountX2 / 2
	ushort[] endCode;

	ushort reserved;

	// starting character for each segment
	// sizeOfArray = segCountX2 / 2
	ushort[] startCode;

	// delta for all character codes in segment
	// sizeOfArray = segCountX2 / 2
	ushort[] idDelta;

	// offset in bytes to glyphIndexArray, or 0
	// sizeOfArray = segCountX2 / 2
	ushort[] idRangeOffset;

	// sizeOfArray = length - MAIN_TABLE_SIZE - segCountX2 * 4 - 2
	ushort[] glyphIndexArray;
}

// Format 6
align(1) struct TrimmedTableMappingTable {
	static const MAIN_TABLE_SIZE = 10;

	// Format number (set to 6)
	ushort format;

	// Length in bytes
	ushort length;

	// Version number (starts at 0)
	ushort subtableVersion;

	// First character code of subrange
	ushort firstCode;

	// Number of character codes in subrange
	ushort entryCount;

	// afterward, a ushort array of size entryCount for glyphIDArray[]
	// sizeOfArray = entryCount
	ushort[] glyphIDArray;
}

// Format 8
align(1) struct Mixed16BitAnd32BitCoverageTable {
	static const MAIN_TABLE_SIZE = (ushort.sizeof * 2) + (uint.sizeof * 3) + (8 * 1024);

	// Format number (set to 8)
	ushort format;

	// table version (starts at 0)
	ushort tableVersion;

	// length of table in bytes
	uint length;

	// language code for this encoding table, 0 if language-independent
	uint language;

	// bitmap with 64K bits that indicate whether or not the particular
	// 16-bit (index) value is the start of a 32-bit character code
	ubyte[8 * 1024] is32;

	// The number of groups to follow
	uint nGroups;

	// The groups
	// sizeOfArray = nGroups
	MixedGroup[] groups;
}

align(1) struct MixedGroup {
	// First character code in this group;
	// Note: that if this group is for one or more 16-bit character codes
	// (which is determined from the is32 array), this 32-bit value will have
	// the high 16-bits set to zero
	uint startCharCode;

	// Last character code in this group
	// Note: This is used as an index and not as a count since the comparisons are done
	// on ranges and this would save an addition.
	uint endCharCode;

	// Glyph index corresponding to the starting character code
	uint startGlyphCode;
}

// Format 10
align(1) struct TrimmedArrayTable {
	static const MAIN_TABLE_SIZE = 20;

	// format (set to 10)
	ushort format;

	// version (starts at 0)
	ushort tableVersion;

	// length of the table in bytes
	uint length;

	// language (0 if dont-care)
	uint language;

	// first character code covered
	uint startCharCode;

	// the number of characters covered
	uint numChars;

	// Array of glyph indices for the character codes covered
	// sizeOfArray = numChars
	ushort[] glyphs;
}

// Format 12
align(1) struct SegmentedCoverageTable {
	static const MAIN_TABLE_SIZE = 16;

	// format (set to 10)
	ushort format;

	// version (starts at 0)
	ushort tableVersion;

	// length of the table in bytes
	uint length;

	// language (0 if dont-care)
	uint language;

	// number of groups
	uint nGroups;

	// sizeOfArray = nGroups
	MixedGroup[] groups;
}

// Format 13 (Last Resort Font)
alias SegmentedCoverageTable LastResortFontTable;

// Format 14 (Unicode Variation Sequences)
align(1) struct VariationSelectorRecord {
	// Variation selector
	// Note: No two records may have the same selector
	// The records are stored in increasing order
	ubyte[3] varSelector;

	// Offset to the default UVS table (may be 0)
	uint defaultUVSOffset;

	// Offset to the non-default UVS table (may be 0)
	uint nonDefaultUVSOffset;
}

align(1) struct UnicodeVariationSequencesTable {
	static const MAIN_TABLE_SIZE = 10;

	// format (set to 14)
	ushort format;

	// length in bytes (includes header)
	uint length;

	// number of variation selector records
	uint numVarSelectorRecords;

	// Selectors
	// The records are stored in increasing order
	// No Duplicates are allowed
	// sizeOfArray = numVarSelectorRecords
	VariationSelectorRecord[] records;
}

align(1) union EncodingSubtable {
	ByteEncodingTable byteEncodingTable;
	HighByteMappingThroughTable highByteMappingThroughTable;
	SegmentMappingToDeltaValuesTable segmentMappingToDeltaValuesTable;
	TrimmedTableMappingTable trimmedTableMappingTable;
	Mixed16BitAnd32BitCoverageTable mixed16BitAnd32BitCoverageTable;
	TrimmedArrayTable trimmedArrayTable;
	SegmentedCoverageTable segmentedCoverageTable;
	LastResortFontTable lastResortFontTable;
}

align(1) struct EncodingTable {
	static const MAIN_TABLE_SIZE = 8;

	// a platform ID
	ushort platformID;

	// platform specific encoding ID
	ushort platformEncodingID;

	// byte offset from beginning of the table to the
	// subtable for this encoding.
	uint offsetToSubtable;

	EncodingSubtable subtable;
}

align(1) struct CharacterToGlyphIndexMappingTable {
	static const MAIN_TABLE_SIZE = 4;

	// The version identification of the table (0)
	ushort tableVersion;

	// The number of EncodingTable entries that follow this table
	ushort numEncodingTables;

	// The encoding tables
	EncodingTable[] encodingTables;
}

// cvt (Control Value Table)
// -------------------------

align(1) struct ControlValueTable {
}

// EBLC (Embedded Bitmap Data Table)
// ---------------------------------
// The EBLC table identifies the sizes and glyph ranges of the sbits
// (scalar bitmaps) and keeps offsets to glyph bitmap data in indexSubTables.
// The EBDT table then stores the glyph bitmap data in a number of different
// possible formats. Glyph metrics information may be stored in either the
// EBLC or EBDT table depending upon the indexSubTable and glyph bitmap data
// formats. The EBSC table identifies sizes that will be handled by scaling up
// or scaling down other sbit sizes.
align(1) struct EmbeddedBitmapDataTable {
	// Version
	short versionMajor;
	ushort versionMinor;

	// afterward is a collection of bitmap data. The format is indicated
	// by the EBLC table.
}

align(1) struct BigGlyphMetrics {
	ubyte height;
	ubyte width;
	byte horizontalBearingX;
	byte horizontalBearingY;
	ubyte horizontalAdvance;
	byte verticalBearingX;
	byte verticalBearingY;
	ubyte verticalAdvance;
}

align(1) struct SmallGlyphMetrics {
	ubyte height;
	ubyte width;
	byte bearingX;
	byte bearingY;
	ubyte advance;
}

// Used for format 8 and format 9 for bitmap data
align(1) struct EBDTComponent {
	// Component glyph code
	ushort glyphCode;

	// X offset
	byte xOffset;

	// Y offset
	byte yOffset;
}

align(1) struct EmbeddedBitmapLocationTable {
	// Version
	short versionMajor;
	ushort versionMinor;

	// Number of BitmapSizeTables
	uint numSizes;
}

enum BitmapSizeFlags : byte {
	Horizontal = 0x1,
	Vertical = 0x2
}

align(1) struct BitmapSizeTable {
	// Offset to index subtable from beginning of EBLC
	uint indexSubTableArrayOffset;

	// Number of bytes in corresponding index subtables and array
	uint indexTablesSize;

	// An index subtable for each range or format change
	uint numberOfIndexSubTables;

	// Not used (set to 0)
	uint colorRef;

	// Line metrics for text rendered in each direction
	SBitLineMetrics horizontal;
	SBitLineMetrics vertical;

	// Lowest glyph index for this size
	ushort startGlyphIndex;

	// Highest glyph index for this size
	ushort endGlyphIndex;

	// Horizontal pixels per Em
	ubyte ppemX;

	// Vertical pixels per Em
	ubyte ppemY;

	// Apparently unused (Set for 1 for now)
	ubyte bitDepth;

	// vertical or horizontal (1 == horizontal, 2 == vertical)
	BitmapSizeFlags flags;
}

align(1) struct SBitLineMetrics {
	byte ascender;
	byte descender;
	ubyte widthMax;
	byte caretSlopeNumerator;
	byte caretSlopeDenominator;
	byte caretOffset;
	byte minOriginSB;
	byte minAdvanceSB;
	byte maxBeforeBL;
	byte minAfterBL;
	byte pad1;
	byte pad2;
}

align(1) struct IndexSubTableArray {
	// First glyph code of this range
	ushort firstGlyphIndex;

	// Last glyph code of this range (inclusive)
	ushort lastGlyphIndex;

	// Add to indexSubTableArrayOffset to get offset from
	// beginning of EBLC table
	uint additionalOffsetToIndexSubtable;
}

align(1) struct IndexSubHeader {
	// Format of this indexSubTable
	ushort indexFormat;

	// Format of EBDT image data
	ushort imageFormat;

	// Offset to image data in EBDT table
	uint imageDataOffset;
}

// 1: Variable metrics glyphs with 4 byte offsets
align(1) struct IndexSubHeader1 {
	IndexSubHeader header;

	// offsetArray[glyphIndex] + imageDataOffset = glyphData
	// sizeOfArray = (lastGlyph-firstGlyph+1)+1 (+1 pad if needed)
	uint[] offsetArray;
}

// All glyphs have identical metrics
align(1) struct IndexSubHeader2 {
	IndexSubHeader header;

	// All the glyphs are of the same size
	uint imageSize;

	// all the glyphs ahve the same metrics; glyph data may be
	// compressed, byte-aligned, or bit-aligned
	BigGlyphMetrics bigMetrics;
}

// 3: Variable metrics glyphs with 2 byte offsets
align(1) struct IndexSubHeader3 {
	IndexSubHeader header;

	// offsetArray[glyphIndex] + imageDataOffset = glyphData
	// sizeOfArray = (lastGlyph - firstGlyph+1)+1 (+1 pad if needed)
	ushort[] offsetArray[];
}

align(1) struct CodeOffsetPair {
	// code of glyph present
	ushort glyphCode;

	// location in EBDT
	ushort offset;
}

// 4: Variable metrics glyphs with sparse glyph codes
align(1) struct IndexSubHeader4 {
	IndexSubHeader header;

	// All glyphs have the same data size
	uint imageSize;

	// All glyphs have the same metrics
	BigGlyphMetrics bigMetrics;

	// The array length
	uint numGlyphs;

	// One per glyph, sorted by glyph code;
	// sizeOfArray = numGlyphs
	ushort[] glyphCodeArray;
}

// 5: Constant metrics glyphs with sparse glyph codes
align(1) struct IndexSubTable5 {
	IndexSubHeader header;

	// all glyphs have the same data size
	uint imageSize;

	// all glyphs have the same metrics
	BigGlyphMetrics bigMetrics;

	// array length;
	uint numGlyphs;

	// one per glyph, sorted by glyph code;
	// sizeOfArray = numGlyphs
	ushort[] glyphCodeArray;
}

// EBST

align(1) struct EmbeddedBitmapScalingTableHeader {
	// Version
	short versionMajor;
	ushort versionMinor;

	uint numSizes;
}

align(1) struct BitmapScaleTable {
	SBitLineMetrics horizontal;
	SBitLineMetrics vertical;
	ubyte ppemX;
	ubyte ppemY;
	ubyte substitutePpemX;
	ubyte substitutePpemY;
}

align(1) struct EmbeddedBitmapScalingTable {
	EmbeddedBitmapScalingTableHeader header;

	// size of array is header.numSizes
	BitmapScaleTable[] bitmapScaleTables;
}

// fpgm

align(1) struct FontProgram {
	ubyte[] instructions;
}

// gasp

align(1) struct GASPRange {
	// Upper limit of range, in PPEM
	ushort rangeMaxPPEM;

	// Flags describing desired rasterizer behavior
	RangeGaspBehavior rangeGaspBehavior;
}

align(1) struct GridFittingAndScanConversionProcedure {
	// Version number (set to 0)
	ushort tableVersion;

	// Number of records to follow
	ushort numRanges;

	// Sorted by ppem, length of array is numRanges
	GASPRange[] gaspRange;
}

enum RangeGaspBehavior : ushort {
	GASP_GRIDFIT = 0x1,
	GASP_DOGRAY = 0x2
}

// glyf (Glyph Data)

struct CompositeData {
	size_t glyphIndex;
}

struct Glyph {
	// If negative, this is a composite glyph.
	bool isComposite;

	// Minimum x for coordinate data in FUnits
	short xMin;

	// Minimum y for coordinate data in FUnits
	short yMin;

	// Maximum x for coordinate data in FUnits
	short xMax;

	// Maximum y for coordinate data in FUnits
	short yMax;

	union {
		struct { // Simple Glyph
			// Array of last points of each contour
			// sizeOfArray = glyf.numberOfContours
			ushort[] endPtsOfContours;

			// The bounding rectangle for each character is defined as the
			// rectangle with a lower-left corner of (xMin, yMin) and an
			// upper-right corner of (xMax, yMax).

			// Array of instruct ions for each glyph.
			// sizeOfArray = simpleglyphdesc.instructionLength
			ubyte[] instructions;

			// Whether or not the point is on the curve
			bool[] isOnCurve;

			// First coordinates relative to (0,0), rest are relative
			// to the previous point
			// sizeOfArray = endPtsOfContours[$-1]+1
			short[] xCoordinates;
			short[] yCoordinates;
		}

		CompositeData[] components;
	}
}

align(1) struct GlyphDataTable {
	// If the number of contours is greater than or equal to zero,
	// this is a 'simple' glyph.

	// If negative, this is a composite glyph.
	short numberOfContours;

	// Minimum x for coordinate data in FUnits
	short xMin;

	// Minimum y for coordinate data in FUnits
	short yMin;

	// Maximum x for coordinate data in FUnits
	short xMax;

	// Maximum y for coordinate data in FUnits
	short yMax;

	// The bounding rectangle for each character is defined as the
	// rectangle with a lower-left corner of (xMin, yMin) and an
	// upper-right corner of (xMax, yMax).
}

// hdmx (Horizontal Device Metrics)

align(1) struct DeviceRecord {
	// Pixel size for following widths (as ppem)
	ubyte pixelSize;

	// Maximum Width
	ubyte maximumWidth;

	// Widths[numGlyphs] (numGlyphs is from the maxp table
	ubyte[] widths;
}

align(1) struct HorizontalDeviceMetricsTable {
	// Version Number (starts at 0)
	ushort tableVersion;

	// number of device records
	short deviceRecordCount;

	// size of a device record, int aligned
	int deviceRecordSize;

	// Records[number of device records]
	DeviceRecord[] deviceRecords;
}

// head (Font Header)
align(1) struct FontHeaderTable {
	// Table version number
	short tableVersionMajor;
	ushort tableVersionMinor;

	// Font revision number
	short fontRevisionMajor;
	ushort fontRevisionMinor;

	// Set to 0x5f0f3cf5
	uint magicNumber;

	// bit 0 - baseline for font at y = 0
	// bit 1 - left sidebearing at x = 0
	// bit 2 - instruct ions may depend on point size
	// bit 3 - force ppem to integer values for all
	//		   internal scalar math; may use fractional ppem
	//		   sizes if this bit is clear
	// bit 4 - instruct ions may alter advance width
	//		   (the advance widths might not scale linearly)
	// all other bits must be zero
	ushort flags;

	// Valid range is from 16 to 16384
	ushort unitsPerEm;

	// International data (8-byte field)
	long created;
	long modified;

	// For all glyph bounding boxes (in FUnits)
	short xMin;
	short yMin;
	short xMax;
	short yMax;

	// Bit 0 - bold
	// Bit 1 - italic
	// All other bits set to zero and reserved
	ushort macStyle;

	// smallest readable size in pixels
	ushort lowestRecPPEM;

	//  0 = Fully mixed directional glyphs
	//  1 = Only strongly left to right
	//  2 = Like 1 but also contains neutrals
	// -1 = Only strongly right to left
	// -2 = Like -1 but also contains neutrals
	short fontDirectionHint;

	// 0 for short offsets, 1 for long
	short indexToLocFormat;

	// 0 for current format
	short glyphDataFormat;
}

// hhea (Horizontal Header)
// ------------------------
// This table contains information for horizontal layout.

align(1) struct HorizontalHeaderTable {
	short tableVersionMajor;
	ushort tableVersionMinor;

	// Typographic ascent in FUnits
	short ascender;

	// Typographic descent in FUnits
	short descender;

	// Typographic line gap in FUnits
	short lineGap;

	// Maximum advance width in hmtx table (in FUnits)
	ushort advanceWidthMax;

	// Minimum left and right sidebearing value in hmtx table (in FUnits)
	short minLeftSideBearing;
	short minRightSideBearing;

	// Max(lsb + (xMax - xMin)) in FUnits
	short xMaxExtent;

	// Used to calculate the slope of the cursor (rise/run)
	// rise of 1 over run of 0 for vertical
	short caretSlopeRise;
	short caretSlopeRun;

	short reserved1;
	short reserved2;
	short reserved3;
	short reserved4;
	short reserved5;

	// 0 for current format
	short metricDataFormat;

	// number of hMetric entries in 'hmtx' table.
	// may be smaller than the total number of glyphs in the font
	ushort numberOfHMetrics;
}

// hmtx (Horizontal Metrics)

align(1) struct LongHorMetric {
	// In FUnits
	ushort advanceWidth;
	short lsb;
}

align(1) struct HorizontalMetricsTable {
	// Paird advance width and left side bearing values for each
	// glyph. sizeOfArray = hhea.numberOfHMetrics (see above)
	LongHorMetric[] hMetrics;

	// Here the advanceWidth is assumed to be the same as the advanceWidth
	// for the last entry above. The number of entries is derived from numGlyphs
	// (from the maxp table) minus numberOfHMetrics. This is generally used
	// with a run of monospaced glyphs (e.g. Kanji fonts or Courier fonts)
	short[] leftSideBearing;
}

// kern (Kerning)
// --------------
// The kerning table contains the values that control the intercharacter
// spacing for the glyphs in a font.

align(1) struct KernelSubTable {
	// version number
	ushort subtableVersion;

	// Length of subtable in bytes (including the header)
	ushort length;

	// What type of information is contained in this table.
	ushort coverage;
	// Bit(s)
	// 0	- 1 if the table has horizontal data, 0 if vertical
	// 1	- when set, the table has minimum values, otherwise
	//		- it has kerning values
	// 2	- If set to 1, kerning is perpendiculat to the flow
	//		- of the text.
	//		- That is, if the text is normally horizontal, the
	//		- kerning will be done in an up and down direction.
	//		- Otherwise, it is done in a left and right direction.
	//		- Where negative values are left and down, and positive
	//		- are right and up.
	// 3	- When 1, the value in this table should replace the
	//		- value currently being accumulated.
	// 4-7	- Reserved (should be zero)
	// 8-15	- Format of the subtable. Only formats 0 and 2 have
	//		- been defined. All others reserved.
}

// The kernel table in the TTF file has a header which contains the format
// number and the number of subtables present. It also contains the subtables
// themselves.
align(1) struct KerningTable {
	// Table version number (starts at 0)
	ushort tableVersion;

	// Number of subtables in the kerning table
	ushort nTables;
}

align(1) struct KerningPair {
	// The glyph index for the left-hand glyph in the kerning pair;
	ushort left;

	// The glyph index for the right-hand glyph in the kerning pair;
	ushort right;

	// The kerning value for the above pair in FUnits.
	// If this value is greater than zero, the characters will
	// be moved apart. If this value is less than zero, the character
	// will be moved closer together.
	short value;
}

align(1) struct KerningSubtable0 {
	// Number of kerning pairs in the table
	ushort nPairs;

	// The largest power of two less than or equal to the value
	// of nPairs, multiplied by the size in bytes of an entry in the
	// table.
	ushort searchRange;

	// This is calculated as log_2 of the largest power of two less than
	// or equal to the value of nPairs. This value indicates how many
	// iterations of the search loop will have to be made.
	// (For example, in a list of eight items, there would have to be
	// three iterations of the loop)
	ushort entrySelector;

	// The value of nPairs minus the largest power of two less than or
	// equal to nPairs, and then multiplied by the size in bytes of an
	// entry in the table.
	ushort rangeShift;

	// A list of kerning pairs follows.
	// sizeOfArray = nPairs
	KerningPair[] kerningPairs;
}

align(1) struct KerningClassTable {
	// First glyph in class range
	ushort firstGlyph;

	// Number of glyphs in class range.
	ushort nGlyphs;

	// Class values
	// sizeOfArray = nGlyphs
	ushort[] classValues;
}

align(1) struct KerningSubtable2 {
	// The width in bytes of a row in the table.
	ushort rowWidth;

	// offset from beginning of this subtable to left-hand class table.
	ushort leftClassTable;

	// offset from beginning of this subtable to right-hand class table.
	ushort rightClassTable;

	// offset from beginning of this subtable to the start of the
	// kerning array
	ushort array;
}

// loca (Index to Location)
// ------------------------
// The indexToLoc table stores the offsets to the locations of the glyphs
// in the font relative to the beginning of the glyphData table.

// depending on head.indexToLocFormat, either the short or long versions of
// the table could be used:

align(1) struct IndexToLocationShortTable {
	// The actual local offset divided by 2 is stored.
	// sizeOfArray = maxp.numGlyphs + 1
	ushort[] offsets;
}

align(1) struct IndexToLocationLongTable {
	// The actual local offset is stored.
	// sizeOfArray = maxp.numGlyphs + 1
	uint[] offsets;
}

// LTSH (Linear Threshold)

align(1) struct LinearThresholdTable {
	// Version number (starts at 0)
	ushort tableVersion;

	// number of glyphs (from "numGlyphs" in maxp table)
	ushort numGlyphs;

	// the vertical pel height at which the glyph can be assumed
	// to scale linearly. On a per glyph basis.
	// sizeOfArray = numGlyphs
	ubyte[] yPels;
}

// maxp (Maximum Profile)
// ----------------------
// This table establishes the memory requirements for this font.

align(1) struct MaximumProfile {
	// Table version.
	short tableVersionMajor;
	ushort tableVersionMinor;

	// The number of glyphs in the font.
	ushort numGlyphs;

	// Maximum points in a non-composite glyph.
	ushort maxPoints;

	// Maximum contours in a non-composite glyph.
	ushort maxContours;

	// Maximum points in a composite glyph.
	ushort maxCompositePoints;

	// Maximum contours in a composite glyph.
	ushort maxCompositeContours;

	// 1 if instruct ions do not use the twilight zone (Z0) or
	// 2 if instruct ion do use this zone
	// should be set to 2 in most cases
	ushort maxTwilightPoints;

	// Number of Storage Area ;ocations.
	ushort maxStorage;

	// Number of FDEFs
	ushort maxFunctionDefs;

	// Number of IDEFs
	ushort maxInstructionDefs;

	// Maximum stack depth
	ushort maxStackElements;

	// Maximum byte count for glyph instruct ions
	ushort maxSizeOfInstructions;

	// Maximum number of components
	ushort maxComponentElements;

	// Maximum levels of recursion (1 for simple components)
	ushort maxComponentDepth;
}

// name (Naming Table)
// -------------------
// The naming table allows multilingual strings to be associated
// with the TTF file.

align(1) struct NameRecord {
	ushort platformID;
	ushort encodingID;
	ushort languageID;

	// 0 = copyright
	// 1 = font family
	// 2 = font subfamily
	// 3 = unique identifier
	// 4 = full font name
	// 5 = version (n.nn format)
	// 6 = Postscript name
	// 7 = trademark
	ushort nameID;
	ushort stringLength;
	ushort stringOffset;
}

align(1) struct NamingTable {
	// Format selector (= 0)
	ushort format;

	// number of NameRecords that follow
	ushort numNameRecords;

	// offset to start of string storage (from start of table)
	ushort offset;

	NameRecord[] nameRecords;
}

// OS/2 (OS/2 and Windows Metrics)

enum FamilyKind : ubyte {
	Any,
	NoFit,
	TextAndDisplay,
	Script,
	Decorative,
	Pictorial
}

enum SerifStyle : ubyte {
	Any,
	NoFit,
	Cove,
	ObtuseCove,
	SquareCove,
	ObtuseSquareCove,
	Square,
	Thin,
	Bone,
	Exaggerated,
	Triangle,
	NormalSans,
	ObtuseSan,
	PerpSans,
	Flared,
	Rounded
}

enum Weight : ubyte {
	Any,
	NoFit,
	VeryLight,
	Light,
	Thin,
	Book,
	Medium,
	Demi,
	Bold,
	Heavy,
	Black,
	Nord
}

enum Proportion : ubyte {
	Any,
	NoFit,
	OldStyle,
	Modern,
	EvenWidth,
	Expanded,
	Condensed,
	VeryExpanded,
	VeryCondensed,
	Monospaced
}

enum Contrast : ubyte {
	Any,
	NoFit,
	None,
	VeryLow,
	Low,
	MediumLow,
	Medium,
	MediumHigh,
	High,
	VeryHigh
}

enum StrokeVariation : ubyte {
	Any,
	NoFit,
	GradualDiagonal,
	GradualTransitional,
	GradualVertical,
	GradualHorizontal,
	RapidVertical,
	RapidHorizontal,
	InstantVertical
}

enum ArmStyle : ubyte {
	Any,
	NoFit,
	StraightArmsHorizontal,
	StraightArmsWedge,
	StraightArmsVertical,
	StraightArmsSingleSerif,
	StraightArmsDoubleSerif,
	NonStraightArmsHorizontal,
	NonStraightArmsWedge,
	NonStraightArmsVertical,
	NonStraightArmsSingleSerif,
	NonStraightArmsDoubleSerif
}

enum Letterform : ubyte {
	Any,
	NoFit,
	NormalContact,
	NormalWeighted,
	NormalBoxed,
	NormalFlattened,
	NormalRounded,
	NormalOffCenter,
	NormalSquare,
	ObliqueContact,
	ObliqueWeighted,
	ObliqueBoxed,
	ObliqueFlattened,
	ObliqueRounded,
	ObliqueOffCenter,
	ObliqueSquare
}

enum Midline : ubyte {
	Any,
	NoFit,
	StandardTrimmed,
	StandardPointed,
	StandardSerifed,
	HighTrimmed,
	HighPointed,
	HighSerifed,
	ConstantTrimmed,
	ConstantPointed,
	ConstantSerifed,
	LowTrimmed,
	LowPointed,
	LowSerifed
}

enum XHeight : ubyte {
	Any,
	NoFit,
	ConstantSmall,
	ConstantStandard,
	ConstantLarge,
	DuckingSmall,
	DuckingStandard,
	DuckingLarge
}

align(1) struct PANOSE {
	FamilyKind bFamilyType;
	SerifStyle bSerifStyle;
	Weight bWeight;
	Proportion bProportion;
	Contrast bContrast;
	StrokeVariation bStrokeVariation;
	ArmStyle bArmStyle;
	Letterform bLetterform;
	Midline bMidline;
	XHeight bXHeight;
}

align(1) struct OS2WindowsMetricsTable {
	// OS/2 table version number
	ushort tableVersion;

	// Average weighted escapement
	short xAvgCharWidth;

	// Weight class (100 (thin), 200 (extra-light), 300 (light), etc)
	ushort usWeightClass;

	// Width class (ultra-condensed, etc)
	ushort usWidthClass;

	// Type flags
	short fsType;

	// The recommended horizontal size in font design units for
	// subscripts for this font.
	short ySubscriptXSize;

	// The recommended vertical size in font design units for
	// subscripts for this font.
	short ySubscriptYSize;

	// The recommended horizontal offset in font design units from
	// the baseline for subscripts for this font.
	short ySubscriptXOffset;

	// The recommended horizontal offset in font design units for
	// subscripts for this font.
	short ySubscriptYOffset;

	// The recommended horizontal size in font design units for
	// superscripts for this font.
	short ySuperscriptXSize;

	// The recommended vertical size in font design units for
	// superscripts for this font.
	short ySuperscriptYSize;

	// The recommended horizontal offset in font design units for
	// superscripts for this font.
	short ySuperscriptXOffset;

	// The recommended vertical offset in font design units from
	// the baseline for superscripts for this font.
	short ySuperscriptYOffset;

	// Width of strikeout stroke in font design units
	short yStrikeoutSize;

	// The position of the strikeout stroke relative to the baseline in
	// font design units
	short yStrikeoutPosition;

	// A classification of font-family design
	short sFamilyClass;

	// The 10-byte series describes the visual characteristics of a
	// given typeface.
	PANOSE panose;

	// Specifies the unicode blocks or ranges emcompassed by the font file
	// in the cmap subtable for platform 3, encoding 1
	uint ulUnicodeRange1;
	uint ulUnicodeRange2;
	uint ulUnicodeRange3;
	uint ulUnicodeRange4;

	// Font vendor information
	char[4] achVendID;

	// Font selection flags
	ushort fsSelection;

	// The minimum unicode index in this font according to cmap table
	ushort usFirstCharIndex;

	// The maximum unicode index in this font according to cmap table
	ushort usLastCharIndex;

	// Typographic ascender for this font (not the same as in hhea table)
	ushort sTypoAscender;

	// Typographic descender for this font (not the same as in hhea table)
	ushort sTypoDescender;

	// Typographic line gap for this font (not the same as in hhea table)
	ushort sTypoLineGap;

	// Ascender metric for Windows (different from all other ascender values)
	// computed as yMax for all characters in the Windows ANSI character set
	ushort usWinAscent;

	// Descender metric for Windows (different from all other descender values)
	// computed as -yMin for all characters in the Windows ANSI character set
	ushort usWinDescent;

	// Specifies code pages emcompassed by the font file
	uint ulCodePageRange1;
	uint ulCodePageRange2;
}