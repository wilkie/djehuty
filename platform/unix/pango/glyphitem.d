/*
 * glyphitem.d
 *
 * This file holds bindings to pango's pango-glyphitem.h. The original
 * copyright is displayed below, but does not pertain to this file.
 *
 * Author: Dave Wilkinson
 *
 */

module platform.unix.pango.glyphitem;

/* Pango
 * pango-glyph-item.h: Pair of PangoItem and a glyph string
 *
 * Copyright (C) 2002 Red Hat Software
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


import platform.unix.pango.types;

import platform.unix.pango.attributes;
import platform.unix.pango.pbreak;
import platform.unix.pango.item;
import platform.unix.pango.glyph;

alias _PangoGlyphItem PangoGlyphItem;

extern(C):

struct _PangoGlyphItem
{
  PangoItem        *item;
  PangoGlyphString *glyphs;
}

PangoGlyphItem *pango_glyph_item_split        (PangoGlyphItem *orig,
					       char     *text,
					       int             split_index);
void            pango_glyph_item_free         (PangoGlyphItem *glyph_item);
GSList *        pango_glyph_item_apply_attrs  (PangoGlyphItem *glyph_item,
					       char     *text,
					       PangoAttrList  *list);
void            pango_glyph_item_letter_space (PangoGlyphItem *glyph_item,
					       char     *text,
					       PangoLogAttr   *log_attrs,
					       int             letter_spacing);
