/*
 * condition.d
 *
 * This module implements a conditional wait object.
 *
 * Author: Dave Wilkinson
 * Originated: December 4th, 2009
 *
 */

module synch.condition;

import platform.vars.mutex;
import platform.vars.condition;

import scaffold.thread;

import synch.mutex;

class Condition {
	this() {
		ConditionInit(_pfvars);
	}

	void signal() {
		ConditionSignal(_pfvars);
	}

	void wait() {
		ConditionWait(_pfvars);
	}

package:

	void wait(ref MutexPlatformVars mutexVars) {
		ConditionWait(_pfvars, mutexVars);
	}

	ConditionPlatformVars _pfvars;
}

interface Waitable {
	Condition waitCondition();
}