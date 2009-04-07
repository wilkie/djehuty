module opengl.texture;

import opengl.gl;

import core.image;
import core.string;
import core.view;

// Section: OpenGL

// Description: This class implements an interface for an OpenGL texture.
class Texture
{

	// Description: This constructor will create a texture out of the image passed in. Optionally, it can divide the image up into equal sized frames.
	// filename: The name of the image to load.
	// frameRows: The number of rows contained in the image.
	// frameCols: The number of columns contained in the image.
	this(StringLiteral filename, int frameRows = 1, int frameCols = 1)
	{
		_img = new Image();

		_img.load(filename);

		View view = _img.getView();

		void* bytes;
		ulong len;

		view.lockBuffer(&bytes, len);
		view.unlockBuffer();

		glGenTextures(1, &_gl_tex_index);
		glBindTexture(GL_TEXTURE_2D, _gl_tex_index);

		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);

	    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, _img.getWidth(), _img.getHeight(), 0, GL_BGRA_EXT, GL_UNSIGNED_BYTE, bytes);

		_frows = frameRows;
		_fcols = frameCols;

		_fw = _img.getWidth() / _fcols;
		_fh = _img.getHeight() / _frows;
	}

	// Description: This function will return the texture's width.
	// Returns: The width of the texture.
	int getWidth()
	{
		return _img.getWidth();
	}

	// Description: This function will return the texture's height.
	// Returns: The height of the texture.
	int getHeight()
	{
		return _img.getHeight();
	}

	// Description: This function will return the number of frames that are contained in this texture.
	// Returns: This returns the equivalent of getFrameRows * getFrameColumns
	int getFrameCount()
	{
		return _frows * _fcols;
	}

	// Description: This function will return the number of frames within each individual column.
	// Returns: The number of rows represented within the texture.
	int getFrameRows()
	{
		return _frows;
	}

	// Description: This function will return the number of frames within each individual row.
	// Returns: The number of columns represented within the texture.
	int getFrameColumns()
	{
		return _fcols;
	}

	// Description: This function will return the width of a frame.
	// Returns: The width of a single frame.
	int getFrameWidth()
	{
		return _fw;
	}

	// Description: This function will return the height of a frame.
	// Returns: The height of a single frame.
	int getFrameHeight()
	{
		return _fh;
	}

	// Description: Returns the texture index as specified by OpenGL upon creation of the texture.
	// Returns: The texture index.
	GLuint getTextureIndex()
	{
		return _gl_tex_index;
	}

protected:

	Image _img;

	int _frows;
	int _fcols;

	int _fw;
	int _fh;

    GLuint _gl_tex_index;
}
