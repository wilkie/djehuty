/*
 * resource.d
 *
 * This file has the logic behind loading a resource from a resource file or
 * a resource stream.
 *
 * Author: Dave Wilkinson
 *
 */

module core.resource;

import core.string;
import core.image;
import core.endian;
import core.menu;
import core.stream;
import core.unicode;

import io.file;
import io.console;

static const bool flagCheckForMenuRecursion = true;

// Section: Core/Resources

// Description: This class facilitates the retreival of compiled resources from a Djehuty resource file (rsc).  The file allows multiple languages and is designed to be efficient and fast.  The resources include Strings and Images at this time.  The strings are stored with a language specific Unicode format.  The resource file allows an application to support multiple locales which can be switched on the fly.  The default language will always be the current locale unless it is missing from the resource file, in which case the first language listed in the file will be the default language upon a file load.

// Feature: You can have more than one resource file in use. (Flexibility)
// Feature: You can either have a resource file for each language, or one file for all languages. (Flexibility)
// Feature: All languages can be supported eventually. (Scalablity)
// Feature: Supports a resource file up to 4 gigabytes, supports a file with at least 1000 languages! (Scalablity)
class Resource {

	// Description: Will create the object and then load the file specified.
	// filename: The path and filename of the resource file.
	this(string filename) {
		open(filename);
	}

	// Description: Will create the object and then load the file specified.
	// filename: The path and filename of the resource file.
	this(String filename) {
		open(filename);
	}

	// Description: Will create the object using the specified array as the resource database. This is for static resource information stored within the executable.
	// fromArray: The byte array to stream from.
	this(ubyte[] fromArray) {
		_file = new Stream(fromArray);

		_stream();
	}

	// Methods //

	// Description: Will open the filename specified.
	// filename: The path and filename of the resource file.
	void open(string filename) {
		_filename = new String(filename);

		_open();
	}

	// Description: Will open the filename specified.
	// filename: The path and filename of the resource file.
	void open(String filename) {
		_filename = new String(filename);

		_open();
	}

	// Description: Will close the file.
	void close() {
		_file = null;
	}

	// Description: Will set the current language to the one given by the parameter if it exists within the file.
	// langID: The standard language ID for the language you wish to use.
	void language(uint langID) {
		// check for validity
		if (_file is null) { return; }

		if (_langTable is null || _langTable.length == 0) { return; }

		foreach(int i, uint lang; _langTable) {
			if (lang == langID) {
				_langIndex = i;
				return;
			}
		}

		// error: unknown language
		return;
	}

	// -- //

	// Description: Will traverse the resource stream and grab the String from the file.
	// resourceID: The specific String resource to grab.
	// Returns: The String resource.
	String loadString(uint resourceID) {
		Console.putln("loading string...");

		// get the string from the file for the current language
		if (_file is null) { return null; }

		if (resourceID > _stringOffsets.length) { return null; }

		if (_stringAccessed[resourceID] !is null) { return _stringAccessed[resourceID]; }

		_file.rewind();
		//Console.putln("cur pos: ", _file.getPosition());

		ulong skipLen = void;
		uint langOffset = void;

		// Get the language offset we need!

		if (_langIndex > 0) {
			skipLen = _stringOffsets[resourceID];
			skipLen += uint.sizeof * (_langIndex-1);
			//Console.putln("skip: ", skipLen);
			_file.skip(skipLen);

			_file.read(langOffset);
			skipLen = langOffset - skipLen - 4;
			//Console.putln("skip: ", skipLen);
		}
		else {
			skipLen = _stringOffsets[resourceID];
			skipLen += uint.sizeof * (_numLang-1);
			//Console.putln("skip: ", skipLen);
		}

		_file.skip(skipLen);

		// read in string length

		uint stringLen;

		//Console.putln("cur pos: ", _file.getPosition());

		_file.read(stringLen);

		//Console.putln("string length: ", stringLen);

		dchar stringarr[] = new dchar[stringLen];

		_file.read(stringarr.ptr, stringLen * 4);

		String s = new String(Unicode.toUtf8(stringarr));

		_stringAccessed[resourceID] = s;

		return s;
	}

	// Description: Will traverse the resource stream and grab the Image from the file.
	// resourceID: The specific Image resource to grab.
	// Returns: The decoded Image resource.
	Image loadImage(uint resourceID) {
		Console.putln("loading image...");

		// get the image from the file
		if (_file is null) { return null; }

		if (resourceID > _imageOffsets.length) { return null; }

		if (_imageAccessed[resourceID] !is null) { return _imageAccessed[resourceID]; }

		_file.rewind();
		//Console.putln("cur pos: ", _file.getPosition());

		ulong skipLen = void;
		uint langOffset = void;

		// Get the language offset we need!

		if (_langIndex > 0) {
			skipLen = _imageOffsets[resourceID];
			skipLen += uint.sizeof * (_langIndex-1);
			//Console.putln("skip: ", skipLen);
			_file.skip(skipLen);

			_file.read(langOffset);
			skipLen = langOffset - skipLen - 4;
			//Console.putln("skip: ", skipLen);
		}
		else {
			skipLen = _imageOffsets[resourceID];
			skipLen += uint.sizeof * (_numLang-1);
			//Console.putln("skip: ", skipLen);
		}

		_file.skip(skipLen);

		// read in string length

		uint fileLen;

		//Console.putln("cur pos: ", _file.getPosition());

		_file.read(fileLen);

		//Console.putln("image file length: ", fileLen);

		Image img = new Image();

		img.load(_file);

		_imageAccessed[resourceID] = img;

		return img;
	}

	// Description: Will traverse the resource stream and grab the Menu and any associated Menu classes from the file.
	// resourceID: The specific Menu resource to grab.
	// Returns: The Menu resource with any sub menus it needs allocated and appended.
	Menu loadMenu(uint resourceID) {
		Console.putln("loading menu...");

		return _loadMenu(resourceID, null);
	}

private:

	String _filename;

	Stream _file;

	uint _langIndex;
	uint _curVersion;
	uint _numLang;

	uint _langTable[]; // the languages supported by the file

	uint _sectionOffsets[3]; // position in stream of the resource section
	uint _sectionCounts[3]; // number of resources of each resource section

	uint _stringOffsets[]; // position in the stream for the string resources
	uint _imageOffsets[]; // position in the stream for the string resources
	uint _menuOffsets[]; // position in the stream for the menu resources

	String _stringAccessed[];	// stores menus already pulled
	Image _imageAccessed[];	// stores menus already pulled
	Menu _menuAccessed[];	// stores menus already pulled

	// hidden function for grabbing a menu
	Menu _loadMenu(uint resourceID, uint[] subMenuIds) {
		// get the menu from the file
		if (_file is null) { return null; }

		if (resourceID > _menuOffsets.length) { return null; }

		if (_menuAccessed[resourceID] !is null) { return _menuAccessed[resourceID]; }

		_file.rewind();
		//Console.putln("cur pos: ", _file.getPosition());

		ulong skipLen = void;
		uint langOffset = void;

		// Get the language offset we need!

		if (_langIndex > 0) {
			skipLen = _menuOffsets[resourceID];
			skipLen += uint.sizeof * (_langIndex-1);
			//Console.putln("skip: ", skipLen);
			_file.skip(skipLen);

			_file.read(langOffset);
			skipLen = langOffset - skipLen - 4;
			//Console.putln("skip: ", skipLen);
		}
		else {
			skipLen = _menuOffsets[resourceID];
			skipLen += uint.sizeof * (_numLang-1);
			//Console.putln("skip: ", skipLen);
		}

		_file.skip(skipLen);

		// read in string length

		//Console.putln("cur pos: ", _file.getPosition());

		uint stringID;
		uint flags;
		uint imgID;
		uint x, y, w, h;
		uint numSubMenus;

		uint[] subMenuIDs;
		Menu[] subMenus;

		_file.read(stringID);
		_file.read(flags);
		_file.read(imgID);
		_file.read(x);
		_file.read(y);
		_file.read(w);
		_file.read(h);

		_file.read(numSubMenus);

		//Console.putln("menu string id: ", stringID);
		//Console.putln("menu flags: ", flags);
		//Console.putln("menu imgID: ", imgID, " ( ", x, ", ", y, " : ", w, " x ", h, " ) ");
		//Console.putln("menu submenu count: ", numSubMenus);

		// for every submenu, read in the id
		// then call this function recursively
		// when it is called recursively, the
		// stream's current position is invalidated
		// so we do this AFTER we read in the menu
		// IDs.

		uint mnuCount = 0;

		if (numSubMenus > 0) {
			// Do not allow recursive reading. (Security)
			// There is a lot of code devoted to avoiding this DoS style
			// attack from editing a resource file.

			subMenuIDs = new uint[numSubMenus];
			subMenus = new Menu[numSubMenus];

			_file.read(subMenuIDs.ptr, uint.sizeof * numSubMenus);

			// now for each, call this function
			foreach(uint i, mnuID; subMenuIDs) {
				if (subMenuIds !is null && flagCheckForMenuRecursion) {
					uint j = subMenuIds.length;

					foreach(uint z, mnuID_old; subMenuIds) {
						if (mnuID_old == subMenuIDs[i]) {
							j = z;
							break;
						}
					}

					if (j == subMenuIds.length) {
						subMenus[mnuCount] = _loadMenu(mnuID, subMenuIDs ~ subMenuIds);
						mnuCount++;
					}
					// else: recursive menu found
				}
				else {
					subMenus[mnuCount] = _loadMenu(mnuID, subMenuIDs);
					mnuCount++;
				}
			}
		}

		// getting the string invalidates the file
		// stream's current location
		String mnuString = loadString(stringID);

		Menu mnu;

		if (mnuCount > 0) {
			if (subMenus.length > mnuCount) {
				subMenus = subMenus[0..mnuCount];
			}
			mnu = new Menu(mnuString, subMenus);
		}
		else {
			mnu = new Menu(mnuString);
		}

		_menuAccessed[resourceID] = mnu;

		return mnu;
	}

	// hidden function, opens and parses always relevant data
	void _open() {
		_file = new File(_filename);

		_stream();
	}

	void _stream() {
		// read in the headers
		uint magic;

		_file.read(magic);
		if (FromLittleEndian32(magic) != 0x53524a44) {
			// error: not a valid resource file
			Console.putln("error: not a valid resource file");
			return;
		}

		//Console.putln("magic: DJRS");

		// read in version information
		if (!_file.read(_curVersion)) {
			// error: version expected, EOF found
			Console.putln("error: version expected, EOF found");
			return;
		}

		//Console.putln("version: ", _curVersion);

		// read in version information
		if (!_file.read(_numLang)) {
			// error: number of languages expected, EOF found
			Console.putln("error: number of languages expected, EOF found");
			return;
		}

		//Console.putln("num languages: ", _numLang);

		_file.skip(4);

		if (_numLang > 1000) {
			// error: over maximum language limit
			Console.putln("error: over maximum language limit");
			return;
		}

		_langTable = new uint[_numLang];

		// read in the language table
		if (!_file.read(_langTable.ptr, uint.sizeof * _numLang)) {
			// error: language table expected, EOF found
			Console.putln("error: language table expected, EOF found");
			return;
		}

		//Console.putln("languages: ", _langTable);

		// read in the section counts
		if (!_file.read(_sectionCounts.ptr, uint.sizeof * _sectionOffsets.length)) {
			// error: section count table expected, EOF found
			Console.putln("error: section count table expected, EOF found");
			return;
		}

		//Console.putln("section counts: ", _sectionCounts);

		// read in the section offsets
		if (!_file.read(_sectionOffsets.ptr, uint.sizeof * _sectionOffsets.length)) {
			// error: section offset table expected, EOF found
			Console.putln("error: section offset table expected, EOF found");
			return;
		}

		//Console.putln("section offsets: ", _sectionOffsets);



		/* STRINGS */



		// load string section information
		if (_sectionCounts[0] > 0) {
			_stringOffsets = new uint[_sectionCounts[0]];
			_stringAccessed = new String[_sectionCounts[0]];
		}

		// read in the string offsets
		if (_sectionCounts[0] > 1 || _sectionOffsets[0] > 0) {
			if (!_file.read((_stringOffsets.ptr + 1), uint.sizeof * (_sectionCounts[0]-1))) {
				// error: string offset table expected, EOF found
				Console.putln("error: string offset table expected, EOF found");
				return;
			}
		}

		if (_sectionCounts[0] > 0) {
			_stringOffsets[0] = cast(uint)_file.position;
		}

		// skip to the image section

		_file.skip(_sectionOffsets[1] - _file.position);




		/* IMAGES */




		// load image section information
		if (_sectionCounts[1] > 0) {
			_imageOffsets = new uint[_sectionCounts[1]];
			_imageAccessed = new Image[_sectionCounts[1]];
		}

		// read in the image offsets
		if (_sectionCounts[1] > 0 || _sectionOffsets[1] > 0) {
			if (!_file.read((_imageOffsets.ptr + 1), uint.sizeof * (_sectionCounts[1]-1))) {
				// error: image offset table expected, EOF found
				Console.putln("error: image offset table expected, EOF found");
				return;
			}
		}

		if (_sectionCounts[1] > 0) {
			_imageOffsets[0] = cast(uint)_file.position;
		}

		//Console.putln(_imageOffsets);
		// skip to the menu section

		_file.skip(_sectionOffsets[2] - _file.position);

		//Console.putln(_sectionOffsets[2] - _file.getPosition());


		/* MENUS */



		// load menu section information
		if (_sectionCounts[2] > 0) {
			_menuOffsets = new uint[_sectionCounts[2]];
			_menuAccessed = new Menu[_sectionCounts[2]];
		}

		// read in the menu offsets
		if (_sectionCounts[2] > 0 || _sectionOffsets[2] > 0) {
			if (!_file.read((_menuOffsets.ptr + 1), uint.sizeof * (_sectionCounts[2]-1))) {
				// error: image offset table expected, EOF found
				Console.putln("error: image offset table expected, EOF found");
				return;
			}
		}

		if (_sectionCounts[2] > 0) {
			_menuOffsets[0] = cast(uint)_file.position;
		}


		//Console.putln(_menuOffsets);


		// set _langID to the first language (default)
		_langIndex = 0;
	}
}
