/*
 * regex.d
 *
 * This file contains the logic behind a regular expression parser.
 *
 * Author: Dave Wilkinson
 * Originated: May 9th, 2009
 *
 */

module core.regex;

import core.string;
import core.definitions;

import synch.thread;

import io.console;

import utils.stack;

// This provides thread-local access to regex variables set via
// Regex groups.

String _1() {
	if (Thread.getCurrent() in Regex.regexRefs) {
		return Regex.regexRefs[Thread.getCurrent()][0];
	}

	return new String("");
}

String _2() {
	if (Thread.getCurrent() in Regex.regexRefs) {
		return Regex.regexRefs[Thread.getCurrent()][1];
	}

	return new String("");
}

String _3() {
	if (Thread.getCurrent() in Regex.regexRefs) {
		return Regex.regexRefs[Thread.getCurrent()][2];
	}

	return new String("");
}

String _4() {
	if (Thread.getCurrent() in Regex.regexRefs) {
		return Regex.regexRefs[Thread.getCurrent()][3];
	}

	return new String("");
}

String _5() {
	if (Thread.getCurrent() in Regex.regexRefs) {
		return Regex.regexRefs[Thread.getCurrent()][4];
	}

	return new String("");
}

String _6() {
	if (Thread.getCurrent() in Regex.regexRefs) {
		return Regex.regexRefs[Thread.getCurrent()][5];
	}

	return new String("");
}

String _7() {
	if (Thread.getCurrent() in Regex.regexRefs) {
		return Regex.regexRefs[Thread.getCurrent()][6];
	}

	return new String("");
}

String _8() {
	if (Thread.getCurrent() in Regex.regexRefs) {
		return Regex.regexRefs[Thread.getCurrent()][7];
	}

	return new String("");
}

String _9() {
	if (Thread.getCurrent() in Regex.regexRefs) {
		return Regex.regexRefs[Thread.getCurrent()][8];
	}

	return new String("");
}

class Regex {

	// Description: This constructor will create an instance of a Regex that will efficiently compute the regular expression given.
	// regex: The regular expression to utilize.
	this(String regex) {
		regularExpression = new String(regex);

		buildDFA();
	}

	this(string regex) {
		regularExpression = new String(regex);

		buildDFA();
	}

	// Description: This function will return a matched regular expression on the given String. Instances of a Regex will use a DFA based approach.
	// str: The String to run the regular expression upon.
	// Returns: The matched substring or null when no match could be found.
	String eval(String str) {
		return null;
	}

	String eval(string str) {
		return eval(new String(str));
	}

	// Description: This function will return a matched regular expression on the given String. Single use regular expression functions, such as this one, use a backtracking algorithm.
	// str: The String to run the regular expression upon.
	// regex: The regular expression to use.
	// Returns: The matched substring or null when no match could be found.
	static String eval(String str, String regex, string options = "") {
		int strPos;
		int regexPos;

		int currentGroupIdx = -1;

		int strPosStart;
		int regexPosStart;
		int regexGroupStart = int.max;
		int regexFlagPotential;

		int nextUnionPos = -1;
		int currentUnionPos = -1;

		int currentClassStart;

		int groupCount;

		int flags;

		const int PLUS_OK = 1;
		const int LAZY_KLEENE = 2;
		const int KLEENE_MATCHED = 4;

		struct GroupInfo
		{
			int startPos;
			int endPos;
			int strStartPos;
			int strPos;
			int parent;
			int unionPos;
			int groupId;
		}

		bool multiline;

		foreach(chr; options) {
			switch(chr) {
				case 'm':
					multiline = true;
					break;
				default:
					break;
			}
		}

		// This hash table contains information about a grouping
		// for a specific position in the regex.
		GroupInfo[int] groupInfo;

		// This hash table contains information that aids operators
		// for a specific position in the regex.
		int[int] operatorFlag;

		// This is a stack of the groupings currently in context.
		Stack!(int) groupStart = new Stack!(int)();
		Stack!(int) stack = new Stack!(int)();

		// Running flags
		bool running = true;
		bool matchMade = true;
		bool backtrack = false;
		bool noMatch = false;
		bool matchClass = false;
		bool matchInverse = false;
		bool matchRange = false;

		bool noMatchClass = false;

		bool backtrackedOnCaret = false;

		regexRefs[Thread.getCurrent()] = new String[](9);

		// Suppresses group matching until a position is reached.
		int noMatchUntilClosedAtPos = -1;
		int noMatchUntilUnionForPos = -1;

		// This function will set a backtracking point in the regex.
		void setBacktrack(int newRegexPos, int newStrPos)
		{
			stack.push(newRegexPos);
			stack.push(newStrPos);
			stack.push(regexGroupStart);
			stack.push(currentGroupIdx);
			stack.push(regexFlagPotential);
		}

		// This function finds the regex position that will undo the last move.
		int findBackupRegexPosition()
		{
			int ret = regexPos - 1;
			if (ret in groupInfo)
			{
				ret = groupInfo[ret].startPos;
			}
			else if (ret < regex.length && regex[ret] == ']' && ret in operatorFlag)
			{
				ret = operatorFlag[ret];
			}
			else
			{
				if (ret > 0 && regex[ret-1] == '\\')
				{
					ret--;
				}
			}
			return ret;
		}

		// Like above, but for the working position.
		int findBackupPosition()
		{
			if (regexPos-1 in groupInfo)
			{
				return groupInfo[groupInfo[regexPos-1].startPos].strStartPos;
			}
			else
			{
				return strPos-1;
			}
		}

		// Set a backtrack that will return to the front of both strings.
		setBacktrack(0,0);

		// This structure hopes to minimize work already done by merely setting
		// a flag whenever a position in each string is reached. Since this
		// denotes that the regex will be parsing from the same state, and the
		// regex is pure, it will not have to repeat the work.
		int[][] memoizer = new int[][](str.length, regex.length);

		// Alright, main loop! This won't be broken until either a match is
		// found or nothing can be found.
		while(running) {

			// This is the mechanics for the memoizer. If a valid match has
			// been made and the regex positions are valid, set this position
			// pair in the memoizer indicating we've done this work before.
			if (strPos < str.length && regexPos < regex.length && matchMade && !noMatch) {
				if (memoizer[strPos][regexPos] == 1) {
					// we have been here before
					backtrack = true;
				}
				else {
					memoizer[strPos][regexPos] = 1;
				}
			}

			// If we are meant to backtrack this turn, this code path is taken.
			if (backtrack) {
				// steps are saved after successful matches
				// therefore the matchMade flag is always set
				matchMade = true;

				int oldRegexPos = regexPos;

				regexFlagPotential = stack.pop();
				currentGroupIdx = stack.pop();
				regexGroupStart = stack.pop();
				strPos = stack.pop();
				regexPos = stack.pop();

				if (regexPos == 0) {
					// We have gone back to the beginning...

					// we could attempt to find a union
					noMatch = true;
					noMatchUntilClosedAtPos = -1;
					noMatchUntilUnionForPos = -1;

					regexPos = oldRegexPos;
				}

				// OMG; Do not want to backtrack twice!
				backtrack = false;
			}

			if (regexPos >= regex.length) {
				// The regex has been consumed.

				if (noMatch) {
					if (noMatchUntilClosedAtPos == -1) {

						// No union, so just start the regex at the next character in the string.

						// UNLESS the backtrack happened at a 'caret' character in the regex
						if (backtrackedOnCaret) {
							matchMade = false;
							running = false;
							break;
						}

						strPosStart++;
						strPos = strPosStart;

						if (strPosStart >= str.length) {
							// bad
							matchMade = false;
							running = false;
							continue;
						}

						// start from a good state
						matchMade = true;

						// turn off find mode
						noMatch = false;

						regexPos = 0;

						// Set the backtrack to point to the start of the regex
						// with the new working position.
						setBacktrack(0, strPos);
					}
					else {
						// bad
						matchMade = false;
						running = false;
					}
				}
				else if (matchMade) {
					// good
					running = false;
					break;
				}
				else {
					// backtrack
					//regexPos = findBackupRegexPosition();
					//strPos = findBackupPosition();
					backtrack = true;
				}
				continue;
			}
			else if (noMatch && regex[regexPos] == '\\') {
				regexPos+=2;
				continue;
			}
			else if (noMatch && noMatchClass) {
				if (regex[regexPos] == ']') {
					noMatchClass = false;
				}
				regexPos++;
			}
			else if (noMatch && regex[regexPos] == '[') {
				// ignore!
				noMatchClass = true;
				continue;
			}
			else if (regex[regexPos] == '|') {

				// A union operator.

				if (currentGroupIdx >= 0) {
					if (groupInfo[currentGroupIdx].unionPos >= 0) {
						// the current group already has at least one union
						// use the current unionPos to append to the list
						if (!(currentUnionPos in operatorFlag) && regexPos > currentUnionPos) {
							operatorFlag[currentUnionPos] = regexPos;
						}
					}
					else {
						// this is the first union of the current group
						groupInfo[currentGroupIdx].unionPos = regexPos;
					}

					if (noMatch && noMatchUntilUnionForPos != -1 && groupInfo[currentGroupIdx].startPos == noMatchUntilClosedAtPos) {
						// turn off find mode
						noMatch = false;

						// start from a good state
						matchMade = true;
					}
					else if (matchMade && !noMatch) {
						// do not take this union
						// declare this group as good

						// but set a backtrack just in case
						// this will start the regular expression search from the next regex
						// point, but undoing the actions of the group thus far
						setBacktrack(regexPos+1, groupInfo[currentGroupIdx].strStartPos);

						if (groupInfo[currentGroupIdx].endPos >= 0) {
							regexPos = groupInfo[currentGroupIdx].endPos-1;
						}
						else {
							noMatch = true;
							noMatchUntilClosedAtPos = currentGroupIdx;
							noMatchUntilUnionForPos = -1;
						}
					}
					else if (!noMatch) {
						// undo actions
						strPos = groupInfo[currentGroupIdx].strStartPos;

						noMatch = false;

						matchMade = true;
					}
				}
				else {
					// union operator is in the main regex (top level)

					// If we are searching for a union to continue a failed search
					// We will enter the next code path. We have found a top level
					// union operator.
					if (noMatch && noMatchUntilClosedAtPos == -1 && noMatchUntilUnionForPos == -1) {
						// Set the backtrack to point to the start of the regex
						// with the new working position.
						setBacktrack(0, strPos);

						// turn off find mode
						noMatch = false;

						// start from a good state
						matchMade = true;
					}
					else if (noMatch && noMatchUntilUnionForPos != -1) {
						// turn off find mode
						noMatch = false;

						// start from a good state
						matchMade = true;
					}
					else if (matchMade) {
						// accept the regular expression
						running = false;
						break;
					}
					else {
						// we start anew, but at this regular expression
						strPos = strPosStart;
					}
				}

				currentUnionPos = regexPos;
				regexPos++;
			}
			else if (regex[regexPos] == '(' && (matchMade || noMatch) ) {

				// The start of a grouping.

				bool isNew;

				if (!(regexPos in groupInfo)) {
					GroupInfo newGroup;
					newGroup.startPos = regexPos;
					newGroup.endPos = -1;
					newGroup.strPos = strPos;
					newGroup.strStartPos = strPos;
					newGroup.parent = currentGroupIdx;
					newGroup.unionPos = -1;

					// This assumes that all groups will be visited
					// in order from left to right.
					newGroup.groupId = groupCount;
					groupCount++;

					groupInfo[regexPos] = newGroup;

					isNew = true;
				}

				groupInfo[regexPos].strStartPos = strPos;
				groupInfo[regexPos].strPos = strPos;

				currentGroupIdx = regexPos;
				regexPos++;

				if (regexPos < regex.length - 1 && regex[regexPos] == '?') {
					switch(regex[regexPos+1]) {
						case '#':
							// comments
							if (groupInfo[currentGroupIdx].endPos > 0) {
								regexPos = groupInfo[currentGroupIdx].endPos;
							}
							else {
								// find the end of the group, ignoring everything
								while(regexPos < regex.length && regex[regexPos] != ')') {
									regexPos++;
								}

								// save the result
								groupInfo[currentGroupIdx].endPos = regexPos;
							}
							break;

						case '>':
							// atomic grouping
							break;

						case ':':
							// non-capturing
							if (isNew) {
								groupInfo[currentGroupIdx].groupId = int.max;
								groupCount--;
							}
							regexPos+=2;
							break;

						case '=':
							// zero-width positive lookahead
							break;

						case '!':
							// zero-width negative lookahead
							break;

						case '<':
							// zero-width lookbehind
							if (regexPos < regex.length - 3) {
								if (regex[regexPos+3] == '=') {
									// positive
								}
								else if (regex[regexPos+3] == '!') {
									// negative
								}
							}
							regexPos+=2;
							break;

						default:
							break;
					}
				}
			}
			else if (regex[regexPos] == ')') {

				// A group is ending.

				if (!(regexPos in groupInfo)) {
					groupInfo[currentGroupIdx].endPos = regexPos;
					groupInfo[regexPos] = groupInfo[currentGroupIdx];

					if (currentGroupIdx == noMatchUntilClosedAtPos) {
						noMatch = false;
					}
				}

				if (noMatch && noMatchUntilClosedAtPos == currentGroupIdx) {
					noMatch = false;
				}

				if (matchMade || noMatch) {
					groupInfo[groupInfo[regexPos].startPos].strPos = strPos;

					regexGroupStart = groupInfo[groupInfo[regexPos].startPos].groupId;

					// set consumption string

					if (!noMatch) {
						if (regexGroupStart < 9) {
							String consumed = new String(str[groupInfo[groupInfo[regexPos].startPos].strStartPos..strPos]);
							regexRefs[Thread.getCurrent()][regexGroupStart] = consumed;
							regexGroupStart++;
						}
					}
				}
				else {
					// if we can backtrack to make another decision in this group, do so
					// that would effectively undo moves that this group had made
					strPos = groupInfo[groupInfo[regexPos].startPos].strPos;
					//backtrack = true;
				}

				currentGroupIdx = groupInfo[regexPos].parent;
				regexPos++;
			}
			else if (noMatch) {
				regexPos++;
			}
			else if (regex[regexPos] == '*') {

				// Kleene star operator.

				if (regexPos < regex.length - 1 && regex[regexPos+1] == '?') {
					// this is a lazy kleene

					// it may have matched something, but it should ignore the work
					// for now that it had done and save it as part of the lazy operator

					if (matchMade) {
						// set backtrack to do another computation
						setBacktrack(findBackupRegexPosition(), strPos);

						//if (!(regexPos in operatorFlag)) {
						if (regexFlagPotential < regexPos) {
							// we have made a match, but have not attempted
							// to try not matching anything first

							// set the flag so that this operator knows that it has
							// already found a match
							operatorFlag[regexPos] = strPos;
							regexFlagPotential = regexPos;

							// set backtrack to start where this one would have
							// continued to
							setBacktrack(regexPos+2, strPos);

							// and then start all over by assuming nothing is taken
							strPos = findBackupPosition();
							regexPos+=2;
						}
						else {
							// we have already found a match
							// just continue on our way
							regexPos+=2;
						}
					}
					else {
						// the group fails, it is ok
						matchMade = true;
						regexPos+=2;
					}
				}
				else if (matchMade) {
					// this is a greedy kleene

					// the backtrack will suggest to just go to the next regex
					// character at this same string. this computation path,
					// however, will be attempting to match the previous group
					// as much as possible

					// we need to set a backtrack for having not matched anything even though
					// something was just matched. It could be that what we matched belongs to
					// another section of the regex.

					if (!(regexPos in operatorFlag) || regexFlagPotential < regexPos) {
						// set a backtrack for having nothing found
						setBacktrack(regexPos+1,findBackupPosition());
					}

					operatorFlag[regexPos] = 1;

					setBacktrack(regexPos+1, strPos);
					regexPos--;

					if (regexPos in groupInfo) {
						regexPos = groupInfo[regexPos].startPos;
						currentGroupIdx = regexPos;
					}
					else if (regexPos < regex.length && regex[regexPos] == ']' && regexPos in operatorFlag) {
						regexPos = operatorFlag[regexPos];
					}
					else {
						if (regexPos > 0 && regex[regexPos-1] == '\\') {
							regexPos--;
						}
					}
				}
				else {
					// it is ok
					matchMade = true;
					regexPos++;
				}
			}
			else if (regex[regexPos] == '+') {

				// Kleene plus operator.

				if (regexPos < regex.length - 1 && regex[regexPos+1] == '?') {
					// this is a lazy kleene

					if (matchMade) {
						// good, continue and set a backtrack to attempt another
						// match on this kleene

						// set the flag so that this operator knows that it has
						// already found a match
						operatorFlag[regexPos] = 1;
						regexFlagPotential = regexPos;

						// set the backtrace
						int newRegexPos = regexPos+2;

						regexPos--;
						if (regexPos in groupInfo) {
							regexPos = groupInfo[regexPos].startPos;
							currentGroupIdx = regexPos;
						}
						else if (regexPos < regex.length && regex[regexPos] == ']' && regexPos in operatorFlag) {
							regexPos = operatorFlag[regexPos];
						}
						else {
							if (regexPos > 0 && regex[regexPos-1] == '\\') {
								regexPos--;
							}
						}

						setBacktrack(regexPos, strPos);

						regexPos = newRegexPos;
					}
					else {
						if (regexFlagPotential < regexPos) {
							// we have not found any matches at all
							// fail the op

							//regexPos = findBackupRegexPosition();
							//strPos = findBackupPosition();
							backtrack = true;
							continue;
						}
						else {
							// it is ok, we found at least one
							matchMade = true;
							regexPos+=2;
						}
					}
				}
				else if (matchMade) {
					// this is a greedy kleene

					// the backtrack will suggest to just go to the next regex
					// character at this same string. this computation path,
					// however, will be attempting to match the previous group
					// as much as possible

					setBacktrack(regexPos+1, strPos);

					// set the flag so that this operator knows that it has
					// already found a match
					operatorFlag[regexPos] = 1;
					regexFlagPotential = regexPos;

					regexPos--;
					if (regexPos in groupInfo) {
						regexPos = groupInfo[regexPos].startPos;
						currentGroupIdx = regexPos;
					}
					else if (regexPos < regex.length && regex[regexPos] == ']' && regexPos in operatorFlag) {
						regexPos = operatorFlag[regexPos];
					}
					else {
						if (regexPos > 0 && regex[regexPos-1] == '\\') {
							regexPos--;
						}
					}
				}
				else {
					// it is ok
					if (regexPos in operatorFlag && regexFlagPotential >= regexPos) {
						// good
						matchMade = true;
						regexPos++;
					}
					else {
						// fail the op
						//regexPos = findBackupRegexPosition();
						//strPos = findBackupPosition();
						backtrack = true;
						continue;
					}
				}
			}
			else if (regex[regexPos] == '?') {
				// option
				regexPos++;

				if (regexPos < regex.length && regex[regexPos] == '?') {
					// lazy option
					regexPos++;
					if (matchMade) {
						// unfortunately, this work that has been done
						// has been done in vain. We want to attempt to
						// not consume this option.

						// set the backtrack to backtrack to the current
						// situation (taking the option)
						setBacktrack(regexPos, strPos);

						// now, attempt to carry on to the next part of
						// the regex while undoing the last group
						strPos = findBackupPosition();
					}
					else {
						// very good, only one possible outcome: no match
						matchMade = true;
					}
				}
				else if (matchMade) {
					// greedy option

					// backtrack to not taking the option
					setBacktrack(regexPos, findBackupPosition());
				}
				else {
					// greedy option
					matchMade = true;
				}
			}
			else if (!matchMade) {
				// the group fails if a concatenation fails
				if (currentGroupIdx >= 0) {
					int curUnionPos = -1;

					if (groupInfo[currentGroupIdx].unionPos >= 0) {
						curUnionPos = groupInfo[currentGroupIdx].unionPos;

						while(curUnionPos < regexPos && curUnionPos in operatorFlag) {
							curUnionPos = operatorFlag[curUnionPos];
						}

						if (curUnionPos < regexPos) {
							curUnionPos = -1;
						}
					}

					if (curUnionPos >= 0) {
						regexPos = curUnionPos;
					}
					else if (groupInfo[currentGroupIdx].endPos >= 0) {
						regexPos = groupInfo[currentGroupIdx].endPos;
					}
					else {
						// need to find either a union for this group
						// or the group end
						noMatch = true;
						noMatchUntilClosedAtPos = currentGroupIdx;
						noMatchUntilUnionForPos = currentGroupIdx;
					}
				}
				else {
					backtrack = true;
					continue;
				}
			}
			else if (regex[regexPos] == '$') {

				// dollar anchor

				if (strPos == str.length || str[strPos] == '\n' || str[strPos] == '\r') {
					matchMade = true;
				}
				else {
					//regexPos = findBackupRegexPosition();
					//strPos = findBackupPosition();
					backtrack = true;
					continue;
				}
				regexPos++;
			}
			else if (regex[regexPos] == '^') {

				// caret anchor

				if (multiline) {
					if (strPos == 0 || str[strPos-1] == '\n' || str[strPos-1] == '\r') {
						matchMade = true;
					}
					else {
						// Multiline option:
						backtrack = true;
						continue;
					}
				}
				else {
					if (strPos == 0) {
						matchMade = true;
					}
					else {
						backtrackedOnCaret = true;
						// Nonmultiline option:
						backtrack = true;
						continue;
					}
				}
				regexPos++;
			}
			else if (((regexPos + 1) < regex.length) && (regex[regexPos] == '\\') && (regex[regexPos+1] == 'b')) {

				// word boundary anchor

				// Check for boundary
				if (strPos == 0) {
					// Anchored to the beginning of the string

					// The first character should be a word character
					if ( (str[strPos] >= 'a' && str[strPos] <= 'z') ||
						 (str[strPos] >= 'A' && str[strPos] <= 'Z') ||
						 (str[strPos] >= '0' && str[strPos] <= '9') ||
						 (str[strPos] == '_')) {
						matchMade = true;
					}
					else {
						backtrack = true;
						continue;
					}
				}
				else if ((strPos == str.length) && (str.length > 0)) {
					// Anchored at end of string
					matchMade = true;

					// The last character should be a word character
					if ( (str[strPos-1] >= 'a' && str[strPos-1] <= 'z') ||
						 (str[strPos-1] >= 'A' && str[strPos-1] <= 'Z') ||
						 (str[strPos-1] >= '0' && str[strPos-1] <= '9') ||
						 (str[strPos-1] == '_')) {
						matchMade = true;
					}
					else {
						backtrack = true;
						continue;
					}
				}
				else {
					// It is between two characters
					// One or the other (exclusive) should be a word character

					bool firstWordCharacter = false;

					if ( (str[strPos-1] >= 'a' && str[strPos-1] <= 'z') ||
						 (str[strPos-1] >= 'A' && str[strPos-1] <= 'Z') ||
						 (str[strPos-1] >= '0' && str[strPos-1] <= '9') ||
						 (str[strPos-1] == '_')) {
						firstWordCharacter = true;
					}

					if ( (str[strPos] >= 'a' && str[strPos] <= 'z') ||
						 (str[strPos] >= 'A' && str[strPos] <= 'Z') ||
						 (str[strPos] >= '0' && str[strPos] <= '9') ||
						 (str[strPos] == '_')) {
						if (!firstWordCharacter) {
							matchMade = true;
						}
						else {
							backtrack = true;
							continue;
						}
					}
					else if (firstWordCharacter) {
						matchMade = true;
					}
					else {
						backtrack = true;
						continue;
					}
				}
				regexPos+=2;
			}
			else {
				// concatentation

				if (regex[regexPos] == '[') {
					currentClassStart = regexPos;

					matchClass = true;

					regexPos++;
					if (regexPos < regex.length && regex[regexPos] == '^') {
						matchInverse = true;
						regexPos++;
					}
					else {
						matchInverse = false;
					}

					// cancel when we run out of space
					if (regexPos == regex.length) {
						continue;
					}
				}

				do {
					if (matchClass && regex[regexPos] == ']') {
						operatorFlag[currentClassStart] = regexPos;
						operatorFlag[regexPos] = currentClassStart;
						if (matchInverse && !matchMade) {
							matchMade = true;
							matchInverse = false;
						}
						matchClass = false;
					}
					else if (matchClass && regexPos < regex.length - 1 && regex[regexPos+1] == '-') {
						// character class range, use the last character
						// and build a range of possible values

						matchRange = true;
						regexPos+=2;
						continue;
					}
					else if (matchRange) {
						matchMade = strPos < str.length && str[strPos] >= regex[regexPos-2] && str[strPos] <= regex[regexPos];

						// no more ranges!
						matchRange = false;
					}
					else if (regex[regexPos] == '\\' && regexPos < regex.length-1) {
						regexPos++;
						if (strPos >= str.length) {
							matchMade = false;
						}
						else {
							switch(regex[regexPos]) {
								case '1':
								case '2':
								case '3':
								case '4':
								case '5':
								case '6':
								case '7':
								case '8':
								case '9':
									int refIndex = cast(uint)regex[regexPos] - cast(uint)'1';
									// forward and backward references

									if (Thread.getCurrent() in regexRefs) {
										if (regexRefs[Thread.getCurrent()][refIndex] !is null) {
											matchMade = true;

											foreach(int i, chr; regexRefs[Thread.getCurrent()][refIndex]) {

												if (strPos >= str.length) {
													matchMade = false;
													break;
												}

												if (str[strPos] != chr) {
													matchMade = false;
													break;
												}

												strPos++;
											}

											if (matchMade) {
												strPos--;
											}
										}
										else {
											matchMade = false;
										}
									}
									else {
										matchMade = false;
									}
									break;
								case 'd':
									matchMade = (str[strPos] >= '0' && str[strPos] <= '9');
									break;

								case 'D':
									matchMade = !(str[strPos] >= '0' && str[strPos] <= '9');
									break;

								case 's':
									matchMade = (str[strPos] == ' '
												|| str[strPos] == '\t'
												|| str[strPos] == '\r'
												|| str[strPos] == '\n'
												|| str[strPos] == '\v'
												|| str[strPos] == '\f');
									break;

								case 'S':
									matchMade = (str[strPos] != ' '
												&& str[strPos] != '\t'
												&& str[strPos] != '\r'
												&& str[strPos] != '\n'
												&& str[strPos] != '\v'
												&& str[strPos] != '\f');
									break;

								case 'w':
									matchMade = (str[strPos] == '_'
												|| (str[strPos] >= 'a' && str[strPos] <= 'z')
												|| (str[strPos] >= 'A' && str[strPos] <= 'Z'));
									break;

								case 'W':
									matchMade = (str[strPos] != '_'
												&& (str[strPos] < 'a' || str[strPos] > 'z')
												&& (str[strPos] < 'A' || str[strPos] > 'Z'));
									break;

								case 'b':
									// backspace
									matchMade = str[strPos] == '\b';
									break;

								case 'n':
									// newline
									matchMade = str[strPos] == '\n';
									break;

								case 'e':
									// escape
									matchMade = str[strPos] == '\x1b';
									break;

								case 'v':
									matchMade = str[strPos] == '\v';
									break;

								case 't':
									matchMade = str[strPos] == '\t';
									break;

								case 'r':
									matchMade = str[strPos] == '\r';
									break;

								case 'a':
									matchMade = str[strPos] == '\a';
									break;

								case '0':
									matchMade = str[strPos] == '\0';
									break;

								case '\0':
									matchMade = str[strPos] == '\0';
									break;

								default:
									matchMade = str[strPos] == regex[regexPos];
									break;
							}
						}
					}
					else if (regexPos < regex.length && strPos < str.length
							&& ((str[strPos] == regex[regexPos])
							|| (!matchClass && regex[regexPos] == '.'
							&& str[strPos] != '\n' && str[strPos] != '\r'))) {
						// match made
						matchMade = true;
					}
					else {
						// no match made
						matchMade = false;
					}

					if ((matchMade && matchInverse) || (matchInverse && strPos >= str.length)) {
						matchMade = false;
						break;
					}

					if (matchClass && !matchMade && regexPos < regex.length) {
						regexPos++;
						continue;
					}

					break;

				} while (true);

				matchRange = false;
				matchInverse = false;

				if (matchClass) {
					matchClass = false;

					if (currentClassStart in operatorFlag) {
						regexPos = operatorFlag[currentClassStart];
					}
					else {
						// dang, need to search for it
						regexPos++;
						for(;regexPos < regex.length && regex[regexPos] != ']'; regexPos++) {
							if (regex[regexPos] == '\\') { regexPos++; }
						}

						if (regexPos >= regex.length) { continue; }

						operatorFlag[currentClassStart] = regexPos;
						operatorFlag[regexPos] = currentClassStart;
					}
				}

				if (matchMade) {

					// consume input string
					strPos++;
				}

				// consume
				regexPos++;
			}
		}

		// Null out any outstanding groups
		if (Thread.getCurrent() in regexRefs) {
			for( ; regexGroupStart < 9 ; regexGroupStart++ ) {
			//	regexRefs[Thread.getCurrent()][regexGroupStart]
				//	= null;
			}
		}

		// Return the result
		if (matchMade && strPosStart <= str.length) {
			if (strPos-strPosStart == 0) {
				return new String("");
			}
			return str.subString(strPosStart, strPos-strPosStart);
		}

		return null;
	}

	static String eval(string str, String regex) {
		return eval(new String(str), regex);
	}

	static String eval(String str, string regex) {
		return eval(str, new String(regex));
	}

	static String eval(string str, string regex) {
		return eval(new String(str), new String(regex));
	}

protected:

	// These instance variables contain the data structures
	// that will build and maintain the DFA for the regular expression

	// Holds the regular expression for the instance
	String regularExpression;

	void buildDFA() {
	}

private:

	static String[][Thread] regexRefs;

}
