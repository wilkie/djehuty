/*
 * font.d
 *
 * This file holds bindings to pango's pango-font.h.
 *
 * Author: Dave Wilkinson
 *
 */

module platform.unix.pango.font;

//extern(C) struct _PangoFontDescription;
//extern(C) struct _PangoFontMetrics;


enum PangoStyle {
  PANGO_STYLE_NORMAL,
  PANGO_STYLE_OBLIQUE,
  PANGO_STYLE_ITALIC
}

enum PangoVariant {
  PANGO_VARIANT_NORMAL,
  PANGO_VARIANT_SMALL_CAPS
}

enum PangoWeight {
  PANGO_WEIGHT_ULTRALIGHT = 200,
  PANGO_WEIGHT_LIGHT = 300,
  PANGO_WEIGHT_NORMAL = 400,
  PANGO_WEIGHT_SEMIBOLD = 600,
  PANGO_WEIGHT_BOLD = 700,
  PANGO_WEIGHT_ULTRABOLD = 800,
  PANGO_WEIGHT_HEAVY = 900
}

enum PangoStretch {
  PANGO_STRETCH_ULTRA_CONDENSED,
  PANGO_STRETCH_EXTRA_CONDENSED,
  PANGO_STRETCH_CONDENSED,
  PANGO_STRETCH_SEMI_CONDENSED,
  PANGO_STRETCH_NORMAL,
  PANGO_STRETCH_SEMI_EXPANDED,
  PANGO_STRETCH_EXPANDED,
  PANGO_STRETCH_EXTRA_EXPANDED,
  PANGO_STRETCH_ULTRA_EXPANDED
}

enum PangoFontMask {
  PANGO_FONT_MASK_FAMILY  = (1 << 0),
  PANGO_FONT_MASK_STYLE   = (1 << 1),
  PANGO_FONT_MASK_VARIANT = (1 << 2),
  PANGO_FONT_MASK_WEIGHT  = (1 << 3),
  PANGO_FONT_MASK_STRETCH = (1 << 4),
  PANGO_FONT_MASK_SIZE    = (1 << 5),
  PANGO_FONT_MASK_GRAVITY = (1 << 6)
}

import platform.unix.pango.types;
import platform.unix.pango.gravity;
import platform.unix.pango.types;
import platform.unix.pango.coverage;

extern(C) struct _PangoFontDescription;

alias _PangoFontDescription PangoFontDescription;
alias _PangoFontMetrics PangoFontMetrics;

/**
 * PangoStyle:
 * @PANGO_STYLE_NORMAL: the font is upright.
 * @PANGO_STYLE_OBLIQUE: the font is slanted, but in a roman style.
 * @PANGO_STYLE_ITALIC: the font is slanted in an italic style.
 *
 * An enumeration specifying the various slant styles possible for a font.
 **/

/* CSS scale factors (1.2 factor between each size) */
const auto PANGO_SCALE_XX_SMALL = (cast(double)0.5787037037037);
const auto PANGO_SCALE_X_SMALL  = (cast(double)0.6444444444444);
const auto PANGO_SCALE_SMALL    = (cast(double)0.8333333333333);
const auto PANGO_SCALE_MEDIUM   = (cast(double)1.0);
const auto PANGO_SCALE_LARGE    = (cast(double)1.2);
const auto PANGO_SCALE_X_LARGE  = (cast(double)1.4399999999999);
const auto PANGO_SCALE_XX_LARGE = (cast(double)1.728);

/*
 * PangoFontDescription
 */

GType PANGO_TYPE_FONT_DESCRIPTION()
{
	return pango_font_description_get_type();
}

extern(C):
GType                 pango_font_description_get_type    ();
PangoFontDescription *pango_font_description_new         ();
PangoFontDescription *pango_font_description_copy        (PangoFontDescription  *desc);
PangoFontDescription *pango_font_description_copy_static (PangoFontDescription  *desc);
guint                 pango_font_description_hash        (PangoFontDescription  *desc);
gboolean              pango_font_description_equal       (PangoFontDescription  *desc1,
							  PangoFontDescription  *desc2);
void                  pango_font_description_free        (PangoFontDescription        *desc);
void                  pango_font_descriptions_free       (PangoFontDescription       **descs,
							  int                          n_descs);

void                 pango_font_description_set_family        (PangoFontDescription *desc,
							       char           *family);
void                 pango_font_description_set_family_static (PangoFontDescription *desc,
							       char           *family);
char* pango_font_description_get_family        (PangoFontDescription *desc);

void                 pango_font_description_set_style         (PangoFontDescription *desc,
							       PangoStyle            style);
PangoStyle           pango_font_description_get_style         (PangoFontDescription *desc);
void                 pango_font_description_set_variant       (PangoFontDescription *desc,
							       PangoVariant          variant);
PangoVariant         pango_font_description_get_variant       (PangoFontDescription *desc);
void                 pango_font_description_set_weight        (PangoFontDescription *desc,
							       PangoWeight           weight);
PangoWeight          pango_font_description_get_weight        (PangoFontDescription *desc);
void                 pango_font_description_set_stretch       (PangoFontDescription *desc,
							       PangoStretch          stretch);
PangoStretch         pango_font_description_get_stretch       (PangoFontDescription *desc);
void                 pango_font_description_set_size          (PangoFontDescription *desc,
							       gint                  size);
gint                 pango_font_description_get_size          (PangoFontDescription *desc);
void                 pango_font_description_set_absolute_size (PangoFontDescription *desc,
							       double                size);
gboolean             pango_font_description_get_size_is_absolute (PangoFontDescription *desc);
void                 pango_font_description_set_gravity       (PangoFontDescription *desc,
							       PangoGravity          gravity);
PangoGravity         pango_font_description_get_gravity       (PangoFontDescription *desc);

PangoFontMask pango_font_description_get_set_fields (PangoFontDescription *desc);
void          pango_font_description_unset_fields   (PangoFontDescription       *desc,
						     PangoFontMask               to_unset);

void pango_font_description_merge        (PangoFontDescription       *desc,
					  PangoFontDescription *desc_to_merge,
					  gboolean                    replace_existing);

void pango_font_description_merge_static (PangoFontDescription       *desc,
					  PangoFontDescription *desc_to_merge,
					  gboolean                    replace_existing);

gboolean pango_font_description_better_match (PangoFontDescription *desc,
					      PangoFontDescription *old_match,
					      PangoFontDescription *new_match);

PangoFontDescription *pango_font_description_from_string (char                  *str);
char *                pango_font_description_to_string   (PangoFontDescription  *desc);
char *                pango_font_description_to_filename (PangoFontDescription  *desc);

/*
 * PangoFontMetrics
 */

GType PANGO_TYPE_FONT_METRICS()
{
	return pango_font_metrics_get_type();
}

GType             pango_font_metrics_get_type                    ();
PangoFontMetrics *pango_font_metrics_ref                         (PangoFontMetrics *metrics);
void              pango_font_metrics_unref                       (PangoFontMetrics *metrics);
int               pango_font_metrics_get_ascent                  (PangoFontMetrics *metrics);
int               pango_font_metrics_get_descent                 (PangoFontMetrics *metrics);
int               pango_font_metrics_get_approximate_char_width  (PangoFontMetrics *metrics);
int               pango_font_metrics_get_approximate_digit_width (PangoFontMetrics *metrics);
int               pango_font_metrics_get_underline_position      (PangoFontMetrics *metrics);
int               pango_font_metrics_get_underline_thickness     (PangoFontMetrics *metrics);
int               pango_font_metrics_get_strikethrough_position  (PangoFontMetrics *metrics);
int               pango_font_metrics_get_strikethrough_thickness (PangoFontMetrics *metrics);




PangoFontMetrics *pango_font_metrics_new ();

struct _PangoFontMetrics
{
  guint ref_count;

  int ascent;
  int descent;
  int approximate_char_width;
  int approximate_digit_width;
  int underline_position;
  int underline_thickness;
  int strikethrough_position;
  int strikethrough_thickness;
};

/*
 * PangoFontFamily
 */

//#define PANGO_FONT_FAMILY(object)           (G_TYPE_CHECK_INSTANCE_CAST ((object), PANGO_TYPE_FONT_FAMILY, PangoFontFamily))
//#define PANGO_IS_FONT_FAMILY(object)        (G_TYPE_CHECK_INSTANCE_TYPE ((object), PANGO_TYPE_FONT_FAMILY))

GType PANGO_TYPE_FONT_FAMILY ()
{
	return pango_font_family_get_type();
}

alias _PangoFontFamily      PangoFontFamily;
alias _PangoFontFace        PangoFontFace;

GType      pango_font_family_get_type();

void pango_font_family_list_faces (PangoFontFamily  *family,
						   PangoFontFace  ***faces,
						   int              *n_faces);

char *pango_font_family_get_name   (PangoFontFamily  *family);

gboolean   pango_font_family_is_monospace         (PangoFontFamily  *family);


//#define PANGO_FONT_FAMILY_CLASS(klass)      (G_TYPE_CHECK_CLASS_CAST ((klass), PANGO_TYPE_FONT_FAMILY, PangoFontFamilyClass))
//#define PANGO_IS_FONT_FAMILY_CLASS(klass)   (G_TYPE_CHECK_CLASS_TYPE ((klass), PANGO_TYPE_FONT_FAMILY))
//#define PANGO_FONT_FAMILY_GET_CLASS(obj)    (G_TYPE_INSTANCE_GET_CLASS ((obj), PANGO_TYPE_FONT_FAMILY, PangoFontFamilyClass))

alias _PangoFontFamilyClass PangoFontFamilyClass;

struct _PangoFontFamily
{
  GObject parent_instance;
};

struct _PangoFontFamilyClass
{
  GObjectClass parent_class;

  /*< public >*/

  void function(PangoFontFamily *family, PangoFontFace*** faces, int* n_faces) list_faces;

  const char* function(PangoFontFamily* family) get_name;

  gboolean function(PangoFontFamily* family) is_monospace;

  /*< private >*/

  /* Padding for future expansion */
  void function() _pango_reserved2;
  void function() _pango_reserved3;
  void function() _pango_reserved4;

};

/*
 * PangoFontFace
 */

//#define PANGO_TYPE_FONT_FACE              (pango_font_face_get_type ())
//#define PANGO_FONT_FACE(object)           (G_TYPE_CHECK_INSTANCE_CAST ((object), PANGO_TYPE_FONT_FACE, PangoFontFace))
//#define PANGO_IS_FONT_FACE(object)        (G_TYPE_CHECK_INSTANCE_TYPE ((object), PANGO_TYPE_FONT_FACE))

GType      pango_font_face_get_type();

PangoFontDescription* pango_font_face_describe       (PangoFontFace *face);

char* pango_font_face_get_face_name (PangoFontFace* face);

void pango_font_face_list_sizes     (PangoFontFace  *face,
						      int           **sizes,
						      int            *n_sizes);


//#define PANGO_FONT_FACE_CLASS(klass)      (G_TYPE_CHECK_CLASS_CAST ((klass), PANGO_TYPE_FONT_FACE, PangoFontFaceClass))
//#define PANGO_IS_FONT_FACE_CLASS(klass)   (G_TYPE_CHECK_CLASS_TYPE ((klass), PANGO_TYPE_FONT_FACE))
//#define PANGO_FONT_FACE_GET_CLASS(obj)    (G_TYPE_INSTANCE_GET_CLASS ((obj), PANGO_TYPE_FONT_FACE, PangoFontFaceClass))

alias _PangoFontFaceClass   PangoFontFaceClass;

struct _PangoFontFace
{
  GObject parent_instance;
};

struct _PangoFontFaceClass
{
  GObjectClass parent_class;

  /*< public >*/

  const char* function(PangoFontFace* face) get_face_name;
  PangoFontDescription* function(PangoFontFace* face) describe;
  void function(PangoFontFace* face, int** sizes, int* n_sizes) list_sizes;

  /*< private >*/

  /* Padding for future expansion */
  void function() _pango_reserved2;
  void function() _pango_reserved3;
  void function() _pango_reserved4;
};

/*
 * PangoFont
 */

//#define PANGO_TYPE_FONT              (pango_font_get_type ())
//#define PANGO_FONT(object)           (G_TYPE_CHECK_INSTANCE_CAST ((object), PANGO_TYPE_FONT, PangoFont))
//#define PANGO_IS_FONT(object)        (G_TYPE_CHECK_INSTANCE_TYPE ((object), PANGO_TYPE_FONT))

GType                 pango_font_get_type          ();

PangoFontDescription *pango_font_describe          (PangoFont        *font);

PangoFontDescription *pango_font_describe_with_absolute_size (PangoFont        *font);

PangoCoverage *       pango_font_get_coverage      (PangoFont        *font,
						    PangoLanguage    *language);

PangoEngineShape *    pango_font_find_shaper       (PangoFont        *font,
						    PangoLanguage    *language,
						    guint32           ch);

PangoFontMetrics *    pango_font_get_metrics       (PangoFont        *font,
						    PangoLanguage    *language);

void                  pango_font_get_glyph_extents (PangoFont        *font,
						    PangoGlyph        glyph,
						    PangoRectangle   *ink_rect,
						    PangoRectangle   *logical_rect);

PangoFontMap         *pango_font_get_font_map      (PangoFont        *font);


//#define PANGO_FONT_CLASS(klass)      (G_TYPE_CHECK_CLASS_CAST ((klass), PANGO_TYPE_FONT, PangoFontClass))
//#define PANGO_IS_FONT_CLASS(klass)   (G_TYPE_CHECK_CLASS_TYPE ((klass), PANGO_TYPE_FONT))
//#define PANGO_FONT_GET_CLASS(obj)    (G_TYPE_INSTANCE_GET_CLASS ((obj), PANGO_TYPE_FONT, PangoFontClass))

alias _PangoFontClass       PangoFontClass;

struct _PangoFont
{
  GObject parent_instance;
}

struct _PangoFontClass
{
  GObjectClass parent_class;

  /*< public >*/

  PangoFontDescription *(*describe)           (PangoFont      *font);
  PangoCoverage *       (*get_coverage)       (PangoFont      *font,
					       PangoLanguage  *lang);
  PangoEngineShape *    (*find_shaper)        (PangoFont      *font,
					       PangoLanguage  *lang,
					       guint32         ch);
  void                  (*get_glyph_extents)  (PangoFont      *font,
					       PangoGlyph      glyph,
					       PangoRectangle *ink_rect,
					       PangoRectangle *logical_rect);
  PangoFontMetrics *    (*get_metrics)        (PangoFont      *font,
					       PangoLanguage  *language);
  PangoFontMap *        (*get_font_map)       (PangoFont      *font);
  PangoFontDescription *(*describe_absolute)  (PangoFont      *font);
  /*< private >*/

  /* Padding for future expansion */
  void (*_pango_reserved1) ();
  void (*_pango_reserved2) ();
}

/* used for very rare and miserable situtations that we cannot even
 * draw a hexbox
 */
const auto PANGO_UNKNOWN_GLYPH_WIDTH = 10;
const auto PANGO_UNKNOWN_GLYPH_HEIGHT = 14;

const auto PANGO_GLYPH_EMPTY           = (cast(PangoGlyph)0x0FFFFFFF);
const auto PANGO_GLYPH_UNKNOWN_FLAG    = (cast(PangoGlyph)0x10000000);
//const auto PANGO_GET_UNKNOWN_GLYPH(wc) = (cast(PangoGlyph)(wc)|PANGO_GLYPH_UNKNOWN_FLAG);

