/*
 * cairo.d
 *
 * This file holds bindings to pango's pangocairo.h. The original copyright
 * is displayed below, but does not pertain to this file.
 *
 * Author: Dave Wilkinson
 *
 */

module binding.pango.cairo;

/* Pango
 * pangocairo.h:
 *
 * Copyright (C) 1999, 2004 Red Hat, Inc.
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Library General Public
 * License as published by the Free Software Foundation; either
 * version 2 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.	 See the GNU
 * Library General Public License for more details.
 *
 * You should have received a copy of the GNU Library General Public
 * License along with this library; if not, write to the
 * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
 * Boston, MA 02111-1307, USA.
 */

import binding.pango.types;

import binding.pango.context;
import binding.pango.fontmap;
import binding.pango.layout;
import binding.pango.glyph;

import binding.cairo.cairo;


/**
 * PangoCairoFontMap:
 *
 * #PangoCairoFontMap is an interface exported by font maps for
 * use with Cairo. The actual type of the font map will depend
 * on the particular font technology Cairo was compiled to use.
 *
 * Since: 1.10
 **/

//#define PANGO_TYPE_CAIRO_FONT_MAP       (pango_cairo_font_map_get_type ())
//#define PANGO_CAIRO_FONT_MAP(object)    (G_TYPE_CHECK_INSTANCE_CAST ((object), PANGO_TYPE_CAIRO_FONT_MAP, PangoCairoFontMap))
//#define PANGO_IS_CAIRO_FONT_MAP(object) (G_TYPE_CHECK_INSTANCE_TYPE ((object), PANGO_TYPE_CAIRO_FONT_MAP))

extern(C) struct _PangoCairoFontMap;
alias _PangoCairoFontMap      PangoCairoFontMap;

/*
 * PangoCairoFontMap
 */

extern(C):

GType         pango_cairo_font_map_get_type    ();

PangoFontMap *pango_cairo_font_map_new         ();
PangoFontMap *pango_cairo_font_map_get_default ();

void          pango_cairo_font_map_set_resolution (PangoCairoFontMap *fontmap,
						   double             dpi);
double        pango_cairo_font_map_get_resolution (PangoCairoFontMap *fontmap);
PangoContext *pango_cairo_font_map_create_context (PangoCairoFontMap *fontmap);

/* Update a Pango context for the current state of a cairo context
 */
void         pango_cairo_update_context (cairo_t      *cr,
					 PangoContext *context);

void                        pango_cairo_context_set_font_options (PangoContext               *context,
								  cairo_font_options_t *options);
cairo_font_options_t *pango_cairo_context_get_font_options (PangoContext               *context);

void               pango_cairo_context_set_resolution     (PangoContext       *context,
							   double              dpi);
double             pango_cairo_context_get_resolution     (PangoContext       *context);

/* Convenience
 */
PangoLayout *pango_cairo_create_layout (cairo_t     *cr);
void         pango_cairo_update_layout (cairo_t     *cr,
					PangoLayout *layout);

/*
 * Rendering
 */
void pango_cairo_show_glyph_string (cairo_t          *cr,
				    PangoFont        *font,
				    PangoGlyphString *glyphs);
void pango_cairo_show_layout_line  (cairo_t          *cr,
				    PangoLayoutLine  *line);
void pango_cairo_show_layout       (cairo_t          *cr,
				    PangoLayout      *layout);

void pango_cairo_show_error_underline (cairo_t       *cr,
				       double         x,
				       double         y,
				       double         width,
				       double         height);

/*
 * Rendering to a path
 */
void pango_cairo_glyph_string_path (cairo_t          *cr,
				    PangoFont        *font,
				    PangoGlyphString *glyphs);
void pango_cairo_layout_line_path  (cairo_t          *cr,
				    PangoLayoutLine  *line);
void pango_cairo_layout_path       (cairo_t          *cr,
				    PangoLayout      *layout);

void pango_cairo_error_underline_path (cairo_t       *cr,
				       double         x,
				       double         y,
				       double         width,
				       double         height);
