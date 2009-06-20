/*
 * event.d
 *
 * This module implements the event dispatching mechanism.
 *
 */

module core.event;

// Description: This class represents an object that can dispatch signals.
class Dispatcher {

	void OnPush(Responder rsp) {
	}

	// Description: This function will set the responder that will receive
	//	signals raised by this class.
	// rsp: The class that will respond to the signal.
	void setResponder(Responder rsp) {
		responder = rsp;
	}

protected:

	Responder responder;

	// Description: This function will emit a signal to the Responder that
	//	is listening to this Dispatcher.
	// signal: The identifier for the signal.
	// Returns: Will return true when the signal was handled.
	bool raiseSignal(uint signal) {
		if (responder !is null) {
			// Raise the event on the Responder, if it does not respond,
			// tell the Responder to pass the event up the responder
			// chain.
			if (!responder.OnSignal(this, signal)) {
				// recursively raise the event
				return responder.raiseSignal(signal);
			}
		}
		return true;
	}
}

// Description: This class represents an object that can respond to signals.
class Responder : Dispatcher {
public:

	bool OnSignal(Dispatcher dispatcher, uint signal) {
		return false;
	}
	
	// Description: This function will attach the specified Dispatcher to this
	//	Responder. It fires an OnPush event for the Dispatcher as well.
	void push(Dispatcher dsp) {
		dsp.setResponder(this);
		dsp.OnPush(this);
	}
}