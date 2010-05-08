module feeder;

import core.string;
import core.unicode;
import core.definitions;

import io.file;
import io.console;

char[] delims = " \t.{}()[];,-+=/\\*&^%!|?:<>`\"'";

class Feeder {
	this(string filename) {
		fp = File.open(filename);
		//fp = fopen(std.string.toStringz(filename), "rb");

		// reinit
		lineNumber = 0;
	}

	~this() {
		// *** delete
		//fclose(fp);
	}

	string[] feed() {
		char[] line;

		if(fp.readLine(line)) {
			// Minimal Logic:
			// - know not to parse comments
			// - know that first describe dictates control
			// - know how to expand should and shouldNot

			// *** delete
			//char[] line = readln(fp);

			// Increment line counter
			lineNumber++;

			// sanitize line
			// *** delete (I don't add newline)
			//line = chomp(line);

			// return tokens
			line = line.trim();
			return splitAll(line, delims);
		}

		return null;
	}

	uint getLineNumber() {
		return lineNumber;
	}
	
	string fileName() {
		return fp.name;
	}

protected:

	File fp;
	//_iobuf* fp;
	uint lineNumber = 0;

	string[] splitAll(char[] s, char[] delim, bool keepDelim = true) {
		string[] ret;

		uint lastpos = 0;
		foreach(i, c; s) {
			foreach(cmp; delim) {
				if (c == cmp) {
					if (lastpos != i) {
						ret ~= s[lastpos..i].dup;
					}
					if (keepDelim) {
						ret ~= s[i..i+1].dup;
					}
					lastpos = i+1;
				}
			}
		}

		ret ~= ["\n"];

		return ret;
	}
}
