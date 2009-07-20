/*
 * types.d
 *
 * This file holds bindings to pango's types.h.
 *
 * Author: Dave Wilkinson
 *
 */

module binding.pango.types;

enum PangoDirection {
  PANGO_DIRECTION_LTR,
  PANGO_DIRECTION_RTL,
  PANGO_DIRECTION_TTB_LTR,
  PANGO_DIRECTION_TTB_RTL,
  PANGO_DIRECTION_WEAK_LTR,
  PANGO_DIRECTION_WEAK_RTL,
  PANGO_DIRECTION_NEUTRAL
}

alias uint GType;
alias uint guint;
alias uint gulong;
alias int gboolean;
alias int gint;
alias int glong;
alias byte gint8;
alias ubyte guint8;
alias short gint16;
alias ushort guint16;
alias uint guint32;
alias int gint32;
alias char gchar;
alias ubyte guchar;
alias char gunichar;
alias void* gpointer;
alias long gint64;
alias ulong guint64;
alias float gfloat;
alias double gdouble;
alias void* gconstpointer;

alias void            (*GDestroyNotify)       (gpointer       data);

extern(C) struct _GData;

extern(C):

alias _GData           GData;

alias _GList GList;

struct _GList
{
  gpointer data;
  GList *next;
  GList *prev;
}

alias _GObject GObject;

struct _GObject
{
  GTypeInstance  g_type_instance;

  /*< private >*/
  guint ref_count;
  GData *qdata;
};

alias guint32 GQuark;

alias _GError GError;

struct _GError
{
  GQuark       domain;
  gint         code;
  gchar       *message;
}

alias _GTypeClass GTypeClass;

struct _GTypeClass
{
  /*< private >*/
  GType g_type;
}

alias _GTypeModule GTypeModule;

struct _GTypeModule
{
  GObject parent_instance;

  guint use_count;
  GSList *type_infos;
  GSList *interface_infos;

  /*< public >*/
  gchar *name;
}

alias _GValue GValue;


  union _GValue_un {
    gint	v_int;
    guint	v_uint;
    glong	v_long;
    gulong	v_ulong;
    gint64      v_int64;
    guint64     v_uint64;
    gfloat	v_float;
    gdouble	v_double;
    gpointer	v_pointer;
  }

struct _GValue
{
  /*< private >*/
  GType		g_type;

  /* public for GTypeValueTable methods */
  _GValue_un data[2];
}

alias _GParamSpec GParamSpec;

enum GParamFlags
{
  G_PARAM_READABLE            = 1 << 0,
  G_PARAM_WRITABLE            = 1 << 1,
  G_PARAM_CONSTRUCT	      = 1 << 2,
  G_PARAM_CONSTRUCT_ONLY      = 1 << 3,
  G_PARAM_LAX_VALIDATION      = 1 << 4,
  G_PARAM_STATIC_NAME	      = 1 << 5,
  G_PARAM_STATIC_NICK	      = 1 << 6,
  G_PARAM_STATIC_BLURB	      = 1 << 7
} ;

struct _GParamSpec
{
  GTypeInstance  g_type_instance;

  gchar         *name;
  GParamFlags    flags;
  GType		 value_type;
  GType		 owner_type;	/* class or interface using this property */

  /*< private >*/
  gchar         *_nick;
  gchar         *_blurb;
  GData		*qdata;
  guint          ref_count;
  guint		 param_id;	/* sort-criteria */
}

alias _GObjectConstructParam GObjectConstructParam;

struct _GObjectConstructParam
{
  GParamSpec *pspec;
  GValue     *value;
}

alias _GTypeInstance GTypeInstance;

struct _GTypeInstance
{
  /*< private >*/
  GTypeClass *g_class;
}

alias _GSList GSList;

struct _GSList
{
  gpointer data;
  GSList *next;
}

alias _GObjectClass GObjectClass;

struct  _GObjectClass
{
  GTypeClass   g_type_class;

  /*< private >*/
  GSList      *construct_properties;

  /*< public >*/
  /* overridable methods */
  GObject*   (*constructor)     (GType                  type,
                                 guint                  n_construct_properties,
                                 GObjectConstructParam *construct_properties);
  void       (*set_property)		(GObject        *object,
                                         guint           property_id,
                                         GValue   *value,
                                         GParamSpec     *pspec);
  void       (*get_property)		(GObject        *object,
                                         guint           property_id,
                                         GValue         *value,
                                         GParamSpec     *pspec);
  void       (*dispose)			(GObject        *object);
  void       (*finalize)		(GObject        *object);

  /* seldomly overidden */
  void       (*dispatch_properties_changed) (GObject      *object,
					     guint	   n_pspecs,
					     GParamSpec  **pspecs);

  /* signals */
  void	     (*notify)			(GObject	*object,
					 GParamSpec	*pspec);
  /*< private >*/
  /* padding */
  gpointer	pdummy[8];
};

/* Pango
 * pango-types.h:
 *
 * Copyright (C) 1999 Red Hat Software
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

import binding.pango.engine;
import binding.pango.pbreak;
import binding.pango.font;
import binding.pango.fontmap;

alias _PangoLogAttr PangoLogAttr;

alias _PangoEngineLang PangoEngineLang;
alias _PangoEngineShape PangoEngineShape;

alias _PangoFont    PangoFont;
alias _PangoFontMap PangoFontMap;

alias _PangoRectangle PangoRectangle;



/* A index of a glyph into a font. Rendering system dependent */
typedef guint32 PangoGlyph;

void        g_object_unref                    (gpointer        object);


const auto PANGO_SCALE = 1024;

int PANGO_PIXELS(int d)
{
	return (d + 512) >> 10;
}

int PANGO_PIXELS_FLOOR(int d)
{
	return (d) >> 10;
}

int PANGO_PIXELS_CEIL(int d)
{
	return (d + 1023) >> 10;
}

/* The above expressions are just slightly wrong for floating point d;
 * For example we'd expect PANGO_PIXELS(-512.5) => -1 but instead we get 0.
 * That's unlikely to matter for practical use and the expression is much
 * more compact and faster than alternatives that work exactly for both
 * integers and floating point.
 */

int    pango_units_from_double (double d) ;
double pango_units_to_double (int i) ;


/* Dummy typedef - internally it's a 'const char *' */
extern(C) struct _PangoLanguage;
alias _PangoLanguage PangoLanguage;

//#define PANGO_TYPE_LANGUAGE (pango_language_get_type ())

GType          pango_language_get_type    ();
PangoLanguage *pango_language_from_string (char *language);

//#define pango_language_to_string(language) ((const char *)language)

char *pango_language_get_sample_string (PangoLanguage *language);

PangoLanguage *pango_language_get_default ();

gboolean      pango_language_matches  (PangoLanguage *language,
				       char *range_list);



/* A rectangle. Used to store logical and physical extents of glyphs,
 * runs, strings, etc.
 */
struct _PangoRectangle
{
  int x;
  int y;
  int width;
  int height;
}

/* Macros to translate from extents rectangles to ascent/descent/lbearing/rbearing
 */

int PANGO_ASCENT(_PangoRectangle rect)
{
	return -rect.y;
}

int PANGO_DESCENT(_PangoRectangle rect)
{
	return rect.y + rect.height;
}

int PANGO_LBEARING(_PangoRectangle rect)
{
	return rect.x;
}

int PANGO_RBEARING(_PangoRectangle rect)
{
	return rect.x + rect.width;
}

void pango_extents_to_pixels (PangoRectangle *ink_rect,
			      PangoRectangle *logical_rect);

/**
 * PangoDirection:
 * @PANGO_DIRECTION_LTR: A strong left-to-right direction
 * @PANGO_DIRECTION_RTL: A strong right-to-left direction
 * @PANGO_DIRECTION_TTB_LTR: Deprecated value; treated the
 *   same as %PANGO_DIRECTION_RTL.
 * @PANGO_DIRECTION_TTB_RTL: Deprecated value; treated the
 *   same as %PANGO_DIRECTION_LTR
 * @PANGO_DIRECTION_WEAK_LTR: A weak left-to-right direction
 * @PANGO_DIRECTION_WEAK_RTL: A weak right-to-left direction
 * @PANGO_DIRECTION_NEUTRAL: No direction specified
 *
 * The #PangoDirection type represents a direction in the
 * Unicode bidirectional algorithm; not every value in this
 * enumeration makes sense for every usage of #PangoDirection;
 * for example, the return value of pango_unichar_direction()
 * and pango_find_base_dir() cannot be %PANGO_DIRECTION_WEAK_LTR
 * or %PANGO_DIRECTION_WEAK_RTL, since every character is either
 * neutral or has a strong direction; on the other hand
 * %PANGO_DIRECTION_NEUTRAL doesn't make sense to pass
 * to pango_itemize_with_base_dir().
 *
 * The %PANGO_DIRECTION_TTB_LTR, %PANGO_DIRECTION_TTB_RTL
 * values come from an earlier interpretation of this
 * enumeration as the writing direction of a block of
 * text and are no longer used; See #PangoGravity for how
 * vertical text is handled in Pango.
 **/

PangoDirection pango_unichar_direction      (gunichar     ch);

PangoDirection pango_find_base_dir          (gchar *text,
					     gint         length);


gboolean       pango_get_mirror_char        (gunichar     ch,
					     gunichar    *mirrored_ch);
