/*
 * codebox.d
 *
 * This module implements a code aware text-editor TUI widget.
 *
 * Author: Dave Wilkinson
 * Originated: August 6th, 2009
 *
 */

module cui.codebox;

import cui.textbox;

import djehuty;

import io.console;

class CuiCodeBox : CuiTextBox {

	// Constructors

	this(uint x, uint y, uint width, uint height) {
		super(x,y,width,height);
	}

	// Events

	override void onLineChanged(uint lineNumber) {
		// When a line is changed, look for language syntax features
		string line = _lines[lineNumber].value;

		// Reset formatting
		_lines[lineNumber].format = null;

		string work;
		int pos;
		int findPos;

		int currentRulePos = int.max;
		int currentRuleLength;
		int currentRule = int.max;

		// Keyword Parse
		do {
			currentRule = int.max;
			currentRulePos = int.max;

			foreach(i, rule; _rules) {
				work = Regex.eval(line, rule.regex);

				// Did it match?
				if (work !is null) {
					findPos = _position;
					if (findPos < currentRulePos) {
						currentRulePos = findPos;
						currentRuleLength = work.length;
						currentRule = i;
					}
				}
			}

			// If there was a match, format the line with the earliest
			if (currentRule != int.max) {
				findPos = currentRulePos;
				pos += findPos;

				addFormat(lineNumber, pos, currentRuleLength, _rules[currentRule].forecolor, _rules[currentRule].backcolor);

				pos += currentRuleLength;
				findPos += currentRuleLength;
				line = line.substring(findPos);
			}
		} while (currentRule != int.max)
	}

	// Properties

private:

	void addFormat(uint lineNumber, uint firstPos, uint length, Color forecolor, Color backcolor) {
		if (_lines[lineNumber].format is null) {
			// Simply add
			_lines[lineNumber].format = [
				new LineFormat(_forecolor, _backcolor, firstPos),
				new LineFormat(forecolor, backcolor, length),
				new LineFormat(_forecolor, _backcolor, _lines[lineNumber].value.length - (firstPos + length))
			];
		}
		else {
			LineFormat[] newFormat;

			uint last;
			uint pos;
			uint formatIdx;
			for (uint idx = 0; idx < _lines[lineNumber].format.length; idx++) {
				pos += _lines[lineNumber].format[idx].len;
				if (pos > firstPos) {
					formatIdx = idx;
					break;
				}
				last = pos;
			}

			// Split format at firstPos
			newFormat = _lines[lineNumber].format[0..formatIdx+1];
			newFormat[formatIdx+1].len = firstPos - last;
			newFormat ~= [new LineFormat(forecolor, backcolor, length)];
			newFormat ~= _lines[lineNumber].format[formatIdx..formatIdx+1];
			newFormat[formatIdx+2].len = pos - (firstPos + length);

			_lines[lineNumber].format = newFormat;
		}
	}

	struct SyntaxRule {
		string regex;
		Color forecolor;
		Color backcolor;
	}

	SyntaxRule[] _rules = [
		// Line Comments
//		{ `//([^\n\r]*)`, Color.Green, Color.Black},
		// Block Comments
//		{ `/\*([^\*](?:\*[^/])?)*(?:\*/)?`, Color.Green, Color.Black},
		// Double Quote strings
//		{ `"((?:[^\\"](?:\\.)?)*)"?`, Color.Magenta, Color.Black},
		// Keywords
		{ `\b(abstract|alias|align|asm|assert|auto|body|bool|break|byte|case|cast|catch|cdouble|cent|cfloat|char|class|const|continue|creal|dchar|debug|default|delegate|delete|deprecated|do|double|else|enum|export|extern|false|final|finally|float|for|foreach|foreach_reverse|function|goto|idouble|if|ifloat|import|in|inout|int|interface|invariant|ireal|is|lazy|long|macro|mixin|module|new|null|out|override|package|pragma|private|protected|public|real|ref|return|scope|short|static|struct|super|switch|synchronized|template|this|throw|__traits|true|try|typedef|typeof|ubyte|ucent|uint|ulong|union|unittest|ushort|version|void|volatile|wchar|while|with)\b`, Color.Blue, Color.Black },
		// Operators
//		{ `[\(\)]+`, Color.Red, Color.Black}
	];
}
