module drawing.font;

class Font {
private:
	double _size;

	bool _bold;
	bool _italic;
	bool _underscore;
	bool _strikethru;

	string _name;

public:

	// Constructors

	this(string name, double size, bool bold = false, bool italic = false, bool underline = false, bool strikethru = false) {
		_size = size;
		_bold = bold;
		_italic = italic;
		_underscore = underscore;
		_strikethru = strikethru;

		_name = name.dup;
	}

	// Methods

	// Properties

	double size() {
		return _size;
	}

	bool bold() {
		return _bold;
	}

	bool italic() {
		return _italic;
	}

	bool strikethru() {
		return _strikethru;
	}

	bool underscore() {
		return _underscore;
	}

	string name() {
		return _name.dup;
	}
}