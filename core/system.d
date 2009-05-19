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
}