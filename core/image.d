/*
 * image.d
 *
 * This file contains the magic behind Image.
 *
 * Author: Dave Wilkinson
 *
 */

module core.image;

import interfaces.stream;

import core.string;
import core.view;
import core.file;

import synch.semaphore;

// import the codec information
import codecs.image.codec;
import codecs.image.all;

import console.main;

// Section: Core/Resources

// Description: This class will wrap a DIB view object and load into this view an image file as long as it has a decoder.  So far, I have BMP, PNG, and GIF (animated as well).  Animated Images are supported, but you will have to load them a frame at a time.
class Image
{
public:

	this()
	{
		//_loaded = new Semaphore();
		//_loaded.init(1);
	}

	this(String filename)
	{
		load(filename);
	}

	this(string filename)
	{
		load(filename);
	}

	// Description: Will load the image.  It will throw the file to all the available decoders with a preference to the ones that match the file extension.  When the decoder accepts the file, it will return true, otherwise on error it will return false.
	// filename: The filename to open as an image.
	// Returns: Will return true when the file is accepted and the image is loaded.
	bool load(String filename)
	{
		FileReader f = new FileReader();
		_view = new View();

		if (f.open(filename) == false)
		{
			return false;
		}

		return _stream(f) == StreamData.Accepted;
	}

	// Description: Will load the image.  It will throw the file to all the available decoders with a preference to the ones that match the file extension.  When the decoder accepts the file, it will return true, otherwise on error it will return false.
	// filename: The filename to open as an image.
	// Returns: Will return true when the file is accepted and the image is loaded.
	bool load(string filename)
	{
		FileReader f = new FileReader();
		_view = new View();

		if (f.open(filename) == false)
		{
			return false;
		}

		return _stream(f) == StreamData.Accepted;
	}

	// Description: Will load the image from a valid stream.  Use this to open an image from within a file or from a network socket.  The decoders support progressive images already and are developed with this in mind.  You do not need to send a complete stream as images can be rendered by chunks.  The function will return information on the stream's acceptance.
	// stream: The stream to read as an image.
	// Returns: Describes the current state of the stream decoding.  If it is StreamData.Invalid, then the stream cannot be decoded.  If it is StreamData.Required, then more data is required to render the stream, and only a partial image is available.  If it is StreamData.Accepted, then the stream has been decoded successfully and the image is available.
	StreamData load(AbstractStream stream)
	{
		return _stream(stream);
	}

	// Description: Will return the width of the loaded image.
	// Returns: The width of the image.
	uint getWidth()
	{
		return _view.getWidth();
	}

	// Description: Will return the height of the loaded image.
	// Returns: The height of the image.
	uint getHeight()
	{
		return _view.getHeight();
	}

	// Description: This function will return the view object associated with this image.
	// Returns: A View object.
	View getView()
	{
		return _view;
	}

	// Description: This function will return the currently used ImageCodec, if available.
	// Returns: The ImageCodec being used.
	ImageCodec getCodec()
	{
		return _curCodec;
	}

protected:

	View _view;

	bool _hasMultipleFrames;
	ImageFrameDescription _imageFrameDesc;

	ImageCodec _curCodec;

	//Semaphore _loaded;

	StreamData _stream(AbstractStream stream)
	{
		StreamData ret = StreamData.Invalid;

		_view = new View();

		if (_curCodec is null)
		{
			ret = runAllCodecs(_curCodec, stream, _view);
		}
		else
		{
			ret = _curCodec.decode(stream, _view);
		}

		return ret;
	}
}

void ImageLock(ref Image img)
{
	//img._loaded.down();
}

void ImageUnlock(ref Image img)
{
	//img._loaded.up();
}
