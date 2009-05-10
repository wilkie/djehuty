module specs.core.regex;

import testing.support;

import core.string;
import core.regex;

describe regex()
{
	describe work()
	{
		it should_handle_kleene_star()
		{
			String str = Regex.work("<EM>some text</EM>", `<.*>`);
			should(str == "<EM>some text</EM>");
		}
	}
}
