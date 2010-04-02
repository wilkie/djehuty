/*
 * system.d
 *
 * This module implements a class that can be used to query information
 * about the system.
 *
 */

module core.system;

import scaffold.system;
import scaffold.directory;
import scaffold.time;

import core.locale : LocaleId;
import core.time;
import core.timezone;

import io.directory;
import io.console;

// Description: This class gives the developer a means to query common parameters about devices and configurations of the system.
class System {
	static:
	public:

	class Displays {
		static:
		public:

		uint count() {
			return SystemGetDisplayCount();
		}

		uint primary() {
			return SystemGetPrimaryDisplay();
		}

		int width(uint index) {
			return SystemGetDisplayWidth(index);
		}

		int height(uint index) {
			return SystemGetDisplayHeight(index);
		}
	}

	class Display {
		static:
		public:

		int width() {
			return SystemGetDisplayWidth(Displays.primary);
		}

		int height() {
			return SystemGetDisplayHeight(Displays.primary);
		}
	}

	class Memory {
		static:
		public:

		ulong total() {
			return SystemGetTotalMemory();
		}

		ulong available() {
			return SystemGetAvailableMemory();
		}
	}

	class FileSystem {
		static:
		public:

		// Description: This function will return the Directory representing the current directory.
		// Returns: The Directory representing the working directory.
		Directory currentDir() {
			return Directory.open(DirectoryGetCWD());
		}

		// Description: This function will return the Directory representing the directory the executable is located in. It should not be relied on completely, as this information can be incorrect or non-existent.
		// Returns: The Directory representing the executable location.
		Directory applicationDir() {
			return Directory.open(DirectoryGetApp());
		}

		// Description: This function will return the Directory representing the system's temporary files directory. Persistance is not guaranteed.
		// Returns: The Directory representing the temp location.
		Directory tempDir() {
			Directory retdir = Directory.open(DirectoryGetTempData());
			if (retdir is null)
			{
				Console.putln("suckin it up");
				retdir = new Directory(DirectoryGetTempData());
			}
			return retdir;
			//return Directory.open(DirectoryGetTempData());
		}

		// Description: This function will return the Directory representing the system's temporary files directory. Persistance is not guaranteed.
		// Returns: The Directory representing the temp location.
		Directory appDataDir() {
			return Directory.open(DirectoryGetAppData());
		}

		// Description: This function will return the Directory representing the system's temporary files directory. Persistance is not guaranteed.
		// Returns: The Directory representing the temp location.
		Directory userDataDir() {
			return Directory.open(DirectoryGetUserData());
		}

		// Description: This function will return the Directory representing the system's temporary files directory. Persistance is not guaranteed.
		// Returns: The Directory representing the temp location.
		Directory binaryDir() {
			return Directory.open(DirectoryGetBinary());
		}
	}
	
	class Locale {
		static:
		public:

			LocaleId id() {
				return SystemGetLocaleId();
			}

			TimeZone timezone() {
				return new TimeZone();
			}
	}

	long time() {
		return SystemTimeGet();
	}
}
