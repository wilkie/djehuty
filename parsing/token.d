module parsing.token;

import core.variant;

struct Token {
	uint type;
	Variant value;

	uint column;
	uint line;

	uint columnEnd;
	uint lineEnd;
}
