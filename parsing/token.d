module parsing.token;

import core.variant;

struct Token {
	uint type;
	Variant value;
}