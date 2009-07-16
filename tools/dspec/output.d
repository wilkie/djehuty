module output;

import core.string;
import core.unicode;

import io.file;
import io.console;

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
	this(String path)
	{
		if (!readyOutput(path))
		{
			// Error: cannot write file
			Console.putln("Error: Cannot write to ", path.array);
		}
		printHeader();
	}
	
	~this()
	{
	}

	void work(AST result)
	{
		Console.putln("Outputting ... ");
		AST working = result;
		AST node;
				
		while(working !is null)
		{
			node = working.right;
			if (node !is null)
			{
				if (node.valueType == AST.ValueType.Name)
				{
					String name;
					node.getValue(name);

					Console.putln("Tree: ", name.array);
					//writefln(name);

					switch(name.array)
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
	
	bool finalizeOutput()
	{
		if (outfp is null)
		{
			return false;
		}

		//fwritef(outfp, "%s", "\nclass Tests\n{\n");
		outfp.write("\nclass Tests\n{\n"c);

		foreach(className; classes)
		{
			outfp.write("\tstatic void test"c);
			outfp.write(Unicode.toUtf8(className.array));
			outfp.write("()\n\t{\n"c);
			//fwritef(outfp, "%s", "\tstatic void test", className, "()\n\t{\n");
			outfp.write("\t\t"c);
			outfp.write(Unicode.toUtf8(className.array));
			outfp.write("Tester.test();\n"c);
			//fwritef(outfp, "%s", "\t\t" ~ className ~ "Tester.test();\n");
			outfp.write("\t}\n\n"c);
			//fwritef(outfp, "%s", "\t}\n\n");
		}

		outfp.write("\tstatic void testAll()\n\t{\n"c);
		//fwritef(outfp, "%s", "\tstatic void testAll()\n\t{\n");

		foreach(className; classes)
		{
			outfp.write("\t\ttest"c);
			outfp.write(Unicode.toUtf8(className.array));
			outfp.write("();\n"c);
			//fwritef(outfp, "%s", "\t\ttest", className, "();\n");
		}

		outfp.write("\t\tTest.done();\n"c);

		outfp.write("\t}\n"c);
		//fwritef(outfp, "%s", "\t}\n");

		outfp.write("}\n"c);
		//fwritef(outfp, "%s", "}\n");
		outfp.write(footer);
		//fwritef(outfp, "%s", footer);

		outfp.close();
		//fclose(outfp);
		return true;
	}
	
protected:

	File outfp;
	//_iobuf* outfp;
	String className;
	String[] tests;
	ulong[] lines;

	String[] classes;

	String exception;
	
	bool shouldThrow = false;

	bool readyOutput(String path)
	{
		//outfp = fopen(std.string.toStringz(path), "w+");
		outfp = new File(path);
		
		if (outfp is null) 
		{
			return false;
		}
		
		return true;
	}
	
	bool printHeader()
	{
		//fwritef(outfp, "%s", header);
		Console.putln("output header");
		outfp.write(header);

		return true;

	}

	bool printDone(AST tree, String describing)
	{
		AST working = tree;
		AST node;
		
		if (describing !is null)
		{
			print(new String("done before_") ~ describing);
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
					String content;
					node.getValue(content);
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
					String content;
					node.getValue(content);
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
	
	bool printIt(AST tree, String describing)
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
					String name;
					node.getValue(name);

					switch(name.array)
					{
						case "Identifier":
							String val;
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
								print(new String("_") ~ describing);
							}
							print("();\n");
							
							if (describing is null)
							{
								val = new String("_") ~ val;
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
					String content;
					node.getValue(content);
					print(content);
				}
			}

			working = working.left;
		}
		
		print("}catch(Exception _exception_)\n{\n");
		if (shouldThrow)
		{
			Console.putln("!!", exception.array);
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
					String content;
					node.getValue(content);
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
					String content;
					node.getValue(content);
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

		exception = new String("");

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
					String content;
					node.getValue(content);
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

		String describing;

		bool hasDone = false;

		while (working !is null)
		{
			node = working.right;
			if (node !is null)
			{
				if (node.valueType == AST.ValueType.Name)
				{
					String name;
					node.getValue(name);

					switch(name.array)
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
					String content;
					node.getValue(content);
					print(content);
				}
			}

			working = working.left;
		}

		if (!hasDone)
		{
			print(new String("done before_") ~ describing ~ "() { }\n");
		}

		return true;
	}

	bool printDescribe(AST tree)
	{
		AST working = tree;
		AST node;

		bool hasDone = false;

		String val;

		while (working !is null)
		{
			node = working.right;
			if (node !is null)
			{
				if (node.valueType == AST.ValueType.Name)
				{
					String name;
					node.getValue(name);

					switch(name.array)
					{
						case "Identifier":
							node.right.getValue(val);
							Console.putln("ID: ", val.array);

							if (val[0] >= 'a' && val[0] <= 'z')
							{
								val.setCharAt(0, val[0] - 32);
							}
							Console.putln("ID: ", val.array, " len ", val.length);

							val ~= "Tester";
							Console.putln("ID: ", val.array, " len ", val.length);

							print(new String("class ") ~ val ~ "\n{");
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
					String content;
					node.getValue(content);
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

		Console.putln("className: ", className.array, " len " , className.length);
		String classNameFixed = className.subString(0,className.length-6);
		Console.putln("className::", classNameFixed.array);
		Console.putln("className::", className[0..className.length-6]);

		print ("\n\tstatic void test()\n\t{\n");

		print (new String("\t") ~ className ~ " tester = new " ~ className ~ "();\n\n");
		print (new String("\tTest test = new Test(\"") ~ classNameFixed ~ "\");\n\n");
		print (new String("\tit result;\n\n"));

		String currentSection = new String("");

		foreach(i, test; tests)
		{
			int pos = test.find(new String("_"));
			String section = new String(test[0..pos]);

			if (currentSection != section)
			{
				print(new String("\ttest.logSubset(\"") ~ section ~ "\");\n\n");
				currentSection = section;
			}

			print(new String("\ttester = new ") ~ className ~ "();\n\n");
			print(new String("\tresult = tester.") ~ test ~ "();\n\t");
			print(new String("\ttest.logResult(result, \"") ~ test.replace('_', ' ') ~ "\", \"");
			print(new String(lines[i]));
			//fwritef(outfp, "", lines[i]);
			print("\");\n\n");
		}

		print("\n\t}");

		print("\n}");

		classes ~= classNameFixed;

		return true;
	}

	bool print(string stuff)
	{
		return outfp.write(Unicode.toUtf8(stuff));
		//fwritef(outfp, "%s", stuff);
		//return true;
	}

	bool print(String stuff)
	{
		return outfp.write(Unicode.toUtf8(stuff.array));
	}
}