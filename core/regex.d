module core.regex;

import core.string;

import console.main;

import utils.stack;

class Regex
{
	// Description: This constructor will create an instance of a Regex that will efficiently compute the regular expression given.
	// regex: The regular expression to utilize.
	this(String regex)
	{
		regularExpression = new String(regex);

		buildDFA();
	}

	this(StringLiteral regex)
	{
		regularExpression = new String(regex);
		
		buildDFA();
	}
	
	// Description: This function will return a matched regular expression on the given String. Instances of a Regex will use a DFA based approach.
	// str: The String to run the regular expression upon.
	// Returns: The matched substring or null when no match could be found.
	String work(String str)
	{
		return null;
	}

	String work(StringLiteral str)
	{
		return work(new String(str));
	}

	// Description: This function will return a matched regular expression on the given String. Single use regular expression functions, such as this one, use a backtracking algorithm.
	// str: The String to run the regular expression upon.
	// regex: The regular expression to use.
	// Returns: The matched substring or null when no match could be found.
	static String work(String str, String regex)
	{
		int strPos;
		int regexPos;

		int strPosStart;
		int regexPosStart;
		
		int flags;
		
		const int PLUS_OK = 1;
		const int LAZY_KLEEN = 2;
		
		bool hasFlag(int flag)
		{
			return (flags & flag) > 0;
		}
		
		void setFlag(int flag)
		{
			flags |= flag;
		}
		
		void resetFlag(int flag)
		{
			flags &= ~flag;
		}

		Stack!(int) stack = new Stack!(int)();
		stack.push(0);
		stack.push(0);
		stack.push(0);

		bool running = true;
		bool matchMade = true;
		bool backtrack = false;

		// a+b in "bbaaaaaaabb" matches "aaaaaaaab"
		//Console.putln("attempting s:", strPos, " r:", regexPos);

		while(running)
		{
			if (backtrack)
			{
				// steps are saved after successful matches
				// therefore the matchMade flag is always set
				matchMade = true;

				flags = stack.pop();
				strPos = stack.pop();
				regexPos = stack.pop();
				if (regexPos == 0)
				{
					strPosStart++;
					strPos = strPosStart;

					if (strPosStart >= str.length)
					{
						// bad
						matchMade = false;
						running = false;
					}
				}

				backtrack = false;
				//Console.putln("backtracking s:", strPos, " r:", regexPos);
			}

			if (regexPos >= regex.length)
			{
				if (matchMade)
				{
					// good
					running = false;
				}
				else
				{
					// backtrack
					backtrack = true;
				}
			}
			else if (regex[regexPos] == '*')
			{
				if ((regexPos < regex.length - 1) && regex[regexPos+1] == '?')
				{
					// lazy *
					if (hasFlag(LAZY_KLEEN))
					{
						// it must match here
						if (matchMade)
						{
							// good
							
							// the matcher matched the character
							// strPos points to the next to-be-matched character
							// and regexPos points to the kleen
							
							// here, the next step to match the kleen with another
							// character (in strPos)
							
							// the next step in this computation path is to match
							// the current charcter with the next regex operator
							//Console.putln("ok(*?) s:", strPos, " r:", regexPos);
							stack.push(regexPos-1);
							stack.push(strPos);
							stack.push(flags);
		
							// still processing
							regexPos+=2;
						}
						else
						{
							// bad
							backtrack = true;
						}
					}
					else
					{
						// the matcher below simply accepts nothing for lazy *
						// so the backtrack should point to the next to match
						// and the strPos should point to the next item
						//Console.putln("ok(*?) s:", strPos, " r:", regexPos);
						
						setFlag(LAZY_KLEEN);

						stack.push(regexPos-1);
						stack.push(strPos+1);
						stack.push(flags);
	
						regexPos+=2;
						
						matchMade = true;
					}
				}	// greedy *
				else if (matchMade)
				{
					//Console.putln("ok(*) s:", strPos, " r:", regexPos);
					stack.push(regexPos+1);
					stack.push(strPos);
					stack.push(flags);

					// still processing
					regexPos--;
				}
				else
				{
					// that is ok
					matchMade = true;
					regexPos++;
				}
			}
			else if (regex[regexPos] == '+')
			{
				if ((regexPos < regex.length - 1) && regex[regexPos+1] == '?')
				{
					// lazy +
					if (matchMade)
					{
						//Console.putln("ok(+?) s:", strPos, " r:", regexPos);
						stack.push(regexPos-1);
						stack.push(strPos);
						stack.push(flags);

						regexPos+=2;
					}
					else
					{
						//Console.putln("fail(+?) s:", strPos, " r:", regexPos);
						backtrack = true;
						matchMade = false;
					}
				}	// greedy +
				else if (matchMade)
				{
					//Console.putln("ok(+) s:", strPos, " r:", regexPos);
					stack.push(regexPos+1);
					stack.push(strPos);
					stack.push(flags);

					// still processing
					setFlag(PLUS_OK);

					regexPos--;
				}
				else if (hasFlag(PLUS_OK))
				{
					// no match (at least one found)
					//Console.putln("match(+) s:", strPos, " r:", regexPos);
					matchMade = true;
					// reset + status
					resetFlag(PLUS_OK);
					regexPos++;
				}
				else
				{
					// no match (zero found)
					//Console.putln("fail(+) s:", strPos, " r:", regexPos);
					backtrack = true;
					matchMade = false;
				}
			}
			else
			{
				if (!matchMade)
				{
					backtrack = true;
				}
				else if (strPos >= str.length)
				{
					matchMade = false;
				}
				else if (!hasFlag(LAZY_KLEEN) && (regexPos < regex.length - 2) && regex[regexPos+1] == '*' && regex[regexPos+2] == '?')
				{
					// lazy *
					//Console.putln("match(*?)[epsilon] s:", strPos, " r:", regexPos);
					matchMade = true;
					regexPos++;
					//Console.putln("attempting s:", strPos, " r:", regexPos);
				}
				else if ((str[strPos] == regex[regexPos]) || (regex[regexPos] == '.'))
				{
					//Console.putln("match s:", strPos, " r:", regexPos);

					// match made
					matchMade = true;

					// consume input string
					strPos++;

					// consume regular expression
					regexPos++;
					//Console.putln("attempting s:", strPos, " r:", regexPos);
				}
				else
				{
					//Console.putln("fail s:", strPos, " r:", regexPos);

					// no match made
					matchMade = false;

					// consume regular expression
					regexPos++;
				}
			}
		}

		if (matchMade && strPosStart < str.length)
		{
			return str.subString(strPosStart, strPos-strPosStart);
		}
		
		return null;
	}

	static String work(StringLiteral str, String regex)
	{
		return work(new String(str), regex);
	}

	static String work(String str, StringLiteral regex)
	{
		return work(str, new String(regex));
	}

	static String work(StringLiteral str, StringLiteral regex)
	{
		return work(new String(str), new String(regex));
	}
	
protected:

	// These instance variables contain the data structures
	// that will build and maintain the DFA for the regular expression
	
	// Holds the regular expression for the instance
	String regularExpression;

	void buildDFA()
	{
	}
}