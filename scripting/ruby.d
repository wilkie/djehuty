module scripting.ruby;

import binding.ruby.ruby;

class RubyScript {
private:
	static bool _inited = false;
	static void _init() {
		ruby_init();
		ruby_init_loadpath();
		rb_set_safe_level(0);
		ruby_script("ruby");

		_inited = true;
	}

	int _status;

public:

	this() {
		// XXX: SYNCHRONIZE
		if (!_inited) {
			_init();
		}
	}

	void eval(string code) {
		rb_eval_string_protect((code ~ '\0').ptr, &_status);
	}
}
