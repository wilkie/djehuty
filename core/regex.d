/*
 * regex.d
 *
 * This file contains the logic behind a regular expression parser.
 *
 * Author: Dave Wilkinson
 * Originated: May 9th, 2009
 * Inspiration: "Albino 2" by Mark Knight
 *
 */

module core.regex;

import core.string;
import core.definitions;

import synch.thread;

import io.console;

import data.stack;
import data.list;

// This provides thread-local access to regex variables set via
// Regex groups.

uint _position() {
	if (Thread.current() in Regex.regexPos) {
		return Regex.regexPos[Thread.current()];
	}

	return uint.max;
}

string _1() {
	if (Thread.current() in Regex.regexRefs) {
		return Regex.regexRefs[Thread.current()][0];
	}

	return ("");
}

string _2() {
	if (Thread.current() in Regex.regexRefs) {
		return Regex.regexRefs[Thread.current()][1];
	}

	return ("");
}

string _3() {
	if (Thread.current() in Regex.regexRefs) {
		return Regex.regexRefs[Thread.current()][2];
	}

	return ("");
}

string _4() {
	if (Thread.current() in Regex.regexRefs) {
		return Regex.regexRefs[Thread.current()][3];
	}

	return ("");
}

string _5() {
	if (Thread.current() in Regex.regexRefs) {
		return Regex.regexRefs[Thread.current()][4];
	}

	return ("");
}

string _6() {
	if (Thread.current() in Regex.regexRefs) {
		return Regex.regexRefs[Thread.current()][5];
	}

	return ("");
}

string _7() {
	if (Thread.current() in Regex.regexRefs) {
		return Regex.regexRefs[Thread.current()][6];
	}

	return ("");
}

string _8() {
	if (Thread.current() in Regex.regexRefs) {
		return Regex.regexRefs[Thread.current()][7];
	}

	return ("");
}

string _9() {
	if (Thread.current() in Regex.regexRefs) {
		return Regex.regexRefs[Thread.current()][8];
	}

	return ("");
}

class Regex {

	// Description: This constructor will create an instance of a Regex that will efficiently compute the regular expression given.
	// regex: The regular expression to utilize.
	this(string regex) {
		regularExpression = (regex);

		buildDFA(false);
	}

	// Description: This function will return a matched regular expression on the given string. Single use regular expression functions, such as this one, use a backtracking algorithm.
	// str: The string to run the regular expression upon.
	// regex: The regular expression to use.
	// Returns: The matched substring or null when no match could be found.
	static string eval(string str, string regex, string options = "") {
		RegexInfo regexInfo;
		
		/*
		static RegexInfo[string] oldRuns;

		string oldRunIndex = (regex.tostring() ~ "_" ~ options);
		if (oldRunIndex in oldRuns) {
			regexInfo = oldRuns[oldRunIndex];
		}*/

		regexInfo.memoizer = new int[][](str.length, regex.length);

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

		regexRefs[Thread.current()] = new string [](9);

		// Suppresses group matching until a position is reached.
		int noMatchUntilClosedAtPos = -1;
		int noMatchUntilUnionForPos = -1;

		// This function will set a backtracking point in the regex.
		void setBacktrack(int newRegexPos, int newStrPos) {
			stack.push(newRegexPos);
			stack.push(newStrPos);
			stack.push(regexGroupStart);
			stack.push(currentGroupIdx);
			stack.push(regexFlagPotential);
		}

		// This function finds the regex position that will undo the last move.
		int findBackupRegexPosition() {
			int ret = regexPos - 1;
			if (ret in regexInfo.groupInfo) {
				ret = regexInfo.groupInfo[ret].startPos;
			}
			else if (ret < regex.length && regex[ret] == ']' && ret in regexInfo.operatorFlag) {
				ret = regexInfo.operatorFlag[ret];
			}
			else {
				if (ret > 0 && regex[ret-1] == '\\') {
					ret--;
				}
			}
			return ret;
		}

		// Like above, but for the working position.
		int findBackupPosition() {
			if (regexPos-1 in regexInfo.groupInfo) {
				return regexInfo.groupInfo[regexInfo.groupInfo[regexPos-1].startPos].strStartPos;
			}
			else {
				return strPos-1;
			}
		}

		// Set a backtrack that will return to the front of both strings.
		setBacktrack(0,0);

		// Alright, main loop! This won't be broken until either a match is
		// found or nothing can be found.
		while(running) {

			// This is the mechanics for the memoizer. If a valid match has
			// been made and the regex positions are valid, set this position
			// pair in the memoizer indicating we've done this work before.
			if (strPos < str.length && regexPos < regex.length && matchMade && !noMatch) {
				if (regexInfo.memoizer[strPos][regexPos] == 1) {
					// we have been here before
					backtrack = true;
				}
				else {
					regexInfo.memoizer[strPos][regexPos] = 1;
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
					if (regexInfo.groupInfo[currentGroupIdx].unionPos >= 0) {
						// the current group already has at least one union
						// use the current unionPos to append to the list
						if (!(currentUnionPos in regexInfo.operatorFlag) && regexPos > currentUnionPos) {
							regexInfo.operatorFlag[currentUnionPos] = regexPos;
						}
					}
					else {
						// this is the first union of the current group
						regexInfo.groupInfo[currentGroupIdx].unionPos = regexPos;
					}

					if (noMatch && noMatchUntilUnionForPos != -1 && currentGroupIdx == noMatchUntilClosedAtPos) {
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
						setBacktrack(regexPos+1, regexInfo.groupInfo[currentGroupIdx].strStartPos);

						if (regexInfo.groupInfo[currentGroupIdx].endPos >= 0) {
							regexPos = regexInfo.groupInfo[currentGroupIdx].endPos-1;
						}
						else {
							noMatch = true;
							noMatchUntilClosedAtPos = currentGroupIdx;
							noMatchUntilUnionForPos = -1;
						}
					}
					else if (!noMatch) {
						// undo actions
						strPos = regexInfo.groupInfo[currentGroupIdx].strStartPos;

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

				if (!(regexPos in regexInfo.groupInfo)) {
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

					regexInfo.groupInfo[regexPos] = newGroup;

					isNew = true;
				}

				regexInfo.groupInfo[regexPos].strStartPos = strPos;
				regexInfo.groupInfo[regexPos].strPos = strPos;

				currentGroupIdx = regexPos;
				regexPos++;

				if (regexPos < regex.length - 1 && regex[regexPos] == '?') {
					switch(regex[regexPos+1]) {
						case '#':
							// comments
							if (regexInfo.groupInfo[currentGroupIdx].endPos > 0) {
								regexPos = regexInfo.groupInfo[currentGroupIdx].endPos;
							}
							else {
								// find the end of the group, ignoring everything
								while(regexPos < regex.length && regex[regexPos] != ')') {
									regexPos++;
								}

								// save the result
								regexInfo.groupInfo[currentGroupIdx].endPos = regexPos;
							}
							break;

						case '>':
							// atomic grouping
							break;

						case ':':
							// non-capturing
							if (isNew) {
								regexInfo.groupInfo[currentGroupIdx].groupId = int.max;
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

				if (!(regexPos in regexInfo.groupInfo)) {
					regexInfo.groupInfo[currentGroupIdx].endPos = regexPos;
					regexInfo.groupInfo[regexPos] = regexInfo.groupInfo[currentGroupIdx];

					if (currentGroupIdx == noMatchUntilClosedAtPos) {
						noMatch = false;
					}
				}

				if (noMatch && noMatchUntilClosedAtPos == currentGroupIdx) {
					noMatch = false;
				}

				if (matchMade || noMatch) {
					regexInfo.groupInfo[regexInfo.groupInfo[regexPos].startPos].strPos = strPos;

					regexGroupStart = regexInfo.groupInfo[regexInfo.groupInfo[regexPos].startPos].groupId;

					// set consumption string

					if (!noMatch) {
						if (regexGroupStart < 9) {
							string consumed = (str[regexInfo.groupInfo[regexInfo.groupInfo[regexPos].startPos].strStartPos..strPos]);
							regexRefs[Thread.current()][regexGroupStart] = consumed;
							regexGroupStart++;
						}
					}
				}
				else {
					// if we can backtrack to make another decision in this group, do so
					// that would effectively undo moves that this group had made
					strPos = regexInfo.groupInfo[regexInfo.groupInfo[regexPos].startPos].strPos;
					//backtrack = true;
				}

				currentGroupIdx = regexInfo.groupInfo[regexPos].parent;
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

						//if (!(regexPos in regexInfo.operatorFlag)) {
						if (regexFlagPotential < regexPos) {
							// we have made a match, but have not attempted
							// to try not matching anything first

							// set the flag so that this operator knows that it has
							// already found a match
							regexInfo.operatorFlag[regexPos] = strPos;
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

					if (!(regexPos in regexInfo.operatorFlag) || regexFlagPotential < regexPos) {
						// set a backtrack for having nothing found
						setBacktrack(regexPos+1,findBackupPosition());
					}

					regexInfo.operatorFlag[regexPos] = 1;

					setBacktrack(regexPos+1, strPos);
					regexPos--;

					if (regexPos in regexInfo.groupInfo) {
						regexPos = regexInfo.groupInfo[regexPos].startPos;
						currentGroupIdx = regexPos;
					}
					else if (regexPos < regex.length && regex[regexPos] == ']' && regexPos in regexInfo.operatorFlag) {
						regexPos = regexInfo.operatorFlag[regexPos];
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
						regexInfo.operatorFlag[regexPos] = 1;
						regexFlagPotential = regexPos;

						// set the backtrace
						int newRegexPos = regexPos+2;

						regexPos--;
						if (regexPos in regexInfo.groupInfo) {
							regexPos = regexInfo.groupInfo[regexPos].startPos;
							currentGroupIdx = regexPos;
						}
						else if (regexPos < regex.length && regex[regexPos] == ']' && regexPos in regexInfo.operatorFlag) {
							regexPos = regexInfo.operatorFlag[regexPos];
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
					regexInfo.operatorFlag[regexPos] = 1;
					regexFlagPotential = regexPos;

					regexPos--;
					if (regexPos in regexInfo.groupInfo) {
						regexPos = regexInfo.groupInfo[regexPos].startPos;
						currentGroupIdx = regexPos;
					}
					else if (regexPos < regex.length && regex[regexPos] == ']' && regexPos in regexInfo.operatorFlag) {
						regexPos = regexInfo.operatorFlag[regexPos];
					}
					else {
						if (regexPos > 0 && regex[regexPos-1] == '\\') {
							regexPos--;
						}
					}
				}
				else {
					// it is ok
					if (regexPos in regexInfo.operatorFlag && regexFlagPotential >= regexPos) {
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

					if (regexInfo.groupInfo[currentGroupIdx].unionPos >= 0) {
						curUnionPos = regexInfo.groupInfo[currentGroupIdx].unionPos;

						while(curUnionPos < regexPos && curUnionPos in regexInfo.operatorFlag) {
							curUnionPos = regexInfo.operatorFlag[curUnionPos];
						}

						if (curUnionPos < regexPos) {
							curUnionPos = -1;
						}
					}
					
					strPos = regexInfo.groupInfo[currentGroupIdx].strStartPos;

					if (curUnionPos >= 0) {
						regexPos = curUnionPos;
					}
					else if (regexInfo.groupInfo[currentGroupIdx].endPos >= 0) {
						regexPos = regexInfo.groupInfo[currentGroupIdx].endPos;
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
						regexInfo.operatorFlag[currentClassStart] = regexPos;
						regexInfo.operatorFlag[regexPos] = currentClassStart;
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

									if (Thread.current() in regexRefs) {
										if (regexRefs[Thread.current()][refIndex] !is null) {
											matchMade = true;

											foreach(int i, chr; regexRefs[Thread.current()][refIndex]) {

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

					if (currentClassStart in regexInfo.operatorFlag) {
						regexPos = regexInfo.operatorFlag[currentClassStart];
					}
					else {
						// dang, need to search for it
						regexPos++;
						for(;regexPos < regex.length && regex[regexPos] != ']'; regexPos++) {
							if (regex[regexPos] == '\\') { regexPos++; }
						}

						if (regexPos >= regex.length) { continue; }

						regexInfo.operatorFlag[currentClassStart] = regexPos;
						regexInfo.operatorFlag[regexPos] = currentClassStart;
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
		if (Thread.current() in regexRefs) {
			for( ; regexGroupStart < 9 ; regexGroupStart++ ) {
			//	regexRefs[Thread.current()][regexGroupStart]
				//	= null;
			}
		}

		/*
		if (!(oldRunIndex in oldRuns)) {
			oldRuns[oldRunIndex] = regexInfo;
		}*/

		// Return the result
		if (matchMade && strPosStart <= str.length) {
			if (strPos-strPosStart == 0) {
				return ("");
			}

			// Save the position where the string was consumed
			this.regexPos[Thread.current()] = strPosStart;

			// Slice and return the consumed string
			return str.substring(strPosStart, strPos-strPosStart);
		}

		return null;
	}

	// Description: This function will return a matched regular expression on the given string. Instances of a Regex will use a DFA based approach.
	// str: The string to run the regular expression upon.
	// Returns: The matched substring or null when no match could be found.
	string eval(string str) {
		State currentState = startingState;

		uint strPos;
		uint startingStrPos;

		State acceptState;
		uint acceptStrEnd;

		dchar chr;
		for (strPos = startingStrPos; strPos < str.length; strPos++) {
		//	Console.putln("starting ... ", startingStrPos);
			chr = str[strPos];
		//	Console.putln("chr ... ", str[strPos]);
			if (chr in currentState.transitions) {
				// Take transition
				//Console.putln("taking transition ", chr, " from ", currentState.id, " to ", currentState.transitions[chr].id);
				currentState = currentState.transitions[chr];
				if (currentState.accept) {
					//Console.putln("found accept at ", strPos, " from ", startingStrPos);
					acceptStrEnd = strPos + 1;
					acceptState = currentState;
				}
			}
			else {
				// No transition
				
				if (acceptStrEnd > startingStrPos) {
					Console.putln("Leaving Early");
					strPos = acceptStrEnd;
					currentState = acceptState;
				}

				// Is this an accept state?
				if (currentState.accept) {
					break;
				}

				// Start over

				if (startingStrPos >= str.length) {
					// No more to search
					return null;
				}

				// Next turn, strPos will be startingStrPos + 1
				// (because of loop iteration)
				strPos = startingStrPos;

				// We are sliding down the string by one character
				startingStrPos++;

				// We go back to the beginning
				currentState = startingState;
			}
		}
				
		if (acceptStrEnd > startingStrPos) {
			Console.putln("Leaving Early");
			strPos = acceptStrEnd;
			currentState = acceptState;
		}

		// Return consumed string
		if (currentState.accept) {
			return str.substring(startingStrPos, strPos - startingStrPos);
		}

		// No match
		return null;
	}

protected:

	// These instance variables contain the data structures
	// that will build and maintain the DFA for the regular expression

	// Holds the regular expression for the instance
	string regularExpression;

	// For DFA regex operations
	
	class Link {
		State from;
		dchar transition;
	}

	static class State {
		State[dchar] transitions;
		// List!(Group) groupStarts;
		// List!(Group) groupEnds;
		List!(dchar) backwardList;
		List!(Link) incomingList;

		bool accept;

		int id;

		this() {
			this(count);
		}

		this(int id) {
			this.id = id;
			backwardList = new List!(dchar);
			incomingList = new List!(Link);
			debugThis();
		}

		// Debugging block
		static int count = 0;
		static List!(State) all;

		static this() {
			all = new List!(State);
		}

		void debugThis() {
			count++;
			all.add(this);
		}
	
		string tostring() {
			string ret = "State " ~ toStr(id) ~ ": [";

			if (accept) {
				ret ~= "A] ";
			}
			else {
				ret ~= " ] ";
			}

			foreach(key; transitions.keys) {
				if (transitions[key].id <= id) {
					ret ~= toStr(key) ~ "<>" ~ toStr(transitions[key].id) ~ " ";
				}
				else {
					ret ~= toStr(key) ~ "->" ~ toStr(transitions[key].id) ~ " ";
				}
			}
			return ret;
		}

		static void printall() {
			foreach(state; all) {
				Console.putln(state);
			}
		}
	}

	State startingState;

	void buildDFA(bool useDFARules = false) {
		_DFARules = useDFARules;

		// Go through the regular expression and build the DFAs
		startingState = buildDFA(regularExpression);
	}

private:

	bool _DFARules;

	struct DFAGroupInfo {
		bool hasKleene;
		int endPos;
	}

	DFAGroupInfo[int] _groupInfo;

	void fillGroupInfo() {
		_groupInfo = null;

		dchar ch;

		List!(int) groupStack = new List!(int);

		for (uint i; i < regularExpression.length; i++) {
			Console.putln("foo ", i);
			ch = regularExpression[i];
			switch (ch) {
				case '\0':
					return;
				case '\\':
					i++;
					continue;
				case '(':
					groupStack.add(cast(int)i);
					DFAGroupInfo dgi;
					_groupInfo[i] = dgi;
					break;
				case ')':
					int startPos = groupStack.remove();
					if (startPos in _groupInfo) {
						_groupInfo[startPos].endPos = i;
						if ((i + 1 < regularExpression.length) && regularExpression[i+1] == '*') {
							Console.putln("HAS KLEENE");
							_groupInfo[startPos].hasKleene = true;
							i++;
						}
					}
					break;
				default:
					if (groupStack.empty()) {
						Console.putln("NULLED");
						_groupInfo = null;
					}
					break;
			}
		}
	}

	State buildDFA(string regex) {
		fillGroupInfo();
		uint regexPos = 0;
		List!(State) current = new List!(State);
		return buildDFA(regex, regexPos, current);
	}

	State buildDFA(string regex, ref uint regexPos, ref List!(State) current, bool isKleene = false) {
		State startState = new State();
		Console.putln("Start State: ", startState.id);

		uint groupPos = regexPos - 1;

		dchar lastChar = '\0';
		dchar thisChar;
		dchar lastConcatChar = '\0';

		enum Operation {
			None,
			Kleene,
			Concat
		}

		Operation lastOp = Operation.None;

		List!(State) old = current.dup();
		current.add(startState);

		if (regexPos < regex.length) {
			lastChar = regex[regexPos];
			if (lastChar == '*') {
				// error
			}
			else if (lastChar == '(') {
				// group
				regexPos++;
				buildDFA(regex, regexPos, current);
				if (regex[regexPos] == '*') {
					Console.putln("Inner Group Kleened");
					lastOp = Operation.Kleene;
				}
			}
			else {
				lastConcatChar = lastChar;
			}
			regexPos++;
		}

		while (regexPos <= regex.length) {
			if (regexPos == regex.length) {
				thisChar = '\0';
			}
			else {
				thisChar = regex[regexPos];
			}

			if (thisChar == '*') {
				// Kleene Star
				//Console.putln("Kleene (", lastChar, ")");
				if (lastChar == ')') {
					Console.putln("Kleene Group End, connecting ", lastConcatChar, " to ", startState.id);
					foreach(state; current) {
						State ret = concat(state, lastConcatChar, startState);
						if (ret is startState && startState.id <= state.id) {
							state.backwardList.add(lastConcatChar);
							Link link = new Link();
							link.from = state;
							link.transition = lastConcatChar;
							startState.incomingList.add(link);
						}
					}
					old.add(startState);
					current = old;
					State.printall();
					return startState;
				}
				else {
					// Single Character Kleene
					// ex. "a*" => [p] -> 'a' -> [p]
					Console.putln("Single Character Kleene (", lastConcatChar, ")");

					List!(State) newStateList = current.dup;
					State loopState;
					foreach(state; current) {
						if (state.backwardList.empty) {
							while (lastConcatChar in state.transitions) {
								state = concat(state, lastConcatChar, state);
							}

							state.transitions[lastConcatChar] = state;
							state.backwardList.add(lastConcatChar);
						}
						else {
							if (loopState is null) {
								loopState = new State();
								loopState.transitions[lastConcatChar] = loopState;
								loopState.backwardList.add(lastConcatChar);
							}
							State ret = concat(state, lastConcatChar, loopState);
						}
					}

					current = newStateList;

					if (loopState !is null) {
						current.add(loopState);
					}

					//Console.putln("Done Single Character Kleene (", lastConcatChar, ")");
				}
				lastOp = Operation.Kleene;
				lastConcatChar = '\0';
			}
			else {
				// concatenation
				if (lastConcatChar != '\0' && thisChar != ')') {
					Console.putln("-=-=-=-=-");
					Console.putln("boo: ", lastOp == Operation.Kleene);
					State concatState;
					List!(State) newStateList = new List!(State);
					foreach(state; current) {
						State ret = concat(state, lastConcatChar, concatState, lastOp == Operation.Kleene);
						if (ret !is concatState && ret !is null) {
							newStateList.add(ret);
						}
					}
					if (concatState !is null) {
						newStateList.add(concatState);
					}
					current = newStateList;
					Console.putln("Concat Character (", lastConcatChar, ")");
					State.printall();
					Console.putln("-=-=-=-=-");
					foreach(state; current) {
						Console.put(state.id, " ... ");
					}
					Console.putln;
					lastOp = Operation.Concat;
				}

				if (thisChar == '(') {
					// group start
					Console.putln("Inner Group Found");
					regexPos+=1;
					buildDFA(regex, regexPos, current, false);
					if (regex[regexPos] == '*') {
						Console.putln("Inner Group Kleened");
						lastOp = Operation.Kleene;
					}
					lastConcatChar = '\0';
				}
				else if (thisChar != ')') {
					lastConcatChar = thisChar;
				}
			}

			//Console.putln("lastChar = ", thisChar);
			lastChar = thisChar;

			regexPos++;
		}

		foreach(state; current) {
			isolate(state);
			state.accept = true;
		}

		Console.putln("Done");
		State.printall();

		return startState;
	}

	State concat(State start, dchar transition, ref State to, bool doNotUnroll = false) {
		if (to !is null) {
			Console.putln(start.id, " to ", to.id);
		}
		else {
			Console.putln(start.id, " to null");
		}

		if ((to is null) || (to.id > start.id)) {
			if (!doNotUnroll) {
				isolate(start);
				unroll(start);
				isolate(start);
			}
		}

		if (transition in start.transitions) {
			return start.transitions[transition];
		}
		else {
			if (to is null) {
				to = new State();
			}
			start.transitions[transition] = to;
		}

		return to;
	}

	void unroll(State state) {
		Console.putln("unrolling ", state.id);
		foreach(backwardTrans; state.backwardList) {
			State newState = new State();
			State destState = state.transitions[backwardTrans];

			state.transitions[backwardTrans] = newState;
			foreach(transition; destState.transitions.keys) {
				State toState = destState.transitions[transition];
				newState.transitions[transition] = toState;
				newState.backwardList.add(transition);
				Link link = new Link();
				link.from = newState;
				link.transition = transition;
				toState.incomingList.add(link);
/*
				if (toState is state) {
					Link link = new Link();
					link.from = newState;
					link.transition = transition;
					state.incomingList.add(link);
				}
*/
			}
		}
		state.backwardList = new List!(dchar);
	}

	void isolate(State state) {
		Console.putln("isolating ", state.id);
		foreach(link; state.incomingList) {
			unroll(link.from);
		}
		state.incomingList = new List!(Link);
	}

	public static void test() {
	}

	static void my_unroll(State state, dchar chr) {
	}

	// Common

	static string[][Thread] regexRefs;
	static uint[Thread] regexPos;

	// For backtracking regex operations

	struct GroupInfo {
		int startPos;
		int endPos;
		int strStartPos;
		int strPos;
		int parent;
		int unionPos;
		int groupId;
	}

	struct RegexInfo {

		// This hash table contains information about a grouping
		// for a specific position in the regex.
		GroupInfo[int] groupInfo;

		// This hash table contains information that aids operators
		// for a specific position in the regex.
		int[int] operatorFlag;

		// This structure hopes to minimize work already done by merely setting
		// a flag whenever a position in each string is reached. Since this
		// denotes that the regex will be parsing from the same state, and the
		// regex is pure, it will not have to repeat the work.
		int[][] memoizer;
	}
}
