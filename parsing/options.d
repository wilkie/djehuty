/*
 * options.d
 *
 * This module implements a mechanism to read in command line options.
 *
 * Author: Dave Wilkinson
 * Originated: September 28th, 2009
 *
 */

module parsing.options;

import core.util;
import core.string;
import core.tostring;
import core.definitions;
import core.arguments;
import core.main;

public import _ConsoleIO = io.console;

template BuildArgumentRetrieval(T) {
	//pragma(msg, T.stringof);
	static if (is(T == char)) {
		const char[] BuildArgumentRetrieval = `(param.toString())[0];`;
	}
	else static if (IsSigned!(T)) {
		const char[] BuildArgumentRetrieval = `cast(` ~ T.stringof ~ `)atoi(param.toString());`;
	}
	else {
		const char[] BuildArgumentRetrieval = `param.toString();`;
	}
}

template BuildArgumentRetrieve(uint argidx, uint idx, list...) {
	static if (idx >= list.length) {
		const char[] BuildArgumentRetrieve = ``;
	}
	else static if (list[idx].stringof[0] != '"') {
		const char[] BuildArgumentRetrieve = `param = getParameter();`
			~ "\n\t\t\t\t"
			~ `if (param is null) { onError(token); return; } `
			~ "\n\t\t\t\t"
			~ list[idx].stringof ~ ` arg` ~ argidx.stringof[0..$-1] ~ ` = `
			~ BuildArgumentRetrieval!(list[idx])
			~ "\n\t\t\t\t"
			~ BuildArgumentRetrieve!(argidx+1,idx+2, list);
	}
	else {
		// no more parameters
		const char[] BuildArgumentRetrieve = ``;
	}
}

template BuildOpParams(uint argidx, uint idx, list...) {
	static if (idx >= list.length) {
		const char[] BuildOpParams = ``;
	}
	else static if (argidx == 0) {
		static if (list[idx].stringof[0] != '"') {
			const char[] BuildOpParams = `arg0` ~ BuildOpParams!(argidx+1, idx+2, list);
		}
		else {
			const char[] BuildOpParams = ``;
		}
	}
	else {
		static if (list[idx].stringof[0] != '"') {
			const char[] BuildOpParams = `, arg` ~ argidx.stringof[0..$-1] ~ BuildOpParams!(argidx+1, idx+2, list);
		}
		else {
			const char[] BuildOpParams = ``;
		}
	}
}

template RebuildOpName(char[] name, uint idx = 0) {
	static if (idx >= name.length || name == "" || name[idx] == ',' || name[idx] == ' ') {
		const char[] RebuildOpName = Capitalize!(name[0..idx]);
	}
	else static if (name[idx] == '-') {
		const char[] RebuildOpName = Capitalize!(name[0..idx]) ~ RebuildOpName!(name[idx+1..$], 0);
	}
	else {
		const char[] RebuildOpName = RebuildOpName!(name, idx + 1);
	}
}

template BuildOpName(uint idx, list...) {
	const char[] BuildOpName = `on` ~ RebuildOpName!(list[idx]) ~ `(` ~ BuildOpParams!(0, idx+2, list) ~ `);`;
}

template BuildCaseList(char[] optionString, uint pos = 0) {
	static if (pos >= optionString.length) {
		const char[] BuildCaseList = `case ` ~ "`" ~ optionString ~ "`" ~ `:
				`;
	}
	else static if (optionString[pos] == ',' || optionString[pos] == ' ') {
		static if (Trim!(optionString[0..pos]) == "") {
			const char[] BuildCaseList = BuildCaseList!(optionString[pos+1..$], 0);
		}
		else {
			const char[] BuildCaseList = `case ` ~ "`" ~ Trim!(optionString[0..pos]) ~ "`" ~ `:
			` ~ BuildCaseList!(optionString[pos+1..$], 0);
		}
	}
	else {
		const char[] BuildCaseList = BuildCaseList!(optionString, pos + 1);
	}
}

template BuildArgumentItem(uint idx, list...) {
	static if (idx >= list.length) {
		const char[] BuildArgumentItem = ``;
	}
	else static if (list[idx].stringof[0] == '"') {
		//pragma(msg, idx.stringof ~ "::" ~ list[idx].stringof);
		const char[] BuildArgumentItem =
				BuildCaseList!(list[idx])
				~ BuildArgumentRetrieve!(0, idx+2, list)
				~ BuildOpName!(idx, list)
				~ "\n\t\t\t\t" ~ `break;

			` ~ BuildArgumentItem!(idx+2, list);
	}
	else {
		const char[] BuildArgumentItem = "" ~ BuildArgumentItem!(idx+2, list);
	}
}

// assumptions: 'token' is a string to check
template BuildArgumentParser(list...) {
	const char[] BuildArgumentParser = `
		switch(token) {
			` ~ BuildArgumentItem!(0, list) ~ `
			default:
				// no option found
				tokenFound = false;
				break;
		}
	`;
}

template BuildUsageString(char[] name, uint idx = 0) {
	static if (idx >= name.length) {
		const char[] BuildUsageString = Trim!(name[0..idx]);
	}
	else static if (name[idx] == ',') {
		const char[] BuildUsageString = Trim!(name[0..idx]) ~ ", -" ~ BuildUsageString!(name[idx+1..$], 0);
	}
	else {
		const char[] BuildUsageString = BuildUsageString!(name, idx + 1);
	}
}

template BuildUsageParameterList(uint idx, list...) {
	static if (idx >= list.length) {
		const char[] BuildUsageParameterList = ` `;
	}
	else static if (list[idx].stringof[0] == '"') {
		const char[] BuildUsageParameterList = ` `;
	}
	else {
		static if (list[idx].stringof == "char[]") {
			// {string} is prettier, imho
			const char[] BuildUsageParameterList = ` {string}` ~ BuildUsageParameterList!(idx+2, list);
		}
		else {
			const char[] BuildUsageParameterList = ` {` ~ list[idx].stringof ~ `}` ~ BuildUsageParameterList!(idx+2, list);
		}
	}
}

template BuildUsageParameterPretty(char[] foo) {
	const char[] BuildUsageParameterPretty = "           "[0..(11 - foo.length)] ~ foo;
}

template BuildUsageParameterDescList(uint idx, list...) {
	static if (idx >= list.length) {
		const char[] BuildUsageParameterDescList = ``;
	}
	else static if (list[idx].stringof[0] == '"') {
		const char[] BuildUsageParameterDescList = ``;
	}
	else {
		static if (list[idx].stringof == "char[]") {
			// {string} is prettier, imho
			const char[] BuildUsageParameterDescList = ` ` ~ BuildUsageParameterPretty!(`{string}`) ~ ` - ` ~ list[idx+1] ~ `\n` ~ BuildUsageParameterDescList!(idx+2, list);
		}
		else {
			const char[] BuildUsageParameterDescList = ` ` ~ BuildUsageParameterPretty!(`{` ~ list[idx].stringof ~ `}`) ~ ` - ` ~ list[idx+1] ~ `\n` ~ BuildUsageParameterDescList!(idx+2, list);
		}
	}
}

template BuildUsageDesc(uint idx, list...) {
	static if (idx >= list.length) {
		const char[] BuildUsageDesc = ``;
	}
	else {
		const char[] BuildUsageDesc = `_ConsoleIO.Console.putln("-` ~ BuildUsageString!(list[idx]) ~ BuildUsageParameterList!(idx + 2, list) ~ `: ` ~ list[idx+1] ~ `");
				_ConsoleIO.Console.putln("` ~ BuildUsageParameterDescList!(idx + 2, list) ~ `");
			`;
	}
}

template BuildUsageItem(uint idx, list...) {
	static if (idx >= list.length) {
		const char[] BuildUsageItem = ``;
	}
	else static if (list[idx].stringof[0] == '"') {
		const char[] BuildUsageItem =
				BuildCaseList!(list[idx])
				~ BuildUsageDesc!(idx, list)
				~ "\n\t\t\t\t" ~ `break;

			` ~ BuildUsageItem!(idx+2, list);
	}
	else {
		const char[] BuildUsageItem = "" ~ BuildUsageItem!(idx+2, list);
	}
}

// Assumes 'option' contains the option to view
template BuildUsagePrinter(list...) {
	const char[] BuildUsagePrinter = `
		switch(option) {
			` ~ BuildUsageItem!(0, list) ~ `
			default:
				// no option
				break;
		}
	`;
}

template BuildOpSimpleName(char[] name, uint idx = 0) {
	static if (idx >= name.length) {
		const char[] BuildOpSimpleName = Trim!(name[0..idx]);
	}
	else static if (name[idx] == ',') {
		const char[] BuildOpSimpleName = Trim!(name[0..idx]);
	}
	else {
		const char[] BuildOpSimpleName = BuildOpSimpleName!(name, idx + 1);
	}
}

template BuildOpSortableName(char[] name, uint pos = 0) {
	static if (pos >= name.length) {
		const char[] BuildOpSortableName = ` ` ~ BuildOpSimpleName!(name);
	}
	else static if (name[pos] == '-') {
		const char[] BuildOpSortableName = BuildOpSortableName!(name, pos + 1);
	}
	else {
		const char[] BuildOpSortableName = name[pos..$] ~ ` ` ~ BuildOpSimpleName!(name);
	}
}

template BuildOptionArray(uint idx, list...) {
	static if (idx >= list.length) {
		const char[] BuildOptionArray = ``;
	}
	else static if (list[idx].stringof[0] == '"') {
		const char[] BuildOptionArray = `"` ~ BuildOpSortableName!(list[idx]) ~ `",
			` ~ BuildOptionArray!(idx + 2, list);
	}
	else {
		const char[] BuildOptionArray = BuildOptionArray!(idx + 2, list);
	}
}

template BuildUsagePrinterAllDescPretty(char[] foo) {
	static if (foo.length >= 40) {
		const char[] BuildUsagePrinterAllDescPretty = foo;
	}
	else {
		const char[] BuildUsagePrinterAllDescPretty = foo ~ "                                        "[0..35 - foo.length] ;
	}
}

template BuildUsagePrinterAllDesc(uint idx, list...) {
	static if (idx >= list.length) {
		const char[] BuildUsagePrinterAllDesc = ``;
	}
	else static if (list[idx].stringof[0] == '"') {
		const char[] BuildUsagePrinterAllDesc = `_ConsoleIO.Console.putln(" ` 
				~ BuildUsagePrinterAllDescPretty!(Trim!(list[idx] ~ BuildUsageParameterList!(idx+2, list)))
				~ ` - `
				~ list[idx + 1]
				~ `");`;
	}
	else {
		const char[] BuildUsagePrinterAllDesc = "" ~ BuildUsagePrinterAllDesc!(idx+2, list);
	}
}

template BuildUsagePrinterAllItem(uint idx, list...) {
	static if (idx >= list.length) {
		const char[] BuildUsagePrinterAllItem = ``;
	}
	else static if (list[idx].stringof[0] == '"') {
		const char[] BuildUsagePrinterAllItem =
				BuildCaseList!(list[idx])
				~ BuildUsagePrinterAllDesc!(idx, list)
				~ "\n\t\t\t\t" ~ `break;

			` ~ BuildUsagePrinterAllItem!(idx+2, list);
	}
	else {
		const char[] BuildUsagePrinterAllItem = "" ~ BuildUsagePrinterAllItem!(idx+2, list);
	}
}

template BuildUsagePrinterAll(list...) {
	const char[] BuildUsagePrinterAll = `
		string[] options = [
			` ~ Trim!(BuildOptionArray!(0, list))[0..$-1] ~ `
		];

		options.sort;

		foreach(_opt; options) {
			String _str = new String(_opt);
			int pos = _str.findReverse(new String(" "));
			char[] option = _str[pos+1.._str.length];

			switch (option) {
			` ~ BuildUsagePrinterAllItem!(0, list) ~ `
			default:
				break;
			}
		}
	`;
}

abstract class OptionParser {
	this() {
		parse();
	}

	void parse() {
	}

	void showUsage() {
	}

	void printUsage(string option) {
	}

	void onError(string option) {
		// Default handler will print out the correct usage of the
		// option and exit

		_ConsoleIO.Console.putln("Error in syntax for option: -", option);
		_ConsoleIO.Console.putln();
		printUsage(option);
		Djehuty.end(0);
	}
}

template Options(list...) {

	// print out list of options
	override string toString() {
		return "";
	}

	override void showUsage() {

		// Traditional header

		_ConsoleIO.Console.putln("OVERVIEW: Application Name - Version - 0.0.0");
		_ConsoleIO.Console.putln();
		_ConsoleIO.Console.putln("USAGE: foo ");
		_ConsoleIO.Console.putln();
		_ConsoleIO.Console.putln("OPTIONS:");

		// Followed by an alphabetical listing of options and their usage

		//pragma(msg,BuildUsagePrinterAll!(list));
		mixin(BuildUsagePrinterAll!(list));
	}

	override void printUsage(string option) {
		char[] token;
		//pragma(msg,BuildUsagePrinter!(list));
		mixin(BuildUsagePrinter!(list));
	}

	override void parse() {
		Arguments args = Arguments.instance;
		_ConsoleIO.Console.putln(args.length);
		foreach(var; args) {
			_ConsoleIO.Console.putln(var);
		}
		char[] token;
		String param;

		for (uint i; i < args.length; ) {
			String arg;

			void pullArgument() {
				arg = args.peekAt(i);
				i++;
			}

			pullArgument();

			if (arg[0] == '-') {
				// it is an option
				for (uint c = 1; c < arg.length; c++) {

					String getParameter() {
						String ret;
						if (arg is null) {
							return null;
						}

						if (c >= arg.length - 1) {
							pullArgument();
							ret = arg;
						}
						else {
							ret = arg.subString(c+1);
						}

						if (ret !is null && ret.length > 0 && (ret[0] == '"' || ret[0] == '\'')) {
							char lookingFor = ret[0];
							// we have to look for the end of the string argument
							while (!(ret[ret.length - 1] == lookingFor && (ret.length == 1 || ret[ret.length - 2] != '\\'))) {
								pullArgument();
								if (arg is null) {
									onError(token);
									return null;
								}
								ret ~= " ";
								ret ~= arg;
							}

							// Replace escaped characters
							char[] findStr = `\` ~ [lookingFor];
							int pos = ret.find(findStr);
							while (pos != -1) {
								ret = new String(ret[0..pos] ~ [lookingFor] ~ ret[pos+2..ret.length]);
								pos = ret.find(findStr, pos+1);
							}
							// good
							ret = ret.subString(1, ret.length - 2);
						}

						if (arg !is null) {
							c = arg.length;
						}
						return ret;
					}

					dchar chr = arg[c];

					if (token.length == 0 && chr == '-' && c != 1) {
						// incorrect
						onError(token);
						return;
					}
					token ~= chr;
					bool tokenFound = true;

					//pragma(msg,BuildArgumentParser!(list));

					mixin(BuildArgumentParser!(list));

					if (tokenFound) {
						// interpretate and return the arguments
						token = "";
					}
				}
			}
		}
	}
}
