/*
 * system.d
 *
 * This module implements a class that can be used to query information
 * about the system.
 *
 */

module core.system;

import platform.imports;
mixin(PlatformScaffoldImport!());

import io.directory;

// Description: This class gives the developer a means to query common parameters about devices and configurations of the system.
class System {
	static:
	public:

	class Displays {
		static:
		public:

		uint count() {
			return Scaffold.SystemGetDisplayCount();
		}

		uint primary() {
			return Scaffold.SystemGetPrimaryDisplay();
		}

		int width(uint index) {
			return Scaffold.SystemGetDisplayWidth(index);
		}

		int height(uint index) {
			return Scaffold.SystemGetDisplayHeight(index);
		}
	}

	class Display {
		static:
		public:

		int width() {
			return Scaffold.SystemGetDisplayWidth(Displays.primary);
		}

		int height() {
			return Scaffold.SystemGetDisplayHeight(Displays.primary);
		}
	}

	class Memory {
		static:
		public:

		ulong total() {
			return Scaffold.SystemGetTotalMemory();
		}

		ulong available() {
			return Scaffold.SystemGetAvailableMemory();
		}
	}

	class FileSystem {
		static:
		public:

		// Description: This function will return the Directory representing the current directory.
		// Returns: The Directory representing the working directory.
		Directory currentDir() {
			return new Directory(Scaffold.DirectoryGetCWD());
		}

		// Description: This function will return the Directory representing the directory the executable is located in. It should not be relied on completely, as this information can be incorrect or non-existent.
		// Returns: The Directory representing the executable location.
		Directory applicationDir() {
			return new Directory(Scaffold.DirectoryGetApp());
		}

		// Description: This function will return the Directory representing the system's temporary files directory. Persistance is not guaranteed.
		// Returns: The Directory representing the temp location.
		Directory tempDir() {
			return new Directory(Scaffold.DirectoryGetTempData());
		}

		// Description: This function will return the Directory representing the system's temporary files directory. Persistance is not guaranteed.
		// Returns: The Directory representing the temp location.
		Directory appDataDir() {
			return new Directory(Scaffold.DirectoryGetAppData());
		}

		// Description: This function will return the Directory representing the system's temporary files directory. Persistance is not guaranteed.
		// Returns: The Directory representing the temp location.
		Directory userDataDir() {
			return new Directory(Scaffold.DirectoryGetUserData());
		}

		// Description: This function will return the Directory representing the system's temporary files directory. Persistance is not guaranteed.
		// Returns: The Directory representing the temp location.
		Directory binaryDir() {
			return new Directory(Scaffold.DirectoryGetBinary());
		}
	}
}