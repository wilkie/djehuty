/*
 * nodes.d
 *
 * This module lists the possible parse tree nodes for the D parser.
 *
 * Author: Dave Wilkinson
 * Originated: February 6th 2010
 *
 */

module parsing.d.nodes;

enum DNode : uint {
	Module, // module bleh.foo; => ModuleName
	Import, // import bleh.foo; => ModuleName
	ModuleName, // "foo.foo"
	Block, // { ... }
}
