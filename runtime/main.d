/*
 * main.d
 *
 * This module provides the C entry into the application.
 *
 */

module runtime.main;

import runtime.gc;

// The user supplied D entry
int main(char[][] args);

// Description: This function is the main entry point of the application.
// argc: The number of arguments
// argv: An array of strings that specify the arguments.
// Returns: The error code for the application.
import binding.c;

extern(C) int main(int argc, char** argv) {
	// Initialize the garbage collector
	gc_init();

	// Gather arguments
	main([]);

	// Terminate the garbage collector
	gc_term();
	return 0;
}
