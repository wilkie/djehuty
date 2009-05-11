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

		it should_handle_lazy_kleene_star()
		{
			String str = Regex.work("<EM>some text</EM>", `<.*?>`);
			should(str == "<EM>");
		}

		it should_handle_kleene_plus()
		{
			String str = Regex.work("<>EM>some text</EM>", `<.+>`);
			should(str == "<>EM>some text</EM>");
		}

		it should_handle_lazy_kleene_plus()
		{
			String str = Regex.work("<>EM>some text</EM>", `<.+?>`);
			should(str == "<>EM>");
		}

		it should_handle_options()
		{
			String str = Regex.work("abc", `a?abc`);
			should(str == "abc");
			
			str = Regex.work("aabc", `a?abc`);
			should(str == "aabc");

			str = Regex.work("ababbababababbbc", `(a?b)*c`);
			should(str == "ababbababababbbc");
		}

		it should_handle_optional_groups()
		{
			String str = Regex.work("abcdefeggfoo", `abc(egg|foo)?def(egg|foo)?(egg|foo)?`);
			should(str == "abcdefeggfoo");
		}

		it should_handle_union_at_base_level()
		{
			String str = Regex.work("dogbert", `cat|dog`);
			should(str == "dog");
		}

		it should_handle_union_at_group_level()
		{
			String str = Regex.work("bacd", `(bac|b)acd`);
			should(str == "bacd");
		}

		it should_handle_union_with_kleene_star()
		{
			String str = Regex.work("catdog", `(cat|dog)*`);
			should(str == "catdog");
		}

		it should_handle_nested_groups()
		{
			String str = Regex.work("catbert", `(cat(bert))`);
			should(str == "catbert");
		}

		it should_handle_nested_groups_with_union()
		{
			String str = Regex.work("dogpoo", `(dog(bert|poo))`);
			should(str == "dogpoo");
		}

		it should_handle_character_classes()
		{
			String str = Regex.work("daccabaaccbg", `d[abc]*g`);
			should(str == "daccabaaccbg");

			str = Regex.work("daccabadaccbg", `d[abc]*g`);
			should(str == "daccbg");
		}
		
		it should_handle_dollar_sign()
		{
			String str = Regex.work("root woot moot foot", `.oot$`);
			should(str == "foot");

			str = Regex.work("root\nwoot\nmoot\nfoot", `.oot$`);
			should(str == "root");
		}

		it should_handle_beginning_of_line_caret()
		{
			String str = Regex.work("root woot moot foot", `^.oot`);
			should(str == "root");

			str = Regex.work(" root\nwoot\nmoot\nfoot", `^.oot`);
			should(str == "woot");
		}
	}
}
