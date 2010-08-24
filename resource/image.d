/*
 * image.d
 *
 * This file contains the magic behind Image.
 *
 * Author: Dave Wilkinson
 *
 */

module resource.image;

import core.stream;
import core.string;
import core.stream;
import core.definitions;

import graphics.bitmap;
import graphics.graphics;

import io.file;
import io.console;

import synch.semaphore;

// import the codec information
import decoders.image.decoder;
import decoders.image.all;

// Section: Core/Resources

// Description: This class will wrap a DIB view object and load into this view an image file
//   as long as it has a decoder.  So far, I have BMP, PNG, and GIF (animated as well).  Animated
//   Images are supported, but you will have to load them a frame at a time.
class Image {
protected:

	Bitmap _view;
	ImageFrameDescription _frameDesc;

	ImageDecoder _curCodec;

	// Information about the frames
	uint _frameCount;
	uint _frameIdx;

	// Whether or not this image has frames
	bool _hasFrames;
	ImageFrameDescription[] _frameDescs;
	Bitmap[] _frames;

	Bitmap _curView;
	ImageFrameDescription _curFrameDesc;

	//Semaphore _loaded;

	StreamData _stream(Stream stream) {
		StreamData ret = StreamData.Invalid;

		if (_curView is null) {
			_curView = new Bitmap(0, 0);
			_curFrameDesc = ImageFrameDescription.init;
		}

		if (!_hasFrames) {
			if (_curCodec is null) {
				ret = runAllDecoders(_curCodec, stream, _curView);
			}
			else {
				ret = _curCodec.decode(stream, _curView);
			}

			if (ret == StreamData.Accepted) {
				// This means the image decoder is indeed the correct choice
				// and that this image contains multiple frames.
				_hasFrames = true;
			}
			else if (ret != StreamData.Invalid) {
				_view = _curView;
			}
		}

		if (_hasFrames) {
			ret = StreamData.Accepted;
			while(ret == StreamData.Accepted) {
				if (_curView is null) {
					_curView = new Bitmap(0, 0);
					_curFrameDesc = ImageFrameDescription.init;
				}
				ret = _curCodec.decodeFrame(stream, _curView, _curFrameDesc);
				if (ret == StreamData.Accepted || ret == StreamData.Complete) {
					// Frame was decoded.
					_frames ~= _curView;
					_frameDescs ~= _curFrameDesc;
					if (_view is null) {
						_view = new Bitmap(_curView.width, _curView.height);
						_view.drawCanvas(_curView, 0, 0);
					}
					_curView = null;
					_frameCount++;
				}
			}

			foreach(ref frameDesc; _frameDescs) {
				frameDesc.time = _curFrameDesc.time;
			}
		}
		_frameDesc = _curFrameDesc;
		return ret;
	}

public:
	this() {
		//_loaded = new Semaphore();
		//_loaded.init(1);
	}

	this(string filename) {
		load(filename);
	}

	// Description: Will load the image.  It will throw the file to all the available decoders
	//   with a preference to the ones that match the file extension.  When the decoder accepts
	//   the file, it will return true, otherwise on error it will return false.
	// filename: The filename to open as an image.
	// Returns: Will return true when the file is accepted and the image is loaded.
	bool load(string filename) {
		File f = File.open(filename);

		if (f is null) {
			return false;
		}

		return _stream(f) == StreamData.Accepted;
	}

	// Description: Will load the image from a valid stream.  Use this to open an image from within
	//   a file or from a network socket.  The decoders support progressive images already and are
	//   developed with this in mind.  You do not need to send a complete stream as images can be
	//   rendered by chunks.  The function will return information on the stream's acceptance.
	// stream: The stream to read as an image.
	// Returns: Describes the current state of the stream decoding.  If it is StreamData.Invalid,
	//   then the stream cannot be decoded.  If it is StreamData.Required, then more data is required
	//   to render the stream, and only a partial image is available.  If it is StreamData.Accepted,
	//   then the stream has been decoded successfully and the image is available.
	StreamData load(Stream stream) {
		return _stream(stream);
	}

	// Description: Will return the width of the loaded image.
	// Returns: The width of the image.
	uint width() {
		return _view.width;
	}

	// Description: Will return the height of the loaded image.
	// Returns: The height of the image.
	uint height() {
		return _view.height;
	}

	// Description: This function will return the view object associated with this image.
	// Returns: The view that can be manipulated.
	Bitmap canvas() {
		return _view;
	}

	// Description: This function will return the currently used ImageDecoder, if available.
	// Returns: The ImageDecoder being used.
	ImageDecoder codec() {
		return _curCodec;
	}

	uint numFrames() {
		if (!_hasFrames) {
			return 1;
		}
		return _frameCount;
	}

	uint frame() {
		if (!_hasFrames) {
			return 0;
		}
		return _frameIdx;
	}

	void frame(uint value) {
		if (!_hasFrames) {
			return;
		}

		if (value > this.numFrames) {
			if (this.numFrames == 0) {
				value = 0;
			}
			else {
				value = this.numFrames - 1;
			}
		}
		_frameIdx = value;
		_view = _frames[_frameIdx];
		_frameDesc = _frameDescs[_frameIdx];
	}

	ImageFrameDescription frameDescription() {
		return _frameDesc;
	}

	void next() {
		uint lastFrame = _frameIdx;
		_frameIdx = (_frameIdx + 1) % this.numFrames;
		if (lastFrame == _frameIdx) { return; }
		_frameDesc = _frameDescs[_frameIdx];

		if (_view !is null) {
			// Update view, if necessary
			if (_frameDesc.clearFirst) {
				_view.brush = new Brush(_frameDesc.clearColor);
				_view.fillRectangle(0,0,_view.width,_view.height);
			}
			_view.drawCanvas(_frames[_frameIdx], _frameDesc.xoffset, _frameDesc.yoffset);
			_view.drawCanvas(_frames[_frameIdx], _frameDesc.xoffset, _frameDesc.yoffset);
		}
		else {
			_view = _frames[_frameIdx];
		}
	}
}