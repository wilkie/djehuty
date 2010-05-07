module output;

import djehuty;

import io.file;
import io.console;

import ast;
import parser;

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

		moduleName = "";
		packageName = "";

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
						case "ParseModule":
							AST work = node;
							while (work !is null) {
								node = work.right;
								if (node !is null) {
									if (node.valueType == AST.ValueType.Name) {
									}
									else {
										string content;
										node.getValue(content);
										moduleName = content.trim();
										packageName = moduleName.substring(0, moduleName.findReverse("."));
										moduleName = moduleName.substring(packageName.length+1);
									}
								}

								work = work.left;
							}

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

		outfp.close();
		//fclose(outfp);
		return true;
	}

protected:

	string specName;

	File outfp;
	//_iobuf* outfp;
	string className;
	string moduleName;
	string packageName;
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
		print("/*\n *\n */\n\n");
		print("import spec.specification;\n");
		print("import spec.itemspecification;\n");
		print("import spec.modulespecification;\n");
		print("import spec.packagespecification;\n");
		print("\nimport spec.logic;\n");
		print("\nimport djehuty;\n");

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
								val = describing ~ "!" ~ val;
							}

							print(val.replace('!','_') ~ "() {\n");

							print("\t\tbefore();\n");
							print("\t\tbefore");
							if (describing !is null) {
								print("_" ~ describing);
							}
							print("();\n");
							


							if (describing is null) {
								val = "_" ~ val;
							}

							tests ~= val;

							print("\t\tit _ret = it.does;\n");

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
				print("\t\t\t_ret = it.does");
			}
			else {
				print("\t\t\tif (_exception_.msg != ");
				print(exception);
				print(") { _ret = it.doesnt; }\n\t\t\t_ret = it.does");
			}
		}
		else {
			print("\t\t\t_ret = it.doesnt");
		}
		
		
		print(";\n\t\t}\n\t\treturn _ret;\n\t}\n");


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
		
		print(")) {\n\t\t\t\t_ret = it.doesnt;\n\t\t\t}\n");

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
		
		print(") {\n\t\t\t\t_ret = it.doesnt;\n\t\t\t}\n");

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

							val ~= "Tests";
							//Console.putln("ID: ", val.array, " len ", val.length);

							print("private struct " ~ val ~ " {\nstatic:\n");
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

		// do tests

		//Console.putln("className: ", className.array, " len " , className.length);
		string classNameFixed = className.substring(0,className.length-6);
		//Console.putln("className::", classNameFixed.array);
		//Console.putln("className::", className[0..className.length-6]);

		print("\n}\n\n");

		print ("\nstatic this() {\n");

		print ("\t// Add to specification\n");
		// Split packageName into separate things
		string[] packages = packageName.split('.');
		print ("\tPackageSpecification ps;\n");
		print ("\tPackageSpecification tmpps;\n");

		print ("\tps = Specification.traverse(\"" ~ packages[0] ~ "\");\n");
		print ("\tif(ps is null) {\n");
		print ("\t\tps = new PackageSpecification(\"" ~ packages[0] ~ "\");\n");
		print ("\t\tSpecification.add(ps);\n");
		print ("\t}\n\n");

		foreach(pack; packages[1..$]) {
			print ("\ttmpps = ps;\n");
			print ("\tps = tmpps.traverse(\"" ~ pack ~ "\");\n");
			print ("\tif(ps is null) {\n");
			print ("\t\tps = new PackageSpecification(\"" ~ pack ~ "\");\n");
			print ("\t\ttmpps.add(ps);\n");
			print ("\t}\n\n");
		}

		print ("\t// Add to this module\n");
		print ("\tModuleSpecification ms = ps.retrieve(\"" ~ moduleName ~ "\");\n");
		print ("\tif(ms is null) {\n");
		print ("\t\tms = new ModuleSpecification(\"" ~ moduleName ~ "\");\n");
		print ("\t\tps.add(ms);\n");
		print ("\t}\n\n");

		print ("\tItemSpecification item;\n\n");

		string currentSection = "";
		foreach(i, test; tests) {
			int pos = test.find("!");
			string section = test[0..pos].dup;
			Console.putln("cs:", currentSection, " t:", test);
			if (currentSection != section) {
				currentSection = section;
				print ("\titem = new ItemSpecification(\"" ~ section ~ "\");\n");
				print ("\tms.add(item);\n");
			}
			print("\titem.add(\"" ~ test[pos+1..$].replace('_', ' ') ~ "\", &" ~ className ~ "." ~ test.replace('!','_') ~ ");\n");
		}

		print("}\n\n");

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
