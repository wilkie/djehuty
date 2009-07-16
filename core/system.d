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

		uint getScreenCount() {
			return Scaffold.SystemGetDisplayCount();
		}

		uint getPrimary() {
			return Scaffold.SystemGetPrimaryDisplay();
		}

		int getWidth(uint index) {
			return Scaffold.SystemGetDisplayWidth(index);
		}

		int getHeight(uint index) {
			return Scaffold.SystemGetDisplayHeight(index);
		}
	}
	
	class Display {
		static:
		public:

		int getWidth() {
			return Scaffold.SystemGetDisplayWidth(Displays.getPrimary());
		}

		int getHeight() {
			return Scaffold.SystemGetDisplayHeight(Displays.getPrimary());
		}
	}

	class Memory {
		static:
		public:

		ulong getTotal() {
			return Scaffold.SystemGetTotalMemory();
		}

		ulong getAvailable() {
			return Scaffold.SystemGetAvailableMemory();
		}
	}
	
	class FileSystem {
		static:
		public:

		// Description: This function will return the Directory representing the current directory.
		// Returns: The Directory representing the working directory.
		Directory getCurrentDir() {
			return new Directory(Scaffold.DirectoryGetCWD());
		}
	
		// Description: This function will return the Directory representing the directory the executable is located in. It should not be relied on completely, as this information can be incorrect or non-existent.
		// Returns: The Directory representing the executable location.
		Directory getApplicationDir() {
			return new Directory(Scaffold.DirectoryGetApp());
		}
	
		// Description: This function will return the Directory representing the system's temporary files directory. Persistance is not guaranteed.
		// Returns: The Directory representing the temp location.
		Directory getTempDir() {
			return new Directory(Scaffold.DirectoryGetTempData());
		}

		// Description: This function will return the Directory representing the system's temporary files directory. Persistance is not guaranteed.
		// Returns: The Directory representing the temp location.
		Directory getAppDataDir() {
			return new Directory(Scaffold.DirectoryGetAppData());
		}

		// Description: This function will return the Directory representing the system's temporary files directory. Persistance is not guaranteed.
		// Returns: The Directory representing the temp location.
		Directory getUserDataDir() {
			return new Directory(Scaffold.DirectoryGetUserData());
		}

		// Description: This function will return the Directory representing the system's temporary files directory. Persistance is not guaranteed.
		// Returns: The Directory representing the temp location.
		Directory getBinaryDir() {
			return new Directory(Scaffold.DirectoryGetBinary());
		}
	}
}