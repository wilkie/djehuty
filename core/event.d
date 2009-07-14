/*
 * event.d
 *
 * This module implements the event dispatching mechanism.
 *
 */

module core.event;

// Description: This class represents an object that can dispatch signals.
class Dispatcher {

	void onPush(Responder rsp) {
	}

	// Description: This function will set the responder that will receive
	//	signals raised by this class.
	// rsp: The class that will respond to the signal.
	void responder(Responder rsp) {
		_responder = rsp;
	}
	
	Responder responder() {
		return _responder;
	}

protected:

	// Description: This function will emit a signal to the Responder that
	//	is listening to this Dispatcher.
	// signal: The identifier for the signal.
	// Returns: Will return true when the signal was handled.
	bool raiseSignal(uint signal) {
		if (_responder !is null) {
			// Raise the event on the Responder, if it does not respond,
			// tell the Responder to pass the event up the responder
			// chain.
			if (!_responder.onSignal(this, signal)) {
				// recursively raise the event
				return _responder.raiseSignal(signal);
			}
		}
		return true;
	}
	
private:

	Responder _responder;
}

// Description: This class represents an object that can respond to signals.
class Responder : Dispatcher {
public:

	bool onSignal(Dispatcher dispatcher, uint signal) {
		return false;
	}
	
	// Description: This function will attach the specified Dispatcher to this
	//	Responder. It fires an onPush event for the Dispatcher as well.
	void push(Dispatcher dsp) {
		dsp.responder = this;
		dsp.onPush(this);
	}
}