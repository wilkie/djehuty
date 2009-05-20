/*
 * Xrender.d
 *
 * This file holds bindings to Xrender. This file was created from xrender.h
 * which is provided with Xrender proper. The original copyright notice is
 * displayed below, but does not pertain to this file.
 *
 * Author: Dave Wilkinson
 *
 */

module platform.unix.x.Xrender;

/*
 *
 * Copyright © 2000 SuSE, Inc.
 *
 * Permission to use, copy, modify, distribute, and sell this software and its
 * documentation for any purpose is hereby granted without fee, provided that
 * the above copyright notice appear in all copies and that both that
 * copyright notice and this permission notice appear in supporting
 * documentation, and that the name of SuSE not be used in advertising or
 * publicity pertaining to distribution of the software without specific,
 * written prior permission.  SuSE makes no representations about the
 * suitability of this software for any purpose.  It is provided "as is"
 * without express or implied warranty.
 *
 * SuSE DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE, INCLUDING ALL
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS, IN NO EVENT SHALL SuSE
 * BE LIABLE FOR ANY SPECIAL, INDIRECT OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION
 * OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
 * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 *
 * Author:  Keith Packard, SuSE, Inc.
 */

import platform.unix.x.render;

import platform.unix.x.Xlib;

//#include <X11/Xfuncproto.h>
//#include <X11/Xosdefs.h>
//#include <X11/Xutil.h>

struct XRenderDirectFormat {
    short   red;
    short   redMask;
    short   green;
    short   greenMask;
    short   blue;
    short   blueMask;
    short   alpha;
    short   alphaMask;
}

struct XRenderPictFormat {
    PictFormat  id;
    int			type;
    int			depth;
    XRenderDirectFormat	direct;
    Colormap		colormap;
}

enum:uint
{
	PictFormatID	    = (1 << 0);
	PictFormatType	    = (1 << 1);
	PictFormatDepth	    = (1 << 2);
	PictFormatRed	    = (1 << 3);
	PictFormatRedMask   = (1 << 4);
	PictFormatGreen	    = (1 << 5);
	PictFormatGreenMask = (1 << 6);
	PictFormatBlue	    = (1 << 7);
	PictFormatBlueMask  = (1 << 8);
	PictFormatAlpha	    = (1 << 9);
	PictFormatAlphaMask = (1 << 10);
	PictFormatColormap  = (1 << 11);
}

struct XRenderPictureAttributes {
    int 		repeat;
    Picture		alpha_map;
    int			alpha_x_origin;
    int			alpha_y_origin;
    int			clip_x_origin;
    int			clip_y_origin;
    Pixmap		clip_mask;
    Bool		graphics_exposures;
    int			subwindow_mode;
    int			poly_edge;
    int			poly_mode;
    Atom		dither;
    Bool		component_alpha;
}

struct {
    unsigned short   red;
    unsigned short   green;
    unsigned short   blue;
    unsigned short   alpha;
} XRenderColor;

struct XGlyphInfo {
    unsigned short  width;
    unsigned short  height;
    short	    x;
    short	    y;
    short	    xOff;
    short	    yOff;
}

struct XGlyphElt8 {
    GlyphSet		    glyphset;
    _Xconst char	    *chars;
    int			    nchars;
    int			    xOff;
    int			    yOff;
}

struct XGlyphElt16 {
    GlyphSet		    glyphset;
    _Xconst unsigned short  *chars;
    int			    nchars;
    int			    xOff;
    int			    yOff;
}

struct XGlyphElt32 {
    GlyphSet		    glyphset;
    _Xconst uint    *chars;
    int			    nchars;
    int			    xOff;
    int			    yOff;
}

typedef double	XDouble;

struct XPointDouble {
    XDouble  x, y;
}

XFixed XDoubleToFixed(XDouble f)
{
	return cast(XFixed)(f * 65536);
}

XDouble XFixedToDouble(XFixed f)
{
	return cast(XDouble)(f) / cast(XDouble)65536.0;
}

alias int XFixed;

typedef struct XPointFixed {
    XFixed x;
	XFixed y;
}

struct XLineFixed {
    XPointFixed	p1;
	XPointFixed p2;
}

struct XTriangle {
    XPointFixed	p1;
	XPointFixed p2;
	XPointFixed p3;
}

struct XCircle {
    XFixed x;
    XFixed y;
    XFixed radius;
}

struct XTrapezoid {
    XFixed top;
	XFixed bottom;
    XLineFixed left;
	XLineFixed right;
}

struct XTransform {
    XFixed matrix[3][3];
}

struct XFilters {
    int	    nfilter;
    char    **filter;
    int	    nalias;
    short   *alias;
}

struct XIndexValue {
    Culong pixel;
    ushort red;
	ushort green;
	ushort blue;
	ushort alpha;
}

struct XAnimCursor {
    Cursor cursor;
    Culong delay;
}

struct XSpanFix {
    XFixed left;
	XFixed right;
	XFixed y;
}

struct XTrap {
    XSpanFix top;
	XSpanFix bottom;
}

struct XLinearGradient {
    XPointFixed p1;
    XPointFixed p2;
}

struct XRadialGradient {
    XCircle inner;
    XCircle outer;
}

struct XConicalGradient {
    XPointFixed center;
    XFixed angle; /* in degrees */
}

_XFUNCPROTOBEGIN

Bool XRenderQueryExtension (Display *dpy, int *event_basep, int *error_basep);

Status XRenderQueryVersion (Display *dpy,
			    int     *major_versionp,
			    int     *minor_versionp);

Status XRenderQueryFormats (Display *dpy);

int XRenderQuerySubpixelOrder (Display *dpy, int screen);

Bool XRenderSetSubpixelOrder (Display *dpy, int screen, int subpixel);

XRenderPictFormat *
XRenderFindVisualFormat (Display *dpy, _Xconst Visual *visual);

XRenderPictFormat *
XRenderFindFormat (Display			*dpy,
		   Culong		mask,
		   _Xconst XRenderPictFormat	*templ,
		   int				count);

#define PictStandardARGB32  0
#define PictStandardRGB24   1
#define PictStandardA8	    2
#define PictStandardA4	    3
#define PictStandardA1	    4
#define PictStandardNUM	    5

XRenderPictFormat *
XRenderFindStandardFormat (Display		*dpy,
			   int			format);

XIndexValue *
XRenderQueryPictIndexValues(Display			*dpy,
			    _Xconst XRenderPictFormat	*format,
			    int				*num);

Picture
XRenderCreatePicture (Display				*dpy,
		      Drawable				drawable,
		      _Xconst XRenderPictFormat		*format,
		      Culong			valuemask,
		      _Xconst XRenderPictureAttributes	*attributes);

void
XRenderChangePicture (Display				*dpy,
		      Picture				picture,
		      Culong			valuemask,
		      _Xconst XRenderPictureAttributes  *attributes);

void
XRenderSetPictureClipRectangles (Display	    *dpy,
				 Picture	    picture,
				 int		    xOrigin,
				 int		    yOrigin,
				 _Xconst XRectangle *rects,
				 int		    n);

void
XRenderSetPictureClipRegion (Display	    *dpy,
			     Picture	    picture,
			     Region	    r);

void
XRenderSetPictureTransform (Display	    *dpy,
			    Picture	    picture,
			    XTransform	    *transform);

void
XRenderFreePicture (Display                   *dpy,
		    Picture                   picture);

void
XRenderComposite (Display   *dpy,
		  int	    op,
		  Picture   src,
		  Picture   mask,
		  Picture   dst,
		  int	    src_x,
		  int	    src_y,
		  int	    mask_x,
		  int	    mask_y,
		  int	    dst_x,
		  int	    dst_y,
		  unsigned int	width,
		  unsigned int	height);

GlyphSet
XRenderCreateGlyphSet (Display *dpy, _Xconst XRenderPictFormat *format);

GlyphSet
XRenderReferenceGlyphSet (Display *dpy, GlyphSet existing);

void
XRenderFreeGlyphSet (Display *dpy, GlyphSet glyphset);

void
XRenderAddGlyphs (Display		*dpy,
		  GlyphSet		glyphset,
		  _Xconst Glyph		*gids,
		  _Xconst XGlyphInfo	*glyphs,
		  int			nglyphs,
		  _Xconst char		*images,
		  int			nbyte_images);

void
XRenderFreeGlyphs (Display	    *dpy,
		   GlyphSet	    glyphset,
		   _Xconst Glyph    *gids,
		   int		    nglyphs);

void
XRenderCompositeString8 (Display		    *dpy,
			 int			    op,
			 Picture		    src,
			 Picture		    dst,
			 _Xconst XRenderPictFormat  *maskFormat,
			 GlyphSet		    glyphset,
			 int			    xSrc,
			 int			    ySrc,
			 int			    xDst,
			 int			    yDst,
			 _Xconst char		    *string,
			 int			    nchar);

void
XRenderCompositeString16 (Display		    *dpy,
			  int			    op,
			  Picture		    src,
			  Picture		    dst,
			  _Xconst XRenderPictFormat *maskFormat,
			  GlyphSet		    glyphset,
			  int			    xSrc,
			  int			    ySrc,
			  int			    xDst,
			  int			    yDst,
			  _Xconst unsigned short    *string,
			  int			    nchar);

void
XRenderCompositeString32 (Display		    *dpy,
			  int			    op,
			  Picture		    src,
			  Picture		    dst,
			  _Xconst XRenderPictFormat *maskFormat,
			  GlyphSet		    glyphset,
			  int			    xSrc,
			  int			    ySrc,
			  int			    xDst,
			  int			    yDst,
			  _Xconst unsigned int	    *string,
			  int			    nchar);

void
XRenderCompositeText8 (Display			    *dpy,
		       int			    op,
		       Picture			    src,
		       Picture			    dst,
		       _Xconst XRenderPictFormat    *maskFormat,
		       int			    xSrc,
		       int			    ySrc,
		       int			    xDst,
		       int			    yDst,
		       _Xconst XGlyphElt8	    *elts,
		       int			    nelt);

void
XRenderCompositeText16 (Display			    *dpy,
			int			    op,
			Picture			    src,
			Picture			    dst,
			_Xconst XRenderPictFormat   *maskFormat,
			int			    xSrc,
			int			    ySrc,
			int			    xDst,
			int			    yDst,
			_Xconst XGlyphElt16	    *elts,
			int			    nelt);

void
XRenderCompositeText32 (Display			    *dpy,
			int			    op,
			Picture			    src,
			Picture			    dst,
			_Xconst XRenderPictFormat   *maskFormat,
			int			    xSrc,
			int			    ySrc,
			int			    xDst,
			int			    yDst,
			_Xconst XGlyphElt32	    *elts,
			int			    nelt);

void
XRenderFillRectangle (Display		    *dpy,
		      int		    op,
		      Picture		    dst,
		      _Xconst XRenderColor  *color,
		      int		    x,
		      int		    y,
		      unsigned int	    width,
		      unsigned int	    height);

void
XRenderFillRectangles (Display		    *dpy,
		       int		    op,
		       Picture		    dst,
		       _Xconst XRenderColor *color,
		       _Xconst XRectangle   *rectangles,
		       int		    n_rects);

void
XRenderCompositeTrapezoids (Display		*dpy,
			    int			op,
			    Picture		src,
			    Picture		dst,
			    _Xconst XRenderPictFormat	*maskFormat,
			    int			xSrc,
			    int			ySrc,
			    _Xconst XTrapezoid	*traps,
			    int			ntrap);

void
XRenderCompositeTriangles (Display		*dpy,
			   int			op,
			   Picture		src,
			   Picture		dst,
			    _Xconst XRenderPictFormat	*maskFormat,
			   int			xSrc,
			   int			ySrc,
			   _Xconst XTriangle	*triangles,
			   int			ntriangle);

void
XRenderCompositeTriStrip (Display		*dpy,
			  int			op,
			  Picture		src,
			  Picture		dst,
			    _Xconst XRenderPictFormat	*maskFormat,
			  int			xSrc,
			  int			ySrc,
			  _Xconst XPointFixed	*points,
			  int			npoint);

void
XRenderCompositeTriFan (Display			*dpy,
			int			op,
			Picture			src,
			Picture			dst,
			_Xconst XRenderPictFormat	*maskFormat,
			int			xSrc,
			int			ySrc,
			_Xconst XPointFixed	*points,
			int			npoint);

void
XRenderCompositeDoublePoly (Display		    *dpy,
			    int			    op,
			    Picture		    src,
			    Picture		    dst,
			    _Xconst XRenderPictFormat	*maskFormat,
			    int			    xSrc,
			    int			    ySrc,
			    int			    xDst,
			    int			    yDst,
			    _Xconst XPointDouble    *fpoints,
			    int			    npoints,
			    int			    winding);
Status
XRenderParseColor(Display	*dpy,
		  char		*spec,
		  XRenderColor	*def);

Cursor
XRenderCreateCursor (Display	    *dpy,
		     Picture	    source,
		     unsigned int   x,
		     unsigned int   y);

XFilters *
XRenderQueryFilters (Display *dpy, Drawable drawable);

void
XRenderSetPictureFilter (Display    *dpy,
			 Picture    picture,
			 char	    *filter,
			 XFixed	    *params,
			 int	    nparams);

Cursor
XRenderCreateAnimCursor (Display	*dpy,
			 int		ncursor,
			 XAnimCursor	*cursors);


void
XRenderAddTraps (Display	    *dpy,
		 Picture	    picture,
		 int		    xOff,
		 int		    yOff,
		 _Xconst XTrap	    *traps,
		 int		    ntrap);

Picture XRenderCreateSolidFill (Display *dpy,
                                const XRenderColor *color);

Picture XRenderCreateLinearGradient (Display *dpy,
                                     const XLinearGradient *gradient,
                                     const XFixed *stops,
                                     const XRenderColor *colors,
                                     int nstops);

Picture XRenderCreateRadialGradient (Display *dpy,
                                     const XRadialGradient *gradient,
                                     const XFixed *stops,
                                     const XRenderColor *colors,
                                     int nstops);

Picture XRenderCreateConicalGradient (Display *dpy,
                                      const XConicalGradient *gradient,
                                      const XFixed *stops,
                                      const XRenderColor *colors,
                                      int nstops);
