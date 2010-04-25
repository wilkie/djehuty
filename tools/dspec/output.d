module output;

import djehuty;

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

import djehuty;

`;

char[] footer =
`
`;

class Output {
	this(string path) {
		if (!readyOutput(path)) {
			// Error: cannot write file
			Console.putln("Error: Cannot write to ", path);
		}
		printHeader();
	}

	~this() {
	}

	void work(AST result, string path) {
		specName = path.dup;

		//Console.putln("Outputting ... ");
		AST working = result;
		AST node;

		while(working !is null) {
			node = working.right;
			if (node !is null) {
				if (node.valueType == AST.ValueType.Name) {
					string name;
					node.getValue(name);

					//Console.putln("Tree: ", name.array);
					//writefln(name);

					switch(name) {
						case "ParseDescribe":

							tests = null;
							lines = null;
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

	bool finalizeOutput() {
		if (outfp is null) {
			return false;
		}

		//fwritef(outfp, "%s", "\nclass Tests\n{\n");
		outfp.write("\nclass Tests {\n"c);

		foreach(className; classes) {
			outfp.write("\tstatic void test"c);
			outfp.write(Unicode.toUtf8(className));
			outfp.write("() {\n"c);
			//fwritef(outfp, "%s", "\tstatic void test", className, "()\n\t{\n");
			outfp.write("\t\t"c);
			outfp.write(Unicode.toUtf8(className));
			outfp.write("Tester.test();\n"c);
			//fwritef(outfp, "%s", "\t\t" ~ className ~ "Tester.test();\n");
			outfp.write("\t}\n\n"c);
			//fwritef(outfp, "%s", "\t}\n\n");
		}

		outfp.write("\tstatic uint testAll() {\n"c);
		//fwritef(outfp, "%s", "\tstatic void testAll()\n\t{\n");

		foreach(className; classes) {
			outfp.write("\t\ttest"c);
			outfp.write(Unicode.toUtf8(className));
			outfp.write("();\n"c);
			//fwritef(outfp, "%s", "\t\ttest", className, "();\n");
		}

		outfp.write("\t\tTest.done();\n"c);

		outfp.write("\t\treturn Test.getFailureCount();\n"c);

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

	string specName;

	File outfp;
	//_iobuf* outfp;
	string className;
	string[] tests;
	ulong[] lines;

	string[] classes;

	string exception;

	bool shouldThrow = false;

	bool readyOutput(string path) {
		//Console.putln("opening file");
		//outfp = fopen(std.string.toStringz(path), "w+");
		outfp = new File(path);

		if (outfp is null) {
			return false;
		}

		return true;
	}

	bool printHeader() {
		//fwritef(outfp, "%s", header);
		//Console.putln("output header");
		outfp.write(header);

		return true;

	}

	bool printDone(AST tree, string describing) {
		AST working = tree;
		AST node;

		if (describing !is null) {
			print("done before_" ~ describing);
		}
		else {
			print("done before");
		}

		print("()\n\t{");

		while (working !is null) {
			node = working.right;
			if (node !is null) {
				if (node.valueType == AST.ValueType.Name) {
				}
				else {
					string content;
					node.getValue(content);
					printContent(content, 3);
				}
			}

			working = working.left;
		}

		print("}");

		return true;
	}

	bool printImport(AST tree) {
		AST working = tree;
		AST node;

		while (working !is null) {
			node = working.right;
			if (node !is null) {
				if (node.valueType == AST.ValueType.Name) {
				}
				else {
					string content;
					node.getValue(content);
					if (!(content == " testing.support")) {
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

	bool printIt(AST tree, string describing) {
		AST working = tree;
		AST node;

		while (working !is null) {
			node = working.right;
			if (node !is null) {
				if (node.valueType == AST.ValueType.Name) {
					string name;
					node.getValue(name);

					switch(name) {
						case "Identifier":
							string val;
							node.right.getValue(val);

							print("\n\tit ");
							if (describing !is null) {
								val = describing ~ "_" ~ val;
							}

							print(val ~ "() {\n");

							print("\t\tbefore");
							if (describing !is null) {
								print("_" ~ describing);
							}
							print("();\n");

							if (describing is null) {
								val = "_" ~ val;
							}

							tests ~= val;

							print("\t\ttry {\n");
							break;
						case "LineNumber":
							ulong val;
							node.right.getValue(val);
							//Console.putln("LineNumber ", val);

							lines ~= [val];
							//Console.putln(lines);
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
				else {
					string content;
					node.getValue(content);
					printContent(content, 3);
				}
			}

			working = working.left;
		}

		print("\t\t}\n\t\tcatch(Exception _exception_) {\n");
		if (shouldThrow) {
			//Console.putln("!!", exception.array);
			if (exception == "") {
				print("\t\t\treturn it.does");
			}
			else {
				print("\t\t\tif (_exception_.msg != ");
				print(exception);
				print(") { return it.doesnt; }\n\t\t\treturn it.does");
			}
		}
		else {
			print("\t\t\treturn it.doesnt");
		}

		print(";\n\t\t}\n\t\treturn it.does;\n\t}\n");

		return true;
	}

	bool printShould(AST tree) {
		AST working = tree;
		AST node;

		print("\t\t\tif(!(");

		while (working !is null) {
			node = working.right;
			if (node !is null) {
				if (node.valueType == AST.ValueType.Name) {
				}
				else {
					string content;
					node.getValue(content);
					printContent(content, 0);
				}
			}

			working = working.left;
		}

		print(")) {\n\t\t\t\treturn it.doesnt;\n\t\t\t}\n");

		return true;
	}

	bool printShouldNot(AST tree) {
		AST working = tree;
		AST node;

		print("\t\t\tif(");

		while (working !is null) {
			node = working.right;
			if (node !is null) {
				if (node.valueType == AST.ValueType.Name) {
				}
				else {
					string content;
					node.getValue(content);
					printContent(content, 0);
				}
			}

			working = working.left;
		}

		print(") {\n\t\t\t\treturn it.doesnt;\n\t\t\t}\n");

		return true;
	}

	bool printShouldThrow(AST tree) {
		AST working = tree;
		AST node;

		exception = "";

		while (working !is null) {
			node = working.right;
			if (node !is null) {
				if (node.valueType == AST.ValueType.Name) {
				}
				else {
					string content;
					node.getValue(content);
					exception = content;
				}
			}

			working = working.left;
		}

		shouldThrow = true;

		return true;
	}

	bool printDescribeSection(AST tree) {
		AST working = tree;
		AST node;

		string describing;

		bool hasDone = false;

		while (working !is null) {
			node = working.right;
			if (node !is null) {
				if (node.valueType == AST.ValueType.Name) {
					string name;
					node.getValue(name);

					switch(name) {
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
				else {
					string content;
					node.getValue(content);
					printContent(content, 3);
				}
			}

			working = working.left;
		}

		if (!hasDone) {
			print("\n\tdone before_" ~ describing ~ "() {\n\t}\n");
		}

		return true;
	}

	bool printDescribe(AST tree) {
		AST working = tree;
		AST node;

		bool hasDone = false;

		string val;

		while (working !is null) {
			node = working.right;
			if (node !is null) {
				if (node.valueType == AST.ValueType.Name) {
					string name;
					node.getValue(name);

					switch(name) {
						case "Identifier":
							node.right.getValue(val);
							//Console.putln("ID: ", val.array);

							if (val[0] >= 'a' && val[0] <= 'z') {
								val[0] = val[0] - 32;
							}
							//Console.putln("ID: ", val.array, " len ", val.length);

							val ~= "Tester";
							//Console.putln("ID: ", val.array, " len ", val.length);

							print("class " ~ val ~ " {\n");
							Console.putln("Creating ", val);
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
				else {
					string content;
					node.getValue(content);
					if (content.trim() != "") {
						print("\n");
						printContent(content, 1);
					}
				}
			}

			working = working.left;
		}

		if (!hasDone) {
			print("\n\tdone before() {\n\t}\n\n");
		}

		print("\tthis() {\n\t\tbefore();\n\t}\n");

		// do tests

		//Console.putln("className: ", className.array, " len " , className.length);
		string classNameFixed = className.substring(0,className.length-6);
		//Console.putln("className::", classNameFixed.array);
		//Console.putln("className::", className[0..className.length-6]);

		print ("\n\tstatic void test() {\n");

		print ("\t\t" ~ className ~ " tester = new " ~ className ~ "();\n\n");
		print ("\t\tTest test = new Test(\"" ~ classNameFixed ~ "\", \"");
		print (specName ~ "\");\n\n");
		print ("\t\tit result;\n\n");

		string currentSection = "";

		foreach(i, test; tests) {
			int pos = test.find("_");
			string section = test[0..pos].dup;

			if (currentSection != section) {
				print("\t\ttest.logSubset(\"" ~ section ~ "\");\n\n");
				currentSection = section;
			}

			print("\t\ttester = new " ~ className ~ "();\n\n");
			print("\t\tresult = tester." ~ test ~ "();\n");
			print("\t\ttest.logResult(result, \"" ~ test.replace('_', ' ') ~ "\", \"");
			//Console.putln(lines);
			//Console.putln(lines[i]);
			print(toStr(cast(long)lines[i]));
			//fwritef(outfp, "", lines[i]);
			print("\");\n\n");
		}

		print("\t\ttest.finish();\n\t}");

		print("\n}\n\n");

		classes ~= classNameFixed;

		return true;
	}

	bool print(string stuff) {
		return outfp.write(Unicode.toUtf8(stuff));
		//fwritef(outfp, "%s", stuff);
		//return true;
	}

	void printContent(string content, int tabs) {
		content = content.trim();
		if (content == "") { return; }
		int pos = content.find("\n");
		while(pos != -1) {
			if (tabs > 0) {
				switch(tabs) {
					case 3:
						print("\t");
					case 2:
						print("\t");
					case 1:
						print("\t");
					default:
						break;
				}
				print(content.substring(0, pos));
				print("\n");
			}
			else {
				print(content.substring(0, pos));
			}
			content = content.substring(pos+1).trim();
			pos = content.find("\n");
		}
		if (tabs > 0) {
			switch(tabs) {
				case 3:
					print("\t");
				case 2:
					print("\t");
				case 1:
					print("\t");
				default:
					break;
			}
			print(content);
			print("\n");
		}
		else {
			print(content);
		}
	}
}
