/*
 * fontset.d
 *
 * This file holds bindings to pango's pango-fontset.h. The original copyright is
 * displayed below, but does not pertain to this file.
 *
 * Author: Dave Wilkinson
 *
 */

module binding.pango.fontset;

/* Pango
 * pango-fontset.h: Font set handling
 *
 * Copyright (C) 2001 Red Hat Software
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

import binding.pango.coverage;
import binding.pango.types;

import binding.pango.font;
import binding.pango.fontmap;

extern(C):

/*
 * PangoFontset
 */

//#define PANGO_TYPE_FONTSET              (pango_fontset_get_type ())
//#define PANGO_FONTSET(object)           (G_TYPE_CHECK_INSTANCE_CAST ((object), PANGO_TYPE_FONTSET, PangoFontset))
//#define PANGO_IS_FONTSET(object)        (G_TYPE_CHECK_INSTANCE_TYPE ((object), PANGO_TYPE_FONTSET))

GType pango_fontset_get_type () ;

alias _PangoFontset        PangoFontset;

/**
 * PangoFontsetForeachFunc
 * @fontset: a #PangoFontset
 * @font: a font from @fontset
 * @data: callback data
 *
 * A callback function used by pango_fontset_foreach() when enumerating
 * the fonts in a fontset.
 *
 * Returns: if %TRUE, stop iteration and return immediately.
 *
 * Since: 1.4
 **/

alias gboolean function(PangoFontset*, PangoFont*, gpointer) PangoFontsetForeachFunc;

PangoFont *       pango_fontset_get_font    (PangoFontset           *fontset,
					     guint                   wc);

PangoFontMetrics *pango_fontset_get_metrics (PangoFontset           *fontset);

void              pango_fontset_foreach     (PangoFontset           *fontset,
					     PangoFontsetForeachFunc func,
					     gpointer                data);


alias _PangoFontsetClass   PangoFontsetClass;

//#define PANGO_FONTSET_CLASS(klass)      (G_TYPE_CHECK_CLASS_CAST ((klass), PANGO_TYPE_FONTSET, PangoFontsetClass))
//#define PANGO_IS_FONTSET_CLASS(klass)   (G_TYPE_CHECK_CLASS_TYPE ((klass), PANGO_TYPE_FONTSET))
//#define PANGO_FONTSET_GET_CLASS(obj)    (G_TYPE_INSTANCE_GET_CLASS ((obj), PANGO_TYPE_FONTSET, PangoFontsetClass))

struct _PangoFontset
{
  GObject parent_instance;
}

struct _PangoFontsetClass
{
  GObjectClass parent_class;

  /*< public >*/

  PangoFont *       (*get_font)     (PangoFontset     *fontset,
				     guint             wc);

  PangoFontMetrics *(*get_metrics)  (PangoFontset     *fontset);
  PangoLanguage *   (*get_language) (PangoFontset     *fontset);
  void              (*pango_foreach)      (PangoFontset           *fontset,
				     PangoFontsetForeachFunc func,
				     gpointer                data);

  /*< private >*/

  /* Padding for future expansion */
  void (*_pango_reserved1) ();
  void (*_pango_reserved2) ();
  void (*_pango_reserved3) ();
  void (*_pango_reserved4) ();
};

/*
 * PangoFontsetSimple
 */

//#define PANGO_TYPE_FONTSET_SIMPLE       (pango_fontset_simple_get_type ())
//#define PANGO_FONTSET_SIMPLE(object)    (G_TYPE_CHECK_INSTANCE_CAST ((object), PANGO_TYPE_FONTSET_SIMPLE, PangoFontsetSimple))
//#define PANGO_IS_FONTSET_SIMPLE(object) (G_TYPE_CHECK_INSTANCE_TYPE ((object), PANGO_TYPE_FONTSET_SIMPLE))

extern(C) struct _PangoFontsetSimple;
extern(C) struct _PangoFontsetSimpleClass;

alias _PangoFontsetSimple  PangoFontsetSimple;
alias _PangoFontsetSimpleClass  PangoFontsetSimpleClass;

GType pango_fontset_simple_get_type () ;

PangoFontsetSimple * pango_fontset_simple_new    (PangoLanguage      *language);
void                 pango_fontset_simple_append (PangoFontsetSimple *fontset,
						  PangoFont          *font);

int                  pango_fontset_simple_size   (PangoFontsetSimple *fontset);
