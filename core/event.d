/*
 * event.d
 *
 * This module implements the event dispatching mechanism.
 *
 */

module core.event;

alias bool delegate(Dispatcher dsp, uint signal) SignalHandler;

// Description: This class represents an object that can dispatch signals.
class Dispatcher : Object {
private:

	Responder _responder;
	SignalHandler _handler;

public:
	// Description: This function will emit a signal to the Responder that
	//	is listening to this Dispatcher.
	// signal: The identifier for the signal.
	// Returns: Will return true when the signal was handled.
	bool raiseSignal(uint signal) {
		if (_responder !is null) {
			// Raise the event on the Responder, if it does not respond,
			// tell the Responder to pass the event up the responder
			// chain.
			if (!_handler(this, signal)) {
				// recursively raise the event
				return _responder.raiseSignal(signal);
			}
		}
		return true;
	}

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

	void handler(SignalHandler value) {
		_handler = value;
	}

	SignalHandler handler() {
		return _handler;
	}
}

// Description: This class represents an object that can respond to signals.
class Responder : Dispatcher {
public:

	bool onSignal(Dispatcher dispatcher, uint signal) {
		return false;
	}

	// Description: This function will attach the specified Dispatcher to this
	//	Responder. It fires an onPush event for the Dispatcher as well.
	void push(Dispatcher dsp, SignalHandler handler = null) {
		dsp.responder = this;
		if (handler is null) {
			handler = &onSignal;
		}
		dsp.handler = handler;
		dsp.onPush(this);
	}
}
