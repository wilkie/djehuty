module output;

import std.stdio;
import std.string;

import ast;
import parser;

char[] header = 
`
/*
 * test.d
 *
 * Tests the specifications defined and parsed by dspec
 *
 */

module specs.test;

import testing.logic;

`;

char[] footer =
`
`;

class Output
{
	this(char[] path)
	{
		readyOutput(path);
		printHeader();
	}
	
	~this()
	{
		finalizeOutput();
	}
	
	void work(AST result)
	{
		AST working = result;
		AST node;
				
		while(working !is null)
		{
			node = working.right;
			if (node !is null)
			{
				if (node.valueType == AST.ValueType.Name)
				{
					char[] name;
					node.getValue(name);

					writefln(name);

					switch(name)
					{
						case "ParseDescribe":

							tests = null;
							className = null;
							
							printDescribe(node);					
							break;
						case "ParseImport":
							printImport(node);
							break;
						default:
							// error
							break;
					}
				}
			}
			working = working.left;
		}
	}
	
protected:

	_iobuf* outfp;
	char[] className;
	char[][] tests;
	ulong[] lines;
	
	char[][] classes;
	
	char[] exception;
	
	bool shouldThrow = false;

	bool readyOutput(char[] path)
	{
		outfp = fopen(std.string.toStringz(path), "w+");
		
		if (outfp is null) 
		{
			return false;
		}
		
		return true;
	}
	
	bool printHeader()
	{
		fwritef(outfp, "%s", header);

		return true;

	}
	
	bool finalizeOutput()
	{
		if (outfp is null)
		{
			return false;
		}
		
		fwritef(outfp, "%s", "\nclass Tests\n{\n");
		
		foreach(className; classes)
		{
			fwritef(outfp, "%s", "\tstatic void test", className, "()\n\t{\n");
			fwritef(outfp, "%s", "\t\t" ~ className ~ "Tester.test();\n");
			fwritef(outfp, "%s", "\t}\n\n");
		}
		
		fwritef(outfp, "%s", "\tstatic void testAll()\n\t{\n");
		
		foreach(className; classes)
		{
			fwritef(outfp, "%s", "\t\ttest", className, "();\n");
		}
		
		fwritef(outfp, "%s", "\t}\n");
		
		fwritef(outfp, "%s", "}\n");
		fwritef(outfp, "%s", footer);
		
		fclose(outfp);
		return true;
	}
	
	bool printDone(AST tree, char[] describing)
	{
		AST working = tree;
		AST node;
		
		if (describing !is null)
		{
			print("done before_" ~ describing);
		}
		else
		{
			print("done before");
		}
		
		print("()\n\t{");
		
		while (working !is null)
		{		
			node = working.right;
			if (node !is null)
			{
				if (node.valueType == AST.ValueType.Name)
				{
				}
				else
				{
					char[] content;node.getValue(content);
					print(content);
				}
			}

			working = working.left;
		}
		
		print("}");
		
		return true;
	}
	
	bool printImport(AST tree)
	{
		AST working = tree;
		AST node;
		
		while (working !is null)
		{		
			node = working.right;
			if (node !is null)
			{
				if (node.valueType == AST.ValueType.Name)
				{
				}
				else
				{
					char[] content;node.getValue(content);
					if (!(content == " testing.support"))
					{
						print("import");
						print(content);		
						print(";\n\n");
					}
				}
			}

			working = working.left;
		}
		
		return true;
	}
	
	bool printIt(AST tree, char[] describing)
	{
		AST working = tree;
		AST node;
		
		while (working !is null)
		{		
			node = working.right;
			if (node !is null)
			{
				if (node.valueType == AST.ValueType.Name)
				{
					char[] name;
					node.getValue(name);

					switch(name)
					{
						case "Identifier":
							char[] val;
							node.right.getValue(val);
							
							print("it ");
							if (describing !is null)
							{
								val = describing ~ "_" ~ val;
							}
							
							print(val ~ "()\n\t{");
							
							print("before");
							if (describing !is null)
							{
								print("_" ~ describing);
							}
							print("();\n");
							
							if (describing is null)
							{
								val = "_" ~ val;
							}
							
							tests ~= val;
		
							print("try\n{");
							break;
						case "LineNumber":
							ulong val;
							node.right.getValue(val);
							
							lines ~= val;
							break;
						case "ParseDone":
							printDone(node,describing);
							break;
						case "ParseShould":
							printShould(node);
							break;
						case "ParseShouldNot":
							printShouldNot(node);
							break;	
						case "ParseShouldThrow":
							printShouldThrow(node);
							break;
						default:
							break;
					}
				}
				else
				{
					char[] content;node.getValue(content);
					print(content);
				}
			}

			working = working.left;
		}
		
		print("}catch(Exception _exception_)\n{\n\t");
		if (shouldThrow)
		{
			writefln("!!", exception);
			if (exception == "")
			{
				print("return it.does");
			}
			else
			{
				print("if (_exception_.msg != ");
				print(exception);
				print(") { return it.doesnt; } return it.does");
			}
		}
		else
		{
			print("return it.doesnt");
		}
		
		print(";\n}\n\treturn it.does;\n\t}");
		
		return true;
	}
	
	bool printShould(AST tree)
	{
		AST working = tree;
		AST node;
		
		print("if(!(");
		
		while (working !is null)
		{		
			node = working.right;
			if (node !is null)
			{
				if (node.valueType == AST.ValueType.Name)
				{
				}
				else
				{
					char[] content;node.getValue(content);
					print(content);
				}
			}

			working = working.left;
		}
		
		print("))\n\t{\n\t\treturn it.doesnt;\n\t}\n");
		
		return true;
	}
	
	bool printShouldNot(AST tree)
	{
		AST working = tree;
		AST node;
		
		print("if(");
		
		while (working !is null)
		{		
			node = working.right;
			if (node !is null)
			{
				if (node.valueType == AST.ValueType.Name)
				{
				}
				else
				{
					char[] content;node.getValue(content);
					print(content);
				}
			}

			working = working.left;
		}
		
		print(")\n{ return it.doesnt; }\n");
		
		return true;
	}
	
	bool printShouldThrow(AST tree)
	{
		AST working = tree;
		AST node;
		
		exception = "";
				
		while (working !is null)
		{		
			node = working.right;
			if (node !is null)
			{
				if (node.valueType == AST.ValueType.Name)
				{
				}
				else
				{
					char[] content;node.getValue(content);
					exception = content;
				}
			}

			working = working.left;
		}
		
		shouldThrow = true;
		
		return true;
	}
	
	bool printDescribeSection(AST tree)
	{
		AST working = tree;
		AST node;
		
		char[] describing;
		
		bool hasDone = false;
		
		while (working !is null)
		{		
			node = working.right;
			if (node !is null)
			{
				if (node.valueType == AST.ValueType.Name)
				{
					char[] name;
					node.getValue(name);

					switch(name)
					{
						case "Identifier":
							node.right.getValue(describing);
							break;
						case "ParseDone":
							hasDone = true;
							printDone(node,describing);
							break;
						case "ParseIt":
							printIt(node,describing);
							break;
						default:
							break;
					}
				}
				else
				{
					char[] content;node.getValue(content);
					print(content);
				}
			}

			working = working.left;
		}
		
		if (!hasDone)
		{
			print("done before_" ~ describing ~ "() { }\n");
		}
		
		return true;
	}
	
	bool printDescribe(AST tree)
	{
		AST working = tree;
		AST node;
		
		bool hasDone = false;
		
		char[] val;
		
		while (working !is null)
		{		
			node = working.right;
			if (node !is null)
			{
				if (node.valueType == AST.ValueType.Name)
				{
					char[] name;
					node.getValue(name);

					switch(name)
					{
						case "Identifier":
							node.right.getValue(val);
							writefln("ID: ", val);
							
							if (val[0] >= 'a' && val[0] <= 'z')
							{
								val[0] -= 32;
							}
							
							val ~= "Tester";
							
							print("class " ~ val ~ "\n{");
							className = val;
							break;
						case "ParseDone":
							hasDone = true;
							printDone(node,null);
							break;
						case "ParseIt":
							printIt(node,null);
							break;
						case "ParseDescribeSection":
							printDescribeSection(node);
							break;
						default:
							break;
					}
				}
				else
				{
					char[] content;node.getValue(content);
					print(content);
				}
			}

			working = working.left;
		}
		
		if (!hasDone)
		{
			print("done before() { }\n\n");
		}
		
		print("this() { before(); }\n\n");
		
		// do tests
		
		char[] classNameFixed = className[0..$-6];
		
		print ("\n\tstatic void test()\n\t{\n\t");
		
		print ("\t" ~ className ~ " tester = new " ~ className ~ "();\n\n\t");
		print ("\tTest test = new Test(\"" ~ classNameFixed ~ "\");\n\n\t");
		print ("\tit result;\n\n\t");
		
		char[] currentSection = "";
		
		foreach(i, char[] test; tests)
		{
			int pos = find(test, '_');
			char[] section = test[0..pos];
			
			if (currentSection != section)
			{
				print("\ttest.logSubset(\"" ~ section ~ "\");\n\n\t");
				currentSection = section;
			}
			
			print("\ttester = new " ~ className ~ "();\n\n\t");
			print("\tresult = tester." ~ test ~ "();\n\t");
			print("\ttest.logResult(result, \"" ~ replace(test, "_", " ") ~ "\", \"");
			fwritef(outfp, "", lines[i]);
			print("\");\n\n\t");
		}
		
		print("\n\t}");
		
		print("\n}");
		
		classes ~= classNameFixed;
		
		return true;
	}
	
	bool print(char[] stuff)
	{
		fwritef(outfp, "%s", stuff);
		return true;
	}
}