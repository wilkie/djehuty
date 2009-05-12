module specs.core.regex;

import testing.support;

import core.string;
import core.regex;

describe regex()
{
	describe eval()
	{
		it should_handle_kleene_star()
		{
			String str = Regex.eval("<EM>some text</EM>", `<.*>`);
			should(str == "<EM>some text</EM>");
		}

		it should_handle_lazy_kleene_star()
		{
			String str = Regex.eval("<EM>some text</EM>", `<.*?>`);
			should(str == "<EM>");
		}

		it should_handle_kleene_plus()
		{
			String str = Regex.eval("<>EM>some text</EM>", `<.+>`);
			should(str == "<>EM>some text</EM>");
		}

		it should_handle_lazy_kleene_plus()
		{
			String str = Regex.eval("<>EM>some text</EM>", `<.+?>`);
			should(str == "<>EM>");
		}

		it should_handle_options()
		{
			String str = Regex.eval("abc", `a?abc`);
			should(str == "abc");
			
			str = Regex.eval("aabc", `a?abc`);
			should(str == "aabc");

			str = Regex.eval("ababbababababbbc", `(a?b)*c`);
			should(str == "ababbababababbbc");
		}

		it should_handle_optional_groups()
		{
			String str = Regex.eval("abcdefeggfoo", `abc(egg|foo)?def(egg|foo)?(egg|foo)?`);
			should(str == "abcdefeggfoo");
		}

		it should_handle_union_at_base_level()
		{
			String str = Regex.eval("dogbert", `cat|dog`);
			should(str == "dog");
		}

		it should_handle_union_at_group_level()
		{
			String str = Regex.eval("bacd", `(bac|b)acd`);
			should(str == "bacd");
		}

		it should_handle_union_with_kleene_star()
		{
			String str = Regex.eval("catdogdogcatbert", `(cat|dog)*`);
			should(str == "catdogdogcat");
		}

		it should_handle_nested_groups()
		{
			String str = Regex.eval("catbert", `(cat(bert))`);
			should(str == "catbert");
		}

		it should_handle_nested_groups_with_union()
		{
			String str = Regex.eval("dogpoo", `(dog(bert|poo))`);
			should(str == "dogpoo");
		}

		it should_handle_character_classes()
		{
			String str = Regex.eval("daccabaaccbg", `d[abc]*g`);
			should(str == "daccabaaccbg");

			str = Regex.eval("daccabadaccbg", `d[abc]*g`);
			should(str == "daccbg");

			str = Regex.eval("daccabadaccbg", `^d[abc]*g`);
			should(str is null);
		}
		
		it should_handle_inverse_character_classes()
		{
			String str = Regex.eval("ddeffegggdefeddfeg", `d[^abc]*g`);
			should(str == "ddeffegggdefeddfeg");
			
			str = Regex.eval("ddeffegggdefeddfeg", `d[^abc]*?g`);
			should(str == "ddeffeg");

			str = Regex.eval("ddeffeagggdefeddfeg", `d[^abc]*?g`);
			should(str == "defeddfeg");
		}
		
		it should_handle_dollar_sign()
		{
			String str = Regex.eval("root woot moot foot", `.oot$`);
			should(str == "foot");

			str = Regex.eval("root\nwoot\nmoot\nfoot", `.oot$`);
			should(str == "root");
		}

		it should_handle_beginning_of_line_caret()
		{
			String str = Regex.eval("root woot moot foot", `^.oot`);
			should(str == "root");

			str = Regex.eval(" root\nwoot\nmoot\nfoot", `^.oot`);
			should(str == "woot");
		}
	}
}
